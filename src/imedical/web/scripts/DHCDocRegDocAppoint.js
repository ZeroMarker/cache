document.body.onload = BodyLoadHandler;
function BodyLoadHandler(){
	IntList()
	var obj=document.getElementById("Save")
	if (obj){
		obj.onclick=SaveClick;
	}
	
}

function SaveClick()
{
	//选择预约
	var ResStr=""
	var objApp=document.getElementById("SelectApp")
	{
		var ResLengthApp=objApp.length
		for (var j=0;j<ResLengthApp;j++)
		{
			var ResDr=objApp.options[j].value;
			if (ResStr==""){ResStr=ResDr}
			else(ResStr=ResStr+"^"+ResDr)
		}
	}
	//选择科室
	var FindLoc=0
	var obj=document.getElementById("RegLoc")
	{
		var RegLength=obj.length
		for (var i=0;i<RegLength;i++)
		{
			if (obj.options[i].selected){
				FindLoc=1
				var RegLocID=obj.options[i].value;
				var Rtn=tkMakeServerCall("web.DHCBL.Doctor.AppointOral","SetUserCanDo",RegLocID,ResStr)
			}
		}	
	}
	if (FindLoc==0){alert("请选择需要维护权限的挂号科室!");return false}
	alert("OK")
	
	
}


function IntList()
{
	
	//就诊科室
	var obj=document.getElementById("RegLoc")
	{
		obj.size=20;
		obj.multiple=true;
		obj.length=0
		obj.onclick=RegLocDb_Click //RegLoc_Click;
		//obj.ondblclick=RegLocDb_Click;
		
		var LocStr=tkMakeServerCall("web.DHCBL.Doctor.AppointOral","GetSetLoc","O^E^I")
		var LocStrArry=LocStr.split("^")
		for (var i=0;i<LocStrArry.length;i++)
		{
			var SubArry=LocStrArry[i].split("!")
			var varItem = new Option(SubArry[1],SubArry[0]);
			obj.options.add(varItem);
			
		}
	}
	//预约科室
	var obj=document.getElementById("AppLoc")
	{
		obj.size=20;
		obj.multiple=false;
		obj.length=0
		obj.onclick=AppLoc_Click;
		
		var LocStr=tkMakeServerCall("web.DHCBL.Doctor.AppointOral","GetSetLoc","O^E")
		var LocStrArry=LocStr.split("^")
		for (var i=0;i<LocStrArry.length;i++)
		{
			var SubArry=LocStrArry[i].split("!")
			var varItem = new Option(SubArry[1],SubArry[0]);
			obj.options.add(varItem);
			
		}
	}
	///可挂资源
	var obj=document.getElementById("AppMark")
	{
		obj.size=20;
		obj.multiple=false;
		obj.length=0
		obj.ondblclick=AppMark_Click;
	}
	
	//已经选择的预约资源
	var obj=document.getElementById("SelectApp")
	{
		obj.size=20;
		obj.multiple=false;
		obj.length=0
		obj.ondblclick=SelectApp_Click;
	}
	
	

}
function RegLoc_Click()
{
	
	
}

///查看挂号科室对应了那些权限
function RegLocDb_Click()
{
	var obj=document.getElementById("RegLoc")
	var RegLocID=obj.value
	var ResStr=tkMakeServerCall("web.DHCBL.Doctor.AppointOral","GetAppCanDo",RegLocID)
	var obj=document.getElementById("SelectApp")
	obj.length=0
	var obj1=document.getElementById("AppLoc")
	obj1.selectedIndex=-1
	var obj2=document.getElementById("AppMark")
	obj2.selectedIndex=-1
	obj2.length=0;
	if (ResStr!=""){
		var LocStrArry=ResStr.split("^")
		for (var i=0;i<LocStrArry.length;i++)
		{
			var SubArry=LocStrArry[i].split("!")
			var varItem = new Option(SubArry[1],SubArry[0]);
			obj.options.add(varItem);
		}
	}
	
}
function AppLoc_Click()
{
	var LocID=document.getElementById("AppLoc").value
	var obj=document.getElementById("AppMark")
	{
		obj.size=20;
		obj.multiple=false;
		obj.length=0
		var LocStr=tkMakeServerCall("web.DHCBL.Doctor.AppointOral","GetRBResDr",LocID)
		var LocStrArry=LocStr.split("^")
		for (var i=0;i<LocStrArry.length;i++)
		{
			var SubArry=LocStrArry[i].split("!")
			var varItem = new Option(SubArry[1],SubArry[0]);
			obj.options.add(varItem);
			
		}
		
	}

	
}
function AppMark_Click()
{
	var ObjAppLoc=document.getElementById("AppLoc")
	var obj=document.getElementById("AppMark")
	var Desc=obj.options[obj.selectedIndex].text
	var RBASDr=obj.options[obj.selectedIndex].value
	var obj=document.getElementById("SelectApp")
	for (var i=0;i<obj.length;i++){
		if (obj[i].value==RBASDr){
			alert("预约号别"+Desc+"已在已选号序列中");
			return false;
		}
	}
	var varItem = new Option(ObjAppLoc.options[ObjAppLoc.selectedIndex].text+"-"+Desc,RBASDr);
	obj.options.add(varItem);
	
}

function SelectApp_Click()
{
	var obj=document.getElementById("SelectApp")
	obj.options.remove(obj.selectedIndex)	
}