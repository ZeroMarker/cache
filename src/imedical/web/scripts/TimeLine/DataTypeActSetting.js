var accessURL = "../dhcextaccess.csp";
var actionDesc = "";
var selectCode = "";

Ext.onReady(function() {
	Ext.util.CSS.createStyleSheet(".mybtn .x-btn-text{line-height:16px!important;}","fixbtncss");
	Ext.BLANK_IMAGE_URL = BLANK_IMAGE_URL;
	ShowPage();
	Ext.getCmp("grdDataTypeAct").loadData();
});

//显示页面
function ShowPage() {
    var allItems = InitControl();

    var frmDataTypeAct = new Ext.form.FormPanel({
        id: "frmDataTypeAct",
        renderTo: Ext.getBody(),
        layout: 'border',
        baseCls: "", //不能删除
        frame: true,
        title: '',
        items: allItems
    });
}

//定义工具栏
function InitToolBar() {
    var tbItems = new Array();
    tbItems.push('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
    var lblDesc = new Ext.form.Label({
        id: 'lblDesc',
        html: '描述&nbsp;',
        height: 20,
        width: 50
    });
    tbItems.push(lblDesc);

    var txtDesc = new FW.Ctrl.TextBox({
        id: 'txtDesc',
        maxLength: 30,
        height: 20,
        width: 120,
        submitValue: false
    });
    tbItems.push(txtDesc);

    tbItems.push('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
    var lblDataType = new Ext.form.Label({
        id: 'lblDataType',
        text: '子项'
    });
    tbItems.push(lblDataType);
	tbItems.push('&nbsp;')
    var cmbDataType = new FW.Ctrl.BandBox({
        id: "cmbDataType",
        name: "Arg1",
        displayField: 'Description',
        valueField: 'Code',
        queryUrl: accessURL,
        queryParams: { 'AcessType': 'GridQuery', 'MethodSignature': 'icare.DataTypeConfig:GetDataTypeList' },
        storeExpression: [{ name: 'Code', mapping: 'Code', caption: 'Code', width: 50 }, { name: 'Description', mapping: 'Description', caption: '描述', width: 90}],
        editable: true,
        submitValue: false,
        allowBlank: true,
        height: 20,
        width: 190
    });
    tbItems.push(cmbDataType);

    var lblSPace = new Ext.form.Label({
        id: 'lblSPace',
        text: '',
        height: 20,
        width: 80
    });
    tbItems.push(lblSPace);

    var btnSearch = new Ext.Button({
        id: "btnSearch",
        text: "查询",
        icon:'../../images/uiimages/search.png',
        height: 25,
        width: 80,
        cls:'mybtn',
        handler: SearchInfor
    });
    tbItems.push(btnSearch);
    return tbItems;
}

//定义工具栏
function InitControl() {
    var controls = new Array();
    var tbItems = InitToolBar();
    var btnArray = InitButtons();
    var grdDataTypeAct = new FW.Ctrl.ListGrid({
        id: "grdDataTypeAct",
        showSelectColumn: false,
        //是否准许收缩 
        collapsible: false,
        //面板标题消息 子项行为列表
        title: "",
        stripeRows: false,
        queryUrl: accessURL,
        queryParams: {'AcessType':'GridQuery','MethodSignature':'icare.DataTypeActConfig:GetDataTypeActList' },
        getParamFn: GetSearchParam,
        allColumns: [{ header: "代码", dataIndex: "Code", sortable: true, width:80},
                     { header: "描述", dataIndex: "Description", sortable: true, width: 150 },
                     { header: "DataTypeCode", dataIndex: "DataTypeCode", sortable: true, hideable: false, hidden: true },
                     { header: "子项", dataIndex: "DataTypeDesc", sortable: true, width: 150},
                     { header: "HIS代码",dataIndex:"HisCode",width:100},
                     { header: "顺序值",dataIndex:"ActSort",width:100,sortable:true}
                     ],
        tbar: tbItems.concat(btnArray),
        //buttons: [btnArray],
        height: 550,
        region: "center",
        layout: 'fit',
        margins: '0px 5px 0px 5px'
    });
    controls.push(grdDataTypeAct);
    return controls;
}

//取得查询参数
function GetSearchParam() {
    return { 'Arg1': Ext.getCmp("txtDesc").getValue(), 'Arg2': Ext.getCmp("cmbDataType").getValue() }
}

//定义按钮
function InitButtons() {
    var btnDelete = new Ext.Button({
        id: "btnDelete",
        text: "删除",
        height: 25, width: 80,cls:'mybtn',
        icon:'../../images/uiimages/edit_remove.png',
        handler: DeleteDataTypeAct
    });
    var btnAdd = new Ext.Button({
        id: "btnAdd",
        text: "增加",
        height: 25, width: 80,cls:'mybtn',
        icon:'../../images/uiimages/edit_add.png',
        handler: AddDataTypeAct
    });
    var btnEdit = new Ext.Button({
        id: "btnEdit",
        text: "修改",
        height: 25, width: 80,cls:'mybtn',
        icon:'../../images/uiimages/pencil.png',
        handler: EditDataTypeAct
    });

    return ["-",btnAdd, "-",btnEdit,"-", btnDelete]
}

//检索信息
function SearchInfor() {
    Ext.getCmp("grdDataTypeAct").loadData();
}

//添加数据
function AddDataTypeAct() {
    actionDesc = "Add"
    var DetailWindow = InitInforDetialForm(actionDesc);
    DetailWindow.show();
}


//修改数据
function EditDataTypeAct() {
    var rows = Ext.getCmp("grdDataTypeAct").getSelectionModel().getSelections();
    if (rows.length == 0 || rows.length > 1) {
        FW.CommonMethod.ShowMessage("I", "请你选择一行数据进行操作！");
        return;
    }
    actionDesc = "Edit";
    selectCode = rows[0].get("Code");
    //打开窗体
    var DetailWindow = InitInforDetialForm(actionDesc);
    DetailWindow.show();
    //将选中项的信息绑定到TextField中
    Ext.getCmp("pnlDataTypeAct").getForm().findField("txtCode").setValue(rows[0].get("Code"));
    Ext.getCmp("pnlDataTypeAct").getForm().findField("txtDescription").setValue(rows[0].get("Description"));
    Ext.getCmp("pnlDataTypeAct").getForm().findField("cmbPnlDataType").setInitValueAndText(rows[0].get("DataTypeCode"), rows[0].get("DataTypeDesc"));
    Ext.getCmp("pnlDataTypeAct").getForm().findField("txtHisCode").setValue(rows[0].get("HisCode"));
    Ext.getCmp("pnlDataTypeAct").getForm().findField("txtActSort").setValue(rows[0].get("ActSort"));
}

//删除数据
function DeleteDataTypeAct() {
    var rows = Ext.getCmp("grdDataTypeAct").getSelectionModel().getSelections();
    if (rows.length == 0) {
        FW.CommonMethod.ShowMessage("I", "请至少选择一行数据！");
        return;
    }
    FW.CommonMethod.ShowConfirmMessage("确实要删除所选的记录吗?", DeleteData);
}

//删除数据
function DeleteData(btn) {
    if (btn == "ok") {
        var rows = Ext.getCmp("grdDataTypeAct").getSelectionModel().getSelections();
        var deleteId = "";
        for (var index = 0; index < rows.length; index++) {
            if (index == 0) {
                deleteId = rows[index].get("Code");
            }
            else {
                deleteId = rows[index].get("Code");
            }
        }
        var actionParams = { 'AcessType': 'ClassMethod', 'MethodSignature': 'icare.DataTypeActConfig:DeleteDataTypeAct', 'Arg1': deleteId };
        FW.CommonMethod.SubmitForm("frmDataTypeAct", actionParams, "grdDataTypeAct");
    }
}

//初始化信息窗口
function InitInforDetialForm(actionDesc) {
    var pnlDetail = InitPanel(actionDesc);
    var btnSave = new Ext.Button({
        id: "btnSave",
        text: "保存",
	icon:'../../images/uiimages/filesave.png',
        handler: SaveInfor
    });
    var btnCancelSave = new Ext.Button({
        id: "btnCancelSave",
        text: "取消",
	icon:'../../images/uiimages/cancel.png',
        handler: CancelSave
    });

    //修改和添加时的弹出窗体
    return new Ext.Window({
        id: "winDataTypeAct",
        //是否准许收缩 
        collapsible: true,
        //能否最大化
        maximizable: false,
        height: 280,
        width: 350,
        modal: true,
        closable: true,
        autoDestroy: true,
        layout: "form",
        plain: true,
        title: "子项信息",
        bodyStyle: "padding:5px;",
        buttonAlign: "center",
        items: pnlDetail,
        buttons: [btnSave, btnCancelSave]
    });
}

//初始化信息窗体
function InitPanel(actionDesc) {
         var controls = [{ xtype: "FWTextBox", fieldLabel: "代码", vtype: 'number', id: "txtCode", maxLength: 20, allowBlank: false,  height: 20, width: 155 ,labelSeparator:""},
             { xtype: "FWTextBox", fieldLabel: "描述", id: "txtDescription", maxLength: 20, allowBlank: false, height: 20,width: 155 ,labelSeparator:""},
             { xtype: "FWBandbox",
                 name: "Arg1",
                 displayField: 'Description',
                 valueField: 'Code',
                 queryUrl: accessURL,
                 queryParams: { 'AcessType': 'GridQuery', 'MethodSignature': 'icare.DataTypeConfig:GetDataTypeList' },
                 storeExpression: [{ name: 'Code', mapping: 'Code', caption: '代码', width: 50 }, { name: 'Description', mapping: 'Description', caption: '描述', width: 90}],
                 editable: true,
                 submitValue: false,
                 allowBlank: false,
                 height: 20,
                 width: 190,
                 fieldLabel: "子项",
                 labelSeparator:"",
                 id: 'cmbPnlDataType', allowBlank: false
             },
             { xtype: "FWTextBox", fieldLabel: "HIS对照代码", id: "txtHisCode", maxLength: 20, allowBlank: true, height: 20,width: 155 ,labelSeparator:""},
             { xtype: "FWTextBox", fieldLabel: "顺序", id: "txtActSort", maxLength: 20, allowBlank: true, height: 20,width: 155 ,labelSeparator:""}
         ];
    return new Ext.FormPanel({
        id: "pnlDataTypeAct",
        labelWidth: 80,
        labelAlign: "right",
        height: 300,
        frame: true,
        bodyStyle: "padding:5px 5px 0",
        defaultType: "textfield",
        items: controls
    });
}

//保存信息
function SaveInfor() {
    var code = Ext.getCmp("pnlDataTypeAct").getForm().findField("txtCode").getValue();
    var desc = Ext.getCmp("pnlDataTypeAct").getForm().findField("txtDescription").getValue();
    var dataTypeCode = Ext.getCmp("pnlDataTypeAct").getForm().findField("cmbPnlDataType").getValue();
    var HisCode = Ext.getCmp("pnlDataTypeAct").getForm().findField("txtHisCode").getValue();
    var ActSort = Ext.getCmp("pnlDataTypeAct").getForm().findField("txtActSort").getValue();
    var actionParams = "";
    if (actionDesc == "Add") {
        actionParams = { 'AcessType': 'ClassMethod', 'MethodSignature': 'icare.DataTypeActConfig:AddDataTypeAct', 
        'Arg1': code, 'Arg2': desc, 'Arg3': dataTypeCode,'Arg4': HisCode,'Arg5':ActSort};
    }
    else if (actionDesc == "Edit") {
    var oldCode = selectCode;
    actionParams = { 'AcessType': 'ClassMethod', 'MethodSignature': 'icare.DataTypeActConfig:UpdateDataTypeAct', 
    'Arg1': oldCode, 'Arg2': code, 'Arg3': desc, 'Arg4': dataTypeCode ,'Arg5':HisCode,'Arg6':ActSort};
    }
    SubmitForm("pnlDataTypeAct", actionParams, "grdDataTypeAct", "winDataTypeAct");
}

//取消保存信息
function CancelSave() {
    Ext.getCmp("winDataTypeAct").close();
}

//提交
function SubmitForm(frmName, actionParams, grdName, winName) {
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
            if (action.result.success == "false") {
                FW.CommonMethod.ShowMessage("E", "操作失败,输入的Code可能已经存在！");
            }
            else {
                FW.CommonMethod.ShowMessage("I", "操作成功！");
                if (grdName) {
                    Ext.getCmp(grdName).store.reload();
                }
            }
        },
        failure: function(form, action) {
            FW.CommonMethod.ShowMessage("E", "操作失败！");
        }
    });
}