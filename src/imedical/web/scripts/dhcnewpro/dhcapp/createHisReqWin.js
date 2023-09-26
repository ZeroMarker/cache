
/// Creator:    bianshuai
/// CreateDate: 2016-04-30
/// Descript:   历史申请记录

createHisReqWin = function(FN){
	
	//if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出

	//$('body').append('<div id="win"></div>');
	//$('#win').append('<div id="hisReqList"></div>');

	$('#win').window({
		title:'历史申请记录',
		collapsible:true,
		border:true,
		closed:"true",
		width:1000,
		height:460,
		onClose:function(){
			//$('#win').remove();  //窗口关闭时移除win的DIV标签
			}
	}); 
	
	//初始化咨询信息列表
	InitDataList();
	
	//初始化界面默认信息
	InitDefault();
	
	$('#win').window('open');

	//初始化界面默认信息
	function InitDefault(){
		/**
		  * 起始、截止日期
		  */
		$("#startDate").datebox("setValue", formatDate(0));
		$("#endDate").datebox("setValue", formatDate(0));
		
		$('div#tb a:contains("查询")').bind('click',queryReqHisList);
		$('div#tb a:contains("选取")').bind('click',selectReqHisList);
	}
		
	/// 初始化数据列表
	function InitDataList(){
	
		/**
		 * 定义columns
		 */
		var columns=[[
			{field:'arRepID',title:'arRepID',width:80},
			{field:'arReqData',title:'申请日期',width:100},
			{field:'arReqTime',title:'申请时间',width:100},
			{field:'arReqUser',title:'申请人',width:100},
			{field:'arRepExLoc',title:'执行科室',width:200},
			{field:'arPatName',title:'病人姓名',width:100},
			{field:'arReqNo',title:'申请单号',width:100},
			{field:'repEmgFlag',title:'加急',width:100}
		]];
	
		/**
		 * 定义datagrid
		 */
		var option = {
			///title:'历史申请记录',
			toolbar: '#tb',
			singleSelect : true,
		    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    		FN(rowData.arRepID);
				$('#win').window('close');
	        }
		};
		
		var uniturl = LINK_CSP+"?ClassName=web.DHCAPPComDataUtil&MethodName=jsonAppReqHis";
		var hrListComponent = new ListComponent('hisReqList', columns, uniturl, option);
		hrListComponent.Init();
	}

	/// 查找点评单
	function queryReqHisList(){
	
		var startDate = $('#startDate').datebox('getValue');   //起始日期
		var endDate = $('#endDate').datebox('getValue'); 	   //截止日期

		var ListData = startDate + "^" + endDate;

		$('#hisReqList').datagrid('reload',{"params":ListData});
	}

	/// 选取指定行
	function selectReqHisList(){
	
		var rowData = $("#hisReqList").datagrid('getSelected');
		if (rowData != null) {
			FN(rowData.arRepID);
			$('#win').window('close');
		}else{
			$.messager.alert('提示','请选择要提取的申请单记录','warning');  //苏帆  2016年7月6日
			return false; 
		}
	}
}
