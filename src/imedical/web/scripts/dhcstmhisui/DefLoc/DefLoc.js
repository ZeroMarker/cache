///��������ά��
var init = function (){
	var HospId="";
	function InitHosp() {
		var hospComp=InitHospCombo("CT_Loc",gSessionStr);
		if (typeof hospComp ==='object'){
			HospId=$HUI.combogrid('#_HospList').getValue();
			$('#_HospList').combogrid("options").onSelect=function(index,record){
				HospId=record.HOSPRowId;
				$UI.clearBlock('LocTB');
				QueryGroupLoc();
			};
		}else{
			HospId=gHospId;
		}
	}
	function GetHospId() {
		var HospId="";
		if ($("#_HospList").length!=0){
			HospId=$HUI.combogrid('#_HospList').getValue();
		}else{
			HospId=gHospId;
		}
		return HospId;
	}
	/*var DefLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var LocCombox = {
		type:'combobox',
		options: {
			valueField: 'RowId',
			textField: 'Description',
			data : function(){
				var ComboData = $.cm({
					ClassName: 'web.DHCSTMHUI.Common.Dicts',
					QueryName: 'GetCTLoc',
					ResultSetType: 'array',
					Params: DefLocParams
				}, false);
				return ComboData;
			}()
		}
	};
	*/
	var LocCombox = {
		type: 'combobox',
		options: {
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function (record) {
				var rows = DeflocGrpGrid.getRows();
				var row = rows[DeflocGrpGrid.editIndex];
				row.CtDesc = record.Description;
			},
			onShowPanel: function () {
				var Params=JSON.stringify(addSessionParams({Type:'All',BDPHospital:GetHospId()}));
				$(this).combobox('clear');
				var url = $URL+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='+Params;
				$(this).combobox('reload',url);
			}
		}
	};
	function QueryGroupLoc(){
		var SessionParmas=addSessionParams({BDPHospital:HospId});
		var Paramsobj=$UI.loopBlock('LocTB');
		var Params=JSON.stringify(jQuery.extend(true,Paramsobj,SessionParmas));
		$UI.clear(DeflocGrpGrid);
		$UI.clear(LocGrid);
		LocGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCPlanStatusInit',
			QueryName: 'QueryGroupLoc',
			Params: Params
			//GroupId:gGroupId
		});	
	}
	$('#SearchBT').on('click', function(){
		QueryGroupLoc();
	});
	function clear(){
		$UI.clearBlock('LocTB');
		$UI.clear(LocGrid);
		$UI.clear(DeflocGrpGrid);
		InitHosp();	
	}
	$('#ClearBT').on('click', function(){
		clear();
	});
	var LocGridCm = [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '����',
			field: 'Code',
			width:300
		}, {
			title: '����',
			field: 'Description',
			width:350
		}
	]];
	var SessionParmas=addSessionParams({Hospital:HospId});
	var Paramsobj=$UI.loopBlock('LocTB');
	var Params1=JSON.stringify(jQuery.extend(true,Paramsobj,SessionParmas));
	var LocGrid = $UI.datagrid('#LocList', {
		lazy: false,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCPlanStatusInit',
			QueryName: 'QueryGroupLoc',
			Params:Params1
			//GroupId:gGroupId
		},
		columns: LocGridCm,
		//toolbar: '#LocTB',
		sortName: 'RowId',  
		sortOrder: 'Desc', 
		onClickCell: function(index, filed ,value){
			var Row=LocGrid.getRows()[index]
			var Id = Row.RowId;
			if(!isEmpty(Id)){
				DeflocGrp(Id);
			}	
			LocGrid.commonClickCell(index,filed)
		}
	})
	var DefLocGrpBar = [{
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
					$UI.msg('alert','��ѡ��Ҫά���Ŀ���!');
					return;
				}
				DeflocGrpGrid.commonAddRow();
			}
		}, {
			text: '����',
			iconCls: 'icon-save',
			handler: function () {
				var Rows = DeflocGrpGrid.getChangesData();
				if (Rows === false){	//δ��ɱ༭����ϸΪ��
					return;
				}
				if (isEmpty(Rows)){	//��ϸ����
					$UI.msg("alert", "û����Ҫ�������ϸ!");
					return;
				}
				for(var i = 0;i<Rows.length;i++){
					if(Rows[i].Description==""){
						$UI.msg('alert','��ѡ�����������Ϣ!');
						return;
					}
				}
				var Selected = LocGrid.getSelected();
				var PRowId = Selected.RowId;
				$.cm({
					ClassName: 'web.DHCSTMHUI.DefLoc',
					MethodName: 'Save',
					LocId: PRowId,
					Params: JSON.stringify(Rows)
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success', jsonData.msg);
						DeflocGrpGrid.reload()
					}else{
				$UI.msg('error', jsonData.msg);
			}
				});
			}
		}, {
			text: 'ɾ��',
			iconCls: 'icon-cancel',
			handler: function () {
				var Rows=DeflocGrpGrid.getSelectedData();
				if(isEmpty(Rows)){
					$UI.msg('alert','��ѡ����Ҫɾ���Ŀ�����Ϣ!');
					return;
				}
				$.cm({
					ClassName:'web.DHCSTMHUI.DefLoc',
					MethodName:'Delete',
					Params:JSON.stringify(Rows)
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success', jsonData.msg);
						DeflocGrpGrid.reload()
					}else{
				$UI.msg('error', jsonData.msg);
			}
				});
			}
		}
	];
	var DeflocGrpGridCm = [[{
			field: 'ck',
			checkbox: true
		},{
			title: 'Rowid',
			field: 'Rowid',
			hidden: true
		},{
			title: '����',
			field: 'CtCode', 
			width:220
		},{
			title: '����',
			field: 'CtRowId',
			width:250,
			formatter: CommonFormatter(LocCombox,'CtRowId','CtDesc'),
			editor:LocCombox
		}, {
			title : 'ʹ�ñ�־',
			field : 'UseFlag',
			hidden:true
		}
	]]; 
	var DeflocGrpGrid = $UI.datagrid('#DeflocGrpGridList', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DefLoc',
				MethodName: 'QueryDefLoc'
			},
			columns: DeflocGrpGridCm,
			toolbar: DefLocGrpBar,
			onClickCell: function(index, field ,value){
				var Row=DeflocGrpGrid.getRows()[index]
				DeflocGrpGrid.commonClickCell(index,field)
			}
	});	
	function DeflocGrp(Id) {
		DeflocGrpGrid.load({
			ClassName: 'web.DHCSTMHUI.DefLoc',
			QueryName: 'QueryDefLoc',
			LocId:Id
		});
	}
	clear();
}
$(init);