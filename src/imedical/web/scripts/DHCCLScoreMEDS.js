
function BodyLoadHandler()
{
	var SCORERowId,ScoreType;
	var obj=document.getElementById('SCORERowId')
	if(obj) SCORERowId=obj.value;
	var obj=document.getElementById('ScoreType')
	if(obj) ScoreType=obj.value;
	obj=document.getElementById('GetScoreMEDS').value;
    var retval=cspRunServerMethod(obj,SCORERowId,ScoreType);
	DisPlayScoreMEDS(retval);

	var obj=document.getElementById('AddScoreMEDS')	
	if(obj) obj.onclick=AddScoreMEDS_click;
	var obj=document.getElementById('DeleteScoreMEDS')	
	if(obj) obj.onclick=DeleteScoreMEDS_click;


}

function AddScoreMEDS_click()
{
	var SCORERowId,AgeScore,NurHomeResidentScore,TerminalIllnessScore,LowerRespInfectScore,BandProportionScore,TachypneaHypoxiaScore,SepticShockScore,PlateletCountScore,AltMentalStatusScore
	var ObjSCORERowId=document.getElementById("SCORERowId");
	if(ObjSCORERowId) SCORERowId=ObjSCORERowId.value;
	var obj=document.getElementById('ScoreType')
	if(obj) ScoreType=obj.value;
	var ObjAgeScore=document.getElementById("AgeScore");
	if(ObjAgeScore.checked==true) AgeScore=3;
	else AgeScore=0; 	
	var ObjNurHomeResidentScore=document.getElementById("NurHomeResidentScore");
	if(ObjNurHomeResidentScore.checked==true) NurHomeResidentScore=2;
	else NurHomeResidentScore=0;	
	var ObjTerminalIllnessScore=document.getElementById("TerminalIllnessScore");
	if(ObjTerminalIllnessScore.checked==true) TerminalIllnessScore=6;
	else TerminalIllnessScore=0;	
	var ObjLowerRespInfectScore=document.getElementById("LowerRespInfectScore");
	if(ObjLowerRespInfectScore.checked==true) LowerRespInfectScore=2;
	else LowerRespInfectScore=0;	
	var ObjBandProportionScore=document.getElementById("BandProportionScore");
	if(ObjBandProportionScore.checked==true) BandProportionScore=3;
	else BandProportionScore=0;	
	var ObjTachypneaHypoxiaScore=document.getElementById("TachypneaHypoxiaScore");
	if(ObjTachypneaHypoxiaScore.checked==true) TachypneaHypoxiaScore=3;
	else TachypneaHypoxiaScore=0;	
	var ObjSepticShockScore=document.getElementById("SepticShockScore");
    if(ObjSepticShockScore.checked==true) SepticShockScore=3;
	else SepticShockScore=0;	
	var ObjPlateletCountScore=document.getElementById("PlateletCountScore");
    if(ObjPlateletCountScore.checked==true) PlateletCountScore=3;
	else PlateletCountScore=0;	
	var ObjAltMentalStatusScore=document.getElementById("AltMentalStatusScore");
    if(ObjAltMentalStatusScore.checked==true) AltMentalStatusScore=2;
	else AltMentalStatusScore=0;	

	var obj=document.getElementById('AddMEDS')
	if(obj) 
	{
		var encmeth=obj.value;
	    var resStr=cspRunServerMethod(encmeth,SCORERowId,AgeScore,NurHomeResidentScore,TerminalIllnessScore,LowerRespInfectScore,BandProportionScore,TachypneaHypoxiaScore,SepticShockScore,PlateletCountScore,AltMentalStatusScore)
		
		if (resStr!='0')
		{
			alert(t['Error']);
			return;
		}	
		else
		{
			alert(t['Success']);
			obj=document.getElementById('GetScoreMEDS').value;
    		var retval=cspRunServerMethod(obj,SCORERowId,ScoreType);
			DisPlayScoreMEDS(retval);
		}
	}
}

function DeleteScoreMEDS_click()
{
	var SCORERowId,MEDSRowId;
	var ObjSCORERowId=document.getElementById("SCORERowId");
	if(ObjSCORERowId) SCORERowId=ObjSCORERowId.value;
	var obj=document.getElementById('DeleteMEDS')
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

function DisPlayScoreMEDS(Str)
{
	var s=Str.split("^");
	var MEDSScore=s[0];
	var AgeScore=s[1];
	var NurHomeResidentScore=s[2];
	var TerminalIllnessScore=s[3];
	var LowerRespInfectScore=s[4];
	var BandProportionScore=s[5];
	var TachypneaHypoxiaScore=s[6];
	var SepticShockScore=s[7];
	var PlateletCountScore=s[8];
	var AltMentalStatusScore=s[9];

	var ObjMEDSScore=document.getElementById("MEDSScore");
    if(ObjMEDSScore) ObjMEDSScore.value=MEDSScore;
	var ObjAgeScore=document.getElementById("AgeScore");
	var ObjNurHomeResidentScore=document.getElementById("NurHomeResidentScore");
	var ObjTerminalIllnessScore=document.getElementById("TerminalIllnessScore");
	var ObjLowerRespInfectScore=document.getElementById("LowerRespInfectScore");
	var ObjBandProportionScore=document.getElementById("BandProportionScore");
	var ObjTachypneaHypoxiaScore=document.getElementById("TachypneaHypoxiaScore");
	var ObjSepticShockScore=document.getElementById("SepticShockScore");
	var ObjPlateletCountScore=document.getElementById("PlateletCountScore");
	var ObjAltMentalStatusScore=document.getElementById("AltMentalStatusScore");

		if(AgeScore==3) ObjAgeScore.checked=true;
		else ObjAgeScore.checked=false;
	    if(NurHomeResidentScore==2) ObjNurHomeResidentScore.checked=true;
	    else ObjNurHomeResidentScore.checked=false;	
	    if(TerminalIllnessScore==6) ObjTerminalIllnessScore.checked=true;
	    else ObjTerminalIllnessScore.checked=false;
	    if(LowerRespInfectScore==2) ObjLowerRespInfectScore.checked=true;
	    else ObjLowerRespInfectScore.checked=false;
	    if(BandProportionScore==3) ObjBandProportionScore.checked=true;
	    else ObjBandProportionScore.checked=false;
	    if(TachypneaHypoxiaScore==3) ObjTachypneaHypoxiaScore.checked=true;
	    else ObjTachypneaHypoxiaScore.checked=false;
	    if(SepticShockScore==3) ObjSepticShockScore.checked=true;
	    else ObjSepticShockScore.checked=false;
	    if(PlateletCountScore==3) ObjPlateletCountScore.checked=true;
	    else ObjPlateletCountScore.checked=false;
	    if(AltMentalStatusScore==2) ObjAltMentalStatusScore.checked=true;
	    else ObjAltMentalStatusScore.checked=false;

}



document.body.onload = BodyLoadHandler;