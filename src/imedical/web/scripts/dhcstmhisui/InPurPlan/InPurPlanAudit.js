var init = function() {

	/*--按钮事件--*/
	
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#MainConditions')
			if(isEmpty(ParamsObj.StartDate)){
				$UI.msg("alert","开始日期不能为空!");
				return;
			}
			if(isEmpty(ParamsObj.EndDate)){
				$UI.msg("alert","截止日期不能为空!");
				return;
			}
			if(isEmpty(ParamsObj.PurLoc)){
				$UI.msg("alert","采购科室不能为空!");
				return;
			}
			ParamsObj.CompFlag="Y"
			var Params=JSON.stringify(ParamsObj);
			if(ParamsObj.AuditFlag!="N"){
				setAudit();
			}
			else{
				setUnAudit();
			}
			PurMainGrid.load({
				ClassName: 'web.DHCSTMHUI.INPurPlan',
				QueryName: 'Query',
				Params:Params
			});
		}
	});
	
	//设置可编辑组件的disabled属性
	function setUnAudit(){
		ChangeButtonEnable({'#AduitBT':true,'#DenyBT':true});
	}
	function setAudit(){
		ChangeButtonEnable({'#AduitBT':false,'#DenyBT':false});
	}
	function DefaultClear(){
		$UI.clearBlock('#MainConditions');
		$UI.clear(PurMainGrid);
		$UI.clear(PurDetailGrid);
		$HUI.combobox("#PurLoc").enable()
		ChangeButtonEnable({'#AduitBT':true,'#DenyBT':true});
		Default();
	}
	
	$UI.linkbutton('#AduitBT',{
		onClick:function(){
			var Row=PurMainGrid.getSelected()
			if(isEmpty(Row)){
				$UI.msg("alert","请选择要审核的采购计划单!");
				return;
			}
			var Params=JSON.stringify(addSessionParams({RowId:Row.RowId}));
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.INPurPlan',
				MethodName: 'jsAudit',
				Params:Params
			},function(jsonData){
				hideMask();
				if(jsonData.success==0){
					$UI.msg("success",jsonData.msg);
					$UI.clear(PurMainGrid);
					$UI.clear(PurDetailGrid);
					PurMainGrid.commonReload();
				}
				else{
					$UI.msg("error",jsonData.msg);
				}
			});
		}
	});
	
	$UI.linkbutton('#DenyBT',{
		onClick:function(){
			$UI.confirm("是否拒绝审核", "warning", "", Deny, "", "", "警告", false)
		}
	});
	
	function Deny(){
		var Row=PurMainGrid.getSelected()
		var index=PurMainGrid.editIndex
		PurMainGrid.endEdit(index)
		if(isEmpty(Row)){
			$UI.msg("alert","请选择要拒绝的采购计划单!");
			return;
		}
		if(isEmpty(Row.RefuseCase)){
			$UI.msg("alert","请填写拒绝原因!");
			return;
		}
		var Params=JSON.stringify(addSessionParams({RowId:Row.RowId,RefuseCase:Row.RefuseCase}));
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPurPlan',
			MethodName: 'jsDeny',
			Params:Params
		},function(jsonData){
			hideMask();
			if(jsonData.success==0){
				$UI.msg("success",jsonData.msg);
				$UI.clear(PurMainGrid);
				$UI.clear(PurDetailGrid);
				PurMainGrid.commonReload();
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
	$UI.linkbutton('#PrintBT',{
		onClick:function(){
			var Row=PurMainGrid.getSelected()
			if(isEmpty(Row)){
				$UI.msg("alert","请选择要打印的采购计划单!");
				return;
			}
			PrintInPurPlan(Row.RowId)
		}
	});

	/*--绑定控件--*/
	var PurLocBox = $HUI.combobox('#PurLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+PurLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var VendorBox = $HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var AuditBox = $HUI.combobox('#AuditFlag', {
		data:[{'RowId':'','Description':'全部'},{'RowId':'N','Description':'未审核'},{'RowId':'Y','Description':'已审核'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	
	/*--Grid--*/
	var PurDetailCm = [[
		{
			title:"RowId",
			field:'RowId',
			hidden:true
		}, {
			title:"物资ID",
			dataIndex : 'IncId',
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
			title:"采购数量",
			field:'Qty',
			width:80,
			align:'right'
		}, {
			title:"单位",
			field:'UomDesc',
			width:80
		}, {
			title:"进价",
			field:'Rp',
			width:80,
			align:'right'
		}, {
			title:"售价",
			field:'Sp',
			width:80,
			align:'right'
		}, {
			title:"进价金额",
			field:'RpAmt',
			width:80,
			align:'right'
		}, {
			title:"售价金额",
			field:'SpAmt',
			width:80,
			align:'right'
		}, {
			title:"厂商",
			field:'ManfDesc',
			width:100
		}, {
			title:"供应商",
			field:'VendorDesc',
			width:100
		}, {
			title:"配送商",
			field:'CarrierDesc',
			width:100
		}, {
			title:"请求科室",
			field:'ReqLocDesc',
			width:100
		}, {
			title:"请求科室库存",
			field:'StkQty',
			width:80,
			align:'right'
		}, {
			title:"库存上限",
			field:'MaxQty',
			width:80,
			align:'right'
		}, {
			title:"库存下限",
			field:'MinQty',
			width:80,
			align:'right'
		}
	]];
	
	var PurDetailGrid = $UI.datagrid('#PurDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INPurPlanItm',
			QueryName: 'Query',
			rows: 99999
		},
		pagination:false,
		columns: PurDetailCm,
		sortName: 'RowId',
		sortOrder: 'Desc'
	})
	
	var PurMainCm = [[{
			title:"RowId",
			field:'RowId',
			hidden:true
		}, {
			title:"计划单号",
			field:'PurNo',
			width:160
		}, {
			title:"采购科室",
			field:'PurLoc',
			width:150
		}, {
			title : "类组",
			field : 'StkScg',
			width : 150
		},{
			title:"制单日期",
			field:'CreateDate',
			width:100
		}, {
			title:"制单人",
			field:'CreateUser',
			width:100
		}, {
			title:"完成标志",
			field:'CompFlag',
			width:100,
			formatter:function(value){
				var status="";
				if(value=="Y"){
					status="已完成";
				}else{
					status="未完成";
				}
				return status;
			}
		}, {
			title:"审核状态",
			field:'DHCPlanStatusDesc',
			width:100,
			formatter:function(value){
				var status="";
				if(value==""){
					status="未审核";
				}else{
					status=value;
				}
				return status;
			}
		}, {
			title:"是否已生成订单",
			field:'PoFlag',
			width:120,
			formatter:function(value){
				var status="";
				if(value=="Y"){
					status="是";
				}else{
					status="否";
				}
				return status;
			}
		}, {
			title:"拒绝原因",
			field:'RefuseCase',
			width:100,
			necessary:true,
			editor:{
				type:'text',
				options:{
					required:true
				}
			}
		}
	]];
	
	var PurMainGrid = $UI.datagrid('#PurMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INPurPlan',
			QueryName: 'Query'
		},
		onClickCell: function(index, filed ,value){	
			PurMainGrid.commonClickCell(index,filed,value)
		},
		columns: PurMainCm,
		onSelect:function(index, row){
			PurDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.INPurPlanItm',
				QueryName: 'Query',
				PurId: row.RowId,
				rows: 99999
			});
		},
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				PurMainGrid.selectRow(0);
			}
		}
	})
	/*--设置初始值--*/
	var Default=function(){
		///设置初始值 考虑使用配置
		var DefaultValue={
			StartDate:DefaultStDate(),
			EndDate:DefaultEdDate(),
			PurLoc:gLocObj,
			AuditFlag:'N'
		}
		$UI.fillBlock('#MainConditions',DefaultValue)
	}
	Default()
}
$(init);