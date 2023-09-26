
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
	    {field:'creDate',title:'�ϴ�����',width:100},
		{field:'creTime',title:'�ϴ�ʱ��',width:100},
		{field:'title',title:'�ļ���',width:300},
		{field:'author',title:'����',width:120},
		{field:'view',title:'Ԥ��',width:100,align:'center',
			formatter:function(value, rowData, rowIndex){
				return setCellHerfView(rowData,"pencil");
			}},
		{field:'del',title:'ɾ��',width:100,align:'center',
			formatter:function(value, rowData, rowIndex){
				return setCellHerfDel(rowData,"pencil");
			}}
	]];
	
	//����datagrid
	$('#dg').datagrid({
		title:'ģ���ϴ�',    
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
	
	//��ѯ��ť���¼�
	$('#btnUpLoad').bind('click',function(){
		showUpLoadWin();  //�ϴ�
	})
	
})

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
		}
		}] 
	});
	     
	$('#UpLoadWin').dialog('open');
}

/// �ύ�ĵ���������
function SaveFileToServer()
{
	///��ȡ�ϴ��ļ�����
	var fileName=$("input[name=fileName]").val();
	if(fileName==""){
		$.messager.alert("��ʾ","����д�ļ�����,����!");
		return;
	}
	
	var mainstr=session['LOGON.USERID']+"^"+fileName;
	
	///��ȡ�ϴ��ļ�·��
	var filePath=$("input[name=DocID]").val();
	if(filePath==""){
		$.messager.alert("��ʾ","��ѡ��׼���ϴ����ļ�,����!");
		return;
	}

	///������
	var pid=tkMakeServerCall("web.DHCSTPHCMLECTURES","NewPid");

	///׼������
	var FileBase64Str=document.all.WebOffice1.GetFileBase64(filePath,0);
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
		mytrn=tkMakeServerCall("web.DHCSTPHCMLECTURES","saveRepTemp",pid,Len,mainstr);
		if(mytrn!=0){
			$.messager.alert("��ʾ","�ϴ�ʧ��,����ԭ��:"+mytrn);
			return;
		}
		$.messager.alert("��ʾ","�ϴ��ɹ�!");
		$('#UpLoadWin').dialog('close');
		$('#UpLoadWin').css("display","none");
		$("input[name=fileName]").val("");
		$("input[name=DocID]").val("");
	}
	return;
}

/// �ļ��������
function OpenFileOnline(RepID)
{
	CloseWord();  //�ȹرյ�ǰWord,�ٽ��д�
	$.post(url+'?action=OpenTempFile',{"RepID":RepID},function(data){
		if(data.replace(/(^\s*)|(\s*$)/g, "").length!=""){
			var tempPath=document.all.WebOffice1.GetTempFilePath();//��ȡ��ʱ�ļ�·��
			//alert("�ĵ��浽������ʱ·����"+tempPath);
			document.all.WebOffice1.SaveBinaryFileFromBase64(tempPath,data.replace(/(^\s*)|(\s*$)/g, ""));
			document.all.WebOffice1.LoadOriginalFile(tempPath,"doc");
			hideAll('','','','');   ///2003�����ز˵�
			hideWebofficeToolBar();
			ProtectFull();
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
		url:url+'?action=QueryDocMangement',	
		queryParams:{
			params:params}
	});
}

///==============================================================

/// ����
function setCellHerfView(rowData,index){
	return "<a href='#' onclick='showWin("+rowData.docID+")'><img src='../scripts/dhcpha/jQuery/themes/icons/"+index+".png' border=0/></a>";
}

/// ����
function setCellHerfEdit(rowData,index){
	return "<a href='#' onclick='showEditWin("+rowData.docID+")'><img src='../scripts/dhcpha/jQuery/themes/icons/"+index+".png' border=0/></a>";
}

/// ����
function setCellHerfDel(rowData,index){
	return "<a href='#' onclick='del("+rowData.docID+")'><img src='../scripts/dhcpha/jQuery/themes/icons/"+index+".png' border=0/></a>";
}

//��������ɫ  formatter="SetCellColor"
function SetCellColor(value, rowData, rowIndex)
{
	return '<span style="font-weight:bold;color:red;font-size:12pt;font-family:���Ŀ���;">'+value+'</span>';
}

//��������ɫ  formatter="SetCellColor"
function SetCellFont(value, rowData, rowIndex)
{
	return '<span style="font-weight:bold;font-size:12pt;font-family:���Ŀ���;">'+value+'</span>';
}


///����
function showWin(RepID)
{
	createMedViewWin(RepID); //���ô��� createMedViewWin
}

///�����������
function createMedViewWin(RepID)
{
   	$('#mwin').css("display","block");
	$('#mwin').dialog({
		title:'���',
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

///�����༭����
function showEditWin(RepID)
{
   	$('#mwin').css("display","block");
	$('#mwin').dialog({
		title:'�༭',
		width:winScrWidth-500, //1000,
		height:winScrHeight-200, //750,
		border:true,
		closed:"true",
		collapsible:true,
	    modal: true ,
		buttons:[{
			text:'����',
			iconCls:'icon-save',
			handler:function(){
				$('#mwin').dialog("close");
				}
		},{
			text:'�ر�',
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

/// ɾ����¼
function del(RepID)
{
	$.messager.confirm("ȷ�϶Ի���","ȷ��Ҫִ��ɾ��������",function(val){
		if(val){
			if(RepID==""){
				$.messager.alert("��ʾ","��ѡ���¼,����!");
				return;
			}
			$.post(url+"?action=delTempFile",{params:RepID},function(content){
				if(content.replace(/(^\s*)|(\s*$)/g, "")!=0){
					$.messager.alert("��ʾ","ɾ��ʧ��!");
					return;
				}
				$.messager.alert("��ʾ","ɾ���ɹ�!");
				Query();  //ɾ���ɹ�֮��,����ˢ��
			});
		}
	})
}
