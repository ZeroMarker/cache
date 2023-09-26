var accessURL = "../dhcextaccess.csp";
var actionDesc = "";
var selectCode = "";

Ext.onReady(function() {
	Ext.util.CSS.createStyleSheet(".mybtn .x-btn-text{line-height:16px!important;}","fixbtncss");
	Ext.BLANK_IMAGE_URL = BLANK_IMAGE_URL;
	ShowPage();
	Ext.getCmp("grdTimeLineItems").loadData();
});

//显示页面
function ShowPage() {
    var allItems = InitControl();
    var frmTimeLineItems = new Ext.form.FormPanel({
        id: "frmTimeLineItems",
        layout: "border",
        renderTo: Ext.getBody(),
        baseCls: "",
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
        html: '项目描述&nbsp;',
        height: 20,
        width: 60
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
    var lblViewType = new Ext.form.Label({
        id: 'lblViewType',
        html: '显示类型&nbsp;',
        height: 20,
        width: 60
    });
    tbItems.push(lblViewType);

    var cbxViewType = new FW.Ctrl.ComboBox({
        id: 'cbxViewType',
        dataItems: viewTypeData,
        valueField: 'viewType',
        displayField: 'viewTypeDesc',
        editable: true,
        height: 20,
        width: 120,
        submitValue: false
    });
    tbItems.push(cbxViewType);

    tbItems.push('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
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

//定义控件
function InitControl() {
    var controls = new Array();
//    var lblDesc = new Ext.form.Label({
//        id: 'lblDesc',
//        text: '项目描述:',
//        height: 20,
//        width: 60,
//        x: '140',
//        y: '22'
//    });
//    controls.push(lblDesc);

//    var txtDesc = new FW.Ctrl.TextBox({
//        id: 'txtDesc',
//        maxLength: 30,
//        height: 20,
//        width: 120,
//        submitValue: false,
//        x: '200',
//        y: '20'
//    });
//    controls.push(txtDesc);

//    var lblViewType = new Ext.form.Label({
//        id: 'lblViewType',
//        text: '显示类型:',
//        height: 20,
//        width: 60,
//        x: '340',
//        y: '22'
//    });
//    controls.push(lblViewType);
//    
//    var cbxViewType = new FW.Ctrl.ComboBox({
//        id: 'cbxViewType',
//        dataItems: viewTypeData,
//        valueField: 'viewType',
//        displayField: 'viewTypeDesc',
//        editable: true,
//        height: 20,
//        width: 120,
//        submitValue: false,
//        x: '400',
//        y: '20'
//    });
//    controls.push(cbxViewType);

//    var btnSearch = new Ext.Button({
//        id: "btnSearch",
//        text: "搜索",
//        height: 25,
//        width: 80,
//        x: '550',
//        y: '18',
//        handler: SearchInfor
//    });
//    controls.push(btnSearch);

    var btnArray = InitButtons();
    var tbItems = InitToolBar();
    var grdTimeLineItems = new FW.Ctrl.ListGrid({
        id: "grdTimeLineItems",
        showSelectColumn: false,
        //是否准许收缩 
        collapsible: false,
        //面板标题消息
        title: "", //显示项目列表
        stripeRows: false,
        queryUrl: accessURL,
        queryParams: { 'AcessType': 'GridQuery', 'MethodSignature': 'icare.TimeLineConfig:GetTimeLineItems' },
        getParamFn: GetSearchParam,
        allColumns: [{ header: "ID", dataIndex: "ID", sortable: true, width: 0, hideable: false, hidden: true },
                     { header: "CategoryCode", dataIndex: "CategoryCode", width: 0, hideable: false, hidden: true },
                     { header: "项目描述", dataIndex: "CategoryDesc", sortable: true, width: 150 },
                     { header: "ViewType", dataIndex: "ViewType", width: 0, hideable: false, hidden: true },
                     { header: "显示类型", dataIndex: "ViewTypeDesc", sortable: true, width: 100 },
                     { header: "ViewConfigId", dataIndex: "ViewConfigId", width: 0, hideable: false, hidden: true },
                     { header: "显示配置", dataIndex: "ViewConfigParam", sortable: true, width: 210 },
                     { header: "显示顺序", dataIndex: "Sequence", sortable: true, width: 60}],
        tbar: tbItems.concat(btnArray),
       // buttons: [btnArray],
        height: 460,
        region:'center'
        //width: 650,
        //x: '60',
        //y: '40'
    });
    controls.push(grdTimeLineItems);
    return controls;
}

//取得查询参数
function GetSearchParam() {

    return { 'Arg1': timeLineId, 'Arg2': Ext.getCmp("txtDesc").getValue(), 'Arg3': Ext.getCmp("cbxViewType").getValue() }
}

//定义按钮
function InitButtons() {
    var btnDelete = new Ext.Button({
        id: "btnDelete",
        text: "删除",
        height: 25,
        width: 80,
        cls:'mybtn',
		icon:'../../images/uiimages/edit_remove.png',
        handler: DeleteTimeLineItems
    });
    var btnAdd = new Ext.Button({
        id: "btnAdd",
        text: "增加",
        height: 25,        
        width: 80,
        cls:'mybtn',
		icon:'../../images/uiimages/edit_add.png',
        handler: AddTimeLineItems
    });
    var btnEdit = new Ext.Button({
        id: "btnEdit",
        text: "修改",
        height: 25,        
        width: 80,
        cls:'mybtn',
		icon:'../../images/uiimages/pencil.png',
        handler: EditTimeLineItems
    });

    return ["-",btnAdd, "-",btnEdit,"-", btnDelete]
}

//检索信息
function SearchInfor() {
    Ext.getCmp("grdTimeLineItems").loadData();
}

//添加数据
function AddTimeLineItems() {
    actionDesc = "Add"
    var DetailWindow = InitInforDetialForm(actionDesc);
    DetailWindow.show();
}


//修改数据
function EditTimeLineItems() {
    var rows = Ext.getCmp("grdTimeLineItems").getSelectionModel().getSelections();
    if (rows.length == 0 || rows.length > 1) {
        FW.CommonMethod.ShowMessage("I", "请你选择一行数据进行操作！");
        return;
    }
    actionDesc = "Edit"
    selectCode = rows[0].get("ID");
    //打开窗体
    var DetailWindow = InitInforDetialForm(actionDesc);
    DetailWindow.show();
    //将选中项的信息绑定到TextField中
    Ext.getCmp("pnlTimeLineItems").getForm().findField("cbxCategory").setValueAndLoad(rows[0].get("CategoryCode"));
    Ext.getCmp("pnlTimeLineItems").getForm().findField("cbxShowType").setValueAndLoad(rows[0].get("ViewType"));
    Ext.getCmp("pnlTimeLineItems").getForm().findField("cbxViewConfig").setValueAndLoad(rows[0].get("ViewConfigId"));
    Ext.getCmp("pnlTimeLineItems").getForm().findField("txtSequence").setValue(rows[0].get("Sequence"));
}

//删除数据
function DeleteTimeLineItems() {
    var rows = Ext.getCmp("grdTimeLineItems").getSelectionModel().getSelections();
    if (rows.length == 0) {
        FW.CommonMethod.ShowMessage("I", "请至少选择一行数据！");
        return;
    }
    FW.CommonMethod.ShowConfirmMessage("确实要删除所选的记录吗?", DeleteData);
}


//删除数据
function DeleteData(btn) {
    if (btn == "ok") {
        var rows = Ext.getCmp("grdTimeLineItems").getSelectionModel().getSelections();
        var deleteId = "";
        for (var index = 0; index < rows.length; index++) {
            if (index == 0) {
                deleteId = rows[index].get("ID");
            }
            else {
                deleteId = rows[index].get("ID");
            }
        }
        var actionParams = { 'AcessType': 'ClassMethod', 'MethodSignature': 'icare.TimeLineConfig:DeleteTimeLineItems', 'Arg1': deleteId };
        FW.CommonMethod.SubmitForm("frmTimeLineItems", actionParams, "grdTimeLineItems");
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
        id: "winTimeLineItems",
        //是否准许收缩 
        collapsible: true,
        //能否最大化
        maximizable: false,
        height: 200,
        width: 300,
        modal: true,
        closable: true,
        autoDestroy: true,
        layout: "form",
        plain: true,
        title: "显示项目信息",
        bodyStyle: "padding:5px;",
        buttonAlign: "center",
        items: pnlDetail,
        buttons: [btnSave, btnCancelSave]
    });
}

//初始化信息窗体
function InitPanel(actionDesc) {
    var controls = [{ xtype: "FWCombobox", fieldLabel: "显示项目", id: "cbxCategory",
        displayField: 'Description', valueField: 'Code',
        queryUrl: accessURL,
        displayFields:['Description'],
        queryParams: { 'AcessType': 'ComonQuery', 'MethodSignature': 'icare.TimeLineCategroyConfig:GetCategroyInforList'},
        storeExpression: [{ name: 'Code', mapping: 'Code' }, { name: 'Description', mapping: 'Description'}],
        editable: true, submitValue: false, allowBlank: false, height: 20, width: 150 ,labelSeparator:""},
        { xtype: "FWCombobox", fieldLabel: "显示类型", id: "cbxShowType", dataItems: viewTypeData,
            displayField: 'viewTypeDesc', valueField: 'viewType',
            editable: true,submitValue: false,
            allowBlank: false, height: 20, width: 150 ,labelSeparator:""},
        { xtype: "FWCombobox", fieldLabel: "显示配置", id: "cbxViewConfig",
            displayFields: ['Description', 'Parameters'], displayField: 'Description', valueField: 'ID',
            queryUrl: accessURL,
            queryParams: { 'AcessType': 'ComonQuery', 'MethodSignature': 'icare.ViewTypeParamConfig:GetViewTypeParamListInfor' },
            storeExpression: [{ name: 'ID', mapping: 'ID' }, { name: 'Description', mapping: 'Description' }, { name: 'Parameters', mapping: 'Parameters'}],
            submitValue: false, editable: true, allowBlank: true, height: 20, width: 150 ,labelSeparator:""},
        { xtype: "FWTextBox", fieldLabel: "显示顺序", id: "txtSequence", vtype: 'number', maxLength: 20, submitValue: false, allowBlank: false, height: 20, width: 150 ,labelSeparator:""}];
    return new Ext.FormPanel({
        id: "pnlTimeLineItems",
        labelWidth: 75,
        labelAlign: "right",
        height: 120,
        frame: true,
        bodyStyle: "padding:5px 5px 0",
        defaultType: "textfield",
        items: controls
    });
}

//保存信息
function SaveInfor() {
    var category= Ext.getCmp("pnlTimeLineItems").getForm().findField("cbxCategory").getValue();
    var viewType = Ext.getCmp("pnlTimeLineItems").getForm().findField("cbxShowType").getValue();
    var viewConfig = Ext.getCmp("pnlTimeLineItems").getForm().findField("cbxViewConfig").getValue();
    var sequence = Ext.getCmp("pnlTimeLineItems").getForm().findField("txtSequence").getValue();
    var actionParams = "";
    if (actionDesc == "Add") {
        actionParams = { 'AcessType': 'ClassMethod', 'MethodSignature': 'icare.TimeLineConfig:AddTimeLineItems', 'Arg1': timeLineId, 'Arg2': category, 'Arg3': viewType, 'Arg4': viewConfig, 'Arg5': sequence };
    }
    else if (actionDesc == "Edit") {
    actionParams = { 'AcessType': 'ClassMethod', 'MethodSignature': 'icare.TimeLineConfig:UpdateTimeLineItems', 'Arg1': timeLineId, 'Arg2': selectCode, 'Arg3': category, 'Arg4': viewType, 'Arg5': viewConfig, 'Arg6': sequence };
    }
    SubmitForm("pnlTimeLineItems", actionParams, "grdTimeLineItems", "winTimeLineItems");
}

//取消保存信息
function CancelSave() {
    Ext.getCmp("winTimeLineItems").close();
}

//提交页面
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
                FW.CommonMethod.ShowMessage("E", "操作失败,该显示项目可能已经存在！");
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