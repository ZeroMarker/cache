/*
* @Author: 基础数据平台-杨帆
* @Date:   2020-01-10
* @描述:语音云HIS
*/
//语音命令集保存、删除
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.ASR.ASRCommandSet&pClassMethod=SaveEntity&pEntityName=web.Entity.ASR.ASRCommandSet";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.ASR.ASRCommandSet&pClassMethod=DeleteData";
//语音命令集场景保存、删除
var SAVESETSCENES_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.ASR.ASRCommandSetScenes&pClassMethod=SaveEntity&pEntityName=web.Entity.ASR.ASRCommandSetScenes";
var DELETESETSCENES_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.ASR.ASRCommandSetScenes&pClassMethod=DeleteData";
var ASRSParref=""
var init=function()
{
	//禁用语音命令集场景按钮
	ableExtendPro=function(type){
		$('#setscenesgrid').datagrid('load',  {
                ClassName:"web.DHCBL.ASR.ASRCommandSetScenes",
                QueryName:"GetList",
				parref:""
			});
		if (type==true){
			$('#setscenessearch').linkbutton('enable');
			$('#setscenesRefresh').linkbutton('enable');
			$('#add_setscenes').linkbutton('enable');
			$('#update_setscenes').linkbutton('enable');
			$('#del_setscenes').linkbutton('enable');
			$('#Btnsetscenescmd').linkbutton('enable');
			$('#BtnCompanyScenes').linkbutton('enable');
		}else{
			$('#setscenessearch').linkbutton('disable');
			$('#setscenesRefresh').linkbutton('disable');
			$('#add_setscenes').linkbutton('disable');
			$('#update_setscenes').linkbutton('disable');
			$('#del_setscenes').linkbutton('disable');
			$('#Btnsetscenescmd').linkbutton('disable');
			$('#BtnCompanyScenes').linkbutton('disable');
		}
	}
	//语音命令集表
    var hiscolumns =[[
	  {field:'ASRID',title:'Rowid',width:150,sortable:true,hidden:true},
	  {field:'ASRAppName',title:'应用名',width:150,sortable:true},
	  {field:'ASRAppVersion',title:'应用版本',width:150,sortable:true},
	  {field:'ASRServicePath',title:'服务路径',width:150,sortable:true},
	  {field:'ASRVoiceprintScore',title:'声纹认证分值',width:150,sortable:true},
	  {field:'ASRStartDate',title:'开始日期',width:150,sortable:true},
	  {field:'ASREndDate',title:'结束日期',width:150,sortable:true}

    ]];
    var setgrid = $HUI.datagrid("#setgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.ASR.ASRCommandSet",
            QueryName:"GetList"
        },
        columns: hiscolumns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        remoteSort:false,
        idField:'ASRID',
        singleSelect:true,
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onDblClickRow:function(rowIndex,rowData){
        	UpdateData();
        },
		onClickRow:function(rowIndex,rowData){
			$('#setscenessearch').linkbutton('enable');
			$('#setscenesRefresh').linkbutton('enable');
			$('#add_setscenes').linkbutton('enable');
			$('#update_setscenes').linkbutton('enable');
			$('#del_setscenes').linkbutton('enable');
			$('#Btnsetscenescmd').linkbutton('enable');
			$('#BtnCompanyScenes').linkbutton('enable');

			var record = $("#setgrid").datagrid("getSelected");
			var parref=record.ASRID;
        	$('#setscenesgrid').datagrid('load',  {
                ClassName:"web.DHCBL.ASR.ASRCommandSetScenes",
                QueryName:"GetList",
				parref:parref
			});
        },
        onLoadSuccess:function(data){
	        $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
        	$(this).datagrid('columnMoving'); //列可以拖拽改变顺序
        }	
    });
    //搜索
    $('#setsearch').click(function(e){
        Searchset();
    });
    //搜索回车事件
    $('#setDesc').keyup(function(event){
        if(event.keyCode == 13) {
          Searchset();
        }
    });    
    //搜索方法
    Searchset=function()
    {
        var setDesc=$('#setDesc').val();
        $('#setgrid').datagrid('reload',  {
                ClassName:"web.DHCBL.ASR.ASRCommandSet",
                QueryName:"GetList",
                desc:setDesc
        });
        $('#setgrid').datagrid('unselectAll');
		ableExtendPro("")        
    }    
    //重置
    $('#setRefresh').click(function(e){
    	setRefreshFun();
    });
	//重置事件
    $('#setDesc').keyup(function(event){
        if(event.keyCode == 27) {
          setRefreshFun();
        }
    });    
    //重置方法
    setRefreshFun=function()
    {
        $('#setDesc').val("");
    	$('#setgrid').datagrid('reload',  {
            	ClassName:"web.DHCBL.ASR.ASRCommandSet",
            	QueryName:"GetList"
    	});
    	$('#setgrid').datagrid('unselectAll');
		$('#setscenesgrid').datagrid('unselectAll');
		ableExtendPro("")     
    }   
	
	//点击添加按钮(语音命令集)
    $('#add_btn').click(function(e)
    {
        AddData();
		var date=$.fn.datebox.defaults.formatter(new Date())
		$('#ASRStartDate').datebox('setValue',date);
	});

	
    //点击修改按钮（语音命令集）
	$('#update_btn').click(function(e)
	{
    	UpdateData();
	});

    //点击删除按钮（语音命令集）
	$('#del_btn').click(function(e)
	{
    	DelData();
	});
	//添加方法（语音命令集）
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
	//保存方法（语音命令集）
    SaveFunLib=function(id)
	{
		if ($.trim($("#ASRAppName").val())=="")
		{
			$.messager.alert('错误提示','应用名不能为空!',"info");
			return;
		}
		var flag= 0 //tkMakeServerCall("web.DHCBL.ASR.ASRCommandSet","FormValidate",$.trim($("#ASRID").val()),$.trim($("#ASRCompany").val()),$.trim($("#ASRAppName").val()),$.trim($("#ASRAppVersion").val()));
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
									$('#setgrid').datagrid('reload');  // 重新载入当前页面数据
									$('#setgrid').datagrid('unselectAll');									
								}
								else{
									
									 $.cm({
										ClassName:"web.DHCBL.ASR.ASRCommandSet",
										QueryName:"GetList",
										rowid: data.id   
									},function(jsonData){
										$('#setgrid').datagrid('insertRow',{
											index:0,
											row:jsonData.rows[0]
										})
									})
									$('#setgrid').datagrid('unselectAll');
								}
								$('#myWin').dialog('close'); // close a dialog
								ableExtendPro("")
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
		//修改数据方法（语音命令集）
    UpdateData=function() {
		var record = $("#setgrid").datagrid("getSelected");
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		var id=record.ASRID
		$.cm({
			ClassName:"web.DHCBL.ASR.ASRCommandSet",
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
				buttonAlign : 'center',
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
	//删除方法（语音命令集）
    DelData=function()
    {
		var row = $("#setgrid").datagrid('getSelected'); 
		if (!(row))
		{
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var rowid=row.ASRID;
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
								$('#setgrid').datagrid('reload');  // 重新载入当前页面数据 
								$('#setgrid').datagrid('unselectAll');  // 清空列表选中数据
								ableExtendPro("")								
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
	
    //语音命令集场景表
    var columns =[[
        {field:'ASRSID',title:'Rowid',width:100,hidden:true,sortable:true},
        {field:'ASRSScenes',title:'场景代码',width:100,sortable:true},
        {field:'ASRSScenesCommandName',title:'场景名称',width:100,sortable:true},
        {field:'ASRSActiveFlag',title:'有效标识',width:100,sortable:true,formatter:ReturnFlagIcon},
        {field:'ASRSRemark',title:'备注说明',width:100,sortable:true}

    ]];
    var congrid = $HUI.datagrid("#setscenesgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.ASR.ASRCommandSetScenes",
            QueryName:"GetList"
        },
        columns: columns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        remoteSort:false,
        singleSelect:true,
        idField:'ASRSID',
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onDblClickRow:function(rowIndex,rowData){
        	UpdateDatasetscenes();
        },
        onLoadSuccess:function(data){
	        $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
        	$(this).datagrid('columnMoving'); //列可以拖拽改变顺序
        }   	
    });
	//搜索
    $('#setscenessearch').click(function(e){
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
		var record = $("#setgrid").datagrid("getSelected");
		var ASRSParRef=record.ASRID;
        var setscenesDesc=$('#setscenesDesc').val();
        $('#setscenesgrid').datagrid('reload',  {
                ClassName:"web.DHCBL.ASR.ASRCommandSetScenes",
                QueryName:"GetList",
                desc:setscenesDesc,
				parref:ASRSParRef
        });
        $('#setscenesgrid').datagrid('unselectAll');        
    }    
    //重置
    $('#setscenesRefresh').click(function(e){
		scenesRefreshFun();
    });
	//重置事件
    $('#setscenesDesc').keyup(function(event){
        if(event.keyCode == 27) {
          scenesRefreshFun();
        }
    });    
    //重置方法
    scenesRefreshFun=function()
    {
        var record = $("#setgrid").datagrid("getSelected");
		var ASRSParRef=record.ASRID;
    	$('#setscenesDesc').val("");
    	$('#setscenesgrid').datagrid('reload',  {
            	ClassName:"web.DHCBL.ASR.ASRCommandSetScenes",
            	QueryName:"GetList",
				parref:ASRSParRef
    	});
    	$('#setscenesgrid').datagrid('unselectAll');  
    }   
	
	//点击添加按钮(语音命令集场景)
    $('#add_setscenes').click(function(e)
    {
        AddDatasetscenes();
	});

	
    //点击修改按钮（语音命令集场景）
	$('#update_setscenes').click(function(e)
	{
    	UpdateDatasetscenes();
	});

    //点击删除按钮（语音命令集场景）
	$('#del_setscenes').click(function(e)
	{
    	DelDatasetscenes();
	});
	//点击关联按钮（场景命令）
	$('#Btnsetscenescmd').bind('click', function(){
		var record = $("#setscenesgrid").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		var recordSet = $("#setgrid").datagrid("getSelected");
		var ASRCParref=record.ASRSID;
		var titleSetScenes=record.ASRSScenesCommandName;
		$("#winsetscenescmd").show();  
		var windowHight = document.documentElement.clientHeight;        //可获取到高度
    	var windowWidth = document.documentElement.clientWidth;
		var url="dhc.bdp.asr.asrcommandsetscenescmd.csp?ASRCParref="+ASRCParref+""
	    if ("undefined"!==typeof websys_getMWToken){
			url += "&MWToken="+websys_getMWToken()
		}
		$('#winsetscenescmd').window({
			iconCls:'icon-w-paper',
			title:"场景命令-"+titleSetScenes,
			resizable:true,
			width: windowWidth-100,    
	        height: windowHight-100,
			modal:true,
			draggable :true,
			content:'<iframe frameborder="0" src="'+url+'" width="100%" height="100%" scrolling="auto"></iframe>'
		});
	});
		
	//添加方法（语音命令集场景）
    AddDatasetscenes=function()
    {
		$("#myWinsetscenes").show();
		var myWinsetscenes = $HUI.dialog("#myWinsetscenes",
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
					id:'save_btnA',
					handler:function()
					{		
						SaveFunLibsetscenes("");		
					}
				},
			    {
					text:'关闭',
					handler:function()
					{
						myWinsetscenes.close();
						editIndex = undefined;
					}
			    }
			]
			
		});
		$('#form-savesetscenes').form("clear");
		var record = $("#setgrid").datagrid("getSelected");
		var ASRSParRef=record.ASRID;
		$("#ASRSParRef").val(ASRSParRef);	
		$HUI.checkbox("#ASRSActiveFlag").setValue(true);
		$("#save_btnA").removeClass("l-btn l-btn-small").addClass("l-btn l-btn-small green"); 
	}
	//保存方法（语音命令集场景）
    SaveFunLibsetscenes=function(id)
	{	
		if ($.trim($("#ASRSScenes").val())=="")
		{
			$.messager.alert('错误提示','场景不能为空!',"info");
			return;
		}
		if ($.trim($("#ASRSScenesCommandName").val())=="")
		{
			$.messager.alert('错误提示','场景命令名不能为空!',"info");
			return;
		}
		var flag= tkMakeServerCall("web.DHCBL.ASR.ASRCommandSetScenes","FormValidate",$.trim($("#ASRSID").val()),$.trim($("#ASRSScenes").val()),$.trim($("#ASRSParRef").val()));
		if (flag==1)
		{
			$.messager.alert('错误提示','该场景已经存在!',"info");
			return;
		}
		
		$.messager.confirm('提示', "确认要保存数据吗?", function(r){
			if (r){
				$('#form-savesetscenes').form('submit', { 
					url: SAVESETSCENES_ACTION_URL,
					success: function (data) { 
						  var data=eval('('+data+')'); 
						  if (data.success == 'true') {
								$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
								if (id!="")
								{
									$('#setscenesgrid').datagrid('reload');  // 重新载入当前页面数据
									$('#setscenesgrid').datagrid('unselectAll');									
								}
								else{
									
									 $.cm({
										ClassName:"web.DHCBL.ASR.ASRCommandSetScenes",
										QueryName:"GetList",
										rowid: data.id   
									},function(jsonData){
										$('#setscenesgrid').datagrid('insertRow',{
											index:0,
											row:jsonData.rows[0]
										})
									})
									$('#setscenesgrid').datagrid('unselectAll');
								}
								$('#myWinsetscenes').dialog('close'); // close a dialog
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
		//修改数据方法（语音命令集场景）
    UpdateDatasetscenes=function() {
		var record = $("#setscenesgrid").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		var id=record.ASRSID
		$.cm({
			ClassName:"web.DHCBL.ASR.ASRCommandSetScenes",
			MethodName:"OpenData",
			id:id
		},function(jsonData){
			if (jsonData.ASRSActiveFlag=="Y")
				{
					$HUI.checkbox("#ASRSActiveFlag").setValue(true);	
				}else{
					$HUI.checkbox("#ASRSActiveFlag").setValue(false);
				}
			$('#form-savesetscenes').form("load",jsonData);	
			
			$("#myWinsetscenes").show(); 
			var myWinsetscenes = $HUI.dialog("#myWinsetscenes",{
				iconCls:'icon-w-edit',
				resizable:true,
				title:'修改',
				modal:true,
				buttonAlign : 'center',
				buttons:[{
					text:'保存',
					id:'save_btnA',
					handler:function(){
						SaveFunLibsetscenes(id)
					}
				},{
					text:'关闭',
					handler:function(){
						myWinsetscenes.close();
					}
				}]
			});	
			$("#save_btnA").removeClass("l-btn l-btn-small").addClass("l-btn l-btn-small green"); 
		});
	}
	//删除方法（语音命令集场景）
    DelDatasetscenes=function()
    {
		var row = $("#setscenesgrid").datagrid('getSelected'); 
		if (!(row))
		{
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var rowid=row.ASRSID;
		var flag= tkMakeServerCall("web.DHCBL.ASR.ASRCommandSetScenes","DelValidate",rowid);
		if (flag==1)
		{
			$.messager.alert('错误提示','该场景下存在场景命令数据!',"info");
			return;
		}
		//var rowid=row.ASRSID;
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r)
		{
			if (r)
			{
				$.ajax(
					{
						url:DELETESETSCENES_ACTION_URL,  
						data:{"id":rowid},  
						type:"POST",     
						success: function(data)
						{
							var data=eval('('+data+')'); 
							if (data.success == 'true') 
							{
								$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
								$('#setscenesgrid').datagrid('reload');  // 重新载入当前页面数据 
								$('#setscenesgrid').datagrid('unselectAll');  // 清空列表选中数据 
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
	
	/****************************场景关联厂商部分**2020-11-04***************************/
	
	var TREE_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.ASR.ASRCommandCompany&pClassMethod=GetJsonDataForTree";
	
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
		var record = $("#setscenesgrid").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		ASRSParref=record.ASRSID;
		var titleCompany=record.ASRSScenesCommandName;
		$("#myChecktreeWin").show();
		var myChecktreeWin = $HUI.dialog("#myChecktreeWin",{
			iconCls:'icon-w-paper',
			resizable:true,
			title:'关联厂商-'+titleCompany,
			modal:true,
			showType:'fade',
			buttonAlign : 'center',
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
			//alert(node.id+","+ASRSParref+","+checked);
			var rs=tkMakeServerCall("web.DHCBL.ASR.ASRCommandCompany","SaveLinkScenes",node.id,ASRSParref,checked);
			//alert(rs);
		},
		onBeforeExpand:function(node){
			//2018-11-30展开一个节点，展开下面第一级子节点，而不是只符合查询条件的数据。 
			$(this).tree('expandFirstChildNodes',node)
        },
		onBeforeLoad:function(node,param){
			param.asrsid=ASRSParref
		},
		onLoadSuccess:function(){
			if ($("#treeLayoutCenter").height()<$("#myChecktree").height()){ //有滚动条时，底部按钮加投影
				$("#myChecktreeWin .dialog-button").attr("style","box-shadow: 0px -1px 10px 0px rgba(0,0,0,0.2);padding-top: 10px;")
			}
		}
	});
	/****************************场景关联厂商部分完*****************************/
	
	ableExtendPro("")	
}
$(init);