/**
 * 模块:		药库
 * 子模块:		医嘱项维护
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
		// 控制录入数字
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
	            if (title.indexOf("等效单位") >= 0) {
					InitEqualUomGrid();
	            }else if (title.indexOf("限制科室用药") >= 0){
					InitArcResDocGrid();
		        }else if (title.indexOf("医嘱项别名") >= 0){
					InitArcAliasGrid();
		        }else if (title.indexOf("皮试医嘱关联") >= 0){
					InitArcSkinGrid();
		        }
	        }
	    });
		if (urlSaveAs=="Y"){
			urlArcItmId="";   
		}
	}catch(e){
		$.messager.alert("错误提示",e.message,"error");
	}
});

function InitContent(){
	GetPhcArcItmValues();
}

function ClearContent(){
	$.messager.confirm('清屏提示', '您确认清屏吗?', function(r){
		if (r){	
			$(".dhcst-win-content input").val("");
			$(".dhcst-win-content input[type=checkbox]").prop('checked',false);
		}
	});
}
function CloseContent(){
	$.messager.confirm('关闭提示', '您确认关闭吗?', function(r){
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
		$.messager.alert("成功提示","保存成功!","info");
		urlActionType="U";
		urlArcItmId=saveArr[1];
		if ((urlActionType=="U")&&(urlSaveAs!="Y")){
			InitContent();
		}else{
			var src="dhcst.easyui.arcitm.modify.csp?"+"actionType="+"U"+"&arcItmRowId="+urlArcItmId+"&phcGenericId="+urlPhcGenericId+"&saveAs=";
			parent.$("#ifrmMainTain").attr("src",src);
		}
		var winTitle=parent.$("#maintainWin").panel('options').title;
		winTitle=winTitle.replace('增加','修改');
		winTitle=winTitle.replace('另存','修改');
		parent.$("#maintainWin").panel({title:winTitle});
	}else{
		$.messager.alert("错误提示",saveArr[1]+"!","error");
	}
}

/// 等效单位修改
function EqualUomEdit(btnId){
	var modifyType=DHCSTEASYUI.GetModifyType(btnId);
	var dataSelected=$('#equalUomGrid').datagrid('getSelected');
	var eqRowId=dataSelected?dataSelected.eqRowId:"";
	if (urlArcItmId==""){
		$.messager.alert("提示","请先保存医嘱项信息!","warning");
		return;
	}
	if ((modifyType=="A")||(modifyType=="U")){
		var doseUom=$("#cmbEqualUom").dhcstcomboeu('getValue');	
		var doseQty=$("#txtEqualQty").val();
		var doseDefQty=$("#txtEqualDefQty").val();
		if (doseUom==""){
			$.messager.alert("提示","请选择等效单位!","warning");
			return;
		}
		if ((doseQty=="")||(doseQty<=0)){
			$.messager.alert("提示","请录入有效的等效单位数量!","warning");
			return;
		}
		/*if ((doseDefQty=="")||(doseDefQty<=0)){
			$.messager.alert("提示","请录入有效的等效单位默认数量!","warning");
			return;
		}*/
		if (modifyType=="A"){
			eqRowId="";
		}else{
			if (eqRowId==""){
				$.messager.alert("提示","请选择记录!","warning");
				return;
			}
		}
		var eqUomStr=eqRowId+"^"+doseUom+"^"+doseQty+"^"+doseDefQty;
		var saveRet=tkMakeServerCall("web.DHCST.PHCDRGMAST","SaveFormDoseEquiv","",eqUomStr,urlArcItmId);
		if (saveRet==0){
			$.messager.alert("提示",((modifyType=="A")?"增加":"修改")+"成功!","info");
			$("#equalUomGrid").datagrid('reload');
		}else{
			var saveArr=saveRet.toString().split("^");
			if ((saveArr[0]<0)&&(saveArr[1]||""!="")){
				$.messager.alert(((modifyType=="A")?"增加":"修改")+"提示",saveArr[1],"warning");			
			}else{
				$.messager.alert("错误提示",((modifyType=="A")?"增加":"修改")+"失败,错误代码:"+saveRet+"!","error");
			}
		}
	
	}else if (modifyType=="D"){
		if (eqRowId==""){
			$.messager.alert("提示","请选择记录!","warning");
			return;
		}
		$.messager.confirm('确认提示', '等效单位为基础数据,您确认删除吗?', function(r){
			if (r){
				var delRet=tkMakeServerCall("web.DHCST.PHCDRGMAST","DeleteFormDoseEquiv",eqRowId);
				if (delRet==0){
					$.messager.alert("成功提示","删除成功!","info");
					$("#equalUomGrid").datagrid('reload');
				}else{
					$.messager.alert("错误提示","删除失败,错误代码:"+delRet+"!","error");
				}
			}
		});		
	}
}

/// 别名修改
function ArcAliasEdit(btnId){
	var modifyType=DHCSTEASYUI.GetModifyType(btnId);
	var dataSelected=$('#arcAliasGrid').datagrid('getSelected');
	var arcAliasId=dataSelected?dataSelected.arcAliasId:"";
	var aliasText=$("#txtArcAlias").val().trim();
	if ((modifyType=="A")||(modifyType=="U")){
		if (urlArcItmId==""){
			$.messager.alert("提示","请先保存医嘱项信息!","warning");
			return;
		}
		if (aliasText==""){
			$.messager.alert("提示","请录入别名!","warning");
			return;
		}
		if (modifyType=="A"){
			arcAliasId="";
		}else{
			if (arcAliasId==""){
				$.messager.alert("提示","请选择记录!","warning");
				return;
			}
		}
		var aliasStr=arcAliasId+"^"+aliasText;
		var saveRet=tkMakeServerCall("web.DHCST.ARCALIAS","Save",urlArcItmId,aliasStr);
		if (saveRet==0){
			$.messager.alert("提示",((modifyType=="A")?"增加":"修改")+"成功!","info");
			$("#arcAliasGrid").datagrid('reload');
		}else{
			$.messager.alert("错误提示",((modifyType=="A")?"增加":"修改")+"失败,错误代码:"+saveRet+"!","error");
		}
	}else if (modifyType=="D"){
		if (arcAliasId==""){
			$.messager.alert("提示","请选择记录!","warning");
			return;
		}
		var delRet=tkMakeServerCall("web.DHCST.ARCALIAS","Delete",arcAliasId);
		if (delRet==0){
			$.messager.alert("成功提示","删除成功!","info");
			$("#arcAliasGrid").datagrid('reload');
		}else{
			$.messager.alert("错误提示","删除失败,错误代码:"+delRet+"!","error");
		}
	}
}

/// 限制科室用药
function ResDocEdit(btnId){
	if (urlArcItmId==""){
		$.messager.alert("提示","请先保存医嘱项信息!","warning");
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
			$.messager.alert("提示","请选择关系!","warning");
			return;
		}
		if (resDocType==""){
			$.messager.alert("提示","请选择类型!","warning");
			return;
		}
		if (resDocOperate==""){
			$.messager.alert("提示","请选择操作!","warning");
			return;
		}
		if (resDocPointer==""){
			$.messager.alert("提示","请选择名称!","warning");
			return;
		}
		if (modifyType=="A"){
			resDocId="";
		}else{
			if (resDocId==""){
				$.messager.alert("提示","请选择记录!","warning");
				return;
			}
		}
		var resDocStrStr=resDocId+"^"+resDocRelation+"^"+resDocType+"^"+resDocOperate+"^"+resDocPointer;
		var saveRet=tkMakeServerCall("web.DHCST.RestrictDoc","Save",urlArcItmId,resDocStrStr);
		var saveArr=saveRet.split("^");
		var saveVal=saveArr[0]||"";
		if (saveVal>=0){
			$.messager.alert("成功提示",((modifyType=="A")?"增加":"修改")+"成功!","info");
			$("#arcResDocGrid").datagrid('reload');
		}else{
			var saveInfo=saveArr[1]||"";
			if (saveInfo!=""){
				$.messager.alert("提示",saveInfo,"warning");
			}else{
				$.messager.alert("错误提示",((modifyType=="A")?"增加":"修改")+"失败,错误代码:"+saveRet+"!","error");
			}
		}
	}else if (modifyType=="D"){
		if (resDocId==""){
			$.messager.alert("提示","请选择记录!","warning");
			return;
		}
		var delRet=tkMakeServerCall("web.DHCST.RestrictDoc","Delete",resDocId);
		if (delRet==0){
			$.messager.alert("成功提示","删除成功!","info");
			$("#arcResDocGrid").datagrid('reload');
		}else{
			$.messager.alert("错误提示","删除失败,错误代码:"+delRet+"!","error");
		}
	}
}


/// 皮试关联医嘱
function ArcSkinEdit(btnId){
	if (urlArcItmId==""){
		$.messager.alert("提示","请先保存医嘱项信息!","warning");
		return;
	}
	var modifyType=DHCSTEASYUI.GetModifyType(btnId);
	var dataSelected=$('#arcSkinGrid').datagrid('getSelected');
	var sktId=dataSelected?dataSelected.sktId:"";
	var arcItmId=$("#cmbArcItm").dhcstcomboeu('getValue');
	if ((modifyType=="A")){
		if (arcItmId==""){
			$.messager.alert("提示","请选择医嘱项条件!","warning");
			return;
		}
		sktId="";
		var arcSkinStr="^^"+arcItmId
		var saveRet=tkMakeServerCall("web.DHCST.ARCITMMAST","SaveSktInfo",urlArcItmId,arcSkinStr);
		if (saveRet>=0){
			$.messager.alert("成功提示",((modifyType=="A")?"增加":"修改")+"成功!","info");
			$("#cmbArcItm").combogrid("clear")
			$("#arcSkinGrid").datagrid('reload');
		}else{
			$.messager.alert("错误提示",((modifyType=="A")?"增加":"修改")+"失败,错误代码:"+saveRet+"!","error");
		}
	}else if (modifyType=="D"){
		if (sktId==""){
			$.messager.alert("提示","请选择记录!","warning");
			return;
		}
		var delRet=tkMakeServerCall("web.DHCST.ARCITMMAST","DeleteSktInfo",sktId);
		if (delRet==0){
			$.messager.alert("成功提示","删除成功!","info");
			$("#arcSkinGrid").datagrid('reload');
		}else{
			$.messager.alert("错误提示","删除失败,错误代码:"+delRet+"!","error");
		}
	}
}
 /// 保存-获取医嘱项数据
function GetSaveArcList(){
	var saveArcCondition=[
		'txtArcCode',			// 代码-1
		'txtArcDesc',			// 描述-2
		'cmbBillUom',			// 计价单位-3
		'cmbArcCat',			// 医嘱子类-4
		'cmbArcBillGrp',		// 费用大类-5
		'cmbArcBillSub', 		// 费用子类-6
		'chkOrderOnItsOwn',		// 独立医嘱-7
		'cmbOECPriority',		// 医嘱优先级-8
		'chkWoStock',			// 无库存-9
		'txtInsuDesc',			// 医保名称-10
		'txtArcAliasStr',		// 别名-11
		'txtArcSX',				// 缩写-12
		'cmbOfficialType',		// 医保类别-13
		'txtArcMaxQty',			// 最大量-14
		'txtArcNoOfCumDays',	// 限制使用天数-15
		'txtArcMaxQtyPerDay',	// 每天最大剂量-16
		'txtArcMaxCumDose',		// 单次最大剂量-17
		'chkRestrictEM',		// 急诊用药-18
		'chkRestrictIP',		// 住院用药-19
		'chkRestrictOP',		// 门诊用药-20
		'chkRestrictHP',		// 体检用药-21
		'txtOeMessage',			// 医嘱提示-22
		'chkUpdateTar',			// 是否更新收费项-23
		'chkUpdateInsu',		// 是否更新医保项-24
		'cmbTarSubCat',			// 子分类-25
		'cmbTarInCat',			// 住院子分类-26
		'cmbTarOutCat',			// 门诊子分类-27
		'cmbTarAcctCat',		// 核算子分类-28
		'cmbTarMedCat',			// 病历首页分类-29
		'cmbTarAccSubCat',		// 会计子分类-30
		'cmbTarNewMedCat',		// 新病案分类-31
		'dtArcEffDate',			// 生效日期-32
		'dtArcEffDateTo',		// 医嘱截止日期-33
		'LOGON.USERID',			// 更新用户-34
		'txtLimitQty',			// 限制用量-35
		'txtWarningUseQty',		// 极限用量-36
		'chkFreeDrugFlag'		// 免费药-37
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
/// 保存-获取药学项串
function GetSavePhcList(){
	var savePhcCondition=[
		'txtArcCode',			// 代码-1
		'txtArcDesc',			// 描述-2
		'cmbPhcForm',			// 剂型-3
		'cmbPhcBaseUom',		// 基本单位-4
		'cmbPhcInstruc',		// 用法-5
		'cmbPhcDuration',		// 疗程-6
		'txtPhcBaseQty',		// 基本单位数量-7
		'cmbPhcManf',	    	// 厂商-8
		'cmbPhcPoison',			// 管制分类-9
		'cmbPhcFreq',			// 频次-10
		'cmbOfficialType',		// 医保类别-11
		'cmbGeneric',			// 处方通用名-12
		'cmbPhcCat',			// 药学一级分类-13
		'cmbPhcSubCat',			// 药学二级分类-14
		'cmbPhcMinCat',			// 药学三级分类-15
		'txtPhcLabelName11',	// 英文国际非专利药名-16
		'txtPhcLabelName12',	// 国际专利药名-17
		'txtPhcLabelName1',		// 商品名-18
		'txtPhcZhJName',		// 制剂通用名-19
		'txtPhcYLName',			// 原料通用名-20
		'chkIPOneDay',			// 住院一天量-21
		'chkOPOneDay',			// 门诊一天量(1\0)-22
		'chkOPSkin',			// 门诊皮试用原液(1\0)-23
		'chkIPSkin',			// 住院皮试用原液(1\0)-24
		'txtDDD',				// DDD值-25
		'LOGON.USERID',			// 更新用户-26
		'chkPhcAnti',			// 抗生素标志-27
		'chkPhcCritical',		// 危重药标志-28
		'txtPhcAgeLimit',		// 年龄限制-已停用-29
		//'dtPhcStartDate',		// 开始日期-
		'treePhcCat',			// 多级药学分类-30
		'cmbWhoNetCode',		// WHONET码-31
		'cmbPhcSpec',			// 草药备注-32
		'txtWhoDDD',			// WhoDDD值-33
		'cmbWhoDDDUom',			// WhoDDD单位-34
		'txtIvgttSpeed',		// 滴速-35
		'txtGranulesFact',		// 颗粒单位系数-36
		'chkProvinceComm',		// 省属常用药物-37
		'cmbPhcPivaCat',		// 药品配液分类-38
		'cmbHighRisk',			// 高危级别-39
		'chkPhcSingleUse',		// 单味使用标识-40
		'chkAllergy',			// 过敏-41
		'chkDietTaboo',			// 饮食禁忌-42
		'chkPhcTumble',			// 跌倒风险-43
		'chkDope',				// 兴奋剂-44
		'chkBaseDrug',			// 国家基本药物-45
		'chkProBaseDrug',		// 省基本药物-46
		'chkCityBaseDrug',		// 市基本药物-47
		'chkCouBaseDrug',		// 区(县)基本药物-48
		'cmbPhcOTC'	,			// 非处方-OTC-49
		'chkCodeX',				// 中国药典-50
		'chkPhcTest',			// 临床验证用药-51
		'chkTPN',				// TPN-52
		'chkCQZT',				// 长期默认嘱托-53
		'chkONE',				// 临时默认取药-54
		'txtPhcSpec',			// 含量规格-55
		'chkMonitorFlag',		// 重点监控药品 -56
		'chkOM'					// 附加说明默认自备 -57
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
	// 验证组合必填
	var poisonDesc=$("#cmbPhcPoison").combobox("getText")||"";
	var ddd=savePhcList[24];
	var antiFlag=savePhcList[26];
	var whoNetCode=savePhcList[30];
	var whoDDD=savePhcList[32];
	var whoDDDUom=savePhcList[33];
	// 抗菌药勾选时,必须选择管制分类
	if(antiFlag=="Y"){
		if (poisonDesc==""){
			$.messager.alert("提示","抗菌药必须选择管制分类","info");
			return "";
		}
		if (poisonDesc.indexOf("抗菌药")<0){
			$.messager.alert("提示","抗菌药的管制分类必须为抗菌药物的一种","info");
			return "";
		}
	}
	// 管制分类为抗菌药时DDD的值必填
	if (poisonDesc.indexOf("抗菌药")>=0){
		if (antiFlag!="Y"){
			$.messager.alert("提示","管制分类为抗菌药时必须维护抗菌药标志","info");
			return "";	管制分类为抗菌药时必须填入DDD的值	
		}
		if (ddd==""){
			$.messager.alert("提示","管制分类为抗菌药时必须填入DDD的值","info");
			return "";		
		}
		if (whoNetCode==""){
			$.messager.alert("提示","管制分类为抗菌药时必须填入WHONET码值","info");
			return "";		
		}	
	}
	if ((whoDDD!="")&&(whoDDDUom=="")){
		$.messager.alert("提示","WHODDD值不为空,单位为空","info");
		return "";		
	}
	if ((whoDDD=="")&&(whoDDDUom!="")){
		$.messager.alert("提示","WHODDD单位不为空,值为空","info");
		return "";		
	}	
	return savePhcList.join("^");
}
/*************初始化信息********************/
function InitArcDict(){
	var options={
		ClassName:"web.DHCST.Util.DrugUtilQuery",
		QueryName:"",
		StrParams:""		
	}
	var secOptions=options;
	var tmpOptions={};
	/*********************************医嘱项信息*******************************/
	/// 费用大类
	tmpOptions={
		QueryName:"GetArcBillGrp",
		onSelect:function(selData){   
			/// 级联-费用子类
			secOptions.QueryName="GetArcBillSub";
			secOptions.StrParams=selData.RowId;
			$("#cmbArcBillSub").dhcstcomboeu(secOptions);	
		}  
    } 
	$("#cmbArcBillGrp").dhcstcomboeu($.extend({},options,tmpOptions));
	/// 费用子类
	tmpOptions={
		QueryName:"GetArcBillSub",
    }	
	$("#cmbArcBillSub").dhcstcomboeu($.extend({},options,tmpOptions));	 
	/// 医嘱大类
	tmpOptions={
		QueryName:"GetOrderCategory",
		onSelect:function(selData){   
			/// 级联-医嘱子类
			secOptions.QueryName="GetArcItemCat";
			secOptions.StrParams=selData.RowId;
			$("#cmbArcCat").dhcstcomboeu(secOptions);	
		}  
    } 
	$("#cmbOrdCategory").dhcstcomboeu($.extend({},options,tmpOptions));
	/// 医嘱子类
	tmpOptions={
		QueryName:"GetArcItemCat",
    }
	$("#cmbArcCat").dhcstcomboeu($.extend({},options,tmpOptions));
	/// 医嘱优先级
	tmpOptions={
		QueryName:"GetOECPriority",
    }
    $("#cmbOECPriority").dhcstcomboeu($.extend({},options,tmpOptions));
	/// 计价单位
	/*
	tmpOptions={
		QueryName:"GetCTUom",
    }
    $("#cmbBillUom").dhcstcomboeu($.extend({},options,tmpOptions));
    */
    /*****************************药学信息*****************************/
    /// 基本单位
	tmpOptions={
		QueryName:"GetCTUom",
    }
    $("#cmbPhcBaseUom").dhcstcomboeu($.extend({},options,tmpOptions));
    /// 剂型
	tmpOptions={
		QueryName:"GetPhcForm",
		onLoadSuccess:function(data) {
			// 初始化
			LoadTimeArr["cmbPhcForm"]=LoadTimeArr["cmbPhcForm"]+1;
			if (LoadTimeArr["cmbPhcForm"]==1){
				if ((urlArcItmId=="")&&(urlPhcFormId!="")){
					$("#cmbPhcForm").combobox("setValue",urlPhcFormId);
				}
			}
		}
    }
    $("#cmbPhcForm").dhcstcomboeu($.extend({},options,tmpOptions));
    /// 用法
 	tmpOptions={
		QueryName:"GetPHCInstruc",
    }
    $("#cmbPhcInstruc").dhcstcomboeu($.extend({},options,tmpOptions));   
    /// 频次
 	tmpOptions={
		QueryName:"GetPHCFreq",
    }
    $("#cmbPhcFreq").dhcstcomboeu($.extend({},options,tmpOptions));  
    /// 疗程
 	tmpOptions={
		QueryName:"GetPhcDuration",
    }
    $("#cmbPhcDuration").dhcstcomboeu($.extend({},options,tmpOptions));   
    /// 厂商
 	tmpOptions={
	 	ClassName:"web.DHCST.Util.OrgUtilQuery",
		QueryName:"GetPhManufacturer",
    }
    $("#cmbPhcManf").dhcstcomboeu($.extend({},options,tmpOptions)); 
    /// 医保类别
 	tmpOptions={
		QueryName:"GetInsuCat",
    }
    $("#cmbOfficialType").dhcstcomboeu($.extend({},options,tmpOptions)); 
    /// 管制分类
 	tmpOptions={
		QueryName:"GetPhcPoison",
    }
    $("#cmbPhcPoison").dhcstcomboeu($.extend({},options,tmpOptions)); 
    /// 草药备注
   	tmpOptions={
		QueryName:"GetPHCSpecInc",
		multiple:true
    }
    $("#cmbPhcSpec").dhcstcomboeu($.extend({},options,tmpOptions));   
    /// 高危级别
    tmpOptions={
		QueryName:"GetHighRiskLevel",
    }
    $("#cmbHighRisk").dhcstcomboeu($.extend({},options,tmpOptions));  
    /// 药品配液分类
    tmpOptions={
		QueryName:"GetPHCPivaCat",
    }
    $("#cmbPhcPivaCat").dhcstcomboeu($.extend({},options,tmpOptions)); 
    /// 等效单位
	tmpOptions={
		QueryName:"GetCTUom",
    }
    $("#cmbEqualUom").dhcstcomboeu($.extend({},options,tmpOptions));  
    /// OTC-非处方标识
    tmpOptions={
		QueryName:"GetOfficeCode",
		StrParams:"Gpp"
    }
    $("#cmbPhcOTC").dhcstcomboeu($.extend({},options,tmpOptions));   
	
	/*********local 数据**********/
	/// 关系
    tmpOptions={
		data: [{RowId: 'AND',Description: '并且'},{RowId: 'OR',Description: '或者'}]
    };
    $("#cmbResDocRelation").dhcstcomboeu($.extend({},options,tmpOptions)); 
	/// 类型
    tmpOptions={
		data: [
			{RowId:'KS',Description:'科室',QueryName:'GetTypeLoc',strParams:'E'},
			{RowId:'ZC',Description:'职称',QueryName:'GetCarPrvTp',strParams:''},
			{RowId:'YS',Description:'医生',QueryName:'GetLocUser',strParams:''},
			{RowId:'JB',Description:'病人级别',QueryName:'GetCtEMF',strParams:''}
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
	/// 操作
    tmpOptions={
		data: [{RowId:'=',Description:'等于'},{RowId:'<>',Description:'不等于'},{RowId:'>=',Description:'大于等于'}]
    };
    $("#cmbResDocOperate").dhcstcomboeu($.extend({},options,tmpOptions));  
    /// whonet码
    tmpOptions={
		QueryName:"GetWhonetInfo",
	    columns: [[
			{field:'antCode',title:'代码',width:100,sortable:true},
			{field:'antName',title:'中文描述',width:100,sortable:true},
			{field:'antEName',title:'英文描述',width:100,sortable:true}
	    ]],
		idField:'antCode',
		textField:'antCode'
    }
    $("#cmbWhoNetCode").dhcstcombogrideu($.extend({},options,tmpOptions));
    /// 医嘱项下拉
    tmpOptions={
	    ClassName:"web.DHCST.ARCITMMAST",
		QueryName:"GetArcItmMast",
	    columns: [[
			{field:'arcItmRowId',title:'arcItmRowId',width:100,sortable:true,hidden:true},
			{field:'arcItmCode',title:'医嘱项代码',width:100,sortable:true},
			{field:'arcItmDesc',title:'医嘱项描述',width:200,sortable:true}
	    ]],
		idField:'arcItmRowId',
		textField:'arcItmDesc'
    }
    $("#cmbArcItm").dhcstcombogrideu($.extend({},options,tmpOptions));
    $("#dtArcEffDate,#dtArcEffDateTo").datebox({});  
	// 处方通用名下拉
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
			{field:'Description',title:'处方通用名名称',width:200,sortable:true}
	    ]],
		idField:'RowId',
		textField:'Description',
		mode:"remote",
		pageSize:30, 
		pageList:[30,50,100],  
		pagination:true,
		onLoadSuccess:function(data) {
			// 初始化
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

/// 需根据医嘱id初始化的下拉列表
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
 /// 初始化等效果单位列表
function InitEqualUomGrid(){
	var gridColumns=[[  
		{field:'eqRowId',title:'等效单位ID',width:300,hidden:true}, 
		{field:'doseUomId',title:'单位ID',width:300,hidden:true}, 
		{field:'doseUomDesc',title:'等效单位',width:180,align:"center"},
		{field:'doseQty',title:'等效数量',width:180,align:"right"},
		{field:'doseDefQty',title:'缺省数量',width:180,align:"right"}
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

/// 初始化别名列表
function InitArcAliasGrid(){
	var gridColumns=[[  
		{field:'arcAliasId',title:'别名表ID',width:300,hidden:true}, 
		{field:'arcAliasText',title:'医嘱项别名',width:300,hidden:false}
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

/// 初始化限制科室用药
function InitArcResDocGrid(){
	var gridColumns=[[  
		{field:'resDocRelationDesc',title:'关系',width:155,hidden:false,align:'center'},
		{field:'resDocTypeDesc',title:'类型',width:145,hidden:false,align:'center'},
		{field:'resDocOperateDesc',title:'操作',width:145,hidden:false,align:'center'},
		{field:'resDocPointerDesc',title:'名称',width:242,hidden:false},
		{field:'resDocRelation',title:'关系ID',width:300,hidden:true,align:'center'},
		{field:'resDocType',title:'类型ID',width:300,hidden:true,align:'center'},
		{field:'resDocOperate',title:'操作ID',width:300,hidden:true,align:'center'},
		{field:'resDocPointer',title:'名称ID',width:300,hidden:true},
		{field:'resDocId',title:'限制科室用药ID',width:300,hidden:true}
		
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

/// 皮试关联列表
function InitArcSkinGrid(){
	var gridColumns=[[  
		{field:'sktId',title:'关联表ID',width:155,hidden:true,align:'center'},
		{field:'arcItmId',title:'医嘱项ID',width:145,hidden:true,align:'center'},
		{field:'arcItmCode',title:'医嘱项代码',width:100,hidden:false,align:'center'},
		{field:'arcItmDesc',title:'医嘱项名称',width:300,hidden:false,align:'center'},
		
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

/// 所有控件重新赋值
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
				alert("获取数据失败!");
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
				alert("获取数据失败!");
			},
			success:function(retData){
				SetPhcArcItmValues(retData)
			}
		})	
	}
}
/// 医嘱项药学项赋值
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
/// 根据Id取值
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
/// 验证必填以及其他
function CheckRequied(value,id){
	var msgText="";
	if (value==""){
		switch(id){
			case "txtArcCode":
				msgText="医嘱项代码为空";
			  	break;
			case "txtArcDesc":
				msgText="医嘱项名称为空";
				break;
			case "cmbArcBillGrp":
				msgText="费用大类为空";
				break;
			case "cmbArcBillSub":
				msgText="费用子类为空";
				break;
			case "cmbOrdCategory":
				msgText="医嘱大类为空";
				break;
			case "cmbArcCat":
				msgText="医嘱子类为空";
				break;
			case "cmbOECPriority":
				msgText="医嘱优先级为空";
				break;
			case "cmbPhcBaseUom":
				msgText="药学基本单位";
				break;
			case "cmbGeneric":
				msgText="处方通用名";
				break;
			default:
				msgText="";
		}
		if (msgText!=""){
			$.messager.alert("提示",msgText,"info");
			return false;
		}
	}
	return true;
}