import type AbilityConstant from "@ohos:app.ability.AbilityConstant";
import UIAbility from "@ohos:app.ability.UIAbility";
import type Want from "@ohos:app.ability.Want";
import type { UIContext as UIContext } from "@ohos:arkui.UIContext";
import type window from "@ohos:window";
import hilog from "@ohos:hilog";
/**
 * EntryAbility 是应用的入口类，继承自 UIAbility。
 * 负责处理应用的生命周期事件和加载主界面。
 */
export default class EntryAbility extends UIAbility {
    /**
     * 当 Ability 首次被创建时触发。
     * @param want 包含了启动 Ability 的相关信息（如参数、意图等）。
     * @param launchParam 启动参数。
     */
    onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
        // 打印日志，标记 Ability 已创建
        hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    }
    /**
     * 当 Ability 被销毁时触发。
     * 用于释放系统资源，进行清理工作。
     */
    onDestroy() {
        // 打印日志，标记 Ability 已销毁
        hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
    }
    /**
     * 当窗口管理器（WindowStage）创建完成后触发。
     * 这是设置应用主界面的关键时刻。
     * @param windowStage 窗口管理器，用于管理应用窗口。
     */
    onWindowStageCreate(windowStage: window.WindowStage) {
        // 打印日志，标记窗口阶段已创建
        hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
        // 加载主页面内容
        // 'pages/HomePage' 是页面在 resources/base/profile/main_pages.json 中定义的路径，
        // 对应实际文件 entry/src/main/ets/pages/HomePage.ets
        windowStage.loadContent('pages/HomePage', (err, data) => {
            // 如果加载失败，打印错误日志
            if (err.code) {
                hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
                return;
            }
            // 如果加载成功，打印成功日志
            hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
            // --- 核心逻辑补充 ---
            // 获取当前主窗口的 UIContext (UI上下文)
            // UIContext 提供了访问资源管理器等系统能力的方法
            let uiContext: UIContext | undefined = windowStage.getMainWindowSync().getUIContext();
            // 将 UIContext 存储到全局状态管理 AppStorage 中
            // 键名为 'uiContext'。这样在应用的任何地方（包括工具类文件）都可以通过 AppStorage.get('uiContext') 拿到它。
            // 本项目中主要用于 CalculateUtil 或 HomePage 中解析 Resource 类型的字符串资源。
            AppStorage.setOrCreate('uiContext', uiContext);
        });
    }
    /**
     * 当窗口管理器（WindowStage）被销毁时触发。
     * 通常意味着应用界面不可见或应用正在退出。
     */
    onWindowStageDestroy() {
        // 打印日志，标记窗口阶段已销毁
        hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
    }
    /**
     * 当 Ability 切换到前台（用户可见）时触发。
     * 例如：用户从桌面点击图标打开应用，或从后台切换回应用。
     */
    onForeground() {
        // 打印日志，标记应用进入前台
        hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
    }
    /**
     * 当 Ability 切换到后台（用户不可见）时触发。
     * 例如：用户按了 Home 键回到桌面。
     */
    onBackground() {
        // 打印日志，标记应用进入后台
        hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
    }
}
