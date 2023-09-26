var buyrowid=0;
function BodyLoadHandler() {
	var GetPatInfoObj=document.getElementById('PatNo');	
	if (GetPatInfoObj) GetPatInfoObj.onkeydown=GetPatInfo_Click
    
    var clickButton = document.getElementById("Detail");
	if(clickButton)
	   clickButton.onclick=GetDetail
}
function GetPatInfo_Click()
{
	if (window.event.keyCode==13) 
	{
		var PatNo=document.getElementById('PatNo').value
		var GetPatObj=document.getElementById('GetPatInfo');
        if (GetPatObj) {var encmeth=GetPatObj.value} else {var encmeth=''};
        
        
        var PatInfo=cspRunServerMethod(encmeth,PatNo)
       
        PatInfo=PatInfo.split("^")
        document.getElementById('PatName').value=PatInfo[0]
        document.getElementById('PatSex').value=PatInfo[1]
	}
}

function SelectRowHandler()
{
	//获取到选中的行
	var eSrc=window.event.srcElement;
    var rowObj=getRow(eSrc);
    var selectrow=rowObj.rowIndex;
    //获取Table的记录数
    //自己加小写 t
    var objtbl=document.getElementById('tDHCTang');	
    var rows=objtbl.rows.length;
    //获取Table上某一行的某个元素的值
    //自己加小写 z
    var SelRowObj=document.getElementById('BillIdz'+selectrow);
    buyrowid=SelRowObj.innerText;
    //alert(buyrowid)
}

function GetDetail()
{
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCTTao&BillId='+buyrowid;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1000,height=700,left=0,top=0')
}

document.body.onload = BodyLoadHandler;	
