/* 四川阳光采购 合同信息查询*/
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
	/// 下载合同产品
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
	            $UI.msg('alert', '下载采购目录时平台产品ID和日期不能同时为空！');
                return;
            }
            if (CurPage=="")
            {
	            $UI.msg('alert', '下载时当前页码不能为空！');
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
					$UI.msg('success',"下载成功!");
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
			title: '合同ID',
			field: 'PCTcontractId',
			width: 180,
			sortable: true
		},{
			title: '合同明细ID',
			field: 'PCTdetailId',
			width: 180,
			sortable: true
		}, {
			title: '合同状态',
			field: 'PCTcontractStatus',
			width: 180
		}, {
			title: '医院名称',
			field: 'hospitalName',
			width: 100
		}, {
			title: '医院负责人',
			field: 'lawerHospital',
			width: 150
		}, {
			title: '医院联系电话',
			field: 'phoneHospital',
			width: 150
		}, {
			title: '医疗机构签订状态',
			field: 'PCThospitalSignStatus',
			width: 150,
			align: 'left'
		}, {
			title: '医院签订日期',
			field: 'hospitalSignDate',
			width: 200
		}, {
			title: '医院签订时间',
			field: 'hospitalSignTime',
			width: 200
		}, {
			title: '生产企业编号',
			field: 'companyIdSc',
			width: 200
		}, {
			title: '生产企业名称',
			field: 'PCTCompanyNameSc',
			width: 200
		}, {
			title: '生产企业联系电话',
			field: 'phoneCompsc',
			width: 200
		}, {
			title: '生产企业负责人',
			field: 'lawerCompanyName',
			width: 200
		}, {
			title: '生产企业签订状态',
			field: 'PCTcompanyScSignStatus',
			width: 200
		}, {
			title: '生产企业签订日期',
			field: 'companyScSignDate',
			width: 200
		}, {
			title: '生产企业签订时间',
			field: 'companyScSignTime',
			width: 200
		}, {
			title: '配送方编号',
			field: 'companyIdPs',
			width: 200
		}, {
			title: '配送方名称',
			field: 'PCTcompanyNamePs',
			width: 200
		},{
			title : "配送方签订状态",
			field : 'PCTcompanyPsSignStatus',
			width : 100
		},{
			title : "配送方签订日期",
			field : 'companyPsSignDate',
			width : 100
		},{
			title : "配送方签订时间",
			field : 'companyPsSignTime',
			width : 50
		},{
			title : "配送方法定代表人",
			field : 'lawerCompPs',
			width : 100
		},{
			title : "配送企业联系电话",
			field : 'phoneCompPs',
			width : 80
		},{
			title : "注册证名称",
			field : 'regCername',
			width : 80
		},{
			title : "注册证号",
			field : 'regCerno',
			width : 80
		},{
			title : "合同明细采购总价",
			field : 'amount',
			width : 80
		},{
			title : "中选价格",
			field : 'PCTcontractPrice',
			width : 80
		},{
			title : "合同量",
			field : 'PCTcontractNumber',
			width : 80
		},{
			title : "合同完成量",
			field : 'accomplishment',
			width : 80
		},{
			title : "变更日期",
			field : 'LastUpdateDate',
			width : 80,
		},{
			title : "变更时间",
			field : 'LastUpdateTime',
			width : 80
		},{
			title : "下载日期",
			field : 'PCTDownDate',
			width : 80
		},{
			title : "下载时间",
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

