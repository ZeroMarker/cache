//
/**
 * 麻醉记费结果生成
 * @author yongyang 2018-12-26
 */
(function(global, factory) {
    if (!global.chargeView) factory(global.chargeView = {});
}(this, function(exports) {

    function init(opt) {
        var view = new ChargeView(opt);
        exports.instance = view;
        return view;
    }

    exports.init = init;

    function ChargeView(opt) {
        this.options = $.extend({ width: 710, height: 530 }, opt);
        this.saveHandler = opt.saveHandler;
        this.retrieveHandler = opt.retrieveHandler;
        this.savePrintLogHandler = opt.savePrintLogHandler;
        this.auditHandler = opt.auditHandler;
        this.generateHandler = opt.generateHandler;

        this.comboDataSource = opt.comboDataSource;

        this.schedule = this.options.operSchedule;
        this.addview = addview;
        this.isItemLoaded = true;
        this.printCount = 0;
        this.init();
    }

    ChargeView.prototype = {
        constructor: ChargeView,
        init: function() {
            var _this = this;
            this.dom = $('<div></div>').appendTo('body');
            var buttons = $('<div></div>');
            this.btn_save = $('<a href="#"></a>').linkbutton({
                text: '保存',
                disabled: true,
                iconCls: 'icon-w-save',
                onClick: function() {
                    _this.save();
                }
            }).appendTo(buttons);
            this.btn_audit = $('<a href="#"></a>').linkbutton({
                text: '审核',
                disabled: false, //权限控制未实现，通过安全组配置实现？
                iconCls: 'icon-w-submit',
                onClick: function() {
                    _this.audit();
                }
            }).appendTo(buttons);
            var btn_cancel = $('<a href="#"></a>').linkbutton({
                text: '关闭',
                iconCls: 'icon-w-cancel',
                onClick: function() {
                    _this.close();
                }
            }).appendTo(buttons);

            this.header = $('<div class="chargeview-header"></div>').appendTo(this.dom);
            this.itemContainer = $('<div class="chargeview-container" style="margin-left:10px;"></div>').appendTo(this.dom);

            this.dom.dialog({
                left: 300,
                top: 50,
                height: this.options.height,
                width: this.options.width,
                title: '记费项目登记',
                iconCls: 'icon-w-edit',
                modal: true,
                closed: true,
                resizable: true,
                checkbox: true,
                buttons: buttons,
                onOpen: function() {

                },
                onClose: function() {
                    _this.clear();
                }
            });

            //this.initHeader();
            this.initGrid();
            this.addview.init({
                saveHandler: function(data) {
                    if (_this.saveHandler) _this.saveHandler(data, function() {
                        _this.retrieve();
                    });
                }
            });
            this.addview.setComboDataSource(this.comboDataSource);
        },
        /**
         * 初始头部
         */
        initHeader: function() {
            var _this = this;

            var btn_add = $('<a href="#"></a>').linkbutton({
                text: '新增',
                iconCls: 'icon-add',
                onClick: function() {
                    _this.add();
                }
            }).appendTo(this.header);

            var btn_generate = $('<a href="#" style="margin-left:10px;"></a>').linkbutton({
                text: '生成',
                iconCls: 'icon-listitem',
                onClick: function() {
                    _this.generate();
                }
            }).appendTo(this.header);
        },
        /**
         * 初始化表格
         */
        initGrid: function() {
            var _this = this;
            var options = this.options;
            var uomList = this.comboDataSource.DoseUnits || [];
            var datagrid = $('<table></table>').appendTo(this.itemContainer);
            datagrid.datagrid({
                width: 690,
                height: 433,
				toolbar:"<div style='padding:5px'><a href='#' id='btnAdd'>新增</a><a href='#' id='btnGenerate'>生成</a></div>",
				bodyCls:"panel-header-gray",
                singleSelect: false,
                rownumbers: true,
                headerCls: 'panel-header-gray',
                frozenColumns: [
                    [{
                        field: "CheckStatus",
                        checkbox: true
                    }]
                ],
                columns: [
                    [{
                            field: "operator",
                            title: "操作",
                            width: 40,
                            hidden: false,
                            formatter: function(value, row, index) {
                                var htmlArr = [];
                                if (!row.AuditUser) {
                                    htmlArr.push("<a href='javascript:;' class='chargeview-tool-delete l-btn l-btn-small l-btn-plain' iconcls='icon-cancel' title='删除此项收费' group='' id='' rowIndex='" + index + "' data-rowid='" + row.RowId + "'>");
                                    htmlArr.push("<span class='l-btn-left l-btn-icon-left'><span class='l-btn-text l-btn-empty'>&nbsp;</span><span class='l-btn-icon icon-cancel'>&nbsp;</span></span>");
                                    htmlArr.push("</a>");
                                }
                                return htmlArr.join("");
                            }
                        },
                        { field: "RowId", title: "收费记录ID", width: 60, hidden: true },
                        { field: "ChargeDT", title: "时间", width: 160, editor: 'datetimebox' },
                        { field: "ArcimDesc", title: "医嘱名称", width: 140 },
                        { field: "PrescribedDose", title: "剂量", width: 60, editor: 'validatebox' },
                        {
                            field: "DoseUnitDesc",
                            title: "剂量单位",
                            width: 50,
                            editor: {
                                type: "combobox",
                                options: {
                                    textField: 'Description',
                                    valueField: 'Description',
                                    data: uomList,
                                    onSelect: function(row) {
                                        _this.selectedDoseUom = row;
                                    }
                                }
                            }
                        },
                        { field: "Qty", title: "数量", width: 50, editor: 'numberbox' },
                        { field: "UnitDesc", title: "单位", width: 50 },
                        { field: "Price", title: "单价", width: 60 },
                        { field: "InstrDesc", title: "用药途径", width: 120 },
                        { field: "BillDeptDesc", title: "开单科室", width: 60 },
                        { field: "ExecDeptDesc", title: "接收科室", width: 60 },
                        {
                            field: "Audited",
                            title: "已审核",
                            width: 60,
                            formatter: function(value, row, index) {
                                return (row.AuditUser ? "√" : "");
                            }
                        }
                    ]
                ],
                rowStyler: function(index, row) {
                    var style = "";
                    if (row.AuditUser) style = "color:#ccc;";
                    else if (row.errorDetected || (row.ChargeDT &&
                            row.ChargeDT.indexOf(_this.schedule.TheatreInDT.slice(0, 10)) < 0 &&
                            row.ChargeDT.indexOf(new Date().format('yyyy-MM-dd')) < 0)) style = "color:#FC522C;";
                    else if (row.AlertQty && Number(row.Qty) > Number(row.AlertQty)) {
                        style = "color:#f00;";
                    } else if (Number(row.Qty) <= 0 || Number(row.PrescribedDose) <= 0 || !row.DoseUnitDesc) {
                        style = "color:#f00;";
                    }
                    return style;
                },
                onBeforeEdit: function(index, row) {
                    _this.selectedDoseUom = null;
                    return (row.AuditUser ? false : true);
                },
                onAfterEdit: function(index, row, changes) {
                    var selectedDoseUom = _this.selectedDoseUom;
                    if (selectedDoseUom) {
                        row.DoseUnit = selectedDoseUom.ExternalID;
                        row.DoseUnitDesc = selectedDoseUom.Description;
                    }

                    row.errorDetected = false;

                    if (row.ChargeDT &&
                        row.ChargeDT.indexOf(_this.schedule.TheatreInDT.slice(0, 10)) < 0 &&
                        row.ChargeDT.indexOf(new Date().format('yyyy-MM-dd')) < 0) row.errorDetected = true;

                    _this.btn_audit.linkbutton('disable');
                    _this.btn_audit.attr('title', '请先保存后再点击审核！');
                },
                onEndEdit: function(index, row) {

                },
                onSelect: function() {

                },
                onLoadSuccess: function() {
                    _this.dom.find('.chargeview-tool-delete').click(function() {
                        _this.deleteRow(this);
                    });
                }
            });

            this.datagrid = datagrid;
            this.datagrid.datagrid('enableCellEditing');
			
			$("#btnAdd").linkbutton({
                iconCls:"icon-add",
                plain:true,
                onClick:function(){
					_this.add();
                }
            });
			
			$("#btnGenerate").linkbutton({
                iconCls:"icon-listitem",
                plain:true,
                onClick:function(){
					_this.generate();
                }
            });
			
        },
        deleteRow: function(row) {
            var _this = this;
            var datagrid = this.datagrid;
            var rowIndex = $(row).attr("rowIndex");
            var rowId = $(row).attr("data-rowid");

            $.messager.confirm("提示", "是否删除此条收费记录？", function(result) {
                if (result) {
                    if (_this.saveHandler) {
                        _this.saveHandler([{
                            ClassName: ANCLS.Model.ChargeRecordDetail,
                            RowId: rowId,
                            OperSchedule: session.OPSID,
                            UpdateUser: session.UserID,
                            isRemoved: 'Y'
                        }], function() {
                            _this.retrieve();
                        });
                    }
                }
				else
                {
                    _this.dom.find('.chargeview-tool-delete').unbind("click");
                    _this.dom.find('.chargeview-tool-delete').click(function() {
                        _this.deleteRow(this);
                    })
                }
            });
        },
        setPrintCount: function(count) {

        },
        loadData: function(data) {
            this.datagrid.datagrid('loadData', data);
        },
        open: function() {
            this.dom.dialog('open');
            this.btn_save.linkbutton('enable');
        },
        close: function() {
            this.dom.dialog('close');
        },
        clear: function() {
            var itemview = this.itemview;
            this.dom.find('.charge-item').each(function(index, e) {
                itemview.clear($(e));
            })
        },
        add: function() {
            this.addview.open();
        },
        generate: function() {
            var _this = this;
            if (this.generateHandler) this.generateHandler(function() {
                _this.retrieve();
            });
        },
        endEditing: function() {
            var datagrid = this.datagrid;
            var rows = $(datagrid).datagrid("getRows");
            var length = rows.length;
            for (var i = 0; i < length; i++) {
                datagrid.datagrid("endEdit", i);
            }
        },
        audit: function() {
            var _this = this;
            var printDatas = this.datagrid.datagrid("getSelections");
            var audittingDataList = [];
            var alertMessages = [];
            var errorMessages = [];
            if (printDatas && printDatas.length > 0) {
                $.each(printDatas, function(index, row) {
                    if (row.AuditUser) {
                        _this.datagrid.datagrid("unselectRow", index);
                        return true;
                    }
                    audittingDataList.push({
                        ClassName: ANCLS.Model.ChargeRecordDetail,
                        RowId: row.RowId
                    });
                    if (row.ChargeDT &&
                        row.ChargeDT.indexOf(_this.schedule.TheatreInDT) < 0 &&
                        row.ChargeDT.indexOf(new Date().format('yyyy-MM-dd')) < 0) {
                        alertMessages.push('<b>' + row.ArcimDesc + '</b>' + '的医嘱时间与入手术间日期<b style="color:red;">' + _this.schedule.TheatreInDT + '</b>或当前日期<b style="color:red;">' + (new Date().format('yyyy-MM-dd')) + '</b>不同');
                    }

                    if (!row.AuditUser && row.AlertQty && Number(row.Qty) > Number(row.AlertQty)) {
                        alertMessages.push('<b>' + row.ArcimDesc + '</b>' + '的数量大于<b style="color:red;">' + row.AlertQty + '</b>');
                    }

                    if (Number(row.Qty) <= 0) {
                        _this.datagrid.datagrid("unselectRow", index);
                        errorMessages.push('<b>' + row.ArcimDesc + '</b>' + '的数量不能为<b style="color:red;">0</b>');
                    } else if (Number(row.PrescribedDose) <= 0) {
                        _this.datagrid.datagrid("unselectRow", index);
                        errorMessages.push('<b>' + row.ArcimDesc + '</b>' + '的剂量不能为<b style="color:red;">0</b>');
                    } else if (!row.DoseUnitDesc) {
                        _this.datagrid.datagrid("unselectRow", index);
                        errorMessages.push('<b>' + row.ArcimDesc + '</b>' + '的剂量单位不能为<b style="color:red;">空</b>');
                    }
                });

                if (errorMessages.length > 0) {
                    $.messager.alert("药品医嘱错误，不能审核", errorMessages.join('<br/>'), "error");
                    return;
                }

                if (alertMessages.length > 0) {
                    $.messager.confirm('提示', alertMessages.join('<br/>') + '<br/>您确定继续审核吗？', function(confirmed) {
                        if (confirmed) {
                            if (_this.auditHandler) _this.auditHandler(audittingDataList, function() {
                                _this.retrieve();
                            })
                        }
                    });
                } else {
					if (audittingDataList.length==0)
					{
						$.messager.alert("提示", "没有可以审核的医嘱", "error");
						return;
					}
                    else if (_this.auditHandler) _this.auditHandler(audittingDataList, function() {
                        _this.retrieve();
                    })
                }
            } else {
                $.messager.alert("操作步骤错误", "请选择要审核的医嘱！", "warning");
            }
        },
        save: function() {
            this.endEditing();
            var _this = this;
            var datagrid = this.datagrid;
            var changes = $(datagrid).datagrid("getRows");
            var deletedChanges = $(datagrid).datagrid("getChanges", "deleted");

            var savingChanges = changes;
            var removeChanges = [];
            var savingDataList = [];

            $.each(deletedChanges, function(ind, row) {
                if (row.RowId) removeChanges.push(row);
            });

            var errorDetected = false;
            $.each(savingChanges, function(ind, row) {
                var guid = dhccl.guid();
                if (row.ChargeDT &&
                    row.ChargeDT.indexOf(_this.schedule.TheatreInDT.slice(0, 10)) < 0 &&
                    row.ChargeDT.indexOf(new Date().format('yyyy-MM-dd')) < 0) errorDetected = true;
                savingDataList.push({
                    ClassName: ANCLS.Model.ChargeRecordDetail,
                    RowId: row.RowId,
                    OperSchedule: session.OPSID,
                    ChargeRecord: row.ChargeRecord,
                    UpdateUser: session.UserID,
                    PrescribedDose: row.PrescribedDose,
                    Qty: row.Qty,
                    DoseUnit: row.DoseUnit,
                    ChargeDT: row.ChargeDT
                });
            });

            if (errorDetected) {
                $.messager.alert('数据错误', '医嘱时间错误，请设置为入手术间时间到今天之内的时间', 'error');
                return;
            }

            $.each(removeChanges, function(ind, row) {
                if (row.RowId)
                    savingDataList.push({
                        ClassName: ANCLS.Model.ChargeRecordDetail,
                        RowId: row.RowId,
                        isRemoved: 'Y'
                    });
            });

            if (this.saveHandler) {
                this.saveHandler(savingDataList, function() {
                    _this.retrieve();
                });
                this.btn_audit.linkbutton('enable');
                this.btn_audit.attr('title', '');
            }
        },
        retrieve: function() {
            var _this = this;
            if (this.retrieveHandler) {
                this.retrieveHandler(function(data) {
                    _this.loadData(data);
                    _this.btn_save.linkbutton('enable');
                })
            }
        }
    }
	
    /**
     * 添加医嘱界面
     */
    var addview = {
        /**
         * 初始化
         */
        init: function(opt) {
            var _this = this;
            this.dom = $('<div></div>').appendTo('body');
            this.saveHandler = opt.saveHandler;
            this.form = $('<form class="editview-form"></form>')
                .form({})
                .appendTo(this.dom);

            var buttons = $('<div></div>');
            this.btn_save = $('<a href="#"></a>').linkbutton({
                text: '新增',
                iconCls: 'icon-w-save',
                onClick: function() {
                    _this.save();
                }
            }).appendTo(buttons);
            var btn_cancel = $('<a href="#"></a>').linkbutton({
                text: '取消',
                iconCls: 'icon-w-cancel',
                onClick: function() {
                    _this.close();
                }
            }).appendTo(buttons);

            this.dom.dialog({
                left: 475,
                top: 165,
                height: 288,
                width: 320,
                title: '添加医嘱',
				iconCls: 'icon-w-add',
                modal: true,
                closed: true,
                resizable: true,
                buttons: buttons,
                onOpen: function() {
                    _this.clear();
                },
                onClose: function() {}
            });

            this.initForm();
        },
        /**
         * 初始化表单
         */
        initForm: function() {
            var _this = this;
            this.Price = $('<input type="hidden">').appendTo(this.form);

            var row = $('<div class="editview-f-rhisui"><div class="label">医嘱项</div></div').appendTo(this.form);
            this.Arcim = $('<input type="text" style="width:180px;">').appendTo(row);
            this.Arcim.combogrid({
                panelWidth: 450,
				required: true,
                panelHeight: 400,
                delay: 300,
                pageSize: 10,
                pageNumber: 1,
                pagination: true,
                mode: 'remote',
                idField: "ArcimId",
                textField: "ArcimDesc",
                url: ANCSP.MethodService,
                onBeforeLoad: function(param) {
                    param.ClassName = CLCLS.BLL.OEOrder;
                    param.MethodName = "GetArcimJSON";
                    param.Arg1 = param.page;
                    param.Arg2 = param.rows;
                    param.Arg3 = param.q ? param.q : "";
                    param.Arg4 = session.ExtGroupID;
                    param.Arg5 = session.ExtDeptID;
                    param.Arg6 = session.EpisodeID;
                    param.Arg7 = session.UserID;
                    param.ArgCnt = 7;
                },
                columns: [
                    [
                        { field: "ArcimId", title: "ID", hidden: true },
                        { field: "ArcimDesc", title: "医嘱项目", width: 330 },
                        { field: "BaseUomDesc", title: "单位", width: 40 },
                        { field: "Price", title: "单价", width: 60 }
                    ]
                ],
                onSelect: function(index, row) {
                    _this.Price.val(row.Price);
                    _this.setRecevieLoc(row.ArcimId);
                }
            });

            var row = $('<div class="editview-f-rhisui"><div class="label">剂量</div></div').appendTo(this.form);
            this.DoseQty = $('<input class="textbox" type="text" style="width:83px;margin-right:5px;">').appendTo(row);
            this.DoseUnit = $('<input type="text">').appendTo(row);
            this.DoseQty.validatebox({
                width: 90,
                required: true
            });
            this.DoseUnit.combobox({
                width: 85,
                required: true,
                valueField: "ExternalID",
                textField: "Description",
                cls: 'drugeditor-editview-f-r-unit'
            });

            var row = $('<div class="editview-f-rhisui"><div class="label">数量</div></div').appendTo(this.form);
            this.Qty = $('<input class="textbox" type="text" style="width:93px;margin-right:5px;">').appendTo(row);
            this.Unit = $('<input type="text">').appendTo(row);
            this.Qty.numberbox({
                width: 90,
                required: true
            });
            this.Unit.combobox({
                width: 85,
                required: true,
                valueField: "RowId",
                textField: "Description",
                cls: 'drugeditor-editview-f-r-unit',
                url: ANCSP.DataQuery,
                onBeforeLoad: function(param) {
                    param.ClassName = CLCLS.BLL.Admission;
                    param.QueryName = "FindUom";
                    param.ArgCnt = 0;
                }
            });

            var row = $('<div class="editview-f-rhisui"><div class="label">接收科室</div></div').appendTo(this.form);
            this.ExecDept = $('<input type="text" style="width:180px;">').appendTo(row);
            this.ExecDept.combobox({
                required: true,
                valueField: "RowId",
                textField: "Description",
                url: ANCSP.DataQuery,
                onBeforeLoad: function(param) {
                    param.ClassName = CLCLS.BLL.Admission;
                    param.QueryName = 'FindLocation';
                    param.Arg1 = '';
                    param.Arg2 = 'D^E^O^AN^OP';
                    param.ArgCnt = 2;
                }
            });

            var row = $('<div class="editview-f-rhisui" style="margin-bottom:0px"><div class="label">用药途径</div></div').appendTo(this.form);
            this.Instruction = $('<input type="text" style="width:180px;">').appendTo(row);
            this.Instruction.combobox({
                valueField: "RowId",
                textField: "Description",
                url: ANCSP.DataQuery,
                onBeforeLoad: function(param) {
                    param.ClassName = CLCLS.BLL.Admission;
                    param.QueryName = 'FindInstruction';
                    param.Arg1 = '';
                    param.ArgCnt = 1;
                }
            });
        },
        setComboDataSource: function(comboDataSource) {
            if (comboDataSource.DoseUnits) this.DoseUnit.combobox('loadData', comboDataSource.DoseUnits);
        },
        setRecevieLoc: function(arcimId) {
            var receiveLocId = dhccl.getDatas(ANCSP.MethodService, {
                ClassName: CLCLS.BLL.Admission,
                MethodName: 'GetReceiveLoc',
                Arg1: session.OPSID,
                Arg2: arcimId,
                ArgCnt: 2
            }, 'text', false);
            this.ExecDept.combobox('setValue', receiveLocId);
        },
        /**
         * 清空
         */
        clear: function() {
            this.form.form('clear');
        },
        /**
         * 打开
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
         * 转换为数据形式
         */
        toData: function() {
            return {
                RowId: "",
                PrescribedDose: this.DoseQty.val(),
                ActualDose: this.DoseQty.val(),
                DoseUnit: this.DoseUnit.combobox('getValue'),
                Qty: this.Qty.numberbox('getValue'),
                Unit: this.Unit.combobox('getValue'),
                Instruction: this.Instruction.combobox('getValue'),
                OperSchedule: session.OPSID,
                UpdateUser: session.UserID,
                CreateUser: session.UserID,
                BillDept: session.DeptID,
                ExecDept: this.ExecDept.combobox('getValue'),
                ArcimID: this.Arcim.combogrid('getValue'),
                ArcimDesc: this.Arcim.combogrid('getText'),
                Price: this.Price.val()
            }
        },
        /**
         * 保存
         */
        save: function() {
            if (this.form.form('validate')) {
                var data = this.toData();
                if (this.saveHandler) {
                    this.saveHandler(data);
                }

                this.close();
            }
        }
    };
}));