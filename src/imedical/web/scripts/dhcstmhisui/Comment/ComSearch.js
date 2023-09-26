/*
点评单查询
*/
var ComSearch=function(Fn){
	$HUI.dialog('#FindWin').open();
	$UI.linkbutton('#FQueryBT',{
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#FindConditions');			
			if(isEmpty(ParamsObj.StartDate)){
				$UI.msg('alert','开始日期不能为空!');
				return;
			}
			if(isEmpty(ParamsObj.EndDate)){
				$UI.msg('alert','截止日期不能为空!');
				return;
			}
			
			var Params=JSON.stringify(ParamsObj);
			FindMainGrid.load({
				ClassName: 'web.DHCSTMHUI.Comment',
				QueryName: 'Query',
				Params:Params
			});
		}
	});
	$UI.linkbutton('#FSubmitBT', {
		onClick: function () {
			var Row=FindMainGrid.getSelected();
			if ((isEmpty(Row)) || (Row.length == 0)) {
				$UI.msg('alert', '请选择需要提交的单据!');
				return false;
			}
			var ComId=Row.RowId;
			$UI.confirm('您将要提交所选单据,提交后不允许取消提交,是否继续?', '', '', ComSubmit);		
		}
	});
	function ComSubmit() {
		showMask();
		var Row=FindMainGrid.getSelected();
		var ComId=Row.RowId;
		$.cm({
			ClassName: 'web.DHCSTMHUI.Comment',
			MethodName: 'Submit',
			ComId: ComId
		}, function (jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				FindMainGrid.commonReload();
			} else {
				$UI.msg('error', jsonData.msg);
			};
		});
	}
	var ComMainCm = [[{
			title : "点评单ID",
			field : 'RowId',
			width : 100,
			hidden : true
		}, {
			title : "点评单号",
			field : 'ComNo',
			width : 200
		}, {
			title : "点评单状态",
			field : 'Status',
			width : 200,
	        formatter: function(value,row,index){
				if (row.Status==0){
					return "未点评";
				} else if(row.Status==1){
					return "点评中";
				}else if(row.Status==2){
					return "点评完成"
				}else if(row.Status==3){
					return "已提交"
				}else {
					return ""
				}
	        }
		}, {
			title : "制单日期",
			field : 'CreateDate',
			width : 200
		}, {
			title : "制单时间",
			field : 'CreateTime',
			width : 200
		}, {
			title : '制单人',
			field : 'CreateUser',
			width : 150
		}, {
			title : '抽取条件',
			field : 'Conditions',
			width : 200
		}	
	]];
	$UI.linkbutton('#FClearBT',{
		onClick:function(){
			Clear();
		}
	});
	var Clear=function(){
		$UI.clearBlock('#FindConditions');
		$UI.clear(FindMainGrid);
	///设置初始值 考虑使用配置
		var Dafult={StartDate: DateFormatter(new Date()),
					EndDate: DateFormatter(new Date()),
					}
		$UI.fillBlock('#FindConditions',Dafult)
	}
	$UI.linkbutton('#FReturnBT',{
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#FindConditions');	
			var RetStatus=ParamsObj.FResult;
			var Row=FindMainGrid.getSelected();
			if(isEmpty(Row)){
				$UI.msg('alert','请选择要返回的点评单!');
			}
			Fn(Row.RowId,RetStatus);
			$HUI.dialog('#FindWin').close();
		}
	});
	var FindMainGrid = $UI.datagrid('#FindMainGrid', {
		lazy:false,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Comment',
			QueryName: 'Query'
		},
		columns: ComMainCm,
		onDblClickRow:function(index, row){
			var ParamsObj=$UI.loopBlock('#FindConditions');	
			var RetStatus=ParamsObj.FResult;
			Fn(row.RowId,RetStatus);
			$HUI.dialog('#FindWin').close();
		}
	})
	Clear()

}