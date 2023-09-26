var init = function() {
	///设置可编辑组件的disabled属性
	function setEditDisable(){
		$HUI.combobox("#StkLoc").disable();
		$HUI.combobox("#ScgStk").disable();
		$HUI.combobox("#StkCat").disable();
	}
	///放开可编辑组件的disabled属性
	function setEditEnable(){
		$HUI.combobox("#StkLoc").enable();
		$HUI.combobox("#ScgStk").enable();
		$HUI.combobox("#StkCat").enable();
	}
	var ClearMain=function(){
		$UI.clearBlock('#MainConditions');
		$UI.clearBlock('#TB');
		$UI.clear(StkGrid);
		var Dafult={
			StkLoc:gLocObj
			}
		$UI.fillBlock('#MainConditions',Dafult)
		ChangeButtonEnable({'#CreateBT':true,'#DelBT':false,'#ComBT':false,'#CanComBT':false,'#CountComBT':false,'#CountCanComBT':false,'#AdjBT':false});
	};
	var StkLocParams=JSON.stringify(addSessionParams({Type:INREQUEST_LOCTYPE}));
	var StkLocBox = $HUI.combobox('#StkLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+StkLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$('#ScgStk').stkscgcombotree({
		onClick:function(node){
			StkCat.clear();
			var Params=JSON.stringify(addSessionParams());
			var url=$URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array&StkGrpId='+node.id+'&Params='+Params;
			StkCat.reload(url);
		}
	})
	var StkCat = $HUI.combobox('#StkCat', {
			valueField: 'RowId',
			textField: 'Description'
		});
	var HandlerParams=function(){
		var Scg=$("#ScgStk").combotree('getValue');
		var Obj={StkGrpRowId:Scg,StkGrpType:"M"};
		return Obj
	}
	$("#InciDesc").lookup(InciLookUpOp(HandlerParams,'#InciDesc','#Inci'));
	var UserBox = $HUI.combobox('#User', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetUser&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			FindWin(Select)
		}
	});
	$UI.linkbutton('#FilerBT',{
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#TB')
			var Params=JSON.stringify(ParamsObj);
			var RowId=$('#RowId' ).val()
			if(isEmpty(RowId)){return;}
			StkGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCReqLocStktk',
				QueryName: 'QueryDetail',
				Parref: RowId,
				Params:Params
			});
		}
	});
	$UI.linkbutton('#CreateBT',{
		onClick:function(){
			var MainObj=$UI.loopBlock('#MainConditions')
			var StrParam=JSON.stringify(MainObj);
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCReqLocStktk',
				MethodName: 'Create',
				StrParam: StrParam
			},function(jsonData){
				hideMask();
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					Select(jsonData.rowid);
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
		}
	})
$UI.linkbutton('#SaveBT',{
		onClick:function(){
			DetailObj=StkGrid.getChangesData();
			if (DetailObj === false){	//未完成编辑或明细为空
				return;
			}
			if (isEmpty(DetailObj)){	//明细不变
				$UI.msg("alert", "没有需要保存的明细!");
				return;
			}
			var Detail=JSON.stringify(DetailObj)
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCReqLocStktk',
				MethodName: 'SaveStkTkItm',
				ListData: Detail
			},function(jsonData){
				hideMask();
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					Select(jsonData.rowid);
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
		}
	})
	$UI.linkbutton('#SetZeroBT',{
		onClick:function(){
			Set(1);
		}
	});
	$UI.linkbutton('#SetFreBT',{
		onClick:function(){
			Set(2);
		}
	});
	var Set=function(Flag){
		var RowId=$('#RowId' ).val()
		if(isEmpty(RowId)){return;}
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCReqLocStktk',
			MethodName: 'SetDefaultQtyForReqLoc',
			Flag: Flag,
			Inst:RowId
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				Select(jsonData.rowid);
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#DelBT',{
		onClick:function(){
			var RowId=$('#RowId' ).val()
			if(isEmpty(RowId)){return;}
			function del(){
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCReqLocStktk',
					MethodName: 'Delete',
					RowId: RowId
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						ClearMain();
						setEditEnable();
					}else{
						$UI.msg('error',jsonData.msg);
					}
				});
			}
			$UI.confirm('确定要删除吗?','','', del);
		}
	});
	$UI.linkbutton('#ComBT',{
		onClick:function(){
			var RowId=$('#RowId' ).val()
			if(isEmpty(RowId)){return;}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCReqLocStktk',
				MethodName: 'Complete',
				RowId: RowId
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					Select(jsonData.rowid);
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#CanComBT',{
		onClick:function(){
			var RowId=$('#RowId' ).val()
			if(isEmpty(RowId)){return;}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCReqLocStktk',
				MethodName: 'CancelComplete',
				RowId: RowId
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					Select(jsonData.rowid);
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#CountComBT',{
		onClick:function(){
			var RowId=$('#RowId' ).val()
			if(isEmpty(RowId)){return;}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCReqLocStktk',
				MethodName: 'CountComplete',
				RowId: RowId
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					Select(jsonData.rowid);
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#CountCanComBT',{
		onClick:function(){
			var RowId=$('#RowId' ).val()
			if(isEmpty(RowId)){return;}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCReqLocStktk',
				MethodName: 'CountCancelComplete',
				RowId: RowId
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					Select(jsonData.rowid);
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			ClearMain();
			setEditEnable();
		}
	});
	$UI.linkbutton('#AdjBT',{
		onClick:function(){
			var MainObj=$UI.loopBlock('#MainConditions')
			var StrParam=JSON.stringify(MainObj);
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCReqLocStktk',
				MethodName: 'AdjStktk',
				Params: StrParam
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					Select(jsonData.rowid);
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
		}
	});
	var Select=function(RowId){
		$UI.clearBlock('#MainConditions');
		$UI.clear(StkGrid);
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCReqLocStktk',
			MethodName: 'Select',
			RowId: RowId
		},
		function(jsonData){
			$UI.fillBlock('#MainConditions',jsonData);
			setEditDisable();
			//按钮控制
			if($HUI.checkbox("#AdjCompleted").getValue()){
				ChangeButtonEnable({'#CreateBT':false,'#DelBT':false,'#ComBT':false,'#CanComBT':false,'#CountComBT':false,'#CountCanComBT':false,'#AdjBT':false,'#SaveBT':false,'#SetZeroBT':false,'#SetFreBT':false});
			}else if($HUI.checkbox("#CountCompleted").getValue()){
				ChangeButtonEnable({'#CreateBT':false,'#DelBT':false,'#ComBT':false,'#CanComBT':false,'#CountComBT':false,'#CountCanComBT':true,'#AdjBT':true,'#SaveBT':false,'#SetZeroBT':false,'#SetFreBT':false});
			}else if($HUI.checkbox("#Completed").getValue()){
				ChangeButtonEnable({'#CreateBT':false,'#DelBT':false,'#ComBT':false,'#CanComBT':true,'#CountComBT':true,'#CountCanComBT':false,'#AdjBT':false,'#SaveBT':true,'#SetZeroBT':true,'#SetFreBT':true});
			}else{
				ChangeButtonEnable({'#CreateBT':false,'#DelBT':true,'#ComBT':true,'#CanComBT':false,'#CountComBT':false,'#CountCanComBT':false,'#AdjBT':false,'#SaveBT':false,'#SetZeroBT':false,'#SetFreBT':false});
			}
		});
		StkGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCReqLocStktk',
			QueryName: 'QueryDetail',
			Parref: RowId
		});
	}
	var StkCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width:100,
			saveCol: true,
			hidden: true
		}, {
			title: 'Incil',
			field: 'Incil',
			width:100,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width:100
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width:150
		}, {
			title: "规格",
			field:'Spec',
			width:100
		}, {
			title:"冻结数量",
			field:'FreezeQty',
			width:100,
			align:'right'
		}, {
			title:"标准数量",
			field:'RepQty',
			width:100,
			align:'right'
		}, {
			title:"实盘数量",
			field:'CountQty',
			width:100,
			saveCol: true,
			necessary:true,
			align:'right',
			editor:{
				type:'numberbox',
				options:{
					required:false
				}
			}
		}, {
			title:"进价金额",
			field:'RpAmt',
			width:100,
			align:'right'
		}, {
			title:"售价金额",
			field:'SpAmt',
			width:100,
			align:'right'
		},{
			title:"单位",
			field:'PUomDesc',
			width:100
		},{
			title:"请求备注",
			field:'Remarks',
			width:200,
			saveCol:true,
			align:'left',
			editor:{
				type:'validatebox'
			}
		}
	]];

	var StkGrid = $UI.datagrid('#StkGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCReqLocStktk',
			QueryName: 'QueryDetail'
		},
		columns: StkCm,
		singleSelect:true,
//		toolbar:[{
//			id:'SaveBT',
//			text: '保存',
//			iconCls: 'icon-save',
//			handler: function () {
//				Save();
//			}},{
//			id:'SetZeroBT',
//			text: '设置未填数为0',
//			iconCls: 'icon-save',
//			handler: function () {
//				Set(1);
//			}},{
//			id:'SetFreBT',
//			text: '设置未填数为账盘数',
//			iconCls: 'icon-save',
//			handler: function () {
//				Set(2);
//			}}],
		toolbar:'#TB',
		onClickCell: function(index, filed ,value){
			if(!$HUI.checkbox("#Completed").getValue()||$HUI.checkbox("#CountCompleted").getValue()){
				return false;
			}
			StkGrid.commonClickCell(index,filed,value);
		},
		onEndEdit:function(index, row, changes){
			var Editors = $(this).datagrid('getEditors', index);
			for(var i=0;i<Editors.length;i++){
				var Editor = Editors[i];
				if(Editor.field=='Qty'){}
			}
		},
		onBeforeEdit:function(index,row){
			if(!$HUI.checkbox("#Completed").getValue()||$HUI.checkbox("#CountCompleted").getValue()){
				return false;
			}
		}
	});
	ClearMain();
}
$(init);
