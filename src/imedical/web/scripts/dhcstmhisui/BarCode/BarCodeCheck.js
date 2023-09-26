
var init = function(){
	var RowIdStr = "";
	
	var Clear = function(){
		$UI.clearBlock('#Conditions');
		$UI.clear(BarCodeGrid);
		var Dafult = {
			OriginalStatus: 'Temp',
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
	$UI.linkbutton('#DownExcelTemplet', {
		onClick: function () {
			ExportExcel();
		}
	});
	function ExportExcel() {
		window.open("../scripts/dhcstmhisui/BarCode/跟台高值耗材信息导入模板.xlsx", "_blank");
	}
	function Query(){
		$UI.clear(BarCodeGrid);
		var ParamsObj = $UI.loopBlock('#Conditions');
		ParamsObj.RowIdStr = RowIdStr;
		var Params = JSON.stringify(ParamsObj);
		BarCodeGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'queryRegHVs',
			Params: Params
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
		//var Detail = BarCodeGrid.getChangesData('InciId');
		var Detail = BarCodeGrid.getRowsData();
		if (Detail === false){
			return;
		}
		if (isEmpty(Detail)){
			$UI.msg("alert", "没有需要保存的明细!");
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
				RowIdStr = jsonData.rowid;
				Query();
			}else{
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	$('#File').filebox({
		buttonAlign: 'left',
		prompt: '请选择要导入的Excel',
		accept: 'application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
	});
	$UI.linkbutton('#ReadBT', {
		onClick: function () {
//			$('#StkGrpId').combobox('clear');
			var VendorId = $HUI.combobox('#ApcvmDr').getValue();
			if(isEmpty(VendorId)){
				$UI.msg('alert', '请选择供应商!');
				return;
			}
			ImportExcelFN();
		}
	});
	function ImportExcelFN() {
		var filelist = $('#File').filebox("files");
		if (filelist.length == 0) {
			$UI.msg('alert', '请选择要导入的Excel!')
			return
		}
		showMask();
		var file = filelist[0];
		var reader = new FileReader();
		reader.onload = function (e) {
			if (reader.result) {
				reader.content = reader.result;
			}
			var data = e ? e.target.result : reader.content;
			var workbook = XLSX.read(data, {
				type: 'binary'
			});
			var ImportArrAll = XLSX.utils.sheet_to_json(workbook.Sheets[workbook.SheetNames[0]]);
			var ImportArr = ImportArrAll.slice(1).reverse();
			var ImportParams = JSON.stringify(ImportArr);
			var ParamsObj = $UI.loopBlock('#MainConditions');
			var VendorId = $HUI.combobox('#ApcvmDr').getValue();
			var ParamsObj = {VendorId : VendorId};
			var Params = JSON.stringify(addSessionParams(ParamsObj));
			var jsonData = $.cm({
				wantreturnval: 0,
				ClassName: 'web.DHCSTMHUI.BarCodeCheck',
				MethodName: 'GetJsonByImport',
				ImportParams: ImportParams,
				Params: Params
			}, false);
			
			$("#BarCodeGrid").datagrid("loadData", jsonData);
			hideMask();
		}
		reader.readAsBinaryString(file);
	}
	
	/*
	$HUI.combobox('#RecLocId',{
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({Type:'All'})),
		valueField: 'RowId',
		textField: 'Description'
	});
	*/
	
	var VendorParams = JSON.stringify(addSessionParams({APCType:'M',RcFlag:'Y'}));
	$HUI.combobox('#ApcvmDr', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$HUI.combobox('#VendorId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
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
			title: '物资代码',
			field: 'InciCode',
			width: 120,
			align: 'left',
//			renderer: Ext.util.Format.InciPicRenderer('IncId'),
			sortable: true
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 200,
			align: 'left',
			sortable: true
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '数量',
			field: 'Qty',
			width: 80,
			align: 'right'
		}, {
			title: '高值条码',
			field: 'BarCode',
			width: 220,
			align: 'left',
			sortable: false
		}, {
			title: '供应商id',
			field: 'VendorId',
			width: 50,
			hidden: true
		}, {
			title: '供应商',
			field: 'VendorDesc',
			width: 150
		}, {
			title: '自带条码',
			field: 'OriginalCode',
			width: 150,
			align: 'left',
			sortable: false,
			editor: {
				type: 'text'
			}
		}, {
			title: '批次码',
			field: 'BatchCode',
			width: 120,
			align: 'left',
			sortable: true,
			editor: {
				type: 'text'
			}
		},{
			title: '品牌',
			field: 'Brand',
			width: 80,
			hidden: true
		},{
			title: '进价',
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
			title: '批号',
			field: 'BatchNo',
			width: 90,
			align: 'center',
			sortable: true,
			editor: {
				type: 'text'
			}
		}, {
			title: '有效期',
			field: 'ExpDate',
			width: 100,
			align: 'center',
			sortable: true,
			editor: {
				type: 'datebox'
			}
		},{
			title: '当前售价',
			field: 'Sp',
			width: 80,
			align: 'right'
		},{
			title: '招标进价',
			field: 'PbRp',
			width: 100
		},{
			title: '加成率',
			field: 'MarginNow',
			width: 80,
			align: 'right'
		},{
			title: '具体规格',
			field: 'SpecDesc',
			width: 100,
			align: 'left',
			sortable: true
		},{
			title: '注册证号',
			field: 'CertNo',
			width: 150
		},{
			title: '注册证效期',
			field: 'CertExpDate',
			width: 100
		}, {
			title: '生产日期',
			field: 'ProduceDate',
			width: 100,
			align: 'center',
			sortable: true
		}, {
			title: '入库单位',
			field: 'PurUomId',
			width: 80,
			align: 'left',
			sortable: true,
			hidden:true
		}, {
			title: '基本单位',
			field: 'BUomId',
			width: 80,
			align: 'left',
			sortable: true,
			hidden: true
		}, {
			title: '入库子表id',
			field: 'Ingri',
			width: 80,
			align: 'left',
			sortable: true,
			hidden: true
		}, {
			title: '厂商',
			field: 'ManfId',
			width: 100,
			hidden: true
		}, {
			title: '厂商',
			field: 'Manf',
			width: 100
		}, {
			title: '注册人员',
			field: 'User',
			width: 100
		}, {
			title: '注册日期',
			field: 'Date',
			width: 100
		}, {
			title: '条码类型',
			field: 'Stauts',
			width: 100,
			hidden: true
		}
	]];

	var BarCodeGrid = $UI.datagrid('#BarCodeGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'queryRegHVs'
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
		}
	});
	
	/**
	 * 根据inci_rowid获取厂商,规格等明细信息
	 * @param {库存项rowid} InciId
	 * @param {行索引} RowIndex
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
			$UI.msg('error', '条码信息获取错误!');
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
if (!FileReader.prototype.readAsBinaryString) {
	console.log('readAsBinaryString definition not found');
	FileReader.prototype.readAsBinaryString = function (fileData) {
		var binary = '';
		var pk = this;
		var reader = new FileReader();
		reader.onload = function (e) {
			var bytes = new Uint8Array(reader.result);
			var length = bytes.byteLength;
			for (var i = 0; i < length; i++) {
				var a = bytes[i];
				var b = String.fromCharCode(a)
				binary += b;
			}
			pk.content = binary;
			$(pk).trigger('onload');
		}
		reader.readAsArrayBuffer(fileData);
	}
}
