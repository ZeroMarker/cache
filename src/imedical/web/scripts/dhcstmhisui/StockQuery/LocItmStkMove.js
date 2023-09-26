/*̨�˲�ѯ*/
var init = function() {
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			QueryMasterInfo();
		}
	});
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			MasterClear();
		}
	});
	var PhaLocParams=JSON.stringify(addSessionParams({Type:"Login"}));
	var PhaLocBox = $HUI.combobox('#PhaLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+PhaLocParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	$('#StkGrpId').stkscgcombotree({
		onSelect:function(node){
			$.cm({
				ClassName:'web.DHCSTMHUI.Common.Dicts',
				QueryName:'GetStkCat',
				ResultSetType:'array',
				StkGrpId:node.id
			},function(data){
				StkCatBox.clear();
				StkCatBox.loadData(data);
				})
			}
	});
	var StkCatBox = $HUI.combobox('#StkCat', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	var HandlerParams = function(){
		var StkGrpId = $('#StkGrpId').combotree('getValue');
		var PhaLoc = $('#PhaLoc').combo('getValue');
		var Obj = {StkGrpRowId:StkGrpId, StkGrpType:'M', Locdr:PhaLoc};
		return Obj;
	}
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	var StockTypeBox = $HUI.combobox('#StockType', {
		data:[{'RowId':0,'Description':'ȫ��'},{'RowId':1,'Description':'���Ϊ��'},{'RowId':2,'Description':'���Ϊ��'},{'RowId':3,'Description':'���Ϊ��'},{'RowId':4,'Description':'������'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var ManageDrugFlagBox = $HUI.combobox('#ManageDrugFlag', {
		data:[{'RowId':'','Description':'ȫ��'},{'RowId':'1','Description':'�ص��ע'},{'RowId':'0','Description':'���ص��ע'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var QueryFlagBox = $HUI.combobox('#QueryFlag', {
		data:[{'RowId':'','Description':'ȫ��'},{'RowId':'������','Description':'������'},{'RowId':'��������','Description':'��������'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var MasterInfoCm = [[
		 {
			title : "INCIL",
			field : 'INCIL',
			width : 20,
			hidden : true
		}, {
			title : "���ʴ���",
			field : 'InciCode',
			width : 120
		}, {
			title : "��������",
			field : 'InciDesc',
			width : 200
		}, {
			title : '������',
			field : 'StkCat',
			width : 100
		}, {
			title : '��ⵥλ',
			field : 'PurUom',
			width : 70
		}, {
			title : '������λ',
			field : 'BUom',
			width : 90
		}, {
			title : '�ڳ����',
			field : 'BegQtyUom',
			width : 70,
			align: 'right'
		}, {
			title : "�ڳ����(����)",
			field : 'BegRpAmt',
			width : 70,
			align: 'right'
		}, {
			title : "�ڳ����(�ۼ�)",
			field : 'BegSpAmt',
			width : 100,
			align: 'right'
		}, {
			title : "��ĩ���",
			field : 'EndQtyUom',
			width : 100,
			align: 'right'
		}, {
			title : "��ĩ���(����)",
			field : 'EndRpAmt',
			width : 100,
			align: 'right'
		}, {
			title : "��ĩ���(�ۼ�)",
			field : 'EndSpAmt',
			width : 100,
			align: 'right'
		}	
	]];
	
	var ParamsObj=$UI.loopBlock('#Conditions')
	var MasterInfoGrid = $UI.datagrid('#MasterInfoGrid', {
		lazy:true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocItmTransMove',
			MethodName: 'LocItmStkMoveSum',
			Params:JSON.stringify(ParamsObj)
		},
		columns: MasterInfoCm,
		showBar: true,
		onSelect:function(index, row){
			var ParamsObj=$UI.loopBlock('#Conditions')
			MasterDetailInfoGrid.load({
				ClassName: 'web.DHCSTMHUI.LocItmTransMove',
				MethodName: 'LocItmStkMoveDetail',
				ParamStr: JSON.stringify(ParamsObj),
				INCIL:row.INCIL
			});
		}
	})
	var DetailInfoCm = [[
		{
			title : "TrId",
			field : 'TrId',
			width : 100,
			hidden : true
		}, {
			title : '����',
			field : 'TrDate',
			width : 150
		}, {
			title : '����Ч��',
			field : 'BatExp',
			width : 150
		}, {
			title : "��λ",
			field : 'PurUom',
			width : 80
		}, {
			title : "��ֵ����",
			field : 'HVBarCode',
			width : 140
		}, {
			title : "����",
			field : 'Rp',
			width : 80,
			align: 'right'
		}, {
			title : "�ۼ�",
			field : 'Sp',
			width : 80,
			align: 'right'
		}, {
			title : "��������",
			field : 'EndQtyUom',
			width : 120,
			align: 'right'
		}, {
			title : "����",
			field : 'TrQtyUom',
			width : 100,
			align: 'right'
		}, {
			title : "���۽��",
			field : 'RpAmt',
			width : 120,
			align: 'right'
		}, {
			title : "�ۼ۽��",
			field : 'SpAmt',
			width : 120,
			align: 'right'
		}, {
			title : "�����",
			field : 'TrNo',
			width : 120
		}, {
			title : "������",
			field : 'TrAdm',
			width : 100
		}, {
			title : "ժҪ",
			field : 'TrMsg',
			width : 100
		}, {
			title : "������(����)",
			field : 'EndRpAmt',
			width : 120,
			align: 'right'
		}, {
			title : "������(�ۼ�)",
			field : 'EndSpAmt',
			width : 120,
			align: 'right'
		}, {
			title : "��Ӧ��",
			field : 'Vendor',
			width : 160
		}, {
			title : "����",
			field : 'Manf',
			width : 160
		}, {
			title : "������",
			field : 'OperateUser',
			width : 100
		}			
	]];
	var MasterDetailInfoGrid = $UI.datagrid('#MasterDetailInfoGrid', {
		lazy:true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocItmTransMove',
			MethodName: 'LocItmStkMoveDetail'
		},
		idFiled:'TrId',
		columns: DetailInfoCm,   
		showBar: true,
		onClickCell: function(index, filed ,value){
			MasterDetailInfoGrid.commonClickCell(index,filed,value);
		}
	})
	function QueryMasterInfo(){
		var ParamsObj=$UI.loopBlock('#Conditions')
		if(isEmpty(ParamsObj.StartDate)){
			$UI.msg('alert','��ʼ���ڲ���Ϊ��!');
			return;
		}
		if(isEmpty(ParamsObj.EndDate)){
			$UI.msg('alert','��ֹ���ڲ���Ϊ��!');
			return;
		}
		if(isEmpty(ParamsObj.PhaLoc)){
			$UI.msg('alert','���Ҳ���Ϊ��!');
			return;
		}	
		var Params=JSON.stringify(ParamsObj);
		$UI.clear(MasterDetailInfoGrid);
		MasterInfoGrid.load({
			ClassName: 'web.DHCSTMHUI.LocItmTransMove',
			MethodName: 'LocItmStkMoveSum',
			Params:Params
		})
	}
	function MasterClear() {
		$UI.clearBlock('#Conditions');
		$UI.clear(MasterInfoGrid);
		$UI.clear(MasterDetailInfoGrid);
		var Dafult={StartDate: DateFormatter(new Date()),
					EndDate:DateFormatter(new Date()),
					PhaLoc:gLocObj
					}
		$UI.fillBlock('#Conditions',Dafult);
	
	}
	MasterClear();
}
$(init);