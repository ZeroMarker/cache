/// Creator: bianshuai
/// CreateDate: 2014-10-29
//  Descript: ҩƷ�����¼��ϱ�

var HospID = session['LOGON.HOSPID'];
var url="dhcpha.clinical.action.csp";
var statArray = [{ "val": "Y", "text": "�ύ" }, { "val": "N", "text": "δ�ύ" }];
$(function(){

	$("#stdate").datebox("setValue", formatDate(-2));  //Init��ʼ����
	$("#enddate").datebox("setValue", formatDate(0));  //Init��������
	
	//����
	$('#dept').combobox({
		mode:'remote',
		onShowPanel:function(){ //qunianpeng 2017/8/14 ֧��ƴ����ͺ���
			//$('#dept').combobox('reload',url+'?action=SelAllLoc&HospID='+HospID)
			$('#dept').combobox('reload',url+'?action=GetAllLocNewVersion&hospId='+HospID+'  ')
		}
	}); 

	//����
	$('#ward').combobox({
		mode:'remote',
		onShowPanel:function(){ //qunianpeng 2017/8/14 ֧��ƴ����ͺ���
			//$('#ward').combobox('reload',url+'?action=SelAllLoc')
			$('#ward').combobox('reload',url+'?action=GetAllWardNewVersion')

		}
	});
	
	//״̬
	$('#status').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		data:statArray 
	});
	$('#status').combobox('setValue',"N"); //����comboboxĬ��ֵ
	
	$('#Find').bind("click",Query); //�����ѯ
	$("a:contains('���')").bind("click",repview); //����鿴
	$('a:contains("����")').bind("click",Export);  //����
	
	InitPatList(); //�����б�
        Query();
	
	//�ǼǺŻس��¼�
	$('#patno').bind('keypress',function(event){
	 if(event.keyCode == "13"){
		 var patno=$.trim($("#patno").val());
		 if (patno!=""){
			GetWholePatID(patno);
			Query();
		 }	
	 }
	});
})

//��ѯ
function Query()
{
	//1�����datagrid 
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
	//2����ѯ
	var StDate=$('#stdate').datebox('getValue'); //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var LocID=$('#dept').combobox('getValue'); //����ID
	if (LocID== undefined){LocID="";}
	var PatNo=$.trim($("#patno").val());
	var curStatus=$('#status').combobox('getValue'); //״̬  liyarong 2016-09-26
	var params=StDate+"^"+EndDate+"^"+LocID+"^"+PatNo+"^"+curStatus;
	$('#maindg').datagrid({
		url:url+'?action=GetDQEvtReport',	
		queryParams:{
			params:params}
	});
}

//��ʼ�������б�
function InitPatList()
{
	//����columns
	var columns=[[
		{field:"ck",checkbox:true,width:20},
		{field:"dgERepID",title:'dgERepID',width:90,hidden:true},
		{field:'dgERepCode',title:'����',width:180},
		{field:'dgEPatNo',title:'�ǼǺ�',width:120},
		{field:'dgEPatName',title:'����',width:120},
		{field:'dgERepStatus',title:'��ǰ״̬',width:120},
		{field:'dgERepLoc',title:'�������',width:260},
		{field:'dgEReporter',title:'������',width:120},
		{field:'dgERepDate',title:'��������',width:120}
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
}

/// �������
function repview()
{
	var dgERepID="";
	var rowList=$('#maindg').datagrid('getSelections');
 	if (rowList!=""){
		if(rowList.length>1){
			$.messager.alert('������ʾ','һ��ֻ�����һ�����棬�빴ѡ��Ҫ�鿴�ļ�¼!',"error");
			return;
			}
		var row=$('#maindg').datagrid('getSelected');
		dgERepID=row.dgERepID;
		dgERepStatus=row.dgERepStatus;  //liyarong 2016-09-26
	}else{
		$.messager.alert('������ʾ','����ѡ��һ�м�¼!',"error");
		return;
	}
	showEditWin(dgERepID,dgERepStatus); 
}


//�༭����
function showEditWin(dgERepID,dgERepStatus)
{	
	if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="win"></div>');
	$('#win').window({
		title:'����༭',
		collapsible:true,
		border:false,
		closed:"true",
		width:1250,
		height:600
	});

		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.drugqualityevtreport.csp?dqEvtRepID='+dgERepID+'&curstatus='+dgERepStatus+'&editFlag='+0+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
}


///��0���˵ǼǺ�
function GetWholePatID(RegNo)
{    
	if (RegNo=="") {
		return RegNo;
	}
	var patLen = tkMakeServerCall("web.DHCSTCNTSCOMMON","GetPatRegNoLen");
	var plen=RegNo.length;
	if (plen>patLen){
		$.messager.alert('������ʾ',"�ǼǺ��������");
		return;
	}
	for (i=1;i<=patLen-plen;i++){
		RegNo="0"+RegNo;  
	}
	$("#patno").val(RegNo);
}

// ����Excel
function Export()
{
	var selItemList = $('#maindg').datagrid('getSelections');    //wangxuejian 2016-09-14
	if (selItemList==""){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert("��ʾ:","��ѡ��·����,���ԣ�");
		return;
	}
/*
	$.each(selItems, function(index, item){
		var dgERepID=selItems.dgERepID;         //����ID
		ExportExcel(dgERepID,filePath);
	})
*/
   var selItems= $('#maindg').datagrid('getChecked');
	$.each(selItems, function(index, item){
		var dgERepID=item.dgERepID;         //����ID
		ExportExcel(dgERepID,filePath);
	})
	$.messager.alert("��ʾ:","������ɣ�����Ŀ¼Ϊ:��"+filePath+"��");
}
function ExportExcel(dgERepID,filePath)
{
	if(dgERepID==""){
		$.messager.alert("��ʾ:","����IDΪ�գ�");
		return;
	}
	var retval=tkMakeServerCall("web.DHCSTPHCMDRGQEVTREPORT","getDQEvtRepExportInfo",dgERepID);
	if(retval==""){
		$.messager.alert("��ʾ:","ȡ���ݴ���");
		return;
	}
	var retvalArr=retval.split("&&");
	//1����ȡXLS��ӡ·��
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCST_PHCM_DrgQuaRep.xls";
	//var Template = "C:\\DHCST_PHCM_DrgQuaRep.xls";
	
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;
	
	objSheet.Cells(2,2).value=retvalArr[2]; //�������/����
	objSheet.Cells(2,7).value=retvalArr[3]; //����ʱ��
	objSheet.Cells(2,11).value=retvalArr[35]; //����
	
	objSheet.Cells(3,2).value=retvalArr[6]; //��������
	objSheet.Cells(3,4).value=retvalArr[9]; //��������
	objSheet.Cells(3,7).value=retvalArr[8]; //����
	objSheet.Cells(3,9).value=retvalArr[7]; //�Ա�
	objSheet.Cells(3,12).value=retvalArr[10]; //סԺ��/��������
	
	objSheet.Cells(4,2).value=retvalArr[12];  //�������
	objSheet.Cells(4,8).value=retvalArr[13];  //�¼�����ʱ��
	objSheet.Cells(4,11).value=retvalArr[14]; //����ʱ��
	
	objSheet.Cells(5,2).value=retvalArr[15]; //�¼��ּ�
	objSheet.Cells(6,2).value=retvalArr[16]+retvalArr[17]; //�¼������ص�
	objSheet.Cells(7,5).value=retvalArr[18]+retvalArr[19]; //�Ƿ��ܹ��ṩҩƷ��ǩ��������ӡ��������
	objSheet.Cells(8,2).value=retvalArr[29];  //�¼���������
	
	objSheet.Cells(9,3).value=retvalArr[20];   //�Ƿ�����
	objSheet.Cells(9,7).value=retvalArr[21];   //ֱ������
	objSheet.Cells(9,11).value=retvalArr[22];  //����ʱ��
	objSheet.Cells(10,3).value=retvalArr[27];  //�Ƿ�������Σ
	objSheet.Cells(10,7).value=retvalArr[28];  //������(����)
	objSheet.Cells(11,3).value=retvalArr[24];  //�Ƿ��˺�
	objSheet.Cells(11,7).value=retvalArr[25];  //��λ���̶�
	objSheet.Cells(12,4).value=retvalArr[26];  //סԺʱ���ӳ�
	objSheet.Cells(13,3).value=retvalArr[23];  //�ָ�����
	
	objSheet.Cells(14,2).value=retvalArr[36];  //����ʱ������
	objSheet.Cells(15,2).value=retvalArr[30];  //�¼��������
	objSheet.Cells(16,2).value=retvalArr[31];  //�Ľ���ʩ
	objSheet.Cells(17,3).value=retvalArr[33];  //������
	objSheet.Cells(17,10).value=retvalArr[34]; //���ң����ţ�������
	
	var dgEvtRepDrgItmList=retvalArr[37];  //ҩƷ�б�

	var dgEvtRepDrgItmArr=dgEvtRepDrgItmList.split("||");
	for(var k=0;k<dgEvtRepDrgItmArr.length;k++){
		var dgEvtDrgItmArr=dgEvtRepDrgItmArr[k].split("^");
		objSheet.Cells(19+k,1).value=dgEvtDrgItmArr[0];  //��Ʒ����
		objSheet.Cells(19+k,2).value=dgEvtDrgItmArr[2];  //ͨ����
		objSheet.Cells(19+k,3).value=dgEvtDrgItmArr[9]; //��Ӧ��
		objSheet.Cells(19+k,5).value=dgEvtDrgItmArr[4];  //������ҵ
		objSheet.Cells(19+k,7).value=dgEvtDrgItmArr[10]; //����~У��
		objSheet.Cells(19+k,9).value=dgEvtDrgItmArr[7];  //���
		objSheet.Cells(19+k,10).value=dgEvtDrgItmArr[11]; //����
		objSheet.Cells(19+k,11).value=dgEvtDrgItmArr[6];  //����
		objSheet.Cells(19+k,12).value=dgEvtDrgItmArr[8];  //��װ����
	}
    //xlApp.Visible = true; 
	//xlApp.UserControl = true;
	xlBook.SaveAs(filePath+retvalArr[35]+".xls");
	xlApp=null;
	xlBook.Close(savechanges=false);
	objSheet=null;
}