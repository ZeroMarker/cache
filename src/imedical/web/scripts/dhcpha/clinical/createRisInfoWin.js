
function createRisWin(callBack){
	try{
		if($('#RisWin').is(":visible")){return;}  //窗体处在打开状态,退出
		$('body').append('<div id="RisWin"></div>');
		$('#RisWin').append('<div id="Ris"></div>');
		$('#Ris').datagrid({
		    url:'dhcapp.broker.csp',
		    fit:true,
			rownumbers:true,
			pageSize:100,        // 每页显示的记录条数
			pageList:[100,200],   // 可以设置每页记录条数的列表
			loadMsg: $g('正在加载信息...'),
			pagination:true,
			nowrap:false,
			queryParams:{
	     		ClassName: 'PHA.CPW.Com.OutInterfance',
	     		MethodName: 'GetRisReport',
				EpisodeID: AdmDr
			},
			toolbar: [{
				text: $g('引用'),
				iconCls: 'icon-ok',
				handler: function(){
					var dataArr = $('#Ris').datagrid("getChecked");
					var text = "";
					$.each(dataArr, function(key, val){
						text = text + val.StrOrderName +":"+ val.ResultDescEx +";  ";
					})
					if(text!=""){
					callBack(text);
					}
					$('#RisWin').window('close');
				}
			},'-',{
				text:$g('关闭'),
				iconCls: 'icon-cancel',
				handler: function(){$('#RisWin').window('close');}
			}],
		    columns:[[
		    	{field:'check',checkbox:true},	
		    	{ field: 'DepLocDesc',align: 'center', title: $g('就诊科室')},
    	        { field: 'No',align: 'center', title: $g('申请单号')},
				{ field: 'StudyNo',align: 'center', title: $g('检查号')},
				{ field: 'StrOrderName',align: 'center', title: $g('检查名称')},
				{ field: 'strOrderDateDesc',align: 'center', title: $g('申请日期')},
				{ field: 'ItemStatus',align: 'center', title: $g('检查状态')},
				{ field: 'RecLocName',align: 'center', title: $g('检查科室')},
				{ field: 'ExamDescEx',align: 'center', title: $g('检查描述')},
				{ field: 'ResultDescEx',align: 'center', title: $g('检查结果')},
				{ field: 'IsCVR',align: 'center', title: $g('危急值报告')},
				{ field: 'IsIll',align: 'center', title: $g('是否阳性'),
					formatter:function(value,row,index){ 
						if (value=='Y'){return $g("是");} 
						else {return $g("否");}
					}}, 
		    
				    ]],
		    onDblClickRow: function(rowIndex, rowData){
			    var text = rowData.StrOrderName +":"+ rowData.ResultDescEx
			    callBack(text);
			}
		    
		});
		$('#RisWin').window({
			title:$g('检查列表'),    
			collapsible:true,
			border:true,
			closed:"true",
			width:1050,
			height:500,
			minimizable:false,						
			onClose:function(){
				$('#RisWin').remove();  
			}
		}); 
		$('#RisWin').window('open');

	}catch(e){
		alert(e.message)
		}
}