var init = function() {

	/*--按钮事件--*/
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
			$UI.msg('alert', '开始日期不能为空!');
			return false;
		}
		if (isEmpty(ParamsObj.EndDate)) {
			$UI.msg('alert', '截止日期不能为空!');
			return false;
		}
		if (isEmpty(ParamsObj.RecLoc)) {
			$UI.msg('alert', '接收科室不能为空!');
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
		///设置初始值 考虑使用配置
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
			$UI.msg('alert', '请选择需要发放的明细!');
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
			var warnmsgtitle = "病人姓名:" + patienname + "\t" + "登记号:" + papmino + "\n";
			if (dspstatus == 1) {
				$UI.msg('alert', '第' + row + '行' +warnmsgtitle+"的"+ incidesc+ '已发放!');
				return false;
			}
			if (disStr == "") {
				disStr = orditm;
			} else {
				disStr = disStr + "^" + orditm;
			}
		}
		if (disStr == "") {
			$UI.msg('alert', '没有需要发放的明细!');
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
	/*--绑定控件--*/
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
		rowStyle:'checkbox', //显示成勾选行形式
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
			title:"收据Id",
			field:'prt',
			width:60,
			hidden:true
		}, {
			title:"姓名",
			field:'patienname',
			width:100
		}, {
			title:"登记号",
			field:'papmino',
			width:100
		}, {
			title:"收据号",
			field:'prtcode',
			width:150
		}, {
			title:"收费日期",
			field:'prtdate',
			width:100
		}, {
			title:"收费时间",
			field:'prttime',
			width:100
		}, {
			title:"性别",
			field:'papsex',
			width:80
		}, {
			title:"年龄",
			field:'perold',
			width:80,
			align:'right'
		}, {
			title:"电话",
			field:'tel',
			width:150,
			align:'right'
		}, {
			title:"发放日期",
			field:'dspdate',
			width:100
		}, {
			title:"患者科室",
			field:'patlocdesc',
			width:150
		},{
			title:"医嘱明细id",
			field:'orditm',
			width:60,
			hidden:true
		},{
			title:"库存项id",
			field:'inci',
			width:60,
			hidden:true
		}, {
			title:"物资代码",
			field:'incicode',
			width:150
		}, {
			title:"物资名称",
			field:'incidesc',
			width:200
		}, {
			title:"数量",
			field:'qty',
			width:100,
			align: 'right'
		}, {
			title:"单位",
			field:'dispUomDesc',
			width:80
		}, {
			title:"单价",
			field:'Sp',
			width:100,
			align: 'right'
		}, {
			title:"金额",
			field:'SpAmt',
			width:100,
			align: 'right'
		}, {
			title:"医嘱状态",
			field:'oeflag',
			width:80
		}, {
			title:"医师",
			field:'orduserName',
			width:80,
			hidden:true
		}, {
			title:"货位",
			field:'stkbin',
			width:80,
			hidden:true
		}, {
			title:"厂家",
			field:'manf',
			width:100,
			hidden:true
		}, {
			title:"库存量",
			field:'logQty',
			width:80,
			align: 'right'
		}, {
			title:"在途库存",
			field:'reservedQty',
			width:80,
			align: 'right'
		}, {
			title:"发放状态",
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
			title:"医嘱明细id",
			field:'Orditm',
			width:60,
			hidden:true
		},{
			title:"库存项id",
			field:'Inci',
			width:60,
			hidden:true
		}, {
			title:"物资代码",
			field:'Incicode',
			width:150
		}, {
			title:"物资名称",
			field:'Incidesc',
			width:200
		}, {
			title:"数量",
			field:'Qty',
			width:100,
			align: 'right'
		}, {
			title:"单位",
			field:'DispUomDesc',
			width:80
		}, {
			title:"单价",
			field:'Sp',
			width:100,
			align: 'right'
		}, {
			title:"金额",
			field:'SpAmt',
			width:100,
			align: 'right'
		}, {
			title:"医嘱状态",
			field:'Oeflag',
			width:80
		}, {
			title:"医师",
			field:'OrduserName',
			width:80
		}, {
			title:"货位",
			field:'Stkbin',
			width:80
		}, {
			title:"厂家",
			field:'manf',
			width:100
		}, {
			title:"库存量",
			field:'LogQty',
			width:80,
			align: 'right'
		}, {
			title:"在途库存",
			field:'ReservedQty',
			width:80,
			align: 'right'
		}, {
			title:"发放状态",
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