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
	initUserInfo(); //add by csj 2020-11-17
	initButton();
    //initButtonWidth(); //add by jyp 2023-02-06

	defindTitleStyle(); 
	initLookUp();
	filldata($("#RowID").val())
	$HUI.datagrid("#DHCEQDisuse",{   
    url:$URL, 
	idField:'TRowID', //主键   
    border : false,
	striped : true,
    cache: false,
    fit:true,
    singleSelect:false,
	//移除TOOLBAR,添加新增按钮  modify by jyp 2023-02-17
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
	idField:'TRowID', //主键   //add by lmm 2018-10-23
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
	//modified by wy 2022-7-8 HISUI界面2612985 begin
	columns:MergeOrdercolumns, 
	toolbar:[
		 {
	        id:"save",
			iconCls:'icon-save', 
			text:'保存',
			handler:function(){SavegridData();}
		 },
		 {   
	     	id:"submit",
	        iconCls: 'icon-ok', 
	        text:'提交',      
	         handler: function(){SubmitgridData();}      
	     },
	     {   
	    	id:"delete",       
	        iconCls: 'icon-cancel', 
	        text:'删除',      
	         handler: function(){DeleteGridData();}      
	     },
	     {   
	    	id:"clear",       
	        iconCls: 'icon-clear-screen',  
	        text:'清空',      
	        handler: function(){ClearGridData();}      
	     },
	     {	//add by csj 2020-11-17 添加打印 需求号：1605288
		    id:"print",
			iconCls:'icon-print', 
	        text:'打印',      
	        handler: function(){BPrint_Clicked();}
		 }] , //modified by wy 2022-7-8 HISUI界面2612985 end
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
	else if($("#Status").val()=="1")  //  modified by sjh SJH0026 2020-06-11 增加汇总单提交状态下的报废单控制
	{
		jQuery("#add").linkbutton('disable');
		jQuery("#BFind").linkbutton('disable');	 //modified by wy 2022-5-16 HISUI界面2612985
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
	
	//modify by lmm 2019-08-29 使用删除图标
	var TDeleteList=$("#DHCEQMergeOrder").datagrid('getColumnOption','TDeleteList');
	TDeleteList.formatter=	function(value,row,index){
			var MOLID = '<a href="#"  onclick="deleterow('+row.TRowID+')">&nbsp;<img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/no.png" /></a> '; return MOLID; 		
		}	
		
	
}	


///add by lmm 2017-08-22 
///报废单查询条件
function Combindata()
{
	var	val="^ReplacesAD=";
	val=val+"^ApproveRole="+getElementValue("CurRole");  ///Modified By QW20201223 BUG: QW0085 CurRole
	val=val+"^Type="+getElementValue("Type");  ///Modified By QW20201223 BUG: QW0085 Type
	val=val+"^StatusDR=1";
	val=val+"^Status=";
	val=val+"^EquipDR=";  
	val=val+"^RequestLocDR=";
	val=val+"^EquipTypeDR=";
	val=val+"^PurchaseTypeDR=";	
	val=val+"^StartDate="+getElementValue("StartDate");
	val=val+"^EndDate="+getElementValue("EndDate");  
	val=val+"^WaitAD="+getElementValue("WaitAD");  ///Modified By QW20201223 BUG: QW0085 WaitAD
	val=val+"^QXType="+getElementValue("QXType");  ///Modified By QW20201223 BUG: QW0085 QXType
	val=val+"^Name=";
	val=val+"^UseLocDR="+getElementValue("UseLocDR");
	val=val+"^RequestNo="+$('#RequestNo').val();
	val=val+"^EquipName="+$('#Equip').val();
	val=val+"^MinValue=";
	val=val+"^MaxValue=";
	val=val+"^StartInDate=";
	val=val+"^EndInDate=";
	val=val+"^EquipNo=";			
	val=val+"^MergeOrderFlag=N"; ///Modified By QW20201223 BUG: QW0085
	val=val+"^Action="+getElementValue("Action"); /// Add by QW20201223 BUG: QW0085 	Action 		
	
	return val;
		
}
///add by jyp 2023-02-17
///移除TOOLBAR,添加新增按钮  
function BAdd_Clicked()
{
	SavegridData();
}

//add by lmm 2017-08-22
//报废单查询
//modified by wy 2022-5-16 HISUI界面2612985
function BFind_Clicked()
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
//勾选单条数据
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


///生成汇总单
function SavegridData()
{
	//modify by lmm 2018-11-28 begin
	var combindata=MergeOrder()
	var combindataList=MergeOrderList()
	//add by lmm 2019-01-26 818933 begin
	if(($('#RowID').val()=="")&&(combindataList==""))
	{
		alertShow("未勾选业务单据！")
		return;	
	}
	//add by lmm 2019-01-26 818933 end
	var Rtn = tkMakeServerCall("web.DHCEQ.Plat.BUSMergeOrder", "SaveData",combindata,combindataList);
	var data=Rtn.split("^")
	if (data[0] ==0)
	{
	    messageShow("","","","保存成功")     //modify by lmm 2019-03-12  836875
		RowID=data[1]
		$('#RowID').val(RowID);
	    var url='dhceq.em.mergeorder.csp?RowID='+RowID+"&Status=0&SourceType="+$('#SourceType').val()+"&SubType="+$('#SubType').val();
	    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href=url;
		
	}
	else
	{
   		$.messager.alert('添加失败！',data, 'warning')
   		return;
	}
	//modify by lmm 2018-11-28 end
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
	//modify by lmm 2018-11-28 begin
	var RowID=$("#RowID").val()
	var data = tkMakeServerCall("web.DHCEQ.Plat.BUSMergeOrder", "GetMergeOrderInfo",RowID);
	//modify by lmm 2018-11-28 end
	data=data.replace(/\ +/g,"")	//去掉空格
	data=data.replace(/[\r\n]/g,"")	//去掉回车换行
	var list=data.split("^");
	jQuery("#MergeOrderNo").val(list[0]);
	setElement("SubType",list[2])
	jQuery("#Remark").val(list[3]);
	jQuery("#Status").val(list[13]);
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
		        
				var RowID=$("#RowID").val()
				var data = tkMakeServerCall("web.DHCEQ.Plat.BUSMergeOrder", "DeleteData",RowID);
				data=data.split("^")
        		if (data[0] ==0) {
				$.messager.show({title: '提示',msg: '保存成功'});
				alertShow("删除成功!")
				var url='dhceq.em.mergeorder.csp?RowID=&Status=&SourceType='+$('#SourceType').val()+"&SubType="+$('#SubType').val();
				if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
					url += "&MWToken="+websys_getMWToken()
				}
				window.location.href= url;
	        }else{
               	$.messager.alert('删除失败！',data, 'warning')
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
///删除汇总明细
//
function deleterow(dataid)
{
    if (dataid==""){
            $.messager.alert("错误", "请选中汇总明细！", 'error') 
            return false;
    }else
    {
	    $.messager.confirm('请确认', '您确定要删除该明细？', function (b) {	//modified by csj 2020-11-10 需求号：1590656
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
				$.messager.show({title: '提示',msg: '保存成功'});
				alertShow("删除成功!")
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
	           		$.messager.alert('删除失败！',data, 'warning')
	           		return;
			    }
		        //modify by lmm 2018-11-28 end
		        

	        }         
        })
		    
	}
	
}
///add by lmm 2017-08-30
///提交汇总单
function SubmitgridData()
{
    //modify by lmm 2018-11-28 begin
    var RowID=$('#RowID').val()
	var data = tkMakeServerCall("web.DHCEQ.Plat.BUSMergeOrder", "SubmitData",RowID);
	data=data.split("^")
	if (data[0] ==0) {
		$.messager.show({title: '提示',msg: '保存成功'});
		RowID=data[1]
		$('#RowID').val(RowID);
		var url='dhceq.em.mergeorder.csp?RowID='+RowID+"&Status=1&SourceType="+$('#SourceType').val()+"&SubType="+$('#SubType').val();
	    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href=url;
	}
	else
	{
   		$.messager.alert('添加失败！','无提交数据', 'warning') //modify by hly 2019-04-03
   		return;
    }
    //modify by lmm 2018-11-28 end
}

///add by lmm 2017-09-01
///清除汇总单数据
function ClearGridData()
{
	var url= 'dhceq.em.mergeorder.csp?RowID=&Status=&SourceType='+$('#SourceType').val()+"&SubType="+$('#SubType').val();
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.location.href= url;
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


///Modefied by CSJ 2020-11-17 添加润乾打印
function BPrint_Clicked()
{
	var PreviewRptFlag=getElementValue("PreviewRptFlag");
	var fileName=""	;
    if(PreviewRptFlag==0)
    {
	    fileName="{DHCEQMergeOrder.raq(RowID="+getElementValue("RowID")+";USERNAME="+curUserName+";HOSPDESC="+curSSHospitalName+";MergeOrderNo="+getElementValue("MergeOrderNo")+")}";
	    DHCCPM_RQDirectPrint(fileName);
    }
    if(PreviewRptFlag==1)
    { 
	    fileName="DHCEQMergeOrder.raq&RowID="+getElementValue("RowID")+"&USERNAME="+curUserName+"&HOSPDESC="+curSSHospitalName+"&MergeOrderNo="+getElementValue("MergeOrderNo");
	    DHCCPM_RQPrint(fileName);
    }												

}
//add by csj 2020-11-19 图片上传
function BPicture_Clicked()
{
	var ReadOnly=getElementValue("ReadOnly")

	var Status=getElementValue("Status");
	if (Status!=0) {ReadOnly=1}
	var str='dhceq.plat.picturemenu.csp?&CurrentSourceType=34-1&CurrentSourceID='+getElementValue("RowID")+'&Status='+Status+'&ReadOnly='+ReadOnly;
	showWindow(str,"图片信息","","","icon-w-paper","modal","","","large");
}
