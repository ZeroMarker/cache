
//BPM中部分固定值
var G_BPM_INITIATOR = 'initiator';
var G_BPM_DRAFTER = '起草人';

var ElementAuthorUrl = 'dhcstm.elementauthoraction.csp';
var G_FormPanelId, G_BPM_Model;
var G_ConfigSaveFor, G_ConfigReference;
/**
 * 表单授权窗口
 * @param {表单id} FormPanelId
 * @param {BPM模型id} BPMModel
 */
function ElementAuthorWin(FormPanelId, BPMModel){
	G_FormPanelId = FormPanelId, G_BPM_Model = BPMModel;
	
	if(!CommParObj || CommParObj.BPMFormConfig != 'Y'){
		Msg.info('warning', '对不起, 您没有该配置权限!');
		return false;
	}
	
	if(Ext.isEmpty(G_BPM_Model)){
		Msg.info('error', 'BPM模型参数错误');
		return false;
	}
	var PageInfo = App_MenuCspName + '^' + G_FormPanelId;
	
	var ElementInfoSaveBtn = new Ext.ux.Button({
		text : '保存',
		iconCls : 'page_save',
		handler : function(){
			SaveElementRoleInfo();
		}
	});
	
	function SaveElementRoleInfo(){
		var BPMRole = Ext.getCmp('ElementInfoCombo').getValue();
		if(Ext.isEmpty(BPMRole)){
			Msg.info('warning', '请选择BPM模型角色!');
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
			Msg.info('warning', '没有需要保存的明细!');
			return false;
		}
		var mask = ShowLoadMask(ElAuthorWin.body, '处理中请稍候...');
		Ext.Ajax.request({
			url: ElementAuthorUrl + '?actiontype=SaveAuthorData',
			params: {PageInfo : PageInfo, ConfigInfo: ConfigInfo, ListData : ListData},
			failure: function(result, request) {
				mask.hide();
				Msg.info('error', '请检查网络连接!');
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success=='true') {
					Msg.info('success', '关联成功!');
					ElementInfoGrid.getStore().reload();
				}else{
					Msg.info('error', '失败:' +  jsonData.info);
				}
				mask.hide();
			},
			scope : this
		});
	}
	
	var ElementInfoCombo = new Ext.ux.ComboBox({
		id : 'ElementInfoCombo',
		fieldLabel : 'BPM模型角色',
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
			title : 'BPM角色',
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
		header : '是否可用',
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
			{header : '控件Id', dataIndex : 'FieldId', align : 'left', width : 120},
			{header : '控件名称', dataIndex : 'FieldLabel', align : 'left', width : 120},
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
		title : '物资信息',
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
 * 根据FormPanel的id获取表单上的控件信息字符串
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
 * 初始化表单数据,记录到数据库
 * @param {} FormPanelId
 * @return {Boolean} true:成功, false:失败
 */
function InitialFormData(FormPanelId){
	var FieldStr = GetFieldStr(FormPanelId);
	var PageInfo = App_MenuCspName + '^' + FormPanelId;
	var Ret = tkMakeServerCall('web.DHCSTM.DHCPageElementAuthor', 'Initial', FieldStr, PageInfo);
	if(Ret != ''){
		Msg.info('error', '初始化数据失败!');
		return false;
	}
	return true;
}

/**
 * 根据表单id,BPM模型角色, 重置界面控件是否可编辑
 * @param {表单id} FormPanelId
 * @param {模型角色} BPMModelRole
 */
function ReSetFormElement(FormPanelId, BPMModelRole){
	//如果是initator, 取"起草人"
	if(BPMModelRole == G_BPM_INITIATOR){
		var BPMCode = Ext.getCmp(FormPanelId).BPMCode;
		//获取名为"起草人"的角色
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
	//1.禁用所有控件
	Ext.getCmp(FormPanelId).getForm().items.each(function(f){ 
		try{
			//使用setDisabled后, 界面不能使用form.submit传值
			f.setDisabled(true);
		}catch(e){
			return;
		}
	});
	//2.获取可用json,按权限放开
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
				Msg.info('error', '授权数据获取失败!');
			}
		},
		scope : this
	});
}