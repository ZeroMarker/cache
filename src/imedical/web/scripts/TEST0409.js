var buyrowid;
//JS���÷����M
function BodyLoadHandler() {
	var GetPatInfoObj=document.getElementById('PatID');	
	if (GetPatInfoObj) GetPatInfoObj.onkeydown=GetPatInfo_Click;
	//alert(1)
	
	
	var p1=document.getElementById('POPUP');	
	if (p1) p1.onclick=Find;
	
}
function GetPatInfo_Click()
{
	//alert(2)
	
	if (window.event.keyCode==13) 
	{
		//alert(3)
		var PatNo=document.getElementById('PatID').value;
		var GetPatObj=document.getElementById('js2m');
        if (GetPatObj) {var encmeth=GetPatObj.value} else {var encmeth=''};
        
       
        var PatInfo=cspRunServerMethod(encmeth,PatNo)
       
        PatInfo=PatInfo.split("^")
         alert(PatInfo)
        document.getElementById('PatName').value=PatInfo[0]
        //document.getElementById('patsex').value=PatInfo[1]
	}
}

//��ѡ��
 function SelectRowHandler()
{
	//��ȡ��ѡ�е���
	var eSrc=window.event.srcElement;
    var rowObj=getRow(eSrc);
    var selectrow=rowObj.rowIndex;
    //��ȡTable�ļ�¼��
    var objtbl=document.getElementById('tTEST0409');//T���Լ������	
    var rows=objtbl.rows.length;
    //��ȡTable��ĳһ�е�ĳ��Ԫ�ص�ֵ
    var SelRowObj=document.getElementById('ROW1z'+selectrow); //
    //var buyrowid=SelRowObj.innerText;
    buyrowid=SelRowObj.innerText;
    alert(buyrowid+'  '+selectrow+"/"+rows)
}

function Find()
{
	alert('popup'+t['01']+buyrowid);
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCTTao&BillId='+buyrowid+'&deposittype='+t['01'];
	
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1000,height=700,left=0,top=0');
}



document.body.onload = BodyLoadHandler;	