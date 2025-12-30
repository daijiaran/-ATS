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

import { CommonConstants, Priority, SymbolicEnumeration } from '../constants/CommonConstants';
import CheckEmptyUtil from './CheckEmptyUtil';

/**
 * 计算工具类
 * 负责解析数学表达式、执行四则运算以及处理数值精度和格式化。
 */
class CalculateUtil {
  /**
   * 判断传入的字符是否为运算符。
   *
   * @param value 需要判断的符号
   * @return boolean 如果是运算符(+-×÷)返回true
   */
  isSymbol(value: string) {
    if (CheckEmptyUtil.isEmpty(value)) {
      return;
    }
    // 检查该字符是否存在于定义的运算符字符串集合中
    return (CommonConstants.OPERATORS.indexOf(value) !== -1);
  }

  /**
   * 获取运算符的优先级。
   * 用于算法判断计算顺序（先乘除后加减）。
   *
   * @param value 运算符
   * @return number 优先级数值 (高:2, 中:1, 低:0)
   */
  getPriority(value: string): number {
    if (CheckEmptyUtil.isEmpty(value)) {
      return Priority.LOW;
    }
    let result = 0;
    switch (value) {
      case SymbolicEnumeration.ADD:
      case SymbolicEnumeration.MIN:
        result = Priority.MEDIUM; // 加减法为中优先级
        break;
      case SymbolicEnumeration.MUL:
      case SymbolicEnumeration.DIV:
        result = Priority.HIGH;   // 乘除法为高优先级
        break;
      default:
        result = Priority.LOW;
        break;
    }
    return result;
  }

  /**
   * 比较两个运算符的优先级。
   *
   * @param arg1 当前运算符
   * @param arg2 栈顶运算符
   * @return boolean 如果 arg1 的优先级 <= arg2 的优先级，返回 true。
   * 这意味着需要先计算栈顶的 arg2，才能处理 arg1。
   */
  comparePriority(arg1: string, arg2: string): boolean {
    if (CheckEmptyUtil.isEmpty(arg1) || CheckEmptyUtil.isEmpty(arg2)) {
      return false;
    }
    return (this.getPriority(arg1) <= this.getPriority(arg2));
  }

  /**
   * 表达式解析核心方法。
   * 将用户输入的中缀表达式数组转换为方便计算的队列（通常是后缀表达式逻辑）。
   *
   * @param expressions 表达式数组 (例如: ["1", "+", "2", "×", "3"])
   * @return string 计算结果
   */
  parseExpression(expressions: Array<string>): string {
    if (CheckEmptyUtil.isEmpty(expressions)) {
      return 'NaN';
    }
    let len = expressions.length;
    let outputStack: string[] = []; // 临时存储运算符的栈
    let outputQueue: string[] = []; // 存储最终排序好的数字和运算符的队列

    // 1. 预处理：处理百分号 (%)
    expressions.forEach((item: string, index: number) => {
      // 如果包含 %，将其转换为 除以100 的数值
      if (item.indexOf(CommonConstants.PERCENT_SIGN) !== -1) {
        expressions[index] = (this.mulOrDiv(item.slice(0, item.length - 1),
          CommonConstants.ONE_HUNDRED, CommonConstants.DIV)).toString();
      }
      // 容错处理：如果最后一个元素是运算符，将其移除（例如用户输入 "1+2+" 还没输完就按等于）
      if ((index === len - 1) && this.isSymbol(item)) {
        expressions.pop();
      }
    });

    // 2. 调度场算法：重排表达式顺序
    while (expressions.length > 0) {
      let current: string | undefined = expressions.shift();
      if (current !== undefined) {
        if (this.isSymbol(current)) {
          // 如果是运算符
          // 当栈不为空，且当前运算符优先级 <= 栈顶运算符优先级时
          // 将栈顶运算符弹出并放入输出队列（保证高优先级的先运算）
          while (outputStack.length > 0 && this.comparePriority(current, outputStack[outputStack.length - 1])) {
            let popValue: string | undefined = outputStack.pop();
            if (popValue !== undefined) {
              outputQueue.push(popValue);
            }
          }
          outputStack.push(current);
        } else {
          // 如果是数字，直接放入输出队列
          outputQueue.push(current);
        }
      }
    }
    // 将栈中剩余的运算符全部移入队列
    while (outputStack.length > 0) {
      let popValue: string | undefined = outputStack.pop();
      if (popValue !== undefined) {
        outputQueue.push(popValue);
      }
    }

    // 3. 计算排序后的队列
    return this.dealQueue(outputQueue);
  }

  /**
   * 处理后缀表达式队列，计算最终结果。
   *
   * @param queue 排好序的表达式队列 (例如: ["1", "2", "3", "×", "+"])
   * @return string 最终计算结果字符串
   */
  dealQueue(queue: Array<string>): string {
    if (CheckEmptyUtil.isEmpty(queue)) {
      return 'NaN';
    }
    let outputStack: string[] = []; // 用于计算的数字栈
    while (queue.length > 0) {
      let current: string | undefined = queue.shift();
      if (current !== undefined) {
        if (!this.isSymbol(current)) {
          // 如果是数字，压入栈
          outputStack.push(current);
        } else {
          // 如果是运算符，从栈中弹出两个数字进行计算
          // 注意：栈是后进先出，所以先弹出的是第二个操作数(second)，后弹出的是第一个(first)
          let second: string | undefined = outputStack.pop();
          let first: string | undefined = outputStack.pop();
          if (first !== undefined && second !== undefined) {
            let calResultValue: string = this.calResult(first, second, current)
            // 将计算结果压回栈中，供后续运算使用
            outputStack.push(calResultValue);
          }
        }
      }
    }
    // 计算结束后，栈中应该只剩下一个结果
    if (outputStack.length !== 1) {
      return 'NaN';
    } else {
      // 处理结果末尾可能多余的小数点
      let end: string = outputStack[0]?.endsWith(CommonConstants.DOTS) ?
        outputStack[0].substring(0, outputStack[0].length - 1) : outputStack[0];
      return end;
    }
  }

  /**
   * 基础运算分发方法。
   * 根据运算符调用具体的计算函数。
   *
   * @param arg1 第一个数字
   * @param arg2 第二个数字
   * @param symbol 运算符
   * @return string 计算结果
   */
  calResult(arg1: string, arg2: string, symbol: string): string {
    if (CheckEmptyUtil.isEmpty(arg1) || CheckEmptyUtil.isEmpty(arg2) || CheckEmptyUtil.isEmpty(symbol)) {
      return 'NaN';
    }
    let result = 0;
    switch (symbol) {
      case SymbolicEnumeration.ADD:
        result = this.add(arg1, arg2, CommonConstants.ADD);
        break;
      case SymbolicEnumeration.MIN:
        result = this.add(arg1, arg2, CommonConstants.MIN);
        break;
      case SymbolicEnumeration.MUL:
        result = this.mulOrDiv(arg1, arg2, CommonConstants.MUL);
        break;
      case SymbolicEnumeration.DIV:
        result = this.mulOrDiv(arg1, arg2, CommonConstants.DIV);
        break;
      default:
        break;
    }
    // 计算完成后，尝试格式化为科学计数法
    return this.numberToScientificNotation(result);
  }

  /**
   * 加减法运算实现（包含精度处理）。
   *
   * @param arg1 数字1
   * @param arg2 数字2
   * @param symbol 加号或减号
   * @return number 结果数值
   */
  add(arg1: string, arg2: string, symbol: string): number {
    let addFlag = (symbol === CommonConstants.ADD);
    // 如果包含科学计数法('e')，直接使用JS原生计算（因为数字太大，已经丢失精度了）
    if (this.containScientificNotation(arg1) || this.containScientificNotation(arg2)) {
      if (addFlag) {
        return Number(arg1) + Number(arg2);
      }
      return Number(arg1) - Number(arg2);
    }
    // 规范化输入：如果是 "0." 视为 "0"
    arg1 = (arg1 === CommonConstants.ZERO_DOTS) ? '0' : arg1;
    arg2 = (arg2 === CommonConstants.ZERO_DOTS) ? '0' : arg2;

    // 获取小数点后的位数
    let leftArr = arg1.split(CommonConstants.DOTS);
    let rightArr = arg2.split(CommonConstants.DOTS);
    let leftLen = leftArr.length > 1 ? leftArr[1] : '';
    let rightLen = rightArr.length > 1 ? rightArr[1] : '';

    // 找出最长的小数位数
    let maxLen = Math.max(leftLen.length, rightLen.length);
    // 计算放大倍数 (例如最长2位小数，则放大100倍)
    let multiples = Math.pow(CommonConstants.TEN, maxLen);

    // 核心逻辑：先乘倍数转为整数计算，再除以倍数还原，避免 0.1+0.2!=0.3 的浮点问题
    if (addFlag) {
      return Number(((Number(arg1) * multiples + Number(arg2) * multiples) / multiples).toFixed(maxLen));
    }
    return Number(((Number(arg1) * multiples - Number(arg2) * multiples) / multiples).toFixed(maxLen));
  }

  /**
   * 乘除法运算实现（包含精度处理）。
   *
   * @param arg1 数字1
   * @param arg2 数字2
   * @param symbol 乘号或除号
   * @return number 结果数值
   */
  mulOrDiv(arg1: string, arg2: string, symbol: string): number {
    let mulFlag = (symbol === CommonConstants.MUL);
    // 科学计数法直接计算
    if (this.containScientificNotation(arg1) || this.containScientificNotation(arg2)) {
      if (mulFlag) {
        return Number(arg1) * Number(arg2);
      }
      return Number(arg1) / Number(arg2);
    }
    // 获取小数位数
    let leftLen = arg1.split(CommonConstants.DOTS)[1] ? arg1.split(CommonConstants.DOTS)[1].length : 0;
    let rightLen = arg2.split(CommonConstants.DOTS)[1] ? arg2.split(CommonConstants.DOTS)[1].length : 0;

    // 核心逻辑：移除小数点变为整数运算
    if (mulFlag) {
      // 乘法：结果需要除以 10^(左小数位 + 右小数位)
      return Number(arg1.replace(CommonConstants.DOTS, '')) *
      Number(arg2.replace(CommonConstants.DOTS, '')) / Math.pow(CommonConstants.TEN, leftLen + rightLen);
    }
    // 除法：结果需要除以 10^(右小数位 - 左小数位) -> 相当于补齐小数位后的整数除法
    return Number(arg1.replace(CommonConstants.DOTS, '')) /
      (Number(arg2.replace(CommonConstants.DOTS, '')) / Math.pow(CommonConstants.TEN, rightLen - leftLen));
  }

  /**
   * 检测字符串是否包含科学计数法标记 'e'。
   */
  containScientificNotation(arg: string) {
    return (arg.indexOf(CommonConstants.E) !== -1);
  }

  /**
   * 将数字转换为科学计数法格式。
   * 当数字长度超过显示限制时触发。
   *
   * @param result 计算结果数值
   * @return string 格式化后的字符串
   */
  numberToScientificNotation(result: number) {
    // 处理无穷大情况
    if (result === Number.NEGATIVE_INFINITY || result === Number.POSITIVE_INFINITY) {
      return 'NaN';
    }
    let resultStr = JSON.stringify(result);
    // 如果已经是科学计数法，直接返回
    if (this.containScientificNotation(resultStr)) {
      return resultStr;
    }
    // 确定符号位（正负）
    let prefixNumber = (resultStr.indexOf(CommonConstants.MIN) === -1) ? 1 : -1;
    result *= prefixNumber; // 转为正数处理计算

    // 如果数字长度（去掉小数点和负号）小于最大限制(16)，则不需要转换
    if (resultStr.replace(CommonConstants.DOTS, '').replace(CommonConstants.MIN, '').length <
    CommonConstants.NUM_MAX_LEN) {
      return resultStr;
    }

    // 计算指数部分
    let suffix = (Math.floor(Math.log(result) / Math.LN10));
    // 计算尾数部分
    let prefix = (result * Math.pow(CommonConstants.TEN, -suffix) * prefixNumber);
    // 拼接结果：尾数 + 'e' + 指数
    return (prefix + CommonConstants.E + suffix);
  }
}

export default new CalculateUtil();