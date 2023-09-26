var accessURL = "DHCExtAccess.csp";
var action = "";
var SYSDateFormat=tkMakeServerCall("websys.Conversions","DateFormat");
if (SYSDateFormat=="3"){
	SYSDateFormat="Y-m-d"
}else if(SYSDateFormat=="4"){
	SYSDateFormat="d/m/Y"
}else{
	SYSDateFormat="d/m/Y"
}
Ext.onReady(function() {
    ShowPage();
    Ext.getCmp("grdBedTypeFee").loadData();
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
    var frmBedTypeFeeSet = new Ext.form.FormPanel({
        id: "frmBedTypeFeeSet",
        layout: "absolute",
        renderTo: Ext.getBody(),
        region: "center",
        width: '100%',
        height: 560,
        frame: true,
        cls: '',
        items: allItems
    });
}

//定义控件
function CreateItems() {
    var controls = new Array();
    
    var lblBedType = new Ext.form.Label({
        id: 'lblBedType',
        text: '床位类型',      // 去掉laebl中的冒号    update2020-2-18 钟荣枫
        height: 20,
        width: 70,
        x: '200',
        y: '25'
    });
    controls.push(lblBedType);

    var cmbBedType = new FW.Ctrl.ComboBox({
        id: "cmbBedType",
        name: 'Arg1',
        valueField: 'BEDTP_RowId',
        displayField: 'BEDTP_Desc',
        queryUrl: accessURL,
        queryParams: { 'AcessType': 'ComonQuery', 'MethodSignature': 'web.DHCPACBedFeeSet:GetBedTypeList' },
        storeExpression: [{ name: 'BEDTP_RowId', mapping: 'BEDTP_RowId' }, { name: 'BEDTP_Desc', mapping: 'BEDTP_Desc'}],
        editable: true,
        submitValue: false,
        allowBlank: true,
        height: 20,
        width: 190,
        x: '260',
        y: '20'
    });
    controls.push(cmbBedType);

    var btnSearch = new Ext.Button({
        id: "btnSearch",
        iconCls:'icon-find-custom',
        text: "搜索",
        height: 20,
        width: 80,
        x: '500',
        y: '20',
        height: 25,
        handler: SearchInfor
    });
    controls.push(btnSearch);
    
    var btnArray = InitButtons();
    var grdBedTypeFee = new FW.Ctrl.ListGrid({
        id: "grdBedTypeFee",
        showSelectColumn: true,
        //是否准许收缩 
        collapsible: false,
        //面板标题消息
        title: "床位类型费用列表",
        stripeRows: false,
        multiSelect:true,
        //queryCtrlId: 'cmbBedType',
        queryUrl: accessURL,
        queryParams: { 'AcessType': 'GridQuery'},
        getParamFn: GetSearchParam,
        allColumns: [{ header: "ID", dataIndex: "BEDTPI_RowId", sortable: false, hideable: false, hidden: true },
                    { header: "bedTypeId", dataIndex: "BEDTPI_BEDTP_ParRef", sortable: false, hideable: false, hidden: true },
                    { header: "床位类型", dataIndex: "BEDTP_Desc", sortable: true,width:130},
                    { header: "费用类型ID", dataIndex: "BEDTPI_FeeType", sortable: false, hideable: false, hidden: true },
                    { header: "费用类型", dataIndex: "FT_Desc", sortable: true, width: 80 },
                    { header: "费用医嘱ID", dataIndex: "BEDTPI_ARCIM_DR", sortable: false, hideable: false, hidden: true },
                    { header: "费用医嘱", dataIndex: "ARCIM_Desc", sortable: true,width: 300 },
                    { header: "开始时间", dataIndex: "startDate", sortable: true, width: 100 ,
                      renderer: function(startDate) {
	                       var value=tkMakeServerCall("websys.Conversions","DateLogicalToHtml",startDate);
                           return value;
                        }
                    },
                    { header: "结束时间", dataIndex: "endDate", sortable: true,width: 100,
                       renderer: function(endDate) {
                           var value=tkMakeServerCall("websys.Conversions","DateLogicalToHtml",endDate);
                           return value;
                        }
                    }],
        buttons: [btnArray],
        height: 415,
        width: 800,
        x: '10',
        y: '70'
    });
    controls.push(grdBedTypeFee);
    return controls;
}

//取得查询参数
function GetSearchParam() {
     var bedType = Ext.getCmp("cmbBedType").getValue();
     if (bedType == "") {
         return { 'MethodSignature': 'web.DHCPACBedFeeSet:GetBedTypeFeeList' }
     }
     else {
         return { 'MethodSignature': 'web.DHCPACBedFeeSet:GetBedTypeFeeListByType', 'Arg1': bedType }
     }
}

//定义按钮
function InitButtons() {
    var btnDelete = new Ext.Button({
        id: "btnDelete",
        text: "删除",
        iconCls:"icon-delete-custom",
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

    return [btnAdd, btnEdit, btnDelete]
}

//检索数据
function SearchInfor() {
    Ext.getCmp("grdBedTypeFee").loadData();
}

//添加信息
function AddInfor() {
    action = "add";
    var DetailWindow = InitDetailWin();
    DetailWindow.show();
}

//删除信息
function DeleteInfor() {
    var rows = Ext.getCmp("grdBedTypeFee").getSelectionModel().getSelections();
    if (rows.length == 0) {
        ShowMessage("I", "请至少选择一行数据！");
        return;
    }
    ShowConfirmMessage("确实要删除所选的记录吗?", DeleteData);
}

//删除数据
function DeleteData(btn) {
    if (btn == "ok") {
        var rows = Ext.getCmp("grdBedTypeFee").getSelectionModel().getSelections();
        var deleteId = "";
        for (var index = 0; index < rows.length; index++) {
            if (index == 0) {
                deleteId = rows[index].get("BEDTPI_RowId");
            }
            else {
                deleteId = rows[index].get("BEDTPI_RowId");
            }
            var actionParams = { 'AcessType': 'ClassMethod', 'MethodSignature': 'web.DHCPACBedFeeSet:DeleteBedTypeFeeItem', 'Arg1': deleteId };
            SubmitForm("frmBedTypeFeeSet", actionParams, "grdBedTypeFee");
        }
        //var actionParams = { 'AcessType': 'ClassMethod', 'MethodSignature': 'web.DHCPACBedFeeSet:DeleteBedTypeFeeItem', 'Arg1': deleteId };
        //SubmitForm("frmBedTypeFeeSet", actionParams, "grdBedTypeFee");
    }
}

//修改信息
function EditInfor() {
    var rows = Ext.getCmp("grdBedTypeFee").getSelectionModel().getSelections();
    if (rows.length == 0 || rows.length > 1) {
        ShowMessage("I", "请你选择一行数据进行操作！");
        return;
    }
    action = "update";
    //打开窗体
    var DetailWindow = InitDetailWin();
    DetailWindow.show();
    //将选中项的信息绑定到TextField中
    Ext.getCmp("pnlFee").getForm().findField("cmbBedTypeSave").setInitValueAndText(rows[0].get("BEDTPI_BEDTP_ParRef"), rows[0].get("BEDTP_Desc"));
    //封死床位类型，不可修改
    Ext.getCmp("pnlFee").getForm().findField("cmbBedTypeSave").disable()
    Ext.getCmp("pnlFee").getForm().findField("cmbFeeItmMast").setInitValueAndText(rows[0].get("BEDTPI_ARCIM_DR"), rows[0].get("ARCIM_Desc"));
    Ext.getCmp("pnlFee").getForm().findField("cmbFeeType").setInitValueAndText(rows[0].get("BEDTPI_FeeType"), rows[0].get("FT_Desc"));
    var startDate=tkMakeServerCall("websys.Conversions","DateLogicalToHtml",rows[0].get("startDate"));
    var endDate=tkMakeServerCall("websys.Conversions","DateLogicalToHtml",rows[0].get("endDate"));
    Ext.getCmp("pnlFee").getForm().findField("dtbxStartDate").setValue(startDate);
    Ext.getCmp("pnlFee").getForm().findField("dtbxEndDate").setValue(endDate);
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
        height: 240,
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
            { xtype: "FWCombobox",
            displayField: 'BEDTP_Desc',
            valueField: 'BEDTP_RowId',
            queryParams: { 'AcessType': 'ComonQuery', 'MethodSignature': 'web.DHCPACBedFeeSet:GetBedTypeList' },
            storeExpression: [{ name: 'BEDTP_RowId', mapping: 'BEDTP_RowId' }, { name: 'BEDTP_Desc', mapping: 'BEDTP_Desc'}],
            queryUrl: accessURL,
            submitValue: false,
            editable: true,
            height: 20,
            width: 250,
            fieldLabel: "床位类型",
            labelSeparator: '', // 去掉laebl中的冒号    update2020-2-12 钟荣枫
            id: 'cmbBedTypeSave', allowBlank: false, blankText: '此项必填'
        },
        { xtype: "FWBandbox",
            name: "Arg1",
            displayFields: ['ARCIM_Desc', 'ALIAS_Text'],
            displayField: 'ARCIM_Desc',
            valueField: 'ARCIM_RowId',
            queryParams: { 'AcessType': 'GridQuery', 'MethodSignature': 'web.DHCPACBedFeeSet:GetARCItmMastList' },
            storeExpression: [{ name: 'ARCIM_Desc', mapping: 'ARCIM_Desc', caption: '描述', width: 200 }, { name: 'ARCIM_Price', mapping: 'ARCIM_Price', caption: '价格', width: 60 }, { name: 'ARCIM_Code', mapping: 'ARCIM_Code', caption: '代码', width: 100},{ name: 'ARCIM_RowId', mapping: 'ARCIM_RowId', caption: 'ID' }],
            queryUrl: accessURL,
            editable: true,
            submitValue: false,
            height: 20,
            width: 250,
            gridWidth: 350,
            fieldLabel: "费用医嘱",
            labelSeparator: '', // 去掉laebl中的冒号
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
        { xtype: "FWDatebox", width: 250,fieldLabel: "结束日期", name: 'Arg4', format: SYSDateFormat, id: "dtbxEndDate", allowBlank: true, blankText: '此项必填',labelSeparator: '',}];
    return new Ext.FormPanel({
        id: "pnlFee",
        labelWidth: 75,
        labelAlign: "right",
        height: 160,
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
    if (startDate != "" && endDate != "") {
        if (startDate > endDate) {
            ShowMessage("I", "开始日期不能大于结束日期！");
            return;
        }
    }
    if (!Ext.getCmp("pnlFee").getForm().isValid()) return;
    var actionParams;
    var feeItmMast = Ext.getCmp("pnlFee").getForm().findField("cmbFeeItmMast").getValue();
    var feeType = Ext.getCmp("pnlFee").getForm().findField("cmbFeeType").getValue();
    var bedTypeId = Ext.getCmp("pnlFee").getForm().findField("cmbBedTypeSave").getValue();
    if (action == "add") {
        actionParams = { 'AcessType': 'ClassMethod', 'MethodSignature': 'web.DHCPACBedFeeSet:SaveBedTypeFeeItem', 'Arg1': feeItmMast, 'Arg2': feeType, 'Arg5': bedTypeId};
    }
    else if (action == "update") {
        var rows = Ext.getCmp("grdBedTypeFee").getSelectionModel().getSelections();
        var feeItemId = rows[0].get("BEDTPI_RowId")
        actionParams = { 'AcessType': 'ClassMethod', 'MethodSignature': 'web.DHCPACBedFeeSet:UpdateBedTypeFeeItem', 'Arg1': feeItmMast, 'Arg2': feeType, 'Arg5': bedTypeId, 'Arg6': feeItemId };
    }
    SubmitForm("pnlFee", actionParams, "grdBedTypeFee", "winDetail");
}

//取消保存
function CancelSave() {
    Ext.getCmp("winDetail").close();
}