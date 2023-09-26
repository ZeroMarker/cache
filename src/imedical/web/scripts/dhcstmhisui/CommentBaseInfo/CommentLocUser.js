var init = function (){
	/*被点评科室*/
	var PhaLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var PhaLocCombox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+PhaLocParams,
			valueField: 'RowId',
			textField: 'Description',
			required:true,
			onSelect:function(record){
				var rows =ComLocGrid.getRows();
				var row = rows[ComLocGrid.editIndex];
				row.PhaLocDesc=record.Description;
			},
			onShowPanel:function(){
				$(this).combobox('reload')
			}
		}
	};
	/*点评科室*/
	var ComLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var ComLocCombox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+ComLocParams,
			valueField: 'RowId',
			textField: 'Description',
			required:true,
			onSelect:function(record){
				var rows =ComLocGrid.getRows();
				var row = rows[ComLocGrid.editIndex];
				row.ComLocDesc=record.Description;
			},
			onShowPanel:function(){
				$(this).combobox('reload')
			}
		}
	};
	/*点评人员*/
	var UserCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			mode: 'remote',
			onBeforeLoad: function (param) {
				var Selected = ComLocGrid.getSelected();
				if (!isEmpty(Selected)) {
					param.Params = JSON.stringify({
						LocDr: Selected.ComLocId
					});
				}

			},
			onSelect:function(record){
				var rows =ComUserGrid.getRows();
				var row = rows[ComUserGrid.editIndex];
				row.User=record.Description;	
			},
			onShowPanel:function(){
				$(this).combobox('reload')
			}
		}
	};
	
	var ComLocTB = [{
			text: '查询',
			iconCls: 'icon-search',
			handler: function(){
				ComLocGrid.load({
					ClassName: 'web.DHCSTMHUI.CommentLocUser',
					QueryName: 'selectComLoc'
				});
			}
		},{
			text: '新增',
			iconCls: 'icon-add',
			handler: function(){
				ComLocGrid.commonAddRow();
			}
		}, {
			text: '保存',
			iconCls: 'icon-save',
			handler: function () {
				var Rows=ComLocGrid.getChangesData();
				$.cm({
					ClassName: 'web.DHCSTMHUI.CommentLocUser',
					MethodName: 'SaveComLoc',
					Params: JSON.stringify(Rows)
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						ComLocGrid.reload();
					}else{
						$UI.msg('error',jsonData.msg);
					 }
				});
			}
		}, {
			text: '删除',
			iconCls: 'icon-cancel',
			handler: function () {
				var Rows=ComLocGrid.getSelectedData()
				if(isEmpty(Rows)){
					$UI.msg('alert','没有选中的信息!')
					return;
				}
				$.cm({
					ClassName: 'web.DHCSTMHUI.CommentLocUser',
					MethodName: 'DeleteComLoc',
					Params: JSON.stringify(Rows)
					},function(jsonData){
						if(jsonData.success==0){
							$UI.msg('success',jsonData.msg);
							ComLocGrid.reload()
						}else{
						 	$UI.msg('error',jsonData.msg);
						}
					}
				);
			}
		}
	];
	var ComLocGridCm = [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '被点评科室',
			field: 'PhaLocId',
			width:150,
			formatter: CommonFormatter(PhaLocCombox,'PhaLocId','PhaLocDesc'),
			editor:PhaLocCombox
		}, {
			title: '可点评科室',
			field: 'ComLocId',
			width:150,
			formatter: CommonFormatter(ComLocCombox,'ComLocId','ComLocDesc'),
			editor:ComLocCombox
		}, {
			title: '开始日期',
			field: 'StartDate',
			width:150,
			editor:{
				type:'datebox'
				}
		}, {
			title: '开始时间',
			field: 'StartTime',
			width:150,
			editor:{
				type:'timespinner',
				options:{
					}
				}
		}, {
			title: '截止日期',
			field: 'EndDate',
			width:150,
			editor:{
				type:'datebox'
				}
		}, {
			title: '截止时间',
			field: 'EndTime',
			width:150,
			editor:{
				type:'timespinner',
				options:{
					}
				}
		}, {
			title: '是否激活',
			field: 'Active',
			width:100,
			align:'center',
			formatter:BoolFormatter,
			editor:{type:'checkbox',options:{on:'Y',off:'N'}}
		}
	]];
	var ComLocGrid = $UI.datagrid('#ComLocGrid', {
		lazy: false,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.CommentLocUser',
			QueryName: 'selectComLoc'
		},
		columns: ComLocGridCm,
		toolbar: ComLocTB,
		onClickCell: function(index, filed ,value){
			var Row=ComLocGrid.getRows()[index];
			var ParRef= Row.RowId;
			if(!isEmpty(ParRef)){
				ComLocUser(ParRef);
			}	
			ComLocGrid.commonClickCell(index,filed)
		}
	})
	var ComUserBar = [{
			text: '新增',
			iconCls: 'icon-add',
			handler: function(){
				var Selected = ComLocGrid.getSelected();
				var ParRef = Selected.RowId;				
				if(isEmpty(ParRef)){
					$UI.msg('alert','请选中要维护的可点评科室!')
					return;
				}
				ComUserGrid.commonAddRow();
			}
		}, {
			text: '保存',
			iconCls: 'icon-save',
			handler: function () {
				var Rows = ComUserGrid.getChangesData();
				if(isEmpty(Rows)){
					$UI.msg('alert','没有需要保存的信息!');
					return;
				}
				var Selected = ComLocGrid.getSelected();
				var ParRef = Selected.RowId;
				$.cm({
					ClassName: 'web.DHCSTMHUI.CommentLocUser',
					MethodName: 'SaveComUser',
					Params: JSON.stringify(Rows),
					ParRef: ParRef
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						ComUserGrid.reload();
					}else{
						$UI.msg('error',jsonData.msg);
					 }
				});
			}
		}, {
			text: '删除',
			iconCls: 'icon-cancel',
			handler: function () {
				var Rows=ComUserGrid.getSelectedData()
				$.cm({
					ClassName:'web.DHCSTMHUI.CommentLocUser',
					MethodName:'DeleteComUser',
					Params:JSON.stringify(Rows)
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						ComUserGrid.reload();
					}else{
						$UI.msg('error',jsonData.msg);
					}
				});
			}
		}
	];
	var ComUserGridCm = [[{
			title: 'CNTLUParRef',
			field: 'CNTLUParRef',
			width:100,
			hidden: true
		},{
			title: 'CNTLURowid',
			field: 'CNTLURowid',
			width:100,
			hidden: true
		},{
			title: '人员工号',
			field: 'ComUserCode', 
			width:150
		},{
			title: '姓名',
			field: 'ComUserId',
			width:100,
			formatter: CommonFormatter(UserCombox,'ComUserId','ComUser'),
			editor:UserCombox
		}, {
			title: '开始日期',
			field: 'StartDate',
			width:150,
			editor:{
				type:'datebox'
				}
		}, {
			title: '开始时间',
			field: 'StartTime',
			width:150,
			editor:{
				type:'timespinner',
				options:{
					}
				}
		}, {
			title: '截止日期',
			field: 'EndDate',
			width:150,
			editor:{
				type:'datebox'
				}
		}, {
			title: '截止时间',
			field: 'EndTime',
			width:150,
			editor:{
				type:'timespinner',
				options:{
					}
				}
		}, {
			title: '是否激活',
			field: 'ActiveFlag',
			width:100,
			align:'center',
			formatter:BoolFormatter,
			editor:{type:'checkbox',options:{on:'Y',off:'N'}}
		}
	]]; 
	var ComUserGrid = $UI.datagrid('#ComUserGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.CommentLocUser',
				QueryName: 'QueryComLocUser'
			},
			columns: ComUserGridCm,
			toolbar: ComUserBar,
			onClickCell: function(index, field ,value){
				var Row=ComUserGrid.getRows()[index]
				ComUserGrid.commonClickCell(index,field)
			}
	});	
	function ComLocUser(ParRef) {
		ComUserGrid.load({
			ClassName: 'web.DHCSTMHUI.CommentLocUser',
			QueryName: 'QueryComLocUser',
			ParRef:ParRef
		});
	}
	}
$(init);