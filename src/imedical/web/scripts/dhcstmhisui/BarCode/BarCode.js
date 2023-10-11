/* ��ֵ��������*/
var init = function() {
	var RowIdStr = '';
	var SessionParams = gGroupId + '^' + gLocId + '^' + gUserId + '^' + gHospId;
	/* ��������*/
	var CreateLocParams = JSON.stringify(addSessionParams({ Type: 'Login', Element: 'CreateLoc' }));
	$HUI.combobox('#CreateLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + CreateLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var FReqLocParams = JSON.stringify(addSessionParams({ Type: 'All', Element: 'ReqLocId' }));
	$HUI.combobox('#ReqLocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FReqLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var FVendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	$HUI.combobox('#VendorId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + FVendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var HandlerParams = function() {
		var Scg = $('#ScgId').combotree('getValue');
		var LocDr = $('#CreateLoc').combo('getValue');
		var ReqLoc = '';
		var HV = 'Y';
		var QtyFlag = '0';
		var Obj = { StkGrpRowId: Scg, StkGrpType: 'M', Locdr: LocDr, NotUseFlag: 'N', QtyFlag: QtyFlag, HV: HV, RequestNoStock: 'Y' };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	// ���붩��
	$UI.linkbutton('#ImpPo', {
		onClick: function() {
			var Locid = $('#CreateLoc').combo('getValue');
			var LocDesc = $('#CreateLoc').combo('getText');
			var LocObj = { RowId: Locid, Description: LocDesc };
			ImportPoSearch(getPoList, LocObj);
		}
	});
	// ����ƽ̨����
	$UI.linkbutton('#ImpSciPo', {
		onClick: function() {
			if (SerUseObj.SCI === 'Y') {
				ImportSciPoSearch(QueryForSciPo);
			} else if (SerUseObj.ECS === 'Y') {
				ImportECSPoSearch(QueryForSciPo);
			} else {
				$UI.msg('alert', '����ά��ƽ̨���ò���!');
			}
		}
	});
	$('#File').filebox({
		prompt: $g('��ѡ��Ҫ�����Excel'),
		accept: 'application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
	});
	$UI.linkbutton('#ReadBT', {
		onClick: function() {
			$('#StkGrpId').combobox('clear');
			ImportExcelFN();
		}
	});
	$UI.linkbutton('#DownExcelTemplet', {
		onClick: function() {
			ExportExcel();
		}
	});
	function ExportExcel() {
		window.open('../scripts/dhcstmhisui/BarCode/����ע��ģ��.xls', '_blank');
	}
	function getPoList(rowsData, VendorId, VendorDesc) {
		if (isEmpty(rowsData)) {
			return;
		}
		if (rowsData.length <= 0) {
			return;
		}
		for (var i = 0; i < rowsData.length; i++) {
			var row = rowsData[i];
			var FindIndex = BarCodeGrid.find('Inpoi', row.RowId);
			if (FindIndex >= 0) { continue; } // ������ϸ�ѵ���
			var record = {
				InciId: row.InciId,
				InciCode: row.InciCode,
				InciDesc: row.InciDesc,
				Qty: row.PurQty,
				Rp: row.Rp,
				CertNo: row.CertNo,
				CertExpDate: row.CertExpDate,
				BUomId: row.UomId,
				BUom: row.UomDesc,
				VendorId: VendorId,
				VendorDesc: VendorDesc,
				Inpoi: row.RowId,
				Spec: row.Spec,
				ManfId: row.ManfId,
				Manf: row.ManfDesc,
				BatchCodeFlag: row.BatchCodeFlag
			};
			BarCodeGrid.appendRow(record);
		}
	}

	function QueryForSciPo(IdStr) {
		RowIdStr = IdStr;
		Query();
	}

	$UI.linkbutton('#CopyBatNoBT', {
		onClick: function() {
			var rows = BarCodeGrid.getRows();
			var len = rows.length;
			if (len == 0) {
				$UI.msg('alert', 'û��Ҫ������ϸ!');
				return false;
			}
			SaveBatExpWin(SaveBatExp);
		}
	});

	function ImportExcelFN() {
		var wb;
		var filelist = $('#File').filebox('files');
		if (filelist.length == 0) {
			$UI.msg('alert', '��ѡ��Ҫ�����Excel!');
			return;
		}
		showMask();
		var file = filelist[0];
		var reader = new FileReader();
		reader.onload = function(e) {
			if (reader.result) {
				reader.content = reader.result;
			}
			var data = e ? e.target.result : reader.content;
			wb = XLSX.read(data, {
				type: 'binary'
			});
			var json = to_json(wb);
			$('#BarCodeGrid').datagrid('loadData', json);
			hideMask();
		};
		reader.readAsBinaryString(file);
	}
	function to_json(workbook) {
		var jsonData = {};
		var sheet2JSONOpts = {
			defval: ''		// ����Ϊ��ʱ��Ĭ��ֵ
		};
		var result = XLSX.utils.sheet_to_json(workbook.Sheets[workbook.SheetNames[0]], sheet2JSONOpts);
		result = result.slice(1);
		var dateFormat = tkMakeServerCall('web.DHCSTMHUI.StkTypeM', 'GetDateFormat');
		for (var i = 0; i < result.length; i++) {
			var InciCode = result[i].InciCode;
			var Manf = '';
			var Hospital = result[i].Hospital;
			var ExpDate = result[i].ExpDate;
			var ProduceDate = result[i].ProduceDate;
			if ((ExpDate != '') && (!CheckDateForm(ExpDate, dateFormat))) {
				$UI.msg('alert', $g('��:') + (i + 1) + $g(',����Ч�ڸ�ʽ����ȷ!'));
				hideMask();
				return;
			}
			if ((ProduceDate != '') && (!CheckDateForm(ProduceDate, dateFormat))) {
				$UI.msg('alert', $g('��:') + (i + 1) + $g(',�����������ڸ�ʽ����ȷ!'));
				hideMask();
				return;
			}
			var Str = tkMakeServerCall('web.DHCSTMHUI.DHCItmTrack', 'GetInciMsg', InciCode, Manf, Hospital);
			if (isEmpty(Str)) {
				$UI.msg('alert', $g('��:') + (i + 1) + $g(',�������������Ϣ������!'));
				hideMask();
				return;
			}
			result[i].InciId = Str.split('^')[0];
			result[i].ManfId = Str.split('^')[1];
			result[i].Manf = Str.split('^')[5];
			result[i].UomDr = Str.split('^')[2];
			result[i].BUom = Str.split('^')[8];
			result[i].Spec = Str.split('^')[3];
			result[i].Model = Str.split('^')[4];
			result[i].VendorId = Str.split('^')[6];
			result[i].VendorDesc = Str.split('^')[7];
			result[i].CertExpDate = Str.split('^')[13];
			if (isEmpty(result[i].Rp)) {
				result[i].Rp = Str.split('^')[9];
			}
			var Sp = tkMakeServerCall('web.DHCSTMHUI.DHCINGdRec', 'GetSpForRec', result[i].InciId, result[i].UomDr, result[i].Rp, SessionParams);
			result[i].Sp = Sp;
			result[i].NewSp = Sp;
			if (isEmpty(result[i].InciId)) {
				$UI.msg('alert', $g('��:') + (i + 1) + $g('�������ʴ��������Ϣ������!'));
				hideMask();
				return;
			}
			if ((!isEmpty(result[i].CertNo)) && (result[i].CertNo != Str.split('^')[11])) {
				$UI.msg('alert', $g('��:') + (i + 1) + ',' + result[i].InciCode + result[i].InciDesc + $g('ע��֤�����ֵ���Ŀע��֤��ͬ!'));
				hideMask();
				return;
			} else if (isEmpty(result[i].CertNo)) {
				result[i].CertNo = Str.split('^')[11];
			}
			if (result[i].InciDesc != Str.split('^')[12]) {
				$UI.msg('alert', $g('��:') + (i + 1) + ',' + result[i].InciCode + result[i].InciDesc + $g('�������������������!'));
				hideMask();
				return;
			}
		}
		jsonData.rows = result;
		jsonData.total = result.length;
		return jsonData;
	}
	
	function SaveBatExp(Params) {
		if (!BarCodeGrid.endEditing()) {
			return;
		}
		var FillFlag = $("input[name='Fill']:checked").val();	// 1:������, 2:��������
		var BatNo = Params.BatNo;
		var ExpDate = Params.ExpDate;
		var Rows = BarCodeGrid.getRows();
		// var Rows = BarCodeGrid.getRows();
		var len = Rows.length;
		var FillCount = 0;
		for (var index = 0; index < len; index++) {
			var RowData = Rows[index];
			if ((FillFlag == '1') && !(isEmpty(RowData.BatchNo) && isEmpty(RowData.ExpDate))) {
				continue;
			}
			$('#BarCodeGrid').datagrid('endEdit', index);
			$('#BarCodeGrid').datagrid('selectRow', index);

			$('#BarCodeGrid').datagrid('editCell', { index: index, field: 'BatchNo' });
			var ed = $('#BarCodeGrid').datagrid('getEditor', { index: index, field: 'BatchNo' });
			ed.target.val(BatNo);

			$('#BarCodeGrid').datagrid('editCell', { index: index, field: 'ExpDate' });
			ed = $('#BarCodeGrid').datagrid('getEditor', { index: index, field: 'ExpDate' });
			$(ed.target).datebox('setValue', ExpDate);

			$('#BarCodeGrid').datagrid('endEdit', index);
			FillCount++;
		}
		if (FillCount > 0) {
			$UI.msg('alert', $g('���������:') + FillCount + $g(', ��ע�Ᵽ��!'));
		} else {
			$UI.msg('error', 'δ������Ч���!');
		}
	}
	
	function Query() {
		var ParamsObj = $CommonUI.loopBlock('#MainConditions');
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
		if (isEmpty(StartDate)) {
			$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
			return;
		}
		if (isEmpty(EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
			return;
		}
		if (compareDate(StartDate, EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���С�ڿ�ʼ����!');
			return;
		}
		ParamsObj.RowIdStr = RowIdStr;
		var Params = JSON.stringify(ParamsObj);
		BarCodeGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'queryRegHVs',
			query2JsonStrict: 1,
			Params: Params,
			rows: 99999,
			totalFooter: '"InciCode":"�ϼ�"',
			totalFields: 'Rp,Sp,RpAmt'
		});
		RowIdStr = '';
	}
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	
	var Clear = function() {
		RowIdStr = '';
		$('#File').filebox('clear');
		$UI.clearBlock('#MainConditions');
		$UI.clear(BarCodeGrid);
		$UI.clearBlock('#IngrConditions');
		SetDefaValues();
	};
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	
	function GetParamsObj() {
		var ParamsObjMain = $CommonUI.loopBlock('#MainConditions');
		var ParamsObjRec = $CommonUI.loopBlock('#IngrConditions');
		var ParamsObj = jQuery.extend(true, ParamsObjMain, ParamsObjRec);
		return ParamsObj;
	}
	function CheckBeforeReg() {
		if (!BarCodeGrid.endEditing()) {
			return;
		}
		var Detail = BarCodeGrid.getRows();
		if (Detail === false) {	// δ��ɱ༭����ϸΪ��
			return;
		}
		if (isEmpty(Detail)) {	// ��ϸ����
			$UI.msg('alert', 'û����Ҫ�������ϸ!');
			return;
		}
		// ��Ч����
		var CheckMsgArr = [], CheckExpDateMsgArr = [], CheckMsg = '';
		var ConfirmMsgArr = [], ConfirmMsg = '';
		for (var i = 0; i < Detail.length; i++) {
			var RowData = Detail[i];
			var InciId = RowData['InciId'];
			var VendorId = RowData['VendorId'];
			var ExpReq = RowData['ExpReq'];
			var ExpDate = RowData['ExpDate'];
			var ProduceDate = RowData['ProduceDate'];
			var BatchReq = RowData['BatchReq'];
			var BatchNo = RowData['BatchNo'];
			var NowDate = DateFormatter(new Date());
			var TableFlag = RowData['TableFlag'];
			var Rp = RowData['Rp'];
			var Sp = RowData['Sp'];
			if ((VendorId == '') && (ItmTrackParamObj.VendorNeeded == 'Y')) {
				CheckMsg = $g('��:') + (i + 1) + $g(',��Ӧ��Ϊ��');
				CheckMsgArr.push(CheckMsg);
			}
			var BatchCodeFlag = RowData['BatchCodeFlag'];
			var BatchCode = RowData['BatchCode'];
			if ((BatchCodeFlag == 'Y') && (BatchCode == '')) {
				CheckMsg = $g('��:') + (i + 1) + $g('�Դ�������Ϊ��');
				CheckMsgArr.push(CheckMsg);
			}
			if (Rp < 0 || Sp < 0) {
				CheckMsg = $g('��:') + (i + 1) + $g(',���ۻ��ۼ۲���С����');
				CheckMsgArr.push(CheckMsg);
			}
			if (Rp == 0 || Sp == 0) {
				ConfirmMsg = $g('��:') + (i + 1) + $g(',���ۻ��ۼ�Ϊ��');
				ConfirmMsgArr.push(ConfirmMsg);
			}
			if ((!isEmpty(BatchNo)) && (BatchReq == 'N')) {
				CheckMsg = $g('��:') + (i + 1) + $g(',���Ų�������д');
				CheckMsgArr.push(CheckMsg);
			}
			if ((isEmpty(BatchNo)) && (BatchReq == 'R')) {
				CheckMsg = $g('��:') + (i + 1) + $g(',���ű�����д');
				CheckMsgArr.push(CheckMsg);
			}
			if ((!isEmpty(ExpDate)) && (ExpReq == 'N')) {
				CheckMsg = $g('��:') + (i + 1) + $g(',��Ч�ڲ�������д');
				CheckMsgArr.push(CheckMsg);
			}
			if ((isEmpty(ExpDate)) && (ExpReq == 'R')) {
				CheckMsg = $g('��:') + (i + 1) + $g(',��Ч�ڱ�����д');
				CheckMsgArr.push(CheckMsg);
			}
			if (!isEmpty(ExpDate)) {
				if (compareDate(NowDate, ExpDate)) {
					CheckMsg = $g('��:') + (i + 1) + $g(',��Ч�ڲ������ڵ�ǰ����');
					CheckMsgArr.push(CheckMsg);
				} else {
					var ExpDateMsg = tkMakeServerCall('web.DHCSTMHUI.DHCINGdRecItm', 'CheckExpDate', InciId, ExpDate);
					if (!isEmpty(ExpDateMsg)) {
						CheckMsg = $g('��:') + (i + 1) + ',' + ExpDateMsg;
						CheckExpDateMsgArr.push(CheckMsg);
					}
				}
			}
			if ((!isEmpty(ProduceDate)) && (compareDate(ProduceDate, NowDate))) {
				CheckMsg = $g('��:') + (i + 1) + $g(',�������ڲ������ڵ�ǰ����');
				CheckMsgArr.push(CheckMsg);
			}
			if (TableFlag == 'Y') {
				CheckMsg = $g('��:') + (i + 1) + $g(',��̨��ֵ��������������');
				CheckMsgArr.push(CheckMsg);
			}
		}
		if (!isEmpty(CheckMsgArr)) {
			$UI.msg('alert', CheckMsgArr.join());
			return false;
		}
		if (!isEmpty(CheckExpDateMsgArr)) {
			$UI.msg('alert', CheckExpDateMsgArr.join());
		}
		if (!isEmpty(ConfirmMsgArr)) {
			$UI.confirm(ConfirmMsgArr.join() + $g('�Ƿ����?'), '', '', SaveBarCode);
		} else {
			SaveBarCode();
		}
	}
	function SaveBarCode() {
		var MainObj = GetParamsObj();
		var Main = JSON.stringify(addSessionParams(MainObj));
		var Detail = BarCodeGrid.getRowsData('InciId');
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			MethodName: 'jsRegHV',
			MainInfo: Main,
			ListDetail: JSON.stringify(Detail)
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				RowIdStr = jsonData.rowid;
				Query();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			CheckBeforeReg();
		}
	});
	
	// ��ӡ��ť��Ӧ����
	var PrintBtn = $('#Print').menubutton({ menu: '#mm-Print' });
	$(PrintBtn.menubutton('options').menu).menu({
		onClick: function(item) {
			var BtnName = item.name;		// div������name����
			var rowsData = '', row = '', rowIndex = 0, count = 0;
			if (BtnName == 'PrintBarCode') {
				rowsData = BarCodeGrid.getSelections();
				if (rowsData.length <= 0) {
					$UI.msg('alert', 'û��Ҫ��ӡ�ĸ�ֵ����!');
					return;
				}
				count = rowsData.length;
				for (rowIndex = 0; rowIndex < count; rowIndex++) {
					row = rowsData[rowIndex];
					PrintBarcode(row.BarCode, 1);
				}
			} else if (BtnName == 'PrintBarCode2') {
				rowsData = BarCodeGrid.getSelections();
				if (rowsData.length <= 0) {
					$UI.msg('alert', 'û��Ҫ��ӡ�ĸ�ֵ����!');
					return;
				}
				count = rowsData.length;
				for (rowIndex = 0; rowIndex < count; rowIndex++) {
					row = rowsData[rowIndex];
					PrintBarcode(row.BarCode, 2);
				}
			} else if (BtnName == 'PrintPage') {
				rowsData = BarCodeGrid.getRows();
				if (rowsData.length <= 0) {
					$UI.msg('alert', 'û��Ҫ��ӡ�ĸ�ֵ����!');
					return;
				}
				count = rowsData.length;
				for (rowIndex = 0; rowIndex < count; rowIndex++) {
					row = rowsData[rowIndex];
					PrintBarcode(row.BarCode, 1);
				}
			} else if (BtnName == 'PrintPage2') {
				rowsData = BarCodeGrid.getRows();
				if (rowsData.length <= 0) {
					$UI.msg('alert', 'û��Ҫ��ӡ�ĸ�ֵ����!');
					return;
				}
				count = rowsData.length;
				for (rowIndex = 0; rowIndex < count; rowIndex++) {
					row = rowsData[rowIndex];
					PrintBarcode(row.BarCode, 2);
				}
			}
		}
	});
	
	// / �ж��Դ������Ƿ����
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
	var SelectRow = function(row) {
		var InciId = row.InciDr;
		var Params = gGroupId + '^' + gLocId + '^' + gUserId + '^' + gHospId;
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
				Qty: row.PFac,
				Rp: row.BRp,
				Sp: row.BSp,
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
				BatchNo: row.BatchNo || BatchNo,
				ExpDate: row.ExpDate || ExpDate,
				BarCode: row.OrgBarCode,
				BatchCodeFlag: row.BatchCodeFlag,
				ProduceDate: row.ProduceDate,
				TableFlag: row.TableFlag
			}
		});
		setTimeout(function() {
			BarCodeGrid.refreshRow();
			BarCodeGrid.startEditingNext('InciDesc');
		}, 0);
	};
	/*
	var PhManufacturerParams = JSON.stringify(addSessionParams({ StkType: "M" }));
	var PhManufacturerBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params=' + PhManufacturerParams,
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function (record) {
				var rows = BarCodeGrid.getRows();
				var row = rows[BarCodeGrid.editIndex];
				row.Manf = record.Description;
			}
		}
	};*/
	
	var VendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var VendorBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function(record) {
				var rows = BarCodeGrid.getRows();
				var row = rows[BarCodeGrid.editIndex];
				row.VendorDesc = record.Description;
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
				var rows = BarCodeGrid.getRows();
				var row = rows[BarCodeGrid.editIndex];
				if (!isEmpty(row)) {
					param.Inci = row.InciId;
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
				var rows = BarCodeGrid.getRows();
				var row = rows[BarCodeGrid.editIndex];
				if (!isEmpty(row)) {
					param.Inci = row.InciId;
				}
			},
			onSelect: function(record) {
				var rows = BarCodeGrid.getRows();
				var row = rows[BarCodeGrid.editIndex];
				row.CertExpDate = record.MRCExpDate;
				row.ManfId = record.MRCManfId;
				row.Manf = record.MRCManfDesc;
				setTimeout(function() {
					BarCodeGrid.refreshRow();
				}, 0);
			}
		}
	};
	
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
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true,
			editor: (CodeMainParamObj.UseSpecList == 'Y' ? false : true) ? null : SpecDescbox
		}, {
			title: '����',
			field: 'Qty',
			width: 50,
			align: 'right',
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					tipPosition: 'bottom',
					precision: 0
				}
			},
			funWhileJump: function(target) {
				var RecQty = target.val();
				var Rp = target.parents('td[field]').siblings('td[field="Rp"]').find('input').val();
				var RpAmt = accMul(Rp, RecQty);
				var RowData = BarCodeGrid.getRows()[BarCodeGrid.editIndex];
				RowData['RpAmt'] = RpAmt;
				setTimeout(function() {
					BarCodeGrid.refreshRow();
				}, 0);
			}
			
		}, {
			title: '��ֵ����',
			field: 'BarCode',
			width: 280
		}, {
			title: '�Դ���',
			field: 'OriginalCode',
			hidden: hiddenOrigiBarCode,
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
			editor: (IngrParamObj.AllowEditRp == 'N' ? true : false) ? null : {
				type: 'numberbox',
				options: {
					required: true,
					tipPosition: 'bottom',
					min: 0,
					precision: GetFmtNum('FmtRP')
				}
			}
		}, {
			title: '���۽��',
			field: 'RpAmt',
			align: 'right',
			width: 100
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
			editable: false,
			formatter: CommonFormatter(RegCertBox, 'CertNo', 'CertNo'),
			editor: RegCertBox
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
			title: '��������',
			field: 'ManfId',
			width: 100,
			hidden: true
		}, {
			title: '��������',
			field: 'Manf',
			width: 100/*,
			formatter: CommonFormatter(PhManufacturerBox, 'ManfId', 'Manf'),
			editor: PhManufacturerBox*/
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
			title: '����Ҫ��',
			field: 'BatchReq',
			width: 80,
			hidden: true
		}, {
			title: '��Ч��Ҫ��',
			field: 'ExpReq',
			width: 80,
			hidden: true
		}, {
			title: '�������־',
			field: 'BatchCodeFlag',
			width: 100,
			hidden: false,
			align: 'center'
		}, {
			title: '��������',
			field: 'OriginalStatus',
			width: 100,
			hidden: false,
			formatter: OriginalStatusFormatter
		}, {
			title: '��̨��־',
			field: 'TableFlag',
			width: 100,
			hidden: false,
			formatter: BoolFormatter,
			align: 'center'
		}
	]];

	var BarCodeGrid = $UI.datagrid('#BarCodeGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'queryRegHVs',
			query2JsonStrict: 1,
			rows: 99999,
			totalFooter: '"InciCode":"�ϼ�"',
			totalFields: 'Rp,Sp,RpAmt'
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			MethodName: 'DeleteLabel'
		},
		columns: BarCodeCm,
		checkField: 'InciId',
		singleSelect: false,
		showBar: true,
		showFooter: true,
		remoteSort: false,
		showAddDelItems: true,
		pagination: false,
		checkOnSelect: false,		// ������Ϊtrueʱ,˫���¼���onBeforeCheck�¼�Ӱ��.
		onClickCell: function(index, field, value) {
			BarCodeGrid.commonClickCell(index, field, value);
		},
		onBeforeCellEdit: function(index, field) {
			var row = $(this).datagrid('getRows')[index];
			var RowId = row.RowId;
			var OriginalStatus = row.OriginalStatus;
			if (field == 'Qty') {
				if ((!isEmpty(RowId)) && (isEmpty(OriginalStatus))) {
					return false;
				}
			}
			if (field == 'BatchCode') {
				if ((!isEmpty(RowId)) && (OriginalStatus == 'NotUnique')) {
					return false;
				}
			}
		},
		onEndEdit: function(index, row, changes) {
			var RowId = row.RowId;
			var IncId = row.InciId;
			if (isEmpty(IncId)) {
				$UI.msg('alert', '��Ч��ϸ!');
				BarCodeGrid.checked = false;
				return false;
			}
			var OriginalStatus = row.OriginalStatus;
			if (changes.hasOwnProperty('Qty')) {
				if ((!isEmpty(RowId)) && (isEmpty(OriginalStatus))) {
					$UI.msg('alert', 'Ψһ�뱣��������������޸�!');
					BarCodeGrid.checked = false;
					return false;
				}
			}
			if (changes.hasOwnProperty('BatchCode')) {
				if ((!isEmpty(RowId)) && (OriginalStatus == 'NotUnique')) {
					$UI.msg('alert', '���������ĸ�ֵ����������Դ������벻���޸�!');
					BarCodeGrid.checked = false;
					return false;
				}
			}
			if (changes.hasOwnProperty('Rp')) {
				var rp = row.Rp;
				if (isEmpty(rp)) {
					$UI.msg('alert', '���۲���Ϊ��!');
					BarCodeGrid.checked = false;
					return false;
				} else if (rp < 0) {
					$UI.msg('alert', '���۲���С����!');
					BarCodeGrid.checked = false;
					return false;
				} else if (rp == 0) {
					$UI.msg('alert', '���۵�����!');
				}
				
				var SessionParams = gGroupId + '^' + gLocId + '^' + gUserId + '^' + gHospId;
				var UomId = row.BUomId;
				var sp = tkMakeServerCall('web.DHCSTMHUI.DHCINGdRec', 'GetSpForRec', IncId, UomId, rp, SessionParams);
				// ��֤�ӳ���
				var ChargeFlag = tkMakeServerCall('web.DHCSTMHUI.Common.DrugInfoCommon', 'GetChargeFlag', IncId);
				var margin = 0;
				if ((rp != 0) && (ChargeFlag == 'Y')) {
					margin = accSub(accDiv(sp, rp), 1);
					if ((IngrParamObj.MarginWarning != 0) && ((margin > IngrParamObj.MarginWarning) || (margin < 0))) {
						$UI.msg('alert', '�ӳ��ʳ����޶���Χ!');
						BarCodeGrid.checked = false;
						return false;
					}
				}
				row.Sp = sp;
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
					var Scg = $('#ScgId').combotree('getValue');
					var LocDr = $('#CreateLoc').combo('getValue');
					var Obj = {
						Incid: row.InciId,
						Incicode: row.InciCode,
						Incidesc: row.InciDesc,
						PriorRp: PriorRp,
						PriorSp: PriorSp,
						ResultRp: ResultRp,
						ResultSp: ResultSp,
						AdjSpUomId: row.BUomId,
						StkGrpType: Scg,
						LocDr: LocDr
					};
					var adjPriceObj = addSessionParams(Obj);
					$UI.confirm(row.InciDesc + $g('�۸����仯���Ƿ����ɵ��۵�?'), '', '', SetAdjPrice, '', '', '', '', adjPriceObj);
				}
			}
			if (changes.hasOwnProperty('ProduceDate')) {
				var ProduceDate = row.ProduceDate;
				var ExpireDate = row.ExpDate;
				if ((IngrParamObj.DefaExpDate == '3') && (!isEmpty(ProduceDate)) && (isEmpty(ExpireDate))) {
					var DefaultBatExp = tkMakeServerCall('web.DHCSTMHUI.DHCINGdRec', 'GetDefaultBatExp', IncId, SessionParams, ProduceDate);
					var ExpDate = DefaultBatExp.split('^')[1];
					BarCodeGrid.updateRow({
						index: BarCodeGrid.editIndex,
						row: {
							ExpDate: ExpDate
						}
					});
					$('#BarCodeGrid').datagrid('refreshRow', BarCodeGrid.editIndex);
				}
			}
			BarCodeGrid.setFooterInfo();
		},
		onBeginEdit: function(index, row) {
			$('#BarCodeGrid').datagrid('beginEdit', index);
			var ed = $('#BarCodeGrid').datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++) {
				var e = ed[i];
				if (e.field == 'OriginalCode') {
					$(e.target).bind('keydown', function(event) {
						if (event.keyCode == 13) {
							var RowIndex = BarCodeGrid.editIndex;
							var OriginalCode = $(this).val();
							if (!isEmpty(OriginalCode)) {
								var retinfo = GetRepeatResult(OriginalCode);
								if (retinfo != -1) {
									$UI.msg('alert', OriginalCode + $g('�����Ѿ����ڣ�'));
									$(this).val('');
									return;
								}
								var ret = tkMakeServerCall('web.DHCSTMHUI.DHCItmTrack', 'OriBarIfExit', OriginalCode);
								if (ret == 1) {
									$UI.msg('alert', OriginalCode + $g('�����Ѿ����ڣ�'));
									$(this).val('');
									return;
								}
								// �Զ��������Ч��
								var BarCodeObj = $.cm({
									ClassName: 'web.DHCSTMHUI.DHCUDI',
									MethodName: 'UDIInfo',
									Code: OriginalCode
								}, false);
								var InciId = BarCodeObj['InciId'];
								var BatchNo = BarCodeObj['BatchNo'], ExpDate = BarCodeObj['ExpDate'], ProduceDate = BarCodeObj['ProduceDate'];
								if (!isEmpty(BatchNo) && !isEmpty(ExpDate)) {
									var RowInciId = BarCodeGrid.getRows()[BarCodeGrid.editIndex]['InciId'];
									if (!isEmpty(InciId)) {
										if (!isEmpty(RowInciId) && (InciId != RowInciId)) {
											$UI.msg('error', '����������Ϣ�ͱ������ݲ�ƥ��!');
										}

										if (InciId != RowInciId) {
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
									$UI.msg('alert', $g('�Զ����������:') + BatchNo + $g(',��Ч��:') + ExpDate + $g(',��������:') + ProduceDate + $g(', ��ע��˶�!'));
									BarCodeGrid.updateRow({
										index: RowIndex,
										row: {
											OriginalCode: OriginalCode,
											BatchNo: BatchNo,
											ExpDate: ExpDate
										}
									});
								}
							}
						}
					});
				} else if (e.field == 'BatchCode') {
					$(e.target).bind('keydown', function(event) {
						if (event.keyCode == 13) {
							var RowIndex = BarCodeGrid.editIndex;
							var OriginalCode = $(this).val();
							if (!isEmpty(OriginalCode)) {
								var BarCodeObj = $.cm({
									ClassName: 'web.DHCSTMHUI.DHCUDI',
									MethodName: 'UDIInfo',
									Code: OriginalCode
								}, false);
								var InciId = BarCodeObj['InciId'];
								var BatchNo = BarCodeObj['BatchNo'], ExpDate = BarCodeObj['ExpDate'], ProduceDate = BarCodeObj['ProduceDate'];
								if (!isEmpty(BatchNo) && !isEmpty(ExpDate)) {
									var RowInciId = BarCodeGrid.getRows()[BarCodeGrid.editIndex]['InciId'];
									if (!isEmpty(InciId)) {
										if (!isEmpty(RowInciId) && (InciId != RowInciId)) {
											$UI.msg('error', '����������Ϣ�ͱ������ݲ�ƥ��!');
										}

										if (InciId != RowInciId) {
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
									$UI.msg('alert', $g('�Զ����������:') + BatchNo + $g(',��Ч��:') + ExpDate + $g(',��������:') + ProduceDate + $g(', ��ע��˶�!'));
									BarCodeGrid.updateRow({
										index: RowIndex,
										row: {
											BatchCode: OriginalCode,
											BatchNo: BatchNo,
											ExpDate: ExpDate
										}
									});
								}
							}
						}
					});
				}
			}
		},
		beforeAddFn: function() {

		},
		onDblClickRow: function(index, row) {
			var RowId = row['RowId'];
			if (isEmpty(RowId)) {
				return;
			}
			var BarCode = row['BarCode'];
			var InciDesc = row['InciDesc'];
			var InfoStr = BarCode + ' : ' + InciDesc;
			BarCodePackItm(RowId, InfoStr);
		},
		onBeforeCheck: function(index, row) {
			var IngrVendorId = $('#InGdReqVendor').combobox('getValue');
			var RowVendorId = row['VendorId'];
			// �����⹩Ӧ�̺���ϸ���Ƿ����
			if (!isEmpty(IngrVendorId) && !isEmpty(RowVendorId) && (IngrVendorId != RowVendorId)) {
				$UI.msg('alert', $g('��:') + (index + 1) + $g(',��Ӧ������⹩Ӧ�̲���,���ʵ!'));
				return false;
			}
		},
		onCheck: function(index, row) {
			var IngrVendorId = $('#InGdReqVendor').combobox('getValue');
			var RowVendorId = row['VendorId'];
			if (isEmpty(IngrVendorId) && !isEmpty(RowVendorId)) {
				AddComboData($('#InGdReqVendor'), RowVendorId, row['VendorDesc']);
				$('#InGdReqVendor').combobox('setValue', RowVendorId);
			}
		},
		onUncheck: function(index, row) {
			// û��ѡ�����ʱ,�ÿչ�Ӧ��
			if (isEmpty($(this).datagrid('getSelected'))) {
				$('#InGdReqVendor').combobox('setValue', '');
			}
		},
		onCheckAll: function(rows) {
			var IngrVendorId = $('#InGdReqVendor').combobox('getValue');
			var RowVendorId = rows[0].VendorId;
			var VendorDesc = rows[0].VendorDesc;
			if (isEmpty(IngrVendorId) && !isEmpty(RowVendorId)) {
				AddComboData($('#InGdReqVendor'), RowVendorId, VendorDesc);
				$('#InGdReqVendor').combobox('setValue', RowVendorId);
			}
			var CheckMsgArr = [];
			var vendor = $('#InGdReqVendor').combobox('getValue');
			for (var i = 0, Len = rows.length; i < Len; i++) {
				var NullInfoArr = [];
				var RowData = rows[i];
				if (!isEmpty(RowData['VendorId']) && (RowData['VendorId'] != vendor)) {
					NullInfoArr.push($g('��Ӧ��'));
				}
				if (!isEmpty(NullInfoArr)) {
					var NullInfo = NullInfoArr.join('��');
					var MsgStr = $g('��:') + (i + 1) + ',' + NullInfo + $g('����⹩Ӧ�̲�ͬ');
					CheckMsgArr.push(MsgStr);
				}
			}
			if (!isEmpty(CheckMsgArr)) {
				var CheckMsg = CheckMsgArr.join();
				$UI.msg('error', CheckMsg);
				return false;
			}
		},
		onUncheckAll: function(rows) {
			// û��ѡ�����ʱ,�ÿչ�Ӧ��
			if (isEmpty($(this).datagrid('getSelected'))) {
				$('#InGdReqVendor').combobox('setValue', '');
			}
		}
	});
	
	/* ���*/
	var FRecLocParams = JSON.stringify(addSessionParams({ Type: 'Login', Element: 'InGdRecLocId' }));
	$HUI.combobox('#InGdRecLocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FRecLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$('#InGdReqLocId').combobox('clear');
			$('#InGdReqLocId').combobox('reload', $URL
				+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
				+ JSON.stringify(addSessionParams({
					Type: 'Trans',
					LocId: LocId,
					TransLocType: 'T',
					Element: 'InGdRecLocId'
				}))
			);
		}
	});
	var ReqVendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	$HUI.combobox('#InGdReqVendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + ReqVendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var tRecLocParams = JSON.stringify(addSessionParams({ Type: 'Trans', Element: 'InGdReqLocId' }));
	$HUI.combobox('#InGdReqLocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + tRecLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var SourceOfFundParams = JSON.stringify(addSessionParams());
	$HUI.combobox('#Source', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSourceOfFund&ResultSetType=array&Params=' + SourceOfFundParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$HUI.checkbox('#XK', {
		onCheckChange: function(e, value) {
			var ReqLocObj = DeepClone(gLocObj);
			if (value) {
				var RecLoc = $('#InGdRecLocId').combobox('getValue');
				var Info = tkMakeServerCall('web.DHCSTMHUI.Common.UtilCommon', 'GetMainLoc', RecLoc);
				var InfoArr = Info.split('^');
				var VituralLoc = InfoArr[0], VituralLocDesc = InfoArr[1];
				ReqLocObj['RowId'] = VituralLoc, ReqLocObj['Description'] = VituralLocDesc;
			}
			var IngrData = { 'InGdRecLocId': ReqLocObj };
			$UI.fillBlock('#IngrConditions', IngrData);
		}
	});
	
	$UI.linkbutton('#SaveInGdRecBT', {
		onClick: function() {
			SaveIngr();
		}
	});
	
	function SaveIngr() {
		if (!BarCodeGrid.endEditing()) {
			return false;
		}
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
		
		var IngrMainParamObj = $UI.loopBlock('#IngrConditions');
		// �ж���ⵥ�Ƿ�������
		// �ж���ⲿ�ź͹������Ƿ�Ϊ��
		var phaLoc = IngrMainParamObj.InGdRecLocId;
		if (isEmpty(phaLoc)) {
			$UI.msg('alert', '��ѡ��������!');
			return false;
		}
		var vendor = IngrMainParamObj.InGdReqVendor;
		if (isEmpty(vendor)) {
			$UI.msg('alert', '��ѡ��Ӧ��!');
			return false;
		}
		var CheckMsgArr = [], CheckExpDateMsgArr = [], CheckMsg = '';
		for (i = 0, Len = RowsData.length; i < Len; i++) {
			var NullInfoArr = [];
			var RowData = RowsData[i];
			var InciId = RowData['InciId'];
			var BatchReq = RowData['BatchReq'];
			var BatchNo = RowData['BatchNo'];
			var ExpReq = RowData['ExpReq'];
			var ExpDate = RowData['ExpDate'];
			var ProduceDate = RowData['ProduceDate'];
			var VendorId = RowData['VendorId'];
			var NowDate = DateFormatter(new Date());
			if ((BatchReq == 'R') && isEmpty(BatchNo)) {
				NullInfoArr.push($g('����'));
			}
			if ((ExpReq == 'R') && isEmpty(ExpDate)) {
				NullInfoArr.push($g('��Ч��'));
			}
			if (!isEmpty(NullInfoArr)) {
				var NullInfo = NullInfoArr.join('��');
				CheckMsg = '��:' + (i + 1) + ',' + NullInfo + $g('û��¼��');
				CheckMsgArr.push(CheckMsg);
			}
			if (!isEmpty(VendorId) && (VendorId != vendor)) {
				NullInfoArr.push($g('��Ӧ��'));
				CheckMsg = '��:' + (i + 1) + $g(',��Ӧ������⹩Ӧ�̲�ͬ');
				CheckMsgArr.push(CheckMsg);
			}
			if ((!isEmpty(BatchNo)) && (BatchReq == 'N')) {
				CheckMsg = '��:' + (i + 1) + $g(',���Ų�������д');
				CheckMsgArr.push(CheckMsg);
			}
			if ((!isEmpty(ExpDate)) && (ExpReq == 'N')) {
				CheckMsg = '��:' + (i + 1) + $g(',��Ч�ڲ�������д');
				CheckMsgArr.push(CheckMsg);
			}
			if (!isEmpty(ExpDate)) {
				if (compareDate(NowDate, ExpDate)) {
					CheckMsg = '��:' + (i + 1) + $g(',��Ч�ڲ������ڵ�ǰ����');
					CheckMsgArr.push(CheckMsg);
				} else {
					var ExpDateMsg = tkMakeServerCall('web.DHCSTMHUI.DHCINGdRecItm', 'CheckExpDate', InciId, ExpDate);
					if (!isEmpty(ExpDateMsg)) {
						CheckMsg = '��:' + (i + 1) + ',' + ExpDateMsg;
						CheckExpDateMsgArr.push(CheckMsg);
					}
				}
			}
			if ((!isEmpty(ProduceDate)) && (compareDate(ProduceDate, NowDate))) {
				CheckMsg = $g('��:') + (i + 1) + $g(',�������ڲ������ڵ�ǰ����');
				CheckMsgArr.push(CheckMsg);
			}
		}
		if (!isEmpty(CheckMsgArr)) {
			CheckMsg = CheckMsgArr.join();
			$UI.msg('error', CheckMsg);
			return false;
		}
		if (!isEmpty(CheckExpDateMsgArr)) {
			CheckMsg = CheckExpDateMsgArr.join();
			$UI.msg('error', CheckMsg);
		}
		var ParamsObj = $CommonUI.loopBlock('#MainConditions');
		var ScgId = ParamsObj.ScgId;
		IngrMainParamObj = jQuery.extend(true, IngrMainParamObj, { ScgId: ScgId });
		var Main = JSON.stringify(IngrMainParamObj);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			MethodName: 'CreatIngr',
			MainInfo: Main,
			ListDetail: JSON.stringify(RowsData)
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				var IngrRowid = jsonData.rowid;
				$UI.clear(BarCodeGrid);
				
				var UrlStr = 'dhcstmhui.ingdrechv.csp?RowId=' + IngrRowid;
				Common_AddTab('��ֵ���', UrlStr);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	/* ��ʼ��*/
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
		if (ItmTrackParamObj.AutoVirFlag == 'Y') {
			$('#XK').checkbox('setValue', true);
		} else {
			$('#XK').checkbox('setValue', false);
		}
		if ((SerUseObj.ECS == 'Y') || (SerUseObj.SCI == 'Y')) {
			$('.SCIShow').show();
		} else {
			$('.SCIShow').hide();
		}
	}
	Clear();
};
$(init);