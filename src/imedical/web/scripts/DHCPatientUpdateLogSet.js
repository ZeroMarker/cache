document.body.onload = BodyLoadHandler;
function BodyLoadHandler() {
	var obj=document.getElementById("ClassPropertyList");
	if(obj){
		obj.multiple=true;
	}
	var obj=document.getElementById("UPLSClassList");
	if(obj){
		obj.size=1; 
		obj.multiple=false;
		obj.selectedIndex=-1;
		obj.onchange=UPLSClassListChange;
	}
	var obj=document.getElementById("UPLSClassPropertyList");
	if(obj)
	{
		obj.multiple=true;
		obj.onclick=UPLSClassPropertyListClick;
	}
	var obj=document.getElementById("QueryClassProperty");
	if(obj)obj.onclick=QueryClassPropertyClick;
	var obj=document.getElementById("Add");
	if(obj)obj.onclick=AddClick;
	var obj=document.getElementById("Up");
	if(obj)obj.onclick=UpClick;	
	var obj=document.getElementById("Down");
	if(obj)obj.onclick=DownClick;	
	var obj=document.getElementById("Delete");
	if(obj)obj.onclick=DeleteClick;
	var obj=document.getElementById("UpdateDescription");
	if(obj)obj.onclick=UpdateDescriptionClick;
	
	var obj=document.getElementById("UPLSClassListLink");
	if(obj)
	{
		obj.multiple=false;
		obj.size=20; 
	}
	var obj=document.getElementById("SaveUPLSClassListLink");
	if(obj) obj.onclick=PropertyLinkSave;
				
}		
function QueryClassPropertyClick()
{
	var obj=document.getElementById("UPLSClassList");
	if(obj)obj.selectedIndex=-1;
	var obj=document.getElementById("ClassPropertyList");
	if(obj)
	{
		ClearAllList(obj);
		var ClassName="";
		var obj=document.getElementById("ClassName");
		if(obj)ClassName=obj.value;
		var encmeth="";
		var obj=document.getElementById("SelectPropertyBroker");
		if(obj)encmeth=obj.value;
		if (encmeth!=""){
			var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","ClassPropertyList",ClassName);
		}
	}
	var obj=document.getElementById("UPLSClassPropertyList");
	if(obj)
	{
		ClearAllList(obj);
		var ClassName="";
		var obj=document.getElementById("ClassName");
		if(obj)ClassName=obj.value;
		var encmeth="";
		var obj=document.getElementById("SelectUPLSPropertyBroker");
		if(obj)encmeth=obj.value;
		if (encmeth!=""){
			var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","UPLSClassPropertyList",ClassName);
		}
	}	
}	
function UPLSClassListChange()
{
	var obj=document.getElementById("ClassName");
	if(obj)obj.value="";
	var obj=document.getElementById("ClassPropertyList");
	if(obj)
	{
		ClearAllList(obj);
		var ClassName="";
		var obj=document.getElementById("UPLSClassList");
		if((obj)&&(obj.selectedIndex!=-1))ClassName=obj.options[obj.selectedIndex].value;
		var encmeth="";
		var obj=document.getElementById("SelectPropertyBroker");
		if(obj)encmeth=obj.value;
		if (encmeth!=""){
			var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","ClassPropertyList",ClassName);
		}
	}
	var obj=document.getElementById("UPLSClassPropertyList");
	if(obj)
	{
		ClearAllList(obj);
		var ClassName="";
		var obj=document.getElementById("UPLSClassList");
		if((obj)&&(obj.selectedIndex!=-1))ClassName=obj.options[obj.selectedIndex].value;
		var encmeth="";
		var obj=document.getElementById("SelectUPLSPropertyBroker");
		if(obj)encmeth=obj.value;
		if (encmeth!=""){
			var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","UPLSClassPropertyList",ClassName);
		}
	}
}
function ClearAllList(obj) {
	for (var i=obj.options.length-1; i>=0; i--) obj.options[i] = null;
}
function UPLSClassPropertyListClick()
{ 
  listObj = document.getElementById('UPLSClassPropertyList');
  if(listObj.selectedIndex==-1)
  {
 	return;
  }
  var selValue = listObj.options[listObj.selectedIndex].value;
  var Description=tkMakeServerCall("web.DHCBL.Patient.DHCPatientUpdateLog","GetUPLSPropertyDescription",selValue)
  var obj = document.getElementById('PropertyDescription');
  if(obj) obj.value=Description;
  CreatUPLSClassListLink();
  
}
function AddClick() {	
  var ClassName="";
  var obj=document.getElementById("ClassName");
  if(obj)ClassName=obj.value;
  if (ClassName=="")
  {
  	var obj=document.getElementById("UPLSClassList");
  	if((obj)&&(obj.selectedIndex!=-1))ClassName=obj.options[obj.selectedIndex].value;
  }
  if (ClassName=="") return;
  listObj = document.getElementById('ClassPropertyList');
  if(listObj.selectedIndex==-1)
  {
 	alert("请选择左侧属性列表");
 	return;
  }
  var ClassPropertyValue = listObj.options[listObj.selectedIndex].value;
  if (ClassPropertyValue=="") return;
  var ret=tkMakeServerCall("web.DHCBL.Patient.DHCPatientUpdateLog","AddUPLSProperty",ClassName,ClassPropertyValue)
  if (ret>0)
  {
  	   listObj = document.getElementById('UPLSClassPropertyList');
  	   if(listObj)listObj.options[listObj.length] = new Option(ClassPropertyValue,ret);
  	   alert("添加成功");
  }
}
function UpClick() {	
	
  listObj = document.getElementById('UPLSClassPropertyList');
  if(listObj.selectedIndex==-1)
  {
 	return;
  }
  if(listObj.selectedIndex==0)
  {
 	return;
  }
  var selIndex = listObj.selectedIndex;
  var selValue = listObj.options[selIndex].value;
  var selText = listObj.options[selIndex].text;
  var DownselValue = listObj.options[selIndex - 1].value;
  listObj.options[selIndex].value = listObj.options[selIndex - 1].value;
  listObj.options[selIndex].text = listObj.options[selIndex - 1].text;
  listObj.options[selIndex - 1].value = selValue;
  listObj.options[selIndex - 1].text = selText;
  listObj.selectedIndex = selIndex - 1;
  var ret=tkMakeServerCall("web.DHCBL.Patient.DHCPatientUpdateLog","ChangeUPLSClassPropertyIndex",selValue,DownselValue)
}
function DownClick() {	
  listObj = document.getElementById('UPLSClassPropertyList');
  if(listObj.selectedIndex==-1)
  {
 	return;
  }
  if(listObj.selectedIndex == listObj.options.length - 1)
  {
 	return;
  }
  var selIndex = listObj.selectedIndex;
  var selValue = listObj.options[selIndex].value;
  var selText = listObj.options[selIndex].text;
  var UpselValue = listObj.options[selIndex + 1].value;
  listObj.options[selIndex].value = listObj.options[selIndex + 1].value;
  listObj.options[selIndex].text = listObj.options[selIndex + 1].text;
  listObj.options[selIndex + 1].value = selValue;
  listObj.options[selIndex + 1].text = selText;
  listObj.selectedIndex = selIndex + 1;
  var ret=tkMakeServerCall("web.DHCBL.Patient.DHCPatientUpdateLog","ChangeUPLSClassPropertyIndex",selValue,UpselValue)
}
function DeleteClick() {	
  listObj = document.getElementById('UPLSClassPropertyList');
  if(listObj.selectedIndex==-1)
  {
 	alert("请选择右侧属性列表");
 	return;
  }
  var selValue = listObj.options[listObj.selectedIndex].value;
  var ret = window.confirm('确认要删除吗');
  if (ret == true)
  {
 	 var ret=tkMakeServerCall("web.DHCBL.Patient.DHCPatientUpdateLog","DeleteUPLSProperty",selValue)
  	 if (ret==0)
  	 {
  	   listObj.remove(listObj.selectedIndex);
  	 }
  }
}
function UpdateDescriptionClick() {	
 listObj = document.getElementById('UPLSClassPropertyList');
  if(listObj.selectedIndex==-1)
  {
 	alert("请选择右侧属性列表");
 	return;
  }
  var selValue = listObj.options[listObj.selectedIndex].value;
  var Description="";
  var obj = document.getElementById('PropertyDescription');
  if(obj) Description=obj.value;
  var ret=tkMakeServerCall("web.DHCBL.Patient.DHCPatientUpdateLog","UpdateUPLSPropertyDescription",selValue,Description)
  if (ret==0)
  {
  	   alert("更新成功");
  }
}
///---------------类属性列表的索引的描述
function CreatUPLSClassListLink() {	
  var Obj = document.getElementById('UPLSClassListLink');
  if (Obj){
	  Obj.length=0
	  var listObj = document.getElementById('UPLSClassPropertyList');
	  if(listObj.selectedIndex==-1)
	  {
	 	return;
	  }
	  var selValue = listObj.options[listObj.selectedIndex].value;
	  var SubClassUserName=tkMakeServerCall("web.DHCBL.Patient.DHCPatientUpdateLog","PropertyLinkClassName",selValue)
	  if (SubClassUserName!=""){
		  	var encmeth="";
			var obj=document.getElementById("SelectPropertyBroker");
			if(obj)encmeth=obj.value;
			if (encmeth!=""){
				var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","UPLSClassListLink",SubClassUserName);
			} 
			var PropertyLink=tkMakeServerCall("web.DHCBL.Patient.DHCPatientUpdateLog","GetPropertyLink",selValue)
			if (PropertyLink!=""){
				var Obj = document.getElementById('UPLSClassListLink');
				var ObjLength=Obj.length;
				for (var J=0;J<ObjLength;J++)
				{
				 	 var selValue = Obj.options[J].value;
					 if (PropertyLink==selValue){
						 Obj.options[J].selected=true
						 }
	 				 
				
				}
			}
	 }
  }

}
function PropertyLinkSave()
{
	var SavePropertyLink=""
	var listObj = document.getElementById('UPLSClassPropertyList');
	if (listObj){
		var selValue = listObj.options[listObj.selectedIndex].value;
		if (selValue!=""){
				var Obj = document.getElementById('UPLSClassListLink');
				if (Obj){
					SavePropertyLink=Obj.value;
					if (SavePropertyLink=="")
					{	alert("请选择有效的指针索引描述项")
					}
					else
					{
						var PropertyLink=tkMakeServerCall("web.DHCBL.Patient.DHCPatientUpdateLog","SavePropertyLink",selValue,SavePropertyLink)
						alert("OK")
					}
				}
			
			}
		
	}
	
	
	
}

