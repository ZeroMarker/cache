//DHCOPBillReasonRefInv.js
//Creator:	   lichao
//CreatDate:  2009-02-23
//Description: ��������뷢Ʊ��ӡģ�������
var DRowid
function BodyLoadHandler() {
	var obj=document.getElementById("BtAdd");
	if (obj)
	{
		obj.onclick=Add_OnClick;
	}
	var obj=document.getElementById("BtDelete");
	if (obj)
	{
		obj.onclick=Delete_OnClick;
	}
	var obj=document.getElementById("AdmReasondesc");
	if (obj)
	{
		obj.size=1;
		obj.multiple=false;
		if(obj.options.length>0)
		{
			obj.options.selectedIndex=0;
		}
	}
	var obj=document.getElementById("UseDept");
	if (obj)
	{
		obj.size=1;
		obj.multiple=false;
		if(obj.options.length>0)
		{
			obj.options.selectedIndex=0;
		}
	}
	var obj=document.getElementById("FareType");
	if (obj)
	{
		obj.size=1;
		obj.multiple=false;
		if(obj.options.length>0)
		{
			obj.options.selectedIndex=0;
		}
	}
}

function Add_OnClick()
{
	var obj=document.getElementById("AdmReasondesc");
	var AdmReasonDrVal=obj.value
	var obj=document.getElementById("FareType");
	var FareTypeVal=obj.value
	var obj=document.getElementById("UseDept");
	var UseDeptVal=obj.value
	var obj=document.getElementById("PrintTemp");
	var PrintTempVal=obj.value
	if (PrintTempVal=="")
	{
		alert("������ģ������")
		return;
	}
	//�ж��Ƿ����  add zhli  17.9.26
	var rtn = tkMakeServerCall('web.DHCOPBillReasonRefInv', 'CheckInfo', AdmReasonDrVal,FareTypeVal,UseDeptVal,PrintTempVal);
	if(rtn==0){
		alert("�������Ѵ���!");
	    return; 
	    
	}
	var Insertbj=document.getElementById('Insert');
	if (Insertbj) {var encmeth=Insertbj.value} else {var encmeth=''};
	var myrtn=cspRunServerMethod(encmeth,AdmReasonDrVal,FareTypeVal,UseDeptVal,PrintTempVal)
	if (myrtn=="0")
	{
		alert("����ɹ�");
		ReLoadH();
	}else{
		alert("����ʧ��");
	}	
}
function Delete_OnClick()
{
	var deleteobj=document.getElementById('Delete');
	if (deleteobj) {var encmeth=deleteobj.value} else {var encmeth=''};
	var myrtn=cspRunServerMethod(encmeth,DRowid)
	if (myrtn=="0")
	{
		alert("ɾ���ɹ�");
		ReLoadH();
	}else{
		alert("ɾ��ʧ��");
	}	
}

function ReLoadH(){
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBillReasonRefInv";
	location.href=lnk;
	
}
function SelectRowHandler()	
{  	
   var SelRowObj,CurObj
   var eSrc=window.event.srcElement;
   var Objtbl=document.getElementById('tDHCOPBillReasonRefInv');
   var Rows=Objtbl.rows.length;	
   var lastrowindex=Rows - 1;
   var rowObj=getRow(eSrc);
   var selectrow=rowObj.rowIndex;
   if (!selectrow) return;
   SelRowObj=document.getElementById('TAdmDescDrz'+selectrow);
   CurObj=SelRowObj.value; 
   document.getElementById("AdmReasondesc").value=CurObj
   SelRowObj=document.getElementById('TSareUseFareTypez'+selectrow);
   CurObj=SelRowObj.innerText; 
   document.getElementById("FareType").value=CurObj
   SelRowObj=document.getElementById('TSareUseDeptz'+selectrow);
   CurObj=SelRowObj.innerText; 
   document.getElementById("UseDept").value=CurObj
   SelRowObj=document.getElementById('TSarePrintTempz'+selectrow);
   CurObj=SelRowObj.innerText;
   document.getElementById("PrintTemp").value=CurObj
   SelRowObj=document.getElementById('TRowidz'+selectrow);
   DRowid=SelRowObj.value; 	

}
document.body.onload = BodyLoadHandler;