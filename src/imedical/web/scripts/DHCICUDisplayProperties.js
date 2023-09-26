var preSelectRow=-1;
var selectRow=0;
function BodyLoadHandler()
{
	var obj=document.getElementById('Add')
	if(obj) obj.onclick=Insert_click;
	var obj=document.getElementById('Modify')
	if(obj) obj.onclick=Update_click;
	var obj=document.getElementById('Remove')
	if (obj) obj.onclick = Delete_click;
}
	
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	selectRow=rowObj.rowIndex;
	if (!selectRow) return;
	
	if (preSelectRow!=selectRow)
	{
		SetElementByElement('PropertyItem',"V",'TPropertyItemDescz'+selectRow,"I"," ","");
	    SetElementByElement("PropertyValue","V","TPropertyValuez" + selectRow,"I"," ","");
	    SetElementByElement("PropertyValueID","V","TPropertyValueIDz" + selectRow,"I"," ","");
	    SetElementByElement("PropertyItemID","V","TPropertyItemIDz" + selectRow,"I"," ","");
		preSelectRow=selectRow;
	}
	else
	{
	    SetElementValue("PropertyItem","V","");
	    SetElementValue("PropertyValue","V","");
	    SetElementValue("PropertyValueID","V","");
	    SetElementValue("PropertyItemID","V","");
	    
		preSelectRow=-1
		selectRow=0
	}
}

function Insert_click()
{
	if (selectRow>0) 
	{
		alert('数据行被选中,不能进行添加!')
		return;
	}
    var displayItemID=request("DisplayItemID").replace("#","") ;//= parent.frames['RPMiddle'].GetElementValue("ItemID","V");
    var propertyItemID = GetElementValue("PropertyItemID","V");
    var propertyValue = GetElementValue("PropertyValue","V");

	var obj=document.getElementById('AddPropertyValue')
	if(obj) 
	{
	    var retStr = cspRunServerMethod(obj.value, propertyItemID, propertyValue,displayItemID);
		if (retStr!=0) alert(retStr);
		else 
		{
			alert('添加成功!');
			document.location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCICUDisplayProperties&DisplayItemID=" + displayItemID;
		}
	}
}

function Update_click(){
	if (selectRow<1) 
	{
		alert('请选择一条数据再进行更新操作!');
		return;
	}

    var propertyValueID = GetElementValue("PropertyValueID","V");
    var displayItemID = GetElementValue("DisplayItemID","V");
    var propertyItemID = GetElementValue("PropertyItemID","V");
    var propertyValue = GetElementValue("PropertyValue","V");
    

    var obj = document.getElementById('ModifyPropertyValue');
	if(obj) 
	{
	    var retStr = cspRunServerMethod(obj.value, propertyValueID, displayItemID,propertyItemID, propertyValue);
		if (retStr!=0) alert(retStr);
		else
		{
			alert('更新成功!');
			document.location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCICUDisplayProperties&DisplayItemID=" + displayItemID;
		}
	}
}

function Delete_click(){
	if (selectRow<1) 
	{
		alert('请选择一条数据再进行删除操作!')
		return;
    }
    var propertyValueID = GetElementValue("PropertyValueID","V");
	var obj=document.getElementById('RemovePropertyValue',"V")
	if(obj) 
	{
		retStr = cspRunServerMethod(obj.value, propertyValueID);
		if (retStr!=0) alert(retStr);
		else 
		{
			alert('删除成功!')
			document.location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCICUDisplayProperties&DisplayItemID=" + displayItemID;
		}
	}	
}

function GetPropertyItem(selectItemStr) {
    var propertyItemArr = selectItemStr.split("^");
    SetElementValue("PropertyItemID","V",propertyItemArr[0]);
    SetElementValue("PropertyItem","V",propertyItemArr[2]);
}
function request(paras){ 
var url = location.href;  
var paraString = url.substring(url.indexOf("?")+1,url.length).split("&");  
var paraObj = {}  
for (i=0; j=paraString[i]; i++){  
paraObj[j.substring(0,j.indexOf("=")).toLowerCase()] = j.substring(j.indexOf("=")+1,j.length);  
}  
var returnValue = paraObj[paras.toLowerCase()];  
if(typeof(returnValue)=="undefined"){  
return "";  
}else{  
return returnValue;  
}  
} 

document.body.onload=BodyLoadHandler;