//DHCMedBaseSysDicEdit.js
function initForm()
{
	DisplayDetail();
	document.getElementById("btnUpdate").onclick = btnUpdateOnClick;
}
function DisplayDetail(){
	var obj=document.getElementById("txtRowid");
	if (obj){
		var Rowid=obj.value;
		if (!Rowid) return;
		var obj=document.getElementById("MedthodGetSysDic");
	    if (obj) {var encmeth=obj.value} else {var encmeth=''}
	    var ret=cspRunServerMethod(encmeth,Rowid);
		if (!ret) return;
		
		var tmpList=ret.split("^");
		var obj=document.getElementById("DicName");
		
		if (obj&&tmpList[1]){obj.readOnly=true;obj.value=tmpList[1];}
		/*
		var obj=document.getElementById("TblName");
		if (obj&&tmpList[3]){
			for (var i=0;i<obj.options.length;i++){
				if (obj.options[i].value==tmpList[2]){
					obj.selectedIndex=i;
					break;
				}
			}
		}
		*/
		var obj=document.getElementById("TblName");
		if (obj&&tmpList[2]){obj.value=tmpList[2];}
		
		var obj=document.getElementById("IdField");
		if (obj&&tmpList[3]){obj.value=tmpList[3];}
		
		var obj=document.getElementById("CodeField");
		if (obj&&tmpList[4]){obj.value=tmpList[4];}
		
		var obj=document.getElementById("DescField");
		if (obj&&tmpList[5]){obj.value=tmpList[5];}
		
		var obj=document.getElementById("DicActive");
		if (obj&&tmpList[6]){
			if (tmpList[6]=="Y"){
				obj.checked=true;
			}else{
				obj.checked=false;
			}
		}
		
		var obj=document.getElementById("DicResume");
		if (obj&&tmpList[7]){obj.value=tmpList[7];}
	}
}
function btnUpdateOnClick()
{
	var cRowid="",cDicName="",cTblName="",cRowidField="",cCodeField="",cDescField="",cActive="",cResume="";	
	var obj=document.getElementById("txtRowid");
	if(obj) {cRowid=Trim(obj.value);}
	var obj=document.getElementById("DicName");
	if(obj) {cDicName=Trim(obj.value);}
	var obj=document.getElementById("TblName");
	if(obj) {cTblName=Trim(obj.value);}
	var obj=document.getElementById("IdField");
	if(obj) {cRowidField=Trim(obj.value);}
	var obj=document.getElementById("CodeField");
	if(obj) {cCodeField=Trim(obj.value);}
	var obj=document.getElementById("DescField");
	if(obj) {cDescField=Trim(obj.value);}
	var obj=document.getElementById("DicActive");
	if(obj) {
		if (obj.checked){cActive="Yes";}
		else{cActive="No";}
		}
	var obj=document.getElementById("DicResume");
	if(obj) {cResume=Trim(obj.value);}
	if ((!cDicName)||(!cTblName)||(!cRowidField)||(!cActive)||(!cCodeField)||(!cDescField)) {
		alert(t["DataError"]);
		return;
	}
	var InString=cRowid+"^"+cDicName+"^"+cTblName+"^"+cRowidField+"^"+cCodeField+"^"+cDescField+"^"+cResume+"^"+cActive;
	//alert(InString);
	var obj=document.getElementById("MedthodUpdateSysDic");
    if (obj) {var encmeth=obj.value} else {var encmeth=''}
    var ret=cspRunServerMethod(encmeth,InString);
    if (ret&&ret>0){
	    alert(t["UpdateTrue"]);
	}else{
		alert(t["UpdateFalse"]);
	}
	window.close();
}
//remove space for string 
	function LTrim(str){ //remove the leading space
		var i;
		for(i=0;i < str.length; i ++)
		{
			 if(str.charAt(i)!=" "&&str.charAt(i)!=" ") 
				break;
		}
		str = str.substring(i,str.length);
		return str;
	}
	
	function RTrim(str){
		var i;
		for(i = str.length - 1; i>=0; i--)
		{
			if(str.charAt(i)!=" "&&str.charAt(i)!=" ") 
				break;
		}
		str = str.substring(0,i+1);
		return str;
	}
	
	//remove blank of a string
	function Trim(str){
		return LTrim(RTrim(str));
	} 
initForm();