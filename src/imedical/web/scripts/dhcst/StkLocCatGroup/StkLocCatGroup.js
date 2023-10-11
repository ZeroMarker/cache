// ����:�����������
// ��д����:2012-06-14
//=========================����ȫ�ֱ���=================================
var groupId = session['LOGON.GROUPID'];
var CTLocId = "";
var LocGrpId = "";
//=========================����ȫ�ֱ���=================================
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

var CTLocGrid="";
//��������Դ
var gridUrl = 'dhcst.stkloccatgroupaction.csp';
var CTLocGridProxy= new Ext.data.HttpProxy({url:gridUrl+'?actiontype=selectAll',method:'GET'});
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
        header:$g("����"),
        dataIndex:'Code',
        width:200,
        align:'left',
        sortable:true
    },{
        header:$g("����"),
        dataIndex:'Desc',
        width:200,
        align:'left',
        sortable:true
    }
]);

//��ʼ��Ĭ��������
CTLocGridCm.defaultSortable = true;

var queryCTLoc = new Ext.Toolbar.Button({
	text:$g('��ѯ'),
    tooltip:$g('��ѯ'),
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		CTLocGridDs.proxy = new Ext.data.HttpProxy({url:gridUrl+'?actiontype=QueryLoc',method:'POST'});
		CTLocGridDs.load({params:{strFilter:Ext.getCmp('locCode').getValue()+"^"+Ext.getCmp('locName').getValue(),start:0,limit:CTLocPagingToolbar.pageSize,sort:'Rowid',dir:'desc',groupId:groupId}});
	}
});

var CTLocPagingToolbar = new Ext.PagingToolbar({
    store:CTLocGridDs,
	pageSize:30,
    displayInfo:true,
    displayMsg:$g('�� {0} ���� {1}�� ��һ�� {2} ��'),
    emptyMsg:$g("û�м�¼"),
	doLoad:function(C){
		var B={},
		A=this.getParams();
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B[A.sort]='Rowid';
		B[A.dir]='desc';
		B['strFilter']=Ext.getCmp('locCode').getValue()+"^"+Ext.getCmp('locName').getValue();
		B['groupId']=groupId;
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//���
CTLocGrid = new Ext.grid.GridPanel({
	id:"CTLocGridid",
	store:CTLocGridDs,
	cm:CTLocGridCm,
	trackMouseOver:true,
	height:265,
	stripeRows:true,
	sm:new Ext.grid.RowSelectionModel({}),
	loadMask:true,
	tbar:[$g('���Ҵ���:'),locCode,$g('��������:'),locName,'-',queryCTLoc],
	bbar:CTLocPagingToolbar
});
//=========================������Ϣ=================================

//=========================������������=============================
var defaultFlag = new Ext.grid.CheckColumn({
	header:$g('ȱʡ��־'),
	dataIndex:'DefaultFlag',
	width:100,
	sortable:true,
	renderer:function(v, p, record){
		p.css += ' x-grid3-check-col-td';
		return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	}
});

function addNewRow() {
	if(CTLocId==null || CTLocId==""){
		Msg.info("warning",$g("����ѡ����ң�"));
		return;
	}
	var record = Ext.data.Record.create([
		{
			name : 'Rowid',
			type : 'int'
		}, {
			name : 'GrpId',
			type : 'int'
		}, {
			name : 'GrpCode',
			type : 'string'
		}, {
			name : 'GrpDesc',
			type : 'string'
		}, {
			name : 'DefaultFlag',
			type : 'string'
		}
	]);
	
	var NewRecord = new record({
		Rowid:'',
		GrpId:'',
		GrpCode:'',
		GrpDesc:'',
		DefaultFlag:'Y'
	});
					
	StkLocCatGroupGridDs.add(NewRecord);
	StkLocCatGroupGrid.startEditing(StkLocCatGroupGridDs.getCount() - 1, 2);
}

var ScStkGrpStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcst.extux.csp?actiontype=StkCatGroup&type=G&start=0&limit=999'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});
	
var SCG = new Ext.ux.StkGrpComboBox ({
	fieldLabel : $g('����'),
	id : 'SCG',
	name : 'SCG',
	anchor : '90%',
	StkType:App_StkTypeCode,
	emptyText : $g('����...')
});		

var StkLocCatGroupGrid="";
//��������Դ
var StkLocCatGroupGridProxy= new Ext.data.HttpProxy({url:gridUrl,method:'GET'});
var StkLocCatGroupGridDs = new Ext.data.Store({
	proxy:StkLocCatGroupGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [
		{name:'Rowid'},
		{name:'GrpId'},
		{name:'GrpCode'},
		{name:'GrpDesc'},
		{name:'DefaultFlag'}
	]),
	pruneModifiedRecords:true,
    remoteSort:true
});

//ģ��
var StkLocCatGroupGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
        header:$g("����"),
        dataIndex:'GrpCode',
        width:180,
        align:'left',
        sortable:true
    },{
        header:$g("����"),
        dataIndex:'GrpId',
        width:180,
        align:'left',
        sortable:true,
		renderer : Ext.util.Format.comboRenderer(SCG),
		editor:new Ext.grid.GridEditor(SCG)
    },defaultFlag
]);

//��ʼ��Ĭ��������
StkLocCatGroupGridCm.defaultSortable = true;

var addStkLocCatGroup = new Ext.Toolbar.Button({
	text:$g('�½�'),
    tooltip:$g('�½�'),
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var saveStkLocCatGroup = new Ext.Toolbar.Button({
	text:$g('����'),
    tooltip:$g('����'),
	width : 70,
	height : 30,
    iconCls:'page_save',
	handler:function(){
		//��ȡ���е��¼�¼
		var mr=StkLocCatGroupGridDs.getModifiedRecords();
		var data="";
		var grpStr=""
		for(var i=0;i<mr.length;i++){
			var rowId=mr[i].data["Rowid"];
			var grpId = mr[i].data["GrpId"];
			var GrpDesc=mr[i].data["GrpDesc"];
			var flag = mr[i].data["DefaultFlag"];
			if(grpId==""){
				var count=i+1
				if(grpStr==""){
					grpStr = count;
				}else{
					grpStr = grpStr+","+count;
				}
				}
			if(rowId!=""){
				var dataRow = rowId+"^"+grpId+"^"+flag+"^"+GrpDesc;
				if(data==""){
					data = dataRow;
				}else{
					data = data+xRowDelim()+dataRow;
				}
			}else{
				var dataRow = "^"+grpId+"^"+flag+"^"+GrpDesc;
				if(data==""){
					data = dataRow;
				}else{
					data = data+xRowDelim()+dataRow;
				}
			}
		}
		if(grpStr!=""){ Msg.info("error",$g("��ѡ������󱣴�!"));	return false;;}
		if(data!=""){
			Ext.Ajax.request({
				url: gridUrl+'?actiontype=Save',
				params: {data:data,locId:CTLocId},
				failure: function(result, request) {
					Msg.info("error", $g("������������!"));
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success", $g("����ɹ�!"));
						StkLocCatGroupGridDs.proxy = new Ext.data.HttpProxy({url:gridUrl+'?actiontype=Query&locId='+CTLocId,method:'GET'});
						StkLocCatGroupGridDs.load();
					}else{
						if(jsonData.info==-1){
							Msg.info("error",$g("�����ظ�"));
						}else{
							Msg.info("error", $g("����ʧ��! ")+ jsonData.info);
						}
					}
				},
				scope: this
			});
		}
    }
});

var deleteStkLocCatGroup = new Ext.Toolbar.Button({
	text:$g('ɾ��'),
    tooltip:$g('ɾ��'),
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = StkLocCatGroupGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error",$g("��ѡ������!"));
			return false;
		}else{
			var record = StkLocCatGroupGrid.getStore().getAt(cell[0]);
			var RowId = record.get("Rowid");
			if(RowId!=""){
				Ext.MessageBox.confirm($g('��ʾ'),$g('ȷ��Ҫɾ��ѡ������?'),
					function(btn) {
						if(btn == 'yes'){
							Ext.Ajax.request({
								url:gridUrl+'?actiontype=delete&rowid='+RowId,
								waitMsg:$g('ɾ����...'),
								failure: function(result, request) {
									Msg.info("error",$g("������������!"));
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true') {
										Msg.info("success",$g("ɾ���ɹ�!"));
										StkLocCatGroupGridDs.proxy = new Ext.data.HttpProxy({url:gridUrl+'?actiontype=Query&locId='+CTLocId,method:'GET'});
										StkLocCatGroupGridDs.load();
										StkLocUserCatGroupGridDs.reload();
									}else{
										Msg.info("error",$g("ɾ��ʧ��!"));
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				Msg.info("error",$g("�����д�!"));
			}
		}
    }
});

//���
StkLocCatGroupGrid = new Ext.grid.EditorGridPanel({
	store:StkLocCatGroupGridDs,
	cm:StkLocCatGroupGridCm,
	trackMouseOver:true,
	height:265,
	plugins:defaultFlag,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	deferRowRender:false,
	tbar:[addStkLocCatGroup,'-',saveStkLocCatGroup,'-',deleteStkLocCatGroup]
});
//=========================������������=============================
//=========================��Աά��=============================
Ext.util.Format.comboRenderer = function(combo){  
    return function(value){  
       var record = combo.findRecord(combo.valueField,value);  
        return record ? record.get(combo.displayField):combo.valueNotFoundText;  
    }  
};

var DefaultField = new Ext.grid.CheckColumn({
	header:$g('�Ƿ�Ĭ��'),
	dataIndex:'Default',
	width:100,
	sortable:true,
	renderer:function(v, p, record){
		p.css += ' x-grid3-check-col-td';
		return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	}
});

var ActiveField = new Ext.grid.CheckColumn({
	header:$g('�Ƿ���Ч'),
	dataIndex:'Active',
	width:100,
	sortable:true,
	hidden:true,  //ȥ��������ʾ��Ĭ��Y 2020-03-02  yangsj
	renderer:function(v, p, record){
		p.css += ' x-grid3-check-col-td';
		return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	}
});

var UStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url:'dhcst.orgutil.csp?actiontype=StkLocUserCatGrp'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});
	
var UCG = new Ext.form.ComboBox({
	fieldLabel : $g('����'),
	id : 'UCG',
	name : 'UCG',
	anchor : '90%',
	width : 120,
	store : UStore,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : false,
	triggerAction : 'all',
	emptyText : $g('����...'),
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 10,
	listWidth : 250,
	valueNotFoundText : '',
	listeners:{
		specialKey:function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				addNewRow();
			}
		}
	}
});		
	
UCG.on('beforequery', function(e) {
	UStore.removeAll();
	UStore.setBaseParam('name',Ext.getCmp('UCG').getRawValue());
	UStore.setBaseParam('locId',CTLocId);
	var pageSize=Ext.getCmp("UCG").pageSize;
	UStore.load({params:{start:0,limit:pageSize}});
});

function addRow() {
	var record = Ext.data.Record.create([
		{
			name : 'Rowid',
			type : 'int'
		},{
			name : 'UserId',
			type : 'int'
		}, {
			name : 'Code',
			type : 'string'
		}, {
			name : 'Name',
			type : 'string'
		}, {
			name : 'Default',
			type : 'string'
		}, {
			name : 'Active',
			type : 'string'
		}
	]);
					
	var rec = new record({
		Rowid:'',
		UserId:'',
		Code:'',
		Name:'',
		Default:'Y',
		Active:'Y'
	});
	StkLocUserCatGroupGridDs.add(rec);
	StkLocUserCatGroupGrid.startEditing(StkLocUserCatGroupGridDs.getCount() - 1, 2);
}

var StkLocUserCatGroupGrid="";
//��������Դ
var StkLocUserCatGroupGridProxy= new Ext.data.HttpProxy({url:gridUrl,method:'GET'});
var StkLocUserCatGroupGridDs = new Ext.data.Store({
	proxy:StkLocUserCatGroupGridProxy,
    reader:new Ext.data.JsonReader({
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
    remoteSort:false
});

//ģ��
var StkLocUserCatGroupGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
        header:$g("����"),
        dataIndex:'Code',
        width:200,
        align:'left',
        sortable:true
    },{
        header:$g("����"),
        dataIndex:'UserId',
        width:200,
        align:'left',
        sortable:true,
		renderer:Ext.util.Format.comboRenderer2(UCG,"UserId","Name"),
		editor:new Ext.grid.GridEditor(UCG)
    },DefaultField,ActiveField
]);

 

//��ʼ��Ĭ��������
StkLocUserCatGroupGridCm.defaultSortable = true;

var addStkLocUserCatGroup = new Ext.Toolbar.Button({
	text:$g('�½�'),
    tooltip:$g('�½�'),
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		if(LocGrpId!=""){
			addRow();
		}else{
			Msg.info("error", $g("��ѡ���������!"));
		}
	}
});

var saveStkLocUserCatGroupGrid = new Ext.Toolbar.Button({
	text:$g('����'),
    tooltip:$g('����'),
	width : 70,
	height : 30,
    iconCls:'page_save',
	handler:function(){
		//��ȡ���е��¼�¼
		var mr=StkLocUserCatGroupGridDs.getModifiedRecords();
		var data="";
		var nameflag="";
		for(var i=0;i<mr.length;i++){
			var RowId = mr[i].data["Rowid"];
			var userId = mr[i].data["UserId"];
			var active ="Y"  // mr[i].data["Active"];  //���治�ɱ༭��Ĭ��ΪY
			var def = mr[i].data["Default"];
			var name = mr[i].data["Name"];
			if(RowId!=""){
				var dataRow = RowId+"^"+userId+"^"+active+"^"+def+"^"+name;
				if(data==""){
					data = dataRow;
					nameflag=nameflag+userId
				}else{
					data = data+xRowDelim()+dataRow;
					nameflag=nameflag+userId
				}
			}else{
				var dataRow = "^"+userId+"^"+active+"^"+def+"^"+name;
				if(data==""){
					data = dataRow;
					nameflag=nameflag+userId
				}else{
					data = data+xRowDelim()+dataRow;
					nameflag=nameflag+userId
				}
			}
		}
		if(nameflag==""){	Msg.info("error",$g("û����Ҫ���������!"));	return false;;}
		
		if(data!=""){
			Ext.Ajax.request({
				url: gridUrl+'?actiontype=SaveUser',
				params: {data:data,locGrpId:LocGrpId},
				failure: function(result, request) {
					Msg.info("error", $g("������������!"));
				},
				success: function(result, request) {
					data="";
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success",$g( "����ɹ�!"));
						StkLocUserCatGroupGridDs.proxy = new Ext.data.HttpProxy({url:gridUrl+'?actiontype=QueryUser',method:'GET'});
						StkLocUserCatGroupGridDs.load({params:{start:0,limit:StkLocUserCatGroupGridPagingToolbar.pageSize,sort:'Rowid',dir:'desc',locGrpId:LocGrpId}});
					}else{
						if(jsonData.info==-1){
							Msg.info("error",$g("��Ա�ظ�!"));
						}else{
							Msg.info("error", $g("����ʧ��")+jsonData.info);
						}
					}
				},
				scope: this
			});
		}
    }
});

var deleteStkLocUserCatGroupGrid = new Ext.Toolbar.Button({
	text:$g('ɾ��'),
    tooltip:$g('ɾ��'),
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = StkLocUserCatGroupGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error",$g("��ѡ������!"));
			return false;
		}else{
			var record = StkLocUserCatGroupGrid.getStore().getAt(cell[0]);
			var RowId = record.get("Rowid");
			if(RowId!=""){
				Ext.MessageBox.confirm($g('��ʾ'),$g('ȷ��Ҫɾ��ѡ������?'),
					function(btn) {
						if(btn == 'yes'){
							Ext.Ajax.request({
								url:gridUrl+'?actiontype=deleteUser&rowid='+RowId,
								waitMsg:$g('ɾ����...'),
								failure: function(result, request) {
									Msg.info("error",$g("������������!"));
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true') {
										Msg.info("success",$g("ɾ���ɹ�!"));
										StkLocUserCatGroupGridDs.proxy = new Ext.data.HttpProxy({url:gridUrl+'?actiontype=QueryUser',method:'GET'});
										StkLocUserCatGroupGridDs.load({params:{start:0,limit:StkLocUserCatGroupGridPagingToolbar.pageSize,sort:'Rowid',dir:'desc',locGrpId:LocGrpId}});
									}else{
										Msg.info("error",$g("ɾ��ʧ��!"));
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				Msg.info("error",$g("�����д�!"));
			}
		}
    }
});

var StkLocUserCatGroupGridPagingToolbar = new Ext.PagingToolbar({
    store:StkLocUserCatGroupGridDs,
	pageSize:30,
    displayInfo:true,
    displayMsg:$g('�� {0} ���� {1}�� ��һ�� {2} ��'),
    emptyMsg:$g("û�м�¼"),
	doLoad:function(C){
		var B={},
		A=this.getParams();
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B[A.sort]='Rowid';
		B[A.dir]='desc';
		B['locGrpId']=LocGrpId;
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//���
StkLocUserCatGroupGrid = new Ext.grid.EditorGridPanel({
	store:StkLocUserCatGroupGridDs,
	cm:StkLocUserCatGroupGridCm,
	trackMouseOver:true,
	height:370,
	plugins:[DefaultField,ActiveField],
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:2,
	tbar:[addStkLocUserCatGroup,'-',saveStkLocUserCatGroupGrid,'-',deleteStkLocUserCatGroupGrid],
	bbar:StkLocUserCatGroupGridPagingToolbar
});
StkLocUserCatGroupGrid.on('beforeedit',function(e){
	if(e.field=="UserId"){
		addComboData(UCG.getStore(),e.record.get("UserId"),e.record.get("Name"));
	}
})
//=========================��Աά��=============================

//=============��������������������===================
CTLocGrid.on('rowclick',function(grid,rowIndex,e){
	var selectedRow = CTLocGridDs.data.items[rowIndex];
	CTLocId = selectedRow.data["Rowid"];
	StkLocCatGroupGridDs.proxy = new Ext.data.HttpProxy({url:gridUrl+'?actiontype=Query&locId='+CTLocId,method:'GET'});
	StkLocCatGroupGridDs.load();
	StkLocUserCatGroupGrid.store.removeAll();
	LocGrpId="";
	StkLocUserCatGroupGridDs.proxy = new Ext.data.HttpProxy({url:gridUrl+'?actiontype=QueryUser',method:'GET'});
	StkLocUserCatGroupGridDs.setBaseParam('locGrpId',LocGrpId);
	StkLocUserCatGroupGridDs.load({params:{start:0,limit:StkLocUserCatGroupGridPagingToolbar.pageSize,sort:'Rowid',dir:'desc'}});
	StkLocUserCatGroupGrid.store.removeAll();
});
//=============��������������������===================

//=============������������Աά����������===================
StkLocCatGroupGrid.on('rowclick',function(grid,rowIndex,e){
	var selectedRow = StkLocCatGroupGridDs.data.items[rowIndex];
	LocGrpId = selectedRow.data["Rowid"];
	StkLocUserCatGroupGridDs.proxy = new Ext.data.HttpProxy({url:gridUrl+'?actiontype=QueryUser',method:'GET'});
	StkLocUserCatGroupGridDs.setBaseParam('locGrpId',LocGrpId);
	StkLocUserCatGroupGridDs.load({params:{start:0,limit:StkLocUserCatGroupGridPagingToolbar.pageSize,sort:'Rowid',dir:'desc'}});
	StkLocUserCatGroupGrid.store.removeAll();
});


//=============������������Աά����������===================
var HospPanel = InitHospCombo('PHA-IN-LocStkCatGrp',function(combo, record, index){
	
	HospId = this.value; 
	SCG.store.removeAll();
	SCG.store.reload();
	StkLocCatGroupGrid.store.removeAll();
	//StkLocCatGroupGrid.getView().refresh();
	StkLocUserCatGroupGrid.store.removeAll();
	//StkLocUserCatGroupGrid.getView().refresh();	
	Ext.getCmp('locCode').setValue('');
	Ext.getCmp('locName').setValue('');
	queryCTLoc.handler();

});
	

//===========ģ����ҳ��=================================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	

	var CTLocPanel = new Ext.Panel({
		id:"CTLocPanel",
		deferredRender : true,
		title:$g('������Ϣ'),
		activeTab: 0,
		region:'west',
		collapsible: true,
        split: true,
		height:328,
		width:600,
		minSize: 0,
        maxSize: 600,
        layout:'fit',
		items:[CTLocGrid]                                 
	});
	
	var StkLocCatGroupPanel = new Ext.Panel({
		id:"StkLocCatGroupPanel",
		deferredRender : true,
		title:$g('��������'),
		activeTab: 0,
		deferredRender : true,
		region:'center',
		height:328,
		width:1200,
		layout:'fit',
		items:[StkLocCatGroupGrid]                                 
	});
	
	var StkLocUserCatGroupPanel = new Ext.Panel({
		id:"StkLocUserCatGroupPanel",
		deferredRender : true,
		title:$g('��Աά��'),
		activeTab: 0,
		region:'south',
		height:300,
		layout:'fit',
		split:true,
		collapsible:true,
		items:[StkLocUserCatGroupGrid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		collapsible:true,
		split: true,
		items:[HospPanel,CTLocPanel,StkLocCatGroupPanel,StkLocUserCatGroupPanel],
		renderTo:'mainPanel'
	});

	//Ext.fly("eewwee").setStyle('padding-top','30px');
	//queryCTLoc.handler();
});

//===========ģ����ҳ��=================================================