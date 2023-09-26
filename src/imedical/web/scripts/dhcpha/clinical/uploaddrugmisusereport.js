/// Creator: bianshuai
/// CreateDate: 2014-10-29
//  Descript: ��ҩ�����ϱ�

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
			$('#dept').combobox('reload',url+'?action=GetAllLocNewVersion&hospId='+HospID+'  ')
			//$('#dept').combobox('reload',url+'?action=SelAllLoc&HospID='+HospID)
		}
	}); 

	//����
	$('#ward').combobox({
		mode:'remote',	
		onShowPanel:function(){ //qunianpeng 2017/8/14 ֧��ƴ����ͺ���
			$('#ward').combobox('reload',url+'?action=GetAllWardNewVersion')
			//$('#ward').combobox('reload',url+'?actiontype=SelAllLoc')			
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
	$('a:contains("����")').bind("click",Export); //����
	
	InitPatList(); //��ʼ�������б�
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
	var LocID=$('#dept').combobox('getValue');     //����ID
	var Status=$('#status').combobox('getValue'); //״̬
	if (LocID== undefined){LocID="";}
	var PatNo=$.trim($("#patno").val());
	var params=StDate+"^"+EndDate+"^"+LocID+"^"+PatNo+"^"+Status;

	$('#maindg').datagrid({
		url:url+'?action=GetDrgMisuseRep',	
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
		{field:'dmRepCode',title:'������',width:180},
		{field:'dgERepLoc',title:'���沿��',width:260},
		{field:'dgEPatNo',title:'�ǼǺ�',width:120},
		{field:'dgEPatName',title:'����',width:120},
		{field:'dgERepStatus',title:'��ǰ״̬',width:120},//liyarong 2016-09-19
		{field:'dgEReporter',title:'������',width:120},
		{field:'dgERepDate',title:'��������',width:120}
		//{field:'AuditTime',title:'�˻�ԭ��',width:120},
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
		dgERepStatus=row.dgERepStatus   //liyarong 2016-09-23
	}else{
		$.messager.alert('������ʾ','����ѡ��һ�м�¼!',"error");
		return;
	}
	showViewWin(dgERepID,dgERepStatus);
}

//�༭����
function showViewWin(dgERepID,dgERepStatus)    //liyarong 2016-09-23
{
	if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="win"></div>');
	$('#win').window({
		title:'����鿴',
		collapsible:true,
		border:false,
		closed:"true",
		width:1250,
		height:600
	});

		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.drugmisusereport.csp?mrRepID='+dgERepID+'&mrstatus='+dgERepStatus+'&editFlag='+0+'"></iframe>';  //liyarong 2016-09-23
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
	var retval=tkMakeServerCall("web.DHCSTPHCMDRGMISUSEREPORT","getDrgMisRepExportInfo",dgERepID);
	if(retval==""){
		$.messager.alert("��ʾ:","ȡ���ݴ���");
		return;
	}
	var retvalArr=retval.split("&&");

	//1����ȡXLS��ӡ·��
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCST_PHCM_DrgMisRep.xls";
	//var Template = "C:\\DHCST_PHCM_DrgMisRep.xls";
	
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;
	
	objSheet.Cells(2,2).value=retvalArr[2]; //����������
	objSheet.Cells(2,5).value=retvalArr[3]; //���ִ�������
	objSheet.Cells(2,8).value=retvalArr[1]; //��������
	objSheet.Cells(2,11).value=retvalArr[46]; //����
	
	objSheet.Cells(3,2).value=retvalArr[8];  //��������
	objSheet.Cells(3,4).value=retvalArr[11]; //��������
	objSheet.Cells(3,6).value=retvalArr[10]; //����
	objSheet.Cells(3,8).value=retvalArr[9];  //�Ա�
	objSheet.Cells(3,10).value=retvalArr[12]+"Kg"; //����
	objSheet.Cells(3,12).value=retvalArr[13]; //��ϵ��ʽ
	
	objSheet.Cells(4,3).value=retvalArr[14]; //סԺ��/��������
	objSheet.Cells(4,5).value=retvalArr[15]; //���

	objSheet.Cells(5,5).value=retvalArr[38]+retvalArr[39];  //�Ƿ��ܹ��ṩҩƷ��ǩ��������ӡ��������
	objSheet.Cells(6,2).value=retvalArr[41];  //��������
	objSheet.Cells(7,4).value=retvalArr[4];  //����ҩƷ�Ƿ񷢸�����
	objSheet.Cells(7,9).value=retvalArr[5];  //�����Ƿ�ʹ�ô���ҩƷ
	
	objSheet.Cells(8,2).value=retvalArr[6];  //����ּ�
	
	if(retvalArr[16]=="����"){
		objSheet.Cells(9,3).value=retvalArr[16];   //�Ƿ�����
		objSheet.Cells(9,7).value=retvalArr[17];   //ֱ������
	}else{
		objSheet.Cells(11,3).value=retvalArr[16];  //�Ƿ��˺�
		objSheet.Cells(11,7).value=retvalArr[17];  //��λ���̶�
	}
	objSheet.Cells(9,11).value=retvalArr[18]+" "+retvalArr[19];  //����ʱ��
	objSheet.Cells(10,3).value=retvalArr[20];  //�Ƿ�������Σ
	objSheet.Cells(10,7).value=retvalArr[21];  //������(����)
	objSheet.Cells(12,3).value=retvalArr[22];  //�ָ�����
		
	objSheet.Cells(13,3).value=retvalArr[42];  //�������������
	objSheet.Cells(14,3).value=retvalArr[29]+retvalArr[30];  //��������ĳ���
	objSheet.Cells(15,3).value=retvalArr[31]+retvalArr[32];  //����������Ա
	objSheet.Cells(16,3).value=retvalArr[35]+retvalArr[36];  //�����������ص���Ա
	objSheet.Cells(17,3).value=retvalArr[33]+retvalArr[34];  //���ִ������Ա
	objSheet.Cells(18,3).value=retvalArr[37];  //��������η��ֻ�����
	//objSheet.Cells(19,3).value=retvalArr[40];  //��Ԥ�����ƴ������Ľ���
	
	objSheet.Cells(19,2).value=retvalArr[23]; //������
	objSheet.Cells(19,4).value=retvalArr[24]; //����
	objSheet.Cells(19,6).value=retvalArr[25]; //ְ��
	objSheet.Cells(19,8).value=retvalArr[26]; //�绰
	objSheet.Cells(19,10).value=retvalArr[27]; //E-mail
	objSheet.Cells(19,12).value=retvalArr[28]; //�ʱ�

	var dgMisRepDrgItmList=retvalArr[47];  //ҩƷ�б�

	var dgMisRepDrgItmArr=dgMisRepDrgItmList.split("||");
	for(var k=0;k<dgMisRepDrgItmArr.length;k++){
		var dgMisDrgItmArr=dgMisRepDrgItmArr[k].split("^");

		objSheet.Cells(21+k,1).value=dgMisDrgItmArr[0];   //��Ʒ����
		objSheet.Cells(21+k,3).value=dgMisDrgItmArr[2];   //ͨ����
		objSheet.Cells(21+k,6).value=dgMisDrgItmArr[8];   //������ҵ
		objSheet.Cells(21+k,8).value=dgMisDrgItmArr[4];   //����
		objSheet.Cells(21+k,9).value=dgMisDrgItmArr[5];   //�÷�����
		objSheet.Cells(21+k,11).value=dgMisDrgItmArr[6];  //����
	}

    //xlApp.Visible = true; 
	//xlApp.UserControl = true;
	xlBook.SaveAs(filePath+retvalArr[46]+".xls");
	xlApp=null;
	xlBook.Close(savechanges=false);
	objSheet=null;
}
