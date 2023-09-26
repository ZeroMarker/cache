
/*
*/

$(function(){
	InitWardList();
	InitPatNoList();
	InitOrdItmdgList();
	InitStatusDg();
	InitCurLabel();

});



//初始化病人列表
function InitWardList()
{
	//定义columns
	var columns=[[
		{field:"WardID",title:'WardID',hidden:true},
		{field:'WardDesc',title:'病区',width:180},
		{field:'Sum',title:'总数',width:50}
	]];
	
	//定义datagrid
	$('#warddg').datagrid({
		 width:'100%',
	    height:'100%',
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		//pageSize:100,  // 每页显示的记录条数
		//pageList:[100],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
	    onDblClickRow:function(rowIndex,rowData){
		   //var wardId=rowData.WardID;
		   //var wardDesc=rowData.WardDesc
		   //var inputs=wardId+","+wardDesc
		   //QueryDetail(rowIndex,rowData);
	   }


	});
    initScroll("#warddg");
}



function InitPatNoList()
{
	
	//定义columns
	var columnspat=[[
	    {field:'RegNo',title:'登记号',width:60},
		{field:'Adm',title:'adm',width:60},
		{field:'AdmDate',title:'就诊日期',width:100},
		{field:'AdmTime',title:'就诊时间',width:100},
		{field:'AdmLoc',title:'就诊科室',width:100},
		{field:'CurrWard',title:'病区',width:100},
		{field:'CurrWardID',title:'病区ID',width:100},
		{field:'Currbed',title:'床号',width:100},
		{field:'Currdoc',title:'医生',width:100}
		
	]];
	
	//定义datagrid
	$('#admdg').datagrid({
		url:'',
		toolbar:'#patnodgBar',
		fit:true,
		rownumbers:true,
		columns:columnspat,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80,120,160],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
	    onDblClickRow:function(rowIndex,rowData){
		   //var pointer=rowData.CurrWardID;
		  // QuerySubDb(inputs);
		  //var AdmId=rowData.Adm;
		  //QueryResult(pointer,AdmId)
		   }
	});

	initScroll("#admdg");
}



//初始化审核列表
function InitOrdItmdgList()
{
	
	//定义columns
	var columnspat=[[
		

		
		{field:'TbRegNo',title:'床号',width:50},
		{field:"TbName",title:'姓名',width:50},
		{field:'TbBatNo',title:'批次',width:50,
		  editor:{type:'validatebox',options:{required:'true'} }
		 },
		{field:'TbItmDesc',title:'主药',width:180},
		{field:'TbItmDesc1',title:'溶媒',width:180},
		{field:'TbQty',title:'频次',width:50},
		{field:'TbDosage',title:'剂量',width:50}
	]];
	                                                          
	//定义datagrid
	$('#ordtimdg').datagrid({
		url:'',
		fit:true,
		singleSelect:true,
		toolbar:'#orditmgbbar',
		rownumbers:true,
		columns:columnspat,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80,120,160],   // 可以设置每页记录条数的列表
		loadMsg: '正在加载信息...',
		pagination:true,
	    onDblClickRow:function(rowIndex,rowData){
        }
	   
	
	});

    initScroll("#ordtimdg");
}

//当前瓶签
function InitCurLabel()
{
	
	//定义columns
	var columnspat=[[
		{field:'ward',title:'病区',width:180},
	    {field:'drug',title:'配伍',width:60},
		{field:'freq',title:'打签',width:60},
		{field:'dose1',title:'排药',width:60},
		{field:'dose2',title:'核对',width:60},
		{field:'dose3',title:'配置',width:60},
		{field:'dose4',title:'成品核对',width:60},
		{field:'dose5',title:'打包',width:60},
		{field:'dose6',title:'停止',width:60},
		{field:'dose7',title:'停止核对',width:60}
		
	]];
	
	//定义datagrid
	$('#statusdg').datagrid({
		url:'',
		toolbar:'#curlabeldgbar',
		fit:true,
		rownumbers:true,
		columns:columnspat,
		//pageSize:40,  // 每页显示的记录条数
		//pageList:[40,80,120,160],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:false,
	    onDblClickRow:function(rowIndex,rowData){
		   //var pointer=rowData.CurrWardID;
		  // QuerySubDb(inputs);
		  //var AdmId=rowData.Adm;
		  //QueryResult(pointer,AdmId)
		   }
	});

	initScroll("#statusdg");
}


//
function InitStatusDg()
{
	
	//定义columns
	var columnsdrug=[[
		{field:'ward',title:'药品',width:180},
	    {field:'drug',title:'频次',width:60},
		{field:'freq',title:'剂量',width:60}
		
	]];
	
	//定义datagrid
	$('#executedg').datagrid({
		url:'',
		toolbar:'#executedgbar',
		fit:true,
		rownumbers:true,
		columns:columnsdrug,
		//pageSize:40,  // 每页显示的记录条数
		//pageList:[40,80,120,160],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:false,
	    onDblClickRow:function(rowIndex,rowData){
		   //var pointer=rowData.CurrWardID;
		  // QuerySubDb(inputs);
		  //var AdmId=rowData.Adm;
		  //QueryResult(pointer,AdmId)
		   }
	});

	initScroll("#executedg");
}



