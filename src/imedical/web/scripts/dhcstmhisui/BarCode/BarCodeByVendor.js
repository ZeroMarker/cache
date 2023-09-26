
var init = function(){

	var Clear = function(){
		$UI.clearBlock('#Conditions');
		$UI.clear(BarCodeGrid);
		var Dafult = {
			StartDate: DateFormatter(new Date()),
			EndDate: DateFormatter(new Date())
		};
		$UI.fillBlock('#Conditions', Dafult);
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function(){
			Clear();
		}
	});	
	$UI.linkbutton('#QueryBT', {
		onClick: function(){
			Query();
		}
	});
	function Query(){
		$UI.clear(BarCodeGrid);
		var ParamsObj = $UI.loopBlock('#Conditions');
		var Params = JSON.stringify(ParamsObj);
		BarCodeGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'queryRegHVs',
			Params: Params,
			rows: 99999
		});
	}
	
	$UI.linkbutton('#SaveBT', {
		onClick: function(){
			SaveBarCode();
		}
	});
	function SaveBarCode(){
		var MainObj = $UI.loopBlock('#Conditions');
		var Main = JSON.stringify(MainObj);
		var Detail = BarCodeGrid.getChangesData('InciId');
		if (Detail === false){	//δ��ɱ༭����ϸΪ��
			return;
		}
		if (isEmpty(Detail)){	//��ϸ����
			$UI.msg("alert", "û����Ҫ�������ϸ!");
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			MethodName: 'RegHV',
			MainInfo: Main,
			ListDetail: JSON.stringify(Detail)
		},function(jsonData){
			if(jsonData.success === 0){
				$UI.msg('success', jsonData.msg);
				Query();
			}else{
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	$HUI.combobox('#ReqLocId',{
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({Type:'All'})),
		valueField: 'RowId',
		textField: 'Description'
	});	
	$HUI.combobox('#RecLocId',{
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({Type:'All'})),
		valueField: 'RowId',
		textField: 'Description'
	});	
	$HUI.combobox('#RecLoc',{
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({Type:'Login'})),
		valueField: 'RowId',
		textField: 'Description'
	});
	$('#RecLoc').combobox('setValue', session['LOGON.CTLOCID']);
	
	var VirtualFlag = $HUI.checkbox('#VirtualFlag',{
		onCheckChange: function(e, value){
			if(value){
				var RecLoc = $('#RecLoc').combobox('getValue');
				var Info = tkMakeServerCall('web.DHCSTMHUI.Common.UtilCommon','GetMainLoc',RecLoc);
				var InfoArr = Info.split('^');
				var VituralLoc = InfoArr[0], VituralLocDesc = InfoArr[1];
				AddComboData($('#RecLoc'), VituralLoc, VituralLocDesc);
				$('#RecLoc').combobox('setValue', VituralLoc);
			}else{
				$('#RecLoc').combobox('setValue', gLocId);
			}
		}
	});
	
	var VendorParams = JSON.stringify(addSessionParams({APCType:'M',RcFlag:'Y'}));
	$HUI.combobox('#ApcvmDr', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$HUI.combobox('#FVendorBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var SourceOfFundParams=JSON.stringify(addSessionParams());
	var SourceOfFundBox = $HUI.combobox('#SourceOfFund', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSourceOfFund&ResultSetType=array&Params='+SourceOfFundParams,
			valueField: 'RowId',
			textField: 'Description'
	});	
	var HandlerParams=function(){
		var Scg=$("#ScgId").combotree('getValue');
		var LocDr=$("#RecLocId").combo('getValue');
		var ReqLoc=$("#ReqLocId").combo('getValue');
		var HV = 'Y';
		var QtyFlag ='0';
		var Obj={StkGrpRowId:Scg,StkGrpType:"M",Locdr:LocDr,NotUseFlag:"N",QtyFlag:QtyFlag,HV:HV,RequestNoStock:"Y"};
		return Obj;
	};
	$("#InciDesc").lookup(InciLookUpOp(HandlerParams,'#InciDesc','#Inci'));
	$UI.linkbutton('#SaveImpBT', {
		onClick: function(){
			SaveImp();
		}
	});
	
	function SaveImp() {
		var MainObj = $UI.loopBlock('#ImpConditions');
		if(isEmpty(MainObj['RecLoc'])){
			$UI.msg('alert', '���Ҳ���Ϊ��!');
			return;
		}
		if(isEmpty(MainObj['ApcvmDr'])){
			$UI.msg('alert', '��Ӧ�̲���Ϊ��!');
			return;
		}
		var Main = JSON.stringify(MainObj);
		
		var Rows = BarCodeGrid.getRows();
		if(isEmpty(Rows)){
			$UI.msg('alert', '��ѡ����Ҫ������ϸ!');
			return;
		}
		var DetailArr = [];
		for(var i = 0, Len = Rows.length; i < Len; i++){
			var Row = Rows[i];
			var Ingri = Row['Ingri'];
			if(!isEmpty(Ingri)){
				continue;	//�Ѿ�����,����
			}
			var ItmTrackId = Row['RowId'];
			if(isEmpty(ItmTrackId)){
				$UI.msg('error', '��' + (i+1) + '������δע��!');
				return;
			}
			var InciId = Row['InciId'], IngrUomId = Row['BUomId'], RecQty = Row['Qty'], BarCode = Row['BarCode'],
				SpecDesc = Row['SpecDesc'], BatchNo = Row['BatchNo'], ExpDate = Row['ExpDate'], ManfId = Row['ManfId'],
				Rp = Row['Rp'], Sp = Row['Sp'], CertNo = Row['CertNo'], CertExpDate = Row['CertExpDate'];
			if(isEmpty(InciId)){
				continue;
			}
			var IngriData = {RowId: '', IncId: InciId, IngrUomId: IngrUomId, RecQty: RecQty, HVBarCode: BarCode,
				SpecDesc: SpecDesc, BatchNo: BatchNo, ExpDate: ExpDate, ManfId: ManfId,
				Rp: Rp, Sp: Sp, CertNo: CertNo, CertExpDate: CertExpDate
			};
			DetailArr.push(IngriData);
		}
		var Detail = JSON.stringify(DetailArr);
		if(Detail === false){
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			MethodName: 'jsSave',
			MainInfo: Main,
			ListData: Detail
		}, function(jsonData){
			if(jsonData.success === 0){
				$UI.msg('success', jsonData.msg);
				var IngrId = jsonData.rowid;
				$UI.clear(BarCodeGrid);
				var UrlStr = 'dhcstmhui.ingdrechv.csp?RowId=' + IngrId;
				Common_AddTab('��ֵ���', UrlStr);
			}else{
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	var BarCodeGridCm = [[{
			title: 'RowId',
			field: 'InctrackId',
			width: 50,
			hidden: true
		}, {
			title: 'InciId',
			field: 'InciId',
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 120,
			align: 'left',
			sortable: true
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 200,
			align: 'left',
			sortable: true
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '����',
			field: 'Qty',
			width: 80,
			align: 'right'
		}, {
			title: '��ֵ����',
			field: 'BarCode',
			width: 220,
			align: 'left',
			sortable: false,
			editor: {
				type: 'validatebox',
				options: {
					required: true
				}
			}
		}, {
			title: '��Ӧ��id',
			field: 'VendorId',
			width: 50,
			hidden: true
		}, {
			title: '��Ӧ��',
			field: 'VendorDesc',
			width: 150
		}, {
			title: '�Դ�����',
			field: 'OriginalCode',
			width: 150,
			align: 'left',
			sortable: false
		},{
			title: 'Ʒ��',
			field: 'Brand',
			width: 80,
			hidden: true
		},{
			title: '����',
			field: 'Rp',
			width: 60,
			align: 'right',
			sortable: true,
			editor: {
				type: 'numberbox',
				options: {
					required: true
				}
			}
		},{
			title: '����',
			field: 'BatchNo',
			width: 90,
			align: 'center',
			sortable: true
		}, {
			title: '��Ч��',
			field: 'ExpDate',
			width: 100,
			align: 'center',
			sortable: true
		},{
			title: '��ǰ�ۼ�',
			field: 'Sp',
			width: 80,
			align: 'right'
		},{
			title: '�б����',
			field: 'PbRp',
			width: 100
		},{
			title: '�ӳ���',
			field: 'MarginNow',
			width: 80,
			align: 'right'
		},{
			title: '������',
			field: 'SpecDesc',
			width: 100,
			align: 'left',
			sortable: true
		},{
			title: 'ע��֤��',
			field: 'CertNo',
			width: 150
		},{
			title: 'ע��֤Ч��',
			field: 'CertExpDate',
			width: 100
		}, {
			title: '��������',
			field: 'ProduceDate',
			width: 100,
			align: 'center',
			sortable: true
		}, {
			title: '��ⵥλ',
			field: 'PurUomId',
			width: 80,
			align: 'left',
			sortable: true,
			hidden:true
		}, {
			title: '������λ',
			field: 'BUomId',
			width: 80,
			align: 'left',
			sortable: true,
			hidden: true
		}, {
			title: '����ӱ�id',
			field: 'Ingri',
			width: 80,
			align: 'left',
			sortable: true,
			hidden: true
		}, {
			title: '����',
			field: 'ManfId',
			width: 100,
			hidden: true
		}, {
			title: '����',
			field: 'Manf',
			width: 100
		}, {
			title: 'ע����Ա',
			field: 'User',
			width: 100
		}, {
			title: 'ע������',
			field: 'Date',
			width: 100
		}
	]];

	var BarCodeGrid = $UI.datagrid('#BarCodeGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'queryRegHVs',
			rows: 99999
		},
		deleteRowParams: {
			ClassName:'web.DHCSTMHUI.DHCItmTrack',
			MethodName:'DeleteLabel'
		},
		columns: BarCodeGridCm,
		showBar: true,
		showAddDelItems: true,
		pagination: false,
		onClickCell: function(index, field, value){
			BarCodeGrid.commonClickCell(index, field);
		},
		onBeforeCellEdit: function(index, field){
			var RowId = BarCodeGrid.getRows()[index]['RowId'];
			if(field == 'BarCode' && !isEmpty(RowId)){
				return false;
			}
		},
		onBeginEdit: function(index, row){
			//����������������������
			$('#BarCodeGrid').datagrid('beginEdit', index);
			var ed = $('#BarCodeGrid').datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++){
				var e = ed[i];
				if(e.field == 'BarCode'){
					$(e.target).bind('keydown', function(event){
						if(event.keyCode == 13){
							var BarCode = $(this).val();
							if(isEmpty(BarCode)){
								return false;
							}
							var BarCodeArr = BarCode.split('-');
							var SerialNo = BarCodeArr[BarCodeArr.length - 1];
							if(SerialNo.length < 10){
								//��ˮ��Ϊyymmdd0001(������+4λ), ����Ϊ10
								$UI.msg('alert', '��ˮ�ų��Ȳ���, ���ʵ¼���Ƿ���ȷ!');
								BarCodeGrid.stopJump();
								return false;
							}
							
							var BarCodeInfo = $.cm({
								ClassName: 'web.DHCSTMHUI.DHCItmTrack',
								MethodName: 'GetItmInfoByBarCode',
								BarCode: BarCode
							},false);
							if(BarCodeInfo.success &&  BarCodeInfo.success < 0){
								$UI.msg('error', '�����ȡ����:' + BarCodeInfo.msg);
								BarCodeGrid.stopJump();
								return;
							}
							var InciId = BarCodeInfo['InciId'], VendorId = BarCodeInfo['VendorId'], VendorDesc = BarCodeInfo['VendorDesc'];
							var ExpDate = BarCodeInfo['ExpDate'], ScgId = BarCodeInfo['ScgId'], ScgDesc = BarCodeInfo['ScgDesc'], BatchNo = BarCodeInfo['BatchNo'], SpecDesc = BarCodeInfo['SpecDesc'];
							
							var ImpVendor = $('#ApcvmDr').combobox('getValue');
							if(!isEmpty(ImpVendor) && (VendorId != ImpVendor)){
								$UI.msg('alert', '�����빩Ӧ�̺���⹩Ӧ�̲�һ��!');
								//�����Ƿ����ϸ����,�ٿ���
								BarCodeGrid.stopJump();
								return false;
							}
//							var StkGrpType = Ext.getCmp('StkGrpType').getValue();
//							if(!Ext.isEmpty(StkGrpType) && (Scg != StkGrpType)){
//								var count = BarCodeGrid.getStore().getCount();
//								if(count == 1){
//									addComboData('', Scg, ScgDesc, Ext.getCmp('StkGrpType'));
//									Ext.getCmp('StkGrpType').setValue(Scg);
//								}else{
//									Msg.info('warning', '�����������������鲻��!');
//									return false;
//								}
//							}
							
							BarCodeGrid.updateRow({
								index: index,
								row: {
									InciId: InciId,
									BarCode: BarCode,
									VendorId: VendorId,
									VendorDesc: VendorDesc,
									ExpDate: ExpDate,
									BatchNo: BatchNo,
									SpecDesc: SpecDesc,
									VendorId: VendorId,
									VendorDesc: VendorDesc
								}
							});
						//	addComboData(SpecDescStore, SpecDesc, SpecDesc);
							$('#ApcvmDr').combobox('setValue', VendorId);
							//Ϊrecord set�����ֶ���Ϣ
							GetMatDetail(InciId, index);
//							addComboData(Ext.getCmp('ImpVendor').getStore(), VendorId, VendorDesc);
						}
					});
				}
			}
		}
	});
	
	/**
	 * ����inci_rowid��ȡ����,������ϸ��Ϣ
	 * @param {�����rowid} InciId
	 * @param {������} RowIndex
	 */
	function GetMatDetail(InciId, RowIndex) {
		var Params = JSON.stringify(addSessionParams());
		var InciInfo = $.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			MethodName: 'GetItmInfo',
			IncId: InciId,
			Params: Params
		}, false);
		if(isEmpty(InciInfo) || isEmpty(InciInfo['InciCode'])){
			$UI.msg('error', '������Ϣ��ȡ����!');
			return false;
		}
		var InciCode = InciInfo['InciCode'], InciDesc = InciInfo['InciDesc'], Spec = InciInfo['Spec'],
			BUomId = InciInfo['BUomId'], PurUomId = InciInfo['PurUomId'],
			ManfId = InciInfo['ManfId'], ManfDesc = InciInfo['ManfDesc'],
			CertNo = InciInfo['CertNo'], CertExpDate = InciInfo['CertExpDate'],
			BSp = Number(InciInfo['BSp']), BRp = Number(InciInfo['BRp']);
		var MarginNow = '';
		if(BRp > 0){
			MarginNow = accDiv(BSp, BRp);
		}
		BarCodeGrid.updateRow({
			index: RowIndex,
			row: {
				InciCode: InciCode,
				InciDesc: InciDesc,
				Spec: Spec,
				Qty: 1,
				BUomId: BUomId,
				PurUomId: PurUomId,
				ManfId: ManfId,
				ManfDesc: ManfDesc,
				Rp: BRp,
				Sp: BSp
			}
		});
	}
	
	Clear();
	
}
$(init);
