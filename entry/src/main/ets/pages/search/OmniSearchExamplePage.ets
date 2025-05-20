import {
  OmniSearchV2,
  SearchContainerModifier,
  SearchTextInputModifier,
  OmniToast
} from "@omni-ui/omni_component"
import { inputMethod } from "@kit.IMEKit"

@Builder
export function OmniSearchExamplePageBuilder() {
  OmniSearchExamplePage()
}

@Component
struct OmniSearchExamplePage {
  build() {
    NavDestination() {

      Column() {
        Text('默认样式').margin({ bottom: 15 })
        OmniSearchV2()

        Text('自定义样式').margin({ bottom: 15, top: 15 })
        OmniSearchV2({
          config: {
            defaultText: '关键字',
            placeHolderText: '请输入想要搜索的内容',
            hasCancelBtn: false,
            hasClearBtn: true,
            hasSearchBtn: true
          },
          textInputModifier: new SearchTextInputModifier()
            .withCaretColor('#FF552E')
            .withBackgroundColor(0xffffff),
          foregroundContainerModifier: new SearchContainerModifier()
            .withHeight(44)
            .withBackgroundColor(0xffffff)
            .withBorderRadius(6)
            .withBorderWidth(1)
            .withBorderColor('#F7F7F7')
            .withShadow({
              radius: 5,
              type: ShadowType.BLUR,
              color: '#F7F7F7'
            })
            .withMargin({
              left: '5%',
              right: '5%',
              top: 10,
              bottom: 10
            }),
          backgroundContainerModifier: new SearchContainerModifier()
            .withWidth('100%')
            .withPadding({
              right: 10
            })
            .withBackgroundColor(0xffffff),
          submitCallback: (searchText) => {
            OmniToast.showText({ msg: `搜索:${searchText}` })
          },
          onCancel: () => {
            OmniToast.showText({ msg: `点击取消按钮` })
          },
          onFocusCallback: () => {
            // OmniToast.showText({ msg: `获取到焦点` })
          },
          onTextChange: (text) => {
            OmniToast.showText({ msg: `输入框内容变化:${text}` })
          }
        })
      }
      .height('100%')
      .onClick(() => {
        // 退出文本编辑状态
        inputMethod.getController().stopInputSession();
      })

    }.title('Search示例')
  }
}