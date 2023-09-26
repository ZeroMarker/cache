// /名称: 实盘：录入方式三（根据账盘数据按品种填充实盘数）
// /描述: 实盘：录入方式三（根据账盘数据按品种填充实盘数）
var init = function() {
	//盘点录入方式三
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
	//查询
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			QueryDetail();
		}
	});
	//保存
	$UI.linkbutton('#SaveBT',{ 
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#ConditionsInput');
			var Main=JSON.stringify(ParamsObj)
			var ListData=DetailGrid.getChangesData("rowid");
			if (ListData === false){	//未完成编辑或明细为空
				return;
			}
			if (isEmpty(ListData)){	//明细不变
				$UI.msg("alert", "没有需要保存的明细!");
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
	//设置未填数 flag=1 等于0  flag=2 等于账盘数
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
	
	
	// 根据账盘数据插入实盘列表
	function creatStk(inst, instwWin){
		if (isEmpty(inst)) {
			$UI.msg('alert','请选择盘点单!');
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
	
	//======================tbar操作事件end============================
	
	
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
			title: '物资代码',
			field: 'code',
			width:120
		}, {
			title: '物资名称',
			field: 'desc',
			width:150
		}, {
			title: "规格",
			field:'spec',
			width:100
		}, {
			title:"uomrowid",
			field:'uom',
			hidden:true
		}, {
			title:"单位",
			field:'uomDesc',
			width:100
		}, {
			title:"进价",
			field:'rp',
			width:100,
			align:'right'
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
			field:'IncsbDesc',
			width:100
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
		toolbar:[{
				text: '设置未填数等于0',
				iconCls: 'icon-paper-cfg',
				handler: function () {
					SetDefault(1);
				}},{
				text: '设置未填数等于账盘数',
				iconCls: 'icon-paper-cfg',
				handler: function () {
					SetDefault(2);
				}}]
	})
	creatStk(gRowid, gInstwWin);
}
$(init);
