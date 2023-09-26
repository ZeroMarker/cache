
function BodyLoadHandler()
{
	var obj=document.getElementById("AllChecked");
	if(obj){obj.onclick=AllCheck_Click;}
}

function AllCheck_Click()
{
	var AdmDr="",TarDr="",OEORIDr="",InsuFlag="",BillDr=""
	var obj=document.getElementById("AdmDr");
	if(obj){AdmDr=obj.value;}
	var obj=document.getElementById("TarDr");
	if(obj){TarDr=obj.value;}
	var obj=document.getElementById("BillDr"); //Lou 2011-10-24
	if(obj){BillDr=obj.value;}
	
	var Src=window.event.srcElement;
	var tbl=document.getElementById('tINSUAuditDetailsListIP');
	var row=tbl.rows.length;
	for (var irow=1;irow<=row;irow++) {
		obj=document.getElementById('TInsuFlagz'+irow);
		if (obj) { obj.checked=Src.checked; }
		obj=document.getElementById('Txmdjz'+irow);
		if(obj)
		{
			if (Src.checked==true)
			{
				if (obj.innerText.indexOf("->")>=0){}
				else
				{
					obj.innerText=obj.innerText+"->丙类";
				}
			}
			else
			{
				var tmp
				tmp=obj.innerText.split("->")
				obj.innerText=tmp[0];
			}
		}
		var obj=document.getElementById('TOEORIDrz'+irow);
		if(obj){OEORIDr=obj.value;}
		var obj=document.getElementById('TInsuFlagz'+irow);
		if(obj){
			if(obj.checked==true)
			{
				InsuFlag="N";
			}
			else{InsuFlag="Y";}
		}
		var Ins=document.getElementById('clsSaveInsuFlag');
		if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
		var flag=cspRunServerMethod(encmeth,BillDr,TarDr,OEORIDr,InsuFlag);		
	}
	
	//location.reload();
}


function SelectRowHandler()	{
	var AdmDr="",TarDr="",OEORIDr="",InsuFlag="",BillDr=""
	var obj=document.getElementById("AdmDr");
	if(obj){AdmDr=obj.value;}
	var obj=document.getElementById("TarDr");
	if(obj){TarDr=obj.value;}
	var obj=document.getElementById("BillDr"); //Lou 2011-10-24
	if(obj){BillDr=obj.value;}

	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tINSUAuditDetailsListIP');
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	
	iSeldRow=selectrow;
	var SelRowObj
	var obj
	SelRowObj=document.getElementById('TInsuFlagz'+selectrow);
	//SelRowObj.onfocus=Test();
	obj=document.getElementById('Txmdjz'+selectrow);
	if(obj)
	{
		if (SelRowObj.checked==true)
		{
			if (obj.innerText.indexOf("->")>=0){}
			else
			{
				obj.innerText=obj.innerText+"->丙类";
			}
		}
		else
		{
			var tmp
			tmp=obj.innerText.split("->")
			obj.innerText=tmp[0];
		}
		//var obj=document.getElementById('TOEORIDrz'+selectrow); //如果没有执行执行就放开此行 Zhan 20160413
		var obj=document.getElementById('TOEExeDrz'+selectrow);
		if(obj){OEORIDr=obj.innerText;}
		var obj=document.getElementById('TInsuFlagz'+selectrow);
		if(obj){
			if(obj.checked==true)
			{
				InsuFlag="N";
			}
			else{InsuFlag="Y";}
		}
		//alert(AdmDr+"^"+TarDr+"^"+OEORIDr+"^"+InsuFlag)
		var Ins=document.getElementById('clsSaveInsuFlag');
		if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
		var flag=cspRunServerMethod(encmeth,BillDr,TarDr,OEORIDr,InsuFlag);
		location.reload();
	}
}
document.body.onload = BodyLoadHandler;
