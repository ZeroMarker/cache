/*
* @Author: 基础数据平台-李可凡
* @Date:   2020-9-25
* @描述:应用场景关联厂商
*/

//保存、删除
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.ASR.ASRCommandCompany&pClassMethod=SaveEntity&pEntityName=web.Entity.ASR.ASRCommandCompany";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.ASR.ASRCommandCompany&pClassMethod=DeleteData";
var init=function()
{
	//厂商下拉框		
	$('#ASRCCCompanyDR').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.ASR.ASRCompany&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'ASRCID',
		textField:'ASRCCompany'
	});
	//厂商查询下拉框
	$('#textCompanyDR').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.ASR.ASRCompany&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'ASRCID',
		textField:'ASRCCompany',
		onSelect:function(record){
			SearchFun();
		}
	});
	
   //场景关联厂商列表
   var columns =[[
   	  {field:'ASRCCID',title:'ASRCCID',width:150,sortable:true,hidden:true},
	  {field:'ASRCCScenesDR',title:'应用场景',width:150,sortable:true,hidden:true},
	  {field:'ASRCCCompanyDR',title:'厂商',width:150,sortable:true},
	  {field:'ASRCCDateFrom',title:'开始日期',width:150,sortable:true},
	  {field:'ASRCCDateTo',title:'结束日期',width:150,sortable:true,formatter:ReturnFlagIcon},
    ]];
    var grid = $HUI.datagrid("#grid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.ASR.ASRCommandCompany",
            QueryName:"GetList",
			scenesdr:ASRCParref
        },
        columns: columns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:10,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        remoteSort:false,
        idField:'ASRCCID',
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
    $('#btnSearch').click(function(e){
        SearchFun();
    });
    //搜索方法
    SearchFun=function()
    {
        $('#grid').datagrid('reload',  {
                ClassName:"web.DHCBL.ASR.ASRCommandCompany",
                QueryName:"GetList",
				scenesdr:ASRCParref,
				companydr:$("#textCompanyDR").combobox('getValue')
        });
        $('#grid').datagrid('unselectAll');        
    }    
    //重置
    $('#btnRefresh').click(function(e){
    	$("#textCompanyDR").combobox('setValue',"");
    	$('#grid').datagrid('reload',  {
            	ClassName:"web.DHCBL.ASR.ASRCommandCompany",
            	QueryName:"GetList",
				scenesdr:ASRCParref
    	});
		$('#grid').datagrid('unselectAll');
    });
	//点击添加按钮
    $('#add_btn').click(function(e)
    {
        AddData();
		var date=$.fn.datebox.defaults.formatter(new Date())
		$('#ASRCCDateFrom').datebox('setValue',date);
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
	//添加方法
    AddData=function()
    {
		$('#form-save').form("clear");
		$("#ASRCCScenesDR").val(ASRCParref);		//隐藏的文本框，项目组合套DR
		$HUI.checkbox("#IsDefault").setValue(false);
		$('#IsDefault').parent().removeClass("checked");
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
	}
	//保存方法
    SaveFunLib=function(id)
	{
		if ($("#ASRCCCompanyDR").combobox('getValue')=="")
		{
			$.messager.alert('错误提示','厂商不能为空!',"info");
			return;
		}
		var flag= tkMakeServerCall("web.DHCBL.ASR.ASRCommandCompany","FormValidate",$.trim($("#ASRCCID").val()),$.trim($("#ASRCCScenesDR").val()),$("#ASRCCCompanyDR").combobox('getValue'));
		if (flag==1)
		{
			$.messager.alert('错误提示','该厂商已经存在!',"info");
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
								/*
								if (id!="")
								{
									$('#grid').datagrid('reload');  // 重新载入当前页面数据
									$('#grid').datagrid('unselectAll');									
								}
								else{
									
									 $.cm({
										ClassName:"web.DHCBL.ASR.ASRCommandCompany",
										QueryName:"GetList",
										ASRCCID: data.id   
									},function(jsonData){
										$('#grid').datagrid('insertRow',{
											index:0,
											row:jsonData.rows[0]
										})
									})
									$('#grid').datagrid('unselectAll');
								}
								*/
								$('#grid').datagrid('reload');  // 重新载入当前页面数据
								$('#grid').datagrid('unselectAll');		
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
		//修改数据方法
    UpdateData=function() {
		var record = $("#grid").datagrid("getSelected");
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		var id=record.ASRCCID
		$.cm({
			ClassName:"web.DHCBL.ASR.ASRCommandCompany",
			MethodName:"OpenData",
			id:id
		},function(jsonData){
			if (jsonData.IsDefault=="1")
				{
					$HUI.checkbox("#IsDefault").setValue(true);	
				}else{
					$HUI.checkbox("#IsDefault").setValue(false);
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
	//删除方法
    DelData=function()
    {
		var row = $("#grid").datagrid('getSelected'); 
		if (!(row))
		{
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var ASRCCID=row.ASRCCID;
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r)
		{
			if (r)
			{
				$.ajax(
					{
						url:DELETE_ACTION_URL,  
						data:{"id":ASRCCID},  
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