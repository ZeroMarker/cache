var accessURL = "DHCExtAccess.csp";
var action = "";
var selectBedId = "";
var SYSDateFormat="";
var DateFormat=tkMakeServerCall("websys.Conversions","DateFormat");
if (DateFormat=="3"){
	SYSDateFormat="Y-m-d"
}else if(DateFormat=="4"){
	SYSDateFormat="d/m/Y"
}else{
	SYSDateFormat="d/m/Y"
}
Ext.onReady(function() {
    ShowPage();
    Ext.getCmp("grdFeeInfor").loadData();
});

//显示确认消息
ShowConfirmMessage = function(messageInfor, callbackFunction) {
    Ext.MessageBox.show({
        title: "确认信息",
        msg: messageInfor,
        width: 250,
        fn: callbackFunction,
        buttons: Ext.MessageBox.OKCANCEL,
        icon: Ext.MessageBox.QUESTION
    });
}

//显示消息
ShowMessage = function(messageType, messageInfor, url) {
    var messageTitle;
    var msgIcon;
    if (messageType == "E") {
        messageTitle = "错误信息";
        msgIcon = Ext.MessageBox.ERROR;
    }
    else if (messageType == "I") {
        messageTitle = "提示信息";
        msgIcon = Ext.MessageBox.INFO;
    }
    else if (messageType == "W") {
        messageTitle = "警告信息";
        msgIcon = Ext.MessageBox.WARNING;
    }

    Ext.MessageBox.show({
        title: messageTitle,
        msg: messageInfor,
        width: 250,
        buttons: Ext.MessageBox.OK,
        icon: msgIcon
    });
}
    

//发送请求
 DoRequest= function(url, actionParams, HandleResult,nameSpace) {
    var conn = new Ext.data.Connection();
    conn.request({
        url: url,
        params: actionParams,
        method: 'post',
        scope: nameSpace,
        callback: HandleResult
    });
}

SubmitForm = function(frmName, actionParams, grdName, winName) {
    if (!Ext.getCmp(frmName).getForm().isValid()) {
        return;
    }
    Ext.getCmp(frmName).getForm().submit({
        waitTitle: '提示',
        waitMsg: '正在提交数据请稍后...',
        url: accessURL,
        params: actionParams,
        success: function(form, action) {
            if (winName) {
                Ext.getCmp(winName).close();
            }
            ShowMessage("I", "操作成功！");
            if (grdName) {
                Ext.getCmp(grdName).store.reload();
            }
        },
        failure: function(form, action) {
            ShowMessage("E", "操作失败！");
        }
    });
}

//显示页面
function ShowPage() {
    var allItems = CreateItems();
    var frmMenu = new Ext.form.FormPanel({
        id: "frmBedFeeSet",
        layout: "absolute",
        renderTo: Ext.getBody(),
        region: "center",
        width: '100%',
        height: 560,
        frame: true,
        cls: '',
        items: allItems
    });
    Ext.getCmp("btnDelete").disable();
    Ext.getCmp("btnAdd").disable();
    Ext.getCmp("btnEdit").disable();
}

//创建控件
function CreateItems() {
    var controls = new Array();
    var treeMenu = new Ext.tree.TreePanel({
        id: 'treeBed',
        title: '病区床位',
        height: 540,
        width: 220,
        useArrows: true,
        autoScroll: true,
        animate: true,
        enableDD: true,
        containerScroll: true,
        rootVisible: false,
        frame: true,
        x: '5',
        y: '5',
        root: {
            nodeType: 'async',
            id: 'rootNode',
            children: treeData},
        listeners: {
            'checkchange': SelectedNodeChange
        }
    });
    controls.push(treeMenu);
    
    var btnArray = InitButtons();
    var grdFeeInfor = new FW.Ctrl.ListGrid({
        id: "grdFeeInfor",
        showSelectColumn: true,
        //是否准许收缩 
        collapsible: false,
        //面板标题消息
        title: "床位费用列表",
        stripeRows: false,
        queryUrl: accessURL,
        multiSelect:true,
        queryParams: { 'AcessType': 'GridQuery', 'MethodSignature': 'web.DHCPACBedFeeSet:GetBedFeeList' },
        getParamFn: GetSearchParam,
        allColumns: [{ header: "ID", dataIndex: "BEDI_RowId", sortable: false, hideable: false, hidden: true },
                     { header: "费用类型ID", dataIndex: "BEDI_FeeType", sortable: false, hideable: false, hidden: true },
                      { header: "费用类型", dataIndex: "FT_Desc", sortable: true, width: 80},
                     { header: "费用医嘱ID", dataIndex: "BEDI_ARCIM_DR", sortable: false, hideable: false, hidden: true },
                     { header: "费用医嘱", dataIndex: "ARCIM_Desc", sortable: true, width: 230 },
                     { header: "开始时间", dataIndex: "startDate", sortable: true, width: 100,
                        renderer: function(startDate) {
	                       var value=tkMakeServerCall("websys.Conversions","DateLogicalToHtml",startDate);
                           return value;
                        }
                     },
                     { header: "结束时间", dataIndex: "endDate", sortable: true, width: 100,
                        renderer: function(endDate) {
                           var value=tkMakeServerCall("websys.Conversions","DateLogicalToHtml",endDate);
                           return value;
                        }
                     }],
        buttons: [btnArray],
        height: 415,
        width: 600,
        x: '240',
        y: '5'
    });
    controls.push(grdFeeInfor);
    return controls;
}

//定义按钮
function InitButtons() {
	if (CFEnableAir=='Y') {CFEnableAir=true;}else{CFEnableAir=false;}
	if (CFEnableHeat=='Y') {CFEnableHeat=true;}else{CFEnableHeat=false;}
	var EnableAirSelect = new  Ext.form.Checkbox({
        id: "EnableAirSelect",
		checked:CFEnableAir,
        boxLabel :'<span style="font-size:16px;">启用空调费收取</span>',
        handler: SelectInfor
    });
	var EnableHeatSelect = new  Ext.form.Checkbox({
        id: "EnableHeatSelect",
		checked:CFEnableHeat,
        boxLabel :'<span style="font-size:16px;">启用暖气费收取</span>',
        handler: SelectInfor
    });
	
    var btnDelete = new Ext.Button({
        id: "btnDelete",
        iconCls:"icon-delete-custom",
        text: "删除",
        handler: DeleteInfor
    });
    var btnAdd = new Ext.Button({
        id: "btnAdd",
        iconCls: 'icon-add-custom',
        text: "添加",
        handler: AddInfor
    });
    var btnEdit = new Ext.Button({
        id: "btnEdit",
        iconCls:'icon-filesave-custom',
        text: "修改",
        handler: EditInfor
    });


    return [EnableAirSelect,EnableHeatSelect,btnAdd, btnEdit, btnDelete]
}

//点击病床
function SelectedNodeChange(node, checked) {
   if (checked) {
       var checkedNodes = Ext.getCmp("treeBed").getChecked();
        for (var index = 0; index < checkedNodes.length; index++) {
            if (checkedNodes[index].id != node.id) {
                checkedNodes[index].ui.checkbox.checked = false;
                checkedNodes[index].attributes.checked = false;
            }
        }
        selectBedId = node.id;
        //Ext.getCmp("grdFeeInfor").show();
        Ext.getCmp("grdFeeInfor").loadData();
        Ext.getCmp("btnDelete").enable();
        Ext.getCmp("btnAdd").enable();
        Ext.getCmp("btnEdit").enable();
    }
    else {
        //Ext.getCmp("grdFeeInfor").hide();
        selectBedId = "";
        Ext.getCmp("grdFeeInfor").loadData();
        Ext.getCmp("btnDelete").disable();
        Ext.getCmp("btnAdd").disable();
        Ext.getCmp("btnEdit").disable();
    }
}

//取得查询参数
function GetSearchParam() {

    return { 'Arg1': selectBedId.split("||")[0], 'Arg2': selectBedId.split("||")[1] }
}

//总开关设置
function SelectInfor() {
    var EnableAirSelect = Ext.getCmp("EnableAirSelect");
    if (EnableAirSelect.checked) {
        var EnableAir="Y";
        Ext.Msg.alert("提示","选中后启用空调费收取！");
    }else{
		var EnableAir="N";
		Ext.Msg.alert("提示","取消选中后停止空调费收取！"); 
	}
	var EnableHeatSelect = Ext.getCmp("EnableHeatSelect");
	if (EnableHeatSelect.checked) {
        var EnableHeat="Y";
        Ext.Msg.alert("提示","选中后启用暖气费收取！");
    }else{
		var EnableHeat="N";
		Ext.Msg.alert("提示","取消选中后停止暖气费收取！"); 
	}
	
	var Coninfo="EnableAir"+String.fromCharCode(1)+EnableAir+String.fromCharCode(2)+"EnableHeat"+String.fromCharCode(1)+EnableHeat
	var actionParams = { 'AcessType': 'ClassMethod', 'MethodSignature': 'web.DHCPACBedFeeSet:SaveConfig', 'Arg1': Coninfo };
    SubmitForm("frmBedFeeSet", actionParams, "grdFeeInfor");
	
	
}

//添加信息
function AddInfor() {
    if (selectBedId != "") {
        action = "add";
        var DetailWindow = InitDetailWin();
        DetailWindow.show();
    }
    else
    {
      ShowMessage("I", "请选择床位！");
    }
}

//修改信息
function EditInfor() {
    var rows = Ext.getCmp("grdFeeInfor").getSelectionModel().getSelections();
    if (rows.length == 0 || rows.length > 1) {
        ShowMessage("I", "请你选择一行数据进行操作！");
        return;
    }
    action = "update";
    //打开窗体
    var DetailWindow = InitDetailWin();
    DetailWindow.show();
    //将选中项的信息绑定到TextField中
    Ext.getCmp("pnlFee").getForm().findField("cmbFeeItmMast").setInitValueAndText(rows[0].get("BEDI_ARCIM_DR"),rows[0].get("ARCIM_Desc"));
    Ext.getCmp("pnlFee").getForm().findField("cmbFeeType").setInitValueAndText(rows[0].get("BEDI_FeeType"), rows[0].get("FT_Desc"));
    var startDate=tkMakeServerCall("websys.Conversions","DateLogicalToHtml",rows[0].get("startDate"));
    var endDate=tkMakeServerCall("websys.Conversions","DateLogicalToHtml",rows[0].get("endDate"));
    Ext.getCmp("pnlFee").getForm().findField("dtbxStartDate").setValue(startDate);
    Ext.getCmp("pnlFee").getForm().findField("dtbxEndDate").setValue(endDate);
}

//删除信息
function DeleteInfor() {
    var rows = Ext.getCmp("grdFeeInfor").getSelectionModel().getSelections();
    if (rows.length == 0) {
        ShowMessage("I", "请至少选择一行数据！");
        return;
    }
    ShowConfirmMessage("确实要删除所选的记录吗?", DeleteData);
}

//删除数据
function DeleteData(btn) {
    if (btn == "ok") {
        var rows = Ext.getCmp("grdFeeInfor").getSelectionModel().getSelections();
        var deleteId = "";
        for (var index = 0; index < rows.length; index++) {
            if (index == 0) {
                deleteId = rows[index].get("BEDI_RowId");
            }
            else {
                deleteId = rows[index].get("BEDI_RowId");
            }
            var actionParams = { 'AcessType': 'ClassMethod', 'MethodSignature': 'web.DHCPACBedFeeSet:DeleteBedFeeItem', 'Arg1': deleteId };
            SubmitForm("frmBedFeeSet", actionParams, "grdFeeInfor");
        }
      // var actionParams = { 'AcessType': 'ClassMethod', 'MethodSignature': 'web.DHCPACBedFeeSet:DeleteBedFeeItem', 'Arg1': deleteId };
       //SubmitForm("frmBedFeeSet", actionParams, "grdFeeInfor");
    }
}

//定义详情窗口
function InitDetailWin() {
    var pnlDetail = InitDetailPanel();
    var btnSave = new Ext.Button({
        id: "btnSave",
        iconCls:'icon-filesave-custom',
        text: "保存",
        handler: SaveInfor
    });
    var btnCancel = new Ext.Button({
        id: "btnCancel",
        iconCls:'icon-undo-custom',
        text: "取消",
        handler: CancelSave
    });

    //修改和添加时的弹出窗体
    return new Ext.Window({
        id: "winDetail",
        //是否准许收缩 
        collapsible: true,
        //能否最大化
        maximizable: false,
        height: 220,
        width: 400,
        modal: true,
        closable: true,
        autoDestroy: true,
        layout: "form",
        plain: true,
        title: "费用信息",
        bodyStyle: "padding:5px;",
        buttonAlign: "center",
        items: pnlDetail,
        buttons: [btnSave, btnCancel]
    });
}

//定义详情面板
function InitDetailPanel() {
    var controls = [
        { xtype: "FWBandbox",
            name:"Arg1",
            displayFields: ['ARCIM_Desc','ALIAS_Text'],
            displayField: 'ARCIM_Desc',
            valueField: 'ARCIM_RowId',
            queryParams: { 'AcessType': 'GridQuery', 'MethodSignature': 'web.DHCPACBedFeeSet:GetARCItmMastList' },
            storeExpression: [{ name: 'ARCIM_Desc', mapping: 'ARCIM_Desc', caption: '描述', width: 200 }, { name: 'ARCIM_Price', mapping: 'ARCIM_Price', caption: '价格', width: 60 }, { name: 'ARCIM_Code', mapping: 'ARCIM_Code', caption: '代码', width: 100},{ name: 'ARCIM_RowId', mapping: 'ARCIM_RowId', caption: 'ID' }],
            queryUrl: accessURL,
            editable: true,
            submitValue: false,
            height: 20,
            width: 250,
            gridWidth:350,
            fieldLabel: "费用医嘱",
            labelSeparator: '', // 去掉laebl中的冒号  update2020-2-12 钟荣枫
            id: 'cmbFeeItmMast', allowBlank: false, blankText: '此项必填'
        },
        { xtype: "FWCombobox",
        displayFields: ['FT_Desc', 'FT_StartDate', 'FT_EndDate'],
        displayField: 'FT_Desc',
        valueField: 'FT_RowId',
        queryParams: { 'AcessType': 'ComonQuery', 'MethodSignature': 'web.DHCPACBedFeeSet:GetBedFeeTypeList' },
        storeExpression: [{ name: 'FT_RowId', mapping: 'FT_RowId' }, { name: 'FT_Desc', mapping: 'FT_Desc' }, { name: 'FT_StartDate', mapping: 'FT_StartDate' }, { name: 'FT_EndDate', mapping: 'FT_EndDate'}],
        queryUrl: accessURL,
        submitValue: false,
        editable: true,
        height: 20,
        width: 250,
        fieldLabel: "费用类型",
        labelSeparator: '', // 去掉laebl中的冒号
        id: 'cmbFeeType', allowBlank: false, blankText: '此项必填'
        },
        { xtype: "FWDatebox", width: 250,fieldLabel: "开始日期", name: 'Arg3', format: SYSDateFormat, id: "dtbxStartDate", allowBlank: true, blankText: '此项必填',labelSeparator: '' },
        { xtype: "FWDatebox", width: 250,fieldLabel: "结束日期", name: 'Arg4', format: SYSDateFormat, id: "dtbxEndDate", allowBlank: true, blankText: '此项必填',labelSeparator: ''}];
    return new Ext.FormPanel({
        id: "pnlFee",
        labelWidth: 75,
        labelAlign: "right",
        height: 140,
        frame: true,
        bodyStyle: "padding:5px 5px 0",
        defaultType: "textfield",
        items: controls
    });
}

//保存信息
function SaveInfor() {
    var startDate = Ext.getCmp("pnlFee").getForm().findField("dtbxStartDate").getValue();
    var endDate = Ext.getCmp("pnlFee").getForm().findField("dtbxEndDate").getValue();
    if(startDate != "" && endDate != "")
    {
        if(startDate >endDate)
        {
            ShowMessage("I", "开始日期不能大于结束日期！");
            return;
        }
    }
    if (!Ext.getCmp("pnlFee").getForm().isValid()) return;
    var actionParams;
    var feeItmMast = Ext.getCmp("pnlFee").getForm().findField("cmbFeeItmMast").getValue();
    var feeType = Ext.getCmp("pnlFee").getForm().findField("cmbFeeType").getValue();
    if (action == "add") {
        var wardId = selectBedId.split("||")[0];
        var bedId = selectBedId.split("||")[1];
        actionParams = { 'AcessType': 'ClassMethod', 'MethodSignature': 'web.DHCPACBedFeeSet:SaveBedFeeItem', 'Arg1': feeItmMast, 'Arg2': feeType, 'Arg5': wardId, 'Arg6': bedId };
    }
    else if (action == "update") {
        var rows = Ext.getCmp("grdFeeInfor").getSelectionModel().getSelections();
        var feeItemId = rows[0].get("BEDI_RowId")
        actionParams = { 'AcessType': 'ClassMethod', 'MethodSignature': 'web.DHCPACBedFeeSet:UpdateBedFeeItem', 'Arg1': feeItmMast, 'Arg2': feeType,'Arg5': feeItemId };
    }
    SubmitForm("pnlFee", actionParams, "grdFeeInfor", "winDetail");
}

//取消保存
function CancelSave()
{
    Ext.getCmp("winDetail").close();
}
