var CurrentRow;
function BodyLoadHandler()
{
	
	obj=document.getElementById("Add") ;
    if (obj) obj.onclick=AddClick;
    
    obj=document.getElementById("Delete") ;
    if (obj) obj.onclick=DeleteClick;
    
    obj=document.getElementById("Query") ;
    if (obj) obj.onclick=QueryClick;
    
    obj=document.getElementById("Update") ;
    if (obj) obj.onclick=UpdateClick;
    obj=document.getElementById("Desc") ;
    if (obj) obj.onkeydown=keydown;	
}

function AddClick()
{
	var obj=document.getElementById("Desc"); 
	if (obj) 
	{	
	    var tarDesc=(trim(obj.value))
		if (tarDesc!="")
		{
	
			var obj=document.getElementById("mInsert") ;
			if (obj) {var encmeth=obj.value;} else {var encmeth='';}
			var ret=cspRunServerMethod(encmeth,tarDesc) ;
			if (ret<0)
			{
				alert("����ʧ��,������")
			}
			else
			{
				QueryClick();
			}

		}else{
			alert("����¼���շ�����!")
		}  
	} 
}

function QueryClick()
{
	var obj=document.getElementById("Desc"); 
	if (obj)
	{
		var tarDesc=trim(obj.value);
		var objtarDesc=document.getElementById("tarDesc"); 
		objtarDesc.value=tarDesc;	
	
	}
	Query_click();
}

function UpdateClick()
{
	if (typeof(CurrentRow)=='undefined') 
	{
		alert("����ѡ��Ԥ�޸ĵļ�¼");
		return;
	}
	
	var obj=document.getElementById("Trowid"+"z"+CurrentRow) 
	var tarrowid=obj.innerText;
	var objdesc=document.getElementById("Desc") 
	var tardesc=trim(objdesc.value);
	if (tardesc=="")
	{
		alert("���Ʋ���Ϊ��,������")
		return;
	}	
	
	var obj=document.getElementById("mUpdate") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var ret=cspRunServerMethod(encmeth,tarrowid,tardesc) ;
	if (ret<0)
			{
				alert("����ʧ��,������")
			}
	else
			{
				QueryClick();
			}



}
function DeleteClick()
{
	if (typeof(CurrentRow)=='undefined') 
	{
		alert("����ѡ��ɾ���ļ�¼");
		return;
	}
	var obj=document.getElementById("Tdesc"+"z"+CurrentRow) 
	var tardesc=obj.innerText;
	
	if (confirm("ȷ��Ҫɾ��< "+tardesc+" >�������¼��?")==false)  return ; 
	
	var obj=document.getElementById("Trowid"+"z"+CurrentRow) 
	var tarrowid=obj.innerText;

	var obj=document.getElementById("mDelete") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var ret=cspRunServerMethod(encmeth,tarrowid) ;
	if (ret<0)
			{
				alert("ɾ��ʧ��,������")
			}
	else
			{
				var objDesc=document.getElementById("Desc")
	 			objDesc.value="";
				QueryClick();
			}

}

function SelectRowHandler()
 {
	 
	 var row=selectedRow(window);
	 CurrentRow=row;

	 SetDesc();
	 SetLinkItm();
	 SetLinkOrd();
	 findLinkItm();
	 findLinkOrd();
 }
 
 function SetDesc()
 {
	 var obj=document.getElementById("Tdesc"+"z"+CurrentRow)
	 var desc=obj.innerText;
	 var objDesc=document.getElementById("Desc")
	 objDesc.value=desc; 
 }
 function SetLinkItm()
 {
	 var objRowid=document.getElementById("Trowid"+"z"+CurrentRow)
	 var rowid=objRowid.innerText;
	 var docu=parent.frames['DHCST.PIVA.ORDERLINKITM'].document
	 var objRowid=docu.getElementById("mRowid")
	 objRowid.value=rowid;
 }
 
 function SetLinkOrd()
 {
	 var objRowid=document.getElementById("Trowid"+"z"+CurrentRow)
	 var rowid=objRowid.innerText;
	 var docu=parent.frames['DHCST.PIVA.ORDERLINKORD'].document
	 var objRowid=docu.getElementById("mRowid")
	 objRowid.value=rowid;

 }
 
 function findLinkItm()
 {
	 var objRowid=document.getElementById("Trowid"+"z"+CurrentRow)
	 var rowid=objRowid.innerText;
	 var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCST.PIVA.ORDERLINKITM&mRowid="+rowid;
     parent.frames['DHCST.PIVA.ORDERLINKITM'].location.href=lnk;
 }
 function findLinkOrd()
 {
	 var objRowid=document.getElementById("Trowid"+"z"+CurrentRow)
	 var rowid=objRowid.innerText;
	 var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCST.PIVA.ORDERLINKORD&mRowid="+rowid;
     parent.frames['DHCST.PIVA.ORDERLINKORD'].location.href=lnk;
 }
 function keydown()
 {
 	if (window.event.keyCode==13) 
	{  	
		if (event.preventDefault()){event.preventDefault()}
	}
}
 
document.body.onload=BodyLoadHandler;