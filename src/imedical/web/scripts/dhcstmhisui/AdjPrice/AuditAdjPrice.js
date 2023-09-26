// /����: ��˵��۵�
// /����: ��˵��۵�
// /��д�ߣ�zhangxiao
// /��д����: 2018.06.11
var init = function () {
	var Clear=function(){
		$UI.clearBlock('#Conditions');
		$UI.clear(AdjPriceGrid);
		var Dafult={
			StartDate:DateFormatter(new Date()),
			EndDate:DateFormatter(new Date()),
			Status:"No"
			}
		$UI.fillBlock('#Conditions',Dafult);
		$('#ScgId').combotree('options')['setDefaultFun']();
	}
	var InciHandlerParams=function(){
		var Scg=$("#ScgId").combotree('getValue');
		var Obj={StkGrpRowId:Scg,StkGrpType:"M",BDPHospital:gHospId};
		return Obj
	}
	$("#InciDesc").lookup(InciLookUpOp(InciHandlerParams,'#InciDesc','#Inci'));	
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
		var ParamsObj=$UI.loopBlock('Conditions');
		if(isEmpty(ParamsObj.StartDate)){
			    $UI.msg('alert','��ʼ���ڲ���Ϊ��!')
				return;
			}
		if(isEmpty(ParamsObj.EndDate)){
				$UI.msg('alert','��ֹ���ڲ���Ϊ��!')
				return;
			}	
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(AdjPriceGrid);
		AdjPriceGrid.load({
			ClassName: 'web.DHCSTMHUI.INAdjSalePrice',
			QueryName: 'QueryAspInfo',
			Params: Params
		});		
	}
	$UI.linkbutton('#DenyBT',{
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#Conditions')
			var Params=JSON.stringify(ParamsObj)
			var Rows=AdjPriceGrid.getSelectedData();
			if(Rows===false){return}; //��֤δͨ��  ���ܱ���
			if(Rows==""){
				$UI.msg('alert','��ѡ����Ҫȡ����˵ĵ��۵�!');
				return false;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.INAdjSalePrice',
				MethodName: 'SetCancelAudit',
				Params: Params,
				Rows: JSON.stringify(Rows)
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					$UI.clear(AdjPriceGrid);
					Query()
				}else{
					 $UI.msg('error',jsonData.msg);
					}
			});
		}
	});
	$UI.linkbutton('#AduitBT',{
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#Conditions')
			var Params=JSON.stringify(ParamsObj)
			var Rows=AdjPriceGrid.getSelectedData();
			if(Rows===false){return}; //��֤δͨ��  ���ܱ���
			if(Rows==""){
				$UI.msg('alert','��ѡ����Ҫ��˵ĵ��۵�!');
				return false;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.INAdjSalePrice',
				MethodName: 'SetAudit',
				Params: Params,
				Rows: JSON.stringify(Rows)
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					$UI.clear(AdjPriceGrid);
					Query()
				}else{
					 $UI.msg('error',jsonData.msg);
					}
			});
		}
	});
	var AdjPriceCm = [[
		{	field: 'ck',
			checkbox: true
		},{
			title: 'RowId',
			field: 'RowId',
			saveCol: true,
			hidden: true
		}, {
			title : "���۵���",
			field : 'AspNo',
			width : 180
		}, {
			title : "״̬",
			field : 'Status',
			width : 100
		},{
	        title:"������",
	        field:'StkCatDesc',
	        width:100,
	        align:'left'	  
	    }, {
			title: '����RowId',
			field: 'Inci',
			hidden: true			
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width:100
		}, {
			title: '��������',
			field: 'InciDesc',
			width:150
		}, {
        	title: "���",
       		field:'Spec',
        	width:100
    	}, {
	        title:"���۵�λ",
	        field:'AspUomDesc',
	        width:100,
	        align:'right'
	    }, {
	        title:"��ǰ�ۼ�",
	        field:'PriorSpUom',
	        width:100,
	        align:'right'
	    }, {
	        title:"�����ۼ�",
	        field:'ResultSpUom',
	        width:100,
	        align:'right',
	        editor:{type:'numberbox',options:{required:true}}
	    },{
	        title:"���(�ۼ�)",
	        field:'DiffSpUom',
	        width:100,
	        align:'right',
			editor:{}
	    }, {
	        title:"��ǰ����",
	        field:'PriorRpUom',
	        width:100,
	        align:'right'
		}, {
	        title:"�������",
	        field:'ResultRpUom',
	        width:100,
	        align:'right',
	        editor:{type:'numberbox',options:{required:true}}
	    },{
	        title:"���(����)",
	        field:'DiffRpUom',
	        width:100,
	        align:'right',
			editor:{}
	    },{
	        title:"�Ƶ�����",
	        field:'AdjDate',
	        width:120,
	        align:'left',
			editor:{}
	    },{
	        title:"�ƻ���Ч����",
	        field:'PreExecuteDate',
	        width:120,
	        align:'left',
			editor:{type:'datebox',options:{}}
	    },{
	        title:"ʵ����Ч����",
	        field:'ExecuteDate',
	        width:120,
	        align:'left',
			editor:{}
	    },{
	        title:"����ԭ��",
	        field:'AdjReason',
	        width:120,
	        align:'left'
	    },{
	        title:"������",
	        field:'AdjUserName',
	        width:100,
	        align:'left',
			editor:{}
	    },{
	        title:"��������",
	        field:'MarkTypeDesc',
	        width:120,
	        align:'left',
			editor:{}
	    },{
	        title:"����ۼ�",
	        field:'MaxSp',
	        width:100,
	        align:'right',
			editor:{}
	    },{
	        title:"����ļ���",
	        field:'WarrentNo',
	        width:120,
	        align:'left',
	        editor:{type:'text',options:{}}
	    },{
	        title:"����ļ�����",
	        field:'WnoDate',
	        width:120,
	        align:'left',
	        editor:{type:'datebox',options:{}}
	    },{
	        title:"��Ʊ��",
	        field:'InvNo',
	        width:120,
	        align:'left',
			editor:{type:'text',options:{}}
	    },{
	        title:"��Ʊ����",
	        field:'InvDate',
	        width:120,
	        align:'left',
			editor:{type:'datebox',options:{}}
	    }
	]];
	var AdjPriceGrid = $UI.datagrid('#AdjPriceGrid', {
		url:$URL,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INAdjSalePrice',
			QueryName: 'QueryAspInfo'
		},
		columns: AdjPriceCm,
		singleSelect:false,
		showBar:true,
		sortName: 'RowId',  
		sortOrder: 'Desc'
	})
	Clear()
}
$(init);
	
	