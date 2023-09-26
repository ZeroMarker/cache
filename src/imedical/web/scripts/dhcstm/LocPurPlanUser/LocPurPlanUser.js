// ����:���Ҳɹ���Աά��
// ��д����:2015-05-23
//lihui

var groupId = session['LOGON.GROUPID'];
var CTLocId = "";

//=========================������Ϣ=================================
//��ȫ��
var groupComboStore = new Ext.data.JsonStore({
    autoDestroy: true,
    url: 'dhcstm.orgutil.csp?actiontype=QueryGroup',
    storeId: 'groupComboStore',
    root: 'rows',
    totalProperty : "results",
    fields: ['RowId', 'Description']
});

var groupCombo = new Ext.ux.ComboBox({
	fieldLabel : '��ȫ��',
	id : 'groupCombo',
	name : 'groupCombo',
	store : groupComboStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'FilterDesc',
	listeners : {
		"select":function() {
			CTLocGridDs.load({params:{start:0,limit:CTLocPagingToolbar.pageSize,sort:'RowId',dir:'desc'}});
		}
	}
});

//���Ҵ���
var locCode = new Ext.form.TextField({
	id:'locCode',
	allowBlank:true,
	anchor:'90%',
	width:70
});
//��������
var locName = new Ext.form.TextField({
	id:'locName',
	allowBlank:true,
	anchor:'90%',
	width:70
});

var CTLocGrid="";
//��������Դ
var gridUrl = 'dhcstm.locpurplanuseraction.csp';
var CTLocGridProxy= new Ext.data.HttpProxy({url:gridUrl+'?actiontype=QueryLoc',method:'POST'});
var CTLocGridDs = new Ext.data.Store({
	proxy:CTLocGridProxy,
	reader:new Ext.data.JsonReader({
		totalProperty:'results',
		root:'rows'
	}, [
		{name:'Rowid'},
		{name:'Code'},
		{name:'Desc'}
	]),
	remoteSort:false,
	listeners : {
		beforeload : function(store,options){
			store.removeAll();
			var strFilter = Ext.getCmp('locCode').getValue()+"^"+Ext.getCmp('locName').getValue();
			var selectGroup = Ext.getCmp("groupCombo").getValue();
			if(selectGroup == ""){
				selectGroup=groupId
			}
			store.setBaseParam('strFilter',strFilter);
			store.setBaseParam('groupId',selectGroup);
		}
	}
});

//ģ��
var CTLocGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header:"����",
		dataIndex:'Code',
		width:150,
		align:'left',
		sortable:true
	},{
		header:"����",
		dataIndex:'Desc',
		width:200,
		align:'left',
		sortable:true
	}
]);

var queryCTLoc = new Ext.Toolbar.Button({
	text:'��ѯ',
	tooltip:'��ѯ',
	iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		CTLocGridDs.load({params:{start:0,limit:CTLocPagingToolbar.pageSize,sort:'Rowid',dir:'desc'}});
	}
});

var CTLocPagingToolbar = new Ext.PagingToolbar({
	store:CTLocGridDs,
	pageSize:30,
	displayInfo:true,
	displayMsg:'�� {0} ���� {1} ����һ�� {2} ��'
});

//���
CTLocGrid = new Ext.grid.GridPanel({
	store:CTLocGridDs,
	cm:CTLocGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm:new Ext.grid.RowSelectionModel({}),
	loadMask:true,
	tbar:['��ȫ��:',groupCombo,'���Ҵ���:',locCode,'��������:',locName,'-',queryCTLoc],
	bbar:CTLocPagingToolbar,
	listeners : {
		'rowclick' : function(grid,rowIndex,e){
			var selectedRow = CTLocGridDs.data.items[rowIndex];
			CTLocId = selectedRow.data["Rowid"];
			LocPurUserGridDs.load({params:{start:0,limit:LocPurUserPagingbar.pageSize,sort:'Rowid',dir:'desc'}});
			RefreshLocUser();
		}
	}
});

function RefreshLocUser(){
	UStore.load();
	
}
//=========================������Ϣend==========================

//=========================��Աά��=============================

var UStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url:'dhcstm.orgutil.csp?actiontype=StkLocUserCatGrp'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});
	
var UCG = new Ext.form.ComboBox({
	fieldLabel : '����',
	id : 'UCG',
	name : 'UCG',
	anchor : '90%',
	width : 120,
	store : UStore,
	valueField : 'RowId',
	displayField : 'Description',
	//allowBlank : false,
	triggerAction : 'all',
	emptyText : '����...',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 10,
	listWidth : 250,
	valueNotFoundText : ''
});		
	
UCG.on('beforequery', function(e) {
	UStore.removeAll();
	UStore.setBaseParam('name',Ext.getCmp('UCG').getRawValue());
	UStore.setBaseParam('locId',CTLocId);
	var pageSize=Ext.getCmp("UCG").pageSize;
	UStore.load({
		params:{start:0,limit:pageSize},
		callback : function(r,options, success){
					var tmprecode=new  Ext.data.Record()
					for(var i=0; i<LocPurUserGridDs.getCount()-1;i++ ){
						var name=LocPurUserGridDs.getAt(i).get("Name");
						UStore.removeAt(UStore.find("Description",name));
					}
				}
	});
});

//��������Դ
var LocPurUserGridProxy = new Ext.data.HttpProxy({url:gridUrl+'?actiontype=QueryUser',method:'GET'});
var LocPurUserGridDs = new Ext.data.Store({
	proxy:LocPurUserGridProxy,
	reader:new Ext.data.JsonReader({
		totalProperty:'results',
		root:'rows'
	}, [
		{name:'Rowid'},
		{name:'UserId'},
		{name:'Code'},
		{name:'Name'},
		{name:'Default'},
		{name:'Active'}
	]),
	pruneModifiedRecords:true,
	remoteSort:false,
	listeners : {
		beforeload : function(store,options){
			store.removeAll();
			store.setBaseParam('ctlocid',CTLocId);
			
		}
	}
});

var DefaultField = new Ext.grid.CheckColumn({
	header:'�Ƿ�Ĭ��',
	dataIndex:'Default',
	width:100,
	sortable:true
});

var ActiveField = new Ext.grid.CheckColumn({
	header:'�Ƿ���Ч',
	dataIndex:'Active',
	width:100,
	sortable:true
});

//ģ��
var LocPurUserGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
		header:"��ԱID",
		dataIndex:'Code',
		width:200,
		align:'left',
		sortable:true
	},{
		header:"����",
		dataIndex:'UserId',
		width:200,
		align:'left',
		sortable:true,
		renderer:Ext.util.Format.comboRenderer2(UCG,"UserId","Name"),
		editor:new Ext.grid.GridEditor(UCG)
	},DefaultField,ActiveField
]);

var addLocPurUser = new Ext.Toolbar.Button({
	text:'�½�',
	tooltip:'�½�',
	iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		if(CTLocId!=""){
			addRow();
		}else{
			Msg.info("error", "��ѡ�����!");
		}
		
	}
});

function addRow() {
	var rec = CreateRecordInstance(LocPurUserGridDs.fields,{Default:'Y',Active:'Y'});
	LocPurUserGridDs.add(rec);
	var col = GetColIndex(LocPurUserGrid,'UserId');
	LocPurUserGrid.startEditing(LocPurUserGridDs.getCount() - 1, col);
}

var saveLocPurUser = new Ext.Toolbar.Button({
	text:'����',
	tooltip:'����',
	width : 70,
	height : 30,
	iconCls:'page_save',
	handler:function(){
		//��ȡ���е��¼�¼
		var mr=LocPurUserGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var RowId = mr[i].data["Rowid"];
			var userId = mr[i].data["UserId"];
			if(userId==""){
				continue;
			}
			var active = mr[i].data["Active"];
			var def = mr[i].data["Default"];
			var name = mr[i].data["Name"];
			var dataRow = RowId+"^"+userId+"^"+active+"^"+def+"^"+name;
			if(data==""){
				data = dataRow;
			}else{
				data = data+xRowDelim()+dataRow;
			}
		}
		if(data==""){
			Msg.info("error","û����Ҫ���������!");
			return false;
		}else{
			Ext.Ajax.request({
				url: gridUrl+'?actiontype=SaveUser',
				params: {data:data,ctlocid:CTLocId},
				failure: function(result, request) {
					Msg.info("error", "������������!");
				},
				success: function(result, request) {
					data="";
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success", "����ɹ�!");
						LocPurUserGridDs.reload();
					}else{
						if(jsonData.info==-1){
							Msg.info("error","��Ա�ظ�!");
						}else{
							Msg.info("error", "����ʧ��"+jsonData.info);
						}
					}
				},
				scope: this
			});
		}
    }
});

var deleteLocPurUser = new Ext.Toolbar.Button({
	text:'ɾ��',
	tooltip:'ɾ��',
	iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = LocPurUserGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error","��ѡ������!");
			return false;
		}else{
			var record = LocPurUserGrid.getStore().getAt(cell[0]);
			var RowId = record.get("Rowid");
			if(RowId!=""){
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
					function(btn) {
						if(btn == 'yes'){
							Ext.Ajax.request({
								url:gridUrl+'?actiontype=deleteUser&rowid='+RowId,
								waitMsg:'ɾ����...',
								failure: function(result, request) {
									Msg.info("error","������������!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true') {
										Msg.info("success","ɾ���ɹ�!");
										LocPurUserGridDs.reload();
									}else{
										Msg.info("error","ɾ��ʧ��!");
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				Msg.info("error","�����д�!");
			}
		}
	}
});

var LocPurUserPagingbar = new Ext.PagingToolbar({
	store:LocPurUserGridDs,
	pageSize:30,
	displayInfo:true,
	displayMsg:'�� {0} ���� {1}����һ�� {2} ��'
});

//���
var LocPurUserGrid = new Ext.grid.EditorGridPanel({
	store:LocPurUserGridDs,
	cm:LocPurUserGridCm,
	trackMouseOver:true,
	height:370,
	plugins:[DefaultField,ActiveField],
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	tbar:[addLocPurUser,'-',saveLocPurUser,'-',deleteLocPurUser],
	bbar:LocPurUserPagingbar,
	listeners : {
		beforeedit : function(e){
			if(e.field=='UserId' && e.record.get('Rowid')!=''){
				e.cancel = true;
			}
		}
	}
});
//=========================��Աά��end=============================

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var CTLocPanel = new Ext.Panel({
		deferredRender : true,
		title:'������Ϣ',
		activeTab: 0,
		region:'north',
		collapsible: true,
		split: true,
		height:300,
		layout:'fit',
		items:[CTLocGrid]
	});
	
	var StkLocUserCatGroupPanel = new Ext.Panel({
		deferredRender : true,
		title:'��Աά��',
		activeTab: 0,
		region:'center',
		height:300,
		layout:'fit',
		split:true,
		collapsible:true,
		items:[LocPurUserGrid]                                 
	});
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		collapsible:true,
		split: true,
		items:[CTLocPanel,StkLocUserCatGroupPanel],
		renderTo:'mainPanel'
	});
	queryCTLoc.handler();
	//��ȡ��½ֵ
	SetLogGroup(groupCombo.getStore(), "groupCombo");
});
