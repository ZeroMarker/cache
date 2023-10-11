/// 医呼通设备管理（科室级）
/// 基础数据平台-李可凡
/// 2022-08-21
/// table: CT_HCCSEquipLinkContList

var init = function(){
	
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTHCCSEquipReceive&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTHCCSEquipLinkContList";
	
	var CTLOCID = (session&&session['LOGON.CTLOCID'])||"";
	/*********************检索工具条**********************/
	
	$('#TextEQCode').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchFunLib();
		}
		if(event.keyCode == 27) {
		  ClearFunLib();
		}
	});
	$('#TextEQID').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchFunLib();
		}
		if(event.keyCode == 27) {
		  ClearFunLib();
		}
	});
	$('#TextUseMode').combobox({
		 data:[{'value':'','text':'全部'},{'value':'A','text':'全科共用'},{'value':'U','text':'单人专用'}],
		 valueField:'value',
		 textField:'text',
		 panelHeight:'auto',
		 onSelect:function(record){
			SearchFunLib();
		 }
	});
	
	//使用人查询下拉框
	$('#TextUser').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.CTHCCSEquipReceive&QueryName=GetConForCmb&ResultSetType=array&locid="+CTLOCID,
		//mode: 'remote',		//检索取后台
		valueField:'HCCSCLRowId',
		textField:'HCCSCLUserDesc',
		onSelect:function(record){
			SearchFunLib();
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
	
	/*********************弹出窗口下拉框**********************/
	
	//设备下拉表格
	$('#ReceiveEquipDR').combogrid({
		panelWidth:500,
		panelHeight:350,
		mode: 'remote',		//检索取后台
		idField:'ELCLRowId',
		textField:'EQCode',
		url:$URL+"?ClassName=web.DHCBL.CT.CTHCCSEquipReceive&QueryName=GetEquipForCmb&ResultSetType=array",
		columns:[[
			{field:'checked',title:'checked',checkbox:true},
			{field:'ELCLRowId',title:'ELCLRowId',width:100,hidden:true,sortable:true},
			{field:'EQCode',title:'设备编码',width:200,sortable:true},
			{field:'EQId',title:'设备ID',width:200,sortable:true}
		]],
		fitColumns: true,
		//checkOnSelect:true,
		//selectOnCheck:true,
		multiple:true	//下拉框多选
	});
	
	//使用模式下拉框
	$('#ELCLUseMode').combobox({
		data:[{'value':'A','text':'全科共用'},{'value':'U','text':'单人专用'}],
		valueField:'value',
		textField:'text',
		panelHeight:'auto',
		onSelect:function(record){
			if ($('#ELCLUseMode').combobox('getValue')=="A")
			{
				$("#ELCLEquipUserDR").combobox('setValue','');
			}
		 }
	});
	
	//使用人下拉框
	$('#ELCLEquipUserDR').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.CTHCCSEquipReceive&QueryName=GetConForCmb&ResultSetType=array&locid="+CTLOCID,
		//mode: 'remote',		//检索取后台
		valueField:'HCCSCLRowId',
		textField:'HCCSCLUserDesc',
		onSelect:function(record){
			if ($('#ELCLUseMode').combobox('getValue')=="A")
			{
				$.messager.alert('错误提示','只有使用模式为‘单人专用’时，<br/>可选择使用人!',"info");
				//alert("只有使用模式为‘单人专用’时可选择使用人");
				$("#ELCLEquipUserDR").combobox('setValue','');
			}
		 }
	});
	
	/*********************工具条按钮**********************/
	
	//点击接收设备按钮
	$("#btnReceive").click(function(e){
		/*
		$('#ReceiveEquipDR').combogrid({
			panelWidth:500,
			panelHeight:350,
			mode: 'remote',		//检索取后台
			idField:'ELCLRowId',
			textField:'EQCode',
			url:$URL+"?ClassName=web.DHCBL.CT.CTHCCSEquipReceive&QueryName=GetEquipForCmb&ResultSetType=array",
			columns:[[
				{field:'checked',title:'checked',checkbox:true},
				{field:'ELCLRowId',title:'ELCLRowId',width:100,hidden:true,sortable:true},
				{field:'EQCode',title:'设备编码',width:200,sortable:true},
				{field:'EQId',title:'设备ID',width:200,sortable:true}
			]],
			fitColumns: true,
			//checkOnSelect:true,
			//selectOnCheck:true,
			multiple:true	//下拉框多选
		});
		*/
		$("#ReceiveEquipDR").combogrid({url:$URL+"?ClassName=web.DHCBL.CT.CTHCCSEquipReceive&QueryName=GetEquipForCmb&ResultSetType=array&locid="+CTLOCID})
		ReceiveData();
	});
	//点击修改按钮
	$("#btnUpdate").click(function(e){
		UpdateData();
	});
	//点击批量设置共用按钮
	$("#btnShare").click(function(e){
		ShareData();
	});
	//点击归还按钮
	$("#btnReturn").click(function (e) { 
		ReturnData();
	});	
	
	//查询方法
	SearchFunLib=function(){
		var equipcode=$.trim($('#TextEQCode').val());
		var equipid=$.trim($('#TextEQID').val());
		var usemode=$("#TextUseMode").combobox('getValue');
		var user=$("#TextUser").combobox('getValue');
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.CT.CTHCCSEquipReceive",
			QueryName:"GetList",
			'equipcode':equipcode,
			'equipid':equipid,
			'usemode':usemode,
			'user':user,
			'loc':''
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	//重置方法
	ClearFunLib=function()
	{
		$("#TextEQCode").val("");
		$("#TextEQID").val("");
		$("#TextUseMode").combobox('setValue','');
		$("#TextUser").combobox('setValue','');
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.CT.CTHCCSEquipReceive",
			QueryName:"GetList",
			'loc':''
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	
	///接收设备
	ReceiveFunLib=function(id)
	{
		var ReceiveEquipDR=$("#ReceiveEquipDR").combogrid('getValues');
		if ((ReceiveEquipDR=="")||(ReceiveEquipDR=="undefined"))
        {
            $.messager.alert('错误提示', '设备请选择下拉框里的值!', "error");
            return;
        }
		
		//数组转^拼接的字符串
		var ReceiveEquipDRStr="";
		for (var i=0;i<ReceiveEquipDR.length;i++)
		{
			if (ReceiveEquipDRStr==""){
				ReceiveEquipDRStr=ReceiveEquipDRStr+ReceiveEquipDR[i];
			}else{
				ReceiveEquipDRStr=ReceiveEquipDRStr+"^"+ReceiveEquipDR[i];
			}
		}
		//alert(ReceiveEquipDRStr);
		
		$.messager.confirm('提示', "确认要保存数据吗?", function(r){
			if (r){
				var result=tkMakeServerCall("web.DHCBL.CT.CTHCCSEquipReceive","ReceiveAll",ReceiveEquipDRStr);
				if (result != "-1") {
					var message="添加成功！"
					$.messager.popover({msg: message,type:'success',timeout: 1000});
					$('#ReceiveWin').dialog('close');
					$("#mygrid").datagrid("reload");
					$('#mygrid').datagrid('unselectAll');
				}
				else{
					$.messager.alert('操作提示',"添加失败！","error");
				}
			}
		})

	}
	
	///修改方法
	UpdateFunLib=function(id)
	{
		//alert($("#ELCLRowId").val());
		//alert($("#ELCLEquipmentDR").val());
		//alert($('#ELCLUseMode').combobox('getValue'));
		//alert($('#ELCLEquipUserDR').combobox('getValue'));
		//return;
		if ($('#ELCLUseMode').combobox('getValue')=="")
		{
			$.messager.alert('错误提示','使用模式不能为空!',"info");
			return;
		}
		$.messager.confirm('提示', "确认要保存数据吗?", function(r){
			if (r){
				$('#form-save').form('submit', { 
					url: SAVE_ACTION_URL, 
					success: function (data) { 
						  var data=eval('('+data+')'); 
						  if (data.success == 'true') {
								$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
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
		})
	}
	
	
	//点击接收设备按钮
	ReceiveData=function() {
		$("#ReceiveWin").show();
		var ReceiveWin = $HUI.dialog("#ReceiveWin",{
			iconCls:'icon-w-add',
			resizable:true,
			title:'接收设备',
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				text:'保存',
				id:'save_btn',
				handler:function(){
					ReceiveFunLib("")
				}
			},{
				text:'关闭',
				handler:function(){
					ReceiveWin.close();
				}
			}]
		});	
		$('#form-Receive').form("clear");
	}
	
	//点击修改按钮
	UpdateData=function() {
		var record = $("#mygrid").datagrid("getSelections"); 
		if (record.length<1)
		{
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		if (record.length>1)
		{
			$.messager.alert('错误提示','请选择单条数据进行修改!',"info");
			return;
		}
		var record = $("#mygrid").datagrid("getSelected"); 
		var id=record.ELCLRowId
		$.cm({
			ClassName:"web.DHCBL.CT.CTHCCSEquipReceive",
			MethodName:"OpenData",
			id:id
		},function(jsonData){
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
						UpdateFunLib(id)
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
	
	//点击批量设置共用按钮
	ShareData=function() {
		var record = $("#mygrid").datagrid("getSelections"); 
		if (record.length<1)
		{
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		var ShareStr="";
		for (var m=0;m<record.length;m++)
		{
			if  (record[m].ELCLRowId=="")
			{
				continue;
			}
			if (ShareStr=="")
			{
				ShareStr=record[m].ELCLRowId;
			}
			else{
				ShareStr=ShareStr+"^"+record[m].ELCLRowId;
			}
		}
		//alert(ShareStr);
		if (ShareStr!=""){
			$.messager.confirm('提示', "确认要批量设置共用吗?", function(r){
				if (r){
					var result=tkMakeServerCall("web.DHCBL.CT.CTHCCSEquipReceive","ShareAll",ShareStr);
					if (result != "-1") {
						var message="保存成功！"
						$.messager.popover({msg: message,type:'success',timeout: 1000});
						$("#mygrid").datagrid("reload");
						$('#mygrid').datagrid('unselectAll');
					}
					else{
						$.messager.alert('操作提示',"保存失败！","error");
					}
					ShareStr="";	//清空获取的行id
				}
			})
		}
	}
	
	//点击归还按钮
	ReturnData=function() {
		var record = $("#mygrid").datagrid("getSelections"); 
		if (record.length<1)
		{
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		var ReturnStr="";
		for (var m=0;m<record.length;m++)
		{
			if  (record[m].ELCLRowId=="")
			{
				continue;
			}
			if (ReturnStr=="")
			{
				ReturnStr=record[m].ELCLRowId;
			}
			else{
				ReturnStr=ReturnStr+"^"+record[m].ELCLRowId;
			}
		}
		//alert(ReturnStr);
		if (ReturnStr!=""){
			$.messager.confirm('提示', "确认要归还设备吗?", function(r){
				if (r){
					var result=tkMakeServerCall("web.DHCBL.CT.CTHCCSEquipReceive","ReturnAll",ReturnStr);
					if (result != "-1") {
						var message="归还成功！"
						$.messager.popover({msg: message,type:'success',timeout: 1000});
						$("#mygrid").datagrid("reload");
						$('#mygrid').datagrid('unselectAll');
					}
					else{

						$.messager.alert('操作提示',"归还失败！","error");
					}
					ReturnStr="";	//清空获取的行id
				}
			})
		}
	}
	
	//datagrid排序：
	function sort_int(a,b){
		if(a.length >b.length) return 1;
		else if (a.length <b.length) return -1;
		else if (a > b) return 1;
		else return -1;
	}
	//使用模式彩色文字
	function ReturnModeIcon(value){
		if(value=='A')
		{
			return "<font color='#4169e1'>全科共用</font>"
		}else if(value=='U')
		{
			return "<font color='#ee82ee'>单人专用</font>"
		}else
		{
			return "";
		}
	}
	
	var columns =[[
				{field:'ELCLRowId',title:'ELCLRowId',width:80,hidden:true,sortable:true},
				{field:'ELCLAcceptLocationDR',title:'领用科室（隐藏）',width:120,hidden:true,sortable:true},
				{field:'EQCode',title:'设备编码',width:120,sortable:true},
				{field:'EQId',title:'设备ID',width:120,sortable:true},
				{field:'ELCLAcceptTime',title:'设备接收时间',width:120,sortable:true},
				{field:'ELCLAcceptUserDR',title:'设备接收人',width:120,sortable:true},
				{field:'ELCLUseMode',title:'使用模式',width:120,sortable:true,formatter:ReturnModeIcon},
				{field:'ELCLEquipUserDR',title:'使用人',width:120,sortable:true}
				]];
	
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.CT.CTHCCSEquipReceive",
			QueryName:"GetList",
			'locid':CTLOCID    //当前登录科室
		},
		columns: columns,  //列信息
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:PageSizeMain,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:false,
		ClassTableName:'User.CTHCCSEquipLinkContList',
		SQLTableName:'CT_HCCSEquipLinkContList',
		idField:'ELCLRowId', 
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true, //列号 自适应宽度
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