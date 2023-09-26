function GetSciItm(){
	var Clear=function(){
		$UI.clearBlock('#SciConditions');
		$UI.clear(SciGrid);
		var Dafult={
			SciStartDate: DateFormatter(new Date()),
			SciEndDate: DateFormatter(new Date()),
			CreatedFlag:"N"
		};
		$UI.fillBlock('#SciWin',Dafult)
	}
	$HUI.dialog('#SciWin').open();
	$UI.linkbutton('#SciQueryBT',{
		onClick:function(){
			NewItmSearch();
		}
	});
	
	function NewItmSearch(){
		var ParamsObj=$UI.loopBlock('#SciConditions')
		var Params=JSON.stringify(ParamsObj);
		SciGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCNewItm',
			QueryName: 'GetNewItm',
			Params:Params
		});
	}
	$UI.linkbutton('#SciPickBT',{
		onClick:function(){
			SciPickFun();
		}
	});
	function SciPickFun(){
		if(isEmpty(SciGrid.getSelected())){
			return;
		}
		var NIRowId=SciGrid.getSelected().NIRowId;
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCNewItm',
			MethodName: 'GetItmDetail',
			RowId:NIRowId
		}, function(jsonData){
			$UI.clearBlock('#BasicInciData');
			$UI.fillBlock('#BasicInciData',jsonData);
			$HUI.dialog('#SciWin').close();
		});
	}
	
	$UI.linkbutton('#SciClearBT',{
		onClick:function(){
			Clear();
		}
	});
	$UI.linkbutton('#NewItmSynSCIBT', {
		onClick: function(){
			var Param = gLocId + '^' + gUserId;
			var Result = $.m({
				ClassName: 'web.DHCSTMHUI.ServiceForSCI',
				MethodName: 'getSciHopInc',
				Param: Param
			}, false);
			if(Result == 0){
				$UI.msg('success', 'ͬ���ɹ�!');
				NewItmSearch();
			}else{
				$UI.msg('error', '����ʧ��:' + Result);
			}
		}
	});
	var SciCm = [[{
			title: 'NIRowId',
			field: 'NIRowId',
			width:150,
			hidden: true
		},{
			title: 'Inci',
			field: 'Inci',
			width:150,
			hidden: true
		},{
			title: '���ʴ���',
			field: 'InciCode',
			width:150,
			hidden: true
		}, {
			title: '��������',
			field: 'InciDesc',
			width:150,
			hidden: true
		}, {
			title: "����",
			field:'NIDesc',
			width:150
		}, {
			title:"���",
			field:'NISpec',
			width:100,
			align:'right'
		}, {
			title:"�ͺ�",
			field:'NIModel',
			width:100
		}, {
			title:"Ʒ��",
			field:'NIBrand',
			width:100
		}, {
			title:"������λ",
			field:'NIBUomDesc',
			width:100
		}, {
			title:"��ⵥλ",
			field:'NIPUomDesc',
			width:100
		},{ title:"����",
			field:'NIRpPUom',
			width:100,
			align:'right'
		}, {
			title:"���ڱ�־",
			field:'NIImportFlag',
			width:100,
			align:'cenrer'
		}, {
			title:"��Ӧ��",
			field:'NIVendorDesc',
			width:100
		},{
			title:"����",
			field:'NIManfDesc',
			width:100
		},{
			title:"һ���Ա�־",
			field:'NIBAflag',
			width:100,
			align:'cenrer'
		}
	]];
	var SciGrid = $UI.datagrid('#SciGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCNewItm',
			QueryName: 'GetNewItm'
		},
		columns: SciCm,
		onDblClickRow: function(index, row){
			SciPickFun();
		}
	});
	Clear();
}