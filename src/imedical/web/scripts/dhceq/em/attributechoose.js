//attributechoose.js
var Columns=getCurColumnsInfo('EM.G.AttributeCatChoose','','','')
$(function(){
	initDocument();
});

function initDocument()
{ 
	
	initButton(); //��ť��ʼ��
	initButtonWidth();
	initLookUp(); //��ʼ���Ŵ�
	defindTitleStyle(); 
	$HUI.datagrid("#tAttibuteChoose",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSAttributeCat",
	        	QueryName:"GetAttributeCatChoose",
	        	Name:getElementValue("EQName"),
	        	Code:getElementValue("EACode"),
	        	
		},
		rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
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
		messageShow("alert","error","������ʾ","�������ʧ��,��ѡ���豸��¼.");
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
		messageShow("alert","error","������ʾ","����ʧ��,������Ϣ:"+jsonData.Data);
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
