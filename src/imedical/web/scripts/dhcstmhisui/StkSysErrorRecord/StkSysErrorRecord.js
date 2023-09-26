
var init = function() {
	
	var ClearMain=function(){
		$UI.clearBlock('#MainConditions');
		$UI.clear(ErrorRecordGrid);
		
	}

	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#MainConditions')
			
		    if(isEmpty(ParamsObj.StartDate)){
			  $UI.msg('alert','��ʼ���ڲ���Ϊ��!');
			  return;
		    }
		    if(isEmpty(ParamsObj.EndDate)){
			  $UI.msg('alert','��ֹ���ڲ���Ϊ��!');
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
			title: '��־��������',
			field: 'Date',
			width:100
		}, {
			title: '��־����ʱ��',
			field: 'Time',
			width:100
		}, {
			title: '������ģ��',
			field: 'AppName',
			width:150
		}, {
			title: "��������",
			field:'ErrInfo',
			width:100
		}, {
			title:"�������������",
			field:'KValue',
			width:150
		}, {
			title:"��������Ĵ���",
			field:'Trigger',
			width:100
		}, {
			title:"��������IP",
			field:'IP',
			width:100
		}, {
			title:"�����û�",
			field:'UserName',
			width:100
		}, {
			title:"�����Ϣ",
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
