/**
 * ģ��:		ҩ��
 * ��ģ��:		ҽ����ά��
 * createdate:	2017-06-26
 * creator:		yunhaibao
 */
var LoadTimeArr=new Array();
LoadTimeArr["cmbGeneric"]=0;
LoadTimeArr["cmbPhcForm"]=0;
$(function(){
	try{
		if (urlActionType=="U"){
		}else{
			urlArcItmId="";
		}
		// ����¼������
		$("#txtArcMaxQty,#txtArcMaxCumDose,#txtArcMaxQtyPerDay,#txtArcNoOfCumDays,#txtLimitQty,#txtWarningUseQty,#txtWhoDDD,#txtDDD,#txtGranulesFact,#txtIvgttSpeed,#txtEqualQty,#txtEqualDefQty").keyup(function(){
			if (isNaN(this.value)){
				this.value=this.value.replace(/^\D*([1-9]\d*\.?\d{0,2})?.*$/,'$1')
			}
		});
		InitArcDict();
		InitArcDictByArc();
		InitContent();
		$("#btnSave").on("click",SaveContent);
	    $("#btnClear").on("click",ClearContent);
	    $("#btnClose").on("click",CloseContent);
		DHCSTEASYUI.Authorize();
		document.onkeypress = DHCSTEASYUI.BanBackspace;
		document.onkeydown = DHCSTEASYUI.BanBackspace;
		$("#tabsArc").tabs({
	        onSelect: function(title) {
	            if (title.indexOf("��Ч��λ") >= 0) {
					InitEqualUomGrid();
	            }else if (title.indexOf("���ƿ�����ҩ") >= 0){
					InitArcResDocGrid();
		        }else if (title.indexOf("ҽ�������") >= 0){
					InitArcAliasGrid();
		        }else if (title.indexOf("Ƥ��ҽ������") >= 0){
					InitArcSkinGrid();
		        }
	        }
	    });
		if (urlSaveAs=="Y"){
			urlArcItmId="";   
		}
	}catch(e){
		$.messager.alert("������ʾ",e.message,"error");
	}
});

function InitContent(){
	GetPhcArcItmValues();
}

function ClearContent(){
	$.messager.confirm('������ʾ', '��ȷ��������?', function(r){
		if (r){	
			$(".dhcst-win-content input").val("");
			$(".dhcst-win-content input[type=checkbox]").prop('checked',false);
		}
	});
}
function CloseContent(){
	$.messager.confirm('�ر���ʾ', '��ȷ�Ϲر���?', function(r){
		if (r){	
			parent.$('#maintainWin').window("close");
		}
	});
}

function SaveContent(){
	var arcList=GetSaveArcList();
	if (arcList==""){
		return;
	}
	var phcList=GetSavePhcList();
	if (phcList==""){
		return;
	}
	var saveRet=tkMakeServerCall("web.DHCST.DrugInfoMaintain","SavePhcArc",urlArcItmId,arcList,phcList);
	var saveArr=saveRet.split("^");
	if (saveArr[0]==0){
		$.messager.alert("�ɹ���ʾ","����ɹ�!","info");
		urlActionType="U";
		urlArcItmId=saveArr[1];
		if ((urlActionType=="U")&&(urlSaveAs!="Y")){
			InitContent();
		}else{
			var src="dhcst.easyui.arcitm.modify.csp?"+"actionType="+"U"+"&arcItmRowId="+urlArcItmId+"&phcGenericId="+urlPhcGenericId+"&saveAs=";
			parent.$("#ifrmMainTain").attr("src",src);
		}
		var winTitle=parent.$("#maintainWin").panel('options').title;
		winTitle=winTitle.replace('����','�޸�');
		winTitle=winTitle.replace('���','�޸�');
		parent.$("#maintainWin").panel({title:winTitle});
	}else{
		$.messager.alert("������ʾ",saveArr[1]+"!","error");
	}
}

/// ��Ч��λ�޸�
function EqualUomEdit(btnId){
	var modifyType=DHCSTEASYUI.GetModifyType(btnId);
	var dataSelected=$('#equalUomGrid').datagrid('getSelected');
	var eqRowId=dataSelected?dataSelected.eqRowId:"";
	if (urlArcItmId==""){
		$.messager.alert("��ʾ","���ȱ���ҽ������Ϣ!","warning");
		return;
	}
	if ((modifyType=="A")||(modifyType=="U")){
		var doseUom=$("#cmbEqualUom").dhcstcomboeu('getValue');	
		var doseQty=$("#txtEqualQty").val();
		var doseDefQty=$("#txtEqualDefQty").val();
		if (doseUom==""){
			$.messager.alert("��ʾ","��ѡ���Ч��λ!","warning");
			return;
		}
		if ((doseQty=="")||(doseQty<=0)){
			$.messager.alert("��ʾ","��¼����Ч�ĵ�Ч��λ����!","warning");
			return;
		}
		/*if ((doseDefQty=="")||(doseDefQty<=0)){
			$.messager.alert("��ʾ","��¼����Ч�ĵ�Ч��λĬ������!","warning");
			return;
		}*/
		if (modifyType=="A"){
			eqRowId="";
		}else{
			if (eqRowId==""){
				$.messager.alert("��ʾ","��ѡ���¼!","warning");
				return;
			}
		}
		var eqUomStr=eqRowId+"^"+doseUom+"^"+doseQty+"^"+doseDefQty;
		var saveRet=tkMakeServerCall("web.DHCST.PHCDRGMAST","SaveFormDoseEquiv","",eqUomStr,urlArcItmId);
		if (saveRet==0){
			$.messager.alert("��ʾ",((modifyType=="A")?"����":"�޸�")+"�ɹ�!","info");
			$("#equalUomGrid").datagrid('reload');
		}else{
			var saveArr=saveRet.toString().split("^");
			if ((saveArr[0]<0)&&(saveArr[1]||""!="")){
				$.messager.alert(((modifyType=="A")?"����":"�޸�")+"��ʾ",saveArr[1],"warning");			
			}else{
				$.messager.alert("������ʾ",((modifyType=="A")?"����":"�޸�")+"ʧ��,�������:"+saveRet+"!","error");
			}
		}
	
	}else if (modifyType=="D"){
		if (eqRowId==""){
			$.messager.alert("��ʾ","��ѡ���¼!","warning");
			return;
		}
		$.messager.confirm('ȷ����ʾ', '��Ч��λΪ��������,��ȷ��ɾ����?', function(r){
			if (r){
				var delRet=tkMakeServerCall("web.DHCST.PHCDRGMAST","DeleteFormDoseEquiv",eqRowId);
				if (delRet==0){
					$.messager.alert("�ɹ���ʾ","ɾ���ɹ�!","info");
					$("#equalUomGrid").datagrid('reload');
				}else{
					$.messager.alert("������ʾ","ɾ��ʧ��,�������:"+delRet+"!","error");
				}
			}
		});		
	}
}

/// �����޸�
function ArcAliasEdit(btnId){
	var modifyType=DHCSTEASYUI.GetModifyType(btnId);
	var dataSelected=$('#arcAliasGrid').datagrid('getSelected');
	var arcAliasId=dataSelected?dataSelected.arcAliasId:"";
	var aliasText=$("#txtArcAlias").val().trim();
	if ((modifyType=="A")||(modifyType=="U")){
		if (urlArcItmId==""){
			$.messager.alert("��ʾ","���ȱ���ҽ������Ϣ!","warning");
			return;
		}
		if (aliasText==""){
			$.messager.alert("��ʾ","��¼�����!","warning");
			return;
		}
		if (modifyType=="A"){
			arcAliasId="";
		}else{
			if (arcAliasId==""){
				$.messager.alert("��ʾ","��ѡ���¼!","warning");
				return;
			}
		}
		var aliasStr=arcAliasId+"^"+aliasText;
		var saveRet=tkMakeServerCall("web.DHCST.ARCALIAS","Save",urlArcItmId,aliasStr);
		if (saveRet==0){
			$.messager.alert("��ʾ",((modifyType=="A")?"����":"�޸�")+"�ɹ�!","info");
			$("#arcAliasGrid").datagrid('reload');
		}else{
			$.messager.alert("������ʾ",((modifyType=="A")?"����":"�޸�")+"ʧ��,�������:"+saveRet+"!","error");
		}
	}else if (modifyType=="D"){
		if (arcAliasId==""){
			$.messager.alert("��ʾ","��ѡ���¼!","warning");
			return;
		}
		var delRet=tkMakeServerCall("web.DHCST.ARCALIAS","Delete",arcAliasId);
		if (delRet==0){
			$.messager.alert("�ɹ���ʾ","ɾ���ɹ�!","info");
			$("#arcAliasGrid").datagrid('reload');
		}else{
			$.messager.alert("������ʾ","ɾ��ʧ��,�������:"+delRet+"!","error");
		}
	}
}

/// ���ƿ�����ҩ
function ResDocEdit(btnId){
	if (urlArcItmId==""){
		$.messager.alert("��ʾ","���ȱ���ҽ������Ϣ!","warning");
		return;
	}
	var modifyType=DHCSTEASYUI.GetModifyType(btnId);
	var dataSelected=$('#arcResDocGrid').datagrid('getSelected');
	var resDocId=dataSelected?dataSelected.resDocId:"";
	var resDocRelation=$("#cmbResDocRelation").dhcstcomboeu('getValue');
	var resDocType=$("#cmbResDocType").dhcstcomboeu('getValue');
	var resDocOperate=$("#cmbResDocOperate").dhcstcomboeu('getValue');
	var resDocPointer=$("#cmbResDocPointer").dhcstcomboeu('getValue');
	var resDocPinterDesc=$("#cmbResDocPointer").combobox('getText')||"";
	if (resDocPointer==resDocPinterDesc){
		resDocPointer="";
	}
	if ((modifyType=="A")||(modifyType=="U")){
		if (resDocRelation==""){
			$.messager.alert("��ʾ","��ѡ���ϵ!","warning");
			return;
		}
		if (resDocType==""){
			$.messager.alert("��ʾ","��ѡ������!","warning");
			return;
		}
		if (resDocOperate==""){
			$.messager.alert("��ʾ","��ѡ�����!","warning");
			return;
		}
		if (resDocPointer==""){
			$.messager.alert("��ʾ","��ѡ������!","warning");
			return;
		}
		if (modifyType=="A"){
			resDocId="";
		}else{
			if (resDocId==""){
				$.messager.alert("��ʾ","��ѡ���¼!","warning");
				return;
			}
		}
		var resDocStrStr=resDocId+"^"+resDocRelation+"^"+resDocType+"^"+resDocOperate+"^"+resDocPointer;
		var saveRet=tkMakeServerCall("web.DHCST.RestrictDoc","Save",urlArcItmId,resDocStrStr);
		var saveArr=saveRet.split("^");
		var saveVal=saveArr[0]||"";
		if (saveVal>=0){
			$.messager.alert("�ɹ���ʾ",((modifyType=="A")?"����":"�޸�")+"�ɹ�!","info");
			$("#arcResDocGrid").datagrid('reload');
		}else{
			var saveInfo=saveArr[1]||"";
			if (saveInfo!=""){
				$.messager.alert("��ʾ",saveInfo,"warning");
			}else{
				$.messager.alert("������ʾ",((modifyType=="A")?"����":"�޸�")+"ʧ��,�������:"+saveRet+"!","error");
			}
		}
	}else if (modifyType=="D"){
		if (resDocId==""){
			$.messager.alert("��ʾ","��ѡ���¼!","warning");
			return;
		}
		var delRet=tkMakeServerCall("web.DHCST.RestrictDoc","Delete",resDocId);
		if (delRet==0){
			$.messager.alert("�ɹ���ʾ","ɾ���ɹ�!","info");
			$("#arcResDocGrid").datagrid('reload');
		}else{
			$.messager.alert("������ʾ","ɾ��ʧ��,�������:"+delRet+"!","error");
		}
	}
}


/// Ƥ�Թ���ҽ��
function ArcSkinEdit(btnId){
	if (urlArcItmId==""){
		$.messager.alert("��ʾ","���ȱ���ҽ������Ϣ!","warning");
		return;
	}
	var modifyType=DHCSTEASYUI.GetModifyType(btnId);
	var dataSelected=$('#arcSkinGrid').datagrid('getSelected');
	var sktId=dataSelected?dataSelected.sktId:"";
	var arcItmId=$("#cmbArcItm").dhcstcomboeu('getValue');
	if ((modifyType=="A")){
		if (arcItmId==""){
			$.messager.alert("��ʾ","��ѡ��ҽ��������!","warning");
			return;
		}
		sktId="";
		var arcSkinStr="^^"+arcItmId
		var saveRet=tkMakeServerCall("web.DHCST.ARCITMMAST","SaveSktInfo",urlArcItmId,arcSkinStr);
		if (saveRet>=0){
			$.messager.alert("�ɹ���ʾ",((modifyType=="A")?"����":"�޸�")+"�ɹ�!","info");
			$("#cmbArcItm").combogrid("clear")
			$("#arcSkinGrid").datagrid('reload');
		}else{
			$.messager.alert("������ʾ",((modifyType=="A")?"����":"�޸�")+"ʧ��,�������:"+saveRet+"!","error");
		}
	}else if (modifyType=="D"){
		if (sktId==""){
			$.messager.alert("��ʾ","��ѡ���¼!","warning");
			return;
		}
		var delRet=tkMakeServerCall("web.DHCST.ARCITMMAST","DeleteSktInfo",sktId);
		if (delRet==0){
			$.messager.alert("�ɹ���ʾ","ɾ���ɹ�!","info");
			$("#arcSkinGrid").datagrid('reload');
		}else{
			$.messager.alert("������ʾ","ɾ��ʧ��,�������:"+delRet+"!","error");
		}
	}
}
 /// ����-��ȡҽ��������
function GetSaveArcList(){
	var saveArcCondition=[
		'txtArcCode',			// ����-1
		'txtArcDesc',			// ����-2
		'cmbBillUom',			// �Ƽ۵�λ-3
		'cmbArcCat',			// ҽ������-4
		'cmbArcBillGrp',		// ���ô���-5
		'cmbArcBillSub', 		// ��������-6
		'chkOrderOnItsOwn',		// ����ҽ��-7
		'cmbOECPriority',		// ҽ�����ȼ�-8
		'chkWoStock',			// �޿��-9
		'txtInsuDesc',			// ҽ������-10
		'txtArcAliasStr',		// ����-11
		'txtArcSX',				// ��д-12
		'cmbOfficialType',		// ҽ�����-13
		'txtArcMaxQty',			// �����-14
		'txtArcNoOfCumDays',	// ����ʹ������-15
		'txtArcMaxQtyPerDay',	// ÿ��������-16
		'txtArcMaxCumDose',		// ����������-17
		'chkRestrictEM',		// ������ҩ-18
		'chkRestrictIP',		// סԺ��ҩ-19
		'chkRestrictOP',		// ������ҩ-20
		'chkRestrictHP',		// �����ҩ-21
		'txtOeMessage',			// ҽ����ʾ-22
		'chkUpdateTar',			// �Ƿ�����շ���-23
		'chkUpdateInsu',		// �Ƿ����ҽ����-24
		'cmbTarSubCat',			// �ӷ���-25
		'cmbTarInCat',			// סԺ�ӷ���-26
		'cmbTarOutCat',			// �����ӷ���-27
		'cmbTarAcctCat',		// �����ӷ���-28
		'cmbTarMedCat',			// ������ҳ����-29
		'cmbTarAccSubCat',		// ����ӷ���-30
		'cmbTarNewMedCat',		// �²�������-31
		'dtArcEffDate',			// ��Ч����-32
		'dtArcEffDateTo',		// ҽ����ֹ����-33
		'LOGON.USERID',			// �����û�-34
		'txtLimitQty',			// ��������-35
		'txtWarningUseQty',		// ��������-36
		'chkFreeDrugFlag'		// ���ҩ-37
	];
	var saveArcList=[];
	var conLen=saveArcCondition.length;
	var tmpValue="",tmpTitle="";
	for (var i=0;i<conLen;i++){
		tmpTitle=saveArcCondition[i];
		tmpValue=GetValueById(tmpTitle);
		if (CheckRequied(tmpValue,tmpTitle)==false){
			return "";
		}
		saveArcList[i]=tmpValue
	}
	return saveArcList.join("^");
}
/// ����-��ȡҩѧ�
function GetSavePhcList(){
	var savePhcCondition=[
		'txtArcCode',			// ����-1
		'txtArcDesc',			// ����-2
		'cmbPhcForm',			// ����-3
		'cmbPhcBaseUom',		// ������λ-4
		'cmbPhcInstruc',		// �÷�-5
		'cmbPhcDuration',		// �Ƴ�-6
		'txtPhcBaseQty',		// ������λ����-7
		'cmbPhcManf',	    	// ����-8
		'cmbPhcPoison',			// ���Ʒ���-9
		'cmbPhcFreq',			// Ƶ��-10
		'cmbOfficialType',		// ҽ�����-11
		'cmbGeneric',			// ����ͨ����-12
		'cmbPhcCat',			// ҩѧһ������-13
		'cmbPhcSubCat',			// ҩѧ��������-14
		'cmbPhcMinCat',			// ҩѧ��������-15
		'txtPhcLabelName11',	// Ӣ�Ĺ��ʷ�ר��ҩ��-16
		'txtPhcLabelName12',	// ����ר��ҩ��-17
		'txtPhcLabelName1',		// ��Ʒ��-18
		'txtPhcZhJName',		// �Ƽ�ͨ����-19
		'txtPhcYLName',			// ԭ��ͨ����-20
		'chkIPOneDay',			// סԺһ����-21
		'chkOPOneDay',			// ����һ����(1\0)-22
		'chkOPSkin',			// ����Ƥ����ԭҺ(1\0)-23
		'chkIPSkin',			// סԺƤ����ԭҺ(1\0)-24
		'txtDDD',				// DDDֵ-25
		'LOGON.USERID',			// �����û�-26
		'chkPhcAnti',			// �����ر�־-27
		'chkPhcCritical',		// Σ��ҩ��־-28
		'txtPhcAgeLimit',		// ��������-��ͣ��-29
		//'dtPhcStartDate',		// ��ʼ����-
		'treePhcCat',			// �༶ҩѧ����-30
		'cmbWhoNetCode',		// WHONET��-31
		'cmbPhcSpec',			// ��ҩ��ע-32
		'txtWhoDDD',			// WhoDDDֵ-33
		'cmbWhoDDDUom',			// WhoDDD��λ-34
		'txtIvgttSpeed',		// ����-35
		'txtGranulesFact',		// ������λϵ��-36
		'chkProvinceComm',		// ʡ������ҩ��-37
		'cmbPhcPivaCat',		// ҩƷ��Һ����-38
		'cmbHighRisk',			// ��Σ����-39
		'chkPhcSingleUse',		// ��ζʹ�ñ�ʶ-40
		'chkAllergy',			// ����-41
		'chkDietTaboo',			// ��ʳ����-42
		'chkPhcTumble',			// ��������-43
		'chkDope',				// �˷ܼ�-44
		'chkBaseDrug',			// ���һ���ҩ��-45
		'chkProBaseDrug',		// ʡ����ҩ��-46
		'chkCityBaseDrug',		// �л���ҩ��-47
		'chkCouBaseDrug',		// ��(��)����ҩ��-48
		'cmbPhcOTC'	,			// �Ǵ���-OTC-49
		'chkCodeX',				// �й�ҩ��-50
		'chkPhcTest',			// �ٴ���֤��ҩ-51
		'chkTPN',				// TPN-52
		'chkCQZT',				// ����Ĭ������-53
		'chkONE',				// ��ʱĬ��ȡҩ-54
		'txtPhcSpec',			// �������-55
		'chkMonitorFlag',		// �ص���ҩƷ -56
		'chkOM'					// ����˵��Ĭ���Ա� -57
	];
	var chkArr01=['chkOPOneDay','chkOPSkin','chkIPSkin'];
	var savePhcList=[];
	var conLen=savePhcCondition.length;
	var tmpValue="";
	for (var i=0;i<conLen;i++){
		tmpTitle=savePhcCondition[i];
		if (tmpTitle=="txtPhcBaseQty"){
			tmpValue=1;
		}else if (tmpTitle=="cmbPhcSpec"){
			var tmpValue=$("#cmbPhcSpec").combobox("getValues");
		}else if (tmpTitle=="cmbGeneric"){
			var tmpValue=$("#cmbGeneric").combogrid("getValue");
		}else{
			tmpValue=GetValueById(tmpTitle);
			if (CheckRequied(tmpValue,tmpTitle)==false){
				return "";
			}
			if ($.inArray(tmpTitle, chkArr01)>=0){
				tmpValue=(tmpValue=="Y")?'1':'0';
			}
		}
		savePhcList[i]=tmpValue;
	}
	// ��֤��ϱ���
	var poisonDesc=$("#cmbPhcPoison").combobox("getText")||"";
	var ddd=savePhcList[24];
	var antiFlag=savePhcList[26];
	var whoNetCode=savePhcList[30];
	var whoDDD=savePhcList[32];
	var whoDDDUom=savePhcList[33];
	// ����ҩ��ѡʱ,����ѡ����Ʒ���
	if(antiFlag=="Y"){
		if (poisonDesc==""){
			$.messager.alert("��ʾ","����ҩ����ѡ����Ʒ���","info");
			return "";
		}
		if (poisonDesc.indexOf("����ҩ")<0){
			$.messager.alert("��ʾ","����ҩ�Ĺ��Ʒ������Ϊ����ҩ���һ��","info");
			return "";
		}
	}
	// ���Ʒ���Ϊ����ҩʱDDD��ֵ����
	if (poisonDesc.indexOf("����ҩ")>=0){
		if (antiFlag!="Y"){
			$.messager.alert("��ʾ","���Ʒ���Ϊ����ҩʱ����ά������ҩ��־","info");
			return "";	���Ʒ���Ϊ����ҩʱ��������DDD��ֵ	
		}
		if (ddd==""){
			$.messager.alert("��ʾ","���Ʒ���Ϊ����ҩʱ��������DDD��ֵ","info");
			return "";		
		}
		if (whoNetCode==""){
			$.messager.alert("��ʾ","���Ʒ���Ϊ����ҩʱ��������WHONET��ֵ","info");
			return "";		
		}	
	}
	if ((whoDDD!="")&&(whoDDDUom=="")){
		$.messager.alert("��ʾ","WHODDDֵ��Ϊ��,��λΪ��","info");
		return "";		
	}
	if ((whoDDD=="")&&(whoDDDUom!="")){
		$.messager.alert("��ʾ","WHODDD��λ��Ϊ��,ֵΪ��","info");
		return "";		
	}	
	return savePhcList.join("^");
}
/*************��ʼ����Ϣ********************/
function InitArcDict(){
	var options={
		ClassName:"web.DHCST.Util.DrugUtilQuery",
		QueryName:"",
		StrParams:""		
	}
	var secOptions=options;
	var tmpOptions={};
	/*********************************ҽ������Ϣ*******************************/
	/// ���ô���
	tmpOptions={
		QueryName:"GetArcBillGrp",
		onSelect:function(selData){   
			/// ����-��������
			secOptions.QueryName="GetArcBillSub";
			secOptions.StrParams=selData.RowId;
			$("#cmbArcBillSub").dhcstcomboeu(secOptions);	
		}  
    } 
	$("#cmbArcBillGrp").dhcstcomboeu($.extend({},options,tmpOptions));
	/// ��������
	tmpOptions={
		QueryName:"GetArcBillSub",
    }	
	$("#cmbArcBillSub").dhcstcomboeu($.extend({},options,tmpOptions));	 
	/// ҽ������
	tmpOptions={
		QueryName:"GetOrderCategory",
		onSelect:function(selData){   
			/// ����-ҽ������
			secOptions.QueryName="GetArcItemCat";
			secOptions.StrParams=selData.RowId;
			$("#cmbArcCat").dhcstcomboeu(secOptions);	
		}  
    } 
	$("#cmbOrdCategory").dhcstcomboeu($.extend({},options,tmpOptions));
	/// ҽ������
	tmpOptions={
		QueryName:"GetArcItemCat",
    }
	$("#cmbArcCat").dhcstcomboeu($.extend({},options,tmpOptions));
	/// ҽ�����ȼ�
	tmpOptions={
		QueryName:"GetOECPriority",
    }
    $("#cmbOECPriority").dhcstcomboeu($.extend({},options,tmpOptions));
	/// �Ƽ۵�λ
	/*
	tmpOptions={
		QueryName:"GetCTUom",
    }
    $("#cmbBillUom").dhcstcomboeu($.extend({},options,tmpOptions));
    */
    /*****************************ҩѧ��Ϣ*****************************/
    /// ������λ
	tmpOptions={
		QueryName:"GetCTUom",
    }
    $("#cmbPhcBaseUom").dhcstcomboeu($.extend({},options,tmpOptions));
    /// ����
	tmpOptions={
		QueryName:"GetPhcForm",
		onLoadSuccess:function(data) {
			// ��ʼ��
			LoadTimeArr["cmbPhcForm"]=LoadTimeArr["cmbPhcForm"]+1;
			if (LoadTimeArr["cmbPhcForm"]==1){
				if ((urlArcItmId=="")&&(urlPhcFormId!="")){
					$("#cmbPhcForm").combobox("setValue",urlPhcFormId);
				}
			}
		}
    }
    $("#cmbPhcForm").dhcstcomboeu($.extend({},options,tmpOptions));
    /// �÷�
 	tmpOptions={
		QueryName:"GetPHCInstruc",
    }
    $("#cmbPhcInstruc").dhcstcomboeu($.extend({},options,tmpOptions));   
    /// Ƶ��
 	tmpOptions={
		QueryName:"GetPHCFreq",
    }
    $("#cmbPhcFreq").dhcstcomboeu($.extend({},options,tmpOptions));  
    /// �Ƴ�
 	tmpOptions={
		QueryName:"GetPhcDuration",
    }
    $("#cmbPhcDuration").dhcstcomboeu($.extend({},options,tmpOptions));   
    /// ����
 	tmpOptions={
	 	ClassName:"web.DHCST.Util.OrgUtilQuery",
		QueryName:"GetPhManufacturer",
    }
    $("#cmbPhcManf").dhcstcomboeu($.extend({},options,tmpOptions)); 
    /// ҽ�����
 	tmpOptions={
		QueryName:"GetInsuCat",
    }
    $("#cmbOfficialType").dhcstcomboeu($.extend({},options,tmpOptions)); 
    /// ���Ʒ���
 	tmpOptions={
		QueryName:"GetPhcPoison",
    }
    $("#cmbPhcPoison").dhcstcomboeu($.extend({},options,tmpOptions)); 
    /// ��ҩ��ע
   	tmpOptions={
		QueryName:"GetPHCSpecInc",
		multiple:true
    }
    $("#cmbPhcSpec").dhcstcomboeu($.extend({},options,tmpOptions));   
    /// ��Σ����
    tmpOptions={
		QueryName:"GetHighRiskLevel",
    }
    $("#cmbHighRisk").dhcstcomboeu($.extend({},options,tmpOptions));  
    /// ҩƷ��Һ����
    tmpOptions={
		QueryName:"GetPHCPivaCat",
    }
    $("#cmbPhcPivaCat").dhcstcomboeu($.extend({},options,tmpOptions)); 
    /// ��Ч��λ
	tmpOptions={
		QueryName:"GetCTUom",
    }
    $("#cmbEqualUom").dhcstcomboeu($.extend({},options,tmpOptions));  
    /// OTC-�Ǵ�����ʶ
    tmpOptions={
		QueryName:"GetOfficeCode",
		StrParams:"Gpp"
    }
    $("#cmbPhcOTC").dhcstcomboeu($.extend({},options,tmpOptions));   
	
	/*********local ����**********/
	/// ��ϵ
    tmpOptions={
		data: [{RowId: 'AND',Description: '����'},{RowId: 'OR',Description: '����'}]
    };
    $("#cmbResDocRelation").dhcstcomboeu($.extend({},options,tmpOptions)); 
	/// ����
    tmpOptions={
		data: [
			{RowId:'KS',Description:'����',QueryName:'GetTypeLoc',strParams:'E'},
			{RowId:'ZC',Description:'ְ��',QueryName:'GetCarPrvTp',strParams:''},
			{RowId:'YS',Description:'ҽ��',QueryName:'GetLocUser',strParams:''},
			{RowId:'JB',Description:'���˼���',QueryName:'GetCtEMF',strParams:''}
		],
    	onSelect:function(selData){ 
			var resDocOptions={
				ClassName:"web.DHCST.RestrictDoc",
				QueryName:selData.QueryName,
				StrParams:selData.strParams,
				mode:"remote",
				enterNullValueClear: true,
				
				onBeforeLoad: function(param) {
					var origP=$(this).combobox("options").StrParams||"";
					var qP=param.q||""
					var origPArr=origP.split("^");
					origPArr[2]=qP;
					var newP=origPArr.join("^");
					param.q=newP;
		        }
			};
			$("#cmbResDocPointer").dhcstcomboeu(resDocOptions);
		} 
    };
    $("#cmbResDocType").dhcstcomboeu($.extend({},options,tmpOptions));  
	/// ����
    tmpOptions={
		data: [{RowId:'=',Description:'����'},{RowId:'<>',Description:'������'},{RowId:'>=',Description:'���ڵ���'}]
    };
    $("#cmbResDocOperate").dhcstcomboeu($.extend({},options,tmpOptions));  
    /// whonet��
    tmpOptions={
		QueryName:"GetWhonetInfo",
	    columns: [[
			{field:'antCode',title:'����',width:100,sortable:true},
			{field:'antName',title:'��������',width:100,sortable:true},
			{field:'antEName',title:'Ӣ������',width:100,sortable:true}
	    ]],
		idField:'antCode',
		textField:'antCode'
    }
    $("#cmbWhoNetCode").dhcstcombogrideu($.extend({},options,tmpOptions));
    /// ҽ��������
    tmpOptions={
	    ClassName:"web.DHCST.ARCITMMAST",
		QueryName:"GetArcItmMast",
	    columns: [[
			{field:'arcItmRowId',title:'arcItmRowId',width:100,sortable:true,hidden:true},
			{field:'arcItmCode',title:'ҽ�������',width:100,sortable:true},
			{field:'arcItmDesc',title:'ҽ��������',width:200,sortable:true}
	    ]],
		idField:'arcItmRowId',
		textField:'arcItmDesc'
    }
    $("#cmbArcItm").dhcstcombogrideu($.extend({},options,tmpOptions));
    $("#dtArcEffDate,#dtArcEffDateTo").datebox({});  
	// ����ͨ��������
	var tmpGenericId="";
	if (urlArcItmId==""){
		tmpGenericId=urlPhcGenericId;
	}
	tmpOptions={
		ClassName:"web.DHCST.Util.DrugUtilQuery",
		QueryName:"GetPhcGeneric",
		StrParams:"|@|"+tmpGenericId+"|@|"+urlArcItmId,
    	columns: [[
			{field:'RowId',title:'RowId',width:100,sortable:true,hidden:true},
			{field:'Description',title:'����ͨ��������',width:200,sortable:true}
	    ]],
		idField:'RowId',
		textField:'Description',
		mode:"remote",
		pageSize:30, 
		pageList:[30,50,100],  
		pagination:true,
		onLoadSuccess:function(data) {
			// ��ʼ��
			LoadTimeArr["cmbGeneric"]=LoadTimeArr["cmbGeneric"]+1;
			if (LoadTimeArr["cmbGeneric"]==1){
				if ((urlArcItmId=="")&&(tmpGenericId!="")){
					$("#cmbGeneric").combogrid("setValue",tmpGenericId);
				}
			}
		},
		onSelect:function(rowIndex,selData){
			var geneId=selData.RowId||"";
			if (geneId!=""){
				var formData=tkMakeServerCall("web.DHCST.Common.DrugInfoCommon","GetFormByGene",geneId);
				if (formData!=""){
					var formDataArr=formData.split("^");
					$("#cmbPhcForm").combobox("setValue",formDataArr[2]);
					$("#cmbPhcForm").combobox("setText",formDataArr[1]);
				}else{
					$("#cmbPhcForm").combobox("setValue","");
					$("#cmbPhcForm").combobox("setText","");		
				}
			}
		}
		
    };
	$("#cmbGeneric").dhcstcombogrideu(tmpOptions);
}

/// �����ҽ��id��ʼ���������б�
function InitArcDictByArc(){
	var options={
		ClassName:"web.DHCST.Util.DrugUtilQuery",
		QueryName:"",
		StrParams:""		
	}
	var tmpOptions={};
	tmpOptions={
		QueryName:"PHCDFWhoDDDUom",
		StrParams:urlArcItmId
    } 
	$("#cmbWhoDDDUom").dhcstcomboeu($.extend({},options,tmpOptions));
}
 /// ��ʼ����Ч����λ�б�
function InitEqualUomGrid(){
	var gridColumns=[[  
		{field:'eqRowId',title:'��Ч��λID',width:300,hidden:true}, 
		{field:'doseUomId',title:'��λID',width:300,hidden:true}, 
		{field:'doseUomDesc',title:'��Ч��λ',width:180,align:"center"},
		{field:'doseQty',title:'��Ч����',width:180,align:"right"},
		{field:'doseDefQty',title:'ȱʡ����',width:180,align:"right"}
	]];
	var options={
		ClassName:"web.DHCST.PHCDRGMAST",
		QueryName:"QueryFormDoseEquiv",
		columns:gridColumns,
		pagination:false,
		queryParams:{
			StrParams:urlArcItmId,
		},
		onClickRow:function(rowIndex,rowData){
			if (rowData){
				$("#cmbEqualUom").combobox('setValue',rowData.doseUomId)
				$("#txtEqualQty").val(rowData.doseQty);
				$("#txtEqualDefQty").val(rowData.doseDefQty);
			}
		}
		
	};
	$('#equalUomGrid').dhcstgrideu(options);  
}

/// ��ʼ�������б�
function InitArcAliasGrid(){
	var gridColumns=[[  
		{field:'arcAliasId',title:'������ID',width:300,hidden:true}, 
		{field:'arcAliasText',title:'ҽ�������',width:300,hidden:false}
	]];
	var options={
		ClassName:"web.DHCST.ARCALIAS",
		QueryName:"QueryByRowId",
		columns:gridColumns,
		pagination:false,
		queryParams:{
			StrParams:urlArcItmId,
		},
		onClickRow:function(rowIndex,rowData){
			if (rowData){
				$("#txtArcAlias").val(rowData.arcAliasText);
			}
		}
		
	};
	$('#arcAliasGrid').dhcstgrideu(options);  
}

/// ��ʼ�����ƿ�����ҩ
function InitArcResDocGrid(){
	var gridColumns=[[  
		{field:'resDocRelationDesc',title:'��ϵ',width:155,hidden:false,align:'center'},
		{field:'resDocTypeDesc',title:'����',width:145,hidden:false,align:'center'},
		{field:'resDocOperateDesc',title:'����',width:145,hidden:false,align:'center'},
		{field:'resDocPointerDesc',title:'����',width:242,hidden:false},
		{field:'resDocRelation',title:'��ϵID',width:300,hidden:true,align:'center'},
		{field:'resDocType',title:'����ID',width:300,hidden:true,align:'center'},
		{field:'resDocOperate',title:'����ID',width:300,hidden:true,align:'center'},
		{field:'resDocPointer',title:'����ID',width:300,hidden:true},
		{field:'resDocId',title:'���ƿ�����ҩID',width:300,hidden:true}
		
	]];
	var options={
		ClassName:"web.DHCST.RestrictDoc",
		QueryName:"GetRestrictDocInfo",
		columns:gridColumns,
		pagination:false,
		queryParams:{
			StrParams:urlArcItmId,
		},
		onClickRow:function(rowIndex,rowData){
			if (rowData){
				$("#cmbResDocRelation").combobox('select',rowData.resDocRelation);
				$("#cmbResDocType").combobox('select',rowData.resDocType);
				$("#cmbResDocOperate").combobox('select',rowData.resDocOperate);			
				$("#cmbResDocPointer").combobox('select',rowData.resDocPointer);
				//$("#cmbResDocPointer").combobox('setText',rowData.resDocPointerDesc);
			}
		}
	};
	$('#arcResDocGrid').dhcstgrideu(options);  
}

/// Ƥ�Թ����б�
function InitArcSkinGrid(){
	var gridColumns=[[  
		{field:'sktId',title:'������ID',width:155,hidden:true,align:'center'},
		{field:'arcItmId',title:'ҽ����ID',width:145,hidden:true,align:'center'},
		{field:'arcItmCode',title:'ҽ�������',width:100,hidden:false,align:'center'},
		{field:'arcItmDesc',title:'ҽ��������',width:300,hidden:false,align:'center'},
		
	]];
	var options={
		ClassName:"web.DHCST.ARCITMMAST",
		QueryName:"GetSktInfo",
		columns:gridColumns,
		pagination:false,
		queryParams:{
			StrParams:urlArcItmId,
		},
		onClickRow:function(rowIndex,rowData){
			if (rowData){
			}
		}
	};
	$('#arcSkinGrid').dhcstgrideu(options); 
}

/// ���пؼ����¸�ֵ
function GetPhcArcItmValues(){
	if (urlArcItmId!=""){
		$.ajax({
			type:"POST",
			data:"json",
			url:"DHCST.QUERY.JSON.csp?&Plugin=EasyUI.ComboBox"+
			"&ClassName=web.DHCST.ARCITMMAST"+
			"&QueryName=QueryArcByArcim"+
			"&StrParams="+urlArcItmId,
			error:function(){        
				alert("��ȡ����ʧ��!");
			},
			success:function(retData){
				SetPhcArcItmValues(retData)
			}
		})
		$.ajax({
			type:"POST",
			data:"json",
			url:"DHCST.QUERY.JSON.csp?&Plugin=EasyUI.ComboBox"+
			"&ClassName=web.DHCST.PHCDRGMAST"+
			"&QueryName=QueryPhcByArcim"+
			"&StrParams="+urlArcItmId,
			error:function(){        
				alert("��ȡ����ʧ��!");
			},
			success:function(retData){
				SetPhcArcItmValues(retData)
			}
		})	
	}
}
/// ҽ����ҩѧ�ֵ
function SetPhcArcItmValues(retData){
	var jsonData=JSON.parse(retData)[0];
	for (var jsonId in jsonData){
		if ($("#"+jsonId).html()==undefined){
			continue;
		}
		var jsonValue=jsonData[jsonId]||"";
		if (jsonId.substring(0, 3)=="txt"){
			$("#"+jsonId).val(jsonValue);
		}else if (jsonId.substring(0, 3)=="cmb"){
			if ((jsonId=="cmbWhoNetCode")||(jsonId=="cmbGeneric")){
				$("#"+jsonId).combogrid('setValue',jsonValue);
			}else if (jsonId=="cmbPhcSpec"){
				if (jsonValue==""){
					$("#"+jsonId).combobox('setValues',[]);
				}else{
					$("#"+jsonId).combobox('setValues',jsonValue.split(","));
				}
			}else{
				$("#"+jsonId).combobox('setValue',jsonValue);
			}
		}else if (jsonId.substring(0, 3)=="chk"){
			var tmpValue=((jsonValue=="Y")||(jsonValue=="1"))?true:false;
			$("#"+jsonId).prop('checked',tmpValue);
		}else if (jsonId.substring(0, 2)=="dt"){
			$("#"+jsonId).datebox('setValue',jsonValue);
		}
	}
	if (urlSaveAs=="Y"){
		$("#txtArcCode").val("");
		$("#txtArcDesc").val("");
	}
}
/// ����Idȡֵ
function GetValueById(id){
 	if (id.indexOf("LOGON")>=0){
		return session[id];
	}
	if (id.indexOf("url")>=0){
		return eval(id);
	}
	if ($("#"+id).html()==undefined){
		return "";
	}
	if (id=="cmbGeneric"){
		return $("#"+id).combogrid('getValue')||"";
	}
	if (id.substring(0, 3)=="txt"){
		return $("#"+id).val()||"";
	}else if (id.substring(0, 3)=="cmb"){
		return $("#"+id).combobox('getValue')||"";
	}else if (id.substring(0, 3)=="chk"){
		var tmpValue=$("#"+id).prop('checked')
		return tmpValue==true?"Y":"N";
	}else if (id.substring(0, 2)=="dt"){
		return $("#"+id).datebox('getValue')||"";
	}	
	return ""
}
/// ��֤�����Լ�����
function CheckRequied(value,id){
	var msgText="";
	if (value==""){
		switch(id){
			case "txtArcCode":
				msgText="ҽ�������Ϊ��";
			  	break;
			case "txtArcDesc":
				msgText="ҽ��������Ϊ��";
				break;
			case "cmbArcBillGrp":
				msgText="���ô���Ϊ��";
				break;
			case "cmbArcBillSub":
				msgText="��������Ϊ��";
				break;
			case "cmbOrdCategory":
				msgText="ҽ������Ϊ��";
				break;
			case "cmbArcCat":
				msgText="ҽ������Ϊ��";
				break;
			case "cmbOECPriority":
				msgText="ҽ�����ȼ�Ϊ��";
				break;
			case "cmbPhcBaseUom":
				msgText="ҩѧ������λ";
				break;
			case "cmbGeneric":
				msgText="����ͨ����";
				break;
			default:
				msgText="";
		}
		if (msgText!=""){
			$.messager.alert("��ʾ",msgText,"info");
			return false;
		}
	}
	return true;
}