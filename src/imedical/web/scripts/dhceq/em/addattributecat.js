//addattributecat.js
var Columns=getCurColumnsInfo('EM.L.AttributeCat','','','');
var PreSelectedRowID=undefined;
$(function(){
	initDocument();
});
function initDocument()
{
	initIHTType()
	initButton(); //按钮初始化
	initButtonWidth();
	initMessage("");
	defindTitleStyle(); 
	$HUI.datagrid("#taddAttributeCat",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSAttributeCat",
	        	QueryName:"GetAttributeCat",
	        	Code:getElementValue("IHTCode"),
	        	Desc:getElementValue("IHTDesc"),
	        	TypeStr:getElementValue("IHTType")
		},
		onSelect:function(rowIndex,rowData)		
		{ 
			OnSelect_Clicked(rowIndex,rowData);
		},
		rownumbers: false,  //如果为true，则显示一个行号列。
		singleSelect:true,
		fit:true,
		border:false,
		fitColumns:true,   //add by lmm 2020-06-05 UI
		columns:Columns,
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100]
		,
		
		
	});
	setRequiredElements("IHTCode^IHTDesc"); //add by sjh SJH0034 2020-09-10
	
}
function BSave_Clicked()
{ 
	var datalist=getInputList();
	if(datalist.IHTCode==""||datalist.IHTDesc=="")
	{ 
		messageShow("alert","info","","代码或名称为空");
		return;
	}
	if(getElementValue("IHTType")=="")
	{ 
		messageShow("alert","info","","请选择设备属性码");
		return;
	}
	var datalist=JSON.stringify(datalist)
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSAttributeCat","SaveAttributeCat",datalist,"");
	jsonData=JSON.parse(jsonData);
	if(jsonData.SQLCODE==0)
	{ 
		messageShow("alert","info","",t[jsonData.SQLCODE]);
		window.location.reload();
	}
	else
	{ 
		{messageShow("alert","error","错误提示",t[jsonData.SQLCODE]);return;}
	}
	
}

function BDelete_Clicked()
{ 
	var datalist=getInputList();
	if(datalist.IHTCode==""||datalist.IHTDesc=="")
	{ 
	 messageShow("alert","info","",t[-9243]);
	}
	else
	{ 	
	    //modified by wy 2021-9-14 2144654
		messageShow("confirm","info","提示","是否删除该信息？","",BDelete,function(){
			return;
		});	

	}
}
function BDelete()
{ 
	var datalist=getInputList();
	var datalist=JSON.stringify(datalist)
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSAttributeCat","SaveAttributeCat",datalist,"2");
	jsonData=JSON.parse(jsonData);
	if(jsonData.SQLCODE==0)
	{ 
		messageShow("alert","success","提示",t[jsonData.SQLCODE]);
	    window.setTimeout(function(){window.location.reload();},300); 
			 
	}
	else
	{ 
		messageShow("alert","error","错误提示",t[jsonData.SQLCODE]);return;
	}
}

//modify by wl 2020-06-22 增加参数
function BFind_Clicked()
{
	$HUI.datagrid("#taddAttributeCat",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSAttributeCat",
	        	QueryName:"GetAttributeCat",
	        	Code:getElementValue("IHTCode"),
	        	Desc:getElementValue("IHTDesc"),
	        	TypeStr:getElementValue("IHTType"),
	        	otherDesc:getElementValue("IHTHold1")
		},
		onSelect:function(rowIndex,rowData)		
		{ 
			
			OnSelect_Clicked(rowIndex,rowData);
		},
		rownumbers: false,  //如果为true，则显示一个行号列。
		singleSelect:true,
		fit:true,
		border:false,
		columns:Columns,
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100]
		
	});
}
//modify by wl 2020-06-12 WL0067 
function initIHTType()
{ 
	
		$HUI.combobox("#IHTType",{
				valueField:'id', textField:'text',panelHeight:"auto",
				data:[
					 {id:getElementValue("EACode"),text:getElementValue("EAName"),selected:true}
					
				],
			});  
		$('#IHTType').combobox({disabled:true});
	
}
//modify by wl 2020-06-22 增加清空按钮
function OnSelect_Clicked(rowIndex, rowData)
{ 
	if (PreSelectedRowID!=rowData.TRowID)
	{
		setElement("IHTRowID",rowData.TRowID);
		setElement("IHTCode",rowData.TCode);
		setElement("IHTDesc",rowData.TName);
		setElement("IHTHold1",rowData.TOtherDesc)
		PreSelectedRowID=rowData.TRowID
	}
	else
	{
		BClear_Clicked()
	}

}
//add by wl 2020-06-22	
function BClear_Clicked()
{
		PreSelectedRowID=""
		$('#taddAttributeCat').datagrid('unselectAll');
		setElement("IHTRowID","");
		setElement("IHTCode","");
		setElement("IHTDesc","");
		setElement("IHTHold1","");
}
