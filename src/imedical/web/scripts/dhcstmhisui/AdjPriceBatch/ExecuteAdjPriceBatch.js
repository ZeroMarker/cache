// /名称: 调价单生效(批次)
// /描述: 调价单生效(批次)
// /编写者：zhangxiao
// /编写日期: 2018.07.17
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
		$UI.clear(DetailGrid);
		var Dafult={
			StartDate:DateFormatter(new Date()),
			EndDate:DateFormatter(new Date()),
			Status:"A"
			}
		$UI.fillBlock('#Conditions',Dafult);
		$('#ScgId').combotree('options')['setDefaultFun']();
	}
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Clear();
		}
	});
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			Query()
		}
	});
	function Query(){
		if(isEmpty($HUI.combobox("#Status").getValue())){
				$UI.msg('alert','调价单状态不能为空!');
				return false;
			};
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
		$UI.clear(DetailGrid);
		DetailGrid.load({
			ClassName: 'web.DHCSTMHUI.INAdjPriceBatch',
			QueryName: 'QueryAspBatInfo',
			Params: Params
		});		
	}
	$UI.linkbutton('#ExeBT',{
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#Conditions')
			var Params=JSON.stringify(ParamsObj)
			var Rows=DetailGrid.getSelectedData();
			if(Rows===false){return}; //验证未通过  不能保存
			if(Rows==""){
				$UI.msg('alert','请选择需要生效的调价单!');
				return
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.INAdjPriceBatch',
				MethodName: 'SetExe',
				Params: Params,
				Rows: JSON.stringify(Rows)
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					$UI.clear(DetailGrid);
					Query()
				}else{
					 $UI.msg('error',jsonData.msg);
					}
			});
		}
	});
	$UI.linkbutton('#SaveBT',{
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#Conditions')
			var Params=JSON.stringify(ParamsObj)
			var Rows=DetailGrid.getChangesData();
			if(Rows===false){return}; //验证未通过  不能保存
			if (isEmpty(Rows)) {
				$UI.msg('alert','没有需要保存的调价单信息!');
				return
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.INAdjPriceBatch',
				MethodName: 'BatUpdatePriceAPB',
				Params: Params,
				Rows: JSON.stringify(Rows)
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					$UI.clear(DetailGrid);
					Query()
				}else{
					 $UI.msg('error',jsonData.msg);
					}
			});
		}
	});
	var DetailCm = [[
		{	field: 'ck',
			checkbox: true
		},{
			title: 'RowId',
			field: 'RowId',
			saveCol: true,
			hidden: true
		}, {
			title : "调价单号",
			field : 'AspNo',
			width : 180
		},{
			title: 'Incib',
			field: 'Incib',
			hidden: true
		}, {
			title : "状态",
			field : 'Status',
			width : 100
		},{
	        title:"库存分类",
	        field:'StkCatDesc',
	        width:100,
	        align:'left'	  
	    }, {
			title: '物资RowId',
			field: 'Inci',
			hidden: true			
		}, {
			title: '物资代码',
			field: 'InciCode',
			width:100
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
	        width:100,
	        align:'right'
	    }, {
	        title:"批次/效期",
	        field:'BatExp',
	        width:100,
	        align:'right'
	    }, {
	        title:"调前售价",
	        field:'PriorSpUom',
	        width:100,
	        align:'right'
	    }, {
	        title:"调后售价",
	        field:'ResultSpUom',
	        width:100,
	        align:'right',
	        saveCol: true,
	        editor:{type:'numberbox',options:{required:true}}
	    },{
	        title:"差价(售价)",
	        field:'DiffSpUom',
	        width:100,
	        align:'right'
	    }, {
	        title:"调前进价",
	        field:'PriorRpUom',
	        width:100,
	        align:'right'
		}, {
	        title:"调后进价",
	        field:'ResultRpUom',
	        width:100,
	        align:'right',
	        saveCol: true,
	        editor:{type:'numberbox',options:{required:true}}
	    },{
	        title:"差价(进价)",
	        field:'DiffRpUom',
	        width:100,
	        align:'right'
	    },{
	        title:"制单日期",
	        field:'AdjDate',
	        width:120,
	        align:'left'
	    },{
	        title:"计划生效日期",
	        field:'PreExecuteDate',
	        width:120,
	        align:'left'
	    },{
	        title:"实际生效日期",
	        field:'ExecuteDate',
	        width:120,
	        align:'left'
	    },{
	        title:"调价原因",
	        field:'AdjReason',
	        width:120,
	        align:'left'
	    },{
	        title:"调价人",
	        field:'AdjUserName',
	        width:100,
	        align:'left'
	    },{
	        title:"定价类型",
	        field:'MarkTypeDesc',
	        width:120,
	        align:'left'
	    },{
	        title:"最高售价",
	        field:'MaxSp',
	        width:100,
	        align:'right'
	    },{
	        title:"物价文件号",
	        field:'WarrentNo',
	        width:120,
	        align:'left'
	    },{
	        title:"物价文件日期",
	        field:'WnoDate',
	        width:120,
	        align:'left'
	    }
	]];
	var DetailGrid = $UI.datagrid('#DetailGrid', {
		url:$URL,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INAdjPriceBatch',
			QueryName: 'QueryAspBatInfo'
		},
		columns: DetailCm,
		singleSelect:false,
		sortName: 'RowId',  
		sortOrder: 'Desc',
		showBar:true,
		onClickCell: function(index, filed ,value){	
			DetailGrid.commonClickCell(index,filed,value);
		}
	})
	
	Clear()	
	
}
$(init);