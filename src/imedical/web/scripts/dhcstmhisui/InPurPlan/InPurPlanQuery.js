var init = function() {

	/*--按钮事件--*/
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#MainConditions');
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
			ParamsObj.CompFlag="Y";
			ParamsObj.AuditFlag="Y";
			var Params=JSON.stringify(ParamsObj);
			$UI.clear(PurDetailGrid);
			PurMainGrid.load({
				ClassName: 'web.DHCSTMHUI.INPurPlan',
				QueryName: 'Query',
				Params:Params
			});
		}
	});
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			DefaultClear();
		}
	});
	function DefaultClear(){
		$UI.clearBlock('#MainConditions');
		$UI.clear(PurMainGrid);
		$UI.clear(PurDetailGrid);
		Default();
	}
	$UI.linkbutton('#PrintBT',{
		onClick:function(){
			var Row=PurMainGrid.getSelected();
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
	var StkCatBox = $HUI.combobox('#StkCat', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	$('#StkScg').combotree({
		onChange:function(newValue, oldValue){
			StkCatBox.clear();
			var url=$URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array&StkGrpId='+newValue;
			StkCatBox.reload(url);
		}
	});
	var HandlerParams=function(){
		var StkScg=$("#StkScg").combotree('getValue');
		var PurLoc=$("#PurLoc").combo('getValue');
		var Obj={StkGrpRowId:StkScg,StkGrpType:"M",Locdr:PurLoc};
		return Obj
	}
	$("#InciDesc").lookup(InciLookUpOp(HandlerParams,'#InciDesc','#Inci'));
	
	$HUI.tabs("#DetailTabs",{
		onSelect:function(title,index){
			var Row=PurMainGrid.getSelected()
			if(isEmpty(Row)){
				$UI.msg("alert","请选择采购计划单!");
				return;
			}
			PurId=Row.RowId
			if(title=="物资明细"){
				loadIncDetailIFrame(PurId);
			}
			else if(title=="科室请领明细"){
				loadReqDetailIFrame(PurId);
			}
			else if(title=="供应商明细"){
				loadVenDetailIFrame(PurId);
			}
			else{
				loadPurDetailGrid(PurId);
			}
		}
	});
	function loadPurDetailGrid(PurId){
		PurDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.INPurPlanItm',
				QueryName: 'Query',
				PurId: PurId,
				rows: 99999
			});
	}
	function loadIncDetailIFrame(PurId){
		var p_URL=PmRunQianUrl+"?reportName=DHCSTM_HUI_INPURPLAN_ReqInfo.raq"+"&Parref=" + PurId;
		$("#IncDetailIFrame").attr("src", p_URL);
	}
	function loadReqDetailIFrame(PurId){
		var p_URL=PmRunQianUrl+"?reportName=DHCSTM_HUI_INPURPLAN_ReqLocInfo.raq"+"&Parref=" + PurId;
		$("#ReqDetailIFrame").attr("src", p_URL);
	}
	function loadVenDetailIFrame(PurId){
		var p_URL=PmRunQianUrl+"?reportName=DHCSTM_HUI_INPURPLAN_ReqVenInfo.raq"+"&Parref=" + PurId;
		$("#VenDetailIFrame").attr("src", p_URL)
	}
	function createFrame(url) {
		var s = '<iframe scrolling="auto" frameborder="0"  src="' + url + '" style="width:100%;height:100%;"></iframe>';
		return s;
	}	
	
	/*--Grid--*/
	var PurDetailCm = [[{
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
			var DTTabed = $('#DetailTabs').tabs('getSelected');  
			var DTTabed=$('#DetailTabs').tabs('getTabIndex',DTTabed);
			if(DTTabed==0){
				loadPurDetailGrid(row.RowId)
			}else if(DTTabed==1){
				loadIncDetailIFrame(row.RowId)
			}else if(DTTabed==2){
				loadReqDetailIFrame(row.RowId)
			}else if(DTTabed==2){
				loadVenDetailIFrame(row.RowId)
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
		$UI.fillBlock('#MainConditions',DefaultValue);
		$("#IncDetailIFrame").attr("src", "");
		$("#ReqDetailIFrame").attr("src", "");
		$("#VenDetailIFrame").attr("src", "");
	}
	Default()
}
$(init);