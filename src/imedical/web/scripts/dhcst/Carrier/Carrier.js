// 名称:配送商管理
// 编写日期:2012-05-10

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
                    
    CarrierGridDs.add(NewRecord);
    CarrierGrid.startEditing(CarrierGridDs.getCount() - 1, 1);
}
    
var CarrierGrid="";
//配置数据源
var CarrierGridUrl = 'dhcst.carrieraction.csp';
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
        {name:'Desc'}
       
        
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
        CarrierGridDs.load({params:{start:0,limit:CarrierPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:conditionCode,conditionDesc:conditionDesc,conditionType:conditionType}});
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
            if((code!="")&&(desc!="")){
                var dataRow = mr[i].data["RowId"]+"^"+code+"^"+desc+"^"+type;
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
        }
       
        else{
            Ext.Ajax.request({
                url: CarrierGridUrl+'?actiontype=save',
                params: {data:data},
                failure: function(result, request) {
                    Msg.info("error", "请检查网络连接!");
                },
                success: function(result, request) {
                    var jsonData = Ext.util.JSON.decode( result.responseText );
                    if (jsonData.success=='true') {
                        Msg.info("success", "保存成功!");
                        CarrierGridDs.load({params:{start:0,limit:CarrierPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionDesc:Ext.getCmp('conditionDescField').getValue(),conditionType:App_StkTypeCode}});
                    }else{	                    
						var date=jsonData.info
						if(date==-1){
							Msg.info("error", "代码重复!");}
						else if(date==-2){
							Msg.info("error", "名称重复!" );}
						else {
							Msg.info("error", "保存失败！" );
						}                       
                        CarrierGridDs.load({params:{start:0,limit:CarrierPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionDesc:Ext.getCmp('conditionDescField').getValue(),conditionType:App_StkTypeCode}});
                    }
                },
                scope: this
            });
        }
    }
});

var saveAsCarrier = new Ext.Toolbar.Button({
	text:'另存',
	iconCls:'page_excel',
	handler:function(){
		ExportAllToExcel(CarrierGrid);
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
                            Ext.Ajax.request({
                                url:CarrierGridUrl+'?actiontype=delete&rowid='+RowId,
                                waitMsg:'删除中...',
                                failure: function(result, request) {
                                    Msg.info("error", "请检查网络连接!");
                                },
                                success: function(result, request) {
                                    var jsonData = Ext.util.JSON.decode( result.responseText );
                                    if (jsonData.success=='true') {
                                        Msg.info("success", "删除成功!");
                                        CarrierGridDs.load({params:{start:0,limit:CarrierPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionDesc:Ext.getCmp('conditionDescField').getValue(),conditionType:App_StkTypeCode}});
                                    }else{
                                        if(jsonData.info==-1){
                                            Msg.info("error", "配送商在药品定义里使用过，不能删除!");
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

var formPanel = new Ext.form.FormPanel({
    labelWidth : 50,
    autoScroll:true,
    labelAlign : 'right',
    frame : true,
    autoHeight:true,
    tbar:[findCarrier,'-',addCarrier,'-',saveCarrier,'-',saveAsCarrier],		//,'-',deleteCarrier
    items : [{
        xtype : 'fieldset',
        title : '查询条件',
        defaults: {border:false},
		style:DHCSTFormStyle.FrmPaddingV,
        layout : 'column',
        items : [{
            columnWidth : .33,
            xtype : 'fieldset',
            items : [conditionCodeField]
        }, {
            columnWidth : .33,
            xtype : 'fieldset',
            items : [conditionDescField]
        }]
    }]
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
        if(this.fireEvent("beforechange",this,B)!==false){
            this.store.load({params:B});
        }
    }
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

CarrierGridDs.load({params:{start:0,limit:CarrierPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionDesc:Ext.getCmp('conditionDescField').getValue(),conditionType:App_StkTypeCode}});

var HospPanel = InitHospCombo('DHC_Carrier',function(combo, record, index){
	HospId = this.value; 
	CarrierGridDs.reload();
});


//=========================配送商类别=============================

//===========模块主页面===============================================
Ext.onReady(function(){
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
     var panel = new Ext.Panel({
        title:'配送商维护',
        activeTab:0,
        region:'north',
        height:DHCSTFormStyle.FrmHeight(1),
        layout:'fit',
        items:[formPanel]                                 
    });
    
    var mainPanel = new Ext.Viewport({
        layout:'border',
		items:[
			{
				region:'north',
				height:'500px',
				items:[HospPanel,panel]
			},CarrierGrid
		],
        renderTo:'mainPanel'
    });
});
//===========模块主页面===============================================