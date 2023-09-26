/// Created By HZY 2012-12-27 HZY0035
/// ----------------------------------
function BodyLoadHandler() 
{
	InitPage();
	var Status=GetElementValue("Status")
	var SerialFlag=GetElementValue("SerialFlag")
	if (Status>0) 
	{
		DisableBElement("BUpdate",true)
		DisableBElement("SelectAll",true)
	}
	if (SerialFlag=="Y")
	{
		DisableBElement("BUpdate",true)
	}
}

function InitPage()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Clicked;
	var obj=document.getElementById("SelectAll");
	if (obj) obj.onclick=SelectAll_Clicked;
}

///明细选择
function BUpdate_Clicked()
{	
	var SourceID=GetElementValue("SourceID");
	if (SourceID=="") return;
	var objtbl=document.getElementById('tDHCEQUpdateAccessoryByList'); //得到表格   t+组件名称
	var rows=objtbl.rows.length;
	var i=rows-1;
	var TJob=GetElementValue("TJobz"+i);
	SetElement("Job",TJob);
	
	var Job=GetElementValue("Job");
	var index=GetElementValue("index");
	var MXRowID=GetElementValue("MXRowID");
	var Type=GetElementValue("Type")
	var SourceID=GetElementValue("SourceID");
	var StoreLocDR=GetElementValue("StoreLocDR");
	var QuantityNum=GetElementValue("QuantityNum");	
	var encmeth=GetElementValue("GetAccessoryIDsInfo");
	if (encmeth=="") return;
	var listinfos=cspRunServerMethod(encmeth,Type,MXRowID,StoreLocDR,QuantityNum,Job,index,SourceID);	//取得已经存在的RowIDs
	var list=listinfos.split("&");	
	listinfos=list[1];
				
	for (i=1;i<rows;i++)
	{
		var TRowID=GetElementValue("TRowIDz"+i)
		var ListInfo=TRowID
		var TSelect=GetElementValueNew("TSelectz"+i,"2")
		
		var tmp=","+listinfos+",";
		if (tmp.indexOf(","+ListInfo+",")==-1)
		{
			if (TSelect==true)
			{
				if (listinfos!="") listinfos=listinfos+",";
				listinfos=listinfos+ListInfo;
			}			
		}
		else
		{
			if (TSelect==false)
			{
				tmp=tmp.replace(","+ListInfo+",",",")
				if (tmp==",")
				{	listinfos="";	}
				else
				{	listinfos=tmp.substring(1,tmp.length - 1) }
			}
		}		
	}	
	var Num=0;
	if ((listinfos!="")&&(listinfos!=","))
	{
		var list=listinfos.split(",");
		Num=list.length;
	}	
	
	var truthBeTold = true;
	var Rnt=Num-QuantityNum;
	if (Rnt<0)
	{
		var truthBeTold = window.confirm("选择的设备数量少了"+(-Rnt)+"台,是否修改?");
	}
	else if (Rnt>0)
	{
		var truthBeTold = window.confirm("选择的设备数量多了"+Rnt+"台,是否修改?");
	}
	if(truthBeTold)
	{
		var encmeth=GetElementValue("GetUpdate");
		if (encmeth=="") return;
		var MXInfo=Job+"^"+index+"^"+Num+"^"+MXRowID+"^"+Type;
		var result=cspRunServerMethod(encmeth,listinfos,MXInfo);
		if (result==0)
		{
			if (Type==1)	//配件转移
			{
				var obj=opener.document.getElementById("TQuantityNumz"+index);
			}
			else
			{
				var obj=opener.document.getElementById("TReturnQtyNumz"+index);  	//Modify DJ 2014-09-10
			}
			if (obj) obj.value=Num;
			window.opener.SumList_Change();   //修改父窗口合计信息
	
			var val="&Job="+Job;
			val=val+"&index="+index;
			val=val+"&SourceID="+SourceID;
			val=val+"&MXRowID="+MXRowID;
			val=val+"&QuantityNum="+Num;
			val=val+"&StoreLocDR="+StoreLocDR;
			val=val+"&Status="+GetElementValue("Status");
			val=val+"&Type="+Type;
			window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQUpdateAccessoryByList&'+val;
		}
		else
		{
			alertShow("更新失败!");
		}
	}
}

function SelectAll_Clicked()
{
	var valRowIDs=""
	var eSrc=window.event.srcElement;
	var obj=document.getElementById("SelectAll");
	var Objtbl=document.getElementById('tDHCEQUpdateAccessoryByList');
	var Rows=Objtbl.rows.length;
	for (var i=1;i<Rows;i++)
	{
		var selobj=document.getElementById('TSelectz'+i);
		selobj.checked=obj.checked;
		if (selobj.checked==true)
		{
			var TRowID=GetElementValue("TRowIDz"+i);
			var Select=document.getElementById("TSelectz"+i);
			var Select=Select.checked
			if (Select==true)
			{
				Select=1;
				if (valRowIDs=="") 
				{
					valRowIDs=TRowID;
				}
				else 
				{
					if (valRowIDs.indexOf(TRowID)!=-1) 
					{
						valRowIDs=TRowID;
					}
					else 
					{
						valRowIDs=valRowIDs+","+TRowID;
					}
				}
			}
			else
			{
				Select=0;
				if (valRowIDs.indexOf(TRowID)!=-1)
				{
					var valRowIDs=","+valRowIDs+",";
					var valRowIDs=valRowIDs.replace(","+TRowID+",",",");
					var valRowIDs=valRowIDs.substring(1,valRowIDs.length - 1);
					if (valRowIDs=",") valRowIDs="";
				}
			}
		}
	}
}

document.body.onload = BodyLoadHandler;