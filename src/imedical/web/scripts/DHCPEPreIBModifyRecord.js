//名称	DHCPEPreIBModifyRecord.js
//功能	个人基本信息修改记录
//创建	2018.08.31
//创建人  xy

$(function(){
	
	InitModifyRecordDataGrid();
	
})
function InitModifyRecordDataGrid(){
	$HUI.datagrid("#dhcpemodifyrecordlist",{
		 url:$URL,
        fit : true,
        border : false,
        striped : true,
        fitColumns : false,
        autoRowHeight : false,
		nowrap:false,
        singleSelect: false,
        selectOnCheck: true,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		pageSize: 10,
		pageList: [10, 20, 40, 40],
	    displayMsg:"",//隐藏分页下面的文字"显示几页到几页,共多少条数据"
		queryParams:{
			ClassName:"web.DHCPE.PreIBaseInfo",
			QueryName:"SearchPreIBModifyRecord", 
			SourceType:SourceType,
			SourceID:SourceID,
		},columns:[[ 
			{field:'User',width:'100',title:'修改人'},
			{field:'Date',width:'100',title:'修改日期'},
			{field:'Time',width:'100',title:'修改时间'},
			{field:'OldInfo',width:'350',title:'修改前内容'},
			{field:'NewInfo',width:'380',title:'修改后内容'},
			
			
		]]
	
	})
}