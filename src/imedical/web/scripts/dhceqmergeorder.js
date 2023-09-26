var SelectedRowID = 0;
var PreSelectedRowID = 0;
var editFlag="undefined";
var MergeOrdercolumns=GetCurColumnsInfo('EM.G.MergeOrder.DisuseList','','',''); 
var DisuseRequestcolumns=GetCurColumnsInfo('EM.G.MergeOrder.Disuse','','',''); 
$(document).ready(function (){
	initUseLocPanel();			//����
	initUseLocData();
	//initEquipPanel();
	//initEquipData();
	//$(selector).linkbutton({disabled:true});
	filldata($("#RowID").val())
		$('#DHCEQDisuse').datagrid({  
	    url:'dhceq.jquery.csp', 
	    queryParams:{
	        ClassName:"web.DHCEQBatchDisuseRequest",
	        QueryName:"GetDisuseRequest",
	        Arg1:Combindata(),
	        ArgCnt:1
	    },
	    idField:'TRowID', //����
	    border:'true',
	    fit:true,
	    singleSelect:true,
	    toolbar:[{  
	    			iconCls: 'icon-search', 
	                text:'��ѯ',          
	                handler: function(){
	                     findGridData();
	                }   
	                },'------------------------',{   
                 	id:"add",
	                iconCls: 'icon-redo', 
	                text:'����',      
	                 handler: function(){
	                     SavegridData();
	                     }      
	                 }] , 

	    columns:DisuseRequestcolumns,
	    /*[[
	    	{field:'TRowID',title:'TRowID',width:50,hidden:true}, 
	    	{field:'TCheckFlag',title:'TCheckFlag',width:50,align:'center',checkbox:true}, 
	    	{field:'TEquipDR',title:'TEquipDR',width:50,hidden:true},
	        {field:'TEquip',title:'�豸����',width:100,align:'center'},
	        {field:'TRequestNo',title:'���ϵ���',width:100,align:'center'},  
	        {field:'TNo',title:'�豸���',width:100,align:'center'},
	        {field:'TRequestLocDR',title:'TRequestLocDR',width:100,align:'center',hidden:true},  
	        {field:'TUseLoc',title:'ʹ�ÿ���',width:100,align:'center',align:'center'},  
	        {field:'TPrice',title:'ԭֵ',width:100,align:'center'},
	        {field:'TTotalFee',title:'���',width:100,align:'center'},
	        {field:'TQuantity',title:'����',width:100,align:'center'},
	    ]],*/
	    selectOnCheck: false,
	    pagination:true,
	    pageSize:12,
	    pageNumber:1,
	    pageList:[12,24,36] 
	});
	
	
	$('#DHCEQMergeOrder').datagrid({  
	    url:'dhceq.jquery.csp', 
	    queryParams:{
	        ClassName:"web.DHCEQMergeOrder",
	        QueryName:"GetMergeOrderList",
	        Arg1:$("#RowID").val(),
	        ArgCnt:1
	    },
	    border:'true',
	    fit:true,
	    singleSelect:true,
	    toolbar:[{     
                	id:"add",
	                iconCls: 'icon-save',
	                text:'����',          
	                handler: function(){
	                     SavegridData();
	                }
	                },'------------------------',{   
                 	id:"submit",
	                iconCls: 'icon-ok', 
	                text:'�ύ',      
	                 handler: function(){
	                     SubmitgridData();
	                     }      
	                 },'------------------------',{   
                	id:"delete",       
	                iconCls: 'icon-no', 
	                text:'ɾ��',      
	                 handler: function(){
	                     DeleteGridData();
	                     }      
	                 },'------------------------',{   
                	id:"clear",       
	                iconCls: 'icon-cut', 
	                text:'���',      
	                 handler: function(){
	                     ClearGridData();
	                     }      
	                 }] , 

	    columns: MergeOrdercolumns,
	   /*[[
	    	{field:'TRowID',title:'TRowID',width:50,hidden:true}, 
	    	{field:'TMergeOrderDR',title:'TMergeOrderDR',hidden:true},
	    	{field:'TSourceID',title:'TSourceID',hidden:true},
	        {field:'TRequestNo',title:'���ϵ���',width:100,align:'center'},  
	        {field:'TNo',title:'�豸���',width:100,align:'center'},
	        {field:'TRequestLocDR',title:'TRequestLocDR',width:100,align:'center',hidden:true},  
	        {field:'TUserLoc',title:'ʹ�ÿ���',width:100,align:'center',align:'center',hidden:true},  
	        {field:'TEquip',title:'�豸����',width:100,align:'center'},
	        {field:'TOriginalFee',title:'ԭֵ',width:100,align:'center'},
	        {field:'TQuantityNum',title:'����',width:30,align:'center'},
	        {field:'TRequestNum',title:'��������',width:60,align:'center',editor:'numberbox'},
	        {field:'TAduitNum',title:'��������',width:60,align:'center',hidden:true},
	        {field:'TRemark',title:'��ע',width:60,align:'center',editor:'text'},
	        {field:'TDeleteList',title:'ɾ��',width:60,align:'center',
	        formatter:function(value,row,index){
			var MOLID = '<a href="#"  onclick="deleterow('+row.TRowID+')">ɾ��</a> '; return MOLID; 
	 		}},
	    ]],*/
	    //selectOnCheck: false,
	    pagination:true,
	    pageSize:12,
	    pageNumber:1,
	    pageList:[12,24,36],
 		onAfterEdit: function (rowIndex, rowData, changes) {
                console.info(rowData);
        },        
        onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    	if ((editFlag=="undefined")&&($("#Status").val()=="0"))
            {
	            jQuery("#DHCEQMergeOrder").datagrid('beginEdit', rowIndex);
	            editFlag =rowIndex;
            }
            else
	    	{
                jQuery("#DHCEQMergeOrder").datagrid('endEdit', editFlag); 
                editFlag ="undefined";
            } 
        }
        ,
		onLoadSuccess:function(data){
			var copyrows=[]
			var rows = $("#DHCEQMergeOrder").datagrid("getRows"); //��δ����ǻ�ȡ��ǰҳ�������С�
			for(var i=0;i<rows.length;i++)
			{
				//������ObjCertInfo��ֵ
				copyrows.push(rows[i]);	
				//alert(GlobalObj.MergeOrderList(rows[i].TRowID))		
			}
		}
	});
	if(($("#Status").val()=="0")||($("#Status").val()==""))
	{
		jQuery("#add").linkbutton('enable');	
		jQuery("#submit").linkbutton('enable');	
		jQuery("#delete").linkbutton('enable');	
	}
	else if($("#Status").val()=="1")
	{
		jQuery("#add").linkbutton('disable');	
		jQuery("#submit").linkbutton('disable');	
		jQuery("#delete").linkbutton('disable');	
		$('#DHCEQMergeOrder').datagrid('hideColumn','TDeleteList')
	}
	
	var TDeleteList=$("#DHCEQMergeOrder").datagrid('getColumnOption','TDeleteList');
	TDeleteList.formatter=	function(value,row,index){
			var MOLID = '<a href="#"  onclick="deleterow('+row.TRowID+')">ɾ��</a> '; return MOLID; 		
		}	
	
	

});

///add by lmm 2017-08-22 
///���ϵ���ѯ����
function Combindata()
{
	var	val="^ReplacesAD=";
	val=val+"^ApproveRole=";
	val=val+"^Type=";
	val=val+"^StatusDR=1";
	val=val+"^Status=";
	val=val+"^EquipDR=";  //+GlobalObj.EquipDR
	val=val+"^RequestLocDR=";
	val=val+"^EquipTypeDR=";
	val=val+"^PurchaseTypeDR=";	
	val=val+"^StartDate="+changeDateformat($('#StartDate').datebox('getText'));
	val=val+"^EndDate="+changeDateformat($('#EndDate').datebox('getText'));  
	val=val+"^WaitAD=";
	val=val+"^QXType=";
	val=val+"^Name=";
	val=val+"^UseLocDR="+GlobalObj.UseLocDR;
	val=val+"^RequestNo="+$('#RequestNo').val();
	val=val+"^EquipName="+$('#Equip').val();
	val=val+"^MinValue=";
	val=val+"^MaxValue=";
	val=val+"^StartInDate=";
	val=val+"^EndInDate=";
	val=val+"^EquipNo=";			
	val=val+"^MergeOrderFlag=Y";			
	
	return val;
		
}

//add by lmm 2017-08-22
//���ϵ���ѯ
function findGridData()
{
	$('#DHCEQDisuse').datagrid({
		url:'dhceq.jquery.csp',
		queryParams:{
	        ClassName:"web.DHCEQBatchDisuseRequest",
	        QueryName:"GetDisuseRequest",
	        Arg1:Combindata(),
	        ArgCnt:1
		}
	    });
	//Clear();

}

///add by lmm 2017-08-22
//��ѡ��������
function CheckSingleData_OnClickRow(rowIndex, rowData)
{
	//SelectedRowID=rowData.TRowID
    var combindata="";
    var rows = $('#DHCEQDisuse').datagrid('getChecked');
	$.each(rows, function(rowIndex, rowData){
		if (combindata=="")
		{ 
			combindata=rowData.TRowID;
		}
		 else combindata=combindata+","+rowData.TRowID; 
	}); 
		GlobalObj.rows=rows;
		GlobalObj.SelectedRowIDs=combindata;
}


///���ɻ��ܵ�
function SavegridData(){
	$.ajax({
    	//async: false,
		url :"dhceq.jquery.method.csp",
		type:"POST",
        data:{
	        ClassName:"web.DHCEQMergeOrder",
	        MethodName:"SaveData",
                Arg1:MergeOrder(),
                Arg2:MergeOrderList(),
                ArgCnt:2
	    },
       	error:function(XMLHttpRequest, textStatus, errorThrown){
                alert(XMLHttpRequest.status);
                alert(XMLHttpRequest.readyState);
                alert(textStatus);
        },
        success:function (data, response, status) {
				$.messager.progress('close');
				data=data.split("^")
        		if (data[0] ==0) {
				$.messager.show({title: '��ʾ',msg: '����ɹ�'});
				GlobalObj.RowID=data[1]
				RowID=data[1]
				$('#RowID').val(GlobalObj.RowID);
			    var url=window.location.href //GR0026 �´��ڴ�ģ̬����,ͨ���ı����ֵ���Ԥ�������⣿
			    if(url.indexOf("killcache=1")!=-1)  window.location.href='dhceqmergeorder.csp?RowID='+RowID+"&Status=0&SourceType="+$('#SourceType').val()+"&SubType="+$('#SubType').val();
			    else 								window.location.href='dhceqmergeorder.csp?RowID='+RowID+"&Status=0&SourceType="+$('#SourceType').val()+"&SubType="+$('#SubType').val();
				
           		}
            	else
            	{
               		$.messager.alert('���ʧ�ܣ�',data, 'warning')
               		return;
                }
        }
	})
}


///add by lmm 2017-08-25
///���ܵ�����
function MergeOrder()
{
	var val=""
	val=val+$('#RowID').val();
	val=val+"^"+$('#SourceType').val();
	val=val+"^"+$('#SubType').val();
	val=val+"^"+$('#Remark').val();
	
	return val;
	
}

///add by lmm 2017-08-25
///������ϸ����
function MergeOrderList()
{
	
    var combindata="";
    var vallist=""
    var copyrows=[]
	var morows = $("#DHCEQMergeOrder").datagrid("getRows"); //��δ����ǻ�ȡ��ǰҳ�������С�
	var rows = $('#DHCEQDisuse').datagrid('getChecked');
	var ets = $('#DHCEQDisuse').datagrid('getEditors');	
	if (rows!="")
	{
		$.each(rows, function(rowIndex, rowData){
			if (vallist=="")
			{ 
				vallist="^"+rowData.TRowID;
			}
			 else vallist=vallist+"&^"+rowData.TRowID; 
		}); 
	}
	else
	{
		for(var i=0;i<morows.length;i++)
		{
			//������ObjCertInfo��ֵ
			copyrows.push(morows[i]);	
		}
		for(var j=0;j<morows.length;j++)
		{
			if (vallist=="")
			{ 
				vallist=copyrows[j].TRowID+"^"+copyrows[j].TSourceID+"^"+copyrows[j].TRequestNum+"^"+copyrows[j].TAduitNum+"^"+copyrows[j].TRemark;
			}
			 else vallist=vallist+"&"+copyrows[j].TRowID+"^"+copyrows[j].TSourceID+"^"+copyrows[j].TRequestNum+"^"+copyrows[j].TAduitNum+"^"+copyrows[j].TRemark; 
		}
	}
	
	return vallist;
}

///add by lmm 2017-08-25
///�����ܵ�����
function filldata(RowID)
{
	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQMergeOrder',
			MethodName:'GetMergeOrderInfo',
			Arg1:$("#RowID").val(),
			ArgCnt:1
		},
		success:function(data,response,status)
		{
			data=data.replace(/\ +/g,"")	//ȥ���ո�
			data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
			var list=data.split("^");
			jQuery("#MergeOrderNo").val(list[0]);
			jQuery("#SubType").combobox('setValue',list[2]);
			jQuery("#Remark").val(list[3]);
			jQuery("#Status").val(list[13]);
			GlobalObj.Status=list[13]
			
		}
	});
}

///add by lmm 2017-08-25
///ɾ�����ܵ�����
function DeleteGridData(){
    if ($('#RowID').val()==""){
            $.messager.alert("����", "��ѡ�л��ܵ���", 'error') 
            return false;
    }else
    {
	    $.messager.confirm('��ȷ��', '��ȷ��Ҫɾ���õ��ݣ�', function (b) {
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
				        ClassName:"web.DHCEQMergeOrder",
				        MethodName:"DeleteData",
		                Arg1:$('#RowID').val(),
		                ArgCnt:1
				    },
			       	error:function(XMLHttpRequest, textStatus, errorThrown){
		                    alert(XMLHttpRequest.status);
		                    alert(XMLHttpRequest.readyState);
		                    alert(textStatus);
			        },
		            success:function (data, response, status) {
	        				$.messager.progress('close');
							data=data.split("^")
		            		if (data[0] ==0) {
							$.messager.show({title: '��ʾ',msg: '����ɹ�'});
							alert("ɾ���ɹ�!")
							    
							//var url=window.location.href
							    window.location.href= 'dhceqmergeorder.csp?RowID=&Status=&SourceType='+$('#SourceType').val()+"&SubType="+$('#SubType').val();
							    
							    							
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


function Clear()
{
	$('#RowID').val("");
	$('#Remark').val("");
	$('#MergeOrderNo').val("");
	$('#SubType').combobox('setValue',"");
}
///ɾ��������ϸ
//
function deleterow(dataid)
{
    if (dataid==""){
            $.messager.alert("����", "��ѡ�л�����ϸ��", 'error') 
            return false;
    }else
    {
	    $.messager.confirm('��ȷ��', '��ȷ��Ҫɾ���õ��ݣ�', function (b) {
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
				        ClassName:"web.DHCEQMergeOrder",
				        MethodName:"DeleteMergeOrderList",
		                Arg1:dataid,
		                ArgCnt:1
				    },
			       	error:function(XMLHttpRequest, textStatus, errorThrown){
		                    alert(XMLHttpRequest.status);
		                    alert(XMLHttpRequest.readyState);
		                    alert(textStatus);
			        },
		            success:function (data, response, status) {
	        				$.messager.progress('close');
							data=data.split("^")
		            		if (data[0] ==0) {
							$.messager.show({title: '��ʾ',msg: '����ɹ�'});
							alert("ɾ���ɹ�!")
							$('#DHCEQMergeOrder').datagrid('reload',{
							        ClassName:"web.DHCEQMergeOrder",
							        QueryName:"GetMergeOrderList",
							        Arg1:$('#RowID').val(),
							        ArgCnt:1
							    });
							$('#DHCEQDisuse').datagrid('reload',{
							        ClassName:"web.DHCEQBatchDisuseRequest",
							        QueryName:"GetDisuseRequest",
							        Arg1:Combindata(),
							        ArgCnt:1
							    });
							
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
///add by lmm 2017-08-30
///�ύ���ܵ�
function SubmitgridData()
{
	$.ajax({
    	//async: false,
		url :"dhceq.jquery.method.csp",
		type:"POST",
        data:{
	        ClassName:"web.DHCEQMergeOrder",
	        MethodName:"SubmitData",
                Arg1:$('#RowID').val(),
                ArgCnt:1
	    },
       	error:function(XMLHttpRequest, textStatus, errorThrown){
                alert(XMLHttpRequest.status);
                alert(XMLHttpRequest.readyState);
                alert(textStatus);
        },
        success:function (data, response, status) {
				$.messager.progress('close');
				data=data.split("^")
        		if (data[0] ==0) {
				$.messager.show({title: '��ʾ',msg: '����ɹ�'});
				GlobalObj.RowID=data[1]
				RowID=data[1]
				$('#RowID').val(GlobalObj.RowID);
			    var url=window.location.href //GR0026 �´��ڴ�ģ̬����,ͨ���ı����ֵ���Ԥ�������⣿
			    if(url.indexOf("killcache=1")!=-1)  window.location.href='dhceqmergeorder.csp?RowID='+RowID+"&Status=1&SourceType="+$('#SourceType').val()+"&SubType="+$('#SubType').val();
			    else 								window.location.href='dhceqmergeorder.csp?RowID='+RowID+"&Status=1&SourceType="+$('#SourceType').val()+"&SubType="+$('#SubType').val();
				
           		}
            	else
            	{
               		$.messager.alert('���ʧ�ܣ�',data, 'warning')
               		return;
                }
        }
	})
}

///add by lmm 2017-09-01
///������ܵ�����
function ClearGridData()
{
	var url=window.location.href
	window.location.href= 'dhceqmergeorder.csp?RowID=&Status=&SourceType='+$('#SourceType').val()+"&SubType="+$('#SubType').val();
}

function changeDateformat(Date)
{
	if (Date=="") return "";
	var date=Date.split("-")
	var temp=date[2]+"/"+date[1]+"/"+date[0];   //���ڸ�ʽ�任
	return temp;
}
