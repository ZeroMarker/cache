/*
���ݶ������
*/
var ImpByPoFN=function(Fn){
	$HUI.dialog('#ImportByPoWin').open();
	$UI.linkbutton('#PoQueryBT',{
		onClick:function(){
			QueryInpoIngrInfo();
		}
	});
	$UI.linkbutton('#PoClearBT',{
		onClick:function(){
			InpoIngrClear();
		}
	});
	$UI.linkbutton('#PoSaveBT',{
		onClick:function(){
			if(CheckDataBeforeSave()){
				InpoIngrSave();
			}
		}
	});
	//Grid �� comboxData
	var UomCombox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInciUom&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required:true,
			mode:'remote',
			onBeforeLoad:function(param){
				var rows =IngrInpoDetailGrid.getRows();
				var row = rows[IngrInpoDetailGrid.editIndex];
				if(!isEmpty(row)){
					param.Inci =row.IncId;
				}
			},
			onSelect:function(record){
				var rows =IngrInpoDetailGrid.getRows();
				var row = rows[IngrInpoDetailGrid.editIndex];
				row.IngrUom=record.Description;
				var NewUomid=record.RowId;
				var OldUomid=row.IngrUomId;
				if(isEmpty(NewUomid)||(NewUomid==OldUomid)){return false;}
				var BUomId=row.BUomId;
				var confac=row.ConFacPur;
				if (NewUomid==BUomId){ //��ⵥλת��Ϊ������λ
					var rp=row.Rp;
					var sp=row.Sp;
					row.Rp=Number(rp).div(confac);
					row.Sp=Number(sp).div(confac);
				}else{ //������λת��Ϊ��ⵥλ
					var rp=row.Rp;
					var sp=row.Sp;
					row.Rp=Number(rp).mul(confac);
					row.Sp=Number(sp).mul(confac);
				}
				row.IngrUomId=NewUomid;
				$('#IngrInpoDetailGrid').datagrid('refreshRow', IngrInpoDetailGrid.editIndex);
			},
			onShowPanel:function(){
				$(this).combobox('reload');
			}
		}
	};
	/// grid combobox
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
	var SpecDescParams=JSON.stringify(sessionObj)
	var SpecDescbox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSpecDesc&ResultSetType=array&Params='+SpecDescParams,
			valueField: 'Description',
			textField: 'Description',
			mode:'remote',
			onBeforeLoad:function(param){
				var Select=IngrInpoDetailGrid.getSelected();
				if(!isEmpty(Select)){
					param.Inci =Select.IncId;
				}
			}
		}
	};
	var RecLocParams=JSON.stringify(addSessionParams({Type:"Login"}));
//	var RecLocBox = $HUI.combobox('#PoRecLoc', {
//			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+RecLocParams,
//			valueField: 'RowId',
//			textField: 'Description'
//	});
	$("#PoRecLoc").lookup({
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetCTLoc',
			Params: RecLocParams
		}
	});
	var VendorParams=JSON.stringify(addSessionParams({APCType:"M",RcFlag:"Y"}));
//	var VendorBox = $HUI.combobox('#VendorBox', {
//			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorParams,
//			valueField: 'RowId',
//			textField: 'Description'
//	});
	$("#VendorBox").lookup({
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetVendor',
			Params: VendorParams
		}
	});

	var SourceOfFundParams=JSON.stringify(addSessionParams());
//	var SourceOfFundBox = $HUI.combobox('#PoSourceOfFund', {
//			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSourceOfFund&ResultSetType=array&Params='+SourceOfFundParams,
//			valueField: 'RowId',
//			textField: 'Description'
//	});
	$("#PoSourceOfFund").lookup({
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetSourceOfFund',
			Params: SourceOfFundParams
		}
	});
	var IngrInpoMainCm = [[
			{
				title : "RowId",
				field : 'PoId',
				width : 50,
				hidden : true
			},{
				title : "������",
				field : 'PoNo',
				width : 100
			},{
				title : "�깺����",
				field : 'ReqLocDesc',
				width : 100
			},{
				title : "��������",
				field : 'PoLocDesc',
				width : 100
			},{
				title : "��Ӧ��",
				field : 'Vendor',
				width : 100
			},{
				title : "����״̬",
				field : 'PoStatus',
				width : 100,
				formatter :function(v){
						if(v==0){return "δ���"}
						else if(v==1){return "�������"}
						else {return "ȫ�����"}
					}
			},{
				title : "��������",
				field : 'PoDate',
				width : 100
			},{
				title : "VenId",
				field : 'VenId',
				width : 50,
				hidden : true
			},{
				title : "PurUserId",
				field : 'PurUserId',
				width : 50,
				hidden : true
			},{
				title : "StkGrpId",
				field : 'StkGrpId',
				width : 50,
				hidden : true
			},{
				title : "CmpFlag",
				field : 'CmpFlag',
				width : 50,
				hidden : true
			},{
				title : "�����ʼ�",
				field : 'Email',
				width : 100
			},{
				title : "ReqLoc",
				field : 'ReqLoc',
				width : 50,
				hidden : true
			},{
				title : "PoLoc",
				field : 'PoLoc',
				width : 50,
				hidden : true
			},{
				title : "�Ƿ�����",
				field : 'Approveed',
				width : 100,
				formatter : function(value){
				if(value=='Y')
				return '��';
				else
				return '��';}
			},{
				title : "������",
				field : 'ApproveedUser',
				width : 50,
				hidden : true
			},{
				title : "ApproveedDate",
				field : 'ApproveedDate',
				width : 50,
				hidden : true
			},{
				title : "CancelReasonId",
				field : 'CancelReasonId',
				width : 50,
				hidden : true
			},{
				title : "CancelReason",
				field : 'CancelReason',
				width : 50,
				hidden : true
			}
	]];
	var IngrInpoMainGrid = $UI.datagrid('#IngrInpoMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INPO',
			QueryName: 'Query'
		},
		columns: IngrInpoMainCm,
		showBar:true,
		onSelect:function(index, row){
			IngrInpoDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
				QueryName: 'QueryPoItmForRec',
				Parref: row.PoId
			});
		},
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				IngrInpoMainGrid.selectRow(0);
			}
		}
	})
	var IngrInpoDetailGridCm = [[
			{
				title : "RowId",
				field : 'Inpoi',
				width : 50,
				hidden : true
			},{
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
				width : 100
			},{
				title : "���",
				field : 'Spec',
				width : 100
			},{
				title : "����",
				field : 'RecQty',
				width : 100,
				align : 'right',
				editor:{
					type:'numberbox',
					options:{
						required:true
					}
				}
			},{
				title : "��λ",
				field : 'IngrUomId',
				width : 100,
				formatter: CommonFormatter(UomCombox,'IngrUomId','IngrUom'),
				editor:UomCombox
			},{
				title : "����",
				field : 'Rp',
				width : 80,
				align : 'right',
				editor:{
					type:'numberbox',
					options:{
						required:true
					}
				}
			},{
				title : "��������",
				field : 'ManfId',
				width : 100,
				formatter: CommonFormatter(PhManufacturerBox,'ManfId','Manf'),
				editor:PhManufacturerBox
			},{
				title : "�ۼ�",
				field : 'Sp',
				width : 100,
				align : 'right'
			},{
				title : "����",
				field : 'BatchNo',
				width : 80,
				editor:{
					type:'text',
					options:{
					}
				}
			},{
				title : "��Ч��",
				field : 'ExpDate',
				width : 80,
				editor:{
					type:'datebox',
					options:{
					}
				}
			},{
				title : "������λ",
				field : 'BUomId',
				width : 50,
				hidden : true
			},{
				title : "ת����",
				field : 'ConFacPur',
				width : 100
			},{
				title : "��������",
				field : 'PurQty',
				width : 100,
				align : 'right'
			},{
				title : "������Ƶ�����",
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
				title : "BarcodeQty",
				field : 'BarcodeQty',
				width : 50,
				align : 'right',
				hidden : true
			},{
				title : "AvaBarcodeQty",
				field : 'AvaBarcodeQty',
				width : 50,
				align : 'right',
				hidden : true
			},{
				title : "������",
				field : 'SpecDesc',
				width : 100,
				formatter: CommonFormatter(SpecDescbox,'SpecDesc','SpecDesc'),
				editor:SpecDescbox
			},{
				title : "ע��֤��",
				field : 'AdmNo',
				width : 90,
				editor:{
					type:'text',
					options:{
					}
				}
			},{
				title : "ע��֤��Ч��",
				field : 'AdmExpdate',
				width : 100,
				editor:{
					type:'datebox',
					options:{
					}
				}
			},{
				title : "��ֵ��־",
				field : 'HVFlag',
				width : 100
			},{
				title : "���������",
				field : 'ImpQtyAudited',
				width : 100,
				align : 'right'
			}
		]];
	var IngrInpoDetailGrid = $UI.datagrid('#IngrInpoDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
			QueryName: 'QueryPoItmForRec'
		},
		columns: IngrInpoDetailGridCm,
		showBar:true,
		onClickCell: function(index, field ,value){
			IngrInpoDetailGrid.commonClickCell(index,field,value);
		}
	});
	function QueryInpoIngrInfo() {
		var ParamsObj=$UI.loopBlock('#PoConditions');
		if(isEmpty(ParamsObj.PoRecLoc)){
			$UI.msg('alert','�����Ҳ���Ϊ��!');
			return false;
		}
		var Params=JSON.stringify(ParamsObj);
		$UI.clear(IngrInpoDetailGrid);
		IngrInpoMainGrid.load({
			ClassName: 'web.DHCSTMHUI.INPO',
			QueryName: 'Query',
			Params:Params
		});
	}
	function CheckDataBeforeSave() {
		var ParamsObj=$UI.loopBlock('#PoConditions');
		var RecLoc=ParamsObj.PoRecLoc;
		var Row=IngrInpoMainGrid.getSelected();
		if(isEmpty(Row)){
			$UI.msg('alert','��ѡ��Ҫ����ĵ���!');
			return false;
		}

		var Status = Row.PoStatus;
		if (Status ==2) {
			$UI.msg('alert','�ö����Ѿ�ȫ����⣬���������!');
			return false;
		}
		if (isEmpty(RecLoc)) {
			$UI.msg('alert','��ѡ��������!');
			return false;
		}
		var RowsData=IngrInpoDetailGrid.getRows();
		// ��Ч����
		var count = 0;
		for (var i = 0; i < RowsData.length; i++) {
			var item = RowsData[i].IncId;
			if (!isEmpty(item)) {
				count++;
			}
		}
		if (RowsData.length <= 0 || count <= 0) {
			$UI.msg('alert','�������ϸ����!');
			return false;
		}
		return true;
	}
	function InpoIngrSave() {
		var ParamsObj=$UI.loopBlock('PoConditions');
		var SaveParamsObj = $UI.loopBlock('#PoSaveConditions');
		var RecLoc=ParamsObj.PoRecLoc;
		var SourceOfFund=SaveParamsObj.PoSourceOfFund;
		var Row=IngrInpoMainGrid.getSelected();
		if(isEmpty(Row)){
			$UI.msg('alert','��ѡ��Ҫ����ĵ���!');
			return false;
		}
		var PoId = Row.PoId;
		var HVflag=GetCertDocHVFlag(PoId,"PO");
		if(HVflag=="Y"){
			$UI.msg('alert','�˶���Ϊ��ֵ����,��ȥ��ֵ����������浼�붩��,ע������!');
			return false;
		}
		var PurchaseUser = Row.PurUserId;
		var Vendor = Row.VenId;
		var StkGrpId = Row.StkGrpId;
		var ReqLocId = Row.ReqLoc;
		var Complete = "N";
		var AdjCheque = "N";
		var GiftFlag = "N";
		var Main=JSON.stringify(addSessionParams({RecLoc:RecLoc,PurchaseUser:PurchaseUser,ApcvmDr:Vendor,StkGrpId:StkGrpId,SourceOfFund:SourceOfFund,ReqLocId:ReqLocId,Complete:Complete,AdjCheque:AdjCheque,GiftFlag:GiftFlag,PoId:PoId}));
		var DetailObj=IngrInpoDetailGrid.getRowsData();
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
			$UI.msg('alert',jsonData.msg);
			if(jsonData.success==0){
				var IngrRowid=jsonData.rowid;
				$HUI.dialog('#ImportByPoWin').close();
				if(IngrParamObj.AutoPrintAfterSave=="Y"){
					PrintRec(IngrRowid,"Y");
				}
				Fn(IngrRowid);
			}
		});
	}

	function InpoIngrClear() {
		$UI.clearBlock('#PoConditions');
		$UI.clearBlock('#PoSaveConditions');
		$UI.clear(IngrInpoMainGrid);
		$UI.clear(IngrInpoDetailGrid);
		var LocId = $("#RecLoc").combobox('getValue');
		var LocDesc = $("#RecLoc").combobox('getText');
		var Dafult={
			PoStartDate: DefaultStDate(),
			PoEndDate: DefaultEdDate(),
			PoRecLoc: {RowId: LocId, Description: LocDesc},
			Status:0
		};
		$UI.fillBlock('#PoConditions',Dafult);
	}
	InpoIngrClear();
	QueryInpoIngrInfo();
}