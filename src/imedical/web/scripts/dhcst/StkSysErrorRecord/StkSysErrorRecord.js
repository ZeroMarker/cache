// ����:��־��ѯ����
// ��д����:2012-06-13

//=========================��־��ѯ����=============================
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
//��������Դ
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
//ģ��
var ErrorRecordGridCm = new Ext.grid.ColumnModel([
     new Ext.grid.RowNumberer(),
     {
        header:"��־��������",
        dataIndex:'Date',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"��־����ʱ��",
        dataIndex:'Time',
        width:90,
        align:'left',
        sortable:true
    },{
        header:"������ģ��",
        dataIndex:'AppName',
        width:120,
        align:'left',
        sortable:true
    },{
        header:"��������",
        dataIndex:'ErrInfo',
        width:280,
        align:'left',
        sortable:true,
  		editor:new Ext.form.TextField({})
    },{
        header:"�������������",
        dataIndex:'KValue',
        width:150,
        align:'left',
        sortable:true
    },{
        header:"��������Ĵ���",
        dataIndex:'Trigger',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"��������IP",
        dataIndex:'IP',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"�����û�",
        dataIndex:'UserName',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"�����Ϣ",
        dataIndex:'BrowserInfo',
        width:120,
        align:'left',
        sortable:true
    }
]);

//��ʼ��Ĭ��������
ErrorRecordGridCm.defaultSortable = true;
var queryErrorRecord = new Ext.Toolbar.Button({
    text:'��ѯ',
    tooltip:'��ѯ',
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
            Msg.info("error", "�����Ƿ�©ѡ����ֹ��־!");
        }
    }
});

//���
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
    tbar:['��ʼ����:',startDate,'��������:',endDate,'-',queryErrorRecord]
});
//=========================��־��ѯ����=============================

//===========ģ����ҳ��===============================================
Ext.onReady(function(){
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    
    var panel = new Ext.Panel({
        title:'��־��ѯ����',
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
//===========ģ����ҳ��===============================================