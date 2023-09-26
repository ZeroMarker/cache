var init = function() {
	var Clear=function(){
		$UI.clearBlock('#Conditions');
		$UI.clear(RequestMainGrid);
		$UI.clear(RequestDetailGrid);
		var Dafult={
			StartDate:DefaultStDate(),
			EndDate:DefaultEdDate(),
			SupLoc:gLocObj,
			AllTransfer:'Y',
			PartTransfer:'Y',
			NoTransfer:'Y',
			RecLocAudited:'Y',
			Complate:'Y',
			ProvLocAudited:'N'
		};
		$UI.fillBlock('#Conditions',Dafult);
	};
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			Query();
		}
	});	
	function Query(){
		var ParamsObj=$UI.loopBlock('#Conditions')
		if(isEmpty(ParamsObj.StartDate)){
			$UI.msg('alert','开始日期不能为空!');
			return;
		}
		if(isEmpty(ParamsObj.EndDate)){
			$UI.msg('alert','截止日期不能为空!');
			return;
		}
		if(isEmpty(ParamsObj.SupLoc)){
			$UI.msg('alert','供应科室不能为空!');
			return;
		}
		var Params=JSON.stringify(ParamsObj);
		RequestMainGrid.load({
			ClassName: 'web.DHCSTMHUI.INRequest',
			QueryName: 'INReqM',
			Params:Params
		});
	}
	$UI.linkbutton('#AduitBT',{
		onClick:function(){
			var Row=RequestMainGrid.getSelected();
			if(isEmpty(Row)){
				$UI.msg('alert','请选择请求单!');
				return;
			}
			var Params=JSON.stringify(addSessionParams({Req:Row.RowId}));
			$.cm({
				ClassName: 'web.DHCSTMHUI.INRequest',
				MethodName: 'jsProvSideAudit',
				Params:Params
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					$UI.clear(RequestDetailGrid);
					RequestMainGrid.commonReload();
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#DenyBT',{
		onClick:function(){
			var Row=RequestMainGrid.getSelected();
			if(isEmpty(Row)){
				$UI.msg('alert','请选择请求单!');
				return;
			}
			var Params=JSON.stringify(addSessionParams({Req:Row.RowId}));
			$.cm({
				ClassName: 'web.DHCSTMHUI.INRequest',
				MethodName: 'ProvSideDeny',
				Params:Params
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					$UI.clear(RequestDetailGrid);
					RequestMainGrid.commonReload();
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#PrintBT', {
		onClick: function () {
			var Row=RequestMainGrid.getSelected();
			if(isEmpty(Row)){
				$UI.msg('alert','请选择需要打印的请求单!');
				return;
			}
			var RowId=Row.RowId;
			PrintINRequest(RowId);
		}
	});
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Clear()
		}
	});
	var ReqLocParams=JSON.stringify(addSessionParams({Type:'All'}));
	var ReqLocBox = $HUI.combobox('#ReqLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+ReqLocParams,
			valueField: 'RowId',
			textField: 'Description'
		});
	var SupLocParams=JSON.stringify(addSessionParams({Type:INREQUEST_LOCTYPE}));
	var SupLocBox = $HUI.combobox('#SupLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+SupLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var RequestMainCm = [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '请求单类型',
			field: 'ReqType',
			width:150,
			formatter:function(v){
				if (v=='O') {return "请求单";}
				if (v=='C') {return '申领计划';}
				return '其他';
			}
		}, {
			title: '请求单号',
			field: 'ReqNo',
			width:150
		}, {
			title: '请求部门',
			field: 'ToLocDesc',
			width:150
		}, {
			title: "供给部门",
			field:'FrLocDesc',
			width:100
		}, {
			title:"请求人",
			field:'UserName',
			width:70
		}, {
			title:"日期",
			field:'Date',
			width:90
		}, {
			title:"时间",
			field:'Time',
			width:80
		}, {
			title:"完成状态",
			field:'Complete',
			align:'center',
			width:60
		}, {
			title:"转移状态",
			field:'Status',
			width:80,
			align:'center',
			formatter:function(value){
				var status="";
				if(value==0){
					status="未转移";
				}else if(value==1){
					status="部分转移";
				}else if(value==2){
					status="全部转移";
				}
				return status;
			}
		}, {
			title:"备注",
			field:'Remark',
			width:100
		},{
			title:'请求方审核',
			field:'RecLocAudited',
			align:'center',
			width:80
		},{
			title: "审核日期",
			field: 'AuditDate',
			width: 80
		},{
			title:'供应方审核',
			field:'ProvLocAudited',
			align:'center',
			width:80
		},{
			title:'仓库是否拒绝',
			field:'PreFlag',
			width:80,
			align:'center'
		}
	]];
	
	var RequestMainGrid = $UI.datagrid('#RequestMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INRequest',
			QueryName: 'INReqM'
		},
		columns: RequestMainCm,
		onSelect:function(index, row){
			var ParamsObj={RefuseFlag:1};
			var Params=JSON.stringify(ParamsObj);
			RequestDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.INReqItm',
				QueryName: 'INReqD',
				Req: row.RowId,
				Params:Params,
				rows: 99999
			});
		},
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				$(this).datagrid('selectRow', 0);
			}
		}
	})
	
	function savecheck(){
		RequestDetailGrid.endEditing();
		var rowsData = RequestDetailGrid.getRows();
		for(var i=0;i<rowsData.length;i++){
			var row=rowsData[i]
			var ApprovedQty=row.ApprovedQty;
			if ( ApprovedQty < 0 ){
				$UI.msg("alert","第"+(i+1)+"行批准数量不能小于0");
				return false;
			}
		}
		return true;
	}
	function DetailSave(){
		if(savecheck()==true){
			var Details=RequestDetailGrid.getChangesData('RowId');
			$.cm({
				ClassName: 'web.DHCSTMHUI.INReqItm',
				MethodName: 'jsModifyQtyApproved',
				Details: JSON.stringify(Details)
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					RequestDetailGrid.reload()
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
		}
	}
	
	var RequestDetailCm = [[{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '物资代码',
			field: 'Code',
			width:120
		}, {
			title: '物资名称',
			field: 'Description',
			width:150
		}, {
			title: "规格",
			field:'Spec',
			width:100
		}, {
			title:"具体规格",
			field:'SpecDesc',
			width:100
		}, {
			title:"厂商",
			field:'Manf',
			width:100
		}, {
			title:"请求数量",
			field:'Qty',
			width:100,
			align:'right'
		}, {
			title:"批准数量",
			field:'ApprovedQty',
			width:100,
			align:'right',
			editor: {
					type: 'numberbox',
					options: {
						required: true
					}
				}
		}, {
			title:"单位",
			field:'UomDesc',
			width:80
		}, {
			title:"售价",
			field:'Sp',
			width:100,
			align:'right'
		}, {
			title:"售价金额",
			field:'SpAmt',
			width:100,
			align:'right'
		}, {
			title:"请求备注",
			field:'ReqRemarks',
			width:100
		}, {
			title:"是否拒绝",
			field:'RefuseFlag',
			width:80,
			align:'center'
		}
	]];
	
	var RequestDetailGrid = $UI.datagrid('#RequestDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INReqItm',
			QueryName: 'INReqD',
			rows: 99999
		},
		pagination:false,
		columns: RequestDetailCm,
		toolbar:[{
			text: '保存',
			iconCls: 'icon-save',
			handler: function () {
				DetailSave();
			}
		}],
		onClickCell: function (index, filed, value) {
			RequestDetailGrid.commonClickCell(index, filed, value);
		},
		onBeforeCellEdit: function(index, field){
			var Row=RequestMainGrid.getSelected()
			var ProvAuditFlag=Row.ProvLocAudited
			if(ProvAuditFlag=="Y"){
				$UI.msg("alert","供应方已审核不能修改!");
				return false;
			}
		}
	})
	
	Clear();
	Query();
	
}
$(init);