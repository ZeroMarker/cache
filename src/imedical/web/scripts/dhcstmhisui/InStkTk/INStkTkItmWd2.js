var init = function() {
	//�̵�¼�뷽ʽһ
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
		$UI.clearBlock('#ConditionsWd2');
		$UI.clear(DetailGrid);
		var Dafult={
				ScgStk:"",
				LocManaGrp:"",
				InstNo:"",
				StkCatBox:"",
				LocStkBin:"",
				InStkTkWin:""
			}
		$UI.fillBlock('#ConditionsWd2',Dafult);
		Select(gRowid);
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
			save();
		}
	});
	var save=function(){
		var ParamsObj=$UI.loopBlock('#ConditionsWd2');
		var Main=JSON.stringify(ParamsObj)
		var ListData=DetailGrid.getChangesData();
		if (ListData === false){	//δ��ɱ༭����ϸΪ��
			return;
		}
		if (isEmpty(ListData)){	//��ϸ����
			$UI.msg("alert", "û����Ҫ�������ϸ!");
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.INStkTkItmWd',
			MethodName: 'jsSave',
			Main: Main,
			ListData: JSON.stringify(ListData)
		},function(jsonData){
			$UI.msg('alert',jsonData.msg);
			if(jsonData.success==0){
				QueryDetail()
			}
		});
	}
	var Select=function(inst){
		//$UI.clearBlock('#ConditionsWd2');
		//$UI.clear(DetailGrid);
		$.cm({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			MethodName: 'jsSelect',
			inst: inst
			},
			function(jsonData){
				$UI.fillBlock('#ConditionsWd2',jsonData);
				QueryDetail();
		});
	}
	
	function QueryDetail(){
		var ParamsObj=$UI.loopBlock('#ConditionsWd2');
		var Params=JSON.stringify(ParamsObj)
		$UI.setUrl(DetailGrid);
		DetailGrid.load({
			ClassName: 'web.DHCSTMHUI.INStkTkItmWd',
			QueryName: 'jsINStkTkItmWd',
			Sort:"code",
			Dir:"asc",
			Params: Params,
			rows: 99999
		});
		
	}
	var HandlerParams=function(){
		var Scg=$("#ScgStk").combotree('getValue');
		var Obj={StkGrpRowId:Scg,StkGrpType:"M",Locdr:"",NotUseFlag:"N",QtyFlag:"",
		ToLoc:"",ReqModeLimited:"",NoLocReq:"",HV:"",RequestNoStock:""};
		return Obj
	}
	var SelectRow=function(row){
		var Rows =DetailGrid.getRows();  
		var SelectRow = Rows[DetailGrid.editIndex];
		GetItmFreezeBatch(gRowid,row,GetItmFreezeBatchCallback)
	}
	function GetItmFreezeBatchCallback(row, retrunData){
		if(retrunData.length<1){
			$UI.msg('alert','�����ʲ��ڱ��̵㵥��Χ������¼��!');
			return;
		}
		var Rows =DetailGrid.getRows();  
		var SelectRow = Rows[DetailGrid.editIndex];
		SelectRow.inci=row.InciDr;
		SelectRow.code=row.InciCode;
		SelectRow.desc=row.InciDesc
		SelectRow.spec=row.Spec;
		
		var DefaultBat=retrunData[0]
		if (!isEmpty(DefaultBat)) {
			SelectRow.insti=DefaultBat.Insti;
			SelectRow.BatExp=DefaultBat.BatExp;
			SelectRow.uom=DefaultBat.FreUom;
		}
		
		setTimeout(function(){
			DetailGrid.refreshRow();
			DetailGrid.startEditingNext('desc');
		},0);
	}
	function GetItmFreezeBatch(inst,row,callback){
		$.cm({
				ClassName:'web.DHCSTMHUI.INStkTk',
				QueryName:'jsGetItmFreezeBatch',
				ResultSetType:'array',
				Inst: inst,
				Inci:row.InciDr
			},function(data){
				callback(row,data)
			})
	}
	//======================tbar�����¼�end============================
	var BatExpBox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.DHCSTMHUI.INStkTk&QueryName=jsGetItmFreezeBatch&ResultSetType=array',
			valueField: 'BatExp',
			textField: 'BatExp',
			mode:'remote',
			onBeforeLoad:function(param){
				var Select=DetailGrid.getSelected();
				if(!isEmpty(Select)){
					param.Inci =Select.inci;
					param.Inst =gRowid;
				}
			}
		}
	};
	
	var UomCombox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInciUom&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required:true,
			mode:'remote',
			onBeforeLoad:function(param){
				var Select=DetailGrid.getSelected();
				if(!isEmpty(Select)){
					param.Inci =Select.inci;
				}
			}
		}
	};
	var DetailGridCm = [[{
			title: 'instw',
			field: 'instw',
			hidden: true
		}, {
			title: 'insti',
			field: 'insti',
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
			width:150,
			editor:InciEditor(HandlerParams,SelectRow)
		}, {
			title: "���",
			field:'spec',
			width:100
		}, {
			title:"����",
			field:'manf',
			width:100
		}, {
			title:"����~��Ч��",
			field:'BatExp',
			width:200,
			formatter: CommonFormatter(BatExpBox,'BatExp','BatExp'),
			editor:BatExpBox
		}/*, {
			title:"uomrowid",
			field:'uom',
			hidden:true
		}, {
			title:"��λ",
			field:'uomDesc',
			width:100,
			align:'right'
		}*/, {
			title : "��λ",
			field : 'uom',
			width : 80,
			formatter: CommonFormatter(UomCombox,'uom','uomDesc'),
			editor:UomCombox
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
			align:'right'
		}, {
			title:"�ۼ�",
			field:'sp',
			width:100,
			align:'right',
			hidden: true
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
			field:'stkbin',
			width:60,
			hidden: true
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
			ClassName: 'web.DHCSTMHUI.INStkTkItm',
			QueryName: 'DHCSTInStkTkItm',
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
		showAddItems:true/*,
		toolbar:[{
					text: '����¼��<input type="text" id="barcode"/>' ,
					handler: function () {
						
					}
				}]*/
	})
	Select(gRowid);
	
}
$(init);
