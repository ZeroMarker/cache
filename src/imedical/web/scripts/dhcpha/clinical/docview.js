
/// Creator: bianshuai
/// CreateDate: 2014-06-22
//  Descript: 报告浏览

//定义Url
var url="dhcpha.clinical.action.csp";
var winScrHeight=window.screen.height;        //屏幕分辨率的高
var winScrWidth=window.screen.width;          //屏幕分辨率的宽

$(function(){
	
	//定义columns
	var columns=[[
	    {field:'docID',title:'docID',width:100},
	    {field:'creDate',title:'日期',width:100},
		{field:'creTime',title:'时间',width:100},
		{field:'title',title:'文档名',width:300},
		{field:'author',title:'作者',width:120}
	]];
	
	//定义datagrid
	$('#dg').datagrid({
		title:'文档浏览',    
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:30,  // 每页显示的记录条数
		pageList:[30,45],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true
	});
	
	initScroll('#dg');//初始化显示横向滚动条
	
	$("#StartDate").datebox("setValue", formatDate(-1));  //Init起始日期
	$("#EndDate").datebox("setValue", formatDate(0));  //Init结束日期
	
	//查询按钮绑定事件
	$('#btnQuery').bind('click',function(){
		Query();  //查询
	})
	
	//预览按钮绑定事件
	$('#btnView').bind('click',function(){
		view();  //预览
	})
	
	//修订按钮绑定事件
	$('#btnMod').bind('click',function(){
		Mod();  //修订
	})
	
	//删除按钮绑定事件
	$('#btnDel').bind('click',function(){
		Del();  //删除
	})
})

/// 提交文档到服务器
function SaveFileToServer(repID)
{
	///计数器
	var pid=tkMakeServerCall("web.DHCSTPHCMLECTURES","NewPid");

	///准备数据
	var FileBase64Str=document.all.WebOffice1.GetFileBase64("",0);
	if(FileBase64Str.length==0){
		$.messager.alert("提示","文件二进制码转换失败!");
		return;
	}

	var Len=Math.ceil(FileBase64Str.length/20000);
	var TmpBaseStr="",mytrn="";
	for(var i=0;i<Len;i++){
		TmpBaseStr=FileBase64Str.substring(i*20000,20000*(i+1));
		mytrn=tkMakeServerCall("web.DHCSTPHCMLECTURES","saveFileBase64",pid,TmpBaseStr);      ///循环截取字符串存入数据库
		if(mytrn!=0){
			break;	
		}
	}

	///准备数据完成后,调用后台程序生成对应的数据流,存入表结构
	if(mytrn==0){
		mytrn=tkMakeServerCall("web.DHCSTPHCMLECTURES","modFile",pid,Len,repID);
		if(mytrn!=0){
			alert("保存失败,错误原因:"+mytrn);
			return;
		}
		alert("保存成功!");
	}
	return;
}

/// 文件在线浏览
function OpenFileOnline(RepID,editflag)
{
	CloseWord();  //先关闭当前Word,再进行打开
	$.post(url+'?action=OpenFile',{"RepID":RepID},function(data){
		if(data.replace(/(^\s*)|(\s*$)/g, "").length!=""){
			var tempPath=document.all.WebOffice1.GetTempFilePath();//获取临时文件路径
			//alert("文档存到本地临时路径："+tempPath);
			document.all.WebOffice1.SaveBinaryFileFromBase64(tempPath,data.replace(/(^\s*)|(\s*$)/g, ""));
			document.all.WebOffice1.LoadOriginalFile(tempPath,"doc");
			if(editflag==1){
				showWebofficeToolBar();
			}else{
				hideAll('','','','');   ///2003版隐藏菜单
				hideWebofficeToolBar();
			}
		}
	});
}

/// 关闭Word
function CloseWord(){

  document.all.WebOffice1.CloseDoc(0); 
}

/// 查询
function Query()
{
	var StDate=$('#StartDate').datebox('getValue'); //起始日期
	var EndDate=$('#EndDate').datebox('getValue');  //截止日期
	var params=StDate+"^"+EndDate;
	$('#dg').datagrid({
		url:url+'?action=QueryDocMan',	
		queryParams:{
			params:params}
	});
}

///创建浏览窗体
function createMedViewWin(RepID)
{
   	$('#mwin').css("display","block");
	$('#mwin').dialog({
		title:'浏览',
		width:winScrWidth-300, //1000,
		height:winScrHeight-200, //750,
		border:true,
		closed:"true",
		collapsible:true,
	    modal: true
	});
    $('#mwin').dialog('open');
    OpenFileOnline(RepID,0);
    document.all.WebOffice1.height="670";
}

///创建编辑窗体
function showEditWin(RepID)
{
   	$('#mwin').css("display","block");
	$('#mwin').dialog({
		title:'修订',
		width:winScrWidth-300, //1000,
		height:winScrHeight-200, //750,
		border:true,
		closed:"true",
		collapsible:true,
		onClose:function(){
			//$('#mwin').remove();  //窗口关闭时移除win的DIV标签
		},
	    modal: true,
		buttons:[{
			text:'保存',
			iconCls:'icon-save',
			handler:function(){
				save(RepID);
				$('#mwin').dialog("close");
				$('#mwin').css("display","none");
				CloseWord();
				}
		},{
			text:'关闭',
			iconCls:'icon-cancel',
			handler:function(){
				$('#mwin').dialog("close");
				$('#mwin').css("display","none");
				CloseWord();
				}
		}]
	});
	document.all.WebOffice1.height="630";
    $('#mwin').dialog('open');
    OpenFileOnline(RepID,1);
}

/// 删除文档
function Del()
{
	var RepID="";
	var row=$('#dg').datagrid('getSelected');
	if (row){
		RepID=row.docID;
	}else{
		$.messager.alert('错误提示','请先选择一行记录!',"error");
		return;
	}
	if(RepID==""){
		$.messager.alert("提示","请选择记录,重试!");
		return;
	}

	$.post(url+"?action=delFile",{params:RepID},function(content){
		if(content.replace(/(^\s*)|(\s*$)/g, "")!=0){
			$.messager.alert("提示","删除失败!");
			return;
		}
		$.messager.alert("提示","删除成功!");
		Query();  //删除成功之后,重新刷新
	});	
}

///显示编辑窗体
function Mod()
{
	var RepID="";
	var row=$('#dg').datagrid('getSelected');
	if (row){
		RepID=row.docID;
	}else{
		$.messager.alert('错误提示','请先选择一行记录!',"error");
		return;
	}
	showEditWin(RepID);
}

///显示预览窗体
function view()
{
	var RepID="";
	var row=$('#dg').datagrid('getSelected');
	if (row){
		RepID=row.docID;
	}else{
		$.messager.alert('错误提示','请先选择一行记录!',"error");
		return;
	}
	createMedViewWin(RepID);
}

///保存
function save(RepID)
{
	SaveFileToServer(RepID);
}

/// 关闭Word
function CloseWord(){

  document.all.WebOffice1.CloseDoc(0); 
}