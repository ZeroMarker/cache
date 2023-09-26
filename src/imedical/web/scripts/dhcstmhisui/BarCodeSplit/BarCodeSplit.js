var init = function() {
	var HospId="";
	function InitHosp() {
		var hospComp=InitHospCombo("INC_Itm",gSessionStr);
		if (typeof hospComp ==='object'){
			HospId=$HUI.combogrid('#_HospList').getValue();
			$('#_HospList').combogrid("options").onSelect=function(index,record){
				HospId=record.HOSPRowId;
				setStkGrpHospid(HospId);
				$UI.clearBlock('MainConditions');
				$HUI.combotree('#StkScg').load(HospId);
				Query();
			};
		}else{
			HospId=gHospId;
		}
		setStkGrpHospid(HospId);
	}
	$UI.linkbutton('#TipBT',{
		onClick:function(){
			$HUI.dialog('#FindWin').open()
		}
	});
	
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			Query();
		}
	});
	function Query(){
		var ParamsObj=$UI.loopBlock('#MainConditions')
		var Params=JSON.stringify(ParamsObj);
		IncBarcodeGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCBarCodeSplitInfo',
			QueryName: 'Query',
			rows:999,
			Params:Params
		});
	}
	
	function QueryStr(RowIdStr){
		var ParamsObj=$UI.loopBlock('#MainConditions');
		ParamsObj.RowIdStr=RowIdStr;
		var Params=JSON.stringify(ParamsObj);
		IncBarcodeGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCBarCodeSplitInfo',
			QueryName: 'Query',
			rows:999,
			Params:Params
		});
	}
	$UI.linkbutton('#SaveBT',{
		onClick:function(){
			Save();
		}
	});
	function Save(){
		if(savecheck()==true){
			var MainObj=$UI.loopBlock('#MainConditions')
			var Main=JSON.stringify(MainObj)
			var DetailObj=IncBarcodeGrid.getChangesData('InciId');
			if (DetailObj === false){	//未完成编辑或明细为空
				return;
			}
			if (isEmpty(DetailObj)){	//明细不变
				$UI.msg("alert", "没有需要保存的明细!");
				return;
			}
			var Detail=JSON.stringify(DetailObj)
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCBarCodeSplitInfo',
				MethodName: 'jsSave',
				Main: Main,
				Detail: Detail
			},function(jsonData){
				hideMask();
				if(jsonData.success==0){
					$UI.msg("success",jsonData.msg);
					QueryStr(jsonData.rowid);
				}
				else{
					$UI.msg("error",jsonData.msg);
				}
			});
		}
	}
	//数据检查
	function savecheck(){
		IncBarcodeGrid.endEditing();
		var rowsData = IncBarcodeGrid.getRows();
		for(var i=0;i<rowsData.length;i++){
			var row=rowsData[i]
			var UsedFlag=row.UsedFlag;
			var SplitBarCode=row.SplitBarCode;
			if (UsedFlag=="Y"){
				$UI.msg("alert","第"+(i+1)+"行已使用不能修改");
				return false;
			}
			if(SplitBarCode==""){
				$UI.msg("alert","第"+(i+1)+"行条码不能为空");
				return false;
			}
		}
		return true;
	}
	
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Default();
		}
	});
	/*--绑定控件--*/
	var StkCatBox = $HUI.combobox('#StkCat', {
		//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	$('#StkScg').combotree({
		onChange:function(newValue, oldValue){
			StkCatBox.clear();
			var Params=JSON.stringify(addSessionParams({BDPHospital:HospId}));
			var url=$URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array&StkGrpId='+newValue+'&Params='+Params;
			StkCatBox.reload(url);
		}
	});
	var HandlerParams=function(){
		var StkScg=$("#StkScg").combotree('getValue');
		var StkCat=$("#StkCat").combobox('getValue');
		var Obj={StkGrpRowId:StkScg,StkGrpType:"M",NotUseFlag:"N",HV:"",StkCat:StkCat,BDPHospital:HospId};
		return Obj;
	}
	
	$("#InciDesc").lookup(InciLookUpOp(HandlerParams,'#InciDesc','#Inci'));
	
	var SelectRow=function(row){
		//其他信息
		var Rows =IncBarcodeGrid.getRows();
		var Row = Rows[IncBarcodeGrid.editIndex];
		Row.InciId=row.InciDr;
		Row.InciCode=row.InciCode;
		Row.InciDesc=row.InciDesc;
		setTimeout(function(){
			IncBarcodeGrid.refreshRow();
			IncBarcodeGrid.startEditingNext('InciDesc');
		},0);
	}
	
	var IncBarcodeCm = [[
		{
			field: 'ck',
			checkbox: true
		},{
			title:"RowId",
			field:'RowId',
			width:50,
			hidden:true
		}, {
			title:"InciId",
			field:'InciId',
			width:50,
			hidden:true
		}, {
			title:"物资代码",
			field:'InciCode',
			width:100
		}, {
			title:"物资名称",
			field:'InciDesc',
			width:150,
			editor:InciEditor(HandlerParams,SelectRow)
		}, {
			title:"规格",
			field:'Spec',
			width:60
		}, {
			title: "物资条码",
			field: 'SplitBarCode',
			width: 150,
			necessary:true,
			editor: {
				type: 'text'
			}
		}, {
			title:"效期起始位置",
			field:'ExpStartPosition',
			width:100,
			align:'right',
			editor:{
				type:'numberbox',
				options:{
					precision: 0
				}
			}
		}, {
			title:"效期长度",
			field:'ExpLength',
			width:80,
			align:'right',
			editor:{
				type:'numberbox',
				options:{
					precision: 0
				}
			}
		}, {
			title:"批号起始位置",
			field:'BatStartPosition',
			width:100,
			align:'right',
			editor:{
				type:'numberbox',
				options:{
					precision: 0
				}
			}
		}, {
			title:"批号长度",
			field:'BatLength',
			width:80,
			align:'right',
			editor:{
				type:'numberbox',
				options:{
					precision: 0
				}
			}
		}, {
			title:"生产日期起始位置",
			field:'ProStartPosition',
			width:130,
			align:'right',
			editor:{
				type:'numberbox',
				options:{
					precision: 0
				}
			}
		}, {
			title:"生产日期长度",
			field:'ProLength',
			width:100,
			align:'right',
			editor:{
				type:'numberbox',
				options:{
					precision: 0
				}
			}
		}, {
			title:"更新日期",
			field:'UpdateDate',
			width:100
		}, {
			title:"更新时间",
			field:'UpdateTime',
			width:80
		}, {
			title:"更新人",
			field:'UpdateUserName',
			width:80
		}, {
			title:"使用标记",
			field:'UsedFlag',
			formatter:BoolFormatter,
			align:'center',
			width:80
		}
	]];
	
	var IncBarcodeGrid = $UI.datagrid('#IncBarcodeGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCBarCodeSplitInfo',
			QueryName: 'Query'
		},
		deleteRowParams:{
			ClassName:'web.DHCSTMHUI.DHCBarCodeSplitInfo',
			MethodName:'jsDelete'
		},
		columns: IncBarcodeCm,
		sortName: 'RowId',
		sortOrder: 'Asc',
		showAddDelItems:true,
		showBar:true,
		pagination: false,
		singleSelect: false,
		onClickCell: function(index, filed ,value){
			IncBarcodeGrid.commonClickCell(index,filed,value);
		},
		onBeginEdit: function(index, row){
			$('#IncBarcodeGrid').datagrid('beginEdit', index);
			var ed = $('#IncBarcodeGrid').datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++){
				var e = ed[i];
				if(e.field == 'SplitBarCode'){
					$(e.target).bind('keydown', function(event){
						if(event.keyCode == 13){
							var Value = $(this).val();
							var BarCodeObj = GetBarCodeSplitInfo(Value);
							var BarCode = BarCodeObj['Code'];
							$(this).val(BarCode);
						}
					});
				}
			}
		}
	})
	
	var Default=function(){
		$UI.clearBlock('#MainConditions');
		$UI.clear(IncBarcodeGrid);
		///设置初始值 考虑使用配置
		var DefaultValue={
			
		};
		$UI.fillBlock('#MainConditions',DefaultValue);
		InitHosp();
		$('#StkScg').combotree('options')['setDefaultFun']();
	}
	Default();
}
$(init);