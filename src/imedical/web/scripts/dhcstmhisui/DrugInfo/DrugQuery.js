var init = function () {
	var HospId="";
	function InitHosp() {
		var hospComp=InitHospCombo("INC_Itm",gSessionStr);
		if (typeof hospComp ==='object'){
			HospId=$HUI.combogrid('#_HospList').getValue();
			$('#_HospList').combogrid("options").onSelect=function(index,record){
				HospId=record.HOSPRowId;
				setStkGrpHospid(HospId);
				$UI.clearBlock('Conditions');
				$HUI.combotree('#StkGrpBox').load(HospId);
				QueryDrugInfo();
			};
		}else{
			HospId=gHospId;
		}
		setStkGrpHospid(HospId);
	}
	//�س��¼�
	$("#Conditions").bind("keydown",function(e){
		var theEvent = e || window.event;
		var code = theEvent.keyCode || theEvent.which || theEvent.charCode;
		if (code == 13) {
			QueryDrugInfo();
		}
	});
	
	$('#QueryBT').on('click', QueryDrugInfo);
	$('#ClearBT').on('click', ClearDrugInfo);
	
	/*$('#StkGrpBox').stkscgcombotree({
		onSelect:function(node){
			var Params=JSON.stringify(addSessionParams({BDPHospital:HospId}));
			$.cm({
				ClassName:'web.DHCSTMHUI.Common.Dicts',
				QueryName:'GetStkCat',
				ResultSetType:'array',
				StkGrpId:node.id,
				Params:Params
			},function(data){
				StkCatBox.clear();
				StkCatBox.loadData(data);
				})
			}
	})*/
	var StkCatBox = $HUI.combobox('#StkCatBox', {
			valueField: 'RowId',
			textField: 'Description',
			onShowPanel: function () {
				var scg=$("#StkGrpBox").combotree('getValue');
				var Params=JSON.stringify(addSessionParams({BDPHospital:HospId}));
				StkCatBox.clear();
				var url=$URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array&StkGrpId=' + scg+'&Params='+Params;
				StkCatBox.reload(url);
			}
		});
	
	var VendorBox = $HUI.combobox('#VendorBox', {
			//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorParams,
			valueField: 'RowId',
			textField: 'Description',
			onShowPanel : function () {
				VendorBox.clear();
				var VendorParams=JSON.stringify(addSessionParams({APCType:"M",ScgId:"",RcFlag:"Y",BDPHospital:HospId}));
				var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorParams;
				VendorBox.reload(url);
			}
		});
	
	var ManfBox = $HUI.combobox('#ManfBox', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params=' + ManfParams,
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel : function () {
			ManfBox.clear();
			var ManfParams = JSON.stringify(addSessionParams({
				StkType: "M",
				BDPHospital:HospId
			}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params=' + ManfParams;
			ManfBox.reload(url);
		}
	});
	var HandlerParams=function(){
		var Scg=$("#StkGrpBox").combotree('getValue');
		var Obj={StkGrpRowId:Scg,StkGrpType:"M",BDPHospital:HospId};
		return Obj
	}
	$("#InciDesc").lookup(InciLookUpOp(HandlerParams,'#InciDesc','#Inci'));
	var DrugInfoCm = [[{
			title: '�����id',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			sortable:true,
			width: 100,
			frozen:true
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 150,
			frozen:true
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '�ͺ�',
			field: 'Model',
			width: 100
		}, {
			title: '��ע',
			field: 'Remarks',
			width: 100
		}, {
			title: 'Ʒ��',
			field: 'Brand',
			width: 100
		}, {
			title: '��ܼ���',
			field: 'Supervision',
			width: 100
		}, {
			title: '����',
			width: 150,
			field: 'Manf'
		}, {
			title: '����',
			width: 100,
			field: 'Origin'
		}, {
			title: '��ⵥλ',
			width: 80,
			field: 'PurUom'
		}, {
			title: '�ۼ�(��ⵥλ)',
			field: 'Sp',
			width: 100,
			align: 'right'
		}, {
			title: '����(��ⵥλ)',
			field: 'Rp',
			width: 100,
			align: 'right',
			sortable: true
		}, {
			title: '�ӳ�',
			width: 100,
			field: 'Marginnow',
			align: 'right'
		}, {
			title: '������λ',
			width: 80,
			field: 'BUom'
		}, {
			title: '�Ƽ۵�λ',
			width: 80,
			field: 'BillUom'
		}, {
			title: '������',
			width: 100,
			field: 'StkCatDesc'
		}, {
			title: '������',
			width: 60,
			field: 'NotUseFlag',
			formatter: BoolFormatter
		}, {
			title: '��Ӧ��rowid',
			field: 'VendorId',
			width: 100,
			hidden: true
		}, {
			title: '��Ӧ��',
			width: 150,
			field: 'VendorName'
		}, {
			title: 'ע��֤��',
			width: 100,
			field: 'RegisterNo'
		}, {
			title: 'ע��֤Ч��',
			width: 100,
			field: 'RegisterNoExpDate'
		}, {
			title: 'ע��֤��֤����',
			width: 120,
			field: 'RegCertDateOfIssue'
		}, {
			title: 'ע��֤����',
			width: 100,
			field: 'RegItmDesc'
		}, {
			title: 'ע��֤��ȫ����',
			width: 100,
			field: 'RegCertNoFull'
		}, {
			title: '������-�������֤��',
			width: 140,
			field: 'ProductionLicense'
		}, {
			title: '��Ӧ��-��Ӫ���֤��',
			width: 140,
			field: 'BusinessCertificate'
		}, {
			title: '��Ӧ��-Ӫҵִ�պ�',
			field: 'BusinessLicense',
			width: 140
		}, {
			title: '��Ӧ��-��ϵ��',
			field: 'ContactPerson',
			width: 100
		}, {
			title: '��Ӧ��-��Ȩ����',
			field: 'AuthorizationDate',
			width: 120
		}, {
			title: '��Ӧ��-��ϵ�绰',
			field: 'ContactTel',
			width: 120
		}, {
			title: '����(������λ)',
			field: 'BRp',
			width: 100,
			align: 'right'
		}, {
			title: '��ֵ��־',
			field: 'HighPrice',
			width: 80,
			align: 'center',
			formatter: BoolFormatter
		}, {
			title: 'ֲ���־',
			field: 'Implantation',
			width: 80,
			align: 'center',
			formatter: BoolFormatter
		}, {
			title: 'ҩѧ�����',
			field: 'PhcdCode',
			width: 100
		}
	]];
	var DrugInfoGrid = $UI.datagrid('#DrugList', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DrugInfoMaintain',
				//QueryName: 'GetItm'
				MethodName: 'GetItmDetail'
			},
			columns: DrugInfoCm,
			remoteSort: true,
			showBar:true
		});
	function QueryDrugInfo() {
		var SessionParmas=addSessionParams({BDPHospital:HospId});
		var Paramsobj=$UI.loopBlock('Conditions');
		var Params=JSON.stringify(jQuery.extend(true,Paramsobj,SessionParmas));
		$UI.clear(DrugInfoGrid);
		DrugInfoGrid.load({
			ClassName: 'web.DHCSTMHUI.DrugInfoMaintain',
			//QueryName: 'GetItm',
			MethodName: 'GetItmDetail',
			Params:Params
		});
	}

	function ClearDrugInfo() {
		$UI.clearBlock('Conditions');
		$UI.clear(DrugInfoGrid);
		InitHosp();
		InitHospButton(DrugInfoGrid,"INC_Itm");
		$('#StkGrpBox').combotree('options')['setDefaultFun']();
	}
	ClearDrugInfo();
}
$(init);
