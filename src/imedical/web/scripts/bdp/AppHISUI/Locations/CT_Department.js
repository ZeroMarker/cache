//Creator:基础数据平台-李可凡
//CreatDate:2020-07026
//Description:HIS-Location与HR-组织关联关系表(HCP)

var init = function(){
	
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTDepartment&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTDepartment";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTDepartment&pClassMethod=DeleteData";
	
	$('#TextRowId').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchFunLib();
		}
		if(event.keyCode == 27) {
		  ClearFunLib();
		}
	});
	$('#TextCode').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchFunLib();
		}
		if(event.keyCode == 27) {
		  ClearFunLib();
		}
	});
	$('#TextDesc').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchFunLib();
		}
		if(event.keyCode == 27) {
		  ClearFunLib();
		}
	});
	
	//检索栏医疗机构下拉框
	$('#TextRefClin').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.CTRefClin&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'CTRFCRowId',
		textField:'CTRFCDesc'
	});
	
	//上级组织部门下拉框
	$('#DEPParentDR').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.CTDepartment&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'ID',
		textField:'DEPDesc'
	});
	//医疗机构下拉框
	$('#DEPRefClinDR').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.CTRefClin&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'CTRFCRowId',
		textField:'CTRFCDesc'
	});
	
	//科室分类
	$('#DEPCategory').combobox({ 
		data:[{'value':'01','text':'临床科室'},
			{'value':'02','text':'医技科室'},
			{'value':'03','text':'医辅科室'},
			{'value':'04','text':'职能科室'},
			{'value':'05','text':'党群科室'},
			{'value':'06','text':'后勤科室'},
			{'value':'99','text':'其他'}],
        valueField:'value',
        textField:'text',
        panelHeight:'auto'
	});
	//组织属性
	$('#DEPAtrribute').combobox({ 
		data:[{'value':'01','text':'行政序列'},
			{'value':'01.01','text':'职能科室序列'},
			{'value':'01.02','text':'临床科室序列'},
			{'value':'01.03','text':'医技科室序列'},
			{'value':'01.04','text':'医辅科室序列'},
			{'value':'01.05','text':'后勤科室序列'},
			{'value':'02','text':'党群序列'},
			{'value':'02.01','text':'党建序列'},
			{'value':'02.02','text':'团委序列'},
			{'value':'02.03','text':'工会序列'},
			{'value':'03','text':'委员会序列'},
			//{'value':'04','text':'业务线'},
			{'value':'09','text':'其他序列'}],
        valueField:'value',
        textField:'text',
        panelHeight:'auto'
	});
	//部门性质
	$('#DEPCharacter').combobox({ 
		data:[{'value':'1','text':'临床'},
			{'value':'2','text':'医技'},
			{'value':'3','text':'医辅'},
			{'value':'4','text':'管理'}],
        valueField:'value',
        textField:'text',
        panelHeight:'auto'
	});
	//支出属性
	$('#DEPPayAtrribute').combobox({ 
		data:[{'value':'1','text':'医疗'},
			{'value':'2','text':'管理'},
			{'value':'3','text':'物资加工'}],
        valueField:'value',
        textField:'text',
        panelHeight:'auto'
	});
	//分摊性质
	$('#DEPShareCharacter').combobox({ 
		data:[{'value':'1','text':'管理'},
			{'value':'2','text':'门诊医辅'},
			{'value':'3','text':'内部定价'}],
        valueField:'value',
        textField:'text',
        panelHeight:'auto'
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
		var hrid=$.trim($("#TextRowId").val());
		var code=$.trim($('#TextCode').val());
		var desc=$.trim($('#TextDesc').val());
		var refclin=$('#TextRefClin').combobox('getValue');
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.CT.CTDepartment",
			QueryName:"GetList",
			'hrid':hrid,	
			'code':code,
			'desc':desc,
			'refclin':refclin
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	//重置方法
	ClearFunLib=function()
	{
		$("#TextRowId").val("");
		$("#TextCode").val("");
		$("#TextDesc").val("");
		$("#TextRefClin").combobox('setValue','');
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.CT.CTDepartment",
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
		if ($.trim($("#DEPRowId").val())=="")
		{
			$.messager.alert('错误提示','HR组织部门代码不能为空!',"info");
			return;
		}
		if ($.trim($("#DEPDesc").val())=="")
		{
			$.messager.alert('错误提示','组织部门名称不能为空!',"info");
			return;
		}
		if ($('#DEPRefClinDR').combobox('getValue')=="")
		{
			$.messager.alert('错误提示','医疗机构不能为空!',"info");
			return;
		}
		if ($('#DEPDateFrom').datebox('getValue')=="")
		{
			$.messager.alert('错误提示','开始日期不能为空!',"info");
			return;
		}
		var startdate=$('#DEPDateFrom').datebox('getValue');
		var enddate=$('#DEPDateTo').datebox('getValue');
		if ((startdate!="")&&(enddate!="")&&(startdate>enddate))
		{
			$.messager.alert('错误提示','开始日期不能大于结束日期!',"info");
			return;
		}
		var flag = tkMakeServerCall("web.DHCBL.CT.CTDepartment","FormValidate",$("#ID").val(),$("#DEPRowId").val());	
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
										ClassName:"web.DHCBL.CT.CTDepartment",
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
		var id=record.ID
		$.cm({
			ClassName:"web.DHCBL.CT.CTDepartment",
			MethodName:"OpenData",
			id:id
			},function(jsonData){
				if (jsonData.DEPPurchaseFlag=="Y")
				{
					$HUI.checkbox("#DEPPurchaseFlag").setValue(true);	
				}else{
					$HUI.checkbox("#DEPPurchaseFlag").setValue(false);
				}
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
				{field:'DEPRowId',title:'组织部门代码',width:120,sortable:true},
				{field:'DEPCode',title:'院内编码',width:120,sortable:true},
				{field:'DEPDesc',title:'组织部门名称',width:120,sortable:true},
				{field:'DEPAlias',title:'简称',width:120,sortable:true},
				{field:'DEPOfficePhone',title:'联系电话',width:120,sortable:true},
				{field:'DEPCategory',title:'科室分类',width:120,sortable:true},
				{field:'DEPParentDR',title:'上级组织部门',width:120,sortable:true},
				{field:'DEPRefClinDR',title:'医疗机构',width:120,sortable:true},
				{field:'DEPAtrribute',title:'组织属性',width:120,sortable:true},
				{field:'DEPUpdateUserName',title:'修改人名称',width:120,sortable:true},
				{field:'DEPCharacter',title:'部门性质',width:120,sortable:true},
				{field:'DEPPayAtrribute',title:'支出属性',width:120,sortable:true},
				{field:'DEPPurchaseFlag',title:'是否采购部门',width:120,sortable:true,align:'center',formatter:ReturnFlagIcon},
				{field:'DEPShareCharacter',title:'分摊性质',width:120,sortable:true},
				{field:'DEPDateFrom',title:'开始日期',width:120,sortable:true},
				{field:'DEPDateTo',title:'结束日期',width:120,sortable:true},
				{field:'DEPNationalCode',title:'统计国家编码',width:120,sortable:true},
				{field:'DEPOfficeAddress',title:'地址',width:120,sortable:true}
				]];
	
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.CT.CTDepartment",
			QueryName:"GetList"
		},
		columns: columns,  //列信息
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:20,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		ClassTableName:'User.CTDepartment',
		SQLTableName:'CT_Department',
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