var admType,Dept
function BodyLoadHandler()
{         
   //
 //  var schobj=document.getElementById("BtSearCH");
  //  if (schobj) {schobj.onclick=sch_click;}	
   var stdate=document.getElementById("StartDate");
   var edate=document.getElementById("EndDate");
   if(stdate.value.length==0){stdate.value=DateDemo();}
   if(edate.value.length==0){edate.value=DateDemo();}

}

function DateDemo(){
   var d, s="";
   d = new Date();
   s += d.getDate() + "/";
   s += (d.getMonth() + 1) + "/";
   s += d.getYear();
   return(s);
}
function getloc(str)
{
   var loc=str.split("^");
   var obj=document.getElementById("locid")
   obj.value=loc[1];
}

function sch_click()
{
	
   var stdate=document.getElementById("StartDate").value;
   var edate=document.getElementById("EndDate").value;
   if (GetDate(stdate)>GetDate(edate)) {alert(t['alert:startEndDateErr']);return}
   //var locId=document.getElementById("locid").value;
   //alert(locId);	
   //var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCNURSEXCUTE"+"&wardid="+wardid+"&RegNo="+regobj+"&userId="+userId+"&StartDate="+stdate+"&EndDate="+edate+"&vartyp="+vartyp+"&gap="+gap+"&warddes="+wardobj+"&Loc="+locid+"&doctyp="+doctyp+"&longNewOrdAdd="+longNewOrdAdd+"&RollOrd="+RollOrd.checked;
   // parent.frames['OrdList'].location.href=lnk; 
   // 
}

function GetDate(dateStr)
{
	var tmpList=dateStr.split("/")
	if (tmpList.length<3) return 0;
	return ((tmpList[2]*1000)+(tmpList[1]*50)+tmpList[0]*1)
}

document.body.onload = BodyLoadHandler;	