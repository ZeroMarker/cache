// 名称:日志查询管理
// 编写日期:2012-06-13

//=========================日志查询管理=============================
var startDate = new Ext.ux.DateField({
    id:'startDate',
    allowBlank:false,
    value:new Date()
});

var endDate = new Ext.ux.DateField({
    id:'endDate',
    allowBlank:false,
    value:new Date()
});

var ErrorRecordGrid="";
//配置数据源
var ErrorRecordGridUrl = 'dhcst.stksyserrorrecordaction.csp';
var ErrorRecordGridProxy= new Ext.data.HttpProxy({url:ErrorRecordGridUrl+'?actiontype=query',method:'GET'});
var ErrorRecordGridDs = new Ext.data.Store({
    proxy:ErrorRecordGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
        totalProperty:'results',
        pageSize:35
    }, [
        {name:'RowId'},
        {name:'Date'},
        {name:'Time'},
        {name:'AppName'},
        {name:'ErrInfo'},
        {name:'KValue'},
        {name:'Trigger'},
        {name:'IP'},
        {name:'UserName'},
        {name:'BrowserInfo'}
    ]),
    remoteSort:true
});
ErrorRecordGridProxy.addListener('beforewrite',function(proxy,action,data,response){
});
//模型
var ErrorRecordGridCm = new Ext.grid.ColumnModel([
     new Ext.grid.RowNumberer(),
     {
        header:"日志生成日期",
        dataIndex:'Date',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"日志生成时间",
        dataIndex:'Time',
        width:90,
        align:'left',
        sortable:true
    },{
        header:"错误发生模块",
        dataIndex:'AppName',
        width:120,
        align:'left',
        sortable:true
    },{
        header:"错误描述",
        dataIndex:'ErrInfo',
        width:280,
        align:'left',
        sortable:true,
  		editor:new Ext.form.TextField({})
    },{
        header:"产生错误的数据",
        dataIndex:'KValue',
        width:150,
        align:'left',
        sortable:true
    },{
        header:"产生错误的代码",
        dataIndex:'Trigger',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"操作机器IP",
        dataIndex:'IP',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"操作用户",
        dataIndex:'UserName',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"浏览信息",
        dataIndex:'BrowserInfo',
        width:120,
        align:'left',
        sortable:true
    }
]);

//初始化默认排序功能
ErrorRecordGridCm.defaultSortable = true;
var queryErrorRecord = new Ext.Toolbar.Button({
    text:'查询',
    tooltip:'查询',
    iconCls:'page_find',
    width : 70,
    height : 30,
    handler:function(){
        var startDate = Ext.getCmp('startDate').getValue();
        var endDate = Ext.getCmp('endDate').getValue();
        if((startDate!="")&&(startDate!=null)&&(endDate!="")&&(endDate!=null)){
            startDate = startDate.format('Y-m-d');
            endDate = endDate.format('Y-m-d');
            ErrorRecordGridDs.load({params:{startDate:startDate,endDate:endDate}});
        }else{
            Msg.info("error", "请检查是否漏选了起止日志!");
        }
    }
});

//表格
ErrorRecordGrid = new Ext.grid.EditorGridPanel({
    store:ErrorRecordGridDs,
    cm:ErrorRecordGridCm,
    trackMouseOver:true,
    region:'center',
    height:665,
    stripeRows:true,
    sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
    loadMask:true,
    clicksToEdit:1,
    tbar:['开始日期:',startDate,'结束日期:',endDate,'-',queryErrorRecord]
});
//=========================日志查询管理=============================

//===========模块主页面===============================================
Ext.onReady(function(){
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    
    var panel = new Ext.Panel({
        title:'日志查询管理',
        activeTab:0,
        //region:'center',
        layout:"fit",
        items:[ErrorRecordGrid]                                 
    });
    
    var mainPanel = new Ext.Viewport({
        layout:'fit',
        items:[panel],
        renderTo:'mainPanel'
    });
});
//===========模块主页面===============================================