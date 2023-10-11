$.extend($.fn.datagrid.defaults.editors, {
    validatebox: {
        init: function (container, options) {
            var containerDiv = $("<div></div>").appendTo(container);
            $(containerDiv).attr("id", "div_" + options.ID);
            if (!!options.toolTip)
                $(containerDiv).attr("title", options.toolTip);
            var a = $('<input type="text" class="datagrid-editable-input">').appendTo(containerDiv);
            a.validatebox(options);

            $(a).attr("id", options.ID);
			$(a).attr("name", options.ID);
            $(a).attr("Signature", options.Signature);
            if (options.Signature != "None")
                $(a).attr("SignatureAuto", options.SignatureAuto);
            if (isEditHisuiTableEmptyTableTitle(options.ID))
            {
                DisEnableOne(options.ID,true);
            }
            if (!!options.importrule)
                $(a).attr("importrule", options.importrule);
            if (!!options.importtype)
                $(a).attr("importtype", options.importtype);
            if (!!options.importmulti)
                $(a).attr("importmulti", options.importmulti);
            if (!!options.placeholder)
                $(a).attr("placeholder", options.placeholder);
			UpdateEditCellInfo(options.ID);
            return a;
        },
        destroy: function (target) {
			$(target).validatebox("destroy");
        },
        getValue: function (target) {
            return window.ElementUtility.TextElement.getValueById($(target).attr("id"));
        },
        setValue: function (target, value) {
            if (!!value)
                window.ElementUtility.TextElement.banding($(target).attr("id"), value);
        },
        resize: function (target, width) {
            if ($.type(window[$(target).attr("id")]) === "function")
                window[$(target).attr("id")]();
            $(target)._outerWidth(width);
        }
    },
    numberbox: {
        init: function (e, options) {
            var containerDiv = $("<div></div>").appendTo(e);
            $(containerDiv).attr("id", "div_" + options.ID);
            if (!!options.toolTip)
                $(containerDiv).attr("title", options.toolTip);
            var a = $('<input type="text" class="datagrid-editable-input">').appendTo(containerDiv);
            a.numberbox(options);
            $(a).attr("id", options.ID);
            $(a).attr("name", options.ID);  
            if (!!options.importrule)
                $(a).attr("importrule", options.importrule);
            if (!!options.importtype)
                $(a).attr("importtype", options.importtype);
            if (!!options.importmulti)
                $(a).attr("importmulti", options.importmulti);
            if (!!options.placeholder)
                $(a).attr("placeholder", options.placeholder);
			UpdateEditCellInfo(options.ID);
            return a;
        },
        destroy: function (e) {
            $(e).numberbox("destroy");
        },
        getValue: function (e) {
            return window.ElementUtility.NumberElement.getValueById($(e).attr("id"));
        },
        setValue: function (e, t) {
            if (!!t)
                window.ElementUtility.NumberElement.banding($(e).attr("id"), t);
        },
        resize: function (e, t) {
            if ($.type(window[$(e).attr("id")]) === "function")
                window[$(e).attr("id")]();
            $(e)._outerWidth(t)._outerHeight(30);
        }
    },
    datebox: {
        init: function (e, options) {
            var containerDiv = $("<div></div>").appendTo(e);
            $(containerDiv).attr("id", "div_" + options.ID);
            if (!!options.toolTip)
                $(containerDiv).attr("title", options.toolTip);
            var a = $('<input type="text" format="' + options.format2 + '">').appendTo(containerDiv);
            a.dateboxq(options);
            $(a).attr("id", options.ID);
            $(a).attr("name", options.ID);
            if (!!options.placeholder)
                $(a).attr("placeholder", options.placeholder);
			UpdateEditCellInfo(options.ID);
            return a;
        },
        destroy: function (e) {
            $(e).validatebox("destroy");
        },
        getValue: function (e) {
            return window.ElementUtility.DateElement.getValueById($(e).attr("id"));
        },
        setValue: function (e, t) {
            if (!!t)
                window.ElementUtility.DateElement.banding($(e).attr("id"), t);
        },
        resize: function (e, t) {
            if ($.type(window[$(e).attr("id")]) === "function")
                window[$(e).attr("id")]();
            $(e).dateboxq("resize", t);
        }
    },
    timespinner: {
        init: function (e, options) {
            var containerDiv = $("<div></div>").appendTo(e);
            $(containerDiv).attr("id", "div_" + options.ID);
            if (!!options.toolTip)
                $(containerDiv).attr("title", options.toolTip);
            var a = $("<input class='hisui-timespinner textbox' type=\"text\">").appendTo(containerDiv);
            a.timespinner(options);
            $(a).attr("id", options.ID);
            $(a).attr("name", options.ID);
            if (!!options.placeholder)
                $(a).attr("placeholder", options.placeholder);
			UpdateEditCellInfo(options.ID);
            return a;
        },
        destroy: function (e) {
            $(e).timespinner("destroy");
        },
        getValue: function (e) {
            return window.ElementUtility.TimeElement.getValueById($(e).attr("id"));
        },
        setValue: function (e, t) {
            if (!!t)
                window.ElementUtility.TimeElement.banding($(e).attr("id"), t);
        },
        resize: function (e, t) {
            if ($.type(window[$(e).attr("id")]) === "function")
                window[$(e).attr("id")]();
            $(e).timespinner("resize", t);
        }
    },
    textarea: {
        init: function (e, options) {
            var containerDiv = $("<div></div>").appendTo(e);
            $(containerDiv).attr("id", "div_" + options.ID);
            if (!!options.toolTip)
                $(containerDiv).attr("title", options.toolTip);
            var i = '<textarea class="textbox datagrid-editable-input" style="';
            if ("undefined" != typeof options) {
                if (options.height) i += "height:" + options.height + ";";
                if (options.width) i += "width:" + options.width + ";";
            }
            var a = $(i + '"></textarea>').appendTo(containerDiv);
            if ("undefined" != typeof options) {
                a.validatebox(options);
            }
            $(a).attr("id", options.ID);
            $(a).attr("name", options.ID);
            if (!!options.importrule)
                $(a).attr("importrule", options.importrule);
            if (!!options.importtype)
                $(a).attr("importtype", options.importtype);
            if (!!options.importmulti)
                $(a).attr("importmulti", options.importmulti);
            if (!!options.placeholder)
                $(a).attr("placeholder", options.placeholder);
            UpdateEditCellInfo(options.ID);
            return a;
        },
        destroy: function(e) {
            if (e.length > 0 && e.hasClass("validatebox-text")) e.validatebox("destroy");
        },
        getValue: function(e) {
            return window.ElementUtility.TextareaElement.getValueById($(e).attr("id"));
        },
        setValue: function(e, t) {
            if (!!t) 
                window.ElementUtility.TextareaElement.banding($(e).attr("id"), t);
        },
        resize: function (e, t) {
            if ($.type(window[$(e).attr("id")]) === "function")
                window[$(e).attr("id")]();
            $(e)._outerWidth(t);
        }
    },
    cellTextarea: {
        init: function (e, options) {
            var containerDiv = $("<div></div>").appendTo(e);
            $(containerDiv).attr("id", "div_" + options.ID);
            if (!!options.toolTip)
                $(containerDiv).attr("title", options.toolTip);
            $("<div></div>").appendTo(containerDiv)
            var h = '<textarea class="celltextarea textbox datagrid-editable-input" style="position:absolute;';
            if ("undefined" != typeof options) {
                if (options.height) h += 'height:' + options.height + ";";
                if (options.width) h += 'width:' + options.width + ";";
            }
            var a = $(h + '"></textarea>').appendTo(containerDiv);
            if ("undefined" != typeof options) {  
                a.validatebox(options);
            }
            $(a).attr("id", options.ID);
            $(a).attr("name", options.ID);
            if (!!options.importrule)
                $(a).attr("importrule", options.importrule);
            if (!!options.importtype)
                $(a).attr("importtype", options.importtype);
            if (!!options.importmulti)
                $(a).attr("importmulti", options.importmulti);
            if (!!options.placeholder)
                $(a).attr("placeholder", options.placeholder);
			UpdateEditCellInfo(options.ID);
            return a;
        },
        destroy: function (e) {
            e.off(".celltextarea");
            e.closest(".datagrid-body").off(".celltextarea");
            if (e.length > 0 && e.hasClass("validatebox-text")) e.validatebox("destroy");
        },
        getValue: function (e) {
            return window.ElementUtility.TextareaElement.getValueById($(e).attr("id"));
        },
        setValue: function (e, t) {
            if (!!t) {
                window.ElementUtility.TextareaElement.banding($(e).attr("id"), t);
                $(e).prev().text(t);
            }
                
        },
        resize: function (e, t) {
            if ($.type(window[$(e).attr("id")]) === "function")
                window[$(e).attr("id")]();
            $(e)._outerWidth(t);
            var i = function (e) {
                var t = $(e);
                var i = t.closest("div.datagrid-cell").closest("td").height();
                var a = t.closest(".datagrid-view2")[0].offsetHeight;
                var n = t.parent().parent().offset().top;
                var r = t.closest(".datagrid-body").offset().top;
                var o = n - r;
                var s = true;
                if (o + i > a - o) {
                    s = false;
                }
                var d = Math.max(o + i, a - o);
                d = Math.min(d, a - 32);
                if (i > a - 32) {
                    d = a - 32;
                    if (o < 0) {
                        s = false;
                    } else {
                        s = true;
                    }
                }

                return {
                    maxHeight: d - 32,
                    downShow: s
                };
            };
            var a = function (e, t, a, r) {
                t = t || 0;
                var o = !!document.getBoxObjectFor || "mozInnerScreenX" in window, s = !!window.opera && !!window.opera.toString().indexOf("Opera"), d = e.currentStyle ? function (t) {
                    var i = e.currentStyle[t];
                    if (t === "height" && i.search(/px/i) !== 1) {
                        var a = e.getBoundingClientRect();
                        return a.bottom - a.top - parseFloat(d("paddingTop")) - parseFloat(d("paddingBottom")) + "px";
                    }
                    return i;
                } : function (t) {
                    return getComputedStyle(e, null)[t];
                }, l = parseFloat(d("height"));
                e.style.resize = "none";
                var c = function (a) {
                    var r, c = 0, f = e.style;
                    if (a != true && e._length === e.value.length) return;
                    e._length = e.value.length;
                    if (!o && !s) {
                        c = parseInt(d("paddingTop")) + parseInt(d("paddingBottom"));
                    }
                    e.style.height = l + "px";
                    var u = i(e);
                    var h = u.maxHeight;
                    if (e.scrollHeight > l) {
                        if (h && e.scrollHeight > h) {
                            r = h - c;
                            f.overflowY = "auto";
                        } else {
                            r = e.scrollHeight - c;
                            f.overflowY = "hidden";
                        }
                        f.height = r + t + "px";
                        e.currHeight = parseInt(f.height);
                    }
                    n($(e), u.downShow);
                };
                $(e).off("propertychange.celltextarea").on("propertychange.celltextarea", c);
                $(e).off("input.celltextarea").on("input.celltextarea", c);
                $(e).off("focus.celltextarea").on("focus.celltextarea", c);
                c(r);
            };
            var n = function (e, t) {
                var a = e.parent().parent().offset();
                var n = e.closest("div.datagrid-cell");
                if (n.length > 0 && n[0].style.whiteSpace == "") {
                    a.top -= 7;
                }
                var r = e.closest(".datagrid-view2")[0];
                if (r) {
                    if (a) {
                        var o = e.closest(".datagrid").offset().top;
                        if ("undefined" == typeof t) t = i(e[0]).downShow;
                        if (t) {
                            if (!$(e).prev().text())
                                a.top = a.top - 16;
                            e.offset(a);
                        } else {
                            var s = n.closest("td").height();
                            if (s > e.height())
                            {
                                e.offset(a);
                            }
                            else {
                                e.offset({
                                    top: a.top + s - e.height(),
                                    left: a.left
                                });
                            }
                            
                        }
                    }
                    if (false == t) {
                        if (r.scrollTop > 0) {
                            setTimeout(function () {
                                e.closest(".datagrid-body")[0].scrollTop = 1e5;
                            }, 0);
                        }
                    }
                }
            };
            e.closest(".datagrid-body").on("scroll.celltextarea", function () {
                n(e);
            });
            a(e[0], 0, undefined);
        }
    },
    combobox: {
        init: function (e, options) {
            var containerDiv = $("<div></div>").appendTo(e);
            $(containerDiv).attr("id", "div_" + options.ID);
            if (!!options.toolTip)
                $(containerDiv).attr("title", options.toolTip);
            var a = $('<input type="text">').appendTo(containerDiv);
            a.combobox(options || {});
            $(a).attr("id", options.ID);
            $(a).attr("name", options.ID);
            if (!!options.placeholder)
                $(a).attr("placeholder", options.placeholder);
			UpdateEditCellInfo(options.ID);
            return a;
        },
        destroy: function (e) {
            $(e).combobox("destroy");
        },
        getValue: function (e) {

            var ElementType = GetEditElementStringType($(e).attr("id"));
            if (ElementType == "CheckElement" || ElementType == "DropListElement" || ElementType == "RadioElement") {
                return window.ElementUtility.DropListElement.getValueById($(e).attr("id"));
            }
            else if (ElementType == "DropCheckboxElement") {
                return window.ElementUtility.DropCheckboxElement.getValueById($(e).attr("id"));
            }
            else if (ElementType == "DropRadioElement") {
                return window.ElementUtility.DropRadioElement.getValueById($(e).attr("id"));
            }
        },
        setValue: function (e, t) {
            var ElementType = GetEditElementStringType($(e).attr("id"))
            if (t === undefined)
                return;
            if (!!t && $.type(t) == "string")
                t = JSON.parse(t);
            if (($.type(t) == "string" && t == ""))
                t = [];
            
            if (ElementType == "CheckElement" || ElementType == "DropListElement" || ElementType == "RadioElement") {
                window.ElementUtility.DropListElement.banding($(e).attr("id"), t);
            }
            else if (ElementType == "DropCheckboxElement") {
                window.ElementUtility.DropCheckboxElement.banding($(e).attr("id"), t);
            }
            else if (ElementType == "DropRadioElement") {
                window.ElementUtility.DropRadioElement.banding($(e).attr("id"), t);
            }
        },
        resize: function (e, t) {
            if ($.type(window[$(e).attr("id")]) === "function")
                window[$(e).attr("id")]();
            $(e).combobox("resize", t);
        }
    }
});

function isEditHisuiTableEmptyTableTitle(columnFiled)
{
    var re = false;
    if (window.EmptyDynamicTitle === undefined)
        return re;
    $.each(window.EmptyDynamicTitle, function (k, v) {
        if (columnFiled.indexOf(k) >= 0)
        {
            $.each(v, function (i, n) {
                var t = "edit" + k + "_" + n; 
                if (columnFiled === t)
                {
                    re = true;
                    return true;
                }
            });
            
            return true;
        }
    });

    return re;
}

function GetTableColumnFields(tableID) {
    return $('#' + tableID).datagrid('getColumnFields', true).concat($('#' + tableID).datagrid('getColumnFields'));
}

function AddHisuiEditors(tableID) {
    if (window.HisuiEditors === undefined) {
        window.HisuiEditors = {};
    }
    var editElements = [];
    var requiredElements = [];
    var importRule = {};
    var columns = GetTableColumnFields(tableID);
    $.each(columns, function (i, columnField) {
        var opt = $('#' + tableID).datagrid('getColumnOption', columnField);
        if (!!opt.editor) {
            editElements.push(opt.editor.options.ID);
            if (!!opt.editor.options.importrule)
                importRule[columnField + "_importrule"] = opt.editor.options.importrule;
            if (!!opt.editor.options.importtype)
                importRule[columnField + "_importtype"] = opt.editor.options.importtype;
            if (!!opt.editor.options.importmulti)
                importRule[columnField + "_importmulti"] = opt.editor.options.importmulti;
            if (!!opt.editor.options.required)
                requiredElements.push(columnField);
        }
    });
    window.HisuiEditors[tableID] = { "editIndex": undefined, "editField": undefined, "editElements": editElements, "DefaultExpr": {}, "NoEdit": [], "ImportRule": importRule, "requiredElements": requiredElements,"editors":[] };
}

function AddCellEditDefault(identity, defaultExpr) {
    var testReg = /^edit/;
    if (testReg.test(identity) && IsTableCellEdit(GetTableIdByIndentity(identity))) {
        var tableID = GetTableIdByIndentity(identity);
        if (!!window.HisuiEditors[tableID]) {
            var field = GetTableFieldByIndentity(identity);
            window.HisuiEditors[tableID].DefaultExpr[field] = defaultExpr;
        }

    }
}

function ClearHisuiEditorInfo(tableID) {
    window.HisuiEditors[tableID].editIndex = undefined;
    window.HisuiEditors[tableID].editField = undefined;
    window.HisuiEditors[tableID].NoEdit = [];
}

function ClearHisuiEditorNoEditInfo(tableID, editIndex) {
    $.each(window.HisuiEditors[tableID].editElements, function (i, columnField) {
        var key = editIndex + GetTableIdByIndentity(columnField);
        var index = window.HisuiEditors[tableID].NoEdit.indexOf(key);
        if (index >= 0)
            window.HisuiEditors[tableID].NoEdit.splice(index, 1);
    });
}

function OnHisuiEditClickRow(rowIndex, rowData, tableID) {
    var _msg = IsPermission(GetTopTempletGuid(), "save");
    if (_msg.denied) {
        if (_msg.warnDialogShow)
            $.messager.alert(" ", _msg.errMsg, "info");
        return;
    }

    if (OnHisuiEndEditing(tableID)) {
        if (IsCancelDataTableRow(tableID, rowData.ID))
            return;
        var opts = $('#' + tableID).datagrid('options');
        if (IsStatisticsRow(rowData) && !opts.statisticsRowEdit){          
            return;
        }
        
        if (IsStatisticsRow(rowData) && !!opts.statisticsRowEdit) { 
            if (!!rowData.tempData && rowData.tempData == "true")
                return;
            else 
                $('#' + tableID).datagrid('refreshRow', rowIndex);
        }

        if (!!rowData.ID) {
            var opts = $('#' + tableID).datagrid('options');
            var updateVerifyRelatedSignField = opts.updateVerifyRelatedSignField;
            if (!!updateVerifyRelatedSignField) {
                var isOK = IsVerifyEditPermission(rowData.ID, updateVerifyRelatedSignField, opts.signVerifyNoWarn);
                if (!isOK)
                    return;
            }
        }
        window.HisuiEditors[tableID].editIndex = rowIndex;
        $('#' + tableID).datagrid('selectRow', rowIndex).datagrid('beginEdit', rowIndex);
        $('#' + tableID + "_toolbar > #edttEnd").show();
    }
}

function IsVerifyEditPermission(rowID, verifyRelatedSignField,msgNoWarn)
{
    var _msg = IsPermission(GetTopTempletGuid(), "save");
    if (_msg.denied) {
        if (_msg.warnDialogShow)
            $.messager.alert(" ", _msg.errMsg, "info");
        return false;
    }

    var msg = tkMakeServerCall("NurMp.Template.MultData", "IsUpdate", rowID, session['LOGON.USERCODE'], session['LOGON.GROUPDESC'], verifyRelatedSignField);

    var reMsg = JSON.parse(msg);
    if (MsgIsOK(reMsg)) {
        if (reMsg.data == 0) {
            if (!!msgNoWarn && msgNoWarn === true) {
                return false;
            }
            $.messager.alert(" ", $g(reMsg.msg), "info");
            return false;
        }
    }
    else {
        $.messager.alert(" ", $g("修改权限查询失败") + reMsg.msg, "error");
        return false;
    }
    return true;
}

function OnHisuiEditEnd(tableID) {
    OnHisuiEndEditing(tableID);
}

function OnHisuiEditSave(tableID) {
    var innerFun = function () {
        setTimeout(function () {
            DBTableLoadData(tableID);
            RefreshMiddleFrameTemplateTree();
            ClearHisuiEditorInfo(tableID);
        }, 5);
    };
    var insertErrorMsgs = function (msg) {
        var isExist = false;
        $.each(errorMsgs, function (i, errorMsg) {
            if (msg === errorMsg) {
                isExist = true;
                return false;
            }
        });

        if (!isExist)
            errorMsgs.push(msg);
    };
    var self = arguments.callee.caller.arguments[0];
    if (OnHisuiEndEditing(tableID)) {
        if (IsTableCellEdit(tableID)) {
            if (!CellEditBeforeSaveRequiredVerify(tableID))
                return false;
        }
        var changeRowIDs = [];
        var changeRows = $('#' + tableID).datagrid('getChanges');

        var j = changeRows.length;
        while (j--) {
            if (!!changeRows[j].tempData && changeRows[j].tempData == "true") {
                changeRows.splice(j, 1);
            }
        }

        if (changeRows.length == 0)
            return;
        var columns = GetTableColumnFields(tableID);
        var opts = $('#' + tableID).datagrid('options');
        var gatherData = {};
        var saveType = 1;//0:暂存，1:保存
        if (!!opts.gatherParams) {
            var queryParams = $.map(opts.gatherParams.split(','), function (n) {
                if (n.indexOf('^') > -1)
                {
                    var eleId = n.split('^')[0];
                    var map = n.split('^')[1];
                    if (!!map)//带有映射的一般另有他用，不需要保存
                        return null;
                    else
                        return eleId;
                }
                else
                    return n;
            });
            gatherData = CombineSpecifyFiledsData(GatherTemplateSpecifyFiledsData(queryParams));
        }
        var errorMsgs = [];

        var SignColumnFields = HasSignColumn(tableID);
        if (window.CAVerify > 0 && SignColumnFields.length > 0) {
            var allSigned = true;
            $.each(changeRows, function (i, row) {
                var saveID = tableID;
                if (!!row["ID"])
                    saveID += row["ID"];
                else if (!!row["newTempID"])
                    saveID += row["newTempID"];

                if (!HasSignedTableRow(saveID))
                {
                    allSigned = false;
                    return false;
                }
            });
            if (!allSigned) {
                //todo 那一行没有签名，就高亮那一行，并且可以通过SignColumnFields，焦点在需要签名的那个单元格上
                $.messager.alert("", $g("每一条记录更新，都需要签名，否则无法保存"), "error");
                return false;
            }
        }

        $.each(changeRows, function (i, row) {
            var dataPost = gatherData;
            var signTemplateData = {};
            $.each(columns, function (i, columnField) {
                var opt = $('#' + tableID).datagrid('getColumnOption', columnField);
                if (IsSysElement(columnField)) {
                    dataPost[columnField] = row[columnField];
                    signTemplateData[columnField] = row[columnField];
                }
            });


            dataPost["templateVersionGuid"] = opts.bandingTemplateGuid;
            dataPost["EpisodeID"] = window.EpisodeID;
            dataPost["LOGON.CTLOCID"] = session['LOGON.CTLOCID'];
            dataPost["LOGON.WARDID"] = session['LOGON.WARDID'];
            dataPost["LOGON.GROUPDESC"] = session['LOGON.GROUPDESC'];
            dataPost["LOGON.USERID"] = session['LOGON.USERID'];
            dataPost["TemporarySave"] = saveType;
            if (!!row["ID"])
                dataPost["NurMPDataID"] = row["ID"];
            dataPost["logAuxiliaryInfo"] = GetLogAuxiliaryInfo();
            var url = WebIp + "/csp/dhcnurmpgetdata.csp?ClassName=NurMp.Template.MultData&MethodName=Save";
            url = GetMWToken(url);
            $.ajax({
                type: "POST",
                async: false,
                url: url,
                data: { datapost: JSON.stringify(dataPost) },
                success: function (msg) {
                    var reMsg = JSON.parse(msg)
                    if (MsgIsOK(reMsg)) {
                        if (/^\d+$/.test(reMsg.data))//正常应返回流水号
                        {
                            changeRowIDs.push(reMsg.data);
                            var saveID = tableID;
                            if (!!row["ID"])
                                saveID += row["ID"];
                            else if (!!row["newTempID"])
                                saveID += row["newTempID"];

                            if (window.CAVerify > 0 && HasSignedTableRow(saveID)) {
                                __NurseCASignData(window.CAVarCert, window.CAContainerName, signTemplateData, reMsg.data, saveID);//saveID,用表格ID+流水号ID(或者临时流水号)
                            }
                        }
                        else {
                            insertErrorMsgs(reMsg.data);
                        }
                    }
                    else {
                        insertErrorMsgs(reMsg.data);
                    }
                }
            });
        });
        if (window.CAVerify > 0) {
            __ClearCASignedInfo();
            if (!!window.CASignedInfos) {
                for (var i = window.CASignedInfos.length-1; i >= 0; i--) {
                    if (!!window.CASignedInfos[i].rowIdentity && window.CASignedInfos[i].rowIdentity.indexOf(tableID)>-1)
                        window.CASignedInfos.splice(i, 1);
                }
            }
        }
        if (changeRowIDs.length == 0)//全部失败
        {
            $.messager.alert("提交失败", errorMsgs.join("\n"), "error");
        }
        else
        {
            if (opts.saveGeneratePic) {
                var generatePicPrintTemplateEmrCode = "";
                var generatePicType = "";
                if (opts.saveGeneratePicPrintTemplateEmrCode.indexOf("^") > 0) {
                    generatePicPrintTemplateEmrCode = opts.saveGeneratePicPrintTemplateEmrCode.split("^")[0];
                    generatePicType = opts.saveGeneratePicPrintTemplateEmrCode.split("^")[1];
                }
                else {
                    generatePicPrintTemplateEmrCode = opts.saveGeneratePicPrintTemplateEmrCode;
                    generatePicType = "0";//图片
                }
                    

                if (changeRows.length != changeRowIDs.length && errorMsgs.length > 0) {//部分失败
                    $.messager.alert("部分提交失败", errorMsgs.join("\n"), "error", function () {
                        __GeneratePic(changeRowIDs, generatePicPrintTemplateEmrCode, false, innerFun, generatePicType);
                    });
                }
                else//全部成功
                    __GeneratePic(changeRowIDs, generatePicPrintTemplateEmrCode, false, innerFun, generatePicType);
            }
            else
            {
                if (changeRows.length != changeRowIDs.length && errorMsgs.length > 0) {//部分失败
                    $.messager.alert("部分提交失败", errorMsgs.join("\n"), "error", function () {
                        if (!!window.HideSavedAlter)
                            innerFun();
                        else {
                            var msg = saveType == 1 ? $g("部分提交成功") : $g("部分保存成功"); //0:暂存，1:保存
                            $.messager.alert(" ", msg, "success", function () {
                                innerFun();
                            });
                        }
                    });
                }
                else//全部成功
                {
                    if (!!window.HideSavedAlter)
                        innerFun();
                    else {
                        var msg = saveType == 1 ? $g("提交成功") : $g("保存成功"); //0:暂存，1:保存
                        $.messager.alert(" ", msg, "success", function () {
                            innerFun();
                        });
                    }
                } 
            }
        }
    }
}

function HasSignedTableRow(rowIndentity) {
    var isHas = false;
    if (window.CASignedInfos === undefined)
        return false;
    $.each(window.CASignedInfos, function (i, n) {
        if (n.rowIdentity == rowIndentity) {
            isHas = true;
            return false;
        }
    });
    return isHas;
}

function OnHisuiEditAppend(tableID) {

    var _msg = IsPermission(GetTopTempletGuid(), "new");
    if (_msg.denied) {
        if (_msg.warnDialogShow)
            $.messager.alert(" ", _msg.errMsg, "info");
        return;
    }

    if (OnHisuiEndEditing(tableID)) {

        var opts = $('#' + tableID).datagrid('options');

        var isKongBiaoTou = false;
        if (!!opts.gatherParams) {
            $("select[id^='DropListElement_']").each(function (i) {
                var options = $(this).combobox("options");
                if (options.onSelect == DynamicTableTitleDropListChange && [opts.gatherParams].indexOf($(this).attr("id")) > -1) {
                    var val = window.ElementUtility["DropListElement"].getValueById($(this).attr("id"));
                    if (val.length == 0 || val[0].Text == kongbiaotou || val[0].Text == "") {
                        isKongBiaoTou = true;
                        return false;
                    }
                }
            });
        }
        if (isKongBiaoTou) {
            $.messager.alert(" ", $g("空表头不能新建记录"), "info");
            return;
        }

        if (opts.editBottomAdd)
            window.HisuiEditors[tableID].editIndex = $('#' + tableID).datagrid('getRows').length;
        else 
            window.HisuiEditors[tableID].editIndex = 0;

        if (opts.cellEdit) {
            var newRowData = {};
            $.each(window.HisuiEditors[tableID].DefaultExpr, function (k, v) {
                var t="";              
                if (/^Func/.test(v)){
                    t = v.slice(5);
                    if (t == "GetTableEditDataSourceRefDefaultValue"){
                        var identity = "edit" + tableID + "_" + k;
                        newRowData[k] = GetTableEditDataSourceRefDefaultValue(identity);
                    }      
                    else
                        newRowData[k] = window[t]();
                }
                else if (/^Text/.test(v)) {
                    t = v.slice(5);
                    newRowData[k] = t;
                }
                else {
                    if ($.isPlainObject(v))
                        newRowData[k] = v.values;
                    else if ($.isArray(v))
                        newRowData[k] = v;
                }
            });
            $('#' + tableID).datagrid('insertRow', { index: window.HisuiEditors[tableID].editIndex, row: newRowData });
        }
        else
            $('#' + tableID).datagrid('insertRow', { index: window.HisuiEditors[tableID].editIndex, row: {} });
        
        if (opts.cellEdit) {
            if (opts.cellEditDefaultColumnNo !== "") {
                var dg = $('#' + tableID);
                var fields = GetTableColumnFields(tableID);
                var columns = [];
                $.map(fields, function (field) {
                    columns.push(dg.datagrid('getColumnOption', field));
                });

                var f = columns[+opts.cellEditDefaultColumnNo + 1].field;
                $('#' + tableID).datagrid('gotoCell', {
                    index: window.HisuiEditors[tableID].editIndex,
                    field: f
                });
                $('#' + tableID).datagrid('editCell', {
                    index: window.HisuiEditors[tableID].editIndex,
                    field: f
                });
            }
        }
        else{
            $('#' + tableID).datagrid('beginEdit', window.HisuiEditors[tableID].editIndex);
            $('#' + tableID + "_toolbar > #edttEnd").show();
        }
        
    }
}

function OnHisuiEndEditing(tableID) {
    var editIndex = window.HisuiEditors[tableID].editIndex;
    if (editIndex === undefined) { return true; }
    if ($('#' + tableID).datagrid('validateRow', editIndex)) {
        $('#' + tableID).datagrid('endEdit', editIndex);
        window.HisuiEditors[tableID].editIndex = undefined;
        window.HisuiEditors[tableID].editField = undefined;
        $('#' + tableID + "_toolbar > #edttEnd").hide();
        return true;
    } else {
        if (!!window.RequiredAlter)
            $.messager.alert(" ", $g("有必填项未填"), "info");
        return false;
    }

}

function CellEditBeforeSaveRequiredVerify(tableID) {
    var isSuccess = true;
    var changeRows = $('#' + tableID).datagrid('getChanges');
    $.each(changeRows, function (i, r) {
        $.each(window.HisuiEditors[tableID].requiredElements, function (i, f) {
            if (!r[f]) {
                isSuccess = false;
                var rIndex = $('#' + tableID).datagrid('getRowIndex', r);
                $('#' + tableID).datagrid('gotoCell', {
                    index: rIndex,
                    field: f
                });
                $('#' + tableID).datagrid('editCell', {
                    index: rIndex,
                    field: f
                });
                return false;
            }
        });
        if (!isSuccess)
            return false;
    });

    return isSuccess;
}

function OnHisuiEditCancel(tableID) {
    $('#' + tableID).datagrid('rejectChanges');
    $('#' + tableID + "_toolbar > #edttEnd").hide();
    ClearHisuiEditorInfo(tableID);
}

function OnHisuiEditRemove(tableID) {
    var editIndex = window.HisuiEditors[tableID].editIndex;
    if (editIndex == undefined) { return; }
    var editRow = $('#' + tableID).datagrid('getRows')[editIndex];
    if (!!editRow["ID"]) {
        $.messager.alert(" ", $g("非新增数据，只能作废"), "info");
        return;
    }
    $('#' + tableID).datagrid('cancelEdit', editIndex)
			.datagrid('deleteRow', editIndex);
    ClearHisuiEditorNoEditInfo(tableID, editIndex);
    window.HisuiEditors[tableID].editIndex = undefined;
    window.HisuiEditors[tableID].editField = undefined;

    var changeRows = $('#' + tableID).datagrid('getChanges');
    if (changeRows.length == 0)
        $('#' + tableID + "_toolbar > #edttEnd").hide();
}

function OnHisuiEditAccept(tableID) {//保存

    Throttle(OnHisuiEditSave, null, [tableID]);
}

function OnHisuiCellEditEnterHandler(tableID, i, f) {
    
    var tableOpts = $('#' + tableID).datagrid('options');
    if (!!tableOpts.onlyRadioDBClickEdit) {
        var editorType = GetElementStringType(f);
        if (editorType == "RadioElement") {
            var formElement = "edit" + tableID + "_" + f;
            var formElementData = $("#" + formElement).combobox("getData");
            if (!!formElementData && formElementData.length == 1) {
                return;
            }
        }
    }

    var currentIndex = window.HisuiEditors[tableID].editElements.indexOf("edit" + tableID + "_" + f);
    if (currentIndex == -1 || currentIndex == window.HisuiEditors[tableID].editElements.length - 1)
        return;
    do {
        var currentIndex = currentIndex + 1;
        var nextField = GetTableFieldByIndentity(window.HisuiEditors[tableID].editElements[currentIndex]);
        var key = i + nextField;
        var findNoEditIndex = window.HisuiEditors[tableID].NoEdit.indexOf(key);
        if (findNoEditIndex == -1) {
            var target = $("#" + tableID);
            var panel = $(target).datagrid('getPanel');
            panel.find('td.datagrid-row-selected').removeClass('datagrid-row-selected');
            setTimeout(function () {
                $('#' + tableID).datagrid('gotoCell', {
                    index: i,
                    field: nextField
                });
                $('#' + tableID).datagrid('editCell', {
                    index: i,
                    field: nextField
                });
            }, 0);
            break;
        }
    } while (currentIndex < window.HisuiEditors[tableID].editElements.length - 1);
}

function OnHisuiBeforeCellEdit(tableID, i, f) {

    var _msg = IsPermission(GetTopTempletGuid(), "save");
    if (_msg.denied) {
        if (_msg.warnDialogShow)
            $.messager.alert(" ", _msg.errMsg, "info");
        return false;
    }
    var rowDatas = $('#' + tableID).datagrid("getRows");
    var rowData = rowDatas[i];

    if (IsCancelDataTableRow(tableID, rowData.ID))
        return false;
    var opts = $('#' + tableID).datagrid('options');
    if (IsStatisticsRow(rowData) && !opts.statisticsRowEdit)
        return false;
    if (IsStatisticsRow(rowData) && !!opts.statisticsRowEdit && !!rowData.tempData && rowData.tempData == "true") 
        return false;

    if (!!rowData.ID) {
        var opts = $('#' + tableID).datagrid('options');
        var updateVerifyRelatedSignField = opts.updateVerifyRelatedSignField;
        if (!!updateVerifyRelatedSignField) {
            var isOK = IsVerifyEditPermission(rowData.ID, updateVerifyRelatedSignField, opts.signVerifyNoWarn);
            if (!isOK)
                return false;
        }
    }

    var key = i + f;
    var findNoEditIndex = window.HisuiEditors[tableID].NoEdit.indexOf(key);
    return findNoEditIndex == -1;
}

function OnHisuiColumnFormatter(value, column, row, tableID,index) {

    var EmptyDefualtDisProcess = function (value) {
        if (!value && !!column.EmptyDefaultDis)
            return column.EmptyDefaultDis;
        else {
            if (!!column.WrapFlag) {
                var regexp = new RegExp(column.WrapFlag, "g");
                var dg = $('#' + tableID);
                var fields = GetTableColumnFields(tableID);
                var AlignTargetColumnOpt = null;
                $.each(fields, function (i,field) {
                    var columnOpt = dg.datagrid('getColumnOption', field);
                    if (columnOpt.AlignTargetColumn != undefined && !!columnOpt.AlignTargetColumn && columnOpt.AlignTargetColumn == column.field)
                        AlignTargetColumnOpt = columnOpt;
                });
                if (!!AlignTargetColumnOpt) {
                    var items = value.split(column.WrapFlag);
                    var ret = "";
                    $.each(items, function (i, n) {
                        ret += "<div>" + n + "</div>";
                    });
                    return ret;
                }
                else if (!!column.AlignTargetColumn)
                {
                    var columnOpt = dg.datagrid('getColumnOption', column.AlignTargetColumn);
                    var targetItems = row[columnOpt.field].split(columnOpt.WrapFlag);
                    var sourceItems = value.split(column.WrapFlag);
                    var ret = "";
                    $.each(targetItems, function (i, n) {
                        if (!!columnOpt) {
                            ret += "<div style='height:" + testHeight(columnOpt.width, n) + "'>" + sourceItems[i] + "</div>";
                        }
                    });
                    return ret;
                }
                else {
                    value = value.replace(regexp, "\n");
                }
            }
            return html_encode(value);
        }
            
    }

    var testHeight = function (width,value) {
        var h = 0;
        var testdiv = "<div id='calcHeight' class='datagrid-cell' style='height:auto;text-align:center;white-space:normal;'></div>"
        if ($("#calcHeight").length == 0)
            $("body").append(testdiv);
        $("#calcHeight").empty().css("width",width).text(value);
        var elem1 = document.getElementById("calcHeight");
        h = window.getComputedStyle(elem1).getPropertyValue('height');
        return h;
    }

    var name = column.field;
    if (row.ID === undefined && !!row[name])
        value = row[name];
    if (value == undefined)
        return "";
    if (!value)
        return EmptyDefualtDisProcess(value);

    var opts = $('#' + tableID).datagrid('options');
    if (IsCA(value)) {
        var SignatureFull = value.substring(2);//去掉前缀CA

        if (!!opts.SignImgSyncLoad && !!row.asyncSignImg) {
            if (!!window.AsyncSignImgs[tableID][index + "-" + column.field])
                return window.AsyncSignImgs[tableID][index + "-" + column.field];
            else
                return "";
            console.log("从本地变量里找到图片，进行渲染");
        }
        else
            return CASignTableDisplayImg(SignatureFull, row, column.ItemsSplitString, column.field, column.signShowOrder, opts.SignImgSyncLoad, index, tableID);
    }
    else if (IsPatientCA(value)) {
        return PatientCASignTableDisplayImg(value);
    }
    else if (IsStatisticsRow(row)) {
        if (!!opts.statisticsResultDoubleBlack && opts.statisticsResultFields.indexOf(name) > -1) {
            var lineheight = parseInt($(".datagrid-cell-c1-" + name).css("line-height")) + 8;
            return "<span style='border-bottom:4px double black;line-height:"+lineheight+"px;'>" + html_encode(value) + "</span>";
        }
        else
            return html_encode(value);
    }
    else {
        if (IsSysElement(name)) {
            var ElementType = GetElementStringType(name)
            if (ElementType == "CheckElement" || ElementType == "DropListElement" || ElementType == "RadioElement"
				|| ElementType == "DropCheckboxElement" || ElementType == "DropRadioElement") {

                var ShowNumerValue = !!column.ShowNumerValue ? true : false;
                if ($.type(value) == "string") {
                    if (value.indexOf("{") >= 0 && value.indexOf("}") >= 0) {//统计数据可能不是对象
                        if (ShowNumerValue)
                            return EmptyDefualtDisProcess(GetComboboxString("numberValue", JSON.parse(value), column.ItemsSplitString));
                        else
                            return EmptyDefualtDisProcess(GetComboboxString("text", JSON.parse(value), column.ItemsSplitString));

                    }
                    else {
                        return EmptyDefualtDisProcess(value);
                    }
                }
                else {
                    if (ShowNumerValue)
                        return EmptyDefualtDisProcess(GetComboboxString("numberValue", value, column.ItemsSplitString));
                    else
                        return EmptyDefualtDisProcess(GetComboboxString("text", value, column.ItemsSplitString));
                }
            }
            else {
                return EmptyDefualtDisProcess(value);
            }
        }
        else
            return EmptyDefualtDisProcess(value);
    }
}

/**
 * hisui数据表格加载成功，附加了行的mouseover
 * @method OnHisUITableLoadSuccess 
**/
function OnHisUITableLoadSuccess(data) {
    var self = this;
    var tableDivID = "div_" + this.id;
    if (!!window.HisuiEditors && !!window.HisuiEditors[this.id]) {
        window.HisuiEditors[this.id].editIndex = undefined;
        window.HisuiEditors[this.id].editField = undefined;
    }
    
    $("#" + tableDivID + " .datagrid-row").mouseenter(function (e) {
        var index = $(this).attr("datagrid-row-index");
        var rowData = data.rows[index];
        if (!window.ContinuePrintMark) {
            if (!!rowData && !!rowData.PrintInfo && rowData.PrintInfo != "null") {
                //样例  "StartPageNo|2^StartIndex|5^EndPageNo|2^EndIndex|5"

                var printTrace = StringObjectToObject(rowData.PrintInfo, "^", "|");

                var content = "开始页:{0}开始:{1}结束页:{2}结束:{3}";
                content = $g(content).format(printTrace.StartPageNo, printTrace.StartIndex, printTrace.EndPageNo, printTrace.EndIndex)
                $(this).data("hasPopover2", true);
                $(this).popover({ trigger: 'manual', cache: false, placement: 'top', content: content });
                $(this).popover("show");
            }
        }
        //样例  { InVols: [{ "name": "氯化钠", "value": 100 }, { "name": "葡萄糖", "value": 110 }], OutVols: [{ "name": "尿", "value": 150 }, { "name": "胃液", "value": 130 }] };

        var StatisticsDetailInfo = rowData.StatisticsDetailInfo;
        var opts = $('#' + self.id).datagrid('options');
        if (opts.statisticsDetailTooltip && !!StatisticsDetailInfo && StatisticsDetailInfo != "null") {
            var detailHtml = "<table cellspacing=0 border=1 sytle='border-collapse:collapse;'>";
            detailHtml += "<tr><th></th><th>" + $g("名称") + "</th><th>" + $g("量") + "</th></tr>";
            $.each(StatisticsDetailInfo.InVols, function (i, n) {
                if (i == 0)
                    detailHtml += "<tr><td rowspan=" + StatisticsDetailInfo.InVols.length + ">入液量分项</td><td style='width:100px;'>" + n.name + "</td><td style='width:50px'>" + n.value + "</td></tr>";
                else
                    detailHtml += "<tr><td>" + n.name + "</td><td>" + n.value + "</td></tr>";
            });
            $.each(StatisticsDetailInfo.OutVols, function (i, n) {
                if (i == 0)
                    detailHtml += "<tr><td rowspan=" + StatisticsDetailInfo.OutVols.length + ">出液量分项</td><td style='width:100px'>" + n.name + "</td><td style='width:50px'>" + n.value + "</td></tr>";
                else
                    detailHtml += "<tr><td>" + n.name + "</td><td>" + n.value + "</td></tr>";
            });
            detailHtml += "</table>";
            var offset = 0;
            if ($(this).width() / 2 > e.clientX)
                offset = -($(this).width() / 2 - e.clientX);
            else if ($(this).width() / 2 < e.clientX)
                offset = e.clientX - ($(this).width() / 2);
            $(this).data("hidePopover", "outer");
            var ttt = this;
            $(this).popover({
                trigger: 'manual', cache: false, placement: 'bottom', content: detailHtml, offsetTop: -15, offsetLeft: offset,
                onHide: function (e) {
                    console.log('hide');
                },
                onShow: function (e) {
                    $(e).mouseenter(function (e1) {
                        $(ttt).data("hidePopover", "inner");
                    });
                    $(e).mouseleave(function (e1) {
                        $(ttt).popover("hide");
                    });
                }
            });
            $(this).popover("show");
        }
    });

    $("#" + tableDivID + " .datagrid-row").mouseleave(function () {
        if ($(this).data("hasPopover2") === true) {
            $(this).popover("hide");
        }
        if ($(this).data("hidePopover") === "outer") {
            var ttt = this;
            setTimeout(function () {
                if ($(ttt).data("hidePopover") === "outer")
                    $(ttt).popover("hide");
            }, 100);
        }
    });

    if (!!$("#" + this.id).data("StatisticsMergeDisColumns")) {
        var mergeColumns = $("#" + this.id).data("StatisticsMergeDisColumns");
        var startField = mergeColumns[0];
        var mergeCount = mergeColumns.length;
        $.each(data.rows, function (i, rowData) {
            if (!!rowData.StatisticsInfo && (rowData.StatisticsInfo.type == "TwentyFourHoursStatistics" || rowData.StatisticsInfo.type == "TimeQuantumStatistics"
                || rowData.StatisticsInfo.type == "DaytimeStatistics" || rowData.StatisticsInfo.type == "SingleItemStatistics")) {
                $(self).datagrid('mergeCells', {
                    index: i,
                    field: startField,
                    colspan: mergeCount
                });
            }
        });
    }
}
/**
 * hisui数据表格右键菜单响应
 * @method OnHisUiTableMenuHandler 
**/
function OnHisUiTableMenuHandler(item) {
    if (item.id == "menuRePrintSet") {
        if ($("#rePrintDialog").length == 0)
            $("body").append(document.getElementById('RePrintSetDialogTemplate').innerHTML);

        $("#rePrintDialog #startPageNo").numberbox();
        $("#rePrintDialog #startPageNo").numberbox('reset');
        $("#rePrintDialog #startRowNo").numberbox();
        $("#rePrintDialog #startRowNo").numberbox('reset');
        var tableID = $(this).data("TableID");
        $("#rePrintDialog").data("TableID", tableID);
        $("#rePrintDialog").dialog();
        $("#rePrintDialog").dialog('open');
    }
    if (item.id == "menuReSetTableTitle") {
        var tableID = $(this).data("TableID");
        var opts = $('#' + tableID).datagrid('options');
        var DynamicTableTitleDropListElementID = "";
        if (!!opts.gatherParams) {
            $("select[id^='DropListElement_']").each(function (i) {
                var options = $(this).combobox("options");
                if (options.onSelect == DynamicTableTitleDropListChange && [opts.gatherParams].indexOf($(this).attr("id")) > -1) {
                    DynamicTableTitleDropListElementID = $(this).attr("id");
                    return false;
                }
            });
        }
        if (!!DynamicTableTitleDropListElementID) {
            var checkedIds = DataTableCheckRowIds(tableID);
            if (!checkedIds){
                $.messager.alert(" ", $g("请选择要操作的记录"), "info");
                return false;
            }
            var DynamicTableTitles = $('#' + DynamicTableTitleDropListElementID).combobox("getData");
            var currentDynamicTableTitle = GetValueById(DynamicTableTitleDropListElementID);

            if (currentDynamicTableTitle.length == 0 || currentDynamicTableTitle.Text == kongbiaotou){
                $.messager.alert(" ", $g("空表头不能变更表头"), "info");
                return false;
            }
            else {
                $("<div id='reSetTableTitleDialog' class='hisui-dialog'></div>").dialog({
                    title: '变更表头',
                    modal: true,
                    width: 350,
                    height: 200,
                    content: "<div style='margin-top:50px;text-align:center'><select id='dynamicTableTitles' name='dynamicTableTitle' placeholder='请选择要变更的表头' style='width:300px;'></select></div>",
                    buttons: [{
                        text: '确定',
                        handler: function () {
                            var destinationTableTitle = window.ElementUtility["DropListElement"].getValueById("dynamicTableTitles");
                            if (destinationTableTitle.length == 0) {
                                $.messager.alert(" ", $g("请选择要变更的表头"), "info");
                            }
                            else {
                                var slectedValue = currentDynamicTableTitle[0].Text;
                                slectedValue = DynamicTableTitleFormater(slectedValue);
                                var _sourceTitles = slectedValue.split(" ");
                                _sourceTitles.shift();

                                slectedValue = destinationTableTitle[0].Text;
                                slectedValue = DynamicTableTitleFormater(slectedValue);
                                var _destinationTitles = slectedValue.split(" ");
                                _destinationTitles.shift();

                                var _bContainer = true;
                                $.each(_sourceTitles, function (i, n) {
                                    if (_sourceTitles[i].split("-").length > 1 && _sourceTitles[i].split("-")[1] != "")
                                    {
                                        if ($.inArray(n, _destinationTitles) == -1) {
                                            _bContainer = false;
                                            return false;
                                        }
                                    }
                                });

                                if (!_bContainer){
                                    $.messager.alert(" ", $g("表头不匹配，无法变更"), "info");
                                }
                                else{
                                    
                                    var head = destinationTableTitle[0].Text.replace(/\s{1}(Y|N)\s{1}/, destinationTableTitle[0]["Value"] + " ");
                                    var msg = tkMakeServerCall("NurMp.TableChangeHead", "UpdateHead", checkedIds, head);
                                    var reMsg = JSON.parse(msg);
                                    if (MsgIsOK(reMsg)) {
                                        $('#reSetTableTitleDialog').dialog('destroy');
                                        var queryParam = $("#" + tableID).attr("queryInfo");
                                        GetDataFromService(null, [tableID], GetDBTablePageInfo(tableID, GetDBTablePageNumber(tableID)), queryParam);
                                    }
                                    else
                                        $.messager.alert($g("提示"), $g("操作失败\n错误原因：") + reMsg.msg, "error");
                                }
                            }
                        }
                    }, {
                        text: '取消',
                        handler: function () {
                            $('#reSetTableTitleDialog').dialog('destroy');
                        }
                    }],
                    onClose: function () {
                        $(this).dialog('destroy');
                    },
                    onOpen: function () {
                        $('#dynamicTableTitles').combobox({ panelHeight: 'auto', valueField: 'Value', textField: 'Text' });
                        $('#dynamicTableTitles').combobox("loadData", DynamicTableTitles);
                    }
                });
            }
        }
        else {
            $.messager.alert(" ", $g("请检查编辑器，此操作需要配置采集下拉表头"), "info");
            return false;
        }

    }
    if (item.id == "preSwitchTableHeadMenu" || item.id == "nextSwitchTableHeadMenu") {
        var tableID = $(this).data("TableID");
        var opts = $('#' + tableID).datagrid('options');
        var DynamicTableTitleDropListElementID = "";
        if (!!opts.gatherParams) {
            $("select[id^='DropListElement_']").each(function (i) {
                var options = $(this).combobox("options");
                if (options.onSelect == DynamicTableTitleDropListChange && [opts.gatherParams].indexOf($(this).attr("id")) > -1) {
                    DynamicTableTitleDropListElementID = $(this).attr("id");
                    return false;
                }
            });
        }
        if (!!DynamicTableTitleDropListElementID) {
            var DynamicTableTitles = $('#' + DynamicTableTitleDropListElementID).combobox("getData");
            var currentDynamicTableTitle = GetValueById(DynamicTableTitleDropListElementID);
            if (currentDynamicTableTitle.length == 0 || currentDynamicTableTitle[0].Text == kongbiaotou) {
                $.messager.alert(" ", $g("没有更多的表头,请新建表头"), "info");
                return false;
            }
            var index = -1;
            $.each(DynamicTableTitles, function (i, n) {
                if (n.Value === currentDynamicTableTitle[0].Value) {
                    index = i;
                    return false;
                }
            });
            if (item.id == "nextSwitchTableHeadMenu")
            {
                index = index + 1;
                if (index > DynamicTableTitles.length -1)
                {
                    $.messager.alert(" ", $g("已经是最后一个表头"), "info");
                    return false;
                }
            }
            else {
                index = index - 1;
                if (index < 0) {
                    $.messager.alert(" ", $g("已经是第一个表头"), "info");
                    return false;
                }
            }
            var helper = GetElementHelper(DynamicTableTitleDropListElementID);
            helper.banding(DynamicTableTitleDropListElementID,[DynamicTableTitles[index]]);
        }
        else {
            $.messager.alert(" ", $g("请配置表格采集表头下拉元素"), "info");
            return false;
        }
    }
    //扩展菜单项响应
    if (window.ExtendTableMenuEventFunc != undefined && $.type(window.ExtendTableMenuEventFunc) === "function") {
        window.ExtendTableMenuEventFunc(item);
    }
}
/**
 * 行转列数据表格单元格事件
 * @method OnRowToColDataTableHandler 
**/
function OnRowToColDataTableHandler(id) {
    $("#" + id + " td").click(function () {
        var div = $(this).find("div[class^='col_']");
        if ($(this).is("[rowID]") && !!div && div.length == 1) {
            var colid = $(div).attr("colid");

            if ($(div).parent().hasClass("datagrid-row-selected")) {
                clearAll("datagrid-row-selected");
                return;
            }

            clearAll("datagrid-row-selected");

            $("#" + id + " div[class^='" + colid + "']").each(function (i) {
                $(this).parent().addClass("datagrid-row-selected");
            });
        }
    });
    $("#" + id + " td").mouseout(function () {
        var div = $(this).find("div[class^='col_']");
        if (!!div && div.length == 1) {
            clearAll("datagrid-row-over");
        }
    });
    $("#" + id + " td").mouseover(function () {
        var div = $(this).find("div[class^='col_']");
        if (!!div && div.length == 1) {
            clearAll("datagrid-row-over");

            var colid = $(div).attr("colid");
            $("#" + id + " div[class^='" + colid + "']").each(function (i) {
                $(this).parent().addClass("datagrid-row-over");
            });
        }
    });
    $("#" + id + " td").dblclick(function () {
        var div = $(this).find("div[class^='col_']");
        if ($(this).is("[rowID]") && !!div && div.length == 1) {

            var callbackEdit = "callbackEdit_" + id;
            var gatherEdit = "gatherEdit_" + id;
            if (!($.type(window[callbackEdit]) === "function")) {
                window[callbackEdit] = function () {
                    DBTableLoadData(id);
                };
            }

            if (!($.type(window[gatherEdit]) === "function")) {
                window[gatherEdit] = function () {
                    return GatherTemplateSpecifyFiledsData([id]);
                };
            }

            var basicInfoJSON = $("#" + id).attr("BasicInfo");
            basicInfoJSON = basicInfoJSON.replace(/'/g, '"');
            var basicInfoObj = jQuery.parseJSON(basicInfoJSON);
            var urlPartParam = "NurMPDataID=" + $(this).attr("rowid");
            var updateVerifyRelatedSignField = basicInfoObj.UpdateVerifyRelatedSignField;
            if (!!updateVerifyRelatedSignField) {
                var isOK = IsVerifyEditPermission($(this).attr("rowid"), updateVerifyRelatedSignField);
                if (!isOK)
                    return;
            }
            OpenWindow(basicInfoObj.TemplateIndentity, callbackEdit, gatherEdit, urlPartParam, basicInfoObj.WinInfo);
        }
    });

    function clearAll(cssClass) {
        $("#" + id + " div[class^='col_']").each(function (i) {
            $(this).parent().removeClass(cssClass);
        });
    }

}
/**
 * hisui数据表格右键菜单操作
 * @method OnHisUITableRowContextMenu 
**/
function OnHisUITableRowContextMenu(e, rowIndex, rowData) {
    var tableID = $(this).attr("id");
    var opts = $('#' + tableID).datagrid('options');

    $('#hisUITableMenu').menu('destroy');
    $("body").append(document.getElementById('HisUITableMenuTemplate').innerHTML);
    
    if (!!opts.CopyMenu && $("#hisUITableMenu > #menuCopy").length == 0)
        $("#hisUITableMenu").append("<div id='menuCopy'>复制</div>");
    if (!!opts.RePrintSetMenu && $("#hisUITableMenu > #menuRePrintSet").length == 0)
        $("#hisUITableMenu").append("<div id='menuRePrintSet'>补打设置</div>");
    if (!!opts.ReSetTableHeadMenu && $("#hisUITableMenu > #menuReSetTableTitle").length == 0)
        $("#hisUITableMenu").append("<div id='menuReSetTableTitle'>变更表头</div>");
    if (!!opts.SwitchTableHeadMenu && $("#hisUITableMenu > #preSwitchTableHeadMenu").length == 0)
        $("#hisUITableMenu").append("<div id='preSwitchTableHeadMenu'>上一个表头</div>");
    if (!!opts.SwitchTableHeadMenu && $("#hisUITableMenu > #nextSwitchTableHeadMenu").length == 0)
        $("#hisUITableMenu").append("<div id='nextSwitchTableHeadMenu'>下一个表头</div>");
    
    //扩展菜单项
    if (window.ExtendTableMenuFunc != undefined && $.type(window.ExtendTableMenuFunc) === "function") {
        window.ExtendTableMenuFunc();
    }

    if ($("#hisUITableMenu").children().length > 0) {
        $("#hisUITableMenu").data("TableID", tableID);
        $("#hisUITableMenu").data("RowID", rowData.ID);
        $('#hisUITableMenu').menu();
        $('#hisUITableMenu').menu('show', { left: e.pageX, top: e.pageY });

        if ($("#hisUITableMenu > #menuCopy").length == 1) {
            var clipboard1 = new ClipboardJS('#hisUITableMenu > #menuCopy', {
                text: function () {
                    return window.TableClipboardContent;
                }
            });
        }
        e.preventDefault();
    }
}
/**
 * hisui数据表格选中事件
 * @method OnHisUITableRowContextMenu 
**/
function OnHisUITableRowSelect(rowIndex, rowData) {
    var rowfilter = "tr[datagrid-row-index='" + rowIndex + "']";
    var row = $('#div_' + this.id + ' .datagrid-btable').eq(1).find(rowfilter);
    if (rowData != undefined && !!rowData.PrintInfo && rowData.PrintInfo != "null") {
        $(row).removeClass('datagrid-row-mp-printed');
    }
}
/**
 * hisui数据表格取消选中事件
 * @method OnHisUITableRowContextMenu 
**/
function OnHisUITableRowUnSelect(rowIndex, rowData) {
    var rowfilter = "tr[datagrid-row-index='" + rowIndex + "']";
    var row = $('#div_' + this.id + ' .datagrid-btable').eq(1).find(rowfilter);
    if (rowData != undefined && !!rowData.PrintInfo && rowData.PrintInfo != "null") {
        $(row).addClass('datagrid-row-mp-printed');
    }
}

function UpdateEditCellInfo(identity) {
    var tableId = GetTableIdByIndentity(identity);
    if (IsTableCellEdit(tableId)) {
        var currentCell = $("#" + tableId).datagrid("cell");
        window.HisuiEditors[tableId].editField = currentCell.field;
        window.HisuiEditors[tableId].editIndex = currentCell.index;
    }
}

function UpdateEditCellNotEditStatus(identity, isEnable) {
    var tableId = GetTableIdByIndentity(identity);
    var field = GetTableFieldByIndentity(identity);

    var opts = $('#' + tableId).datagrid('getColumnOption', field);
    if (!!opts.editOpenWindowTemplate)
        return false;   
    var key = window.HisuiEditors[tableId].editIndex + field;
    if (isEnable) {
        var index = window.HisuiEditors[tableId].NoEdit.indexOf(key);
        if (index >= 0)
            window.HisuiEditors[tableId].NoEdit.splice(index, 1);
    }
    else {
        var index = window.HisuiEditors[tableId].NoEdit.indexOf(key);
        if (index == -1)
            window.HisuiEditors[tableId].NoEdit.push(key);
    }
}

function GetTableCellData(identity) {
    var tableId = GetTableIdByIndentity(identity);
    var field = GetTableFieldByIndentity(identity);
    var editRowIndex = window.HisuiEditors[tableId].editIndex;
    var cellData = null;
    var helper = GetElementHelper(identity);
    var rowDatas = $('#' + tableId).datagrid("getRows");
    if (field == window.HisuiEditors[tableId].editField) {
        if (helper != undefined)
            cellData = helper.getValueByName(identity);
    }
    else {
        cellData = rowDatas[editRowIndex][field];
    }
    return cellData;
}

function GetTableCellDataReturnSpecifyFiledsData(identity) {
    var tableId = GetTableIdByIndentity(identity);
    var field = GetTableFieldByIndentity(identity);
    var cellData = GetTableCellData(identity);
    return { keys: [field], vals: [cellData] };
}

function SetTableCellData(identity, val) {
    var tableId = GetTableIdByIndentity(identity);
    var field = GetTableFieldByIndentity(identity);
    var editRowIndex = window.HisuiEditors[tableId].editIndex;
    if (editRowIndex == undefined)
        return;
    var type = GetElementStringType(identity);
    var rowDatas = $('#' + tableId).datagrid("getRows");
    var changeFun = function () {
        var dg = $('#' + tableId);
        var opt = dg.datagrid('getColumnOption', field);
        if (!!opt.editor && $.type(opt.editor.options.ChangeFunc) === "function") {
            opt.editor.options.ChangeFunc();
        } 
    };
    if (field == window.HisuiEditors[tableId].editField) {
        if (ElementUtility[type] != undefined)
            ElementUtility[type].banding(identity, val);
    }
    else {
        if (type == "CheckElement" || type == "DropListElement" || type == "RadioElement" ||
	        type == "DropCheckboxElement" || type == "DropRadioElement") {
            if ($.isPlainObject(val)) {
                if (val.values.length == 0) {
                    rowDatas[editRowIndex][field] = [];
                }
                else {
                    var filterVal = [];
                    var op = $("#" + tableId).datagrid("getColumnOption", field);
                    var editor = !!op.editor ? op.editor : op.editor1;
                    $.each(editor.options.data, function (dindex, dvalue) {
                        $.each(val.values, function (vindex, vvalue) {
                            if (vvalue.Value == dvalue.Value) {
                                filterVal.push(dvalue);
                                return false;
                            }
                        });
                    });
                    rowDatas[editRowIndex][field] = filterVal;
                }
            }
            else {
                rowDatas[editRowIndex][field] = val;
            }
        }
        else {
            rowDatas[editRowIndex][field] = val;
        }
        changeFun();
    }
}
/**
* hisUI表格行，当用户勾选一行
* @method OnHisUITableCheck
**/
function OnHisUITableCheck(rowIndex, rowData) {
    var self = this;
    var tableId = self.id;

    var rows = $('#' + tableId).datagrid('getRows');
    $.each(rows, function (i, row) {
        if (row.parentId == rowData.ID)
            $('#' + tableId).datagrid('checkRow',i);
    });
}
function OnHisUITableUncheck(rowIndex, rowData) {
    var self = this;
    var tableId = self.id;

    var rows = $('#' + tableId).datagrid('getRows');
    $.each(rows, function (i, row) {
        if (row.parentId == rowData.ID)
            $('#' + tableId).datagrid('uncheckRow', i);
    });
}


function InitStatisticsRowEdit(tableID, editIndex, rowData) {
    if (editIndex === undefined) { return true; }
    if (IsStatisticsRow(rowData)) {

        var columns = [];
        var dg = $('#' + tableID);
        var fields = GetTableColumnFields(tableID);
        $.map(fields, function (field) {
            columns.push(dg.datagrid('getColumnOption', field));
            if (rowData[field + "old"] != undefined)
                rowData[field] = rowData[field + "old"];
        });

        window.HisuiEditors[tableID].editElements = [];
        $.each(columns, function (i, col) {
            if (col.hasOwnProperty("editor") && !!col.editor) {
                window.HisuiEditors[tableID].editors[col.field] = col.editor;
                if (col.editor.type == "datebox" || col.editor.type == "timespinner") {//统计的日期和时间不允许修改
                    //col.editor = { type: col.editor.type, options: { ID: col.editor.options.ID } };
                    col.editor = null;
                    var tr = $('#' + tableID).datagrid('options').finder.getTr($('#' + tableID)[0], editIndex);
                    var trindex = tr.length - 1;
                    tr[trindex].cells[i].innerText = rowData[col.field];
                }
                else {
	                var tempID = "";
	                if (col.editor.type == "validatebox")
	                	tempID="edit" + tableID + "_" + col.field + "Statistics";
	                else
	                	tempID="edit" + tableID + "_" + "TextElement_" + i + "Statistics"
                    var tempEditor = { type: "validatebox", options: { ID: tempID } };
                    if (col.editor.options.Signature != undefined) tempEditor.options.Signature = col.editor.options.Signature;
                    if (col.editor.options.SignatureAuto != undefined) tempEditor.options.SignatureAuto = col.editor.options.SignatureAuto;
                    col.editor = tempEditor;
                    window.HisuiEditors[tableID].editElements.push(col.editor.options.ID);        
                }    
            }
            else {
                var tr = $('#' + tableID).datagrid('options').finder.getTr($('#' + tableID)[0], editIndex);
                var cells = [];

                $.each(tr, function (k, _tr) {
                    for(var n = 0;n<_tr.cells.length;n++){
                        cells.push(_tr.cells[n]);
                    }
                });
   
                if (col.field == "ID")
                    return;
                cells[i].innerText = rowData[col.field];
            }
        });
    }
}

function ClearStatisticsRowEdit(tableID, editIndex, rowData) {
    if (editIndex === undefined) { return true; }
    if (IsStatisticsRow(rowData)) {
        window.HisuiEditors[tableID].editElements = [];
        var dg = $('#' + tableID);
        var fields = GetTableColumnFields(tableID);
        var columns = [];
        $.map(fields, function (field) {
            columns.push(dg.datagrid('getColumnOption', field));
        });
        $.each(columns, function (i, col) {            
            if (!!window.HisuiEditors[tableID].editors[col.field])
                col.editor = window.HisuiEditors[tableID].editors[col.field];
            if (!!col.editor)
                window.HisuiEditors[tableID].editElements.push(col.editor.options.ID);
        });
    }
}

function CellEditByOpenWindow(tableID, field) {
        
    var tableOpts = $('#' + tableID).datagrid('options');
    if (!!tableOpts.onlyRadioDBClickEdit) {
        var editorType = GetElementStringType(field);
        if (editorType == "RadioElement")
        {
            var formElement = "edit" + tableID + "_" + field;
            var formElementData = $("#" + formElement).combobox("getData");
            if (!!formElementData && formElementData.length == 1) {
                setTimeout(function () {
                    var e = $.Event("keydown");
                    e.keyCode = 27; // for Esc

                    var input = $("#" + formElement).combobox('textbox');
                    var currentvalue = GetValueByName(formElement);
                    if (!!currentvalue && currentvalue.length == 0) {
                        SetOneValue(formElement, $("#" + formElement).combobox("getData"));
                    }
                    else {
                        SetOneValue(formElement, []);
                    }
                    $(input).trigger(e);
                }, 1);
            }
        }
    }

    var opts = $('#' + tableID).datagrid('getColumnOption', field);
    var windowInfo = null;
    if (!!opts.windowsInfo)
        windowInfo = opts.windowsInfo;
    if (!!opts.editOpenWindowTemplate && !opts.hidden)
    {
        if (opts.editOpenWindowByMPDataID === "True")
        {
            OpenNewWindowByNurMPDataID('Gather_' + opts.editor.options.ID, 'Callback_' + opts.editor.options.ID, opts.editOpenWindowTemplate, windowInfo);
        }
        else
            OpenNewWindow('', 'Callback_' + opts.editor.options.ID, opts.editOpenWindowTemplate, windowInfo);
    }
        
}

function GetDynamicTableTitleMergeInfos(opts) {
    var columnInfos = opts.columns;
    var mergeInfos = {keys:[],vals:[]};
    /*例子：{
            keys:["0_10_3", "0_12_5"]
            vals:[["1_0_1_TextareaElement_23","1_1_1_TextareaElement_24","1_2_1_TextareaElement_25"],["","","","",""]]
    */
    for (var row = 0; row < columnInfos.length; row++) {
        for (var col = 0; col < columnInfos[row].length; col++) {
            if (!!columnInfos[row][col]["colspan"] && parseInt(columnInfos[row][col].colspan) >= 1) {
                var rowspan = !!columnInfos[row][col]["rowspan"] ? parseInt(columnInfos[row][col].rowspan) : 1;
                var key = row + "_" + col + "_" + parseInt(columnInfos[row][col].colspan) + "_" + rowspan;
                mergeInfos.keys.push(key);
                mergeInfos.vals.push([]);
            }
            
            var findMergeIndex = null;
            $.each(mergeInfos.keys, function (i, mergeId) {
                var mergeSub = mergeInfos.vals[i];

                if (!!mergeId && !!mergeSub) {
                    var _tsplit = mergeId.split("_");
                    var subNum = 0;
                    $.each(mergeSub, function (k, n) {
                        var _tcellsplit = n.split("_");
                        subNum = subNum + (+_tcellsplit[2]);
                    });
                    if ((0 + (+_tsplit[0]) + (+_tsplit[3])) == row && subNum < (+_tsplit[2])) {
                        findMergeIndex = i;
                        return false;
                    }
                }
            });
            if (findMergeIndex !== null) {
                var mergeId = mergeInfos.keys[findMergeIndex];
                var colspan = !!columnInfos[row][col]["colspan"] ? parseInt(columnInfos[row][col].colspan) : 1;
                var rowspan = !!columnInfos[row][col]["rowspan"] ? parseInt(columnInfos[row][col].rowspan) : 1;
                var subCell = row + "_" + col + "_" + colspan + "_" + rowspan + "_" + columnInfos[row][col].field+"F";
                mergeInfos.vals[findMergeIndex].push(subCell);
            }
        }
    }
    //将父合并单元格，用子单元格来替换，便于将来删除空白列
    for (var i = mergeInfos.keys.length - 1; i >= 0 ; i--) {
        var mergeId = mergeInfos.keys[i];
        var mergeSub = mergeInfos.vals[i];

        $.each(mergeInfos.vals, function (j, mergeInfo) {
            $.each(mergeInfo, function (h, s) {
                if (s.indexOf(mergeId) != -1) {
                    mergeInfo.splice(h, 1);
                    mergeInfos.vals[j] = mergeInfo.concat(mergeSub);
                    return false;
                }
            });
        });
    }
    return mergeInfos;
}

function GetDynamicTableTitleParentTitleBanding(tableID) {
    if (!tableID)
        return "";
    var re = [];
    if (IsHisUIDataTable(tableID)) {
        var opts = $("#div_" + tableID).data("nurOldOpts");
        $.each(opts.columns, function (i, row) {
            $.each(row, function (j, col) {
                if (!!col["colspan"]) {
                    var _bandingIndex = -1;
                    var _colspan = "" + col["colspan"];//保证是个字符串
                    if (_colspan.indexOf("dyTitle") > -1) {
                        _bandingIndex = _colspan.split("\"")[2];
                        re.push(_bandingIndex);
                    }
                }
            });
        });
        if (re.length > 0)
            return "^" + re.join("^");
        else
            return "";
    }
    else {
        return "";
    }
}

/**
 * 返回hisUI表格的签名列字段,可以是多个
 * @method HasSignedColoumn 
**/
function HasSignColumn(tableID) {
    var columns = GetTableColumnFields(tableID);
    var SignColumnFields = $.map(columns, function (col) {
        if (col.SignColumn !== undefined && col.SignColumn === true)
            return col.field;
        else
            return null;
    });
    return SignColumnFields;
}


