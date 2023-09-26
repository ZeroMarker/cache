var ssTarId="",ssHisCode="",ssHisDesc="",ssConId="",ssInsuId="",ssInsuCode="",ssInsuDesc=""
var iSeldRow=0
var InsuTypelgl=""
var userID,userCode,userName=""
function BodyLoadHandler() {
	
	userID=session['LOGON.USERID'];
	userCode=session['LOGON.USERCODE'];
	userName=session['LOGON.USERNAME'];

	var obj=document.getElementById("Contrast");
	if (obj){ obj.onclick=Updat_click;}
	var obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click;}	
	var obj=document.getElementById("cmdQuery");
	if (obj){ obj.onclick=List_click;}	
	var obj=document.getElementById("InsuQuery");
	if (obj){ obj.onkeydown=GetInsuQuery;}
	var obj=document.getElementById("Query");
	if(obj){obj.onclick=Query_onclick}
	
	
	//var obj=document.getElementById("Class");
	//if(obj){obj.onchange=iniSkypeType}
	
	
	//if(obj) {obj.onclick=Find_onclick}
	//iniSkypeType()
	ini();
	websys_setfocus('InsuQuery')
	
	//insertSepBtn('fINSUTarContrastCom');//调用DHCCPMSepPage.js
    //SepPage('fINSUTarContrastCom','tINSUTarContrastCom',50);  //调用DHCCPMSepPage.js
	
	}
	
function Query_onclick()        //20090422 增加按日期查询功能控制
{   var obj=document.getElementById("Class");
	if (obj.value=="4")
	{
	var obj=document.getElementById("sKeyWord");
	//alert(obj.value)
	if (obj.value!="")
		{
		var flag=validateCNDate(obj.value) 
		if(flag){Query_click()}
		}
	else {alert("请输入日期")}
	}
	else {Query_click()}
}

function validateCNDate( strValue ) 
{ 
var objRegExp = /^\d{4}(\-|\/|\.)\d{1,2}\1\d{1,2}$/ 

if(!objRegExp.test(strValue))
   { 
	alert("请按格式输入正确的日期")
	return false; 
   }
else
   { 
	var arrayDate = strValue.split(RegExp.$1); 
	var intDay = parseInt(arrayDate[2],10); 
	var intYear = parseInt(arrayDate[0],10); 
	var intMonth = parseInt(arrayDate[1],10); 
	if(intMonth > 12 || intMonth < 1) { 
	return false; 
   } 
var arrayLookup = { '1' : 31,'3' : 31, '4' : 30,'5' : 31,'6' : 30,'7' : 31, 
'8' : 31,'9' : 30,'10' : 31,'11' : 30,'12' : 31} 
if(arrayLookup[parseInt(arrayDate[1])] != null) 
   { 
	if(intDay <= arrayLookup[parseInt(arrayDate[1])] && intDay != 0) 
	return true; 
   } 
if (intMonth-2 ==0) 
   { 
	var booLeapYear = (intYear % 4 == 0 && (intYear % 100 != 0 || intYear % 400 == 0)); 
	if( ((booLeapYear && intDay <= 29) || (!booLeapYear && intDay <=28)) && intDay !=0) 
	{return true;
	}
	else 
	{
	alert("请按格式输入正确的日期")
	return false; 
		} 
   } 
   
} 
	alert("请按格式输入正确的日期")
	return false; 
} 






function GetInsuQuery() {
	if (window.event.keyCode==13) 
	{
	window.event.keyCode=117; InsuQuery_lookuphandler(); }
	}
function ini(){
	var obj=document.getElementById("Type");
	if (obj){
		
	  obj.size=1; 
	  obj.multiple=false;
	  FillTypeList(obj)
		var n=obj.length
		var Typeobj=document.getElementById("TypeSave");
		if(Typeobj.value==""){
			obj.options[0].selected=true
		}
		else{
			for (var i =0;i<n;i++){
				if(obj.options[i].value==Typeobj.value){
				obj.options[i].selected=true
				}
			}
		}
	}
	var obj=document.getElementById("Class");
	if (obj){	
	  obj.size=1; 
	  obj.multiple=false;	 
	  obj.options[0]=new Option(t['msClass1'],"1");
	  obj.options[1]=new Option(t['msClass2'],"2");
	  obj.options[2]=new Option(t['msClass3'],"3");
	  //obj.options[3]=new Option(t['msClass4'],"4");
	  //obj.options[4]=new Option("查询所有限制药品","5");
		}
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
	  obj.size=1; 
	  obj.multiple=false;
	  obj.options[0]=new Option(t['msConType1'],"A");
	  obj.options[1]=new Option(t['msConType2'],"Y");
	  obj.options[2]=new Option(t['msConType3'],"N");
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
	
	//下面的程序是用于在界面上默认显示空 Lou 2010-03-03注释
	/*var obj=document.getElementById("Type");
	if (obj){
      var n=obj.length
      for (var i =0;i<n;i++){
		  var Typeobj=document.getElementById("TypeSave");
		  if(obj.options[i].value==Typeobj.value){
		  obj.options[i].selected=true
		  }
	      }
	}
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
	}*/
	
	}
	
function Updat_click(){
	//alert("UpdateStr");
	var obj=document.getElementById("InsuId");
	if (obj){ssInsuId=obj.value}
	//alert(1);
	var obj=document.getElementById("InsuQuery");
	if (obj){ssInsuDesc=obj.value}
	//alert(2);
	//Add By wuqk 2006-03-10 增加生效日期
	
	var obj=document.getElementById("iActDate");
	if (obj){ssiActDate=obj.value}
	
	//alert(3);
    var Data=ssiActDate.split("/")
    ssiActDate=Data[2]+"-"+Data[1]+"-"+Data[0]
	
	//alert(ssInsuId+"   -   "+ssTarId+"   -   "+ssHisDesc+"   -   "+"   -   "+"   -   "+ssInsuCode+"   -   "+ssInsuDesc)
	if ((ssInsuId=="")||(ssTarId=="")||(ssiActDate=="")){return false}
	//if (confirm("Are you sure contrast it,"+ssHisCode+"-"+ssHisDesc+" to -> "+ssInsuDesc+" ?")){
	//alert(11)
	if (confirm(t['01']+ssHisCode+"-"+ssHisDesc+t['02']+ssInsuDesc+" ?")){
			
		var Qty=1,InsuType="",ElsString=""
		var obj
		obj=document.getElementById('Type');
        if (obj) {InsuType=obj.value};
		obj=document.getElementById('iQty');
        if (obj) {Qty=obj.value};
        
        //Add By wuqk 2006-03-10 增加生效日期
    //s ContId=$p(Instring,"^",1)
    //s HisDr=$p(Instring,"^",2)
    //s HisCode=$p(Instring,"^",3)
    //s HisDesc=$p(Instring,"^",4)
    //s InsuDr=$p(Instring,"^",5)
    //s InsuCode=$p(Instring,"^",6)
    //s InsuDesc=$p(Instring,"^",7)
    //s Class=$p(Instring,"^",8)
    //s Level=$p(Instring,"^",9)
    //s PatTypeDr=$p(Instring,"^",10)
    //s Amount=$p(Instring,"^",11)
    //s DrAddFlag=$p(Instring,"^",12)
    //s ActiveDate=$zdh($p(Instring,"^",13),3)
    //s ZText=$p(Instring,"^",14)
    //s DicType=$p(Instring,"^",15)
       // alert("InsuType"+InsuType)
       
        //var UpdateStr="^"+ssTarId+"^"+ssHisCode+"^"+ssHisDesc+"^"+ssInsuId+"^"+"^"+ssInsuDesc+"^"+"^"+"^"+"^"+Qty+"^"+"^"+ssiActDate+"^"+"^"+InsuType
       
        var UpdateStr="^"+ssTarId+"^"+ssHisCode+"^"+ssHisDesc+"^"+ssInsuId+"^"+"^"+ssInsuDesc+"^"+"^"+"^"+"^"+Qty+"^"+"^"+ssiActDate+"^"+"^"+InsuType+"^"+userID+"^"+"TEST^TEST"  
        //alert(UpdateStr)
        //var UpdateStr=ssConId+"^"+ssTarId+"^"+ssInsuId+"^"+Qty+"^"+InsuType+"^"+ElsString
		//alert(1)
		var Ins=document.getElementById('ClassTxtUpdate');
        if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
       // alert("UpdateStr")
        var flag=cspRunServerMethod(encmeth,'','',UpdateStr)
        //alert(flag)
        if (flag=="0"){
	        //alert('ok');
	        location.reload();        //不刷新怎么过滤ˋ
	        websys_setfocus('InsuQuery')
	        }
	    else if (flag>0){
	        //alert('ok');
	       alert(t['06'])
	        }
	    else{
	        //alert('Error ! ErrNo='+flag);
	        alert(t['03']+flag);
		    }		
		}	   
	}
function Delete_click(){
	if (ssConId=="") {		
		alert(t['04']);
		return false;
		}
	
	if (confirm(t['05'])){		
		var Ins=document.getElementById('ClassTxtDelete');
        if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
        var flag=cspRunServerMethod(encmeth,'','',ssConId)
        
        if (flag=="0"){
	        alert('ok');
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
function SetInsuString(value){	
	var TarCate=value
	var TempData=TarCate.split("^")
	var obj=document.getElementById("InsuQuery");
	if (obj){obj.value=TempData[4]}
	var obj=document.getElementById("InsuId");
	if (obj){obj.value=TempData[0]}
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
	var objtbl=document.getElementById('tINSUTarContrastCom');
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
		ssInsuId="";
		ssInsuCode="";
		ssInsuDesc="";
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
	
	SelRowObj=document.getElementById('TInsuIdz'+selectrow);	
	if (SelRowObj){ssInsuId=SelRowObj.value}
	else{ssInsuId=""}
	
	SelRowObj=document.getElementById('InsuCodez'+selectrow);	
	if (SelRowObj){ssInsuCode=SelRowObj.innerText}
	else{ssInsuCode=""}	
	
	SelRowObj=document.getElementById('InsuDescz'+selectrow);		
	if (SelRowObj){ssInsuDesc=SelRowObj.innerText}
	else{ssInsuDesc=""}
}	

function FillTypeList(obj){
	//var OutStr=-1
	var VerStr="";
	VerStr=tkMakeServerCall("web.INSUDicDataCom","GetSys","","","TariType");
	if (VerStr==""){
		return false;
	}
	var i
	var VerArr1=VerStr.split("!");
	var ArrTxt= new Array(VerArr1.length-2);
	var ArrValue = new Array(VerArr1.length-2);
	for(i=1;i<VerArr1.length;i++){
		var VerArr2=VerArr1[i].split("^");
		ArrTxt[i-1]=VerArr2[3];
		ArrValue[i-1]=VerArr2[2];
		}
		ClearAllList(obj);
		AddItemToList(obj,ArrTxt,ArrValue)

	}
function ClearAllList(obj) {
	if (obj.options.length>0) {
	for (var i=obj.options.length-1; i>=0; i--) obj.options[i] = null;
	}
}	
function AddItemToList(obj,arytxt,aryval) {
	if (arytxt.length>0) {
		if (arytxt[0]!="") {
			var lstlen=obj.length;
			for (var i=0;i<arytxt.length;i++) {
				
				obj.options[lstlen] = new Option(arytxt[i],aryval[i]); 
				var AvlQty=aryval[i].split("&")
				//alert(AvlQty[4])
				if ( AvlQty[4]== 1 ) {
					obj.options[lstlen].style.color="green";
				}
				if( AvlQty[4]<1 ){
					obj.options[lstlen].style.color="red";
				}
				lstlen++;}
		}
	}
}

document.body.onload = BodyLoadHandler;