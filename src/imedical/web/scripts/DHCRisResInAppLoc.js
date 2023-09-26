//DHCRisResInAppLoc.js
//sunyi 2014-04-13
var SelectedRow="-1"

function BodyLoadHandler()
{
	var AddObj=document.getElementById("Add");
	if (AddObj)
	{
		AddObj.onclick=Add_click;
	}
	
	var DeleteObj=document.getElementById("Del");
	if (DeleteObj)
	{
		DeleteObj.onclick=Delete_click;
	}
	
	var ModiObj=document.getElementById("Update");
	if (ModiObj)
	{
		ModiObj.onclick=Modi_click;
	}
	var QueryObj=document.getElementById("Query");
	if (QueryObj)
	{
		QueryObj.onclick=Query_click;
	}
	var ClearObj=document.getElementById("Clear");
	if (ClearObj)
	{
		ClearObj.onclick=Clear_click;
	}
    initAppLoc();	
    initServiceGroup();
    initRes();
		
}

function Add_click()
{
	 var OperateCode="I";
	 var Rowid="";
	 var AppLocObj=document.getElementById("SelAppLocList");
	 if (AppLocObj)
	 {
		 var AppLocDR=AppLocObj.value;
		 var AppLoc=AppLocObj.text;
	 }
	 
	 var SerGroupObj=document.getElementById("InServiceGroupName");
	 if (SerGroupObj)
	 {
		 var SerGroupDR=SerGroupObj.value;
		 var SerGroup=SerGroupObj.text;
	 }
	 var ResObj=document.getElementById("Resource");
	 if (ResObj)
	 {
		 var ResDR=ResObj.value;
		 var Res=ResObj.text;
	 }
	 
	
	 if((SerGroupDR=="")||(ResDR==""))
	 {
		 var error="所有项目必须填写!";
		 alert(error);
		 return ;
	 }
	  
	 var Info=Rowid+"^"+AppLocDR+"^"+SerGroupDR+"^"+ResDR;
	 //alert(Info);
	 ResInAppLocSet(Info,OperateCode);
	
	
}

function Delete_click()
{
	var OperateCode="D"
	var SelRowid=document.getElementById("SelRowid").value;
	
	if (SelRowid=="")
	{
		alert("未选择记录不能删除!")
		return;
		
	}
	
	var str="^^^";
    var Info=SelRowid+str;
    ResInAppLocSet(Info,OperateCode);
	
}

function Modi_click()
{
	 var SelRowid=document.getElementById("SelRowid").value;
	 var OperateCode="U";
	
	 if (SelRowid=="")
	 {
		alert("未选择记录不能更新!")
		return;	
	 }
	
	 var AppLocObj=document.getElementById("SelAppLocList");
	 if (AppLocObj)
	 {
		 var AppLocDR=AppLocObj.value;
		 var AppLoc=AppLocObj.text;
	 }
	  
	 var SerGroupObj=document.getElementById("InServiceGroupName");
	 if (SerGroupObj)
	 {
		 var SerGroupDR=SerGroupObj.value;
		 var SerGroup=SerGroupObj.text;
	 }
	 var ResObj=document.getElementById("Resource");
	 if (ResObj)
	 {
		 var ResDR=ResObj.value;
		 var Res=ResObj.text;
	 }
	 
	 
	 if((SerGroupDR=="")||(ResDR==""))
	 {
		 var error="所有项目必须填写!";
		 alert(error);
		 return ;
	 }
	  
	 var Info=SelRowid+"^"+AppLocDR+"^"+SerGroupDR+"^"+ResDR;
	 ResInAppLocSet(Info,OperateCode);
	
}

function Query_click()
{
	 var AppLocObj=document.getElementById("SelAppLocList");
	 if (AppLocObj)
	 {
		 var AppLocDR=AppLocObj.value;
		 var AppLoc=AppLocObj.text;
	 }
	  
	 var SerGroupObj=document.getElementById("InServiceGroupName");
	 if (SerGroupObj)
	 {
		 var SerGroupDR=SerGroupObj.value;
		 var SerGroup=SerGroupObj.text;
	 }
	 var ResObj=document.getElementById("Resource");
	 if (ResObj)
	 {
		 var ResDR=ResObj.value;
		 var Res=ResObj.text;
	 }
	 
	 
	 var Info=AppLocDR+"^"+SerGroupDR+"^"+ResDR;
	
	 location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisResInAppLoc"+"&Info="+Info;
}

function Clear_click()
{
	 var AppLocObj=document.getElementById("SelAppLocList");
	 if (AppLocObj)
	 {
		 AppLocObj.value="";
		 AppLocObj.text="";
	 }
	 var SerGroupObj=document.getElementById("InServiceGroupName");
	 if (SerGroupObj)
	 {
		 SerGroupObj.value="";
		 SerGroupObj.text="";
	 }
	 var ResObj=document.getElementById("Resource");
	 if (ResObj)
	 {
		 ResObj.value="";
		 ResObj.text="";
	 }
	 //Query_click();
		
		
}

function SelectRowHandler()
{
	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisResInAppLoc');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	
	if (!selectrow) return;
	if (SelectedRow!=selectrow)
	{   
	    var SerGroup=document.getElementById("ServiceGroupz"+selectrow).innerText;
	    var Res=document.getElementById("Resz"+selectrow).innerText;
	    var SerGroupDR=document.getElementById("ServiceGroupDRz"+selectrow).value;
	    var ResDR=document.getElementById("ResourceDRz"+selectrow).value;
	    var AppLoc=document.getElementById("AppLocz"+selectrow).innerText;
	    var AppLocDR=document.getElementById("AppLocDRz"+selectrow).value;
	    var SelRowid=document.getElementById("Rowidz"+selectrow).value;
		
		var SeleRowidObj=document.getElementById("SelRowid");
		if (SeleRowidObj)
		{
			SeleRowidObj.value=SelRowid;
		}
		var AppLocObj=document.getElementById("SelAppLocList");
		if (AppLocObj)
		{
			AppLocObj.value=AppLocDR;
			AppLocObj.text=AppLoc;
		}
		var SerGroupObj=document.getElementById("InServiceGroupName");
		if (SerGroupObj)
		{
			SerGroupObj.value=SerGroupDR;
			SerGroupObj.text=SerGroup;
			
			 
			if(SerGroupDR!="")
		    {
			   var ResourceObj=document.getElementById("Resource");
		       if (ResourceObj)
		       {
				   combo("Resource");
	 		       var GetResListFunction=document.getElementById("GetResListFun").value;
			       var ResList=cspRunServerMethod(GetResListFunction,SerGroupDR);
	    	       AddItem("Resource",ResList);
	    	       
	    	       ResourceObj.value=ResDR;
			       ResourceObj.text=Res;
		       }
    	       
		    }
		}
		
		
		SelectedRow = selectrow;
	
	}
	else
	{
		SelectedRow="-1"
		Clear_click()
	}
	
}



//初始化接收信息
function initServiceGroup()
{
    var Obj=document.getElementById("InServiceGroupName");
    if (Obj)
    {
 		combo("InServiceGroupName");
    	Obj.onchange=changeServiceGroup;
    }
}
//初始化排班配置的预约资源
function initRes()
{
   var Obj=document.getElementById("Resource");
   if (Obj)
   {
     combo("Resource");
   }
}

//初始登陆室信息
function initAppLoc()
{
    var Obj=document.getElementById("SelAppLocList");
    if (Obj)
    {
 		combo("SelAppLocList");
		var AppLocFunction=document.getElementById("AppLocListFun").value;
		var Info1=cspRunServerMethod(AppLocFunction);
    	AddItem("SelAppLocList",Info1);
    }
}

function combo(cmstr)
{
	var obj=document.getElementById(cmstr);
	obj.size=1; 
	obj.multiple=false;
}

function AddItem(ObjName, Info)
{
	var Obj=document.getElementById(ObjName);
    if (Obj.options.length>0)
 	{
		for (var i=Obj.options.length-1; i>=0; i--) Obj.options[i] = null;
	}
	
    var ItemInfo=Info.split("^");
 	for (var i=0;i<ItemInfo.length;i++)
 	{
	 	perInfo=ItemInfo[i].split(String.fromCharCode(1))
	 	var sel=new Option(perInfo[1],perInfo[0]);
	    Obj.options[Obj.options.length]=sel;
	} 
}

function changeServiceGroup()
{
	var SerGroupObj=document.getElementById("InServiceGroupName");
	if (SerGroupObj)
	{
		var GroupID=SerGroupObj.value;
		if(GroupID!="")
		{
			 var Obj=document.getElementById("Resource");
             if (Obj)
             {
 		       combo("Resource");
 		       var GetResListFunction=document.getElementById("GetResListFun").value;
		       var ResList=cspRunServerMethod(GetResListFunction,GroupID);
    	       AddItem("Resource",ResList);
             }
		}
 	}
}

function ResInAppLocSet(Info,OperateCode)
{
	var ResInAppLoc=document.getElementById("ResInAppLocFun").value;
	var value=cspRunServerMethod(ResInAppLoc,Info,OperateCode);
	if (value!="0")
	{  
	     if(OperateCode=="I")
	     {
		    if (value==-1)
		    {
			    var Info="资源已在其他科室使用不能增加!";
			}else
			{
		        var Info="增加失败:SQLCODE="+value;
			}
		 }
	     else if(OperateCode=="U")
	     {
		    var Info="更新失败:SQLCODE="+value;
		 }
		 else
		 {
			var Info="删除失败:SQLCODE="+value;
	     }	 
		
	     alert(Info);
	}
	else
	{   
		/*var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisAppLocResourceList";
   		location.href=lnk; */
   		window.location.reload();
	}
	
}

document.body.onload = BodyLoadHandler;


