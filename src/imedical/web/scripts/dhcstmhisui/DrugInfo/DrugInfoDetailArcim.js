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
	}, function(jsonData){
		if(jsonData.success!=0){
			$UI.msg('error',jsonData.msg);
		}else{
			$UI.clearBlock('#InciData');
			$UI.clearBlock('#ArcimData');
			$UI.fillBlock('#InciData',jsonData.InciData);
			$UI.fillBlock('#ArcimData',jsonData.ArcimData);
			if (isEmpty(jsonData.ArcimData.Arc)) {
				$("#ArcCode").val($("#InciCode").val());
				$("#TariCode").val($("#InciCode").val());
				$("#ArcDesc").val($("#InciDesc").val());
				$("#TariDesc").val($("#InciDesc").val());
			/*	if(CodeMainParamObj['ArcimDescAutoMode'] == '1'){
					value=$("#InciDesc").val();
					spec=$("#Spec").val();
					if(!isEmpty(spec)){
						value = value+"["+spec+"]";
					}
				}else{
					 value=$("#InciDesc").val();
				}
				$("#ArcDesc").val(value);
				*/
				$('#BillUomBox').combobox({
					url:$URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetConUom&ResultSetType=array&UomId='+$('#BUom').combobox('getValue')
				});
			};
			$HUI.checkbox('#ChargeFlag').setValue(true);
		}
	});	
}
var initDetail=function(){
	$UI.linkbutton('#SaveArcBT',{
		onClick:function(){
			Save();
		}
	});
	var Save =function(){
		var InciObj=$UI.loopBlock('#InciData');
		var IncData=JSON.stringify(InciObj);
		var ArcObj=$UI.loopBlock('#ArcimData');
		var ArcData=JSON.stringify(ArcObj);
		var SearchDataObj=$UI.loopBlock('#Conditions');
		var SearchData = JSON.stringify(jQuery.extend(true,SearchDataObj,{BDPHospital:GetHospId()}));
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DrugInfoMaintain',
			MethodName: 'SaveData',
			ArcData: ArcData,
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
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTUom&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description'
		});
	var PUom= $HUI.combobox('#PUom', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTUom&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description'
		});	
	$('#StkGrpBox').combotree({
		onClick:function(node){
			StkCatBox.clear();
			var url=$URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array&StkGrpId='+node.id;
			StkCatBox.reload(url);
		}
	});
	var StkCatBox = $HUI.combobox('#StkCatBox', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	var BookCatBox = $HUI.combobox('#BookCatBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetBookCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	var SupervisionBox = $HUI.combobox('#SupervisionBox', {
		data:[{'RowId':'I','Description':'I'},{'RowId':'II','Description':'II'},{'RowId':'III','Description':'III'},{'RowId':'IV','Description':'IV'},{'RowId':'V','Description':'V'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var MarkTypeBox = $HUI.combobox('#MarkTypeBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetMarkType&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	var ChargeTypeBox = $HUI.combobox('#ChargeTypeBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetChargeType&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	var ManfParams=JSON.stringify(addSessionParams({}));
	var ManfBox = $HUI.combobox('#ManfBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params='+ManfParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var PbBox = $HUI.combobox('#PbBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPublicBidding&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	var PbVendorParams=JSON.stringify(addSessionParams({APCType:"M",RcFlag:"Y"}));
	var PbVendorBox = $HUI.combobox('#PbVendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+PbVendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var PbCarrier = $HUI.combobox('#PbCarrier', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCarrier&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});	
	var PbLevel = $HUI.combobox('#PbLevel', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPBLevel&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	var OriginBox = $HUI.combobox('#OriginBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOrigin&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	var ImportFlagBox = $HUI.combobox('#ImportFlagBox', {
		data:[{'RowId':'国产','Description':'国产'},{'RowId':'进口','Description':'进口'},{'RowId':'合资','Description':'合资'}],
		valueField: 'RowId',
		textField: 'Description'
	});	
	var SterileCatBox = $HUI.combobox('#SterileCatBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSterileCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});	
	var QualityLevelBox = $HUI.combobox('#QualityLevelBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetQualityLevel&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});	
	var PackUomBox= $HUI.combobox('#PackUomBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTUom&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	var NotUseReasonBox= $HUI.combobox('#NotUseReasonBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetNotUseReason&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	var SupplyLocBoxParams=JSON.stringify(addSessionParams({Type:'All'}));
	var SupplyLocBox = $HUI.combobox('#SupplyLocBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+SupplyLocBoxParams,
		valueField: 'RowId',
		textField: 'Description'
	});	
	var FirstReqLocBoxParams=JSON.stringify(addSessionParams({Type:'All'}));
	var FirstReqLocBox = $HUI.combobox('#FirstReqLocBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+FirstReqLocBoxParams,
		valueField: 'RowId',
		textField: 'Description'
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
	/////医嘱项///////////////////
	var OrdCatBox= $HUI.combobox('#OrdCatBox', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOrdCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onSelect:function(record){
			OrdSubCatBox.clear();
			var Params = JSON.stringify(addSessionParams({BDPHospital:GetHospId()}));
			var url=$URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOrdSubCat&ResultSetType=array&OrdCat='+record.RowId+'&Params='+Params;
			OrdSubCatBox.reload(url);
		},
		onShowPanel : function () {
			OrdCatBox.clear();
			var Params = JSON.stringify(addSessionParams({BDPHospital:GetHospId()}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOrdCat&ResultSetType=array&Params='+Params;
			OrdCatBox.reload(url);
		}
	});
	var OrdSubCatBox= $HUI.combobox('#OrdSubCatBox', {
		valueField: 'RowId',
		textField: 'Description'
	});	
	var BillCatBox= $HUI.combobox('#BillCatBox', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetBillCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onSelect:function(record){
			BillSubCatBox.clear();
			var Params = JSON.stringify(addSessionParams({BDPHospital:GetHospId()}));
			var url=$URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetBillSubCat&ResultSetType=array&BillCat='+record.RowId+'&Params='+Params;
			BillSubCatBox.reload(url);
		},
		onShowPanel : function () {
			BillCatBox.clear();
			var Params = JSON.stringify(addSessionParams({BDPHospital:GetHospId()}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetBillCat&ResultSetType=array&Params='+Params;
			BillCatBox.reload(url);
		}
	});
	var BillSubCatBox= $HUI.combobox('#BillSubCatBox', {
		valueField: 'RowId',
		textField: 'Description'
	});		
	var BillUomBox= $HUI.combobox('#BillUomBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTUom&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});	
	var PriorityBox= $HUI.combobox('#PriorityBox', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOECPriority&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel : function () {
			PriorityBox.clear();
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOECPriority&ResultSetType=array';
			PriorityBox.reload(url);
		}
	});
	var TarSubCatBox= $HUI.combobox('#TarSubCatBox', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarSubCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel : function () {
			TarSubCatBox.clear();
			var Params = JSON.stringify(addSessionParams({BDPHospital:GetHospId()}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarSubCat&ResultSetType=array&Params='+Params;
			TarSubCatBox.reload(url);
		}
	});
	var TarInpatCatBox= $HUI.combobox('#TarInpatCatBox', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarInpatCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel : function () {
			TarInpatCatBox.clear();
			var Params = JSON.stringify(addSessionParams({BDPHospital:GetHospId()}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarInpatCat&ResultSetType=array&Params='+Params;
			TarInpatCatBox.reload(url);
		}
	});
	var TarOutpatCatBox= $HUI.combobox('#TarOutpatCatBox', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarOutpatCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel : function () {
			TarOutpatCatBox.clear();
			var Params = JSON.stringify(addSessionParams({BDPHospital:GetHospId()}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarOutpatCat&ResultSetType=array&Params='+Params;
			TarOutpatCatBox.reload(url);
		}
	});
	var TarEMCCatBox= $HUI.combobox('#TarEMCCatBox', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarEMCCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel : function () {
			TarEMCCatBox.clear();
			var Params = JSON.stringify(addSessionParams({BDPHospital:GetHospId()}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarEMCCat&ResultSetType=array&Params='+Params;
			TarEMCCatBox.reload(url);
		}
	});
	var TarAcctCatBox= $HUI.combobox('#TarAcctCatBox', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarAcctCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel : function () {
			TarAcctCatBox.clear();
			var Params = JSON.stringify(addSessionParams({BDPHospital:GetHospId()}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarAcctCat&ResultSetType=array&Params='+Params;
			TarAcctCatBox.reload(url);
		}
	});
	var TarMRCatBox= $HUI.combobox('#TarMRCatBox', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarMRCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel : function () {
			TarMRCatBox.clear();
			var Params = JSON.stringify(addSessionParams({BDPHospital:GetHospId()}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarMRCat&ResultSetType=array&Params='+Params;
			TarMRCatBox.reload(url);
		}
	});
	var TarNewMRCatBox= $HUI.combobox('#TarNewMRCatBox', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarNewMRCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel : function () {
			TarNewMRCatBox.clear();
			var Params = JSON.stringify(addSessionParams({BDPHospital:GetHospId()}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarNewMRCat&ResultSetType=array&Params='+Params;
			TarNewMRCatBox.reload(url);
		}
	});
	$("#InciData :input").attr('disabled', true);
	$("#InciData .combo-f").each(function(){
		$(this).combo({disabled:true});
	})
	InitCompStat();
	$HUI.tabs("#InciArcTab",{
		onSelect:function(title){
			if (title=="医嘱项"){
				var BUom=$("#BUom").combo('getValue');
				$HUI.combobox("#BillUomBox").setValue(BUom);
			}
		}
	});
}
//根据配置控制界面控件
function InitCompStat() {
	if (CodeMainParamObj['SameCode'] == "N") {
		$('#ArcCode').removeAttr("disabled");
	} else {
		$('#ArcCode').attr("disabled", "disabled");
	}
	function InciCodeValChange() {
		$("#ArcCode").val($("#InciCode").val());
		$("#TariCode").val($("#InciCode").val());
	}
	$("#InciCode").bind("change", function () {
		InciCodeValChange();
	});
	if (CodeMainParamObj['SameDesc'] == "N") {
		$('#ArcDesc').removeAttr("disabled");
	} else {
		$('#ArcDesc').attr("disabled", "disabled");
	}
	function InciDescValChange() {
		if (CodeMainParamObj['ArcimDescAutoMode'] == 1) {
			var value = $("#InciDesc").val();
			var spec = $("#Spec").val();
			if (!isEmpty(spec)) {
				value = value + "[" + $("#Spec").val() + "]";
			}
		} else if (CodeMainParamObj['ArcimDescAutoMode'] == 2) {
			var value = $("#InciDesc").val();
			var spec = $("#Spec").val();
			var model = $("#Model").val();
			if (!isEmpty(spec)) {
				value = value + "[" + spec + "][" + model + "]";
			}
		} else {
			var value = $("#InciDesc").val();
		}
		$("#ArcDesc").val(value);
		$("#TariDesc").val(value);
	}
	$("#InciDesc").bind("change", function () {
		InciDescValChange();
	});
	$("#Spec").bind("change", function () {
		InciDescValChange();
	});
	$("#Model").bind("change", function () {
		InciDescValChange();
	});
	if (CodeMainParamObj['ModifyBillCode'] == "N") {
		$('#TariCode').attr("disabled", "disabled");
		$('#TariDesc').attr("disabled", "disabled");
	} else {
		$('#TariCode').removeAttr("disabled");
		$('#TariDesc').removeAttr("disabled");
	}
	function ArcValChange() {
		$("#TariCode").val($("#ArcCode").val());
		$("#TariDesc").val($("#ArcDesc").val());
	}
	$("#ArcCode").bind("change", function () {
		ArcValChange();
	});
	$("#ArcDesc").bind("change", function () {
		ArcValChange();
	});
	if (CodeMainParamObj['SetNotUseFlagEdit'] == "Y") {
		$HUI.checkbox('#NotUseFlag').disable();
	}
	$('#FeeFlag').on('ifChecked', function (event) {
		$('#TariCode').attr("disabled", "disabled");
		$('#TariDesc').attr("disabled", "disabled");
		$('#TarSubCatBox').combobox({ disabled: true });
		$('#TarInpatCatBox').combobox({ disabled: true });
		$('#TarOutpatCatBox').combobox({ disabled: true });
		$('#TarEMCCatBox').combobox({ disabled: true });
		$('#TarAcctCatBox').combobox({ disabled: true });
		$('#TarMRCatBox').combobox({ disabled: true });
		$('#TarNewMRCatBox').combobox({ disabled: true });
	});
	$('#FeeFlag').on('ifUnchecked', function (event) {
		$('#TariCode').removeAttr("disabled");
		$('#TariDesc').removeAttr("disabled");
		$('#TarSubCatBox').combobox({ disabled: false });
		$('#TarInpatCatBox').combobox({ disabled: false });
		$('#TarOutpatCatBox').combobox({ disabled: false });
		$('#TarEMCCatBox').combobox({ disabled: false });
		$('#TarAcctCatBox').combobox({ disabled: false });
		$('#TarMRCatBox').combobox({ disabled: false });
		$('#TarNewMRCatBox').combobox({ disabled: false });
		if (CodeMainParamObj['ModifyBillCode'] == "N") {
			$('#TariCode').attr("disabled", "disabled");
			$('#TariDesc').attr("disabled", "disabled");
		} else {
			$('#TariCode').removeAttr("disabled");
			$('#TariDesc').removeAttr("disabled");
		}
	});
	//设置收费标志是否可编辑
	if (CodeMainParamObj['SetChargeFlagEdit'] == "Y") {
		$('#ChargeFlag').attr("disabled", "disabled");
	}else{
		$('#ChargeFlag').removeAttr("disabled");
	}
}
