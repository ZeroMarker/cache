/*
 * FileName:    dhcpeappsettings.js
 * Author:      wangzhenghao
 * Date:        20210914
 * Description: 体检应用界面参数配置
 */
function init() {
    //应用程序
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
        displayMsg: "", //隐藏分页下面的文字"显示几页到几页,共多少条数据" 
        toolbar: [{
                text: '新增',
                iconCls: 'icon-add',
                handler: function() {
                    openAppWin()
                }
            },
            {
                text: '修改',
                iconCls: 'icon-write-order',
                handler: function() {
                    var rows = $("#AppGrid").datagrid("getSelections")
                    if (rows.length !== 1) {
                        $.messager.popover({
                            msg: '请选择一条数据进行操作！！！',
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
                text: '删除',
                handler: function() {
                    var myGrid = $("#AppGrid")
                    var suc = 0
                    var err = 0
                    var rows = myGrid.datagrid("getSelections")
                    if (rows.length === 0) {
                        $.messager.popover({
                            msg: '请先选择待删除的记录！！！',
                            type: 'error',
                            timeout: 1000
                        })
                        return false;
                    }

                    if (!confirm("确定删除应用及下面所有配置。第一次提示")) return false;
                    if (!confirm("确定删除应用及下面所有配置。第二次提示")) return false;
                    if (!confirm("确定删除应用及下面所有配置。最后一次提示")) return false;


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
                            msg: '删除失败',
                            type: 'error',
                            timeout: 1000
                        })
                    } else {

                        $.messager.popover({
                            msg: '删除成功',
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
                { field: 'SACode', title: '代码', width: '150' },
                { field: 'SADesc', title: '名称', width: '150', },
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
    //参数
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
                text: '新增',
                iconCls: 'icon-add',
                handler: function() {
                    openAPWin()
                }
            },
            {
                text: '修改',
                iconCls: 'icon-write-order',
                handler: function() {
                    var rows = $("#AppParamGrid").datagrid("getSelections")
                    if (rows.length !== 1) {
                        $.messager.popover({
                            msg: '请选择一条数据进行操作！！！',
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
                text: '删除',
                handler: function() {
                    var myGrid = $("#AppParamGrid")
                    var rows = myGrid.datagrid("getSelections")
                    if (rows.length === 0) {
                        $.messager.popover({
                            msg: '请先选择待删除的记录！！！',
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
                            msg: '删除失败',
                            type: 'error',
                            timeout: 1000
                        })
                    } else {

                        $.messager.popover({
                            msg: '删除成功',
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
                { field: 'SPCode', title: '代码', width: 200 },
                { field: 'SPDesc', title: '名称', width: 200 },
                { field: 'SPDefault', title: '默认值', width: 100 },
                { field: 'SPNote', title: '备注', width: 550, },
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
    //参数值
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
                text: '新增',
                handler: function() {
                    openPVWin()
                }
            },
            {
                iconCls: 'icon-write-order',
                text: '修改',
                handler: function() {
                    var rows = $("#AppParamValueGrid").datagrid("getSelections")
                    if (rows.length !== 1) {
                        $.messager.popover({
                            msg: '请选择一条数据进行操作！！！',
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
                text: '删除',
                handler: function() {
                    var suc = 0
                    var err = 0
                    var myGrid = $("#AppParamValueGrid")
                    var rows = myGrid.datagrid("getSelections")
                    if (rows.length === 0) {
                        $.messager.popover({
                            msg: '请先选择待删除的记录！！！',
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
                            msg: '删除失败',
                            type: 'error',
                            timeout: 1000
                        })
                    } else {

                        $.messager.popover({
                            msg: '删除成功',
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
            {title: '类型', field: 'SVType', hidden: true},
            {title: '类型值', field: 'SVTypeValue', hidden: true},
            {title: '类型', field: 'TypeDesc', width: 100},
            {title: '类型值', field: 'TypeValueDesc', width: 160},
            {title: '参数值', field: 'SVParamValue', width: 200},
            {title: '备注', field: 'Remark', width: 380}
            ]
        ],
        rownumbers: true,
        singleSelect: true,
    });
}

/**
 * @description 打开应用窗口
 * @param winData {Object}
 * @author WZH 20210914
 */
function openAppWin(winData) {
    var height = window.screen.availHeight * 0.3;
    var width = window.screen.availWidth * 0.2;
    var content = '' +
        '<div id="myFrom">' +
        '   <div>' +
        '       <label for="appCode">代码</label>' +
        '       <input id="appCode" name="appCode"/>' +
        '   </div>' +
        '   <div>' +
        '       <label for="appDesc">名称</label>' +
        '       <input id="appDesc" name="appDesc"/>' +
        '   </div>' +
        '</div>'


    if (winData == undefined) {
        var image = 'icon-w-add';
        var title = "新增应用";
    } else {
        var image = 'icon-w-edit';
        var title = "修改应用";
    }
    $('#myWin').dialog({
        iconCls: image,
        title: title,
        modal: true,
        height: height,
        width: width,
        content: content,
        buttons: [{
            text: '保存',
            handler: function(e) {
                var isValid = $("#myFrom").form('validate');
                if (!isValid) {
                    return false;
                }
                winData = winData || {} //新增时这个未定义
                var myId = winData['SARowId'] || "" //当前选中行id
                var appCode = $("#appCode").val()
                var appDesc = $("#appDesc").val()
                var myData = {
                    SACode: appCode,
                    SADesc: appDesc,
                }
                var flag
                var myGrid = $('#AppGrid')

                // 修改
                if (myId != "") {
                    flag = tkMakeServerCall("web.DHCPE.Settings.App", "UpdateApp", myId, appCode, appDesc)
                    if (flag != "0") {
                        $.messager.popover({
                            msg: '修改失败' + flag,
                            type: 'error',
                            timeout: 1000
                        })
                        return false;
                    }
                    var index = myGrid.datagrid("getRowIndex", winData)
                    $.messager.popover({
                        msg: '修改成功',
                        type: 'success',
                        timeout: 1000
                    })
                    myGrid.datagrid('updateRow', {
                        index: index,
                        row: myData
                    });
                } else {
                    // 新增
                    flag = tkMakeServerCall("web.DHCPE.Settings.App", "AddApp", appCode, appDesc)
                    if (flag.split('^')[0] <= 0) {
                        $.messager.popover({
                            msg: '新增失败' + flag,
                            type: 'error',
                            timeout: 1000
                        })
                        return false;
                    }
                    $.messager.popover({
                        msg: '新增成功',
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
 * @description 加载应用窗口数据、事件
 * @param data
 * @author WZH 20210914
 */
function initAPPWinData(data) {
    //代码
    $('#appCode').validatebox({
        required: true,
    })
    //名称
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
 * @description 打开参数窗口
 * @param winData {Object}
 * @author WZH 20210914
 */
function openAPWin(winData) {
    // winData不传时，判断为新增操作，新增操作需选择上个表格
    var parentId = ""
    if (!winData) {
        var parent = $("#AppGrid")
        var prows = parent.datagrid("getSelections")
        if (prows.length !== 1) {
            $.messager.popover({
                msg: '请选择一个上级！！！',
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
        '       <label for="paramCode">代码</label>' +
        '       <input id="paramCode" name="paramCode"/>' +
        '   </div>' +
        '   <div>' +
        '       <label for="paramDesc">名称</label>' +
        '       <input id="paramDesc" name="paramDesc"/>' +
        '   </div>' +
        '   <div>' +
        '       <label for="paramDefault">默认值</label>' +
        '       <input id="paramDefault" name="paramDefault"/>' +
        '   </div>' +
        '   <div>' +
        '       <label for="paramNote">备注</label>' +
        '       <textarea id="paramNote" name="paramNote"/>' +
        '   </div>' +
        '</div>'

    if (winData == undefined) {
        var image = 'icon-w-add';
        var title = "新增参数";
    } else {
        var image = 'icon-w-edit';
        var title = "修改参数";
    }
    $('#myWin').dialog({
        iconCls: image,
        title: title,
        modal: true,
        height: height,
        width: width,
        content: content,
        buttons: [{
            text: '保存',
            handler: function(e) {
                var isValid = $("#myFrom").form('validate');
                if (!isValid) {
                    return false;
                }
                winData = winData || {} //新增时这个未定义
                var myId = winData['SPRowId'] || "" //当前选中行id
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
                    // 修改
                    flag = tkMakeServerCall("web.DHCPE.Settings.Param", "UpdateParam", myId, paramCode, paramDesc, paramDefault, paramNote)
                    if (flag != '0') {
                        $.messager.popover({
                            msg: '修改失败',
                            type: 'error',
                            timeout: 1000
                        })
                        return false;
                    }
                    var index = myGrid.datagrid("getRowIndex", winData)
                    $.messager.popover({
                        msg: '修改成功',
                        type: 'success',
                        timeout: 1000
                    })
                    myGrid.datagrid('updateRow', {
                        index: index,
                        row: myData
                    });
                } else {
                    // 新增
                    flag = tkMakeServerCall("web.DHCPE.Settings.Param", "AddParam", parentId, paramCode, paramDesc, paramDefault, paramNote)
                    if (flag.split('^')[0] <= 0) {
                        $.messager.popover({
                            msg: '新增失败',
                            type: 'error',
                            timeout: 1000
                        })
                        return false;
                    }
                    $.messager.popover({
                        msg: '新增成功',
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
 * @description 加载参数窗口数据、事件
 * @param data {Object}
 * @author WZH 20210914
 */
function initAPWinData(data) {
    //代码
    $('#paramCode').validatebox({
        required: true,
    })
    //名称
    $('#paramDesc').validatebox({
        required: true,
    })
    //默认值
    $('#paramDefault').validatebox({
        required: false,
    })
    //备注
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
 * @description 打开参数值窗口
 * @param winData {object} 当前选中行的数据
 * @author WZH 20210913
 */
function openPVWin(winData) {

    // winData不传时，判断为新增操作，新增操作需选择上个表格
    var parentId = ""
    if (!winData) {
        var parent = $("#AppParamGrid")
        var prows = parent.datagrid("getSelections")
        if (prows.length !== 1) {
            $.messager.popover({
                msg: '请选择一个上级！！！',
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
        '       <label for="type">类型</label>' +
        '       <input id="type" style="width:400px;" name="type"/>' +
        '   </div>' +
        '   <div id="TVD">' +
        '       <label for="typeValue">类型值</label>' +
        '       <input id="typeValue" style="width:400px;" name="typeValue"/>' +
        '   </div>' +
        '   <div>' +
        '       <label for="paramValue">参数值</label>' +
        '       <input id="paramValue" style="width:400px;" name="paramValue"/>' +
        '   </div>' +
        '   <div>' +
        '       <label for="paramRemark">备注</label>' +
        '       <textarea id="paramRemark" style="width:400px;" name="paramRemark"/>' +
        '   </div>' +
        '</div>'


    if (winData == undefined) {
        var image = 'icon-w-add';
        var title = "新增参数值";
    } else {
        var image = 'icon-w-edit';
        var title = "修改参数值";
    }
    $('#myWin').dialog({
        iconCls: image,
        title: title,
        modal: true,
        height: height,
        width: width,
        content: content,
        buttons: [{
            text: '保存',
            handler: function(e) {
                var isValid = $("#myFrom").form('validate');
                if (!isValid) {
                    return false;
                }
                winData = winData || {} //新增时这个未定义
                var myId = winData['SVRowId'] || "" //当前选中行id

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
                    // 修改
                        flag = tkMakeServerCall("web.DHCPE.Settings.Value", "UpdateValue", myId, type, typeValue, paramValue,$("#paramRemark").val())
                    if (flag != '0') {
                        $.messager.popover({
                            msg: '修改失败',
                            type: 'error',
                            timeout: 1000
                        })
                        return false;
                    }
                    var index = myGrid.datagrid("getRowIndex", winData)
                    $.messager.popover({
                        msg: '修改成功',
                        type: 'success',
                        timeout: 1000
                    })
                    myGrid.datagrid('updateRow', {
                        index: index,
                        row: myData
                    });
                } else {
                    // 新增
                        flag = tkMakeServerCall("web.DHCPE.Settings.Value", "AddValue", parentId, type, typeValue, paramValue,$("#paramRemark").val())
                    if (flag.split('^')[0] <= 0) {
                        $.messager.popover({
                            msg: '新增失败' + flag,
                            type: 'error',
                            timeout: 1000
                        })
                        return false;
                    }
                    $.messager.popover({
                        msg: '保存成功',
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
 * @description 加载参数值窗口数据、事件
 * @param data {Object} 窗口数据 属性与元素id一致
 * @author WZH 20210913
 */
function initPVWinData(data) {
    $('#type').combobox({
        required: true,
        data: [{
            id: 'H',
            text: '全院'
        }, {
            id: 'L',
            text: '科室'
        }, {
            id: 'G',
            text: '安全组'
        }, {
            id: 'U',
            text: '人员'
        }, {
            id: 'V',
            text: 'VIP等级'
        }, {
            id: 'C',
            text: '自定义'
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
 * @description 加载类型值内容，根据类型变动
 * @param type
 * @author WZH 20210913
 */
function initTypeValue(type) {

    var HospID = session['LOGON.HOSPID'];
    var LocID = session['LOGON.CTLOCID'];
    $("#TVD").html("<label for='typeValue'>类型值</label> <input id='typeValue' style='width:400px;' name='typeValue'/>");
    var typeValue = $('#typeValue');

    switch (type.toUpperCase()) {
        case 'H': //院区
            typeValue.combobox({
                url: $URL + '?ClassName=web.DHCPE.HISUICommon&QueryName=FindHosp&ResultSetType=Array',
                valueField: 'id',
                textField: 'desc',
            });
            break
        case 'G': //安全组
            typeValue.combobox({
                url: $URL + "?ClassName=web.DHCPE.HISUICommon&QueryName=FindFeeTypeSuperGroup&ResultSetType=array&hospId=" + HospID + "&LocID=" + LocID,
                valueField: 'id',
                textField: 'desc',
            });
            break
        case 'L': //科室
            typeValue.combobox({
                url: $URL + "?ClassName=web.DHCPE.Public.SettingEdit&QueryName=Querytest&ResultSetType=array",
                valueField: 'CTLOCID',
                textField: 'Desc',
            });
            break
        case 'U': //用户
            typeValue.combobox({
                url: $URL + "?ClassName=web.DHCPE.HISUICommon&QueryName=FindUser&ResultSetType=array&hospId=" + HospID,
                valueField: 'id',
                textField: 'name'
            });
            break
        case 'V': //VIP等级
            typeValue.combobox({
                url: $URL + "?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID=" + session['LOGON.CTLOCID'],
                valueField: 'id',
                textField: 'desc'
            });
            break
        case 'C': //自定义
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