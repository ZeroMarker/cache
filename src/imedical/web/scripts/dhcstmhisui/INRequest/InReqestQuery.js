var init = function() {
	var Clear=function(){
		$UI.clearBlock('#Conditions');
		$UI.clear(RequestMainGrid);
		$UI.clear(RequestDetailGrid);
		var Dafult={
			StartDate:DefaultStDate(),
			EndDate:DefaultEdDate(),
			ReqLoc:gLocObj
			}
		$UI.fillBlock('#Conditions',Dafult)
	};
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			Query();
		}
	});
	function Query(){
		$UI.clear(RequestDetailGrid);
		$UI.clear(RequestMainGrid);
		var ParamsObj=$UI.loopBlock('#Conditions')
		if(isEmpty(ParamsObj.StartDate)){
			$UI.msg('alert','开始日期不能为空!');
			return;
		}
		if(isEmpty(ParamsObj.EndDate)){
			$UI.msg('alert','截止日期不能为空!');
			return;
		}
		if(isEmpty(ParamsObj.ReqLoc)){
			$UI.msg('alert','请求科室不能为空!');
			return;
		}
		var Params=JSON.stringify(ParamsObj);
		RequestMainGrid.load({
			ClassName: 'web.DHCSTMHUI.INRequestQuery',
			QueryName: 'INReq',
			Params:Params
		});
	}
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Clear()
		}
	});
	var ReqLocParams=JSON.stringify(addSessionParams({Type:INREQUEST_LOCTYPE}));
	var ReqLocBox = $HUI.combobox('#ReqLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+ReqLocParams,
			valueField: 'RowId',
			textField: 'Description'
		});
	var SupLocParams=JSON.stringify(addSessionParams({Type:'All'}));
	var SupLocBox = $HUI.combobox('#SupLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+SupLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var RequestMainCm = [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '请求单类型',
			field: 'ReqType',
			width:100,
			formatter:function(v){
				if (v=='O') {return "请求单";}
				if (v=='C') {return '申领计划';}
				return '其他';
			}
		}, {
			title: '请求单号',
			field: 'ReqNo',
			width:200
		}, {
			title: '请求部门',
			field: 'ToLocDesc',
			width:150
		}, {
        	title: "供给部门",
       		field:'FrLocDesc',
        	width:150
    	}, {
	        title:"请求人",
	        field:'UserName',
	        width:70
	    }, {
	        title:"请求方审核人",
	        field:'AuditUser',
	        width:90
	    }, {
	        title:"供应方审核人",
	        field:'AuditUserProv',
	        width:90
	    }, {
	        title:"日期",
	        field:'ReqDate',
	        width:90,
	        align:'right'
		}, {
	        title:"时间",
	        field:'ReqTime',
	        width:80,
	        align:'right'
	    }, {
	        title:"完成状态",
	        field:'Complete',
	        width:60
	    }, {
	        title:"转移状态",
	        field:'TransStatus',
	        width:80,
	        align:'right',
	        formatter:function(value){
				var status="";
				if(value==0){
					status="未转移";
				}else if(value==1){
					status="部分转移";
				}else if(value==2){
					status="全部转移";
				}
				return status;
			}
	    }
	]];
	var RequestMainGrid = $UI.datagrid('#RequestMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INRequest',
			QueryName: 'INReqM'
		},
		columns: RequestMainCm,
		onSelect:function(index, row){
			var ParamsObj={RefuseFlag:1}
			var Params=JSON.stringify(ParamsObj)
			RequestDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.INReqItm',
				QueryName: 'INReqD',
				Req: row.RowId,
				Params:Params,
				rows: 99999
			});
		}
	})

	var RequestDetailCm = [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '物资代码',
			field: 'Code',
			width:120
		}, {
			title: '物资名称',
			field: 'Description',
			width:150
		}, {
        	title: "规格",
       		field:'Spec',
        	width:100
    	}, {
	        title:"具体规格",
	        field:'SpecDesc',
	        width:100
	    }, {
	        title:"厂商",
	        field:'Manf',
	        width:100
		}, {
	        title:"请求数量",
	        field:'Qty',
	        width:100,
	        align:'right'
	    }, {
			title : "供应方库存",
			field : 'StkQty',
			width : 80,
			align : 'right'
		}, {
			title : "已转移数量",
			field : 'TransQty',
			width : 80,
			align : 'right'
		}, {
			title : "未转移数量",
			field : 'NotTransQty',
			width : 80,
			align : 'right'
		}, {
	        title:"单位",
	        field:'UomDesc',
	        width:80
	    }, {
	        title:"售价",
	        field:'Sp',
	        width:100,
	        align:'right'
	    }, {
	        title:"售价金额",
	        field:'SpAmt',
	        width:100,
	        align:'right'
	    }, {
	        title:"请求备注",
	        field:'ReqRemarks',
	        width:100
	    }, {
	        title:"是否拒绝",
	        field:'RefuseFlag',
	        width:60,
	        align:'center'
	    }
	]];

	var RequestDetailGrid = $UI.datagrid('#RequestDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INReqItm',
			QueryName: 'INReqD',
			rows: 99999
		},
		pagination:false,
		columns: RequestDetailCm
	})

	Clear();
	Query();

}
$(init);