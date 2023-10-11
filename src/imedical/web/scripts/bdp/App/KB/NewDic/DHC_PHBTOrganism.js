/*
* @Author: 基础数据平台-石萧伟
* @Date:   2018-08-07 15:41:35
* @Last Modified by:   admin
* @Last Modified time: 2018-10-23 15:51:07
* @描述:细菌字典
*/
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHBTOrganism&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHBTOrganism";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHBTOrganism&pClassMethod=DeleteData";
var init=function()
{
    var columns =[[
        {field:'BTOCode',title:'代码',sortable:true,width:100},
        {field:'BTODesc',title:'描述',sortable:true,width:100},
        {field:'BTOWhoNet',title:'Whonet码',sortable:true,width:100},
        {field:'BTOActiveFlag',title:'是否可用',sortable:true,width:100,
              formatter:ReturnFlagIcon
    	},
        {field:'BTOSysFlag',title:'系统标识',sortable:true,width:100,
              formatter:ReturnFlagIcon
    	},    	
        {field:'BTORowId',title:'rowid',sortable:true,width:100,hidden:true}
    ]];
    var mygrid = $HUI.datagrid("#mygrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.KB.DHCPHBTOrganism",
            QueryName:"GetList"
        },
        columns: columns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:PageSizeMain,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        remoteSort:false,
        //ClassTableName:'User.DHCPHExtPart',
		//SQLTableName:'DHC_PHExtPart',
        idField:'BTORowId',
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onDblClickRow:function(index,row)
        {
        	updateData();
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
    $('#update_btn').click(function(){
    	updateData();
    });
    //点击删除按钮
    $('#del_btn').click(function(e){
    	delData();
    });
     //点击搜索按钮
    $('#btnSearch').click(function(e){
    	SearchFunLib();
    });
    //搜索回车事件
	$('#TextDesc,#TextCode').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchFunLib();
		}
	});    
    //搜索方法
    SearchFunLib=function()
    {
    	var code=$("#TextCode").val();
    	var desc=$("#TextDesc").val();
    	$('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.KB.DHCPHBTOrganism",
            QueryName:"GetList",
            desc:desc,
            code:code
        });
        $('#mygrid').datagrid('unselectAll');    	
    }    
    //点击重置按钮
    $('#btnRefresh').click(function(e){
		$("#TextDesc").val('');//清空检索框
		$("#TextCode").val('');
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.KB.DHCPHBTOrganism",
            QueryName:"GetList"
        });
		$('#mygrid').datagrid('unselectAll');
    });
 	//点击添加按钮方法
    AddData=function(){ 
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
					SaveFunLib("",1)
				}
			},{
				text:'继续新增',
				id:'save_goon',
				handler:function(){
					//goOnSaveData();
					SaveFunLib("",2)
				}
			},{
				text:'关闭',
				handler:function(){
					myWin.close();
				}
			}]
		});
		$('#form-save').form("clear");
		//默认选中
		$HUI.checkbox("#BTOActiveFlag").setValue(true);
		$HUI.checkbox("#BTOSysFlag").setValue(true);	
	}
	SaveFunLib=function(id,flagT)
	{
		//alert(flag)
		var code=$.trim($("#BTOCode").val());
		var desc=$.trim($("#BTODesc").val());	
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
		var flag="N";
		if ($('#BTOActiveFlag').attr('checked')) 
		{
			var flag="Y" ;
		}
		var flag1="N";
		if ($('#BTOSysFlag').attr('checked')) 
		{
			var flag1="Y" ;
		}		
		$('#form-save').form('submit', {
			url:SAVE_ACTION_URL,
			onSubmit: function(param){
                param.BTORowId = id;
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
			//alert(flagT)
			if(flagT==1)
			{
				//alert(flagT)
				$('#myWin').dialog('close'); // close a dialog
			}
			else
			{
				$('#form-save').form("clear");
				//默认选中
				$HUI.checkbox("#BTOActiveFlag").setValue(true);	
				$HUI.checkbox("#BTOSysFlag").setValue(true);			
			}
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
	updateData=function()
	{
		var record = mygrid.getSelected(); 
		if(record)
		{
			var id=record.BTORowId;
			$.cm({
				ClassName:"web.DHCBL.KB.DHCPHBTOrganism",
				MethodName:"NewOpenData",
				id:id
			},function(jsonData){
				//给是否可用单独赋值	
				//alert(jsonData.PHLFSysFlag)		
				//alert(jsonData.PHLFActiveFlag)		
				if (jsonData.BTOActiveFlag=="Y"){
					$HUI.checkbox("#BTOActiveFlag").setValue(true);		
				}else{
					$HUI.checkbox("#BTOActiveFlag").setValue(false);
				}
				if (jsonData.BTOSysFlag=="Y"){
					$HUI.checkbox("#BTOSysFlag").setValue(true);		
				}else{
					$HUI.checkbox("#BTOSysFlag").setValue(false);
				}
				$('#form-save').form("load",jsonData);	
			});	
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
						SaveFunLib(id,1)
					}
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
	delData=function()
	{
		var row = $("#mygrid").datagrid("getSelected"); 
		if (!(row))
		{	$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var rowid=row.BTORowId;
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
			if (r){
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
								}); */
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
}
$(init);