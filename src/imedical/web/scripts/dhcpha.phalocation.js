/// dhcpha.phalocation.js

var currrow="";

function BodyLoadHandler()
{	

	var obj=document.getElementById("Add")
	if (obj) obj.onclick=Add;
	var obj=document.getElementById("Delete")
	if (obj) obj.onclick=Delete;
	var obj=document.getElementById("Modify")
	if (obj) obj.onclick=Modify;
	
	}

function Delete()
{ 
    var rowid;
	var exeobj;
	if (currrow>0) 
	{var obj=document.getElementById("Rowid"+"z"+currrow)
	 rowid=obj.value;	
	}
	//alert(rowid)
	var obj=document.getElementById("mDeleteOne")
	if (obj) exeobj=obj.value 
	else exeobj=""
	//alert(exeobj)
	
	var result=cspRunServerMethod(exeobj,rowid)
	
	self.location.reload();	
 }

function SelectRowHandler() {
	currrow=selectedRow(window);
	if (currrow>0) 
	var rowid;
	{var obj=document.getElementById("Rowid"+"z"+currrow)
	 rowid=obj.value;	
	}
//	alert(rowid)
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phalocdisptype&Parref="+rowid	
	parent.frames['dhcpha.phalocdisptype'].location.href=lnk;
}

function Add()
{ 
  var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phalocationAdd&Rowid="
   window.open(lnk,"_target","width=1000,height=600,menubar=no,status=yes,toolbar=no,resizable=yes,scrollbars=yes");
 // window.open(lnk)
  
}
function Modify()
{ 
  var id ;
  if (currrow>0)
  {
	 var obj=document.getElementById("Rowid"+"z"+currrow) 
	 if (obj)
	 {id=obj.value; }
	  var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phalocationAdd&Rowid="+id
	  window.open(lnk,"_target","width=1000,height=600,menubar=no,status=yes,toolbar=no,resizable=yes,scrollbars=yes");
  }
}

document.body.onload=BodyLoadHandler;