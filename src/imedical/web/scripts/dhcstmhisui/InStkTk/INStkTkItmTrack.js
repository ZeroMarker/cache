//����:		ʵ�̣�¼�뷽ʽ��(��ֵɨ���̵�)
var init = function() {
	//=======================������ʼ��start==================
	//����  ����������
	$('#ScgStk').stkscgcombotree({
		onSelect:function(node){
			$.cm({
				ClassName:'web.DHCSTMHUI.Common.Dicts',
				QueryName:'GetStkCat',
				ResultSetType:'array',
				StkGrpId:node.id
			},function(data){
				StkCatBox.loadData(data);
				})
			}
	})
	//������
	var StkCatBox = $HUI.combobox('#StkCatBox', {
			valueField: 'RowId',
			textField: 'Description'
		});
	//��λ
	var LocStkBinParams=JSON.stringify(addSessionParams({LocDr:gLocId}));
	var LocStkBinBox = $HUI.combobox('#LocStkBin', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocStkBin&ResultSetType=array&Params='+LocStkBinParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	//������
	var LocManaGrpBox = $HUI.combobox('#LocManaGrp', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocManGrp&ResultSetType=array&LocId='+gLocId,
		valueField: 'RowId',
		textField: 'Description'
	});
	//ʵ�̴���
	var InStkTkWinBox = $HUI.combobox('#InStkTkWin', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInStkTkWindow&ResultSetType=array&LocId='+gLocId,
			valueField: 'RowId',
			textField: 'Description',
			editable:false
		});
		$('#InStkTkWin').combobox('setValue', gInstwWin);
		$("#BarCode").bind('keypress',function(event){
			if(event.keyCode==13){
				var barcode= $("#BarCode").val();
				if(!isEmpty(barcode)){
					HVINStkTk(barcode);
					$("#BarCode").val("");
				}
			}
		})
	//===========================������ʼend===========================
	// ======================tbar�����¼�start=========================
	//����
	$UI.linkbutton('#ClearBT',{ 
		onClick:function(){
			Clear();
		}
	});
	function Clear() {
		$UI.clearBlock('#Conditions');
		$UI.clear(DetailGrid);
		var Dafult={
				ScgStk:"",
				LocManaGrp:"",
				InstNo:"",
				StkCatBox:"",
				LocStkBin:"",
				InStkTkWin:""
			}
		$UI.fillBlock('#Conditions',Dafult);
	}
	//��ѯ
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			QueryDetail();
		}
	});
	
	var Select=function(inst){
		$.cm({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			MethodName: 'jsSelect',
			inst: inst
			},
			function(jsonData){
				$UI.fillBlock('#Conditions',jsonData);
				QueryDetail();
		});
	}
	
	function QueryDetail(){
		var ParamsObj=$UI.loopBlock('#Conditions');
		$UI.setUrl(DetailGrid);
		DetailGrid.load({
			ClassName: 'web.DHCSTMHUI.INStkTkItm',
			QueryName: 'jsDHCSTInStkTkItm',
			qPar:"",
			Inst:ParamsObj.inst,
			Others: ""
		});
	}
	
	function loadHVBarCodeInfoGrid() {
		var row = $('#DetailGrid').datagrid('getSelected');
		if(isEmpty(row)){
			$UI.msg('alert','��ѡ������!');
			return;
		}
		if(isEmpty(row.rowid)){
			$UI.msg('alert','��������!');
			return;
		}
		$UI.setUrl(HVBarCodeInfoGrid);
		HVBarCodeInfoGrid.load({
				ClassName: 'web.DHCSTMHUI.INStkTkItmTrack',
				QueryName: 'jsItmTrackDetail',
				insti: row.rowid,
				Others:"",
				qPar:""
			});
	}
	
		//����ʵ��
	function HVINStkTk(HVBarCode){
		if(isEmpty(HVBarCode)){
			return false;
		}
		var result = tkMakeServerCall('web.DHCSTMHUI.INStkTkItmTrack', 'INStkTkItmTrack', HVBarCode, gRowid, gUserId);
		var resultArr = result.split('^');
		var ret = resultArr[0];
		if(ret === '0'){
			loadHVBarCodeInfoGrid();
		}else{
			if(ret == -10){
				$UI.msg('alert','�����벻����!')
			}else if(ret == -11){
				$UI.msg('alert','�����벻�ڵ�ǰ�̵㵥��!')
			}else if(ret == -12){
				$UI.msg('alert','�������ѽ���ɨ���̵�!')
			}else{
				$UI.msg('alert','����:' + ret)
			}
			return false;
		}
	}
	//======================tbar�����¼�end============================
	var DetailGridCm = [[{
			title: 'rowid',
			field: 'rowid',
			hidden: true
		}, {
			title: 'inclb',
			field: 'inclb',
			hidden: true
		}, {
			title: 'inci',
			field: 'inci',
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'code',
			width:120
		}, {
			title: '��������',
			field: 'desc',
			width:150
		}, {
			title: "���",
			field:'spec',
			width:100
		}, {
			title: "����",
			field:'batchNo',
			width:100
		}, {
			title: "��Ч��",
			field:'expDate',
			width:100
		}, {
			title:"����",
			field:'manf',
			width:100
		}, {
			title:"��������",
			field:'freQty',
			width:80,
			align:'right',
			hidden: true
		}, {
			title:"uomrowid",
			field:'uom',
			hidden:true
		}, {
			title:"��λ",
			field:'uomDesc',
			width:100
		}, {
			title:"buomrowid",
			field:'buom',
			hidden:true
		}, {
			title:"������λ",
			field:'buomDesc',
			width:80,
			hidden: true
		}, {
			title:"����",
			field:'rp',
			width:100,
			align:'right',
			hidden: true
		}, {
			title:"�ۼ�",
			field:'sp',
			width:100,
			align:'right',
			hidden: true
		}, {
			title:"ʵ������",
			field:'countQty',
			width:100,
			align:'right',
			editor:{
				type:'numberbox',
				options:{
					required:true
					}
				}
		}, {
			title:"ʵ������",
			field:'countDate',
			width:100
		}, {
			title:"ʵ��ʱ��",
			field:'countTime',
			width:100
		}, {
			title:"ʵ����",
			field:'userName',
			width:60
		}, {
			title:"��λ",
			field:'stkbin',
			width:60,
			hidden: true
		}
	]];
	var DetailGrid = $UI.datagrid('#DetailGrid',{
		url : '',
		queryParams : {
			ClassName: 'web.DHCSTMHUI.INStkTkItm',
			QueryName: 'jsDHCSTInStkTkItm'	
		},
		columns : DetailGridCm,
		onSelect:function(index, row){
			loadHVBarCodeInfoGrid();
		}
	})
	var HVBarCodeInfoGridCm = [[
		{
			title: 'instit',
			field: 'instit',
			hidden: true
		}, {
			title: '����ID',
			field: 'dhcit',
			hidden: true
		} , {
			title:"��ֵ����",
			field:'HVBarCode',
			width:200
		}, {
			title:"�̵��־",
			field:'institFlag',
			width:100
		}
		]]
		
	var HVBarCodeInfoGrid = $UI.datagrid('#HVBarCodeInfoGrid',{
		url : '',
		queryParams : {
			ClassName: 'web.DHCSTMHUI.INStkTkItmTrack',
			MethodName: 'jsItmTrackDetail'
		},
		columns : HVBarCodeInfoGridCm,
		rows:9999,
		onClickCell: function(index, filed ,value){
			HVBarCodeInfoGrid.commonClickCell(index,filed,value);
		}
	})
	Select(gRowid);
	
}
$(init);
