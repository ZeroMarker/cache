// /����: ���������ѯ
// /����: ���������ѯ
// /��д�ߣ�zhangxiao
// /��д����: 2018.06.15
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
	var LocParams=JSON.stringify(addSessionParams({Type:"Login"}));
	var LocBox = $HUI.combobox('#Loc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+LocParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	var Clear=function(){
		$UI.clearBlock('#Conditions');
		$UI.clear(DetailGrid);
		var Dafult={
			StartDate:DateFormatter(new Date()),
			EndDate:DateFormatter(new Date()),
			Loc:gLocObj,
			OptType:"1"
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
				$UI.msg('alert','��ʼ���ڲ���Ϊ��!');
				return;
			}
		if(isEmpty(ParamsObj.EndDate)){
				$UI.msg('alert','��ֹ���ڲ���Ϊ��!');
				return;
			}	
		var Params = JSON.stringify(ParamsObj);
		DetailGrid.load({
			ClassName: 'web.DHCSTMHUI.AspAmount',
			QueryName: 'QueryAspAmount',
			Params: Params
		});		
	}
	var DetailGridCm = [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width:120
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
	        field:'AspUom',
	        width:100
	    }, {
	        title:"�����",
	        field:'StkQty',
	        align:'right',
	        width:100
	    }, {
	        title:"��ǰ�ۼ�",
	        field:'PriorSp',
	        width:100,
	        align:'right'
		}, {
	        title:"�����ۼ�",
	        field:'ResultSp',
	        width:100,
	        align:'right'
	    }, {
	        title:"���(�ۼ�)",
	        field:'DiffSp',
	        width:80
	    }, {
	        title:"��ǰ����",
	        field:'PriorRp',
	        width:100,
	        align:'right'
	    }, {
	        title:"�������",
	        field:'ResultRp',
	        width:100,
	        align:'right'
	    }, {
	        title:"���(����)",
	        field:'DiffRp',
	        width:100
	    }, {
	        title:"������(�ۼ�)",
	        field:'SpAmt',
	        width:80,
	        align:'center'
	    }, {
	        title:"������(����)",
	        field:'RpAmt',
	        width:100,
	        align:'center'
	    }, {
	        title:"����",
	        field:'LocDesc',
	        width:100,
	        align:'center'
	    }, {
	        title:"��Ч����",
	        field:'ExecuteDate',
	        width:100,
	        align:'left'
	    }, {
	        title:"������",
	        field:'AspUser',
	        width:60,
	        align:'left'
	    }, {
	        title:"����ԭ��",
	        field:'AspReason',
	        width:60,
	        align:'left'
	    }		
	]];
	var DetailGrid = $UI.datagrid('#DetailGrid', {
		url:$URL,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.AspAmount',
			QueryName: 'QueryAspAmount'
		},
		sortName: 'RowId',  
		sortOrder: 'Desc',
		showBar:true,
		columns: DetailGridCm	
	})
	
	Clear()
}
$(init);