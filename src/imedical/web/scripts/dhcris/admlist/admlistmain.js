Ext.QuickTips.init();
//分页工具栏上的条数选择下拉列表 
var comboStore =  new Ext.data.ArrayStore({
	    id:'o',
        fields: ['text', 'value'],
        data :[['15', 15], ['30', 30], ['50', 50], ['100', 100],['200',200],['500',500]]  // from states.js
 });
var pagesize_combo = new Ext.form.ComboBox({   
      store:comboStore ,   
      width:50,      
      //readOnly:true, //只读，并且不显示下拉箭头
	    editable:false,  //只读,显示下拉箭头
      emptyText: '15',      
      //mode: 'remote',
	    mode: 'local',      
      triggerAction: 'all',      
      valueField:'value',      
      displayField: 'text'     
 });            
 //条数选择下拉列表-选中事件 
 var number=15;
 pagesize_combo.on("select",function(comboBox){             
    pageToolBar.pageSize = parseInt(comboBox.getValue());      
    number=parseInt(comboBox.getValue());
    AdmListStore.reload({params:{start:0,limit:number}});      
 });  
//定义分页工具栏(写在外面有问题)
var pageToolBar = new Ext.PagingToolbar({
    pageSize:number,
    store:AdmListStore,
    //prependButtons:true,
    displayInfo:true,
    displayMsg:"本页显示第{0}条到{1}条记录,一共{2}条",
    EmptyMsg:"没有记录",
    items:['&nbsp;&nbsp;每页显示记录数量:',pagesize_combo] 
});
	
var AdmListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
        url : ExtToolSetting.RunQueryPageURL
    }));

//创建一个自定义Record类型
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
	      title:'检查列表', 
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
            //,{header:'选择',width:100,dataIndex:'checked'}
            ,sm  //new Ext.grid.CheckboxSelectionModel () //{singleSelect  : true}
            ,{header:'姓名',width:30,dataIndex:'Name',sortable:true}
            ,{header:'性别',width:70,dataIndex:'Sex',sortable:true}
            ,{header:'年龄',width:30,dataIndex:'Age',sortable:true}
            ,{header:'登记号',width:60,dataIndex:'RegNo',sortable:true}
            ,{header:'检查号',width:60,dataIndex:'StudyNo',sortable:true}
            ,{header:'检查项目',width:150,dataIndex:'strOrderName',sortable:true}
            ,{header:'检查状态',width:60,dataIndex:'PatientStatus',sortable:true }
            ,{header:'病人类型',width:60,dataIndex:'Type',sortable:true}
            ,{header:'执行科室',width:60,dataIndex:'LocName',sortable:true}
            ,{header:'医嘱日期',width:80,dataIndex:'strDate',sortable:true}
            ,{header:'医嘱时间',width:80,dataIndex:'strTime',sortable:true}
            ,{header:'预约日期',width:80,dataIndex:'BKDate',sortable:true}
            ,{header:'预约时间',width:80,dataIndex:'BKTime',sortable:true}
            ,{header:'登记日期',width:80,dataIndex:'RegDate',sortable:true}
            ,{header:'登记时间',width:80,dataIndex:'RegTime',sortable:true}
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
                hd_checker.removeClass('x-grid3-hd-checker'); // 去掉全选框 
            } 
         }
        }
        ,loadMask : {msg : '正在加载数据，请稍侯……'}
        ,view:new Ext.grid.GroupingView()
        ,bbar:new Ext.PagingToolbar({
                        pageSize:number,
                        store:AdmListStore,
                        displayInfo:true,
                        displayMsg:"本页显示第{0}条到{1}条记录,一共{2}条",
                        EmptyMsg:"没有记录",
                        items:['&nbsp;&nbsp;每页显示记录数量:',pagesize_combo] 
                        })
        
});
//alert(EpisodeID);

///查询就诊列表
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
        title:"当前就诊检查记录",
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