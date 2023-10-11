$(function(){
	initDocument();
});

function initDocument()
{
	initUserInfo();
	initLookUp();
	initMessage();  //add by lmm 2019-09-09
	defindTitleStyle();
	initButton();
	setEnabled();
}

///Description: �0�8�0�5�0�6�0�6���0�5�0�7�0�3���0�5����
function BSave_Clicked()
{
	if (checkMustItemNull()) return;
	var ExObj=getElementValue("EQItemDR_MIDesc")
	var EquipTypeDR=getElementValue("EQEquipTypeDR")
	if (ExObj=="") {	
		alertShow("�豸���Ϊ�գ�")
		return
    }
    if (EquipTypeDR=="") {	
		alertShow("�������鲻��Ϊ�գ�")
		return
    }
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","SaveExObj",ExObj,EquipTypeDR);
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) 
	{
		messageShow('alert','error','��ʾ',jsonData.Data,'','','');
		return;
	}
	else
	{
		messageShow('alert','info','��ʾ',"����ɹ���","","","") 
		var url="dhceq.em.equipAdddevice.csp?RowID="+jsonData.Data;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href= url;
	}
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
	$.messager.confirm('��ʾ','�Ƿ�ȷ��ɾ��?',function(r){    
    if (r){    
    		setElement("EQInvalidFlag","true");
			var data=getInputList();
			data=JSON.stringify(data);
			var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","SaveData",data,""); //modfied by wy 2019-12-16 �0�4���0�5��1136221
			jsonData=jQuery.parseJSON(jsonData);
			if (jsonData.SQLCODE<0) {messageShow('alert','error','��ʾ',jsonData.Data,'','','');return;}
			messageShow('alert','success','��ʾ','�����ɹ�!','','','');
			var url="dhceq.em.equipclass.csp?RowID=";
			if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
				url += "&MWToken="+websys_getMWToken()
			}
			window.location.href= url;
   	 	}    
	});
}
function setSelectValue(vElementID,rowData)
{
	if (vElementID=="EQEquipTypeDR_ETDesc")
	{
		setElement("EQEquipTypeDR",rowData.TRowID)
	}
}
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}

