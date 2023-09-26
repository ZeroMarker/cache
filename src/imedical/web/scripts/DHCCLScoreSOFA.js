
function BodyLoadHandler()
{
	var SCORERowId,ScoreType;
	var obj=document.getElementById('SCORERowId')
	if(obj) SCORERowId=obj.value;
	var obj=document.getElementById('ScoreType')
	if(obj) ScoreType=obj.value;
	obj=document.getElementById('GetScoreSOFA').value;
    var retval=cspRunServerMethod(obj,SCORERowId,ScoreType);
	DisPlayScoreSOFA(retval);
	
	var ObjRespScore1=document.getElementById("RespScore1");
	if(ObjRespScore1) ObjRespScore1.onclick=ClearSOFA_click;
	var ObjRespScore2=document.getElementById("RespScore2");
	if(ObjRespScore2) ObjRespScore2.onclick=ClearSOFA_click;
	var ObjRespScore3=document.getElementById("RespScore3");
	if(ObjRespScore3) ObjRespScore3.onclick=ClearSOFA_click;
	var ObjRespScore4=document.getElementById("RespScore4");   
	if(ObjRespScore4) ObjRespScore4.onclick=ClearSOFA_click;
	var ObjCoagulationScore1=document.getElementById("CoagulationScore1");
	if(ObjCoagulationScore1) ObjCoagulationScore1.onclick=ClearSOFA_click;
	var ObjCoagulationScore2=document.getElementById("CoagulationScore2");
	if(ObjCoagulationScore2) ObjCoagulationScore2.onclick=ClearSOFA_click;
	var ObjCoagulationScore3=document.getElementById("CoagulationScore3");
	if(ObjCoagulationScore3) ObjCoagulationScore3.onclick=ClearSOFA_click;
	var ObjCoagulationScore4=document.getElementById("CoagulationScore4");
	if(ObjCoagulationScore4) ObjCoagulationScore4.onclick=ClearSOFA_click;
	var ObjLiverScore1=document.getElementById("LiverScore1");
	if(ObjLiverScore1) ObjLiverScore1.onclick=ClearSOFA_click;
	var ObjLiverScore2=document.getElementById("LiverScore2");
	if(ObjLiverScore2) ObjLiverScore2.onclick=ClearSOFA_click;
	var ObjLiverScore3=document.getElementById("LiverScore3");
	if(ObjLiverScore3) ObjLiverScore3.onclick=ClearSOFA_click;
	var ObjLiverScore4=document.getElementById("LiverScore4");
	if(ObjLiverScore4) ObjLiverScore4.onclick=ClearSOFA_click;
    var ObjCardiovascularScore1=document.getElementById("CardiovascularScore1");
	if(ObjCardiovascularScore1) ObjCardiovascularScore1.onclick=ClearSOFA_click;
    var ObjCardiovascularScore2=document.getElementById("CardiovascularScore2");
	if(ObjCardiovascularScore2) ObjCardiovascularScore2.onclick=ClearSOFA_click;
    var ObjCardiovascularScore3=document.getElementById("CardiovascularScore3");
	if(ObjCardiovascularScore3) ObjCardiovascularScore3.onclick=ClearSOFA_click;
    var ObjCardiovascularScore4=document.getElementById("CardiovascularScore4");
	if(ObjCardiovascularScore4) ObjCardiovascularScore4.onclick=ClearSOFA_click;
	var ObjCentralNervousScore1=document.getElementById("CentralNervousScore1");
	if(ObjCentralNervousScore1) ObjCentralNervousScore1.onclick=ClearSOFA_click;
	var ObjCentralNervousScore2=document.getElementById("CentralNervousScore2");
	if(ObjCentralNervousScore2) ObjCentralNervousScore2.onclick=ClearSOFA_click;
	var ObjCentralNervousScore3=document.getElementById("CentralNervousScore3");
	if(ObjCentralNervousScore3) ObjCentralNervousScore3.onclick=ClearSOFA_click;
	var ObjCentralNervousScore4=document.getElementById("CentralNervousScore4");
	if(ObjCentralNervousScore4) ObjCentralNervousScore4.onclick=ClearSOFA_click;
	var ObjRenalScore1=document.getElementById("RenalScore1");
	if(ObjRenalScore1) ObjRenalScore1.onclick=ClearSOFA_click;
	var ObjRenalScore2=document.getElementById("RenalScore2");
	if(ObjRenalScore2) ObjRenalScore2.onclick=ClearSOFA_click;
	var ObjRenalScore3=document.getElementById("RenalScore3");
	if(ObjRenalScore3) ObjRenalScore3.onclick=ClearSOFA_click;
	var ObjRenalScore4=document.getElementById("RenalScore4");
	if(ObjRenalScore4) ObjRenalScore4.onclick=ClearSOFA_click;

	var obj=document.getElementById('AddScoreSOFA')	
	if(obj) obj.onclick=AddScoreSOFA_click;
	var obj=document.getElementById('UpdateScoreSOFA')	
	if(obj) obj.onclick=UpdateScoreSOFA_click;
	var obj=document.getElementById('DeleteScoreSOFA')	
	if(obj) obj.onclick=DeleteScoreSOFA_click;

}

function ClearSOFA_click()
{	
	var eSrc=window.event.srcElement;
	var Obj=document.getElementById(eSrc.name);
	if((eSrc.name.indexOf("RespScore")>-1)&&(Obj.checked==true)) ClearSOFA(eSrc.name,"RespScore");
	if((eSrc.name.indexOf("CoagulationScore")>-1)&&(Obj.checked==true)) ClearSOFA(eSrc.name,"CoagulationScore");
	if((eSrc.name.indexOf("LiverScore")>-1)&&(Obj.checked==true)) ClearSOFA(eSrc.name,"LiverScore");
	if((eSrc.name.indexOf("CardiovascularScore")>-1)&&(Obj.checked==true)) ClearSOFA(eSrc.name,"CardiovascularScore");
	if((eSrc.name.indexOf("CentralNervousScore")>-1)&&(Obj.checked==true)) ClearSOFA(eSrc.name,"CentralNervousScore");
	if((eSrc.name.indexOf("RenalScore")>-1)&&(Obj.checked==true)) ClearSOFA(eSrc.name,"RenalScore");

}	
function ClearSOFA(eSrcStr,Str)
{
	for(i=1;i<5;i++)
	{
		if(eSrcStr==(Str+i)) document.getElementById(Str+i).checked=true;
			
		else document.getElementById(Str+i).checked=false;
	}

}


function AddScoreSOFA_click()
{
	var SCORERowId,RespScore,CoagulationScore,LiverScore,CardiovascularScore,CentralNervousScore,RenalScore
	var ObjSCORERowId=document.getElementById("SCORERowId");
	if(ObjSCORERowId) SCORERowId=ObjSCORERowId.value;
	var obj=document.getElementById('ScoreType')
	if(obj) ScoreType=obj.value;

	var ObjRespScore1=document.getElementById("RespScore1");
	if(ObjRespScore1.checked==true) RespScore=1;	
	var ObjRespScore2=document.getElementById("RespScore2");
	if(ObjRespScore2.checked==true) RespScore=2;	
	var ObjRespScore3=document.getElementById("RespScore3");
	if(ObjRespScore3.checked==true) RespScore=3;	
	var ObjRespScore4=document.getElementById("RespScore4");
	if(ObjRespScore4.checked==true) RespScore=4;	
	
    if(RespScore!=1&&RespScore!=2&&RespScore!=3&&RespScore!=4) 
    {
	    alert(t['NULL_RespScore']);
        return;
    }
    
	var ObjCoagulationScore1=document.getElementById("CoagulationScore1");
	if(ObjCoagulationScore1.checked==true) CoagulationScore=1;	
	var ObjCoagulationScore2=document.getElementById("CoagulationScore2");
	if(ObjCoagulationScore2.checked==true) CoagulationScore=2;	
	var ObjCoagulationScore3=document.getElementById("CoagulationScore3");
	if(ObjCoagulationScore3.checked==true) CoagulationScore=3;	
	var ObjCoagulationScore4=document.getElementById("CoagulationScore4");
	if(ObjCoagulationScore4.checked==true) CoagulationScore=4;		
	if(CoagulationScore!=1&&CoagulationScore!=2&&CoagulationScore!=3&&CoagulationScore!=4) 
    {
	    alert(t['NULL_CoagulationScore']);
        return;
    }

	var ObjLiverScore1=document.getElementById("LiverScore1");
	if(ObjLiverScore1.checked==true) LiverScore=1;	
	var ObjLiverScore2=document.getElementById("LiverScore2");
	if(ObjLiverScore2.checked==true) LiverScore=2;	
	var ObjLiverScore3=document.getElementById("LiverScore3");
	if(ObjLiverScore3.checked==true) LiverScore=3;	
	var ObjLiverScore4=document.getElementById("LiverScore4");
	if(ObjLiverScore4.checked==true) LiverScore=4;	
    if(LiverScore!=1&&LiverScore!=2&&LiverScore!=3&&LiverScore!=4) 
    {
	    alert(t['NULL_LiverScore']);
        return;
    }

    var ObjCardiovascularScore1=document.getElementById("CardiovascularScore1");
	if(ObjCardiovascularScore1.checked==true) CardiovascularScore=1;	
    var ObjCardiovascularScore2=document.getElementById("CardiovascularScore2");
	if(ObjCardiovascularScore2.checked==true) CardiovascularScore=2;	
    var ObjCardiovascularScore3=document.getElementById("CardiovascularScore3");
	if(ObjCardiovascularScore3.checked==true) CardiovascularScore=3;	
    var ObjCardiovascularScore4=document.getElementById("CardiovascularScore4");
	if(ObjCardiovascularScore4.checked==true) CardiovascularScore=4;
    if(CardiovascularScore!=1&&CardiovascularScore!=2&&CardiovascularScore!=3&&CardiovascularScore!=4) 
    {
	    alert(t['NULL_CardiovascularScore']);
        return;
    }

	var ObjCentralNervousScore1=document.getElementById("CentralNervousScore1");
	if(ObjCentralNervousScore1.checked==true) CentralNervousScore=1;	
	var ObjCentralNervousScore2=document.getElementById("CentralNervousScore2");
	if(ObjCentralNervousScore2.checked==true) CentralNervousScore=2;
	var ObjCentralNervousScore3=document.getElementById("CentralNervousScore3");
	if(ObjCentralNervousScore3.checked==true) CentralNervousScore=3;
	var ObjCentralNervousScore4=document.getElementById("CentralNervousScore4");
	if(ObjCentralNervousScore4.checked==true) CentralNervousScore=4;    
	if(CentralNervousScore!=1&&CentralNervousScore!=2&&CentralNervousScore!=3&&CentralNervousScore!=4) 
    {
	    alert(t['NULL_CentralNervousScore']);
        return;
    }

	var ObjRenalScore1=document.getElementById("RenalScore1");
	if(ObjRenalScore1.checked==true) RenalScore=1;	
	var ObjRenalScore2=document.getElementById("RenalScore2");
	if(ObjRenalScore2.checked==true) RenalScore=2;	
	var ObjRenalScore3=document.getElementById("RenalScore3");
	if(ObjRenalScore3.checked==true) RenalScore=3;	
	var ObjRenalScore4=document.getElementById("RenalScore4");
	if(ObjRenalScore4.checked==true) RenalScore=4;	
    if(RenalScore!=1&&RenalScore!=2&&RenalScore!=3&&RenalScore!=4) 
    {
	    alert(t['NULL_RenalScore']);
        return;
    }

	var obj=document.getElementById('AddSOFA')
	if(obj) 
	{
		var encmeth=obj.value;
	    var resStr=cspRunServerMethod(encmeth,SCORERowId,RespScore,CoagulationScore,LiverScore,CardiovascularScore,CentralNervousScore,RenalScore)
	    if (resStr!='0'){
			alert(t['Error']);
			return;
		}	
		else  
		{
			alert(t['Success']);
			obj=document.getElementById('GetScoreSOFA').value;
    		var retval=cspRunServerMethod(obj,SCORERowId,ScoreType);
			DisPlayScoreSOFA(retval);
		}
	}
}

function DeleteScoreSOFA_click()
{
	var SCORERowId,SOFARowId;
	var ObjSCORERowId=document.getElementById("SCORERowId");
	if(ObjSCORERowId) SCORERowId=ObjSCORERowId.value;
	var obj=document.getElementById('DeleteSOFA')
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





function DisPlayScoreSOFA(Str)
{
	var s=Str.split("^");
	var SOFAScore=s[0];
	var RespScore=s[1];
	var CoagulationScore=s[2];
	var LiverScore=s[3];
	var CardiovascularScore=s[4];
	var CentralNervousScore=s[5];
	var RenalScore=s[6];
    
    if(Str=="")
    {   
    	var obj=document.getElementById('SCORERowId')
		if(obj) SCORERowId=obj.value;
    	var obj=document.getElementById("GetScoreSOFA").value;
    	var retStr=cspRunServerMethod(obj,SCORERowId,"GLASG");
    	var CentralNervousScore1=retStr.split("^")[0];
    	if(CentralNervousScore1>=13&&CentralNervousScore1<=15) CentralNervousScore="1";
    	if(CentralNervousScore1>=10&&CentralNervousScore1<=12) CentralNervousScore="2";
    	if(CentralNervousScore1>=6&&CentralNervousScore1<=9) CentralNervousScore="3";
    	if(CentralNervousScore1>=3&&CentralNervousScore1<6) CentralNervousScore="4"; 	
    }
	var ObjSOFAScore=document.getElementById("SOFAScore");
    if(ObjSOFAScore) ObjSOFAScore.value=SOFAScore;
	var ObjRespScore1=document.getElementById("RespScore1");
	var ObjRespScore2=document.getElementById("RespScore2");
	var ObjRespScore3=document.getElementById("RespScore3");
	var ObjRespScore4=document.getElementById("RespScore4");   
	var ObjCoagulationScore1=document.getElementById("CoagulationScore1");
	var ObjCoagulationScore2=document.getElementById("CoagulationScore2");
	var ObjCoagulationScore3=document.getElementById("CoagulationScore3");
	var ObjCoagulationScore4=document.getElementById("CoagulationScore4");
	var ObjLiverScore1=document.getElementById("LiverScore1");
	var ObjLiverScore2=document.getElementById("LiverScore2");
	var ObjLiverScore3=document.getElementById("LiverScore3");
	var ObjLiverScore4=document.getElementById("LiverScore4");
    var ObjCardiovascularScore1=document.getElementById("CardiovascularScore1");
    var ObjCardiovascularScore2=document.getElementById("CardiovascularScore2");
    var ObjCardiovascularScore3=document.getElementById("CardiovascularScore3");
    var ObjCardiovascularScore4=document.getElementById("CardiovascularScore4");
	var ObjCentralNervousScore1=document.getElementById("CentralNervousScore1");
	var ObjCentralNervousScore2=document.getElementById("CentralNervousScore2");
	var ObjCentralNervousScore3=document.getElementById("CentralNervousScore3");
	var ObjCentralNervousScore4=document.getElementById("CentralNervousScore4");
	var ObjRenalScore1=document.getElementById("RenalScore1");
	var ObjRenalScore2=document.getElementById("RenalScore2");
	var ObjRenalScore3=document.getElementById("RenalScore3");
	var ObjRenalScore4=document.getElementById("RenalScore4");
	        switch(RespScore)
        {
	        case "1":
	        	ObjRespScore1.checked=true;
	        	break;
	        case "2":
	        	ObjRespScore2.checked=true;
	        	break;
	        case "3":
	        	ObjRespScore3.checked=true;
	        	break;
	        case "4":
	        	ObjRespScore4.checked=true;
	        	break;
	    }
	        
        switch(CoagulationScore)
        {
	        case "1":
	        	ObjCoagulationScore1.checked=true;
	        	break;
	        case "2":
	        	ObjCoagulationScore2.checked=true;
	        	break;
	        case "3":
	        	ObjCoagulationScore3.checked=true;
	        	break;
	        case "4":
	        	ObjCoagulationScore4.checked=true;
	        	break;
	    }
	    switch(LiverScore)
        {
	        case "1":
	        	ObjLiverScore1.checked=true;
	        	break;
	        case "2":
	        	ObjLiverScore2.checked=true;
	        	break;
	        case "3":
	        	ObjLiverScore3.checked=true;
	        	break;
	        case "4":
	        	ObjLiverScore4.checked=true;
	        	break;
	    }
	    switch(CardiovascularScore)
        {
	        case "1":
	        	ObjCardiovascularScore1.checked=true;
	        	break;
	        case "2":
	        	ObjCardiovascularScore2.checked=true;
	        	break;
	        case "3":
	        	ObjCardiovascularScore3.checked=true;
	        	break;
	        case "4":
	        	ObjCardiovascularScore4.checked=true;
	        	break;
	    }
		switch(CentralNervousScore)
        {
	        case "1":
	        	ObjCentralNervousScore1.checked=true;
	        	break;
	        case "2":
	        	ObjCentralNervousScore2.checked=true;
	        	break;
	        case "3":
	        	ObjCentralNervousScore3.checked=true;
	        	break;
	        case "4":
	        	ObjCentralNervousScore4.checked=true;
	        	break;
	    }
	    
		switch(RenalScore)
        {
	        case "1":
	        	ObjRenalScore1.checked=true;
	        	break;
	        case "2":
	        	ObjRenalScore2.checked=true;
	        	break;
	        case "3":
	        	ObjRenalScore3.checked=true;
	        	break;
	        case "4":
	        	ObjRenalScore4.checked=true;
	        	break;
	    } 

}



document.body.onload = BodyLoadHandler;