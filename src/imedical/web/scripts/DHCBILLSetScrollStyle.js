///DHCBILLSetScrollStyle.js
var SelectedRow="-1";
function BodyLoadHandler() {
	 var scopeObj=websys_$("listScope")
     if(scopeObj){
	    scopeObj.size=1;
	    scopeObj.multiple=false;	
	    scopeObj.options[0]=new Option(t['scope1'],"SITE");
	    scopeObj.options[1]=new Option(t['scope2'],"GROUP");  //添加选项
	    scopeObj.options[2]=new Option(t['scope3'],"GUSER");  //添加选项
	    scopeObj.options[0].selected=true;                //设置默认值
 	 	/*if(scopeObj.value==="SITE"){
	 	 	 $("txtGroup").disabled=true;
	 	 	 $("txtGuser").disabled=true;
	 	}*/
 	 }	
 	 var location=websys_$("listScrollLocation")
 	 if(location){
	 	location.size=1;
	    location.multiple=false;	
	    location.options[0]=new Option(t['right'],"");
	    location.options[1]=new Option(t['left'],"RTL");  //添加选项
	    location.options[0].selected=true;                //设置默认值	 
	 }
 	 var obj=websys_$("btnAdd");
 	 if(obj)obj.onclick = btnAdd_OnClick;
	 var obj=websys_$("btnDelete")
	 if(obj)obj.onclick = btnDel_OnClick; 	 
	 var obj=websys_$("btnClear")
	 if(obj)obj.onclick = btnClear_OnClick;
	   var obj=websys_$("txtComponentName")
	 if(obj)obj.onkeydown = ComponentName_OnKeyDown;  
	  var obj=websys_$("txtGroup")
	 if(obj)obj.onkeydown = Group_OnKeyDown; 	 
	 var obj=websys_$("txtGuser")
	 if(obj)obj.onkeydown = Guser_OnKeyDown; 
	 	 var obj=websys_$("test")
	 if(obj)obj.onclick = testHandler; 
}
function testHandler(){
			var obj=new ActiveXObject("TestDll.Class1");
			//var obj=new ActiveXObject("GetDataInfo.GetCatPrtInfo");
			alert(obj);	
}
//添加
function btnAdd_OnClick(){
   if(websys_$("txtComponentName").value===""){
		alert('"组件名"不能为空');  
		return; 
   }
   switch(websys_$("listScope").value){
		case "SITE":
			break;
		case "GROUP":
			if(websys_$("txtGroup").value===""&&websys_$("groupRowid").value===""){
				alert('"安全组"不能为空');
				return;	
			}
			break;
		case "GUSER":
			if(websys_$("txtGuser").value===""&&websys_$("guserRowid").value===""){
				alert('"用户名"不能为空');
				return;	
			}
			break;
   }
   var comName=websys_$("txtComponentName").value
   var scope=websys_$("listScope").value;
   var group=websys_$("txtGroup").value;
   var guser=websys_$("txtGuser").value;
   var flag=true;
   var rtn=tkMakeServerCall("web.DHCBILLLLibraryLogic","JudgeScrollExitYN",comName,group,guser,scope);
   if(rtn==="0"){
		var truthBeTold = window.confirm(t['message2']);
		if(!truthBeTold)return;   
		flag=false;
    }
   
   var str=new StringBuffer();
   str.append(comName).append("").append("")
   	  .append(websys_$("txtScrollWidth").value).append(websys_$("txtScrollHeight").value)
   	  .append(websys_$("listScrollLocation").value).append(websys_$("colLockFlag").checked);
   var data=str.toString("^");
   var rtn=tkMakeServerCall("web.DHCBILLLLibraryLogic","SetScrollData",comName,group,guser,scope,data);
   if(rtn==="0"){
	    if(flag){alert(t['addSuccess']);}
	    else{alert(t['updateSuccess']);}
		   
		find_click();
    }else{
		if(flag) alert(t['addFailure']);
		else alert(t['updateFailure']);	
	}
}
//删除
function btnDel_OnClick(){
	var delStr=GetSelectRowid();
	if(delStr==="")return;
    var truthBeTold = window.confirm(t['message1']);
    if (!truthBeTold)return;
    var rtn=tkMakeServerCall("web.DHCBILLLLibraryLogic","DeleteScroll",delStr);
    if(rtn==="0"){
		alert(t['deleteSuccess']);   
		find_click();
    }else{
		alert(t['deleteFailure']);	
	}
}
//清屏
function btnClear_OnClick(){
	websys_$("txtComponentName").value="";
	websys_$("componentRowid").value="";
	websys_$("txtGuser").value="";
	websys_$("guserRowid").value="";
	websys_$("txtGroup").value="";
	websys_$("groupRowid").value="";
	websys_$("txtScrollWidth").value="";
	websys_$("txtScrollHeight").value="";
	websys_$("listScrollLocation").value="";
	websys_$("listScope").options[0].selected=true;
	websys_$("listScrollLocation").options[0].selected=true;
	websys_$("colLockFlag").value="";
	websys_$("colLockFlag").checked=false;
	find_click();
}
function Component_LookUp(value){
    ///76^APCVendCat.Find^web.APCVendCat^^F^
	var tmp=value.split("^");
    if(websys_$("txtComponentName"))websys_$("txtComponentName").value=tmp[1];
    if(websys_$("componentRowid"))websys_$("componentRowid").value=tmp[0];
}
function Guser_LookUp(value){
	var tmp=value.split("^");
	if(websys_$("txtGuser"))websys_$("txtGuser").value=tmp[0];
	if(websys_$("guserRowid"))websys_$("guserRowid").value=tmp[2];
}
function Group_LookUp(value){
	var tmp=value.split("^");
	if(websys_$("txtGroup"))websys_$("txtGroup").value=tmp[1];
	if(websys_$("groupRowid"))websys_$("groupRowid").value=tmp[0];	
}
function ComponentName_OnKeyDown(){
	var key=websys_getKey(e);
	if (key==13) {
		 window.event.keyCode=117;	   
	     txtComponentName_lookuphandler();
	     DHCWeb_Nextfocus();	
	}
}
function Group_OnKeyDown(){
	var key=websys_getKey(e);
	if (key==13) {
		 window.event.keyCode=117;	   
	     txtGroup_lookuphandler();
	     DHCWeb_Nextfocus();	
	}
}
function Guser_OnKeyDown(){
	var key=websys_getKey(e);
	if (key==13) {
		window.event.keyCode=117;	   
	     txtGuser_lookuphandler();
	     DHCWeb_Nextfocus();	
	}
}
///Lid
///2010-06-24
function GetSelectRowid(){
	var rows=DHCWeb_GetTBRows("tDHCBILLSetScrollStyle")
    if(rows<1){
		return -1;    
	}
	var str=new StringBuffer(); 
	for (var i=1;i<=rows;i++){
		var sSelect=document.getElementById('TSelectz'+i);
		if (sSelect.checked){
		        var compName=websys_$("TComponentNamez"+i).innerText;
			    var sub=websys_$("TSubz"+i).value; 	    
		        var scope=websys_$("TScopeDescz"+i).innerText;
		        if(scope==="站点"){
			    	scope="SITE";    
			    }else if(scope==="安全组"){
					scope="GROUP"    
				}else{
					scope="GUSER"	
				}
		        str.append(compName+"^"+scope+"^"+sub);
		}
	}
	
	var rtn=str.toString("!");
	return rtn;
}
function SelectRowHandler(){
   var eSrc=window.event.srcElement;
   var rowobj=getRow(eSrc)
   Objtbl=document.getElementById('tDHCBILLSetScrollStyle');
   Rows=Objtbl.rows.length;
   var lastrowindex=Rows - 1;
   var rowObj=getRow(eSrc);
   var selectrow=rowObj.rowIndex;
   if (!selectrow) return;
   if (selectrow!=SelectedRow) {
        var SelRowObj=websys_$('TComponentNamez'+selectrow);
      	websys_$("txtComponentName").value=SelRowObj.innerText;
      	var selGuserName=websys_$('TGuserNamez'+selectrow).innerText;
      	var selGroupDesc=websys_$('TGroupDescz'+selectrow).innerText;
      	var selSub=websys_$('TSubz'+selectrow).value;
      	var scope=websys_$('TScopeDescz'+selectrow).innerText;
		if(scope==="站点"){
			  websys_$("listScope").options[0].selected=true;     
	     }else if(scope==="安全组"){
			  websys_$("listScope").options[1].selected=true;
			  websys_$("txtGroup").value=selGroupDesc;
			  websys_$("groupRowid").value=selSub;    
		 }else{
			  websys_$("listScope").options[2].selected=true;
			  websys_$("txtGuser").value=selGuserName;
			  websys_$("guserRowid").value=selSub;	
		 }
		var selWidth=websys_$('TWidthz'+selectrow).innerText;
      	var selHeight=websys_$('THeightz'+selectrow).innerText;
		websys_$("txtScrollWidth").value=selWidth;
		websys_$("txtScrollHeight").value=selHeight;
		 var selLocation=websys_$("TLocationz"+selectrow).innerText;
		 if(selLocation==="左"){
		    websys_$("listScrollLocation").options[1].selected=true;	 
		 }else{
			 websys_$("listScrollLocation").options[0].selected=true;	 
	     }
   }   
}
document.body.onload = BodyLoadHandler;