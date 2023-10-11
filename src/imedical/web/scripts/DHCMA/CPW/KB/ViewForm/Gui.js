//页面Gui
var obj = new Object();
function InitViewFromWin(){	
    var viewColumns = [];			//类标题数组
    
    $cm({
		ClassName:"DHCMA.CPW.KBS.PathBaseSrv",
		QueryName:"QryPathStage",
		aPathBaseDr:PathFormID,
		ResultSetType:"array",
	},function(rs){
		//动态添加列标题
		console.log(rs)
		for (var i=0;i<rs.length;i++){
			var tmpObj = rs[i];
			viewColumns[i] = {field:"FLD-"+tmpObj.ID,title:tmpObj.EpDesc}
		}		
		$cm({
			ClassName:"DHCMA.CPW.KBS.PathBaseSrv",
			MethodName:"GetViewFormItems",
			aPathBaseID:PathFormID
		},function(rs){
			//debugger
			//获取表单视图
			obj.gridViewForm = $HUI.datagrid("#gridViewForm",{
				fit: true,
				title:'路径名称：<span style=\"color:#1584D2\"><b>'+rs.name+'<b/></span>',
				headerCls:'panel-header-gray', //配置项使表格变成灰色
				pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
				rownumbers: false, //如果为true, 则显示一个行号列
				singleSelect: false,
				autoRowHeight: true, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
				loadMsg:'数据加载中...',
				pageSize: 99,
				pageList : [20,50,100,200],
				data:rs,
			    frozenColumns: [[
		        	{ field: 'step', title: '步骤', width: 100,styler: function (value, row, index) {
             			return 'background-color:#F4F6F5;';
          			}},
		        ]],
				columns:[viewColumns],
				onBeforeLoad: function (param) {
		            var firstLoad = $(this).attr("firstLoad");
		            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
		            {
		                $(this).attr("firstLoad","true");
		                return false;
		            }
		            return true;
				},
				onLoadSuccess:function(){
					$(this).prev().find('div.datagrid-body').unbind('mouseover');
					$(":input").attr("disabled", "disabled");     
					$.parser.parse();	
				},
				onClickRow: function (rowIndex, rowData) {
    				$(this).datagrid('unselectRow', rowIndex);
				}
				,
				rowStyler: function(index,row){
					return 'background-color:#F7FBFF;';
				}
			});
		})
	})
	
	//$.parser.parse();
	InitViewFormWinEvent(obj);
	obj.LoadEvents(arguments);
}