/*
 *author zouxuan 2020-11-17 BUG ZX0114
 *description ΢�Ų�����־js����
*/
var columns=getCurColumnsInfo('PLAT.G.CT.WechatOperationLog','','','');  

$(document).ready(function () {
	initDocument();
});
function initDocument()
{
	defindTitleStyle();
	initButtonWidth();
	initButton();
	initLookUp();
	
	$HUI.datagrid("#tWechatOperationLogFind",{   
	   	url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Plat.CTWChatUser",
	        QueryName:"GetWChatOperationLog",
	        LogType:getElementValue("LogType"),
	        ChatID:getElementValue("ChatID"),
	        User:getElementValue("UserDR"),
	        StartDate:getElementValue("StartDate"),
	        EndDate:getElementValue("EndDate"),
	        MethodDesc:getElementValue("MethodDesc")
		},
    	fitColumns : true,
	    scrollbarSize:0, 
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  
	    columns:columns,
		pagination:true,
		pageSize:20,
		pageNumber:1,
		pageList:[20,40,60,80,100]
	});	    
		
	var MapType = $HUI.combobox('#LogType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data: [
		{
			id: '1',
			text: '����־'
		},{
			id: '2',
			text: '������־'
		}],
	})  
}

//modify by zx 2020-11-17 BUG ZX0114
//��ѯ����
function BFind_Clicked()
{
	$HUI.datagrid("#tWechatOperationLogFind",{   
    	url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Plat.CTWChatUser",
	        QueryName:"GetWChatOperationLog",
	        LogType:getElementValue("LogType"),
	        ChatID:getElementValue("ChatID"),
	        User:getElementValue("UserDR"),
	        StartDate:getElementValue("StartDate"),
	        EndDate:getElementValue("EndDate"),
	        MethodDesc:getElementValue("MethodDesc")
		},
	});
}

function setSelectValue(elementID,rowData)
{
	//Modefied by zc0090 2020-12-09 ������Ϣע��
	//alert(JSON.stringify(rowData))
	setElement(elementID+"DR",rowData.TRowID);
}

function clearData(elementID)
{
	setElement(elementID+"DR","");
}