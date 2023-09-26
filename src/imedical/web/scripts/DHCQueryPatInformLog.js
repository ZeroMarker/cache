///DHCQueryPatInformLog 
function DocumentLoadHandler()
{
	var Obj=document.getElementById('RegNo');
	if (Obj) 
	{	
		Obj.onkeydown = CardNoclick;
	}
}

function CardNoclick() 
{
	//return;
	/*if (evtName=='CardNo') 
	{
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}*/
	var key=websys_getKey();
	if (key==13) 
	{
		var Obj=document.getElementById('RegNo');
		CardNo=Obj.value
		///缺少卡类型
		if ((CardNo.length!=8)||(CardNo.length!=12)) {var CardNoLength=12;}
		//var CardNoLength=15   //正式库上要屏蔽这句话 

		if ((CardNo.length<CardNoLength)&&(CardNoLength!=0)) 
		{
			for (var i=(CardNoLength-CardNo.length-1); i>=0; i--)
			{	
				CardNo="0"+CardNo;
			}
			//alert(CardNo);
		}
		var Obj=document.getElementById('RegNo');
		Obj.value=CardNo
		
		BSearch_click();
	
	}
}

document.body.onload = DocumentLoadHandler;
