/*��ֵ��������*/
var init = function () {
	var RowIdStr = "";
	
	var FRecLocParams=JSON.stringify(addSessionParams({Type:"Login"}));
	$HUI.combobox('#InGdRecLocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+FRecLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var VendorParams=JSON.stringify(addSessionParams({APCType:"M",RcFlag:"Y"}));
	$HUI.combobox('#InGdReqVendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var tRecLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	$HUI.combobox('#InGdReqLocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+tRecLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$HUI.combobox('#VendorId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var SourceOfFundParams=JSON.stringify(addSessionParams());
	$HUI.combobox('#Source', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSourceOfFund&ResultSetType=array&Params='+SourceOfFundParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$HUI.checkbox('#XK',{
		onCheckChange: function(e, value){
			if(value){
				var RecLoc = $('#InGdRecLocId').combobox('getValue');
				var Info = tkMakeServerCall('web.DHCSTMHUI.Common.UtilCommon','GetMainLoc',RecLoc);
				var InfoArr = Info.split("^");
				var VituralLoc = InfoArr[0], VituralLocDesc = InfoArr[1];
				AddComboData($('#InGdRecLocId'), VituralLoc, VituralLocDesc);
				$('#InGdRecLocId').combobox('setValue', VituralLoc);
			}else{
				$('#InGdRecLocId').combobox('setValue', gLocId);
			}
		}
	});
	
	
	var Clear = function () {
		RowIdStr = "";
		$UI.clearBlock('#MainConditions');
		$UI.clear(BarCodeGrid);
		$UI.clearBlock('#IngrConditions');
		SetDefaValues();
	}
	function SetDefaValues() {
		var IngrDefa = {
			InGdRecLocId: gLocObj
		};
		$UI.fillBlock('#IngrConditions', IngrDefa);
		
		var SearchDefa = {
			CreateLoc: gLocObj,
			StartDate: TrackDefaultStDate(),
			EndDate: TrackDefaultEdDate()
		};
		$UI.fillBlock('#MainConditions', SearchDefa);
		$('#ScgId').combotree('options')['setDefaultFun']();
	}
	$UI.linkbutton('#SaveInGdRecBT', {
		onClick: function () {
			SaveIngr();
		}
	});

	//��ӡ��ť��Ӧ����
	var PrintBtn = $('#Print').menubutton({ menu: '#mm-Print' });
	$(PrintBtn.menubutton('options').menu).menu({
		onClick: function (item) {
			var BtnName = item.name;		//div������name����
			if (BtnName == 'PrintBarCode') {
				var rowsData = BarCodeGrid.getSelections();
				if (rowsData.length <= 0) {
					$UI.msg('alert', 'û��Ҫ��ֵ����!');
					return;
				}
				var count = rowsData.length;
				for (var rowIndex = 0; rowIndex < count; rowIndex++) {
					var row = rowsData[rowIndex];
					var BarCode = row.BarCode;
					PrintBarcode(BarCode, 1);
				}
			} else if (BtnName == 'PrintBarCode2') {
				var rowsData = BarCodeGrid.getSelections();
				if (rowsData.length <= 0) {
					$UI.msg('alert', 'û��Ҫ��ֵ����!');
					return;
				}
				var count = rowsData.length;
				for (var rowIndex = 0; rowIndex < count; rowIndex++) {
					var row = rowsData[rowIndex];
					var BarCode = row.BarCode;
					PrintBarcode(BarCode, 2);
				}
			} else if (BtnName == 'PrintPage') {
				var rowsData = BarCodeGrid.getRows();
				if (rowsData.length <= 0) {
					$UI.msg('alert', 'û��Ҫ��ֵ����!');
					return;
				}
				var count = rowsData.length;
				for (var rowIndex = 0; rowIndex < count; rowIndex++) {
					var row = rowsData[rowIndex];
					var BarCode = row.BarCode;
					PrintBarcode(BarCode, 1);
				}
			} else if (BtnName == 'PrintPage2') {
				var rowsData = BarCodeGrid.getRows();
				if (rowsData.length <= 0) {
					$UI.msg('alert', 'û��Ҫ��ֵ����!');
					return;
				}
				var count = rowsData.length;
				for (var rowIndex = 0; rowIndex < count; rowIndex++) {
					var row = rowsData[rowIndex];
					var BarCode = row.BarCode;
					PrintBarcode(BarCode, 2);
				}
			}
		}
	});

	var ImportBtn = $('#ImportEdit').menubutton({ menu: '#mm-Import' });
	$(ImportBtn.menubutton('options').menu).menu({
		onClick: function (item) {
			var BtnName = item.name;
			if (BtnName == 'ImpPo') {
				ImportPoSearch(getPoList);
			} else if (BtnName == 'ImpSciPo') {
				ImportSciPoSearch(QueryForSciPo);
			}
		}
	});
	function getPoList(rowsData,VendorId,VendorDesc) {
		if (isEmpty(rowsData)) {
			return;
		}
		if (rowsData.rows.length <= 0) {
			return;
		}
		for (var i = 0; i < rowsData.rows.length; i++) {
			var row = rowsData.rows[i];
			var record = {
				InciId: row.IncId,
				InciCode: row.IncCode,
				InciDesc: row.IncDesc,
				Qty: row.PurQty,
				Rp: row.Rp,
				CertNo: row.CertNo,
				CertExpDate: row.CertExpDate,
				BUomId: row.PurUomId,
				BUom: row.PurUom,
				VendorId: VendorId,
				VendorDesc: VendorDesc
			};
			BarCodeGrid.appendRow(record);
		}
	}

	function QueryForSciPo(IdStr) {
		RowIdStr = IdStr;
		Query();
	}

	$UI.linkbutton('#CopyBatNoBT', {
		onClick: function () {
			var rows = BarCodeGrid.getRows();
			var len = rows.length;
			if (len == 0) {
				$UI.msg('alert', 'û��Ҫ������ϸ!');
				return false;
			}
			SaveBatExpWin(SaveBatExp);
		}
	});

	function SaveBatExp(Params) {
		BarCodeGrid.endEditing();
		var FillFlag = $("input[name='Fill']:checked").val();	//1:������, 2:��������
		var BatNo = Params.BatNo;
		var ExpDate = Params.ExpDate;
		var Rows = BarCodeGrid.getRows();
		var len = Rows.length;
		var FillCount = 0;
		for (var index = 0; index < len; index++) {
			var RowData = Rows[index];
			if ((FillFlag == '1') && !(isEmpty(RowData.BatchNo) && isEmpty(RowData.ExpDate))) {
				continue;
			}
			$('#BarCodeGrid').datagrid('endEdit', index);
			$('#BarCodeGrid').datagrid('selectRow', index);
			//$('#BarCodeGrid').datagrid('endEdit', index).datagrid('beginEdit', index);

			$('#BarCodeGrid').datagrid('editCell', { index: index, field: 'BatchNo' });
			var ed = $('#BarCodeGrid').datagrid('getEditor', { index: index, field: 'BatchNo' });
			ed.target.val(BatNo);

			$('#BarCodeGrid').datagrid('editCell', { index: index, field: 'ExpDate' });
			var ed = $('#BarCodeGrid').datagrid('getEditor', { index: index, field: 'ExpDate' });
			$(ed.target).datebox('setValue', ExpDate);

			$('#BarCodeGrid').datagrid('endEdit', index);
			FillCount++;
		}
		if (FillCount > 0) {
			$UI.msg('alert', '�����' + FillCount + '��, ��ע�Ᵽ��!');
		} else {
			$UI.msg('error', 'δ������Ч���!');
		}
	}


	var SpecDescParams = JSON.stringify(sessionObj);
	var SpecDescbox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSpecDesc&ResultSetType=array&Params=' + SpecDescParams,
			valueField: 'Description',
			textField: 'Description',
			mode: 'remote',
			onBeforeLoad: function (param) {
				var rows = BarCodeGrid.getRows();
				var row = rows[BarCodeGrid.editIndex];
				if (!isEmpty(row)) {
					param.Inci = row.InciId;
				}
			}
		}
	};
	function SaveIngr() {
		BarCodeGrid.endEditing();
		var RowsData = BarCodeGrid.getChecked();
		// ��Ч����
		var count = 0;
		for (var i = 0; i < RowsData.length; i++) {
			var item = RowsData[i].RowId;
			if (!isEmpty(item)) {
				count++;
			}
		}
		if (RowsData.length <= 0 || count <= 0) {
			$UI.msg('alert', '��ѡ�������ϸ!');
			return false;
		}

		var IngrParamObj = $UI.loopBlock('#IngrConditions');
		// �ж���ⵥ�Ƿ�������
		// �ж���ⲿ�ź͹������Ƿ�Ϊ��
		var phaLoc = IngrParamObj.InGdRecLocId;
		if (isEmpty(phaLoc)) {
			$UI.msg('alert','��ѡ��������!');
			return false;
		}
		var vendor = IngrParamObj.InGdReqVendor;
		if (isEmpty(vendor)) {
			$UI.msg('alert','��ѡ��Ӧ��!');
			return false;
		}
		var CheckMsgArr = [];
		for(var i = 0, Len = RowsData.length; i < Len; i++){
			var NullInfoArr = [];
			var RowData = RowsData[i];
			if((RowData['BatchReq'] == 'R') && isEmpty(RowData['BatchNo'])){
				NullInfoArr.push('����');
			}
			if((RowData['ExpReq'] == 'R') && isEmpty(RowData['ExpDate'])){
				NullInfoArr.push('��Ч��');
			}
			if((RowData['ExpReq'] == 'R') && isEmpty(RowData['ProduceDate'])){
				NullInfoArr.push('��������');
			}
			if(!isEmpty(NullInfoArr)){
				var RowIndex = BarCodeGrid.getRowIndex(RowData);
				var NullInfo = NullInfoArr.join('��');
				var MsgStr = '��' + (RowIndex + 1) + '��' + NullInfo + 'û��¼��';
				CheckMsgArr.push(MsgStr);
			}
		}
		if(!isEmpty(CheckMsgArr)){
			var CheckMsg = CheckMsgArr.join();
			$UI.msg('error', CheckMsg);
			return;
		}
		var ParamsObj = $CommonUI.loopBlock('#MainConditions');
		var ScgId=ParamsObj.ScgId;
		var IngrParamObj=jQuery.extend(true,IngrParamObj,{ScgId:ScgId});
		var Main = JSON.stringify(IngrParamObj);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			MethodName: 'CreatIngr',
			MainInfo: Main,
			ListDetail: JSON.stringify(RowsData)
		}, function (jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				var IngrRowid = jsonData.rowid;
				$UI.clear(BarCodeGrid);
				
				var UrlStr='dhcstmhui.ingdrechv.csp?RowId=' + IngrRowid;
				Common_AddTab('��ֵ���', UrlStr);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			Query();
		}
	});

	function Query() {
		var ParamsObj = $CommonUI.loopBlock('#MainConditions');
		if (isEmpty(ParamsObj.StartDate)) {
			$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
			return;
		}
		if (isEmpty(ParamsObj.EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
			return;
		}
		ParamsObj.RowIdStr = RowIdStr;
		var Params = JSON.stringify(ParamsObj);
		BarCodeGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'queryRegHVs',
			Params: Params,
			rows:99999
		});
		RowIdStr = '';
	}
	$UI.linkbutton('#SaveBT', {
		onClick: function () {
			SaveBarCode();
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function () {
			Clear();
		}
	});
	function GetParamsObj() {
		var ParamsObjMain = $CommonUI.loopBlock('#MainConditions');
		var ParamsObjRec = $CommonUI.loopBlock('#IngrConditions');
		var ParamsObj=jQuery.extend(true,ParamsObjMain,ParamsObjRec);
		return ParamsObj;
	}
	function SaveBarCode() {
		var MainObj = GetParamsObj();
		var Main = JSON.stringify(MainObj);
		var Detail = BarCodeGrid.getChangesData('InciId');
		if (Detail === false){	//δ��ɱ༭����ϸΪ��
			return;
		}
		if (isEmpty(Detail)){	//��ϸ����
			$UI.msg("alert", "û����Ҫ�������ϸ!");
			return;
		}
		
		var RowsData = BarCodeGrid.getChangesData();
		// ��Ч����
		var count = 0;
		var CheckMsgArr = [];
		for (var i = 0; i < RowsData.length; i++) {
			var RowData = RowsData[i];
			var InciId = RowData['InciId'];
			var VendorId = RowData['VendorId'];
			if (VendorId == "") {
				var RowIndex = BarCodeGrid.getRowIndex(RowData);
				var CheckMsg = '��' + (RowIndex + 1) + '�й�Ӧ��Ϊ��';
				CheckMsgArr.push(CheckMsg);
			}
			if (!isEmpty(InciId)) {
				count++;
			}
		}
		if (RowsData.length <= 0 || count <= 0) {
			$UI.msg('alert', '��ѡ����ϸ!');
			return false;
		}
		if(!isEmpty(CheckMsgArr)){
			$UI.msg('alert', CheckMsgArr.join());
			return false;
		}

		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			MethodName: 'RegHV',
			MainInfo: Main,
			ListDetail: JSON.stringify(Detail)
		}, function (jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				RowIdStr = jsonData.rowid;
				Query();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	var HandlerParams = function () {
		var Scg = $("#ScgId").combotree('getValue');
		var LocDr = $("#CreateLoc").combo('getValue');
		var ReqLoc = "";
		var HV = 'Y';
		var QtyFlag = '0';
		var Obj = { StkGrpRowId: Scg, StkGrpType: "M", Locdr: LocDr, NotUseFlag: "N", QtyFlag: QtyFlag, HV: HV, RequestNoStock: "Y" };
		return Obj;
	};
	$("#InciDesc").lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	var SelectRow = function (row) {
		var InciId = row.InciDr;
		var Params = gGroupId + "^" + gLocId + "^" + gUserId + "^" + gHospId;
		var DefaultBatExp = tkMakeServerCall('web.DHCSTMHUI.DHCINGdRec', 'GetDefaultBatExp', InciId, Params);
		var BatchNo = DefaultBatExp.split('^')[0];
		var ExpDate = DefaultBatExp.split('^')[1];
		BarCodeGrid.updateRow({
			index: BarCodeGrid.editIndex,
			row: {
				InciId: row.InciDr,
				InciCode: row.InciCode,
				InciDesc: row.InciDesc,
				Spec: row.Spec,
				Qty:row.PFac,
				Rp: row.BRp,
				Sp:row.BSp,
				UomDr: row.PUomDr,
				Uom: row.PUomDesc,
				BUomId: row.BUomDr,
				BUom: row.BUomDesc,
				VendorId: row.PbVendorId,
				VendorDesc: row.PbVendorDesc,
				BatchReq: row.BatchReq,
				ExpReq: row.ExpReq,
				CertNo: row.CertNo,
				CertExpDate: row.CertExpDate,
				ManfId: row.Manfdr,
				Manf: row.ManfName,
				BatchNo: row.BatchNo||BatchNo,
				ExpDate: row.ExpDate||ExpDate,
				BarCode:row.OrgBarCode,
				ProduceDate:row.ProduceDate
				
			}
		});
		setTimeout(function () {
			BarCodeGrid.refreshRow();
			BarCodeGrid.startEditingNext('InciDesc');
		}, 0);
	};

	var FRecLocParams = JSON.stringify(addSessionParams({ Type: "Login" }));
	$HUI.combobox('#CreateLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FRecLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});

	var ReqLocParams = JSON.stringify(addSessionParams({ Type: "All" }));
	$HUI.combobox('#ReqLocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var PhManufacturerParams = JSON.stringify(addSessionParams({ StkType: "M" }));
	var PhManufacturerBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params=' + PhManufacturerParams,
			valueField: 'RowId',
			textField: 'Description',
			onBeforeLoad: function (param) {

			}
		}
	};
	
	var VendorParams = JSON.stringify(addSessionParams({ APCType: "M", RcFlag: "Y" }));
	var VendorBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function (record) {
				var rows = BarCodeGrid.getRows();
				var row = rows[BarCodeGrid.editIndex];
				row.VendorDesc = record.Description;
			},
			onShowPanel: function () {
				$(this).combobox('reload');
			}
		}
	};
	/// �ж��Դ������Ƿ����
	function GetRepeatResult(colValue) {
		var RowsData = BarCodeGrid.getRows();
		// ��Ч����
		for (var i = 0; i < RowsData.length; i++) {
			var Code = RowsData[i].OriginalCode;
			if (Code == colValue) {
				return i;
			}
		}
		return -1;
	}
	var BarCodeCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '����RowId',
			field: 'InciId',
			width: 50,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 100
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 160,
			editor: InciEditor(HandlerParams, SelectRow)
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '������',
			field: 'SpecDesc',
			width: 100,
			formatter: CommonFormatter(SpecDescbox, 'SpecDesc', 'SpecDesc'),
			editor: SpecDescbox
		}, {
			title: '����',
			field: 'Qty',
			width: 50,
			align: 'right',
			editor: {
				type: 'numberbox',
				options: {
					required: true
				}
			}
		}, {
			title: '��ֵ����',
			field: 'BarCode',
			width: 280
		}, {
			title: '�Դ���',
			field: 'OriginalCode',
			hidden: true,
			width: 200,
			editor: {
				type: 'text'
			}
		}, {
			title: '�Դ�������',
			field: 'BatchCode',
			width: 200,
			editor: {
				type: 'text'
			}
		}, {
			title: '����',
			field: 'Rp',
			align: 'right',
			width: 80,
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					min:0,
					precision:GetFmtNum('FmtRP')
				}
			}
		}, {
			title: '�ۼ�',
			field: 'Sp',
			align: 'right',
			width: 80
		}, {
			title: 'Inpoi',
			field: 'Inpoi',
			hidden: true,
			width: 100
		}, {
			title: '����',
			field: 'BatchNo',
			width: 100,
			editor: {
				type: 'text'
			}
		}, {
			title: 'Ч��',
			field: 'ExpDate',
			width: 150,
			editor: {
				type: 'datebox'
			}
		}, {
			title: '��������',
			field: 'ProduceDate',
			width: 100,
			editor: {
				type: 'datebox'
			}
		}, {
			title: '��λdr',
			field: 'BUomId',
			width: 100,
			hidden: true
		}, {
			title: '��λ',
			field: 'BUom',
			width: 50
		}, {
			title: 'ע��֤��',
			field: 'CertNo',
			width: 100,
			editor: {
				type: 'text'
			}
		}, {
			title: 'ע��֤Ч��',
			field: 'CertExpDate',
			width: 100,
			editor: {
				type: 'datebox'
			}
		}, {
			title: '��Ӧ��',
			field: 'VendorId',
			width: 120,
			formatter: CommonFormatter(VendorBox, 'VendorId', 'VendorDesc'),
			editor: VendorBox
		}, {
			title: '����',
			field: 'ManfId',
			width: 100,
			formatter: CommonFormatter(PhManufacturerBox, 'ManfId', 'Manf'),
			editor: PhManufacturerBox
		}, {
			title: 'DetailSubId',
			field: 'OrderDetailSubId',
			width: 100,
			hidden: true
		}, {
			title: '���е���',
			field: 'SxNo',
			width: 100,
			hidden: false
		}, {
			title: "����Ҫ��",
			field: 'BatchReq',
			width: 80,
			hidden: true
		}, {
			title: "��Ч��Ҫ��",
			field: 'ExpReq',
			width: 80,
			hidden: true
		}
	]];

	var BarCodeGrid = $UI.datagrid('#BarCodeGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'queryRegHVs',
			rows:99999
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			MethodName: 'DeleteLabel'
		},
		columns: BarCodeCm,
		singleSelect: false,
		showBar: true,
		showAddDelItems: true,
		pagination: false,
		checkOnSelect: false,		//������Ϊtrueʱ,˫���¼���onBeforeCheck�¼�Ӱ��.
		onClickCell: function (index, field, value) {
			BarCodeGrid.commonClickCell(index, field, value);
		},
		onEndEdit: function (index, row, changes) {
			var Editors = $(this).datagrid('getEditors', index);
			for (var i = 0; i < Editors.length; i++) {
				var Editor = Editors[i];
				if (Editor.field == 'BatchNo') {
					var BatchReq = row.BatchReq;
					var BatchNo = row.BatchNo;
					if ((!isEmpty(BatchNo)) && (BatchReq == "N")) {
						$UI.msg('alert', "���Ų�������д!");
						BarCodeGrid.checked = false;
						return false;
					}
				} else if (Editor.field == 'ExpDate') {
					var ExpReq = row.ExpReq;
					var ExpDate = row.ExpDate;
					var IncId=row.InciId;
					var NowDate = DateFormatter(new Date());
					if ((!isEmpty(ExpDate)) && (ExpReq == "N")) {
						$UI.msg('alert', "��Ч�ڲ�������д!");
						BarCodeGrid.checked = false;
						return false;
					}
					if ((!isEmpty(ExpDate))&&(FormatDate(NowDate)>=FormatDate(ExpDate))){
						$UI.msg('alert',"��Ч�ڲ���С�ڻ���ڵ�ǰ����!");
						BarCodeGrid.checked=false;
						return false;
					}
					var ExpChcekInfo = tkMakeServerCall('web.DHCSTMHUI.DHCINGdRecItm', 'CheckExpDate', IncId, ExpDate);
					if ((!isEmpty(ExpDate))&&(ExpReq=="R")&&(ExpChcekInfo!="")){
						$UI.msg('alert',"�����ʾ�����Ч����������С��"+180+"��!");
						BarCodeGrid.checked = false;
						return false;
					}
				}
			}
		},
		onBeginEdit: function (index, row) {
			$('#BarCodeGrid').datagrid('beginEdit', index);
			var ed = $('#BarCodeGrid').datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++) {
				var e = ed[i];
				if (e.field == 'OriginalCode') {
					$(e.target).bind('keydown', function (event) {
						if (event.keyCode == 13) {
							var RowIndex = BarCodeGrid.editIndex;
							var OriginalCode = $(this).val();
							if (!isEmpty(OriginalCode)) {
								var retinfo = GetRepeatResult(OriginalCode);
								if (retinfo != -1) {
									$UI.msg('alert', OriginalCode + "�Ѿ����ڣ�")
									$(this).val("");
									return;
								}
								var ret = tkMakeServerCall("web.DHCSTMHUI.DHCItmTrack", "OriBarIfExit", OriginalCode);
								if (ret == 1) {
									$UI.msg('alert', OriginalCode + "�Ѿ����ڣ�")
									$(this).val("");
									return;
								}
								//�Զ��������Ч��
								var BarCodeObj = GetBarCodeSplitInfo(OriginalCode);
								var InciId = BarCodeObj['InciId'];
								var BatchNo = BarCodeObj['BatchNo'], ExpDate = BarCodeObj['ExpDate'], ProduceDate = BarCodeObj['ProduceDate'];
								if (!isEmpty(BatchNo) && !isEmpty(ExpDate)) {
									var RowInciId = BarCodeGrid.getRows()[BarCodeGrid.editIndex]['InciId'];
									if (!isEmpty(InciId)) {
										if (!isEmpty(RowInciId) && (InciId != RowInciId)) {
											$UI.msg('error', '����������Ϣ�ͱ������ݲ�ƥ��!');
										}

										if (InciId != RowInciId) {
											var ParamsObj = {
												StkGrpType: 'M',
												InciId: InciId
											};
											// HV: 'Y',
											var ParamsObj = { StkGrpType: 'M', NotUseFlag: 'N', InciId: InciId };
											var Params = JSON.stringify(addSessionParams(ParamsObj));
											var InciData = $.cm({
												ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
												MethodName: 'GetPhaOrderItemInfo',
												page: 1,
												rows: 1,
												StrParam: Params
											}, false);
											if (!isEmpty(InciData['rows'][0])) {
												SelectRow(InciData['rows'][0]);
											}
										}
									}

									var ExpDateStr = isEmpty(ExpDate) ? '' : DateFormatter(ExpDate);
									var ProduceDateStr = isEmpty(ProduceDate) ? '' : DateFormatter(ProduceDate);
									$UI.msg('alert', '�Զ����������:' + BatchNo + ',��Ч��:' + ExpDateStr + ',��������:' + ProduceDateStr + ', ��ע��˶�!')
									BarCodeGrid.updateRow({
										index: RowIndex,
										row: {
											OriginalCode: OriginalCode,
											BatchNo: BatchNo,
											ExpDate: ExpDateStr
										}
									});
								}
							}
						}
					})
				}
				if (e.field == 'OldOriginalCode') {
					$(e.target).bind('keydown', function (event) {
						if (event.keyCode == 13) {
							var RowIndex = BarCodeGrid.editIndex;
							var OriginalCode = $(this).val();
							if (!isEmpty(OriginalCode)) {
								var BarCodeObj = GetBarCodeSplitInfo(OriginalCode);
								var InciId = BarCodeObj['InciId'];
								var BatchNo = BarCodeObj['BatchNo'], ExpDate = BarCodeObj['ExpDate'], ProduceDate = BarCodeObj['ProduceDate'];
								if (!isEmpty(BatchNo) && !isEmpty(ExpDate)) {
									var RowInciId = BarCodeGrid.getRows()[BarCodeGrid.editIndex]['InciId'];
									if (!isEmpty(InciId)) {
										if (!isEmpty(RowInciId) && (InciId != RowInciId)) {
											$UI.msg('error', '����������Ϣ�ͱ������ݲ�ƥ��!');
										}

										if (InciId != RowInciId) {
											var ParamsObj = {
												StkGrpType: 'M',
												InciId: InciId
											};
											// HV: 'Y',
											var ParamsObj = { StkGrpType: 'M', NotUseFlag: 'N', InciId: InciId };
											var Params = JSON.stringify(addSessionParams(ParamsObj));
											var InciData = $.cm({
												ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
												MethodName: 'GetPhaOrderItemInfo',
												page: 1,
												rows: 1,
												StrParam: Params
											}, false);
											if (!isEmpty(InciData['rows'][0])) {
												SelectRow(InciData['rows'][0]);
											}
										}
									}

									var ExpDateStr = isEmpty(ExpDate) ? '' : DateFormatter(ExpDate);
									var ProduceDateStr = isEmpty(ProduceDate) ? '' : DateFormatter(ProduceDate);
									$UI.msg('alert', '�Զ����������:' + BatchNo + ',��Ч��:' + ExpDateStr + ',��������:' + ProduceDateStr + ', ��ע��˶�!')
									BarCodeGrid.updateRow({
										index: RowIndex,
										row: {
											OldOriginalCode: OriginalCode,
											BatchNo: BatchNo,
											ExpDate: ExpDateStr
										}
									});
								}
							}
						}
					})
				}
			}
		},
		beforeAddFn: function () {

		},
		onDblClickRow: function (index, row) {
			var RowId = row['RowId'];
			if (isEmpty(RowId)) {
				return;
			}
			var BarCode = row['BarCode'];
			var InciDesc = row['InciDesc'];
			var InfoStr = BarCode + ' : ' + InciDesc;
			BarCodePackItm(RowId, InfoStr);
		},
		onBeforeCheck: function(index, row){
			var IngrVendorId = $('#InGdReqVendor').combobox('getValue');
			var RowVendorId = row['VendorId'];
			//�����⹩Ӧ�̺���ϸ���Ƿ����
			if(!isEmpty(IngrVendorId) && !isEmpty(RowVendorId) && (IngrVendorId != RowVendorId)){
				$UI.msg('alert', '��' + (index + 1) + '�й�Ӧ������⹩Ӧ�̲���,���ʵ!');
				return false;
			}
		},
		onCheck: function(index, row){
			var IngrVendorId = $('#InGdReqVendor').combobox('getValue');
			var RowVendorId = row['VendorId'];
			if(isEmpty(IngrVendorId) && !isEmpty(RowVendorId)){
				AddComboData($('#InGdReqVendor'), RowVendorId, row['VendorDesc']);
				$('#InGdReqVendor').combobox('setValue', RowVendorId);
			}
		},
		onUncheck: function(index, row){
			//û��ѡ�����ʱ,�ÿչ�Ӧ��
			if(isEmpty($(this).datagrid('getSelected'))){
				$('#InGdReqVendor').combobox('setValue', '');
			}
		}
	});
	Clear();
}
$(init);
