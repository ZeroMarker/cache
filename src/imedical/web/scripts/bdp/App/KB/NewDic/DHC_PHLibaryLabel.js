/*
Creator:GuXueping
CreatDate:2017-12-01
Description:知识库标识字典
*/
//var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHLibaryLabel&pClassMethod=GetList";
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHLibaryLabel&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHLibaryLabel";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHLibaryLabel&pClassMethod=DeleteData";
//var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHLibaryLabel&pClassMethod=NewOpenData";

var init = function(){
	
	var columns =[[  
				  {field:'PHLICode',title:'代码',width:180},
				  {field:'PHLIDesc',title:'描述',width:180}, 
				  {field:'PHLIActiveFlag',title:'是否可用',width:60,
		                formatter:ReturnFlagIcon			  
				  },
				  {field:'PHLIRowId',title:'PHLIRowId',hidden:true}
				  ]];
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCPHLibaryLabel",
			QueryName:"GetList"
		},
		columns: columns,  //列信息
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:PageSizeMain,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		idField:'PHLIRowId', 
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true,
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort:false,  //定义是否从服务器排序数据。定义是否从服务器排序数据。true
		//toolbar:'#mytbar'
		/*toolbar:[{
			iconCls:'icon-add',
			text:'新增',
			handler:AddData
		},{
			iconCls:'icon-save',
			text:'编辑',
			//disabled:true,
			id:'editIcons',
			handler:UpdateData
		},{
			iconCls:'icon-close',
			text:'删除',
			//disabled:true,
			id:'delIcons',
			handler:DelData
		}]*/
        onDblClickRow:function(index,row)
        {
        	UpdateData();
        	//changeUpDownStatus(index);
        },
        onLoadSuccess:function(data){
			$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
        }	
	});

    //点击添加按钮
    $('#add_btn').click(function(e){
    	AddData();
    });
    //点击修改按钮
    $('#update_btn').click(function(e){
    	UpdateData();
    });
    //点击删除按钮
    $('#del_btn').click(function(e){
    	DelData();
    });
	//查询按钮
	$("#btnSearch").click(function (e) { 
			SearchFunLib();
	 })  
	 
	//清屏按钮
	$("#btnRefresh").click(function (e) { 
			ClearFunLib();
	 }) 
 
    //搜索回车事件
	$('#TextDesc,#TextCode').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchFunLib();
		}
	}); 
	 //查询方法
	function SearchFunLib(){
		var code=$.trim($("#TextCode").val());
		var desc=$.trim($('#TextDesc').val());
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.KB.DHCPHLibaryLabel",
			QueryName:"GetList"	,	
			'code':code,	
			'desc': desc
		});		
	}
	
	//重置方法
	function ClearFunLib()
	{
		$("#TextCode").val("");
		$("#TextDesc").val("");
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.KB.DHCPHLibaryLabel",
			QueryName:"GetList"
		});
	}
	
	 //点击新增按钮
	function AddData() {
		//$('#PHLICodeF').attr("disabled",false);
		$('#PHLICodeF').attr("readonly",false);
        $('#PHLICodeF')[0].readonly=false;
        $('#PHLICodeF').css({'background-color':'#ffffff'});
		$("#myWin").show();
		$('#form-save').form("clear");
		$HUI.checkbox("#PHLIActiveFlagF").setValue(true);	
		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-w-add',
			resizable:true,
			title:'新增',
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				text:'保存',
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
	}
	
	//点击修改按钮
	function UpdateData() {
		var record = mygrid.getSelected(); 
		if (record){			
			 //调用后台openData方法给表单赋值
			var id = record.PHLIRowId;
			
			$.cm({
				ClassName:"web.DHCBL.KB.DHCPHLibaryLabel",
				MethodName:"NewOpenData",
				id:id
			},function(jsonData){
				//给是否可用单独赋值				
				if (jsonData.PHLIActiveFlag=="Y"){
					$HUI.checkbox("#PHLIActiveFlagF").setValue(true);		
				}else{
					$HUI.checkbox("#PHLIActiveFlagF").setValue(false);
				}
				$('#form-save').form("load",jsonData);	
			});
							
			
			//从grid表格里获取数据给表单赋值
			/*$("#PHLICodeF").val(record.PHLICode);
			$("#PHLIDescF").val(record.PHLIDesc);
			if (record.PHLIActiveFlag=="Y"){	
				$HUI.checkbox("#PHLIActiveFlagF").setValue(true);		
			}else{
				$HUI.checkbox("#PHLIActiveFlagF").setValue(false);
			}*/
			//$('#PHLICodeF').attr("disabled",true);//代码不可修改
			$('#PHLICodeF').attr("readonly",true);
	        $('#PHLICodeF')[0].readonly=true;
	        $('#PHLICodeF').css({'background-color':'#EBEBE4'});			
			$("#myWin").show(); 
			var myWin = $HUI.dialog("#myWin",{
				iconCls:'icon-w-edit',
				resizable:true,
				title:'修改',
				modal:true,
				buttons:[{
					text:'保存',
					handler:function(){SaveFunLib(id)}
				},{
					text:'关闭',
					handler:function(){
						myWin.close();
					}
				}]
			});				
			
		}else{
			$.messager.alert('错误提示','请先选择一条记录!',"error");
		}
	

	}

	///新增、更新
	function SaveFunLib(id)
	{            
						
		var code=$.trim($("#PHLICodeF").val());
		var desc=$.trim($("#PHLIDescF").val());

		var active="N";
		if ($('#PHLIActiveFlagF').attr('checked')) 
		{
			var active="Y" ;
		}
		
		if (code=="")
		{
			$.messager.alert('错误提示','代码不能为空!',"error");
			return;
		}
		if (desc=="")
		{
			$.messager.alert('错误提示','描述不能为空!',"error");
			return;
		}
		
		
		$('#form-save').form('submit', { 
			url: SAVE_ACTION_URL, 
			onSubmit: function(param){
				param.PHLIRowId = id;
			},
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
				}); */
				$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
				$('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
				$('#myWin').dialog('close'); // close a dialog
			  } 
			  else { 
				var errorMsg ="更新失败！"
				if (data.errorinfo) {
					errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
				}
				 $.messager.alert('操作提示',errorMsg,"error");
	
			}

			} 
		  }); 


	}

	///删除
	function DelData()
	{                  

		//更新
		var row = $("#mygrid").datagrid("getSelected"); 
		if (!(row))
		{	$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var rowid=row.PHLIRowId;
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
			if(r)
			{
				$.ajax({
					url:DELETE_ACTION_URL,  
					data:{"id":rowid},  
					type:"POST",   
					//dataType:"TEXT",  
					success: function(data){
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
								});*/
								$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000}); 
								 $('#mygrid').datagrid('reload');  // 重新载入当前页面数据  
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



};
$(init);