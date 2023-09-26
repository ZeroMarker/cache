/*
低值耗材医嘱补录入库出库
*/
var init = function() {
	var CURRENT_INGR = '', CURRENT_INIT = '';
	var clear=function(){
		$UI.clearBlock('#MainConditions');
		$UI.clear(MatOrdItmGrid);
		$UI.clear(IngrMainGrid);
		$UI.clear(IngrDetailGrid);
		$UI.clear(InitMainGrid);
		$UI.clear(InitDetailGrid);
        var Dafult={StartDate: DefaultStDate(),
					EndDate: DefaultEdDate(),
					RecLocId:gLocObj,
					RecStatusBox:"N",
					InciId:"",
					CURRENT_INGR:"",
					CURRENT_INIT:""
					}
	    $UI.fillBlock('#MainConditions',Dafult)
	}
	$UI.linkbutton('#ClearBT',{ 
		onClick:function(){
			clear();
		}
	});
	
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			Query();
		}
	});
	function Query(){
		var ParamsObj=$UI.loopBlock('#MainConditions');
		if(isEmpty(ParamsObj.RecLocId)){
			$UI.msg('alert','请选择入库科室!');
			return;
		}
		if(isEmpty(ParamsObj.OeriRecLocId)){
			$UI.msg('alert','请选择医嘱接收科室!');
			return;
		}
		if(isEmpty(ParamsObj.StartDate)){
			$UI.msg('alert','开始日期不能为空!');
			return;
		}
		if(isEmpty(ParamsObj.EndDate)){
			$UI.msg('alert','截止日期不能为空!');
			return;
		}
		var Params=JSON.stringify(ParamsObj);
		$UI.setUrl(MatOrdItmGrid);
		MatOrdItmGrid.load({
			ClassName: 'web.DHCSTMHUI.TableMatHandle',
			QueryName: 'Query',
			Params:Params
		});
	}
	function CheckDataBeforeSave() {
		var ParamsObj=$UI.loopBlock('#MainConditions');
		// 判断入库单是否已审批
		var RecLocId = ParamsObj.RecLocId;
		var ReqLocId = ParamsObj.ReqLocId;
		var ReqLocDesc = $("#ReqLocId").combo('getText');
		if (isEmpty(RecLocId)) {
			$UI.msg('alert','请选择入库科室!');
			return false;
		}
		var RowsData=MatOrdItmGrid.getSelections();
		// 有效行数
		var count = 0;
	    for (var i = 0; i < RowsData.length; i++) {
	       var item = RowsData[i].intr;
	       var ingrFlag = RowsData[i].ingrFlag;
		   if (!isEmpty(item)&&(ingrFlag!="Y")) {
				count++;
		   }
		}
		if (RowsData.length <= 0 || count <= 0) {
			$UI.msg('alert','请选择需要入库的医嘱记录或者存在已入库医嘱记录!');
			return false;
		}
		if (RowsData.length>count) {
			$UI.msg('alert','存在已入库医嘱记录!');
			return false;
		}
		return true;
	}
	$UI.linkbutton('#CreateBT',{ 
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#MainConditions');
			var ReqLocId = ParamsObj.ReqLocId;
			var ReqLocDesc = $("#ReqLocId").combo('getText');
			if (isEmpty(ReqLocId)) {
				$UI.msg('alert','请选择出库接收科室!');
				return false;
			}else if(
				$.messager.confirm("生成入库单","确定选择 "+ReqLocDesc+" 作为出库接收科室?",function (r) {
					if (r) {
			if (CheckDataBeforeSave()){
				Create();
							}
						}})
				)
			{
				return false;
			}
		}
	});
	function Create(){
		var ParamsObj=$UI.loopBlock('#MainConditions');
		var Params=JSON.stringify(ParamsObj);
		var RowsData=MatOrdItmGrid.getSelectedData();
		if (RowsData.length <= 0) {
			$UI.msg('alert','请选择需要入库的医嘱记录!');
			return false;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.TableMatHandle',
			MethodName: 'Create',
			MainInfo: Params,
			ListDetail: JSON.stringify(RowsData)
		},function(jsonData){
			hideMask();
			if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
				    var CurrentInfo=jsonData.rowid
				    var CurrentInfoArr = CurrentInfo.split("^");
					CURRENT_INGR = CurrentInfoArr[0];
					CURRENT_INIT = CurrentInfoArr[1];
					if (CURRENT_INGR!="")
					{$('#MatOeriTab').tabs('select','入库信息');}
					Query();
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#RecPrintBT',{ 
		onClick:function(){
			var Row=IngrMainGrid.getSelected();
		    if(isEmpty(Row)){
			    $UI.msg('alert','请选择需要打印的入库单据!');
			    return false;
		    }
		    var IngrId=Row.IngrId;
		    PrintRec(IngrId);
		}
	});
	$UI.linkbutton('#InisTrfPrintBT',{ 
		onClick:function(){
			var Row=InitMainGrid.getSelected();
		    if(isEmpty(Row)){
			    $UI.msg('alert','请选择需要打印的出库单据!');
			    return false;
		    }
		    var init=Row.RowId;
		    PrintInIsTrf(init);
		}
	});
	$UI.linkbutton('#CancelBT',{ 
		onClick:function(){
			Cancelmul();
		}
	});
	///撤销
	function Cancelmul(){
		var RowsData=MatOrdItmGrid.getSelectedData();
		if (RowsData.length <= 0) {
			$UI.msg('alert','请选择需要撤销的医嘱记录!');
			return false;
		}
		var intridstr="";
		for (var i=0;i<RowsData.length;i++){
			var record=RowsData[i];
			var intrid=record.intr;
			var ingrFlag = record.ingrFlag;
			if (ingrFlag!="Y") {
				continue;
			}
			if (intridstr==""){intridstr=intrid;}else{intridstr=intridstr+"^"+intrid;}
		}
		if (intridstr=="") {
			$UI.msg('alert','请选择可以撤销的医嘱记录!');
			return false;
		}
		showMask();
		var Params = JSON.stringify(addSessionParams());
		$.cm({
			ClassName: 'web.DHCSTMHUI.TableMatHandle',
			MethodName: 'CancelNorMatRecStr',
			intridstr: intridstr,
			Params: Params
		},function(jsonData){
			hideMask();
			if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
				    var countInfo=jsonData.rowid;
				    var countInfoArr = countInfo.split("^");
					var all = countInfoArr[0];
					var succount = countInfoArr[1];
					$UI.msg('success',"共"+all+"条记录;成功:"+succount+"条记录！");
					Query();
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	}
	$HUI.tabs("#MatOeriTab",{
		onSelect:function(title){
			if(title=="入库信息"){
				if (isEmpty(CURRENT_INGR)){return false;}
				$UI.clear(IngrMainGrid);
				$UI.clear(IngrDetailGrid);
				$UI.setUrl(IngrMainGrid);
		        IngrMainGrid.load({
			        ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			        QueryName: 'QueryIngrStr',
			        ingrStr:CURRENT_INGR
		        });
			}else if(title=="出库信息"){
				if (isEmpty(CURRENT_INIT)){return false;}
				$UI.clear(InitMainGrid);
				$UI.clear(InitDetailGrid);
				$UI.setUrl(InitMainGrid);
		        InitMainGrid.load({
			        ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			        QueryName: 'QueryTrans',
			        InitStr:CURRENT_INIT
		        });
			}			
		}
	});
	var SourceOfFundParams=JSON.stringify(addSessionParams());
	var SourceOfFundBox = $HUI.combobox('#SourceOfFund', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSourceOfFund&ResultSetType=array&Params='+SourceOfFundParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	var VendorParams=JSON.stringify(addSessionParams({APCType:"M",RcFlag:"Y"}));
	var VendorBox = $HUI.combobox('#FVendorBox', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	
	var RecLocParams=JSON.stringify(addSessionParams({Type:"Login"}));
	var RecLocBox = $HUI.combobox('#RecLocId', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+RecLocParams,
			valueField: 'RowId',
			textField: 'Description'
	});	
	var ReqLocIdParams=JSON.stringify(addSessionParams({Type:"All"}));
	var ReqLocIdBox = $HUI.combobox('#ReqLocId', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+ReqLocIdParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	var OeriRecLocIdParams=JSON.stringify(addSessionParams({Type:"All"}));
	var OeriRecLocIdBox = $HUI.combobox('#OeriRecLocId', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+OeriRecLocIdParams,
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function(record){
				var LocId = record['RowId'];
				$('#ReqLocId').combobox('setValue', LocId);
			}
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
				row.VenDesc=record.Description
			},
			onShowPanel:function(){
				$(this).combobox('reload')
			}
		}
	}
	var HandlerParams = function(){
		var ScgId = $('#ScgStk').combotree('getValue');
		var Locdr = $('#RecLocId').combo('getValue');
		var toLoc = $('#ReqLocId').combo('getValue');
		var Obj = {StkGrpRowId:ScgId, StkGrpType:'M', Locdr:Locdr,toLoc:toLoc,BDPHospital:gHospId};
		return Obj;
	}
	$('#inciDesc').lookup(InciLookUpOp(HandlerParams, '#inciDesc', '#InciId'));
	var InGrMainCm = [[
		{
			title : "RowId",
			field : 'IngrId',
			width : 100,
			hidden : true
		}, {
			title : "入库单号",
			field : 'IngrNo',
			width : 120
		}, {
			title : '入库科室',
			field : 'RecLoc',
			width : 150
		}, {
			title : '接收科室',
			field : 'ReqLocDesc',
			width : 150
		}, {
			title : "供应商",
			field : 'Vendor',
			width : 200
		}, {
			title : "资金来源",
			field : 'SourceOfFund',
			width : 200
		}, {
			title : '创建人',
			field : 'CreateUser',
			width : 70
		}, {
			title : '创建日期',
			field : 'CreateDate',
			width : 90
		}, {
			title : '审核人',
			field : 'AuditUser',
			width : 70
		}, {
			title : '审核日期',
			field : 'AuditDate',
			width : 90
		}, {
			title : "订单号",
			field : 'PoNo',
			width : 120
		}, {
			title : "入库类型",
			field : 'IngrType',
			width : 80
		}, {
			title : "进价金额",
			field : 'RpAmt',
			width : 100,
			align : 'right'
		}, {
			title : "售价金额",
			field : 'SpAmt',
			width : 100,
			align : 'right'
		}, {
			title : "进销差价",
			field : 'Margin',
			width : 100,
			align : 'right'
		}, {
			title : "备注",
			field : 'InGrRemarks',
			width : 100
		}, {
			title : "ReqLoc",
			field : 'ReqLoc',
			width : 10,
			hidden : true
		}, {
			title : "Complete",
			field : 'Complete',
			width : 10,
			hidden : true
		}, {
			title : "StkGrp",
			field : 'StkGrp',
			width : 10,
			hidden : true
		}
	]];
	//入库
	var IngrMainGrid = $UI.datagrid('#IngrMainGrid', {
		url:'',
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			QueryName: 'QueryIngrStr'
		},
		columns: InGrMainCm,
		singleSelect:false,
		showBar:true,
		onSelect:function(index, row){
			$UI.setUrl(IngrDetailGrid)
			IngrDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
				QueryName: 'QueryDetail',
				Parref: row.IngrId
			});
		}
	})		
	var MatOrdCm = [[
		{	field: 'ck',
			checkbox: true
		},{
			title: 'RowId',
			field: 'intr',
			hidden:true
		}, {
			title: '供应商',
			field: 'vendor',
			width:100
		},{
			title: 'vendordr',
			field: 'vendordr',
			hidden:true
		}, {
			title: '物资RowId',
			field: 'IncId',
			hidden: true			
		}, {
			title: '代码',
			field: 'IncCode',
			width:100
		}, {
			title: '物资名称',
			field: 'IncDesc',
			width:100
		}, {
			title: '规格',
			field: 'Spec',
			width:100
		}, {
			title: '具体规格',
			field: 'SpecDesc',
			width:100
		},{
			title: 'ingritmid',
			field: 'ingritmid',
			hidden:true
		},{
			title: 'inititmid',
			field: 'inititmid',
			hidden:true
		}, {
			title: '补录标记',
			field: 'ingrFlag',
			width:100
		}, {
			title: 'inclb',
			field: 'inclb',
			hidden: true			
		}, {
			title: '进价',
			field: 'Rp',
			width:100
		}, {
			title: '售价',
			field: 'Sp',
			width:100
		}, {
			title: '数量',
			field: 'RecQty',
			width:100
		}, {
			title: '单位',
			field: 'IngrUom',
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
			title: '发票号',
			field: 'InvNo',
			width:100,
			editor:{
				type:'text',
				options:{
				}
			}
		}, {
			title: '发票日期',
			field: 'InvDate',
			width:100,
			editor:{
				type:'datebox',
				options:{
					}
				}
		}, {
			title: '发票金额',
			field: 'InvMoney',
			width:100,
			editor:{
				type:'numberbox',
				options:{
				}
            }
		}, {
			title: '入库单号',
			field: 'IngrNo',
			width:100
		}, {
			title: '患者姓名',
			field: 'paname',
			width:100
		}, {
			title: '患者登记号',
			field: 'PatNo',
			width:100
		}, {
			title: '医生',
			field: 'doctor',
			width:100
		}/*, {
			title: '医嘱日期',
			field: 'oridate',
			width:100
		}, {
			title: '医嘱时间',
			field: 'oritime',
			width:100
		}, {
			title: '补录接收科室',
			field: 'admloc',
			width:100
		}, {
			title: '患者病区',
			field: 'PatLoc',
			width:100
		}, {
			title: '床号',
			field: 'BedNo',
			width:100
		}, {
			title: '处方号',
			field: 'tranNo',
			width:100
		}, {
			title: '费用状态',
			field: 'chargestatus',
			width:100
		}, {
			title: '费用总额',
			field: 'chargeAmt',
			width:100
		}, {
			title: '厂商',
			field: 'manf',
			width:100
		}*/
	]];
	var MatOrdItmGrid = $UI.datagrid('#MatOrdItmGrid', {
		url:'',
		queryParams: {
			ClassName: 'web.DHCSTMHUI.TableMatHandle',
			QueryName: 'Query'
		},
		columns: MatOrdCm,
		singleSelect:false,
		showBar:true,
		columns:MatOrdCm,
				onSelect:function (index,row){
					var ingrFlag=row.ingrFlag;
					if (ingrFlag=="Y"){
						CURRENT_INIT=row.inititmid.split("||")[0];
						CURRENT_INGR=row.ingritmid.split("||")[0];
						//$('#MatOeriTab').tabs('select',"入库信息");
						$UI.clear(IngrMainGrid);
						$UI.clear(IngrDetailGrid);
				$UI.setUrl(IngrMainGrid);
				IngrMainGrid.load({
						ClassName:'web.DHCSTMHUI.DHCINGdRec',
						QueryName:'QueryIngrStr',
								ingrStr:CURRENT_INGR
				});
					}
				},
		onClickCell:function(index,field,value){
			MatOrdItmGrid.commonClickCell(index,field,value)
		}
	})
	
	var IngrDetailCm = [[
		{
			title : "RowId",
			field : 'RowId',
			width : 100,
			hidden : true
		}, {
			title : '物资代码',
			field : 'IncCode',
			width : 80
		}, {
			title : '物资名称',
			field : 'IncDesc',
			width : 230
		}, {
			title : '高值条码',
			field : 'HVBarCode',
			width : 80
		}, {
			title : '自带条码',
			field : 'OrigiBarCode',
			width : 80
		}, {
			title : '规格',
			field : 'Spec',
			width : 80
		}, {
			title : "厂商",
			field : 'Manf',
			width : 180
		}, {
			title : "批次id",
			field : 'Inclb',
			width : 70,
			hidden : true
		}, {
			title : "批号",
			field : 'BatchNo',
			width : 90
		}, {
			title : "有效期",
			field : 'ExpDate',
			width : 100
		}, {
			title : "单位",
			field : 'IngrUom',
			width : 80
		}, {
			title : "数量",
			field : 'RecQty',
			width : 80,
	        align : 'right'
		}, {
			title : "进价",
			field : 'Rp',
			width : 60,
	        align : 'right'
		}, {
			title : "售价",
			field : 'Sp',
			width : 60,
	        align : 'right'
		}, {
			title : "发票号",
			field : 'InvNo',
			width : 80
		}, {
			title : "发票日期",
			field : 'InvDate',
			width : 100
		}, {
			title : "发票金额",
			field : 'InvMoney',
			width : 100,
	        align : 'right'
		}, {
			title : "进价金额",
			field : 'RpAmt',
			width : 100,
	        align : 'right'
		}, {
			title : "售价金额",
			field : 'SpAmt',
			width : 100,
	        align : 'right'
		}, {
			title : "进销差价",
			field : 'Margin',
			width : 100,
	        align : 'right'
		}, {
			title : "随行单号",
			field : 'SxNo',
			width : 80
		}
	]];
	
	var IngrDetailGrid = $UI.datagrid('#IngrDetailGrid', {
		url:'',
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
			QueryName: 'QueryDetail'
		},
		columns: IngrDetailCm,
		singleSelect:false,
		showBar:true
	})
	var InitMainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 80,
			hidden: true
		}, {
			title: '单号',
			field: 'InitNo',
			align: 'left',
			width: 150,
			sortable: true
		}, {
			title: '出库科室',
			field: 'FrLocDesc',
			width: 150,
			sortable: true
		}, {
			title: '接收科室',
			field: 'ToLocDesc',
			width: 150
		}, {
			title: '请求单号',
			field: 'ReqNo',
			width: 150
		}, {
			title: '制单时间',
			field: 'InitDateTime',
			width: 150
		}, {
			title: '出库类型',
			field: 'OperateTypeDesc',
			width: 80
		}, {
			title: '单据状态',
			field: 'StatusCode',
			width: 70
		}, {
			title: '制单人',
			field: 'UserName',
			width: 80
		}, {
			title: '进价金额',
			field: 'RpAmt',
			align: 'right',
			width: 100
		}, {
			title: '售价金额',
			field: 'SpAmt',
			align: 'right',
			width: 100
		}, {
			title: '进销差',
			field: 'MarginAmt',
			align: 'right',
			width: 100
		}, {
			title: '备注',
			field: 'Remark',
			width: 150
		}
	]];
	//出库
	var InitMainGrid = $UI.datagrid('#InitMainGrid', {
		url:'',
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			QueryName: 'QueryTrans'
		},
		columns: InitMainCm,
		singleSelect:false,
		showBar:true,
		onSelect:function(index, row){
			$UI.setUrl(InitDetailGrid);
			var init=row.RowId;
			var params=JSON.stringify(addSessionParams({Init:init}));
			InitDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			    QueryName: 'DHCINIsTrfD',
				Params:params 
			});
		}
	})
	var InitDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 80,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 120
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 180
		}, {
			title: '规格',
			field: 'Spec',
			width: 80
		}, {
			title: '高值条码',
			field: 'HVBarCode',
			width: 150
		}, {
			title: '批号~效期',
			field: 'BatExp',
			width: 200
		}, {
			title: '厂商',
			field: 'ManfDesc',
			width: 160
		}, {
			title: '批次库存',
			field: 'InclbQty',
			align: 'right',
			width: 80
		}, {
			title: '出库数量',
			field: 'Qty',
			align: 'right',
			width: 80
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 50
		}, {
			title: '进价',
			field: 'Rp',
			align: 'right',
			width: 80
		}, {
			title: '售价',
			field: 'Sp',
			align: 'right',
			width: 80
		}, {
			title: '进价金额',
			field: 'RpAmt',
			align: 'right',
			width: 80
		}, {
			title: '售价金额',
			field: 'SpAmt',
			align: 'right',
			width: 80
		}, {
			title: '灭菌批号',
			field: 'SterilizedBat',
			width: 160
		}, {
			title: '请求数量',
			field: 'ReqQty',
			align: 'right',
			width: 80
		}, {
			title: '请求方库存',
			field: 'ReqLocStkQty',
			align: 'right',
			width: 100
		}, {
			title: '占用数量',
			field: 'InclbDirtyQty',
			align: 'right',
			width: 100
		}, {
			title: '可用数量',
			field: 'InclbAvaQty',
			align: 'right',
			width: 100
		}
	]];
	
	var InitDetailGrid = $UI.datagrid('#InitDetailGrid', {
		url:'',
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			QueryName: 'DHCINIsTrfD'
		},
		columns: InitDetailCm,
		singleSelect:false,
		showBar:true
	})
	clear();
}
$(init);