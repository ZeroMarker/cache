Ext.QuickTips.init();


var url = '../web.eprajax.epsodeListGrid.cls?patientID='+ patientID + '&admType=' + admType + '&argDiagnosDesc=' + argDiagnosDesc;
//取得就诊列表数据源，其中传入的admType、argDiagnosDesc若为空，即取全部数据
function GetGridStore()
{
	var store = new Ext.data.JsonStore({
        //url:'../web.eprajax.epsodeListGrid.cls?patientID='+ patientID ,
        url:url,
        //url:'http://172.21.21.31/trakcarelive/trak/web/csp/web.eprajax.epsodeListGrid.cls?patientID=424'
        fields: [
           {name: 'AdmDate'},
           {name: 'AdmType'},
           {name: 'Diagnosis'},
           {name: 'CurDept'},
           {name: 'MainDoc'},
           {name:'DisDate'},
           {name:'EpisodeID'}
        ]
    });
    
    return store;
}

//创建就诊列表的Grid
function getGridPanel()
{
    var store = GetGridStore();
    store.load();
    
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
        {header:'就诊日期', dataIndex:'AdmDate', width:70},
        {header:'类型', dataIndex:'AdmType', width:40,renderer:gettype},
        {header:'诊断', dataIndex:'Diagnosis'},
        {header:'科室', dataIndex:'CurDept', width:75},
        {header:'主治医生', dataIndex:'MainDoc', width:60},
        {header:'出院日期', dataIndex:'DisDate',width:70}
    ]);
    
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
				width:80,
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
                //width: 100
                width:0	
			},
			'-',
			//'->',
			{id:'btnconfirm',text:'确定',cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/btnConfirm.gif',pressed:false,handler:confirm},
			'-',
			{id:'btncompare',name:'btncompare',text:'对比',cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/browser.gif',pressed:false}
		]
    });
    
    return grid;
}


var grid = getGridPanel();
var frmMainContent = new Ext.Viewport({
	id: 'viewport',
	shim: false,
	animCollapse: false,
	constrainHeader: true, 
	margins:'0 0 0 0',           
	layout: "border",  
	border: false,              
	items: [{
		border:false,
		region:'west',
		layout:'fit',
		split: true,
		collapsible: true,  
		width:300,
		items:grid
	},{
		border: false,
		region: "center",
		layout: "border",
		items: [{
			border: false,
			region: "center",
			layout: "fit",
			html:'<iframe id="frmTabPanel" name="frmTabPanel" style="width:100%;height:100%" src="epr.newfw.epsodeListTabPanel.csp?patientID=' + patientID + '&episodeID="'+ episodeID +'"></iframe>'
		}]
    }]
});

grid.on('rowdblclick',function(g,index,e)
{
	//debugger;
	episodeID = g.getStore().getAt(index).data['EpisodeID'];
	browser();
})

//点击“对比”，创建对比窗口

var btn = Ext.getCmp('btncompare');
var win;
btn.on('click',function(){
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
			animateTarget: 'btn',
			//collapsible: true,
			//maximizable:false,
			raggable: true,	//不可拖动
			modal:true,			//遮挡后面的页面
			resizable:true,	//重置窗口大小
			items: [
				new Ext.Panel({
					id:'comparePanel',
					layout:'fit',
					border:false,
					html:'<iframe id="frmCompare" style="width:100%; height:100%" src="epr.newfw.epsodeListComparePhoto.csp"></iframe>'
				})
			]//,
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

