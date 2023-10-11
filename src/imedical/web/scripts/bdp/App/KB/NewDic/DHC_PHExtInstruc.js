/// 名称: 用法字典
/// 描述: 包含增删改查、维护成分功能
/// 编写者: 基础数据平台组-丁亚男
/// 编写日期: 2018-08-07
var init = function(){
	
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtInstruc&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHExtInstruc";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtInstruc&pClassMethod=DeleteData";
	
	
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
	
	//删除按钮
	$("#btnDel").click(function (e) { 
		delData();
	 }) 
 

	 //查询方法
	SearchFunLib=function (){
		var code=$.trim($("#TextCode").val());
		var desc=$.trim($('#TextDesc').val());
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.KB.DHCPHExtInstruc",
			QueryName:"GetList",
			'code':code,	
			'desc':desc
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	//重置方法
	ClearFunLib=function ()
	{
		$("#TextCode").val("");
		$("#TextDesc").val("");
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.KB.DHCPHExtInstruc",
			QueryName:"GetList"
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	///添加、修改
	SaveFunLib=function(id)
	{		
		if ($.trim($("#PHEINCodeF").val())=="")
		{
			$.messager.alert('错误提示','代码不能为空!',"error");
			return;
		}
		if ($.trim($("#PHEINDescF").val())=="")
		{
			$.messager.alert('错误提示','描述不能为空!',"error");
			return;
		}	
		
		$('#form-save').form('submit', { 
			url: SAVE_ACTION_URL, 
			success: function (data) { 
				  var data=eval('('+data+')'); 
				  if (data.success == 'true') {
						/*$.messager.show({ 
						  title: '提示消息', 
						  msg: '提交成功', 
						  showType: 'show', 
						  timeout: 1000, 
						  style: { 
							right: '', 
							bottom: ''
						  } 
						});*/
						$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
						$('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
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
	///继续添加
	TAddFunLib=function(id)
	{		
		if ($.trim($("#PHEINCodeF").val())=="")
		{
			$.messager.alert('错误提示','代码不能为空!',"error");
			return;
		}
		if ($.trim($("#PHEINDescF").val())=="")
		{
			$.messager.alert('错误提示','描述不能为空!',"error");
			return;
		}	
		
		$('#form-save').form('submit', { 
			url: SAVE_ACTION_URL, 
			success: function (data) { 
				  var data=eval('('+data+')'); 
				  if (data.success == 'true') {
				  		$('#form-save').form("clear");
				  		$HUI.checkbox("#PHEINActiveFlagF").setValue(true);
						$HUI.checkbox("#PHEINSysFlagF").setValue(true);
						/*$.messager.show({ 
						  title: '提示消息', 
						  msg: '提交成功', 
						  showType: 'show', 
						  timeout: 1000, 
						  style: { 
							right: '', 
							bottom: ''
						  } 
						});*/
						$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000}); 
						$('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
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
	//点击添加按钮
	AddData=function () 
	{
		$("#myWin").show();
		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-w-add',
			resizable:true,
			title:'新增',
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				text:'保存',
				//iconCls:'icon-save',
				id:'save_btn',
				handler:function(){
					SaveFunLib("")
				}
			},{
				text:'继续新增',
				//iconCls:'icon-cancel',
				handler:function(){
					TAddFunLib("")
				}
			},{
				text:'关闭',
				//iconCls:'icon-cancel',
				handler:function(){
					myWin.close();
				}
			}]
		});	
		$('#form-save').form("clear");
		$HUI.checkbox("#PHEINActiveFlagF").setValue(true);
		$HUI.checkbox("#PHEINSysFlagF").setValue(true);
		//如勾选框默认不选择，需要去掉checked样式 ，如果默认勾选则不用加。2018-06-12
		//$('#ARCICRestrictedOrder').parent().removeClass("checked");
	}
	
	//点击修改按钮
	UpdateData=function () 
	{
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		$.cm({
			ClassName:"web.DHCBL.KB.DHCPHExtInstruc",
			MethodName:"NewOpenData",
			id: record.PHEINRowId      ///rowid
		},function(jsonData){
			if (jsonData.PHEINActiveFlag=="Y"){
				$HUI.checkbox("#PHEINActiveFlagF").setValue(true);		
			}else{
				$HUI.checkbox("#PHEINActiveFlagF").setValue(false);
			}
			if (jsonData.PHEINSysFlag=="Y"){
				$HUI.checkbox("#PHEINSysFlagF").setValue(true);		
			}else{
				$HUI.checkbox("#PHEINSysFlagF").setValue(false);
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
					//iconCls:'icon-save',
					id:'save_btn',
					handler:function(){
						SaveFunLib(record.PHEINRowId)
					}
				},{
					text:'关闭',
					//iconCls:'icon-cancel',
					handler:function(){
						myWin.close();
					}
				}]
			});
		});
		
	}
	
	delData=function()
	{
		var row = $("#mygrid").datagrid("getSelected"); 
		if (!(row))
		{	$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var rowid=row.PHEINRowId;
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
			if (r){
				$.ajax({
					url:DELETE_ACTION_URL,  
					data:{"id":rowid},  
					type:"POST",   
					//dataType:"TEXT",  
					success: function(data){
							  var data=eval('('+data+')'); 
							  if (data.success == 'true') {
								/*$.messager.show({ 
								  title: '提示消息', 
								  msg: '删除成功', 
								  showType: 'show', 
								  timeout: 1000, 
								  style: { 
									right: '', 
									bottom: ''
								  } 
								}); */
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
				  {field:'PHEINRowId',title:'PHEINRowId',width:80,sortable:true,hidden:true},
				  {field:'PHEINCode',title:'代码',width:150,sortable:true},
				  {field:'PHEINDesc',title:'描述',width:150,sortable:true},
				  {field:'PHEINActiveFlag',title:'是否可用',width:150,sortable:true,align:'center',formatter:ReturnFlagIcon},
				  {field:'PHEINSysFlag',title:'是否系统标识',width:150,sortable:true,align:'center',formatter:ReturnFlagIcon}
	 ]];
	 
	 
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCPHExtInstruc",         ///调用Query时
			QueryName:"GetList"
		},
		//ClassTableName:'User.DHCPHExtForm',
		//SQLTableName:'DHC_PHExtForm',
		idField:'PHEINRowId',
		columns: columns,  //列信息
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:PageSizeMain,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true,
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort:false,  //定义是否从服务器排序数据。true
		onDblClickRow:function(rowIndex,rowData){
        	UpdateData();
        },
        onLoadSuccess:function(data){
	        $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
        	$(this).datagrid('columnMoving'); //列可以拖拽改变顺序
        }
	});
	//ShowUserHabit('mygrid');
	
};
$(init);
