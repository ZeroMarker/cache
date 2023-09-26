/*��ⵥ���*/
var init = function () {
	var Clear = function () {
		$UI.clearBlock('#FindConditions');
		$UI.clear(InGdRecMainGrid);
		$UI.clear(InGdRecDetailGrid);
		//���ó�ʼֵ ����ʹ������
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
				$UI.msg('alert', '��ѡ����Ҫ��ӡ����Ϣ!');
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
				$UI.msg('alert', '��ѡ����Ҫ��ӡ����Ϣ!');
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
				title: "��ⵥ��",
				field: 'IngrNo',
				width: 120
			}, {
				title: '������',
				field: 'RecLoc',
				width: 150
			}, {
				title: '���տ���',
				field: 'ReqLocDesc',
				width: 150
			}, {
				title: "��Ӧ��",
				field: 'Vendor',
				width: 200
			}, {
				title: "�ʽ���Դ",
				field: 'SourceOfFund',
				width: 200
			}, {
				title: '������',
				field: 'CreateUser',
				width: 70
			}, {
				title: '��������',
				field: 'CreateDate',
				width: 90
			}, {
				title: '�����',
				field: 'AuditUser',
				width: 70
			}, {
				title: '�������',
				field: 'AuditDate',
				width: 90
			}, {
				title: "������",
				field: 'PoNo',
				width: 120
			}, {
				title: "�������",
				field: 'IngrType',
				width: 80
			}, {
				title: "���۽��",
				field: 'RpAmt',
				width: 100,
				align: 'right'
			}, {
				title: "�ۼ۽��",
				field: 'SpAmt',
				width: 100,
				align: 'right'
			}, {
				title: "�������",
				field: 'Margin',
				width: 100,
				align: 'right'
			}, {
				title: "��ע",
				field: 'InGrRemarks',
				width: 100
			}, {
				title: "���ͱ�־",
				field: 'GiftFlag',
				width: 100
			}, {
				title: "���ۻ�Ʊ��־",
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
				title: "���״̬",
				field: 'Audit',
				width: 60
			}, {
				title: "��ӡ����",
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
				title: '���ʴ���',
				field: 'IncCode',
				width: 80
			}, {
				title: '��������',
				field: 'IncDesc',
				width: 230
			}, {
				title: '��ֵ����',
				field: 'HVBarCode',
				width: 80
			}, {
				title: '�Դ�����',
				field: 'OrigiBarCode',
				width: 80
			}, {
				title: '���',
				field: 'Spec',
				width: 80
			}, {
				title: "����",
				field: 'Manf',
				width: 180
			}, {
				title: "����id",
				field: 'Inclb',
				width: 70,
				hidden: true
			}, {
				title: "����",
				field: 'BatchNo',
				width: 90
			}, {
				title: "��Ч��",
				field: 'ExpDate',
				width: 100
			}, {
				title: "��λ",
				field: 'IngrUom',
				width: 80
			}, {
				title: "����",
				field: 'RecQty',
				width: 80,
				align: 'right'
			}, {
				title: "����",
				field: 'Rp',
				width: 60,
				align: 'right'
			}, {
				title: "�ۼ�",
				field: 'Sp',
				width: 60,
				align: 'right'
			}, {
				title: "��Ʊ��",
				field: 'InvNo',
				width: 80,
				editor: {
					type: 'text'
				}
			}, {
				title: "��Ʊ����",
				field: 'InvDate',
				width: 100,
				editor: {
					type: 'datebox'
				}
			}, {
				title: "��Ʊ���",
				field: 'InvMoney',
				width: 100,
				align: 'right',
				editor: {
					type: 'numberbox'
				}
			}, {
				title: "���۽��",
				field: 'RpAmt',
				width: 100,
				align: 'right'
			}, {
				title: "�ۼ۽��",
				field: 'SpAmt',
				width: 100,
				align: 'right'
			}, {
				title: "�������",
				field: 'Margin',
				width: 100,
				align: 'right'
			}, {
				title: "���е���",
				field: 'SxNo',
				width: 80
			}, {
				title: "���۵�״̬",
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
			$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
			return false;
		}
		if (isEmpty(ParamsObj.EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
			return false;
		}
		if (isEmpty(ParamsObj.FRecLoc)) {
			$UI.msg('alert', '�����Ҳ���Ϊ��!');
			return false;
		}
		if (isEmpty(ParamsObj.AuditFlag)) {
			$UI.msg('alert', '�Ƿ���˱�־����Ϊ��!');
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
				$UI.msg('alert', IngrNo + '��ⵥ�����!');
				return false;
			}
			var IngrId = RowsData[i].IngrId;
			var Oerecflag = tkMakeServerCall("web.DHCSTMHUI.DHCINGdRec", "GetOeriRecFlag", IngrId);
			if ((Oerecflag != "Y") && (UseItmTrack) && (CheckHighValueLabels("G", IngrId) == false)) {
				$UI.msg('alert', IngrNo + '��ֵ�������쳣!');
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
					$UI.msg('alert', '��ѡ����Ҫ��˵ĵ���!');
					return false;
				}
				if (IngrParamObj.ConfirmBeforeAudit == "Y") {
					$UI.confirm('����Ҫ�����ѡ����,�Ƿ����?', '', '', IngrAudit);
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
			$UI.msg('alert', 'û����Ҫ��˵ĵ���!');
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
				$UI.msg('success', "��:" + Allcnt + "��¼,�ɹ�:" + Succnt + "��");
				if (failcnt > 0) {
					$UI.msg('error', "ʧ��:" + failcnt + "��;" + ErrInfo);
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
			$UI.msg('alert', '����Ҫ�������ϸ��Ϣ!');
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
