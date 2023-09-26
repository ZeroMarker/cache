var listField = null
var haveList = false;
Ext.onReady(function() {
    ShowPage();
    SetValue();
});

function ShowPage() {
    var allItems = InitControl();
    var btnAll = InitButtons();
    var frmSetParam = new Ext.form.FormPanel({
        width: 580,
        height: 470,
        id: 'frmParamSet',
        layout: 'absolute',
        renderTo: Ext.getBody(),
        region: 'center',
        title:'打印测试数据',
        frame: true,
        items: allItems,
        buttons: btnAll
    });
}

function InitControl() {
    var controls = new Array();
    
    var lblFieldParam = new Ext.form.Label({
        id: 'lblFieldParam',
        width: 66,
        height: 20,
        x: '10',
        y: '5',
        text: '字段参数：'
    });
    controls.push(lblFieldParam);

    var pgField = new Ext.grid.PropertyGrid({
        id:'pgField',
        autoScroll: true,
        listeners: { 'validateedit': removeChar },
        width: 250,
        height:350,
        x: '10',
        y: '35'
    });
    controls.push(pgField);

    var lblListParam = new Ext.form.Label({
        id: 'lblListParam',
        width: 66,
        height: 20,
        x: '310',
        y: '5',
        text: '列表参数：'
    });
    controls.push(lblListParam);

    var lblPrintRows = new Ext.form.Label({
        id: 'lblPrintRows',
        width: 66,
        height: 20,
        x: '415',
        y: '8',
        text: '打印'
    });
    controls.push(lblPrintRows);

    var lblRows = new Ext.form.Label({
    id: 'lblRows',
        width: 66,
        height: 20,
        x: '500',
        y: '8',
        text: '行'
    });
    controls.push(lblRows);
    
    var txtPrintRows = new FW.Ctrl.TextBox({
        id: 'txtPrintRows',
        submitValue: false,
        vtype: 'amount',
        maxLength: 3,
        height: 20,
        width: 40,
        beforeBlur:editRows,
        x: '450',
        y: '5'
    });
    controls.push(txtPrintRows);

    var pgList = new Ext.grid.PropertyGrid({
        id: 'pgList',
        autoScroll: true,
        listeners: { 'validateedit': removeChar },
        width: 250,
        height: 350,
        x: '310',
        y: '35'
    });
    controls.push(pgList);
    
    return controls;
}


//定义按钮
function InitButtons() {
    var btnConfirm = new Ext.Button({ id: 'btnConfirm', text: '确定', width: 80, handler: Confirm });
    var btnCancel = new Ext.Button({ id: 'btnCancel', text: '取消', width: 80, handler: Cancel });
    return [btnConfirm, btnCancel];
}

//确定操作
function Confirm() {
    var resultObj = { filedObj: '', listObj: '',rows:0 };
    resultObj.filedObj = Ext.getCmp("pgField").getSource();
    resultObj.listObj = Ext.getCmp("pgList").getSource();
    resultObj.rows = Ext.getCmp("txtPrintRows").getValue();
    var resultObjStr = Ext.encode(resultObj);
    var filedObjStr = getFieldPrintStr(resultObj.filedObj);
    //var listObjStr = getListPrintStr(resultObj.listObj);
    var listObjStr = getListPrintStrNew(resultObj.listObj, parseInt(resultObj.rows, 10));
    window.returnValue = [filedObjStr, listObjStr, resultObjStr];
    window.close();
}

//取消操作
function Cancel() {
    window.returnValue = null;
    window.close();
}

//设定值
function SetValue() {
    var paramData = window.dialogArguments;
    //listField = paramData[1];
    haveList = paramData[1];
    if (paramData[2] != null) {
        eval("var params = " + paramData[2]);
        var filedObjOld = params.filedObj;
        var listObjOld = params.listObj;
        var rows = params.rows;
        eval("var filedParamObj = " + ToJson(paramData[0], filedObjOld));
        Ext.getCmp("pgField").setSource(filedParamObj);
        //eval("var listParamObj = " + ToJson(paramData[1], listObjOld));
        if (haveList) {
            eval("var listParamObj = " + getListSource(rows, listObjOld));
            Ext.getCmp("pgList").setSource(listParamObj);
        }
        Ext.getCmp("txtPrintRows").setValue(rows);
    }
    else {
        eval("var filedObj = " + ToJson(paramData[0],null));
        Ext.getCmp("pgField").setSource(filedObj);
        //eval("var listObj = " + ToJson(paramData[1],null));
        if (haveList) {
            eval("var listObj = " + getListSource(1, null));
            Ext.getCmp("pgList").setSource(listObj);
        }
        Ext.getCmp("txtPrintRows").setValue(1);
    }
}

//转化为json字符串
function ToJson(arrayData,oldObj) {
    var count = arrayData.length;
    var jsonStr = "";
    for (var index = 0; index < count; index++) {
        if (index > 0) {
            jsonStr = jsonStr + ",";
        }
        if (oldObj) {
            eval("var itemValue = oldObj." + arrayData[index]);
            if (itemValue) {
                jsonStr = jsonStr + "'" + arrayData[index] + "':'" + itemValue + "'";
            }
            else {
                jsonStr = jsonStr + "'" + arrayData[index] + "':''";
            }
        }
        else {
            jsonStr = jsonStr + "'" + arrayData[index] + "':''";
        }
    }
    if (jsonStr != "") {
        return "{" + jsonStr + "}";
    }
    else {
        return null;
    }
}

function getFieldPrintStr(obj) {
    var rs = "";
    for (var item in obj) {
        rs = rs + item + String.fromCharCode(2) + eval("obj." + item) + "^";
    }
    if (rs != "") {
        var len = rs.length;
        rs = rs.substr(0, len - 1);
    }
    return rs;
}

function getListPrintStrNew(obj, rowCount) {
    var rs = "";
    if (haveList) {
        for (var index = 0; index < rowCount; index++) {
            var itemName = "Row" + index;
            if (index > 0) {
                rs = rs + String.fromCharCode(2);
            }
            rs = rs + eval("obj." + itemName);
        }
    }
    return rs;
}

function getListPrintStr(obj) {
    var rs = "";
    if (listField) {
        var count = listField.length;
        for (var index = 0; index < count; index++) {
            if (index > 0 ) {
                rs = rs + "^";
            }
            rs = rs + eval("obj." + listField[index]);
        }
    }
    if (Ext.getCmp("txtPrintRows").getValue() != "" && rs != "") {
        var rows = parseInt(Ext.getCmp("txtPrintRows").getValue(), 10);
        var tem = rs;
        for (var index = 0; index < rows - 1; index++) {
            rs = rs + String.fromCharCode(2) + tem;
        }
    }
    return rs;
}

function removeChar(e) {
    if (e.grid.id != "pgList") {
        e.value = e.value.replace(/\^/g, '');
    }
    e.value = e.value.replace(/\/g, '');
    e.value = e.value.replace(/\'/g, '');
    e.value = e.value.replace(/\"/g, '');
}

function getListSource(rowCount, oldObj) {
    var jsonStr = "";
    for (var index = 0; index < rowCount; index++) {
        if (index > 0) {
            jsonStr = jsonStr + ",";
        }
        var itemName = "Row" + index;
        if (oldObj) {
            eval("var itemValue = oldObj." + itemName);
            if (itemValue) {
                jsonStr = jsonStr + "'" + itemName + "':'" + itemValue + "'";
            }
            else {
                jsonStr = jsonStr + "'" + itemName + "':''";
            }
        }
        else {
            jsonStr = jsonStr + "'" + itemName + "':''";
        }
    }
    if (jsonStr != "") {
        return "{" + jsonStr + "}";
    }
    else {
        return null;
    }
}

function editRows() {
    if (haveList) {
        var rows = Ext.getCmp("txtPrintRows").getValue();
        if (rows != "") {
            var listobj = Ext.getCmp("pgList").getSource();
            eval("var listParamObj = " + getListSource(parseInt(rows, 10), listobj));
            Ext.getCmp("pgList").setSource(listParamObj);
        }
    }
}