/// Creator: bianshuai
/// CreateDate: 2015-03-20
//  Descript: 文献阅读

var url="dhcpha.clinical.action.csp";

$(function(){

	$("#stdate").datebox("setValue", formatDate(-2));  //Init起始日期
	$("#enddate").datebox("setValue", formatDate(0));  //Init结束日期
	
	$('a:contains("查询")').bind("click",Query);   //查询
	$('a:contains("新建")').bind("click",NewWin);  //新建
	$('a:contains("下载")').bind("click",downLoad);  //下载
	$('a:contains("浏览")').bind("click",view);  //浏览
	$('a:contains("修改")').bind("click",mod);  //修改
	$('a:contains("删除")').bind("click",del);  //删除
	
	InitPatList(); //初始化病人列表
})

//查询
function Query()
{
	//1、清空datagrid 
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
	//2、查询
	var StDate=$('#stdate').datebox('getValue');   //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var LocID=$('#dept').combobox('getValue');     //科室ID
	var status=$('#status').combobox('getValue');  //状态
	if (typeof LocID=="undefined"){LocID="";}
	var PatNo=$.trim($("#patno").val());
	var UserID=session['LOGON.USERID'];       //用户
	var LocId=session['LOGON.CTLOCID'];       //科室
	var GroupId=session['LOGON.GROUPID'];     //安全组
	var params=StDate+"^"+EndDate+"^"+LocID+"^"+PatNo+"^"+GroupId+"^"+LocId+"^"+UserID+"^"+status;

	$('#maindg').datagrid({
		url:url+'?action=GetAdrReport',	
		queryParams:{
			params:params}
	});
}

//初始化病人列表
function InitPatList()
{
	//定义columns
	var columns=[[
		{field:"documentID",title:'documentID',width:90},
		{field:'date',title:'日期',width:100},
		{field:'title',title:'题目',width:160},
		{field:'user',title:'主讲人',width:100},
		{field:'content',title:'主要内容',width:260},
		{field:'liters',title:'参考文献',width:320},
		{field:'partuser',title:'参加人员',width:320},
		{field:'address',title:'地点',width:160}
	]];
	
	//定义datagrid
	$('#maindg').datagrid({
		title:'病历讨论',
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:false,
		loadMsg: '正在加载信息...',
		pagination:true
	});
	
	initScroll("#maindg");//初始化显示横向滚动条
        $('#maindg').datagrid('loadData', {total:0,rows:[]});
}

/*******************下载**********************/
function downLoad()
{
}

/*******************浏览**********************/
function view()
{
}

/*******************删除**********************/
function del()
{
}

/*******************修改**********************/
function mod()
{
}


/*******************新建窗体**********************/
function NewWin()
{	
	clearDialog();
	$('#newwin').css("display","block");
	$('#newwin').dialog({
		title:"新建【病历讨论】",
		collapsible:false,
		border:false,
		closed:"true",
		width:800,
		height:420,
		buttons:[{
				text:'保存',
				iconCls:'icon-save',
				handler:function(){
					closeNewWin(); ///关闭新建窗体
					}
			},{
				text:'退出',
				iconCls:'icon-cancel',
				handler:function(){
					closeNewWin();  ///关闭新建窗体
					}
			}]
	});
	///显示对话框	
	$('#newwin').dialog('open');
}

/*******************关闭新建窗体**********************/
function closeNewWin()
{
	$('#newwin').dialog('close');
	$("#newwin").css("display","none");
}

/// Creator: qunianpeng
/// CreateDate: 2016-08-01
//  Descript: 清空新建窗口
function clearDialog(){	
	$("#date").datebox("setValue","");  // 日期
	$("#address").val("");			 // 地点
	$("#user").val("");				// 主讲人
	$("#file").val("");	             // 添加文件	
	$("#title").val("");			//题目
	$("#content").val("");			//主要内容
	$("#liters").val("");				//参考文献
	$("#partuser").val("");			//参加人员
 
}