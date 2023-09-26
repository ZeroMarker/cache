//DHCANCOPCountTypeDetail.JS
function BodyLoadHandler()
{
    
	var TypeId=document.getElementById("TypeId").value;
	var GetTypeSel=document.getElementById("GetTypeSel").value;
	if (TypeId!="")
	{
		var ret=cspRunServerMethod(GetTypeSel,TypeId);
		var selobj=document.getElementById("Item");
		addlistoption(selobj,ret,"^");		
	}
	var obj=document.getElementById('moveout');
	if (obj) obj.onclick =moveout_Click;
	var obj=document.getElementById('movein');
	if (obj) obj.onclick =movein_Click;
    var obj=document.getElementById('SaveSet');
	if (obj) obj.onclick =Save_Click;
	var obj=document.getElementById('Up');
	if (obj) obj.onclick =UpClickHandler;
	var obj=document.getElementById('Down');
	if (obj) obj.onclick =DownClickHandler;


}
function addlistoption(selobj,resStr,del)
{
    var resList=new Array();
    var tmpList=new Array();
    selobj.options.length=0;
    resList=resStr.split(del);
    for (i=0;i<resList.length;i++)
    {
	    tmpList=resList[i].split("|")
	    selobj.add(new Option(tmpList[1],tmpList[0]));
	}
}
function moveout_Click()
{
  var surlist=document.getElementById("Item");
  var dlist=document.getElementById("ItemAll");
  moveout(surlist,dlist);
}
function movein_Click()
{
  var surlist=document.getElementById("ItemAll");
  var dlist=document.getElementById("Item");
  movein(surlist,dlist);	
}
function Save_Click(dlist)
{
  var selrow=parent.frames[0].document.getElementById("selrow").value;
  if (selrow=="")
  {
	  alert(t['alert:selrow']);//please select one line of search type first
	  return false;
  }
  var seltyp;
  var dlist=document.getElementById("Item");
  var tmpStr=selitem(dlist);
  var SaveTypeSel=document.getElementById("SaveTypeSel").value;
  var TypeId=parent.frames[0].document.getElementById("TypeIdz"+selrow).innerText;
  var resStr=cspRunServerMethod(SaveTypeSel,TypeId,tmpStr);  
  alert(resStr);
  var lnk1= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANCOPCountTypeDefault&TypeId="+TypeId;
  parent.frames[2].location.href=lnk1;
  return;
}
function DHCWeb_GetRowIdx(wobj)
{
	try{
		var eSrc=wobj.event.srcElement;
		//alert(wobj.name);
		if (eSrc.tagName=="IMG") eSrc=wobj.event.srcElement.parentElement;
		var rowObj=getRow(eSrc);
		var selectrow=rowObj.rowIndex;
		return 	selectrow
	}catch (e)
	{
		alert(e.toString());
		return -1;
	}
}
document.body.onload = BodyLoadHandler;
function movein(surlist,dlist)
{
    if (surlist.selectedIndex==-1){
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
	        //surlist.options[i]=null;
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
function moveout(surlist,dlist)
{
    if (surlist.selectedIndex==-1){
	   return;
	   }
	var i;
	var objSelected ;// new Option(surlist[nIndex].text, surlist[nIndex].value);
	for (i=0;i<surlist.options.length;i++)
	{
		if (surlist.options[i].selected)
		{
	        surlist.options[i]=null;
	        i=i-1;
       	}
	}
	return;
}
function selitem(selbox)
{
      var tmpList=new Array();
        for ( var i=0;i<selbox.options.length;i++)
		{   
			tmpList[tmpList.length]=selbox.options[i].value;
		}
		if (tmpList[0]=="") tmpList=tmpList.slice(1);
		var Str=tmpList.join("^");
  return Str
}
function Swap(a,b) {
	//Swap position and style of two options
	//We used to just remove then add - but this didn't work in NS6
	var lstItems=document.getElementById("Item");
	var opta=lstItems[a];
	var optb=lstItems[b];
	lstItems[a]= new Option(optb.text,optb.value);
	lstItems[a].style.color=optb.style.color;
	lstItems[a].style.backgroundColor=optb.style.backgroundColor;
	lstItems[b]= new Option(opta.text,opta.value);
	lstItems[b].style.color=opta.style.color;
	lstItems[b].style.backgroundColor=opta.style.backgroundColor;
	lstItems.selectedIndex=b;
}
function UpClickHandler() {
	var lstItems=document.getElementById("Item");
	var i=lstItems.selectedIndex;
	var len=lstItems.length;

	if ((len>1)&&(i>0)) {
		Swap(i,i-1)
	}
	return false;
}
function DownClickHandler() {
	var lstItems=document.getElementById("Item");
	var i=lstItems.selectedIndex;
	var len=lstItems.length;
	if ((len>1)&&(i<(len-1))) {
		Swap(i,i+1)
	 }
	return false;
}
