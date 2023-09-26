 
/// Creator: bianshuai
/// CreateDate: 2014-06-22
//  Descript: 报告浏览

//定义Url
var url="dhcpha.clinical.action.csp";
var winScrHeight=window.screen.height;        //屏幕分辨率的高
var winScrWidth=window.screen.width;          //屏幕分辨率的宽

$(function(){
	//新建[空白文档]按钮绑定事件
	$('#bnew').bind('click',function(){
		newFile();
	})

	//新建[引用模板]按钮绑定事件
	$('#bnewtemp').bind('click',function(){
		newFileByTemp();
	})
	
	//上传按钮绑定事件
	$('#bupload').bind('click',function(){
		upLoadFile();
	})
	
	//修改按钮绑定事件
	$('#bmod').bind('click',function(){
		modFile();
	})
	
	//删除按钮绑定事件
	$('#bdel').bind('click',function(){
		delFile();
	})
	
	$("#StartDate").datebox("setValue", formatDate(-1));  //Init起始日期
	$("#EndDate").datebox("setValue", formatDate(0));  //Init结束日期
	
	//查询按钮绑定事件
	$('#btnQuery').bind('click',function(){
		queryFile();  //查询
	})
	
	//定义columns
	var columns=[[
	    {field:'RowID',title:'RowID',width:100},
		{field:'Title',title:'模板名称',width:300},
		{field:'UpUser',title:'上传人',width:120},
		{field:'UpDate',title:'上传日期',width:120},
		{field:'UpTime',title:'上传时间',width:120}
	]];
	
	//定义datagrid
	$('#dg').datagrid({
		//title:'',    
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
	    singleSelect:true,
		loadMsg: '正在加载信息...'
	});
	
	initScroll('#dg');   //初始化显示横向滚动条
	
	$('#dg').datagrid({
		url:url+'?action=LoadTempInfo'
	});
	
	//定义columns
	var columns=[[
	    {field:'RowID',title:'RowID',width:100},
		{field:'title',title:'名称',width:300},
		{field:'upuser',title:'上传人',width:120},
		{field:'update',title:'上传日期',width:120},
		{field:'uptime',title:'上传时间',width:120},
		{field:'moduser',title:'修改人',width:120},
		{field:'moddate',title:'修改日期',width:120},
		{field:'modtime',title:'修改时间',width:120}
	]];
	
	//定义datagrid
	$('#dgperdetail').datagrid({
		//title:'',    
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:30,  		// 每页显示的记录条数
		pageList:[30,45],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true
	});
	
	initScroll('#dgperdetail');//初始化显示横向滚动条
	queryFile();
})

/// 提交文档到服务器
function SaveFileToServer()
{
	///获取上传文件名称
	var fileName=$("input[name=fileName]").val();
	if(fileName==""){
		alert("请填写文件名称,重试!");
		return;
	}
	
	var mainstr=session['LOGON.USERID']+"^"+fileName;

	///计数器
	var pid=tkMakeServerCall("web.DHCSTPHCMLECTURES","NewPid");

	///准备数据
	var FileBase64Str=document.all.WebOffice1.GetFileBase64("",0);
	if(FileBase64Str.length==0){
		alert("文件二进制码转换失败!");
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
		mytrn=tkMakeServerCall("web.DHCSTPHCMLECTURES","saveRep",pid,Len,mainstr);
		if(mytrn!=0){
			alert("保存失败,错误原因:"+mytrn);
			return;
		}
		alert("保存成功!");
		$('#UpLoadWin').dialog("close");  //关闭窗体
		$('#UpLoadWin').css("display","none");
		queryFile();  //保存成功后,页面刷新
	}
	return;
}

/// 文件在线浏览
function newDocByTemp(RepID)
{
	document.all.WebOffice1.CloseDoc(0);   //先关闭当前Word,再进行打开
	$.post(url+'?action=OpenTempFile',{"RepID":RepID},function(data){
		if(data.replace(/(^\s*)|(\s*$)/g, "").length!=""){
			var tempPath=document.all.WebOffice1.GetTempFilePath();//获取临时文件路径
			//alert("文档存到本地临时路径："+tempPath);
			document.all.WebOffice1.SaveBinaryFileFromBase64(tempPath,data.replace(/(^\s*)|(\s*$)/g, ""));
			document.all.WebOffice1.LoadOriginalFile(tempPath,"doc");
		}
	});
}

/// 打开窗口
function windowOpen()
{
	window.open ('','editwindow','height=100,width=400,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no');
}

/// 新建[空白文档]
function newFile()
{
	showEditWin("0");
}

/// 新建[引用模板]
function newFileByTemp()
{
	showEditWin("1");
}

/// 上传
function upLoadFile()
{
	showUpLoadWin();  //弹出上传窗口
}

/// 修改
function modFile()
{
	showEditWin("2");
}

///创建编辑窗体
function showEditWin(setflag)
{
	var RepID="";
    if(setflag=="0"){
		hideWebofficeToolBar(); //隐藏工具栏
		newDoc();  //新建
	}else if(setflag=="1"){
		var RepID="";
		var row=$('#dg').datagrid('getSelected');
		if (row){
			RepID=row.RowID;
		}else{
			alert('请先选择一行记录!');
			return;
		}
		if(RepID==""){
			alert("请选择记录,重试!");
			return;
		}
		newDocByTemp(RepID);  //按照模板新建
	}else if(setflag=="2"){
		var RepID="";
		var row=$('#dgperdetail').datagrid('getSelected');
		if (row){
			RepID=row.RowID;
		}else{
			alert('请先选择一行记录!');
			return;
		}
		if(RepID==""){
			alert("请选择记录,重试!");
			return;
		}
		openDocToEdit(RepID); //在线进行编辑
	}
	
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
				if(setflag==2){
					SaveModFileToServer(RepID);
				}else{
					SaveNewFileToServer();
				}
				//$('#mwin').dialog("close");
				//$('#mwin').css("display","none");
				//document.all.WebOffice1.CloseDoc(0); 
				}
		},{
			text:'关闭',
			iconCls:'icon-cancel',
			handler:function(){
				$('#mwin').dialog("close");
				$('#mwin').css("display","none");
				document.all.WebOffice1.CloseDoc(0); 
				}
		}]
	});
	
    $('#mwin').dialog('open');

}

/// 在线进行编辑
function openDocToEdit(RepID)
{
	document.all.WebOffice1.CloseDoc(0);   //先关闭当前Word,再进行打开
	$.post(url+'?action=OpenFile',{"RepID":RepID},function(data){
		if(data.replace(/(^\s*)|(\s*$)/g, "").length!=""){
			var tempPath=document.all.WebOffice1.GetTempFilePath();//获取临时文件路径
			//alert("文档存到本地临时路径："+tempPath);
			document.all.WebOffice1.SaveBinaryFileFromBase64(tempPath,data.replace(/(^\s*)|(\s*$)/g, ""));
			document.all.WebOffice1.LoadOriginalFile(tempPath,"doc");
		}
	});
}

/// 查询
function queryFile()
{
	var StDate=$('#StartDate').datebox('getValue'); //起始日期
	var EndDate=$('#EndDate').datebox('getValue');  //截止日期
	var params=StDate+"^"+EndDate;
	$('#dgperdetail').datagrid({
		url:url+'?action=QueryDocByLogUser',	
		queryParams:{
			params:params}
	});
}

/// 删除文档
function delFile()
{
	$.messager.confirm("提示:","您确认要删除当前选中记录吗？",function(r){
		if(r){
			var RepID="";
			var row=$('#dgperdetail').datagrid('getSelected');
			if (row){
				RepID=row.RowID;
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
				queryFile();  //删除成功之后,重新刷新
			});
		}
	});
}

///创建上传窗口
function showUpLoadWin()
{
	$('#UpLoadWin').css("display","block");
	$('#UpLoadWin').dialog({
		title:'上传',
		width:450,
		height:230,
		closed: false,    
	    cache: false,
	    modal: true,
		buttons:[{
			text:'提交',
			iconCls:'icon-save',
			handler:function(){
				SaveFileToServer();  //提交保存
			}
		},{
			text:'关闭',
			iconCls:'icon-cancel',
			handler:function(){
				$('#UpLoadWin').dialog("close");
				$('#UpLoadWin').css("display","none");
		}
		}] 
	});
	     
	$('#UpLoadWin').dialog('open');
}

/// 提交文档到服务器
function SaveNewFileToServer()
{
	var fileName=prompt("请输入即将保存的文档名称","");
	/*
	///获取上传文件名称
	var fileName=$("input[name=fileName]").val();
	if(fileName==""){
		alert("请填写文件名称,重试!");
		return;
	}
	*/
	var mainstr=session['LOGON.USERID']+"^"+fileName;

	///计数器
	var pid=tkMakeServerCall("web.DHCSTPHCMLECTURES","NewPid");

	///准备数据
	var FileBase64Str=document.all.WebOffice1.GetFileBase64("",0);
	if(FileBase64Str.length==0){
		alert("文件二进制码转换失败!");
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
		mytrn=tkMakeServerCall("web.DHCSTPHCMLECTURES","saveRep",pid,Len,mainstr);
		if(mytrn!=0){
			alert("保存失败,错误原因:"+mytrn);
			return;
		}
		alert("保存成功!");
		$('#mwin').dialog("close");  //关闭窗体
		$('#mwin').css("display","none");
		queryFile();  //保存成功后,页面刷新
	}
	return;
	
}

/// 提交文档到服务器
function SaveModFileToServer(repID)
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
