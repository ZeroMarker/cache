var mLinkId=0;

function BodyLoadHandler() {
	var GetPatInfoObj=document.getElementById('patno');	//��ȡ��Ρ]�ǼǺš^�A�������������Ʊ���һ��
	if (GetPatInfoObj) GetPatInfoObj.onkeydown=GetPatInfo_Click//���ݼ����¼�����GetPatInfo_Click��Ӧ����
	
	var clickButton = document.getElementById("FindOut");//ͬ��
	if(clickButton)
	   clickButton.onclick=showDetail
	
	
}
function GetPatInfo_Click()
{

	
	if (window.event.keyCode==13) 
	{
	
		var PatNo=document.getElementById('patno').value
		//var GetPatObj=document.getElementById('GetInfo1');
		var GetPatObj=document.getElementById('inl');//ͨ���齨�ϵ�����Ԫ��inl������ѡ��A����web.DHCBZTClass.FindPatName
        if (GetPatObj) { var encmeth=GetPatObj.value} else { var encmeth=''};//ͨ��encmeth��õ��ú����ķ���ֵ
        
        
        //var PatInfo=cspRunServerMethod(encmeth,PatNo)
       cspRunServerMethod(encmeth,'RetVal',PatNo)//����RetVal�������������ֵ
        //PatInfo=PatInfo.split("^")
       //
        //document.getElementById('patname').value=PatInfo[0]
     
        //document.getElementById('patsex').value=PatInfo[1]
        //alert(4)
        
	}

}

function RetVal(value)
{
	//alert(value)
	var PatInfo=value.split("^")	
	document.getElementById('patname').value=PatInfo[0]
     
    document.getElementById('patsex').value=PatInfo[1]
}
	//alert(5)
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	var selectrow = rowObj.rowIndex;
	
	
	//��ȡTable�ļ�¼��
	var objtbl=document.getElementById('tDHCBZT1');	
	var rows=objtbl.rows.length;
	//��ȡTable��ĳһ�е�ĳ��Ԫ�ص�ֵ
	//var SelRowObj=document.getElementById('Tbuyrowidz'+selectrow);	
	//var buyrowid=SelRowObj.innerText;
	//����TbuyrowidΪԪ�ص����ơAzҪ�ӵ�Ԫ�����Ƶĺ���AselectrowΪ
	//�кšF
	//�������ʾ��������SelRowObj.innerText;
	//��������ص�������SelRowObj.Value
    //alert(5)
	
	var SelRowObj=document.getElementById('billRowIdz'+selectrow);//billRowId Ϊ��ȡ�е�Ԫ�ص����� �����һ�� z
	
	mLinkId=SelRowObj.innerText;
	alert(mLinkId)
	alert(1)
	//alert(LinkId)
}
function showDetail()
{
	alert(2)
	//alert(mLinkId)
	//alert(3)
	//alert(LinkId)
	
	//var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFDeposit&Adm='+Adm+'&deposittype='+t['01']
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCBZT4&LinkId='+mLinkId;
    //alert(4)
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1000,height=700,left=0,top=0')
	//alert(3)
}


document.body.onload = BodyLoadHandler;	
