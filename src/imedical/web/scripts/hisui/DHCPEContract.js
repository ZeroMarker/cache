
//����	DHCPEContract .js
//����	�����ͬ
//���	DHCPEContract 	
//����	2018.09.03
//������  xy

function BodyLoadHandler()
{
	var obj;
	
	//���� 
	obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_click;
	
	//����
	obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_click;
	
	//�����趨
	obj=document.getElementById("HomeSet");
	if (obj){obj.onclick=HomeSet_Click; }
}

function BAdd_click()
{
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEContractEdit";
	var wwidth=400;
  	var wheight=300;
  	var xposition = (screen.width - wwidth) / 2;
  	var yposition = (screen.height - wheight) / 2;
  	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yesheight='
   	+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
   	;
 	var cwin=window.open(lnk,"_blank",nwin)


	//websys_lu(lnk,false,'width=400,height=310,hisui=true,title=�����ͬά��')

	
}

function BClear_click()
{
	setValueById("ID","");
	setValueById("No","");
	setValueById("Name","");
	setValueById("SignDate","");
	setValueById("StartDate","");
	setValueById("EndDate","");

}




function HomeSet_Click()
{
	var obj,encmeth="",ID="";
	
	obj=document.getElementById("ID");
	if (obj) ID=obj.value;
	
	if (ID=="" || ID==undefined){
		$.messager.alert("��ʾ","��ѡ������õ�����","info");
		return;	
	}
	
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEPreGADM.Home&PGADMDr="+ID+"&Type=C";
	
	/*
	var wwidth=800;
	var wheight=730;
	
	var xposition = (screen.width - wwidth) / 2;
	var yposition = ((screen.height - wheight) / 2)-10;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	//messageShow("","","",lnk)
	var cwin=window.open(lnk,"_blank",nwin) 
*/
   websys_lu(lnk,false,'width=800,height=630,hisui=true,title=��������')

}

var selectrow=-1;
function SelectRowHandler(index,rowdata) {
	selectrow=index;
	if (selectrow=="-1") return;
	if(index==selectrow)
	{
		BClear_click();
		var ID=rowdata.TID;
		obj=document.getElementById("GetInfoClass");
		if (obj) encmeth=obj.value;
		Str=cspRunServerMethod(encmeth,ID);
		var DataArr=Str.split("^"); 
		setValueById("ID",DataArr[0]);
		/*
		setValueById("No",DataArr[1]);
		setValueById("Name",DataArr[2]);
		setValueById("SignDate",DataArr[3]);
		setValueById("Remark",DataArr[4]);
	   */
		
	}else
	{
		SelectedRow=-1;	
	}
	
}


document.body.onload = BodyLoadHandler;