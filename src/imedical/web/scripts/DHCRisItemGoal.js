//DHCRisItemGoal.js
//sunyi 2012-02-02

function BodyLoadHandler()
{

	var AddObj=document.getElementById("Add");
	if (AddObj)
	{
		AddObj.onclick=Add_click;
	}
	
	var UpdateObj=document.getElementById("Update");
	if (UpdateObj)
	{
		UpdateObj.onclick=Update_click;
	}
	
	var DeleteObj=document.getElementById("Delete");
	if (DeleteObj)
	{
		DeleteObj.onclick=Delete_click;
	}
	var QueryObj=document.getElementById("Query");
	if(QueryObj)
	{
		QueryObj.onclick=Query_click;
	}

}

function Add_click()
{
	 var OperateCode="I";
	 var Info=GetValue();
	 
 
	 if(Info=="-1")
	 {
		 var error="请检查医嘱项目是否为空!";
		 alert(error);
		 return ;
	 }
	 
	SetDHCRBCGoalSet(Info,OperateCode);
}

function Update_click()
{
	var OperateCode="U"
	var SelRowid=document.getElementById("SelRowid").value;
	
	if (SelRowid=="")
	{
		alert("未选择记录不能删除!")
		return;
		
	}
	var ArcItemRowid=document.getElementById("ArcItemRowid").value;
	var Goal=document.getElementById("Goal").value;
    var Info=SelRowid+"^"+ArcItemRowid+"^"+Goal;
    SetDHCRBCGoalSet(Info,OperateCode);
	
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
	
	var str="^^";
    var Info=SelRowid+str;
    SetDHCRBCGoalSet(Info,OperateCode);
	
}

function Query_click()
{
	var QArcItmRowid=document.getElementById("QArcItmRowid").value;
	var Info=QArcItmRowid+"^";
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisItemGoal"+"&Info="+Info;
}


function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisItemGoal');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

    
 	var SelRowid=document.getElementById("Rowidz"+selectrow).value;
	
	var SeleRowidObj=document.getElementById("SelRowid");
	if (SeleRowidObj)
	{
		SeleRowidObj.value=SelRowid;
		var GetGoalbyRowidFun=document.getElementById("GetGoalbyRowid").value;
	    var value=cspRunServerMethod(GetGoalbyRowidFun,SelRowid);
	    var Goal=ReplaceInfo(value);  
	}
	
	var GoalObj=document.getElementById("Goal");
	if(GoalObj)
	{
		GoalObj.value=Goal;
	}
	
	
}


function SetDHCRBCGoalSet(Info,OperateCode)
{
	var SetDHCRBCGoalFun=document.getElementById("SetDHCRBCGoalFun").value;
	var value=cspRunServerMethod(SetDHCRBCGoalFun,Info,OperateCode);
	if (value!="0")
	{  
	     if(OperateCode=="I")
	     {
		    var Info="增加失败:SQLCODE="+value;
		 }
	     if(OperateCode=="U")
	     {
		    var Info="更新失败:SQLCODE="+value;
		 }
		 else
		 {
			var Info="删除失败:SQLCODE="+value;
	     }	 
		
	}
	else
	{   
	    ClearData();
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisItemGoal";
   		location.href=lnk;
   		
	}
	
}


function GetValue()
{
	orddoc=parent.frames["DHCRisItmGoalMemoSet"].document;
	var Rowid="",Info=""
	var ArcItemID=orddoc.getElementById("ArcItemID").value;
	var Goal=document.getElementById("Goal").value;
	
	if(ArcItemID!="")
	{
	   Info=Rowid+"^"+ArcItemID+"^"+Goal;
	   return Info;
	}
	else
	{
	   return -1;	
	}

}


function ClearData()
{
	orddoc=parent.frames["DHCRisItmGoalMemoSet"].document;
	var SeleRowidObj=document.getElementById("SelRowid");
	if (SeleRowidObj)
	{
		SeleRowidObj.value="";
	}
	
	var ItemSubCatObj=orddoc.getElementById("ItemSubCat");
	if (ItemSubCatObj)
	{
		ItemSubCatObj.value="";
		orddoc.getElementById("SubCatID").value="";
	}
	
	var OrdNameObj=orddoc.getElementById("OrdName");
	if(OrdNameObj)
	{
	    OrdNameObj.value="";
	    orddoc.getElementById("ArcItemID").value="";
	}
	
}


function ReplaceInfo(Strtmp)
{
   Info=Strtmp.replace(new RegExp("X000b","g"),"\r");
   Info=Info.replace(new RegExp("X000a","g"),"\n");
   return Info ;
}

function GetOrdItemInfo(Info)
{
  Item=Info.split("^");
  document.getElementById("QArcItmRowid").value=Item[1];
  document.getElementById("QArcItemMast").value=Item[0]; 
	
}


document.body.onload = BodyLoadHandler;


