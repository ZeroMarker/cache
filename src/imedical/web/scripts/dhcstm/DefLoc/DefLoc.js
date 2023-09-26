// ����:�������ҹ���(2016-12-23���ڿ������Ĺ���Ŀ���ҷ���)
// ��д����:2012-06-15

var groupId = session['LOGON.GROUPID'];
var gCTLocId = "";

//=========================������Ϣ=================================
//���Ҵ���
var locCode = new Ext.form.TextField({
	id:'locCode',
	allowBlank:true,
	anchor:'90%'
});
//��������
var locName = new Ext.form.TextField({
	id:'locName',
	allowBlank:true,
	anchor:'90%'
});

//��������Դ
var gridUrl = 'dhcstm.deflocaction.csp';
var CTLocGridProxy= new Ext.data.HttpProxy({url:gridUrl+'?actiontype=QueryLoc',method:'GET'});
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
	remoteSort:false
});

//ģ��
var CTLocGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header:"����",
		dataIndex:'Code',
		width:200,
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
		var StrParam = Ext.getCmp('locCode').getValue()+"^"+Ext.getCmp('locName').getValue();
		CTLocGridDs.setBaseParam('strFilter',StrParam);
		CTLocGridDs.setBaseParam('groupId',groupId);
		CTLocGridDs.load({params:{start:0,limit:CTLocPagingToolbar.pageSize}});
	}
});

var CTLocPagingToolbar = new Ext.PagingToolbar({
	store:CTLocGridDs,
	pageSize:30,
	displayInfo:true
});

//���
var CTLocGrid = new Ext.grid.GridPanel({
	title:'������Ϣ',
	region:'west',
	width:600,
	store:CTLocGridDs,
	cm:CTLocGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm:new Ext.grid.RowSelectionModel({
		listeners : {
			rowselect : function(sm,rowIndex,r){
				gCTLocId = r.data["Rowid"];
				DefLocGridDs.setBaseParam('locId',gCTLocId);
				DefLocGridDs.setBaseParam('sort','Rowid');
				DefLocGridDs.load({params:{start:0,limit:DefLocPagingToolbar.pageSize}});
			}
		}
	}),
	loadMask:true,
	tbar:['���Ҵ���:',locCode,'��������:',locName,'-',queryCTLoc],
	bbar:CTLocPagingToolbar
});
//=========================������Ϣ=================================

//=========================��������=============================
function addNewRow() {
	var record = Ext.data.Record.create([
		{
			name : 'Rowid',
			type : 'int'
		}, {
			name : 'Code',
			type : 'string'
		}, {
			name : 'Desc',
			type : 'string'
		}, {
			name : 'SubLocId',
			type : 'int'
		}, {
			name : 'UseFlag',
			type : 'string'
		}
	]);
	
	var NewRecord = new record({
		Rowid:'',
		Code:'',
		Desc:'',
		SubLocId:'',
		UseFlag:''
	});
	
	DefLocGridDs.add(NewRecord);
	DefLocGrid.startEditing(DefLocGridDs.getCount() - 1, 2);
}

var DefLoc = new Ext.ux.LocComboBox({
	fieldLabel : '����',
	id : 'DefLoc',
	listeners:{
		specialKey:function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				addNewRow();
			}
		},
		beforeselect : function(combo,record,index){
			var selIndex = DefLocGridDs.findExact('SubLocId',record.get('RowId'),0);
			if(selIndex>=0){
				Msg.info('warning','�����ظ�!');
				return false;
			}
		}
	}
});

//��������Դ
var DefLocGridProxy= new Ext.data.HttpProxy({url:gridUrl+'?actiontype=Query',method:'GET'});
var DefLocGridDs = new Ext.data.Store({
	proxy:DefLocGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows'
	}, [
		{name:'Rowid'},
		{name:'Code'},
		{name:'Desc'},
		{name:'SubLocId'},
		{name:'UseFlag'}
	]),
	remoteSort:true,
	pruneModifiedRecords : true
});

var UseFlag = new Ext.grid.CheckColumn({
	header:'�Ƿ�ʹ��',
	dataIndex:'UseFlag',
	width:100,
	sortable:true,
	hidden : true
});

//ģ��
var DefLocGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
		header:"����",
		dataIndex:'Code',
		width:180,
		align:'left',
		sortable:true
	},{
		header:"����",
		dataIndex:'SubLocId',
		width:180,
		align:'left',
		sortable:true,
		renderer : Ext.util.Format.comboRenderer2(DefLoc,'SubLocId','Desc'),
		editor:new Ext.grid.GridEditor(DefLoc)
	},UseFlag
]);

var addDefLoc = new Ext.Toolbar.Button({
	text:'�½�',
	tooltip:'�½�',
	iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		if(Ext.isEmpty(gCTLocId)){
			Msg.info('warning','��ѡ�����!');
			return;
		}
		addNewRow();
	}
});

var saveDefLoc = new Ext.Toolbar.Button({
	text:'����',
	tooltip:'����',
	width : 70,
	height : 30,
	iconCls:'page_save',
	handler:function(){
		if(DefLocGrid.activeEditor!=null){
			DefLocGrid.activeEditor.completeEdit();
		}
		var mr=DefLocGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var subLocId = mr[i].data["SubLocId"];
			if(subLocId=='')continue;
			var desc= mr[i].data["Desc"];
			var flag= mr[i].data["UseFlag"];
			var dataRow= subLocId+"^"+flag;
			if(data==""){
				data = dataRow;
			}else{
				data = data+xRowDelim()+dataRow;
			}
		}
		if(data==""){
			Msg.info("warning","û����Ҫ�������Ϣ!");
			return;
		}
		var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
		Ext.Ajax.request({
			url: gridUrl+'?actiontype=Save',
			params : {locId : gCTLocId, data : data},
			failure: function(result, request) {
				mask.hide();
				Msg.info("error", "������������!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				mask.hide();
				if (jsonData.success=='true') {
					Msg.info("success", "����ɹ�!");
					DefLocGridDs.reload();
				}else{
					Msg.info("error", "����ʧ��!");
				}
			},
			scope: this
		});
	}
});

var deleteDefLoc = new Ext.Toolbar.Button({
	text:'ɾ��',
	tooltip:'ɾ��',
	iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = DefLocGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error","��ѡ������!");
			return false;
		}else{
			var record = DefLocGrid.getStore().getAt(cell[0]);
			var RowId = record.get("Rowid");
			if(RowId!=""){
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
							Ext.Ajax.request({
								url:gridUrl+'?actiontype=delete&rowid='+RowId,
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
										DefLocGridDs.reload();
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
				var rowInd=cell[0];
				if (rowInd>=0){
					DefLocGrid.getStore().removeAt(rowInd);
					DefLocGrid.getView().refresh();
				}
			}
		}
	}
});

var DefLocPagingToolbar = new Ext.PagingToolbar({
	store:DefLocGridDs,
	pageSize:30,
	displayInfo:true
});

//���
var DefLocGrid = new Ext.grid.EditorGridPanel({
	title:'��������',
	region:'center',
	store:DefLocGridDs,
	cm:DefLocGridCm,
	trackMouseOver:true,
	plugins:UseFlag,
	stripeRows:true,
	loadMask:true,
	clicksToEdit:1,
	deferRowRender:false,
	sm:new Ext.grid.CellSelectionModel({}),
	tbar:[addDefLoc,'-',saveDefLoc,'-',deleteDefLoc],
	bbar:DefLocPagingToolbar,
	listeners : {
		beforeedit : function(e){
			if(e.record.get('Rowid')!=''){
				return false;
			}
		}
	}
});
//=========================��������=============================

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		collapsible:true,
		split: true,
		items:[CTLocGrid,DefLocGrid],
		renderTo:'mainPanel'
	});
	
	queryCTLoc.handler();
});
