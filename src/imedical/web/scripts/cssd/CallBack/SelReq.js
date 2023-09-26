function SelReq(Fn){
	var Dafult={
		FStartDate:DefaultStDate(),
		FEndDate:DefaultEdDate
	}
	$UI.clearBlock('#SelReqConditions');		
	$UI.fillBlock('#SelReqWin',Dafult);
	$HUI.dialog('#SelReqWin').open();
	//申请科室
	$HUI.combobox('#SelReqLoc', {
		url: $URL
			+ '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array',
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function (data) {   //默认登录科室
			//$("#SelReqLoc").combobox('setValue',gLocId);
		}
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
	var FloorBox = $HUI.combobox('#SFloorCode', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetFloorCode&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function (data) {   //默认第一个值
			//$("#FloorCode").combobox('setValue',data[0].RowId);
		},
		onSelect: function (row) {
			if (row != null) {
				//alert(row.RowId);
				$HUI.combobox('#SLineCode', {
				  url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetLineCode&ResultSetType=array&FloorCode='+row.RowId,
				  valueField: 'RowId',
				  textField: 'Description',
					onLoadSuccess: function (data) {   //默认第一个值
						$("#SLineCode").combobox('setValue',data[0].RowId);
					}
				}); 
			}
		}

	});
	//线路号
	/* var LineBox = $HUI.combobox('#SLineCode', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetLineCode&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function (data) {   //默认第一个值
			//$("#LineCode").combobox('setValue',data[0].RowId);
		}
	}); */
	
	$UI.linkbutton('#SelReqQueryBT', {
		onClick: function(){
			SelReqQuery();
			$UI.clear(SelReqDetailGrid)
		}
	});
	function SelReqQuery(){
		var ParamsObj = $UI.loopBlock('#SelReqWin');
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(SelReqMasterGrid);
		SelReqMasterGrid.load({
			ClassName: 'web.CSSDHUI.CallBack.CreateCallBackByApply',
			QueryName: 'SelectApplyForCallBack',
			Params: Params
		});
	}

	$UI.linkbutton('#SelReqCreateBT',{
		onClick: function(){
			SelReqCreate();
		}
	});
	
	function SelReqCreate() {
		var Rows = SelReqMasterGrid.getChecked();
		if(isEmpty(Rows)){
			$UI.msg('alert', '请选择需要生成的请领单据');
			return;
		}
		var ItemRows = SelReqDetailGrid.getChecked();
		if(isEmpty(ItemRows)){
			$UI.msg('alert', '请选择需要生成的消毒包');
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
		var ApplyMainRowObj = $('#SelReqMasterGrid').datagrid('getSelected');
		var ApplyMainRow = ApplyMainRowObj.RowId;
		var ItemRowObj = SelReqDetailGrid.getSelectedData();
		var ItemRowId = ",";
		for (var i = 0; i < ItemRowObj.length; i++) {
			var ItemRowId = ItemRowId + ItemRowObj[i].RowId + ",";
		}
		var Parames = JSON.stringify(ItemRowObj);
		var main = JSON.stringify(addSessionParams({ApplyMainRow : ApplyMainRow}));
		if(DetailIds.indexOf(",")!="-1"){
			var Parames = Parames=JSON.stringify(addSessionParams({ItemRowId:ItemRowId}));
			$.cm({
				ClassName: 'web.CSSDHUI.CallBack.CallBack',
				MethodName: 'jsCreatCallBackByApplyAll',
				Parames: Parames,
				ApplyMainRow: DetailIds
			},function(jsonData){
				if(jsonData.success === 0){
					$UI.msg('success', jsonData.msg);
					$('#SelReqWin').window('close');
					Fn();
				}else{
					$UI.msg('error', jsonData.msg);
				}
			}); 
		}else{
			$.cm({
					ClassName : 'web.CSSDHUI.CallBack.CallBack',
					MethodName : 'jsCreatCallBackByApply',
					Parames : Parames,
					ApplyMainRow : ApplyMainRow,
					main : main
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					$('#SelReqWin').window('close');
					Fn();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	}

	var SelReqMasterCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width:50,
			hidden: true
		}, {
			title: '申请科室',
			field: 'LocDesc',
			width:100
		}, {
			title: '单号',
			field: 'No',
			width:100
		}, {
			title: '单据状态',
			field: 'ReqFlag',
			width:100
		}, {
			title: '提交时间',
			field: 'commitDate',
			width:150
		}, {
			title: '提交人',
			field: 'commitUser',
			width:100
		}, {
			title: '单据类型',
			field: 'ReqType',
			width:100
		}, {
			title: '紧急程度',
			field: 'ReqLevel',
			width:100
		}
	]];


	var SelReqMasterGrid = $UI.datagrid('#SelReqMasterGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.CallBack.CreateCallBackByApply',
			QueryName: 'SelectApplyForCallBack'	,
			Params:JSON.stringify($UI.loopBlock('#SelReqConditions'))
		},
		columns: SelReqMasterCm,
		lazy:false,
		selectOnCheck: false,
		onLoadSuccess:function(data){  
			if(data.rows.length>0){
				$('#SelReqMasterGrid').datagrid("selectRow", 0);
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
			SelReqMasterGrid.commonClickCell(index,filed);
		},
		onDblClickRow:function(rowIndex){//鼠标双击事件
        $('#SelReqMasterGrid').datagrid("selectRow",rowIndex);//选中此行
        	SelReqCreate();
		}
	})

	var SelReqDetailCm = [[
		{
			title:'',
			id:"selectAll",
			field:'ck',
			checkbox:true
		},{
			title: 'RowId',
			field: 'RowId',
			width:100,
			hidden: true
		},{
			title: '消毒包名称',
			field: 'PackageName',
			width:100,
			fitColumns:true
		},{
			title: '请领数量',
			align:'right',
			field: 'Qty',
			width:70,
			fitColumns:true
		},{
			title: '已回收数量',
			align:'right',
			field: 'BackQty',
			width:80,
			fitColumns:true
		},{
			title: '未回收数量',
			align:'right',
			field: 'NotQty',
			width:80,
			fitColumns:true
		},{
			title: '要回收数量',
			align:'right',
			field: 'PreQty',
			width:80,
			editor:{type:'numberbox'},
			fitColumns:true
		},{
			title: '备注',
			field: 'Remark',
			width:70,
			fitColumns:true
		}
	]]; 

	var SelReqDetailGrid = $UI.datagrid('#SelReqDetailGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.CallBack.CreateCallBackByApply',
			MethodName: 'SelectByF'
		},
		columns: SelReqDetailCm,
		pagination:true,
		singleSelect:false,
		onLoadSuccess:function(data){  
				if(data.rows.length>0){
					$('#SelReqDetailGrid').datagrid("selectAll");
				}	
		},
		onClickCell: function(index, field, value){
			var Row=SelReqDetailGrid.getRows()[index];	
			SelReqDetailGrid.commonClickCell(index, field);
			var rows=SelReqDetailGrid.getSelections();
			for(var i=0;i<rows.length;i++){
				rows[i].endEdit();
			}
		}
	});	
	
	function FindItemByF(Id) {
		SelReqDetailGrid.load({
			ClassName: 'web.CSSDHUI.CallBack.CreateCallBackByApply',
			QueryName: 'SelectByF',
			ApplyId:Id
			
		});
	}
}