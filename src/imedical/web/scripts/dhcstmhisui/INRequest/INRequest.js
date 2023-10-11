var ReqTemplateFlag = false;
var init = function() {
	// �󶨲�����Ϣ
	var userCode = session['LOGON.USERCODE'];
	var userdr = session['LOGON.USERID'];
	var frm = dhcsys_getmenuform();
	var Adm = frm.EpisodeID.value;
	if (Adm) {
		$.cm({
			ClassName: 'web.DHCSTMHUI.INRequest',
			MethodName: 'ByAdmGetPatInfo',
			Adm: Adm
		}, function(jsonData) {
			if (jsonData.success == 0) {
				var vs = jsonData.rowid.split('^');
				$('#RegNo').val(vs[0]);
				$('#PatientName').val(vs[1]);
				$('#Medicare').val(vs[2]);
			} else {
				$UI.msg('alert', jsonData.msg);
				return;
			}
		});
	}
	var LimitAmtCol = (InitParamObj.UseLocLimitAmt == 'Y' ? false : true);
	// /���ÿɱ༭�����disabled����
	function setEditDisable() {
		$HUI.combobox('#ReqLoc').disable();
		$HUI.combobox('#SupLoc').disable();
		$HUI.combobox('#ScgStk').disable();
		$HUI.combobox('#ReqType').disable();
		$('#Medicare').attr('readOnly', true);
	}
	// /�ſ��ɱ༭�����disabled����
	function setEditEnable() {
		$HUI.combobox('#ReqLoc').enable();
		$HUI.combobox('#SupLoc').enable();
		$HUI.combobox('#ScgStk').enable();
		$HUI.combobox('#ReqType').enable();
		$('#Medicare').attr('readOnly', false);
	}
	var ClearMain = function() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(InRequestGrid);
		var DefaultData = {
			ReqLoc: gLocObj,
			ReqType: 'O'
		};
		$UI.fillBlock('#MainConditions', DefaultData);
		ChangeButtonEnable({
			'#DelBT': false,
			'#PrintBT': false,
			'#ComBT': false,
			'#CanComBT': false,
			'#SaveBT': true
		});
	};

	var ReqTypeBox = $HUI.combobox('#ReqType', {
		data: [{ 'RowId': 'O', 'Description': '��ʱ����' }, { 'RowId': 'C', 'Description': '����ƻ�' }],
		valueField: 'RowId',
		textField: 'Description'
	});

	// Grid �� comboxData
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
				var rows = InRequestGrid.getRows();
				var row = rows[InRequestGrid.editIndex];
				if (!isEmpty(row)) {
					param.Inci = row.Inci;
				}
			},
			onSelect: function(record) {
				var rows = InRequestGrid.getRows();
				var row = rows[InRequestGrid.editIndex];
				row.UomDesc = record.Description;
				var Uom = record.RowId;
				row.Uom = Uom;
				var Inci = row.Inci;
				var LocId = $HUI.combobox('#ReqLoc').getValue();
				var FrLoc = $HUI.combobox('#SupLoc').getValue();
				var Params = gGroupId + '^' + LocId + '^' + gUserId + '^' + Uom + '^' + FrLoc;
				GetItmInfo(Inci, Params, row, InRequestGrid.editIndex);
			}
		}
	};
	function GetItmInfo(Inci, Params, Row, index) {
		var Data = tkMakeServerCall('web.DHCSTMHUI.INRequest', 'GetItmInfo', Inci, Params);
		var ArrData = Data.split('^');
		var ManfId = ArrData[0];
		var ManfDesc = ArrData[1];
		Row.Manf = ManfDesc,
		Row.Rp = Number(ArrData[4]);
		Row.Sp = Number(ArrData[5]);
		if (!isEmpty(Row.Qty)) {
			Row.SpAmt = accMul(Number(Row.Qty), Number(Row.Sp));
			Row.RpAmt = accMul(Number(Row.Qty), Number(Row.Rp));
		}
		Row.RepLev = ArrData[10];
		Row.LimitType = ArrData[11];
		Row.ReqAmt = ArrData[12];
		Row.LeftAmt = ArrData[13];
		Row.ProLocAllAvaQty = ArrData[14];
		setTimeout(function() {
			InRequestGrid.refreshRow();
			InRequestGrid.startEditingNext('Description');
		}, 0);
	}
	var SpecDescParams = JSON.stringify(sessionObj);
	var SpecDescbox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSpecDesc&ResultSetType=array&Params=' + SpecDescParams,
			valueField: 'Description',
			textField: 'Description',
			mode: 'remote',
			onBeforeLoad: function(param) {
				var rows = InRequestGrid.getRows();
				var row = rows[InRequestGrid.editIndex];
				if (!isEmpty(row)) {
					param.Inci = row.Inci;
				}
			}
		}
	};
	var ReqLocParams = JSON.stringify(addSessionParams({
		Type: INREQUEST_LOCTYPE,
		Element: 'ReqLoc',
		LoginLocType: 2
	}));
	var ReqLocBox = $HUI.combobox('#ReqLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$('#SupLoc').combobox('clear');
			$('#SupLoc').combobox('reload', $URL
				+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
				+ JSON.stringify(addSessionParams({
					Type: 'Trans',
					LocId: LocId,
					TransLocType: 'F',
					Element: 'SupLoc'
				})));
			var DefaInfo = tkMakeServerCall('web.DHCSTMHUI.DHCTransferLocConf', 'GetDefLoc', LocId, gGroupId);
			var SupLocId = DefaInfo.split('^')[0], SupLocDesc = DefaInfo.split('^')[1];
			if (SupLocId && SupLocDesc) {
				AddComboData($('#SupLoc'), SupLocId, SupLocDesc);
				$('#SupLoc').combobox('setValue', SupLocId);
				SupLocParamsObj = GetAppPropValue('DHCSTINREQM', provLoc);
			}
			var requestLoc = ReqLocBox.getValue();
			var provLoc = SupLocBox.getValue();
			$HUI.combotree('#ScgStk').setFilterByLoc(requestLoc, provLoc);
		}
	});
	var SupLocParams = JSON.stringify(addSessionParams({
		Type: 'Trans',
		Element: 'SupLoc'
	}));
	var SupLocBox = $HUI.combobox('#SupLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + SupLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var requestLoc = ReqLocBox.getValue();
			var provLoc = SupLocBox.getValue();
			$HUI.combotree('#ScgStk').setFilterByLoc(requestLoc, provLoc);
			
			SupLocParamsObj = GetAppPropValue('DHCSTINREQM', provLoc);
		}
	});
	var UserBox = $HUI.combobox('#User', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetUser&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			FindWin(Select);
		}
	});
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			if (CheckDataBeforeSave() == true) {
				Save();
			}
		}
	});
	function CheckDataBeforeSave() {
		if (!InRequestGrid.endEditing()) {
			return false;
		}
		var RowsData = InRequestGrid.getRows();
		for (var i = 0; i < RowsData.length; i++) {
			var row = i + 1;
			var IncId = RowsData[i].Inci;
			var Incidesc = RowsData[i].Description;
			var qty = RowsData[i].Qty;
			if (qty == null || qty <= 0) {
				$UI.msg('alert', '��' + row + '��' + Incidesc + '��������С�ڻ����0!');
				return false;
			}
		}
		return true;
	}
	var Save = function() {
		var MainObj = $UI.loopBlock('#MainConditions');
		var IsChange = $UI.isChangeBlock('#MainConditions');
		var Main = JSON.stringify(MainObj);
		// ͨ��ģ���Ƶ�
		var Req = $('#RowId').val();
		if (ReqTemplateFlag && isEmpty(Req)) {
			// ��ģ���Ƶ�
			DetailObj = InRequestGrid.getRowsData();
		} else {
			DetailObj = InRequestGrid.getChangesData('Inci');
		}
		if (DetailObj === false) {
			return;
		} else if (DetailObj.length == 0 && IsChange == false) {
			$UI.msg('alert', 'û����Ҫ���������!');
			return;
		}
		var CheckMsgArr = [];
		var InreqRows = InRequestGrid.getRows();
		for (var i = 0; i < InreqRows.length; i++) {
			var InreqRow = InreqRows[i];
			var Inci = InreqRow.Inci;
			var InciDesc = InreqRow.Description;
			var SpecDesc = InreqRow.SpecDesc;
			var RowIndex = $('#InRequestGrid').datagrid('getRowIndex', InreqRow);
			$.each(InreqRows, function(index, row) {
				var tmpInci = row['Inci'];
				var tmpInciDesc = row['Description'];
				var tmpSpecDesc = row['SpecDesc'];
				if (tmpInci == Inci && index != RowIndex) {
					if ((CodeMainParamObj.UseSpecList != 'Y') || (isEmpty(tmpSpecDesc) && (isEmpty(SpecDesc)))) {
						var CheckMsg = InciDesc + '�ظ�¼��';
						CheckMsgArr.push(CheckMsg);
					} else {
						if (tmpSpecDesc == SpecDesc) {
							var CheckMsg = InciDesc + '������:[' + SpecDesc + ']�ظ�¼��';
							CheckMsgArr.push(CheckMsg);
						}
					}
				}
			});
		}
		if (!isEmpty(CheckMsgArr)) {
			$UI.msg('alert', CheckMsgArr.join());
			return false;
		}
		var Detail = JSON.stringify(DetailObj);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INRequest',
			MethodName: 'Save',
			Main: Main,
			Detail: Detail
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				Select(jsonData.rowid);
				ReqTemplateFlag = false;
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	};
	$UI.linkbutton('#DelBT', {
		onClick: function() {
			var Req = $('#RowId').val();
			if (isEmpty(Req)) {
				return;
			}
			function del() {
				$.cm({
					ClassName: 'web.DHCSTMHUI.INRequest',
					MethodName: 'Delete',
					Req: Req
				}, function(jsonData) {
					if (jsonData.success === 0) {
						$UI.msg('success', jsonData.msg);
						ClearMain();
						setEditEnable();
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			}
			$UI.confirm('ȷ��Ҫɾ����?', '', '', del);
		}
	});
	
	// ���ǰ�ض��ж���ʾ
	function CheckDataBeforeComplete() {
		var MainObj = $UI.loopBlock('#MainConditions');
		var Req = MainObj.RowId;
		if (isEmpty(Req)) {
			$UI.msg('alert', '����Ҫ����ĵ���');
			return false;
		}
		var rowData = InRequestGrid.getRows();
		var rowCount = rowData.length;
		if (rowCount < 1) {
			$UI.msg('alert', '�õ���û����ϸ!');
			return false;
		}
		// �ж��޶�
		if (InitParamObj.UseLocLimitAmt == 'Y') {
			var LimitAmtInfo = $.cm({
				ClassName: 'web.DHCSTMHUI.LocLimitAmt',
				MethodName: 'GetLimitAmtByReq',
				ReqId: Req
			}, false);
			if (!isEmpty(LimitAmtInfo.success) && LimitAmtInfo.success != 0) {
				return true;
			}
			var ResultLoc = LimitAmtInfo.ResultLoc;
			var ResultScg = LimitAmtInfo.ResultScg;
			var ResultCat = LimitAmtInfo.ResultCat;
			var ResultInci = LimitAmtInfo.ResultInci;
			var ResultInciQty = LimitAmtInfo.ResultInciQty;
			var ResultInciOnceQty = LimitAmtInfo.ResultInciOnceQty;
			var Msg = '';
			if (!isEmpty(ResultLoc)) {
				Msg = Msg + '����:(' + ResultLoc + ')�������޶';
			}
			if (!isEmpty(ResultScg)) {
				Msg = Msg + '����:(' + ResultScg + ')�����޶';
			}
			if (!isEmpty(ResultCat)) {
				Msg = Msg + '������:(' + ResultCat + ')�����޶';
			}
			if (!isEmpty(ResultInci)) {
				Msg = Msg + 'Ʒ��:(' + ResultInci + ')�����޶';
			}
			if (!isEmpty(ResultInciQty)) {
				Msg = Msg + 'Ʒ��:(' + ResultInciQty + ')����������';
			}
			if (!isEmpty(ResultInciOnceQty)) {
				Msg = Msg + '(Ʒ��:' + ResultInciOnceQty + ')��������������';
			}
			if (!isEmpty(Msg)) {
				$UI.confirm('��ʱ����� ' + Msg + ' �Ƿ����?', '', '', Complete);
			} else {
				Complete();
			}
		} else {
			Complete();
		}
	}
	function Complete() {
		var MainObj = $UI.loopBlock('#MainConditions');
		var Main = JSON.stringify(MainObj);
		$.cm({
			ClassName: 'web.DHCSTMHUI.INRequest',
			MethodName: 'jsSetComp',
			Params: Main
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				Select(jsonData.rowid);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#ComBT', {
		onClick: function() {
			CheckDataBeforeComplete();
		}
	});
	$UI.linkbutton('#CanComBT', {
		onClick: function() {
			var Req = $('#RowId').val();
			if (isEmpty(Req)) {
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.INRequest',
				MethodName: 'jsCancelComp',
				Req: Req
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					Select(jsonData.rowid);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			ClearMain();
			setEditEnable();
		}
	});
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			if (isEmpty($('#RowId').val())) {
				$UI.msg('alert', 'û����Ҫ��ӡ������!');
				return;
			}
			if (InRequestParamObj.PrintNoComplete != 'Y' && !$HUI.checkbox('#Comp').getValue()) {
				$UI.msg('alert', 'δ��ɲ��ܴ�ӡ!');
				return false;
			}
			PrintINRequest($('#RowId').val());
		}
	});
	$UI.linkbutton('#FindTemBT', {
		onClick: function() {
			findReqTemplateWin(Select, TemSelect);
		}
	});
	var Select = function(Req) {
		$UI.clearBlock('#MainConditions');
		$UI.clear(InRequestGrid);
		$.cm({
			ClassName: 'web.DHCSTMHUI.INRequest',
			MethodName: 'Select',
			Req: Req
		}, function(jsonData) {
			$UI.fillBlock('#MainConditions', jsonData);
			setEditDisable();
			// ��ť����
			if ($HUI.checkbox('#Comp').getValue()) {
				ChangeButtonEnable({
					'#DelBT': false,
					'#PrintBT': true,
					'#ComBT': false,
					'#CanComBT': true,
					'#SaveBT': false
				});
			} else {
				ChangeButtonEnable({
					'#DelBT': true,
					'#PrintBT': true,
					'#ComBT': true,
					'#CanComBT': false,
					'#SaveBT': true
				});
			}
		});
		var ParamsObj = {
			RefuseFlag: 1
		};
		var Params = JSON.stringify(addSessionParams(ParamsObj));
		InRequestGrid.load({
			ClassName: 'web.DHCSTMHUI.INReqItm',
			QueryName: 'INReqD',
			query2JsonStrict: 1,
			Req: Req,
			Params: Params,
			rows: 99999,
			totalFooter: '"Description":"�ϼ�"',
			totalFields: 'SpAmt'
		});
	};
	
	var TemSelect = function(Req, ReqDetailIdStr) {
		ClearMain();
		ReqTemplateFlag = true;
		$.cm({
			ClassName: 'web.DHCSTMHUI.INRequest',
			MethodName: 'Select',
			Req: Req
		}, function(jsonData) {
			$('#ScgStk').combotree('setValue', jsonData.ScgStk);
			$('#ReqLoc').combobox('setValue', jsonData.ReqLocId);
			$('#SupLoc').combobox('setValue', jsonData.SupLocId);
			$('#ReqType').combobox('setValue', jsonData.ReqType);
			// $UI.fillBlock('#MainConditions',jsonData);
		});
		var ParamsObj = {
			RefuseFlag: 1,
			ReqDetailIdStr: ReqDetailIdStr
		};
		var Params = JSON.stringify(addSessionParams(ParamsObj));
		InRequestGrid.load({
			ClassName: 'web.DHCSTMHUI.INReqItm',
			QueryName: 'INReqD',
			query2JsonStrict: 1,
			Req: Req,
			Params: Params,
			rows: 99999,
			totalFooter: '"Description":"�ϼ�"',
			totalFields: 'SpAmt'
		});
	};
	
	$UI.linkbutton('#SaveAsTemBT', {
		onClick: function() {
			var MainObj = $UI.loopBlock('#MainConditions');
			var ReqId = MainObj['RowId'], Template = MainObj['#Template'];
			if (isEmpty(ReqId)) {
				$UI.msg('alert', '����ѡ����Ҫ���ĵ���!');
				return;
			}
			if (Template == 'Y') {
				$UI.confirm('��ǰ���ݾ���ģ��, �Ƿ�������?', 'question', '', SaveAsTemp);
			} else {
				$UI.confirm('����Ҫ���õ���Ϊģ��, �Ƿ����?', 'question', '', SaveAsTemp);
			}
		}
	});
	function SaveAsTemp() {
		var MainObj = $UI.loopBlock('#MainConditions');
		var ReqId = MainObj['RowId'];
		var ParamsObj = { ReqId: ReqId };
		ParamsObj = addSessionParams(ParamsObj);
		var Params = JSON.stringify(ParamsObj);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INRequestTemplate',
			MethodName: 'jsSaveAsTem',
			Params: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				Select(jsonData.rowid);
				ReqTemplateFlag = false;
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	$UI.linkbutton('#SelInciBT', {
		onClick: function() {
			if ($HUI.checkbox('#Comp').getValue()) {
				$UI.msg('alert', '�Ѿ���ɣ���������һ��!');
				return false;
			}
			if (isEmpty($HUI.combobox('#ReqLoc').getValue())) {
				$UI.msg('alert', '������Ҳ���Ϊ��!');
				return false;
			}
			if (isEmpty($HUI.combobox('#SupLoc').getValue())) {
				$UI.msg('alert', '��Ӧ���Ҳ���Ϊ��!');
				return false;
			}
			if (InRequestParamObj.NoScgLimit != 'Y' && isEmpty($HUI.combobox('#ScgStk').getValue())) {
				$UI.msg('alert', '���鲻��Ϊ��!');
				return false;
			}
			setEditDisable();
			
			var Scg = $('#ScgStk').combotree('getValue');
			var SupLoc = $('#SupLoc').combo('getValue');
			var ReqLoc = $('#ReqLoc').combo('getValue');
			var ReqType = $('#ReqType').combo('getValue');
			var HV = gHVInRequest ? 'Y' : 'N';
			var RequestNoStock = SupLocParamsObj['IsRequestNoStock'];
			var QtyFlag = RequestNoStock == 'Y' ? '0' : (SupLocParamsObj['QtyFlag'] == 'Y' ? '1' : '0'); // / ���ݿⷿ�ж�
			var ParamsObj = {
				StkGrpRowId: Scg,
				StkGrpType: 'M',
				Locdr: SupLoc,
				ToLoc: ReqLoc,
				NotUseFlag: 'N',
				QtyFlag: QtyFlag,	// ���
				ReqModeLimited: ReqType, // "O"
				NoLocReq: 'N',
				HV: HV,
				RequestNoStock: RequestNoStock, //	//���
				SeachAllFlag: 'Y'
			};
			var OthersObj = {
				DefaUom: InRequestParamObj.DefaUom,	// ��λ
				MoreThanStockFlag: SupLocParamsObj['IfRequestMoreThanStock'] // Y����
			};
			IncItmWindow(ParamsObj, OthersObj, ReturnInfoFunc);
		}
	});
	var ReturnInfoFunc = function(RowsData) {
		var RowsLen = RowsData.length;
		for (var i = 0; i < RowsLen; i++) {
			var RowData = RowsData[i];
			var Inci = RowData.InciDr;
			var InciDesc = RowData.InciDesc;
			var FindIndex = InRequestGrid.find('Inci', Inci);
			if (CodeMainParamObj.UseSpecList != 'Y' && FindIndex >= 0) {
				$UI.msg('alert', InciDesc + '�Ѵ����ڵ�' + (FindIndex + 1) + '��!');
				continue;
			}
			var UomId = RowData.BUomDr;
			var UomDesc = RowData.BUomDesc;
			var Sp = RowData.BSp;
			var ProLocAllAvaQty = RowData.BUomAvaQty;
			var ReqPuomQty = RowData.ReqBuomQty;
			if (InRequestParamObj.DefaUom == 0) {
				UomId = RowData.PUomDr;
				UomDesc = RowData.PUomDesc;
				Sp = RowData.PSp;
				ProLocAllAvaQty = RowData.PUomAvaQty;
				ReqPuomQty = RowData.ReqPuomQty;
			}
			var LocId = $HUI.combobox('#ReqLoc').getValue();
			var FrLoc = $HUI.combobox('#SupLoc').getValue();
			var Params = gGroupId + '^' + LocId + '^' + gUserId + '^' + UomId + '^' + FrLoc;
			var INReqData = tkMakeServerCall('web.DHCSTMHUI.INRequest', 'GetItmInfo', RowData.InciDr, Params);
			var ArrData = INReqData.split('^');
			
			var rowObj = {
				Inci: RowData.InciDr,
				Code: RowData.InciCode,
				Description: RowData.InciDesc,
				Spec: RowData.Spec,
				Uom: UomId,
				UomDesc: UomDesc,
				Qty: RowData.Qty,
				ProLocAllAvaQty: ProLocAllAvaQty,
				ReqPuomQty: ReqPuomQty,
				HVFlag: RowData.HVFlag,
				InciRemarks: RowData.Remarks,
				Manf: ArrData[1],
				Rp: ArrData[4],
				Sp: ArrData[5],
				SpAmt: accMul(Number(RowData.Qty), Number(ArrData[5])),
				RpAmt: accMul(Number(RowData.Qty), Number(ArrData[4])),
				RepLev: ArrData[10],
				ReqAmt: ArrData[11],
				LeftAmt: ArrData[12],
				LimitType: ArrData[13],
				ItmReqAmt: ArrData[14],
				ItmLeftAmt: ArrData[15]
			};
			
			var tmprow = $.extend({}, rowObj);
			var EditRowIndex = 0;
			var length = InRequestGrid.getRows().length;
			if (length > 0) {
				EditRowIndex = length;
			}
			InRequestGrid.insertRow({
				index: EditRowIndex,
				row: tmprow
			});
		}
	};
	
	var HandlerParams = function() {
		var Scg = $('#ScgStk').combotree('getValue');
		var LocDr = $('#SupLoc').combo('getValue');
		var ReqLoc = $('#ReqLoc').combo('getValue');
		var HV = gHVInRequest ? 'Y' : 'N';
		var RequestNoStock = SupLocParamsObj['IsRequestNoStock'];
		var QtyFlag = RequestNoStock == 'Y' ? '0' : (SupLocParamsObj['QtyFlag'] == 'Y' ? '1' : '0'); // / ���ݿⷿ�ж�
		var ReqType = $('#ReqType').combo('getValue');	// �������������"����ƻ�",����QtyFlag��Ӱ��,���жϿ���Ƿ�Ϊ0
		var Obj = {
			StkGrpRowId: Scg,
			StkGrpType: 'M',
			Locdr: LocDr,
			NotUseFlag: 'N',
			QtyFlag: QtyFlag,
			ToLoc: ReqLoc,
			ReqModeLimited: 'O',
			NoLocReq: 'N',
			HV: HV,
			RequestNoStock: RequestNoStock,
			ReqType: ReqType
		};
		return Obj;
	};
	var SelectRow = function(row) {
		var Rows = InRequestGrid.getRows();
		var Row = Rows[InRequestGrid.editIndex];
		var Inci = row.InciDr;
		var InciDesc = row.InciDesc;
		var FindIndex = InRequestGrid.find('Inci', Inci);
		var Uom = SupLocParamsObj['DefaUom'] == '1' ? row.BUomDr : row.PUomDr;
		var UomDesc = SupLocParamsObj['DefaUom'] == '1' ? row.BUomDesc : row.PUomDesc;
		if (CodeMainParamObj.UseSpecList != 'Y' && FindIndex >= 0 && FindIndex != InRequestGrid.editIndex) {
			$UI.msg('alert', InciDesc + '�Ѵ����ڵ�' + (FindIndex + 1) + '��!');
			return;
		}
		InRequestGrid.updateRow({
			index: InRequestGrid.editIndex,
			row: {
				Inci: row.InciDr,
				Code: row.InciCode,
				Uom: Uom,
				UomDesc: UomDesc,
				Sp: row.PSp,
				Description: row.InciDesc,
				Spec: row.Spec,
				ProLocAllAvaQty: row.PUomAvaQty,
				ReqPuomQty: row.ReqPuomQty,
				InciRemarks: row.Remarks,
				HVFlag: row.HVFlag
			}
		});
		var LocId = $HUI.combobox('#ReqLoc').getValue();
		var FrLoc = $HUI.combobox('#SupLoc').getValue();
		var Params = gGroupId + '^' + LocId + '^' + gUserId + '^' + row.PUomDr + '^' + FrLoc;
		GetItmInfo(row.InciDr, Params, Row, InRequestGrid.editIndex);
	};

	var InRequestCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			saveCol: true,
			hidden: true
		}, {
			title: '����RowId',
			field: 'Inci',
			width: 100,
			saveCol: true,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'Code',
			width: 100
		}, {
			title: '��������',
			field: 'Description',
			width: 150,
			editor: InciEditor(HandlerParams, SelectRow)
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '������',
			field: 'SpecDesc',
			width: 100,
			align: 'left',
			saveCol: CodeMainParamObj.UseSpecList == 'Y' ? true : false,
			sortable: true,
			formatter: CommonFormatter(SpecDescbox, 'SpecDesc', 'SpecDesc'),
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true,
			editor: (CodeMainParamObj.UseSpecList == 'Y' ? false : true) ? null : SpecDescbox
		}, {
			title: '��������',
			field: 'Manf',
			width: 150
		}, {
			title: '�������ÿ��',
			field: 'ProLocAllAvaQty',
			width: 100,
			align: 'right',
			sortable: false
		}, {
			title: '�������',
			field: 'RepLev',
			width: 100,
			align: 'right',
			sorter: NumberSorter
		}, {
			title: '��������',
			field: 'Qty',
			width: 100,
			necessary: true,
			saveCol: true,
			align: 'right',
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					tipPosition: 'bottom',
					min: 0,
					precision: GetFmtNum('FmtQTY')
				}
			},
			sorter: NumberSorter
		}, {
			title: '��λ',
			field: 'Uom',
			width: 80,
			necessary: true,
			saveCol: true,
			formatter: CommonFormatter(UomCombox, 'Uom', 'UomDesc'),
			editor: UomCombox
		}, {
			title: '���۵���',
			field: 'Sp',
			width: 100,
			sorter: NumberSorter,
			align: 'right'
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			width: 100,
			align: 'right',
			sorter: NumberSorter
		}, {
			title: '����ע',
			field: 'ReqRemarks',
			width: 200,
			align: 'left',
			saveCol: true,
			editor: {
				type: 'validatebox'
			}
		}, {
			title: '���ʱ�ע',
			field: 'InciRemarks',
			width: 200
		}, {
			title: '�����ҿ����',
			field: 'ReqPuomQty',
			width: 100,
			align: 'right',
			sortable: false
		}, {
			title: '��ֵ��־',
			field: 'HVFlag',
			width: 80,
			align: 'center',
			formatter: BoolFormatter,
			hidden: true
		}, {
			title: '�޶ʽ',
			field: 'LimitType',
			width: 100,
			align: 'right',
			hidden: LimitAmtCol
		}, {
			title: '�޶�',
			field: 'ReqAmt',
			width: 100,
			align: 'right',
			hidden: LimitAmtCol
		}, {
			title: 'ʣ���޶�',
			field: 'LeftAmt',
			width: 130,
			align: 'right',
			hidden: LimitAmtCol
		}, {
			title: '����',
			field: 'Rp',
			width: 100,
			align: 'right',
			hidden: true
		}, {
			title: '���۽��',
			field: 'RpAmt',
			width: 100,
			align: 'right',
			hidden: true
		}
	]];

	var InRequestGrid = $UI.datagrid('#InRequestGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INReqItm',
			QueryName: 'INReqD',
			query2JsonStrict: 1,
			rows: 99999,
			totalFooter: '"Description":"�ϼ�"',
			totalFields: 'SpAmt'
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.INReqItm',
			MethodName: 'Delete'
		},
		columns: InRequestCm,
		checkField: 'Inci',
		singleSelect: false,
		showBar: true,
		showFooter: true,
		showAddDelItems: true,
		remoteSort: false,
		pagination: false,
		onClickRow: function(index, row) {
			InRequestGrid.commonClickRow(index, row);
		},
		onEndEdit: function(index, row, changes) {
			var Editors = $(this).datagrid('getEditors', index);
			for (var i = 0; i < Editors.length; i++) {
				var Editor = Editors[i];
				if (Editor.field == 'Qty') {
					var RepLev = row.RepLev;
					var Qty = row.Qty;
					if (!isEmpty(Qty)) {
						row.SpAmt = accMul(Number(row.Qty), Number(row.Sp));
						row.RpAmt = accMul(Number(row.Qty), Number(row.Rp));
					}
					var ProLocAllAvaQty = row.ProLocAllAvaQty;
					if (!isEmpty(RepLev) & RepLev != 0) {
						RepLev = Qty % RepLev;
					}
					if ((!isEmpty(RepLev) & RepLev != 0) && (InRequestParamObj.IfAllowReqBQtyUsed == 'Y')) {
						$UI.msg('alert', '����������Ҫ�����������������!');
						InRequestGrid.checked = false;
						return false;
					}
					if ((SupLocParamsObj.IfRequestMoreThanStock != 'Y') && (accSub(Qty, ProLocAllAvaQty) > 0)) {
						$UI.msg('alert', '�������������Դ��ڿ����!');
						InRequestGrid.checked = false;
						return false;
					}
				}
				if (Editor.field == 'SpecDesc') {
					var SpecDesc = row.SpecDesc;
					var InciDesc = row.Description;
					var Inci = row.Inci;
					var InreqRows = InRequestGrid.getRows();
					$.each(InreqRows, function(tindex, trow) {
						var tmpInci = trow['Inci'];
						var tmpInciDesc = trow['Description'];
						var tmpSpecDesc = trow['SpecDesc'];
						if ((tmpInci == Inci) && (tmpSpecDesc == SpecDesc) && index != tindex) {
							$UI.msg('alert', tmpInciDesc + '������:[' + tmpSpecDesc + ']�ظ�¼��');
							InRequestGrid.checked = false;
							return false;
						}
					});
				}
			}
		},
		onBeforeEdit: function(index, row) {
			if ($HUI.checkbox('#Comp').getValue()) {
				return false;
			}
		},
		onBeginEdit: function(index, row) {
			var ed = $('#InRequestGrid').datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++) {
				var e = ed[i];
				if (e.field == 'Qty') {
					$(e.target).bind('keydown', function(event) {
						if (event.keyCode == 13) {
							var Qty = $(this).val();
							if (Qty <= 0) {
								$UI.msg('alert', '��������������!');
								$(this).val('');
								InRequestGrid.checked = false;
								InRequestGrid.stopJump();
								return false;
							}
							var ProLocAllAvaQty = row['ProLocAllAvaQty'];
							if ((SupLocParamsObj['IfRequestMoreThanStock'] != 'Y') && (accSub(Qty, ProLocAllAvaQty) > 0)) {
								$UI.msg('alert', '�������������Դ��ڿ����!');
								$(this).val('');
								InRequestGrid.checked = false;
								InRequestGrid.stopJump();
								return false;
							}
						}
					});
				}
			}
		},
		beforeDelFn: function() {
			if ($HUI.checkbox('#Comp').getValue()) {
				$UI.msg('alert', '�Ѿ���ɣ�����ɾ��ѡ����!');
				return false;
			}
		},
		beforeAddFn: function() {
			if ($HUI.checkbox('#Comp').getValue()) {
				$UI.msg('alert', '�Ѿ���ɣ���������һ��!');
				return false;
			}
			if (isEmpty($HUI.combobox('#ReqLoc').getValue())) {
				$UI.msg('alert', '������Ҳ���Ϊ��!');
				return false;
			}
			if (isEmpty($HUI.combobox('#SupLoc').getValue())) {
				$UI.msg('alert', '��Ӧ���Ҳ���Ϊ��!');
				return false;
			}
			if ($HUI.combobox('#SupLoc').getValue() == $HUI.combobox('#ReqLoc').getValue()) {
				$UI.msg('alert', '������Ҳ������빩Ӧ������ͬ!');
				return false;
			}
			if (InRequestParamObj.NoScgLimit != 'Y' && isEmpty($HUI.combobox('#ScgStk').getValue())) {
				$UI.msg('alert', '���鲻��Ϊ��!');
				return false;
			}
			setEditDisable();
		},
		onLoadSuccess: function(data) {
			var Req = $('#RowId').val();
			if (isEmpty(Req)) {
				for (var i = 0; i < data.rows.length; i++) {
					$(this).datagrid('updateRow', {
						index: i,
						row: { RowId: '' }
					});
				}
			}
		}
	});
	function SelectDefa() {
		ClearMain();
		if (!isEmpty(gReqId)) {
			Select(gReqId);
			gReqId = '';
		} else if (!isEmpty(gTabParams)) {
			var TalParamsObj = JSON.parse(gTabParams);
			var TabType = TalParamsObj.TabType;
			if (TabType == 'Search') {
				FindWin(Select);
			}
			gTabParams = '';
		}
		CheckLocationHref(1);
	}
	SelectDefa();
};
$(init);