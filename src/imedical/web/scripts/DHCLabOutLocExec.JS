///Creator Qiuxianfu 2013.09.01
///DHCLabOutLocExec.JS
///标本运送管理

var patwardobj
///获取用户所属登陆科室
var ctlocid=session['LOGON.CTLOCID'];
var ObjClear=document.getElementById("Clear");
if (ObjClear) {ObjClear.onclick=ObjClear_Click;}
var ObjSpecDelete=document.getElementById("SpecDelete");
if (ObjSpecDelete) {ObjSpecDelete.onclick=SpecDelete;}
var TransmitNo=document.getElementById("TransmitNo");
var ObjTatSum=document.getElementById("TatSum");
if (ObjTatSum) {
	TatSum();
}
var ObjLabno=document.getElementById("Labno");
if (ObjLabno) {ObjLabno.onkeydown=PlacerNo_blur;}

document.body.onload = BodyLoadHandler;
document.body.onunload = BodyUnLoadHandler;

function BodyUnLoadHandler(){

}

function BodyLoadHandler(){


}
function SelectRowHandler(){
    var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCLabOutLocExec');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var SelRowObj=document.getElementById('labNoz'+selectrow);
	SelectedRow=selectrow;
	labNo=SelRowObj.innerText;

 }

function PlacerNo_blur(){

     if (event.keyCode==13){
	    var TransmitNo=DHCC_GetElementData("TransmitNo");
	    //alert(ctlocid+","+TransmitNo);     
	    var ret=CheckLabno(ObjLabno.value,ctlocid,TransmitNo);
	    //alert(ret+"100")
	    if (ret==0){
		    BtUpdate_Click();}
		else{
			var flag=ret.substring(0,1)
			if (flag==1){
				if(window.confirm(ret.substring(1,ret.length)+"确实要更新吗？")){
				BtUpdate_Click();}
			}
			else{
				//alert(ret+"-QQ");
				alert(ret.substring(1,ret.length));}
		}

		
  	}
}
function BtUpdate_Click(){
 var TransmitNo=DHCC_GetElementData("TransmitNo");
 if (TransmitNo==null) {alert("未选中出库单！");}
 //alert(TransmitNo)
 var Remark=DHCC_GetElementData("Remark");
 var ObjUpdate=document.getElementById("Update");
 if (ObjUpdate) {
	 var ret=cspRunServerMethod(ObjUpdate.value,ObjLabno.value,TransmitNo,Remark);
	 //alert(ret);
	 }
	if (ret！=0) alert("更新失败！");
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCLabOutLocExec&TransmitNo="+TransmitNo;
    parent.frames[1].location.href=lnk; 	
	ObjLabno.value=""
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
function CheckLabno(Labno,CTLocId,TransNo){
	var ObjCheckLabno=document.getElementById("CheckLabno");
	if (ObjCheckLabno){
			retStr=cspRunServerMethod(ObjCheckLabno.value,Labno,CTLocId,TransNo);
			var StrInfo=retStr.split("^");
			if (StrInfo[0]==0) {
				return 0;}
			else if (StrInfo[0]==1){
				return 1+StrInfo[1];}
			else{
			return StrInfo[0]+StrInfo[1];}
			
		}
}
function ObjClear_Click(){
	var ObjLabno=document.getElementById("Labno");
	if (ObjLabno) ObjLabno.value="";
	var ObjRemark=document.getElementById("Remark");
	if (ObjRemark) ObjRemark.value="";
}
function SpecDelete(){
	if(window.confirm("确实要删除吗？")){
		var ObjCheckLabnoDelete=document.getElementById("CheckLabnoDelete");
		if (ObjCheckLabnoDelete){
			retStr=cspRunServerMethod(ObjCheckLabnoDelete.value,labNo);
			if (retStr==0){
			SpecDelete_Click(labNo);}
			else{
			alert(retStr.substring(1,retStr.length));}
		}
	}
}
function SpecDelete_Click(labNo){
	var ObjDeleteLabno=document.getElementById("DeleteLabno");
	if (ObjDeleteLabno) {
		ret=cspRunServerMethod(ObjDeleteLabno.value,labNo);
		if (ret==0){
			alert("删除成功！");
			var TransmitNo=DHCC_GetElementData("TransmitNo");
			var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCLabOutLocExec&TransmitNo="+TransmitNo;
    		parent.frames[1].location.href=lnk; 
        }
		else{
		alert("删除失败！");}
	}
	//alert(labNo);
}
function TatSum(){
	var TransmitNo=DHCC_GetElementData("TransmitNo");
	var ObjTatSum=document.getElementById("TatSum");
	if (ObjTatSum){
		ret=cspRunServerMethod(ObjTatSum.value,TransmitNo);
		var ObjSum=document.getElementById("Sum");
		if (ObjSum) {ObjSum.value=ret;}
	}
}