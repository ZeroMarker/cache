/* 四川阳光采购 平台配送单查询*/
function SCQueryPoDistrStatus(PoId){
	$HUI.dialog('#SCDistrstatusWin',{width: gWinWidth, height: gWinHeight}).open();
	$UI.linkbutton('#SCDistrSearchBT',{
		onClick:function(){
			SCDistrQuery();
		}
	});
	function SCDistrClear(){
		$UI.clearBlock('#SCDistrConditions');
		$UI.clear(SCPoDistrStatusGrid);
		var DistrDafult = {
			SCCurPage:1
		};
		$UI.fillBlock('#SCDistrConditions', DistrDafult);
	}
	///低值入库
	$UI.linkbutton('#SCSaveInGdRecBT', {
		onClick: function () {
			SCSaveIngr();
		}
	});
	function SCSaveIngr() {
		var RowsData = SCPoDistrStatusGrid.getSelections();
		// 有效行数
		var count = 0;
		for (var i = 0; i < RowsData.length; i++) {
			var item = RowsData[i].Inci;
			if (!isEmpty(item)) {
				count++;
			}
		}
		if (RowsData.length <= 0 || count <= 0) {
			$UI.msg('alert', '没有需要入库的明细!');
			return false;
		}
		var MainInfo=tkMakeServerCall("web.DHCSTMHUI.ServiceForSCYGCG","GetPoInfoById",PoId)
        if(MainInfo==""){
	         $UI.msg('alert','无法获取到订单数据请核实！');
			return;   
	     }
         var MainInfoArr=MainInfo.split("^");     
         var RecLoc=MainInfoArr[4];
         var PurchaseUser=MainInfoArr[2];
         var Vendor=MainInfoArr[1];
         var StkGrpId=MainInfoArr[3];
         var ReqLocId=MainInfoArr[5];       
         var Complete = "N";
		 var AdjCheque = "N";
		 var GiftFlag = "N";
		 var Main = JSON.stringify(addSessionParams({ RecLoc: RecLoc, PurchaseUser: PurchaseUser, ApcvmDr: Vendor, StkGrpId: StkGrpId, ReqLocId: ReqLocId, Complete: Complete, AdjCheque: AdjCheque, GiftFlag: GiftFlag, PoId: PoId }));
		 var ListDetail="";
		 for (var i = 0, Len = RowsData.length; i < Len; i++) {
			var RowData = RowsData[i];
			var IncId=RowData['Inci'];
			if(IncId==""){
				$UI.msg('alert', '第'+ (i + 1)+'行产品没有与HIS库存项的对照关系,请核查!');
				continue;
			}
			var orderDetailId=RowData['orderDetailID'];		//采购平台明细编号
			var warehouseCount=RowData['warehouseCount'];	//已收货数量
			var distributeCount =RowData['distributeCount'];//配送数量
			if((warehouseCount!="")&&(distributeCount!="")){
				if(distributeCount-warehouseCount<=0){
					$UI.msg('alert', '第'+ (i + 1)+'行收货数量大于等于配送数量,不允许再生成入库单!');
					continue;
				}
			}
			var DrugInfo=tkMakeServerCall("web.DHCSTMHUI.ServiceForSCYGCG","GetPoItmInfoHisUI",orderDetailId,PoId,"N");
			if(DrugInfo==""){
				$UI.msg('alert', '获取订单明细信息失败！');
				return;   
	        }
	        var DrugInfoArr=DrugInfo.split("^");
	        var PoItmId=DrugInfoArr[0];
			var IngrUomId = DrugInfoArr[1];
			var Rp= DrugInfoArr[2];
			var Sp= DrugInfoArr[3];
			var ManfId = DrugInfoArr[4];
			//var ExpDate =DrugInfoArr[5];
			var BatchNo =RowData['batchRecordID'];
			var ExpDate =RowData['periodDate'];
			var InvNo =RowData['invoiceID'];
			var InvCode =RowData['invoiceCode'];
			var distributeId=RowData['distributionSerialID'];   //配送明细编号 保存至 initm_OrderDetailSubId			
			var Remark="依据采购平台订单配送";
			var RecQty=distributeCount-warehouseCount;  // 入库数量
			var NewSp= Sp;
			var DetailData ={Inpoi:PoItmId,IncId: IncId, IngrUomId: IngrUomId,RecQty:RecQty,Rp:Rp,ManfId:ManfId,Sp:Sp,NewSp:NewSp,BatchNo:BatchNo,ExpDate:ExpDate,InvNo:InvNo,InvCode:InvCode,OrderDetailSubId:distributeId,Remark:Remark};
			if(ListDetail==""){
				ListDetail=JSON.stringify(DetailData);
			}
			else{
				ListDetail=ListDetail+","+JSON.stringify(DetailData);
			}
		}
		if(ListDetail==""){
			$UI.msg('alert', '没有需要保存的入库明细！');
			return;   
		}
		var Detail="["+ListDetail+"]";
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			MethodName: 'jsSave',
			MainInfo: Main,
			ListData: Detail
		}, function (jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				var IngrRowid = jsonData.rowid;
				var Str='dhcstmhui.ingdrec.csp?Rowid=' + IngrRowid;
				window.open(Str, '_blank', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1500,height=750,left=0,top=0')
				Clear()
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	/// 阳光采购  关联高值入库单 高值条码
	$UI.linkbutton('#SCLinkInGdRecBT', {
		onClick: function () {
			SCLinkInGdRec();
		}
	});
	function SCLinkInGdRec() {
		var RowsData = SCPoDistrStatusGrid.getSelections();
		// 有效行数
		var count = 0;
		for (var i = 0; i < RowsData.length; i++) {
			var RowIndex = SCPoDistrStatusGrid.getRowIndex(RowsData[i]);
			var item = RowsData[i].Inci;
			var highflag = RowsData[i].highflag; 
			if (highflag!="Y") {
					$UI.msg('alert', '非高值耗材!');
					SCPoDistrStatusGrid.unselectRow(RowIndex);
					continue;
				}
			
			if (!isEmpty(item)) {
				count++;
			}
		}
		if (RowsData.length <= 0 || count <= 0) {
			$UI.msg('alert', '没有需要处理的明细!');
			return false;
		}
		var Detail=JSON.stringify(RowsData);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.ServiceForSCYGCG',
			MethodName: 'JSLinkInGdRec',
			ListData: Detail
		}, function (jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				var IngrRowid = jsonData.rowid;
				Clear()
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	var SCPoDistrStatusCm = [[
		{
			field: 'check',
			checkbox: true
		},{
			title: '订单明细编号',
			field: 'orderDetailID',
			width: 180,
			sortable: true
		}, {
			title: '配送明细编号',
			field: 'distributionSerialID',
			width: 180
		}, {
			title: '库存项ID',
			field: 'Inci',
			width: 100
		}, {
			title: '库存项代码',
			field: 'InciCode',
			width: 100
		}, {
			title: '库存项名称',
			field: 'InciDesc',
			width: 100
		}, {
			title: '发票号',
			field: 'invoiceID',
			width: 150
		}, {
			title: '发票代码',
			field: 'invoiceCode',
			width: 150
		}, {
			title: '批号',
			field: 'batchRecordID',
			width: 150
		}, {
			title: '效期',
			field: 'periodDate',
			width: 150
		}, {
			title: '配送数量',
			field: 'distributeCount',
			width: 150,
			align: 'left'
		}, {
			title: '配送日期',
			field: 'distriDate',
			width: 200
		}, {
			title: '配送时间',
			field: 'distriTime',
			width: 200
		}, {
			title: '入库数量',
			field: 'warehouseCount',
			width: 200
		}, {
			title: '入库日期',
			field: 'IngdrecDate',
			width: 200
		}, {
			title: '入库时间',
			field: 'IngdrecTime',
			width: 200
		}, {
			title: '总页数',
			field: 'totalPageCount',
			width: 200,
			hidden:true
		}, {
			title: '总行数',
			field: 'totalRecordCount',
			width: 200,
			hidden:true
		}, {
			title: '是否高值',
			field: 'highflag',
			width: 80 
		}, {
			title: '自定义配送信息',
			field: 'distributeCustomInfo',
			width: 200
		}, {
			title: '多个发票',
			field: 'invoicePrimaryIds',
			width: 200
		}, {
			title: '发票验证状态',
			field: 'invoiceValidState',
			width: 200
		}, {
			title: '发票验证备注信息',
			field: 'invoiceValidRemark',
			width: 200
		}, {
			title: '订单明细配送地址',
			field: 'detailDistributeAddress',
			width: 200
		}
	]];
	var SCPoDistrStatusGrid = $UI.datagrid('#SCPoDistrStatusGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.ServiceForSCYGCG',
			MethodName: 'JSQueryPoItmDispatching',
			rows:99999
		},
		columns: SCPoDistrStatusCm,
		showBar:true,
		idField: 'distributionSerialID',
		pagination: false,
		singleSelect: false,
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				SCPoDistrStatusGrid.selectRow(0);
				var SelectedRow = SCPoDistrStatusGrid.getSelected();
				var TotalPageCount=SelectedRow.totalPageCount;
				var TotalRecordCount=SelectedRow.totalRecordCount;
				$("#SCTotalPage").val(TotalPageCount);
				$("#SCTotalRecord").val(TotalRecordCount);
			}
		}
	});
	
	function SCDistrQuery(){
		var Row=SCPoDistrStatusGrid.getSelected();
		if(!isEmpty(Row)){
			$UI.clear(SCPoDistrStatusGrid);
		}
		var ParamsObj = $UI.loopBlock('#SCDistrConditions');
		var Page=ParamsObj.SCCurPage;
		if((Page=="")||(isEmpty(Page))){
			$UI.msg('alert','当前页码不能为空');
			return;
		}
		SCPoDistrStatusGrid.load({
			ClassName: 'web.DHCSTMHUI.ServiceForSCYGCG',
			MethodName: 'JSQueryPoItmDispatching',
			rows:99999,
			Page:Page,
			PoId:PoId
		});
	}
	SCDistrClear();
	SCDistrQuery();
}

