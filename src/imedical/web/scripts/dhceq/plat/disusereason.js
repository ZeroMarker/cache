var Columns=getCurColumnsInfo('PLAT.G.DReason','','','')
var SelectedRowID = 0;
var preRowID=0;
//�������
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
			$.messager.popover({msg:"����ʧ��,�����ѡ��һ����¼",type:'alert'});
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
		alertShow("�����ɹ�");
	}
	else{
		messageShow("alert","error","������ʾ",jsonData.Data) //modify by zyq 2023-03-01
		return
	}
}
function BSave_Clicked(){
	if (getElementValue("DRRowID")==""){
			$.messager.popover({msg:"��ѡ��һ��",type:'alert'});
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
		alertShow("����ɹ�");
	}
	else{
		messageShow("alert","error","������ʾ",jsonData.Data) //modify by zyq 2023-03-01
		return
	}
}
function BDelete_Clicked(){
    if (getElementValue("DRRowID")==""){
            $.messager.popover({msg:"��ѡ��һ��",type:'alert'}); 
            return false;
    } 
    var rows =$('#tDHCEQCDisuseReason').datagrid('getSelected');
    $.messager.confirm('��ȷ��', '��ȷ��Ҫɾ����ѡ���У�', function (b) { 
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
				alertShow("ɾ���ɹ�");
			}
			else{
				messageShow("alert","error","������ʾ",jsonData.Data) //modify by zyq 2023-03-01
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
