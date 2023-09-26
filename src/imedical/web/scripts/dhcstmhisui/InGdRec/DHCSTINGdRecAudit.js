/*入库单审核*/
var init = function () {
	var Clear = function () {
		$UI.clearBlock('#FindConditions');
		$UI.clear(InGdRecMainGrid);
		$UI.clear(InGdRecDetailGrid);
		//设置初始值 考虑使用配置
		var Dafult = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			FRecLoc: gLocObj,
			AuditFlag: "N",
			FStatusBox: "Y"
		}
		$UI.fillBlock('#FindConditions', Dafult)
		//$('#ScgId').combotree('options')['setDefaultFun']();
	}
	var FRecLocParams = JSON.stringify(addSessionParams({
				Type: "Login"
			}));
	var FRecLocBox = $HUI.combobox('#FRecLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FRecLocParams,
			valueField: 'RowId',
			textField: 'Description'
		});
	var RequestLocParams = JSON.stringify(addSessionParams({
				Type: "All"
			}));
	var RequestLocBox = $HUI.combobox('#RequestLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + RequestLocParams,
			valueField: 'RowId',
			textField: 'Description'
		});
	var CreateUserIdParams = JSON.stringify(addSessionParams({
				LocDr: ""
			}));
	var CreateUserIdBox = $HUI.combobox('#CreateUserId', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=array&Params=' + CreateUserIdParams,
			valueField: 'RowId',
			textField: 'Description'
		});
	var FVendorBoxParams = JSON.stringify(addSessionParams({
				APCType: "M",
				RcFlag: "Y"
			}));
	var FVendorBox = $HUI.combobox('#FVendorBox', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + FVendorBoxParams,
			valueField: 'RowId',
			textField: 'Description'
		});
	var HandlerParams = function(){
		var ScgId = $('#ScgId').combotree('getValue');
		var Locdr = $('#FRecLoc').combobox('getValue');
		var Obj = {StkGrpRowId:ScgId, StkGrpType:'M', Locdr:Locdr,BDPHospital:gHospId};
		return Obj;
	}
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));	
	$('#FInGrNo').bind('keydown', function(event){
		if(event.keyCode == 13){
			QueryIngrInfo();
		}
	});
	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			QueryIngrInfo();
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function () {
			Clear();
		}
	});
	$UI.linkbutton('#SaveInvBT', {
		onClick: function () {
			SaveInvInfo();
		}
	});
	$UI.linkbutton('#PrintBT', {
		onClick: function () {
			var Row = InGdRecMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择需要打印的信息!');
				return false;
			}
			var Rowid = Row.IngrId;
			PrintRec(Rowid);
		}
	});

	$UI.linkbutton('#PrintHVColBT', {
		onClick: function () {
			var Row = InGdRecMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择需要打印的信息!');
				return false;
			}
			var Rowid = Row.IngrId;
			PrintRecHVCol(Rowid);
		}
	});

	var InGdRecMainCm = [[{
				field: "ck",
				checkbox: true
			}, {
				title: "RowId",
				field: 'IngrId',
				width: 100,
				hidden: true
			}, {
				title: "入库单号",
				field: 'IngrNo',
				width: 120
			}, {
				title: '入库科室',
				field: 'RecLoc',
				width: 150
			}, {
				title: '接收科室',
				field: 'ReqLocDesc',
				width: 150
			}, {
				title: "供应商",
				field: 'Vendor',
				width: 200
			}, {
				title: "资金来源",
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
				title: '审核人',
				field: 'AuditUser',
				width: 70
			}, {
				title: '审核日期',
				field: 'AuditDate',
				width: 90
			}, {
				title: "订单号",
				field: 'PoNo',
				width: 120
			}, {
				title: "入库类型",
				field: 'IngrType',
				width: 80
			}, {
				title: "进价金额",
				field: 'RpAmt',
				width: 100,
				align: 'right'
			}, {
				title: "售价金额",
				field: 'SpAmt',
				width: 100,
				align: 'right'
			}, {
				title: "进销差价",
				field: 'Margin',
				width: 100,
				align: 'right'
			}, {
				title: "备注",
				field: 'InGrRemarks',
				width: 100
			}, {
				title: "赠送标志",
				field: 'GiftFlag',
				width: 100
			}, {
				title: "调价换票标志",
				field: 'AdjCheque',
				width: 100
			}, {
				title: "ReqLoc",
				field: 'ReqLoc',
				width: 10,
				hidden: true
			}, {
				title: "Complete",
				field: 'Complete',
				width: 10,
				hidden: true
			}, {
				title: "StkGrp",
				field: 'StkGrp',
				width: 10,
				hidden: true
			}, {
				title: "AuditFlag",
				field: 'AuditFlag',
				width: 10,
				hidden: true
			}, {
				title: "审核状态",
				field: 'Audit',
				width: 60
			}, {
				title: "打印次数",
				field: 'PrintCount',
				width: 80,
				align: 'right'
			}
		]];
	var InGdRecMainGrid = $UI.datagrid('#InGdRecMainGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCINGdRec',
				QueryName: 'Query'
			},
			columns: InGdRecMainCm,
			showBar: true,
			singleSelect: false,
			onSelect: function (index, row) {
				$UI.setUrl(InGdRecDetailGrid)
				InGdRecDetailGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
					QueryName: 'QueryDetail',
					Parref: row.IngrId,
					rows: 99999
				});
			}
		});

	var InGdRecDetailCm = [[{
				title: "RowId",
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
				title: "厂商",
				field: 'Manf',
				width: 180
			}, {
				title: "批次id",
				field: 'Inclb',
				width: 70,
				hidden: true
			}, {
				title: "批号",
				field: 'BatchNo',
				width: 90
			}, {
				title: "有效期",
				field: 'ExpDate',
				width: 100
			}, {
				title: "单位",
				field: 'IngrUom',
				width: 80
			}, {
				title: "数量",
				field: 'RecQty',
				width: 80,
				align: 'right'
			}, {
				title: "进价",
				field: 'Rp',
				width: 60,
				align: 'right'
			}, {
				title: "售价",
				field: 'Sp',
				width: 60,
				align: 'right'
			}, {
				title: "发票号",
				field: 'InvNo',
				width: 80,
				editor: {
					type: 'text'
				}
			}, {
				title: "发票日期",
				field: 'InvDate',
				width: 100,
				editor: {
					type: 'datebox'
				}
			}, {
				title: "发票金额",
				field: 'InvMoney',
				width: 100,
				align: 'right',
				editor: {
					type: 'numberbox'
				}
			}, {
				title: "进价金额",
				field: 'RpAmt',
				width: 100,
				align: 'right'
			}, {
				title: "售价金额",
				field: 'SpAmt',
				width: 100,
				align: 'right'
			}, {
				title: "进销差价",
				field: 'Margin',
				width: 100,
				align: 'right'
			}, {
				title: "随行单号",
				field: 'SxNo',
				width: 80
			}, {
				title: "调价单状态",
				field: 'AdjSpStatus',
				width: 80
			}
		]];

	var InGdRecDetailGrid = $UI.datagrid('#InGdRecDetailGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
				QueryName: 'QueryDetail',
				rows: 99999
			},
			pagination:false,
			columns: InGdRecDetailCm,
			showBar: true,
			onClickCell: function (index, filed, value) {
				InGdRecDetailGrid.commonClickCell(index, filed, value);
			}
		})
	function QueryIngrInfo() {
		$UI.clear(InGdRecMainGrid);
		$UI.clear(InGdRecDetailGrid);
		var ParamsObj = $UI.loopBlock('#FindConditions');
		if (isEmpty(ParamsObj.StartDate)) {
			$UI.msg('alert', '开始日期不能为空!');
			return false;
		}
		if (isEmpty(ParamsObj.EndDate)) {
			$UI.msg('alert', '截止日期不能为空!');
			return false;
		}
		if (isEmpty(ParamsObj.FRecLoc)) {
			$UI.msg('alert', '入库科室不能为空!');
			return false;
		}
		if (isEmpty(ParamsObj.AuditFlag)) {
			$UI.msg('alert', '是否审核标志不能为空!');
			return false;
		}
		var Params = JSON.stringify(ParamsObj);
		$UI.setUrl(InGdRecMainGrid);
		InGdRecMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			QueryName: 'Query',
			Params: Params
		});
	}
	function CheckDataBeforeAudi() {
		var RowsData = InGdRecMainGrid.getSelections();
		for (var i = 0; i < RowsData.length; i++) {
			var AuditFlag = RowsData[i].AuditFlag;
			var IngrNo = RowsData[i].IngrNo;
			if (AuditFlag == "Y") {
				$UI.msg('alert', IngrNo + '入库单已审核!');
				return false;
			}
			var IngrId = RowsData[i].IngrId;
			var Oerecflag = tkMakeServerCall("web.DHCSTMHUI.DHCINGdRec", "GetOeriRecFlag", IngrId);
			if ((Oerecflag != "Y") && (UseItmTrack) && (CheckHighValueLabels("G", IngrId) == false)) {
				$UI.msg('alert', IngrNo + '高值条码数异常!');
				return false;
			}
		}
		return true;
	}
	function AUTOPrint(IdStr) {
		var IngrIdArr = IdStr.split("^");
		for (var i = 0; i < IngrIdArr.length; i++) {
			var Ingrid = IngrIdArr[i];
			var HVFlag = GetCertDocHVFlag(Ingrid, "G");
			var AutoPrintFlag = "Y";
			if (HVFlag == "Y") {
				PrintRecHVCol(Ingrid, AutoPrintFlag);
			} else {
				PrintRec(Ingrid, AutoPrintFlag);
			}
		}
	}
	$UI.linkbutton('#AuditBT', {
		onClick: function () {
			if (CheckDataBeforeAudi()) {
				var RowData = InGdRecMainGrid.getSelections();
				if ((isEmpty(RowData)) || (RowData.length == 0)) {
					$UI.msg('alert', '请选择需要审核的单据!');
					return false;
				}
				if (IngrParamObj.ConfirmBeforeAudit == "Y") {
					$UI.confirm('您将要审核所选单据,是否继续?', '', '', IngrAudit);
				} else {
					IngrAudit();
				}
			}
		}
	});
	function IngrAudit() {
		var RowData = InGdRecMainGrid.getSelections();
		var IngrIdStr = "";
		for (var i = 0; i < RowData.length; i++) {
			var IngrId = RowData[i].IngrId;
			if (IngrIdStr == "") {
				IngrIdStr = IngrId;
			} else {
				IngrIdStr = IngrIdStr + "^" + IngrId;
			}
		}
		if (IngrIdStr == "") {
			$UI.msg('alert', '没有需要审核的单据!');
			return false;
		}
		var Params = JSON.stringify(sessionObj);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			MethodName: 'jsAudit',
			Params: Params,
			IngrIdStr: IngrIdStr
		}, function (jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				QueryIngrInfo();
				var info = jsonData.msg;
				var infoArr = info.split("@");
				var Allcnt = infoArr[0];
				var Succnt = infoArr[1];
				var failcnt = Allcnt - Succnt;
				var ErrInfo = infoArr[2];
				$UI.msg('success', "共:" + Allcnt + "记录,成功:" + Succnt + "条");
				if (failcnt > 0) {
					$UI.msg('error', "失败:" + failcnt + "条;" + ErrInfo);
				}
				var IngrIdStr = jsonData.rowid;
				if ((Succnt > 0) && (IngrParamObj.AutoPrintAfterAudit == "Y")) {
					AUTOPrint(IngrIdStr);
				}
			}
		});
	}
	function SaveInvInfo() {
		var rowsData = InGdRecDetailGrid.getRows();
		if (rowsData.length <= 0) {
			$UI.msg('alert', '无需要处理的明细信息!');
			return false;
		}
		for (var i = 0; i < rowsData.length; i++) {
			var row = rowsData[i];
			var RowId = row.RowId;
			var InvNo = row.InvNo;
			var InvDate = row.InvDate;
			var InvMoney = row.InvMoney;
			var SxNo = row.SxNo;
			var Params = JSON.stringify(addSessionParams({
						TrType: 'G',
						RowId: RowId,
						InvNo: InvNo,
						InvDate: InvDate,
						InvMoney: InvMoney,
						SxNo: SxNo
					}));
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINGdRec',
				MethodName: 'UpdateINV',
				Params: Params
			}, function (jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					QueryIngrInfo();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	}
	Clear();

}
$(init);
