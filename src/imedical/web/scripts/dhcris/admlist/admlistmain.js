Ext.QuickTips.init();
//��ҳ�������ϵ�����ѡ�������б� 
var comboStore =  new Ext.data.ArrayStore({
	    id:'o',
        fields: ['text', 'value'],
        data :[['15', 15], ['30', 30], ['50', 50], ['100', 100],['200',200],['500',500]]  // from states.js
 });
var pagesize_combo = new Ext.form.ComboBox({   
      store:comboStore ,   
      width:50,      
      //readOnly:true, //ֻ�������Ҳ���ʾ������ͷ
	    editable:false,  //ֻ��,��ʾ������ͷ
      emptyText: '15',      
      //mode: 'remote',
	    mode: 'local',      
      triggerAction: 'all',      
      valueField:'value',      
      displayField: 'text'     
 });            
 //����ѡ�������б�-ѡ���¼� 
 var number=15;
 pagesize_combo.on("select",function(comboBox){             
    pageToolBar.pageSize = parseInt(comboBox.getValue());      
    number=parseInt(comboBox.getValue());
    AdmListStore.reload({params:{start:0,limit:number}});      
 });  
//�����ҳ������(д������������)
var pageToolBar = new Ext.PagingToolbar({
    pageSize:number,
    store:AdmListStore,
    //prependButtons:true,
    displayInfo:true,
    displayMsg:"��ҳ��ʾ��{0}����{1}����¼,һ��{2}��",
    EmptyMsg:"û�м�¼",
    items:['&nbsp;&nbsp;ÿҳ��ʾ��¼����:',pagesize_combo] 
});
	
var AdmListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
        url : ExtToolSetting.RunQueryPageURL
    }));

//����һ���Զ���Record����
//Name,Sex,Age,RegNo,StudyNo,strOrderName,PatientStatus,Type,LocName,strDate,strTime,BKDate,BKTime,RegDate,RegTime,oeorditemdr,replocdr
var gridRecord = Ext.data.Record.create([
            {name:'checked',mapping:'checked'}
            ,{name:'Name',mapping:'Name'}
            ,{name:'Sex',mapping:'Sex'}
            ,{name:'Age',mapping:'Age'}
            ,{name:'RegNo',mapping:'RegNo'}
            ,{name:'StudyNo',mapping:'StudyNo'}
            ,{name:'strOrderName',mapping:'strOrderName'}
            ,{name:'PatientStatus',mapping:'PatientStatus'}
            ,{name:'Type',mapping:'Type'}
            ,{name:'LocName',mapping:'LocName'}
            ,{name:'strDate',mapping:'strDate'}
            ,{name:'strTime',mapping:'strTime'}
            ,{name:'BKDate',mapping:'BKDate'}
            ,{name:'BKTime',mapping:'BKTime'}
            ,{name:'RegDate',mapping:'RegDate'}
            ,{name:'RegTime',mapping:'RegTime'}
            ,{name:'oeorditemdr',mapping:'oeorditemdr'}
            ,{name:'replocdr',mapping:'replocdr'}
]);  
  
var AdmListStore =new Ext.data.GroupingStore({    //new Ext.data.Store({
        proxy : AdmListStoreProxy,
        reader : new Ext.data.JsonReader({
            root:'record',
            totalProperty:'total',
            idProperty:'Group'
        },gridRecord)
        ,
        groupField:'LocName',
        sortInfo:{field:'replocdr',direction:'ASC'}
    });
    
var sm = new Ext.grid.CheckboxSelectionModel({singleSelect:false,checkOnly:true});
var AdmListGrid = new Ext.grid.GridPanel({
	      title:'����б�', 
        id:'AllStudyGrid'
        ,store:AdmListStore
        //,region:'west'
        ,collapsible:true
        //,split:true
        ,layout:"fit"
        //,width:300
        ,height:600
        //,autoScroll:true
        //,clicksToEdit:1
        ,sm:sm//new Ext.grid.CheckboxSelectionModel({singleSelect:false})
        //,bodyStyle: 'background:#ffc; padding:10px;'
        ,style:'border: 1px solid #8db2e3;'
        ,stripeRows:true
        //,viewConfig:{forceFit:true}
        //,autoFill:true
        //,forceFit:true
        ,columns:[
            new Ext.grid.RowNumberer()
            //,{header:'ѡ��',width:100,dataIndex:'checked'}
            ,sm  //new Ext.grid.CheckboxSelectionModel () //{singleSelect  : true}
            ,{header:'����',width:30,dataIndex:'Name',sortable:true}
            ,{header:'�Ա�',width:70,dataIndex:'Sex',sortable:true}
            ,{header:'����',width:30,dataIndex:'Age',sortable:true}
            ,{header:'�ǼǺ�',width:60,dataIndex:'RegNo',sortable:true}
            ,{header:'����',width:60,dataIndex:'StudyNo',sortable:true}
            ,{header:'�����Ŀ',width:150,dataIndex:'strOrderName',sortable:true}
            ,{header:'���״̬',width:60,dataIndex:'PatientStatus',sortable:true }
            ,{header:'��������',width:60,dataIndex:'Type',sortable:true}
            ,{header:'ִ�п���',width:60,dataIndex:'LocName',sortable:true}
            ,{header:'ҽ������',width:80,dataIndex:'strDate',sortable:true}
            ,{header:'ҽ��ʱ��',width:80,dataIndex:'strTime',sortable:true}
            ,{header:'ԤԼ����',width:80,dataIndex:'BKDate',sortable:true}
            ,{header:'ԤԼʱ��',width:80,dataIndex:'BKTime',sortable:true}
            ,{header:'�Ǽ�����',width:80,dataIndex:'RegDate',sortable:true}
            ,{header:'�Ǽ�ʱ��',width:80,dataIndex:'RegTime',sortable:true}
            ,{header:'oeorditemdr',width:50,dataIndex:'oeorditemdr',sortable:true,hidden:true}
            ,{header:'replocdr',width:50,dataIndex:'replocdr',sortable:true,hidden:true}
        ],
        items:[
            //pnQueryButton
        ]
        ,
        listeners:{
         render:function(){
         var hd_checker = this.getEl().select('div.x-grid3-hd-checker');
         if (hd_checker.hasClass('x-grid3-hd-checker')) {  
                hd_checker.removeClass('x-grid3-hd-checker'); // ȥ��ȫѡ�� 
            } 
         }
        }
        ,loadMask : {msg : '���ڼ������ݣ����Ժ��'}
        ,view:new Ext.grid.GroupingView()
        ,bbar:new Ext.PagingToolbar({
                        pageSize:number,
                        store:AdmListStore,
                        displayInfo:true,
                        displayMsg:"��ҳ��ʾ��{0}����{1}����¼,һ��{2}��",
                        EmptyMsg:"û�м�¼",
                        items:['&nbsp;&nbsp;ÿҳ��ʾ��¼����:',pagesize_combo] 
                        })
        
});
//alert(EpisodeID);

///��ѯ�����б�
AdmListStoreProxy.on('beforeload',function(objProxy,param){
    //alert("1");
    param.ClassName='web.DHCRisclinicQueryOEItemDo';
    param.QueryName='QueryCurrentAdmList';
    //param.Arg1 = obj.comGroup.getRawValue();
    param.Arg1 = EpisodeID; //'0000123745';
    param.Arg2 = "";  //adm;
    param.Arg3 = "";   //Ext.getCmp('sdate').getValue(); //'2008-10-22';
    param.Arg4 = "";   //Ext.getCmp('edate').getValue(); //'2013-10-22'
    param.ArgCnt = 4;
    //param.start=0;
    //param.limit=15;
});

AdmListStore.load({params:{start:0,limit:15}});

var listShowPanel = new Ext.FormPanel({
        title:"��ǰ�������¼",
        //width:600,
        //bodyStyle: 'background:#ffc; padding:10px;',
        bodyStyle: 'padding:10;',
        layout:"form",
        region:'center',
        frame:true,
        autoScroll:true,
        items:[
            new Ext.Panel({
                border:false,
                height:10
            })
            ,AdmListGrid
        ]
    });





//alert(session['LOGON.CTLOCID']);
Ext.onReady(function(){
    var obj = new Object();
    
     obj.Viewport = new Ext.Viewport({
        id:'viewport',
        layout:'border',
        labelStyle: 'background:#ffc; padding:10px;',
        items:[
            listShowPanel  
        ]
    });
   
});