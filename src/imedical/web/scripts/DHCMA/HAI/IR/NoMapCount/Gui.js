//页面Gui
function InitNoMapCountWin(){
	var obj = new Object();
	$.parser.parse();
	
	$HUI.datagrid("#gridNoMapCount",{
		fit: true,
		//title:'未对照内容列表',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,	
		fitColumns: true,		
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
		    ClassName:"DHCHAI.DPS.NoMapCountSrv",
			QueryName:"QryNoMapCount",
	    },
		columns:[[
			{field:'TypeDesc',title:'类型',width:100,align:'center'},
			{field:'PhraseDesc',title:'名称',width:100,align:'center',formatter:rowformater},
			{field:'Count',title:'未对照数量',width:80,align:'center'}
		]]
	
	});
	//未对照内容列表连接
	function rowformater(value,row,index){
		if (row.PhraseDesc == '细菌对照') {            
			return  "<a href='dhcma.hai.dp.labbactmap.csp?1=1'>" +row.PhraseDesc+ "</a>" ;        
		}else if (row.PhraseDesc == '抗生素对照') {            
			return  "<a href='dhcma.hai.dp.labantimap.csp?1=1'>" +row.PhraseDesc+ "</a>" ;       
		}else if (row.PhraseDesc == '抗菌药物对照') {           
			return  "<a href='dhcma.hai.dp.oeantimastmap.csp?1=1'>" +row.PhraseDesc+ "</a>" ;        
		} else if (row.PhraseDesc == '标本对照') {           
			return  "<a href='dhcma.hai.dp.labspecmap.csp?1=1'>" +row.PhraseDesc+ "</a>" ;        
		}else{           
			return  "<a href='dhcma.hai.dp.phrasemap.csp?1=1'>" +row.PhraseDesc+ "</a>" ;        
		}	
	}
	InitNoMapCountWinEvent(obj);	
	obj.LoadEvent(arguments);
	
	return obj;
}


