/*
* @Author: 基础数据平台-杨帆
* @Date:   2020-01-10
* @描述:语音云HIS
*/

//语音命令集场景命令指令保存、删除
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.ASR.ASRCommandSetScenesCmd&pClassMethod=SaveEntity&pEntityName=web.Entity.ASR.ASRCommandSetScenesCmd";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.ASR.ASRCommandSetScenesCmd&pClassMethod=DeleteData";
var init=function()
{
   //语音命令集场景命令指令表
   var columns =[[
   	  {field:'ASRCID',title:'RowID',width:150,sortable:true,hidden:true},
	  {field:'ASRCCommandName',title:'命令名',width:150,sortable:true},
	  {field:'ASRCExpression',title:'命令描述或表达式',width:150,sortable:true},
	  {field:'ASRCParamFormat',title:'参数格式',width:150,sortable:true},
	  {field:'ASRCParamType',title:'参数类型',width:150,sortable:true},
	  {field:'ASRCTriggerType',title:'触发类型',width:150,sortable:true},
	  {field:'ASRCTriggerTypeExpression',title:'触发类型表达式',width:150,sortable:true},
	  {field:'ASRCCommandParam',title:'命令参数',width:150,sortable:true},
	  {field:'ASRCParamDescription',title:'命令参数说明',width:150,sortable:true},
	  {field:'ASRCIsParamCommand',title:'是否有参数命令',width:150,sortable:true,formatter:ReturnFlagIcon}
    ]];
    var grid = $HUI.datagrid("#grid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.ASR.ASRCommandSetScenesCmd",
            QueryName:"GetList",
			parref:ASRCParref
        },
        columns: columns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:10,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        remoteSort:false,
        //ClassTableName:'User.DHCPHExtPart',
		//SQLTableName:'DHC_PHExtPart',
        idField:'ASRCID',
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
        Searchsetscenes();
    });
    //搜索回车事件
    $('#setscenesDesc').keyup(function(event){
        if(event.keyCode == 13) {
          Searchsetscenes();
        }
    });    
    //搜索方法
    Searchsetscenes=function()
    {
        var setscenesDesc=$('#setscenesDesc').val();
        $('#grid').datagrid('reload',  {
                ClassName:"web.DHCBL.ASR.ASRCommandSetScenesCmd",
                QueryName:"GetList",
                desc:setscenesDesc,
				parref:ASRCParref
        });
        $('#grid').datagrid('unselectAll');        
    }    
    //重置
    $('#btnRefresh').click(function(e){
    	Refreshsetscenes();
    });
	//重置事件
    $('#setscenesDesc').keyup(function(event){
        if(event.keyCode == 27) {
          Refreshsetscenes();
        }
    });    
    //重置方法
    Refreshsetscenes=function()
    {
        $('#setscenesDesc').val("");
    	$('#grid').datagrid('reload',  {
            	ClassName:"web.DHCBL.ASR.ASRCommandSetScenesCmd",
            	QueryName:"GetList",
				parref:ASRCParref
    	});
		$('#grid').datagrid('unselectAll');     
    } 
	
	//点击添加按钮(语音命令集场景命令指令)
    $('#add_btn').click(function(e)
    {
        AddData();
	});

	
    //点击修改按钮（语音命令集场景命令指令）
	$('#update_btn').click(function(e)
	{
    	UpdateData();
	});

    //点击删除按钮（语音命令集场景命令指令）
	$('#del_btn').click(function(e)
	{
    	DelData();
	});
	//添加方法（语音命令集场景命令指令）
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
			]
			
		});
		$('#form-save').form("clear");
		$("#ASRCParref").val(ASRCParref);
		$HUI.checkbox("#ASRCIsParamCommand").setValue(false);
		$("#save_btn").removeClass("l-btn l-btn-small").addClass("l-btn l-btn-small green"); 
	}
	//保存方法（语音命令集场景命令指令）
    SaveFunLib=function(id)
	{			
		if ($.trim($("#ASRCCommandName").val())=="")
		{
			$.messager.alert('错误提示','命令名不能为空!',"info");
			return;
		}
		if ($.trim($("#ASRCExpression").val())=="")
		{
			$.messager.alert('错误提示','命令描述或表达式不能为空!',"info");
			return;
		}
		var flag= tkMakeServerCall("web.DHCBL.ASR.ASRCommandSetScenesCmd","FormValidate",$.trim($("#ASRCID").val()),$.trim($("#ASRCParref").val()),$.trim($("#ASRCCommandName").val()));
		if (flag==1)
		{
			$.messager.alert('错误提示','该命令名已经存在!',"info");
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
										ClassName:"web.DHCBL.ASR.ASRCommandSetScenesCmd",
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
		//修改数据方法（语音命令集场景命令指令）
    UpdateData=function() {
		var record = $("#grid").datagrid("getSelected");
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		var id=record.ASRCID
		$.cm({
			ClassName:"web.DHCBL.ASR.ASRCommandSetScenesCmd",
			MethodName:"OpenData",
			id:id
		},function(jsonData){
			if (jsonData.ASRCIsParamCommand=="Y")
				{
					$HUI.checkbox("#ASRCIsParamCommand").setValue(true);	
				}else{
					$HUI.checkbox("#ASRCIsParamCommand").setValue(false);
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
			$("#save_btn").removeClass("l-btn l-btn-small").addClass("l-btn l-btn-small green"); 
		});
	}
	//删除方法（语音命令集场景命令指令）
    DelData=function()
    {
		var row = $("#grid").datagrid('getSelected'); 
		if (!(row))
		{
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var rowid=row.ASRCID;
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