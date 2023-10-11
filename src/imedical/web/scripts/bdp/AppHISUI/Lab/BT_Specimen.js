/*
* @Author: 基础数据平台-谢海睿
* @Date:   2019-05-29 15:36:35
* @Last Modified by:   admin
* @Last Modified time: 2019-06-21 10:55:56
* @描述:检验- 标本类型
*/

var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.LAB.BTSpecimen&pClassQuery=GetList";
var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.LAB.BTSpecimen&pClassMethod=OpenData";
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.LAB.BTSpecimen&pClassMethod=SaveEntity&pEntityName=web.Entity.LAB.BTSpecimen";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.LAB.BTSpecimen&pClassMethod=DeleteData";
//datagrid排序：
function sort_int(a,b){
	if(a.length >b.length) return 1;
	else if (a.length <b.length) return -1;
	else if (a > b) return 1;
	else return -1;
}
var init = function(){
	var columns =[[
			{field:'RowID',title:'RowID',sortable:true,width:100,hidden:true},
			{field:'Sequence',title:'序号',sortable:true,width:50,sortable:true,sorter:sort_int},
			{field:'Code',title:'代码',sortable:true,width:100},
			{field:'IName',title:'内部名称',sortable:true,width:100},
			{field:'XName',title:'外部名称',sortable:true,width:100},
			{field:'HospitalDR',title:'医院',sortable:true,width:200},
			{field:'Active',title:'激活',sortable:true,align:'center',formatter:ReturnFlagIcon,width:100},
			{field:'EName',title:'英文缩写',sortable:true,width:100},
			{field:'HISCode',title:'HIS对照码',sortable:true,width:100},
            {field:'WCode',title:'whone码',sortable:true,width:100},
            {field:'SpecimenGroupDR',title:'标本组',sortable:true,width:100}
			]];
	
    var grid = $HUI.datagrid("#grid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.LAB.BTSpecimen",
            QueryName:"GetList"
        },
		ClassTableName:'dbo.BTSpecimen',
		SQLTableName:'dbo.BT_Specimen',
		idField:'RowID',
        columns: columns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        remoteSort:false,
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onDblClickRow:function(index,row)
        {
        	UpdateData();
        },
		onLoadSuccess:function(data)
		{
			$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
        }	
	});
	//医院下拉框
	$('#HospitalDR,#Hospital').combobox(
		{
			url:$URL+"?ClassName=web.DHCBL.LAB.BTHospital&QueryName=GetDataForCmb1&ResultSetType=array",
			valueField:'RowID',
			textField:'CName',
	    }
	);
	//标本类型下拉框
	$('#SpecimenGroupDR').combobox(
		{
			url:$URL+"?ClassName=web.DHCBL.LAB.BTSpecimenGroup&QueryName=GetDataForCmb1&ResultSetType=array",
			valueField:'RowID',
			textField:'CName',
	    }
	);
    //点击搜索按钮
	$('#btnSearch').click(function(e)
	{
    	SearchFunLib();
	});
    //搜索回车事件
	$('#TextDesc,#TextCode,#Hospital').keyup(function(event) //?
	{
		if(event.keyCode == 13) 
		{
			SearchFunLib();
		}
		if(event.keyCode == 27){
			ClearFunLib();
		}
	}); 
	//重置方法
	ClearFunLib=function(){
		$("#TextDesc").val('');//清空检索框
		$("#TextCode").val('');
		$("#Hospital").combobox("setValue","");
		$('#grid').datagrid('load',{
			ClassName: "web.DHCBL.LAB.BTSpecimen",
            QueryName:"GetList"
		});
		$('#grid').datagrid('unselectAll');
	}

    //搜索方法
    SearchFunLib=function()
    {
    	var code=$("#TextCode").val();
		var IName=$("#TextDesc").val();
		var hospital=$("#Hospital").combobox("getValue");
    	$('#grid').datagrid('load',{
            ClassName:"web.DHCBL.LAB.BTSpecimen",
			QueryName:"GetList",
			code:code,
            iname:IName,
			hospital:hospital
        });
        $('#grid').datagrid('unselectAll');
	}
		    
    //点击重置按钮
	$('#btnRefresh').click(function(e)
	{
		ClearFunLib();
	});
		
    //点击添加按钮
	$('#add_btn').click(function(e)
	{
    	AddData();
	});
		
    //点击修改按钮
	$('#update_btn').click(function(e)
	{
    	UpdateData();
	});
		
    //点击删除按钮
	$('#del_btn').click(function(e)
	{
    	DelData();
	}); 

	//删除方法
    DelData=function()
    {
		var row = $("#grid").datagrid('getSelected'); 
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
								$('#grid').datagrid('reload');  // 重新载入当前页面数据 
								$('#grid').datagrid('unselectAll');  // 清空列表选中数据 
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
	
	//新增方法
    AddData=function()
    {
		$('#HospitalDR').combobox("reload");
		$('#SpecimenGroupDR').combobox("reload");
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
		$('#HospitalDR').combobox("reload");
		$('#SpecimenGroupDR').combobox("reload");
		var record = grid.getSelected();
		if(record)
		{
			var id=record.RowID; 
			//同步基本信息
			$.cm(
				{
					ClassName:"web.DHCBL.LAB.BTSpecimen",
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
						
						}
					}
				],
				onClose:function()
				{
					
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
		var IName=$.trim($("#IName").val());
		var XName=$.trim($("#XName").val());	
		///判空	
		if (Code=="")
		{
			$.messager.alert('错误提示','代码不能为空!',"info");
			return;
		}else if(Code.length>=10){
			$.messager.alert('错误提示','代码长度不能超过10个字节!',"info");
			return;
		}
		if (IName=="")
		{
			$.messager.alert('错误提示','内部名称不能为空!',"info");
			return;
		}
		if (XName=="")
		{
			$.messager.alert('错误提示','外部名称不能为空!',"info");
			return;
		}
		var SpecimenGroupDR=$('#SpecimenGroupDR').combobox('getValue')
		if ((SpecimenGroupDR==undefined)||(SpecimenGroupDR=="undefined"))
		{
			$.messager.alert('错误提示','标本组请选择下拉列表里的值',"info");
			return;
		}
		var HospitalDR=$('#HospitalDR').combobox('getValue')
		if ((HospitalDR==undefined)||(HospitalDR=="undefined")||(HospitalDR==""))
		{
			$.messager.alert('错误提示','医院请选择下拉列表里的值',"info");
			return;
		}
		var result= tkMakeServerCall("web.DHCBL.LAB.BTSpecimen","FormValidate",id,Code,HospitalDR);		
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
									$('#grid').datagrid('reload');  // 重新载入当前页面数据 
								}
								else{
										$.cm({
										ClassName:"web.DHCBL.LAB.BTSpecimen",
										QueryName:"GetList",
										rowid: data.id   
									},function(jsonData){
										$('#grid').datagrid('insertRow',{
											index:0,
											row:jsonData.rows[0]
										})
									})
									$('#grid').datagrid('unselectAll');
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
	HISUI_Funlib_Translation('grid');
    HISUI_Funlib_Sort('grid');	
};

$(init);