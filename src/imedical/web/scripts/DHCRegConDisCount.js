///DHCRegConDisCount.js
document.body.onload = BodyLoadHandler;
var SelectedRow = 0;
var myCombAry=new Array();
function BodyLoadHandler() {
	LoadPriority()
	var obj=document.getElementById("Add");
	if(obj){obj.onclick=Add_click;}
	//var obj=document.getElementById("Delete")
	//if(obj){obj.onclick=Delete_click;}
	var obj=document.getElementById("Update")
	if(obj){obj.onclick=Update_click;}
	var myobj=websys_$('StartTime');
	if (myobj) myobj.onchange=CheckStartTime;

	var myobj=websys_$('EndTime');
	if (myobj) myobj.onchange=CheckEndTime;

	
}
function CheckStartTime(){
	var myobj=websys_$('StartTime');
	CheckTime(myobj);
}
function CheckEndTime(){
	var myobj=websys_$('EndTime');
	CheckTime(myobj);
}
function CheckTime(myobj){
	var tstr=myobj.value;
	if(tstr)
	{
		var tstr_Split=tstr.split(":")
		var hour=tstr_Split[0];			
		var minuts=tstr_Split[1];
		var seconds=tstr_Split[2];	
		if (seconds==undefined) seconds="00"
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
		if (seconds>=60){
			seconds=59;
		}
		//myobj.value=hour+':'+minuts+':00';
		myobj.value=hour+':'+minuts+':'+seconds;
	}
}
function LoadPriority(){
	var Priority=DHCC_GetElementData('Priority');
	if (document.getElementById('Priority')){
		var Dem=String.fromCharCode(1)
		var PriorityStr=Dem+"^1"+Dem+"Ⅰ^2"+Dem+"Ⅱ^3"+Dem+"Ⅲ^4"+Dem+"Ⅳ"
		combo_Priority=dhtmlXComboFromStr("Priority",PriorityStr);
		myCombAry["Priority"]=combo_Priority;
		combo_Priority.enableFilteringMode(true);
		combo_Priority.selectHandle=combo_PriorityKeydownhandler;
		combo_Priority.setComboText(Priority)
		
	}
}
function combo_PriorityKeydownhandler(){
	var PriorityRowId=combo_Priority.getSelectedValue();
	DHCC_SetElementData('PriorityDr',PriorityRowId);
	
}
function Add_click(){
	var PriorityDr=DHCC_GetElementData("PriorityDr")
	if (PriorityDr==""){alert("缺少优惠级别");return;}
	var Code=DHCC_GetElementData("Code")
	if (Code==""){alert("缺少优惠Code");return;}
	var Desc=DHCC_GetElementData("Desc")
	if (Desc==""){alert("缺少优惠描述");return;}
	var StartDate=DHCC_GetElementData("StartDate")
	if (StartDate==""){alert("缺少优惠开始日期");return;}
	var StartTime=DHCC_GetElementData("StartTime")
	var EndDate=DHCC_GetElementData("EndDate")
	var EndTime=DHCC_GetElementData("EndTime")
	var Rtn=CompareDate(StartDate,EndDate)
	if (!Rtn){alert("结束日期不能小于开始日期!");return Rtn}
	var OtherDesc=DHCC_GetElementData("OtherDesc")
    var BtnAddClass=document.getElementById("AddMethod")
    if (BtnAddClass) {var encmeth=BtnAddClass.value} else {var encmeth=''};
    var returnvalue=cspRunServerMethod(encmeth,"",PriorityDr,Code,Desc,StartDate,StartTime,EndDate,EndTime,OtherDesc);
 	if(returnvalue==0) {
	 	alert("添加成功");
	 	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCRegConDisCount";
   		location.href=lnk
	 }
   else alert("添加失败")
	
	
}

function Update_click(){
	if ((SelectedRow==0)||(Rowid=="")){
		alert("请选择一行")
		return false;
	}
	var Rowid=DHCC_GetElementData("Rowid")
	var PriorityDr=DHCC_GetElementData("PriorityDr")
	if (PriorityDr==""){alert("缺少优惠级别");return;}
	var Code=DHCC_GetElementData("Code")
	if (Code==""){alert("缺少优惠Code");return;}
	var Desc=DHCC_GetElementData("Desc")
	if (Desc==""){alert("缺少优惠描述");return;}
	var StartDate=DHCC_GetElementData("StartDate")
	if (StartDate==""){alert("缺少优惠开始日期");return;}
	var StartTime=DHCC_GetElementData("StartTime")
	var EndDate=DHCC_GetElementData("EndDate")
	var EndTime=DHCC_GetElementData("EndTime")
	var Rtn=CompareDate(StartDate,EndDate)
	if (!Rtn){alert("结束日期不能小于开始日期!");return Rtn}
	var OtherDesc=DHCC_GetElementData("OtherDesc")
   var BtnAddClass=document.getElementById("AddMethod")
   if (BtnAddClass) {var encmeth=BtnAddClass.value} else {var encmeth=''};
   var returnvalue=cspRunServerMethod(encmeth,Rowid,PriorityDr,Code,Desc,StartDate,StartTime,EndDate,EndTime,OtherDesc);
 if(returnvalue==0) {
	 alert("修改成功");
	 var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCRegConDisCount";
   location.href=lnk
 }
   else alert("修改失败")
}

function SelectRowHandler()
{
	//BtnClear_Click()
	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRegConDisCount');
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;	
	var rowObj=getRow(eSrc);	
	var selectrow=rowObj.rowIndex;	
	if (!selectrow) return;
	var DetailSetLink='DetailSetz'+selectrow
	var RCDRowid=DHCC_GetColumnData("RCDRowid",selectrow);
	var RCDCode=DHCC_GetColumnData("RCDCode",selectrow);
	var RCDDesc=DHCC_GetColumnData("RCDDesc",selectrow);
	var RCDStartDate=DHCC_GetColumnData("RCDStartDate",selectrow);
	var RCDStartTime=DHCC_GetColumnData("RCDStartTime",selectrow);
	var RCDEndDate=DHCC_GetColumnData("RCDEndDate",selectrow);
	var RCDEndTime=DHCC_GetColumnData("RCDEndTime",selectrow);
	var RCDOtherDesc=DHCC_GetColumnData("RCDOtherDesc",selectrow);
	var RCDPriorityRowid=DHCC_GetColumnData("RCDPriorityRowid",selectrow);
	var RCDPriority=DHCC_GetColumnData("RCDPriority",selectrow);
	if (!selectrow) return;
	if (((SelectedRow!=0)&&(selectrow==SelectedRow))&&(eSrc.id!=DetailSetLink)){
		ClearClickHander()
		SelectedRow=0;
		return;
	}
	 
	
	DHCC_SetElementData("Rowid",RCDRowid)
	DHCC_SetElementData("Code",RCDCode.replace(/(^\s*)|(\s*$)/g,''))
	DHCC_SetElementData("Desc",RCDDesc.replace(/(^\s*)|(\s*$)/g,''))
	DHCC_SetElementData("StartDate",RCDStartDate.replace(/(^\s*)|(\s*$)/g,''))
	DHCC_SetElementData("StartTime",RCDStartTime.replace(/(^\s*)|(\s*$)/g,''))
	DHCC_SetElementData("EndDate",RCDEndDate.replace(/(^\s*)|(\s*$)/g,''))
	DHCC_SetElementData("EndTime",RCDEndTime.replace(/(^\s*)|(\s*$)/g,''))
	DHCC_SetElementData("OtherDesc",RCDOtherDesc.replace(/(^\s*)|(\s*$)/g,''))
	DHCC_SetElementData("PriorityDr",RCDPriorityRowid)
	DHCC_SetElementData("Priority",RCDPriority.replace(/(^\s*)|(\s*$)/g,''))

SelectedRow = selectrow;
   if (eSrc.id==DetailSetLink){
     var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCRegConDisCountSet&RCDRowid="+RCDRowid;
	 //var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProState&PPRowId="+PPRowId;
	 win=window.open(lnk,"DHCRegConDisCount","status=1,scrollbars=1,top=0,left=20,width=1300,height=700");
	 return false;	 
	}

}
function ClearClickHander(){
	DHCC_SetElementData("Rowid","")
	DHCC_SetElementData("Code","")
	DHCC_SetElementData("Desc","")
	DHCC_SetElementData("StartDate","")
	DHCC_SetElementData("StartTime","")
	DHCC_SetElementData("EndDate","")
	DHCC_SetElementData("EndTime","")
	DHCC_SetElementData("OtherDesc","")
	DHCC_SetElementData("PriorityDr","")
	DHCC_SetElementData("Priority","")
	
}