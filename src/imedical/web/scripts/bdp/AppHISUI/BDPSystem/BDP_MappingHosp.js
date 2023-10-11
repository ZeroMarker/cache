
//Creator:yangfan
//CreatDate:2020-02-12
//Description:私有数据关联医院

var init = function(){
	
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPMappingHOSP&pClassMethod=DeleteData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.BDP.BDPMappingHOSP&pClassMethod=SaveEntity&pEntityName=web.Entity.BDP.BDPMappingHosp";
	
	
	
	/**************************************权限分配按钮***李可凡***2020年3月26日*********************************/
	//从医院下拉框
	$('#HospitalFrom').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.CTHospital&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'HOSPRowId',
		textField:'HOSPDesc'
	});
	//到医院下拉框
	$('#HospitalTo').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.CTHospital&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'HOSPRowId',
		textField:'HOSPDesc'
	});
	
	//点击批量授权按钮
	CopyData=function() {
		$('#Copygrid').datagrid('unselectAll');
		$('#HospitalFrom').combobox('reload');
		$('#HospitalTo').combobox('reload');
		$("#CopyWin").show();
		var CopyWin = $HUI.dialog("#CopyWin",{
			iconCls:'icon-w-add',
			resizable:true,
			title:'批量授权',
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				text:'保存',
				id:'copy_btn',
				handler:function(){
					SaveCopy();
				}
			},{
				text:'关闭',
				handler:function(){
					CopyWin.close();
				}
			}]
		});	
		$('#form-copy').form("clear");
	 }
	 
	//批量授权保存方法
	SaveCopy=function(){
		var HospitalFrom=$('#HospitalFrom').combobox('getValue');
		var HospitalTo=$('#HospitalTo').combobox('getValue');
		var record_copy=Copygrid.getSelections(); 
		if (HospitalFrom=="")
		{
			$.messager.alert('错误提示','从医院不能为空!',"info");
			return;
		}
		if (HospitalTo=="")
		{
			$.messager.alert('错误提示','到医院不能为空!',"info");
			return;
		}
		if ((HospitalFrom==undefined)||(HospitalFrom=="undefined") )
		{
			$.messager.alert('错误提示','从医院请选择下拉列表里的值!',"info");
			return;
		}
		if ((HospitalTo==undefined)||(HospitalTo=="undefined") )
		{
			$.messager.alert('错误提示','到医院请选择下拉列表里的值!',"info");
			return;
		}
		if (HospitalFrom==HospitalTo)
		{
			$.messager.alert('错误提示','医院不能相同!',"info");
			return;
		}
		if (record_copy=="")
		{	
			$.messager.alert('错误提示','请选择需要批量授权的表!',"info");
			return;
		}
		
		var len=record_copy.length;
		var tablestr="";
		for (i=0;i<len;i++)
		{
			var tablename=record_copy[i].ClassName;
			if (tablestr==""){
				tablestr=tablename;
			}else{
				tablestr=tablestr+"^"+tablename;
			}
		}
		//alert(HospitalFrom+","+HospitalTo+","+tablestr);
		$.messager.confirm('提示', "确认要批量授权数据吗?", function(r){
			if (r){
				var flag = tkMakeServerCall("web.DHCBL.BDP.BDPMappingHOSP","CopyAuthorizedDataByTable",HospitalFrom,HospitalTo,tablestr);	
				if (flag=="1"){
					$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
					$('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
					$('#mygrid').datagrid('unselectAll');
				}
				else{
					$.messager.alert('操作提示',"保存失败！","error");
				}
			}
		})
	}
	
	var copycolumns =[[	
				{field:'checkOrd',checkbox:'true',align:'center',width:30},
				{field:'RowID',title:'RowID',width:80,hidden:true,sortable:true},
				{field:'ClassName',title:'表名',width:100,sortable:true},
				{field:'TableDesc',title:'中文名',width:100,sortable:true}
				]];
				  
				  
	var Copygrid = $HUI.datagrid("#Copygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.BDP.BDPTableList",
			QueryName:"GetDataForCmb1",
			'datatype':"C"
		},
		columns: copycolumns,  //列信息
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:100,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:false,
		ClassTableName:'User.BDPTableList',
		SQLTableName:'BDPTableList',
		idField:'RowID', 
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
	
	/**************************************权限分配按钮***完*********************************/
	
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
		var tabledr=$('#TextTable').combobox('getValue')
		var hospitaldr=$("#TextHospital").combobox('getValue')
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.BDP.BDPMappingHOSP",
			QueryName:"GetList",	
			'code':code,	
			'tabledr':tabledr,
			'hospitaldr':hospitaldr
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	//重置方法
	ClearFunLib=function()
	{
		$("#TextCode").val("");
		$("#TextTable").combobox('setValue','');
		$("#TextHospital").combobox('setValue','');
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.BDP.BDPMappingHOSP",
			QueryName:"GetList"
		});
		$('#mygrid').datagrid('unselectAll');

	}
	
	//查询工具栏医院下拉框
	$('#TextHospital').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.CTHospital&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'HOSPRowId',
		textField:'HOSPDesc'
	});
	
	//查询工具栏表名称下拉框
	$('#TextTable').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.BDP.BDPTableList&QueryName=GetDataForCmb1&ResultSetType=array&datatype=SCA&mappinghospflag=Y",
		valueField:'RowID',
		textField:'Table'
	});

	//医院下拉框
	$('#BDPMPHHospital').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.CTHospital&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'HOSPRowId',
		textField:'HOSPDesc'
	});
	
	//表名称下拉框
	$('#BDPMPHTableName').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.BDP.BDPTableList&QueryName=GetDataForCmb1&ResultSetType=array&datatype=SCA&mappinghospflag=Y",
		valueField:'RowID',
		textField:'Table'
	});
	
	
	 ///新增、修改
	SaveFunLib=function(id)
	{
		var BDPMPHHospital=$('#BDPMPHHospital').combobox('getValue')
		if (BDPMPHHospital=="")
		{
			$.messager.alert('错误提示','医院不能为空!',"info");
			return;
		}		
		if ((BDPMPHHospital==undefined)||(BDPMPHHospital=="undefined") )
		{
			$.messager.alert('错误提示','医院请选择下拉列表里的值!',"info");
			return;
		}
		var BDPMPHTableName=$('#BDPMPHTableName').combobox('getValue')		
		if (BDPMPHTableName=="")
		{
			$.messager.alert('错误提示','表名称不能为空!',"info");
			return;
		}
		if ((BDPMPHTableName==undefined)||(BDPMPHTableName=="undefined") )
		{
			$.messager.alert('错误提示','表名称请选择下拉列表里的值!',"info");
			return;
		}
		if ($.trim($("#BDPMPHDataReference").val())=="")
		{
			$.messager.alert('错误提示','对应表数据RowID不能为空!',"info");
			return;
		}
		var flag = tkMakeServerCall("web.DHCBL.BDP.BDPMappingHOSP","FormValidate",$("#ID").val(),$("#BDPMPHTableName").combobox('getValue'),$('#BDPMPHHospital').combobox('getValue'),$("#BDPMPHDataReference").val());	
		if (flag==1)
		{
			$.messager.alert('操作提示',"该记录已经存在！","info");
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
								if (id!="")
								{
									$('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
									$('#mygrid').datagrid('unselectAll');
								}
								else{
									
									 $.cm({
										ClassName:"web.DHCBL.BDP.BDPMappingHOSP",
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
		$('#BDPMPHHospital').combobox('reload');
		$('#BDPMPHTableName').combobox('reload');
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
		$('#form-save').form("clear");
	}
	
	//点击修改按钮
	UpdateData=function() {
		$('#BDPMPHHospital').combobox('reload');
		$('#BDPMPHTableName').combobox('reload');
		var record=mygrid.getSelected(); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		var id=record.ID
		$.cm({
			ClassName:"web.DHCBL.BDP.BDPMappingHOSP",
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
						SaveFunLib(id)
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

	

	///删除
	DelData=function()
	{                  
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
			if (r){	
				$.ajax({
					url:DELETE_ACTION_URL,  
					data:{
						"id":record.ID      ///rowid
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
				  {field:'ID',title:'ID',width:80,hidden:true,sortable:true},
				  {field:'BDPMPHHospital',title:'关联医院',width:140,sortable:true},
				  {field:'BDPMPHTableName',title:'表名称',width:140,sortable:true},
				  {field:'BDPMPHDataReference',title:'对应表数据RowID',width:50,sortable:true},
				  ]];
				  
				  
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.BDP.BDPMappingHOSP",
			QueryName:"GetList"
		},
		columns: columns,  //列信息
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:PageSizeMain,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		ClassTableName:'User.BDPMappingHosp',
		SQLTableName:'BDP_MappingHosp',
		idField:'ID', 
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true, //列号 自适应宽度
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort:false,  //定义是否从服务器排序数据。true
		toolbar:[{
			iconCls:'icon-add',
			text:'新增',
			id:'btnAdd',
			handler:AddData
		},{
			iconCls:'icon-write-order',
			text:'修改',
			id:'btnUpdate',
			handler:UpdateData
		},{
			iconCls:'icon-cancel',
			text:'删除',
			id:'btnDel',
			handler:DelData
		},{
			iconCls:'icon-add',
			text:'批量授权',
			id:'btnCopy',
			handler:CopyData
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