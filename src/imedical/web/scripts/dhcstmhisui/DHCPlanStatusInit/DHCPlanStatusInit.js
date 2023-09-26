// /����: ��������ɹ���˼���ά��
// /����: ��������ɹ���˼���ά��
// /��д�ߣ�zhangxiao
// /��д����: 2018.07.25
var init = function() {
	var HospId=gHospId;
	var TableName="CT_Loc";
	function InitHosp() {
		var hospComp=InitHospCombo(TableName,gSessionStr);
		if (typeof hospComp ==='object'){
			HospId=$HUI.combogrid('#_HospList').getValue();
			Query();
			$('#_HospList').combogrid("options").onSelect=function(index,record){
				HospId=record.HOSPRowId;
				Query();
			};
		}
	}
	function Query(){
		var SessionParmas=addSessionParams({BDPHospital:HospId});
		var Paramsobj=$UI.loopBlock('#LocTB');
		var Params=JSON.stringify(jQuery.extend(true,Paramsobj,SessionParmas));
		LocGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCPlanStatusInit',
			QueryName: 'QueryGroupLoc',
			Params: Params,
			GroupId:''
		});
	}
	
	var PlanStatusCombox = {
		type: 'combobox',
		options: {
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function (record) {
				var rows = StatusGrpGrid.getRows();
				var row = rows[StatusGrpGrid.editIndex];
				row.PlanStatusDesc = record.Description;
			},
			onShowPanel: function () {
				var Params=JSON.stringify(addSessionParams({BDPHospital:HospId}));
				$(this).combobox('clear');
				var url = $URL+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPlanStatus&ResultSetType=Array&Params='+Params;
				$(this).combobox('reload',url);
			}
		}
	};
	
	var GroupCombox = {
		type: 'combobox',
		options: {
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function (record) {
				var rows = StatusGrpGrid.getRows();
				var row = rows[StatusGrpGrid.editIndex];
				row.GroupDesc = record.Description;
			},
			onShowPanel: function () {
				var Params=JSON.stringify(addSessionParams({BDPHospital:HospId}));
				$(this).combobox('clear');
				var url = $URL+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetGroup&ResultSetType=Array&Params='+Params;
				$(this).combobox('reload',url);
			}
		}
	};
	
	$('#SearchBT').on('click', function(){
		Query();
	});
	$('#ClearBT').on('click', function(){
		$UI.clearBlock('LocTB');
		$UI.clear(LocGrid);
		$UI.clear(StatusGrpGrid);
	});
	var LocGridCm = [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '����',
			field: 'Code',
			width:250
		}, {
			title: '����',
			field: 'Description',
			width:300
		}
	]];
	var LocGrid = $UI.datagrid('#LocList', {
		lazy: false,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCPlanStatusInit',
			QueryName: 'QueryGroupLoc',
			GroupId:''
		},
		columns: LocGridCm,
		//toolbar: '#LocTB',
		sortName: 'RowId',  
		sortOrder: 'Desc', 
		onClickCell: function(index, filed ,value){
			var Row=LocGrid.getRows()[index]
			var Id = Row.RowId;
			if(!isEmpty(Id)){
				StatusGrp(Id);
			}	
			LocGrid.commonClickCell(index,filed)
		}
	})
	var StatusGrpBar = [{
			text: '����',
			iconCls: 'icon-add',
			handler: function(){
				var Selected = LocGrid.getSelected();
				if(isEmpty(Selected)){
					$UI.msg('alert','��ѡ��Ҫά���Ŀ���!')
					return;
				}
				var PRowId = Selected.RowId;
				if(isEmpty(PRowId)){
					$UI.msg('alert','��ѡ��Ҫά���Ŀ���!')
					return;
				}
				StatusGrpGrid.commonAddRow();
			}
		}, {
			text: '����',
			iconCls: 'icon-save',
			handler: function () {
				var Rows = StatusGrpGrid.getChangesData();
				if (Rows === false){	//δ��ɱ༭����ϸΪ��
					return;
				}
				if (isEmpty(Rows)){	//��ϸ����
					$UI.msg("alert", "û����Ҫ�������ϸ!");
					return;
				}
				var Selected = LocGrid.getSelected();
				var PRowId = Selected.RowId;
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCPlanStatusInit',
					MethodName: 'Save',
					LocId: PRowId,
					Params: JSON.stringify(Rows)
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						StatusGrpGrid.reload()
					}else{
					 $UI.msg('error',jsonData.msg);
					}
				});
			}
		}, {
			text: 'ɾ��',
			iconCls: 'icon-cancel',
			handler: function () {
				var Rows=StatusGrpGrid.getSelectedData();
				if (isEmpty(Rows)){
					StatusGrpGrid.commonDeleteRow();
				}else{
				$.cm({
					ClassName:'web.DHCSTMHUI.DHCPlanStatusInit',
					MethodName:'Delete',
					Params:JSON.stringify(Rows)
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						StatusGrpGrid.reload()
					}else{
					 $UI.msg('error',jsonData.msg);
					}
				});
				}
			}
		}
	];
	var StatusGrpGridCm = [[{
			title: 'PsiRowId',
			field: 'RowId',
			hidden: true
		},{
			title: '��˼���',
			field: 'PlanStatusId', 
			width:250,
			formatter: CommonFormatter(PlanStatusCombox,'PlanStatusId','PlanStatusDesc'),
			editor:PlanStatusCombox
		},{
			title: '��ȫ��',
			field: 'GroupId',
			width:310,
			formatter: CommonFormatter(GroupCombox,'GroupId','GroupDesc'),
			editor:GroupCombox
			
		}
	]]; 

	var StatusGrpGrid = $UI.datagrid('#StatusGrpGridList', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCPlanStatusInit',
				MethodName: 'QueryPlanStatus'
			},
			deleteRowParams: {
				ClassName: 'web.DHCSTMHUI.DHCPlanStatusInit',
				MethodName: 'Delete'
			},
			columns: StatusGrpGridCm,
			toolbar: StatusGrpBar,
			onClickCell: function(index, field ,value){
				var Row=StatusGrpGrid.getRows()[index]
				StatusGrpGrid.commonClickCell(index,field)
			}
	});	
	function StatusGrp(Id) {
		StatusGrpGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCPlanStatusInit',
			QueryName: 'QueryPlanStatus',
			LocId:Id
		});
	}
	InitHosp();
}
$(init);