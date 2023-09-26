/*确认*/
var init = function () {
	var Clear=function(){
		$UI.clearBlock('#FindConditions');
		$UI.clear(BarMainGrid);
		$UI.clear(BarDetailGrid);
	///设置初始值 考虑使用配置
		var Dafult={
					StartDate: TrackDefaultStDate(),
					EndDate: TrackDefaultEdDate()
					}
		$UI.fillBlock('#FindConditions',Dafult)
	}
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			Query();
		}
		});
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Clear();
		}
	});
	$UI.linkbutton('#ConfirmBT',{
		onClick:function(){
			var Selected=BarMainGrid.getSelectedData();
				if(Selected.length==0){
					$UI.msg('alert','请选择!!')
					return;
				}
				var BarCode=Selected[0].BarCode
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCItmTrack',
					MethodName: 'SaveHv',
					label: BarCode
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
					}else{
						$UI.msg('error',jsonData.msg);
					}
				});
		}
	});	
	var BarMainCm = [[{
			title : "RowId",
			field : 'RowId',
			width : 100,
			hidden : true
		}, {
			title : "InciId",
			field : 'InciId',
			width : 120,
			hidden : true
		}, {
			title : '物资代码',
			field : 'InciCode',
			width : 150
		}, {
			title : '物资名称',
			field : 'InciDesc',
			width : 150
		}, {
			title : "条码",
			field : 'BarCode',
			width : 200
		}, {
			title : "自带条码",
			field : 'OriginalCode',
			width : 200
		}, {
			title : '状态',
			field : 'Status',
			formatter : StatusFormatter,
			width : 70
		}, {
			title : '批号id',
			field : 'BatNo',
			width : 90,
			hidden: true
		}, {
			title : '批号~效期',
			field : 'BatExp',
			width : 70
		}, {
			title : '规格',
			field : 'Spec',
			width : 90
		}, {
			title : "具体规格",
			field : 'SpecDesc',
			width : 120
		}, {
			title : "单位",
			field : 'UomDesc',
			width : 80
		}, {
			title : "供应商",
			field : 'VendorDesc',
			width : 100
		}, {
			title : "厂商",
			field : 'ManfDesc',
			width : 100
		}, {
			title : "确认",
			field : 'RetOriFlag',
			width : 100
		}, {
			title : "条码生成(注册)日期",
			field : 'DhcitDate',
			width : 100
		}, {
			title : "条码生成(注册)时间",
			field : 'DhcitTime',
			width : 100
		}, {
			title : "操作人",
			field : 'DhcitUser',
			width : 100
		}
	]];
	var BarMainGrid = $UI.datagrid('#BarMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'Query'
		},
		columns: BarMainCm,
		showBar:true,
		onSelect:function(index, row){
			BarDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCItmTrack',
				QueryName: 'QueryItmTrackItem',
				Parref: row.RowId
			});
		}
	})
	
	var BarDetailCm = [[{
			title : "RowId",
			field : 'RowId',
			width : 100,
			hidden : true
		}, {
			title : '类型',
			field : 'Type',
			formatter: TypeRenderer,
			width : 80
		}, {
			title : 'Pointer',
			field : 'Pointer',
			width : 230,
			hidden: true
		}, {
			title : '台账标记',
			field : 'IntrFlag',
			width : 80
		}, {
			title : '处理号',
			field : 'OperNo',
			width : 80
		}, {
			title : '业务发生日期',
			field : 'Date',
			width : 80
		}, {
			title : "业务发生时间",
			field : 'Time',
			width : 180
		}, {
			title : "业务操作人",
			field : 'User',
			width : 70
		}, {
			title : "位置信息",
			field : 'OperOrg',
			width : 90
		}		
	]];
	
	var BarDetailGrid = $UI.datagrid('#BarDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'QueryItmTrackItem'
		},
		columns: BarDetailCm,
		showBar:true
	})
	function Query(){
		var ParamsObj=$UI.loopBlock('#FindConditions')
		if(isEmpty(ParamsObj.StartDate)){
			$UI.msg('alert','开始日期不能为空!');
			return;
		}
		if(isEmpty(ParamsObj.EndDate)){
			$UI.msg('alert','截止日期不能为空!');
			return;
		}
		var Params=JSON.stringify(ParamsObj);
		$UI.clear(BarDetailGrid);
		BarMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'Query',
			Params:Params
		});
	}
	
	Clear();

}
$(init);