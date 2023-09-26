
function BodyLoadHandler()
{
	var SCORERowId,ScoreType;
	var obj=document.getElementById('SCORERowId')
	if(obj) SCORERowId=obj.value;
	var obj=document.getElementById('ScoreType')
	if(obj) ScoreType=obj.value;
	obj=document.getElementById('GetScoreISS').value;
    var retval=cspRunServerMethod(obj,SCORERowId,ScoreType);
	DisPlayScoreISS(retval);
	var ObjHeadNeckScore1=document.getElementById("HeadNeckScore1");
	if(ObjHeadNeckScore1) ObjHeadNeckScore1.onclick=ClearISS_click;
	var ObjHeadNeckScore2=document.getElementById("HeadNeckScore2");
	if(ObjHeadNeckScore2) ObjHeadNeckScore2.onclick=ClearISS_click;
	var ObjHeadNeckScore3=document.getElementById("HeadNeckScore3");
	if(ObjHeadNeckScore3) ObjHeadNeckScore3.onclick=ClearISS_click;
	var ObjHeadNeckScore4=document.getElementById("HeadNeckScore4");
	if(ObjHeadNeckScore4) ObjHeadNeckScore4.onclick=ClearISS_click;
	var ObjHeadNeckScore5=document.getElementById("HeadNeckScore5");    
	if(ObjHeadNeckScore5) ObjHeadNeckScore5.onclick=ClearISS_click;
	var ObjFaceScore1=document.getElementById("FaceScore1");
	if(ObjFaceScore1) ObjFaceScore1.onclick=ClearISS_click;
	var ObjFaceScore2=document.getElementById("FaceScore2");
	if(ObjFaceScore2) ObjFaceScore2.onclick=ClearISS_click;
	var ObjFaceScore3=document.getElementById("FaceScore3");
	if(ObjFaceScore3) ObjFaceScore3.onclick=ClearISS_click;
	var ObjChestScore1=document.getElementById("ChestScore1");
	if(ObjChestScore1) ObjChestScore1.onclick=ClearISS_click;
	var ObjChestScore2=document.getElementById("ChestScore2");
	if(ObjChestScore2) ObjChestScore2.onclick=ClearISS_click;
	var ObjChestScore3=document.getElementById("ChestScore3");
	if(ObjChestScore3) ObjChestScore3.onclick=ClearISS_click;
	var ObjChestScore4=document.getElementById("ChestScore4");
	if(ObjChestScore4) ObjChestScore4.onclick=ClearISS_click;
	var ObjChestScore5=document.getElementById("ChestScore5");
	if(ObjChestScore5) ObjChestScore5.onclick=ClearISS_click;
    var ObjAbdomenScore1=document.getElementById("AbdomenScore1");
	if(ObjAbdomenScore1) ObjAbdomenScore1.onclick=ClearISS_click;
	var ObjAbdomenScore2=document.getElementById("AbdomenScore2");
	if(ObjAbdomenScore2) ObjAbdomenScore2.onclick=ClearISS_click;
	var ObjAbdomenScore3=document.getElementById("AbdomenScore3");
	if(ObjAbdomenScore3) ObjAbdomenScore3.onclick=ClearISS_click;
	var ObjAbdomenScore4=document.getElementById("AbdomenScore4");
	if(ObjAbdomenScore4) ObjAbdomenScore4.onclick=ClearISS_click;
	var ObjAbdomenScore5=document.getElementById("AbdomenScore5");
	if(ObjAbdomenScore5) ObjAbdomenScore5.onclick=ClearISS_click;
	var ObjExtremityScore1=document.getElementById("ExtremityScore1");
	if(ObjExtremityScore1) ObjExtremityScore1.onclick=ClearISS_click;
	var ObjExtremityScore2=document.getElementById("ExtremityScore2");
	if(ObjExtremityScore2) ObjExtremityScore2.onclick=ClearISS_click;
	var ObjExtremityScore3=document.getElementById("ExtremityScore3");
	if(ObjExtremityScore3) ObjExtremityScore3.onclick=ClearISS_click;
	var ObjExtremityScore4=document.getElementById("ExtremityScore4");
	if(ObjExtremityScore4) ObjExtremityScore4.onclick=ClearISS_click;
	var ObjExtremityScore5=document.getElementById("ExtremityScore5");
	if(ObjExtremityScore5) ObjExtremityScore5.onclick=ClearISS_click;
	var ObjExternalScore1=document.getElementById("ExternalScore1");
	if(ObjExternalScore1) ObjExternalScore1.onclick=ClearISS_click;
	var ObjExternalScore2=document.getElementById("ExternalScore2");
	if(ObjExternalScore2) ObjExternalScore2.onclick=ClearISS_click;
	var ObjExternalScore3=document.getElementById("ExternalScore3");
	if(ObjExternalScore3) ObjExternalScore3.onclick=ClearISS_click;
	var ObjExternalScore4=document.getElementById("ExternalScore4");
	if(ObjExternalScore4) ObjExternalScore4.onclick=ClearISS_click;
	var ObjExternalScore5=document.getElementById("ExternalScore5");
	if(ObjExternalScore5) ObjExternalScore5.onclick=ClearISS_click;

	var obj=document.getElementById('AddScoreISS')	
	if(obj) obj.onclick=AddScoreISS_click;
	var obj=document.getElementById('DeleteScoreISS')	
	if(obj) obj.onclick=DeleteScoreISS_click;

}
function ClearISS_click()
{	
	var eSrc=window.event.srcElement;
	var Obj=document.getElementById(eSrc.name);
	if((eSrc.name.indexOf("HeadNeckScore")>-1)&&(Obj.checked==true)) ClearISS(eSrc.name,"HeadNeckScore");
	if((eSrc.name.indexOf("FaceScore")>-1)&&(Obj.checked==true)) ClearISS(eSrc.name,"FaceScore");
	if((eSrc.name.indexOf("ChestScore")>-1)&&(Obj.checked==true)) ClearISS(eSrc.name,"ChestScore");
	if((eSrc.name.indexOf("AbdomenScore")>-1)&&(Obj.checked==true)) ClearISS(eSrc.name,"AbdomenScore");
	if((eSrc.name.indexOf("ExtremityScore")>-1)&&(Obj.checked==true)) ClearISS(eSrc.name,"ExtremityScore");
	if((eSrc.name.indexOf("ExternalScore")>-1)&&(Obj.checked==true)) ClearISS(eSrc.name,"ExternalScore");

}	
function ClearISS(eSrcStr,Str)
{
	for(i=1;i<6;i++)
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

function AddScoreISS_click()
{
	var HeadNeckScore,FaceScore,ChestScore,AbdomenScore,ExtremityScore,ExternalScore;
	var ObjSCORERowId=document.getElementById("SCORERowId");
	if(ObjSCORERowId) SCORERowId=ObjSCORERowId.value;
	var obj=document.getElementById('ScoreType')
	if(obj) ScoreType=obj.value;
	var ObjHeadNeckScore1=document.getElementById("HeadNeckScore1");
	if(ObjHeadNeckScore1.checked==true) HeadNeckScore=1;	
	var ObjHeadNeckScore2=document.getElementById("HeadNeckScore2");
	if(ObjHeadNeckScore2.checked==true) HeadNeckScore=2;	
	var ObjHeadNeckScore3=document.getElementById("HeadNeckScore3");
	if(ObjHeadNeckScore3.checked==true) HeadNeckScore=3;	
	var ObjHeadNeckScore4=document.getElementById("HeadNeckScore4");
	if(ObjHeadNeckScore4.checked==true) HeadNeckScore=4;	
	var ObjHeadNeckScore5=document.getElementById("HeadNeckScore5");
	if(ObjHeadNeckScore5.checked==true) HeadNeckScore=5;	
    if(HeadNeckScore!=1&&HeadNeckScore!=2&&HeadNeckScore!=3&&HeadNeckScore!=4&&HeadNeckScore!=5) 
    {
	    alert(t['NULL_HeadNeckScore']);
        return;
    }
    
	var ObjFaceScore1=document.getElementById("FaceScore1");
	if(ObjFaceScore1.checked==true) FaceScore=1;	
	var ObjFaceScore2=document.getElementById("FaceScore2");
	if(ObjFaceScore2.checked==true) FaceScore=2;	
	var ObjFaceScore3=document.getElementById("FaceScore3");
	if(ObjFaceScore3.checked==true) FaceScore=3;			
    if(FaceScore!=1&&FaceScore!=2&&FaceScore!=3) 
    {
	    alert(t['NULL_FaceScore']);
        return;
    }

	var ObjChestScore1=document.getElementById("ChestScore1");
	if(ObjChestScore1.checked==true) ChestScore=1;	
	var ObjChestScore2=document.getElementById("ChestScore2");
	if(ObjChestScore2.checked==true) ChestScore=2;		
	var ObjChestScore3=document.getElementById("ChestScore3");
	if(ObjChestScore3.checked==true) ChestScore=3;	
	var ObjChestScore4=document.getElementById("ChestScore4");
	if(ObjChestScore4.checked==true) ChestScore=4;	
	var ObjChestScore5=document.getElementById("ChestScore5");
	if(ObjChestScore5.checked==true) ChestScore=5;	
    
    if(ChestScore!=1&&ChestScore!=2&&ChestScore!=3&&ChestScore!=4&&ChestScore!=5) 
    {
	    alert(t['NULL_ChestScore']);
        return;
    }

	var ObjAbdomenScore1=document.getElementById("AbdomenScore1");
	if(ObjAbdomenScore1.checked==true) AbdomenScore=1;	
	var ObjAbdomenScore2=document.getElementById("AbdomenScore2");
	if(ObjAbdomenScore2.checked==true) AbdomenScore=2;	
	var ObjAbdomenScore3=document.getElementById("AbdomenScore3");
	if(ObjAbdomenScore3.checked==true) AbdomenScore=3;	
	var ObjAbdomenScore4=document.getElementById("AbdomenScore4");
	if(ObjAbdomenScore4.checked==true) AbdomenScore=4;	
	var ObjAbdomenScore5=document.getElementById("AbdomenScore5");
	if(ObjAbdomenScore5.checked==true) AbdomenScore=5;	
    if(AbdomenScore!=1&&AbdomenScore!=2&&AbdomenScore!=3&&AbdomenScore!=4&&AbdomenScore!=5) 
    {
	    alert(t['NULL_AbdomenScore']);
        return;
    }

	var ObjExtremityScore1=document.getElementById("ExtremityScore1");
	if(ObjExtremityScore1.checked==true) ExtremityScore=1;	
	var ObjExtremityScore2=document.getElementById("ExtremityScore2");
	if(ObjExtremityScore2.checked==true) ExtremityScore=2;
	var ObjExtremityScore3=document.getElementById("ExtremityScore3");
	if(ObjExtremityScore3.checked==true) ExtremityScore=3;
	var ObjExtremityScore4=document.getElementById("ExtremityScore4");
	if(ObjExtremityScore4.checked==true) ExtremityScore=4;			
	var ObjExtremityScore5=document.getElementById("ExtremityScore5");
	if(ObjExtremityScore5.checked==true) ExtremityScore=5;	
    if(ExtremityScore!=1&&ExtremityScore!=2&&ExtremityScore!=3&&ExtremityScore!=4&&ExtremityScore!=5) 
    {
	    alert(t['NULL_ExtremityScore']);
        return;
    }
	var ObjExternalScore1=document.getElementById("ExternalScore1");
	if(ObjExternalScore1.checked==true) ExternalScore=1;			
	var ObjExternalScore2=document.getElementById("ExternalScore2");
	if(ObjExternalScore2.checked==true) ExternalScore=2;
	var ObjExternalScore3=document.getElementById("ExternalScore3");
	if(ObjExternalScore3.checked==true) ExternalScore=3;
	var ObjExternalScore4=document.getElementById("ExternalScore4");
	if(ObjExternalScore4.checked==true) ExternalScore=4;
	var ObjExternalScore5=document.getElementById("ExternalScore5");
	if(ObjExternalScore5.checked==true) ExternalScore=5;
    if(ExternalScore!=1&&ExternalScore!=2&&ExternalScore!=3&&ExternalScore!=4&&ExternalScore!=5) 
    {
	    alert(t['NULL_ExternalScore']);
        return;
    }

	var obj=document.getElementById('AddISS')
	if(obj) 
	{
		var encmeth=obj.value;
	    var resStr=cspRunServerMethod(encmeth,SCORERowId,HeadNeckScore,FaceScore,ChestScore,AbdomenScore,ExtremityScore,ExternalScore)
	    if (resStr!='0'){
			alert(t['Error']);
			return;
		}	
		else  
		{
			alert(t['Success']);
			obj=document.getElementById('GetScoreISS').value;
    		var retval=cspRunServerMethod(obj,SCORERowId,ScoreType);
			DisPlayScoreISS(retval);
		}
	}
}

function DeleteScoreISS_click()
{
	var SCORERowId,ISSRowId;
	var ObjSCORERowId=document.getElementById("SCORERowId");
	if(ObjSCORERowId) SCORERowId=ObjSCORERowId.value;
	var obj=document.getElementById('DeleteISS')
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

function DisPlayScoreISS(Str)
{
	var s=Str.split("^");
	var ISSScore=s[0];
	var HeadNeckScore=s[1];
	var FaceScore=s[2];
	var ChestScore=s[3];
	var AbdomenScore=s[4];
	var ExtremityScore=s[5];
	var ExternalScore=s[6];
	
	var ObjISSScore=document.getElementById("ISSScore");
    if(ObjISSScore) ObjISSScore.value=ISSScore;
	var ObjHeadNeckScore1=document.getElementById("HeadNeckScore1");
	var ObjHeadNeckScore2=document.getElementById("HeadNeckScore2");
	var ObjHeadNeckScore3=document.getElementById("HeadNeckScore3");
	var ObjHeadNeckScore4=document.getElementById("HeadNeckScore4");
	var ObjHeadNeckScore5=document.getElementById("HeadNeckScore5");    
	var ObjFaceScore1=document.getElementById("FaceScore1");
	var ObjFaceScore2=document.getElementById("FaceScore2");
	var ObjFaceScore3=document.getElementById("FaceScore3");
	var ObjChestScore1=document.getElementById("ChestScore1");
	var ObjChestScore2=document.getElementById("ChestScore2");
	var ObjChestScore3=document.getElementById("ChestScore3");
	var ObjChestScore4=document.getElementById("ChestScore4");
	var ObjChestScore5=document.getElementById("ChestScore5");
    var ObjAbdomenScore1=document.getElementById("AbdomenScore1");
	var ObjAbdomenScore2=document.getElementById("AbdomenScore2");
	var ObjAbdomenScore3=document.getElementById("AbdomenScore3");
	var ObjAbdomenScore4=document.getElementById("AbdomenScore4");
	var ObjAbdomenScore5=document.getElementById("AbdomenScore5");
	var ObjExtremityScore1=document.getElementById("ExtremityScore1");
	var ObjExtremityScore2=document.getElementById("ExtremityScore2");
	var ObjExtremityScore3=document.getElementById("ExtremityScore3");
	var ObjExtremityScore4=document.getElementById("ExtremityScore4");
	var ObjExtremityScore5=document.getElementById("ExtremityScore5");
	var ObjExternalScore1=document.getElementById("ExternalScore1");
	var ObjExternalScore2=document.getElementById("ExternalScore2");
	var ObjExternalScore3=document.getElementById("ExternalScore3");
	var ObjExternalScore4=document.getElementById("ExternalScore4");
	var ObjExternalScore5=document.getElementById("ExternalScore5");
	
	    switch(HeadNeckScore)
        {
	        case "1":
	        	ObjHeadNeckScore1.checked=true;
	        	break;
	        case "2":
	        	ObjHeadNeckScore2.checked=true;
	        	break;
	        case "3":
	        	ObjHeadNeckScore3.checked=true;
	        	break;
	        case "4":
	        	ObjHeadNeckScore4.checked=true;
	        	break;
	        case "5":
	        	ObjHeadNeckScore5.checked=true;
	        	break;
		}
	        
	    switch(FaceScore)
        {
	        case "1":
	        	ObjFaceScore1.checked=true;
	        	break;
	        case "2":
	        	ObjFaceScore2.checked=true;
	        	break;
	        case "3":
	        	ObjFaceScore3.checked=true;
	        	break;
	    }
	    
	    switch(ChestScore)
        {
	        case "1":
	        	ObjChestScore1.checked=true;
	        	break;
	        case "2":
	        	ObjChestScore2.checked=true;
	        	break;
	        case "3":
	        	ObjChestScore3.checked=true;
	        	break;
	        case "4":
	        	ObjChestScore4.checked=true;
	        	break;
	        case "5":
	        	ObjChestScore5.checked=true;
	        	break;
		}
	    
	    switch(AbdomenScore)
        {
	        case "1":
	        	ObjAbdomenScore1.checked=true;
	        	break;
	        case "2":
	        	ObjAbdomenScore2.checked=true;
	        	break;
	        case "3":
	        	ObjAbdomenScore3.checked=true;
	        	break;
	        case "4":
	        	ObjAbdomenScore4.checked=true;
	        	break;
	        case "5":
	        	ObjAbdomenScore5.checked=true;
	        	break;

	        	
	        	
	    }
	    
	    switch(ExtremityScore)
        {
	        case "1":
	        	ObjExtremityScore1.checked=true;
	        	break;
	        case "2":
	        	ObjExtremityScore2.checked=true;
	        	break;
	        case "3":
	        	ObjExtremityScore3.checked=true;
	        	break;
	        case "4":
	        	ObjExtremityScore4.checked=true;
	        	break;
	        case "5":
	        	ObjExtremityScore5.checked=true;
	        	break;    	
	    }
	    switch(ExternalScore)
        {
	        case "1":
	        	ObjExternalScore1.checked=true;
	        	break;
	        case "2":
	        	ObjExternalScore2.checked=true;
	        	break;
	        case "3":
	        	ObjExternalScore3.checked=true;
	        	break;
	        case "4":
	        	ObjExternalScore4.checked=true;
	        	break;
	        case "5":
	        	ObjExternalScore5.checked=true;
	        	break;
        }	            	 
}



document.body.onload = BodyLoadHandler;