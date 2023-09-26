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
	//回车事件
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
			title: '库存项id',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			sortable:true,
			width: 100,
			frozen:true
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 150,
			frozen:true
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '型号',
			field: 'Model',
			width: 100
		}, {
			title: '备注',
			field: 'Remarks',
			width: 100
		}, {
			title: '品牌',
			field: 'Brand',
			width: 100
		}, {
			title: '监管级别',
			field: 'Supervision',
			width: 100
		}, {
			title: '厂商',
			width: 150,
			field: 'Manf'
		}, {
			title: '产地',
			width: 100,
			field: 'Origin'
		}, {
			title: '入库单位',
			width: 80,
			field: 'PurUom'
		}, {
			title: '售价(入库单位)',
			field: 'Sp',
			width: 100,
			align: 'right'
		}, {
			title: '进价(入库单位)',
			field: 'Rp',
			width: 100,
			align: 'right',
			sortable: true
		}, {
			title: '加成',
			width: 100,
			field: 'Marginnow',
			align: 'right'
		}, {
			title: '基本单位',
			width: 80,
			field: 'BUom'
		}, {
			title: '计价单位',
			width: 80,
			field: 'BillUom'
		}, {
			title: '库存分类',
			width: 100,
			field: 'StkCatDesc'
		}, {
			title: '不可用',
			width: 60,
			field: 'NotUseFlag',
			formatter: BoolFormatter
		}, {
			title: '供应商rowid',
			field: 'VendorId',
			width: 100,
			hidden: true
		}, {
			title: '供应商',
			width: 150,
			field: 'VendorName'
		}, {
			title: '注册证号',
			width: 100,
			field: 'RegisterNo'
		}, {
			title: '注册证效期',
			width: 100,
			field: 'RegisterNoExpDate'
		}, {
			title: '注册证发证日期',
			width: 120,
			field: 'RegCertDateOfIssue'
		}, {
			title: '注册证名称',
			width: 100,
			field: 'RegItmDesc'
		}, {
			title: '注册证号全名称',
			width: 100,
			field: 'RegCertNoFull'
		}, {
			title: '生产商-生产许可证号',
			width: 140,
			field: 'ProductionLicense'
		}, {
			title: '供应商-经营许可证号',
			width: 140,
			field: 'BusinessCertificate'
		}, {
			title: '供应商-营业执照号',
			field: 'BusinessLicense',
			width: 140
		}, {
			title: '供应商-联系人',
			field: 'ContactPerson',
			width: 100
		}, {
			title: '供应商-授权到期',
			field: 'AuthorizationDate',
			width: 120
		}, {
			title: '供应商-联系电话',
			field: 'ContactTel',
			width: 120
		}, {
			title: '进价(基本单位)',
			field: 'BRp',
			width: 100,
			align: 'right'
		}, {
			title: '高值标志',
			field: 'HighPrice',
			width: 80,
			align: 'center',
			formatter: BoolFormatter
		}, {
			title: '植入标志',
			field: 'Implantation',
			width: 80,
			align: 'center',
			formatter: BoolFormatter
		}, {
			title: '药学项代码',
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
