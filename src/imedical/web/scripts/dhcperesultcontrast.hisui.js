
/*
 * FileName:    dhcperesultcontrast.hisui.js
 * Author:      xy
 * Date:        20221206
 * Description: 结果对比
 */
 
$(function(){
	
	//初始化界面
	InitResultContrastGrid();
	
})

function InitResultContrastGrid(){
	$HUI.datagrid("#ResultContrastGrid",{
		height: 663,
		url:$URL,
		striped: false, //是否显示斑马线效果
		singleSelect: true,
		selectOnCheck: false,
		autoRowHeight: false,
		showFooter: true,
		nowrap:false,
		loadMsg: 'Loading...',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		pageSize: 10,
		pageList: [10, 20, 40, 40],
		queryParams:{
			ClassName:"web.DHCPE.ResultContrast",
			QueryName:"ContrastWithLast", 
			PAADM:PAADM
		},columns:[[ 
			{field:'PAADM',title:'PAADM',hidden: true},
			{field:'TARCIMItem',width:120,title:'医嘱项'},
			{field:'TLastTime',width:300,title:'上次'},
			{field:'TCurrentTime',width:300,title:'本次'},
			{field:'TLastTime2',width:300,title:'上上次'},
			
			
		]]
	
	})
}