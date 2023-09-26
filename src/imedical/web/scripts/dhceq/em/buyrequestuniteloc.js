var Columns=getCurColumnsInfo('EM.G.MultipleApproveInfo','','','')
var selectflag=false
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});
function initDocument()
{
	initLookUp();
	initButton();
	initButtonWidth();
	defindTitleStyle();
	setEnabled();
	$HUI.datagrid("#DHCEQMultipleApproveInfo",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.EM.LIBMultipleApproveInfo",
	        	QueryName:"MultipleApproveInfo",
				BusID:getElementValue("MABusID"),
				ApproveType:getElementValue("MAApproveTypeDR")
		},
		rownumbers: true, 
		fitColumns : true,    //add by lmm 2020-06-04
		singleSelect:true,
		fit:true,
		border:false,
		columns:Columns,
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100],
		onClickRow:function(rowIndex,rowData){onClickRow(rowIndex,rowData);},
		onLoadSuccess:function(){}
	});
}
function BSave_Clicked()
{
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.LIBMultipleApproveInfo","SaveData",data,"0");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		url="dhceq.em.buyrequestuniteloc.csp?&BRRowID="+getElementValue("MABusID")+"&ApproveType="+getElementValue("MAApproveTypeDR")
		window.location.href= url;
		//modified by ZY0222 2020-04-16
		websys_showModal("options").mth();
	}else
    {
		alertShow("错误信息:"+jsonData.Data);
		return
    }
}
function BDelete_Clicked()
{
	var data=getElementValue("MARowID")
	if (data=="")
	{
		alertShow("没有选中行!");
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.LIBMultipleApproveInfo","SaveData",data,"1");
	jsonData=JSON.parse(jsonData)
	
	if (jsonData.SQLCODE==0)
	{
		url="dhceq.em.buyrequestuniteloc.csp?&BRRowID="+getElementValue("MABusID")+"&ApproveType="+getElementValue("MAApproveTypeDR")
		window.location.href= url;
		//modified by ZY0222 2020-04-16
		websys_showModal("options").mth();
	}
	else
    {
		alertShow("错误信息:"+jsonData.Data);
		return
    }
}

function setSelectValue(elementID,rowData)
{
	if(elementID=="MASourceID_CTLOCDesc") {setElement("MASourceID",rowData.TRowID)}
}

function onClickRow(rowIndex,rowData)
{
	if(!selectflag)
	{   
		selectflag=true;
		setElement("MASourceID",rowData.TSourceID);
		setElement("MASourceID_CTLOCDesc",rowData.TSource);
		setElement("MARowID",rowData.TRowID);
	}else
	{
		selectflag=false;
		setElement("MASourceID","");
		setElement("MASourceID_CTLOCDesc","");
		setElement("MARowID","");
		jQuery('#DHCEQMultipleApproveInfo').datagrid('unselectAll');
	}

}
function clearData(vElementID)
{
	var _index = vElementID.indexOf('_')
	if(_index != -1){
		var vElementDR = vElementID.slice(0,_index)
		if($("#"+vElementDR).length>0)
		{
			setElement(vElementDR,"");
		}
	}
}

//add by zx 2019-09-16
function setEnabled()
{
	var ReadOnly=getElementValue("ReadOnly");
	if(ReadOnly=="1")
	{
		disableElement("BSave",true);
		disableElement("BDelete",true);
	}
}
//Add by QW20191205 begin 需求号:1123791  解决联合科室不显示科室数量
function BClosed_Clicked()
{

	websys_showModal("options").mth();
	closeWindow("modal")

}

