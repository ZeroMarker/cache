
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
	    {field:'creDate',title:'上传日期',width:100},
		{field:'creTime',title:'上传时间',width:100},
		{field:'title',title:'文件名',width:300},
		{field:'author',title:'作者',width:120},
		{field:'view',title:'预览',width:100,align:'center',
			formatter:function(value, rowData, rowIndex){
				return setCellHerfView(rowData,"pencil");
			}},
		{field:'del',title:'删除',width:100,align:'center',
			formatter:function(value, rowData, rowIndex){
				return setCellHerfDel(rowData,"pencil");
			}}
	]];
	
	//定义datagrid
	$('#dg').datagrid({
		title:'模板上传',    
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
	
	//查询按钮绑定事件
	$('#btnUpLoad').bind('click',function(){
		showUpLoadWin();  //上传
	})
	
})

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
		}
		}] 
	});
	     
	$('#UpLoadWin').dialog('open');
}

/// 提交文档到服务器
function SaveFileToServer()
{
	///获取上传文件名称
	var fileName=$("input[name=fileName]").val();
	if(fileName==""){
		$.messager.alert("提示","请填写文件名称,重试!");
		return;
	}
	
	var mainstr=session['LOGON.USERID']+"^"+fileName;
	
	///获取上传文件路径
	var filePath=$("input[name=DocID]").val();
	if(filePath==""){
		$.messager.alert("提示","请选择准备上传的文件,重试!");
		return;
	}

	///计数器
	var pid=tkMakeServerCall("web.DHCSTPHCMLECTURES","NewPid");

	///准备数据
	var FileBase64Str=document.all.WebOffice1.GetFileBase64(filePath,0);
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
		mytrn=tkMakeServerCall("web.DHCSTPHCMLECTURES","saveRepTemp",pid,Len,mainstr);
		if(mytrn!=0){
			$.messager.alert("提示","上传失败,错误原因:"+mytrn);
			return;
		}
		$.messager.alert("提示","上传成功!");
		$('#UpLoadWin').dialog('close');
		$('#UpLoadWin').css("display","none");
		$("input[name=fileName]").val("");
		$("input[name=DocID]").val("");
	}
	return;
}

/// 文件在线浏览
function OpenFileOnline(RepID)
{
	CloseWord();  //先关闭当前Word,再进行打开
	$.post(url+'?action=OpenTempFile',{"RepID":RepID},function(data){
		if(data.replace(/(^\s*)|(\s*$)/g, "").length!=""){
			var tempPath=document.all.WebOffice1.GetTempFilePath();//获取临时文件路径
			//alert("文档存到本地临时路径："+tempPath);
			document.all.WebOffice1.SaveBinaryFileFromBase64(tempPath,data.replace(/(^\s*)|(\s*$)/g, ""));
			document.all.WebOffice1.LoadOriginalFile(tempPath,"doc");
			hideAll('','','','');   ///2003版隐藏菜单
			hideWebofficeToolBar();
			ProtectFull();
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
		url:url+'?action=QueryDocMangement',	
		queryParams:{
			params:params}
	});
}

///==============================================================

/// 链接
function setCellHerfView(rowData,index){
	return "<a href='#' onclick='showWin("+rowData.docID+")'><img src='../scripts/dhcpha/jQuery/themes/icons/"+index+".png' border=0/></a>";
}

/// 链接
function setCellHerfEdit(rowData,index){
	return "<a href='#' onclick='showEditWin("+rowData.docID+")'><img src='../scripts/dhcpha/jQuery/themes/icons/"+index+".png' border=0/></a>";
}

/// 链接
function setCellHerfDel(rowData,index){
	return "<a href='#' onclick='del("+rowData.docID+")'><img src='../scripts/dhcpha/jQuery/themes/icons/"+index+".png' border=0/></a>";
}

//设置列颜色  formatter="SetCellColor"
function SetCellColor(value, rowData, rowIndex)
{
	return '<span style="font-weight:bold;color:red;font-size:12pt;font-family:华文楷体;">'+value+'</span>';
}

//设置列颜色  formatter="SetCellColor"
function SetCellFont(value, rowData, rowIndex)
{
	return '<span style="font-weight:bold;font-size:12pt;font-family:华文楷体;">'+value+'</span>';
}


///窗口
function showWin(RepID)
{
	createMedViewWin(RepID); //调用窗体 createMedViewWin
}

///创建浏览窗体
function createMedViewWin(RepID)
{
   	$('#mwin').css("display","block");
	$('#mwin').dialog({
		title:'浏览',
		width:winScrWidth-500, //1000,
		height:winScrHeight-200, //750,
		border:true,
		closed:"true",
		collapsible:true,
	    modal: true
	});
	
    $('#mwin').dialog('open');
    OpenFileOnline(RepID);
}

///创建编辑窗体
function showEditWin(RepID)
{
   	$('#mwin').css("display","block");
	$('#mwin').dialog({
		title:'编辑',
		width:winScrWidth-500, //1000,
		height:winScrHeight-200, //750,
		border:true,
		closed:"true",
		collapsible:true,
	    modal: true ,
		buttons:[{
			text:'保存',
			iconCls:'icon-save',
			handler:function(){
				$('#mwin').dialog("close");
				}
		},{
			text:'关闭',
			iconCls:'icon-cancel',
			handler:function(){
				$('#mwin').dialog("close");
				$('#mwin').css("display","none");
				}
		}]
	});
	
    $('#mwin').dialog('open');
    OpenFileOnline(RepID);
}

/// 删除记录
function del(RepID)
{
	$.messager.confirm("确认对话框","确定要执行删除操作？",function(val){
		if(val){
			if(RepID==""){
				$.messager.alert("提示","请选择记录,重试!");
				return;
			}
			$.post(url+"?action=delTempFile",{params:RepID},function(content){
				if(content.replace(/(^\s*)|(\s*$)/g, "")!=0){
					$.messager.alert("提示","删除失败!");
					return;
				}
				$.messager.alert("提示","删除成功!");
				Query();  //删除成功之后,重新刷新
			});
		}
	})
}
