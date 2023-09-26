// ����:�������ù���
// ��д����:2012-06-7
// Modify:zdm,2012-07-10,�޸Ľ��沼��

var StkSysAppId = "";
var StkSysAppParameId = "";
var GroupId = session['LOGON.GROUPID'];
//������Ŀ��־(1:����,����:������)
var gGroupFlag = tkMakeServerCall("web.DHCSTM.Common.AppCommon","GetAppPropValue","DHCSTCOMMONM","GroupFlag","");

var ReSetAppParame = new Ext.Button({
	text : '��ʼ������',
	iconCls : 'page_gear',
	//hidden : true,
	width : 70,
	height : 30,
	handler : function(){
		if(!confirm('��һ����ʾ: ���������ò���, ���ɾ��֮ǰ�����в�������, �Ƿ����?')){
			return;
		}
		if(!confirm('�ڶ�����ʾ: ���������ò���, ���ɾ��֮ǰ�����в�������, �Ƿ����?')){
			return;
		}
		if(!confirm('���һ����ʾ: ���������ò���, ���ɾ��֮ǰ�����в�������, �Ƿ����?')){
			return;
		}
		
		var result = tkMakeServerCall('web.DHCSTM.Tools.CreateAppPara', 'ReSetParame');
		if(!Ext.isEmpty(result)){
			Msg.info('error', '����ʧ��:' + result);
		}else{
			Msg.info('success', '���óɹ�!');
			StkSysAppParameGridDs.reload();
		}
	}
});

var synAppParame = new Ext.Toolbar.Button({
	text:'ͬ������',
	tooltip:'ͬ������',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		var synRet = tkMakeServerCall("web.DHCSTM.Tools.CreateApp","App");
		var synRet = tkMakeServerCall("web.DHCSTM.Tools.CreateAppPara","Prop");
		var synRetArr = synRet.split("^");
		Msg.info("success","����"+synRetArr[2]+"��, ����"+synRetArr[0]+"��, �޸�"+synRetArr[1]+"��!");
		StkSysAppParameValueGridDs.removeAll();
		StkSysAppParameGridDs.reload();
	}
});

//��������Դ
var StkSysAppGridUrl = 'dhcstm.stksysappaction.csp';
var StkSysAppGridDs = new Ext.data.JsonStore({
	url : StkSysAppGridUrl+'?actiontype=selectAll',
	totalProperty : 'results',
	root:'rows',
	fields : ['RowId','Code','Desc','Type']
});

//ģ��
var StkSysAppGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header:"����",
		dataIndex:'Code',
		width:170,
		align:'left',
		sortable:true
	},{
		header:"����",
		dataIndex:'Desc',
		width:120,
		align:'left',
		sortable:true
	}
]);

//���
var StkSysAppGrid = new Ext.grid.EditorGridPanel({
	id : 'StkSysAppGrid',
	store:StkSysAppGridDs,
	cm:StkSysAppGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm:new Ext.grid.RowSelectionModel({
		singleSelect : true,
		listeners : {
			rowselect : function(sm,rowIndex,r){
				StkSysAppId = r.get("RowId");
				StkSysAppParameGridDs.load({params:{StkSysAppId:StkSysAppId}});
				StkSysAppParameValueGrid.getStore().removeAll();
			}
		}
	}),
	viewConfig : {
		forceFit : true
	},
	loadMask:true,
	tbar : [ReSetAppParame, '-', synAppParame]
});

StkSysAppGridDs.load();
//=========================Ӧ��ϵͳ����=================================

//=========================Ӧ��ϵͳ��������=============================
function addNewMXRow() {
	var MXRecord = CreateRecordInstance(StkSysAppParameGridDs.fields);
	StkSysAppParameGridDs.add(MXRecord);
	StkSysAppParameGrid.startEditing(StkSysAppParameGridDs.getCount() - 1, 2);
}

//��������Դ
var StkSysAppParameGridUrl = 'dhcstm.stksysappparameaction.csp';
var StkSysAppParameGridDs = new Ext.data.JsonStore({
	url : StkSysAppParameGridUrl+'?actiontype=selectParame',
	totalProperty : 'results',
	root : 'rows',
	fields : ['RowId','Parref','Code','Desc','Memo','PropValue'],
	pruneModifiedRecords : true,
	listeners : {
		load : function(store,records,options){
			gGroupFlag = tkMakeServerCall("web.DHCSTM.Common.AppCommon","GetAppPropValue","DHCSTCOMMONM","GroupFlag","");
		}
	}
});

//ģ��
var StkSysAppParameGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
		header:"Id",
		dataIndex:'RowId',
		width:100,
		align:'left',
		sortable:true,
		hidden:true
	},{
		header:"����",
		dataIndex:'Code',
		width:150,
		align:'left',
		sortable:true,
		editor: new Ext.form.TextField({
			id:'nameField',
			allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var row = StkSysAppParameGrid.getSelectionModel().getSelectedCell()[0];
						var col = GetColIndex(StkSysAppParameGrid,'Desc');
						StkSysAppParameGrid.startEditing(row, col);
					}
				}
			}
		})
	},{
		header:"����",
		dataIndex:'Desc',
		width:180,
		align:'left',
		sortable:true,
		editor: new Ext.form.TextField({
			id:'descField',
			allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var row = StkSysAppParameGrid.getSelectionModel().getSelectedCell()[0];
						var col = GetColIndex(StkSysAppParameGrid,'Memo');
						StkSysAppParameGrid.startEditing(row, col);
					}
				}
			}
		})
	},{
		header:"��ע",
		dataIndex:'Memo',
		width:220,
		align:'left',
		sortable:true,
		editor: new Ext.form.TextField({
			id:'memoField',
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var row = StkSysAppParameGrid.getSelectionModel().getSelectedCell()[0];
						var col = GetColIndex(StkSysAppParameGrid,'PropValue');
						StkSysAppParameGrid.startEditing(row, col);
					}
				}
			}
		})
	},{
		header:"ȱʡֵ",
		dataIndex:'PropValue',
		width:80,
		align:'left',
		editor: new Ext.form.TextField({
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						addNewMXRow();
					}
				}
			}
		})
	}
]);

var addStkSysAppParame = new Ext.Toolbar.Button({
	text:'�½�',
	tooltip:'�½�',
	iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		if(StkSysAppId!=""){
			addNewMXRow();
		}else{
			Msg.info("error", "��ѡ��Ӧ��ϵͳ!");
			return false;
		}
	}
});

var saveStkSysAppParame = new Ext.Toolbar.Button({
	text:'����',
	tooltip:'����',
	width : 70,
	height : 30,
	iconCls:'page_save',
	handler:function(){
		if(StkSysAppParameGrid.activeEditor != null){
			StkSysAppParameGrid.activeEditor.completeEdit();
		} 
		//��ȡ���е��¼�¼
		var mr=StkSysAppParameGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var code = mr[i].data["Code"];
			var rowid =mr[i].data["RowId"];
			var desc = mr[i].data["Desc"];
			var memo = mr[i].data["Memo"];
			var propValue = mr[i].data["PropValue"];
			if((code!="")&&(StkSysAppId!="")){
				var dataRow = rowid+"^"+StkSysAppId+"^"+code+"^"+desc+"^"+memo
					+"^"+propValue;
				if(data==""){
					data = dataRow;
				}else{
					data = data+xRowDelim()+dataRow;
				}
			}
		}
		if(data!=""){
			var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
			Ext.Ajax.request({
				url: StkSysAppParameGridUrl+'?actiontype=saveParame',
				params: {data:data},
				failure: function(result, request) {
					mask.hide();
					Msg.info("error", "������������!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					mask.hide();
					if (jsonData.success=='true') {
						data="";
						Msg.info("success", "����ɹ�!");
						StkSysAppParameGridDs.reload();
					}else{
						if(jsonData.info=="RepRec"){
							data="";
							Msg.info("error", "��¼�ظ�!");
						}else{
							data="";
							Msg.info("error", "����ʧ��!");
						}
					}
				},
				scope: this
			});
		}
		else(Msg.info("error", "û���޸Ļ����������!"));
	}
});

var deleteStkSysAppParame = new Ext.Toolbar.Button({
	text:'ɾ��',
	tooltip:'ɾ��',
	width : 70,
	height : 30,
	iconCls:'page_delete',
	handler:function(){
		var cell = StkSysAppParameGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error", "��ѡ������!");
			return false;
		}else{
			var record = StkSysAppParameGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
							Ext.Ajax.request({
								url:StkSysAppParameGridUrl+'?actiontype=deleteParame&rowid='+RowId,
								waitMsg:'ɾ����...',
								failure: function(result, request) {
									mask.hide();
									Msg.info("error", "������������!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									mask.hide();
									if (jsonData.success=='true') {
										Msg.info("success", "ɾ���ɹ�!");
										StkSysAppParameGridDs.load({params:{StkSysAppId:StkSysAppId}});
									}else{
										Msg.info("error", "ɾ��ʧ��!");
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				StkSysAppParameGridDs.remove(record);
				StkSysAppParameGrid.getView().refresh();
			}
		}
	}
});
//���
var StkSysAppParameGrid = new Ext.grid.EditorGridPanel({
	id : 'StkSysAppParameGrid',
	store:StkSysAppParameGridDs,
	cm:StkSysAppParameGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({
		listeners : {
			cellselect : function(sm,rowIndex,colIndex){
				var selectedRow = StkSysAppParameGridDs.data.items[rowIndex];
				StkSysAppParameId = selectedRow.data["RowId"];
				StkSysAppParameValueGridDs.load({params:{StkSysAppParameId:StkSysAppParameId}});
			}
		}
	}),
	viewConfig : {
		forceFit : true
	},
	loadMask:true,
	tbar:[addStkSysAppParame,'-',saveStkSysAppParame,'-',deleteStkSysAppParame],
	clicksToEdit:1,
	listeners : {
		beforeedit : function(e){
			if(e.field=="Code"){
				if(!Ext.isEmpty(e.record.get("RowId"))){
					e.cancel=true;   //�����޸�����
				}
			}else if(e.field=='PropValue'){
				if(gGroupFlag==1 && !Ext.isEmpty(e.record.get("RowId")) && e.record.get('Code')!='GroupFlag'){
					e.cancel = true;
				}
			}
		}
	}
});
//=========================Ӧ��ϵͳ��������=============================

//=========================Ӧ��ϵͳ����ֵ����===========================
var typeStore = new Ext.data.SimpleStore({
	fields:['key', 'keyValue'],
	data:[["G",'��ȫ��'], ["L",'����'], ["U",'��Ա'], ["D",'ȫԺ']]
});

var typeField = new Ext.form.ComboBox({
	id:'typeField',
	width:200,
	listWidth:200,
	allowBlank:true,
	store:typeStore,
	value:'', // Ĭ��ֵ""
	valueField:'key',
	displayField:'keyValue',
	emptyText:'',
	triggerAction:'all',
	emptyText:'',
	minChars:1,
	pageSize:10,
	mode:'local',
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});

var PointerStore = new Ext.data.JsonStore({
	url : 'dhcstm.orgutil.csp?actiontype=GetSSPPoint',
	totalProperty : "results",
	root : 'rows',
	fields : ['Description', 'RowId']
});

var PointerField = new Ext.ux.ComboBox({
	fieldLabel : '����ֵ',
	id : 'PointerField',
	width : 120,
	store : PointerStore,
	filterName : 'filter',
	valueParams : {Group:GroupId},
	listeners:{
		beforequery : function(e){
			var rowIndex=StkSysAppParameValueGrid.getSelectionModel().getSelectedCell()[0];
			var record=StkSysAppParameValueGrid.store.getAt(rowIndex);
			var type=record.get("Type");
			this.store.setBaseParam('Type',type);
		},
		specialKey:function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				var row = StkSysAppParameValueGrid.getSelectionModel().getSelectedCell()[0];
				var col = GetColIndex(StkSysAppParameValueGrid,'Value');
				StkSysAppParameValueGrid.startEditing(row, col);
			}
		}
	}
});

var Hosp = new Ext.ux.ComboBox({
	fieldLabel : 'ҽԺ',
	id : 'Hosp',
	store : HospStore,
	listeners:{
		specialKey:function(field, e) {
			if(e.getKey() == Ext.EventObject.ENTER){
				addRow();
			}
		}
	}
});

function addRow() {
	var MXRec = CreateRecordInstance(StkSysAppParameValueGridDs.fields);
	StkSysAppParameValueGridDs.add(MXRec);
	StkSysAppParameValueGrid.startEditing(StkSysAppParameValueGridDs.getCount() - 1, 1);
}

//��������Դ
var StkSysAppParameValueGridUrl = 'dhcstm.stksysappparameaction.csp';
var StkSysAppParameValueGridDs = new Ext.data.JsonStore({
	url : StkSysAppParameValueGridUrl+'?actiontype=selectParameValue',
	totalProperty : 'results',
	root : 'rows',
	fields : ['ParRef','RowId','Type','TypeName','Pointer',
		'PointerName','Value','HospDr','HospName'],
	pruneModifiedRecords : true
});

//ģ��
var StkSysAppParameValueGridCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),{
		header:"����",
		dataIndex:'Type',
		width:120,
		align:'left',
		sortable:true,
		editor : new Ext.grid.GridEditor(typeField),
		renderer : Ext.util.Format.comboRenderer(typeField)
	},{
		header:"����ֵ",
		dataIndex:'Pointer',
		width:200,
		align:'left',
		sortable:true,
		editor:new Ext.grid.GridEditor(PointerField),
		renderer:Ext.util.Format.comboRenderer2(PointerField,'Pointer','PointerName')
	},{
		header:"����ֵ",
		dataIndex:'Value',
		width:100,
		align:'left',
		sortable:true,
		editor: new Ext.form.TextField({
			id:'valueField',
			allowBlank:true,
			listeners:{
				specialKey:function(field, e) {
					var keyCode=e.getKey();
					if(keyCode==e.ENTER){
						var row = StkSysAppParameValueGrid.getSelectionModel().getSelectedCell()[0];
						var col = GetColIndex(StkSysAppParameValueGrid,'HospDr')
						StkSysAppParameValueGrid.startEditing(row, col);
					}
				}
			}
		})
	},{
		header:"ҽԺ",
		dataIndex:'HospDr',
		width:300,
		align:'left',
		sortable:true,
		editor:new Ext.grid.GridEditor(Hosp),
		renderer:Ext.util.Format.comboRenderer2(Hosp,'HospDr','HospName')
	}
]);

var addStkSysAppParameValue = new Ext.Toolbar.Button({
	text:'�½�',
	tooltip:'�½�',
	iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		if(StkSysAppParameId!=""){
			addRow();
		}else{
			Msg.info("error", "��ѡ���������!");
			return false;
		}
	}
});

var saveStkSysAppParameValue = new Ext.Toolbar.Button({
	text:'����',
	tooltip:'����',
	width : 70,
	height : 30,
	iconCls:'page_save',
	handler:function(){
		//��ȡ���е��¼�¼
		if(StkSysAppParameValueGrid.activeEditor != null){
			StkSysAppParameValueGrid.activeEditor.completeEdit();
		}
		var mr=StkSysAppParameValueGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var value = mr[i].data["Value"];
			var rowid =mr[i].get('RowId');
			var type = mr[i].data["Type"];
			var pointer = mr[i].data["Pointer"];
			var hosp = mr[i].data["HospDr"];
			if(gGroupFlag!=1 && type=='D'){
				//��������Ŀ
				Msg.info('warning','��������Ŀ,���Ƽ�ʹ��"ȫԺ"����,��ʹ�ò���ȱʡֵά��!');
				return;
			}
			if(gGroupFlag==1 && hosp==""){
				hosp = session['LOGON.HOSPID'];
				if(Ext.isEmpty(hosp)){
					Msg.info('warning','������Ŀ,��������"ҽԺ"!');
					return;
				}
			}
			if((StkSysAppParameId!="")&&(pointer!="")){
				var dataRow = rowid+"^"+StkSysAppParameId+"^"+type+"^"+pointer+"^"+value+"^"+hosp;
				if(data==""){
					data = dataRow;
				}else{
					data = data+xRowDelim()+dataRow;
				}
			}
		}
		if(data!=""){
			var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
			Ext.Ajax.request({
				url: StkSysAppParameValueGridUrl+'?actiontype=saveParameValue',
				params: {data:data},
				failure: function(result, request) {
					mask.hide();
					Msg.info("error", "������������!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					mask.hide();
					if (jsonData.success=='true') {
						data="";
						Msg.info("success", "����ɹ�!");
						StkSysAppParameValueGridDs.reload();
					}else{
						if(jsonData.info=="RepRec"){
							data="";
							Msg.info("error", "��¼�ظ�!");
						}else{
							data="";
							Msg.info("error", "����ʧ��!");
						}
					}
				},
				scope: this
			});
		}
		else{Msg.info("error", "û���޸Ļ����������!")};
	}
});

var deleteStkSysAppParameValue = new Ext.Toolbar.Button({
	text:'ɾ��',
	tooltip:'ɾ��',
	width : 70,
	height : 30,
	iconCls:'page_delete',
	handler:function(){
		var cell = StkSysAppParameValueGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error", "��ѡ������!");
			return false;
		}else{
			var record = StkSysAppParameValueGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
							Ext.Ajax.request({
								url:StkSysAppParameValueGridUrl+'?actiontype=deleteParameValue&rowid='+RowId,
								waitMsg:'ɾ����...',
								failure: function(result, request) {
									mask.hide();
									Msg.info("error", "������������!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									mask.hide();
									if (jsonData.success=='true') {
										Msg.info("success", "ɾ���ɹ�!");
										StkSysAppParameValueGridDs.reload();
									}else{
										Msg.info("error", "ɾ��ʧ��!");
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				StkSysAppParameValueGridDs.remove(record);
				StkSysAppParameValueGrid.getView().refresh();
			}
		}
	}
});

//���
var StkSysAppParameValueGrid = new Ext.grid.EditorGridPanel({
	id : 'StkSysAppParameValueGrid',
	store:StkSysAppParameValueGridDs,
	cm:StkSysAppParameValueGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	tbar:[addStkSysAppParameValue,'-',saveStkSysAppParameValue,'-',deleteStkSysAppParameValue,'-','��������Ŀ,����ά��"ҽԺ". ������Ŀ"ҽԺ"����½ҽԺ����.'],
	clicksToEdit:1,
	listeners : {
		beforeedit : function(e){
			if(e.field == 'HospDr' && gGroupFlag==1 && session['LOGON.GROUPDESC']!='Demo Group'){
				e.cancel = true;
			}
		},
		afteredit : function(e){
			if(e.field=='Type'){
				e.record.set('Pointer','');
			}
		}
	}
});
//=========================Ӧ��ϵͳ����ֵ����===========================

//===========ģ����ҳ��=================================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items : [
			{
				region: 'west',
				collapsible: true,
				title: 'Ӧ�ó���',
				split: true,
				width: 350,
				minSize: 200,
				maxSize: 400,
				margins: '0 5 0 0',
				layout: 'fit',
				items:StkSysAppGrid
			}, {
				region: 'center',
				title: '����',
				layout: 'fit',
				items: StkSysAppParameGrid
			}, {
				region: 'south',
				split: true,
				height: 250,
				minSize: 100,
				maxSize: 250,
				collapsible: true,
				title: '����ֵ',
				layout: 'fit',
				items: StkSysAppParameValueGrid
			}
		],
		renderTo:'mainPanel'
	});
});
//===========ģ����ҳ��=================================================