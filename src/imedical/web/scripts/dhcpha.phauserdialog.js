///dhcpha.phauserdialog
///�ڶ���ҩ��
function BodyLoadHandler()
{
	  window.returnValue="";
	  var obj=document.getElementById("bOK")
	  if (obj) obj.onclick=OkClick;
	  
	  var obj = document.getElementById("phaUser");
	  if (obj){
		setphaUser();
		obj.onchange=phaUserSelect;
	  }
	  
}


function OkClick()
{
	var obj=document.getElementById("phaUser");
	if (obj){window.returnValue=obj.value;}
	else {window.returnValue="";}
	window.close();
}

function setphaUser()
{
	var obj=document.getElementById("phaUser");
	if (obj) InitphaUser(obj);
	var objindex=document.getElementById("phauserIndex");
	if (objindex) obj.selectedIndex=objindex.value;
}
///��ʼ����ҩ��
function InitphaUser(listobj)
{
	var grp=session['LOGON.GROUPID']
	var sessionloc=session['LOGON.CTLOCID']
	var obj=document.getElementById("mGetPhaUser");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,"",sessionloc);
	if (result!="")
	{
		var tmparr=result.split("!!")
		var cnt=tmparr.length
		for (i=0;i<=cnt-1;i++)
		{ 
			var userstr=tmparr[i].split("^")
			var user=userstr[0];
			var userindex=userstr[1];
			///��ʼ����ҩ��
			if (listobj)
			{
				
				listobj.size=1; 
			 	listobj.multiple=false;

			 	listobj.options[i+1]=new Option(user,userindex);
		    }
			
		}
		
	}
	

}

/// phaUser
function phaUserSelect()
{
	var obj=document.getElementById("phauserIndex");
	if(obj){
		var objuser=document.getElementById("phaUser");
		obj.value=objuser.selectedIndex;
	}
}

document.body.onload=BodyLoadHandler