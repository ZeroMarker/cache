var init = function() {

	/*--��ť�¼�--*/
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			QueryMain()
		}
	});
	function QueryMain() {
		$UI.clear(OutMatMainGrid);
		//$UI.clear(OutMatDetailGrid);
		var ParamsObj = $UI.loopBlock('#MainConditions');
		if (isEmpty(ParamsObj.StartDate)) {
			$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
			return false;
		}
		if (isEmpty(ParamsObj.EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
			return false;
		}
		if (isEmpty(ParamsObj.RecLoc)) {
			$UI.msg('alert', '���տ��Ҳ���Ϊ��!');
			return false;
		}
		var Params = JSON.stringify(ParamsObj);
		$UI.setUrl(OutMatMainGrid);
		OutMatMainGrid.load({
			ClassName: 'web.DHCSTMHUI.MatItmDsip',
			QueryName: 'QueryMain',
			Params: Params
		});
	}
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Clear()
		}
	});
	function Clear(){
		$UI.clearBlock('#MainConditions');
		$UI.clear(OutMatMainGrid);
		//$UI.clear(OutMatDetailGrid);
		Default();
	}
	var Default=function(){
		///���ó�ʼֵ ����ʹ������
		var DefaultValue={
			StartDate:DateFormatter(new Date()),
			EndDate:DateFormatter(new Date()),
			RecLoc:gLocId
		};
		$UI.fillBlock('#MainConditions',DefaultValue);
	}
	$UI.linkbutton('#DispBT',{
		onClick:function(){
			OutMatDisp()
		}
	});
	function OutMatDisp() {
		var RowsData = OutMatMainGrid.getSelections();
		if ((isEmpty(RowsData)) || (RowsData.length == 0)) {
			$UI.msg('alert', '��ѡ����Ҫ���ŵ���ϸ!');
			return false;
		}
		var disStr = "";
		for (var i = 0; i < RowsData.length; i++) {
			var dspstatus = RowsData[i].dspstatus;
			var incidesc= RowsData[i].incidesc;
			var patienname= RowsData[i].patienname;
			var papmino=RowsData[i].papmino;
			var orditm = RowsData[i].orditm;
			var RowIndex = $('#OutMatMainGrid').datagrid('getRowIndex', RowsData[i]);
			var row = RowIndex + 1;
			var warnmsgtitle = "��������:" + patienname + "\t" + "�ǼǺ�:" + papmino + "\n";
			if (dspstatus == 1) {
				$UI.msg('alert', '��' + row + '��' +warnmsgtitle+"��"+ incidesc+ '�ѷ���!');
				return false;
			}
			if (disStr == "") {
				disStr = orditm;
			} else {
				disStr = disStr + "^" + orditm;
			}
		}
		if (disStr == "") {
			$UI.msg('alert', 'û����Ҫ���ŵ���ϸ!');
			return false;
		}
		var Params = JSON.stringify(sessionObj);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.MatItmDsip',
			MethodName: 'jsMatDisp',
			Params: Params,
			disStr: disStr
		}, function (jsonData) {
			
		})
	
	}
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
	/*--�󶨿ؼ�--*/
	var RecLocParams = JSON.stringify(addSessionParams({
		Type: "All"
	}));
	var RecLocBox = $HUI.combobox('#RecLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+RecLocParams,
		valueField: 'RowId',
		textField: 'Description',
	});
	var ExeLocParams = JSON.stringify(addSessionParams({
		Type: "All"
	}));
	var ExeLocBox = $HUI.combobox('#ExeLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+ExeLocParams,
		valueField: 'RowId',
		textField: 'Description',
		multiple:true,
		rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
		selectOnNavigation:false
	});
	var CardTypeBox = $HUI.combobox('#CardType', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCardType&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var OutMatMainCm = [[
		{
			field: 'ck',
			checkbox: true
		},{
			title:"adm",
			field:'adm',
			width:60,
			hidden:true
		},{
			title:"�վ�Id",
			field:'prt',
			width:60,
			hidden:true
		}, {
			title:"����",
			field:'patienname',
			width:100
		}, {
			title:"�ǼǺ�",
			field:'papmino',
			width:100
		}, {
			title:"�վݺ�",
			field:'prtcode',
			width:150
		}, {
			title:"�շ�����",
			field:'prtdate',
			width:100
		}, {
			title:"�շ�ʱ��",
			field:'prttime',
			width:100
		}, {
			title:"�Ա�",
			field:'papsex',
			width:80
		}, {
			title:"����",
			field:'perold',
			width:80,
			align:'right'
		}, {
			title:"�绰",
			field:'tel',
			width:150,
			align:'right'
		}, {
			title:"��������",
			field:'dspdate',
			width:100
		}, {
			title:"���߿���",
			field:'patlocdesc',
			width:150
		},{
			title:"ҽ����ϸid",
			field:'orditm',
			width:60,
			hidden:true
		},{
			title:"�����id",
			field:'inci',
			width:60,
			hidden:true
		}, {
			title:"���ʴ���",
			field:'incicode',
			width:150
		}, {
			title:"��������",
			field:'incidesc',
			width:200
		}, {
			title:"����",
			field:'qty',
			width:100,
			align: 'right'
		}, {
			title:"��λ",
			field:'dispUomDesc',
			width:80
		}, {
			title:"����",
			field:'Sp',
			width:100,
			align: 'right'
		}, {
			title:"���",
			field:'SpAmt',
			width:100,
			align: 'right'
		}, {
			title:"ҽ��״̬",
			field:'oeflag',
			width:80
		}, {
			title:"ҽʦ",
			field:'orduserName',
			width:80,
			hidden:true
		}, {
			title:"��λ",
			field:'stkbin',
			width:80,
			hidden:true
		}, {
			title:"����",
			field:'manf',
			width:100,
			hidden:true
		}, {
			title:"�����",
			field:'logQty',
			width:80,
			align: 'right'
		}, {
			title:"��;���",
			field:'reservedQty',
			width:80,
			align: 'right'
		}, {
			title:"����״̬",
			field:'dspstatus',
			width:80,
			hidden:true
		}
	]];
	var OutMatMainGrid = $UI.datagrid('#OutMatMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.MatItmDsip',
			QueryName: 'QueryMain',
			rows:99999
		},
		columns: OutMatMainCm,
		showBar:true,
		pagination: false,
		singleSelect:false
		/*onSelect: function (index, row) {
			$UI.setUrl(OutMatDetailGrid)
			OutMatDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.MatItmDsip',
				QueryName: 'QueryDetail',
				Parref: row.Adm,
				rows: 99999
			});
		}*/
	})
	/*var OutMatDetailCm = [[
		{
			field: 'ck',
			checkbox: true
		},{
			title:"ҽ����ϸid",
			field:'Orditm',
			width:60,
			hidden:true
		},{
			title:"�����id",
			field:'Inci',
			width:60,
			hidden:true
		}, {
			title:"���ʴ���",
			field:'Incicode',
			width:150
		}, {
			title:"��������",
			field:'Incidesc',
			width:200
		}, {
			title:"����",
			field:'Qty',
			width:100,
			align: 'right'
		}, {
			title:"��λ",
			field:'DispUomDesc',
			width:80
		}, {
			title:"����",
			field:'Sp',
			width:100,
			align: 'right'
		}, {
			title:"���",
			field:'SpAmt',
			width:100,
			align: 'right'
		}, {
			title:"ҽ��״̬",
			field:'Oeflag',
			width:80
		}, {
			title:"ҽʦ",
			field:'OrduserName',
			width:80
		}, {
			title:"��λ",
			field:'Stkbin',
			width:80
		}, {
			title:"����",
			field:'manf',
			width:100
		}, {
			title:"�����",
			field:'LogQty',
			width:80,
			align: 'right'
		}, {
			title:"��;���",
			field:'ReservedQty',
			width:80,
			align: 'right'
		}, {
			title:"����״̬",
			field:'Dspstatus',
			width:80
		}
	]];
	var OutMatDetailGrid = $UI.datagrid('#OutMatDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.ItmDsip',
			QueryName: 'QueryDetail',
			rows:99999
		},
		columns: OutMatDetailCm,
		showBar:true,
		pagination: false,
		singleSelect:false,
		onClickCell: function(index, filed ,value){
			OutMatDetailGrid.commonClickCell(index,filed,value)
		}
	})*/
	Default();
}
$(init);