/*
����������Ϣά��
*/
var init = function(){
	var HospId="";
	function InitHosp() {
		var hospComp=InitHospCombo("CT_Loc",gSessionStr);
		if (typeof hospComp ==='object'){
			HospId=$HUI.combogrid('#_HospList').getValue();
			$('#_HospList').combogrid("options").onSelect=function(index,record){
				HospId=record.HOSPRowId;
				setStkGrpHospid(HospId);
				$UI.clearBlock('Conditions');
				Query();
			};
		}else{
			HospId=gHospId;
		}
		setStkGrpHospid(HospId);
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
	$UI.linkbutton('#SetTransferFrLocBT', {
		onClick: function(){
			setTransferFrLoc(LocInfoGrid,GetHospId());
		}
	});
	$UI.linkbutton('#SetTransStkCatBT', {
		onClick: function(){
			setTransStkCat(LocInfoGrid,GetHospId());
		}
	});	
	$UI.linkbutton('#SetLocClaGrpBT', {
		onClick: function(){
			setLocClaGrp(LocInfoGrid,GetHospId());
		}
	});
	$UI.linkbutton('#QueryBT', {
		onClick: function(){
			Query();
		}
	});
	function Query(){
		var SessionParmas=addSessionParams({Hospital:HospId});
		var Paramsobj=$UI.loopBlock('Conditions');
		var Params=JSON.stringify(jQuery.extend(true,Paramsobj,SessionParmas));
		LocInfoGrid.load({
			ClassName: 'web.DHCSTMHUI.CTLOC',
			QueryName: 'Query',
			Params: Params
		});
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function(){
			Clear();
		}
	});
	function Clear(){
		$UI.clearBlock('#Conditions');
		$UI.clear(LocInfoGrid);
		InitHosp();
	}
	
	$UI.linkbutton('#SaveBT', {
		onClick: function(){
			Save();
		}
	});
	function Save(){
		var Detail = LocInfoGrid.getChangesData();
		if (Detail === false){	//δ��ɱ༭����ϸΪ��
			return;
		}
		if (isEmpty(Detail)){	//��ϸ����
			$UI.msg("alert", "û����Ҫ�������ϸ!");
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.CTLOC',
			MethodName: 'Save',
			Params: JSON.stringify(Detail)
		},function(jsonData){
			if(jsonData.success === 0){
				$UI.msg('success', jsonData.msg);
				LocInfoGrid.reload();
			}else{
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	var Slg=$HUI.combobox('#Slg', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocGroup&ResultSetType=array&Params='+Params,
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function(){
			Slg.clear();
			var Params = JSON.stringify(addSessionParams({BDPHospital:HospId}));
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocGroup&ResultSetType=array&Params='+Params;
			Slg.reload(url);
		}
	})
	var Lig=$HUI.combobox('#Lig', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocItemGrp&ResultSetType=array&Params='+Params,
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function(){
			Lig.clear();
			var Params = JSON.stringify(addSessionParams({BDPHospital:HospId}));
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocItemGrp&ResultSetType=array&Params='+Params;
			Lig.reload(url);
		}
	});
	var MainLoc=$HUI.combobox('#MainLoc', {
		//url: $URL+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='+ JSON.stringify(addSessionParams({Type:'All'})),
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function(){
			MainLoc.clear();
			var Params = JSON.stringify(addSessionParams({Type:'All',BDPHospital:HospId}));
			var url = $URL+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='+Params;
			MainLoc.reload(url);
		}
	});
	$('#Type').simplecombobox({
		data: [
			{RowId: 'A', Description: '��е����'},
			{RowId: 'R', Description: 'ҩ��'},
			{RowId: 'I', Description: 'סԺҩ��'},
			{RowId: 'O', Description: '����ҩ��'},
			{RowId: 'G', Description: '����ҩ��'},
			{RowId: 'E', Description: '����'}
		]
	});
	
	var Params=JSON.stringify(addSessionParams({BDPHospital:GetHospId()}));
	//������
	/*var SlgCombo = {
		type: 'combobox',
		options: {
			valueField: 'RowId',
			textField: 'Description',
			data : function(){
				var ComboData = $.cm({
					ClassName: 'web.DHCSTMHUI.Common.Dicts',
					QueryName: 'GetLocGroup',
					ResultSetType: 'array',
					Params: Params
				}, false);
				return ComboData;
			}()
		}
	};*/
	var SlgCombo = {
		type: 'combobox',
		options: {
			//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocGroup&ResultSetType=array&Params=' + Params,
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function (record) {
				var rows = LocInfoGrid.getRows();
				var row = rows[LocInfoGrid.editIndex];
				row.SlgDesc = record.Description;
			},
			onShowPanel: function () {
				var Params=JSON.stringify(addSessionParams({BDPHospital:GetHospId()}));
				$(this).combobox('clear');
				var url = $URL+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocGroup&ResultSetType=Array&Params='+Params;
				$(this).combobox('reload',url);
			}
		}
	};
	//��Ŀ��
	/*var LigCombo = {
		type: 'combobox',
		options: {
			valueField: 'RowId',
			textField: 'Description',
			data : function(){
				var ComboData = $.cm({
					ClassName: 'web.DHCSTMHUI.Common.Dicts',
					QueryName: 'GetLocItemGrp',
					ResultSetType: 'array',
					Params: Params
				}, false);
				return ComboData;
			}()
		}
	};*/
	var LigCombo = {
		type: 'combobox',
		options: {
			//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocItemGrp&ResultSetType=array&Params=' + Params,
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function (record) {
				var rows = LocInfoGrid.getRows();
				var row = rows[LocInfoGrid.editIndex];
				row.LigDesc = record.Description;
			},
			onShowPanel: function () {
				var Params=JSON.stringify(addSessionParams({BDPHospital:GetHospId()}));
				$(this).combobox('clear');
				var url = $URL+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocItemGrp&ResultSetType=Array&Params='+Params;
				$(this).combobox('reload',url);
			}
		}
	};
	var LocTypeCombo = {
		type: 'combobox',
		options: {
			mode: 'local',
			valueField: 'RowId',
			textField: 'Description',
			data: [
				{RowId: 'A', Description: '��е����'},
				{RowId: 'R', Description: 'ҩ��'},
				{RowId: 'I', Description: 'סԺҩ��'},
				{RowId: 'O', Description: '����ҩ��'},
				{RowId: 'G', Description: '����ҩ��'},
				{RowId: 'E', Description: '����'}
			]
		}
	};
	//֧�����
	/*var MainLocCombo = {
		type: 'combobox',
		options: {
			valueField: 'RowId',
			textField: 'Description',
			data : function(){
				var ComboData = $.cm({
					ClassName: 'web.DHCSTMHUI.Common.Dicts',
					QueryName: 'GetCTLoc',
					Params: JSON.stringify(addSessionParams({Type:'All'})),
					ResultSetType: 'array'
				}, false);
				return ComboData;
			}()
		}
	};*/
	var MainLocCombo = {
		type: 'combobox',
		options: {
			//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + Params,
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function (record) {
				var rows = LocInfoGrid.getRows();
				var row = rows[LocInfoGrid.editIndex];
				row.MainLocDesc = record.Description;
			},
			onShowPanel: function () {
				var Params=JSON.stringify(addSessionParams({Type:'All',BDPHospital:GetHospId()}));
				$(this).combobox('clear');
				var url = $URL+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='+Params;
				$(this).combobox('reload',url);
			}
		}
	};
	var PrintModeCombo = {
		type: 'combobox',
		options: {
			mode: 'local',
			valueField: 'RowId',
			textField: 'Description',
			data: [
				{RowId: 'MM', Description: 'MM'},
				{RowId: 'MO', Description: 'MO'},
				{RowId: 'MR', Description: 'MR'},
				{RowId: 'MF', Description: 'MF'}
			]
		}
	};
	
	var LocInfoCm = [[
		{
			title: 'LocId',
			field: 'LocId',
			width: 80,
			hidden: true
		},{
			title: '����',
			field: 'LocCode',
			width: 150,
			align: 'left'
		},{
			title: '����',
			field: 'LocDesc',
			width: 260,
			align: 'left'
		},{
			title: '������',
			field: 'SlgId',
			width: 120,
			editor: SlgCombo,
			formatter: CommonFormatter(SlgCombo, 'SlgId', 'SlgDesc')		//combo��dataͬ��ʱ,ʹ��CommonFormatter(SlgCombo)Ҳ��
		},{
			title: '��Ŀ��',
			field: 'LigId',
			width: 120,
			editor: LigCombo,
			formatter: CommonFormatter(LigCombo, 'LigId', 'LigDesc')
		},{
			title: '�ⷿ���',
			field: 'Type',
			width: 150,
			editor: LocTypeCombo,
			formatter: CommonFormatter(LocTypeCombo)
		},{
			title: '֧�����',
			field: 'MainLocId',
			width: 150,
			editor: MainLocCombo,
			formatter: CommonFormatter(MainLocCombo, 'MainLocId', 'MainLocDesc')
		},{
			title: '����',
			field: 'Active',
			width: 60,
			align: 'center',
			editor: {type: 'checkbox', options: {on:'Y',off:'N'}},
			formatter: BoolFormatter
		},{
			title: '�����������Ŀ',
			field: 'ReqAllItm',
			width: 120,
			align: 'center',
			editor: {type: 'checkbox', options: {on:'Y',off:'N'}},
			formatter: BoolFormatter
		},{
			title: '����˳��',
			field: 'ReportSeq',
			width: 80,
			align: 'right',
			editor: {type:'numberbox'}
		},{
			title: '��ӡģʽ',
			field: 'PrintMode',
			width: 100,
			align: 'left',
			editor: PrintModeCombo,
			formatter: CommonFormatter(PrintModeCombo)
		},{
			title: '�Զ��±���־',
			field: 'AutoMonFlag',
			width: 120,
			align: 'center',
			editor: {type: 'checkbox', options: {on:'Y',off:'N'}},
			formatter: BoolFormatter
		}
	]];


	var LocInfoGrid = $UI.datagrid('#LocInfoGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.CTLOC',
			QueryName: 'Query'
		},
		columns: LocInfoCm,
		//fitColumns: true,
		remoteSort: true,
		showBar: true,
		onClickCell: function(index, field ,value){
			LocInfoGrid.commonClickCell(index, field);
		}
	});
	Clear();
	Query();
};
$(init);