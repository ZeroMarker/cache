/// 名称: 合报告分组关联
/// 描述: 包含增删改查、合报告分组及合报告分组关联
/// 编写者: 基础数据平台组-钟荣枫
/// 编写日期: 2020-4-17

//合报告分组保存
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.LAB.BTTestSetOGTTGroup&pClassMethod=SaveEntity&pEntityName=web.Entity.LAB.BTTestSetOGTTGroup";
//关联保存
var SAVE_ACTION_URL_LINK = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.LAB.BTTestSetOGTTGroupLinks&pClassMethod=SaveEntity&pEntityName=web.Entity.LAB.BTTestSetOGTTGroupLinks";//关联保存
//合报告分组删除
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.LAB.BTTestSetOGTTGroup&pClassMethod=DeleteData";
//关联删除
var DELETE_ACTION_URL_Link = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.LAB.BTTestSetOGTTGroupLinks&pClassMethod=DeleteData";

var init=function()
{
	//datagrid排序：
	function sort_int(a,b){
		if(a.length >b.length) return 1;
		else if (a.length <b.length) return -1;
		else if (a > b) return 1;
		else return -1;
	}
    ///合报告分组
    var columns =[[
		{field:'RowID',title:'RowID',sortable:true,width:100,hidden:true},
		{field:'Sequence',title:'序号',sortable:true,width:50, sortable:true},	//,sorter:sort_int
        {field:'Code',title:'代码',sortable:true,width:100},
        {field:'CName',title:'名称',sortable:true,width:100},
        {field:'MainTestSetDR',title:'主组合套ID',sortable:true,width:150,hidden:true},
        {field:'MainTestSetDesc',title:'主组合套',sortable:true,width:150,hidden:true},
        {field:'HospitalDR',title:'医院',sortable:true,width:350,hidden:true},
        {field:'Active',title:'激活',sortable:true,width:50,formatter:ReturnFlagIcon}
    ]];
    var Groupgrid = $HUI.datagrid("#Groupgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.LAB.BTTestSetOGTTGroup",
            QueryName:"GetList"
        },
        columns: columns,  //列信息
		SQLTableName:'dbo.BT_TestSetOGTTGroup',
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
    
    ShowUserHabit('Groupgrid');

    ///检验医嘱(项目组合套)
    var TestSetcolumns =[[
	    {field:'RowID',title:'RowId',width:100,sortable:true,hidden:true},
	    {field:'Code',title:'代码',width:100,sortable:true},
		{field:'CName',title:'名称',width:100,sortable:true},
		{field:'Connecte',title:'关联',width:50,align:'center',
		//封装？
			formatter:function(val,row,index){  
                var btn =  '<img class="contrast mytooltip" title="关联" onclick="ConMethod('+index+')" src="../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png" style="border:0px;cursor:pointer">'   
				
				return btn;  
			}  
      }  
    ]];
    var TestSetgrid= $HUI.datagrid("#TestSetgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.LAB.BTTestSet",
            QueryName:"GetDataForCmb1",
            linkflag:"Y"
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
		onDblClickRow:function(index, row){
			ConMethod(index)
		}
	});
	ShowUserHabit('TestSetgrid');

	//关联
    var Linkcolumns =[[
        {field:'RowID',title:'RowID',width:100,hidden:true,sortable:true},
       // {field:'Sequence',title:'序号',width:50,sortable:true},
        {field:'TestSetOGTTGroupDR',title:'组合套组ID',width:100,sortable:true,hidden:true},
        {field:'TestSetOGTTGroupDesc',title:'组合套组',width:100,sortable:true,hidden:true},
		{field:'MainTestSetDR',title:'主组合套ID',width:100,sortable:true,hidden:true},
		{field:'MainTestSetDesc',title:'主组合套',width:100,sortable:true},
		{field:'SubTestSetDR',title:'子组合套ID',width:100,sortable:true,hidden:true},
		{field:'SubTestSetDesc',title:'子组合套',width:100,sortable:true},
		{field:'MainFlag',title:'是否主组合套',width:100,align:'center',
			formatter:function(value,row,index)
			{
				//var btn =  '<img class="contrast" onclick="ChangeMainestSet('+index+')" src="../scripts_lib/hisui-0.1.0/dist/css/icons/OK.png" style="border:0px;cursor:pointer">' 
				if (row.MainTestSetDR==row.SubTestSetDR)	//是主组合套的显示图标
				{
					return "<font color='#21ba45'>是</font>"
					//return btn;
				}
				else
				{
					return "<font color='#f16e57'>否</font>"
				}

			}
        },
		{field:'ChangeFlag',title:'改为主组合套',width:100,align:'center',
			formatter:function(value,row,index)
			{
				var btn =  '<img class="contrast" onclick="ChangeMainestSet('+index+')" src="../scripts_lib/hisui-0.1.0/dist/css/icons/write_order.png" style="border:0px;cursor:pointer">' 
				if (row.MainTestSetDR!=row.SubTestSetDR)	//不是主组合套的显示图标
				{
					return btn;
				}
			}
        },
		{field:'Delete',title:'删除',width:50,align:'center',
			formatter:function(value,row,index){  
                var btn =  '<img class="contrast" onclick="DelDataLink('+index+')" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png" style="border:0px;cursor:pointer">' 
				return btn;  
			}  
        }
     ]];

    var Linkgrid = $HUI.datagrid("#Linkgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.LAB.BTTestSetOGTTGroupLinks",
            QueryName:"GetList"
        },
        columns:Linkcolumns,  //列信息
        ClassTableName:'dbo.BTTestSetOGTTGroupLinks',
        SQLTableName:'dbo.BT_TestSetOGTTGroupLinks',
        pagination: true,   //pagination    boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
        singleSelect:true,
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        remoteSort:false,  //定义是否从服务器排序数据。true
        
		onBeforeLoad: function (param) {
                var firstLoad = $(this).attr("firstLoad");
                if (firstLoad == "false" || typeof (firstLoad) == "undefined")
                {
                    $(this).attr("firstLoad","true");
                    
                    return false;
                }
                return true;
            }
      	
	});
	ShowUserHabit('Linkgrid');

    
    //医院下拉框
	$('#HospitalDR').combobox({
		url:$URL+"?ClassName=web.DHCBL.LAB.BTHospital&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'RowID',
		textField:'CName'
	});
	
	//搜索回车事件，ESC事件(检验医嘱)
	$('#TextTestSet').keyup(function(event)
	{
		if(event.keyCode == 13) 
		{
			SearchFunLib();
		}
		if(event.keyCode == 27){
			$("#TextTestSet").val('');
			$('#TestSetgrid').datagrid('load',{
				'ClassName': "web.DHCBL.LAB.BTTestSet",
	            'QueryName':"GetDataForCmb1",
	            'linkflag':"Y"
			});
		$('#TestSetgrid').datagrid('unselectAll');
		}
	});
     //点击查询按钮(检验医嘱查询)
     $('#btnSearch').click(function(e)
     {
        SearchFunLib();
	 });
	 
    //点击重置按钮（检验医嘱(项目组合套)）
	$('#btnRefresh').click(function(e)
	{
		$("#TextTestSet").val('');
		$('#TestSetgrid').datagrid('load',{
			'ClassName': "web.DHCBL.LAB.BTTestSet",
            'QueryName':"GetDataForCmb1",
            'linkflag':"Y"
		});
		$('#TestSetgrid').datagrid('unselectAll');
	});
	 //搜索方法（检验医嘱(项目组合套)）
    SearchFunLib=function()
    {
    	var CName=$("#TextTestSet").val();
    	$('#TestSetgrid').datagrid('load',{
            'ClassName': "web.DHCBL.LAB.BTTestSet",
            'QueryName':"GetDataForCmb1",
            'linkflag':"Y",
            'desc':CName
        });
        $('#TestSetgrid').datagrid('unselectAll');
	}
		

	/*************************合报告分组操作*******开始*****************************/
	//搜索框事件
	$('#GroupTextCName').keyup(function(event)
	{
		if(event.keyCode == 13) 
		{ 
			GroupSearchFunLib();
		}
		if(event.keyCode == 27){
			$("#GroupTextCName").val('');
			$('#Groupgrid').datagrid('load',{
				'ClassName': "web.DHCBL.LAB.BTTestSetOGTTGroup",
				'QueryName':"GetList"
			});
		$('#Linkgrid').datagrid('loadData',[]);
		$('#Groupgrid').datagrid('unselectAll');
		}
	}); 
	//点击查询按钮(合报告分组)
     $('#btnSearchGroup').click(function(e)
     {
        GroupSearchFunLib();
	 });
	//搜索方法（合报告分组）
    GroupSearchFunLib=function()
    {
    	var CName=$("#GroupTextCName").val();
    	$('#Groupgrid').datagrid('load',{
            'ClassName':"web.DHCBL.LAB.BTTestSetOGTTGroup",
			'QueryName':"GetList",
			'cname':CName
        });
        $('#Groupgrid').datagrid('unselectAll');
	}
	//点击重置按钮（合报告分组）
	$('#GroupbtnRefresh').click(function(e)
	{
		$("#GroupTextCName").val('');
		$('#Groupgrid').datagrid('load',{
			'ClassName':"web.DHCBL.LAB.BTTestSetOGTTGroup",
			'QueryName':"GetList"
		});
		$('#Linkgrid').datagrid('loadData',[]);
		$('#Groupgrid').datagrid('unselectAll');
	});
    //点击添加按钮(合报告分组)
    $('#add_btn').click(function(e)
    {
        AddData();
	});

	
    //点击修改按钮（合报告分组）
	$('#update_btn').click(function(e)
	{
    	UpdateData();
	});

    //点击删除按钮（合报告分组）
	$('#del_btn').click(function(e)
	{

	    DelData();
	});
	//删除方法（合报告分组）
    DelData=function()
    {
		var row = $("#Groupgrid").datagrid('getSelected'); 
		if (!(row))
		{
			$.messager.alert('提示','请先选择一条记录!',"info");
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
				SearchFunLibLink()
			}
		});    	
	} 
	//添加方法（合报告分组）
    AddData=function()
    {
		$("#myWin").show();
		$('#HospitalDR').combobox('reload');
		
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
					}
			    }
			],
			
		});
		$('#form-save').form("clear");
		$HUI.checkbox("#Active").setValue(true);
	}
	//修改数据方法（合报告分组）
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
					'ClassName':"web.DHCBL.LAB.BTTestSetOGTTGroup",
					'MethodName':"OpenData",
					'id':id,
					'RetFlag':"JSON"
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
						}
					}
				]
			});	
		}
		else
		{
			$.messager.alert('提示','请先选择一条记录!',"info");
		}
	}
	//保存（合报告分组）
    SaveFunLib=function(id)
    {
		var Code=$.trim($("#Code").val());
		var CName=$.trim($("#CName").val());
		///判空	
		if (Code=="")
		{
			$.messager.alert('提示','代码不能为空!',"info");
			return;
		}
		if (CName=="")
		{
			$.messager.alert('提示','描述不能为空!',"info");
			return;
		}
		var HospitalDR=$('#HospitalDR').combobox('getValue')
		if ((HospitalDR==undefined)||(HospitalDR=="undefined")||(HospitalDR==""))
		{
			$.messager.alert('提示','医院请选择下拉列表里的值',"info");
			return;
		}

		var result= tkMakeServerCall("web.DHCBL.LAB.BTTestSetOGTTGroup","FormValidate",id,Code,HospitalDR);
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
								else
								{
									$.cm({
										'ClassName':"web.DHCBL.LAB.BTTestSetOGTTGroup",
										'QueryName':"GetList",
										'rowid': data.id   
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
							SearchFunLibLink()
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
	/*************************合报告分组操作*******结束*****************************/

	/***********************************关联操作*********开始***********************************/
	//搜索方法（关联）
    SearchFunLibLink=function()
    {
		var Groupgrid=$("#Groupgrid").datagrid('getSelected');
		
		if (Groupgrid!=null){
			
			var TestSetOGTTGroupDR=Groupgrid.RowID;
			//alert(TestSetOGTTGroupDR)

			$('#Linkgrid').datagrid('load',  { 
				'ClassName':"web.DHCBL.LAB.BTTestSetOGTTGroupLinks",
				'QueryName':"GetList",
				'otttgroup': TestSetOGTTGroupDR				
			});
		}
		else
		{
			$('#Linkgrid').datagrid('loadData',[]);
		}
        $('#Linkgrid').datagrid('unselectAll');
	}
	//刷新主表及项目组合套表
 	DoReload=function(){
	    $("#TestSetgrid").datagrid('reload');
	    

		var rowdata=$("#Groupgrid").datagrid('getSelected');
		var groupindex=$('#Groupgrid').datagrid('getRowIndex',rowdata);	 //获取行的编号
		$('#Groupgrid').datagrid('refreshRow'.groupindex)
		
 	}

	//关联，1对1
    ConMethod=function(index)
    {
		$('#TestSetgrid').datagrid('selectRow',index);
		var Groupgrid=$("#Groupgrid").datagrid('getSelected');
		var TestSetgrid=$("#TestSetgrid").datagrid('getSelected');
		var Links=$("#Linkgrid").datagrid('getRows');
		if(!Groupgrid)
		{
			$.messager.alert('提示','请选择需要关联的合报告分组！',"info");
        	return;
		}
		if (Links.length<=0)	//判断是否第一条关联 是
		{
			var massage="该数据将设置为主组合套，"
			var firstflag=1
			var flag=tkMakeServerCall("web.DHCBL.LAB.BTTestSetOGTTGroupLinks","FormValidate","",Groupgrid.RowID,TestSetgrid.RowID,TestSetgrid.RowID);
		}
		else		//否
		{
			var massage=""
			var firstflag=0
			var flag=tkMakeServerCall("web.DHCBL.LAB.BTTestSetOGTTGroupLinks","FormValidate","",Groupgrid.RowID,Links[0].MainTestSetDR,TestSetgrid.RowID);
		}
		
		if(flag!=1){
			$.messager.confirm("提示", massage+"确认要保存关联数据吗?", function (r) {
				if (r) 
				{
					var data=tkMakeServerCall("web.DHCBL.LAB.BTTestSetOGTTGroupLinks","SaveLinkDatas",Groupgrid.RowID,TestSetgrid.RowID,firstflag);
					var data=eval('('+data+')');
					if (data.success == 'true') {
						
						DoReload()
						$.messager.popover({msg: '关联成功！',type:'success',timeout: 1000});
						if(Groupgrid!=null){
							var TestSetOGTTGroupDR=Groupgrid.RowID;
							$('#Linkgrid').datagrid('load',{
								'ClassName':"web.DHCBL.LAB.BTTestSetOGTTGroupLinks",
								'QueryName':"GetList",
								'otttgroup':TestSetOGTTGroupDR
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
					//项目组合套表删除此行数据
					
					//
					
				}	
				else
				{
					return false;
				}
			})
		}			
		else 
		{
			$.messager.alert('提示',"该关联已经存在！","info");
		}
			
    }
    //修改主组合套(关联)
    ChangeMainestSet=function(index){
    	$('#Linkgrid').datagrid('selectRow',index);
    	var ChangeMaintestSet_ACTION_URL_Link="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.LAB.BTTestSetOGTTGroupLinks&pClassMethod=ChangeMaintestSet";
    	var row = $("#Linkgrid").datagrid('getSelected'); 
		if(row)
		{
			var TestSetOGTTGroupDR=row.TestSetOGTTGroupDR;
			var SubTestSetDR=row.SubTestSetDR;
			$.messager.confirm('提示', '确定要修改为主组合套吗?', function(r)
			{
				if (r)
				{
					var result= tkMakeServerCall("web.DHCBL.LAB.BTTestSetOGTTGroupLinks","ChangeMaintestSet",TestSetOGTTGroupDR,SubTestSetDR);
					var otttgroup=$('#Groupgrid').datagrid('getSelected');
					if(otttgroup!=null){
						$('#Linkgrid').datagrid('load',{
							'ClassName':"web.DHCBL.LAB.BTTestSetOGTTGroupLinks",
							'QueryName':"GetList",
							'otttgroup':otttgroup.RowID
						});
					}else{
						$('#Linkgrid').datagrid('loadData',[]);
					};
					//刷新主组合套
					//refreshRow
					var rowdata=$("#Groupgrid").datagrid('getSelected');
					var groupindex=$('#Groupgrid').datagrid('getRowIndex',rowdata);	 //获取行的编号
					$('#Groupgrid').datagrid('refreshRow'.groupindex)
				}
			});
		}
    }


	//删除方法（关联）
    DelDataLink=function(index)
    {
    	$('#Linkgrid').datagrid('selectRow',index);
		var row = $("#Linkgrid").datagrid('getSelected'); 
		var Links=$("#Linkgrid").datagrid('getRows');
		if(row)
		{
			
			if (row.MainTestSetDR==row.SubTestSetDR)	//主组合套
			{
				$.messager.confirm('提示', '确定要删除主组合套吗?这将删除所有关联数据。', function(r)
				{
					if (r)
					{
						var datas=tkMakeServerCall("web.DHCBL.LAB.BTTestSetOGTTGroupLinks","DeleteAllLinkData",row.TestSetOGTTGroupDR);
						var data = eval('('+datas+')');

					    if (data.success == 'true') 
					    {
					    	DoReload()		//刷新主表和项目组合套表

					        var otttgroup=$('#Groupgrid').datagrid('getSelected');
							if(otttgroup!=null){
								$('#Linkgrid').datagrid('load',{
									'ClassName':"web.DHCBL.LAB.BTTestSetOGTTGroupLinks",
									'QueryName':"GetList",
									'otttgroup':otttgroup.RowID
								});
							}else{
								$('#Linkgrid').datagrid('loadData',[]);
							};
							

							$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});						 			       
					    }
					    else
					    {
					        var errorMsg ="删除失败！"
							if (data.info) {
								errorMsg =errorMsg+ '<br/>错误信息:' + data.info
							}
							$.messager.alert('操作提示',errorMsg,"error");
					    }		
					}
				});
				
			}
			else
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
							    $("#TestSetgrid").datagrid('reload');
							    
								var data=eval('('+data+')'); 
								if (data.success == 'true') 
								{  
									var otttgroup=$('#Groupgrid').datagrid('getSelected');
									if(otttgroup!=null){
										$('#Linkgrid').datagrid('load',{
											'ClassName':"web.DHCBL.LAB.BTTestSetOGTTGroupLinks",
											'QueryName':"GetList",
											'otttgroup':otttgroup.RowID
										});
									}else{
										$('#Linkgrid').datagrid('loadData',[]);
									};
									$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});	
								}	 
								else 
								{
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

	} 
	/***********************************关联操作*********开始***********************************/
	
	HISUI_Funlib_Translation('Groupgrid');
    HISUI_Funlib_Sort('Groupgrid');
}
$(init);