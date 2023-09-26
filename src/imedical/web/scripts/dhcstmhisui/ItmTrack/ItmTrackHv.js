/*ȷ��*/
var init = function () {
	var Clear=function(){
		$UI.clearBlock('#FindConditions');
		$UI.clear(BarMainGrid);
		$UI.clear(BarDetailGrid);
	///���ó�ʼֵ ����ʹ������
		var Dafult={
					StartDate: TrackDefaultStDate(),
					EndDate: TrackDefaultEdDate()
					}
		$UI.fillBlock('#FindConditions',Dafult)
	}
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			Query();
		}
		});
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Clear();
		}
	});
	$UI.linkbutton('#ConfirmBT',{
		onClick:function(){
			var Selected=BarMainGrid.getSelectedData();
				if(Selected.length==0){
					$UI.msg('alert','��ѡ��!!')
					return;
				}
				var BarCode=Selected[0].BarCode
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCItmTrack',
					MethodName: 'SaveHv',
					label: BarCode
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
					}else{
						$UI.msg('error',jsonData.msg);
					}
				});
		}
	});	
	var BarMainCm = [[{
			title : "RowId",
			field : 'RowId',
			width : 100,
			hidden : true
		}, {
			title : "InciId",
			field : 'InciId',
			width : 120,
			hidden : true
		}, {
			title : '���ʴ���',
			field : 'InciCode',
			width : 150
		}, {
			title : '��������',
			field : 'InciDesc',
			width : 150
		}, {
			title : "����",
			field : 'BarCode',
			width : 200
		}, {
			title : "�Դ�����",
			field : 'OriginalCode',
			width : 200
		}, {
			title : '״̬',
			field : 'Status',
			formatter : StatusFormatter,
			width : 70
		}, {
			title : '����id',
			field : 'BatNo',
			width : 90,
			hidden: true
		}, {
			title : '����~Ч��',
			field : 'BatExp',
			width : 70
		}, {
			title : '���',
			field : 'Spec',
			width : 90
		}, {
			title : "������",
			field : 'SpecDesc',
			width : 120
		}, {
			title : "��λ",
			field : 'UomDesc',
			width : 80
		}, {
			title : "��Ӧ��",
			field : 'VendorDesc',
			width : 100
		}, {
			title : "����",
			field : 'ManfDesc',
			width : 100
		}, {
			title : "ȷ��",
			field : 'RetOriFlag',
			width : 100
		}, {
			title : "��������(ע��)����",
			field : 'DhcitDate',
			width : 100
		}, {
			title : "��������(ע��)ʱ��",
			field : 'DhcitTime',
			width : 100
		}, {
			title : "������",
			field : 'DhcitUser',
			width : 100
		}
	]];
	var BarMainGrid = $UI.datagrid('#BarMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'Query'
		},
		columns: BarMainCm,
		showBar:true,
		onSelect:function(index, row){
			BarDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCItmTrack',
				QueryName: 'QueryItmTrackItem',
				Parref: row.RowId
			});
		}
	})
	
	var BarDetailCm = [[{
			title : "RowId",
			field : 'RowId',
			width : 100,
			hidden : true
		}, {
			title : '����',
			field : 'Type',
			formatter: TypeRenderer,
			width : 80
		}, {
			title : 'Pointer',
			field : 'Pointer',
			width : 230,
			hidden: true
		}, {
			title : '̨�˱��',
			field : 'IntrFlag',
			width : 80
		}, {
			title : '�����',
			field : 'OperNo',
			width : 80
		}, {
			title : 'ҵ��������',
			field : 'Date',
			width : 80
		}, {
			title : "ҵ����ʱ��",
			field : 'Time',
			width : 180
		}, {
			title : "ҵ�������",
			field : 'User',
			width : 70
		}, {
			title : "λ����Ϣ",
			field : 'OperOrg',
			width : 90
		}		
	]];
	
	var BarDetailGrid = $UI.datagrid('#BarDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'QueryItmTrackItem'
		},
		columns: BarDetailCm,
		showBar:true
	})
	function Query(){
		var ParamsObj=$UI.loopBlock('#FindConditions')
		if(isEmpty(ParamsObj.StartDate)){
			$UI.msg('alert','��ʼ���ڲ���Ϊ��!');
			return;
		}
		if(isEmpty(ParamsObj.EndDate)){
			$UI.msg('alert','��ֹ���ڲ���Ϊ��!');
			return;
		}
		var Params=JSON.stringify(ParamsObj);
		$UI.clear(BarDetailGrid);
		BarMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'Query',
			Params:Params
		});
	}
	
	Clear();

}
$(init);