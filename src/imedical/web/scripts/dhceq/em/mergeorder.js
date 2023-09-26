var SelectedRowID = 0;
var PreSelectedRowID = 0;
var editFlag="undefined";
var MergeOrdercolumns=getCurColumnsInfo('PLAT.G.MergeOrder.OrderList','','',''); 
var DisuseRequestcolumns=getCurColumnsInfo('EM.G.MergeOrder.Disuse','','',''); 
jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
);
function initDocument(){
	
	defindTitleStyle(); 
	initLookUp();
	filldata($("#RowID").val())
	
	
	
	
	$HUI.datagrid("#DHCEQDisuse",{   
    url:$URL, 
	idField:'TRowID', //����   
    border : false,
	striped : true,
    cache: false,
    fit:true,
    singleSelect:false,
	toolbar:[
		{
			id:"find", //add by sjh SJH0026 2020-06-11
			iconCls:'icon-search', 
			text:'��ѯ',
			handler:function(){findGridData();}
		},{
	        id:"add",
			iconCls:'icon-add', 
			text:'���',
			handler:function(){SavegridData();}
		} 
	], 
    queryParams:{
        ClassName:"web.DHCEQ.EM.BUSBatchDisuseRequest",
        QueryName:"GetDisuseRequest",
        VData:Combindata()
    },
	//fitColumns:true,
	pagination:true,
	columns:DisuseRequestcolumns,
	});
	$HUI.datagrid("#DHCEQMergeOrder",{   
    url:$URL, 
	idField:'TRowID', //����   //add by lmm 2018-10-23
	    border : false,
		striped : true,
	    cache: false,
	    fit:true,
	    singleSelect:true,
		fitColumns:true,
		pagination:true,
    queryParams:{
        ClassName:"web.DHCEQ.Plat.BUSMergeOrder",
        QueryName:"GetMergeOrderList",
        RowID:$("#RowID").val()
    },
	//fitColumns:true,
	columns:MergeOrdercolumns, 
	toolbar:[
		 {
	        id:"save",
			iconCls:'icon-save', 
			text:'����',
			handler:function(){SavegridData();}
		 },{   
	     	id:"submit",
	        iconCls: 'icon-ok', 
	        text:'�ύ',      
	         handler: function(){SubmitgridData();}      
	     },{   
	    	id:"delete",       
	        iconCls: 'icon-no', 
	        text:'ɾ��',      
	         handler: function(){DeleteGridData();}      
	     },{   
	    	id:"clear",       
	        iconCls: 'icon-cut', 
	        text:'���',      
	        handler: function(){ClearGridData();}      
	     }] , 
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
				//alertShow(GlobalObj.MergeOrderList(rows[i].TRowID))		
			}
		}

});

	if(($("#Status").val()=="0")||($("#Status").val()==""))
	{
		jQuery("#add").linkbutton('enable');	
		jQuery("#submit").linkbutton('enable');	
		jQuery("#delete").linkbutton('enable');	
	}
	else if($("#Status").val()=="1")  //  modified by sjh SJH0026 2020-06-11 ���ӻ��ܵ��ύ״̬�µı��ϵ�����
	{
		jQuery("#add").linkbutton('disable');
		jQuery("#find").linkbutton('disable');	 
		jQuery("#save").linkbutton('disable');	
		jQuery("#submit").linkbutton('disable');	
		jQuery("#delete").linkbutton('disable');	
		$('#DHCEQMergeOrder').datagrid('hideColumn','TDeleteList');
		$('#DHCEQDisuse').datagrid('hideColumn','TCheckFlag');
		$('#DHCEQDisuse').datagrid('hideColumn','TEquip');
		$('#DHCEQDisuse').datagrid('hideColumn','TRequestNo');
		$('#DHCEQDisuse').datagrid('hideColumn','TNo');
		$('#DHCEQDisuse').datagrid('hideColumn','TPrice');
		$('#DHCEQDisuse').datagrid('hideColumn','TTotalFee');
		$('#DHCEQDisuse').datagrid('hideColumn','TQuantity'); 

	}
	
	//modify by lmm 2019-08-29 ʹ��ɾ��ͼ��
	var TDeleteList=$("#DHCEQMergeOrder").datagrid('getColumnOption','TDeleteList');
	TDeleteList.formatter=	function(value,row,index){
			var MOLID = '<a href="#"  onclick="deleterow('+row.TRowID+')">&nbsp;<img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/no.png" /></a> '; return MOLID; 		
		}	
		
	
}	


///add by lmm 2017-08-22 
///���ϵ���ѯ����
function Combindata()
{
	var	val="^ReplacesAD=";
	val=val+"^ApproveRole=";
	val=val+"^Type=";
	val=val+"^StatusDR=1";
	val=val+"^Status=";
	val=val+"^EquipDR=";  
	val=val+"^RequestLocDR=";
	val=val+"^EquipTypeDR=";
	val=val+"^PurchaseTypeDR=";	
	val=val+"^StartDate="+getElementValue("StartDate");
	val=val+"^EndDate="+getElementValue("EndDate");  
	val=val+"^WaitAD=";
	val=val+"^QXType=";
	val=val+"^Name=";
	val=val+"^UseLocDR="+getElementValue("UseLocDR");
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
	$HUI.datagrid("#DHCEQDisuse",{   
    url:$URL, 
    queryParams:{
        ClassName:"web.DHCEQ.EM.BUSBatchDisuseRequest",
        QueryName:"GetDisuseRequest",
        VData:Combindata()
	    },
	});

}

///add by lmm 2017-08-22
//��ѡ��������
function CheckSingleData_OnClickRow(rowIndex, rowData)
{
    var combindata="";
    var rows = $('#DHCEQDisuse').datagrid('getChecked');
	$.each(rows, function(rowIndex, rowData){
		if (combindata=="")
		{ 
			combindata=rowData.TRowID;
		}
		 else combindata=combindata+","+rowData.TRowID; 
	}); 
}


///���ɻ��ܵ�
function SavegridData()
{
	//modify by lmm 2018-11-28 begin
	var combindata=MergeOrder()
	var combindataList=MergeOrderList()
	//add by lmm 2019-01-26 818933 begin
	if(($('#RowID').val()=="")&&(combindataList==""))
	{
		alertShow("δ��ѡҵ�񵥾ݣ�")
		return;	
	}
	//add by lmm 2019-01-26 818933 end
	var Rtn = tkMakeServerCall("web.DHCEQ.Plat.BUSMergeOrder", "SaveData",combindata,combindataList);
	var data=Rtn.split("^")
	if (data[0] ==0)
	{
	    messageShow("","","","����ɹ�")     //modify by lmm 2019-03-12  836875
		RowID=data[1]
		$('#RowID').val(RowID);
	    var url=window.location.href //GR0026 �´��ڴ�ģ̬����,ͨ���ı����ֵ���Ԥ�������⣿
	    if(url.indexOf("killcache=1")!=-1)  window.location.href='dhceq.em.mergeorder.csp?RowID='+RowID+"&Status=0&SourceType="+$('#SourceType').val()+"&SubType="+$('#SubType').val();
	    else 								window.location.href='dhceq.em.mergeorder.csp?RowID='+RowID+"&Status=0&SourceType="+$('#SourceType').val()+"&SubType="+$('#SubType').val();
		
	}
	else
	{
   		$.messager.alert('���ʧ�ܣ�',data, 'warning')
   		return;
	}
	//modify by lmm 2018-11-28 end
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
	//modify by lmm 2018-11-28 begin
	var RowID=$("#RowID").val()
	var data = tkMakeServerCall("web.DHCEQ.Plat.BUSMergeOrder", "GetMergeOrderInfo",RowID);
	//modify by lmm 2018-11-28 end
	data=data.replace(/\ +/g,"")	//ȥ���ո�
	data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
	var list=data.split("^");
	jQuery("#MergeOrderNo").val(list[0]);
	setElement("SubType",list[2])
	jQuery("#Remark").val(list[3]);
	jQuery("#Status").val(list[13]);
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
		        
				var RowID=$("#RowID").val()
				var data = tkMakeServerCall("web.DHCEQ.Plat.BUSMergeOrder", "DeleteData",RowID);
				data=data.split("^")
        		if (data[0] ==0) {
				$.messager.show({title: '��ʾ',msg: '����ɹ�'});
				alertShow("ɾ���ɹ�!")
				window.location.href= 'dhceq.em.mergeorder.csp?RowID=&Status=&SourceType='+$('#SourceType').val()+"&SubType="+$('#SubType').val();
	           	}
            	else
            	{
               		$.messager.alert('ɾ��ʧ�ܣ�',data, 'warning')
               		return;
                }
	        }         
        })
		    
	}
}


function Clear()
{
	$('#RowID').val("");
	$('#Remark').val("");
	$('#MergeOrderNo').val("");
	setElement("SubType","")
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
		        //modify by lmm 2018-11-28 begin
				var data = tkMakeServerCall("web.DHCEQ.Plat.BUSMergeOrder", "DeleteMergeOrderList",dataid);
				data=data.split("^")
        		if (data[0] ==0) {
				$.messager.show({title: '��ʾ',msg: '����ɹ�'});
				alertShow("ɾ���ɹ�!")
				$HUI.datagrid("#DHCEQDisuse",{   
			    url:$URL, 
			    queryParams:{
			        ClassName:"web.DHCEQ.EM.BUSBatchDisuseRequest",
			        QueryName:"GetDisuseRequest",
			        VData:Combindata()
			    },
				});
				$HUI.datagrid("#DHCEQMergeOrder",{   
			    url:$URL, 
			    queryParams:{
			        ClassName:"web.DHCEQ.Plat.BUSMergeOrder",
			        QueryName:"GetMergeOrderList",
			        RowID:$("#RowID").val()
			    },
				})
							
			    }
			    else
			    {
	           		$.messager.alert('ɾ��ʧ�ܣ�',data, 'warning')
	           		return;
			    }
		        //modify by lmm 2018-11-28 end
		        

	        }         
        })
		    
	}
	
}
///add by lmm 2017-08-30
///�ύ���ܵ�
function SubmitgridData()
{
    //modify by lmm 2018-11-28 begin
    var RowID=$('#RowID').val()
	var data = tkMakeServerCall("web.DHCEQ.Plat.BUSMergeOrder", "SubmitData",RowID);
	data=data.split("^")
	if (data[0] ==0) {
		$.messager.show({title: '��ʾ',msg: '����ɹ�'});
		RowID=data[1]
		$('#RowID').val(RowID);
	    var url=window.location.href //GR0026 �´��ڴ�ģ̬����,ͨ���ı����ֵ���Ԥ�������⣿
	    if(url.indexOf("killcache=1")!=-1)  window.location.href='dhceq.em.mergeorder.csp?RowID='+RowID+"&Status=1&SourceType="+$('#SourceType').val()+"&SubType="+$('#SubType').val();
	    else 								window.location.href='dhceq.em.mergeorder.csp?RowID='+RowID+"&Status=1&SourceType="+$('#SourceType').val()+"&SubType="+$('#SubType').val();
	
	}
	else
	{
   		$.messager.alert('���ʧ�ܣ�','���ύ����', 'warning') //modify by hly 2019-04-03
   		return;
    }
    //modify by lmm 2018-11-28 end
}

///add by lmm 2017-09-01
///������ܵ�����
function ClearGridData()
{
	var url=window.location.href
	window.location.href= 'dhceq.em.mergeorder.csp?RowID=&Status=&SourceType='+$('#SourceType').val()+"&SubType="+$('#SubType').val();
}


//add hly 20190404
function setSelectValue(vElementID,rowData)
{
	setElement(vElementID+"DR",rowData.TRowID)  //modify by lmm 2019-04-19 872469
}

///add by lmm 2019-04-19 872469
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}