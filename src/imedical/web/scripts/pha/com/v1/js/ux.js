/**
 * ����:	 ҩ����������
 * ��д��:	 yunhaibao
 * ��д����: 2019-05-06
 */
var PHA_UX = {
    DHCPHCCat: function(_id, _opts, _callBack) {
        var _winDivId = _id + "_PHA_UX_DHCPHCCat";
        var _tgId = _id + "_PHA_UX_DHCPHCCat_TG";
        var _winToolBarId = _id + "_PHA_UX_DHCPHCCat_TG_BAR";
        var _barAliasId = _id + "_bar";
        if ($("#" + _winDivId).text() == "") {
            var _winDiv = "<div id=" + _winDivId + ' style="padding:10px;overflow:hidden;"><div style="border:1px solid #cccccc;width:100%;height:100%;border-radius: 4px;"><div id=' + _tgId + "></div></div></div>";
            var _winToolBarDiv = "<div id=" + _winToolBarId + ' style="padding:10px;border-bottom:none;"><input id=' + _barAliasId + "></div>";
            $("body").append(_winDiv);
            $("body").append(_winToolBarDiv);
            var _treeColumns = [
                [
                    {
                        field: "phcCatDesc",
                        title: "ҩѧ����",
                        width: 300
                    },
                    {
                        field: "phcCatDescAll",
                        title: "ҩѧ����ȫ��",
                        width: 300,
                        hidden: true
                    },
                    {
                        field: "phcCatId",
                        title: "phcCatId",
                        hidden: true
                    },
                    {
                        field: "_parentId",
                        title: "parentId",
                        hidden: true
                    }
                ]
            ];
            $("#" + _tgId).treegrid({
                animate: true,
                border: false,
                fit: true,
                nowrap: true,
                fitColumns: true,
                singleSelect: true,
                idField: "phcCatId",
                treeField: "phcCatDesc",
                rownumbers: false, //�к�
                columns: _treeColumns,
                showHeader: false,
                url: $URL,
                queryParams: {
                    ClassName: "PHA.STORE.Drug",
                    QueryName: "DHCPHCCat",
                    page: 1,
                    rows: 9999
                },
                toolbar: "#" + _winToolBarId,
                onDblClickRow: function(rowIndex, rowData) {
                    $("#" + _winDivId).window("close");
                    _callBack(rowData);
                }
            });
        }
        $("#" + _winDivId)
            .window({
                title: "ҩѧ����",
                collapsible: false,
                iconCls: "icon-w-list",
                maximizable: false,
                minimizable: false,
                border: false,
                closed: true,
                modal: true,
                width: 600,
                height: 500,
                onBeforeClose: function() {
                    // $("#UpdateBatNoWindowDiv").remove()
                }
            })
            .window("open");
        $("#" + _barAliasId).searchbox({
            width: $("#" + _winToolBarId).width(),
            searcher: function(text) {
                $("#" + _tgId).treegrid("options").queryParams.InputStr = text;
                $("#" + _tgId).treegrid("reload");
                $("#" + _barAliasId).searchbox("clear");
                $("#" + _barAliasId)
                    .next()
                    .children()
                    .focus();
            }
        });
        $("#" + _barAliasId)
            .next()
            .find(".searchbox-text")
            .attr("placeholder", "����������س���ѯ...");
    },
    /**
     * ͨ������봰��
     * @param {Object}  _opts
     * 						tblName ����
     * 						codeName ������ֵ�ֶ���
     * 						title ��������
     * @param {Function} _callBack �ص�����
     */
    MaxCode: function(_opts, _callBack) {
        var _winDivId = "PHA_UX_MaxCode";
        var _preCodeId = "preCode_PHA_UX_MaxCode";
        var _maxCodeId = "maxCode_PHA_UX_MaxCode";
        // if ($("#" + _winDivId).text() == "") {
        var _winDiv = "<div id=" + _winDivId + ' style="overflow:hidden;">';
        _winDiv += '<div class="pha-row">';
        _winDiv += '<div class="pha-col">';
        _winDiv += '<div class="pha-tip-info" style="width:230px">�������Ϊǰ׺֮�������+1</div>';
        _winDiv += "</div>";
        _winDiv += "</div>";
        _winDiv += '<div class="pha-row">';
        _winDiv += '<div class="pha-col">';
        _winDiv += '<div class="pha-tip-info" style="width:230px">��MEDIWAY+5 �����׺5λ����</div>';
        _winDiv += "</div>";
        _winDiv += "</div>";
        _winDiv += '<div class="pha-row">';
        _winDiv += '<div class="pha-col">';
        _winDiv += "<label>ǰ׺��</label>";
        _winDiv += '<div class="pha-col">';
        _winDiv += "<input id=" + _preCodeId + ' class="hisui-validatebox" style="width:200px" placeholder="¼�����س�...">';
        _winDiv += "</div>";
        _winDiv += "</div>";
        _winDiv += "</div>";
        _winDiv += '<div class="pha-row">';
        _winDiv += '<div class="pha-col">';
        _winDiv += "<label>�����</label>";
        _winDiv += '<div class="pha-col">';
        _winDiv += "<input id=" + _maxCodeId + ' class="hisui-validatebox" style="width:200px">';
        _winDiv += "</div>";
        _winDiv += "</div>";
        _winDiv += "</div>";
        _winDiv += "</div>";
        $("body").append(_winDiv);
        $.parser.parse($("#PHA_UX_MaxCode"));
        // }
        $("#" + _winDivId)
            .dialog({
                title: _opts.title,
                collapsible: false,
                iconCls: "icon-w-find",
                resizable: false,
                maximizable: false,
                minimizable: false,
                closable: false,
                border: false,
                closed: true,
                modal: true,
                width: 275,
                height: 250,
                buttons: [
                    {
                        text: "ȷ��",
                        handler: function() {
                            var maxCode = $("#" + _maxCodeId).val();
                            _callBack(maxCode);
                            $("#" + _winDivId).window("close");
                        }
                    },
                    {
                        text: "ȡ��",
                        handler: function() {
                            $("#" + _winDivId).window("close");
                        }
                    }
                ],
                onBeforeClose: function() {
                    $("#" + _winDivId).remove();
                }
            })
            .dialog("open");
        $("#" + _preCodeId).on("keypress", function(event) {
            if (window.event.keyCode == "13") {
                $.cm(
                    {
                        ClassName: "PHA.COM.MaxCode",
                        MethodName: "Generate",
                        TblName: _opts.tblName,
                        CodeName: _opts.codeName,
                        PrefixData: $("#" + _preCodeId).val(),
                        dataType: "text"
                    },
                    function(text) {
                        if (text == "") {
                            PHA.Alert("��ʾ", "��¼���ǰ׺��Ҫ��ϵͳ�д���</br>���Ϊȫ�¹���,�״���¼��", "warning");
                        }
                        $("#" + _maxCodeId).val(text);
                    }
                );
            }
        });
    },
    /**
     * �������壬�����ʽͳһ�����ݲ�ͬ
     */
    Alias: function(_opts, _callBack) {
        var _preId = "PHA_UX_Alias_" + Math.floor(Math.random() * 10000 + 1);
        var _winDivId = _preId;
        var _gridId = "grid_" + _preId;
        var _winToolBarId = "gridBar_" + _preId;
        var btnAddId = "btnAdd" + _preId;
        var btnSaveId = "btnSave" + _preId;
        var btnDelId = "btnDel" + _preId;
        var _winDiv = "<div id=" + _winDivId + ' style="padding:10px;overflow:hidden;"><div style="border:1px solid #cccccc;width:100%;height:100%;border-radius: 4px;"><div id=' + _gridId + "></div></div></div>";
        var _winToolBarDiv = "<div id=" + _winToolBarId + ">";
        _winToolBarDiv += "<div>";
        _winToolBarDiv += '<a class="hisui-linkbutton" plain="true" iconCls="icon-add" id=' + btnAddId + " >����</a>";
        _winToolBarDiv += '<a class="hisui-linkbutton" plain="true" iconCls="icon-save" id=' + btnSaveId + ">����</a>";
        _winToolBarDiv += '<a class="hisui-linkbutton" plain="true" iconCls="icon-remove" id=' + btnDelId + ">ɾ��</a>";
        _winToolBarDiv += "</div>";
        _winToolBarDiv += "</div>";
        $("body").append(_winDiv);
        $("body").append(_winToolBarDiv);
        $.parser.parse($("#" + _winDivId));
        $.parser.parse($("#" + _winToolBarId));
        var columns = [
            [
                {
                    field: "aliasId",
                    title: "����Id",
                    hidden: true,
                    width: 100
                },
                {
                    field: "aliasText",
                    title: "����",
                    width: 200,
                    editor: {
                        type: "validatebox",
                        options: {
                            required: true
                        }
                    }
                }
            ]
        ];
        var dataGridOption = {
            url: $URL,
            queryParams: _opts.queryParams,
            pagination: false,
            columns: columns,
            fitColumns: true,
            toolbar: "#" + _winToolBarId,
            enableDnd: false,
            onClickRow: function(rowIndex, rowData) {
                $(this).datagrid("endEditing");
                // $("[datagrid-row-index="+rowIndex+"]").css("background","red")
            },
            onDblClickCell: function(rowIndex, field, value) {
                $(this).datagrid("beginEditCell", {
                    index: rowIndex,
                    field: field
                });
            }
        };
        PHA.Grid(_gridId, dataGridOption);
        $("#" + _winDivId)
            .window({
                title: _opts.title,
                collapsible: false,
                iconCls: "icon-w-edit",
                resizable: false,
                maximizable: false,
                minimizable: false,
                border: false,
                closed: true,
                modal: true,
                width: 400,
                height: 400,
                onBeforeClose: function() {
                    $("#" + _winToolBarId).remove();
                    $("#" + _winDivId).remove();
                    _callBack();
                }
            })
            .window("open");
        // ��ť�¼�
        $("#" + btnAddId).on("click", function() {
            $("#" + _gridId).datagrid("addNewRow", {});
        });
        $("#" + btnSaveId).on("click", function() {
            var $_grid = $("#" + _gridId);
            $_grid.datagrid("endEditing");
            var gridChanges = $_grid.datagrid("getChanges");
            var gridChangeLen = gridChanges.length;
            if (gridChangeLen == 0) {
                PHA.Popover({
                    msg: "û����Ҫ���������",
                    type: "alert"
                });
                return;
            }
            var inputStrArr = [];
            for (var i = 0; i < gridChangeLen; i++) {
                var iData = gridChanges[i];
                if ($_grid.datagrid("getRowIndex", iData) < 0) {
                    continue;
                }
                var params = (iData.aliasId || "") + "^" + (iData.aliasText || "");
                inputStrArr.push(params);
            }
            var inputStr = inputStrArr.join("!!");
            var saveOpt = $.extend(
                {},
                {
                    dataType: "text",
                    MultiDataStr: inputStr
                },
                _opts.saveParams
            );
            var saveRet = $.cm(saveOpt, false);
            var saveArr = saveRet.split("^");
            var saveVal = saveArr[0];
            var saveInfo = saveArr[1];
            if (saveVal < 0) {
                PHA.Alert("��ʾ", saveInfo, saveVal);
            } else {
                PHA.Popover({
                    msg: "����ɹ�",
                    type: "success",
                    timeout: 1000
                });
                // ��������,�ɹ�ֱ��ˢ��
                $_grid.datagrid("reload");
            }
        });
        $("#" + btnDelId).on("click", function() {
            var $_grid = $("#" + _gridId);
            var gridSelect = $_grid.datagrid("getSelected") || "";
            if (gridSelect == "") {
                PHA.Popover({
                    msg: "����ѡ����Ҫɾ��������",
                    type: "alert"
                });
                return;
            }
            var aliasId = gridSelect.aliasId || "";
            var rowIndex = $_grid.datagrid("getRowIndex", gridSelect);
            if (aliasId != "") {
                var saveOpt = $.extend(
                    {},
                    {
                        dataType: "text",
                        AliasId: aliasId
                    },
                    _opts.deleteParams
                );
                var saveRet = $.cm(saveOpt, false);
                var saveArr = saveRet.split("^");
                var saveVal = saveArr[0];
                var saveInfo = saveArr[1];
                if (saveVal < 0) {
                    PHA.Alert("��ʾ", saveInfo, saveVal);
                    return;
                } else {
                    PHA.Popover({
                        msg: "ɾ���ɹ�",
                        type: "success",
                        timeout: 1000
                    });
                }
            }
            $_grid.datagrid("deleteRow", rowIndex);
        });
    },
    /**
     * ���������ͷ�װ
     * @param {*} _opts
     * 					cardTypeId	������domid
     * 					cardNoId	����domid
     * 					patNoId		�ǼǺ�domid
     * 					readCardId	������ťdomid
     * @param {*} _callBackOpts
     * 					�����ص�ͬʱ�����߲���
     * 					ReadHandler �����¼�,��д�߹���
     * 					AfterHandler����дֵ���¼�
     */
    DHCCardTypeDef: function(_opts, _callBackOpts) {
        _callBackOpts = _callBackOpts || {};
        if (typeof _opts == "object") {
            // ��ʼ��
            var cardNoId = _opts.cardNoId || "";
            var readCardId = _opts.readCardId || "";
            var cardTypeId = _opts.cardTypeId || "";
            var patNoId = _opts.patNoId || "";
            PHA.ComboBox(cardTypeId, {
                editable: false,
                width: 100,
                url: PHA_STORE.DHCCardTypeDef().url,
                panelHeight: "auto",
                onLoadSuccess: function(data) {
                    for (var i = 0; i < data.length; index++) {
                        var iData = data[i];
                        var iVal = iData.RowId;
                        var iDesc = iData.Description;
                        var iDef = iData.Default;
                        if (iDef == "true") {
                            $(this).combobox("select", iVal);
                            break;
                        }
                    }
                },
                onSelect: function(data) {
                    var cardTypeAry = data.RowId.split("^");
                    var readCardMode = cardTypeAry[16];
                    if (readCardMode == "Handle") {
                        if (readCardId) {
                            $("#" + readCardId).linkbutton("disable");
                        }
                        if (cardNoId) {
                            $("#" + cardNoId).attr("readOnly", false);
                        }
                    } else {
                        if (readCardId) {
                            $("#" + readCardId).linkbutton("enable");
                        }
                        if (cardNoId) {
                            $("#" + cardNoId).attr("readOnly", true);
                            $("#" + cardNoId).val("");
                        }
                    }
                }
            });
            if (readCardId) {
                $("#" + readCardId).on("click", function(e) {
                    if ($(this).linkbutton("options").disabled != true) {
                        if (_callBackOpts.ReadHandler) {
                            _callBackOpts.ReadHandler();
                        } else {
                            ReadCard();
                        }
                    }
                });
            }
            if (cardNoId) {
                $("#" + cardNoId).keydown(function(e) {
                    if (e.keyCode == 13) {
                        ReadCard("handle");
                    }
                });
            }
        } else {
        }
        // ����
        function ReadCard(readType) {
            try {
                var cardType = $("#" + cardTypeId).combobox("getValue");
                var cardTypeDR = cardType.split("^")[0];
                var myRtn = "";
                if (readType == "") {
                    if (cardTypeDR == "") {
                        myRtn = DHCACC_GetAccInfo();
                    } else {
                        myRtn = DHCACC_GetAccInfo(cardTypeDR, cardType);
                    }
                } else {
                    var cardNo = "";
                    if (cardNoId) {
                        cardNo = $("#" + cardNoId).val();
                    }
                    cardNo = FullCardNo(cardNo, cardType);
                    myRtn = DHCACC_GetAccInfo(cardTypeDR, cardNo, "", "PatInfo");
                }
                var myAry = myRtn.toString().split("^");
                var rtn = myAry[0];
                switch (rtn) {
                    case "0":
                        if (cardNoId) {
                            $("#" + cardNoId).val(myAry[1]);
                        }
                        if (patNoId) {
                            $("#" + patNoId).val(myAry[5]);
                        }
                        if (_callBackOpts.AfterHandler) {
                            _callBackOpts.AfterHandler();
                        }
                        break;
                    case "-200":
                        $.messager.alert("��ʾ", "����Ч", "info", function() {
                            if (readCardId) {
                                $("#" + readCardId).focus();
                            }
                        });
                        break;
                    case "-201":
                        if (cardNoId) {
                            $("#" + cardNoId).val(myAry[1]);
                        }
                        if (patNoId) {
                            $("#" + patNoId).val(myAry[5]);
                        }
                        if (_callBackOpts.AfterHandler) {
                            _callBackOpts.AfterHandler();
                        }
                        break;
                    default:
                        break;
                }
            } catch (e) {}
        }
        // ���Ų���
        function FullCardNo(cardNo, cardType) {
            var cardNoLen = cardType.split("^")[17];
            if (cardNoLen != 0 && cardNo.length < cardNoLen) {
                var defLen = cardNoLen - cardNo.length - 1;
                for (var i = defLen; i >= 0; i--) {
                    cardNo = "0" + cardNo;
                }
            }
            return cardNo;
        }
    }
};
