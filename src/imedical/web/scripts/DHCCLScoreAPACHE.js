
function BodyLoadHandler()
{
	var SCORERowId,ScoreType;
	var obj=document.getElementById('SCORERowId')
	if(obj) SCORERowId=obj.value;
	var obj=document.getElementById('ScoreType')
	if(obj) ScoreType=obj.value;
	obj=document.getElementById('GetScoreAPACHE').value;
    var retval=cspRunServerMethod(obj,SCORERowId,ScoreType);  
	DisPlayScoreAPACHE(retval);
	
	var ObjPaCO2Val=document.getElementById("PaCO2Val");
    if(ObjPaCO2Val) ObjPaCO2Val.onblur=GetOxygenIndexVal;
	var ObjOxygenIndexVal=document.getElementById("OxygenIndexVal");
    if(ObjOxygenIndexVal) ObjOxygenIndexVal.onfocus=GetOxygenIndexVal;

	var ObjChronOrganFailScore1=document.getElementById("ChronOrganFailScore1");
	if(ObjChronOrganFailScore1) ObjChronOrganFailScore1.onclick=ClearAPACHE_click;
	var ObjChronOrganFailScore2=document.getElementById("ChronOrganFailScore2");
	if(ObjChronOrganFailScore2) ObjChronOrganFailScore2.onclick=ClearAPACHE_click;
	var ObjChronOrganFailScore3=document.getElementById("ChronOrganFailScore3");
	if(ObjChronOrganFailScore3) ObjChronOrganFailScore3.onclick=ClearAPACHE_click;
	
	var obj=document.getElementById('AddScoreAPACHE')	
	if(obj) obj.onclick=AddScoreAPACHE_click;
	var obj=document.getElementById('DeleteScoreAPACHE')	
	if(obj) obj.onclick=DeleteScoreAPACHE_click;
	var obj=document.getElementById('PrintBtn')	
	if(obj) obj.onclick=Print_Click;
}

function ClearAPACHE_click()
{	
	var eSrc=window.event.srcElement;
	var Obj=document.getElementById(eSrc.name);
	var ObjChronOrganFailScore1=document.getElementById("ChronOrganFailScore1");
	var ObjChronOrganFailScore2=document.getElementById("ChronOrganFailScore2");
	var ObjChronOrganFailScore3=document.getElementById("ChronOrganFailScore3");
	if((eSrc.name.indexOf("ChronOrganFailScore1")>-1)&&(Obj.checked==true)) 
	{
		ObjChronOrganFailScore2.checked=false;
		ObjChronOrganFailScore3.checked=false;
	}
	if((eSrc.name.indexOf("ChronOrganFailScore2")>-1)&&(Obj.checked==true))
	{
		ObjChronOrganFailScore1.checked=false;
		ObjChronOrganFailScore3.checked=false;
	}
	if((eSrc.name.indexOf("ChronOrganFailScore3")>-1)&&(Obj.checked==true))
	{
		ObjChronOrganFailScore1.checked=false;
		ObjChronOrganFailScore2.checked=false;
	}

}	

function AddScoreAPACHE_click()
{
	var TempScore,MeanArtPressScore,HeartRateScore,RespRateScore,OxygenIndexScore,ArterialPHScore,SodiumScore,PotassiumScore,CreatinineScore,HematocritScore,WhiteBloodCellScore,SerumHCO3Score,GlasgowScore,AgeScore,ChronOrganFailScore;				
	var ObjSCORERowId=document.getElementById("SCORERowId");
	if(ObjSCORERowId) SCORERowId=ObjSCORERowId.value;
	var obj=document.getElementById('ScoreType')
	if(obj) ScoreType=obj.value;

    var ObjTempVal=document.getElementById("TempVal");
    if(ObjTempVal) TempVal=ObjTempVal.value;
    if (TempVal=="")
	{
		alert(t['Null_TempVal']);
		return;
	}
    if((TempVal>=41)||(TempVal<=29.9)) TempScore=4;
    if(((TempVal>=39)&&(TempVal<=40.9))||((TempVal>=30)&&(TempVal<=31.9))) TempScore=3;
    if((TempVal>=32)&&(TempVal<=33.9)) TempScore=2;
    if(((TempVal>=38.5)&&(TempVal<=38.9))||((TempVal>=34)&&(TempVal<=35.9))) TempScore=1;
    if((TempVal>=36)&&(TempVal<=38.4)) TempScore=0;

    var ObjDiaArtPressVal=document.getElementById("DiaArtPressVal");
    if(ObjDiaArtPressVal) DiaArtPressVal=ObjDiaArtPressVal.value;
    var ObjSysArtPressVal=document.getElementById("SysArtPressVal");
    if(ObjSysArtPressVal) SysArtPressVal=ObjSysArtPressVal.value;
    if ((DiaArtPressVal=="")||(SysArtPressVal==""))
	{
		alert(t['Null_DiaorSysArtPressVal']);
		return;
	}
    var MeanArtPressVal=eval(DiaArtPressVal)+(SysArtPressVal-DiaArtPressVal)/3;
    //var ObjMeanArtPresVal=document.getElementById("MeanArtPresVal");
    //if(ObjMeanArtPresVal) MeanArtPresVal=ObjMeanArtPresVal.value

    if((MeanArtPressVal>=160)||(MeanArtPressVal<=49)) MeanArtPressScore=4;
    if((MeanArtPressVal>=130)&&(MeanArtPressVal<=159)) MeanArtPressScore=3;
    if(((MeanArtPressVal>=110)&&(MeanArtPressVal<=129))||((MeanArtPressVal>=50)&&(MeanArtPressVal<=69))) MeanArtPressScore=2;
    if((MeanArtPressVal>=70)&&(MeanArtPressVal<=109)) MeanArtPressScore=0;

    var ObjHeartRateVal=document.getElementById("HeartRateVal");
    if(ObjHeartRateVal) HeartRateVal=ObjHeartRateVal.value;
    if (HeartRateVal=="")
	{
		alert(t['Null_HeartRateVal']);
		return;
	}
    if((HeartRateVal>=180)||(HeartRateVal<=39)) HeartRateScore=4;
    if(((HeartRateVal>=140)&&(HeartRateVal<=179))||((HeartRateVal>=40)&&(HeartRateVal<=54))) HeartRateScore=3;
    if(((HeartRateVal>=110)&&(HeartRateVal<=139))||((HeartRateVal>=55)&&(HeartRateVal<=69))) HeartRateScore=2;
    if((HeartRateVal>=70)&&(HeartRateVal<=109)) HeartRateScore=0;

    var ObjRespRateVal=document.getElementById("RespRateVal");
    if(ObjRespRateVal) RespRateVal=ObjRespRateVal.value;
    if (RespRateVal=="")
	{
		alert(t['Null_RespRateVal']);
		return;
	}
    if((RespRateVal>=50)||(RespRateVal<=5)) RespRateScore=4;
    if((RespRateVal>=35)&&(RespRateVal<=49)) RespRateScore=3;
    if((RespRateVal>=6)&&(RespRateVal<=9)) RespRateScore=2;
    if(((RespRateVal>=25)&&(RespRateVal<=34))||((RespRateVal>=10)&&(RespRateVal<=11))) RespRateScore=1;
    if((RespRateVal>=12)&&(RespRateVal<=24)) RespRateScore=0;
    
    var ObjFiO2Val=document.getElementById("FiO2Val");
    if(ObjFiO2Val) FiO2Val=ObjFiO2Val.value;
    var ObjPaO2Val=document.getElementById("PaO2Val");
    if(ObjPaO2Val) PaO2Val=ObjPaO2Val.value;
    var ObjPaCO2Val=document.getElementById("PaCO2Val");
    if(ObjPaCO2Val) PaCO2Val=ObjPaCO2Val.value;
    var ObjAtmosPressureVal=document.getElementById("AtmosPressureVal");
    if(ObjAtmosPressureVal) AtmosPressureVal=ObjAtmosPressureVal.value;
    var ObjH2OPressureVal=document.getElementById("H2OPressureVal");
    if(ObjH2OPressureVal) H2OPressureVal=ObjH2OPressureVal.value;
    GetOxygenIndexVal();
    var ObjOxygenIndexVal=document.getElementById("OxygenIndexVal");
    if(ObjOxygenIndexVal) OxygenIndexVal=ObjOxygenIndexVal.value;
    if ((FiO2Val=="")||(PaO2Val=="")||(PaCO2Val==""))
	{
		alert(t['Null_FiO2PaO2PaCO2Val']);
		return;
	}
    if(FiO2Val>=50)
    {
		if(OxygenIndexVal>=500) OxygenIndexScore=4;
    	if((OxygenIndexVal>=350)&&(OxygenIndexVal<=499)) OxygenIndexScore=3;
    	if((OxygenIndexVal>=200)&&(OxygenIndexVal<=349)) OxygenIndexScore=2;
    	if(OxygenIndexVal<200) OxygenIndexScore=0;
	}
	if(FiO2Val<50)
    {
		if(PaO2Val<55) OxygenIndexScore=4;
    	if((PaO2Val>=55)&&(PaO2Val<=60)) OxygenIndexScore=3;
    	if((PaO2Val>=61)&&(PaO2Val<=70)) OxygenIndexScore=1;
    	if(PaO2Val>70) OxygenIndexScore=0;
	}
    var ObjArterialPHVal=document.getElementById("ArterialPHVal");
    if(ObjArterialPHVal) ArterialPHVal=ObjArterialPHVal.value;
    if (ArterialPHVal=="")
	{
		alert(t['Null_ArterialPHVal']);
		return;
	}
    if((ArterialPHVal>=7.7)||(ArterialPHVal<7.15)) ArterialPHScore=4;
    if(((ArterialPHVal>=7.6)&&(ArterialPHVal<=7.69))||((ArterialPHVal>=7.15)&&(ArterialPHVal<=7.24))) ArterialPHScore=3;
    if((ArterialPHVal>=7.25)&&(ArterialPHVal<=7.32)) ArterialPHScore=2;
    if((ArterialPHVal>=7.5)&&(ArterialPHVal<=7.59)) ArterialPHScore=1;
    if((ArterialPHVal>=7.33)&&(ArterialPHVal<=7.49)) ArterialPHScore=0;
 
    var ObjSodiumVal=document.getElementById("SodiumVal");
    if(ObjSodiumVal) SodiumVal=ObjSodiumVal.value;
    if (SodiumVal=="")
	{
		alert(t['Null_SodiumVal']);
		return;
	}
    if((SodiumVal>=180)||(SodiumVal<=110)) SodiumScore=4;
    if(((SodiumVal>=160)&&(SodiumVal<=179))||((SodiumVal>=111)&&(SodiumVal<=119))) SodiumScore=3;
    if(((SodiumVal>=155)&&(SodiumVal<=159))||((SodiumVal>=120)&&(SodiumVal<=129))) SodiumScore=2;
    if((SodiumVal>=150)&&(SodiumVal<=154)) SodiumScore=1;
    if((SodiumVal>=130)&&(SodiumVal<=149)) SodiumScore=0;
        
    var ObjPotassiumVal=document.getElementById("PotassiumVal");
    if(ObjPotassiumVal) PotassiumVal=ObjPotassiumVal.value;
    if (PotassiumVal=="")
	{
		alert(t['Null_PotassiumVal']);
		return;
	}
    if((PotassiumVal>=7)||(PotassiumVal<2.5)) PotassiumScore=4;
    if((PotassiumVal>=6)&&(PotassiumVal<=6.9)) PotassiumScore=3;
    if((PotassiumVal>=2.5)&&(PotassiumVal<=2.9)) PotassiumScore=2;
    if((PotassiumVal>=5.5)&&(PotassiumVal<=5.9)) PotassiumScore=1;
    if((PotassiumVal>=3)&&(PotassiumVal<=3.4)) PotassiumScore=1;
    if((PotassiumVal>=3.5)&&(PotassiumVal<=5.4)) PotassiumScore=0;

    var ObjAcuteRenalFailure=document.getElementById("AcuteRenalFailure");
    if(ObjAcuteRenalFailure.checked==true) AcuteRenalFailure="Y";
    else AcuteRenalFailure="N";
    var ObjCreatinineVal=document.getElementById("CreatinineVal");
    if(ObjCreatinineVal) CreatinineVal=ObjCreatinineVal.value;
    if (CreatinineVal=="")
	{
		alert(t['Null_CreatinineVal']);
		return;
	}
    if(CreatinineVal>=3.5) CreatinineScore=4;
    if((CreatinineVal>=2)&&(CreatinineVal<=3.4)) CreatinineScore=3;
    if(((CreatinineVal>=1.5)&&(CreatinineVal<=1.9))||(CreatinineVal<0.6)) CreatinineScore=2;
    if((CreatinineVal>=0.6)&&(CreatinineVal<=1.4)) CreatinineScore=0;
    if (AcuteRenalFailure=="Y") CreatinineScore=CreatinineScore*2;
       
    var ObjHematocritVal=document.getElementById("HematocritVal");
    if(ObjHematocritVal) HematocritVal=ObjHematocritVal.value;
    if (HematocritVal=="")
	{
		alert(t['Null_HematocritVal']);
		return;
	}
    if((HematocritVal>=60)||(HematocritVal<20)) HematocritScore=4;
    if(((HematocritVal>=50)&&(HematocritVal<=59.9))||((HematocritVal>=20)&&(HematocritVal<=29.9))) HematocritScore=2;
    if((HematocritVal>=46)&&(HematocritVal<=49.9)) HematocritScore=1;
    if((HematocritVal>=30)&&(HematocritVal<=45.9)) HematocritScore=0;

    var ObjWhiteBloodCellVal=document.getElementById("WhiteBloodCellVal");
    if(ObjWhiteBloodCellVal) WhiteBloodCellVal=ObjWhiteBloodCellVal.value;
    if (WhiteBloodCellVal=="")
	{
		alert(t['Null_WhiteBloodCellVal']);
		return;
	}
    if((WhiteBloodCellVal>=40)||(WhiteBloodCellVal<1)) WhiteBloodCellScore=4;
    if(((WhiteBloodCellVal>=20)&&(WhiteBloodCellVal<=39.9))||((WhiteBloodCellVal>=1)&&(WhiteBloodCellVal<=2.9))) WhiteBloodCellScore=2;
    if((WhiteBloodCellVal>=15)&&(WhiteBloodCellVal<=19.9)) WhiteBloodCellScore=1;
    if((WhiteBloodCellVal>=3)&&(WhiteBloodCellVal<=14.9)) WhiteBloodCellScore=0;

    var ObjSerumHCO3Val=document.getElementById("SerumHCO3Val");
    if(ObjSerumHCO3Val) SerumHCO3Val=ObjSerumHCO3Val.value;
    /*if (SerumHCO3Val=="")
	{
		alert(t['Null_SerumHCO3Val']);
		return;
	}*/
    if((SerumHCO3Val>=52)||(SerumHCO3Val<15)) SerumHCO3Score=4;
    if(((SerumHCO3Val>=41)&&(SerumHCO3Val<=51.9))||((SerumHCO3Val>=15)&&(SerumHCO3Val<=17.9))) SerumHCO3Score=3;
    if((SerumHCO3Val>=18)&&(SerumHCO3Val<=21.9)) SerumHCO3Score=2;
    if((SerumHCO3Val>=32)&&(SerumHCO3Val<=40.9)) SerumHCO3Score=1;
    if((SerumHCO3Val>=22)&&(SerumHCO3Val<=31.9)) SerumHCO3Score=0;
    
    var ObjGlasgowVal=document.getElementById("GlasgowVal");
    if(ObjGlasgowVal) GlasgowVal=ObjGlasgowVal.value;
    if (GlasgowVal=="")
	{
		alert(t['Null_GlasgowVal']);
		return;
	}
	GlasgowScore=15-GlasgowVal;
    var ObjAgeVal=document.getElementById("AgeVal");
    if(ObjAgeVal) AgeVal=ObjAgeVal.value;
    if (AgeVal=="")
	{
		alert(t['Null_AgeVal']);
		return;
	}
    if(AgeVal<=44) AgeScore=0;
    if((AgeVal>=45)&&(AgeVal<=54)) AgeScore=2;
    if((AgeVal>=55)&&(AgeVal<=64)) AgeScore=3;
    if((AgeVal>=65)&&(AgeVal<=74)) AgeScore=5;
    if(AgeVal>=75) AgeScore=6;
	
    var ObjChronOrganFailScore1=document.getElementById("ChronOrganFailScore1");
	if(ObjChronOrganFailScore1.checked==true) ChronOrganFailScore=5;
	var ObjChronOrganFailScore2=document.getElementById("ChronOrganFailScore2");
	if(ObjChronOrganFailScore2.checked==true) ChronOrganFailScore=2;
	var ObjChronOrganFailScore3=document.getElementById("ChronOrganFailScore3");
	if(ObjChronOrganFailScore3.checked==true) ChronOrganFailScore=0;
    if ((ChronOrganFailScore!=5)&&(ChronOrganFailScore!=2)&&(ChronOrganFailScore!=0))
	{
		alert(t['Null_ChronOrganFailScore']);
		return;
	}
	var APACHEValStr=TempVal+"^"+DiaArtPressVal+"^"+SysArtPressVal+"^"+MeanArtPressVal+"^"+HeartRateVal+"^"+RespRateVal+"^"+FiO2Val+"^"+PaO2Val+"^"+PaCO2Val+"^"+AtmosPressureVal+"^"+H2OPressureVal+"^"+OxygenIndexVal+"^"+ArterialPHVal+"^"+SodiumVal+"^"+PotassiumVal+"^"+AcuteRenalFailure+"^"+CreatinineVal+"^"+HematocritVal+"^"+WhiteBloodCellVal+"^"+SerumHCO3Val+"^"+GlasgowVal+"^"+AgeVal;
	var APACHEScoreStr=TempScore+"^"+MeanArtPressScore+"^"+HeartRateScore+"^"+RespRateScore+"^"+OxygenIndexScore+"^"+ArterialPHScore+"^"+SodiumScore+"^"+PotassiumScore+"^"+CreatinineScore+"^"+HematocritScore+"^"+WhiteBloodCellScore+"^"+SerumHCO3Score+"^"+GlasgowScore+"^"+AgeScore+"^"+ChronOrganFailScore;
	var obj=document.getElementById('AddAPACHE')
	if(obj) 
	{
		var encmeth=obj.value;
	    var resStr=cspRunServerMethod(encmeth,SCORERowId,APACHEValStr,APACHEScoreStr)
	    if (resStr!='0'){
			alert(t['Error']);
			return;
		}	
		else  
		{
			alert(t['Success']);
			obj=document.getElementById('GetScoreAPACHE').value;
    		var retval=cspRunServerMethod(obj,SCORERowId,ScoreType);  
	        DisPlayScoreAPACHE(retval);	
		}
	}
}

function DeleteScoreAPACHE_click()
{
	var SCORERowId;
	var ObjSCORERowId=document.getElementById("SCORERowId");
	if(ObjSCORERowId) SCORERowId=ObjSCORERowId.value;
	var obj=document.getElementById('DeleteAPACHE')
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

function DisPlayScoreAPACHE(Str) 
{
	var s=Str.split("^");
	//alert(s.length);
	if (s.length<2) 
	{
		var obj=document.getElementById('SCORERowId')
		if(obj) SCORERowId=obj.value;
    	var obj=document.getElementById("GetScoreAPACHE").value;
    	var retStr=cspRunServerMethod(obj,SCORERowId,"GLASG");
    	var GlasgowVal=retStr.split("^")[0]; 
    	var ObjGlasgowVal=document.getElementById("GlasgowVal");
    	if(ObjGlasgowVal) ObjGlasgowVal.value=GlasgowVal;
		return;
	}
	var APACHEScore=s[0];
	var TempVal=s[1];
	var DiaArtPressVal=s[2];
	var SysArtPressVal=s[3];
	var MeanArtPresVal=s[4];
	var HeartRateVal=s[5];
    var RespRateVal=s[6];
    var FiO2Val=s[7];
    var PaO2Val=s[8];
    var PaCO2Val=s[9];
    var AtmosPressureVal=s[10];
    var H2OPressureVal=s[11];
    var OxygenIndexVal=s[12];
    var ArterialPHVal=s[13];
    var SodiumVal=s[14];
    var PotassiumVal=s[15];
    var AcuteRenalFailure=s[16];
    var CreatinineVal=s[17];
    var HematocritVal=s[18];
    var WhiteBloodCellVal=s[19];
    var SerumHCO3Val=s[20];
    var GlasgowVal=s[21];
    var AgeVal=s[22];
    var ChronOrganFailScore=s[23];       	

    var ObjAPACHEScore=document.getElementById("APACHEScore");
    if(ObjAPACHEScore) ObjAPACHEScore.value=APACHEScore;
    var ObjTempVal=document.getElementById("TempVal");
    if(ObjTempVal) ObjTempVal.value=TempVal;
    var ObjDiaArtPressVal=document.getElementById("DiaArtPressVal");
    if(ObjDiaArtPressVal) ObjDiaArtPressVal.value=DiaArtPressVal;
    var ObjSysArtPressVal=document.getElementById("SysArtPressVal");
    if(ObjSysArtPressVal) ObjSysArtPressVal.value=SysArtPressVal;
    var ObjMeanArtPressVal=document.getElementById("MeanArtPressVal");
    if(ObjMeanArtPressVal) ObjMeanArtPressVal.value=MeanArtPressVal;
    var ObjHeartRateVal=document.getElementById("HeartRateVal");
    if(ObjHeartRateVal) ObjHeartRateVal.value=HeartRateVal;
    var ObjRespRateVal=document.getElementById("RespRateVal");
    if(ObjRespRateVal) ObjRespRateVal.value=RespRateVal;
    var ObjFiO2Val=document.getElementById("FiO2Val");
    if(ObjFiO2Val) ObjFiO2Val.value=FiO2Val;
    var ObjPaO2Val=document.getElementById("PaO2Val");
    if(ObjPaO2Val) ObjPaO2Val.value=PaO2Val;
    var ObjPaCO2Val=document.getElementById("PaCO2Val");
    if(ObjPaCO2Val) ObjPaCO2Val.value=PaCO2Val;
    var ObjAtmosPressureVal=document.getElementById("AtmosPressureVal");
    if(ObjAtmosPressureVal) ObjAtmosPressureVal.value=AtmosPressureVal;
    var ObjH2OPressureVal=document.getElementById("H2OPressureVal");
    if(ObjH2OPressureVal) ObjH2OPressureVal.value=H2OPressureVal;
    var ObjOxygenIndexVal=document.getElementById("OxygenIndexVal");
    if(ObjOxygenIndexVal) ObjOxygenIndexVal.value=OxygenIndexVal;
    var ObjArterialPHVal=document.getElementById("ArterialPHVal");
    if(ObjArterialPHVal) ObjArterialPHVal.value=ArterialPHVal;
    var ObjSodiumVal=document.getElementById("SodiumVal");
    if(ObjSodiumVal) ObjSodiumVal.value=SodiumVal;
    var ObjPotassiumVal=document.getElementById("PotassiumVal");
    if(ObjPotassiumVal) ObjPotassiumVal.value=PotassiumVal;
    var ObjAcuteRenalFailure=document.getElementById("AcuteRenalFailure");
    if((ObjAcuteRenalFailure)&&(AcuteRenalFailure=="Y")) ObjAcuteRenalFailure.checked=true;
    var ObjCreatinineVal=document.getElementById("CreatinineVal");
    if(ObjCreatinineVal) ObjCreatinineVal.value=CreatinineVal;
    var ObjHematocritVal=document.getElementById("HematocritVal");
    if(ObjHematocritVal) ObjHematocritVal.value=HematocritVal;
    var ObjWhiteBloodCellVal=document.getElementById("WhiteBloodCellVal");
    if(ObjWhiteBloodCellVal) ObjWhiteBloodCellVal.value=WhiteBloodCellVal;
    var ObjSerumHCO3Val=document.getElementById("SerumHCO3Val");
    if(ObjSerumHCO3Val) ObjSerumHCO3Val.value=SerumHCO3Val;
    var ObjAgeVal=document.getElementById("AgeVal");
    if(ObjAgeVal) ObjAgeVal.value=AgeVal;
    var ObjGlasgowVal=document.getElementById("GlasgowVal");
    if(ObjGlasgowVal) ObjGlasgowVal.value=GlasgowVal;
    var ObjChronOrganFailScore1=document.getElementById("ChronOrganFailScore1");
    var ObjChronOrganFailScore2=document.getElementById("ChronOrganFailScore2");
        switch(ChronOrganFailScore)
        {
	        case "5":
	        	ObjChronOrganFailScore1.checked=true;
	        	break;
	        case "2":
	        	ObjChronOrganFailScore2.checked=true;
	        	break;
	    }
}

function GetOxygenIndexVal()
{	
    var RespQuot=0.8;
    var ObjFiO2Val=document.getElementById("FiO2Val");
    if(ObjFiO2Val) FiO2Val=ObjFiO2Val.value;
    var ObjPaO2Val=document.getElementById("PaO2Val");
    if(ObjPaO2Val) PaO2Val=ObjPaO2Val.value;
    var ObjPaCO2Val=document.getElementById("PaCO2Val");
    if(ObjPaCO2Val) PaCO2Val=ObjPaCO2Val.value;
    var ObjAtmosPressureVal=document.getElementById("AtmosPressureVal");
    if(ObjAtmosPressureVal) AtmosPressureVal=ObjAtmosPressureVal.value;
    var ObjH2OPressureVal=document.getElementById("H2OPressureVal");
    if(ObjH2OPressureVal) H2OPressureVal=ObjH2OPressureVal.value;
    var ObjOxygenIndexVal=document.getElementById("OxygenIndexVal");
    OxygenIndexVal=((AtmosPressureVal - H2OPressureVal)*FiO2Val/100 - (PaCO2Val/RespQuot)) - PaO2Val; 
    if(ObjOxygenIndexVal) ObjOxygenIndexVal.value=OxygenIndexVal;
}
function GetFilePath() //+wxl 091028
{   var GetPath=document.getElementById("GetPath").value;
    var path=cspRunServerMethod(GetPath);
    return path
}
function Print_Click()  //+wxl 091028
{
    var xlsExcel,xlsSheet,xlsBook;
    var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
    var LeftFooter,CenterFooter,RightFooter;
    var path,fileName;
	//alert(String.fromCharCode(9632)); //8730//9633
	//return;
    path = GetFilePath();
    fileName=path + "APACHEIIScore.xls";
    xlsExcel = new ActiveXObject("Excel.Application");
    xlsBook = xlsExcel.Workbooks.Add(fileName);
    xlsSheet = xlsBook.ActiveSheet;
    xlsTop=1;xlsLeft=1;
    
    var ctloc="",PatAge="",PatSex="",PatName="",medCardNo="",MainDiag1="",MainDiag2="",ComDiag1="",ComDiag2="",ScoreTime="",GlasgowScore="",APACHEScore="";
    var objSCORERowId=document.getElementById("SCORERowId");
	if (objSCORERowId.value=="") return;
 	var PatInfo=document.getElementById("GetPatInfo");
 	var objEpisodeID=parent.frames["RPtop"].document.getElementById("EpisodeID");
	if (PatInfo){
    	var PatInfoStr=cspRunServerMethod(PatInfo.value,"^"+objEpisodeID.value);
		var PatInfoArr=PatInfoStr.split("^");
		//alert(PatInfoArr);
		ctloc=PatInfoArr[1];
		PatSex=PatInfoArr[3] 
		PatName=PatInfoArr[4];
		PatAge=PatInfoArr[7];
		medCardNo=PatInfoArr[12];
	}
	var objGetDiag=document.getElementById("GetDiag");
	if (objGetDiag){
    	var str=cspRunServerMethod(objGetDiag.value,objEpisodeID.value);
    	var arr=str.split(",");
    	//alert(arr);
    	MainDiag1=arr[0];
    	MainDiag2=arr[1];
	} 
	var objGetAPACHEScore=document.getElementById("GetAPACHEScore");
	if (objGetAPACHEScore){
    	var APACHEScoreStr=cspRunServerMethod(objGetAPACHEScore.value,objSCORERowId.value);
    	var arr=APACHEScoreStr.split("!")
    	//alert(arr)
    	ScoreTime=arr[0];
    	GlasgowScore=arr[1].split("^");
    	if (arr.length>2) APACHEScore=arr[2].split("^");
	}
	var row=2;
	xlsSheet.cells(row,2)=ctloc;
    xlsSheet.cells(row,9)=medCardNo;
    row=row+1;
    xlsSheet.cells(row,1)=PatName;
    if (PatSex=="ÄÐ") xlsSheet.cells(row,2)=String.fromCharCode(9632)+" "+PatSex;
    if (PatSex=="Å®") xlsSheet.cells(row,3)=String.fromCharCode(9632)+" "+PatSex;
    xlsSheet.cells(row,4)=PatAge;
    xlsSheet.cells(row,6)=ScoreTime;
    row=row+1;
    xlsSheet.cells(row,4)=MainDiag1;
    xlsSheet.cells(row+1,4)=MainDiag2;
    xlsSheet.cells(row+2,4)=ComDiag2;
    xlsSheet.cells(row+3,4)=ComDiag2;
   	row=row+6;
   	if (APACHEScore!="") xlsSheet.cells(row,11)=APACHEScore[16];
   	row=row+3;
   	if (GlasgowScore!="") {
	   	xlsSheet.cells(row,11)=GlasgowScore[0];
	   	//if (GlasgowScore[1]!="") xlsSheet.cells(row+4-GlasgowScore[1],3)=(4-GlasgowScore[1])+" "+String.fromCharCode(9632);
   		//if (GlasgowScore[2]!="") xlsSheet.cells(row+5-GlasgowScore[2],6)=(5-GlasgowScore[2])+" "+String.fromCharCode(9632);
   		//if (GlasgowScore[3]!="") xlsSheet.cells(row+6-GlasgowScore[3],9)=(6-GlasgowScore[3])+" "+String.fromCharCode(9632);
 	   	if (GlasgowScore[1]!="") xlsSheet.cells(row+4-GlasgowScore[1],3)=GlasgowScore[1]+" "+String.fromCharCode(9632);
   		if (GlasgowScore[2]!="") xlsSheet.cells(row+5-GlasgowScore[2],6)=GlasgowScore[2]+" "+String.fromCharCode(9632);
   		if (GlasgowScore[3]!="") xlsSheet.cells(row+6-GlasgowScore[3],9)=GlasgowScore[3]+" "+String.fromCharCode(9632);  	
   	}
   	row=row+9;
   	if (APACHEScore!=""){
		//APACHEScore_"^"_TempScore_"^"_MeanArtPresScore_"^"_HeartRateScore_"^"_RespRateScore_"^"_FiO2Val_"^"_OxygenIndexScore_"^"_ArterialPHScore_"^"_SodiumScore_"^"_PotassiumScore_"^"_AcuteRenalFailure_"^"_CreatinineScore_"^"_HematocritScore_"^"_WhiteBloodCellScore_"^"_SerumHCO3Score_"^"_GlasgowScore_"^"_AgeScore_"^"_ChronOrganFailScore		
		//0					1				2					3					4				5			6						7					8				9				10						11					12						13						14					15			16				17					
		xlsSheet.cells(row,11)=APACHEScore[1];
		xlsSheet.cells(row+1,11)=APACHEScore[2];
		xlsSheet.cells(row+2,11)=APACHEScore[3];
		xlsSheet.cells(row+3,11)=APACHEScore[4];
		xlsSheet.cells(row+4,11)=APACHEScore[6];
		xlsSheet.cells(row+5,11)=APACHEScore[7];
		xlsSheet.cells(row+6,11)=APACHEScore[8];
		xlsSheet.cells(row+7,11)=APACHEScore[9];
		xlsSheet.cells(row+8,11)=APACHEScore[11];
		xlsSheet.cells(row+9,11)=APACHEScore[13];
		xlsSheet.cells(row+10,11)=APACHEScore[12];
		xlsSheet.cells(row+11,11)=APACHEScore[14];
		xlsSheet.cells(row+12,11)=APACHEScore[18];
   	}
	row=row+17;
	if (APACHEScore!="") xlsSheet.cells(row,11)=APACHEScore[17];
	row=row+7;
	if (APACHEScore!="") xlsSheet.cells(row,3)=APACHEScore[0];
    xlsSheet.PrintOut
    xlsSheet = null;
    xlsBook.Close(savechanges=false)
    xlsBook = null;
    xlsExcel.Quit();
    xlsExcel = null;
}
document.body.onload = BodyLoadHandler;