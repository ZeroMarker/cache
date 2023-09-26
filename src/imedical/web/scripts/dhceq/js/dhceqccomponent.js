var SelectedRowID = 0;
var PreSelectedRowID = 0;
var ItemSelectedRowID = 0;
var PreItemSelectedRowID = 0;
var InitItemGridFlag=0

$(document).ready(function () {
	//var str=window.location.search.substr(1);
   	//var list=str.split("=");
   	//var tid=list[1]
	//$('#trComponentSet').hide();
	//$('#trComponentSetItem').hide();
	//initDocument();
	$('#ComponentSet').datagrid({  
	    url:'dhceq.jquery.csp', 
	    queryParams:{
	        ClassName:"web.DHCEQComponent",
	        QueryName:"GetComponentSet",
	        Arg1:$("#SourceType").combobox("getValue"),
	        Arg2:$("#SourceID").combogrid("getValue"),
	        Arg3:$("#ComponentName").val(),  //"",
	        Arg4:$("#ComponentDesc").val(),  //"",
	        ArgCnt:4
	    },
	    border:'true',
	    fit:true,
	    singleSelect:true,
	    toolbar:[{  
	    			iconCls: 'icon-add', /// Modfied by zc 2015-07-27 ZC0026 新增按钮
	                text:'新增',          
	                handler: function(){
	                     SavegridData();
	                }   
	                },'------------------------',{         
	                iconCls: 'icon-save',
	                text:'更新',          
	                handler: function(){
	                     SavegridData();
	                }
	                },'------------------------',{        
	                iconCls: 'icon-cut', 
	                text:'删除',      
	                 handler: function(){
	                     DeleteGridData();
	                     }      
	                 },'------------------------',{        
	                iconCls: 'icon-search', 
	                text:'查询',      
	                 handler: function(){
	                      findGridData();
	                     }      
	                 }] , 

	    columns:[[
	    	{field:'TComponentID',title:'ComponentID',width:50,hidden:true},
	        {field:'TSourceType',title:'SourceType',width:60,hidden:true}, 
	        {field:'TSourceTypeDesc',title:'来源类型',width:60,align:'center'},
	        {field:'TSourceID',title:'SourceID',width:100,align:'center',hidden:true},  
	        {field:'TSource',title:'来源',width:100,align:'center'},  //,hidden:true
	        {field:'TComponentName',title:'组件名',width:100,align:'center'},
	        {field:'TComponentDesc',title:'组件描述',width:100,align:'center'},
	        //{field:'TLayout',title:'布局',width:100,align:'center'},
	    ]],
	    onClickRow : function (rowIndex, rowData) {
	        fillData_OnClickRow(rowIndex, rowData);
	    },
		onLoadSuccess:function(data) {     //add by mwz 2017-08-01  需求号406086
	        Clear();         
	        PreSelectedRowID=0
			SelectedRowID=0
	        },
	    pagination:true,
	    pageSize:12,
	    pageNumber:1,
	    pageList:[12,24,36] 
	});
$("#SourceType").combobox({
	onChange: function(SourceType,TSourceType){
		if($("#SourceType").combobox("getValue")==0)
		{
			$("#SourceID").combogrid({
				disabled:true
			})
    		$('#SourceID').combogrid('setValue','0')
			//$("#SourceID").combogrid("getValue")==0
		}

		if($("#SourceType").combobox("getValue")==1)
		{
			$("#SourceID").combogrid({
				disabled:false,
				idField:'Hidden',
				textField:'Desc',
				url:'dhceq.jquery.csp',
				queryParams:{
					ClassName:'web.DHCEQFind',
					QueryName:'GetHospital',
					Arg1:'',
					ArgCnt:1
					},
				columns:[[
					{field:'Desc',title:'类型',width:130,align:'center'},
				]]
			});	
		
		}
		if($("#SourceType").combobox("getValue")==2)
		{
			$("#SourceID").combogrid({
				disabled:false,
				idField:'GroupID',
				textField:'GroupName',
				url:'dhceq.jquery.csp',
				queryParams:{
					ClassName:'web.DHCEQFind',
					QueryName:'Group',
					Arg1:'',
					ArgCnt:1
					},
				columns:[[
					{field:'GroupName',title:'类型',width:130,align:'center'},
				]]
			});	
		
		}
		if($("#SourceType").combobox("getValue")==3)
		{
			$("#SourceID").combogrid({
				disabled:false,
				idField:'Hidden',
				textField:'UserName',
				url:'dhceq.jquery.csp',
				queryParams:{
					ClassName:'web.DHCEQFind',
					QueryName:'User',
					Arg1:'',
					ArgCnt:1
					},
				columns:[[
					{field:'UserName',title:'类型',width:130,align:'center'},
				]]
			});	
		
		}
		}
});
//GAI
function fillData_OnClickRow(rowIndex, rowData)
{
	
	SelectedRowID=rowData.TComponentID
	if (PreSelectedRowID!=SelectedRowID)
	{
		ClearItem();  //add by lmm 2017-07-31 406071
		$('#ComponentID').val(rowData.TComponentID);
		$('#ComponentName').val(rowData.TComponentName);
		$('#Layout').val(rowData.TLayout);
		$('#SourceType').combobox('setValue',rowData.TSourceType);
		$('#SourceID').combogrid('setValue',rowData.TSourceID);
		$('#Source').val(rowData.TSource);
		$('#ComponentDesc').val(rowData.TComponentDesc);
		PreSelectedRowID=SelectedRowID
	}
	else
	{
		Clear();
		PreSelectedRowID=0
		SelectedRowID=0
	}
	InitComponentItemData(PreSelectedRowID)
}
function InitComponentItemData(PreSelectedRowID)
{
	if (InitItemGridFlag==1)
	{
		$('#ComponentSetItem').datagrid('reload',{
		        ClassName:"web.DHCEQComponent",
		        QueryName:"GetComponentSetItem",
		        Arg1:PreSelectedRowID,
		        Arg2:$("#ItemName").val(),
		        Arg3:$("#Caption").val(),
		        Arg4:1,
		        ArgCnt:4
		    });
	}
	else
	{
		InitItemGridFlag=1
		$('#ComponentSetItem').datagrid({   
		    url:'dhceq.jquery.csp', 
		    queryParams:{
		        ClassName:"web.DHCEQComponent",
		        QueryName:"GetComponentSetItem",
		        Arg1:PreSelectedRowID,
		        Arg2:$("#ItemName").val(),
		        Arg3:$("#Caption").val(),
		        Arg4:1,
		        ArgCnt:4
		    },
		    border:'true',
		    fit:true,
		    singleSelect:true,
		    toolbar:[{  
		    			iconCls: 'icon-add', /// Modfied by zc 2015-07-27 ZC0026 新增按钮
		                text:'新增',          
		                handler: function(){
		                     SaveItemgridData();
		                }   
		                },'------------------------',{         
		                iconCls: 'icon-save',
		                text:'更新',          
		                handler: function(){
		                     SaveItemgridData();
		                }
		                },'------------------------',{        
		                iconCls: 'icon-cut', 
		                text:'删除',      
		                 handler: function(){
		                     DeleteItemGridData();
		                     }      
		                 },'------------------------',{        
		                iconCls: 'icon-search', 
		                text:'查询',      
		                 handler: function(){
		                     findItemGridData();
		                     }      
		                 }] , 
		    columns:[[
		    	{field:'TItemID',title:'ID',width:50,hidden:true},    
		        {field:'TItemName',title:'列名',width:100,align:'center'},
		        {field:'TCaption',title:'列描述',width:100,align:'center'},       
		        {field:'THiddenFlag',title:'Hidden',width:50,align:'center'},  
		        {field:'TItemStyle',title:'风格',width:100,align:'center'}, 
		        {field:'TSort',title:'序号',width:50,align:'center'},                 
		    ]],
		    onClickRow : function (rowIndex, rowData) {
		        SetData_OnClickRow(rowIndex, rowData);
		    	},
		    onLoadSuccess:function(data) {     //add by mwz 2017-08-01  需求号406086
	        ClearItem();         
	        PreItemSelectedRowID=0
			ItemSelectedRowID=0
	        },
		    pagination:true,
		    pageSize:12,
		    pageNumber:1,
		    pageList:[12,24,36]  
		});
	}
}
function SetData_OnClickRow(rowIndex, rowData)
{
	ItemSelectedRowID=rowData.TItemID
	if (PreItemSelectedRowID!=ItemSelectedRowID)
	{
		$('#ItemID').val(rowData.TItemID);
		$('#ItemName').val(rowData.TItemName);
		$('#Caption').val(rowData.TCaption);
		$('#ItemStyle').val(rowData.TItemStyle);
		$('#Sort').val(rowData.TSort);
		SetCheckValue("HiddenFlag",rowData.THiddenFlag)
		PreItemSelectedRowID=ItemSelectedRowID
	}
	else
	{
		ClearItem();
		SetCheckValue("HiddenFlag","")
		PreItemSelectedRowID=0
		ItemSelectedRowID=0
	}
}

/// Modfied by zc 2015-07-27 ZC0026
/// 描述:新增AddgridData方法
function SavegridData(){
	//$("#SourceID").combogrid("getValue")=0
	if (CheckData()==false) return false;
	$.ajax({
    	//async: false,
		url :"dhceq.jquery.method.csp",
		type:"POST",
        data:{
	        ClassName:"web.DHCEQComponent",
	        MethodName:"SaveComponent",
                Arg1:$('#ComponentID').val(),
                Arg2:$('#SourceType').combobox('getValue'),
                Arg3:$('#SourceID').combogrid("getValue"),
				Arg4:$('#ComponentName').val(),
				Arg5:"",
                ArgCnt:5
	    },
       	error:function(XMLHttpRequest, textStatus, errorThrown){
                messageShow("","","",XMLHttpRequest.status);
                messageShow("","","",XMLHttpRequest.readyState);
                messageShow("","","",textStatus);
        },
        success:function (data, response, status) {
				$.messager.progress('close');
        		if (data ==0) {
				$.messager.show({title: '提示',msg: '保存成功'});
				$('#ComponentSet').datagrid('reload');
	        		/*
				$('#ComponentSet').datagrid('reload',{
				        ClassName:"web.DHCEQComponent",
				        QueryName:"GetComponentSet",
				        Arg1:$("#SourceType").combobox("getValue"),
				        Arg2:$("#SourceID").combogrid("getValue"),
				        Arg3:$("#ComponentName").val(),  //"",
				        Arg4:$("#ComponentDesc").val(),  //"",
				        ArgCnt:4
				    });
				    alertShow("操作成功!")*/
				Clear();
           		}
            	else
            	{
               		$.messager.alert('添加失败！',data, 'warning')
               		return;
                }
        }
	})
}

function DeleteGridData(){
    if ($('#ComponentID').val()==""){
            $.messager.alert("错误", "请选中一行！", 'error') /// Modfied by zc 2015-07-27 ZC0026
            return false;
    }else
    {
	    $.messager.confirm('请确认', '您确定要删除所选的行？', function (b) {
	        if (b==false)
	        {
	             return;
	        }
	        else
	        {
				$.ajax({
			    	//async: false,
					url :"dhceq.jquery.method.csp",
					type:"POST",
			        data:{
				        ClassName:"web.DHCEQComponent",
				        MethodName:"DeleteComponent",
		                Arg1:$('#ComponentID').val(),
		                ArgCnt:1
				    },
			       	error:function(XMLHttpRequest, textStatus, errorThrown){
		                    messageShow("","","",XMLHttpRequest.status);
		                    messageShow("","","",XMLHttpRequest.readyState);
		                    messageShow("","","",textStatus);
			        },
		            success:function (data, response, status) {
	        				$.messager.progress('close');
		            		if (data ==0) {
							$.messager.show({title: '提示',msg: '保存成功'});
							$('#ComponentSet').datagrid('reload');
							$('#ComponentSetItem').datagrid('reload');   //add by mwz 需求号395135  2017-06-23
							/*
							$('#ComponentSet').datagrid('reload',{
							        ClassName:"web.DHCEQComponent",
							        QueryName:"GetComponentSet",
							        Arg1:$("#SourceType").combobox("getValue"),
				       				Arg2:$("#SourceID").combogrid("getValue"),
							        Arg3:$("#ComponentName").val(),  //"",
							        Arg4:$("#ComponentDesc").val(),  //"",
							        ArgCnt:4
							    });
							    alertShow("删除成功!")*/
							Clear();
			           		}
			            	else
			            	{
			               		$.messager.alert('删除失败！',data, 'warning')
			               		return;
			                }
		            }
		    	})
	        }         
        })
		    
	}
}
function findGridData()
{
	$('#ComponentSet').datagrid({
		url:'dhceq.jquery.csp',
		queryParams:{
	        ClassName:"web.DHCEQComponent",
	        QueryName:"GetComponentSet",
	        Arg1:$('#SourceType').combobox('getValue'), //"0", 
			Arg2:$("#SourceID").combogrid("getValue"),
	        Arg3:$("#ComponentName").val(),
	        Arg4:$("#ComponentDesc").val(),  //"",
	        ArgCnt:4
		}
	    });
	//Clear();  add by wy 2017-06-19 需求：394670

}
function findItemGridData()
{
	$('#ComponentSetItem').datagrid({
		url:'dhceq.jquery.csp',
		queryParams:{
	        ClassName:"web.DHCEQComponent",
	        QueryName:"GetComponentSetItem",
		    Arg1:PreSelectedRowID,
		    Arg2:$("#ItemName").val(),
		    Arg3:$("#Caption").val(),
		    Arg4:1,
	        ArgCnt:4
		}
	    });
	//ClearItem();	 add by wy 2017-06-19 需求：394670   
}
/// Modfied by zc 2015-07-27 ZC0026
/// 描述:新增AddgridData方法
function SaveItemgridData(){
	if (CheckItemData()==false) return false;
	$.ajax({
    	//async: false,
		url :"dhceq.jquery.method.csp",
		type:"POST",
        data:{
            ClassName:"web.DHCEQComponent",
            MethodName:"SaveComponentItem",
                Arg1:$('#ItemID').val(),
                Arg2:$('#ComponentID').val(),
                Arg3:$('#ItemName').val(),
                Arg4:$('#Caption').val(),
                Arg5:$('#ItemStyle').val(),
                Arg6:$('#Sort').val(),
        		Arg7:GetCheckValue("HiddenFlag"),
                ArgCnt:7
	    },
		beforeSend:function(){$.messager.progress({text:'正在保存中'})},
       	error:function(XMLHttpRequest, textStatus, errorThrown){
                messageShow("","","",XMLHttpRequest.status);
                messageShow("","","",XMLHttpRequest.readyState);
                messageShow("","","",textStatus);
        },
        success:function (data, response, status) {
				$.messager.progress('close');
        		if (data ==0) {
				$.messager.show({title: '提示',msg: '保存成功'});
				$('#ComponentSetItem').datagrid('reload');
				/*
				$('#ComponentSetItem').datagrid('reload',{
				        ClassName:"web.DHCEQComponent",
				        QueryName:"GetComponentSetItem",
				        Arg1:PreSelectedRowID,
				        Arg2:$("#ItemName").val(),
				        Arg3:$("#Caption").val(),
				        Arg4:1,
				        ArgCnt:4
				    });*/
				ClearItem();
           		}
            	else
            	{
               		$.messager.alert('添加失败！',data, 'warning')
               		return;
                }
        }
	})
}

function DeleteItemGridData(){
	
    if ($('#ItemID').val()==""){
            $.messager.alert("错误", "请选中一行！", 'error') /// Modfied by zc 2015-07-27 ZC0026
            return false;
    }else
    {
	    $.messager.confirm('请确认', '您确定要删除所选的行？', function (b) {
	        if (b==false)
	        {
	             return;
	        }
	        else
	        {
				$.ajax({
			    	//async: false,
					url :"dhceq.jquery.method.csp",
					type:"POST",
			        data:{
				        ClassName:"web.DHCEQComponent",
				        MethodName:"DeleteComponentItem",
		                Arg1:$('#ItemID').val(),
		                ArgCnt:1
				    },
			       	error:function(XMLHttpRequest, textStatus, errorThrown){
		                    messageShow("","","",XMLHttpRequest.status);
		                    messageShow("","","",XMLHttpRequest.readyState);
		                    messageShow("","","",textStatus);
			        },
		            success:function (data, response, status) {
	        				$.messager.progress('close');
		            		if (data ==0) {
					$.messager.show({title: '提示',msg: '删除成功'});
					$('#ComponentSetItem').datagrid('reload');
					ClearItem();
			            		/*
							$('#ComponentSetItem').datagrid('reload',{
							        ClassName:"web.DHCEQComponent",
							        QueryName:"GetComponentSetItem",
							        Arg1:PreSelectedRowID,
							        Arg2:$("#ItemName").val(),
							        Arg3:$("#Caption").val(),
							        Arg4:1,
							        ArgCnt:4
							    });
							 ClearItem();*/
			           		}
			            	else
			            	{
			               		$.messager.alert('删除失败！',data, 'warning')
			               		return;
			                }
		            }
		    	})
	        }         
        })
		    
	}
}
//数据有效检测 Add JDL 20151020
function CheckData()
{
    if ($('#SourceType').combobox('getValue')==""){
            $.messager.alert("错误", "来源类型为空！", 'error')
            return false;
    }
    $('#SourceID').val('setValue','0')
    if ($('#SourceID').combogrid('getValue')==""){
            $.messager.alert("错误", "来源为空！", 'error')
            return false;
    }
    if ($('#ComponentName').val()==""){
            $.messager.alert("错误", "组件名为空！", 'error')
            return false;
    }
	return true;
}
//数据有效检测 Add JDL 20151020
function CheckItemData()
{
	if ($('#ItemName').val()==""){
           $.messager.alert("错误", "元素名称不能为空！", 'error')
           return false;
    }
    if ($('#Caption').val()==""){
            $.messager.alert("错误", "元素描述不能为空！", 'error')
            return false;
    }
	if ($('#ItemStyle').val()==""){
			$.messager.alert("错误", "元素格式不能为空！", 'error')
			return false;
	}
	if ($('#Sort').val()==""){
			$.messager.alert("错误", "序号不能为空！", 'error')
			return false;
	}
	return true;
}
function Clear()
{
	$('#ComponentID').val("");
	$('#ComponentName').val("");
	$('#ComponentDesc').val("");
	//$('#Layout').val("");
	$('#SourceType').combobox('setValue',"");
	$('#SourceID').combogrid('setValue','');
	$('#SourceID').combogrid('setText','');
	$('#Source').val("");
}
function ClearItem()
{
	$('#ItemID').val("");
	$('#ItemName').val("");
	$('#Caption').val("");
	$('#ItemStyle').val("");
	$('#Sort').val("");
	SetCheckValue("HiddenFlag","")
}
});


