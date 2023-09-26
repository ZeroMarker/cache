//DHCRisTechian.js 


function BodyLoadHandler()
{
	var date=document.getElementById("Date");
	var xlocid=session["LOGON.CTLOCID"] ;
	var LocID=document.getElementById("LocID");
	LocID.value=xlocid;
	if (date.value=="")
	{
	    date.value=DateDemo();
	}
    var ExcuteObj=document.getElementById("Excute");
	if (ExcuteObj)
	{
		ExcuteObj.onclick=ExcuteClick;
	}
	var CancelObj=document.getElementById("Cancel");
	if (CancelObj)
	{
		CancelObj.onclick=CancelExcuteClick;
	}
	document.getElementById("ExecuteDoc").value=session['LOGON.USERCODE'];
}

function ExcuteClick()
{
  var ordtab=document.getElementById("tDHCRisTechian");
  var ExecFun=document.getElementById("ExecFun").value;
  var UserCode=session['LOGON.USERCODE'];
    
  if (ordtab) 
  {
     for (var i=1; i<ordtab.rows.length; i++)
     {
        var selectedobj=document.getElementById("TSelectedz"+i);
        if ((selectedobj)&&(selectedobj.checked))
        {
	        var StudyNo=document.getElementById("StudyNoz"+i).innerText;
	    	var TechianDoc=document.getElementById("TechianDocz"+i).innerText;
	    	if (TechianDoc==" ")
	    	{
		     	var FilmNums=document.getElementById("FilmNumsz"+i).value; 
		   		var exposeNums=document.getElementById("exposeNumsz"+i).value; 
   				var value=cspRunServerMethod(ExecFun,StudyNo,FilmNums,exposeNums,UserCode);
	    	}
	    	else
	    	{
		    	alert(t['CanntExecute']);
		    	
		   		    	
	    	}
	    	
		}//select
      }// for 
    }

	
}

function CancelExcuteClick()
{
	 //check password 	
  var usercode=document.getElementById('ExecuteDoc').value;
  var userpass=document.getElementById('password');
  
  var getmethod=document.getElementById('CheckPWD');
  if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
  
  var retval=cspRunServerMethod(encmeth,usercode,userpass.value)
  alert(retval);
  
  if (retval=="-1"){alert(t['05']);return;}	
  if (retval=="-2"){alert(t['02']);userpass.value="";websys_setfocus('password');return;}	
  if (retval=="-5"){alert(t['05']);return;}	
  
  var ordtab=document.getElementById("tDHCRisTechian");
  var CancelFun=document.getElementById("CancelFun").value;
    
  if (ordtab) 
  {
     for (var i=1; i<ordtab.rows.length; i++)
     {
        var selectedobj=document.getElementById("TSelectedz"+i);
        if ((selectedobj)&&(selectedobj.checked))
        {
	        var StudyNo=document.getElementById("StudyNoz"+i).innerText;
	    	var value=cspRunServerMethod(CancelFun,StudyNo);
	    }
	 }
   }
}
	
function DateDemo()
{
   var d, s="";         
   d = new Date(); 
   var sDay="",sMonth="",sYear="";
   sDay = d.getDate();		
   if(sDay < 10)
   sDay = "0"+sDay;
    
   sMonth = d.getMonth()+1;		
   if(sMonth < 10)
   sMonth = "0"+sMonth;
   
   sYear  = d.getYear();		
   s = sDay + "/" + sMonth + "/" + sYear;            
   return(s); 
   
                             
}



function GetEQInfo(Info)
{
	var tem=Info.split("^");
	document.getElementById("DeviceName").value=tem[2];
    document.getElementById("EQDR").value=tem[0];


}

document.body.onload = BodyLoadHandler;


