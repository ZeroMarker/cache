
function BodyLoadHandler()
{
		var obj=document.getElementById('Name');
		if(obj.value=="") 
		{	
			obj.onfocus=SetData;
		}
    var obj=document.getElementById('Save');
    if(obj) obj.onclick=SaveData;

    var obj=document.getElementById('Delete');
    if(obj) obj.onclick=DeleteData;	
		
		Init();
		
 		var obj=document.getElementById('InputInfo');
	  if(obj.value!="") SetRepInfo();
}

function DeleteData()
{
	var ResDate="",WardId="",BedId="";
	
	ResDate=GetValues("ResDate");
	WardId=GetValues("WardId");
	BedId=GetValues("BedId");
	
	if((ResDate=="")||(WardId=="")||(BedId=="")) return;
	var ret=confirm(t['DeleteYOrN']);
	if(ret==false) return;
	
	DataList=ResDate+"^"+WardId+"^"+BedId;
	var obj=document.getElementById("MethodDeleteRep");
	if (obj) {var encmeth=obj.value} else {var encmeth=''}
	var ret=cspRunServerMethod(encmeth,DataList);
	if(ret==-1) 
	
	{	
		alert(t['DeleteFalse']);
    return;
  }
	 lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCMedICURes";
  parent.frames[1].location.href=lnk;	
	
	
}
function SetRepInfo()
{
	var DataList="";
	var obj=document.getElementById('InputInfo');
	if(obj) Str=obj.value;
	tmp=Str.split("^");
	DataList=tmp[0]+"^"+tmp[1]+"^"+tmp[2];
	
  if(DataList=="") return;
	var obj=document.getElementById("MethodCheckRep");
	if (obj) {var encmeth=obj.value} else {var encmeth=''}
	var ret=cspRunServerMethod(encmeth,DataList);
	if(ret!=-1)
	{
		res=1;
		var obj=document.getElementById('ResDate');
		if(obj) obj.value=tmp[3];
		SetRepData(ret);
	}
	var obj=document.getElementById('cUpdate');
	if(obj.value=="N")
	{
		var obj=document.getElementById('Save');
		obj.style.display="none";
		var obj=document.getElementById('Delete');
		obj.style.display="none";
		var obj=document.getElementById('Clear');
		obj.style.display="none";
		
	}
	
}

function CheckRepDet()
{
	var ResDate="",WardId="",BedId="",DataList="",res=-1;
	ResDate=GetValues("ResDate");
	WardId=GetValues("WardId");
	BedId=GetValues("BedId");
	if((ResDate=="")||(WardId=="")||(BedId=="")) return;
	DataList=ResDate+"^"+WardId+"^"+BedId;
	var obj=document.getElementById("MethodCheckRep");
	if (obj) {var encmeth=obj.value} else {var encmeth=''}
	var ret=cspRunServerMethod(encmeth,DataList);
	if(ret!=-1)
	{
		res=1;
		SetRepData(ret);
	}
	return res;

}

function SetRepData(Str)
{
	var tmp=Str.split("^");

	SetValues("BasesetDiag",tmp[0]);
	gSetListValue("BloodInf",tmp[1]);
	gSetListValue("CtlocNum",tmp[2]);
	SetValues("CulResNum11ID",tmp[3].split("~")[0]); 
	SetValues("CulResNum11",tmp[3].split("~")[1]); 
	SetValues("CulResNum12ID",tmp[4].split("~")[0]);
	SetValues("CulResNum12",tmp[4].split("~")[1]);
	SetValues("CulResNum21ID",tmp[5].split("~")[0]);
	SetValues("CulResNum21",tmp[5].split("~")[1]);
	SetValues("CulResNum22ID",tmp[6].split("~")[0]);
	SetValues("CulResNum22",tmp[6].split("~")[1]);
	SetValues("BedId",tmp[7].split("~")[0]);
	SetValues("CurrentBed",tmp[7].split("~")[1]);
	SetValues("WardId",tmp[8].split("~")[0]);
	SetValues("CurrentWard",tmp[8].split("~")[1]);
	gSetListValue("DeepVeinPipe",tmp[9]);
	SetValues("ForBed",tmp[10]);
	SetValues("InfBacilliNum1ID",tmp[11].split("~")[0]);
	SetValues("InfBacilliNum1",tmp[11].split("~")[1]);
	SetValues("InfBacilliNum2ID",tmp[12].split("~")[0]);
	SetValues("InfBacilliNum2",tmp[12].split("~")[1]);
	SetValues("InfNum",tmp[13]);
	gSetListValue("PneuInf",tmp[14]);
	gSetListValue("PrognosisRes",tmp[15]);
	SetValues("RecDate",tmp[16]);
	SetValues("RecNo",tmp[17]);
	SetValues("RecTime",tmp[18]);
	SetValues("TopTemp",tmp[19]);
	SetValues("TraLocID",tmp[20].split("~")[0]);
	SetValues("TraLoc",tmp[20].split("~")[1]);
	gSetListValue("UrinaryInf",tmp[21]);
	gSetListValue("UrinePipe",tmp[22]);
	gSetListValue("WindPipeOrCut",tmp[23]);
	SetValues("Resume_",tmp[24]);
	SetValues("cPaadm",tmp[25]);
	SetValues("Name",tmp[39]);
	SetValues("Age",tmp[42]);
	SetValues("IPNo",tmp[43]);
	
	var obj=document.getElementById("Sex");
	if(obj) 
	{
		if(tmp[41]==t['Man']) gSetListIndex("Sex",0);
		else gSetListIndex("Sex",1);	 
	 }
 
}
function SetWardRoomId(Str)
{
	var WardId=document.getElementById('WardId');
	var tem=Str.split("^");
	WardId.value=tem[1];
}
function SetInfBacilliNum1(Str)
{
	var InfBacilliNum1ID=document.getElementById('InfBacilliNum1ID');
	var tem=Str.split("^");
	InfBacilliNum1ID.value=tem[1];
}

function SetInfBacilliNum2(Str)
{
	var InfBacilliNum2ID=document.getElementById('InfBacilliNum2ID');
	var tem=Str.split("^");
	InfBacilliNum2ID.value=tem[1];
}

function SetCulResNum11(Str)
{
	var CulResNum11ID=document.getElementById('CulResNum11ID');
	var tem=Str.split("^");
	CulResNum11ID.value=tem[1];
}

function SetCulResNum12(Str)
{
	var CulResNum12ID=document.getElementById('CulResNum12ID');
	var tem=Str.split("^");
	CulResNum12ID.value=tem[1];
}

function SetCulResNum21(Str)
{
	var CulResNum21ID=document.getElementById('CulResNum21ID');
	var tem=Str.split("^");
	CulResNum21ID.value=tem[1];
}

function SetCulResNum22(Str)
{
	var CulResNum22ID=document.getElementById('CulResNum22ID');
	var tem=Str.split("^");
	CulResNum22ID.value=tem[1];
}

function SetBedId(Str)
{
	var BedId=document.getElementById('BedId');
	var tem=Str.split("^");
	BedId.value=tem[1];
}

function SetTraLoc(Str)
{
	var TraLocID=document.getElementById('TraLocID');
	var tem=Str.split("^");
	TraLocID.value=tem[1];
}
function SetData()
{
	var BedRowid="",ResDate="";
	
	var ret=CheckRepDet();
	if(ret>0) return;

	BedRowid=document.getElementById("WardId").value+"||"+document.getElementById("BedId").value
	var obj=document.getElementById("ResDate");
	if(obj) ResDate=obj.value;
	if((BedRowid=="")||(ResDate=="")) return;
	
	var obj=document.getElementById("MethodFindPatInfo");
	if (obj) {var encmeth=obj.value} else {var encmeth=''}
	var ret=cspRunServerMethod(encmeth,BedRowid,ResDate);
	//ret=GetAdmInfo_"^"_papmino_"^"_name_"^"_sex_"^"_birthdate_"^"_age

	if((ret==1)||(ret=="")) return;
	
	var tem=ret.split("^");
	
	var obj=document.getElementById("cPaadm");
	if(obj) obj.value=tem[0];
		
	var obj=document.getElementById("Name");
	if(obj) obj.value=tem[14];
	
	var obj=document.getElementById("Sex");
	if(obj) 
	{
		if(tem[15]==t['Man']) gSetListIndex("Sex",0);
		else gSetListIndex("Sex",1);
	 
	 }
	var obj=document.getElementById("Age");
	if(obj) obj.value=tem[17];
	
	var obj=document.getElementById("IPNo");
	if(obj) obj.value=tem[18];
	
	var obj=document.getElementById("TraLoc");
	if(obj) obj.value=tem[21].split("~")[1]; 
	
	if(tem[21].split("~")[0]!=null) 
	{
		var obj=document.getElementById("TraLocID");  
		if(obj) obj.value=tem[21].split("~")[0];
		
	}   
	
	var obj=document.getElementById("ForBed");
	if(obj) obj.value=tem[22].split("~")[1];

}
function Init()
{
	var obj=document.getElementById("ResNo");
	if(obj) obj.value=session['LOGON.USERID'];
	MakeComboBox("WindPipeOrCut");
	var InfNum=document.getElementById("WindPipeOrCut");
	if (InfNum)	gSetListIndex("WindPipeOrCut",0);
	
	MakeComboBox("UrinePipe");
	var InfNum=document.getElementById("UrinePipe");
	if (InfNum)	gSetListIndex("UrinePipe",0);
	
	MakeComboBox("DeepVeinPipe");
	var InfNum=document.getElementById("DeepVeinPipe");
	if (InfNum)	gSetListIndex("DeepVeinPipe",0);
	
	MakeComboBox("CtlocNum");
	var InfNum=document.getElementById("CtlocNum");
	if (InfNum)	gSetListIndex("CtlocNum",0);
	
	MakeComboBox("BloodInf");
	var InfNum=document.getElementById("BloodInf");
	if (InfNum)	gSetListIndex("BloodInf",0);
	
	MakeComboBox("UrinaryInf");
	var InfNum=document.getElementById("UrinaryInf");
	if (InfNum)	gSetListIndex("UrinaryInf",0);
	
	MakeComboBox("PneuInf");
	var InfNum=document.getElementById("PneuInf");
	if (InfNum)	gSetListIndex("PneuInf",0);

	MakeComboBox("PrognosisRes");
	var InfNum=document.getElementById("PrognosisRes");
	if (InfNum)	gSetListIndex("PrognosisRes",0);		
	
	MakeComboBox("Sex");
	var InfNum=document.getElementById("Sex");
	if (InfNum)	gSetListIndex("Sex",0);	
	
}
function MakeComboBox(controlID)
{
	var obj = document.getElementById(controlID);
	obj.multiple = false;
	obj.size = 1;
}
function gSetListIndex(objname,Index)
{
	var obj=document.getElementById(objname);
	if (obj)
	{
		//obj.selectedIndex=Index;
		obj.options[Index].selected=true;
	}
}
function gSetListValue(objname,value)
{
	var obj=document.getElementById(objname);
	if(!obj) return;
	for(i=0;i<obj.length;i++)
	{
		if(obj.options[i].value==value)
		{
		  obj.options[i].selected=true;
		  return;
		}
		  
		}
}
function GetValuesSel(Str)
{
	var ret="";
	var select = document.getElementById(Str);
  if(select) ret=select.options[select.selectedIndex].innerText
  return ret ;
	
}
function SaveData()
{
	if((GetValues("ResDate")=="")||(GetValues("CurrentBed")=="")||(GetValues("cPaadm")==""))
	{
		alert(t['NoFinish']);
		return;
	}
    var DataList=GetValues("cPaadm")+"^"+				
    SetWeekData()+"^"+						
    GetValues("WardId")+"^"+
    GetValues("BedId")+"^"+
    GetValues("CtlocNum")+"^"+
    GetValues("DeepVeinPipe")+"^"+
    GetValues("UrinePipe")+"^"+
    GetValues("WindPipeOrCut")+"^"+
    GetValues("TopTemp")+"^"+
    GetValues("BloodInf")+"^"+
    GetValues("UrinaryInf")+"^"+
    GetValues("PneuInf")+"^"+
    GetValues("InfNum")+"^"+
    GetValues("InfBacilliNum1ID")+"^"+
    GetValues("CulResNum11ID")+"^"+
    GetValues("CulResNum12ID")+"^"+
    GetValues("PrognosisRes")+"^"+
    GetValues("ResNo")+"^"+
    GetValues("TraLocID")+"^"+
    GetValues("ForBed")+"^"+
    GetValues("ResDate")+"^"+
    GetValues("BasesetDiag")+"^"+
    GetValues("RecNo")+"^"+
    GetValues("RecDate")+"^"+
    GetValues("RecTime")+"^"+
    GetValues("InfBacilliNum2ID")+"^"+
    GetValues("CulResNum21ID")+"^"+
    GetValues("CulResNum22ID");
    
	var obj=document.getElementById("MethodInsertData");
	if (obj) {var encmeth=obj.value} else {var encmeth=''}
	var ret=cspRunServerMethod(encmeth,DataList);
	
	if (ret>0) alert(t['Sucess']);
	else alert(t['False']);
}
function GetValues(Str)
{
	var ret=""
	var obj=document.getElementById(Str);
	if(obj) ret=obj.value;
	return ret;	
}
function SetValues(Str,tmp)
{
	var obj=document.getElementById(Str);
	if((obj)&&(tmp!=null)) obj.value=tmp;
}
document.body.onload=BodyLoadHandler;

function SetWeekData()
{
	var ResDate="",myweekday="",weekday="";
	var obj=document.getElementById('ResDate');
	if(obj) ResDate=obj.value;
  
  if (ResDate=="") return;

   ResDate=ResDate.split("/")[2]+"/"+ResDate.split("/")[1]+"/"+ResDate.split("/")[0];
   myweekday=new Date(ResDate).getDay();
  		
	 if(myweekday == 0) weekday=t['weekday0'];
	 else if(myweekday == 1)  weekday=t['weekday1'];
	 else if(myweekday == 2)  weekday=t['weekday2'];
	 else if(myweekday == 3)  weekday=t['weekday3'];
	 else if(myweekday == 4)  weekday=t['weekday4'];
	 else if(myweekday == 5)  weekday=t['weekday5'];
	 else if(myweekday == 6)  weekday=t['weekday6'];
	 return weekday;
}




