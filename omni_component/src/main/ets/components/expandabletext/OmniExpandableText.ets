import { MeasureOptions, MeasureText } from '@kit.ArkUI'
import { OmniTheme, OmniThemeStyle } from '../../theme/OmniTheme'
import { taskpool } from '@kit.ArkTS'

@Component
export struct OmniExpandableText {
  @StorageLink(OmniTheme.KEY)
  private baseStyle: OmniThemeStyle = OmniTheme.getDefaultStyle()
  @State isFold: boolean = true
  @State private showAction: boolean = false
  @Prop content: string = ''
  @Prop maxLine: number = 99
  @State private shadowHeight: Length = 17
  @Prop contentFontColor: ResourceColor = '#43474D'
  @Prop contentFontSize: string | number | Resource = this.baseStyle.fontSizeMd
  @Prop expandFontColor: ResourceColor = '#517A99'
  @Prop expandFontSize: string | number | Resource = this.baseStyle.fontSizeMd
  @Prop foldText: ResourceStr = '收起'
  @Prop expandText: ResourceStr = '展开'

  //特殊处理换行符
  handleBr(rawHtml: string) {
    const brStr = '<br>'
    while (rawHtml.search(brStr) > 0) {
      rawHtml = rawHtml.replace('<br>', `\n`)
    }
    return rawHtml
  }

  /**
   * 返回文本所占布局高度，单位为px
   * @param options
   * @returns
   */
  getTextHeight(options: MeasureOptions) {
    return this.getUIContext().getMeasureUtils().measureTextSize(options).height as number;
  }

  build() {
    Column() {
      Stack() {
        Text(this.handleBr(this.content ?? ''))
          .width('100%')
          .fontColor(this.contentFontColor)
          .fontSize(this.contentFontSize)
          .maxLines(this.isFold ? this.maxLine ?? 99 : 99)
          .onSizeChange((_oldValue: SizeOptions, newValue: SizeOptions) => {
            const textWidth = Number(newValue.width)
            taskpool.execute(handleShowAction, this.content, this.contentFontSize, textWidth, this.maxLine)
              .then(result => {
                const args = result as Object[]
                this.showAction = args[0] as boolean
                this.shadowHeight = args[1] as number
              })
          })

        if (this.showAction == true) {
          Stack() {
            Image('https://wos.58cdn.com.cn/cDazYxWcDHJ/picasso/6udkiul3.png')
              .width(100)
              .height(this.shadowHeight)
              .visibility(this.isFold ? Visibility.Visible : Visibility.Hidden)

            Text(this.isFold ? this.expandText : this.foldText)
              .fontColor(this.expandFontColor)
              .fontSize(this.expandFontSize)
              .onClick(() => {
                this.isFold = !this.isFold
              })
          }.alignContent(Alignment.End)
        }
      }.alignContent(Alignment.BottomEnd)
    }
    .alignItems(HorizontalAlign.Start)
  }
}

@Concurrent
function handleShowAction(
  textContent: string,
  fontSize: number,
  constraintWidth: number,
  maxLines: number
): Object[] {
  const textHeight = MeasureText.measureTextSize({
    textContent: textContent,
    fontSize: fontSize,
    constraintWidth: constraintWidth
  }).height as number

  const textMaxHeight = MeasureText.measureTextSize({
    textContent: textContent,
    fontSize: fontSize,
    constraintWidth: constraintWidth,
    maxLines: maxLines
  }).height as number

  const showAction = textHeight > textMaxHeight
  const shadowHeight = px2vp(MeasureText.measureTextSize({
    textContent: textContent,
    fontSize: fontSize,
    constraintWidth: constraintWidth,
    maxLines: 1
  }).height as number)
  return [showAction, shadowHeight]
}
