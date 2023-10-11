/*
* @Author: 基础数据平台-likefan
* @Date:   2020-09-124
* @描述:语音云HIS
*/
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.ASR.ASRCompany&pClassMethod=SaveEntity&pEntityName=web.Entity.ASR.ASRCompany";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.ASR.ASRCompany&pClassMethod=DeleteData";
var ASRCParref=""
var TREE_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.ASR.ASRCommandCompany&pClassMethod=GetJsonDataForCmb";
var init=function()
{
    var hiscolumns =[[
	  {field:'ASRCID',title:'ASRCID',width:150,sortable:true,hidden:true},
	  {field:'ASRCCompany',title:'厂商',width:150,sortable:true},
	  {field:'ASRCAppVersion',title:'应用版本',width:150,sortable:true},
	  {field:'ASRCAppName',title:'应用名',width:150,sortable:true},
	  {field:'ASRCCompanyName',title:'公司名',width:150,sortable:true},
	  {field:'ASRCProtocolVersion',title:'通信模块协议版本',width:150,sortable:true},
	  {field:'ASRCCompanyCmd',title:'厂商初始化命令串',width:150,sortable:true},
	  {field:'ASRCServicePath',title:'服务路径',width:150,sortable:true},
	  {field:'ASRCStartDate',title:'开始日期',width:150,sortable:true},
	  {field:'ASRCEndDate',title:'结束日期',width:150,sortable:true}

    ]];
    var mygrid = $HUI.datagrid("#mygrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.ASR.ASRCompany",
            QueryName:"GetList"
        },
        columns: hiscolumns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        remoteSort:false,
        idField:'ASRCID',
        singleSelect:true,
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onDblClickRow:function(rowIndex,rowData){
        	UpdateData(); 
        },
		onClickRow:function(rowIndex,rowData){
			ASRCParref=$("#mygrid").datagrid("getSelected").ASRCID;
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
    //搜索回车事件
    $('#textCompany').keyup(function(event){
        if(event.keyCode == 13) {
          SearchFun();
        }
    });    
    //搜索方法
    SearchFun=function()
    {
        var textCompany=$('#textCompany').val();
        $('#mygrid').datagrid('reload',  {
                ClassName:"web.DHCBL.ASR.ASRCompany",
                QueryName:"GetList",
                desc:textCompany
        });
        $('#mygrid').datagrid('unselectAll');
    }    
    //重置
    $('#btnRefresh').click(function(e){
    	RefreshFun();
    });
	//重置ESC事件
    $('#textCompany').keyup(function(event){
        if(event.keyCode == 27) {
          RefreshFun();
        }
    });   
	//重置方法
    RefreshFun=function()
    {
        $('#textCompany').val("");
    	$('#mygrid').datagrid('reload',  {
            	ClassName:"web.DHCBL.ASR.ASRCompany",
            	QueryName:"GetList"
    	});
    	$('#mygrid').datagrid('unselectAll');
    }    
	
	//点击添加按钮
    $('#add_btn').click(function(e)
    {
        AddData();
		var date=$.fn.datebox.defaults.formatter(new Date())
		$('#ASRCStartDate').datebox('setValue',date);
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
		$("#save_btn").removeClass("l-btn l-btn-small").addClass("l-btn l-btn-small green"); 
	}
	//保存方法
    SaveFunLib=function(id)
	{
		if ($.trim($("#ASRCCompany").val())=="")
		{
			$.messager.alert('错误提示','厂商不能为空!',"info");
			return;
		}
		if ($('#ASRCStartDate').datebox('getValue')=="")
		{
			$.messager.alert('错误提示','开始日期不能为空!',"info");
			return;
		}
		var flag= tkMakeServerCall("web.DHCBL.ASR.ASRCompany","FormValidate",$.trim($("#ASRCID").val()),$.trim($("#ASRCCompany").val()));
		if (flag==1)
		{
			$.messager.alert('错误提示','该厂商下该版本号已存在!',"info");
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
										ClassName:"web.DHCBL.ASR.ASRCompany",
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
	//修改数据方法
    UpdateData=function() {
		var record = $("#mygrid").datagrid("getSelected");
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		var id=record.ASRCID
		$.cm({
			ClassName:"web.DHCBL.ASR.ASRCompany",
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
	//删除方法
    DelData=function()
    {
		var row = $("#mygrid").datagrid('getSelected'); 
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
								$('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
								$('#mygrid').datagrid('unselectAll');  // 清空列表选中数据
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
	
	/****************************厂商关联场景部分*****************************/
	//点击关联场景按钮
	$('#BtnCompanyScenes').click(function(e)
	{
    	LinkScenesFun();
	});
	
	//检索框
	$("#myChecktreeDesc").keyup(function(){ 
		var str = $("#myChecktreeDesc").val(); 
		findByRadioCheck("myChecktree",str,$("input[name='FilterCK']:checked").val())
		
	})
	//检索按钮
	$('#treesearch').click(function(e){
        var str = $("#myChecktreeDesc").val(); 
		findByRadioCheck("myChecktree",str,$("input[name='FilterCK']:checked").val())
    });
	///全部、已选、未选
	$HUI.radio("#myChecktreeWin [name='FilterCK']",{
        onChecked:function(e,value){
        	findByRadioCheck("myChecktree",$("#myChecktreeDesc").val(),$(e.target).attr("value"))
       }
    });
    
	//关联场景菜单功能
	LinkScenesFun=function ()
	{
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		ASRCParref=record.ASRCID;
		var titleCompany=record.ASRCCompany;
		$("#myChecktreeWin").show();
		var myChecktreeWin = $HUI.dialog("#myChecktreeWin",{
			iconCls:'icon-w-paper',
			resizable:true,
			title:'关联场景-'+titleCompany,
			modal:true,
			showType:'fade',
			buttons:[{
				text:'关闭',
				handler:function(){
					myChecktreeWin.close();
				}
			}]
		});
		$("#myChecktree").tree("reload");  //窗口每次打开时，数据重新加载
		$HUI.radio("#myChecktreeFilterCK0").setValue(true)  //初始设置为全部
		$("#myChecktreeDesc").val("")
	}
	
	///定义关联场景树
	var myChecktree = $HUI.tree("#myChecktree",{
		url:TREE_QUERY_ACTION_URL,
		idField: 'id',
		lines:true,  //树节点之间显示线条
		autoSizeColumn:false,
		checkbox:true,
		cascadeCheck:true,  //是否级联检查。默认true  菜单特殊，不级联操作
		animate:false,     //是否树展开折叠的动画效果
		onCheck:function(node,checked)
		{
			//保存关联场景，点击勾选框就触发后台保存，实时保存
			//alert(ASRCParref+","+node.id+","+checked);
			var rs=tkMakeServerCall("web.DHCBL.ASR.ASRCommandCompany","SaveLinkScenes",ASRCParref,node.id,checked);
			//alert(rs);
		},
		onBeforeExpand:function(node){
			//2018-11-30展开一个节点，展开下面第一级子节点，而不是只符合查询条件的数据。 
			$(this).tree('expandFirstChildNodes',node)
        },
		onBeforeLoad:function(node,param){
			param.asrcid=ASRCParref
		},
		onLoadSuccess:function(){ 
			if ($("#treeLayoutCenter").height()<$("#myChecktree").height()){ //有滚动条时，底部按钮加投影
				$("#myChecktreeWin .dialog-button").attr("style","box-shadow: 0px -1px 10px 0px rgba(0,0,0,0.2);padding-top: 10px;")
			}
		}
	});
	
}
$(init);