/* 四川阳光采购 企业对照*/
function SCQueryComany(HISComId,HISComType){
	if(isEmpty(HISComId)){
		$UI.msg('alert','请先选择需要对照的企业!')
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
	            $UI.msg('alert', '下载企业信息时企业产品ID和日期不能同时为空！');
                return;
            }
            if (CurPage=="")
            {
	            $UI.msg('alert', '下载企业信息时当前页码不能为空！');
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
					$UI.msg('success',"下载成功!");
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
			$UI.msg('alert', '请选择需要对照的平台企业信息!');
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
				$UI.msg('success',"对照成功！");
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
				$UI.msg('alert', '请先选择要取消对照的企业信息!');
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
			title: 'HIS企业ID',
			field: 'Pointer',
			width: 150
		}, {
			title: 'HIS企业类型',
			field: 'TypeDesc',
			width: 100
		}, {
			title: '企业类型',
			field: 'comtypedesc',
			width: 80
		},{
			title: '企业编号',
			field: 'DHCPCcompanyId',
			width: 100
		}, {
			title: '企业名称',
			field: 'DHCPCcompanyName',
			width: 80,
			sortable: true
		}, {
			title: '地址',
			field: 'DHCPCaddress',
			width: 100,
			sortable: true
		}, {
			title: '企业联系电话',
			field: 'CcompanyContactTel',
			width: 100,
			sortable: true
		}, {
			title: '企业传真号码',
			field: 'CcompanyContactFax',
			width: 100,
			sortable: true
		}, {
			title: '邮编',
			field: 'DHCPCzipCode',
			width: 150
		}, {
			title: '邮箱',
			field: 'DHCPCemail',
			width: 150
		}, {
			title: '下载日期',
			field: 'DownDate',
			width: 150
		}, {
			title: '下载时间',
			field: 'DownTime',
			width: 150
		}, {
			title: '营业执照注册号',
			field: 'DHCPCBusinessLicense',
			width: 100
		}, {
			title: '地区id号',
			field: 'AreaId',
			width: 100
		}, {
			title: '地区名称',
			field: 'AreaName',
			width: 100
		}, {
			title: '企业账号',
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