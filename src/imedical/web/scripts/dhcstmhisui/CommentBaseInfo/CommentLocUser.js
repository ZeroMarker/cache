var init = function (){
	/*����������*/
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
	/*��������*/
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
	/*������Ա*/
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
			text: '��ѯ',
			iconCls: 'icon-search',
			handler: function(){
				ComLocGrid.load({
					ClassName: 'web.DHCSTMHUI.CommentLocUser',
					QueryName: 'selectComLoc'
				});
			}
		},{
			text: '����',
			iconCls: 'icon-add',
			handler: function(){
				ComLocGrid.commonAddRow();
			}
		}, {
			text: '����',
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
			text: 'ɾ��',
			iconCls: 'icon-cancel',
			handler: function () {
				var Rows=ComLocGrid.getSelectedData()
				if(isEmpty(Rows)){
					$UI.msg('alert','û��ѡ�е���Ϣ!')
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
			title: '����������',
			field: 'PhaLocId',
			width:150,
			formatter: CommonFormatter(PhaLocCombox,'PhaLocId','PhaLocDesc'),
			editor:PhaLocCombox
		}, {
			title: '�ɵ�������',
			field: 'ComLocId',
			width:150,
			formatter: CommonFormatter(ComLocCombox,'ComLocId','ComLocDesc'),
			editor:ComLocCombox
		}, {
			title: '��ʼ����',
			field: 'StartDate',
			width:150,
			editor:{
				type:'datebox'
				}
		}, {
			title: '��ʼʱ��',
			field: 'StartTime',
			width:150,
			editor:{
				type:'timespinner',
				options:{
					}
				}
		}, {
			title: '��ֹ����',
			field: 'EndDate',
			width:150,
			editor:{
				type:'datebox'
				}
		}, {
			title: '��ֹʱ��',
			field: 'EndTime',
			width:150,
			editor:{
				type:'timespinner',
				options:{
					}
				}
		}, {
			title: '�Ƿ񼤻�',
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
			text: '����',
			iconCls: 'icon-add',
			handler: function(){
				var Selected = ComLocGrid.getSelected();
				var ParRef = Selected.RowId;				
				if(isEmpty(ParRef)){
					$UI.msg('alert','��ѡ��Ҫά���Ŀɵ�������!')
					return;
				}
				ComUserGrid.commonAddRow();
			}
		}, {
			text: '����',
			iconCls: 'icon-save',
			handler: function () {
				var Rows = ComUserGrid.getChangesData();
				if(isEmpty(Rows)){
					$UI.msg('alert','û����Ҫ�������Ϣ!');
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
			text: 'ɾ��',
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
			title: '��Ա����',
			field: 'ComUserCode', 
			width:150
		},{
			title: '����',
			field: 'ComUserId',
			width:100,
			formatter: CommonFormatter(UserCombox,'ComUserId','ComUser'),
			editor:UserCombox
		}, {
			title: '��ʼ����',
			field: 'StartDate',
			width:150,
			editor:{
				type:'datebox'
				}
		}, {
			title: '��ʼʱ��',
			field: 'StartTime',
			width:150,
			editor:{
				type:'timespinner',
				options:{
					}
				}
		}, {
			title: '��ֹ����',
			field: 'EndDate',
			width:150,
			editor:{
				type:'datebox'
				}
		}, {
			title: '��ֹʱ��',
			field: 'EndTime',
			width:150,
			editor:{
				type:'timespinner',
				options:{
					}
				}
		}, {
			title: '�Ƿ񼤻�',
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