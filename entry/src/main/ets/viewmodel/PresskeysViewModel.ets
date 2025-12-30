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

import { PressKeysBean } from './PressKeysItem';

/**
 * 键盘视图模型 (ViewModel)
 * 负责提供计算器键盘的布局数据源。
 */
export class PressKeysBeanViewModel {

  /**
   * 获取按键数据数组。
   * 这是一个二维数组，每一个内部数组代表计算器界面上的一列 (Column)。
   * * @return Array<Array<PressKeysBean>> 按键对象集合
   */
  getPressKeys(): Array<Array<PressKeysBean>> {
    return [
      // 第一列数据 (从上到下: 清除, 7, 4, 1, %)
      [
        // 参数说明: (类型:0图标/1文字, 宽/字体大小, 高, 逻辑值, 图片资源)
        new PressKeysBean(0, '32vp', '32vp', 'clean', $r('app.media.ic_clean')), // 清除键 (AC)
        new PressKeysBean(1, '19vp', '43vp', '7'), // 数字 7
        new PressKeysBean(1, '19vp', '43vp', '4'), // 数字 4
        new PressKeysBean(1, '19vp', '43vp', '1'), // 数字 1
        new PressKeysBean(1, '25vp', '43vp', '%')  // 百分号
      ],
      // 第二列数据 (从上到下: 除号, 8, 5, 2, 0)
      [
        new PressKeysBean(0, '32vp', '32vp', 'div', $r('app.media.ic_div')), // 除法键 (÷)
        new PressKeysBean(1, '19vp', '43vp', '8'), // 数字 8
        new PressKeysBean(1, '19vp', '43vp', '5'), // 数字 5
        new PressKeysBean(1, '19vp', '43vp', '2'), // 数字 2
        new PressKeysBean(1, '19vp', '43vp', '0')  // 数字 0
      ],
      // 第三列数据 (从上到下: 乘号, 9, 6, 3, 小数点)
      [
        new PressKeysBean(0, '32vp', '32vp', 'mul', $r('app.media.ic_mul')), // 乘法键 (×)
        new PressKeysBean(1, '19vp', '43vp', '9'), // 数字 9
        new PressKeysBean(1, '19vp', '43vp', '6'), // 数字 6
        new PressKeysBean(1, '19vp', '43vp', '3'), // 数字 3
        new PressKeysBean(1, '19vp', '43vp', '.')  // 小数点
      ],
      // 第四列数据 (功能键列: 删除, 减号, 加号, 等于)
      // 注意：这一列的元素比前三列少一个，通常意味着某些键高度较高（如等于号可能占两行），或者UI布局特殊。
      [
        new PressKeysBean(0, '30.48vp', '20vp', 'del', $r('app.media.ic_del')), // 删除/回退键
        new PressKeysBean(0, '24vp', '24vp', 'min', $r('app.media.ic_min')),     // 减法键 (-)
        new PressKeysBean(0, '32vp', '32vp', 'add', $r('app.media.ic_add')),     // 加法键 (+)
        new PressKeysBean(0, '32vp', '32vp', 'equ', $r('app.media.ic_equ'))      // 等于键 (=)
      ]
    ];
  }
}

// 创建一个实例并导出，方便外部直接引用 (单例模式用法)
let keysModel = new PressKeysBeanViewModel();
export default keysModel as PressKeysBeanViewModel;