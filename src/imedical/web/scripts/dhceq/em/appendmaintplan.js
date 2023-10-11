var editIndex=undefined;
var Columns=getCurColumnsInfo('EM.G.Maint.MaintPlanList','','','');

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});

function initDocument()
{
	initUserInfo();
	initLookUp();
	initMessage();
	defindTitleStyle();
	initButton();
	initButtonWidth();
	InitEvent()
	
	$HUI.datagrid("#MaintPlanList",{
		url:$URL,
	    queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSMaintPlan",
	        	QueryName:"GetMaintPlanNew",
	        	BussType:1,	// MZY0120	2022-04-13
		        //CycleType:6,	 MZY0099	2200374		2021-11-13
		        AllFlag:1
		},
	    toolbar:[{
    			iconCls: 'icon-import',
                text:'׷����ѡ�мƻ���',
				id:'app',
                handler: function(){
                     BAppend_Click();
                }
        }],
		rownumbers:true,  		//���Ϊtrue����ʾ�к���
		singleSelect:true,
		//fit:true,
		//fitColumns:true,
		columns:Columns,
		pagination:true,
		pageSize:12,
		pageNumber:1,
		pageList:[12,24,36]
	});
	
	disableElement("app",true); 	//��ť����
};

function InitEvent() //��ʼ���¼�
{
	if (jQuery("#BAppend").length>0)
	{
		jQuery("#BAppend").linkbutton({iconCls: 'icon-w-import'});
		jQuery("#BAppend").on("click", BAppend_Click);
	}
	if (jQuery("#BClose").length>0)
	{
		jQuery("#BClose").linkbutton({iconCls: 'icon-w-close'});
		jQuery('#BClose').on("click", BClose_Clicked);
	}
}

function setEnabled(flag)
{
	//disableElement("BSave",0);
	//disableElement("BDelete",flag);
	//disableElement("app",flag);
}

function setSelectValue(elementID,rowData)
{
	setDefaultElementValue(elementID,rowData)
}

function onClickRow(index)
{
	if (editIndex==index)
	{
		editIndex = undefined;
		Clear();
		disableElement("app",true);
		// MZY0083	2034030,2034042		2021-07-19	ȡ��ѡ����
		$('#MaintPlanList').datagrid("unselectRow",index);
		return
	}
	var rowData = $('#MaintPlanList').datagrid('getSelected');
	if (!rowData) return;
	if (rowData.TRowID=="")
	{
		messageShow('alert','error','������ʾ','�б������쳣!');
		return;
	}
	setElement("MPID",rowData.TRowID);
	setElement("MPName",rowData.TName);
	editIndex=index;
	disableElement("app",false);
}
function Clear()
{
	SetElement("MPID","");
	SetElement("MPName","");
}
function clearData(elementID)
{
	var elementName=elementID.split("_")[0];
	setElement(elementName,"");
	return;
}

function BFind_Clicked()
{
	$HUI.datagrid("#MaintPlanList",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSMaintPlan",
	        QueryName:"GetMaintPlanNew",
	        BussType:1,	// MZY0120	2022-04-13
	        Name:getElementValue("PlanName"),
	        MonthStr:getElementValue("MonthStr"),
	        MaintUserDR:getElementValue("MaintUserDR"),
	        //CycleType:6,	 MZY0099	2200374		2021-11-13
	        AllFlag:1
	    }
	});
	disableElement("app",true); 	// MZY0083	2034030,2034042		2021-07-19	��ť����
}
function setElementEnabled()
{
	//var Rtn=tkMakeServerCall("web.DHCEQCommon","GetSysInfo",103002);
	//if(Rtn=="1") disableElement("CTContractNo",true);
}

function BAppend_Click()
{
	messageShow("confirm","","","�Ƿ�ȷ���ѵ�ǰѡ���豸׷����: "+getElementValue("MPName"),"",AppendEquip,UnAppendEquip);
}
function AppendEquip()
{
	if (getElementValue("MPID")=="")
	{
		messageShow('alert','error','������ʾ','δѡ��׷�Ӽƻ�!');
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan","AppendEquip", getElementValue("MPID"), getElementValue("EquipDRStr"));
	//alert(jsonData)
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		//var url= 'dhceq.em.inventoryexception.csp?&InventoryDR=&InventoryNo='+getElementValue("InventoryNo")+'&StatusDR='+'&QXType='+getElementValue("QXType")+'&ReadOnly='+getElementValue("ReadOnly");
	    //window.setTimeout(function(){window.location.href=url},50);
	    messageShow("popover","","","׷�ӳɹ���","");
	    var ExecuteIDs=tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan","GetExecuteIDs", getElementValue("MPID"))
	    if (ExecuteIDs!="")
	    {
		    messageShow("confirm","","","׷�ӵļƻ�������ִ��,�Ƿ��豸ͬ����ִ�е�?","",UpdateExecuteList,UnUpdateExecuteList);
	    }
	}
	else
    {
		messageShow('alert','error','������ʾ��',jsonData.Data);
    }
}
function UnAppendEquip()
{
	
}
function UpdateExecuteList()
{
	var Rtn=tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan","UpdateExecuteList", getElementValue("MPID"), getElementValue("EquipDRStr"));
	//alert(jsonData)
	if (Rtn<0)
	{
		messageShow('alert','error','������ʾ��',"");
	}
	else
    {
		//window.location.reload()
		//var url= 'dhceq.em.inventoryexception.csp?&InventoryDR=&InventoryNo='+getElementValue("InventoryNo")+'&StatusDR='+'&QXType='+getElementValue("QXType")+'&ReadOnly='+getElementValue("ReadOnly");
	    //window.setTimeout(function(){window.location.href=url},50);
	    messageShow("popover","","","ͬ���ɹ���","");
    }
}
function UnUpdateExecuteList()
{
	
}
function BClose_Clicked()
{
	//websys_showModal("options").mth();
	closeWindow('modal');
}
