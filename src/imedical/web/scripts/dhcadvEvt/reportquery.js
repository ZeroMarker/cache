
/// Creator: congyue
/// CreateDate: 2017-07-28
/// Descript: �����¼����� ��ѯ����
var LgParam=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+LgHospID;
var url = "dhcadv.repaction.csp";
var statShare = [{ "val": "δ����", "text": "δ����" },{ "val": "����", "text": "����" }];
var statArray = [{ "val": "Y", "text": "���ύ" },{ "val": "N", "text": "δ�ύ" }];
var statReceive = [{ "val": "δ����", "text": "δ����" },{ "val": "1", "text": "����" },{ "val": "2", "text": "����" }];
var statOverTime = [{ "val": "Y", "text": "��ʱ" },{ "val": "N", "text": "δ��ʱ" }];
var condArray= [{ "val": "and", "text": "����" },{ "val": "or", "text": "����" }]; //�߼���ϵ
var stateBoxArray= [{ "val": "=", "text": "����" },{ "val": ">", "text": "����" },{ "val": ">=", "text": "���ڵ���" },{ "val": "<=", "text": "С�ڵ���" },{ "val": "<", "text": "С��" }]; //����
var formNameID="",StrParam="",querytitle="" ,cancelflag="",curCondRow=1; // ��id, ��ѯ������, ��ѯ����, ���ϱ�ʶ, �߼���ѯ���� ����
var StDate="";   //һ��ǰ������   2018-01-26 �޸ģ�Ĭ�Ͽ�ʼ����Ϊ����ʹ�����ڣ���2018-01-01
var EndDate=formatDate(0); //ϵͳ�ĵ�ǰ����
var ColSort="",ColOrder=""; // ������ , �����־:desc ����   asc ����
$(function(){ 
	InitPageComponent(); 	  /// ��ʼ������ؼ�����
	InitPageButton();         /// ���水ť����
	InitPageDataGrid();		  /// ��ʼ��ҳ��datagrid
	InitPageStyle();          /// ��ʼ��ҳ����ʽ	
});
/// ��ʼ������ؼ�����
function InitPageComponent(){
	if(DateFormat=="4"){ //���ڸ�ʽ 4:"DMY" DD/MM/YYYY
		StDate="01"+"/"+"01"+"/"+2018;  //���꿪ʼ����
	}else if(DateFormat=="3"){ //���ڸ�ʽ 3:"YMD" YYYY-MM-DD
		StDate=2018+"-"+"01"+"-"+"01";  //���꿪ʼ����
	}else if(DateFormat=="1"){ //���ڸ�ʽ 1:"MDY" MM/DD/YYYY
		StDate="01"+"/"+"01"+"/"+2018;  //���꿪ʼ����
	}
	//����
   $('#dept').combobox({ 
		mode:'remote',  //���������������
		onShowPanel:function(){ 
			$('#dept').combobox('reload',url+'?action=GetAllLocNewVersion&hospId='+LgHospID+'')
		}
	});
	
	//״̬
	$('#status').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		data:statArray
	});
	//��������
	$('#typeevent').combobox({
		url:url+'?action=SelEventbyNew&param='+LgGroupID+"^"+LgCtLocID+"^"+LgUserID,
		onSelect: function(rec){  
			if((rec.text=="��·���ѱ��浥")||(rec.text=="��ҩ���󱨸浥")||(rec.text=="����(׹��)�¼����浥")||(rec.text=="ѹ�����浥")){
	        	$('#Fish').show();
	        }else{
        		$('#Fish').hide();
	        }
		}
	});
	//����״̬
	$('#Share').combobox({
		panelHeight:"auto", 
		data:statShare
	});
	//����״̬
	$('#receive').combobox({
		panelHeight:"auto",
		data:statReceive
	});
	//��ʱ״̬
	$('#OverTime').combobox({
		panelHeight:"auto", 
		data:statOverTime
	});
	//�߼���ϵ
	$('#condCombox').combobox({
		panelHeight:"auto", 
		data:condArray
	});
	//��ҳ �����������
	StrParam=getParam("StrParam");
	querytitle=getParam("querytitle");
	querytitle=decodeURI(decodeURI(querytitle));
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
		$('#dept').combobox("setValue",LgCtLocID);     //����ID
		$("#dept").combobox('setText',LgCtLocDesc);
	}
	$('#querytitle').html("�����ۺϲ�ѯ"+querytitle);
}
/// ���水ť����
function InitPageButton(){
	$('#Refresh').bind("click",Query);  //ˢ��
	$('#Find').bind("click",Query);  //�����ѯ 
	$('#Printhtml').bind("click",htmlPrint);  //�����ӡ  Print ʹ��html��ӡ
	$('#Export').bind("click",Export);  //�������(��̬����)
	$('#ExportAll').bind("click",ExportAll);  //�������(ȫ�����͹̶�����)
	$('#ExportWord').bind("click",ExportWord);  //�������(word����)	
	$('#RepCancel').bind("click",RepCancel); //���� 
	$('#RepDelete').bind("click",RepDelete); //ɾ��
	$('#Fish').bind("click",fish); //���ͼ	
	$("#addCondBTN").on('click',addCondition); // �߼���ѯ��������
	$("#Print").bind("click",Print);		 //�����Ĵ�ӡ
}
/// ��ʼ��ҳ����ʽ
function InitPageStyle(){
	addCondition(); // �߼���ѯ��������
}

//����Ӧ hxy 2017-08-28
function resizeH(){
	$("#reqList").height($(window).height()-245)
	$("#maindg").datagrid('resize', { 
            height : $(window).height()-245
    }); 
}
//��ʼ��ҳ��datagrid
function InitPageDataGrid()
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
		{field:"RepStaus",title:'����״̬',hidden:false},
		{field:"RepStausDr",title:'����״̬Dr',width:100,hidden:true},
		{field:'Medadrreceive',title:'����״̬',width:100,hidden:true},
		{field:'Medadrreceivedr',title:'����״̬dr',width:80,hidden:true},
		{field:'RepDate',title:'��������',width:120,sortable:true},
		{field:'PatID',title:'�ǼǺ�',width:120,hidden:false},
		{field:'AdmNo',title:'������',width:120,formatter:setPatientRecord},
		{field:'PatName',title:'����',width:120},
		{field:'RepType',title:'��������',width:280},
		{field:'OccurDate',title:'��������',width:120},
		{field:'OccurLoc',title:'��������',width:150},
		{field:'LocDep',title:'����ϵͳ',width:150,hidden:true},
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
		{field:'AutOverTimeflag',title:'����ʱ',width:120,hidden:false},
		{field:'CaseShareLoclist',title:'�������',width:120,hidden:false},
		{field:'FileFlag',title:'�鵵״̬',width:80},
		{field:'AdmID',title:'����ID',width:80,hidden:true}
		
	]];

	//����datagrid
	$('#maindg').datagrid({
		toolbar: '#toolbar',//hxy add 08-28
		title:'', //hxy �����б�
		method:'get',
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryRepList'+'&StrParam='+StrParam+'&LgParam='+LgParam+'&ParStr='+"",
		fit:true,
		rownumbers:true,
		columns:columns,
		remoteSort:false,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		height:300,
		nowrap:true,
		rowStyler:function(index,row){    // yangyongtao 2017-11-22
	        /* if ((row.RepStaus).indexOf("����") >= 0){  
	            return 'background-color:red;';  
	        } */
	          
	        if ((row.StaFistAuditUser==LgUserName)||(row.BackAuditUser==LgUserName)){  
	            return 'background-color:red;';  
	        } 
    	},
        onSelect:function(rowIndex, rowData){
	        ButtonInfo();
        },
        onUnselect:function(rowIndex, rowData){ 
        	ButtonInfo();
		},
		onSortColumn:function (sort,order){
			ColSort=sort;
			ColOrder=order;
			Query();
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
	var ColParam=ColSort+"^"+ColOrder;
	$('#maindg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryRepList',	
		queryParams:{
			StrParam:StrParam,
			LgParam:LgParam,
			ParStr:getParStr(),
			ColParam:ColParam}
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
		var recordID=escape(rowData.recordID);         //����д��¼ID
		var RepID=escape(rowData.RepID);                //����ID   yangyongtao 2017-11-24
		var RepStaus=escape(rowData.RepStaus);         //��״̬
		if (RepStaus=="δ�ύ"){
			RepStaus=""; //����Ϊδ�ύ������Ϊ��
		}
		var RepTypeDr=escape(rowData.RepTypeDr);         //��������Dr
		var RepTypeCode=escape(rowData.RepTypeCode); //�������ʹ���
		var RepType=escape(rowData.RepType); //��������
		var StatusLast=escape(rowData.StatusLast); //������һ״̬
		var RepUser=rowData.RepUser; //������
		var Medadrreceivedr=escape(rowData.Medadrreceivedr); //����״̬dr
		var StaFistAuditUser=escape(rowData.StaFistAuditUser);  //��������
		var BackAuditUser=escape(rowData.BackAuditUser); //���ز�����
		var FileFlag=rowData.FileFlag;  			//�鵵��ʶ
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
		if(((RepStaus=="")&&((RepUser!="����")&&(RepUser!=LgUserName)))){///&&(Medadrreceivedr!=2)  //sufan 20200420 ��������ᵼ�²��ܱ����ύ
			editFlag=-1;
		}
		if((Medadrreceivedr==2)&&(StaFistAuditUser!=LgUserName)&&(BackAuditUser!=LgUserName)){
			editFlag=-1;
		}
		if(cancelflag=="Y"){
			editFlag=-1;
		}
		if((FileFlag!="δ�鵵")&&(FileFlag!="�����鵵")){
			editFlag=-1;
		}
		var adrReceive=escape(rowData.Medadrreceivedr); //����״̬dr
		RepUser=escape(RepUser); 
		FileFlag=escape(FileFlag);  			//�鵵��ʶ
		return "<a href='#' onclick=\"showEditWin('"+recordID+"','"+RepStaus+"','"+RepTypeDr+"','"+RepTypeCode+"','"+RepType+"','"+editFlag+"','"+RepID+"','"+adrReceive+"','"+RepUser+"','"+FileFlag+"')\"><img src='../scripts/dhcadvEvt/images/adv_sel_8.png' border=0/></a>";
}

//�༭����
function showEditWin(recordID,RepStaus,RepTypeDr,RepTypeCode,RepType,editFlag,RepID,adrReceive,RepUser,FileFlag)
{
	if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="win"></div>');
	$('#win').window({
		title:'����༭',
		border:false,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		closed:"true",
		width:screen.availWidth-100,    ///2017-11-23  cy  �޸ĵ��������С 1250  ��Ŀ1550
		height:screen.availHeight-100
	});
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.layoutform.csp?recordId='+recordID+'&RepStaus='+RepStaus+'&RepTypeDr='+RepTypeDr+'&code='+RepTypeCode+'&desc='+RepType+'&editFlag='+editFlag+'&RepID='+RepID+'&adrReceive='+adrReceive+'&winflag='+1+'&RepUser='+RepUser+'&FileFlag='+FileFlag+'"></iframe>'; 
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
		border:false,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		closed:"true",
		width:1110,
		height:500
	});
	
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.onlinereview.csp?ID='+RepID+'&TypeCode='+RepTypeCode+'"></iframe>';
		$('#winonline').html(iframe);
		$('#winonline').window('open');
	
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
/*// ����word ����ί
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
}*/
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
	}/*else{
		$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>����ʧ�ܣ�</font>","info");
	}*/
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
	}/*else{
		$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>����ʧ�ܣ�</font>","info");
	}*/
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
		border:false,
		collapsible:false,
		minimizable:false,
		maximizable:false,
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
	var filePath="";
	ExportData(StDate,EndDate,RepType,TitleList,DescList,filePath,TabFieldList,TabDescList);
	//var filePath=browseFolder();
	//if (typeof filePath=="undefined"){
	//	$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ȡ��������</font>","error");
	//	return;
	//}
  	//var re=/[a-zA-Z]:\\/;     //wangxuejian 2016-10-10
	//if ((filePath.match(re)=="")||(filePath.match(re)==null)){
	//	$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ѡ����Ч·����,���ԣ�</font>","error");
	//	return;
	//}
	//var Allflag=ExportData(StDate,EndDate,RepType,TitleList,DescList,filePath,TabFieldList,TabDescList);
	//if(Allflag==true){
	//	$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>������ɣ�����Ŀ¼Ϊ:"+filePath+"</font>","info");
	//	$('#ExportWin').window('close');
	//}else{
	//	$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>����ʧ�ܣ�</font>","info");
	//} 
	
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
	ExportAllData(StDate,EndDate,typeevent);
	//var filePath=browseFolder();
	//if (typeof filePath=="undefined"){
	//	$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ȡ��������</font>","error");
	//	return;
	//}
  	//var re=/[a-zA-Z]:\\/;     
	//if ((filePath.match(re)=="")||(filePath.match(re)==null)){
	//	$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ѡ����Ч·����,���ԣ�</font>","error");
	//	return;
	//}
	//var Allflag=ExportAllData(StDate,EndDate,typeevent,filePath);
	//if(Allflag==true){
	//	$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>������ɣ�����Ŀ¼Ϊ:"+filePath+"</font>","info");
	//}else{
	//	$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>����ʧ�ܣ�</font>","info");
	//
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
	}/*else{
		$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>����ʧ�ܣ�</font>","info");
	}*/
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
	var RepFileFlag=""; //�鵵״̬ 2018-01-23
	$.each(selItems, function(index, item){
		var FileFlag=item.FileFlag; //�鵵״̬ 2018-01-23
		if (FileFlag=="�ѹ鵵"){
			RepFileFlag="-1";
		}
	})
	if (RepFileFlag=="-1"){
		$.messager.alert("��ʾ:","��ѡ��������ѹ鵵���棬�������ϣ�");
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
//���ͼ cy 2018-08-03
function fish(){
	var selItems = $('#maindg').datagrid('getSelections');
	/*if (selItems.length>1){
		$.messager.alert("��ʾ:","��ѡ��һ�����ݣ�");
		return;
	}*/
	var RepID="",RepTypeCode=""
	if(selItems.length==1){
		RepID=selItems[0].RepID;//����ID
		RepTypeCode=selItems[0].RepTypeCode;//�������ʹ���/������Code
	}
	var RepType=$('#typeevent').combobox('getValue');  //��������
	if (((RepTypeCode=="")||(RepTypeCode==undefined))&&((RepType=="")||(RepType==undefined))){
		$.messager.alert("��ʾ:","��ѡ��һ�����ݻ���ѡ������������ԣ�");
		return;
	}
	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	
	var StrParam=StDate+"^"+EndDate+"^"+RepTypeCode+"^"+RepType
	if($('#fishwin').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="fishwin"></div>');
	$('#fishwin').window({
		title:'���ͼ',
		border:false,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		closed:"true",
		width:1200,
		height:620
	});
	
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.fishbone.csp?RepID='+RepID+'&StrParam='+StrParam+'"></iframe>';
	$('#fishwin').html(iframe);
	$('#fishwin').window('open');
}
//����  ����
function setPatientRecord(value, rowData, rowIndex)
{   
	var RepID=rowData.RepID;         //����ID
	var RepTypeCode=rowData.RepTypeCode; //�������ʹ���
	var Adm=rowData.AdmID
	var PatNo=rowData.AdmNo  //����״̬
	html = "<a href='#' onclick=\"LoadPatientRecord('"+rowData.PatID+"','"+Adm+"')\">"+PatNo+"</a>";
    return html;
   // return "<a href='#' mce_href='#' onclick='LoadPatientRecord("+rowData.PatID+","+Adm+");'>"+PatNo+"</a>";  
    
}
/// �����鿴
function LoadPatientRecord(PatID,Adm){
	//createPatInfoWin(Adm,PatID);
	
	if($('#winlode').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="winlode"></div>');
	$('#winlode').window({
		title:'��������б�',
		border:false,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		closed:"true",
		width:document.body.offsetWidth-100,
		height:document.body.offsetHeight-100
	});
	var frm=window.parent.document.forms["fEPRMENU"];
	if(frm.EpisodeID){
		frm.EpisodeID.value=Adm;
	}
	//var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="websys.chartbook.hisui.csp?ChartBookName='+"DHC.inpatient.Doctor.DHCEMRbrowse"+"&PatientListPage="+ "inpatientlist.csp"+"&EpisodeID="+Adm+'"></iframe>';
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="websys.chartbook.hisui.csp?ChartBookName='+"DHC.Doctor.DHCEMRbrowse"+"&PatientListPage="+ "emr.browse.patientlist.csp"+"&SwitchSysPat=N"+"&EpisodeID="+Adm+'"></iframe>';
	$('#winlode').html(iframe);
	$('#winlode').window('open'); 
}
window.onbeforeunload = onbeforeunload_handler;
/// ҳ��ر�֮ǰ����
function onbeforeunload_handler() {
    var frm=window.parent.document.forms["fEPRMENU"];
	if(frm.EpisodeID){
		frm.EpisodeID.value="";
	}
}
//html��ӡ
function htmlPrint(){

	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	if (selItems.length>1){
		$.messager.alert("��ʾ:","��ѡ��һ�����ݣ�");
		return;
	}
	var RepID=selItems[0].RepID;//����ID
	var RepTypeCode=selItems[0].RepTypeCode;//�������ʹ���/������Code
	var recordID=selItems[0].recordID;//����¼IDrecordID
	var url="dhcadv.htmlprint.csp?RepID="+RepID+"&RepTypeCode="+RepTypeCode+"&recordID="+recordID+"&prtOrExp="+this.id
	//return;
	window.open(url,"_blank");
}
//�жϵ�¼���Ƿ��в�����ť��Ȩ�������ư�ť��ʾ������
function ButtonInfo(){
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$('#RepDelete').hide();
		$('#RepCancel').hide();
		$('#Fish').hide();
		return;
	}
	var DeleteOperSec="",CancelOperSec="",FishOperSec="";
	$.each(selItems, function(index, item){
		var RepTypeCode=item.RepTypeCode; //�������ʹ���
		if((RepTypeCode=="advPipeOff")||(RepTypeCode=="advDrugUseErr")||(RepTypeCode=="advFallDownFill")||(RepTypeCode=="advSkinUlcer")){
        	FishOperSec="Y";
        }
		var OperSecparams=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+RepTypeCode;
		runClassMethod("web.DHCADVCOMMON","GetOperSecAll",{'params':OperSecparams},
		function(data){
			var tmp=data.split("^"); 
	        //ɾ��Ȩ��
			if((tmp[4]=="Y")&&(DeleteOperSec!="N")){
				DeleteOperSec="Y";
	        }else{
		        DeleteOperSec="N";
		    }
	        //����Ȩ��
			if((tmp[5]=="Y")&&(CancelOperSec!="N")){
				CancelOperSec="Y";
	        }else{
		        CancelOperSec="N";
		    }
		   
		},"text",false);
		
	})
    //ɾ��Ȩ��
    if(DeleteOperSec=="N"){
		$('#RepDelete').hide();
    }else{
		$('#RepDelete').show();
    }
    //����Ȩ��
    if(CancelOperSec=="N"){
		$('#RepCancel').hide();
    }else{
		$('#RepCancel').show();
    }
    //���ͼȨ��
	if(FishOperSec=="Y"){
		$('#Fish').show();
    }else{
		$('#Fish').hide();
    }
}

/////////////////////////////////////�߼���ѯ����////////////////////////////////////////
// ������
function addCondition(){
	
	curCondRow=curCondRow+1;
	var html=""
	html+='<tr id="'+curCondRow+'Tr"><td><b style="padding-left:30px">��ѯ����</b>';
	html+=getLookUpHtml(curCondRow,1);
	html+=getSelectHtml(curCondRow,1);
	html+='<span style="padding-left:20px;"><input class="dhcc-input" id="QueCond"'+curCondRow+"-"+1+' style="width:120"/></span>';
	html+='</td><td style="padding-left:60px"><b style="padding-left:30px">��ѯ����</b>';
	html+=getLookUpHtml(curCondRow,2);
	html+=getSelectHtml(curCondRow,2);
	html+='<span style="padding-left:20px;"><input class="dhcc-input" id="QueCond"'+curCondRow+"-"+2+' style="width:120"/></span>';
	html+='</td><td style="padding-left:20px"><span style="cursor: pointer" onclick="addCondition()"><span  class="icon icon-add" >&nbsp;&nbsp;&nbsp;&nbsp;</span>������</span></td>>';
	if(curCondRow>2){
		html+='</td><td style="padding-left:20px"><span style="cursor: pointer" onclick="removeCond('+curCondRow+')"><span  class="icon icon-remove" >&nbsp;&nbsp;&nbsp;&nbsp;</span>ɾ����</span></td></tr>';
	}
	$("#condTable").append(html);
	//����
	$("input[id^=stateBox"+curCondRow+"-]").combobox({
		panelHeight:"auto", 
		data:stateBoxArray
	});
	// ��ѯ������
	$("input[id^=LookUp"+curCondRow+"-]").combobox({
		data:GetFrozeData()
	});
	setHeight();
}
// ɾ����
function removeCond(row){
	$("#"+row+"Tr").remove();
	setHeight();
}
function setHeight(){
    var tableHeight=$('#condTable')[0].offsetHeight
    var divHeight=tableHeight+150;
    var centertop=divHeight+50;
    var maindgHeight=$(window).height()-divHeight-120;
    if(maindgHeight<400){
	    maindgHeight='auto';
	}
    $('#northdiv').css({
        height:divHeight+'px'
    });
    $('#nourthlayot').panel('resize', {
        height:'auto'
    });
    $('#centerlayout').panel('resize', {
        top:centertop+'px',
        height:'auto'
    });
    $("#reqList").css({
	    height:maindgHeight
	})
	$("#maindg").datagrid('resize', {           
        height:maindgHeight
    }); 

}
// �������
function getSelectHtml(row,column){
	var key=row+"-"+column;
	var html='<span style="padding-left:20px;">';
	html+='<input  id="stateBox'+key+'" style="width:80;" class="easyui-combobox" data-options="valueField:\'val\',textField:\'text\'"/>'
	html+='</span>'
	return html;
}
// ��ѯ���� ��������
function getLookUpHtml(row,column){
	var html="";
	var key=row+"-"+column;
	html+='<span class="lookup" style="padding-left:20px;">'
	//html+='		<input data-id="" class="textbox lookup-text validatebox-text"  style="width: 118px; height: 28px; line-height: 28px;" id="'+key+'" onkeypress="return onKeyPress(event,this)" data-key='+key+' type="text" >'
	//html+='		<span class="lookup-arrow" style="height: 28px;" onclick="showDic(this)" data-key='+key+'></span>'
	html+='<input id="LookUp'+key+'" style="width:120" class="easyui-combobox" data-options="valueField:\'val\',textField:\'text\'"/>'	
	html+='</span>'
	return html;
}
// ����¼�
function toggleExecInfo(obj){
	if($(obj).hasClass("expanded")){
		$(obj).removeClass("expanded");
		$(obj).html("�߼���ѯ");
		$("#condTable").hide();
		$("#dashline").hide();
		$("#condTd").hide();
		
	}else{
		$(obj).addClass("expanded");
		$(obj).html("����");
		$("#condTable").show();
		$("#dashline").show();
		$("#condTd").show();
	}
	setHeight();
}
// ��ȡ�����ʾ�У���Ϊ��ѯ�����������ݣ�
function GetFrozeData(){
	//��ȡ����δ����������
     var cols = $("#maindg").datagrid('getColumnFields');
     var array = [];
     for (var i=0;i<cols.length;i++) {     
         //��ȡÿһ�е���������
         var col = $("#maindg").datagrid("getColumnOption", cols[i]);
         //��������
         var obj = new Object();
         if((cols[i]!="ck")&&(cols[i]!="Edit")&&(col.hidden!=true)){
         	obj["val"] = cols[i];
         	obj["text"] = col.title.trim();
         	//׷�Ӷ���
         	array.push(obj);
         }
     }   
     return array;
}

// ��ȡ��ѯ�����ַ���
function getParStr(){
	var retArr=[];
	var cond=$("#condCombox").combobox('getValue');
	$("#condTable").find("td").each(function(index,obj){
		if($(obj).children().length<3){
			return true;
		}
		// ��������ֵ������ ���룩
		var column=$(obj).children().eq(1).find("input")[2];
		if(column!=undefined){
			column=column.value;
		}else{
			column="";
		}
		if(column==""){
			return true;	
		}
		// �ж����� ����ֵ�����ڣ�С�ڣ�
		var op=$(obj).children().eq(2).find("input")[2];
		if(op!=undefined){
			op=op.value;
		}else{
			op="";
		}
		// �����ж�ֵ ����������ݣ�
		var columnValue=$(obj).children().eq(3).find("input")[0].value;
		if(columnValue==""){
			return true;
		}

		// ��_$c(1)_ֵ_$c(1)_�ж�����_$c(1)_�߼���ϵ
		var par=column;
		par+=String.fromCharCode(1)+columnValue;
		par+=String.fromCharCode(1)+op;
		par+=String.fromCharCode(1)+cond;
		retArr.push(par);
	})
	return retArr.join("^");
}
/////////////////////////////////////������ӡ�뵼��////////////////////////////////////////
///�����Ĵ�ӡ
function Print()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	if (selItems.length>1){
		$.messager.alert("��ʾ:","��ѡ��һ�����ݣ�");
		return;
	}
	var RepID=selItems[0].RepID;//����ID
	var RepTypeCode=selItems[0].RepTypeCode;//�������ʹ���/������Code
	runClassMethod("web.DHCADVRepPrint","GetPrintData",{"AdvMasterDr":RepID,"PrintUserId":LgUserID,"LgHospID":LgHospID},function(ret){
		dhcprtPrint(RepTypeCode,ret,"print");
	},"json");
}
///����word��ʽ
function ExportWord()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	if (selItems.length>1){
		$.messager.alert("��ʾ:","��ѡ��һ�����ݣ�");
		return;
	}
	var RepID=selItems[0].RepID;//����ID
	var RepTypeCode=selItems[0].RepTypeCode;//�������ʹ���/������Code
	runClassMethod("web.DHCADVRepPrint","GetPrintData",{"AdvMasterDr":RepID,"PrintUserId":LgUserID,"LgHospID":LgHospID},function(ret){
		exportword(RepTypeCode,ret);
	},"json");
}

