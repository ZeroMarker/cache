
/// �°���ҩ������JS  bianshuai 2016-04-25
var LINK_CSP="dhcapp.broker.csp";
var url="dhcpha.clinical.action.csp";
var RowDelim=String.fromCharCode(1);  //�����ݼ�ķָ���
var PatientID="",EpisodeID="",mrRepID="",editRow="",mrstatus="";

/// ҳ���ʼ������
function initPageDefault(){
	
	mrRepID=getParam("mrRepID");
	EpisodeID=getParam("EpisodeID");
	mrstatus=getParam("mrstatus");    //liyarong 2016-0923
	initCombobox();  ///  ҳ��Combobox��ʼ����
	initDataGrid();  ///  ҳ��DataGrid��ʼ����
	initBlButton();  ///  ҳ��Button ���¼�
	initCheckBoxEvent();     /// ��ʼ��ҳ��CheckBox�¼�
	
		
	if (mrRepID != ""){
		LoadDrugMisRep(mrRepID); /// ���ر�����Ϣ
		if(mrstatus=="�ύ"){           //liyarong 2016-0923
		 $("a:contains('�ύ')").linkbutton('disable');
	     $("a:contains('����')").linkbutton('disable');
		 	}
	}else{
		initPatInfo();           /// ���ز��˻�����Ϣ
	}
        $("#mrRepDept").combobox('setValue',LgCtLocDesc);   //hzg 2018-7-2
}

/// ҳ��Combobox��ʼ����
function initCombobox(){
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCSTPHCMCOMMON&MethodName=";

	///  �Ա�
	var url = uniturl+"jsonCTSex";
	new ListCombobox("mrPatSex",url,'',{panelHeight:"auto"}).init();
	
	///  ְ��
	var url = uniturl+"jsonCarPrvTp";
	new ListCombobox("mrProTit",url,'').init();
	
	///  ����
	var url = uniturl+"jsonGetEmPatLoc";
	new ListCombobox("mrRepDept",url,'').init();
	$('#mrRepDept').combobox({
		mode:'remote',
		onShowPanel:function(){ //qunianpeng 2017/8/14 ֧��ƴ����ͺ���
			$('#mrRepDept').combobox('reload','dhcpha.clinical.action.csp'+'?action=GetAllLocNewVersion&hospId='+LgHospID+'')
		}
		//onLoadSuccess:function(){
			//$("#mrRepDept").combobox('setValue',LgCtLocID); 
		//}
	}); 
	//$("#mrRepDept").combobox('setValue',LgCtLocID); 
	//$("#mrRepDept").combobox('setText',LgCtLocDesc);
	
	///  ������
	var url = uniturl+"jsonGetSSUser";
	new ListCombobox("mrRepUser",url,'').init();
	$("#mrRepUser").combobox('setValue',LgUserID);
	
	/// ��������
	$('#mrErrOccDate').datebox("setValue",formatDate(-2));
	
	/// ��������
	$('#mrDisErrDate').datebox("setValue",formatDate(-2));
	
	/// ��������
	$('#mrRepDate').datebox("setValue",formatDate(0));
}

/// ҳ��DataGrid��ʼ����
function initDataGrid(){
	
	///  ����columns
	var columns=[[
		{field:"orditm",title:'ҽ��ID',width:90,hidden:true},
		{field:"phcdf",title:'ҩѧ��ID',width:90,hidden:true},
	    {field:'incidesc',title:'��Ʒ����',width:200,editor:texteditor},
	    {field:'genenic',title:'ͨ����',width:200,editor:texteditor},
	    {field:'genenicdr',title:'genenicdr',width:80,hidden:true},
	    {field:'manf',title:'����',width:100,editor:texteditor},
	    {field:'manfdr',title:'manfdr',width:80,hidden:true},
	    {field:'form',title:'����',width:100,align:'left',editor:texteditor},
	    {field:'formdr',title:'formdr',width:80,hidden:true},
	    {field:'instru',title:'�÷�',width:100,editor:texteditor},
		{field:'instrudr',title:'instrudr',width:80,hidden:true},
		{field:'dosage',title:'����',width:100,editor:texteditor},
		{field:'dosuomdr',title:'��λID',width:60,hidden:true},
		{field:'freq',title:'Ƶ��',width:100,hidden:true},
		{field:'freqdr',title:'Ƶ��ID',width:60,hidden:true},
		{field:'operation',title:'<a href="#" onclick="createPatOrdWin()"><img style="margin-left:3px;margin-top:6px;" src="../scripts/dhcpha/jQuery/themes/icons/edit_add.png" border=0/></a>',width:30,align:'center',
			formatter:SetCellUrl}
	]];
	
	///  ����datagrid
	var option = {
		title:"ҩƷ�б�",
		fit:false,
		columns:columns,
	    singleSelect:true,
	    rownumbers:true,
	    remoteSort:false,
		pagination: false
	};

	var uniturl = "";
	new ListComponent('mrPatOrdItmList', columns, uniturl, option).Init();
	
	///  ��ʼ��Datagrid����
	InitListComponentRow();
}

//��ʼ���б�ʹ��
function InitListComponentRow(){
	
	for(var k=0;k<4;k++){
		$("#mrPatOrdItmList").datagrid('insertRow',{index: 0, row: {orditm:''}});
	}
}

/// ����
function SetCellUrl(value, rowData, rowIndex){	
	return "<a href='#' onclick='deleteRow("+rowIndex+")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";
}

/// ɾ����
function deleteRow(rowIndex){
	
	//�ж���
    var rowobj={
		orditm:'', incidesc:'', genenic:'', manf:'', form:'', instru:'', dosage:''
	};

	//��ǰ��������4,��ɾ�����������
	var rows = $("#mrPatOrdItmList").datagrid('getRows');

	if(rows.length > 4){
		 $("#mrPatOrdItmList").datagrid('deleteRow',rowIndex);
	}else{
		$("#mrPatOrdItmList").datagrid('updateRow',{
			index: rowIndex, // ������
			row: rowobj
		});
	}
	
	// ɾ����,��������
	$("#mrPatOrdItmList").datagrid('sort', {	        
		sortName: 'incidesc',
		sortOrder: 'desc'
	});
}

/// ҳ�� Button ���¼�
function initBlButton(){
	
	
	///  ���
	$('a:contains("���")').bind("click",addMisRepDrug);
	
	///  ȡ��
	$('a:contains("ȡ��")').bind("click",cancelPatOrdWin);
}

/// ��ʼ��ҳ��CheckBox�¼�
function initCheckBoxEvent(){

	$("input[type=checkbox]").live('click',function(){
		///  �������
		if (this.name == "mrErrContent") {
			return;
		}
		///  ������������
		if (this.name == "ErrTriFac") {
			return;
		}
		///  ֢״
		if (this.name == "EmSymFeild") {
			$(this).parent().remove();
			return;
		}
		$("input[name="+this.name+"]:not([value="+this.value+"])").each(function(){
			$(this).removeAttr("checked");
			setCheckBoxRelation(this.id);    //wangxuejian 2016-08-29
		})
		setCheckBoxRelation(this.id);         //wangxuejian 2016-08-29
	});
}

/// ���ز�����Ϣ
function initPatInfo(){

	runClassMethod("web.DHCSTPHCMDrugMisUseQuery","GetPatInfo",{"EpisodeID":EpisodeID,"PatientID":PatientID},function(jsonString){

		if (jsonString != null){
			var rowData = jsonString;
			setRegPanelInfo(rowData);
		}
	},'json',false)
}

/// ���õǼ��������
function setRegPanelInfo(rowData){
	
	PatientID = rowData.PatientID;
	$("#PatientID").val(rowData.PatientID);    /// ����ID
	$("#mrPatName").val(rowData.PatName);      /// ����
	$("#mrPatDOB").datebox("setValue",rowData.birthday);     /// ��������
	$("#mrPatAge").val(rowData.PatAge);        /// ����
	$("#mrPatSex").combobox("setValue",rowData.sexId);       /// �Ա�
	$("#mrPatWeight").val(rowData.PatWeight);  /// ����
	$("#mrPatContact").val(rowData.PatTelH);   /// ��ϵ��ʽ
	$("#mrPatNo").val(rowData.PatNo);          /// �ǼǺ�
	$("#mrPatDiag").val(rowData.PatDiag);      /// ���
}

/// ������ҩҽ������
function createPatOrdWin(){

	$('#mrPatWin').window({
		title:'��ҩҽ���б�',
		collapsible:true,
		border:false,
		closed:"true",
		width:1000,
		height:400,
		minimizable:false,					/// ������С����ť
		maximized:true						/// ���(qunianpeng 2018/5/2)
	}); 

	$('#mrPatWin').window('open');
	initPatOrdList(); /// ��ҩҽ���б�
}

/// ��ҩҽ���б�
function initPatOrdList(){
	
	//����columns
	var columns=[[
		{field:"select",checkbox:true,width:20},
		{field:"orditm",title:'orditm',width:90,hidden:true},
		{field:'phcdf',title:'phcdf',width:80,hidden:true},
		{field:'priorty',title:'���ȼ�',width:40},
		{field:'StartDate',title:'��ʼ����',width:80}, //���ڴ��� duwensheng 2016-09-13
		{field:'EndDate',title:'��������',width:80},
		{field:'incidesc',title:'����',width:200},
		{field:'genenic',title:'ͨ����',width:160},
		{field:'genenicdr',title:'genenicdr',width:80,hidden:true},
		{field:'dosage',title:'����',width:60},
		{field:'dosuomID',title:'dosuomID',width:80,hidden:true},
		{field:'instru',title:'�÷�',width:80},
		{field:'instrudr',title:'instrudr',width:80,hidden:true},
		{field:'manf',title:'����',width:80},
		{field:'manfdr',title:'manfdr',width:80,hidden:true},
		{field:'form',title:'����',width:80},
		{field:'formdr',title:'formdr',width:80,hidden:true},
		{field:'freq',title:'Ƶ��',width:80},
		{field:'freqdr',title:'freqdr',width:80,hidden:true}
		
	]];

	//����datagrid  //2016-09-05 qunianpeng
	$('#medInfo').datagrid({
		url:'',
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
	    pageNumber:1,
		pageSize:15,  // ÿҳ��ʾ�ļ�¼����
		pageList:[15,30,45],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true
	});
	
	$('#medInfo').datagrid({
		url:url+'?action=GetPatOEInfo',	
		queryParams:{
			params:EpisodeID}
	});
   $('#medInfo').datagrid('loadData', {total:0,rows:[]});
}

///  ���ҩƷ���������
function addMisRepDrug(){
	
	/// ��ҩҽ���б�
	var rows = $('#mrPatOrdItmList').datagrid('getRows');
	for(var i=0;i<rows.length;i++){
		if(rows[i].orditm == ""){
			break;
		}
	}

	var checkedItems = $('#medInfo').datagrid('getChecked');
	if(checkedItems==""){
		 $.messager.alert("��ʾ:","����ѡ��ҩƷ��");
		 return;
		}
	var ItemFlag="";
    $.each(checkedItems, function(index, item){
	    var rowobj={
			orditm:item.orditm, phcdf:item.phcdf, incidesc:item.incidesc, genenic:item.genenic, genenicdr:item.genenicdr, manf:item.manf,
			manfdr:item.manfdr, formdr:item.formdr, form:item.form, dosage:item.dosage, instru:item.instru, instrudr:item.instrudr, 
			dosuomdr:item.dosuomID, freq:item.freq, freqdr:item.freqdr
		}

		//�б������������Ѵ��ڣ�������ʾ���ٹرմ���
		for(var j=0;j<rows.length;j++){
			if(item.incidesc==rows[j].incidesc){
				ItemFlag=1;
				alert("ҩƷ�б��Ѵ���'"+rows[j].genenic+"',������ѡ��!");
				return;
			}
		}
		if(ItemFlag!=1){
	    if((i>3)||(rows.length<=i)){
			$("#mrPatOrdItmList").datagrid('appendRow',rowobj);
		}else{
			$("#mrPatOrdItmList").datagrid('updateRow',{	//��ָ����������ݣ�appendRow�������һ���������
				index: i, // ������0��ʼ����
				row: rowobj
			});
		}}
		i=i+1;		
    })
	 if(ItemFlag!=1){
    $.messager.alert("��ʾ:","��ӳɹ���");
    cancelPatOrdWin();
     }
}

///  �رղ����б���
function cancelPatOrdWin(){

	$('#mrPatWin').window('close');
	
}
function saveBeforeCheck(){  //2016-09-29
	var mrDspToPat = "";
	if ($("input[name='mrDspToPat']:checked").length){
		mrDspToPat = $("input[name='mrDspToPat']:checked").val();     /// �Ƿ񷢸�����
	}
	if(mrDspToPat==""){
		$.messager.alert("��ʾ:","������ҩƷ�Ƿ񷢸����ߡ�����Ϊ�գ�");
		return false;
	}
	
	var mrErrorLevel = "";  
	if ($("input[name='mrErrorLevel']:checked").length){
		mrErrorLevel = $("input[name='mrErrorLevel']:checked").val(); /// ����ּ�
	}
	if(mrErrorLevel==""){
		$.messager.alert("��ʾ:","������ּ�������Ϊ�գ�");
		return false;
	}
	
	/// �˺����(����/�˺�)
	var HarmRet = "";HarmRetDesc = "";
	if ($('input[name="HarmRet"]:checked').length){
		HarmRet = $('input[name="HarmRet"]:checked').val();
	}
	if(HarmRet==""){
	   $.messager.alert("��ʾ:","�������˺����������Ϊ�գ�");
		return false;
	}
	
	/// ��������
	var ErrHappSite = "";ErrHappSiteDesc = "";
	if ($('input[name="ErrHappSite"]:checked').length){
		ErrHappSite = $('input[name="ErrHappSite"]:checked').val();
	}
	if(ErrHappSite==""){
		$.messager.alert("��ʾ:","����������ĳ���������Ϊ�գ�");
		return false;
	}
	
	/// ���������Ա
	var TriErrUser = "";TriErrUserDesc = "";
	if ($('input[name="TriErrUser"]:checked').length){
		TriErrUser = $('input[name="TriErrUser"]:checked').val();
	}
	 if(TriErrUser==""){
		$.messager.alert("��ʾ:","������������Ա������Ϊ�գ�");
		return false;
	}
	
	/// �������
	var ErrContent = [];
	$('input[name="mrErrContent"]:checked').each(function(){
		ErrContent.push(this.value);
	})
	ErrContent = ErrContent.join("||");
	if(ErrContent==""){
		$.messager.alert("��ʾ:","��������ݡ�����Ϊ�գ�");
		return false;
	}
	
	/// �������������
	var ErrTriFac = [];
	$('input[name="ErrTriFac"]:checked').each(function(){
		ErrTriFac.push(this.value);
	})
	ErrTriFac = ErrTriFac.join("||");
	if(ErrTriFac==""){
		$.messager.alert("��ʾ:","��������������ء�����Ϊ�գ�");
		return false;
	}
	
	/// ҩƷ�б�
	var mrItemList = [];
	var mrPatOrdItems = $("#mrPatOrdItmList").datagrid('getRows');
	$.each(mrPatOrdItems, function(index, item){
		if(item.orditm!=""){
		 	var ItemList = item.orditm +"^"+ item.phcdf +"^"+ item.incidesc +"^"+ item.genenicdr +"^"+ item.formdr +"^"+ item.dosage +"^"+ item.dosuomdr +"^"+ item.instrudr
		 	    +"^"+ item.freqdr +"^"+ item.manfdr;
		  	mrItemList.push(ItemList);
		 }
	})
	mrItemList = mrItemList.join("!!");
	if(mrItemList==""){
		$.messager.alert("��ʾ:","��ҩƷ�б�����Ϊ�գ�");
		return false;
	}
	return true ;
	}
/// ���汨������
function saveMisRep(flag){
		if((flag)&&(!saveBeforeCheck())){   //liyarong 2016-09-29
		return;
	}
	
	var mrRepDate = $("#mrRepDate").datebox("getValue");        /// ��������
	var mrErrOccDate = $("#mrErrOccDate").datebox("getValue");  /// ��������
	var mrDisErrDate = $("#mrDisErrDate").datebox("getValue");  /// ��������
	var mrDspToPat = "";
	if ($("input[name='mrDspToPat']:checked").length){
		mrDspToPat = $("input[name='mrDspToPat']:checked").val();     /// �Ƿ񷢸�����
	}
	
	var mrPatTaked = "";
	if ($("input[name='mrPatTaked']:checked").length){
		mrPatTaked = $("input[name='mrPatTaked']:checked").val();     /// �����Ƿ�ʹ��
	}
	
	var mrErrorLevel = "";  
	if ($("input[name='mrErrorLevel']:checked").length){
		mrErrorLevel = $("input[name='mrErrorLevel']:checked").val(); /// ����ּ�
	}

	var mrPatName = $("#mrPatName").val();				 /// ��������
	var mrPatSex = $("#mrPatSex").combobox("getValue");  /// �Ա�
	var mrPatAge = $("#mrPatAge").val();   				 /// ����
	var mrPatDOB = $("#mrPatDOB").datebox("getValue");   /// ��������
	var mrPatWeight = $("#mrPatWeight").val();           /// ����
	var mrPatContact = $("#mrPatContact").val();         /// ��ϵ��ʽ
	var mrPatNo = $("#mrPatNo").val();  				 /// סԺ��/��������
	
	var mrPatDiag = $("#mrPatDiag").val();			     /// �������
	
	/// �˺����(����/�˺�)
	var HarmRet = "";HarmRetDesc = "";
	if ($('input[name="HarmRet"]:checked').length){
		HarmRet = $('input[name="HarmRet"]:checked').val();
	}
	if (HarmRet>10){
		HarmRetDesc=$('#HarmRetDesc'+HarmRet).val();
	}
	
	var mrDeathDate="";mrDeathTime="";
	var DeathTime = $("#DeathTime").datetimebox('getValue');
	if (DeathTime != ""){ 
		mrDeathDate = DeathTime.split(" ")[0];  /// ��������
		mrDeathTime = DeathTime.split(" ")[1];  /// ����ʱ��
	}
	
	/// ���ȴ�ʩ����
	var mrRescue = "N";
	if ($("#CriticallyIll:checked").length){
		mrRescue = "Y";
	}
	var mrResMeasDesc = $("#mrResMeasDesc").val();
	
	/// �ָ�����
	var mrRecProc = "";
	if ($('input[name="mrRecProc"]:checked').length){
		mrRecProc = $('input[name="mrRecProc"]:checked').val();
	}
	
	var mrRepUser = $("#mrRepUser").combobox("getValue");     /// ������
	var mrRepDept = $("#mrRepDept").combobox("getValue");     /// �����˿���
	var mrProTit = $("#mrProTit").combobox("getValue");       /// ְ��
	var mrRepTel = $("#mrRepTel").val();       /// �绰
	var mrEmail = $("#mrEmail").val();         /// E-mail
	var mrPostCode = $("#mrPostCode").val();   /// �ʱ�
	
	/// ��������
	var ErrHappSite = "";ErrHappSiteDesc = "";
	if ($('input[name="ErrHappSite"]:checked').length){
		ErrHappSite = $('input[name="ErrHappSite"]:checked').val();
	}
	if (ErrHappSite == "99"){
		ErrHappSiteDesc = $("#ErrHappSiteDesc").val();
	}
	
	
	/// ���������Ա
	var TriErrUser = "";TriErrUserDesc = "";
	if ($('input[name="TriErrUser"]:checked').length){
		TriErrUser = $('input[name="TriErrUser"]:checked').val();
	}
	if (TriErrUser == "99"){
		TriErrUserDesc = $("#TriErrUserDesc").val();
	}
	/// ���ִ�����Ա
	var DisErrUser = "";DisErrUserDesc = "";
	if ($('input[name="DisErrUser"]:checked').length){
		DisErrUser = $('input[name="DisErrUser"]:checked').val();
	}
	if (DisErrUser == "99"){
		DisErrUserDesc = $("#DisErrUserDesc").val();
	}
	
	/// ���������Ա
	var ErrRelUser = "";ErrRelUserDesc = "";
	if ($('input[name="ErrRelUser"]:checked').length){
		ErrRelUser = $('input[name="ErrRelUser"]:checked').val();
	}
	if (ErrRelUser == "99"){
		ErrRelUserDesc = $("#ErrRelUserDesc").val();
	}
	
	/// ����ķ��ֺͱ����ʩ
	var mrDisAndHandMea = $("#mrDisAndHandMea").val();
	if (mrDisAndHandMea == "������¼����������֡������������ʩ��"){
		mrDisAndHandMea = "";
	}
	
	/// �Ƿ��ṩҩƷ�������
	var mrProDrgRelInfo = "";mrDrgRelInfoDesc = "";
	if ($('input[name="mrProDrgRelInfo"]:checked').length){
		mrProDrgRelInfo = $('input[name="mrProDrgRelInfo"]:checked').val();
	}
	if (mrProDrgRelInfo == "99"){
		mrDrgRelInfoDesc = $("#mrDrgRelInfoDesc").val();
		//$('#mrDrgRelInfoDesc').attr("disabled",false);
	}
	
	/// �������
	var ErrContent = [];
	$('input[name="mrErrContent"]:checked').each(function(){
		ErrContent.push(this.value);
	})
	var ErrContentDesc = $("#mrErrContentDesc").val();
	if (ErrContentDesc != ""){
		ErrContent.push("99"+"#"+ErrContentDesc);
	}
	ErrContent = ErrContent.join("||");
	
	
	/// �������������
	var ErrTriFac = [];
	$('input[name="ErrTriFac"]:checked').each(function(){
		ErrTriFac.push(this.value);
	})
	var ErrTriFacDesc = $("#ErrTriFacDesc").val();
	if (ErrTriFacDesc != ""){
		ErrTriFac.push("99"+"#"+ErrTriFacDesc);
	}
	ErrTriFac = ErrTriFac.join("||");
	

	/// ��������^��������^��������^�Ƿ񷢸�����^�����Ƿ�ʹ��^����ּ�^����^�Ա�^����^��������^����^��ϵ��ʽ^�ǼǺ�^���^�˺����
	/// �˺��������^��������^����ʱ��^����^����(��ʩ)^�ָ�����^������^�������^ְ��^�绰^E-mail^�ʱ�^��������ĳ���^��������ĳ�������
	/// ���������Ա^���������Ա����^���ִ�����Ա^���ִ�����Ա����^���������Ա^���������Ա����^�����������ʩ^�Ƿ��ṩҩƷ�������^�Ƿ��ṩҩƷ�����������^��������^�������������
	var mrListData = mrRepDate +"^"+ mrErrOccDate +"^"+ mrDisErrDate +"^"+ mrDspToPat +"^"+ mrPatTaked +"^"+ mrErrorLevel +"^"+ PatientID +"^"+ mrPatName +"^"+ mrPatSex +"^"+ mrPatAge;
	    mrListData = mrListData +"^"+ mrPatDOB +"^"+ mrPatWeight +"^"+ mrPatContact +"^"+ mrPatNo +"^"+ mrPatDiag +"^"+ HarmRet +"^"+ HarmRetDesc +"^"+ mrDeathDate +"^"+ mrDeathTime;
	    mrListData = mrListData +"^"+ mrRescue +"^"+ mrResMeasDesc +"^"+ mrRecProc +"^"+ mrRepUser +"^"+ mrRepDept +"^"+ mrProTit +"^"+ mrRepTel +"^"+ mrEmail +"^"+ mrPostCode +"^"+ ErrHappSite +"^"+ ErrHappSiteDesc;
	    mrListData = mrListData +"^"+ TriErrUser +"^"+ TriErrUserDesc +"^"+ DisErrUser +"^"+ DisErrUserDesc +"^"+ ErrRelUser +"^"+ ErrRelUserDesc +"^"+ mrDisAndHandMea +"^"+ mrProDrgRelInfo +"^"+ mrDrgRelInfoDesc;
	    mrListData = mrListData +"^"+ ErrContent +"^"+ ErrTriFac;

	/// ҩƷ�б�
	var mrItemList = [];
	var mrPatOrdItems = $("#mrPatOrdItmList").datagrid('getRows');
	$.each(mrPatOrdItems, function(index, item){
		if(item.orditm!=""){
		 	var ItemList = item.orditm +"^"+ item.phcdf +"^"+ item.incidesc +"^"+ item.genenicdr +"^"+ item.formdr +"^"+ item.dosage +"^"+ item.dosuomdr +"^"+ item.instrudr
		 	    +"^"+ item.freqdr +"^"+ item.manfdr;
		  	mrItemList.push(ItemList);
		 }
	})
	mrItemList = mrItemList.join("!!");
	
		if(flag==1){		
		var curStatus="Y";
		var mrListData=mrListData+"^"+curStatus;
		}else if(flag==0){	
	    var curStatus="N";
	    var mrListData=mrListData+"^"+curStatus;    
		}
	
	/// ��������
	runClassMethod("web.DHCSTPHCMDrugMisUseReport","save",{"mrRepID":mrRepID,"mrListData":mrListData,"mrItemList":mrItemList},function(jsonString){
		var mrret = jsonString;
		if (mrret > 0){
			mrRepID = mrret;
			LoadDrugMisRep(mrRepID);   ///  ���ر�������
			if(flag==1){
				  $.messager.alert("��ʾ:","�ύ�ɹ���");	                 //liyarong 2016-10-09
				  $("a:contains('�ύ')").linkbutton('disable');
				  $("a:contains('����')").linkbutton('disable');
			}else if(flag==0){
				  $.messager.alert("��ʾ:","����ɹ���");
			  }
		    parent.Query(); 
		}else{
		    if(flag==1){
				  $.messager.alert("��ʾ:","�ύʧ�ܣ�"); 
			}else if(flag==0){
				  $.messager.alert("��ʾ:","����ʧ�ܣ�");  
			 }
		}
	})
}

///  ���ر�������
function LoadDrugMisRep(mrRepID){

	runClassMethod("web.DHCSTPHCMDrugMisUseQuery","GetMisRep",{"mrRepID":mrRepID},function(jsonString){

		if (jsonString != null){
			var mrRepObj = jsonString;
			
			$("#mrRepCode").val(mrRepObj.mrRepNo);        			       /// ����
			$("#mrRepDate").datebox("setValue",mrRepObj.mrRepDate);        /// ��������
			$("#mrErrOccDate").datebox("setValue",mrRepObj.mrRepOccDate);  /// ��������
			$("#mrDisErrDate").datebox("setValue",mrRepObj.mrRepDisDate);  /// ��������
			PatientID=mrRepObj.mrRepPatID;                                 ///����id  liyarong2016-10-8                      
			EpisodeID=mrRepObj.mrRepPatAdm;                                ///����id  liyarong2016-10-8
			$("#mrPatName").val(mrRepObj.mrRepPatName);				       /// ��������
			$("#mrPatSex").combobox("setValue",mrRepObj.mrRepPatSex);      /// �Ա�
			$("#mrPatAge").val(mrRepObj.mrRepPatAge);   				   /// ����
			$("#mrPatDOB").datebox("setValue",mrRepObj.mrRepPatDOB);       /// ��������
			$("#mrPatWeight").val(mrRepObj.mrRepPatWeight);                /// ����
			$("#mrPatContact").val(mrRepObj.mrRepPatContact);              /// ��ϵ��ʽ
			$("#mrPatNo").val(mrRepObj.mrRepPatMedNo);  				   /// סԺ��/��������
			$("#mrPatDiag").val(mrRepObj.mrRepPatICDDesc);			       /// �������
	
		    $("#mrRepUser").combobox("setValue",mrRepObj.mrRepUser);     /// ������
			$("#mrRepDept").combobox("setValue",mrRepObj.mrRepDept);     /// �����˿���
			$("#mrProTit").combobox("setValue",mrRepObj.mrRepProTitle);  /// ְ��
			$("#mrRepTel").val(mrRepObj.mrRepTel);           /// �绰
			$("#mrEmail").val(mrRepObj.mrRepEmail);          /// E-mail
			$("#mrPostCode").val(mrRepObj.mrRepPostCode);    /// �ʱ�

			$("#mrDisAndHandMea").val(mrRepObj.mrDisAndHandMea);  /// ����ķ��ֺͱ����ʩ
			
			/// ���ִ�����Ա
			$('input[name="DisErrUser"][value="'+ mrRepObj.mrRepDisErrUser +'"]').attr("checked",'checked');
			$("#DisErrUserDesc").val(mrRepObj.mrRepDisErrUserDesc);
	
			/// ���������Ա
			$('input[name="ErrRelUser"][value="'+ mrRepObj.mrRepErrRelUser +'"]').attr("checked",'checked');
			$("#ErrRelUserDesc").val(mrRepObj.mrRepErrRelUserDesc);
		
			/// ��������
			$('input[name="ErrHappSite"][value="'+ mrRepObj.mrRepHappSite +'"]').attr("checked",'checked');
			$("#ErrHappSiteDesc").val(mrRepObj.mrRepHappSiteDesc);

			/// ���������Ա
			$('input[name="TriErrUser"][value="'+ mrRepObj.mrRepTriErrUser +'"]').attr("checked",'checked');
			$("#TriErrUserDesc").val(mrRepObj.mrRepTriErrUserDesc);
			
			/// �Ƿ񷢸�����
			$('input[name="mrDspToPat"][value="'+ mrRepObj.mrRepDspToPat +'"]').attr("checked",'checked');
	
			/// �����Ƿ�ʹ��
			$('input[name="mrPatTaked"][value="'+ mrRepObj.mrRepPatTaked +'"]').attr("checked",'checked');
	
			/// ����ּ�
			$('input[name="mrErrorLevel"][value="'+ mrRepObj.mrRepLevel +'"]').attr("checked",'checked');
	
			/// �˺����(����/�˺�)
			$('input[name="HarmRet"][value="'+ mrRepObj.mrRepHarmRet +'"]').attr("checked",'checked');
			$('#HarmRetDesc'+mrRepObj.mrRepHarmRet).val(mrRepObj.mrRepHarmRetDesc);
			
			/// ��������
			if((mrRepObj.mrRepDeathDate=="")&&(mrRepObj.mrRepDeathTime=="")){
				     $("#DeathTime").datetimebox('setValue',"");
			}else{
				     $("#DeathTime").datetimebox('setValue',mrRepObj.mrRepDeathDate+" "+mrRepObj.mrRepDeathTime);	
		     	 }
	
			/// ���ȴ�ʩ����
			$('input[name="HarmRet"][value="'+ mrRepObj.mrRepRescue +'"]').attr("checked",'checked');
			$("#mrResMeasDesc").val(mrRepObj.mrRepResMeasDesc);
	
			/// �ָ�����
			$('input[name="mrRecProc"][value="'+ mrRepObj.mrRepRecProc +'"]').attr("checked",'checked');
			
			/// �Ƿ��ṩҩƷ�������
			$('input[name="mrProDrgRelInfo"][value="'+ mrRepObj.mrProDrgRelInfo +'"]').attr("checked",'checked');
			$("#mrDrgRelInfoDesc").val(mrRepObj.mrDrgRelInfoDesc);
			
			/// �������������
			var ErrTriFacArr = mrRepObj.mrRepTriErrFac.split("||");
			for (var i=0;i<ErrTriFacArr.length;i++){
				if (ErrTriFacArr[i].indexOf("#") == "-1"){
					$('input[name="ErrTriFac"][value="'+ ErrTriFacArr[i] +'"]').attr("checked",'checked');
				}else{
					 $("#ErrTriFacDesc").val(ErrTriFacArr[i].split("#")[1]);
				}
			}
			
			/// �������
			var mrRepErrConArr = mrRepObj.mrRepErrContent.split("||");
			for (var i=0;i<mrRepErrConArr.length;i++){
				if (mrRepErrConArr[i].indexOf("#") == "-1"){
					$('input[name="mrErrContent"][value="'+ mrRepErrConArr[i] +'"]').attr("checked",'checked');
				}else{
					 $("#mrErrContentDesc").val(mrRepErrConArr[i].split("#")[1]);
				}
			}
		}
	})
	
	/// ����ҩƷ�б�
	var uniturl = LINK_CSP+"?ClassName=web.DHCSTPHCMDrugMisUseQuery&MethodName=QueryMRDrugMisList";
	$("#mrPatOrdItmList").datagrid({ url:uniturl, queryParams:{ mrRepID:mrRepID}});
}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })

function setCheckBoxRelation(id){   //wangxuejian 2016-08-29
//	if($('#'+id).hasClass('cb_active')){
	if($('#'+id).is(':checked')){  
		///���߼�����
		if(id=="TriErrUser"){
			$('#TriErrUserDesc').attr("disabled",false);
		}		
		///�м�(��λ���̶�)
		if(id=="HL12"){
			$('#HarmRetDesc12').attr("disabled",false);
		}
		///��ʱ�˺�(��λ���̶�)
		if(id=="HL11"){
			$('#HarmRetDesc11').attr("disabled",false);
			//$('#adrrEventRDRDate').datebox({disabled:false});
		}
	    ///����(��ʩ)
		if(id=="CriticallyIll"){
			$('#mrResMeasDesc').attr("disabled",false);
		}    
		///����(ֱ������)
		if(id=="death"){
			$('#HarmRetDesc13').attr("disabled",false);
			$("#DeathTime").datetimebox({disabled:false});  //zhaowuqiang 2016-09-14
		}
		///�Ƿ��ܹ��ṩҩƷ��ǩ��</br>������ӡ��������
		if(id=="ER99"){
		   	$('#mrDrgRelInfoDesc').attr("disabled",false);
		}
		///�����������ص���Ա
		if(id=="ErrRelUser"){
			$('#ErrRelUserDesc').attr("disabled",false);
		}
		///���ִ������Ա
		if(id=="DisErrUser"){
			$('#DisErrUserDesc').attr("disabled",false);
		}
		///��������ĳ���
		if(id=="ErrHappSite"){
			$('#ErrHappSiteDesc').attr("disabled",false);
		}
	}else{
		///���߼�����
		if(id=="TriErrUser"){
			$('#TriErrUserDesc').val("");
			$('#TriErrUserDesc').attr("disabled","true");
		}
		///�м�(��λ���̶�)
		if(id=="HL12"){
			$('#HarmRetDesc12').val("");
			$('#HarmRetDesc12').attr("disabled","true");
		}	
		///��ʱ�˺�(��λ���̶�)
		if(id=="HL11"){
			$('#HarmRetDesc11').val("");
			$('#HarmRetDesc11').attr("disabled","true");
		}    
	    ///����(��ʩ)
		if(id=="CriticallyIll"){
			$('#mrResMeasDesc').val("");
			$('#mrResMeasDesc').attr("disabled","true");
		}
		///����(ֱ������)
		if(id=="death"){
			$('#HarmRetDesc13').val("");
			$('#HarmRetDesc13').attr("disabled","true");
			$("#DeathTime").datetimebox({disabled:true});  //zhaowuqiang 2016-09-14
		}
		///�Ƿ��ܹ��ṩҩƷ��ǩ��</br>������ӡ��������
		if(id=="ER99"){
			$('#mrDrgRelInfoDesc').val("");
			$('#mrDrgRelInfoDesc').attr("disabled","true");
		}
		///�����������ص���Ա
		if(id=="ErrRelUser"){
			$('#ErrRelUserDesc').val("");
			$('#ErrRelUserDesc').attr("disabled","true");
		}
		///���ִ������Ա
		if(id=="DisErrUser"){
			$('#DisErrUserDesc').val("");
			$('#DisErrUserDesc').attr("disabled","true");
		}
		///��������ĳ���
		if(id=="ErrHappSite"){
			$('#ErrHappSiteDesc').val("");
			$('#ErrHappSiteDesc').attr("disabled","true");
		}
	}
}