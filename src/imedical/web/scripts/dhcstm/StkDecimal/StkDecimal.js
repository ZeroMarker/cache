// 名称:小数规则设置管理
// 编写日期:2012-06-4
//=========================定义全局变量=================================
var StkDecimalId = "";
//=========================定义全局变量=================================
//=========================小数规则设置=================================

var Flag = new Ext.grid.CheckColumn({
	header:'是否使用',
	dataIndex:'UseFlag',
	width:150,
	sortable:true,
	renderer:function(v, p, record){
		p.css += ' x-grid3-check-col-td';
		return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	}
});

function addNewRow() {
	var record = Ext.data.Record.create([
		{
			name : 'RowId',
			type : 'int'
		}, {
			name : 'Name',
			type : 'string'
		}, {
			name : 'Desc',
			type : 'string'
		}, {
			name : 'UseFlag',
			type : 'string'
		}
	]);
					
	var NewRecord = new record({
		RowId:'',
		Name:'',
		Desc:'',
		UseFlag:''
	});
					
	StkDecimalGridDs.add(NewRecord);
	StkDecimalGrid.startEditing(StkDecimalGridDs.getCount() - 1, 1);
}

var StkDecimalGrid="";
//配置数据源
var StkDecimalGridUrl = 'dhcstm.stkdecimalaction.csp';
var StkDecimalGridProxy= new Ext.data.HttpProxy({url:StkDecimalGridUrl+'?actiontype=selectAll',method:'GET'});
var StkDecimalGridDs = new Ext.data.Store({
	proxy:StkDecimalGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [
		{name:'RowId'},
		{name:'Name'},
		{name:'Desc'},
		{name:'UseFlag'}
	]),
	pruneModifiedRecords : true,
    remoteSort:false
});

//模型
var StkDecimalGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"名称",
        dataIndex:'Name',
        width:100,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'nameField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						StkDecimalGrid.startEditing(StkDecimalGridDs.getCount() - 1, 2);
					}
				}
			}
        })
    },{
        header:"描述",
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
    },Flag
]);

//初始化默认排序功能
StkDecimalGridCm.defaultSortable = true;

var addStkDecimal = new Ext.Toolbar.Button({
	text:'新建',
    tooltip:'新建',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});
function CheckDataBeforeSave(){
	//=====判断代码和名称是否重复输入===
		var rowCount = StkDecimalGrid.getStore().getCount();
		for (i=0;i<rowCount-1;i++){
			for(j=i+1;j<rowCount;j++){
				var item_i=StkDecimalGridDs.getAt(i).get("Name");
				var item_j=StkDecimalGridDs.getAt(j).get("Name");
				if(item_i!=""&&item_j!=""&&item_i==item_j){
					changeBgColor(i, "yellow");
					changeBgColor(j, "yellow");
					Msg.info("warning","名称输入重复!!!!");
					return false;
						}
				}
			}
		// 变换行颜色
		function changeBgColor(row, color) {
			StkDecimalGrid.getView().getRow(row).style.backgroundColor = color;
		}	
		//=====判断代码和名称是否重复输入===
	}
var saveStkDecimal = new Ext.Toolbar.Button({
	text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if(CheckDataBeforeSave()!=false){
		//获取所有的新记录 
		var mr=StkDecimalGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){ 
			var name = mr[i].data["Name"].trim();
			var desc = mr[i].data["Desc"].trim();
			var useFlag = mr[i].data["UseFlag"]
			if((name!="")&&(desc!="")){
				var dataRow = mr[i].data["RowId"]+"^"+name+"^"+desc+"^"+useFlag;
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
				url: StkDecimalGridUrl+'?actiontype=save',
				params: {data:data},

				failure: function(result, request) {
					 mask.hide();
					Msg.info("error","请检查网络连接!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success","保存成功!");
						StkDecimalGridDs.load();
					}else{
						Msg.info("error","保存失败!");
						StkDecimalGridDs.load();
					}
				},
				scope: this
			});
		}
		}
    }
});

var deleteStkDecimal = new Ext.Toolbar.Button({
	text:'删除',
    tooltip:'删除',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = StkDecimalGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error","请选择数据!");
			return false;
		}else{
			var record = StkDecimalGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('提示','确定要删除选定的行?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
							Ext.Ajax.request({
								url:StkDecimalGridUrl+'?actiontype=delete&rowid='+RowId,
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
										StkDecimalGridDs.load();
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
				//Msg.info("error","数据有错!");
				var rowInd=cell[0];		 
				if (rowInd>=0) StkDecimalGrid.getStore().removeAt(rowInd);						
			}
		}
    }
});

//表格
StkDecimalGrid = new Ext.grid.EditorGridPanel({
	store:StkDecimalGridDs,
	cm:StkDecimalGridCm,
	trackMouseOver:true,
	height:690,
	stripeRows:true,
	plugins:Flag,
	clicksToEdit:0,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
    tbar:[addStkDecimal,'-',saveStkDecimal],	//,'-',deleteStkDecimal
	clicksToEdit:1
});

StkDecimalGridDs.load();
//=========================小数规则设置=================================

//=========================规则明细=============================
var StkDecimalItmGrid="";
var StkDecimalDesc="";

function addNewMXRow() {
	var mxRecord = Ext.data.Record.create([
		{
			name : 'RowId',
			type : 'int'
		},{
			name : 'Min',
			type : 'double'
		}, {
			name : 'Max',
			type : 'double'
		}, {
			name : 'DecimalLen',
			type : 'int'
		}
	]);
					
	var MXRecord = new mxRecord({
		RowId:'',
		Min:'',
		Max:'',
		DecimalLen:''
	});
		
	StkDecimalItmGridDs.add(MXRecord);
	StkDecimalItmGrid.startEditing(StkDecimalItmGridDs.getCount() - 1, 1);
}

//配置数据源
var StkDecimalItmGridUrl = 'dhcstm.ctuomaction.csp';
var StkDecimalItmGridProxy= new Ext.data.HttpProxy({url:StkDecimalItmGridUrl,method:'GET'});
var StkDecimalItmGridDs = new Ext.data.Store({
	proxy:StkDecimalItmGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [
		{name:'RowId'},
		{name:'Min'},
		{name:'Max'},
		{name:'DecimalLen'}
	]),
    pruneModifiedRecords : true,
    remoteSort:true
});

//模型
var StkDecimalItmGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
        header:"规则下限",
        dataIndex:'Min',
        width:150,
        align:'right',
        sortable:true,
		editor: new Ext.form.NumberField({
			id:'minField',
            allowBlank:false,
			decimalPrecision:4,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						StkDecimalItmGrid.startEditing(StkDecimalItmGridDs.getCount() - 1, 2);
					}
				}
			}
        })
    },{
        header:"规则上限",
        dataIndex:'Max',
        width:150,
        align:'right',
		decimalPrecision:4,
        sortable:true,
		editor: new Ext.form.NumberField({
			id:'maxField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						StkDecimalItmGrid.startEditing(StkDecimalItmGridDs.getCount() - 1, 3);
					}
				}
			}
        })
    },{
        header:"小数位数",
        dataIndex:'DecimalLen',
        width:150,
        align:'right',
        sortable:true,
		editor: new Ext.form.NumberField({
			id:'decimalLenField',
            allowBlank:false,
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

//初始化默认排序功能
StkDecimalItmGridCm.defaultSortable = true;

var addStkDecimalItm = new Ext.Toolbar.Button({
	text:'新建',
    tooltip:'新建',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		if(StkDecimalId!=""){
			addNewMXRow();
		}else{
			Msg.info("error", "请选择规则!");
			return false;
		}
	}
});
function CheckDataBeforeSave2(){
	
	var mr=StkDecimalItmGridDs.getModifiedRecords();
	for(var i=0;i<mr.length;i++){
		var rowid = mr[i].data["RowId"];
			
			var min = mr[i].data["Min"];
			var max = mr[i].data["Max"];
			var len = mr[i].data["DecimalLen"];
			var rows=StkDecimalItmGridDs.indexOf(mr[i])+1
			if(min>max){
			Msg.info('warning', '第'+rows+'行规则上限不能小于规则下限！');
					return false;
					}
		}
	}
var saveStkDecimalItm = new Ext.Toolbar.Button({
	text:'保存',
    tooltip:'保存',
	width : 70,
	height : 30,
    iconCls:'page_save',
	handler:function(){
		if(CheckDataBeforeSave2()!=false){
		//获取所有的新记录 
		var mr=StkDecimalItmGridDs.getModifiedRecords();
		var addData="";
		for(var i=0;i<mr.length;i++){
			var rowid = mr[i].data["RowId"];
			
			var min = mr[i].data["Min"];
			var max = mr[i].data["Max"];
			var len = mr[i].data["DecimalLen"];
			if((min!=""||min=="0")&&(max!=""||max=="0")&&(len!=""||len=="0")){
				var dataRow = rowid+"^"+StkDecimalId+"^"+min+"^"+max+"^"+len;
				if(addData==""){
					addData = dataRow;
				}else{
					addData = addData+xRowDelim()+dataRow;
				}
			}
		}
		
		if(addData==""){Msg.info("error","没有修改或添加新数据！")}
		else{
			var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
			Ext.Ajax.request({
				url: StkDecimalGridUrl+'?actiontype=addRelation',
				params: {data:addData},
				failure: function(result, request) {
					 mask.hide();
					Msg.info("error", "请检查网络连接!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success", "保存成功!");
						StkDecimalItmGridDs.load({params:{StkDecimalId:StkDecimalId}});
					}else{
						Msg.info("error", "保存失败!");
						StkDecimalItmGridDs.load({params:{StkDecimalId:StkDecimalId}});
					}
				},
				scope: this
			});
		}
		}
    }
});

var deleteStkDecimalItm = new Ext.Toolbar.Button({
	text:'删除',
    tooltip:'删除',
	width : 70,
	height : 30,
    iconCls:'page_delete',
	handler:function(){
		var cell = StkDecimalItmGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error", "请选择数据!");
			return false;
		}else{
			var record = StkDecimalItmGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('提示','确定要删除选定的行?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
							Ext.Ajax.request({
								url:StkDecimalGridUrl+'?actiontype=deleteChild&rowid='+RowId,
								waitMsg:'删除中...',
								failure: function(result, request) {
									 mask.hide();
									Msg.info("error", "请检查网络连接!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									 mask.hide();
									if (jsonData.success=='true') {
										Msg.info("success", "删除成功!");
										StkDecimalItmGridDs.load({params:{StkDecimalId:StkDecimalId}});
									}else{
										Msg.info("error", "删除失败!");
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				//Msg.info("error", "数据有错,没有RowId!");
				var rowInd=cell[0];		 
				if (rowInd>=0) StkDecimalItmGrid.getStore().removeAt(rowInd);						
			}
		}
    }
});

//表格
StkDecimalItmGrid = new Ext.grid.EditorGridPanel({
	store:StkDecimalItmGridDs,
	cm:StkDecimalItmGridCm,
	trackMouseOver:true,
	height:690,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
    tbar:[addStkDecimalItm,'-',saveStkDecimalItm,'-',deleteStkDecimalItm],
	clicksToEdit:1
});
//=========================规则明细=============================

//=============小数规则设置与规则明细二级联动===================
StkDecimalGrid.on('rowclick',function(grid,rowIndex,e){
	//单击库存组刷新库存小类记录
	var selectedRow = StkDecimalGridDs.data.items[rowIndex];
	StkDecimalId = selectedRow.data["RowId"];
	StkDecimalItmGridDs.proxy = new Ext.data.HttpProxy({url:StkDecimalGridUrl+'?actiontype=selectChild',method:'GET'});
	StkDecimalItmGridDs.load({params:{StkDecimalId:StkDecimalId}});
});
//=============小数规则设置与规则明细二级联动===================

//===========模块主页面=================================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var StkDecimalPanel = new Ext.Panel({
		deferredRender : true,
		title:'小数规则设置',
		activeTab: 0,
		region:'west',
		width:500,
		collapsible: true,
        split: true,
		minSize: 0,
        maxSize: 600,
		items:[StkDecimalGrid]                                 
	});
	
	var StkDecimalItmPanel = new Ext.Panel({
		deferredRender : true,
		title:'规则明细',
		activeTab: 0,
		region:'center',
		layout:'fit',
		items:[StkDecimalItmGrid]                                 
	});
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		collapsible:true,
		split: true,
		items:[StkDecimalPanel,StkDecimalItmPanel],
		renderTo:'mainPanel'
	});
});
//===========模块主页面=================================================