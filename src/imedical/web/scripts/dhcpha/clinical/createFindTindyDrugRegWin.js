/// 查找点评单据
createFindTindyDrugRegWin = function(FN){
	
	if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="newTdrWin"></div>');
	$('#newTdrWin').append('<div id="tdrNoList"></div>');
		
	/**
	 * 查询窗口
	 */
	var option = {
		collapsible:true,
		border:true,
		closed:"true"
	};
	
	var newTdrWindowUX = new WindowUX('查找药品拆零记录', 'newTdrWin', '1200', '550', option);
	newTdrWindowUX.Init();
    
    //初始化咨询信息列表
	InitTdrWinList();
		
	//初始化界面按钮事件
	InitTdrWinListener();
	
	//初始化界面默认信息
	InitTdrWinDefault();
	
	/// 查找点评单
	function QueryTdrNoList(){
		
		var tdrStartDate = $('#tdrStartDate').datebox('getValue');   //起始日期
		var tdrEndDate = $('#tdrEndDate').datebox('getValue'); 	     //截止日期
		var tdrWinDept = $('#tdrWinDept').combobox('getValue');      //拆零科室
		var tdrWinUser = $('#tdrWinUser').combobox('getValue');  	 //拆零人员

		var ListData = tdrStartDate + "^" + tdrEndDate + "^" + tdrWinDept + "^" + tdrWinUser;

		$('#tdrNoList').datagrid({
			url:url+'?action=QueryTdrNo',
			queryParams:{
				param : ListData}
		});
	}

	/// 选取指定行
	function SelTdrNoList(){
		
		var rows = $("#tdrNoList").datagrid('getSelected');
		if (rows != null) {
			FN(rows.tdrID);
			$('#newTdrWin').window('close');
		}else{
			$.messager.alert('提示','请选择要提取的拆零单记录','warning');
			return false; 
		}
	}
	
	function InitTdrWinList(){
		// 定义columns
		var columns=[[
			{field:"tdrNo",title:'拆零单号',width:120},
			{field:"tdrCDate",title:'日期',width:100},
			{field:"tdrCTime",title:'时间',width:100},
			{field:'tdrDept',title:'拆零科室',width:160},
			{field:'tdrUser',title:'拆零人',width:100},
			{field:'tdrPurDesc',title:'拆零目的',width:100},
			{field:'tdrComFlag',title:'是否完成',width:80,align:'center'},
			{field:'tdrChkFlag',title:'是否核对',width:80,align:'center'},
			{field:'tdrChkDate',title:'核对日期',width:100},
			{field:'tdrChkTime',title:'核对时间',width:100},
			{field:'tdrChkTime',title:'核对人',width:100},
			{field:'tdrID',title:'tdrID',width:80,hidden:true}
		]];
	
		/**
		 * 定义datagrid
		 */
		var option = {
			title:'药品拆零单列表',
			//nowrap:false,
			toolbar: '#cmttb',
			singleSelect : true,
		    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
			    FN(rowData.tdrID);
				$('#newTdrWin').window('close');
	        }
		};
		
		var tdrNoListComponent = new ListComponent('tdrNoList', columns, '', option);
		tdrNoListComponent.Init();

	}
	
	//初始化界面按钮事件
	function InitTdrWinListener(){
		
		$('a:contains("查询列表")').bind('click',QueryTdrNoList);
		$('a:contains("选取列表")').bind('click',SelTdrNoList);
	}
	
	//初始化界面默认信息
	function InitTdrWinDefault(){
		
		/**
		 * 拆零日期
		 */
		$("#tdrStartDate").datebox("setValue", formatDate(0));
		$("#tdrEndDate").datebox("setValue", formatDate(0));
	
		/**
		 * 拆零科别
		 */
		var tdrWinDeptCombobox = new ListCombobox("tdrWinDept",url+'?action=QueryConDept','');
		tdrWinDeptCombobox.init();
	
		//$("#tdrWinDept").combobox("setValue",LgCtLocID);
	
		/**
		 * 拆零人员
		 */
		var tdrWinUserCombobox = new ListCombobox("tdrWinUser",url+'?action=SelUserByGrp&grpId=1','',{panelHeight:"auto"});
		tdrWinUserCombobox.init();
	
		//$("#tdrWinUser").combobox("setValue",LgUserID);
	}

}

