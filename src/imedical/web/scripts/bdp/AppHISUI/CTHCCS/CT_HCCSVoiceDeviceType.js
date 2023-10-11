//Creator:丁亚男
//CreatDate:2021-01-25
//Description:语音备忘类型
var GV={}  ;//存放全局变量
var init = function(){
	
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.HCCSVoiceDeviceType&pClassMethod=DeleteData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.HCCSVoiceDeviceType&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTHCCSVoiceDeviceType";
	
	var HospID=""
	//多院区下拉框
	var hospComp=GenHospComp('CT_HCCSVoiceDeviceType');
	GV.getSelectHospId=function(){
		return $("#_HospList").combogrid('getValue');
	}
	GV.selectHospId=GV.getSelectHospId();
	hospComp.options().onSelect=function(){
		var HospID=$HUI.combogrid('#_HospList').getValue();
		ClearFunLib();
	}
	/*
	//多院区下拉框
	var hospComp = GenHospComp("CT_HCCSVoiceDeviceType");
	//医院下拉框选中事件
	hospComp.jdata.options.onSelect = function(e){
		var HospID=$HUI.combogrid('#_HospList').getValue();
		ClearFunLib();
	}
	*/
	//应用类型下拉框
	$("#VDTType").combobox({
		valueField: 'id',
		textField: 'text',
		data: [{id: "NURSE",text: '护士' }, 
				{id: "DOCTOR", text: '医生'}]
	});
	//代码查询、重置
	$('#TextCode').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchFunLib();
		}
		if(event.keyCode == 27) {
		  ClearFunLib();
		}
	    
	});
	//描述查询、重置
	$('#TextDesc').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchFunLib();
		}
		if(event.keyCode == 27) {
		  ClearFunLib();
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
	 
	 //查询方法
	SearchFunLib=function(){
		var code=$.trim($("#TextCode").val());
		var desc=$.trim($('#TextDesc').val()); 
		var HospID=hospComp.getValue();
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.CT.HCCSVoiceDeviceType",
			QueryName:"GetList",	
			'code':code,	
			'desc':desc,
			'hospid':HospID
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	//重置方法
	ClearFunLib=function()
	{
		$("#TextCode").val("");
		$("#TextDesc").val("");
		var HospID=hospComp.getValue();
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.CT.HCCSVoiceDeviceType",
			QueryName:"GetList",
			'hospid':HospID
		});
		$('#mygrid').datagrid('unselectAll');

	}
	
	 ///新增、修改
	SaveFunLib=function(id)
	{			
		if ($.trim($("#VDTCode").val())=="")
		{
			$.messager.alert('错误提示','代码不能为空!',"info");
			return;
		}
		if ($.trim($("#VDTDesc").val())=="")
		{
			$.messager.alert('错误提示','描述不能为空!',"info");
			return;
		}
		var flag= tkMakeServerCall("web.DHCBL.CT.HCCSVoiceDeviceType","FormValidate",$.trim($("#VDTRowId").val()),$.trim($("#VDTCode").val()),$.trim($("#VDTDesc").val()),hospComp.getValue());
		if (flag==1)
		{
			$.messager.alert('错误提示','该纪录已经存在!',"info");
			return;
		}
		$.messager.confirm('提示', "确认要保存数据吗?", function(r){
			if (r){
				$('#form-save').form('submit', { 
					url: SAVE_ACTION_URL,
					onSubmit: function(param){
							param.LinkHospId = hospComp.getValue()
						},
					success: function (data) { 
						  var data=eval('('+data+')'); 
						  if (data.success == 'true') {
								$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
								if (id!="")
								{
									$('#mygrid').datagrid('reload');  // 重新载入当前页面数据
									$('#mygrid').datagrid('unselectAll');									
								}
								else{
									
									 $.cm({
										ClassName:"web.DHCBL.CT.HCCSVoiceDeviceType",
										QueryName:"GetList",
										rowid: data.id   
									},function(jsonData){
										$('#mygrid').datagrid('insertRow',{
											index:0,
											row:jsonData.rows[0]
										})
									})
									$('#mygrid').datagrid('unselectAll');
								}
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
	
	
	 //点击新增按钮
	 AddData=function() {
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
					SaveFunLib("")
				}
			},{
				text:'关闭',
				handler:function(){
					myWin.close();
				}
			}]
		});
		$("#save_btn").removeClass("l-btn l-btn-small").addClass("l-btn l-btn-small green");
		$('#form-save').form("clear");
		$HUI.checkbox("#VDTActiveFlag").setValue(true);		//新增-有效标识默认勾选
	}
	
	//点击修改按钮
	UpdateData=function() {
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		var id=record.VDTRowId
		$.cm({
			ClassName:"web.DHCBL.CT.HCCSVoiceDeviceType",
			MethodName:"OpenData",
			id:id
		},function(jsonData){
			if (jsonData.VDTActiveFlag=="Y")   //有效标识
			{
				$HUI.checkbox("#VDTActiveFlag").setValue(true);	  
			}else{
				$HUI.checkbox("#VDTActiveFlag").setValue(false);
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
					id:'save_btn',
					handler:function(){
						SaveFunLib(id)
					}
				},{
					text:'关闭',
					handler:function(){
						myWin.close();
					}
				}]
			});	
			$("#save_btn").removeClass("l-btn l-btn-small").addClass("l-btn l-btn-small green");	
		});
	}

	

	///删除
	DelData=function()
	{                  
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
			if (r){	
				$.ajax({
					url:DELETE_ACTION_URL,  
					data:{
						"id":record.VDTRowId      //rowid
					},  
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
				  {field:'VDTRowId',title:'VDTRowId',width:80,hidden:true,sortable:true},
				  {field:'VDTCode',title:'代码',width:100,sortable:true},
				  {field:'VDTDesc',title:'描述',width:100,sortable:true},
				  {field:'VDTType',title:'应用类型',width:100,sortable:true,
				  formatter: function(value, row, index) {
					  if (value == "NURSE") {
						  return "护士";
					  }
					  if (value == "DOCTOR") {
						  return "医生";
					  }
					  if (value == "") {
						  return "";
					  }
				  }},
				  {field:'VDTRemarks',title:'备注',width:100,sortable:true},
				  {field:'VDTActiveFlag',title:'是否启用',width:100,sortable:true,align:'center',formatter:ReturnFlagIcon}
				  ]];
				  
				  
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.CT.HCCSVoiceDeviceType",
			QueryName:"GetList",
			'hospid':hospComp.getValue()    //多院区医院
		},
		columns: columns,  //列信息
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:PageSizeMain,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		ClassTableName:'User.CTHCCSVoiceDeviceType',
		SQLTableName:'CT_HCCSVoiceDeviceType',
		idField:'VDTRowId', 
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true, //列号 自适应宽度
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort:false,  //定义是否从服务器排序数据。true
		toolbar:[{
			iconCls:'icon-add',
			text:'新增',
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
			handler:DelData
		}],

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