// 名称:配送商管理
// 编写日期:2012-05-10
var MPNumber = "";
//=========================配送商类别=============================
var conditionCodeField = new Ext.form.TextField({
    id:'conditionCodeField',
    fieldLabel:'代码',
    allowBlank:true,
    //width:180,
    listWidth:180,
    emptyText:'代码...',
    anchor:'90%',
    selectOnFocus:true
});

var conditionDescField = new Ext.form.TextField({
    id:'conditionDescField',
    fieldLabel:'名称',
    allowBlank:true,
    //width:150,
    listWidth:150,
    emptyText:'名称...',
    anchor:'90%',
    selectOnFocus:true
});
var conditionMPNumberField = new Ext.form.TextField({
	id:'conditionMPNumberField',
	fieldLabel:'手机号',
	allowBlank:true,
	listWidth:150,
	emptyText:'手机号……',
	anchor:'90%',
	selectOnFocus:true
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
        },{
	        name : 'MPNumber',
	        type : 'string'
	        }
    ]);
                    
    var NewRecord = new record({
        RowId:'',
        Code:'',
        Desc:'',
        MPNumber:''
    });
                    
    CarrierGridDs.add(NewRecord);
    CarrierGrid.startEditing(CarrierGridDs.getCount() - 1, 1);
}
    
var CarrierGrid="";
//配置数据源
var CarrierGridUrl = 'dhcstm.carrieraction.csp';
var CarrierGridProxy= new Ext.data.HttpProxy({url:CarrierGridUrl+'?actiontype=query',method:'POST'});
var CarrierGridDs = new Ext.data.Store({
    proxy:CarrierGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
        totalProperty:'results',
        pageSize:35
    }, [
        {name:'RowId'},
        {name:'Code'},       
        {name:'Desc'},
        {name:'MPNumber'}
        
        
    ]),
    remoteSort:false,
    pruneModifiedRecords:true
});

//模型
var CarrierGridCm = new Ext.grid.ColumnModel([
     new Ext.grid.RowNumberer(),
     {
        header:"代码",
        dataIndex:'Code',
        width:180,
        align:'left',
        sortable:true,
        editor: new Ext.form.TextField({
            id:'codeField',
            allowBlank:false,
            listeners:{
                specialKey:function(field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        CarrierGrid.startEditing(CarrierGridDs.getCount() - 1, 2);
                    }
                }
            }
        })
    },{
        header:"名称",
        dataIndex:'Desc',
        width:300,
        align:'left',
        sortable:true,
        editor: new Ext.form.TextField({
            id:'descField',
            allowBlank:false,
            listeners:{
                specialKey:function(field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                       CarrierGrid.startEditing(CarrierGridDs.getCount() - 1, 3);
                    }
                }
            }
        })
        
    },{
	   
        header:"手机号",
        id:'MPNumber',
        dataIndex:'MPNumber',
        width:300,
        align:'left',
        sortable:true,
        editor: new Ext.form.TextField({
            id:'numberField',
            allowBlank:true,
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
CarrierGridCm.defaultSortable = true;

var findCarrier = new Ext.Toolbar.Button({
    text:'查询',
    tooltip:'查询',
    iconCls:'page_find',
    width : 70,
    height : 30,
    handler:function(){
        var conditionCode = Ext.getCmp('conditionCodeField').getValue();
        var conditionDesc = Ext.getCmp('conditionDescField').getValue();
        var conditionType=App_StkTypeCode;
        var MPNumber = Ext.getCmp('conditionMPNumberField').getValue();
        CarrierGridDs.load({params:{start:0,limit:CarrierPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:conditionCode,conditionDesc:conditionDesc,conditionType:conditionType,MPNumber:MPNumber}});
    }
});

var addCarrier = new Ext.Toolbar.Button({
    text:'新建',
    tooltip:'新建',
    iconCls:'page_add',
    width : 70,
    height : 30,
    handler:function(){
        addNewRow();
    }
});

var saveCarrier = new Ext.Toolbar.Button({
    text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
    width : 70,
    height : 30,
    handler:function(){
        //获取所有的新记录 
        var mr=CarrierGridDs.getModifiedRecords();
        var data="";
        for(var i=0;i<mr.length;i++){
            var code = mr[i].data["Code"].trim();
            var desc = mr[i].data["Desc"].trim();
            var type = App_StkTypeCode;
            var MPNumber = mr[i].data["MPNumber"].trim();
            
            /*var reg =/^0{0,1}(13[0-9]|15[0-9]|18[3-9])[0-9]{8}$/;      ///正则表达式匹配手机号
            if(!reg.test(MPNumber)) 
        { 
        
           
            alert("您的手机号码不正确，请重新输入"); 
            //CarrierGridDs.load({params:{start:0,limit:CarrierPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionDesc:Ext.getCmp('conditionDescField').getValue(),conditionType:App_StkTypeCode,MPNumber:MPNumber}});
            return ; 
        }*/ 
           
            if((code!="")&&(desc!="")){
                var dataRow = mr[i].data["RowId"]+"^"+code+"^"+desc+"^"+type+"^"+MPNumber;
                if(data==""){
                    data = dataRow;
                }else{
                    data = data+xRowDelim()+dataRow;
                }
            }
        }
        
        if(data==""){
            Msg.info("error", "没有修改或添加新数据!");
            return false;
        }else{
        	var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
            Ext.Ajax.request({
                url: CarrierGridUrl+'?actiontype=save',
                params: {data:data},
                failure: function(result, request) {
                	 mask.hide();
                    Msg.info("error", "请检查网络连接!");
                },
                success: function(result, request) {
                    var jsonData = Ext.util.JSON.decode( result.responseText );
                     mask.hide();
                    if (jsonData.success=='true') {
                        Msg.info("success", "保存成功!");
                        CarrierGridDs.load({params:{start:0,limit:CarrierPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionDesc:Ext.getCmp('conditionDescField').getValue(),conditionType:App_StkTypeCode,MPNumber:MPNumber}});
                    }else{
	                    if(jsonData.info==-1){
							Msg.info("error", "代码重复!");
						}else if(jsonData.info==-2){
							Msg.info("error", "名称重复!");
						}else{
							 Msg.info("error", "保存失败!" +jsonData.info);
						}
                        CarrierGridDs.load({params:{start:0,limit:CarrierPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionDesc:Ext.getCmp('conditionDescField').getValue(),conditionType:App_StkTypeCode,MPNumber:MPNumber}});
                    }
                },
                scope: this
            });
        }
    }
});

var saveAs = new Ext.Toolbar.Button({
	text:'另存',
	height:30,
	width:70,
	iconCls:'page_save',
	handler:function(){
		gridSaveAsExcel(CarrierGrid);
	}

});


var deleteCarrier = new Ext.Toolbar.Button({
    text:'删除',
    tooltip:'删除',
    iconCls:'page_delete',
    width : 70,
    height : 30,
    handler:function(){
        var cell = CarrierGrid.getSelectionModel().getSelectedCell();
        if(cell==null){
            Msg.info("error", "请选择数据!");
            return false;
        }else{
            var record = CarrierGrid.getStore().getAt(cell[0]);
            var RowId = record.get("RowId");
            if(RowId!=""){
                Ext.MessageBox.confirm('提示','确定要删除选定的行?',
                    function(btn) {
                        if(btn == 'yes'){
                        	var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
                            Ext.Ajax.request({
                                url:CarrierGridUrl+'?actiontype=delete&rowid='+RowId,
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
                                        CarrierGridDs.load({params:{start:0,limit:CarrierPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionDesc:Ext.getCmp('conditionDescField').getValue(),conditionType:App_StkTypeCode}});
                                    }else{
                                        if(jsonData.info==-1){
                                            Msg.info("error", "配送商在物资定义里使用过，不能删除!");
                                        }else{
                                            Msg.info("error", "删除失败!");
                                        }
                                    }
                                },
                                scope: this
                            });
                        }
                    }
                )
            }else{
                Msg.info("error", "数据有错,没有RowId!");
            }
        }
    }
});

//分页工具栏
var CarrierPagingToolbar = new Ext.PagingToolbar({
    store:CarrierGridDs,
    pageSize:35,
    displayInfo:true,
    displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg:"没有记录",
    doLoad:function(C){
        var B={},
        A=this.getParams();
        B[A.start]=C;
        B[A.limit]=this.pageSize;
        B[A.sort]='RowId';
        B[A.dir]='desc';
        B['conditionCode']=Ext.getCmp('conditionCodeField').getValue();
        B['conditionDesc']=Ext.getCmp('conditionDescField').getValue();
        B['conditionType']=App_StkTypeCode;
        B['MPNumber']=MPNumber;
        if(this.fireEvent("beforechange",this,B)!==false){
            this.store.load({params:B});
        }
    }
});
   //var CarrierGridUrl = 'dhcstm.carrieraction.csp';
var CarrierGridProxy= new Ext.data.HttpProxy({url:CarrierGridUrl+'?actiontype=select',method:'POST'});
 var DrugInfoGridds = new Ext.data.Store({
    proxy:CarrierGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
        totalProperty:'results',
        pageSize:35
    }, [
        {name:'InciRowid'},
        {name:'InciCode'},       
        {name:'InciDesc'},
        {name:'Spec'},
        {name:'Manf'},
        {name:'PurUom'},       
        {name:'BUom'},
        {name:'StkCat'},
        {name:'Rp'},
        {name:'Sp'}
    ]),
    remoteSort:false,
    pruneModifiedRecords:true
});
var nm = new Ext.grid.RowNumberer();
	
var DrugInfoCm = new Ext.grid.ColumnModel([nm, 
	{
		header : "库存项id",
		dataIndex : 'InciRowid',
		width : 80,
		align : 'left',
		sortable : true,
		hidden : true,
		hideable : false
	}, {
		header : "物资代码",
		dataIndex : 'InciCode',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : '物资名称',
		dataIndex : 'InciDesc',
		width : 200,
		align : 'left',
		sortable : true
	}, {
		header : "规格",
		dataIndex : 'Spec',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : '入库单位',
		dataIndex : 'PurUom',
		width : 70,
		align : 'left',
		sortable : true
	}, {
		header : "基本单位",
		dataIndex : 'BUom',
		width : 80,
		align : 'left',
		sortable : true
	},  {
		header : "库存分类",
		dataIndex : 'StkCat',
		width : 150,
		align : 'left',
		sortable : true
	},  {
		header : "进价",
		dataIndex : 'Rp',
		width : 150,
		align : 'left',
		sortable : true
	},  {
		header : "售价",
		dataIndex : 'Sp',
		width : 150,
		align : 'left',
		sortable : true
	}
]);
DrugInfoCm.defaultSortable = true;

var CarrierPagingToolbar = new Ext.PagingToolbar({
	store : CarrierGridDs,
	pageSize : 30,
	displayInfo : true,
	displayMsg : '当前记录 {0} -- {1} 条 共 {2} 条记录',
	emptyMsg : "No results to display",
	prevText : "上一页",
	nextText : "下一页",
	refreshText : "刷新",
	lastText : "最后页",
	firstText : "第一页",
	beforePageText : "当前页",
	afterPageText : "共{0}页",
	emptyMsg : "没有数据"
});
		
var DrugInfoGrid = new Ext.grid.GridPanel({
	id:'DrugInfoGrid',
	title:'配送物资明细',
	region:'south',
	height:200,
	width : 200,
	autoScroll:true,
	cm:DrugInfoCm,
	store:DrugInfoGridds,
	trackMouseOver : true,
	stripeRows : true,
	sm : new Ext.grid.RowSelectionModel({singleSelect:false}),
	loadMask : true,
	bbar:CarrierPagingToolbar		
});

//表格
CarrierGrid = new Ext.grid.EditorGridPanel({
    store:CarrierGridDs,
    title:'配送商明细',
    cm:CarrierGridCm,
    trackMouseOver:true,
    region:'center',
    height:690,
    stripeRows:true,
    sm:new Ext.grid.CellSelectionModel({}),
    loadMask:true,
    bbar:CarrierPagingToolbar,
    clicksToEdit:1
});
CarrierGridDs.load({params:{start:0,limit:CarrierPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionDesc:Ext.getCmp('conditionDescField').getValue(),conditionType:App_StkTypeCode,MPNumber:MPNumber}});

var formPanel = new Ext.ux.FormPanel({
	title:'配送商维护',
    tbar:[findCarrier,'-',addCarrier,'-',saveCarrier,'-',saveAs],		//,'-',deleteCarrier
    items : [{
		xtype : 'fieldset',
		title : '查询条件',
		layout : 'column',	
		style : 'padding:5px 0px 0px 5px',
		defaults:{border:false,columnWidth : .3,xtype:'fieldset'},
		items : [{
				items : [conditionCodeField]
			}, {
				items : [conditionDescField]
			},{
				items : [conditionMPNumberField]	
		}]
    }]
});

//==== 添加表格选取行事件=============//
CarrierGrid.on('rowclick',function(grid,rowIndex,e){
	var selectedRow = CarrierGridDs.data.items[rowIndex];
	tmpSelectedScheme=selectedRow.data['RowId'];
	DrugInfoGridds.proxy = new Ext.data.HttpProxy({url: CarrierGridUrl+'?actiontype=select&rowid='+tmpSelectedScheme,method:'POST'});
	DrugInfoGridds.load({params:{start:0,limit:CarrierPagingToolbar.pageSize,sort:'RowId',dir:'desc',rowid:tmpSelectedScheme}});
});	

//=========================配送商类别=============================

//===========模块主页面===============================================
Ext.onReady(function(){
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    
    var mainPanel = new Ext.ux.Viewport({
        layout:'border',
        items:[formPanel,CarrierGrid,DrugInfoGrid],
        renderTo:'mainPanel'
    });
});
	