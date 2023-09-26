
/// Creator: bianshuai
/// CreateDate: 2014-06-22
//  Descript: �������

//����Url
var url="dhcpha.clinical.action.csp";
var winScrHeight=window.screen.height;        //��Ļ�ֱ��ʵĸ�
var winScrWidth=window.screen.width;          //��Ļ�ֱ��ʵĿ�

$(function(){
	
	//����columns
	var columns=[[
	    {field:'docID',title:'docID',width:100},
	    {field:'creDate',title:'����',width:100},
		{field:'creTime',title:'ʱ��',width:100},
		{field:'title',title:'�ĵ���',width:300},
		{field:'author',title:'����',width:120}
	]];
	
	//����datagrid
	$('#dg').datagrid({
		title:'�ĵ����',    
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:30,  // ÿҳ��ʾ�ļ�¼����
		pageList:[30,45],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true
	});
	
	initScroll('#dg');//��ʼ����ʾ���������
	
	$("#StartDate").datebox("setValue", formatDate(-1));  //Init��ʼ����
	$("#EndDate").datebox("setValue", formatDate(0));  //Init��������
	
	//��ѯ��ť���¼�
	$('#btnQuery').bind('click',function(){
		Query();  //��ѯ
	})
	
	//Ԥ����ť���¼�
	$('#btnView').bind('click',function(){
		view();  //Ԥ��
	})
	
	//�޶���ť���¼�
	$('#btnMod').bind('click',function(){
		Mod();  //�޶�
	})
	
	//ɾ����ť���¼�
	$('#btnDel').bind('click',function(){
		Del();  //ɾ��
	})
})

/// �ύ�ĵ���������
function SaveFileToServer(repID)
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

/// �ļ��������
function OpenFileOnline(RepID,editflag)
{
	CloseWord();  //�ȹرյ�ǰWord,�ٽ��д�
	$.post(url+'?action=OpenFile',{"RepID":RepID},function(data){
		if(data.replace(/(^\s*)|(\s*$)/g, "").length!=""){
			var tempPath=document.all.WebOffice1.GetTempFilePath();//��ȡ��ʱ�ļ�·��
			//alert("�ĵ��浽������ʱ·����"+tempPath);
			document.all.WebOffice1.SaveBinaryFileFromBase64(tempPath,data.replace(/(^\s*)|(\s*$)/g, ""));
			document.all.WebOffice1.LoadOriginalFile(tempPath,"doc");
			if(editflag==1){
				showWebofficeToolBar();
			}else{
				hideAll('','','','');   ///2003�����ز˵�
				hideWebofficeToolBar();
			}
		}
	});
}

/// �ر�Word
function CloseWord(){

  document.all.WebOffice1.CloseDoc(0); 
}

/// ��ѯ
function Query()
{
	var StDate=$('#StartDate').datebox('getValue'); //��ʼ����
	var EndDate=$('#EndDate').datebox('getValue');  //��ֹ����
	var params=StDate+"^"+EndDate;
	$('#dg').datagrid({
		url:url+'?action=QueryDocMan',	
		queryParams:{
			params:params}
	});
}

///�����������
function createMedViewWin(RepID)
{
   	$('#mwin').css("display","block");
	$('#mwin').dialog({
		title:'���',
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

///�����༭����
function showEditWin(RepID)
{
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
				save(RepID);
				$('#mwin').dialog("close");
				$('#mwin').css("display","none");
				CloseWord();
				}
		},{
			text:'�ر�',
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

/// ɾ���ĵ�
function Del()
{
	var RepID="";
	var row=$('#dg').datagrid('getSelected');
	if (row){
		RepID=row.docID;
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
		Query();  //ɾ���ɹ�֮��,����ˢ��
	});	
}

///��ʾ�༭����
function Mod()
{
	var RepID="";
	var row=$('#dg').datagrid('getSelected');
	if (row){
		RepID=row.docID;
	}else{
		$.messager.alert('������ʾ','����ѡ��һ�м�¼!',"error");
		return;
	}
	showEditWin(RepID);
}

///��ʾԤ������
function view()
{
	var RepID="";
	var row=$('#dg').datagrid('getSelected');
	if (row){
		RepID=row.docID;
	}else{
		$.messager.alert('������ʾ','����ѡ��һ�м�¼!',"error");
		return;
	}
	createMedViewWin(RepID);
}

///����
function save(RepID)
{
	SaveFileToServer(RepID);
}

/// �ر�Word
function CloseWord(){

  document.all.WebOffice1.CloseDoc(0); 
}