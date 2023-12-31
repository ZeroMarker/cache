/**
 * 用户选择框（PACU护士填写护士签名数据）
 * @author yongyang 20200701
 */
(function(global, factory) {
    if (!global.NurseEditor) factory(global.NurseEditor = {});
}(this, function(exports) {

    exports.init = function(opt) {
        var view = new NurseEditor(opt);
        exports.instance = view;
        return view;
    }

    exports.instance = null;

    function NurseEditor(opt) {
        this.options = $.extend({ width: 340, height: 240 }, opt);
        this.saveHandler = opt.saveHandler;
        this.init();
    }

    NurseEditor.prototype = {
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
                title: '用户选择',
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

            var timeRow = $('<div class="vitalsign-editview-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label">开始时间：</div>').appendTo(timeRow);
            this.StartDT = $('<input type="text">').appendTo(timeRow);
            this.StartDT.datetimebox({
                required: true,
                width: 180,
                label: label
            });
            this.StartDT.datetimebox('initiateWheelListener');
            this.StartDT.datetimebox('initiateKeyUpListener');

            var valueRow = $('<div class="vitalsign-editview-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label">用户：</div>').appendTo(valueRow);
            this.SignNurse = $('<input type="text" style="width:174px;">').appendTo(valueRow);
            this.SignNurse.combobox({
                width: 180,
                label: label,
                valueField: 'RowId',
                textField: 'Description'
            });
            this.setDataSource();
        },
        setDataSource: function() {
            var comboDataSource = this.options.comboDataSource || {};
            this.SignNurse.combobox('loadData', comboDataSource.Nurses || []);
        },
        setParaItem: function(paraItem) {
            this.paraItem = paraItem;
            this.dom.dialog('setTitle', '数据编辑——' + paraItem.Description);
            this.dom.data('paraItem', paraItem);
        },
        loadData: function(data) {
            if (data.RowId) {
                this.originalData = data;
                this.StartDT.datetimebox('setValue', data.StartDT.format(constant.dateTimeFormat));
                this.SignNurse.combobox('setValue', data.SignNurse);
            } else {
                this.StartDT.datetimebox('setValue', data.StartDT.format(constant.dateTimeFormat));
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

            return true;
        },
        toData: function() {
            var paraItem = this.dom.data('paraItem');
            var dataValue = this.SignNurse.combobox('getText');
            var signNurse = this.SignNurse.combobox('getValue');

            var startDT = this.StartDT.datetimebox("getValue");
            var arr = startDT.split(' ');
            var startDate = startTime = '';
            if (arr.length > 1) {
                startDate = arr[0];
                startTime = arr[1];
            }

            startDT = (new Date()).tryParse(startDT, constant.dateTimeFormat);

            return {
                RowId: "",
                SheetRecord: "",
                ParaItem: paraItem.RowId,
                StartDate: startDate,
                StartTime: startTime,
                EndDate: startDate,
                EndTime: startTime,
                DataValue: dataValue,
                EditFlag: "N",
                FromData: "",
                CreateUserID: "",
                CreateDT: "",
                StartDT: startDT,
                EndDT: startDT,
                CategoryItem: paraItem.CategoryItem.RowId,
                DataItem: paraItem.CategoryItem.DataItem,
                DataItemDesc: paraItem.Description,
                ItemCategory: "V",
                Continuous: 'N',
                SignNurse: signNurse
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