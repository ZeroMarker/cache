var CurrentRow;
function BodyLoadHandler()
{
	
	obj=document.getElementById("Add") ;
    if (obj) obj.onclick=AddClick;
	
}


function AddClick()
{
	
	if (confirm("ȷ��Ҫ������?")==false)  return ;
	if (DeleteItm()==-1)
	{
		QueryClick();
		return;
	} 
    var obj=document.getElementById("mRowid") 
    var mrowid=obj.value;
    
    var objtbl=document.getElementById("t"+"DHCST_PIVA_LOCGRPITM")
    var cnt=getRowcount(objtbl) ;
    var str=""
	for (var i=1;i<=cnt;i++)
	{
		var objsel=document.getElementById("Tselect"+"z"+i);
		var objrowid=document.getElementById("Trowid"+"z"+i);
		var locrowid=objrowid.innerText;
		if (objsel.checked==true )
		{
			if (str=="")
			{
				
				str=locrowid;
			}
			else
			{
				str=str+"^"+locrowid;
			}
		}
	}
	if (str=="")
	{
		QueryClick();
		return;
	}

	var obj=document.getElementById("mInsert") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var ret=cspRunServerMethod(encmeth,str,mrowid) ;
	if (ret<0)
				{
					alert("����ʧ��,������")
				}
	else
				{
					QueryClick();
				}

}

function DeleteItm()
{
	
	var obj=document.getElementById("mRowid") 
	var mrowid=obj.value
	if (mrowid=="") 
	{
		alert("����ѡ��������ٽ��в���");
		return -1;
	}

	var obj=document.getElementById("mDelete") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var ret=cspRunServerMethod(encmeth,mrowid) ;
	if (ret<0)
			{
				alert("ɾ��ʧ��,������")
				return;
			}

}

function SelectRowHandler()
 {
	 
	 var row=selectedRow(window);
	 CurrentRow=row;


 }
 
 
function QueryClick()
 {
	 var obj=document.getElementById("mRowid") ;
	 var rowid= obj.value;
	 var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCST.PIVA.LOCGRPITM&mRowid="+rowid;
     parent.frames['DHCST.PIVA.LOCGRPITM'].location.href=lnk;
 }
 

 
document.body.onload=BodyLoadHandler;