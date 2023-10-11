/* �Ĵ�����ɹ� ��Ʒ����*/
function SCPurPlanCodeEdit(){
	var Inci=$('#Inci').val();
	if(isEmpty(Inci)){
		$UI.msg('alert','����ѡ����Ҫ���յĿ����!')
		return;
	}
	$HUI.dialog('#SCPurinfoWin',{width: gWinWidth, height: gWinHeight}).open();
	
	var ProcurecatalogType = $HUI.combobox('#ProcurecatalogType', {
		data: [
			{'RowId': '1', 'Description': '����ר��'},
			{'RowId': '0', 'Description': '�۸�������Ʒ'},
			{'RowId': '3', 'Description': '����'}
		],
		valueField: 'RowId',
		textField: 'Description'
	});
	var ScBid = $HUI.combobox('#ScBid', {
		data: [
			{'RowId': '1', 'Description': '���ҵ�һ����(����֧��)'},
			{'RowId': '2', 'Description': 'ʡ�����˵�һ����(������������)'},
			{'RowId': '3', 'Description': '���ҵڶ�����(�˹��ؽ�)'},
			{'RowId': '4', 'Description': '"3+N"����(����ҩ��������)'},
			{'RowId': '5', 'Description': '"3+N"����(�˹�������))'},
			{'RowId': '6', 'Description': '"3+N"����(������)'},
			{'RowId': '7', 'Description': '"3+N"����(�ǿƴ���)'},
		],
		valueField: 'RowId',
		textField: 'Description'
	});
	$UI.linkbutton('#SCPQueryBT',{
		onClick:function(){
			SCFindQuery();
		}
	});
	function SCFindQuery(){
		$UI.clear(SCPurinfoGrid);
		var ParamsObj = $UI.loopBlock('#SCFindConditions');
		var PurCode=ParamsObj.SCPurCode;
		var SCPurName=ParamsObj.SCPurName;
		var PurSubCode="";
		var Params=PurSubCode+"^"+PurCode+"^"+SCPurName+"^";
		SCPurinfoGrid.load({
			ClassName: 'web.DHCSTMHUI.ServiceForSCYGCG',
			MethodName: 'JSQueryMatPurCatalogNew',
			Params:Params
		});
	}
	$UI.linkbutton('#SCPDownloadBT',{
		onClick:function(){
			$UI.clear(SCPurinfoGrid);
			var ParamsObj = $UI.loopBlock('#SCFindConditions');
			var CurPage=ParamsObj.SCCurPageNumber;
			var SCPurCode=ParamsObj.SCPurCode;
			var UserId=ParamsObj.gUserId;
			var ProcurecatalogType=ParamsObj.ProcurecatalogType;
			var ScBid=ParamsObj.ScBid;
			if(isEmpty(ProcurecatalogType)){
				$UI.msg('alert', '��Ʒ���Ͳ���Ϊ�գ�');
				return;	
			}
			if(isEmpty(ScBid)){
				$UI.msg('alert', '�������β���Ϊ�գ�');
				return;	
			}
            if (CurPage=="")
            {
	            $UI.msg('alert', '���زɹ�Ŀ¼ʱ��ǰҳ�벻��Ϊ�գ�');
                return;
            }
		     showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.ServiceForSCYGCG',
				MethodName: 'GetProductInfo',
				CurPage: CurPage,
				GoodIds:SCPurCode,
				UserId:UserId,
				ProcurecatalogType:ProcurecatalogType,
				ScBid:ScBid
			},function(jsonData){
				hideMask();
				if(jsonData.success==0){
					$UI.msg('success',"���سɹ�!");
					var info=jsonData.msg;
					var infoArr = info.split("^");
					var SCTotalPageCount=infoArr[0];
					var SCTotalRecordCount=infoArr[1];
					if (Number(SCTotalRecordCount)>=0){
						$("#SCTotalPageCount").val(SCTotalPageCount);
						$("#SCTotalRecordCount").val(SCTotalRecordCount);
					}
					SCPurinfoGrid.load({
						ClassName: 'web.DHCSTMHUI.ServiceForSCYGCG',
						MethodName: 'JSQueryMatPurCatalogNew'
					});
				}else{
					$UI.msg('error',jsonData.msg);		
					SCPurinfoGrid.load({
						ClassName: 'web.DHCSTMHUI.ServiceForSCYGCG',
						MethodName: 'JSQueryMatPurCatalogNew'
					});
				}
			});
		}	
	});
	$UI.linkbutton('#SCPMatchBT',{
		onClick:function(){
			var RelaRet=tkMakeServerCall("web.DHCSTMHUI.ServiceForSCYGCG","UpDateInciLogFlag",Inci);
		    if(RelaRet!=0){
		    	$UI.confirm('�ÿ�����Ѵ��ڶ��չ�ϵ,���ȷ������¶��չ�ϵ,�Ƿ����?', '', '',SCMatch);
		    }else{
		    	SCMatch();
		    }
		}	
	});
	function SCMatch(){
		var Row=SCPurinfoGrid.getSelected();
		if(isEmpty(Row)){
			$UI.msg('alert', '��ѡ����Ҫ���յ�ƽ̨�ɹ���Ϣ!');
			return;
		}
		var MPCId = Row.MPCId;
		if(isEmpty(MPCId)){
			$UI.msg('alert', '����ѡ��Ҫȡ�����յ�ƽ̨�ɹ���Ϣ!');
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.ServiceForSCYGCG',
			MethodName: 'SaveRelaInfo',
			Inci: Inci,
			Matrowid:MPCId,
			UpFlag:1
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success',"���ճɹ���");
				GetDetail(Inci);
				$HUI.dialog('#SCPurinfoWin').close();
			}else{
				$UI.msg('error',jsonData.msg);		
			}
		});
	}
	$UI.linkbutton('#SCPCanMatchBT',{
		onClick:function(){	
			var Row=SCPurinfoGrid.getSelected();
			if(isEmpty(Row)){
				$UI.msg('alert', '����ѡ��Ҫȡ�����յ�ƽ̨�ɹ���Ϣ!');
				return;
			}
			var MPCId = Row.MPCId;
			if(isEmpty(MPCId)){
				$UI.msg('alert', '����ѡ��Ҫȡ�����յ�ƽ̨�ɹ���Ϣ!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.ServiceForSCYGCG',
				MethodName: 'SaveRelaInfo',
				Inci: Inci,
				Matrowid:MPCId,
				UpFlag:0
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					GetDetail(Inci);
					SCPurinfoGrid.load({
						ClassName: 'web.DHCSTMHUI.ServiceForSCYGCG',
						MethodName: 'JSQueryMatPurCatalogNew'
					});
				}else{
					$UI.msg('error',jsonData.msg);		
				}
			});				
		}	
	});
	$UI.linkbutton('#SCPClearBT',{
		onClick:function(){
			SCClear();
		}
	});
	function SCClear(){
		$UI.clearBlock('#SCFindConditions');
		$UI.clear(SCPurinfoGrid);
		var Dafult = {
			SCCurPageNumber:1
			
		};
		$UI.fillBlock('#SCFindConditions', Dafult);
	}
	var PurinfoCm = [[{
			title: 'MPCId',
			field: 'MPCId',
			width: 50,
			hidden: true
		}, {
			title: '�����ID',
			field: 'INCI',
			width: 80,
			sortable: true,
			hidden: true
		}, {
			title: '��������',
			field: 'InciCode',
			width: 100,
			sortable: true
		}, {
			title: '��Ʒ���',
			field: 'GoodsId',
			width: 100,
			sortable: true
		}, {
			title: 'ͨ������',
			field: 'productName',
			width: 150
		}, {
			title: '��Ʒ����',
			field: 'GoodsName',
			width: 150
		}, {
			title: '���',
			field: 'OutLookc',
			width: 150
		}, {
			title: '�ͺ�',
			field: 'GoodsType',
			width: 150
		}, {
			title: '�����̱��',
			field: 'CompanyIdPs',
			width: 150
		}, {
			title: '������',
			field: 'CompanyNamePs',
			width: 150
		}, {
			title: '����',
			field: 'SortName',
			width: 100
		}, {
			title: '��λ',
			field: 'Unit',
			width: 80
		}, {
			title: 'ע��֤����',
			field: 'RegCodeName',
			width: 100
		}, {
			title: 'ע��֤��',
			field: 'regCerno',
			width: 100
		}, {
			title: 'ע��֤ID',
			field: 'regcode',
			width: 100
		}, {
			title: 'Ʒ��',
			field: 'Brand',
			width: 100
		}, {
			title: '��Դ',
			field: 'Source',
			width: 150
		}, {
			title: '�ɹ��۸�',
			field: 'PurchasePrice',
			width: 150
		}, {
			title: 'Ͷ����ҵ���',
			field: 'CompanyIdTb',
			width: 150
		}, {
			title: 'Ͷ����ҵ',
			field: 'CompanyNameTb',
			width: 150
		}, {
			title: '�ɹ����',
			field: 'PurchaseType',
			width: 150
		}, {
			title: '�����ɹ��۸�',
			field: 'DailPurchasePrice',
			width: 150
		}, {
			title: '�����ɹ����ͱ�ʶ',
			field: 'PurchaseIDentification',
			width: 150
		}, {
			title: '�������',
			field: 'AddDate',
			width: 150
		}, {
			title: '���ʱ��',
			field: 'AddTime',
			width: 150
		}, {
			title: '�������',
			field: 'LastUpdateDate',
			width: 150
		}, {
			title: '���ʱ��',
			field: 'LastUpdateTime',
			width: 150
		}, {
			title: '��������',
			field: 'DownDate',
			width: 150
		}, {
			title: '����ʱ��',
			field: 'DownTime',
			width: 150
		}, {
			title: '������',
			field: 'DownUser',
			width: 150
		}, {
			title: '�۸�״̬',
			field: 'bargainStatus',
			width: 150
		}, {
			title: 'ҽ������',
			field: 'ybCode',
			width: 150
		}, {
			title: '��ѡ�۸�',
			field: 'DailPurchasePrice',
			width: 150
		}
	]];

	var SCPurinfoGrid = $UI.datagrid('#SCPurinfoGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.ServiceForSCYGCG',
			MethodName: 'JSQueryMatPurCatalogNew'
		},
		columns: PurinfoCm,
		idField: 'MPCId',
		showBar:true,
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				SCPurinfoGrid.selectRow(0);
			}
		}
	});

	SCClear();
	SCFindQuery();
}