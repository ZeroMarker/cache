
var SelectedRow = 0;
var mCatSubId="",mPatLocId="",mRecLocId="",mSelRowid="",SelPatLocId="",SelRecLocId="",SelDafault="",SelTPriorityId=""
var CatSubId,PatLocId,RecLocId,Default,PriorityID,stDate,stTime,endDate,endTime;
function BodyLoadHandler()
{
	   var obj=document.getElementById('Add')
	   if (obj) {obj.onclick=Add_Click}
	   var obj=document.getElementById('Update')
	   if (obj) {obj.onclick=Update_Click}
	   var obj=document.getElementById('Delete')
	   if (obj) {obj.onclick=Delete_Click}
	   
	   var obj=document.getElementById('SelDel')
	   if (obj) {obj.onclick=SelDel_Click}
	   var obj=document.getElementById('AllSelect')
	   if (obj) {obj.onclick=AllSelect_Click}
	   var obj=document.getElementById('Find')
	   if (obj) {obj.onclick=Find_click}	
	   
	   var PatLoc=DHCC_GetElementData('PatLoc');
       if (document.getElementById('PatLoc')){
            var DepStr=DHCC_GetElementData('GetPatLocStr');
			combo_PatLoc=dhtmlXComboFromStr("PatLoc",DepStr);
            combo_PatLoc.enableFilteringMode(true);
            combo_PatLoc.selectHandle=combo_PatLocKeydownhandler;
            combo_PatLoc.setComboText(PatLoc);
		}
		
	   var RecLoc=DHCC_GetElementData('RecLoc');
       if (document.getElementById('RecLoc')){
            var DepStr1=DHCC_GetElementData('GetRecLocStr');
			combo_RecLoc=dhtmlXComboFromStr("RecLoc",DepStr1);
            combo_RecLoc.enableFilteringMode(true);
            combo_RecLoc.selectHandle=combo_RecLocKeydownhandler;
            combo_RecLoc.setComboText(RecLoc);

		}
	
		var SelPrio=DHCC_GetElementData('Priority');
		if (document.getElementById('Priority')){
	        var SelPrioStr=DHCC_GetElementData('GetPriorityStr');
		    combo_SelPrio=dhtmlXComboFromStr("Priority",SelPrioStr);
	        combo_SelPrio.enableFilteringMode(true);
	        combo_SelPrio.selectHandle=combo_SelPrioKeydownhandler;
	        combo_SelPrio.setComboText(SelPrio);           
		}
	  var obj=document.getElementById('default')
	  if (obj) obj.onclick=default_Click
	  default_Click()

	
}

function Find_click()
{   
	var PatLocId="",PatLocId="",OrdPriority="";
    var HosIdobj=document.getElementById('HosId');
	if (HosIdobj) {var HosId=HosIdobj.value}
	var CatSubIdobj=document.getElementById('CatSubId');
	if (CatSubIdobj) {var CatSubId=CatSubIdobj.value}
	var PatLocIdobj=document.getElementById('PatLocId');
	if (PatLocIdobj) {var PatLocId=PatLocIdobj.value}
	var RecLocIdobj=document.getElementById('RecLocId');
	if (RecLocIdobj) {var RecLocId=RecLocIdobj.value}
    var defaultobj=document.getElementById('default');
	if (defaultobj.checked==true) {var Default="Y"}
	if (defaultobj.checked==false) {var Default=""}
	var OrdPriorityIdobj=document.getElementById('PriorityID');
	if (OrdPriorityIdobj) {var OrdPriority=OrdPriorityIdobj.value}
    
	
    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOrdCatSubRecLocAdd&CatSubId="+CatSubId+"&PatLocId="+PatLocId+"&RecLocId="+RecLocId+"&HosId="+HosId+"&Default="+Default+"&OrdPriority="+OrdPriority
	parent.frames['DHCOrdCatSubRecLocAdd'].document.location.href=lnk;
	
	
	
	}



function Add_Click()
{
	var obj=document.getElementById('CatSubId');
	if (obj) {var CatSubId=obj.value}
	var obj=document.getElementById('PatLocId');
	if (obj) {var PatLocId=obj.value}
    var obj=document.getElementById('RecLocId');
	if (obj) {var RecLocId=obj.value}
	var obj=document.getElementById('PriorityID');
	if (obj) {var PriorityID=obj.value}
    var obj=document.getElementById('default')
    if (obj) {var Default=obj.value}
    var obj=document.getElementById('stDate');
	if (obj) {var stDate=obj.value}	
	var obj=document.getElementById('endDate');
	if (obj) {var endDate=obj.value}
	var obj=document.getElementById('stTime');
	if (obj) {var stTime=obj.value}
	var obj=document.getElementById('endTime');
	if (obj) {var endTime=obj.value}
    
	var MedthodAdd=document.getElementById('MedthodAdd').value;
    if (MedthodAdd) {
	    if (cspRunServerMethod(MedthodAdd,'SetPid','',CatSubId,PatLocId,RecLocId,Default,PriorityID,stDate,stTime,endDate,endTime)=='0') {
		    Find_click()
		    }
	    //alert(ret)
	   }
}

function Update_Click()
{
	var obj=document.getElementById('CatSubId');
	if (obj) {var CatSubId=obj.value}
	var obj=document.getElementById('PatLocId');
	if (obj) {var PatLocId=obj.value}
    var obj=document.getElementById('RecLocId');
	if (obj) {var RecLocId=obj.value}
	var PatLocobj=document.getElementById('PatLoc');
	if (PatLocobj) {
		if (PatLocobj.value=="") {PatLocId=""}
		}
    var RecLocobj=document.getElementById('RecLoc');
	if (RecLocobj) {
		if (RecLocobj.value=="") {RecLocId=""}
		}
	var obj=document.getElementById('PriorityID');
	if (obj) {
		var PriorityID=obj.value
		}
		
	var obj=document.getElementById('stDate');
	if (obj) {
		var stDate=obj.value
		}	
	var obj=document.getElementById('endDate');
	if (obj) {
		var endDate=obj.value
		}
	var obj=document.getElementById('stTime');
	if (obj) {
		var stTime=obj.value
		}
	var obj=document.getElementById('endTime');
	if (obj) {
		var endTime=obj.value
		}
		
    var obj=document.getElementById('default')
    if (obj) {var Default=obj.value}
    //alert(PatLocId+"@"+RecLocId)
    if (mSelRowid=="") {
	    alert("请选择一行记录!")
	    return ;
	    }
	var MedthodUpdate=document.getElementById('MedthodUpdate').value;
    if (MedthodUpdate) {
	    if (cspRunServerMethod(MedthodUpdate,'SetPid','',mSelRowid,CatSubId,PatLocId,RecLocId,Default,PriorityID,stDate,stTime,endDate,endTime)=='0') {}
	   }
}

function combo_PatLocKeydownhandler(e){

	var PatLocId=combo_PatLoc.getActualValue();

	//mPatLocId=PatLocId

	//var DepRowId=DHCC_GetComboValue(combo_ERepLoc);

	 DHCC_SetElementData('PatLocId',PatLocId);
	//alert(document.getElementById('PatLocId').value)
	 
}

function combo_RecLocKeydownhandler(e){

	var RecLocId=combo_RecLoc.getActualValue();

	//mRecLocId=RecLocId

	//var DepRowId=DHCC_GetComboValue(combo_ERepLoc);

	 DHCC_SetElementData('RecLocId',RecLocId);
	//alert(document.getElementById('RecLocId').value)
	 
}


function combo_SelPrioKeydownhandler(e){

	var SelPrioId=combo_SelPrio.getActualValue();
    DHCC_SetElementData('PriorityID',SelPrioId);	 
}


function SelectRowHandler()	{

	var eSrc=window.event.srcElement;

	 objtbl=document.getElementById('tDHCOrdCatSubRecLocAdd');

	var rows=objtbl.rows.length;

	var lastrowindex=rows - 1;

	var rowObj=getRow(eSrc);

	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	var TRowidobj=document.getElementById('TRowidz'+selectrow);
	if (TRowidobj) {mSelRowid=TRowidobj.value}
	var TPatLocIdobj=document.getElementById('TPatLocIdz'+selectrow)
	if (TPatLocIdobj) {SelPatLocId=TPatLocIdobj.value}
	var TRecLocIdobj=document.getElementById('TRecLocIdz'+selectrow)
	if (TRecLocIdobj) {SelRecLocId=TRecLocIdobj.value}
	var TDefaultobj=document.getElementById('TDefaultz'+selectrow)   //组件里之前拼写错误
	if (TDefaultobj) {SelDafault=TDefaultobj.innerText}
	var TPriorityIdobj=document.getElementById('TPriorityIdz'+selectrow)
	if (TPriorityIdobj) {SelTPriorityId=TPriorityIdobj.value}
	var TPatLocobj=document.getElementById('TPatLocz'+selectrow)
	if (TPatLocobj) {var TPatLoc=TPatLocobj.innerText}
	var TRecLocobj=document.getElementById('TRecLocz'+selectrow)
	if (TRecLocobj) {var TRecLoc=TRecLocobj.innerText}
	var TPriorityobj=document.getElementById('TPriorityz'+selectrow)
	if (TPriorityobj) {var TPriority=TPriorityobj.innerText}
	var TstDateobj=document.getElementById('TstDatez'+selectrow)
	if (TstDateobj) {var TstDate=TstDateobj.innerText}
	var TendDateobj=document.getElementById('TendDatez'+selectrow)
	if (TendDateobj) {var TendDate=TendDateobj.innerText}
	var TstTimeobj=document.getElementById('TstTimez'+selectrow)
	if (TstTimeobj) {var TstTime=TstTimeobj.innerText}
	var TendTimeobj=document.getElementById('TendTimez'+selectrow)
	if (TendTimeobj) {var TendTime=TendTimeobj.innerText}
	
	
	var defaultobj=document.getElementById('default')
	if (defaultobj) {
		if (SelDafault=="Y") {defaultobj.checked=true}
		else {defaultobj.checked=false}
		
    }
	var PatLocojb=document.getElementById('PatLoc');
	if (PatLocojb) {PatLocojb.value=TPatLoc}
	var RecLocojb=document.getElementById('RecLoc');
	if (RecLocojb) {RecLocojb.value=TRecLoc}
	var Priorityojb=document.getElementById('Priority');
	if (Priorityojb) {Priorityojb.value=TPriority}
	
	var stDateojb=document.getElementById('stDate');
	if (stDateojb) {stDateojb.value=TstDate}
	var endDateojb=document.getElementById('endDate');
	if (endDateojb) {endDateojb.value=TendDate}
	
	var stTimeojb=document.getElementById('stTime');
	if (stTimeojb) {stTimeojb.value=TstTime}
	var endTimeojb=document.getElementById('endTime');
	if (endTimeojb) {endTimeojb.value=TendTime}

	DHCC_SetElementData('PatLocId',SelPatLocId)
	DHCC_SetElementData('RecLocId',SelRecLocId)
	DHCC_SetElementData('PriorityID',SelTPriorityId)	
	SelectedRow = selectrow;
}

function default_Click()
{
	
	var obj=document.getElementById('default')
    if (obj.checked==true) 
    { 
    	obj.value="Y"
   	}
	else
	{
		obj.value=""
	}
}

function SetPid(value) 

{ 
     if (value!="01")
    {  
	  if (value=="02") {alert(t['02'])}
	  if (value=="03") {alert(t['03'])}
	  if (value=="04") {alert(t['04'])}
	  if (value=="05") {alert(t['05'])}
	  if (value=="06") {alert(t['06'])}
	   window.location.reload();
	   return;
	  }

	try {		   
	    //alert(t['01']); 
	    window.location.reload(); 
		} catch(e) {}; 
}


function AllSelect_Click()
{
	var checked;
	var obj=document.getElementById("AllSelect")
	if (obj) checked= obj.checked;
	var obj=document.getElementById("t"+"DHCOrdCatSubRecLocAdd")
	var cnt=getRowcount(obj);
  	if (cnt>0)
  	{
	  	for (i=1;i<=cnt;i++)
	  	{
			var obj=document.getElementById("TSelect"+"z"+i);
			obj.checked=checked;
		}
	}
}

function SelDel_Click()
{
	var i=0;
	var rowcnt="",Rowidstr=""
	var objtbl=document.getElementById("t"+"DHCOrdCatSubRecLocAdd");
	if (objtbl)	rowcnt=getRowcount(objtbl)
	if (rowcnt<1){	return; } 
	for(i=1;i<=rowcnt;i++)
	{
		var objCheck=document.getElementById("TSelect"+"z"+i);
		if (objCheck)
		{		 
			if(objCheck.checked==true)
			{ 
				var objname=document.getElementById("TRowid"+"z"+i);
				Rowidstr=Rowidstr+"^"+objname.value

		 	}
		}
				
	}
	if (Rowidstr!="")
	{
	  var MedthodDelete=document.getElementById('MedthodSelDelete').value;
    	  if (MedthodDelete) {
	    	//alert(Rowidstr)
		if(confirm('确实要删除该数据吗?')){
	   		 var ret=cspRunServerMethod(MedthodDelete,Rowidstr)
	    		//alert(ret)
	    		window.location.reload(); 
		}
	   }
	}
	else
	{
		alert("请选择要删除的接收科室数据！")
	}
}

function getRowcount(obj)
{ if (obj)
	{return obj.rows.length-1 ;}
	return 0	
	}


document.body.onload = BodyLoadHandler;