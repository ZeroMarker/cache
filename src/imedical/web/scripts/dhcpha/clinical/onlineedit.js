 
/// Creator: bianshuai
/// CreateDate: 2014-06-22
//  Descript: �������

//����Url
var url="dhcpha.clinical.action.csp";
var winScrHeight=window.screen.height;        //��Ļ�ֱ��ʵĸ�
var winScrWidth=window.screen.width;          //��Ļ�ֱ��ʵĿ�

$(function(){
	//�½�[�հ��ĵ�]��ť���¼�
	$('#bnew').bind('click',function(){
		newFile();
	})

	//�½�[����ģ��]��ť���¼�
	$('#bnewtemp').bind('click',function(){
		newFileByTemp();
	})
	
	//�ϴ���ť���¼�
	$('#bupload').bind('click',function(){
		upLoadFile();
	})
	
	//�޸İ�ť���¼�
	$('#bmod').bind('click',function(){
		modFile();
	})
	
	//ɾ����ť���¼�
	$('#bdel').bind('click',function(){
		delFile();
	})
	
	$("#StartDate").datebox("setValue", formatDate(-1));  //Init��ʼ����
	$("#EndDate").datebox("setValue", formatDate(0));  //Init��������
	
	//��ѯ��ť���¼�
	$('#btnQuery').bind('click',function(){
		queryFile();  //��ѯ
	})
	
	//����columns
	var columns=[[
	    {field:'RowID',title:'RowID',width:100},
		{field:'Title',title:'ģ������',width:300},
		{field:'UpUser',title:'�ϴ���',width:120},
		{field:'UpDate',title:'�ϴ�����',width:120},
		{field:'UpTime',title:'�ϴ�ʱ��',width:120}
	]];
	
	//����datagrid
	$('#dg').datagrid({
		//title:'',    
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...'
	});
	
	initScroll('#dg');   //��ʼ����ʾ���������
	
	$('#dg').datagrid({
		url:url+'?action=LoadTempInfo'
	});
	
	//����columns
	var columns=[[
	    {field:'RowID',title:'RowID',width:100},
		{field:'title',title:'����',width:300},
		{field:'upuser',title:'�ϴ���',width:120},
		{field:'update',title:'�ϴ�����',width:120},
		{field:'uptime',title:'�ϴ�ʱ��',width:120},
		{field:'moduser',title:'�޸���',width:120},
		{field:'moddate',title:'�޸�����',width:120},
		{field:'modtime',title:'�޸�ʱ��',width:120}
	]];
	
	//����datagrid
	$('#dgperdetail').datagrid({
		//title:'',    
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:30,  		// ÿҳ��ʾ�ļ�¼����
		pageList:[30,45],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true
	});
	
	initScroll('#dgperdetail');//��ʼ����ʾ���������
	queryFile();
})

/// �ύ�ĵ���������
function SaveFileToServer()
{
	///��ȡ�ϴ��ļ�����
	var fileName=$("input[name=fileName]").val();
	if(fileName==""){
		alert("����д�ļ�����,����!");
		return;
	}
	
	var mainstr=session['LOGON.USERID']+"^"+fileName;

	///������
	var pid=tkMakeServerCall("web.DHCSTPHCMLECTURES","NewPid");

	///׼������
	var FileBase64Str=document.all.WebOffice1.GetFileBase64("",0);
	if(FileBase64Str.length==0){
		alert("�ļ���������ת��ʧ��!");
		return;
	}

	var Len=Math.ceil(FileBase64Str.length/20000);
	var TmpBaseStr="",mytrn="";
	for(var i=0;i<Len;i++){
		TmpBaseStr=FileBase64Str.substring(i*20000,20000*(i+1));
		mytrn=tkMakeServerCall("web.DHCSTPHCMLECTURES","saveFileBase64",pid,TmpBaseStr);      ///ѭ����ȡ�ַ����������ݿ�
		if(mytrn!=0){
			break;	
		}
	}
			
	///׼��������ɺ�,���ú�̨�������ɶ�Ӧ��������,�����ṹ
	if(mytrn==0){
		mytrn=tkMakeServerCall("web.DHCSTPHCMLECTURES","saveRep",pid,Len,mainstr);
		if(mytrn!=0){
			alert("����ʧ��,����ԭ��:"+mytrn);
			return;
		}
		alert("����ɹ�!");
		$('#UpLoadWin').dialog("close");  //�رմ���
		$('#UpLoadWin').css("display","none");
		queryFile();  //����ɹ���,ҳ��ˢ��
	}
	return;
}

/// �ļ��������
function newDocByTemp(RepID)
{
	document.all.WebOffice1.CloseDoc(0);   //�ȹرյ�ǰWord,�ٽ��д�
	$.post(url+'?action=OpenTempFile',{"RepID":RepID},function(data){
		if(data.replace(/(^\s*)|(\s*$)/g, "").length!=""){
			var tempPath=document.all.WebOffice1.GetTempFilePath();//��ȡ��ʱ�ļ�·��
			//alert("�ĵ��浽������ʱ·����"+tempPath);
			document.all.WebOffice1.SaveBinaryFileFromBase64(tempPath,data.replace(/(^\s*)|(\s*$)/g, ""));
			document.all.WebOffice1.LoadOriginalFile(tempPath,"doc");
		}
	});
}

/// �򿪴���
function windowOpen()
{
	window.open ('','editwindow','height=100,width=400,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no');
}

/// �½�[�հ��ĵ�]
function newFile()
{
	showEditWin("0");
}

/// �½�[����ģ��]
function newFileByTemp()
{
	showEditWin("1");
}

/// �ϴ�
function upLoadFile()
{
	showUpLoadWin();  //�����ϴ�����
}

/// �޸�
function modFile()
{
	showEditWin("2");
}

///�����༭����
function showEditWin(setflag)
{
	var RepID="";
    if(setflag=="0"){
		hideWebofficeToolBar(); //���ع�����
		newDoc();  //�½�
	}else if(setflag=="1"){
		var RepID="";
		var row=$('#dg').datagrid('getSelected');
		if (row){
			RepID=row.RowID;
		}else{
			alert('����ѡ��һ�м�¼!');
			return;
		}
		if(RepID==""){
			alert("��ѡ���¼,����!");
			return;
		}
		newDocByTemp(RepID);  //����ģ���½�
	}else if(setflag=="2"){
		var RepID="";
		var row=$('#dgperdetail').datagrid('getSelected');
		if (row){
			RepID=row.RowID;
		}else{
			alert('����ѡ��һ�м�¼!');
			return;
		}
		if(RepID==""){
			alert("��ѡ���¼,����!");
			return;
		}
		openDocToEdit(RepID); //���߽��б༭
	}
	
   	$('#mwin').css("display","block");
	$('#mwin').dialog({
		title:'�޶�',
		width:winScrWidth-300, //1000,
		height:winScrHeight-200, //750,
		border:true,
		closed:"true",
		collapsible:true,
		onClose:function(){
			//$('#mwin').remove();  //���ڹر�ʱ�Ƴ�win��DIV��ǩ
		},
	    modal: true,
		buttons:[{
			text:'����',
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
			text:'�ر�',
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

/// ���߽��б༭
function openDocToEdit(RepID)
{
	document.all.WebOffice1.CloseDoc(0);   //�ȹرյ�ǰWord,�ٽ��д�
	$.post(url+'?action=OpenFile',{"RepID":RepID},function(data){
		if(data.replace(/(^\s*)|(\s*$)/g, "").length!=""){
			var tempPath=document.all.WebOffice1.GetTempFilePath();//��ȡ��ʱ�ļ�·��
			//alert("�ĵ��浽������ʱ·����"+tempPath);
			document.all.WebOffice1.SaveBinaryFileFromBase64(tempPath,data.replace(/(^\s*)|(\s*$)/g, ""));
			document.all.WebOffice1.LoadOriginalFile(tempPath,"doc");
		}
	});
}

/// ��ѯ
function queryFile()
{
	var StDate=$('#StartDate').datebox('getValue'); //��ʼ����
	var EndDate=$('#EndDate').datebox('getValue');  //��ֹ����
	var params=StDate+"^"+EndDate;
	$('#dgperdetail').datagrid({
		url:url+'?action=QueryDocByLogUser',	
		queryParams:{
			params:params}
	});
}

/// ɾ���ĵ�
function delFile()
{
	$.messager.confirm("��ʾ:","��ȷ��Ҫɾ����ǰѡ�м�¼��",function(r){
		if(r){
			var RepID="";
			var row=$('#dgperdetail').datagrid('getSelected');
			if (row){
				RepID=row.RowID;
			}else{
				$.messager.alert('������ʾ','����ѡ��һ�м�¼!',"error");
				return;
			}
			if(RepID==""){
				$.messager.alert("��ʾ","��ѡ���¼,����!");
				return;
			}

			$.post(url+"?action=delFile",{params:RepID},function(content){
				if(content.replace(/(^\s*)|(\s*$)/g, "")!=0){
					$.messager.alert("��ʾ","ɾ��ʧ��!");
					return;
				}
				$.messager.alert("��ʾ","ɾ���ɹ�!");
				queryFile();  //ɾ���ɹ�֮��,����ˢ��
			});
		}
	});
}

///�����ϴ�����
function showUpLoadWin()
{
	$('#UpLoadWin').css("display","block");
	$('#UpLoadWin').dialog({
		title:'�ϴ�',
		width:450,
		height:230,
		closed: false,    
	    cache: false,
	    modal: true,
		buttons:[{
			text:'�ύ',
			iconCls:'icon-save',
			handler:function(){
				SaveFileToServer();  //�ύ����
			}
		},{
			text:'�ر�',
			iconCls:'icon-cancel',
			handler:function(){
				$('#UpLoadWin').dialog("close");
				$('#UpLoadWin').css("display","none");
		}
		}] 
	});
	     
	$('#UpLoadWin').dialog('open');
}

/// �ύ�ĵ���������
function SaveNewFileToServer()
{
	var fileName=prompt("�����뼴��������ĵ�����","");
	/*
	///��ȡ�ϴ��ļ�����
	var fileName=$("input[name=fileName]").val();
	if(fileName==""){
		alert("����д�ļ�����,����!");
		return;
	}
	*/
	var mainstr=session['LOGON.USERID']+"^"+fileName;

	///������
	var pid=tkMakeServerCall("web.DHCSTPHCMLECTURES","NewPid");

	///׼������
	var FileBase64Str=document.all.WebOffice1.GetFileBase64("",0);
	if(FileBase64Str.length==0){
		alert("�ļ���������ת��ʧ��!");
		return;
	}

	var Len=Math.ceil(FileBase64Str.length/20000);
	var TmpBaseStr="",mytrn="";
	for(var i=0;i<Len;i++){
		TmpBaseStr=FileBase64Str.substring(i*20000,20000*(i+1));
		mytrn=tkMakeServerCall("web.DHCSTPHCMLECTURES","saveFileBase64",pid,TmpBaseStr);      ///ѭ����ȡ�ַ����������ݿ�
		if(mytrn!=0){
			break;	
		}
	}
			
	///׼��������ɺ�,���ú�̨�������ɶ�Ӧ��������,�����ṹ
	if(mytrn==0){
		mytrn=tkMakeServerCall("web.DHCSTPHCMLECTURES","saveRep",pid,Len,mainstr);
		if(mytrn!=0){
			alert("����ʧ��,����ԭ��:"+mytrn);
			return;
		}
		alert("����ɹ�!");
		$('#mwin').dialog("close");  //�رմ���
		$('#mwin').css("display","none");
		queryFile();  //����ɹ���,ҳ��ˢ��
	}
	return;
	
}

/// �ύ�ĵ���������
function SaveModFileToServer(repID)
{
	///������
	var pid=tkMakeServerCall("web.DHCSTPHCMLECTURES","NewPid");

	///׼������
	var FileBase64Str=document.all.WebOffice1.GetFileBase64("",0);
	if(FileBase64Str.length==0){
		$.messager.alert("��ʾ","�ļ���������ת��ʧ��!");
		return;
	}

	var Len=Math.ceil(FileBase64Str.length/20000);
	var TmpBaseStr="",mytrn="";
	for(var i=0;i<Len;i++){
		TmpBaseStr=FileBase64Str.substring(i*20000,20000*(i+1));
		mytrn=tkMakeServerCall("web.DHCSTPHCMLECTURES","saveFileBase64",pid,TmpBaseStr);      ///ѭ����ȡ�ַ����������ݿ�
		if(mytrn!=0){
			break;	
		}
	}

	///׼��������ɺ�,���ú�̨�������ɶ�Ӧ��������,�����ṹ
	if(mytrn==0){
		mytrn=tkMakeServerCall("web.DHCSTPHCMLECTURES","modFile",pid,Len,repID);
		if(mytrn!=0){
			alert("����ʧ��,����ԭ��:"+mytrn);
			return;
		}
		alert("����ɹ�!");
	}
	return;
}
