
function BodyLoadHandler()
{
	var SCORERowId,ScoreType;
	var obj=document.getElementById('SCORERowId')
	if(obj) SCORERowId=obj.value;
	var obj=document.getElementById('ScoreType')
	if(obj) ScoreType=obj.value;
	obj=document.getElementById('GetScoreCPugh').value;
    var retval=cspRunServerMethod(obj,SCORERowId,ScoreType);
	DisPlayScoreCPugh(retval);
	
	var ObjHepatEncephalScore1=document.getElementById("HepatEncephalScore1");
	if(ObjHepatEncephalScore1) ObjHepatEncephalScore1.onclick=ClearCPugh_click;
	var ObjHepatEncephalScore2=document.getElementById("HepatEncephalScore2");
	if(ObjHepatEncephalScore2) ObjHepatEncephalScore2.onclick=ClearCPugh_click;
	var ObjHepatEncephalScore3=document.getElementById("HepatEncephalScore3");
	if(ObjHepatEncephalScore3) ObjHepatEncephalScore3.onclick=ClearCPugh_click;
	var ObjAscitesScore1=document.getElementById("AscitesScore1");
	if(ObjAscitesScore1) ObjAscitesScore1.onclick=ClearCPugh_click;
	var ObjAscitesScore2=document.getElementById("AscitesScore2");
	if(ObjAscitesScore2) ObjAscitesScore2.onclick=ClearCPugh_click;
	var ObjAscitesScore3=document.getElementById("AscitesScore3");
	if(ObjAscitesScore3) ObjAscitesScore3.onclick=ClearCPugh_click;
	var ObjTotalBilirubinScore1=document.getElementById("TotalBilirubinScore1");
	if(ObjTotalBilirubinScore1) ObjTotalBilirubinScore1.onclick=ClearCPugh_click;
	var ObjTotalBilirubinScore2=document.getElementById("TotalBilirubinScore2");
	if(ObjTotalBilirubinScore2) ObjTotalBilirubinScore2.onclick=ClearCPugh_click;
	var ObjTotalBilirubinScore3=document.getElementById("TotalBilirubinScore3");
	if(ObjTotalBilirubinScore3) ObjTotalBilirubinScore3.onclick=ClearCPugh_click;
	var ObjSerumAlbuminScore1=document.getElementById("SerumAlbuminScore1");
	if(ObjSerumAlbuminScore1) ObjSerumAlbuminScore1.onclick=ClearCPugh_click;
	var ObjSerumAlbuminScore2=document.getElementById("SerumAlbuminScore2");
	if(ObjSerumAlbuminScore2) ObjSerumAlbuminScore2.onclick=ClearCPugh_click;
	var ObjSerumAlbuminScore3=document.getElementById("SerumAlbuminScore3");
	if(ObjSerumAlbuminScore3) ObjSerumAlbuminScore3.onclick=ClearCPugh_click;
	var ObjProthrombinTimeScore1=document.getElementById("ProthrombinTimeScore1");
	if(ObjProthrombinTimeScore1) ObjProthrombinTimeScore1.onclick=ClearCPugh_click;
	var ObjProthrombinTimeScore2=document.getElementById("ProthrombinTimeScore2");
	if(ObjProthrombinTimeScore2) ObjProthrombinTimeScore2.onclick=ClearCPugh_click;
	var ObjProthrombinTimeScore3=document.getElementById("ProthrombinTimeScore3");
	if(ObjProthrombinTimeScore3) ObjProthrombinTimeScore3.onclick=ClearCPugh_click;

	var obj=document.getElementById('AddScoreCPugh')	
	if(obj) obj.onclick=AddScoreCPugh_click;
	var obj=document.getElementById('DeleteScoreCPugh')	
	if(obj) obj.onclick=DeleteScoreCPugh_click;

}
function ClearCPugh_click()
{	
	var eSrc=window.event.srcElement;
	var Obj=document.getElementById(eSrc.name);
	if((eSrc.name.indexOf("HepatEncephalScore")>-1)&&(Obj.checked==true)) ClearCPugh(eSrc.name,"HepatEncephalScore");
	if((eSrc.name.indexOf("AscitesScore")>-1)&&(Obj.checked==true)) ClearCPugh(eSrc.name,"AscitesScore");
	if((eSrc.name.indexOf("TotalBilirubinScore")>-1)&&(Obj.checked==true)) ClearCPugh(eSrc.name,"TotalBilirubinScore");
	if((eSrc.name.indexOf("SerumAlbuminScore")>-1)&&(Obj.checked==true)) ClearCPugh(eSrc.name,"SerumAlbuminScore");
	if((eSrc.name.indexOf("ProthrombinTimeScore")>-1)&&(Obj.checked==true)) ClearCPugh(eSrc.name,"ProthrombinTimeScore");
}	
function ClearCPugh(eSrcStr,Str)
{
	for(i=1;i<4;i++)
	{
		if(eSrcStr==(Str+i)) 
		{
			obj=document.getElementById(Str+i)
			if(obj) obj.checked=true;
		}
			
		else 
		{
			obj=document.getElementById(Str+i)
			if(obj) obj.checked=false;
		}
	}

}


function AddScoreCPugh_click()
{
	var HepatEncephalScore,AscitesScore,TotalBilirubinScore,SerumAlbuminScore,ProthrombinTimeScore;
	var ObjSCORERowId=document.getElementById("SCORERowId");
	if(ObjSCORERowId) SCORERowId=ObjSCORERowId.value;
	var obj=document.getElementById('ScoreType')
	if(obj) ScoreType=obj.value;
	var ObjHepatEncephalScore1=document.getElementById("HepatEncephalScore1");
	if(ObjHepatEncephalScore1.checked==true) HepatEncephalScore=1;	
	var ObjHepatEncephalScore2=document.getElementById("HepatEncephalScore2");
	if(ObjHepatEncephalScore2.checked==true) HepatEncephalScore=2;	
	var ObjHepatEncephalScore3=document.getElementById("HepatEncephalScore3");
	if(ObjHepatEncephalScore3.checked==true) HepatEncephalScore=3;	
	if(HepatEncephalScore!=1&&HepatEncephalScore!=2&&HepatEncephalScore!=3) 
    {
	    alert(t['NULL_HepatEncephalScore']);
        return;
    }
	
	var ObjAscitesScore1=document.getElementById("AscitesScore1");
	if(ObjAscitesScore1.checked==true) AscitesScore=1;	
	var ObjAscitesScore2=document.getElementById("AscitesScore2");
	if(ObjAscitesScore2.checked==true) AscitesScore=2;	
	var ObjAscitesScore3=document.getElementById("AscitesScore3");
	if(ObjAscitesScore3.checked==true) AscitesScore=3;	
	if(AscitesScore!=1&&AscitesScore!=2&&AscitesScore!=3) 
    {
	    alert(t['NULL_AscitesScore']);
        return;
    }
	
	var ObjTotalBilirubinScore1=document.getElementById("TotalBilirubinScore1");
	if(ObjTotalBilirubinScore1.checked==true) TotalBilirubinScore=1;
	var ObjTotalBilirubinScore2=document.getElementById("TotalBilirubinScore2");
	if(ObjTotalBilirubinScore2.checked==true) TotalBilirubinScore=2;
	var ObjTotalBilirubinScore3=document.getElementById("TotalBilirubinScore3");
	if(ObjTotalBilirubinScore3.checked==true) TotalBilirubinScore=3;
    if(TotalBilirubinScore!=1&&TotalBilirubinScore!=2&&TotalBilirubinScore!=3) 
    {
	    alert(t['NULL_TotalBilirubinScore']);
        return;
    }				
	var ObjSerumAlbuminScore1=document.getElementById("SerumAlbuminScore1");
	if(ObjSerumAlbuminScore1.checked==true) SerumAlbuminScore=1;
	var ObjSerumAlbuminScore2=document.getElementById("SerumAlbuminScore2");
	if(ObjSerumAlbuminScore2.checked==true) SerumAlbuminScore=2;
	var ObjSerumAlbuminScore3=document.getElementById("SerumAlbuminScore3");
	if(ObjSerumAlbuminScore3.checked==true) SerumAlbuminScore=3;
    if(SerumAlbuminScore!=1&&SerumAlbuminScore!=2&&SerumAlbuminScore!=3) 
    {
	    alert(t['NULL_SerumAlbuminScore']);
        return;
    }				
	var ObjProthrombinTimeScore1=document.getElementById("ProthrombinTimeScore1");
	if(ObjProthrombinTimeScore1.checked==true) ProthrombinTimeScore=1;
	var ObjProthrombinTimeScore2=document.getElementById("ProthrombinTimeScore2");
	if(ObjProthrombinTimeScore2.checked==true) ProthrombinTimeScore=2;
	var ObjProthrombinTimeScore3=document.getElementById("ProthrombinTimeScore3");
	if(ObjProthrombinTimeScore3.checked==true) ProthrombinTimeScore=3;
    if(ProthrombinTimeScore!=1&&ProthrombinTimeScore!=2&&ProthrombinTimeScore!=3) 
    {
	    alert(t['NULL_ProthrombinTimeScore']);
        return;
    }				
	var ChildPughScoreStr=HepatEncephalScore+"^"+AscitesScore+"^"+TotalBilirubinScore+"^"+SerumAlbuminScore+"^"+ProthrombinTimeScore;
	var obj=document.getElementById('AddCPugh')
	if(obj) 
	{
		var encmeth=obj.value;
	    var resStr=cspRunServerMethod(encmeth,SCORERowId,ChildPughScoreStr)
	    if (resStr!='0'){
			alert(t['Error']);
			return;
		}	
		else  
		{
			alert(t['Success']);
	    	//location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCCLScoreGlasgow&SCORERowId="+SCORERowId;
			obj=document.getElementById('GetScoreCPugh').value;
    		var retval=cspRunServerMethod(obj,SCORERowId,ScoreType);  
	        DisPlayScoreCPugh(retval);	

		}
	}
}	

function DeleteScoreCPugh_click()
{
	var SCORERowId,GLASGRowId;
	var ObjSCORERowId=document.getElementById("SCORERowId");
	if(ObjSCORERowId) SCORERowId=ObjSCORERowId.value;
	var obj=document.getElementById('DeleteCPugh')
	if(obj) 
	{
		var encmeth=obj.value;
	    var resStr=cspRunServerMethod(encmeth,SCORERowId)
	    if (resStr!='0'){
			alert(t['Error']);
			return;
		}	
		else  
		{
			alert(t['Success']);
	    	window.location.reload();
		}
	}
}

function DisPlayScoreCPugh(Str) 
{
	var s=Str.split("^");
	var ChildPughScore=s[0];
	var HepatEncephalScore=s[1];
	var AscitesScore=s[2];
	var TotalBilirubinScore=s[3];
    var SerumAlbuminScore=s[4];
    var ProthrombinTimeScore=s[5];

    if((ChildPughScore>=5)&&(ChildPughScore<=8)) ChildPughScore=ChildPughScore+"|"+t["gradeA"];
    if((ChildPughScore>=9)&&(ChildPughScore<=11)) ChildPughScore=ChildPughScore+"|"+t["gradeB"];
    if((ChildPughScore>=12)&&(ChildPughScore<=15)) ChildPughScore=ChildPughScore+"|"+t["gradeC"];
    var ObjChildPughScore=document.getElementById("ChildPughScore");
    if(ObjChildPughScore) ObjChildPughScore.value=ChildPughScore;	
	var ObjHepatEncephalScore1=document.getElementById("HepatEncephalScore1");
	var ObjHepatEncephalScore2=document.getElementById("HepatEncephalScore2");
	var ObjHepatEncephalScore3=document.getElementById("HepatEncephalScore3");
	var ObjAscitesScore1=document.getElementById("AscitesScore1");
	var ObjAscitesScore2=document.getElementById("AscitesScore2");
	var ObjAscitesScore3=document.getElementById("AscitesScore3");
	var ObjTotalBilirubinScore1=document.getElementById("TotalBilirubinScore1");
	var ObjTotalBilirubinScore2=document.getElementById("TotalBilirubinScore2");
	var ObjTotalBilirubinScore3=document.getElementById("TotalBilirubinScore3");
	var ObjSerumAlbuminScore1=document.getElementById("SerumAlbuminScore1");
	var ObjSerumAlbuminScore2=document.getElementById("SerumAlbuminScore2");
	var ObjSerumAlbuminScore3=document.getElementById("SerumAlbuminScore3");
	var ObjProthrombinTimeScore1=document.getElementById("ProthrombinTimeScore1");
	var ObjProthrombinTimeScore2=document.getElementById("ProthrombinTimeScore2");
	var ObjProthrombinTimeScore3=document.getElementById("ProthrombinTimeScore3");

        switch(HepatEncephalScore)
        {
	        case "1":
	        	ObjHepatEncephalScore1.checked=true;
	        	break;
	        case "2":
	        	ObjHepatEncephalScore2.checked=true;
	        	break;
	        case "3":
	        	ObjHepatEncephalScore3.checked=true;
	        	break;
   		}
	        
	    switch(AscitesScore)
        {
	        case "1":
	        	ObjAscitesScore1.checked=true;
	        	break;
	        case "2":
	        	ObjAscitesScore2.checked=true;
	        	break;
	        case "3":
	        	ObjAscitesScore3.checked=true;
	        	break;
 		}

	    switch(TotalBilirubinScore)
        {
	        case "1":
	        	ObjTotalBilirubinScore1.checked=true;
	        	break;
	        case "2":
	        	ObjTotalBilirubinScore2.checked=true;
	        	break;
	        case "3":
	        	ObjTotalBilirubinScore3.checked=true;
	        	break;
	    }
	    switch(SerumAlbuminScore)
        {
	        case "1":
	        	ObjSerumAlbuminScore1.checked=true;
	        	break;
	        case "2":
	        	ObjSerumAlbuminScore2.checked=true;
	        	break;
	        case "3":
	        	ObjSerumAlbuminScore3.checked=true;
	        	break;
	    }
	    switch(ProthrombinTimeScore)
        {
	        case "1":
	        	ObjProthrombinTimeScore1.checked=true;
	        	break;
	        case "2":
	        	ObjProthrombinTimeScore2.checked=true;
	        	break;
	        case "3":
	        	ObjProthrombinTimeScore3.checked=true;
	        	break;
	    }
}

document.body.onload = BodyLoadHandler;