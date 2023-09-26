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
				Query();
			};
		}else{
			HospId=gHospId;
		}
		setStkGrpHospid(HospId);
	}
	$('#QueryBT').on('click', Query);
	$('#ClearBT').on('click', Clear);
	var TarSubCat= $HUI.combobox('#TarSubCat', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarSubCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel : function () {
			TarSubCat.clear();
			var Params = JSON.stringify(addSessionParams({BDPHospital:HospId}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarSubCat&ResultSetType=array&Params='+Params;
			TarSubCat.reload(url);
		}
	});
	var TarInpatCat= $HUI.combobox('#TarInpatCat', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarInpatCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel : function () {
			TarInpatCat.clear();
			var Params = JSON.stringify(addSessionParams({BDPHospital:HospId}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarInpatCat&ResultSetType=array&Params='+Params;
			TarInpatCat.reload(url);
		}
	});
	var TarOutpatCat= $HUI.combobox('#TarOutpatCat', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarOutpatCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel : function () {
			TarOutpatCat.clear();
			var Params = JSON.stringify(addSessionParams({BDPHospital:HospId}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarOutpatCat&ResultSetType=array&Params='+Params;
			TarOutpatCat.reload(url);
		}
	});
	var TarEMCCat= $HUI.combobox('#TarEMCCat', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarEMCCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel : function () {
			TarEMCCat.clear();
			var Params = JSON.stringify(addSessionParams({BDPHospital:HospId}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarEMCCat&ResultSetType=array&Params='+Params;
			TarEMCCat.reload(url);
		}
	});
	var TarAcctCat= $HUI.combobox('#TarAcctCat', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarAcctCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel : function () {
			TarAcctCat.clear();
			var Params = JSON.stringify(addSessionParams({BDPHospital:HospId}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarAcctCat&ResultSetType=array&Params='+Params;
			TarAcctCat.reload(url);
		}
	});
	var TarMRCat= $HUI.combobox('#TarMRCat', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarMRCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel : function () {
			TarMRCat.clear();
			var Params = JSON.stringify(addSessionParams({BDPHospital:HospId}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarMRCat&ResultSetType=array&Params='+Params;
			TarMRCat.reload(url);
		}
	});
	var TarNewMRCat= $HUI.combobox('#TarNewMRCat', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarNewMRCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel : function () {
			TarNewMRCat.clear();
			var Params = JSON.stringify(addSessionParams({BDPHospital:HospId}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetTarNewMRCat&ResultSetType=array&Params='+Params;
			TarNewMRCat.reload(url);
		}
	});
	var TarInfoCm = [[{
				title: '收费项id',
				field: 'RowId',
				align: 'left',
				width:100,
				hidden: true
			}, {
				title: '收费项代码',
				field: 'TARICode',
				align: 'left',
				width:100,
				sortable: true
			}, {
				title: '收费项名称',
				field: 'TARIDesc',
				align: 'left',
				width:100,
				sortable: true
			}, {
				title: '单位Id',
				field: 'UomId',
				width:100,
				hidden: true,
				align: 'left'
			}, {
				title: '单位',
				field: 'UomDesc',
				width:100,
				align: 'left'
			}, {
				title: '激活标志',
				field: 'ActiveFlag',
				width:100,
				align: 'center'
			}
		]];

	var TarInfoGrid = $UI.datagrid('#TarGrid', {
		queryParams: {
			ClassName: "web.DHCSTMHUI.InciLinkTar",
			QueryName: "QueryTar"
		},
		columns: TarInfoCm,
		showBar:true,
		singleSelect: true,
		onClickRow:function(index, row){
			InciInfoGrid.load({
				ClassName: 'web.DHCSTMHUI.InciLinkTar',
				QueryName: 'GetLinkData',
				Tariff: row.RowId
			});
		}
	});
	function Query() {
		var SessionParmas=addSessionParams({BDPHospital:HospId});
		var Paramsobj=$UI.loopBlock('Conditions');
		var Params=JSON.stringify(jQuery.extend(true,Paramsobj,SessionParmas));
		$UI.clear(TarInfoGrid);
		$UI.clear(InciInfoGrid);
		TarInfoGrid.load({
			ClassName: "web.DHCSTMHUI.InciLinkTar",
			QueryName: "QueryTar",
			Params:Params
		});
	}
	var HandlerParams=function(){
		var Obj={StkGrpType:"M",NotUseFlag:"N",BDPHospital:HospId};
		return Obj;
	}
	var SelectRow=function(row){
		var Rows =InciInfoGrid.getRows();
		var SelectRow = Rows[InciInfoGrid.editIndex];
		SelectRow.Inci=row.InciDr;
		SelectRow.InciCode=row.InciCode;
		SelectRow.InciDesc=row.InciDesc;
		SelectRow.UomId=row.PUomDr;
		SelectRow.UomDesc=row.PUomDesc;
		SelectRowRowData.Spec=row.Spec;
		
		setTimeout(function(){
			InciInfoGrid.refreshRow();
			InciInfoGrid.startEditingNext('InciDesc');
		},0);
	}	
	var InciInfoCm = [[{
				title: 'RowId',
				field: 'RowId',
				align: 'left',
				width:100,
				hidden: true
			},{
				title: 'Inci',
				field: 'Inci',
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
				width:200,
				editor:InciEditor(HandlerParams,SelectRow),
				sortable: true
			}, {
				title: '规格',
				field: 'Spec',
				width:100,
				align: 'left'
			}, {
				title: '数量',
				field: 'LinkQty',
				width:100,
				editor:{
					type:'numberbox',
					options:{
						required:true
					}
				},
				align: 'right'
			}, {
				title: '入库单位Id',
				field: 'UomId',
				width:100,
				hidden: true,
				align: 'left'
			}, {
				title: '入库单位',
				field: 'UomDesc',
				width:100,
				align: 'left'
			}
		]];

	var InciInfoGrid = $UI.datagrid('#InciGrid', {
			queryParams: {
				ClassName: "web.DHCSTMHUI.InciLinkTar",
				QueryName: "GetLinkData"
			},
			deleteRowParams:{
				ClassName:'web.DHCSTMHUI.InciLinkTar',
				MethodName:'Delete'
			},
			columns: InciInfoCm,
			//fitColumns: true,
			showBar:true,
			showAddDelItems:true,
			singleSelect: true,
			toolbar:[{
				text: '保存',
				iconCls: 'icon-save',
				handler: function () {
					Save();
			}}],
			onClickCell: function(index, filed ,value){	
				InciInfoGrid.commonClickCell(index,filed,value);
			},
			beforeAddFn:function(){
				var SelectRow=TarInfoGrid.getSelected();
				if(isEmpty(SelectRow)){
					$UI.msg("alert","请先选择收费项!");	
					return false;
				}
			}
		});
	function Save(){
		var SelectRow=TarInfoGrid.getSelected();
		if(isEmpty(SelectRow)){
			$UI.msg("alert","请先选择收费项!");	
			return false;
		}
		var Detail=InciInfoGrid.getChangesData('Inci');
		if (Detail === false){	//未完成编辑或明细为空
			return;
		}
		if (isEmpty(Detail)){	//明细不变
			$UI.msg("alert", "没有需要保存的明细!");
			return;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.InciLinkTar',
			MethodName: 'Save',
			Tariff: SelectRow.RowId,
			ListData: JSON.stringify(Detail)
		},function(jsonData){
			hideMask();
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				InciInfoGrid.commonReload();
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	}
	function Clear() {
		$UI.clearBlock('Conditions');
		$UI.clear(TarInfoGrid);
		$UI.clear(InciInfoGrid);
		InitHosp();
	}
	Clear();
}
$(init);