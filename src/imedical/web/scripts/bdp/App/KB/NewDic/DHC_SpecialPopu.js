/*
* @Author: 基础数据平台-石萧伟
* @Date:   2018-07-31 15:41:35
* @Last Modified by:   admin
* @Last Modified time: 2018-10-23 15:27:58
* @描述:特殊人群字典
*/
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCSpecialPopu&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCSpecialPopu";
var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCSpecialPopu&pClassMethod=OpenData";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCSpecialPopu&pClassMethod=DeleteData";
var init = function(){
    var columns =[[
        {field:'SPECode',title:'代码',sortable:true,width:100},
        {field:'SPEDesc',title:'描述',sortable:true,width:100},
        {field:'SPEType',title:'特殊人群标识',sortable:true,width:100},
        {field:'SPELibDr',title:'知识库标识',sortable:true,width:100},
        {field:'SPEActiveFlag',title:'是否可用',sortable:true,width:100,
              formatter:ReturnFlagIcon
    	},
        {field:'SPESysFlag',title:'系统标识',sortable:true,width:100,
              formatter:ReturnFlagIcon
    	},
        {field:'SPERowId',title:'rowid',sortable:true,width:100,hidden:true}
    ]];
    var mygrid = $HUI.datagrid("#mygrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.KB.DHCSpecialPopu",
            QueryName:"GetList"
        },
        columns: columns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:PageSizeMain,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        remoteSort:false,
        //ClassTableName:'User.DHCLabItmFeild',
		//SQLTableName:'DHC_LabItmFeild',
        idField:'SPERowId',
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onDblClickRow:function(index,row)
        {
        	updateData();
        },
        onLoadSuccess:function(data){
			$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
        },
        onRowContextMenu:function (e, rowIndex,row) { //右键时触发事件
            /*e.preventDefault();//阻止浏览器捕获右键事件
            $(this).datagrid('selectRow', rowIndex);
            //changeUpDownStatus(rowIndex);
        	$('#rightbar').menu('show', {    
				  left:e.pageX,  
				  top:e.pageY
			})*/
        }  	
    	
    });
    /*
    //右键点击添加按钮
    $('#addright_btn').click(function(e){
    	AddData();
    });
    //右键点击修改按钮
    $('#updateright_btn').click(function(){
    	updateData();
    });
    //右键点击删除按钮
    $('#delright_btn').click(function(e){
    	delData();
    });
    //右键关联病症
    $('#disright_btn').click(function(e){
    	LinkMethod("dis");
    });
    //右键关联既往史
    $('#historyright_btn').click(function(e){
    	LinkMethod("history");
    });
    //右键关联检查结果
    $('#resultright_btn').click(function(e){
    	LinkMethod("result");
    });
    //右键关联检验指标
    $('#labright_btn').click(function(e){
    	LinkMethod("lab");
    });*/
    //工具栏知识库标识下拉框
	$('#TextLib').combobox({
        url:$URL+"?ClassName=web.DHCBL.KB.DHCPHLibaryLabel&QueryName=GetNewDataForCmb1&ResultSetType=array",
        valueField:'PHLIRowId',
        textField:'PHLIDesc',
        mode:'remote'
    });
    //弹窗知识库标识下拉框
	$('#SPELibDr').combobox({
        url:$URL+"?ClassName=web.DHCBL.KB.DHCPHLibaryLabel&QueryName=GetNewDataForCmb1&ResultSetType=array",
        valueField:'PHLIRowId',
        textField:'PHLIDesc',
        mode:'remote' 
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
    //关联病症
    $('#dis_btn').click(function(e){
    	LinkMethod("dis");
    });
    //关联既往史
    $('#history_btn').click(function(e){
    	LinkMethod("history");
    });
    //关联检查结果
    $('#result_btn').click(function(e){
    	LinkMethod("result");
    });
    //关联检验指标
    $('#lab_btn').click(function(e){
    	LinkMethod("lab");
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
    	var libdr=$("#TextLib").combobox('getValue');
    	$('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.KB.DHCSpecialPopu",
            QueryName:"GetList",
            desc:desc,
            code:code,
            lib:libdr
        });
        $('#mygrid').datagrid('unselectAll');   	
    }    
    //点击重置按钮
    $('#btnRefresh').click(function(e){
		$("#TextDesc").val('');//清空检索框
		$("#TextCode").val('');
		$("#TextLib").combobox('setValue','');
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.KB.DHCSpecialPopu",
            QueryName:"GetList"
        });
		$('#mygrid').datagrid('unselectAll');
    });
    //右键点击重置按钮
    $('#btnright_Refresh').click(function(e){
		$("#TextDesc").val('');//清空检索框
		$("#TextCode").val('');
		$("#TextLib").combobox('setValue','');
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.KB.DHCSpecialPopu",
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
		$HUI.checkbox("#SPEActiveFlag").setValue(true);
		$HUI.checkbox("#SPESysFlag").setValue(true);		
	}
	SaveFunLib=function(id,flagT)
	{
		//alert(flag)
		var code=$.trim($("#SPECode").val());
		var desc=$.trim($("#SPEDesc").val());	
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
		var active="N";
		if ($('#SPEActiveFlag').attr('checked')) 
		{
			var active="Y" ;
		}
		var flag="N";
		if ($('#SPESysFlag').attr('checked')) 
		{
			var flag="Y" ;
		}	
		$('#form-save').form('submit', {
			url:SAVE_ACTION_URL,
			onSubmit: function(param){
                param.SPERowId = id;
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
				$HUI.checkbox("#SPEActiveFlag").setValue(true);
				$HUI.checkbox("#SPESysFlag").setValue(true);				
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
			var id=record.SPERowId;
			$.cm({
				ClassName:"web.DHCBL.KB.DHCSpecialPopu",
				MethodName:"NewOpenData",
				id:id
			},function(jsonData){
				//给是否可用单独赋值	
				//alert(jsonData.PHLFSysFlag)		
				//alert(jsonData.PHLFActiveFlag)		
				if (jsonData.SPEActiveFlag=="Y"){
					$HUI.checkbox("#SPEActiveFlag").setValue(true);		
				}else{
					$HUI.checkbox("#SPEActiveFlag").setValue(false);
				}
				if(jsonData.SPESysFlag=="Y"){
					$HUI.checkbox('#SPESysFlag').setValue(true);
				}else{
					$HUI.checkbox('#SPESysFlag').setValue(false);
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
		var rowid=row.SPERowId;
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
	LinkMethod=function(flag)
	{
		var record = mygrid.getSelected(); 
		if(record)
		{
			var resutText=record.SPEDesc;
			$('#linkWin').show();
			var resultWin = $HUI.dialog("#linkWin",{
				iconCls:'icon-textbook',
				resizable:true,
				//title:resutText,
				modal:true
			});	
			var parref=record.SPERowId;
			var parrefDesc=record.SPEDesc;
			var url=""
			if(flag=="dis")
			{
				$("#linkWin").panel('setTitle','关联病症字典-'+resutText);
				url="../csp/dhc.bdp.kb.dhcspecialpopudis.csp"+"?parref="+parref+"&parrefDesc="+parrefDesc;
			}
			else if(flag=="history")
			{
				$("#linkWin").panel('setTitle','关联既往史字典-'+resutText);
				url="../csp/dhc.bdp.kb.dhcspecialpopuhistory.csp"+"?parref="+parref+"&parrefDesc="+parrefDesc;
			}
			else if(flag=="result")
			{
				$("#linkWin").panel('setTitle','关联检查结果字典-'+resutText);
				url="../csp/dhc.bdp.kb.dhcspecialpopuexa.csp"+"?parref="+parref+"&parrefDesc="+parrefDesc;
			}
			else if(flag=="lab")
			{
				$("#linkWin").panel('setTitle','关联检验指标字典-'+resutText);
				url="../csp/dhc.bdp.kb.dhcspecialpopulab.csp"+"?parref="+parref+"&parrefDesc="+parrefDesc;
			}
			 //token改造 GXP 20230209
			if(('undefined'!==typeof websys_getMWToken)&&(url!=""))
			{
				url+="&MWToken="+websys_getMWToken()
			}	
			$('#link_iframe').attr("src",url);
		}
		else
		{
			$.messager.alert('错误提示','请先选择一条记录!',"error");			
		}
	}
}
$(init);