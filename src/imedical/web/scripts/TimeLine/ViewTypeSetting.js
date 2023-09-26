var accessURL = "../dhcextaccess.csp";
var actionDesc = "";
var selectId = "";

Ext.onReady(function() {
	Ext.util.CSS.createStyleSheet(".mybtn .x-btn-text{line-height:16px!important;}","fixbtncss");
	Ext.BLANK_IMAGE_URL = BLANK_IMAGE_URL;
	ShowPage();
	Ext.getCmp("grdDataTypeParam").loadData();
});

//显示页面
function ShowPage() {
    var allItems = InitControl();
    var frmDataTypeParam = new Ext.form.FormPanel({
        id: "frmDataTypeParam",
        layout: "border",
        renderTo: Ext.getBody(),
        //region: "center",
        //width: 835,
        baseCls: "",
        //height: 468,
        //frame: true,
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
        width: 150,
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
        width: 80,
        cls:'mybtn',
        icon:'../../images/uiimages/search.png',
        handler: SearchInfor
    });
    tbItems.push(btnSearch);
    return tbItems;
}


//定义控件
function InitControl() {
    var controls = new Array();
    var btnArray = InitButtons();
    var tbItems = InitToolBar();

    var grdDataTypeParam = new FW.Ctrl.ListGrid({
        id: "grdDataTypeParam",
        showSelectColumn: false,
        //是否准许收缩 
        collapsible: false,
        //面板标题消息
        title: "", //显示配置列表
        stripeRows: false,
        queryUrl: accessURL,
        queryParams: { 'AcessType': 'GridQuery', 'MethodSignature': 'icare.ViewTypeParamConfig:GetViewTypeParamList' },
        getParamFn: GetSearchParam,
        allColumns: [{ header: "ID", dataIndex: "ID", sortable: true, hideable: false, hidden: true },
                     { header: "描述", dataIndex: "Description", sortable: true, width: 150 },
                     { header: "参数", dataIndex: "Parameters", sortable: true, width: 200}],
        tbar: tbItems.concat(btnArray),
        //buttons: [btnArray],
        height: 550,
        //width: 800,
        //x: '80',
        //y: '40'
		icon:'../../images/uiimages/search.png',
        region: "center",
        layout: 'fit',
        margins: '0px 5px 0px 5px'

    });
    controls.push(grdDataTypeParam);
    return controls;
}

//取得查询参数
function GetSearchParam() {

    return { 'Arg1': Ext.getCmp("txtDesc").getValue() }
}

//定义按钮
function InitButtons() {
    var btnDelete = new Ext.Button({
        id: "btnDelete",
        text: "删除",
        height: 25,width: 80,cls:'mybtn',
        icon:'../../images/uiimages/edit_remove.png',
        handler: DeleteDataTypeParam
    });
    var btnAdd = new Ext.Button({
        id: "btnAdd",
        text: "增加",
        height: 25,width: 80,cls:'mybtn',
        icon:'../../images/uiimages/edit_add.png',
        handler: AddDataTypeParam
    });
    var btnEdit = new Ext.Button({
        id: "btnEdit",
        text: "修改",
        height: 25,width: 80,cls:'mybtn',
        icon:'../../images/uiimages/pencil.png',
        handler: EditDataTypeParam
    });

    return ["-",btnAdd,"-", btnEdit,"-", btnDelete]
}

//检索信息
function SearchInfor() {
    Ext.getCmp("grdDataTypeParam").loadData();
}

//添加数据
function AddDataTypeParam() {
    actionDesc = "Add"
    var DetailWindow = InitInforDetialForm(actionDesc);
    DetailWindow.show();
}


//修改数据
function EditDataTypeParam() {
    var rows = Ext.getCmp("grdDataTypeParam").getSelectionModel().getSelections();
    if (rows.length == 0 || rows.length > 1) {
        FW.CommonMethod.ShowMessage("I", "请你选择一行数据进行操作！");
        return;
    }
    actionDesc = "Edit"
    selectId = rows[0].get("ID");
    //打开窗体
    var DetailWindow = InitInforDetialForm(actionDesc);
    DetailWindow.show();
    //将选中项的信息绑定到TextField中
    Ext.getCmp("pnlDataTypeParam").getForm().findField("txtDescription").setValue(rows[0].get("Description"));
    Ext.getCmp("pnlDataTypeParam").getForm().findField("txtParam").setValue(rows[0].get("Parameters"));
}


//删除数据
function DeleteDataTypeParam() {
    var rows = Ext.getCmp("grdDataTypeParam").getSelectionModel().getSelections();
    if (rows.length == 0) {
        FW.CommonMethod.ShowMessage("I", "请至少选择一行数据！");
        return;
    }
    FW.CommonMethod.ShowConfirmMessage("确实要删除所选的记录吗?", DeleteData);
}


//删除数据
function DeleteData(btn) {
    if (btn == "ok") {
        var rows = Ext.getCmp("grdDataTypeParam").getSelectionModel().getSelections();
        var deleteId = "";
        for (var index = 0; index < rows.length; index++) {
            if (index == 0) {
                deleteId = rows[index].get("ID");
            }
            else {
                deleteId = rows[index].get("ID");
            }
        }
        var actionParams = { 'AcessType': 'ClassMethod', 'MethodSignature': 'icare.ViewTypeParamConfig:DeleteViewTypeParam', 'Arg1': deleteId };
        FW.CommonMethod.SubmitForm("frmDataTypeParam", actionParams, "grdDataTypeParam");
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
        id: "winDataTypeParam",
        //是否准许收缩 
        collapsible: true,
        //能否最大化
        maximizable: false,
        height: 150,
        width: 350,
        modal: true,
        closable: true,
        autoDestroy: true,
        layout: "form",
        plain: true,
        title: "显示配置信息",
        bodyStyle: "padding:5px;",
        buttonAlign: "center",
        items: pnlDetail,
        buttons: [btnSave, btnCancelSave]
    });
}

//初始化信息窗体
function InitPanel(actionDesc) {
    var controls = [{ xtype: "FWTextBox", fieldLabel: "描述", id: "txtDescription", maxLength: 20, allowBlank: false,  height: 20, width: 200 ,labelSeparator:""},
                    { xtype: "FWTextBox", fieldLabel: "参数值", id: "txtParam", maxLength: 500, allowBlank: false,  height: 20, width: 200 ,labelSeparator:"" }
         ];
    return new Ext.FormPanel({
        id: "pnlDataTypeParam",
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
    var param = Ext.getCmp("pnlDataTypeParam").getForm().findField("txtParam").getValue();
    var desc = Ext.getCmp("pnlDataTypeParam").getForm().findField("txtDescription").getValue();
    var actionParams = "";
    if (actionDesc == "Add") {
        actionParams = { 'AcessType': 'ClassMethod', 'MethodSignature': 'icare.ViewTypeParamConfig:AddViewTypeParam', 'Arg1': desc, 'Arg2': param };
    }
    else if (actionDesc == "Edit") {
    actionParams = { 'AcessType': 'ClassMethod', 'MethodSignature': 'icare.ViewTypeParamConfig:UpdateViewTypeParam', 'Arg1': selectId, 'Arg2': desc, 'Arg3': param };
    }
    SubmitForm("pnlDataTypeParam", actionParams, "grdDataTypeParam", "winDataTypeParam");
}

//取消保存信息
function CancelSave() {
    Ext.getCmp("winDataTypeParam").close();
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