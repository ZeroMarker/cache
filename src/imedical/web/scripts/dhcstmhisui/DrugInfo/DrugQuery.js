var init = function() {
	var HospId = '';
	function InitHosp() {
		var hospComp = InitHospCombo('INC_Itm', gSessionStr);
		if (typeof hospComp === 'object') {
			HospId = $HUI.combogrid('#_HospList').getValue();
			$('#_HospList').combogrid('options').onSelect = function(index, record) {
				HospId = record.HOSPRowId;
				setStkGrpHospid(HospId);
				$UI.clearBlock('Conditions');
				$HUI.combotree('#StkGrpBox').load(HospId);
				SetServiceInfo(HospId);
				QueryDrugInfo();
				ReloadListData();
			};
		} else {
			HospId = gHospId;
		}
		setStkGrpHospid(HospId);
		SetServiceInfo();
	}
	// ���ݽӿ����ÿ�����ذ�ťչʾ
	function SetServiceInfo(HospId) {
		if (!isEmpty(HospId)) {
			SerUseObj = GetSerUseObj(HospId);
		}
		if ((SerUseObj.ECS == 'Y') || (SerUseObj.LIS == 'Y') || (SerUseObj.SCI == 'Y')) {
			$('.SCIShow').show();
		} else {
			$('.SCIShow').hide();
		}
	}
	var ReloadListData = function() {
		var VendorBoxUrl = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ APCType: 'M', ScgId: '', BDPHospital: HospId }));
		$('#VendorBox').combobox('reload', VendorBoxUrl).combobox('clear');
		
		var ManfBoxUrl = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ StkType: 'M', BDPHospital: HospId }));
		$('#ManfBox').combobox('reload', ManfBoxUrl).combobox('clear');
	};
	
	$('#QueryBT').on('click', QueryDrugInfo);
	$('#ClearBT').on('click', ClearDrugInfo);
	$('#SendSCIBT').on('click', SendInciSCI);
	$('#PrintInciBarBT').on('click', printInciHBarCodeS);
	function SendInciSCI() {
		var Rows = DrugInfoGrid.getSelections();
		if (Rows.length <= 0) {
			$UI.msg('alert', '��ѡ��Ҫ���͵ĺĲ�!');
			return;
		}
		var incistr = '';
		for (var i = 0, Len = Rows.length; i < Len; i++) {
			var RowData = Rows[i];
			var RowIndex = DrugInfoGrid.getRowIndex(RowData);
			var incid = RowData['RowId'];
			if (incistr == '') { incistr = incid; } else { incistr = incistr + '^' + incid; }
		}
		if (incistr == '') {
			$UI.msg('alert', '��ѡ��Ҫ���͵ĺĲ�!');
			return;
		}
		if (SerUseObj.ECS == 'Y') {
			$.cm({
				ClassName: 'web.DHCSTMHUI.ServiceForECS',
				MethodName: 'updateHosInv',
				InciIdStr: incistr,
				HospId: HospId
			}, function(jsonData) {
				$UI.msg('success', '�ѷ���!');
			});
		} else if (SerUseObj.SCI == 'Y') {
			$.cm({
				ClassName: 'web.DHCSTMHUI.ServiceForSCI',
				MethodName: 'getHopInc',
				InciStr: incistr
			}, function(jsonData) {
				$UI.msg('success', '�ѷ���!');
			});
		}
		if (SerUseObj.LIS == 'Y') {
			$.cm({
				ClassName: 'web.DHCSTMHUI.ServiceForLis',
				MethodName: 'SynInciInfo',
				Inci: incistr,
				HospId: HospId
			}, function(jsonData) {
				$UI.msg('success', '�ѷ���!');
			});
		}
	}
	/* $('#StkGrpBox').stkscgcombotree({
		onSelect:function(node){
			var Params=JSON.stringify(addSessionParams({BDPHospital:HospId}));
			$.cm({
				ClassName:'web.DHCSTMHUI.Common.Dicts',
				QueryName:'GetStkCat',
				ResultSetType:'array',
				StkGrpId:node.id,
				Params:Params
			},function(data){
				StkCatBox.clear();
				StkCatBox.loadData(data);
				})
			}
	})*/
	var StkCatBox = $HUI.combobox('#StkCatBox', {
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			var scg = $('#StkGrpBox').combotree('getValue');
			var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			StkCatBox.clear();
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array&StkGrpId=' + scg + '&Params=' + Params;
			StkCatBox.reload(url);
		}
	});
	
	var VendorBox = $HUI.combobox('#VendorBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ APCType: 'M', ScgId: '', BDPHospital: HospId })),
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var ManfBox = $HUI.combobox('#ManfBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ StkType: 'M', BDPHospital: HospId })),
		valueField: 'RowId',
		textField: 'Description'
	});
	var HandlerParams = function() {
		var Scg = $('#StkGrpBox').combotree('getValue');
		var Obj = { StkGrpRowId: Scg, StkGrpType: 'M', BDPHospital: HospId };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	var DrugInfoCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: '�����id',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			sortable: true,
			width: 100,
			frozen: true,
			formatter: function(value, row, index) {
				var str = "<a href='#' onclick='IncRegInfoWin(" + row.RowId + ")'>" + value + '</a>';
				return str;
			}
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 150,
			frozen: true
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '�ͺ�',
			field: 'Model',
			width: 100
		}, {
			title: '��ע',
			field: 'Remarks',
			width: 100
		}, {
			title: 'Ʒ��',
			field: 'Brand',
			width: 100
		}, {
			title: '��ܼ���',
			field: 'Supervision',
			width: 100
		}, {
			title: '����',
			width: 100,
			field: 'Origin'
		}, {
			title: '��ⵥλ',
			width: 80,
			field: 'PurUom'
		}, {
			title: '�ۼ�(��ⵥλ)',
			field: 'Sp',
			width: 100,
			align: 'right'
		}, {
			title: '����(��ⵥλ)',
			field: 'Rp',
			width: 100,
			align: 'right',
			sortable: true
		}, {
			title: '�ӳ�',
			width: 100,
			field: 'Marginnow',
			align: 'right'
		}, {
			title: '������λ',
			width: 80,
			field: 'BUom'
		}, {
			title: '�˵���λ',
			width: 80,
			field: 'BillUom'
		}, {
			title: '������',
			width: 100,
			field: 'StkCatDesc'
		}, {
			title: '������',
			width: 60,
			field: 'NotUseFlag',
			formatter: BoolFormatter
		}, {
			title: 'ע��֤��',
			width: 100,
			field: 'RegisterNo'
		}, {
			title: 'ע��֤Ч��',
			width: 100,
			field: 'RegisterNoExpDate'
		}, {
			title: 'ע��֤��֤����',
			width: 120,
			field: 'RegCertDateOfIssue'
		}, {
			title: 'ע��֤����',
			width: 100,
			field: 'RegItmDesc'
		}, {
			title: '����(������λ)',
			field: 'BRp',
			width: 100,
			align: 'right'
		}, {
			title: '��ֵ��־',
			field: 'HighPrice',
			width: 80,
			align: 'center',
			formatter: BoolFormatter
		}, {
			title: 'ֲ���־',
			field: 'Implantation',
			width: 80,
			align: 'center',
			formatter: BoolFormatter
		}, {
			title: '��������',
			field: 'Manf',
			width: 100,
			align: 'left'
		}, {
			title: '�������',
			field: 'insProLicText',
			width: 100,
			align: 'left'
		}, {
			title: 'һ����������',
			field: 'firstProdLicText',
			width: 100,
			align: 'left'
		}, {
			title: '��Ӧ��',
			field: 'VendorName',
			width: 100,
			align: 'left'
		}, {
			title: '��Ӫ���',
			field: 'insBusLicText',
			width: 100,
			align: 'left'
		}, {
			title: '���ྭӪ����',
			field: 'secondBusLicText',
			width: 100,
			align: 'left'
		}
	]];
	var DrugInfoGrid = $UI.datagrid('#DrugList', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DrugInfoMaintain',
			// QueryName: 'GetItm'
			MethodName: 'GetItmDetail'
		},
		columns: DrugInfoCm,
		remoteSort: true,
		showBar: true,
		singleSelect: false,
		navigatingWithKey: true,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	function QueryDrugInfo() {
		var SessionParmas = addSessionParams({ BDPHospital: HospId });
		var Paramsobj = $UI.loopBlock('Conditions');
		var StartDate = Paramsobj.UpdateStartDate;
		var EndDate = Paramsobj.UpdateEndDate;
		if ((!isEmpty(StartDate)) && (!isEmpty(EndDate)) && compareDate(StartDate, EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���С�ڿ�ʼ����!');
			return;
		}
		var ItmQueryDefaRp = CodeMainParamObj['ItmQueryDefaRp'];
		Paramsobj.DefaRp = ItmQueryDefaRp;
		var Params = JSON.stringify(jQuery.extend(true, Paramsobj, SessionParmas));
		$UI.clear(DrugInfoGrid);
		
		DrugInfoGrid.load({
			ClassName: 'web.DHCSTMHUI.DrugInfoMaintain',
			// QueryName: 'GetItm',
			MethodName: 'GetItmDetail',
			Params: Params
		});
	}

	function ClearDrugInfo() {
		$UI.clearBlock('Conditions');
		$UI.clear(DrugInfoGrid);
		InitHosp();
		InitHospButton(DrugInfoGrid, 'INC_Itm');
		$('#StkGrpBox').combotree('options')['setDefaultFun']();
	}
	function LodopPrintInciBar(Incid, Times) {
		if (Times == undefined) {
			Times = 1;
		}
		DHCP_GetXMLConfig('InvPrintEncrypt', 'DHCSTM_InciBar');
		var inpara = '';
		inpara = $.cm({ ClassName: 'web.DHCSTMHUI.DrugInfoMaintain', MethodName: 'HCodeforprint', inci: Incid, dataType: 'text' }, false);
		for (var i = 1; i <= Times; i++) {
			// ���þ����ӡ����
			DHC_PrintByLodop(getLodop(), inpara, '', [], '�������ӡ', { printListByText: true });
		}
	}
	function printInciHBarCodeS() {
		var Rows = DrugInfoGrid.getSelections();
		if (Rows.length <= 0) {
			$UI.msg('alert', '��ѡ��Ҫ��ӡ�ĺĲ�!');
			return;
		}
		for (var i = 0, Len = Rows.length; i < Len; i++) {
			var RowData = Rows[i];
			var RowIndex = DrugInfoGrid.getRowIndex(RowData);
			var Incid = RowData['RowId'];
			LodopPrintInciBar(Incid, 1);
		}
	}
	ClearDrugInfo();
};
$(init);