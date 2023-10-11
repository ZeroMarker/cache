/*
* @Author: 基础数据平台-杨帆
* @Date:   2020-12-23
* @描述:个人通讯录-设备绑定
*/

//设备绑定保存、删除
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTHCCSEquipLinkContList&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTHCCSEquipLinkContList";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTHCCSEquipLinkContList&pClassMethod=DeleteData";
var init=function()
{
   //设备绑定表
   var columns =[[
					{field:'ELCLRowId',title:'ELCLRowId',width:100,sortable:true,hidden:true},
					{field:'ELCLContactListDR',title:'ELCLContactListDR',width:100,sortable:true,hidden:true}, //个人通讯录id
					{field:'ELCLEquipmentDR',title:'设备编码',width:160,sortable:true},
					{field:'EQId',title:'设备ID',width:180,sortable:true},
					{field:'ELCLDateFrom',title:'关联开始日期',width:100,sortable:true},
					{field:'ELCLDateTo',title:'关联结束日期',width:100,sortable:true},
					{field:'HCCSCLInput',title:'NFC信息写入',width:80,align:'center',
                    formatter:function(val,row,index){  
                        var btn =  '<img class="contrast mytooltip" title="NFC信息写入" onclick="EditMethod()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/book_green.png" style="border:0px;cursor:pointer">'   
                        
                        return btn;  
                    }
                  }
    ]];
    var grid = $HUI.datagrid("#grid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.CT.CTHCCSEquipLinkContList",
            QueryName:"GetList2",
			contactListid:HCCSCLRowId
        },
        columns: columns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:10,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        remoteSort:false,
        //ClassTableName:'User.CTHCCSEquipLinkContList',
		//SQLTableName:'CT_HCCSEquipLinkContList',
        idField:'ELCLRowId',
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onDblClickRow:function(rowIndex,rowData){
        	UpdateData();
        },
        onLoadSuccess:function(data){
	        $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
        	$(this).datagrid('columnMoving'); //列可以拖拽改变顺序
        }		
    });

	//设备编码下拉框
	$('#ELCLEquipmentDR').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.HCCSEquipment&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'EQRowId',
		textField:'EQCode',
		onBeforeLoad: function(param){
			param.hospid = HospID
		},
		onSelect:function(param){
			var EQCode=$('#ELCLEquipmentDR').combobox('getValue')
			var EQId= tkMakeServerCall("web.DHCBL.CT.CTHCCSEquipLinkContList","GetEQID",EQCode);
			if (EQId!="")
			{
				$('#EQId').val(EQId)
			}
		}
	});

	//设备编码查询、重置
	$('#EquipmentCode').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchEquipment();
		}
		if(event.keyCode == 27) {
		  RefreshEquipment();
		}
	    
	});
	//设备ID查询、重置
	$('#EquipmentDesc').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchEquipment();
		}
		if(event.keyCode == 27) {
		  RefreshEquipment();
		}
	    
	});

    //搜索
    $('#btnSearch').click(function(e){
        SearchEquipment();
    });
  
    //搜索方法
    SearchEquipment=function()
    {
		var code=$.trim($("#EquipmentCode").val());
		var id=$.trim($('#EquipmentDesc').val());
        $('#grid').datagrid('reload',  {
                ClassName:"web.DHCBL.CT.CTHCCSEquipLinkContList",
                QueryName:"GetList2",
				eqcode:code,
				eqid:id,
                //equipmentid:id,
				contactListid:HCCSCLRowId
        });
        $('#grid').datagrid('unselectAll');        
    }    
    //重置
    $('#btnRefresh').click(function(e){
    	RefreshEquipment();
    });
  
    //重置方法
    RefreshEquipment=function()
    {
        $("#EquipmentCode").val("");
		$("#EquipmentDesc").val("");
    	$('#grid').datagrid('reload',  {
            	ClassName:"web.DHCBL.CT.CTHCCSEquipLinkContList",
            	QueryName:"GetList2",
				contactListid:HCCSCLRowId
    	});
		$('#grid').datagrid('unselectAll');     
    } 
	
	//点击添加按钮(设备绑定)
    $('#add_btn').click(function(e)
    {
        AddData();
		$('#ELCLContactListDR').val(HCCSCLRowId);
		
		var date=$.fn.datebox.defaults.formatter(new Date())
		$('#ELCLDateFrom').datebox('setValue',date);
	});

	
    //点击修改按钮（设备绑定）
	$('#update_btn').click(function(e)
	{
    	UpdateData();
	});

    //点击删除按钮（设备绑定）
	$('#del_btn').click(function(e)
	{
    	DelData();
	});
	
	/****************************NFC信息写入部分***************************/

	//点击发放记录查询按钮
	EditMethod=function()
	{
		if (soundWS.readyState===1){
            soundWS.send("write_nfc="+HCCSCLUserCode);
            $.messager.popover({msg: 'NFC信息写入成功！',type:'success',timeout: 1000});
		}
	}
	/****************************NFC信息写入部分 完***************************/
	//添加方法（设备绑定）
    AddData=function()
    {
		$('#ELCLEquipmentDR').combobox('reload');
		$("#myWin").show();
		var flag= tkMakeServerCall("web.DHCBL.CT.CTHCCSEquipLinkContList","GetBandFlag",HCCSCLRowId);
		if (flag=="1")
		{
			$.messager.alert('提示','该用户已绑定一个有效设备!',"info");
			return;
		}
		var myWin = $HUI.dialog("#myWin",
		{
			iconCls:'icon-w-add',
			resizable:true,
			title:'新增',
			modal:true,
			buttonAlign : 'center',
			buttons:
			[
				{
					text:'保存',
					id:'save_btn',
					handler:function()
					{		
						SaveFunLib("");		
					}
				},
				{
					text:'关闭',
					handler:function()
					{
						myWin.close();
						editIndex = undefined;
					}
				}
			],
			
		});
		$('#form-save').form("clear");
		$("#HCCSCLRowId").val(HCCSCLRowId);
	}
	//保存方法（设备绑定）
    SaveFunLib=function(id)
	{			
		var ELCLEquipmentDR=$('#ELCLEquipmentDR').combobox('getValue')	
		if ((ELCLEquipmentDR==undefined)||(ELCLEquipmentDR=="") )
		{
			$.messager.alert('错误提示','设备请选择下拉列表里的值!',"info");
			return;
		}
		if ($.trim($("#EQId").val())=="")
		{
			$.messager.alert('错误提示','设备Id不能为空!',"info");
			return;
		}

		var ELCLDateFrom=$('#ELCLDateFrom').datebox('getValue')	
		if ((ELCLDateFrom==undefined)||(ELCLDateFrom=="") )
		{
			$.messager.alert('错误提示','开始时间不能为空!',"info");
			return;
		}

		var flag= tkMakeServerCall("web.DHCBL.CT.CTHCCSEquipLinkContList","FormValidate",$.trim($("#ELCLRowId").val()),ELCLEquipmentDR,HCCSCLRowId,ELCLDateFrom);
		if (flag==1)
		{
			$.messager.alert('错误提示','该设备已被其他用户绑定!',"info");
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
									$('#grid').datagrid('reload');  // 重新载入当前页面数据
									$('#grid').datagrid('unselectAll');									
								}
								else{
									
									 $.cm({
										ClassName:"web.DHCBL.CT.CTHCCSEquipLinkContList",
										QueryName:"GetList2",
										rowid: data.id   
									},function(jsonData){
										$('#grid').datagrid('insertRow',{
											index:0,
											row:jsonData.rows[0]
										})
									})
									$('#grid').datagrid('unselectAll');
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
	//修改数据方法（设备绑定）
    UpdateData=function() {
		$('#ELCLEquipmentDR').combobox('reload');
		var record = $("#grid").datagrid("getSelected");
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		var id=record.ELCLRowId
		$.cm({
			ClassName:"web.DHCBL.CT.CTHCCSEquipLinkContList",
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
	//删除方法（设备绑定）
    DelData=function()
    {
		var row = $("#grid").datagrid('getSelected'); 
		if (!(row))
		{
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var rowid=row.ELCLRowId;
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r)
		{
			if (r)
			{
				$.ajax(
					{
						url:DELETE_ACTION_URL,  
						data:{"id":rowid},  
						type:"POST",     
						success: function(data)
						{
							var data=eval('('+data+')');
							if (data.success == 'true') 
							{
								$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
								$('#grid').datagrid('reload');  // 重新载入当前页面数据 
								$('#grid').datagrid('unselectAll');  // 清空列表选中数据 
							} 
							else {
								var errorMsg ="删除失败！"
								if (data.info) 
								{
									errorMsg =errorMsg+ '<br/>错误信息:' + data.info
								}
								$.messager.alert('操作提示',errorMsg,"error");
					
							}			
						}  
					});
			}
		});    	
	} 
	
}
$(init);