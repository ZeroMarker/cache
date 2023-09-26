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
			$UI.msg('alert','��ѡ��Ҫ��˵���ϸ!');
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
			$UI.msg('alert','��ʼ���ڲ���Ϊ��!');
			return;
		}
		if(isEmpty(ParamsObj.ToDate)){
			$UI.msg('alert','��ֹ���ڲ���Ϊ��!');
			return;
		}
		ParamsObj.AuditFlag="N"; //δ���
		ParamsObj.INGRFlag="2"; //δ���
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
				$UI.msg('alert', '������ǼǺ�!');
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
			title: '����RowId',
			field: 'Inci',
			hidden: true,
			width:100
		}, {
			title: '����',
			field: 'InciCode',
			width:100
		}, {
			title: '��������',
			field: 'InciDesc',
			width:100
		}, {
			title: '���',
			field: 'Spec',
			width:100
		}, {
			title: '����',
			field: 'BarCode',
			width:100
		}, {
			title: '��ⵥ',
			field: 'Ingri',
			hidden:true,
			width:100
		}, {
			title: '��������',
			field: 'Date',
			width:100
		}, {
			title: '����',
			field: 'Rp',
			width:100,
			align:'right'
		}, {
			title: '��Ʊ���',
			field: 'InvAmt',
			saveCol: true,
			width:100,
			align:'right'
		}, {
			title: '��Ʊ��',
			field: 'InvNo',
			saveCol: true,
			width:100
		}, {
			title: '��Ʊ����',
			field: 'InvDate',
			saveCol: true,
			width:100
		}, {
			title: '����',
			field: 'BatNo',
			width:100
		}, {
			title: '��Ч��',
			field: 'ExpDate',
			width:100
		}, {
			title: '��ⵥ��',
			field: 'IngNo',
			width:100
		}, {
			title: '���ߵǼǺ�',
			field: 'PaNo',
			width:100
		}, {
			title: 'ҽ��',
			field: 'Doctor',
			width:100
		}, {
			title: 'ҽ������',
			field: 'OrdDate',
			width:100
		}, {
			title: 'ҽ��ʱ��',
			field: 'OrdTime',
			width:100
		}, {
			title: '����',
			field: 'Qty',
			width:100,
			align:'right'
		}, {
			title: '��λ',
			field: 'UomDesc',
			width:100
		}, {
			title: '��¼���տ���',
			field: 'AdmLoc',
			width:100
		}, {
			title: '���߲���',
			field: 'Ward',
			width:100
		}, {
			title: '����',
			field: 'Bed',
			width:100
		}, {
			title: '������',
			field: 'PrescNo',
			width:100,
			hidden: true
		}, {
			title: '����״̬',
			field: 'FreeStatus',
			width:100,
			hidden: true
		}, {
			title: '�����ܶ�',
			field: 'FeeAmt',
			width:100,
			align:'right'
		}, {
			title: '��Ӧ��',
			field: 'Vendor',
			saveCol: true,
			width:100
		}, {
			title: '����',
			field: 'Manf',
			width:100
		}, {
			title: '�ۼ�',
			field: 'Sp',
			width:100,
			align:'right'
		}, {
			title: '������',
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