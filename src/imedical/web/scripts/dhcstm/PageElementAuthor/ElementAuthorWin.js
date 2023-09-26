
//BPM�в��̶ֹ�ֵ
var G_BPM_INITIATOR = 'initiator';
var G_BPM_DRAFTER = '�����';

var ElementAuthorUrl = 'dhcstm.elementauthoraction.csp';
var G_FormPanelId, G_BPM_Model;
var G_ConfigSaveFor, G_ConfigReference;
/**
 * ����Ȩ����
 * @param {��id} FormPanelId
 * @param {BPMģ��id} BPMModel
 */
function ElementAuthorWin(FormPanelId, BPMModel){
	G_FormPanelId = FormPanelId, G_BPM_Model = BPMModel;
	
	if(!CommParObj || CommParObj.BPMFormConfig != 'Y'){
		Msg.info('warning', '�Բ���, ��û�и�����Ȩ��!');
		return false;
	}
	
	if(Ext.isEmpty(G_BPM_Model)){
		Msg.info('error', 'BPMģ�Ͳ�������');
		return false;
	}
	var PageInfo = App_MenuCspName + '^' + G_FormPanelId;
	
	var ElementInfoSaveBtn = new Ext.ux.Button({
		text : '����',
		iconCls : 'page_save',
		handler : function(){
			SaveElementRoleInfo();
		}
	});
	
	function SaveElementRoleInfo(){
		var BPMRole = Ext.getCmp('ElementInfoCombo').getValue();
		if(Ext.isEmpty(BPMRole)){
			Msg.info('warning', '��ѡ��BPMģ�ͽ�ɫ!');
			return false;
		}
		var ConfigInfo = BPMRole;
		
		if(ElementInfoGrid.activeEditor != null){
			ElementInfoGrid.activeEditor.compleEdit();
		}
		var mr = ElementInfoGrid.getStore().getModifiedRecords();
		var ListData = '';
		for(var i = 0; i < mr.length; i++){
			var FieldId = mr[i].get('FieldId');
			var FieldLabel = mr[i].get('FieldLabel');
			var FieldEnable = mr[i].get('FieldEnable');
			var RowData = FieldId + '^' + FieldLabel + '^' + FieldEnable;
			if(ListData == ''){
				ListData = RowData;
			}else{
				ListData = ListData + xRowDelim() + RowData;
			}
		}
		if(Ext.isEmpty(ListData)){
			Msg.info('warning', 'û����Ҫ�������ϸ!');
			return false;
		}
		var mask = ShowLoadMask(ElAuthorWin.body, '���������Ժ�...');
		Ext.Ajax.request({
			url: ElementAuthorUrl + '?actiontype=SaveAuthorData',
			params: {PageInfo : PageInfo, ConfigInfo: ConfigInfo, ListData : ListData},
			failure: function(result, request) {
				mask.hide();
				Msg.info('error', '������������!');
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success=='true') {
					Msg.info('success', '�����ɹ�!');
					ElementInfoGrid.getStore().reload();
				}else{
					Msg.info('error', 'ʧ��:' +  jsonData.info);
				}
				mask.hide();
			},
			scope : this
		});
	}
	
	var ElementInfoCombo = new Ext.ux.ComboBox({
		id : 'ElementInfoCombo',
		fieldLabel : 'BPMģ�ͽ�ɫ',
		store : new Ext.data.JsonStore({
			url : ElementAuthorUrl + '?actiontype=GetBPMModelRole',
			totalProperty : 'total',
			root : 'listData',
			fields : ['code','roleName']
		}),
		valueField : 'code',
		displayField : 'roleName',
		valueParams : {'BPMModel' : G_BPM_Model},
		listeners : {
			select : function(combo, record, index){
				var BPMRole = record.get(combo.valueField);
				var ConfigInfo = BPMRole;
				ElementInfoGrid.getStore().setBaseParam('ConfigInfo', ConfigInfo);
				ElementInfoGrid.getStore().load();
			}
		}
	});
	
	var ElementInfoPanel = new Ext.ux.FormPanel({
		tbar : [ElementInfoSaveBtn],
		items : [{
			xtype : 'fieldset',
			title : 'BPM��ɫ',
			layout : 'column',
			defaults : {layout : 'form'},
			items : [{
					columnWidth : 0.4,
					labelWidth : 100,
					items : [ElementInfoCombo]
				}
			]
		}]
	});
	
	
	var FieldEnablePlugin = new Ext.grid.CheckColumn({
		header : '�Ƿ����',
		dataIndex : 'FieldEnable',
		align : 'left',
		width : 80
	});
	
	var ElementInfoGrid = new Ext.grid.EditorGridPanel({
		region : 'center',
		plugins : [FieldEnablePlugin],
		store : new Ext.data.JsonStore({
			autoLoad : true,
			url : ElementAuthorUrl + '?actiontype=GetAuthorDetail',
			totalProperty : 'results',
			root : 'rows',
			fields : ['RowId','FieldId','FieldLabel','FieldEnable'],
			pruneModifiedRecords : true,
			baseParams : {PageInfo : PageInfo}
		}),
		cm : new Ext.grid.ColumnModel([
			{header : 'RowId', dataIndex : 'RowId', align : 'left', width : 120, hidden : true},
			{header : '�ؼ�Id', dataIndex : 'FieldId', align : 'left', width : 120},
			{header : '�ؼ�����', dataIndex : 'FieldLabel', align : 'left', width : 120},
			FieldEnablePlugin
		]),
		viewConfig: {
			forceFit: true
		},
		listeners : {
			dblclick : function(e){
				this.ownerCt.hide();
			}
		}
	});
	
	var ElAuthorWin = new Ext.ux.Window({
		title : '������Ϣ',
		width : gWinWidth,
		height : gWinHeight,
		maximizable : true,
		modal : true,
		layout : 'border',
		items : [ElementInfoPanel, ElementInfoGrid],
		listeners : {
			beforeshow : function(win){
				return InitialFormData(G_FormPanelId);
			},
			show : function(){
				var ConfigInfo = 'SITE';
				ElementInfoGrid.getStore().setBaseParam('ConfigInfo', ConfigInfo);
				ElementInfoGrid.getStore().load();
			}
		}
	});
	ElAuthorWin.show();
}

/**
 * ����FormPanel��id��ȡ���ϵĿؼ���Ϣ�ַ���
 * @param {} FormPanelId
 * @return {}
 */
function GetFieldStr(FormPanelId){
	var Index = 0;
	var FieldStr = '';
	Ext.getCmp(FormPanelId).getForm().items.each(function(f){ 
		Index++;
		var FieldInfo = f.id + '^' + (f.fieldLabel||f.boxLabel) + '^' + Index;
		if(FieldStr == ''){
			FieldStr = FieldInfo;
		}else{
			FieldStr = FieldStr + RowDelim + FieldInfo;
		}
	});
	return FieldStr;
}

/**
 * ��ʼ��������,��¼�����ݿ�
 * @param {} FormPanelId
 * @return {Boolean} true:�ɹ�, false:ʧ��
 */
function InitialFormData(FormPanelId){
	var FieldStr = GetFieldStr(FormPanelId);
	var PageInfo = App_MenuCspName + '^' + FormPanelId;
	var Ret = tkMakeServerCall('web.DHCSTM.DHCPageElementAuthor', 'Initial', FieldStr, PageInfo);
	if(Ret != ''){
		Msg.info('error', '��ʼ������ʧ��!');
		return false;
	}
	return true;
}

/**
 * ���ݱ�id,BPMģ�ͽ�ɫ, ���ý���ؼ��Ƿ�ɱ༭
 * @param {��id} FormPanelId
 * @param {ģ�ͽ�ɫ} BPMModelRole
 */
function ReSetFormElement(FormPanelId, BPMModelRole){
	//�����initator, ȡ"�����"
	if(BPMModelRole == G_BPM_INITIATOR){
		var BPMCode = Ext.getCmp(FormPanelId).BPMCode;
		//��ȡ��Ϊ"�����"�Ľ�ɫ
		var RolesInfo = tkMakeServerCall('web.DHCSTM.DHCPageElementAuthor', 'GetBPMModelRole', 0, -1, BPMCode);
		var RolesArr = Ext.decode(RolesInfo);
		if(!Ext.isEmpty(RolesArr) && !Ext.isEmpty(RolesArr.listData)){
			for(var i = 0, Len = RolesArr.listData.length; i < Len; i++){
				var RoleDetail = RolesArr.listData[i];
				if(RoleDetail.roleName == G_BPM_DRAFTER){
					BPMModelRole = RoleDetail.code;
					break;
				}
			}
		}
	}
	//1.�������пؼ�
	Ext.getCmp(FormPanelId).getForm().items.each(function(f){ 
		try{
			//ʹ��setDisabled��, ���治��ʹ��form.submit��ֵ
			f.setDisabled(true);
		}catch(e){
			return;
		}
	});
	//2.��ȡ����json,��Ȩ�޷ſ�
	var PageInfo = App_MenuCspName + '^' + FormPanelId;
	var ConfigInfo = BPMModelRole;
	Ext.Ajax.request({
		url: ElementAuthorUrl + '?actiontype=GetAuthorDetail',
		params: {PageInfo : PageInfo, ConfigInfo: ConfigInfo},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			try{
				for(var i = 0, Len = jsonData.rows.length; i < Len; i++){
					var FieldId = jsonData.rows[i].FieldId;
					var FieldEnable = jsonData.rows[i].FieldEnable;
					FieldEnable = FieldEnable == 'Y'? false : true;
					Ext.getCmp(FieldId).setDisabled(FieldEnable);
				}
			}catch(e){
				Msg.info('error', '��Ȩ���ݻ�ȡʧ��!');
			}
		},
		scope : this
	});
}