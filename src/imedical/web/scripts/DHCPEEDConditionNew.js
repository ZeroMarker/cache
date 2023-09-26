var Rows;
document.body.onload = BodyLoadHandler;
function BodyLoadHandler()
{
	var obj;
	obj=document.getElementById("BSave");
	if (obj) obj.onclick=BSave_click;
	
	var tbl=document.getElementById('tDHCPEEDConditionNew'); //取表格元素?名称
	var row=tbl.rows.length;
	for (var i=1;i<row;i++) {
	    var obj=document.getElementById("TItem"+i);
	    if(obj){obj.onkeydown=ItemOnKeydown;}
		var obj=document.getElementById("TReference"+i);
	    if(obj){obj.onkeydown=ItemStandardOnKeydown;}
		var obj=document.getElementById("TAdd"+i);
	    if(obj){ obj.onclick=InsertRow;}
	     var obj=document.getElementById("TDelete"+i);
	    if(obj){obj.onclick=DeleteRowNew;}

	}

	return false;
}
function BSave_click()
{
	var Express="",encmeth="",ParrefRowId="",iType="";
	var NoBloodFlag="N",AgeRange="";
	var obj=document.getElementById("SaveClass");
	if (obj) encmeth=obj.value;
	var obj=document.getElementById("ParrefRowId");
	if (obj) ParrefRowId=obj.value;
	var obj=document.getElementById("Type");
	if (obj) iType=obj.value;
	if(iType=="") iType="ED";
	var Char_1=String.fromCharCode(1);
	var tbl=document.getElementById('tDHCPEEDConditionNew');	//取表格元素?名称
	var row=tbl.rows.length;
	var obj;
	for (var j=1;j<row;j++) {
		var OneRowInfo="",Select="N",PreBracket="",ItemID="",Operator="",ODStandardID="",Reference="",AfterBracket="",Relation="",Sex="N";
		
		var ItemName=""
		obj=document.getElementById("TItem"+j);
		if (obj) ItemName=obj.value;

		obj=document.getElementById("TItemIDz"+j);
		if (obj) ItemID=obj.value;
		
		if((ItemName!="")&&(ItemID=="")) {
			alert("第"+j+"行项目没有回车选择");
			return false;
		}

		if (ItemID=="") break;
		obj=document.getElementById("TPreBracket"+j);
		if (obj) PreBracket=obj.value;
		obj=document.getElementById("TAfterBracket"+j);
		if (obj) AfterBracket=obj.value;
		obj=document.getElementById("TRelation"+j);
		if (obj) Relation=obj.value;
		obj=document.getElementById("TOperator"+j);
		if (obj) Operator=obj.value;
		if (Operator==""){
			alert("第"+j+"行,运算符不能为空");
			return false;
		}
		obj=document.getElementById("TSelectz"+j);
		//if (obj&&obj.checked){
			obj=document.getElementById("TODStandardIDz"+j);
			if (obj){
				ODStandardID=obj.value;
				//Reference="";
			}
		//}else{
			obj=document.getElementById("TReference"+j);
			if (obj){
				Reference=obj.value;
				//ODStandardID="";
			}
		//}
		if ((Reference=="")&&(ODStandardID=="")){
			alert("第"+j+"行,参考值不能为空");
			return false;
		}
		obj=document.getElementById("TSex"+j);
		if (obj) Sex=obj.value;

		obj=document.getElementById("TNoBloodFlagz"+j);
		if (obj&&obj.checked) NoBloodFlag="Y";
		obj=document.getElementById("TAgeRangez"+j);
		if (obj) AgeRange=obj.value;
		if(AgeRange!="") {
			if(AgeRange.indexOf("-")==-1)
			{
				alert("输入年龄范围格式不正确,应为10-20")
				return false;
			}
			var AgeMin=AgeRange.split("-")[0];
			var AgeMax=AgeRange.split("-")[1];
			//alert(AgeMin+"^"+AgeMax)
			if((isNaN(AgeMin))||(isNaN(AgeMax)))
			{
			alert("输入年龄不是数字")
			return false;
		
			}
			
		}
		OneRowInfo=PreBracket+"^"+ItemID+"^"+Operator+"^"+ODStandardID+"^"+Reference+"^"+Sex+"^"+AfterBracket+"^"+Relation+"^"+NoBloodFlag+"^"+AgeRange;;
		if (Express!=""){
			Express=Express+Char_1+OneRowInfo;
		}else{
			Express=OneRowInfo;
		}
	}
	var ret=cspRunServerMethod(encmeth,iType,ParrefRowId,Express);
	if (ret==0){
		alert("保存成功")
		return false;
	}
	alert("保存失败"+ret)
}
function ItemStandardOnChange()
{
	var eSrc=window.event.srcElement;
	var ElementName=eSrc.id;
	var CurRows=ElementName.split("TReference")[1];
	var obj=document.getElementById("TODStandardIDz"+CurRows);
	obj.value="";
}
function ItemStandardOnKeydown(e)
{
	if (event.keyCode==13)
	{
		var eSrc=window.event.srcElement;
		var ElementName=eSrc.id;
		Rows=ElementName.split("TReference")[1];
		var obj=document.getElementById("TItemIDz"+Rows);
		var ItemID=obj.value;
		if (ItemID==""){
			alert("请先选择项目");
			return websys_cancel();
		}
		var obj=document.getElementById("TSelectz"+Rows);
		if (obj&&!obj.checked) return websys_cancel();
		
		var url='websys.lookup.csp';
		url += "?ID=&CONTEXT=K"+"web.DHCPE.ODStandard:ODStandardByOD";
		url += "&TLUJSF=StandardFindAfter";
		url += "&P1="+ItemID;
		websys_lu(url,1,'');
		return websys_cancel();
	}
}
function StandardFindAfter(value)
{
	if (value=="")	return false;
	var obj=document.getElementById("TODStandardIDz"+Rows);
	if (obj) obj.value=value.split("^")[5];
	var obj=document.getElementById("TReference"+Rows);
	if (obj) obj.value=value.split("^")[0];
	
}
function ItemOnChange()
{
	var eSrc=window.event.srcElement;
	var ElementName=eSrc.id;
	var CurRows=ElementName.split("TItem")[1];
	var obj=document.getElementById("TItemIDz"+CurRows);
	if (obj) obj.value="";
	var obj=document.getElementById("TReference"+CurRows);
	if (obj) obj.value="";
	var obj=document.getElementById("TODStandardIDz"+CurRows);
	if (obj) obj.value="";
	var obj=document.getElementById("TSelectz"+CurRows);
	if (obj){ obj.checked=false;}
}
function ItemOnKeydown(e)
{
	if (event.keyCode==13)
	{
		var eSrc=window.event.srcElement;
		var ElementName=eSrc.id;
		Rows=ElementName.split("TItem")[1];
		var ODDesc=eSrc.value;
		var url='websys.lookup.csp';
		url += "?ID=&CONTEXT=K"+"web.DHCPE.Report.PosQuery:FromDescOrderDetail";
		url += "&TLUJSF=ItemFindAfter";
		url += "&P1="+ODDesc;
		websys_lu(url,1,'');
		return websys_cancel();
	}
}
function ItemFindAfter(value)
{
	if (value=="") return false;
	var NorInfo=tkMakeServerCall("web.DHCPE.ODStandard","GetNorInfo",value);
	//alert(NorInfo)
	var obj=document.getElementById("NorInfo");
	if (obj) obj.value=NorInfo;
	
	var Arr=value.split("^");
	var obj=document.getElementById("TItemIDz"+Rows);
	if (obj) obj.value=Arr[2];
	var obj=document.getElementById("TItem"+Rows);
	if (obj) obj.value=Arr[0];
	var obj=document.getElementById("TSelectz"+Rows);
	if (obj){
		if (Arr[3]=="S"){
			obj.checked=true;
		}else{
			obj.checked=false;
		}
	}
}

function InsertRow(e)
{
	//var Postion=e.id;
	//Postion=parseInt(Postion);
	
	var eSrc=window.event.srcElement;
	var ElementName=eSrc.id;
	var Postion=ElementName.split("TAdd")[1];
	var Postion=parseInt(Postion);
	var tbl=document.getElementById('tDHCPEEDConditionNew');	//取表格元素?名称
	var row=tbl.rows.length;
	var obj;


	for (var j=row-1;j>=Postion;j--) {
		Insert("TItemIDz",j);
		Insert("TItem",j);
		Insert("TPreBracket",j);
		Insert("TAfterBracket",j);
		Insert("TRelation",j);
		Insert("TOperator",j);
		Insert("TReference",j);
		Insert("TSex",j);
		Insert("TODStandardIDz",j);
		Insert("TAgeRangez",j);
		Insert("TNoBloodFlagz",j);
		Insert("Tindz",j);
	
	}
return false;
}
function DeleteRowNew(e)
{
	/*
	var Postion=e.id;
	var tbl=document.getElementById('tDHCPEEDConditionNew');	//取表格元素?名称
	var row=tbl.rows.length;
	var obj;
	Postion=parseInt(Postion);
	*/
	var eSrc=window.event.srcElement;
	var ElementName=eSrc.id;
	var Postion=ElementName.split("TDelete")[1]; 
	var Postion=parseInt(Postion);
	var tbl=document.getElementById('tDHCPEEDConditionNew'); //取表格元素?名称
	var row=tbl.rows.length;
	var obj;

	for (var j=Postion;j<row;j++) {
		
		Delete("TItemIDz",j);
		Delete("TItem",j);
		Delete("TPreBracket",j);
		Delete("TAfterBracket",j);
		Delete("TRelation",j);
		Delete("TOperator",j);
		Delete("TReference",j);
		Delete("TSex",j);
		Delete("TODStandardIDz",j);	
		Delete("TAgeRangez",j);
		Delete("TNoBloodFlagz",j);
		//Delete("Tindz",j);	
	}
	return false;
}
function Insert(Name,j)
{
		var value=GetValue(Name+j,1)
	
		 SetValue(Name+(j+1),value,1)
		 SetValue(Name+j,"",1)
}
function Delete(Name,j)
{
		var value=GetValue(Name+(j+1),1)
		
		 SetValue(Name+j,value,1)
		 SetValue(Name+(j+1),"",1)
}
function Trim(String)
{
	if (""==String) { return ""; }
	var m = String.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

function GetObj(Name)
{
	var obj=document.getElementById(Name);
	return obj;	
}
function GetValue(Name,Type)
{
	var Value="";
	var obj=GetObj(Name);
	if (obj){
		if (Type=="2"){
			Value=obj.innerText;
		}else{
			Value=obj.value;
		}
	}
	return Trim(Value);
}
function SetValue(Name,Value,Type)
{
	var obj=GetObj(Name);
	if (obj){
		if (Type=="2"){
			obj.innerText=Value;
		}else{
			obj.value=Value;
		}
	}
}