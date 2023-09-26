// 名称:物资对照维护
// 编写日期:2013-12-16	

//=========================物资对照=============================
var gUserId = session['LOGON.USERID'];	
var gLocId=session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];

// 类组
var StkGrpType=new Ext.ux.StkGrpComboBox({ 
	id : 'StkGrpType',
	name : 'StkGrpType',
	StkType:App_StkTypeCode,     //标识类组类型
	LocId:gLocId,
	UserId:gUserId,
	anchor:'70%'
});
// 物资inci
var Inci = new Ext.form.TextField({
	fieldLabel : 'Inci',
	id : 'Inci',
	name : 'Inci',
	anchor : '90%',
	valueNotFoundText : ''
});
// 物资名称
var InciDesc = new Ext.form.TextField({
	fieldLabel :'物资名称',
	id:'InciDesc',
	name:'InciDesc',
	anchor:'90%',
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				var stktype = Ext.getCmp("StkGrpType").getValue();
				GetPhaOrderInfo2(field.getValue(), stktype);
			}
		}
	}
});
// HIS物资代码
var HisInciCode = new Ext.form.TextField({
	fieldLabel :'HIS物资代码',
	id:'HisInciCode',
	name:'HisInciCode',
	anchor:'90%'
});
//调用药品窗体并返回结果
function GetPhaOrderInfo2(item, group) {						
	if (item != null && item.length > 0) {
	    GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", "",
						getDrugList2);
	}
}	
// 返回方法
function getDrugList2(record) {
	if (record == null || record == "") {
		return;
	}
	var inciDr = record.get("InciDr");
	var inciCode=record.get("InciCode");
	var inciDesc=record.get("InciDesc");
	Ext.getCmp("Inci").setValue(inciDr);
	Ext.getCmp("InciDesc").setValue(inciDesc);
}
function GetPhaOrderInfo(item, group) {				
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", "",
				getDrugList);
	}
}

function getDrugList(record) {
	if (record == null || record == "") {
		return;
	}
	var cell = ItmCompareGrid.getSelectionModel().getSelectedCell();
	var row = cell[0];
	var rowData = ItmCompareGrid.getStore().getAt(row);
	var inciDr = record.get("InciDr");
	var inciCode=record.get("InciCode");
	var inciDesc=record.get("InciDesc");
	var spec=record.get("Spec");
	 rowData.set("InciId",inciDr);
	 rowData.set("InciCode",inciCode);
	 rowData.set("InciDesc",inciDesc);
	 rowData.set("Spec",spec);
	 var colindex=GetColIndex(ItmCompareGrid,"HisInciCode");
	ItmCompareGrid.startEditing(cell[0],colindex);
}
var findItmCompare = new Ext.Toolbar.Button({
	text:'查询',
    tooltip:'查询',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		Query()
	}
});

var addItmCompare = new Ext.Toolbar.Button({
    text:'新建',
    tooltip:'新建',
    iconCls:'page_add',
    width : 70,
    height : 30,
    handler:function(){
	    ItmCompareGrid.store.removeAll();
        addNewRow();
    }
});
var SaveBT = new Ext.Toolbar.Button({
	id : "SaveBT",
	text : '保存',
	tooltip : '点击保存',
	width : 70,
	height : 30,
	iconCls : 'page_save',
	handler : function() {
		if(beforesave()==true){
			saveOrder();
		}
	}
});
//删除按钮
var DeleteDetail = new Ext.Toolbar.Button({
    text:'删除一条',
    tooltip:'删除一条',
    iconCls:'page_delete',
    width : 70,
    height : 30,
    handler:function(){
	    deleteDetail(); 
	}
})				
//增加一条
var AddDetail = new Ext.Toolbar.Button({
    text:'增加一条',
    tooltip:'增加一条',
    iconCls:'page_add',
    width : 70,
    height : 30,
    handler:function(){
	    addNewRow(); 
	}
})							
//模型
var nm = new Ext.grid.RowNumberer();
var ItmCompareGridCm = new Ext.grid.ColumnModel([nm,{
        header : "RowId",
		dataIndex : 'RowId',
		width : 120,
		align : 'left',
		sortable : true,
		hidden : true
	},{
		header : "InciId",
		dataIndex : 'InciId',
		width : 120,
		align : 'left',
		sortable : true,
		hidden : true
	},{
		header : "物资代码",
		dataIndex : 'InciCode',
		width : 150,
		align : 'left',
		sortable : true
	},{
        header:"物资名称",
        dataIndex:'InciDesc',
        width:250,
        align:'left',
        sortable:true,
        editor :new Ext.grid.GridEditor(new Ext.form.TextField({
			selectOnFocus : true,
			allowBlank : false,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var group = Ext.getCmp("StkGrpType").getValue();
						GetPhaOrderInfo(field.getValue(),group);					
					}
				}
			}
		}))
	},{
		header : "规格",
		dataIndex : 'Spec',
		width : 150,
		align : 'left',
		sortable : true
	},{
		header:'HIS物资代码',
	    dataIndex:'HisInciCode',
	    width:150,
	    align:'left',
	    sortable:true,
	    editor : new Ext.form.TextField({
			selectOnFocus : true,
			allowBlank : false,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					var cell = ItmCompareGrid.getSelectionModel().getSelectedCell();
					var colindex=GetColIndex(ItmCompareGrid,"HisInciDesc");
					ItmCompareGrid.startEditing(cell[0],colindex);
					}
				}
			}
		})   	     
	},{
		header:'HIs物资名称',
	    dataIndex:'HisInciDesc',
	    width:150,
	    align:'left',
	    sortable:true,
	    editor : new Ext.form.TextField({
			selectOnFocus : true,
			allowBlank : false,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					addNewRow()
					}
				}
			}
		})   
    }
]);
//初始化默认排序功能
ItmCompareGridCm.defaultSortable = true;
//保存前判断数据
function beforesave(){
	var rowCount = ItmCompareGrid.getStore().getCount();
	for (var i = 0; i < rowCount - 1; i++) {
		for (var j = i + 1; j < rowCount; j++) {
			var item_i = ItmCompareGridDs.getAt(i).get("InciId");
			var item_j = ItmCompareGridDs.getAt(j).get("InciId");
			var item_m = ItmCompareGridDs.getAt(i).get("HisInciCode");
			var item_n = ItmCompareGridDs.getAt(j).get("HisInciCode");
			if (item_i != "" && item_j != ""&& item_i == item_j) {
				changeBgColor(i, "yellow");
				changeBgColor(j, "yellow");
				Msg.info("warning", "物资维护重复，请重新输入!");
				return false;
			}
			if (item_m != "" && item_n != ""&& item_m == item_n) {
				changeBgColor(i, "yellow");
				changeBgColor(j, "yellow");
				Msg.info("warning", "HIS物资维护重复，请重新输入!");
				return false;
			}
		}
	}
	return true;
}
		// 变换行颜色
function changeBgColor(row, color) {
	ItmCompareGrid.getView().getRow(row).style.backgroundColor = color;
}

function addNewRow() {
	// 判断是否已经有添加行
	var rowCount = ItmCompareGrid.getStore().getCount();
	if (rowCount > 0) {
		var rowData = ItmCompareGridDs.data.items[rowCount - 1];
		var data = rowData.get("InciId");	
		if (data == null || data.length <= 0) {
		var inciIndex=GetColIndex(ItmCompareGrid,"InciCode");			
		ItmCompareGrid.startEditing(ItmCompareGridDs.getCount() - 1, inciIndex);
		return;
		}
	}
	
	var record = Ext.data.Record.create([{
            name : 'RowId',
            type : 'int'
        },{
            name : 'InciId',
            type : 'string'
        },{
            name : 'InciCode',
            type : 'string'
        },{
	        name : 'InciDesc',
	        type : 'string'
	    },{
	        name : 'Spec',
	        type : 'string'
	    },{
            name : 'HisInciCode',
            type : 'string'
        },{
            name : 'HisInciDesc',
            type : 'string'
        }
    ]);
    var NewRecord = new record({
	    RowId:'',
	    InciId:'',
        InciCode:'',
        InciDesc:'',
        Spec:'',
        HisInciCode:'',
        HisInciDesc:''       
    });
                    
    ItmCompareGridDs.add(NewRecord);
    var inciIndex=GetColIndex(ItmCompareGrid,"InciDesc");
    ItmCompareGrid.startEditing(ItmCompareGridDs.getCount()-1, inciIndex);
}

// 访问路径
var DetailUrl ='dhcstm.itmcompareaction.csp?actiontype=Query';
// 通过AJAX方式调用后台数据
var proxy = new Ext.data.HttpProxy({
			url : DetailUrl,
			method : "POST"
	});
		
// 指定列参数
var fields = ["RowId", "InciId", "InciCode","InciDesc","HisInciCode","HisInciDesc","Spec"];
		
// 支持分页显示的读取方式
var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "RowId",
		fields : fields
});
// 数据集
var ItmCompareGridDs = new Ext.data.Store({
		proxy : proxy,
		reader : reader
});	 
			
//保存供应项目明细
function saveOrder(){
	var ListDetail="";
	var rowCount = ItmCompareGrid.getStore().getCount();
	for (var i = 0; i < rowCount; i++) {
		var rowData = ItmCompareGridDs.getAt(i);
		//新增或数据发生变化时执行下述操作
		if(rowData.data.newRecord || rowData.dirty){			
			var RowId=rowData.get("RowId"); 
			var InciId=rowData.get("InciId");
			var InciCode=rowData.get("InciCode");	
			var InciDesc=rowData.get("InciDesc");	
			var HisInciCode=rowData.get("HisInciCode");  
			var HisInciDesc=rowData.get("HisInciDesc");    
			if(InciId==""||InciCode==""||InciDesc==""||HisInciCode==""||HisInciDesc==""){
				Msg.info("error","第"+(i+1)+"行数据不完整!");return
			}	 
			var str= RowId + "^" + InciId+"^"+InciCode+"^"+InciDesc+"^"+HisInciCode+"^"+HisInciDesc
			if(ListDetail==""){
				ListDetail=str;
			}else{
				ListDetail=ListDetail+RowDelim+str;
			}
		}
	}               
	if(ListDetail==""){
		Msg.info("error","没有修改或添加新数据!");
		return false;
	}else{
		var url ="dhcstm.itmcompareaction.csp?actiontype=Save";
		var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
		Ext.Ajax.request({
			url : url,
			method : 'POST',
			params:{ListDetail:ListDetail},
			waitMsg : '处理中...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				mask.hide();		
				if (jsonData.success == 'true') {
					// 刷新界面
					Msg.info("success", "保存成功!");
					Query()
				}else{
					var ret=jsonData.info;
					if(ret==-1){
						Msg.info("error","存在相同物资!");
					}else if(ret==-2){
						Msg.info("error","存在相同HIS物资代码!");
					}else{
						Msg.info("error", "保存不成功："+ret);
					}
				}
			},
			scope : this
		});
	}
}
           
//查询函数
function Query()
{	
	var Inci=""
	if(Ext.getCmp("InciDesc").getValue()!=""){
		var Inci=Ext.getCmp("Inci").getValue();
	}
	var stktype = Ext.getCmp("StkGrpType").getValue();
    var hisInciCode = Ext.getCmp("HisInciCode").getValue();
    ItmCompareGridDs.removeAll();
    ItmCompareGridDs.setBaseParam('Inci',Inci)
    ItmCompareGridDs.setBaseParam('stktype',stktype)
    ItmCompareGridDs.setBaseParam('gLocId',gLocId)
    ItmCompareGridDs.setBaseParam('gUserId',gUserId)
	ItmCompareGridDs.setBaseParam('hisInciCode',hisInciCode)
	ItmCompareGridDs.load({
		params:{start:0,limit:ItmComparePagingToolbar.pageSize}
	});
}
function deleteDetail()
{
	var cell = ItmCompareGrid.getSelectionModel().getSelectedCell();
	if(cell==null){
		Msg.info("error","请选择数据!");
		return false;}
	else{ var record = ItmCompareGrid.getStore().getAt(cell[0]);
		var RowId = record.get("RowId");
		if (RowId!=""){
			Ext.MessageBox.confirm('提示','确定要删除选定的行?',
			function(btn){
				if(btn=="yes"){
					var url = "dhcstm.itmcompareaction.csp?actiontype=Delete&rowid="+RowId;
					var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
					Ext.Ajax.request({
						url:url,
						waitMsg:'删除中...',
						failure: function(result, request) {
							Msg.info("error","请检查网络连接!");
							 mask.hide();
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							mask.hide();
							if (jsonData.success=='true') {
								Msg.info("success","删除成功!");
								Query()
							}
							else{
								Msg.info("error","删除失败!");
							}
						},
						scope: this
					});
					   
				}						   
			})
		}else{ 
			var rowInd=cell[0];      
			if (rowInd>=0) ItmCompareGrid.getStore().removeAt(rowInd);
		}
	}   
}
	      
var formPanel = new Ext.form.FormPanel({
	labelwidth : 30,
	autoScroll : true,
	labelAlign : 'right',
	frame : true,
	bodyStyle : 'padding:5px;',
    tbar:[findItmCompare,'-',addItmCompare,'-',SaveBT],
	items : [{
		xtype : 'fieldset',
		title : '查询条件',
		autoHeight : true,
		layout : 'column',			
		items : [{
				columnWidth : .33,
				layout : 'form',
				items : [StkGrpType]
			}, {
				columnWidth : .33,
				layout : 'form',
				items : [InciDesc]
			}, {
				columnWidth : .33,
				layout : 'form',
				items : [HisInciCode]
		}]
	}]

});

//分页工具栏
var ItmComparePagingToolbar = new Ext.PagingToolbar({
    store:ItmCompareGridDs,
	pageSize:30,
    displayInfo:true,
    displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg:"没有记录"
});

//表格
ItmCompareGrid = new Ext.grid.EditorGridPanel({
	store:ItmCompareGridDs,
	cm:ItmCompareGridCm,
	title:'物资对照明细',
	trackMouseOver:true,
	clicksToEdit:0,
	region:'center',
	height:690,
	stripeRows:true,
    sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	tbar:{items:[AddDetail,'-',DeleteDetail]},
	bbar:ItmComparePagingToolbar
});
//==========================物资对照=============================

//===========模块主页面===========================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
   
	var panel = new Ext.Panel({
		title:'物资对照维护',
		activeTab:0,
		region:'north',
		height:159,
		layout:'fit',
		items:[formPanel]                                 
	});
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[panel,ItmCompareGrid],
		renderTo:'mainPanel'
	});
});
	
//===========模块主页面===========================================