
function BodyLoadHandler()
{
	var SCORERowId,ScoreType;
	var obj=document.getElementById('SCORERowId')
	if(obj) SCORERowId=obj.value;
	var obj=document.getElementById('ScoreType')
	if(obj) ScoreType=obj.value;
	obj=document.getElementById('GetScoreCRAMS').value;
    var retval=cspRunServerMethod(obj,SCORERowId,ScoreType);  
	DisPlayScoreCRAMS(retval);
	
	var ObjC2=document.getElementById("C2");
	if(ObjC2) ObjC2.onclick=ClearCRAMS_click;
	var ObjC1=document.getElementById("C1");
	if(ObjC1) ObjC1.onclick=ClearCRAMS_click;
	var ObjC0=document.getElementById("C0");
	if(ObjC0) ObjC0.onclick=ClearCRAMS_click;
	
	var ObjR2=document.getElementById("R2");
	if(ObjR2) ObjR2.onclick=ClearCRAMS_click;	
	var ObjR1=document.getElementById("R1");
	if(ObjR1) ObjR1.onclick=ClearCRAMS_click;	
	var ObjR0=document.getElementById("R0");
	if(ObjR0) ObjR0.onclick=ClearCRAMS_click;	
	
	var ObjA2=document.getElementById("A2");
	if(ObjA2) ObjA2.onclick=ClearCRAMS_click;	
	var ObjA1=document.getElementById("A1");
	if(ObjA1) ObjA1.onclick=ClearCRAMS_click;	
	var ObjA0=document.getElementById("A0");
	if(ObjA0) ObjA0.onclick=ClearCRAMS_click;	
	

	var ObjM2=document.getElementById("M2");
	if(ObjM2) ObjM2.onclick=ClearCRAMS_click;	
	var ObjM1=document.getElementById("M1");
	if(ObjM1) ObjM1.onclick=ClearCRAMS_click;	
	var ObjM0=document.getElementById("M0");
	if(ObjM0) ObjM0.onclick=ClearCRAMS_click;	
	
	var ObjS2=document.getElementById("S2");	
	if(ObjS2) ObjS2.onclick=ClearCRAMS_click;	
	var ObjS1=document.getElementById("S1");
	if(ObjS1) ObjS1.onclick=ClearCRAMS_click;	
	var ObjS0=document.getElementById("S0");
	if(ObjS0) ObjS0.onclick=ClearCRAMS_click;	
	
	var obj=document.getElementById('AddScoreCRAMS')	
	if(obj) obj.onclick=AddScoreCRAMS_click;
	var obj=document.getElementById('DeleteScoreCRAMS')	
	if(obj) obj.onclick=DeleteScoreCRAMS_click;

}

function ClearCRAMS_click()
{	
	var eSrc=window.event.srcElement;
	var Obj=document.getElementById(eSrc.name);
	if((eSrc.name.indexOf("C")>-1)&&(Obj.checked==true)) ClearCRAMS(eSrc.name,"C");
	if((eSrc.name.indexOf("R")>-1)&&(Obj.checked==true)) ClearCRAMS(eSrc.name,"R");
	if((eSrc.name.indexOf("A")>-1)&&(Obj.checked==true)) ClearCRAMS(eSrc.name,"A");
	if((eSrc.name.indexOf("M")>-1)&&(Obj.checked==true)) ClearCRAMS(eSrc.name,"M");
	if((eSrc.name.indexOf("S")>-1)&&(Obj.checked==true)) ClearCRAMS(eSrc.name,"S");
}	
function ClearCRAMS(eSrcStr,Str)
{
	for(i=0;i<3;i++)
	{
		if(eSrcStr==(Str+i)) document.getElementById(Str+i).checked=true;
			
		else document.getElementById(Str+i).checked=false;
	}

}


function AddScoreCRAMS_click()
{
	var C,A,R,M,S;
	var ObjSCORERowId=document.getElementById("SCORERowId");
	if(ObjSCORERowId) SCORERowId=ObjSCORERowId.value;
	var obj=document.getElementById('ScoreType')
	if(obj) ScoreType=obj.value;


	var ObjC2=document.getElementById("C2");
	if(ObjC2.checked==true) C=2;	
	var ObjC1=document.getElementById("C1");
	if(ObjC1.checked==true) C=1;
	var ObjC0=document.getElementById("C0");
	if(ObjC0.checked==true) C=0;
    if(C!=2&&C!=1&&C!=0) 
    {
	    alert(t['NULL_Circul']);
        return;
    }

	var ObjR2=document.getElementById("R2");
	if(ObjR2.checked==true) R=2;	
	var ObjR1=document.getElementById("R1");
	if(ObjR1.checked==true) R=1;
	var ObjR0=document.getElementById("R0");
	if(ObjR0.checked==true) R=0;
    if(R!=2&&R!=1&&R!=0) 
    {
	    alert(t['NULL_Resp']);
        return;
    }

	var ObjA2=document.getElementById("A2");
	if(ObjA2.checked==true) A=2;	
	var ObjA1=document.getElementById("A1");
	if(ObjA1.checked==true) A=1;
	var ObjA0=document.getElementById("A0");
	if(ObjA0.checked==true) A=0;
    if(A!=2&&A!=1&&A!=0) 
    {
	    alert(t['NULL_Abdomen']);
        return;
    }
	
	var ObjM2=document.getElementById("M2");
	if(ObjM2.checked==true) M=2;	
	var ObjM1=document.getElementById("M1");
	if(ObjM1.checked==true) M=1;
	var ObjM0=document.getElementById("M0");
	if(ObjM0.checked==true) M=0;
    if(M!=2&&M!=1&&M!=0) 
    {
	    alert(t['NULL_Motor']);
        return;
    }
	
	var ObjS2=document.getElementById("S2");
	if(ObjS2.checked==true) S=2;	
	var ObjS1=document.getElementById("S1");
	if(ObjS1.checked==true) S=1;
	var ObjS0=document.getElementById("S0");
	if(ObjS0.checked==true) S=0;
    if(S!=2&&S!=1&&S!=0) 
    {
	    alert(t['NULL_Speech']);
        return;
    }
						
	var obj=document.getElementById('AddCRAMS')
	if(obj) 
	{
		var encmeth=obj.value;
	    var resStr=cspRunServerMethod(encmeth,SCORERowId,C,R,A,M,S)
	    if (resStr!='0'){
			alert(t['Error']);
			return;
		}	
		else  
		{
			alert(t['Success']);
	    	//location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCCLScoreDetail&SCORERowId="+SCORERowId;
			obj=document.getElementById('GetScoreCRAMS').value;
    		var retval=cspRunServerMethod(obj,SCORERowId,ScoreType);  
	        DisPlayScoreCRAMS(retval);	
		}
	}
}

function DeleteScoreCRAMS_click()
{
	var SCORERowId,MEDSRowId;
	var ObjSCORERowId=document.getElementById("SCORERowId");
	if(ObjSCORERowId) SCORERowId=ObjSCORERowId.value;
	var obj=document.getElementById('ScoreType')
	if(obj) ScoreType=obj.value;
	var obj=document.getElementById('DeleteCRAMS')
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

function DisPlayScoreCRAMS(Str) 
{
	var s=Str.split("^");
	var CRAMSScore=s[0];
	var CirculScore=s[1];
	var RespScore=s[2];
	var AbdomenScore=s[3];
	var MotorScore=s[4];
	var SpeechScore=s[5];
    
    var ObjCRAMSScore=document.getElementById("CRAMSScore");
    if(ObjCRAMSScore) ObjCRAMSScore.value=CRAMSScore;
	var ObjC2=document.getElementById("C2");
	var ObjC1=document.getElementById("C1");
	var ObjC0=document.getElementById("C0");

	var ObjR2=document.getElementById("R2");	
	var ObjR1=document.getElementById("R1");
	var ObjR0=document.getElementById("R0");
	
	var ObjA2=document.getElementById("A2");	
	var ObjA1=document.getElementById("A1");
	var ObjA0=document.getElementById("A0");
	
	var ObjM2=document.getElementById("M2");
	var ObjM1=document.getElementById("M1");
	var ObjM0=document.getElementById("M0");
	
	var ObjS2=document.getElementById("S2");	
	var ObjS1=document.getElementById("S1");
	var ObjS0=document.getElementById("S0");

        switch(CirculScore)
        {
	        case "2":
	        	ObjC2.checked=true;
	        	break;
	        case "1":
	        	ObjC1.checked=true;
	        	break;
	        case "0":
	        	ObjC0.checked=true;
	        	break;
	    }
	        
	    switch(RespScore)
        {
	        case "2":
	        	ObjR2.checked=true;
	        	break;
	        case "1":
	        	ObjR1.checked=true;
	        	break;
	        case "0":
	        	ObjR0.checked=true;
	        	break;
	    }

	    switch(AbdomenScore)
        {
	        case "2":
	        	ObjA2.checked=true;
	        	break;
	        case "1":
	        	ObjA1.checked=true;
	        	break;
	        case "0":
	        	ObjA0.checked=true;
	        	break;
	    }
	    
	    switch(MotorScore)
        {
	        case "2":
	        	ObjM2.checked=true;
	        	break;
	        case "1":
	        	ObjM1.checked=true;
	        	break;
	        case "0":
	        	ObjM0.checked=true;
	        	break;
	    }
	    
	    switch(SpeechScore)
        {
	        case "2":
	        	ObjS2.checked=true;
	        	break;
	        case "1":
	        	ObjS1.checked=true;
	        	break;
	        case "0":
	        	ObjS0.checked=true;
	        	break;
	    }

}

document.body.onload = BodyLoadHandler;