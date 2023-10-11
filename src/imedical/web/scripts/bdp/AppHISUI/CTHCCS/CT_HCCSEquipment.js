//Creator:yangfan
//CreatDate:2020-12-17
//Description:医呼通设备
var GV={}  ;//存放全局变量
var init = function(){
	
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.HCCSEquipment&pClassMethod=DeleteData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.HCCSEquipment&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTHCCSEquipment";
	
	var HospID=""
	//多院区下拉框
	var hospComp=GenHospComp('CT_HCCSEquipment');
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
	var hospComp = GenHospComp("CT_HCCSEquipment");
	//医院下拉框选中事件
	hospComp.jdata.options.onSelect = function(e){
		var HospID=$HUI.combogrid('#_HospList').getValue();
		ClearFunLib();
	}
	*/

	//设备代码查询、重置
	$('#TextCode').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchFunLib();
		}
		if(event.keyCode == 27) {
		  ClearFunLib();
		}
	    
	});
	//设备ID查询、重置
	$('#TextID').keyup(function(event){
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
		var eqid=$.trim($('#TextID').val()); 
		var HospID=hospComp.getValue();
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.CT.HCCSEquipment",
			QueryName:"GetList",	
			'code':code,	
			'eqid':eqid,
			'hospid':HospID
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	//重置方法
	ClearFunLib=function()
	{
		$("#TextCode").val("");
		$("#TextID").val("");
		var HospID=hospComp.getValue();
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.CT.HCCSEquipment",
			QueryName:"GetList",
			'hospid':HospID
		});
		$('#mygrid').datagrid('unselectAll');

	}
	
	 ///新增、修改
	SaveFunLib=function(id)
	{			
		if ($.trim($("#EQCode").val())=="")
		{
			$.messager.alert('错误提示','设备代码不能为空!',"info");
			return;
		}
		if ($.trim($("#EQId").val())=="")
		{
			$.messager.alert('错误提示','设备ID不能为空!',"info");
			return;
		}
		var flag= tkMakeServerCall("web.DHCBL.CT.HCCSEquipment","FormValidate",$.trim($("#EQRowId").val()),$.trim($("#EQCode").val()),$.trim($("#EQId").val()),hospComp.getValue());
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
										ClassName:"web.DHCBL.CT.HCCSEquipment",
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
		$HUI.checkbox("#EQActiveFlag").setValue(true);		//新增-有效标识默认勾选
	}
	
	//点击修改按钮
	UpdateData=function() {
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		var id=record.EQRowId
		$.cm({
			ClassName:"web.DHCBL.CT.HCCSEquipment",
			MethodName:"OpenData",
			id:id
		},function(jsonData){
			if (jsonData.EQActiveFlag=="Y")   //有效标识
			{
				$HUI.checkbox("#EQActiveFlag").setValue(true);	  
			}else{
				$HUI.checkbox("#EQActiveFlag").setValue(false);
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
						"id":record.EQRowId      //rowid
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
	/****************************发放记录查询部分***************************/
	//点击发放记录查询按钮
	/*QueryMethod=function(index)
	{
		$('#mygrid').datagrid('selectRow',index);    //单击按钮选中列表
		var record = $("#mygrid").datagrid("getSelected"); 
		var EQRowId=record.EQRowId;
		var HospID=$HUI.combogrid('#_HospList').getValue();
		$("#searchWin").show();  
		$('#searchWin').window({
			iconCls:'icon-paper',
			title:"发放记录查询",
			width:800,
			height:Math.min(document.body.clientHeight-10,500),
			modal:true,
			resizable:true,
			minimizable:false,
			maximizable:false,
			collapsible:false,
			content:'<iframe id="recordquery" frameborder="0" src="dhc.bdp.ct.ctequipmentlink.csp?EQRowId='+EQRowId+'&HospID='+HospID+'" width="99%" height="98%" scrolling="auto"></iframe>'
		});
	}
	*/
	/****************************发放记录查询部分***************************/
	
	var columns =[[  
				  {field:'EQRowId',title:'EQRowId',width:80,hidden:true,sortable:true},
				  {field:'EQCode',title:'设备编码',width:100,sortable:true},
				  {field:'EQId',title:'设备ID',width:100,sortable:true},
				  {field:'EQRemarks',title:'备注',width:100,sortable:true},
				  {field:'EQActiveFlag',title:'是否启用',width:100,sortable:true,align:'center',formatter:ReturnFlagIcon}
				  /*,
				  {field:'EQBindRecord',title:'发放记录查询',width:100,align:'center',
                    formatter:function(val,row,index){  
                        var btn =  '<img class="contrast mytooltip" title="发放记录查询" onclick="QueryMethod('+index+')" src="../scripts_lib/hisui-0.1.0/dist/css/icons/book_green.png" style="border:0px;cursor:pointer">'   
                        
                        return btn;  
                    }
                  }*/
				  ]];
				  
				  
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.CT.HCCSEquipment",
			QueryName:"GetList",
			'hospid':hospComp.getValue()    //多院区医院
		},
		columns: columns,  //列信息
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:PageSizeMain,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		ClassTableName:'User.CTHCCSEquipment',
		SQLTableName:'CT_HCCSEquipment',
		idField:'EQRowId', 
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