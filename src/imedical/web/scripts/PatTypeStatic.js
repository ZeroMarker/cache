 function BodyLoadHandler() {
	document.getElementById('User').value=session['LOGON.USERNAME']                                       //直接在制表人显示登录名
	//var GetDateObj=document.getElementById('EndDate');	
	//if (GetDateObj) GetDateObj.onkeydown=GetDate_Click
}

var GetStrObj=document.getElementById('StrDate');
if (GetStrObj) GetStrObj.onchange=output1;
var GetDateObj=document.getElementById('EndDate');
if (GetDateObj) GetDateObj.onchange=output2;


/*
function GetDate_Click()
{
    var GetStrDateObj=document.getElementById('StrDate').value;
	document.getElementById('StaticDate').value=GetStrDateObj
	if (window.event.keyCode==13) 	
	{
		var PrtEndDate=document.getElementById('EndDate').value
		var GetDateObj=document.getElementById('GetDate');
        if (GetDateObj) {var encmeth=GetDateObj.value} else {var encmeth=''};
        
        
        var GetDateInfo=cspRunServerMethod(encmeth,PrtEndDate)
       
        GetDateInfo=GetDateInfo.split("^")
        document.getElementById('StaticDate').value= document.getElementById('StaticDate').value+"至"+GetDateInfo[0]
        document.getElementById('MadeDate').value=GetDateInfo[1]
        document.getElementById('MadeTime').value=GetDateInfo[2]
	}
}
*/

function output1()
{
	document.getElementById('StaticDate').value=document.getElementById('StrDate').value;
}

function output2()
{
	document.getElementById('StaticDate').value=document.getElementById('StaticDate').value+"至"+document.getElementById('EndDate').value;
	datestr=new Date();
	year=datestr.getYear();
	month=datestr.getMonth()+1;
	date=datestr.getDate();
	
	var MinMilli = 1000 * 60;
    var HrMilli = MinMilli * 60;
    var DyMilli = HrMilli * 24;

	time=datestr.getTime()/DyMilli;
	minutes=datestr.getMinutes();
	seconds=datestr.getSeconds();
	document.getElementById('MadeDate').value=day+"/"+month+"/"+year
	document.getElementById('MadeTime').value=time+"/"+minutes+"/"+seconds
}

document.body.onload = BodyLoadHandler;