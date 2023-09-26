var init = function() {
	//=======================条件初始化start==================
	
	//科室
	var LocParams=JSON.stringify(addSessionParams({Type:"LinkLoc"}));
	var LocBox = $HUI.combobox('#FLocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var HandlerParams=function(){
		var Obj={StkGrpType:"M",BDPHospital:gHospId};
		return Obj
	}
	$("#InciDesc").lookup(InciLookUpOp(HandlerParams,'#InciDesc','#Inci'));
	$("#FInciDesc").lookup(InciLookUpOp(HandlerParams,'#FInciDesc','#FInci'));
	//===========================条件初始end===========================
	// ======================tbar操作事件start=========================
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
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(MasterGrid);
		$UI.clear(DetailGrid);
		$UI.setUrl(MasterGrid);
		MasterGrid.load({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			QueryName: 'jsDHCSTINStkTk',
			Params: Params
		});
	}
	$UI.linkbutton('#ClearBT',{ 
		onClick:function(){
			Clear();
		}
	});
	function Clear() {
		$UI.clearBlock('#Conditions');
		$UI.clear(MasterGrid);
		$UI.clear(DetailGrid);
		var Dafult={
				FLocId:gLocObj,
				FStartDate:DateFormatter(new Date()),
				FEndDate:DateFormatter(new Date()),
				FInstComp:"",
				FStkTkComp:"",
				FAdjComp:""
			}
		$UI.fillBlock('#Conditions',Dafult);
		$('#detailtype').tabs('disableTab', 1)
	}
	$UI.linkbutton('#PrintBT',{ 
		onClick:function(){
			Print();
		}
	});
	function Print(){
		var row = $('#MasterGrid').datagrid('getSelected');
		if(isEmpty(row)){
			$UI.msg('alert','请选择数据!');
			return;
		}
		if(isEmpty(row.inst)){
			$UI.msg('alert','参数错误!');
			return;
		}
		var ret = tkMakeServerCall("web.DHCSTMHUI.INStkTk", "UpPrintFlag", row.inst);
		PrintINStk(row.inst, 1);
	}
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
		$UI.setUrl(DetailGrid);
		DetailGrid.load({
				ClassName: 'web.DHCSTMHUI.INStkTkItm',
				QueryName: 'jsDHCSTInStkTkItm',
				Inst: row.inst,
				Others:Params,
				qPar:"",
				totalFooter:'"code":"合计"',
				totalFields:'freezeRpAmt,countRpAmt,varianceRpAmt'
			});
	}
	//检索明细
	$UI.linkbutton('#QueryDetailBT',{ 
		onClick:function(){
			loadDetailGrid();
		}
	});
	
	//叶签切换 监听
	$HUI.tabs("#detailtype",{
		onSelect:function(title){
			if(title=="按品种汇总"){
				loadDetailGridRQ();
			}else{
				loadDetailGrid();
			}
		}
	});
	function loadDetailGridRQ(){
		var row = $('#MasterGrid').datagrid('getSelected');
		var Rowid=row.inst;
		var Params=JSON.stringify({Inst:Rowid});
		var p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_INStkTk_GroupInci.raq'
			+"&Inst="+Rowid+"&Params="+Params
		$("#frameInstktkInciPanel").attr("src",p_URL);
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
			width:100
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
			var DTTabed = $('#detailtype').tabs('getSelected');  
			var DTTabed=$('#detailtype').tabs('getTabIndex',DTTabed);
			if(DTTabed==0){
				loadDetailGrid();
			}else if(DTTabed==1){
				loadDetailGridRQ();
			}
			
		},
		onLoadSuccess:function(data){
			if(data.rows.length>0){
				$('#detailtype').tabs('enableTab', 1)
				$('#MasterGrid').datagrid("selectRow", 0)
				loadDetailGrid();
			}	
		}
	})
	var DetailGridCm = [[{
			title: 'rowid',
			field: 'rowid',
			hidden: true
		}, {
			title: 'inclb',
			field: 'inclb',
			hidden: true
		}, {
			title: 'inci',
			field: 'inci',
			hidden: true
		}, {
			title: '物资代码',
			field: 'code',
			width:120
		}, {
			title: '物资名称',
			field: 'desc',
			width:150
		}, {
			title: "规格",
			field:'spec',
			width:100
		}, {
			title:"厂商",
			field:'manf',
			width:100
		}, {
			title:"条码",
			field:'barcode',
			width:100,
			hidden:true
		}, {
			title:"账盘数量",
			field:'freQty',
			width:100,
			align:'right'
		}, {
			title:"账盘日期",
			field:'freDate',
			width:100
		}, {
			title:"账盘时间",
			field:'freTime',
			width:100
		}, {
			title:"实盘数量",
			field:'countQty',
			width:100,
			align:'right'
		}, {
			title:"实盘日期",
			field:'countDate',
			width:100
		}, {
			title:"实盘时间",
			field:'countTime',
			width:80
		}, {
			title:"实盘人",
			field:'countPerson',
			hidden: true,
			hidden:true
		}, {
			title:"实盘人",
			field:'countPersonName',
			width:100
		}, {
			title:"dd",
			field:'variance',
			width:100,
			hidden:true
		}, {
			title:"备注",
			field:'remark',
			width:60,
			hidden:true
		}, {
			title:"状态",
			field:'status',
			width:60,
			hidden:true
		}, {
			title:"单位",
			field:'uom',
			hidden: true,
			hidden:true
		}, {
			title:"单位",
			field:'uomDesc',
			width:60
		}, {
			title:"批号",
			field:'batchNo',
			width:100
		}, {
			title:"有效期",
			field:'expDate',
			width:100
		}, {
			title:"调整标志",
			field:'adjFlag',
			width:60,
			hidden:true
		}, {
			title:"货位码",
			field:'sbDesc',
			width:100
		}, {
			title:"dd",
			field:'inadi',
			hidden: true,
			align:'right',
			hidden:true
		}, {
			title:"售价",
			field:'sp',
			width:60,
			align:'right',
			hidden:true
		}, {
			title:"进价",
			field:'rp',
			width:60,
			align:'right'
		}, {
			title:"账盘售价金额",
			field:'freezeSpAmt',
			width:100,
			align:'right',
			hidden:true
		}, {
			title:"账盘进价金额",
			field:'freezeRpAmt',
			width:100,
			align:'right'
		}, {
			title:"实盘售价金额",
			field:'countSpAmt',
			width:100,
			align:'right',
			hidden:true
		}, {
			title:"实盘进价金额",
			field:'countRpAmt',
			width:100,
			align:'right'
		}, {
			title:"损益售价金额",
			field:'varianceSpAmt',
			width:100,
			align:'right',
			hidden:true
		}, {
			title:"损益进价金额",
			field:'varianceRpAmt',
			width:100,
			align:'right'
		}, {
			title:"dd",
			field:'trueQty',
			width:60,
			hidden:true
		}, {
			title:"类组",
			field:'scgDesc',
			width:100
		}, {
			title:"供应商",
			field:'vendor',
			width:100
		}, {
			title:"库存分类",
			field:'incscdesc',
			width:100
		}, {
			title:"具体规格",
			field:'specdesc',
			width:100
		}, {
			title:"dd",
			field:'freeBarCode',
			width:60,
			hidden:true
		}, {
			title:"dd",
			field:'countBarCode',
			width:60,
			hidden:true
		}, {
			title:"dd",
			field:'varianceBarCode',
			width:60,
			hidden:true
		}
	]];
	var DetailGrid = $UI.datagrid('#DetailGrid',{
		queryParams : {
			ClassName: 'web.DHCSTMHUI.INStkTkItm',
			QueryName: 'jsDHCSTInStkTkItm',
			totalFooter:'"code":"合计"',
			totalFields: 'freezeRpAmt,countRpAmt,varianceRpAmt'
		},
		columns : DetailGridCm
	})
	Clear();
}
$(init);
