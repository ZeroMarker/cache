
//名称	DHCPEUpdateCheckDate .js
//功能	预约日期修改
//组件	DHCPEUpdateCheckDate 	
//创建	2018.08.30
//创建人  xy
document.body.onload = BodyLoadHandler;
function BodyLoadHandler()
{
	var obj;
	obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_click;
}
function BUpdate_click()
{
	var obj,NewDate="",encmeth="",PreIADM="",NewTime="";
	
	var NewDate=getValueById("NewDate")
	if (NewDate==""){
		$.messager.alert("提示","请输入修改日期","info");
		return false;
	}

	var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat");
	 if (dtformat=="YMD"){
		  var iNewDate=NewDate.split("-")[0];
		  
	  }
	  if (dtformat=="DMY"){
		 var iNewDate=NewDate.split("/")[2];
		 
	  }
	  

	if(iNewDate<1841){
		$.messager.alert('提示','修改日期不能小于1841年!',"info"); 
		return false;
	}

var NewTime=getValueById("NewTime")
	if (NewTime!=""){
		if(NewTime.indexOf(":")=="-1"){
			$.messager.alert("提示","时间格式不正确","info");
			return false;
		}
		if(NewTime.indexOf(":")!="-1"){
		if((NewTime.split(":")[0]>=24)||(NewTime.split(":")[1]>59)||(NewTime.split(":")[2]>59)){
			$.messager.alert("提示","时间格式不正确","info");
			return false;
			}
		}
	}

	obj=document.getElementById("OtherInfo");
	OtherInfo=obj.value;
	var Arr=OtherInfo.split("^");
	var GIType=Arr[1];
	if (GIType=="I")
	{
		var Level=Arr[0];
		var obj=document.getElementById('IsCanPreClass');
		if (obj){
			var IsClass=obj.value;
			var LocID=session['LOGON.CTLOCID'];
			var flag=cspRunServerMethod(IsClass,NewDate,LocID,Level,"I",NewTime);
			var Arr=flag.split("^");
			if (Arr[0]=="0"){
				if (!confirm(Arr[1])) return false;
			}
		}
	}
	
	NewDate=NewDate+"^"+NewTime;
	
	obj=document.getElementById("PreIADM");
	if (obj) PreIADM=obj.value;
	obj=document.getElementById("UpdateClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,PreIADM,NewDate);
	if (ret=="0"){ 
		$.messager.alert("提示","修改成功","success"); 
	    window.close();
	    window.parent.parent.opener.location.reload();
	    }
}
function SetPreDate(NewDateStr)
{
	var obj=document.getElementById("NewDate");
	if (obj) obj.value=NewDateStr;
}