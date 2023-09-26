var ImportSciPoSearch=function(Fn){
	$HUI.dialog('#ImportBySciPo').open();
	
	$HUI.combobox('#SCIPoVendor',{
		valueField: 'RowId',
		textField: 'Description'
	});
	$HUI.combobox('#SCIPoReqLoc',{
		valueField: 'RowId',
		textField: 'Description'
	});

	$('#SCISxNo').bind('keydown',function(event){
		if(event.keyCode == "13"){
			var SxNo = $(this).val();
			if(isEmpty(SxNo)){
				return;
			}
			try{
				var SxNoObj = eval('(' + SxNo + ')');
				SxNo = SxNoObj['text'];
				$(this).val(SxNo);
			}catch(e){}
			SCIPoQuery();
		}
	});
	
	function SCIPoQuery(){
		var SxNo = $('#SCISxNo').val();
		if(isEmpty(SxNo)){
			$UI.msg('alert','请输入随行单号!');
			return;
		}
		var HVFlag = 'Y';
		$.cm({
			ClassName: 'web.DHCSTMHUI.ServiceForSCI',
			MethodName: 'getOrderDetail',
			SxNo: SxNo,
			HVFlag: HVFlag
		},function(jsonData){
			if(!isEmpty(jsonData['Main']) && !isEmpty(jsonData['Detail'])){
				if(jsonData['Detail']['total'] > 0){
					$UI.fillBlock('#ImportBySciPo',jsonData['Main']);
					PoSciDetailGrid.loadData(jsonData['Detail']);
				}else{
					$UI.msg('alert', '未找到符合的单据明细,请确认是否高值订单!');
				}
			}else{
				$UI.msg('alert', '该单据不存在,或已处理!');
			}
		});
	}
	
	$UI.linkbutton('#PoSciClearBT',{
		onClick:function(){
			Clear();
		}
	});
	
	function Clear(){
		$UI.clearBlock('#SearchByPoSciConditions');
		$UI.clear(PoSciDetailGrid);
	}
	
	$UI.linkbutton('#PoSciQueryBT',{
		onClick:function(){
			SCIPoQuery();
		}
	});
	
	$UI.linkbutton('#PoSciReturnBT',{
		onClick:function(){
			SCIPoReg();
		}
	});
	
	function SCIPoReg(){
		var MainObj = {};
		MainObj['CreateLoc'] = $HUI.combobox('#CreateLoc').getValue();
		var MainInfo = JSON.stringify(addSessionParams(MainObj));

		var RegRows = [];
		var Rows = PoSciDetailGrid.getRows();
		var Len = Rows.length;
		if(Len == 0){
			$UI.msg('alert', '没有需要导入的明细!');
			return;
		}
		for(var i = 0; i < Len; i++){
			var Row = Rows[i];
			var RegRow = {};
			RegRow['InciId'] = Row['IncId'];
			RegRow['BarCode'] = Row['BarCode'];
			RegRow['Qty'] = Row['AvaBarcodeQty'];			//???
			//RegRow['OriginalCode'] = Row['OriginalCode'];			//自带条码(唯一)
			RegRow['Inpoi'] = Row['PoItmId'];
			RegRow['BatchNo'] = Row['BatNo'];
			RegRow['ExpDate'] = Row['ExpDate'];
			//RegRow['SpecDesc'] = Row[''];
			//RegRow['ProduceDate'] = Row[''];
			RegRow['CertNo'] = Row['CerNo'];
			RegRow['CertExpDate'] = Row['CerExpDate'];
			RegRow['Rp'] = Row['Rp'];
			//RegRow['ManfId'] = Row[''];
			//RegRow['VendorId'] = Row[''];
			RegRow['OrderDetailSubId'] = Row['OrderDetailSubId'];
			//RegRow['SxNo'] = Row[''];
			RegRow['OldOriginalCode'] = Row['OriginalCode'];		//自带条码(不唯一)
			RegRows.push(RegRow);
		}
		var ListDetail = JSON.stringify(RegRows);
		
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			MethodName: 'RegHV',
			MainInfo: MainInfo,
			ListDetail: ListDetail
		},function(jsonData){
			hideMask();
			if(jsonData.success === 0){
				var RowIdStr = jsonData.rowid;
				Fn(RowIdStr);
				$UI.msg('success', jsonData.msg);
				$HUI.dialog('#ImportBySciPo').close();
			}else{
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	var PoSciDetailCm = [[{
			title : "RowId",
			field : 'PoItmId',
			width : 100,
			hidden : true
		}, {
			title : '物资id',
			field : 'IncId',
			width : 80
		}, {
			title : '物资代码',
			field : 'IncCode',
			width : 80
		}, {
			title : '物资名称',
			field : 'IncDesc',
			width : 230
		}, {
			title : "规格",
			field : 'Spec',
			width : 100
		}, {
			title : "高值条码",
			field : 'BarCode',
			width : 200
		}, {
			title : "自带批次码",
			field : 'OriginalCode',
			width : 200
		}, {
			title : "高值标志",
			field : 'HighValueFlag',
			formatter : BoolFormatter,
			width : 80
		}, {
			title : "数量",
			field : 'AvaBarcodeQty',
			width : 90
		}, {
			title : "进价",
			field : 'Rp',
			width : 100
		}, {
			title : "售价",
			field : 'Sp',
			width : 60
		}, {
			title : "单位",
			field : 'PurUom',
			width : 80
		}, {
			title : "订购数量",
			field : 'PurQty',
			width : 90
		}, {
			title : "已入库数量",
			field : 'ImpQty',
			width : 90
		}, {
			title : "已生成数量",
			field : 'BarcodeQty',
			width : 90
		},{
			title : "注册证号码",
			field : 'CerNo',
			width : 90
		},{
			title : "注册证效期",
			field : 'CerExpDate',
			width : 90
		},{
			title : "批号",
			field : 'BatNo',
			width : 90
		},{
			title : "效期",
			field : 'ExpDate',
			width : 90
		},{
			title : 'SCI发货单Id',
			field : 'OrderDetailSubId',
			hidden : true,
			width : 100
		}
	]];
	
	var PoSciDetailGrid = $UI.datagrid('#PoSciDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.ServiceForSCI',
			MethodName: 'getOrderDetail'
		},
		columns: PoSciDetailCm
	});
	
	Clear();
}