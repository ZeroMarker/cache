var DebtSum=0,selectrow

function BodyLoadHandler() {
	var Addobj=document.getElementById('BtnAdd');
	Addobj.onclick=Add_click;
	var Deleteobj=document.getElementById('BtnDelete');
	Deleteobj.onclick=Delete_click;
	var Deleteobj=document.getElementById('BtnUpdate');
	Deleteobj.onclick=Update_click;
}

function Add_click()
{   
	Addtabrow();
		
}
function Addtabrow()
	{   var DebtAmt
		var objtbl=document.getElementById('tUDHCJFUpdDebtPaymode');
		tAddRow(objtbl);
		var rows=objtbl.rows.length;
		var LastRow=rows - 1;
		var Row=LastRow
	
		var Tpaymode=document.getElementById("TPaymodez"+Row);
		var TAddAmt=document.getElementById("TPayAmtz"+Row);
		var PayModeObj=document.getElementById("PayMode");
		var PayamtObj=document.getElementById("Payamt");
		var DebtObj=document.getElementById("DebtAmt");
		var BalanceObj=document.getElementById("Balance");
		DebtAmt=DebtObj.value
		
		Tpaymode.innerText=PayModeObj.value;
		TAddAmt.innerText=PayamtObj.value
		var banlance=eval(BalanceObj.value)-eval(PayamtObj.value)
		BalanceObj.value=eval(banlance).toFixed(2).toString(10)
		
		PayModeObj.value=""
		PayamtObj.value=""

		}
function tAddRow(objtbl) {
	tk_ResetRowItemst(objtbl);
	var row=objtbl.rows.length;
	var objlastrow=objtbl.rows[row-1];
	//make sure objtbl is the tbody element
	objtbl=websys_getParentElement(objlastrow);
	var objnewrow=objlastrow.cloneNode(true);
	var rowitems=objnewrow.all; //IE only
	if (!rowitems) rowitems=objnewrow.getElementsByTagName("*"); //N6
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			arrId[arrId.length-1]=row;
			rowitems[j].id=arrId.join("z");
			rowitems[j].name=arrId.join("z");
			rowitems[j].value="";
		}
	}
	objnewrow=objtbl.appendChild(objnewrow);
	
	//
	{if ((objnewrow.rowIndex)%2==0) {objnewrow.className="RowOdd";} else {objnewrow.className="RowEven";}}
}
function tk_ResetRowItemst(objtbl) {
	for (var i=0;i<objtbl.rows.length; i++) {
		var objrow=objtbl.rows[i];
		{if ((i+1)%2==0) {objrow.className="RowEven";} else {objrow.className="RowOdd";}}
		var rowitems=objrow.all; //IE only
		if (!rowitems) rowitems=objrow.getElementsByTagName("*"); //N6
		for (var j=0;j<rowitems.length;j++) {
			//alert(i+":"+j+":"+rowitems[j].id);
			if (rowitems[j].id) {
				var arrId=rowitems[j].id.split("z");
				//if (arrId[arrId.length-1]==i+1) break; //break out of j loop
				arrId[arrId.length-1]=i+1;
				rowitems[j].id=arrId.join("z");
				rowitems[j].name=arrId.join("z");
			}
		}
	}
}
function SelectRowHandler()	
{  
	var eSrc=window.event.srcElement;
	var Objtbl=document.getElementById('tUDHCJFUpdDebtPaymode');
	var Rows=Objtbl.rows.length;
	var lastrowindex=Rows - 1;
	var RowObj=getRow(eSrc);
	selectrow=RowObj.rowIndex;
}
function Delete_click()
{  
	var Objtbl=document.getElementById('tUDHCJFUpdDebtPaymode');
	Objtbl.deleteRow(selectrow);
	tk_ResetRowItemst(Objtbl);
}
function Update_click()
{   var PayStr
	PayStr=""
	var Balance=document.getElementById("Balance").value
	if (Balance!=0)
	{
		alert(t['01'])
		return
	}
	var Objtbl=document.getElementById('tUDHCJFUpdDebtPaymode');
	var Rows=Objtbl.rows.length-1;
	for (i=2;i<=Rows;i++)
	{ 
		var Tpaymode=document.getElementById('TPaymodez'+i).innerText;
		var TAddAmt=document.getElementById('TPayAmtz'+i).innerText;
		if (PayStr=="")
		{   if (Tpaymode)
		    {   PayStr=Tpaymode+"^"+TAddAmt  }
		}
		else
		{   if (Tpaymode)
			{   PayStr=PayStr+"&"+Tpaymode+"^"+TAddAmt   }
		}
	}
	var UpdateRowId
	UpdateRowId=document.getElementById("Rowid").value
	var Guser=session['LOGON.USERID']
	var UpdateObj=document.getElementById('GetUpdate');
    if (UpdateObj) {var encmeth=UpdateObj.value} else {var encmeth=''};
	var retval=(cspRunServerMethod(encmeth,UpdateRowId,PayStr,Guser))
	if (retval==0)
	{   alert(t['02'])   }
	else
	{   alert(t['03'])  }
	   
}
document.body.onload = BodyLoadHandler;