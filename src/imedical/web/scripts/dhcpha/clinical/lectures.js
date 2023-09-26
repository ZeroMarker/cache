/// Creator: bianshuai
/// CreateDate: 2015-03-20
//  Descript: 文献阅读

var url="dhcpha.clinical.action.csp";
var ftpServerIp="ftp://192.192.10.119/ftpfile/文件目录/";
var userName = "HL";
var userPass = "HL20130909";

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
		title:'文献列表',
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

///上传
function UpLoad(ftpServerIp,userName,userPass,strPath)
{
	var str=FileManage.UpLoadFile(ftpServerIp,userName,userPass,strPath);
	return str;
}
///下载
function DownLoad(userName, userPass, ftpServerIp,strName)
{
	FileManage.SaveAsFile(userName,userPass,ftpServerIp,strName);
}
///重命名
function FileRename(sourcePath,userName,userPass,newName)
{
	return FileManage.fileRename(sourcePath,userName,userPass,newName);
}
///删除
function FileDelete(sourcePath,userName,userPass)
{
	return FileManage.fileDelete(sourcePath,userName,userPass);
}
function HasFile(sourcePath)
{
	return FileManage.HasFile(sourcePath);
}
function PDFConvertToSWF(exePath, sourcePath, targetPath)
{
	return FileManage.PDFConvertToSWF(exePath, sourcePath, targetPath);
}
function OfficeConvertToPDF(sourcePath, targetPath)
{
	return FileManage.OfficeConvertToPDF(sourcePath, targetPath);
}
function ServerFileUpload(sourcePath, targetPath)
{
	return FileManage.FileCopy(sourcePath, targetPath);
}
function HasFile(sourcePath)
{
	return FileManage.HasFile(sourcePath);
}
function HttpDownload(sourcePath,targetPath)
{
	FileManage.HttpDownload(sourcePath,targetPath);
}
function FileChange(strName)
{
	var result="";
	var regex = /[^\u4e00-\u9fa5\w]/g;
	/*
	if(strName.indexOf('.doc')==-1&&strName.indexOf('.docx')==-1&&strName.indexOf('.xls')==-1&&strName.indexOf('.xlsx')==-1&&strName.indexOf('.ppt')==-1&&strName.indexOf('.pptx')==-1&&strName.indexOf('.pdf')==-1)
	{
		alert('该格式的文件不支持预览，请下载！');	
		return false;
	}
	*/
	var fso = new ActiveXObject("Scripting.FileSystemObject");
  	var serverPath='http://192.192.10.123/trakcare/web/scripts/nurse/FlexPaper/docs/'+strName.split('.')[0].replace(regex,"")+'.swf';
	if(!IsExistsFile(serverPath))
	{
		alert(1)
		var temppath="c:/tempfile";
		if(!fso.FolderExists(temppath))
		{
			fso.CreateFolder(temppath);
		}
		alert(2)
		var filepath="ftp://HL:HL20130909@192.192.10.119/ftpfile/文件目录/"+strName;
		var pdfpath=temppath+'/'+strName.split('.')[0]+".pdf";
		alert(filepath)
		alert(pdfpath)
		var ret=OfficeConvertToPDF(filepath,pdfpath);
		alert(ret)
		if(ret){
			var exeServerPath="http://192.192.10.123/trakcare/web/DHCMG/FileManage/pdf2swf.exe"
			var exePath=temppath+'/pdf2swf.exe'
			HttpDownload(exeServerPath,exePath);
			if(fso.FileExists(exePath))
			{
				var tempswf=temppath+'/'+strName.split('.')[0].replace(regex,"")+".swf";
				var ret1=PDFConvertToSWF(exePath,pdfpath,tempswf);
				alert("ret1---"+ret1)
				if(ret1)
				{
					var ret2=ServerFileUpload(tempswf,serverPath);
					alert("ret2---"+ret2)
					if(ret2)
					{ 
						result=strName.split('.')[0].replace(regex,"")+".swf";
					}
					fso.DeleteFile(temppath+'/*.swf');
				}
				fso.DeleteFile(temppath+'/*.exe');
			}
			fso.DeleteFile(temppath+'/*.pdf'); 
		}
		fso.DeleteFolder(temppath);
	}
	else{
		result=strName.split('.')[0].replace(regex,"")+".swf";
	}
	if(result!="")
	{
		var swffile='docs/'+result;
		window.open("../scripts/nurse/FlexPaper/model.html?swffile="+swffile,'newwindow','height=600,width=800,top=20,left=300,toolbar=no,menubar=no,scrollbars=yes, resizable=no,location=no,status=no') 
		return true;
	}
	else{
		alert('该格式的文件不支持预览，请下载！');	
		return false;
	}
}
function IsExistsFile(filepath)
{
	var xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	xmlhttp.open("GET",filepath,false);
	xmlhttp.send();
	if(xmlhttp.readyState==4){   
  		if(xmlhttp.status==200){
	  		return true;
	  	} //url存在   
  		else if(xmlhttp.status==404){
	  		return false;
	  	} //url不存在   
  		else return false;//其他状态   
 	} 
}

function downLoad()
{
	var strName="这是作废文件.docx";
	DownLoad(userName,userPass,ftpServerIp,strName);
}

/*******************浏览**********************/
function view()
{
	var strName="这是作废文件.docx";
	var result=FileChange(strName);
	if(result==true){}
}

/*******************删除**********************/
function del()
{
	var strName="User.DHCStkLocGroup.xml";
	var sourcePath=ftpServerIp+strName;
	var result = FileDelete(sourcePath,userName,userPass);
	if(result==true){
		$.messager.alert("提示","删除成功!");
		return;	
	}else{
		$.messager.alert("提示","删除失败!");
		return;	
	}
}

/*******************修改**********************/
function mod()
{
	var newName="这是作废文件.docx";
	var strName="（傅昌芳）药学查房.docx";
	var sourcePath=ftpServerIp+strName;
	var result = FileRename(sourcePath,userName,userPass,newName);
	if(result==true){
		$.messager.alert("提示","修改成功!");
		return;	
	}else{
		$.messager.alert("提示","修改失败!");
		return;	
	}
}


/*******************新建窗体**********************/
function NewWin()
{
	$('#newwin').css("display","block");
	$('#newwin').dialog({
		title:"新建【文献阅读】",
		collapsible:false,
		border:false,
		closed:"true",
		width:800,
		height:420,
		buttons:[{
				text:'保存',
				iconCls:'icon-save',
				handler:function(){
					//closeNewWin(); ///关闭新建窗体
					///获取上传文件路径
					var filePath=$("input[name=filepath]").val();
					if(filePath==""){
						$.messager.alert("提示","请选择准备上传的文件,重试!");
						return;
					}
	
					var str=UpLoad(ftpServerIp,userName,userPass,filePath);
					if(str==true){
						$.messager.alert("提示","上传成功!");
						return;
					}
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