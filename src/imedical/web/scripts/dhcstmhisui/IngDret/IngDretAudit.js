var init = function() {
	var Clear=function(){
		$UI.clearBlock('#Conditions');
		$UI.clear(RetMainGrid);
		$UI.clear(RetDetailGrid);
		var Dafult={
			StartDate:DefaultStDate(),
			EndDate:DefaultEdDate(),
			RetLoc:gLocObj,
			Completed:'Y',
			AuditFlag:'N'
			}
		$UI.fillBlock('#Conditions',Dafult)
	}
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			$UI.clear(RetMainGrid);
			$UI.clear(RetDetailGrid);
			var ParamsObj=$UI.loopBlock('#Conditions')
			if(isEmpty(ParamsObj.StartDate)){
				$UI.msg('alert','开始日期不能为空!');
				return;
			}
			if(isEmpty(ParamsObj.EndDate)){
				$UI.msg('alert','截止日期不能为空!');
				return;
			}
			if(isEmpty(ParamsObj.RetLoc)){
				$UI.msg('alert','退货科室不能为空!');
				return;
			}	
			var Params=JSON.stringify(ParamsObj);
			RetMainGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGdRet',
				QueryName: 'DHCINGdRet',
				Params:Params
			});
		}
	});
	$UI.linkbutton('#AuditBT',{
		onClick:function(){
			var Row=RetMainGrid.getSelected()
			if(isEmpty(Row)){
				$UI.msg('alert','请选择要审核的退货单!');
				return;
			}	
			var Params=JSON.stringify(addSessionParams({RowId:Row.RowId}));
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINGdRet',
				MethodName: 'jsAudit',
				Params:Params
				
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					$UI.clear(RetDetailGrid);
					RetMainGrid.commonReload();
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#SendBT',{
		onClick:function(){
			var Row=RetMainGrid.getSelected()
			if(isEmpty(Row)){
				$UI.msg('alert','请选择要推送的退货单!');
				return;
			}		
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINGdRet',
				MethodName: 'SendIngRetToSCM',
				RowId:Row.RowId
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Clear()
		}
	});
	$UI.linkbutton('#PrintBT',{
		onClick:function(){
			var Row=RetMainGrid.getSelected()
			if(isEmpty(Row)){
				$UI.msg('alert','请选择要打印的退货单!');
				return;
			}
			PrintIngDret(Row.RowId);
		}
	});
	
	$UI.linkbutton('#PrintHVBT',{
		onClick:function(){
			var Row=RetMainGrid.getSelected()
			if(isEmpty(Row)){
				$UI.msg('alert','请选择要打印的退货单!');
				return;
			}
			PrintIngDretHVCol(Row.RowId);
		}
	});

	var SendFlagBox = $HUI.combobox('#SendFlag', {
		data:[{'RowId':'','Description':'全部'},{'RowId':'Y','Description':'已推送'},{'RowId':'N','Description':'未推送'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var RetLocParams=JSON.stringify(addSessionParams({Type:'Login'}));
	var RetLocBox = $HUI.combobox('#RetLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+RetLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});	
	var VendorParams=JSON.stringify(addSessionParams({APCType:"M",RcFlag:"Y"}));
	var VendorBox = $HUI.combobox('#Vendor', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	
	var RetMainCm = [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '退货单号',
			field: 'RetNo',
			width:150
		}, {
			title: '供应商',
			field: 'VendorName',
			width:150
		},{
			title: '退货科室',
			field: 'RetLocDesc',
			width:150
		}, {
	        title:"制单人",
	        field:'RetUserName',
	        width:70
	    }, {
	        title:"制单日期",
	        field:'RetDate',
	        width:90,
	        align:'right'
		}, {
	        title:"制单时间",
	        field:'RetTime',
	        width:80,
	        align:'right'
	    }, {
	        title:"完成状态",
	        field:'Completed',
	        align:'center',
	        width:60
	    },  {
	        title:"审核标志",
	        field:'AuditFlag',
	        align:'center',
	        width:60
	    },{
			title: '推送平台标志',
			field: 'SendFlag',
			width:80
		},{
	        title:"备注",
	        field:'Remark',
	        width:100,
	        align:'right'
	    }
	]];
	
	var RetMainGrid = $UI.datagrid('#RetMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRet',
			QueryName: 'DHCINGdRet'
		},
		columns: RetMainCm,
		onSelect:function(index, row){
			$UI.setUrl(RetDetailGrid)
			var ParamsObj={RefuseFlag:1}
			var Params=JSON.stringify(ParamsObj)
			RetDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGrtItm',
				QueryName: 'DHCINGdRetItm',
				RetId: row.RowId,
				rows: 99999
			});
		},
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				$(this).datagrid('selectRow',0);
			}
		}
	})
	
	var RetDetailCm = [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		},{
			title: 'Ingri',
			field: 'Ingri',
			hidden: true			
		},{
			title: 'Inci',
			field: 'Inci',
			hidden: true			
		},{
			title: 'Inclb',
			field: 'Inclb',
			hidden: true			
		}, {
			title: '物资代码',
			field: 'Code',
			width:100
		}, {
			title: '物资名称',
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
        	title: "批号",
       		field:'BatNo',
        	width:100
    	}, {
	        title:"效期",
	        field:'ExpDate',
	        width:120
	    }, {
	        title:"批次存数",
	        field:'StkQty',
	        width:100,
	        align:'right'
		}, {
	        title:"退货数量",
	        field:'Qty',
	        width:100,
	        align:'right'
	    }, {
	        title:"单位",
	        field:'UomDesc',
	        width:100
	    }, {
	        title:"退货原因",
	        field:'Reason',
	        width:100
	    },{
	        title:"退货进价",
	        field:'Rp',
	        width:100,
	        align:'right'
	    }, {
	        title:"进价金额",
	        field:'RpAmt',
	        width:100,
	        align:'right'
	    },{
	        title:"发票号",
	        field:'InvNo',
	        width:100,
	        align:'left'	
	    },{
	        title:"发票日期",
	        field:'InvDate',
	        width:100,
	        align:'right'
	        
	    }, {
	        title:"发票金额",
	        field:'InvAmt',
	        width:100,
	        align:'right'
	    },{
	        title:"零售单价",
	        field:'Sp',
	        width:100,
	        align:'right'
	    }, {
	        title:"售价金额",
	        field:'SpAmt',
	        width:100,
	        align:'right'
	    },{
	        title:"备注",
	        field:'Remark',
	        width:200,
	        align:'left'	
	    },{
	        title:"具体规格",
	        field:'SpecDesc',
	        width:100,
	        align:'left'
	    },{
			title:"高值标志",
			field:'HVFlag',
			width:80,
			align:'center',
			formatter :function(v){
				if(v=="Y"){return "是"}
				else{return "否"}
			}
		},{
	        title:"随行单号",
	        field:'SxNo',
	        width:200,
	        align:'left'
	    }		
	]];
	var RetDetailGrid = $UI.datagrid('#RetDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGrtItm',
			QueryName: 'DHCINGdRetItm',
			rows: 99999
		},
		pagination:false,
		columns: RetDetailCm
	})
	
	Clear()
}
$(init);