/*
入库单制单
 */
var init = function () {
	//获取入库主表信息
	function GetParamsObj() {
		var ParamsObj = $UI.loopBlock('#MainConditions');
		return ParamsObj;
	}
	//Grid 列 comboxData
	var UomCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInciUom&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			mode: 'remote',
			onBeforeLoad: function (param) {
				var rows =InGdRecGrid.getRows();  
				var row = rows[InGdRecGrid.editIndex];
				if(!isEmpty(row)){
					param.Inci =row.IncId;
				}
			},
			onSelect: function (record) {
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
				if (NewUomid == BUomId) { //入库单位转换为基本单位
				var rp=row.Rp;
				var sp = row.Sp;
				var newsp = row.NewSp;
					row.Rp = Number(rp).div(Number(confac));
					row.Sp = Number(sp).div(Number(confac));
					row.NewSp = Number(newsp).div(Number(confac));
				} else { //基本单位转换为入库单位
					var rp=row.Rp;
					var sp = row.Sp;
					var newsp = row.NewSp;
					row.Rp = Number(rp).mul(Number(confac));
					row.Sp = Number(sp).mul(Number(confac));
					row.NewSp = Number(newsp).mul(Number(confac));
				}
				if (isEmpty(row.RecQty)){
					var RpAmt = 0;
					var SpAmt = 0;
					var NewSpAmt=0;
				}else{
					var RpAmt = Number(row.Rp).mul(row.RecQty);
					var SpAmt = Number(row.Sp).mul(row.RecQty);
					var NewSpAmt = Number(row.NewSp).mul(row.RecQty);
				}
				row.RpAmt = RpAmt;
				row.InvMoney = RpAmt;
				row.SpAmt = SpAmt;
				row.NewSpAmt = NewSpAmt;
				row.IngrUomId = NewUomid;
				$('#InGdRecGrid').datagrid('refreshRow', InGdRecGrid.editIndex);
			},
			onShowPanel: function () {
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
			onBeforeLoad: function (param) {
				var Select = InGdRecGrid.getSelected();
				if (!isEmpty(Select)) {
					param.Inci = Select.IncId;
				}
			}
		}
	};
	var PhManufacturerParams = JSON.stringify(addSessionParams({
				StkType: "M"
			}));
	var PhManufacturerBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params=' + PhManufacturerParams,
			valueField: 'RowId',
			textField: 'Description',
			onBeforeLoad: function (param) {
				var ParamsObj = $UI.loopBlock('#MainConditions');
				var ScgId = ParamsObj.StkGrpId;
				param.ScgId = ScgId;
			},
			onSelect: function (record) {
				var rows = InGdRecGrid.getRows();
				var row = rows[InGdRecGrid.editIndex];
				row.Manf = record.Description;
			},
			onShowPanel: function () {
				$(this).combobox('reload')
			}
		}
	};
	var reqLocParams = JSON.stringify(addSessionParams({
				Type: "All"
			}));
	var reqLocCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + reqLocParams,
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function (record) {
				var rows = InGdRecGrid.getRows();
				var row = rows[InGdRecGrid.editIndex];
				row.reqLocDesc = record.Description;
			},
			onShowPanel: function () {
				$(this).combobox('reload')
			}
		}
	};
	var RecLocParams = JSON.stringify(addSessionParams({
				Type: "Login"
			}));
	var RecLocBox = $HUI.combobox('#RecLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + RecLocParams,
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function (record) {
				var LocId = record['RowId'];
				$('#PurchaseUser').lookup('clear');
				$('#PurchaseUser').lookup('options')['queryParams']['Params'] = JSON.stringify(addSessionParams({
					LocDr: LocId,
					UseAllUserAsPur: IngrParamObj.UseAllUserAsPur
				}));
			}
		});
	var ReqLocIdParams = JSON.stringify(addSessionParams({
				Type: "All"
			}));
//	var ReqLocIdBox = $HUI.combobox('#ReqLocId', {
//			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocIdParams
//		});
	$("#ReqLocId").lookup({
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetCTLoc',
			Params: ReqLocIdParams
		}
	});
	var VendorParams = JSON.stringify(addSessionParams({
				APCType: "M",
				RcFlag: "Y"
			}));
	var VendorBox = $HUI.combobox('#Vendor', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
			valueField: 'RowId',
			textField: 'Description',
			onBeforeLoad: function (param) {
				var ParamsObj = $UI.loopBlock('#MainConditions');
				var ScgId = ParamsObj.StkGrpId;
				param.ScgId = ScgId;
			}
		});
	var IngrTypeIdParams = JSON.stringify(addSessionParams({
				Type: "IM"
			}));
//	var IngrTypeIdBox = $HUI.combobox('#IngrTypeId', {
//			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOperateType&ResultSetType=array&Params=' + IngrTypeIdParams,
//			valueField: 'RowId',
//			textField: 'Description',
//			onLoadSuccess: function () {
//				var IngrTypeId = GetIngrtypeDefa();
//				$('#IngrTypeId').combobox('select', IngrTypeId);
//			}
//		});
	$("#IngrTypeId").lookup({
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetOperateType',
			Params: IngrTypeIdParams
		}
	});
	var PurchaseUserParams = JSON.stringify(addSessionParams({
				LocDr: gLocId,
				UseAllUserAsPur: IngrParamObj.UseAllUserAsPur
			}));
//	var PurchaseUserBox = $HUI.combobox('#PurchaseUser', {
//			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocPPLUser&ResultSetType=array&Params=' + PurchaseUserParams,
//			valueField: 'RowId',
//			textField: 'Description',
//			onLoadSuccess: function(){
//				var data=$(this).combobox('getData');
//				if(data.length>0){
//					for(var i=0;i<data.length;i++){
//						if(data[i].Default=='Y'){
//							$(this).combobox('select',data[i].RowId);
//							return;
//						}
//					}
//				}
//			}
//		});
	$("#PurchaseUser").lookup({
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetLocPPLUser',
			Params: PurchaseUserParams
		}
	});
	var AcceptUserIdParams = JSON.stringify(addSessionParams({
				LocDr: ""
			}));
//	var AcceptUserIdBox = $HUI.combobox('#AcceptUserId', {
//			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=array&Params=' + AcceptUserIdParams,
//			valueField: 'RowId',
//			textField: 'Description'
//		});
	$("#AcceptUserId").lookup({
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetDeptUser',
			Params: AcceptUserIdParams
		}
	});
	var SourceOfFundParams = JSON.stringify(addSessionParams());
//	var SourceOfFundBox = $HUI.combobox('#SourceOfFund', {
//			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSourceOfFund&ResultSetType=array&Params=' + SourceOfFundParams,
//			valueField: 'RowId',
//			textField: 'Description'
//		});
	
	
	$("#SourceOfFund").lookup({
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetSourceOfFund',
			Params: SourceOfFundParams
		}
	});

	function SetFieldDisabled(bool) {
		$('#RecLoc').combobox(bool);
		$('#Vendor').combobox(bool);
		$('#StkGrpId').combobox(bool);
	}
	function CheckDataBeforeSave() {
		InGdRecGrid.endEditing();
		var ParamsObj = GetParamsObj();
		// 判断入库单是否已审批
		var CmpFlag = ParamsObj.Complete;
		if (CmpFlag == "Y") {
			$UI.msg('alert', '入库单已完成不可修改!');
			return false;
		}
		// 判断入库部门和供货商是否为空
		var phaLoc = ParamsObj.RecLoc;
		if (isEmpty(phaLoc)) {
			$UI.msg('alert', '请选择入库科室!');
			return false;
		}
		var vendor = ParamsObj.Vendor;
		if (isEmpty(vendor)) {
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
		for (var i = 0; i < RowsData.length; i++) {
			var sp = RowsData[i].Sp;
			var IncId = RowsData[i].IncId;
			if (isEmpty(IncId)) {
				$UI.msg('alert', '第' + row + '行' + Incidesc + '为无效明细!');
				return false;
			}
			var Incidesc = RowsData[i].IncDesc;
			var qty = RowsData[i].RecQty;
			var rp = RowsData[i].Rp;
			var ExpDate = RowsData[i].ExpDate;
			var ExpReq = RowsData[i].ExpReq;
			var row = i + 1;
			if ((sp <= 0) && (CommParObj.BatSp == 1)) {
				$UI.msg('alert', '第' + row + '行' + Incidesc + '售价为零或者小于零!');
				return false;
			}
			if (qty == null || qty <= 0) {
				$UI.msg('alert', '第' + row + '行' + Incidesc + '数量不能小于或等于0!');
				return false;
			}
			if (rp == null || rp < 0) {
				$UI.msg('alert', '第' + row + '行' + Incidesc + '进价不能小于0!');
				return false;
			}
			if ((!isEmpty(ExpDate)) && (ExpReq == "R")){
				var ExpDateMsg = ExpDateValidator(ExpDate, IncId);
				if(!isEmpty(ExpDateMsg)){
					$UI.msg('alert', '第' + row + '行' + ExpDateMsg );
					return false;
				}
			}
		}
		return true;
	}
	function SaveIngrInfo() {
		var MainObj = GetParamsObj();
		var Main = JSON.stringify(MainObj);
		var IsChange = $UI.isChangeBlock('#MainConditions');
		var DetailObj = InGdRecGrid.getRowsData();
		if (DetailObj === false) {
			return false;
		} else if ((DetailObj.length == 0) && IsChange == false) {
			$UI.msg('alert', '无需要保存的明细!');
			return false;
		}
		var Detail = JSON.stringify(DetailObj);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			MethodName: 'jsSave',
			MainInfo: Main,
			ListData: Detail
		}, function (jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				var Ingrid = jsonData.rowid;
				Select(Ingrid);
				if (IngrParamObj.AutoPrintAfterSave == "Y") {
					PrintRec(Ingrid, "Y");
				}
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	var IngrClear = function () {
		$UI.clearBlock('#MainConditions');
		$UI.clear(InGdRecGrid);
		$('#File').filebox("clear");
		SetDefaValues();
	}
	$UI.linkbutton('#ClearBT', {
		onClick: function () {
			var ChangeDetailObj = InGdRecGrid.getChangesData();
			if (ChangeDetailObj.length > 0) {
				$UI.confirm("数据已修改是否放弃保存！", "warning", "", IngrClear, "", "", "警告", false);
			} else {
				IngrClear();
			}
		}
	});
	$UI.linkbutton('#DelBT', {
		onClick: function () {
			$UI.confirm('确定要删除吗?', '', '', DelIngr);
		}
	});
	function DelIngr() {
		var ParamsObj = GetParamsObj();
		var Rowid = $("#IngrId").val();
		if (ParamsObj.Complete == "Y") {
			$UI.msg('alert', '入库单已完成不能删除!');
			return false;
		}
		if (isEmpty(Rowid)) {
			$UI.msg('alert', '入库单不存在!');
			return false;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			MethodName: 'Delete',
			IngrId: Rowid
		}, function (jsonData) {
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
		onClick: function () {
			var ChangeDetailObj = InGdRecGrid.getChangesData();
			if (ChangeDetailObj.length > 0) {
				$UI.confirm("数据已修改是否放弃保存！", "warning", "", MakeComplete, "", "", "警告", false);
			} else {
				MakeComplete();
			}
		}
	});
	function MakeComplete() {
		var Rowid = $("#IngrId").val();
		if (isEmpty(Rowid)) {
			$UI.msg('alert', '入库单不存在!');
			return false;
		}
		if ($HUI.checkbox("#Complete").getValue()) {
			$UI.msg('alert', '入库单已完成!');
			return false;
		}
		var RowData = InGdRecGrid.getRowsData();
		if (isEmpty(RowData) || RowData.length == 0) {
			$UI.msg('alert', '入库单无明细!');
			return false;
		}
		var Params = JSON.stringify(addSessionParams());
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			MethodName: 'jsMakeComplete',
			IngrId: Rowid,
			Params: Params
		}, function (jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				Select(Rowid);
				if ((IngrParamObj.AutoAuditAfterComp == "Y") && (IngrParamObj.AutoPrintAfterAudit == "Y")) {
					PrintRec(Rowid, "Y");
				} else if (IngrParamObj.Allowflash == '') {
					IngrClear();
				}
			} else {
				$UI.msg('error', jsonData.msg);
			}

		});
	}

	$UI.linkbutton('#CanComBT', {
		onClick: function () {
			var Rowid = $("#IngrId").val();
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
		}, function (jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				Select(Rowid);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#PrintBT', {
		onClick: function () {
			var Rowid = $("#IngrId").val();
			if (isEmpty(Rowid)) {
				$UI.msg('alert', '没有需要打印的信息!');
				return false;
			}
			if (($HUI.checkbox("#Complete").getValue() == false) && (IngrParamObj.PrintNoComplete == "N")) {
				$UI.msg('alert', '不允许打印未完成的入库单!');
				return false;
			}
			PrintRec(Rowid);
		}
	});
	function ImpFromTxtFN() {}
	function ImportExcelFN() {
		var wb;
		var filelist = $('#File').filebox("files");
		if (filelist.length == 0) {
			$UI.msg('alert', '请选择要导入的Excel!')
			return
		}
		showMask();
		var file = filelist[0];
		var reader = new FileReader();
		reader.onload = function (e) {
			if (reader.result) {
				reader.content = reader.result;
			}
			var data = e ? e.target.result : reader.content;
			wb = XLSX.read(data, {
					type: 'binary'
				});
			var json = to_json(wb);
			$("#InGdRecGrid").datagrid("loadData", json);
			hideMask();
		}
		reader.readAsBinaryString(file);
	}
	function to_json(workbook) {
		var jsonData = {};
		var result = XLSX.utils.sheet_to_json(workbook.Sheets[workbook.SheetNames[0]]);
		result = result.slice(1);
		for(var i=0;i<result.length;i++){
			var InciCode= result[i].IncCode;
			var Manf= result[i].Manf;
			var IngrUom= result[i].IngrUom;
			var Rp=result[i].Rp;
			var Hospital=result[i].Hospital;
			if (InciCode!=""){
				var Str=tkMakeServerCall("web.DHCSTMHUI.DHCINGdRec","GetInciMsg",InciCode,Manf,IngrUom,Hospital);
				result[i].IncId=Str.split("^")[0];
				result[i].ManfId=Str.split("^")[1];
				result[i].IngrUomId=Str.split("^")[2];
				var Sp = tkMakeServerCall('web.DHCSTMHUI.DHCINGdRec', 'GetSpForRec', result[i].IncId, result[i].IngrUomId, Rp, SessionParams);
				result[i].Sp=Sp;
				result[i].NewSp=Sp;
			}
		}
		jsonData.rows = result;
		jsonData.total = result.length;
		return jsonData;
	};
	function ExportExcel() {
		window.open("../scripts/dhcstmhisui/InGdRec/入库单导入模板.xls", "_blank");
	}
	$UI.linkbutton('#ImportTxt', {
		onClick: function () {
			ImpFromTxtFN();
		}
	});
	$('#File').filebox({
		buttonAlign: 'left',
		prompt: '请选择要导入的Excel',
		accept: 'application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
	});
	$UI.linkbutton('#ReadBT', {
		onClick: function () {
			$('#StkGrpId').combobox('clear');
			ImportExcelFN();
		}
	});
	$UI.linkbutton('#ImportInpo', {
		onClick: function () {
			ImpByPoFN(Select);
		}
	});
	$UI.linkbutton('#ImportSCI', {
		onClick: function () {
			ImpBySciPoFN(Select);
		}
	});
	$UI.linkbutton('#DownExcelTemplet', {
		onClick: function () {
			ExportExcel();
		}
	});
	$UI.linkbutton('#VenEvaluateBT', {
		onClick: function () {}
	});
	$UI.linkbutton('#RecImgBT', {
		onClick: function () {}
	});
	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			DrugImportGrSearch(Select);
		}
	});
	$UI.linkbutton('#SaveBT', {
		onClick: function () {
			if (CheckDataBeforeSave() == true) {
				SaveIngrInfo();
			}
		}
	});
	var Select = function (RecRowid) {
		$UI.clearBlock('#MainConditions');
		$UI.clear(InGdRecGrid);
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			MethodName: 'Select',
			Ingr: RecRowid
		}, function (jsonData) {
			$UI.fillBlock('#MainConditions', jsonData);
			SetFieldDisabled("disable");
			if ($HUI.checkbox("#Complete").getValue()) {
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
			Parref: RecRowid,
			rows:99999,
			totalFooter:'"IncCode":"合计"',
			totalFields:'RpAmt,NewSpAmt'
		});
	}
	$('#SxNo').bind('keydown', function (event) {
		if (event.keyCode == 13) {
			var SxNo = $(this).val();
			if(isEmpty(SxNo)){
				return;
			}
			try{
				var SxNoObj = eval('(' + SxNo + ')');
				SxNo = SxNoObj['text'];
				$(this).val(SxNo);
			}catch(e){}
			SaveSCIPoIngrInfo();
		}
	});
	function SaveSCIPoIngrInfo() {
		var ParamsObj = GetParamsObj();
		var RecLoc = ParamsObj.RecLoc;
		var SxNo = ParamsObj.SxNo;
		$.cm({
			ClassName: 'web.DHCSTMHUI.ServiceForSCI',
			MethodName: 'CreateIngrBySciInPo',
			BarCode: SxNo,
			LocId: RecLoc,
			UserId: gUserId
		}, function (jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				var IngrRowid = jsonData.rowid;
				Select(IngrRowid);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	var addOneRow = {
		text: '新增',
		iconCls: 'icon-add',
		handler: function () {
			var AllRows = InGdRecGrid.getRows();
			var LastRowIndex = InGdRecGrid.editIndex;
			var Row = AllRows[LastRowIndex];
			InGdRecGrid.endEditing();
			var DefaData = {};
			if ((!isEmpty(AllRows)) && (!isEmpty(Row))) {
				if (IngrParamObj.CompareNamePrice == 'Y') { //同上次入库判断是否改价;改名称;
					var Inci = Row.IncId;
					var Rp = Row.Rp;
					var Incidesc = Row.IncDesc;
					var CompareNamePrice = tkMakeServerCall("web.DHCSTMHUI.DHCINGdRec", "CheckNamePrice", Inci, Rp);
					if (CompareNamePrice == -1) {
						$UI.msg('alert', Incidesc + '的名称已修改!')
					}
					if (CompareNamePrice == -2) {
						$UI.msg('alert', Incidesc + '的进价已调整!')
					}
				}
				if (IngrParamObj.DefaInvNo == "Y") {
					var DefaData = {
						InvNo: Row['InvNo'],
						InvDate: Row['InvDate']
					};
				}
			}else if(!isEmpty(AllRows) && isEmpty(Row)){
				//如果没有选择的行,则使用最后一行
				var LastRow = AllRows[AllRows.length - 1];
				if (IngrParamObj.DefaInvNo == "Y") {
					var DefaData = {
						InvNo: LastRow['InvNo'],
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
		handler: function () {
			if (delDetail()) {
				InGdRecGrid.commonDeleteRow();
			}
		}
	};
	var delDetail = function () {
		if ($HUI.checkbox("#Complete").getValue()) {
			$UI.msg('alert', '入库单已完成!');
			return false;
		}
		if (IngrParamObj.MakeByPoOnly == 'Y') {
			$UI.msg('alert', '入库单需和订单保持一致,不能删除!');
			return false;
		}
		return true;
	};
	var HandlerParams = function () {
		var Scg = $("#StkGrpId").combotree('getValue');
		var LocDr = ""; ///$("#RecLoc").combo('getValue');
		var Vendor = "";
		if(IngrParamObj.PbVendorFilter=="Y"){
			Vendor = $("#Vendor").combo('getValue');
		}
		var Obj = {
			StkGrpRowId: Scg,
			StkGrpType: "M",
			Locdr: LocDr,
			NotUseFlag: "N",
			QtyFlag: "0",
			ToLoc: "",
			ReqModeLimited: "",
			NoLocReq: "",
			Vendor: Vendor,
			HV: "N"
		};
		return Obj;
	}

	var SelectRow = function (row) {
		var HVFlag = row.HvFlag;
		var InciDr = row.InciDr;
		var Manfdr = row.Manfdr;
		var VendorId = $("#Vendor").combo('getValue');
		var InciDesc = row.InciDesc;
		var InciCode = row.InciCode;
		if ((UseItmTrack) && (HVFlag == "Y")) {
			$UI.msg('alert', "高值材料,请到高值入库制单界面根据条码入库!");
			return false;
		}
		var CheckQualParams = JSON.stringify(addSessionParams({
					ApcvmDr: VendorId,
					Inci: InciDr,
					ManfId: Manfdr
				}));
		var CheckQualData="";
		if(CommParObj.NewQuality=="Y"){
			var CheckQualData = tkMakeServerCall('web.DHCSTMHUI.Common.UtilCommon', 'CheckNew', CheckQualParams);
		}else{
		var CheckQualData = tkMakeServerCall('web.DHCSTMHUI.Common.UtilCommon', 'Check', CheckQualParams);
		}
		if (CheckQualData != "") {
			$UI.msg('alert', InciDesc + ":" + CheckQualData);
			if (CommParObj.StopItmBussiness == 'Y') {
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
		var MaxSp = ArrData.MaxSp;
		var Sp = ArrData.Sp;
		if ((IngrParamObj.ValidateMaxSp == "Y") && (MaxSp != "") && (Number(Sp) > Number(MaxSp))) {
			$UI.msg('alert', "当前售价高于最高售价!");
			//return false;
		}

		//申请科室赋值
		var ReqLocId = $("#ReqLocId").lookup('getValue');
		var ReqLocDesc = $("#ReqLocId").lookup('getText');
		var tmpIngrUomId = "";
		tmpIngrUom = "";
		tmpRp = "";
		tmpSp = "";
		tmpNewSp = "";
		tmpMarginnow = "";
		if (IngrParamObj.DefaUom == 1) {
			var tmpIngrUomId = ArrData.BUomId;
			var tmpIngrUom = ArrData.BUomDesc;
			var tmpRp = ArrData.BRp;
			var tmpSp = ArrData.BSp;
			var tmpNewSp = ArrData.BSp;
		} else {
			var tmpIngrUomId = ArrData.PurUomId;
			var tmpIngrUom = ArrData.PurUomDesc;
			var tmpRp = ArrData.Rp;
			var tmpSp = ArrData.Sp;
			var tmpNewSp = ArrData.Sp;
		}
		//加成率
		var sp = tmpSp;
		var rp = tmpRp;
		/// 计算加成率
		if ((sp != 0) && (rp != 0)) {
			var margin = accSub(accDiv(sp, rp), 1);
			tmpMarginnow = margin.toFixed(3);
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
				BatchNo: row.BatchNo||ArrData.BatNo,
				ExpDate: row.ExpDate||ArrData.ExpDate,
				QualityNo: "",
				MtDesc: ArrData.MtDesc,
				PubDesc: ArrData.PbDesc,
				Remarks: row.Remarks,
				BUomId: ArrData.BUomId,
				ConFacPur: ArrData.ConFac,
				MtDr: ArrData.MtDr,
				MtDr2: "",
				SterilizedNo: "",
				InPoQty: "",
				BatchReq: ArrData.BatchReq,
				ExpReq: ArrData.ExpReq,
				BarCode: ArrData.BarCodes,
				AdmNo: ArrData.CertNo,
				AdmExpdate: ArrData.CertExpDate,
				SpecDesc: "",
				IngrUomId: tmpIngrUomId,
				IngrUom: tmpIngrUom,
				Rp: tmpRp,
				Sp: tmpSp,
				NewSp: tmpNewSp,
				reqLocId: ReqLocId,
				reqLocDesc: ReqLocDesc,
				IncscDesc: ArrData.IncscDesc,
				Marginnow: tmpMarginnow
			}
		});
		setTimeout(function () {
			InGdRecGrid.refreshRow();
			InGdRecGrid.startEditingNext('IncDesc');
		}, 0);
	}

	var InGdRecCm = [[{
				field: 'check',
				checkbox: true
			}, {
				title: 'RowId',
				field: 'RowId',
				width: 100,
				hidden: true
			}, {
				title: '物资RowId',
				field: 'IncId',
				width: 100,
				hidden: true
			}, {
				title: '物资代码',
				field: 'IncCode',
				width: 100
			}, {
				title: '物资名称',
				field: 'IncDesc',
				width: 230,
				editor: InciEditor(HandlerParams, SelectRow)
			}, {
				title: "规格",
				field: 'Spec',
				width: 100
			}, {
				title: "型号",
				field: 'Model',
				width: 100
			}, {
				title: "高值标志",
				field: 'HVFlag',
				width: 80,
				hidden: true
			}, {
				title: "厂商",
				field: 'ManfId',
				width: 150,
				formatter: CommonFormatter(PhManufacturerBox, 'ManfId', 'Manf'),
				editor: PhManufacturerBox
			}, {
				title: "批号",
				field: 'BatchNo',
				width: 90,
				editor: {
					type: 'text'
				}
			}, {
				title: "有效期",
				field: 'ExpDate',
				width: 140,
				editor: {
					type: 'datebox'
				}
			}, {
				title: "单位",
				field: 'IngrUomId',
				width: 80,
				formatter: CommonFormatter(UomCombox, 'IngrUomId', 'IngrUom'),
				editor: UomCombox
			}, {
				title: "数量",
				field: 'RecQty',
				width: 80,
				align: 'right',
				necessary: true,
				editor: {
					type: 'numberbox',
					options: {
						required: true,
						min:0,
						precision:GetFmtNum('FmtQTY')
					}
				}
			}, {
				title: "进价",
				field: 'Rp',
				width: 60,
				align: 'right',
				necessary: true,
				editor: {
					type: 'numberbox',
					options: {
						required: true,
						min:0,
						precision:GetFmtNum('FmtRP')
					}
				}
			}, {
				title: "售价",
				field: 'Sp',
				align: 'right',
				width: 60
			}, {
				title: "当前加成",
				field: 'Marginnow',
				align: 'right',
				width: 60
			}, {
				title: "入库售价",
				field: 'NewSp',
				width: 60,
				align: 'right',
				necessary: true,
				hidden:true,
				editor: {
					type: 'numberbox',
					options: {
						required: true,
						min:0,
						precision:GetFmtNum('FmtSP')
					}
				}
			}, {
				title: "发票号",
				field: 'InvNo',
				width: 80,
				editor: {
					type: 'text'
				}
			}, {
				title: "发票金额",
				field: 'InvMoney',
				align: 'right',
				width: 80
			}, {
				title: "发票日期",
				field: 'InvDate',
				width: 100,
				editor: {
					type: 'datebox'
				}
			}, {
				title: "质检单号",
				field: 'QualityNo',
				width: 90,
				editor: {
					type: 'text'
				}
			}, {
				title: "随行单号",
				field: 'SxNo',
				width: 90,
				editor: {
					type: 'text'
				}
			}, {
				title: "进货金额",
				field: 'RpAmt',
				align: 'right',
				width: 100
			}, {
				title: "入库售价金额",
				field: 'NewSpAmt',
				align: 'right',
				width: 100
			}, {
				title: "定价类型",
				field: 'MtDesc',
				width: 180
			}, {
				title: "招标轮次",
				field: 'PubDesc',
				width: 80,
				hidden: true
			}, {
				title: "摘要",
				field: 'Remark',
				width: 90,
				editor: {
					type: 'text'
				}
			}, {
				title: "备注",
				field: 'Remarks',
				width: 90,
				editor: {
					type: 'text'
				}
			}, {
				title: "BUomId",
				field: 'BUomId',
				width: 100,
				hidden: true
			}, {
				title: "ConFacPur",
				field: 'ConFacPur',
				width: 100,
				hidden: true
			}, {
				title: "MtDr",
				field: 'MtDr',
				width: 80,
				hidden: true
			}, {
				title: "MtDr2",
				field: 'MtDr2',
				width: 80,
				hidden: true
			}, {
				title: "灭菌批号",
				field: 'SterilizedNo',
				width: 90,
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
				title: "批号要求",
				field: 'BatchReq',
				width: 80,
				hidden: true
			}, {
				title: "有效期要求",
				field: 'ExpReq',
				width: 80,
				hidden: true
			}, {
				title: "物资条码",
				field: 'BarCode',
				width: 180,
				editor: {
					type: 'text'
				}
			}, {
				title: "注册证号",
				field: 'AdmNo',
				width: 90,
				editor: {
					type: 'text'
				}
			}, {
				title: "注册证有效期",
				field: 'AdmExpdate',
				width: 100,
				editor: {
					type: 'datebox'
				}
			}, {
				title: "具体规格",
				field: 'SpecDesc',
				width: 100,
				editable: false,
				formatter: CommonFormatter(SpecDescbox, 'SpecDesc', 'SpecDesc'),
				editor: SpecDescbox
			}, {
				title: "请求科室",
				field: 'reqLocId',
				width: 80,
				formatter: CommonFormatter(reqLocCombox, 'reqLocId', 'reqLocDesc'),
				editor: reqLocCombox
			}, {
				title: "单品税额",
				field: 'Tax',
				width: 100,
				align: 'right',
				editor: {
					type: 'numberbox'
				}
			}, {
				title: "单品总税额",
				field: 'TaxAmt',
				align: 'right',
				width: 100
			}, {
				title: "OrderDetailSubId",
				field: 'OrderDetailSubId',
				width: 80,
				hidden: true
			}, {
				title: "订单明细id",
				field: 'Inpoi',
				width: 80,
				hidden: true
			}, {
				title: '生产日期',
				field: 'ProduceDate',
				width: 100,
				editor: {
					type: 'datebox'
				}
			}, {
				title: "库存分类",
				field: 'IncscDesc',
				width: 100
			}
		]];
	var InGdRecGrid = $UI.datagrid('#InGdRecGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
				QueryName: 'QueryDetail',
				rows:99999,
				totalFooter:'"IncCode":"合计"',
				totalFields:'RpAmt,NewSpAmt'
			},
			deleteRowParams: {
				ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
				MethodName: 'Delete'
			},
			singleSelect: false,
			columns: InGdRecCm,
			showBar: true,
			//showAddDelItems:true,
			toolbar: [addOneRow, deleteOneRow],
			pagination: false,
			onClickCell: function (index, field, value) {
				if ($HUI.checkbox("#Complete").getValue()) {
					$UI.msg('alert', '入库单已完成!');
					return false;
				}
				var Row = InGdRecGrid.getRows()[index];
				if ((field == 'ExpDate') && (Row.ExpReq == "N")) {
					return false;
				}
				if ((field == 'BatchNo') && (Row.BatchReq == "N")) {
					return false;
				}
				InGdRecGrid.commonClickCell(index, field, value);
			},
			onBeforeEdit: function (index, row) {
				if ($HUI.checkbox("#Complete").getValue()) {
					$UI.msg('alert', '入库单已完成!');
					return false;
				}
			},
			beforeAddFn: function () {
				var ParamsObj = GetParamsObj();
				if ($HUI.checkbox("#Complete").getValue()) {
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
				if ((IngrParamObj.ImpTypeNotNull == "Y") && (isEmpty(ParamsObj.IngrTypeId))) {
					$UI.msg('alert', '入库类型不能为空!!');
					return false;
				}
				if (IngrParamObj.MakeByPoOnly == "Y") {
					$UI.msg('alert', '必须依据订单入库,不能增加!');
					return false;
				}
				if ((IngrParamObj.RequiredSourceOfFund == "Y") && (isEmpty(ParamsObj.SourceOfFund))) {
					$UI.msg('alert', '资金来源不能为空!');
					return false;
				}
				if (isEmpty(ParamsObj.StkGrpId)) {
					$UI.msg('alert', '未选择类组，请谨慎核实数据!');
				}
				SetFieldDisabled("disable");
			},
			onBeginEdit: function (index, row) {
				//增加完成情况字数输入限制
				$(this).datagrid('beginEdit', index);
				var ed = $(this).datagrid('getEditors', index);
				for (var i = 0; i < ed.length; i++) {
					var e = ed[i];
					if (e.field == 'BarCode') {
						$(e.target).bind('keydown', function (event) {
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
									return;
								}
								SelectRow(InciInfoObj['rows'][0]);
							}
						});
					}
				}
			},
			onEndEdit: function (index, row, changes) {
					if (changes.hasOwnProperty('ExpDate')) {
						var ExpReq = row.ExpReq;
						var ExpDate = row.ExpDate;
						var IncId = row.IncId;
						if (isEmpty(IncId)) {
							$UI.msg('alert', "无效明细!");
							InGdRecGrid.checked = false;
							return false;
						}
						var NowDate = DateFormatter(new Date());
						if ((isEmpty(ExpDate)) && (ExpReq == "R")) {
							$UI.msg('alert', "有效期不可为空!");
							InGdRecGrid.checked = false;
							return false;
						}
						if ((!isEmpty(ExpDate)) && (FormatDate(NowDate) >= FormatDate(ExpDate))) {
							$UI.msg('alert', "有效期不能小于或等于当前日期!");
							InGdRecGrid.checked = false;
							return false;
						}
						if ((!isEmpty(ExpDate)) && (ExpReq == "R")) {
							var ExpDateMsg = ExpDateValidator(ExpDate, IncId);
							if(!isEmpty(ExpDateMsg)){
								$UI.msg('alert', '第' + row + '行' + ExpDateMsg );
								InGdRecGrid.checked = false;
								return false;
							}
							if ((!isEmpty(ExpDate)) && (ExpReq == "N")) {
								$UI.msg('alert', "有效期不允许填写!");
								InGdRecGrid.checked = false;
								return false;
							}
						}
					}
					if (changes.hasOwnProperty('BatchNo')) {
						var BatchReq = row.BatchReq;
						var BatchNo = row.BatchNo;
						var IncId = row.IncId;
						if (isEmpty(IncId)) {
							$UI.msg('alert', "无效明细!");
							InGdRecGrid.checked = false;
							return false;
						}
						if ((isEmpty(BatchNo)) && (BatchReq == "R")) {
							$UI.msg('alert', "批号不可为空!");
							InGdRecGrid.checked = false;
							return false;
						}
						if ((!isEmpty(BatchNo)) && (BatchReq == "N")) {
							$UI.msg('alert', "批号不允许填写!");
							InGdRecGrid.checked = false;
							return false;
						}
					}
					if (changes.hasOwnProperty('Rp')) {
						var rp = row.Rp;
						var IncId = row.IncId;
						if (isEmpty(IncId)) {
							$UI.msg('alert', "无效明细!");
							InGdRecGrid.checked = false;
							return false;
						}
						if (isEmpty(rp)) {
							$UI.msg('alert', "进价不能为空!");
							InGdRecGrid.checked = false;
							return false;
						} else if (rp < 0) {
							//2016-09-26进价可为0
							$UI.msg('alert', "进价不能小于零!");
							InGdRecGrid.checked = false;
							return false;
						} else if (rp == 0) {
							//2016-09-26进价可为0
							$UI.msg('alert', "进价等于零!");
						}
						var IncId = row.IncId;
						var UomId = row.IngrUomId;
						var sp = tkMakeServerCall('web.DHCSTMHUI.DHCINGdRec', 'GetSpForRec', IncId, UomId, rp, SessionParams);
						row.Sp = sp;
						//验证加成率
						var ChargeFlag = tkMakeServerCall('web.DHCSTMHUI.Common.DrugInfoCommon', 'GetChargeFlag', IncId);
						var margin = 0;
						if ((rp != 0) && (ChargeFlag == 'Y')) {
							margin = accSub(accDiv(sp, rp), 1);
							if ((IngrParamObj.MarginWarning != 0) && ((margin > IngrParamObj.MarginWarning) || (margin < 0))) {
								$UI.msg('alert', "加成率超出限定范围!");
								InGdRecGrid.checked = false;
								return false;
							}
						}
						// 计算指定行的进货金额
						var RealTotal = accMul(row.RecQty, rp);
						row.RpAmt = RealTotal;
						row.InvMoney = RealTotal;
						row.NewSp = sp;
						row.NewSpAmt = accMul(row.RecQty, sp);
						row.Marginnow = margin.toFixed(3);
						/// 是否调价
						var PriorPriceInfo = tkMakeServerCall('web.DHCSTMHUI.DHCINGdRec', 'GetPrice', IncId, UomId, SessionParams);
						var PriorPriceArr = PriorPriceInfo.split("^");
						var PriorRp = PriorPriceArr[0];
						var PriorSp = PriorPriceArr[1];
						var ResultRp = row.Rp;
						var ResultSp = row.Sp;
						var AllowAspWhileReceive = IngrParamObj.AllowAspWhileReceive;
						var IfExitPriceAdj = tkMakeServerCall('web.DHCSTMHUI.INAdjSalePrice', 'CheckItmAdjSp', IncId, "");
						if ((AllowAspWhileReceive == "Y") && (Number(PriorSp) != Number(ResultSp)) && (IfExitPriceAdj != 1)) {
							var Scg = $("#StkGrpId").combotree('getValue');
							var LocDr = $("#RecLoc").combo('getValue');
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
							$UI.confirm(row.IncDesc + '价格发生变化，是否生成调价单?', '', '', SetAdjPrice, "", "", "", "", adjPriceObj);
						}
					}
					if (changes.hasOwnProperty('RecQty')) {
						var Tax = row.Tax;
						var RecQty = row.RecQty;
						var Rp = row.Rp;
						var Sp = row.Sp;
						if ((isEmpty(RecQty)) || (RecQty <= 0)) {
							$UI.msg('alert', "入库数量不能小于或等于0!");
							InGdRecGrid.checked = false;
							return false;
						}
						var InPoQty = row.InPoQty;
						if ((IngrParamObj.RecQtyExceedOrderAllowed != "Y") && (InPoQty != "") && (Number(RecQty) > Number(InPoQty))) {
							$UI.msg('alert', "入库数量不能大于订购数量!");
							InGdRecGrid.checked = false;
							return false;
						}
						var RealTotal = accMul(Rp, RecQty);
						var SpAmt = accMul(Sp, RecQty);
						if (!isEmpty(Tax)) {
							var TaxAmt = accMul(Tax, RecQty);
							row.TaxAmt = TaxAmt;
						}
						row.RpAmt = RealTotal;
						row.NewSpAmt = SpAmt;
						row.InvMoney = RealTotal;
					}
					if (changes.hasOwnProperty('Tax')) {
						var Tax = row.Tax;
						var RecQty = row.RecQty;
						var TaxAmt = accMul(Tax, RecQty);
						row.TaxAmt = TaxAmt;
					}
					if (changes.hasOwnProperty('InvNo')) {
						var flag = InvNoValidator(row.InvNo, $("#IngrId").val());
						if (flag == false) {
							$UI.msg('alert', "发票号" + row.InvNo + "已存在于别的入库单!");
						}
						if ((isEmpty(row.InvNo)) && (IngrParamObj.InvNoNotNull == "Y")) {
							$UI.msg('alert', "发票号不可为空!");
							InGdRecGrid.checked = false;
							return false;
						}
					}
					if (changes.hasOwnProperty('NewSp')) {
						var NewSp = row.NewSp;
						if ((CommParObj.BatSp == 1) && ((isEmpty(NewSp)) || (NewSp <= 0))) {
							$UI.msg('alert', "入库售价不能小于或等于0!");
							//InGdRecGrid.checked=false;
							//return false;
						}
					}
					if (changes.hasOwnProperty('ManfId')) {
						var ManfId = row.ManfId;
						if ((IngrParamObj.ManfNotNull != "Y") && (isEmpty(ManfId))) {
							$UI.msg('alert', "入库厂商不能为空!");
							InGdRecGrid.checked = false;
							return false;
						}
						var CheckQualParams = JSON.stringify(addSessionParams({
									ManfId: ManfId,
									Inci: row.IncId
								}));
						var CheckQualData = tkMakeServerCall('web.DHCSTMHUI.Common.UtilCommon', 'Check', CheckQualParams);
						if (CheckQualData != "") {
							$UI.msg('alert', row.IncDesc + ":" + CheckQualData);
							if (CommParObj.StopItmBussiness == 'Y') {
								InGdRecGrid.checked = false;
								return false;
							}
						}
					}
				
				InGdRecGrid.setFooterInfo();
			},
			rowStyler: function (index, row) {
				if ((row.Sp == 0) && (CommParObj.BatSp == 1)) {
					$UI.msg('alert', "售价不能小于等于零!");
					return 'background-color:yellow;color:black;font-weight:bold;';
				}
			}
		})
	function SetDefaValues() {
		$('#StkGrpId').combotree('options')['setDefaultFun']();
		$('#RecLoc').combobox('setValue', gLocId);
		$('#CreateDate').dateboxq('setValue', DateFormatter(new Date()));
		var IngrTypeId = GetIngrtypeDefa();
		$('#IngrTypeId').lookup('setValue', IngrTypeId);
		SetFieldDisabled("enable");
		InGdRecGrid.setFooterInfo()
		ChangeButtonEnable({
			'#SaveBT': true,
			'#DelBT': false,
			'#ComBT': false,
			'#CanComBT': false,
			'#PrintBT': false
		});
	}
	SetDefaValues();
	if (!isEmpty(gIngrRowid)) {
		Select(gIngrRowid);
	}
}
$(init);
if (!FileReader.prototype.readAsBinaryString) {
	console.log('readAsBinaryString definition not found');
	FileReader.prototype.readAsBinaryString = function (fileData) {
		var binary = '';
		var pk = this;
		var reader = new FileReader();
		reader.onload = function (e) {
			var bytes = new Uint8Array(reader.result);
			var length = bytes.byteLength;
			for (var i = 0; i < length; i++) {
				var a = bytes[i];
				var b = String.fromCharCode(a)
				binary += b;
			}
			pk.content = binary;
			$(pk).trigger('onload');
		}
		reader.readAsArrayBuffer(fileData);
	}
}