var accessURL = "../dhcextaccess.csp";

Ext.onReady(function() {
	Ext.util.CSS.createStyleSheet(".mybtn .x-btn-text{line-height:16px!important;}","fixbtncss");
    Ext.BLANK_IMAGE_URL = BLANK_IMAGE_URL;
    ShowPage();
    Ext.getCmp("grdDiagnoseType").loadData();
    document.onkeydown = ProhibitBack;
});

//禁止后退
function ProhibitBack(e) {
    var code;
    if (!e) var e = window.event;
    if (e.keyCode) code = e.keyCode;
    else if (e.which) code = e.which;

    if (((event.keyCode == 8) &&                                                    //BackSpace 
         ((event.srcElement.type != "text" &&
         event.srcElement.type != "textarea" &&
         event.srcElement.type != "password") ||
         event.srcElement.readOnly == true)) ||
        ((event.ctrlKey) && ((event.keyCode == 78) || (event.keyCode == 82))) ||    //CtrlN,CtrlR 
        (event.keyCode == 116)) {                                                   //F5 
        event.keyCode = 0;
        event.returnValue = false;
    }
    return true;
}

//显示页面
function ShowPage() {
    var allItems = InitControl();
    var frmDiagnoseType = new Ext.form.FormPanel({
        id: "frmDiagnoseType",
        layout: "border",
        renderTo: Ext.getBody(),
        //region: "center",
        //width: 835,
        //height: 468,
        baseCls: "",
        frame: true,
        title: '',
        cls: '',
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
        height: 25,
        width: 80,cls:'mybtn',
        icon:'../../images/uiimages/search.png',
        handler: SearchInfor
    });
    tbItems.push(btnSearch);
    return tbItems;
}

//定义控件
function InitControl() {
    var controls = new Array();
    var tbItems = InitToolBar();
    var btnArray = InitButtons();
    
    var grdDiagnoseType = new FW.Ctrl.ListGrid({
        id: "grdDiagnoseType",
        showSelectColumn: false,
        //是否准许收缩 
        collapsible: false,
        //面板标题消息
        title: "", //诊断类型列表
        stripeRows: false,
        queryUrl: accessURL,
        queryParams: { 'AcessType': 'GridQuery', 'MethodSignature': 'icare.DiagnoseSetting:GetDiagnoseType' },
        getParamFn: GetSearchParam,
        allColumns: [{ header: "ID", dataIndex: "ID", sortable: false, width: 0,hidden:true,hideable:false },
                     { header: "描述", dataIndex: "Description", sortable: false, width: 200 },
                     { header: "显示顺序", dataIndex: "SortNumber", sortable: false, width: 80 }],
        tbar: tbItems.concat(btnArray),
        //buttons: [btnArray],
        height: 550,
        //width: 800,
        //x: '80',
       // y: '40'
		icon:'../../images/uiimages/search.png',
        region: "center",
        layout: 'fit',
        margins: '0px 5px 0px 5px'
    });
    controls.push(grdDiagnoseType);
    return controls;
}

//取得查询参数
function GetSearchParam() {

    return { 'Arg1': Ext.getCmp("txtDesc").getValue() }
}

//定义按钮
function InitButtons() {
    var btnEdit = new Ext.Button({
        id: "btnEdit",
        text: "修改",
        height: 25,width: 80,cls:'mybtn',
        icon:'../../images/uiimages/pencil.png',
        handler: EditItem
    });

    return ["-",btnEdit]
}

//检索信息
function SearchInfor() {
    Ext.getCmp("grdDiagnoseType").loadData();
}


//修改数据
function EditItem() {
    var rows = Ext.getCmp("grdDiagnoseType").getSelectionModel().getSelections();
    if (rows.length == 0 || rows.length > 1) {
        FW.CommonMethod.ShowMessage("I", "请你选择一行数据进行操作！");
        return;
    }
    //打开窗体
    var DetailWindow = InitInforDetialForm();
    DetailWindow.show();
    //将选中项的信息绑定到TextField中
    Ext.getCmp("pnlDiagnoseType").getForm().findField("txtId").setValue(rows[0].get("ID"));
    Ext.getCmp("pnlDiagnoseType").getForm().findField("txtOldSortNumber").setValue(rows[0].get("SortNumber"));
    Ext.getCmp("pnlDiagnoseType").getForm().findField("txtDescription").setValue(rows[0].get("Description"));
    Ext.getCmp("pnlDiagnoseType").getForm().findField("txtSortNumber").setValue(rows[0].get("SortNumber"));
}

//初始化信息窗口
function InitInforDetialForm() {
    var pnlDetail = InitPanel();
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
        id: "winDiagnoseType",
        //是否准许收缩 
        collapsible: true,
        //能否最大化
        maximizable: false,
        height: 150,
        width: 300,
        modal: true,
        closable: true,
        autoDestroy: true,
        layout: "form",
        plain: true,
        title: "诊断类型信息",
        bodyStyle: "padding:5px;",
        buttonAlign: "center",
        items: pnlDetail,
        buttons: [btnSave, btnCancelSave]
    });
}

//初始化信息窗体
function InitPanel() {
    var controls = [{ xtype: "FWTextBox", fieldLabel: "Id", vtype: 'alphanum', id: "txtId", maxLength: 20, allowBlank: false, height: 20, width: 100, hidden: true },
        { xtype: "FWTextBox", fieldLabel: "Id", vtype: 'alphanum', id: "txtOldSortNumber", maxLength: 20, allowBlank: false, height: 20, width: 100, hidden: true },
         { xtype: "FWTextBox", fieldLabel: "描述", id: "txtDescription", maxLength: 30, allowBlank: false, height: 20, width: 150, readOnly: true ,labelSeparator:""},
         { xtype: "FWTextBox", fieldLabel: "显示顺序", vtype: 'alphanum', id: "txtSortNumber", maxLength: 2, allowBlank: false, height: 20, width: 150 ,labelSeparator:""}
         ];
    return new Ext.FormPanel({
        id: "pnlDiagnoseType",
        labelWidth: 75,
        labelAlign: "right",
        height: 70,
        frame: true,
        bodyStyle: "padding:5px 5px 0",
        defaultType: "textfield",
        items: controls
    });
}

//保存信息
function SaveInfor() {
    var Id = Ext.getCmp("pnlDiagnoseType").getForm().findField("txtId").getValue();
    var desc = Ext.getCmp("pnlDiagnoseType").getForm().findField("txtDescription").getValue();
    var oldSortNumber = Ext.getCmp("pnlDiagnoseType").getForm().findField("txtOldSortNumber").getValue();
    var sortNumber = Ext.getCmp("pnlDiagnoseType").getForm().findField("txtSortNumber").getValue();
    var actionParams = { 'AcessType': 'ClassMethod', 'MethodSignature': 'icare.DiagnoseSetting:UpdateDiagnoseType', 'Arg1': Id, 'Arg2': desc, 'Arg3': oldSortNumber, 'Arg4': sortNumber };
    SubmitForm("pnlDiagnoseType", actionParams, "grdDiagnoseType", "winDiagnoseType");
}

//取消保存信息
function CancelSave() {
    Ext.getCmp("winDiagnoseType").close();
}

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
                FW.CommonMethod.ShowMessage("E", "操作失败！");
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