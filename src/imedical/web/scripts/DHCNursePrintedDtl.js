var myData=new Array();

function BodyLoadHandler()
{
	var schobj=document.getElementById("printbut");
    if (schobj) {schobj.onclick=PrintClick;}
}
function PrintClick()
{
	var querytyp=document.getElementById("querytyp");
	var RpDes=document.getElementById("RpDes").value;
	RpDes=unescape(RpDes);
	GetPrintedData();
	PrintRp(querytyp.value,"select",RpDes);
}
function GetPrintedData()
{
	var GetTmpData=document.getElementById("GetTmpPrintedData").value;
    var GetTmpDataNum=document.getElementById("GetTmpPrintedDataNum").value;
    //qse add 061214
    var userId=session['LOGON.USERID'];
    var TmpNum=cspRunServerMethod(GetTmpDataNum,userId);
    for (j=1;j<=TmpNum;j++)
    {
		var item=cspRunServerMethod(GetTmpData,userId,j);
		var itemData=item.split("!")
		myData[j-1]=itemData;
	}

}



document.body.onload = BodyLoadHandler;