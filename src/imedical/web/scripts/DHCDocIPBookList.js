
var UDHCJFFlag="N"
var dialogArgumentName="";
try{
var Obj=window.parent.frames["RPTop"]
if (Obj){
	var UDHCJFFlag=Obj.document.getElementById('UDHCJFFlag').value;
	if (window.parent.dialogArguments){
		dialogArgumentName=window.parent.dialogArguments.name;
	}
}
}catch(e){}
function BodyLoadHandler() {
	//var UDHCJFFlag=window.document.forms.length; //document.getElementById('UDHCJFFlag').value
   //计费调用双击返回
   if(UDHCJFFlag=="Y"){
    var Obj=document.getElementById('tDHCDocIPBookList');
	if (Obj){
		  	Obj.ondblclick=ReturnOPBookID;
		} 
	}
	var Obj=document.getElementById('tDHCDocIPBookList');
	if (Obj){
		 	var rows=Obj.rows.length;
		 	for (var Sub=1; Sub<rows; Sub++){
			 	if ((UDHCJFFlag!="Y")||(dialogArgumentName!="")){
				 	var RegisterObj=document.getElementById('Registerz'+Sub);
			 	    if (RegisterObj) RegisterObj.style.display='none';
				}
			  	var ObjBookID=document.getElementById('RowIDz'+Sub).value;
			  	var mode=tkMakeServerCall("web.DHCBillInterface","IIsIPBook",ObjBookID);
			  	if (mode!=""){
					//Obj.rows[Sub].className='red';
					Obj.rows[Sub].style.backgroundColor="#E0E0E0"
				}
			  	if ((UDHCJFFlag=="Y")||(dialogArgumentName!="")){
			  	 	//var ObjAdmission=document.getElementById('Registerz'+Sub);
				  	//if (ObjAdmission){ObjAdmission.style.display ="none";}
		  			var ObjDetail=document.getElementById('Detailz'+Sub);
				  	if (ObjDetail){ObjDetail.style.display ="none";}
		 		}	
		 	}
	 }
	
	
}
function ReturnOPBookID()
{
	var SelectBookID=""
    var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	var ObjBookID=document.getElementById('RowIDz'+selectrow)
	if (ObjBookID){SelectBookID=ObjBookID.value}
	var mode=tkMakeServerCall("web.DHCBillInterface","IIsIPBook",SelectBookID);
	if (mode!=""){
		if (mode=="IPBookErr"){alert("不是当天的住院证");return}
		if (mode=="Admission"){alert("病人正在住院");return}
		if (mode=="OnceAdmission"){alert("病人曾住院");return}
		}
	window.parent.returnValue=SelectBookID;
	window.parent.name="";
	window.parent.close()
   
}
function getDblClickRow(evt) {
	var eSrc=websys_getSrcElement(evt);
	while(eSrc.tagName != "TR") {if (eSrc.tagName == "TH") break;eSrc=websys_getParentElement(eSrc);}
	if (eSrc.tagName=="TR") {
		var gotheader=0;
		var tbl=getTable(eSrc);
		if (tbl.tHead) return eSrc.rowIndex;
		else return eSrc.rowIndex+1;
	}
	return "";
}
document.body.onload = BodyLoadHandler;