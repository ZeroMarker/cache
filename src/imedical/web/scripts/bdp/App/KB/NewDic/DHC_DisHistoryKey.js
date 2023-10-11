/// 名称: 既往史关键字表
/// 描述: 包含增删改查、维护成分功能
/// 编写者: 基础数据平台组-丁亚男
/// 编写日期: 2018-7-18
var init = function(){
	
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCDisHistoryKey&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCDisHistoryKey";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCDisHistoryKey&pClassMethod=DeleteData";
	
	//既往史查询下拉框
	$('#DHKDHDr').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.KB.DHCDisHistoryFeild&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'DHIRowId',
		textField:'DHIDesc'
	});
	
	//既往史添加弹框下拉框
	$('#DHKDHDrF').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.KB.DHCDisHistoryFeild&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'DHIRowId',
		textField:'DHIDesc'
	});
	
	$('#DHKKey').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchFunLib();
		}
		if(event.keyCode == 27) {
		  ClearFunLib();
		}
	    
	});
	$('#DHKDHDr').keyup(function(event){
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
		var key=$.trim($('#DHKKey').val());
		var alf=$.trim($('#DHKDHDr').combobox('getValue'));
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.KB.DHCDisHistoryKey",
			QueryName:"GetList",
			'alf' :alf,
			'key' :key
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	//重置方法
	ClearFunLib=function ()
	{
		$("#DHKKey").val("");
		$('#DHKDHDr').combobox('setValue', '');
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.KB.DHCDisHistoryKey",
			QueryName:"GetList"
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	///添加、修改
	SaveFunLib=function(id)
	{		
		if (($('#DHKDHDrF').combobox('getValue')==undefined)||($('#DHKDHDrF').combobox('getValue')==""))
		{
			$.messager.alert('错误提示','既往史不能为空，请选择下拉列表里的值!',"error");
			return;
		}
		
		if ($.trim($("#DHKKeyF").val())=="")
		{
			$.messager.alert('错误提示','关键字不能为空!',"error");
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
						$('#mygrid').datagrid('reload');
						
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
		if (($('#DHKDHDrF').combobox('getValue')==undefined)||($('#DHKDHDrF').combobox('getValue')==""))
		{
			$.messager.alert('错误提示','既往史不能为空，请选择下拉列表里的值!',"error");
			return;
		}
		
		if ($.trim($("#DHKKeyF").val())=="")
		{
			$.messager.alert('错误提示','关键字不能为空!',"error");
			return;
		}
			
		
		
		$('#form-save').form('submit', { 
			url: SAVE_ACTION_URL, 
			success: function (data) { 
				  var data=eval('('+data+')'); 
				  if (data.success == 'true') {
				  		$('#form-save').form("clear");
				  		$HUI.checkbox("#DHKSysFlagF").setValue(true);
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
						$('#mygrid').datagrid('reload');
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
		$('#DHKDHDrF').combobox('reload');
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
		$HUI.checkbox("#DHKSysFlagF").setValue(true);
		
	}
	
	//点击修改按钮
	UpdateData=function () 
	{
		$('#DHKDHDrF').combobox('reload');
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		$.cm({
			ClassName:"web.DHCBL.KB.DHCDisHistoryKey",
			MethodName:"NewOpenData",
			id: record.DHKRowId      ///rowid
		},function(jsonData){
			if (jsonData.DHKSysFlag=="Y"){
				$HUI.checkbox("#DHKSysFlagF").setValue(true);		
			}else{
				$HUI.checkbox("#DHKSysFlagF").setValue(false);
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
						SaveFunLib(record.DHKRowId)
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
		var rowid=row.DHKRowId;
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
				  {field:'DHKRowId',title:'DHKRowId',width:80,sortable:true,hidden:true},
				  {field:'DHIDesc',title:'既往史',width:150,sortable:true},
				  {field:'DHKDHDr',title:'既往史ID',width:150,sortable:true,hidden:true},
				  {field:'DHKKey',title:'关键字',width:150,sortable:true},
				  {field:'DHKSysFlag',title:'是否系统标识',width:150,sortable:true,align:'center',formatter:ReturnFlagIcon}
	 ]];
	 
	 
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCDisHistoryKey",         ///调用Query时
			QueryName:"GetList"
		},
		idField:'DHKRowId',
		columns: columns,  //列信息
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:MainFalg,
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
	ShowUserHabit('mygrid');
	
};
$(init);
