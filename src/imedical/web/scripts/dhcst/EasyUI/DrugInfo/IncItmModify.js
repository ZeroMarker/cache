/**
 * 模块:		药库
 * 子模块:		库存项维护
 * createdate:	2017-07-03
 * creator:		yunhaibao
 */
var HASBEENUSED="";	// 是否发生业务
$(function(){
	try{
		if (urlActionType=="U"){

		}else{
			urlIncItmId="";
		}
		// 控制录入数字
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
	            if (title.indexOf("单位转换维护") >= 0) {
		            if ($("#ifrmCTConFac").attr("src")==""){
						$("#ifrmCTConFac").attr("src","dhc.bdp.ext.default.csp?extfilename=App/Stock/CT_ConFac")
		            }
	            }else if (title.indexOf("发药单位维护") >= 0){
		            $("#dtDispUomEdDate").datebox({});
		            $("#dtDispUomStDate").datebox({});
		        	InitDispUomGrid();
		        }else if (title.indexOf("库存项别名") >= 0){
					InitIncAliasGrid();
		        }
	        }
	    });
	    if (urlSaveAs=="Y"){
			urlIncItmId="";   
		}
	}catch(e){
		$.messager.alert("错误提示",e.message,"error");
		$.messager.progress('close');
	}
});

function InitContent(){
	GetIncItmValues();
	InitDetailReadOnly();
	return
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
		$.messager.alert("成功提示","保存成功!","info");
		if ((urlActionType=="U")&&(urlSaveAs!="Y")){
			GetIncItmValues();
		}else{
			// 不是修改,成功后重新加载
			urlActionType="U";
			var src="dhcst.easyui.incitm.modify.csp?"+"actionType="+urlActionType+"&incItmRowId="+urlIncItmId+"&arcItmRowId="+urlArcItmId+"&saveAs=";
			parent.$("#ifrmMainTain").attr("src",src);
		}
		var winTitle=parent.$("#maintainWin").panel('options').title;
		winTitle=winTitle.replace('增加','修改');
		winTitle=winTitle.replace('另存','修改');
		parent.$("#maintainWin").panel({title:winTitle});
	}else{
		$.messager.alert("错误提示",saveArr[1]!=undefined?saveArr[1]:saveRet+"!","error");
	}
}

 /// 保存-获取库存项数据
function GetSaveIncList(){
	var saveIncCondition=[
		'txtIncCode',			// 代码-1
		'txtIncDesc',			// 描述-2
		'cmbIncBaseUom',		// 基本单位-3
		'cmbIncPurchUom',		// 入库单位-4
		'cmbStkCat',			// 库存分类-5
		'cmbIncIsTrf',			// 转移方式-6
		'cmbBatchReq',			// 要求批次-7
		'cmbExpReq',			// 要求效期-8
		'txtIncAliasStr',		// 别名-9
		'chkNotUse',			// 不可用-10
		'txtReportingDays',		// 协和码-11
		'txtIncBarCode',		// 条码-12
		'LOGON.USERID',			// 更新用户-13
		'txtSp',				// 售价-14
		'txtRp',				// 进价-15
		'dtPriceExeDate',		// 价格生效日期-16
		'txtIncSpec',			// 规格-17
		'cmbInciImport',		// 进口标志-18
		'cmbQualityLev',		// 质量层次-19
		'cmbOTC',				// 处方药分类-20
		'chkIncBaseDrug',		// 国家基本药物-21
		'chkIncCodeX',			// 中国药典标志-22
		'chkIncTest',			// 临床验证用药-23
		'chkIncRec',			// 处方购药标识-24
		'txtQualityNo',			// 质量编号-25
		'txtComeFrom',			// 国省别-26
		'cmbIncRemark1-txtIncRemark2', // 批准文号-27
		'chkHighPrice',			// 高值类标志-28
		'cmbMarkType',			// 定价类型-29
		'txtMaxSp',				// 最高售价-30
		'txtStoreConId',		// 存储条件	-31
		'chkIncInHosp',			// 本院药品目录-32
		'chkIncPb',				// 招标标志-33
		'txtPbRp',				// 招标进价-34
		'cmbPbLevel',			// 招标级别-35
		'cmbPbVendor',			// 招标供应商-36
		'cmbPbManf',			// 招标厂商-37
		'cmbPbCarrier',			// 招标配送商-38
		'cmbPbName',			// 招标名称-39
		'chkBAFlag',			// 阳光采购-40
		'txtExpLen',			// 效期长度-41
		'txtPrcFile',			// 物价文件号-42
		'dtPrcFileDate',		// 物价备案日期-43
		'chkSkin',				// 皮试-44
		'cmbBookCat',			// 帐簿分类-45
		'txtUserOrderInfo',     // 用药说明-46
		'chkIncProBaseDrug',	// 省基本药物-47
		'chkIncCityBaseDrug',	// 市基本药物-48	
		'chkIncCouBaseDrug',	// 区县基本药物-49	
		'txtIncBaseCode',		// 本位码-50
		'txtInDrugInfo',		// 进药依据-51
		'cmbIncPackUom',		// 大包装单位-52
		'txtPackPurFac',		// 打包装系数-53
		'chkHighRisk',			// 高危标志-54
		'cmbNotUseReason',		// 不可用原因-55
		'cmbIncInsu',			// 医保类别-56
		'LOGON.CTLOCID',		// 登录科室-57
		'LOGON.GROUPID',		// 登录安全组-58
		'cmbRefReturn',			// 不可退药原因-59
		'cmbIncOutBaseUom',		// 门诊发药单位-60
		'cmbIncInBaseUom',		// 住院发药单位-61
		'dtOrdEndDate'			// 医嘱截止日期-62
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

 /// 保存-获取库存项存储条件数据
function GetSaveStoreConList(){
	var saveStoreConCondition=[
		'chkRoomTemp',		// 常温-1
		'chkDry',			// 干燥-2
		'chkAirtight',		// 密闭-3
		'chkDark',			// 避光-4
		'chkVentilation',	// 通风-5
		'chkRadiation',		// 防辐射-6
		'chkMeltSeal',		// 熔封-7
		'chkCool',			// 阴凉-8
		'chkColdDark',		// 凉暗-9
		'chkSeal', 			// 密封-10
		'chkRefrigeration', // 冷藏-11
		'txtMinTemp',		// 最低温-12
		'txtMaxTemp',  		// 最高温-13
		'txtMinHumi',		// 最低湿度-14
		'txtMaxHumi'		// 最高湿度-15
		
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

 /// 保存-获取收费项数据
function GetSaveTarList(){
	var saveTarCondition=[
		'cmbTarSubCat',		// 子分类
		'cmbTarInCat',		// 住院子分类
		'cmbTarOutCat',		// 门诊子分类
		'cmbTarAcctCat',	// 核算子分类
		'cmbTarMedCat',		// 病案首页分类
		'cmbTarAccSubCat',	// 会计子分类
		'cmbTarNewMedCat'	// 新病案首页		
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

/// 别名修改
function IncAliasEdit(btnId){
	var modifyType=DHCSTEASYUI.GetModifyType(btnId);
	var dataSelected=$('#incAliasGrid').datagrid('getSelected');
	var incAliasId=dataSelected?dataSelected.incAliasId:"";
	var aliasText=$("#txtIncAlias").val().trim();
	if ((modifyType=="A")||(modifyType=="U")){
		if(urlIncItmId==""){
			$.messager.alert("提示","请先保存库存项信息!","warning");
			return;			
		}
		if (aliasText==""){
			$.messager.alert("提示","请录入别名!","warning");
			return;
		}
		if (modifyType=="A"){
			incAliasId="";
		}else{
			if (incAliasId==""){
				$.messager.alert("提示","请选择记录!","warning");
				return;
			}
		}
		var aliasStr=incAliasId+"^"+aliasText;
		var saveRet=tkMakeServerCall("web.DHCST.INCALIAS","Save",urlIncItmId,aliasStr);
		if (saveRet==0){
			$.messager.alert("成功提示",((modifyType=="A")?"增加":"修改")+"成功!","info");
			$("#incAliasGrid").datagrid('reload');
		}else{
			$.messager.alert("错误提示",((modifyType=="A")?"增加":"修改")+"失败,错误代码:"+saveRet+"!","error");
		}
	}else if (modifyType=="D"){
		if (incAliasId==""){
			$.messager.alert("提示","请选择记录!","warning");
			return;
		}
		var delRet=tkMakeServerCall("web.DHCST.INCALIAS","Delete",incAliasId);
		if (delRet==0){
			$.messager.alert("成功提示","删除成功!","info");
			$("#incAliasGrid").datagrid('reload');
		}else{
			$.messager.alert("错误提示","删除失败,错误代码:"+delRet+"!","error");
		}
	}
}

/// 发药单位修改
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
			$.messager.alert("提示","请选择科室!","warning");
			return;
		}
		if (dispUomId==""){
			$.messager.alert("提示","请选择单位!","warning");
			return;
		}
		if (modifyType=="A"){
			ilduId="";
		}else{
			if (ilduId==""){
				$.messager.alert("提示","请选择记录!","warning");
				return;
			}
		}
		var dispUomStr=ilduId+"^"+dispUomId+"^"+activeFlag+"^"+startDate+"^"+endDate;
		var saveRet=tkMakeServerCall("web.DHCST.DispUom","Save",phaLocId,"",dispUomStr,urlIncItmId);
		if (saveRet==0){
			$.messager.alert("成功提示",((modifyType=="A")?"增加":"修改")+"成功!","info");
			$("#dispUomGrid").datagrid('reload');
		}else{
			var saveArr=saveRet.toString().split("^");
			if ((saveArr[0]<0)&&(saveArr[1]||""!="")){
				$.messager.alert(((modifyType=="A")?"增加":"修改")+"提示",saveArr[1],"warning");			
			}else{
				$.messager.alert("错误提示",((modifyType=="A")?"增加":"修改")+"失败,不存在和基本单位的转换系数!","error");
			}
		}
	}else if (modifyType=="D"){
		if (ilduId==""){
			$.messager.alert("提示","请选择记录!","warning");
			return;
		}
		var delRet=tkMakeServerCall("web.DHCST.DispUom","DeleteDispUomInfo",ilduId);
		if (delRet==0){
			$.messager.alert("成功提示","删除成功!","info");
			$("#dispUomGrid").datagrid('reload');
		}else{
			$.messager.alert("错误提示","删除失败,错误代码:"+delRet+"!","error");
		}
	}
}

/*************初始化信息********************/
function InitIncDict(){
	var options={
		ClassName:"web.DHCST.Util.DrugUtilQuery",
		QueryName:"",
		StrParams:""		
	};
	var tmpOptions={};
	/// 基本单位
	tmpOptions={
		QueryName:"GetCTUom"
    };
	$("#cmbIncBaseUom").dhcstcomboeu($.extend({},options,tmpOptions));
	/// 门诊发药单位
	$("#cmbIncOutBaseUom").dhcstcomboeu($.extend({},options,tmpOptions));
	/// 住院发药单位
	$("#cmbIncInBaseUom").dhcstcomboeu($.extend({},options,tmpOptions));
	/// 入库单位
	$("#cmbIncPurchUom").dhcstcomboeu($.extend({},options,tmpOptions));
	/// 大包装单位
	$("#cmbIncPackUom").dhcstcomboeu($.extend({},options,tmpOptions));
    /// 发药单位
    $("#cmbDispUom").dhcstcomboeu($.extend({},options,tmpOptions));
	/// 账簿分类
	tmpOptions={
		QueryName:'GetBookCat'
	};
	$("#cmbBookCat").dhcstcomboeu($.extend({},options,tmpOptions));
	/// 定价类型
	tmpOptions={
		QueryName:'GetMarkType'
	};
	$("#cmbMarkType").dhcstcomboeu($.extend({},options,tmpOptions));
	/// 招标名称
	tmpOptions={
		QueryName:'GetPublicBiddingList'
	};
	$("#cmbPbName").dhcstcomboeu($.extend({},options,tmpOptions));
	/// 招标级别 
	tmpOptions={
		QueryName:'GetPBLevel'
	};
	$("#cmbPbLevel").dhcstcomboeu($.extend({},options,tmpOptions));
	/// 招标生产商
 	tmpOptions={
	 	ClassName:"web.DHCST.Util.OrgUtilQuery",
		QueryName:"GetPhManufacturer",
    }
    $("#cmbPbManf").dhcstcomboeu($.extend({},options,tmpOptions)); 
	/// 招标供应商
 	tmpOptions={
	 	ClassName:"web.DHCST.Util.OrgUtilQuery",
		QueryName:"GetAPCVendor",
    }
    $("#cmbPbVendor").dhcstcomboeu($.extend({},options,tmpOptions)); 
	/// 招标配送商
 	tmpOptions={
	 	ClassName:"web.DHCST.Util.OrgUtilQuery",
		QueryName:"GetCarrier",
    }
    $("#cmbPbCarrier").dhcstcomboeu($.extend({},options,tmpOptions)); 
	/// 进口标志
 	tmpOptions={
		QueryName:"GetImportFlag",
    }
    $("#cmbInciImport").dhcstcomboeu($.extend({},options,tmpOptions));
    /// 质量层次
 	tmpOptions={
		QueryName:"GetQualityLevel",
    }
    $("#cmbQualityLev").dhcstcomboeu($.extend({},options,tmpOptions));
	/// 不可用原因
 	tmpOptions={
		QueryName:"GetItmNotUseReason",
    }
    $("#cmbNotUseReason").dhcstcomboeu($.extend({},options,tmpOptions));
    /// 批准文号
    tmpOptions={
		QueryName:"GetOfficeCode",
		StrParams:"Gp"
    }
    $("#cmbIncRemark1").dhcstcomboeu($.extend({},options,tmpOptions)); 
	/// 子分类
    tmpOptions={
		QueryName:"GetTarSubCate",
    }
    $("#cmbTarSubCat").dhcstcomboeu($.extend({},options,tmpOptions)); 
	/// 门诊子分类
    tmpOptions={
		QueryName:"GetTarOutpatCate",
    }
    $("#cmbTarOutCat").dhcstcomboeu($.extend({},options,tmpOptions)); 
	/// 住院子分类
    tmpOptions={
		QueryName:"GetTarInpatCate",
    }
    $("#cmbTarInCat").dhcstcomboeu($.extend({},options,tmpOptions)); 
	/// 会计子分类
    tmpOptions={
		QueryName:"GetTarAcctCate",
    }
    $("#cmbTarAccSubCat").dhcstcomboeu($.extend({},options,tmpOptions)); 
	/// 核算子分类
    tmpOptions={
		QueryName:"GetTarEMCCate",
    }
    $("#cmbTarAcctCat").dhcstcomboeu($.extend({},options,tmpOptions));
	/// 病案首页分类
    tmpOptions={
		QueryName:"GetTarMRCate",
    }
    $("#cmbTarMedCat").dhcstcomboeu($.extend({},options,tmpOptions));
	/// 新病案首页 
    tmpOptions={
		QueryName:"GetTarNewMRCate",
    }
    $("#cmbTarNewMedCat").dhcstcomboeu($.extend({},options,tmpOptions));
	/// 不可退药原因 
    tmpOptions={
	    ClassName:"web.DHCST.Util.OtherUtilQuery",
		QueryName:"GetRefRetReason",
    }
    $("#cmbRefReturn").dhcstcomboeu($.extend({},options,tmpOptions));
	/// 库存分类
	tmpOptions={
		ClassName:"web.DHCST.Util.DrugUtilQuery",
		QueryName:"GetINCSCStkGrp",
		StrParams:""
    }
    $("#cmbStkCat").dhcstcomboeu($.extend({},options,tmpOptions));
	/// 科室下拉 
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
    /// 转移方式
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
    /// 批次要求
	tmpOptions={
		data: [
			{RowId: 'REQUIRED',Description: '要求'},
			{RowId: 'NONREQUIRED',Description: '不要求'},
			{RowId: 'OPTIONAL',Description: '随意'}
		],
		editable:false
	};
    $("#cmbBatchReq").dhcstcomboeu($.extend({},options,tmpOptions));
    $("#cmbBatchReq").combobox('setValue','REQUIRED');
    /// 效期要求
    $("#cmbExpReq").dhcstcomboeu($.extend({},options,tmpOptions));
    $("#cmbExpReq").combobox('setValue','REQUIRED');   
    /// 价格生效日期
    $("#dtPriceExeDate").datebox({});
    /// 物价备案日期
	$("#dtPrcFileDate").datebox({});
    /// 医嘱截止日期 
	$("#dtOrdEndDate").datebox({});
}

/// 库存项别名列表
function InitIncAliasGrid(){
	var gridColumns=[[  
		{field:'incAliasId',title:'别名表ID',width:300,hidden:true}, 
		{field:'incAliasText',title:'库存项别名',width:300,hidden:false}
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

/// 发药单位列表
function InitDispUomGrid(){
	var gridColumns=[[  
		{field:'ilduId',title:'ilduId',width:155,hidden:true,align:'center'},
		{field:'locId',title:'科室Id',width:145,hidden:true,align:'center'},
		{field:'uomId',title:'单位Id',width:145,hidden:true,align:'center'},
		{field:'uomDesc',title:'单位描述',width:200,hidden:false},
		{field:'active',title:'激活标志',width:100,hidden:false,align:'center'},
		{field:'startDate',title:'开始日期',width:150,hidden:false,align:'center'},
		{field:'endDate',title:'结束日期',width:150,hidden:false,align:'center'}
		
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

/// 所有控件重新赋值
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
				alert("获取数据失败!");
			},
			success:function(retData){
				SetIncItmValues(retData)
			}
		})	
	}
	
}

/// 库存项赋值
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

/// 根据Id取值
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

/// 验证必填以及其他
function CheckRequied(value,id){
	var msgText="";
	if (value==""){
		switch(id){
			case "txtIncCode":
				msgText="库存项代码为空";
			  	break;
			case "txtIncDesc":
				msgText="库存项名称为空";
				break;
			case "cmbIncBaseUom":
				msgText="基本单位为空";
				break;
			case "cmbIncPurchUom":
				msgText="入库单位为空";
				break;
			case "cmbIncOutBaseUom":
				msgText="门诊发药单位为空";
				break;
			case "cmbIncInBaseUom":
				msgText="住院发药单位为空";
				break;
			case "cmbStkCat":
				msgText="库存分类为空";
				break;
			case "cmbTarSubCat":
				msgText="子分类为空";
				break;
			case "cmbTarAcctCat":
				msgText="核算子分类为空";
				break;
			case "cmbTarMedCat":
				msgText="病案首页分类为空";
				break;
			case "cmbTarOutCat":
				msgText="门诊子分类为空";
				break;
			case "cmbTarAccSubCat":
				msgText="会计子分类为空";
				break;
			case "cmbTarNewMedCat":
				msgText="新病案首页为空";
				break;
			case "cmbTarInCat":
				msgText="住院子分类为空";
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