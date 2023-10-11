/*
��ⵥ�Ƶ�(��ֵ)
*/
var ScgTipFlag = '';
var init = function() {
	if (!UseItmTrack) {
		$UI.msg('alert', 'δ���ø�ֵ����,�˲˵���ʹ��!');
	}
	// ��ȡ���������Ϣ
	function GetParamsObj() {
		var ParamsObj = $UI.loopBlock('#MainConditions');
		return ParamsObj;
	}
	var UomCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInciUom&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			tipPosition: 'bottom',
			mode: 'remote',
			editable: false,
			onBeforeLoad: function(param) {
				var rows = InGdRecGrid.getRows();
				var row = rows[InGdRecGrid.editIndex];
				if (!isEmpty(row)) {
					param.Inci = row.IncId;
				}
			},
			onSelect: function(record) {
				var rows = InGdRecGrid.getRows();
				var row = rows[InGdRecGrid.editIndex];
				row.IngrUom = record.Description;
				var NewUomid = record.RowId;
				var OldUomid = row.IngrUomId;
				if (isEmpty(NewUomid) || (NewUomid == OldUomid)) { return false; }
				var BUomId = row.BUomId;
				var confac = row.ConFacPur;
				var rp, sp, newsp, RpAmt, SpAmt;
				if (NewUomid == BUomId) { // ��ⵥλת��Ϊ������λ
					rp = row.Rp;
					sp = row.Sp;
					newsp = row.NewSp;
					row.Rp = Number(rp).div(confac);
					row.Sp = Number(sp).div(confac);
					row.NewSp = Number(newsp).div(confac);
				} else { // ������λת��Ϊ��ⵥλ
					rp = row.Rp;
					sp = row.Sp;
					newsp = row.NewSp;
					row.Rp = Number(rp).mul(confac);
					row.Sp = Number(sp).mul(confac);
					row.NewSp = Number(newsp).mul(confac);
				}
				if (isEmpty(row.RecQty)) {
					RpAmt = 0;
					SpAmt = 0;
				} else {
					RpAmt = Number(row.Rp).mul(row.RecQty);
					SpAmt = Number(row.Sp).mul(row.RecQty);
				}
				row.RpAmt = RpAmt;
				row.InvMoney = RpAmt;
				row.SpAmt = SpAmt;
				row.IngrUomId = NewUomid;
				setTimeout(function() {
					InGdRecGrid.refreshRow();
				}, 0);
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	var PhManufacturerParams = JSON.stringify(addSessionParams({ StkType: 'M' }));
	var PhManufacturerBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params=' + PhManufacturerParams,
			valueField: 'RowId',
			textField: 'Description',
			onBeforeLoad: function(param) {
				var ScgId = GetParamsObj.StkGrpId;
				param.ScgId = ScgId;
			},
			onSelect: function(record) {
				var rows = InGdRecGrid.getRows();
				var row = rows[InGdRecGrid.editIndex];
				row.Manf = record.Description;
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	var reqLocParams = JSON.stringify(addSessionParams({ Type: 'All' }));
	var reqLocCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + reqLocParams,
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function(record) {
				var rows = InGdRecGrid.getRows();
				var row = rows[InGdRecGrid.editIndex];
				row.reqLocDesc = record.Description;
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	var SpecDescParams = JSON.stringify(sessionObj);
	var SpecDescbox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSpecDesc&ResultSetType=array&Params=' + SpecDescParams,
			valueField: 'Description',
			textField: 'Description',
			mode: 'remote',
			onBeforeLoad: function(param) {
				var Select = InGdRecGrid.getSelected();
				if (!isEmpty(Select)) {
					param.Inci = Select.IncId;
				}
			}
		}
	};
	var RegCertBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetRegCert&ResultSetType=array&Params=' + JSON.stringify(sessionObj),
			valueField: 'Description',
			textField: 'Description',
			mode: 'remote',
			onBeforeLoad: function(param) {
				var Select = InGdRecGrid.getSelected();
				if (!isEmpty(Select)) {
					param.Inci = Select.IncId;
				}
			},
			onSelect: function(record) {
				var rows = InGdRecGrid.getRows();
				var row = rows[InGdRecGrid.editIndex];
				row.AdmExpdate = record.MRCExpDate;
				row.ManfId = record.MRCManfId;
				row.Manf = record.MRCManfDesc;
				InGdRecGrid.refreshRow();
			}
		}
	};
	var RecLocParams = JSON.stringify(addSessionParams({ Type: 'Login', Element: 'RecLoc' }));
	var RecLocBox = $HUI.combobox('#RecLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + RecLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$HUI.combotree('#StkGrpId').setFilterByLoc(LocId);
			GetPurchaseUser(LocId);
			if (CommParObj.ApcScg == 'L') {
				VendorBox.clear();
				var Params = JSON.stringify(addSessionParams({ APCType: 'M', LocId: LocId }));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + Params;
				VendorBox.reload(url);
			}
		}
	});
	var ReqLocIdParams = JSON.stringify(addSessionParams({ Type: 'All', Element: 'ReqLocId' }));
	var ReqLocIdBox = $HUI.combobox('#ReqLocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocIdParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var VendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var VendorBox = $HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
		valueField: 'RowId',
		textField: 'Description',
		onBeforeLoad: function(param) {
			var ScgId = GetParamsObj.StkGrpId;
			param.ScgId = ScgId;
		}
	});
	var IngrTypeIdParams = JSON.stringify(addSessionParams({ Type: 'IM' }));
	var IngrTypeIdBox = $HUI.combobox('#IngrTypeId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOperateType&ResultSetType=array&Params=' + IngrTypeIdParams,
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function() {
			var IngrTypeId = GetIngrtypeDefa().split('^')[0];
			$('#IngrTypeId').combobox('select', IngrTypeId);
		}
	});
	var PurchaseUserParams = JSON.stringify(addSessionParams({ LocDr: '', UseAllUserAsPur: IngrParamObj.UseAllUserAsPur }));
	var PurchaseUserBox = $HUI.combobox('#PurchaseUser', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocPPLUser&ResultSetType=array&Params=' + PurchaseUserParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	function GetPurchaseUser(RecLocid) {
		$('#PurchaseUser').combobox('clear');
		$('#PurchaseUser').combobox('reload', $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocPPLUser&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({ LocDr: RecLocid, UseAllUserAsPur: IngrParamObj.UseAllUserAsPur }))
		);
	}
	var AcceptUserIdParams = JSON.stringify(addSessionParams({ LocDr: '' }));
	var AcceptUserIdBox = $HUI.combobox('#AcceptUserId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=array&Params=' + AcceptUserIdParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var SourceOfFundParams = JSON.stringify(addSessionParams());
	var SourceOfFundBox = $HUI.combobox('#SourceOfFund', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSourceOfFund&ResultSetType=array&Params=' + SourceOfFundParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	function SetFieldDisabled(bool) {
		$('#RecLoc').combobox(bool);
		$('#Vendor').combobox(bool);
		$('#StkGrpId').combobox(bool);
		$('#VirtualFlag').checkbox(bool);
	}
	function ChangeButtonEnable(str) {
		var list = str.split('^');
		for (var i = 0; i < list.length; i++) {
			if (list[i] == '1') {
				list[i] = 'enable';
			} else {
				list[i] = 'disable';
			}
		}
		// ��ѯ^����^����^����^ɾ��^���^ȡ�����
		// 1^1^1^1^1^1^1
		$('#QueryBT').linkbutton(list[0]);
		$('#ClearBT').linkbutton(list[1]);
		$('#SaveBT').linkbutton(list[2]);
		$('#DelBT').linkbutton(list[3]);
		$('#ComBT').linkbutton(list[4]);
		$('#CanComBT').linkbutton(list[5]);
	}
	var VirtualFlag = $HUI.checkbox('#VirtualFlag', {
		onCheckChange: function(e, value) {
			if (value) {
				var RecLoc = $('#RecLoc').combobox('getValue');
				var Info = tkMakeServerCall('web.DHCSTMHUI.Common.UtilCommon', 'GetMainLoc', RecLoc);
				var InfoArr = Info.split('^');
				var VituralLoc = InfoArr[0], VituralLocDesc = InfoArr[1];
				AddComboData($('#RecLoc'), VituralLoc, VituralLocDesc);
				$('#RecLoc').combobox('setValue', VituralLoc);
			} else {
				$('#RecLoc').combobox('setValue', gLocId);
			}
		}
	});
	
	function CheckDataBeforeSave() {
		if (!InGdRecGrid.endEditing()) {
			return false;
		}
		var ParamsObj = GetParamsObj();
		// �ж���ⵥ�Ƿ�������
		var CmpFlag = ParamsObj.Complete;
		if (CmpFlag == 'Y') {
			$UI.msg('alert', '��ⵥ����ɲ����޸�!');
			return false;
		}
		// �ж���ⲿ�ź͹������Ƿ�Ϊ��
		var phaLoc = ParamsObj.RecLoc;
		if (isEmpty(phaLoc)) {
			$UI.msg('alert', '��ѡ��������!');
			$('#RecLoc').focus();
			return false;
		}
		var vendor = ParamsObj.Vendor;
		if (isEmpty(vendor)) {
			$UI.msg('alert', '��ѡ��Ӧ��!');
			$('#Vendor').focus();
			return false;
		}
		var PurUserId = ParamsObj.PurchaseUser;
		if ((isEmpty(PurUserId)) & (IngrParamObj.PurchaserNotNull == 'Y')) {
			$UI.msg('alert', '�ɹ�Ա����Ϊ��!');
			return false;
		}
		var IngrTypeId = ParamsObj.IngrTypeId;
		if ((isEmpty(IngrTypeId)) & (IngrParamObj.ImpTypeNotNull == 'Y')) {
			$UI.msg('alert', '������Ͳ���Ϊ��!');
			return false;
		}
		var ReqLoc = ParamsObj.ReqLocId;
		if (phaLoc == ReqLoc) {
			$UI.msg('alert', '���տ��Ҳ���������������ͬ!');
			return false;
		}
		
		var InStkTkParamObj = GetAppPropValue('DHCSTINSTKTKM');
		if (InStkTkParamObj.AllowBusiness != 'Y') {
			var IfExistInStkTk = tkMakeServerCall('web.DHCSTMHUI.INStkTk', 'CheckInStkTkByLoc', phaLoc);
			if (IfExistInStkTk == 'Y') {
				$UI.msg('alert', '����δ��ɵ��̵㵥��������!');
				return false;
			}
		}
		// 1.�ж���������Ƿ�Ϊ��
		var RowsData = InGdRecGrid.getChangesData('IncId');
		// ��Ч����
		var count = 0;
		for (var i = 0; i < RowsData.length; i++) {
			var IncId = RowsData[i].IncId;
			if (!isEmpty(IncId)) {
				count++;
			}
			var sp = RowsData[i].Sp;
			var Incidesc = RowsData[i].IncDesc;
			var qty = RowsData[i].RecQty;
			var ExpDate = RowsData[i].ExpDate;
			var ExpReq = RowsData[i].ExpReq;
			var BatchNo = RowsData[i].BatchNo;
			var BatchReq = RowsData[i].BatchReq;
			var ManfId = RowsData[i].ManfId;
			var ProduceDate = RowsData[i].ProduceDate;
			var rp = RowsData[i].Rp;
			var NowDate = DateFormatter(new Date());
			var row = i + 1;
			if (sp < 0 || rp < 0) {
				$UI.msg('alert', '��' + row + '��' + Incidesc + '�ۼۻ���۲���С����!');
				return false;
			}
			if (sp == 0 || rp == 0) {
				if (!confirm('��' + row + '��' + Incidesc + '�ۼۻ����Ϊ��,�Ƿ����?')) {
					return false;
				}
			}
			if (qty == null || qty <= 0) {
				$UI.msg('alert', '��' + row + '��' + Incidesc + '��������С�ڻ����0!');
				return false;
			}
			if ((isEmpty(BatchNo)) && (BatchReq == 'R')) {
				$UI.msg('alert', '��' + row + '�����Ų���Ϊ��');
				return false;
			}
			if ((isEmpty(ExpDate)) && (ExpReq == 'R')) {
				$UI.msg('alert', '��' + row + '����Ч�ڲ���Ϊ��');
				return false;
			}
			if ((!isEmpty(BatchNo)) && (BatchReq == 'N')) {
				$UI.msg('alert', '��' + row + '�����Ų�����¼��');
				return false;
			}
			if ((!isEmpty(ExpDate)) && (ExpReq == 'N')) {
				$UI.msg('alert', '��' + row + '����Ч�ڲ�����¼��');
				return false;
			}
			if (!isEmpty(ExpDate)) {
				if (compareDate(NowDate, ExpDate)) {
					$UI.msg('alert', '��' + row + '����Ч�ڲ������ڵ�ǰ����');
					return false;
				} else {
					var ExpDateMsg = ExpDateValidator(ExpDate, IncId);
					if (!isEmpty(ExpDateMsg)) {
						$UI.msg('alert', '��' + row + '��' + ExpDateMsg);
					}
				}
			}
			if ((!isEmpty(ProduceDate)) && (compareDate(ProduceDate, NowDate))) {
				$UI.msg('alert', '��' + row + '���������ڲ������ڵ�ǰ����');
				return false;
			}
			/* if ((IngrParamObj.ManfNotNull != "Y") && (isEmpty(ManfId))) {
				$UI.msg('alert', "����������Ҳ���Ϊ��!");
				return false;
			}*/
		}
		
		if (RowsData.length <= 0 || count <= 0) {
			$UI.msg('alert', '��������Ч�����ϸ!');
			return false;
		}
		return true;
	}
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			if (CheckDataBeforeSave() == true) {
				SaveIngrInfo();
			}
		}
	});
	function SaveIngrInfo() {
		var DetailObj = InGdRecGrid.getChangesData('IncId');
		var ifChangeMain = $UI.isChangeBlock('#MainConditions');
		if (DetailObj === false) {	// δ��ɱ༭����ϸΪ��
			return;
		}
		if (!ifChangeMain && (isEmpty(DetailObj))) {	// ��������ϸ����
			$UI.msg('alert', 'û����Ҫ�������Ϣ!');
			return;
		}
		var MainObj = $UI.loopBlock('#MainConditions');
		var Main = JSON.stringify(MainObj);
		var Detail = JSON.stringify(DetailObj);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			MethodName: 'jsSave',
			MainInfo: Main,
			ListData: Detail
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				var Rowid = jsonData.rowid;
				Select(Rowid);
				if (IngrParamObj.AutoPrintAfterSave == 'Y') {
					PrintRecHVCol(Rowid, 'Y');
				}
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
		
	var IngrClear = function() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(InGdRecGrid);
		// /���ó�ʼֵ ����ʹ������
		var DefaultData = {
			RecLoc: gLocObj,
			IngrId: '',
			CreateDate: DateFormatter(new Date())
		};
		$UI.fillBlock('#MainConditions', DefaultData);
		SetFieldDisabled('enable');
		ChangeButtonEnable('1^1^1^1^1^0');
		var IngrTypeId = GetIngrtypeDefa().split('^')[0];
		$('#IngrTypeId').combobox('select', IngrTypeId);

		if (ItmTrackParamObj.AutoVirFlag == 'Y') {
			$('#VirtualFlag').checkbox('setValue', true);
		} else {
			$('#VirtualFlag').checkbox('setValue', false);
		}
		
		if ((SerUseObj.ECS == 'Y') || (SerUseObj.SCI == 'Y')) {
			$('.SCIShow').show();
		} else {
			$('.SCIShow').hide();
		}
		ScgTipFlag = '';
	};
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			var DetailObj = InGdRecGrid.getChangesData();
			if (DetailObj.length > 0) {
				$UI.confirm('���������޸�,ȷ��Ҫ������?', '', '', IngrClear);
			} else {
				IngrClear();
			}
		}
	});
	$UI.linkbutton('#DelBT', {
		onClick: function() {
			$UI.confirm('ȷ��Ҫɾ����?', '', '', DelIngr);
		}
	});
	function DelIngr() {
		var Rowid = $('#IngrId').val();
		var ParamsObj = $UI.loopBlock('#MainConditions');
		if (ParamsObj.Complete == 'Y') {
			$UI.msg('alert', '��ⵥ����ɲ���ɾ��!');
			return false;
		}
		if (isEmpty(Rowid)) {
			$UI.msg('alert', '��ⵥ������!');
			return false;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			MethodName: 'jsDelete',
			IngrId: Rowid
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				IngrClear();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#ComBT', {
		onClick: function() {
			var DetailObj = InGdRecGrid.getChangesData();
			if (DetailObj.length > 0) {
				$UI.confirm('���������޸�,ȷ��Ҫ������?', '', '', MakeComplete);
			} else {
				var RecDesc = $HUI.combobox('#RecLoc').getText();
				$UI.confirm('��ǰ�������� ' + RecDesc + ' ȷ���Ƿ����?', '', '', MakeComplete);
			}
		}
	});
	function MakeComplete() {
		var Rowid = $('#IngrId').val();
		if (isEmpty(Rowid)) {
			$UI.msg('alert', '��ⵥ������!');
			return false;
		}
		if ($HUI.checkbox('#Complete').getValue()) {
			$UI.msg('alert', '��ⵥ�����!');
			return false;
		}
		var RowData = InGdRecGrid.getRowsData();
		if (isEmpty(RowData) || RowData.length == 0) {
			$UI.msg('alert', '��ⵥ����ϸ!');
			return false;
		}
		var Params = JSON.stringify(addSessionParams());
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			MethodName: 'jsMakeComplete',
			IngrId: Rowid,
			Params: Params
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				if ((IngrParamObj.AutoAuditAfterComp == 'Y') && (IngrParamObj.AutoPrintAfterAudit == 'Y')) {
					PrintRecHVCol(gIngrRowid, 'Y');
				}
				if (IngrParamObj.Allowflash == '') {
					IngrClear();
				} else {
					Select(Rowid);
				}
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	$UI.linkbutton('#CanComBT', {
		onClick: function() {
			var Rowid = $('#IngrId').val();
			CancelComplete(Rowid);
		}
	});
	function CancelComplete(Rowid) {
		if (isEmpty(Rowid)) {
			$UI.msg('alert', '��ⵥ������!');
			return false;
		}
		var Params = JSON.stringify(addSessionParams());
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			MethodName: 'jsCancleComplete',
			IngrId: Rowid,
			Params: Params
		}, function(jsonData) {
			if (jsonData.success == 0) {
				Select(Rowid);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#PrintHVColBT', {
		onClick: function() {
			var Rowid = $('#IngrId').val();
			if (isEmpty(Rowid)) {
				$UI.msg('alert', 'û����Ҫ��ӡ����Ϣ!');
				return false;
			}
			if (($HUI.checkbox('#Complete').getValue() == false) && (IngrParamObj.PrintNoComplete != 'Y')) {
				$UI.msg('alert', '�������ӡδ��ɵ���ⵥ!');
				return false;
			}
			PrintRecHVCol(Rowid);
		}
	});
	
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			DrugImportGrSearch(Select);
		}
	});
	var Select = function(RecRowid) {
		$UI.clearBlock('#MainConditions');
		$UI.clear(InGdRecGrid);
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			MethodName: 'Select',
			Ingr: RecRowid
		},
		function(jsonData) {
			var MainLocInfo = tkMakeServerCall('web.DHCSTMHUI.Common.UtilCommon', 'GetMainLocInfo', jsonData.RecLocId.RowId);
			var MainLocId = MainLocInfo.split('^')[0];
			if ((!isEmpty(MainLocId)) && (gLocId == MainLocId)) {
				$('#VirtualFlag').checkbox('setValue', true);
			} else {
				$('#VirtualFlag').checkbox('setValue', false);
			}
			$UI.fillBlock('#MainConditions', jsonData);
			SetFieldDisabled('disable');
			if ($HUI.checkbox('#Complete').getValue()) {
				ChangeButtonEnable('1^1^0^0^0^1');
			} else {
				ChangeButtonEnable('1^1^1^1^1^0');
			}
		});
		InGdRecGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
			QueryName: 'QueryDetail',
			query2JsonStrict: 1,
			Parref: RecRowid,
			rows: 99999
		});
	};
	
	var addOneRow = {
		text: '����',
		iconCls: 'icon-add',
		handler: function() {
			var AllRows = InGdRecGrid.getRows();
			var LastRowIndex = InGdRecGrid.editIndex;
			var Row = AllRows[LastRowIndex];
			var DefaData = {};
			if ((!isEmpty(AllRows)) && (!isEmpty(Row))) {
				if (IngrParamObj.CompareNamePrice == 'Y') { // ͬ�ϴ�����ж��Ƿ�ļ�;������;
					var Inci = Row.IncId;
					var Rp = Row.Rp;
					var Incidesc = Row.IncDesc;
					var CompareNamePrice = tkMakeServerCall('web.DHCSTMHUI.DHCINGdRec', 'CheckNamePrice', Inci, Rp);
					if (CompareNamePrice == -1) {
						$UI.msg('alert', Incidesc + '���������޸�!');
					}
					if (CompareNamePrice == -2) {
						$UI.msg('alert', Incidesc + '�Ľ����ѵ���!');
					}
				}
				var tmpInvNo = Row.InvNo;
				var tmpInvDate = Row.InvDate;
				if (IngrParamObj.DefaInvNo == 'Y') {
					DefaData = { InvNo: tmpInvNo, InvDate: tmpInvDate };
				}
			}
			InGdRecGrid.commonAddRow(DefaData);
		}
	};
	var delDetail = function() {
		if ($HUI.checkbox('#Complete').getValue()) {
			$UI.msg('alert', '��ⵥ�����!');
			return false;
		}
		if (IngrParamObj.MakeByPoOnly == 'Y') {
			$UI.msg('alert', '��ⵥ��Ͷ�������һ��,����ɾ��!');
			return false;
		}
		return true;
	};
	var deleteOneRow = {
		text: 'ɾ��',
		iconCls: 'icon-cancel',
		handler: function() {
			if (delDetail()) {
				InGdRecGrid.commonDeleteRow();
			}
		}
	};
	
	var InGdRecCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			saveCol: true,
			hidden: true,
			width: 100
		}, {
			title: '����RowId',
			field: 'IncId',
			saveCol: true,
			hidden: true,
			width: 100
		}, {
			title: '���ʴ���',
			field: 'IncCode',
			width: 100
		}, {
			title: '��������',
			field: 'IncDesc',
			width: 230
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '��ֵ����',
			field: 'HVBarCode',
			width: 180,
			jump: false,
			saveCol: true,
			editor: {
				type: 'validatebox',
				options: {
					required: true,
					tipPosition: 'bottom'
				}
			}
		}, {
			title: '��ֵ��־',
			field: 'HVFlag',
			width: 80,
			hidden: true,
			formatter: BoolFormatter
		}, {
			title: '����������ʱID',
			field: 'TmpManfId',
			width: 150,
			hidden: true
		}, {
			title: '��������RowId',
			field: 'ManfId',
			width: 150,
			saveCol: true,
			hidden: true/*,
			formatter: CommonFormatter(PhManufacturerBox,'ManfId','Manf'),
			editor:PhManufacturerBox*/
		}, {
			title: '��������',
			field: 'Manf',
			width: 150
		}, {
			title: '����',
			field: 'BatchNo',
			width: 90,
			saveCol: true,
			editor: {
				type: 'text',
				options: {
				}
			}
		}, {
			title: '��Ч��',
			field: 'ExpDate',
			width: 100,
			saveCol: true,
			editor: {
				type: 'datebox',
				options: {
				}
			}
		}, {
			title: '��λ',
			field: 'IngrUomId',
			width: 80,
			saveCol: true,
			formatter: CommonFormatter(UomCombox, 'IngrUomId', 'IngrUom'),
			editor: UomCombox
		}, {
			title: '����',
			field: 'RecQty',
			width: 80,
			align: 'right',
			saveCol: true,
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					tipPosition: 'bottom',
					min: 0,
					precision: 0
				}
			}
		}, {
			title: '����',
			field: 'Rp',
			width: 60,
			align: 'right',
			saveCol: true,
			editor: (IngrParamObj.AllowEditRp == 'N' ? true : false) ? null : {
				type: 'numberbox',
				options: {
					required: true,
					min: 0,
					precision: GetFmtNum('FmtRP')
				}
			}
		}, {
			title: '�ۼ�',
			field: 'Sp',
			width: 60,
			align: 'right',
			saveCol: true
		}, {
			title: '��ǰ�ӳ�',
			field: 'Marginnow',
			width: 60
		}, {
			title: '����ۼ�',
			field: 'NewSp',
			width: 60,
			align: 'right',
			saveCol: true,
			editor: IngrParamObj.NewSpAsSp == 'N' ? null : {
				type: 'numberbox',
				options: {
					required: true,
					tipPosition: 'bottom',
					min: 0,
					precision: GetFmtNum('FmtSP')
				}
			}
		}, {
			title: '��Ʊ����',
			field: 'InvCode',
			width: 80,
			saveCol: true,
			editor: {
				type: 'text'
			}
		}, {
			title: '��Ʊ��',
			field: 'InvNo',
			width: 80,
			saveCol: true,
			editor: {
				type: 'text'
			}
		}, {
			title: '��Ʊ���',
			field: 'InvMoney',
			width: 80,
			align: 'right',
			saveCol: true
		}, {
			title: '��Ʊ����',
			field: 'InvDate',
			width: 100,
			saveCol: true,
			editor: {
				type: 'datebox',
				options: {
				}
			}
		}, {
			title: '�ʼ쵥��',
			field: 'QualityNo',
			width: 90,
			saveCol: true,
			editor: {
				type: 'text',
				options: {
				}
			}
		}, {
			title: '���е���',
			field: 'SxNo',
			width: 90,
			saveCol: true,
			editor: {
				type: 'text',
				options: {
				}
			}
		}, {
			title: '����ҽ������',
			field: 'MatInsuCode',
			width: 160
		}, {
			title: '����ҽ������',
			field: 'MatInsuDesc',
			width: 160
		}, {
			title: '�������',
			field: 'RpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '��������',
			field: 'MtDesc',
			width: 180
		}, {
			title: 'ժҪ',
			field: 'Remark',
			width: 90,
			saveCol: true,
			editor: {
				type: 'text',
				options: {
				}
			}
		}, {
			title: '��ע',
			field: 'Remarks',
			width: 90,
			saveCol: true,
			editor: {
				type: 'text',
				options: {
				}
			}
		}, {
			title: 'BUomId',
			field: 'BUomId',
			width: 10,
			hidden: true
		}, {
			title: 'ConFacPur',
			field: 'ConFacPur',
			width: 10,
			hidden: true
		}, {
			title: 'MtDr',
			field: 'MtDr',
			width: 10,
			saveCol: true,
			hidden: true
		}, {
			title: '�������',
			field: 'SterilizedNo',
			width: 90,
			saveCol: true,
			editor: {
				type: 'text',
				options: {
				}
			}
		}, {
			title: '��������',
			field: 'InPoQty',
			width: 20,
			align: 'right',
			hidden: true
		}, {
			title: '����Ҫ��',
			field: 'BatchReq',
			width: 10,
			hidden: true
		}, {
			title: '��Ч��Ҫ��',
			field: 'ExpReq',
			width: 10,
			hidden: true
		}, {
			title: 'ע��֤��',
			field: 'AdmNo',
			width: 100,
			saveCol: true,
			editable: false,
			formatter: CommonFormatter(RegCertBox, 'AdmNo', 'AdmNo'),
			editor: RegCertBox
		}, {
			title: 'ע��֤��Ч��',
			field: 'AdmExpdate',
			width: 100,
			saveCol: true,
			editor: {
				type: 'datebox',
				options: {
				}
			}
		}, {
			title: '������',
			field: 'SpecDesc',
			width: 100,
			saveCol: CodeMainParamObj.UseSpecList == 'Y' ? true : false,
			formatter: CommonFormatter(SpecDescbox, 'SpecDesc', 'SpecDesc'),
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true
		// editor:(CodeMainParamObj.UseSpecList=="Y"?false:true)?null:SpecDescbox
		}, {
			title: '������',
			field: 'reqLocId',
			width: 80,
			saveCol: true,
			formatter: CommonFormatter(reqLocCombox, 'reqLocId', 'reqLocDesc'),
			editor: reqLocCombox
		}, {
			title: '��Ʒ˰��',
			field: 'Tax',
			width: 100,
			align: 'right',
			saveCol: true,
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					precision: GetFmtNum('FmtRP')
				}
			}
		}, {
			title: '��Ʒ��˰��',
			field: 'TaxAmt',
			width: 100,
			align: 'right'
		}, {
			title: 'OrderDetailSubId',
			field: 'OrderDetailSubId',
			width: 80,
			saveCol: true,
			hidden: true
		}, {
			title: '������ϸid',
			field: 'Inpoi',
			width: 80,
			saveCol: true,
			hidden: true
		}, {
			title: 'dhcit',
			field: 'dhcit',
			width: 80,
			hidden: true
		}, {
			title: 'Inpoi',
			field: 'Inpoi',
			width: 80,
			hidden: true
		}, {
			title: '�Դ�����',
			field: 'OrigiBarCode',
			width: 80,
			hidden: hiddenOrigiBarCode
		}, {
			title: '��������',
			field: 'ProduceDate',
			width: 100,
			saveCol: true,
			editor: {
				type: 'datebox'
			}
		}, {
			title: '��������',
			field: 'OriginalStatus',
			width: 80,
			formatter: OriginalStatusFormatter
		}
	]];
	function ReturnInfoFunc(RowData, row) {
		var RecLocId = $('#RecLoc').combobox('getValue');
		var ParamsObj = addSessionParams({ RecLocId: RecLocId });
		var Params = JSON.stringify(ParamsObj);
		var ItmData = $.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			MethodName: 'GetItmInfo',
			IncId: row.Inci,
			Params: Params
		}, false);
		var tmpManfId = ''; tmpManf = ''; tmpBatchNo = ''; tmpExpDate = ''; tmpAdmNo = ''; tmpAdmExpdate = ''; Margin = 0;
		if (!isEmpty(row.ManfId)) {
			tmpManfId = row.ManfId;
			tmpManf = row.ManfDesc;
		} else {
			tmpManfId = ItmData.ManfId;
			tmpManf = ItmData.ManfDesc;
		}
		if (!isEmpty(row.BatNo)) {
			tmpBatchNo = row.BatNo;
		} else {
			tmpBatchNo = ItmData.BatNo;
		}
		if (!isEmpty(row.ExpDate)) {
			tmpExpDate = row.ExpDate;
		} else {
			tmpExpDate = ItmData.ExpDate;
		}
		if (!isEmpty(row.CertNo)) {
			tmpAdmNo = row.CertNo;
		} else {
			tmpAdmNo = ItmData.CertNo;
		}
		if (!isEmpty(row.CertExpDate)) {
			tmpAdmExpdate = row.CertExpDate;
		} else {
			tmpAdmExpdate = ItmData.CertExpDate;
		}
		// �ӳ���
		var Sp = row.Sp;
		var Rp = row.BRp;
		if (Sp != 0) {
			Margin = accSub(accDiv(Sp, Rp), 1);
		}
		var RowIndex = InGdRecGrid.editIndex;
		InGdRecGrid.updateRow({
			index: RowIndex,
			row: {
				Inci: row.InciDr,
				IncId: row.Inci,
				IncCode: row.Code,
				IncDesc: row.Description,
				Inpoi: row.Poi,
				RecQty: 1,
				Rp: row.BRp,
				RpAmt: row.BRp,
				SpecDesc: row.SpecDesc,
				reqLocId: row.ReqLoc,
				reqLocDesc: row.ReqLocDesc,
				SxNo: row.SxNo,
				SterilizedNo: row.SterilizedNo,
				OrigiBarCode: row.OrigiBarCode,
				OriginalStatus: row.OriginalStatus,
				TmpManfId: tmpManfId,
				ManfId: tmpManfId,
				Manf: tmpManf,
				BatchNo: tmpBatchNo,
				ExpDate: tmpExpDate,
				AdmNo: tmpAdmNo,
				AdmExpdate: tmpAdmExpdate,
				Sp: row.Sp,
				SpAmt: row.Sp,
				NewSp: row.Sp,
				InvMoney: row.BRp,
				Spec: ItmData.Spec,
				HVFlag: ItmData.HVFlag,
				BUomId: ItmData.BUomId,
				IngrUomId: ItmData.BUomId,
				IngrUom: ItmData.BUomDesc,
				MtDr: ItmData.MtDr,
				MtDesc: ItmData.MtDesc,
				PubDesc: ItmData.PbDesc,
				ConFacPur: ItmData.ConFac,
				BatchReq: ItmData.BatchReq,
				ExpReq: ItmData.ExpReq,
				Marginnow: Margin,
				ProduceDate: row.ProduceDate,
				MatInsuCode: ItmData.MatInsuCode,
				MatInsuDesc: ItmData.MatInsuDesc
			}
		});
		setTimeout(function() {
			InGdRecGrid.refreshRow();
			InGdRecGrid.commonAddRow();
		}, 50);
	}
	var InGdRecGrid = $UI.datagrid('#InGdRecGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
			QueryName: 'QueryDetail',
			query2JsonStrict: 1,
			rows: 99999
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
			MethodName: 'Delete'
		},
		columns: InGdRecCm,
		checkField: 'dhcit',
		showBar: true,
		toolbar: [addOneRow, deleteOneRow],
		pagination: false,
		onClickCell: function(index, field, value) {
			if ($HUI.checkbox('#Complete').getValue()) {
				$UI.msg('alert', '��ⵥ�����!');
				return false;
			}
			var Row = InGdRecGrid.getRows()[index];
			if ((!isEmpty(Row.IncId) && ((field == 'HVBarCode') || (field == 'IngrUomId')))) {
				return false;
			}
			if ((!isEmpty(Row.IncId) && (field == 'RecQty') && (Row.OriginalStatus != 'NotUnique'))) {
				return false;
			}
			/* if ((field == 'ManfId')&&(!isEmpty(Row.TmpManfId))&&(ItmTrackParamObj.IfRecVenManfEdit=="N")) {
				$UI.msg('alert','����������ά���������޸�!');
				return false;
			}*/
			InGdRecGrid.commonClickCell(index, field, value);
		},
		onBeforeEdit: function(index, row) {
			if ($HUI.checkbox('#Complete').getValue()) {
				$UI.msg('alert', '��ⵥ�����!');
				return false;
			}
		},
		onBeginEdit: function(index, row) {
			var ed = $('#InGdRecGrid').datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++) {
				var Editor = ed[i];
				if (Editor.field == 'HVBarCode') {
					$(Editor.target).bind('keydown', function(event) {
						if (event.keyCode == 13) {
							var BarCode = $(this).val();
							if (isEmpty(BarCode)) {
								InGdRecGrid.stopJump();
								return false;
							}
							var FindIndex = InGdRecGrid.find('HVBarCode', BarCode);
							if (FindIndex >= 0 && FindIndex != index) {
								$UI.msg('alert', '���벻���ظ�¼��!');
								$(this).val('');
								$(this).focus();
								InGdRecGrid.stopJump();
								return false;
							}
							var BarCodeData = $.cm({
								ClassName: 'web.DHCSTMHUI.DHCItmTrack',
								MethodName: 'GetItmByBarcode',
								BarCode: BarCode
							}, false);
							if (!isEmpty(BarCodeData.success) && BarCodeData.success != 0) {
								$UI.msg('alert', BarCodeData.msg);
								$(this).val('');
								$(this).focus();
								InGdRecGrid.stopJump();
								return false;
							}
							var ScgStk = BarCodeData['ScgStk'];
							var ScgStkDesc = BarCodeData['ScgStkDesc'];
							var dhcitLocId = BarCodeData['dhcitLocId'];
							var IsAudit = BarCodeData['IsAudit'];
							var OperNo = BarCodeData['OperNo'];
							var Type = BarCodeData['Type'];
							var Status = BarCodeData['Status'];
							var RecallFlag = BarCodeData['RecallFlag'];
							var Inci = BarCodeData['Inci'];
							var Code = BarCodeData['Code'];
							var Description = BarCodeData['Description'];
							var dhcit = BarCodeData['dhcit'];
							var ManfId = BarCodeData['ManfId'], ManfDesc = BarCodeData['ManfDesc'];
							var Poi = BarCodeData['Poi'], BatNo = BarCodeData['BatNo'], ExpDate = BarCodeData['ExpDate'];
							var CertNo = BarCodeData['CertNo'], CertExpDate = BarCodeData['CertExpDate'], BRp = BarCodeData['BRp'];
							var OriginalStatus = BarCodeData['OriginalStatus'];
							var StkGrpId = $('#StkGrpId').combobox('getValue');
							var VendorId = BarCodeData['VendorId'];
							if ($HUI.combobox('#Vendor').getValue() == '') {
								$HUI.combobox('#Vendor').setValue(VendorId);
							}
							var TmpVendorId = $HUI.combobox('#Vendor').getValue();
							if ((VendorId != TmpVendorId) && (ItmTrackParamObj.IfRecVenManfEdit == 'N')) {
								$UI.msg('alert', '����' + BarCode + '�Ĺ�Ӧ���뵱ǰѡ��Ӧ�̲�һ��!');
								return false;
							}
							if ((Type != 'Reg' && Type != 'G' && OriginalStatus != 'NotUnique') || (Type == 'G' && IsAudit == 'Y' && OriginalStatus != 'NotUnique')) {
								$UI.msg('alert', '�������Ѱ������!');
								$(this).val('');
								$(this).focus();
								InGdRecGrid.stopJump();
								return false;
							} else if (Type == 'G' && IsAudit != 'Y') {
								$UI.msg('alert', '��������δ��˵�' + OperNo + ',���ʵ!');
								$(this).val('');
								$(this).focus();
								InGdRecGrid.stopJump();
								return false;
							} else if (!isEmpty(dhcitLocId) && (gLocId != dhcitLocId)) {
								$UI.msg('alert', '������Ǳ�����ע������!');
								$(this).val('');
								$(this).focus();
								InGdRecGrid.stopJump();
								return false;
							}
							$(this).val(BarCode).validatebox('validate');
							row['HVBarCode'] = BarCode;
							row['dhcit'] = dhcit;
							ReturnInfoFunc(row, BarCodeData);
						}
					});
				}
				if ((Editor.field == 'InvCode') || (Editor.field == 'InvNo')) {
					$(Editor.target).bind('keydown', function(event) {
						if (event.keyCode == 13) {
							var InvInfo = $(this).val();
							SetInvInfo(InvInfo);
						}
					});
				}
			}
		},
		beforeAddFn: function() {
			if (IngrParamObj.NewSpAsSp !== 'Y') {
				InGdRecGrid.hideColumn('NewSp');
			}
			var ParamsObj = GetParamsObj();
			if ($HUI.checkbox('#Complete').getValue()) {
				$UI.msg('alert', '��ⵥ�����!');
				return false;
			}
			if (isEmpty(ParamsObj.RecLoc)) {
				$UI.msg('alert', '�����Ҳ���Ϊ��!');
				return false;
			}
			/*
			if(isEmpty(ParamsObj.Vendor)){
				$UI.msg('alert','��Ӧ�̲���Ϊ��!');
				return false;
			}
			*/
			if (isEmpty(ParamsObj.StkGrpId) && isEmpty(ScgTipFlag)) {
				$UI.msg('alert', 'δѡ�����飬�������ʵ����!');
				ScgTipFlag = 'Y';
			}
			if ((IngrParamObj.ImpTypeNotNull == 'Y') && (isEmpty(ParamsObj.IngrTypeId))) {
				$UI.msg('alert', '������Ͳ���Ϊ��!!');
				return false;
			}
			if (IngrParamObj.MakeByPoOnly == 'Y') {
				$UI.msg('alert', '�������ݶ������,��������!');
				return false;
			}
			if ((IngrParamObj.RequiredSourceOfFund == 'Y') && (isEmpty(ParamsObj.SourceOfFund))) {
				$UI.msg('alert', '�ʽ���Դ����Ϊ��!');
				return false;
			}
			SetFieldDisabled('disable');
		},
		onEndEdit: function(index, row, changes) {
			var IncId = row.IncId;
			if (isEmpty(IncId)) {
				$UI.msg('alert', '��Ч��ϸ!');
				InGdRecGrid.checked = false;
				return false;
			}
			// �ж�����
			var VendorId = $('#Vendor').combo('getValue');
			var CheckCertObj = addSessionParams({
				Manf: row.ManfId,
				Inci: row.IncId,
				Vendor: VendorId
			});
			var CheckCertRet = Common_CheckCert(CheckCertObj, 'In');
			if (!CheckCertRet) {
				InGdRecGrid.checked = false;
				return false;
			}
			var Editors = $(this).datagrid('getEditors', index);
			for (var i = 0; i < Editors.length; i++) {
				var Editor = Editors[i];
				if (Editor.field == 'Rp') {
					var rp = row.Rp;
					if (isEmpty(rp)) {
						$UI.msg('alert', '���۲���Ϊ��!');
						InGdRecGrid.checked = false;
						return false;
					} else if (rp < 0) {
						// 2016-09-26���ۿ�Ϊ0
						$UI.msg('alert', '���۲���С��0!');
						InGdRecGrid.checked = false;
						return false;
					}
					var UomId = row.IngrUomId;
					var sp = tkMakeServerCall('web.DHCSTMHUI.DHCINGdRec', 'GetSpForRec', IncId, UomId, rp, SessionParams);
					row.Sp = sp;
					// ��֤�ӳ���
					var ChargeFlag = tkMakeServerCall('web.DHCSTMHUI.Common.DrugInfoCommon', 'GetChargeFlag', IncId);
					var margin = 0;
					if ((rp != 0) && (ChargeFlag == 'Y')) {
						margin = accSub(accDiv(sp, rp), 1);
						if ((IngrParamObj.MarginWarning != 0) && ((margin > IngrParamObj.MarginWarning) || (margin < 0))) {
							$UI.msg('alert', '�ӳ��ʳ����޶���Χ!');
							InGdRecGrid.checked = false;
							return false;
						}
					}
					// ����ָ���еĽ������
					var RealTotal = accMul(row.RecQty, rp);
					row.NewSp = sp;
					row.RpAmt = RealTotal;
					row.InvMoney = RealTotal;
					row.Marginnow = margin.toFixed(3);
					// / �Ƿ����
					var PriorPriceInfo = tkMakeServerCall('web.DHCSTMHUI.DHCINGdRec', 'GetPrice', IncId, UomId, SessionParams);
					var PriorPriceArr = PriorPriceInfo.split('^');
					var PriorRp = PriorPriceArr[0];
					var PriorSp = PriorPriceArr[1];
					var ResultRp = row.Rp;
					var ResultSp = row.Sp;
					var AllowAspWhileReceive = IngrParamObj.AllowAspWhileReceive;
					var IfExitPriceAdj = tkMakeServerCall('web.DHCSTMHUI.INAdjSalePrice', 'CheckItmAdjSp', IncId, '');
					if ((AllowAspWhileReceive == 'Y') && (Number(PriorSp) != Number(ResultSp)) && (IfExitPriceAdj != 1)) {
						var Scg = $('#StkGrpId').combotree('getValue');
						var LocDr = $('#RecLoc').combo('getValue');
						var Obj = { Incid: row.IncId, Incicode: row.IncCode, Incidesc: row.IncDesc, PriorRp: PriorRp, PriorSp: PriorSp,
							ResultRp: ResultRp, ResultSp: ResultSp, AdjSpUomId: row.IngrUomId, StkGrpType: Scg, LocDr: LocDr };
						var adjPriceObj = addSessionParams(Obj);
						$UI.confirm('�۸����仯���Ƿ����ɵ��۵�?', '', '', SetAdjPrice, '', '', '', '', adjPriceObj);
					}
				} else if (Editor.field == 'RecQty') {
					var Tax = row.Tax;
					var RecQty = row.RecQty;
					var Rp = row.Rp;
					if ((isEmpty(RecQty)) || (RecQty <= 0)) {
						$UI.msg('alert', '�����������С�ڻ����0!');
						InGdRecGrid.checked = false;
						return false;
					}
					var InPoQty = row.InPoQty;
					if ((IngrParamObj.RecQtyExceedOrderAllowed != 'Y') && (InPoQty != '') && (Number(RecQty) > Number(InPoQty))) {
						$UI.msg('alert', '����������ܴ��ڶ�������!');
						InGdRecGrid.checked = false;
						return false;
					}
					var RealTotal = accMul(Rp, RecQty);
					if (!isEmpty(Tax)) {
						var TaxAmt = accMul(Tax, RecQty);
						row.TaxAmt = TaxAmt;
					}
					row.RpAmt = RealTotal;
					row.InvMoney = RealTotal;
				} else if (Editor.field == 'Tax') {
					var Tax = row.Tax;
					var RecQty = row.RecQty;
					var TaxAmt = accMul(Tax, RecQty);
					row.TaxAmt = TaxAmt;
				} else if (Editor.field == 'InvNo') {
					var flag = InvNoValidator(row.InvNo, $('#IngrId').val());
					if (flag == false) {
						$UI.msg('alert', '��Ʊ��' + row.InvNo + '�Ѵ����ڱ����ⵥ!');
					}
					if ((isEmpty(row.InvNo)) && (IngrParamObj.InvNoNotNull == 'Y')) {
						$UI.msg('alert', '��Ʊ�Ų���Ϊ��!');
						InGdRecGrid.checked = false;
						return false;
					}
				} else if (Editor.field == 'NewSp') {
					var NewSp = row.NewSp;
					if ((CommParObj.BatSp == 1) && ((isEmpty(NewSp)) || (NewSp < 0))) {
						$UI.msg('alert', '����ۼ۲���С��0!');
						InGdRecGrid.checked = false;
						return false;
					}
				}/* else if(Editor.field=='ManfId'){
					var ManfId=row.ManfId;
					if ((IngrParamObj.ManfNotNull!="Y")&&(isEmpty(ManfId))){
						$UI.msg('alert',"����������Ҳ���Ϊ��!");
						InGdRecGrid.checked=false;
						return false;
					}
				}*/else if (Editor.field == 'ProduceDate') {
					var ProduceDate = row.ProduceDate;
					var ExpireDate = row.ExpDate;
					if ((IngrParamObj.DefaExpDate == '3') && (!isEmpty(ProduceDate)) && (isEmpty(ExpireDate))) {
						var DefaultBatExp = tkMakeServerCall('web.DHCSTMHUI.DHCINGdRec', 'GetDefaultBatExp', IncId, SessionParams, ProduceDate);
						var ExpDate = DefaultBatExp.split('^')[1];
						InGdRecGrid.updateRow({
							index: InGdRecGrid.editIndex,
							row: {
								ExpDate: ExpDate
							}
						});
						$('#InGdRecGrid').datagrid('refreshRow', InGdRecGrid.editIndex);
					}
				}
			}
		},
		rowStyler: function(index, row) {
			if (row.Sp < 0) {
				$UI.msg('alert', '�ۼ۲���С����!');
				return 'background-color:yellow;color:black;font-weight:bold;';
			}
		}
	});
	function SetInvInfo(InvInfo) {
		var InvObj = GetInvInfo(InvInfo);
		if (InvObj === false) {
			$UI.msg('alert', '��¼����ȷ�ķ�Ʊ��Ϣ!');
			return;
		} else if (!isEmpty(InvObj)) {
			var InvCode = InvObj.InvCode;
			var InvNo = InvObj.InvNo;
			var InvAmt = InvObj.InvAmt;
			var InvDate = InvObj.InvDate;
			InGdRecGrid.updateRow({
				index: InGdRecGrid.editIndex,
				row: {
					InvCode: InvCode,
					InvNo: InvNo,
					// InvMoney:InvAmt,
					InvDate: InvDate
				}
			});
			$('#InGdRecGrid').datagrid('refreshRow', InGdRecGrid.editIndex);
		}
	}
	IngrClear();
	if (!isEmpty(gIngrRowid)) {
		Select(gIngrRowid);
	}
};
$(init);