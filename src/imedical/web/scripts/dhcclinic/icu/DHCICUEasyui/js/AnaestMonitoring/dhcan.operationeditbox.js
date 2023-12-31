//
/**
 * 手术名称、医生编辑界面 // 暂不支持同时创建多个
 * @param {object} options - 初始化对象 or 方法名
 * @param {object} param - 方法参数
 * @returns {object} 初始化之后的返回对象 or 方法执行结果
 * @author yongyang 2017-11-09
 */
(function($) {
    $.fn.operationeditbox = function(options, param) {
        if (typeof options == "string") {
            var method = $.fn.operationeditbox.methods[options];
            if (method) return method($(this), param);
        } else {
            var state = $(this).data("operationeditbox");
            if (state) {
                $.extend(state.options, options);
            } else {
                $(this).data("operationeditbox", {
                    options: $.extend({}, $.fn.operationeditbox.defaults, options),
                    data: []
                });
                state = $(this).data("operationeditbox");
            }
            _initiate(this);
            return this;
        }
    }

    $.fn.operationeditbox.methods = {
        dataItem: function(target) {
            return $(target).data("DataItem");
        },
        options: function(target) {
            return $(target).data("operationeditbox").options;
        },
        datagrid: function(target) {
            return $(target).data("operationeditbox").datagrid;
        },
        dialog: function(target) {
            return $(target).data("operationeditbox").dialog;
        },
        form: function(target) {
            return $(target).data("operationeditbox").form;
        },
        reload: function(target, param) {
            $(target).data("datagrid").datagrid("reload");
        },
        save: function(target, param) {
            var dataItem = $(target).operationeditbox("dataItem");
            var options = $(target).operationeditbox("options");
            var datagrid = $(target).operationeditbox("datagrid");
            var changes = $(datagrid).datagrid("getRows");
            var deletedChanges = $(datagrid).datagrid("getChanges", "deleted");
            var savingChanges = changes;
            var removeChanges = [];

            $.each(deletedChanges, function(ind, row) {
                if (!row.AnaOperID == "") removeChanges.push(row);
            })

            if (options.onBeforeSave && !options.onBeforeSave.call(target, {
                    saving: savingChanges,
                    removing: removeChanges
                })) return true;

            if (savingChanges.length > 0 || removeChanges.length > 0) {
                if (!param || !param.needConfirm) saveData();
                else {
                    $.messager.confirm("请确认保存当前修改",
                        "<div style='height:52px;'>“" + dataItem.title + "”的数据已修改:" + originalText + " → " + presentText + "</div><div><em>如需保存请点击【确认】，不保存请点击【取消】</em></div>",
                        saveData);
                }

                return false;
            } else {
                if (options.onSaveSuccess) {
                    options.onSaveSuccess.call(target, $(target).operationeditbox("getDHCData"));
                }
            }

            return true;

            function saveData() {
                var fixedSavingData = {
                    ClassName: dataItem.className,
                    OperSchedule: options.operScheduleId
                };
                var savedDataList = [],
                    removedDataList = [];
                var error = false,
                    errorMsgArr = [];

                $.each(savingChanges, function(ind, row) {
                    var savingData = $.extend({}, row, fixedSavingData);
                    var result = dhccl.saveDatas(dhccl.csp.dataService, savingData); // [async = false]

                    if (result.indexOf("S^") >= 0) {
                        savedDataList.push(savingData);
                    } else {
                        error = true;
                        errorMsgArr.push(result);
                    }
                });

                $.each(removeChanges, function(ind, row) {
                    var result = dhccl.removeData(fixedSavingData.ClassName, row.AnaOperID); // [async = false]

                    if (result.indexOf("S^") >= 0) {
                        removedDataList.push(row);
                    } else {
                        error = true;
                        errorMsgArr.push(result);
                    }
                });

                if (!error) {
                    if (options.onSaveSuccess) {
                        options.onSaveSuccess.call(target, $(target).operationeditbox("getDHCData"));
                    }
                    if (options.afterSave) {
                        options.afterSave.call(target);
                    }
                } else {
                    if (options.onSaveError) {
                        options.onSaveError.call(target, errorMsgArr.join("<br>"));
                    }
                }
            }
        },
        isChanged: function(target) {
            return $(target).operationeditbox("datagrid").isChanged;
        },
        setDHCData: function(target, data) {
            var dataItem = $(target).data("DataItem");
            $(target).data("DHCData", data);
            $(target).val(data[dataItem.code] || "");
        },
        getDHCData: function(target) {
            var options = $(target).operationeditbox("options");
            var datagrid = $(target).operationeditbox("datagrid");
            var rows = $(datagrid).datagrid("getRows");
            var DHCData = $(target).data("DHCData");
            var fieldValues = {};

            $.each(rows, function(ind, row) {
                $.each(row, function(field, value) {
                    if (fieldValues[field] || (fieldValues[field] = [])) {
                        if (!(value === "")) fieldValues[field].push(value);
                    }
                });
            });

            switch (options.type) {
                case 'Plan':
                    $.extend(DHCData, {
                        PlanOperation: (fieldValues.Operation || []).join(SEPARATOR),
                        PlanOperationDesc: (fieldValues.OperationDesc || []).join(SEPARATOR),
                        PlanOperDesc: (fieldValues.OperInfo || []).join(OPERSEPARATOR),
                        PlanSurgeon: (fieldValues.Surgeon || []).join(SEPARATOR),
                        PlanSurgeonDesc: (fieldValues.SurgeonDesc || []).join(SEPARATOR),
                        PlanAssistant: (fieldValues.Assistant || []).join(SEPARATOR),
                        PlanAssistantDesc: (fieldValues.AssistantDesc || []).join(SEPARATOR),
                        PlanSurCareProv: (fieldValues.SurgeonDesc || []).concat(fieldValues.AssistantDesc).join(SEPARATOR),
                        PlanAssistant: (fieldValues.AssistantDesc || []).join(SEPARATOR),
                        PlanOperPosDesc: (fieldValues.OperPosDesc || []).join(SEPARATOR)
                    });
                    break;
                case 'Actual':
                    $.extend(DHCData, {
                        Operation: (fieldValues.Operation || []).join(SEPARATOR),
                        OperationDesc: (fieldValues.OperationDesc || []).join(SEPARATOR),
                        OperDesc: (fieldValues.OperInfo || []).join(OPERSEPARATOR),
                        Surgeon: (fieldValues.Surgeon || []).join(SEPARATOR),
                        SurgeonDesc: (fieldValues.SurgeonDesc || []).join(SEPARATOR),
                        Assistant: (fieldValues.Assistant || []).join(SEPARATOR),
                        AssistantDesc: (fieldValues.AssistantDesc || []).join(SEPARATOR),
                        SurCareProv: (fieldValues.SurgeonDesc || []).concat(fieldValues.AssistantDesc).join(SEPARATOR),
                        Assistant: (fieldValues.AssistantDesc || []).join(SEPARATOR),
                        OperPosDesc: (fieldValues.OperPosDesc || []).join(SEPARATOR)
                    });
                    break;
                default:
                    break;

            }

            return DHCData;
        },
        destory: function(target) {
            var dialog = $(target).data("dialog");
            var datagrid = $(target).data("datagrid");

            $(dialog).remove();
            $(datagrid).remove();
        },
        close: function(target) {
            var opts = $(target).operationeditbox("options");
            if (opts.onClose) {
                opts.onClose.call(target);
            }
        }
    }

    $.fn.operationeditbox.defaults = {
        width: 700,
        height: 200,
        minWidth: 500,
        dialogWidth: 700,
        dialogHeight: 540,
        keyHandler: {

        },
        mouseHandler: {

        },
        /**
         * 保存之前调用
         * @param {object} param 保存时调用的参数
         */
        onBeforeSave: null,
        /**
         * 当保存成功后调用
         * @param {object} data 保存的数据
         */
        onSaveSuccess: null,
        /**
         * 当保存失败时调用
         * @param {string} errorMsg 错误消息
         */
        onSaveError: null,
        /**
         * 关闭时调用
         * @param None
         */
        onClose: null
    }

    function _initiate(target) {
        $(target).attr("disabled", true);
        $(target).validatebox({
            novalidate: true
        });

        _initiatedatagrid(target);
        _initiateDialog(target);
    }

    function _initiatedatagrid(target) {
        var state = $(target).data("operationeditbox");
        var options = state.options;

        var toolHtmlArr = [];
        toolHtmlArr.push("<div>");
        toolHtmlArr.push("<a class=\"operationeditbox-tool-add easyui-linkbutton\" data-options=\"iconCls:\'icon-add\',plain:true\">添加</a>");
        //toolHtmlArr.push("<a class=\"operationeditbox-tool-save easyui-linkbutton\" data-options=\"iconCls:\'icon-save\',plain:true\">保存</a>");
        //toolHtmlArr.push("<a class=\"operationeditbox-tool-close easyui-linkbutton\" data-options=\"iconCls:\'icon-cancel\',plain:true\">关闭</a>");
        toolHtmlArr.push("</div>");
        var tool = $(toolHtmlArr.join(""));

        var datagrid = $("<table></table>");
        $(target).after(datagrid);

        $(datagrid).datagrid({
            width: options.width > options.minWidth ? options.width : options.minWidth,
            height: options.height,
            singleSelect: true,
            rownumbers: true,
            toolbar: tool,
            columns: [
                [{
                        field: "operator",
                        title: "操作",
                        width: 80,
                        hidden: false,
                        formatter: function(value, row, index) {
                            var html = "";
                            html += "<a href='javascript:;' class='operationeditbox-tool-edit l-btn l-btn-small l-btn-plain' iconcls='icon-edit' title='编辑此项手术' group='' id='' rowindex=" + index + ">";
                            html += "<span class='l-btn-left l-btn-icon-left'><span class='l-btn-text l-btn-empty'>&nbsp;</span><span class='l-btn-icon icon-edit'>&nbsp;</span></span>";
                            html += "</a>";
                            html += "<a href='javascript:;' class='operationeditbox-tool-delete l-btn l-btn-small l-btn-plain' iconcls='icon-remove' title='删除此项手术' group='' id='' rowindex=" + index + ">";
                            html += "<span class='l-btn-left l-btn-icon-left'><span class='l-btn-text l-btn-empty'>&nbsp;</span><span class='l-btn-icon icon-remove'>&nbsp;</span></span>";
                            html += "</a>";

                            return html;
                        }
                    },
                    { field: "AnaOperID", title: "OperID", width: 240, hidden: true },
                    { field: "OperInfo", title: "手术名称", width: 240 },
                    { field: "OperClassDesc", title: "手术分级", width: 60, hidden: true },
                    { field: "BladeTypeDesc", title: "切口类型", width: 60, hidden: true },
                    { field: "BodySiteDesc", title: "手术部位", width: 60, hidden: true },
                    { field: "OperPosDesc", title: "手术体位", width: 60, hidden: true },
                    { field: "SurgeonDesc", title: "手术医生", width: 60 },
                    { field: "AssistantDesc", title: "手术助手", width: 160 },
                    { field: "SurgeonAss1", title: "一助", width: 160, hidden: true },
                    { field: "SurgeonAss2", title: "二助", width: 160, hidden: true },
                    { field: "SurgeonAss3", title: "三助", width: 160, hidden: true },
                    { field: "SurgeonAss4", title: "四助", width: 160, hidden: true },
                    { field: "SurgeonAss5", title: "五助", width: 160, hidden: true },
                    { field: "SurgeonAss6", title: "六助", width: 160, hidden: true },
                    { field: "Note", title: "手术说明", width: 120, hidden: true },
                    { field: "OperNote", title: "名称备注", width: 60 }
                ]
            ],
            onLoadSuccess: function() {
                $($(target).parent()).find('.operationeditbox-tool-edit').unbind();
                $($(target).parent()).find('.operationeditbox-tool-edit').click(function() {
                    editRow.call(this, target);
                });
                $($(target).parent()).find('.operationeditbox-tool-delete').unbind();
                $($(target).parent()).find('.operationeditbox-tool-delete').click(function() {
                    deleteRow.call(this, target);
                });
            }
        });

        $(target).data("operationeditbox").datagrid = datagrid;
        $(datagrid).datagrid("loadData", options.data);

        _initiateButtons(target);
    }

    /**
     * 初始化表格操作按钮
     * @author yongyang 20171113
     */
    function _initiateButtons(target) {
        var state = $(target).data("operationeditbox");
        var options = state.options;

        $("a.operationeditbox-tool-add").linkbutton({
            onClick: function(e) {
                var dialog = $(target).operationeditbox("dialog");
                var form = $(target).operationeditbox("form");
                var saveButton = $(dialog).dialog("options").buttons[0];
                $.extend(saveButton, {
                    text: "新增",
                    iconCls: "icon-add"
                });
                $(dialog).dialog({
                    title: "新增手术",
                    iconCls: "icon-add"
                });
                $(dialog).dialog("open");
                $(form).form("load", getDefaultRowData(target));
            }
        });

        /*
        $("a.operationeditbox-tool-save").linkbutton({
            onClick: function(e) {
                $(target).operationeditbox("save");
            }
        });

        $("a.operationeditbox-tool-close").linkbutton({
            onClick: function(e) {
                $(target).operationeditbox("close");
            }
        });
        */
        /*
        $(state.datagrid).delegate("a.operationeditbox-tool-edit", "click", function(e) {
            var dialog = $(target).operationeditbox("dialog");
            var datagrid = $(target).operationeditbox("datagrid");
            var form = $(target).operationeditbox("form");
            var rowIndex = $(this).attr("rowindex");
            var rows = $(datagrid).datagrid("getRows");
            var selectedRow = rows[rowIndex];
            selectedRow.selectedRowIndex = rowIndex;

            var saveButton = $(dialog).dialog("options").buttons[0];
            $.extend(saveButton, {
                text: "修改",
                iconCls: "icon-edit"
            });

            $(dialog).dialog({
                title: "修改手术",
                iconCls: "icon-edit"
            });
            $(form).form("load", selectedRow);
            $(dialog).dialog("open");
        });
        $(state.datagrid).delegate("a.operationeditbox-tool-delete", "click", function(e) {
            var datagrid = $(target).operationeditbox("datagrid");
            var rowIndex = $(this).attr("rowindex");
            var rows = $(datagrid).datagrid("getRows");
            var selectedRow = rows[rowIndex];
            var rowIndex = $(datagrid).datagrid("getRowIndex", selectedRow);
            $.messager.confirm("提示", "是否删除该手术？", function(result) {
                if (result) {
                    $(datagrid).datagrid("deleteRow", rowIndex);
                }
            });
        });*/
    }

    /**
     * 编辑选中行
     * @param {*} target 
     */
    function editRow(target) {
        var dialog = $(target).operationeditbox("dialog");
        var datagrid = $(target).operationeditbox("datagrid");
        var form = $(target).operationeditbox("form");
        var rowIndex = $(this).attr("rowindex");
        var rows = $(datagrid).datagrid("getRows");
        var selectedRow = rows[rowIndex];
        selectedRow.selectedRowIndex = rowIndex;

        var saveButton = $(dialog).dialog("options").buttons[0];
        $.extend(saveButton, {
            text: "修改",
            iconCls: "icon-edit"
        });

        $(dialog).dialog({
            title: "修改手术",
            iconCls: "icon-edit"
        });
        $(form).form("load", selectedRow);
        $(dialog).dialog("open");
    }

    /**
     * 删除选中行
     * @param {*} target 
     */
    function deleteRow(target) {
        var datagrid = $(target).operationeditbox("datagrid");
        var rowIndex = $(this).attr("rowindex");
        var rows = $(datagrid).datagrid("getRows");
        var selectedRow = rows[rowIndex];
        var rowIndex = $(datagrid).datagrid("getRowIndex", selectedRow);
        $.messager.confirm("提示", "是否删除该手术？", function(result) {
            if (result) {
                $(datagrid).datagrid("deleteRow", rowIndex);
            }
        });
    }

    /**
     * 获取默认行数据
     */
    function getDefaultRowData(target) {
        var state = $(target).data("operationeditbox");
        var datagrid = $(target).operationeditbox("datagrid");
        var options = state.options;
        var DHCData = $(target).data("DHCData");
        var row = {};
        var appDeptID = DHCData.AppDeptID,
            operList = $(datagrid).datagrid("getRows"),
            surgeonDeptID = "";
        if (operList && operList.length > 0) {
            var lastOper = operList[operList.length - 1];
            surgeonDeptID = lastOper.SurgeonDeptID;
        } else if (appDeptID && (Number(appDeptID)) > 0) {
            surgeonDeptID = appDeptID;
        } else {
            surgeonDeptID = session.DeptID;
        }
        row.SurgeonDeptID = surgeonDeptID;
        return row;
    }

    /**
     * 初始化编辑模态框
     * @param {object} target 
     */
    function _initiateDialog(target) {
        var state = $(target).data("operationeditbox");
        var options = state.options;

        var htmlArr = [];
        htmlArr.push("<div class=\"operationeditbox-dialog hisui-dialog\" data-options=\"closed:true,width:600,height:450,modal:true\">");
        htmlArr.push("<form class='operationeditbox-form'>");
        htmlArr.push("<table class=\"form-table\">");
        htmlArr.push("<tr><td>手术名称</td>");
        htmlArr.push("<td colspan=\"3\">");
        htmlArr.push("<input name=\"Operation\" class=\"dhccl-combobox\" style=\"width:500px\" data-options=\"\">");
        htmlArr.push("<input type=\"hidden\" name=\"OperationDesc\">");
        htmlArr.push("</td></tr>");
        htmlArr.push("<tr><td>名称备注</td>");
        htmlArr.push("<td colspan=\"3\">");
        htmlArr.push("<input name=\"OperNote\" class=\"textbox\" style=\"width:493px\">")
        htmlArr.push("</td></tr>");
        htmlArr.push("<tr><td>手术分级</td>");
        htmlArr.push("<td>")
        htmlArr.push("<input name=\"OperClass\" class=\"dhccl-combobox\" data-options=\"required:false\">");
        htmlArr.push("<input type=\"hidden\" name=\"OperClassDesc\">");
        htmlArr.push("</td>");
        htmlArr.push("<td>切口类型</td>");
        htmlArr.push("<td>");
        htmlArr.push("<input name=\"BladeType\" class=\"dhccl-combobox\" data-options=\"required:false\">");
        htmlArr.push("<input type=\"hidden\" name=\"BladeTypeDesc\">");
        htmlArr.push("</td>");
        htmlArr.push("</tr>");
        htmlArr.push("<tr><td>手术部位</td>");
        htmlArr.push("<td>");
        htmlArr.push("<input name=\"BodySite\" class=\"dhccl-combobox\" data-options=\"required:false\">");
        htmlArr.push("<input type=\"hidden\" name=\"BodySiteDesc\">");
        htmlArr.push("</td>");
        htmlArr.push("<td>手术体位</td>");
        htmlArr.push("<td>");
        htmlArr.push("<input name=\"OperPos\" class=\"dhccl-combobox\" data-options=\"\">");
        htmlArr.push("<input type=\"hidden\" name=\"OperPositionDesc\">");
        htmlArr.push("</td>");
        htmlArr.push("</tr>");
        htmlArr.push("<tr>");
        htmlArr.push("<td>术者科室</td>");
        htmlArr.push("<td>");
        htmlArr.push("<input name=\"SurgeonDeptID\" class=\"dhccl-combobox\" data-options=\"required:false\">");
        htmlArr.push("<input type=\"hidden\" name=\"SurgeonDeptDesc\">");
        htmlArr.push("</td>");
        htmlArr.push("<td>手术医生</td>");
        htmlArr.push("<td>");
        htmlArr.push("<input name=\"Surgeon\" class=\"dhccl-combobox\" data-options=\"required:false\">");
        htmlArr.push("<input type=\"hidden\" name=\"SurgeonDesc\">");
        htmlArr.push("</td>");
        htmlArr.push("</tr>");
        htmlArr.push("<tr>");
        htmlArr.push("<td>手术一助</td>");
        htmlArr.push("<td><input name=\"SurgeonAss1\" class=\"dhccl-combobox\"></td>");
        htmlArr.push("<td>手术二助</td>");
        htmlArr.push("<td><input name=\"SurgeonAss2\" class=\"dhccl-combobox\"></td>");
        htmlArr.push("</tr>");
        htmlArr.push("<tr>");
        htmlArr.push("<td>手术三助</td>");
        htmlArr.push("<td><input name=\"SurgeonAss3\" class=\"dhccl-combobox\"></td>");
        htmlArr.push("<td>手术四助</td>");
        htmlArr.push("<td><input name=\"SurgeonAss4\" class=\"dhccl-combobox\"></td>");
        htmlArr.push("</tr>");
        htmlArr.push("<tr>");
        htmlArr.push("<td>手术五助</td>");
        htmlArr.push("<td><input name=\"SurgeonAss5\" class=\"dhccl-combobox\"></td>");
        htmlArr.push("<td>手术六助</td>");
        htmlArr.push("<td><input name=\"SurgeonAss6\" class=\"dhccl-combobox\"></td>");
        htmlArr.push("</tr>");
        htmlArr.push("<tr>");
        htmlArr.push("<td>进修实习</td>");
        htmlArr.push("<td><input type=\"text\" name=\"AddtionalStaff\" style=\"width:182px\" class=\"textbox\"></td>");
        htmlArr.push("<td>手术说明</td>");
        htmlArr.push("<td><input name=\"Note\" style=\"width:182px\"></input></td>");
        htmlArr.push("</tr>");
        htmlArr.push("</table>");
        htmlArr.push("<input type=\"hidden\" name=\"AnaOperID\">");
        htmlArr.push("<input type=\"hidden\" name=\"OperationInfo\">");
        htmlArr.push("<input type=\"hidden\" name=\"AssistantDesc\">");
        htmlArr.push("<input type=\"hidden\" name=\"Assistant\">");
        htmlArr.push("<input type=\"hidden\" name=\"selectedRowIndex\">");
        htmlArr.push("</form>");
        htmlArr.push("</div>");

        var dialog = $(htmlArr.join(""));
        $(target).after(dialog);

        $(dialog).dialog({
            width: options.dialogWidth,
            height: options.dialogHeight,
            buttons: [{
                text: "新增",
                iconCls: "icon-add",
                handler: function() {
                    var datagrid = $(target).operationeditbox("datagrid");
                    var dialog = $(target).operationeditbox("dialog");
                    var form = $(target).operationeditbox("form");
                    if ($(form).form("validate")) {
                        var state = $(form).data("form");
                        var formItem = state.formItem;
                        var assistantIdArray = new Array(),
                            assistantArray = new Array();
                        formItem.SurgeonAssistant.each(function() {
                            var assistantId = $(this).combobox('getValue'),
                                assistant = $(this).combobox('getText');
                            if (assistantId != "") {
                                assistantIdArray.push(assistantId);
                                assistantArray.push(assistant);
                            }
                        });
                        formItem.SurgeonAssistantID.val(assistantIdArray.join(SEPARATOR));
                        formItem.SurgeonAssistantDesc.val(assistantArray.join(SEPARATOR));

                        var operationData = $(form).serializeJson();
                        operationData.OperInfo = (operationData.OperationDesc || operationData.OperNote);

                        if (operationData.selectedRowIndex === "") {
                            $(datagrid).datagrid("appendRow", operationData);
                        } else if (operationData.selectedRowIndex >= 0) {
                            var selectedIndex = operationData.selectedRowIndex;
                            var selectedRow = $(datagrid).datagrid("getRows")[selectedIndex];
                            $(datagrid).datagrid("updateRow", {
                                index: selectedIndex,
                                row: operationData
                            });
                        } else {
                            // do nothing
                        }
                        $($(target).parent()).find('.operationeditbox-tool-edit').unbind();
                        $($(target).parent()).find('.operationeditbox-tool-edit').click(function() {
                            editRow.call(this, target);
                        });
                        $($(target).parent()).find('.operationeditbox-tool-delete').unbind();
                        $($(target).parent()).find('.operationeditbox-tool-delete').click(function() {
                            deleteRow.call(this, target);
                        });

                        $(dialog).dialog("close");
                    }
                }
            }, {
                text: "取消",
                iconCls: "icon-cancel",
                handler: function() {
                    var dialog = $(target).operationeditbox("dialog");
                    $(dialog).dialog("close");
                }
            }],
            onClose: function() {
                var form = $(target).operationeditbox("form");
                $(form).form("clear");
            }
        });

        $(target).data("operationeditbox").dialog = dialog;

        var form = $(dialog).find("form");
        $(target).data("operationeditbox").form = form;

        _initiateForm(target);
    }

    var SEPARATOR = ",",
        OPERSEPARATOR = "+";
    /**
     * 初始化模态框中表单
     * @param {object} target 
     */
    function _initiateForm(target) {
        var form = $(target).operationeditbox("form");
        $(form).form({
            onLoadSuccess: function(data) {
                var state = $(this).data("form");
                var formItem = state.formItem;
                $(formItem.Operation).combobox("setText", data.OperationDesc || "");
                $(formItem.Surgeon).combobox("setText", data.SurgeonDesc || "");
                $(formItem.OperClass).combobox("setText", data.OperClassDesc || "");
                $(formItem.BladeType).combobox("setText", data.BladeTypeDesc || "");
                $(formItem.OperPos).combobox("setText", data.OperPosDesc || "");
                $(formItem.BodySite).combobox("setText", data.BodySiteDesc || "");

                var assistantId = data.Assistant || "";
                var assistant = data.AssistantDesc || "";

                var assistantIdArray = assistantId.split(SEPARATOR);
                var assistantArray = assistant.split(SEPARATOR);

                formItem.SurgeonAssistant.each(function(ind) {
                    if (assistantIdArray[ind]) {
                        $(this).combobox("setValue", assistantIdArray[ind]);
                        $(this).combobox("setText", assistantArray[ind]);
                    }
                });
            }
        });

        _initiateFormItem(target);
    }

    /**
     * 初始化表单控件
     */
    function _initiateFormItem(target) {
        var form = $(target).operationeditbox("form");

        formItem.target = target;
        formItem.Operation = $($(form).find("input[name='Operation']"));
        formItem.OperationDesc = $($(form).find("input[name='OperationDesc']"));
        formItem.OperNote = $($(form).find("input[name='OperNote']"));
        formItem.OperClass = $($(form).find("input[name='OperClass']"));
        formItem.OperClassDesc = $($(form).find("input[name='OperClassDesc']"));
        formItem.BodySite = $($(form).find("input[name='BodySite']"));
        formItem.BodySiteDesc = $($(form).find("input[name='BodySiteDesc']"));
        formItem.BladeType = $($(form).find("input[name='BladeType']"));
        formItem.BladeTypeDesc = $($(form).find("input[name='BladeTypeDesc']"));
        formItem.OperPos = $($(form).find("input[name='OperPos']"));
        formItem.OperPosDesc = $($(form).find("input[name='OperPosDesc']"));
        formItem.SurgeonDept = $($(form).find("input[name='SurgeonDeptID']"));
        formItem.SurgeonDeptDesc = $($(form).find("input[name='SurgeonDeptDesc']"));
        formItem.Surgeon = $($(form).find("input[name='Surgeon']"));
        formItem.SurgeonDesc = $($(form).find("input[name='SurgeonDesc']"));

        var surgeonAssistantSelector = [];
        surgeonAssistantSelector.push("input[name='SurgeonAss1']");
        surgeonAssistantSelector.push("input[name='SurgeonAss2']");
        surgeonAssistantSelector.push("input[name='SurgeonAss3']");
        surgeonAssistantSelector.push("input[name='SurgeonAss4']");
        surgeonAssistantSelector.push("input[name='SurgeonAss5']");
        surgeonAssistantSelector.push("input[name='SurgeonAss6']");
        formItem.SurgeonAssistant = $($(form).find(surgeonAssistantSelector.join(",")));

        formItem.SurgeonAssistantID = $($(form).find("input[name='Assistant']"));
        formItem.SurgeonAssistantDesc = $($(form).find("input[name='AssistantDesc']"));
        formItem.AddtionalStaff = $($(form).find("input[name='AddtionalStaff']"));
        formItem.Note = $($(form).find("input[name='Note']"));

        formItem.form = form;
        $(form).data("form").formItem = formItem;
        formItem.render.call(formItem);
    }

    var formItem = {
        /**
         * 表单项目：手术名称
         */
        Operation: null,
        OperationDesc: null,
        /**
         * 表单项目：手术备注
         */
        OperNote: null,
        /**
         * 表单项目：手术分级
         */
        OperClass: null,
        OperClassDesc: null,
        /**
         * 表单项目：手术部位
         */
        BodySite: null,
        BodySiteDesc: null,
        /**
         * 表单项目：手术切口
         */
        BladeType: null,
        BladeTypeDesc: null,
        /**
         * 表单项目：手术体位
         */
        OperPos: null,
        OperPosDesc: null,
        /**
         * 表单项目：术者科室
         */
        SurgeonDept: null,
        SurgeonDeptDesc: null,
        /**
         * 表单项目：手术助手（多个助手置于此数组中）
         */
        SurgeonAssistant: null,
        /**
         * 表单项目：手术主刀医生
         */
        Surgeon: null,
        SurgeonDesc: null,
        /**
         * 表单项目：手术助手的ID（多个助手的值组成字符串）
         */
        SurgeonAssistantID: null,
        /**
         * 表单项目：手术助手的描述（多个助手的描述组成字符串）
         */
        SurgeonAssistantDesc: null,
        /**
         * 表单项目：实习进修
         */
        AddtionalStaff: null,
        /**
         * 表单项目：备注
         */
        Note: null,
        /**
         * 对应的表单
         */
        form: null,
        /**
         * 对应的编辑框对象
         */
        target: null,
        /**
         * 渲染方法
         */
        render: function() {
            this.Operation.data("FormItem", this);
            this.SurgeonAssistant.data("FormItem", this);
            this.Surgeon.data("FormItem", this);
            this.OperClass.data("FormItem", this);
            this.BladeType.data("FormItem", this);
            this.BodySite.data("FormItem", this);
            this.OperPos.data("FormItem", this);

            var options = $(this.target).operationeditbox("options");
            this.SurgeonDept.combobox({
                url: ANCSP.DataQuery,
                queryParams: options.queryParams.surgeonDept,
                valueField: "RowId",
                textField: "Description",
                // mode: "remote"
                onBeforeLoad: function(param) {
                    var opts = $(this).data('combobox').options;
                    var formItem = $(this).data("FormItem");
                    param.Arg1 = '';
                    opts.url = composeUrl(ANCSP.DataQuery, $.extend(opts.queryParams, param));
                },
                filter: function(q, row) {
                    q = q.toUpperCase();
                    var opts = $(this).combobox('options');
                    return (row[opts.valueField] === q) || (row[opts.textField].indexOf(q) > -1) || ((row['Alias'] || '').indexOf(q) > -1);
                }
            });

            //助手，值修改时更新表单隐藏元素值
            this.SurgeonAssistant.combobox({
                valueField: "RowId",
                textField: "Description",
                filter: function(q, row) {
                    q = q.toUpperCase();
                    var opts = $(this).combobox('options');
                    return (row[opts.valueField] === q) || (row[opts.textField].indexOf(q) > -1) || ((row['ShortDesc'] || '').indexOf(q) > -1);
                },
                onShowPanel: function() {
                    var formItem = $(this).data("FormItem");
                    var datas = $(this).combobox("getData"),
                        options = $(this).combobox("options"),
                        surgeonDeptID = formItem.SurgeonDept.combobox("getValue");

                    if (!datas || datas.length <= 0) {
                        datas = formItem.loader.surgeons.call(formItem);
                        $(this).combobox("loadData", datas);
                    } else if (options.surgeonDeptID != surgeonDeptID) {
                        datas = formItem.loader.surgeons.call(formItem);
                        $(this).combobox("loadData", datas);
                    }

                    options.surgeonDeptID = surgeonDeptID;
                },
                onSelect: function(record) {
                    var _this = this;
                    var formItem = $(this).data("FormItem");
                    var assistantIdArray = new Array(),
                        assistantArray = new Array();
                    formItem.SurgeonAssistant.each(function() {
                        var assistantId = $(this).combobox('getValue'),
                            assistant = $(this).combobox('getText');
                        if (_this === this) {
                            assistantId = record.RowId;
                            assistant = record.Description;
                        }
                        if (assistantId != "") {
                            assistantIdArray.push(assistantId);
                            assistantArray.push(assistant);
                        }
                    });
                    formItem.SurgeonAssistantID.val(assistantIdArray.join(SEPARATOR));
                    formItem.SurgeonAssistantDesc.val(assistantArray.join(SEPARATOR));
                }
            });

            //主刀加载
            this.Surgeon.combobox({
                valueField: "RowId",
                textField: "Description",
                filter: function(q, row) {
                    q = q.toUpperCase();
                    var opts = $(this).combobox('options');
                    return (row[opts.valueField] === q) || (row[opts.textField].indexOf(q) > -1) || ((row['ShortDesc'] || '').indexOf(q) > -1);
                },
                onShowPanel: function() {
                    var formItem = $(this).data("FormItem");
                    var datas = $(this).combobox("getData"),
                        options = $(this).combobox("options"),
                        surgeonDeptID = formItem.SurgeonDept.combobox("getValue");

                    if (!datas || datas.length <= 0) {
                        datas = formItem.loader.surgeons.call(formItem);
                        $(this).combobox("loadData", datas);
                    } else if (options.surgeonDeptID != surgeonDeptID) {
                        datas = formItem.loader.surgeons.call(formItem);
                        $(this).combobox("loadData", datas);
                    }

                    options.surgeonDeptID = surgeonDeptID;
                },
                onSelect: function(record) {
                    var formItem = $(this).data("FormItem");
                    formItem.SurgeonDesc.val(record.Description);
                }
            });

            this.Operation.combobox({
                url: ANCSP.DataQuery,
                onBeforeLoad: function(param) {
                    var opts = $(this).data('combobox').options;
                    var formItem = $(this).data("FormItem");
                    param.Arg2 = formItem.Surgeon.combobox("getValue");
                    param.Arg3 = formItem.SurgeonDept.combobox("getValue");
                    opts.url = composeUrl(ANCSP.DataQuery, $.extend(opts.queryParams, param));
                },
                queryParams: options.queryParams.operation,
                valueField: "RowId",
                textField: "ICDDesc",
                mode: "remote",
                onSelect: function(record) {
                    var formItem = $(this).data("FormItem");

                    if (formItem.OperClass && record.OperClass) {
                        formItem.OperClass.combobox("setValue", record.OperClass);
                    }
                    if (formItem.BladeType && record.BladeType) {
                        formItem.BladeType.combobox("setValue", record.BladeType);
                    }
                    if (formItem.BodySite && record.BodySite) {
                        formItem.BodySite.combobox("setValue", record.BodySite);
                    }
                    if (formItem.OperPos && record.OperPos) {
                        formItem.OperPos.combobox("setValue", record.OperPos);
                    }
                    formItem.OperationDesc.val(record.ICDDesc);
                }
            });

            this.OperClass.combobox({
                data: options.queryData.operClassList,
                valueField: "RowId",
                textField: "Description"
            });

            this.BladeType.combobox({
                data: options.queryData.bladeTypeList,
                valueField: "RowId",
                textField: "Description"
            });

            this.BodySite.combobox({
                data: options.queryData.bodySiteList,
                valueField: "RowId",
                textField: "Description"
            });

            this.OperPos.combobox({
                data: options.queryData.operPosList,
                valueField: "RowId",
                textField: "Description"
            });

            $([this.Operation, this.OperClass, this.BladeType, this.BodySite, this.OperPos]).each(function() {
                $(this).combobox({
                    onSelect: function(record) {
                        var formItem = $(this).data("FormItem");
                        var data = formItem.loader.surgeons.call(formItem);
                        $(formItem.SurgeonAssistant).combobox("loadData", data);
                        $(formItem.Surgeon).combobox("loadData", data);

                        var descItem = formItem[$(this).attr("comboname") + "Desc"];
                        if (descItem) {
                            descItem.val(record.Description);
                        }
                    }
                });
            });

            $.each([this.Note, this.OperNote, this.AddtionalStaff], function() {
                $(this).validatebox({ novalidate: true });
            });
        },
        /**
         * 数据加载，仅加载多个控件共用的数据，如：医生
         */
        loader: {
            surgeons: function() {
                var options = $(this.target).operationeditbox("options");
                var result = dhccl.getDatas(ANCSP.DataQuery, $.extend({}, options.queryParams.surgeon, {
                    Arg1: "",
                    Arg2: this.SurgeonDept.combobox("getValue")
                }), "json");
                return result;
            }
        }
    }

    function composeUrl(url, params) {
        var result = url + '?';
        var needConnectionChar = false;
        for (var key in params) {
            if (needConnectionChar) result = result + '&';
            result = result + key + '=' + params[key];
            needConnectionChar = true;
        }

        return result;
    }
})(jQuery);