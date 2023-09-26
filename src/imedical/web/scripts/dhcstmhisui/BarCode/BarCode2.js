/*高值条码重新生成*/
var init = function() {
	var Clear=function(){
		$UI.clearBlock('#Conditions');
		$UI.clearBlock('#TB');
		$UI.clear(BarCodeGrid);
		var Dafult={
			StartDate: TrackDefaultStDate(),
			EndDate: TrackDefaultEdDate()
		};
		$UI.fillBlock('#Conditions',Dafult);
	};
	var HandlerParams=function(){
		var Obj={Hv:'Y',StkGrpType:"M"};
		return Obj;
	};
	$("#InciDesc").lookup(InciLookUpOp(HandlerParams,'#InciDesc','#inci'));
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Clear();
		}
	});
	$UI.linkbutton('#PrintBT',{
		onClick: function(){
			var rowsData = BarCodeGrid.getSelections();
			if(isEmpty(rowsData)){
				$UI.msg('alert', '请选择需要打印的条码!');
				return;
			}
			for(var i = 0, Len = rowsData.length; i < Len; i++){
				var BarCode = rowsData[i]['BarCode'];
				PrintBarcode(BarCode, 1);
			}
		}
	});
	$UI.linkbutton('#PrintAllBT',{
		onClick:function(){
			DHCP_GetXMLConfig("DHCSTM_Barcode");
			var rowsData = BarCodeGrid.getRows();
			if(rowsData.length<=0){
				return;
			}
			var count=rowsData.length
			for (var rowIndex = 0; rowIndex < count; rowIndex++) {
				var row = rowsData[rowIndex];
				var BarCode = row.BarCode
				PrintBarcode(BarCode,1);
			}
		}
	});
	
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			Query();
		}
	});
	
	function Query(){
		var ParamsObj=$UI.loopBlock('#Conditions')
		if(isEmpty(ParamsObj.StartDate)){
			$UI.msg('alert','开始日期不能为空!');
			return;
		}
		if(isEmpty(ParamsObj.EndDate)){
			$UI.msg('alert','截止日期不能为空!');
			return;
		}
		
		var Params=JSON.stringify(ParamsObj);
		BarCodeGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'queryRegHVs',
			Params:Params,
			rows:99999
		});
	}
	$UI.linkbutton('#AddBT',{
		onClick:function(){
				SaveBarCode();
		}
	});
	function GetParamsObj(){
		var ParamsObj=$UI.loopBlock('#Conditions');
		return ParamsObj;
	}
	function SaveBarCode(){
		var ParamsObj=$UI.loopBlock('#TB');
		if(isEmpty(ParamsObj.OldBarCode)){
			$UI.msg('alert','原始条码不能为空!');
			return;
		};
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			MethodName: 'NewBarcode',
			Params: JSON.stringify(ParamsObj)
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				$("#BarCodeText").val(jsonData.keyValue.BarCode);
				Query();
			}else{
				$UI.msg('alert',jsonData.msg);
			}
		});
	}
	
	var PhManufacturerParams=JSON.stringify(addSessionParams({StkType:"M"}));
	var PhManufacturerBox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params='+PhManufacturerParams,
			valueField: 'RowId',
			textField: 'Description',
			onBeforeLoad:function(param){
				
			}
		}
	};	
	var VendorParams=JSON.stringify(addSessionParams({APCType:"M",RcFlag:"Y"}));
	var VendorBox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorParams,
			valueField: 'RowId',
			textField: 'Description',
			onSelect:function(record){
				var rows =BarCodeGrid.getRows();
				var row = rows[BarCodeGrid.editIndex]
				row.VenDesc=record.Description
			},
			onShowPanel:function(){
				$(this).combobox('reload')
			}
		}
	};
	
	var BarCodeCm = [[
		{
			field: 'ck',
			checkbox: true
		},{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '物资RowId',
			field: 'InciId',
			hidden: true
		}, {
			title: '代码',
			field: 'InciCode',
			width: 100
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 100
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '数量',
			field: 'Qty',
			width: 50,
			align: 'right',
			editor: {
				type: 'numberbox',
				options: {
					required:true
				}
			}
		}, {
			title: '条码',
			field: 'BarCode',
			width: 200
		}, {
			title: '自带码',
			field: 'OriginalCode',
			width: 200,
			editor: {
				type: 'text',
				options: {
				}
			}
		}, {
			title: '进价',
			field: 'Rp',
			align: 'right',
			width: 100
		}, {
			title: 'Inpoi',
			field: 'Inpoi',
			hidden: 'true',
			width: 100
		}, {
			title: '批号',
			field: 'BatchNo',
			width: 100,
			editor: {
				type: 'text',
				options: {
				}
			}
		}, {
			title: '效期',
			field: 'ExpDate',
			width: 100,
			editor: {
				type: 'datebox',
				options: {
				}
			}
		}, {
			title: '具体规格',
			field: 'SpecDesc',
			width: 100,
			hidden:'true'
		}, {
			title: '生产日期',
			field: 'ProduceDate',
			width: 100,
			editor: {
				type: 'datebox',
				options: {
				}
			}
		}, {
			title: '单位dr',
			field: 'BUomId',
			width: 100,
			hidden: true
		}, {
			title: '单位',
			field: 'BUom',
			width:100
		}, {
			title: '注册证号',
			field: 'CertNo',
			width: 100,
			editor: {
				type: 'text',
				options: {
				}
			}
		}, {
			title: '注册证效期',
			field: 'CertExpDate',
			width: 100,
			editor: {
				type: 'datebox',
				options: {
				}
			}
		}, {
			title: '供应商',
			field: 'VendorId',
			width:120,
			formatter: CommonFormatter(VendorBox,'VendorId','VendorDesc'),
			editor:VendorBox
		}, {
			title: '厂商',
			field: 'ManfId',
			width: 100,
			formatter: CommonFormatter(PhManufacturerBox,'ManfId','Manf'),
			editor: PhManufacturerBox
		}, {
			title: 'DetailSubId',
			field: 'OrderDetailSubId',
			width:100,
			hidden: true
		}, {
			title: '随行单号',
			field: 'SxNo',
			width:100,
			hidden: false
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
		}
	]];
	
	var BarCodeGrid = $UI.datagrid('#BarCodeGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'queryRegHVs',
			rows:99999
		},
		toolbar: '#TB',
		columns: BarCodeCm,
		singleSelect: false
	})
	Clear();
}
$(init);
