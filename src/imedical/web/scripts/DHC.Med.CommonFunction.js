	/* =========================================================================
	NAME: DHC.Med.CommonFunction.js
	AUTHOR: lxf
	DATE  : 2008-10-22
	============================================================================ */
	//Add Items to "OPTION" ListBox Control
	function AddListItem(controlID, itemCaption, itemValue, pos)
	{
		var obj = document.getElementById(controlID);
		var objItm = document.createElement("OPTION");
		if(pos >=0 )
		{
			obj.options.add(objItm, pos);		
		}else
		{
			obj.options.add(objItm);
		}
		objItm.innerText = itemCaption;
		objItm.value = itemValue;
		return objItm;
	}
//Disable Elements on page ,including magnifier Component
function DisableById(componentId,id)
{
	var obj=document.getElementById(id);
	if (obj) obj.disabled=true;
	if (componentId>0)
	{
		obj=document.getElementById("ld"+componentId+"i"+id);
		if (obj) obj.style.display ="none";
	}
}

//Disable Elements on page ,including magnifier Component
function DisableComponentById(id)
{
	var tformName=document.getElementById("TFORM").value;
	var getComponentIdByName=document.getElementById("GetComponentIdByName").value;
	var componentId=cspRunServerMethod(getComponentIdByName,tformName);
	
	var obj=document.getElementById(id);
	if (obj) obj.disabled=true;
	if (componentId>0)
	{
		obj=document.getElementById("ld"+componentId+"i"+id);
		if (obj) obj.style.display ="none";
	}
}
function DisableElementsByTagName(TagName){
	var Elements = document.getElementsByTagName(TagName);
	var len = Elements.length;
	for(var i = 0;i < len; i++)
	{
	   Elements[i].disabled=true;
	}	
}
//Disable Elements By NameList.Format:"name1^name2^name3"
function DisableElementsByNameList(nameList){
	var nameArray=nameList.split("^");
	for(var i=0;i<nameArray.length;i++){
		document.getElementById(nameArray[i]).disabled=true;
	}
}

function HideHrefElements(){
	var hrefElements = document.getElementsByTagName("a");
	var len = hrefElements.length;
	for(var i = 0;i < len; i++)
	{
	   hrefElements[i].style.display ="none";;
	}	
}

function DHCC_GetElementData(ElementName){
 	var obj=document.getElementById(ElementName);
 	if(obj){
 		if(obj.tagName=='LABEL'){
 			return obj.innerText;
		}else{
 			if(obj.type=='checkbox')return obj.checked;
	 		return obj.value;
		}
	}
 	return "";
}

function DHCC_SetElementData(ElementName,value){
 	var obj=document.getElementById(ElementName);
 	if(obj){
 		obj.value=value;
	}
 	return "";
}
