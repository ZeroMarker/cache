///DHCDocExtData.js
///医联卡对照
///2011-1-24

var SelectedRow=0;

function BodyLoadHandler()
{
	InitMedCard();
	
	var AddObj=document.getElementById('Add');
	if(AddObj){AddObj.onclick=AddClickHandler;}	
	var DeleteObj=document.getElementById('Delete');
	if(DeleteObj){DeleteObj.onclick=DeleteClickHandler;}	
	var ModifyObj=document.getElementById('Modify');
	if(ModifyObj){
		//document.all.Modify.style.display="none";
		ModifyObj.onclick=ModifyClickHandler;
	}	
	var ClearObj=document.getElementById('Clear');
	if(ClearObj){ClearObj.onclick=ClearClickHandler;}
	var obj=document.getElementById('AddCTExtDataType');
	if(obj){obj.onclick=AddCTExtDataType;}
}

function InitMedCard()
{
	var obj=document.getElementById('SetSelectType');
	if (obj) {var encmeth=obj.value} else {var encmeth=''};
	if(encmeth!=''){
		var ret=cspRunServerMethod(encmeth,'SetSelectType');
	}
	
	var obj=document.getElementById('SelectType');
	if(obj){
		obj.size=1;
		obj.multiple=false;
		obj.onchange=SelectTypeHandler;
	}
	var obj=document.getElementById('ActiveFlag')
	if(obj){
		obj.size=1;
		obj.multiple=false;
		obj.options[0]=new Option("激活","Y");
		obj.options[1]=new Option("未激活","N");
	}	
}

function SelectTypeHandler()
{
	var obj=document.getElementById('SelectType');
	if(obj.selectedIndex==-1) return;
	var SelType=obj.options[obj.selectedIndex].value;
	if(SelType=='') {alert(t['tType']);return;}
	var obj=document.getElementById('SelectTypeCode');
	if(obj){obj.value=SelType;}
	//alert(SelType)
	Search_click();
	
	return;
}

function AddClickHandler()
{
	var obj=document.getElementById('SelectType');
	if(obj.selectedIndex==-1){alert(t['tType']);return;}
	var SelType=obj.options[obj.selectedIndex].value;
	if(SelType=='') {alert(t['tType']);return;}
	
	var obj=document.getElementById('ActiveFlag');
	if(obj) {var ActiveFlag=obj.options[obj.selectedIndex].value;}	
	var HisCodeRowId=document.getElementById('HISCodeRowId').value;
	var HisCode=document.getElementById('SelectHISCode').value;
	var HisDesc=document.getElementById('SelectHISDesc').value;
	if ((HisCode=="")||(HisDesc=="")){alert(t['tHisCode']);return;}
	
	var MUCCode=document.getElementById('MUCCode').value;
	var MUCDesc=document.getElementById('MUCDesc').value;	
	/*****************判断是否重复插入************************/
	var Repeat=document.getElementById('Repeat');
	if (Repeat) {encmeth=Repeat.value;} else {encmeth='';}
	if (encmeth!=''){
		var RtnVal=cspRunServerMethod(encmeth,SelType,HisCodeRowId);
		if(RtnVal=="R") {alert(t['tRepeat']);return;}		
	}
	
	var InStr=SelType+"^"+HisCodeRowId+"^"+HisCode+"^"+HisDesc+"^"+MUCCode+"^"+MUCDesc+"^"+ActiveFlag;
	var Ins=document.getElementById('Ins');
	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
	if(encmeth!=''){
		if(cspRunServerMethod(encmeth,InStr)!=0) alert(t['tFail']);
	}
	ClearClickHandler();
	Search_click();
}

function ModifyClickHandler()
{
	if(SelectedRow==0) {alert("请选择一条记录");return;}
	var TempId=document.getElementById('TempId').value;
	if(TempId=='') return;
	var obj=document.getElementById('SelectType');
	var SelType=obj.options[obj.selectedIndex].value;
	var obj=document.getElementById('ActiveFlag');
	if(obj) {var ActiveFlag=obj.options[obj.selectedIndex].value;}
	
	var HISCodeRowId=document.getElementById('HISCodeRowId').value;
	var HisCode=document.getElementById('SelectHISCode').value;
	var HisDesc=document.getElementById('SelectHISDesc').value;
	var MUCCode=document.getElementById('MUCCode').value;
	var MUCDesc=document.getElementById('MUCDesc').value;
	/*****************判断是否重复插入************************/
	var Repeat=document.getElementById('Repeat');
	if (Repeat) {encmeth=Repeat.value;} else {encmeth='';}
	if (encmeth!=''){
		var RtnVal=cspRunServerMethod(encmeth,SelType,HISCodeRowId,TempId);
		if(RtnVal=="R") {alert(t['tRepeat']);return;}		
	}
		
	var InStr=HISCodeRowId+"^"+HisCode+"^"+HisDesc+"^"+MUCCode+"^"+MUCDesc+"^"+ActiveFlag;	
	//alert(InStr)
	var obj=document.getElementById('Mod');
	if(obj){var encmeth=obj.value;} else {var encmeth='';}
	if(encmeth!=''){
		if(cspRunServerMethod(encmeth,InStr,TempId)==0){
			alert(t['tModify']);
			ClearClickHandler();
			//document.all.Modify.style.display="none"
			//document.all.Add.style.display=""
		}
		else{alert(t['NotModify']);return;}
	}
	Search_click();
}

function DeleteClickHandler()
{
	if(SelectedRow==0) {alert("请选择一条记录");return;}
	var DelRowid=document.getElementById("HidRowidz"+SelectedRow).value;
	
	var obj=document.getElementById('SelectType');
	if(obj){SelType=obj.options[obj.selectedIndex].value;}
	
	var Del=document.getElementById('Del');
	if(Del){var encmeth=Del.value;} else {var encmeth='';}
	
	if(cspRunServerMethod(encmeth,DelRowid)!=0) {alert(t['tDel']);return;}
	ClearClickHandler();
	Search_click();
}

function ClearClickHandler()
{
	//document.getElementById('SelectType').text="";
	document.getElementById('HISCodeRowId').value="";
	document.getElementById('SelectHISCode').value="";
	document.getElementById('SelectHISDesc').value="";
	document.getElementById('MUCCode').value="";
	document.getElementById('MUCDesc').value="";
	document.getElementById('TempId').value="";
}

function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;//alert(selectrow)
	if(!selectrow) return;
	if(SelectedRow!=selectrow){
		SelectedRow=selectrow;
		document.getElementById('HISCodeRowId').value=document.getElementById('THISCodeRowIdz'+selectrow).value;
		document.getElementById('SelectHISCode').value=document.getElementById('THISCodez'+selectrow).innerText;
		document.getElementById('SelectHISDesc').value=document.getElementById('THISDescz'+selectrow).innerText;
		document.getElementById('MUCCode').value=document.getElementById('TMUCCodez'+selectrow).innerText;
		document.getElementById('MUCDesc').value=document.getElementById('TMUCDescz'+selectrow).innerText;
		var obj=document.getElementById('ActiveFlag');
		var TAF=document.getElementById('TActiveFlagz'+selectrow).innerText;
		if(TAF=='是') obj.options[0].selected=true;
		else obj.options[1].selected=true;
		document.getElementById('TempId').value=document.getElementById('HidRowidz'+selectrow).value;
	}else{
		SelectedRow=0
	}
	//document.all.Modify.style.display=""
	//document.all.Add.style.display="none"
}



document.body.onload=BodyLoadHandler;

function SetCodeToDesc(PutStr)
{
	var obj=document.getElementById('HISCodeRowId');
	if(obj){obj.value=PutStr.split("^")[2];}
	
	var obj=document.getElementById('SelectHISDesc');
	if(obj){
		obj.value=PutStr.split("^")[1];
		obj.disabled=true;
	}
}

function SetSelectType(val)
{
	var SelectTypeCode="";
	var obj=document.getElementById('SelectTypeCode');
	if(obj){SelectTypeCode=obj.value;}
	var obj=document.getElementById('SelectType');
	
	var ArrVal=val.split(String.fromCharCode(1));
	for (var i=0;i<ArrVal.length;i++){
		var TypeVal=ArrVal[i];
		var ArrTypeVal=TypeVal.split("^");
		obj.options.add(new Option(ArrTypeVal[2],ArrTypeVal[0])); 
		
		if (SelectTypeCode==ArrTypeVal[0]){
			obj.options[i].selected=true;
		}
	}
}

function AddCTExtDataType()
{
	var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCDocCTExtDataType";
	if(typeof websys_writeMWToken=='function') url=websys_writeMWToken(url);
	window.open(url,"DHCDocCTExtDataType","top=0,left=0,width=800,height=600,alwaysLowered=yes");
}