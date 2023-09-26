// ����:�������
// ��д����:2012-05-8
//=========================����ȫ�ֱ���===============================
var StkCatGroupId = "";
//=========================����ȫ�ֱ���===============================
//=========================�����=====================================
//��������Դ
var StkCatGroupGridUrl = 'dhcstm.stkcatgroupaction.csp';
var StkCatGroupGridProxy= new Ext.data.HttpProxy({url:StkCatGroupGridUrl+'?actiontype=selectAll',method:'GET'});
var StkCatGroupGridDs = new Ext.data.Store({
	proxy:StkCatGroupGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows'
	}, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Desc'},
		{name:'SpReq'},
		{name:'SCGSet'}
	]),
	remoteSort:false
});
var SpReq = new Ext.grid.CheckColumn({
	header:'�ۼ۱�����',
	dataIndex:'SpReq',
	width:80,
	sortable:true
});
var SCGSetStore = new Ext.data.SimpleStore({
		fields : ['RowId', 'Description'],
		data : [['MM', 'ҽ�ò���'], ['MO', '���ڲ���'], ['MR', '�Լ�'], ['MF', '�̶��ʲ�']]
	});

var SCGSet=new Ext.form.ComboBox({
			id:'SCGSet',
			name:'SCGSet',
			anchor : '90%',
			width : 120,
			store: SCGSetStore,
			mode : 'local',
			valueField : 'RowId',
			displayField : 'Description',
			valueNotFoundText : ''
});

//ģ��
var StkCatGroupGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header:"����",
		dataIndex:'Code',
		width:100,
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
						addNewRow();
					}
				}
			}
		})
	},SpReq,
	{
		header:"����",
		dataIndex:'SCGSet',
		width:100,
		align:'left',
		sortable:true,
		renderer:Ext.util.Format.comboRenderer(SCGSet),
		editor:new Ext.grid.GridEditor(SCGSet)
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
		var Other=Ext.getCmp('OtherFlag').getValue()==true?"O":"M"
		StkCatGroupGridDs.setBaseParam('Type',Other)
		StkCatGroupGridDs.load();
	}
});

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

function addNewRow() {
	var NewRecord = CreateRecordInstance(StkCatGroupGridDs.fields);
	StkCatGroupGridDs.add(NewRecord);
	StkCatGroupGrid.startEditing(StkCatGroupGridDs.getCount() - 1, 1);
}

var saveStkCatGroup = new Ext.Toolbar.Button({
	text:'����',
	tooltip:'����',
	iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		//��ȡ���е��¼�¼
		var Other=Ext.getCmp('OtherFlag').getValue()==true?"O":"M"
		var mr=StkCatGroupGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var code=mr[i].data["Code"].trim();
			var desc=mr[i].data["Desc"].trim();
			var spreq=mr[i].data["SpReq"].trim();
			var SCGSet=mr[i].data["SCGSet"].trim()
			if(code!="" && desc!=""){
				var dataRow = mr[i].data["RowId"]+"^"+code+"^"+desc+"^"+Other+"^"+spreq+"^"+SCGSet;
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
				StkCatGroupGridDs.remove(record);
				StkCatGroupGrid.getView().refresh();
			}
		}
	}
});
var OtherFlag = new Ext.form.Checkbox({
		boxLabel : '��������',
		id : 'OtherFlag',
		name : 'OtherFlag',
		anchor : '90%',
		checked : false,
		listeners:{
			check:function(chk,bool){
				SearchBT.handler()
			}
		}
	});
//���
var StkCatGroupGrid = new Ext.grid.EditorGridPanel({
	title:'�������ά��',
	region:'west',
	width:600,
	collapsible: true,
	split: true,
	minSize: 0,
	maxSize: 600,
	id : 'StkCatGroupGrid',
	store:StkCatGroupGridDs,
	cm:StkCatGroupGridCm,
	trackMouseOver:true,
	plugins:[SpReq],
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	tbar:[SearchBT,'-',addStkCatGroup,'-',saveStkCatGroup,'-',OtherFlag],
	listeners :��{
		'rowclick' : function(grid,rowIndex,e){
			//���������ˢ�¿��С���¼
			var selectedRow = StkCatGroupGridDs.data.items[rowIndex];
			StkCatGroupId = selectedRow.data["RowId"];
			StkCatGridDs.proxy = new Ext.data.HttpProxy({url:StkCatGridUrl+'?actiontype=selectStkCatBySCG',method:'GET'});
			StkCatGridDs.load({params:{StkCatGroupId:StkCatGroupId}});
		}
	}
});

//=========================�����=====================================

//=========================���С��===================================
var IncScStkGrpStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcstm.stkcatgroupaction.csp?actiontype=INCSCStkGrp&StkType=M&start=0&limit=200'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});

var INCStkCat = new Ext.form.ComboBox({
	fieldLabel : '����',
	id : 'INCStkCat',
	anchor : '90%',
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
	valueNotFoundText : '',
	listeners:{
		'beforequery':function(e){
			IncScStkGrpStore.removeAll();	//load֮ǰremoveԭ��¼���������׳���
			var Other=Ext.getCmp('OtherFlag').getValue()==true?"O":"M"
			IncScStkGrpStore.setBaseParam("Type",Other)
			IncScStkGrpStore.load();
		},
		'beforeselect' : function(combo, record, index){
			var Incsc = record.get(this.valueField);
			var FindIndex = StkCatGridDs.findExact('catId', Incsc, 0);
			if(FindIndex != -1){
				Msg.info('warning', '�Ѵ����ڵ�' + (FindIndex + 1) + '��!');
				return false;
			}
		}
	}
});

//��������Դ
var StkCatGridUrl = 'dhcstm.stkcatgroupaction.csp';
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
		dataIndex:'catId',
		width:300,
		align:'left',
		sortable:true,
		renderer : Ext.util.Format.comboRenderer2(INCStkCat,'catId','desc'),
		editor:new Ext.grid.GridEditor(INCStkCat)
	}
]);

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
			Msg.info("warning","��ѡ������!");
			return false;
		}
	}
});

function addNewSCRow() {
	var NewSCRecord = CreateRecordInstance(StkCatGridDs.fields);
	StkCatGridDs.add(NewSCRecord);
	StkCatGrid.startEditing(StkCatGridDs.getCount() - 1, 1);
}

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
			if(mr[i].data["catId"].trim()!=""){
				var dataRow = StkCatGroupId+"^"+mr[i].data["catId"].trim();
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
				StkCatGridDs.remove(record);
				StkCatGrid.getView().refresh();
			}
		}
	}
});

//���
var StkCatGrid = new Ext.grid.EditorGridPanel({
	title:'������',
	region:'center',
	id : 'StkCatGrid',
	store:StkCatGridDs,
	cm:StkCatGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	tbar:[addStkCat,'-',saveStkCat,'-',deleteStkCat]
});
//=========================���С��===================================

//===========ģ����ҳ��===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var mainPanel = new Ext.ux.Viewport({
		layout: 'border',
		items:[StkCatGroupGrid,StkCatGrid],
		renderTo: 'mainPanel'
	});
	SearchBT.handler()
});
//===========ģ����ҳ��===============================================