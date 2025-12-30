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

/**
 * 所有功能的通用常量类。
 * 用于集中管理应用中用到的字符串、数字常量，避免硬编码。
 */
export class CommonConstants {
  /**
   * 满比例字符串，通常用于设置宽度或高度为 100%。
   */
  static readonly FULL_PERCENT: string = '100%';

  /**
   * 基础运算符集合字符串，包含加、减、乘、除。
   * 用于判断字符是否为运算符。
   */
  static readonly OPERATORS: string = '+-×÷';

  /**
   * 高优先级运算符集合，包含乘法和除法。
   */
  static readonly OPERATORS_PRIORITY: string = '×÷';

  /**
   * 加法符号 (+)。
   */
  static readonly ADD: string = '+';

  /**
   * 减法符号 (-)。
   */
  static readonly MIN: string = '-';

  /**
   * 乘法符号 (×)。
   */
  static readonly MUL: string = '×';

  /**
   * 除法符号 (÷)。
   */
  static readonly DIV: string = '÷';

  /**
   * 百分号 (%)。
   */
  static readonly PERCENT_SIGN: string = '%';

  /**
   * 小数点 (.)。
   */
  static readonly DOTS: string = '.';

  /**
   * 数字常量：2。
   */
  static readonly TWO: number = 2;

  /**
   * 数字常量：10。
   */
  static readonly TEN: number = 10;

  /**
   * 字符串常量：100。
   */
  static readonly ONE_HUNDRED: string = '100';

  /**
   * 大字体显示的最大长度限制。
   * 当输入数字超过这个长度时，字体可能会变小或截断。
   */
  static readonly INPUT_LENGTH_MAX: number = 9;

  /**
   * 索引常量：2。
   * 可能用于数组访问或逻辑判断。
   */
  static readonly INDEX_TWO: number = 2;

  /**
   * 单个数字的最大长度限制 (16位)。
   * 通常用于防止精度溢出或超出屏幕显示范围。
   */
  static readonly NUM_MAX_LEN: number = 16;

  /**
   * 科学计数法中的符号 'e'。
   */
  static readonly E: string = 'e';

  /**
   * 字符串形式的零 '0'。
   */
  static readonly ZERO: string = '0';

  /**
   * 字符串形式的 '0.'，用于浮点数输入的起始状态。
   */
  static readonly ZERO_DOTS: string = '0.';
}

/**
 * 按键功能标识枚举。
 * 用于代码逻辑中区分用户点击的是哪种类型的功能键。
 */
export enum Symbol {
  ADD = 'add',    // 加法功能
  MIN = 'min',    // 减法功能
  MUL = 'mul',    // 乘法功能
  DIV = 'div',    // 除法功能
  CLEAN = 'clean',// 清除/归零功能 (C/AC)
  DEL = 'del',    // 删除/退格功能
  EQU = 'equ'     // 等于/计算结果功能
}

/**
 * 运算符优先级枚举。
 * 用于计算逻辑（如栈操作）中判断运算顺序。
 */
export enum Priority {
  HIGH = 2,   // 高优先级 (通常指乘除)
  MEDIUM = 1, // 中优先级 (通常指加减)
  LOW = 0     // 低优先级
}

/**
 * 符号枚举。
 * 将逻辑名称映射到具体的显示字符。
 */
export enum SymbolicEnumeration {
  ADD = '+', // 加号字符
  MIN = '-', // 减号字符
  MUL = '×', // 乘号字符
  DIV = '÷'  // 除号字符
}