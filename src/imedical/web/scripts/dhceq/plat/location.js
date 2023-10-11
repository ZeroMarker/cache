var Columns=getCurColumnsInfo('EM.G.DT3D.Location','','','')
var SelectedRowID = 0;
var preRowID=0;
//界面入口
jQuery(document).ready
(    
	function()
	{
		setTimeout("initDocument();",50);
	}
);
function initDocument()
{
	initPanel();
}
function initPanel()
{ 
	initTopPanel();
}

function initTopPanel()
{
	initUserInfo();
	initButton(); 
    initButtonWidth();
    initLookUp();
	initMessage("");
	defindTitleStyle(); 
	initData();
}
function initData(){
	$HUI.datagrid("#tDHCEQCLocation",{   
	    url:$URL, 
    	queryParams:{
        ClassName:"web.DHCDT3D.Location",
        QueryName:"GetLocation",
        Desc:getElementValue("Desc"),
        BUNo:getElementValue("BUNo"),
        FloorID:getElementValue("FloorID"),
        FBuildingDR:getElementValue("BuildingDR"),
        LocDR:getElementValue("LocDR"),
        Job:getElementValue("Job")
    	},
   		fitColumns:true,    
    	columns:Columns,
    pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60,75]   
});
}	
function BFind_Clicked(){
	$HUI.datagrid("#tDHCEQCLocation",{   
	    url:$URL, 
    	queryParams:{
        ClassName:"web.DHCDT3D.Location",
        QueryName:"GetLocation",
        Desc:getElementValue("Desc"),
        BUNo:getElementValue("BUNo"),
        FloorID:getElementValue("FloorID"),
        FBuildingDR:getElementValue("BuildingDR"),
        LocDR:getElementValue("LocDR"),
        Job:getElementValue("Job")
    },
});
}
function BPrint_Clicked()
{
	var checkedItems = $('#tDHCEQCLocation').datagrid('getChecked');
	var selectItems = [];
	$.each(checkedItems, function(index, item){
        	selectItems.push(item.TRowID);
		});
	if(selectItems=="")
	{
		//modified by CZF0105 20200409
		messageShow("confirm","info","提示","是否全部打印?","",PrintAll,function(){
			return;
		})
	}
	else
	{
		var str="";
		for(i=0;i<selectItems.length;i++)//开始循环
		{
			//printRoomBarStandard(selectItems[i],"","")
			printRoomBar(selectItems[i])
		}
	}
}
function PrintAll()
{
	var TotalRows=tkMakeServerCall("web.DHCDT3D.Location","GetTempDataRows","GetLocation",getElementValue("Job"),curUserID)
	if (TotalRows=="")
	{
		messageShow('alert','error','提示',"无数据,不能打印");
		return;
	}
	for (var i=1;i<=TotalRows;i++)
	{
		var LocationID=tkMakeServerCall("web.DHCDT3D.Location","GetTempData","GetLocation",getElementValue("Job"),curUserID,i)
		//printRoomBarStandard(LocationID,"","")
		printRoomBar(LocationID)
	}
}
//选择框选择事件
function setSelectValue(elementID,rowData)
{
	setElement(elementID+"DR",rowData.TRowID)
	if(elementID=="Building") 
	{
		setElement("BuildingDR",rowData.TRowID)
		setElement("Building",rowData.TName)
	}
	if(elementID=="FloorNo") 
	{
		setElement("FloorID",rowData.TRowID)
		setElement("FloorNo",rowData.TName)
	}
}
function printRoomBar(locationid)
{
	if (locationid=="") return;
	var jsonData=tkMakeServerCall("web.DHCDT3D.Location","GetOneLocation", locationid);
	var jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow('alert','error','提示',jsonData.Data,'','','');return;}
	var objLocation=jsonData.Data;
	var c2=String.fromCharCode(2);
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCEQRoom");
	var LODOP = getLodop();
		
	var inpara="BUNo"+c2+objLocation.BUNo;
	inpara+="^LDesc"+c2+objLocation.LDesc;  			
	inpara+="^FLocation"+c2+"("+objLocation.BName+objLocation.FFloorNum+"层)";
	//inpara+="^BName"+c2+objLocation.BName;	
	inpara+="^RoomNo"+c2+"Room"+objLocation.BUNo;					
	//alert(inpara)
	DHC_PrintByLodop(LODOP,inpara,"","","",{printListByText:true});
	
}
//hisui.common.js错误纠正需要
function clearData(elementID)
{
	setElement(elementID+"DR","")
	if(elementID=="FloorNo") 
	{
		setElement("FloorID","")
	}
} 
//元素参数重新获取值
function getParam(ID)
{
	if (ID=="FBuildingDR"){return getElementValue("BuildingDR")}

}
function BussClick(curIndex)
{
	var rowsData = $("#tDHCEQCLocation").datagrid("getRows");
	var rowData = rowsData[curIndex];
	var FloorNo = rowData.TF3DFloorID;
	var BuildingUnitNo = rowData.TBU3DRoomID;
	var url='http://www.thingjs.com/s/315573fc9499abdbd46cb199?params=105b0f77fd24654d4eebc434e9&ServiceName=viewfloor&FloorNo='+FloorNo+'&BuildingUnitNo='+BuildingUnitNo; 
	//var url='https://www.thingjs.com/s/7dec7051acb4fa2cf45a7e12?params=105b0f77fd24654d4eebc434e9&ServiceName=viewfloor&FloorNo='+FloorNo+'&BuildingUnitNo='+BuildingUnitNo; 
	showWindow(url,"三维可视化","","","","modal","","","large");
}
