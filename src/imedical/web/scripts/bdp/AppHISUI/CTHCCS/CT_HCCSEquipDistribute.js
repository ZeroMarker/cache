/// 医呼通设备发放（院级）
/// 基础数据平台-李可凡
/// 2022-08-21
/// table: CT_HCCSEquipLinkContList

var init = function(){
	
	//var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTHCCSEquipDistribute&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.AccountDept";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTHCCSEquipDistribute&pClassMethod=AddData";
	
	var HospID=""
	//多院区下拉框
	var hospComp=GenHospComp('CT_HCCSEquipLinkContList');
	hospComp.options().onSelect=function(){
		var HospID=$HUI.combogrid('#_HospList').getValue();
		ClearFunLib();
	}
	
	/*********************检索工具条**********************/
	
	$('#TextLoc').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchFunLib();
		}
		if(event.keyCode == 27) {
		  ClearFunLib();
		}
	});
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
	$('#TextStatus').combobox({
		 data:[{'value':'','text':'全部'},{'value':'Y','text':'启用'},{'value':'N','text':'停用'}],
		 valueField:'value',
		 textField:'text',
		 panelHeight:'auto',
		 onSelect:function(record){
			SearchFunLib();
		 }
	});
	$('#TextStatus').combobox('setValue','Y');
	
	$('#TextIsAccepted').combobox({
		 data:[{'value':'','text':'全部'},{'value':'Y','text':'是'},{'value':'N','text':'否'}],
		 valueField:'value',
		 textField:'text',
		 panelHeight:'auto',
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
	
	//科室下拉框
	$('#ELCLAcceptLocationDR').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.CTHCCSEquipDistribute&QueryName=GetLocForCmb&ResultSetType=array",
		//mode: 'remote',		//检索取后台
		valueField:'LOCRowId',
		textField:'LOCDesc'
	});
	
	//领用人下拉框
	$('#ELCLContactListDR').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.CTHCCSEquipDistribute&QueryName=GetConForCmb&ResultSetType=array",
		//mode: 'remote',		//检索取后台
		valueField:'HCCSCLRowId',
		textField:'HCCSCLUserDesc'
	});
	
	//设备下拉表格
	$('#ELCLEquipmentDR').combogrid({
		panelWidth:500,
		panelHeight:350,
		mode: 'remote',		//检索取后台
		idField:'EQRowId',
		textField:'EQCode',
		url:$URL+"?ClassName=web.DHCBL.CT.CTHCCSEquipDistribute&QueryName=GetEquipForCmb&ResultSetType=array",
		columns:[[
			{field:'checked',title:'checked',checkbox:true},
			{field:'EQRowId',title:'EQRowId',width:100,hidden:true,sortable:true},
			{field:'EQCode',title:'设备编码',width:200,sortable:true},
			{field:'EQId',title:'设备ID',width:200,sortable:true}
		]],
		fitColumns: true,
		//checkOnSelect:true,
		//selectOnCheck:true,
		multiple:true	//下拉框多选
	});
	
	
	/*********************工具条按钮**********************/
	
	//点击添加按钮
	$("#btnAdd").click(function(e){
		AddData();
	});
	//点击停用按钮
	$("#btnEnd").click(function(e){
		EndData();
	});
	//点击删除按钮
	$("#btnDel").click(function (e) { 
		DelData();
	});	
	
	//查询方法
	SearchFunLib=function(){
		var loc=$.trim($("#TextLoc").val());
		var equipcode=$.trim($('#TextEQCode').val());
		var equipid=$.trim($('#TextEQID').val());
		var Status=$("#TextStatus").combobox('getValue');
		var isaccepted=$("#TextIsAccepted").combobox('getValue');
		var HospID=hospComp.getValue();
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.CT.CTHCCSEquipDistribute",
			QueryName:"GetList",
			'loc':loc,
			'equipcode':equipcode,
			'equipid':equipid,
			'status':Status,
			'isaccepted':isaccepted,
			'hospid':HospID
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	//重置方法
	ClearFunLib=function()
	{
		$("#TextLoc").val("");
		$("#TextEQCode").val("");
		$("#TextEQID").val("");
		$("#TextStatus").combobox('setValue','Y');
		$("#TextIsAccepted").combobox('setValue','');
		var HospID=hospComp.getValue();
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.CT.CTHCCSEquipDistribute",
			QueryName:"GetList",
			'status':"Y",
			'hospid':HospID
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	
	///新增
	AddFunLib=function(id)
	{
		var ELCLAcceptLocationDR=$("#ELCLAcceptLocationDR").combobox('getValue');
		var ELCLContactListDR=$("#ELCLContactListDR").combobox('getValue');
		var ELCLEquipmentDR=$("#ELCLEquipmentDR").combogrid('getValues');
		//alert(ELCLAcceptLocationDR);
		//alert(ELCLContactListDR);
		//alert(ELCLEquipmentDR);
		if ((ELCLAcceptLocationDR=="")||(ELCLAcceptLocationDR=="undefined"))
        {
            $.messager.alert('错误提示', '科室请选择下拉框里的值!', "error");
            return;
        }
		if ((ELCLContactListDR=="")||(ELCLContactListDR=="undefined"))
        {
            $.messager.alert('错误提示', '领用人请选择下拉框里的值!', "error");
            return;
        }
		if ((ELCLEquipmentDR=="")||(ELCLEquipmentDR=="undefined"))
        {
            $.messager.alert('错误提示', '设备请选择下拉框里的值!', "error");
            return;
        }
		
		//数组转^拼接的字符串
		var ELCLEquipmentDRStr="";
		for (var i=0;i<ELCLEquipmentDR.length;i++)
		{
			if (ELCLEquipmentDRStr==""){
				ELCLEquipmentDRStr=ELCLEquipmentDRStr+ELCLEquipmentDR[i];
			}else{
				ELCLEquipmentDRStr=ELCLEquipmentDRStr+"^"+ELCLEquipmentDR[i];
			}
		}
		//alert(ELCLEquipmentDRStr);
		
		//校验设备重复
		var ValidateFlag=tkMakeServerCall("web.DHCBL.CT.CTHCCSEquipDistribute","IsValidate",ELCLEquipmentDRStr);
		if (ValidateFlag==1)
		{
			$.messager.alert('错误提示', '所选设备中存在已被领用的设备!', "error");
			return;
		}
		
		$.messager.confirm('提示', "确认要保存数据吗?", function(r){
			if (r){
				var result=tkMakeServerCall("web.DHCBL.CT.CTHCCSEquipDistribute","AddData",ELCLAcceptLocationDR,ELCLContactListDR,ELCLEquipmentDRStr);
				if (result != "-1") {
					var message="添加成功！"
					$.messager.popover({msg: message,type:'success',timeout: 1000});
					$('#myWin').dialog('close');
					$("#mygrid").datagrid("reload");
					$('#mygrid').datagrid('unselectAll');
				}
				else{
					$.messager.alert('操作提示',"添加失败！","error");
				}
			}
		})

	}
	
	//点击新增按钮
	AddData=function() {
		HospID=hospComp.getValue();
		$('#ELCLAcceptLocationDR').combobox('reload',$URL+"?ClassName=web.DHCBL.CT.CTHCCSEquipDistribute&QueryName=GetLocForCmb&ResultSetType=array&hospid="+HospID);
		$('#ELCLContactListDR').combobox('reload',$URL+"?ClassName=web.DHCBL.CT.CTHCCSEquipDistribute&QueryName=GetConForCmb&ResultSetType=array&hospid="+HospID);
		//$('#ELCLEquipmentDR').combogrid('reload',$URL+"?ClassName=web.DHCBL.CT.CTHCCSEquipDistribute&QueryName=GetEquipForCmb&ResultSetType=array&hospid="+HospID);
		$("#ELCLEquipmentDR").combogrid({url:$URL+"?ClassName=web.DHCBL.CT.CTHCCSEquipDistribute&QueryName=GetEquipForCmb&ResultSetType=array&hospid="+HospID})
		
		$("#myWin").show();
		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-w-add',
			resizable:true,
			title:'新增',
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				text:'保存',
				id:'save_btn',
				handler:function(){
					AddFunLib("")
				}
			},{
				text:'关闭',
				handler:function(){
					myWin.close();
				}
			}]
		});	
		$('#form-save').form("clear");
		
	}
	
	//点击停用按钮
	EndData=function() {
		var record = $("#mygrid").datagrid("getSelections"); 
		if (record.length<1)
		{
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		var EndStr="";
		for (var m=0;m<record.length;m++)
		{
			if  (record[m].ELCLRowId=="")
			{
				continue;
			}
			if (EndStr=="")
			{
				EndStr=record[m].ELCLRowId;
			}
			else{
				EndStr=EndStr+"^"+record[m].ELCLRowId;
			}
		}
		//alert(EndStr);
		if (EndStr!=""){
			//停用时，判断设备是否已归还	2023-02-10
			var resultCheck=tkMakeServerCall("web.DHCBL.CT.CTHCCSEquipDistribute","EndAllCheck",EndStr);
			if (resultCheck==1){
				$.messager.alert('操作提示',"无法停用未归还的设备！","error");
				return;
			}
			
			$.messager.confirm('提示', "确认要停用数据吗?", function(r){
				if (r){
					var result=tkMakeServerCall("web.DHCBL.CT.CTHCCSEquipDistribute","EndAll",EndStr);
					if (result != "-1") {
						var message="停用成功！"
						$.messager.popover({msg: message,type:'success',timeout: 1000});
						$("#mygrid").datagrid("reload");
						$('#mygrid').datagrid('unselectAll');
					}
					else{
						$.messager.alert('操作提示',"停用失败！","error");
					}
					EndStr="";	//清空获取的行id
				}
			})
		}
	}
	
	//点击删除按钮
	DelData=function() {
		var record = $("#mygrid").datagrid("getSelections"); 
		if (record.length<1)
		{
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		var DelStr="";
		for (var m=0;m<record.length;m++)
		{
			if  (record[m].ELCLRowId=="")
			{
				continue;
			}
			if (DelStr=="")
			{
				DelStr=record[m].ELCLRowId;
			}
			else{
				DelStr=DelStr+"^"+record[m].ELCLRowId;
			}
		}
		//alert(DelStr);
		if (DelStr!=""){
			$.messager.confirm('提示', "确认要删除数据吗?", function(r){
				if (r){
					var result=tkMakeServerCall("web.DHCBL.CT.CTHCCSEquipDistribute","DeleteAll",DelStr);
					if (result != "-1") {
						var message="删除成功！"
						$.messager.popover({msg: message,type:'success',timeout: 1000});
						$("#mygrid").datagrid("reload");
						$('#mygrid').datagrid('unselectAll');
					}
					else{

						$.messager.alert('操作提示',"删除失败！","error");
					}
					DelStr="";	//清空获取的行id
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
	//启用停用彩色文字
	function ReturnActiveIcon(value){
		if(value=='Y'||value=='1')
		{
			return "<font color='#21ba45'>启用</font>"
		}else if(value=='N'||value=='0')
		{
			return "<font color='#f16e57'>停用</font>"
		}else
		{
			return "";
		}
	}
	
	var columns =[[
				{field:'ELCLRowId',title:'ELCLRowId',width:80,hidden:true,sortable:true},
				{field:'ELCLAcceptLocationCode',title:'科室代码',width:120,sortable:true,},
				{field:'ELCLAcceptLocationDesc',title:'科室名称',width:120,sortable:true},
				{field:'EQCode',title:'设备编码',width:120,sortable:true},
				{field:'EQId',title:'设备ID',width:120,sortable:true},
				{field:'ELCLDeliverTime',title:'发放时间',width:120,sortable:true},
				{field:'ELCLContactListName',title:'科室领用人',width:120,sortable:true},
				{field:'ELCLStatus',title:'状态',width:120,sortable:true,formatter:ReturnActiveIcon},
				{field:'ELCLIsAcceptedByLoc',title:'科室是否接收',width:120,sortable:true,formatter:ReturnFlagIcon}
				]];
	
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.CT.CTHCCSEquipDistribute",
			QueryName:"GetList",
			'status':$("#TextStatus").combobox('getValue'),
			'hospid':hospComp.getValue()    //多院区医院
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
			
        },
        onLoadSuccess:function(data){
	        $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
        	$(this).datagrid('columnMoving'); //列可以拖拽改变顺序
        }
		
	});
	ShowUserHabit('mygrid');
	
};
$(init);