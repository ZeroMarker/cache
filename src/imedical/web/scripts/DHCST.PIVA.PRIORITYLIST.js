
function BodyLoadHandler()
{
	var obj=document.getElementById("t"+"DHCST_PIVA_PRIORITYLIST")
	if (obj) obj.ondblclick=selectPri;

}

function selectPri()
{
 //设置: 1--插入  2--删除
 var row=selectedRow(window);
 if (!row) return;
 if (row<1) return;
 var objrowid=document.getElementById("Trowid"+"z"+row);
 var rowid=objrowid.value;
 var objlocid=document.getElementById("Locid");
 var locid=objlocid.value;
 var objset=document.getElementById("Tset"+"z"+row);
 if (objset.innerText!="Y")
	{
		objset.innerText="Y";
        var flag=1
        var xx=document.getElementById("mUpdate");
		if (xx) {var encmeth=xx.value;} else {var encmeth='';}
	    var result=cspRunServerMethod(encmeth,rowid,locid,flag)
		if (result==-1){alert("此设置失败!")}
	}
			
 else  {   
            objset.innerText=""
            var flag=2
            var xx=document.getElementById("mUpdate");
			if (xx) {var encmeth=xx.value;} else {var encmeth='';}
			var result=cspRunServerMethod(encmeth,rowid,locid,flag)
			if (result==-1){alert("此设置失败!")}
		}

 //self.location.reload();
}
document.body.onload=BodyLoadHandler