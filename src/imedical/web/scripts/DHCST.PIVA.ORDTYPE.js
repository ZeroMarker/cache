//DHCST.PIVA.ORDTYPE
var CurrentRow;
function BodyLoadHandler()
{
	var obj=document.getElementById("bNew");
	if (obj) obj.onclick=bNewClick;
	websys_sckeys['N']=bNewClick; //zhouyg 20151013 
	obj=document.getElementById("bDelete") ;
    if (obj) obj.onclick=bDeleteClick;
    
    
}

function bNewClick()
{
	if (typeof(CurrentRow)=='undefined') 
	{
		var link="websys.default.csp?WEBSYS.TCOMPONENT=DHCST.PIVA.ORDTYPEADD"   
	}
	else
	{
	     var link="websys.default.csp?WEBSYS.TCOMPONENT=DHCST.PIVA.ORDTYPEADD&mainrow="+CurrentRow;
	}
    window.open(link,"_TARGET","height=500,width=600,menubar=no,status=yes,toolbar=no")
}

function SelectRowHandler()
 {
	 
	 var row=selectedRow(window);
	 CurrentRow=row;

 }
function bDeleteClick()
{
	if (typeof(CurrentRow)=='undefined') 
	{
		alert("��ѡ��Ҫɾ���ļ�¼��������...")
		return;  
	}
	if (confirm("ȷ��Ҫɾ����¼��?")==false)  return ;
	
	var obj=document.getElementById("Trowid"+"z"+CurrentRow)
	var rowid=obj.value;
	var ret=cspRunDelPhcCat(rowid);
	if (ret!=0)
	{
		alert("ɾ��ʧ��!")
		return;
	}
	else
    {
	    location.reload();
    }
	
	
}


function cspRunDelPhcCat(rowid)
{
	var obj=document.getElementById("mDelPhcCat");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,rowid);
	return result;
}



document.body.onload=BodyLoadHandler