
//Creator:yangfan
//CreatDate:2020-03-15
//Description:检验项目

var init = function(){
	
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.LAB.BTTestCode&pClassMethod=DeleteData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.LAB.BTTestCode&pClassMethod=SaveEntity&pEntityName=web.Entity.LAB.BTTestCode";
	
	
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
	 
	 //查询方法
	SearchFunLib=function(){
		var code=$.trim($("#TextCode").val());
		var desc=$.trim($('#TextDesc').val());
		var hospitaldr=$("#TextHospital").combobox('getValue')
		var scodedr=$("#TextSCode").combobox('getValue')
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.LAB.BTTestCode",
			QueryName:"GetList",	
			'code':code,	
			'desc':desc,
			'hospitaldr':hospitaldr,
			'scodedr':scodedr
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	//重置方法
	ClearFunLib=function()
	{
		$("#TextCode").val("");
		$("#TextDesc").val("");
		$("#TextHospital").combobox('setValue','');
		$("#TextSCode").combobox('setValue','');
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.LAB.BTTestCode",
			QueryName:"GetList"
		});
		$('#mygrid').datagrid('unselectAll');

	}
	
	//查询工具栏医院下拉框
	$('#TextHospital').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.LAB.BTHospital&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'RowID',
		textField:'CName'
	});
	
	//医院下拉框
	$('#HospitalDR').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.LAB.BTHospital&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'RowID',
		textField:'CName'
	});

	//查询工具栏标准码下拉框
	$('#TextSCode').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.LAB.BTTestCodeSCode&QueryName=GetDataForCmb1&ResultSetType=array",		
		valueField:'SCode',
		textField:'TCName'
	});
	
	//标准码下拉框
	$('#SCode').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.LAB.BTTestCodeSCode&QueryName=GetDataForCmb1&ResultSetType=array",		
		valueField:'SCode',
		textField:'TCName'
	});
	
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
			$.messager.alert('错误提示','描述不能为空!',"info");
			return;
		}
		var HospitalDR=$('#HospitalDR').combobox('getValue')	
		if ((HospitalDR==undefined)||(HospitalDR=="undefined") )
		{
			$.messager.alert('错误提示','医院请选择下拉列表里的值!',"info");
			return;
		}
		var flag = tkMakeServerCall("web.DHCBL.LAB.BTTestCode","FormValidate",$("#RowID").val(),$("#Code").val(),$('#HospitalDR').combobox('getValue'));	
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
									$('#mygrid').datagrid('unselectAll');
								}
								else{
									
									 $.cm({
										ClassName:"web.DHCBL.LAB.BTTestCode",
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
		$('#HospitalDR').combobox('reload');
		$('#SCode').combobox('reload');
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
		$('#HospitalDR').combobox('reload');
		$('#SCode').combobox('reload');
		var record=mygrid.getSelected(); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		var id=record.RowID
		$.cm({
			ClassName:"web.DHCBL.LAB.BTTestCode",
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

	

	///删除
	DelData=function()
	{                  
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	$.messager.alert('错误提示','请先选择一条记录!',"error");
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
	
	//datagrid排序：
	function sort_int(a,b){
		if(a.length >b.length) return 1;
		else if (a.length <b.length) return -1;
		else if (a > b) return 1;
		else return -1;
	}
	
	var columns =[[
				  {field:'RowID',title:'RowID',width:80,hidden:true,sortable:true},
                  {field:'Sequence',title:'序号',width:40,sortable:true,sorter:sort_int},
				  {field:'Code',title:'代码',width:40,sortable:true},
				  {field:'CName',title:'描述',width:150,sortable:true},
				  {field:'SCode',title:'标准码',width:60,sortable:true},
				  {field:'HospitalDR',title:'关联医院',width:150,sortable:true},
				  {field:'Active',title:'激活',width:60,sortable:true,align:'center',formatter:ReturnFlagIcon} 
				  ]];
				  
				  
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.LAB.BTTestCode",
			QueryName:"GetList"
		},
		columns: columns,  //列信息
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:20,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		ClassTableName:'dbo.BTTestCode',
		SQLTableName:'dbo.BT_TestCode',
		idField:'RowID', 
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true, //列号 自适应宽度
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort:false,  //定义是否从服务器排序数据。true
		/*
		toolbar:[{
			iconCls:'icon-add',
			text:'新增',
			id:'add_btn',
			handler:AddData
		},{
			iconCls:'icon-write-order',
			text:'修改',
			id:'update_btn',
			handler:UpdateData
		},{
			iconCls:'icon-cancel',
			text:'删除',
			id:'del_btn',
			handler:DelData
		}],
		*/
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