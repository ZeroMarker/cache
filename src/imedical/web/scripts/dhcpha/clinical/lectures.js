/// Creator: bianshuai
/// CreateDate: 2015-03-20
//  Descript: �����Ķ�

var url="dhcpha.clinical.action.csp";
var ftpServerIp="ftp://192.192.10.119/ftpfile/�ļ�Ŀ¼/";
var userName = "HL";
var userPass = "HL20130909";

$(function(){

	$("#stdate").datebox("setValue", formatDate(-2));  //Init��ʼ����
	$("#enddate").datebox("setValue", formatDate(0));  //Init��������
	
	$('a:contains("��ѯ")').bind("click",Query);   //��ѯ
	$('a:contains("�½�")').bind("click",NewWin);  //�½�
	$('a:contains("����")').bind("click",downLoad);  //����
	$('a:contains("���")').bind("click",view);  //���
	$('a:contains("�޸�")').bind("click",mod);  //�޸�
	$('a:contains("ɾ��")').bind("click",del);  //ɾ��
	
	InitPatList(); //��ʼ�������б�
})

//��ѯ
function Query()
{
	//1�����datagrid 
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
	//2����ѯ
	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var LocID=$('#dept').combobox('getValue');     //����ID
	var status=$('#status').combobox('getValue');  //״̬
	if (typeof LocID=="undefined"){LocID="";}
	var PatNo=$.trim($("#patno").val());
	var UserID=session['LOGON.USERID'];       //�û�
	var LocId=session['LOGON.CTLOCID'];       //����
	var GroupId=session['LOGON.GROUPID'];     //��ȫ��
	var params=StDate+"^"+EndDate+"^"+LocID+"^"+PatNo+"^"+GroupId+"^"+LocId+"^"+UserID+"^"+status;

	$('#maindg').datagrid({
		url:url+'?action=GetAdrReport',	
		queryParams:{
			params:params}
	});
}

//��ʼ�������б�
function InitPatList()
{
	//����columns
	var columns=[[
		{field:"documentID",title:'documentID',width:90},
		{field:'date',title:'����',width:100},
		{field:'title',title:'��Ŀ',width:160},
		{field:'user',title:'������',width:100},
		{field:'content',title:'��Ҫ����',width:260},
		{field:'liters',title:'�ο�����',width:320},
		{field:'partuser',title:'�μ���Ա',width:320},
		{field:'address',title:'�ص�',width:160}
	]];
	
	//����datagrid
	$('#maindg').datagrid({
		title:'�����б�',
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true
	});
	
	initScroll("#maindg");//��ʼ����ʾ���������
        $('#maindg').datagrid('loadData', {total:0,rows:[]});
}

/*******************����**********************/

///�ϴ�
function UpLoad(ftpServerIp,userName,userPass,strPath)
{
	var str=FileManage.UpLoadFile(ftpServerIp,userName,userPass,strPath);
	return str;
}
///����
function DownLoad(userName, userPass, ftpServerIp,strName)
{
	FileManage.SaveAsFile(userName,userPass,ftpServerIp,strName);
}
///������
function FileRename(sourcePath,userName,userPass,newName)
{
	return FileManage.fileRename(sourcePath,userName,userPass,newName);
}
///ɾ��
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
		alert('�ø�ʽ���ļ���֧��Ԥ���������أ�');	
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
		var filepath="ftp://HL:HL20130909@192.192.10.119/ftpfile/�ļ�Ŀ¼/"+strName;
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
		alert('�ø�ʽ���ļ���֧��Ԥ���������أ�');	
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
	  	} //url����   
  		else if(xmlhttp.status==404){
	  		return false;
	  	} //url������   
  		else return false;//����״̬   
 	} 
}

function downLoad()
{
	var strName="���������ļ�.docx";
	DownLoad(userName,userPass,ftpServerIp,strName);
}

/*******************���**********************/
function view()
{
	var strName="���������ļ�.docx";
	var result=FileChange(strName);
	if(result==true){}
}

/*******************ɾ��**********************/
function del()
{
	var strName="User.DHCStkLocGroup.xml";
	var sourcePath=ftpServerIp+strName;
	var result = FileDelete(sourcePath,userName,userPass);
	if(result==true){
		$.messager.alert("��ʾ","ɾ���ɹ�!");
		return;	
	}else{
		$.messager.alert("��ʾ","ɾ��ʧ��!");
		return;	
	}
}

/*******************�޸�**********************/
function mod()
{
	var newName="���������ļ�.docx";
	var strName="����������ҩѧ�鷿.docx";
	var sourcePath=ftpServerIp+strName;
	var result = FileRename(sourcePath,userName,userPass,newName);
	if(result==true){
		$.messager.alert("��ʾ","�޸ĳɹ�!");
		return;	
	}else{
		$.messager.alert("��ʾ","�޸�ʧ��!");
		return;	
	}
}


/*******************�½�����**********************/
function NewWin()
{
	$('#newwin').css("display","block");
	$('#newwin').dialog({
		title:"�½��������Ķ���",
		collapsible:false,
		border:false,
		closed:"true",
		width:800,
		height:420,
		buttons:[{
				text:'����',
				iconCls:'icon-save',
				handler:function(){
					//closeNewWin(); ///�ر��½�����
					///��ȡ�ϴ��ļ�·��
					var filePath=$("input[name=filepath]").val();
					if(filePath==""){
						$.messager.alert("��ʾ","��ѡ��׼���ϴ����ļ�,����!");
						return;
					}
	
					var str=UpLoad(ftpServerIp,userName,userPass,filePath);
					if(str==true){
						$.messager.alert("��ʾ","�ϴ��ɹ�!");
						return;
					}
					}
			},{
				text:'�˳�',
				iconCls:'icon-cancel',
				handler:function(){
					closeNewWin();  ///�ر��½�����
					}
			}]
	});
	///��ʾ�Ի���	
	$('#newwin').dialog('open');
}

/*******************�ر��½�����**********************/
function closeNewWin()
{
	$('#newwin').dialog('close');
	$("#newwin").css("display","none");
}