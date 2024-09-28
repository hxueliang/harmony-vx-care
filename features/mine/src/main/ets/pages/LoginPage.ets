import { loginApi, ResManager, UserStore } from '@hm/basic/Index';
import { authentication } from '@kit.AccountKit';
import { util } from '@kit.ArkTS';
import { Log } from '@abner/log';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct LoginPage {
  login() {
    // 创建授权请求，并设置参数
    let authRequest = new authentication.HuaweiIDProvider().createAuthorizationWithHuaweiIDRequest();
    // 获取手机号需要传如下scope，传参数之前需要先申请对应scope权限,才能返回对应数据
    authRequest.scopes = ['phone'];
    // 获取code需传如下permission
    authRequest.permissions = ['serviceauthcode'];
    // 用户是否需要登录授权，该值为true且用户未登录或未授权时，会拉起用户登录或授权页面
    authRequest.forceAuthorization = true;
    // 用于防跨站点请求伪造，非空字符串即可
    authRequest.state = util.generateRandomUUID();
    // 执行请求
    try {
      let controller = new authentication.AuthenticationController(getContext(this));
      controller.executeRequest(authRequest, async (err, data) => {
        if (err) {
          Log.error(`auth fail,error: ${JSON.stringify(err)}s`);
          return;
        }
        let authorizationWithHuaweiIDResponse = data as authentication.AuthorizationWithHuaweiIDResponse;
        let state = authorizationWithHuaweiIDResponse.state;
        if (state != undefined && authRequest.state != state) {
          Log.error(`auth fail,The state is different: ${JSON.stringify(authorizationWithHuaweiIDResponse)}s`);
          return;
        }
        Log.debug(`auth success: ${JSON.stringify(authorizationWithHuaweiIDResponse)}s`);
        let authorizationWithHuaweiIDCredential = authorizationWithHuaweiIDResponse.data!;
        let code = authorizationWithHuaweiIDCredential.authorizationCode || '';
        // 开发者处理code
        Log.warn(`code: ${code}`)
        /**
         * 获取 clientId 和 clientSecret
         * https://developer.huawei.com/consumer/cn/service/josp/agc/index.html#/myProject/388421841222502313/97458334310914890?appId=5765880207855491419
         */
        const token = await loginApi({
          clientId: '112105819',
          clientSecret: '69fff04cec2487d2283729c57b7fdc2c884fcbd358c756d1e0208abb2f9eb8b7',
          code,
        })
        Log.info(token)
        await UserStore.setUser({ token })
        router.replaceUrl({ url: 'pages/Index' })
      });
    } catch (error) {
      Log.error(`auth failed: ${JSON.stringify(error)}s`);
    }
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
        // app 信息
        Column() {
          Image($r("app.media.pic_login_icon"))
            .width(124)
            .height(76)
            .margin({ bottom: 20 })
          Text() {
            Span('越秀康养')
              .fontColor('#000')
              .fontSize(24)
              .fontWeight(700)
          }
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#fff')

        Button({ stateEffect: true }) {
          Row({ space: 6.5 }) {
            Image(ResManager.IC_HUAWEI)
              .width(24)
              .aspectRatio(1)
            Text('华为登录')
              .fontColor('#fff')
              .fontWeight(500)
              .fontSize(ResManager.EC_MODULE_TITLE_FS)
          }.onClick(async () => {
            // this.login()
            // return
            // 模似登录
            await UserStore.setUser({
              token: 'eyJhbGciOiJIUzI1NiJ9.eyJjdXJyZW50VXNlciI6IntcInVzZXJuYW1lXCI6XCIzNTQyMzQ4NEBxcS5jb21cIixcInBhc3N3b3JkXCI6XCJcIixcIm5pY2tOYW1lXCI6XCLmiqTnkIblkZgxXCIsXCJlbWFpbFwiOlwiMzU0MjM0ODRAcXEuY29tXCIsXCJyZWFsTmFtZVwiOlwi5oqk55CG5ZGYMVwiLFwibW9iaWxlXCI6XCIxODIxMTAyMTg5NlwiLFwic2V4XCI6XCIwXCIsXCJkZXB0Tm9cIjpcIjEwMDAwMTAwNTAwMDAwMFwiLFwicG9zdE5vXCI6XCIxMDAwMDEwMDUwMDMwMDBcIixcImRhdGFTdGF0ZVwiOlwiMFwiLFwiYXZhdGFyXCI6XCJodHRwczovL3lqeS1vc3MtdmlkZW9zLm9zcy1hY2NlbGVyYXRlLmFsaXl1bmNzLmNvbS9ncnp4aHouanBnXCIsXCJpZFwiOjE2NzE0MDMyNTY1MTkwNzgyNzUsXCJjcmVhdGVUaW1lXCI6MTcxNTU2ODM5MDAwMCxcInVwZGF0ZVRpbWVcIjoxNzE1NTY4MzkwMDAwLFwiY3JlYXRlQnlcIjoxNjcxNDAzMjU2NTE5MDc4MTM4fSIsImV4cCI6MTQ2NzU2NTk0Nzd9.8PrMKBNrVVCfcI4DgICxp6oBQGqy46m3oglFQCiKtzw'
            })
            router.replaceUrl({ url: 'pages/Index' })
          })
        }
        .margin({ top: 150 })
        .width(250)
        .height(40)
        .backgroundColor(ResManager.EC_MAIN_COLOR)
      }
    }
    .width('100%')
    .height('100%')
  }
}