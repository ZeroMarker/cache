
//Creator:陈莹
//CreatDate:2018-2-5
//Description:节假日特殊业务代码表

var init = function(){
	
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.BDPSpecialService&pClassMethod=DeleteData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.BDPSpecialService&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.BDPSpecialService";
	
	
	$('#TextCode').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchFunLib();
		}
		if(event.keyCode == 27) {
		  ClearFunLib();
		}
	    
	});
	$('#TextDesc').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchFunLib();
		}
		if(event.keyCode == 27) {
		  ClearFunLib();
		}
	    
	});
	
	//查询按钮
	$("#btnSearch").click(function (e) { 

			SearchFunLib();
	 })  
	 
	//重置按钮
	$("#btnRefresh").click(function (e) { 

			ClearFunLib();
	 }) 
	 
	 //点击添加按钮
	$("#btnAdd").click(function(e){
		AddData();
	});
	//点击修改按钮
	$("#btnUpdate").click(function(e){
		UpdateData();
	});
	//点击删除按钮
	$("#btnDel").click(function (e) { 
			DelData();
	});	
	 
	 //查询方法
	SearchFunLib=function(){
		var code=$.trim($("#TextCode").val());
		var desc=$.trim($('#TextDesc').val());
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.CT.BDPSpecialService",
			QueryName:"GetList",	
			'code':code,	
			'desc':desc
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	//重置方法
	ClearFunLib=function()
	{
		$("#TextCode").val("");
		$("#TextDesc").val("");
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.CT.BDPSpecialService",
			QueryName:"GetList"
		});
		$('#mygrid').datagrid('unselectAll');

	}
	 ///新增、修改
	SaveFunLib=function(id)
	{			
		if ($.trim($("#BDPSSCode").val())=="")
		{
			$.messager.alert('错误提示','代码不能为空!',"error");
			return;
		}
		if ($.trim($("#BDPSSDesc").val())=="")
		{
			$.messager.alert('错误提示','描述不能为空!',"error");
			return;
		}
		
		var alertmessage="确认要保存数据吗?"
		///2018-03-09  业务代码不可任意修改
		if ((id!="")&&($.trim($("#BDPSSCode").val())!=$("#mygrid").datagrid("getSelected").BDPSSCode))
		{
			var alertmessage="业务代码由产品组指定并写死在程序中。如果要修改，必须要产品组同步修改程序，确认要保存数据吗?"
		}
		
		$.messager.confirm('提示', alertmessage, function(r){
			if (r){
				$('#form-save').form('submit', { 
					url: SAVE_ACTION_URL, 
					/*onSubmit: function(param){
						
						param.BDPSSRowId = id;   ///rowid
						
					},
					*/
					success: function (data) { 
						  var data=eval('('+data+')'); 
						  if (data.success == 'true') {
								$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
								if (id!="")
								{
									$('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
								}
								else{
									
									 $.cm({
										ClassName:"web.DHCBL.CT.BDPSpecialService",
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
	
	
	 //点击新增按钮
	 AddData=function() {
		$("#myWin").show();
		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-w-add',
			resizable:true,
			title:'新增',
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				text:'保存',
				id:'save_btn',
				handler:function(){
					SaveFunLib("")
				}
			},{
				text:'关闭',
				handler:function(){
					myWin.close();
				}
			}]
		});	
		$('#form-save').form("clear");
		$HUI.checkbox("#BDPSSTimeRangeFlag").setValue(false);	
		//如勾选框默认不选择，需要去掉checked样式 ，如果默认勾选则不用加。2018-06-12
		$('#BDPSSTimeRangeFlag').parent().removeClass("checked");
		
		
	}
	
	//点击修改按钮
	UpdateData=function() {
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var id=record.BDPSSRowId
		$.cm({
			ClassName:"web.DHCBL.CT.BDPSpecialService",
			MethodName:"OpenData",
			id:id,
			RetFlag:1
		},function(jsonData){
			if (jsonData.BDPSSTimeRangeFlag=="Y"){
				$HUI.checkbox("#BDPSSTimeRangeFlag").setValue(true);		
			}else{
				$HUI.checkbox("#BDPSSTimeRangeFlag").setValue(false);
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

	

	///删除
	DelData=function()
	{                  
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
			if (r){	
				$.ajax({
					url:DELETE_ACTION_URL,  
					data:{
						"id":record.BDPSSRowId      ///rowid
					},  
					type:"POST",   
					success: function(data){
							  var data=eval('('+data+')'); 
							  if (data.success == 'true') {
									$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
									
									$('#mygrid').datagrid('reload');  // 重新载入当前页面数据  
									$('#mygrid').datagrid('unselectAll');  // 清空列表选中数据
							  } 
							  else { 
									var errorMsg ="删除失败！"
									if (data.info) {
										errorMsg =errorMsg+ '<br/>错误信息:' + data.info
									}
									$.messager.alert('操作提示',errorMsg,"error");
					
							}			
					}  
				})
			}
		});
	}
	var columns =[[  
				  {field:'BDPSSRowId',title:'RowId',width:80,hidden:true,sortable:true},
				  {field:'BDPSSCode',title:'业务代码',width:120,sortable:true},
				  {field:'BDPSSDesc',title:'业务描述',width:120,sortable:true},
				  {field:'BDPSSRemark',title:'备注',width:120,sortable:true},
				  {field:'BDPSSTimeRangeFlag',title:'是否开启时段功能',width:80,sortable:true,align:'center',formatter:ReturnFlagIcon} 
				  ]];
				  
				  
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.CT.BDPSpecialService",
			QueryName:"GetList"
		},
		columns: columns,  //列信息
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:PageSizeMain,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		ClassTableName:'User.BDPSpecialService',
		SQLTableName:'BDP_SpecialService',
		idField:'BDPSSRowId', 
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true, //列号 自适应宽度
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort:false,  //定义是否从服务器排序数据。true
		
		onRowContextMenu: function(e, rowIndex, rowData){   //右键菜单
			e.preventDefault();  //阻止浏览器捕获右键事件
			$(this).datagrid("selectRow", rowIndex); //根据索引选中该行  
			var mygridmm = $('<div style="width:120px;"></div>').appendTo('body');	
			$(
	        '<div onclick=UpdateData() iconCls="icon-write-order">修改</div>' +
			'<div onclick=Datagrid_DelData("mygrid","'+DELETE_ACTION_URL+'") iconCls="icon-cancel">删除</div>'
			).appendTo(mygridmm)
			mygridmm.menu()
			mygridmm.menu('show',{
				left:e.pageX,  
				top:e.pageY
			});
			
		},
		onDblClickRow:function(rowIndex,rowData){
        	UpdateData();
        },
        onLoadSuccess:function(data){
	        $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
        	$(this).datagrid('columnMoving'); //列可以拖拽改变顺序
        }
	});
	ShowUserHabit('mygrid');
};
$(init);