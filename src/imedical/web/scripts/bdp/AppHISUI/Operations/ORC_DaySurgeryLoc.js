/// 日间手术科室界面
/// 基础数据平台-李可凡
/// 2021-05-08

var init = function(){
	
	var SAVE_myACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.ORCDaySurgeryLoc&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.ORCDaySurgeryLoc";
	var DELETE_myACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ORCDaySurgeryLoc&pClassMethod=DeleteData";
	
	var SAVE_linkACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.ORCDaySurgeryLocLinkLoc&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.ORCDaySurgeryLocLinkLoc";
	var DELETE_linkACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ORCDaySurgeryLocLinkLoc&pClassMethod=DeleteData";
	
	var HospID=""
	//多院区下拉框
	var hospComp=GenHospComp('ORC_DaySurgeryLoc');
	hospComp.options().onSelect=function(){
		var HospID=$HUI.combogrid('#_HospList').getValue();
		myClearFunLib();
	}
	
	$('#myTextCode').keyup(function(event){
		if(event.keyCode == 13) {
		  mySearchFunLib();
		}
		if(event.keyCode == 27) {
		  myClearFunLib();
		}
	    
	});
	
	//科室下拉框
	$('#DSLDaySurgeryLocDR').combobox({
		url:$URL+"?ClassName=web.DHCBL.CT.CTLoc&QueryName=GetDataForCmb1&ResultSetType=array&hospid="+HospID,
		valueField:'CTLOCRowID',
		textField:'CTLOCDesc'
	});
	
	//查询按钮
	$("#mybtnSearch").click(function (e) {
			mySearchFunLib();
	 })  
	 
	//重置按钮
	$("#mybtnRefresh").click(function (e) {
			myClearFunLib();
	 }) 
	
	//点击添加按钮
	$("#mybtnAdd").click(function(e){
		myAddData();
	});
	//点击修改按钮
	$("#mybtnUpdate").click(function(e){
		myUpdateData();
	});
	//点击删除按钮
	$("#mybtnDel").click(function (e) { 
		myDelData();
	});	
	
	//禁用关联科室按钮
	disableLinkBtn=function(){
		$('#linkgrid').datagrid('load',  {
                ClassName:"web.DHCBL.CT.ORCDaySurgeryLocLinkLoc",
                QueryName:"GetList"
			});
		$('#linkbtnSearch').linkbutton('disable');
		$('#linkbtnRefresh').linkbutton('disable');
		$('#linkbtnAdd').linkbutton('disable');
		$('#linkbtnUpdate').linkbutton('disable');
		$('#linkbtnDel').linkbutton('disable');
		$("#linkTextCode").val("");
		$("#linkTextDesc").val("");
	}
	
	//查询方法
	mySearchFunLib=function(){
		var query=$.trim($("#myTextCode").val());
		var HospID=hospComp.getValue();
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.CT.ORCDaySurgeryLoc",
			QueryName:"GetList",
			'hospid':HospID,
			'query':query
		});
		$('#mygrid').datagrid('unselectAll');
		disableLinkBtn();
	}
	
	//重置方法
	myClearFunLib=function()
	{
		$("#myTextCode").val("");
		var HospID=hospComp.getValue();
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.CT.ORCDaySurgeryLoc",
			QueryName:"GetList",
			'hospid':HospID
		});
		$('#mygrid').datagrid('unselectAll');
		disableLinkBtn();
	}
	
	///删除
	myDelData=function()
	{                  
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
			if (r){	
				$.ajax({
					url:DELETE_myACTION_URL,  
					data:{
						"id":record.DSLRowId
					},  
					type:"POST",   
					success: function(data){
							  var data=eval('('+data+')'); 
							  if (data.success == 'true') {
									$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
									
									$('#mygrid').datagrid('reload');  // 重新载入当前页面数据  
									$('#mygrid').datagrid('unselectAll');  // 清空列表选中数据
									disableLinkBtn();
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
	
	///新增、修改
	mySaveFunLib=function(id)
	{
		if ($('#DSLDaySurgeryLocDR').combobox('getValue')=="")
		{
			$.messager.alert('错误提示','科室不能为空!',"info");
			return;
		}
		var flag = tkMakeServerCall("web.DHCBL.CT.ORCDaySurgeryLoc","FormValidate",$("#DSLRowId").val(),$('#DSLDaySurgeryLocDR').combobox('getValue'));	
		if (flag==1)
		{
			$.messager.alert('操作提示',"该记录已经存在！","info");
			return;
		}
		$.messager.confirm('提示', "确认要保存数据吗?", function(r){
			if (r){
				$('#myform-save').form('submit', { 
					url: SAVE_myACTION_URL, 
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
										ClassName:"web.DHCBL.CT.ORCDaySurgeryLoc",
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
								disableLinkBtn();
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
	myAddData=function() {
		var HospID=hospComp.getValue();
		var url=$URL+"?ClassName=web.DHCBL.CT.CTLoc&QueryName=GetDataForCmb1&ResultSetType=array&hospid="+HospID;
		$('#DSLDaySurgeryLocDR').combobox('reload',url);
		$("#myWin").show();
		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-w-add',
			resizable:true,
			title:'新增',
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				text:'保存',
				id:'mysave_btn',
				handler:function(){
					mySaveFunLib("")
				}
			},{
				text:'关闭',
				handler:function(){
					myWin.close();
				}
			}]
		});	
		$('#myform-save').form("clear");
	}
	
	//点击修改按钮
	myUpdateData=function() {
		var HospID=hospComp.getValue();
		var url=$URL+"?ClassName=web.DHCBL.CT.CTLoc&QueryName=GetDataForCmb1&ResultSetType=array&hospid="+HospID;
		$('#DSLDaySurgeryLocDR').combobox('reload',url);
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		var id=record.DSLRowId
		$.cm({
			ClassName:"web.DHCBL.CT.ORCDaySurgeryLoc",
			MethodName:"OpenData",
			id:id
		},function(jsonData){
			$('#myform-save').form("load",jsonData);
			$("#myWin").show(); 
			var myWin = $HUI.dialog("#myWin",{
				iconCls:'icon-w-edit',
				resizable:true,
				title:'修改',
				modal:true,
				buttons:[{
					text:'保存',
					id:'mysave_btn',
					handler:function(){
						mySaveFunLib(id)
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
	
	//datagrid排序：
	function sort_int(a,b){
		if(a.length >b.length) return 1;
		else if (a.length <b.length) return -1;
		else if (a > b) return 1;
		else return -1;
	}
	
	var mycolumns =[[
				{field:'DSLRowId',title:'RowId',width:80,hidden:true,sortable:true},
				{field:'DSLDaySurgeryLocDR',title:'科室DR',width:120,hidden:true,sortable:true,},
				{field:'CTLOCCode',title:'代码',width:120,sortable:true},
				{field:'CTLOCDesc',title:'名称',width:120,sortable:true}
				]];
	
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.CT.ORCDaySurgeryLoc",
			QueryName:"GetList",
			'hospid':hospComp.getValue()    //多院区医院
		},
		columns: mycolumns,  //列信息
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:PageSizeMain,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		ClassTableName:'User.ORCDaySurgeryLoc',
		SQLTableName:'ORC_DaySurgeryLoc',
		idField:'DSLRowId', 
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true, //列号 自适应宽度
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort:false,  //定义是否从服务器排序数据。true
		onClickRow:function(rowIndex,rowData){
			$('#linkbtnSearch').linkbutton('enable');
			$('#linkbtnRefresh').linkbutton('enable');
			$('#linkbtnAdd').linkbutton('enable');
			$('#linkbtnUpdate').linkbutton('enable');
			$('#linkbtnDel').linkbutton('enable');
			$("#linkTextCode").val("");
			$("#linkTextDesc").val("");
			var record = $("#mygrid").datagrid("getSelected");
        	$('#linkgrid').datagrid('load',  {
                ClassName:"web.DHCBL.CT.ORCDaySurgeryLocLinkLoc",
                QueryName:"GetList",
				parref:record.DSLRowId
			});
        },
		onDblClickRow:function(rowIndex,rowData){
        	myUpdateData();
        },
        onLoadSuccess:function(data){
	        $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
        	$(this).datagrid('columnMoving'); //列可以拖拽改变顺序
        }
		
	});
	ShowUserHabit('mygrid');
	
	
/*****************************************关联科室部分****************************************/

	var SAVE_linkACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.ORCDaySurgeryLocLinkLoc&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.ORCDaySurgeryLocLinkLoc";
	var DELETE_linkACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ORCDaySurgeryLocLinkLoc&pClassMethod=DeleteData";
	
	$('#linkTextCode').keyup(function(event){
		if(event.keyCode == 13) {
		  linkSearchFunLib();
		}
		if(event.keyCode == 27) {
		  linkClearFunLib();
		}
	    
	});
	
	var linkcolumns =[[
					{field:'DSLLLRowId',title:'DSLLLRowId',width:100,sortable:true,hidden:true},
					{field:'DSLLLParRef',title:'DSLLLParRef',width:100,sortable:true,hidden:true},
					{field:'DSLLLLinkLocDR',title:'关联科室DR',width:200,sortable:true,hidden:true},
					{field:'CTLOCCode',title:'代码',width:200,sortable:true},
					{field:'CTLOCDesc',title:'名称',width:200,sortable:true}
    ]];
    var linkgrid = $HUI.datagrid("#linkgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.CT.ORCDaySurgeryLocLinkLoc",
            QueryName:"GetList"
        },
        columns: linkcolumns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:10,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        remoteSort:false,
        //ClassTableName:'User.CTHCCSEquipLinkContList',
		//SQLTableName:'CT_HCCSEquipLinkContList',
        idField:'DSLLLRowId',
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onDblClickRow:function(rowIndex,rowData){
        	linkUpdateData();
        },
        onLoadSuccess:function(data){
	        $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
        	$(this).datagrid('columnMoving'); //列可以拖拽改变顺序
        }		
    });
	
	//科室下拉框
	$('#DSLLLLinkLocDR').combobox({
		url:$URL+"?ClassName=web.DHCBL.CT.CTLoc&QueryName=GetDataForCmb1&ResultSetType=array&hospid="+HospID,
		valueField:'CTLOCRowID',
		textField:'CTLOCDesc'
	});
	
    //搜索
    $('#linkbtnSearch').click(function(e){
        linkSearchFunLib();
    });
	
	//重置
    $('#linkbtnRefresh').click(function(e){
    	linkClearFunLib();
    });
	
    //搜索方法
    linkSearchFunLib=function()
    {
		var record = $("#mygrid").datagrid("getSelected");
		var query=$.trim($("#linkTextCode").val());
        $('#linkgrid').datagrid('reload',  {
                ClassName:"web.DHCBL.CT.ORCDaySurgeryLocLinkLoc",
                QueryName:"GetList",
				'parref':record.DSLRowId,
				'query':query
        });
        $('#linkgrid').datagrid('unselectAll');
    }    
    
    //重置方法
    linkClearFunLib=function()
    {
		var record = $("#mygrid").datagrid("getSelected");
		$("#linkTextCode").val("");
		$("#linkTextDesc").val("");
    	$('#linkgrid').datagrid('reload',  {
            	ClassName:"web.DHCBL.CT.ORCDaySurgeryLocLinkLoc",
            	QueryName:"GetList",
				parref:record.DSLRowId
    	});
		$('#linkgrid').datagrid('unselectAll');     
    }
	
	//点击添加按钮
	$("#linkbtnAdd").click(function(e){
		linkAddData();
	});
	//点击修改按钮
	$("#linkbtnUpdate").click(function(e){
		linkUpdateData();
	});
	//点击删除按钮
	$("#linkbtnDel").click(function (e) { 
		linkDelData();
	});	
	
	///删除
	linkDelData=function()
	{                  
		var record = $("#linkgrid").datagrid("getSelected"); 
		if (!(record))
		{	$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
			if (r){	
				$.ajax({
					url:DELETE_linkACTION_URL,  
					data:{
						"id":record.DSLLLRowId
					},  
					type:"POST",   
					success: function(data){
							  var data=eval('('+data+')'); 
							  if (data.success == 'true') {
									$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
									
									$('#linkgrid').datagrid('reload');  // 重新载入当前页面数据  
									$('#linkgrid').datagrid('unselectAll');  // 清空列表选中数据
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
	
	///新增、修改
	linkSaveFunLib=function(id)
	{
		if ($('#DSLLLLinkLocDR').combobox('getValue')=="")
		{
			$.messager.alert('错误提示','科室不能为空!',"info");
			return;
		}
		var flag = tkMakeServerCall("web.DHCBL.CT.ORCDaySurgeryLocLinkLoc","FormValidate",$("#DSLLLRowId").val(),$("#DSLLLParRef").val(),$('#DSLLLLinkLocDR').combobox('getValue'));	
		if (flag==1)
		{
			$.messager.alert('操作提示',"该记录已经存在！","info");
			return;
		}
		$.messager.confirm('提示', "确认要保存数据吗?", function(r){
			if (r){
				$('#linkform-save').form('submit', { 
					url: SAVE_linkACTION_URL, 
					success: function (data) { 
						  var data=eval('('+data+')'); 
						  if (data.success == 'true') {
								$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
								if (id!="")
								{
									$('#linkgrid').datagrid('reload');  // 重新载入当前页面数据 
								}
								else{
									
									 $.cm({
										ClassName:"web.DHCBL.CT.ORCDaySurgeryLocLinkLoc",
										QueryName:"GetList",
										rowid: data.id   
									},function(jsonData){
										$('#linkgrid').datagrid('insertRow',{
											index:0,
											row:jsonData.rows[0]
										})
									})
									$('#linkgrid').datagrid('unselectAll');
								}
								$('#linkWin').dialog('close'); // close a dialog
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
	linkAddData=function() {
		var HospID=hospComp.getValue();
		var url=$URL+"?ClassName=web.DHCBL.CT.CTLoc&QueryName=GetDataForCmb1&ResultSetType=array&hospid="+HospID;
		$('#DSLLLLinkLocDR').combobox('reload',url);
		var record = $("#mygrid").datagrid("getSelected");
		$("#linkWin").show();
		var linkWin = $HUI.dialog("#linkWin",{
			iconCls:'icon-w-add',
			resizable:true,
			title:'新增',
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				text:'保存',
				id:'linksave_btn',
				handler:function(){
					linkSaveFunLib("")
				}
			},{
				text:'关闭',
				handler:function(){
					linkWin.close();
				}
			}]
		});	
		$('#linkform-save').form("clear");
		$('#DSLLLParRef').val(record.DSLRowId);
	}
	
	//点击修改按钮
	linkUpdateData=function() {
		var record = $("#linkgrid").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		var HospID=hospComp.getValue();
		var url=$URL+"?ClassName=web.DHCBL.CT.CTLoc&QueryName=GetDataForCmb1&ResultSetType=array&hospid="+HospID;
		$('#DSLLLLinkLocDR').combobox('reload',url);
		var id=record.DSLLLRowId
		$.cm({
			ClassName:"web.DHCBL.CT.ORCDaySurgeryLocLinkLoc",
			MethodName:"OpenData",
			id:id
		},function(jsonData){
			$('#linkform-save').form("load",jsonData);
			$("#linkWin").show(); 
			var linkWin = $HUI.dialog("#linkWin",{
				iconCls:'icon-w-edit',
				resizable:true,
				title:'修改',
				modal:true,
				buttons:[{
					text:'保存',
					id:'linksave_btn',
					handler:function(){
						linkSaveFunLib(id)
					}
				},{
					text:'关闭',
					handler:function(){
						linkWin.close();
					}
				}]
			});		
		});
	}

	disableLinkBtn();
	
};
$(init);