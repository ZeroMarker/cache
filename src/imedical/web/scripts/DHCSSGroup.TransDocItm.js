function BodyLoadHandler()
{	
   var obj=document.getElementById("add")
   if (obj) obj.onclick=Addclick;
   var obj=document.getElementById("del")
   if (obj) obj.onclick=Delclick;
   
}

///����
function Addclick()
{
	var docu=parent.frames['DHCSSGroup.TransDoc'].document
	if (docu){
		var tblobj=docu.getElementById("t"+"DHCSSGroup_TransDoc")
		var cnt=getRowcount(tblobj);
		if (!(cnt>0)) return;
	    for (i=1;i<=cnt;i++)
	    {
		    
		    var obj=docu.getElementById("Tyes"+"z"+i)
		    if (obj) {
			    if (obj.checked!=true){
				    continue;
			    }
		    }
		    var rowid=""
		    var obj=docu.getElementById("Trowid"+"z"+i)
		    if (obj) rowid=obj.value;
		    var group=""
		    var obj=docu.getElementById("Tgroup"+"z"+i)
		    if (obj) group=obj.innerText;
		    
		    var ret=AddToSSDocGrp(rowid)
		    if (ret==-1)
		    {
			    alert(group+"����ʧ��")
		    }
		    if (ret==-2)
		    {
			    alert(group+"�����ظ�����")
		    }
		    
	    }
		
			
	}
	ReloadWinow();
	
}

///�Ƴ�
function Delclick()
{
	
		var tblobj=document.getElementById("t"+"DHCSSGroup_TransDocItm")
		var cnt=getRowcount(tblobj);
		if (!(cnt>0)) return;
	    for (i=1;i<=cnt;i++)
	    {
		    
		    var obj=document.getElementById("Tyes"+"z"+i)
		    if (obj) {
			    if (obj.checked!=true){
				    continue;
			    }
		    }
		    var rowid=""
		    var obj=document.getElementById("Trowid"+"z"+i)
		    if (obj) rowid=obj.value;
		    var group=""
		    var obj=document.getElementById("Tgroup"+"z"+i)
		    if (obj) group=obj.innerText;
		    
		    var ret=DelSSDocGrp(rowid)
		    if (ret==-1)
		    {
			    alert(group+"�Ƴ�ʧ��")
		    }
		    
	    }
		
			
	
	ReloadWinow();
}

///����ҽ����Ȩ��ȫ��
function AddToSSDocGrp(rowid)
{
  var obj=document.getElementById("madd")
  if (obj) {var encmeth=obj.value;} else {var encmeth='';}
  var ret=cspRunServerMethod(encmeth,rowid)
  return ret 
	
}

///����ҽ����Ȩ��ȫ��
function DelSSDocGrp(rowid)
{
  var obj=document.getElementById("mdel")
  if (obj) {var encmeth=obj.value;} else {var encmeth='';}
  var ret=cspRunServerMethod(encmeth,rowid)
  return ret 
	
}

///ˢ�½���
function ReloadWinow()
{	
    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCSSGroup.TransDocItm" ;
	location.href=lnk;
}





document.body.onload=BodyLoadHandler;