
function BodyLoadHandler()
{
	var SCORERowId,ScoreType;
	var obj=document.getElementById('SCORERowId')
	if(obj) SCORERowId=obj.value;
	var obj=document.getElementById('ScoreType')
	if(obj) ScoreType=obj.value;
	obj=document.getElementById('GetScoreGLASG').value;
    var retval=cspRunServerMethod(obj,SCORERowId,ScoreType);
	DisPlayScoreGLASG(retval);
	
	var ObjEyeScore4=document.getElementById("EyeScore4");
	if(ObjEyeScore4) ObjEyeScore4.onclick=ClearGLASG_click;
	var ObjEyeScore3=document.getElementById("EyeScore3");
	if(ObjEyeScore3) ObjEyeScore3.onclick=ClearGLASG_click;
	var ObjEyeScore2=document.getElementById("EyeScore2");
	if(ObjEyeScore2) ObjEyeScore2.onclick=ClearGLASG_click;
	var ObjEyeScore1=document.getElementById("EyeScore1");
	if(ObjEyeScore1) ObjEyeScore1.onclick=ClearGLASG_click;
	var ObjVerbalScore5=document.getElementById("VerbalScore5");
	if(ObjVerbalScore5) ObjVerbalScore5.onclick=ClearGLASG_click;
	var ObjVerbalScore4=document.getElementById("VerbalScore4");
	if(ObjVerbalScore4) ObjVerbalScore4.onclick=ClearGLASG_click;
	var ObjVerbalScore3=document.getElementById("VerbalScore3");
	if(ObjVerbalScore3) ObjVerbalScore3.onclick=ClearGLASG_click;
	var ObjVerbalScore2=document.getElementById("VerbalScore2");
	if(ObjVerbalScore2) ObjVerbalScore2.onclick=ClearGLASG_click;
	var ObjVerbalScore1=document.getElementById("VerbalScore1");
	if(ObjVerbalScore1) ObjVerbalScore1.onclick=ClearGLASG_click;
	var ObjMotorScore6=document.getElementById("MotorScore6");
	if(ObjMotorScore6) ObjMotorScore6.onclick=ClearGLASG_click;
	var ObjMotorScore5=document.getElementById("MotorScore5");
	if(ObjMotorScore5) ObjMotorScore5.onclick=ClearGLASG_click;
	var ObjMotorScore4=document.getElementById("MotorScore4");
	if(ObjMotorScore4) ObjMotorScore4.onclick=ClearGLASG_click;
	var ObjMotorScore3=document.getElementById("MotorScore3");
	if(ObjMotorScore3) ObjMotorScore3.onclick=ClearGLASG_click;
	var ObjMotorScore2=document.getElementById("MotorScore2");
	if(ObjMotorScore2) ObjMotorScore2.onclick=ClearGLASG_click;
	var ObjMotorScore1=document.getElementById("MotorScore1");
	if(ObjMotorScore1) ObjMotorScore1.onclick=ClearGLASG_click;

	var obj=document.getElementById('AddScoreGLASG')	
	if(obj) obj.onclick=AddScoreGLASG_click;
	var obj=document.getElementById('DeleteScoreGLASG')	
	if(obj) obj.onclick=DeleteScoreGLASG_click;

}
function ClearGLASG_click()
{	
	var eSrc=window.event.srcElement;
	var Obj=document.getElementById(eSrc.name);
	if((eSrc.name.indexOf("EyeScore")>-1)&&(Obj.checked==true)) ClearGLASG(eSrc.name,"EyeScore");
	if((eSrc.name.indexOf("VerbalScore")>-1)&&(Obj.checked==true)) ClearGLASG(eSrc.name,"VerbalScore");
	if((eSrc.name.indexOf("MotorScore")>-1)&&(Obj.checked==true)) ClearGLASG(eSrc.name,"MotorScore");
}	
function ClearGLASG(eSrcStr,Str)
{
	for(i=1;i<7;i++)
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


function AddScoreGLASG_click()
{
	var EyeScore,VerbalScore,MotorScore;
	var ObjSCORERowId=document.getElementById("SCORERowId");
	if(ObjSCORERowId) SCORERowId=ObjSCORERowId.value;
	var obj=document.getElementById('ScoreType')
	if(obj) ScoreType=obj.value;
	var ObjEyeScore4=document.getElementById("EyeScore4");
	if(ObjEyeScore4.checked==true) EyeScore=4;	
	var ObjEyeScore3=document.getElementById("EyeScore3");
	if(ObjEyeScore3.checked==true) EyeScore=3;	
	var ObjEyeScore2=document.getElementById("EyeScore2");
	if(ObjEyeScore2.checked==true) EyeScore=2;	
	var ObjEyeScore1=document.getElementById("EyeScore1");
	if(ObjEyeScore1.checked==true) EyeScore=1;	
   if(EyeScore!=1&&EyeScore!=2&&EyeScore!=3&&EyeScore!=4) 
    {
	    alert(t['NULL_EyeScore']);
        return;
    }
	
	var ObjVerbalScore5=document.getElementById("VerbalScore5");
	if(ObjVerbalScore5.checked==true) VerbalScore=5;	
	var ObjVerbalScore4=document.getElementById("VerbalScore4");
	if(ObjVerbalScore4.checked==true) VerbalScore=4;
	var ObjVerbalScore3=document.getElementById("VerbalScore3");
	if(ObjVerbalScore3.checked==true) VerbalScore=3;
	var ObjVerbalScore2=document.getElementById("VerbalScore2");
	if(ObjVerbalScore2.checked==true) VerbalScore=2;
	var ObjVerbalScore1=document.getElementById("VerbalScore1");
	if(ObjVerbalScore1.checked==true) VerbalScore=1;
	if(VerbalScore!=1&&VerbalScore!=2&&VerbalScore!=3&&VerbalScore!=4&&VerbalScore!=5) 
    {
	    alert(t['NULL_VerbalScore']);
        return;
    }
	var ObjMotorScore5=document.getElementById("MotorScore5");
	if(ObjMotorScore5.checked==true) MotorScore=5;
	var ObjMotorScore4=document.getElementById("MotorScore4");
	if(ObjMotorScore4.checked==true) MotorScore=4;
	var ObjMotorScore3=document.getElementById("MotorScore3");
	if(ObjMotorScore3.checked==true) MotorScore=3;
	var ObjMotorScore2=document.getElementById("MotorScore2");
	if(ObjMotorScore2.checked==true) MotorScore=2;
	var ObjMotorScore1=document.getElementById("MotorScore1");
	if(ObjMotorScore1.checked==true) MotorScore=1;
    if(MotorScore!=1&&MotorScore!=2&&MotorScore!=3&&MotorScore!=4&&MotorScore!=5&&MotorScore!=6) 
    {
	    alert(t['NULL_MotorScore']);
        return;
    }				
	var obj=document.getElementById('AddGLASG')
	if(obj) 
	{
		var encmeth=obj.value;
	    var resStr=cspRunServerMethod(encmeth,SCORERowId,EyeScore,VerbalScore,MotorScore)
	    if (resStr!='0'){
			alert(t['Error']);
			return;
		}	
		else  
		{
			alert(t['Success']);
	    	//location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCCLScoreGlasgow&SCORERowId="+SCORERowId;
			obj=document.getElementById('GetScoreGLASG').value;
    		var retval=cspRunServerMethod(obj,SCORERowId,ScoreType);  
	        DisPlayScoreGLASG(retval);	

		}
	}
}	

function DeleteScoreGLASG_click()
{
	var SCORERowId,GLASGRowId;
	var ObjSCORERowId=document.getElementById("SCORERowId");
	if(ObjSCORERowId) SCORERowId=ObjSCORERowId.value;
	var obj=document.getElementById('ScoreType')
	if(obj) ScoreType=obj.value;
	var obj=document.getElementById('DeleteGLASG')
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

function DisPlayScoreGLASG(Str) 
{
	var s=Str.split("^");
	var GLASGScore=s[0];
	var EyeScore=s[1];
	var VerbalScore=s[2];
	var MotorScore=s[3];
    
    var ObjGLASGScore=document.getElementById("GLASGScore");
    if(ObjGLASGScore) ObjGLASGScore.value=GLASGScore;
	var ObjEyeScore4=document.getElementById("EyeScore4");
	var ObjEyeScore3=document.getElementById("EyeScore3");
	var ObjEyeScore2=document.getElementById("EyeScore2");
	var ObjEyeScore1=document.getElementById("EyeScore1");
	var ObjVerbalScore5=document.getElementById("VerbalScore5");
	var ObjVerbalScore4=document.getElementById("VerbalScore4");
	var ObjVerbalScore3=document.getElementById("VerbalScore3");
	var ObjVerbalScore2=document.getElementById("VerbalScore2");
	var ObjVerbalScore1=document.getElementById("VerbalScore1");
	var ObjMotorScore6=document.getElementById("MotorScore6");
	var ObjMotorScore5=document.getElementById("MotorScore5");
	var ObjMotorScore4=document.getElementById("MotorScore4");
	var ObjMotorScore3=document.getElementById("MotorScore3");
	var ObjMotorScore2=document.getElementById("MotorScore2");
	var ObjMotorScore1=document.getElementById("MotorScore1");

        switch(EyeScore)
        {
	        case "4":
	        	ObjEyeScore4.checked=true;
	        	break;
	        case "3":
	        	ObjEyeScore3.checked=true;
	        	break;
	        case "2":
	        	ObjEyeScore2.checked=true;
	        	break;
	        case "1":
	        	ObjEyeScore1.checked=true;
	        	break;
   		}
	        
	    switch(VerbalScore)
        {
	        case "5":
	        	ObjVerbalScore5.checked=true;
	        	break;
	        case "4":
	        	ObjVerbalScore4.checked=true;
	        	break;
	        case "3":
	        	ObjVerbalScore3.checked=true;
	        	break;
	        case "2":
	        	ObjVerbalScore2.checked=true;
	        	break;
	        case "1":
	        	ObjVerbalScore1.checked=true;
	        	break;
 		}

	    switch(MotorScore)
        {
	        case "6":
	        	ObjMotorScore6.checked=true;
	        	break;
	        case "5":
	        	ObjMotorScore5.checked=true;
	        	break;
	        case "4":
	        	ObjMotorScore4.checked=true;
	        	break;
	        case "3":
	        	ObjMotorScore3.checked=true;
	        	break;
	        case "2":
	        	ObjMotorScore2.checked=true;
	        	break;
	        case "1":
	        	ObjMotorScore1.checked=true;
	        	break;
	    }


}

document.body.onload = BodyLoadHandler;