//根据RowId查询
function GetHospId() {
	var HospId="";
	if ($("#_HospList").length!=0){
		HospId=$HUI.combogrid('#_HospList').getValue();
	}else{
		HospId=gHospId;
	}
	return HospId;
}
function GetDetail(RowId) {
	$.cm({
		ClassName: 'web.DHCSTMHUI.DrugInfoMaintain',
		MethodName: 'GetDetail',
		InciId:RowId,
		HospId: GetHospId()
	}, function (jsonData) {
		if(jsonData.success!=0){
			$UI.msg('error',jsonData.msg);
		}else{
			$UI.clearBlock('#BasicInciData');
			$UI.fillBlock('#BasicInciData',jsonData.InciData);
			var UseFlag=$('#UseFlag' ).val();  ///是否已经使用 1 使用 0 未使用
			ChangeState(UseFlag);
		}
	});
}
var ChangeState=function(UseFlag){
	if (UseFlag == 1) {
		$HUI.combobox("#BUom").disable();
		$('#RpPUom').attr("disabled","disabled");
		$HUI.datebox("#PreExeDate").disable();
	} else {
		$HUI.combobox("#BUom").enable();
		$('#RpPUom').removeAttr("disabled");
		$HUI.datebox("#PreExeDate").enable();
	}
}
var initDetail=function(){
	$UI.linkbutton('#AddInciBT',{
		onClick:function(){
			$UI.clearBlock("#BasicInciData");
			ChangeState(0);
		}
	});
	$UI.linkbutton('#SaveInciBT',{
		onClick:function(){
			Save();
		}
	});
	$UI.linkbutton('#AddSaveInciBT',{
		onClick:function(){
			//前期处理
			$('#Inci').val('');
			$('#InciCode').val('');
			$('#PreExeDate').datebox('setValue', '');
			$HUI.combobox("#BUom").enable();
			$('#RpPUom').removeAttr("disabled");
			$HUI.datebox("#PreExeDate").enable();
			//Save();
		}
	});
	$UI.linkbutton('#GetMaxCodeBT',{
		onClick:function(){
			GetMaxCode();
		}
	});
	$UI.linkbutton('#UpPicBT',{
		onClick:function(){
			UpLoader();
		}
	});
	$UI.linkbutton('#ViewPicBT',{
		onClick:function(){
			ViewPic();
		}
	});
	$UI.linkbutton('#SciBT',{
		onClick: function(){
			GetSciItm();
		}
	});
	$UI.linkbutton('#InciCfgBT',{
		onClick:function(){
			MustInputSet('#BasicInciData');
		}
	});
	$UI.linkbutton('#SpecBT',{
		onClick:function(){
			IncSpecEdit();
		}
	});
	$UI.linkbutton('#AliasBT',{
		onClick:function(){
			IncAliasEdit();
		}
	});
	$UI.linkbutton('#StoreCondBT',{
		onClick:function(){
			GetStoreCon();
		}
	});
	$UI.linkbutton('#ZeroBT',{
		onClick:function(){
			HospZeroStkEdit();
		}
	});
	$UI.linkbutton('#LinkArcimBT',{
		onClick:function(){
			GetArcforLinkInci();
		}
	});
	$UI.linkbutton('#RegCertNoBT',{
		onClick:function(){
			var regNo=$("#RegCertNo").val();
			var Incid=$("#Inci").val();
			if (isEmpty(Incid)){
				$UI.msg('alert','请先维护物资信息！')
				return false;
			}
			var InciObj=$UI.loopBlock('#BasicInciData')
			var ManfId=InciObj.Manf;
			if (isEmpty(ManfId)){
				$UI.msg('alert','请先维护厂商！')
				return false;
			}
			if (isEmpty(regNo)){
				$UI.msg('alert','请先填写注册证号！')
				return false;
			}
			RegNoInfo(regNo,Incid+"^"+ManfId);
		}
	});	
	var Save =function(){
		var InciObj=$UI.loopBlock('#BasicInciData')
		if(!$UI.checkMustInput('#BasicInciData',InciObj)){
			$UI.msg('alert','请先填写必填项！');
			return;
		}
		var IncData = JSON.stringify(InciObj);
		var SearchDataObj=$UI.loopBlock('#Conditions');
		var SearchData = JSON.stringify(jQuery.extend(true,SearchDataObj,{BDPHospital:GetHospId()}));
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DrugInfoMaintain',
			MethodName: 'SaveData',
			IncData: IncData,
			SearchData:SearchData
		},function(jsonData){
			hideMask();
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				GetDetail(jsonData.rowid);
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	}
	var BUom= $HUI.combobox('#BUom', {
			//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTUom&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			onChange:function(newValue, oldValue){
				if(!isEmpty(oldValue)){
					PUom.clear();
				}
				var url=$URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetConUom&ResultSetType=array&UomId='+newValue;
				PUom.reload(url);
			},
			onShowPanel: function () {
				//BUom.clear();		//clear影响onChange时的oldValue使用
				var url=$URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTUom&ResultSetType=array';
				BUom.reload(url);
			}
		});
	var PUom= $HUI.combobox('#PUom', {
			//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetConUom&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description'
		});
	var StkCatBox = $HUI.combobox('#StkCatBox', {
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function () {
			var scg=$("#StkGrpBox").combotree('getValue');
			var Params=JSON.stringify(addSessionParams({BDPHospital:GetHospId()}));
			StkCatBox.clear();
			var url=$URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array&StkGrpId=' + scg+'&Params='+Params;
			StkCatBox.reload(url);
		}
	});
	var BookCatBox = $HUI.combobox('#BookCatBox', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetBookCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function () {
			BookCatBox.clear();
			var Params=JSON.stringify(addSessionParams({BDPHospital:GetHospId()}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetBookCat&ResultSetType=array&Params='+Params;
			BookCatBox.reload(url);
		}
	});
	var SupervisionBox = $HUI.combobox('#SupervisionBox', {
		data:[{'RowId':'I','Description':'I'},{'RowId':'II','Description':'II'},{'RowId':'III','Description':'III'},{'RowId':'IV','Description':'IV'},{'RowId':'V','Description':'V'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var MarkTypeBox = $HUI.combobox('#MarkTypeBox', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetMarkType&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function () {
			MarkTypeBox.clear();
			var Params=JSON.stringify(addSessionParams({BDPHospital:GetHospId()}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetMarkType&ResultSetType=array&Params='+Params;
			MarkTypeBox.reload(url);
		}
	});
	var ChargeTypeBox = $HUI.combobox('#ChargeTypeBox', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetChargeType&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function () {
			ChargeTypeBox.clear();
			var Params=JSON.stringify(addSessionParams({BDPHospital:GetHospId()}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetChargeType&ResultSetType=array&Params='+Params;
			ChargeTypeBox.reload(url);
		}
	});
	
	var ManfBox = $HUI.combobox('#ManfBox', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params='+ManfParams,
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel : function () {
			ManfBox.clear();
			var ManfParams = JSON.stringify(addSessionParams({
				StkType: "M",
				BDPHospital:GetHospId()
			}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params='+ManfParams;
			ManfBox.reload(url);
		}
	});
	var PbBox = $HUI.combobox('#PbBox', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPublicBidding&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onChange: function (newValue, oldValue) {
			PbLevel.clear();
			var Params = JSON.stringify(addSessionParams({ Pb: newValue,BDPHospital:GetHospId() }));
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPBLevel&ResultSetType=array&Params='+Params;
			PbLevel.reload(url);
		},
		onShowPanel : function () {
			PbBox.clear();
			var Params = JSON.stringify(addSessionParams({BDPHospital:GetHospId()}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPublicBidding&ResultSetType=array&Params='+Params;
			PbBox.reload(url);
		}
	});
	
	var PbVendorBox = $HUI.combobox('#PbVendor', {
			//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+PbVendorParams,
			valueField: 'RowId',
			textField: 'Description',
			onShowPanel : function () {
				PbVendorBox.clear();
			var PbVendorParams = JSON.stringify(addSessionParams({
				APCType: "M",
				RcFlag: "Y",
				BDPHospital:GetHospId()
			}));
				var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+PbVendorParams;
				PbVendorBox.reload(url);
			}
	});
	var PbCarrier = $HUI.combobox('#PbCarrier', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCarrier&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
			onShowPanel : function () {
				PbCarrier.clear();
			var Params = JSON.stringify(addSessionParams({BDPHospital:GetHospId()}));
				var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCarrier&ResultSetType=array&Params='+Params;
				PbCarrier.reload(url);
			}
	});
	var PbLevel = $HUI.combobox('#PbLevel', {
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess:function(){
			var data=$(this).combobox('getData');
			if (data.length > 0) {
				$(this).combobox('select',data[0].RowId);
			}
		}
	});
	var OriginBox = $HUI.combobox('#OriginBox', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOrigin&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel : function () {
			OriginBox.clear();
			var Params = JSON.stringify(addSessionParams());
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOrigin&ResultSetType=array&Params='+Params;
			OriginBox.reload(url);
		}
	});
	var ImportFlagBox = $HUI.combobox('#ImportFlagBox', {
		data:[{'RowId':'国产','Description':'国产'},{'RowId':'进口','Description':'进口'},{'RowId':'合资','Description':'合资'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var SterileCatBox = $HUI.combobox('#SterileCatBox', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSterileCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel : function () {
			SterileCatBox.clear();
			var Params = JSON.stringify(addSessionParams({BDPHospital:GetHospId()}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSterileCat&ResultSetType=array&Params='+Params;
			SterileCatBox.reload(url);
		}
	});
	var QualityLevelBox = $HUI.combobox('#QualityLevelBox', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetQualityLevel&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel : function () {
			QualityLevelBox.clear();
			var Params = JSON.stringify(addSessionParams({BDPHospital:GetHospId()}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetQualityLevel&ResultSetType=array&Params='+Params;
			QualityLevelBox.reload(url);
		}
	});
	var PackUomBox= $HUI.combobox('#PackUomBox', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTUom&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel : function () {
			PackUomBox.clear();
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTUom&ResultSetType=array';
			PackUomBox.reload(url);
		}
	});
	var NotUseReasonBox= $HUI.combobox('#NotUseReasonBox', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetNotUseReason&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel : function () {
			NotUseReasonBox.clear();
			var Params = JSON.stringify(addSessionParams({BDPHospital:GetHospId()}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetNotUseReason&ResultSetType=array&Params='+Params;
			NotUseReasonBox.reload(url);
		}
	});
	var SupplyLocBox = $HUI.combobox('#SupplyLocBox', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+SupplyLocBoxParams,
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel : function () {
			SupplyLocBox.clear();
			var SupplyLocBoxParams = JSON.stringify(addSessionParams({
				Type: 'All',
				BDPHospital:GetHospId()
			}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+SupplyLocBoxParams;
			SupplyLocBox.reload(url);
		}
	});
	var FirstReqLocBox = $HUI.combobox('#FirstReqLocBox', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+FirstReqLocBoxParams,
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel : function () {
			FirstReqLocBox.clear();
			var FirstReqLocBoxParams = JSON.stringify(addSessionParams({
				Type: 'All',
				BDPHospital:GetHospId()
			}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+FirstReqLocBoxParams;
			FirstReqLocBox.reload(url);
		}
	});
	var BatchNoReq = $HUI.combobox('#BatchNoReq', {
		data:[{'RowId':'R','Description':'要求'},{'RowId':'N','Description':'不要求'},{'RowId':'O','Description':'随意'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var ExpDateReq = $HUI.combobox('#ExpDateReq', {
		data:[{'RowId':'R','Description':'要求'},{'RowId':'N','Description':'不要求'},{'RowId':'O','Description':'随意'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var ReqTypeBox = $HUI.combobox('#ReqTypeBox', {
		data:[{'RowId':'','Description':''},{'RowId':'O','Description':'临时请求'},{'RowId':'C','Description':'申请计划'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var RiskCategoryBox = $HUI.combobox('#RiskCategoryBox', {
		data:[{'RowId':'I','Description':'I'},{'RowId':'II','Description':'II'},{'RowId':'III','Description':'III'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var ConsumableLevelBox = $HUI.combobox('#ConsumableLevelBox', {
		data:[{'RowId':'I','Description':'I'},{'RowId':'II','Description':'II'},{'RowId':'III','Description':'III'}],
		valueField: 'RowId',
		textField: 'Description'
	});	
	var OfficialBox = $HUI.combobox('#OfficialBox', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOfficial&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel : function () {
			OfficialBox.clear();
			var Params = JSON.stringify(addSessionParams());
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOfficial&ResultSetType=array&Params='+Params;
			OfficialBox.reload(url);
		}
	});	
	$("#RegCertNo").bind("change", function () {
		var regNo=$("#RegCertNo").val();
		setRegInfo(regNo);
	});
	InitCompStat();
	ReSetMustInput('#BasicInciData');
}
//根据配置控制界面控件
function InitCompStat(){
	///是否允许录入进价
	if (CodeMainParamObj['AllowInputRp'] == "Y"){
		$('#RpPUom').removeAttr("disabled");
	}else{
		$('#RpPUom').attr("disabled","disabled");
	}
	if (CodeMainParamObj['SetInitStatusNotUse'] == "Y"){
		$HUI.checkbox('#NotUseFlag').setValue(true);
	}else{
		$HUI.checkbox('#NotUseFlag').setValue(false);
	}
	if (CodeMainParamObj['INCIBatchReq']){
		$HUI.combobox("#BatchNoReq").setValue(CodeMainParamObj['INCIBatchReq']);
	}
	if (CodeMainParamObj['INCIExpReq']){
		$HUI.combobox("#ExpDateReq").setValue(CodeMainParamObj['INCIExpReq']);
	}
	if(CodeMainParamObj['SetNotUseFlagEdit'] == "Y"){
		$HUI.checkbox('#NotUseFlag').disable();
	}

}