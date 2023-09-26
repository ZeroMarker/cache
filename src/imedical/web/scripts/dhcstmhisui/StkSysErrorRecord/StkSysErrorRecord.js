
var init = function() {
	
	var ClearMain=function(){
		$UI.clearBlock('#MainConditions');
		$UI.clear(ErrorRecordGrid);
		
	}

	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#MainConditions')
			
		    if(isEmpty(ParamsObj.StartDate)){
			  $UI.msg('alert','开始日期不能为空!');
			  return;
		    }
		    if(isEmpty(ParamsObj.EndDate)){
			  $UI.msg('alert','截止日期不能为空!');
			  return;
		    }
		    var Params = JSON.stringify(ParamsObj);
		    //alert(Params);
		    ErrorRecordGrid.load({
			  ClassName: 'web.DHCSTMHUI.ErrorRecord',
			  QueryName: 'Query',
			  Params:Params
		    });
		}
	});
	var ErrorRecordGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width:100,
			hidden: true
		}, {
			title: '日志生成日期',
			field: 'Date',
			width:100
		}, {
			title: '日志生成时间',
			field: 'Time',
			width:100
		}, {
			title: '错误发生模块',
			field: 'AppName',
			width:150
		}, {
			title: "错误描述",
			field:'ErrInfo',
			width:100
		}, {
			title:"产生错误的数据",
			field:'KValue',
			width:150
		}, {
			title:"产生错误的代码",
			field:'Trigger',
			width:100
		}, {
			title:"操作机器IP",
			field:'IP',
			width:100
		}, {
			title:"操作用户",
			field:'UserName',
			width:100
		}, {
			title:"浏览信息",
			field:'BrowserInfo',
			width:100
		}
	]];

	var ErrorRecordGrid = $UI.datagrid('#ErrorRecordGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.ErrorRecord',
			QueryName: 'Query'
		},
		columns: ErrorRecordGridCm,
		singleSelect:false,
		showBar:true
	});

}
$(init);
