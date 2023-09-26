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
			if (DetailObj === false){	//δ��ɱ༭����ϸΪ��
				return;
			}
			if (isEmpty(DetailObj)){	//��ϸ����
				$UI.msg("alert", "û����Ҫ�������ϸ!");
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
	//���ݼ��
	function savecheck(){
		IncBarcodeGrid.endEditing();
		var rowsData = IncBarcodeGrid.getRows();
		for(var i=0;i<rowsData.length;i++){
			var row=rowsData[i]
			var UsedFlag=row.UsedFlag;
			var SplitBarCode=row.SplitBarCode;
			if (UsedFlag=="Y"){
				$UI.msg("alert","��"+(i+1)+"����ʹ�ò����޸�");
				return false;
			}
			if(SplitBarCode==""){
				$UI.msg("alert","��"+(i+1)+"�����벻��Ϊ��");
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
	/*--�󶨿ؼ�--*/
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
		//������Ϣ
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
			title:"���ʴ���",
			field:'InciCode',
			width:100
		}, {
			title:"��������",
			field:'InciDesc',
			width:150,
			editor:InciEditor(HandlerParams,SelectRow)
		}, {
			title:"���",
			field:'Spec',
			width:60
		}, {
			title: "��������",
			field: 'SplitBarCode',
			width: 150,
			necessary:true,
			editor: {
				type: 'text'
			}
		}, {
			title:"Ч����ʼλ��",
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
			title:"Ч�ڳ���",
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
			title:"������ʼλ��",
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
			title:"���ų���",
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
			title:"����������ʼλ��",
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
			title:"�������ڳ���",
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
			title:"��������",
			field:'UpdateDate',
			width:100
		}, {
			title:"����ʱ��",
			field:'UpdateTime',
			width:80
		}, {
			title:"������",
			field:'UpdateUserName',
			width:80
		}, {
			title:"ʹ�ñ��",
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
		///���ó�ʼֵ ����ʹ������
		var DefaultValue={
			
		};
		$UI.fillBlock('#MainConditions',DefaultValue);
		InitHosp();
		$('#StkScg').combotree('options')['setDefaultFun']();
	}
	Default();
}
$(init);