/*
* @Author: 基础数据平台-谢海睿
* @Date:   2019-11-14
* @描述:检验-标本分管维护
*/
//合管组合套分组保存
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.LAB.BTTestSetGroup&pClassMethod=SaveEntity&pEntityName=web.Entity.LAB.BTTestSetGroup";
//关联保存
var SAVE_ACTION_URL_LINK = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.LAB.BTTestSetGroupLinks&pClassMethod=SaveEntity&pEntityName=web.Entity.LAB.BTTestSetGroupLinks";//关联保存
//合管组合套删除
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.LAB.BTTestSetGroup&pClassMethod=DeleteData";
//关联删除
var DELETE_ACTION_URL_Link = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.LAB.BTTestSetGroupLinks&pClassMethod=DeleteData";
var init=function()
{
	//datagrid排序：
	function sort_int(a,b){
		if(a.length >b.length) return 1;
		else if (a.length <b.length) return -1;
		else if (a > b) return 1;
		else return -1;
	}
    ///合管组合套分组
    var columns =[[
		{field:'RowID',title:'RowID',sortable:true,width:100,hidden:true},
		{field:'SeqNum',title:'序号',sortable:true,width:50, sorter:sort_int},
        {field:'Code',title:'代码',sortable:true,width:100},
        {field:'CName',title:'名称',sortable:true,width:100},
        {field:'HospitalDR',title:'医院',sortable:true,width:350,hidden:true},
        {field:'Active',title:'激活',sortable:true,width:50,formatter:ReturnFlagIcon}
    ]];
    var Groupgrid = $HUI.datagrid("#Groupgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.LAB.BTTestSetGroup",
            QueryName:"GetList"
        },
        columns: columns,  //列信息
		SQLTableName:'dbo.BT_TestSetGroup',
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        remoteSort:false,
        idField:'RowID',
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onLoadSuccess:function(data)
        {
            $(this).prev().find('div.datagrid-body').prop('scrollTop',0);
        },
        onDblClickRow:function(index,row)
        {
        	UpdateData();
		},
		onClickRow:function(index,row)
		{
			SearchFunLibLink();
		}		
    });

    ///检验医嘱(项目组合套)
    var TestSetcolumns =[[
	    {field:'RowID',title:'RowId',width:100,sortable:true,hidden:true},
	    {field:'Code',title:'代码',width:100,sortable:true},
		{field:'CName',title:'名称',width:100,sortable:true},
		{field:'opt',title:'操作',width:50,align:'center',
		//封装？
			formatter:function(){  
                var btn =  '<img class="contrast mytooltip" title="关联" onclick="ConMethod()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png" style="border:0px;cursor:pointer">'   
				return btn;  
			}  
      }  
    ]];
    var TestSetgrid= $HUI.datagrid("#TestSetgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.LAB.BTTestSet",
            QueryName:"GetList"
        },
        columns: TestSetcolumns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        remoteSort:false,
        idField:'RowID',
        singleSelect:true,
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onLoadSuccess:function(data){
            $(this).prev().find('div.datagrid-body').prop('scrollTop',0);
		},
	});
	//关联
    var Linkcolumns =[[
        {field:'RowID',title:'RowID',width:100,hidden:true,sortable:true},
        {field:'TestSetGroupDR',title:'合管组合套分组',width:100,sortable:true},
		{field:'TestSetDR',title:'项目组合套名称',width:100,sortable:true},
		{field:'opt',title:'操作',width:50,align:'center',
			formatter:function(){  
                var btn =  '<img class="contrast" onclick="DelDataLink()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png" style="border:0px;cursor:pointer">' 
				return btn;  
			}  
        }
     ]];
    var Linkgrid = $HUI.datagrid("#Linkgrid",{
        url:$URL,
		
        columns:Linkcolumns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        remoteSort:false,
        singleSelect:true,
        idField:'RowID',
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		
	});
	$('#GroupTextCName').keyup(function(event)
	{
		if(event.keyCode == 13) 
		{ 
			GroupSearchFunLib();
		}
		if(event.keyCode == 27){
			$("#GroupTextCName").val('');
			$('#Groupgrid').datagrid('load',{
			ClassName: "web.DHCBL.LAB.BTTestSetGroup",
			QueryName:"GetList"
		});
		$('#Linkgrid').datagrid('loadData',[]);
		$('#Groupgrid').datagrid('unselectAll');
		}
	}); 
	//搜索回车事件，ESC事件(检验医嘱)
	$('#TextCode').keyup(function(event)
	{
		if(event.keyCode == 13) 
		{
			SearchFunLib();
		}
		if(event.keyCode == 27){
			$("#TextCode").val('');
			$('#TestSetgrid').datagrid('load',{
			ClassName: "web.DHCBL.LAB.BTTestSet",
            QueryName:"GetList"
		});
		$('#TestSetgrid').datagrid('unselectAll');
		}
	}); 
    
    //医院下拉框
	$('#HospitalDR').combobox({
		url:$URL+"?ClassName=web.DHCBL.LAB.BTHospital&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'RowID',
		textField:'CName'
	});
     //点击查询按钮(检验医嘱查询)
     $('#btnSearch').click(function(e)
     {
        SearchFunLib();
	 });

	 //点击查询按钮(合管组合套分组)
     $('#btnSearchGroup').click(function(e)
     {
        GroupSearchFunLib();
	 });

	//点击查询按钮(关联)
     $('#btnSearchLink').click(function(e)
     {
        LinkSearchFunLib();
	 });
	 
    //点击重置按钮（检验医嘱(项目组合套)）
	$('#btnRefresh').click(function(e)
	{
		$("#TextCode").val('');
		$('#TestSetgrid').datagrid('load',{
			ClassName: "web.DHCBL.LAB.BTTestSet",
            QueryName:"GetList"
		});
		var TestSetGroupDR=$('#Groupgrid').datagrid('getSelected');
		if(TestSetGroupDR!=null){
			$('#Linkgrid').datagrid('load',{
				ClassName:"web.DHCBL.LAB.BTTestSetGroupLinks",
				QueryName:"GetList",
				testsetgroupdr:TestSetGroupDR.RowID,
				testsetdr:""
			});
		}else{
			$('#Linkgrid').datagrid('loadData',[]);
		};
		$('#TestSetgrid').datagrid('unselectAll');
	});

	//点击重置按钮（合管组合套分组）
	$('#GroupbtnRefresh').click(function(e)
	{
		$("#GroupTextCName").val('');
		$('#Groupgrid').datagrid('load',{
			ClassName:"web.DHCBL.LAB.BTTestSetGroup",
			QueryName:"GetList"
		});
		$('#Linkgrid').datagrid('loadData',[]);
		$('#Groupgrid').datagrid('unselectAll');
	});
    //点击添加按钮(合管组合套分组)
    $('#add_btn').click(function(e)
    {
        AddData();
	});

	
    //点击修改按钮（合管组合套分组）
	$('#update_btn').click(function(e)
	{
    	UpdateData();
	});

    //点击删除按钮（合管组合套分组）
	$('#del_btn').click(function(e)
	{
    	DelData();
	});
	//删除方法（合管组合套分组）
    DelData=function()
    {
		var row = $("#Groupgrid").datagrid('getSelected'); 
		if (!(row))
		{
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var rowid=row.RowID;
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r)
		{
			if (r)
			{
				$.ajax(
					{
						url:DELETE_ACTION_URL,  
						data:{"id":rowid},  
						type:"POST",     
						success: function(data)
						{
							var data=eval('('+data+')'); 
							if (data.success == 'true') 
							{
								$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
								$('#Groupgrid').datagrid('reload');  // 重新载入当前页面数据 
								$('#Groupgrid').datagrid('unselectAll');  // 清空列表选中数据 
							} 
							else {
								var errorMsg ="删除失败！"
								if (data.info) 
								{
									errorMsg =errorMsg+ '<br/>错误信息:' + data.info
								}
								$.messager.alert('操作提示',errorMsg,"error");
					
							}			
						}  
					});
			}
		});    	
	} 
	//关联，1对1
    ConMethod=function()
    {
 		setTimeout(function(){
			var Groupgrid=$("#Groupgrid").datagrid('getSelected');
			var TestSetgrid=$("#TestSetgrid").datagrid('getSelected');
			if(!Groupgrid)
			{
				$.messager.alert('错误提示','请选择需要关联的合管组合套分组！',"error");
            	return;
			}
			var ids=Groupgrid.RowID+'^'+TestSetgrid.RowID;
			var flag=tkMakeServerCall("web.DHCBL.LAB.BTTestSetGroupLinks","FormValidate","",Groupgrid.RowID,TestSetgrid.RowID);
			if(flag!=1){
				$.messager.confirm("提示", "确认要保存关联数据吗?", function (r) {
					if (r) 
					{
						var data=tkMakeServerCall("web.DHCBL.LAB.BTTestSetGroupLinks","SaveData",ids);
						var data=eval('('+data+')');
						var TestSetGroupDR=Groupgrid.RowID;
						if (data.success == 'true') {
							$.messager.popover({msg: '关联成功！',type:'success',timeout: 1000});
							if(Groupgrid!=null){
								var TestSetGroupDR=Groupgrid.RowID;
								$('#Linkgrid').datagrid('load',{
									ClassName:"web.DHCBL.LAB.BTTestSetGroupLinks",
									QueryName:"GetList",
									testsetgroupdr:TestSetGroupDR
								});
							}else{
								$('#Linkgrid').datagrid('loadData',[]);
							}
						}
						else
						{
							var errorMsg ="关联失败！"
							if (data.info) {
								errorMsg =errorMsg+ '<br/>错误信息:' + data.info
							}
							$.messager.alert('操作提示',errorMsg,"error");				
						}
						
					}	
					else{
							return false;
						}
				})
			}			
			else 
			{
				$.messager.alert('错误提示',"该条记录重复","info");
			}
			},100);	 
    }
	//删除方法（关联）
    DelDataLink=function()
    {
		setTimeout(function(){
			var row = $("#Linkgrid").datagrid('getSelected'); 
			if(row)
			{
				var rowid=row.RowID;
						$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r)
						{
							if (r)
							{
								$.ajax(
									{
										url:DELETE_ACTION_URL_Link,  
										data:{"id":rowid},  
										type:"POST",     
										success: function(data)
										{
											var data=eval('('+data+')'); 
											if (data.success == 'true') 
											{  
												var TestSetGroupDR=$('#Groupgrid').datagrid('getSelected');
												if(TestSetGroupDR!=null){
													$('#Linkgrid').datagrid('load',{
														ClassName:"web.DHCBL.LAB.BTTestSetGroupLinks",
														QueryName:"GetList",
														testsetgroupdr:TestSetGroupDR.RowID
													});
												}else{
													$('#Linkgrid').datagrid('loadData',[]);
												};
												$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});	
											}	 
											else {
												var errorMsg ="删除失败！"
												if (data.info) 
												{
													errorMsg =errorMsg+ '<br/>错误信息:' + data.info
												}
												$.messager.alert('操作提示',errorMsg,"error");
									
											}			
										}  
									});
							}
							else{
								return false;
							}
						});
			}
		 
	},100)   	
	} 
	//添加方法（合管组合套分组）
    AddData=function()
    {
		$("#myWin").show();
		var myWin = $HUI.dialog("#myWin",
		{
			iconCls:'icon-w-add',
			resizable:true,
			title:'新增',
			modal:true,
			buttonAlign : 'center',
			buttons:
			[
				{
					text:'保存',
					id:'save_btn',
					handler:function()
					{		
						SaveFunLib("");		
					}
				},
			    {
					text:'关闭',
					handler:function()
					{
						myWin.close();
						editIndex = undefined;
					}
			    }
			],
			
		});
		$('#form-save').form("clear");
		$HUI.checkbox("#Active").setValue(true);
	}
	//修改数据方法（合管组合套分组）
    UpdateData = function()
	{
        var record = Groupgrid.getSelected();
		if(record)
		{
			var id=record.RowID; 
			//同步基本信息
			$.cm(
				{
					ClassName:"web.DHCBL.LAB.BTTestSetGroup",
					MethodName:"OpenData",
					id:id
			    },
				function(jsondata)
				{
					if(jsondata.Active==1){
						$HUI.checkbox("#Active").setValue(true);
                    }else{
                        $HUI.checkbox("#Active").setValue(false);
                    }
					$('#form-save').form("load",jsondata);
				}
            );
			$("#myWin").show();
			var myWin = $HUI.dialog("#myWin",
			{
				iconCls:'icon-w-edit',
				resizable:true,
				title:'修改',
				modal:true,
				buttons:[
					{
						text:'保存',
						id:'save_btn',
						handler:function()
						{
							
							SaveFunLib(id);
																	
						},
					},	
					{
						text:'关闭',
						handler:function()
						{
							 myWin.close();
							 editIndex = undefined;
						}
					}
				],
				onClose:function()
				{
					editIndex = undefined;
				}
			});	
		}
		else
		{
			$.messager.alert('错误提示','请先选择一条记录!',"error");
		}
	}
	//保存（合管组合套分组）
    SaveFunLib=function(id)
    {
		var Code=$.trim($("#Code").val());
		var CName=$.trim($("#CName").val());
		///判空	
		if (Code=="")
		{
			$.messager.alert('错误提示','代码不能为空!',"error");
			return;
		}
		if (CName=="")
		{
			$.messager.alert('错误提示','内部名称不能为空!',"error");
			return;
		}
		var HospitalDR=$('#HospitalDR').combobox('getValue')
		if ((HospitalDR==undefined)||(HospitalDR=="undefined")||(HospitalDR==""))
		{
			$.messager.alert('错误提示','医院请选择下拉列表里的值',"error");
			return;
		}
		var result= tkMakeServerCall("web.DHCBL.LAB.BTTestSetGroup","FormValidate",id,Code,HospitalDR);
		if(result==0){
			$.messager.confirm("提示", "确认要保存数据吗?", function (r) {
				if (r) 
				{
					$('#form-save').form('submit', 
					{
						url:SAVE_ACTION_URL,
						onSubmit: function(param)
						{
							param.RowID=id;
						},
						success: function (data) 
						{
							var data=eval('('+data+')');
							if (data.success == 'true') 
							{
								if (id!="")
								{
									$('#Groupgrid').datagrid('reload');  // 重新载入当前页面数据 
								}
								else{
										$.cm({
										ClassName:"web.DHCBL.LAB.BTTestSetGroup",
										QueryName:"GetList",
										rowid: data.id   
									},function(jsonData){
										$('#Groupgrid').datagrid('insertRow',{
											index:0,
											row:jsonData.rows[0]
										})
									})
									$('#Groupgrid').datagrid('unselectAll');
								}
								$("#myWin").dialog('close'); // close a dialog
							} 
							else 
							{ 
								var errorMsg ="更新失败！"
								if (data.errorinfo)
								{
									errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
								}
								$.messager.alert('操作提示',errorMsg,"error");
							}
						} 
					});
				}else{
					return false;
				}
			})
	}else{
		$.messager.alert('操作提示',"该记录已经存在！","info");
	}			    	
	}
    //搜索方法（检验医嘱(项目组合套)）
    SearchFunLib=function()
    {
    	var CName=$("#TextCode").val();
    	$('#TestSetgrid').datagrid('load',{
            ClassName:"web.DHCBL.LAB.BTTestSet",
			QueryName:"GetList",
            desc:CName
        });
        $('#TestSetgrid').datagrid('unselectAll');
	}
	//搜索方法（合管组合套分组）
    GroupSearchFunLib=function()
    {
    	var CName=$("#GroupTextCName").val();
    	$('#Groupgrid').datagrid('load',{
            ClassName:"web.DHCBL.LAB.BTTestSetGroup",
			QueryName:"GetList",
			cname:CName
        });
        $('#Groupgrid').datagrid('unselectAll');
	}
	//搜索方法（关联）
    SearchFunLibLink=function()
    {
		var Groupgrid=$("#Groupgrid").datagrid('getSelected');
		if(Groupgrid!=null){
			var TestSetGroupDR=Groupgrid.RowID;
			$('#Linkgrid').datagrid('load',{
				ClassName:"web.DHCBL.LAB.BTTestSetGroupLinks",
				QueryName:"GetList",
				testsetgroupdr:TestSetGroupDR,
				testsetdr:""
			});
		}else{
			$('#Linkgrid').datagrid('loadData',[]);
		}
        $('#Linkgrid').datagrid('unselectAll');
	}	
	
	HISUI_Funlib_Translation('Groupgrid');
    HISUI_Funlib_Sort('Groupgrid');
}
$(init);