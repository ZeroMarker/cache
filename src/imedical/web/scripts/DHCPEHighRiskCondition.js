/// /// 对应组件DHCPEHighRiskCondition 高危维护
var CurrentSel=0
var SelectedRow=-1
var TFORM="tDHCPEHighRiskCondition"
function BodyLoadHandler()
{	
	var obj;
	
	obj=document.getElementById("Update");
	if (obj) obj.onclick=Update_Click;
	
	obj=document.getElementById("Delete");
	if (obj) obj.onclick=Delete_Click;
	
	obj=document.getElementById("Clear");
	if (obj) obj.onclick=Clear_Click;
	
	obj=document.getElementById("ConditionFlag");
	if (obj) obj.onclick=ConditionFlag_click;
	
	obj=document.getElementById("Sex_N");
	if (obj){ obj.onclick=Sex_click; }
	obj=document.getElementById("Sex_M");
	if (obj){ obj.onclick=Sex_click; }	
	obj=document.getElementById("Sex_F");
	if (obj){ obj.onclick=Sex_click; }	

	obj=document.getElementById('AgeMin');
	if (obj) {obj.onkeydown = keydown;}

	obj=document.getElementById('AgeMax');
	if (obj) {obj.onkeydown = keydown;}
	
	obj=document.getElementById('Min');
	if (obj) {obj.onkeydown = keydown;}	
	
	obj=document.getElementById('Max');
	if (obj) {obj.onkeydown = keydown;}
	obj=document.getElementById("ConditionFlag");
	if (obj) obj.onclick=ConditionFlag_click;
	
	iniForm();
}
function iniForm()
{
		

	SetSex("");
	SetSex("N");


}
function Clear_Click()
{	 
  	var obj=document.getElementById("Num");
    if(obj){obj.value=""}
    var obj=document.getElementById("Station");
    if(obj){obj.value=""}
    var obj=document.getElementById("StationRowId");
    if(obj){obj.value=""}
  	var obj=document.getElementById("Detail");
    if(obj){obj.value=""}
    var obj=document.getElementById("OrderDetailRowId");
    if(obj){obj.value=""}
  	var obj=document.getElementById("StandardRowId");
    if(obj){obj.value=""}
    var obj=document.getElementById("Standard");
    if(obj){obj.value=""}

  	var obj=document.getElementById("Min");
    if(obj){obj.value=""}

  	var obj=document.getElementById("Max");
    if(obj){obj.value=""}
	 
	//年龄下限
	obj=document.getElementById("AgeMin");  
	if(obj){obj.value=""}
	
	//年龄上限
	obj=document.getElementById("AgeMax");  
	if(obj){obj.value=""}
		SetSex("N");

}
//增加
function Update_Click()
{	
    var obj;
	var iCode="",iDesc="", iOrderDetailRowId="",iStandardRowId="", iMin="", iMax="",iSex="",iAgeMin="",iAgeMax=""
  	var iNum="",iTextValue="";
  	var obj=document.getElementById("Num");
    if (obj){
		iNum=obj.value
	}
  	
  	var obj=document.getElementById("Code");
    if (obj){
		iCode=obj.value
	}
	if (""==iCode){
		alert("请选择填写编号");
		return false
  	} 
  	var obj=document.getElementById("Desc");
    if (obj){
		iDesc=obj.value
	}
	if (""==iDesc){
		alert("请选择填写描述");
		return false
  	} 
	
	

  	var obj=document.getElementById("OrderDetailRowId");
    if (obj){
		iOrderDetailRowId=obj.value
	}
	if (""==iOrderDetailRowId){
		alert("请选择细项");
		return false
  	} 


  	var obj=document.getElementById("StandardRowId");
    if (obj){
		iStandardRowId=obj.value
	}
	
  	var obj=document.getElementById("TextValue");
    if (obj){
		iTextValue=obj.value
	}
	
  	var obj=document.getElementById("Min");
    if (obj){
		iMin=obj.value
	}
	

  	var obj=document.getElementById("Max");
    if (obj){
		iMax=obj.value
	}
    iSex=GetSex(); 
	 
	//年龄下限
	obj=document.getElementById("AgeMin");  
	if (obj){ 
		iAgeMin=obj.value; 
		if (IsValidAge(iAgeMin)){}
		else { 
			obj.className='clsInvalid';			
			alert(t['Err 03']);
			return false;
		}
	}		

	//年龄上限
	obj=document.getElementById("AgeMax");  
	if (obj){ 
		iAgeMax=obj.value; 
		if (IsValidAge(iAgeMax)){}
		else {
			obj.className='clsInvalid'; 			
			alert(t['Err 04']);
			return false;
		}
	}  
        var String=iNum+"^"+iCode+"^"+iDesc+"^"+iOrderDetailRowId+"^"+iStandardRowId+"^"+iTextValue+"^"+iMin+"^"+iMax+"^"+iSex+"^"+iAgeMin+"^"+iAgeMax
 
    	var Ins=document.getElementById('UpdateBox');
        if (Ins) {var encmeth=Ins.value} 
        else {var encmeth=''};
        var flag=cspRunServerMethod(encmeth,String)
         location.reload();
}
//删除
function Delete_Click()
{	
	var iNum="",iCode=""
   	var obj=document.getElementById("Num");
    if (obj){
		iNum=obj.value
	}
  	
  	var obj=document.getElementById("Code");
    if (obj){
		iCode=obj.value
	}
    	
    var Ins=document.getElementById('DeleteBox');
    if (Ins) {var encmeth=Ins.value} 
    else {var encmeth=''};
    var flag=cspRunServerMethod(encmeth,iCode,iNum)
    location.reload()

     
   
     
}

// **************************************************************

function ShowCurRecord(selectrow) {

	var SelRowObj;
	var obj;
	SelRowObj=document.getElementById('TStationDesc'+'z'+selectrow);
	obj=document.getElementById("Station");
	if (SelRowObj && obj) { obj.value=SelRowObj.innerText; }

	SelRowObj=document.getElementById('TStation'+'z'+selectrow);
	obj=document.getElementById("StationRowId");
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }
	
	SelRowObj=document.getElementById('TDetailDesc'+'z'+selectrow);
	obj=document.getElementById("Detail");
	if (SelRowObj && obj) { obj.value=SelRowObj.innerText; }
	
	SelRowObj=document.getElementById('TDetailID'+'z'+selectrow);
	obj=document.getElementById("OrderDetailRowId");
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }
	SelRowObj=document.getElementById('TStandardRowId'+'z'+selectrow);
	obj=document.getElementById("StandardRowId");
	if (SelRowObj && obj) { obj.value=SelRowObj.value;}
	
	//高危下限
	SelRowObj=document.getElementById('TMin'+'z'+selectrow);
	var Min=document.getElementById("Min");
	if (SelRowObj && obj) { 
	    Min.value=trim(SelRowObj.innerText);	
		Min.className=''; 
		Min.disabled=false; }
	//高危上限
    SelRowObj=document.getElementById('TMax'+'z'+selectrow);
	var Max=document.getElementById("Max");
	if (SelRowObj && obj) { 
	    Max.value=trim(SelRowObj.innerText);	
		Max.className='';  
		Max.disabled=false;}
	//高危项(选择型)
	StandardRow=document.getElementById('TStandard'+'z'+selectrow);
	var Standard=document.getElementById("Standard");
	if (Standard) {Standard.disabled=false;}
    //高危项(文本型)
	var Text=document.getElementById("TextValue");
	if (Text) {Text.disabled=false;}
	//细项类型			
	SelRowObj=document.getElementById('TDetailType'+'z'+selectrow);
	obj=document.getElementById("DetailType");
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }
	//根据不同细项类型在选择行时将高危项放到相应的元素上
	if  (obj.value=="T") 
	    {
		if (SelRowObj && Text) 
		{ 
		Text.value=StandardRow.innerText; 
		}
		
		Standard.value=""
	    Standard.disabled=true;
        Max.disabled=true;
	    Min.disabled=true; 
		}
	if  (obj.value=="S") 
	    {
		if (SelRowObj && Standard) 
		{ 
		 Standard.value=StandardRow.innerText; }
		 Text.value=""
		 Text.disabled=true;
         Max.disabled=true;
	     Min.disabled=true; 
		}
 
	if ((obj.value=="N")||(obj.value=="C"))
	{  
	    Standard.disabled=true;
        Text.disabled=true;
	}	
		
	SelRowObj=document.getElementById('TSexDesc'+'z'+selectrow);
	if (SelRowObj) {  
	   
		SetSex("");	
		SetSex(trim(SelRowObj.innerText));	 }
	
	SelRowObj=document.getElementById('TAgeMin'+'z'+selectrow);
	obj=document.getElementById("AgeMin");
	if (SelRowObj && obj) { 
	    obj.value=trim(SelRowObj.innerText);	
		obj.className='';  }
	
	SelRowObj=document.getElementById('TAgeMax'+'z'+selectrow);
	obj=document.getElementById("AgeMax");
	if (SelRowObj && obj) { 
	   obj.value=trim(SelRowObj.innerText);	
	   obj.className=''; }
	
	SelRowObj=document.getElementById('TNum'+'z'+selectrow);
	obj=document.getElementById("Num");
	if (SelRowObj && obj) { 
	   obj.value=trim(SelRowObj.innerText);	
	   obj.className=''; }
	

	

	
}
function SelectRowHandler(){  
	var eSrc=window.event.srcElement;
	
	var objtbl=document.getElementById('tDHCPEHighRiskCondition');
	
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	
	if (!selectrow) return;
	
	if (selectrow!=SelectedRow) {
		ShowCurRecord(selectrow);		
		SelectedRow = selectrow;
	}
	else { SelectedRow=0; }
	
}

function GetStationRowId(value)	{
	//alert("Station:"+value);
	var Station=value.split("^");
	var obj=document.getElementById('StationRowId');
	obj.value=Station[1];
}
function GetOrderDetailRowId(value)	{

	var OrderDetail=value.split("^");
	var obj=document.getElementById('OrderDetailRowId');
	obj.value=OrderDetail[9];
	var obj=document.getElementById('DetailType');
	var Type=OrderDetail[1];
	var obj=document.getElementById("TextValue");
    if (obj){obj.disabled=false;}
    var obj=document.getElementById("Min");
    if (obj){ obj.disabled=false;}
    var obj=document.getElementById("Max");
    if (obj){obj.disabled=false;}
    var obj=document.getElementById("Standard");
    if (obj){obj.disabled=false;}
	if (Type=="S")
	{  	
	    var obj=document.getElementById("TextValue");
        if (obj){obj.disabled=true;}
        var obj=document.getElementById("Min");
        if (obj){ obj.disabled=true;}
	    var obj=document.getElementById("Max");
        if (obj){obj.disabled=true;}
        websys_setfocus('Standard')
	}

	if (Type=="T")
	{  
	    var obj=document.getElementById("Standard");
        if (obj){obj.disabled=true;}
        var obj=document.getElementById("Min");
        if (obj){ obj.disabled=true;}
	    var obj=document.getElementById("Max");
        if (obj){obj.disabled=true;}
        websys_setfocus('TextValue')
	}
 
	if ((Type=="N")||(Type=="C"))
	{  
	   var obj=document.getElementById("Standard");
        if (obj){obj.disabled=true;}
        var obj=document.getElementById("TextValue");
        if (obj){ obj.disabled=true;}
        websys_setfocus('Min')
	}

  	
		
}
function GetStandardRowId(value)	{
	var Standard=value.split("^");
	var obj=document.getElementById('StandardRowId');
	obj.value=Standard[5];
}

function GetSex() {	
	var obj;

	obj=document.getElementById("Sex_M");
	if (obj){ if (obj.checked) { return "M"; } }
	
	obj=document.getElementById("Sex_F");
	if (obj){ if (obj.checked) { return "F"; } }
	
	obj=document.getElementById("Sex_N");
	if (obj){ if (obj.checked) { return "N"; } }
	
}
function IsValidAge(Value) {
	
	if(""==trim(Value) || "0"==Value) { 
		//容许为空
		return true; 	
	}
	if (!(IsFloat(Value))) { return false; }
	
	if ((Value>0)&&(Value<120)) {
		return true; 
	}
}
function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}
 

//验证是否为浮点数
function IsFloat(Value) {
	
	var reg;
	
	if(""==trim(Value)) { 
		//容许为空
		return true; 
	}else { Value=Value.toString(); }
	
	reg=/^((-?|\+?)\d+)(\.\d+)?$/;
	if ("."==Value.charAt(0)) {
		Value="0"+Value;
	}
	
	var r=Value.match(reg);
	if (null==r) { return false; }
	else { return true; }
}
function SetSex(value) {
	
	var obj;

	if (""==value) {		 		
		obj=document.getElementById("Sex_N");
		if (obj){ obj.checked=false; }
		obj=document.getElementById("Sex_M");
		if (obj){ obj.checked=false; }
		obj=document.getElementById("Sex_F");
		if (obj){ obj.checked=false; }
		return false;				
	}
	
	if ("M"==value) {
		
		obj=document.getElementById("Sex_M");
		if (obj){ obj.checked=true; }  
	}
	else {	
		if ("F"==value) {
		obj=document.getElementById("Sex_F");
		if (obj){ obj.checked=true; }  
		}
		else {
			if ("N"==value) {
				obj=document.getElementById("Sex_N");
				if (obj){ obj.checked=true; } 
			}
			else{
				obj=document.getElementById("Sex_N");
				if (obj){ obj.checked=true; }  			
			}
		}
	}  
}
function Sex_click() {
	var obj;

	srcElement = window.event.srcElement;

	SetSex("");

	obj=srcElement;
	obj.checked=true;
}
function keydown(e) {	

	var key;
	key=websys_getKey(e);
	
	if ((key==13)||(key==9)) {
	}else{
		var eSrc=window.event.srcElement;
		if (eSrc) { eSrc.className=''; }	
	}

}
function ConditionFlag_click()
{
	var Code="",obj,ConditionFlag=0;
  	obj=document.getElementById("Code");
    	if (obj){
		Code=obj.value
	}
	if (Code=="") return;
	
	obj=document.getElementById("ConditionFlag");
	if (obj&&obj.checked) ConditionFlag=1;
	tkMakeServerCall("web.DHCPE.HighRisk","SetConditionFlag",Code,ConditionFlag) ;
	alert("设置完成");
}
document.body.onload = BodyLoadHandler;