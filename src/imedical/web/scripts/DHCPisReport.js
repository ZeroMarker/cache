
var tstatuscode=0
var ttmrowid=""
var paadmdr=""
var orditemdr=""
var pathid=""



function BodyLoadHandler()
{	
    var ordItemDr=document.getElementById("OEorditemID").value
	if (ordItemDr=="") ordItemDr="2182209||13"
    document.getElementById("OEorditemID").value=ordItemDr
    orditemdr=ordItemDr
    
    var admDR=document.getElementById("EpisodeID").value
	if (admDR=="") admDR="2182209"
    document.getElementById("EpisodeID").value=admDR
    paadmdr=admDR 
    
    /*orditemdr=document.getElementById("OEorditemID").value
    paadmdr=document.getElementById("EpisodeID").value
    
    if(orditemdr=="" || paadmdr=="")
    {
	    return
     }
   
     */
    var GetTmrowidFun=document.getElementById("GetTMrowid").value;
  	var TMROWID=cspRunServerMethod(GetTmrowidFun,orditemdr)
  	
  	if(TMROWID!="")
  	{
		ttmrowid=TMROWID
		
		GetPatInfo()
  	    var GetPathIdFun=document.getElementById("GetPathId").value;
	    var PATHID=cspRunServerMethod(GetPathIdFun,ttmrowid)
		pathid=PATHID
		document.getElementById("PathId").value=pathid
		
  	    var GetStatusFun=document.getElementById("GetAppStatus").value;
		var VS = cspRunServerMethod(GetStatusFun,ttmrowid)
		if(VS!='')
		  {    
		      var itemVS=VS.split("~")
		      document.getElementById("VS").value=itemVS[1];

		      var allReportFun=document.getElementById("allReport").value;
 	 	   	  var ALLRPTINFO=cspRunServerMethod(allReportFun,pathid)
  	
   	   		  document.getElementById("Report").value=ALLRPTINFO
	  		     		    
		  }
  	}
  	else
  	{
	 alert(t['tmrowidisnull']) 	
	 }

}

function GetPatInfo()
{
    var GetPatInfoFun=document.getElementById("GetPatInfo").value;
  	var PATINFO=cspRunServerMethod(GetPatInfoFun,ttmrowid)
  	
    if (PATINFO!="")
	{   
		var item=PATINFO.split("^");
		//paadmDr,name,nameP,sexDr,birthDate,admType,chargeType 7
		//,address,tel,IPNo,AdmNo,room,bedNo 13
    	document.getElementById("RegNo").value=item[9];
		document.getElementById("Name").value=item[1];
	
		var vdate3=item[4]
		var ChangDFun=document.getElementById("Date3To4").value
		var vdate4=cspRunServerMethod(ChangDFun,vdate3)
		document.getElementById("DOB").value=vdate4;
		//document.getElementById("Age").value="";
		
		var titem1=item[3].split("~")
		document.getElementById("Sex").value=titem1[1];
		document.getElementById("SexDr").value=titem1[0];
		
		document.getElementById("TelNo").value=item[8];
		document.getElementById("address").value=item[7];
		
		var titem2=item[5].split("~")
		document.getElementById("Admtype").value=titem2[1];
		document.getElementById("AdmtypeDR").value=titem2[0];
		
		var titem3=item[6].split("~")
		document.getElementById("FeeType").value=titem3[1];
		document.getElementById("CharegetypeDR").value=titem3[0]
		document.getElementById("RoomNo").value=item[11];
		document.getElementById("BedNo").value=item[12];
		document.getElementById("InpoNo").value=item[10];
}

}

document.body.onload = BodyLoadHandler;