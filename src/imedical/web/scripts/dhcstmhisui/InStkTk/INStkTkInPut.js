// /����: ʵ�̣�¼�뷽ʽ���������������ݰ�Ʒ�����ʵ������
// /����: ʵ�̣�¼�뷽ʽ���������������ݰ�Ʒ�����ʵ������
var init = function() {
	//�̵�¼�뷽ʽ��
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
	var HandlerParams=function(){
		var Scg=$("#ScgStk").combotree('getValue');
		var Obj={StkGrpRowId:Scg,StkGrpType:"M"};
		return Obj
	}
	$("#InciDesc").lookup(InciLookUpOp(HandlerParams,'#InciDesc','#Inci'));
	//===========================������ʼend===========================
	// ======================tbar�����¼�start=========================
		//����
	$UI.linkbutton('#ClearBT',{ 
		onClick:function(){
			Clear();
		}
	});
	function Clear() {
		$UI.clearBlock('#ConditionsInput');
		$UI.clear(DetailGrid);
		var Dafult={
				ScgStk:"",
				LocManaGrp:"",
				InstNo:"",
				StkCatBox:"",
				LocStkBin:"",
				InStkTkWin:""
			}
		$UI.fillBlock('#ConditionsInput',Dafult);
	}
	//��ѯ
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			QueryDetail();
		}
	});
	//����
	$UI.linkbutton('#SaveBT',{ 
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#ConditionsInput');
			var Main=JSON.stringify(ParamsObj)
			var ListData=DetailGrid.getChangesData("rowid");
			if (ListData === false){	//δ��ɱ༭����ϸΪ��
				return;
			}
			if (isEmpty(ListData)){	//��ϸ����
				$UI.msg("alert", "û����Ҫ�������ϸ!");
				return;
			}
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.InStkTkInput',
				MethodName: 'jsSave',
				Main: Main,
				ListData: JSON.stringify(ListData)
			},function(jsonData){
				hideMask();
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					QueryDetail()
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
			
		}
	});
	//����δ���� flag=1 ����0  flag=2 ����������
	function SetDefault(flag){
		var ParamsObj=$UI.loopBlock('#ConditionsInput');
		var Params=JSON.stringify(ParamsObj)
		$.cm({
			ClassName: 'web.DHCSTMHUI.InStkTkInput',
			MethodName: 'jsSetDefaultQty',
			Params: Params,
			Flag:flag
		},function(jsonData){
			$UI.msg('success',jsonData.msg);
			QueryDetail();
//			if(jsonData.success>=0){
//				QueryDetail()
//			}
		});
	}
	
	
	// �����������ݲ���ʵ���б�
	function creatStk(inst, instwWin){
		if (isEmpty(inst)) {
			$UI.msg('alert','��ѡ���̵㵥!');
			return false;
		}
		$.cm({
				ClassName: 'web.DHCSTMHUI.InStkTkInput',
				MethodName: 'jsCreateStkTkInput',
				Inst: gRowid,
				User:gUserId,
				InputWin:gInstwWin
			},function(jsonData){
				//$UI.msg('alert',jsonData.msg);
				if(jsonData.success>=0){
					Select(gRowid);
				}
			});
	}
	
	var Select=function(inst){
		//$UI.clearBlock('#ConditionsInput');
		//$UI.clear(DetailGrid);
		$.cm({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			MethodName: 'jsSelect',
			inst: inst
			},
			function(jsonData){
				$UI.fillBlock('#ConditionsInput',jsonData);
				QueryDetail();
		});
		
	
	}
	
	function QueryDetail(){
		var ParamsObj=$UI.loopBlock('#ConditionsInput');
		var Params=JSON.stringify(ParamsObj)
		$UI.setUrl(DetailGrid);
		DetailGrid.load({
			ClassName: 'web.DHCSTMHUI.InStkTkInput',
			QueryName: 'jsINStkTkInPut',
			Sort:"code",
			Dir:"ASC",
			Params: Params,
			rows: 99999
		});
		
	}
	
	//======================tbar�����¼�end============================
	
	
	var DetailGridCm = [[{
			title: 'rowid',
			field: 'rowid',
			hidden: true
		}, {
			title: 'parref',
			field: 'parref',
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
			title:"uomrowid",
			field:'uom',
			hidden:true
		}, {
			title:"��λ",
			field:'uomDesc',
			width:100
		}, {
			title:"����",
			field:'rp',
			width:100,
			align:'right'
		}, {
			title:"��������",
			field:'freQty',
			width:80,
			align:'right'
		}, {
			title:"ʵ������",
			field:'countQty',
			width:100,
			align:'right',
			editor:{
				type:'numberbox',
				options:{
					
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
			field:'IncsbDesc',
			width:100
		}, {
			title:"��������",
			field:'adjQty',
			width:100,
			align:'right'
		}, {
			title:"���̽��۽��",
			field:'freezeRpAmt',
			width:100,
			align:'right'
		}, {
			title:"ʵ�̽��۽��",
			field:'countRpAmt',
			width:100,
			align:'right'
		}, {
			title:"������۽��",
			field:'adjRpAmt',
			width:100,
			align:'right'
		}
	]];
	var DetailGrid = $UI.datagrid('#DetailGrid',{
		queryParams : {
			ClassName: 'web.DHCSTMHUI.InStkTkInput',
			QueryName: 'INStkTkInPut',
			rows: 99999
		},
		columns : DetailGridCm,
		pagination:false,
		onClickCell: function(index, filed ,value){
			DetailGrid.commonClickCell(index,filed,value);
		},
		onBeginEdit: function (index, row) {
			$('#DetailGrid').datagrid('beginEdit', index);
			var ed = $('#DetailGrid').datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++) {
				var e = ed[i];
				if (e.field == 'countQty') {
					$(e.target).bind('keydown', function (event) {
						if (event.keyCode == 38) {//up
							//�����ƶ�����һ��Ϊֹ
							if (index > 0) {
								newindex=index-1;
								$('#DetailGrid').datagrid('selectRow', newindex);
								$('#DetailGrid').datagrid('endEdit', index).datagrid('beginEdit', newindex);
								var newed = DetailGrid.getEditor({index:newindex,field:'countQty'});
								if(newed!=null){
									$(newed.target).focus();
									$(newed.target).next().children().focus();
								}
							}
						}
						if (event.keyCode == 40) {//down
							if (index < $('#DetailGrid').datagrid('getData').rows.length - 1) {
								newindex=index+1;
								$('#DetailGrid').datagrid('selectRow', newindex);
								$('#DetailGrid').datagrid('endEdit', index).datagrid('beginEdit', newindex);
								var newed = DetailGrid.getEditor({index:newindex,field:'countQty'});
								if(newed!=null){
									$(newed.target).focus();
									$(newed.target).next().children().focus();
								}
							}
						}
					})
				}
			}
		},
		toolbar:[{
				text: '����δ��������0',
				iconCls: 'icon-paper-cfg',
				handler: function () {
					SetDefault(1);
				}},{
				text: '����δ��������������',
				iconCls: 'icon-paper-cfg',
				handler: function () {
					SetDefault(2);
				}}]
	})
	creatStk(gRowid, gInstwWin);
}
$(init);
