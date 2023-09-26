var mLinkId=0;

function BodyLoadHandler() {
	var GetPatInfoObj=document.getElementById('patno');	//获取入参登记号入参名和组件名称保持一致
	if (GetPatInfoObj) GetPatInfoObj.onkeydown=GetPatInfo_Click//根据键盘事件调用GetPatInfo_Click响应函数
	
	var clickButton = document.getElementById("FindOut");//同上
	if(clickButton)
	   clickButton.onclick=showDetail
	
	
}
function GetPatInfo_Click()
{

	
	if (window.event.keyCode==13) 
	{
	
		var PatNo=document.getElementById('patno').value
		//var GetPatObj=document.getElementById('GetInfo1');
		var GetPatObj=document.getElementById('inl');//通过组建上的隐藏元素inl的属性选项调用web.DHCBZTClass.FindPatName
        if (GetPatObj) { var encmeth=GetPatObj.value} else { var encmeth=''};//通过encmeth获得调用函数的返回值
        
        
        //var PatInfo=cspRunServerMethod(encmeth,PatNo)
       cspRunServerMethod(encmeth,'RetVal',PatNo)//调用RetVal函数来返回相关值
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
	
	
	//获取Table的记录数
	var objtbl=document.getElementById('tDHCBZT1');	
	var rows=objtbl.rows.length;
	//获取Table上某一行的某个元素的值
	//var SelRowObj=document.getElementById('Tbuyrowidz'+selectrow);	
	//var buyrowid=SelRowObj.innerText;
	//其中Tbuyrowid为元素的名称z要加到元素名称的后面selectrow为
	//行号
	//如果是显示的列则用SelRowObj.innerText;
	//如果是隐藏的列则用SelRowObj.Value
    //alert(5)
	
	var SelRowObj=document.getElementById('billRowIdz'+selectrow);//billRowId 为获取行的元素的名称 后面加一个 z
	
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
