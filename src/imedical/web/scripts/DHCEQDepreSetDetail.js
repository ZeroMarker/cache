/// 创建:zy 2010-07-22    No ZY0026
/// ----------------------------------
var SelectedRow = 0;
function BodyLoadHandler() 
{
	if (GetElementValue("Flag")=="1") DisableElement("BUpdate",true);
	DisableElement("BDelete",true);
	InitEvent();
}
function InitEvent()
{
	var obj=document.getElementById("BUpdate");//更新
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");//删除
	if (obj) obj.onclick=BDelete_Click;
}

function BUpdate_Click() 
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")return;
	var plist=CombinData();
	var result=cspRunServerMethod(encmeth,plist,'0');
	result=result.replace(/\\n/g,"\n")
	if(result<0)
	{
		alertShow(t[-1000])
		return
	}
	else if (result>0)
	{
	window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDepreSetDetail&DepreSetDR='+GetElementValue("DepreSetDR");;
	}
}

function BDelete_Click() 
{
	var RowID=GetElementValue("RowID");
	if (RowID=="")return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")return;
	var result=cspRunServerMethod(encmeth,RowID,'1');
	result=result.replace(/\\n/g,"\n")
	if(result<0)
	{
		alertShow(t[-1000])
		return
	}
	else if (result>0)
	{
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDepreSetDetail&RowID='+GetElementValue("RowID")+"&DepreSetDR="+GetElementValue("DepreSetDR");
	}
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQDepreSetDetail');
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (SelectedRow==selectrow)	
	{
		Clear()
		SelectedRow=0;
		SetElement("RowID","");
		DisableElement("BDelete",true);
	}
	else
	{
		SelectedRow=selectrow;
		RowID=GetElementValue("TRowIDz"+SelectedRow);
		SetElement("RowID",RowID);
		FillData();
		DisableElement("BDelete",false);
	}
}
function Clear()
{
	SetElement("DSDRowID","");
	SetChkElement("ExceedFlag","");
	SetElement("FromYear","");
	SetElement("ToYear","");
	SetElement("Rate","");
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
}

function FillData()
{
	var RowID=GetElementValue("RowID");
	if (RowID=="")return;
	var encmeth=GetElementValue("GetDepreSetDetailByID");
	if (encmeth=="")return;
	var Ret=cspRunServerMethod(encmeth,RowID);
	Ret=Ret.replace(/\\n/g,"\n");
	list=Ret.split("^");
	var sort=10
	SetElement("ExceedFlag",list[sort]);
	SetElement("FromYear",list[2]);
	SetElement("ToYear",list[3]);
	SetElement("Rate",list[4]);
	SetElement("Hold1",list[5]);
	SetElement("Hold2",list[6]);
	SetElement("Hold3",list[7]);
	SetElement("Hold4",list[8]);
	SetElement("Hold5",list[9]);
}

function CombinData()
{
	var combindata=GetElementValue("RowID") ;
	combindata=combindata+"^"+GetElementValue("DepreSetDR") ;		//2设备名称
  	combindata=combindata+"^"+GetChkElementValue("ExceedFlag") ; 	//4主标志
  	combindata=combindata+"^"+GetElementValue("FromYear") ; 		//5自动记入折旧标志
  	combindata=combindata+"^"+GetElementValue("ToYear") ; 			//6上次折旧月份
  	combindata=combindata+"^"+GetElementValue("Rate") ; 			//7成本分配类型
  	combindata=combindata+"^"+GetElementValue("Hold1") ;		 	//16备注
  	combindata=combindata+"^"+GetElementValue("Hold2") ;		 	//17备注
  	combindata=combindata+"^"+GetElementValue("Hold3") ;		 	//18备注
  	combindata=combindata+"^"+GetElementValue("Hold4") ;		 	//19备注
  	combindata=combindata+"^"+GetElementValue("Hold5") ;		 	//20备注
  	return combindata;
}
function condition()//条件
{
	if (CheckMustItemNull()) return true;
	return false;
}
document.body.onload = BodyLoadHandler;