/// 名称: 溶媒分类明细
/// 描述: 包含增删改查、维护成分功能
/// 编写者: 基础数据平台组-丁亚男
/// 编写日期: 2018-08-09
var init = function(){
	
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHMenstruumItm&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHMenstruumItm";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHMenstruumItm&pClassMethod=DeleteData";
	
	//药品名下拉框（添加弹框）
	$('#PHMIDrugDrF').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHProName&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'PHNRowId',
		textField:'PHNDesc'
	});
	//药品名查询下拉框
	$('#PHMIDrugDr').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHProName&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'PHNRowId',
		textField:'PHNDesc'
	});
	
	//溶媒下拉框（添加弹框）
	$('#PHMIMentDrF').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHMenstruumCat&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'PHMCRowId',
		textField:'PHMCDesc'
	});
	//溶媒查询下拉框
	$('#PHMIMentDr').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHMenstruumCat&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'PHMCRowId',
		textField:'PHMCDesc'
	});
	
 	//删除按钮
	$("#btnDel").click(function (e) { 

			Datagrid_DelData('mygrid',DELETE_ACTION_URL);
	 }) 
	 //查询方法
	SearchFunLib=function (){
		var drug=$.trim($('#PHMIDrugDr').combobox('getValue'));
		var ment=$.trim($('#PHMIMentDr').combobox('getValue'));
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.KB.DHCPHMenstruumItm",
			QueryName:"GetList",
			'drug':drug,
			'ment':ment
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	//重置方法
	ClearFunLib=function ()
	{
		$('#PHMIDrugDr').combobox('setValue', '');
		$('#PHMIMentDr').combobox('setValue', '');
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.KB.DHCPHMenstruumItm",
			QueryName:"GetList"
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	///添加、修改
	SaveFunLib=function(id)
	{		
		if (($('#PHMIDrugDrF').combobox('getValue')==undefined)&&($('#PHMIDrugDrF').combobox('getText')!=""))
		{
			$.messager.alert('错误提示','请选择下拉列表里的药品名!',"error");
			return;
		}
		if (($('#PHMIMentDrF').combobox('getValue')==undefined)&&($('#PHMIMentDrF').combobox('getText')!=""))
		{
			$.messager.alert('错误提示','请选择下拉列表里的溶媒!',"error");
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
		if (($('#PHMIDrugDrF').combobox('getValue')==undefined)&&($('#PHMIDrugDrF').combobox('getText')!=""))
		{
			$.messager.alert('错误提示','请选择下拉列表里的药品名!',"error");
			return;
		}
		if (($('#PHMIMentDrF').combobox('getValue')==undefined)&&($('#PHMIMentDrF').combobox('getText')!=""))
		{
			$.messager.alert('错误提示','请选择下拉列表里的溶媒!',"error");
			return;
		}
		$('#form-save').form('submit', { 
			url: SAVE_ACTION_URL, 
			success: function (data) { 
				  var data=eval('('+data+')'); 
				  if (data.success == 'true') {
				  		$('#form-save').form("clear");
						$HUI.checkbox("#PHEGAlSysFlagF").setValue(true);
						/*$.messager.show({ 
						  title: '提示消息', 
						  msg: '提交成功', 
						  showType: 'show', 
						  timeout: 1000, 
						  style: { 
							right: '', 
							bottom: ''
						  } 
						}); */
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
		$('#PHMIDrugDrF').combobox('reload');
		$('#PHMIMentDrF').combobox('reload');
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
	}
	
	//点击修改按钮
	UpdateData=function () 
	{
		$('#PHMIDrugDrF').combobox('reload');
		$('#PHMIMentDrF').combobox('reload');
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		$.cm({
			ClassName:"web.DHCBL.KB.DHCPHMenstruumItm",
			MethodName:"NewOpenData",
			id:record.PHMIRowId      ///rowid
		},function(jsonData){
			//alert(JSON.stringify(jsonData))
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
						SaveFunLib(record.PHMIRowId)
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
	
	var columns =[[  
				  {field:'PHMIRowId',title:'PHMIRowId',width:80,sortable:true,hidden:true},
				  {field:'PHNDesc',title:'药品名',width:150,sortable:true},
				  {field:'PHMIDrugDr',title:'药品名ID',width:150,sortable:true,hidden:true},
				  {field:'PHMCDesc',title:'溶媒',width:150,sortable:true},
				  {field:'PHMIMentDr',title:'溶媒ID',width:150,sortable:true,hidden:true}
	 ]];
	 
	 
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCPHMenstruumItm",         ///调用Query时
			QueryName:"GetList"
		},
		idField:'PHMIRowId',
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
	ShowUserHabit('mygrid');
	
};
$(init);


 

