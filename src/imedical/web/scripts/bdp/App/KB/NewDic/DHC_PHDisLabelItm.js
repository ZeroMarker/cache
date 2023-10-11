/*
* @Author: 基础数据平台-石萧伟
* @Date:   2018-08-17 15:41:35
* @Last Modified by:   admin
* @Last Modified time: 2018-09-28 14:49:03
* @描述:诊断逻辑明细目录
*/
var SAVE_ACTION_URL_LabelItm = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDisLabelItm&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHDisLabelItm";
var DELETE_ACTION_URL_LabelItm = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDisLabelItm&pClassMethod=DeleteData";
init=function()
{
	if(parrefDesc=="症状" || parrefDesc=="诊断")
	{
		var columns =[[
	        {field:'PHEGDesc',title:'通用名',sortable:true,width:100,hidden:true},
	        {field:'PDLIVal',title:'检验值',sortable:true,width:100,hidden:true},
	        {field:'PDLIOperator',title:'运算符',sortable:true,width:100,
	        	formatter: function(value,row,index)
	        	{
	        		if (value==">")
	        		{
	        		   return "大于";
	        		}
	        		if (value=="<")
	        		{
	        		   return "小于";
	        		}
	        		if (value=="=")
	        		{
	        		   return "等于";
	        		}
	        		if (value=="!>")
	        		{
	        		   return "不大于";
	        		}
	        		if (value=="!<")
	        		{
	        		   return "不小于";
	        		}
	        		if (value=="<>")
	        		{
	        		   return "不等于";
	        		}
	        	},hidden:true
	    	},
	        {field:'PDLIResultText',title:'结果',sortable:true,width:100,
	        	formatter: function(value,row,index)
	        	{
	        		if (value=="H")
	        		{
	        		   return "高";
	        		}
	        		if (value=="L")
	        		{
	        		   return "低";
	        		}
	        		if (value=="N")
	        		{
	        		   return "正常";
	        		}
	        		if (value=="I")
	        		{
	        		   return "包含";
	        		}
	        		if (value=="NT")
	        		{
	        		   return "阳性";
	        		}
	        		if (value=="PT")
	        		{
	        		   return "阴性";
	        		}
	        	},hidden:true	        	
	    	},
	    	{field:'PHKWDesc',title:'关联项目',sortable:true,width:100},
	    	{field:'PDLIRelation',title:'逻辑',sortable:true,width:100,
		    	formatter: function(value,row,index)
	        	{
				    if (value=="O")
		    		{
		    		   return "Or";
		    		}
		    		if (value=="A")
		    		{
		    		   return "And";
		    		}
	        	},hidden:true
	    	},
	        {field:'PDLISysFlag',title:'是否系统标识',sortable:true,width:100,
	            formatter:ReturnFlagIcon,hidden:true
	        },         
	        {field:'PDLIRowId',title:'rowid',sortable:true,width:100,hidden:true}
	    ]];
	}
	else if(parrefDesc=="检查" || parrefDesc=="检验")
	{
		var columns =[[
	        {field:'PHEGDesc',title:'通用名',sortable:true,width:100},
	        {field:'PDLIVal',title:'检验值',sortable:true,width:100},
	        {field:'PDLIOperator',title:'运算符',sortable:true,width:100,
	        	formatter: function(value,row,index)
	        	{
	        		if (value==">")
	        		{
	        		   return "大于";
	        		}
	        		if (value=="<")
	        		{
	        		   return "小于";
	        		}
	        		if (value=="=")
	        		{
	        		   return "等于";
	        		}
	        		if (value=="!>")
	        		{
	        		   return "不大于";
	        		}
	        		if (value=="!<")
	        		{
	        		   return "不小于";
	        		}
	        		if (value=="<>")
	        		{
	        		   return "不等于";
	        		}
	        	}
	    	},
	        {field:'PDLIResultText',title:'结果',sortable:true,width:100,
	        	formatter: function(value,row,index)
	        	{
	        		if (value=="H")
	        		{
	        		   return "高";
	        		}
	        		if (value=="L")
	        		{
	        		   return "低";
	        		}
	        		if (value=="N")
	        		{
	        		   return "正常";
	        		}
	        		if (value=="I")
	        		{
	        		   return "包含";
	        		}
	        		if (value=="NT")
	        		{
	        		   return "阴性";
	        		}
	        		if (value=="PT")
	        		{
	        		   return "阳性";
	        		}
	        	}	        	
	    	},
	    	{field:'PHKWDesc',title:'关联项目',sortable:true,width:100,hidden:true},
	    	{field:'PDLIRelation',title:'逻辑',sortable:true,width:100,
		    	formatter: function(value,row,index)
	        	{
				    if (value=="O")
		    		{
		    		   return "Or";
		    		}
		    		if (value=="A")
		    		{
		    		   return "And";
		    		}
	        	}
	    	},
	        {field:'PDLISysFlag',title:'是否系统标识',sortable:true,width:100,
	            formatter: function(value,row,index){
	                    if(value=='N')  
	                    {
	                        return "<img  src='../scripts/bdp/Framework/icons/no.png' style='border: 0px'><span>"
	                    }
	                    else if(value=='Y') 
	                    {
	                    	return "<img src='../scripts/bdp/Framework/icons/yes.png' style='border: 0px'><span>";
	                    }
	            }
	        },         
	        {field:'PDLIRowId',title:'rowid',sortable:true,width:100,hidden:true}
	    ]];		
	}
    var itmgrid = $HUI.datagrid("#itmgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.KB.DHCPHDisLabelItm",
            QueryName:"GetList",
            pdliid:parref
        },
        columns: columns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:PageSizeMain,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        remoteSort:false,
        //ClassTableName:'User.DHCLabItmResult',
		//SQLTableName:'DHC_LabItmResult',
        idField:'PDLIRowId',
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
    $('#add_btn').click(function(){
    	addData();
    });
    $('#update_btn').click(function(){
    	updateData();
    });
    $('#del_btn').click(function(){
    	delData();
    });
    delData=function()
    {
 		var row = $("#itmgrid").datagrid("getSelected"); 
		if (!(row))
		{	$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var rowid=row.PDLIRowId;
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
			if (r){
				$.ajax({
					url:DELETE_ACTION_URL_LabelItm,  
					data:{"id":rowid},  
					type:"POST",   
					//dataType:"TEXT",  
					success: function(data){
							  var data=eval('('+data+')'); 
							  if (data.success == 'true') {
								$.messager.show({ 
								  title: '提示消息', 
								  msg: '删除成功', 
								  showType: 'show', 
								  timeout: 1000, 
								  style: { 
									right: '', 
									bottom: ''
								  } 
								}); 
								 $('#itmgrid').datagrid('reload');  // 重新载入当前页面数据 
								 $('#itmgrid').datagrid('unselectAll');  // 清空列表选中数据 
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
  	updateData=function()
	{
    	if(parrefDesc=="症状" || parrefDesc=="诊断")
    	{
    		$('#gendrid').hide();
    		$('#valid').hide();
    		$('#operatorid').hide();
    		$('#resultid').hide();
    		$('#relationid').hide();
    		$('#flagid').hide();
    		$('#keywordid').show();
    	}
    	else
    	{
    		$('#gendrid').show();
    		$('#valid').show();
    		$('#operatorid').show();
    		$('#resultid').show();
    		$('#relationid').show();
    		$('#flagid').show();
    		$('#keywordid').hide();
    	}		
		var record = itmgrid.getSelected(); 
		if(record)
		{
			var id=record.PDLIRowId;
			$.cm({
				ClassName:"web.DHCBL.KB.DHCPHDisLabelItm",
				MethodName:"NewOpenData",
				id:id
			},function(jsonData){
				//alert(jsonData.PDPLabelDr)
				if (jsonData.PDLISysFlag=="Y"){
					$HUI.checkbox("#PDLISysFlag").setValue(true);		
				}else{
					$HUI.checkbox("#PDLISysFlag").setValue(false);
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
						saveFunLib(id,1)
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
    saveFunLib=function(id,flagT)
    {
    	if(parrefDesc=="症状" || parrefDesc=="诊断")
    	{
    		var desc=$('#PDLIKeyWord').combobox('getValue');
    		if(desc=="")
	    	{
				$.messager.alert('错误提示','关联项目不能为空!',"error");
				return;    		
	    	} 
    	}
    	else
    	{
    		var desc=$('#PDLIGenDr').combobox('getValue');
	    	if(desc=="")
	    	{
				$.messager.alert('错误提示','通用名不能为空!',"error");
				return;    		
	    	}     		
    	}   	
		$('#PDLIId').val(parref);		
		$('#form-save').form('submit', {
			url:SAVE_ACTION_URL_LabelItm,
			onSubmit: function(param){
                param.PDLIRowId = id;
            },
			success: function (data) { 
			  	var data=eval('('+data+')'); 
			  	if (data.success == 'true') {
					$.messager.show({ 
				 	title: '提示消息', 
				  	msg: '提交成功', 
				  	showType: 'show', 
				  	timeout: 1000, 
				  	style: { 
					right: '', 
					bottom: ''
				  	} 
				}); 
				$('#itmgrid').datagrid('reload');  // 重新载入当前页面数据 
				if(flagT==1)
				{
					$('#myWin').dialog('close'); // close a dialog
				}
				else
				{
					$('#form-save').form("clear");
					$HUI.checkbox("#PDLISysFlag").setValue(true);
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
    if(parrefDesc=="检验")
    {
	    $('#PDLIGenDr').combobox({
	        url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtGeneric&QueryName=GetDataForCmb1&ResultSetType=array&code=LAB",
	        valueField:'PHEGRowId',
	        textField:'PHEGDesc'
	        //mode:'remote', 
	    });	     
    }
    if(parrefDesc=="检查")
    {
	    $('#PDLIGenDr').combobox({
	        url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtGeneric&QueryName=GetDataForCmb1&ResultSetType=array&code=CHECK",
	        valueField:'PHEGRowId',
	        textField:'PHEGDesc'
	        //mode:'remote', 
	    });     	
    }
    //运算符
	$('#PDLIOperator').combobox({
        valueField:'id',
        textField:'text',
        data:[
			{id:'>',text:'大于'},
			{id:'<',text:'小于'},
			{id:'=',text:'等于'},
			{id:'!>',text:'不大于'},
			{id:'!<',text:'不小于'},
			{id:'<>',text:'不等于'}	
		]
    }); 
	//逻辑下拉框
	$('#PDLIRelation').combobox({
        valueField:'id',
        textField:'text',
        data:[
			{id:'O',text:'Or'},
			{id:'A',text:'And'}	
		]
    });
    //运算符
	$('#PDLIResultText').combobox({
        valueField:'id',
        textField:'text',
        data:[
			{id:'H',text:'高'},
			{id:'L',text:'低'},
			{id:'N',text:'正常'},
			{id:'I',text:'包含'},
			{id:'NT',text:'阴性'},
			{id:'PT',text:'阳性'}	
		]
    }); 
    $('#PDLIKeyWord').combobox({
        url:$URL+"?ClassName=web.DHCBL.KB.DHCPHDiseaseGuide&QueryName=GetIDDataForCmb&ResultSetType=array&labeldr="+labeldr,
        valueField:'RowId',
        textField:'Desc'
        //mode:'remote', 
    });                           
    addData=function()
    {
    	//singleselect=true;
    	if(parrefDesc=="症状" || parrefDesc=="诊断")
    	{
    		$('#gendrid').hide();
    		$('#valid').hide();
    		$('#operatorid').hide();
    		$('#resultid').hide();
    		$('#relationid').hide();
    		$('#flagid').hide();
    		$('#keywordid').show();
    	}
    	else
    	{
    		$('#gendrid').show();
    		$('#valid').show();
    		$('#operatorid').show();
    		$('#resultid').show();
    		$('#relationid').show();
    		$('#flagid').show();
    		$('#keywordid').hide();
    	}
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
					saveFunLib("",1)
				}
			},
			{
				text:'继续新增',
				id:'save_goon',
				handler:function(){
					saveFunLib("",2)
				}
			},{
				text:'关闭',
				handler:function(){
					myWin.close();
				}
			}]
		});
		$('#form-save').form("clear");
		$HUI.checkbox("#PDLISysFlag").setValue(true);		
    }     	
}
$(init);