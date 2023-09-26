function BodyLoadHandler()
{
    

	var obj=document.getElementById('addoploc');
	if (obj) obj.onclick =addoploc_Click;
	var obj=document.getElementById('deloploc');
	if (obj) obj.onclick =deloploc_Click;
	var obj=document.getElementById('addanloc');
	if (obj) obj.onclick =addanloc_Click;
	var obj=document.getElementById('delanloc');
	if (obj) obj.onclick =delanloc_Click;
      obj=document.getElementById('SaveSet');
	if (obj) obj.onclick =Save_Click;

}
function addoploc_Click()
{  //添加长期医嘱包括的优先级
	var surlist=document.getElementById("CTLOC");
	var dlist=document.getElementById("OpLoc");
	movein(surlist,dlist);
	
}
function deloploc_Click()
{ 
	var dlist=document.getElementById("CTLOC");
	var surlist=document.getElementById("OpLoc");
	
	moveout1(surlist,dlist);
	
}
function addanloc_Click()
{  //添加临时医嘱包括的优先级
	var surlist=document.getElementById("CTLOC");
	var dlist=document.getElementById("AnLoc");
	movein(surlist,dlist);
	
}
function delanloc_Click()
{
	var dlist=document.getElementById("CTLOC");
	var surlist=document.getElementById("AnLoc");
	moveout1(surlist,dlist);
	
}
function ifselected(val,list)
{
	for (var i=0;i<list.options.length;i++){
		if (list.options[i].value==val)
		{
			list.options[i].selected=true;
		}
		//alert(i);
	  
	}
	return false;
}	
function moveout_Click()
{
  var surlist=document.getElementById("item");
  var dlist=document.getElementById("itemall");
  moveout1(surlist,dlist);
 // savevar(surlist);
}
function movein_Click()
{
  var surlist=document.getElementById("itemall");
  var dlist=document.getElementById("item");
  movein(surlist,dlist);
 // savevar(dlist);
	
}
function Save_Click(dlist)
{
  var  AnLoc=document.getElementById("AnLoc");
  var OpLoc=document.getElementById("OpLoc");
  var SaveAnoP=document.getElementById("SaveAnOpSet").value;
  var  AnStr=selitem(AnLoc);
  var  OpStr=selitem(OpLoc);
  var resStr=cspRunServerMethod(SaveAnoP,AnStr+"!"+OpStr) 
  alert(resStr);
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
	       // surlist.options[i]=null;
	       
	        i=i-1;
		 }
       	}
	}
	return;
	}
//检查目的listitem 是否有该值?
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
	var nIndex=surlist.selectedIndex;
	//alert (surlist.options[nIndex].text);
	var Index =dlist.options.length ;
	if (ifexist(surlist[nIndex].value,dlist)==false)
	{
	var objSelected = new Option(surlist[nIndex].text, surlist[nIndex].value);
	dlist.options[Index]=objSelected;
	}
	surlist.options[nIndex]=null;
	//form1.dismeth.options[2].selected=true;
	return;
	}
function moveout1(surlist,dlist)
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

function selitem(selbox)
{
      var tmpList=new Array();
        for ( var i=0;i<selbox.options.length;i++)
		{   
			//if (selbox.options[i].selected)
			//{   //alert(tmpList.length+" //"+tmpList)
			    tmpList[tmpList.length]=selbox.options[i].value+"|"+selbox.options[i].text
			//}
		}
		if (tmpList[0]=="") tmpList=tmpList.slice(1)
		var Str=tmpList.join("^");
  return Str
}
function Swap(a,b) {
	//Swap position and style of two options
	//We used to just remove then add - but this didn't work in NS6
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
	var i=lstItems.selectedIndex;
	var len=lstItems.length;

	if ((len>1)&&(i>0)) {
		Swap(i,i-1)
	}
 savevar(lstItems);
	return false;
}
function DownClickHandler() {
	var i=lstItems.selectedIndex;
	var len=lstItems.length;
	if ((len>1)&&(i<(len-1))) {
		Swap(i,i+1)
	 }
  savevar(lstItems)
	 return false;
}
document.body.onload = BodyLoadHandler;