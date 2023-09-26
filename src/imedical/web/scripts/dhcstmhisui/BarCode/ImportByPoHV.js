/*
订单查询
*/
var ImportPoSearch=function(Fn){
	$HUI.dialog('#ImportByPo',{
		width: gWinWidth,
		height: gWinHeight
	}).open();
	
	var Clear = function(){
		$UI.clearBlock('#ImportByPoConditions');
		$UI.clear(PoMainGrid);
		$UI.clear(PoDetailGrid);
		
		var DefaPoData = {
			PoStartDate: TrackDefaultStDate(),
			PoEndDate: TrackDefaultEdDate(),
			PoRecLoc: gLocObj
		};
		$UI.fillBlock('#ImportByPoConditions', DefaPoData);
	}
	
	var PRecLocParams=JSON.stringify(addSessionParams({Type:"Login"}));
	var PRecLocBox = $HUI.combobox('#PoRecLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+PRecLocParams,
			valueField: 'RowId',
			textField: 'Description'
	});	
	var VendorParams=JSON.stringify(addSessionParams({APCType:"M",RcFlag:"Y"}));
	var VendorBox = $HUI.combobox('#VendorBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$UI.linkbutton('#PoQueryBT',{
		onClick:function(){
			PoQuery();
		}
	});
	function PoQuery(){
		var ParamsObj=$CommonUI.loopBlock('#ImportByPoConditions')
		if(isEmpty(ParamsObj.PoStartDate)){
			$UI.msg('alert', '开始日期不能为空!');
			return;
		}
		if(isEmpty(ParamsObj.PoEndDate)){
			$UI.msg('alert', '截止日期不能为空!');
			return;
		}
		if(isEmpty(ParamsObj.PoRecLoc)){
			$UI.msg('alert', '入库科室不能为空!');
			return;
		}	
		var Params=JSON.stringify(ParamsObj);
		PoMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'QueryPo',
			Params:Params,
			sort:"",
			order:""
		});
	}
	
	$UI.linkbutton('#PoClearBT',{
		onClick:function(){
			Clear();
		}
	});
	$UI.linkbutton('#PoReturnBT',{
		onClick:function(){
			var Row=PoMainGrid.getSelected();
			if(isEmpty(Row)){
				$UI.msg('alert', '请选择要返回的订单!');
				return;
			}
			var VendorId = Row.VenId;
			var VendorDesc = Row.Vendor;
			var rowsData = PoDetailGrid.getData();   //取grid所有记录
			Fn(rowsData,VendorId,VendorDesc);
			$HUI.dialog('#ImportByPo').close();
		}
	});
	var PoMainCm = [[{
			title : "RowId",
			field : 'PoId',
			width : 100,
			hidden : true
		}, {
			title : "订单单号",
			field : 'PoNo',
			width : 120
		}, {
			title : "供应商id",
			field : 'VenId',
			width : 50,
			hidden: true
		}, {
			title : "供应商",
			field : 'Vendor',
			width : 150
		}, {
			title : '订购科室',
			field : 'PoLoc',
			width : 150
		}, {
			title : '申购科室',
			field : 'ReqLoc',
			width : 150
		}, {
			title : '订单日期',
			field : 'PoDate',
			width : 90
		}
	]];
	
	var PoMainGrid = $UI.datagrid('#PoMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'QueryPo'
		},
		columns: PoMainCm,
		onSelect:function(index, row){
			PoDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCItmTrack',
				QueryName: 'INPOItmQuery',
				Parref: row.PoId
			});
		},
		onDblClickRow:function(index, row){
			Fn(row.PoId);
			$HUI.dialog('#ImportByPo').close();
		},
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				PoMainGrid.selectRow(0);
			}
		}
	});
	
	var PoDetailCm = [[{
			title : "RowId",
			field : 'PoItmId',
			width : 100,
			hidden : true
		}, {
			title : '物资id',
			field : 'IncId',
			hidden : true,
			width : 80
		}, {
			title : '物资代码',
			field : 'IncCode',
			width : 80
		}, {
			title : '物资名称',
			field : 'IncDesc',
			width : 200
		}, {
			title : "规格",
			field : 'Spec',
			width : 80
		}, {
			title : "数量",
			field : 'AvaQty',
			align : 'right',
			width : 60
		}, {
			title : "进价",
			field : 'Rp',
			align : 'right',
			width : 60
		}, {
			title : "单位id",
			field : 'PurUomId',
			width : 50,
			hidden : true
		}, {
			title : "单位",
			field : 'PurUom',
			width : 50
		}, {
			title : "订购数量",
			field : 'PurQty',
			align : 'right',
			width : 90
		}, {
			title : "已入库数量",
			field : 'ImpQty',
			align : 'right',
			width : 90
		}, {
			title : "已生成数量",
			field : 'BarcodeQty',
			align : 'right',
			width : 90
		},{
			title : "注册证号码",
			field : 'CertNo',
			width : 90
		},{
			title : "注册证效期",
			field : 'CertExpDate',
			width : 90
		}	
	]];
	
	var PoDetailGrid = $UI.datagrid('#PoDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'INPOItmQuery'
		},
		columns: PoDetailCm
	})
	Clear();
	PoQuery();
}