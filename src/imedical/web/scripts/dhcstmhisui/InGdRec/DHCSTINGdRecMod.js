/*�������ⵥ��ѯ���޸�*/
var init = function() {
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			QueryIngrInfo();
		}
	});
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			IngrClear();
		}
	});
	$UI.linkbutton('#UpadateBT',{
		onClick:function(){
			UpadateData();
		}
	});
	$UI.linkbutton('#UpVendBT',{
		onClick:function(){
			UpVendData();
		}
	});
	$UI.linkbutton('#CancelAuditBT',{
		onClick:function(){
			CancelAudit();
		}
	});
	function UpadateData(){
		var Row=InGdRecMainGrid.getSelected();
		if(isEmpty(Row)){
			$UI.msg('alert','��ѡ��Ҫ����ĵ���!');
			return false;
		}
		var LocId=Row.RecLocId;
		var CheckParams = {LocId : LocId};
		var CheckRet = $.m({
			ClassName: 'web.DHCSTMHUI.Common.UtilCommon',
			MethodName: 'CheckBeforeInstk',
			Params: JSON.stringify(CheckParams)
		},false);
		if(!isEmpty(CheckRet)){
			$UI.msg('alert', CheckRet);
			return false;
		}
		var MainObj=$UI.loopBlock('#FindConditions');
		var Main=JSON.stringify(MainObj);
		var DetailObj=InGdRecDetailGrid.getChangesData('RowId');
		if (DetailObj === false){	//δ��ɱ༭����ϸΪ��
			return false;
		}
		if (isEmpty(DetailObj)){	//��ϸ����
			$UI.msg("alert", "û����Ҫ�������ϸ!");
			return false;
		}
		var Detail=JSON.stringify(DetailObj);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRecMod',
			MethodName: 'UpdateRecInfo',
			ListData: Detail
		},function(jsonData){
			hideMask();
			$UI.msg('alert',jsonData.msg);
			if(jsonData.success==0){
				QueryIngrInfo();
			}
		});
	}
	function UpVendData(){
		var MainObj=$UI.loopBlock('#FindConditions');
		var newVendorId=MainObj.FVendorBox;
		if(isEmpty(newVendorId)){
			$UI.msg('alert','��ѡ��Ӧ��!');
			return false;
		}
		var Row=InGdRecMainGrid.getSelected();
		if(isEmpty(Row)){
			$UI.msg('alert','��ѡ��Ҫ����ĵ���!');
			return false;
		}
		var LocId=Row.RecLocId;
		var CheckParams = {LocId : LocId};
		var CheckRet = $.m({
			ClassName: 'web.DHCSTMHUI.Common.UtilCommon',
			MethodName: 'CheckBeforeInstk',
			Params: JSON.stringify(CheckParams)
		},false);
		if(!isEmpty(CheckRet)){
			$UI.msg('alert', CheckRet);
			return false;
		}
		var oldVendorId=Row.Vendor;
		if(newVendorId==oldVendorId){
			return false;
		}
		var IngrId=Row.IngrId;
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRecMod',
			MethodName: 'GrUpdateVen',
			IngrId: IngrId,
			VendorId: newVendorId
		},function(jsonData){
			hideMask();
			$UI.msg('alert',jsonData.msg);
			if(jsonData.success==0){
				QueryIngrInfo();
			}
		});
	}
	function CancelAudit(){
		var Row=InGdRecMainGrid.getSelected();
		if(isEmpty(Row)){
			$UI.msg('alert','��ѡ��Ҫȡ����˵ĵ���!');
			return false;
		}
		var LocId=Row.RecLocId;
		var CheckParams = {LocId : LocId};
		var CheckRet = $.m({
			ClassName: 'web.DHCSTMHUI.Common.UtilCommon',
			MethodName: 'CheckBeforeInstk',
			Params: JSON.stringify(CheckParams)
		},false);
		if(!isEmpty(CheckRet)){
			$UI.msg('alert', CheckRet);
			return false;
		}
		var IngrId=Row.IngrId;
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRecMod',
			MethodName: 'GrCancelAudit',
			IngrId: IngrId
		},function(jsonData){
			hideMask();
			$UI.msg('alert',jsonData.msg);
			if(jsonData.success==0){
				QueryIngrInfo();
			}
		});
	}
	$UI.linkbutton('#PrintBT',{
		onClick:function(){
			var Row=InGdRecMainGrid.getSelected();
			if(isEmpty(Row)){
				$UI.msg('alert','��ѡ����Ҫ��ӡ����Ϣ!');
				return false;
			}
			var Rowid=Row.IngrId;
			PrintRec(Rowid);
		}
	});

	$UI.linkbutton('#PrintHVColBT',{
		onClick:function(){
			var Row=InGdRecMainGrid.getSelected();
			if(isEmpty(Row)){
				$UI.msg('alert','��ѡ����Ҫ��ӡ����Ϣ!');
				return false;
			}
			var Rowid=Row.IngrId;
			PrintRecHVCol(Rowid);
		}
	});
	var FRecLocParams=JSON.stringify(addSessionParams({Type:"Login"}));
	var FRecLocBox = $HUI.combobox('#FRecLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+FRecLocParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	var FVendorBoxParams=JSON.stringify(addSessionParams({APCType:"M",RcFlag:"Y"}));
	var FVendorBox = $HUI.combobox('#FVendorBox', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+FVendorBoxParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	var PhManufacturerParams=JSON.stringify(addSessionParams({StkType:"M"}));
	var PhManufacturerBox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params='+PhManufacturerParams,
			valueField: 'RowId',
			textField: 'Description',
			onBeforeLoad:function(param){
				//var ScgId=GetParamsObj().StkGrpId;
				//param.ScgId =ScgId;
			}
		}
	};
	var InGdRecMainCm = [[{
			title : "RowId",
			field : 'IngrId',
			width : 100,
			hidden : true
		}, {
			title : "��ⵥ��",
			field : 'IngrNo',
			width : 120
		}, {
			title : "VenId",
			field : 'VenId',
			width : 200,
			hidden : true
		}, {
			title : "��Ӧ��",
			field : 'Vendor',
			width : 200
		},{
			title : "RecLocId",
			field : 'RecLocId',
			width : 100,
			hidden : true
		}, {
			title : '������',
			field : 'ReqLocDesc',
			width : 150
		}, {
			title : '��������',
			field : 'ReqLocDesc',
			width : 150
		}, {
			title : '������',
			field : 'AcceptUser',
			width : 70
		}, {
			title : '��������',
			field : 'CreateDate',
			width : 90
		}, {
			title : '�ɹ�Ա',
			field : 'PurchUser',
			width : 70
		}, {
			title : "��ɱ�־",
			field : 'Complete',
			width : 70
		}, {
			title : "���۽��",
			field : 'RpAmt',
			width : 100,
	        align : 'right'
		}, {
			title : "�ۼ۽��",
			field : 'SpAmt',
			width : 100,
	        align : 'right'
		}	
	]];
	
	var InGdRecMainGrid = $UI.datagrid('#InGdRecMainGrid', {
		url: '',
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			QueryName: 'Query'
		},
		columns: InGdRecMainCm,
		showBar:true,
		onSelect:function(index, row){
			var VenId=row.VenId;
			var Vendor=row.Vendor;
			var VenObj = {RowId: VenId, Description: Vendor};
			$('#FVendorBox').combobox('setValue',VenId);
			$UI.setUrl(InGdRecDetailGrid);
			InGdRecDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
				QueryName: 'QueryDetail',
				Parref: row.IngrId,
				rows: 99999
			});
		}
	})
	
	var InGdRecDetailCm = [[{
			title : "RowId",
			field : 'RowId',
			width : 100,
			hidden : true
		}, {
			title : '���ʴ���',
			field : 'IncCode',
			width : 80
		}, {
			title : '��������',
			field : 'IncDesc',
			width : 230
		}, {
			title : "���",
			field : 'Spec',
			width : 180
		}, {
			title : "������",
			field : 'SpecDesc',
			width : 180,
			hidden : true
		}, {
			title : "����",
			field : 'ManfId',
			width : 180,
			formatter: CommonFormatter(PhManufacturerBox,'ManfId','Manf'),
			editor:PhManufacturerBox
		}, {
			title : "����",
			field : 'BatchNo',
			width : 90,
			editor:{
				type:'text'
				}
		}, {
			title : "��Ч��",
			field : 'ExpDate',
			width : 100,
			editor:{
				type:'datebox'
				}
		},{
			title : "����Ҫ��",
			field : 'BatchReq',
			width : 80,
			hidden : true
		},{
			title : "��Ч��Ҫ��",
			field : 'ExpReq',
			width : 80,
			hidden : true
		}, {
			title : "��λ",
			field : 'IngrUom',
			width : 80
		}, {
			title : "����",
			field : 'RecQty',
			width : 80,
	        align : 'right'
		}, {
			title : "����",
			field : 'Rp',
			width : 60,
	        align : 'right',
			editor:{
				type:'numberbox',
				options:{
					required:true
					}
				}
		}, {
			title : "ע��֤��",
			field : 'AdmNo',
			width : 80,
			hidden : true
		}, {
			title : "ע��֤��Ч��",
			field : 'AdmExpdate',
			width : 80,
			hidden : true
		}, {
			title : "ժҪ",
			field : 'Remark',
			width : 60,
			hidden : true
		}, {
			title : "�ۼ�",
			field : 'Sp',
			width : 60,
	        align : 'right'
		}, {
			title : "��Ʊ��",
			field : 'InvNo',
			width : 80,
			editor:{
				type:'text'
				}
		}, {
			title : "��Ʊ����",
			field : 'InvDate',
			width : 100,
			editor:{
				type:'datebox',
				options:{
					}
				}
		}, {
			title :"��Ʊ���",
			field :'InvMoney',
			width :80,
	        align : 'right',
			editor:{
				type:'numberbox'
				}
		}, {
			title : "���۽��",
			field : 'RpAmt',
			width : 100,
	        align : 'right'
		}, {
			title : "�ۼ۽��",
			field : 'SpAmt',
			width : 100,
	        align : 'right'
		},{
			title : "���е���",
			field : 'SxNo',
			width : 90,
			editor:{
				type:'text'
				}
		}, {
			title : '��ֵ����',
			field : 'HVBarCode',
			width : 80
		}, {
			title : '�Դ�����',
			field : 'OrigiBarCode',
			width : 80
		}			
	]];
	
	var InGdRecDetailGrid = $UI.datagrid('#InGdRecDetailGrid', {
		url: '',
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
			QueryName: 'QueryDetail',
			rows: 99999
		},
		pagination:false,
		columns: InGdRecDetailCm, 
		showBar:true,  
		onClickCell: function(index, field ,value){	
			var Row = InGdRecDetailGrid.getRows()[index];
			if ((field == 'ExpDate')&&(Row.ExpReq=="N")) {
				return false;
			}
			if ((field == 'BatchNo')&&(Row.BatchReq=="N")) {
				return false;
			}
			InGdRecDetailGrid.commonClickCell(index,field,value)
		}
	})
	function QueryIngrInfo(){
		$UI.clear(InGdRecMainGrid);
		$UI.clear(InGdRecDetailGrid);
		var ParamsObj=$UI.loopBlock('#FindConditions')
		if(isEmpty(ParamsObj.StartDate)){
			$UI.msg('alert','��ʼ���ڲ���Ϊ��!');
			return;
		}
		if(isEmpty(ParamsObj.EndDate)){
			$UI.msg('alert','��ֹ���ڲ���Ϊ��!');
			return;
		}
		if(isEmpty(ParamsObj.FRecLoc)){
			$UI.msg('alert','���Ҳ���Ϊ��!');
			return;
		}	
		var Params=JSON.stringify(ParamsObj);
		$UI.setUrl(InGdRecMainGrid)
		InGdRecMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			QueryName: 'Query',
			Params:Params
		});
	
	}
	function IngrClear() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(InGdRecMainGrid);
		$UI.clear(InGdRecDetailGrid);
		var Dafult={StartDate: DefaultStDate(),
					EndDate: DefaultEdDate(),
					FRecLoc:gLocObj,
					AuditFlag:"Y"
					}
		$UI.fillBlock('#FindConditions',Dafult);
	
	}
	IngrClear();
}
$(init);