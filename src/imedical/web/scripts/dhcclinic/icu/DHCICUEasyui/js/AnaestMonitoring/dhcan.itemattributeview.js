//
/**
 * 药品项目属性编辑
 * 初始化的时候才创建并储存一个实例
 * @author yongyang 20180822
 */

(function(global, factory) {
    if (!global.ItemAttributeView) factory(global.ItemAttributeView = {});
}(this, function(exports) {

    exports.init = function(opt) {
        exports.instance = new ItemAttributeView(opt);
        return exports.instance;
    }

    exports.open = function() {
        if (exports.instance) exports.instance.open();
        else {
            $.messager.alert('错误', '药品项目属性界面未初始化', 'icon-error');
        }
    }

    exports.instance = null;

    /**
     * 药品项目属性界面
     * @param {object} opt 
     */
    function ItemAttributeView(opt) {
        this.options = $.extend(opt, {
            width: 360,
            height: 420
        });
        this.saveHandler = opt.saveHandler;
        this.editform = editform;
        this.init();
    }

    ItemAttributeView.prototype = {
        init: function() {
            var _this = this;
            this.dom = $('<div></div>').appendTo('body');
            var buttons = $('<div></div>');
            var btn_save = $('<a href="#"></a>').linkbutton({
                text: '保存',
                iconCls: 'icon-save',
                onClick: function() {
                    _this.save();
                }
            }).appendTo(buttons);
            var btn_cancel = $('<a href="#"></a>').linkbutton({
                text: '取消',
                iconCls: 'icon-cancel',
                onClick: function() {
                    _this.close();
                }
            }).appendTo(buttons);

            this.initForm();
            this.dom.dialog({
                left: 300,
                top: 150,
                height: this.options.height,
                width: this.options.width,
                title: '药品项目属性',
                modal: true,
                closed: true,
                buttons: buttons,
                onOpen: function() {

                },
                onClose: function() {
                    _this.clear();
                }
            });
            this.initiated = true;
        },
        initForm: function() {
            this.editform.init(this.dom);
            if (this.options.comboDataSource)
                this.setComboDataSource(this.options.comboDataSource);
        },
        /**
         * 设置界面项目
         */
        setParaItem: function(paraItem) {
            this.paraItem = paraItem;
            if (paraItem.ItemCategory == 'D') {
                this.dom.dialog({ height: 420 });
            } else {
                this.dom.dialog({ height: 220 });
            }
            this.dom.dialog("setTitle", "项目属性：" + paraItem.Description);
            this.editform.load(paraItem);
            if (paraItem.Code === 'BloodTransfusion' || paraItem.DataCategoryCode === 'BloodTransfusion') {
                this.editform.showBloodType();
            }
        },
        /**
         * 设置选项数据
         */
        setComboDataSource: function(dataList) {
            this.editform.setComboDataSource(dataList);
        },
        /**
         * 清空表单项
         */
        clear: function() {
            this.editform.clear();
            this.originalData = null;
        },
        /**
         * 打开编辑框
         */
        open: function() {
            this.dom.dialog('open');
        },
        /**
         * 关闭
         */
        close: function() {
            this.dom.dialog('close');
        },
        /**
         * 保存
         */
        save: function() {
            if (!this.editform.validate()) return;
            var data = this.editform.toData();
            $.extend(this.paraItem, data);
            $.extend(data, {
                ParaItem: this.paraItem.RowId
            });
            if (this.saveHandler) {
                this.saveHandler(data);
                this.close();
            }
        }
    }

    var editform = {
        init: function(container) {
            var _this = this;

            this.dom = $('<form class="itemattrview-form"></form>').appendTo(container);
            this.dom.form({});

            this.RowId = $('<input type="hidden" name="RowId">').appendTo(this.dom);
            this.ParaItemRowId = $('<input type="hidden" name="ParaItem">').appendTo(this.dom);

            var row = $('<div class="editview-f-r" style="display:none;"></div>').appendTo(this.dom);
            this.BloodTypeRow = row;
            var label = $('<div class="label">血型：</div>').appendTo(row);
            this.BloodType = $('<input type="text" name="Unit">').appendTo(row);
            this.BloodType.combobox({
                textField: 'text',
                valueField: 'value',
                width: 200,
                label: label,
                data: [{ text: 'RhD+ A', value: 'RhD+ A' },
                    { text: 'RhD- A', value: 'RhD- A' },
                    { text: 'RhD+ B', value: 'RhD+ B' },
                    { text: 'RhD- B', value: 'RhD- B' },
                    { text: 'RhD+ AB', value: 'RhD+ AB' },
                    { text: 'RhD- AB', value: 'RhD- AB' },
                    { text: 'RhD+ O', value: 'RhD+ O' },
                    { text: 'RhD- O', value: 'RhD- O' }
                ]
            });

            var row = $('<div class="editview-f-r" data-itemcategory="D"></div>').appendTo(this.dom);
            var label = $('<div class="label">浓度：</div>').appendTo(row);
            this.Concentration = $('<input class="textbox" type="text" name="ConcentrationUnit" style="width:93px;margin-right:5px;">').appendTo(row);
            this.Concentration.validatebox({
                width: 100,
                label: label,
                novalidate: true
            });
            this.ConcentrationUnit = $('<input type="text" name="ConcentrationUnit">').appendTo(row);
            this.ConcentrationUnit.combobox({
                textField: 'Description',
                valueField: 'RowId',
                width: 95,
                cls: 'drugeditor-editview-f-r-unit'
            });

            var row = $('<div class="editview-f-r"></div>').appendTo(this.dom);
            var label = $('<div class="label">单位：</div>').appendTo(row);
            this.Unit = $('<input type="text" name="Unit">').appendTo(row);
            this.Unit.combobox({
                textField: 'Description',
                valueField: 'RowId',
                width: 200,
                label: label
            });

            var row = $('<div class="editview-f-r" data-itemcategory="D"><label for="itemattrview_DoseUnitVisible" class="label">显示剂量单位：</label></div>').appendTo(this.dom);
            this.DoseUnitVisible = $('<input id="itemattrview_DoseUnitVisible" type="checkbox" name="DoseUnitVisible">').appendTo(row);
            this.DoseUnitVisible.checkbox({});

            var row = $('<div class="editview-f-r" data-itemcategory="D"><label for="itemattrview_SpeedUnitVisible" class="label">显示速度单位：</label></div>').appendTo(this.dom);
            this.SpeedUnitVisible = $('<input id="itemattrview_SpeedUnitVisible" type="checkbox" name="SpeedUnitVisible">').appendTo(row);
            this.SpeedUnitVisible.checkbox({});

            var row = $('<div class="editview-f-r" data-itemcategory="D"><label for="itemattrview_ConcentrationVisible" class="label">显示浓度：</label></div>').appendTo(this.dom);
            this.ConcentrationVisible = $('<input id="itemattrview_ConcentrationVisible" type="checkbox" name="ConcentrationVisible">').appendTo(row);
            this.ConcentrationVisible.checkbox({});

            var row = $('<div class="editview-f-r" data-itemcategory="D"><label for="itemattrview_InstructionVisible" class="label">显示用法：</label></div>').appendTo(this.dom);
            this.InstructionVisible = $('<input id="itemattrview_InstructionVisible" type="checkbox" name="InstructionVisible">').appendTo(row);
            this.InstructionVisible.checkbox({});

            var row = $('<div class="editview-f-r"><label for="itemattrview_Continuous" class="label">默认持续：</label></div>').appendTo(this.dom);
            this.Continuous = $('<input id="itemattrview_Continuous" type="checkbox" name="Continuous">').appendTo(row);
            this.Continuous.checkbox({});

            $('<span style="font-weight:bold;margin-left:10px;">默认持续分钟数：</span>').appendTo(row);
            this.Duration = $('<input type="text" name="Duration">').appendTo(row);
            this.Duration.numberbox({
                width: 53,
                prompt: '默认持续分钟数'
            });

            var row = $('<div class="editview-f-r" data-itemcategory="D"></div>').appendTo(this.dom);
            var label = $('<div class="label">默认用法：</div>').appendTo(row);
            this.Instruction = $('<input type="text" name="Instruction">').appendTo(row);
            this.Instruction.combobox({
                textField: 'Description',
                valueField: 'RowId',
                width: 200,
                label: label
            });

            var row = $('<div class="editview-f-r"></div>').appendTo(this.dom);
            var label = $('<div class="label">备注：</div>').appendTo(row);
            this.Note = $('<input type="text" name="Note" style="width:193px;">').appendTo(row);
            this.Note.validatebox({
                width: 200,
                label: label,
                novalidate: true
            });
        },
        load: function(data) {
            if (data) {
                this.Unit.combobox('setValue', data.Unit);
                this.Concentration.validatebox('setValue', data.Concentration);
                this.ConcentrationUnit.combobox('setValue', data.ConcentrationUnit);
                this.BloodType.combobox('setValue', data.BloodType);
                this.DoseUnitVisible.checkbox('setValue', data.DoseUnitVisible === 'Y');
                this.SpeedUnitVisible.checkbox('setValue', data.SpeedUnitVisible === 'Y');
                this.ConcentrationVisible.checkbox('setValue', data.ConcentrationVisible === 'Y');
                this.InstructionVisible.checkbox('setValue', data.InstructionVisible === 'Y');
                this.Continuous.checkbox('setValue', data.Continuous === 'Y');
                this.Instruction.combobox('setValue', data.Instruction);
                this.Note.validatebox('setValue', data.Note);
                this.Duration.numberbox('setValue', data.Duration);
                this.ParaItemRowId.val(data.RowId);
                if (data.ItemCategory == 'D') {
                    this.dom.find('.editview-f-r[data-itemcategory="D"]').show();
                } else {
                    this.dom.find('.editview-f-r[data-itemcategory="D"]').hide();
                }
            }
        },
        setComboDataSource: function(dataList) {
            this.Unit.combobox('loadData', dataList.Units || []);
            this.ConcentrationUnit.combobox('loadData', dataList.ConcentrationUnits || []);
            this.Instruction.combobox('loadData', dataList.Instructions || []);
        },
        clear: function() {
            this.dom.form('clear');
            this.BloodTypeRow.hide();
            this.DoseUnitVisible.checkbox('setValue', false);
            this.SpeedUnitVisible.checkbox('setValue', false);
            this.ConcentrationVisible.checkbox('setValue', false);
            this.InstructionVisible.checkbox('setValue', false);
            this.Continuous.checkbox('setValue', false);
            $(this.DoseUnitVisible.parent()).removeClass('checked');
            $(this.SpeedUnitVisible.parent()).removeClass('checked');
            $(this.ConcentrationVisible.parent()).removeClass('checked');
            $(this.InstructionVisible.parent()).removeClass('checked');
            $(this.Continuous.parent()).removeClass('checked');
        },
        showBloodType: function() {
            this.BloodTypeRow.show();
        },
        validate: function() {
            var concentration = this.Concentration.validatebox('getValue');
            if (concentration == '' || (Number(concentration) + '') == concentration) {
                return true;
            } else {
                this.Concentration.focus();
                this.Concentration.attr('title', '值错误，请输入数字');
            }
        },
        toData: function() {
            return {
                ParaItem: this.ParaItemRowId.val(),
                Unit: this.Unit.combobox('getValue'),
                UnitDesc: this.Unit.combobox('getText'),
                DoseUnitVisible: this.DoseUnitVisible.prop('checked') ? 'Y' : 'N',
                SpeedUnitVisible: this.SpeedUnitVisible.prop('checked') ? 'Y' : 'N',
                ConcentrationVisible: this.ConcentrationVisible.prop('checked') ? 'Y' : 'N',
                BloodType: this.BloodType.combobox('getValue') || '',
                Concentration: this.Concentration.validatebox('getValue'),
                ConcentrationUnit: this.ConcentrationUnit.combobox('getValue') || '',
                ConcentrationUnitDesc: this.ConcentrationUnit.combobox('getText') || '',
                Continuous: this.Continuous.prop('checked') ? 'Y' : 'N',
                Duration: this.Duration.numberbox('getValue'),
                Instruction: this.Instruction.combobox('getValue'),
                InstructionDesc: this.Instruction.combobox('getText'),
                InstructionVisible: this.InstructionVisible.prop('checked') ? 'Y' : 'N',
                Note: this.Note.validatebox('getValue') || ''
            }
        }
    }
}));