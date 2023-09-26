//UDHCJFChageDisDate.js  cjb add 

function BodyLoadHandler()
{
	var obj=document.getElementById("BUpdate");
	if (obj){obj.onclick=Update_click}
}
function Update_click(){
	var ADMRowid=document.getElementById("ADMRowid").value;
	var disdate=document.getElementById("DisDate").value;
	var distime=document.getElementById("DisTime").value;
	var BillNo=document.getElementById("BillNo").value;
	var method=document.getElementById("update").value;
	var flag=cspRunServerMethod(method,ADMRowid,BillNo,disdate,distime)
		switch (flag){
			case "0":
			alert(t['00'])
			window.opener.Find.click()
	     	window.close();
			break;
			case "1":
			alert(t['01'])
			break;
			case "2":
			alert(t['02'])
			break;
			case "3":
			alert(t['03'])
			break;
			}
	}

document.body.onload = BodyLoadHandler;
