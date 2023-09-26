var YDYobj="",DDDobj="",defalutobj=""
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
	
    
    var obj=document.getElementById('DepGroup');
    if (obj) obj.ondblclick =DepGroup_Click;
	
    obj=document.getElementById('SaveSet');
	if (obj) obj.onclick =Save_Click;
	
	
	obj=document.getElementById('Check');
	if (obj) obj.onclick =Check_Click
	
	YDYobj=document.getElementById('YDY')
	if (YDYobj) YDYobj.onclick=YDY_Click
	DDDobj=document.getElementById('DDD')
	if (DDDobj) DDDobj.onclick=DDD_Click
	defalutobj=document.getElementById('Default')
	if (defalutobj) defalutobj.onclick=defalut_Click
    Addobj=document.getElementById('Add')
	if (Addobj) Addobj.onclick=Add_Click

	var obj=document.getElementById('Creat')
	if (obj) obj.onclick=Creat_Click
	YDY_Click()
	DDD_Click()
	defalut_Click()
	
  
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



function Add_Click()
{  
    var hosidobj=document.getElementById('HosId')
    if (hosidobj) {var HosId=hosidobj.value}
    var lnk="dhcordcatrecloc.csp"
    window.open(lnk,"_blank","height=600,width=1000,menubar=no,status=yes,toolbar=no,resizable=yes,left=100,top=100") ;

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

	
///数据检测
function Check_Click()
{
	var PriorityIDobj=document.getElementById('PriorityID')
    if (PriorityIDobj) {var PriorityID=PriorityIDobj.value}
  	var PatLoc=document.getElementById("PatLoc");
  	var RecLoc=document.getElementById("RecLoc");
  	var SelCatSub=document.getElementById("SelCatSub")
  	var YDYflag=YDYobj.value
  	var DDDflag=DDDobj.value
  	var Defflag=defalutobj.value
  	var stDateobj=document.getElementById('stDate')
    if (stDateobj) {var stDate=stDateobj.value}
   	var endDateobj=document.getElementById('endDate')
    if (endDateobj) {var endDate=endDateobj.value}
    var stTimeobj=document.getElementById('stTime')
    if (stTimeobj) {var stTime=stTimeobj.value}
    var endTimeobj=document.getElementById('endTime')
    if (endTimeobj) {var endTime=endTimeobj.value}  	
  	var SaveSetFun=document.getElementById("CheckRecLocFuntion").value;
  	var  PatLocStr=selitem(PatLoc);
  	var  RecLocStr=selitem(RecLoc);
  	var  SelCatSubStr=selitem(SelCatSub);
  	if ((YDYflag!=1)&&(DDDflag!=1))  {
	  	alert("请选择其中一种规则!")
	  	return;
	  	}
	  	//alert(RecStr)                    SelCatSubStr, PatLocStr, RecLocStr, YDYflag, DDDflag, Defflag, PriorityID, stDate, endDate, stTime, endTime
  	var retStr=cspRunServerMethod(SaveSetFun,SelCatSubStr,PatLocStr,RecLocStr,YDYflag,DDDflag,Defflag,PriorityID,stDate,endDate,stTime,endTime)
  	var str=retStr.split("^")
  	if (str[0]=="0") {
	  	var job=str[1]
         var journal="Journal2"
         var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCOrdCatSubRecLocJournal&Job="+job+"&JouType="+journal
         window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=4000,height=2000,left=0,top=0')
	  	}
	else {
		alert("检测失败!"+str[1]);
	}
  	
  	return;

}





function Creat_Click()
{
	var PriorityIDobj=document.getElementById('PriorityID')
    if (PriorityIDobj) {var PriorityID=PriorityIDobj.value}
  	var PatLoc=document.getElementById("PatLoc");
  	var RecLoc=document.getElementById("RecLoc");
  	var SelCatSub=document.getElementById("SelCatSub")
  	var YDYflag=YDYobj.value
  	var DDDflag=DDDobj.value
  	var Defflag=defalutobj.value
  	var stDateobj=document.getElementById('stDate')
    if (stDateobj) {var stDate=stDateobj.value}
   	var endDateobj=document.getElementById('endDate')
    if (endDateobj) {var endDate=endDateobj.value}
    var stTimeobj=document.getElementById('stTime')
    if (stTimeobj) {var stTime=stTimeobj.value}
    var endTimeobj=document.getElementById('endTime')
    if (endTimeobj) {var endTime=endTimeobj.value}  	
  	var SaveSetFun=document.getElementById("SaveSetFuntion").value;
  	var  PatStr=selitem(PatLoc);
  	var  RecStr=selitem(RecLoc);
  	var  SelCatSubStr=selitem(SelCatSub);
  	if ((YDYflag!=1)&&(DDDflag!=1))  {
	  	alert("请选择其中一种规则!")
	  	return;
	  	}
  	var retStr=cspRunServerMethod(SaveSetFun,SelCatSubStr,PatStr,RecStr,YDYflag,DDDflag,Defflag,PriorityID,stDate,endDate,stTime,endTime)
  	var str=retStr.split("^") 
  	if (str[0]=="0") {
	  	var job=str[1]
	  	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCOrdCatSubRecLocInsert&Job='+job
         window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=4000,height=2000,left=0,top=0')
	  	}
	else {
		alert(str[1]);
		alert("生成数据失败!");
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


function addRecLoc_Click()
{  
	var surlist=document.getElementById("CTLOC");
	var dlist=document.getElementById("RecLoc");
	movein(surlist,dlist);
	
}
function delRecLoc_Click()
{ 
	var dlist=document.getElementById("CTLOC");
	var surlist=document.getElementById("RecLoc");
	
	moveout1(surlist,dlist);
	
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


function Save_Click(dlist)
{
  var PatLoc=document.getElementById("PatLoc");
  var RecLoc=document.getElementById("RecLoc");
  var SelCatSub=document.getElementById("SelCatSub")
  var SaveSetFun=document.getElementById("SaveSetFuntion").value;
  var  PatStr=selitem(PatLoc);
  var  RecStr=selitem(RecLoc);
  var  SelCatSubStr=selitem(SelCatSub);
  var resStr=cspRunServerMethod(SaveSetFun,SelCatSubStr,PatStr,RecStr) 
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

function YDY_Click()
{
   if (YDYobj.checked==true) 
   {YDYobj.value="1"
   	
   	DDDobj.checked=false
   	DDDobj.value="0"
   }
   else
   {YDYobj.value="0"}
}

function DDD_Click()
{
   if (DDDobj.checked==true) 
   {DDDobj.value="1"
   	
   	YDYobj.checked=false
   	YDYobj.value="0"
   }
   else
   {DDDobj.value="0"}
}

function defalut_Click()
{
   if (defalutobj.checked==true) 
   { defalutobj.value="Y"
   }
   else
   {defalutobj.value=""}
}
	
document.body.onload = BodyLoadHandler;