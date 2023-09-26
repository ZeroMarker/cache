//盘点汇总
var init = function() {
	//=======================条件初始化start==================
	
	//科室
	var LocParams=JSON.stringify(addSessionParams({Type:"LinkLoc"}));
	var LocBox = $HUI.combobox('#FLocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	//===========================条件初始end===========================
	// ======================tbar操作事件start=========================
	//查询
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			Query();
		}
	});
	function Query(){ 
		var ParamsObj=$UI.loopBlock('Conditions');
		if(isEmpty(ParamsObj.FLocId)){
				$UI.msg('alert','科室不能为空!');
				return;
			}
		if(isEmpty(ParamsObj.FStartDate)){
				$UI.msg('alert','开始日期不能为空!');
				return;
			}
		if(isEmpty(ParamsObj.FEndDate)){
				$UI.msg('alert','截止日期不能为空!');
				return;
			}
		ParamsObj.FInstComp="Y";
		ParamsObj.FAdjComp="N"
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(MasterGrid);
		$UI.clear(DetailGrid);
		MasterGrid.load({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			QueryName: 'jsDHCSTINStkTk',
			Params: Params,
			sort:'',
			order:''
		});
	}
	//取消完成
	$UI.linkbutton('#CancelCompleteBT',{ 
		onClick:function(){
			CancelComplete();
		}
	});
	function CancelComplete(){
		var row = $('#MasterGrid').datagrid('getSelected');
		if(isEmpty(row)){
			$UI.msg('alert','请选择数据!');
			return;
		}
		if(isEmpty(row.inst)){
			$UI.msg('alert','参数错误!');
			return;
		}
		$.cm({
				ClassName: "web.DHCSTMHUI.INStkTkItmWd",
				MethodName: "StkCancelComplete",
				Inst:row.inst
			},function(jsonData){
				if(jsonData.success>=0){
					$UI.msg('success',jsonData.msg);
					Query();
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
	}
	//确定完成
	$UI.linkbutton('#CompleteBT',{ 
		onClick:function(){
			Complete();
		}
	});
	function Complete(){
		var row = $('#MasterGrid').datagrid('getSelected');
		if(isEmpty(row)){
			$UI.msg('alert','请选择数据!');
			return;
		}
		if(isEmpty(row.inst)){
			$UI.msg('alert','参数错误!');
			return;
		}
		if(isEmpty(row.InputType)){
			$UI.msg('alert','该盘点单尚未进行实盘录入!');
			return;
		}
		if(row.stktkComp=="Y"){
			$UI.msg('alert','盘点单已经汇总完成!');
			return;
		}
		var clName="";
		var mName="";
		if(row.InputType==1){
			clName="web.DHCSTMHUI.INStkTkItmWd";
			mName="INStkTkWdSum";
		}else if(row.InputType==2){
			clName="web.DHCSTMHUI.InStkTkInput";
			mName="CompleteInput";
		}else if(row.InputType==3){
			clName="web.DHCSTMHUI.INStkTkItmTrack";
			mName="CompleteItmTrack";
		}
		$.cm({
				ClassName: clName,
				MethodName: mName,
				Inst:row.inst,
				UserId:gUserId
			},function(jsonData){
				if(jsonData.success>=0){
					$UI.msg('success',jsonData.msg);
					Query();
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
	}
	//清屏
	function Clear() {
		$UI.clearBlock('#Conditions');
		$UI.clear(MasterGrid);
		$UI.clear(DetailGrid);
		var Dafult={
				FLocId:gLocId,
				FStartDate:DateFormatter(new Date()),
				FEndDate:DateFormatter(new Date()),
				FInstComp:"Y",
				FStkTkComp:"",
				FAdjComp:"N"
			}
		$UI.fillBlock('#Conditions',Dafult)
	}
	//加载物资汇总信息
	function loadDetailGrid(){
		var row = $('#MasterGrid').datagrid('getSelected');
		if(isEmpty(row)){
			$UI.msg('alert','请选择数据!');
			return;
		}
		if(isEmpty(row.inst)){
			$UI.msg('alert','参数错误!');
			return;
		}
		var ParamsObj=$UI.loopBlock('DetailConditions');
		var Params = JSON.stringify(ParamsObj);
		DetailGrid.load({
				ClassName: 'web.DHCSTMHUI.INStkTkItmWd',
				QueryName: 'CollectItmCountQty',
				Inst: row.inst,
				Sort:"",
				Dir:""
			});
	}
	
	//======================tbar操作事件end============================
	
	var MasterGridCm = [[ {
			title: 'inst',
			field: 'inst',
			hidden: true
		},{
			title: '盘点单号',
			field: 'instNo',
			width:200
		}, {
			title:"日期",
			field:'date',
			width:100
		}, {
			title:"时间",
			field:'time',
			width:70
		}, {
			title:"科室",
			field:'locDesc',
			width:150
		}, {
			title:"盘点完成",
			field:'comp',
			width:70,
			formatter: function(value,row,index){
				if (row.comp=="Y"){
					return "已完成";
				} else {
					return "未完成";
				}
			}
		}, {
			title:"实盘录入完成",
			field:'stktkComp',
			width:100,
			formatter: function(value,row,index){
				if (row.stktkComp=="Y"){
					return "已完成";
				} else {
					return "未完成";
				}
			}
		}, {
			title:"调整完成",
			field:'adjComp',
			width:70,
			formatter: function(value,row,index){
				if (row.adjComp=="Y"){
					return "已完成";
				} else {
					return "未完成";
				}
			}
		}, {
			title:"标志",
			field:'manFlag',
			width:70,
			hidden:true
		}, {
			title:"账盘单位",
			field:'freezeUom',
			width:70,
			formatter: function(value,row,index){
				if (row.freezeUom==1){
					return "入库单位";
				} else {
					return "基本单位";
				}
			}
		}, {
			title:"账盘进价金额",
			field:'SumFreezeRpAmt',
			width:100,
			align:'right'
		}, {
			title:"账盘售价金额",
			field:'SumFreezeSpAmt',
			width:100,
			align:'right'
		}, {
			title:"实盘进价金额",
			field:'SumCount1RpAmt',
			width:100,
			align:'right'
		}, {
			title:"实盘售价金额",
			field:'SumCount1SpAmt',
			width:100,
			align:'right'
		}, {
			title:"损益进价金额",
			field:'SumVariance1RpAmt',
			width:100,
			align:'right'
		}, {
			title:"损益售价金额",
			field:'SumVariance1SpAmt',
			width:100,
			align:'right'
		}, {
			title:"包括不可用",
			field:'includeNotUse',
			width:100
		}, {
			title:"仅不可用",
			field:'onlyNotUse',
			width:70
		}, {
			title:"类组",
			field:'scgDesc',
			width:100
		}, {
			title:"库存分类",
			field:'scDesc',
			width:100
		}, {
			title:"开始货位码",
			field:'frSb',
			width:100
		}, {
			title:"结束货位码",
			field:'toSb',
			width:100
		}, {
			title:"录入类型",
			field:'InputType',
			width:70,
			hidden:true
		}, {
			title:"打印标志",
			field:'printflag',
			width:70,
			hidden:true
		}, {
			title:"最低进价",
			field:'MinRp',
			width:70,
			align:'right'
		}, {
			title:"最高进价",
			field:'MaxRp',
			width:70,
			align:'right'
		}, {
			title:"随机数",
			field:'RandomNum',
			width:70,
			align:'right'
		}, {
			title:"高值标志",
			field:'HighValueFlag',
			width:70
		}
	]];
	var MasterGrid = $UI.datagrid('#MasterGrid',{
		url : $URL,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INStkTk',
			QueryName: 'jsDHCSTINStkTk'
		},
		columns: MasterGridCm,
		onSelect:function(index, row){
			loadDetailGrid();
		},
		onLoadSuccess:function(data){
			if(data.rows.length>0){
				$('#MasterGrid').datagrid("selectRow", 0)
				loadDetailGrid();
			}
		}
	})
	//===========================================物资汇总============================
	var DetailGridCm = [[{
			title: 'Inci',
			field: 'Inci',
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width:120
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width:150
		}, {
			title: "规格",
			field:'Spec',
			width:100
		}, {
			title:"账盘数量",
			field:'FreezeQty',
			width:100,
			align:'right'
		}, {
			title:"实盘数量",
			field:'CountQty',
			width:100,
			align:'right'
		}, {
			title:"最新进价",
			field:'LastRp',
			width:100,
			align:'right'
		}
	]];
	var DetailGrid = $UI.datagrid('#DetailGrid',{
		queryParams : {
			ClassName: 'web.DHCSTMHUI.INStkTkItmWd',
			QueryName: 'CollectItmCountQty'
		},
		columns : DetailGridCm,
		onSelect:function(index, row){
			loadInstItmGrid();
		},
		onLoadSuccess:function(data){
			if(data.rows.length>0){
				$('#DetailGrid').datagrid("selectRow", 0)
				loadInstItmGrid();
			}
		}
	})
	function loadInstItmGrid(){
		var MasterRow = $('#MasterGrid').datagrid('getSelected');
		if(isEmpty(MasterRow)){
			$UI.msg('alert','请选择数据!');
			return;
		}
		if(isEmpty(MasterRow.inst)){
			$UI.msg('alert','参数错误!');
			return;
		}
		var Detailrow = $('#DetailGrid').datagrid('getSelected');
		if(isEmpty(Detailrow)){
			$UI.msg('alert','请选择数据!');
			return;
		}
		if(isEmpty(Detailrow.Inci)){
			$UI.msg('alert','参数错误!');
			return;
		}
		InstDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.INStkTkItmWd',
				MethodName: 'QueryItmTkWdDetail',
				Inst: MasterRow.inst,
				Inci:Detailrow.Inci
			});
		InstItmGrid.load({
				ClassName: 'web.DHCSTMHUI.INStkTkItmWd',
				MethodName: 'QueryItmTkWd',
				Inst: MasterRow.inst,
				Inci:Detailrow.Inci
			});
	}
	//=============================批次汇总=======================================
	var InstItmGridCm=[[{
			title: 'Insti',
			field: 'Insti',
			width:100,
			hidden: true
		}, {
			title: 'Inclb',
			field: 'Inclb',
			width:100,
			hidden: true
		},{
			title: '批号',
			field: 'BatNo',
			width:100
		},{
			title: '效期',
			field: 'ExpDate',
			width:100
		},{
			title: '单位',
			field: 'FreUomDesc',
			width:100
		},{
			title: '账盘数量',
			field: 'FreQty',
			width:100,
			align:'right'
		},{
			title: '实盘数量',
			field: 'CountQty',
			width:100,
			align:'right'
		}]]
	var InstItmGrid = $UI.datagrid('#InstItmGrid',{
		queryParams : {
			ClassName: 'web.DHCSTMHUI.INStkTkItmWd',
			MethodName: 'QueryItmTkWd'
		},
		columns : InstItmGridCm
	})
	//====================批次明细=====================
	var InstDetailGridCm = [[{
			title: 'Rowid',
			field: 'Rowid',
			hidden: true,
			width:100
		}, {
			title: 'Inclb',
			field: 'Inclb',
			hidden: true,
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
			title: '单位',
			field: 'CountUom',
			width:100
		}, {
			title: '实盘数量',
			field: 'CountQty',
			width:100,
			align:'right'
		}, {
			title: '实盘日期',
			field: 'CountDate',
			width:100
		}, {
			title: '实盘时间',
			field: 'CountTime',
			width:100
		}, {
			title: '实盘人',
			field: 'CountUserName',
			width:100
		}
	]];
	var InstDetailGrid = $UI.datagrid('#InstDetailGrid',{
		queryParams : {
			ClassName: 'web.DHCSTMHUI.INStkTkItmWd',
			MethodName: 'QueryItmTkWdDetail'
		},
		columns : InstDetailGridCm
	})
	Clear();
}
$(init);
