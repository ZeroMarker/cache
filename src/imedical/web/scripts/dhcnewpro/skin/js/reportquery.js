
/// Creator: congyue
/// CreateDate: 2017-07-28
/// Descript: �����¼����� ��ѯ����
var url = "dhcadv.repaction.csp";
var statShare = [{ "val": "δ����", "text": "δ����" },{ "val": "����", "text": "����" }];
var statArray = [{ "val": "Y", "text": "���ύ" },{ "val": "N", "text": "δ�ύ" }];
var statReceive = [{ "val": "δ����", "text": "δ����" },{ "val": "1", "text": "����" },{ "val": "2", "text": "����" }];
var statOverTime = [{ "val": "Y", "text": "��ʱ" },{ "val": "N", "text": "δ��ʱ" }];
var formNameID="";
var StrParam="";
var StDate="";  //formatDate(-7);  //һ��ǰ������   2018-01-26 �޸ģ�Ĭ�Ͽ�ʼ����Ϊ����ʹ�����ڣ���2018-01-01
var EndDate=formatDate(0); //ϵͳ�ĵ�ǰ����
var querytitle="" ,cancelflag="";
$(function(){ 
	//var DateFormat="3" ;
	if(DateFormat=="4"){ //���ڸ�ʽ 4:"DMY" DD/MM/YYYY
		StDate="01"+"/"+"01"+"/"+2018;  //���꿪ʼ����
	}else if(DateFormat=="3"){ //���ڸ�ʽ 3:"YMD" YYYY-MM-DD
		StDate=2018+"-"+"01"+"-"+"01";  //���꿪ʼ����
	}else if(DateFormat=="1"){ //���ڸ�ʽ 1:"MDY" MM/DD/YYYY
		StDate="01"+"/"+"01"+"/"+2018;  //���꿪ʼ����
	}
	/*document.onkeydown = function(e){ 
    var ev = document.all ? window.event : e;
    	if(ev.keyCode==13) {
			commonQuery({'datagrid':'#datagrid','formid':'#toolbar'})
     	}
	}*/
	
/* 	//����
	$('#dept').combobox({
		//panelHeight:"auto",  //���������߶��Զ�����
		url:url+'?action=SelAllLoc'
		
	}); */
   /* $('#dept').combobox({ //  yangyongtao   2017-11-17
		mode:'remote',  //���������������
		onShowPanel:function(){ 
			$('#dept').combobox('reload',url+'?action=GetAllLocNewVersion&hospId='+LgHospID+'')
		}
	}); */
	var UserId="";
	if((LgGroupDesc=="����")||(LgGroupDesc=="Nursing Manager")){
		UserId="";
	}else{
		UserId=LgUserID;
	}
	$('#dept').combobox({ //  yangyongtao   2017-11-17
		mode:'remote',  //���������������
		onShowPanel:function(){ //GetSecuGroupCombox(UserId)
			$('#dept').combobox('reload','dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=GetSecuGroupCombox&UserId='+UserId+'&GroupId='+LgGroupID+'&LocId='+LgCtLocID+'')
		}
	});
	//$("#dept").combobox('setValue',LgCtLocID);
	//$("#dept").combobox('setText',LgCtLocDesc);
	/* if((LgGroupDesc!="����")&&(LgGroupDesc!="Nursing Manager")){
		$('#dept').combobox("setValue",LgCtLocID);     //����ID
		$("#dept").combobox('setText',LgCtLocDesc);
	} */
	
	if(LgGroupDesc=="סԺ��ʿ"){
		$('#dept').combobox({disabled:true});;  //����ID
		$('#dept').combobox("setValue",LgCtLocID);     //����ID
		$("#dept").combobox('setText',LgCtLocDesc);
	}
	
	//״̬
	$('#status').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		data:statArray
	});
	//��������
	$('#typeevent').combobox({
		//panelHeight:"auto",  //���������߶��Զ�����
		url:url+'?action=SelEventbyNew'
		
	});
	//����״̬
	$('#Share').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		data:statShare
	});
	//����״̬
	$('#receive').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		data:statReceive
	});
	//��ʱ״̬
	$('#OverTime').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		data:statOverTime
	});
	//��ҳ �����������
	StrParam=getParam("StrParam");
	querytitle=getParam("querytitle");
	if(StrParam!=""){
		var tmp=StrParam.split("^");
		$("#stdate").datebox("setValue", tmp[0]);  //Init��ʼ����
		$("#enddate").datebox("setValue", tmp[1]);  //Init��������		
		if(tmp[2]!=""){
			$('#dept').combobox({disabled:true});;  //����ID
			$('#dept').combobox("setValue",tmp[2]);     //����ID
			$("#dept").combobox('setText',LgCtLocDesc);
		}else{
			$('#dept').combobox("setValue",tmp[2]);     //����ID
			$("#dept").combobox('setText',"")
		}
		$('#status').combobox("setValue",tmp[7]);  //״̬
		$('#typeevent').combobox("setValue",tmp[8]);  //��������
		$('#Share').combobox("setValue",tmp[9]);  //����״̬ 
	}else{
		$("#stdate").datebox("setValue", StDate);  //Init��ʼ����
		$("#enddate").datebox("setValue", EndDate);  //Init��������
	}
	$('#querytitle').html("�����ۺϲ�ѯ"+querytitle);
	cancelflag=getParam("cancelflag");//���Ͻ����ʶ
	if(cancelflag=="Y"){
		$('#topquerytitle').html("����������ѯ");
		$('#querytitle').html("����������ѯ");
		$('#Print').hide();  //�����ӡ
		$('#Export').hide();  //�������(��̬����)
		$('#ExportAll').hide();
		$('#RepCancel').hide();
		$('#RepDelete').hide();

	}else{
		if((LgGroupDesc=="����")||(LgGroupDesc=="Nursing Manager")){
			//$('#ExportWord').show();
			//$('#ExportExcel').show();
			//$('#ExportExcelAll').show();
			//$('#ExportGather').show();
			$('#RepCancel').show();
			$('#RepDelete').show();
		}else{
			//$('#ExportWord').hide();
			//$('#ExportExcel').hide();
			//$('#ExportExcelAll').hide();
			//$('#ExportGather').hide();
			$('#RepCancel').hide();
			$('#RepDelete').hide();
		}
	}
	$('#Refresh').bind("click",Query);  //ˢ��
	$('#Find').bind("click",Query);  //�����ѯ 
	$('#Print').bind("click",Print);  //�����ӡ
	$('#Export').bind("click",Export);  //�������(��̬����)
	//$('#ExportWord').bind("click",ExportWord);  //�������(����ίwprd����)	
	///$('#ExportExcel').bind("click",ExportExcel);  //�������(����ίexcel����)
	//$('#ExportExcelAll').bind("click",ExportExcelAll);  //�������(ҽ�ܾ�excel����)
	$('#ExportAll').bind("click",ExportAll);  //�������(ȫ�����͹̶�����)
	//$('#ExportGather').bind("click",ExportGather);  //�������(���ܰ�)
	$('#RepCancel').bind("click",RepCancel); //���� 
	$('#RepDelete').bind("click",RepDelete); //ɾ�� 
	InitPatList();
	
	$("#reqList").height($(window).height()-245)//hxy 08-28 st
	$("#maindg").datagrid('resize', {           
            height : $(window).height()-245
    }); 
    window.onresize=resizeH;                    //hxy 08-28 ed
	
});
//����Ӧ hxy 2017-08-28
function resizeH(){
	$("#reqList").height($(window).height()-245)
	$("#maindg").datagrid('resize', { 
            height : $(window).height()-245
    }); 
}
//��ʼ�������б�
function InitPatList()
{
	//����columns
	var columns=[[
		{field:"ck",checkbox:true,width:20},
		{field:'LkDetial',title:'����',width:100,align:'center',formatter:SetCellOpUrl,hidden:true},
		{field:"RepID",title:'RepID',width:80,hidden:true},
		{field:"recordID",title:'recordID',width:80,hidden:true},
		{field:'RepShareStatus',title:'����״̬',width:80,align:'center',hidden:true},
		{field:'Edit',title:'�鿴',width:50,align:'center',formatter:setCellEditSymbol,hidden:false},
		{field:'StatusLast',title:'��һ״̬',width:100,hidden:true},
		{field:'StatusLastID',title:'��һ״̬ID',width:100,hidden:true},
		{field:"RepStaus",title:'����״̬',width:100,hidden:false},
		{field:"RepStausDr",title:'����״̬Dr',width:100,hidden:true},
		{field:'Medadrreceive',title:'����״̬',width:100,hidden:true},
		{field:'Medadrreceivedr',title:'����״̬dr',width:80,hidden:true},
		{field:'RepDate',title:'��������',width:120},
		{field:'PatID',title:'�ǼǺ�',width:120,hidden:false},
		{field:'AdmNo',title:'������',width:120},
		{field:'PatName',title:'����',width:120},
		{field:'RepType',title:'��������',width:280},
		{field:'OccurDate',title:'��������',width:120},
		{field:'OccurLoc',title:'��������',width:150},
		{field:'LocDep',title:'����ϵͳ',width:150},
		{field:'RepLoc',title:'�������',width:150},	
		{field:'RepUser',title:'������',width:120},
		{field:'RepTypeCode',title:'�������ʹ���',width:120,hidden:true},
		{field:'RepImpFlag',title:'�ص��ע',width:120,hidden:true},
		{field:'RepSubType',title:'����������',width:120,hidden:true},
		{field:'RepLevel',title:'�����¼�����',width:120,hidden:true},
		{field:'RepInjSev',title:'�˺����ض�',width:120,hidden:true},
		{field:'RepTypeDr',title:'��������Dr',width:120,hidden:true},
		{field:'StaFistAuditUser',title:'��������',width:120,hidden:true},
		{field:'BackAuditUser',title:'���ز�����',width:120,hidden:true},
		{field:'RepOverTimeflag',title:'���ʱ',width:120,hidden:false},
		{field:'AutOverTimeflag',title:'��ʿ����˳�ʱ',width:120,hidden:false},
		{field:'CaseShareLoclist',title:'�������',width:120,hidden:false},
		{field:'FileFlag',title:'�鵵״̬',width:80}
		
	]];

	//����datagrid
	$('#maindg').datagrid({
		toolbar: '#toolbar',//hxy add 08-28
		title:'', //hxy �����б�
		method:'get',
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryRepList'+'&StrParam='+StrParam,
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		height:300,
		nowrap:false,
		rowStyler:function(index,row){    // yangyongtao 2017-11-22
	        /* if ((row.RepStaus).indexOf("����") >= 0){  
	            return 'background-color:red;';  
	        } */
	          
	        if ((row.StaFistAuditUser==LgUserName)||(row.BackAuditUser==LgUserName)){  
	            return 'background-color:red;';  
	        } 
    	}
	});
	if(StrParam==""){
		Query();
	}
}
function Query()
{
	//1�����datagrid 
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
	if((querytitle!="")&&(LgGroupDesc=="סԺ��ʿ")){
		$('#dept').combobox("setValue",LgCtLocID);     //����ID
		$("#dept").combobox('setText',LgCtLocDesc);
	}
	//2����ѯ
	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var LocID=$('#dept').combobox('getValue');     //����ID
	var status=$('#status').combobox('getValue');  //״̬
	var typeevent=$('#typeevent').combobox('getValue');  //��������
	var statShare=$('#Share').combobox('getValue');  //����״̬ 
	var receive="";  //$('#receive').combobox('getText');  //����״̬ 
	var OverTime=$('#OverTime').combobox('getValue');  //����״̬
	if (status==undefined){status="";} 
	if (typeevent==undefined){typeevent="";}
	if (statShare==undefined){statShare="";}
	if (OverTime==undefined){OverTime="";}
	var PatNo=$.trim($("#patno").val());
	var StrParam=StDate+"^"+EndDate+"^"+LocID+"^"+PatNo+"^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^"+status+"^"+typeevent+"^"+statShare+"^"+receive+"^^^"+"^"+OverTime+"^^"+cancelflag;
	//var StrParam=StDate+"^"+EndDate+"^"+LocID+"^"+PatNo+"^"+134+"^"+6+"^"+359+"^"+status+"^"+typeevent+"^"+statShare;
	//alert(StrParam);
	$('#maindg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryRepList',	
		queryParams:{
			StrParam:StrParam}
	});
	querytitle="";
	if(cancelflag=="Y"){
		$('#querytitle').html("����������ѯ");
	}else{
		$('#querytitle').html("�����ۺϲ�ѯ"+querytitle);
	}
		
	//var Rel='dhcadv.reportquery.csp?StrParam='+StrParam+'&querytitle='+"";
	//location.href=Rel;
}

function showDetail(){
	var rowsData = $("#datagrid").datagrid('getSelected')
	if (rowsData == null) {
		$.messager.alert("��ʾ","��ѡ���!");
		return;
	}
	window.open("formrecorditm.csp?recordId="+rowsData.recordID)
}


///���ñ༭����
function setCellEditSymbol(value, rowData, rowIndex)
{
		var recordID=rowData.recordID;         //����д��¼ID
		var RepID=rowData.RepID                //����ID   yangyongtao 2017-11-24
		var RepStaus=rowData.RepStaus;         //��״̬
		if (RepStaus=="δ�ύ"){
			RepStaus=""; //����Ϊδ�ύ������Ϊ��
		}
		var RepTypeDr=rowData.RepTypeDr;         //��������Dr
		var RepTypeCode=rowData.RepTypeCode; //�������ʹ���
		var RepType=rowData.RepType; //��������
		var StatusLast=rowData.StatusLast; //������һ״̬
		var RepUser=rowData.RepUser //������
		var Medadrreceivedr=rowData.Medadrreceivedr //����״̬dr
		var StaFistAuditUser=rowData.StaFistAuditUser  //��������
		var BackAuditUser=rowData.BackAuditUser //���ز�����
		var editFlag=1;  //�޸ı�־  1�����޸� -1�������޸�   �����һ״̬Ϊ�ղ��ҽ���״̬�ǲ��أ�����״̬drΪ2��������޸�
		/* if((StatusLast!="")&&(RepStaus.indexOf("����") < 0)&&(RepUser!=LgUserName)){
			editFlag=-1;
		} */
		
		if(((StatusLast!="")&&(RepStaus.indexOf("����") < 0)&&(LgGroupDesc=="סԺ��ʿ"))){///&&(Medadrreceivedr!=2)
			editFlag=-1;
		}
		if(((StatusLast=="")&&(RepUser!=LgUserName)&&(LgGroupDesc=="סԺ��ʿ"))){///&&(Medadrreceivedr!=2)
			editFlag=-1;
		}
		if((Medadrreceivedr==2)&&(StaFistAuditUser!=LgUserName)&&(BackAuditUser!=LgUserName)){
			editFlag=-1;
		}
		if(cancelflag=="Y"){
			editFlag=-1;
		}
		
		var adrReceive=rowData.Medadrreceivedr; //����״̬dr
		
		return "<a href='#' onclick=\"showEditWin('"+recordID+"','"+RepStaus+"','"+RepTypeDr+"','"+RepTypeCode+"','"+RepType+"','"+editFlag+"','"+RepID+"','"+adrReceive+"')\"><img src='../scripts/dhcnewpro/images/adv_sel_8.png' border=0/></a>";
}

//�༭����
function showEditWin(recordID,RepStaus,RepTypeDr,RepTypeCode,RepType,editFlag,RepID,adrReceive)
{
	if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="win"></div>');
	$('#win').window({
		title:'����༭',
		collapsible:true,
		border:false,
		closed:"true",
		width:1350,    ///2017-11-23  cy  �޸ĵ��������С 1250  ��Ŀ1550
		height:600
	});
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.layoutform.csp?recordId='+recordID+'&RepStaus='+RepStaus+'&RepTypeDr='+RepTypeDr+'&code='+RepTypeCode+'&desc='+RepType+'&editFlag='+editFlag+'&RepID='+RepID+'&adrReceive='+adrReceive+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
	//window.open("formrecorditmedit.csp?recordId="+rowsData.ID)
}

//����  ����
function SetCellOpUrl(value, rowData, rowIndex)
{   var RepID=rowData.RepID;         //����ID
	var RepTypeCode=rowData.RepTypeCode; //�������ʹ���
	var RepShareStatus=rowData.RepShareStatus  //����״̬
	var html = "";
	if (RepShareStatus == "����"){
		html = "<a href='#' onclick=\"newCreateConsultWin('"+RepID+"','"+RepTypeCode+"')\" style='margin:0px 5px;font-weight:bold;color:red;text-decoration:none;'>�鿴�ظ��б�</a>";
	}else{
		  html = "<a href='#' onclick=\"newCreateConsultWin('"+RepID+"','"+RepTypeCode+"')\">�鿴�ظ��б�</a>";
		}
    return html;
}

/**
  * �½����۴���
  */
function newCreateConsultWin(RepID,RepTypeCode){
	if($('#winonline').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="winonline"></div>');
	$('#winonline').window({
		title:'�б�',
		collapsible:true,
		border:false,
		closed:"true",
		width:1110,
		height:500
	});
	
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.onlinereview.csp?ID='+RepID+'&TypeCode='+RepTypeCode+'"></iframe>';
		$('#winonline').html(iframe);
		$('#winonline').window('open');
	
}
//��ӡ
function Print(){
	var rowsData = $("#maindg").datagrid('getSelections')
	if (rowsData.length=="0") {
		$.messager.alert("��ʾ","��ѡ��һ����¼!");
		return;	
	}
	
	for(i=0;i<rowsData.length;i++){
		var recordId = rowsData[i].recordID;
		var RepID = rowsData[i].RepID;
		var RepTypeCode= rowsData[i].RepTypeCode;
		printRepForm(RepID,RepTypeCode);
		
	}	
	//window.open("formprint.csp?recordId="+rowsData[0].recordID);
}
//congyue 2017-09-06 �����ҳͼ�꣬������ҳ
function Gologin(){
	location.href='dhcadv.homepage.csp';
}
//2016-10-10
function CloseWinUpdate(){
	$('#win').window('close');
}
function cleanInput(){
	
	var StDate=formatDate(-7);  //һ��ǰ������
	var EndDate=formatDate(0); //ϵͳ�ĵ�ǰ����
	$("#stdate").datebox("setValue", StDate);  //Init��ʼ����
	$("#enddate").datebox("setValue", EndDate);  //Init��������
	$('#dept').combobox('setValue',"");     //����ID
	$("#status").combobox('setValue',"");
	$('#typeevent').combobox('setValue',"");;  //��������
	$('#receive').combobox('setValue',"");;  //����״̬
	$('#Share').combobox('setValue',"");;  //����״̬
 	$("#ImpFlag").val("");             //��ע״̬
	$("#patno").val("");
}
// ����word ����ί
function ExportWord()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert('��ʾ',"<font style='color:red;font-weight:bold;font-size:20px;'>����ѡ��һ�м�¼!</font>","error");
		return;
	}
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ȡ��������</font>","error");
		return;
	}
   	var re=/[a-zA-Z]:\\/;     //wangxuejian 2016-10-10
	if ((filePath.match(re)=="")||(filePath.match(re)==null)){
		$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ѡ����Ч·����,���ԣ�</font>","error");
		return;
	}

	for(i=0;i<selItems.length;i++){
		var recordId = selItems[i].recordID;
		var RepID = selItems[i].RepID;
		var RepTypeCode= selItems[i].RepTypeCode;
		var RepType= selItems[i].RepType;
		ExportWordData(RepID,RepTypeCode,RepType,filePath);
	}	
	$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>������ɣ�����Ŀ¼Ϊ:"+filePath+"</font>","info");
}
// ����Excel ����ί
function ExportExcel()
{
	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ȡ��������</font>","error");
		return;
	}
  	var re=/[a-zA-Z]:\\/;     //wangxuejian 2016-10-10
	if ((filePath.match(re)=="")||(filePath.match(re)==null)){
		$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ѡ����Ч·����,���ԣ�</font>","error");
		return;
	}
	var Staticflag=ExportExcelStatic(StDate,EndDate,filePath);
	if(Staticflag==true){
		$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>������ɣ�����Ŀ¼Ϊ:"+filePath+"</font>","info");
	}else{
		$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>����ʧ�ܣ�</font>","info");
	}
}
// ����Excel ҽ�ܾ�
function ExportExcelAll()
{

	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var typeevent=$('#typeevent').combobox('getText');  //��������
	if((typeevent=="")||(typeevent=="ȫ��")){
		$.messager.alert("��ʾ:","��ѡ����屨������","error");
		return;
	}
	if((typeevent.indexOf("ҽ��") >= 0)){
		$.messager.alert("��ʾ:","������û��ҽ�ܾ���Ҫ���ݣ���ѡ����������","error");
		return;
	}
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ȡ��������</font>","error");
		return;
	}
  	var re=/[a-zA-Z]:\\/;     //wangxuejian 2016-10-10
	if ((filePath.match(re)=="")||(filePath.match(re)==null)){
		$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ѡ����Ч·����,���ԣ�</font>","error");
		return;
	}
	var Allflag=ExportExcelAllData(StDate,EndDate,typeevent,filePath);
	if(Allflag==true){
		$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>������ɣ�����Ŀ¼Ϊ:"+filePath+"</font>","info");
	}else{
		$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>����ʧ�ܣ�</font>","info");
	}
}

// ����(��̬)
function Export()
{
	var typeevent=$('#typeevent').combobox('getValue');  //��������
	if((typeevent=="")||(typeevent=="ȫ��")){
		$.messager.alert("��ʾ:","��ѡ����屨������","error");
		return;
	}
	//formNameID==##class(web.DHCADVCOMMONPART).GetFormNameID
	runClassMethod("web.DHCADVCOMMONPART","GetFormNameID",{"AdrEvtDr":typeevent},
	function(ret){
		formNameID=ret
	},'text',false);
	//���崦�ڴ�״̬,�˳�
	if(!$('#ExportWin').is(":visible")){
		$('#ExportWin').window('open');
		//initDatagrid();
		reloadAllItmTable(formNameID);
		$('#setItmTable').datagrid('loadData', {total:0,rows:[]}); 
		return;
	} 
	$('#ExportWin').window({
		title:'����',
		collapsible:false,
		border:false,
		closed:false,
		width:800,
		height:480
	});
	$('#ExportWin').window('open');
	initDatagrid();
	$("a:contains('���Ԫ��')").bind('click',addItm);
    $("a:contains('ɾ��Ԫ��')").bind('click',delItm);
    $("a:contains('ȫ��ѡ��')").bind('click',selAllItm);
    $("a:contains('ȡ��ѡ��')").bind('click',unSelAllItm);
    $("a:contains('ȫ��ɾ��')").bind('click',delAllItm);

}

function initDatagrid(){
	var columns=[[
		{field:'FormDicID',title:'FormDicID',width:50,hidden:true},
		{field:'DicField',title:'DicField',width:100,hidden:true},
		{field:'DicDesc',title:'ȫ����',width:200}
	]];
	
	$("#allItmTable").datagrid({
		url:LINK_CSP+"?ClassName=web.DHCADVEXPFIELD&MethodName=GetSetFiel",
		queryParams:{
			ForNameID:""
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		loadMsg: '���ڼ�����Ϣ...',
		//showHeader:false,
		rownumbers : false,
		pagination:false,
		onSelect:function (rowIndex, rowData){
			
		}
	});	
	
	var setcolumns=[[
		{field:'FormDicID',title:'FormDicID',width:50,hidden:true},
		{field:'DicField',title:'DicField',width:100,hidden:true},
		{field:'DicDesc',title:'������',width:200}
	]];

	$("#setItmTable").datagrid({
		url:"",
		fit:true,
		rownumbers:true,
		columns:setcolumns,
		loadMsg: '���ڼ�����Ϣ...',
		//showHeader:false,
		rownumbers : false,
		pagination:false,
		onSelect:function (rowIndex, rowData){
			
		}
	});
	$('#setItmTable').datagrid('loadData', {total:0,rows:[]}); 
	reloadAllItmTable(formNameID);
	reloadSetFielTable(formNameID);
		
}
///���Ԫ��
function addItm(){
	var datas = $("#allItmTable").datagrid("getSelections");
	if(datas.length<1){
		$.messager.alert("��ʾ","δѡ��������ݣ�");
		return;	    
	}
	for(var i=0;i<datas.length;i++)
	{
		$('#setItmTable').datagrid('insertRow',{
			index:0,
			row:{
				FormDicID:datas[i].FormDicID,
				DicField:datas[i].DicField,
				DicDesc:datas[i].DicDesc
			}
		
		})
		var aindex=$('#allItmTable').datagrid('getRowIndex',datas[i]);
		$('#allItmTable').datagrid('deleteRow',aindex);

	} 

}
function delItm(){
	var datas = $("#setItmTable").datagrid("getSelections");
	if(datas.length<1){
		$.messager.alert("��ʾ","δѡ���Ҳ����ݣ�");
		return;	    
	}
	for(var i=0;i<datas.length;i++)
	{
		var aindex=$('#setItmTable').datagrid('getRowIndex',datas[i]);
		$('#setItmTable').datagrid('deleteRow',aindex);
		$('#allItmTable').datagrid('insertRow',{
			index:0,
			row:{
				FormDicID:datas[i].FormDicID,
				DicField:datas[i].DicField,
				DicDesc:datas[i].DicDesc
			}
		})
	}
}

function delAllItm(){
	$("#setItmTable").datagrid("checkAll");
	delItm();
}
function selAllItm(){
	$("#allItmTable").datagrid("checkAll");
}
function unSelAllItm(){
	$("#allItmTable").datagrid("uncheckAll");
}
//reload ���ϱ�
function reloadAllItmTable(value){
	$("#allItmTable").datagrid('load',{
		ForNameID:value
	})
}

function reloadSetFielTable(value){
	$("#setItmTable").datagrid('load',{
		ForNameID:value
	})
}
///ˢ�� field��fieldVal
function reloadTopTable(){
	reloadSetFielTable(formNameID);
	reloadAllItmTable(formNameID);
}
function ExportOK(){
	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var RepType=$('#typeevent').combobox('getText');  //��������
	var datas = $("#setItmTable").datagrid("getRows");
	if(datas.length<1){
		$.messager.alert("��ʾ","������Ϊ�գ�����ӵ����У�");
		return;	    
	}
	var fieldList = [],descList=[],tablefield=[],tabledesc=[];
	for(var i=0;i<datas.length;i++)
	{
		if (datas[i].DicField.indexOf("UlcerPart")>=0){
			tablefield.push(datas[i].DicField);
			tabledesc.push(datas[i].DicDesc);
		}else{
			fieldList.push(datas[i].DicField);
			descList.push(datas[i].DicDesc);
		}
	} 
	var TitleList=fieldList.join("#");
	var DescList=descList.join("#");
	var TabFieldList=tablefield.join("#");
	var TabDescList=tabledesc.join("#");
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ȡ��������</font>","error");
		return;
	}
  	var re=/[a-zA-Z]:\\/;     //wangxuejian 2016-10-10
	if ((filePath.match(re)=="")||(filePath.match(re)==null)){
		$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ѡ����Ч·����,���ԣ�</font>","error");
		return;
	}
	var Allflag=ExportData(StDate,EndDate,RepType,TitleList,DescList,filePath,TabFieldList,TabDescList);
	if(Allflag==true){
		$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>������ɣ�����Ŀ¼Ϊ:"+filePath+"</font>","info");
		$('#ExportWin').window('close');
	}else{
		$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>����ʧ�ܣ�</font>","info");
	} 
	
}
// ȫ������Excel 
function ExportAll()
{

	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var typeevent=$('#typeevent').combobox('getText');  //��������
	/* if((typeevent=="")||(typeevent=="ȫ��")){
		$.messager.alert("��ʾ:","��������Ϊ�գ���ѡ������","error");
		return;
	} */
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ȡ��������</font>","error");
		return;
	}
  	var re=/[a-zA-Z]:\\/;     
	if ((filePath.match(re)=="")||(filePath.match(re)==null)){
		$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ѡ����Ч·����,���ԣ�</font>","error");
		return;
	}
	var Allflag=ExportAllData(StDate,EndDate,typeevent,filePath);
	if(Allflag==true){
		$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>������ɣ�����Ŀ¼Ϊ:"+filePath+"</font>","info");
	}else{
		$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>����ʧ�ܣ�</font>","info");
	}
}
// ����Excel ���ܰ�
function ExportGather()
{

	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var typeevent=$('#typeevent').combobox('getText');  //��������
	/* if((typeevent=="")||(typeevent=="ȫ��")){
		$.messager.alert("��ʾ:","��������Ϊ�գ���ѡ������","error");
		return;
	} */
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ȡ��������</font>","error");
		return;
	}
  	var re=/[a-zA-Z]:\\/;     
	if ((filePath.match(re)=="")||(filePath.match(re)==null)){
		$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ѡ����Ч·����,���ԣ�</font>","error");
		return;
	}
	var Allflag=ExportGatherData(StDate,EndDate,typeevent,filePath);
	if(Allflag==true){
		$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>������ɣ�����Ŀ¼Ϊ:"+filePath+"</font>","info");
	}else{
		$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>����ʧ�ܣ�</font>","info");
	}
}
//����
function RepCancel()
{
	var NextLoc="";
	var LocAdvice="";
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	$.messager.confirm("��ʾ", "�Ƿ�������ϲ���", function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
			$.each(selItems, function(index, item){
				var RepID=item.RepID;         //��������ID
				var RepTypeCode=item.RepTypeCode;         //�������ʹ���
				var Medadrreceivedr=item.Medadrreceivedr;//����״̬dr
				var RepStausDr=item.RepStausDr //��ǰ״̬id
				var params=RepID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+NextLoc+"^"+LocAdvice+"^"+Medadrreceivedr+"^"+RepTypeCode+"^"+RepStausDr+"^"+"Y";   //������
				var num=$('#maindg').datagrid("getRowIndex",item); //2017-11-23  ��ȡindexֵ 
				var errnum=$('[datagrid-row-index="'+num+'"] .datagrid-cell-rownumber').text(); //2017-11-23 ��ȡ�к�
				
				runClassMethod("web.DHCADVCOMMONPART","MataRepCancel",{'params':params},
				function(jsonString){ 
					//var num=$('#maindg').datagrid("getRowIndex",item)+1; //2017-04-06  ��ȡ���� ������һ�в�������
					if(jsonString.ErrCode < 0){
						$.messager.alert("��ʾ:","���ϴ���,����ԭ��:"+"<font style='color:red;'>"+jsonString.ErrMsg+"</font>");  //+"��"+errnum+"������"
					}
				},"json",false);
				
			})
			$("#showalert").hide();
			$('#maindg').datagrid('reload'); //���¼���
			$('#maindg').datagrid('unselectAll') //2017-04-06 ���ȫѡ
		}
	})
}
//ɾ��
function RepDelete()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	var RepFileFlag=""; //�鵵״̬ 2018-01-23
	$.each(selItems, function(index, item){
		var FileFlag=item.FileFlag; //�鵵״̬ 2018-01-23
		if (FileFlag=="�ѹ鵵"){
			RepFileFlag="-1";
		}
	})
	if (RepFileFlag=="-1"){
		$.messager.alert("��ʾ:","��ѡ��������ѹ鵵���棬����ɾ����");
		return;
	}
	$.messager.confirm("��ʾ", "�Ƿ����ɾ������", function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
			$.each(selItems, function(index, item){
				var RepID=item.RepID;         //��������ID
				runClassMethod("web.DHCADVCOMMONPART","DelRepData",{'RepID':RepID},
				function(data){ 
					//var num=$('#maindg').datagrid("getRowIndex",item)+1; //2017-04-06  ��ȡ���� ������һ�в�������
					if(data< 0){
						$.messager.alert("��ʾ:","ɾ��ʧ�ܣ�");  //+"��"+errnum+"������"
					}
				},"",false);
				
			})
			$('#maindg').datagrid('reload'); //���¼���
			$('#maindg').datagrid('unselectAll') //2017-04-06 ���ȫѡ
		}
	})
}
