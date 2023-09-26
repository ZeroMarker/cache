/*跟台高值清点*/
var init = function () {
	var InciHandlerParams = function () {
		var Obj = {
			StkGrpType: "M"
		};
		return Obj;
	}
	$("#InciDesc").lookup(InciLookUpOp(InciHandlerParams, '#InciDesc', '#Inci'));
	var Clear=function(){
		$UI.clearBlock('#MainConditions');
		$UI.clear(TableHVRecordGrid);
		///设置初始值 考虑使用配置
		var Dafult={
			FromDate: TrackDefaultStDate(),
			ToDate: TrackDefaultEdDate(),
			OrdLoc: gLocObj,
			//INGRFlag: 1,
			TableFlag: "Y"
		};
		$UI.fillBlock('#MainConditions',Dafult)
	}
	var OrdLocParams=JSON.stringify(addSessionParams({Type:"Login"}));
	$HUI.combobox('#OrdLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+OrdLocParams,
			valueField: 'RowId',
			textField: 'Description'
	});	
	
	var VendorBoxParams=JSON.stringify(addSessionParams({APCType:"M",RcFlag:"Y"}));
	$HUI.combobox('#Vendor', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorBoxParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	var SpecDescParams=JSON.stringify(sessionObj)
	var SpecDescbox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSpecDesc&ResultSetType=array&Params='+SpecDescParams,
			valueField: 'Description',
			textField: 'Description',
			onBeforeLoad:function(param){
				var Select=TableHVRecordGrid.getSelected();
				if(!isEmpty(Select)){
					param.Inci = Select['Inci'];
				}
			}
		}
	};
	var VendorCombo = {
		type: 'combobox',
		options : {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorBoxParams,
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			onSelect: function(record){
				var rows = TableHVRecordGrid.getRows();  
				var row = rows[TableHVRecordGrid.editIndex];
				row['Vendor'] = record['Description'];
			}
		}
	};
	
	var MainLocParams=JSON.stringify(addSessionParams({Type:'All'}));	
	var MainLocCombox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+MainLocParams,
			valueField: 'RowId',
			textField: 'Description',
			required:true,
			onSelect:function(record){
				var rows = TableHVRecordGrid.getRows();  
				var row = rows[TableHVRecordGrid.editIndex];
				row.MainLocDesc=record.Description;
			}
		}
	};
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			Query();
		}
	});
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Clear();
		}
	});
	$UI.linkbutton('#SaveBT', {
		onClick: function(){
			Save();
		}
	});
	$UI.linkbutton('#PrintBT', {
		onClick: function(){
			Print();
		}
	});
	$('#PaAdmNo').bind('keypress', function (event) {
		if (event.keyCode == "13") {
			var PaAdmNo = $(this).val();
			if (PaAdmNo == "") {
				$UI.msg('alert', '请输入登记号!');
				return;
			}
			var patinfostr=tkMakeServerCall("web.DHCSTMHUI.HVMatOrdItm", "Pa",PaAdmNo);
			var patinfoarr=patinfostr.split("^");
			var newPaAdmNo=patinfoarr[0];
			var patinfo=patinfoarr[1]+","+patinfoarr[2];
			//var PatNoLen = tkMakeServerCall("web.DHCSTMHUI.DHCMatDisp", "GetPatNoLen");
			//var newPaAdmNo = NumZeroPadding(PaAdmNo, PatNoLen);
			$("#PaAdmNo").val(newPaAdmNo);
			$("#RegInfo").val(patinfo);
		}
	});
	var TableHVRecordCm = [[
		{
			field: 'ck',
			checkbox: true
		},{
			title: 'RowId',
			field: 'RowId',
			saveCol: true,
			hidden:true
		},{
			title: 'Oeori',
			field: 'Oeori',
			hidden:true
		}, {
			title: '物资RowId',
			field: 'Inci',
			hidden: true
		}, {
			title: '代码',
			field: 'InciCode',
			width:100
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width:100
		}, {
			title: '单位',
			field: 'UomDesc',
			width:100
		}, {
			title: '数量',
			field: 'Qty',
			width:100
		}, {
			title: '批号',
			field: 'BatNo',
			saveCol: true,
			width:100,
			editor:{
				type:'text',
				options:{
					}
				}
		}, {
			title: '有效期',
			field: 'ExpDate',
			saveCol: true,
			width:100,
			editor:{
				type:'datebox',
				options:{
					}
				}
		}, {
			title: '具体规格',
			field: 'SpecDesc',
			saveCol: true,
			width:100,
			editable : false,
			formatter: CommonFormatter(SpecDescbox,'SpecDesc','SpecDesc'),
			editor:SpecDescbox
		}, {
			title: 'dhcit',
			field: 'dhcit',
			saveCol: true,
			width:100,
			hidden:true
		}, {
			title: '自带条码',
			field: 'OriginalCode',
			saveCol: true,
			width:100,
			editor:{
				type:'text',
				options:{
					}
				}
		}, {
			title: '条码',
			field: 'BarCode',
			width:100
		}, {
			title: '补录标记',
			field: 'IngrFlag',
			formatter: BoolFormatter,
			align: 'center',
			width: 60
		}, {
			title: '进价',
			field: 'Rp',
			saveCol: true,
			width:100,
			editor:{
				type:'numberbox',
				options:{
					}
				}
		}, {
			title: '售价',
			field: 'Sp',
			width:100
		}, {
			title: '供应商',
			field: 'VendorDr',
			formatter: CommonFormatter(VendorCombo, 'VendorDr', 'Vendor'),
			editor: VendorCombo,
			saveCol: true,
			width: 200
		}, {
			title: '厂商',
			field: 'Manf',
			width:100
		}, {
			title: '患者登记号',
			field: 'PaNo',
			width:100
		}, {
			title: '患者姓名',
			field: 'PaName',
			width:100
		}, {
			title: '患者科室',
			field: 'AdmLoc',
			width:100
		}, {
			title: '医生',
			field: 'Doctor',
			width:100
		}, {
			title: '医嘱日期',
			field: 'OrdDate',
			width:100
		}, {
			title: '医嘱时间',
			field: 'OrdTime',
			width:100
		}, {
			title:"补录入库科室",
			field:'MainLoc',
			width:100,
			saveCol: true,
			formatter: CommonFormatter(MainLocCombox,'MainLoc','MainLocDesc'),
			editor:MainLocCombox
		}
	]];
	var TableHVRecordGrid = $UI.datagrid('#TableHVRecordGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.HVMatOrdItm',
			QueryName: 'HVMatOrdItems'
		},
		columns: TableHVRecordCm,
		showBar:false,
		singleSelect:false,
		onClickCell: function(index, field ,value){	
			TableHVRecordGrid.commonClickCell(index,field,value)
		}
	});
	
	
	function Query(){
		var ParamsObj=$UI.loopBlock('#MainConditions');
		if(isEmpty(ParamsObj['OrdLoc'])){
			$UI.msg('alert','请选择医嘱接收科室!');
			return;
		}
		if(isEmpty(ParamsObj['FromDate'])){
			$UI.msg('alert','开始日期不能为空!');
			return;
		}
		if(isEmpty(ParamsObj['ToDate'])){
			$UI.msg('alert','开始日期不能为空!');
			return;
		}
		var Params=JSON.stringify(ParamsObj);
		TableHVRecordGrid.load({
			ClassName: 'web.DHCSTMHUI.HVMatOrdItm',
			QueryName: 'HVMatOrdItems',
			Params: Params
		});
	}
	function Save(){
		var RowsData = TableHVRecordGrid.getChangesData();
		if (RowsData === false){	//未完成编辑或明细为空
			return;
		}
		if (isEmpty(RowsData)){	//明细不变
			$UI.msg("alert", "没有需要保存的明细!");
			return;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.HVMatOrdItm',
			MethodName: 'SaveHvmInfo',
			ListData: JSON.stringify(RowsData)
		},function(jsonData){
			hideMask();
			if(jsonData.success === 0){
				$UI.msg('success',jsonData.msg);
				Query();
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	}
	
	function Print(){
		var rowsData = TableHVRecordGrid.getSelections();
		if(rowsData.length<=0){
			$UI.msg('alert', '没有要打印的高值条码!');
			return;
		}
		var count=rowsData.length;
		for (var rowIndex = 0; rowIndex < count; rowIndex++) {
			var row = rowsData[rowIndex];
			var BarCode = row.BarCode;
			PrintBarcode(BarCode,1);
		}
	}
	Clear();
}
$(init);