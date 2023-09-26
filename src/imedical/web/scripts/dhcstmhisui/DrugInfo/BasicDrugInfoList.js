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
	$('#QueryBT').on('click', QueryDrugInfo);
	$('#ClearBT').on('click', ClearDrugInfo);
	/*$('#FStkGrpBox').stkscgcombotree({
		onSelect:function(node){
			$.cm({
				ClassName:'web.DHCSTMHUI.Common.Dicts',
				QueryName:'GetStkCat',
				ResultSetType:'array',
				StkGrpId:node.id
			},function(data){
				FStkCatBox.clear();
				FStkCatBox.loadData(data);
				})
			}
	})*/
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
	
	var FVendorBox = $HUI.combobox('#FVendorBox', {
			//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+FVendorParams,
			valueField: 'RowId',
			textField: 'Description',
			onShowPanel: function () {
				FVendorBox.clear();
				var FVendorParams=JSON.stringify(addSessionParams({APCType:"M",ScgId:"",RcFlag:"Y",BDPHospital:HospId}));
				var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+FVendorParams;
				FVendorBox.reload(url);
			}
		});
	var HandlerParams=function(){
		var Scg=$("#FStkGrpBox").combotree('getValue');
		var Obj={StkGrpRowId:Scg,StkGrpType:"M",BDPHospital:HospId};
		return Obj
	}
	$("#FInciDesc").lookup(InciLookUpOp(HandlerParams,'#FInciDesc','#FInci'));
	var DrugInfoCm = [[{
				title: '�����id',
				field: 'RowId',
				align: 'left',
				width:100,
				hidden: true
			}, {
				title: '���ʴ���',
				field: 'InciCode',
				align: 'left',
				width:100,
				sortable: true
			}, {
				title: '��������',
				field: 'InciDesc',
				align: 'left',
				width:100,
				sortable: true
			}, {
				title: '���',
				field: 'Spec',
				width:100,
				align: 'left'
			}, {
				title: '�ͺ�',
				field: 'Model',
				width:100,
				align: 'left'
			}, {
				title: 'Ʒ��',
				field: 'Brand',
				width:100,
				align: 'left'
			}, {
				title: '����',
				field: 'Manf',
				width:100,
				align: 'left'
			}, {
				title: '��ⵥλ',
				field: 'PurUom',
				width:100,
				align: 'left'
			}, {
				title: '�ۼ�(��ⵥλ)',
				field: 'Sp',
				align: 'right',
				width:100,
				sortable: true
			}, {
				title: '����(��ⵥλ)',
				field: 'Rp',
				align: 'right',
				width:100,
				sortable: true
			}, {
				title: '������λ',
				field: 'BUom',
				width:100,
				align: 'left'
			}, {
				title: '�Ƽ۵�λ',
				field: 'BillUom',
				width:100,
				align: 'left'
			}, {
				title: '������',
				field: 'StkCatDesc',
				width:100,
				align: 'left'
			}, {
				title: '��������',
				field: 'InciCreateDate',
				width:100,
				align: 'left'
			}, {
				title: '��������',
				field: 'InciUpdateDate',
				width:100,
				align: 'left'
			}, {
				title: '������',
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
			toolbar: [
			 {
				text: 'ȷ�ϲ�ά��ҽ����',
				iconCls: 'icon-accept',
				handler: function () {
					var Row=DrugInfoGrid.getSelected()
					if(isEmpty(Row)){
						$UI.msg('alert','��ѡ��Ҫȷ�ϵĿ����!');
						return;
					}
					var InciId=Row.RowId;
					var AckFlag='Y';
					var UserId=gUserId;
					$.cm({
						ClassName: 'web.DHCSTMHUI.INCITM',
						MethodName: 'SetAckSpFlag',
						InciId: InciId,
						AckFlag: AckFlag,
						UserId:UserId
					},function(jsonData){
						if(jsonData.success==0){
							$UI.msg('success',jsonData.msg);
						}else{
							$UI.msg('error',jsonData.msg);		
						}
					});					
					
				}
			}
			],
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
		$UI.clearBlock('#BasicInciData');
		if ('#ArcimData'){$UI.clearBlock('#ArcimData');}
		$UI.clear(DrugInfoGrid);
		$('#FChargeBox').val('');
		InitHosp();
		$('#FStkGrpBox').combotree('options')['setDefaultFun']();
	}
	function ClearDrugInfoForHosp() {
		$UI.clearBlock('#BasicInciData');
		if ('#ArcimData'){$UI.clearBlock('#ArcimData');}
		$UI.clear(DrugInfoGrid);
		$('#FChargeBox').val('');
	}
	ClearDrugInfo();
 initDetail();
}
$(init);