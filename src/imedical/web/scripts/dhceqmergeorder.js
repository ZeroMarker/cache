var SelectedRowID = 0;
var PreSelectedRowID = 0;
var editFlag="undefined";
var MergeOrdercolumns=GetCurColumnsInfo('EM.G.MergeOrder.DisuseList','','',''); 
var DisuseRequestcolumns=GetCurColumnsInfo('EM.G.MergeOrder.Disuse','','',''); 
$(document).ready(function (){
	initUseLocPanel();			//科室
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
	    idField:'TRowID', //主键
	    border:'true',
	    fit:true,
	    singleSelect:true,
	    toolbar:[{  
	    			iconCls: 'icon-search', 
	                text:'查询',          
	                handler: function(){
	                     findGridData();
	                }   
	                },'------------------------',{   
                 	id:"add",
	                iconCls: 'icon-redo', 
	                text:'右移',      
	                 handler: function(){
	                     SavegridData();
	                     }      
	                 }] , 

	    columns:DisuseRequestcolumns,
	    /*[[
	    	{field:'TRowID',title:'TRowID',width:50,hidden:true}, 
	    	{field:'TCheckFlag',title:'TCheckFlag',width:50,align:'center',checkbox:true}, 
	    	{field:'TEquipDR',title:'TEquipDR',width:50,hidden:true},
	        {field:'TEquip',title:'设备名称',width:100,align:'center'},
	        {field:'TRequestNo',title:'报废单号',width:100,align:'center'},  
	        {field:'TNo',title:'设备编号',width:100,align:'center'},
	        {field:'TRequestLocDR',title:'TRequestLocDR',width:100,align:'center',hidden:true},  
	        {field:'TUseLoc',title:'使用科室',width:100,align:'center',align:'center'},  
	        {field:'TPrice',title:'原值',width:100,align:'center'},
	        {field:'TTotalFee',title:'金额',width:100,align:'center'},
	        {field:'TQuantity',title:'数量',width:100,align:'center'},
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
	                text:'保存',          
	                handler: function(){
	                     SavegridData();
	                }
	                },'------------------------',{   
                 	id:"submit",
	                iconCls: 'icon-ok', 
	                text:'提交',      
	                 handler: function(){
	                     SubmitgridData();
	                     }      
	                 },'------------------------',{   
                	id:"delete",       
	                iconCls: 'icon-no', 
	                text:'删除',      
	                 handler: function(){
	                     DeleteGridData();
	                     }      
	                 },'------------------------',{   
                	id:"clear",       
	                iconCls: 'icon-cut', 
	                text:'清空',      
	                 handler: function(){
	                     ClearGridData();
	                     }      
	                 }] , 

	    columns: MergeOrdercolumns,
	   /*[[
	    	{field:'TRowID',title:'TRowID',width:50,hidden:true}, 
	    	{field:'TMergeOrderDR',title:'TMergeOrderDR',hidden:true},
	    	{field:'TSourceID',title:'TSourceID',hidden:true},
	        {field:'TRequestNo',title:'报废单号',width:100,align:'center'},  
	        {field:'TNo',title:'设备编号',width:100,align:'center'},
	        {field:'TRequestLocDR',title:'TRequestLocDR',width:100,align:'center',hidden:true},  
	        {field:'TUserLoc',title:'使用科室',width:100,align:'center',align:'center',hidden:true},  
	        {field:'TEquip',title:'设备名称',width:100,align:'center'},
	        {field:'TOriginalFee',title:'原值',width:100,align:'center'},
	        {field:'TQuantityNum',title:'数量',width:30,align:'center'},
	        {field:'TRequestNum',title:'申请数量',width:60,align:'center',editor:'numberbox'},
	        {field:'TAduitNum',title:'审批数量',width:60,align:'center',hidden:true},
	        {field:'TRemark',title:'备注',width:60,align:'center',editor:'text'},
	        {field:'TDeleteList',title:'删除',width:60,align:'center',
	        formatter:function(value,row,index){
			var MOLID = '<a href="#"  onclick="deleterow('+row.TRowID+')">删除</a> '; return MOLID; 
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
        onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
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
			var rows = $("#DHCEQMergeOrder").datagrid("getRows"); //这段代码是获取当前页的所有行。
			for(var i=0;i<rows.length;i++)
			{
				//给对象ObjCertInfo赋值
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
			var MOLID = '<a href="#"  onclick="deleterow('+row.TRowID+')">删除</a> '; return MOLID; 		
		}	
	
	

});

///add by lmm 2017-08-22 
///报废单查询条件
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
//报废单查询
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
//勾选单条数据
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


///生成汇总单
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
				$.messager.show({title: '提示',msg: '保存成功'});
				GlobalObj.RowID=data[1]
				RowID=data[1]
				$('#RowID').val(GlobalObj.RowID);
			    var url=window.location.href //GR0026 新窗口打开模态窗口,通过改变参数值解决预缓存问题？
			    if(url.indexOf("killcache=1")!=-1)  window.location.href='dhceqmergeorder.csp?RowID='+RowID+"&Status=0&SourceType="+$('#SourceType').val()+"&SubType="+$('#SubType').val();
			    else 								window.location.href='dhceqmergeorder.csp?RowID='+RowID+"&Status=0&SourceType="+$('#SourceType').val()+"&SubType="+$('#SubType').val();
				
           		}
            	else
            	{
               		$.messager.alert('添加失败！',data, 'warning')
               		return;
                }
        }
	})
}


///add by lmm 2017-08-25
///汇总单数据
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
///汇总明细数据
function MergeOrderList()
{
	
    var combindata="";
    var vallist=""
    var copyrows=[]
	var morows = $("#DHCEQMergeOrder").datagrid("getRows"); //这段代码是获取当前页的所有行。
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
			//给对象ObjCertInfo赋值
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
///填充汇总单数据
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
			data=data.replace(/\ +/g,"")	//去掉空格
			data=data.replace(/[\r\n]/g,"")	//去掉回车换行
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
///删除汇总单数据
function DeleteGridData(){
    if ($('#RowID').val()==""){
            $.messager.alert("错误", "请选中汇总单！", 'error') 
            return false;
    }else
    {
	    $.messager.confirm('请确认', '您确定要删除该单据？', function (b) {
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
							$.messager.show({title: '提示',msg: '保存成功'});
							alert("删除成功!")
							    
							//var url=window.location.href
							    window.location.href= 'dhceqmergeorder.csp?RowID=&Status=&SourceType='+$('#SourceType').val()+"&SubType="+$('#SubType').val();
							    
							    							
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


function Clear()
{
	$('#RowID').val("");
	$('#Remark').val("");
	$('#MergeOrderNo').val("");
	$('#SubType').combobox('setValue',"");
}
///删除汇总明细
//
function deleterow(dataid)
{
    if (dataid==""){
            $.messager.alert("错误", "请选中汇总明细！", 'error') 
            return false;
    }else
    {
	    $.messager.confirm('请确认', '您确定要删除该单据？', function (b) {
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
							$.messager.show({title: '提示',msg: '保存成功'});
							alert("删除成功!")
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
			               		$.messager.alert('删除失败！',data, 'warning')
			               		return;
			                }
		            }
		    	})
	        }         
        })
		    
	}
	
}
///add by lmm 2017-08-30
///提交汇总单
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
				$.messager.show({title: '提示',msg: '保存成功'});
				GlobalObj.RowID=data[1]
				RowID=data[1]
				$('#RowID').val(GlobalObj.RowID);
			    var url=window.location.href //GR0026 新窗口打开模态窗口,通过改变参数值解决预缓存问题？
			    if(url.indexOf("killcache=1")!=-1)  window.location.href='dhceqmergeorder.csp?RowID='+RowID+"&Status=1&SourceType="+$('#SourceType').val()+"&SubType="+$('#SubType').val();
			    else 								window.location.href='dhceqmergeorder.csp?RowID='+RowID+"&Status=1&SourceType="+$('#SourceType').val()+"&SubType="+$('#SubType').val();
				
           		}
            	else
            	{
               		$.messager.alert('添加失败！',data, 'warning')
               		return;
                }
        }
	})
}

///add by lmm 2017-09-01
///清除汇总单数据
function ClearGridData()
{
	var url=window.location.href
	window.location.href= 'dhceqmergeorder.csp?RowID=&Status=&SourceType='+$('#SourceType').val()+"&SubType="+$('#SubType').val();
}

function changeDateformat(Date)
{
	if (Date=="") return "";
	var date=Date.split("-")
	var temp=date[2]+"/"+date[1]+"/"+date[0];   //日期格式变换
	return temp;
}
