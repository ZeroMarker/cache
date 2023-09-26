var init = function() {
	var CURRENT_INGR = '', CURRENT_INIT = '';
	$UI.linkbutton('#ClearBT',{ 
		onClick:function(){
			Clear();
		}
	});
	
	$UI.linkbutton('#SaveBT',{ 
		onClick:function(){
			Save();
		}
	});
	
	function Save(){
		var RowsData=MatOrdItmGrid.getSelectedData();
		if (RowsData.length <= 0) {
			$UI.msg('alert','请选择入库明细!');
			return false;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.HVMatOrdItm',
			MethodName: 'SaveInvInfo',
			ListData: JSON.stringify(RowsData)
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
		ParamsObj.AuditFlag="Y";
		var Params=JSON.stringify(ParamsObj);
		MatOrdItmGrid.load({
			ClassName: 'web.DHCSTMHUI.HVMatOrdItm',
			QueryName: 'HVMatOrdItems',
			Params:Params
		});
	}
	$UI.linkbutton('#CreateBT',{ 
		onClick:function(){
			Create();
		}
	});	
	function Create(){
		var ParamsObj=$UI.loopBlock('#MainConditions')
		var Params=JSON.stringify(ParamsObj);
		var RowsData=MatOrdItmGrid.getSelectedData();
		if (RowsData.length <= 0) {
			$UI.msg('alert','请选择入库明细!');
			return false;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.HVMatOrdItm',
			MethodName: 'Create',
			MainInfo: Params,
			ListDetail: JSON.stringify(RowsData)
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				var CurrentInfo=jsonData.rowid;
				var CurrentInfoArr = CurrentInfo.split("^");
				CURRENT_INGR = CurrentInfoArr[0];
				CURRENT_INIT = CurrentInfoArr[1];
				Query();
			}else{
				$UI.msg('error',jsonData.msg);	
			}
		});
	}
	$UI.linkbutton('#CancelBT',{ 
		onClick:function(){
			var params=JSON.stringify(addSessionParams());
			var ParamInfo = tkMakeServerCall("web.DHCSTMHUI.HVMatOrdItm", "GetParamProp",params);
			var paramarr = ParamInfo.split("^");
			var IfCanDoCancelOeRec = paramarr[1];
			if (IfCanDoCancelOeRec != "Y") {
				$UI.msg('alert','您没有权限撤销补录!');
				return false;
			}
			CancelMatOrd()
		}
	});
	function CancelMatOrd(){
		var rowsData = MatOrdItmGrid.getSelections();
		if(rowsData.length<=0){
			$UI.msg('alert','请选择需要处理的医嘱记录!');
			return false;
		}
		var count=rowsData.length;
		var hvs=""
		for (var rowIndex = 0; rowIndex < count; rowIndex++) {
			var row = rowsData[rowIndex];
			var RowId = row.RowId;
			var IngNo=row.IngNo;
			var IngriModifyNo=row.IngriModifyNo;
			if (IngriModifyNo==""){
				$UI.msg('alert','明细未补录!');
			return false;
				}
			if (IngNo=="") {continue;}
			if(hvs==""){
				hvs=RowId;
			}else{
				hvs=hvs+"^"+RowId;
			}
		}
		if(hvs==""){
			$UI.msg('alert','请选择需要处理的医嘱记录!');
			return false;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.HVMatOrdItm',
			MethodName: 'jsCancelMatRecStr',
			hvmatids: hvs
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				Query();
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#Print1',{ 
		onClick:function(){
			var Row=IngrMainGrid.getSelected();
			if(isEmpty(Row)){
				$UI.msg('alert','请选择需要打印的单据!');
				return;
			}
			PrintRec(Row.IngrId);
		}
	});
	$UI.linkbutton('#Print2',{ 
		onClick:function(){
			var Row=InitMainGrid.getSelected();
			if(isEmpty(Row)){
				$UI.msg('alert','请选择需要打印的单据!');
				return;
			}
			PrintInIsTrf(Row.init);
		}
	});
	$UI.linkbutton('#CopyInvBT',{
		onClick:function(){
			var rows=MatOrdItmGrid.getRows();
			var len=rows.length;
			if(len==0){
				$UI.msg('alert','没有医嘱信息!');
				return false;
			}
			SaveInvWin(SaveInv);
		}
	});
	function SaveInv(Params){
		MatOrdItmGrid.endEditing();
		var ParamsObj=$UI.loopBlock('#MainConditions');
		var INGRFlag=ParamsObj.INGRFlag;
		if(INGRFlag==1){
			$UI.msg('alert','已入库单据不允许修改发票信息');
				return false;
			}
		var FillFlag = $("input[name='Fill']:checked").val();	//1:不覆盖, 2:覆盖已填
		var InvNo=Params.InvNo;
		var InvDate=Params.InvDate;
		var Rows=MatOrdItmGrid.getRows();
		var len=Rows.length;
		var FillCount = 0;
		for (var index = 0; index < len; index++) {
			var RowData = Rows[index];
			if((FillFlag == '1') && !(isEmpty(RowData.InvNo) && isEmpty(RowData.InvDate))){
				continue;
			}
			$('#MatOrdItmGrid').datagrid('endEdit', index);
			$('#MatOrdItmGrid').datagrid('selectRow', index);
			$('#MatOrdItmGrid').datagrid('editCell', {index: index, field: 'InvNo'});
			var ed = $('#MatOrdItmGrid').datagrid('getEditor', {index: index, field: 'InvNo'});
			ed.target.val(InvNo);
			$('#MatOrdItmGrid').datagrid('editCell', {index: index, field: 'InvDate'});
			var ed = $('#MatOrdItmGrid').datagrid('getEditor', {index: index, field: 'InvDate'});
			$(ed.target).datebox('setValue', InvDate);
			$('#MatOrdItmGrid').datagrid('endEdit', index);
			FillCount++;
		}
		if(FillCount > 0){
			$UI.msg('alert', '已填充' + FillCount + '行, 请注意保存!');
		}else{
			$UI.msg('error', '未进行有效填充!');
		}
	}
	$HUI.tabs("#tt2",{
		onSelect:function(title){
			if(title=="入库信息"){
				if(!isEmpty(CURRENT_INGR)){
					IngrMainGrid.load({
						ClassName: 'web.DHCSTMHUI.DHCINGdRec',
						QueryName: 'QueryIngrStr',
						ingrStr:CURRENT_INGR
					});
				};
			}else if(title=="出库信息"){
				if(!isEmpty(CURRENT_INIT)){
					InitMainGrid.load({
						ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
						QueryName: 'QueryTrans',
						InitStr:CURRENT_INIT
					});
				};
			}
		}
	});
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
		$UI.clear(IngrMainGrid);
		$UI.clear(IngrDetailGrid);
		$UI.clear(InitMainGrid);
		$UI.clear(InitDetailGrid);
		
	}
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
			width:100,
			editor:{
				type:'text',
				options:{
				}
			}
		}, {
			title: '发票日期',
			field: 'InvDate',
			saveCol: true,
			width:100,
			editor:{
				type:'datebox',
				options:{
					}
				}
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
		},{
			title: '补录入库单号',
			field: 'IngriModifyNo',
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
			field: 'VendorDr',
			saveCol: true,
			width:100,
			formatter: CommonFormatter(VendorBox,'VendorDr','Vendor'),
			editor:VendorBox
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
		},{
			title: 'IngriModify',
			field: 'IngriModify',
			saveCol: true,
			hidden:true,
			width:50
		},{
			title: 'Initi',
			field: 'Initi',
			saveCol: true,
			hidden:true,
			width:50
		}
	]];
	/*
	 	type:'checkbox',  
		options:{  
			on: "true",  
			off: "false"  
		} 
		, {
			title: '补录标志',
			field: 'sflag',
			width:100,
			editor:{
				type:'checkbox'
			}
		}
	*/
	var MatOrdItmGrid = $UI.datagrid('#MatOrdItmGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.HVMatOrdItm',
			QueryName: 'HVMatOrdItems'
		},
		columns: MatOrdCm,
		singleSelect:false,
		showBar:false,
		onClickCell: function(index, filed ,value){	
				var rows =MatOrdItmGrid.getRows();
				var row = rows[index]
				if(!isEmpty(row.Ingri)&&(filed=='VendorDr')){
					return false;
				}
			MatOrdItmGrid.commonClickCell(index,filed,value);
		},
		onEndEdit:function(index, row, changes){
			var Editors = $(this).datagrid('getEditors', index);
			for(var i=0;i<Editors.length;i++){
				var Editor = Editors[i];
			}
		},
		onCheck:function(index, row){
			var IngriModify=row.IngriModify;
			var MainIngr=IngriModify.split("||")[0];
			var Initi=row.Initi;
			var MainInit=Initi.split("||")[0];
			CURRENT_INGR = MainIngr;
			CURRENT_INIT = MainInit;
		}
	})
	var InGrMainCm = [[
		{	field: 'ck',
			checkbox: true,
			width:100
		},{
			title: 'RowId',
			field: 'IngrId',
			hidden:true,
			width:100
		}, {
			title: '入库单号',
			field: 'IngrNo',
			width:100
		}, {
			title: '入库部门',
			field: 'RecLoc',
			width:100
		}, {
			title: '供应商',
			field: 'Vendor',
			width:100
		}, {
			title: 'StkGrp',
			field: 'StkGrp',
			hidden: true
		}, {
			title: '采购员',
			field: 'PurchUser',
			width:100
		}, {
			title: '完成标志',
			field: 'Complete',
			width:100
		}, {
			title: '发票金额',
			field: 'InvAmt',
			width:100,
			align:'right'
		}, {
			title: '进价金额',
			field: 'RpAmt',
			hidden: true,
			align:'right'
		}, {
			title: '售价金额',
			field: 'SpAmt',
			width:100,
			align:'right'
		}, {
			title: '备注',
			field: 'InGrRemarks',
			width:100
		}
	]];
	
	var IngrMainGrid = $UI.datagrid('#IngrMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			QueryName: 'QueryIngrStr'
		},
		columns: InGrMainCm,
		singleSelect:false,
		showBar:true,
		onSelect:function(index, row){
			IngrDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
				QueryName: 'QueryDetail',
				Parref: row.IngrId
			});
		},
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				$(this).datagrid('selectRow',0);
			}
		}
	})
	var IngrDetailCm = [[
		{	field: 'ck',
			checkbox: true,
			width:100
		},{
			title: 'Ingri',
			field: 'Ingri',
			hidden:true,
			width:100
		}, {
			title: '物资代码',
			field: 'IncCode',
			width:100
		}, {
			title: '物资名称',
			field: 'IncDesc',
			width:100
		}, {
			title: '生产厂商',
			field: 'Manf',
			width:100
		}, {
			title: '批号',
			field: 'BatchNo',
			width:100
		}, {
			title: '有效期',
			field: 'ExpDate',
			width:100
		}, {
			title: '单位',
			field: 'IngrUom',
			width:100
		}, {
			title: '数量',
			field: 'RecQty',
			width:100,
			align:'right'
		}, {
			title: '进价',
			field: 'Rp',
			width:100,
			align:'right'
		}, {
			title: '售价',
			field: 'Sp',
			width:100,
			align:'right'
		}, {
			title: '发票号',
			field: 'InvNo',
			width:100
		}, {
			title: '发票日期',
			field: 'InvDate',
			width:100
		}, {
			title: '发票金额',
			field: 'InvMoney',
			width:100,
			align:'right'
		}, {
			title: '进价金额',
			field: 'RpAmt',
			width:100,
			align:'right'
		}, {
			title: '售价金额',
			field: 'SpAmt',
			width:100,
			align:'right'
		}
	]];
	
	var IngrDetailGrid = $UI.datagrid('#IngrDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
			QueryName: 'QueryDetail'
		},
		columns: IngrDetailCm,
		singleSelect:false,
		showBar:true
	})
	var InitMainCm = [[
		{	field: 'ck',
			checkbox: true,
			width:100
		},{
			title: 'RowId',
			field: 'RowId',
			hidden:true,
			width:100
		}, {
			title: '转移单号',
			field: 'InitNo',
			width:100
		}, {
			title: '请求部门',
			field: 'ToLocDesc',
			width:100
		}, {
			title: '供给部门',
			field: 'FrLocDesc',
			width:100
		}, {
			title: '转移日期',
			field: 'InitDate',
			width:100
		}, {
			title: '制单人',
			field: 'UserName',
			width:100
		}, {
			title: '进价金额',
			field: 'RpAmt',
			width:100
		}, {
			title: '售价金额',
			field: 'SpAmt',
			width:100
		}
	]];
	
	var InitMainGrid = $UI.datagrid('#InitMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			QueryName: 'QueryTrans'
		},
		columns: InitMainCm,
		singleSelect:false,
		showBar:true,
		onSelect:function(index, row){
			InitDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
				QueryName: 'DHCINIsTrfD',
				Params: JSON.stringify({Init:row.RowId})
			});
		},
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				$(this).datagrid('selectRow',0);
			}
		}
	})
	var InitDetailCm = [[
		{	field: 'ck',
			checkbox: true,
			width:100
		},{
			title: 'RowId',
			field: 'RowId',
			hidden:true,
			width:100
		}, {
			title: '物资RowId',
			field: 'InciId',
			hidden: true,
			width:100
		}, {
			title: '物资代码',
			field: 'InciCode',
			width:100
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width:100
		}, {
			title: '批次Id',
			field: 'Inclb',
			hidden: true,
			width:100
		}, {
			title: '批次/效期',
			field: 'BatExp',
			width:100
		}, {
			title: '生产厂商',
			field: 'ManfDesc',
			width:100
		}, {
			title: '批次库存',
			field: 'InclbQty',
			width:100
		}, {
			title: '转移数量',
			field: 'Qty',
			width:100
		}, {
			title: '转移单位',
			field: 'UomDesc',
			width:100
		}, {
			title: '进价',
			field: 'Rp',
			width:100
		}, {
			title: '售价',
			field: 'Sp',
			width:100
		}, {
			title: '请求数量',
			field: 'ReqQty',
			width:100
		}, {
			title: '货位码',
			field: 'StkBin',
			width:100
		}, {
			title: '请求方库存',
			field: 'ReqLocStkQty',
			width:100
		}, {
			title: '占用数量',
			field: 'InclbDirtyQty',
			width:100
		}, {
			title: '可用数量',
			field: 'InclbAvaQty',
			width:100
		}, {
			title: '批次售价',
			field: 'NewSp',
			width:100
		}, {
			title: '规格',
			field: 'Spec',
			width:100
		}, {
			title: '售价金额',
			field: 'SpAmt',
			width:100
		}, {
			title: '进价金额',
			field: 'RpAmt',
			width:100
		}
	]];
	
	var InitDetailGrid = $UI.datagrid('#InitDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			QueryName: 'DHCINIsTrfD'
		},
		columns: InitDetailCm,
		singleSelect:false,
		showBar:true
	})
	Clear();
}
$(init);