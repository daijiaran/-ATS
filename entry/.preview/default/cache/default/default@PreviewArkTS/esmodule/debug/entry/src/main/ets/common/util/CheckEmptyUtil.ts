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
 * 判空工具类
 * 用于集中处理对象、字符串和数组的非空校验。
 */
class CheckEmptyUtil {
    /**
     * 检查对象或基本类型是否为空。
     *
     * @param {object | string} obj - 需要检查的对象或字符串
     * @return {boolean} - 如果是 undefined, null 或 空字符串('')，返回 true；否则返回 false。
     */
    isEmpty(obj: object | string): boolean {
        // typeof obj === 'undefined': 检查变量是否未定义
        // obj === null: 检查变量是否为 null
        // obj === '': 检查变量是否为空字符串
        return (typeof obj === 'undefined' || obj === null || obj === '');
    }
    /**
     * 检查字符串是否为空（忽略首尾空格）。
     * 这是一个更严格的字符串检查，"   " 也会被视为空。
     *
     * @param {string} str - 需要检查的字符串
     * @return {boolean} - 如果去除首尾空格后长度为0，返回 true。
     */
    checkStrIsEmpty(str: string): boolean {
        // .trim() 用于去除字符串两端的空白字符
        return str.trim().length === 0;
    }
    /**
     * 检查数组是否为空。
     *
     * @param {Array<string>} arr - 需要检查的字符串数组
     * @return {boolean} - 如果数组长度为0，返回 true。
     */
    isEmptyArr(arr: Array<string>): boolean {
        return arr.length === 0;
    }
}
/**
 * 导出该类的一个实例（单例模式）。
 * 外部引用时无需 new，直接使用即可。
 * 例如: CheckEmptyUtil.isEmpty(myVar)
 */
export default new CheckEmptyUtil();
