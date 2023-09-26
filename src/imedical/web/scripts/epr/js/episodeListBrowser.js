Ext.QuickTips.init();

var url = '../web.eprajax.episodeListGrid.cls?patientID='+ patientID + '&admType=' + admType + '&argDiagnosDesc=' + escape(argDiagnosDesc);


//方案表格，改变默认方案行背景色
function changeRowBackgroundColor(grid){
	var store = grid.getStore(grid);
	var total = store.getCount();
	for (var i = 0; i < total; i++) {
	    var colorFlag = store.getAt(i).data['ColorFlag'];
		if(colorFlag != ""){
			grid.getView().getCell(i, 1).style.backgroundColor = colorFlag;
		}
	}
}

var store = GetGridStore();
//取得就诊列表数据源，其中传入的admType、argDiagnosDesc若为空，即取全部数据
function GetGridStore()
{
    //debugger;
	var store = new Ext.data.JsonStore({
        //url:'../web.eprajax.episodeListGrid.cls?patientID='+ patientID ,
        url:url,
        //url:'http://172.21.21.31/trakcarelive/trak/web/csp/web.eprajax.episodeListGrid.cls?patientID=424'
        fields: [
           {name: 'AdmDate'},
           {name: 'AdmType'},
           {name: 'Diagnosis'},
           {name: 'CurDept'},
           {name: 'MainDoc'},
           {name:'DisDate'},
           {name:'EpisodeID'},
		   {name:'ColorFlag'}
        ],
       	root: 'data',
		//获取总页数
		totalProperty: 'TotalCount'
    });
    
    //测试数据源是否正常加载
    store.on('load', function () {
        //这个函数会在数据加载完后触发
        //debugger;
        //alert(store);
	    //增加背景色
	    changeRowBackgroundColor(Ext.getCmp('episodeGrid'));
    });
    store.on('loadexception', function (proxy, options, response, e) {
        //数据加载异常
        //debugger;
        //alert(response.responseText);
        //alert(e);
        //var i = response.responseText.indexOf('\r\n')
        //alert(i);
    });
    
    return store;
}

//创建就诊列表的Grid
function getGridPanel()
{
    //debugger;
    //var store = GetGridStore();
    //store.load();
    var sm = new Ext.grid.CheckboxSelectionModel({
        listeners:{
           // 'rowdeselect':function(cm,index,record)
            //{
				//debugger;
				//alert(index);
                //取消选中的对象触发的事件
                //var dom = record.data;//取消选中的对象
            //},
            'rowselect':function(record,index,e)
            {
                //选中对象触发的事件
                
                //var dom1 = record.data;//选中的对象
                //alert(dom1["AdmDate"]);
                
                episodeID = grid.getStore().getAt(index).data['EpisodeID'];
                //browser();
                //alert(episodeID);
            }
        }
    });
    
    var cm = new Ext.grid.ColumnModel([sm,
        {header:'就诊日期', dataIndex:'AdmDate', width:70, sortable:true},
        {header:'诊断', dataIndex:'Diagnosis', sortable:true},
        {header:'类型', dataIndex:'AdmType', width:40, renderer:gettype, sortable:true},
        {header:'科室', dataIndex:'CurDept', width:75, sortable:true},
        {header:'主治医生', dataIndex:'MainDoc', width:60, sortable:true},
        {header:'出院日期', dataIndex:'DisDate',width:70, sortable:true}
    ]);
    
    //就诊类型的转换（I：住院，O：门诊，E：急诊）
    function gettype(val)
    {
        if(val == "I")
        {
            //改变就诊类型的颜色
		    return '<span style="color:green;">住院</span>';
        }
        else if(val == "O"){
            //改变就诊类型的颜色
            return '<span style="color:red;">门诊</span>';
        }
        else if(val == "E")
        {
            //改变就诊类型的颜色
		    return '<span style="color:blue;">急诊</span>';
        }
        
        return val;
    }

	//将底部工具栏分为两行，第一行为患者列表分页栏，第二行为按钮工具栏
	//初始化第二行按钮工具栏：权限申请按钮、集中打印按钮
	var hiddenCentralPrint = (EnableCentralPrintInBrowser != "Y");
	var bbar2 = new Ext.Toolbar({
		id: 'bbar2',
		//预留按钮溢出位置
		//layout: {
		//    overflowHandler: 'Menu'
		//},
		items: [
			{id:'btnRequest',name:'btnRequest',text:'申请权限',cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/browser.gif',pressed:false},
			{id:'btnCentralPrint',name:'btnCentralPrint',text:'集中打印',cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/print.gif',pressed:false, hidden:hiddenCentralPrint}	
		]
	}); 
	
    var grid = new Ext.grid.GridPanel({
        id:'episodeGrid',
        layout:'fit',
        border:false,
        store:store,
        cm:cm,
        sm:sm,
        forceFit:true,
        autoScroll:true,
        frame:true,
        tbar:[
			'就诊类型',
			'-',
			{
				id:'cboAdmType',
				//emptyText:'就诊类型',
				width:60,
				resizable: false,
				xtype :'combo',
				valueField:'returnValue',
				displayField:'displayText',
				readOnly: true,
				triggerAction : 'all', 
				mode: 'local',
				store: new Ext.data.SimpleStore({
					fields:['returnValue','displayText'],
					data:[['','全部'],['O','门诊'],['E','急诊'],['I','住院']]
				})
			},
			//'-',
			{
				id:'txtArgDiagnosDesc',
				emptyText:'诊断内容',
                xtype: 'textfield',
                //enable:false,
                width: 75
                //width:0
			},
			'-',
			//'->',
			{id:'btnconfirm',text:'确定',cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/btnConfirm.gif',pressed:false,handler:confirm},
			'-',
			{id:'btncompare',name:'btncompare',text:'对比',cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/browser.gif',pressed:false}
		],
		bbar:
		[
			//病历浏览分页栏
			new Ext.PagingToolbar({
				id: "pagToolbar",
				store: store,
				//pageSize: queryPageSize,
				pageSize:20,
				//displayInfo: true,
			   // displayMsg:'共{2}条',
			   // beforePageText: '页码',
				//afterPageText: '总页数 {0}',
			   // displayInfo: true,	
				firstText: '首页',
				prevText: '上 一页',
				nextText: '下一页',
				lastText: '末页',
				refreshText: '刷新',
				emptyMsg: "没有记录"
			 })
		],
		listeners: {
			'render': function(){
                bbar2.render(this.bbar);
			}
		}
    });
    
    return grid;
}


var grid = getGridPanel();

var frmMainContent = new Ext.Viewport({
	id: 'viewport',
	shim: false,
	animCollapse: false,
	constrainHeader: true, 
	collapsible: true,
	margins:'0 0 0 0',           
	layout: "border",  
	border: false,              
	items: [{
		border:false,
		title:'就诊信息',
		region:'west',
		layout:'fit',
		split: true,
		collapsible: true,  
		width:310,
		items:grid
	},{
		border: false,
		region: "center",
		layout: "border",
		items: [{
			border: false,
			region: "center",
			layout: "fit",
			html:'<iframe id="frmTabPanel" name="frmTabPanel" style="width:100%;height:100%" src="epr.newfw.episodelisttabpanel.csp?patientID=' + patientID + '&episodeID="'+ episodeID +'"></iframe>'
		}]
    }]
});

		
Ext.getCmp('pagToolbar').bind(store);
store.load({ params: { start: 0, limit: 20} });
/*
//就诊列表根据就诊类型的不同渲染不同背景色的功能
grid.getStore().addListener('load',handleGridLoadEvent);
function handleGridLoadEvent(store,records)
{
    var girdcount=0;
    store.each(function(r)
    {
        //I：住院，O：门诊，E：急诊
        if(r.get('AdmType')=='')
        {
            grid.getView().getRow(girdcount).style.backgroundColor='#c3daf9';
        }
        else if(r.get('AdmType')=='')
        {
            grid.getView().getRow(girdcount).style.backgroundColor='#c3daf9';
        }
        else
        {
            grid.getView().getRow(girdcount).style.backgroundColor='#c3daf9';
        }
        girdcount=girdcount+1;
    });
}
*/

grid.on('rowdblclick',function(g,index,e)
{
	episodeID = g.getStore().getAt(index).data['EpisodeID'];
	type = g.getStore().getAt(index).data['AdmType'];
	browser();
});

//点击“对比”，创建对比窗口
var btncompare = Ext.getCmp('btncompare');
var win;
btncompare.on('click',function(){
	//add by YHY
	var selModel = Ext.getCmp('episodeGrid').getSelectionModel();
	var selects = selModel.getSelections();
	
	if(selects.length == 0)
	{
		Ext.MessageBox.alert('操作提示','请选择一条就诊记录再进行就诊浏览,请重新操作');
		return;
	}
	
	if(!win)
	{
		win = new Ext.Window({
			id:'compareWin',
			layout:'fit',		//自动适应Window大小 
			width:1000,
			height:600, 
			title:'病历对比',
			//animCollapse:true,
			closeAction:'hide',
			animateTarget: 'btncompare',
			//collapsible: true,
			//maximizable:false,
			raggable: true,	//不可拖动
			modal:true,			//遮挡后面的页面
			resizable:true,	//重置窗口大小
		    //html:'<div><img src="file:///C:/DOCUME~1/ADMINI~1/LOCALS~1/Temp/1.gif" /></div>'
			items: [
				new Ext.Panel({
					id:'comparePanel',
					layout:'fit',
					border:false,
					//html:'<iframe id="frmCompare" style="width:100%; height:100%" src="epr.newfw.episodelistcomparephoto.csp"></iframe>'
					html:'<iframe id="frmCompare" style="width:100%; height:100%" src=""></iframe>'
				})
			]
			//buttons:[{
					//text:"关闭",
					//handler:function(){
						//win.hide();
					//}
			//}]
		}); 
	}
	win.show(this);
	compare();
});


//点击"申请权限"

var btnRequest = Ext.getCmp('btnRequest');

btnRequest.on('click',function(){
    //alert('EpisodeID:'+episodeID+'--PatientID:'+patientID);
    var selModel = Ext.getCmp('episodeGrid').getSelectionModel();
	var selects = selModel.getSelections();
	
	if(selects.length == 0)
	{
		Ext.MessageBox.alert('操作提示','请选择一条就诊记录再进行操作');
		return;
	}
	if(selects.length > 1)
	{
	    Ext.MessageBox.alert('操作提示','已选择'+selects.length +'条就诊记录,请选择一条记录再进行操作');
		return;
	}
    var win = new Ext.Window({
	    id:'requestWin',
	    layout:'fit',		//自动适应Window大小 
	    width:500,
	    height:500, 
	    title:'申请权限',
	    //animCollapse:true,
	    //closeAction:'hide',
	    animateTarget: 'btnRequest',
	    //collapsible: true,
	    //maximizable:false,
	    raggable: true,	//不可拖动
	    modal:true,			//遮挡后面的页面
	    resizable:true,	//重置窗口大小
	    //items:fromPanel
	    html:'<iframe id="frmRequest" style="width:100%; height:100%" src="epr.newfw.actionrequest.csp?PatientID='+patientID+'&EpisodeID='+episodeID+'"></iframe>'
    }); 
    win.show(this);
});


var btnCentralPrint = Ext.getCmp('btnCentralPrint');
btnCentralPrint.on('click',function(){
    //alert('EpisodeID:'+episodeID+'--PatientID:'+patientID);
    var selModel = Ext.getCmp('episodeGrid').getSelectionModel();
	var selects = selModel.getSelections();
	
	if(selects.length == 0)
	{
		Ext.MessageBox.alert('操作提示','请选择一条就诊记录再进行操作');
		return;
	}
	if(selects.length > 1)
	{
	    Ext.MessageBox.alert('操作提示','已选择'+selects.length +'条就诊记录,请选择一条记录再进行操作');
		return;
	}
    var win = new Ext.Window({
	    id:'centralizedPrintWin',
	    layout:'fit',		//自动适应Window大小 
	    width:800,
	    height:500, 
	    title:'集中打印',
	    //animCollapse:true,
	    //closeAction:'hide',
	    animateTarget: 'btnCentralPrint',
	    //collapsible: true,
	    //maximizable:false,
	    raggable: true,	//不可拖动
	    modal:true,			//遮挡后面的页面
	    resizable:true,	//重置窗口大小
	    html: '<iframe id="eprCentralizedPrint" scrolling="no" frameborder="0" style="width:100%; height:100%;" src="dhc.epr.centralizedprintiframe.csp?EpisodeID=' + episodeID + '"></iframe>'
	}); 
    win.show(this);
});

/*
//点击"会诊授权"
var btnAuthorize = Ext.getCmp('btnAuthorize');
btnAuthorize.on('click', function() {
    //以下参数来自于护理组
    var episodeID = "77128";         //患者就诊ID
    var consultID = "112";          //会诊申请ID
    var consdocID = "3915";          //会诊医生ID
    var conslocID = "14";	        //会诊科室ID
    var consultType = "院内";       //会诊类型
    var appointType = 1             //授权类型（0：个人；1：科室）
    
    var win = new Ext.Window({
        id: 'authorizeWin',
        layout: 'fit', 	//自动适应Window大小 
        width: 500,
        height: 500,
        title: '会诊病历授权',
        //animCollapse:true,
        //closeAction:'hide',
        animateTarget: 'btnAuthorize',
        //collapsible: true,
        //maximizable:false,
        raggable: true,     //不可拖动
        modal: true, 		//遮挡后面的页面
        resizable: true,    //重置窗口大小
        //items:fromPanel
        html: '<iframe id="frmAuthorize" style="width:100%; height:100%" src="epr.newfw.actionauthorize.csp?EpisodeID=' + episodeID + '&ConsultID=' + consultID + '&ConsdocID=' + consdocID + '&ConslocID=' + conslocID + '&ConsultType=' + consultType + '&AppointType=' + appointType + '"></iframe>'
    });
    win.show(this);
});
*/
