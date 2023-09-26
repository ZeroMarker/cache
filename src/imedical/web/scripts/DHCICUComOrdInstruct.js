var preRowInd=0;                              
function BodyLoadHandler() 
{	
    var objGetOrdDefault=document.getElementById("GetOrdDefault"); //wll20120906
	var GetOrdDefaultStr=objGetOrdDefault.value.split("@");
	//alert(GetOrdDefaultStr);
	var objdefaultOrd=document.getElementById("defaultOrd");
    if (objdefaultOrd) objdefaultOrd.value=GetOrdDefaultStr[0];
    InitPage();
}
function InitPage()
{

	var obj=document.getElementById("BSave");
	if (obj) obj.onclick =Save;
    var obj=document.getElementById("BDelete");
	if (obj) obj.onclick =Delete;
	var obj=document.getElementById("DelOrdInstruc");
	if (obj) obj.onclick =Del_Click;
	var obj=document.getElementById("AddOrdInstruc");
	if (obj) obj.onclick =Add_Click;
	var obj=document.getElementById("BSaveDefault");
	if (obj) obj.onclick =SaveDefault;
	
}

function Save()
{
	//alert("a");
	var dphcinRowid="";
	var GetSave=document.getElementById("GetSave").value;
	//alert(GetSave);
    var obj=document.getElementById("dancoRowid");
	if (obj) var dancoRowid=obj.value;
	//alert(dancoRowid);
	var obj=document.getElementById("dphcinRowid");
	var typeobj=document.getElementById("dphcin");
	var dphcinRowid=selitem(typeobj,"^");
	if (obj) obj.value=dphcinRowid;
	//alert(dphcinRowid);
	
	var obj=document.getElementById("GetSave");
	var encmeth=obj.value;
	//alert(encmeth);
	var result=cspRunServerMethod(encmeth,dancoRowid,dphcinRowid);
	if (result==0)
	{
		alert("保存成功!")
		//savedefault(dancoRowid);
		window.location.reload();
	}
	else
	{
		alert(result)
	}
}
function SaveDefault()
{
    //alert("a");
    var obj=document.getElementById("defaultOrdId");
	var defaultOrdId=obj.value;
	//alert(defaultOrdId);
	var obj=document.getElementById("GetSaveDefault");
	var encmeth=obj.value;
	//alert(encmeth);
	var result=cspRunServerMethod(encmeth,defaultOrdId);
	//alert(result);
	if (result==0)
	{
		alert("保存成功!")
		window.location.reload();
	}
	else
	{
		alert(result)
	}
}
function Delete()
{
	var obj=document.getElementById("dancoRowid");
  	if(obj) var dancoRowid=obj.value;

  	var obj=document.getElementById("GetDelete");
	var encmeth=obj.value;
	//alert(encmeth);
	var result=cspRunServerMethod(encmeth,dancoRowid);
    if (result==0)
	{
		alert("删除成功!")
		window.location.reload();
	}
	else
	{
		alert("删除失败!")
	}
	//alert(result);
}

function selitem(selbox,delimStr)
{
      var tmpList=new Array();
        for ( var i=0;i<selbox.options.length;i++)
		{   
			if (selbox.options[i].selected)
			{   //alert(tmpList.length+" //"+tmpList)
			    tmpList[tmpList.length]=selbox.options[i].value
			}
		}
		if (tmpList[0]=="") tmpList=tmpList.slice(1)
		var Str=tmpList.join(delimStr);
  return Str
}

function Del_Click()
{
  var surlist=document.getElementById("unusephcindesc");
  var dlist=document.getElementById("dphcin");
  DelOrdInstrucZ(surlist,dlist);
  savevar(surlist);
}
function Add_Click()
{
  var surlist=document.getElementById("dphcin");
  var dlist=document.getElementById("unusephcindesc");
  AddOrdInstrucZ(surlist,dlist);
  savevar(dlist);
	
}
function DelOrdInstrucZ(surlist,dlist)
{
    if (surlist.selectedIndex==-1)
    {
	   return;
	}
	var i;
	var objSelected ;// new Option(surlist[nIndex].text, surlist[nIndex].value);
	for (i=0;i<surlist.options.length;i++)
	{
		if (surlist.options[i].selected)
		{

		  //if (ifexist(surlist[i].value,dlist)==false)
		  //{
		    
		   // var objSelected = new Option(surlist[i].text, surlist[i].value);
	        //dlist.options[dlist.options.length]=objSelected;
	        surlist.options[i]=null;
	        i=i-1;
		 // }
       	}
	}
	return;
}

function AddOrdInstrucZ(surlist,dlist)
{
    if (surlist.selectedIndex==-1)
    {
	   return;
	}
	var i;
	var objSelected ;// new Option(surlist[nIndex].text, surlist[nIndex].value);
	for (i=0;i<surlist.options.length;i++)
	{
		if (surlist.options[i].selected)
		{
		    if (ifexist(surlist[i].value,dlist)==false)
		    {		    
		    	var objSelected = new Option(surlist[i].text, surlist[i].value);
	        	
	        	dlist.options[dlist.options.length]=objSelected;
	       		// surlist.options[i]=null;
	        	i=i-1;
		 	}
       	}
	}
	return;
}

function ifexist(val,list)
{
	for (var i=0;i<list.options.length;i++){
		if (list.options[i].value==val)
		{
			return true;
		}
		//alert(i);
	  
	}
	return false;
}

function savevar(dlist)
{
	var tmpList="";
	if (dlist){
        for ( var i=0;i<dlist.options.length;i++)
		{   
			if (tmpList=="") tmpList=dlist.options[i].value;
			else  tmpList=tmpList+"^"+dlist.options[i].value;

		}
	}
  	var SaveUnusePhcin=document.getElementById("SaveUnusePhcin");
  	if (SaveUnusePhcin) {
		var ret=cspRunServerMethod(SaveUnusePhcin.value,tmpList);
  		if (ret==0){
	   		//alert(t["alert:success"]);
	    	self.location.reload();
  		}
  		else {
			alert(ret)
  		}
  	}
}
function SelectRowHandler()
{

	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById("tDHCICUComOrdInstruct");
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById("dancoRowid");
	var obj1=document.getElementById("dancoDesc");
	var obj2=document.getElementById("dphcinRowid");
	var obj3=document.getElementById("dphcin");
	//SelectedSet(obj3,RetStr[8],"^");
	
	var SelRowObj=document.getElementById("tANCORowIdz"+selectrow);
	var SelRowObj1=document.getElementById("tANCODescz"+selectrow);
	var SelRowObj2=document.getElementById("tPHCINRowIdz"+selectrow);
	var SelRowObj3=document.getElementById("tPHCINDescz"+selectrow);

	if (preRowInd==selectrow)
	{
	   window.location.href= "websys.default.csp?WEBSYS.TCOMPONENT=DHCICUComOrdInstruct";
	   /*obj.value="";
	   obj1.value="";
	   obj2.value="";
	   obj3.value="";
	   obj4.value="";
	   obj5.value="";
	   obj6.value="";*/
   	   preRowInd=0;
    }
   else
   {
	   if (obj)  obj.value=SelRowObj.innerText;
	   //alert(obj.value);
	   if (obj1) obj1.value=SelRowObj1.innerText;
	   //alert(obj1.value);
	   if (obj2) obj2.value=SelRowObj2.innerText;
	   //alert(obj2.value);
	   //obj3.value=SelRowObj3.innerText;
	   SelectedSet(obj3,obj2.value,"^");
	   //alert(obj3.value);
	   preRowInd=selectrow;
   }
	return;
}

function SelectedSet(selObj,indStr,delim) 
{//查询条件设置
	var tmpList=new Array();
	for(i=0;i<selObj.options.length;i++)
	{
		selObj.options[i].selected=false;
	}
	tmpList=indStr.split(delim)
	for(j=0;j<tmpList.length;j++)
	{
		for(i=0;i<selObj.options.length;i++)
		{
			if (selObj.options[i].value==tmpList[j])
		    {
			    selObj.options[i].selected=true;break
		    }
		}
	}
}

function GetDrugOrdItem(str)
{
	var strValue=str.split("^");
	var obj=document.getElementById("dancoRowid");
	if (obj) obj.value=strValue[1];
	var obj=document.getElementById("dancoDesc");
	if (obj) obj.value=strValue[0];
}

function GetOrdDefault(str)
{
	var strValue=str.split("^");
	var obj=document.getElementById("defaultOrdId");
	if (obj) obj.value=strValue[1];
	var obj=document.getElementById("defaultOrd");
	if (obj) obj.value=strValue[0];
}


document.body.onload = BodyLoadHandler;
