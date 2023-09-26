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
		InciId: RowId,
		HospId: GetHospId()
	}, function (jsonData) {
		if (jsonData.success != 0) {
			$UI.msg('error', jsonData.msg);
		} else {
			$UI.clearBlock('#InciData');
			$UI.clearBlock('#ArcimData');
			$UI.fillBlock('#InciData', jsonData.InciData);
			$UI.fillBlock('#ArcimData', jsonData.ArcimData);
			if (isEmpty(jsonData.ArcimData.Arc)) {
				$("#ArcCode").val($("#InciCode").val());
				$("#TariCode").val($("#InciCode").val());
				$("#ArcDesc").val($("#InciDesc").val());
				$("#TariDesc").val($("#InciDesc").val());
			}
			var UseFlag = $('#UseFlag').val(); ///是否已经使用 1 使用 0 未使用
			ChangeState(UseFlag);
		}
	});
}

var ChangeState = function (UseFlag) {
	if (UseFlag == 1) {
		$HUI.combobox("#BUom").disable();
		$('#SpPUom').attr("disabled", "disabled");
		$('#RpPUom').attr("disabled", "disabled");
		$('#PreExeDate').attr("disabled", "disabled");
	} else {
		$HUI.combobox("#BUom").enable();
		$('#SpPUom').removeAttr("disabled");
		$('#RpPUom').removeAttr("disabled");
		$('#PreExeDate').removeAttr("disabled");
	}
}
var initDetail = function () {
	
	var CatParams = JSON.stringify(addSessionParams({BDPHospital:GetHospId()}));
	
	$HUI.checkbox("#ChargeFlag", {
		onCheckChange: function (e, value) {
			if (value) {
				$('#tabs').tabs('enableTab', '医嘱项');
				InciDescValChange();
			} else {
				$('#tabs').tabs('disableTab', '医嘱项');
			}
		}
	});
	$HUI.tabs("#tabs",{
		onSelect:function(title,index){
			if(title=="医嘱项"){
				if (!(isEmpty($("#Inci").val()) && (CodeMainParamObj['ScMap'] == "G"))) {
					return;
				}
				var value = $HUI.checkbox('#HighPrice').getValue();
				if (value) {
					$.cm({
						ClassName: 'web.DHCSTMHUI.DrugInfoMaintain',
						MethodName: 'MapArcByHv',
						HvFlag: 'Y',
						Params:JSON.stringify(addSessionParams({Hospital:GetHospId()}))
					},function (ArcimData) {
						$UI.fillBlock('#ArcimData', ArcimData);
					});
				} else {
					$.cm({
						ClassName: 'web.DHCSTMHUI.DrugInfoMaintain',
						MethodName: 'MapArcByHv',
						HvFlag: 'N',
						Params:JSON.stringify(addSessionParams({Hospital:GetHospId()}))
					},function (ArcimData) {
						$UI.fillBlock('#ArcimData', ArcimData);
					});
				}
			}			
		}
	});
	$UI.linkbutton('#AddInciBT', {
		onClick: function () {
			$UI.clearBlock("#InciData");
			$UI.clearBlock("#ArcimData");
			$HUI.checkbox('#ChargeFlag').setValue(true);
			ChangeState(0);
			InitCompStat();
		}
	});
	$UI.linkbutton('#SaveInciBT', {
		onClick: function () {
			Save();
		}
	});
	$UI.linkbutton('#AddSaveInciBT', {
		onClick: function () {
			//前期处理
			$('#Inci').val('');
			$('#Arc').val('');
			$('#InciCode').val('');
			$('#ArcCode').val('');
			$('#TariCode').val('');
			$('#PreExeDate').dateboxq('setValue', '');
			$('#PreExeDate').dateboxq('enable');
			$HUI.combobox("#BUom").enable();
			$('#SpPUom').removeAttr("disabled");
			$('#RpPUom').removeAttr("disabled");
			//Save();
		}
	});
	$UI.linkbutton('#AddArcBT', {
		onClick: function () {
			$UI.clearBlock("#InciData");
			$UI.clearBlock("#ArcimData");
			$HUI.checkbox('#ChargeFlag').setValue(true);
			ChangeState(0);
		}
	});
	$UI.linkbutton('#SaveArcBT', {
		onClick: function () {
			Save();
		}
	});
	$UI.linkbutton('#AddSaveArcBT', {
		onClick: function () {
			//前期处理
			Save();
		}
	});
	$UI.linkbutton('#GetMaxCodeBT', {
		onClick: function () {
			GetMaxCode();
		}
	});
	$UI.linkbutton('#UpPicBT', {
		onClick: function () {
			UpLoader();
		}
	});
	$UI.linkbutton('#ViewPicBT', {
		onClick: function () {
			ViewPic();
		}
	});
	$UI.linkbutton('#InciCfgBT', {
		onClick: function () {
			MustInputSet('#InciData');
		}
	});
	$UI.linkbutton('#ArcCfgBT', {
		onClick: function () {
			MustInputSet('#ArcimData');
		}
	});
	$UI.linkbutton('#SpecBT', {
		onClick: function () {
			IncSpecEdit();
		}
	});
	$UI.linkbutton('#AliasBT', {
		onClick: function () {
			IncAliasEdit();
		}
	});
	$UI.linkbutton('#ArcAliasBT', {
		onClick: function () {
			OrdAliasEdit();
		}
	});
	$UI.linkbutton('#StoreCondBT', {
		onClick: function () {
			GetStoreCon();
		}
	});
	$UI.linkbutton('#ZeroBT', {
		onClick: function () {
			HospZeroStkEdit();
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
			var InciObj=$UI.loopBlock('#InciData')
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
	
	var Save = function () {
		var InciObj = $UI.loopBlock('#InciData');
		if (!$UI.checkMustInput('#InciData', InciObj)) {
			$UI.msg('alert', '请先填写必填项！');
			return;
		}
		var IncData = JSON.stringify(InciObj);
		
		var ArcTabDisableFlag = $('#tabs').tabs('getTab', '医嘱项').panel("options").tab.hasClass('tabs-disabled');
		var ArcObj = $UI.loopBlock('#ArcimData');
		if (!ArcTabDisableFlag && !$UI.checkMustInput('#ArcimData', ArcObj)) {
			$UI.msg('alert', '请先填写必填项！');
			return;
		}
		var ArcData = JSON.stringify(ArcObj);
		var SearchDataObj=$UI.loopBlock('#Conditions');
		var SearchData = JSON.stringify(jQuery.extend(true,SearchDataObj,{BDPHospital:GetHospId()}));
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DrugInfoMaintain',
			MethodName: 'SaveData',
			ArcData: ArcData,
			IncData: IncData,
			SearchData:SearchData
		}, function (jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				GetDetail(jsonData.rowid);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	var BUom = $HUI.combobox('#BUom', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTUom&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onChange: function (newValue, oldValue) {
			PUom.clear();
			BillUomBox.clear();
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetConUom&ResultSetType=array&UomId=' + newValue;
			PUom.reload(url);
			BillUomBox.reload(url);
			BillUomBox.setValue(newValue);
		},
		onShowPanel: function () {
			BUom.clear();
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTUom&ResultSetType=array';
			BUom.reload(url);
		}
	});
	var PUom = $HUI.combobox('#PUom', {
		valueField: 'RowId',
		textField: 'Description'
	});
	var StkCatBox = $HUI.combobox('#StkCatBox', {
		valueField: 'RowId',
		textField: 'Description',
		onChange: function (newValue, oldValue) {
			if (!(isEmpty($("#Inci").val()) && (CodeMainParamObj['ScMap'] == "Y"))) {
				return;
			};
			$.cm({
				ClassName: 'web.DHCSTMHUI.DrugInfoMaintain',
				MethodName: 'MapArc',
				StkCatId: newValue
			},function (ArcimData) {
				$UI.fillBlock('#ArcimData', ArcimData);
			});
		},
		onShowPanel: function () {
			var scg=$("#StkGrpBox").combotree('getValue');
			var Params=JSON.stringify(addSessionParams({BDPHospital:GetHospId()}));
			StkCatBox.clear();
			var url=$URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array&StkGrpId=' + scg+'&Params='+Params;
			StkCatBox.reload(url);
		}
	});
	/*$('#StkGrpBox').combotree({
		onClick: function(node) {
			StkCatBox.clear();
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array&StkGrpId=' + node.id;
			StkCatBox.reload(url);
		}
	});*/
	var BookCatBox = $HUI.combobox('#BookCatBox', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetBookCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function () {
			BookCatBox.clear();
			var Params=JSON.stringify(addSessionParams({BDPHospital:GetHospId()}));
			var url=$URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetBookCat&ResultSetType=array&Params='+Params;
			BookCatBox.reload(url);
		}
	});
	var SupervisionBox = $HUI.combobox('#SupervisionBox', {
		data: [{
			'RowId': 'I',
			'Description': 'I'
		}, {
			'RowId': 'II',
			'Description': 'II'
		}, {
			'RowId': 'III',
			'Description': 'III'
		}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var MarkTypeBox = $HUI.combobox('#MarkTypeBox', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetMarkType&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function (record) {
			var MarkType = record['RowId'];
			var RpPUom = $('#RpPUom').val();
			if (RpPUom != 0 && MarkType != "") {
				var MtSp = tkMakeServerCall('web.DHCSTMHUI.Common.PriceCommon', 'GetMarkTypeSp', MarkType, RpPUom);
				var Inci = $('#Inci').val();
				if(Inci==""){
				$('#SpPUom').val(MtSp);
				}
			}
		},
		onShowPanel: function () {   ///加载界面 不初始化数据 若需要初始化数据关联其他用途 可注释onShowPanel属性 将url放开 lihui
			MarkTypeBox.clear();
			var Params=JSON.stringify(addSessionParams({BDPHospital:GetHospId()}));
			var url=$URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetMarkType&ResultSetType=array&Params='+Params;
			MarkTypeBox.reload(url);
		}
	});
	$("#RpPUom").bind("change", function () {
		var RpPUom=$('#RpPUom').val();
		var MarkType =$("#MarkTypeBox").combo('getValue');
		if (RpPUom != 0 && MarkType != "") {
				var MtSp = tkMakeServerCall('web.DHCSTMHUI.Common.PriceCommon', 'GetMarkTypeSp', MarkType, RpPUom);
				$('#SpPUom').val(MtSp);
			}
		
	});	
	var ChargeTypeBox = $HUI.combobox('#ChargeTypeBox', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetChargeType&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function () {
			ChargeTypeBox.clear();
			var Params=JSON.stringify(addSessionParams({BDPHospital:GetHospId()}));
			var url=$URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetChargeType&ResultSetType=array&Params='+Params;
			ChargeTypeBox.reload(url);
		}
	});
	
	var ManfBox = $HUI.combobox('#ManfBox', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params=' + ManfParams,
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel : function () {
			ManfBox.clear();
			var ManfParams = JSON.stringify(addSessionParams({
				StkType: "M",
				BDPHospital:GetHospId()
			}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params=' + ManfParams;
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
	
	var PbVendorBox = $HUI.combobox('#PbVendor', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + PbVendorParams,
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel : function () {
			PbVendorBox.clear();
			var PbVendorParams = JSON.stringify(addSessionParams({
				APCType: "M",
				RcFlag: "Y",
				BDPHospital:GetHospId()
			}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + PbVendorParams;
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
	var OriginBox = $HUI.combobox('#OriginBox', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOrigin&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel : function () {
			OriginBox.clear();
			var Params = JSON.stringify(addSessionParams({BDPHospital:GetHospId()}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOrigin&ResultSetType=array&Params='+Params;
			OriginBox.reload(url);
		}
	});
	var ImportFlagBox = $HUI.combobox('#ImportFlagBox', {
		data: [{
			'RowId': '国产',
			'Description': '国产'
		}, {
			'RowId': '进口',
			'Description': '进口'
		}, {
			'RowId': '合资',
			'Description': '合资'
		}
		],
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
	var PackUomBox = $HUI.combobox('#PackUomBox', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTUom&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel : function () {
			PackUomBox.clear();
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTUom&ResultSetType=array';
			PackUomBox.reload(url);
		}
	});
	/*
	var NotUseReasonBox = $HUI.combobox('#NotUseReasonBox', {
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
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + SupplyLocBoxParams,
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel : function () {
			SupplyLocBox.clear();
			var SupplyLocBoxParams = JSON.stringify(addSessionParams({
				Type: 'All',
				BDPHospital:GetHospId()
			}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + SupplyLocBoxParams;
			SupplyLocBox.reload(url);
		}
	});
	var FirstReqLocBox = $HUI.combobox('#FirstReqLocBox', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FirstReqLocBoxParams,
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel : function () {
			FirstReqLocBox.clear();
			var FirstReqLocBoxParams = JSON.stringify(addSessionParams({
				Type: 'All',
				BDPHospital:GetHospId()
			}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FirstReqLocBoxParams;
			FirstReqLocBox.reload(url);
		}
	});
	*/
	
	$HUI.lookup('#NotUseReasonBox', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetNotUseReason',
			Params: CatParams
		}
	});
	var SupplyLocBoxParams = JSON.stringify(addSessionParams({
		Type: 'All',
		BDPHospital:GetHospId()
	}));
	$HUI.lookup('#SupplyLocBox', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetCTLoc',
			Params: SupplyLocBoxParams
		}
	});
	var FirstReqLocBoxParams = JSON.stringify(addSessionParams({
		Type: 'All',
		BDPHospital:GetHospId()
	}));
	$HUI.lookup('#FirstReqLocBox', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetCTLoc',
			Params: CatParams
		}
	});
	
	var BatchNoReq = $HUI.combobox('#BatchNoReq', {
		data: [{
			'RowId': 'R',
			'Description': '要求'
		}, {
			'RowId': 'N',
			'Description': '不要求'
		}, {
			'RowId': 'O',
			'Description': '随意'
		}
		],
		valueField: 'RowId',
		textField: 'Description'
	});
	var ExpDateReq = $HUI.combobox('#ExpDateReq', {
		data: [{
			'RowId': 'R',
			'Description': '要求'
		}, {
			'RowId': 'N',
			'Description': '不要求'
		}, {
			'RowId': 'O',
			'Description': '随意'
		}
		],
		valueField: 'RowId',
		textField: 'Description'
	});
	$HUI.lookup('#ReqTypeBox', {
		mode: 'local',
		data: [
			{'RowId': '', 'Description': '空'},
			{'RowId': 'O', 'Description': '临时请求'},
			{'RowId': 'C', 'Description': '申请计划'}
		]
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
	/*
	var OfficialBox = $HUI.combobox('#OfficialBox', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOfficial&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel : function () {
			OfficialBox.clear();
			var Params = JSON.stringify(addSessionParams({BDPHospital:GetHospId()}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOfficial&ResultSetType=array&Params='+Params;
			OfficialBox.reload(url);
		}
	});
	
	var OrdCatBox = $HUI.combobox('#OrdCatBox', {
		///url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOrdCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function (record) {
			OrdSubCatBox.clear();
			var Params = JSON.stringify(addSessionParams({BDPHospital:GetHospId()}));
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOrdSubCat&ResultSetType=array&OrdCat=' + record.RowId+'&Params='+Params;
			OrdSubCatBox.reload(url);
		},
		onShowPanel : function () {
			OrdCatBox.clear();
			var Params = JSON.stringify(addSessionParams({BDPHospital:GetHospId()}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOrdCat&ResultSetType=array&Params='+Params;
			OrdCatBox.reload(url);
		}
	});
	var OrdSubCatBox = $HUI.combobox('#OrdSubCatBox', {
		valueField: 'RowId',
		textField: 'Description'
	});
	*/
	
	$HUI.lookup('#OfficialBox', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetOfficial',
			Params: CatParams
		}
	});
	
	$HUI.lookup('#OrdCatBox', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetOrdCat',
			Params: CatParams
		},
		onSelect: function(index, row){
			$HUI.lookup('#OrdSubCatBox').setValue('');
			$HUI.lookup('#OrdSubCatBox').setText('');
		}
	});
	
	$HUI.lookup('#OrdSubCatBox', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetOrdSubCat',
			Params: CatParams
		},
		onBeforeLoad: function (param) {
			var OrdCatId = $HUI.lookup('#OrdCatBox').getValue();
			OrdCatId = isEmpty(OrdCatId)? '' : OrdCatId;
			param['OrdCat'] = OrdCatId;
		}
	});
	
	/*
	var BillCatBox = $HUI.combobox('#BillCatBox', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetBillCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function (record) {
			BillSubCatBox.clear();
			var Params = JSON.stringify(addSessionParams({BDPHospital:GetHospId()}));
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetBillSubCat&ResultSetType=array&BillCat=' + record.RowId+'&Params='+Params;
			BillSubCatBox.reload(url);
		},
		onShowPanel : function () {
			BillCatBox.clear();
			var Params = JSON.stringify(addSessionParams({BDPHospital:GetHospId()}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetBillCat&ResultSetType=array&Params='+Params;
			BillCatBox.reload(url);
		}
	});
	var BillSubCatBox = $HUI.combobox('#BillSubCatBox', {
		valueField: 'RowId',
		textField: 'Description'
	});
	*/
	$HUI.lookup('#BillCatBox', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetBillCat',
			Params: CatParams
		},
		onSelect: function(index, row){
			$HUI.lookup('#BillSubCatBox').setValue('');
			$HUI.lookup('#BillSubCatBox').setText('');
		}
	});
	$HUI.lookup('#BillSubCatBox', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetBillSubCat',
			Params: CatParams
		},
		onBeforeLoad: function (param) {
			var BillCatId = $HUI.lookup('#BillCatBox').getValue();
			BillCatId = isEmpty(BillCatId)? '' : BillCatId;
			param['BillCat'] = BillCatId;
		}
	});
	
	var BillUomBox = $HUI.combobox('#BillUomBox', {
		valueField: 'RowId',
		textField: 'Description'
	});
	/*
	var PriorityBox = $HUI.combobox('#PriorityBox', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOECPriority&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel : function () {
			PriorityBox.clear();
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOECPriority&ResultSetType=array';
			PriorityBox.reload(url);
		}
	});
	
	var TarSubCatBox = $HUI.combobox('#TarSubCatBox', {
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
	var TarInpatCatBox = $HUI.combobox('#TarInpatCatBox', {
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
	var TarOutpatCatBox = $HUI.combobox('#TarOutpatCatBox', {
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
	var TarEMCCatBox = $HUI.combobox('#TarEMCCatBox', {
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
	var TarAcctCatBox = $HUI.combobox('#TarAcctCatBox', {
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
	var TarMRCatBox = $HUI.combobox('#TarMRCatBox', {
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
	var TarNewMRCatBox = $HUI.combobox('#TarNewMRCatBox', {
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
	*/
	
	$HUI.lookup('#PriorityBox', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetOECPriority'
		}
	});
	
	$HUI.lookup('#TarSubCatBox', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetTarSubCat',
			Params: CatParams
		}
	});
	$HUI.lookup('#TarInpatCatBox', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetTarInpatCat',
			Params: CatParams
		}
	});
	$HUI.lookup('#TarOutpatCatBox', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetTarOutpatCat',
			Params: CatParams
		}
	});
	$HUI.lookup('#TarEMCCatBox', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetTarEMCCat',
			Params: CatParams
		}
	});
	$HUI.lookup('#TarAcctCatBox', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetTarAcctCat',
			Params: CatParams
		}
	});
	$HUI.lookup('#TarMRCatBox', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetTarMRCat',
			Params: CatParams
		}
	});
	$HUI.lookup('#TarNewMRCatBox', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetTarNewMRCat',
			Params: CatParams
		}
	});
	
	$("#RegCertNo").bind("change", function () {
		var regNo=$("#RegCertNo").val();
		setRegInfo(regNo);
	});
	InitCompStat();
	ReSetMustInput('#InciData');
	ReSetMustInput('#ArcimData');
}

//根据配置控制界面控件
function InitCompStat() {
	///是否允许录入进价
	if (CodeMainParamObj['AllowInputRp'] == "Y") {
		$('#RpPUom').removeAttr("disabled");
	} else {
		$('#RpPUom').attr("disabled", "disabled");
	}
	///是否允许录入售价
	if (CodeMainParamObj['AllowInputSp'] == "Y") {
		$('#SpPUom').removeAttr("disabled");
	} else {
		$('#SpPUom').attr("disabled", "disabled");
	}
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
	
	$("#ArcCode").bind("change", function () {
		ArcValChange();
	});
	$("#ArcDesc").bind("change", function () {
		ArcValChange();
	});
	if (CodeMainParamObj['SetInitStatusNotUse'] == "Y") {
		$HUI.checkbox('#NotUseFlag').setValue(true);
	} else {
		$HUI.checkbox('#NotUseFlag').setValue(false);
	}
	if (CodeMainParamObj['INCIBatchReq']) {
		$HUI.combobox("#BatchNoReq").setValue(CodeMainParamObj['INCIBatchReq']);
	}
	if (CodeMainParamObj['INCIExpReq']) {
		$HUI.combobox("#ExpDateReq").setValue(CodeMainParamObj['INCIExpReq']);
	}
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
	//设置医嘱项页签是否可编辑
	var ChargeFlag = $HUI.checkbox('#ChargeFlag').getValue();
	if (ChargeFlag) {
		$('#tabs').tabs('enableTab', '医嘱项');
	} else {
		$('#tabs').tabs('disableTab', '医嘱项');
	}
}
