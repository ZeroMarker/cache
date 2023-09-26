
$(function(){
	initUserInfo();
	initMessage("BussWarnDays"); 	//获取业务消息
	defindTitleStyle();
	//initLookUp("");
	initButton(); //按钮初始化
	initButtonWidth();
	setRequiredElements("BWDWarnDay^BWDWarnDaysNum");
	fillData();
});

function fillData()
{
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.BussWarnDays","GetOneBussWarnDays",getElementValue("BWDSourceType"),getElementValue("BWDSubType"),getElementValue("BWDBussID"));
	jsonData=jQuery.parseJSON(jsonData);
	//alert(jsonData.Data)
	if (jsonData.SQLCODE<0)
	{
		messageShow('alert','error','错误提示',jsonData.Data)
		return;
	}
	setElementByJson(jsonData.Data);
	if (jsonData.Data=="")
	{
		setElement("BWDSourceType_Desc", "采购合同到货");
		setElement("BWDSubType_Desc", "采购合同明细");
		jQuery('#BWDWarnDay').datebox('setValue', getElementValue("pWarnDay"));
		//jQuery('#BWDWarnDaysNum').val("30");
	}
	setElement("Name", getElementValue("pName"));
	if (getElementValue("ReadOnly")==1)
	{ 
		disableElement("BSave",true);
		disableElement("BDelete",true);
	}
	else
	{
		if (getElementValue("BWDRowID")=="") disableElement("BDelete",true);
	}
}
/*//Lookup返回处理		*****预留*****
function setSelectValue(elementID,rowData)
{
	if(elementID=="CType_Desc")
	{
		setElement("CCType",rowData.TRowID);
		initItemLookUp();
	}
	else if(elementID=="CCVendorDR_VDesc") {setElement("CCVendorDR",rowData.TRowID);}
}
///清空Lookup
function clearData(elementID)
{
	var elementName=elementID.split("_")[0]
	setElement(elementName,"")
	return;
}*/
function BSave_Clicked()
{
	if (getElementValue("BWDWarnDay")=="")
	{
		messageShow('alert','error','错误提示','预警日期不能为空!');
		return;
	}
	if (getElementValue("BWDWarnDaysNum")=="")
	{
		messageShow('alert','error','错误提示','触发预警天数不能为空!');
		return;
	}
	var data=getInputList();
	data=JSON.stringify(data);
	//alert(data)
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.BussWarnDays","SaveData",data);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		var url='dhceq.plat.busswarndays.csp?SourceType='+getElementValue("BWDSourceType")+'&SubType='+getElementValue("BWDSubType")+'&SourceID='+getElementValue("BWDBussID")+"&ReadOnly="+getElementValue("ReadOnly")+"&Name="+getElementValue("pName");
		messageShow("popover","","","操作成功!");	//默认延迟2秒
		setTimeout(function(){window.location.href=url}, 2000);
	}
	else
    {
		messageShow('alert','error','错误提示',jsonData.Data);
		return
    }
}
function BDelete_Clicked()
{
	messageShow("confirm","info","提示","确定删除当前设置?","",BDelete_Opt,function(){
		return;
	});	
}
function BDelete_Opt()
{
	var rowid=getElementValue("BWDRowID");
	if (rowid=="")
	{
		$.messager.show({title: '提示',msg: '未保存记录不能删除'});
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.BussWarnDays","DeleteData",rowid);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		messageShow("popover","","","操作成功!");
		ClearElement();
	}
	else
    {
		messageShow('alert','error','错误提示',jsonData.Data);
		return
    }
}
function ClearElement()
{
	//alertShow("ClearElement")
	jQuery('#BWDRowID').val('');
	jQuery('#BWDWarnDay').datebox('setValue',getElementValue("pWarnDay"));
	jQuery('#BWDEndDay').datebox('setValue','');
	jQuery('#BWDWarnDaysNum').val('');
	jQuery('#BWDOverDueDaysNum').val('');
	jQuery('#BWDRemark').val('');
}