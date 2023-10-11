//Creator:基础数据平台-李可凡
//CreatDate:2019年11月14日
//Description:工作小组表

var init = function(){
	
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.LAB.BTWorkGroupMachine&pClassMethod=SaveEntity&pEntityName=web.Entity.LAB.BTWorkGroupMachine";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.LAB.BTWorkGroupMachine&pClassMethod=DeleteData";
	
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
		var code=$.trim($("#TextCode").val());
		var desc=$.trim($('#TextDesc').val());
		var workgroupdr=$("#TextWorkGroup").combobox('getValue')
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.LAB.BTWorkGroupMachine",
			QueryName:"GetList",	
			'code':code,	
			'desc':desc,
			'workgroupdr':workgroupdr
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	//重置方法
	ClearFunLib=function()
	{
		$("#TextCode").val("");
		$("#TextDesc").val("");
		$("#TextWorkGroup").combobox('setValue','');
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.LAB.BTWorkGroupMachine",
			QueryName:"GetList"
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	//查询工具栏工作组下拉框
	$('#TextWorkGroup').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.LAB.BTWorkGroup&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'RowID',
		textField:'CName'
	});
	
	//所属小组下拉框
	$('#OwnWorkGroupMachineDR').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.LAB.BTWorkGroupMachine&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'RowID',
		textField:'CName'
	});
	
	//工作组下拉框
	$('#WorkGroupDR').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.LAB.BTWorkGroup&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'RowID',
		textField:'CName'
	});
	
	//所在房间下拉框
	$('#RoomDR').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.LAB.BTRoom&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'RowID',
		textField:'CName'
	});
	
	//通讯方式
	$('#CommDirection').combobox({ 
		data:[{
				'value':'UI',
				'text':'单向通讯'
				},{
				'value':'BI',
				'text':'双向通讯'
				},{
				'value':'LS',
				'text':'装载列表'
				},{
				'value':'UP',
				'text':'主动上传'
			}],
		 valueField:'value',
		 textField:'text',
		 panelHeight:'auto'
	});
	
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
						"id":record.RowID      ///rowid
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
		if ($.trim($("#Code").val())=="")
		{
			$.messager.alert('错误提示','代码不能为空!',"info");
			return;
		}
		if ($.trim($("#CName").val())=="")
		{
			$.messager.alert('错误提示','名称不能为空!',"info");
			return;
		}
		
		var WorkGroupDR=$('#WorkGroupDR').combobox('getValue')	
		if (WorkGroupDR=="")
		{
			$.messager.alert('错误提示','工作组不能为空!',"info");
			return;
		}
		if ((WorkGroupDR==undefined)||(WorkGroupDR=="undefined") )
		{
			$.messager.alert('错误提示','工作组请选择下拉列表里的值!',"info");
			return;
		}	
		var RoomDR=$('#RoomDR').combobox('getValue')	
		if ((RoomDR==undefined)||(RoomDR=="undefined") )
		{
			$.messager.alert('错误提示','所在房间请选择下拉列表里的值!',"info");
			return;
		}	
		var OwnWorkGroupMachineDR=$('#OwnWorkGroupMachineDR').combobox('getValue')	
		if ((OwnWorkGroupMachineDR==undefined)||(OwnWorkGroupMachineDR=="undefined") )
		{
			$.messager.alert('错误提示','所属小组请选择下拉列表里的值!',"info");
			return;
		}	
		var CommDirection=$('#CommDirection').combobox('getValue')
		if ((CommDirection==undefined)||(CommDirection=="undefined")) 
		{
			$.messager.alert('错误提示','通讯方式请选择下拉列表里的值!',"info");
			return;
		}	
		var flag = tkMakeServerCall("web.DHCBL.LAB.BTWorkGroupMachine","FormValidate",$("#RowID").val(),$("#Code").val(),$('#WorkGroupDR').combobox('getValue'));	
		if (flag==1)
		{
			$.messager.alert('操作提示',"该记录已经存在！","info");
			return;
		}
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
										ClassName:"web.DHCBL.LAB.BTWorkGroupMachine",
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
		$('#OwnWorkGroupMachineDR').combobox('reload');
		$('#WorkGroupDR').combobox('reload');
		$('#RoomDR').combobox('reload');
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
		$HUI.checkbox("#Active").setValue(true);
	}
	
	//点击修改按钮
	UpdateData=function() {
		$('#OwnWorkGroupMachineDR').combobox('reload');
		$('#WorkGroupDR').combobox('reload');
		$('#RoomDR').combobox('reload');
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		var id=record.RowID
		$.cm({
			ClassName:"web.DHCBL.LAB.BTWorkGroupMachine",
			MethodName:"OpenData",
			id:id
		},function(jsonData){
			if (jsonData.Active==1)
				{
					$HUI.checkbox("#Active").setValue(true);	
				}else{
					$HUI.checkbox("#Active").setValue(false);
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
		});
	}
	
	//datagrid排序：
	function sort_int(a,b){
		if(a.length >b.length) return 1;
		else if (a.length <b.length) return -1;
		else if (a > b) return 1;
		else return -1;
	}
	
	var columns =[[  
				  {field:'RowID',title:'RowId',width:80,hidden:true,sortable:true},
				  {field:'Sequence',title:'序号',width:50,sortable:true,sorter:sort_int},
				  {field:'Code',title:'代码',width:100,sortable:true},
				  {field:'CName',title:'名称',width:150,sortable:true},
				  {field:'WorkGroupDR',title:'工作组',width:120,sortable:true},
				  {field:'Active',title:'激活',width:80,sortable:true,align:'center',formatter:ReturnFlagIcon},
				  {field:'ReportTempl',title:'报告模板',width:150,sortable:true},
				  {field:'Leader',title:'负责人',width:80,sortable:true},
				  {field:'Telephone',title:'联系电话',width:120,sortable:true},
				  {field:'RoomDR',title:'所在房间',width:120,sortable:true},
				  {field:'CommDirection',title:'通讯方式',width:100,sortable:true},
				  {field:'OwnWorkGroupMachineDR',title:'所属小组',width:150,sortable:true}
				  
				  ]];
	
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.LAB.BTWorkGroupMachine",
			QueryName:"GetList"
		},
		columns: columns,  //列信息
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:PageSizeMain,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		ClassTableName:'dbo.BTWorkGroupMachine',
		SQLTableName:'dbo.BT_WorkGroupMachine',
		idField:'RowID', 
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true, //列号 自适应宽度
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
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
	
	HISUI_Funlib_Translation('mygrid');
    HISUI_Funlib_Sort('mygrid');
};
$(init);