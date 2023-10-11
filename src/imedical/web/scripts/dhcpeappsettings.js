/*
 * FileName:    dhcpeappsettings.js
 * Author:      wangzhenghao
 * Date:        20210914
 * Description: ���Ӧ�ý����������
 */
function init() {
    //Ӧ�ó���
    $("#AppGrid").datagrid({
        url: $URL,
        queryParams: {
            ClassName: "web.DHCPE.Settings.App",
            QueryName: "SearchApp"
        },
        fit: true,
        pageSize: 50,
        pagination: true,
        border: false,
        displayMsg: "", //���ط�ҳ���������"��ʾ��ҳ����ҳ,������������" 
        toolbar: [{
                text: '����',
                iconCls: 'icon-add',
                handler: function() {
                    openAppWin()
                }
            },
            {
                text: '�޸�',
                iconCls: 'icon-write-order',
                handler: function() {
                    var rows = $("#AppGrid").datagrid("getSelections")
                    if (rows.length !== 1) {
                        $.messager.popover({
                            msg: '��ѡ��һ�����ݽ��в���������',
                            type: 'error',
                            timeout: 1000
                        })
                        return false;
                    }
                    openAppWin(rows[0])
                }
            },
            {
                iconCls: 'icon-cancel',
                text: 'ɾ��',
                handler: function() {
                    var myGrid = $("#AppGrid")
                    var suc = 0
                    var err = 0
                    var rows = myGrid.datagrid("getSelections")
                    if (rows.length === 0) {
                        $.messager.popover({
                            msg: '����ѡ���ɾ���ļ�¼������',
                            type: 'error',
                            timeout: 1000
                        })
                        return false;
                    }

                    if (!confirm("ȷ��ɾ��Ӧ�ü������������á���һ����ʾ")) return false;
                    if (!confirm("ȷ��ɾ��Ӧ�ü������������á��ڶ�����ʾ")) return false;
                    if (!confirm("ȷ��ɾ��Ӧ�ü������������á����һ����ʾ")) return false;


                    for (var i = 0; i < rows.length; i++) {
                        var row = rows[i]
                        var rowIndex = myGrid.datagrid("getRowIndex", row)
                        var RowId = row['SARowId']
                        var flag = tkMakeServerCall("web.DHCPE.Settings.App", "DeleteApp", RowId || "")
                        if (flag === '0') {
                            suc++
                            myGrid.datagrid("deleteRow", rowIndex)
                        } else {
                            err++
                        }
                    }
                    if (err != 0) {
                        $.messager.popover({
                            msg: 'ɾ��ʧ��',
                            type: 'error',
                            timeout: 1000
                        })
                    } else {

                        $.messager.popover({
                            msg: 'ɾ���ɹ�',
                            type: 'success',
                            timeout: 1000
                        })
                    }
                }
            }
        ],
        columns: [
            [
                { field: 'SARowId', hidden: true },
                { field: 'SACode', title: '����', width: '150' },
                { field: 'SADesc', title: '����', width: '150', },
            ]
        ],
        rownumbers: true,
        singleSelect: true,
        onSelect: function(rowIndex, rowData) {
            $("#AppParamGrid").datagrid("load", {
                ClassName: "web.DHCPE.Settings.Param",
                QueryName: "SearchParam",
                appId: rowData['SARowId']
            })
            $("#AppParamValueGrid").datagrid("load", {
                ClassName: "web.DHCPE.Settings.Value",
                QueryName: "SearchValue",
                paramId: ""
            })
        }
    });
    //����
    $("#AppParamGrid").datagrid({
        url: $URL,
        queryParams: {
            ClassName: "web.DHCPE.Settings.Param",
            QueryName: "SearchParam",
        },
        fit: true,
        pageSize: 50,
        pagination: true,
        border: false,
        toolbar: [{
                text: '����',
                iconCls: 'icon-add',
                handler: function() {
                    openAPWin()
                }
            },
            {
                text: '�޸�',
                iconCls: 'icon-write-order',
                handler: function() {
                    var rows = $("#AppParamGrid").datagrid("getSelections")
                    if (rows.length !== 1) {
                        $.messager.popover({
                            msg: '��ѡ��һ�����ݽ��в���������',
                            type: 'error',
                            timeout: 1000
                        })
                        return false;
                    }
                    openAPWin(rows[0])
                }
            },
            {
                iconCls: 'icon-cancel',
                text: 'ɾ��',
                handler: function() {
                    var myGrid = $("#AppParamGrid")
                    var rows = myGrid.datagrid("getSelections")
                    if (rows.length === 0) {
                        $.messager.popover({
                            msg: '����ѡ���ɾ���ļ�¼������',
                            type: 'error',
                            timeout: 1000
                        })
                        return false;
                    }
                    for (var i = 0; i < rows.length; i++) {
                        var row = rows[i]
                        var suc = 0
                        var err = 0
                        var rowIndex = myGrid.datagrid("getRowIndex", row)
                        var RowId = row['SPRowId']
                        var flag = tkMakeServerCall("web.DHCPE.Settings.Param", "DeleteParam", RowId || "")
                        if (flag === '0') {
                            suc++
                            myGrid.datagrid("deleteRow", rowIndex)
                        } else {
                            err++
                        }
                    }
                    if (err != 0) {
                        $.messager.popover({
                            msg: 'ɾ��ʧ��',
                            type: 'error',
                            timeout: 1000
                        })
                    } else {

                        $.messager.popover({
                            msg: 'ɾ���ɹ�',
                            type: 'success',
                            timeout: 1000
                        })
                    }
                }
            }
        ],
        columns: [
            [
                { field: 'SPRowId', hidden: true },
                { field: 'SPCode', title: '����', width: 200 },
                { field: 'SPDesc', title: '����', width: 200 },
                { field: 'SPDefault', title: 'Ĭ��ֵ', width: 100 },
                { field: 'SPNote', title: '��ע', width: 550, },
            ]
        ],
        rownumbers: true,
        singleSelect: true,
        onSelect: function(rowIndex, rowData) {
            $("#AppParamValueGrid").datagrid("load", {
                ClassName: "web.DHCPE.Settings.Value",
                QueryName: "SearchValue",
                paramId: rowData['SPRowId']
            })
        }
    });
    //����ֵ
    $("#AppParamValueGrid").datagrid({
        url: $URL,
        queryParams: {
            ClassName: "web.DHCPE.Settings.Value",
            QueryName: "SearchValue",
        },
        fit: true,
        pageSize: 50,
        pagination: true,
        border: false,
        toolbar: [{
                iconCls: 'icon-add',
                text: '����',
                handler: function() {
                    openPVWin()
                }
            },
            {
                iconCls: 'icon-write-order',
                text: '�޸�',
                handler: function() {
                    var rows = $("#AppParamValueGrid").datagrid("getSelections")
                    if (rows.length !== 1) {
                        $.messager.popover({
                            msg: '��ѡ��һ�����ݽ��в���������',
                            type: 'error',
                            timeout: 1000
                        })
                        return false;
                    }
                    openPVWin(rows[0])
                }
            },
            {
                iconCls: 'icon-cancel',
                text: 'ɾ��',
                handler: function() {
                    var suc = 0
                    var err = 0
                    var myGrid = $("#AppParamValueGrid")
                    var rows = myGrid.datagrid("getSelections")
                    if (rows.length === 0) {
                        $.messager.popover({
                            msg: '����ѡ���ɾ���ļ�¼������',
                            type: 'error',
                            timeout: 1000
                        })
                        return false;
                    }

                    for (var i = 0; i < rows.length; i++) {
                        var row = rows[i]
                        var rowIndex = myGrid.datagrid("getRowIndex", row)
                        var RowId = row['SVRowId']
                        var flag = tkMakeServerCall("web.DHCPE.Settings.Value", "DeleteValue", RowId || "")
                        if (flag === '0') {
                            suc++
                            myGrid.datagrid("deleteRow", rowIndex)
                        } else {
                            err++
                        }
                    }
                    if (err != 0) {
                        $.messager.popover({
                            msg: 'ɾ��ʧ��',
                            type: 'error',
                            timeout: 1000
                        })
                    } else {

                        $.messager.popover({
                            msg: 'ɾ���ɹ�',
                            type: 'success',
                            timeout: 1000
                        })
                    }
                }
            }
        ],
        columns: [
            [
            {field: 'SVRowId', hidden: true},
            {title: '����', field: 'SVType', hidden: true},
            {title: '����ֵ', field: 'SVTypeValue', hidden: true},
            {title: '����', field: 'TypeDesc', width: 100},
            {title: '����ֵ', field: 'TypeValueDesc', width: 160},
            {title: '����ֵ', field: 'SVParamValue', width: 200},
            {title: '��ע', field: 'Remark', width: 380}
            ]
        ],
        rownumbers: true,
        singleSelect: true,
    });
}

/**
 * @description ��Ӧ�ô���
 * @param winData {Object}
 * @author WZH 20210914
 */
function openAppWin(winData) {
    var height = window.screen.availHeight * 0.3;
    var width = window.screen.availWidth * 0.2;
    var content = '' +
        '<div id="myFrom">' +
        '   <div>' +
        '       <label for="appCode">����</label>' +
        '       <input id="appCode" name="appCode"/>' +
        '   </div>' +
        '   <div>' +
        '       <label for="appDesc">����</label>' +
        '       <input id="appDesc" name="appDesc"/>' +
        '   </div>' +
        '</div>'


    if (winData == undefined) {
        var image = 'icon-w-add';
        var title = "����Ӧ��";
    } else {
        var image = 'icon-w-edit';
        var title = "�޸�Ӧ��";
    }
    $('#myWin').dialog({
        iconCls: image,
        title: title,
        modal: true,
        height: height,
        width: width,
        content: content,
        buttons: [{
            text: '����',
            handler: function(e) {
                var isValid = $("#myFrom").form('validate');
                if (!isValid) {
                    return false;
                }
                winData = winData || {} //����ʱ���δ����
                var myId = winData['SARowId'] || "" //��ǰѡ����id
                var appCode = $("#appCode").val()
                var appDesc = $("#appDesc").val()
                var myData = {
                    SACode: appCode,
                    SADesc: appDesc,
                }
                var flag
                var myGrid = $('#AppGrid')

                // �޸�
                if (myId != "") {
                    flag = tkMakeServerCall("web.DHCPE.Settings.App", "UpdateApp", myId, appCode, appDesc)
                    if (flag != "0") {
                        $.messager.popover({
                            msg: '�޸�ʧ��' + flag,
                            type: 'error',
                            timeout: 1000
                        })
                        return false;
                    }
                    var index = myGrid.datagrid("getRowIndex", winData)
                    $.messager.popover({
                        msg: '�޸ĳɹ�',
                        type: 'success',
                        timeout: 1000
                    })
                    myGrid.datagrid('updateRow', {
                        index: index,
                        row: myData
                    });
                } else {
                    // ����
                    flag = tkMakeServerCall("web.DHCPE.Settings.App", "AddApp", appCode, appDesc)
                    if (flag.split('^')[0] <= 0) {
                        $.messager.popover({
                            msg: '����ʧ��' + flag,
                            type: 'error',
                            timeout: 1000
                        })
                        return false;
                    }
                    $.messager.popover({
                        msg: '�����ɹ�',
                        type: 'success',
                        timeout: 1000
                    })
                    myData['SARowId'] = flag
                    myGrid.datagrid("appendRow", myData)
                }
                $('#myWin').window("close")
            }
        }]
    });
    var myFrom = $("#myFrom").css("text-align", "center")
    $("#myFrom>div").css("margin-top", "3mm")
    var myLabel = $("#myFrom label").css("width", "50px")
    myLabel.css("display", "inline-block")
    $("#myFrom>a").css("margin-top", "13mm")
    initAPPWinData(winData)
}

/**
 * @description ����Ӧ�ô������ݡ��¼�
 * @param data
 * @author WZH 20210914
 */
function initAPPWinData(data) {
    //����
    $('#appCode').validatebox({
        required: true,
    })
    //����
    $('#appDesc').validatebox({
        required: true,
    })
    if (data) {
        var myData = {
            appCode: data['SACode'],
            appDesc: data['SADesc'],
        }
        $("#myFrom").form('load', myData);
    }
}

/**
 * @description �򿪲�������
 * @param winData {Object}
 * @author WZH 20210914
 */
function openAPWin(winData) {
    // winData����ʱ���ж�Ϊ��������������������ѡ���ϸ����
    var parentId = ""
    if (!winData) {
        var parent = $("#AppGrid")
        var prows = parent.datagrid("getSelections")
        if (prows.length !== 1) {
            $.messager.popover({
                msg: '��ѡ��һ���ϼ�������',
                type: 'error'
            })
            return false
        }
        parentId = prows[0]['SARowId']
    }

    var height = window.screen.availHeight * 0.4;
    var width = window.screen.availWidth * 0.2;
    var content = '' +
        '<div id="myFrom">' +
        '   <div>' +
        '       <label for="paramCode">����</label>' +
        '       <input id="paramCode" name="paramCode"/>' +
        '   </div>' +
        '   <div>' +
        '       <label for="paramDesc">����</label>' +
        '       <input id="paramDesc" name="paramDesc"/>' +
        '   </div>' +
        '   <div>' +
        '       <label for="paramDefault">Ĭ��ֵ</label>' +
        '       <input id="paramDefault" name="paramDefault"/>' +
        '   </div>' +
        '   <div>' +
        '       <label for="paramNote">��ע</label>' +
        '       <textarea id="paramNote" name="paramNote"/>' +
        '   </div>' +
        '</div>'

    if (winData == undefined) {
        var image = 'icon-w-add';
        var title = "��������";
    } else {
        var image = 'icon-w-edit';
        var title = "�޸Ĳ���";
    }
    $('#myWin').dialog({
        iconCls: image,
        title: title,
        modal: true,
        height: height,
        width: width,
        content: content,
        buttons: [{
            text: '����',
            handler: function(e) {
                var isValid = $("#myFrom").form('validate');
                if (!isValid) {
                    return false;
                }
                winData = winData || {} //����ʱ���δ����
                var myId = winData['SPRowId'] || "" //��ǰѡ����id
                var paramCode = $("#paramCode").val()
                var paramDesc = $("#paramDesc").val()
                var paramDefault = $("#paramDefault").val()
                var paramNote = $("#paramNote").val()
                var flag
                var myData = {
                    SPCode: paramCode,
                    SPDesc: paramDesc,
                    SPDefault: paramDefault,
                    SPNote: paramNote,
                }
                var myGrid = $('#AppParamGrid')

                if (myId != "") {
                    // �޸�
                    flag = tkMakeServerCall("web.DHCPE.Settings.Param", "UpdateParam", myId, paramCode, paramDesc, paramDefault, paramNote)
                    if (flag != '0') {
                        $.messager.popover({
                            msg: '�޸�ʧ��',
                            type: 'error',
                            timeout: 1000
                        })
                        return false;
                    }
                    var index = myGrid.datagrid("getRowIndex", winData)
                    $.messager.popover({
                        msg: '�޸ĳɹ�',
                        type: 'success',
                        timeout: 1000
                    })
                    myGrid.datagrid('updateRow', {
                        index: index,
                        row: myData
                    });
                } else {
                    // ����
                    flag = tkMakeServerCall("web.DHCPE.Settings.Param", "AddParam", parentId, paramCode, paramDesc, paramDefault, paramNote)
                    if (flag.split('^')[0] <= 0) {
                        $.messager.popover({
                            msg: '����ʧ��',
                            type: 'error',
                            timeout: 1000
                        })
                        return false;
                    }
                    $.messager.popover({
                        msg: '�����ɹ�',
                        type: 'success',
                        timeout: 1000
                    })
                    myData['SPRowId'] = flag
                    myGrid.datagrid("appendRow", myData)
                }
                $('#myWin').window("close")
            }
        }]
    });
    var myFrom = $("#myFrom").css("text-align", "center")
    $("#myFrom>div").css("margin-top", "3mm")
    var myLabel = $("#myFrom label").css("width", "50px")
    myLabel.css("display", "inline-block")
    $("#myFrom>a").css("margin-top", "13mm")
    initAPWinData(winData)
}

/**
 * @description ���ز����������ݡ��¼�
 * @param data {Object}
 * @author WZH 20210914
 */
function initAPWinData(data) {
    //����
    $('#paramCode').validatebox({
        required: true,
    })
    //����
    $('#paramDesc').validatebox({
        required: true,
    })
    //Ĭ��ֵ
    $('#paramDefault').validatebox({
        required: false,
    })
    //��ע
    /*$('#paramNote').validatebox({
        required: true,
    })*/
    if (data) {
        var myData = {
            paramCode: data['SPCode'],
            paramDesc: data['SPDesc'],
            paramDefault: data['SPDefault'],
            paramNote: data['SPNote'],
        }
        $("#myFrom").form('load', myData);
    }
}

/**
 * @description �򿪲���ֵ����
 * @param winData {object} ��ǰѡ���е�����
 * @author WZH 20210913
 */
function openPVWin(winData) {

    // winData����ʱ���ж�Ϊ��������������������ѡ���ϸ����
    var parentId = ""
    if (!winData) {
        var parent = $("#AppParamGrid")
        var prows = parent.datagrid("getSelections")
        if (prows.length !== 1) {
            $.messager.popover({
                msg: '��ѡ��һ���ϼ�������',
                type: 'error'
            })
            return false
        }
        parentId = prows[0]['SPRowId']
    }

    var height = 300;
    var width = 500;
    var content = '' +
        '<div id="myFrom">' +
        '   <div>' +
        '       <label for="type">����</label>' +
        '       <input id="type" style="width:400px;" name="type"/>' +
        '   </div>' +
        '   <div id="TVD">' +
        '       <label for="typeValue">����ֵ</label>' +
        '       <input id="typeValue" style="width:400px;" name="typeValue"/>' +
        '   </div>' +
        '   <div>' +
        '       <label for="paramValue">����ֵ</label>' +
        '       <input id="paramValue" style="width:400px;" name="paramValue"/>' +
        '   </div>' +
        '   <div>' +
        '       <label for="paramRemark">��ע</label>' +
        '       <textarea id="paramRemark" style="width:400px;" name="paramRemark"/>' +
        '   </div>' +
        '</div>'


    if (winData == undefined) {
        var image = 'icon-w-add';
        var title = "��������ֵ";
    } else {
        var image = 'icon-w-edit';
        var title = "�޸Ĳ���ֵ";
    }
    $('#myWin').dialog({
        iconCls: image,
        title: title,
        modal: true,
        height: height,
        width: width,
        content: content,
        buttons: [{
            text: '����',
            handler: function(e) {
                var isValid = $("#myFrom").form('validate');
                if (!isValid) {
                    return false;
                }
                winData = winData || {} //����ʱ���δ����
                var myId = winData['SVRowId'] || "" //��ǰѡ����id

                var type = $('#type').combobox("getValue");
                if(type == "C" ){
	                    var typeValue =$('#typeValue').val();
                    }else{
	                     var typeValue=$('#typeValue').combobox("getValue");
                    }
                    var paramValue = $('#paramValue').val();

                var TypeDesc = $('#type').combobox("getText");
                var TypeValueDesc = type == "C" ?  $('#typeValue').val() : $('#typeValue').combobox("getText");
                if(typeValue == "" && TypeValueDesc !="" && type == "C") typeValue = TypeValueDesc;

                var myGrid = $('#AppParamValueGrid')

                var myData = {
                    SVType: type,
                    SVTypeValue: typeValue,
                    SVParamValue: paramValue,
                    TypeDesc: TypeDesc,
                    TypeValueDesc: TypeValueDesc,
                    Remark: $("#paramRemark").val()
                }
                var flag
                if (myId != "") {
                    // �޸�
                        flag = tkMakeServerCall("web.DHCPE.Settings.Value", "UpdateValue", myId, type, typeValue, paramValue,$("#paramRemark").val())
                    if (flag != '0') {
                        $.messager.popover({
                            msg: '�޸�ʧ��',
                            type: 'error',
                            timeout: 1000
                        })
                        return false;
                    }
                    var index = myGrid.datagrid("getRowIndex", winData)
                    $.messager.popover({
                        msg: '�޸ĳɹ�',
                        type: 'success',
                        timeout: 1000
                    })
                    myGrid.datagrid('updateRow', {
                        index: index,
                        row: myData
                    });
                } else {
                    // ����
                        flag = tkMakeServerCall("web.DHCPE.Settings.Value", "AddValue", parentId, type, typeValue, paramValue,$("#paramRemark").val())
                    if (flag.split('^')[0] <= 0) {
                        $.messager.popover({
                            msg: '����ʧ��' + flag,
                            type: 'error',
                            timeout: 1000
                        })
                        return false;
                    }
                    $.messager.popover({
                        msg: '����ɹ�',
                        type: 'success',
                        timeout: 1000
                    })
                    myData['SVRowId'] = flag
                    myGrid.datagrid("appendRow", myData)
                }
                $('#myWin').window("close")
            }
        }]
    });
    var myFrom = $("#myFrom").css("text-align", "center")
    $("#myFrom>div").css("margin-top", "3mm")
    var myLabel = $("#myFrom label").css("width", "50px")
    myLabel.css("display", "inline-block")
    $("#myFrom>a").css("margin-top", "13mm")
    initPVWinData(winData)
}

/**
 * @description ���ز���ֵ�������ݡ��¼�
 * @param data {Object} �������� ������Ԫ��idһ��
 * @author WZH 20210913
 */
function initPVWinData(data) {
    $('#type').combobox({
        required: true,
        data: [{
            id: 'H',
            text: 'ȫԺ'
        }, {
            id: 'L',
            text: '����'
        }, {
            id: 'G',
            text: '��ȫ��'
        }, {
            id: 'U',
            text: '��Ա'
        }, {
            id: 'V',
            text: 'VIP�ȼ�'
        }, {
            id: 'C',
            text: '�Զ���'
        }],
        valueField: 'id',
        textField: 'text',
        onSelect: function(value) {
            initTypeValue(value.id)
        }
    });
    $('#typeValue').validatebox({
        required: true,
    });
    $('#paramValue').validatebox({
        // required: true,
    })
    if (data) {
        initTypeValue(data['SVType'])
        var myData = {
            type: data['SVType'],
            typeValue: data['SVTypeValue'],
            paramValue: data['SVParamValue'],
            paramRemark: data['Remark']
        }
        $("#myFrom").form('load', myData);
    }
}

/*
 * @description ��������ֵ���ݣ��������ͱ䶯
 * @param type
 * @author WZH 20210913
 */
function initTypeValue(type) {

    var HospID = session['LOGON.HOSPID'];
    var LocID = session['LOGON.CTLOCID'];
    $("#TVD").html("<label for='typeValue'>����ֵ</label> <input id='typeValue' style='width:400px;' name='typeValue'/>");
    var typeValue = $('#typeValue');

    switch (type.toUpperCase()) {
        case 'H': //Ժ��
            typeValue.combobox({
                url: $URL + '?ClassName=web.DHCPE.HISUICommon&QueryName=FindHosp&ResultSetType=Array',
                valueField: 'id',
                textField: 'desc',
            });
            break
        case 'G': //��ȫ��
            typeValue.combobox({
                url: $URL + "?ClassName=web.DHCPE.HISUICommon&QueryName=FindFeeTypeSuperGroup&ResultSetType=array&hospId=" + HospID + "&LocID=" + LocID,
                valueField: 'id',
                textField: 'desc',
            });
            break
        case 'L': //����
            typeValue.combobox({
                url: $URL + "?ClassName=web.DHCPE.Public.SettingEdit&QueryName=Querytest&ResultSetType=array",
                valueField: 'CTLOCID',
                textField: 'Desc',
            });
            break
        case 'U': //�û�
            typeValue.combobox({
                url: $URL + "?ClassName=web.DHCPE.HISUICommon&QueryName=FindUser&ResultSetType=array&hospId=" + HospID,
                valueField: 'id',
                textField: 'name'
            });
            break
        case 'V': //VIP�ȼ�
            typeValue.combobox({
                url: $URL + "?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID=" + session['LOGON.CTLOCID'],
                valueField: 'id',
                textField: 'desc'
            });
            break
        case 'C': //�Զ���
            typeValue.validatebox({
                required: true
            });
            break
        default:
            typeValue.combobox({
                required: true,
            });
    }
}

$(init)