/// 名称: 通用名字典
/// 描述: 包含增删改查、维护成分功能
/// 编写者: 基础数据平台组-丁亚男
/// 编写日期: 2018-7-18
var init = function(){
	
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtGeneric&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHExtGeneric";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtGeneric&pClassMethod=DeleteData";

	//别名维护
	AliasData = function() {
			var record = $("#mygrid").datagrid("getSelected"); 
			if (!(record)) {
				$.messager.alert('提示','请选择一行进行维护!',"warning");
				return;
			} else {
				var itemdesc=record.PHEGDesc
				var itemRowId=record.PHEGRowId
				$("#myWinAlias").show();  
				var url="dhc.bdp.kb.dhcphextgenericalias.csp?selectrow="+itemRowId+"&selectrowDesc="+itemdesc
		 	    //token改造 GXP 20230209
				if('undefined'!==typeof websys_getMWToken)
				{
					url+="&MWToken="+websys_getMWToken()
				}
				var myWinGuideImage = $HUI.window("#myWinAlias",{
					resizable:true,
					collapsible:false,
					minimizable:false,
					iconCls:'icon-textbook',
					title:"别名维护-"+itemdesc,
					modal:true,
					content:'<iframe frameborder="0" src="'+url+'" width="100%" height="99%" ></iframe>'
				});	
			}
					
	}
	//药品属性
	ProData= function() {
			var record = $("#mygrid").datagrid("getSelected"); 
			if (!(record)) {
				$.messager.alert('提示','请选择一行进行维护!',"warning");
				return;
			} else {
				var itemdesc=record.PHEGDesc
				var itemRowId=record.PHEGRowId
				$("#myWinAlias").show();  
				var url="dhc.bdp.kb.dhcphextgenericpro.csp?selectrow="+itemRowId+"&selectrowDesc="+itemdesc
		 	    //token改造 GXP 20230209
				if('undefined'!==typeof websys_getMWToken)
				{
					url+="&MWToken="+websys_getMWToken()
				}
				var myWinGuideImage = $HUI.window("#myWinAlias",{
					resizable:true,
					collapsible:false,
					minimizable:false,
					iconCls:'icon-textbook',
					title:"药品属性-"+itemdesc,
					modal:true,
					content:'<iframe  frameborder="0" src="'+url+'" width="100%" height="99%" ></iframe>'
				});	
			}
					
	}
	//检验属性
	LProData= function() {
			var record = $("#mygrid").datagrid("getSelected"); 
			if (!(record)) {
				$.messager.alert('提示','请选择一行进行维护!',"warning");
				return;
			} else {
				var itemdesc=record.PHEGDesc
				var itemRowId=record.PHEGRowId
				$("#myWinAlias").show(); 
				var url="dhc.bdp.kb.dhcphextgenericlpro.csp?selectrow="+itemRowId+"&selectrowDesc="+itemdesc
		 	    //token改造 GXP 20230209
				if('undefined'!==typeof websys_getMWToken)
				{
					url+="&MWToken="+websys_getMWToken()
				}
				var myWinGuideImage = $HUI.window("#myWinAlias",{
					resizable:true,
					collapsible:false,
					minimizable:false,
					iconCls:'icon-textbook',
					title:"检验属性-"+itemdesc,
					modal:true,
					content:'<iframe  frameborder="0" src="'+url+'" width="100%" height="99%" ></iframe>'
				});	
			}
					
	}
	//关联剂型
	LinkData= function() {
			var record = $("#mygrid").datagrid("getSelected"); 
			if (!(record)) {
				$.messager.alert('提示','请选择一行进行维护!',"warning");
				return;
			} else {
				var itemdesc=record.PHEGDesc
				var itemRowId=record.PHEGRowId
				$("#myWinAlias").show();  
				var url="dhc.bdp.kb.dhcphextgenericlink.csp?selectrow="+itemRowId+"&selectrowDesc="+itemdesc
		 	    //token改造 GXP 20230209
				if('undefined'!==typeof websys_getMWToken)
				{
					url+="&MWToken="+websys_getMWToken()
				}
				var myWinGuideImage = $HUI.window("#myWinAlias",{
					resizable:true,
					collapsible:false,
					minimizable:false,
					iconCls:'icon-textbook',
					title:"关联剂型-"+itemdesc,
					modal:true,
					content:'<iframe  frameborder="0" src="'+url+'" width="100%" height="99%" ></iframe>'
				});	
			}
					
	}
	//关联标本
	LisData= function() {
			var record = $("#mygrid").datagrid("getSelected"); 
			if (!(record)) {
				$.messager.alert('提示','请选择一行进行维护!',"warning");
				return;
			} else {
				var itemdesc=record.PHEGDesc
				var itemRowId=record.PHEGRowId
				$("#myWinAlias").show();  
				var url="dhc.bdp.kb.dhcphextgenericlis.csp?selectrow="+itemRowId+"&selectrowDesc="+itemdesc
		 	    //token改造 GXP 20230209
				if('undefined'!==typeof websys_getMWToken)
				{
					url+="&MWToken="+websys_getMWToken()
				}
				var myWinGuideImage = $HUI.window("#myWinAlias",{
					resizable:true,
					collapsible:false,
					minimizable:false,
					iconCls:'icon-textbook',
					title:"关联标本-"+itemdesc,
					modal:true,
					content:'<iframe  frameborder="0" src="'+url+'" width="100%" height="99%" ></iframe>'
				});	
			}
					
	}
	//关联部位
	PartData= function() {
			var record = $("#mygrid").datagrid("getSelected"); 
			if (!(record)) {
				$.messager.alert('提示','请选择一行进行维护!',"warning");
				return;
			} else {
				var itemdesc=record.PHEGDesc
				var itemRowId=record.PHEGRowId
				var lib=record.PHLICode
				$("#myWinAlias").show();  
				var url="dhc.bdp.kb.dhcphextgenericpart.csp?selectrow="+itemRowId+"&lib="+lib+"&selectrowDesc="+itemdesc
		 	    //token改造 GXP 20230209
				if('undefined'!==typeof websys_getMWToken)
				{
					url+="&MWToken="+websys_getMWToken()
				}
				var myWinGuideImage = $HUI.window("#myWinAlias",{
					resizable:true,
					collapsible:false,
					minimizable:false,
					iconCls:'icon-textbook',
					title:"关联部位-"+itemdesc,
					modal:true,
					content:'<iframe  frameborder="0" src="'+url+'" width="100%" height="99%" ></iframe>'
				});	
			}
					
	}
	//成分明细
	IngrData= function() {
			var record = $("#mygrid").datagrid("getSelected"); 
			if (!(record)) {
				$.messager.alert('提示','请选择一行进行维护!',"warning");
				return;
			} else {
				var itemdesc=record.PHEGDesc
				var itemRowId=record.PHEGRowId
				$("#myWinAlias").show();  
				var url="dhc.bdp.kb.dhcphextgenericingr.csp?selectrow="+itemRowId+"&selectrowDesc="+itemdesc
		 	    //token改造 GXP 20230209
				if('undefined'!==typeof websys_getMWToken)
				{
					url+="&MWToken="+websys_getMWToken()
				}
				var myWinGuideImage = $HUI.window("#myWinAlias",{
					resizable:true,
					collapsible:false,
					minimizable:false,
					iconCls:'icon-textbook',
					title:"成分明细-"+itemdesc,
					modal:true,
					content:'<iframe  frameborder="0" src="'+url+'" width="100%" height="99%" ></iframe>'
				});	
			}
					
	}
	//标本采集注意事项
	CareData= function() {
			var record = $("#mygrid").datagrid("getSelected"); 
			if (!(record)) {
				$.messager.alert('提示','请选择一行进行维护!',"warning");
				return;
			} else {
				var itemdesc=record.PHEGDesc
				var itemRowId=record.PHEGRowId
				$("#myWinAlias").show();  
				var url="dhc.bdp.kb.dhcphextgenericcare.csp?selectrow="+itemRowId+"&selectrowDesc="+itemdesc
		 	    //token改造 GXP 20230209
				if('undefined'!==typeof websys_getMWToken)
				{
					url+="&MWToken="+websys_getMWToken()
				}
				var myWinGuideImage = $HUI.window("#myWinAlias",{
					resizable:true,
					collapsible:false,
					minimizable:false,
					iconCls:'icon-textbook',
					title:"标本采集注意事项-"+itemdesc,
					modal:true,
					content:'<iframe  frameborder="0" src="'+url+'" width="100%" height="99%" ></iframe>'
				});	
			}
					
	}
	//知识库标识查询下拉框
	$('#PHEGLibDr').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHLibaryLabel&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'PHLIRowId',
		textField:'PHLIDesc'
	});
	
	//知识库标识下拉框
	$('#PHEGLibDrF').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHLibaryLabel&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'PHLIRowId',
		textField:'PHLIDesc'
	});
	
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
	$('#PHEGLibDr').keyup(function(event){
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
		var lib=$.trim($('#PHEGLibDr').combobox('getValue'));
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.KB.DHCPHExtGeneric",
			QueryName:"GetList",
			'code':code,	
			'desc':desc,
			'lib' :lib
		});
		$('#mygrid').datagrid('unselectAll');
		$('#btnPro').linkbutton('enable');
 		$('#btnLink').linkbutton('enable');
 		$('#btnIngr').linkbutton('enable');
 		$('#btnLPro').linkbutton('enable');
		$('#btnLis').linkbutton('enable');
		$('#btnCare').linkbutton('enable');
		$('#btnPart').linkbutton('enable');
 		
	}
	
	//重置方法
	ClearFunLib=function ()
	{
		$("#TextCode").val("");
		$("#TextDesc").val("");
		$('#PHEGLibDr').combobox('setValue', '');
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.KB.DHCPHExtGeneric",
			QueryName:"GetList"
		});
		$('#mygrid').datagrid('unselectAll');
		$('#btnPro').linkbutton('enable');
 		$('#btnLink').linkbutton('enable');
 		$('#btnIngr').linkbutton('enable');
 		$('#btnLPro').linkbutton('enable');
		$('#btnLis').linkbutton('enable');
		$('#btnCare').linkbutton('enable');
		$('#btnPart').linkbutton('enable');
	}
	
	///添加、修改
	SaveFunLib=function(id)
	{		
		if ($.trim($("#PHEGCodeF").val())=="")
		{
			$.messager.alert('错误提示','代码不能为空!',"error");
			return;
		}
		if ($.trim($("#PHEGDescF").val())=="")
		{
			$.messager.alert('错误提示','描述不能为空!',"error");
			return;
		}
			
		if (($('#PHEGLibDrF').combobox('getValue')==undefined) || ($('#PHEGLibDrF').combobox('getValue')==""))
		{
			$.messager.alert('错误提示','知识库标识不能为空，请选择下拉列表里的值!',"error");
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
		if ($.trim($("#PHEGCodeF").val())=="")
		{
			$.messager.alert('错误提示','代码不能为空!',"error");
			return;
		}
		if ($.trim($("#PHEGDescF").val())=="")
		{
			$.messager.alert('错误提示','描述不能为空!',"error");
			return;
		}
			
		if (($('#PHEGLibDrF').combobox('getValue')==undefined) ||  ($('#PHEGLibDrF').combobox('getValue')==""))
		{
			$.messager.alert('错误提示','知识库标识不能为空，请选择下拉列表里的值!',"error");
			return;
		}
		$('#form-save').form('submit', { 
			url: SAVE_ACTION_URL, 
			success: function (data) { 
				  var data=eval('('+data+')'); 
				  if (data.success == 'true') {
				  		$('#form-save').form("clear");
				  		$HUI.checkbox("#PHEGActiveFlagF").setValue(true);
						$HUI.checkbox("#PHEGSysFlagF").setValue(true);
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
		$('#PHEGLibDrF').combobox('reload');
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
		$HUI.checkbox("#PHEGActiveFlagF").setValue(true);
		$HUI.checkbox("#PHEGSysFlagF").setValue(true);
		//如勾选框默认不选择，需要去掉checked样式 ，如果默认勾选则不用加。2018-06-12
		//$('#ARCICRestrictedOrder').parent().removeClass("checked");
	}
	
	//点击修改按钮
	UpdateData=function () 
	{
		$('#PHEGLibDrF').combobox('reload');
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		$.cm({
			ClassName:"web.DHCBL.KB.DHCPHExtGeneric",
			MethodName:"NewOpenData",
			id: record.PHEGRowId      ///rowid
		},function(jsonData){
			if (jsonData.PHEGActiveFlag=="Y"){
				$HUI.checkbox("#PHEGActiveFlagF").setValue(true);		
			}else{
				$HUI.checkbox("#PHEGActiveFlagF").setValue(false);
			}
			if (jsonData.PHEGSysFlag=="Y"){
				$HUI.checkbox("#PHEGSysFlagF").setValue(true);		
			}else{
				$HUI.checkbox("#PHEGSysFlagF").setValue(false);
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
						SaveFunLib(record.PHEGRowId)
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
		var rowid=row.PHEGRowId;
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
			if (r){
				$.ajax({
					url:DELETE_ACTION_URL,  
					data:{"id":rowid},  
					type:"POST",   
					//dataType:"TEXT",  
					success: function(data)
					{
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
						else 
						{ 
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
				  {field:'PHEGRowId',title:'PHEGRowId',width:80,sortable:true,hidden:true},
				  {field:'PHEGCode',title:'代码',width:150,sortable:true},
				  {field:'PHEGDesc',title:'描述',width:150,sortable:true},
				  {field:'PHLICode',title:'知识库标识代码',width:150,sortable:true,hidden:true},
				  {field:'PHLIDesc',title:'知识库标识',width:150,sortable:true},
				  {field:'PHEGLibDr',title:'知识库标识ID',width:150,sortable:true,hidden:true},
				  {field:'PHICStr',title:'药品分类',width:150,sortable:true},
				  {field:'PHEINGStr',title:'成分分类',width:150,sortable:true},
				  {field:'PHEGActiveFlag',title:'是否可用',width:150,sortable:true,align:'center',formatter:ReturnFlagIcon},
				  {field:'PHEGSysFlag',title:'是否系统标识',width:150,sortable:true,align:'center',formatter:ReturnFlagIcon},
				  {field:'PHEGDataPool',title:'数据池标识',width:80,sortable:true,align:'center',formatter:ReturnFlagIcon }
	 ]];
	 
	 
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCPHExtGeneric",         ///调用Query时
			QueryName:"GetList"
		},
		ClassTableName:'User.DHCPHExtGeneric',
		SQLTableName:'DHC_PHExtGeneric',
		idField:'PHEGRowID',
		columns: columns,  //列信息
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:PageSizeMain,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true,
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort:false,  //定义是否从服务器排序数据。true
		/*toolbar:[{
			iconCls:'icon-add',
			text:'添加',
			id:'add_btn',
			handler:AddData
		},{
			iconCls:'icon-write-order',
			text:'修改',
			id:'update_btn',
			handler:UpdateData
		},{
			iconCls:'icon-cancel',
			text:'删除',
			id:'del_btn',
			handler:function()
			{
				Datagrid_DelData('mygrid',DELETE_ACTION_URL)
			}
		},{
			iconCls:'icon-read-card',
			text:'别名维护',
			id:'btnAlias',
			handler:AliasData
		},{
			iconCls:'icon-read-card',
			text:'药品属性',
			id:'btnPro',
			handler:ProData
		},{
			iconCls:'icon-read-card',
			text:'检验属性',
			id:'btnLPro',
			handler:LProData
		},{
			iconCls:'icon-read-card',
			text:'关联剂型',
			id:'btnLink',
			handler:LinkData
		},{
			iconCls:'icon-read-card',
			text:'关联标本',
			id:'btnLis',
			handler:LisData
		},{
			iconCls:'icon-read-card',
			text:'关联部位',
			id:'btnPart',
			handler:PartData
		},{
			iconCls:'icon-read-card',
			text:'成分明细',
			id:'btnIngr',
			handler:IngrData
		},{
			iconCls:'icon-read-card',
			text:'标本采集注意事项',
			id:'btnCare',
			handler:CareData
		}],*/
		onDblClickRow:function(rowIndex,rowData){
        	UpdateData();
        },
        onClickRow:function(rowIndex,rowData){
        	var code =rowData.PHLICode
        	if(code!="DRUG"){
		 		$('#btnPro').linkbutton('disable');
		 		$('#btnLink').linkbutton('disable');
		 		$('#btnIngr').linkbutton('disable');
		 		
		 	}else{
		 		$('#btnPro').linkbutton('enable');
		 		$('#btnLink').linkbutton('enable');
		 		$('#btnIngr').linkbutton('enable');
		 	}
		 	if(code!="LAB"){
		 		$('#btnLPro').linkbutton('disable');
		 		$('#btnLis').linkbutton('disable');
		 	}else{
		 		$('#btnLPro').linkbutton('enable');
		 		$('#btnLis').linkbutton('enable');
		 	}
		 	if(code!="SPEC"){
		 		$('#btnCare').linkbutton('disable');
		 	}else{
		 		$('#btnCare').linkbutton('enable');
		 	}
		 	if((code!="ELECT")&&(code!="ULTR")&&(code!="RADI")&&(code!="ENDO")&&(code!="CHECK")&&(code!="OPERATION")&&(code!="TREAT")){
		 		$('#btnPart').linkbutton('disable');
		 	}else{
		 		$('#btnPart').linkbutton('enable');
		 	}
        },
        onLoadSuccess:function(data){
	        $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
        	$(this).datagrid('columnMoving'); //列可以拖拽改变顺序
        }
	});
	ShowUserHabit('mygrid');
	
};
$(init);
