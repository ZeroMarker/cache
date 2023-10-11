/// 名称: 药品通用名和剂型关联
/// 描述: 包含增删改查、维护成分功能
/// 编写者: 基础数据平台组-丁亚男
/// 编写日期: 2018-07-24

var init = function(){
	
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCGenLinkPointer&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCGenLinkPointer";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCGenLinkPointer&pClassMethod=DeleteData";
	
	//通用名下拉框（添加弹框）
	$('#GlPGenDrF').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtGeneric&QueryName=GetDataForCmb1&ResultSetType=array&code=DRUG",
		valueField:'PHEGRowId',
		textField:'PHEGDesc'
	});
	//通用名下拉框（修改弹框）
	$('#GlPGenDrFU').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtGeneric&QueryName=GetDataForCmb1&ResultSetType=array&code=DRUG",
		valueField:'PHEGRowId',
		textField:'PHEGDesc'
	});
	//通用名查询下拉框
	$('#GlPGenDr').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtGeneric&QueryName=GetDataForCmb1&ResultSetType=array&code=DRUG",
		valueField:'PHEGRowId',
		textField:'PHEGDesc'
	});
	
	//剂型下拉框（添加弹框）
	$('#GlPPointerF').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtForm&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'PHEFRowId',
		textField:'PHEFDesc'
	});
	//剂型下拉框（修改弹框）
	$('#GlPPointerFU').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtForm&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'PHEFRowId',
		textField:'PHEFDesc'
	});
	//剂型查询下拉框
	$('#GlPPointer').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtForm&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'PHEFRowId',
		textField:'PHEFDesc'
	});
	
	//删除按钮
	$("#btnDel").click(function (e) { 

			Datagrid_DelData('mygrid',DELETE_ACTION_URL);
	 }) 
 

	 //查询方法
	SearchFunLib=function (){
		var gen=$.trim($('#GlPGenDr').combobox('getValue'));
		var pointer=$.trim($('#GlPPointer').combobox('getValue'));
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.KB.DHCGenLinkPointer",
			QueryName:"GetList",
			'gen':gen,
			'pointer':pointer
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	//重置方法
	ClearFunLib=function ()
	{
		$('#GlPGenDr').combobox('setValue', '');
		$('#GlPPointer').combobox('setValue', '');
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.KB.DHCGenLinkPointer",
			QueryName:"GetList"
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	///添加
	SaveFunLib=function(id)
	{		
		if (($('#GlPGenDrF').combobox('getValue')==undefined)||($('#GlPGenDrF').combobox('getValue')==""))
		{
			$.messager.alert('错误提示','通用名不能为空，请选择下拉列表里的值!',"error");
			return;
		}
		if (($('#GlPPointerF').combobox('getValue')==undefined)||($('#GlPPointerF').combobox('getValue')==""))
		{
			$.messager.alert('错误提示','剂型不能为空，请选择下拉列表里的值!',"error");
			return;
		}
		var GlPPointerValue =$('#GlPPointerF').combobox('getValues')
		$('#form-save').form('submit', { 
			url: SAVE_ACTION_URL,
			onSubmit: function(param){
					param.GlPPointer= GlPPointerValue	
				},
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
		if (($('#GlPGenDrF').combobox('getValue')==undefined)||($('#GlPGenDrF').combobox('getValue')==""))
		{
			$.messager.alert('错误提示','通用名不能为空，请选择下拉列表里的值!',"error");
			return;
		}
		if (($('#GlPPointerF').combobox('getValue')==undefined)||($('#GlPPointerF').combobox('getValue')==""))
		{
			$.messager.alert('错误提示','剂型不能为空，请选择下拉列表里的值!',"error");
			return;
		}
		$('#form-save').form('submit', { 
			url: SAVE_ACTION_URL,
			success: function (data) { 
				  var data=eval('('+data+')'); 
				  if (data.success == 'true') {
				  		$('#form-save').form("clear");
				  		$HUI.checkbox("#GlPActiveFlagF").setValue(true);
				  		$HUI.checkbox("#GlPSysFlagF").setValue(true);
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
		$('#GlPGenDrF').combobox('reload');
		$('#GlPPointerF').combobox('reload');
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
		$HUI.checkbox("#GlPActiveFlagF").setValue(true);
		$HUI.checkbox("#GlPSysFlagF").setValue(true);
	}
	///修改
	SaveFunLibUpdate=function(id)
	{		
		if (($('#GlPGenDrFU').combobox('getValue')==undefined)||($('#GlPGenDrFU').combobox('getValue')==""))
		{
			$.messager.alert('错误提示','通用名不能为空，请选择下拉列表里的值!',"error");
			return;
		}
		if (($('#GlPPointerFU').combobox('getValue')==undefined)||($('#GlPPointerFU').combobox('getValue')==""))
		{
			$.messager.alert('错误提示','剂型不能为空，请选择下拉列表里的值!',"error");
			return;
		}
		$('#form-save-Update').form('submit', { 
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
						$('#myWinUpdate').dialog('close'); // close a dialog
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
	//点击修改按钮
	UpdateData=function () 
	{
		$('#GlPGenDrFU').combobox('reload');
		$('#GlPPointerFU').combobox('reload');
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		$.cm({
			ClassName:"web.DHCBL.KB.DHCGenLinkPointer",
			MethodName:"NewOpenData",
			id: record.GlPRowId      ///rowid
		},function(jsonData){
			if (jsonData.GlPActiveFlag=="Y"){
				$HUI.checkbox("#GlPActiveFlagFU").setValue(true);		
			}else{
				$HUI.checkbox("#GlPActiveFlagFU").setValue(false);
			}
			if (jsonData.GlPSysFlag=="Y"){
				$HUI.checkbox("#GlPSysFlagFU").setValue(true);		
			}else{
				$HUI.checkbox("#GlPSysFlagFU").setValue(false);
			}
			
			$('#form-save-Update').form("load",jsonData);	
			$("#myWinUpdate").show(); 
			var myWinUpdate = $HUI.dialog("#myWinUpdate",{
				iconCls:'icon-w-edit',
				resizable:true,
				title:'修改',
				modal:true,
				buttons:[{
					text:'保存',
					//iconCls:'icon-save',
					id:'save_btn_update',
					handler:function(){
						SaveFunLibUpdate(record.GlPRowId)
					}
				},{
					text:'关闭',
					//iconCls:'icon-cancel',
					handler:function(){
						myWinUpdate.close();
					}
				}]
			});
		});
		
	}
	
	var columns =[[  
				  {field:'GlPRowId',title:'GlPRowId',width:80,sortable:true,hidden:true},
				  {field:'PHEGDesc',title:'药品通用名',width:150,sortable:true},
				  {field:'LGPGenDr',title:'通用名ID',width:150,sortable:true,hidden:true},
				  {field:'PHEFDesc',title:'剂型',width:150,sortable:true},
				  {field:'GlPPointer',title:'剂型ID',width:150,sortable:true,hidden:true},
				  {field:'GlPActiveFlag',title:'是否可用',width:150,sortable:true,align:'center',formatter:ReturnFlagIcon},
				  {field:'GlPSysFlag',title:'是否系统标识',width:150,sortable:true,align:'center',formatter:ReturnFlagIcon}
	 ]];
	 
	 
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCGenLinkPointer",         ///调用Query时
			QueryName:"GetList"
		},
		ClassTableName:'User.DHCGenLinkPointer',
		SQLTableName:'DHC_GenLinkPointer',
		idField:'GlPRowId',
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


 

