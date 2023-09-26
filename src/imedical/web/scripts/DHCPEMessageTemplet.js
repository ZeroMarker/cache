///yandong
///DHCPEMessageTemplet.js
/// 主要功能:短信模板维护
/// DHCPEMessageTemplet.js
/// 对应表	


var CurRow=0
var CurrentSel=0
function BodyLoadHandler() {

	var obj;
	//alert('1')
	obj=document.getElementById("Update");
	if (obj){obj.onclick=Update_click;}

	obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click; }

	obj=document.getElementById("Add");
	if (obj){ obj.onclick=Add_click; }
	
	 obj=document.getElementById("find");
	if (obj){ obj.onclick=Find_click; }
	
	//清屏
	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }

}

function Clear_click()
{
	var obj;
	
	//短信类型
	obj=document.getElementById("Type");
	if(obj){obj.value="";}
	
	//短信内容
	obj=document.getElementById("Templet");
	if(obj){obj.value="";}
	
	//vip等级
	obj=document.getElementById("VIPLevel");
	if(obj){obj.value="";}
	
	//激活
	obj=document.getElementById("Active");
	if(obj){obj.checked=false;}
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

function Find_click(){
	var obj;
	var iType="",iTemplet="",iDefault="0",iActive="0",iVIPLevel="";
	obj=document.getElementById("Type");
	if (obj) iType=obj.value;
	obj=document.getElementById("Templet");
	if (obj) iTemplet=obj.value;
	obj=document.getElementById("Default");
	if (obj&&obj.checked) iDefault="1";
	obj=document.getElementById("Active");
	if (obj&&obj.checked) iActive="1";
	obj=document.getElementById("VIPLevel");
	if (obj) iVIPLevel=obj.value;
	if(iVIPLevel!="") var iVIPLevel=tkMakeServerCall("web.DHCPE.MessageTemplet","GetVipDesc",iVIPLevel);
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEMessageTemplet"
			+"&Type="+iType
			+"&Templet="+iTemplet
			+"&Default="+iDefault
			+"&Active="+iActive
			+"&VIPLevel="+iVIPLevel
			
	;
	//alert(lnk)
	location.href=lnk;
		
	
}

function Add_click() {
	var iType="", iTemplet="",iActive="",iDefault="",iVIPLevel="";
	
	
	var obj=document.getElementById("VIPLevel");
	if (obj){iVIPLevel=obj.value; }   //vip
	
	//类型 
	var obj=document.getElementById("Type");
	if (obj){iType=obj.value; } 

    //内容
	var obj=document.getElementById("Templet");
	if (obj){iTemplet=obj.value; } 
    //标志
    var obj=document.getElementById("Active");
	if (obj && obj.checked) { iActive="1"; }
	else { iActive="0"; }
	//默认标志
	var obj=document.getElementById("Default");
	if (obj && obj.checked) { iDefault="1"; }
	else { iDefault="0"; }
	
   if (""==iType) {
		obj=document.getElementById("Type")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("短信类型不能为空");
		return false;
	}

 	if (""==iTemplet) {
		obj=document.getElementById("Templet")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("短信内容不能为空");
		return false;
	}
	
	if (""==iVIPLevel) {
		obj=document.getElementById("VIPLevel")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("VIP等级不能为空");
		return false;
	}
	
   /*
     //输入数据验证
	if ((iType=="")||(iTemplet=="")) {
		alert("Please entry all information.");
		
	}  */
	var Instring=trim(iType)		
				+"^"+trim(iTemplet)
				+"^"+trim(iActive)
				+"^"+trim(iDefault)
				+"^"+trim(iVIPLevel)	
				
	//alert(Instring)
	var Ins=document.getElementById('AddBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring)
    if (flag==0)  
    
	{  
	 alert(t["04"]);
	 window.location.reload();   
	
		 
	}
	else
	{
		alert(flag);
	}
    }  
    
function Update_click()
{   
    var RowId="",iType="", iTemplet="",iActive="",iDefault="",iVIPLevel="";
	
	var obj=document.getElementById("Id");
	if (obj){RowId=obj.value; } 
	if(RowId=="") {
		alert("请选择待修改的记录");
		return false;
	}

	//类型 
	var obj=document.getElementById("Type");
	if (obj){iType=obj.value; } 


	var obj=document.getElementById("VIPLevel");
	if (obj){iVIPLevel=obj.value; }   //vip

    //内容
	var obj=document.getElementById("Templet");
	if (obj){iTemplet=obj.value; } 
	
	//标志
    var obj=document.getElementById("Active");
	if (obj && obj.checked) { iActive="1"; }
	else { iActive="0"; }
	//默认标志
	var obj=document.getElementById("Default");
	if (obj && obj.checked) { iDefault="1"; }
	else { iDefault="0"; }
	
   if (""==iType) {
		obj=document.getElementById("Type")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("短信类型不能为空");
		return false;
	}

 	if (""==iTemplet) {
		obj=document.getElementById("Templet")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("短信内容不能为空");
		return false;
	}
	
	if (""==iVIPLevel) {
		obj=document.getElementById("VIPLevel")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("VIP等级不能为空");
		return false;
	}

     /*
     //输入数据验证
	if ((iType=="")||(iTemplet=="")) {
		alert("Please entry all information.");
		
	} */ 
	var Instring=trim(RowId)
	            +"^"+trim(iType)		
				+"^"+trim(iTemplet)
				+"^"+trim(iActive)
				+"^"+trim(iDefault)	
				+"^"+iVIPLevel	
				
	//alert(Instring)
	var Ins=document.getElementById('UpdateBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring)
    if (flag==0)  
    
	{  
	alert(t["05"]);
	window.location.reload();   
	
		 
	}
	else
	{
		alert(t["02"]);
	}
    
   // alert(Instring);

 }

function Delete_click()

{ 
    var RowId=""
	var obj=document.getElementById("Id");
	if (obj){RowId=obj.value; } 
	
	if(RowId==""){
		alert("请先选择要删除的记录");
		return false;
	}

	var Instring=trim(RowId)
	var Ins=document.getElementById('DeleteBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring)
	
	if (flag==0)
	{   alert(t["06"]);
		window.location.reload();
	}
	
	else
	{    
		alert(t["03"]);
	}
	}
	
	
function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	
	var objtbl=document.getElementById('tDHCPEMessageTemplet');	
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var Row=rowObj.rowIndex;
	if (Row==CurRow)
	{
		return false;
		CurRow=0      
	
	}
	else
	{
		CurRow=Row;
	}
	var obj=document.getElementById("IDz"+CurRow)
	var objId=document.getElementById("Id")
	if (objId)  {
	objId.value=obj.value;
	}
	var obj=document.getElementById("NMT_Typez"+CurRow)
    //alert(obj.innerText)
	var objType=document.getElementById("Type")
	if (objType)  objType.value=obj.innerText;
	
	
	
	var obj=document.getElementById("NMT_VIPLevelz"+CurRow)
    //alert(obj.innerText)
	var objVIPLevel=document.getElementById("VIPLevel")
	if (obj.innerText=="VIP")  objVIPLevel.value=2
	if (obj.innerText=="普通")  objVIPLevel.value=1
	if (obj.innerText=="VVIP") objVIPLevel.value=3
	if (obj.innerText=="过期主场") objVIPLevel.value=4
	if (obj.innerText=="职业病") objVIPLevel.value=5

	

	
    var obj=document.getElementById("NMT_Templetz"+CurRow)
    var objTemplet=document.getElementById("Templet")
	if (objTemplet)  objTemplet.value=obj.innerText;
   
    var obj=document.getElementById("NMT_Activez"+CurRow)
    var objActive=document.getElementById("Active")
    //alert(obj.innerText)
	
	if(obj.innerText=="1") objActive.checked="true"
	else
	{objActive.checked=""}
	

	var obj=document.getElementById("NMT_Defaultz"+CurRow)
    var objDefault=document.getElementById("Default")
	if(obj.innerText=="1") objDefault.checked="true"
	else
	{objDefault.checked=""}
	
	

}	


document.body.onload = BodyLoadHandler;
