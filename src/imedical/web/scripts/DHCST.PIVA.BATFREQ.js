var currRow="";

function BodyLoadHandler()
{
  var obj=document.getElementById("Update")
  if (obj) obj.onclick=setFreqtime;
  var obj=document.getElementById("Freq")
  if (obj) obj.ondblclick=openFreqlist;
  var obj=document.getElementById("Ploc"); 
    if (obj) 
	{obj.onkeydown=popDispLoc;
	 obj.onblur=DispLocCheck;}   
}
function openFreqlist()
{
   var link="websys.default.csp?WEBSYS.TCOMPONENT=DHCST.PIVA.FREQLIST"
   window.open(link,"_TARGET","height=300,width=500,menubar=no,status=yes,toolbar=no,resizable=yes")
}

function SelectRowHandler()
{
	currRow=selectedRow(window)
	setItem(currRow)
}

function setItem(currRow)
{
   
   var objloc=document.getElementById("Tloc"+"z"+currRow)
   if (objloc) var ploc=objloc.innerText;
   var objfreq=document.getElementById("Tfreq"+"z"+currRow)
   if (objfreq) var freq=objfreq.innerText
   var objbatno=document.getElementById("Tbatno"+"z"+currRow)
   if (objbatno) var batno=objbatno.innerText
   var objgrpno=document.getElementById("Tgrpno"+"z"+currRow)
   if (objgrpno) var grpno=objgrpno.innerText
   var objstiem=document.getElementById("Tstiem"+"z"+currRow)
   if (objstiem) var stiem=objstiem.innerText

   var objPloc=document.getElementById("Ploc")
    objPloc.value=ploc
   var objFreq=document.getElementById("Freq")
    objFreq.value=freq
   var objBatno=document.getElementById("Batno")
    objBatno.value=batno
   var objGrpno=document.getElementById("Grpno")
    objGrpno.value=grpno
   var objStime=document.getElementById("Stime")
    objStime.value=stiem

}

function setFreqtime()
{

    if (currRow!=""){var flag=2
    	var objrowid=document.getElementById("Trowid"+"z"+currRow)
        var rowid=objrowid.value;}
    if (currRow=="") {
	      flag=1
          rowid=""}   //flag 1:增加   2:更新
	var objPloc=document.getElementById("plocrowid")
	var Ploc=objPloc.value
	
	if (Ploc==""){alert("配液科室没有填写")
	              return;}
	var objFreq=document.getElementById("Freq")
	var Freq=objFreq.value
	if (Freq==""){alert("用药频率没有填写")
	              return;}
    var objBatno=document.getElementById("Batno")
	var Batno=objBatno.value
	if (Batno==""){alert("批次没有填写")
	              return;}
	var objGrpno=document.getElementById("Grpno")
	var Grpno=objGrpno.value
	if (Grpno==""){alert("轮次没有填写")
	              return;}
	var objStime=document.getElementById("Stime")
	var Stime=objStime.value
	if (Stime==""){alert("开始时间没有填写")
	              return;}
	      
	if (flag==2){
		var objPloc=document.getElementById("Ploc")
	    var Ploc=objPloc.value}

    var xx=document.getElementById("mSave");
	if (xx) {var encmeth=xx.value;} else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,Ploc,Freq,Batno,Grpno,Stime,flag,rowid)
	if (result==-1){alert("此设置失败!")}
	else {alert("OK")}
	
	self.location.reload();
	
}


function popDispLoc()
   { 
	if (window.event.keyCode==13) 
	  {  window.event.keyCode=117;
	     Ploc_lookuphandler();
        }
   }
function DispLocCheck()
{
	var obj=document.getElementById("Ploc");
	var obj2=document.getElementById("plocrowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	
	}
function DispLocLookUpSelect(str)
{ 
	var loc=str.split("^");
	var obj=document.getElementById("plocrowid");
	if (obj)
	{if (loc.length>0)   obj.value=loc[1] ;
		else	obj.value="" ;  
	}
    }

document.body.onload=BodyLoadHandler