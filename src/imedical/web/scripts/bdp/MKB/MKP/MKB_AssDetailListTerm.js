/// 名称: 辅助功能区 -引用属性格式的属性内容维护
/// 描述: 包含增删改上移下移等功能
/// 编写者: 基础数据平台组-石萧伟
/// 编写日期: 2018-05-22

var init = function(){
	//datagrid列
	var columns =[[   
					{field:'MKBTPDRowId',title:'属性内容表id',width:80,sortable:true,hidden:true},
					{field:'MKBTPDSequence',title:'顺序',width:150,sortable:true,hidden:true,
						sorter:function (a,b){  
							if(a.length > b.length) return 1;
								else if(a.length < b.length) return -1;
								else if(a > b) return 1;
								else return -1;
						}
					},
					{field:'MKBTRowId',title:'RowId',width:80,sortable:true,hidden:true},
					{field:'MKBTDesc',title:'描述',width:150,sortable:true},
					{field:'MKBTCode',title:'代码',width:150,sortable:true}
				]];
				
	//列表datagrid
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.MKB.MKBTermProDetail",
			QueryName:"GetSellistTermList",
			property:property
		},
		columns:columns,
		pagination: false,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏
		singleSelect:true,
		idField:'MKBTRowId', 
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort:false,  //定义是否从服务器排序数据。true
		sortName : 'MKBTPDSequence',
		sortOrder : 'asc'
			  
	});	

};
$(init);
