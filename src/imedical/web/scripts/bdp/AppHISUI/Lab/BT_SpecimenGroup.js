/*
* @Author: 基础数据平台-谢海睿
* @Date:   2019-12-3
* @描述:标本组维护
*/
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.LAB.BTSpecimenGroup&pClassMethod=SaveEntity&pEntityName=web.Entity.LAB.BTSpecimenGroup";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.LAB.BTSpecimenGroup&pClassMethod=DeleteData";
//datagrid排序：
function sort_int(a,b){
	if(a.length >b.length) return 1;
	else if (a.length <b.length) return -1;
	else if (a > b) return 1;
	else return -1;
}
var init=function()
{
    var columns =[[
		
		{field:'RowID',title:'RowID',sortable:true,width:100,hidden:true}, 
		{field:'Sequence',title:'序号',sortable:true,width:15,sortable:true,sorter:sort_int},
		{field:'Code',title:'代码',sortable:true,width:30},
        {field:'CName',title:'名称',sortable:true,width:100},
        {field:'HospitalDR',title:'医院',sortable:true,width:150},
        {field:'Active',title:'激活',sortable:true,width:50,formatter:ReturnFlagIcon}
    ]];
    var SpecimenGroupgrid = $HUI.datagrid("#SpecimenGroupgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.LAB.BTSpecimenGroup",
            QueryName:"GetList"
        },
		ClassTableName:'dbo.BTSpecimenGroup',
		SQLTableName:'dbo.BT_SpecimenGroup',
		idField:'RowID',
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
			$('#SpecimenGroupgrid').datagrid('load',{
			ClassName: "web.DHCBL.LAB.BTSpecimenGroup",
			QueryName:"GetList"
		});
			$('#SpecimenGroupgrid').datagrid('unselectAll');
		}
	}); 
    //医院下拉框
	$('#HospitalDR,#Hospital').combobox({
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
        $("#Hospital").combobox('setValue','');
		$('#SpecimenGroupgrid').datagrid('load',{
			ClassName:"web.DHCBL.LAB.BTSpecimenGroup",
			QueryName:"GetList"
		});
		$('#SpecimenGroupgrid').datagrid('unselectAll');
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
		var row = $("#SpecimenGroupgrid").datagrid('getSelected'); 
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
								$('#SpecimenGroupgrid').datagrid('reload');  // 重新载入当前页面数据 
								$('#SpecimenGroupgrid').datagrid('unselectAll');  // 清空列表选中数据 
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

	//添加方法
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
						
						SaveFunLib("")
						
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

	//修改数据方法
    UpdateData = function()
	{
        $('#HospitalDR').combobox('reload');
        var record = SpecimenGroupgrid.getSelected();
		if(record)
		{
			var id=record.RowID; 
			//同步基本信息
			$.cm(
				{
					ClassName:"web.DHCBL.LAB.BTSpecimenGroup",
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
							
							SaveFunLib(id)
								
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

	//保存
    SaveFunLib=function(id)
    {
		var Code=$.trim($("#Code").val());
		var CName=$.trim($("#CName").val());
		///判空	
		if (Code=="")
		{
			$.messager.alert('错误提示','代码不能为空!',"info");
			return;
		}else if(Code.length>=10)
		{
			$.messager.alert('错误提示','代码长度不能超过10个字节!',"info");
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
		var result= tkMakeServerCall("web.DHCBL.LAB.BTSpecimenGroup","FormValidate",id,Code,HospitalDR);
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
								$('#SpecimenGroupgrid').datagrid('reload');  // 重新载入当前页面数据 
							}
							else{
								
									$.cm({
									ClassName:"web.DHCBL.LAB.BTSpecimenGroup",
									QueryName:"GetList",
									rowid: data.id   
								},function(jsonData){
									$('#SpecimenGroupgrid').datagrid('insertRow',{
										index:0,
										row:jsonData.rows[0]
									})
								})
								$('#SpecimenGroupgrid').datagrid('unselectAll');
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

	//搜索方法
    SearchFunLibGroup=function()
    {
        var Code=$("#TextCode").val();
        var CName=$("#TextDesc").val();
		var Hospital=$("#Hospital").combobox('getValue');
    	$('#SpecimenGroupgrid').datagrid('load',{
            ClassName:"web.DHCBL.LAB.BTSpecimenGroup",
			QueryName:"GetList",
			code:Code,
            cname:CName,
            hospital:Hospital
        });
        $('#SpecimenGroupgrid').datagrid('unselectAll');
	}	
	HISUI_Funlib_Translation('SpecimenGroupgrid');
    HISUI_Funlib_Sort('SpecimenGroupgrid');	
}
$(init);