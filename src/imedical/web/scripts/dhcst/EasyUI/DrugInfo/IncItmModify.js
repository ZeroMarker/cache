/**
 * ģ��:		ҩ��
 * ��ģ��:		�����ά��
 * createdate:	2017-07-03
 * creator:		yunhaibao
 */
var HASBEENUSED="";	// �Ƿ���ҵ��
$(function(){
	try{
		if (urlActionType=="U"){

		}else{
			urlIncItmId="";
		}
		// ����¼������
		$("#txtPbRp,#txtMaxSp,#txtSp,#txtRp,#txtPackPurFac").keyup(function(){
			if (isNaN(this.value)){
				this.value=this.value.replace(/^\D*([1-9]\d*\.?\d{0,2})?.*$/,'$1')
			}
		});
		InitIncDict();
		InitContent();
		$("#btnSave").on("click",SaveContent);
	    $("#btnClear").on("click",ClearContent);
		$("#btnClose").on("click",CloseContent);
		document.onkeypress = DHCSTEASYUI.BanBackspace;
		document.onkeydown = DHCSTEASYUI.BanBackspace;
		$("#tabsInc").tabs({
	        onSelect: function(title) {
	            if (title.indexOf("��λת��ά��") >= 0) {
		            if ($("#ifrmCTConFac").attr("src")==""){
						$("#ifrmCTConFac").attr("src","dhc.bdp.ext.default.csp?extfilename=App/Stock/CT_ConFac")
		            }
	            }else if (title.indexOf("��ҩ��λά��") >= 0){
		            $("#dtDispUomEdDate").datebox({});
		            $("#dtDispUomStDate").datebox({});
		        	InitDispUomGrid();
		        }else if (title.indexOf("��������") >= 0){
					InitIncAliasGrid();
		        }
	        }
	    });
	    if (urlSaveAs=="Y"){
			urlIncItmId="";   
		}
	}catch(e){
		$.messager.alert("������ʾ",e.message,"error");
		$.messager.progress('close');
	}
});

function InitContent(){
	GetIncItmValues();
	InitDetailReadOnly();
	return
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
	var incList=GetSaveIncList();
	if (incList==""){
		return;
	}
	incList=urlArcItmId+"^"+incList;
	var storeConList=GetSaveStoreConList();
	var tarList=GetSaveTarList();
	if (tarList==""){
		return;
	}
	var saveRet=tkMakeServerCall("web.DHCST.DrugInfoMaintain","SaveInc",urlIncItmId,incList,storeConList,tarList,session['LOGON.USERID']);
	var saveArr=saveRet.split("^");
	if (saveArr[0]==0){
		urlIncItmId=saveArr[1];
		$.messager.alert("�ɹ���ʾ","����ɹ�!","info");
		if ((urlActionType=="U")&&(urlSaveAs!="Y")){
			GetIncItmValues();
		}else{
			// �����޸�,�ɹ������¼���
			urlActionType="U";
			var src="dhcst.easyui.incitm.modify.csp?"+"actionType="+urlActionType+"&incItmRowId="+urlIncItmId+"&arcItmRowId="+urlArcItmId+"&saveAs=";
			parent.$("#ifrmMainTain").attr("src",src);
		}
		var winTitle=parent.$("#maintainWin").panel('options').title;
		winTitle=winTitle.replace('����','�޸�');
		winTitle=winTitle.replace('���','�޸�');
		parent.$("#maintainWin").panel({title:winTitle});
	}else{
		$.messager.alert("������ʾ",saveArr[1]!=undefined?saveArr[1]:saveRet+"!","error");
	}
}

 /// ����-��ȡ���������
function GetSaveIncList(){
	var saveIncCondition=[
		'txtIncCode',			// ����-1
		'txtIncDesc',			// ����-2
		'cmbIncBaseUom',		// ������λ-3
		'cmbIncPurchUom',		// ��ⵥλ-4
		'cmbStkCat',			// ������-5
		'cmbIncIsTrf',			// ת�Ʒ�ʽ-6
		'cmbBatchReq',			// Ҫ������-7
		'cmbExpReq',			// Ҫ��Ч��-8
		'txtIncAliasStr',		// ����-9
		'chkNotUse',			// ������-10
		'txtReportingDays',		// Э����-11
		'txtIncBarCode',		// ����-12
		'LOGON.USERID',			// �����û�-13
		'txtSp',				// �ۼ�-14
		'txtRp',				// ����-15
		'dtPriceExeDate',		// �۸���Ч����-16
		'txtIncSpec',			// ���-17
		'cmbInciImport',		// ���ڱ�־-18
		'cmbQualityLev',		// �������-19
		'cmbOTC',				// ����ҩ����-20
		'chkIncBaseDrug',		// ���һ���ҩ��-21
		'chkIncCodeX',			// �й�ҩ���־-22
		'chkIncTest',			// �ٴ���֤��ҩ-23
		'chkIncRec',			// ������ҩ��ʶ-24
		'txtQualityNo',			// �������-25
		'txtComeFrom',			// ��ʡ��-26
		'cmbIncRemark1-txtIncRemark2', // ��׼�ĺ�-27
		'chkHighPrice',			// ��ֵ���־-28
		'cmbMarkType',			// ��������-29
		'txtMaxSp',				// ����ۼ�-30
		'txtStoreConId',		// �洢����	-31
		'chkIncInHosp',			// ��ԺҩƷĿ¼-32
		'chkIncPb',				// �б��־-33
		'txtPbRp',				// �б����-34
		'cmbPbLevel',			// �б꼶��-35
		'cmbPbVendor',			// �б깩Ӧ��-36
		'cmbPbManf',			// �б곧��-37
		'cmbPbCarrier',			// �б�������-38
		'cmbPbName',			// �б�����-39
		'chkBAFlag',			// ����ɹ�-40
		'txtExpLen',			// Ч�ڳ���-41
		'txtPrcFile',			// ����ļ���-42
		'dtPrcFileDate',		// ��۱�������-43
		'chkSkin',				// Ƥ��-44
		'cmbBookCat',			// �ʲ�����-45
		'txtUserOrderInfo',     // ��ҩ˵��-46
		'chkIncProBaseDrug',	// ʡ����ҩ��-47
		'chkIncCityBaseDrug',	// �л���ҩ��-48	
		'chkIncCouBaseDrug',	// ���ػ���ҩ��-49	
		'txtIncBaseCode',		// ��λ��-50
		'txtInDrugInfo',		// ��ҩ����-51
		'cmbIncPackUom',		// ���װ��λ-52
		'txtPackPurFac',		// ���װϵ��-53
		'chkHighRisk',			// ��Σ��־-54
		'cmbNotUseReason',		// ������ԭ��-55
		'cmbIncInsu',			// ҽ�����-56
		'LOGON.CTLOCID',		// ��¼����-57
		'LOGON.GROUPID',		// ��¼��ȫ��-58
		'cmbRefReturn',			// ������ҩԭ��-59
		'cmbIncOutBaseUom',		// ���﷢ҩ��λ-60
		'cmbIncInBaseUom',		// סԺ��ҩ��λ-61
		'dtOrdEndDate'			// ҽ����ֹ����-62
	];
	var saveIncList=[];
	var conLen=saveIncCondition.length;
	var tmpValue="",tmpTitle="";
	for (var i=0;i<conLen;i++){
		tmpTitle=saveIncCondition[i];
		var tmpTitleArr=tmpTitle.split("-");
		var tmpTitleLen=tmpTitleArr.length;	
		if (tmpTitleLen==1){
			tmpValue=GetValueById(tmpTitle);
			if (CheckRequied(tmpValue,tmpTitle)==false){
				return "";
			}
		}else{
			tmpValue="";
			for (var j=0;j<tmpTitleLen;j++){
				var tmpJValue=GetValueById(tmpTitleArr[j]);
				if (CheckRequied(tmpJValue,tmpTitleArr[j])==false){
					return "";
				}
				tmpValue=(j==0)?tmpJValue:tmpValue+"-"+tmpJValue;
			}
		}
		saveIncList[i]=tmpValue
	}
	return saveIncList.join("^");
}

 /// ����-��ȡ�����洢��������
function GetSaveStoreConList(){
	var saveStoreConCondition=[
		'chkRoomTemp',		// ����-1
		'chkDry',			// ����-2
		'chkAirtight',		// �ܱ�-3
		'chkDark',			// �ܹ�-4
		'chkVentilation',	// ͨ��-5
		'chkRadiation',		// ������-6
		'chkMeltSeal',		// �۷�-7
		'chkCool',			// ����-8
		'chkColdDark',		// ����-9
		'chkSeal', 			// �ܷ�-10
		'chkRefrigeration', // ���-11
		'txtMinTemp',		// �����-12
		'txtMaxTemp',  		// �����-13
		'txtMinHumi',		// ���ʪ��-14
		'txtMaxHumi'		// ���ʪ��-15
		
	];
	var saveStoreConList=[];
	var conLen=saveStoreConCondition.length;
	var tmpValue="",tmpTitle="";
	for (var i=0;i<conLen;i++){
		tmpTitle=saveStoreConCondition[i];
		tmpValue=GetValueById(tmpTitle)
		saveStoreConList[i]=tmpValue
	}
	return saveStoreConList.join("^");
}

 /// ����-��ȡ�շ�������
function GetSaveTarList(){
	var saveTarCondition=[
		'cmbTarSubCat',		// �ӷ���
		'cmbTarInCat',		// סԺ�ӷ���
		'cmbTarOutCat',		// �����ӷ���
		'cmbTarAcctCat',	// �����ӷ���
		'cmbTarMedCat',		// ������ҳ����
		'cmbTarAccSubCat',	// ����ӷ���
		'cmbTarNewMedCat'	// �²�����ҳ		
	];
	var saveTarList=[];
	var conLen=saveTarCondition.length;
	var tmpValue="",tmpTitle="";
	for (var i=0;i<conLen;i++){
		tmpTitle=saveTarCondition[i];
		tmpValue=GetValueById(tmpTitle);
		if (CheckRequied(tmpValue,tmpTitle)==false){
			return "";
		}
		saveTarList[i]=tmpValue
	}
	return saveTarList.join("^");
}

/// �����޸�
function IncAliasEdit(btnId){
	var modifyType=DHCSTEASYUI.GetModifyType(btnId);
	var dataSelected=$('#incAliasGrid').datagrid('getSelected');
	var incAliasId=dataSelected?dataSelected.incAliasId:"";
	var aliasText=$("#txtIncAlias").val().trim();
	if ((modifyType=="A")||(modifyType=="U")){
		if(urlIncItmId==""){
			$.messager.alert("��ʾ","���ȱ���������Ϣ!","warning");
			return;			
		}
		if (aliasText==""){
			$.messager.alert("��ʾ","��¼�����!","warning");
			return;
		}
		if (modifyType=="A"){
			incAliasId="";
		}else{
			if (incAliasId==""){
				$.messager.alert("��ʾ","��ѡ���¼!","warning");
				return;
			}
		}
		var aliasStr=incAliasId+"^"+aliasText;
		var saveRet=tkMakeServerCall("web.DHCST.INCALIAS","Save",urlIncItmId,aliasStr);
		if (saveRet==0){
			$.messager.alert("�ɹ���ʾ",((modifyType=="A")?"����":"�޸�")+"�ɹ�!","info");
			$("#incAliasGrid").datagrid('reload');
		}else{
			$.messager.alert("������ʾ",((modifyType=="A")?"����":"�޸�")+"ʧ��,�������:"+saveRet+"!","error");
		}
	}else if (modifyType=="D"){
		if (incAliasId==""){
			$.messager.alert("��ʾ","��ѡ���¼!","warning");
			return;
		}
		var delRet=tkMakeServerCall("web.DHCST.INCALIAS","Delete",incAliasId);
		if (delRet==0){
			$.messager.alert("�ɹ���ʾ","ɾ���ɹ�!","info");
			$("#incAliasGrid").datagrid('reload');
		}else{
			$.messager.alert("������ʾ","ɾ��ʧ��,�������:"+delRet+"!","error");
		}
	}
}

/// ��ҩ��λ�޸�
function DispUomEdit(btnId){
	var modifyType=DHCSTEASYUI.GetModifyType(btnId);
	var dataSelected=$('#dispUomGrid').datagrid('getSelected');
	var ilduId=dataSelected?dataSelected.ilduId:"";
	var phaLocId=$("#cmbPhaLoc").dhcstcomboeu('getValue');
	var dispUomId=$("#cmbDispUom").dhcstcomboeu('getValue');
	var startDate= $("#dtDispUomStDate").datebox('getValue');
	var endDate=$("#dtDispUomEdDate").datebox('getValue');
	var activeFlag=$("#chkDispUomActive").prop('checked');
	activeFlag=(activeFlag==true)?'Y':'N';
	if ((modifyType=="A")||(modifyType=="U")){
		if (phaLocId==""){
			$.messager.alert("��ʾ","��ѡ�����!","warning");
			return;
		}
		if (dispUomId==""){
			$.messager.alert("��ʾ","��ѡ��λ!","warning");
			return;
		}
		if (modifyType=="A"){
			ilduId="";
		}else{
			if (ilduId==""){
				$.messager.alert("��ʾ","��ѡ���¼!","warning");
				return;
			}
		}
		var dispUomStr=ilduId+"^"+dispUomId+"^"+activeFlag+"^"+startDate+"^"+endDate;
		var saveRet=tkMakeServerCall("web.DHCST.DispUom","Save",phaLocId,"",dispUomStr,urlIncItmId);
		if (saveRet==0){
			$.messager.alert("�ɹ���ʾ",((modifyType=="A")?"����":"�޸�")+"�ɹ�!","info");
			$("#dispUomGrid").datagrid('reload');
		}else{
			var saveArr=saveRet.toString().split("^");
			if ((saveArr[0]<0)&&(saveArr[1]||""!="")){
				$.messager.alert(((modifyType=="A")?"����":"�޸�")+"��ʾ",saveArr[1],"warning");			
			}else{
				$.messager.alert("������ʾ",((modifyType=="A")?"����":"�޸�")+"ʧ��,�����ںͻ�����λ��ת��ϵ��!","error");
			}
		}
	}else if (modifyType=="D"){
		if (ilduId==""){
			$.messager.alert("��ʾ","��ѡ���¼!","warning");
			return;
		}
		var delRet=tkMakeServerCall("web.DHCST.DispUom","DeleteDispUomInfo",ilduId);
		if (delRet==0){
			$.messager.alert("�ɹ���ʾ","ɾ���ɹ�!","info");
			$("#dispUomGrid").datagrid('reload');
		}else{
			$.messager.alert("������ʾ","ɾ��ʧ��,�������:"+delRet+"!","error");
		}
	}
}

/*************��ʼ����Ϣ********************/
function InitIncDict(){
	var options={
		ClassName:"web.DHCST.Util.DrugUtilQuery",
		QueryName:"",
		StrParams:""		
	};
	var tmpOptions={};
	/// ������λ
	tmpOptions={
		QueryName:"GetCTUom"
    };
	$("#cmbIncBaseUom").dhcstcomboeu($.extend({},options,tmpOptions));
	/// ���﷢ҩ��λ
	$("#cmbIncOutBaseUom").dhcstcomboeu($.extend({},options,tmpOptions));
	/// סԺ��ҩ��λ
	$("#cmbIncInBaseUom").dhcstcomboeu($.extend({},options,tmpOptions));
	/// ��ⵥλ
	$("#cmbIncPurchUom").dhcstcomboeu($.extend({},options,tmpOptions));
	/// ���װ��λ
	$("#cmbIncPackUom").dhcstcomboeu($.extend({},options,tmpOptions));
    /// ��ҩ��λ
    $("#cmbDispUom").dhcstcomboeu($.extend({},options,tmpOptions));
	/// �˲�����
	tmpOptions={
		QueryName:'GetBookCat'
	};
	$("#cmbBookCat").dhcstcomboeu($.extend({},options,tmpOptions));
	/// ��������
	tmpOptions={
		QueryName:'GetMarkType'
	};
	$("#cmbMarkType").dhcstcomboeu($.extend({},options,tmpOptions));
	/// �б�����
	tmpOptions={
		QueryName:'GetPublicBiddingList'
	};
	$("#cmbPbName").dhcstcomboeu($.extend({},options,tmpOptions));
	/// �б꼶�� 
	tmpOptions={
		QueryName:'GetPBLevel'
	};
	$("#cmbPbLevel").dhcstcomboeu($.extend({},options,tmpOptions));
	/// �б�������
 	tmpOptions={
	 	ClassName:"web.DHCST.Util.OrgUtilQuery",
		QueryName:"GetPhManufacturer",
    }
    $("#cmbPbManf").dhcstcomboeu($.extend({},options,tmpOptions)); 
	/// �б깩Ӧ��
 	tmpOptions={
	 	ClassName:"web.DHCST.Util.OrgUtilQuery",
		QueryName:"GetAPCVendor",
    }
    $("#cmbPbVendor").dhcstcomboeu($.extend({},options,tmpOptions)); 
	/// �б�������
 	tmpOptions={
	 	ClassName:"web.DHCST.Util.OrgUtilQuery",
		QueryName:"GetCarrier",
    }
    $("#cmbPbCarrier").dhcstcomboeu($.extend({},options,tmpOptions)); 
	/// ���ڱ�־
 	tmpOptions={
		QueryName:"GetImportFlag",
    }
    $("#cmbInciImport").dhcstcomboeu($.extend({},options,tmpOptions));
    /// �������
 	tmpOptions={
		QueryName:"GetQualityLevel",
    }
    $("#cmbQualityLev").dhcstcomboeu($.extend({},options,tmpOptions));
	/// ������ԭ��
 	tmpOptions={
		QueryName:"GetItmNotUseReason",
    }
    $("#cmbNotUseReason").dhcstcomboeu($.extend({},options,tmpOptions));
    /// ��׼�ĺ�
    tmpOptions={
		QueryName:"GetOfficeCode",
		StrParams:"Gp"
    }
    $("#cmbIncRemark1").dhcstcomboeu($.extend({},options,tmpOptions)); 
	/// �ӷ���
    tmpOptions={
		QueryName:"GetTarSubCate",
    }
    $("#cmbTarSubCat").dhcstcomboeu($.extend({},options,tmpOptions)); 
	/// �����ӷ���
    tmpOptions={
		QueryName:"GetTarOutpatCate",
    }
    $("#cmbTarOutCat").dhcstcomboeu($.extend({},options,tmpOptions)); 
	/// סԺ�ӷ���
    tmpOptions={
		QueryName:"GetTarInpatCate",
    }
    $("#cmbTarInCat").dhcstcomboeu($.extend({},options,tmpOptions)); 
	/// ����ӷ���
    tmpOptions={
		QueryName:"GetTarAcctCate",
    }
    $("#cmbTarAccSubCat").dhcstcomboeu($.extend({},options,tmpOptions)); 
	/// �����ӷ���
    tmpOptions={
		QueryName:"GetTarEMCCate",
    }
    $("#cmbTarAcctCat").dhcstcomboeu($.extend({},options,tmpOptions));
	/// ������ҳ����
    tmpOptions={
		QueryName:"GetTarMRCate",
    }
    $("#cmbTarMedCat").dhcstcomboeu($.extend({},options,tmpOptions));
	/// �²�����ҳ 
    tmpOptions={
		QueryName:"GetTarNewMRCate",
    }
    $("#cmbTarNewMedCat").dhcstcomboeu($.extend({},options,tmpOptions));
	/// ������ҩԭ�� 
    tmpOptions={
	    ClassName:"web.DHCST.Util.OtherUtilQuery",
		QueryName:"GetRefRetReason",
    }
    $("#cmbRefReturn").dhcstcomboeu($.extend({},options,tmpOptions));
	/// ������
	tmpOptions={
		ClassName:"web.DHCST.Util.DrugUtilQuery",
		QueryName:"GetINCSCStkGrp",
		StrParams:""
    }
    $("#cmbStkCat").dhcstcomboeu($.extend({},options,tmpOptions));
	/// �������� 
    tmpOptions={
	    ClassName:"web.DHCST.Util.OrgUtilQuery",
		QueryName:"GetGroupDept",
		StrParams:session['LOGON.GROUPID']+"|@|",
		onSelect:function(selData){
			$('#dispUomGrid').dhcstgrideu({
		     	queryParams:{
			     	ClassName:"web.DHCST.DispUom",
			     	QueryName:"GetDispUomInfo",
					StrParams:selData.RowId+"|@|"+urlIncItmId 
				}
			});
		}
    }
    $("#cmbPhaLoc").dhcstcomboeu($.extend({},options,tmpOptions));
    /// ת�Ʒ�ʽ
	tmpOptions={
		data: [
			{RowId: 'TRANS',Description: 'Transfer Only'},
			{RowId: 'ISSUE',Description: 'Issue Only'},
			{RowId: 'BOTH',Description: 'Both Issue & Transfer'}
		],
		editable:false
	};
    $("#cmbIncIsTrf").dhcstcomboeu($.extend({},options,tmpOptions));
    $("#cmbIncIsTrf").combobox('setValue','TRANS');
    /// ����Ҫ��
	tmpOptions={
		data: [
			{RowId: 'REQUIRED',Description: 'Ҫ��'},
			{RowId: 'NONREQUIRED',Description: '��Ҫ��'},
			{RowId: 'OPTIONAL',Description: '����'}
		],
		editable:false
	};
    $("#cmbBatchReq").dhcstcomboeu($.extend({},options,tmpOptions));
    $("#cmbBatchReq").combobox('setValue','REQUIRED');
    /// Ч��Ҫ��
    $("#cmbExpReq").dhcstcomboeu($.extend({},options,tmpOptions));
    $("#cmbExpReq").combobox('setValue','REQUIRED');   
    /// �۸���Ч����
    $("#dtPriceExeDate").datebox({});
    /// ��۱�������
	$("#dtPrcFileDate").datebox({});
    /// ҽ����ֹ���� 
	$("#dtOrdEndDate").datebox({});
}

/// ���������б�
function InitIncAliasGrid(){
	var gridColumns=[[  
		{field:'incAliasId',title:'������ID',width:300,hidden:true}, 
		{field:'incAliasText',title:'��������',width:300,hidden:false}
	]];
	var options={
		ClassName:"web.DHCST.INCALIAS",
		QueryName:"QueryByRowId",
		queryParams:{
			StrParams:urlIncItmId 
		},
		pagination:false,
		columns:gridColumns,
		onClickRow:function(rowIndex,rowData){
			if (rowData){
				$("#txtIncAlias").val(rowData.incAliasText);
			}
		}		
	};
	$('#incAliasGrid').dhcstgrideu(options); 
}

/// ��ҩ��λ�б�
function InitDispUomGrid(){
	var gridColumns=[[  
		{field:'ilduId',title:'ilduId',width:155,hidden:true,align:'center'},
		{field:'locId',title:'����Id',width:145,hidden:true,align:'center'},
		{field:'uomId',title:'��λId',width:145,hidden:true,align:'center'},
		{field:'uomDesc',title:'��λ����',width:200,hidden:false},
		{field:'active',title:'�����־',width:100,hidden:false,align:'center'},
		{field:'startDate',title:'��ʼ����',width:150,hidden:false,align:'center'},
		{field:'endDate',title:'��������',width:150,hidden:false,align:'center'}
		
	]];
	var options={
		ClassName:"web.DHCST.DispUom",
		QueryName:"GetDispUomInfo",
		queryParams:{
			StrParams:'|@|' 
		},
		pagination:false,
		columns:gridColumns,
		onClickRow:function(rowIndex,rowData){
			if (rowData){
				$("#cmbPhaLoc").combobox('setValue',rowData.locId);
				$("#cmbDispUom").combobox('setValue',rowData.uomId);
				$("#dtDispUomStDate").datebox('setValue',rowData.startDate);
				$("#dtDispUomEdDate").datebox('setValue',rowData.endDate);
				$("#chkDispUomActive").attr('checked',(rowData.active=='Y')?true:false);
			}
		}
	};
	$('#dispUomGrid').dhcstgrideu(options);  
}

/// ���пؼ����¸�ֵ
function GetIncItmValues(){
	if (urlIncItmId!=""){
		$.ajax({
			type:"POST",
			data:"json",
			url:"DHCST.QUERY.JSON.csp?&Plugin=EasyUI.ComboBox"+
			"&ClassName=web.DHCST.INCITM"+
			"&QueryName=QueryIncByIncId"+
			"&StrParams="+urlIncItmId,
			//url:"DHCST.QUERY.BROKER.csp?DataType=Array&ClassName=web.DHCST.INCITM&QueryName=QueryIncByIncId&strParams="+urlIncItmId,
			//url:"websys.Broker.cls?DataType=Array&ClassName=web.DHCST.INCITM&QueryName=QueryIncByIncId&strParams="+urlIncItmId,      
			error:function(){        
				alert("��ȡ����ʧ��!");
			},
			success:function(retData){
				SetIncItmValues(retData)
			}
		})	
	}
	
}

/// ����ֵ
function SetIncItmValues(retData){
	var jsonData=JSON.parse(retData)[0];
	for (var jsonId in jsonData){
		var jsonValue=jsonData[jsonId]||"";
		if (jsonId.substring(0, 3)=="txt"){
			$("#"+jsonId).val(jsonValue);
		}else if (jsonId.substring(0, 3)=="cmb"){
			$("#"+jsonId).combobox('setValue',jsonValue);
		}else if (jsonId.substring(0, 3)=="chk"){
			var tmpValue=((jsonValue=="Y")||(jsonValue=="1"))?true:false;
			$("#"+jsonId).prop('checked',tmpValue);
		}else if (jsonId.substring(0, 2)=="dt"){
			$("#"+jsonId).datebox('setValue',jsonValue);
		}
	}
	if (urlSaveAs=="Y"){
		$("#txtIncCode").val("");
		$("#txtIncDesc").val("");
	}else{
		var HASBEENUSED=jsonData.HASBEENUSED;
		MakeReadOnly(HASBEENUSED);
	}
}

/// ����Idȡֵ
function GetValueById(id){
 	if (id.indexOf("LOGON")>=0){
		return session[id];
	}
	if ($("#"+id).html()==undefined){
		return "";
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
			case "txtIncCode":
				msgText="��������Ϊ��";
			  	break;
			case "txtIncDesc":
				msgText="���������Ϊ��";
				break;
			case "cmbIncBaseUom":
				msgText="������λΪ��";
				break;
			case "cmbIncPurchUom":
				msgText="��ⵥλΪ��";
				break;
			case "cmbIncOutBaseUom":
				msgText="���﷢ҩ��λΪ��";
				break;
			case "cmbIncInBaseUom":
				msgText="סԺ��ҩ��λΪ��";
				break;
			case "cmbStkCat":
				msgText="������Ϊ��";
				break;
			case "cmbTarSubCat":
				msgText="�ӷ���Ϊ��";
				break;
			case "cmbTarAcctCat":
				msgText="�����ӷ���Ϊ��";
				break;
			case "cmbTarMedCat":
				msgText="������ҳ����Ϊ��";
				break;
			case "cmbTarOutCat":
				msgText="�����ӷ���Ϊ��";
				break;
			case "cmbTarAccSubCat":
				msgText="����ӷ���Ϊ��";
				break;
			case "cmbTarNewMedCat":
				msgText="�²�����ҳΪ��";
				break;
			case "cmbTarInCat":
				msgText="סԺ�ӷ���Ϊ��";
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
function MakeReadOnly(flag){
	if (urlSaveAs!="Y"){
		if ((flag==1)||(flag=="Y")){
			$("#cmbIncBaseUom").combobox('readonly',true);
			$("#txtRp").attr('readonly','readonly');
			$("#txtSp").attr('readonly','readonly');
			$("#dtPriceExeDate").datebox('readonly',true);
		}
	}
	
}

function InitDetailReadOnly()
{
	var gLocId=session['LOGON.CTLOCID'];
	var gUserId=session['LOGON.USERID'];
	var gGroupId=session['LOGON.GROUPID']; 
	var gHospId=session['LOGON.HOSPID']; 
	var strParams=gGroupId+"^"+gLocId+"^"+gUserId+"^"+gHospId;
	var retData=tkMakeServerCall("web.DHCST.DrugInfoMaintain","GetParamProp",strParams)
	var propValue=retData.split("^");
	var allowInputRp=propValue[0];
	var allowInputSp=propValue[1];
	if(allowInputRp=="N"){
		$("#txtRp").attr('readonly','readonly');
	}
	if(allowInputSp=="N"){
		$("#txtSp").attr('readonly','readonly');
	}
}