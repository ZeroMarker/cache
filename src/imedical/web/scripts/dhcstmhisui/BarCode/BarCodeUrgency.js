/* 高值生成条码(紧急业务)*/
var init = function() {
	var RowIdStr = '';
	function GetParamsObj(Condition) {
		var ParamsObj = $CommonUI.loopBlock(Condition);
		return ParamsObj;
	}
	var Clear = function() {
		RowIdStr = '';
		$UI.clearBlock('#MainConditions');
		$UI.clearBlock('#IngrConditions');
		$UI.clear(BarCodeGrid);
		$UI.clear(IngrMainGrid);
		$UI.clear(IngrDetailGrid);
		var DefaRecLoc = ItmTrackParamObj.DefaRecLoc;
		var Params = JSON.stringify(addSessionParams());
		var RecLocStr = tkMakeServerCall('web.DHCSTMHUI.Common.UtilCommon', 'LocToRowID', DefaRecLoc, Params);
		var RecLocObj = { RowId: RecLocStr.split('^')[0], Description: RecLocStr.split('^')[1] };
		// /设置初始值 考虑使用配置
		var MainDefaultData = {
			StartDate: TrackDefaultStDate(),
			EndDate: TrackDefaultEdDate()
		};
		var IngrDefaultData = { InGdRecLocId: RecLocObj };
		$UI.fillBlock('#MainConditions', MainDefaultData);
		$UI.fillBlock('#IngrConditions', IngrDefaultData);
	};
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	
	// 打印按钮对应方法
	var PrintBtn = $('#Print').menubutton({ menu: '#mm-Print' });
	$(PrintBtn.menubutton('options').menu).menu({
		onClick: function(item) {
			var BtnName = item.name;		// div定义了name属性
			if (BtnName == 'PrintBarCode') {
				var rowsData = BarCodeGrid.getSelections();
				if (rowsData.length <= 0) {
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
	
	$UI.linkbutton('#CopyBatNoBT', {
		onClick: function() {
			var rows = BarCodeGrid.getRows();
			if (isEmpty(rows)) {
				$UI.msg('alert', '没有需要处理的明细,请勾选条码信息中的记录!');
				return false;
			}
			SaveBatExpWin(SaveBatExp);
		}
	});
	
	function SaveBatExp(Params) {
		if (!BarCodeGrid.endEditing()) {
			return;
		}
		var FillFlag = $("input[name='Fill']:checked").val();	// 1:不覆盖, 2:覆盖已填
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
			$UI.msg('alert', '已填充' + FillCount + '行, 请注意保存!');
		} else {
			$UI.msg('error', '未进行有效填充!');
		}
	}
	
	var FVendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var FVendorBox = $HUI.combobox('#VendorId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + FVendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	function CheckDataBeforeSave() {
		if (!BarCodeGrid.endEditing()) {
			return false;
		}
		var ParamsObj = GetParamsObj('#IngrConditions');
		var MainParamsObj = GetParamsObj('#MainConditions');
		// 判断入库部门和供货商是否为空
		var InGdReqLocId = ParamsObj.InGdReqLocId;
		var vendor = ParamsObj.InGdReqVendor;
		if (isEmpty(vendor)) {
			$UI.msg('alert', '请选择供应商!');
			return false;
		}
		if (isEmpty(MainParamsObj.ScgId)) {
			$UI.msg('alert', '类组不能为空!');
			return false;
		}
		// 1.判断入库物资是否为空
		var RowsData = BarCodeGrid.getSelectedData();
		// 有效行数
		var count = 0;
		for (var i = 0; i < RowsData.length; i++) {
			var item = RowsData[i].RowId;
			if (!isEmpty(item)) {
				count++;
			}
		}
		if (RowsData.length <= 0 || count <= 0) {
			$UI.msg('alert', '没有需要保存的入库明细!');
			return false;
		}
		if (RowsData.length > count) {
			$UI.msg('alert', '存在未注册条码不允许入库!');
			return false;
		}
		var CheckMsgArr = [], CheckExpDateMsgArr = [];
		for (var i = 0; i < RowsData.length; i++) {
			var rp = RowsData[i].Rp;
			var sp = RowsData[i].Sp;
			var Incidesc = RowsData[i].Desc;
			var row = i + 1;
			var item = RowsData[i].RowId;
			var NullInfoArr = [];
			var RowData = RowsData[i];
			var InciId = RowData['InciId'];
			var BatchReq = RowData['BatchReq'];
			var BatchNo = RowData['BatchNo'];
			var ExpReq = RowData['ExpReq'];
			var ExpDate = RowData['ExpDate'];
			var ProduceDate = RowData['ProduceDate'];
			var NowDate = DateFormatter(new Date());
			if ((BatchReq == 'R') && isEmpty(BatchNo)) {
				NullInfoArr.push('批号');
			}
			if ((ExpReq == 'R') && isEmpty(ExpDate)) {
				NullInfoArr.push('有效期');
			}
			if (!isEmpty(NullInfoArr)) {
				var NullInfo = NullInfoArr.join('、');
				var MsgStr = '第' + (i + 1) + '行' + NullInfo + '没有录入';
				CheckMsgArr.push(MsgStr);
			}
			if ((!isEmpty(BatchNo)) && (BatchReq == 'N')) {
				var CheckMsg = '第' + (i + 1) + '行批号不允许填写';
				CheckMsgArr.push(CheckMsg);
			}
			if ((!isEmpty(ExpDate)) && (ExpReq == 'N')) {
				var CheckMsg = '第' + (i + 1) + '行有效期不允许填写';
				CheckMsgArr.push(CheckMsg);
			}
			if (!isEmpty(ExpDate)) {
				if (compareDate(NowDate, ExpDate)) {
					var CheckMsg = '第' + (i + 1) + '行有效期不能早于当前日期';
					CheckMsgArr.push(CheckMsg);
				} else {
					var ExpDateMsg = tkMakeServerCall('web.DHCSTMHUI.DHCINGdRecItm', 'CheckExpDate', InciId, ExpDate);
					if (!isEmpty(ExpDateMsg)) {
						var CheckMsg = '第' + (i + 1) + '行' + ExpDateMsg;
						CheckExpDateMsgArr.push(CheckMsg);
					}
				}
			}
			if ((!isEmpty(ProduceDate)) && (compareDate(ProduceDate, NowDate))) {
				var CheckMsg = '第' + (i + 1) + '行生产日期不能晚于当前日期';
				CheckMsgArr.push(CheckMsg);
			}
			if (rp < 0 || sp < 0) {
				var CheckMsg = '第' + (i + 1) + '行进价或售价不能小于零';
				CheckMsgArr.push(CheckMsg);
			}
			if (rp == 0 || sp == 0) {
				if (!confirm('第' + (i + 1) + '行进价或售价为零,是否继续?')) {
					return false;
				}
			}
		}
		if (!isEmpty(CheckMsgArr)) {
			var CheckMsg = CheckMsgArr.join();
			$UI.msg('error', CheckMsg);
			return false;
		}
		if (!isEmpty(CheckExpDateMsgArr)) {
			var CheckMsg = CheckExpDateMsgArr.join();
			$UI.msg('error', CheckMsg);
		}
		return true;
	}
	function SaveIngr() {
		var Main = JSON.stringify(GetParamsObj('#IngrConditions'));
		var DetailObj = BarCodeGrid.getSelectedData();
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			MethodName: 'CreateUrgencyIngr',
			MainInfo: Main,
			ListDetail: JSON.stringify(DetailObj)
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				var IngrRowid = jsonData.rowid;
				var Params = JSON.stringify(addSessionParams({ IngrStr: IngrRowid }));
				$('#HVEurgencytabs').tabs('select', '入库信息');
				IngrMainGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCINGdRec',
					QueryName: 'Query',
					query2JsonStrict: 1,
					Params: Params
				});
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#SaveInGdRecBT', {
		onClick: function() {
			var InGdReqLocId = $('#InGdReqLocId').combobox('getValue');
			if (isEmpty(InGdReqLocId)) {
				$UI.msg('alert', '请选择请求科室!');
				return false;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.HVUsePermissonLoc',
				MethodName: 'IfAllowDo',
				Loc: InGdReqLocId,
				User: gUserId
			}, function(jsonData) {
				if (jsonData.success === 0) {
					if (CheckDataBeforeSave() == true) {
						SaveIngr();
					}
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#PrintHVColBT', {
		onClick: function() {
			var Row = IngrMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要打印的入库单!');
				return;
			}
			var IngrId = Row.IngrId;
			PrintRecHVCol(IngrId);
		}
	});
	
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	
	function Query() {
		var ParamsObj = GetParamsObj('#MainConditions');
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
			rows: 99999
		});
		RowIdStr = '';
	}
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			SaveBarCode();
		}
	});
	function SaveBarCode() {
		var MainObj = addSessionParams(GetParamsObj('#MainConditions'));
		var IngrObj = GetParamsObj('#IngrConditions');
		var Main = JSON.stringify(jQuery.extend(true, MainObj, IngrObj));
		var DetailObj = BarCodeGrid.getChangesData('InciId');
		if (DetailObj === false) {	// 未完成编辑或明细为空
			return;
		}
		if (isEmpty(DetailObj)) {	// 明细不变
			$UI.msg('alert', '没有需要保存的明细，请勾选条码信息中的记录!');
			return;
		}
		var CheckMsgArr = [], CheckExpDateMsgArr = [];
		for (var i = 0; i < DetailObj.length; i++) {
			var RowData = DetailObj[i];
			var InciId = RowData['InciId'];
			var VendorId = RowData['VendorId'];
			var ExpReq = RowData['ExpReq'];
			var ExpDate = RowData['ExpDate'];
			var ProduceDate = RowData['ProduceDate'];
			var BatchReq = RowData['BatchReq'];
			var BatchNo = RowData['BatchNo'];
			var NowDate = DateFormatter(new Date());
			var TableFlag = RowData['TableFlag'];
			var rp = RowData['Rp'];
			var sp = RowData['Sp'];
			if (VendorId == '') {
				var CheckMsg = '第' + (i + 1) + '行供应商为空';
				CheckMsgArr.push(CheckMsg);
			}
			var BatchCodeFlag = RowData['BatchCodeFlag'];
			var BatchCode = RowData['BatchCode'];
			if ((BatchCodeFlag == 'Y') && (BatchCode == '')) {
				var CheckMsg = '第' + (i + 1) + '行自带批次码为空';
				CheckMsgArr.push(CheckMsg);
			}
			if ((!isEmpty(BatchNo)) && (BatchReq == 'N')) {
				var CheckMsg = '第' + (i + 1) + '行批号不允许填写';
				CheckMsgArr.push(CheckMsg);
			}
			if ((isEmpty(BatchNo)) && (BatchReq == 'R')) {
				var CheckMsg = '第' + (i + 1) + '行批号必须填写';
				CheckMsgArr.push(CheckMsg);
			}
			if ((!isEmpty(ExpDate)) && (ExpReq == 'N')) {
				var CheckMsg = '第' + (i + 1) + '行有效期不允许填写';
				CheckMsgArr.push(CheckMsg);
			}
			if ((isEmpty(ExpDate)) && (ExpReq == 'R')) {
				var CheckMsg = '第' + (i + 1) + '行有效期必须填写';
				CheckMsgArr.push(CheckMsg);
			}
			if (!isEmpty(ExpDate)) {
				if (compareDate(NowDate, ExpDate)) {
					var CheckMsg = '第' + (i + 1) + '行有效期不能早于当前日期';
					CheckMsgArr.push(CheckMsg);
				} else {
					var ExpDateMsg = tkMakeServerCall('web.DHCSTMHUI.DHCINGdRecItm', 'CheckExpDate', InciId, ExpDate);
					if (!isEmpty(ExpDateMsg)) {
						var CheckMsg = '第' + (i + 1) + '行' + ExpDateMsg;
						CheckExpDateMsgArr.push(CheckMsg);
					}
				}
			}
			if ((!isEmpty(ProduceDate)) && (compareDate(ProduceDate, NowDate))) {
				var CheckMsg = '第' + (i + 1) + '行生产日期不能晚于当前日期';
				CheckMsgArr.push(CheckMsg);
			}
			if (TableFlag == 'Y') {
				var CheckMsg = '第' + (i + 1) + '行跟台高值不允许生成条码';
				CheckMsgArr.push(CheckMsg);
			}
			if (rp < 0 || sp < 0) {
				var CheckMsg = '第' + (i + 1) + '行进价或售价不能小于零';
				CheckMsgArr.push(CheckMsg);
			}
			if (rp == 0 || sp == 0) {
				if (!confirm('第' + (i + 1) + '行进价或售价为零,是否继续?')) {
					return false;
				}
			}
		}
		if (!isEmpty(CheckMsgArr)) {
			$UI.msg('alert', CheckMsgArr.join());
			return false;
		}
		if (!isEmpty(CheckExpDateMsgArr)) {
			$UI.msg('alert', CheckExpDateMsgArr.join());
		}
		var Detail = JSON.stringify(DetailObj);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			MethodName: 'jsRegHV',
			MainInfo: Main,
			ListDetail: Detail
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
	var HandlerParams = function() {
		var Scg = $('#ScgId').combotree('getValue');
		var LocDr = $('#InGdRecLocId').combo('getValue');
		var ReqLoc = '';
		var HV = 'Y';
		var QtyFlag = '0';
		var Obj = { StkGrpRowId: Scg, StkGrpType: 'M', Locdr: LocDr, NotUseFlag: 'N', QtyFlag: QtyFlag, HV: HV, RequestNoStock: 'Y' };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
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
				BUomId: row.BUomDr,
				BUom: row.BUomDesc,
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
	var VendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var VendorBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function(record) {
				var CheckQualParams = JSON.stringify(addSessionParams({
					ApcvmDr: record.RowId,
					Inci: '',
					ManfId: ''
				}));
				var CheckQualData = tkMakeServerCall('web.DHCSTMHUI.Common.UtilCommon', 'CheckNew', CheckQualParams);
				if (CheckQualData != '') {
					$UI.msg('alert', row.InciDesc + ':' + CheckQualData);
					if (CommParObj.StopItmBussiness == 'Y') {
						return false;
					}
				}
				var rows = BarCodeGrid.getRows();
				var row = rows[BarCodeGrid.editIndex];
				row.VendorDesc = record.Description;
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
				
			}
		}
	};
	var RecLocParams = JSON.stringify(addSessionParams({ Type: 'All', Element: 'InGdRecLocId' }));
	var InGdRecLocIdBox = $HUI.combobox('#InGdRecLocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + RecLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var RecVendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var RecVendorBox = $HUI.combobox('#InGdReqVendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + RecVendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var ReqLocParams = JSON.stringify(addSessionParams({ Type: 'Login', Element: 'InGdReqLocId' }));
	var ReqLocBox = $HUI.combobox('#InGdReqLocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var SourceOfFundParams = JSON.stringify(addSessionParams());
	var SourceOfFundBox = $HUI.combobox('#Source', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSourceOfFund&ResultSetType=array&Params=' + SourceOfFundParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var SpecDescParams = JSON.stringify(sessionObj);
	var SpecDescbox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSpecDesc&ResultSetType=array&Params=' + SpecDescParams,
			valueField: 'Description',
			textField: 'Description',
			mode: 'remote',
			onBeforeLoad: function(param) {
				var Select = BarCodeGrid.getSelected();
				if (!isEmpty(Select)) {
					param.Inci = Select.InciId;
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
				BarCodeGrid.refreshRow();
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
			hidden: true,
			width: 60
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 150
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 200,
			editor: InciEditor(HandlerParams, SelectRow)
		}, {
			title: '规格',
			field: 'Spec',
			width: 150
		}, {
			title: '数量',
			field: 'Qty',
			width: 60,
			align: 'right',
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					tipPosition: 'bottom',
					precision: 0
				}
			}
		}, {
			title: '高值条码',
			field: 'BarCode',
			width: 200
		}, {
			title: '自带条码',
			field: 'OriginalCode',
			hidden: hiddenOrigiBarCode,
			width: 200,
			editor: {
				type: 'text',
				options: {
				}
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
			width: 60,
			align: 'right',
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
			title: '当前售价',
			field: 'Sp',
			width: 80,
			align: 'right'
		}, {
			title: '招标进价',
			field: 'PbRp',
			width: 80,
			align: 'right'
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
			width: 100,
			editor: {
				type: 'datebox'
			}
		}, {
			title: '基本单位dr',
			field: 'BUomId',
			width: 100,
			hidden: true
		}, {
			title: '入库单位dr',
			field: 'PurUomId',
			width: 100,
			hidden: true
		}, {
			title: '具体规格',
			field: 'SpecDesc',
			width: 100,
			editable: false,
			formatter: CommonFormatter(SpecDescbox, 'SpecDesc', 'SpecDesc'),
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true,
			editor: (CodeMainParamObj.UseSpecList == 'Y' ? false : true) ? null : SpecDescbox
		}, {
			title: '生产日期',
			field: 'ProduceDate',
			width: 100,
			editor: {
				type: 'datebox',
				options: {
				}
			}
		}, {
			title: '单位',
			field: 'BUom',
			width: 100
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
				type: 'datebox',
				options: {
				}
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
			formatter: CommonFormatter(PhManufacturerBox, 'ManfId', 'Manf'),
			editor: PhManufacturerBox
		}, {
			title: 'DetailSubId',
			field: 'OrderDetailSubId',
			width: 100,
			hidden: true
		}, {
			title: '生成(注册)人员',
			field: 'User',
			width: 150
		}, {
			title: '生成(注册)日期',
			field: 'Date',
			width: 150
		}, {
			title: '生成(注册)时间',
			field: 'Time',
			width: 150
		}, {
			title: '品牌',
			field: 'Brand',
			width: 100
		}, {
			title: '批号要求',
			field: 'BatchReq',
			width: 100,
			hidden: true
		}, {
			title: '效期要求',
			field: 'ExpReq',
			width: 100,
			hidden: true
		}, {
			title: 'Ingri',
			field: 'Ingri',
			width: 50,
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
			rows: 99999
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			MethodName: 'DeleteLabel'
		},
		columns: BarCodeCm,
		checkField: 'InciId',
		singleSelect: false,
		showBar: true,
		remoteSort: false,
		pagination: false,
		showAddDelItems: true,
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
		beforeAddFn: function() {
			var ParamsObj = GetParamsObj('#IngrConditions');
			if (isEmpty(ParamsObj.InGdRecLocId)) {
				$UI.msg('error', '请联系管理员设置入库科室!');
				return false;
			}
		},
		onBeforeCheck: function(index, row) {
			var IngrVendorId = $('#InGdReqVendor').combobox('getValue');
			var RowVendorId = row['VendorId'];
			// 检查入库供应商和明细上是否相符
			if (!isEmpty(IngrVendorId) && !isEmpty(RowVendorId) && (IngrVendorId != RowVendorId)) {
				$UI.msg('alert', '第' + (index + 1) + '行供应商与入库供应商不符,请核实!');
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
					NullInfoArr.push('供应商');
				}
				if (!isEmpty(NullInfoArr)) {
					var NullInfo = NullInfoArr.join('、');
					var MsgStr = '第' + (i + 1) + '行' + NullInfo + '与入库供应商不同';
					CheckMsgArr.push(MsgStr);
				}
			}
			if (!isEmpty(CheckMsgArr)) {
				var CheckMsg = CheckMsgArr.join();
				$UI.msg('error', CheckMsg);
				$('#InGdReqVendor').combobox('setValue', '');
				return false;
			}
		},
		onUncheckAll: function(rows) {
			// 没有选择的行时,置空供应商
			if (isEmpty($(this).datagrid('getSelected'))) {
				$('#InGdReqVendor').combobox('setValue', '');
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
		}
	});
	
	var InGdRecMainCm = [[
		{
			title: 'RowId',
			field: 'IngrId',
			width: 100,
			hidden: true
		}, {
			title: '入库单号',
			field: 'IngrNo',
			width: 120
		}, {
			title: '入库科室',
			field: 'RecLoc',
			width: 150
		}, {
			title: '接收科室',
			field: 'ReqLocDesc',
			width: 150,
			hidden: true
		}, {
			title: '供应商',
			field: 'Vendor',
			width: 200
		}, {
			title: '资金来源',
			field: 'SourceOfFund',
			width: 200
		}, {
			title: '创建人',
			field: 'CreateUser',
			width: 70
		}, {
			title: '创建日期',
			field: 'CreateDate',
			width: 90
		}, {
			title: '进价金额',
			field: 'RpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '售价金额',
			field: 'SpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '进销差价',
			field: 'Margin',
			width: 100,
			align: 'right'
		}, {
			title: 'ReqLoc',
			field: 'ReqLoc',
			width: 10,
			hidden: true
		}, {
			title: 'Complete',
			field: 'Complete',
			width: 10,
			hidden: true
		}, {
			title: 'StkGrp',
			field: 'StkGrp',
			width: 10,
			hidden: true
		}
	]];
	var IngrMainGrid = $UI.datagrid('#IngrMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			QueryName: 'Query',
			query2JsonStrict: 1
		},
		columns: InGdRecMainCm,
		showBar: true,
		onSelect: function(index, row) {
			IngrDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
				QueryName: 'QueryDetail',
				query2JsonStrict: 1,
				Parref: row.IngrId
			});
		}, onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				IngrMainGrid.selectRow(0);
			}
		}
	});
	var InGdRecDetailCm = [[{
		title: 'RowId',
		field: 'RowId',
		width: 100,
		hidden: true
	}, {
		title: '物资代码',
		field: 'IncCode',
		width: 80
	}, {
		title: '物资名称',
		field: 'IncDesc',
		width: 230
	}, {
		title: '高值条码',
		field: 'HVBarCode',
		width: 80
	}, {
		title: '自带条码',
		field: 'OrigiBarCode',
		width: 80
	}, {
		title: '规格',
		field: 'Spec',
		width: 80
	}, {
		title: '生产厂家',
		field: 'Manf',
		width: 180
	}, {
		title: '批次id',
		field: 'Inclb',
		width: 70,
		hidden: true
	}, {
		title: '批号',
		field: 'BatchNo',
		width: 90
	}, {
		title: '有效期',
		field: 'ExpDate',
		width: 100
	}, {
		title: '单位',
		field: 'IngrUom',
		width: 80
	}, {
		title: '数量',
		field: 'RecQty',
		width: 80,
		align: 'right'
	}, {
		title: '进价',
		field: 'Rp',
		width: 60,
		align: 'right'
	}, {
		title: '售价',
		field: 'Sp',
		width: 60,
		align: 'right'
	}, {
		title: '进价金额',
		field: 'RpAmt',
		width: 100,
		align: 'right'
	}, {
		title: '售价金额',
		field: 'SpAmt',
		width: 100,
		align: 'right'
	}, {
		title: '进销差价',
		field: 'Margin',
		width: 100,
		align: 'right'
	}
	]];
	var IngrDetailGrid = $UI.datagrid('#IngrDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
			QueryName: 'QueryDetail',
			query2JsonStrict: 1
		},
		columns: InGdRecDetailCm,
		showBar: true
	});
	Clear();
	if (isEmpty(GetParamsObj('#IngrConditions').InGdRecLocId)) {
		$UI.msg('error', '请联系管理员设置入库科室!');
	}
};
$(init);