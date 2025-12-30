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
 * 按键实体类 (Bean)
 * 用于定义计算器上每一个按键的数据结构。
 */
export class PressKeysBean {
    /**
     * 标记位/类型标识。
     * 用于区分按钮的显示样式：
     * 0: 表示图标按钮 (Icon Button)，需要加载 source 图片资源。
     * 1: 表示文本按钮 (Text Button)，直接显示 value 文本。
     */
    flag: number;
    /**
     * 按钮宽度。
     * 格式通常为字符串类型的尺寸，如 '32vp'。
     */
    width: string;
    /**
     * 按钮高度。
     * 对于文本按钮，这可能也代表字体的大小。
     */
    height: string;
    /**
     * 按钮的逻辑值。
     * 当按钮被按下时，传递给逻辑处理层的具体数值或命令。
     * 例如：'7', 'clean', 'mul'。
     */
    value: string;
    /**
     * 按钮的图片资源 (可选)。
     * 只有当 flag 为 0 (图标按钮) 时，此字段才需要赋值。
     * 使用 Resource 类型引用本地媒体文件，如 $r('app.media.ic_add')。
     */
    source?: Resource;
    /**
     * 构造函数
     * 用于创建一个新的按键对象实例。
     *
     * @param flag 类型标记 (0:图标, 1:文本)
     * @param width 宽度
     * @param height 高度
     * @param value 逻辑值
     * @param source 图片资源 (可选)
     */
    constructor(flag: number, width: string, height: string, value: string, source?: Resource) {
        this.flag = flag;
        this.width = width;
        this.height = height;
        this.value = value;
        this.source = source;
    }
}
