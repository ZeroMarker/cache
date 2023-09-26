//DHCINSUTarConTar
//
//
var ssTarId="",ssHisCode="",ssHisDesc="",ssConId="",ssvsId="",vsHisCode="",vsHisDesc="",TvsId="",TvsCode=""
var iSeldRow=0
var InsuTypelgl=""
var Typevalue
function BodyLoadHandler() {
	var obj=document.getElementById("Contrast");
	if (obj){obj.onclick=Updat_click;}
	var obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click;}	
	var obj=document.getElementById("cmdQuery");
	if (obj){ obj.onclick=List_click;}	
	var obj=document.getElementById("vsQuery");
	if (obj){ obj.onkeydown=GetvsQuery;}
	var obj=document.getElementById("TarCateDesc");
	if (obj){ obj.onkeydown=GetTarCateDesc;}
	var obj=document.getElementById("sKeyWord");
	if (obj){ obj.onkeydown=GetsKeyWord;}
	var obj=document.getElementById("TarChange")
	if (obj) {obj.disabled=true;}
	ini();
	var obj=document.getElementById("Type")
	if (obj) {obj.onchange=GetDisable;}
	var obj=document.getElementById("TarChange");
	if (obj){obj.onclick=Change_click; }
	var obj=document.getElementById("TarDelete");
	if (obj){obj.onclick=TarDelete_click; }
	}
function GetDisable() {
	var obj=document.getElementById("Type")
	//alert(obj.value)
	var tmpobj=document.getElementById("TarChange")
	if(obj.value=="02"||obj.value=="03"){
		tmpobj.disabled=false
		}
	else{tmpobj.disabled=true}
	
}
function Change_click() {
	var obj=document.getElementById("TarChange")
	if (obj.disabled==true){return false;}
	var obj=document.getElementById("Type")

	if (obj) {Type=obj.value}
	if(Type=="") {return false}
	if(ssHisCode=="") {return false}
	var instring=ssHisCode+ "^" +Type
	alert(instring)
	 var ssiActDate="",rowid=""
	var Ins=document.getElementById('changeupdate');
        if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
        var flag=cspRunServerMethod(encmeth,'','',instring)
        alert(flag)
        if (flag>"0"){
	        if (Type=="02") {ssvsHisCode=ssHisCode+"x1";}
	        if (Type=="03") {ssvsHisCode=ssHisCode+"x2";}
	        if (ssvsId!=0){rowid=ssvsId}
	        var UpdateStr=rowid+"^"+ssTarId+"^"+ssHisCode+"^"+flag+"^"+ssvsHisCode+"^"+Type+"^"+ssiActDate+"^"+"^"+"^"
		alert(UpdateStr)
		var Ins=document.getElementById('ClassTxtUpdate');
        if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
        var flag=cspRunServerMethod(encmeth,'','',UpdateStr)
        if (flag=="0"){
	        //alert('ok');
	        location.reload();
	        }
	    else{
	        alert('Error ! ErrNo='+flag);
	        //alert(t['03']+flag);
		    }		
	        }
	    else if(flag=="-100"){alert("项目已存在")}
	    
		else {alert("添加项目失败")
	        //alert(t['07']);
		    }
			   
}

function GetvsQuery() {
	if (window.event.keyCode==13) 
	{
	window.event.keyCode=117; vsQuery_lookuphandler(); }
	}
function GetTarCateDesc() {
	if (window.event.keyCode==13) 
	{

	window.event.keyCode=117; TarCateDesc_lookuphandler(); }
	}
function GetsKeyWord() {
	if (window.event.keyCode==13) 
	{
	window.event.keyCode=117; Query_click(); }
	}
function ini()
{
	var obj=document.getElementById("Type");
	if (obj)
	{
	 obj.size=1; 
	 obj.multiple=false;
	  obj.options[1]=new Option(t['msType1'],"01");
	  obj.options[2]=new Option(t['msType2'],"02");
	  obj.options[3]=new Option(t['msType3'],"03");
	  obj.options[0]=new Option("","");
	  obj.options[0].selected=true;
	}

	var obj=document.getElementById("Class");
	if (obj)
	{	
	  obj.size=1; 
	  obj.multiple=false;
	  //obj.options[0]=new Option("PY","0");
	  //obj.options[0]=new Option("PY","1");
	  //obj.options[1]=new Option("CODE","2");
	  //obj.options[2]=new Option("DESC","3");	 
	  obj.options[0]=new Option(t['msClass1'],"1");
	  obj.options[1]=new Option(t['msClass2'],"2");
	  obj.options[2]=new Option(t['msClass3'],"3");
	  obj.options[0].selected=true;
	}
	
	var obj=document.getElementById("ConType");
	if (obj)
	{	
	  obj.size=1; 
	  obj.multiple=false;
	  //obj.options[0]=new Option("PY","0");
	  //obj.options[0]=new Option("All","A");
	  //obj.options[1]=new Option("Yes","Y");
	  //obj.options[2]=new Option("No","N");
	  obj.options[0]=new Option(t['msConType1'],"A");
	  obj.options[1]=new Option(t['msConType2'],"Y");
	  obj.options[2]=new Option(t['msConType3'],"N");
	  obj.options[0].selected=true;
	}
	
	
	
	var obj=document.getElementById("Type");
	if (obj)
	{
      var n=obj.length
      for (var i =0;i<n;i++)
      {
		  var Typeobj=document.getElementById("TypeSave");
		  if(obj.options[i].value==Typeobj.value)
		  {
		  obj.options[i].selected=true
		  }
	  }
	  var tmpobj=document.getElementById("TarChange")
	  if(obj.value=="02"||obj.value=="03")
	  {
		  tmpobj.disabled=false
	}
}
	
	
	/*
	var obj=document.getElementById("TarChange");
	if (obj){
		//obj.disabled=true
		var tmpobj=document.getElementById("Type")
		if(tmpobj){
			obj.disabled=true
			if((tmpobj.value="02")||(tmpobj.value="03")){alert(tmpobj.value)}//obj.disabled=false}
		}
	}
	
	*/
	
	var obj=document.getElementById("Class");
	if (obj){
      var n=obj.length
      for (var i =0;i<n;i++){
		  var Typeobj=document.getElementById("ClassSave");
		  if(obj.options[i].value==Typeobj.value){
		  obj.options[i].selected=true
		  }
	      }
	}
	var obj=document.getElementById("ConType");
	if (obj){
      var n=obj.length
      for (var i =0;i<n;i++){
		  var Typeobj=document.getElementById("ConTypeSave");
		  if(obj.options[i].value==Typeobj.value){
		  obj.options[i].selected=true
		  }
	      }
	}
	}
	
function Updat_click(){
	var rowid=""
	var obj=document.getElementById("TvsId");
	if (obj){TvsId=obj.value;}
	var obj=document.getElementById("vsQuery");
	if (obj){ssvsHisDesc=obj.value; }
	var obj=document.getElementById("TvsCode");
	if (obj){ssvsHisCode=obj.value;    		}
	//var charType=ssvsHisCode.charAt(ssvsHisCode.length-1)
	var charType=ssvsHisCode.substring(ssvsHisCode.length-2,ssvsHisCode.length) //Lou 2009-06-10
	//alert(charType)
	//modefy by zhangdongliang  这要改很多地方?判断具体类别
	if (charType=='x1'){Type="02"}
	else if (charType=='x2'){Type="03"} 
	else {Type="01"} 
	//var obj=document.getElementById('Type');
    //if (obj) {Type=obj.value};
    if(Type==""){alert(t['08']); return false }   //add by yjz_20081024
	//var obj=document.getElementById("iActDate");
	//if (obj){ssiActDate=obj.value;}
    //var Data=ssiActDate.split("/")
    //ssiActDate=Data[2]+"-"+Data[1]+"-"+Data[0]
    var ssiActDate=""
    	
	if ((TvsId=="")||(ssTarId=="")){return false}
	if (confirm(t['01']+ssHisCode+"-"+ssHisDesc+t['02']+ssvsHisDesc+" ?")){
		//var Qty=1,Type="",ElsString=""

		if (ssvsId!=0){rowid=ssvsId}
  		var UpdateStr=rowid+"^"+ssTarId+"^"+ssHisCode+"^"+TvsId+"^"+ssvsHisCode+"^"+Type+"^"+ssiActDate+"^"+"^"+"^"
		var Ins=document.getElementById('ClassTxtUpdate');
        if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
        alert(UpdateStr)
        var flag=cspRunServerMethod(encmeth,'','',UpdateStr)
        if (flag=="0"){
	        //alert('ok');
	        location.reload();
	        }
	    else{
	        alert('Error ! ErrNo='+flag);
	        //alert(t['03']+flag);
		    }		
		}	   
	} 
function Delete_click(){
	if (ssvsId=="") {
		//alert("No contrasted!");
		alert(t['04']);
		return false;
		}
	//if (confirm("Are you sure delete it?")){
	if (confirm(t['05'])){		
		var Ins=document.getElementById('ClassTxtDelete');
        if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
        var flag=cspRunServerMethod(encmeth,'','',ssvsId)
        if (flag=="0"){
	        //alert('ok');
	        location.reload();
	        }
	    else{
	        //alert('Error ! ErrNo='+flag);
	        alert(t['03']+flag);
		    }		
		}
	
	}	
function SetTarCate(value){	
	var TarCate=value
	var TempData=TarCate.split("^")
	var obj=document.getElementById("TarCate");
	if (obj){obj.value=TempData[0]}
	var obj=document.getElementById("TarCateDesc");
	if (obj){obj.value=TempData[2]}	
	}
function SetvsString(value){
	
	var TarCate=value
	var TempData=TarCate.split("^")

	var obj=document.getElementById("vsQuery");
	if (obj){obj.value=TempData[2]}
	var obj=document.getElementById("TvsId");
	if (obj){obj.value=TempData[0]}
	var obj=document.getElementById("TvsCode");
	if (obj){obj.value=TempData[1]}
	}
	
function List_click(){
	var InsuType=""
	obj=document.getElementById('Type');
	if (obj) {InsuType=obj.value};
	if ((InsuType=="")||(ssTarId=="")){return false}	
	var str='websys.default.csp?WEBSYS.TCOMPONENT=INSUTarContrastListCom&TarId='+ssTarId+'&Type='+InsuType;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=680,height=520,left=0,top=0')
    //location.href=str
}
	
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCINSUTarConTar');
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
     
    //alert(selectrow+"/"+rows)
    
	if (!selectrow) return;
	if (iSeldRow==selectrow){
		iSeldRow=0
		ssTarId="";
		ssHisCode="";
		ssHisDesc="";
		ssConId="";
		ssvsId="";
		ssvsHisCode="";
		ssvsHisDesc="";
		return;
		}
	
	iSeldRow=selectrow;
	var SelRowObj
	var obj
	//ssTarId,ssHisCode,ssHisDesc,ssConId,ssInsuId,ssInsuCode,ssInsuDesc
	SelRowObj=document.getElementById('TarIdz'+selectrow);
	if (SelRowObj){ssTarId=SelRowObj.value}
	else{ssTarId=""}	
	SelRowObj=document.getElementById('HisCodez'+selectrow);
	if (SelRowObj){ssHisCode=SelRowObj.innerText}
	else{ssHisCode=""}
	
	SelRowObj=document.getElementById('HisDescz'+selectrow);
	if (SelRowObj){ssHisDesc=SelRowObj.innerText}
	else{ssHisDesc=""}
	
	SelRowObj=document.getElementById('ConIdz'+selectrow);	
	if (SelRowObj){ssConId=SelRowObj.value}
	else{ssConId=""}
	
	SelRowObj=document.getElementById('vsIdz'+selectrow);	
	if (SelRowObj){ssvsId=SelRowObj.value}
	else{ssvsId=""}

	SelRowObj=document.getElementById('vsHisCodez'+selectrow);	
	if (SelRowObj){ssvsHisCode=SelRowObj.innerText}
	else{ssvsHisCode=""}	
	
	SelRowObj=document.getElementById('vsHisDescz'+selectrow);		
	if (SelRowObj){ssvsHisDesc=SelRowObj.innerText}
	else{ssvsHisDesc=""}
}	
//     add by yjz_20081105
function TarDelete_click(){
	if(ssTarId==""){return false;}
	if (confirm(t['01']+ssHisCode+"-"+ssHisDesc+t['06'])){	
		var Ins=document.getElementById('changedelete');
	    if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
	    var flag=cspRunServerMethod(encmeth,'','',ssTarId)
	    if (flag=="0"){
	        //alert('ok');
	        location.reload();
	        }
	    else{
	        //alert('Error ! ErrNo='+flag);
	        alert(t['03']+flag);
		    }		
		}
	
	
}	
document.body.onload = BodyLoadHandler;