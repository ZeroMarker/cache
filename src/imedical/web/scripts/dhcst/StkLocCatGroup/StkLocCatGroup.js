// 名称:科室类组管理
// 编写日期:2012-06-14
//=========================定义全局变量=================================
var groupId = session['LOGON.GROUPID'];
var CTLocId = "";
var LocGrpId = "";
//=========================定义全局变量=================================
//=========================科室信息=================================
//科室代码
var locCode = new Ext.form.TextField({
	id:'locCode',
    allowBlank:true,
	anchor:'90%'
});
//科室名称
var locName = new Ext.form.TextField({
	id:'locName',
    allowBlank:true,
	anchor:'90%'
});

var CTLocGrid="";
//配置数据源
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

//模型
var CTLocGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:$g("代码"),
        dataIndex:'Code',
        width:200,
        align:'left',
        sortable:true
    },{
        header:$g("名称"),
        dataIndex:'Desc',
        width:200,
        align:'left',
        sortable:true
    }
]);

//初始化默认排序功能
CTLocGridCm.defaultSortable = true;

var queryCTLoc = new Ext.Toolbar.Button({
	text:$g('查询'),
    tooltip:$g('查询'),
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
    displayMsg:$g('第 {0} 条到 {1}条 ，一共 {2} 条'),
    emptyMsg:$g("没有记录"),
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

//表格
CTLocGrid = new Ext.grid.GridPanel({
	id:"CTLocGridid",
	store:CTLocGridDs,
	cm:CTLocGridCm,
	trackMouseOver:true,
	height:265,
	stripeRows:true,
	sm:new Ext.grid.RowSelectionModel({}),
	loadMask:true,
	tbar:[$g('科室代码:'),locCode,$g('科室名称:'),locName,'-',queryCTLoc],
	bbar:CTLocPagingToolbar
});
//=========================科室信息=================================

//=========================科室类组设置=============================
var defaultFlag = new Ext.grid.CheckColumn({
	header:$g('缺省标志'),
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
		Msg.info("warning",$g("请先选择科室！"));
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
	fieldLabel : $g('类组'),
	id : 'SCG',
	name : 'SCG',
	anchor : '90%',
	StkType:App_StkTypeCode,
	emptyText : $g('类组...')
});		

var StkLocCatGroupGrid="";
//配置数据源
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

//模型
var StkLocCatGroupGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
        header:$g("代码"),
        dataIndex:'GrpCode',
        width:180,
        align:'left',
        sortable:true
    },{
        header:$g("描述"),
        dataIndex:'GrpId',
        width:180,
        align:'left',
        sortable:true,
		renderer : Ext.util.Format.comboRenderer(SCG),
		editor:new Ext.grid.GridEditor(SCG)
    },defaultFlag
]);

//初始化默认排序功能
StkLocCatGroupGridCm.defaultSortable = true;

var addStkLocCatGroup = new Ext.Toolbar.Button({
	text:$g('新建'),
    tooltip:$g('新建'),
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var saveStkLocCatGroup = new Ext.Toolbar.Button({
	text:$g('保存'),
    tooltip:$g('保存'),
	width : 70,
	height : 30,
    iconCls:'page_save',
	handler:function(){
		//获取所有的新记录
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
		if(grpStr!=""){ Msg.info("error",$g("请选择类组后保存!"));	return false;;}
		if(data!=""){
			Ext.Ajax.request({
				url: gridUrl+'?actiontype=Save',
				params: {data:data,locId:CTLocId},
				failure: function(result, request) {
					Msg.info("error", $g("请检查网络连接!"));
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success", $g("保存成功!"));
						StkLocCatGroupGridDs.proxy = new Ext.data.HttpProxy({url:gridUrl+'?actiontype=Query&locId='+CTLocId,method:'GET'});
						StkLocCatGroupGridDs.load();
					}else{
						if(jsonData.info==-1){
							Msg.info("error",$g("类组重复"));
						}else{
							Msg.info("error", $g("保存失败! ")+ jsonData.info);
						}
					}
				},
				scope: this
			});
		}
    }
});

var deleteStkLocCatGroup = new Ext.Toolbar.Button({
	text:$g('删除'),
    tooltip:$g('删除'),
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = StkLocCatGroupGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error",$g("请选择数据!"));
			return false;
		}else{
			var record = StkLocCatGroupGrid.getStore().getAt(cell[0]);
			var RowId = record.get("Rowid");
			if(RowId!=""){
				Ext.MessageBox.confirm($g('提示'),$g('确定要删除选定的行?'),
					function(btn) {
						if(btn == 'yes'){
							Ext.Ajax.request({
								url:gridUrl+'?actiontype=delete&rowid='+RowId,
								waitMsg:$g('删除中...'),
								failure: function(result, request) {
									Msg.info("error",$g("请检查网络连接!"));
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true') {
										Msg.info("success",$g("删除成功!"));
										StkLocCatGroupGridDs.proxy = new Ext.data.HttpProxy({url:gridUrl+'?actiontype=Query&locId='+CTLocId,method:'GET'});
										StkLocCatGroupGridDs.load();
										StkLocUserCatGroupGridDs.reload();
									}else{
										Msg.info("error",$g("删除失败!"));
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				Msg.info("error",$g("数据有错!"));
			}
		}
    }
});

//表格
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
//=========================科室类组设置=============================
//=========================人员维护=============================
Ext.util.Format.comboRenderer = function(combo){  
    return function(value){  
       var record = combo.findRecord(combo.valueField,value);  
        return record ? record.get(combo.displayField):combo.valueNotFoundText;  
    }  
};

var DefaultField = new Ext.grid.CheckColumn({
	header:$g('是否默认'),
	dataIndex:'Default',
	width:100,
	sortable:true,
	renderer:function(v, p, record){
		p.css += ' x-grid3-check-col-td';
		return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	}
});

var ActiveField = new Ext.grid.CheckColumn({
	header:$g('是否有效'),
	dataIndex:'Active',
	width:100,
	sortable:true,
	hidden:true,  //去掉此列显示，默认Y 2020-03-02  yangsj
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
	fieldLabel : $g('名称'),
	id : 'UCG',
	name : 'UCG',
	anchor : '90%',
	width : 120,
	store : UStore,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : false,
	triggerAction : 'all',
	emptyText : $g('名称...'),
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
//配置数据源
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

//模型
var StkLocUserCatGroupGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
        header:$g("代码"),
        dataIndex:'Code',
        width:200,
        align:'left',
        sortable:true
    },{
        header:$g("名称"),
        dataIndex:'UserId',
        width:200,
        align:'left',
        sortable:true,
		renderer:Ext.util.Format.comboRenderer2(UCG,"UserId","Name"),
		editor:new Ext.grid.GridEditor(UCG)
    },DefaultField,ActiveField
]);

 

//初始化默认排序功能
StkLocUserCatGroupGridCm.defaultSortable = true;

var addStkLocUserCatGroup = new Ext.Toolbar.Button({
	text:$g('新建'),
    tooltip:$g('新建'),
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		if(LocGrpId!=""){
			addRow();
		}else{
			Msg.info("error", $g("请选择科室类组!"));
		}
	}
});

var saveStkLocUserCatGroupGrid = new Ext.Toolbar.Button({
	text:$g('保存'),
    tooltip:$g('保存'),
	width : 70,
	height : 30,
    iconCls:'page_save',
	handler:function(){
		//获取所有的新记录
		var mr=StkLocUserCatGroupGridDs.getModifiedRecords();
		var data="";
		var nameflag="";
		for(var i=0;i<mr.length;i++){
			var RowId = mr[i].data["Rowid"];
			var userId = mr[i].data["UserId"];
			var active ="Y"  // mr[i].data["Active"];  //界面不可编辑，默认为Y
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
		if(nameflag==""){	Msg.info("error",$g("没有需要保存的数据!"));	return false;;}
		
		if(data!=""){
			Ext.Ajax.request({
				url: gridUrl+'?actiontype=SaveUser',
				params: {data:data,locGrpId:LocGrpId},
				failure: function(result, request) {
					Msg.info("error", $g("请检查网络连接!"));
				},
				success: function(result, request) {
					data="";
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success",$g( "保存成功!"));
						StkLocUserCatGroupGridDs.proxy = new Ext.data.HttpProxy({url:gridUrl+'?actiontype=QueryUser',method:'GET'});
						StkLocUserCatGroupGridDs.load({params:{start:0,limit:StkLocUserCatGroupGridPagingToolbar.pageSize,sort:'Rowid',dir:'desc',locGrpId:LocGrpId}});
					}else{
						if(jsonData.info==-1){
							Msg.info("error",$g("人员重复!"));
						}else{
							Msg.info("error", $g("保存失败")+jsonData.info);
						}
					}
				},
				scope: this
			});
		}
    }
});

var deleteStkLocUserCatGroupGrid = new Ext.Toolbar.Button({
	text:$g('删除'),
    tooltip:$g('删除'),
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = StkLocUserCatGroupGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error",$g("请选择数据!"));
			return false;
		}else{
			var record = StkLocUserCatGroupGrid.getStore().getAt(cell[0]);
			var RowId = record.get("Rowid");
			if(RowId!=""){
				Ext.MessageBox.confirm($g('提示'),$g('确定要删除选定的行?'),
					function(btn) {
						if(btn == 'yes'){
							Ext.Ajax.request({
								url:gridUrl+'?actiontype=deleteUser&rowid='+RowId,
								waitMsg:$g('删除中...'),
								failure: function(result, request) {
									Msg.info("error",$g("请检查网络连接!"));
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true') {
										Msg.info("success",$g("删除成功!"));
										StkLocUserCatGroupGridDs.proxy = new Ext.data.HttpProxy({url:gridUrl+'?actiontype=QueryUser',method:'GET'});
										StkLocUserCatGroupGridDs.load({params:{start:0,limit:StkLocUserCatGroupGridPagingToolbar.pageSize,sort:'Rowid',dir:'desc',locGrpId:LocGrpId}});
									}else{
										Msg.info("error",$g("删除失败!"));
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				Msg.info("error",$g("数据有错!"));
			}
		}
    }
});

var StkLocUserCatGroupGridPagingToolbar = new Ext.PagingToolbar({
    store:StkLocUserCatGroupGridDs,
	pageSize:30,
    displayInfo:true,
    displayMsg:$g('第 {0} 条到 {1}条 ，一共 {2} 条'),
    emptyMsg:$g("没有记录"),
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

//表格
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
//=========================人员维护=============================

//=============科室与科室类组二级联动===================
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
//=============科室与科室类组二级联动===================

//=============科室类组与人员维护二级联动===================
StkLocCatGroupGrid.on('rowclick',function(grid,rowIndex,e){
	var selectedRow = StkLocCatGroupGridDs.data.items[rowIndex];
	LocGrpId = selectedRow.data["Rowid"];
	StkLocUserCatGroupGridDs.proxy = new Ext.data.HttpProxy({url:gridUrl+'?actiontype=QueryUser',method:'GET'});
	StkLocUserCatGroupGridDs.setBaseParam('locGrpId',LocGrpId);
	StkLocUserCatGroupGridDs.load({params:{start:0,limit:StkLocUserCatGroupGridPagingToolbar.pageSize,sort:'Rowid',dir:'desc'}});
	StkLocUserCatGroupGrid.store.removeAll();
});


//=============科室类组与人员维护二级联动===================
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
	

//===========模块主页面=================================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	

	var CTLocPanel = new Ext.Panel({
		id:"CTLocPanel",
		deferredRender : true,
		title:$g('科室信息'),
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
		title:$g('科室类组'),
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
		title:$g('人员维护'),
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

//===========模块主页面=================================================