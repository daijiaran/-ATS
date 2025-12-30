/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Logger from '../common/util/Logger';
import CalculateUtil from '../common/util/CalculateUtil';
import CheckEmptyUtil from '../common/util/CheckEmptyUtil';
import keysModel from '../viewmodel/PresskeysViewModel';
import { PressKeysBean } from '../viewmodel/PressKeysItem';
import { CommonConstants, Symbol } from '../common/constants/CommonConstants';

/**
 * 计算器主页组件
 * 程序的入口 UI，负责界面渲染和用户交互逻辑分发。
 */
@Entry
@Component
struct HomePage {
  // @State 装饰器变量变化会触发 UI 刷新
  @State inputValue: string = ''; // 显示在输入框的完整表达式字符串
  @State calValue: string = '';   // 显示在下方的计算结果预览

  // 核心数据结构：存储表达式的数组。例如 ["12", "+", "5"]
  private expressions: Array<string> = [];

  build() {
    Column() {
      // 1. 输入显示区域
      Column() {
        TextInput({ text: this.resultFormat(this.inputValue) })
          .height(CommonConstants.FULL_PERCENT)
          // 动态调整字体大小：如果输入过长，缩小字体
          .fontSize(
            (this.inputValue.length > CommonConstants.INPUT_LENGTH_MAX) ?
              $r('app.float.font_size_text') : $r('app.float.font_size_input')
          )
          .enabled(false) // 禁止软键盘弹出，只允许通过计算器按钮输入
          .fontColor(Color.Black)
          .textAlign(TextAlign.End)
          .backgroundColor($r('app.color.input_back_color'))
      }
      .width(CommonConstants.FULL_PERCENT)
      .height($r('app.float.input_height'))
      .alignItems(HorizontalAlign.End)
      .margin({
        right: $r('app.float.input_margin_right'),
        top: $r('app.float.input_margin_top')
      })

      // 2. 结果预览显示区域
      Column() {
        Text(this.resultFormat(this.calValue))
          .fontSize($r('app.float.font_size_text'))
          .fontColor($r('app.color.text_color'))
      }
      .width(CommonConstants.FULL_PERCENT)
      .height($r('app.float.text_height'))
      .alignItems(HorizontalAlign.End)
      .margin({
        right: $r('app.float.text_margin_right'),
        bottom: $r('app.float.text_margin_bottom')
      })

      // 3. 键盘区域
      Column() {
        Row() {
          // 遍历 ViewModel 中的列数据
          ForEach(keysModel.getPressKeys(), (columnItem: Array<PressKeysBean>, columnItemIndex?: number) => {
            Column() {
              // 遍历每一列中的按键
              ForEach(columnItem, (keyItem: PressKeysBean, keyItemIndex?: number) => {
                Column() {
                  Column() {
                    // 根据 flag 判断渲染图片还是文本
                    if (keyItem.flag === 0) {
                      Image(keyItem.source !== undefined ? keyItem.source : '')
                        .width(keyItem.width)
                        .height(keyItem.height)
                    } else {
                      Text(keyItem.value)
                        .fontSize(
                          (keyItem.value === CommonConstants.DOTS) ?
                            $r('app.float.font_size_dot') : $r('app.float.font_size_text')
                        )
                        .width(keyItem.width)
                        .height(keyItem.height)
                    }
                  }
                  .width($r('app.float.key_width'))
                  // 特殊处理：如果是最后一列的最后一个键（等于号），高度可能不同
                  .height(
                    ((columnItemIndex === (keysModel.getPressKeys().length - 1)) &&
                      (keyItemIndex === (columnItem.length - 1))) ?
                      $r('app.float.equals_height') : $r('app.float.key_height')
                  )
                  .borderWidth(1)
                  .borderColor($r('app.color.border_color'))
                  .borderRadius($r('app.float.border_radius'))
                  // 特殊处理：等于号背景色不同
                  .backgroundColor(
                    ((columnItemIndex === (keysModel.getPressKeys().length - 1)) &&
                      (keyItemIndex === (columnItem.length - 1))) ?
                      $r('app.color.equals_back_color') : Color.White
                  )
                  .alignItems(HorizontalAlign.Center)
                  .justifyContent(FlexAlign.Center)

                  //每一个案件的点击事件
                  .onClick(() => {
                    // 点击事件分发
                    if (keyItem.flag === 0) {
                      this.inputSymbol(keyItem.value); // 处理符号/功能键
                    } else {
                      this.inputNumber(keyItem.value); // 处理数字键
                    }
                  })
                }
                // 布局权重：等于号可能占据更多空间
                .layoutWeight(
                  ((columnItemIndex === (keysModel.getPressKeys().length - 1)) &&
                    (keyItemIndex === (columnItem.length - 1))) ? CommonConstants.TWO : 1
                )
                .width(CommonConstants.FULL_PERCENT)
                .justifyContent(FlexAlign.Center)
              }, (keyItem: PressKeysBean) => JSON.stringify(keyItem))
            }
            .layoutWeight(1)
            .margin({
              top: $r('app.float.margin_top'),
              bottom: $r('app.float.margin_bottom')
            })
          }, (item: Array<Array<PressKeysBean>>) => JSON.stringify(item))
        }
        .height(CommonConstants.FULL_PERCENT)
        .alignItems(VerticalAlign.Top)
        .margin({
          left: $r('app.float.margin_left'),
          right: $r('app.float.margin_right')
        })
      }
      .layoutWeight(1)
      .width(CommonConstants.FULL_PERCENT)
      .backgroundColor($r('app.color.row_back_color'))
    }
    .height(CommonConstants.FULL_PERCENT)
    .backgroundColor($r('app.color.column_back_color'))
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
        })
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
    } else if (!secondLast) {
      // 只有一项 (如 "12")，追加 (变成 "123")
      this.expressions[len - 1] += value;
    }

    if (secondLast && CalculateUtil.isSymbol(secondLast)) {
      // 如果倒数第二项是符号 (如 "1" "+" "2")，则在最后一项上追加
      this.expressions[len -1] += value;
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
    } else {
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
      this.calValue = this.resourceToString($r('app.string.error'));
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
    } catch (error) {
      Logger.error('[CalculateModel] getResourceString fail: ' + JSON.stringify(error))
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
}