/* 高值生成条码(紧急业务)*/
var init = function() {
	var RowIdStr = "";
	function GetParamsObj(Condition){
		var ParamsObj=$CommonUI.loopBlock(Condition);
		return ParamsObj;
	}
	var Clear=function(){
		RowIdStr = "";
		$UI.clearBlock('#MainConditions');
		$UI.clearBlock('#IngrConditions');
		$UI.clear(BarCodeGrid);
		$UI.clear(IngrMainGrid);
		$UI.clear(IngrDetailGrid);
		var DefaRecLoc=ItmTrackParamObj.DefaRecLoc;
		var Params=JSON.stringify(addSessionParams());
		var RecLocStr=tkMakeServerCall("web.DHCSTMHUI.Common.UtilCommon","LocToRowID",DefaRecLoc,Params);
		var RecLocObj = {RowId: RecLocStr.split('^')[0], Description: RecLocStr.split('^')[1]};
		///设置初始值 考虑使用配置
		var MainDafult={
			StartDate: TrackDefaultStDate(),
			EndDate: TrackDefaultEdDate()
		};
		var IngrDafult={InGdRecLocId:RecLocObj};
		$UI.fillBlock('#MainConditions',MainDafult);
		$UI.fillBlock('#IngrConditions',IngrDafult);
	}
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Clear();
		}
	});
	
	//打印按钮对应方法
	var PrintBtn = $('#Print').menubutton({menu: '#mm-Print'});
	$(PrintBtn.menubutton('options').menu).menu({
		onClick: function (item) {
			var BtnName = item.name;		//div定义了name属性
			if(BtnName == 'PrintBarCode'){
				var rowsData = BarCodeGrid.getSelections();
				if(rowsData.length<=0){
					return;
				}
				var count=rowsData.length;
				for (var rowIndex = 0; rowIndex < count; rowIndex++) {
					var row = rowsData[rowIndex];
					var BarCode = row.BarCode;
					PrintBarcode(BarCode,1);
				}
			}else if(BtnName == 'PrintBarCode2'){
				var rowsData = BarCodeGrid.getSelections();
				if(rowsData.length<=0){
					return;
				}
				var count=rowsData.length;
				for (var rowIndex = 0; rowIndex < count; rowIndex++) {
					var row = rowsData[rowIndex];
					var BarCode = row.BarCode;
					PrintBarcode(BarCode,2);
				}
			}else if(BtnName == 'PrintPage'){
				var rowsData = BarCodeGrid.getRows();
				if(rowsData.length<=0){
					return;
				}
				var count=rowsData.length;
				for (var rowIndex = 0; rowIndex < count; rowIndex++) {
					var row = rowsData[rowIndex];
					var BarCode = row.BarCode;
					PrintBarcode(BarCode,1);
				}
			}else if(BtnName == 'PrintPage2'){
				var rowsData = BarCodeGrid.getRows();
				if(rowsData.length<=0){
					return;
				}
				var count=rowsData.length;
				for (var rowIndex = 0; rowIndex < count; rowIndex++) {
					var row = rowsData[rowIndex];
					var BarCode = row.BarCode;
					PrintBarcode(BarCode,2);
				}
			}
		}
	});
	
	$UI.linkbutton('#CopyBatNoBT',{ 
		onClick:function(){
			var rows=BarCodeGrid.getRows();
			if(isEmpty(rows)){
				$UI.msg('alert', '没有需要处理的明细,请勾选条码信息中的记录!');
				return false;
			}
			SaveBatExpWin(SaveBatExp);
		}
	});
	
	function SaveBatExp(Params){
		BarCodeGrid.endEditing();
		var FillFlag = $("input[name='Fill']:checked").val();	//1:不覆盖, 2:覆盖已填
		var BatNo=Params.BatNo;
		var ExpDate=Params.ExpDate;
		var Rows=BarCodeGrid.getRows();
		var len=Rows.length;
		var FillCount = 0;
		for (var index = 0; index < len; index++) {
			var RowData = Rows[index];
			if((FillFlag == '1') && !(isEmpty(RowData.BatchNo) && isEmpty(RowData.ExpDate))){
				continue;
			}
			$('#BarCodeGrid').datagrid('endEdit', index);
			$('#BarCodeGrid').datagrid('selectRow', index);
			//$('#BarCodeGrid').datagrid('endEdit', index).datagrid('beginEdit', index);
			
			$('#BarCodeGrid').datagrid('editCell', {index: index, field: 'BatchNo'});
			var ed = $('#BarCodeGrid').datagrid('getEditor', {index: index, field: 'BatchNo'});
			ed.target.val(BatNo);
			
			$('#BarCodeGrid').datagrid('editCell', {index: index, field: 'ExpDate'});
			var ed = $('#BarCodeGrid').datagrid('getEditor', {index: index, field: 'ExpDate'});
			$(ed.target).datebox('setValue', ExpDate);
			
			$('#BarCodeGrid').datagrid('endEdit', index);
			FillCount++;
		}
		if(FillCount > 0){
			$UI.msg('alert', '已填充' + FillCount + '行, 请注意保存!');
		}else{
			$UI.msg('error', '未进行有效填充!');
		}
	}
	
	var VendorParams=JSON.stringify(addSessionParams({APCType:"M",RcFlag:"Y"}));
	var VendorBox = $HUI.combobox('#FVendorBox', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	
	
	function CheckDataBeforeSave() {
		var ParamsObj=GetParamsObj('#IngrConditions');
		var MainParamsObj=GetParamsObj('#MainConditions');
		// 判断入库部门和供货商是否为空
		var InGdReqLocId = ParamsObj.InGdReqLocId;
		if (isEmpty(InGdReqLocId)) {
			$UI.msg('alert','请选择请求科室!');
			return false;
		}
		var vendor = ParamsObj.InGdReqVendor;
		if (isEmpty(vendor)) {
			$UI.msg('alert','请选择供应商!');
			return false;
		}
		if(isEmpty(MainParamsObj.ScgStk)){
			$UI.msg('alert','类组不能为空!');
			return false;
		}
		var AllowFlag=tkMakeServerCall("web.DHCSTMHUI.HVUsePermissonLoc","IfAllowDo",InGdReqLocId,gUserId);
		if(AllowFlag==-1){
			$UI.msg('alert','此接收科室当前时间没有操作高值入库权限!');
			return false;
		}
		if(AllowFlag==-2){
			$UI.msg('alert','当前登陆人员没有操作高值入库权限!');
			return false;
		}
		// 1.判断入库物资是否为空
		var RowsData=BarCodeGrid.getRows();
		// 有效行数
		var count = 0;
		for (var i = 0; i < RowsData.length; i++) {
			var item = RowsData[i].RowId;
			var Ingritmid = RowsData[i].Ingri;
			if ((!isEmpty(item))&&(isEmpty(Ingritmid))) {
				count++;
			}
		}
		if (RowsData.length <= 0 || count <= 0) {
			$UI.msg('alert','没有需要保存的入库明细!');
			return false;
		}
		if (RowsData.length>count) {
			$UI.msg('alert','存在未注册条码不允许入库或者存在已入库条码!');
			return false;
		}
		for (var i = 0; i < RowsData.length;i++) {
			var sp=RowsData[i].Sp;
			var Incidesc=RowsData[i].Desc;
			var row=i+1;
			if (sp<=0){
				$UI.msg('alert','第'+row+'行'+Incidesc+'售价为零或者小于零!');
				//return false;
			}
			var item = RowsData[i].RowId;
		}
		return true;
	}
	function SaveIngr(){
		var Main=JSON.stringify(GetParamsObj('#IngrConditions'));
		var DetailObj=BarCodeGrid.getSelectedData();
		if(DetailObj===false){
			$UI.msg('alert','明细验证不通过无法保存!');
			return false;
		}else if (DetailObj.length==0){
			$UI.msg('alert','无需要保存的明细,请勾选条码信息中的记录!');
			return false;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			MethodName: 'CreateUrgencyIngr',
			MainInfo: Main,
			ListDetail: JSON.stringify(DetailObj)
		},function(jsonData){
			hideMask();
			if(jsonData.success === 0){
				$UI.msg('success', jsonData.msg);
				var IngrRowid=jsonData.rowid;
				$("#HVEurgencytabs").tabs("select", "入库信息");
				IngrMainGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCINGdRec',
					QueryName: 'QueryIngrStr',
					ingrStr: IngrRowid
				});
			}else{
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#SaveInGdRecBT',{ 
		onClick:function(){
			if(CheckDataBeforeSave()==true){
				SaveIngr();
			}
		}
	}); 
	$UI.linkbutton('#PrintHVColBT',{ 
		onClick:function(){
			var Row=IngrMainGrid.getSelected();
			if(isEmpty(Row)){
				$UI.msg('alert', '请选择要打印的入库单!');
				return;
			}
			var IngrId=Row.IngrId;
			PrintRecHVCol(IngrId);
		}
	});  
	
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			Query();
		}
	});
	
	function Query(){
		var ParamsObj=GetParamsObj('#MainConditions');
		if(isEmpty(ParamsObj.StartDate)){
			$UI.msg('alert', '开始日期不能为空!');
			return;
		}
		if(isEmpty(ParamsObj.EndDate)){
			$UI.msg('alert', '截止日期不能为空!');
			return;
		}
		ParamsObj.RowIdStr = RowIdStr;
		var Params=JSON.stringify(ParamsObj);
		BarCodeGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'queryRegHVs',
			Params:Params,
			rows:99999
		});
		RowIdStr = '';
	}
	$UI.linkbutton('#SaveBT',{
		onClick:function(){
			SaveBarCode();
		}
	});
	function SaveBarCode(){
		var MainObj=GetParamsObj('#MainConditions');
		var IngrObj=GetParamsObj('#IngrConditions');
		var Main=JSON.stringify(jQuery.extend(true,MainObj,IngrObj));
		var DetailObj=BarCodeGrid.getChangesData('InciId');
		if (DetailObj === false){	//未完成编辑或明细为空
			return;
		}
		if (isEmpty(DetailObj)){	//明细不变
			$UI.msg("alert", "没有需要保存的明细，请勾选条码信息中的记录!");
			return;
		}
		var Detail=JSON.stringify(DetailObj);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			MethodName: 'RegHV',
			MainInfo: Main,
			ListDetail: Detail
		},function(jsonData){
			hideMask();
			if(jsonData.success === 0){
				$UI.msg('success', jsonData.msg);
				RowIdStr = jsonData.rowid;
				Query();
			}else{
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	var HandlerParams=function(){
		var Scg=$("#ScgStk").combotree('getValue');
		var LocDr=$("#InGdRecLocId").combo('getValue');
		var ReqLoc="";
		var HV = 'Y';
		var QtyFlag ='0';
		var Obj={StkGrpRowId:Scg,StkGrpType:"M",Locdr:LocDr,NotUseFlag:"N",QtyFlag:QtyFlag,HV:HV,RequestNoStock:"Y"};
		return Obj;
	};
	$("#InciDesc").lookup(InciLookUpOp(HandlerParams,'#InciDesc','#Inci'));
	var SelectRow=function(row){
		var InciId=row.InciDr;
		var Params = gGroupId+"^"+gLocId+"^"+gUserId+"^"+gHospId;
		var DefaultBatExp = tkMakeServerCall('web.DHCSTMHUI.DHCINGdRec', 'GetDefaultBatExp', InciId, Params);
		var BatchNo=DefaultBatExp.split('^')[0];
		var ExpDate=DefaultBatExp.split('^')[1];
		BarCodeGrid.updateRow({
			index:BarCodeGrid.editIndex,
			row: {
				InciId: row.InciDr,
				InciCode: row.InciCode,
				InciDesc: row.InciDesc,
				Qty:row.PFac,
				Rp: row.BRp,
				Sp:row.BSp,
				BUomId: row.BUomDr,
				BUom: row.BUomDesc,
				CertNo: row.CertNo,
				CertExpDate: row.CertExpDate,
				ManfId: row.Manfdr,
				BatchNo: row.BatchNo||BatchNo,
				ExpDate: row.ExpDate||ExpDate,
				BarCode:row.OrgBarCode,
				ProduceDate:row.ProduceDate
			}
		});
		setTimeout(function () {
			BarCodeGrid.refreshRow();
			BarCodeGrid.startEditingNext('InciDesc');
		}, 0);
	}
	var PhManufacturerParams=JSON.stringify(addSessionParams({StkType:"M"}));
	var PhManufacturerBox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params='+PhManufacturerParams,
			valueField: 'RowId',
			textField: 'Description',
			onBeforeLoad:function(param){
				
			}
		}
	};
	var RecLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var InGdRecLocIdBox = $HUI.combobox('#InGdRecLocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+RecLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});	
	var RecVendorParams=JSON.stringify(addSessionParams({APCType:"M",RcFlag:"Y"}));
	var RecVendorBox = $HUI.combobox('#InGdReqVendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+RecVendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var ReqLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var ReqLocBox = $HUI.combobox('#InGdReqLocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+ReqLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var SourceOfFundParams=JSON.stringify(addSessionParams());
	var SourceOfFundBox = $HUI.combobox('#Source', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSourceOfFund&ResultSetType=array&Params='+SourceOfFundParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	
	var SpecDescParams=JSON.stringify(sessionObj)
	var SpecDescbox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSpecDesc&ResultSetType=array&Params='+SpecDescParams,
			valueField: 'Description',
			textField: 'Description',
			mode:'remote',
			onBeforeLoad:function(param){
				var Select=BarCodeGrid.getSelected();
				if(!isEmpty(Select)){
					param.Inci = Select.InciId;
				}
			}
		}
	};
	var BarCodeCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '物资RowId',
			field: 'InciId',
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width:150
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 200,
			editor: InciEditor(HandlerParams,SelectRow)
		}, {
			title: '规格',
			field: 'Spec',
			width: 150
		}, {
			title: '数量',
			field: 'Qty',
			width: 40,
			align : 'right',
			editor:{
				type:'numberbox',
				options:{
					required:true
				}
			}
		}, {
			title: '高值条码',
			field: 'BarCode',
			width:200
		}, {
			title: '自带条码',
			field: 'OriginalCode',
			width:200,
			editor:{
				type:'text',
				options:{
				}
			}
		}, {
			title: '进价',
			field: 'Rp',
			width: 60,
			align : 'right',
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					min:0,
					precision:GetFmtNum('FmtRP')
				}
			}
		}, {
			title: '当前售价',
			field: 'Sp',
			width: 60,
			align : 'right'
		}, {
			title: '招标进价',
			field: 'PbRp',
			width: 80,
			align : 'right'
		}, {
			title: 'Inpoi',
			field: 'Inpoi',
			hidden: true,
			width: 100
		}, {
			title: '批号',
			field: 'BatchNo',
			width: 100,
			editor: {
				type: 'text'
			}
		}, {
			title: '效期',
			field: 'ExpDate',
			width: 100,
			editor: {
				type: 'datebox'
			}
		}, {
			title: '基本单位dr',
			field: 'BUomId',
			width: 100,
			hidden: true
		}, {
			title: '入库单位dr',
			field: 'PurUomId',
			width: 100,
			hidden: true
		}, {
			title: '具体规格',
			field: 'SpecDesc',
			width: 100,
			editable : false,
			formatter: CommonFormatter(SpecDescbox,'SpecDesc','SpecDesc'),
			editor: SpecDescbox
		}, {
			title: '生产日期',
			field: 'ProduceDate',
			width:100,
			editor:{
				type: 'datebox',
				options: {
				}
			}
		}, {
			title: '基本单位',
			field: 'BUom',
			width: 100
		}, {
			title: '注册证号',
			field: 'CertNo',
			width:100,
			editor:{
				type:'text',
				options:{
					}
				}
		}, {
			title: '注册证效期',
			field: 'CertExpDate',
			width:100,
			editor:{
				type:'datebox',
				options:{
					}
				}
		}, {
			title: '厂商',
			field: 'ManfId',
			width: 100,
			formatter: CommonFormatter(PhManufacturerBox,'ManfId','Manf'),
			editor: PhManufacturerBox
		}, {
			title: 'DetailSubId',
			field: 'OrderDetailSubId',
			width: 100,
			hidden: true
		}, {
			title: '生成(注册)人员',
			field: 'User',
			width: 100
		}, {
			title: '生成(注册)日期',
			field: 'Date',
			width: 100
		}, {
			title: '生成(注册)时间',
			field: 'Time',
			width: 100
		}, {
			title: '品牌',
			field: 'Brand',
			width: 100
		}, {
			title: '批号要求',
			field: 'BatchReq',
			width: 100,
			hidden: true
		}, {
			title: '效期要求',
			field: 'ExpReq',
			width: 100,
			hidden: true
		}, {
			title: 'Ingri',
			field: 'Ingri',
			width: 50,
			hidden: true
		}
	]];
	
	var BarCodeGrid = $UI.datagrid('#BarCodeGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'queryRegHVs',
			rows:99999
		},
		deleteRowParams:{
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			MethodName: 'DeleteLabel'
		},
		columns: BarCodeCm,
		singleSelect:false,
		showBar:true,
		pagination: false,
		showAddDelItems:true,
		onClickCell: function(index, field ,value){
			var Row = BarCodeGrid.getRows()[index];
			if ((!isEmpty(Row.RowId))&&((field == 'Qty')||(field == 'InciDesc'))) {
				return false;
			}
			if ((!isEmpty(Row.Ingri))&&(field != 'RowId')) {
				$UI.msg('alert','已入库条码不允许操作!');
				return false;
			}
			BarCodeGrid.commonClickCell(index,field,value);
		},
		beforeAddFn:function(){
			var ParamsObj=GetParamsObj('#IngrConditions');
			if (isEmpty(ParamsObj.InGdRecLocId)){
				$UI.msg('error','请联系管理员设置入库科室!');
				return false;
			}
		}
	})
	
	var InGdRecMainCm = [[{
			title : "RowId",
			field : 'IngrId',
			width : 100,
			hidden : true
		}, {
			title : "入库单号",
			field : 'IngrNo',
			width : 120
		}, {
			title : '入库科室',
			field : 'RecLoc',
			width : 150
		}, {
			title : '接收科室',
			field : 'ReqLocDesc',
			width : 150,
			hidden : true
		}, {
			title : "供应商",
			field : 'Vendor',
			width : 200
		}, {
			title : "资金来源",
			field : 'SourceOfFund',
			width : 200
		}, {
			title : '创建人',
			field : 'CreateUser',
			width : 70
		}, {
			title : '创建日期',
			field : 'CreateDate',
			width : 90
		}, {
			title : "进价金额",
			field : 'RpAmt',
			width : 100,
			align : 'right'
		}, {
			title : "售价金额",
			field : 'SpAmt',
			width : 100,
			align : 'right'
		}, {
			title : "进销差价",
			field : 'Margin',
			width : 100,
			align : 'right'
		}, {
			title : "ReqLoc",
			field : 'ReqLoc',
			width : 10,
			hidden : true
		}, {
			title : "Complete",
			field : 'Complete',
			width : 10,
			hidden : true
		}, {
			title : "StkGrp",
			field : 'StkGrp',
			width : 10,
			hidden : true
		}
	]];
	var IngrMainGrid = $UI.datagrid('#IngrMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			QueryName: 'QueryIngrStr'
		},
		columns: InGdRecMainCm,
		showBar:true,
		onSelect:function(index, row){
			IngrDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
				QueryName: 'QueryDetail',
				Parref: row.IngrId
			});
		}
	})
	var InGdRecDetailCm = [[{
			title : "RowId",
			field : 'RowId',
			width : 100,
			hidden : true
		}, {
			title : '物资代码',
			field : 'IncCode',
			width : 80
		}, {
			title : '物资名称',
			field : 'IncDesc',
			width : 230
		}, {
			title : '高值条码',
			field : 'HVBarCode',
			width : 80
		}, {
			title : '自带条码',
			field : 'OrigiBarCode',
			width : 80
		}, {
			title : '规格',
			field : 'Spec',
			width : 80
		}, {
			title : "厂商",
			field : 'Manf',
			width : 180
		}, {
			title : "批次id",
			field : 'Inclb',
			width : 70,
			hidden : true
		}, {
			title : "批号",
			field : 'BatchNo',
			width : 90
		}, {
			title : "有效期",
			field : 'ExpDate',
			width : 100
		}, {
			title : "单位",
			field : 'IngrUom',
			width : 80
		}, {
			title : "数量",
			field : 'RecQty',
			width : 80,
			align : 'right'
		}, {
			title : "进价",
			field : 'Rp',
			width : 60,
			align : 'right'
		}, {
			title : "售价",
			field : 'Sp',
			width : 60,
			align : 'right'
		}, {
			title : "进价金额",
			field : 'RpAmt',
			width : 100,
			align : 'right'
		}, {
			title : "售价金额",
			field : 'SpAmt',
			width : 100,
			align : 'right'
		}, {
			title : "进销差价",
			field : 'Margin',
			width : 100,
			align : 'right'
		}
	]];
	var IngrDetailGrid = $UI.datagrid('#IngrDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
			QueryName: 'QueryDetail'
		},
		columns: InGdRecDetailCm,
		showBar:true
	})
	Clear();
	if (isEmpty(GetParamsObj('#IngrConditions').InGdRecLocId)){
		$UI.msg('error','请联系管理员设置入库科室!');
	}
}
$(init);
