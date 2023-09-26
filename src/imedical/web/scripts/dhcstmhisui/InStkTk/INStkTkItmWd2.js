var init = function() {
	//盘点录入方式一
	//=======================条件初始化start==================
	//类组  库存分类联动
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
	//库存分类
	var StkCatBox = $HUI.combobox('#StkCatBox', {
			valueField: 'RowId',
			textField: 'Description'
		});
	//货位
	var LocStkBinParams=JSON.stringify(addSessionParams({LocDr:gLocId}));
	var LocStkBinBox = $HUI.combobox('#LocStkBin', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocStkBin&ResultSetType=array&Params='+LocStkBinParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	//管理组
	var LocManaGrpBox = $HUI.combobox('#LocManaGrp', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocManGrp&ResultSetType=array&LocId='+gLocId,
		valueField: 'RowId',
		textField: 'Description'
	});
	//实盘窗口
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
	//===========================条件初始end===========================
	// ======================tbar操作事件start=========================
	//清屏
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
	//查询
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			QueryDetail();
		}
	});
	//保存
	$UI.linkbutton('#SaveBT',{ 
		onClick:function(){
			save();
		}
	});
	var save=function(){
		var ParamsObj=$UI.loopBlock('#ConditionsWd2');
		var Main=JSON.stringify(ParamsObj)
		var ListData=DetailGrid.getChangesData();
		if (ListData === false){	//未完成编辑或明细为空
			return;
		}
		if (isEmpty(ListData)){	//明细不变
			$UI.msg("alert", "没有需要保存的明细!");
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
			$UI.msg('alert','该物资不在本盘点单范围，不能录入!');
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
	//======================tbar操作事件end============================
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
			title: '物资代码',
			field: 'code',
			width:120
		}, {
			title: '物资名称',
			field: 'desc',
			width:150,
			editor:InciEditor(HandlerParams,SelectRow)
		}, {
			title: "规格",
			field:'spec',
			width:100
		}, {
			title:"厂商",
			field:'manf',
			width:100
		}, {
			title:"批号~有效期",
			field:'BatExp',
			width:200,
			formatter: CommonFormatter(BatExpBox,'BatExp','BatExp'),
			editor:BatExpBox
		}/*, {
			title:"uomrowid",
			field:'uom',
			hidden:true
		}, {
			title:"单位",
			field:'uomDesc',
			width:100,
			align:'right'
		}*/, {
			title : "单位",
			field : 'uom',
			width : 80,
			formatter: CommonFormatter(UomCombox,'uom','uomDesc'),
			editor:UomCombox
		}, {
			title:"buomrowid",
			field:'buom',
			hidden:true
		}, {
			title:"基本单位",
			field:'buomDesc',
			width:80,
			hidden: true
		}, {
			title:"进价",
			field:'rp',
			width:100,
			align:'right'
		}, {
			title:"售价",
			field:'sp',
			width:100,
			align:'right',
			hidden: true
		}, {
			title:"账盘数量",
			field:'freQty',
			width:80,
			align:'right'
		}, {
			title:"实盘数量",
			field:'countQty',
			width:100,
			align:'right',
			editor:{
				type:'numberbox',
				options:{
					
					}
				}
		}, {
			title:"实盘日期",
			field:'countDate',
			width:100
		}, {
			title:"实盘时间",
			field:'countTime',
			width:100
		}, {
			title:"实盘人",
			field:'userName',
			width:60
		}, {
			title:"货位",
			field:'stkbin',
			width:60,
			hidden: true
		}, {
			title:"损益数量",
			field:'adjQty',
			width:100,
			align:'right'
		}, {
			title:"账盘进价金额",
			field:'freezeRpAmt',
			width:100,
			align:'right'
		}, {
			title:"实盘进价金额",
			field:'countRpAmt',
			width:100,
			align:'right'
		}, {
			title:"损益进价金额",
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
							//向上移动到第一行为止
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
					text: '条码录入<input type="text" id="barcode"/>' ,
					handler: function () {
						
					}
				}]*/
	})
	Select(gRowid);
	
}
$(init);
