/**
 * 用药数据速度改变
 * 初始化的时候才创建并储存一个实例
 * @author yongyang 20180503
 */

(function(global, factory) {
    if (!global.SpeedChangeEditor) factory(global.SpeedChangeEditor = {});
}(this, function(exports) {
    exports.init = function(opt) {
        exports.instance = new SpeedChangeEditor(opt);
        return exports.instance;
    }

    exports.open = function() {
        if (exports.instance) exports.instance.open();
        else {
            $.messager.alert('错误', '用药数据编辑界面未初始化', 'icon-error');
        }
    }

    exports.instance = null;

    /**
     * 用药数据速度改变编辑界面
     * @param {object} opt 
     */
    function SpeedChangeEditor(opt) {
        this.options = $.extend(opt, {
            width: 320,
            height: 240
        });
        this.saveHandler = opt.saveHandler;
        this.editform = editform;
        this.init();
    }

    SpeedChangeEditor.prototype = {
        init: function() {
            var _this = this;
            this.dom = $('<div></div>').appendTo('body');
            var buttons = $('<div></div>');
            var btn_save = $('<a href="#"></a>').linkbutton({
                text: '确定',
                iconCls: 'icon-save',
                onClick: function() {
                    _this.save();
                    _this.close();
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
                top: 50,
                height: this.options.height,
                width: this.options.width,
                title: '速度改变',
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
        },
        /**
         * 加载数据
         * @param {object} data
         */
        loadData: function(data) {
            if (data && data.DrugData) this.originalData = data;
            this.editform.loadData(data);
        },
        setStartDT: function(startDT) {
            this.editform.setStartDT(startDT);
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
            var savingDatas = [];
            var preparedDatas = [];
            var savingDatas = this.editform.toData();
            prepareSavingDatas();
            this.saveHandler(preparedDatas);

            function prepareSavingDatas() {
                var anaDataClassName = ANCLS.Model.AnaData;
                var drugDataClassName = ANCLS.Model.DrugData;
                $.each(savingDatas, function(index, data) {
                    var guid = dhccl.guid();
                    preparedDatas.push($.extend(data, {
                        Guid: guid,
                        ClassName: anaDataClassName
                    }));
                    preparedDatas.push($.extend(data.DrugData, {
                        AnaDataGuid: guid,
                        ClassName: drugDataClassName
                    }))
                });
            }
        }
    }

    var editform = {
        init: function(container) {
            var _this = this;

            this.dom = $('<form class="drugeditor-editview-form"></form>').appendTo(container);
            this.dom.form({});

            this.AnaDataRowId = $('<input type="hidden" id="RowId">').appendTo(this.dom);
            this.ParaItemRowId = $('<input type="hidden" name="ParaItem">').appendTo(this.dom);
            this.DrugDataRowId = $('<input type="hidden" name="DrugDataRowId">').appendTo(this.dom);

            var itemRow = $('<div class="drugeditor-editview-f-r"><div class="label">药品项：</div></div>').appendTo(this.dom);
            this.ParaItem = $('<span class="drugeditor-editview-drugitem" style="width:193px;"></span>').appendTo(itemRow);
            this.DataItemRowId = $('<input type="hidden" name="DataItem">').appendTo(itemRow);

            var itemRow = $('<div class="drugeditor-editview-f-r" style="display:none;"><div class="label">医嘱项：</div></div>').appendTo(this.dom);
            this.DrugItem = $('<span class="drugeditor-editview-drugitem"></span>').appendTo(itemRow);
            this.DrugItemID = $('<input type="hidden" name="DrugItem">').appendTo(itemRow);
            this.ArcimID = $('<input type="hidden" name="ArcimID">').appendTo(itemRow);
            this.DrugItemDesc = $('<input type="hidden" name="DrugItemDesc">').appendTo(itemRow);

            var timeRow = $('<div class="drugeditor-editview-f-r"></div>').appendTo(this.dom);
            var label = $('<div class="label">开始时间：</div>').appendTo(timeRow);
            this.StartDT = $('<input type="text">').appendTo(timeRow);
            this.StartDT.datetimebox({
                required: true,
                width: 200,
                label: label,
                onChange: function(newValue, oldValue) {

                }
            });

            var speedRow = $('<div class="drugeditor-editview-f-r"></div>').appendTo(this.dom);
            var label = $('<div class="label">原速度：</div>').appendTo(speedRow);
            this.OriginalSpeed = $('<input class="textbox" type="text" disabled style="width:81px;margin-right:5px;">').appendTo(speedRow);
            this.OriginalSpeedUnit = $('<input type="text" disabled class="drugeditor-editview-f-r-unit" style="width:95px;">').appendTo(speedRow);
            this.OriginalSpeed.validatebox({
                width: 100,
                label: label,
                novalidate: true,
                disabled: true
            });
            this.OriginalSpeedUnit.validatebox({
                width: 95,
                disabled: true,
                novalidate: true,
                cls: 'drugeditor-editview-f-r-unit'
            });

            var speedRow = $('<div class="drugeditor-editview-f-r"></div>').appendTo(this.dom);
            var label = $('<div class="label">修改速度：</div>').appendTo(speedRow);
            this.Speed = $('<input class="textbox" type="text" style="width:81px;margin-right:5px;">').appendTo(speedRow);
            this.SpeedUnit = $('<input type="text" disabled class="drugeditor-editview-f-r-unit" style="width:95px;">').appendTo(speedRow);
            this.Speed.validatebox({
                width: 100,
                label: label,
                novalidate: true
            });
            this.SpeedUnit.validatebox({
                width: 95,
                disabled: true,
                novalidate: true,
                cls: 'drugeditor-editview-f-r-unit'
            });
        },
        loadData: function(data) {
            this.originalData = data;
            this.OriginalSpeed.validatebox("setValue", data.DrugData.Speed);
            this.OriginalSpeedUnit.validatebox("setValue", data.DrugData.SpeedUnitDesc);
            this.SpeedUnit.validatebox("setValue", data.DrugData.SpeedUnitDesc);
            this.AnaDataRowId.val(data.RowId);
            this.DrugDataRowId.val(data.DrugData.RowId);
            this.ParaItem.text(data.ParaItemDesc);
        },
        setStartDT: function(startDT) {
            var startDateTime = startDT.format(constant.dateTimeFormat);
            this.StartDT.datetimebox("setValue", startDateTime);
        },
        clear: function() {
            this.dom.form('clear');
            this.DrugItem.text('');
        },
        toData: function() {
            var startDateTtime = this.StartDT.datetimebox("getValue");
            var arr = startDateTtime.split(' ');
            var startDate = startTime = '';
            if (arr.length > 1) {
                startDate = arr[0];
                startTime = arr[1];
            }

            var startDT = (new Date()).tryParse(startDT, constant.dateTimeFormat);
            var originalData = this.originalData;
            var endDateTime = originalData.EndDateTime;
            var endDate = originalData.EndDate;
            var endTime = originalData.EndTime;
            var endDT = originalData.EndDT;
            var dataList = [];

            var newData = {
                RowId: '',
                StartDate: startDate,
                StartTime: startTime,
                EndDate: endDate,
                EndTime: endTime,
                DataValue: '',
                EditFlag: 'N',
                FromData: originalData.RowId,
                StartDateTime: startDateTtime,
                EndDateTime: endDateTime,
                StartDT: startDT,
                EndDT: endDT,
                Continuous: 'Y',
                ParaItem: originalData.ParaItem,
                CategoryItem: originalData.CategoryItem,
                DataItem: originalData.DataItem,
                DataItemDesc: originalData.DataItemDesc,
                ItemCategory: originalData.ItemCategory,
                DrugData: $.extend({}, this.originalData.DrugData, {
                    RowId: '',
                    Speed: this.Speed.validatebox("getValue")
                })
            };
            dataList.push(newData);

            $.extend(this.originalData, {
                EndDate: startDate,
                EndTime: startTime,
                EndDateTime: startDateTtime,
                EndDT: startDT
            });
            dataList.push(this.originalData);

            return dataList;
        }
    }
}));