// 名称:包装单位管理
// 编写日期:2012-05-10
//=========================定义全局变量=================================
var CtUomId = "";
//=========================定义全局变量=================================
//=========================包装单位类别=================================
var DescField = new Ext.form.TextField({
	id:'DescField',
    allowBlank:true
})

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
		}
	]);
					
	var NewRecord = new record({
		RowId:'',
		Code:'',
		Desc:''
	});
					
	CtUomGridDs.add(NewRecord);
	CtUomGrid.startEditing(CtUomGridDs.getCount() - 1, 1);
}

var CtUomGrid="";
//配置数据源
var CtUomGridUrl = 'dhcstm.ctuomaction.csp';
var CtUomGridProxy= new Ext.data.HttpProxy({url:CtUomGridUrl+'?actiontype=selectAll',method:'POST'});
var CtUomGridDs = new Ext.data.Store({
	proxy:CtUomGridProxy,
    reader:new Ext.data.JsonReader({
		totalProperty:'results',
        root:'rows'
    }, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Desc'}
	]),
	pruneModifiedRecords:true,
    remoteSort:false
});



//模型
var CtUomGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),{
        header:"代码",
        dataIndex:'Code',
        width:120,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'codeField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						CtUomGrid.startEditing(CtUomGridDs.getCount() - 1, 2);
					}
				}
			}
        })
    },{
        header:"名称",
        dataIndex:'Desc',
        width:200,
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
    }
]);

//初始化默认排序功能
CtUomGridCm.defaultSortable = true;

var queryCtUom = new Ext.Toolbar.Button({
	text:'查询',
    tooltip:'查询',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		//alert(Ext.getCmp('DescField').getValue());
		CtUomGridDs.load({params:{start:0,limit:CtUomPagingToolbar.pageSize,sort:'Rowid',dir:'desc',desc:Ext.getCmp('DescField').getValue()}});
	}
});

var addCtUom = new Ext.Toolbar.Button({
	text:'增加',
    tooltip:'增加',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var saveCtUom = new Ext.Toolbar.Button({
	text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		//获取所有的新记录 
		var mr=CtUomGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){ 
			var code = mr[i].data["Code"].trim();
			var desc = mr[i].data["Desc"].trim();
			if((code!="")&&(desc!="")){
				var dataRow = mr[i].data["RowId"]+"^"+code+"^"+desc;
				if(data==""){
					data = dataRow;
				}else{
					data = data+xRowDelim()+dataRow;
				}
			}
		}
		
		if(data==""){
			Msg.info("error","没有修改或添加新数据!");
			return false;
		}else{
			var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
			Ext.Ajax.request({
				url: CtUomGridUrl+'?actiontype=save',
				params:{data:data},
				failure: function(result, request) {
					 mask.hide();
					Msg.info("error","请检查网络连接!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success","保存成功!");
						CtUomGridDs.load({params:{start:0,limit:CtUomPagingToolbar.pageSize,sort:'Rowid',dir:'desc',desc:Ext.getCmp('DescField').getValue()}});
					}else{
						if(jsonData.info==-1){
							Msg.info("error","代码重复!");
						}else if(jsonData.info==-2){
							Msg.info("error","名称重复!");
						}else{
							Msg.info("error","保存失败"+jsonData);
						}
						CtUomGridDs.load({params:{start:0,limit:CtUomPagingToolbar.pageSize,sort:'Rowid',dir:'desc',desc:Ext.getCmp('DescField').getValue()}});
					}
				},
				scope: this
			});
		}
    }
});

var deleteCtUom = new Ext.Toolbar.Button({
	text:'删除',
    tooltip:'删除',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = CtUomGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error","请选择数据!");
			return false;
		}else{
			var record = CtUomGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('提示','确定要删除选定的行?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
							Ext.Ajax.request({
								url:CtUomGridUrl+'?actiontype=delete&rowid='+RowId,
								waitMsg:'删除中...',
								failure: function(result, request) {
									 mask.hide();
									Msg.info("error","请检查网络连接!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									 mask.hide();
									if (jsonData.success=='true') {
										Msg.info("success","删除成功!");
										CtUomGridDs.load({params:{start:0,limit:CtUomPagingToolbar.pageSize,sort:'Rowid',dir:'desc',desc:Ext.getCmp('DescField').getValue()}});
									}else{
										Msg.info("error","删除失败!");
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				Msg.info("error","数据有错!");
			}
		}
    }
});


var CtUomPagingToolbar = new Ext.PagingToolbar({
    store:CtUomGridDs,
	pageSize:30,
    displayInfo:true,
    displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg:"没有记录",
	doLoad:function(C){
		var B={},
		A=this.getParams();
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B[A.sort]='Rowid';
		B[A.dir]='desc';
		B['desc']=Ext.getCmp('DescField').getValue();
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//表格
CtUomGrid = new Ext.grid.EditorGridPanel({
	store:CtUomGridDs,
	cm:CtUomGridCm,
	trackMouseOver:true,
	height:665,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
    tbar:['描述:',DescField,'-',queryCtUom,'-',addCtUom,'-',saveCtUom],		//,'-',deleteCtUom
	clicksToEdit:1,
	bbar:[CtUomPagingToolbar]
});

//=========================包装单位类别=================================

//=========================包装单位类别转换=============================
var activeFlag = new Ext.grid.CheckColumn({
	header:'激活标志',
	dataIndex:'ActiveFlag',
	width:100,
	sortable:true,
	renderer:function(v, p, record){
		p.css += ' x-grid3-check-col-td';
		return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	}
});


var CtUomConFacGrid="";
var CTUomDesc="";

var CTUomStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({url : 'dhcstm.drugutil.csp?actiontype=CTUom',method:'POST'}),
	reader : new Ext.data.JsonReader({
		totalProperty : "results",
		root : 'rows'
	}, ['Description', 'RowId'])
});
	
//CTUomStore.on('beforeload', function(ds, o){
//	ds.proxy=new Ext.data.HttpProxy({url : 'dhcstm.drugutil.csp?actiontype=CTUom&start=0&limit=999&CTUomDesc='+Ext.getCmp('CtUomCon').getRawValue(),method:'GET'});
//});
function addNewCUCFRow() {
	var scRecord = Ext.data.Record.create([
		{
			name : 'Rowid',
			type : 'int'
		},{
			name : 'ToUomId',
			type : 'int'
		}, {
			name : 'ToUomCode',
			type : 'string'
		}, {
			name : 'ToUomDesc',
			type : 'string'
		}, {
			name : 'ConFac',
			type : 'double'
		}, {
			name : 'ActiveFlag',
			type : 'string'	//bool
		}
	]);
					
	var NewCUCFRecord = new scRecord({
		Rowid:'',
		ToUomId:'',
		ToUomCode:'',
		ToUomDesc:'',
		ConFac:'',
		ActiveFlag:'Y'	//true
	});
		
	CtUomConFacGridDs.add(NewCUCFRecord);
	CtUomConFacGrid.startEditing(CtUomConFacGridDs.getCount() - 1, 1);
}

var CtUomCon = new Ext.form.ComboBox({
	fieldLabel : '名称',
	id : 'CtUomCon',
	name : 'CtUomCon',
	anchor : '90%',
	width : 120,
	store : CTUomStore,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : false,
	triggerAction : 'all',
	emptyText : '名称...',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 10,
	listWidth : 250,
	valueNotFoundText : ''	
});	
	
CtUomCon.on('beforequery', function(e) {
	this.store.removeAll();
	this.store.setBaseParam('CTUomDesc',this.getRawValue());
	this.store.load({params:{start:0,limit:this.pageSize}});
});
//CtUomCon.on('focus',function(combo){combo.store.load();});

//配置数据源
var CtUomConFacGridUrl = 'dhcstm.ctuomaction.csp';
var CtUomConFacGridProxy= new Ext.data.HttpProxy({url:CtUomConFacGridUrl,method:'GET'});
var CtUomConFacGridDs = new Ext.data.Store({
	proxy:CtUomConFacGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [
		{name:'Rowid'},
		{name:'ToUomId'},
		{name:'ToUomCode'},
		{name:'ToUomDesc'},
		{name:'ConFac'},
		{name:'ActiveFlag'}	//,type:'bool'
	]),
	pruneModifiedRecords:true,
    remoteSort:false
});

//模型
var CtUomConFacGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),{
        header:"名称",
        dataIndex:'ToUomId',
        width:150,
        align:'left',
        sortable:true,
		renderer : Ext.util.Format.comboRenderer2(CtUomCon,"ToUomId","ToUomDesc"),
		editor:new Ext.grid.GridEditor(CtUomCon)
    },{
        header:"转换因子",
        dataIndex:'ConFac',
        width:250,
        align:'left',
        sortable:true,
		editor: new Ext.form.NumberField({
			id:'conFacField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						CtUomConFacGrid.startEditing(CtUomConFacGridDs.getCount() - 1, 3);
					}
				}
			}
        })
    },activeFlag
]);

//初始化默认排序功能
CtUomConFacGridCm.defaultSortable = true;

var addCtUomConFac = new Ext.Toolbar.Button({
	text:'增加',
    tooltip:'增加',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		if(CtUomId!=""){
			addNewCUCFRow();
		}else{
			Msg.info("warning","请选择包装单位!");
			return false;
		}
	}
});

var saveCtUomConFac = new Ext.Toolbar.Button({
	text:'保存',
    tooltip:'保存',
	width : 70,
	height : 30,
    iconCls:'page_save',
	handler:function(){
		//获取所有的新记录 
		var mr=CtUomConFacGridDs.getModifiedRecords();
		var addData="";
		var updateData="";
		for(var i=0;i<mr.length;i++){
			var rowid = mr[i].data["Rowid"].trim();
			var fac = mr[i].data["ConFac"];
			var active = mr[i].data["ActiveFlag"];
			if(rowid==""){
				var toDesc = mr[i].data["ToUomId"].trim();
				var fac = mr[i].data["ConFac"];			
				if((toDesc!="")&&(fac!="")){
					var dataRow = CtUomId+"^"+toDesc+"^"+fac+"^"+active;
					if(addData==""){
						addData = dataRow;
					}else{
						addData = addData+xRowDelim()+dataRow;
					}
				}
			}else{
				if(fac!=""){
					var dataRow = rowid+"^"+fac+"^"+active;
					if(updateData==""){
						updateData = dataRow;
					}else{
						updateData = updateData+xRowDelim()+dataRow;
					}
				}
			}
		}
		if(addData=="" && updateData==""){
			Msg.info("warning","没有修改或添加新数据!");
		}
		if(addData!=""){
			Ext.Ajax.request({
				url: CtUomConFacGridUrl+'?actiontype=addRelation',
				params:{data:addData},
				failure: function(result, request) {
					Msg.info("error","请检查网络连接!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success","保存成功!");
						CtUomConFacGridDs.load({params:{CtUomId:CtUomId}});
					}else{
						Msg.info("error","保存失败"+jsonData.info);
						CtUomConFacGridDs.load({params:{CtUomId:CtUomId}});
					}
				},
				scope: this
			});
		}
		
		if(updateData!=""){
			Ext.Ajax.request({
				url: CtUomConFacGridUrl+'?actiontype=updateRelation',
				params:{data:updateData},
				failure: function(result, request) {
					Msg.info("error","请检查网络连接!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success","保存成功!");
						CtUomConFacGridDs.load({params:{CtUomId:CtUomId}});
					}else{
						Msg.info("error","保存失败!");
						CtUomConFacGridDs.load({params:{CtUomId:CtUomId}});
					}
				},
				scope: this
			});
		}
    }
});

var deleteCtUomConFac = new Ext.Toolbar.Button({
	text:'删除',
    tooltip:'删除',
	width : 70,
	height : 30,
    iconCls:'page_delete',
	handler:function(){
		var cell = CtUomConFacGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning","请选择数据!");
			return false;
		}else{
			var record = CtUomConFacGrid.getStore().getAt(cell[0]);
			var RowId = record.get("Rowid");
			
			if(RowId!=""){
				Ext.MessageBox.confirm('提示','确定要删除选定的行?',
					function(btn) {
						if(btn == 'yes'){
							Ext.Ajax.request({
								url:CtUomConFacGridUrl+'?actiontype=deleteFac&rowid='+RowId,
								waitMsg:'删除中...',
								failure: function(result, request) {
									Msg.info("error","请检查网络连接!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true') {
										Msg.info("success","删除成功!");
										CtUomConFacGridDs.load({params:{CtUomId:CtUomId}});
									}else{
										Msg.info("error","删除失败!");
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				Msg.info("warning","数据有错,没有RowId!");
			}
		}
    }
});

//表格
CtUomConFacGrid = new Ext.grid.EditorGridPanel({
	store:CtUomConFacGridDs,
	cm:CtUomConFacGridCm,
	trackMouseOver:true,
	plugins:activeFlag,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	tbar:[addCtUomConFac,'-',saveCtUomConFac,'-',deleteCtUomConFac],
	clicksToEdit:1
});
CtUomConFacGrid.on('beforeedit',function(e){
	if(e.field=="ToUomId"){
		addComboData(CtUomCon.getStore(),e.record.get("ToUomId"),e.record.get("ToUomDesc"));
		if(e.record.get("Rowid")!=null&e.record.get("Rowid")!=""){
			e.cancel=true;   //不能修改单位
		}
	}
})
//=========================包装单位类别转换=============================

//=============包装单位类别与包装单位类别转换二级联动===================
CtUomGrid.on('rowclick',function(grid,rowIndex,e){
	//单击库存组刷新库存小类记录
	var selectedRow = CtUomGridDs.data.items[rowIndex];
	CtUomId = selectedRow.data["RowId"];
	CtUomConFacGridDs.proxy = new Ext.data.HttpProxy({url:CtUomConFacGridUrl+'?actiontype=selectCtUomConFacByCU',method:'GET'});
	CtUomConFacGridDs.load({params:{CtUomId:CtUomId}});
});
//=============包装单位类别与包装单位类别转换二级联动===================

//===========模块主页面=================================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var CtUomPanel = new Ext.Panel({
		title:'包装单位维护',
		activeTab: 0,
		region:'west',
		collapsible: true,
        split: true,
		width: 550, // give east and west regions a width
        minSize: 0,
        maxSize: 600,
        layout:'fit',
		items:[CtUomGrid]                                 
	});
	
	var CtUomConFacPanel = new Ext.Panel({
		title:'单位转换维护',
		region : 'center',
		layout : 'fit',
		items:[CtUomConFacGrid]
	});
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		renderTo:'mainPanel',
		items:[CtUomPanel,CtUomConFacPanel]
	});
	//页面加载后自动执行查询
	CtUomGridDs.load({params:{start:0,limit:CtUomPagingToolbar.pageSize,sort:'Rowid',dir:'desc',desc:Ext.getCmp('DescField').getValue()}});
});
//===========模块主页面=================================================