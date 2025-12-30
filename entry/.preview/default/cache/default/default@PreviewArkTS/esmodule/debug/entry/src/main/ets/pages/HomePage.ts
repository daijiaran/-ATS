if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface HomePage_Params {
    inputValue?: string;
    calValue?: string;
    expressions?: Array<string>;
}
import Logger from "@bundle:com.example.simplecalculator/entry/ets/common/util/Logger";
import CalculateUtil from "@bundle:com.example.simplecalculator/entry/ets/common/util/CalculateUtil";
import CheckEmptyUtil from "@bundle:com.example.simplecalculator/entry/ets/common/util/CheckEmptyUtil";
import keysModel from "@bundle:com.example.simplecalculator/entry/ets/viewmodel/PresskeysViewModel";
import type { PressKeysBean } from '../viewmodel/PressKeysItem';
import { CommonConstants, Symbol } from "@bundle:com.example.simplecalculator/entry/ets/common/constants/CommonConstants";
class HomePage extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__inputValue = new ObservedPropertySimplePU('', this, "inputValue");
        this.__calValue = new ObservedPropertySimplePU('', this, "calValue");
        this.expressions = [];
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: HomePage_Params) {
        if (params.inputValue !== undefined) {
            this.inputValue = params.inputValue;
        }
        if (params.calValue !== undefined) {
            this.calValue = params.calValue;
        }
        if (params.expressions !== undefined) {
            this.expressions = params.expressions;
        }
    }
    updateStateVars(params: HomePage_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__inputValue.purgeDependencyOnElmtId(rmElmtId);
        this.__calValue.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__inputValue.aboutToBeDeleted();
        this.__calValue.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    // @State 装饰器变量变化会触发 UI 刷新
    private __inputValue: ObservedPropertySimplePU<string>; // 显示在输入框的完整表达式字符串
    get inputValue() {
        return this.__inputValue.get();
    }
    set inputValue(newValue: string) {
        this.__inputValue.set(newValue);
    }
    private __calValue: ObservedPropertySimplePU<string>; // 显示在下方的计算结果预览
    get calValue() {
        return this.__calValue.get();
    }
    set calValue(newValue: string) {
        this.__calValue.set(newValue);
    }
    // 核心数据结构：存储表达式的数组。例如 ["12", "+", "5"]
    private expressions: Array<string>;
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/HomePage.ets(38:5)", "entry");
            Column.height(CommonConstants.FULL_PERCENT);
            Column.backgroundColor({ "id": 16777250, "type": 10001, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 1. 输入显示区域
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/HomePage.ets(40:7)", "entry");
            // 1. 输入显示区域
            Column.width(CommonConstants.FULL_PERCENT);
            // 1. 输入显示区域
            Column.height({ "id": 16777227, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" });
            // 1. 输入显示区域
            Column.alignItems(HorizontalAlign.End);
            // 1. 输入显示区域
            Column.margin({
                right: { "id": 16777228, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" },
                top: { "id": 16777229, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" }
            });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            TextInput.create({ text: this.resultFormat(this.inputValue) });
            TextInput.debugLine("entry/src/main/ets/pages/HomePage.ets(41:9)", "entry");
            TextInput.height(CommonConstants.FULL_PERCENT);
            TextInput.fontSize((this.inputValue.length > CommonConstants.INPUT_LENGTH_MAX) ? { "id": 16777226, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" } : { "id": 16777225, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" });
            TextInput.enabled(false);
            TextInput.fontColor(Color.Black);
            TextInput.textAlign(TextAlign.End);
            TextInput.backgroundColor({ "id": 16777252, "type": 10001, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" });
        }, TextInput);
        // 1. 输入显示区域
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 2. 结果预览显示区域
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/HomePage.ets(62:7)", "entry");
            // 2. 结果预览显示区域
            Column.width(CommonConstants.FULL_PERCENT);
            // 2. 结果预览显示区域
            Column.height({ "id": 16777236, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" });
            // 2. 结果预览显示区域
            Column.alignItems(HorizontalAlign.End);
            // 2. 结果预览显示区域
            Column.margin({
                right: { "id": 16777238, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" },
                bottom: { "id": 16777237, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" }
            });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.resultFormat(this.calValue));
            Text.debugLine("entry/src/main/ets/pages/HomePage.ets(63:9)", "entry");
            Text.fontSize({ "id": 16777226, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" });
            Text.fontColor({ "id": 16777255, "type": 10001, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" });
        }, Text);
        Text.pop();
        // 2. 结果预览显示区域
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 3. 键盘区域
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/HomePage.ets(76:7)", "entry");
            // 3. 键盘区域
            Column.layoutWeight(1);
            // 3. 键盘区域
            Column.width(CommonConstants.FULL_PERCENT);
            // 3. 键盘区域
            Column.backgroundColor({ "id": 16777253, "type": 10001, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/pages/HomePage.ets(77:9)", "entry");
            Row.height(CommonConstants.FULL_PERCENT);
            Row.alignItems(VerticalAlign.Top);
            Row.margin({
                left: { "id": 16777233, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" },
                right: { "id": 16777234, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" }
            });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 遍历 ViewModel 中的列数据
            ForEach.create();
            const forEachItemGenFunction = (_item, columnItemIndex?: number) => {
                const columnItem = _item;
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Column.create();
                    Column.debugLine("entry/src/main/ets/pages/HomePage.ets(80:13)", "entry");
                    Column.layoutWeight(1);
                    Column.margin({
                        top: { "id": 16777235, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" },
                        bottom: { "id": 16777232, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" }
                    });
                }, Column);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    // 遍历每一列中的按键
                    ForEach.create();
                    const forEachItemGenFunction = (_item, keyItemIndex?: number) => {
                        const keyItem = _item;
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            Column.create();
                            Column.debugLine("entry/src/main/ets/pages/HomePage.ets(83:17)", "entry");
                            Column.layoutWeight(((columnItemIndex === (keysModel.getPressKeys().length - 1)) &&
                                (keyItemIndex === (columnItem.length - 1))) ? CommonConstants.TWO : 1);
                            Column.width(CommonConstants.FULL_PERCENT);
                            Column.justifyContent(FlexAlign.Center);
                        }, Column);
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            Column.create();
                            Column.debugLine("entry/src/main/ets/pages/HomePage.ets(84:19)", "entry");
                            Column.width({ "id": 16777231, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" });
                            Column.height(((columnItemIndex === (keysModel.getPressKeys().length - 1)) &&
                                (keyItemIndex === (columnItem.length - 1))) ? { "id": 16777222, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" } : { "id": 16777230, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" });
                            Column.borderWidth(1);
                            Column.borderColor({ "id": 16777249, "type": 10001, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" });
                            Column.borderRadius({ "id": 16777221, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" });
                            Column.backgroundColor(((columnItemIndex === (keysModel.getPressKeys().length - 1)) &&
                                (keyItemIndex === (columnItem.length - 1))) ? { "id": 16777251, "type": 10001, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" } : Color.White);
                            Column.alignItems(HorizontalAlign.Center);
                            Column.justifyContent(FlexAlign.Center);
                            Column.onClick(() => {
                                // 点击事件分发
                                if (keyItem.flag === 0) {
                                    this.inputSymbol(keyItem.value); // 处理符号/功能键
                                }
                                else {
                                    this.inputNumber(keyItem.value); // 处理数字键
                                }
                            });
                        }, Column);
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            If.create();
                            // 根据 flag 判断渲染图片还是文本
                            if (keyItem.flag === 0) {
                                this.ifElseBranchUpdateFunction(0, () => {
                                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                                        Image.create(keyItem.source !== undefined ? keyItem.source : '');
                                        Image.debugLine("entry/src/main/ets/pages/HomePage.ets(87:23)", "entry");
                                        Image.width(keyItem.width);
                                        Image.height(keyItem.height);
                                    }, Image);
                                });
                            }
                            else {
                                this.ifElseBranchUpdateFunction(1, () => {
                                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                                        Text.create(keyItem.value);
                                        Text.debugLine("entry/src/main/ets/pages/HomePage.ets(91:23)", "entry");
                                        Text.fontSize((keyItem.value === CommonConstants.DOTS) ? { "id": 16777224, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" } : { "id": 16777226, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" });
                                        Text.width(keyItem.width);
                                        Text.height(keyItem.height);
                                    }, Text);
                                    Text.pop();
                                });
                            }
                        }, If);
                        If.pop();
                        Column.pop();
                        Column.pop();
                    };
                    this.forEachUpdateFunction(elmtId, columnItem, forEachItemGenFunction, (keyItem: PressKeysBean) => JSON.stringify(keyItem), true, false);
                }, ForEach);
                // 遍历每一列中的按键
                ForEach.pop();
                Column.pop();
            };
            this.forEachUpdateFunction(elmtId, keysModel.getPressKeys(), forEachItemGenFunction, (item: Array<Array<PressKeysBean>>) => JSON.stringify(item), true, false);
        }, ForEach);
        // 遍历 ViewModel 中的列数据
        ForEach.pop();
        Row.pop();
        // 3. 键盘区域
        Column.pop();
        Column.pop();
    }
    /**
     * 处理符号/功能键输入 (AC, DEL, =, +, -, ×, ÷)
     *
     * @param value 输入的符号逻辑值
     */
    inputSymbol(value: string) {
        if (CheckEmptyUtil.isEmpty(value)) {
            return;
        }
        let len = this.expressions.length;
        switch (value) {
            case Symbol.CLEAN: // 清除键 (AC)
                this.expressions = [];
                this.calValue = '';
                break;
            case Symbol.DEL: // 删除键
                this.inputDelete(len);
                break;
            case Symbol.EQU: // 等于键
                if (len === 0) {
                    return;
                }
                // 调用计算结果
                this.getResult().then((result: boolean) => {
                    if (!result) {
                        return;
                    }
                    // 计算成功后，将结果作为下一次运算的起始值
                    this.inputValue = this.calValue;
                    this.calValue = '';
                    this.expressions = [];
                    this.expressions.push(this.inputValue);
                });
                break;
            default: // 普通运算符 (+, -, ×, ÷)
                this.inputOperators(len, value);
                break;
        }
        this.formatInputValue(); // 刷新 UI 显示
    }
    /**
     * 处理数字输入
     *
     * @param value 输入的数字字符
     */
    inputNumber(value: string) {
        if (CheckEmptyUtil.isEmpty(value)) {
            return;
        }
        let len = this.expressions.length;
        let last = len > 0 ? this.expressions[len - 1] : '';
        // 获取倒数第二个元素，用于判断是否应该拼接数字
        let secondLast = len > 1 ? this.expressions[len - CommonConstants.TWO] : undefined;
        // 校验输入是否合法 (例如防止重复小数点)
        if (!this.validateEnter(last, value)) {
            return;
        }
        // 逻辑：决定是追加字符还是新增数组元素
        if (!last) {
            // 数组为空，直接推入
            this.expressions.push(value);
        }
        else if (!secondLast) {
            // 只有一项 (如 "12")，追加 (变成 "123")
            this.expressions[len - 1] += value;
        }
        if (secondLast && CalculateUtil.isSymbol(secondLast)) {
            // 如果倒数第二项是符号 (如 "1" "+" "2")，则在最后一项上追加
            this.expressions[len - 1] += value;
        }
        if (secondLast && !CalculateUtil.isSymbol(secondLast)) {
            // 这种情况比较少见，可能是逻辑保护，视为新数字
            this.expressions.push(value);
        }
        this.formatInputValue(); // 更新显示
        // 每次输入数字后，尝试实时计算预览结果
        if (value !== CommonConstants.DOTS) {
            this.getResult();
        }
    }
    /**
     * 输入合法性校验
     *
     * @param last 数组中最后一个元素
     * @param value 当前试图输入的字符
     * @return boolean 是否允许输入
     */
    validateEnter(last: string, value: string) {
        // 刚开始不能直接输入 %
        if (!last && value === CommonConstants.PERCENT_SIGN) {
            return false;
        }
        // 减号后面不能直接跟 %
        if ((last === CommonConstants.MIN) && (value === CommonConstants.PERCENT_SIGN)) {
            return false;
        }
        // 如果已经有 %，不能连着输
        if (last.endsWith(CommonConstants.PERCENT_SIGN)) {
            return false;
        }
        // 防止一个数字里出现两个小数点
        if ((last.indexOf(CommonConstants.DOTS) !== -1) && (value === CommonConstants.DOTS)) {
            return false;
        }
        // 如果当前是0，只能接小数点或%，不能接其他数字变成 05
        if ((last === '0') && (value !== CommonConstants.DOTS) &&
            (value !== CommonConstants.PERCENT_SIGN)) {
            return false;
        }
        return true;
    }
    /**
     * 删除键 (Del) 逻辑
     *
     * @param len 当前表达式数组长度
     */
    inputDelete(len: number) {
        if (len === 0) {
            return;
        }
        let last = this.expressions[len - 1];
        let lastLen = last.length;
        if (lastLen === 1) {
            // 如果当前项只有1位，直接移除该项
            this.expressions.pop();
            len = this.expressions.length;
        }
        else {
            // 否则移除字符串的最后一位
            this.expressions[len - 1] = last.slice(0, last.length - 1);
        }
        // 如果删空了，重置所有状态
        if (len === 0) {
            this.inputValue = '';
            this.calValue = '';
            return;
        }
        // 如果删完后最后一个不是符号（是数字），尝试重新计算结果
        if (!CalculateUtil.isSymbol(this.expressions[len - 1])) {
            this.getResult();
        }
    }
    /**
     * 运算符输入处理逻辑
     * 处理运算符替换、负号逻辑等
     *
     * @param len 表达式长度
     * @param value 当前输入的运算符
     */
    inputOperators(len: number, value: string) {
        let last = len > 0 ? this.expressions[len - 1] : undefined;
        let secondLast = len > 1 ? this.expressions[len - CommonConstants.TWO] : undefined;
        // 场景：空数组直接按减号，视为负号
        if (!last && (value === Symbol.MIN)) {
            this.expressions.push(this.getSymbol(value));
            return;
        }
        if (!last) {
            return;
        }
        // 如果上一项是数字，直接推入新运算符
        if (!CalculateUtil.isSymbol(last)) {
            this.expressions.push(this.getSymbol(value));
            return;
        }
        // 场景：运算符替换或负号逻辑
        // 如果输入的是减号，且上一个是减号或加号，这里做了一个特殊的替换逻辑
        if ((value === Symbol.MIN) &&
            (last === CommonConstants.MIN || last === CommonConstants.ADD)) {
            this.expressions.pop();
            this.expressions.push(this.getSymbol(value));
            return;
        }
        if (!secondLast) {
            return;
        }
        // 运算符替换逻辑：如果连续按运算符，通常是用新的替换旧的
        if (value !== Symbol.MIN) {
            this.expressions.pop();
        }
        if (CalculateUtil.isSymbol(secondLast)) {
            this.expressions.pop();
        }
        this.expressions.push(this.getSymbol(value));
    }
    /**
     * 将枚举/逻辑符号转换为实际显示的符号
     *
     * @param value 逻辑符号
     * @return 显示符号 (+, -, ×, ÷)
     */
    getSymbol(value: string) {
        if (CheckEmptyUtil.isEmpty(value)) {
            return '';
        }
        let symbol = '';
        switch (value) {
            case Symbol.ADD:
                symbol = CommonConstants.ADD;
                break;
            case Symbol.MIN:
                symbol = CommonConstants.MIN;
                break;
            case Symbol.MUL:
                symbol = CommonConstants.MUL;
                break;
            case Symbol.DIV:
                symbol = CommonConstants.DIV;
                break;
            default:
                break;
        }
        return symbol;
    }
    /**
     * 深拷贝表达式数组
     * 防止计算过程中修改了原始 UI 数据
     *
     * @return 拷贝后的数组
     */
    deepCopy(): Array<string> {
        let copyExpressions: Array<string> = Array.from(this.expressions);
        return copyExpressions;
    }
    /**
     * 获取计算结果 (异步)
     *
     * @return Promise<boolean> 计算是否成功
     */
    async getResult() {
        // 调用工具类解析并计算
        let calResult = CalculateUtil.parseExpression(this.deepCopy());
        if (calResult === 'NaN') {
            this.calValue = this.resourceToString({ "id": 16777241, "type": 10003, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" });
            return false;
        }
        this.calValue = calResult;
        return true;
    }
    /**
     * 结果数值格式化
     * 为数字添加千分位分隔符 (例如 1,000,000)
     *
     * @param value 原始字符串
     * @return 格式化后的字符串
     */
    resultFormat(value: string) {
        // 正则表达式：用于查找需要加逗号的位置
        let reg = (value.indexOf('.') > -1) ? new RegExp("/(\d)(?=(\d{3})+\.)/g") : new RegExp("/(\d)(?=(?:\d{3})+$)/g");
        return value.replace(reg, '$1,');
    }
    /**
     * 辅助方法：将资源对象转为字符串
     *
     * @param resource 资源对象
     * @return 字符串
     */
    resourceToString(resource: Resource): string {
        if (CheckEmptyUtil.isEmpty(resource)) {
            return '';
        }
        let result = '';
        try {
            // 获取 UI 上下文来解析资源
            const uiContext: UIContext | undefined = AppStorage.get('uiContext');
            let context = uiContext!.getHostContext()!;
            result = context.resourceManager.getStringSync(resource.id);
        }
        catch (error) {
            Logger.error('[CalculateModel] getResourceString fail: ' + JSON.stringify(error));
        }
        return result;
    }
    /**
     * 格式化整个输入表达式用于显示
     * 遍历数组，给每个数字部分加上千分位
     */
    formatInputValue() {
        let deepExpressions: Array<string> = [];
        this.deepCopy().forEach((item: string, index: number) => {
            deepExpressions[index] = this.resultFormat(item);
        });
        // 将数组拼接成字符串赋给 inputValue，触发 UI 刷新
        this.inputValue = deepExpressions.join('');
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "HomePage";
    }
}
registerNamedRoute(() => new HomePage(undefined, {}), "", { bundleName: "com.example.simplecalculator", moduleName: "entry", pagePath: "pages/HomePage", pageFullPath: "entry/src/main/ets/pages/HomePage", integratedHsp: "false", moduleType: "followWithHap" });
