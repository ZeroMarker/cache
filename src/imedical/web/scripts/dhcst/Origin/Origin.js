// 名称:产地管理
// 编写日期:2012-05-10

var OriginGridUrl = 'dhcst.originaction.csp';
GetParamCommon();
var conditionCodeField = new Ext.form.TextField({
    id:'conditionCodeField',
    fieldLabel:'代码',
    allowBlank:true,
    emptyText:'代码...',
    anchor:'90%',
    selectOnFocus:true
});
var conditionDescField = new Ext.form.TextField({
    id:'conditionDescField',
    fieldLabel:'名称',
    allowBlank:true,
    emptyText:'名称...',
    anchor:'90%',
    selectOnFocus:true
});

var conditionAliasField = new Ext.form.TextField({
    id:'conditionAliasField',
    fieldLabel:'别名',
    allowBlank:true,
    emptyText:'别名...',
    anchor:'90%',
    selectOnFocus:true
});

var conditionHospField = new Ext.ux.ComboBox({
	fieldLabel : '医院',
	id : 'conditionHospField',
	store : HospStore,
	allowBlank:true,
	emptyText:'医院...',
	anchor:'90%',
	selectOnFocus:true,
	hidden:true
});

var HospGirdField = new Ext.ux.ComboBox({
	fieldLabel : '医院',
	id : 'HospGirdField',
	store : HospStore,
	listeners:{
		specialKey:function(field, e) {
			if(e.getKey() == Ext.EventObject.ENTER){
				addNewRow();
			}
		}
	}
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
        }, {
            name : 'Alias',
            type : 'string'
        }, {
            name : 'HospId',
            type : 'string'
        },{
	    	name : 'HospDesc' ,
	    	type : 'string'
	    }
    ]);
                    
    var NewRecord = new record({
        RowId:'',
        Code:'',
        Desc:'',
        Alias:'',
        HospId:'',
        HospDesc:''
    });        
    OriginGridDs.add(NewRecord);
	var lastRow = OriginGridDs.getCount() - 1;
	if ( gParamCommon[6]!=2){
		var rowData = OriginGrid.getStore().getAt(lastRow);
		addComboData(HospGirdField.getStore(),session['LOGON.HOSPID'],App_LogonHospDesc);
		rowData.set("HospId", session['LOGON.HOSPID']); 
	}  
    OriginGrid.startEditing(OriginGridDs.getCount() - 1, 1);
}
    
var OriginGrid="";
//配置数据源
var OriginGridProxy= new Ext.data.HttpProxy({url:OriginGridUrl+'?actiontype=query',method:'POST'});
var OriginGridDs = new Ext.data.Store({
    proxy:OriginGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
        totalProperty:'results',
        pageSize:30
    }, [
        {name:'RowId'},
        {name:'Code'},       
        {name:'Desc'},
        {name:'Alias'},
        {name:'HospId'},
        {name:'HospDesc'} 
        
    ]),
    remoteSort:false,
    pruneModifiedRecords:true
});

//模型
var OriginGridCm = new Ext.grid.ColumnModel([
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
                        OriginGrid.startEditing(OriginGridDs.getCount() - 1, 2);
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
                        OriginGrid.startEditing(OriginGridDs.getCount() - 1, 3);
                    }
                }
            }
        })
    },{
        header:"别名",
        dataIndex:'Alias',
        width:300,
        align:'left',
        sortable:true,
        editor: new Ext.form.TextField({
            id:'aliasField',
            allowBlank:true,
            listeners:{
                specialKey:function(field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        OriginGrid.startEditing(OriginGridDs.getCount() - 1, 4);
                    }
                }
            }
        })
    },{
        header:"医院",
        dataIndex:'HospId',
        width:300,
        align:'left',
        sortable:true,
		hidden:true,
        editor: new Ext.grid.GridEditor(HospGirdField),
		renderer:Ext.util.Format.comboRenderer2(HospGirdField,'HospId','HospDesc')
	}  
]);

//初始化默认排序功能
OriginGridCm.defaultSortable = true;

var findOrigin = new Ext.Toolbar.Button({
    text:'查询',
    tooltip:'查询',
    iconCls:'page_find',
    width : 70,
    height : 30,
    handler:function(){
	    QueryOrigin();
    }
});

var addOrigin = new Ext.Toolbar.Button({
    text:'新建',
    tooltip:'新建',
    iconCls:'page_add',
    width : 70,
    height : 30,
    handler:function(){
        addNewRow();
    }
});

var saveOrigin = new Ext.Toolbar.Button({
    text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
    width : 70,
    height : 30,
    handler:function(){
        //获取所有的新记录 
        var mr=OriginGridDs.getModifiedRecords();
        var data="";
        for(var i=0;i<mr.length;i++){
            var code = mr[i].data["Code"].trim();
            var desc = mr[i].data["Desc"].trim();
            var type = App_StkTypeCode;
            var alias = mr[i].data["Alias"].trim();
            var hospId=mr[i].data["HospId"].trim();
            if (code==""){
	             Msg.info("warning", "代码为空");
            	return false;       
	        }
	        if (desc==""){
		       	Msg.info("warning", "名称为空");
            	return false;
		    }
            if((code!="")&&(desc!="")){
                var dataRow = mr[i].data["RowId"]+"^"+code+"^"+desc+"^"+type+"^"+alias+"^"+hospId;
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
            Ext.Ajax.request({
                url: OriginGridUrl+'?actiontype=save',
                params: {data:data},
                failure: function(result, request) {
                    Msg.info("error", "请检查网络连接!");
                },
                success: function(result, request) {
                    var jsonData = Ext.util.JSON.decode( result.responseText );
                    if (jsonData.success=='true') {
                        Msg.info("success", "保存成功!");
                        OriginGridDs.load({params:{start:0,limit:OriginPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionDesc:Ext.getCmp('conditionDescField').getValue(),conditionType:App_StkTypeCode}});
                    }else{
                        Msg.info("error", "保存失败!" +jsonData.info);
                        //OriginGridDs.load({params:{start:0,limit:OriginPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionDesc:Ext.getCmp('conditionDescField').getValue(),conditionType:App_StkTypeCode}});
                    }
                },
                scope: this
            });
        }
    }
});

var saveAsOrigin = new Ext.Toolbar.Button({
	text:'另存',
	iconCls:'page_excel',
	handler:function(){
		ExportAllToExcel(OriginGrid);
	}
});


var deleteOrigin = new Ext.Toolbar.Button({
    text:'删除',
    tooltip:'删除',
    iconCls:'page_delete',
    width : 70,
    height : 30,
    handler:function(){
        var cell = OriginGrid.getSelectionModel().getSelectedCell();
        if(cell==null){
            Msg.info("error", "请选择数据!");
            return false;
        }else{
            var record = OriginGrid.getStore().getAt(cell[0]);
            var RowId = record.get("RowId");
            if(RowId!=""){
                Ext.MessageBox.confirm('提示','确定要删除选定的行?',
                    function(btn) {
                        if(btn == 'yes'){
                            Ext.Ajax.request({
                                url:OriginGridUrl+'?actiontype=delete&rowid='+RowId,
                                waitMsg:'删除中...',
                                failure: function(result, request) {
                                    Msg.info("error", "请检查网络连接!");
                                },
                                success: function(result, request) {
                                    var jsonData = Ext.util.JSON.decode( result.responseText );
                                    if (jsonData.success=='true') {
                                        Msg.info("success", "删除成功!");
                                        OriginGridDs.load({params:{start:0,limit:OriginPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionDesc:Ext.getCmp('conditionDescField').getValue(),conditionType:App_StkTypeCode}});
                                    }else{
                                        if(jsonData.info==-1){
                                            Msg.info("error", "产地在药品定义里使用过，不能删除!");
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

var HospWinButton = GenHospWinButton("PH_Manufacturer");

//绑定点击事件
HospWinButton.on("click" , function(){
	var cell = OriginGrid.getSelectionModel().getSelectedCell();
	if(cell==null){
		Msg.info("warning", "请选择数据!");
		return;
	}
	var record = OriginGrid.getStore().getAt(cell[0]);
	var rowID = record.get("RowId");
	if (rowID===''){
		Msg.info("warning","请先保存数据!");
		return;	
	}
    GenHospWin("DHC_STOrigin",rowID,function(){OriginGridDs.reload();}).show() 
});

var HospPanel = InitHospCombo('DHC_STOrigin',function(combo, record, index){
	HospId = this.value; 
	OriginGridDs.reload();
});

var formPanel = new Ext.form.FormPanel({
    labelWidth : 50,
    autoScroll:true,
    labelAlign : 'right',
    frame : true,
    autoScroll : true,
    autoHeight:true,
    tbar:[findOrigin,'-',addOrigin,'-',saveOrigin,'-',saveAsOrigin,'-',HospWinButton],
    items : [{
        xtype : 'fieldset',
        title : '查询条件',
        defaults: {border:false},
		style:DHCSTFormStyle.FrmPaddingV,
        layout : 'column',
        items : [{
            columnWidth : .25,
            xtype : 'fieldset',
            items : [conditionCodeField]
        }, {
            columnWidth : .25,
            xtype : 'fieldset',
            items : [conditionDescField]
        }, {
            columnWidth : .25,
            xtype : 'fieldset',
            items : [conditionAliasField]
        }, {
            columnWidth : .25,
            xtype : 'fieldset',
            items : [conditionHospField]
        }]
    }]
});

//分页工具栏
var OriginPagingToolbar = new Ext.PagingToolbar({
    store:OriginGridDs,
    pageSize:35,
    displayInfo:true,
    displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg:"没有记录"
});

//表格
OriginGrid = new Ext.grid.EditorGridPanel({
    store:OriginGridDs,
    title:'产地明细',
    cm:OriginGridCm,
    trackMouseOver:true,
    region:'center',
    height:690,
    stripeRows:true,
    sm:new Ext.grid.CellSelectionModel({}),
    loadMask:true,
    bbar:OriginPagingToolbar,
    clicksToEdit:1
});

/// 查询产地
function QueryOrigin(){
    var conditionCode = Ext.getCmp('conditionCodeField').getValue();
    var conditionDesc = Ext.getCmp('conditionDescField').getValue();
    var conditionType = App_StkTypeCode;
    var conditionAlias = Ext.getCmp('conditionAliasField').getValue();
    var conditionHosp = Ext.getCmp('conditionHospField').getValue();
    OriginGridDs.load({
	    params:{
		    start:0,
		    limit:OriginPagingToolbar.pageSize,
		    sort:'RowId',dir:'desc',
		    conditionCode:conditionCode,
		    conditionDesc:conditionDesc,
		    conditionType:conditionType,
		    conditionAlias:conditionAlias,
		    conditionHosp:conditionHosp
		},
		callback : function(o,response,success) { 
			if (success == false){  
				Ext.MessageBox.alert("查询错误",OriginGridDs.reader.jsonData.Error);  
			}
		}
	});
}

//===========模块主页面===============================================
Ext.onReady(function(){
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
     var panel = new Ext.Panel({
        title:'产地维护',
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
			},OriginGrid
		],
        renderTo:'mainPanel'
    });
    QueryOrigin();
});
//===========模块主页面===============================================