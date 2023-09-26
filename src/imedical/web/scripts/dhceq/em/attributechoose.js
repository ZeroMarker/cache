//attributechoose.js
var Columns=getCurColumnsInfo('EM.G.AttributeCatChoose','','','')
$(function(){
	initDocument();
});

function initDocument()
{ 
	
	initButton(); //按钮初始化
	initButtonWidth();
	initLookUp(); //初始化放大镜
	defindTitleStyle(); 
	$HUI.datagrid("#tAttibuteChoose",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSAttributeCat",
	        	QueryName:"GetAttributeCatChoose",
	        	Name:getElementValue("EQName"),
	        	Code:getElementValue("EACode"),
	        	
		},
		rownumbers: true,  //如果为true，则显示一个行号列。
		singleSelect:false,
		fit:true,
		border:false,
		columns:Columns,
		fitColumns:true,   //add by lmm 2020-06-05 UI
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100]
		});		
}
function BSave_Clicked()
{ 
	var EACode= getElementValue("EACode");
	if(EACode=="") return;
	var dataList=""
	var rows = $('#tAttibuteChoose').datagrid('getSelections');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		var RowData=JSON.stringify(rows[i])
		if (dataList=="")
		{
			dataList=RowData;
		}
		else
		{
			dataList=dataList+"&"+RowData;
		}
	}
	// MZY0025	1318610		2020-05-13
	if (dataList=="")
	{
		messageShow("alert","error","错误提示","保存操作失败,请选择设备记录.");
		return
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSAttributeCat","SaveData",dataList,EACode,"","3");
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
	    window.location.reload();
	    
	}	
	else
    {
		messageShow("alert","error","错误提示","保存失败,错误信息:"+jsonData.Data);
		return;
    }

}
function BFind_Clicked()
{ 
	$HUI.datagrid("#tAttibuteChoose",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSAttributeCat",
	        	QueryName:"GetAttributeCatChoose",
	        	Name:getElementValue("EQName"),
	        	Code:getElementValue("EACode"),
		}
	});	
}
