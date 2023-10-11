/* �Ĵ�����ɹ� ��ҵ����*/
function SCQueryComany(HISComId,HISComType){
	if(isEmpty(HISComId)){
		$UI.msg('alert','����ѡ����Ҫ���յ���ҵ!')
		return;
	}
	$HUI.dialog('#SCCompanyWin',{width: gWinWidth, height: gWinHeight}).open();
	
	$UI.linkbutton('#SCComQueryBT',{
		onClick:function(){
			SCFindQuery();
		}
	});
	function SCFindQuery(){
		$UI.clear(SCCominfoGrid);
		var ParamsObj = $UI.loopBlock('#ComConditions');
		var ComCode=ParamsObj.ComCode;
		var SCComName=ParamsObj.SCComName;
		var Params=ComCode+"^"+SCComName+"^";
		SCCominfoGrid.load({
			ClassName: 'web.DHCSTMHUI.ServiceForSCYGCG',
			MethodName: 'JSQueryCompany',
			Params:Params
		});
	}
	$UI.linkbutton('#SCComDownloadBT',{
		onClick:function(){
			$UI.clear(SCCominfoGrid);
			var ParamsObj = $UI.loopBlock('#ComConditions');
			var CurPage=ParamsObj.SCCurPageNumber;
			var StartDate=ParamsObj.StartDate;
			var EndDate=ParamsObj.EndDate;
			var GoodIds=ParamsObj.ComCode;
			var UserId=gUserId;
			if ((GoodIds=="")&&((StartDate=="")||(EndDate=="")))
            {
	            $UI.msg('alert', '������ҵ��Ϣʱ��ҵ��ƷID�����ڲ���ͬʱΪ�գ�');
                return;
            }
            if (CurPage=="")
            {
	            $UI.msg('alert', '������ҵ��Ϣʱ��ǰҳ�벻��Ϊ�գ�');
                return;
            }
		     showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.ServiceForSCYGCG',
				MethodName: 'GetCompanyInfo',
				CurPage: CurPage,
				StartDate:StartDate,
				EndDate:EndDate,
				companyIds:GoodIds,
				userID:UserId
			},function(jsonData){
				hideMask();
				if(jsonData.success==0){
					$UI.msg('success',"���سɹ�!");
					var info=jsonData.msg;
					var infoArr = info.split("^");
					var SCTotalPageCount=infoArr[0];
					var SCTotalRecordCount=infoArr[1];
					if (Number(SCTotalPageCount)>=0){
						$("#SCTotalPageCount").val(SCTotalPageCount);
						$("#SCTotalRecordCount").val(SCTotalRecordCount);
					}
					SCFindQuery();
				}else{
					$UI.msg('error',jsonData.msg);		
				}
			});
		}	
	});
	$UI.linkbutton('#SCComMatchBT',{
		onClick:function(){
			SCMatch();
		}	
	});
	function SCMatch(){
		var Row=SCCominfoGrid.getSelected();
		if(isEmpty(Row)){
			$UI.msg('alert', '��ѡ����Ҫ���յ�ƽ̨��ҵ��Ϣ!');
				return;
			}
		var RowId = Row.RowId;
		$.cm({
			ClassName: 'web.DHCSTMHUI.ServiceForSCYGCG',
			MethodName: 'SaveComRelaInfo',
			CompanyId: HISComId,
			RowId:RowId,
			UpFlag:1,
			HIStype:HISComType
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success',"���ճɹ���");
				SCFindQuery();
			}else{
				$UI.msg('error',jsonData.msg);		
			}
		});
	}
	$UI.linkbutton('#SCComCanMatchBT',{
		onClick:function(){	
			var Row=SCCominfoGrid.getSelected();
			if(isEmpty(Row)){
				$UI.msg('alert', '����ѡ��Ҫȡ�����յ���ҵ��Ϣ!');
				return;
			}
			var RowId = Row.RowId;
			$.cm({
				ClassName: 'web.DHCSTMHUI.ServiceForSCYGCG',
				MethodName: 'SaveComRelaInfo',
				CompanyId: HISComId,
				RowId:RowId,
				UpFlag:0,
				HIStype:HISComType
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					SCFindQuery();
				}else{
					$UI.msg('error',jsonData.msg);		
				}
			});				
		}	
	});
	$UI.linkbutton('#SCComClearBT',{
		onClick:function(){
			SCClear();
		}
	});
	function SCClear(){
		$UI.clearBlock('#ComConditions');
		$UI.clear(SCCominfoGrid);
		var Dafult = {
			StartDate: DateFormatter(new Date()),
			EndDate: DateFormatter(new Date()),
			ComCode:"",
			SCComName:"",
			SCCurPageNumber:1
			
		};
		$UI.fillBlock('#ComConditions', Dafult);
	}
	var SCComCm = [[{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: 'HIS��ҵID',
			field: 'Pointer',
			width: 150
		}, {
			title: 'HIS��ҵ����',
			field: 'TypeDesc',
			width: 100
		}, {
			title: '��ҵ����',
			field: 'comtypedesc',
			width: 80
		},{
			title: '��ҵ���',
			field: 'DHCPCcompanyId',
			width: 100
		}, {
			title: '��ҵ����',
			field: 'DHCPCcompanyName',
			width: 80,
			sortable: true
		}, {
			title: '��ַ',
			field: 'DHCPCaddress',
			width: 100,
			sortable: true
		}, {
			title: '��ҵ��ϵ�绰',
			field: 'CcompanyContactTel',
			width: 100,
			sortable: true
		}, {
			title: '��ҵ�������',
			field: 'CcompanyContactFax',
			width: 100,
			sortable: true
		}, {
			title: '�ʱ�',
			field: 'DHCPCzipCode',
			width: 150
		}, {
			title: '����',
			field: 'DHCPCemail',
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
			title: 'Ӫҵִ��ע���',
			field: 'DHCPCBusinessLicense',
			width: 100
		}, {
			title: '����id��',
			field: 'AreaId',
			width: 100
		}, {
			title: '��������',
			field: 'AreaName',
			width: 100
		}, {
			title: '��ҵ�˺�',
			field: 'loginUserName',
			width: 100
		}
	]];

	var SCCominfoGrid = $UI.datagrid('#SCCominfoGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.ServiceForSCYGCG',
			MethodName: 'JSQueryCompany'
		},
		columns: SCComCm,
		idField: 'RowId',
		showBar:true,
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
			}
		}
	});

	SCClear();
	SCFindQuery();
}