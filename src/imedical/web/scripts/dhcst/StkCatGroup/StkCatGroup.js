// ����:�������
// ��д����:2012-05-8
//=========================����ȫ�ֱ���===============================
var StkCatGroupId = "";
//=========================����ȫ�ֱ���===============================
//=========================�����=====================================
var StruModeFlag=new Ext.grid.CheckColumn({
    header:'�Ƿ�һ�Զ�',
    align:'center',
    dataIndex:'StruModeFlag',
    width:80,
    sortable : true
});

function addNewRow() {
	var record = Ext.data.Record.create([
		{
			name : 'RowId',
			type : 'int'
		}, {
			name : 'Code',
			type : 'string'
		}, {
			name : 'Desc',
			type : 'string'
		}, {
			name : 'SetCode',
			type : 'string'
		},{
			name : 'StruModeFlag',
			type : 'string'
		}
	]);
					
	var NewRecord = new record({
		RowId : '',
		Code : '',
		Desc : '',
		SetCode : '',
		StruModeFlag:''
	});
					
	StkCatGroupGridDs.add(NewRecord);
	StkCatGroupGrid.startEditing(StkCatGroupGridDs.getCount() - 1, 1);
}

var SetStore = new Ext.data.SimpleStore({
	fields : ['RowId', 'Description'],
	data : [['GX', '��ҩ'], ['GZ', '�г�ҩ'], ['GC', '��ҩ']]
});

var SCGSet = new Ext.form.ComboBox({
	fieldLabel : '����',
	id : 'SCGSet',
	name : 'SCGSet',
	anchor : '90%',
	store : SetStore,
	valueField : 'RowId',
	displayField : 'Description',
	mode : 'local',
	allowBlank : true,
	triggerAction : 'all',
	selectOnFocus : true,
	forceSelection : true,	
	listeners:{
		specialKey:function(field, e) {
			if(e.getKey() == Ext.EventObject.ENTER){
				addNewRow();
			}
		}
	}
});

var StkCatGroupGrid="";
//��������Դ
var StkCatGroupGridUrl = 'dhcst.stkcatgroupaction.csp';
var StkCatGroupGridProxy= new Ext.data.HttpProxy({url:StkCatGroupGridUrl+'?actiontype=selectAll',method:'GET'});
var StkCatGroupGridDs = new Ext.data.Store({
	proxy:StkCatGroupGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Desc'},
		{name:'SetCode'},
		{name:'SetDesc'},
		{name:'StruModeFlag'}
	]),
    remoteSort:false
});



//ģ��
var StkCatGroupGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"����",
        dataIndex:'Code',
        width:150,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'codeField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						StkCatGroupGrid.startEditing(StkCatGroupGridDs.getCount() - 1, 2);
					}
				}
			}
        })
    },{
        header:"����",
        dataIndex:'Desc',
        width:150,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'descField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						StkCatGroupGrid.startEditing(StkCatGroupGridDs.getCount() - 1, 3);
					}
				}
			}
        })
    },{
        header:"����",
        dataIndex:'SetCode',
        width:150,
        align:'center',
        sortable:true,
        editor: new Ext.grid.GridEditor(SCGSet),
		renderer: Ext.util.Format.comboRenderer2(SCGSet,'SetCode','SetDesc')
	},StruModeFlag  
]);

//��ʼ��Ĭ��������
StkCatGroupGridCm.defaultSortable = true;

var addStkCatGroup = new Ext.Toolbar.Button({
	text:'�½�',
    tooltip:'�½�',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var saveStkCatGroup = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		
		if(HospId==""){
			Msg.info("warning","����ѡ��ҽԺ!");
			return false;
		}
		//��ȡ���е��¼�¼ 
		var mr=StkCatGroupGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){ 
			var code=mr[i].data["Code"].trim();
			var desc=mr[i].data["Desc"].trim();
			var setCode=mr[i].data["SetCode"].trim();
			var strumodeflag = mr[i].data["StruModeFlag"];
			if(code!="" && desc!=""){
				var dataRow = mr[i].data["RowId"]+"^"+code+"^"+desc+"^"+setCode+"^"+strumodeflag;
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
				url: StkCatGroupGridUrl+'?actiontype=save',
				params: {data:data},
				failure: function(result, request) {
					 mask.hide();
					Msg.info("error","������������!");
					StkCatGroupGridDs.commitChanges();
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success", "����ɹ�!");
						StkCatGroupGridDs.load();
					}else{
						Msg.info("error","��¼�ظ�"+jsonData.info);
						StkCatGroupGridDs.load();
					}
					StkCatGroupGridDs.commitChanges();
				},
				scope: this
			});
		}
    }
});

var deleteStkCatGroup = new Ext.Toolbar.Button({
	text:'ɾ��',
    tooltip:'ɾ��',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		if(HospId==""){
			Msg.info("warning","����ѡ��ҽԺ!");
			return false;
		}
		var cell = StkCatGroupGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning","��ѡ������!");
			return false;
		}else{
			var record = StkCatGroupGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
							Ext.Ajax.request({
								url:StkCatGroupGridUrl+'?actiontype=delete&rowid='+RowId,
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
										StkCatGroupGridDs.load();
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
				Msg.info("warning","��������,û��RowId!");
			}
		}
    }
});

//���
StkCatGroupGrid = new Ext.grid.EditorGridPanel({
	store:StkCatGroupGridDs,
	cm:StkCatGroupGridCm,
	trackMouseOver:true,
	height:770,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	plugins: [StruModeFlag],
    tbar:[addStkCatGroup,'-',saveStkCatGroup],		//,'-',deleteStkCatGroup
	clicksToEdit:1
});

StkCatGroupGridDs.load();
//=========================�����=====================================

//=========================���С��===================================
var IncScStkGrpStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcst.stkcatgroupaction.csp?actiontype=INCSCStkGrp&StkType=G&start=0&limit=200'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});
function addNewSCRow() {
	var scRecord = Ext.data.Record.create([
		{
			name : 'relationId',
			type : 'int'
		},{
			name : 'catId',
			type : 'int'
		}, {
			name : 'code',
			type : 'string'
		}, {
			name : 'desc',
			type : 'string'
		}
	]);
					
	var NewSCRecord = new scRecord({
		relationId:'',
		catId:'',
		code:'',
		desc:''
	});
		
	StkCatGridDs.add(NewSCRecord);
	StkCatGrid.startEditing(StkCatGridDs.getCount() - 1, 1);
}

var SCG = new Ext.form.ComboBox({
	fieldLabel : '����',
	id : 'SCG',
	name : 'SCG',
	anchor : '90%',
	width : 120,
	store : IncScStkGrpStore,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : false,
	triggerAction : 'all',
	emptyText : '����...',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	//pageSize : 10,
	listWidth : 250,
	valueNotFoundText : ''
});		
SCG.on('expand', function(combo) {
	SCG.store.removeAll();
	SCG.store.load();	
});				
function rendererSCG(value, p, r) {
	var combo = Ext.getCmp('SCGList');
	var index = SCGStoreList.find(combo.valueField, value);
	var record = SCGStoreList.getAt(index);
	var recordv = combo.findRecord(combo.valueField, value);
	if (value == '' || !recordv) {
		return value;
	}
	var displayText = "";
	if (record == null) {
		displayText = value;
	} else {
		displayText = recordv.get(combo.displayField);
	}
	return displayText;
}
		
var SCGStoreList = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcst.stkcatgroupaction.csp?actiontype=INCSCStkGrp&StkType=G&start=0&limit=999'
	}),
	reader : new Ext.data.JsonReader({
		totalProperty : "results",
		root : 'rows'
	}, ['Description', 'RowId'])
});
		
SCGStoreList.load();
var SCGList = new Ext.form.ComboBox({
	fieldLabel : '����',
	id : 'SCGList',
	name : 'SCGList',
	anchor : '90%',
	width : 120,
	store : SCGStoreList,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : false,
	triggerAction : 'all',
	emptyText : '����...',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 10,
	listWidth : 250,
	valueNotFoundText : ''
});

var StkCatGrid="";
//��������Դ
var StkCatGridUrl = 'dhcst.stkcatgroupaction.csp';
var StkCatGridProxy= new Ext.data.HttpProxy({url:StkCatGridUrl,method:'GET'});
var StkCatGridDs = new Ext.data.Store({
	proxy:StkCatGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [
		{name:'relationId'},
		{name:'catId'},
		{name:'code'},
		{name:'desc'}
	]),
    remoteSort:true
});



//ģ��
var StkCatGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),{
        header:"����",
        dataIndex:'desc',
        width:300,
        align:'left',
        sortable:true,
		sortable:true,renderer : rendererSCG,
		editor:new Ext.grid.GridEditor(SCG)
    }
]);

//��ʼ��Ĭ��������
StkCatGridCm.defaultSortable = true;

var addStkCat = new Ext.Toolbar.Button({
	text:'�½�',
    tooltip:'�½�',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		if(StkCatGroupId!=""){
			addNewSCRow();
		}else{
			Msg.info("warning","����ѡ��������!");
			return false;
		}
	}
});

var saveStkCat = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		//��ȡ���е��¼�¼ 
		var mr=StkCatGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			if(mr[i].data["desc"].trim()!=""){
				var dataRow = StkCatGroupId+"^"+mr[i].data["desc"].trim();
				if(data==""){
					data = dataRow;
				}else{
					data = data+xRowDelim()+dataRow;
				}
			}
		}
		if(data==""){
			Msg.info("error","û���޸Ļ����������!");
			return false;
		}else{
			var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
			Ext.Ajax.request({
				url: StkCatGridUrl+'?actiontype=addRelation',
				params: {data:data},
				failure: function(result, request) {
					 mask.hide();
					Msg.info("error","������������!");
					StkCatGridDs.commitChanges();
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success","��ӳɹ�!");
						StkCatGridDs.load({params:{StkCatGroupId:StkCatGroupId}});
					}else{
						Msg.info("error",jsonData.info+" ���ʧ��!");
						StkCatGridDs.load({params:{StkCatGroupId:StkCatGroupId}});
					}
					StkCatGridDs.commitChanges();
					IncScStkGrpStore.load();
					SCGStoreList.load();
				},
				scope: this
			});
		}
    }
});

var deleteStkCat = new Ext.Toolbar.Button({
	text:'ɾ��',
    tooltip:'ɾ��',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = StkCatGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning","��ѡ������!");
			return false;
		}else{
			var record = StkCatGrid.getStore().getAt(cell[0]);
			var RowId = record.get("relationId");
			if(RowId!=""){
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
							Ext.Ajax.request({
								url:StkCatGridUrl+'?actiontype=deleteRelation&rowid='+RowId,
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
										StkCatGridDs.load({params:{StkCatGroupId:StkCatGroupId}});
										IncScStkGrpStore.load();
										SCGStoreList.load();
									}else{
										Msg.info("error","ɾ��ʧ��!"+jsonData.info);
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				Msg.info("warning","��������,û��RowId!");
			}
		}
    }
});

//���
StkCatGrid = new Ext.grid.EditorGridPanel({
	store:StkCatGridDs,
	cm:StkCatGridCm,
	trackMouseOver:true,
	height:770,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
    tbar:[addStkCat,'-',saveStkCat,'-',deleteStkCat]
});
//=========================���С��===================================

//===========���������С���������=================================
StkCatGroupGrid.on('rowclick',function(grid,rowIndex,e){
	//���������ˢ�¿��С���¼
	var selectedRow = StkCatGroupGridDs.data.items[rowIndex];
	StkCatGroupId = selectedRow.data["RowId"];
	StkCatGridDs.proxy = new Ext.data.HttpProxy({url:StkCatGridUrl+'?actiontype=selectStkCatBySCG',method:'GET'});
	StkCatGridDs.load({params:{StkCatGroupId:StkCatGroupId}});
});

var HospPanel = InitHospCombo('DHC_StkCatGroup',function(combo, record, index){
	HospId = this.value; 
	StkCatGridDs.reload();
	StkCatGroupGridDs.reload();
	IncScStkGrpStore.reload();
	SCGStoreList.reload();
	
});
//===========���������С���������=================================

//===========ģ����ҳ��===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var StkCatGroupPanel = new Ext.Panel({
		id:"StkCatGroupPanel",
		title:'�������ά��',
		activeTab: 0,
		region:'center',
		region:'west',
		width:600,
		collapsible: true,
        split: true,
		minSize: 0,
        maxSize: 600,
		items:[StkCatGroupGrid]                                 
	});
	
	var StkCatPanel = new Ext.Panel({
		id:"StkCatPanel",
		title:'������',
		activeTab: 0,
		region:'center',
		width:1200,
		items:[StkCatGrid]                                 
	});

	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items:[HospPanel,StkCatGroupPanel,StkCatPanel],
		renderTo: 'mainPanel'
	});
	
});
//===========ģ����ҳ��===============================================