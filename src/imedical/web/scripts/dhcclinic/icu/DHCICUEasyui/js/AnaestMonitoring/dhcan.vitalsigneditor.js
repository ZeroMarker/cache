/**
 * 生命体征数据编辑
 * @author 20180507
 */
(function(global, factory) {
    if (!global.VitalSignEditor) factory(global.VitalSignEditor = {});
}(this, function(exports) {

    exports.init = function(opt) {
        var view = new VitalSignEditor(opt);
        exports.instance = view;
        return view;
    }

    exports.instance = null;

    function VitalSignEditor(opt) {
        this.options = { width: 340, height: 240 }
        this.saveHandler = opt.saveHandler;
        this.init();
    }

    VitalSignEditor.prototype = {
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
                title: '生命体征数据编辑',
                modal: true,
                closed: true,
                buttons: buttons,
                onOpen: function() {

                },
                onClose: function() {
                    _this.clear();
                }
            });
        },
        initForm: function() {
            var _this = this;
            this.form = $('<form class="vitalsign-editview-form"></form>').appendTo(this.dom);
            this.form.form({});
            this.RowId = $('<input type="hidden" name="RowId">').appendTo(this.form);
            this.ParaItemRowId = $('<input type="hidden" name="ParaItem">').appendTo(this.form);
            this.DrugDataRowId = $('<input type="hidden" name="DrugDataRowId">').appendTo(this.form);

            var itemRow = $('<div class="vitalsign-editview-f-r"></div>').appendTo(this.form);
            var label = $('<label class="label" for="vitalsign_continuous">持续：</label>').appendTo(itemRow);
            this.Continuous = $('<input id="vitalsign_continuous" type="checkbox" name="Continuous">').appendTo(itemRow);
            this.Continuous.checkbox({
                onChecked: function(e, value) {
                    _this.EndDT.datetimebox('enable');
                    _this.EndDT.datetimebox('setValue', '9999-12-31 00:00');
                },
                onUnchecked: function(e, value) {
                    _this.EndDT.datetimebox('disable');
                    _this.EndDT.datetimebox('setValue', _this.StartDT.datetimebox('getValue'));
                }
            });

            var timeRow = $('<div class="vitalsign-editview-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label">开始时间：</div>').appendTo(timeRow);
            this.StartDT = $('<input type="text">').appendTo(timeRow);
            this.StartDT.datetimebox({
                required: true,
                width: 180,
                label: label,
                onChanged: function(newValue, oldValue) {
                    if (!_this.Continuous.checkbox('getValue')) {
                        _this.EndDT.datetimebox('setValue', newValue);
                    }
                }
            });
            this.StartDT.datetimebox('initiateWheelListener');
            this.StartDT.datetimebox('initiateKeyUpListener');

            var timeRow = $('<div class="vitalsign-editview-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label">结束时间：</div>').appendTo(timeRow);
            this.EndDT = $('<input type="text">').appendTo(timeRow);
            this.EndDT.datetimebox({
                width: 180,
                disabled: true,
                label: label
            });

            var valueRow = $('<div class="vitalsign-editview-f-r"></div>').appendTo(this.form);
            this.textValueRow = valueRow;
            var label = $('<div class="label">数值：</div>').appendTo(valueRow);
            this.DataValue = $('<input type="text" style="width:174px;">').appendTo(valueRow);
            this.DataValue.validatebox({
                width: 174,
                label: label,
                novalidate: true
            });

            var valueRow = $('<div class="vitalsign-editview-f-r"></div>').appendTo(this.form);
            this.comboValueRow = valueRow;
            var label = $('<div class="label">数值：</div>').appendTo(valueRow);
            this.ComboDataValue = $('<input type="text" style="width:174px;">').appendTo(valueRow);
            this.ComboDataValue.combobox({
                width: 180,
                label: label,
                valueField: 'value',
                textField: 'value'
            });
        },
        setParaItem: function(paraItem) {
            this.paraItem = paraItem;
            this.dom.dialog('setTitle', '数据编辑——' + paraItem.Description);
            this.dom.data('paraItem', paraItem);
            if (this.paraItem.categoryItemObj && this.paraItem.categoryItemObj.Options) {
                var array = this.paraItem.categoryItemObj.Options.split(';');
                var data = [];
                $.each(array, function(index, e) {
                    data.push({ 'value': e });
                });
                this.ComboDataValue.combobox('loadData', data);

                this.comboValueRow.show();
                this.textValueRow.hide();
            } else {
                this.comboValueRow.hide();
                this.textValueRow.show();
            }
            if (paraItem && paraItem.Continuous === 'Y') {
                this.Continuous.checkbox('setValue', true);
            }
        },
        loadData: function(data) {
            var startDT = data.StartDT.format(constant.dateTimeFormat);
            this.StartDT.datetimebox("setValue", startDT);
            if (!this.Continuous.checkbox('getValue')) {
                this.EndDT.datetimebox("setValue", startDT);
            }
            if (this.paraItem && this.paraItem.Duration && Number(this.paraItem.Duration) > 0) {
                this.EndDT.datetimebox("setValue",
                    data.StartDT.addMinutes(Number(this.paraItem.Duration))
                    .format(constant.dateTimeFormat));
            }
            if (data.RowId) {
                this.originalData = data;
                this.Continuous.checkbox('setValue', data.Continuous === 'Y' ? true : false);
                this.StartDT.datetimebox('setValue', data.StartDT.format(constant.dateTimeFormat));
                this.EndDT.datetimebox('setValue', data.EndDT.format(constant.dateTimeFormat));
                this.DataValue.validatebox('setValue', data.DataValue);
                this.ComboDataValue.combobox('setValue', data.DataValue);
            }
        },
        open: function() {
            this.dom.dialog('open');
        },
        close: function() {
            this.dom.dialog('close');
            this.originalData = null;
        },
        clear: function() {
            this.form.form('clear');
            this.originalData = null;
            this.Continuous.checkbox('setValue', false);
            $(this.Continuous.parent()).removeClass('checked');
            this.EndDT.datetimebox('disable');
        },
        validate: function() {

        },
        save: function() {
            var savingDatas = [];
            var preparedDatas = [];
            var newData = this.toData();
            var originalData = this.originalData;
            if (originalData) {
                if (isAnaDataEqual(newData, originalData)) return;
                $.extend(originalData, { EditFlag: 'D' });
                $.extend(newData, {
                    FromData: originalData.RowId,
                    ParaItem: originalData.ParaItem,
                    CategoryItem: originalData.CategoryItem,
                    DataItem: originalData.DataItem,
                    DataItemDesc: originalData.DataItemDesc,
                    ItemCategory: originalData.ItemCategory
                });
                savingDatas.push({ RowId: originalData.RowId, EditFlag: 'D' });
            } else {
                $.extend(newData, {
                    FromData: '',
                    ParaItem: this.paraItem.RowId,
                    CategoryItem: this.paraItem.CategoryItem,
                    DataItem: this.paraItem.DataItem,
                    DataItemDesc: this.paraItem.DataItemDesc,
                    ItemCategory: this.paraItem.ItemCategory
                })
            }
            if (!this.validate(newData)) return;
            savingDatas.push(newData);
            prepareSavingDatas();
            if (this.saveHandler) this.saveHandler(preparedDatas);
            this.close();

            function prepareSavingDatas() {
                var anaDataClassName = ANCLS.Model.AnaData;
                $.each(savingDatas, function(index, data) {
                    preparedDatas.push($.extend(data, {
                        ClassName: anaDataClassName
                    }));
                });
            }
        },
        validate: function(data) {
            var _this = this;
            if (data.StartDT > data.EndDT) {
                $.messager.alert('错误', '结束时间不能小于开始时间', 'error', function() {
                    _this.EndDT.datetimebox('focus');
                });
                return false;
            }

            return true;
        },
        toData: function() {
            var paraItem = this.dom.data('paraItem');
            var dataValue = this.DataValue.validatebox('getValue');
            if (this.comboValueRow.is(':visible')) {
                dataValue = this.ComboDataValue.combobox('getValue');
            }

            var startDT = this.StartDT.datetimebox("getValue");
            var arr = startDT.split(' ');
            var startDate = startTime = '';
            if (arr.length > 1) {
                startDate = arr[0];
                startTime = arr[1];
            }
            var endDT = this.EndDT.datetimebox("getValue");
            var arr = endDT.split(' ');
            var endDate = endTime = '';
            if (arr.length > 1) {
                endDate = arr[0];
                endTime = arr[1];
            }

            startDT = (new Date()).tryParse(startDT, constant.dateTimeFormat);
            endDT = (new Date()).tryParse(endDT, constant.dateTimeFormat);
            return {
                RowId: "",
                SheetRecord: "",
                ParaItem: paraItem.RowId,
                StartDate: startDate,
                StartTime: startTime,
                EndDate: endDate,
                EndTime: endTime,
                DataValue: dataValue,
                EditFlag: "N",
                FromData: "",
                CreateUserID: "",
                CreateDT: "",
                StartDT: startDT,
                EndDT: endDT,
                CategoryItem: paraItem.CategoryItem.RowId,
                DataItem: paraItem.CategoryItem.DataItem,
                DataItemDesc: paraItem.Description,
                ItemCategory: "V",
                Continuous: this.Continuous.checkbox('getValue') ? 'Y' : 'N'
            }
        }
    }

    /**
     * 判断两个数据是否相等
     * @param {Array} fields 
     * @param {object} newData 
     * @param {object} oldData 
     */
    function isEqual(fields, newData, oldData) {
        var result = true;
        $.each(fields, function(index, field) {
            if (newData[field] != oldData[field]) {
                result = false;
                return false;
            }
        });

        return result;
    }

    /**
     * 判断两个麻醉数据是否相等
     * @param {Model.AnaData} newData 
     * @param {Model.AnaData} oldData 
     */
    function isAnaDataEqual(newData, oldData) {
        var fields = ['StartDate', 'EndDate', 'StartTime', 'EndTime', 'DataValue', 'Continuous'];
        return isEqual(fields, newData, oldData);
    }
}))