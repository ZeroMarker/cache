$(function(){
	setRequiredElements("EQItemDR_MIDesc^EQUseLocDR_CTLOCDesc^EQEquipTypeDR_ETDesc")  //modified by wy 2020-3-31 ����1249945
	initDocument();
	
});

function initDocument()
{
	initUserInfo();
	//add by csj 2020-02-11 ��׼��-����̨�˷���ʹ�ÿ��ҷǱ����޸�
	$("#EQClassFlag").checkbox({
		onCheckChange:function(e,v){
			setItemRequire("EQUseLocDR_CTLOCDesc",!v)
		}
	})
	fillData();
	initLookUp();
	initMessage();  //add by lmm 2019-09-09
	var paramsFrom=[{"name":"EquipTypeDR","type":"2","value":""},{"name":"StatCatDR","type":"2","value":""},{"name":"Name","type":"2","value":""},{"name":"AssetType","type":"1","value":""},{"name":"MaintFlag","type":"2","value":"1"}];
    singlelookup("EQItemDR_MIDesc","EM.L.GetMasterItem",paramsFrom,""); //�豸�����
	defindTitleStyle();
	initButton();
	setEnabled();
	initEquipAttributeList();  /// modify by zc0054 2019-12-02 �豸���Գ�ʼ��
	muilt_Tab()  //add by lmm 2020-06-29 �س���һ�����
}

///Description: ��ȡ̨����Ϣ������
function fillData()
{
	var RowID=getElementValue("EQRowID");
	if (RowID=="") return;
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","GetOneEquip",RowID);
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow('alert','error','����',jsonData.Data,'','','');return;}
	setElementByJson(jsonData.Data);
}

///Input: vElementID LookUpԪ��ID  rowData ѡ��������
function setSelectValue(elementID,rowData)
{
 if(elementID=="EQUnitDR_UOMDesc") {setElement("EQUnitDR",rowData.TRowID)}
	else if(elementID=="EQEquiCatDR_ECDesc") {setElement("EQEquiCatDR",rowData.TRowID)}
	else if(elementID=="EQItemDR_MIDesc") {getMasterItem(rowData)}
}

function clearData(elementID)
{
	var elementName=elementID.split("_")[0]
	setElement(elementName,"")
	return;
}

///Description: ���ݱ��淽��
function BSave_Clicked()
{
	if (checkMustItemNull()) return;
	var data=getInputList();
	data=JSON.stringify(data);
	/// modify by zc0054 2019-12-02 begin �豸������ص���
    var SelectType=$("#EquipAttributeList").keywords("getSelected");
    
	var i=SelectType.length;
	var EquipAttributeString=""
	for (var j=0;j<i;j++)
	{
		if(EquipAttributeString=="")
		{
			EquipAttributeString=SelectType[j].id
		}else
		{
			EquipAttributeString=EquipAttributeString+"^"+SelectType[j].id
		}
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","SaveData",data,EquipAttributeString);
	/// modify by zc0054 2019-12-02 end �豸������ص���
	jsonData=jQuery.parseJSON(jsonData);
	// Mozy0241	1142519		2019-12-25	�������ؽ������
	if (jsonData.SQLCODE<0) 
	{
		messageShow('alert','error','����',jsonData.Data,'','','');
		return;
	}
	else
	{
		messageShow('alert','info','��ʾ',"����ɹ�","","","") 
		var url="dhceq.em.equipclass.csp?RowID="+jsonData.Data;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href= url;
	}
}
function confirmFun(){ 
	var url="dhceq.em.equipcass.csp?RowID="+jsonData.Data;
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		url += "&MWToken="+websys_getMWToken()
	}
	window.location.href= url;
}

function getMasterItem(rowData)
{
	setElement("EQItemDR_MIDesc",rowData.TName)
	setElement("EQItemDR",rowData.TRowID)
	setElement("EQEquipTypeDR_ETDesc",rowData.TEquipType)
	setElement("EQEquipTypeDR",rowData.TEquipTypeDR)
	setElement("EQStatCatDR_SCDesc",rowData.TStatCat)
	setElement("EQStatCatDR",rowData.TStatCatDR)
	setElement("EQEquiCatDR_ECDesc",rowData.TCat)
	setElement("EQEquiCatDR",rowData.TCatDR)
	setElement("EQName",rowData.TName)
	setElement("EQCode",rowData.TCode)
	setElement("EQUnitDR_UOMDesc",rowData.TUnit)
	setElement("EQUnitDR",rowData.TUnitDR)
	/// modify by zc0054 2019-12-02 begin�豸������ص���
	var CodeString=tkMakeServerCall("web.DHCEQ.EM.BUSEquipAttribute","GetOneEquipAttribute","1",rowData.TRowID)
	$("#EquipAttributeList").keywords("clearAllSelected")
	if (CodeString!="")
	{
		var list=CodeString.split("^");
		var i=list.length;
		for (var j=0;j<i;j++)
		{
			$("#EquipAttributeList").keywords("select",list[j]);
		}
	}
	/// modify by zc0054 2019-12-02 end �豸������ص���
}
function setEnabled()
{
	var RowID=getElementValue("EQRowID");
	if(RowID=="")
	{
		disableElement("BDelete",true);
	}
}

function BDelete_Clicked()
{  
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){    
    		setElement("EQInvalidFlag","true");
			var data=getInputList();
			data=JSON.stringify(data);
			var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","SaveData",data,""); //modfied by wy 2019-12-16 ����1136221
			jsonData=jQuery.parseJSON(jsonData);
			if (jsonData.SQLCODE<0) {messageShow('alert','error','����',jsonData.Data,'','','');return;}
			messageShow('alert','success','��ʾ','ɾ���ɹ�','','','');
			var url="dhceq.em.equipclass.csp?RowID=";
			if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
				url += "&MWToken="+websys_getMWToken()
			}
			window.location.href= url;
   	 	}    
	});
}


/// modify by zc0054 2019-12-02 �豸���Գ�ʼ��
///�����豸���Թؼ����б�
function initEquipAttributeList()
{
	var result=""
	if(getElementValue("EQRowID")!="")
	{
		var result=getElementValue("EQRowID");
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","ReturnJsonEquipAttribute",result)
	jsonData=jQuery.parseJSON(jsonData);
	var string=eval('(' + jsonData.Data+ ')');
        $("#EquipAttributeList").keywords({
                items:string
        });
    $("#EquipAttributeList").parent().height($("#EquipAttributeList").height())	//add by csj 2020-03-26 ����ţ�1238681
}