var tbarGrid =  new Ext.Toolbar({
	items:[
		'请输入DataServiceUrl：',
		{
			xtype:'textfield',
			id:'txtDataServiceUrl',
			width:150,
			emptyText:'请输入DataServiceUrl'		
		},
		'请输入就诊号：',
		{
			xtype:'textfield',
			id:'txtEpisodeID',
			width:150,
			emptyText:'就诊号'		
		},
		'请输入UserID：',
		{
			xtype:'textfield',
			id:'txtUserID',
			width:150,
			emptyText:'UserID'	
		}]
});


var url = '../DHCEPRFS.web.eprajax.AjaxInterfaceTest.cls?ActionType=getcsp';
var store = new Ext.data.JsonStore({
    url: url,
    fields: [
		{ name: 'TypeCode' },
		{ name: 'TypeName' },
		{ name: 'TypeDesc' },
		{ name: 'CSPPath' },
		{ name: 'PageInfoID' },
		{ name: 'Sequence' }
    ]
});

store.load();

//测试数据源是否正常加载
store.on('load', function() {
    //这个函数会在数据加载完后触发
	//debugger;
});

store.on('loadexception', function(proxy, options, response, e) {
    //数据加载异常
	debugger;
});

var cm = new Ext.grid.ColumnModel([
    { header: '项目内部码', dataIndex: 'TypeCode', width: 100, sortable: true},
    { header: '项目名称', dataIndex: 'TypeName', width: 100, sortable: true },
    { header: '项目描述', dataIndex: 'TypeDesc', width: 100, sortable: true },
    { header: 'CSP名称', dataIndex: 'CSPPath', width: 100, sortable: true },
	{ header: '页码信息ID', dataIndex: 'PageInfoID', width: 100, sortable: true },
	{ header: '顺序号', dataIndex: 'Sequence', width: 100, sortable: true }
]);

var grid = new Ext.grid.GridPanel({
    id: 'cspGrid',
    layout: 'fit',
    border: false,
    store: store,
    cm: cm,
    forceFit: true,
    autoScroll: true,
    frame: true,
    stripeRows: true,
    columnLines: true,
	tbar:tbarGrid,
	listeners:{  
		'rowdblclick' : function(grid, rowIndex, e){  
			var row = grid.getSelectionModel().getSelected();
			var iframeUrl = Ext.getCmp('txtDataServiceUrl').getValue() + 'csp/' + row.get('CSPPath') + 
						'?EpisodeID=' + Ext.getCmp('txtEpisodeID').getValue() + 
						'&PageInfoID=' + row.get('PageInfoID') + 
						'&UserID=' + Ext.getCmp('txtUserID').getValue() + 
						'&CategoryDetail=';
			alert('开始进入csp打印： '+iframeUrl);
			try {
				var i_div = document.getElementById("i_frame_div"); 
				i_div.innerHTML='<IFrame id="i_frame" name="i_frame" width="1px" height="1px" style="display:none" src="'+ iframeUrl +'"></IFrame>';	
			} catch (e) {
				debugger;
				alert(e.message);
			}
			
		}
	}
});

var view = new Ext.Viewport({
	id: 'cspWin',
	shim: false,
	animCollapse: false,
	constrainHeader: true, 
	collapsible: true,
	margins:'0 0 0 0',           
	layout: "border",  
	border: false,              
	items: [{
		border:true,
		region:'center',
		layout:'fit',
		bodyStyle:'padding:0px 0px 0px 0px',
		split: true,
		collapsible: true,  
		items: grid
	},{
		//div为打印准备，打印时嵌套iframe封装打印的csp
		border:false,
		region:'south',
		height: 200,
		bodyStyle:'padding:0px 0px 0px 0px',
		html: '<DIV id="i_frame_div" width="100px" height="100px"></DIV>'
	}]
});

// 每个集成项目内部有多个打印作业,当执行完一个打印作业时调用此方法,完成下列工作:
// 打印作业是否完成的检查\PDF文件是否生成的检查\修改下一个打印作业的输出文件名称
function finishOneItemJob(){
	//debugger;
	alert("完成一个打印作业，点击继续下一个");
}

function finishOneItemJobAsyn(){
	
	finishOneItemJob();
}

function printNext()
{
	alert("打印完成退出");
}