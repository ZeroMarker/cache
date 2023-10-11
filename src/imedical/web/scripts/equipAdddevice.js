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

///Description: Êý¾Ý±£´æ·½·¨
function BSave_Clicked()
{
	if (checkMustItemNull()) return;
	var ExObj=getElementValue("EQItemDR_MIDesc")
	var EquipTypeDR=getElementValue("EQEquipTypeDR")
	if (ExObj=="") {	
		alertShow("设备项不能为空！")
		return
    }
    if (EquipTypeDR=="") {	
		alertShow("管理类组不能为空！")
		return
    }
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","SaveExObj",ExObj,EquipTypeDR);
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) 
	{
		messageShow('alert','error','提示',jsonData.Data,'','','');
		return;
	}
	else
	{
		messageShow('alert','info','提示',"保存成功！","","","") 
		var url="dhceq.em.equipAdddevice.csp?RowID="+jsonData.Data;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
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
	$.messager.confirm('提示','是否确认删除?',function(r){    
    if (r){    
    		setElement("EQInvalidFlag","true");
			var data=getInputList();
			data=JSON.stringify(data);
			var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","SaveData",data,""); //modfied by wy 2019-12-16 ÐèÇó1136221
			jsonData=jQuery.parseJSON(jsonData);
			if (jsonData.SQLCODE<0) {messageShow('alert','error','提示',jsonData.Data,'','','');return;}
			messageShow('alert','success','提示','操作成功!','','','');
			var url="dhceq.em.equipclass.csp?RowID=";
			if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
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

