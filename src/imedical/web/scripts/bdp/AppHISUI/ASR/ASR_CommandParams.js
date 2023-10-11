/*
* @Author: 基础数据平台-杨帆
* @Date:   2020-01-10
* @描述:语音云HIS
*/

//语音命令集场景参数保存、删除
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.ASR.ASRCommandParams&pClassMethod=SaveEntity&pEntityName=web.Entity.ASR.ASRCommandParams";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.ASR.ASRCommandParams&pClassMethod=DeleteData";
var init=function()
{
	//语音命令集场景参数表
    var hiscolumns =[[
        {field:'ASRPScenesDR',title:'场景关联',sortable:true,width:100,hidden:true},
        {field:'ASRPCustomCommandName',title:'自定义命令名',sortable:true,width:100},
        {field:'ASRPCustomCommandType',title:'自定义命令类型',sortable:true,width:100},
        {field:'ASRPCustomCommandTypeValue',title:'自定义命令类型值',sortable:true,width:100},
        {field:'ASRPRemark',title:'备注说明',sortable:true,width:100},

    ]];
    var grid = $HUI.datagrid("#grid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.ASR.ASRCommandParams",
            QueryName:"GetList",
			scenesdr:ASRPScenesDR
        },
        columns: hiscolumns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:10,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        remoteSort:false,
        idField:'ASRPID',
        singleSelect:true,
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onDblClickRow:function(rowIndex,rowData){
        	UpdateData();
        },
        onLoadSuccess:function(data){
	        $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
        	$(this).datagrid('columnMoving'); //列可以拖拽改变顺序
        }	
    });
    //搜索
    $('#btnsearch').click(function(e){
        Searchparams();
    });
    //搜索回车事件
    $('#paramsDesc').keyup(function(event){
        if(event.keyCode == 13) {
          Searchparams();
        }
    });    
    //搜索方法
    Searchparams=function()
    {
        var paramsDesc=$('#paramsDesc').val();
        $('#grid').datagrid('reload',  {
                ClassName:"web.DHCBL.ASR.ASRCommandParams",
                QueryName:"GetList",
                desc:paramsDesc,
				scenesdr:ASRPScenesDR
        });
        $('#grid').datagrid('unselectAll');        
    }    
    //重置
    $('#btnRefresh').click(function(e){
    	$('#paramsDesc').val("");
    	$('#grid').datagrid('reload',  {
            	ClassName:"web.DHCBL.ASR.ASRCommandParams",
            	QueryName:"GetList",
				scenesdr:ASRPScenesDR
    	});
    	$('#grid').datagrid('unselectAll');
    });
	//点击添加按钮(语音命令集场景参数)
    $('#add_btn').click(function(e)
    {
        AddData();
	});

	
    //点击修改按钮（语音命令集场景参数）
	$('#update_btn').click(function(e)
	{
    	UpdateData();
	});

    //点击删除按钮（语音命令集场景参数）
	$('#del_btn').click(function(e)
	{
    	DelData();
	});
	
	//添加方法（语音命令集场景参数）
    AddData=function()
    {
		$("#myWin").show();
		var myWin = $HUI.dialog("#myWin",
		{
			iconCls:'icon-w-addA',
			resizable:true,
			title:'新增',
			modal:true,
			buttonAlign : 'center',
			buttons:
			[
				{
					text:'保存',
					id:'save_btnA',
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
		$("#ASRPScenesDR").val(ASRPScenesDR);
	}
	//保存方法（语音命令集场景参数）
    SaveFunLib=function(id)
	{			
		if ($.trim($("#ASRPCustomCommandName").val())=="")
		{
			$.messager.alert('错误提示','自定义命令名不能为空!',"info");
			return;
		}
		var flag= tkMakeServerCall("web.DHCBL.ASR.ASRCommandParams","FormValidate",$.trim($("#ASRPID").val()),$.trim($("#ASRPScenesDR").val()),$.trim($("#ASRPCustomCommandName").val()));
		if (flag==1)
		{
			$.messager.alert('错误提示','该纪录已经存在!',"info");
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
									$('#grid').datagrid('reload');  // 重新载入当前页面数据
									$('#grid').datagrid('unselectAll');									
								}
								else{
									
									 $.cm({
										ClassName:"web.DHCBL.ASR.ASRCommandParams",
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
		//修改数据方法（语音命令集场景参数）
    UpdateData=function() {
		var record = $("#grid").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		var id=record.ASRPID
		$.cm({
			ClassName:"web.DHCBL.ASR.ASRCommandParams",
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
					id:'save_btnA',
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
	//删除方法（语音命令集场景参数）
    DelData=function()
    {
		var row = $("#grid").datagrid('getSelected'); 
		if (!(row))
		{
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var rowid=row.ASRPID;
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
}
$(init);