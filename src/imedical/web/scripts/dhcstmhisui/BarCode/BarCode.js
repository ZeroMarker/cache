/* 高值条码生成*/
var init = function() {
	var RowIdStr = '';
	var SessionParams = gGroupId + '^' + gLocId + '^' + gUserId + '^' + gHospId;
	/* 条码生成*/
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
	// 导入订单
	$UI.linkbutton('#ImpPo', {
		onClick: function() {
			var Locid = $('#CreateLoc').combo('getValue');
			var LocDesc = $('#CreateLoc').combo('getText');
			var LocObj = { RowId: Locid, Description: LocDesc };
			ImportPoSearch(getPoList, LocObj);
		}
	});
	// 导入平台订单
	$UI.linkbutton('#ImpSciPo', {
		onClick: function() {
			if (SerUseObj.SCI === 'Y') {
				ImportSciPoSearch(QueryForSciPo);
			} else if (SerUseObj.ECS === 'Y') {
				ImportECSPoSearch(QueryForSciPo);
			} else {
				$UI.msg('alert', '请先维护平台调用参数!');
			}
		}
	});
	$('#File').filebox({
		prompt: $g('请选择要导入的Excel'),
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
		window.open('../scripts/dhcstmhisui/BarCode/条码注册模板.xls', '_blank');
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
			if (FindIndex >= 0) { continue; } // 订单明细已导入
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
				$UI.msg('alert', '没有要保存明细!');
				return false;
			}
			SaveBatExpWin(SaveBatExp);
		}
	});

	function ImportExcelFN() {
		var wb;
		var filelist = $('#File').filebox('files');
		if (filelist.length == 0) {
			$UI.msg('alert', '请选择要导入的Excel!');
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
			defval: ''		// 格子为空时的默认值
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
				$UI.msg('alert', $g('行:') + (i + 1) + $g(',该行效期格式不正确!'));
				hideMask();
				return;
			}
			if ((ProduceDate != '') && (!CheckDateForm(ProduceDate, dateFormat))) {
				$UI.msg('alert', $g('行:') + (i + 1) + $g(',该行生产日期格式不正确!'));
				hideMask();
				return;
			}
			var Str = tkMakeServerCall('web.DHCSTMHUI.DHCItmTrack', 'GetInciMsg', InciCode, Manf, Hospital);
			if (isEmpty(Str)) {
				$UI.msg('alert', $g('行:') + (i + 1) + $g(',该行物资相关信息不存在!'));
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
				$UI.msg('alert', $g('行:') + (i + 1) + $g('该行物资代码相关信息不存在!'));
				hideMask();
				return;
			}
			if ((!isEmpty(result[i].CertNo)) && (result[i].CertNo != Str.split('^')[11])) {
				$UI.msg('alert', $g('行:') + (i + 1) + ',' + result[i].InciCode + result[i].InciDesc + $g('注册证号与字典项目注册证不同!'));
				hideMask();
				return;
			} else if (isEmpty(result[i].CertNo)) {
				result[i].CertNo = Str.split('^')[11];
			}
			if (result[i].InciDesc != Str.split('^')[12]) {
				$UI.msg('alert', $g('行:') + (i + 1) + ',' + result[i].InciCode + result[i].InciDesc + $g('该行物资名称输入错误!'));
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
		var FillFlag = $("input[name='Fill']:checked").val();	// 1:不覆盖, 2:覆盖已填
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
			$UI.msg('alert', $g('已填充行数:') + FillCount + $g(', 请注意保存!'));
		} else {
			$UI.msg('error', '未进行有效填充!');
		}
	}
	
	function Query() {
		var ParamsObj = $CommonUI.loopBlock('#MainConditions');
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
		if (isEmpty(StartDate)) {
			$UI.msg('alert', '开始日期不能为空!');
			return;
		}
		if (isEmpty(EndDate)) {
			$UI.msg('alert', '截止日期不能为空!');
			return;
		}
		if (compareDate(StartDate, EndDate)) {
			$UI.msg('alert', '截止日期不能小于开始日期!');
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
			totalFooter: '"InciCode":"合计"',
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
		if (Detail === false) {	// 未完成编辑或明细为空
			return;
		}
		if (isEmpty(Detail)) {	// 明细不变
			$UI.msg('alert', '没有需要保存的明细!');
			return;
		}
		// 有效行数
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
				CheckMsg = $g('行:') + (i + 1) + $g(',供应商为空');
				CheckMsgArr.push(CheckMsg);
			}
			var BatchCodeFlag = RowData['BatchCodeFlag'];
			var BatchCode = RowData['BatchCode'];
			if ((BatchCodeFlag == 'Y') && (BatchCode == '')) {
				CheckMsg = $g('行:') + (i + 1) + $g('自带批次码为空');
				CheckMsgArr.push(CheckMsg);
			}
			if (Rp < 0 || Sp < 0) {
				CheckMsg = $g('行:') + (i + 1) + $g(',进价或售价不能小于零');
				CheckMsgArr.push(CheckMsg);
			}
			if (Rp == 0 || Sp == 0) {
				ConfirmMsg = $g('行:') + (i + 1) + $g(',进价或售价为零');
				ConfirmMsgArr.push(ConfirmMsg);
			}
			if ((!isEmpty(BatchNo)) && (BatchReq == 'N')) {
				CheckMsg = $g('行:') + (i + 1) + $g(',批号不允许填写');
				CheckMsgArr.push(CheckMsg);
			}
			if ((isEmpty(BatchNo)) && (BatchReq == 'R')) {
				CheckMsg = $g('行:') + (i + 1) + $g(',批号必须填写');
				CheckMsgArr.push(CheckMsg);
			}
			if ((!isEmpty(ExpDate)) && (ExpReq == 'N')) {
				CheckMsg = $g('行:') + (i + 1) + $g(',有效期不允许填写');
				CheckMsgArr.push(CheckMsg);
			}
			if ((isEmpty(ExpDate)) && (ExpReq == 'R')) {
				CheckMsg = $g('行:') + (i + 1) + $g(',有效期必须填写');
				CheckMsgArr.push(CheckMsg);
			}
			if (!isEmpty(ExpDate)) {
				if (compareDate(NowDate, ExpDate)) {
					CheckMsg = $g('行:') + (i + 1) + $g(',有效期不能早于当前日期');
					CheckMsgArr.push(CheckMsg);
				} else {
					var ExpDateMsg = tkMakeServerCall('web.DHCSTMHUI.DHCINGdRecItm', 'CheckExpDate', InciId, ExpDate);
					if (!isEmpty(ExpDateMsg)) {
						CheckMsg = $g('行:') + (i + 1) + ',' + ExpDateMsg;
						CheckExpDateMsgArr.push(CheckMsg);
					}
				}
			}
			if ((!isEmpty(ProduceDate)) && (compareDate(ProduceDate, NowDate))) {
				CheckMsg = $g('行:') + (i + 1) + $g(',生产日期不能晚于当前日期');
				CheckMsgArr.push(CheckMsg);
			}
			if (TableFlag == 'Y') {
				CheckMsg = $g('行:') + (i + 1) + $g(',跟台高值不允许生成条码');
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
			$UI.confirm(ConfirmMsgArr.join() + $g('是否继续?'), '', '', SaveBarCode);
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
	
	// 打印按钮对应方法
	var PrintBtn = $('#Print').menubutton({ menu: '#mm-Print' });
	$(PrintBtn.menubutton('options').menu).menu({
		onClick: function(item) {
			var BtnName = item.name;		// div定义了name属性
			var rowsData = '', row = '', rowIndex = 0, count = 0;
			if (BtnName == 'PrintBarCode') {
				rowsData = BarCodeGrid.getSelections();
				if (rowsData.length <= 0) {
					$UI.msg('alert', '没有要打印的高值条码!');
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
					$UI.msg('alert', '没有要打印的高值条码!');
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
					$UI.msg('alert', '没有要打印的高值条码!');
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
					$UI.msg('alert', '没有要打印的高值条码!');
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
	
	// / 判断自带条码是否存在
	function GetRepeatResult(colValue) {
		var RowsData = BarCodeGrid.getRows();
		// 有效行数
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
			title: '物资RowId',
			field: 'InciId',
			width: 50,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 100
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 160,
			editor: InciEditor(HandlerParams, SelectRow)
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '具体规格',
			field: 'SpecDesc',
			width: 100,
			formatter: CommonFormatter(SpecDescbox, 'SpecDesc', 'SpecDesc'),
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true,
			editor: (CodeMainParamObj.UseSpecList == 'Y' ? false : true) ? null : SpecDescbox
		}, {
			title: '数量',
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
			title: '高值条码',
			field: 'BarCode',
			width: 280
		}, {
			title: '自带码',
			field: 'OriginalCode',
			hidden: hiddenOrigiBarCode,
			width: 200,
			editor: {
				type: 'text'
			}
		}, {
			title: '自带批次码',
			field: 'BatchCode',
			width: 200,
			editor: {
				type: 'text'
			}
		}, {
			title: '进价',
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
			title: '进价金额',
			field: 'RpAmt',
			align: 'right',
			width: 100
		}, {
			title: '售价',
			field: 'Sp',
			align: 'right',
			width: 80
		}, {
			title: 'Inpoi',
			field: 'Inpoi',
			hidden: true,
			width: 100
		}, {
			title: '批号',
			field: 'BatchNo',
			width: 100,
			editor: {
				type: 'text'
			}
		}, {
			title: '效期',
			field: 'ExpDate',
			width: 150,
			editor: {
				type: 'datebox'
			}
		}, {
			title: '生产日期',
			field: 'ProduceDate',
			width: 100,
			editor: {
				type: 'datebox'
			}
		}, {
			title: '单位dr',
			field: 'BUomId',
			width: 100,
			hidden: true
		}, {
			title: '单位',
			field: 'BUom',
			width: 50
		}, {
			title: '注册证号',
			field: 'CertNo',
			width: 100,
			editable: false,
			formatter: CommonFormatter(RegCertBox, 'CertNo', 'CertNo'),
			editor: RegCertBox
		}, {
			title: '注册证效期',
			field: 'CertExpDate',
			width: 100,
			editor: {
				type: 'datebox'
			}
		}, {
			title: '供应商',
			field: 'VendorId',
			width: 120,
			formatter: CommonFormatter(VendorBox, 'VendorId', 'VendorDesc'),
			editor: VendorBox
		}, {
			title: '生产厂家',
			field: 'ManfId',
			width: 100,
			hidden: true
		}, {
			title: '生产厂家',
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
			title: '随行单号',
			field: 'SxNo',
			width: 100,
			hidden: false
		}, {
			title: '批号要求',
			field: 'BatchReq',
			width: 80,
			hidden: true
		}, {
			title: '有效期要求',
			field: 'ExpReq',
			width: 80,
			hidden: true
		}, {
			title: '批次码标志',
			field: 'BatchCodeFlag',
			width: 100,
			hidden: false,
			align: 'center'
		}, {
			title: '条码类型',
			field: 'OriginalStatus',
			width: 100,
			hidden: false,
			formatter: OriginalStatusFormatter
		}, {
			title: '跟台标志',
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
			totalFooter: '"InciCode":"合计"',
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
		checkOnSelect: false,		// 该属性为true时,双击事件受onBeforeCheck事件影响.
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
				$UI.msg('alert', '无效明细!');
				BarCodeGrid.checked = false;
				return false;
			}
			var OriginalStatus = row.OriginalStatus;
			if (changes.hasOwnProperty('Qty')) {
				if ((!isEmpty(RowId)) && (isEmpty(OriginalStatus))) {
					$UI.msg('alert', '唯一码保存后数量不能再修改!');
					BarCodeGrid.checked = false;
					return false;
				}
			}
			if (changes.hasOwnProperty('BatchCode')) {
				if ((!isEmpty(RowId)) && (OriginalStatus == 'NotUnique')) {
					$UI.msg('alert', '批次码管理的高值生成条码后自带批次码不能修改!');
					BarCodeGrid.checked = false;
					return false;
				}
			}
			if (changes.hasOwnProperty('Rp')) {
				var rp = row.Rp;
				if (isEmpty(rp)) {
					$UI.msg('alert', '进价不能为空!');
					BarCodeGrid.checked = false;
					return false;
				} else if (rp < 0) {
					$UI.msg('alert', '进价不能小于零!');
					BarCodeGrid.checked = false;
					return false;
				} else if (rp == 0) {
					$UI.msg('alert', '进价等于零!');
				}
				
				var SessionParams = gGroupId + '^' + gLocId + '^' + gUserId + '^' + gHospId;
				var UomId = row.BUomId;
				var sp = tkMakeServerCall('web.DHCSTMHUI.DHCINGdRec', 'GetSpForRec', IncId, UomId, rp, SessionParams);
				// 验证加成率
				var ChargeFlag = tkMakeServerCall('web.DHCSTMHUI.Common.DrugInfoCommon', 'GetChargeFlag', IncId);
				var margin = 0;
				if ((rp != 0) && (ChargeFlag == 'Y')) {
					margin = accSub(accDiv(sp, rp), 1);
					if ((IngrParamObj.MarginWarning != 0) && ((margin > IngrParamObj.MarginWarning) || (margin < 0))) {
						$UI.msg('alert', '加成率超出限定范围!');
						BarCodeGrid.checked = false;
						return false;
					}
				}
				row.Sp = sp;
				// / 是否调价
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
					$UI.confirm(row.InciDesc + $g('价格发生变化，是否生成调价单?'), '', '', SetAdjPrice, '', '', '', '', adjPriceObj);
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
									$UI.msg('alert', OriginalCode + $g('条码已经存在！'));
									$(this).val('');
									return;
								}
								var ret = tkMakeServerCall('web.DHCSTMHUI.DHCItmTrack', 'OriBarIfExit', OriginalCode);
								if (ret == 1) {
									$UI.msg('alert', OriginalCode + $g('条码已经存在！'));
									$(this).val('');
									return;
								}
								// 自动拆分批号效期
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
											$UI.msg('error', '条码物资信息和本行数据不匹配!');
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
									$UI.msg('alert', $g('自动填充了批号:') + BatchNo + $g(',有效期:') + ExpDate + $g(',生产日期:') + ProduceDate + $g(', 请注意核对!'));
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
											$UI.msg('error', '条码物资信息和本行数据不匹配!');
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
									$UI.msg('alert', $g('自动填充了批号:') + BatchNo + $g(',有效期:') + ExpDate + $g(',生产日期:') + ProduceDate + $g(', 请注意核对!'));
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
			// 检查入库供应商和明细上是否相符
			if (!isEmpty(IngrVendorId) && !isEmpty(RowVendorId) && (IngrVendorId != RowVendorId)) {
				$UI.msg('alert', $g('行:') + (index + 1) + $g(',供应商与入库供应商不符,请核实!'));
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
			// 没有选择的行时,置空供应商
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
					NullInfoArr.push($g('供应商'));
				}
				if (!isEmpty(NullInfoArr)) {
					var NullInfo = NullInfoArr.join('、');
					var MsgStr = $g('行:') + (i + 1) + ',' + NullInfo + $g('与入库供应商不同');
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
			// 没有选择的行时,置空供应商
			if (isEmpty($(this).datagrid('getSelected'))) {
				$('#InGdReqVendor').combobox('setValue', '');
			}
		}
	});
	
	/* 入库*/
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
		// 有效行数
		var count = 0;
		for (var i = 0; i < RowsData.length; i++) {
			var item = RowsData[i].RowId;
			if (!isEmpty(item)) {
				count++;
			}
		}
		if (RowsData.length <= 0 || count <= 0) {
			$UI.msg('alert', '请选择入库明细!');
			return false;
		}
		
		var IngrMainParamObj = $UI.loopBlock('#IngrConditions');
		// 判断入库单是否已审批
		// 判断入库部门和供货商是否为空
		var phaLoc = IngrMainParamObj.InGdRecLocId;
		if (isEmpty(phaLoc)) {
			$UI.msg('alert', '请选择入库科室!');
			return false;
		}
		var vendor = IngrMainParamObj.InGdReqVendor;
		if (isEmpty(vendor)) {
			$UI.msg('alert', '请选择供应商!');
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
				NullInfoArr.push($g('批号'));
			}
			if ((ExpReq == 'R') && isEmpty(ExpDate)) {
				NullInfoArr.push($g('有效期'));
			}
			if (!isEmpty(NullInfoArr)) {
				var NullInfo = NullInfoArr.join('、');
				CheckMsg = '行:' + (i + 1) + ',' + NullInfo + $g('没有录入');
				CheckMsgArr.push(CheckMsg);
			}
			if (!isEmpty(VendorId) && (VendorId != vendor)) {
				NullInfoArr.push($g('供应商'));
				CheckMsg = '行:' + (i + 1) + $g(',供应商与入库供应商不同');
				CheckMsgArr.push(CheckMsg);
			}
			if ((!isEmpty(BatchNo)) && (BatchReq == 'N')) {
				CheckMsg = '行:' + (i + 1) + $g(',批号不允许填写');
				CheckMsgArr.push(CheckMsg);
			}
			if ((!isEmpty(ExpDate)) && (ExpReq == 'N')) {
				CheckMsg = '行:' + (i + 1) + $g(',有效期不允许填写');
				CheckMsgArr.push(CheckMsg);
			}
			if (!isEmpty(ExpDate)) {
				if (compareDate(NowDate, ExpDate)) {
					CheckMsg = '行:' + (i + 1) + $g(',有效期不能早于当前日期');
					CheckMsgArr.push(CheckMsg);
				} else {
					var ExpDateMsg = tkMakeServerCall('web.DHCSTMHUI.DHCINGdRecItm', 'CheckExpDate', InciId, ExpDate);
					if (!isEmpty(ExpDateMsg)) {
						CheckMsg = '行:' + (i + 1) + ',' + ExpDateMsg;
						CheckExpDateMsgArr.push(CheckMsg);
					}
				}
			}
			if ((!isEmpty(ProduceDate)) && (compareDate(ProduceDate, NowDate))) {
				CheckMsg = $g('行:') + (i + 1) + $g(',生产日期不能晚于当前日期');
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
				Common_AddTab('高值入库', UrlStr);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	/* 初始化*/
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