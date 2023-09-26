

function BodyLoadHandler() {
	
var myobj=$('TRStartTime');
if (myobj) myobj.onchange=CheckTRStartTime;

var myobj=$('TRCancelTime');
if (myobj) myobj.onchange=CheckTRCancelTime;

var myobj=$('TREndTime');
if (myobj) myobj.onchange=CheckTREndTime;

var myobj=$('TRReturnTime');  
if (myobj) myobj.onchange=CheckTRReturnTime;

var myobj=$('TRValidStartDate');
if (myobj){ 	myobj.onchange=TRValidStartDate_change;} 

var myobj=$('TRValidEndDate');
if (myobj) {	myobj.onchange=TRValidEndDate_change;}

quickK.f8=BtnSearch_click;
quickK.addMethod();
   
document.onkeydown=websys_enternextfocus;

$('BtnClear').onclick = BtnClear_Click;

$('BtnUpdate').onclick = BtnUpdate_Click;

$('BtnAdd').onclick = BtnAdd_Click;

//$('BtnDelete').onclick = BtnDelete_Click;
}


function TRValidEndDate_change(){
	var mydate=DHCWebD_GetObjValue("TRValidEndDate");
	if ((mydate.length!=0)&&(mydate.length!=8)&&(mydate.length!=10)){
		var obj=$("TRValidEndDate");
		obj.className='clsInvalid';
		websys_setfocus("TRValidEndDate");
		return websys_cancel();
	}else{
		var obj=$("TRValidEndDate");
		obj.className='clsvalid';
	}
	if (mydate.length==8){
		var mydate=mydate.substring(6,8)+"/"+mydate.substring(4,6)+"/"+mydate.substring(0,4)
		DHCWebD_SetObjValueA("TRValidEndDate",mydate);
	}	
	if(mydate.length!=0)
	{
	   var myrtn=DHCWeb_IsDate(mydate,"/")
	   if (!myrtn)
	   {
		    var obj=$("TRValidEndDate");
		    obj.className='clsInvalid';
		    websys_setfocus("TRValidEndDate");
		    return websys_cancel();
	   }
	   else{
		   var obj=$("TRValidEndDate");
		   obj.className='clsvalid';
	   }
  }
  else
  	{
  		var obj=$("TRValidEndDate");
		   obj.className='clsvalid';
  	}	
}

function TRValidStartDate_change(){
	var mydate=DHCWebD_GetObjValue("TRValidStartDate");
	if ((mydate=="")||((mydate.length!=8)&&((mydate.length!=10)))){
		var obj=$("TRValidStartDate");
		obj.className='clsInvalid';
		websys_setfocus("TRValidStartDate");
		return websys_cancel();
	}else{
		var obj=$("TRValidStartDate");
		obj.className='clsvalid';
	}	
	
	if ((mydate.length==8)){
		var mydate=mydate.substring(6,8)+"/"+mydate.substring(4,6)+"/"+mydate.substring(0,4)
		DHCWebD_SetObjValueA("TRValidStartDate",mydate);
	}
	////alert(mydate);
	
	var myrtn=DHCWeb_IsDate(mydate,"/")
	if (!myrtn){
		var obj=$("TRValidStartDate");
		obj.className='clsInvalid';
		websys_setfocus("TRValidStartDate");
		return websys_cancel();
	}else{
		var obj=$("TRValidStartDate");
		obj.className='clsvalid';
	}	
}
function CheckTime(myobj)
{
  var tstr=myobj.value;
	if(tstr)
	{
		var tstr_Split=tstr.split(":")
		var hour=tstr_Split[0];			
		var minuts=tstr_Split[1];		
		if(minuts)
		{			
			if(minuts.length >2)
			 {	
			 	  minuts=minuts.substring(0,2);				 	  		 	  
			 }
			 else if(minuts.length==1)
			 {
			 			minuts='0'+minuts;
			 }
			 if(hour.length >2)
			 {
			 	  hour=hour.substring(0,2);			 	  
			 }
			 else if(hour.length==1)
				{
					hour='0'+hour;
				}
		}
		else 
			{			
			switch(hour.length)
			{
				case 1: {hour='0'+hour;minuts='00';break;}
				case 2: {minuts='00';break;}
				case 3: {minuts=hour.substring(2,4);hour=hour.substring(0,2);minuts='0'+minuts;break;}
				case 4: {minuts=hour.substring(2,4);hour=hour.substring(0,2);break;}
			}
		}
		if(hour>=24)
		{
			hour=23;
		}
		if(minuts>=60)
		{
			minuts=59;
		}
		myobj.value=hour+':'+minuts+':00';
	}
}
function CheckTRReturnTime()
{
	var myobj=$('TRReturnTime');
	CheckTime(myobj);		
}

function CheckTREndTime()
{
	var myobj=$('TREndTime');
	CheckTime(myobj);
}
function CheckTRStartTime()
{
	var myobj=$('TRStartTime');
	CheckTime(myobj);
}

function CheckTRCancelTime()
{
	var myobj=$('TRCancelTime');
	CheckTime(myobj);
} 

function BtnClear_Click()
{
	$('ID').value = '';
  $('TRCancelTime').value = '';
  $('TRCode').value = '';
  $('TRDesc').value = '';
  $('TREndTime').value = '';
  $('TRReturnTime').value = '';
  $('TRStartTime').value = '';
  $('TRValidEndDate').value = '';
  $('TRValidStartDate').value = '';
  
  $('BtnUpdate').disabled=true;
  $('BtnAdd').disabled=false;
  $('BtnClear').disabled=true;
}

function BtnAdd_Click() {  
   var rtn=CheckNull();
    if (!rtn){
	    return false;
    } 

//构造服务端解析对象
var ParseInfo="TransContent^ID^TRCancelTime^TRCode^TRDesc^TREndTime^TRReturnTime^TRStartTime^TRValidEndDate^TRValidStartDate";
var DHCTimeRange=DHCDOM_GetEntityClassInfoToXML(ParseInfo);
//alert(DHCTimeRange);

//调用服务端方法
var BtnAddclass=$('BtnAddclass');
if (BtnAddclass) {var encmeth=BtnAddclass.value} else {var encmeth=''};
var returnvalue=cspRunServerMethod(encmeth,DHCTimeRange);
  
  if(returnvalue=='10')
	{
		alert(t['10']); //"代码或名称已经存在");
		$('TRCode').focus();
	}
	if(returnvalue!='-100' && returnvalue!='10')
	{
			alert(t['4']);
	}
	else
	{
		  alert(t['5']);
	}
	

BtnAdd_click();
//BtnClear_Click();
}

function BtnUpdate_Click() {
  
   var rtn=CheckNull();
    if (!rtn){
	    return false;
    }

//构造服务端解析对象
var ParseInfo="TransContent^ID^TRCancelTime^TRCode^TRDesc^TREndTime^TRReturnTime^TRStartTime^TRValidEndDate^TRValidStartDate";
var DHCTimeRange=DHCDOM_GetEntityClassInfoToXML(ParseInfo);
//alert(DHCTimeRange);

//调用服务端方法
var BtnUpdateclass=$('BtnUpdateclass');
if (BtnUpdateclass) {var encmeth=BtnUpdateclass.value} else {var encmeth=''};
var returnvalue=cspRunServerMethod(encmeth,DHCTimeRange);

  if(returnvalue!='-100')
	{
			alert(t['6']);
	}
		else
	  {
		  alert(t['7']);
	  }


BtnUpdate_click();

//$('BtnClear').disabled=false;
//$('BtnUpdate').disabled=true;
}

function BtnDelete_Click() {
  
//构造服务端解析对象
var ParseInfo="TransContent^ID^TRCancelTime^TRCode^TRDesc^TREndTime^TRReturnTime^TRStartTime^TRValidEndDate^TRValidStartDate";
var DHCTimeRange=DHCDOM_GetEntityClassInfoToXML(ParseInfo);
//alert(DHCTimeRange);

//调用服务端方法
var BtnDeleteclass=$('BtnDeleteclass');
if (BtnDeleteclass) {var encmeth=BtnDeleteclass.value} else {var encmeth=''};
var returnvalue=cspRunServerMethod(encmeth,DHCTimeRange);

  if(returnvalue!='-100')
	{
		alert(t['8']);
	}
	else
	{
		alert(t['9']);
	}

//BtnDelete_click();
//BtnClear_Click();
//BtnSearch_click();
}

var SelectedRow = 0;
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=$('tDHCTimeRangeConfig');
	if(!objtbl)
	{
	   objtbl=$('tDHCTimeRangeConfig0');
	}
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;	
	var rowObj=getRow(eSrc);	
	var selectrow=rowObj.rowIndex;
	
	if (!selectrow) return;

	
 var ID=$('ID');

 var TRCancelTime=$('TRCancelTime');

 var TRCode=$('TRCode');

 var TRDesc=$('TRDesc');

 var TREndTime=$('TREndTime');

 var TRReturnTime=$('TRReturnTime');

 var TRStartTime=$('TRStartTime');
 
 var TRValidEndDate=$('TRValidEndDate');

 var TRValidStartDate=$('TRValidStartDate');

	
	
var Sel_TID=$('TIDz'+selectrow);

var Sel_TTRCancelTime=$('TTRCancelTimez'+selectrow);

var Sel_TTRCode=$('TTRCodez'+selectrow);

var Sel_TTRDesc=$('TTRDescz'+selectrow);

var Sel_TTREndTime=$('TTREndTimez'+selectrow);

var Sel_TTRReturnTime=$('TTRReturnTimez'+selectrow);

var Sel_TTRStartTime=$('TTRStartTimez'+selectrow);

var Sel_TTRValidEndDate=$('TTRValidEndDatez'+selectrow);

var Sel_TTRValidStartDate=$('TTRValidStartDatez'+selectrow);


	if (rowObj.className != 'clsRowSelected')
	{
	$('BtnUpdate').disabled=true;	
	$('BtnClear').disabled=true;	
ID.value = '';

TRCancelTime.value = '';

TRCode.value = '';

TRDesc.value = '';

TREndTime.value = '';

TRReturnTime.value = '';

TRStartTime.value = '';

TRValidEndDate.value = '';

TRValidStartDate.value = '';

	}
	else
	{
	$('BtnUpdate').disabled=false;	
	$('BtnClear').disabled=false;	
ID.value = Sel_TID.value;

if (Sel_TTRCancelTime.innerText==" "){	TRCancelTime.value = "";}
else	{    TRCancelTime.value = Sel_TTRCancelTime.innerText;  }

TRCode.value = Sel_TTRCode.innerText;

TRDesc.value = Sel_TTRDesc.innerText;

if (Sel_TTREndTime.innerText==" "){TREndTime.value = "";}
else {TREndTime.value = Sel_TTREndTime.innerText;}

if(Sel_TTRReturnTime.innerText==" "){TRReturnTime.value = ""}
else{TRReturnTime.value = Sel_TTRReturnTime.innerText;}

if (Sel_TTRStartTime.innerText==" "){TRStartTime.value = "";}
else{TRStartTime.value = Sel_TTRStartTime.innerText;}

if (Sel_TTRValidEndDate.innerText==" "){   TRValidEndDate.value = "";}
else	{			TRValidEndDate.value = Sel_TTRValidEndDate.innerText;	}
	
if (Sel_TTRValidStartDate.innerText==" "){	   TRValidStartDate.value = "";}
else	{			TRValidStartDate.value = Sel_TTRValidStartDate.innerText;	}		
	}
SelectedRow = selectrow;

}

//验证必填字段
function CheckNull(){

if ($('TRCode').value=="")
{
	alert(t['2']);
	$('TRCode').focus();
	return false;
}	

if ($('TRDesc').value=="")
{
	alert(t['3']);
	$('TRDesc').focus();
	return false;
}	

if ($('TRCancelTime').value=="")
{
	alert('退号时间点不能为空!');
	$('TRCancelTime').focus();
	return false;
}	

if ($('TRReturnTime').value=="")
{
	alert('预约号回归时间点不能为空!');
	$('TRReturnTime').focus();
	return false;
}	

if ($('TRStartTime').value=="")
{
	alert('出诊开始时间不能为空!');
	$('TRStartTime').focus();
	return false;
}	

if ($('TREndTime').value=="")
{
	alert('出诊结束时间不能为空!');
	$('TREndTime').focus();
	return false;
}	

	return true;
}

document.body.onload = BodyLoadHandler;