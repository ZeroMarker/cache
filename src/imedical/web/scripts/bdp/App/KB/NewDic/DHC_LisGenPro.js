/// 名称: 通用名检验属性
/// 描述: 包含增删改查、维护成分功能
/// 编写者: 基础数据平台组-丁亚男
/// 编写日期: 2018-07-23

var init = function(){
	
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCLisGenPro&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCLisGenPro";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCLisGenPro&pClassMethod=DeleteData";
	
	//通用名下拉框（添加弹框、隐藏）
	$('#LGPGenDrF').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtGeneric&QueryName=GetDataForCmb1&ResultSetType=array&code=LAB",
		valueField:'PHEGRowId',
		textField:'PHEGDesc'
	});
	
	//通用名查询下拉框
	$('#LGPGenDr').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtGeneric&QueryName=GetDataForCmb1&ResultSetType=array&code=LAB",
		valueField:'PHEGRowId',
		textField:'PHEGDesc'
	});
	
	//分类/类型下拉框（添加弹框)
	$HUI.combotree('#LGPCatDrF',{
		url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCBusMainNew&pClassMethod=GetTreeProComboJson&lib=LAB",
		panelWidth:255,
		panelHeight:200
		});
	//标准码查询框
	$('#LGPStCode').keyup(function(event){
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
		var gen=$.trim($('#LGPGenDr').combobox('getValue'));
		var code=$.trim($('#LGPStCode').val());
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.KB.DHCLisGenPro",
			QueryName:"GetList",
			'gen':gen,
			'code':code
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	//重置方法
	ClearFunLib=function ()
	{
		$('#LGPGenDr').combobox('setValue', '');
		$("#LGPStCode").val("");
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.KB.DHCLisGenPro",
			QueryName:"GetList"
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	///添加、修改
	SaveFunLib=function(id)
	{		
		if (($('#LGPGenDrF').combobox('getValue')==undefined)||($('#LGPGenDrF').combobox('getValue')==""))
		{
			$.messager.alert('错误提示','通用名不能为空，请选择下拉列表里的值!',"error");
			return;
		}
		var validateRadio=$("input[name='LGPOTFlag']:checked").val();
		if(validateRadio==undefined)
		{
			$("input[name='LGPOTFlag'][value='TS']").prop("checked",true)
		}
		/*if (validateRadio=="TC")
		{
			if ($.trim($("#LGPStCodeF").val())=="")
			{
				$.messager.alert('错误提示','标准码不能为空!',"error");
				return;
			}
		}*/
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
		if (($('#LGPGenDrF').combobox('getValue')==undefined)||($('#LGPGenDrF').combobox('getValue')==""))
		{
			$.messager.alert('错误提示','通用名不能为空，请选择下拉列表里的值!',"error");
			return;
		}
		/*if ($.trim($("#LGPStCodeF").val())=="")
		{
			$.messager.alert('错误提示','标准码不能为空!',"error");
			return;
		}*/
		var validateRadio=$("input[name='LGPOTFlag']:checked").val();
		if(validateRadio==undefined)
		{
			$("input[name='LGPOTFlag'][value='TS']").prop("checked",true)
		}
		$('#form-save').form('submit', { 
			url: SAVE_ACTION_URL, 
			success: function (data) { 
				  var data=eval('('+data+')'); 
				  if (data.success == 'true') {
				  		$('#form-save').form("clear");
				  		$HUI.checkbox("#LGPSysFlagF").setValue(true);
				  		$HUI.radio("#FlagTS").setValue(true);
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
		$('#LGPGenDrF').combobox('reload');
		$('#LGPCatDrF').combotree('reload');
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
		$HUI.checkbox("#LGPSysFlagF").setValue(true);
		$HUI.radio("#FlagTS").setValue(true);
	}
	
	//点击修改按钮
	UpdateData=function () 
	{
		$('#LGPGenDrF').combobox('reload');
		$('#LGPCatDrF').combotree('reload');
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		$.cm({
			ClassName:"web.DHCBL.KB.DHCLisGenPro",
			MethodName:"NewOpenData",
			id: record.LGPRowId      ///rowid
		},function(jsonData){
			if (jsonData.LGPSysFlag=="Y"){
				$HUI.checkbox("#LGPSysFlagF").setValue(true);		
			}else{
				$HUI.checkbox("#LGPSysFlagF").setValue(false);
			}
			var check = jsonData.LGPOTFlag; 
			$HUI.radio("#Flag"+check).setValue(true)
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
						SaveFunLib(record.LGPRowId)
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
		var rowid=row.LGPRowId;
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
			if (r){
				$.ajax({
					url:DELETE_ACTION_URL,  
					data:{"id":rowid},  
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
				  {field:'LGPRowId',title:'LGPRowId',width:80,sortable:true,hidden:true},
				  {field:'PHEGDesc',title:'通用名',width:150,sortable:true},
				  {field:'LGPGenDr',title:'通用名ID',width:150,sortable:true,hidden:true},
				  {field:'LGPStCode',title:'标准码',width:150,sortable:true},
				  {field:'PHICDesc',title:'分类',width:150,sortable:true},
				  {field:'LGPCatDr',title:'分类ID',width:150,sortable:true,hidden:true},
				  {field:'LGPOTFlag',title:'医嘱类型标识',width:150,sortable:true,
					  formatter:function(v,row,index){  
							if(v=='TS'){return '检验套';}
							if(v=='TC'){return '检验项';}
						}},
				  {field:'LGPSysFlag',title:'是否系统标识',width:150,sortable:true,align:'center',formatter:ReturnFlagIcon}
	 ]];
	 
	 
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCLisGenPro",         ///调用Query时
			QueryName:"GetList"
		},
		ClassTableName:'User.DHCLisGenPro',
		SQLTableName:'DHC_LisGenPro',
		idField:'LGPRowId',
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


 

