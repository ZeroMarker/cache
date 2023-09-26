///DHCMedCardExternal.js
///医联卡对照
///2011-1-24

var LoopCount=1;
var SelectRow=0;
document.body.onload=BodyLoadHandler;
function BodyLoadHandler()
{
	InitMedCard();
	var TypeObj=document.getElementById('SelectType');
	if(TypeObj){TypeObj.onchange=SelectTypeHandler;}
	
	var AddObj=document.getElementById('Add');
	if(AddObj){AddObj.onclick=AddClickHandler;}
	
	var DeleteObj=document.getElementById('Delete');
	if(DeleteObj){DeleteObj.onclick=DeleteClickHandler;}
	
	var ModifyObj=document.getElementById('Modify');
	if(ModifyObj){
		document.all.Modify.style.display="none";
		ModifyObj.onclick=ModifyClickHandler;
	}
	
	var ClearObj=document.getElementById('Clear');
	if(ClearObj){ClearObj.onclick=ClearClickHandler;}
}

function InitMedCard()
{
	var obj=document.getElementById('SelectType');
	if(obj){
		obj.size=1;
		obj.multiple=false;
		obj.options[0]=new Option("频次","Freq");
		obj.options[0].selected=true;
		obj.options[1]=new Option("用法","Instruc");
		obj.options[2]=new Option("疗程","Duration");
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
	ClearTableList();
	var obj=document.getElementById('SelectType');
	if(obj.selectedIndex==-1) return;
	var SelType=obj.options[obj.selectedIndex].value;
	if(SelType=='') {alert(t['Type']);return;}
	var Sel=document.getElementById('Sel');
	if(Sel) {encmeth=Sel.value;} else {encmeth="";}
	var RtnStr=cspRunServerMethod(encmeth,SelType);
	if (RtnStr=='') return;
	try{
		var TableValue=RtnStr.split("!");
 		var RtnStrLen=TableValue.length;
		for(var i=0;i<RtnStrLen;i++){							
			var objtbl=document.getElementById('tDHCMedCardExternal');
			var rows=objtbl.rows.length;
			if(LoopCount!=1) AddRowToList(objtbl);
			LoopCount=LoopCount+1;
			var LastRow=rows - 1;
			var eSrc=objtbl.rows[LastRow];
			if (eSrc.tagName=="TR"){
				var RowObj=websys_getParentElement(eSrc);
				if (RowObj.tHead) eSrc.TRAKListIndex=eSrc.rowIndex;
				else eSrc.TRAKListIndex=eSrc.rowIndex+1;
			}
			var rowitems=RowObj.all;
			if (!rowitems) {rowitems=RowObj.getElementsByTagName('label');}
			for (var j=0;j<rowitems.length;j++) {
				if (rowitems[j].id) {
					var Id=rowitems[j].id;
					var arrId=Id.split('z');
					var Row=arrId[arrId.length-1];
				}
			}			
				
				var Tbl_HisCode=document.getElementById('THISCodez'+Row);			
				document.getElementById('THISCodez'+Row).innerText=TableValue[i].split("^")[0].replace(/(^\s*)|(\s*$)/g,'');
				document.getElementById('THISDescz'+Row).innerText=TableValue[i].split("^")[1].replace(/(^\s*)|(\s*$)/g,'');
				document.getElementById('TMUCCodez'+Row).innerText=TableValue[i].split("^")[2].replace(/(^\s*)|(\s*$)/g,'');
				document.getElementById('TMUCDescz'+Row).innerText=TableValue[i].split("^")[3].replace(/(^\s*)|(\s*$)/g,'');
				document.getElementById('TActiveFlagz'+Row).innerText=TableValue[i].split("^")[4].replace(/(^\s*)|(\s*$)/g,'');
				document.getElementById('HidRowidz'+Row).innerText=TableValue[i].split("^")[5].replace(/(^\s*)|(\s*$)/g,'');
		}
		LoopCount=1;
		SelectRow=0
	}
	catch(e){alert(e)}
}
function AddRowToList(objtbl){
	var row=objtbl.rows.length;
	var objlastrow=objtbl.rows[row-1];
	objtbl=websys_getParentElement(objlastrow);
	var objnewrow=objlastrow.cloneNode(true);
	var rowitems=objnewrow.all; //IE only
	if (!rowitems) rowitems=objnewrow.getElementsByTagName('*'); //N6
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split('z');	
			arrId[arrId.length-1]=eval(arrId[arrId.length-1])+1
			rowitems[j].id=arrId.join('z');
			rowitems[j].name=arrId.join('z');
			rowitems[j].value='';
		}
	}
	objnewrow=objtbl.appendChild(objnewrow);
	{if ((objnewrow.rowIndex)%2==0) {objnewrow.className='RowEven';} else {objnewrow.className='RowOdd';}}
}

function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if(!selectrow) return;
	if(SelectRow!=selectrow){
		SelectRow=selectrow;
		document.getElementById('SelectHISCode').value=document.getElementById('THISCodez'+selectrow).innerText.replace(/(^\s*)|(\s*$)/g,'');
		document.getElementById('SelectHISDesc').value=document.getElementById('THISDescz'+selectrow).innerText.replace(/(^\s*)|(\s*$)/g,'');
		document.getElementById('MUCCode').value=document.getElementById('TMUCCodez'+selectrow).innerText.replace(/(^\s*)|(\s*$)/g,'');
		document.getElementById('MUCDesc').value=document.getElementById('TMUCDescz'+selectrow).innerText.replace(/(^\s*)|(\s*$)/g,'');
		var obj=document.getElementById('ActiveFlag');
		var TAF=document.getElementById('TActiveFlagz'+selectrow).innerText.replace(/(^\s*)|(\s*$)/g,'');
		if(TAF=='Y') obj.options[0].selected=true;
		else obj.options[1].selected=true;
		document.getElementById('TempId').value=document.getElementById('HidRowidz'+selectrow).value;
		document.all.Modify.style.display=""
		document.all.Add.style.display="none"
	}
	else{
		SelectRow=0
		document.all.Modify.style.display="none"
		document.all.Add.style.display=""
		ClearClickHandler()
		}

}

function AddClickHandler()
{
	var obj=document.getElementById('SelectType');
	if(obj.selectedIndex==-1) return;
	
	var SelType=obj.options[obj.selectedIndex].value;
	if(SelType=='') {alert(t['tType']);return;}
	
	var obj=document.getElementById('ActiveFlag');
	if(obj) {var ActiveFlag=obj.options[obj.selectedIndex].value;}
	
	var HisCode=document.getElementById('SelectHISCode').value;
	if (HisCode=='')  {alert(t['tHisCode']);return;}

	var HisDesc=document.getElementById('SelectHISDesc').value;
	var MUCCode=document.getElementById('MUCCode').value;
	var MUCDesc=document.getElementById('MUCDesc').value;	
	/*****************判断是否重复插入************************/
	var Repeat=document.getElementById('Repeat');
	if (Repeat) {encmeth=Repeat.value;} else {encmeth='';}
	if (encmeth!=''){
		var RtnVal=cspRunServerMethod(encmeth,SelType,HisCode);
		if(RtnVal.split("^")[0]=="R") {alert(t['tRepeat']);return;}
		///////////表里不存在的新内容
		else if(RtnVal.split("^")[0]=="NULL") {alert(t['tConfirm']);return;}
		else HisCode=RtnVal.split("^")[1];
	}
	
	var InStr=HisCode+"^"+HisDesc+"^"+MUCCode+"^"+MUCDesc+"^"+ActiveFlag;	
	var Ins=document.getElementById('Ins');
	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
	if(encmeth!=''){
		if(cspRunServerMethod(encmeth,SelType,InStr)!=0) alert(t['tFail']);
	}
	ClearClickHandler();
	SelectTypeHandler();
}

function DeleteClickHandler()
{
	if(SelectRow==0) return;
	var DelRowid=document.getElementById("HidRowidz"+SelectRow).value;
	
	var obj=document.getElementById('SelectType');
	if(obj){SelType=obj.options[obj.selectedIndex].value;}
	
	var Del=document.getElementById('Del');
	if(Del){var encmeth=Del.value;} else {var encmeth='';}
	
	if(cspRunServerMethod(encmeth,SelType,DelRowid)!=0) {alert(t['tDel']);return;}
	ClearClickHandler();
	SelectTypeHandler();
	document.all.Modify.style.display="none"
	document.all.Add.style.display=""
}

function ModifyClickHandler()
{
	var TempId=document.getElementById('TempId').value;
	if(TempId=='') return;
	var obj=document.getElementById('SelectType');
	var SelType=obj.options[obj.selectedIndex].value;
	var obj=document.getElementById('ActiveFlag');
	if(obj) {var ActiveFlag=obj.options[obj.selectedIndex].value;}
	var HisCode=document.getElementById('SelectHISCode').value;
	var HisDesc=document.getElementById('SelectHISDesc').value;
	var MUCCode=document.getElementById('MUCCode').value;
	var MUCDesc=document.getElementById('MUCDesc').value;
	
	/*****************判断是否重复插入************************/
	var Repeat=document.getElementById('Repeat');
	if (Repeat) {encmeth=Repeat.value;} else {encmeth='';}
	if (encmeth!=''){
		var RtnVal=cspRunServerMethod(encmeth,SelType,HisCode);
		if(RtnVal.split("^")[0]=="NULL") {alert(t['tConfirm']);return;}
		else HisCode=RtnVal.split("^")[1];
	}
	var InStr=HisCode+"^"+HisDesc+"^"+MUCCode+"^"+MUCDesc+"^"+ActiveFlag+"^"+TempId;

	var obj=document.getElementById('Mod');
	if(obj){var encmeth=obj.value;} else {var encmeth='';}
	if(encmeth!=''){
		if(cspRunServerMethod(encmeth,SelType,InStr)==0){
			alert(t['tModify']);
			ClearClickHandler();
			document.all.Modify.style.display="none"
			document.all.Add.style.display=""
		}
		else{alert(t['NotModify']);return;}
	}
	SelectTypeHandler();
}

function ClearClickHandler()
{
	document.getElementById('SelectHISCode').value="";
	document.getElementById('SelectHISDesc').value="";
	document.getElementById('MUCCode').value="";
	document.getElementById('MUCDesc').value="";
	document.getElementById('TempId').value="";
}
function ClearTableList()
{
	var tablelist=document.getElementById('tDHCMedCardExternal');
	var rows=tablelist.rows.length;
	var lastrow=rows-1;
	for(var i=1;i<lastrow;i++){
		tablelist.deleteRow(1);
	}
	var objlastrow=tablelist.rows[1];
	var rowitems=objlastrow.all;//alert(rowitems.length) //IE only 12
	if (!rowitems) rowitems=objnewrow.getElementsByTagName('*'); //N6
	for (var j=0;j<rowitems.length;j++) {//alert(j+"&"+rowitems[j].id)
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split('z');
			arrId[arrId.length-1]='1';
			rowitems[j].id=arrId.join('z');
			rowitems[j].name=arrId.join('z');
			rowitems[j].innerText='';
		}
	}	
}
function SetCodeToDesc(PutStr)
{
	var obj=document.getElementById('SelectHISDesc');
	if(obj){
		obj.value=PutStr.split("^")[1];
		obj.disabled=true;
	}
}