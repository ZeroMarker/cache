var ReqTemplateFlag = false;
var init = function() {

	/*--按钮事件--*/
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			FindWin(Select)
		}
	});
	var Select=function(PurId){
		$UI.clearBlock('#MainConditions');
		$UI.clear(PurGrid);
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPurPlan',
			MethodName: 'Select',
			PurId: PurId
		},
		function(jsonData){
			$UI.fillBlock('#MainConditions',jsonData)
			if($HUI.checkbox("#CompFlag").getValue()==false){
				setUnComp()
			}else{
				setComp()
			}
		});
		PurGrid.load({
			ClassName: 'web.DHCSTMHUI.INPurPlanItm',
			QueryName: 'Query',
			PurId: PurId,
			rows:99999
		});
	}
	//设置可编辑组件的disabled属性
	function setUnComp(){
		$HUI.combobox("#PurLoc").disable()
		$HUI.combobox("#StkScg").disable()
		ChangeButtonEnable({'#AddBT':true,'#DelBT':true,'#ComBT':true,'#CanComBT':false});
	}
	function setComp(){
		$HUI.combobox("#PurLoc").disable()
		$HUI.combobox("#StkScg").disable()
		ChangeButtonEnable({'#AddBT':false,'#DelBT':false,'#ComBT':false,'#CanComBT':true});
	}
	function DefaultClear(){
		$UI.clearBlock('#MainConditions');
		$UI.clear(PurGrid);
		$HUI.combobox("#PurLoc").enable()
		$HUI.combobox("#StkScg").enable()
		ChangeButtonEnable({'#AddBT':true,'#DelBT':true,'#ComBT':true,'#CanComBT':false});
		Default();
	}
	
	$UI.linkbutton('#SaveBT',{
		onClick:function(){
			Save();
		}
	});
	function Save(){
		if(savecheck()==true){
			var MainObj=$UI.loopBlock('#MainConditions');
			var Main=JSON.stringify(MainObj);
			var IsChange=$UI.isChangeBlock('#MainConditions');
			
			var RowId = $('#RowId').val();
			if (ReqTemplateFlag && isEmpty(RowId)) {
				//按模板制单
				var DetailObj = PurGrid.getRowsData();
			} else {
				var DetailObj = PurGrid.getChangesData('InciId');
			}
			if (DetailObj === false) {
				return;
			} else if (DetailObj.length == 0 && IsChange == false) {
				$UI.msg('alert', '没有需要保存的内容!');
				return;
			}
			var Detail=JSON.stringify(DetailObj);
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.INPurPlan',
				MethodName: 'Save',
				Main: Main,
				Detail: Detail
			},function(jsonData){
				hideMask();
				if(jsonData.success==0){
					$UI.msg("success",jsonData.msg);
					Select(jsonData.rowid);
					ReqTemplateFlag = false;
				}else{
					$UI.msg("error",jsonData.msg);
				}
			});
		}
	}
	//数据检查
	function savecheck(){
		PurGrid.endEditing();
		if($HUI.checkbox("#CompFlag").getValue()==true){
			$UI.msg("alert","已经完成，不能保存!");
			return false;
		}
		var rowsData = PurGrid.getRows();
		for(var i=0;i<rowsData.length;i++){
			var row=rowsData[i]
			var InciId=row.InciId;
			var UomId=row.UomId;
			var vendorId=row.VendorId
			if ((UomId=="")&&(InciId!="")){
				$UI.msg("alert","第"+(i+1)+"行单位为空");
				return false;
			}
			if(InciId!=""&&vendorId==""&&InPurPlanParamObj.VendorNeeded!="N"){
				$UI.msg("alert","第"+(i+1)+"行供应商为空");
				return false;
			}
		}
		return true;
	}
	$UI.linkbutton('#DelBT',{
		onClick:function(){
			var PurId=$('#RowId' ).val()
			if(isEmpty(PurId)){
				$UI.msg("alert","请选择要删除的采购计划单");
				return;
			}
			$UI.confirm("确定要删除吗", "warning", "", Delete, "", "", "警告", false)
		}
	});
	function Delete(){
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPurPlan',
			MethodName: 'jsDelete',
			PurId: $('#RowId' ).val()
		},function(jsonData){
			hideMask();
			if(jsonData.success==0){
				$UI.msg("success",jsonData.msg);
				DefaultClear()
			}
			else{
				$UI.msg("error",jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#ComBT',{
		onClick:function(){
			var PurId=$('#RowId' ).val()
			if(isEmpty(PurId)){
				$UI.msg("alert","请选择要完成的采购计划单");
				return;
			}
			var Detail=PurGrid.getChangesData();
			if(Detail!=""){
				$UI.confirm("数据已修改是否放弃保存！", "warning", "", SetComplete, "", "", "警告", false)
			}
			else{
				SetComplete()
			}
		}
	});
	function SetComplete(){
		var MainObj=$UI.loopBlock('#MainConditions')
		var Main=JSON.stringify(MainObj)
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPurPlan',
			MethodName: 'jsSetComplete',
			Params:Main
		},function(jsonData){
			hideMask();
			if(jsonData.success==0){
				$UI.msg("success",jsonData.msg);
				Select(jsonData.rowid)
			}
			else{
				$UI.msg("error",jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#CanComBT',{
		onClick:function(){
			var PurId=$('#RowId' ).val()
			if(isEmpty(PurId)){
				$UI.msg("alert","请选择要取消完成的采购计划单");
				return;
			}
			var MainObj=$UI.loopBlock('#MainConditions')
			var Main=JSON.stringify(MainObj)
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.INPurPlan',
				MethodName: 'jsCancelComplete',
				Params:Main
			},function(jsonData){
				hideMask();
				if(jsonData.success==0){
					$UI.msg("success",jsonData.msg);
					Select(jsonData.rowid)
				}
				else{
					$UI.msg("error",jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			DefaultClear();
		}
	});
	$UI.linkbutton('#PrintBT',{
		onClick:function(){
			var PurId=$('#RowId' ).val()
			if(isEmpty(PurId)){
				$UI.msg("alert","请选择要打印的采购计划单");
				return;
			}
			PrintInPurPlan(PurId)
		}
	});
	
	$UI.linkbutton('#MouldBT', {
		onClick: function () {
			InPurPlanMouldWin(Select, MouldSelect);
		}
	});
	
	function MouldSelect(PurId, InppiIdStr){
		DefaultClear();
		ReqTemplateFlag = true;
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPurPlan',
			MethodName: 'Select',
			PurId: PurId
		}, function(jsonData){
			$('#PurLoc').combobox('setValue', jsonData['PurLoc']);
			$("#StkScg").combotree('setValue', jsonData['StkScg']);
		});
		var ParamsObj = {InppiIdStr : InppiIdStr};
		var Params = JSON.stringify(ParamsObj);
		PurGrid.load({
			ClassName: 'web.DHCSTMHUI.INPurPlanItm',
			QueryName: 'Query',
			PurId: PurId,
			Params: Params,
			rows: 99999
		});
	}
	
	/*--绑定控件--*/
	var PurLocBox = $HUI.combobox('#PurLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+PurLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	/*--Grid列绑定--*/
	var HandlerParams=function(){
		var StkScg=$("#StkScg").combotree('getValue')
		var PurLoc=$("#PurLoc").combo('getValue')
		var Obj={StkGrpRowId:StkScg,StkGrpType:"M",Locdr:PurLoc,NotUseFlag:"N",QtyFlag:"",
		ToLoc:"",ReqModeLimited:"",NoLocReq:"",HV:"",RequestNoStock:"Y"};
		return Obj
	}
	var SelectRow=function(row){
		//其他信息
		var purloc=$HUI.combobox("#PurLoc").getValue()
		var InciParams=JSON.stringify(addSessionParams({PurLoc:purloc}));
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPurPlan',
			MethodName: 'GetItmInfo',
			IncId: row.InciDr,
			Params:InciParams
		},
		function(jsonData){
			/*PurGrid.updateRow({
				index:PurGrid.editIndex,
				row: {
					InciId:row.InciDr,
					InciCode:row.InciCode,
					InciDesc:row.InciDesc,
					Spec:jsonData.Spec,
					UomId:jsonData.PurUomId,
					UomDesc:jsonData.PurUomDesc,
					Rp:jsonData.Rp,
					Sp:jsonData.Sp,
					MinQty:jsonData.MinQty,
					MaxQty:jsonData.MaxQty,
					BUomId:jsonData.BUomId,
					ConFac:jsonData.Confac,
					VendorId:jsonData.VenId,
					VendorDesc:jsonData.VenDesc,
					ManfId:jsonData.ManfId,
					ManfDesc:jsonData.ManfDesc,
					CarrierId:jsonData.CarrierId,
					CarrierDesc:jsonData.CarrierDesc
				}
			});*/
			var Rows =PurGrid.getRows();
			var Row = Rows[PurGrid.editIndex];
			Row.InciId=row.InciDr;
			Row.InciCode=row.InciCode;
			Row.InciDesc=row.InciDesc;
			Row.Spec=jsonData.Spec;
			Row.UomId=jsonData.PurUomId;
			Row.UomDesc=jsonData.PurUomDesc;
			Row.Rp=jsonData.Rp;
			Row.Sp=jsonData.Sp;
			Row.MinQty=jsonData.MinQty;
			Row.MaxQty=jsonData.MaxQty;
			Row.BUomId=jsonData.BUomId;
			Row.ConFac=jsonData.Confac;
			Row.VendorId=jsonData.VenId;
			Row.VendorDesc=jsonData.VenDesc;
			Row.ManfId=jsonData.ManfId;
			Row.ManfDesc=jsonData.ManfDesc;
			Row.CarrierId=jsonData.CarrierId;
			Row.CarrierDesc=jsonData.CarrierDesc;
			setTimeout(function(){
				PurGrid.refreshRow();
				PurGrid.startEditingNext('InciDesc');
			},0);
		});
	}

	var UomCombox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInciUom&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required:true,
			mode:'remote',
			onBeforeLoad:function(param){
				var rows =PurGrid.getRows();  
				var row = rows[PurGrid.editIndex];
				if(!isEmpty(row)){
					param.Inci =row.InciId;
				}
			},
			onSelect:function(record){
				var rows =PurGrid.getRows();  
				var row = rows[PurGrid.editIndex];
				var seluom=record.RowId;
				var rp=row.Rp;
				var sp=row.Sp;
				var buom=row.BUomId;
				var confac=row.ConFac;
				var uom=row.UomId;  //旧单位
				if(seluom!=uom){
					if(seluom!=buom){		//原单位是基本单位，目前选择的是入库单位
						Rp=Number(rp).mul(confac); 
						Sp=Number(sp).mul(confac);
					}else{					//目前选择的是基本单位，原单位是入库单位
						Rp=Number(rp).div(confac); 
						Sp=Number(sp).div(confac);
					}
				}
				row.UomDesc=record.Description;
				row.UomId=record.RowId;
				row.Rp=Rp;
				row.Sp=Sp;
				$('#PurGrid').datagrid('refreshRow', PurGrid.editIndex);
				//setTimeout(function(){PurGrid.refreshRow();},0);
			},
			onShowPanel:function(){
				$(this).combobox('reload')
			}
		}
	};
	var SpecDescParams=JSON.stringify(sessionObj)
	var SpecDescbox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSpecDesc&ResultSetType=array&Params='+SpecDescParams,
			valueField: 'Description',
			textField: 'Description',
			required:false,
			mode:'remote',
			onBeforeLoad:function(param){
				var Select=PurGrid.getSelected()
				if(!isEmpty(Select)){
					param.Inci = Select.InciId;
				}
			}
		}
	};
	var VendorCombox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorParams,
			valueField: 'RowId',
			textField: 'Description',
			onSelect:function(record){
				var rows =PurGrid.getRows();
				var row = rows[PurGrid.editIndex];
				row.VendorDesc=record.Description;
			},
			onShowPanel:function(){
				$(this).combobox('reload')
			}
		}
	};
	var ManfCombox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			onSelect:function(record){
				var rows =PurGrid.getRows();  
				var row = rows[PurGrid.editIndex];
				row.ManfDesc=record.Description;
			},
			onShowPanel:function(){
				$(this).combobox('reload')
			}
		}
	};
	var CarrierCombox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCarrier&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			onSelect:function(record){
				var rows =PurGrid.getRows();  
				var row = rows[PurGrid.editIndex];
				row.CarrierDesc=record.Description
			},
			onShowPanel:function(){
				$(this).combobox('reload')
			}
		}
	};
	var ReqLocCombox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+PurLocParams,
			valueField: 'RowId',
			textField: 'Description',
			onSelect:function(record){
				var rows =PurGrid.getRows();  
				var row = rows[PurGrid.editIndex];
				row.ReqLocDesc=record.Description;
			},
			onShowPanel:function(){
				$(this).combobox('reload')
			}
		}
	};
	
	var PurCm = [[
		{
			field: 'ck',
			checkbox: true
		},{
			title:"RowId",
			field:'RowId',
			width:60,
			hidden:true
		}, {
			title:"物资RowId",
			field:'InciId',
			width:60,
			hidden:true
		}, {
			title:"物资代码",
			field:'InciCode',
			width:100
		}, {
			title:"物资名称",
			field:'InciDesc',
			width:200,
			editor:InciEditor(HandlerParams,SelectRow)
		}, {
			title:"规格",
			field:'Spec',
			width:100
		}, {
			title:"具体规格",
			field:'SpecDesc',
			width:100,
			formatter: CommonFormatter(SpecDescbox, 'SpecDesc', 'SpecDesc'),
			editor:SpecDescbox
		}, {
			title:"单位",
			field:'UomId',
			width:80,
			necessary:true,
			formatter: CommonFormatter(UomCombox,'UomId','UomDesc'),
			editor:UomCombox
		}, {
			title:"采购数量",
			field:'Qty',
			width:80,
			align:'right',
			necessary:true,
			editor:{
				type:'numberbox',
				options:{
					required:true
				}
			}
		}, {
			title:"进价",
			field:'Rp',
			width:80,
			align:'right',
			necessary:true,
			editor:{
				type:'numberbox',
				options:{
					required:true
				}
			}
		}, {
			title:"供应商",
			field:'VendorId',
			width:100,
			formatter: CommonFormatter(VendorCombox,'VendorId','VendorDesc'),
			editor:VendorCombox
		}, {
			title:"配送商",
			field:'CarrierId',
			width:100,
			formatter: CommonFormatter(CarrierCombox,'CarrierId','CarrierDesc'),
			editor:CarrierCombox
		}, {
			title:"厂商",
			field:'ManfId',
			width:100,
			formatter: CommonFormatter(ManfCombox,'ManfId','ManfDesc'),
			editor:ManfCombox
		}, {
			title:"请求科室",
			field:'ReqLocId',
			width:100,
			formatter: CommonFormatter(ReqLocCombox,'ReqLocId','ReqLocDesc'),
			editor:ReqLocCombox
		}, {
			title:"库存下限",
			field:'MinQty',
			width:80,
			align:'right'
		}, {
			title:"库存上限",
			field:'MaxQty',
			width:80,
			align:'right'
		}, {
			title:"购入金额",
			field:'RpAmt',
			width:80,
			align:'right'
		}, {
			title:"本科室数量",
			field:'LocQty',
			width:80,
			align:'right'
		}, {
			title:"本科室可用数量",
			field:'LocAvaQty',
			width:80,
			align:'right'
		}, {
			title:"请求数量",
			field:'ReqQty',
			width:80,
			align:'right'
		}, {
			title:"已转移数量",
			field:'TrfQty',
			width:80,
			align:'right'
		}, {
			title:"基本单位Id",
			field:'BUomId',
			width:80,
			hidden: true
		}, {
			title:"单位转换系数",
			field:'ConFac',
			width:80,
			hidden: true
		}
	]];
	
	var PurGrid = $UI.datagrid('#PurGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INPurPlanItm',
			QueryName: 'Query',
			rows:99999
		},
		deleteRowParams:{
			ClassName:'web.DHCSTMHUI.INPurPlanItm',
			MethodName:'jsDelete'
		},
		columns: PurCm,
		sortName: 'RowId',
		sortOrder: 'Asc',
		showAddDelItems:true,
		showBar:true,
		pagination: false,
		singleSelect:false,
		onClickCell: function(index, filed ,value){
			if($HUI.checkbox("#CompFlag").getValue()){
				return false;
			}
			PurGrid.commonClickCell(index,filed,value)
		},
		onBeforeEdit:function(index,row){
			if($HUI.checkbox("#CompFlag").getValue()){
				return false;
			}
		},
		onEndEdit:function(index, row, changes){
			
		},
		beforeAddFn:function(){
			if($HUI.checkbox("#CompFlag").getValue()==true){
				$UI.msg("alert","已经完成，不能增加一行");
				return false;
			}
			if(isEmpty($HUI.combobox("#PurLoc").getValue())){
				$UI.msg("alert","采购科室不能为空");
				return false;
			}
			if(isEmpty($HUI.combobox("#StkScg").getValue())){
				$UI.msg("alert","类组不能为空");
				return false;
			}
			setUnComp();
		},
		onLoadSuccess: function (data) {
			var RowId = $('#RowId').val();
			if (isEmpty(RowId)) {
				for (var i = 0; i < data.rows.length; i++) {
					$(this).datagrid('updateRow', {
						index: i,
						row: {RowId : ''}
					});
				}
			}
		}
	})
	
	var Default=function(){
		///设置初始值 考虑使用配置
		var DefaultValue={
			RowId:"",
			PurLoc:gLocObj
		};
		$UI.fillBlock('#MainConditions',DefaultValue);
		$('#StkScg').combotree('options')['setDefaultFun']();
	}
	Default();
	if(gPurId>0){
		Select(gPurId)
	}
}
$(init);