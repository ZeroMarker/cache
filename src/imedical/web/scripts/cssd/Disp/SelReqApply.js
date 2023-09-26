function SelReqApply(Fn){
	$HUI.dialog('#SelReqWinBorrow').open();
	$UI.clearBlock('#SelReqConditionsBro');
	//申请科室
	$HUI.combobox('#SelReqLocB', {
		url: $URL
			+ '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array',
		valueField: 'RowId',
		textField: 'Description'
//		onLoadSuccess: function (data) {   //默认登录科室
//			$("#SelReqLoc").combobox('setValue',gLocId);
//		}
	});	
	
	//供应科室
	var SupLocParams=JSON.stringify(addSessionParams({Type:"SupLoc"}));
	var SupLocBox = $HUI.combobox('#ReqSupLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+SupLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function (data) {   //默认第一个值
			$("#ReqSupLoc").combobox('setValue',data[0].RowId);
		}
	});
	//楼号
	var FloorBox = $HUI.combobox('#BroFloorCode', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetFloorCode&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function (data) {   //默认第一个值
			//$("#FloorCode").combobox('setValue',data[0].RowId);
		},
		onSelect: function (row) {
                    if (row != null) {
						//alert(row.RowId);
                        $HUI.combobox('#BroLineCode', {
                          url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetLineCode&ResultSetType=array&FloorCode='+row.RowId,
                          valueField: 'RowId',
                          textField: 'Description',
						  	onLoadSuccess: function (data) {   //默认第一个值
								$("#BroLineCode").combobox('setValue',data[0].RowId);
							}
                      }); 
                    }
                }

	});
	$UI.linkbutton('#SelReqQueryBTBro', {
		onClick: function(){
			SelReqQuery();
		}
	});
	function SelReqQuery(){
		var ParamsObj = $UI.loopBlock('#SelReqWinBorrow');
		var Params = JSON.stringify(ParamsObj);
		//alert(Params);
		$UI.clear(SelReqMasterGrid);
		$UI.clear(SelReqDetailGrid);
		SelReqMasterGrid.load({
			ClassName: 'web.CSSDHUI.PackageDisp.CreateDispByBorrow',
			QueryName: 'SelectDispForCallBack',
			Params: Params
		});
	}
	
	$UI.linkbutton('#SelReqCreateBTBro',{
		onClick: function(){
			SelReqCreate();
		}
	});
	function SelReqCreate(){
		var Rows = SelReqMasterGrid.getChecked();
		if(isEmpty(Rows)){
			$UI.msg('alert', '请选择需要生成的回收单据');
			return;
		}
		var DetailIds="";
		for(var i= 0, Len= Rows.length;i < Len;i++){
			var detailid = Rows[i]['RowId'];
			if(DetailIds == ""){
				DetailIds = detailid;
			}	
			else{
				DetailIds = DetailIds + ',' + detailid;
			}
		}
		var ItemRowObj=SelReqDetailGrid.getSelections();
		var ItemRowId=",";
		for(var i=0;i<ItemRowObj.length;i++){
			var ItemRowId=ItemRowId+ItemRowObj[i].RowId+",";
		}
		var Parames=JSON.stringify(addSessionParams({ItemRowId:ItemRowId}));
		//判断是单个生成还是批量生成
		if(DetailIds.indexOf(",")!="-1")
		{
			$.cm({
				ClassName: 'web.CSSDHUI.PackageDisp.Disp',
				MethodName: 'jsCreatDispByCallBackAll',
				Parames: Parames,
				CallBackMainRow: DetailIds
			},function(jsonData){
				if(jsonData.success === 0){
					$UI.msg('success', jsonData.msg);
					$('#SelReqWinBorrow').window('close');
					Fn();
				}else{
					$UI.msg('error', jsonData.msg);
				}
			}); 
		}
		else{
			$.cm({
				ClassName: 'web.CSSDHUI.PackageDisp.Disp',
				MethodName: 'jsCreatDispByApply',
				Parames: Parames,
				CallBackMainRow: DetailIds
			},function(jsonData){
				if(jsonData.success === 0){
					$UI.msg('success', jsonData.msg);
					$('#SelReqWinBorrow').window('close');
					Fn();
				}else{
					$UI.msg('error', jsonData.msg);
				}
			}); 
		}
	}
	function SelReqDefa(){
		$UI.clearBlock('#SelReqConditionsBro');
		//$("input[name='PackageType'][label='全部']").attr("checked",true); 
		var Dafult={
			FStartDate:DefaultStDate(),
			FEndDate:DefaultEdDate,
			FReqNo:""
		}
		$UI.fillBlock('#SelReqConditionsBro', Dafult)
		
	}
	var SelReqMasterCm = [[
		{
			field: 'ck',
			checkbox: true
		},
		{
			title: 'RowId',
			align:'center',
			field: 'RowId',
			width:50,
			hidden: true
		}, {
			title: '单号',
			align:'left',
			field: 'No',
			width:100,
			fitColumns:true
			
		}, {
			title: '单据类型',
			align:'left',
			field: 'ApplyTypeName',
			width:100,
			fitColumns:true
		},{
			title: '申请科室',
			align:'left',
			field: 'FromLocDesc',
			width:100,
			fitColumns:true
		}, {
			title: '申请日期',
			align:'left',
			field: 'AckDate',
			width:100,
			fitColumns:true
		}, {
			title: '申请时间',
			align:'left',
			field: 'AckTime',
			width:100,
			fitColumns:true
		}, {
			title: '申请人',
			align:'left',
			field: 'AckUserDesc',
			width:100,
			fitColumns:true
		},{
			title:'回收标志',
			align:'left',
			field:'ReqFlag',
			width:100,
			fitColumns:true,
			hidden:true
		},{
			title:'是否生成发放单标志',
			align:'center',
			field:'DispFlag',
			width:100,
			fitColumns:true
		}
	]];


	var SelReqMasterGrid = $UI.datagrid('#SelReqMasterGridBro', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageDisp.CreateDispByApply',
			QueryName: 'SelectDispForCallBack',
			Params:JSON.stringify(addSessionParams({ReqFlag:"N"}))
		},
		columns: SelReqMasterCm,
		lazy:true,
		selectOnCheck: false,
		onLoadSuccess:function(data){  
			if(data.rows.length>0){
				$('#SelReqMasterGridBro').datagrid("selectRow", 0);
				var Row=SelReqMasterGrid.getRows()[0]
				var Id = Row.RowId;
				FindItemByF(Id);
			}	
		},
		onClickCell: function(index, filed ,value){
			var Row=SelReqMasterGrid.getRows()[index]
			var Id = Row.RowId;
			if(!isEmpty(Id)){
				FindItemByF(Id);	
			}	
			SelReqMasterGrid.commonClickCell(index,filed)
		},
		onDblClickRow:function(rowIndex){//鼠标双击事件
			$('#SelReqMasterGridBro').datagrid("selectRow",rowIndex);//选中此行
			SelReqCreate();
		}
	})

	var SelReqDetailCm = [[
	{
			title: '',
			id:'selectAll',
			field: 'ck',
			checked:true,
			checkbox : true
		},
		{
			title: 'RowId',
			field: 'RowId',
			width:100,
			hidden: true
		},{
			title: '消毒包名称',
			align:'left',
			field: 'PackageName',
			width:200
		},{
			title: '申请数量',
			align:'right',
			field: 'Qty',
			width:70
		},{
			title: '发放数量',
			align:'right',
			field: 'DispQty',
			width:70
		}
	]]; 

	var SelReqDetailGrid = $UI.datagrid('#SelReqDetailGridBro', {
		queryParams: {
				ClassName: 'web.CSSDHUI.PackageDisp.CreateDispByApply',
				MethodName: 'SelectByF'
			},
			columns: SelReqDetailCm,
			pagination:true,
			singleSelect:false,
			onLoadSuccess:function(data){  
				if(data.rows.length>0){
					$('#SelReqDetailGridBro').datagrid("selectAll");
				}	
			}
		});	
	
	function FindItemByF(Id) {
		//alert(Id);
		SelReqDetailGrid.load({
			ClassName: 'web.CSSDHUI.PackageDisp.CreateDispByApply',
			QueryName: 'SelectByF',
			ApplyId:Id
			
		});
	}
	SelReqDefa();
	SelReqQuery();

}