var init = function() {

	/*--按钮事件--*/
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			Query();
		}
	});
	function Query(){
		$UI.clear(PoMainGrid);
		$UI.clear(PoDetailGrid);
		var ParamsObj=$UI.loopBlock('#MainConditions')
		if(isEmpty(ParamsObj.StartDate)){
			$UI.msg("alert","开始日期不能为空!");
			return;
		}
		if(isEmpty(ParamsObj.EndDate)){
			$UI.msg("alert","截止日期不能为空!");
			return;
		}
		if(isEmpty(ParamsObj.PoLoc)){
			$UI.msg("alert","订单科室不能为空!");
			return;
		}
		ParamsObj.CompFlag="Y"
		var Params=JSON.stringify(ParamsObj);
		if(ParamsObj.ApproveFlag!="N"){
			setApprove();
		}
		else{
			setUnApprove();
		}
		PoMainGrid.load({
			ClassName: 'web.DHCSTMHUI.INPO',
			QueryName: 'QueryMain',
			Params:Params
		});
	}

	//设置可编辑组件的disabled属性
	function setApprove(){
		ChangeButtonEnable({'#ApproveBT':false,'#DenyBT':false});
	}
	function setUnApprove(){
		ChangeButtonEnable({'#ApproveBT':true,'#DenyBT':true});
	}
	function DefaultClear(){
		$UI.clearBlock('#MainConditions');
		$UI.clear(PoMainGrid);
		$UI.clear(PoDetailGrid);
		$HUI.combobox("#PoLoc").enable()
		ChangeButtonEnable({'#ApproveBT':true,'#DenyBT':true});
		Default();
	}
	$UI.linkbutton('#ApproveBT',{
		onClick:function(){
			var Row=PoMainGrid.getSelected()
			if(isEmpty(Row)){
				$UI.msg("alert","请选择要验收的订单!");
				return;
			}
			var Params=JSON.stringify(addSessionParams({RowId:Row.RowId}));
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.INPO',
				MethodName: 'jsApprove',
				Params:Params
			},function(jsonData){
				hideMask();
				if(jsonData.success==0){
					$UI.msg("success",jsonData.msg);
					$UI.clear(PoMainGrid);
					$UI.clear(PoDetailGrid);
					PoMainGrid.commonReload();
				}
				else{
					$UI.msg("error",jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#DenyBT',{
		onClick:function(){
			$UI.confirm("是否拒绝验收", "warning", "", Deny, "", "", "警告", false)
		}
	});

	function Deny(){
		var Row=PoMainGrid.getSelected()
		if(isEmpty(Row)){
			$UI.msg("alert","请选择要拒绝的订单!");
			return;
		}
		var Params=JSON.stringify(addSessionParams({RowId:Row.RowId}));
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPO',
			MethodName: 'jsDeny',
			Params:Params
		},function(jsonData){
			hideMask();
			if(jsonData.success==0){
				$UI.msg("success",jsonData.msg);
				$UI.clear(PoMainGrid);
				$UI.clear(PoDetailGrid);
				PoMainGrid.commonReload();
			}
			else{
				$UI.msg("error",jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#CancelBT',{
		onClick:function(){
			$UI.confirm("是否取消订单", "warning", "", Cancel, "", "", "警告", false)
		}
	});

	function Cancel(){
		var Row=PoMainGrid.getSelected()
		if(isEmpty(Row)){
			$UI.msg("alert","请选择要取消的订单!");
			return;
		}
		if(isEmpty($HUI.combobox("#CancelReason").getValue())){
			$UI.msg("alert","取消原因不能为空!");
			return false;
		}
		var CancelReason=$HUI.combobox("#CancelReason").getValue()
		var Params=JSON.stringify(addSessionParams({RowId:Row.RowId,CancelReason:CancelReason}));
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPO',
			MethodName: 'jsCancel',
			Params:Params
		},function(jsonData){
			hideMask();
			if(jsonData.success==0){
				$UI.msg("success",jsonData.msg);
				$UI.clear(PoMainGrid);
				$UI.clear(PoDetailGrid);
				PoMainGrid.commonReload();
			}
			else{
				$UI.msg("error",jsonData.msg);
			}
		});
	}

	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			DefaultClear();
		}
	});

	$UI.linkbutton('#EvaluateBT', {
		onClick: function () {
			var Row = PoMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要进行评价的订单!');
				return false;
			}
			VendorEvaluateWin(Row.RowId);
		}
	});
	/*--绑定控件--*/
	var PoLocBox = $HUI.combobox('#PoLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+PoLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var VendorBox = $HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var ReqLocBox = $HUI.combobox('#ReqLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+PoLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var ApproveFlagBox = $HUI.combobox('#ApproveFlag', {
		data:[{'RowId':'','Description':'全部'},{'RowId':'N','Description':'未验收'},{'RowId':'Y','Description':'已验收'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var CancelReasonBox = $HUI.combobox('#CancelReason', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetForInPoReasonForCancel&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	$('#SxNo').bind('keydown', function(event){
		if(event.keyCode == 13){
			var SxNo = $(this).val();
			if(isEmpty(SxNo)){
				return;
			}
			try{
				var SxNoObj = eval('(' + SxNo + ')');
				SxNo = SxNoObj['text'];
				$(this).val(SxNo);
			}catch(e){}
			
			$.cm({
				ClassName: 'web.DHCSTMHUI.ServiceForSCI',
				MethodName: 'getOrderDetail',
				SxNo: SxNo,
				HVFlag: ''
			}, function(jsonData){
				if(!isEmpty(jsonData['Main'])){
					$("#PoNo").val(jsonData['Main']['SCIPoNo']);
					Query();
				}else{
					$UI.msg('alert', '该随行单不存在或已入库!');
				}
			});
		}
	});
	function SaveSCIPoIngrInfo() {
		var ParamsObj=GetParamsObj();
		var RecLoc=ParamsObj.RecLoc;
		var SxNo=ParamsObj.SxNo;
		var Params=JSON.stringify(addSessionParams({SxNo:SxNo,RecLoc:RecLoc}));
		$.cm({
			ClassName: 'web.DHCSTMHUI.SCI.Web.DHCSTMDataExchangeSCM',
			MethodName: 'CreateIngrBySciInPo',
			Params: Params
		},function(jsonData){
			$UI.msg("success",jsonData.msg);
			if(jsonData.success==0){
				var IngrRowid=jsonData.rowid;
				Select(IngrRowid);
			}
			else{
				$UI.msg("error",jsonData.msg);
			}
		});
	}
	var HandlerParams=function(){
		var PoLoc=$("#PoLoc").combo('getValue');
		var Obj={StkGrpRowId:"",StkGrpType:"M",Locdr:PoLoc};
		return Obj
	}
	$("#InciDesc").lookup(InciLookUpOp(HandlerParams,'#InciDesc','#Inci'));

	/*--Grid--*/
	var PoDetailCm = [[{
			title:"RowId",
			field:'RowId',
			hidden:true
		}, {
			title:"物资ID",
			dataIndex : 'InciId',
			width : 100,
			hidden : true
		},{
			title:"代码",
			field:'InciCode',
			width:100
		},{
			title:"名称",
			field:'InciDesc',
			width:100
		}, {
			title:"规格",
			field:'Spec',
			width:100
		}, {
			title:"具体规格",
			field:'SpecDesc',
			width:100
		}, {
			title:"单位",
			field:'UomDesc',
			width:80
		}, {
			title:"进价",
			field:'Rp',
			width:80,
			align:'right'
		},{
			title:"进价金额",
			field:'RpAmt',
			width:80,
			align:'right'
		}, {
			title:"到货数量",
			field:'ImpQty',
			width:100,
			align:'right'
		}, {
			title:"未到货数量",
			field:'AvaQty',
			width:100,
			align:'right'
		}, {
			title:"是否撤销",
			field:'CancleFlag',
			width:100
		}
	]];

	var PoDetailGrid = $UI.datagrid('#PoDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INPOItm',
			QueryName: 'Query',
			rows: 99999
		},
		pagination:false,
		columns: PoDetailCm,
		sortName: 'RowId',
		sortOrder: 'Desc'
	})

	var PoMainCm = [[{
			title:"RowId",
			field:'RowId',
			hidden:true
		},  {
			title:"订单号",
			field:'PoNo',
			width:100
		}, {
			title:"订单科室",
			field:'PoLocDesc',
			width:100
		}, {
			title:"供应商",
			field:'VendorDesc',
			width:150
		}, {
			title:"订单状态",
			field:'PoStatus',
			width:100,
			formatter:function(value){
				var PoStatus='';
				if(value==0){
					PoStatus='未入库';
				}else if(value==1){
					PoStatus='部分入库';
				}else if(value==2){
					PoStatus='全部入库';
				}
				return PoStatus;
			}
		}, {
			title:"订单日期",
			field:'CreateDate',
			width:100
		}, {
			title:"完成",
			field:'CompFlag',
			width:100
		}
	]];

	var PoMainGrid = $UI.datagrid('#PoMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INPO',
			QueryName: 'QueryMain'
		},
		onClickCell: function(index, filed ,value){
			PoMainGrid.commonClickCell(index,filed,value)
		},
		columns: PoMainCm,
		onSelect:function(index, row){
			PoDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.INPOItm',
				QueryName: 'Query',
				PoId: row.RowId,
				rows: 99999
			});
		},
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				PoMainGrid.selectRow(0);
			}
		}
	})

	/*--设置初始值--*/
	var Default=function(){
		///设置初始值 考虑使用配置
		var DefaultValue={
			StartDate:DateAdd(new Date(), 'd', parseInt(-7)),
			EndDate:new Date(),
			PoLoc:gLocObj,
			ApproveFlag:'N',
			DefLocPP:'Y'
		}
		$UI.fillBlock('#MainConditions',DefaultValue)
	}
	Default()
}
$(init);
