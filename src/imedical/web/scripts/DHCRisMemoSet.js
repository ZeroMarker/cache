//DHCRisMemoSet.js
//sunyi 2012-04-21
var combo_Use

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
	var ClearObj=document.getElementById("Clear");
	if(ClearObj)
	{
		ClearObj.onclick=Clear_click;
	}
	
	var GetUMRowid=document.getElementById("UMRowid").value;
 	var GetUseMListStr=DHCC_GetElementData('GetUseMethodList');
 
 	/*
	var UseMethodObj=document.getElementById("UseMethod");
	if(UseMethodObj)
	{
		combo_Use=dhtmlXComboFromStr("UseMethod",GetUseMListStr);
		combo_Use.enableFilteringMode(true);
		
		if (GetUMRowid!="")
		{
			combo_Use.setComboValue(GetUMRowid);
		}
		combo_Use.selectHandle=combo_UseKeydownhandler;
		combo_Use.keyenterHandle=combo_UseKeyenterhandler;
		combo_Use.attachEvent("onKeyPressed",combo_UseKeyenterhandler)
  	}
	*/

}



function combo_UseKeyenterhandler()
{
	
}

function combo_UseKeydownhandler()
{
  /*var obj=combo_Use;
  var UMRowid=obj.getActualValue();
  document.getElementById("UMRowid").value=UMRowid;
  */
}




function Add_click()
{
	 var OperateCode="I";
	 var Rowid="";
	 
	 var OrdName=document.getElementById("OrdName").value;
	 var Template=document.getElementById("Template").value;
	 
 
	 if((OrdName=="")||(Template==""))
	 {
		 var error="ҽ����Ŀ��ģ���Ƿ�Ϊ��!";
		 alert(error);
		 return ;
	 }
	 
	 var ArcItemID=document.getElementById("ArcItemID").value;
	 var TemplateID=document.getElementById("TemplateID").value;
	 var UMRowid=document.getElementById("UMRowid").value;
	 var Info=Rowid+"^"+ArcItemID+"^"+TemplateID+"^"+UMRowid;
	 
	 SetMemo(Info,OperateCode);
}



function Update_click()
{
	var OperateCode="U"
	var SelRowid=document.getElementById("SelRowid").value;
	
	if (SelRowid=="")
	{
		alert("δѡ���¼���ܸ���!")
		return;
		
	}
	
	var OrdName=document.getElementById("OrdName").value;
	var Template=document.getElementById("Template").value;
	
    if((OrdName=="")||(Template==""))
	{
		 var error="ҽ����Ŀ��ģ���Ƿ�Ϊ��!";
		 alert(error);
		 return ;
	}
	 
	var ArcItemID=document.getElementById("ArcItemID").value;
	var TemplateID=document.getElementById("TemplateID").value;
	var UMRowid=document.getElementById("UMRowid").value;
	var Info=SelRowid+"^"+ArcItemID+"^"+TemplateID+"^"+UMRowid;
	 
	SetMemo(Info,OperateCode);
	
}


function Delete_click()
{
    var OperateCode="D"
	var SelRowid=document.getElementById("SelRowid").value;
	
	if (SelRowid=="")
	{
		alert("δѡ���¼����ɾ��!")
		return;
		
	}
	
	var str="^^^";
    var Info=SelRowid+str;
    SetMemo(Info,OperateCode);
	
}

function Query_click()
{
	var ItemCatID=document.getElementById("ItemCatID").value;
	var SubCatID=document.getElementById("SubCatID").value;
	var ArcItemID=document.getElementById("ArcItemID").value;
	var TemplateID=document.getElementById("TemplateID").value;
	
	var ItemCat=document.getElementById("ItemCat").value;
	var ItemSubCat=document.getElementById("ItemSubCat").value;
	var OrdName=document.getElementById("OrdName").value;
	var Template=document.getElementById("Template").value;
	var UMRowid=document.getElementById("UMRowid").value;
	
	if ( Template=="")
	{
		TemplateID="";
	}
	var Info=ItemCatID+"^"+SubCatID+"^"+ArcItemID+"^"+TemplateID+"^"+UMRowid;
	var Infos="&ItemCat="+ItemCat+"&ItemSubCat="+ItemSubCat+"&OrdName="+OrdName+"&Template="+Template;
	    Infos=Infos+"&ItemCatID="+ItemCatID+"&SubCatID="+SubCatID+"&ArcItemID="+ArcItemID+"&TemplateID="+TemplateID+"&UMRowid="+UMRowid;
	    
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisMemoSet"+"&Info="+Info+"&Infos="+Infos;
	
	
}

function Clear_click()
{
	document.getElementById("ItemCatID").value="";
	document.getElementById("SubCatID").value="";
	document.getElementById("ArcItemID").value="";
	document.getElementById("TemplateID").value="";
	document.getElementById("OrdName").value="";
	document.getElementById("Template").value="";
	document.getElementById("ItemCat").value="";
	document.getElementById("ItemSubCat").value="";
	document.getElementById("UMRowid").value="";
	//combo_Use.setComboText('');
}


function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisMemoSet');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

    
 	var SelRowid=document.getElementById("TRowidz"+selectrow).value;
 	var OrdName=document.getElementById("TOrdNamez"+selectrow).innerText;
 	var TMDesc=document.getElementById("TMDescz"+selectrow).innerText;
 	var ItemID=document.getElementById("TItemIDz"+selectrow).value;
 	var TMRowid=document.getElementById("TMRowidz"+selectrow).value;
 	var TUMRowid=document.getElementById("TUMRowidz"+selectrow).value;
	
	var SeleRowidObj=document.getElementById("SelRowid");
	if (SeleRowidObj)
	{
		SeleRowidObj.value=SelRowid;
	}
	
	var ItemObj=document.getElementById("OrdName");
	if(ItemObj)
	{
		ItemObj.value=OrdName;
	}
	
	var TemplateObj=document.getElementById("Template");
	if(TemplateObj)
	{
		TemplateObj.value=CTrim(TMDesc);
	}
	
	var ItemIDObj=document.getElementById("ArcItemID");
	if(ItemIDObj)
	{
		ItemIDObj.value=ItemID;
	}
	
	var TMRowidObj=document.getElementById("TemplateID");
	if(TMRowidObj)
	{
		TMRowidObj.value=TMRowid;
	}
	/*
	var UMRowidObj=document.getElementById("UMRowid");
	if(UMRowidObj)
	{
		UMRowidObj.value=TUMRowid;
		if(TUMRowid!="")
		{
		  combo_Use.setComboValue(TUMRowid);
		}
		else
		{
		  combo_Use.setComboText('');
		}
	}
	*/
}


function SetMemo(Info,OperateCode)
{
	var SetMemoFun=document.getElementById("SetMemoFun").value;
	//web.DHCRisCodeTableSet.SetMemo
	var value=cspRunServerMethod(SetMemoFun,Info,OperateCode);
	if (value!="0")
	{  
		if (value=="200")
		{
			var Info="�����ظ����!";
		}
		else
		{
		     if(OperateCode=="I")
		     {
			    var Info="����ʧ��:SQLCODE="+value;
			 }
		     if(OperateCode=="U")
		     {
			    var Info="����ʧ��:SQLCODE="+value;
			 }
			 else
			 {
				var Info="ɾ��ʧ��:SQLCODE="+value;
		     }
	    } 
		alert(Info);
	}
	else
	{   
		/*var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisMemoSet";
   		location.href=lnk;*/
   		window.location.reload();
   		
	}
	
}


//ѡ��ҽ������
function SelectOrdCat(Info)
{
    Item=Info.split("^");
    document.getElementById("ItemCat").value=Item[1];
    document.getElementById("ItemCatID").value=Item[0];
}

//ѡ������
function SelectOrdSubCat(Info)
{
    Item=Info.split("^");
    document.getElementById("ItemSubCat").value=Item[1];
    document.getElementById("SubCatID").value=Item[0];

}

//ҽ����Ŀ
function GetOrdItemInfo(Info)
{
  Item=Info.split("^");
  document.getElementById("ArcItemID").value=Item[1];
  document.getElementById("OrdName").value=Item[0]; 
	
}

//��עģ��
function SelMemoDesc(Info)
{
  Item=Info.split("^");
  document.getElementById("Template").value=Item[2];
  document.getElementById("TemplateID").value=Item[0]; 
}

function CTrim(info)
{
	 return info.replace(/(^\s*)|(\s*$)/g,'');
}

document.body.onload = BodyLoadHandler;

