// /名称: 调价单查询
// /描述: 调价单查询
// /编写者：zhangxiao
// /编写日期: 2018.06.08
var init = function () {
	var InciHandlerParams = function () {
		var Scg = $("#ScgId").combotree('getValue');
		var Obj = {
			StkGrpRowId: Scg,
			StkGrpType: "M",
			BDPHospital:gHospId
		};
		return Obj;
	};
	$("#InciDesc").lookup(InciLookUpOp(InciHandlerParams, '#InciDesc', '#Inci'));
	var Clear=function(){
		$UI.clearBlock('#Conditions');
		$UI.clear(MasterGrid);
		$UI.clear(DetailGrid);
		var Dafult={
			StartDate:DateFormatter(new Date()),
			EndDate:DateFormatter(new Date()),
			ExcludeNew:'Y',
			AdjSPCat:"0"
			}
		$UI.fillBlock('#Conditions',Dafult);
		$('#ScgId').combotree('options')['setDefaultFun']();
	}
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Clear()
		}
	});
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			Query()
		}
	});
	function Query(){
		var ParamsObj=$UI.loopBlock('Conditions');
		if(isEmpty(ParamsObj.StartDate)){
				$UI.msg('alert','开始日期不能为空!');
				return;
			}
		if(isEmpty(ParamsObj.EndDate)){
				$UI.msg('alert','截止日期不能为空!');
				return;
			}	
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(MasterGrid);
		$UI.clear(DetailGrid);
		MasterGrid.load({
			ClassName: 'web.DHCSTMHUI.INAdjSalePrice',
			QueryName: 'QueryAdjSpNo',
			Params: Params
		});		
	}
	$('#PrintBT').on('click', function(){
		PrintDetail()
	});
	function PrintDetail(){
		var SelectedRow = MasterGrid.getSelected();
		if(isEmpty(SelectedRow)){
			$UI.msg('alert','请选择需要打印的单据!');
			return;
		}
		var AspNo = SelectedRow['AspNo'];
		var ParamsObj=$UI.loopBlock('Conditions');
		var Params=JSON.stringify(ParamsObj)

		fileName="DHCSTM_HUI_ItmAdj.raq&AspNo="+AspNo+"&Params="+Params;
		DHCSTM_DHCCPM_RQPrint(fileName);
		/*
		fileName="{DHCSTM_HUI_ItmAdj.raq(Params="+Params+";AspNo="+AspNo+")}";
		fileName=TranslateRQStr(fileName);
		DHCSTM_DHCCPM_RQPrint(fileName);
		*/
		
	}
	var MasterGridCm = [[ {
			title: '调价单号',
			field: 'AspNo',
			width:150
		}, {
	        title:"最后更新日期",
	        field:'AspDate',
	        width:100,
	        align:'right'
		}, {
	        title:"操作人",
	        field:'AspUser',
	        width:70,
	        align:'right'
		}
	]];
	var MasterGrid = $UI.datagrid('#MasterGrid',{
		url : $URL,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INAdjSalePrice',
			QueryName: 'QueryAdjSpNo'
		},
		columns: MasterGridCm,
		onSelect:function(index, row){
			$UI.setUrl(DetailGrid)
			var ParamsObj=$UI.loopBlock('Conditions');
			var Params=JSON.stringify(ParamsObj)
			DetailGrid.load({
				ClassName: 'web.DHCSTMHUI.INAdjSalePrice',
				QueryName: 'QueryDetail',
				AspNo: row.AspNo,
				Params:Params
			});
		}
	})
	var DetailGridCm = [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '状态',
			field: 'Status',
			width:80
		}, {
			title: '库存分类',
			field: 'StkCatDesc',
			width:80
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
	        title:"调价单位",
	        field:'AspUomDesc',
	        width:100
	    }, {
	        title:"调前售价",
	        field:'PriorSpUom',
	        width:100,
	        align:'right'
		}, {
	        title:"调后售价",
	        field:'ResultSpUom',
	        width:100,
	        align:'right'
	    }, {
	        title:"差价(售价)",
	        field:'DiffSpUom',
	        width:80
	    }, {
	        title:"调前进价",
	        field:'PriorRpUom',
	        width:100,
	        align:'right'
	    }, {
	        title:"调后进价",
	        field:'ResultRpUom',
	        width:100,
	        align:'right'
	    }, {
	        title:"差价(进价)",
	        field:'DiffRpUom',
	        width:100
	    }, {
	        title:"调价原因",
	        field:'AdjReason',
	        width:80,
	        align:'center'
	    }, {
	        title:"物价文件号",
	        field:'WarrentNo',
	        width:100,
	        align:'center'
	    }, {
	        title:"计划生效日期",
	        field:'PreExecuteDate',
	        width:100,
	        align:'center'
	    }, {
	        title:"实际生效日期",
	        field:'ExecuteDate',
	        width:100,
	        align:'left'
	    }, {
	        title:"制单人",
	        field:'AdjUserName',
	        width:60,
	        align:'left'
	    }, {
	        title:"审核人",
	        field:'AuditUserName',
	        width:60,
	        align:'left'
	    }, {
	        title:"生效人",
	        field:'ExeUserName',
	        width:60,
	        align:'left'
	    }			
	]];
	var DetailGrid = $UI.datagrid('#DetailGrid',{
		url : '',
		queryParams : {
			ClassName: 'web.DHCSTMHUI.INAdjSalePrice',
			QueryName: 'QueryDetail'	
		},
		columns : DetailGridCm
	})
	
	Clear()
	
}
$(init);