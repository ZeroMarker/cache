/*
* @Author: 基础数据平台-石萧伟
* @Date:   2018-07-26 15:41:35
* @Last Modified by:   admin
* @Last Modified time: 2018-10-23 15:22:14
* @描述:诊断字典
*/
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCExtIcdFeild&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCExtIcdFeild";
//var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCExtIcdFeild&pClassMethod=OpenData";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCExtIcdFeild&pClassMethod=DeleteData";
var init = function(){
    var columns =[[
        {field:'ICDCode',title:'代码',sortable:true,width:100},
        {field:'ICDDesc',title:'描述',sortable:true,width:100},
        {field:'ICDType',title:'类型',sortable:true,width:100,
        	formatter:function(value,row,index){
        		if(value=="9")
        		{
        			return "ICD9";
        		}
        		else if(value=="10")
        		{
        			return "ICD10";
        		}
        		else if(value=="99")
        		{
        			return "非ICD";
        		}
        	}
    	},
        {field:'ICDAcitveFlag',title:'是否可用',sortable:true,width:100,formatter:ReturnFlagIcon},
        {field:'ICDSysFlag',title:'系统标识',sortable:true,width:100,formatter:ReturnFlagIcon},
    	{field:'ICDOpStatus',title:'操作状态',sortable:true,width:100,
    		formatter:function(value,row,index){
    			if(value=="0")
    			{
    				return "放弃";
    			}
    			else if(value=="1")
    			{
    				return "确认";
    			}
    			else
    			{
    				return "";
    			}
    		}
    	},
    	{field:'ICDRemark',title:'备注',sortable:true,width:100},
        {field:'ICDRowId',title:'rowid',sortable:true,width:100,hidden:true}
    ]];
    var mygrid = $HUI.datagrid("#mygrid",{
    	url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCExtIcdFeild&pClassMethod=GetMyList",
        /*url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.KB.DHCExtIcdFeild",
            QueryName:"GetList"
        },*/
    	
        columns: columns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:PageSizeMain,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        remoteSort:false,
        //ClassTableName:'User.DHCLabItmFeild',
		//SQLTableName:'DHC_LabItmFeild',
        idField:'ICDRowId',
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
    //类型下拉框
    $("#ICDType").combobox({
        valueField:'id',
        textField:'text',
        data:[
            {id:'9',text:'ICD9'},
            {id:'10',text:'ICD10'},
            {id:'99',text:'非ICD'}
        ]
    });
    //操作状态下拉框
    $("#ICDOpStatus").combobox({
        valueField:'id',
        textField:'text',
        data:[
            {id:'0',text:'放弃'},
            {id:'1',text:'确认'}
        ]
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
    //关联结果
    $('#result_btn').click(function(e){
    	disLink();
    });
    //关联指标
    $('#quota_btn').click(function(e){
    	dromeLink();
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
    	/*$('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.KB.DHCExtIcdFeild",
            QueryName:"GetList",
            desc:desc,
            code:code
        });*/
    	$('#mygrid').datagrid('options').queryParams={'code':code,'desc':desc}
		$('#mygrid').datagrid('load');
        $('#mygrid').datagrid('unselectAll');   	
    }    
    //点击重置按钮
    $('#btnRefresh').click(function(e){
		$("#TextDesc").val('');//清空检索框
		$("#TextCode").val('');
        $('#mygrid').datagrid('load',  { 
            /*ClassName:"web.DHCBL.KB.DHCExtIcdFeild",
            QueryName:"GetList"*/
        	'code':"",
			'desc':""
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
		$HUI.checkbox("#ICDAcitveFlag").setValue(true);
		$HUI.checkbox("#ICDSysFlag").setValue(true);		
	}
	SaveFunLib=function(id,flagT)
	{
		//alert(flag)
		var code=$.trim($("#ICDCode").val());
		var desc=$.trim($("#ICDDesc").val());
		var type=$("#ICDType").combobox('getValue');	
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
		if (($('#ICDType').combobox('getValue')==undefined) || ($('#ICDType').combobox('getValue')==""))
		{
			$.messager.alert('错误提示','类型不能为空，请选择下拉列表里的值！',"error");
			return;
		}
		var active="N";
		if ($('#ICDAcitveFlag').attr('checked')) 
		{
			var active="Y" ;
		}
		var flag="N";
		if ($('#ICDSysFlag').attr('checked')) 
		{
			var flag="Y" ;
		}	
		$('#form-save').form('submit', {
			url:SAVE_ACTION_URL,
			onSubmit: function(param){
                param.ICDRowId = id;
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
				$HUI.checkbox("#ICDAcitveFlag").setValue(true);
				$HUI.checkbox("#ICDSysFlag").setValue(true);				
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
			var id=record.ICDRowId;
			$.cm({
				ClassName:"web.DHCBL.KB.DHCExtIcdFeild",
				MethodName:"NewOpenData",
				id:id
			},function(jsonData){
				//给是否可用单独赋值	
				//alert(jsonData.PHLFSysFlag)		
				//alert(jsonData.PHLFActiveFlag)		
				if (jsonData.ICDAcitveFlag=="Y"){
					$HUI.checkbox("#ICDAcitveFlag").setValue(true);		
				}else{
					$HUI.checkbox("#ICDAcitveFlag").setValue(false);
				}
				if(jsonData.ICDSysFlag=="Y"){
					$HUI.checkbox('#ICDSysFlag').setValue(true);
				}else{
					$HUI.checkbox('#ICDSysFlag').setValue(false);
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
		var rowid=row.ICDRowId;
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
	disLink=function()
	{
		var record = mygrid.getSelected(); 
		if(record)
		{
			var resutText=record.ICDDesc;
			$('#disWin').show();
			var resultWin = $HUI.dialog("#disWin",{
				iconCls:'icon-textbook',
				resizable:true,
				title:resutText,
				modal:true
			});	
		var parref=record.ICDRowId;
		var parrefDesc=record.ICDDesc;				
		var url="../csp/dhc.bdp.kb.dhcphdislinksym.csp"+"?parref="+parref+"&parrefDesc="+parrefDesc;
	    //token改造 GXP 20230209
		if('undefined'!==typeof websys_getMWToken)
		{
			url+="&MWToken="+websys_getMWToken()
		}
		$('#dis_iframe').attr("src",url);
		}
		else
		{
			$.messager.alert('错误提示','请先选择一条记录!',"error");			
		}
	}
	dromeLink=function()
	{
		var record = mygrid.getSelected(); 
		if(record)
		{
			var resutText=record.ICDDesc;
			$('#dromeWin').show();
			var resultWin = $HUI.dialog("#dromeWin",{
				iconCls:'icon-textbook',
				resizable:true,
				title:resutText,
				modal:true
			});	
		var parref=record.ICDRowId;
		var parrefDesc=record.ICDDesc;				
		var url="../csp/dhc.bdp.kb.dhcphsyndromeicd.csp"+"?parref="+parref+"&parrefDesc="+parrefDesc;
		 //token改造 GXP 20230209
		if('undefined'!==typeof websys_getMWToken)
		{
			url+="&MWToken="+websys_getMWToken()
		}
		$('#drome_iframe').attr("src",url);
		}
		else
		{
			$.messager.alert('错误提示','请先选择一条记录!',"error");			
		}		
	}
}
$(init);