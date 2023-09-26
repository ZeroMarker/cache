
/// Creator:    bianshuai
/// CreateDate: 2016-04-30
/// Descript:   检查申请医嘱项模板

createAppArcTempWin = function(FN){
	
	//if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出

	//$('body').append('<div id="win"></div>');
	//$('#win').append('<div id="ArcTempList"></div>');

	$('#arcwin').window({
		title:'检查申请医嘱项模板',
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

	$('#arcwin').window('open');

	//初始化界面默认信息
	function InitDefault(){
		
		/* 检查分类 */
		
		var uniturl = LINK_CSP+"?ClassName=web.DHCAPPComDataUtil&MethodName=GetAppArcCat&HospID=";
		var arcItemCatCombobox = new ListCombobox("arcitemcat",uniturl,'');
		arcItemCatCombobox.init();
	
		$('div#arctb a:contains("查找")').bind('click',queryArcTempList);
		$('div#arctb a:contains("选择")').bind('click',selectArcTempList);
		$('div#arctb a:contains("删除模板")').bind('click',deleteArcTemp);
		
		$('input[type="radio"][name="itemCat"]').live('click',function(){
			queryArcTempList();
		})
	}
		
	/// 初始化数据列表
	function InitDataList(){
	
		/**
		 * 定义columns
		 */
		var columns=[[
			{field:'arcTempCat',title:'检查分类',width:130},
			{field:'arcTempDesc',title:'模板描述',width:700},
			{field:'arcTempID',title:'arcTempID',width:80}
		]];
	
		/**
		 * 定义datagrid
		 */
		var option = {
			///title:'历史申请记录',
			toolbar: '#arctb',
			singleSelect : true,
		    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    		FN(rowData.arcTempID);
				$('#arcwin').window('close');
	        }
		};
		
		var uniturl = LINK_CSP+"?ClassName=web.DHCAPPComDataUtil&MethodName=jsonAppArcTemp";
		var arcListComponent = new ListComponent('arcTempList', columns, uniturl, option);
		arcListComponent.Init();
	}

	/// 查找点评单
	function queryArcTempList(){
		
		var arcitemcat = $('input[name="itemCat"]:checked ').attr("id");
		var ListData = arcitemcat +"^"+ LgCtLocID +"^"+ LgUserID;
		$('#arcTempList').datagrid('reload',{"params":ListData});
	}

	/// 选取指定行
	function selectArcTempList(){
	
		var rowData = $("#arcTempList").datagrid('getSelected');
		if (rowData != null) {
			FN(rowData.arcTempID);
			$('#arcwin').window('close');
		}else{
			$.messager.alert('提示','请选择要提取的模板记录','warning');
			return false; 
		}
	}
	
	
	/// 删除选中行
	function deleteArcTemp(){
	
		var rowsData = $("#arcTempList").datagrid('getSelected'); //选中要删除的行
		if (rowsData != null) {
			$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
				if (res) {
					runClassMethod("web.DHCAppArcTemp","delArcTemp",{'arcTempID':rowsData.arcTempID},function(jsonString){
						queryArcTempList(); //重新加载
					},'',false)
				}
			});
		}else{
			 $.messager.alert('提示','请选择要删除的项','warning');
			 return;
		}
	}

}
