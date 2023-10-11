/*
入库单制单
 */
var ScgTipFlag = '';
var init = function() {
	// 获取入库主表信息
	function GetParamsObj() {
		var ParamsObj = $UI.loopBlock('#MainConditions');
		return ParamsObj;
	}
	// Grid 列 comboxData
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
				if (isEmpty(NewUomid) || (NewUomid == OldUomid)) {
					return false;
				}
				var BUomId = row.BUomId;
				var confac = row.ConFacPur;
				if (NewUomid == BUomId) { // 入库单位转换为基本单位
					var rp = row.Rp;
					var sp = row.Sp;
					var newsp = row.NewSp;
					row.Rp = Number(rp).div(Number(confac));
					row.Sp = Number(sp).div(Number(confac));
					row.NewSp = Number(newsp).div(Number(confac));
				} else { // 基本单位转换为入库单位
					var rp = row.Rp;
					var sp = row.Sp;
					var newsp = row.NewSp;
					row.Rp = Number(rp).mul(Number(confac));
					row.Sp = Number(sp).mul(Number(confac));
					row.NewSp = Number(newsp).mul(Number(confac));
				}
				if (isEmpty(row.RecQty)) {
					var RpAmt = 0;
					var SpAmt = 0;
				} else {
					var RpAmt = Number(row.Rp).mul(row.RecQty);
					var SpAmt = Number(row.Sp).mul(row.RecQty);
				}
				row.RpAmt = RpAmt;
				row.SpAmt = SpAmt;
				row.InvMoney = RpAmt;
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
				row.AdmNo = record.Description;
				row.Manf = record.MRCManfDesc;
				InGdRecGrid.EditorSetValue('AdmExpdate', record.MRCExpDate);
				setTimeout(function() {
					InGdRecGrid.refreshRow();
				}, 0);
			}
		}
	};
	
	var PhManufacturerParams = JSON.stringify(addSessionParams({
		StkType: 'M'
	}));
	var PhManufacturerBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params=' + PhManufacturerParams,
			valueField: 'RowId',
			textField: 'Description',
			onBeforeLoad: function(param) {
				var ScgId = $('#StkGrpId').combotree('getValue');
				param.ScgId = ScgId;
			},
			onSelect: function(record) {
				var rows = InGdRecGrid.getRows();
				var row = rows[InGdRecGrid.editIndex];
				row.Manf = record.Description;
			}
		}
	};
	var ReqLocParams = JSON.stringify(addSessionParams({
		Type: 'All'
	}));
	var ReqLocCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocParams,
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
	var RecLocParams = JSON.stringify(addSessionParams({
		Type: 'Login',
		Element: 'RecLoc'
	}));
	var RecLocBox = $HUI.combobox('#RecLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + RecLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$HUI.combotree('#StkGrpId').setFilterByLoc(LocId);
			$('#PurchaseUser').combobox('clear');
			if (CommParObj.ApcScg == 'L') {
				VendorBox.clear();
				var Params = JSON.stringify(addSessionParams({ APCType: 'M', LocId: LocId }));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + Params;
				VendorBox.reload(url);
			}
		}
	});
	var ReqLocIdParams = JSON.stringify(addSessionParams({
		Type: 'All',
		Element: 'ReqLocId'
	}));
	var ReqLocIdBox = $HUI.combobox('#ReqLocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocIdParams
	});
	/*
	$('#ReqLocId').lookup({
		// mode:'remote',
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetCTLoc',
			Params: ReqLocIdParams,
			rows: 99999
		}
	});*/
	var VendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	$('#StkGrpId').combotree({
		onClick: function(node) {
			if (CommParObj.ApcScg == 'S') {
				VendorBox.clear();
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams + '&ScgId=' + node.id;
				VendorBox.reload(url);
			}
		}
	});
	var VendorBox = $HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
		valueField: 'RowId',
		textField: 'Description',
		onBeforeLoad: function(param) {
			var ParamsObj = $UI.loopBlock('#MainConditions');
			var ScgId = ParamsObj.StkGrpId;
			param.ScgId = ScgId;
		}
	});
	var IngrTypeIdParams = JSON.stringify(addSessionParams({
		Type: 'IM'
	}));
	var IngrTypeIdBox = $HUI.combobox('#IngrTypeId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOperateType&ResultSetType=array&Params=' + IngrTypeIdParams,
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function() {
			var IngrTypeInfo = GetIngrtypeDefa();
			var IngrTypeId = IngrTypeInfo.split('^')[0];
			$('#IngrTypeId').combobox('select', IngrTypeId);
		}
	});
	/*
	$('#IngrTypeId').lookup({
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetOperateType',
			Params: IngrTypeIdParams,
			rows: 99999
		}
	});*/
	var PurchaseUserParams = JSON.stringify(addSessionParams({
		LocDr: gLocId,
		UseAllUserAsPur: IngrParamObj.UseAllUserAsPur
	}));
	var PurchaseUserBox = $HUI.combobox('#PurchaseUser', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocPPLUser&ResultSetType=array&Params=' + PurchaseUserParams,
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function() {
			var data = $(this).combobox('getData');
			if (data.length > 0) {
				for (var i = 0; i < data.length; i++) {
					if (data[i].Default == 'Y') {
						$(this).combobox('select', data[i].RowId);
						return;
					}
				}
			}
		}
	});
	/*
	$('#PurchaseUser').lookup({
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetLocPPLUser',
			Params: PurchaseUserParams,
			rows: 99999
		}
	});*/
	var AcceptUserIdParams = JSON.stringify(addSessionParams({
		LocDr: ''
	}));
	var AcceptUserIdBox = $HUI.combobox('#AcceptUserId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=array&Params=' + AcceptUserIdParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	/*
	$('#AcceptUserId').lookup({
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetDeptUser',
			Params: AcceptUserIdParams,
			rows: 99999
		}
	});
	*/
	var SourceOfFundParams = JSON.stringify(addSessionParams());
	var SourceOfFundBox = $HUI.combobox('#SourceOfFund', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSourceOfFund&ResultSetType=array&Params=' + SourceOfFundParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	/*
	$('#SourceOfFund').lookup({
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetSourceOfFund',
			Params: SourceOfFundParams,
			rows: 99999
		}
	});*/

	function SetFieldDisabled(bool) {
		$('#RecLoc').combobox(bool);
		$('#Vendor').combobox(bool);
		$('#StkGrpId').combobox(bool);
	}
	function CheckDataBeforeSave() {
		if (!InGdRecGrid.endEditing()) {
			return false;
		}
		var ParamsObj = GetParamsObj();
		// 判断入库单是否已审批
		var CmpFlag = ParamsObj.Complete;
		if (CmpFlag == 'Y') {
			$UI.msg('alert', '入库单已完成不可修改!');
			return false;
		}
		// 判断入库部门和供货商是否为空
		var phaLoc = ParamsObj.RecLoc;
		if (isEmpty(phaLoc)) {
			$UI.msg('alert', '请选择入库科室!');
			return false;
		}
		var Vendor = ParamsObj.Vendor;
		if (isEmpty(Vendor)) {
			$UI.msg('alert', '请选择供应商!');
			return false;
		}
		var PurUserId = ParamsObj.PurchaseUser;
		if ((isEmpty(PurUserId)) & (IngrParamObj.PurchaserNotNull == 'Y')) {
			$UI.msg('alert', '采购员不能为空!');
			return false;
		}
		var IngrTypeId = ParamsObj.IngrTypeId;
		if ((isEmpty(IngrTypeId)) & (IngrParamObj.ImpTypeNotNull == 'Y')) {
			$UI.msg('alert', '入库类型不能为空!');
			return false;
		}
		var ReqLoc = ParamsObj.ReqLocId;
		if (phaLoc == ReqLoc) {
			$UI.msg('alert', '接收科室不允许与入库科室相同!');
			return false;
		}
		// 1.判断入库物资是否为空
		var RowsData = InGdRecGrid.getRows();
		// 有效行数
		var count = 0;
		for (var i = 0; i < RowsData.length; i++) {
			var item = RowsData[i].IncId;
			if (!isEmpty(item)) {
				count++;
			}
		}
		if (RowsData.length <= 0 || count <= 0) {
			$UI.msg('alert', '请输入入库明细!');
			return false;
		}
	
		var InStkTkParamObj = GetAppPropValue('DHCSTINSTKTKM');
		if (InStkTkParamObj.AllowBusiness != 'Y') {
			var IfExistInStkTk = tkMakeServerCall('web.DHCSTMHUI.INStkTk', 'CheckInStkTkByLoc', phaLoc);
			if (IfExistInStkTk == 'Y') {
				$UI.msg('alert', '存在未完成的盘点单不允许保存!');
				return false;
			}
		}
		for (var i = 0; i < RowsData.length; i++) {
			var row = i + 1;
			var sp = RowsData[i].Sp;
			var IncId = RowsData[i].IncId;
			if (isEmpty(IncId)) {
				continue;
				// $UI.msg('alert', '第' + row + '行为无效明细!');
				// return false;
			}
			var Incidesc = RowsData[i].IncDesc;
			var qty = RowsData[i].RecQty;
			var rp = RowsData[i].Rp;
			var ExpDate = RowsData[i].ExpDate;
			var ExpReq = RowsData[i].ExpReq;
			var BatchNo = RowsData[i].BatchNo;
			var BatchReq = RowsData[i].BatchReq;
			// var ManfId=RowsData[i].ManfId;
			var InPoQty = RowsData[i].InPoQty;
			var ProduceDate = RowsData[i].ProduceDate;
			var NowDate = DateFormatter(new Date());
			if (sp < 0 || rp < 0) {
				$UI.msg('alert', '第' + row + '行' + Incidesc + '售价或进价不能小于零!');
				return false;
			}
			if (sp == 0 || rp == 0) {
				if (!confirm('第' + row + '行' + Incidesc + '售价或进价为零,是否继续?')) {
					return false;
				}
			}
			if (qty == null || qty <= 0) {
				$UI.msg('alert', '第' + row + '行' + Incidesc + '数量不能小于或等于0!');
				return false;
			}
			if ((isEmpty(BatchNo)) && (BatchReq == 'R')) {
				$UI.msg('alert', '第' + row + '行批号不能为空');
				return false;
			}
			if ((isEmpty(ExpDate)) && (ExpReq == 'R')) {
				$UI.msg('alert', '第' + row + '行有效期不能为空');
				return false;
			}
			if ((!isEmpty(BatchNo)) && (BatchReq == 'N')) {
				$UI.msg('alert', '第' + row + '行批号不允许录入');
				return false;
			}
			if ((!isEmpty(ExpDate)) && (ExpReq == 'N')) {
				$UI.msg('alert', '第' + row + '行有效期不允许录入');
				return false;
			}
			if (!isEmpty(ExpDate)) {
				if (compareDate(NowDate, ExpDate)) {
					$UI.msg('alert', '第' + row + '行有效期不能早于当前日期');
					return false;
				} else {
					var ExpDateMsg = ExpDateValidator(ExpDate, IncId);
					if (!isEmpty(ExpDateMsg)) {
						$UI.msg('alert', '第' + row + '行' + ExpDateMsg);
					}
				}
			}
			if ((!isEmpty(ProduceDate)) && (compareDate(ProduceDate, NowDate))) {
				$UI.msg('alert', '第' + row + '行生产日期不能晚于当前日期');
				return false;
			}
			/*
			if ((IngrParamObj.ManfNotNull != "Y") && (isEmpty(ManfId))) {
				$UI.msg('alert', "入库生产厂家不能为空!");
				return false;
			}
			*/
			if ((IngrParamObj.RecQtyExceedOrderAllowed != 'Y') && (InPoQty != '') && (Number(qty) > Number(InPoQty))) {
				$UI.msg('alert', '入库数量不能大于订购数量!');
				return false;
			}
		}
		return true;
	}
	function SaveIngrInfo() {
		var IsChange = $UI.isChangeBlock('#MainConditions');
		var DetailObj = InGdRecGrid.getChangesData('IncId');
		if (DetailObj === false) {
			return false;
		} else if ((DetailObj.length == 0) && IsChange == false) {
			$UI.msg('alert', '无需要保存的明细!');
			return false;
		} else {
			var DetailObj = InGdRecGrid.getRowsData('IncId');
		}
		var MainObj = GetParamsObj();
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
				var Ingrid = jsonData.rowid;
				Select(Ingrid);
				if (IngrParamObj.AutoPrintAfterSave == 'Y') {
					PrintRec(Ingrid, 'Y');
				}
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	function SaveCopyDetail() {
		InGdRecGrid.endEditing();
		var DetailObj = InGdRecGrid.getChecked();
		if (isEmpty(DetailObj)) {
			$UI.msg('alert', '请选择对应的明细!');
			return;
		}
		var RowLength = DetailObj.length;
		for (var i = 0; i < RowLength; i++) {
			var Detail = DetailObj[i];
			var IncId = Detail.IncId;
			if (isEmpty(IncId)) continue;
			var rowObj = {
				IncId: Detail.IncId,
				IncCode: Detail.IncCode,
				IncDesc: Detail.IncDesc,
				RecQty: Detail.RecQty,
				Spec: Detail.Spec,
				Model: Detail.Model,
				SpecDesc: Detail.SpecDesc,
				HVFlag: Detail.HVFlag,
				ManfId: Detail.ManfId,
				Manf: Detail.Manf,
				BatchNo: Detail.BatchNo,
				ExpDate: Detail.ExpDate,
				ProduceDate: Detail.ProduceDate,
				IngrUomId: Detail.IngrUomId,
				IngrUom: Detail.IngrUom,
				Rp: Detail.Rp,
				Sp: Detail.Sp,
				Marginnow: Detail.Marginnow,
				NewSp: Detail.NewSp,
				InvNo: Detail.InvNo,
				InvMoney: Detail.InvMoney,
				InvCode: Detail.InvCode,
				InvDate: Detail.InvDate,
				IncscDesc: Detail.IncscDesc,
				MatInsuCode: Detail.MatInsuCode,
				MatInsuDesc: Detail.MatInsuDesc,
				Remarks: Detail.Remarks,
				GrpDesc: Detail.GrpDesc,
				MtDesc: Detail.MtDesc,
				MtDr: Detail.MtDr,
				BUomId: Detail.BUomId,
				BatchReq: Detail.BatchReq,
				ExpReq: Detail.ExpReq,
				AdmNo: Detail.AdmNo,
				AdmExpdate: Detail.AdmExpdate,
				RpAmt: Detail.RpAmt,
				SpAmt: Detail.SpAmt
			};
			var rowData = $.extend({}, rowObj);
			var EditRowIndex = 0;
			var length = InGdRecGrid.getRows().length;
			if (length > 0) {
				EditRowIndex = length;
			}
			InGdRecGrid.insertRow({
				index: EditRowIndex,
				row: rowData
			});
		}
	}
	var IngrClear = function() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(InGdRecGrid);
		$('#File').filebox('clear');
		ScgTipFlag = '';
		SetDefaValues();
	};
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			var ChangeDetailObj = InGdRecGrid.getChangesData();
			if (ChangeDetailObj.length > 0) {
				$UI.confirm('数据已修改是否放弃保存！', 'warning', '', IngrClear, '', '', '警告', false);
			} else {
				IngrClear();
			}
		}
	});
	$UI.linkbutton('#DelBT', {
		onClick: function() {
			$UI.confirm('确定要删除吗?', '', '', DelIngr);
		}
	});
	function DelIngr() {
		var Rowid = $('#IngrId').val();
		if (isEmpty(Rowid)) {
			$UI.msg('alert', '入库单不存在!');
			return false;
		}
		if ($HUI.checkbox('#Complete').getValue()) {
			$UI.msg('alert', '入库单已完成不能删除!');
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
			var ChangeDetailObj = InGdRecGrid.getChangesData();
			if (ChangeDetailObj.length > 0) {
				$UI.confirm('数据已修改是否放弃保存！', 'warning', '', MakeComplete, '', '', '警告', false);
			} else {
				MakeComplete();
			}
		}
	});
	function MakeComplete() {
		var Rowid = $('#IngrId').val();
		if (isEmpty(Rowid)) {
			$UI.msg('alert', '入库单不存在!');
			return false;
		}
		if ($HUI.checkbox('#Complete').getValue()) {
			$UI.msg('alert', '入库单已完成!');
			return false;
		}
		if (CheckDataBeforeSave() == false) {
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
					PrintRec(Rowid, 'Y');
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
			$UI.msg('alert', '入库单不存在!');
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
				$UI.msg('success', jsonData.msg);
				Select(Rowid);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			var Rowid = $('#IngrId').val();
			if (isEmpty(Rowid)) {
				$UI.msg('alert', '没有需要打印的信息!');
				return false;
			}
			if (($HUI.checkbox('#Complete').getValue() == false) && (IngrParamObj.PrintNoComplete == 'N')) {
				$UI.msg('alert', '不允许打印未完成的入库单!');
				return false;
			}
			PrintRec(Rowid);
		}
	});
	function ImpFromTxtFN() {}
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
			$('#InGdRecGrid').datagrid('loadData', json);
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
			var InciCode = result[i].IncCode;
			var Manf = '';	// var Manf= result[i].Manf;
			var IngrUom = result[i].IngrUom;
			var Rp = result[i].Rp;
			var SpData = result[i].Sp; // 加售价
			var Hospital = result[i].Hospital;
			var ExpDate = result[i].ExpDate;
			if ((ExpDate != '') && (!CheckDateForm(ExpDate, dateFormat))) {
				$UI.msg('alert', '第' + (i + 1) + '行效期格式不正确!');
				hideMask();
				return;
			}
			var Str = tkMakeServerCall('web.DHCSTMHUI.DHCINGdRec', 'GetInciMsg', InciCode, Manf, IngrUom, Hospital);
			if (isEmpty(Str)) {
				$UI.msg('alert', '第' + (i + 1) + '行物资相关信息不存在!');
				hideMask();
				return;
			}
			result[i].IncId = Str.split('^')[0];
			result[i].ManfId = Str.split('^')[1];
			result[i].Manf = Str.split('^')[5];
			result[i].IngrUomId = Str.split('^')[2];
			result[i].Spec = Str.split('^')[3];
			result[i].Model = Str.split('^')[4];
			var Sp = tkMakeServerCall('web.DHCSTMHUI.DHCINGdRec', 'GetSpForRec', result[i].IncId, result[i].IngrUomId, Rp, SessionParams);
			result[i].Sp = Sp;
			result[i].NewSp = Sp;
			if (isEmpty(result[i].IncId)) {
				$UI.msg('alert', '第' + (i + 1) + '行物资代码相关信息不存在!');
				hideMask();
				return;
			}
		}
		jsonData.rows = result;
		jsonData.total = result.length;
		return jsonData;
	}
	function ExportExcel() {
		window.open('../scripts/dhcstmhisui/InGdRec/入库单导入模板.xls', '_blank');
	}
	$UI.linkbutton('#ImportTxt', {
		onClick: function() {
			ImpFromTxtFN();
		}
	});
	$('#File').filebox({
		prompt: '请选择要导入的Excel',
		accept: 'application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
	});
	$UI.linkbutton('#ReadBT', {
		onClick: function() {
			ImportExcelFN();
		}
	});
	$UI.linkbutton('#ImportInpo', {
		onClick: function() {
			ImpByPoFN(Select);
		}
	});
	$UI.linkbutton('#ImportSCI', {
		onClick: function() {
			if (SerUseObj.ECS == 'Y') {
				ImpByECSPoFN(Select);
			} else if (SerUseObj.SCI == 'Y') {
				ImpBySciPoFN(Select);
			}
		}
	});
	$UI.linkbutton('#DownExcelTemplet', {
		onClick: function() {
			ExportExcel();
		}
	});
	$UI.linkbutton('#VenEvaluateBT', {
		onClick: function() {}
	});
	$UI.linkbutton('#RecImgBT', {
		onClick: function() {}
	});
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			DrugImportGrSearch(Select);
		}
	});
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			if (CheckDataBeforeSave() == true) {
				SaveIngrInfo();
			}
		}
	});
	$UI.linkbutton('#CopyBT', {
		onClick: function() {
			SaveCopyDetail();
		}
	});
	var Select = function(RecRowid) {
		$UI.clearBlock('#MainConditions');
		$UI.clear(InGdRecGrid);
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			MethodName: 'Select',
			Ingr: RecRowid
		}, function(jsonData) {
			$UI.fillBlock('#MainConditions', jsonData);
			SetFieldDisabled('disable');
			if (IngrParamObj.UpdateVendor == 'Y' && !$HUI.checkbox('#Complete').getValue())	$('#Vendor').combobox('enable');
			if ($HUI.checkbox('#Complete').getValue()) {
				ChangeButtonEnable({
					'#SaveBT': false,
					'#DelBT': false,
					'#ComBT': false,
					'#CanComBT': true,
					'#PrintBT': true
				});
			} else {
				ChangeButtonEnable({
					'#SaveBT': true,
					'#DelBT': true,
					'#ComBT': true,
					'#CanComBT': false,
					'#PrintBT': true
				});
			}
		});
		InGdRecGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
			QueryName: 'QueryDetail',
			query2JsonStrict: 1,
			Parref: RecRowid,
			rows: 99999,
			totalFooter: '"IncCode":"合计"',
			totalFields: 'RpAmt,SpAmt'
		});
	};
	$('#SxNo').bind('keydown', function(event) {
		if (event.keyCode == 13) {
			var SxNo = $(this).val();
			if (isEmpty(SxNo)) {
				return;
			}
			try {
				var SxNoObj = eval('(' + SxNo + ')');
				SxNo = SxNoObj['text'];
				if (!isEmpty(SxNo)) {
					$(this).val(SxNo);
				}
			} catch (e) {}
			SaveSCIPoIngrInfo();
		}
	});
	function SaveSCIPoIngrInfo() {
		var ParamsObj = GetParamsObj();
		var RecLoc = ParamsObj.RecLoc;
		var SxNo = ParamsObj.SxNo;
		if (SerUseObj.ECS == 'Y') {
			$.cm({
				ClassName: 'web.DHCSTMHUI.ServiceForECS',
				MethodName: 'CreateIngrBySxNo',
				BarCode: SxNo,
				LocId: RecLoc,
				UserId: gUserId,
				HospId: gHospId
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					var IngrRowid = jsonData.rowid;
					Select(IngrRowid);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		} else if (SerUseObj.SCI == 'Y') {
			$.cm({
				ClassName: 'web.DHCSTMHUI.ServiceForSCI',
				MethodName: 'CreateIngrBySciInPo',
				BarCode: SxNo,
				LocId: RecLoc,
				UserId: gUserId
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					var IngrRowid = jsonData.rowid;
					Select(IngrRowid);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	}
	var addOneRow = {
		text: '新增',
		iconCls: 'icon-add',
		handler: function() {
			if (!InGdRecGrid.endEditing()) {
				return;
			}
			var AllRows = InGdRecGrid.getRows();
			var LastRowIndex = InGdRecGrid.editIndex;
			var Row = AllRows[LastRowIndex];
			var DefaData = {};
			if ((!isEmpty(AllRows)) && (!isEmpty(Row))) {
				if (IngrParamObj.CompareNamePrice == 'Y') { // 同上次入库判断是否改价;改名称;
					var Inci = Row.IncId;
					var Rp = Row.Rp;
					var Incidesc = Row.IncDesc;
					var CompareNamePrice = tkMakeServerCall('web.DHCSTMHUI.DHCINGdRec', 'CheckNamePrice', Inci, Rp);
					if (CompareNamePrice == -1) {
						$UI.msg('alert', Incidesc + '的名称已修改!');
					}
					if (CompareNamePrice == -2) {
						$UI.msg('alert', Incidesc + '的进价已调整!');
					}
				}
				if (IngrParamObj.DefaInvNo == 'Y') {
					DefaData = {
						InvNo: Row['InvNo'],
						InvCode: Row['InvCode'],
						InvDate: Row['InvDate']
					};
				}
			} else if (!isEmpty(AllRows) && isEmpty(Row)) {
				// 如果没有选择的行,则使用最后一行
				var LastRow = AllRows[AllRows.length - 1];
				if (IngrParamObj.DefaInvNo == 'Y') {
					var DefaData = {
						InvNo: LastRow['InvNo'],
						InvCode: LastRow['InvCode'],
						InvDate: LastRow['InvDate']
					};
				}
			}
			InGdRecGrid.commonAddRow(DefaData);
		}
	};
	var deleteOneRow = {
		text: '删除',
		iconCls: 'icon-cancel',
		handler: function() {
			if (delDetail()) {
				InGdRecGrid.commonDeleteRow();
			}
		}
	};
	var delDetail = function() {
		if ($HUI.checkbox('#Complete').getValue()) {
			$UI.msg('alert', '入库单已完成!');
			return false;
		}
		if (IngrParamObj.MakeByPoOnly == 'Y') {
			$UI.msg('alert', '入库单需和订单保持一致,不能删除!');
			return false;
		}
		return true;
	};
	var HandlerParams = function() {
		var Scg = $('#StkGrpId').combotree('getValue');
		var LocDr = '';
		var Vendor = '';
		if (IngrParamObj.PbVendorFilter == 'Y') {
			Vendor = $('#Vendor').combo('getValue');
		}
		var Obj = {
			StkGrpRowId: Scg,
			StkGrpType: 'M',
			Locdr: LocDr,
			NotUseFlag: 'N',
			QtyFlag: '0',
			ToLoc: '',
			ReqModeLimited: '',
			NoLocReq: '',
			Vendor: Vendor,
			HV: 'N'
		};
		return Obj;
	};

	var SelectRow = function(row) {
		var HVFlag = row.HvFlag;
		var InciDr = row.InciDr;
		var Manfdr = row.Manfdr;
		var VendorId = $('#Vendor').combo('getValue');
		var InciDesc = row.InciDesc;
		var InciCode = row.InciCode;
		if ((UseItmTrack) && (HVFlag == 'Y')) {
			$UI.msg('alert', '高值材料,请到高值入库制单界面根据条码入库!');
			return false;
		}
		// 阳光采购 区分试剂 物资单据
		var SunPurPlan = CommParObj.SunPurPlan; // 参数设置 公共
		if (SunPurPlan == '四川省') {
			var DetailObj = InGdRecGrid.getRows();
			var FirstMRFlag = '';
			if (DetailObj.length > 1) {
				var FirstRow = InGdRecGrid.getRows()[0];
				var FirstMRFlag = tkMakeServerCall('web.DHCSTMHUI.ServiceForSCYGCG', 'GetInciFlag', FirstRow.IncId);
			}
			var CurentInciFlag = tkMakeServerCall('web.DHCSTMHUI.ServiceForSCYGCG', 'GetInciFlag', InciDr);
			if ((FirstMRFlag != '') && (CurentInciFlag != '') && (CurentInciFlag != FirstMRFlag)) {
				$UI.msg('alert', '请将试剂 物资 分开入库!');
				return false;
			}
		}
		
		var Params = JSON.stringify(sessionObj);
		var ArrData = $.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			MethodName: 'GetItmInfo',
			IncId: InciDr,
			Params: Params
		}, false);
		var Sp = ArrData.Sp;
		// 申请科室赋值
		var ReqLocId = $('#ReqLocId').combobox('getValue');
		var ReqLocDesc = $('#ReqLocId').combobox('getText');
		var tmpIngrUomId = '';
		var tmpIngrUom = '';
		var tmpRp = '';
		var tmpSp = '';
		var tmpNewSp = '';
		var tmpMarginnow = '';
		if (IngrParamObj.DefaUom == 1) {
			tmpIngrUomId = ArrData.BUomId;
			tmpIngrUom = ArrData.BUomDesc;
			tmpRp = ArrData.BRp;
			tmpSp = ArrData.BSp;
			tmpNewSp = ArrData.BSp;
		} else {
			tmpIngrUomId = ArrData.PurUomId;
			tmpIngrUom = ArrData.PurUomDesc;
			tmpRp = ArrData.Rp;
			tmpSp = ArrData.Sp;
			tmpNewSp = ArrData.Sp;
		}
		var GiftFlag = $HUI.checkbox('#GiftFlag').getValue();
		if (GiftFlag == true) {
			tmpRp = 0;
		}
		// / 计算加成率
		if ((tmpSp != 0) && (tmpRp != 0)) {
			var margin = accSub(accDiv(tmpSp, tmpRp), 1);
			tmpMarginnow = margin.toFixed(3);
		}
		var InvNo = '';
		var InvCode = '';
		var InvDate = '';
		if (IngrParamObj.DefaInvNo == 'Y') {
			var RowsData = InGdRecGrid.getRows();
			var n = RowsData.length;
			if (n > 1) {
				InvNo = RowsData[n - 2].InvNo;
				InvCode = RowsData[n - 2].InvCode;
				InvDate = RowsData[n - 2].InvDate;
			}
		}
		InGdRecGrid.updateRow({
			index: InGdRecGrid.editIndex,
			row: {
				IncId: InciDr,
				IncCode: ArrData.InciCode,
				IncDesc: ArrData.InciDesc,
				Spec: ArrData.Spec,
				Model: ArrData.Model,
				HVFlag: ArrData.HVFlag,
				ManfId: ArrData.ManfId,
				Manf: ArrData.ManfDesc,
				BatchNo: row.BatchNo || ArrData.BatNo,
				ExpDate: row.ExpDate || ArrData.ExpDate,
				QualityNo: '',
				MtDesc: ArrData.MtDesc,
				PubDesc: ArrData.PbDesc,
				Remarks: row.Remarks,
				BUomId: ArrData.BUomId,
				ConFacPur: ArrData.ConFac,
				MtDr: ArrData.MtDr,
				SterilizedNo: '',
				InPoQty: '',
				BatchReq: ArrData.BatchReq,
				ExpReq: ArrData.ExpReq,
				BarCode: ArrData.BarCodes,
				AdmNo: ArrData.CertNo,
				AdmExpdate: ArrData.CertExpDate,
				SpecDesc: '',
				IngrUomId: tmpIngrUomId,
				IngrUom: tmpIngrUom,
				Rp: tmpRp,
				Sp: tmpSp,
				NewSp: tmpNewSp,
				// reqLocId: ReqLocId,
				// reqLocDesc: ReqLocDesc,
				IncscDesc: ArrData.IncscDesc,
				GrpDesc: ArrData.GrpDesc,
				InvNo: InvNo,
				InvCode: InvCode,
				InvDate: InvDate,
				Marginnow: tmpMarginnow,
				MatInsuCode: ArrData.MatInsuCode,
				MatInsuDesc: ArrData.MatInsuDesc
			}
		});
		setTimeout(function() {
			InGdRecGrid.refreshRow();
			InGdRecGrid.startEditingNext('IncDesc');
		}, 50);
	};

	var InGdRecCm = [[
		{
			field: 'check',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 100,
			saveCol: true,
			hidden: true
		}, {
			title: '物资RowId',
			field: 'IncId',
			width: 100,
			saveCol: true,
			hidden: true
		}, {
			title: '物资代码',
			field: 'IncCode',
			width: 100,
			saveCol: true
		}, {
			title: '物资名称',
			field: 'IncDesc',
			width: 230,
			saveCol: true,
			editor: InciEditor(HandlerParams, SelectRow)
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '型号',
			field: 'Model',
			width: 100
		}, {
			title: '具体规格',
			field: 'SpecDesc',
			width: 100,
			saveCol: CodeMainParamObj.UseSpecList == 'Y' ? true : false,
			editable: false,
			formatter: CommonFormatter(SpecDescbox, 'SpecDesc', 'SpecDesc'),
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true,
			editor: (CodeMainParamObj.UseSpecList == 'Y' ? false : true) ? null : SpecDescbox
		}, {
			title: '高值标志',
			field: 'HVFlag',
			width: 80,
			hidden: true
		}, {
			title: '生产厂家RowId',
			field: 'ManfId',
			width: 150,
			saveCol: true,
			hidden: true/*,
			formatter: CommonFormatter(PhManufacturerBox, 'ManfId', 'Manf'),
			editor: PhManufacturerBox*/
		}, {
			title: '生产厂家',
			field: 'Manf',
			width: 150
		}, {
			title: '批号',
			field: 'BatchNo',
			width: 90,
			saveCol: true,
			editor: {
				type: 'text'
			}
		}, {
			title: '有效期',
			field: 'ExpDate',
			width: 120,
			saveCol: true,
			editor: {
				type: 'datebox'
			}
		}, {
			title: '生产日期',
			field: 'ProduceDate',
			width: 120,
			saveCol: true,
			editor: {
				type: 'datebox'
			},
			hidden: true
		}, {
			title: '单位',
			field: 'IngrUomId',
			width: 70,
			saveCol: true,
			formatter: CommonFormatter(UomCombox, 'IngrUomId', 'IngrUom'),
			editor: UomCombox
		}, {
			title: '数量',
			field: 'RecQty',
			width: 80,
			align: 'right',
			saveCol: true,
			necessary: true,
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					tipPosition: 'bottom',
					min: 0,
					precision: GetFmtNum('FmtQTY')
				}
			},
			funWhileJump: function(target) {
				var RecQty = target.val();
				var Rp = target.parents('td[field]').siblings('td[field="Rp"]').find('input').val();
				var RpAmt = accMul(Rp, RecQty);
				var RowData = InGdRecGrid.getRows()[InGdRecGrid.editIndex];
				RowData['RpAmt'] = RpAmt;
				setTimeout(function() {
					InGdRecGrid.refreshRow();
				}, 0);
			}
		}, {
			title: '进价',
			field: 'Rp',
			width: 60,
			align: 'right',
			saveCol: true,
			necessary: true,
			editor: IngrParamObj.AllowEditRp == 'N' ? null : {
				type: 'numberbox',
				options: {
					min: 0,
					precision: GetFmtNum('FmtRP')
				}
			},
			funWhileJump: function(target) {
				var Rp = target.val();
				var row = InGdRecGrid.getRows()[InGdRecGrid.editIndex];
				var RecQty = row.RecQty;
				var IncId = row.IncId;
				var UomId = row.IngrUomId;
				var sp = tkMakeServerCall('web.DHCSTMHUI.DHCINGdRec', 'GetSpForRec', IncId, UomId, Rp, SessionParams);
				// 验证加成率
				var ChargeFlag = tkMakeServerCall('web.DHCSTMHUI.Common.DrugInfoCommon', 'GetChargeFlag', IncId);
				var margin = 0;
				if ((Rp != 0) && (ChargeFlag == 'Y')) {
					margin = accSub(accDiv(sp, Rp), 1);
					if ((IngrParamObj.MarginWarning != 0) && ((margin > IngrParamObj.MarginWarning) || (margin < 0))) {
						$UI.msg('alert', '加成率超出限定范围!');
						return false;
					}
				}
				var RpAmt = accMul(Rp, RecQty);
				var RowData = InGdRecGrid.getRows()[InGdRecGrid.editIndex];
				RowData['RpAmt'] = RpAmt;
				RowData['Sp'] = sp;
				RowData['NewSp'] = sp;
				RowData['Marginnow'] = margin.toFixed(3);
				setTimeout(function() {
					InGdRecGrid.refreshRow();
				}, 0);
			}
		}, {
			title: '售价',
			field: 'Sp',
			align: 'right',
			width: 60,
			saveCol: true
		}, {
			title: '当前加成',
			field: 'Marginnow',
			align: 'right',
			width: 80
		}, {
			title: '入库售价',
			field: 'NewSp',
			width: 80,
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
			title: '进价金额',
			field: 'RpAmt',
			align: 'right',
			width: 100,
			saveCol: IngrParamObj.AllowEditRpAmt == 'N' ? false : true,
			necessary: IngrParamObj.AllowEditRpAmt == 'N' ? false : true,
			editor: IngrParamObj.AllowEditRpAmt == 'N' ? null : {
				type: 'numberbox',
				options: {
					min: 0,
					precision: GetFmtNum('FmtRA')
				}
			}
		}, {
			title: '售价金额',
			field: 'SpAmt',
			align: 'right',
			width: 100
		}, {
			title: '发票代码',
			field: 'InvCode',
			width: 80,
			saveCol: true,
			editor: {
				type: 'text'
			}
		}, {
			title: '发票号',
			field: 'InvNo',
			width: 80,
			saveCol: true,
			editor: {
				type: 'text'
			}
		}, {
			title: '发票金额',
			field: 'InvMoney',
			align: 'right',
			width: 80,
			saveCol: true
		}, {
			title: '发票日期',
			field: 'InvDate',
			width: 120,
			saveCol: true,
			editor: {
				type: 'datebox'
			}
		}, {
			title: '质检单号',
			field: 'QualityNo',
			width: 90,
			saveCol: true,
			hidden: true,
			editor: {
				type: 'text'
			}
		}, {
			title: '随行单号',
			field: 'SxNo',
			width: 90,
			saveCol: true,
			hidden: true,
			editor: {
				type: 'text'
			}
		}, {
			title: 'MtDr',
			field: 'MtDr',
			width: 80,
			saveCol: true,
			hidden: true
		}, {
			title: '定价类型',
			field: 'MtDesc',
			hidden: true,
			width: 180
		}, {
			title: '招标轮次',
			field: 'PubDesc',
			width: 80,
			hidden: true
		}, {
			title: '国家医保编码',
			field: 'MatInsuCode',
			width: 160
		}, {
			title: '国家医保名称',
			field: 'MatInsuDesc',
			width: 160
		}, {
			title: '备注',
			field: 'Remarks',
			width: 160,
			saveCol: true,
			editor: {
				type: 'text'
			}
		}, {
			title: 'BUomId',
			field: 'BUomId',
			width: 100,
			hidden: true
		}, {
			title: 'ConFacPur',
			field: 'ConFacPur',
			width: 100,
			hidden: true
		}, {
			title: '灭菌批号',
			field: 'SterilizedNo',
			width: 90,
			saveCol: true,
			hidden: true,
			editor: {
				type: 'text'
			}
		}, {
			title: '订购数量',
			field: 'InPoQty',
			width: 80,
			align: 'right',
			hidden: true
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
			title: '物资条码',
			field: 'BarCode',
			jump: false,
			width: 180,
			hidden: true,
			editor: {
				type: 'text'
			}
		}, {
			title: '注册证号',
			field: 'AdmNo',
			width: 200,
			saveCol: true,
			editable: false,
			formatter: CommonFormatter(RegCertBox, 'AdmNo', 'AdmNo'),
			editor: RegCertBox
		}, {
			title: '注册证有效期',
			field: 'AdmExpdate',
			width: 120,
			saveCol: true,
			editor: {
				type: 'datebox'
			}
		}, {
			title: '请求科室',
			field: 'reqLocId',
			width: 120,
			saveCol: true,
			hidden: true,
			formatter: CommonFormatter(ReqLocCombox, 'reqLocId', 'reqLocDesc'),
			editor: ReqLocCombox
		}, {
			title: '单品税额',
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
			},
			hidden: true
		}, {
			title: '单品总税额',
			field: 'TaxAmt',
			align: 'right',
			width: 100,
			hidden: true
		}, {
			title: 'OrderDetailSubId',
			field: 'OrderDetailSubId',
			width: 80,
			saveCol: true,
			hidden: true
		}, {
			title: '订单明细id',
			field: 'Inpoi',
			width: 80,
			saveCol: true,
			hidden: true
		}, {
			title: '类组',
			field: 'GrpDesc',
			width: 120,
			hidden: true
		}, {
			title: '库存分类',
			field: 'IncscDesc',
			width: 120,
			hidden: true
		}
	]];
	var InGdRecGrid = $UI.datagrid('#InGdRecGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
			QueryName: 'QueryDetail',
			query2JsonStrict: 1,
			rows: 99999,
			totalFooter: '"IncCode":"合计"',
			totalFields: 'RpAmt,SpAmt'
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
			MethodName: 'Delete'
		},
		singleSelect: false,
		columns: InGdRecCm,
		checkField: 'IncId',
		showBar: true,
		showFooter: true,
		remoteSort: false,
		toolbar: [addOneRow, deleteOneRow],
		pagination: false,
		onClickRow: function(index, row) {
			InGdRecGrid.commonClickRow(index, row);
		},
		onBeforeEdit: function(index, row) {
			if ($HUI.checkbox('#Complete').getValue()) {
				$UI.msg('alert', '入库单已完成!');
				return false;
			}
		},
		beforeAddFn: function() {
			if (IngrParamObj.NewSpAsSp !== 'Y') {
				InGdRecGrid.hideColumn('NewSp');
			}
			var ParamsObj = GetParamsObj();
			if ($HUI.checkbox('#Complete').getValue()) {
				$UI.msg('alert', '入库单已完成!');
				return false;
			}
			if (isEmpty(ParamsObj.RecLoc)) {
				$UI.msg('alert', '入库科室不能为空!');
				return false;
			}
			if (isEmpty(ParamsObj.Vendor)) {
				$UI.msg('alert', '供应商不能为空!');
				return false;
			}
			if ((IngrParamObj.ImpTypeNotNull == 'Y') && (isEmpty(ParamsObj.IngrTypeId))) {
				$UI.msg('alert', '入库类型不能为空!!');
				return false;
			}
			if (IngrParamObj.MakeByPoOnly == 'Y') {
				$UI.msg('alert', '必须依据订单入库,不能增加!');
				return false;
			}
			if ((IngrParamObj.RequiredSourceOfFund == 'Y') && (isEmpty(ParamsObj.SourceOfFund))) {
				$UI.msg('alert', '资金来源不能为空!');
				return false;
			}
			if (isEmpty(ParamsObj.StkGrpId) && isEmpty(ScgTipFlag)) {
				$UI.msg('alert', '未选择类组，请谨慎核实数据!');
				ScgTipFlag = 'Y';
			}
			SetFieldDisabled('disable');
			if (IngrParamObj.UpdateVendor == 'Y' && !$HUI.checkbox('#Complete').getValue())	$('#Vendor').combobox('enable');
		},
		onBeginEdit: function(index, row) {
			// 增加物资条码检索
			$(this).datagrid('beginEdit', index);
			var ed = $(this).datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++) {
				var e = ed[i];
				if (e.field == 'BarCode') {
					$(e.target).bind('keydown', function(event) {
						if (event.keyCode == 13) {
							var BarCode = $(this).val();
							var ParamsObj = HandlerParams();
							ParamsObj['BarCode'] = BarCode;
							var StrParam = JSON.stringify(ParamsObj);
							var InciInfoObj = $.cm({
								ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
								MethodName: 'GetPhaOrderItemInfo',
								page: 1,
								rows: 1,
								StrParam: StrParam
							}, false);
							if (InciInfoObj['total'] != 1) {
								$UI.msg('alert', '条码对应信息取值失败!');
								$(this).val('');
								$(this).focus();
								return;
							}
							SelectRow(InciInfoObj['rows'][0]);
						}
					});
				}
				if ((e.field == 'InvCode') || (e.field == 'InvNo')) {
					$(e.target).bind('keydown', function(event) {
						if (event.keyCode == 13) {
							var InvInfo = $(this).val();
							SetInvInfo(InvInfo);
						}
					});
				}
			}
		},
		onEndEdit: function(index, row, changes) {
			var Editors = $(this).datagrid('getEditors', index);
			for (var i = 0; i < Editors.length; i++) {
				var Editor = Editors[i];
				if (Editor.field == 'AdmNo') {
					var AdmNo = row.AdmNo;
					if (!isEmpty(AdmNo)) {
						$.cm({
							ClassName: 'web.DHCSTMHUI.DHCMatRegCert',
							MethodName: 'getByRegNo',
							No: AdmNo
						}, function(jsonData) {
							if (!isEmpty(jsonData.MRCManfDesc)) {
								row.AdmExpdate = jsonData.MRCValidUntil;
								row.ManfId = jsonData.MRCManfId;
								row.Manf = jsonData.MRCManfDesc;
							}
						});
					}
				}
				if (Editor.field == 'RecQty') {
					var RecQty = row.RecQty;
					var IngrUomId = row.IngrUomId;
					var ConFac = row.ConFacPur;
					var BUomId = row.BUomId;
					if (IngrUomId == BUomId) {
						if (!CheckFmtQty(ConFac, 'BUom', RecQty)) {
							InGdRecGrid.checked = false;
						}
					} else {
						if (!CheckFmtQty(ConFac, 'PUom', RecQty)) {
							InGdRecGrid.checked = false;
						}
					}
				}
			}
			if ((row.Sp == 0) && (CommParObj.BatSp == 1)) { var CalculateFlag = 'Y'; } else { var CalculateFlag = 'N'; }
			var ChangeRpAmtFlag = 'N';		// CalculateFlag是否重新计算金额，ChangeRpAmtFlag是否修改（计算进价）
			var IncId = row.IncId;
			if (isEmpty(IncId)) {
				$UI.msg('alert', '无效明细!');
				InGdRecGrid.checked = false;
				return false;
			}
			if (changes.hasOwnProperty('Rp')) {
				var rp = row.Rp;
				if (isEmpty(rp)) {
					$UI.msg('alert', '进价不能为空!');
					InGdRecGrid.checked = false;
					return false;
				} else if (rp < 0) {
					$UI.msg('alert', '进价不能小于零!');
					InGdRecGrid.checked = false;
					return false;
				} else if (rp == 0) {
					$UI.msg('alert', '进价为零,请注意核实!');
				}
				CalculateFlag = 'Y';
			}
			
			// 判断资质
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
			
			if ((isEmpty(row.InvNo)) && (IngrParamObj.InvNoNotNull == 'Y')) {
				$UI.msg('alert', '发票号不可为空!');
				InGdRecGrid.checked = false;
				return false;
			}
			
			if (changes.hasOwnProperty('RecQty')) {
				var RecQty = row.RecQty;
				if ((isEmpty(RecQty)) || (RecQty <= 0)) {
					$UI.msg('alert', '入库数量不能小于或等于0!');
					InGdRecGrid.checked = false;
					return false;
				}
				var InPoQty = row.InPoQty;
				if ((IngrParamObj.RecQtyExceedOrderAllowed != 'Y') && (InPoQty != '') && (Number(RecQty) > Number(InPoQty))) {
					$UI.msg('alert', '入库数量不能大于订购数量!');
					InGdRecGrid.checked = false;
					return false;
				}
				CalculateFlag = 'Y';
			}
			if (changes.hasOwnProperty('Tax')) {
				var Tax = row.Tax;
				var RecQty = row.RecQty;
				var TaxAmt = accMul(Tax, RecQty);
				row.TaxAmt = TaxAmt;
			}
			if (changes.hasOwnProperty('InvNo')) {
				var flag = InvNoValidator(row.InvNo, $('#IngrId').val(), row.InvCode);
				if (flag == false) {
					$UI.msg('alert', '发票号' + row.InvNo + '已存在于别的入库单!');
				}
			}
			if (changes.hasOwnProperty('NewSp')) {
				var NewSp = row.NewSp;
				if ((isEmpty(NewSp) || (NewSp < 0))) {
					$UI.msg('alert', '入库售价不能小于0!');
					InGdRecGrid.checked = false;
					return false;
				}
			}
			/*
			if (changes.hasOwnProperty('ManfId')) {
				var ManfId = row.ManfId;
				if ((IngrParamObj.ManfNotNull != "Y") && (isEmpty(ManfId))) {
					$UI.msg('alert', "入库生产厂家不能为空!");
					InGdRecGrid.checked = false;
					return false;
				}
			}*/
			if (changes.hasOwnProperty('ProduceDate')) {
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
			if (changes.hasOwnProperty('RpAmt')) {
				var RpAmt = row.RpAmt;
				if (RpAmt != '') {
					if (RpAmt < 0) {
						$UI.msg('alert', '进价金额不能小于零!');
						InGdRecGrid.checked = false;
						return false;
					}
					CalculateFlag = 'Y';
					ChangeRpAmtFlag = 'Y';
				}
			}
			if (CalculateFlag == 'Y') {
				var rp = row.Rp;
				var RpAmt = row.RpAmt;
				var Qty = row.RecQty;
				if (ChangeRpAmtFlag == 'Y') { rp = Number(RpAmt).div(Number(Qty)); }
				var UomId = row.IngrUomId;
				var sp = tkMakeServerCall('web.DHCSTMHUI.DHCINGdRec', 'GetSpForRec', IncId, UomId, rp, SessionParams);
				// 验证加成率
				var ChargeFlag = tkMakeServerCall('web.DHCSTMHUI.Common.DrugInfoCommon', 'GetChargeFlag', IncId);
				var margin = 0;
				if ((rp != 0) && (ChargeFlag == 'Y')) {
					margin = accSub(accDiv(sp, rp), 1);
					if ((IngrParamObj.MarginWarning != 0) && ((margin > IngrParamObj.MarginWarning) || (margin < 0))) {
						$UI.msg('alert', '加成率超出限定范围!');
						InGdRecGrid.checked = false;
						return false;
					}
				}
				// 计算指定行的数据
				var RealTotal = accMul(Qty, rp);
				row.Rp = rp;
				row.RpAmt = RealTotal;
				row.InvMoney = RealTotal;
				row.Sp = sp;
				row.NewSp = sp;
				row.SpAmt = accMul(Qty, sp);
				row.Marginnow = margin.toFixed(3);
				
				var Tax = row.Tax;
				if (!isEmpty(Tax)) {
					var TaxAmt = accMul(Number(Tax), Qty);
					row.TaxAmt = TaxAmt;
				}
				
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
					var Scg = $('#StkGrpId').combotree('getValue');
					var LocDr = $('#RecLoc').combo('getValue');
					var Obj = {
						Incid: row.IncId,
						Incicode: row.IncCode,
						Incidesc: row.IncDesc,
						PriorRp: PriorRp,
						PriorSp: PriorSp,
						ResultRp: ResultRp,
						ResultSp: ResultSp,
						AdjSpUomId: row.IngrUomId,
						StkGrpType: Scg,
						LocDr: LocDr
					};
					var adjPriceObj = addSessionParams(Obj);
					$UI.confirm(row.IncDesc + '价格发生变化，是否生成调价单?', '', '', SetAdjPrice, '', '', '', '', adjPriceObj);
				}
			}
			InGdRecGrid.setFooterInfo();
		},
		rowStyler: function(index, row) {
			if (row.Sp < 0) {
				return 'background-color:yellow;color:black;font-weight:bold;';
			}
		}
	});
	
	function SetInvInfo(InvInfo) {
		var InvObj = GetInvInfo(InvInfo);
		if (InvObj === false) {
			$UI.msg('alert', '请录入正确的发票信息!');
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
		
	function SetDefaValues() {
		var IngrTypeInfo = GetIngrtypeDefa();
		var IngrTypeId = IngrTypeInfo.split('^')[0];
		var IngrType = IngrTypeInfo.split('^')[1];
		var PurInfoInfo = GetPurUserDefa(gLocObj.RowId);
		var PurUserId = PurInfoInfo.split('^')[0];
		var PurUserName = PurInfoInfo.split('^')[1];
		var DefaultData = {
			RecLoc: gLocObj,
			CreateDate: DateFormatter(new Date())
		};
		$UI.fillBlock('#MainConditions', DefaultData);
		$('#IngrTypeId').combobox('setValue', IngrTypeId);
		$('#IngrTypeId').combobox('setText', IngrType);
		$('#PurchaseUser').combobox('setValue', PurUserId);
		$('#PurchaseUser').combobox('setText', PurUserName);
		$('#StkGrpId').combotree('options')['setDefaultFun']();
		SetFieldDisabled('enable');
		InGdRecGrid.setFooterInfo();
		ChangeButtonEnable({
			'#SaveBT': true,
			'#DelBT': false,
			'#ComBT': false,
			'#CanComBT': false,
			'#PrintBT': false
		});
		if ((SerUseObj.ECS == 'Y') || (SerUseObj.SCI == 'Y')) {
			$('.SCIShow').show();
		} else {
			$('.SCIShow').hide();
		}
	}
	setTimeout(SetDefaValues(), 100);
	if (!isEmpty(gIngrRowid)) {
		Select(gIngrRowid);
	}
};
$(init);
if (!FileReader.prototype.readAsBinaryString) {
	console.log('readAsBinaryString definition not found');
	FileReader.prototype.readAsBinaryString = function(fileData) {
		var binary = '';
		var pk = this;
		var reader = new FileReader();
		reader.onload = function(e) {
			var bytes = new Uint8Array(reader.result);
			var length = bytes.byteLength;
			for (var i = 0; i < length; i++) {
				var a = bytes[i];
				var b = String.fromCharCode(a);
				binary += b;
			}
			pk.content = binary;
			$(pk).trigger('onload');
		};
		reader.readAsArrayBuffer(fileData);
	};
}