/* �Ĵ�����ɹ� ƽ̨���͵���ѯ*/
function SCQueryPoDistrStatus(PoId){
	$HUI.dialog('#SCDistrstatusWin',{width: gWinWidth, height: gWinHeight}).open();
	$UI.linkbutton('#SCDistrSearchBT',{
		onClick:function(){
			SCDistrQuery();
		}
	});
	function SCDistrClear(){
		$UI.clearBlock('#SCDistrConditions');
		$UI.clear(SCPoDistrStatusGrid);
		var DistrDafult = {
			SCCurPage:1
		};
		$UI.fillBlock('#SCDistrConditions', DistrDafult);
	}
	///��ֵ���
	$UI.linkbutton('#SCSaveInGdRecBT', {
		onClick: function () {
			SCSaveIngr();
		}
	});
	function SCSaveIngr() {
		var RowsData = SCPoDistrStatusGrid.getSelections();
		// ��Ч����
		var count = 0;
		for (var i = 0; i < RowsData.length; i++) {
			var item = RowsData[i].Inci;
			if (!isEmpty(item)) {
				count++;
			}
		}
		if (RowsData.length <= 0 || count <= 0) {
			$UI.msg('alert', 'û����Ҫ������ϸ!');
			return false;
		}
		var MainInfo=tkMakeServerCall("web.DHCSTMHUI.ServiceForSCYGCG","GetPoInfoById",PoId)
        if(MainInfo==""){
	         $UI.msg('alert','�޷���ȡ�������������ʵ��');
			return;   
	     }
         var MainInfoArr=MainInfo.split("^");     
         var RecLoc=MainInfoArr[4];
         var PurchaseUser=MainInfoArr[2];
         var Vendor=MainInfoArr[1];
         var StkGrpId=MainInfoArr[3];
         var ReqLocId=MainInfoArr[5];       
         var Complete = "N";
		 var AdjCheque = "N";
		 var GiftFlag = "N";
		 var Main = JSON.stringify(addSessionParams({ RecLoc: RecLoc, PurchaseUser: PurchaseUser, ApcvmDr: Vendor, StkGrpId: StkGrpId, ReqLocId: ReqLocId, Complete: Complete, AdjCheque: AdjCheque, GiftFlag: GiftFlag, PoId: PoId }));
		 var ListDetail="";
		 for (var i = 0, Len = RowsData.length; i < Len; i++) {
			var RowData = RowsData[i];
			var IncId=RowData['Inci'];
			if(IncId==""){
				$UI.msg('alert', '��'+ (i + 1)+'�в�Ʒû����HIS�����Ķ��չ�ϵ,��˲�!');
				continue;
			}
			var orderDetailId=RowData['orderDetailID'];		//�ɹ�ƽ̨��ϸ���
			var warehouseCount=RowData['warehouseCount'];	//���ջ�����
			var distributeCount =RowData['distributeCount'];//��������
			if((warehouseCount!="")&&(distributeCount!="")){
				if(distributeCount-warehouseCount<=0){
					$UI.msg('alert', '��'+ (i + 1)+'���ջ��������ڵ�����������,��������������ⵥ!');
					continue;
				}
			}
			var DrugInfo=tkMakeServerCall("web.DHCSTMHUI.ServiceForSCYGCG","GetPoItmInfoHisUI",orderDetailId,PoId,"N");
			if(DrugInfo==""){
				$UI.msg('alert', '��ȡ������ϸ��Ϣʧ�ܣ�');
				return;   
	        }
	        var DrugInfoArr=DrugInfo.split("^");
	        var PoItmId=DrugInfoArr[0];
			var IngrUomId = DrugInfoArr[1];
			var Rp= DrugInfoArr[2];
			var Sp= DrugInfoArr[3];
			var ManfId = DrugInfoArr[4];
			//var ExpDate =DrugInfoArr[5];
			var BatchNo =RowData['batchRecordID'];
			var ExpDate =RowData['periodDate'];
			var InvNo =RowData['invoiceID'];
			var InvCode =RowData['invoiceCode'];
			var distributeId=RowData['distributionSerialID'];   //������ϸ��� ������ initm_OrderDetailSubId			
			var Remark="���ݲɹ�ƽ̨��������";
			var RecQty=distributeCount-warehouseCount;  // �������
			var NewSp= Sp;
			var DetailData ={Inpoi:PoItmId,IncId: IncId, IngrUomId: IngrUomId,RecQty:RecQty,Rp:Rp,ManfId:ManfId,Sp:Sp,NewSp:NewSp,BatchNo:BatchNo,ExpDate:ExpDate,InvNo:InvNo,InvCode:InvCode,OrderDetailSubId:distributeId,Remark:Remark};
			if(ListDetail==""){
				ListDetail=JSON.stringify(DetailData);
			}
			else{
				ListDetail=ListDetail+","+JSON.stringify(DetailData);
			}
		}
		if(ListDetail==""){
			$UI.msg('alert', 'û����Ҫ����������ϸ��');
			return;   
		}
		var Detail="["+ListDetail+"]";
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			MethodName: 'jsSave',
			MainInfo: Main,
			ListData: Detail
		}, function (jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				var IngrRowid = jsonData.rowid;
				var Str='dhcstmhui.ingdrec.csp?Rowid=' + IngrRowid;
				window.open(Str, '_blank', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1500,height=750,left=0,top=0')
				Clear()
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	/// ����ɹ�  ������ֵ��ⵥ ��ֵ����
	$UI.linkbutton('#SCLinkInGdRecBT', {
		onClick: function () {
			SCLinkInGdRec();
		}
	});
	function SCLinkInGdRec() {
		var RowsData = SCPoDistrStatusGrid.getSelections();
		// ��Ч����
		var count = 0;
		for (var i = 0; i < RowsData.length; i++) {
			var RowIndex = SCPoDistrStatusGrid.getRowIndex(RowsData[i]);
			var item = RowsData[i].Inci;
			var highflag = RowsData[i].highflag; 
			if (highflag!="Y") {
					$UI.msg('alert', '�Ǹ�ֵ�Ĳ�!');
					SCPoDistrStatusGrid.unselectRow(RowIndex);
					continue;
				}
			
			if (!isEmpty(item)) {
				count++;
			}
		}
		if (RowsData.length <= 0 || count <= 0) {
			$UI.msg('alert', 'û����Ҫ�������ϸ!');
			return false;
		}
		var Detail=JSON.stringify(RowsData);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.ServiceForSCYGCG',
			MethodName: 'JSLinkInGdRec',
			ListData: Detail
		}, function (jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				var IngrRowid = jsonData.rowid;
				Clear()
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	var SCPoDistrStatusCm = [[
		{
			field: 'check',
			checkbox: true
		},{
			title: '������ϸ���',
			field: 'orderDetailID',
			width: 180,
			sortable: true
		}, {
			title: '������ϸ���',
			field: 'distributionSerialID',
			width: 180
		}, {
			title: '�����ID',
			field: 'Inci',
			width: 100
		}, {
			title: '��������',
			field: 'InciCode',
			width: 100
		}, {
			title: '���������',
			field: 'InciDesc',
			width: 100
		}, {
			title: '��Ʊ��',
			field: 'invoiceID',
			width: 150
		}, {
			title: '��Ʊ����',
			field: 'invoiceCode',
			width: 150
		}, {
			title: '����',
			field: 'batchRecordID',
			width: 150
		}, {
			title: 'Ч��',
			field: 'periodDate',
			width: 150
		}, {
			title: '��������',
			field: 'distributeCount',
			width: 150,
			align: 'left'
		}, {
			title: '��������',
			field: 'distriDate',
			width: 200
		}, {
			title: '����ʱ��',
			field: 'distriTime',
			width: 200
		}, {
			title: '�������',
			field: 'warehouseCount',
			width: 200
		}, {
			title: '�������',
			field: 'IngdrecDate',
			width: 200
		}, {
			title: '���ʱ��',
			field: 'IngdrecTime',
			width: 200
		}, {
			title: '��ҳ��',
			field: 'totalPageCount',
			width: 200,
			hidden:true
		}, {
			title: '������',
			field: 'totalRecordCount',
			width: 200,
			hidden:true
		}, {
			title: '�Ƿ��ֵ',
			field: 'highflag',
			width: 80 
		}, {
			title: '�Զ���������Ϣ',
			field: 'distributeCustomInfo',
			width: 200
		}, {
			title: '�����Ʊ',
			field: 'invoicePrimaryIds',
			width: 200
		}, {
			title: '��Ʊ��֤״̬',
			field: 'invoiceValidState',
			width: 200
		}, {
			title: '��Ʊ��֤��ע��Ϣ',
			field: 'invoiceValidRemark',
			width: 200
		}, {
			title: '������ϸ���͵�ַ',
			field: 'detailDistributeAddress',
			width: 200
		}
	]];
	var SCPoDistrStatusGrid = $UI.datagrid('#SCPoDistrStatusGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.ServiceForSCYGCG',
			MethodName: 'JSQueryPoItmDispatching',
			rows:99999
		},
		columns: SCPoDistrStatusCm,
		showBar:true,
		idField: 'distributionSerialID',
		pagination: false,
		singleSelect: false,
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				SCPoDistrStatusGrid.selectRow(0);
				var SelectedRow = SCPoDistrStatusGrid.getSelected();
				var TotalPageCount=SelectedRow.totalPageCount;
				var TotalRecordCount=SelectedRow.totalRecordCount;
				$("#SCTotalPage").val(TotalPageCount);
				$("#SCTotalRecord").val(TotalRecordCount);
			}
		}
	});
	
	function SCDistrQuery(){
		var Row=SCPoDistrStatusGrid.getSelected();
		if(!isEmpty(Row)){
			$UI.clear(SCPoDistrStatusGrid);
		}
		var ParamsObj = $UI.loopBlock('#SCDistrConditions');
		var Page=ParamsObj.SCCurPage;
		if((Page=="")||(isEmpty(Page))){
			$UI.msg('alert','��ǰҳ�벻��Ϊ��');
			return;
		}
		SCPoDistrStatusGrid.load({
			ClassName: 'web.DHCSTMHUI.ServiceForSCYGCG',
			MethodName: 'JSQueryPoItmDispatching',
			rows:99999,
			Page:Page,
			PoId:PoId
		});
	}
	SCDistrClear();
	SCDistrQuery();
}

