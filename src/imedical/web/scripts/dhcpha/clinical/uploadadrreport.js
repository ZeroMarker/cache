/// Creator: bianshuai
/// CreateDate: 2014-10-29
//  Descript: ������Ӧ�ϱ�

var url="dhcpha.clinical.action.csp";
var statArray = [{ "val": "N", "text": "δ�ύ" }, { "val": "R", "text": "�˻�" }, { "val": "C", "text": "���ύ" }]; // wangxuejian 2016/10/28
$(function(){

	$("#stdate").datebox("setValue", formatDate(-2));  //Init��ʼ����
	$("#enddate").datebox("setValue", formatDate(0));  //Init��������
 	
	//����
	$('#dept').combobox({
		onShowPanel:function(){
			$('#dept').combobox('reload',url+'?action=SelAllLoc&loctype=E&HospID='+session['LOGON.HOSPID'])
		}
	}); 
	
	

/* 	$('#dept').combobox({
		onShowPanel:function(){
			$('#dept').combobox('reload',url+'?action=SelAllLoc&HospID='+session['LOGON.HOSPID'])
		}
	}); 
	 */
	 $('#status').combobox({	//qunianpeng 2016/11/2
		panelHeight:"auto",  //���������߶��Զ�����
		data:statArray,
		onSelect:function(option){}
	});
	$('#status').combobox('setValue',"N"); //����comboboxĬ��ֵ
/* 	//״̬   wangxuejian  2016/10/27
	var strParam = session['LOGON.GROUPID'] + "^" + session['LOGON.CTLOCID'] + "^" + session['LOGON.USERID'];
	var StatusCombobox = new ListCombobox("status",url+'?action=jsonAdrStatus&strParam='+strParam,'',{panelHeight:"auto"});   
	StatusCombobox.init(); */

	$('#Find').bind("click",Query);  //�����ѯ
	$('#Audit').bind("click",Audit); //����
	$('a:contains("��־")').bind("click",showLogWin); //��־
	$('a:contains("����")').bind("click",Export); 	  //����
	
	InitPatList(); //��ʼ�������б�
	
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
	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var LocID=$('#dept').combobox('getValue');     //����ID
	var status=$('#status').combobox('getValue');  //״̬
	if (typeof LocID=="undefined"){LocID="";}
	var PatNo=$.trim($("#patno").val());
	//var params=StDate+"^"+EndDate+"^"+LocID+"^"+PatNo+"^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^"+status+"^"+LgHospID;
	var params=StDate+"^"+EndDate+"^"+LocID+"^"+PatNo+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.USERID']+"^"+status+"^"+session['LOGON.HOSPID'];
	$('#maindg').datagrid({
	  url:url+'?action=QueryCompAdrReport',   //wangxuejian 2016-10-27 
	//	url:url+'?action=GetAdrReport',	
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
		{field:"AdrReqID",title:'AdrRepID',width:90},
		{field:'Edit',title:'�޸�',width:80,align:'center',formatter:setCellEditSymbol},
		{field:'View',title:'�鿴',width:80,align:'center',formatter:setCellViewSymbol,hidden:true},
		{field:'AdrRepDate',title:'��������',width:100},
		{field:'AdrReqNo',title:'������',width:160},
		{field:'PatNo',title:'�ǼǺ�',width:120},
		{field:'PatName',title:'����',width:120},
		{field:'AdrRepStatus',title:'��ǰ״̬',width:100},
		{field:'AdrNextStatus',title:'��һ״̬',width:100,hidden:true},
		{field:'AdrRepLoc',title:'�������',width:220},
		{field:'AdrReporter',title:'������',width:120},
		{field:'AdrRetReason',title:'�˻�����',width:320,formatter:setCellColor}
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
	//���datagrid  liyarong2016-11-03
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
}

///���ñ༭����
function setCellEditSymbol(value, rowData, rowIndex)
{
	return "<a href='#' onclick='showEditWin("+rowData.AdrReqID+")'><img src='../scripts/dhcpha/images/editb.png' border=0/></a>";
}

///���ò鿴����
function setCellViewSymbol(value, rowData, rowIndex)
{
	return "<a href='#' onclick='showViewWin("+rowData.AdrReqID+")'><img src='../scripts/dhcpha/images/multiref.gif' border=0/></a>";
}

///������ǰ��ɫ
function setCellColor(value, rowData, rowIndex)
{
	return '<span style="color:red;">'+value+'</span>';;
}

//�༭����
function showEditWin(AdrReqID)
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

	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.adrreport.csp?adrRepID='+AdrReqID+'&editFlag='+1+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
}

//�༭����
function showViewWin(AdrReqID)
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

	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.adrreport.csp?adrRepID='+AdrReqID+'&editFlag='+0+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
}

//��־
function showLogWin()
{
	var AdrReqID="";
	var row=$('#maindg').datagrid('getSelected');
	if (row){
		AdrReqID=row.AdrReqID ;
	}else{
		$.messager.alert('��ʾ',"<font style='color:red;font-weight:bold;font-size:20px;'>����ѡ��һ�м�¼!</font>","error");
		return;
	}
	
	$('#LogWin').css("display","block");
	$('#LogWin').window({
		title:'�����־',
		collapsible:true,
		border:false,
		closed:"true",
		width:700,
		height:300,
		onClose:function(){
			$('#LogWin').css("display","none");
		}
	});

	// ����columns
	var columns=[[
		{field:"Status",title:'״̬',width:100},
		{field:"AuditUser",title:'�����',width:100},
		{field:'AuditDate',title:'�������',width:100},
		{field:'AuditTime',title:'���ʱ��',width:100}
	]];
	
	// ����datagrid
	$('#medadvdicdg').datagrid({
		//title:'',
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...'
	});
	$('#LogWin').window('open');

    $('#medadvdicdg').datagrid({
		url:url+'?action=QueryAuditLog',	
		queryParams:{
			params:AdrReqID}
	});
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
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert('��ʾ',"<font style='color:red;font-weight:bold;font-size:20px;'>����ѡ��һ�м�¼!</font>","error");
		return;
	}
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ѡ��·����,���ԣ�</font>","error");
		return;
	}
	$.each(selItems, function(index, item){
		var adrrRepID=item.AdrReqID;         //����ID
		ExportExcel(adrrRepID,filePath);
	})
	$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>������ɣ�����Ŀ¼Ϊ:"+filePath+"</font>","info");
}

function ExportExcel(adrrRepID,filePath)
{
	if(adrrRepID==""){
		$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>����IDΪ�գ�</font>");
		return;
	}
	var retval=tkMakeServerCall("web.DHCSTPHCMADRREPORT","getAdrRepExportInfo",adrrRepID);
	if(retval==""){
		$.messager.alert("��ʾ:","ȡ���ݴ���");
		return;
	}

	var retvalArr=retval.split("&&");
	//1����ȡXLS��ӡ·��
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCST_PHCM_AdrReport.xls";
	//var Template = "C:\\DHCST_PHCM_AdrReport.xls";
	
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;
	objSheet.Cells(2,2).value=retvalArr[2]; //����״̬
	objSheet.Cells(2,9).value=retvalArr[1]; //���
	objSheet.Cells(3,2).value=retvalArr[3]+","+retvalArr[4]+""+retvalArr[5]; //����
	objSheet.Cells(3,7).value=retvalArr[6]; //���浥λ���
	
	objSheet.Cells(4,2).value=retvalArr[9]; //��������
	objSheet.Cells(4,4).value=retvalArr[10]; //�Ա�
	objSheet.Cells(4,6).value=retvalArr[12]; //��������
	objSheet.Cells(4,8).value=retvalArr[13]; //����
	objSheet.Cells(4,10).value=retvalArr[14]; //����
	objSheet.Cells(4,12).value=retvalArr[15]; //��ϵ��ʽ
	
	objSheet.Cells(5,2).value=retvalArr[47]; //ԭ������
	objSheet.Cells(5,5).value=retvalArr[37]; //ҽԺ����
	objSheet.Cells(5,9).value=retvalArr[17]+retvalArr[18]; //����ҩƷ������Ӧ/�¼�
	objSheet.Cells(6,5).value=retvalArr[16]; //������/�����
	objSheet.Cells(6,9).value=retvalArr[19]+retvalArr[20]; //����ҩƷ������Ӧ/�¼�

	objSheet.Cells(7,2).value=retvalArr[49]; //�����Ҫ��Ϣ
	
	objSheet.Cells(8,3).value=retvalArr[48];  //������Ӧ/�¼�����
	objSheet.Cells(8,10).value=retvalArr[21]; //������Ӧ/�¼�����ʱ��
	
	objSheet.Cells(10,1).value=retvalArr[50]; //������Ӧ/�¼���������
	
	objSheet.Cells(11,3).value=retvalArr[22]; //������Ӧ/�¼��Ľ��
	objSheet.Cells(11,7).value=retvalArr[23]; //����/ֱ������
	objSheet.Cells(11,11).value=retvalArr[24]+" "+retvalArr[25]; //����ʱ��
	
	objSheet.Cells(12,5).value=retvalArr[26]; //ͣҩ������󣬷�Ӧ/�¼��Ƿ���ʧ����᣿
	objSheet.Cells(13,5).value=retvalArr[27]; //�ٴ�ʹ�ÿ���ҩƷ���Ƿ��ٴγ���ͬ����Ӧ/�¼�
	objSheet.Cells(14,5).value=retvalArr[28]; //��ԭ��������Ӱ��
	
	objSheet.Cells(15,3).value=retvalArr[29]; //����������
	objSheet.Cells(15,10).value=retvalArr[30]; //ǩ��
	objSheet.Cells(16,3).value=retvalArr[31];  //���浥λ����
	objSheet.Cells(16,10).value=retvalArr[32]; //ǩ��
	
	objSheet.Cells(17,3).value=retvalArr[33]; //��ϵ�绰
	objSheet.Cells(18,3).value=retvalArr[36]; //��������
	objSheet.Cells(17,10).value=retvalArr[34]+retvalArr[35]; //ְҵ
	objSheet.Cells(18,6).value=retvalArr[30]; //ǩ��
	objSheet.Cells(18,10).value=retvalArr[43]; //���沿��
	
	objSheet.Cells(19,3).value=retvalArr[37]; //��λ����
	objSheet.Cells(19,6).value=retvalArr[38]; //��ϵ��
	objSheet.Cells(19,8).value=retvalArr[39]; //�绰
	objSheet.Cells(19,11).value=retvalArr[41]; //��������
	
	objSheet.Cells(20,2).value=retvalArr[40]; //��ע
	
	var adrRepDrgItmList=retvalArr[51];  //ҩƷ�б�

	var adrRepDrgItmArr=adrRepDrgItmList.split("||");
	for(var k=0;k<adrRepDrgItmArr.length;k++){
		var drgItmArr=adrRepDrgItmArr[k].split("^");
		objSheet.Cells(23+k,1).value=drgItmArr[0]; //����
		objSheet.Cells(23+k,2).value=drgItmArr[1]; //��׼�ĺ�
		objSheet.Cells(23+k,3).value=drgItmArr[3]; //��Ʒ����
		objSheet.Cells(23+k,4).value=drgItmArr[8]; //ͨ����
		objSheet.Cells(23+k,6).value=drgItmArr[5]; //����
		objSheet.Cells(23+k,7).value=drgItmArr[17]; //����
		objSheet.Cells(23+k,8).value=drgItmArr[9]; //�÷�����
		objSheet.Cells(23+k,9).value=drgItmArr[13]; //��ʼʱ��
		objSheet.Cells(23+k,11).value=drgItmArr[14]; //����ʱ��
		objSheet.Cells(23+k,12).value=drgItmArr[16]; //��ҩԭ��
	}
	
	//xlApp.Visible = true; 
	//xlApp.UserControl = true;
	//xlBook.SaveAs("D:\\"+retvalArr[1]+".xls");
	//var signSys="\\";
	//filePath=filePath.replace("\\",signSys);
	//alert("filePath:"+filePath)
	xlBook.SaveAs(filePath+retvalArr[1]+".xls");
	xlApp=null;
	xlBook.Close(savechanges=false);
	objSheet=null;
}
