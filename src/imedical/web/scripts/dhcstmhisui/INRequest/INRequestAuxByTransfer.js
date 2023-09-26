var init = function() {
	var Clear=function(){
		$UI.clearBlock('#MainConditions');
		$UI.clear(TransferGrid);
		var Dafult={
			ReqLoc:gLocObj,
			ReqType:'O',
			StartDate:DefaultStDate(),
			EndDate:DefaultEdDate(),
			Days:30
			}
		$UI.fillBlock('#MainConditions',Dafult)
	}
	var UomCombox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTUom&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description'
		}
	};
	var ReqLocParams=JSON.stringify(addSessionParams({Type:INREQUEST_LOCTYPE}));
	var ReqLocBox = $HUI.combobox('#ReqLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+ReqLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});		
	var SupLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var SupLocBox = $HUI.combobox('#SupLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+SupLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#MainConditions')
			if(isEmpty(ParamsObj.SupLoc)){
				$UI.msg('alert','供应科室不能为空!');
				return;
			}
			if(isEmpty(ParamsObj.ReqLoc)){
				$UI.msg('alert','请求科室不能为空!');
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
			if(isEmpty(ParamsObj.Days)){
				$UI.msg('alert','备货天数不能为空!');
				return;
			}
			if(InRequestParamObj.NoScgLimit!='Y'&&isEmpty($HUI.combobox("#ScgStk").getValue())){
				$UI.msg('alert',"类组不能为空!");
				return false;
			};
			var Params=JSON.stringify(ParamsObj)
			TransferGrid.load({
				ClassName: 'web.DHCSTMHUI.INRequestAuxByTrans',
				QueryName: 'LocItmForReq',
				Params:Params
			});
		}
	});
	$UI.linkbutton('#SaveBT',{
		onClick:function(){
			var MainObj=$UI.loopBlock('#MainConditions')
			var Main=JSON.stringify(MainObj)
			var Detail=TransferGrid.getRowsData();
			if(isEmpty(Detail)){
				$UI.msg('alert','请选择相应的辅助请求');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.INRequest',
				MethodName: 'Save',
				Main: Main,
				Detail: JSON.stringify(Detail)
			},function(jsonData){
				if(jsonData.success==0){
					$UI.clear(TransferGrid);
					$UI.msg('success',jsonData.msg);
					var Req=jsonData.rowid
					var HvFlagRadioJObj = $("input[name='HvFlag']:checked");
					if(HvFlagRadioJObj.val()=='N'){
						var UrlStr = "dhcstmhui.inrequest.csp?RowId="+Req;
					}else{
						var UrlStr = "dhcstmhui.inrequesthv.csp?RowId="+Req;	
					}
					Common_AddTab('请求', UrlStr);
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
		}
	});	 
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Clear();
		}
	});	
	var TransferGridCm = [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '物资RowId',
			field: 'Inci',
			hidden: true			
		}, {
			title: '代码',
			field: 'Code',
			width:100
		}, {
			title: '描述',
			field: 'Description',
			width:150
		}, {
        	title: "规格",
       		field:'Spec',
        	width:100
    	}, {
	        title:"厂商",
	        field:'Manf',
	        width:150
	    }, {
	        title:"库存数量",
	        field:'StkQty',
	        width:100,
	        align:'right',
	        hidden:true
	    }, {
	        title:"可用数量",
	        field:'AvaQty',
	        width:100,
	        align:'right'
	    },{
	        title:"日转入量",
	        field:'DailyDispQty',
	        width:100,
	        align:'right'
	    },{
	        title:"请求数量",
	        field:'Qty',
	        width:100,
	        align:'right'
	    },{
	        title:"日期范围内转入总量",
	        field:'ReqQtyAll',
	        width:140,
	        align:'right'
	    },{
	        title:"单位",
	        field:'Uom',
	        width:100,
	    	formatter: CommonFormatter(UomCombox,'Uom','UomDesc')
	    },{
			title:"高值标志",
			field:'HvFlag',
			width:80,
			align:'center',
			renderer :function(v){
				if(v=="Y"){return "是"}
				else{return "否"}
			}
		}		
	]];
	
	var TransferGrid = $UI.datagrid('#TranfersGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INRequestAuxByTrans',
			QueryName: 'LocItmForReq'
		},
		pagination:false,
		columns: TransferGridCm
	})
	Clear()
}
$(init);
