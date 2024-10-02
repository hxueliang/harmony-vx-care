import router from '@ohos.router'
import { EcDialogUpload, getUserApi, IUserData, ResManager, RouterConfig } from '@hm/basic'


@Entry
@Component
struct MinePage {
  @State user: IUserData | null = null // 获取用户信息
  @StorageProp('topHeight')
  topHeight: number = 0
  // 上传弹层控制
  uploadDialog: CustomDialogController = new CustomDialogController({
    // 使用自定义弹层组件
    builder: EcDialogUpload({}),
    alignment: DialogAlignment.Bottom
  })

  aboutToAppear(): void {
    this.getUser()
  }

  async getUser() {
    this.user = await getUserApi()
  }

  @Builder
  cellItem(title: string, flag: 0 | 1) {
    Row() {
      Text(title)
        .fontColor(ResManager.EC_MID_19)
        .fontSize(ResManager.EC_MODULE_TITLE_FS)
        .fontWeight(500)
      Row({ space: 10 }) {
        if (flag === 1) {
          // 昵称修改
          Text(this.user?.nickName)
            .fontColor(ResManager.EC_MID_59)
            .fontSize(ResManager.EC_NORMAL_FS)
            .onClick(() => {
              router.pushUrl({
                url: RouterConfig.USER_NAME_URL,
                params: {
                  name: this.user?.nickName
                }
              })
            })
        } else {
          // 上传
          Image(this.user?.avatar ||
            'https://img2.baidu.com/it/u=130573784,2479509663&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=534')
            .width(34)
            .aspectRatio(1)
            .borderRadius(17)
            .onClick(() => {
              this.uploadDialog.open()
            })
        }
        Image($r('app.media.ic_arrow_black'))
          .width(7)
          .height(16)
      }
    }
    .width('100%')
    .padding({ top: 14, bottom: 14 })
    .justifyContent(FlexAlign.SpaceBetween)
  }

  build() {
    Navigation() {
      Column() {
        Column() {
          List() {
            ListItem() {
              this.cellItem('头像', 0)
            }

            ListItem() {
              this.cellItem('昵称', 1)
            }
          }
          .width('100%')
          .height('auto')
          .padding({ left: 14, right: 18, })
          .divider({ strokeWidth: 1, color: ResManager.EC_MID_LINE })
        }
        .margin({
          top: ResManager.EC_CONTENT_SPACE,
          left: ResManager.EC_CONTENT_SPACE,
          right: ResManager.EC_CONTENT_SPACE
        })
        // .width('100%')
        .backgroundColor('#fff')
        .borderRadius(ResManager.EC_NORMAL_RD)
      }
      .width('100%')
      .height('100%')
      .backgroundColor(ResManager.EC_MID_BG)
    }
    .title('个人设置')
    .padding({ top: this.topHeight })
    .titleMode(NavigationTitleMode.Mini)
  }
}