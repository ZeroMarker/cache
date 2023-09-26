var preRowID=0

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});  // add by wy 2020-05-9 �������Ч��Ӱ�� bug WY0068
});
//modified by add by wy 2020-05-9 bug WY0068
//��ʼ����ѯͷ���
function initDocument()
{
 	initUserInfo();
 	initMessage(); //add by CSJ 2020-03-03 ����ţ�1211992
    initLookUp(); //��ʼ���Ŵ�
	defindTitleStyle();
    initButton(); //��ť��ʼ��
    initButtonWidth();
    //fillData(); //������� add by wy 2018-12-14 ����776553
    setEnabled(); //��ť����
	initDHCEQIFBList();			//��ʼ�����
	setRequiredElements("IFBLVendor"); // modified by wy 2019-12-13 1129288
	disableElement("BDelete",true);   //�һ�ɾ����ť
}
function initDHCEQIFBList()
{
	$HUI.datagrid("#tDHCEQIFBList",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSIFBList",
	        QueryName:"IFBListDetail",	        
	        SourceType:getElementValue("IFBLSourceType"), //modify hly 2019-11-11 bug:1067351
	        SourceID:getElementValue("IFBLSourceID"), //modify hly 2019-11-11 bug:1067351
	        IFBBRowID:getElementValue("IFBBRowID"),
		},
	    fie:true,
	    singleSelect:true,
		fitColumns:true,
		pagination:true,
    	columns:[[  //modify hly 2019-11-11 bug:1067351
    	{field:'IFBLRowID',title:'IFBLRowID',width:50,hidden:true}, 
    	{field:'IFBLVendorDR',title:'IFBLVendorDR',width:50,hidden:true},   
        {field:'IFBLVendor',title:'��Ӧ��',width:60,align:'center'},
        {field:'IFBLManuFactoryDR',title:'IFBLManuFactoryDR',width:50,hidden:true}, 
        {field:'IFBLManuFactory',title:'��������',width:95,align:'center'},
        {field:'IFBLModelDR',title:'IFBLModelDR',width:50,hidden:true},
        {field:'IFBLModel',title:'����',width:100,align:'center'},    
        {field:'IFBLBrandDR',title:'IFBLBrandDR',width:50,hidden:true},
        {field:'IFBLBrand',title:'Ʒ��',width:100,align:'center'}, 
        {field:'IFBLArg',title:'��������',width:100,align:'center'}, 
        {field:'IFBLPrice',title:'����',width:100,align:'center'}, 
        {field:'IFBLAmount',title:'�ܶ�',width:100,align:'center'},
        {field:'IFBLWinFlag',title:'�б��־',width:100,align:'center'}, 
        {field:'IFBLWinQty',title:'�б�����',width:100,align:'center'}, 
        {field:'IFBLCandidacy',title:'��ѡ��־',width:100,align:'center'}, 
        {field:'IFBLCandidacySeq',title:'��ѡ˳��',width:100,align:'center'}, 
        {field:'IFBLScore',title:'����',width:100,align:'center'}, 
        {field:'IFBLRemark',title:'��ע',width:100,align:'center'}, 
    	]],
		onClickRow:function(rowIndex,rowData){OnclickRow();},
	});
}
function setEnabled()
{
	var ReadOnly=getElementValue("ReadOnly");
	if (ReadOnly=="1")
	{
		disableElement("BDelete",true);
		disableElement("BSave",true);
		return;
	}
}
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
	if (vElementID=="Brand")
	{
		setElement("Brand",item.TDesc);
		setElement("BrandDR",item.TRowID);
	}
	/*	if (vElementID=="Model")
	{
		setElement("Model",item.TName);
		setElement("ModelDR",item.TRowID);
	}*/

}

function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}

function GetCheckValue(checkName)
{
	return (jQuery("#" + checkName).is(':checked')==true)?"Y":"N";
}
function OnclickRow()
{
	var selected=$('#tDHCEQIFBList').datagrid('getSelected');
	if(selected)
	{
		var selectedRowID=selected.IFBLRowID; //modify ������2019-11-11 bug:1067330
		if(preRowID!=selectedRowID)
		{  
		    //add by wy 2019-12-25����1141001
	        if (getElementValue("ReadOnly")=="1")
	   		{
				disableElement("BDelete",true);
			}
			else{
				disableElement("BDelete",false);
			   }
			fillData(selectedRowID)
			preRowID=selectedRowID;
		}
		else
		{
			ClearElement();
			$('#tDHCEQIFBList').datagrid('unselectAll');
			selectedRowID = 0;
			preRowID=0;
		}
	}
}
//modifed by wy 2019-12-13  1129283,1129283 begin
function fillData(RowID)
{
	if (RowID=="") return;
	jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSIFBList","GetIFBListByID",RowID)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
	setElementByJson(jsonData.Data);
}
function ClearElement()
{
	setElement("IFBLRowID",""); 
	setElement("IFBLVendorDR","");
	setElement("IFBLVendor","");
	setElement("IFBLManuFactoryDR","");
	setElement("IFBLManuFactory","");
	setElement("IFBLModelDR","");
	setElement("IFBLModel","");
	setElement("IFBLBrandDR","");
	setElement("IFBLBrand","");
	setElement("IFBLArg","");
	setElement("IFBLPrice","");
	setElement("IFBLAmount","");
    setElement("IFBLWinFlag","");
	setElement("IFBLWinQty","");
	setElement("IFBLCandidacy","");
	setElement("IFBLCandidacySeq","");
	setElement("IFBLScore","");
	setElement("IFBLRemark","");
}


function BSave_Clicked()
{
    if (checkMustItemNull()) return
	var data=getInputList();
	data=JSON.stringify(data);
	if (data=="")
	{
		messageShow('alert','error','��ʾ',"Ӧ�깩Ӧ����ϸ����Ϊ��!");
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSIFBList","SaveData",data,"","",0);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var val=getValueList();
		url="dhceq.em.ifblist.csp?"+val
	    window.location.href= url;
	}
	else
    {
		messageShow('alert','error','��ʾ',"������Ϣ:"+jsonData.SQLCODE);
		return
    }
}

function BDelete_Clicked()
{
	if (getElementValue("IFBLRowID")=="")
	{
		messageShow('alert','error','��ʾ',"û��Ӧ�깩Ӧ��ɾ��!");
		return;
	}
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSIFBList","SaveData",data,"","",1);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var val=getValueList();
		url="dhceq.em.ifblist.csp?"+val
	    window.location.href= url;
	}
	else
    {
		messageShow('alert','error','��ʾ',"������Ϣ:"+jsonData.SQLCODE);
		return
    }
}
function getValueList()
{
	var IFBBRowID=getElementValue("IFBBRowID")
	var IFBLSourceType=getElementValue("IFBLSourceType")
	var IFBLSourceID=getElementValue("IFBLSourceID")
	var val="&IFBBRowID="+IFBBRowID+"&SourceType="+IFBLSourceType+"&SourceID="+IFBLSourceID+"&ReadOnly="+getElementValue("ReadOnly")
	return val;
}
//end


