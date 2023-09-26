// ����:��汨�����
//�������ֵ��object
var InScrapParamObj = GetAppPropValue('DHCSTINSCRAPM');
var init = function() {
	var ClearMain=function(){
		$UI.clearBlock('#Conditions');
		$UI.clear(INScrapAuditGrid);
		$UI.clear(INScrapAuditDetailGrid);
		DafultValue()
		$UI.fillBlock('#Conditions',DafultValue)
	}	
//Grid �� comboxData
	var SupLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var SupLocBox = $HUI.combobox('#SupLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+SupLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
//��ť��ز���
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			$UI.clear(INScrapAuditDetailGrid);
			var ParamsObj=$UI.loopBlock('#Conditions')
			if(isEmpty(ParamsObj.StartDate)){
				$UI.msg('alert','��ʼ���ڲ���Ϊ��!');
				return;
			}
			if(isEmpty(ParamsObj.EndDate)){
				$UI.msg('alert','��ֹ���ڲ���Ϊ��!');
				return;
			}
			if(isEmpty(ParamsObj.SupLoc)){
				$UI.msg('alert','��Ӧ���Ҳ���Ϊ��!');
				return;
			}
			var Params=JSON.stringify(ParamsObj);
			$UI.setUrl(INScrapAuditGrid)
			INScrapAuditGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINScrap',
				QueryName: 'DHCINSpM',
				Params:Params
			});
		}
	});
	$UI.linkbutton('#AduitBT',{
		onClick:function(){
			var Row=INScrapAuditGrid.getSelected()
			if(isEmpty(Row)){
				$UI.msg('alert','��ѡ����!');
				return;
			}			
			var Params=JSON.stringify(addSessionParams({Inscrap:Row.RowId}));
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINScrap',
				MethodName: 'Audit',
				Params:Params
				
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					$UI.clear(INScrapAuditGrid);
					$UI.clear(INScrapAuditDetailGrid);
					INScrapAuditGrid.commonReload();
				}else{
					$UI.msg('error',jsonData.msg);		
				}
			});
		}
	});
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			ClearMain();
		}
	});	
	$UI.linkbutton('#PrintBT',{
		onClick:function(){
			var SelectedRow = INScrapAuditGrid.getSelected();
			if(isEmpty(SelectedRow)){
				$UI.msg('alert',"û����Ҫ��ӡ�ĵ���!");
				return;
			}
			var Inscrap = SelectedRow['RowId'];
			PrintINScrap(Inscrap);
		}
	});
	var INScrapAuditGridCm = [[
	{
		title:"RowId",
		field:'RowId',
		hidden:true
	},{
		title:"���𵥺�",
		field:'No',
		width:180,
		align:'center',
		sortable:true   
	},{
		title:"��������",
		field:'LocDesc',
		width:150
	},{
		title:"�Ƶ���",
		field:'UserName',
		width:100,
		align:'left',
		sortable:true
	},{
		title:"�Ƶ�����",
		field:'Date',
		width:100,
		align:'left',
		sortable:true
	},{
		title:"�Ƶ�ʱ��",
		field:'Time',
		width:100,
		align:'left',
		sortable:true
	},{
		title:"��ɱ�־",
		field:'Completed',
		width:80,
		align:'center',
		formatter: BoolFormatter
	},{
		title:"��˱�־",
		field:'ChkFlag',
		width:80,
		align:'center',
		formatter: BoolFormatter
	},{
		title:"�����",
		field:'ChkUserName',
		width:100
	},{
		title:"�������",
		field:'ChkDate',
		width:100
	},{
		title:"���ʱ��",
		field:'ChkTime',
		width:100
	},{
		title:"���۽��",
		field:'RpAmt',
		align: 'right',
		width:100
	},{
		title:"�ۼ۽��",
		field:'SpAmt',
		align: 'right',
		width:100
	}
]];
	var INScrapAuditGrid = $UI.datagrid('#INScrapAuditGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINScrap',
			QueryName: 'DHCINSpM'
		},
		columns: INScrapAuditGridCm,
		showBar: true,
		onSelect:function(index, row){
			$UI.setUrl(INScrapAuditDetailGrid)
			INScrapAuditDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINScrapItm',
				QueryName: 'DHCINSpD',
				Inscrap:row.RowId,
				rows: 99999
			});
		},
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				INScrapAuditGrid.selectRow(0);
			}
		}
	})
	var INScrapAuditDetailGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		},{
			title:"����RowId",
			field:'Inclb',
			width:150,
			hidden: true
		},{
			title:"Incil",
			field:'Incil',
			width:150,
			hidden: true
		},{
			title:"���ʴ���",
			field:'InciCode',
			width:100
		},{
			title:"��������",
			field:'InciDesc',
			width:200,
			editor:'text'
		},{
			title:"��ֵ��־",
			field:'HVFlag',
			width:60,
			hidden:true
		},{
			title:"����~Ч��",
			field:'BatExp',
			width:150
		},{
			title:"����",
			field:'Manf',
			width:200
		},{
			title:"��������",
			field:'Qty',
			width:100,
			align:'right'
		},{
			title:"��λrowid",
			field:'PurUomId',
			width:100,
			hidden:true
		},{
			title:"��λ",
			field:'PurUomDesc',
			width:100
		},{
			title:"�ۼ�",
			field:'Sp',
			align: 'right',
			width:100
		},{
			title:"�ۼ۽��",
			field:'SpAmt',
			align: 'right',
			width:100
		},{
			title:"����",
			field:'Rp',
			align: 'right',
			width:100
		},{
			title:"���۽��",
			field:'RpAmt',
			align: 'right',
			width:100
		}
	]];
	var INScrapAuditDetailGrid = $UI.datagrid('#INScrapAuditDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINScrapItm',
			QueryName: 'DHCINSpD',
			rows: 99999
		},
		pagination:false,
		columns: INScrapAuditDetailGridCm
	})
	/*--���ó�ʼֵ--*/
	var DafultValue=function(){
		var StDate = DateAdd(new Date(), 'd', parseInt(-7));
		var DafultValue={
			RowId:"",
			SupLoc:gLocObj,
			StartDate:DateFormatter(StDate),
			EndDate:DateFormatter(new Date()),
			Audit:"N"
		}
		$UI.fillBlock('#Conditions',DafultValue)
	}
	DafultValue()
}
$(init);