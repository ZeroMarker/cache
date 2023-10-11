/* 四川阳光采购 商品对照*/
function SCPurPlanCodeEdit(){
	var Inci=$('#Inci').val();
	if(isEmpty(Inci)){
		$UI.msg('alert','请先选择需要对照的库存项!')
		return;
	}
	$HUI.dialog('#SCPurinfoWin',{width: gWinWidth, height: gWinHeight}).open();
	
	var ProcurecatalogType = $HUI.combobox('#ProcurecatalogType', {
		data: [
			{'RowId': '1', 'Description': '带量专区'},
			{'RowId': '0', 'Description': '价格联动商品'},
			{'RowId': '3', 'Description': '备案'}
		],
		valueField: 'RowId',
		textField: 'Description'
	});
	var ScBid = $HUI.combobox('#ScBid', {
		data: [
			{'RowId': '1', 'Description': '国家第一批次(冠脉支架)'},
			{'RowId': '2', 'Description': '省际联盟第一批次(冠脉扩张球囊)'},
			{'RowId': '3', 'Description': '国家第二批次(人工关节)'},
			{'RowId': '4', 'Description': '"3+N"联盟(冠脉药物球囊类)'},
			{'RowId': '5', 'Description': '"3+N"联盟(人工晶体类))'},
			{'RowId': '6', 'Description': '"3+N"联盟(起搏器类)'},
			{'RowId': '7', 'Description': '"3+N"联盟(骨科创伤)'},
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
				$UI.msg('alert', '商品类型不能为空！');
				return;	
			}
			if(isEmpty(ScBid)){
				$UI.msg('alert', '集采批次不能为空！');
				return;	
			}
            if (CurPage=="")
            {
	            $UI.msg('alert', '下载采购目录时当前页码不能为空！');
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
					$UI.msg('success',"下载成功!");
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
		    	$UI.confirm('该库存项已存在对照关系,点击确定则更新对照关系,是否继续?', '', '',SCMatch);
		    }else{
		    	SCMatch();
		    }
		}	
	});
	function SCMatch(){
		var Row=SCPurinfoGrid.getSelected();
		if(isEmpty(Row)){
			$UI.msg('alert', '请选择需要对照的平台采购信息!');
			return;
		}
		var MPCId = Row.MPCId;
		if(isEmpty(MPCId)){
			$UI.msg('alert', '请先选择要取消对照的平台采购信息!');
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
				$UI.msg('success',"对照成功！");
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
				$UI.msg('alert', '请先选择要取消对照的平台采购信息!');
				return;
			}
			var MPCId = Row.MPCId;
			if(isEmpty(MPCId)){
				$UI.msg('alert', '请先选择要取消对照的平台采购信息!');
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
			title: '库存项ID',
			field: 'INCI',
			width: 80,
			sortable: true,
			hidden: true
		}, {
			title: '库存项代码',
			field: 'InciCode',
			width: 100,
			sortable: true
		}, {
			title: '产品编号',
			field: 'GoodsId',
			width: 100,
			sortable: true
		}, {
			title: '通用名称',
			field: 'productName',
			width: 150
		}, {
			title: '产品名称',
			field: 'GoodsName',
			width: 150
		}, {
			title: '规格',
			field: 'OutLookc',
			width: 150
		}, {
			title: '型号',
			field: 'GoodsType',
			width: 150
		}, {
			title: '配送商编号',
			field: 'CompanyIdPs',
			width: 150
		}, {
			title: '配送商',
			field: 'CompanyNamePs',
			width: 150
		}, {
			title: '分类',
			field: 'SortName',
			width: 100
		}, {
			title: '单位',
			field: 'Unit',
			width: 80
		}, {
			title: '注册证名称',
			field: 'RegCodeName',
			width: 100
		}, {
			title: '注册证号',
			field: 'regCerno',
			width: 100
		}, {
			title: '注册证ID',
			field: 'regcode',
			width: 100
		}, {
			title: '品牌',
			field: 'Brand',
			width: 100
		}, {
			title: '来源',
			field: 'Source',
			width: 150
		}, {
			title: '采购价格',
			field: 'PurchasePrice',
			width: 150
		}, {
			title: '投标企业编号',
			field: 'CompanyIdTb',
			width: 150
		}, {
			title: '投标企业',
			field: 'CompanyNameTb',
			width: 150
		}, {
			title: '采购类别',
			field: 'PurchaseType',
			width: 150
		}, {
			title: '其他采购价格',
			field: 'DailPurchasePrice',
			width: 150
		}, {
			title: '其他采购类型标识',
			field: 'PurchaseIDentification',
			width: 150
		}, {
			title: '添加日期',
			field: 'AddDate',
			width: 150
		}, {
			title: '添加时间',
			field: 'AddTime',
			width: 150
		}, {
			title: '变更日期',
			field: 'LastUpdateDate',
			width: 150
		}, {
			title: '变更时间',
			field: 'LastUpdateTime',
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
			title: '下载人',
			field: 'DownUser',
			width: 150
		}, {
			title: '价格状态',
			field: 'bargainStatus',
			width: 150
		}, {
			title: '医保分类',
			field: 'ybCode',
			width: 150
		}, {
			title: '中选价格',
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