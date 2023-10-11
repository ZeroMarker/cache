var Columns=getCurColumnsInfo('PLAT.G.Origin','','','')
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
    jQuery('#BAdd').on("click", BAdd_Clicked);
	setRequiredElements("OCode^ODesc");
	initMessage("");
	defindTitleStyle(); 
	setEnabled();
	initData();
}
function OnClickRow()
{	
     var selected=$('#tDHCEQCOrigin').datagrid('getSelected');
     if (selected)
     {       
        var SelectedRowID=selected.TRowID;
        if(preRowID!=SelectedRowID)
        {
	    	 setElement("ORowID",SelectedRowID)
	         setElement("OCode",selected.TCode)
	         setElement("ODesc",selected.TName)
	         setElement("OEquipFlag",selected.TEquipFlag);
			 setElement("OFacilityFlag",selected.TFacilityFlag);
			 setElement("ORemark",selected.TRemark);
             preRowID=SelectedRowID;
             UnderSelect();		
        }
         else
         {
             ClearElement();
             $('#tDHCEQCOrigin').datagrid('unselectAll');
             SelectedRowID = 0;
             preRowID=0;
         }
     }
} 
function initData(){
	$HUI.datagrid("#tDHCEQCOrigin",{   
	    url:$URL, 
    	queryParams:{
        ClassName:"web.DHCEQ.Plat.CTOrigin",
        QueryName:"GetOrigin",
        Code:getElementValue("OCode"),
        Desc:getElementValue("ODesc")
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
	setElement("ORowID","")
	setElement("OCode","")
	setElement("ODesc","")
	setElement("OEquipFlag","");
	setElement("OFacilityFlag","");
	setElement("ORemark","");  
	setEnabled();
	preRowID="";
}	
function BFind_Clicked(){
	$HUI.datagrid("#tDHCEQCOrigin",{   
	    url:$URL, 
    	queryParams:{
        ClassName:"web.DHCEQ.Plat.CTOrigin",
        QueryName:"GetOrigin",
        Code:getElementValue("OCode"),
        Desc:getElementValue("ODesc")
    },
});
}

function BAdd_Clicked(){
	if (getElementValue("ORowID")!=""){
			$.messager.popover({msg:"����ʧ��,�����ѡ��һ����¼",type:'alert'});
            return false;
    } 
	if (checkMustItemNull()) return;
	var data=getInputList();
	data=JSON.stringify(data);
    var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTOrigin","SaveData",data,"0");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		$('#tDHCEQCOrigin').datagrid('reload');
		alertShow("�����ɹ�");
	}
	else{
		alertShow("������Ϣ:"+jsonData.Data);
		return
	}
}
function BSave_Clicked(){
	if (getElementValue("ORowID")==""){
			$.messager.popover({msg:"��ѡ��һ��",type:'alert'});
            return false;
    } 
    if (checkMustItemNull()) return;
    var data=getInputList();
	data=JSON.stringify(data);
    var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTOrigin","SaveData",data,"0");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		$('#tDHCEQCOrigin').datagrid('reload');
		alertShow("����ɹ�");
	}
	else{
		alertShow("������Ϣ:"+jsonData.Data);
		return
	}
}
function BDelete_Clicked(){
    if (getElementValue("ORowID")==""){
            $.messager.popover({msg:"��ѡ��һ��",type:'alert'}); 
            return false;
    } 
    var rows =$('#tDHCEQCOrigin').datagrid('getSelected');
    $.messager.confirm('��ȷ��', '��ȷ��Ҫɾ����ѡ���У�', function (b) { 
    	if (b==false)
    	{
        	 return;
   	 	}
    	else
    	{
		   	var data=getElementValue("ORowID");
			var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTOrigin","SaveData",data,"1");
			jsonData=JSON.parse(jsonData)
			if (jsonData.SQLCODE==0)
			{
				$('#tDHCEQCOrigin').datagrid('reload');
				alertShow("ɾ���ɹ�");
			}
			else{
				alertShow("������Ϣ:"+jsonData.Data);
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
}
function UnderSelect()
{
	disableElement("BSave",false);
	disableElement("BDelete",false);
	disableElement("BAdd",true);
}


