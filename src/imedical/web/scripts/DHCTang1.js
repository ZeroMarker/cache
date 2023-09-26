var buyrowid;
function SelectRowHandler()
{
	//获取到选中的行
	var eSrc=window.event.srcElement;	
    var rowObj=getRow(eSrc);
    var selectrow=rowObj.rowIndex;
    //获取Table的记录数
    var objtbl=document.getElementById('DHCTang');	
    var rows=objtbl.rows.length;
    //获取Table上某一行的某个元素的值
    var SelRowObj=document.getElementById('BillIdz'+selectrow);	
    var buyrowid=SelRowObj.innerText;
    alert 
    var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCTTao&BillId='+buyrowid+'&deposittype='+t['01']
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1000,height=700,left=0,top=0')
}