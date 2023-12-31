(function($) {
    /**
     * 麻醉方法及导管信息填写界面
     * @author yongyang 20171129
     */
    $.fn.anaestmethodeditbox = function(options, param) {
        if (typeof options == "string") {
            var method = $.fn.anaestmethodeditbox.methods[options];
            if (method) return method($(this), param);
        } else {
            var state = $(this).data("anaestmethodeditbox");
            if (state) {
                $.extend(state.options, options);
            } else {
                $(this).data("anaestmethodeditbox", {
                    options: $.extend({}, $.fn.anaestmethodeditbox.defaults, options),
                    data: []
                });
                state = $(this).data("anaestmethodeditbox");
                create(this);
            }
        }
    }

    $.fn.anaestmethodeditbox.methods = {
        /**
         * 获取麻醉方法编辑框的加载项
         */
        options: function(target) {
            return $(target).data("anaestmethodeditbox").options;
        },
        /**
         * 获取麻醉方法编辑框的数据项
         */
        dataItem: function(target) {
            return $(target).data("DataItem");
        },
        /**
         * 获取麻醉方法插管明细编辑对话框
         */
        dialog: function(target) {
            return $(target).data("anaestmethodeditbox").dialog;
        },
        /**
         * 当前麻醉方法编辑框中的数据表格
         */
        datagrid: function(target) {
            return $(target).data("anaestmethodeditbox").datagrid;
        },
        /**
         * 
         */
        form: function(target) {
            return $(target).data("anaestmethodeditbox").form;
        },
        /**
         * 
         */
        infoContainer: function(target) {
            return $(target).data("anaestmethodeditbox").infoContainer;
        },
        /**
         * 
         */
        getAnaMethodInfoItems: function(target, anaMethod) {
            return anaMethodInfoItems;
        },
        infoItems: function(target) {
            return $(target).data("anaestmethodeditbox").infoItems;
        },
        /**
         * 设置麻醉记录中麻醉方法编辑框对应的麻醉记录数据
         */
        setDHCData: function(target, data) {
            $(target).data("DHCData", data);
            var dataItem = $(target).data("DataItem");
            $(target).val(data[dataItem.code]);
        },
        /**
         * 获取麻醉记录中麻醉方法编辑框对应的麻醉记录数据，用于更新record.sheet.context.schedule
         */
        getDHCData: function(target) {
            var datagrid = $(target).anaestmethodeditbox("datagrid");
            var rows = $(datagrid).datagrid("getRows");
            var methodInfoArr = [];

            $.each(rows, function(ind, row) {
                var catheterInfoArr = [];
                if (row.CatheterDesc !== "") catheterInfoArr.push(row.CatheterDesc);
                if (row.CatheterTypeDesc !== "") catheterInfoArr.push(row.CatheterTypeDesc);
                if (row.CatheterDepthDesc !== "") catheterInfoArr.push(row.CatheterDepthDesc);
                if (row.CatheterPathDesc !== "") catheterInfoArr.push(row.CatheterPathDesc);
                if (row.CatheterToolDesc !== "") catheterInfoArr.push(row.CatheterToolDesc);
                if (row.CatheterDirectionDesc !== "") catheterInfoArr.push(row.CatheterDirectionDesc);
                if (row.PunctureSpaceDesc !== "") catheterInfoArr.push(row.PunctureSpaceDesc);
                if (row.PositionMethodDesc !== "") catheterInfoArr.push(row.PositionMethodDesc);
                if (row.NerveBlockSiteDesc !== "") catheterInfoArr.push(row.NerveBlockSiteDesc);

                var catheterInfo = "";
                if (catheterInfoArr.length > 0) catheterInfo = "(" + catheterInfoArr.join(",") + ")";
                methodInfoArr.push(row.AnaMethodDesc + catheterInfo);
            });

            return { "AnaestMethod": methodInfoArr.join("+") };
        },
        /**
         * 保存手术记录对应的麻醉方法
         */
        save: function(target, param) {
            var dataItem = $(target).anaestmethodeditbox("dataItem");
            var options = $(target).anaestmethodeditbox("options");
            var datagrid = $(target).anaestmethodeditbox("datagrid");
            var changes = $(datagrid).datagrid("getRows");
            var deletedChanges = $(datagrid).datagrid("getChanges", "deleted");

            var savingChanges = changes;
            var removeChanges = [];

            $.each(deletedChanges, function(ind, row) {
                if (row.Anaesthesia) removeChanges.push(row);
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
                        function(confirmed) { if (confirmed) saveData(); });
                }

                return false;
            } else {
                if (options.onSaveSuccess) {
                    options.onSaveSuccess.call(target, $(target).anaestmethodeditbox("getDHCData"));
                }
            }

            return true;

            function saveData() {
                var savingDataList = [],
                    removedDataList = [];
                var error = false,
                    errorMsgArr = [];

                $.each(savingChanges, function(ind, row) {
                    savingDataList.push({
                        ClassName: ANCLS.Model.AnaestCatheter,
                        RowId: row.RowId,
                        AnaMethod: row.AnaMethod,
                        Anaesthesia: row.Anaesthesia,
                        Catheter: row.Catheter || '',
                        CatheterType: row.CatheterType || '',
                        CatheterDepth: row.CatheterDepth || '',
                        CatheterPath: row.CatheterPath || '',
                        CatheterTool: row.CatheterTool || '',
                        CatheterDirection: row.CatheterDirection || '',
                        PunctureSpace: row.PunctureSpace || '',
                        PositionMethod: row.PositionMethod || '',
                        NerveBlockSite: row.NerveBlockSite || ''
                    })
                });

                $.each(removeChanges, function(ind, row) {
                    if (row.Anaesthesia)
                        savingDataList.push({
                            ClassName: ANCLS.Model.AnaestCatheter,
                            RowId: row.RowId,
                            isRemoved: 'Y'
                        });
                });

                var result = dhccl.saveDatas(ANCSP.MethodService, {
                    ClassName: ANCLS.BLL.AnaestRecord,
                    MethodName: "SaveAnaestCatheter",
                    Arg1: options.operScheduleId,
                    Arg2: dhccl.formatObjects(savingDataList),
                    ArgCnt: 2
                });
                if (result.indexOf("S^") == -1) {
                    error = true;
                    errorMsgArr.push(result);
                }

                if (!error) {
                    if (options.onSaveSuccess) {
                        options.onSaveSuccess.call(target, $(target).anaestmethodeditbox("getDHCData"));
                    }
                } else {
                    if (options.onSaveError) {
                        options.onSaveError.call(target, errorMsgArr.join("<br>"));
                    }
                }
            }
        },
        /**
         * 销毁麻醉方法编辑框中所有元素
         */
        destroy: function(target) {

        },
        close: function(target) {
            var opts = $(target).anaestmethodeditbox("options");
            if (opts.onClose) {
                opts.onClose.call(target);
            }
        }
    }

    $.fn.anaestmethodeditbox.defaults = {
        infoItemPrefix: "anaestmethodeditbox_input_i_",
        width: 500,
        height: 150
    }

    /**
     * 创建麻醉方法编辑界面
     */
    function create(target) {
        var options = $(target).anaestmethodeditbox("options");
        $(target).attr("readOnly", true);
        $(target).attr("width", options.width);

        var viewContainer = $("<div></div>");
        $(target).parent().append(viewContainer);

        createDataGrid(target, viewContainer);
        createDetailPanel(target, $("body"));
    }

    function createDataGrid(target, container) {
        var state = $(target).data("anaestmethodeditbox");
        var options = $(target).anaestmethodeditbox("options");
        var datagrid = $("<table></table>");
        $(container).append(datagrid);

        var toolHtmlArr = [];
        toolHtmlArr.push("<div>");
        toolHtmlArr.push("<a class=\"anaestmethodeditbox-tool-add easyui-linkbutton\" data-options=\"iconCls:\'icon-add\',plain:true\">添加</a>");
        //toolHtmlArr.push("<a class=\"anaestmethodeditbox-tool-save easyui-linkbutton\" data-options=\"iconCls:\'icon-save\',plain:true\">保存</a>");
        //toolHtmlArr.push("<a class=\"anaestmethodeditbox-tool-close easyui-linkbutton\" data-options=\"iconCls:\'icon-cancel\',plain:true\">关闭</a>");
        toolHtmlArr.push("</div>");
        var tool = $(toolHtmlArr.join(""));

        $(datagrid).datagrid({
            width: options.width,
            height: options.height,
            singleSelect: true,
            rownumbers: true,
            toolbar: tool,
            url: ANCSP.DataQuery,
            queryParams: {
                ClassName: ANCLS.BLL.DataQueries,
                QueryName: "FindAnaestCatheter",
                Arg1: options.operScheduleId,
                ArgCnt: 1
            },
            columns: [
                [{
                        field: "operator",
                        title: "操作",
                        width: 60,
                        hidden: false,
                        formatter: function(value, row, index) {
                            var htmlArr = [];
                            htmlArr.push("<a href='javascript:;' class='anaestmethodeditbox-tool-edit l-btn l-btn-small l-btn-plain' iconcls='icon-edit' title='编辑此项麻醉方法' group='' id='' rowIndex='" + index + "'>");
                            htmlArr.push("<span class='l-btn-left l-btn-icon-left'><span class='l-btn-text l-btn-empty'>&nbsp;</span><span class='l-btn-icon icon-edit'>&nbsp;</span></span>");
                            htmlArr.push("</a>");
                            htmlArr.push("<a href='javascript:;' class='anaestmethodeditbox-tool-delete l-btn l-btn-small l-btn-plain' iconcls='icon-cancel' title='编辑此项麻醉方法' group='' id='' rowIndex='" + index + "'>");
                            htmlArr.push("<span class='l-btn-left l-btn-icon-left'><span class='l-btn-text l-btn-empty'>&nbsp;</span><span class='l-btn-icon icon-cancel'>&nbsp;</span></span>");
                            htmlArr.push("</a>");
                            return htmlArr.join("");
                        }
                    },
                    { field: "RowId", title: "已选麻醉插管ID", width: 60, hidden: true },
                    { field: "Anaesthesia", title: "麻醉表ID", width: 60, hidden: true },
                    { field: "AnaMethodDesc", title: "麻醉方法", width: 140 },
                    { field: "AnaMethodID", title: "麻醉方法ID", width: 60, hidden: true },
                    { field: "CatheterDesc", title: "导管分类", width: 60 },
                    { field: "Catheter", title: "导管分类ID", width: 60, hidden: true },
                    { field: "CatheterTypeDesc", title: "导管型号", width: 60 },
                    { field: "CatheterType", title: "导管型号ID", width: 60, hidden: true },
                    { field: "CatheterDepthDesc", title: "置管深度", width: 60 },
                    { field: "CatheterDepth", title: "置管深度ID", width: 60, hidden: true },
                    { field: "CatheterPathDesc", title: "插管途径", width: 60 },
                    { field: "CatheterPath", title: "插管途径ID", width: 60, hidden: true },
                    { field: "CatheterToolDesc", title: "插管工具", width: 60 },
                    { field: "CatheterTool", title: "插管工具ID", width: 60, hidden: true },
                    { field: "CatheterDirectionDesc", title: "置管方向", width: 60 },
                    { field: "CatheterDirection", title: "置管方向ID", width: 60, hidden: true },
                    { field: "PunctureSpaceDesc", title: "置管间隙", width: 60 },
                    { field: "PunctureSpace", title: "置管间隙ID", width: 60, hidden: true },
                    { field: "PositionMethodDesc", title: "定位方法", width: 60 },
                    { field: "PositionMethod", title: "定位方法ID", width: 60, hidden: true },
                    { field: "NerveBlockSiteDesc", title: "神经阻滞入路", width: 60 },
                    { field: "NerveBlockSite", title: "神经阻滞入路ID", width: 60, hidden: true },
                ]
            ],
            onSelect: function() {

            },
            onLoadSuccess: function() {
                $($(target).parent()).find('.anaestmethodeditbox-tool-edit').unbind();
                $($(target).parent()).find('.anaestmethodeditbox-tool-edit').click(function() {
                    editRow.call(this, target);
                });
                $($(target).parent()).find('.anaestmethodeditbox-tool-delete').unbind();
                $($(target).parent()).find('.anaestmethodeditbox-tool-delete').click(function() {
                    deleteRow.call(this, target);
                });
            }
        });

        state.datagrid = datagrid;

        $(tool).find("a.anaestmethodeditbox-tool-add").linkbutton({
            onClick: function() {
                var dialog = $(target).anaestmethodeditbox("dialog");
                var form = $(target).anaestmethodeditbox("form");
                $(form).form("clear");

                var saveButton = $(dialog).dialog("options").buttons[0];
                $.extend(saveButton, {
                    text: "新增",
                    iconCls: "icon-add"
                });

                showAllCatheterItem(target);

                $(dialog).dialog({
                    title: "添加麻醉方法",
                    iconCls: "icon-add"
                });
                $(dialog).dialog("open");
            }
        });
    }

    function editRow(target) {
        var dialog = $(target).anaestmethodeditbox("dialog");
        var form = $(target).anaestmethodeditbox("form");
        var datagrid = $(target).anaestmethodeditbox("datagrid");
        var rowIndex = $(this).attr("rowIndex");

        var rows = $(datagrid).datagrid("getRows");
        var rowData = rows[rowIndex];

        var saveButton = $(dialog).dialog("options").buttons[0];
        $.extend(saveButton, {
            text: "修改",
            iconCls: "icon-edit"
        });
        $(datagrid).datagrid("selectRow", rowIndex);
        $(dialog).dialog({
            title: "修改麻醉方法",
            iconCls: "icon-edit"
        });
        $(dialog).panel("open");
        $(form).form("load", $.extend(rowData, { selectedRowIndex: rowIndex }));

        showAllCatheterItem(target);
        selectAnaestMethod(target, rowData.AnaMethod);
    }

    function deleteRow(target) {
        var datagrid = $(target).anaestmethodeditbox("datagrid");
        var rowIndex = $(this).attr("rowIndex");
        var rows = $(datagrid).datagrid("getRows");
        var deletedChanges = $(datagrid).datagrid("getChanges", "deleted");
        var rowIndex = Number(rowIndex) - deletedChanges.length;
        var rowData = rows[rowIndex];
        if (rowData) {
            $.messager.confirm("提示", "是否删除该麻醉方法？", function(result) {
                if (result) {
                    $(datagrid).datagrid("deleteRow", rowIndex);
                }
            });
        }
    }

    function createDetailPanel(target, container) {
        var options = $(target).anaestmethodeditbox("options");
        var state = $(target).data("anaestmethodeditbox");

        var dialog = $("<div></div>");
        $(container).append(dialog);

        $(dialog).dialog({
            width: 300,
            height: 395,
            closed: true,
            buttons: [{
                text: "添加",
                iconCls: "icon-add",
                handler: function() {
                    var datagrid = $(target).anaestmethodeditbox("datagrid");
                    var form = $(target).anaestmethodeditbox("form");
                    if ($(form).form("validate")) {

                        var data = $(form).serializeJson();
                        if ($(form).find("input[comboname='CatheterDirection']").next('span').find('.combo-text').val() === "") {
                            data.CatheterDirection = "";
                            data.CatheterDirectionDesc = "";
                        }
                        if (data.selectedRowIndex === "") {
                            $(datagrid).datagrid("appendRow", data);
                        } else if (data.selectedRowIndex >= 0) {
                            $(datagrid).datagrid("updateRow", {
                                index: data.selectedRowIndex,
                                row: data
                            });
                        } else {

                        }

                        $($(target).parent()).find('.anaestmethodeditbox-tool-edit').unbind();
                        $($(target).parent()).find('.anaestmethodeditbox-tool-edit').click(function() {
                            editRow.call(this, target);
                        });
                        $($(target).parent()).find('.anaestmethodeditbox-tool-delete').unbind();
                        $($(target).parent()).find('.anaestmethodeditbox-tool-delete').click(function() {
                            deleteRow.call(this, target);
                        });
                    }
                    $(dialog).dialog("close");
                }
            }, {
                text: "取消",
                iconCls: "icon-cancel",
                handler: function() {
                    $(dialog).dialog("close");
                }
            }],
            onClose: function() {
                var form = $(target).anaestmethodeditbox("form");
                $(form).form("clear");
                var dataItem = $(target).anaestmethodeditbox("dataItem");
                var DHCData = $(target).anaestmethodeditbox("getDHCData");
                $(target).val(DHCData[dataItem.code]);
            }
        });

        state.dialog = dialog;
        CreateForm(target, dialog.find('.dialog-content'));
    }

    /**
     * 显示全部导管项目
     */
    function showAllCatheterItem(target) {
        var form = $(target).anaestmethodeditbox("form");
        var formState = form.data('form');

        for (var field in formState) {
            $(formState[field]).parent().show();
        }
    }

    /**
     * 选中麻醉方法
     */
    function selectAnaestMethod(target, value) {
        var state = $(target).data("anaestmethodeditbox");
        var form = state.form;
        var formState = $(form).data("form");

        var methods = formState.anaestMethod.combobox('getData');
        var record;
        for (var i = 0, length = (methods || []).length; i < length; i++) {
            if (methods[i].RowId == value) record = methods[i];
        }

        if (record) {
            for (var field in formState) {
                if (!record || record[field] != 'H') $(formState[field]).parent().show();
                else $(formState[field]).parent().hide();
            }
        }
    }


    function CreateForm(target, container) {
        var options = $(target).anaestmethodeditbox("options");
        var state = $(target).data("anaestmethodeditbox");

        var htmlArr = [];
        htmlArr.push("<form>");
        htmlArr.push("<input type='hidden' name='RowId'>");
        htmlArr.push("<input type='hidden' name='Anaesthesia'>");
        htmlArr.push("<input type='hidden' name='selectedRowIndex'>");
        htmlArr.push("</form>");

        var form = $(htmlArr.join(""));
        $(container).append(form);
        $(form).form({
            onSubmit: function() {

            }
        });
        state.form = form;

        var formState = $(form).data("form");

        formState.anaestMethod = AppendCatheterControl(target, form, {
            name: "AnaMethod",
            label: "麻醉方法",
            descName: "AnaMethodDesc"
        }, {
            width: 180,
            required: true,
            queryParams: {
                ClassName: ANCLS.BLL.CodeQueries,
                QueryName: "FindAnaestMethod",
                Arg1: "",
                Arg2: "Y",
                ArgCnt: 2
            },
            onBeforeLoad: function(params) {
                var options = $(this).combobox('options');
                var url = ANCSP.DataQuery
                options.url = composeUrl(url, $.extend(options.queryParams, {}));
            },
            onSelect: function(record) {
                var catheterOptions = $(formState.Catheter).combobox("options");
                $(formState.Catheter).combobox("reload", $.extend(catheterOptions.queryParams, {
                    Arg1: record.AnaType,
                    Arg2: record.RowId
                }));
                $(formState.Catheter).combobox("clear");
                $(formState.CatheterType).combobox("clear");
                $(form).find("input[name='AnaMethodDesc']").val(record.Description);

                for (var field in formState) {
                    if (!record || record[field] != 'H') $(formState[field]).parent().show();
                    else $(formState[field]).parent().hide();
                }
            },
            onChanged: function(newValue, oldValue) {
                var data = $(this).combobox('getData') || [];
                var valueField = 'RowId';
                var record = null;
                for (var i = 0, length = data.length; i < length; i++) {
                    if (record[valueField] == newValue) {
                        record = data[i];
                        break;
                    }
                }

                for (var field in formState) {
                    if (!record || record[field] != 'H') $(formState[field]).parent().show();
                    else $(formState[field]).parent().hide();
                }
            }
        });

        var infoContainer = $("<div class='anaestmethodeditbox-info-contianer'></div>");
        $(form).append(infoContainer);

        formState.Catheter = AppendCatheterControl(target, infoContainer, {
            name: "Catheter",
            label: "导管分类",
            descName: "CatheterDesc"
        }, {
            width: 180,
            queryParams: {
                ClassName: ANCLS.BLL.CodeQueries,
                QueryName: "FindCatheter",
                Arg1: "",
                Arg2: "",
                ArgCnt: 2
            },
            onBeforeLoad: function(params) {
                var options = $(this).combobox('options');
                var url = ANCSP.DataQuery
                options.url = composeUrl(url, $.extend(options.queryParams, {}));
            },
            onSelect: function(record) {
                $(formState.CatheterType).combobox("clear");
                $(formState.CatheterDepth).combobox("clear");
                $(formState.CatheterPath).combobox("clear");
                $(formState.CatheterType).combobox("reload");
                $(formState.CatheterDepth).combobox("reload");
                $(formState.CatheterPath).combobox("reload");
                $(form).find("input[name='CatheterDesc']").val(record.Description);
            }
        });
        formState.CatheterType = AppendCatheterControl(target, infoContainer, {
            name: "CatheterType",
            label: "导管型号",
            descName: "CatheterTypeDesc"
        }, {
            width: 180,
            queryParams: {
                ClassName: ANCLS.BLL.CodeQueries,
                QueryName: "FindCatheterType",
                Arg1: "",
                ArgCnt: 1
            },
            onBeforeLoad: function(params) {
                params.Arg1 = $(formState.Catheter).combobox("getValue");
                var options = $(this).combobox('options');
                var url = ANCSP.DataQuery
                options.url = composeUrl(url, $.extend(options.queryParams, params));
            },
            onSelect: function(record) {
                $(form).find("input[name='CatheterTypeDesc']").val(record.Description);
            }
        });
        formState.CatheterPath = AppendCatheterControl(target, infoContainer, {
            name: "CatheterPath",
            label: "插管途径",
            descName: "CatheterPathDesc"
        }, {
            width: 180,
            queryParams: {
                ClassName: ANCLS.BLL.CodeQueries,
                QueryName: "FindCatheterPath",
                Arg1: "",
                ArgCnt: 1
            },
            onBeforeLoad: function(params) {
                params.Arg1 = $(formState.Catheter).combobox("getValue");
                var options = $(this).combobox('options');
                var url = ANCSP.DataQuery
                options.url = composeUrl(url, $.extend(options.queryParams, params));
            },
            onSelect: function(record) {
                $(form).find("input[name='CatheterPathDesc']").val(record.Description);
            }
        });
        formState.CatheterTool = AppendCatheterControl(target, infoContainer, {
            name: "CatheterTool",
            label: "插管工具",
            descName: "CatheterToolDesc"
        }, {
            width: 180,
            queryParams: {
                ClassName: ANCLS.BLL.CodeQueries,
                QueryName: "FindCatheterTool",
                ArgCnt: 0
            },
            onBeforeLoad: function() {
                var options = $(this).combobox('options');
                var url = ANCSP.DataQuery
                options.url = composeUrl(url, $.extend(options.queryParams, {}));
            },
            onSelect: function(record) {
                $(form).find("input[name='CatheterToolDesc']").val(record.Description);
            }
        });
        formState.CatheterDirection = AppendCatheterControl(target, infoContainer, {
            name: "CatheterDirection",
            label: "置管方向",
            descName: "CatheterDirectionDesc"
        }, {
            width: 180,
            queryParams: {
                ClassName: ANCLS.BLL.CodeQueries,
                QueryName: "FindCatheterDirection",
                ArgCnt: 0
            },
            onBeforeLoad: function() {
                var options = $(this).combobox('options');
                var url = ANCSP.DataQuery
                options.url = composeUrl(url, $.extend(options.queryParams, {}));
            },
            onSelect: function(record) {
                $(form).find("input[name='CatheterDirectionDesc']").val(record.Description);
            }
        });
        formState.PunctureSpace = AppendCatheterControl(target, infoContainer, {
            name: "PunctureSpace",
            label: "穿刺间隙",
            descName: "PunctureSpaceDesc"
        }, {
            width: 180,
            queryParams: {
                ClassName: ANCLS.BLL.CodeQueries,
                QueryName: "FindPunctureSpace",
                ArgCnt: 0
            },
            onBeforeLoad: function() {
                var options = $(this).combobox('options');
                var url = ANCSP.DataQuery
                options.url = composeUrl(url, $.extend(options.queryParams, {}));
            },
            onSelect: function(record) {
                $(form).find("input[name='PunctureSpaceDesc']").val(record.Description);
            }
        });
        formState.PositionMethod = AppendCatheterControl(target, infoContainer, {
            name: "PositionMethod",
            label: "定位方法",
            descName: "PositionMethodDesc"
        }, {
            width: 180,
            queryParams: {
                ClassName: ANCLS.BLL.CodeQueries,
                QueryName: "FindPositionMethod",
                ArgCnt: 0
            },
            onBeforeLoad: function() {
                var options = $(this).combobox('options');
                var url = ANCSP.DataQuery
                options.url = composeUrl(url, $.extend(options.queryParams, {}));
            },
            onSelect: function(record) {
                $(form).find("input[name='PositionMethodDesc']").val(record.Description);
            }
        });
        formState.CatheterDepth = AppendCatheterControl(target, infoContainer, {
            name: "CatheterDepth",
            label: "置管深度",
            descName: "CatheterDepthDesc",
            visible: true
        }, {
            width: 180,
            queryParams: {
                ClassName: ANCLS.BLL.CodeQueries,
                QueryName: "FindCatheterDepth",
                Arg1: "",
                ArgCnt: 1
            },
            onBeforeLoad: function(params) {
                params.Arg1 = $(formState.Catheter).combobox("getValue");
                var options = $(this).combobox('options');
                var url = ANCSP.DataQuery
                options.url = composeUrl(url, $.extend(options.queryParams, params));
            },
            onSelect: function(record) {
                $(form).find("input[name='CatheterDepthDesc']").val(record.Description);
            }
        });

        formState.NerveBlockSite = AppendCatheterControl(target, infoContainer, {
            name: "NerveBlockSite",
            label: "入路",
            descName: "NerveBlockSiteDesc"
        }, {
            width: 180,
            queryParams: {
                ClassName: ANCLS.BLL.CodeQueries,
                QueryName: "FindNerveBlockSite",
                ArgCnt: 0
            },
            onBeforeLoad: function() {
                var options = $(this).combobox('options');
                var url = ANCSP.DataQuery
                options.url = composeUrl(url, $.extend(options.queryParams, {}));
            },
            onSelect: function(record) {
                $(form).find("input[name='NerveBlockSiteDesc']").val(record.Description);
            }
        });

        formState.NerveBlockSite.parent().hide();
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

    function AppendCatheterControl(target, container, catheterItem, controlOptions) {
        var state = $(target).data("anaestmethodeditbox");
        var options = state.options;

        var htmlArr = [];
        htmlArr.push("<div class='anaestmethodeditbox-form-item' style='height:30px;padding:2px;position:relative;padding-left:80px;'>");
        htmlArr.push("<div style='width:80px;text-align:right;font-weight:bold;height:30px;line-height:30px;position:absolute;top:0px;left:0px;'><label>" + catheterItem.label + "：</label></div>");
        htmlArr.push("<input name='" + catheterItem.name + "'>");
        htmlArr.push("<input type='hidden' name='" + catheterItem.descName + "'>");
        htmlArr.push("</div>");

        var html = $(htmlArr.join(""));
        $(container).append(html);
        if (typeof catheterItem.visible === 'boolean' && !catheterItem.visible) {
            html.hide();
        }

        var control = $(html).find("input[name='" + catheterItem.name + "']");
        $(control).combobox($.extend({
            valueField: "RowId",
            textField: "Description",
            url: ANCSP.DataQuery
        }, controlOptions));

        return control;
    }
})(jQuery);