/// DHCPEItemResultStatus.js
///    
var IsURL=false;
function BodyLoadHandler() {
	var obj;
	//登记号
	obj=document.getElementById('RegNo');
	if (obj) { obj.onkeydown = RegNo_keydown; }
	iniForm();
}

function iniForm() {
	
	obj=document.getElementById('PatData');
	if (obj && ""!=obj.value) { 
	 	IsURL=true; 
		SetPatient_Sel(unescape(obj.value)); 
		IsURL=false; 
	}
}
// ///////////////////////////////////////////////////////////////////////////////

function trim(s) {
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
        return (m == null) ? "" : m[1];
}

//Input Patient RegNo
function RegNo_keydown(e) {
	var key=websys_getKey(e);
	if (key==13) {
		var obj=document.getElementById('RegNo');
		if (''!=obj.value) {
			var ID=obj.value;
			if (ID.length<8) { ID = RegNoMask(ID); }
			obj.value=ID;
			FindPatDetail(ID);
		}
	}
	obj.className='';
}

function FindPatDetail(ID){
	clear();
	var GetDetail=document.getElementById('GetDetail');
	if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
	var flag=cspRunServerMethod(encmeth,'SetPatient_Sel','',ID);
	if ('0'==flag) {	
		return websys_cancel();
	}else{ 
		
	}

}
/// 参考 DHCOPReg.js
function SetPatient_Sel(value) {
	try {
		var Split_Value=value.split("^")
		var obj;
		var iName=Split_Value[0];
		if (IsURL) { //网页传输参数

		}else{

			if ((""==iName)||("未用"==iName)) { 

				obj=document.getElementById('RegNo');
				if (obj) { obj.className='clsInvalid'; }
				return false;
			}else{

				var tForm="",iRegNo="";	
				var obj=document.getElementById("TFORM");
				if (obj){ tForm=obj.value; }
				
				obj=document.getElementById('RegNo');
				if (obj) { iRegNo=obj.value; }
				
				var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+tForm
						+"&RegNo="+iRegNo
						+"&PatData="+escape(value);

				location.href=lnk;
			}
		}
		
		obj=document.getElementById('Name');
		if (obj) {
  			obj.value=unescape(iName);
			obj.className='';	
		}
		
		obj=document.getElementById('Sex');
		if (obj) {
  			obj.value=unescape(Split_Value[2]);
			obj.className='';
			//websys_nexttab('6');
		}
		
		obj=document.getElementById('Birth');
		if (obj) {
  			obj.value=unescape(Split_Value[1]);
			obj.className='';
			//websys_nexttab('6');
		}

	} catch(e) {};
}

function clear() {
		obj=document.getElementById('Name');
		if (obj) {
  			obj.value=""
			obj.className='';	
		}
		
		obj=document.getElementById('Sex');
		if (obj) {
  			obj.value=""
			obj.className='';
		}
		
		obj=document.getElementById('Birth');
		if (obj) {
  			obj.value=""
			obj.className='';
		}

}


document.body.onload = BodyLoadHandler;