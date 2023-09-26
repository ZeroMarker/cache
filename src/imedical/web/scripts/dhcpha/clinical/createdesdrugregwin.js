/// 查找点评单据
createDesDrugRegWin = function(FN){
	
	if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="newDdrWin"></div>');
	$('#newDdrWin').append('<div id="ddrNoList"></div>');
		
	/**
	 * 查询窗口
	 */
	var option = {
		collapsible:true,
		border:true,
		closed:"true"
	};
	
	var newDdrWindowUX = new WindowUX('查找麻精药品销毁记录', 'newDdrWin', '1200', '550', option);
	newDdrWindowUX.Init();
    
    //初始化咨询信息列表
	InitDdrWinList();
		
	//初始化界面按钮事件
	InitDdrWinListener();
	
	//初始化界面默认信息
	InitDdrWinDefault();
	
	/// 查找点评单
	function QueryDdrNoList(){
		
		var ddrStartDate = $('#ddrStartDate').datebox('getValue');   //起始日期
		var ddrEndDate = $('#ddrEndDate').datebox('getValue'); 	     //截止日期
		var ddrWinDept = $('#ddrWinDept').combobox('getValue');      //销毁科室
		var ddrWinUser = $('#ddrWinUser').combobox('getValue');  	 //销毁人员

		var ListData = ddrStartDate + "^" + ddrEndDate + "^" + ddrWinDept + "^" + ddrWinUser;

		$('#ddrNoList').datagrid({
			url:url+'?action=QueryDesRegNoList',
			queryParams:{
				param : ListData}
		});
	}

	/// 选取指定行
	function SelDdrNoList(){
		
		var rows = $("#ddrNoList").datagrid('getSelected');
		if (rows != null) {
			FN(rows.ddrID);
			$('#newDdrWin').window('close');
		}else{
			$.messager.alert('提示','请选择要提取的销毁单记录','warning');
			return false; 
		}
	}
	
	function InitDdrWinList(){
		// 定义columns
		var columns=[[
			{field:"ddrNo",title:'销毁单号',width:120},
			{field:"ddrCDate",title:'日期',width:100},
			{field:"ddrCTime",title:'时间',width:100},
			{field:'ddrDept',title:'销毁科室',width:160},
			{field:'ddrUser',title:'销毁人',width:100},
			{field:'ddrDesWayDesc',title:'销毁方式',width:100},
			{field:'ddrComFlag',title:'是否完成',width:80,align:'center'},
			{field:'ddrChkFlag',title:'是否核对',width:80,align:'center'},
			{field:'ddrChkDate',title:'核对日期',width:100},
			{field:'ddrChkTime',title:'核对时间',width:100},
			{field:'ddrChkTime',title:'核对人',width:100},
			{field:'ddrID',title:'ddrID',width:80,hidden:true}
		]];
	
		/**
		 * 定义datagrid
		 */
		var option = {
			title:'药品销毁单列表',
			//nowrap:false,
			toolbar: '#cmttb',
			singleSelect : true,
		    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
			    FN(rowData.ddrID);
				$('#newDdrWin').window('close');
	        }
		};
		
		var ddrNoListComponent = new ListComponent('ddrNoList', columns, '', option);
		ddrNoListComponent.Init();

	}
	
	//初始化界面按钮事件
	function InitDdrWinListener(){
		
		$('a:contains("查询列表")').bind('click',QueryDdrNoList);
		$('a:contains("选取列表")').bind('click',SelDdrNoList);
	}
	
	//初始化界面默认信息
	function InitDdrWinDefault(){
		
		/**
		 * 销毁日期
		 */
		$("#ddrStartDate").datebox("setValue", formatDate(0));
		$("#ddrEndDate").datebox("setValue", formatDate(0));
	
		/**
		 * 销毁科别
		 */
		var ddrWinDeptCombobox = new ListCombobox("ddrWinDept",url+'?action=QueryConDept','');
		ddrWinDeptCombobox.init();
	
		//$("#ddrWinDept").combobox("setValue",LgCtLocID);
	
		/**
		 * 销毁人员
		 */
		var ddrWinUserCombobox = new ListCombobox("ddrWinUser",url+'?action=SelUserByGrp&grpId=1','',{panelHeight:"auto"});
		ddrWinUserCombobox.init();
	
		//$("#ddrWinUser").combobox("setValue",LgUserID);
	}

}

