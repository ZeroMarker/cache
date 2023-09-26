/*
������ѯ
*/
var ImportPoSearch=function(Fn){
	$HUI.dialog('#ImportByPo',{
		width: gWinWidth,
		height: gWinHeight
	}).open();
	
	var Clear = function(){
		$UI.clearBlock('#ImportByPoConditions');
		$UI.clear(PoMainGrid);
		$UI.clear(PoDetailGrid);
		
		var DefaPoData = {
			PoStartDate: TrackDefaultStDate(),
			PoEndDate: TrackDefaultEdDate(),
			PoRecLoc: gLocObj
		};
		$UI.fillBlock('#ImportByPoConditions', DefaPoData);
	}
	
	var PRecLocParams=JSON.stringify(addSessionParams({Type:"Login"}));
	var PRecLocBox = $HUI.combobox('#PoRecLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+PRecLocParams,
			valueField: 'RowId',
			textField: 'Description'
	});	
	var VendorParams=JSON.stringify(addSessionParams({APCType:"M",RcFlag:"Y"}));
	var VendorBox = $HUI.combobox('#VendorBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$UI.linkbutton('#PoQueryBT',{
		onClick:function(){
			PoQuery();
		}
	});
	function PoQuery(){
		var ParamsObj=$CommonUI.loopBlock('#ImportByPoConditions')
		if(isEmpty(ParamsObj.PoStartDate)){
			$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
			return;
		}
		if(isEmpty(ParamsObj.PoEndDate)){
			$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
			return;
		}
		if(isEmpty(ParamsObj.PoRecLoc)){
			$UI.msg('alert', '�����Ҳ���Ϊ��!');
			return;
		}	
		var Params=JSON.stringify(ParamsObj);
		PoMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'QueryPo',
			Params:Params,
			sort:"",
			order:""
		});
	}
	
	$UI.linkbutton('#PoClearBT',{
		onClick:function(){
			Clear();
		}
	});
	$UI.linkbutton('#PoReturnBT',{
		onClick:function(){
			var Row=PoMainGrid.getSelected();
			if(isEmpty(Row)){
				$UI.msg('alert', '��ѡ��Ҫ���صĶ���!');
				return;
			}
			var VendorId = Row.VenId;
			var VendorDesc = Row.Vendor;
			var rowsData = PoDetailGrid.getData();   //ȡgrid���м�¼
			Fn(rowsData,VendorId,VendorDesc);
			$HUI.dialog('#ImportByPo').close();
		}
	});
	var PoMainCm = [[{
			title : "RowId",
			field : 'PoId',
			width : 100,
			hidden : true
		}, {
			title : "��������",
			field : 'PoNo',
			width : 120
		}, {
			title : "��Ӧ��id",
			field : 'VenId',
			width : 50,
			hidden: true
		}, {
			title : "��Ӧ��",
			field : 'Vendor',
			width : 150
		}, {
			title : '��������',
			field : 'PoLoc',
			width : 150
		}, {
			title : '�깺����',
			field : 'ReqLoc',
			width : 150
		}, {
			title : '��������',
			field : 'PoDate',
			width : 90
		}
	]];
	
	var PoMainGrid = $UI.datagrid('#PoMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'QueryPo'
		},
		columns: PoMainCm,
		onSelect:function(index, row){
			PoDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCItmTrack',
				QueryName: 'INPOItmQuery',
				Parref: row.PoId
			});
		},
		onDblClickRow:function(index, row){
			Fn(row.PoId);
			$HUI.dialog('#ImportByPo').close();
		},
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				PoMainGrid.selectRow(0);
			}
		}
	});
	
	var PoDetailCm = [[{
			title : "RowId",
			field : 'PoItmId',
			width : 100,
			hidden : true
		}, {
			title : '����id',
			field : 'IncId',
			hidden : true,
			width : 80
		}, {
			title : '���ʴ���',
			field : 'IncCode',
			width : 80
		}, {
			title : '��������',
			field : 'IncDesc',
			width : 200
		}, {
			title : "���",
			field : 'Spec',
			width : 80
		}, {
			title : "����",
			field : 'AvaQty',
			align : 'right',
			width : 60
		}, {
			title : "����",
			field : 'Rp',
			align : 'right',
			width : 60
		}, {
			title : "��λid",
			field : 'PurUomId',
			width : 50,
			hidden : true
		}, {
			title : "��λ",
			field : 'PurUom',
			width : 50
		}, {
			title : "��������",
			field : 'PurQty',
			align : 'right',
			width : 90
		}, {
			title : "���������",
			field : 'ImpQty',
			align : 'right',
			width : 90
		}, {
			title : "����������",
			field : 'BarcodeQty',
			align : 'right',
			width : 90
		},{
			title : "ע��֤����",
			field : 'CertNo',
			width : 90
		},{
			title : "ע��֤Ч��",
			field : 'CertExpDate',
			width : 90
		}	
	]];
	
	var PoDetailGrid = $UI.datagrid('#PoDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'INPOItmQuery'
		},
		columns: PoDetailCm
	})
	Clear();
	PoQuery();
}