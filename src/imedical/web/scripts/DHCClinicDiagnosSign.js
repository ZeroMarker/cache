var clgrp = document.all.ClinicGroupDr;
var dssdr = document.all.MRCDSSDr;
var btnAdd = document.all.Add;
var btnUpdate = document.all.Update;
var HideID = document.all.HideID;
var enmethod = document.all.enmethod.value;
var delmethod = document.all.delmethod.value; 

var clgrpId = '';
var dssdrId = '';
document.body.onload = BodyLoadHandler;

function BodyLoadHandler()
{
	var obj = document.getElementById("Add");
	if (obj) obj.onclick = add_click;
	var obj = document.getElementById("Update");
	if (obj) obj.onclick = update_click;
	var obj = document.getElementById("Delete");
	if (obj) obj.onclick = delete_click;
	//var obj = document.getElementById("ClinicGroupDr");
	//if (obj) obj.onchange = ClinicGroup_changehandler;
}

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	//if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCClinicDiagnosSign');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	var obj=document.getElementById('ClinicGroupDr');
	var obj1=document.getElementById('MRCDSSDr');
	var obj2=document.getElementById('HideID');
	var SelRowObj=document.getElementById('TClinicGroupz'+selectrow);
	var SelRowObj1=document.getElementById('TMRCDSSz'+selectrow);
	var SelRowObj2=document.getElementById('Tidz'+selectrow);
	var SelRowObj3=document.getElementById('TclgrpIdz'+selectrow);
	var SelRowObj4=document.getElementById('TdssdrIdz'+selectrow);
	if (rowObj.className != "clsRowSelected")
	{
		obj.value = '';
		obj1.value = '';
		obj2.value = '';
		clgrpId = '';
		dssdrId = '';
	}
	else
	{
		obj.value=SelRowObj.innerText;
		obj1.value=SelRowObj1.innerText;
		obj2.value=SelRowObj2.value;
		clgrpId = SelRowObj3.value;
		dssdrId = SelRowObj4.value;
	}
	SelectedRow = selectrow;
}

function SetClinic(str)
{
	if (str)
	{
		var array = str.split("^");
		if (array.length>1)
		{
			clgrpId = array[1];
		}
	}
		
}

function SetDSS(str)
{
	if (str)
	{
		var array = str.split("^");
		if (array.length>1)
		{
			dssdrId = array[1];
		}
	}
}
function add_click()
	{
		if (validate())
		{
			if (clgrpId && dssdrId)
			{			
				//alert(HideID.value+':'+clgrpId+':'+dssdrId);
				//return ;
				var ret = cspHttpServerMethod(enmethod,"",clgrpId,dssdrId);
				switch(ret)
				{
					case "1":
						location = self.location;
						break;
					case "-1":
						alert(t['existsMsg']);
						break;
					default:
						alert(t['addFailMsg']);
						break;
				}
			}
		}
	}

function update_click()
	{
		if (validate())
		{
			if (clgrpId && dssdrId)
			{			
				
				//return ;
				var ret = cspHttpServerMethod(enmethod,HideID.value,clgrpId,dssdrId);
				switch(ret)
				{
					case "1":
						location = self.location;
						break;
					case "-1":
						alert(t['existsMsg']);
						break;
					default:
						alert(t['updateFailMsg']);
						break;
				}
			}
		}
	}
function delete_click()
{
	if (HideID.value != '')
	{
		if (confirm(t['delWarning']))
		{
			if (cspHttpServerMethod(delmethod,HideID.value))
				{
					location = self.location;
				}
				else
				{
					alert(t['delFailMsg']);			
				}
		}
	}
	else
	{
		alert(t['delMsg']);
	}
}
function validate()
{
	if (clgrp.value == '' || clgrpId == '')
	{
		alert(t['clgrpMsg']);
		return false;
	}

	if (dssdr.value == '' || dssdrId == '')
	{
		alert(t['dssdrMsg']);
		return false;
	}
	return true;
}