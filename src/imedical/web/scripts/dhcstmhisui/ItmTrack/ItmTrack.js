/*��ֵ����*/
var init = function () {
	var Clear=function(){
		$UI.clearBlock('#FindConditions');
		$UI.clear(BarMainGrid);
		$UI.clear(BarDetailGrid);
		///���ó�ʼֵ ����ʹ������
		var Dafult={
			StartDate: TrackDefaultStDate(),
			EndDate: TrackDefaultEdDate(),
			FRecLoc: gLocObj,
			AuditFlag: "N",
			FStatusBox: "Y"
		};
		$UI.fillBlock('#FindConditions',Dafult);
	}
	var FRecLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var FRecLocBox = $HUI.combobox('#LocId', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+FRecLocParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	
	var VendorBoxParams=JSON.stringify(addSessionParams({APCType:"M",RcFlag:"Y"}));
	$HUI.combobox('#Vendor', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorBoxParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	
	$('#Status').simplecombobox({
		data: [
			{RowId: 'Reg', Description: 'ע��'},
			{RowId: 'Enable', Description: '����'},
			{RowId: 'Used', Description: '����'},
			{RowId: 'Else', Description: '����'}
		]
	});
	$('#wardno').bind('keydown', function(event){
		if(event.keyCode == 13){
			var PapmiNo = $(this).val();
			if(isEmpty(PapmiNo)){
				$UI.msg('alert', '������ǼǺ�!');
				return false;
			}
			try{
				var patinfostr=tkMakeServerCall("web.DHCSTMHUI.HVMatOrdItm", "Pa",PapmiNo);
				var patinfoarr=patinfostr.split("^");
				var newPaAdmNo=patinfoarr[0];
				var patinfo=patinfoarr[1]+","+patinfoarr[2];
				$("#wardno").val(newPaAdmNo);
			}catch(e){}
			 return false;
		}
	});
	var HandlerParams=function(){
		var Obj={Hv:'Y',StkGrpType:"M"};
		return Obj;
	}
	$("#InciDesc").lookup(InciLookUpOp(HandlerParams,'#InciDesc','#Inci'));
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Clear();
		}
	});
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			Query();
		}
	});
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
		BarMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'Query',
			Params:Params
		});
	}
	
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Clear();
		}
	});
	
	$UI.linkbutton('#PrintBT',{
		onClick: function(){
			var rowsData = BarMainGrid.getSelections();
			if(isEmpty(rowsData)){
				$UI.msg('alert', '��ѡ����Ҫ��ӡ������!');
				return;
			}
			for(var i = 0, Len = rowsData.length; i < Len; i++){
				var row = rowsData[i];
				var BarCode = row['BarCode'];
				PrintBarcode(BarCode,1);
			}
		}
	});
	
	var BarMainCm = [[
		{
			title : "RowId",
			field : 'RowId',
			width : 50,
			hidden : true
		}, {
			title : "InciId",
			field : 'InciId',
			width : 120,
			hidden : true
		}, {
			title : '���ʴ���',
			field : 'InciCode',
			width : 100
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
			title : "��ǰλ��",
			field : 'CurrentLoc',
			width : 100
		}, {
			title : "��ӡ���",
			field : 'PrintFlag',
			formatter : BoolFormatter,
			align : 'center',
			width : 80
		}, {
			title : 'Incib',
			field : 'Incib',
			width : 90,
			hidden: true
		}, {
			title : 'Inclb',
			field : 'Inclb',
			width : 100,
			hidden: true
		}, {
			title : '����~Ч��',
			field : 'BatExp',
			width : 150,
			hidden : true
		},{
			title : '����',
			field : 'BatNo',
			width : 100
		},{
			title : 'Ч��',
			field : 'ExpDate',
			width : 90
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
			width : 160
		}, {
			title : "����",
			field : 'ManfDesc',
			width : 160
		}, {
			title : "��������(ע��)ʱ��",
			field : 'DateTime',
			width : 160
		}, {
			title : "������",
			field : 'DhcitUser',
			width : 100
		}, {
			title: '�Դ�������',
			field: 'BatchCode',
			width: 200
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
				Parref: row['RowId'],
				rows: 99999
			});
		},
		onDblClickRow: function(index, row){
			var RowId = row['RowId'];
			if (isEmpty(RowId)) {
				return;
			}
			var BarCode = row['BarCode'];
			var InciDesc = row['InciDesc'];
			var InfoStr = BarCode + ' : ' + InciDesc;
			BarCodePackItm(RowId, InfoStr);
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
			formatter : TypeRenderer,
			width : 80
		}, {
			title : 'Pointer',
			field : 'Pointer',
			width : 80,
			hidden: true
		}, {
			title : '̨�˱��',
			field : 'IntrFlag',
			formatter : BoolFormatter,
			align : 'center',
			width : 80
		}, {
			title : '�����',
			field : 'OperNo',
			width : 120
		}, {
			title : 'ҵ��������',
			field : 'Date',
			hidden : true,
			width : 120
		}, {
			title : "ҵ����ʱ��",
			field : 'Time',
			formatter : function(value, row, index){
				return row['Date'] + ' ' + value;
			},
			width : 160
		}, {
			title : "ҵ�������",
			field : 'User',
			width : 80
		}, {
			title : "λ����Ϣ",
			field : 'OperOrg',
			width : 120
		}		
	]];
	
	var BarDetailGrid = $UI.datagrid('#BarDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'QueryItmTrackItem',
			rows: 99999
		},
		pagination:false,
		columns: BarDetailCm,
		showBar:true
	});
	
	Clear();
}
$(init);