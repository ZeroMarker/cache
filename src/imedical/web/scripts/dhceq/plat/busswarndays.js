
$(function(){
	initUserInfo();
	initMessage("BussWarnDays"); 	//��ȡҵ����Ϣ
	defindTitleStyle();
	//initLookUp("");
	initButton(); //��ť��ʼ��
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
		messageShow('alert','error','������ʾ',jsonData.Data)
		return;
	}
	setElementByJson(jsonData.Data);
	if (jsonData.Data=="")
	{
		setElement("BWDSourceType_Desc", "�ɹ���ͬ����");
		setElement("BWDSubType_Desc", "�ɹ���ͬ��ϸ");
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
/*//Lookup���ش���		*****Ԥ��*****
function setSelectValue(elementID,rowData)
{
	if(elementID=="CType_Desc")
	{
		setElement("CCType",rowData.TRowID);
		initItemLookUp();
	}
	else if(elementID=="CCVendorDR_VDesc") {setElement("CCVendorDR",rowData.TRowID);}
}
///���Lookup
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
		messageShow('alert','error','������ʾ','Ԥ�����ڲ���Ϊ��!');
		return;
	}
	if (getElementValue("BWDWarnDaysNum")=="")
	{
		messageShow('alert','error','������ʾ','����Ԥ����������Ϊ��!');
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
		messageShow("popover","","","�����ɹ�!");	//Ĭ���ӳ�2��
		setTimeout(function(){window.location.href=url}, 2000);
	}
	else
    {
		messageShow('alert','error','������ʾ',jsonData.Data);
		return
    }
}
function BDelete_Clicked()
{
	messageShow("confirm","info","��ʾ","ȷ��ɾ����ǰ����?","",BDelete_Opt,function(){
		return;
	});	
}
function BDelete_Opt()
{
	var rowid=getElementValue("BWDRowID");
	if (rowid=="")
	{
		$.messager.show({title: '��ʾ',msg: 'δ�����¼����ɾ��'});
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.BussWarnDays","DeleteData",rowid);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		messageShow("popover","","","�����ɹ�!");
		ClearElement();
	}
	else
    {
		messageShow('alert','error','������ʾ',jsonData.Data);
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