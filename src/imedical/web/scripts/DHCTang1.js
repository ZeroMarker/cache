var buyrowid;
function SelectRowHandler()
{
	//��ȡ��ѡ�е���
	var eSrc=window.event.srcElement;	
    var rowObj=getRow(eSrc);
    var selectrow=rowObj.rowIndex;
    //��ȡTable�ļ�¼��
    var objtbl=document.getElementById('DHCTang');	
    var rows=objtbl.rows.length;
    //��ȡTable��ĳһ�е�ĳ��Ԫ�ص�ֵ
    var SelRowObj=document.getElementById('BillIdz'+selectrow);	
    var buyrowid=SelRowObj.innerText;
    alert 
    var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCTTao&BillId='+buyrowid+'&deposittype='+t['01']
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1000,height=700,left=0,top=0')
}