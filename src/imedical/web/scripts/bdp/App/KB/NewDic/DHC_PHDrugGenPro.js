/// 名称: 通用名药品属性
/// 描述: 包含增删改查、维护成分功能
/// 编写者: 基础数据平台组-丁亚男
/// 编写日期: 2018-07-23

var init = function(){
	
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrugGenPro&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHDrugGenPro";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrugGenPro&pClassMethod=DeleteData";
	
	//通用名下拉框（添加弹框、隐藏）
	$('#PHGPRGenDrF').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtGeneric&QueryName=GetDataForCmb1&ResultSetType=array&code=DRUG",
		valueField:'PHEGRowId',
		textField:'PHEGDesc'
	});
	
	//通用名查询下拉框
	$('#PHGPRGenDr').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtGeneric&QueryName=GetDataForCmb1&ResultSetType=array&code=DRUG",
		valueField:'PHEGRowId',
		textField:'PHEGDesc'
	});
	//商品名查询下拉框
	$('#PHGPRProDr').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHProName&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'PHNRowId',
		textField:'PHNDesc'
	});
	
	//分类/类型查询下拉框
	$HUI.combotree('#treeCombox',{
		url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCBusMainNew&pClassMethod=GetTreeProComboJson&lib=DRUG",
		panelWidth:255,
		panelHeight:200
		});
	//分类/类型下拉框（添加弹框)
	$HUI.combotree('#PHGPRCatDrF',{
		url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCBusMainNew&pClassMethod=GetTreeProComboJson&lib=DRUG",
		panelWidth:255,
		panelHeight:200
		});
	//ATC编码查询框
	$('#PHGPRAtc').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchFunLib();
		}
		if(event.keyCode == 27) {
		  ClearFunLib();
		}
	    
	});
	
	
	//删除按钮
	$("#btnDel").click(function (e) { 

			Datagrid_DelData('mygrid',DELETE_ACTION_URL);
	 }) 
 

	 //查询方法
	SearchFunLib=function (){
		var gen=$.trim($('#PHGPRGenDr').combobox('getValue'));
		var pro=$.trim($('#PHGPRProDr').combobox('getValue'));
		var atc=$.trim($('#PHGPRAtc').val());
		var cat=$.trim($('#treeCombox').combotree('getValue'));
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.KB.DHCPHDrugGenPro",
			QueryName:"GetList",
			'gen':gen,
			'pro':pro,
			'atc':atc,
			'cat':cat
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	//重置方法
	ClearFunLib=function ()
	{
		$('#PHGPRGenDr').combobox('setValue', '');
		$('#PHGPRProDr').combobox('setValue', '');
		$("#PHGPRAtc").val("");
		$('#treeCombox').combotree('setValue', '');
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.KB.DHCPHDrugGenPro",
			QueryName:"GetList"
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	///添加、修改
	SaveFunLib=function(id)
	{		
		if (($('#PHGPRGenDrF').combobox('getValue')==undefined)||($('#PHGPRGenDrF').combobox('getValue')==""))
		{
			$.messager.alert('错误提示','通用名不能为空，请选择下拉列表里的值!',"error");
			return;
		}
		if (($('#PHGPRCatDrF').combotree('getValue')==undefined)||($('#PHGPRCatDrF').combotree('getValue')==""))
		{
			$.messager.alert('错误提示','分类不能为空，请选择下拉列表里的值!',"error");
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
		if (($('#PHGPRGenDrF').combobox('getValue')==undefined)||($('#PHGPRGenDrF').combobox('getValue')==""))
		{
			$.messager.alert('错误提示','通用名不能为空，请选择下拉列表里的值!',"error");
			return;
		}
		if (($('#PHGPRCatDrF').combotree('getValue')==undefined)||($('#PHGPRCatDrF').combotree('getValue')==""))
		{
			$.messager.alert('错误提示','分类不能为空，请选择下拉列表里的值!',"error");
			return;
		}
		$('#form-save').form('submit', { 
			url: SAVE_ACTION_URL, 
			success: function (data) { 
				  var data=eval('('+data+')'); 
				  if (data.success == 'true') {
				  		$('#form-save').form("clear");
				  		$HUI.checkbox("#PHGPROTCF").setValue(true);
						$HUI.checkbox("#PHGPRSysFlagF").setValue(true);
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
		$('#PHGPRGenDrF').combobox('reload');
		$('#PHGPRCatDrF').combotree('reload');
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
		$HUI.checkbox("#PHGPROTCF").setValue(true);
		$HUI.checkbox("#PHGPRSysFlagF").setValue(true);
	}
	
	//点击修改按钮
	UpdateData=function () 
	{
		$('#PHGPRGenDrF').combobox('reload');
		//$('#PHGPRCatDrF').combotree('reload');
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		$.cm({
			ClassName:"web.DHCBL.KB.DHCPHDrugGenPro",
			MethodName:"NewOpenData",
			id: record.PHGPRRowId      ///rowid
		},function(jsonData){
			if (jsonData.PHGPROTC=="Y"){
				$HUI.checkbox("#PHGPROTCF").setValue(true);		
			}else{
				$HUI.checkbox("#PHGPROTCF").setValue(false);
			}
			if (jsonData.PHGPRSysFlag=="Y"){
				$HUI.checkbox("#PHGPRSysFlagF").setValue(true);		
			}else{
				$HUI.checkbox("#PHGPRSysFlagF").setValue(false);
			}
			$('#form-save').form("load",jsonData);
			$('#PHGPRCatDrF').combotree('reload',"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCBusMainNew&pClassMethod=GetTreeProComboJson&lib=DRUG");
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
						SaveFunLib(record.PHGPRRowId)
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
				  {field:'PHGPRRowId',title:'PHGPRRowId',width:80,sortable:true,hidden:true},
				  {field:'PHEGDesc',title:'通用名',width:150,sortable:true},
				  {field:'PHGPRGenDr',title:'通用名ID',width:150,sortable:true,hidden:true},
				  {field:'PHNDesc',title:'商品名',width:150,sortable:true},
				  {field:'PHNRowId',title:'商品名ID',width:150,sortable:true,hidden:true},
				  {field:'PHGPRAtc',title:'ATC编码',width:150,sortable:true},
				  {field:'PHICDesc',title:'分类',width:150,sortable:true},
				  {field:'PHGPRCatDr',title:'分类ID',width:150,sortable:true,hidden:true},
				  {field:'PHGPROTC',title:'是否处方',width:150,sortable:true,align:'center',formatter:ReturnFlagIcon},
				  {field:'PHGPRSysFlag',title:'是否系统标识',width:150,sortable:true,align:'center',formatter:ReturnFlagIcon}
	 ]];
	 
	 
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCPHDrugGenPro",         ///调用Query时
			QueryName:"GetList"
		},
		ClassTableName:'User.DHCPHDrugGenPro',
		SQLTableName:'DHC_PHDrugGenPro',
		idField:'PHGPRRowId',
		columns: columns,  //列信息
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:PageSizeMain,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		fixRowNumber:true,
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


 

