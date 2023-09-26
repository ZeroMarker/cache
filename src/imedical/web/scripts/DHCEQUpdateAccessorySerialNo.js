document.body.onload = BodyLoadHandler;
function BodyLoadHandler() 
{
	FillData();
	var Job=GetElementValue("Job")
	var Status=GetElementValue("Status")
	if((Status!="")&&(Status!=0))		//Modify DJ 2014-09-12
	{
		DisableBElement("BUpdate",true);
		DisableElement("SerialNo",true); //add by kdf 2018-02-03 需求号：542556
	}
	else
	{
		var obj=document.getElementById("BUpdate");
		if (obj) obj.onclick=BUpdate_Clicked;
	}
	
}

function FillData()
{
	var obj=document.getElementById("SourceID");
	var SourceID=obj.value;
	var obj=document.getElementById("AccessoryDR");
	var AccessoryDR=obj.value;
	var obj=document.getElementById("QuantityNum");
	var QuantityNum=obj.value;
	var obj=document.getElementById("index");
	var index=obj.value
	var obj=document.getElementById("MXRowID");
	var MXRowID=obj.value
	var obj=document.getElementById("Job");
	var Job=obj.value
	var obj=document.getElementById("Status");
	var Status=obj.value
	if ((SourceID=="")||(AccessoryDR=="")){
		return;
	}
	var encmeth=GetElementValue("filldata")

  	if (encmeth=="") return;
  	var ReturnList=cspRunServerMethod(encmeth,MXRowID,SourceID,AccessoryDR,Job);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	var list=ReturnList.split("#");
	SetElement("SerialNo",list[0]);			//Add By DJ 2016-12-05
	//SetElement("SourceID",list[1]);
	//SetElement("QuantityNum",list[2]);
	//SetElement("index",list[3]);
	//SetElement("MXRowID",list[4]);
	//SetElement("AccessoryDR",list[5]);
	//SetElement("Status",list[6]);
	//SetElement("Job",list[6]);
	//var Job=GetElementValue("Job")
	//alertShow(Job)
}

function BUpdate_Clicked()
{
	var SerialNo=GetElementValue("SerialNo")
	var SourceID=GetElementValue("SourceID")
	var QuantityNum=GetElementValue("QuantityNum")
	var index=GetElementValue("index")
	var MXRowID=GetElementValue("MXRowID")
	var AccessoryDR=GetElementValue("AccessoryDR")
	var Status=GetElementValue("Status")
	var Job=GetElementValue("Job")
	
  	SerialNo=SerialNo.replace(/\\n/g,"\n");
	num=SerialNo.split("#");
	var list=num[0]
	row=list.split(",");
	if (row.length>QuantityNum)
	{
		alertShow("序列号数量超出范围")
		return
	}
	var encmeth=GetElementValue("upd")
  	if (encmeth=="") return;
  	var result=cspRunServerMethod(encmeth,SerialNo,SourceID,QuantityNum,index,MXRowID,AccessoryDR,Status,Job);
	if (result==0)
	{
		alertShow("操作成功!")
		location.reload();
		//window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQUpdateAccessorySerialNo&SerialNo='+list+"&QuantityNum="+QuantityNum+"&SourceID="+SourceID+"&index="+index+"&MXRowID="+MXRowID+"&AccessoryDR="+AccessoryDR+"&Status="+Status+"&Job="+Job;
	}
	else
	{
		alertShow(result+"更新失败!");
	}
}