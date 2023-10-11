
var ChangeState = function(UseFlag, Arc) {
	if (UseFlag) {
		$('#BUom').combobox('disable').addClass('pageauthorno');
		$('#RpPUom').attr('disabled', 'disabled').addClass('pageauthorno');
		$('#SpPUom').attr('disabled', 'disabled').addClass('pageauthorno');
		$('#PreExeDate').dateboxq('disable').addClass('pageauthorno');
		if (CodeMainParamObj.NotAllowUpdateIncsc == 'Y') {
			$('#StkGrpBox').combotree('disable').addClass('pageauthorno');
			$('#StkCatBox').combobox('disable').addClass('pageauthorno');
		}
	} else {
		$('#BUom').combobox('enable');
		$('#RpPUom').removeAttr('disabled');
		$('#SpPUom').removeAttr('disabled');
		$('#PreExeDate').dateboxq('enable');
		$('#StkGrpBox').combotree('enable');
		$('#StkCatBox').combobox('enable');
	}
	if (!isEmpty(Arc)) {
		var InsuConfig = tkMakeServerCall('web.DHCSTMHUI.Common.ServiceCommon', 'GetInsuConfig', GetHospId());
		if (InsuConfig == 'INSU') {
			$('#MatInsuCode').attr('readonly', true);
			$('#MatInsuDesc').attr('readonly', true);
		} else {
			$('#MatInsuCode').attr('readonly', false);
			$('#MatInsuDesc').attr('readonly', false);
		}
	} else {
		$('#MatInsuCode').attr('readonly', false);
		$('#MatInsuDesc').attr('readonly', false);
	}
};

var InitDetailInciPart = function() {
	$UI.linkbutton('#AddInciBT', {
		onClick: function() {
			$UI.clearBlock('#InciData');
			$UI.clearBlock('#ArcimData');
			$UI.clearBlock('#BasicInciData');
			InitCompStat();
			ChangeState(0);
		}
	});
	$UI.linkbutton('#SaveInciBT', {
		onClick: function() {
			Save();
		}
	});
	$UI.linkbutton('#AddSaveInciBT', {
		onClick: function() {
			// 前期处理
			$('#Inci').val('');
			$('#Arc').val('');
			$('#InciCode').val('');
			$('#ArcCode').val('');
			$('#TariCode').val('');
			$('#AliasStr').val('');
			$('#ArcAlias').val('');
			$('#BarCode').val('');
			$('#PreExeDate').dateboxq('setValue', '');
			$('#PreExeDate').dateboxq('enable');
			$HUI.combobox('#BUom').enable();
			$('#SpPUom').removeAttr('disabled');
			$('#RpPUom').removeAttr('disabled');
			$('#EffDate').dateboxq('setValue', DateFormatter(new Date()));
			$('#EffToDate').dateboxq('setValue', '');
		}
	});
	$UI.linkbutton('#GetMaxCodeBT', {
		onClick: function() {
			GetMaxCode();
		}
	});
	$UI.linkbutton('#SciBT', {
		onClick: function() {
			GetSciItm();
		}
	});
	$UI.linkbutton('#LinkArcimBT', {
		onClick: function() {
			var RowId = $('#Inci').val();
			GetArcforLinkInci(RowId);
		}
	});
	$UI.linkbutton('#CancelLinkArcimBT', {
		onClick: function() {
			var RowId = $('#Inci').val();
			if (isEmpty(Inci)) {
				$UI.msg('alert', '请先选择要处理的库存项!');
				return;
			}
			$UI.confirm('您将取消医嘱项关联, 是否继续?', 'question', '', CancelArcLinkInci, '', '', '', '', RowId);
		}
	});
	$UI.linkbutton('#UpPicBT', {
		onClick: function() {
			var RowId = $('#Inci').val();
			if (RowId == '') {
				$UI.msg('alert', '请先选择库存项!');
				return;
			}
			UpLoadFileWin('Inci', RowId, '', '', '', '');
		}
	});
	$UI.linkbutton('#ViewPicBT', {
		onClick: function() {
			var OrgType = 'Inci';
			var OrgId = $('#Inci').val();
			ViewFileWin(OrgType, OrgId, '', '', '', '', '');
		}
	});
	$UI.linkbutton('#ViewSupplyPicBT', {
		onClick: function() {
			var InciId = $('#Inci').val();
			var SupplyChainId = tkMakeServerCall('web.DHCSTMHUI.SupplyChainItm', 'GetChainIdByInci', InciId);
			if (SupplyChainId === '') {
				$UI.msg('alert', '未关联授权书!');
				return;
			}
			ChainDetailWin(SupplyChainId, '', 'Y');
		}
	});
	$UI.linkbutton('#CertTakePhotoBT', {
		onClick: function() {
			var RowId = $('#Inci').val();
			if (RowId == '') {
				$UI.msg('alert', '请先选择库存项!');
				return;
			}
			TakePhotoWin('Inci', RowId, 'Inci', '', RowId, '');
		}
	});
	$UI.linkbutton('#InciCfgBT', {
		onClick: function() {
			var Csp = App_MenuCspName;
			if (Csp == 'dhcstmhui.druginfo.csp') {
				MustInputSet('#InciData');
			} else {
				MustInputSet('#BasicInciData');
			}
		}
	});
	// 界面元素授权
	$UI.linkbutton('#InciPageAuthorBT', {
		onClick: function() {
			PageElementAuthorWin('#InciData');
		}
	});
	
	$('#InciCode').bind('change', function() {
		InciCodeValChange();
	});
	$('#InciDesc').bind('change', function() {
		InciDescValChange();
	});
	$('#Spec').bind('change', function() {
		InciDescValChange();
	});
	$UI.linkbutton('#SpecBT', {
		onClick: function() {
			if (CodeMainParamObj.UseSpecList != 'Y') {
				$UI.msg('alert', '"是否使用具体规格"参数未启用,不允许编辑!');
				return;
			} else {
				IncSpecEdit();
			}
		}
	});
	function SetInsuMatCode(insumatCode) {
		$('#MatInsuCode').val(insumatCode);
	}
	
	$UI.linkbutton('#InsuMatCodeBT', {
		onClick: function() {
			GetInsuMatItm(SetInsuMatCode);
		}
	});
	
	$('#Model').bind('change', function() {
		InciDescValChange();
	});
	// /20221112 阳光采购对照
	$UI.linkbutton('#SunPurPlanBT', {
		onClick: function() {
			var SunPurPlan = CommParObj.SunPurPlan; // 参数设置 公共
			if (isEmpty(SunPurPlan)) {
				$UI.msg('alert', '请配置采购平台信息!');
				return;
			}
			if (SunPurPlan == '四川省') {
				SCPurPlanCodeEdit();
			}
		}
	});
	var BUom = $HUI.combobox('#BUom', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTUom&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onChange: function(newValue, oldValue) {
			PUom.clear();
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetConUom&ResultSetType=array&UomId=' + newValue;
			var urlBill = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTUom&ResultSetType=array';
			PUom.reload(url);
			if ($('#BillUomBox').length > 0) {
				$('#BillUomBox').combobox('clear');
				$('#BillUomBox').combobox('reload', urlBill);
				$('#BillUomBox').combobox('setValue', newValue);
			}
			$('#PUom').combobox('setValue', newValue);
		}
	});
	var PUom = $HUI.combobox('#PUom', {
		valueField: 'RowId',
		textField: 'Description'
	});
	$('#StkGrpBox').combotree({
		onClick: function(node) {
			StkCatBox.clear();
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array&StkGrpId=' + node.id;
			StkCatBox.reload(url);
		}
	});
	var StkCatBox = $HUI.combobox('#StkCatBox', {
		valueField: 'RowId',
		textField: 'Description',
		onChange: function(newValue, oldValue) {
			if (!(isEmpty($('#Inci').val()) && (CodeMainParamObj['ScMap'] == 'Y'))) {
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DrugInfoMaintain',
				MethodName: 'MapArc',
				StkCatId: newValue
			}, function(ArcimData) {
				$UI.fillBlock('#ArcimData', ArcimData);
			});
		},
		onShowPanel: function() {
			var scg = $('#StkGrpBox').combotree('getValue');
			var Params = JSON.stringify(addSessionParams({ BDPHospital: GetHospId() }));
			StkCatBox.clear();
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array&StkGrpId=' + scg + '&Params=' + Params;
			StkCatBox.reload(url);
		}
	});
	var BatchNoReq = $HUI.combobox('#BatchNoReq', {
		data: [
			{ 'RowId': 'R', 'Description': '要求' },
			{ 'RowId': 'N', 'Description': '不要求' },
			{ 'RowId': 'O', 'Description': '随意' }
		],
		valueField: 'RowId',
		textField: 'Description'
	});
	var ExpDateReq = $HUI.combobox('#ExpDateReq', {
		data: [
			{ 'RowId': 'R', 'Description': '要求' },
			{ 'RowId': 'N', 'Description': '不要求' },
			{ 'RowId': 'O', 'Description': '随意' }
		],
		valueField: 'RowId',
		textField: 'Description'
	});
	/* 68分类*/
	var MCOParams = gHospId + '^' + GetHospId();
	var OfficialBox = $HUI.combotree('#OfficialBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&MethodName=GetMCOChildNode&NodeId=AllMCO&Params=' + MCOParams,
		valueField: 'id',
		textField: 'text',
		editable: true
	});
	$('#OfficialBox').parent().find('.combo-text').blur(function() {
		$('#OfficialBox').combotree('clear');
	});
	var ClinicalCatBox = $HUI.combobox('#ClinicalCatBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetClinicCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			ClinicalCatBox.clear();
			var Params = JSON.stringify(addSessionParams({ BDPHospital: GetHospId() }));
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetClinicCat&ResultSetType=array&Params=' + Params;
			ClinicalCatBox.reload(url);
		}
	});
	/*
	$HUI.lookup('#ClinicalCatBox', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetClinicCat',
			rows: 9999
		},
		onBeforeLoad: function(param) {
			param['Params'] = JSON.stringify(addSessionParams({
				BDPHospital: GetHospId()
			}));
		}
	});
	*/
	$HUI.combobox('#SupervisionBox', {
		data: [
			{ 'RowId': 'I', 'Description': 'I' },
			{ 'RowId': 'II', 'Description': 'II' },
			{ 'RowId': 'III', 'Description': 'III' }
		],
		valueField: 'RowId',
		textField: 'Description'
	});
	
	$HUI.combobox('#BookCatBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetBookCat&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ BDPHospital: GetHospId() })),
		valueField: 'RowId',
		textField: 'Description'
	});

	$HUI.checkbox('#ChargeFlag', {
		onCheckChange: function(e, value) {
			if (value) {
				$('#tabs').tabs('enableTab', '医嘱项');
				InciDescValChange();
			} else {
				$('#tabs').tabs('disableTab', '医嘱项');
			}
		}
	});
	
	$HUI.combobox('#MarkTypeBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetMarkType&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ BDPHospital: GetHospId() })),
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var MarkType = record['RowId'];
			var RpPUom = $('#RpPUom').val();
			if (RpPUom != 0 && MarkType != '') {
				var MtSp = tkMakeServerCall('web.DHCSTMHUI.Common.PriceCommon', 'GetMarkTypeSp', MarkType, RpPUom);
				var Inci = $('#Inci').val();
				if (Inci == '') {
					$('#SpPUom').numberbox('setValue', MtSp);
				}
			}
		},
		onLoadSuccess: function(data) {
			var Inci = $('#Inci').val();
			if ((data.length == 1) && (isEmpty(Inci)) && ((CommParObj.BatSp == 1) || (CommParObj.BatSpHV == 1))) {
				DefMarkType = data[0].RowId;
				$(this).combobox('select', data[0].RowId);
			}
		}
	});
	$('#RpPUom').bind('change', function() {
		var RpPUom = $('#RpPUom').val();
		var MarkType = $('#MarkTypeBox').combo('getValue');
		if (RpPUom != 0 && MarkType != '') {
			var MtSp = tkMakeServerCall('web.DHCSTMHUI.Common.PriceCommon', 'GetMarkTypeSp', MarkType, RpPUom);
			$('#SpPUom').numberbox('setValue', MtSp);
		}
		if (RpPUom != 0 && MarkType == '') {
			$('#SpPUom').numberbox('setValue', RpPUom);
		}
	});
	$UI.linkbutton('#AdjPriceBT', {
		onClick: function() {
			var UseFlag = $HUI.checkbox('#UseFlag').getValue();
			var Incid = $('#Inci').val();
			if (isEmpty(Incid)) {
				$UI.msg('alert', '请选择需调价的库存项!');
				return false;
			}
			var HospId = GetHospId();
			if ((CommParObj.BatSp != 0) && (UseFlag == true)) {
				$UI.msg('alert', '批次售价请使用批次调价功能!');
				return false;
			}
			var InciCode = $('#InciCode').val();
			var InciDesc = $('#InciDesc').val();
			var PUomId = $('#PUom').combobox('getValue');
			var PUomDesc = $('#PUom').combobox('getText');
			var PUom = {
				RowId: PUomId,
				Description: PUomDesc
			};
			var RpPUom = $('#RpPUom').val();
			var SpPUom = $('#SpPUom').val();
			var StkGrp = $('#StkGrpBox').val();
			var StkCat = $('#StkCat').val();
			var Obj = {
				AspIncid: Incid,
				AspIncCode: InciCode,
				AspIncDesc: InciDesc,
				AspIncSpec: Spec,
				AspIncUom: PUom,
				PriorRpUom: RpPUom,
				PriorSpUom: SpPUom,
				AspStkGrpType: StkGrp,
				AspStkCat: StkCat
			};
			var AspInfo = addSessionParams(Obj);
			AdjPriceEdit(AspInfo);
		}
	});
	
	$HUI.checkbox('#BatchCodeFlag', {
		onChecked: function(e, value) {
			if ($HUI.checkbox('#HighPrice').getValue() != true) {
				$UI.msg('alert', '先维护高值标志才能维护批次码管理标志！');
				$HUI.checkbox('#HighPrice').setValue(true);
			}
		}
	});
	
	$('#RegCertNo').bind('change', function() {
		var regNo = $('#RegCertNo').val();
		var ManfId = $('#ManfBox').combobox('getValue');
		setRegInfo(regNo);
	});
	$UI.linkbutton('#RegCertNoBT', {
		onClick: function() {
			var HospId = GetHospId();
			var regNo = $('#RegCertNo').val();
			var Incid = $('#Inci').val();
			if (isEmpty(Incid)) {
				$UI.msg('alert', '请先维护物资信息！');
				return false;
			}
			var InciObj = $UI.loopBlock('#InciData');
			var ManfId = InciObj.Manf;
			
			if (isEmpty(regNo)) {
				$UI.msg('alert', '请先填写注册证号！');
				return false;
			}
			var DisableButtonFlag = $('#RegCertNoBT').hasClass('pageauthorno');
			RegNoInfo(regNo, Incid + '^' + ManfId + '^' + HospId, DisableButtonFlag);
		}
	});
	
	var ManfBox = $HUI.combobox('#ManfBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ StkType: 'M', BDPHospital: GetHospId() })),
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			$('#insProLicText').val('');
			$('#insProLicIssuedDept').val('');
			$('#insProLicDateFrom').val('');
			$('#insProLicDateTo').val('');
			
			$('#firstProdLicText').val('');
			$('#firstProdLicIssuedDept').val('');
			$('#firstProdLicDateFrom').val('');
			$('#firstProdLicDateTo').val('');
			
			var OrgId = record.RowId;
			var CertInfo = tkMakeServerCall('web.DHCSTMHUI.DHCCertDetail', 'GetCertInfo', 'Manf', OrgId);
			$UI.fillBlock('#ManfData', CertInfo);
		}
	});
	
	var PbVendor = $HUI.combobox('#PbVendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({
			APCType: 'M',
			BDPHospital: GetHospId()
		})),
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			$('#insBusLicText').val('');
			$('#insBusLicIssuedDept').val('');
			$('#insBusLicDateFrom').val('');
			$('#insBusLicDateTo').val('');
			
			$('#secondBusLicText').val('');
			$('#secondBusLicIssuedDept').val('');
			$('#secondBusLicDateFrom').val('');
			$('#secondBusLicDateTo').val('');
			
			var OrgId = record.RowId;
			var CertInfo = tkMakeServerCall('web.DHCSTMHUI.DHCCertDetail', 'GetCertInfo', 'Vendor', OrgId);
			$UI.fillBlock('#VendorData', CertInfo);
		}
	});
	
	$UI.linkbutton('#NewPurBT', {
		onClick: function() {
			var Inci = $('#Inci').val();
			var PurNo = $('#PurNo').combobox('getValue');
			if (isEmpty(Inci)) {
				$UI.msg('alert', '请先维护物资信息！');
				return false;
			}
			PurchaseInfo(Inci, PurNo);
		}
	});
	
	var PbBox = $HUI.combobox('#PbBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPublicBidding&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ BDPHospital: GetHospId() })),
		valueField: 'RowId',
		textField: 'Description',
		onChange: function(newValue, oldValue) {
			PbLevel.clear();
			var Params = JSON.stringify(addSessionParams({ Pb: newValue, BDPHospital: GetHospId() }));
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPBLevel&ResultSetType=array&Params=' + Params;
			PbLevel.reload(url);
		}
	});
	var PbLevel = $HUI.combobox('#PbLevel', {
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function() {
			var data = $(this).combobox('getData');
			if (data.length > 0) {
				$(this).combobox('select', data[0].RowId);
			}
		}
	});
	
	var PbCarrier = $HUI.combobox('#PbCarrier', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCarrier&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ BDPHospital: GetHospId(), LocId: gLocId })),
		valueField: 'RowId',
		textField: 'Description'
	});
	var PurType = $HUI.combobox('#PurType', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDictVal&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ BDPHospital: GetHospId(), Type: 'PurType' })),
		valueField: 'RowId',
		textField: 'Description'
	});
	var PurNo = $HUI.combobox('#PurNo', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPurInfo&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onChange: function(newValue, oldValue) {
			$.cm({
				ClassName: 'web.DHCSTMHUI.PurchaseInfo',
				MethodName: 'GetDataById',
				RowId: newValue
			}, function(jsonData) {
				$UI.fillBlock('#PurchaseData', jsonData);
			});
		}
	});
	// 医保医疗耗材编码
	$('#MatInsuCode').bind('keyup', function(event) {
		if (event.keyCode == 13) {
			var InsuMatCode = $(this).val();
			if (isEmpty(InsuMatCode)) {
				return;
			}
			$UI.clearBlock('#MatInsuData');
			var MatInsuInfo = $.cm({
				ClassName: 'web.DHCSTMHUI.InsuMatCode',
				MethodName: 'GetInsuMatInfo',
				InsuMatCode: InsuMatCode
			}, false);
			$UI.fillBlock('#MatInsuData', MatInsuInfo);
			$(this).val(InsuMatCode);
		}
	});

	$UI.linkbutton('#AliasBT', {
		onClick: function() {
			IncAliasEdit();
		}
	});
	$UI.linkbutton('#StoreCondBT', {
		onClick: function() {
			GetStoreCon();
		}
	});
	var ImportFlagBox = $HUI.combobox('#ImportFlagBox', {
		data: [
			{ 'RowId': '国产', 'Description': '国产' },
			{ 'RowId': '进口', 'Description': '进口' },
			{ 'RowId': '合资', 'Description': '合资' }
		],
		valueField: 'RowId',
		textField: 'Description'
	});

	var SterileCatBox = $HUI.combobox('#SterileCatBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSterileCat&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ BDPHospital: GetHospId() })),
		valueField: 'RowId',
		textField: 'Description'
	});

	var QualityLevelBox = $HUI.combobox('#QualityLevelBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetQualityLevel&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ BDPHospital: GetHospId() })),
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var OriginBox = $HUI.combobox('#OriginBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOrigin&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ BDPHospital: GetHospId() })),
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var PackUomBox = $HUI.combobox('#PackUomBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTUom&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	var PackUomMBox = $HUI.combobox('#PackUomMBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTUom&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var NotUseReasonBox = $HUI.combobox('#NotUseReasonBox', {
		// url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetNotUseReason&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			NotUseReasonBox.clear();
			var Params = JSON.stringify(addSessionParams({ BDPHospital: GetHospId() }));
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetNotUseReason&ResultSetType=array&Params=' + Params;
			NotUseReasonBox.reload(url);
		}
	});
	var SupplyLocBox = $HUI.combobox('#SupplyLocBox', {
		// url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + SupplyLocBoxParams,
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			SupplyLocBox.clear();
			var SupplyLocBoxParams = JSON.stringify(addSessionParams({
				Type: 'All',
				BDPHospital: GetHospId()
			}));
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + SupplyLocBoxParams;
			SupplyLocBox.reload(url);
		}
	});
	var FirstReqLocBox = $HUI.combobox('#FirstReqLocBox', {
		// url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FirstReqLocBoxParams,
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			FirstReqLocBox.clear();
			var FirstReqLocBoxParams = JSON.stringify(addSessionParams({
				Type: 'All',
				BDPHospital: GetHospId()
			}));
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FirstReqLocBoxParams;
			FirstReqLocBox.reload(url);
		}
	});
	
	$HUI.checkbox('#NotUseFlag', {
		onCheckChange: function(e, value) {
			if (!value) {
				$HUI.lookup('#NotUseReasonBox').setValue('');
				$HUI.lookup('#NotUseReasonBox').setText('');
			}
		}
	});
	/*
	$HUI.lookup('#NotUseReasonBox', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetNotUseReason',
			rows: 9999
		},
		onBeforeLoad: function(param) {
			param['Params'] = JSON.stringify(addSessionParams({ BDPHospital: GetHospId() }));
		},
		onSelect: function(index, rowData) {
			if (!$HUI.checkbox('#NotUseFlag').getValue()) {
				$UI.msg('alert', '请先勾选不可用标志！');
				$HUI.lookup('#NotUseReasonBox').setValue('');
				$HUI.lookup('#NotUseReasonBox').setText('');
			}
		}
	});*/
	/*
	$HUI.lookup('#SupplyLocBox', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetCTLoc',
			rows: 9999
		},
		onBeforeLoad: function(param) {
			param['Params'] = JSON.stringify(addSessionParams({
				Type: 'All',
				BDPHospital: GetHospId()
			}));
		}
	});
	
	var ReqLocParams = JSON.stringify(addSessionParams({ BDPHospital: GetHospId() }));
	$HUI.lookup('#FirstReqLocBox', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetCTLoc',
			Params: ReqLocParams,
			rows: 9999
		},
		onBeforeLoad: function(param) {
			param['Params'] = JSON.stringify(addSessionParams({
				Type: 'All',
				BDPHospital: GetHospId()
			}));
		}
	});
*/
	var ReqTypeBox = $HUI.combobox('#ReqTypeBox', {
		data: [{ 'RowId': '', 'Description': '' }, { 'RowId': 'O', 'Description': '临时请求' }, { 'RowId': 'C', 'Description': '申请计划' }],
		valueField: 'RowId',
		textField: 'Description'
	});

	$('#PbNo').bind('change', function() {
		var PbNo = $('#PbNo').val();
		if (!isEmpty(PbNo)) {
			if ($HUI.checkbox('#PbFlag').getValue() != true) {
				$HUI.checkbox('#PbFlag').setValue(true);
				$UI.msg('alert', '已勾选中标标记');
			}
		}
	});
	var SunPurType = $HUI.combobox('#SunPurType', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDictVal&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ BDPHospital: GetHospId(), Type: 'SunPur' })),
		valueField: 'RowId',
		textField: 'Description',
		multiple: true,
		rowStyle: 'checkbox', // 显示成勾选行形式
		selectOnNavigation: false
	});

	$('#SpeFlag').keywords({
		singleSelect: true,
		items: [
			{ text: '-', id: '' }, { text: '是', id: 'Y' }, { text: '否', id: 'N' }
		]
	});
	$HUI.checkbox('#TemPurchase', {
		onCheckChange: function(e, value) {
			if (value) {
				$('#RecMaxQty').attr('readonly', false);
			} else {
				$('#RecMaxQty').numberbox('setValue', '');
				$('#RecMaxQty').attr('readonly', true);
			}
		}
	});
};
$(InitDetailInciPart);