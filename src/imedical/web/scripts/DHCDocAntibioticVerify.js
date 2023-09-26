var SelectedRow=0;
function BodyLoadHandler() {
	obj=document.getElementById("SelectAll");
	if (obj){obj.onclick=SelectAll_Click;}
	
	obj=document.getElementById("BtnVerify");
	if (obj){obj.onclick=Verify_Click;} 
	var Objtbl=document.getElementById('tDHCDocAntibioticVerify');
	var Rows=Objtbl.rows.length;
	for (var i=1;i<Rows;i++){
		var ConResult=document.getElementById('ConResultz'+i); 
		var PoisonCode=GetColumnData("PoisonCode",i);
		if(((ConResult.innerText=="")||(ConResult.innerText==" ")||(ConResult.innerText=="无会诊记录"))&&(PoisonCode=="KSS3")){
			var obj=document.getElementById("selectIDz"+i)
			if(obj) obj.disabled=true
		} 
		if((ConResult.innerText=="不同意")&&(PoisonCode=="KSS3")){
			var obj=document.getElementById("selectIDz"+i)
			if(obj) obj.disabled=true
		}
	}
	var objCancel=document.getElementById("btnCancel")
	if (objCancel){objCancel.onclick=Cancel_click;}
	
	

}
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCDocAntibioticVerify');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (selectrow!=SelectedRow){
		SelectedRow=selectrow;
		return;
		}else{
			SelectedRow=0;
			}
	}
function Cancel_click(){
	if (!SelectedRow) {
		alert("请选择需撤销记录")
		return;
	}
		var obj=document.getElementById("CancleApply")
		var encmeth=""
		if (obj) encmeth=obj.value;
		if (encmeth!=''){
			var AppRowid=GetColumnData("AppRowid",SelectedRow); 
			if(AppRowid==""){
				alert("请选择要撤销的申请单!")
				return	
			}
			var ConResult=GetColumnData("ConResult",SelectedRow);
			if ((ConResult=="不同意")||(ConResult=="同意")) {
				alert("会诊已执行,请先撤销会诊执行!")
				return
			}
			var ret=cspRunServerMethod(encmeth,AppRowid);
			if (ret==0){
				alert("撤销成功");
				btnCancel_click();
			}else{
				alert(ret);
			}
		}
}

function SelectAll_Click(){
	var obj=document.getElementById("SelectAll");
	var Objtbl=document.getElementById('tDHCDocAntibioticVerify');
	var Rows=Objtbl.rows.length;
	for (var i=1;i<Rows;i++){
		var selobj=document.getElementById('selectIDz'+i);  
		if(selobj.disabled!=true){
			selobj.checked=obj.checked;  
			}

	}
}


function Verify_Click() {
	var obj=document.getElementById("VerifyApply");
		
	var encmeth=""
	if (obj) encmeth=obj.value;
	if (encmeth!=''){
		var AppItemStr=GetAppItemStr(); 
		if(AppItemStr==""){
			alert("请选择要审核的申请单!")
			return	
		}
		var ret=cspRunServerMethod(encmeth,AppItemStr);
		if (ret==0){
			alert("审核成功");
			BtnVerify_click();
		}else{
			alert("审核失败");
		}
	}	
}

function GetAppItemStr() {
	var AppItemStr=""
	var objtbl=document.getElementById('tDHCDocAntibioticVerify');	
  	var rows=objtbl.rows.length;
  
	for (i=1;i<rows;i++){
		var SelValue=GetColumnData("selectID",i);  
		if (SelValue){
			var AppRowid=GetColumnData("AppRowid",i);
			if (AppItemStr==""){
				AppItemStr=AppRowid;
			}else{
				AppItemStr=AppItemStr+"^"+AppRowid;
			}
		}	
	}
	return AppItemStr; 	
}  

function GetColumnData(ColName,Row){
	var CellObj=document.getElementById(ColName+"z"+Row);
	//alert(CellObj.id+"^"+CellObj.tagName+"^"+CellObj.value);
	if (CellObj){ 
		if (CellObj.tagName=='LABEL'){
			return CellObj.innerText;
		}else{
			if (CellObj.type=="checkbox"){return CellObj.checked;}else{return CellObj.value;}
		}
	}
	return "";
}
	

document.body.onload = BodyLoadHandler;    