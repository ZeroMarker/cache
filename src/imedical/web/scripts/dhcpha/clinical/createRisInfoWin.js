// pushuangcai
// 2019-10-29
function createRisWin(callBack){
	try{
		if($('#RisWin').is(":visible")){return;}  //窗体处在打开状态,退出
		$('body').append('<div id="RisWin"></div>');
		$('#RisWin').append('<div id="Ris"></div>');
		$('#Ris').datagrid({
		    url:'DHCST.QUERY.BROKER.csp',
		    fit:true,
			rownumbers:true,
			pageSize:40,        // 每页显示的记录条数
			pageList:[40,80],   // 可以设置每页记录条数的列表
			loadMsg: '正在加载信息...',
			pagination:true,
			nowrap:false,
			toolbar: [{
				text: '引用',
				iconCls: 'icon-edit',
				handler: function(){
					var dataArr = $('#Ris').datagrid("getChecked");
					var text = "";
					$.each(dataArr, function(key, val){
						text = text + val.checkname +":"+ val.resultDescEx +";    ";
					})
					callBack(text);
					$('#RisWin').window('close');
				}
			},'-',{
				text: '关闭',
				iconCls: 'icon-cancel',
				handler: function(){$('#RisWin').window('close');}
			}],
		    columns:[[
		    	{field:'check',checkbox:true},	
				{field:'checkname',title:'检查项目',width:100},
				{field:'audittime',title:'审核时间',width:80},
				{field:'resultDescEx',title:'检查结果',width:200},
				{field:'examDescEx',title:'检查描述',width:400},
				{field:'checkNO',title:'报告单号',width:150},
				{field:'ordStartDate',title:'医嘱日期',width:100},
				{field:'ordItemId',title:'ordItemId',width:100}
		    ]],
		    onDblClickRow: function(rowIndex, rowData){
			    var text = rowData.checkname +":"+ rowData.resultDescEx
			    callBack(text);
			    //$('#RisWin').window('close');
			}
		    
		});
		$('#RisWin').window({
			title:'检查列表',    
			collapsible:true,
			border:true,
			closed:"true",
			width:900,
			height:500,
			minimizable:false,						
			onClose:function(){
				$('#RisWin').remove();  
			}
		}); 
		$('#RisWin').window('open');
		$('#Ris').datagrid({
     		queryParams:{
	     		ClassName: 'web.DHCSTPHCMPHARCAREMAIN',
	     		QueryName: 'GetRisReportList',
	     		DataType: "Array",
				admId: EpisodeID
			}
		});
	}catch(e){
		alert(e.message)
		}
}