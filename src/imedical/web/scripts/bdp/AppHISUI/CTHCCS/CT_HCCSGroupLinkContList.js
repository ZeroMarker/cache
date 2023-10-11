/*
* @Author: 基础数据平台-杨帆
* @Editor:丁亚男
* @Date:   2020-12-25
* @描述:群组通讯录维护
*/
//群组保存、删除
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTHCCSGroup&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTHCCSGroup";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTHCCSGroup&pClassMethod=DeleteData";

var init=function()
{
	//多院区下拉框
	var hospComp = GenHospComp("CT_HCCSGroup");
	hospComp.jdata.options.onSelect = function(e){
		var HospID=$HUI.combogrid('#_HospList').getValue();
		groupRefreshFun();//群组重置
	}
	//禁用、启用右侧按钮
	ableConstListButton=function(type){
		if (type==true){
			/* $('#contlistSearch').linkbutton('enable');
			$('#contlistRefresh').linkbutton('enable'); */
			$("#contlistmybar [name='FilterCK']").radio('enable');
			$('#saveButton').linkbutton('enable');
		}else{
			/* $('#contlistSearch').linkbutton('disable');   //禁用个人通讯录查询按钮
			$('#contlistRefresh').linkbutton('disable');   //禁用个人通讯录重置按钮 */
			$("#contlistmybar [name='FilterCK']").radio('disable');
			$('#saveButton').linkbutton('disable');   //禁用个人通讯录保存按钮
		}
	}
	
	//群组
    var groupcolumns =[[
	  {field:'GROUPRowId',title:'GROUPRowId',width:150,sortable:true,hidden:true},
	  {field:'GROUPCode',title:'群组代码',width:120,sortable:true},
	  {field:'GROUPDesc',title:'群组名称',width:200,sortable:true},
	  {field:'GROUPDateFrom',title:'开始日期',width:150,sortable:true},
	  {field:'GROUPDateTo',title:'结束日期',width:150,sortable:true},

    ]];
    var groupgrid = $HUI.datagrid("#groupgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.CT.CTHCCSGroup",
            QueryName:"GetList",
			'hospid':hospComp.getValue()    ///多院区医院
        },
        columns: groupcolumns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        remoteSort:false,
        idField:'GROUPRowId',
        singleSelect:true,
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onDblClickRow:function(rowIndex,rowData){
        	UpdateData();
        },
		onClickRow:function(rowIndex,rowData){
			
			ableConstListButton(true) //启用右侧按钮
			//获取 全选、已选、未选的选中label
			CheckFlag= $("#contlistmybar [name='FilterCK']").attr("label");
			if ((CheckFlag=="")||(CheckFlag=="全部"))
			{
				$HUI.radio("#CheckALL").setValue(true);
			}
			contlistRefresh(); //右侧重置
        },
        onLoadSuccess:function(data){
	        $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
        	$(this).datagrid('columnMoving'); //列可以拖拽改变顺序
        }	
    });
    //搜索
    $('#groupsearch').click(function(e){
        groupSearch();
    });
    //搜索回车事件
    $('#groupDesc').keyup(function(event){
        if(event.keyCode == 13) {
			groupSearch();
        }
    });    
    //搜索方法
    groupSearch=function()
    {
        var groupDesc=$('#groupDesc').val();
		var HospID=hospComp.getValue();
        $('#groupgrid').datagrid('reload',  {
                ClassName:"web.DHCBL.CT.CTHCCSGroup",
                QueryName:"GetList",
                desc:groupDesc,
				'hospid':HospID
        });
        $('#groupgrid').datagrid('unselectAll');
		ableConstListButton(false)  //禁用右侧按钮
		contlistRefresh(); //右侧重置
    }    
    //重置
    $('#groupRefresh').click(function(e){
    	groupRefreshFun();
    });
	//重置事件
    $('#groupDesc').keyup(function(event){
        if(event.keyCode == 27) {
          groupRefreshFun();
        }
    });    
    //重置方法
    groupRefreshFun=function()
    {
        $('#groupDesc').val("");
		var HospID=hospComp.getValue();
    	$('#groupgrid').datagrid('reload',  {
            	ClassName:"web.DHCBL.CT.CTHCCSGroup",
            	QueryName:"GetList",
				'hospid':HospID
    	});
    	$('#groupgrid').datagrid('unselectAll');
		$('#contlistgrid').datagrid('unselectAll');
		ableConstListButton(false)  //禁用右侧按钮
		contlistRefresh(); //右侧重置
    }   
	
	//点击添加按钮(群组)
    $('#add_btn').click(function(e)
    {
        AddData();
	});

    //点击修改按钮（群组）
	$('#update_btn').click(function(e)
	{
    	UpdateData();
	});

    //点击删除按钮（群组）
	$('#del_btn').click(function(e)
	{
    	DelData();
	});
	//添加方法（群组）
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
		$("#save_btn").removeClass("l-btn l-btn-small").addClass("l-btn l-btn-small green");
		$('#form-save').form("clear");
		var date=$.fn.datebox.defaults.formatter(new Date())
		$('#GROUPDateFrom').datebox('setValue',date);
	}
	//保存方法（群组）
    SaveFunLib=function(id)
	{
		if ($.trim($("#GROUPCode").val())=="")
		{
			$.messager.alert('错误提示','群组代码不能为空!',"info");
			return;
		}
		if ($.trim($("#GROUPDesc").val())=="")
		{
			$.messager.alert('错误提示','群组名称不能为空!',"info");
			return;
		}
		var flag= tkMakeServerCall("web.DHCBL.CT.CTHCCSGroup","FormValidate",$.trim($("#GROUPRowId").val()),$.trim($("#GROUPCode").val()),$.trim($("#GROUPDesc").val()),hospComp.getValue());
		if (flag==1)
		{
			$.messager.alert('错误提示','该群组已存在!',"info");
			return;
		}
		$.messager.confirm('提示', "确认要保存数据吗?", function(r){
			if (r){
				$('#form-save').form('submit', { 
					url: SAVE_ACTION_URL,
					onSubmit: function(param){
							param.LinkHospId = hospComp.getValue()
						},
					success: function (data) { 
						  var data=eval('('+data+')'); 
						  if (data.success == 'true') {
								$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
								if (id!="")
								{
									$('#groupgrid').datagrid('reload');  // 重新载入当前页面数据
									$('#groupgrid').datagrid('unselectAll');									
								}
								else{
									
									 $.cm({
										ClassName:"web.DHCBL.CT.CTHCCSGroup",
										QueryName:"GetList",
										rowid: data.id   
									},function(jsonData){
										$('#groupgrid').datagrid('insertRow',{
											index:0,
											row:jsonData.rows[0]
										})
									})
									$('#groupgrid').datagrid('unselectAll');
								}
								$('#myWin').dialog('close'); // close a dialog
								ableConstListButton("")   //禁用按钮
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
		//修改数据方法（群组）
    UpdateData=function() {
		var record = $("#groupgrid").datagrid("getSelected");
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		var id=record.GROUPRowId
		$.cm({
			ClassName:"web.DHCBL.CT.CTHCCSGroup",
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
	//删除方法（群组）
    DelData=function()
    {
		var row = $("#groupgrid").datagrid('getSelected'); 
		if (!(row))
		{
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var rowid=row.GROUPRowId;
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
								$('#groupgrid').datagrid('reload');  // 重新载入当前页面数据 
								$('#groupgrid').datagrid('unselectAll');  // 清空列表选中数据
								ableConstListButton("")
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
	/********个人通讯录开始 *********************************************************************************************************/
	var CheckFlag="全部"
	var Saveflag=1  //保存群组标志 搜索、重置、切换群组不保存，其他情况保存 
	//个人通讯录部分
    var contlistcolumns =[[
		{field:'checked',title:'sel',checkbox:true},
		{field:'CGCLRowId',title:'关联ID',width:100,hidden:true},
        {field:'HCCSCLRowId',title:'用户ID',width:100,hidden:true,sortable:true},
        {field:'HCCSCLUserCode',title:'用户代码',width:100,sortable:true},
        {field:'HCCSCLUserDesc',title:'用户姓名',width:100,sortable:true},
        {field:'HCCSCLLoc',title:'科室',width:150,sortable:true},
        {field:'HCCSCLVOIPNumber',title:'VOIP号码',width:100,sortable:true},

    ]];
    var contlistgrid = $HUI.datagrid("#contlistgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.CT.CTHCCSContactList",
            QueryName:"GetDataForCmb1",
			'hospid':hospComp.getValue(),    ///多院区医院
			CheckFlag:CheckFlag
        },
        columns: contlistcolumns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        remoteSort:false,     //定义从服务器对数据进行排序
        singleSelect:false,
        idField:'HCCSCLRowId',
        rownumbers:true,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true,
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		onCheck:function(index, row){  //选中数据时，checked的内容没有变化
			$('#contlistgrid').datagrid('updateRow',{
				index: index,
				row: {
					checked:true
				}
			});
			
		},
		onUncheck:function(index, row){ //取消选中数据时，checked的内容没有变化
			$('#contlistgrid').datagrid('updateRow',{
				index: index,
				row: {
					checked:false
				}
			});
			
		},
		onCheckAll:function(rows){  //选中数据时，checked的内容没有变化
			$.each(rows, function(index, item){
				$('#contlistgrid').datagrid('updateRow',{
					index: index,
					row: {
						checked:true
					}
				});
			});	
			
		},
		onUncheckAll:function(rows){  //选中数据时，checked的内容没有变化
			$.each(rows, function(index, item){
				$('#contlistgrid').datagrid('updateRow',{
					index: index,
					row: {
						checked:false
					}
				});
			});	
		},
		onBeforeLoad:function()
		{
			
			var Allrows=$('#contlistgrid').datagrid('getRows');
			var ChangeFlag=0  //判断翻页时，数据是否有变化
			for(var i=0; i<Allrows.length; i++) {   //循环获取变化的数据
				if (((Allrows[i].checked==true) && (Allrows[i].CGCLRowId==""))||((Allrows[i].checked!==true) && (Allrows[i].CGCLRowId!=="")))
				{
					ChangeFlag=1;	
					break
				}	
			}
			if ((ChangeFlag==1)&&(Saveflag==1)) //有变化并且是翻页 保存数据
			{
				SavePrePageData();
			}
		}, 
        onLoadSuccess:function(data){
			var CheckALLFlag=0 //加载数据是否全部选中标志
			if (data) {
				 CheckALLFlag=1
                $.each(data.rows, function (index, item) {
                    if (item.checked == false) {
						CheckALLFlag=0;
                    }
                });
			}
			
			if (CheckALLFlag==1) //加载数据全部选中标志
			{
				$("#contlistgrid").datagrid('checkAll')
			}
			else
			{
				$("#contlistgrid").parent().find("div.datagrid-header-check").children("input[type='checkbox']").eq(0).attr("checked", false);
			}
			
	        $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
        	$(this).datagrid('columnMoving'); //列可以拖拽改变顺序
		}		
	});
	
	//搜索
    $('#contlistSearch').click(function(e){
        contlistSearch();
    });
    //搜索回车事件
    $('#contlistDesc').keyup(function(event){
        if(event.keyCode == 13) {
			contlistSearch();
        }
	}); 
    //搜索回车事件
    $('#contlistLocDesc').keyup(function(event){
        if(event.keyCode == 13) {
			contlistSearch();
        }
	}); 
	///全部、已选、未选
	$HUI.radio("#contlistmybar [name='FilterCK']",{
        onChecked:function(e,value){
			CheckFlag=$(e.target).attr("label")
			contlistSearch();//检索
       }
    });
    //搜索方法
    contlistSearch=function()
    {
		var record = $("#groupgrid").datagrid("getSelected");
		var CGCLParRef="";
		if (record)
		{
			 CGCLParRef=record.GROUPRowId;
		}
		var contlistDesc=$('#contlistDesc').val();
		var contlistLocDesc=$('#contlistLocDesc').val();
		var HospID=hospComp.getValue();
		Saveflag=0  //保存群组标志 搜索、重置、切换群组不保存，其他情况保存
        $('#contlistgrid').datagrid('reload',  {
                ClassName:"web.DHCBL.CT.CTHCCSContactList",
                QueryName:"GetDataForCmb1",
				'desc':contlistDesc,
				'loc':contlistLocDesc,
				'hospid':HospID,
				'parref':CGCLParRef,
				CheckFlag:CheckFlag
        });
		$('#contlistgrid').datagrid('unselectAll');
		Saveflag=1  //保存群组标志 搜索、重置、切换群组不保存，其他情况保存    
    }    
    //重置
    $('#contlistRefresh').click(function(e){
		contlistRefresh();
    });
	//重置事件
    $('#contlistDesc').keyup(function(event){
        if(event.keyCode == 27) {
			contlistRefresh();
        }
    });    
    //重置方法
    contlistRefresh=function()
    {
        var record = $("#groupgrid").datagrid("getSelected");
		var CGCLParRef="";
		if (record)
		{
			 CGCLParRef=record.GROUPRowId;
		}
		var HospID=hospComp.getValue();
		$('#contlistDesc').val("");
		$('#contlistLocDesc').val("");
		Saveflag=0  //保存群组标志 搜索、重置、切换群组不保存，其他情况保存
    	$('#contlistgrid').datagrid('reload',  {
            	ClassName:"web.DHCBL.CT.CTHCCSContactList",
            	QueryName:"GetDataForCmb1",
				'hospid':HospID,
				'parref':CGCLParRef,
				CheckFlag:CheckFlag
    	});
		$('#contlistgrid').datagrid('unselectAll');  
		Saveflag=1  //保存群组标志 搜索、重置、切换群组不保存，其他情况保存 
    }   
	
	//点击保存按钮(群组人员)
    $('#saveButton').click(function(e)
    {
        SaveData();
	});
	
	//保存方法（群组人员）
	SaveData=function() {	
		var record = $("#groupgrid").datagrid("getSelected");
		if(!record)
		{
			$.messager.alert('提示',"未选中要保存的数据!","info");						
			return false;
		}
		var GROUPRowId=record.GROUPRowId;
		var Allrows=$('#contlistgrid').datagrid('getRows');
		$.messager.confirm('提示', "确认要保存数据吗?", function(r){
			if (r){
				var ChangeIDstr="";
				for(var i=0; i<Allrows.length; i++) {   //循环获取变化的数据

					if (((Allrows[i].checked==true) && (Allrows[i].CGCLRowId==""))||((Allrows[i].checked!==true) && (Allrows[i].CGCLRowId!=="")))
					{
						if(ChangeIDstr!=="")
						{
							ChangeIDstr=ChangeIDstr+"^"
						}
						ChangeIDstr=ChangeIDstr+Allrows[i].HCCSCLRowId
					}
					
				}
				
				if(ChangeIDstr!=="")
				{
					var rs=tkMakeServerCall("web.DHCBL.CT.CTHCCSGroupLinkContList","SaveGroupLinkList",GROUPRowId,ChangeIDstr);	
					rs=eval('(' + rs + ')');
					if (rs.success== 'true') 
					{
						$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
					}
					else
					{
						$.messager.alert('操作提示',"保存失败！","error");
					}
					Saveflag=0
					$('#contlistgrid').datagrid('reload');  // 重新载入当前页面数据	
					Saveflag=1
				}
				else
				{
					$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
				}
									  
				
			}
		})
	}
	
	//翻页时保存上页数据的方法
	SavePrePageData=function() {	
		var record = $("#groupgrid").datagrid("getSelected");
		if(!record)
		{
			//$.messager.alert('提示',"未选中要保存的数据!","info");						
			return false;
		}
		var GROUPRowId=record.GROUPRowId;
		var Allrows=$('#contlistgrid').datagrid('getRows');
		var ChangeIDstr="";
		for(var i=0; i<Allrows.length; i++) {   //循环获取变化的数据

			if (((Allrows[i].checked==true) && (Allrows[i].CGCLRowId==""))||((Allrows[i].checked!==true) && (Allrows[i].CGCLRowId!=="")))
			{
				if(ChangeIDstr!=="")
				{
					ChangeIDstr=ChangeIDstr+"^"
				}
				ChangeIDstr=ChangeIDstr+Allrows[i].HCCSCLRowId
			}
			
		}
		var rs=tkMakeServerCall("web.DHCBL.CT.CTHCCSGroupLinkContList","SaveGroupLinkList",GROUPRowId,ChangeIDstr);	
		rs=eval('(' + rs + ')');
		if (rs.success== 'true') 
		{
			$.messager.popover({msg: '上页数据保存成功！',type:'success',timeout: 1000});
		}
		else
		{
			$.messager.alert('操作提示',"上页数据保存失败！","error");
		}			
			
	}
	
	

	
	/****************************群组关联个人通讯录  树 部分**2020-12-24***************************/
	
	/*var TREE_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTHCCSGroupLinkContList&pClassMethod=GetJsonDataForTree";

	//查询工具栏用户下拉框
	$('#myChecktreeUserDesc').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.CTHCCSContactList&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'SSUSRInitials',
		textField:'SSUSRName'
	});
	
	//查询工具栏科室下拉框
	$('#myChecktreeLocDesc').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.CTLoc&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'CTLOCCode',
		textField:'CTLOCDesc'
	});
	
	//检索框
	$("#myChecktreeUserDesc").keyup(function(){ 
		var str = $("#myChecktreeUserDesc").val(); 
		findByRadioCheck("myChecktree",str,$("input[name='FilterCK']:checked").val())
		
	})
	///全部、已选、未选
	$HUI.radio("#myChecktreeWin [name='FilterCK']",{
        onChecked:function(e,value){
        	findByRadioCheck("myChecktree",$("#myChecktreeUserDesc").val(),$(e.target).attr("value"))
       }
    });
    
	//
	LinkScenesFun=function ()
	{
		var record = $("#groupgrid").datagrid("getSelected"); 
		CGCLParRef=record.GROUPRowId;
		//var titleCompany=record.ASRSScenesCommandName;
		$("#myChecktree").tree("reload");  //窗口每次打开时，数据重新加载
		$HUI.radio("#myChecktreeFilterCK0").setValue(true)  //初始设置为全部
		$("#myChecktreeUserDesc").val("")
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
			//alert(node.id+","+CGCLParRef+","+checked);
			var rs=tkMakeServerCall("web.DHCBL.CT.CTHCCSGroupLinkContList","SaveLinkScenes",node.id,CGCLParRef,checked);
			//alert(rs);
		},
		onBeforeExpand:function(node){
			//2018-11-30展开一个节点，展开下面第一级子节点，而不是只符合查询条件的数据。 
			$(this).tree('expandFirstChildNodes',node)
        },
		onBeforeLoad:function(node,param){
			param.groupid=CGCLParRef
		}
	});*/
	/****************************群组关联个人通讯录部分完*****************************/
	ableConstListButton("")   //禁用右侧个人通讯录按钮
}
$(init);