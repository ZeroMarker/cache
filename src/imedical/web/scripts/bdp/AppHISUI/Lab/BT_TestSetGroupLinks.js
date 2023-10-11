/*
* @Author: 基础数据平台-谢海睿
* @Date:   2019-11-14
* @描述:合管组合套分组维护
*/
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.LAB.BTTestSetGroup&pClassMethod=SaveEntity&pEntityName=web.Entity.LAB.BTTestSetGroup";
var SAVE_ACTION_URL_LINK = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.LAB.BTTestSetGroupLinks&pClassMethod=SaveEntity&pEntityName=web.Entity.LAB.BTTestSetGroupLinks";//关联保存
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.LAB.BTTestSetGroup&pClassMethod=DeleteData";
var DELETE_ACTION_URL_Link = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.LAB.BTTestSetGroupLinks&pClassMethod=DeleteData";//关联删除
var init=function()
{
    ///合管组合套分组
    var columns =[[
        {field:'RowID',title:'RowID',sortable:true,width:100,hidden:true},
        {field:'Code',title:'代码',sortable:true,width:100},
        {field:'CName',title:'名称',sortable:true,width:100},
        {field:'HospitalDR',title:'医院',sortable:true,width:150},
        {field:'SeqNum',title:'序号',sortable:true,width:50},
        {field:'Active',title:'激活',sortable:true,width:50,formatter:ReturnFlagIcon}
    ]];
    var Groupgrid = $HUI.datagrid("#Groupgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.LAB.BTTestSetGroup",
            QueryName:"GetList"
        },
        columns: columns,  //列信息
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
    });
	//搜索回车事件,ESC事件()，（合管组合套分组）
	$('#TextDesc,#TextCode,#TextDesc1').keyup(function(event)
	{
		if(event.keyCode == 13) 
		{
			SearchFunLibGroup();
		}
		if(event.keyCode == 27){
			$("#TextCode").val('');
			$("#TextDesc").val('');
			$("#TextDesc1").val('');
			$('#Groupgrid').datagrid('load',{
			ClassName:"web.DHCBL.LAB.BTTestSetGroup",
			QueryName:"GetList"
		});
		$('#Groupgrid').datagrid('unselectAll');
		}
	}); 
    //医院下拉框
	$('#HospitalDR').combobox({
		url:$URL+"?ClassName=web.DHCBL.LAB.BTHospital&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'RowID',
		textField:'CName',
	});
	 //点击查询按钮(合管组合套分组)
     $('#btnSearchGroup').click(function(e)
     {
        SearchFunLibGroup();
	 });
	//点击重置按钮（合管组合套分组）
	$('#btnRefreshGroup').click(function(e)
	{
        $("#TextCode").val('');
        $("#TextDesc").val('');
        $("#TextDesc1").val('');
		$('#Groupgrid').datagrid('load',{
			ClassName:"web.DHCBL.LAB.BTTestSetGroup",
			QueryName:"GetList"
		});
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

	//添加方法（合管组合套分组）
    AddData=function()
    {
        $('#HospitalDR').combobox('reload');
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
						var Code=$.trim($("#Code").val());
						var CName=$.trim($("#CName").val());
						///判空	
						if (Code=="")
						{
							$.messager.alert('错误提示','代码不能为空!',"info");
							return;
						}
						if (CName=="")
						{
							$.messager.alert('错误提示','名称不能为空!',"info");
							return;
						}
						var HospitalDR=$('#HospitalDR').combobox('getValue')
						if ((HospitalDR==undefined)||(HospitalDR=="undefined")||(HospitalDR==""))
						{
							$.messager.alert('错误提示','医院请选择下拉列表里的值',"info");
							return;
						}
						var result= tkMakeServerCall("web.DHCBL.LAB.BTTestSetGroup","FormValidate","",Code,HospitalDR);
						if(result==0){
								$.messager.confirm("提示", "确认要保存数据吗?", function (r) {
								if (r) 
								{
									SaveFunLib("")
								}
								else 
								{
									return false;
								}								
							});
						}
						else
						{
							$.messager.alert('操作提示',"该记录已经存在！","info");
						}
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
        $('#HospitalDR').combobox('reload');
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
							var Code=$.trim($("#Code").val());
							var CName=$.trim($("#CName").val());
							///判空	
							if (Code=="")
							{
								$.messager.alert('错误提示','代码不能为空!',"info");
								return;
							}
							if (CName=="")
							{
								$.messager.alert('错误提示','名称不能为空!',"info");
								return;
							}
							var HospitalDR=$('#HospitalDR').combobox('getValue')
							if ((HospitalDR==undefined)||(HospitalDR=="undefined")||(HospitalDR==""))
							{
								$.messager.alert('错误提示','医院请选择下拉列表里的值',"info");
								return;
							}
							var result= tkMakeServerCall("web.DHCBL.LAB.BTTestSetGroup","FormValidate",id,Code,HospitalDR);
							if(result==0){
									$.messager.confirm("提示", "确认要保存数据吗?", function (r) {
									if (r) 
									{
										SaveFunLib(id)
									}
									else 
									{
										return false;
									}								
								});
							}
							else
							{
								$.messager.alert('操作提示',"该记录已经存在！","info");
							}
							
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
	}

	//搜索方法（合管组合套分组）
    SearchFunLibGroup=function()
    {
        var Code=$("#TextCode").val();
        var CName=$("#TextDesc").val();
        var Hosp=$("#TextDesc1").val();
    	$('#Groupgrid').datagrid('load',{
            ClassName:"web.DHCBL.LAB.BTTestSetGroup",
			QueryName:"GetList",
			code:Code,
            desc:CName,
            hospital:Hosp
        });
        $('#Groupgrid').datagrid('unselectAll');
	}	        
}
$(init);