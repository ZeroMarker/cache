dhcwl.mkpi.ShowKpiLoginInfo = function(parentWin){
	var parentWin=null;
	var serviceUrl="dhcwl/kpi/showkpilogininfo.csp";
	var outThis=this;

	var loginType="", pageSize=15;

	//		动态grid列模型数据准备
	var indexArray = new Array();
	var headerArray = new Array(), dataIndexArray = new Array();
	headerArray[1]='ID', headerArray[2]='日志日期', headerArray[3]='开始时间', headerArray[4]='结束时间', headerArray[5]='操作用户';
	headerArray[6]='日志类型', headerArray[7]='调用方法', headerArray[8]='指标列表', headerArray[9]='指标原属性', headerArray[10]='指标新属性';
	headerArray[11]='取数规则', headerArray[12]='过滤规则', headerArray[13]='日期属性', headerArray[14]='其他参数', headerArray[15]='操作后状态';
	headerArray[16]='其他信息';
	dataIndexArray[1]='ID', dataIndexArray[2]='LoginDate', dataIndexArray[3]='LoginSTime', dataIndexArray[4]='LoginETime', dataIndexArray[5]='Operator';
	dataIndexArray[6]='LoginTypeDr', dataIndexArray[7]='CalledFunction', dataIndexArray[8]='MKPIIdList', dataIndexArray[9]='PrePropertyList', dataIndexArray[10]='PostPropertyList';
	dataIndexArray[11]='ParaKpiRule', dataIndexArray[12]='ParaFilterRule', dataIndexArray[13]='ParaDateScope', dataIndexArray[14]='ParaOther', dataIndexArray[15]='OperateState';
	dataIndexArray[16]='OtherContent';
	
	//		行选择模型定义
	var sm = new Ext.grid.CheckboxSelectionModel();
	
	//		定义初始化grid列模型
	var defaultColumnModel = new Ext.grid.ColumnModel([
		sm,
		{header:'ID',dataIndex:'ID',sortable:true,width:15},
		{header:'日志日期',dataIndex:'LoginDate',sortable:true,anchor:'5%'},
		{header:'开始时间',dataIndex:'LoginSTime',sortable:true,anchor:'5%'},
		{header:'结束时间',dataIndex:'LoginETime',sortable:true,anchor:'5%'},
		{header:'操作用户',dataIndex:'Operator',sortable:true,anchor:'5%'},
		{header:'日志类型',dataIndex:'LoginTypeDr',sortable:true,anchor:'5%'},
		{header:'调用方法',dataIndex:'CalledFunction',sortable:true,anchor:'5%'},
		{header:'指标列表',dataIndex:'MKPIIdList',sortable:true,anchor:'5%'},
		{header:'指标原属性',dataIndex:'PrePropertyList',sortable:true,anchor:'10%'},
		{header:'指标新属性',dataIndex:'PostPropertyList',sortable:true,anchor:'10%'},
		{header:'取数规则',dataIndex:'ParaKpiRule',sortable:true,anchor:'10%'},
		{header:'过滤规则',dataIndex:'ParaFilterRule',sortable:true,anchor:'10%'},
		{header:'日期属性',dataIndex:'ParaDateScope',sortable:true,anchor:'5%'},
		{header:'其他参数',dataIndex:'ParaOther',sortable:true,anchor:'10%'},
		{header:'操作后状态',dataIndex:'OperateState',sortable:true,anchor:'5%'},
		{header:'其他信息',dataIndex:'OtherContent',sortable:true,anchor:'5%'}
	]);

/*	//		定义grid记录
	var record = Ext.data.Record.create([
		{name:'ID',type:'string'},
		{name:'LoginDate',type:'string'},
		{name:'LoginSTime',type:'string'},
		{name:'LoginETime',type:'string'},
		{name:'Operator',type:'string'},
		{name:'LoginTypeDr',type:'string'},
		{name:'CalledFunction',type:'string'},
		{name:'MKPIIdList',type:'string'},
		{name:'PrePropertyList',type:'string'},
		{name:'PostPropertyList',type:'string'},
		{name:'ParaKpiRule',type:'string'},
		{name:'ParaFilterRule',type:'string'},
		{name:'ParaDateScope',type:'string'},
		{name:'ParaOther',type:'string'},
		{name:'OperateState',type:'string'},
		{name:'OtherContent',type:'string'}
	]);*/

	//		定义grid数据源
	var store = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:serviceUrl+'?action=lookup&loginType'+loginType+'&start=1&pageSize='+pageSize}),
		reader:new Ext.data.JsonReader({
			totalProperty:'totalNum',
			root:'root',
			fields:[
				{name:'ID'},
				{name:'LoginDate'},
				{name:'LoginSTime'},
				{name:'LoginETime'},
				{name:'Operator'},
				{name:'LoginTypeDr'},
				{name:'CalledFunction'},
				{name:'MKPIIdList'},
				{name:'PrePropertyList'},
				{name:'PostPropertyList'},
				{name:'ParaKpiRule'},
				{name:'ParaFilterRule'},
				{name:'ParaDateScope'},
				{name:'ParaOther'},
				{name:'OperateState'},
				{name:'OtherContent'},
			]
		})
	});


	//		定义grid样式
	var loginInfoGrid = new Ext.grid.GridPanel({
		title:'查询结果',
		id:'loginInfoGrid',
		store:GetDynamicStore(),
		//store:store,
		height:530,
		draggable: true,
		columnLines: true,
		viewConfig:{
			autoFill:true
			//forceFit: true
		},
		cm:defaultColumnModel,
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		tbar:GetPagingBar(),
		bbar:GetPagingBar(),
		listeners:{
			'contextmenu':function(event){
				event.preventDefault();
				quickMenu.showAt(event.getXY());
			}
		}
	});
	
	//		定义Form表单
	var loginInfoForm = new Ext.FormPanel({
		title:'查询条件',
		height:95,
		layout:'table',
		loadMask: true,
		columnLines: true,

		items:[{
			html:'开始日期:'
		},{
			xtype:'datefield',
			format:'Y-m-d',
			name:'fromDate',
			id:'fromDate'
		},{
			html:'结束日期:'
		},{
			xtype:'datefield',
			format:'Y-m-d',
			name:'toDate',
			id:'toDate'
		}],
		bbar:new Ext.Toolbar({
			region:'south',
			items:[{
			//xtype:'button',
			//bodyStyle:{"color":"red"},
			text:'指标定义（增加）',
			id:'btnMkpiDefineAdd',
			//ctCls:'x-btn-over',
			handler:function(){
				GetColumnModelIndex("btnMkpiDefineAdd");
				var dynamicStore = GetDynamicStore();
				loginInfoGrid.reconfigure(dynamicStore,GetDynamicColumn());
				ShowGridData(dynamicStore,loginInfoGrid,"btnMkpiDefineAdd");
			}
		},'-',{
			text:'指标定义（修改）',
			id:'btnMkpiDefineUpdate',
			handler:function(){
				GetColumnModelIndex("btnMkpiDefineUpdate");
				var dynamicStore = GetDynamicStore();
				loginInfoGrid.reconfigure(dynamicStore,GetDynamicColumn());
				ShowGridData(dynamicStore,loginInfoGrid,"btnMkpiDefineUpdate");
			}
		},'-',{
			text:'指标定义（删除）',
			id:'btnMkpiDefineDelete',
			handler:function(){
				GetColumnModelIndex("btnMkpiDefineDelete");
				var dynamicStore = GetDynamicStore();
				loginInfoGrid.reconfigure(dynamicStore,GetDynamicColumn());
				ShowGridData(dynamicStore,loginInfoGrid,"btnMkpiDefineDelete");
			}
		},'-',{
			text:'指标数据（查询）',
			id:'btnMkpiDataGet',
			handler:function(){
				GetColumnModelIndex("btnMkpiDataGet");
				var dynamicStore = GetDynamicStore();
				loginInfoGrid.reconfigure(dynamicStore,GetDynamicColumn());
				ShowGridData(dynamicStore,loginInfoGrid,"btnMkpiDataGet");
			}
		},'-',{
			text:'指标数据（生成）',
			id:'btnMkpiCreate',
			handler:function(){
				GetColumnModelIndex("btnMkpiCreate");
				var dynamicStore = GetDynamicStore();
				loginInfoGrid.reconfigure(dynamicStore,GetDynamicColumn());
				ShowGridData(dynamicStore,loginInfoGrid,"btnMkpiCreate");
			}
		},'-',{
			text:'指标任务',
			id:'btnMkpiTask',
			handler:function(){
				GetColumnModelIndex("btnMkpiTask");
				var dynamicStore = GetDynamicStore();
				loginInfoGrid.reconfigure(dynamicStore,GetDynamicColumn());
				ShowGridData(dynamicStore,loginInfoGrid,"btnMkpiTask");
			}
		}]
		})
	});
	
	//		定义panel面板
	var loginInfoPanel = new Ext.Panel({
		title:'指标日志',
		frame:'true',
		monitorResize:true,
		layout:'border',
		items:[{
			region:'north',
			height:95,
			//anchor:'100% 15%',
			autoScroll:true,
			items:loginInfoForm
		},{
			region:'center',
			height:540,
			//anchor:'100% 85%',
			autoScroll:true,
			items:loginInfoGrid
		}]
	});
	
	//		定义动态的grid列模型
	function GetDynamicColumn(){
		var str = "{'columnModel':[new Ext.grid.RowNumberer(),";
		//var sm = new Ext.grid.CheckboxSelectionModel();
		for(var i=0; i<indexArray.length; i++){
			pointer = indexArray[i];
			if (1 == pointer)
			{
				str = str+"{header:'"+headerArray[pointer]+"', dataIndex:'"+dataIndexArray[pointer]+"',width:30, sortable:true},";
				i=i+1, pointer = indexArray[i];
			}
			//	控制列宽,按数值所占总宽的百分比
			var numOfWidth=300
			if (pointer<=6) numOfWidth=100
			if ((8==pointer)||(13==pointer)||(16==pointer)) numOfWidth=100
			str = str+"{header:'"+headerArray[pointer]+"', dataIndex:'"+dataIndexArray[pointer]+"', sortable:true, width:"+numOfWidth+"},";
		}
		str = str.substring(0, str.length-1)+"]}";
		var jsonColumn = new Ext.util.JSON.decode(str);		//将json字符串解析成为对象
		cm = new Ext.grid.ColumnModel(jsonColumn.columnModel);
		//cm.setConfig([sm,jsonColumn]);

		return cm;
	};

	//		定义动态的store数据池
	function GetDynamicStore(){
		if ("" == loginType)
		{
			GetColumnModelIndex(null);
		}
		var str = "{'fields':[";
		for (var i=0; i<indexArray.length; i++){
			pointer=indexArray[i];
			str = str+"{name:'"+dataIndexArray[pointer]+"', mapping:'"+dataIndexArray[pointer]+"'},";
		}
		var fields = str.substring(0,str.length-1)+"]}";
		var jsonFields = new Ext.util.JSON.decode(fields);
		
		dynamicStore = new Ext.data.JsonStore({
			url:serviceUrl+'?&action=looup&pageSize=15&loginType='+loginType,
			totalProperty:'totalNum',
			root:'root',
			fields:jsonFields.fields,
			autoLoad:true
		});
		return dynamicStore;
	};

	//		创建pagingToolbar
	function GetPagingBar(){
		pagingBar = new Ext.PagingToolbar({
			pageSize:pageSize,
			store:GetDynamicStore()
			//displayInfo:true,
			//displayMsg:'第{0}条到{1}条, sum:{2}',
			//emptyMsg:'sorry,data not found!'
		});
		return pagingBar;
	};

	//		访问server，请求数据并展示
	function ShowGridData(store,loginInfoGrid,btnId){
		var fromDate=Ext.get("fromDate").getValue();
		var toDate=Ext.get("toDate").getValue();
		if (fromDate>toDate)
		{
			Ext.MessageBox.alert("消息","   开始日期不可以大于结束日期哦   ");
			return;
		}
		
		paraList='&fromDate='+fromDate+'&toDate='+toDate;
		
		store.proxy.setUrl(encodeURI(serviceUrl+"?action=lookup&loginType="+loginType+paraList+"&start=1&limit=15&pageSize=15"));
		store.load();
		loginInfoGrid.show();
		//Ext.MessageBox.alert("message","hey, my friend: "+fromDate+"~"+toDate+loginType);
	};

	//		响应用户操作，调控数据模型
	function GetColumnModelIndex(btnId){
		switch (btnId)
		{
		case "btnMkpiDefineAdd":
			loginType = "MKPIDefineAdd";
			indexArray = [1,2,3,4,5,6,8,9,16];
			break;
		case "btnMkpiDefineUpdate":
			loginType = "MKPIDefineUpdate";
			indexArray = [1,2,3,4,5,6,8,9,10,16];
			break;
		case "btnMkpiDefineDelete":
			loginType = "MKPIDefineDelete";
			indexArray = [1,2,3,4,5,6,8,9,10,16];
			break;
		case "btnMkpiDataGet":
			loginType = "MKPIDataGet";
			indexArray = [1,2,3,4,5,6,7,8,11,12,13,14,16];
			break;
		case "btnMkpiCreate":
			loginType = "MKPIDataCreate";
			indexArray = [1,2,3,4,5,6,7,8,13,14,15,16];
			break;
		case "btnMkpiTask":
			loginType = "MKPITask";
			indexArray = [1,2,3,4,6,7,13,14,15,16];
			break;
		default:
			loginType = "MKPIDefineUpdate";
			indexArray = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];
		};
	};


	this.getKpiLoginInfoPanel=function(){
    	return loginInfoPanel;
	}
}