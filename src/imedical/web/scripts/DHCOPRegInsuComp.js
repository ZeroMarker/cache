var SelectedRow=0

function BodyLoadHandler() {
	initForm();
	var obj=document.getElementById("AdmReason");
	if(obj){obj.onchange=InsuPatTypeCodeSet;}
	var obj=document.getElementById("InsuPatTypeCode");
	if(obj){obj.onkeyup=AdmReasonSet;}
	var obj=document.getElementById("Add");
	if(obj){obj.onclick=ADD_click;}
	var obj=document.getElementById("Delete")
	if(obj){obj.onclick=Delete_click;}
	var obj=document.getElementById("Modify")
	if(obj){obj.onclick=Modify_click;}
}
function InsuPatTypeCodeSet(){
	var obj=document.getElementById("AdmReason");
	var InsuPatTypeCode=document.getElementById("InsuPatTypeCode");
	if (obj.value!=""){
		InsuPatTypeCode.value=""
		InsuPatTypeCode.disabled=true;
	}
	else{
		InsuPatTypeCode.disabled=false;
	}
	

	}
	
function AdmReasonSet(){
	var obj=document.getElementById("InsuPatTypeCode");
	//alert(obj.value)
	var AdmReason=document.getElementById("AdmReason");
	if (obj.value!=""){
		AdmReason.options[0].selected=true;
		AdmReason.disabled=true;
	}
	else{
		AdmReason.disabled=false;
	}
}


function ADD_click(){
	var obj=document.getElementById('AdmReason');
	if(obj){
		AdmReason=obj.value;
	}
	var obj=document.getElementById('InsuPatTypeCode');
	if(obj){
		InsuPatTypeCode=obj.value;
	}
	if ((AdmReason=="")&&(InsuPatTypeCode=="")){
		alert(t['01']);
		return;
	}
	var obj=document.getElementById('NowOrdItemDr');
	if(obj){NowOrdItem=obj.value;
			if(NowOrdItem==""){
				alert(t['03']);
				return;}
				}
	
	var obj=document.getElementById('UploadOrdItemDr');
	if(obj){UploadOrdItem=obj.value;
			if(UploadOrdItem==""){
				alert(t['04']);
				return;}
				}
	
	var obj=document.getElementById('StartDate');
	if(obj){StartDate=obj.value;
			if(StartDate==""){
				alert(t['05']);
				return;}
				}
	var obj=document.getElementById('EndDate');
	if(obj){EndDate=obj.value;}
	var InString=""+"^"+AdmReason+"^"+EndDate+"^"+InsuPatTypeCode+"^"+NowOrdItem+"^"+StartDate+"^"+UploadOrdItem
	var Insert=document.getElementById('Insert');
	if (Insert) {var encmeth=Insert.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,InString)>0) {
		location.reload();                ///从新加载页面
	}
	else{
		alert("添加失败")
	}
	
	
	}
function Modify_click(){
	var obj=document.getElementById('Rowid');
	if(obj){
		Rowid=cTrim(obj.value,0);
		if(Rowid==""){
			alert(t['06']);
			return;
		}
	}
	var obj=document.getElementById('AdmReason');
	if(obj){
		AdmReason=obj.value;
	}
	var obj=document.getElementById('InsuPatTypeCode');
	if(obj){
		InsuPatTypeCode=cTrim(obj.value,0);
	}
	if ((AdmReason=="")&&(InsuPatTypeCode=="")){
		alert(t['01']);
		return;
	}
	var obj=document.getElementById('NowOrdItemDr');
	if(obj){NowOrdItem=cTrim(obj.value,0);
			if(NowOrdItem==""){
				alert(t['03']);
				return;}
				}
	
	var obj=document.getElementById('UploadOrdItemDr');
	if(obj){UploadOrdItem=cTrim(obj.value,0);
			if(UploadOrdItem==""){
				alert(t['04']);
				return;}
				}
	
	var obj=document.getElementById('StartDate');
	if(obj){StartDate=cTrim(obj.value,0);
			if(StartDate==""){
				alert(t['05']);
				return;}
				}
	var obj=document.getElementById('EndDate');
	if(obj){EndDate=cTrim(obj.value,0);}
	var InString=Rowid+"^"+AdmReason+"^"+EndDate+"^"+InsuPatTypeCode+"^"+NowOrdItem+"^"+StartDate+"^"+UploadOrdItem
	var Insert=document.getElementById('Update');
	if (Insert) {var encmeth=Insert.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,InString)>0) {
		location.reload();                ///从新加载页面
	}
	else{
		alert("更新失败")
	}
}

function Delete_click(){
	var obj=document.getElementById('Rowid');
	if(obj){
		Rowid=obj.value;
		if(Rowid==""){
			alert(t['07']);
			return;
		}
	}
	var Insert=document.getElementById('Del');
	if (Insert) {var encmeth=Insert.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,Rowid)==0) {
		location.reload();                ///从新加载页面
	}
	else{
		alert("删除失败")
	}
}


function initForm() {
	var obj=document.getElementById('AdmReason')
	obj.size=1; 
	obj.multiple=false;
	var AdmReasonObj=document.getElementById('Category'); 
	if(AdmReasonObj) VerStr=cspRunServerMethod(AdmReasonObj.value)
	var i
	var VerArr1=VerStr.split("!");
	var ArrTxt= new Array(VerArr1.length-2);
	var ArrValue = new Array(VerArr1.length-2);
	for(i=1;i<VerArr1.length;i++){
		var VerArr2=VerArr1[i].split("^");
		ArrTxt[i]=VerArr2[1];
		ArrValue[i]=VerArr2[0];
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
				//alert(i)
				obj.options[lstlen] = new Option(arytxt[i],aryval[i]); 
				lstlen++;}
		}
	}
}
function getorderid(value){
	var TempData=value.split("^")
	var obj=document.getElementById("NowOrdItemDr");
	if (obj){obj.value=TempData[1]}
	
}
function getUporderid(value){
	var TempData=value.split("^")
	var obj=document.getElementById("UploadOrdItemDr");
	if (obj){obj.value=TempData[1]}
	
}
//****************************************************************
// Description: sInputString 为输入字符串?iType为类型?分别为
// 0 - 去除前后空格; 1 - 去前导空格; 2 - 去尾部空格
//****************************************************************
function cTrim(sInputString,iType)
{
  var sTmpStr = ' '
  var i = -1

  if(iType == 0 || iType == 1)
  {
     while(sTmpStr == ' ')
     {
       ++i
       sTmpStr = sInputString.substr(i,1)
     }
     sInputString = sInputString.substring(i)
  }

  if(iType == 0 || iType == 2)
  {
    sTmpStr = ' '
    i = sInputString.length
    while(sTmpStr == ' ')
    {
       --i
       sTmpStr = sInputString.substr(i,1)
    }
    sInputString = sInputString.substring(0,i+1)
  }
  return sInputString
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCOPRegInsuComp');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	//alert(selectrow)
	if (SelectedRow==selectrow){
		SelectedRow=0

		var obj=document.getElementById('Rowid');
		if(obj){
			obj.value="";
		}
		var obj=document.getElementById('AdmReason');
		if(obj){
			obj.options[0].selected=true;
			obj.disabled=false;
		}
		var obj=document.getElementById('InsuPatTypeCode');
		if(obj){
			obj.value="";
			obj.disabled=false;
		}
		var obj=document.getElementById('NowOrdItemDr');
		if(obj){
			obj.value="";
		}
		var obj=document.getElementById('NowOrdItem');
		if(obj){
			obj.value="";
		}
		var obj=document.getElementById('UploadOrdItemDr');
		if(obj){
			obj.value="";
		}
		var obj=document.getElementById('UploadOrdItem');
		if(obj){
			obj.value="";
		}
		var obj=document.getElementById('StartDate');
		if(obj){
			obj.value="";
		}
		var obj=document.getElementById('EndDate');
		if(obj){
			obj.value="";
		}
				return;
	}
	SelectedRow=selectrow
	SelRowObj=document.getElementById('TRowidz'+selectrow);
	if (SelRowObj){
		var obj=document.getElementById('Rowid');
		if(obj){
			obj.value=SelRowObj.value;
		}
	}
	//alert(document.getElementById('Rowid').value);
	var objAdmReason=document.getElementById('AdmReason');
	var objInsuPatTypeCode=document.getElementById('InsuPatTypeCode');
	SelRowObj=document.getElementById('AdmReasonRowidz'+selectrow);
	if (SelRowObj){

		if(objAdmReason){
			objAdmReason.value=cTrim(SelRowObj.value,0);
		}
	}
	SelRowObj=document.getElementById('TabInsuPatTypeCodez'+selectrow);
	if (SelRowObj){
		if(objInsuPatTypeCode){
			objInsuPatTypeCode.value=cTrim(SelRowObj.innerText,0);
			if (objAdmReason.value==""){objAdmReason.disabled=true;objInsuPatTypeCode.disabled=false;}
			else{objAdmReason.disabled=false;objInsuPatTypeCode.disabled=true;}
		}
	}
	SelRowObj=document.getElementById('TabNowOrdItemz'+selectrow);
	if (SelRowObj){
		var obj=document.getElementById('NowOrdItem');
		if(obj){
			obj.value=SelRowObj.innerText;
		}
	}
	SelRowObj=document.getElementById('TabNowOrdItemDrz'+selectrow);
	if (SelRowObj){
		var obj=document.getElementById('NowOrdItemDr');
		if(obj){
			obj.value=SelRowObj.value;
		}
	}
	SelRowObj=document.getElementById('TabUploadOrdItemz'+selectrow);
	if (SelRowObj){
		var obj=document.getElementById('UploadOrdItem');
		if(obj){
			obj.value=SelRowObj.innerText;
		}
	}
	SelRowObj=document.getElementById('TabUploadOrdItemDrz'+selectrow);
	if (SelRowObj){
		//alert(SelRowObj.value)
		var obj=document.getElementById('UploadOrdItemDr');
		if(obj){
			obj.value=SelRowObj.value;
		}
	}
	SelRowObj=document.getElementById('TabStartDatez'+selectrow);
	if (SelRowObj){
		var obj=document.getElementById('StartDate');
		if(obj){
			obj.value=SelRowObj.innerText;
		}
	}
	SelRowObj=document.getElementById('TabEndDatez'+selectrow);
	if (SelRowObj){
		var obj=document.getElementById('EndDate');
		if(obj){
			obj.value=SelRowObj.innerText;
		}
	}
}
document.body.onload = BodyLoadHandler;