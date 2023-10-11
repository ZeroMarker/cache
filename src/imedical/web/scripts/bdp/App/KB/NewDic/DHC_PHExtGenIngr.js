﻿/// 名称: 药品通用名成分明细表
/// 描述: 包含增删改查、维护成分功能
/// 编写者: 基础数据平台组-丁亚男
/// 编写日期: 2018-07-20
var init = function(){
	
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtGenIngr&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHExtGenIngr";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtGenIngr&pClassMethod=DeleteData";
	
	//通用名下拉框（添加弹框）
	$('#PHEGIPHEGDrF').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtGeneric&QueryName=GetDataForCmb1&ResultSetType=array&code=DRUG",
		valueField:'PHEGRowId',
		textField:'PHEGDesc'
	});
	//通用名查询下拉框
	$('#PHEGIPHEGDr').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtGeneric&QueryName=GetDataForCmb1&ResultSetType=array&code=DRUG",
		valueField:'PHEGRowId',
		textField:'PHEGDesc'
	});
	//成分下拉框（添加弹框)
	$HUI.combotree('#PHEGIIngrDrF',{
		url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtIngr&pClassMethod=GetNewTreeComboJson"
		});
	//主要成分标识
	$HUI.combobox("#PHEGILevelF",{
		valueField:'id',
		textField:'text',
		data:[
			{id:'1',text:'一级'},
			{id:'2',text:'二级'},
			{id:'3',text:'三级'}			
		]

	});
	
	//删除按钮
	$("#btnDel").click(function (e) { 

			Datagrid_DelData('mygrid',DELETE_ACTION_URL);
	 }) 
	 //查询方法
	SearchFunLib=function (){
		var gen=$.trim($('#PHEGIPHEGDr').combobox('getValue'));
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.KB.DHCPHExtGenIngr",
			QueryName:"GetList",
			'gen':gen
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	//重置方法
	ClearFunLib=function ()
	{
		$('#PHEGIPHEGDr').combobox('setValue', '');
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.KB.DHCPHExtGenIngr",
			QueryName:"GetList"
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	///添加、修改
	SaveFunLib=function(id)
	{		
		if (($('#PHEGIPHEGDrF').combobox('getValue')==undefined) || ($('#PHEGIPHEGDrF').combobox('getText')==""))
		{
			$.messager.alert('错误提示','通用名不能为空!',"error");
			return;
		}
		if ($('#PHEGIIngrDrF').combotree('getValue')==undefined || ($('#PHEGIIngrDrF').combobox('getText')==""))
		{
			$.messager.alert('错误提示','成分不能为空!',"error");
			return;
		}
		if (($('#PHEGILevelF').combobox('getValue')==undefined) || ($('#PHEGILevelF').combobox('getText')==""))
		{
			$.messager.alert('错误提示','主要成分标识不能为空!',"error");
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
		if (($('#PHEGIPHEGDrF').combobox('getValue')==undefined) || ($('#PHEGIPHEGDrF').combobox('getText')==""))
		{
			$.messager.alert('错误提示','通用名不能为空!',"error");
			return;
		}
		if ($('#PHEGIIngrDrF').combotree('getValue')==undefined || ($('#PHEGIIngrDrF').combobox('getText')==""))
		{
			$.messager.alert('错误提示','成分不能为空!',"error");
			return;
		}
		if (($('#PHEGILevelF').combobox('getValue')==undefined) || ($('#PHEGILevelF').combobox('getText')==""))
		{
			$.messager.alert('错误提示','主要成分标识不能为空!',"error");
			return;
		}
		$('#form-save').form('submit', { 
			url: SAVE_ACTION_URL, 
			success: function (data) { 
				  var data=eval('('+data+')'); 
				  if (data.success == 'true') {
				  		$('#form-save').form("clear");
						$HUI.checkbox("#PHEGISysFlagF").setValue(true);
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
		$('#PHEGIPHEGDrF').combobox('reload');
		$('#PHEGIIngrDrF').combotree('reload');
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
		$HUI.checkbox("#PHEGISysFlagF").setValue(true);
	}
	
	//点击修改按钮
	UpdateData=function () 
	{
		$('#PHEGIPHEGDrF').combobox('reload');
		$('#PHEGIIngrDrF').combotree('reload');
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		$.cm({
			ClassName:"web.DHCBL.KB.DHCPHExtGenIngr",
			MethodName:"NewOpenData",
			id: record.PHEGIRowId      ///rowid
		},function(jsonData){
			if (jsonData.PHEGISysFlag=="Y"){
				$HUI.checkbox("#PHEGISysFlagF").setValue(true);		
			}else{
				$HUI.checkbox("#PHEGISysFlagF").setValue(false);
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
						SaveFunLib(record.PHEGAlRowId)
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
				  {field:'PHEGIRowId',title:'PHEGIRowId',width:80,sortable:true,hidden:true},
				  {field:'PHEGDesc',title:'通用名',width:150,sortable:true},
				  {field:'PHEGIPHEGDr',title:'通用名ID',width:150,sortable:true,hidden:true},
				  {field:'PHEINGDesc',title:'成分',width:150,sortable:true},
				   {field:'PHEGIIngrDr',title:'成分ID',width:150,sortable:true,hidden:true},
				  {field:'PHEGILevel',title:'主要成分标识',width:150,sortable:true,
					  formatter:function(v,row,index){  
							if(v=='1'){return '一级';}
							if(v=='2'){return '二级';}
							if(v=='3'){return '三级';}
						}},
				  {field:'PHEGISysFlag',title:'是否系统标识',width:150,sortable:true,align:'center',formatter:ReturnFlagIcon}
	 ]];
	 
	 
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCPHExtGenIngr",         ///调用Query时
			QueryName:"GetList"
		},
		ClassTableName:'User.DHCPHExtGenIngr',
		SQLTableName:'DHC_PHExtGenIngr',
		idField:'PHEGIRowId',
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


 

