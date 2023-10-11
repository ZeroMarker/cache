var init = function() {
	var HospId = '';
	function InitHosp() {
		var hospComp = InitHospCombo('INC_Itm', gSessionStr);
		if (typeof hospComp === 'object') {
			HospId = $HUI.combogrid('#_HospList').getValue();
			$('#_HospList').combogrid('options').onSelect = function(index, record) {
				HospId = record.HOSPRowId;
				setStkGrpHospid(HospId);
				SetServiceInfo(HospId);
				$UI.clearBlock('Conditions');
				$HUI.combotree('#FStkGrpBox').load(HospId);
				$HUI.combotree('#StkGrpBox').load(HospId);
				QueryDrugInfo();
				ReloadListData();
				ReloadDetailData();
			};
		} else {
			HospId = gHospId;
		}
		setStkGrpHospid(HospId);
		SetServiceInfo();
	}
	// 根据接口启用控制相关按钮展示
	function SetServiceInfo(HospId) {
		if (!isEmpty(HospId)) {
			SerUseObj = GetSerUseObj(HospId);
		}
		if (SerUseObj.ECS == 'Y') {
			$('.SCIShow').show();
		} else {
			$('.SCIShow').hide();
		}
	}
	var ReloadListData = function() {
		var FVendorBoxUrl = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ APCType: 'M', ScgId: '', BDPHospital: HospId }));
		$('#FVendorBox').combobox('reload', FVendorBoxUrl).combobox('clear');
	};
	var ReloadDetailData = function() {
		var ManfBoxUrl = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ StkType: 'M', BDPHospital: HospId }));
		$('#ManfBox').combobox('reload', ManfBoxUrl).combobox('clear');
	
		var PbCarrierUrl = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCarrier&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		$('#PbCarrier').combobox('reload', PbCarrierUrl).combobox('clear');
		
		var BookCatBoxUrl = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetBookCat&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		$('#BookCatBox').combobox('reload', BookCatBoxUrl).combobox('clear');
		
		var MarkTypeBoxUrl = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetMarkType&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		$('#MarkTypeBox').combobox('reload', MarkTypeBoxUrl).combobox('clear');
		
		var PbBoxUrl = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPublicBidding&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		$('#PbBox').combobox('reload', PbBoxUrl).combobox('clear');
		
		var PbVendorUrl = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ APCType: 'M', BDPHospital: HospId }));
		$('#PbVendor').combobox('reload', PbVendorUrl).combobox('clear');
		
		var OriginBoxUrl = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOrigin&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		$('#OriginBox').combobox('reload', OriginBoxUrl).combobox('clear');
		
		var SterileCatBoxUrl = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSterileCat&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		$('#SterileCatBox').combobox('reload', SterileCatBoxUrl).combobox('clear');
		
		var QualityLevelBoxUrl = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetQualityLevel&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		$('#QualityLevelBox').combobox('reload', QualityLevelBoxUrl).combobox('clear');
		
		var NotUseReasonBoxUrl = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetNotUseReason&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		$('#NotUseReasonBox').combobox('reload', NotUseReasonBoxUrl).combobox('clear');
		
		var SupplyLocBoxUrl = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ Type: 'All', BDPHospital: HospId }));
		$('#SupplyLocBox').combobox('reload', SupplyLocBoxUrl).combobox('clear');
		
		var FirstReqLocBoxUrl = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ Type: 'All', BDPHospital: HospId }));
		$('#FirstReqLocBox').combobox('reload', FirstReqLocBoxUrl).combobox('clear');
		
		var OfficialBoxUrl = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&MethodName=GetMCOChildNode&NodeId=AllMCO&Params=' + gHospId + '^' + HospId;
		$('#OfficialBox').combotree('reload', OfficialBoxUrl).combotree('clear');
	};
	$('#QueryBT').on('click', QueryDrugInfo);
	$('#ClearBT').on('click', ClearDrugInfo);
	/* $('#FStkGrpBox').stkscgcombotree({
		onSelect:function(node){
			$.cm({
				ClassName:'web.DHCSTMHUI.Common.Dicts',
				QueryName:'GetStkCat',
				ResultSetType:'array',
				StkGrpId:node.id
			},function(data){
				FStkCatBox.clear();
				FStkCatBox.loadData(data);
				})
			}
	})*/
	var FStkCatBox = $HUI.combobox('#FStkCatBox', {
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			var scg = $('#FStkGrpBox').combotree('getValue');
			var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			FStkCatBox.clear();
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array&StkGrpId=' + scg + '&Params=' + Params;
			FStkCatBox.reload(url);
		}
	});
	
	var FVendorBox = $HUI.combobox('#FVendorBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ APCType: 'M', ScgId: '', BDPHospital: HospId })),
		valueField: 'RowId',
		textField: 'Description'
	});
	var ManfParams = JSON.stringify(addSessionParams({ APCType: 'M', ScgId: '', BDPHospital: HospId }));
	$HUI.combobox('#FManfBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params=' + ManfParams
	});
	
	var HandlerParams = function() {
		var Scg = $('#FStkGrpBox').combotree('getValue');
		var Obj = { StkGrpRowId: Scg, StkGrpType: 'M', BDPHospital: HospId };
		return Obj;
	};
	$('#FInciDesc').lookup(InciLookUpOp(HandlerParams, '#FInciDesc', '#FInci'));

	var DrugInfoCm = [[
		{
			title: '库存项id',
			field: 'RowId',
			align: 'left',
			width: 100,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			align: 'left',
			width: 100,
			sortable: true
		}, {
			title: '物资名称',
			field: 'InciDesc',
			align: 'left',
			width: 160,
			sortable: true
		}, {
			title: '规格',
			field: 'Spec',
			width: 100,
			align: 'left'
		}, {
			title: '型号',
			field: 'Model',
			width: 100,
			align: 'left'
		}, {
			title: '品牌',
			field: 'Brand',
			width: 100,
			align: 'left'
		}, {
			title: '入库单位',
			field: 'PurUom',
			width: 100,
			align: 'left'
		}, {
			title: '售价(入库单位)',
			field: 'Sp',
			align: 'right',
			width: 100,
			sortable: true
		}, {
			title: '进价(入库单位)',
			field: 'Rp',
			align: 'right',
			width: 100,
			sortable: true
		}, {
			title: '基本单位',
			field: 'BUom',
			width: 100,
			align: 'left'
		}, {
			title: '账单单位',
			field: 'BillUom',
			width: 100,
			align: 'left'
		}, {
			title: '库存分类',
			field: 'StkCatDesc',
			width: 100,
			align: 'left'
		}, {
			title: '建档日期',
			field: 'InciCreateDate',
			width: 100,
			align: 'left'
		}, {
			title: '更新日期',
			field: 'InciUpdateDate',
			width: 100,
			align: 'left'
		}, {
			title: '不可用',
			field: 'NotUseFlag',
			width: 60,
			align: 'center',
			formatter: BoolFormatter
		}, {
			title: '注册证号',
			field: 'RegisterNo',
			width: 180,
			align: 'left'
		}, {
			title: '生产厂家',
			field: 'Manf',
			width: 150,
			align: 'left'
		}, {
			title: '生产许可',
			field: 'insProLicText',
			width: 180,
			align: 'left'
		}, {
			title: '一类生产备案',
			field: 'firstProdLicText',
			width: 180,
			align: 'left'
		}, {
			title: '供应商',
			field: 'VendorName',
			width: 150,
			align: 'left'
		}, {
			title: '经营许可',
			field: 'insBusLicText',
			width: 180,
			align: 'left'
		}, {
			title: '二类经营备案',
			field: 'secondBusLicText',
			width: 180,
			align: 'left'
		}
	]];

	var DrugInfoGrid = $UI.datagrid('#tabDrugList', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DrugInfoMaintain',
			MethodName: 'GetItmDetail'
		},
		columns: DrugInfoCm,
		showBar: true,
		toolbar: [{
			text: '确认不维护医嘱项',
			iconCls: 'icon-accept',
			handler: function() {
				var Row = DrugInfoGrid.getSelected();
				if (isEmpty(Row)) {
					$UI.msg('alert', '请选择要确认的库存项!');
					return;
				}
				var InciId = Row.RowId;
				var AckFlag = 'Y';
				var UserId = gUserId;
				$.cm({
					ClassName: 'web.DHCSTMHUI.INCITM',
					MethodName: 'SetAckSpFlag',
					InciId: InciId,
					AckFlag: AckFlag,
					UserId: UserId
				}, function(jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			}
		}
		],
		singleSelect: true,
		onSelect: function(index, row) {
			GetDetail(row.RowId);
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	function QueryDrugInfo() {
		var SessionParmas = addSessionParams({ BDPHospital: HospId });
		var Paramsobj = $UI.loopBlock('Conditions');
		var CreateStartDate = Paramsobj.CreateStartDate;
		var CreateEndDate = Paramsobj.CreateEndDate;
		var UpdateStartDate = Paramsobj.UpdateStartDate;
		var UpdateEndDate = Paramsobj.UpdateEndDate;
		if ((!isEmpty(CreateStartDate)) && (!isEmpty(CreateEndDate)) && compareDate(CreateStartDate, CreateEndDate)) {
			$UI.msg('alert', '建档截止日期不能小于建档开始日期!');
			return;
		}
		if ((!isEmpty(UpdateStartDate)) && (!isEmpty(UpdateEndDate)) && compareDate(UpdateStartDate, UpdateEndDate)) {
			$UI.msg('alert', '更新截止日期不能小于更新开始日期!');
			return;
		}
		var Params = JSON.stringify(jQuery.extend(true, Paramsobj, SessionParmas));
		ClearDrugInfoForHosp();
		DrugInfoGrid.load({
			ClassName: 'web.DHCSTMHUI.DrugInfoMaintain',
			MethodName: 'GetItmDetail',
			Params: Params
		});
	}

	function ClearDrugInfo() {
		$UI.clearBlock('Conditions');
		$UI.clearBlock('#BasicInciData');
		if ($('#ArcimData').length > 0) {
			$UI.clearBlock('#ArcimData');
		}
		$UI.clear(DrugInfoGrid);
		InitHosp();
		$('#FStkGrpBox').combotree('options')['setDefaultFun']();
		$HUI.checkbox('#OwnFlag').setValue(true);
		ChangeState(0);
	}
	function ClearDrugInfoForHosp() {
		$UI.clearBlock('#BasicInciData');
		if ($('#ArcimData').length > 0) {
			$UI.clearBlock('#ArcimData');
		}
		$UI.clear(DrugInfoGrid);
	}
	ClearDrugInfo();
};
$(init);