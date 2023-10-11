/* �Ĵ�����ɹ� ��ͬ��Ϣ��ѯ*/
function SCQueryProContract(){
	$HUI.dialog('#SCProContractWin',{width: gWinWidth, height: gWinHeight}).open();
	$UI.linkbutton('#SCProConSearchBT',{
		onClick:function(){
			SCProConQuery();
		}
	});
	function SCProConQuery(){
		var Row=SCProContractGrid.getSelected();
		if(!isEmpty(Row)){
			$UI.clear(SCProContractGrid);
		}
		var ParamsObj = $UI.loopBlock('#ProConConditions');
		var SCcontractIds=ParamsObj.SCcontractIds;
		var Params=SCcontractIds;
		SCProContractGrid.load({
			ClassName: 'web.DHCSTMHUI.ServiceForSCYGCG',
			MethodName: 'JSQueryProContract',
			Params:Params
		});
	}
	$UI.linkbutton('#SCProConClearBT',{
		onClick:function(){
			SCProConClear();
		}
	});
	function SCProConClear(){
		$UI.clearBlock('#ProConConditions');
		$UI.clear(SCProContractGrid);
		var ProConDafult = {
			SCProConStartDate: DateFormatter(new Date()),
			SCProConEndDate: DateFormatter(new Date()),
			SCProConStartTime:"00:00:00",
			SCProConEndTime:"23:59:59",
			SCPCCurPage:1
			
		};
		$UI.fillBlock('#ProConConditions', ProConDafult);
	}
	/// ���غ�ͬ��Ʒ
	$UI.linkbutton('#SCProConDownBT', {
		onClick: function () {
			SCProConDown();
		}
	});
	function SCProConDown() {
			$UI.clear(SCProContractGrid);
			var ParamsObj = $UI.loopBlock('#ProConConditions');
			var CurPage=ParamsObj.SCPCCurPage;
			var StartDate=ParamsObj.SCProConStartDate;
			var EndDate=ParamsObj.SCProConEndDate;
			var SCcontractIds=ParamsObj.SCcontractIds;
			var UserId=gUserId;
			if ((SCcontractIds=="")&&((StartDate=="")||(EndDate=="")))
            {
	            $UI.msg('alert', '���زɹ�Ŀ¼ʱƽ̨��ƷID�����ڲ���ͬʱΪ�գ�');
                return;
            }
            if (CurPage=="")
            {
	            $UI.msg('alert', '����ʱ��ǰҳ�벻��Ϊ�գ�');
                return;
            }
		     showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.ServiceForSCYGCG',
				MethodName: 'GetProContInfo',
				CurPage: CurPage,
				PCStartDate:StartDate,
				PCEndDate:EndDate,
				contractIds:SCcontractIds,
				UserId:UserId
			},function(jsonData){
				hideMask();
				if(jsonData.success==0){
					$UI.msg('success',"���سɹ�!");
					var info=jsonData.msg;
					var infoArr = info.split("^");
					var SCPCTotalPage=infoArr[0];
					var TotalRecordCount=infoArr[1];
					if (Number(TotalRecordCount)>=0){
						$("#SCPCTotalPage").val(SCPCTotalPage);
						$("#SCPCTotalRecord").val(TotalRecordCount);
					}
					SCProContractGrid.load({
						ClassName: 'web.DHCSTMHUI.ServiceForSCYGCG',
						MethodName: 'JSQueryProContract'
					});
				}else{
					$UI.msg('error',jsonData.msg);		
				}
			});
	}
	var SCProContractCm = [[{
			title: 'DHCMPCTRowId',
			field: 'DHCMPCTRowId',
			width: 180,
			sortable: true,
			hidden: true
		},{
			title: '��ͬID',
			field: 'PCTcontractId',
			width: 180,
			sortable: true
		},{
			title: '��ͬ��ϸID',
			field: 'PCTdetailId',
			width: 180,
			sortable: true
		}, {
			title: '��ͬ״̬',
			field: 'PCTcontractStatus',
			width: 180
		}, {
			title: 'ҽԺ����',
			field: 'hospitalName',
			width: 100
		}, {
			title: 'ҽԺ������',
			field: 'lawerHospital',
			width: 150
		}, {
			title: 'ҽԺ��ϵ�绰',
			field: 'phoneHospital',
			width: 150
		}, {
			title: 'ҽ�ƻ���ǩ��״̬',
			field: 'PCThospitalSignStatus',
			width: 150,
			align: 'left'
		}, {
			title: 'ҽԺǩ������',
			field: 'hospitalSignDate',
			width: 200
		}, {
			title: 'ҽԺǩ��ʱ��',
			field: 'hospitalSignTime',
			width: 200
		}, {
			title: '������ҵ���',
			field: 'companyIdSc',
			width: 200
		}, {
			title: '������ҵ����',
			field: 'PCTCompanyNameSc',
			width: 200
		}, {
			title: '������ҵ��ϵ�绰',
			field: 'phoneCompsc',
			width: 200
		}, {
			title: '������ҵ������',
			field: 'lawerCompanyName',
			width: 200
		}, {
			title: '������ҵǩ��״̬',
			field: 'PCTcompanyScSignStatus',
			width: 200
		}, {
			title: '������ҵǩ������',
			field: 'companyScSignDate',
			width: 200
		}, {
			title: '������ҵǩ��ʱ��',
			field: 'companyScSignTime',
			width: 200
		}, {
			title: '���ͷ����',
			field: 'companyIdPs',
			width: 200
		}, {
			title: '���ͷ�����',
			field: 'PCTcompanyNamePs',
			width: 200
		},{
			title : "���ͷ�ǩ��״̬",
			field : 'PCTcompanyPsSignStatus',
			width : 100
		},{
			title : "���ͷ�ǩ������",
			field : 'companyPsSignDate',
			width : 100
		},{
			title : "���ͷ�ǩ��ʱ��",
			field : 'companyPsSignTime',
			width : 50
		},{
			title : "���ͷ�����������",
			field : 'lawerCompPs',
			width : 100
		},{
			title : "������ҵ��ϵ�绰",
			field : 'phoneCompPs',
			width : 80
		},{
			title : "ע��֤����",
			field : 'regCername',
			width : 80
		},{
			title : "ע��֤��",
			field : 'regCerno',
			width : 80
		},{
			title : "��ͬ��ϸ�ɹ��ܼ�",
			field : 'amount',
			width : 80
		},{
			title : "��ѡ�۸�",
			field : 'PCTcontractPrice',
			width : 80
		},{
			title : "��ͬ��",
			field : 'PCTcontractNumber',
			width : 80
		},{
			title : "��ͬ�����",
			field : 'accomplishment',
			width : 80
		},{
			title : "�������",
			field : 'LastUpdateDate',
			width : 80,
		},{
			title : "���ʱ��",
			field : 'LastUpdateTime',
			width : 80
		},{
			title : "��������",
			field : 'PCTDownDate',
			width : 80
		},{
			title : "����ʱ��",
			field : 'PCTDownTime',
			width : 100
		}
	]];
	var SCProContractGrid = $UI.datagrid('#SCProContractGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.ServiceForSCYGCG',
			MethodName: 'JSQueryProContract'
		},
		columns: SCProContractCm,
		showBar:true,
		idField: 'DHCMPCTRowId',
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				SCProContractGrid.selectRow(0);
				var SelectedRow = SCProContractGrid.getSelected();
				var TotalPageCount=SelectedRow.totalPageCount;
				var TotalRecordCount=SelectedRow.totalRecordCount;
				$("#SCPCTotalPage").val(TotalPageCount);
				$("#SCPCTotalRecord").val(TotalRecordCount);
			}
		}
	});
	SCProConClear();
}

