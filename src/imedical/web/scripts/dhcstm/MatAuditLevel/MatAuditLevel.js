// ����: ҵ��༶���ά��
// ��д����: 20190225

//��������Դ
var AuditLevelGridUrl = 'dhcstm.matauditlevelaction.csp';
var AuditLevelGridProxy= new Ext.data.HttpProxy({url:AuditLevelGridUrl+'?actiontype=QueryMatAuditLevel',method:'GET'});
var AuditLevelGridDs = new Ext.data.Store({
	proxy:AuditLevelGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows'
	}, ['RowId','ActiveFlag','Type','Level','SSGroupId','SSGroupDesc','LocdId','Locdesc','SSUserId','SSUserDesc'
	]),
	remoteSort:false
});
var ActiveFlag = new Ext.grid.CheckColumn({
	header:'�����־',
	dataIndex:'ActiveFlag',
	width:80,
	sortable:true
});
var TypeStore = new Ext.data.SimpleStore({
		fields : ['RowId', 'Description'],
		data : [['G', '���'], ['T', 'ת�Ƴ���'], ['K', 'ת�����'], ['R', '�˻�'], ['D', '����'], ['A', '����'], ['Basic', '������Ϣ']]
	});

var Type=new Ext.form.ComboBox({
			id:'Type',
			name:'Type',
			anchor : '90%',
			width : 120,
			store: TypeStore,
			mode : 'local',
			valueField : 'RowId',
			displayField : 'Description',
			valueNotFoundText : ''
});
var LevelStore = new Ext.data.SimpleStore({
		fields : ['RowId', 'Description'],
		data : [['0', '0'], ['1', '1'], ['2', '2'], ['3', '3'], ['4', '4']]
	});

var Level=new Ext.form.ComboBox({
			id:'Level',
			name:'Level',
			anchor : '90%',
			width : 120,
			store: LevelStore,
			mode : 'local',
			valueField : 'RowId',
			displayField : 'Description',
			valueNotFoundText : ''
});

// ��ȫ��
var groupComboStore = new Ext.data.JsonStore({
		autoDestroy: true,
		url: 'dhcstm.orgutil.csp?actiontype=GetGroup',
		storeId: 'groupComboStore',
		root: 'rows',
		totalProperty: "results",
		fields: ['RowId', 'Description']
	});
var DMALSSGroup = new Ext.ux.ComboBox({
	fieldLabel: '��ȫ��',
	id: 'DMALSSGroup',
	name: 'DMALSSGroup',
	width: 50,
	store: groupComboStore,
	filterName: 'FilterDesc',
	valueField: 'RowId',
	displayField: 'Description'
});
//����
var DMALLoc = new Ext.ux.ComboBox({
	fieldLabel: '����',
	id: 'DMALLoc',
	name: 'DMALLoc',
	width: 50,
	store: DeptLocStore,
	valueField: 'RowId',
	displayField: 'Description',
	filterName: 'locDesc',
	listeners:{
		select:function()
		{  
		   var cell = AuditLevelGrid.getSelectionModel().getSelectedCell(); 
		   var rowData = AuditLevelGrid.getStore().getAt(cell[0]);
		   rowData.set("SSUserId","");
		   rowData.set("SSUserDesc","");
		} 
	}  
	
}); 
DMALLoc.on('beforequery', function(e) {
	var ctlocdesc=Ext.getCmp("DMALLoc").getRawValue();
	DeptLocStore.removeAll();
	DeptLocStore.setBaseParam('locDesc',ctlocdesc);
	DeptLocStore.load({});	
}); 
//�����
var DMALSSUser = new Ext.ux.ComboBox({
	fieldLabel: '�����',
	id: 'DMALSSUser',
	name: 'DMALSSUser',
	width: 50,
	store: DeptUserStore,
	valueField: 'RowId',
	displayField: 'Description',
	filterName: 'SSUserName'
});
DMALSSUser.on('beforequery', function(e) {
	var ctlocid=Ext.getCmp("DMALLoc").getValue();
	var userdesc=Ext.getCmp("DMALSSUser").getRawValue();
	DeptUserStore.removeAll();
	DeptUserStore.setBaseParam('locId',ctlocid);
	DeptUserStore.setBaseParam('name',userdesc);
	DeptUserStore.load({});	
}); 
//ģ��
var AuditLevelGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	ActiveFlag,
	{
		header:"ҵ������",
		dataIndex:'Type',
		width:100,
		align:'left',
		sortable:true,
		renderer:Ext.util.Format.comboRenderer(Type),
		editor:new Ext.grid.GridEditor(Type)
	},{
		header:"��˼���",
		dataIndex:'Level',
		width:100,
		align:'left',
		sortable:true,
		renderer:Ext.util.Format.comboRenderer(Level),
		editor:new Ext.grid.GridEditor(Level)
	}, {
		header: "��ȫ��",
		dataIndex: "SSGroupId",
		width: 150,
		sortable:true,
		renderer :Ext.util.Format.comboRenderer2(DMALSSGroup,"SSGroupId","SSGroupDesc"),
		editor: DMALSSGroup
	}, {
		header: "����",
		dataIndex: "LocdId",
		width: 150,
		sortable:true,
		renderer :Ext.util.Format.comboRenderer2(DMALLoc,"LocdId","Locdesc"),
		editor: DMALLoc
	}, {
		header: "�����",
		dataIndex: "SSUserId",
		width: 150,
		sortable:true,
		renderer :Ext.util.Format.comboRenderer2(DMALSSUser,"SSUserId","SSUserDesc"),
		editor: DMALSSUser
	}
]);

// ��ѯ��ⵥ��ť
var SearchBT = new Ext.Toolbar.Button({
	id : "SearchBT",
	text : '��ѯ',
	width : 70,
	height : 30,
	iconCls : 'page_find',
	handler : function() {
		AuditLevelGridDs.load({
				params: {
					start: 0,
					limit: 9999,
					sort: 'RowId',
					dir: 'desc'
				}
			});
	}
});

var addAuditLevel = new Ext.Toolbar.Button({
	text:'�½�',
	tooltip:'�½�',
	iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

function addNewRow() {
	var NewRecord = CreateRecordInstance(AuditLevelGridDs.fields);
	AuditLevelGridDs.add(NewRecord);
	AuditLevelGrid.startEditing(AuditLevelGridDs.getCount() - 1, 1);
}

var saveAuditLevel = new Ext.Toolbar.Button({
	text:'����',
	tooltip:'����',
	iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		//��ȡ���е��¼�¼
		var mr=AuditLevelGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var RowId=mr[i].data["RowId"].trim();
			var Level=mr[i].data["Level"].trim();
			var ActiveFlag=mr[i].data["ActiveFlag"].trim();
			var Type=mr[i].data["Type"].trim();
			var SSGroupId=mr[i].data["SSGroupId"].trim();
			var LocdId=mr[i].data["LocdId"].trim();
			var SSUserId=mr[i].data["SSUserId"].trim();
			if((Type!="" && Level!="")&&((SSGroupId!="")||(LocdId!="")||(SSUserId!=""))){
				var dataRow = RowId+"^"+Type+"^"+Level+"^"+ActiveFlag+"^"+SSGroupId+"^"+LocdId+"^"+SSUserId;
				if(data==""){
					data = dataRow;
				}else{
					data = data+xRowDelim()+dataRow;
				}
			}
		}

		if(data==""){
			Msg.info("warning","û���޸Ļ����������!");
			return false;
		}else{
			var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
			Ext.Ajax.request({
				url: AuditLevelGridUrl+'?actiontype=SaveMatAuditLevel',
				params: {dataStr:data},
				failure: function(result, request) {
					 mask.hide();
					Msg.info("error","������������!");
					AuditLevelGridDs.commitChanges();
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success", "����ɹ�!");
						SearchBT.handler();
					}else{
						Msg.info("error",jsonData.info);
						SearchBT.handler();
					}
					AuditLevelGridDs.commitChanges();
				},
				scope: this
			});
		}
	}
});

var deleteAuditLevel = new Ext.Toolbar.Button({
	text:'ɾ��',
	tooltip:'ɾ��',
	iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = AuditLevelGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning","��ѡ������!");
			return false;
		}else{
			var record = AuditLevelGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
							Ext.Ajax.request({
								url:AuditLevelGridUrl+'?actiontype=delete&rowid='+RowId,
								waitMsg:'ɾ����...',
								failure: function(result, request) {
									 mask.hide();
									Msg.info("error","������������!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									 mask.hide();
									if (jsonData.success=='true') {
										Msg.info("success","ɾ���ɹ�!");
										StkCatGrid.store.removeAll();
										StkCatGrid.getView().refresh();
										AuditLevelGridDs.load();
									}else{
										if(jsonData.info==-1){
											Msg.info("error","������ά���˿����಻��ɾ��!");
										}else{
											Msg.info("error","ɾ��ʧ��!");
										}
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				AuditLevelGridDs.remove(record);
				AuditLevelGrid.getView().refresh();
			}
		}
	}
});

//���
var AuditLevelGrid = new Ext.grid.EditorGridPanel({
	title:'��˵ȼ�ά��',
	region:'center',
	height:600,
	collapsible: true,
	split: true,
	minSize: 0,
	maxSize: 600,
	id : 'AuditLevelGrid',
	store:AuditLevelGridDs,
	cm:AuditLevelGridCm,
	trackMouseOver:true,
	plugins:[ActiveFlag],
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	tbar:[SearchBT,'-',addAuditLevel,'-',saveAuditLevel]

});

//===========ģ����ҳ��===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var mainPanel = new Ext.ux.Viewport({
		layout: 'border',
		items:[AuditLevelGrid],
		renderTo: 'mainPanel'
	});
	SearchBT.handler()
});
//===========ģ����ҳ��===============================================