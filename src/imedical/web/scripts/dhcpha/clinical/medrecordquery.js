
/// Creator: bianshuai
/// CreateDate: 2014-06-22
//  Descript: 药历查询

//定义Url
var url="dhcpha.clinical.action.csp";

$(function(){
	
	//定义columns
	var columns=[[
	    {field:'AdmDr',title:'AdmDr',width:100},
		{field:'PatNo',title:'登记号',width:80},
		{field:'PatName',title:'姓名',width:80},
		{field:'Ward',title:'病区',width:160},
		{field:'AdmLoc',title:'就诊科室',width:120},
		{field:'PatInDate',title:'入院时间',width:100},
		{field:'CreateTime',title:'创建时间',width:140},
		{field:'CreateUser',title:'创建人',width:100},
		{field:'MedView',title:'浏览',width:100,
			formatter:unitformatter
		}
	]];
	
	//定义datagrid
	$('#dg').datagrid({
		title:'药历查询',    
		url:'',
		fit:true,
		//fitColumns:true,
		rownumbers:true,
		columns:columns,
		pageSize:30,  // 每页显示的记录条数
		pageList:[30,45],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true
	});
	
	initScroll();//初始化显示横向滚动条
	
	$("#StartDate").datebox("setValue", formatDate(-1));  //Init起始日期
	$("#EndDate").datebox("setValue", formatDate(0));  //Init结束日期
	
	//用户
	$('#User').combobox({
		//panelHeight:"auto",  //设置容器高度自动增长
		url:url+'?actiontype=SelUserByGrp&grpId='+session['LOGON.GROUPID']
	}); 
	
	//查询按钮绑定事件
	$('#Query').bind('click',function(){
		Query();  //查询
		//createMedViewWin(); //浏览
	})
})

/// 默认显示横向滚动条
function initScroll(){
	var opts=$('#dg').datagrid('options');    
	var text='{';    
	for(var i=0;i<opts.columns.length;i++)
	{    
		var inner_len=opts.columns[i].length;    
		for(var j=0;j<inner_len;j++)
		{    
			if((typeof opts.columns[i][j].field)=='undefined')break;    
			text+="'"+opts.columns[i][j].field+"':''";    
			if(j!=inner_len-1){    
				text+=",";    
			}    
		}    
	}    
	text+="}";    
	text=eval("("+text+")");    
	var data={"total":1,"rows":[text]};    
	$('#dg').datagrid('loadData',data);  
	$("tr[datagrid-row-index='0']").css({"visibility":"hidden"});
}

/// 格式化日期
function formatDate(t)
{
	var curr_time = new Date();  
	var Year = curr_time.getFullYear();
	var Month = curr_time.getMonth()+1;
	var Day = curr_time.getDate()+parseInt(t);
	return Month+"/"+Day+"/"+Year;
}

/// 格式化
function unitformatter(value, rowData, rowIndex){
	return "<a href='#' onclick='showWin("+rowData.AdmDr+")'>浏览</a>";
}

/// 查询
function Query()
{
	var StDate=$('#StartDate').datebox('getValue'); //起始日期
	var EndDate=$('#EndDate').datebox('getValue');  //截止日期
	var UserID=$('#User').combobox('getValue'); //用户ID
	var KeyWords=$('#keywords').val();          //关键字[诊断]
	var params=StDate+"^"+EndDate+"^"+UserID+"^"+KeyWords;
	$('#dg').datagrid({
		url:url+'?action=QueryMedRecord',	
		queryParams:{
			params:params}
	});
}

///显示窗口 formatter="SetCellUrl"
function showWin(AdmDr)
{
	createMedViewWin(AdmDr); //调用窗体 createMedViewWin
}

///创建浏览窗体
function createMedViewWin(adm)
{
	//窗体存在,先进行移除
	if($('#win').is(":visible")){
		$('#win').remove();
	}  
	
	$('body').append('<div id="win"></div>');

	$('#win').window({
		title:'药历浏览',
		width:1200,
		height:520,
		border:true,
		closed:"true",
		collapsible:true,
		maximized:true, //窗口最大化
		onClose:function(){
			$('#win').remove();  //窗口关闭时移除win的DIV标签
		}
	}); 

	var PatientID="108075";
	var EpisodeID=adm;
	var DocID="55";
	var UserID=session['LOGON.USERID'];
	
	var PrintDocID=521;
	var TemplateDocID=72;
	var ChartItemID="ML521";
	var content = '<iframe id = "framRecord" scrolling="no" frameborder="0" src="epr.newfw.episodelistbrowser.csp?USERNAME=epr&PASSWORD=1&LANGID=1&DEPARTMENT=QY-全院&EpisodeID='+EpisodeID+'" style="width:100%;height:100%;"></iframe>';

	$('#win').html(content);
	$('#win').window('open');
}

