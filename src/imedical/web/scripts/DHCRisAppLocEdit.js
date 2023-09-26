//DHCRisAppLocEdit.js

var SelectedRow="-1"

var $=function(Id){
	return document.getElementById(Id);
}

function BodyLoadHandler()
{
	
	//alert($("ArcItemRowid").value)
	if ($("ArcItemRowid").value=="")
	{
		alert("��������!");
		return;
	}
	
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
	
    //��ѯ�������
    QueryAppLoc();
    GetLoc();
}



function Add_click()
{
	var AppLocListObj=$("AppLocList");
    if (AppLocListObj)
    {  
       
        //alert(UserListObj.value);
        var nIndex=AppLocListObj.selectedIndex;
	    if (nIndex==-1) return;
		var value=AppLocListObj.options[nIndex].value;
		var item=value.split(":");
		//alert(item)
		var Rowid=item[0];
		//alert(Rowid);	
		var Info="^"+$("ArcItemRowid").value+"^"+Rowid
		SaveAppLocSet(Info,"I");
		GetLoc();	
    }
}

function Delete_click()
{	
	var SelAppLocListObj=$("SelAppLocList");
	if (SelAppLocListObj)
	{
	    //alert(SelLocObj.value);
	    var nIndex=SelAppLocListObj.selectedIndex;
	    if (nIndex==-1) return;
		var value=SelAppLocListObj.options[nIndex].value;
		var item=value.split(":");
		//alert(item);
		var Rowid=item[0];
		//alert(Rowid);		
	    var Info=Rowid+"^^"
	    SaveAppLocSet(Info,"D");
	    GetLoc();	 
	}   
	
}


//��ѯ�������
function QueryAppLoc()
{
    var UserObj=document.getElementById("AppLocList");
    if (UserObj)
    {
 		combo("AppLocList");
		var FindRetinueFunction=$("AppLocListFun").value;
		var Info1=cspRunServerMethod(FindRetinueFunction);
    	AddItem("AppLocList",Info1);
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

function GetLoc()
{
	//��ȡ����Ա��ע�Ŀ�������
    var AdmLocFun=document.getElementById("GetAppFun").value;
	var Info1=cspRunServerMethod(AdmLocFun,$("ArcItemRowid").value);
	AddItem("SelAppLocList",Info1);

}


//����Ա�������Ա����
function SaveAppLocSet(Info,OperateCode)
{
	var SaveUserSetFun=$("SaveFun").value;
	var value=cspRunServerMethod(SaveUserSetFun,Info,OperateCode);
	
	if (value!="0")
	{  
	     if(OperateCode=="I")
	     {
		    if (value=="-1")
		    {
			  var Info="�����ظ�����";
		    }
		    else
		    {
		       var Info="����ʧ��:SQLCODE="+value;
		    }
		 }
	     if(OperateCode=="U")
	     {
		    var Info="����ʧ��:SQLCODE="+value;
		 }
		 if(OperateCode=="D")
		 {
			
			var Info="ɾ��ʧ��:SQLCODE="+value;
			
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


