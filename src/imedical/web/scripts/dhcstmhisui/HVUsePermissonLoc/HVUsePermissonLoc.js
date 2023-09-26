var init = function (){
	var HospId="";
	function InitHosp() {
		var hospComp=InitHospCombo("CT_Loc",gSessionStr);
		if (typeof hospComp ==='object'){
			HospId=$HUI.combogrid('#_HospList').getValue();
			$('#_HospList').combogrid("options").onSelect=function(index,record){
				HospId=record.HOSPRowId;
				SearchBT();
			};
		}else{
			HospId=gHospId;
		}
	}
	//var OperLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var OperLocCombox = {
		type:'combobox',
		options:{
			//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+OperLocParams,
			valueField: 'RowId',
			textField: 'Description',
			required:true,
			onSelect:function(record){
				var rows =PerMLocGrid.getRows();
				var row = rows[PerMLocGrid.editIndex];
				row.OperLocDesc=record.Description;
			},
			onShowPanel:function(){
				var Params=JSON.stringify(addSessionParams({Type:'All',BDPHospital:HospId}));
				$(this).combobox('clear');
				var url = $URL+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='+Params;
				$(this).combobox('reload',url);
			}
		}
	};
	var UserCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			mode: 'remote',
			onBeforeLoad: function (param) {
				var Selected = PerMLocGrid.getSelected();
				if (!isEmpty(Selected)) {
					param.Params = JSON.stringify({
							LocDr: Selected.OperLocId
						});
				}

			},
			onSelect:function(record){
				var rows =PerLocUserGrid.getRows();
				var row = rows[PerLocUserGrid.editIndex];
				row.User=record.Description;	
			},
			onShowPanel:function(){
				$(this).combobox('reload')
			}
		}
	}
	function SearchBT() {
		var Params = JSON.stringify(addSessionParams({Hospital:HospId}));
		$UI.clear(PerMLocGrid);
		$UI.clear(PerLocUserGrid);
		PerMLocGrid.load({
			ClassName: 'web.DHCSTMHUI.HVUsePermissonLoc',
			QueryName: 'selectAll',
			Params: Params
		});
	}
	var PerMLocTB = [{
			text: '��ѯ',
			iconCls: 'icon-search',
			handler: function(){
				SearchBT();
			}
		},{
			text: '����',
			iconCls: 'icon-add',
			handler: function(){
				PerMLocGrid.commonAddRow();
			}
		}, {
			text: '����',
			iconCls: 'icon-save',
			handler: function () {
				var Rows=PerMLocGrid.getChangesData();
				if (Rows === false){	//δ��ɱ༭����ϸΪ��
					return;
				}
				if (isEmpty(Rows)){	//��ϸ����
					$UI.msg("alert", "û����Ҫ�������ϸ!");
					return;
				}
				$.cm({
					ClassName: 'web.DHCSTMHUI.HVUsePermissonLoc',
					MethodName: 'SavePerMLoc',
					Params: JSON.stringify(Rows),
					DOuser:gUserId
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						PerMLocGrid.reload();
					}else{
						$UI.msg('error',jsonData.msg);
					 }
				});
			}
		}, {
			text: 'ɾ��',
			iconCls: 'icon-cancel',
			handler: function () {
				var Rows=PerMLocGrid.getSelectedData()
				if(isEmpty(Rows)&&(isEmpty($('#PerMLocGrid').datagrid("getColumnOption","RowId")))){
					PerMLocGrid.commonDeleteRow();
					return false;
				}
				if(isEmpty(Rows)){
					$UI.msg('alert','û��ѡ�е���Ϣ!')
					return;
				}
				$.cm({
					ClassName: 'web.DHCSTMHUI.HVUsePermissonLoc',
					MethodName: 'DeletePerMLoc',
					Params: JSON.stringify(Rows)
					},function(jsonData){
						if(jsonData.success==0){
							$UI.msg('success',jsonData.msg);
							PerMLocGrid.reload()
							PerLocUserGrid.reload()
						}else{
						 	$UI.msg('error',jsonData.msg);
						}
					}
				);
			}
		}
	];
	var PerMLocGridCm = [[{
			title: 'HUPLrowid',
			field: 'HUPLrowid',
			hidden: true
		}, {
			title: 'ִ�п���',
			field: 'OperLocId',
			width:150,
			formatter: CommonFormatter(OperLocCombox,'OperLocId','OperLocDesc'),
			editor:OperLocCombox
		}, {
			title: '��ʼ����',
			field: 'StartDate',
			width:150,
			editor:{
				type:'datebox',
				options:{
					required:true
					}
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
				type:'datebox',
				options:{
					required:true
					}
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
	var PerMLocGrid = $UI.datagrid('#PerMLocGrid', {
		lazy: false,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.HVUsePermissonLoc',
			QueryName: 'selectAll'
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.HVUsePermissonLoc',
			MethodName: 'DeletePerMLoc',
		},
		columns: PerMLocGridCm,
		fitColumns: true,
		toolbar: PerMLocTB,
		sortName: 'RowId',  
		sortOrder: 'Desc', 
		onClickCell: function(index, filed ,value){
			var Row=PerMLocGrid.getRows()[index]
			var HUPLrowid= Row.HUPLrowid;
			if(!isEmpty(HUPLrowid)){
				OperLocGrp(HUPLrowid);
			}	
			PerMLocGrid.commonClickCell(index,filed)
		}
	})
	var PerLocUserBar = [{
			text: '����',
			iconCls: 'icon-add',
			handler: function(){
				var Selected = PerMLocGrid.getSelected();
				var HUPLrowid = Selected.HUPLrowid;
				if(isEmpty(HUPLrowid)){
					$UI.msg('alert','��ѡ��Ҫά���Ŀ���!')
					return;
				}
				PerLocUserGrid.commonAddRow();
			}
		}, {
			text: '����',
			iconCls: 'icon-save',
			handler: function () {
				var Rows = PerLocUserGrid.getChangesData();
				if (Rows === false){	//δ��ɱ༭����ϸΪ��
					return;
				}
				if (isEmpty(Rows)){	//��ϸ����
					$UI.msg("alert", "û����Ҫ�������ϸ!");
					return;
				}
				var Selected = PerMLocGrid.getSelected();
				var Parref = Selected.HUPLrowid;
				$.cm({
					ClassName: 'web.DHCSTMHUI.HVUsePermissonLoc',
					MethodName: 'SavePerLocUser',
					Params: JSON.stringify(Rows),
					PermLocId: Parref,
					DOuser:gUserId
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						PerLocUserGrid.reload();
					}else{
						$UI.msg('error',jsonData.msg);
					 }
				});
			}
		}, {
			text: 'ɾ��',
			iconCls: 'icon-cancel',
			handler: function () {
				var Rows=PerLocUserGrid.getSelectedData()
				if(isEmpty(Rows)&&(isEmpty($('#PerLocUserGrid').datagrid("getColumnOption","RowId")))){
					PerLocUserGrid.commonDeleteRow();
					return false;
				}
				if(isEmpty(Rows)){
					$UI.msg('alert','û��ѡ�е���Ϣ!')
					return;
				}
				$.cm({
					ClassName:'web.DHCSTMHUI.HVUsePermissonLoc',
					MethodName:'DeletePerLocUser',
					Params:JSON.stringify(Rows)
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						PerLocUserGrid.reload();
					}else{
						$UI.msg('error',jsonData.msg);
					}
				});
			}
		}
	];
	var PerLocUserGridCm = [[{
			title: 'HUPLURowid',
			field: 'HUPLURowid',
			width:100,
			hidden: true
		},{
			title: '��Ա����',
			field: 'Code', 
			width:100
		},{
			title: '����',
			field: 'UserId',
			width:100,
			formatter: CommonFormatter(UserCombox,'UserId','User'),
			editor:UserCombox
		}, {
			title: '�Ƿ񼤻�',
			field: 'ActiveFlag',
			width:100,
			align:'center',
			formatter:BoolFormatter,
			editor:{type:'checkbox',options:{on:'Y',off:'N'}}
		}
	]]; 
	var PerLocUserGrid = $UI.datagrid('#PerLocUserGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.HVUsePermissonLoc',
				QueryName: 'QueryPerLocUser'
			},
			deleteRowParams: {
				ClassName:'web.DHCSTMHUI.HVUsePermissonLoc',
				MethodName:'DeletePerLocUser',
			},
			columns: PerLocUserGridCm,
			fitColumns: true,
			toolbar: PerLocUserBar,
			onClickCell: function(index, field ,value){
				var Row=PerLocUserGrid.getRows()[index]
				PerLocUserGrid.commonClickCell(index,field)
			}
	});	
	function OperLocGrp(HUPLrowid) {
		$UI.clear(PerLocUserGrid);
		PerLocUserGrid.load({
			ClassName: 'web.DHCSTMHUI.HVUsePermissonLoc',
			QueryName: 'QueryPerLocUser',
			Parref:HUPLrowid
		});
	}
	InitHosp();
	}
$(init);