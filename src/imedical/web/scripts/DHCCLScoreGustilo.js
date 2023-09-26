
function BodyLoadHandler()
{
	var SCORERowId,ScoreType;
	var obj=document.getElementById('SCORERowId')
	if(obj) SCORERowId=obj.value;
	var obj=document.getElementById('ScoreType')
	if(obj) ScoreType=obj.value;
	obj=document.getElementById('GetScoreGUSTL').value;
    var retval=cspRunServerMethod(obj,SCORERowId,ScoreType);
	DisPlayScoreGUSTL(retval);

	var ObjGustiloI=document.getElementById("Gustilo1");
	if(ObjGustiloI) ObjGustiloI.onclick=ClearGUSTL_click;
	var ObjGustiloII=document.getElementById("Gustilo2");
	if(ObjGustiloII) ObjGustiloII.onclick=ClearGUSTL_click;
	var ObjGustiloIIIA=document.getElementById("Gustilo3");
	if(ObjGustiloIIIA) ObjGustiloIIIA.onclick=ClearGUSTL_click;
	var ObjGustiloIIIB=document.getElementById("Gustilo4");
	if(ObjGustiloIIIB) ObjGustiloIIIB.onclick=ClearGUSTL_click;
	var ObjGustiloIIIC=document.getElementById("Gustilo5");
	if(ObjGustiloIIIC) ObjGustiloIIIC.onclick=ClearGUSTL_click;

	var obj=document.getElementById('AddScoreGUSTL')	
	if(obj) obj.onclick=AddScoreGUSTL_click;
	var obj=document.getElementById('UpdateScoreGUSTL')	
	if(obj) obj.onclick=UpdateScoreGUSTL_click;
	var obj=document.getElementById('DeleteScoreGUSTL')	
	if(obj) obj.onclick=DeleteScoreGUSTL_click;

}
function ClearGUSTL_click()
{	
	var eSrc=window.event.srcElement;
	var Obj=document.getElementById(eSrc.name);
	if(Obj.checked==true)
	{	
		for(i=1;i<6;i++)
		{
			if(eSrc.name==("Gustilo"+i)) document.getElementById("Gustilo"+i).checked=true;
			
			else document.getElementById("Gustilo"+i).checked=false;
		}
	}
}	

function AddScoreGUSTL_click()
{
	var GustiloScore;
	var ObjSCORERowId=document.getElementById("SCORERowId");
	if(ObjSCORERowId) SCORERowId=ObjSCORERowId.value;
	var obj=document.getElementById('ScoreType')
	if(obj) ScoreType=obj.value;
	var ObjGustiloI=document.getElementById("Gustilo1");
	if(ObjGustiloI.checked==true) GustiloScore="I";	
	var ObjGustiloII=document.getElementById("Gustilo2");
	if(ObjGustiloII.checked==true) GustiloScore="II";	
	var ObjGustiloIIIA=document.getElementById("Gustilo3");
	if(ObjGustiloIIIA.checked==true) GustiloScore="IIIA";	
	var ObjGustiloIIIB=document.getElementById("Gustilo4");
	if(ObjGustiloIIIB.checked==true) GustiloScore="IIIB";	
	var ObjGustiloIIIC=document.getElementById("Gustilo5");
	if(ObjGustiloIIIC.checked==true) GustiloScore="IIIC";	
				
	var obj=document.getElementById('AddGUSTL')
	if(obj) 
	{
		var encmeth=obj.value;
	    var resStr=cspRunServerMethod(encmeth,SCORERowId,GustiloScore)
	    if (resStr!='0'){
			alert(t['Error']);
			return;
		}	
		else  
		{
			alert(t['Success']);
			obj=document.getElementById('GetScoreGUSTL').value;
    		var retval=cspRunServerMethod(obj,SCORERowId,ScoreType);
			DisPlayScoreGUSTL(retval);
		}
	}
}

function DeleteScoreGUSTL_click()
{
	var SCORERowId,GUSTLRowId;
	var ObjSCORERowId=document.getElementById("SCORERowId");
	if(ObjSCORERowId) SCORERowId=ObjSCORERowId.value;

	var obj=document.getElementById('DeleteGUSTL')
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


function DisPlayScoreGUSTL(Str)
{
	var s=Str.split("^");
	var GUSTLScore=s[0];
	var GUSTLInfectionRate=s[1];
	var AmputationRate=s[2];
    
    var ObjGUSTLScore=document.getElementById("GUSTLScore");
    if(ObjGUSTLScore) ObjGUSTLScore.value=GUSTLScore;
    if(GUSTLScore!="")
    {    
	var ObjGUSTLInfectionRate=document.getElementById("GUSTLInfectionRate");
    if(ObjGUSTLInfectionRate) ObjGUSTLInfectionRate.value=GUSTLInfectionRate;
    var ObjAmputationRate=document.getElementById("AmputationRate");
    if(ObjAmputationRate) ObjAmputationRate.value=AmputationRate;
    }

	var ObjGustiloI=document.getElementById("Gustilo1");
	var ObjGustiloII=document.getElementById("Gustilo2");
	var ObjGustiloIIIA=document.getElementById("Gustilo3");
	var ObjGustiloIIIB=document.getElementById("Gustilo4");
	var ObjGustiloIIIC=document.getElementById("Gustilo5");
	
        switch(GUSTLScore)
        {
	        case "I":
	        	ObjGustiloI.checked=true;
	        	break;
	        case "II":
	        	ObjGustiloII.checked=true;
	        	break;
	        case "IIIA":
	        	ObjGustiloIIIA.checked=true;
	        	break;
	        case "IIIB":
	        	ObjGustiloIIIB.checked=true;
	        	break;
	        case "IIIC":
	        	ObjGustiloIIIC.checked=true;
	        	break;
        }
}



document.body.onload = BodyLoadHandler;