//DHCRisAddSerGroup.js

var SelectedRow="-1"

var $=function(Id){
	return document.getElementById(Id);
}



function BodyLoadHandler()
{
	/*
	if ($("PerRwoid").value=="")
	{
		alert("参数错误!");
		return;
	}
	*/
	if ($("ArcItemRowid").value=="")
	{
		alert("参数错误!");
		return;
	}
	//alert($("PerRwoid").value);
	//alert($("ArcItemRowid").value);
	//alert($("BodyPartID").value);
	var AddObj=$("Add");
	if (AddObj)
	{
		AddObj.onclick=Add_click;
	}
	
	var DeleteObj=$("Del");
	if (DeleteObj)
	{
		DeleteObj.onclick=Delete_click;
	}
	
    //查询服务组
    QueryServiceGroup();
    GetServiceGroup();
}



function Add_click()
{
	var ServiceListObj=$("InServiceGroupName");
    if (ServiceListObj)
    {  
       
        //alert(UserListObj.value);
        var nIndex=ServiceListObj.selectedIndex;
	    if (nIndex==-1) return;
		var value=ServiceListObj.options[nIndex].value;
		var item=value.split(":");
		var Rowid=item[0];	
		var Info="^"+$("PerRwoid").value+"^"+$("ArcItemRowid").value+"^"+Rowid+"^"+$("BodyPartID").value
		//alert(Info);
		//return;
		SaveSet(Info,"I");
		GetServiceGroup();	
    }
}

function Delete_click()
{	
	var SelRecLocListObj=$("SelServiceGroupList");
	if (SelRecLocListObj)
	{
	    //alert(SelLocObj.value);
	    var nIndex=SelRecLocListObj.selectedIndex;
	    if (nIndex==-1) return;
		var value=SelRecLocListObj.options[nIndex].value;
		var item=value.split(":");
		//alert(item);
		//return;
		var Rowid=item[1];	
		
		var Info="^"+$("PerRwoid").value+"^"+$("ArcItemRowid").value+"^"+Rowid+"^"+$("BodyPartID").value	
	  
	   // var Info=Rowid+"^^^"
	    SaveSet(Info,"D");
	    GetServiceGroup();	 
	}   
	
}


//查询服务组
function QueryServiceGroup()
{
    InServiceGroupNameObj=document.getElementById("InServiceGroupName");
    if (InServiceGroupNameObj)
    {
	 	combo("InServiceGroupName");
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

function GetServiceGroup()
{
	
	//获取医嘱项目关注的服务组
    var AdmLocFun=document.getElementById("GetItmServiceGroup").value;
    var PABIDValue=$("PerRwoid").value+"^"+$("ArcItemRowid").value+"^"+$("BodyPartID").value;
	var Info1=cspRunServerMethod(AdmLocFun,PABIDValue);
	
	AddItem("SelServiceGroupList",Info1);

}


//函数
function SaveSet(Info,OperateCode)
{
	var SaveUserSetFun=$("SaveFun").value;
	var value=cspRunServerMethod(SaveUserSetFun,Info,OperateCode);
	
	var Info="";
	if (value!="0")
	{  
	     if(OperateCode=="I")
	     {
		     if (value=="100")
		     {
			     Info="不能重复添加!";
			 }
		     else
		     {
			     Info="增加失败:返回值="+value;
		     }
		    
		 }
	     if(OperateCode=="U")
	     {
		    Info="更新失败:返回值="+value;
		 }
		 if(OperateCode=="D")
		 {
			
			Info="删除失败:返回值="+value;
			
	     }
	     alert(Info);
	     return;	 
		
	}
	/*else
	{   
   		window.location.reload();
	}*/
}


document.body.onload = BodyLoadHandler;


