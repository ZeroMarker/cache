/* 
 * FileName:	dhcinsu.insuopdivaudit.js
 * User:		HanZH
 * Date:		2022-10-17
 * Function:	
 * Description: �����շ����
*/

var InvAmt=0;
var OEInvId=""
var ItmOEID=""
$(function(){
	setPageLayout(); //ҳ�沼�ֳ�ʼ��
	//setElementEvent(); //ҳ���¼���ʼ��
	var a =document.getElementsByClassName("layout-button-up");
	  a[0].style.display="none";
});

//ҳ�沼�ֳ�ʼ��
function setPageLayout(){
	
	// Ĭ������
	$('#StartDate').datebox('setValue', getDefStDate(-61)); 	// getDefStDate() -> ��Ҫ���� <DHCBILL/>
	$('#EndDate').datebox('setValue', getDefStDate(0));
	//$("#InvAmt").val(InvAmt);
	setValueById('InvAmt',InvAmt);
	$("#InvAmt").attr("readOnly", true);	
	
	
	$('#RegNo').on('keydown', function (e) {
		findPatKeyDownRegNo(e);
	});		
	//��ѯ
	$HUI.linkbutton("#btnQuery", {
		onClick: function () {
			loadInvDataGrid();
		}
	});
	
	
	//���Է�
	$HUI.linkbutton("#btn-zf", {
		onClick: function () {
			ChangeOECoverMain("N");
		}
	});
	
	//��ҽ��
	$HUI.linkbutton("#btn-yb", {
		onClick: function () {
			ChangeOECoverMain("Y");
		}
	});
	
	//ҽ������
	$HUI.linkbutton("#btn-InsuDiv", {
		onClick: function () {
			InsuOPDivideForAudit();
		}
	});
	
	//ҽ������
	$HUI.linkbutton("#btn-InsuDivPrint", {
		onClick: function () {
			InsuDivPrint();
		}
	});
	
	//������ѯ
	$HUI.linkbutton("#btnCheckMB", {
		onClick: function () {
			btnCheckMBPrint();
		}
	});
	
	
	//ҽ������
	$HUI.linkbutton("#btnReadCard", {
		onClick: function () {
			InsuReadPatInfo();
		}
	});
	
	
	//�Ƿ��д�ӡ��Ʊ
	$HUI.combobox("#CPPFlag",{
		valueField:'code', 
		textField:'desc',
		panelHeight:"auto",
		data:[
			{code:'N',desc:'��',selected:'true'},
			{code:'Y',desc:'��'}
		]
	});
	
	//��Ʊ��ϸ�б�
	$HUI.datagrid('#InvGrid',{
		//title:'��Ʊ��ϸ',
		iconCls:'icon-apply-check',
		headerCls:'panel-header-gray',
		closable:false,
		collapsible:false,
		fitColumns:true,
		fit:true,
		rownumbers:true,
		checkOnSelect:false,
		//singleSelect:true,
		pagination:true,
		toolbar: '#InvToolBar', // ������ ��Ӧcsp�е�id
		pageSize:50,
		pageList:[10,20,30,50],
		url:$URL,
		columns:[[     
				{field:'checkbox',checkbox:true},
				{field:'Tind',title:'���',hidden:true,algin:'left'},
				{field:'TInvNo',title:'��Ʊ��',width:140},
				//{field:'TInvId',title:'��Ʊrowid',width:20,hidden:true},
				{field:'TInvId',title:'��Ʊrowid',width:120},
				{field:'TRegNo',title:'�ǼǺ�',width:120},
				{field:'TPatName',title:'��������',width:120},
				{field:'TPatID',title:'�������֤��',width:180},
				{field:'TTotalAmout',title:'��Ʊ���',width:120,align:'right'},
				{field:'TInvDate',title:'�շ�����',width:120},
				{field:'TInvTime',title:'�շ�ʱ��',width:120},
				{field:'TInsuMark',title:'ҽ�����',width:80,hidden:true}
		]],
		onLoadSuccess:function(){

		},
		onSelect:function(rowIndex,rowData){
			loadOEDataGrid(rowIndex,rowData);
		},
		onUnselect:function(rowIndex,rowData){
			cleanloadOEDataGrid(rowIndex,rowData);
		},
		onCheck:function(rowIndex,rowData){
			EditInvAmtAdd(rowIndex,rowData);
		},
		onUncheck:function(rowIndex,rowData){
			EditInvAmtSub(rowIndex,rowData);
		},
		onCheckAll:function(rows){
			EditInvAmtAddALL(rows);
		},
		onUncheckAll:function(rows){
			InvAmt=0;
   			setValueById('InvAmt',0);
   			setValueById('sfz',"");
		}
	});
	
	//ҽ����ϸ�б�
	$HUI.datagrid('#orGrid',{
		//title:'ҽ����ϸ',
		//iconCls:'icon-apply-check',
		//headerCls:'panel-header-gray',
		//fitColumns:true,
		border:false,
		fit:true,
		rownumbers:true,
		//singleSelect:true,
		checkOnSelect:false,
		pagination:true,
		toolbar: '#orToolBar', // ������ ��Ӧcsp�е�id
		pageSize:10,
		pageList:[10,20,30],
		url:$URL,
		columns:[[     
			{field:'checkbox',checkbox:true},
			{field:'BillDr',title:'BillDr',hidden:true},
			{field:'TCoverMainIns',title:'ҽ����ʶ',width:80},
			{field:'TOEID',title:'ҽ��ID',width:60},    
			{field:'TOEDesc',title:'ҽ������',width:160},
			{field:'TInsuxmmc',title:'ҽ����Ŀ����',width:160,size:10},
			{field:'TInsuxmdj',title:'��Ŀ�ȼ�',width:80},
			{field:'Insubz',title:'���Ʒ�Χ',width:200,size:10},
			{field:'TOEDept',title:'ִ�п���',width:100}, 
			{field:'TOEDate',title:'��ҽ������',width:80},   
			{field:'TOEDoctor',title:'��ҽ��ҽ��',width:80},
			{field:'TOEPrice',title:'����',width:60,align:'right'},    
			{field:'TOEQty',title:'����',width:60},
			{field:'TOEAmt',title:'���',width:60,align:'right'}
		]],
		onLoadSuccess:function(){
		},
		onSelect:function(rowIndex,rowData){
			loadItmDataGrid(rowIndex,rowData)
		},
		onUnselect:function(rowIndex,rowData){
			cleanloadItmDataGrid(rowIndex,rowData);
		}
		
	});
	
	//�շ�����ϸ�б�
	$HUI.datagrid('#ItmGrid',{
		title:'�շ�����ϸ',
		iconCls:'icon-apply-check',
		headerCls:'panel-header-gray',
		//fitColumns:true,
		fit:true,
		rownumbers:true,
		singleSelect:true,
		pagination:true,
		pageSize:10,
		pageList:[10,20,30],
		url:$URL,
		columns:[[  
			{field:'TItmind',title:'���',hidden:true}, 
			{field:'TarID',title:'�շ���ID',width:100,hidden:true},    
			{field:'TarCode',title:'ҽԺ��Ŀ����',width:120},
			{field:'TarDesc',title:'ҽԺ��Ŀ����',width:120}, 
			{field:'InsuItmID',title:'ҽ���շ���ID',width:100,hidden:true},
			{field:'InsuCode',title:'ҽ����Ŀ����',width:120},
			{field:'InsuDesc',title:'ҽ����Ŀ����',width:120},       
			{field:'Insuxmdj',title:'��Ŀ�ȼ�',width:80},
			{field:'ItmPrice',title:'����',width:80,align:'right'},    
			{field:'ItmQty',title:'����',width:60},
			{field:'ItmAmt',title:'���',width:80,align:'right'}
		]],
		onLoadSuccess:function(){
		}
	});
	var a =document.getElementsByClassName("layout-button-up");
	  a[0].style.display="none";
}


///���ط�Ʊ�б���Ϣ
function loadInvDataGrid(){
	
	var StartDate = $('#StartDate').datebox('getValue');
	var EndDate = $('#EndDate').datebox('getValue');
	var CPPFlag= $('#CPPFlag').combobox('getValue')
	var RegNo=$('#RegNo').val();
	var InvNo=$('#InvNo').val();
	//alert(InvNo)
	if((RegNo=="")&&(InvNo=="")) {
		$.messager.alert('��ʾ','�ǼǺźͷ�Ʊ�Ų���ͬʱΪ��,����','info');
		return;
	}
	
	var queryParams = {
		ClassName:'web.INSUOPDivideAudit',
		QueryName:'OPDivAuditApp',
		StartDate:StartDate, 
		EndDate:EndDate, 
		RegNo:RegNo, 
		InvNo:InvNo,
		CPPFlag:CPPFlag
	}
	$('#InvGrid').datagrid('options').url = $URL;
	$('#InvGrid').datagrid('load',queryParams);
	
}

///����ҽ���б���Ϣ
function loadOEDataGrid(rowIndex,rowData){
	
	var PrtRowidStr=rowData.TInvId;
	//alert(PrtRowidStr)
	var queryParams = {
		ClassName:'web.INSUOPDivideAudit',
		QueryName:'OPOEListAuditApp',
		PrtRowidStr:PrtRowidStr
	}
	$('#orGrid').datagrid('options').url = $URL;
	$('#orGrid').datagrid('load',queryParams);
	OEInvId=PrtRowidStr;
	
}
///���ҽ���б���Ϣ +20221202
function cleanloadOEDataGrid(rowIndex,rowData){
	if (rowData.TInvId==OEInvId){
		$('#orGrid').datagrid('load',{});
		$('#ItmGrid').datagrid('load',{});
	}
	
}


///�����շ���Ŀ�б���Ϣ
function loadItmDataGrid(rowIndex,rowData){
	var OeOrdDr=rowData.TOEID;
	var BillDr=rowData.BillDr;
	//alert(OeOrdDr+"^"+rowData.BillDr)
	var queryParams = {
		ClassName:'web.INSUOPDivideAudit',
		QueryName:'OPItmListAuditApp',
		BillDr:BillDr,
		OeOrdDr:OeOrdDr
	}
	$('#ItmGrid').datagrid('options').url = $URL;
	$('#ItmGrid').datagrid('load',queryParams);
	ItmOEID=OeOrdDr
	
}

///����շ���Ŀ�б���Ϣ +20221202
function cleanloadItmDataGrid(rowIndex,rowData){
	if (rowData.TOEID==ItmOEID){
		$('#ItmGrid').datagrid('load',{});
	}
	
}

///���Է�-��ҽ��
function ChangeOECoverMain(State){
	var OEORIRowIdStr=""
	var rows = $('#orGrid').datagrid('getChecked'); //�м�¼
	if(rows.length>0){
		for (i=0;i<rows.length;i++)
		{
			if(OEORIRowIdStr==""){OEORIRowIdStr=rows[i].TOEID;}
			else{OEORIRowIdStr=OEORIRowIdStr+"^"+rows[i].TOEID}
		}
		//alert(OEORIRowIdStr)
		
	}else{
		$.messager.alert('��ʾ','��ѡ����Ҫ�����ļ�¼','info');
	}
		
	$.m({
		ClassName: "web.INSUOPDivideAudit",
		MethodName: "UpdateOECoverMain",
		OEORIRowIdStr: OEORIRowIdStr,
		State:State
	}, function (rtn) {
		//alert(rtn)
		if(rtn==0){
			//$.messager.alert('��ʾ','�����ɹ�','info');
		}else{
			$.messager.alert('��ʾ','����ʧ��','info');
		}
	})
	$('#orGrid').datagrid('reload');
	$('#ItmGrid').datagrid('reload');
}



///ҽ������
function InsuOPDivideForAudit(){
	var StrInvDrStr=""
	var rows = $('#InvGrid').datagrid('getChecked'); //�м�¼
	if(rows.length>0){
		for (i=0;i<rows.length;i++)
		{
			if(StrInvDrStr==""){StrInvDrStr=rows[i].TInvId;}
			else{StrInvDrStr=StrInvDrStr+"^"+rows[i].TInvId}
			var StrInvDr=rows[rows.length-1].TInvId
		}
		
	}else{
		$.messager.alert('��ʾ','��ѡ����Ҫ����ļ�¼','info');
		return;
	}
	
	var UseQty=$('#UseQty').val();
	if(UseQty==""){UseQty="0";}			//add by xubaobao 2020 06 17
	var StrikeFlag="N"
	var GroupDR=session['LOGON.GROUPID'];
	var Guser=session['LOGON.USERID']
	var InsuNo=""
	var CardType=""
	var YLLB=""
	var DicCode=""
	var JSLY="01"
	var DYLB=""
	var MoneyType=""	//������
	var LeftAmt="0"
	var LeftAmtStr="!"+LeftAmt+"^"+MoneyType	
	var ExpString=StrikeFlag+"^"+GroupDR+"^"+InsuNo+"^"+CardType+"^"+YLLB+"^"+DicCode+"^^^"+JSLY+"^^"+DYLB+"^^"+session['LOGON.HOSPID']+"^"+LeftAmtStr		
	var ExpString=ExpString+"!"+"INSU"+"^"+UseQty
	var CPPFlag=""
	var AdmReasonId=tkMakeServerCall("web.INSUDicDataCom","GetDicDataDescByCode","HISPROPerty00A","OpChrgChkSetlAdmReasonId",session['LOGON.HOSPID']);
	if(AdmReasonId==""){
		$.messager.alert('��ʾ','���ʵ�Ƿ�ά����HISPROPerty00A�µ�OpChrgChkSetlAdmReasonId�ֵ����ã�','info');
		return;
	}
	
	//ҽ������
	var DivideStr=InsuOPDivideAudit(0 , Guser, StrInvDrStr, "1", AdmReasonId,ExpString,CPPFlag)	//DHCInsuPort.js
	
	DivRowid=tkMakeServerCall("web.DHCINSUPort","GetDivideIDByInvPrtDr",StrInvDr);
	//var flag=InsuOPJSDPrint00A(0,session['LOGON.USERID'],DivRowid,"","","")
	var flag=InsuOPJSDPrint(0,session['LOGON.USERID'],DivRowid,"",AdmReasonId,"",CPPFlag)
	if(DivideStr.split("^")[0]!="0"){
		//$.messager.alert('��ʾ','ҽ������ʧ��','info');
		//return;
	}
	
	$('#InvGrid').datagrid('reload');
	$('#orGrid').datagrid('reload');
	$('#ItmGrid').datagrid('reload');
	InvAmt=0;
}

function InsuDivPrint(){
	var StrInvDrStr=""
	var DivRowid=""
	var rows = $('#InvGrid').datagrid('getChecked'); //�м�¼
	if(rows.length>0){
		for (i=0;i<rows.length;i++)
		{
			if(StrInvDrStr==""){StrInvDrStr=rows[i].TInvId;}
			else{StrInvDrStr=StrInvDrStr+"^"+rows[i].TInvId}
		}
		
	}else{
		$.messager.alert('��ʾ','��ѡ����Ҫ����ļ�¼','info');
		return;
	}
	
	var GroupDR=session['LOGON.GROUPID'];
	var Guser=session['LOGON.USERID']
	DivRowid=tkMakeServerCall("web.DHCINSUDivideCtl","GetDivRowidByInvprt",rows[i].TInvId);
	var flag=InsuOPJSDPrint00A(0,session['LOGON.USERID'],DivRowid,"","","")
	
}

function EditInvAmtAdd(rowIndex,rowData){
	/*var rows = $('#InvGrid').datagrid('getChecked'); //�м�¼
	if(rows.length>0){
		for (i=0;i<rows.length;i++)
		{
			if(InvAmt==""){InvAmt=parseFloat(rows[i].TTotalAmout);}
			else{InvAmt=InvAmt+parseFloat(rows[i].TTotalAmout)}
		}
	}*/
	InvAmt=InvAmt+parseFloat(rowData.TTotalAmout);
	//InvAmt=InvAmt+Number(rowData.TTotalAmout);
	//$("#InvAmt").text(InvAmt);
	setValueById('InvAmt',InvAmt);
	setValueById('sfz',rowData.TPatID);
}

function btnCheckMBPrint(){
	var INSUType="00A"
	var InsuNo=""
	var ID=$('#sfz').val();
	var ExpString=INSUType+"^^^^^"
//	var flag=InsuReadCard00A(0,session['LOGON.USERID'],PatId,"02",ExpString)//DHCInsuPort.js
	var TmpStr=INSUDiseaseApproveQueryNew(0,session['LOGON.USERID'],ID,ExpString)
	$.messager.alert('��ʾ',TmpStr,'info');
	}

function EditInvAmtSub(rowIndex,rowData){
	/*var rows = $('#InvGrid').datagrid('getChecked'); //�м�¼
	if(rows.length>0){
		for (i=0;i<rows.length;i++)
		{
			if(InvAmt==""){InvAmt=parseFloat(rows[i].TTotalAmout);}
			else{InvAmt=InvAmt+parseFloat(rows[i].TTotalAmout)}
		}
	}*/
	InvAmt=InvAmt-parseFloat(rowData.TTotalAmout);
	//$("#InvAmt").text(InvAmt);
	setValueById('InvAmt',InvAmt);
	if(InvAmt=="0"){
		setValueById('sfz',"");
	}
	
}

function EditInvAmtAddALL(rows){
	InvAmt=0
	for (i=0;i<rows.length;i++){
		EditInvAmtAdd(i,rows[i])
	}
}

/*
///ҽ������
function InsuReadPatInfo(){
	var Guser=session['LOGON.USERID'];
	var CardType="";
	var InsuNo="";
	var ExpString=""
	var ID=$('#sfz').val();
	var SFZID=""
	var rows = $('#InvGrid').datagrid('getSelected'); //�м�¼
	if(rows.length>1){
		$.messager.alert('��ʾ','��ѡ��һ����Ҫ�����ļ�¼','info');
		return;
	}
	if(rows.TPatID==""&&ID==""){
		$.messager.alert('��ʾ','���֤�Ų���Ϊ��','info');
		return;
	}else if(rows.TPatID==""){
		SFZID=ID
	}else{
		SFZID=rows.TPatID
	}
	var ExpString=rows.TPatName+"^"+SFZID;
	var ReadInfo=InsuASReadPatInfo(0,Guser,CardType,InsuNo,ExpString)
	//alert(ReadInfo)
	if (ReadInfo.split("|")[0]=="0")
	{
		$('#PatTypeD').text(ReadInfo.split("|")[1]);	
		$('#DiagDesc').text(ReadInfo.split("|")[2]+"|"+ReadInfo.split("|")[3]);	
	}
}
*/

///�ǼǺŻس�
function findPatKeyDownRegNo(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		GetRegNo();
		loadInvDataGrid();
	}
}

//�ǼǺŲ���  
function GetRegNo(){
	var RegNo=$('#RegNo').val();
	var PRegNoLength=10-RegNo.length;      	
	for (var i=0;i<PRegNoLength;i++){
		RegNo="0"+RegNo;			
	}
	//$('#RegNo').val(RegNo);
	setValueById('RegNo',RegNo);
}


function getDefStDate(space) {
	if (isNaN(space)) {
		space = -30;
	}
	var dateObj = new Date();
	dateObj.setDate(dateObj.getDate() + space);
	var myYear = dateObj.getFullYear();
	var myMonth = (dateObj.getMonth() + 1) < 10 ? "0" + (dateObj.getMonth() + 1) : (dateObj.getMonth() + 1);
	var myDay = (dateObj.getDate()) < 10 ? "0" + (dateObj.getDate()) : (dateObj.getDate());
	var dateStr = "";
	var sysDateFormat = $.m({
			ClassName: "websys.Conversions",
			MethodName: "DateFormat"
		}, false); //ͬ������ȡϵͳ�������ڸ�ʽ
	if (sysDateFormat == 1) {
		dateStr = myMonth + '/' + myDay + '/' + myYear;
	} else if (sysDateFormat == 3) {
		dateStr = myYear + '-' + myMonth + '-' + myDay;
	} else {
		dateStr = myDay + '/' + myMonth + '/' + myYear;
	}

	return dateStr;
}




