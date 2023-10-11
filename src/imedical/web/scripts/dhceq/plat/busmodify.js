$(function(){
	initDocument();
});
function initDocument()
{
	initUserInfo();
	initMessage("");		//1995508 czf 2021-07-07
	loadBusinessData();
	setEnabled();
    getUniteBussNos();
	initLookUp();
	defindTitleStyle();
	initButton();
	initButtonWidth(); 
	var BussType=getElementValue("BussType");
	var MainFlag=getElementValue("MainFlag");
	if (BussType==21)
	{
		if (MainFlag=="Y") setRequiredElements("ISEquipTypeDR_ETDesc^ISProviderDR_VDesc^ISOriginDR_ODesc^ISInDate"); 
		else 
		{
			setRequiredElements("ISLEquipName^ISLUnitDR_UOMDesc^ISLStatCatDR_SCDesc^ISLEquipCatDR_ECDesc"); 
			singlelookup("ISLStatCatDR_SCDesc","PLAT.L.StatCat",[{name:"StatCat",type:1,value:"ISLStatCatDR_SCDesc"},{name:"EquipTypeDR",type:4,value:"ISEquipTypeDR"}])
		}
	}
	if(BussType==11)
	{
		initOCLSourceType();
		setRequiredElements("OCLName^OCLOriginalFee^OCLQuantity^OCRStatCatDR_SCDesc^OCLEquiCatDR_ECDesc^OCRProviderDR_VDesc^OCROriginDR_ODesc"); 
		singlelookup("OCRStatCatDR_SCDesc","PLAT.L.StatCat",[{name:"StatCat",type:1,value:"OCRStatCatDR_SCDesc"},{name:"EquipTypeDR",type:4,value:"OCREquipTypeDR"}])	
		var lisLocNum=tkMakeServerCall("web.DHCEQ.Plat.LIBBusinessModify","CheckBussListLoc",BussType,getElementValue("OCLRowID"))	//CZF 1905411 2021-06-03
		if(lisLocNum>1)
		{
			disableElement("OCLUseLocDR_CTLOCDesc",true);
		}
	}
	///modified by ZY0252  20210301
	if(BussType==94)
	{
		if (MainFlag=="Y") setRequiredElements("CTProviderDR_VDesc^CTSignLocDR_CTLOCDesc^CTSignDate"); 
		else 
		{
			initCTLSourceType();
			setRequiredElements("CTProviderDR_VDesc^CTSignLocDR_CTLOCDesc^CTSignDate"); 
		}
	}
	jQuery("#BFunds").linkbutton({iconCls: 'icon-w-paper'});
	jQuery("#BFunds").on("click", BFunds_Clicked);
	//muilt_Tab()  //回车下一输入框
};
///modified by ZY0252  20210301
function initCTLSourceType()
{
	$HUI.combobox('#CTLSourceType',{
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		data:[{
			id: '1',
			text: '计划'
		},{
			id: '2',
			text: '招标'
		},{
			id: '3',
			text: '设备项'
		},{					//czf 1879195 2021-04-21 begin
			id: '4',
			text: '设备'
		},{
			id: '5',
			text: '入库明细'
		},{
			id: '6',
			text: '配件项'
		},{
			id: '7',
			text: '验收单'		//czf 1879195 2021-04-21 end
		}]
	});
}
function initOCLSourceType()
{
	$HUI.combobox('#OCLSourceType',{
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		data:[{
			id: '0',
			text: '设备项'
		},{
			id: '1',
			text: '采购合同'
		},{
			id: '2',
			text: '招标'
		},{
			id: '3',
			text: '计划单'
		},{
			id: '4',
			text: '协议合同'
		},{
			id: '5',
			text: '投放合同'
		}]
	});
}

function loadBusinessData()
{
	var BussType=getElementValue("BussType");
	var BussID=getElementValue("BussID");
	var MainFlag=getElementValue("MainFlag");
	if ((BussType=="")||(BussID=="")) return;
	var DCRRowID=getElementValue("DCRRowID");
	if (BussType==21)
	{
		if(MainFlag=="Y")
		{
			var jsonData=tkMakeServerCall("web.DHCEQ.Plat.LIBBusinessModify","GetBusinessMain",BussType,"",BussID,DCRRowID)
			jsonData=jQuery.parseJSON(jsonData);
			if (jsonData.SQLCODE==-9012) {messageShow('','','',"入库单号不存在!",'',function(){reloadPage();});} 
			else if(jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
			setElementByJson(jsonData.Data);
		}
		else
		{
			var jsonData=tkMakeServerCall("web.DHCEQ.Plat.LIBBusinessModify","GetOneInStockList",BussID);
			jsonData=jQuery.parseJSON(jsonData);
			if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;};
			setElementByJson(jsonData.Data);
			setElement("EQItemDR",getElementValue("ISLItemDR"));
		}
	}
	else if (BussType==11)
	{
		var jsonData=tkMakeServerCall("web.DHCEQ.Plat.LIBBusinessModify","GetBusinessMain",BussType,"",BussID,DCRRowID)
		jsonData=jQuery.parseJSON(jsonData);
		if (jsonData.SQLCODE==-9012) {messageShow('','','',"验收单号不存在!",'',function(){reloadPage();});} //
		else if(jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
		setElementByJson(jsonData.Data);
		var OpenCheckListObj=jsonData.Data.OpenCheckList
		setElementByJson(OpenCheckListObj);
		setElement("EQItemDR",getElementValue("OCLItemDR"));
	}
	///modified by ZY0252  20210301
	else if (BussType==94)
	{
		if(MainFlag=="Y")
		{
			var jsonData=tkMakeServerCall("web.DHCEQ.Plat.LIBBusinessModify","GetBusinessMain",BussType,"",BussID,DCRRowID)
			jsonData=jQuery.parseJSON(jsonData);
			if (jsonData.SQLCODE==-9012) {messageShow('','','',"合同单号不存在!",'',function(){reloadPage();});} 
			else if(jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
			setElementByJson(jsonData.Data);
		}
		else
		{
			var jsonData=tkMakeServerCall("web.DHCEQ.Con.BUSContract","GetOneContractList",BussID);
			jsonData=jQuery.parseJSON(jsonData);
			if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;};
			setElementByJson(jsonData.Data);
			setElement("EQItemDR",getElementValue("CTLItemDR"));
		}
	}
	if (DCRRowID!="")
	{
		var DCRData=tkMakeServerCall("web.DHCEQ.Plat.LIBDataChangeRequest","GetOneDataChangeRequest",DCRRowID)
		DCRData=jQuery.parseJSON(DCRData);
		if (DCRData.SQLCODE<0) {messageShow("","","",DCRData.Data);return;};
		setElement("DCRStatus",DCRData.Data.DCRStatus);
		var DCRNewValue=DCRData.Data.DCRNewValue;
		var DCRNewValueObj=jQuery.parseJSON(DCRNewValue);
		if (BussType==11)
		{
			var OCRDataObj=DCRNewValueObj["OpenCheckRequest"];
			var OCLDataObj=DCRNewValueObj["OpenCheckList"];
			for(var key in OCRDataObj)
			{
				if ($("#"+key)!=undefined)
				{
					setElement(key,OCRDataObj[key]);
					$("#"+key).css("color","#FF8000");		//颜色标识修改的字段
				}
			}
			for(var key in OCLDataObj)
			{
				if ($("#"+key)!=undefined)
				{
					setElement(key,OCLDataObj[key]);
					$("#"+key).css("color","#FF8000");		//颜色标识修改的字段
				}
			}
		}
		else
		{
			for(var key in DCRNewValueObj)
			{
				if ($("#"+key)!=undefined)
				{
					setElement(key,DCRNewValueObj[key]);
					var obj=jQuery("#"+key);
					var objClassInfo=obj.prop("class");
					if (objClassInfo.indexOf("datebox-f")>=0){
						$("#"+key).next().children().css("color","#FF8000");		//颜色标识修改的字段
					}else{
						$("#"+key).css("color","#FF8000");		//颜色标识修改的字段
					}
				}
			}
		}
	}
}

function setEnabled()
{
	var Status=getElementValue("DCRStatus");
	var WaitAD=getElementValue("WaitAD");
	var Type=getElementValue("Type");
	if (Status!="0")	//"",1,2
	{
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		if (Status!="")
		{
			disableElement("BSave",true);
		}
		if (Status!="1")
		{
			disableElement("BAudit",true);
		}
		if (Status=="1")
		{
			if (Type!="1")
			{
				disableElement("BAudit",true);
			}
		}
	}
	else		//新增
	{
		disableElement("BAudit",true);
		if (WaitAD=="1")
		{
			disableElement("BSave",true);
			disableElement("BDelete",true);
			disableElement("BSubmit",true);
		}
	}
}

function BSave_Clicked()
{
	if (checkMustItemNull()) return;	//1995508 czf 2021-07-07
	var bussType=getElementValue("BussType");
	var bussID=getElementValue("BussID");
	var mainFlag=getElementValue("MainFlag");
	var DCRRowID=getElementValue("DCRRowID");
	var SelfFunds=getElementValue("SelfFunds")
	var OtherFunds=getElementValue("OtherFunds")
	if (bussType==11)
	{
		var Amount=getElementValue("OCLOriginalFee")*getElementValue("OCLQuantity");
		if (parseFloat(Amount).toFixed(2)!=parseFloat(Number(SelfFunds)+Number(OtherFunds)).toFixed(2))
		{
			alertShow("资金来源总金额之和不等于该验收单总金额,请修改资金来源!")	
			return;
		}
		setModelRowID(getElementValue("ModelOperMethod"),"OCLModelDR","OCLModelDR_MDesc","OCLItemDR");
		setProviderRowID(getElementValue("ProviderOperMethod"),"OCRProviderDR","OCRProviderDR_VDesc");
		setManuFactoryRowID(getElementValue("ManuFactoryOperMethod"),"OCLManuFactoryDR","OCLManuFactoryDR_VName");
		setLocationRowID(getElementValue("LocationOperMethod"),"OCLLocationDR","OCLLocationDR_LDesc");
	}else if(bussType==21){
		if (mainFlag=="Y"){
			setProviderRowID(getElementValue("ProviderOperMethod"),"ISProviderDR","ISProviderDR_VDesc");
		}
		else{
			setModelRowID(getElementValue("ModelOperMethod"),"ISLModelDR","ISLModelDR_MDesc","ISLItemDR");
			setManuFactoryRowID(getElementValue("ManuFactoryOperMethod"),"ISLManuFactoryDR","ISLManuFactoryDR_MFName");
		}
	}else if(bussType==94){
		if (mainFlag=="Y"){
			setProviderRowID(getElementValue("ProviderOperMethod"),"CTProviderDR","CTProviderDR_VDesc");
		}
		else{
			setModelRowID(getElementValue("ModelOperMethod"),"CTLModelDR","CTLModelDR_MDesc","CTLItemDR");
			setManuFactoryRowID(getElementValue("ManuFactoryOperMethod"),"CTLManuFactoryDR","CTLManuFactoryDR_MFName");
		}
	}
	var data=getInputList();
	data=JSON.stringify(data);
	var dealTypes=getDealBuss();
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.LIBBusinessModify","UpdateBusinessByTypeNew",bussType,bussID,data,mainFlag,dealTypes);
	var RtnObj=JSON.parse(jsonData)
	if (RtnObj.SQLCODE<0)
    {
	    messageShow("","","",RtnObj.Data);
	    return;
    }
    else
    {
	    messageShow("","","","保存成功!")
	    DCRRowID=RtnObj.Data;
	    var url=""
	    if (bussType==21)
	    {
		    if(mainFlag=="Y")
		    {
			    url="dhceq.plat.busmodify.csp?BussType="+bussType+"&BussID="+bussID+"&DCRRowID="+DCRRowID;
			}
			else
			{
				url="dhceq.plat.businessmodifylist.csp?BussType="+bussType+"&BussID="+bussID+"&DCRRowID="+DCRRowID;
			}
		}
		else if (bussType==11)
		{
			url="dhceq.plat.opencheckmodify.csp?BussType="+bussType+"&BussID="+bussID+"&DCRRowID="+DCRRowID;
		}
		///modified by ZY0252  20210301
	    else if (bussType==94)
	    {
		    if(mainFlag=="Y")
		    {
			    url="dhceq.plat.modifycontract.csp?BussType="+bussType+"&BussID="+bussID+"&DCRRowID="+DCRRowID;
			}
			else
			{
				url="dhceq.plat.modifycontractlist.csp?BussType="+bussType+"&BussID="+bussID+"&DCRRowID="+DCRRowID;
			}
		}
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href= url;
    }
}

function BSubmit_Clicked()
{
	var bussType=getElementValue("BussType");
	var bussID=getElementValue("BussID");
	var mainFlag=getElementValue("MainFlag");
	var DCRRowID=getElementValue("DCRRowID");
	if (DCRRowID=="") return;
	//提交之前先保存	modified by czf 2020-12-16 begin
	var SelfFunds=getElementValue("SelfFunds")
	var OtherFunds=getElementValue("OtherFunds")
	if (bussType==11)
	{
		var Amount=getElementValue("OCLOriginalFee")*getElementValue("OCLQuantity");
		if (parseFloat(Amount).toFixed(2)!=parseFloat(Number(SelfFunds)+Number(OtherFunds)).toFixed(2))
		{
			alertShow("资金来源总金额之和不等于该验收单总金额,请修改资金来源!")	
			return;
		}
	}
	var data=getInputList();
	data=JSON.stringify(data);
	var dealTypes=getDealBuss();
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.LIBBusinessModify","UpdateBusinessByTypeNew",bussType,bussID,data,mainFlag,dealTypes);
	var RtnObj=JSON.parse(jsonData)
	if (RtnObj.SQLCODE<0)
    {
	    messageShow("","","",RtnObj.Data);
	    return;
    }
    //提交调整单	modified by czf 2020-12-16 end
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.LIBDataChangeRequest","SubmitData",DCRRowID);
	var RtnObj=JSON.parse(jsonData)
	if (RtnObj.SQLCODE<0)
    {
	    messageShow("","","",RtnObj.Data);
	    return;
    }
    else
    {
	    messageShow("","","","提交成功!")
	    var url=""
	    if (bussType==21)
	    {
		    if(mainFlag=="Y")
		    {
			    url="dhceq.plat.busmodify.csp?BussType="+bussType+"&BussID="+bussID+"&DCRRowID="+DCRRowID;
			}
			else
			{
				url="dhceq.plat.businessmodifylist.csp?BussType="+bussType+"&BussID="+bussID+"&DCRRowID="+DCRRowID;
			}
			if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
				url += "&MWToken="+websys_getMWToken()
			}
			window.location.href= url;
		}
		else if (bussType==11)
		{
			url="dhceq.plat.opencheckmodify.csp?BussType="+bussType+"&BussID="+bussID+"&DCRRowID="+DCRRowID;
		}
		///modified by ZY0252  20210301
	    else if (bussType==94)
	    {
		    if(mainFlag=="Y")
		    {
			    url="dhceq.plat.modifycontract.csp?BussType="+bussType+"&BussID="+bussID+"&DCRRowID="+DCRRowID;
			}
			else
			{
				url="dhceq.plat.modifycontractlist.csp?BussType="+bussType+"&BussID="+bussID+"&DCRRowID="+DCRRowID;
			}
		}
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href= url;

    }
}

function BDelete_Clicked()
{
	var bussType=getElementValue("BussType");
	var bussID=getElementValue("BussID");
	var mainFlag=getElementValue("MainFlag");
	var DCRRowID=getElementValue("DCRRowID");
	if (DCRRowID=="") return;
	var Rtn=tkMakeServerCall("web.DHCEQ.Plat.LIBDataChangeRequest","SaveData",DCRRowID,"1");
	if (Rtn<0)
    {
	    messageShow("","","","删除失败!");
	    return;
    }
    else
    {
	    messageShow("","","","删除成功!")
	    if (bussType==21)
	    {
		    if(mainFlag=="Y")
		    {
			    var url="dhceq.plat.busmodify.csp?BussType="+bussType+"&BussID="+bussID+"&DCRRowID="+Rtn;
			}
			else
			{
				var url="dhceq.plat.businessmodifylist.csp?BussType="+bussType+"&BussID="+bussID+"&DCRRowID="+Rtn;
			}
		}
		else if (bussType==11)
		{
			url="dhceq.plat.opencheckmodify.csp?BussType="+bussType+"&BussID="+bussID+"&DCRRowID="+Rtn;
		}
		///modified by ZY0252  20210301
	    else if (bussType==94)
	    {
		    if(mainFlag=="Y")
		    {
			    url="dhceq.plat.modifycontract.csp?BussType="+bussType+"&BussID="+bussID+"&DCRRowID="+Rtn;
			}
			else
			{
				url="dhceq.plat.modifycontractlist.csp?BussType="+bussType+"&BussID="+bussID+"&DCRRowID="+Rtn;
			}
		}
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href= url;
    }
}

function BAudit_Clicked()
{ 
	var bussType=getElementValue("BussType");
	var bussID=getElementValue("BussID");
	var mainFlag=getElementValue("MainFlag");
	var DCRRowID=getElementValue("DCRRowID");
	if (DCRRowID=="") return;
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.LIBDataChangeRequest","AuditData",DCRRowID);
	var RtnObj=JSON.parse(jsonData)
	if (RtnObj.SQLCODE<0)
    {
	    messageShow("","","",RtnObj.Data);
	    return;
    }
    else
    {
	    messageShow("","","","审核成功!")
	    var url=""
	    if (bussType==21)
	    {
		    if(mainFlag=="Y")
		    {
			    url="dhceq.plat.busmodify.csp?BussType="+bussType+"&BussID="+bussID+"&DCRRowID="+DCRRowID;
			}
			else
			{
				url="dhceq.plat.businessmodifylist.csp?BussType="+bussType+"&BussID="+bussID+"&DCRRowID="+DCRRowID;
			}
		}
		else if (bussType==11)
		{
			url="dhceq.plat.opencheckmodify.csp?BussType="+bussType+"&BussID="+bussID+"&DCRRowID="+DCRRowID;
		}
		///modified by ZY0252  20210301
	    else if (bussType==94)
	    {
		    if(mainFlag=="Y")
		    {
			    url="dhceq.plat.modifycontract.csp?BussType="+bussType+"&BussID="+bussID+"&DCRRowID="+DCRRowID;
			}
			else
			{
				url="dhceq.plat.modifycontractlist.csp?BussType="+bussType+"&BussID="+bussID+"&DCRRowID="+DCRRowID;
			}
		}
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href= url;
    }
}

function getUniteBussNos()
{
	var bussType=getElementValue("BussType");
	var bussID=getElementValue("BussID");
	var mainFlag=getElementValue("MainFlag");
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.LIBBusinessModify","GetUniteBuss",bussType,bussID,"",mainFlag);
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;};
	for (var key in jsonData.Data)
	{
		$("#"+key).text(jsonData.Data[key]);
		if (jsonData.Data[key]!="")
		{
			$("#"+key).parent().css('display','block');
			$("#"+key).parent().find(".hisui-checkbox").checkbox("setValue",true);
		}
	}
}

function getDealBuss()
{
	var bussTypes="";
	$(":checkbox").each(function(){
		var obj=$(this)
		if (obj.checkbox("getValue"))
		{
			if (bussTypes!="") bussTypes=bussTypes+",";
			bussTypes=bussTypes+obj.parent().parent().attr("id");
		}
	});
	return bussTypes;
}

function clearData(elementID)
{
	var elementName=elementID.split("_")[0];
	setElement(elementName,"");
	return;
}

function setSelectValue(elementID,rowData)
{
	var elementName=elementID.split("_")[0];
	setElement(elementName,rowData.TRowID);
}

function BFunds_Clicked()
{
	var BussType=getElementValue("BussType");
	var BussID=getElementValue("BussID")
	var DCRRowID=getElementValue("DCRRowID");
	var DCRStatus=getElementValue("DCRStatus")
	var ReadOnly=1
	if ((DCRStatus==0)||(DCRStatus=="")) ReadOnly=0
	var FundsAmount=0
	var FromType=""
	var FromID=""
	if (BussType==21) 
	{
		FromType=3;
		FromID=BussID
	}
	else if (BussType==11) 
	{
		FromType=0;
		FromID=getElementValue("OCLRowID")
		FundsAmount=getElementValue("OCLOriginalFee")*getElementValue("OCLQuantity")
	}
	FundsAmount=parseFloat(FundsAmount).toFixed(2);
    var str='dhceq.em.funds.csp?FromType='+FromType+'&FromID='+FromID+'&ReadOnly='+ReadOnly+'&FundsAmount='+FundsAmount+'&DCRRowID='+DCRRowID+'&DataChangeFlag=Y';
    showWindow(str,"资金来源","","","icon-w-paper","modal","","","small",SelfFunds_Change); 
}

function SelfFunds_Change()
{
	if (getElementValue("GetSelfFundsID")=="")
	{
		alertShow("请设置自有资金参数!")
		return
	}
	var BussType=getElementValue("BussType");
	var FundsAmount=0
	var FromType=""
	var FromID=""
	var Originalfee=0
	var QuantityNum=0
	if (BussType==21) 
	{
		FromType=3;
		FromID=BussID
		Originalfee=getElementValue("ISLOriginalFee");
		QuantityNum=getElementValue("ISLQuantity")
	}
	else if (BussType==11) 
	{
		FromType=0;
		FromID=getElementValue("OCLRowID")
		Originalfee=getElementValue("OCLOriginalFee");
		QuantityNum=getElementValue("OCLQuantity")
	}
	if (Originalfee=="") Originalfee=0
	Originalfee=parseFloat(Originalfee);
	if (QuantityNum=="") QuantityNum=0
	QuantityNum=parseFloat(QuantityNum);
	if (FromID=="")
	{
		setElement("SelfFunds", Originalfee*QuantityNum)
	}
	else
	{
		var result=tkMakeServerCall("web.DHCEQ.EM.BUSFunds","GetSourceFunds",FromType,FromID,Originalfee*QuantityNum,getElementValue("GetSelfFundsID"),"1","Y");
		var list=result.split("^");
		if (result[0]<0)
		{
			setElement("SelfFunds",0)
		}
		else
		{
			setElement("SelfFunds",result)
		}
	}
	var SelfFunds=getElementValue("SelfFunds")
	if (SelfFunds=="") SelfFunds=0
	SelfFunds=parseFloat(SelfFunds);
	SelfFunds=SelfFunds.toFixed(2)
	setElement("SelfFunds",SelfFunds)
	var tmpValue=parseFloat(Originalfee*QuantityNum);
	tmpValue=tmpValue.toFixed(2)-SelfFunds;
	setElement("OtherFunds",tmpValue.toFixed(2))
	tabflag=0 
}

function setModelRowID(type,ElementID,ElementName,ItemDR)
{
	if((type=="0")||(type==""))
	{
		setElement(ElementID,"");
	}
	else
	{
		var modelDesc=getElementValue(ElementName);
		if (modelDesc=="") return;
		var data=modelDesc+"^";
		var item=getElementValue(ItemDR);
		var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTModel","UpdModel",data, item);
		jsonData=JSON.parse(jsonData);
		if (jsonData.SQLCODE==0) setElement(ElementID,jsonData.Data);
	}
}

function setProviderRowID(type,ElementID,ElementName)
{
	if((type=="0")||(type==""))
	{
		setElement(ElementID,"");
	}
	else
	{
		var providerName=getElementValue(ElementName);
		if (providerName=="") return;
		var FirmType=2
	 	var val="^"+providerName+"^^^"+FirmType;	//2163109 czf
		var ProviderRowID=tkMakeServerCall("web.DHCEQForTrak","UpdProvider",val);
		if (ProviderRowID>0) setElement(ElementID,ProviderRowID);
	}
}

function setManuFactoryRowID(type,ElementID,ElementName)
{
	if((type=="0")||(type==""))
	{
		setElement(ElementID,"");
	}
	else
	{
		var manuFactoryName=getElementValue(ElementName);
		if (manuFactoryName=="") return;
		var FirmType=3
	 	var val="^"+manuFactoryName+"^^^"+FirmType;		//2163109 czf
		var ManuFactoryRowID=tkMakeServerCall("web.DHCEQForTrak","UpdProvider",val);
		if (ManuFactoryRowID>0) setElement(ElementID,ManuFactoryRowID);
	}
}

function setLocationRowID(type,ElementID,ElementName)
{
	if((type=="0")||(type==""))
	{
		setElement(ElementID,"");
	}
	else
	{
		var locationDesc=getElementValue(ElementName);
		if (locationDesc=="") return;
		var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTLocaton","UpdLocation",locationDesc);
		jsonData=JSON.parse(jsonData);
		if (jsonData.SQLCODE==0) setElement(ElementID,jsonData.Data);
	}
}
