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

//��ʾȷ����Ϣ
ShowConfirmMessage = function(messageInfor, callbackFunction) {
    Ext.MessageBox.show({
        title: "ȷ����Ϣ",
        msg: messageInfor,
        width: 250,
        fn: callbackFunction,
        buttons: Ext.MessageBox.OKCANCEL,
        icon: Ext.MessageBox.QUESTION
    });
}

//��ʾ��Ϣ
ShowMessage = function(messageType, messageInfor, url) {
    var messageTitle;
    var msgIcon;
    if (messageType == "E") {
        messageTitle = "������Ϣ";
        msgIcon = Ext.MessageBox.ERROR;
    }
    else if (messageType == "I") {
        messageTitle = "��ʾ��Ϣ";
        msgIcon = Ext.MessageBox.INFO;
    }
    else if (messageType == "W") {
        messageTitle = "������Ϣ";
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
    

//��������
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
        waitTitle: '��ʾ',
        waitMsg: '�����ύ�������Ժ�...',
        url: accessURL,
        params: actionParams,
        success: function(form, action) {
            if (winName) {
                Ext.getCmp(winName).close();
            }
            ShowMessage("I", "�����ɹ���");
            if (grdName) {
                Ext.getCmp(grdName).store.reload();
            }
        },
        failure: function(form, action) {
            ShowMessage("E", "����ʧ�ܣ�");
        }
    });
}

//��ʾҳ��
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

//�����ؼ�
function CreateItems() {
    var controls = new Array();
    var treeMenu = new Ext.tree.TreePanel({
        id: 'treeBed',
        title: '������λ',
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
        //�Ƿ�׼������ 
        collapsible: false,
        //��������Ϣ
        title: "��λ�����б�",
        stripeRows: false,
        queryUrl: accessURL,
        multiSelect:true,
        queryParams: { 'AcessType': 'GridQuery', 'MethodSignature': 'web.DHCPACBedFeeSet:GetBedFeeList' },
        getParamFn: GetSearchParam,
        allColumns: [{ header: "ID", dataIndex: "BEDI_RowId", sortable: false, hideable: false, hidden: true },
                     { header: "��������ID", dataIndex: "BEDI_FeeType", sortable: false, hideable: false, hidden: true },
                      { header: "��������", dataIndex: "FT_Desc", sortable: true, width: 80},
                     { header: "����ҽ��ID", dataIndex: "BEDI_ARCIM_DR", sortable: false, hideable: false, hidden: true },
                     { header: "����ҽ��", dataIndex: "ARCIM_Desc", sortable: true, width: 230 },
                     { header: "��ʼʱ��", dataIndex: "startDate", sortable: true, width: 100,
                        renderer: function(startDate) {
	                       var value=tkMakeServerCall("websys.Conversions","DateLogicalToHtml",startDate);
                           return value;
                        }
                     },
                     { header: "����ʱ��", dataIndex: "endDate", sortable: true, width: 100,
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

//���尴ť
function InitButtons() {
	if (CFEnableAir=='Y') {CFEnableAir=true;}else{CFEnableAir=false;}
	if (CFEnableHeat=='Y') {CFEnableHeat=true;}else{CFEnableHeat=false;}
	var EnableAirSelect = new  Ext.form.Checkbox({
        id: "EnableAirSelect",
		checked:CFEnableAir,
        boxLabel :'<span style="font-size:16px;">���ÿյ�����ȡ</span>',
        handler: SelectInfor
    });
	var EnableHeatSelect = new  Ext.form.Checkbox({
        id: "EnableHeatSelect",
		checked:CFEnableHeat,
        boxLabel :'<span style="font-size:16px;">����ů������ȡ</span>',
        handler: SelectInfor
    });
	
    var btnDelete = new Ext.Button({
        id: "btnDelete",
        iconCls:"icon-delete-custom",
        text: "ɾ��",
        handler: DeleteInfor
    });
    var btnAdd = new Ext.Button({
        id: "btnAdd",
        iconCls: 'icon-add-custom',
        text: "���",
        handler: AddInfor
    });
    var btnEdit = new Ext.Button({
        id: "btnEdit",
        iconCls:'icon-filesave-custom',
        text: "�޸�",
        handler: EditInfor
    });


    return [EnableAirSelect,EnableHeatSelect,btnAdd, btnEdit, btnDelete]
}

//�������
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

//ȡ�ò�ѯ����
function GetSearchParam() {

    return { 'Arg1': selectBedId.split("||")[0], 'Arg2': selectBedId.split("||")[1] }
}

//�ܿ�������
function SelectInfor() {
    var EnableAirSelect = Ext.getCmp("EnableAirSelect");
    if (EnableAirSelect.checked) {
        var EnableAir="Y";
        Ext.Msg.alert("��ʾ","ѡ�к����ÿյ�����ȡ��");
    }else{
		var EnableAir="N";
		Ext.Msg.alert("��ʾ","ȡ��ѡ�к�ֹͣ�յ�����ȡ��"); 
	}
	var EnableHeatSelect = Ext.getCmp("EnableHeatSelect");
	if (EnableHeatSelect.checked) {
        var EnableHeat="Y";
        Ext.Msg.alert("��ʾ","ѡ�к�����ů������ȡ��");
    }else{
		var EnableHeat="N";
		Ext.Msg.alert("��ʾ","ȡ��ѡ�к�ֹͣů������ȡ��"); 
	}
	
	var Coninfo="EnableAir"+String.fromCharCode(1)+EnableAir+String.fromCharCode(2)+"EnableHeat"+String.fromCharCode(1)+EnableHeat
	var actionParams = { 'AcessType': 'ClassMethod', 'MethodSignature': 'web.DHCPACBedFeeSet:SaveConfig', 'Arg1': Coninfo };
    SubmitForm("frmBedFeeSet", actionParams, "grdFeeInfor");
	
	
}

//�����Ϣ
function AddInfor() {
    if (selectBedId != "") {
        action = "add";
        var DetailWindow = InitDetailWin();
        DetailWindow.show();
    }
    else
    {
      ShowMessage("I", "��ѡ��λ��");
    }
}

//�޸���Ϣ
function EditInfor() {
    var rows = Ext.getCmp("grdFeeInfor").getSelectionModel().getSelections();
    if (rows.length == 0 || rows.length > 1) {
        ShowMessage("I", "����ѡ��һ�����ݽ��в�����");
        return;
    }
    action = "update";
    //�򿪴���
    var DetailWindow = InitDetailWin();
    DetailWindow.show();
    //��ѡ�������Ϣ�󶨵�TextField��
    Ext.getCmp("pnlFee").getForm().findField("cmbFeeItmMast").setInitValueAndText(rows[0].get("BEDI_ARCIM_DR"),rows[0].get("ARCIM_Desc"));
    Ext.getCmp("pnlFee").getForm().findField("cmbFeeType").setInitValueAndText(rows[0].get("BEDI_FeeType"), rows[0].get("FT_Desc"));
    var startDate=tkMakeServerCall("websys.Conversions","DateLogicalToHtml",rows[0].get("startDate"));
    var endDate=tkMakeServerCall("websys.Conversions","DateLogicalToHtml",rows[0].get("endDate"));
    Ext.getCmp("pnlFee").getForm().findField("dtbxStartDate").setValue(startDate);
    Ext.getCmp("pnlFee").getForm().findField("dtbxEndDate").setValue(endDate);
}

//ɾ����Ϣ
function DeleteInfor() {
    var rows = Ext.getCmp("grdFeeInfor").getSelectionModel().getSelections();
    if (rows.length == 0) {
        ShowMessage("I", "������ѡ��һ�����ݣ�");
        return;
    }
    ShowConfirmMessage("ȷʵҪɾ����ѡ�ļ�¼��?", DeleteData);
}

//ɾ������
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

//�������鴰��
function InitDetailWin() {
    var pnlDetail = InitDetailPanel();
    var btnSave = new Ext.Button({
        id: "btnSave",
        iconCls:'icon-filesave-custom',
        text: "����",
        handler: SaveInfor
    });
    var btnCancel = new Ext.Button({
        id: "btnCancel",
        iconCls:'icon-undo-custom',
        text: "ȡ��",
        handler: CancelSave
    });

    //�޸ĺ����ʱ�ĵ�������
    return new Ext.Window({
        id: "winDetail",
        //�Ƿ�׼������ 
        collapsible: true,
        //�ܷ����
        maximizable: false,
        height: 220,
        width: 400,
        modal: true,
        closable: true,
        autoDestroy: true,
        layout: "form",
        plain: true,
        title: "������Ϣ",
        bodyStyle: "padding:5px;",
        buttonAlign: "center",
        items: pnlDetail,
        buttons: [btnSave, btnCancel]
    });
}

//�����������
function InitDetailPanel() {
    var controls = [
        { xtype: "FWBandbox",
            name:"Arg1",
            displayFields: ['ARCIM_Desc','ALIAS_Text'],
            displayField: 'ARCIM_Desc',
            valueField: 'ARCIM_RowId',
            queryParams: { 'AcessType': 'GridQuery', 'MethodSignature': 'web.DHCPACBedFeeSet:GetARCItmMastList' },
            storeExpression: [{ name: 'ARCIM_Desc', mapping: 'ARCIM_Desc', caption: '����', width: 200 }, { name: 'ARCIM_Price', mapping: 'ARCIM_Price', caption: '�۸�', width: 60 }, { name: 'ARCIM_Code', mapping: 'ARCIM_Code', caption: '����', width: 100},{ name: 'ARCIM_RowId', mapping: 'ARCIM_RowId', caption: 'ID' }],
            queryUrl: accessURL,
            editable: true,
            submitValue: false,
            height: 20,
            width: 250,
            gridWidth:350,
            fieldLabel: "����ҽ��",
            labelSeparator: '', // ȥ��laebl�е�ð��  update2020-2-12 ���ٷ�
            id: 'cmbFeeItmMast', allowBlank: false, blankText: '�������'
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
        fieldLabel: "��������",
        labelSeparator: '', // ȥ��laebl�е�ð��
        id: 'cmbFeeType', allowBlank: false, blankText: '�������'
        },
        { xtype: "FWDatebox", width: 250,fieldLabel: "��ʼ����", name: 'Arg3', format: SYSDateFormat, id: "dtbxStartDate", allowBlank: true, blankText: '�������',labelSeparator: '' },
        { xtype: "FWDatebox", width: 250,fieldLabel: "��������", name: 'Arg4', format: SYSDateFormat, id: "dtbxEndDate", allowBlank: true, blankText: '�������',labelSeparator: ''}];
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

//������Ϣ
function SaveInfor() {
    var startDate = Ext.getCmp("pnlFee").getForm().findField("dtbxStartDate").getValue();
    var endDate = Ext.getCmp("pnlFee").getForm().findField("dtbxEndDate").getValue();
    if(startDate != "" && endDate != "")
    {
        if(startDate >endDate)
        {
            ShowMessage("I", "��ʼ���ڲ��ܴ��ڽ������ڣ�");
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

//ȡ������
function CancelSave()
{
    Ext.getCmp("winDetail").close();
}
