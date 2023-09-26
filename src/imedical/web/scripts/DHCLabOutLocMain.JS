///Creator Qiuxianfu 2013.09.01
///DHCLabOutLocMain.JS
///标本运送管理
var ctlocid=session['LOGON.CTLOCID'];
var UserId=session['LOGON.USERID'];
var ObjCreatNo=document.getElementById("CreatNo");
if (ObjCreatNo) ObjCreatNo.onclick=CreatTransmitNo;
var ObjExchangeNo=document.getElementById("ExchangeNo");
if (ObjExchangeNo) ObjExchangeNo.onclick=ExchangeNo;
var ObjDeleteNo=document.getElementById("DeleteNo")
if (ObjDeleteNo) {ObjDeleteNo.onclick=TransNoDelete;}
var ObjTatSum=document.getElementById("TatSum");
if (ObjTatSum) {
	TatSum();
}
function BodyUnLoadHandler(){

}

document.body.onload = BodyLoadHandler;
document.body.onunload = BodyUnLoadHandler;

function BodyLoadHandler()
{   
	ObjCreatNo=document.getElementById("CreatNo");
	if (ObjCreatNo) ObjCreatNo.onclick=CreatTransmitNo;
	ObjExchangeNo=document.getElementById("ExchangeNo");
	if (ObjExchangeNo) ObjExchangeNo.onclick=ExchangeNo;
	obj=document.getElementById("SpecType");
	if (obj){
	        obj.size=1;
	        obj.multiple=false;	 
	        obj.options[0]=new Option("标本","S");
	        obj.options[1]=new Option("血袋","P");
	  		obj.selectedIndex=0;
	}
	var objStr=document.getElementById("getTransName");
	if (objStr){
		    encmeth=objStr.value
		    var objTransName=cspRunServerMethod(encmeth,'');
		    pl=objTransName.split("^");
		    var j=0;
		    var ObjTransUser=document.getElementById("TransUser")
		    for (i=0;i<=pl.length-1;i++){
			    pld=pl[i].split(",")
		        ObjTransUser.size=1;
		        ObjTransUser.multiple=false;	 
		        ObjTransUser.options[j]=new Option(pld[1],pld[0]);
		        //objStr.options[1]=new Option("血袋","P");
		  		j=j+1
		    }
		    objStr.selectedIndex=0;
	}
	else {
		var encmeth=''
	};
   var objPrint=document.getElementById('PrintBar');
   if (objPrint) objPrint.onclick=Print;
   var objDateS=document.getElementById("DateS");
   if (objDateS){
	   if (objDateS.value==""){
		   objDateS.value=myDate.toLocaleDateString()
		   }
	   }
   var objDateE=obj=document.getElementById("DateE");
   if (objDateE){
	   if (objDateE.value==""){
		   objDateE.value=myDate.toLocaleDateString()
		   }
	   }
}

function SelectRowHandler()
 {  
    var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCLabOutLocMain');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var SelRowObj=document.getElementById('TransNoz'+selectrow);
	SelectedRow=selectrow;
	TransNo=SelRowObj.innerText;
	var ObjTransNumber=document.getElementById("TransNumber");
	if (ObjTransNumber)	{ObjTransNumber.value=TransNo;}
    var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCLabOutLocExec&TransmitNo="+TransNo;
    
    parent.frames[1].location.href=lnk; 

 }
 
function CreatTransmitNo(){ 
    var RetStr="";
    var GetTransmitNo="";
	var ObjCreatTranmitNo=document.getElementById("gettransNo")
	
	if (ObjCreatTranmitNo)
	{   

		RetStr=cspRunServerMethod(ObjCreatTranmitNo.value);
		var ObjGetTransmitNo=document.getElementById("TransNumber");
		ObjGetTransmitNo.innerText=RetStr;
		var DateS="";
		var DateE=""
		var ret=SaveTransNo(RetStr);
		//var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCLabOutLocMain&DateS="+DateS+"&DateE="+DateE;
    	//parent.frames[1].location.href=lnk; 	
	}
		Find_click();
	return "";	
}

function SaveTransNo(TransNo){
	ObjSaveTransNo=document.getElementById("savetransNo");
	SpecType=DHCC_GetElementData("SpecType");
	if (ObjSaveTransNo){
	//alert(1+TransNo+2+ctlocid+3+SpecType);	
	ret=cspRunServerMethod(ObjSaveTransNo.value,TransNo,ctlocid,SpecType);
	}
	//var ret=QueryMainInfo();
	return ret;
}
function DHCC_GetElementData(ElementName){
  var obj=document.getElementById(ElementName);
  if (obj){
    if (obj.tagName=='LABEL'){
      return obj.innerText;
    }else{
      if (obj.type=='checkbox') return obj.checked;
      return obj.value;
      }
    }
  return "";
}
function ExchangeNo(){
	var ContainerNo=DHCC_GetElementData("ContainerNo")
	var TransUser=DHCC_GetElementData("TransUser")
	var ObjCheckTransNo=document.getElementById("CheckTransNo");
	//alert(TransNo+ContainerNo+TransUser);
	if (ObjCheckTransNo){
		retStr=cspRunServerMethod(ObjCheckTransNo.value,TransNo,ContainerNo,TransUser);
		//var StrInfo=retStr.split("^");
		var flag=retStr.substring(0,1)
		if (flag==0) {
			ExchangeNo_Click(TransNo,ContainerNo,TransUser);}
		else if(flag==1){
			if(window.confirm(retStr.substring(2,retStr.length)+"确实要交接吗？")){
			ExchangeNo_Click(TransNo,ContainerNo,TransUser);}
		}
		else{
		alert(retStr.substring(1,retStr.length));}
		}
		return "";
}
function ExchangeNo_Click(TransNo,ContainerNo,TransUser){
	var ObjExchangeTransNo=document.getElementById("ExchangeTransNo");
	if (ObjExchangeTransNo) {
		//alert(1+TransNo+2+ContainerNo+3+TransUser+4+UserId+5+ctlocid);
		retStr=cspRunServerMethod(ObjExchangeTransNo.value,TransNo,ContainerNo,TransUser,UserId,ctlocid);
		if (retStr==0){
			alert("交接成功！");
			//alert(TransNo);
			var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCLabOutLocExec&TransmitNo="+TransNo;
            parent.frames[1].location.href=lnk; 
		}
		else{
		alert("交接失败！")}
		}
	Find_click();
	return "";
}
function TransNoDelete(){
		if(window.confirm("确实要删除吗？")){
		var ObjTransNumber=document.getElementById("TransNumber");
	    if (ObjTransNumber)	{TransNo=ObjTransNumber.value;}
		var ObjCheckTransNoDelete=document.getElementById("CheckTransNoDelete");
		if (ObjCheckTransNoDelete){
			retStr=cspRunServerMethod(ObjCheckTransNoDelete.value,TransNo);
			if (retStr==0){
			TransNoDelete_Click(TransNo);
			Find_click();}
			else{
			alert(retStr.substring(1,retStr.length));}
		}
	}
}
function TransNoDelete_Click(TransNo){
	var ObjDeleteTransNo=document.getElementById("DeleteTransNo");
	if (ObjDeleteTransNo) {
		ret=cspRunServerMethod(ObjDeleteTransNo.value,TransNo);
		if (ret==0){
			alert("删除成功！");
			//var TransmitNo=DHCC_GetElementData("TransmitNo");
			//var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCLabOutLocExec&TransmitNo="+TransmitNo;
    		//parent.frames[1].location.href=lnk; 
        }
		else{
		alert("删除失败！");}
	}
	//alert(labNo);
}
function TatSum(){
	var DateS=DHCC_GetElementData("DateS");
	var DateE=DHCC_GetElementData("DateE");
	//DateS=formatDate(DateS,"DD/MM/YYYY");
	//DateE=formatDate(DateE,"YYYY-MM-DD");
	//alert(DateS+"--"+DateE);
	var ObjTatSum=document.getElementById("TatSum");
	if (ObjTatSum){
		//ret=0
		ret=cspRunServerMethod(ObjTatSum.value,DateS,DateE);
		var ObjSampleSum=document.getElementById("SampleSum");
		if (ObjSampleSum) {ObjSampleSum.value=ret;}
	}
}
function formatDate(date, format) {   
    if (!date) return;   
    if (!format) format = "yyyy-MM-dd";   
    switch(typeof date) {   
        case "string":  
            alert("Q"+date) 
            date = new Date(date.replace("-", "/"));
            alert(date);   
            break;   
        case "number":   
            date = new Date(date);   
            break;   
    }    
    if (!date instanceof Date) return;   
    var dict = {   
        "yyyy": date.getFullYear(),   
        "M": date.getMonth() + 1,   
        "d": date.getDate(),   
        "H": date.getHours(),   
        "m": date.getMinutes(),   
        "s": date.getSeconds(),   
        "MM": ("" + (date.getMonth() + 101)).substr(1),   
        "dd": ("" + (date.getDate() + 100)).substr(1),   
        "HH": ("" + (date.getHours() + 100)).substr(1),   
        "mm": ("" + (date.getMinutes() + 100)).substr(1),   
        "ss": ("" + (date.getSeconds() + 100)).substr(1)   
    };       
    return format.replace(/(yyyy|MM?|dd?|HH?|ss?|mm?)/g, function() {   
        return dict[arguments[0]];   
    });                   
} 
//打印发血单
function Print()
{
    var xlApp,obook,osheet,xlsheet,xlBook
	var RowStart=7;
	var PatName,Debtor,ABO,RH,Location;
	var ReserveDateTime;
	var TakeInfo;
	//审核标志
	var isAudDateTime;
	var isEgy; //急诊标志
	var getpath=document.getElementById('getPath');
	if (getpath) {var encmeth=getpath.value} else {var encmeth=''};
	path=cspRunServerMethod(encmeth,'');
	var Template=path+"DHCSpecmenTransNo.xls";
	//创建新的打印对象.
	        var ObjTransNumber=document.getElementById("TransNumber");
	        if (ObjTransNumber)	{TransNo=ObjTransNumber.value;}
			//alert(TransNo);
			if (TransNo=="") {
				alert("未选中运送单号!")
			}
			else
			{
			xlApp = new ActiveXObject("Excel.Application");
			xlBook = xlApp.Workbooks.Add(Template);
			xlsheet = xlBook.ActiveSheet;

	    	//基本资料赋值
	    	xlsheet.cells(1,1).value="*"+TransNo+"*"; //姓名
	    	xlsheet.cells(2,3).value=TransNo;//性别
	        //xlsheet.cells(2,1).value=TransNo; //姓名
	    	//xlsheet.cells(2,2).value=TransNo;//性别
			//其他信息
			
         	xlApp.Visible=false;
        	//xlsheet.PrintPreview();
         	xlsheet.PrintOut();
         	xlBook.Close(savechanges=false);
         	xlApp.Quit();
         	xlApp=null;
        	xlsheet=null
			//}
		   //else
		   //{
		   //   alert("单号为:"+document.getElementById("AppNoz"+curr_row).innerText+t['F04']);
		   //}
		//}
		}
}