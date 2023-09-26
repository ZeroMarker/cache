
function BodyLoadHandler()
{
	var SCORERowId,ScoreType;
	var obj=document.getElementById('SCORERowId')
	if(obj) SCORERowId=obj.value;
	var obj=document.getElementById('ScoreType')
	if(obj) ScoreType=obj.value;
	obj=document.getElementById('GetScoreRTS').value;
    var retval=cspRunServerMethod(obj,SCORERowId,ScoreType);
	DisPlayScoreRTS(retval);
	
	var ObjGlasgowScore4=document.getElementById("GlasgowScore4");
	if(ObjGlasgowScore4) ObjGlasgowScore4.onclick=ClearRTS_click
	var ObjGlasgowScore3=document.getElementById("GlasgowScore3");
	if(ObjGlasgowScore3) ObjGlasgowScore3.onclick=ClearRTS_click
	var ObjGlasgowScore2=document.getElementById("GlasgowScore2");
	if(ObjGlasgowScore2) ObjGlasgowScore2.onclick=ClearRTS_click
	var ObjGlasgowScore1=document.getElementById("GlasgowScore1");
	if(ObjGlasgowScore1) ObjGlasgowScore1.onclick=ClearRTS_click
	var ObjGlasgowScore0=document.getElementById("GlasgowScore0");	
	if(ObjGlasgowScore0) ObjGlasgowScore0.onclick=ClearRTS_click												
	var ObjSystolicBPScore4=document.getElementById("SystolicBPScore4");	
	if(ObjSystolicBPScore4) ObjSystolicBPScore4.onclick=ClearRTS_click												
	var ObjSystolicBPScore3=document.getElementById("SystolicBPScore3");		
	if(ObjSystolicBPScore3) ObjSystolicBPScore3.onclick=ClearRTS_click												
	var ObjSystolicBPScore2=document.getElementById("SystolicBPScore2");	
	if(ObjSystolicBPScore2) ObjSystolicBPScore2.onclick=ClearRTS_click												
	var ObjSystolicBPScore1=document.getElementById("SystolicBPScore1");			
	if(ObjSystolicBPScore1) ObjSystolicBPScore1.onclick=ClearRTS_click												
	var ObjSystolicBPScore0=document.getElementById("SystolicBPScore0");
	if(ObjSystolicBPScore0) ObjSystolicBPScore0.onclick=ClearRTS_click												
	var ObjRespRateScore4=document.getElementById("RespRateScore4");
	if(ObjRespRateScore4) ObjRespRateScore4.onclick=ClearRTS_click												
	var ObjRespRateScore3=document.getElementById("RespRateScore3");
	if(ObjRespRateScore3) ObjRespRateScore3.onclick=ClearRTS_click												
	var ObjRespRateScore2=document.getElementById("RespRateScore2");
	if(ObjRespRateScore2) ObjRespRateScore2.onclick=ClearRTS_click												
	var ObjRespRateScore1=document.getElementById("RespRateScore1");
	if(ObjRespRateScore1) ObjRespRateScore1.onclick=ClearRTS_click												
	var ObjRespRateScore0=document.getElementById("RespRateScore0");
	if(ObjRespRateScore0) ObjRespRateScore0.onclick=ClearRTS_click												

	
	var obj=document.getElementById('AddScoreRTS')	
	if(obj) obj.onclick=AddScoreRTS_click;
	var obj=document.getElementById('DeleteScoreRTS')	
	if(obj) obj.onclick=DeleteScoreRTS_click;
}

function ClearRTS_click()
{	
	var eSrc=window.event.srcElement;
	var Obj=document.getElementById(eSrc.name);
	if((eSrc.name.indexOf("GlasgowScore")>-1)&&(Obj.checked==true)) ClearRTS(eSrc.name,"GlasgowScore");
	if((eSrc.name.indexOf("SystolicBPScore")>-1)&&(Obj.checked==true)) ClearRTS(eSrc.name,"SystolicBPScore");
	if((eSrc.name.indexOf("RespRateScore")>-1)&&(Obj.checked==true)) ClearRTS(eSrc.name,"RespRateScore");
}	

function ClearRTS(eSrcStr,Str)
{
	for(i=0;i<5;i++)
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

function AddScoreRTS_click()
{
	var GlasgowScore,SystolicBPScore,RespRateScore;
	var ObjSCORERowId=document.getElementById("SCORERowId");
	if(ObjSCORERowId) SCORERowId=ObjSCORERowId.value;
	var obj=document.getElementById('ScoreType')
	if(obj) ScoreType=obj.value;

	var ObjGlasgowScore4=document.getElementById("GlasgowScore4");
	if(ObjGlasgowScore4.checked==true) GlasgowScore=4;	
	var ObjGlasgowScore3=document.getElementById("GlasgowScore3");
	if(ObjGlasgowScore3.checked==true) GlasgowScore=3;	
	var ObjGlasgowScore2=document.getElementById("GlasgowScore2");
	if(ObjGlasgowScore2.checked==true) GlasgowScore=2;	
	var ObjGlasgowScore1=document.getElementById("GlasgowScore1");
	if(ObjGlasgowScore1.checked==true) GlasgowScore=1;	
	var ObjGlasgowScore0=document.getElementById("GlasgowScore1");
	if(ObjGlasgowScore0.checked==true) GlasgowScore=0;	
    if(GlasgowScore!=0&&GlasgowScore!=1&&GlasgowScore!=2&&GlasgowScore!=3&&GlasgowScore!=4) 
    {
	    alert(t['NULL_GlasgowScore']);
        return;
    }
													
	var ObjSystolicBPScore4=document.getElementById("SystolicBPScore4");
	if(ObjSystolicBPScore4.checked==true) SystolicBPScore=4;
	
	var ObjSystolicBPScore3=document.getElementById("SystolicBPScore3");
	if(ObjSystolicBPScore3.checked==true) SystolicBPScore=3;
		
	var ObjSystolicBPScore2=document.getElementById("SystolicBPScore2");
	if(ObjSystolicBPScore2.checked==true) SystolicBPScore=2;	
	
	var ObjSystolicBPScore1=document.getElementById("SystolicBPScore1");
	if(ObjSystolicBPScore1.checked==true) SystolicBPScore=1;
			
	var ObjSystolicBPScore0=document.getElementById("SystolicBPScore0");
	if(ObjSystolicBPScore0.checked==true) SystolicBPScore=0;	
    if(SystolicBPScore!=0&&SystolicBPScore!=1&&SystolicBPScore!=2&&SystolicBPScore!=3&&SystolicBPScore!=4) 
    {
	    alert(t['NULL_SystolicBPScore']);
        return;
    }

	var ObjRespRateScore4=document.getElementById("RespRateScore4");
	if(ObjRespRateScore4.checked==true) RespRateScore=4;
	var ObjRespRateScore3=document.getElementById("RespRateScore3");
	if(ObjRespRateScore3.checked==true) RespRateScore=3;
	var ObjRespRateScore2=document.getElementById("RespRateScore2");
	if(ObjRespRateScore2.checked==true) RespRateScore=2;
	var ObjRespRateScore1=document.getElementById("RespRateScore1");
	if(ObjRespRateScore1.checked==true) RespRateScore=1;
	var ObjRespRateScore0=document.getElementById("RespRateScore0");
	if(ObjRespRateScore0.checked==true) RespRateScore=0;
    if(RespRateScore!=0&&RespRateScore!=1&&RespRateScore!=2&&RespRateScore!=3&&RespRateScore!=4) 
    {
	    alert(t['NULL_RespRateScore']);
        return;
    }					
	var obj=document.getElementById('AddRTS')

	if(obj) 
	{
		var encmeth=obj.value;
	    var resStr=cspRunServerMethod(encmeth,SCORERowId,GlasgowScore,SystolicBPScore,RespRateScore);
	    if (resStr!='0'){
			alert(t['Error']);
			return;
		}	
		else  
		{
			alert(t['Success']);
	    	//location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCCLScoreRTS&SCORERowId="+SCORERowId;
			obj=document.getElementById('GetScoreRTS').value;
    		var retval=cspRunServerMethod(obj,SCORERowId,ScoreType);  
			DisPlayScoreRTS(retval);

		}
	}
}	

function DeleteScoreRTS_click()
{
	var SCORERowId,RTSRowId;
	var ObjSCORERowId=document.getElementById("SCORERowId");
	if(ObjSCORERowId) SCORERowId=ObjSCORERowId.value;
	var obj=document.getElementById('ScoreType')
	if(obj) ScoreType=obj.value;
	var obj=document.getElementById('DeleteRTS')
	
	if(obj) 
	{
		var encmeth=obj.value;
	    var resStr=cspRunServerMethod(encmeth,SCORERowId);
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

function DisPlayScoreRTS(Str) 
{
	var s=Str.split("^");
	var RTSScore=s[0];
	var GlasgowScore=s[1];
	var SystolicBPScore=s[2];
	var RespRateScore=s[3];

    if(Str=="")
    {   
    	var obj=document.getElementById('SCORERowId')
		if(obj) SCORERowId=obj.value;
    	var obj=document.getElementById("GetScoreRTS").value;
    	var retStr=cspRunServerMethod(obj,SCORERowId,"GLASG");
    	var GlasgowScore1=retStr.split("^")[0];
    	if(GlasgowScore1>=13&&GlasgowScore1<=15) GlasgowScore="4";
    	if(GlasgowScore1>=9&&GlasgowScore1<=12) GlasgowScore="3";
    	if(GlasgowScore1>=6&&GlasgowScore1<=8) GlasgowScore="2";
    	if(GlasgowScore1>=4&&GlasgowScore1<=5) GlasgowScore="1";
    	if(GlasgowScore1==3) GlasgowScore="0";  	
    }
    var ObjRTSScore=document.getElementById("RTSScore");
    if(ObjRTSScore) ObjRTSScore.value=RTSScore;
	var ObjGlasgowScore4=document.getElementById("GlasgowScore4");
	var ObjGlasgowScore3=document.getElementById("GlasgowScore3");
	var ObjGlasgowScore2=document.getElementById("GlasgowScore2");
	var ObjGlasgowScore1=document.getElementById("GlasgowScore1");
	var ObjGlasgowScore0=document.getElementById("GlasgowScore0");													
	var ObjSystolicBPScore4=document.getElementById("SystolicBPScore4");	
	var ObjSystolicBPScore3=document.getElementById("SystolicBPScore3");		
	var ObjSystolicBPScore2=document.getElementById("SystolicBPScore2");	
	var ObjSystolicBPScore1=document.getElementById("SystolicBPScore1");			
	var ObjSystolicBPScore0=document.getElementById("SystolicBPScore0");
	var ObjRespRateScore4=document.getElementById("RespRateScore4");
	var ObjRespRateScore3=document.getElementById("RespRateScore3");
	var ObjRespRateScore2=document.getElementById("RespRateScore2");
	var ObjRespRateScore1=document.getElementById("RespRateScore1");
	var ObjRespRateScore0=document.getElementById("RespRateScore0");

        switch(GlasgowScore)
        {
	        case "4":
	        	ObjGlasgowScore4.checked=true;
	        	break;
	        case "3":
	        	ObjGlasgowScore3.checked=true;
	        	break;
	        case "2":
	        	ObjGlasgowScore2.checked=true;
	        	break;
	        case "1":
	        	ObjGlasgowScore1.checked=true;
	        	break;
	        case "0":
	        	ObjGlasgowScore0.checked=true;
	        	break;


	    }

	    switch(SystolicBPScore)
        {
	        case "4":
	        	ObjSystolicBPScore4.checked=true;
	        	break;
	        case "3":
	        	ObjSystolicBPScore3.checked=true;
	        	break;
	        case "2":
	        	ObjSystolicBPScore2.checked=true;
	        	break;
	        case "1":
	        	ObjSystolicBPScore1.checked=true;
	        	break;
	        case "0":
	        	ObjSystolicBPScore0.checked=true;
	        	break;     	
	    }

	    switch(RespRateScore)
        {
	        case "4":
	        	ObjRespRateScore4.checked=true;
	        	break;
	        case "3":
	        	ObjRespRateScore3.checked=true;
	        	break;
	        case "2":
	        	ObjRespRateScore2.checked=true;
	        	break;
	        case "1":
	        	ObjRespRateScore1.checked=true;
	        	break;
	        case "0":
	        	ObjRespRateScore0.checked=true;
	        	break;
        }

    
}

document.body.onload = BodyLoadHandler;