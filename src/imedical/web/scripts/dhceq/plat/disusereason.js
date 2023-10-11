var Columns=getCurColumnsInfo('PLAT.G.DReason','','','')
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
	initButton(); 
    initButtonWidth();
    //jQuery('#BAdd').on("click", BAdd_Clicked); modify by zyq 2022-12-08
	setRequiredElements("DRDesc^DRCode"); //modify by zyq 2023-03-01
	initMessage("");
	defindTitleStyle(); 
	setEnabled();
	initData();
}
function OnClickRow()
{	
     var selected=$('#tDHCEQCDisuseReason').datagrid('getSelected');
     if (selected)
     {       
        var SelectedRowID=selected.TRowID;
        if(preRowID!=SelectedRowID)
        {
	    	 setElement("DRRowID",SelectedRowID)
	         setElement("DRCode",selected.TCode)
	         setElement("DRDesc",selected.TDesc)
			 setElement("DRRemark",selected.TRemark);
             preRowID=SelectedRowID;
             UnderSelect();		
        }
         else
         {
             ClearElement();
             $('#tDHCEQCDisuseReason').datagrid('unselectAll');
             SelectedRowID = 0;
             preRowID=0;
         }
     }
} 

function initData(){
	$HUI.datagrid("#tDHCEQCDisuseReason",{   
	    url:$URL, 
    	queryParams:{
        ClassName:"web.DHCEQ.Plat.DisuseReason",
        QueryName:"GetReason",
        Code:getElementValue("DRCode"),
        Desc:getElementValue("DRDesc")
    	},
  		singleSelect:true,
   		fitColumns:true,    
    	columns:Columns,
    	onClickRow : function (rowIndex, rowData) {
        OnClickRow();
    },
    pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60,75]   
});
}
function ClearElement()
{
	setElement("DRRowID","")
	setElement("DRCode","")
	setElement("DRDesc","")
	setElement("DRRemark","");  
	setEnabled();
	preRowID="";
}	
function BFind_Clicked(){
	$HUI.datagrid("#tDHCEQCDisuseReason",{   
	    url:$URL, 
    	queryParams:{
        ClassName:"web.DHCEQ.Plat.DisuseReason",
        QueryName:"GetReason",
        Code:getElementValue("DRCode"),
        Desc:getElementValue("DRDesc")
    },
});
}

function BAdd_Clicked(){
	if (getElementValue("DRRowID")!=""){
			$.messager.popover({msg:"新增失败,你可能选中一条记录",type:'alert'});
            return false;
    } 
	if (checkMustItemNull()) return;
	var data=getInputList();
	data=JSON.stringify(data);
    var jsonData=tkMakeServerCall("web.DHCEQ.Plat.DisuseReason","SaveData",data,"0");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		$('#tDHCEQCDisuseReason').datagrid('reload');
		alertShow("新增成功");
	}
	else{
		messageShow("alert","error","错误提示",jsonData.Data) //modify by zyq 2023-03-01
		return
	}
}
function BSave_Clicked(){
	if (getElementValue("DRRowID")==""){
			$.messager.popover({msg:"请选择一行",type:'alert'});
            return false;
    } 
    if (checkMustItemNull()) return;
    var data=getInputList();
	data=JSON.stringify(data);
    var jsonData=tkMakeServerCall("web.DHCEQ.Plat.DisuseReason","SaveData",data,"0");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		$('#tDHCEQCDisuseReason').datagrid('reload');
		alertShow("保存成功");
	}
	else{
		messageShow("alert","error","错误提示",jsonData.Data) //modify by zyq 2023-03-01
		return
	}
}
function BDelete_Clicked(){
    if (getElementValue("DRRowID")==""){
            $.messager.popover({msg:"请选择一行",type:'alert'}); 
            return false;
    } 
    var rows =$('#tDHCEQCDisuseReason').datagrid('getSelected');
    $.messager.confirm('请确认', '您确定要删除所选的行？', function (b) { 
    	if (b==false)
    	{
        	 return;
   	 	}
    	else
    	{
		   	var data=getElementValue("DRRowID");
			var jsonData=tkMakeServerCall("web.DHCEQ.Plat.DisuseReason","SaveData",data,"1");
			jsonData=JSON.parse(jsonData)
			if (jsonData.SQLCODE==0)
			{
				$('#tDHCEQCDisuseReason').datagrid('reload');
				alertShow("删除成功");
			}
			else{
				messageShow("alert","error","错误提示",jsonData.Data) //modify by zyq 2023-03-01
				return
			}
    	}       
  })
     
}

function setEnabled()
{
	disableElement("BSave",true);
	disableElement("BDelete",true);
	disableElement("BAdd",false);
	initButtonColor();
}
function UnderSelect()
{
	disableElement("BSave",false);
	disableElement("BDelete",false);
	disableElement("BAdd",true);
	initButtonColor();
}
