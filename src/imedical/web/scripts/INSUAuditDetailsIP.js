var iSeldRow=0
var DetailsRow=0
function BodyLoadHandler() {
	Guser=session['LOGON.USERID']
	var obj=document.getElementById('AdmDr');
	if(obj)
	{
		//alert(obj.value);
	}
	
	var objtbl=document.getElementById(tINSUAuditDetailsIP) ;  //add 2011 12 31 限制信息字符超长时使用超链接
	if (objtbl)
	{
		for (i=1;iobjtbl.rows.length;i++)
		{
		obj=document.getElementById('Tybbzz'+i);
		if(obj){
			VerArr1=obj.innerText.split("#");
			if (VerArr1.length1){
				obj.innerText=VerArr1[0]
				}
			}

		}
	}
	
}

function SelectRowHandler()	{

	var AdmDr="",TarDr="",OEORIDr="",InsuFlag="",BillDr=""
	var obj=document.getElementById('AdmDr');
	if(obj){AdmDr=obj.value;}

	var obj=document.getElementById('BillDr'); 2011-10-20
	if(obj){BillDr=obj.value;}
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tINSUAuditDetailsIP');
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	
	iSeldRow=selectrow;
	DetailsRow=iSeldRow;   //add 2011 12 31
	var SelRowObj
	var obj
	SelRowObj=document.getElementById('TInsuFlagz'+selectrow);
	var InsuFlagobj='TInsuFlagz'+selectrow;
	if(eSrc.id==InsuFlagobj) //Lou 2011-08-26
	{
		obj=document.getElementById('Txmdjz'+selectrow);
		if(obj)
		{
			if (SelRowObj.checked==true)
			{

				if (obj.innerText.indexOf("-")>=0){}
				else
				{
					obj.innerText=obj.innerText+"->丙类";
				}
			}
			else
			{
				var tmp
				tmp=obj.innerText.split("-")
				obj.innerText=tmp[0];
			}
		}
	
		var obj=document.getElementById('TTarDrz'+selectrow);
		if(obj){TarDr=obj.value;}
		var obj=document.getElementById('TOEORIDrz'+selectrow);
		if(obj){OEORIDr=obj.value;}
		var obj=document.getElementById('TInsuFlagz'+selectrow);
		if(obj){
			if(obj.checked==true)
			{
				InsuFlag="N";
			}
			else{InsuFlag="Y";}
		}
		obj=document.getElementById('TListFlagz'+selectrow);
		if(obj) //如果是汇总项需要循环所有OEORIDr
		{
			if(obj.innerText=="明细"){OEORIDr="";}
		}
		var Ins=document.getElementById('clsSaveInsuFlag');
		if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
		//alert(BillDr+"^"+TarDr+"^"+OEORIDr+"^"+InsuFlag)
		var flag=cspRunServerMethod(encmeth,BillDr,TarDr,OEORIDr,InsuFlag);		
	}	
}

document.body.onload = BodyLoadHandler;
