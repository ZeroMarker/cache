var init = function () {
	if ("undefined" == typeof (sssAspType)) {
		sssAspType = ""
	}

	var UomCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInciUom&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			mode: 'remote',
			onBeforeLoad: function (param) {
				var Select = AdjPriceGrid.getSelected();
				if (!isEmpty(Select)) {
					param.Inci = Select.Inci;
				}

			},
			onSelect: function (record) {
				var rows = AdjPriceGrid.getRows();
				var row = rows[AdjPriceGrid.editIndex];
				row.AspUomDesc = record.Description;
				var NewUomid = record.RowId;
				var OldUomid = row.AspUomId;
				if (isEmpty(NewUomid) || (NewUomid == OldUomid)) {
					return false;
				}
				var BUomId = row.BUomId;
				var PriorRpUom = row.PriorRpUom;
				var PriorSpUom = row.PriorSpUom;
				var ResultRpUom = row.ResultRpUom;
				var ResultSpUom = row.ResultSpUom;
				var confac = row.ConFacPur;
				if (NewUomid == BUomId) { //��ⵥλת��Ϊ������λ
					row.PriorRpUom = Number(PriorRpUom).div(confac);
					row.PriorSpUom = Number(PriorSpUom).div(confac);
					row.ResultRpUom = Number(ResultRpUom).div(confac);
					row.ResultSpUom = Number(ResultSpUom).div(confac);
				} else { //������λת��Ϊ��ⵥλ
					row.PriorRpUom = Number(PriorRpUom).mul(confac);
					row.PriorSpUom = Number(PriorSpUom).mul(confac);
					row.ResultRpUom = Number(ResultRpUom).mul(confac);
					row.ResultSpUom = Number(ResultSpUom).mul(confac);
				}
				row.MarginNow = accDiv(row.ResultSpUom, row.ResultRpUom);
				row.DiffRpUom = accSub(row.ResultRpUom, row.PriorRpUom);
				row.DiffSpUom = accSub(row.ResultSpUom, row.PriorSpUom);
				row.AspUomId = NewUomid;
			},
			onShowPanel: function () {
				$(this).combobox('reload');
			}
		}
	};
	var AdjReasonComData = $.cm({
		ClassName: 'web.DHCSTMHUI.Common.Dicts',
		QueryName: 'GetAdjPriceReason',
		ResultSetType: 'array'
	}, false);
	var AdjReasonCombox = {
		type: 'combobox',
		options: {
			data: AdjReasonComData,
			valueField: 'RowId',
			textField: 'Description',
			required: AdjSpParamObj.AllowSaveReasonEmpty != "Y"
		}
	}
	var InciHandlerParams = function () {
		var Scg = $("#ScgId").combotree('getValue');
		var Obj = {
			StkGrpRowId: Scg,
			StkGrpType: "M",
			BDPHospital:gHospId
		};
		return Obj;
	}
	$("#InciDesc").lookup(InciLookUpOp(InciHandlerParams, '#InciDesc', '#Inci'));
	var HandlerParams = function () {
		var Scg = $("#ScgId").combotree('getValue');
		var Obj = {
			StkGrpRowId: Scg,
			StkGrpType: "M",
			Locdr: "",
			NotUseFlag: "",
			QtyFlag: "Y",
			ToLoc: '',
			ReqModeLimited: "",
			NoLocReq: "",
			HV: "",
			BDPHospital:gHospId
		};
		return Obj;
	}
	var SelectRow = function (row) {
		var SelectRow = AdjPriceGrid.getSelected();
		SelectRow.Inci = row.InciDr;
		SelectRow.InciCode = row.InciCode;
		SelectRow.InciDesc = row.InciDesc;
		SelectRow.Spec = row.Spec;
		var ParamsObj = $UI.loopBlock('Conditions');
		var Params = JSON.stringify(ParamsObj);
		$.cm({
			ClassName: 'web.DHCSTMHUI.INAdjSalePrice',
			MethodName: 'GetItmInfo',
			Inci: row.InciDr,
			Params: Params
		}, function (jsonData) {
			SelectRow.BUomId = jsonData.BUomId;
			SelectRow.ConFacPur = jsonData.ConFacPur;
			SelectRow.PriorSpUom = jsonData.PurSp;
			SelectRow.PriorRpUom = jsonData.PurRp;
			SelectRow.ResultSpUom = jsonData.PurSp;
			SelectRow.ResultRpUom = jsonData.PurRp;
			if ((jsonData.PurSp != 0) && (jsonData.PurRp != 0)) {
				var margin = accDiv(jsonData.PurSp, jsonData.PurRp);
				SelectRow.MarginNow = margin.toFixed(3);
			}
			SelectRow.MaxSp = jsonData.MaxSp;
			SelectRow.MarkTypeDesc = jsonData.MarkTypeDesc;
			SelectRow.StkCatDesc = jsonData.StkCatDesc;
			SelectRow.WarrentNo = jsonData.WarrentNo;
			SelectRow.WnoDate = jsonData.WnoDate;
			SelectRow.AspUomId = jsonData.PUomId;
			SelectRow.AspUomDesc = jsonData.PUomDesc;
			//20180912Ĭ����һ�е���ԭ��
			if (AdjSpParamObj.DefaAspReason == "Y") {
				var rowCount = AdjPriceGrid.getRows().length;
				if (rowCount > 1) {
					var rows = AdjPriceGrid.getRows();
					var tmpAdjReasonId = rows[rowCount - 2]["AdjReasonId"];
					var tmpAdjReason = rows[rowCount - 2]["AdjReason"];
					SelectRow.AdjReasonId = tmpAdjReasonId;
					SelectRow.AdjReason = tmpAdjReason;
				}
			}
			SelectRow.DiffSpUom = 0;
			SelectRow.DiffRpUom = 0;
			SelectRow.AdjSPCat="�ֶ�����";
			var Today = DateFormatter(new Date());
			var Tomorrow = DateFormatter(DateAdd(new Date(), 'd', 1));
			SelectRow.AdjDate = Today;
			SelectRow.PreExecuteDate = Tomorrow;
			setTimeout(function () {
				AdjPriceGrid.refreshRow();
				AdjPriceGrid.startEditingNext('InciDesc');
			}, 0);
		});
	}
	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			Query()
		}
	});
	function Query() {
		var ParamsObj = $UI.loopBlock('Conditions');
		ParamsObj = jQuery.extend(true, ParamsObj, {
			Status: "No"
		});
		if (isEmpty(ParamsObj.StartDate)) {
			$UI.msg('alert', '��ʼ���ڲ���Ϊ��!')
			return;
		}
		if (isEmpty(ParamsObj.EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���Ϊ��!')
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		AdjPriceGrid.load({
			ClassName: 'web.DHCSTMHUI.INAdjSalePrice',
			QueryName: 'QueryAspInfo',
			Params: Params,
			rows:99999
		});
	}
	$UI.linkbutton('#ClearBT', {
		onClick: function () {
			ClearMain();
		}
	});
	var ClearMain = function () {
		$UI.clearBlock('#Conditions');
		$UI.clear(AdjPriceGrid);
		SetDefaValues()

	}
	function CheckBeforeSave() {
		AdjPriceGrid.endEditing();
		var RowsData = AdjPriceGrid.getRows();
		for (var i = 0; i < RowsData.length; i++) {
			var ResultSp = parseFloat(RowsData[i].ResultSpUom);
			var ResultRp = parseFloat(RowsData[i].ResultRpUom);
			var PreExecuteDate = RowsData[i].PreExecuteDate;
			var InciDesc = RowsData[i].InciDesc;
			var MaxSp = parseFloat(RowsData[i].MaxSp);
			var row = i + 1;
			if (ResultSp == null || ResultSp <= 0) {
				$UI.msg('alert', '��' + row + '��' + InciDesc + '�����ۼ۲���С�ڻ����0!');
				return false;
			}
			if (PreExecuteDate == null) {
				$UI.msg('alert', '��' + row + '��' + InciDesc + '�ƻ���Ч���ڲ���Ϊ��!');
				return false;
			}
			if(Number(ResultSp) < Number(ResultRp)){ 
			   $UI.msg('alert','��' + row + '��' + InciDesc + '�����ۼ۲���С�ڻ���ڵ������');
			   return false;
			}
			var Today = DateFormatter(new Date());
			if (PreExecuteDate <= Today) {
				$UI.msg('alert', '��' + row + '��' + InciDesc + "�ƻ���Ч���ڲ���С�ڻ���ڵ�ǰ����!");
				return false;
			}
			if ((AdjSpParamObj.ValidateMaxSp == "Y") && (ResultSp > MaxSp)) {
				$UI.msg('alert', '��' + row + '��' + InciDesc + "�����ۼ۲��ܴ�������ۼ�!");
				return false;
			}
		}
		return true;
	}
	var Save = function () {
		var MainObj = $UI.loopBlock('#Conditions');
		var Main = JSON.stringify(MainObj);
		var Detail = AdjPriceGrid.getChangesData('Inci');
		if (Detail === false) {
			return
		}; //��֤δͨ��  ���ܱ���
		if (isEmpty(Detail)) {
			$UI.msg('alert', 'û����Ҫ����ĵ�����Ϣ!');
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.INAdjSalePrice',
			MethodName: 'Save',
			Main: Main,
			Detail: JSON.stringify(Detail)
		}, function (jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				var AdpNo = $("#AdjspNo").val();
				if (AdpNo == "") {
					$("#AdjspNo").val(jsonData.rowid);
				}
				Query();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	var AdjPriceCm = [[{
				title: 'RowId',
				field: 'RowId',
				hidden: true
			}, {
				title: "���۵���",
				field: 'AspNo',
				width: 180
			}, {
				title: '����RowId',
				field: 'Inci',
				hidden: true
			}, {
				title: '���ʴ���',
				field: 'InciCode',
				width: 100
			}, {
				title: '��������',
				field: 'InciDesc',
				width: 150,
				editor: InciEditor(HandlerParams, SelectRow)
			}, {
				title: "���",
				field: 'Spec',
				width: 100
			}, {
				title: "���۵�λ",
				field: 'AspUomId',
				width: 100,
				align: 'right',
				formatter: CommonFormatter(UomCombox, 'AspUomId', 'AspUomDesc'),
				editor: UomCombox
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
				title: "��ǰ�ۼ�",
				field: 'PriorSpUom',
				width: 100,
				align: 'right'
			}, {
				title: "��ǰ����",
				field: 'PriorRpUom',
				width: 100,
				align: 'right'
			}, {
				title: "�������",
				field: 'ResultRpUom',
				width: 100,
				align: 'right',
				editor: ((AdjSpParamObj.AllowAdjRp == 'Y') && (sssAspType != "SP")) ? {
					type: 'numberbox',
					options: {
						required: true,
						min:0,
						precision:GetFmtNum('FmtRA'),
						onChange: function () {
							if ((AdjSpParamObj.CalSpByMarkType == 1)&&(sssAspType != "RP")) {
								ChangeSp(this);
							}
						}
					}
				}
				 : {
					type: 'numberbox',
					options: {
						disabled: true,
						min:0,
						precision:GetFmtNum('FmtRA')
					}
				}
			}, {
				title: "�����ۼ�",
				field: 'ResultSpUom',
				width: 100,
				align: 'right',
				editor: ((AdjSpParamObj.AllowAdjSp == 'Y') && (sssAspType != "RP")) ? {
					type: 'numberbox',
					options: {
						required: true,
						min:0,
						precision:GetFmtNum('FmtSA')
					}
				}
				 : {
					type: 'numberbox',
					options: {
						disabled: true,
						min:0,
						precision:GetFmtNum('FmtSA')
					}
				}
			}, {
				title: "��ǰ�ӳ�",
				field: 'MarginNow',
				width: 100,
				align: 'right'
			}, {
				title: "���(�ۼ�)",
				field: 'DiffSpUom',
				width: 100,
				align: 'right'
			}, {
				title: "���(����)",
				field: 'DiffRpUom',
				width: 100,
				align: 'right'
			}, {
				title: "����ۼ�",
				field: 'MaxSp',
				width: 100,
				align: 'right'
			}, {
				title: "�ƻ���Ч����",
				field: 'PreExecuteDate',
				width: 120,
				align: 'left',
				editor: {
					type: 'datebox'
				}
			}, {
				title: "�Ƶ�����",
				field: 'AdjDate',
				width: 120,
				align: 'left'
			}, {
				title: "ʵ����Ч����",
				field: 'ExecuteDate',
				width: 120,
				align: 'left'
			}, {
				title: "��������",
				field: 'MarkTypeDesc',
				width: 120,
				align: 'left'
			}, {
				title: "����ļ���",
				field: 'WarrentNo',
				width: 120,
				align: 'left',
				editor: {
					type: 'text'
				}
			}, {
				title: "����ļ�����",
				field: 'WnoDate',
				width: 120,
				align: 'left',
				editor: {
					type: 'datebox'
				}
			}, {
				title: "��Ʊ��",
				field: 'InvNo',
				width: 120,
				align: 'left',
				editor: {
					type: 'text'
				}
			}, {
				title: "��Ʊ����",
				field: 'InvDate',
				width: 120,
				align: 'left',
				editor: {
					type: 'datebox'
				}
			}, {
				title: "����ԭ��",
				field: 'AdjReasonId',
				width: 120,
				align: 'left',
				formatter: CommonFormatter(AdjReasonCombox, 'AdjReasonId', 'AdjReason'),
				editor: AdjReasonCombox
			}, {
				title: "������",
				field: 'AdjUserName',
				width: 100,
				align: 'left'
			}, {
				title: "������",
				field: 'StkCatDesc',
				width: 100,
				align: 'left'
			}, {
				title: "��������",
				field: 'AdjSPCat',
				width: 100,
				align: 'left' //,hidden: true
			}
		]];
	var AdjPriceGrid = $UI.datagrid('#AdjPriceGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.INAdjSalePrice',
				QueryName: 'QueryAspInfo',
				rows:99999
			},
			deleteRowParams: {
				ClassName: 'web.DHCSTMHUI.INAdjSalePrice',
				MethodName: 'jsDelete'
			},
			columns: AdjPriceCm,
			sortName: 'RowId',
			sortOrder: 'Desc',
			showBar: true,
			pagination: false,
			showAddDelItems: true,
			toolbar: [{
					text: '����',
					iconCls: 'icon-save',
					handler: function () {
						if (CheckBeforeSave()) {
							Save();
						}
					}
				}
			],
			onClickCell: function (index, filed, value) {
				AdjPriceGrid.commonClickCell(index, filed, value);
			},
			onEndEdit: function (index, row, changes) {
				var Editors = $(this).datagrid('getEditors', index);
				for (var i = 0; i < Editors.length; i++) {
					var Editor = Editors[i];
					if (Editor.field == 'ResultRpUom') {
						var ResultRpUom = row.ResultRpUom;
						if (isEmpty(ResultRpUom)) {
							$UI.msg('alert', '���۲���Ϊ��!');
							AdjPriceGrid.checked = false;
							return false;
						} else if (ResultRpUom < 0) {
							$UI.msg('alert', '���۲���С��0!');
							AdjPriceGrid.checked = false;
							return false;
						}
						if ((AdjSpParamObj.CalSpByMarkType == 1)&&(sssAspType != "RP")) {
							var Inci = row.Inci;
							var AspUomId = row.AspUomId;
							var Sp = tkMakeServerCall("web.DHCSTMHUI.Common.PriceCommon", "GetMtSp", Inci, AspUomId, ResultRpUom);
							if (Sp == 0) {
								$UI.msg('alert', '�����ۼ�Ϊ0����������ʶ��������Ƿ���ȷ!');
								AdjPriceGrid.checked = false;
								return false;
							}
							row.ResultSpUom = Sp;
						}
						var ResultSpUom = row.ResultSpUom;
						var PriorRpUom = row.PriorRpUom;
						row.MarginNow = accDiv(ResultSpUom, ResultRpUom);
						row.DiffRpUom = accSub(ResultRpUom, PriorRpUom);
					} else if (Editor.field == 'ResultSpUom') {
						var ResultSpUom = row.ResultSpUom;
						var ResultRpUom = row.ResultRpUom;
						var PriorSpUom = row.PriorSpUom;
						if (ResultSpUom < 0) {
							$UI.msg('alert', '�ۼ۲���С��0!');
							AdjPriceGrid.checked = false;
							return false;
						}
						var PriorRpUom = row.PriorRpUom;
						row.MarginNow = accDiv(ResultSpUom, ResultRpUom);
						row.DiffSpUom = accSub(ResultSpUom, PriorSpUom);
					} else if (Editor.field == 'PreExecuteDate') {
						var PreDate = row.PreExecuteDate;
						var NowDate = DateFormatter(new Date());
						if ((!isEmpty(PreDate)) && (FormatDate(NowDate) >= FormatDate(PreDate))) {
							$UI.msg('alert', '�ƻ���Ч���ڲ���С�ڻ���ڵ�ǰ����!');
							AdjPriceGrid.checked = false;
							return false;
						}
					}
				}
			},
			onClickRow: function (index, row) {
				if ((row.AspNo != "") && (row.AspNo != undefined)) {
					$("#AdjspNo").val(row.AspNo);
				}
			}
		});
	function ChangeSp(r) {
		var tr = $(r).closest('tr.datagrid-row');
		var rowindex = parseInt(tr.attr('datagrid-row-index'));
		var Rows = $('#AdjPriceGrid').datagrid('getRows')[rowindex];
		var Inci = Rows.Inci;
		var AspUomId = Rows.AspUomId;
		var Rp = Rows.ResultRpUom;
		var Sp = 0;
		var editors = $('#AdjPriceGrid').datagrid('getEditors', rowindex);
		for (var i = 0; i < editors.length; i++) {
			var editor = editors[i];
			if (editor.field == 'ResultRpUom') {
				Rp = $(editor.target).numberbox('getValue');
				Sp = tkMakeServerCall("web.DHCSTMHUI.Common.PriceCommon", "GetMtSp", Inci, AspUomId, Rp);
			}
			if (editor.field == 'ResultSpUom') {
				$(editor.target).val(Sp);
			}
		}
	}
	//����ȱʡֵ
	function SetDefaValues() {
		var Today = DateFormatter(new Date());
		$('#StartDate').datebox('setValue', Today);
		$('#EndDate').datebox('setValue', Today);
		$('#ScgId').combotree('options')['setDefaultFun']();
	}
	ClearMain();
}
$(init);
