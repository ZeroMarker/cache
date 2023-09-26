defaultobj=""
function BodyLoadHandler()
{   

	var obj=document.getElementById('addRecLoc');
	if (obj) obj.onclick =addRecLoc_Click;
	var obj=document.getElementById('delRecLoc');
	if (obj) obj.onclick =delRecLoc_Click;
	var obj=document.getElementById('addPatLoc');
	if (obj) obj.onclick =addPatLoc_Click;
	var obj=document.getElementById('delPatLoc');
	if (obj) obj.onclick =delPatLoc_Click;
	var obj=document.getElementById('addOrdCatSub');
    if (obj) obj.onclick =addcat_Click;
    var delcat=document.getElementById('delOrdCatSub');
    if (delcat) delcat.onclick =delcat_Click;
    var obj=document.getElementById('OrdCat');
    if (obj) obj.ondblclick =OrdCat_Click;
    
    var SelHos=DHCC_GetElementData('Hospital');
    if (document.getElementById('Hospital')){
        var SelHosStr=DHCC_GetElementData('GetHosStr');
        combo_SelHos=dhtmlXComboFromStr("Hospital",SelHosStr);
        combo_SelHos.enableFilteringMode(true);
        combo_SelHos.selectHandle=combo_SelHosKeydownhandler;
        combo_SelHos.setComboText(SelHos);           
	}
	
	var SelPrio=DHCC_GetElementData('Priority');
	if (document.getElementById('Priority')){
        var SelPrioStr=DHCC_GetElementData('GetPriorityStr');
	    combo_SelPrio=dhtmlXComboFromStr("Priority",SelPrioStr);
        combo_SelPrio.enableFilteringMode(true);
        combo_SelPrio.selectHandle=combo_SelPrioKeydownhandler;
        combo_SelPrio.setComboText(SelPrio);           
	}
	

    var SelInstruc=DHCC_GetElementData('Instruc');
	if (document.getElementById('Instruc')){
        var SelInstrucStr=DHCC_GetElementData('GetInstrucStr');
	    combo_SelInstruc=dhtmlXComboFromStr("Instruc",SelInstrucStr);
        combo_SelInstruc.enableFilteringMode(true);
        combo_SelInstruc.selectHandle=combo_SelInstrucKeydownhandler;
        combo_SelInstruc.setComboText(SelInstruc);       
	}
	
	var SelRecLoc=DHCC_GetElementData('RecLoc');
	if (document.getElementById('RecLoc')){
        var SelRecLocStr2=DHCC_GetElementData('GetRecLocStr2');
	    combo_SelRecLocStr2=dhtmlXComboFromStr("RecLoc",SelRecLocStr2);
        combo_SelRecLocStr2.enableFilteringMode(true);
        combo_SelRecLocStr2.selectHandle=combo_SelRecLocStr2Keydownhandler;
        //alert(SelRecLocStr2)
        //combo_SelRecLocStr2.setComboText(SelRecLocStr2);
        //alert(document.getElementById('RecLoc').value)
	}
    
    
    var obj=document.getElementById('DepGroup');
    if (obj) obj.ondblclick =DepGroup_Click;
	
	defaultobj=document.getElementById('Default')
	if (defaultobj) defaultobj.onclick=default_Click


	var obj=document.getElementById('Creat')
	if (obj) obj.onclick=Creat_Click
	default_Click()
	
  
}

function OrdCat_Click()
{
	var OrdCat=document.getElementById('OrdCat');
	var OrdCatSub=document.getElementById('OrdCatSub');
	var GetItemCat=document.getElementById('GetArcItemCat').value;
    if (OrdCat.selectedIndex==-1){
	   return;
	   }
	var index=OrdCat.selectedIndex;
	var Str=cspRunServerMethod(GetItemCat,OrdCat.options[index].value);
	if (Str!="")
	{
		additem(Str,OrdCatSub);
	}
}

function combo_SelHosKeydownhandler(e){

	var SelHosId=combo_SelHos.getActualValue();
    DHCC_SetElementData('HosId',SelHosId);	 
}

function combo_SelPrioKeydownhandler(e){

	var SelPrioId=combo_SelPrio.getActualValue();
    DHCC_SetElementData('PriorityID',SelPrioId);	 
}


function combo_SelInstrucKeydownhandler(e){

	var SelInstrucId=combo_SelInstruc.getActualValue();
    DHCC_SetElementData('InstrucId',SelInstrucId); 
}


function combo_SelRecLocStr2Keydownhandler(e){

	var SelRecLocId=combo_SelRecLocStr2.getActualValue();
	
    DHCC_SetElementData('RecLocId',SelRecLocId);
}


function DepGroup_Click()
{
	ClearLoc()
	var DepGroup=document.getElementById('DepGroup');
	var Dep=document.getElementById('CTLOC');
	var GetDep=document.getElementById('GetDepFuntion').value;
    if (DepGroup.selectedIndex==-1){
	   return;
	   }
	var HosIdobj=document.getElementById("HosId");
	if (HosIdobj) {var HosId=HosIdobj.value}
	var index=DepGroup.selectedIndex;
	var Str=cspRunServerMethod(GetDep,HosId,DepGroup.options[index].value);
	if (Str!="")
	{
		additem(Str,Dep);
	}

}

function ClearLoc(){
	var CTLOCList=document.getElementById('CTLOC');
	moveout2(CTLOCList,"");
	}
var selitem=function(selbox)
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
function Creat_Click()
{
	var InstrucId,SelCatSubStr,PatLocStr,RecLocId,Defflag,PriorityID,stTime,endTime,HosId;
	var InstrucIdobj=document.getElementById('InstrucId')
    if (InstrucIdobj) {var InstrucId=InstrucIdobj.value}
	var PriorityIDobj=document.getElementById('PriorityID')
    if (PriorityIDobj) {var PriorityID=PriorityIDobj.value}
    var PatLocobj=document.getElementById("PatLoc");
  	if (PatLocobj) {var PatLocId=PatLocobj.value}
  	var RecLocobj=document.getElementById("RecLocId");
  	if (RecLocobj) {var RecLocId=RecLocobj.value}
  	var SelCatSub=document.getElementById("SelCatSub")
  	var defaultobj=document.getElementById('Default')
  	if (defaultobj) {var Defflag=defaultobj.value}
  	var stDateobj=document.getElementById('stDate')
  	if (stDateobj) {var stDate=stDateobj.value}
    var endDateobj=document.getElementById('endDate')
   	if (endDateobj) {var endDate=endDateobj.value}
    var stTimeobj=document.getElementById('stTime')
    if (stTimeobj) {var stTime=stTimeobj.value}
    var endTimeobj=document.getElementById('endTime')
    if (endTimeobj) {var endTime=endTimeobj.value}
    var  PatLocStr=selitem(PatLocobj);
    var  SelCatSubStr=selitem(SelCatSub);
  	var HosIdobj=document.getElementById('HosId')
    if (HosIdobj) {var HosId=HosIdobj.value}
  	
   	var SaveSetFun=document.getElementById('SaveInsData').value;  	
   	//alert(InstrucId+"@"+SelCatSubStr+"@"+PatLocStr+"@"+RecLocId+"@"+Defflag+"@"+PriorityID+"@"+stTime+"@"+endTime)
  	var retStr=cspRunServerMethod(SaveSetFun,InstrucId,SelCatSubStr,PatLocStr,RecLocId,Defflag,PriorityID,stTime,endTime,HosId)
	//alert("retStr:"+retStr)
  	var str=retStr.split("^")
  	if (str[0]=="0") {
	  
	  	var job=str[1]
	  	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCInstrRecLocInsert&Job='+job
         window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=4000,height=2000,left=0,top=0')
	  	}
	else {
		alert("生成数据失败:"+str[1]);
		
		}
  	
  	return;

}

function addcat_Click()

{  
	var surlist=document.getElementById("OrdCatSub");
	var dlist=document.getElementById("SelCatSub");
	movein(surlist,dlist);
}

function delcat_Click()

{ 
	var dlist=document.getElementById("OrdCatSub");
	var surlist=document.getElementById("SelCatSub");
	moveout1(surlist,dlist);
}

function additem(Str,dlist)

{
    var StrArr=Str.split("^");
	var i;
	dlist.options.length=0;
	for (i=0;i<StrArr.length;i++)
	{
		var item=StrArr[i].split("!");
		if (item[0]!="") {
		  var objSelected = new Option(item[1], item[0]);
	      dlist.options[dlist.options.length]=objSelected;
		}
	}
}

function addPatLoc_Click()
{  //添加临时医嘱包括的优先级
	var surlist=document.getElementById("CTLOC");
	var dlist=document.getElementById("PatLoc");
	movein(surlist,dlist);
	
}
function delPatLoc_Click()
{
	var dlist=document.getElementById("CTLOC");
	var surlist=document.getElementById("PatLoc");
	moveout1(surlist,dlist);
	
}
function ifselected(val,list)
{
	for (var i=0;i<list.options.length;i++){
		if (list.options[i].value==val)
		{
			list.options[i].selected=true;
		}
		alert(i);
	  
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

		  if ((ifexist(surlist[i].value,dlist)==false)&&(surlist[i].text!=""))
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
		// alert(val+"#"+list.options[i].value)
		if (list.options[i].value==val)
		{
			//alert(list.options[i].text+" 已存在"+val)
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
function moveout2(surlist,dlist)
{
	for (i=0;i<surlist.options.length;i++)
	{
	        surlist.options[i]=null;
	        i=i-1;
	}
	return;
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

function default_Click()
{
   if (defaultobj.checked==true) 
   { defaultobj.value="Y"
   }
   else
   {defaultobj.value=""}
}
	
document.body.onload = BodyLoadHandler;