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
				$HUI.combotree('#FStkGrpBox').load(HospId); 
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

	var FStkCatBox = $HUI.combobox('#FStkCatBox', {
			valueField: 'RowId',
			textField: 'Description',
			onShowPanel: function () {
				var scg=$("#FStkGrpBox").combotree('getValue');
				var Params=JSON.stringify(addSessionParams({BDPHospital:HospId}));
				FStkCatBox.clear();
				var url=$URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array&StkGrpId=' + scg+'&Params='+Params;
				FStkCatBox.reload(url);
			}
		});
	
//	var FVendorBox = $HUI.combobox('#FVendorBox', {
//			//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+FVendorParams,
//			valueField: 'RowId',
//			textField: 'Description',
//			onShowPanel: function () {
//				FVendorBox.clear();
//				var FVendorParams=JSON.stringify(addSessionParams({APCType:"M",ScgId:"",RcFlag:"Y",BDPHospital:HospId}));
//				var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+FVendorParams;
//				FVendorBox.reload(url);
//			}
//		});
	var FVendorParams=JSON.stringify(addSessionParams({APCType:"M",ScgId:"",RcFlag:"Y",BDPHospital:HospId}));
	$HUI.lookup('#FVendorBox', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetVendor',
			Params: FVendorParams
		}
	});
	var HandlerParams=function(){
		var Scg=$("#FStkGrpBox").combotree('getValue');
		var Obj={StkGrpRowId:Scg,StkGrpType:"M",BDPHospital:HospId};
		return Obj
	}
	$("#FInciDesc").lookup(InciLookUpOp(HandlerParams,'#FInciDesc','#FInci'));
	
	var DrugInfoCm = [[{
				title: '库存项id',
				field: 'RowId',
				align: 'left',
				width:100,
				hidden: true
			}, {
				title: '物资代码',
				field: 'InciCode',
				align: 'left',
				width:100,
				sortable: true
			}, {
				title: '物资名称',
				field: 'InciDesc',
				align: 'left',
				width:100,
				sortable: true
			}, {
				title: '规格',
				field: 'Spec',
				width:100,
				align: 'left'
			}, {
				title: '型号',
				field: 'Model',
				width:100,
				align: 'left'
			}, {
				title: '备注',
				field: 'Remarks',
				width: 100
			}, {
				title: '品牌',
				field: 'Brand',
				width:100,
				align: 'left'
			}, {
				title: '厂商',
				field: 'Manf',
				width:100,
				align: 'left'
			}, {
				title: '入库单位',
				field: 'PurUom',
				width:100,
				align: 'left'
			}, {
				title: '售价(入库单位)',
				field: 'Sp',
				align: 'right',
				width:110,
				sortable: true
			}, {
				title: '进价(入库单位)',
				field: 'Rp',
				align: 'right',
				width:110,
				sortable: true
			}, {
				title: '基本单位',
				field: 'BUom',
				width:80,
				align: 'left'
			}, {
				title: '计价单位',
				field: 'BillUom',
				width:80,
				align: 'left'
			}, {
				title: '库存分类',
				field: 'StkCatDesc',
				width:100,
				align: 'left'
			}, {
				title: '建档日期',
				field: 'InciCreateDate',
				width:100,
				align: 'left'
			}, {
				title: '更新日期',
				field: 'InciUpdateDate',
				width:100,
				align: 'left'
			}, {
				title: '不可用',
				field: 'NotUseFlag',
				width:100,
				align: 'center',
				formatter: BoolFormatter
			}
		]];

	var DrugInfoGrid = $UI.datagrid('#tabDrugList', {
			queryParams: {
				ClassName: "web.DHCSTMHUI.DrugInfoMaintain",
				QueryName: "GetItm"
			},
			columns: DrugInfoCm,
			showBar:true,
			singleSelect: true,
			onSelect:function(index, row){
				GetDetail(row.RowId);
			},
			onLoadSuccess: function(data){
				if(data.rows.length > 0){
					$(this).datagrid('selectRow',0);
				}
			}
		});
	function QueryDrugInfo() {
		var SessionParmas=addSessionParams({BDPHospital:HospId});
		var Paramsobj=$UI.loopBlock('Conditions');
		var Params=JSON.stringify(jQuery.extend(true,Paramsobj,SessionParmas));
		ClearDrugInfoForHosp();
		DrugInfoGrid.load({
			ClassName: "web.DHCSTMHUI.DrugInfoMaintain",
			QueryName: "GetItm",
			Params:Params
		});
	}

	function ClearDrugInfo() {
		$UI.clearBlock('Conditions');
		$UI.clearBlock('#InciData');
		$UI.clearBlock('#ArcimData');
		$UI.clear(DrugInfoGrid);
		$('#FChargeBox').val('')
		$HUI.checkbox('#ChargeFlag').setValue(true);
		ChangeState(0);
		InitCompStat();
		InitHosp();
		$('#FStkGrpBox').combotree('options')['setDefaultFun']();
	}
	function ClearDrugInfoForHosp() {
		$UI.clearBlock('#InciData');
		$UI.clearBlock('#ArcimData');
		$UI.clear(DrugInfoGrid);
		$('#FChargeBox').val('')
	}
	ClearDrugInfo();
	initDetail();
}
$(init);