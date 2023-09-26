var Component="DHCEQMaintRe"
function BodyLoadHandler(){		
	InitPage();
}

function InitPage()
{
	KeyUp("Equip");
	Muilt_LookUp("Equip");
	SetTableItem();
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
}

function GetEquip(value){
	var user=value.split("^");
	var obj=document.getElementById('EquipDR');
	obj.value=user[1];
	var obj=document.getElementById('UseLocDR');
	obj.value=user[5];
}

function BUpdate_Click() 
{
	var objtbl=document.getElementById('t'+Component);
	var rows=objtbl.rows.length;
	for (var i=1;i<rows;i++)
	{
		var TFlag=GetElementValueNew("TChoosez"+i,"2")
		if (TFlag==true)
		{
			if (CheckNull()) return;
	        var combindata=GetMaintInfoList(i);
	        var encmeth=GetElementValue("UpdateData");
  	        if (encmeth=="") return;
	        var Rtn=cspRunServerMethod(encmeth,combindata);
	        if (Rtn<0) 
	        {
		        alertShow(t["04"]);
		        return;	
	        }else if (Rtn>0)
	        {
		        alertShow("记录已生成成功!");
		        BSubmit_Click(Rtn);
		     }
		}
	}	
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT="+Component+"&EquipDR="+GetElementValue("EquipDR")+"&BussType="+GetElementValue("BussType");	      			
	
}

function BSubmit_Click(RowID) 
{
	var encmeth=GetElementValue("SubmitData");
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,RowID)
	if (Rtn<0) 
	{
		alertShow(t["04"]);
		return;	
	}
}

function SetTableItem(RowNo,SourceType,selectrow)
{
	var objtbl=document.getElementById('t'+Component);
	var rows=objtbl.rows.length-1;
	for (var i=1;i<=rows;i++)
		{
			
			ChangeRowStyle(objtbl.rows[i]);		///改变一行的内容显示
		}

}
///改变一行的内容显示
function ChangeRowStyle(RowObj)
{
	for (var j=0;j<RowObj.cells.length;j++)
	{
		var html="";
		var value="";

    	if (!RowObj.cells[j].firstChild) {continue}
		var Id=RowObj.cells[j].firstChild.id;
		var offset=Id.lastIndexOf("z");
		var objindex=Id.substring(offset+1);
		var colName=Id.substring(0,offset);
		var objwidth=RowObj.cells[j].style.width;
		var objheight=RowObj.cells[j].style.height;
		if (colName=="TMaintDate")
		{
			value=GetCElementValue(Id);
         	html=CreatElementHtml(3,Id,objwidth,objheight,"LookUpTableDate","TDate_changehandler","","","")
		}
		if (html!="") RowObj.cells[j].innerHTML=html;
	    if (value!="")
	    {
		    value=trim(value);
		    if (RowObj.cells[j].firstChild.tagName=="LABEL")
		    {
			    RowObj.cells[j].firstChild.innerText=value;
			}
			else if ((RowObj.cells[j].firstChild.tagName=="INPUT")&&(RowObj.cells[j].firstChild.type=="checkbox"))
		    {
			    RowObj.cells[j].firstChild.checked=value;
			}
			else
		    {
			    RowObj.cells[j].firstChild.value=value;
		    }
	    }
	}
}
function GetMaintInfoList(i)
{
	var combindata="";	
	combindata=""; //GetElementValue("RowID") ; //1
	combindata=combindata+"^"+GetElementValue("EquipDR") ; //2
	combindata=combindata+"^"+GetElementValue("BussType") ; //3
	combindata=combindata+"^"+GetElementValue("TRowIDz"+i) ; //4
	combindata=combindata+"^"+GetElementValue("TMaintTypeDRz"+i) ; //5
	combindata=combindata+"^"+GetElementValue("TMaintDatez"+i) ; //6
	combindata=combindata+"^"+GetElementValue("TMaintLocDRz"+i) ; //7
	combindata=combindata+"^"+GetElementValue("TMaintUserDRz"+i) ; //8
	combindata=combindata+"^"+GetElementValue("TMaintModeDRz"+i) ; //9
	combindata=combindata+"^"+GetElementValue("TMaintFeez"+i) ; //10  TotalFee
	combindata=combindata+"^"+GetChkElementValue("TNormalFlagz"+i) ; //11
	combindata=combindata+"^"+GetElementValue("ManageLocDR") ; //12
	combindata=combindata+"^"+GetElementValue("UseLocDR") ; //13
	combindata=combindata+"^"+""; //GetElementValue("Status") ; //14
	combindata=combindata+"^"+""; //GetElementValue("Remark") ; //15
	/*
	combindata=combindata+"^"+GetElementValue("UpdateUserDR") ; //
	combindata=combindata+"^"+GetElementValue("UpdateDate") ; //
	combindata=combindata+"^"+GetElementValue("UpdateTime") ; //
	combindata=combindata+"^"+GetElementValue("AuditUserDR") ; //
	combindata=combindata+"^"+GetElementValue("AuditDate") ; //
	combindata=combindata+"^"+GetElementValue("AuditTime") ; //
	combindata=combindata+"^"+GetElementValue("SubmitUserDR") ; //
	combindata=combindata+"^"+GetElementValue("SubmitDate") ; //
	combindata=combindata+"^"+GetElementValue("SubmitTime") ; //*/
	combindata=combindata+"^"+GetElementValue("TMaintFeez"+i) ; //16
	combindata=combindata+"^"+""; //GetElementValue("Hold1") ; //17
	combindata=combindata+"^"+""; //GetElementValue("Hold2") ; //18
	combindata=combindata+"^"+""; //GetElementValue("Hold3") ; //19
	combindata=combindata+"^"+""; //GetElementValue("Hold4") ; //20
	combindata=combindata+"^"+""; //GetElementValue("Hold5") ; //21
	combindata=combindata+"^"+""; //GetChkElementValue("MeasureFlag") ; //22
	combindata=combindata+"^"+""; //GetElementValue("MeasureDeptDR") ; //23
	combindata=combindata+"^"+""; //GetElementValue("MeasureHandler") ; //24
	combindata=combindata+"^"+""; //GetElementValue("MeasureTel") ; //25
	combindata=combindata+"^"+""; //GetElementValue("MeasureUsers") ; //26
	combindata=combindata+"^"+""; //GetElementValue("ServiceDR") ; //27
	combindata=combindata+"^"+""; //GetElementValue("ServiceHandler") ; //28
	combindata=combindata+"^"+""; //GetElementValue("ServiceTel") ; //29
	combindata=combindata+"^"+""; //GetElementValue("ServiceUsers") ; //30
	combindata=combindata+"^"+""; //GetChkElementValue("InvalidFlag") ; //31
	/*
	combindata=combindata+"^"+GetElementValue("DelUserDR") ; //
	combindata=combindata+"^"+GetElementValue("DelDate") ; //
	combindata=combindata+"^"+GetElementValue("DelTime") ; //*/
	return combindata;
}
function TMaintDate_lookupSelect(dateval)
{
	var obj=document.getElementById('TMaintDatez'+selectRow);
	obj.value=dateval;
}
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	return false;
}
document.body.onload = BodyLoadHandler;
