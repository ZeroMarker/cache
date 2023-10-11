//Creator:基础数据平台-李可凡
//CreatDate:2020-07026
//Description:HIS-Location与HR-组织关联关系表(HCP)

var init = function(){
	
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTDepartmentLocation&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTDepartmentLocation";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTDepartmentLocation&pClassMethod=DeleteData";
	
	$('#TextDept').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchFunLib();
		}
		if(event.keyCode == 27) {
		  ClearFunLib();
		}
	});
	$('#TextLocSource').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchFunLib();
		}
		if(event.keyCode == 27) {
		  ClearFunLib();
		}
	});
	$('#TextLocCode').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchFunLib();
		}
		if(event.keyCode == 27) {
		  ClearFunLib();
		}
	});
	$('#TextLocDesc').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchFunLib();
		}
		if(event.keyCode == 27) {
		  ClearFunLib();
		}
	});
	
	//组织部门下拉框
	$('#DEPLDeptDR').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.CTDepartment&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'ID',
		textField:'DEPDesc'
	});
	//Location来源下拉框
	$('#DEPLLocSource').combobox({ 
		data:[{'value':'CT_Loc','text':'CT_Loc'}],
        valueField:'value',
        textField:'text',
        panelHeight:'auto'
	});
	//Location下拉框
	$('#DEPLLocID').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.CTLoc&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'CTLOCRowID',
		textField:'CTLOCDesc'
	});
	//上级Location来源下拉框
	$('#DEPLParentLocSource').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.CTDepartmentLocation&QueryName=GetSource&ResultSetType=array",
		valueField:'Source',
		textField:'Source'
	});
	//上级Location下拉框
	$('#DEPLParentLocID').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.CTDepartmentLocation&QueryName=GetParentLoc&ResultSetType=array",
		valueField:'DEPLLocID',
		textField:'DEPLLocDesc',
		onBeforeLoad: function(param){
			//$('#DEPLLocSource').combobox('getValue')
		}
	});
	
	//查询按钮
	$("#btnSearch").click(function (e) { 

			SearchFunLib();
	 })  
	 
	//重置按钮
	$("#btnRefresh").click(function (e) { 

			ClearFunLib();
	 }) 
	
	//点击添加按钮
	$("#btnAdd").click(function(e){
		AddData();
	});
	//点击修改按钮
	$("#btnUpdate").click(function(e){
		UpdateData();
	});
	//点击删除按钮
	$("#btnDel").click(function (e) { 
		DelData();
	});	
	
	//查询方法
	SearchFunLib=function(){
		var deptdesc=$.trim($("#TextDept").val());
		var locsource=$.trim($("#TextLocSource").val());
		var loccode=$.trim($('#TextLocCode').val());
		var locdesc=$.trim($('#TextLocDesc').val());
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.CT.CTDepartmentLocation",
			QueryName:"GetList",
			'deptdesc':deptdesc,
			'locsource':locsource,	
			'loccode':loccode,
			'locdesc':locdesc
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	//重置方法
	ClearFunLib=function()
	{
		$("#TextDept").val("");
		$("#TextLocSource").val("");
		$("#TextLocCode").val("");
		$("#TextLocDesc").val("");
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.CT.CTDepartmentLocation",
			QueryName:"GetList"
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	///删除
	DelData=function()
	{                  
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
			if (r){	
				$.ajax({
					url:DELETE_ACTION_URL,  
					data:{
						"id":record.ID      ///rowid
					},  
					type:"POST",   
					success: function(data){
							  var data=eval('('+data+')'); 
							  if (data.success == 'true') {
									$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
									
									$('#mygrid').datagrid('reload');  // 重新载入当前页面数据  
									$('#mygrid').datagrid('unselectAll');  // 清空列表选中数据
							  } 
							  else { 
									var errorMsg ="删除失败！"
									if (data.info) {
										errorMsg =errorMsg+ '<br/>错误信息:' + data.info
									}
									$.messager.alert('操作提示',errorMsg,"error");
					
							}			
					}  
				})
			}
		});
	}
	
	///新增、修改
	SaveFunLib=function(id)
	{			
		if ($('#DEPLDeptDR').combobox('getValue')=="")
		{
			$.messager.alert('错误提示','组织部门不能为空!',"info");
			return;
		}
		if ($('#DEPLLocSource').combobox('getValue')=="")
		{
			$.messager.alert('错误提示','Location来源不能为空!',"info");
			return;
		}
		if ($('#DEPLLocID').combobox('getValue')=="")
		{
			$.messager.alert('错误提示','Location不能为空!',"info");
			return;
		}
		var flag = tkMakeServerCall("web.DHCBL.CT.CTDepartmentLocation","FormValidate",$("#ID").val(),$('#DEPLDeptDR').combobox('getValue'),$('#DEPLLocSource').combobox('getValue'),$('#DEPLLocID').combobox('getValue'),"");	
		if (flag==1)
		{
			$.messager.alert('操作提示',"该记录已经存在！","info");
			return;
		}
		/*
		if (($('#DEPLLocID').combobox('getValue')=="")&&($('#DEPLLocID').combobox('getText')!=""))
		{
			$('#DEPLLocID').combobox('setValue',$('#DEPLLocID').combobox('getText'))
			alert($('#DEPLLocID').combobox('getValue'));
		}
		*/
		$.messager.confirm('提示', "确认要保存数据吗?", function(r){
			if (r){
				$('#form-save').form('submit', { 
					url: SAVE_ACTION_URL, 
					success: function (data) { 
						  var data=eval('('+data+')'); 
						  if (data.success == 'true') {
								$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
								if (id!="")
								{
									$('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
								}
								else{
									
									 $.cm({
										ClassName:"web.DHCBL.CT.CTDepartmentLocation",
										QueryName:"GetList",
										rowid: data.id   
									},function(jsonData){
										$('#mygrid').datagrid('insertRow',{
											index:0,
											row:jsonData.rows[0]
										})
									})
									$('#mygrid').datagrid('unselectAll');
								}
								$('#myWin').dialog('close'); // close a dialog
						  } 
						  else { 
								var errorMsg ="提交失败！"
								if (data.errorinfo) {
									errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
								}
								$.messager.alert('操作提示',errorMsg,"error");
				
						}
		
					} 
				});
			}
		})

	}
	
	//点击新增按钮
	AddData=function() {
		$("#myWin").show();
		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-w-add',
			resizable:true,
			title:'新增',
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				text:'保存',
				id:'save_btn',
				handler:function(){
					SaveFunLib("")
				}
			},{
				text:'关闭',
				handler:function(){
					myWin.close();
				}
			}]
		});	
		$('#form-save').form("clear");
	}
	
	//点击修改按钮
	UpdateData=function() {
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		if (record.DEPLLocSource!="CT_Loc")
		{	
			$.messager.alert('提示','不允许对Location来源为“CT_Loc”以外的数据进行修改!',"info");
			return;
		}
		var id=record.ID
		$.cm({
			ClassName:"web.DHCBL.CT.CTDepartmentLocation",
			MethodName:"OpenData",
			id:id
			},function(jsonData){
				$('#form-save').form("load",jsonData);
				$("#myWin").show(); 
				var myWin = $HUI.dialog("#myWin",{
					iconCls:'icon-w-edit',
					resizable:true,
					title:'修改',
					modal:true,
					buttons:[{
						text:'保存',
						id:'save_btn',
						handler:function(){
							SaveFunLib(id)
						}
					},{
						text:'关闭',
						handler:function(){
							myWin.close();
						}
					}]
				});		
			}
		);
	}
	
	var columns =[[
				{field:'ID',title:'ID',width:80,hidden:true,sortable:true},
				{field:'CTRFCCode',title:'医疗机构代码',width:120,sortable:true},
				{field:'CTRFCDesc',title:'医疗机构名称',width:120,sortable:true},
				{field:'DEPRowId',title:'HR组织部门代码',width:120,sortable:true},
				{field:'DEPLDeptDR',title:'组织部门名称',width:120,sortable:true},
				{field:'DEPLLocSource',title:'Location来源',width:120,sortable:true},
				{field:'DEPLLocID',title:'LocationID',width:80,sortable:true,hidden:true},
				{field:'DEPLLocCode',title:'Location代码',width:120,sortable:true},
				{field:'DEPLLocDesc',title:'Location名称',width:120,sortable:true},
				{field:'LocationType',title:'Location类型',width:100,sortable:true},
				{field:'DEPLParentLocID',title:'上级LocationID',width:80,sortable:true,hidden:true},
				{field:'DEPLParentLocSource',title:'上级Location来源',width:130,sortable:true},
				{field:'DEPLParentLocCode',title:'上级Location代码',width:130,sortable:true},
				{field:'DEPLParentLocDesc',title:'上级Location名称',width:130,sortable:true},
				{field:'DEPLDateFrom',title:'开始日期',width:120,sortable:true},
				{field:'DEPLDateTo',title:'结束日期',width:120,sortable:true},
				]];
	
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.CT.CTDepartmentLocation",
			QueryName:"GetList"
		},
		columns: columns,  //列信息
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:20,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		ClassTableName:'User.CTDepartmentLocation',
		SQLTableName:'CT_DepartmentLocation',
		idField:'ID', 
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true, //列号 自适应宽度
		fitColumns:false, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort:false,  //定义是否从服务器排序数据。true
		onDblClickRow:function(rowIndex,rowData){
        	UpdateData();
        },
        onLoadSuccess:function(data){
	        $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
        	$(this).datagrid('columnMoving'); //列可以拖拽改变顺序
        }
		
	});
	ShowUserHabit('mygrid');
	
	
};
$(init);