	function SelBarcode(Fn,carLabel,MachineNoDR,type){
		$("#SelMachineNo").val(MachineNoDR);
		$("#carLabel").val(carLabel);
		$HUI.dialog('#SelReqWin').open();
		$UI.linkbutton('#SelAddQuery', {
			onClick: function(){
				SelReqQuery(carLabel,MachineNoDR);
			}
	});
	function SelReqQuery(carLabel,MachineNoDR){
		var ParamsObj = $UI.loopBlock('#SelReqConditions');
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(SelReqMasterGrid);
		SelReqMasterGrid.load({
			ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeCar',
			QueryName: 'SelectAllWaitingSter',
			Params: Params,
			CarLabel: carLabel,
			MachineNoDR:MachineNoDR
		});
	}
//添加消毒包
	$UI.linkbutton('#SelBarCodeCreateBT',{
		onClick: function(){
			if(type==="IN"){
				SaveItem();
			}else{
				SaveCar();
			}
			
		}
	});
	///装车
	function SaveCar(){
		var Detail = SelReqMasterGrid.getSelectedData();
		if(isEmpty(Detail)){
			$UI.msg('alert', '请选择要添加的数据!');
			return;
		}
		if(isEmpty(carLabel)){
			$UI.msg('alert', '请选择灭菌车!');
			return;
		}
		$.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeCar',
			MethodName: 'jsAddCarByBarCode',
			carLabel: carLabel,
			Detail: JSON.stringify(Detail)
		},function(jsonData){
			if(jsonData.success === 0){
				Fn();
				var info=jsonData.msg;
				$UI.msg('success', "一共添加"+info.split('^')[0]+"个消毒包,成功:"+info.split('^')[1]+"失败:"+info.split('^')[2]);
				$('#SelReqWin').window('close');
			}else{
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	///保存到明细里面
	function SaveItem(){
		var Detail = SelReqMasterGrid.getSelections();
		if(isEmpty(Detail)){
			$UI.msg('alert', '请选择要添加的数据!');
			return;
		}
		$('#SelReqWin').window('close');
		Fn(Detail);
		
	}
	function SelReqDefa(){
		$UI.clearBlock('#SelReqConditions');
		//$("input[name='PackageType'][label='全部']").attr("checked",true); 
		var Dafult = {
			StartDate:DefaultStDate(),
			EndDate:DefaultEdDate
		};
		$UI.fillBlock('#SelReqConditions', Dafult)
		
	}

	var SelReqMasterCm = [[
		{
			field: 'ck',
			checkbox : true
		}, {
			title : "RowId",
			field : 'RowId',
			saveCol : true,
			width : 60,
			sortable : true,
			hidden : true
		}, {
			title : "条码",
			field : 'Label',
			width : 210,
			sortable : true
		}, {
			title : "消毒包名称",
			field : 'PackageName',
			width : 300,
			sortable : true
		}, {
			title : "消毒包属性Dr",
			field : 'PackageTypeDetial',
			width : 100,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			title : "消毒包属性",
			field : 'PackageTypeDetialName',
			width : 170,
			align : 'left',
			sortable : true
		}, {
			title : "打包人",
			field : 'packerName',
			width : 120,
			//renderer: renderStatus,
			sortable : true
		}, {
			title : "审核人",
			field : 'chkerName',
			width : 120,
			sortable : true
		} 
	]];

	var MachineNoDR=$("#SelMachineNo").val();
	var carLabel=$("#carLabel").val();
	var SelReqMasterGrid = $UI.datagrid('#SelReqMasterGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeCar',
			QueryName: 'SelectAllWaitingSter',
			CarLabel: carLabel,
			MachineNoDR:MachineNoDR
		},
		columns: SelReqMasterCm,
		toolbar: '#SelReqWinTB',
		singleSelect: false,
		pagination: true,
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				//SelReqMasterGrid.selectRow(0);
			}
		},
		onDblClickRow: function(index, row){
//			Fn(row['RowId']);
//			$HUI.dialog('#FindWin').close();
		}
	});
	
	

	SelReqDefa();
	SelReqQuery(carLabel,MachineNoDR);

}