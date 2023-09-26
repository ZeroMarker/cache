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
	    			iconCls: 'icon-add', /// Modfied by zc 2015-07-27 ZC0026 ������ť
	                text:'����',          
	                handler: function(){
	                     SavegridData();
	                }   
	                },'------------------------',{         
	                iconCls: 'icon-save',
	                text:'����',          
	                handler: function(){
	                     SavegridData();
	                }
	                },'------------------------',{        
	                iconCls: 'icon-cut', 
	                text:'ɾ��',      
	                 handler: function(){
	                     DeleteGridData();
	                     }      
	                 },'------------------------',{        
	                iconCls: 'icon-search', 
	                text:'��ѯ',      
	                 handler: function(){
	                      findGridData();
	                     }      
	                 }] , 

	    columns:[[
	    	{field:'TComponentID',title:'ComponentID',width:50,hidden:true},
	        {field:'TSourceType',title:'SourceType',width:60,hidden:true}, 
	        {field:'TSourceTypeDesc',title:'��Դ����',width:60,align:'center'},
	        {field:'TSourceID',title:'SourceID',width:100,align:'center',hidden:true},  
	        {field:'TSource',title:'��Դ',width:100,align:'center'},  //,hidden:true
	        {field:'TComponentName',title:'�����',width:100,align:'center'},
	        {field:'TComponentDesc',title:'�������',width:100,align:'center'},
	        //{field:'TLayout',title:'����',width:100,align:'center'},
	    ]],
	    onClickRow : function (rowIndex, rowData) {
	        fillData_OnClickRow(rowIndex, rowData);
	    },
		onLoadSuccess:function(data) {     //add by mwz 2017-08-01  �����406086
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
					{field:'Desc',title:'����',width:130,align:'center'},
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
					{field:'GroupName',title:'����',width:130,align:'center'},
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
					{field:'UserName',title:'����',width:130,align:'center'},
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
		    			iconCls: 'icon-add', /// Modfied by zc 2015-07-27 ZC0026 ������ť
		                text:'����',          
		                handler: function(){
		                     SaveItemgridData();
		                }   
		                },'------------------------',{         
		                iconCls: 'icon-save',
		                text:'����',          
		                handler: function(){
		                     SaveItemgridData();
		                }
		                },'------------------------',{        
		                iconCls: 'icon-cut', 
		                text:'ɾ��',      
		                 handler: function(){
		                     DeleteItemGridData();
		                     }      
		                 },'------------------------',{        
		                iconCls: 'icon-search', 
		                text:'��ѯ',      
		                 handler: function(){
		                     findItemGridData();
		                     }      
		                 }] , 
		    columns:[[
		    	{field:'TItemID',title:'ID',width:50,hidden:true},    
		        {field:'TItemName',title:'����',width:100,align:'center'},
		        {field:'TCaption',title:'������',width:100,align:'center'},       
		        {field:'THiddenFlag',title:'Hidden',width:50,align:'center'},  
		        {field:'TItemStyle',title:'���',width:100,align:'center'}, 
		        {field:'TSort',title:'���',width:50,align:'center'},                 
		    ]],
		    onClickRow : function (rowIndex, rowData) {
		        SetData_OnClickRow(rowIndex, rowData);
		    	},
		    onLoadSuccess:function(data) {     //add by mwz 2017-08-01  �����406086
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
/// ����:����AddgridData����
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
				$.messager.show({title: '��ʾ',msg: '����ɹ�'});
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
				    alertShow("�����ɹ�!")*/
				Clear();
           		}
            	else
            	{
               		$.messager.alert('���ʧ�ܣ�',data, 'warning')
               		return;
                }
        }
	})
}

function DeleteGridData(){
    if ($('#ComponentID').val()==""){
            $.messager.alert("����", "��ѡ��һ�У�", 'error') /// Modfied by zc 2015-07-27 ZC0026
            return false;
    }else
    {
	    $.messager.confirm('��ȷ��', '��ȷ��Ҫɾ����ѡ���У�', function (b) {
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
							$.messager.show({title: '��ʾ',msg: '����ɹ�'});
							$('#ComponentSet').datagrid('reload');
							$('#ComponentSetItem').datagrid('reload');   //add by mwz �����395135  2017-06-23
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
							    alertShow("ɾ���ɹ�!")*/
							Clear();
			           		}
			            	else
			            	{
			               		$.messager.alert('ɾ��ʧ�ܣ�',data, 'warning')
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
	//Clear();  add by wy 2017-06-19 ����394670

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
	//ClearItem();	 add by wy 2017-06-19 ����394670   
}
/// Modfied by zc 2015-07-27 ZC0026
/// ����:����AddgridData����
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
		beforeSend:function(){$.messager.progress({text:'���ڱ�����'})},
       	error:function(XMLHttpRequest, textStatus, errorThrown){
                messageShow("","","",XMLHttpRequest.status);
                messageShow("","","",XMLHttpRequest.readyState);
                messageShow("","","",textStatus);
        },
        success:function (data, response, status) {
				$.messager.progress('close');
        		if (data ==0) {
				$.messager.show({title: '��ʾ',msg: '����ɹ�'});
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
               		$.messager.alert('���ʧ�ܣ�',data, 'warning')
               		return;
                }
        }
	})
}

function DeleteItemGridData(){
	
    if ($('#ItemID').val()==""){
            $.messager.alert("����", "��ѡ��һ�У�", 'error') /// Modfied by zc 2015-07-27 ZC0026
            return false;
    }else
    {
	    $.messager.confirm('��ȷ��', '��ȷ��Ҫɾ����ѡ���У�', function (b) {
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
					$.messager.show({title: '��ʾ',msg: 'ɾ���ɹ�'});
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
			               		$.messager.alert('ɾ��ʧ�ܣ�',data, 'warning')
			               		return;
			                }
		            }
		    	})
	        }         
        })
		    
	}
}
//������Ч��� Add JDL 20151020
function CheckData()
{
    if ($('#SourceType').combobox('getValue')==""){
            $.messager.alert("����", "��Դ����Ϊ�գ�", 'error')
            return false;
    }
    $('#SourceID').val('setValue','0')
    if ($('#SourceID').combogrid('getValue')==""){
            $.messager.alert("����", "��ԴΪ�գ�", 'error')
            return false;
    }
    if ($('#ComponentName').val()==""){
            $.messager.alert("����", "�����Ϊ�գ�", 'error')
            return false;
    }
	return true;
}
//������Ч��� Add JDL 20151020
function CheckItemData()
{
	if ($('#ItemName').val()==""){
           $.messager.alert("����", "Ԫ�����Ʋ���Ϊ�գ�", 'error')
           return false;
    }
    if ($('#Caption').val()==""){
            $.messager.alert("����", "Ԫ����������Ϊ�գ�", 'error')
            return false;
    }
	if ($('#ItemStyle').val()==""){
			$.messager.alert("����", "Ԫ�ظ�ʽ����Ϊ�գ�", 'error')
			return false;
	}
	if ($('#Sort').val()==""){
			$.messager.alert("����", "��Ų���Ϊ�գ�", 'error')
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


