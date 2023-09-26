var init = function() {
	$UI.linkbutton('#ClearBT',{ 
		onClick:function(){
			Clear();
		}
	});
	var Clear=function(){
		$UI.clearBlock('#MainConditions');
		var IngrParamObj = GetAppPropValue('DHCSTIMPORTM');
		function DefaultStDate(){
			var Today = new Date();
			var DefaStartDate = IngrParamObj.DefaStartDate;
			if(isEmpty(DefaStartDate)){
			return Today;
		}
		var EdDate = DateAdd(Today, 'd', parseInt(DefaStartDate));
			return DateFormatter(EdDate);
		}
 
		function DefaultEdDate(){
			var Today = new Date();
			var DefaEndDate = IngrParamObj.DefaEndDate;
			if(isEmpty(DefaEndDate)){
				return Today;
			}
			var EdDate = DateAdd(Today, 'd', parseInt(DefaEndDate));
			return DateFormatter(EdDate);
		}
		var Dafult={
			FromDate: DefaultStDate(),
			ToDate: DefaultEdDate(),
			Loc:gLocObj
			}
		$UI.fillBlock('#MainConditions',Dafult)
		$UI.clear(MatOrdItmGrid);
	}
	$UI.linkbutton('#AuditBT',{ 
		onClick:function(){
			Audit();
		}
	});
	
	function Audit(){
		var RowsData=MatOrdItmGrid.getSelectedData();
		if (RowsData.length <= 0) {
			$UI.msg('alert','请选择要审核的明细!');
			return false;
		}
		var MainObj=JSON.stringify(addSessionParams());
		$.cm({
			ClassName: 'web.DHCSTMHUI.HVMatOrdItm',
			MethodName: 'jsAudit',
			Main:MainObj,
			Detail: JSON.stringify(RowsData)
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				Query();
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			Query();
		}
	});
	function Query(){
		var ParamsObj=$UI.loopBlock('#MainConditions')
		if(isEmpty(ParamsObj.FromDate)){
			$UI.msg('alert','开始日期不能为空!');
			return;
		}
		if(isEmpty(ParamsObj.ToDate)){
			$UI.msg('alert','截止日期不能为空!');
			return;
		}
		ParamsObj.AuditFlag="N"; //未审核
		ParamsObj.INGRFlag="2"; //未入库
		var Params=JSON.stringify(ParamsObj);
		MatOrdItmGrid.load({
			ClassName: 'web.DHCSTMHUI.HVMatOrdItm',
			QueryName: 'HVMatOrdItems',
			Params:Params
		});
	}
	
	var FVendorParams=JSON.stringify(addSessionParams({APCType:"M",RcFlag:"Y"}));
	var FVendorBox = $HUI.combobox('#Vendor', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+FVendorParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	
	var SourceOfFundParams=JSON.stringify(addSessionParams());
	var SourceOfFundBox = $HUI.combobox('#Source', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSourceOfFund&ResultSetType=array&Params='+SourceOfFundParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	var HandlerParams=function(){
		var Scg=$("#ScgStk").combotree('getValue');
		var Obj={StkGrpRowId:Scg,StkGrpType:"M"};
		return Obj
	}
	$("#InciDesc").lookup(InciLookUpOp(HandlerParams,'#InciDesc','#Inci'));
	
	
	var FLocParams=JSON.stringify(addSessionParams({Type:"Login"}));
	var FLocBox = $HUI.combobox('#Loc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+FLocParams,
			valueField: 'RowId',
			textField: 'Description'
	});	
	var FOrdLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var FOrdLocBox = $HUI.combobox('#OrdLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+FOrdLocParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	var VendorParams=JSON.stringify(addSessionParams({APCType:"M",RcFlag:"Y"}));
	var VendorBox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorParams,
			valueField: 'RowId',
			textField: 'Description',
			mode:'remote',
			onSelect:function(record){
				var rows =MatOrdItmGrid.getRows();
				var row = rows[MatOrdItmGrid.editIndex]
				row.Vendor=record.Description
			},
			onShowPanel:function(){
				$(this).combobox('reload')
			}
		}
	}
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
			var patinfo=patinfoarr[1]//+","+patinfoarr[2];
			$("#PaAdmNo").val(newPaAdmNo);
			$("#PatName").val(patinfo);
		}
	});
	var MatOrdCm = [[
		{	field: 'ck',
			checkbox: true,
			width:100
		},{
			title: 'RowId',
			field: 'RowId',
			saveCol: true,
			hidden:true,
			width:100
		}, {
			title: '物资RowId',
			field: 'Inci',
			hidden: true,
			width:100
		}, {
			title: '代码',
			field: 'InciCode',
			width:100
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width:100
		}, {
			title: '规格',
			field: 'Spec',
			width:100
		}, {
			title: '条码',
			field: 'BarCode',
			width:100
		}, {
			title: '入库单',
			field: 'Ingri',
			hidden:true,
			width:100
		}, {
			title: '生成日期',
			field: 'Date',
			width:100
		}, {
			title: '进价',
			field: 'Rp',
			width:100,
			align:'right'
		}, {
			title: '发票金额',
			field: 'InvAmt',
			saveCol: true,
			width:100,
			align:'right'
		}, {
			title: '发票号',
			field: 'InvNo',
			saveCol: true,
			width:100
		}, {
			title: '发票日期',
			field: 'InvDate',
			saveCol: true,
			width:100
		}, {
			title: '批号',
			field: 'BatNo',
			width:100
		}, {
			title: '有效期',
			field: 'ExpDate',
			width:100
		}, {
			title: '入库单号',
			field: 'IngNo',
			width:100
		}, {
			title: '患者登记号',
			field: 'PaNo',
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
			title: '数量',
			field: 'Qty',
			width:100,
			align:'right'
		}, {
			title: '单位',
			field: 'UomDesc',
			width:100
		}, {
			title: '补录接收科室',
			field: 'AdmLoc',
			width:100
		}, {
			title: '患者病区',
			field: 'Ward',
			width:100
		}, {
			title: '床号',
			field: 'Bed',
			width:100
		}, {
			title: '处方号',
			field: 'PrescNo',
			width:100,
			hidden: true
		}, {
			title: '费用状态',
			field: 'FreeStatus',
			width:100,
			hidden: true
		}, {
			title: '费用总额',
			field: 'FeeAmt',
			width:100,
			align:'right'
		}, {
			title: '供应商',
			field: 'Vendor',
			saveCol: true,
			width:100
		}, {
			title: '厂商',
			field: 'Manf',
			width:100
		}, {
			title: '售价',
			field: 'Sp',
			width:100,
			align:'right'
		}, {
			title: '具体规格',
			field: 'SpecDesc',
			width:100
		}
	]];
	var MatOrdItmGrid = $UI.datagrid('#MatOrdItmGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.HVMatOrdItm',
			QueryName: 'HVMatOrdItems'
		},
		columns: MatOrdCm,
		singleSelect:false,
		showBar:false,
		onClickCell: function(index, filed ,value){	
			MatOrdItmGrid.commonClickCell(index,filed,value);
		}
	})
	Clear();
}
$(init);