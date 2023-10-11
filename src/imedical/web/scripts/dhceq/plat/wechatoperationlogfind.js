/*
 *author zouxuan 2020-11-17 BUG ZX0114
 *description 微信操作日志js调用
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
			text: '绑定日志'
		},{
			id: '2',
			text: '调用日志'
		}],
	})  
}

//modify by zx 2020-11-17 BUG ZX0114
//查询操作
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
	//Modefied by zc0090 2020-12-09 弹出信息注释
	//alert(JSON.stringify(rowData))
	setElement(elementID+"DR",rowData.TRowID);
}

function clearData(elementID)
{
	setElement(elementID+"DR","");
}