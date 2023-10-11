/*
����ƽ̨�������(��ֵ������ģʽ)
*/
var ImpByECSPoHVFN=function(Fn){
	$HUI.dialog('#ImportBySCIPoWin',{
		width: gWinWidth,
		height: gWinHeight,
		onOpen: function(){
			SCIPoIngrClear();
		}
	}).open();
	$UI.linkbutton('#SCIPoQueryBT',{
		onClick:function(){
			QuerySCIPoIngrInfo();
		}
	});
	$UI.linkbutton('#SCIPoClearBT',{
		onClick:function(){
			SCIPoIngrClear();
		}
	});
	$UI.linkbutton('#SCIRegBarCodeBT',{
		onClick: function(){
			SCIRegBarCode();
		}
	});
	function SCIRegBarCode(){
		var MainObj = {};
		var SCIPoLocId = $HUI.combobox('#SCIPoLoc').getValue();
		MainObj['InGdRecLocId'] = SCIPoLocId;
		MainObj['RecLocId'] = gLocId;			//ע�����
		
		var VendorId = $HUI.combobox('#SCIPoVendor').getValue();
		var RowsData = IngrSCIPoDetailGrid.getRows();
		var BatchCodeArr = [];
		for (var i = 0, Len = RowsData.length; i < Len; i++) {
			var Row = RowsData[i];
			var DHCITID = Row['DHCITID'];
			if(!isEmpty(DHCITID)){
				continue;
			}
			var CodeObj = {};
			CodeObj['BatchCodeFlag'] = Row['BatchCodeFlag'];//'Y';
			CodeObj['BatchCode'] = Row['BatchCode'];
			CodeObj['OrderDetailSubId'] = Row['OrderDetailSubId'];
			CodeObj['BarCode'] = Row['BatchCode'];
			CodeObj['InciId'] = Row['IncId'];
			CodeObj['Qty'] = Row['AvaBarcodeQty'];
			CodeObj['Inpoi'] = Row['PoItmId'];
			CodeObj['BatchNo'] = Row['BatchNo'];
			CodeObj['ExpDate'] = Row['ExpDate'];
			//CodeObj['SpecDesc'] = '';
			CodeObj['ProduceDate'] = Row['ProduceDate'];
			CodeObj['CertNo'] = Row['CerNo'];
			CodeObj['CertExpDate'] = Row['CerExpDate'];
			CodeObj['Rp'] = Row['Rp'];
			CodeObj['ManfId'] = Row['ManfId'];
			CodeObj['VendorId'] = VendorId;
			CodeObj['OldOriginalCode'] = Row['OriginalCode'];		//�Դ�����(��Ψһ)
			
			BatchCodeArr.unshift(CodeObj);
		}
		if(BatchCodeArr.length == 0){
			$UI.msg('alert', 'û����ע�������!');
			return;
		}
		
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			MethodName: 'jsRegHV',
			MainInfo: JSON.stringify(addSessionParams(MainObj)),
			ListDetail: JSON.stringify(BatchCodeArr)
		}, function (jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				RowIdStr = jsonData.rowid;
				//���¼�������
				var ParamsObj = $UI.loopBlock('#SCIPoConditions');
				var SCINo = ParamsObj['SCINo'];
				$.cm({
					ClassName: 'web.DHCSTMHUI.ServiceForECS',
					MethodName: 'getOrderDetail',
					SxNo: SCINo,
					HVFlag: 'Y',
					HospId:gHospId
				}, function(jsonData){
					if(jsonData['Main']==undefined){
						return;
					}
					if(jsonData.hasOwnProperty('Main') && jsonData.hasOwnProperty('Detail')){
						$UI.fillBlock('#SCIPoConditions',jsonData['Main']);
						IngrSCIPoDetailGrid.loadData(jsonData['Detail']);
					}
				});
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#SCIPoSaveBT',{
		onClick:function(){
			if(CheckDataBeforeSave()){
				SCIPoIngrSave();
			}
		}
	});
	
	var SCIPoReqLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	$HUI.combobox('#SCIPoReqLoc', {
		valueField: 'RowId',
		textField: 'Description'
	});
	var SCIPoVendorParams=JSON.stringify(addSessionParams({APCType:"M"}));
	var SCIPoVendorBox = $HUI.combobox('#SCIPoVendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+SCIPoVendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var SCIPoLocParams=JSON.stringify(addSessionParams({Type:"Login"}));
	var SCIPoLocBox = $HUI.combobox('#SCIPoLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+SCIPoLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var IngrSCIPoDetailGridCm = [[
		{
			field: 'check',
			checkbox: true
		},{
			title : "RowId",
			field : 'PoItmId',
			width : 50,
			alias :'Inpoi',
			hidden : true
		},{
			title : '�Դ���ID',
			field : 'DHCITID',
			width : 80,
			hidden : true
		}, {
			title : "IncId",
			field : 'IncId',
			width : 50,
			hidden : true
		},{
			title : "���ʴ���",
			field : 'IncCode',
			width : 100
		},{
			title : "��������",
			field : 'IncDesc',
			width : 150
		},{
			title : "���",
			field : 'Spec',
			width : 100
		},/*{
			title : "������",
			field : 'SpecDesc',
			width : 100
		},*/{
			title : "��ֵ����",
			field : 'BarCode',
			width : 200,
			alias : 'HVBarCode'
		}, {
			title : "������",
			field : 'BatchCode',
			width : 200
		}, {
			title : "�Դ���",
			field : 'OriginalCode',
			width : 200
		},{
			title : "����",
			field : 'AvaBarcodeQty',
			width : 80,
			align : 'right',
			alias : 'RecQty'
		},{
			title : "PurUomId",
			field : 'PurUomId',
			width : 100,
			hidden : true,
			alias : 'IngrUomId'
		},{
			title : "��λ",
			field : 'PurUom',
			width : 60
		},{
			title : "����",
			field : 'Rp',
			width : 80,
			align : 'right'
		},{
			title : "��������",
			field : 'Manf',
			width : 100
		},{
			title : "ManfId",
			field : 'ManfId',
			width : 100,
			hidden : true
		},{
			title : "�ۼ�",
			field : 'Sp',
			width : 100,
			align : 'right'
		},{
			title : "����",
			field : 'BatchNo',
			width : 80
		},{
			title : "��Ч��",
			field : 'ExpDate',
			width : 80
		},{
			title : "��������",
			field : 'ProduceDate',
			width : 90
		},{
			title : "������λ",
			field : 'BUomId',
			width : 50,
			hidden : true
		},{
			title : "ת����",
			field : 'ConFac',
			width : 100,
			alias : 'ConFacPur',
			hidden : true
		},{
			title : "��������",
			field : 'PurQty',
			width : 100,
			align : 'right'
		},{
			title : "���������",
			field : 'ImpQty',
			width : 100,
			align : 'right'
		},{
			title : "����Ҫ��",
			field : 'BatchReq',
			width : 50,
			hidden : true
		},{
			title : "��Ч��Ҫ��",
			field : 'ExpReq',
			width : 50,
			hidden : true
		},{
			title : "ע��֤��",
			field : 'CerNo',
			width : 90
		},{
			title : "ע��֤��Ч��",
			field : 'CerExpDate',
			width : 100
		},{
			title : "��ֵ��־",
			field : 'HighValueFlag', 
			width : 100,
			alias : 'HVFlag',
			formatter : BoolFormatter,
			align : 'center'
		},{
			title : 'SCI������Id',
			field : 'OrderDetailSubId',
			hidden : true,
			width : 100
		},{
			title : "�������־",
			field : 'BatchCodeFlag',
			width : 90,
			align : 'center'
		}
	]];
	var IngrSCIPoDetailGrid = $UI.datagrid('#IngrSCIPoDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.ServiceForECS',
			QueryName: 'getOrderDetail'
		},
		columns: IngrSCIPoDetailGridCm,
		showBar:true,
		singleSelect:false,
		remoteSort: false,
		pagination: false,
		onLoadSuccess: function(data){
			$.each(data.rows, function(index, row){
				var ColorField = 'BatchCode';
				var DHCITID = row['DHCITID'];
				//����δע���,Ⱦɫ���
				if(isEmpty(DHCITID)){
					var Color = '#FD930C';
					SetGridBgColor(IngrSCIPoDetailGrid, index, 'BatchCode', Color, ColorField);
				}
			});
		}
	});
	function QuerySCIPoIngrInfo() {
		var ParamsObj=$UI.loopBlock('#SCIPoSearchConditions');
		if(isEmpty(ParamsObj['PoSXNo'])){
			$UI.msg('alert','���е��Ų���Ϊ��!');
			return false;
		}
		SCIPoIngrClear();
		$.cm({
			ClassName: 'web.DHCSTMHUI.ServiceForECS',
			MethodName: 'getOrderDetail',
			SxNo: ParamsObj['PoSXNo'],
			HVFlag: 'Y',
			HospId:gHospId
		}, function(jsonData){
			if(jsonData['Main']==undefined){
				$UI.msg('alert', 'δ�ҵ������е�,��ȷ���Ƿ��Ǹ�ֵ����!');
				return;
			}
			if(jsonData.hasOwnProperty('Main') && jsonData.hasOwnProperty('Detail')){
				$UI.fillBlock('#SCIPoConditions',jsonData['Main']);
				IngrSCIPoDetailGrid.loadData(jsonData['Detail']);
			}else{
				$UI.msg('alert', '�õ����Ѵ���!');
			}
		});
	}
	function CheckDataBeforeSave() {
		var RowsData=IngrSCIPoDetailGrid.getRows();
		// ��Ч����
		var count = 0;
		for (var i = 0; i < RowsData.length; i++) {
			var item = RowsData[i].IncId;
			if (!isEmpty(item)) {
				count++;
			}
		}
		if (RowsData.length <= 0 || count <= 0) {
			$UI.msg('alert','����ϸ����!');
			return false;
		}
		return true;
	}
	function SCIPoIngrSave() {
		var ParamsObj=$UI.loopBlock('#SCIPoConditions');
		var RecLoc=ParamsObj['SCIPoLoc'];
		//var PoId = ParamsObj.PoId;
		//var HVflag=GetCertDocHVFlag(PoId,"PO");
//		if(HVflag=="Y"){
//			$UI.msg('alert','�˶���Ϊ��ֵ����,��ȥ��ֵ����������浼�붩��!');
//			return false;
//		}
		var Vendor = ParamsObj.SCIPoVendor;
		var Main=JSON.stringify(addSessionParams({RecLoc:RecLoc,ApcvmDr:Vendor}));
		
		var Sels = IngrSCIPoDetailGrid.getSelections();
		var CheckRowIndexArr = [];
		for(var i = 0, Len = Sels.length; i < Len; i++){
			var Row = Sels[i];
			var RowIndex = IngrSCIPoDetailGrid.getRowIndex(Row);
			if(isEmpty(Row['DHCITID'])){
				CheckRowIndexArr.push(RowIndex + 1);
				IngrSCIPoDetailGrid.unselectRow(RowIndex);
			}
		}
		if(!isEmpty(CheckRowIndexArr)){
			var RowIndexStr = CheckRowIndexArr.join();
			$UI.msg('alert', '��' + RowIndexStr +'��,����ǰ���Ƚ�������ע��!');
			return;
		}
		
		var DetailObj = IngrSCIPoDetailGrid.getSelectedData();
		if (DetailObj.length==0){
			$UI.msg('alert','����ϸ!');
			return false;
		}
		var Detail=JSON.stringify(DetailObj);
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			MethodName: 'jsSave',
			MainInfo: Main,
			ListData: Detail
		},function(jsonData){
			if(jsonData.success === 0){
				$UI.msg('success', jsonData.msg);
				var IngrRowid=jsonData.rowid;
				$HUI.dialog('#ImportBySCIPoWin').close();
				if(IngrParamObj.AutoPrintAfterSave=="Y"){
					PrintRec(IngrRowid,"Y");
				}
				Fn(IngrRowid);
			}else{
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	function SCIPoIngrClear() {
		$UI.clearBlock('#SCIPoSearchConditions');
		$UI.clearBlock('#SCIPoConditions');
		$UI.clear(IngrSCIPoDetailGrid);
	}
	SCIPoIngrClear();
}