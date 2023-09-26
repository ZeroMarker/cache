// /����: ���۵���ѯ
// /����: ���۵���ѯ
// /��д�ߣ�zhangxiao
// /��д����: 2018.06.08
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
				$UI.msg('alert','��ʼ���ڲ���Ϊ��!');
				return;
			}
		if(isEmpty(ParamsObj.EndDate)){
				$UI.msg('alert','��ֹ���ڲ���Ϊ��!');
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
			$UI.msg('alert','��ѡ����Ҫ��ӡ�ĵ���!');
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
			title: '���۵���',
			field: 'AspNo',
			width:150
		}, {
	        title:"����������",
	        field:'AspDate',
	        width:100,
	        align:'right'
		}, {
	        title:"������",
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
			title: '״̬',
			field: 'Status',
			width:80
		}, {
			title: '������',
			field: 'StkCatDesc',
			width:80
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
	        field:'AspUomDesc',
	        width:100
	    }, {
	        title:"��ǰ�ۼ�",
	        field:'PriorSpUom',
	        width:100,
	        align:'right'
		}, {
	        title:"�����ۼ�",
	        field:'ResultSpUom',
	        width:100,
	        align:'right'
	    }, {
	        title:"���(�ۼ�)",
	        field:'DiffSpUom',
	        width:80
	    }, {
	        title:"��ǰ����",
	        field:'PriorRpUom',
	        width:100,
	        align:'right'
	    }, {
	        title:"�������",
	        field:'ResultRpUom',
	        width:100,
	        align:'right'
	    }, {
	        title:"���(����)",
	        field:'DiffRpUom',
	        width:100
	    }, {
	        title:"����ԭ��",
	        field:'AdjReason',
	        width:80,
	        align:'center'
	    }, {
	        title:"����ļ���",
	        field:'WarrentNo',
	        width:100,
	        align:'center'
	    }, {
	        title:"�ƻ���Ч����",
	        field:'PreExecuteDate',
	        width:100,
	        align:'center'
	    }, {
	        title:"ʵ����Ч����",
	        field:'ExecuteDate',
	        width:100,
	        align:'left'
	    }, {
	        title:"�Ƶ���",
	        field:'AdjUserName',
	        width:60,
	        align:'left'
	    }, {
	        title:"�����",
	        field:'AuditUserName',
	        width:60,
	        align:'left'
	    }, {
	        title:"��Ч��",
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