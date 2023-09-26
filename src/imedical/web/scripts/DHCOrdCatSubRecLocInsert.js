
function BodyLoadHandler()
{   
	obj=document.getElementById('Insert');
	if (obj) obj.onclick =Insert_Click;

	obj=document.getElementById('Journal')
	if (obj) obj.onclick=FindJournal_Click
}


function Insert_Click()
{
  var Jobobj=document.getElementById('Job');
  if (obj) {var job=Jobobj.value}
  var SaveSetFun=document.getElementById("GetInsertFuntion").value;
  var Str1=cspRunServerMethod(SaveSetFun,job);
  var journal="Journal"
  var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCOrdCatSubRecLocJournal&Job="+job+"&JouType="+journal
  window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=800,height=400,left=100,top=100')
	  	
  
}

function FindJournal_Click()
{
	    var Jobobj=document.getElementById('Job');
        if (obj) {var job=Jobobj.value}
        //alert(job)
         var journal="Journal"
         var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCOrdCatSubRecLocJournal&Job="+job+"&JouType="+journal
         window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=800,height=400,left=100,top=100')
	  	}

document.body.onload = BodyLoadHandler;