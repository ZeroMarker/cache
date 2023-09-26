/*
* 药学监护维护
* pengzhikun
*/
var editRow="";  //当前编辑行号
var url="dhcpha.clinical.action.csp";
var ctlocArray = [{ "val": "1067", "text": "小儿外科" }, { "val": "970", "text": "普外科" }, { "val": "971", "text": "抗凝专业" },
	{ "val": "1209", "text": "肾脏科" }, { "val": "999", "text": "内分泌科" }, { "val": "1081", "text": "心内科" },
	{ "val": "1151", "text": "肿瘤化疗科" }];
$(document).ready(function(){
	//根据点击明细显示窗口panel
	$('.easyui-accordion ul li a').click(function(){
		 var panelTitle = $(this).text();
		 //点击侧菜单的显示相应界面
		 choseMenu(panelTitle);
	});
			
})

function choseMenu(item){
	switch(item){
		case "监护级别维护":
			//防止重复点击，而此时Flag=1，导致不执行创建界面
			if(Flag1==0){
				//隐藏mainpanel的所有子节点
				$("#mainPanel").children().css("display","none")
				//动态创建一个"新入院患者"的panel
				createLevelPanel();
				//设置mainPanel可见
				$('#mainPanel').css("display","block"); 
				$('#mainPanel').panel({
					title:item
				});
			}
			
			break;
			
		case "监护项目维护":
			if(Flag2==0){
				//隐藏mainpanel的所有子节点
				$("#mainPanel").children().css("display","none")
				//动态创建一个"住院期间患者"的panel
				createMonItmPanel();
				$('#mainPanel').css("display","block"); 
				$('#mainPanel').panel({
					title:item
				});
				//加载数据
				//loadData();
			}
			break;
			
		case "监护范围维护":
			if(Flag3==0){
				//隐藏mainpanel的所有子节点
				$("#mainPanel").children().css("display","none")
				//动态创建一个"住院期间患者"的panel
				createRangePanel();
				$('#mainPanel').css("display","block"); 
				$('#mainPanel').panel({
					title:item
				});
				//加载数据
				//loadData();
			}
			break;
			
		default:
			break;	
	}
				 	
} 

//--创建"监护级别"主界面--//
var Flag1=0;//防止重复点击，多次创建面板
function createLevelPanel() {
	if(Flag1==0){
		//仅显示咨询主界面
		$("#Level").css("display","block");
		Flag1=1;
		Flag2=0;
		Flag3=0;	
		initLevelData();
		
	}
} 


function initLevelData(){
	$("#levelDG").datagrid({
		idField:"rowid",
		url: url+"?actiontype=GetLevelList",  
		rownumbers:true,
		striped: true,
		pageList : [15, 30, 45],   // 可以设置每页记录条数的列表
		pageSize : 15 ,  // 每页显示的记录条数
		fitColumns:true,
		//sortName: "rowid", //初始化表格时依据的排序 字段 必须和数据库中的字段名称相同
		//sortOrder: "asc",
		singleSelect:true,
		fit: true,
		loadMsg: '正在加载信息...',
		columns: [[
		{	
			field:"rowid",
			title:"ID",
			width:50,
			align:"center"//,
			//hidden:true
		},{	
			field:"code",
			title:"代码",
			width:200,
			align:"left",
			editor:'text'
		},
		{
			field:"desc",
			title:"描述",
			width:200,
			align:"left",
			editor:'text'
		}]],
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editRow != "") { 
                $("#levelDG").datagrid('endEdit', editRow); 
            } 
            $("#levelDG").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        },
	    pagination: true

	})  
	
	//设置分页控件   
	$('#levelDG').datagrid('getPager').pagination({
		showPageList:false,
		beforePageText: '第',//页数文本框前显示的汉字 
		afterPageText: '页    共 {pages} 页',   
		displayMsg: '当前显示 {from} - {to} 条记录   共 {total} 条记录'
	});
}

// 插入新行
function insertLevelRow()
{
	if(editRow>="0"){
		$("#levelDG").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	$("#levelDG").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {rowid: '',code:'',desc: ''}
	});
	$("#levelDG").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

// 删除选中行
function deleteLevelRow()
{
	var rows = $("#levelDG").datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				$.post(url+'?actiontype=DeleteLevel',{"index":rows[0].rowid}, function(data){
					$('#levelDG').datagrid('reload'); //重新加载
				});
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

// 保存编辑行
function saveLevelRow()
{
	if(editRow>="0"){
		$("#levelDG").datagrid('endEdit', editRow);
	}

	var rows = $("#levelDG").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		
		var tmp=rows[i].rowid+"^"+rows[i].code+"^"+rows[i].desc;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");
	//alert(rowstr)
	
	//保存数据
	$.post(url+'?actiontype=UpdateLevel',{"datelist":rowstr},function(data){
		$('#levelDG').datagrid('reload'); //重新加载
	});
}

// 修改选中行
function modifyLevelRow()
{
	var rows = $("#levelDG").datagrid('getSelections'); //选中一行进行编辑
	//选中一行的话触发事件
	if (rows.length == 1)
	{
		if(editRow!=""){
			$("#levelDG").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
		}
		var index = $("#levelDG").datagrid('getRowIndex', rows[0]);//获取选定行的索引
		$("#levelDG").datagrid('beginEdit',index);
		editRow=index;  //记录当前编辑行
	}else{
		$.messager.alert("提示","请选中需编辑行!");
	}
}




//--创建"监护项目"主界面--//
var Flag2=0;//防止重复点击，多次创建面板
function createMonItmPanel() {
	if(Flag2==0){
		//仅显示咨询主界面
		$("#MonItm").css("display","block");
		Flag2=1;
		Flag1=0;
		Flag3=0;
		
		$("#MILevel_comb").combobox({
			onShowPanel:function(){
				$('#MILevel_comb').combobox('reload',url+'?actiontype=GetLevelComb')
			}
		});
	
		$('#MICtloc_comb').combobox({
			panelHeight:"auto",  //设置容器高度自动增长
			data:ctlocArray 
		});
		
		var level=$("#MILevel_comb").combobox('getValue');
		var ctloc=$("#MICtloc_comb").combobox('getValue');
		initMonItmData(level,ctloc);
		
	}
} 

function initMonItmData(level,ctloc){	
		
	$("#MonItmDG").datagrid({
		idField:"rowid",
		url: url+"?actiontype=GetMonItmInfo&level="+level+"&ctloc="+ctloc,
		rownumbers:true,
		striped: true,
		pageList : [20, 30, 40],   // 可以设置每页记录条数的列表
		pageSize : 20 ,  // 每页显示的记录条数
		fitColumns:true,
		//sortName: "rowid", //初始化表格时依据的排序 字段 必须和数据库中的字段名称相同
		//sortOrder: "asc",
		singleSelect:true,
		fit: true,
		loadMsg: '正在加载信息...',
		columns: [[
		{	
			field:"rowid",
			title:"ID",
			width:50,
			align:"center",
			hidden:true
		},{	
			field:"code",
			title:"代码",
			width:50,
			align:"left",
			hidden:true
			
		},
		{
			field:"desc",
			title:"描述",
			width:100,
			align:"left",
			editor:'text'
		},
		{
			field:"level",
			title:"监护级别",
			width:100,
			align:"center",
			editor:{
				type:'combobox',
				options:{
					required:true,
					missingMessage: '请选择级别',
					url:url+'?actiontype=GetLevelComb',
					valueField:'rowid',
					textField:'desc'
					
				}
			}
		},
		{
			field:"ctloc",
			title:"监护科室",
			width:100,
			align:"center",
			editor:{
				type:'combobox',
				options:{
					required:true,
					missingMessage: '请选择科室',
					data:ctlocArray,
					valueField:'val',
					textField:'text'
					
				}
			}
		},
		{
			field:"levelDesc",
			title:"级别",
			width:50,
			align:"center"
			
		},
		{
			field:"ctlocDesc",
			title:"科室",
			width:200,
			align:"center"
			
		}
		
		]],
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editRow != "") { 
                $("#MonItmDG").datagrid('endEdit', editRow); 
            } 
            $("#MonItmDG").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        },
	    pagination: true

	})  
	
	//设置分页控件   
	$('#MonItmDG').datagrid('getPager').pagination({
		showPageList:false,
		beforePageText: '第',//页数文本框前显示的汉字 
		afterPageText: '页    共 {pages} 页',   
		displayMsg: '当前显示 {from} - {to} 条记录   共 {total} 条记录'
	});
}

// 插入新行
function insertMonItmRow()
{
	if(editRow>="0"){
		$("#MonItmDG").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	$("#MonItmDG").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {rowid: '',code:'',desc: '',level:'',ctloc:''}
	});
	$("#MonItmDG").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

function saveMonItmRow()
{
	if(editRow>="0"){
		$("#MonItmDG").datagrid('endEdit', editRow);
	}

	var rows = $("#MonItmDG").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].level=="")||(rows[i].ctloc=="")||(rows[i].desc=="")){
			alert(rows[i].desc)
			alert("第"+(i+1)+"行,"+"有数据没填写！！！");
			return;
			
		}
		var tmp=rows[i].rowid+"^"+rows[i].code+"^"+rows[i].desc+"^"+rows[i].level+"^"+rows[i].ctloc;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");
	//alert(rowstr)

	//保存数据
	
	$.post(url+'?actiontype=UpdateMonItm',{"datelist":rowstr},function(data){
		$('#MonItmDG').datagrid('reload'); //重新加载
	});
	
}

// 删除选中行
function deleteMonItmRow()
{
	var rows = $("#MonItmDG").datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				$.post(url+'?actiontype=DeleteMonItm',{"index":rows[0].rowid}, function(data){
					$('#MonItmDG').datagrid('reload'); //重新加载
				});
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}


function research(){
	var level=$("#level_comb").combobox('getValue');
	var ctloc=$("#ctloc_comb").combobox('getValue');
	/**
	* 下拉框一开始选择了数据，然后又手动清除，再获取值即是undefined，但是需要传给后台的数据是""
	*/
	if(ctloc==undefined){
		ctloc=""
	}
	if(level==undefined){
		level=""
	}
	if(level!="" && ctloc==""){
		alert("请先选择科室,再进行查询!");
		return ;
	}
	initRangeData(level,ctloc);
}


//--创建"监护范围"主界面--//
var Flag3=0; //防止重复点击，多次创建面板
function createRangePanel() {
	if(Flag3==0){
		//仅显示咨询主界面
		$("#Range").css("display","block");
		Flag3=1;
		Flag1=0;
		Flag2=0;
		
		$("#level_comb").combobox({
			onShowPanel:function(){
				$('#level_comb').combobox('reload',url+'?actiontype=GetLevelComb')
			}
		});
	
		$('#ctloc_comb').combobox({
			panelHeight:"auto",  //设置容器高度自动增长
			data:ctlocArray 
		});
		
		var level=$("#level_comb").combobox('getValue');
		var ctloc=$("#ctloc_comb").combobox('getValue');
		initRangeData(level,ctloc);
		
	}
} 

function initRangeData(level,ctloc){	
		
	$("#rangeDG").datagrid({
		idField:"rowid",
		url: url+"?actiontype=getRangeListInfo&level="+level+"&ctloc="+ctloc,
		rownumbers:true,
		striped: true,
		pageList : [20, 30, 40],   // 可以设置每页记录条数的列表
		pageSize : 20 ,  // 每页显示的记录条数
		fitColumns:true,
		//sortName: "rowid", //初始化表格时依据的排序 字段 必须和数据库中的字段名称相同
		//sortOrder: "asc",
		singleSelect:true,
		nowrap: false,   //宽度自适应  2014-12-15 bianshuai
		fit: true,
		loadMsg: '正在加载信息...',
		columns: [[
		{	
			field:"rowid",
			title:"ID",
			width:50,
			align:"center",
			hidden:true
		},{	
			field:"code",
			title:"代码",
			width:50,
			align:"left",
			hidden:true
			
		},
		{
			field:"desc",
			title:"描述",
			width:400,
			align:"left",
			editor:'text'
		},
		{
			field:"level",
			title:"监护级别",
			width:100,
			align:"center",
			editor:{
				type:'combobox',
				options:{
					required:true,
					missingMessage: '请选择级别',
					url:url+'?actiontype=GetLevelComb',
					valueField:'rowid',
					textField:'desc'
					
				}
			}
		},
		{
			field:"ctloc",
			title:"监护科室",
			width:100,
			align:"center",
			editor:{
				type:'combobox',
				options:{
					required:true,
					missingMessage: '请选择科室',
					data:ctlocArray,
					valueField:'val',
					textField:'text'
					
				}
			}
		},
		{
			field:"levelDesc",
			title:"级别",
			width:50,
			align:"center"
			
		},
		{
			field:"ctlocDesc",
			title:"科室",
			width:200,
			align:"center"
			
		}
		
		]],
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editRow != "") { 
                $("#rangeDG").datagrid('endEdit', editRow); 
            } 
            $("#rangeDG").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        },
	    pagination: true

	})  
	
	//设置分页控件   
	$('#rangeDG').datagrid('getPager').pagination({
		showPageList:false,
		beforePageText: '第',//页数文本框前显示的汉字 
		afterPageText: '页    共 {pages} 页',   
		displayMsg: '当前显示 {from} - {to} 条记录   共 {total} 条记录'
	});
}

// 插入新行
function insertRangeRow()
{
	if(editRow>="0"){
		$("#rangeDG").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	$("#rangeDG").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {rowid: '',code:'',desc: '',level:'',ctloc:''}
	});
	$("#rangeDG").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

function saveRangeRow()
{
	if(editRow>="0"){
		$("#rangeDG").datagrid('endEdit', editRow);
	}

	var rows = $("#rangeDG").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].level=="")||(rows[i].ctloc=="")||(rows[i].desc=="")){
			alert(rows[i].desc)
			alert("第"+(i+1)+"行,"+"有数据没填写！！！");
			return;
			
		}
		var tmp=rows[i].rowid+"^"+rows[i].code+"^"+rows[i].desc+"^"+rows[i].level+"^"+rows[i].ctloc;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");
	//alert(rowstr)

	//保存数据
	
	$.post(url+'?actiontype=UpdateRange',{"datelist":rowstr},function(data){
		$('#rangeDG').datagrid('reload'); //重新加载
	});
	
}

// 删除选中行
function deleteRangeRow()
{
	var rows = $("#rangeDG").datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				$.post(url+'?actiontype=DeleteRange',{"index":rows[0].rowid}, function(data){
					$('#rangeDG').datagrid('reload'); //重新加载
				});
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

//点击查询按钮进行统计
function researchMonItm(){
	var level=$("#MILevel_comb").combobox('getValue');
	var ctloc=$("#MICtloc_comb").combobox('getValue');
	if(ctloc==undefined){
		ctloc=""
	}
	if(level==undefined){
		level=""
	}
	if(level!="" && ctloc==""){
		alert("请先选择科室,再进行查询!");
		return ;
	}
	initMonItmData(level,ctloc);
}