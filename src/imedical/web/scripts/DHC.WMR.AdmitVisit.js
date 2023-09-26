var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);
var CHR_3=String.fromCharCode(3);
var CHR_Up="^";
var CHR_Tilted="/";

var tmpChinese;
function GetChinese(MethodName,Ind)
{
	var strMethod = document.getElementById(MethodName).value;
	var ret = cspRunServerMethod(strMethod,Ind);
	var tmp=ret.split("^");
	return tmp;
}
tmpChinese=GetChinese("MethodGetChinese","DHC.WMR.AdmitVisit");

function initForm(){
	var tmpList,tmpSub,tmpChild;
	var AdmitStatus="";
	var Paadm=document.getElementById("Paadm").value;
	var xBregRowid=document.getElementById("BregRowid").value;
	
	if ((Paadm=="")||(xBregRowid=="")){
		alert("Error:Paadm is empty or BregId is empty!");
		return;
	}
	
	document.getElementById("cmdVisit").disabled=true;
	document.getElementById("cmdCancelVisit").disabled=true;
	document.getElementById("cmdEscort").disabled=true;
	document.getElementById("cmdCancelEscort").disabled=true;
	document.getElementById("cmdPrint").disabled=true;
	document.getElementById("cmdXJPrint").disabled=true;
	
	var obj=document.getElementById("MethodGetAdmitVisit");
    if (obj) {var encmeth=obj.value} else {var encmeth=''}
    var ret=cspRunServerMethod(encmeth,Paadm,xBregRowid);
	if (ret==""){
		alert(tmpChinese[0]);
	}else{
		tmpList=ret.split(CHR_1);
		if (tmpList[0]!==""){
			//Paadm Information
			tmpSub=tmpList[0].split("^");
			var obj=document.getElementById("AdmDate");
			if (obj){obj.value=tmpSub[2];}
			var obj=document.getElementById("AdmTime");
			if (obj){obj.value=tmpSub[3];}
			var obj=document.getElementById("AdmDoc");
			if (obj){obj.value=tmpSub[4];}
			var obj=document.getElementById("AdmDep");
			if (obj){obj.value=tmpSub[5];}
			var obj=document.getElementById("AdmWard");
			if (obj){obj.value=tmpSub[6];}
			var obj=document.getElementById("AdmRoom");
			if (obj){obj.value=tmpSub[7];}
			var obj=document.getElementById("AdmBed");
			if (obj){obj.value=tmpSub[8];}
		}
		if (tmpList[1]!==""){
			//Patient Information
			tmpSub=tmpList[1].split("^");
			var obj=document.getElementById("Papmi");
			if (obj){obj.value=tmpSub[21];}
			var obj=document.getElementById("RegNo");
			if (obj){obj.value=tmpSub[22];}
			var obj=document.getElementById("PatName");
			if (obj){obj.value=tmpSub[0];}
			var obj=document.getElementById("PatSex");
			if (obj){obj.value=tmpSub[1];}
			var obj=document.getElementById("PatAge");
			if (obj){obj.value=tmpSub[3];}
			var obj=document.getElementById("MrNo");
			if (obj){obj.value=tmpSub[19];}
		}
		if (tmpList[2]!==""){
			//Admit Visit Information
			tmpSub=tmpList[2].split("^");
			var obj=document.getElementById("AdmitRowid");
			if (obj){obj.value=tmpSub[0];}
			var obj=document.getElementById("AdmitDate");
			if (obj){obj.value=tmpSub[4];}
			var obj=document.getElementById("AdmitTime");
			if (obj){obj.value=tmpSub[5];}
			if (tmpSub[3]!==""){
				tmpChild=tmpSub[3].split("/")
				var obj=document.getElementById("AdmitUser");
				if (obj){obj.value=tmpChild[2];}
				var obj=document.getElementById("AdmitUserRowid");
				if (obj){obj.value=tmpChild[0];}
			}
			var obj=document.getElementById("AdmitResume");
			if (obj){obj.value=tmpSub[9];}
			var obj=document.getElementById("EscortDate");
			if (obj){obj.value=tmpSub[7];}
			var obj=document.getElementById("EscortTime");
			if (obj){obj.value=tmpSub[8];}
			if (tmpSub[6]!==""){
				tmpChild=tmpSub[6].split("/")
				var obj=document.getElementById("EscortUser");
				if (obj){obj.value=tmpChild[2];}
				var obj=document.getElementById("EscortUserRowid");
				if (obj){obj.value=tmpChild[0];}
			}
			
			if (tmpSub[11]!==""){
				tmpChild=tmpSub[11].split("/");
				if (tmpChild[0]==11){
					document.getElementById("cmdVisit").disabled=false;
				}
				if (tmpChild[0]==12){
					document.getElementById("cmdCancelVisit").disabled=false;
					document.getElementById("cmdEscort").disabled=false;
					document.getElementById("cmdXJPrint").disabled=false;
				}
				if (tmpChild[0]==13){
					document.getElementById("cmdCancelVisit").disabled=false;
					document.getElementById("cmdEscort").disabled=false;
					document.getElementById("cmdXJPrint").disabled=false;
				}
				if (tmpChild[0]==14){
					document.getElementById("cmdCancelEscort").disabled=false;
					document.getElementById("cmdPrint").disabled=false;
					document.getElementById("AdmitUser").disabled=true;
					document.getElementById("AdmitUserSign").disabled=true;
					document.getElementById("AdmitNursing").disabled=true;
					document.getElementById("AdmitCase").disabled=true;
					document.getElementById("AdmitResume").disabled=true;
				}
			}
		}else{
			document.getElementById("cmdVisit").disabled=false;
		}
		
		if (tmpList[3]!==""){
			var obj=document.getElementById("AdmitNursing");
			if (obj){
				obj.options.selectedIndex=-1;
				tmpSub=tmpList[3].split("^");
				for (var i=0;i<obj.options.length;i++){
					for (var j=0;j<tmpSub.length;j++){
						tmpChild=tmpSub[j].split("/");
						if (obj.options[i].value==tmpChild[0]){
							obj.options[i].selected=true;
						}else{
							//obj.options[i].selected=false;
						}
					}
				}
			}else{
				for (var i=0;i<obj.options.length;i++){obj.options[i].selected=false;}
			}
		}
		
		if (tmpList[4]!==""){
			var obj=document.getElementById("AdmitCase");
			if (obj){
				obj.options.selectedIndex=-1;
				tmpSub=tmpList[4].split("^");
				for (var i=0;i<obj.options.length;i++){
					for (var j=0;j<tmpSub.length;j++){
						tmpChild=tmpSub[j].split("/");
						if (obj.options[i].value==tmpChild[0]){
							obj.options[i].selected=true;
						}else{
							//obj.options[i].selected=false;
						}
					}
				}
			}else{
				for (var i=0;i<obj.options.length;i++){obj.options[i].selected=false;}
			}
		}
		
		if (tmpList[5]!==""){
			//Breg Information
			tmpSub=tmpList[5].split("^");
			var obj=document.getElementById("BregRowid");
			if (obj){obj.value=tmpSub[0];}
			var obj=document.getElementById("BregRegDate");
			if (obj){obj.value=tmpSub[4];}
			var obj=document.getElementById("BregType");
			if (obj){
				if (tmpSub[26]!==""){
					tmpChild=tmpSub[26].split("/");
					obj.value=tmpChild[1];
				}
			}
			var obj=document.getElementById("BregDep");
			if (obj){
				if (tmpSub[5]!==""){
					tmpChild=tmpSub[5].split("/");
					obj.value=tmpChild[1];
				}
			}
			var obj=document.getElementById("BregWard");
			if (obj){
				if (tmpSub[15]!==""){
					tmpChild=tmpSub[15].split("/");
					obj.value=tmpChild[1];
				}
			}
			var obj=document.getElementById("BregBookDoc");
			if (obj){obj.value=tmpSub[8];}
			if (obj){
				if (tmpSub[8]!==""){
					tmpChild=tmpSub[8].split("/");
					obj.value=tmpChild[1];
				}
			}
			var obj=document.getElementById("BregResume");
			if (obj){obj.value=tmpSub[13];}
			var obj=document.getElementById("BregDiagnose");
			if (obj){
				if (tmpSub[7]!==""){
					tmpChild=tmpSub[7].split("/");
					obj.value=tmpChild[1]+" "+tmpSub[3];
				}
			}
			var obj=document.getElementById("BregCarryType");
			if (obj){obj.value=tmpSub[24];}
			var obj=document.getElementById("BregUrgent");
			if (obj){obj.value=tmpSub[11];}
			if (obj){
				if (tmpSub[11]!==""){
					tmpChild=tmpSub[11].split("/");
					obj.value=tmpChild[1];
				}
			}
		}
	}
}

function LookUpAdmitUser(str)
{
	var objRowid=document.getElementById('AdmitUserRowid');
	var objDesc=document.getElementById('AdmitUser');
	objRowid.value="";
	objDesc.value="";
	if (str!==""){
		var tem=str.split("^");
		objRowid.value=tem[0];
		objDesc.value=tem[2];
	}
}

function LookUpEscortUser(str)
{
	var objRowid=document.getElementById('EscortUserRowid');
	var objDesc=document.getElementById('EscortUser');
	objRowid.value="";
	objDesc.value="";
	if (str!==""){
		var tem=str.split("^");
		objRowid.value=tem[0];
		objDesc.value=tem[2];
	}
}

function Prom(UserSign,UserRowid)
{
    if ((UserSign!=="")||(UserRowid!=="")){
		var obj=document.getElementById("MethodCheckUserSign");
	    if (obj) {var encmeth=obj.value} else {var encmeth=''}
	    var ret=cspRunServerMethod(encmeth,UserRowid,UserSign);
	    if(ret==1){return true;}else{return false;}
    }else{
	    return false;
	}
}

function Visit_onclick()
{
	var AdmitNursing="",AdmitCase="";
	var Paadm=document.getElementById("Paadm").value;
	var BregRowid=document.getElementById("BregRowid").value;
	var Resume=document.getElementById("AdmitResume").value;
	var UserRowid=document.getElementById("AdmitUserRowid").value;
	var UserSign=document.getElementById("AdmitUserSign").value;
	
	var obj=document.getElementById("AdmitNursing");
	if (obj){
		for (var i=0;i<obj.options.length;i++){
			if (obj.options[i].selected) {
				if (AdmitNursing!==""){
					AdmitNursing=AdmitNursing+"^"+obj.options[i].value;
				}else{
					AdmitNursing=obj.options[i].value;
				}
			}
		}
	}
	var obj=document.getElementById("AdmitCase");
	if (obj){
		for (var i=0;i<obj.options.length;i++){
			if (obj.options[i].selected) {
				if (AdmitCase!==""){
					AdmitCase=AdmitCase+"^"+obj.options[i].value;
				}else{
					AdmitCase=obj.options[i].value;
				}
			}
		}
	}

	if ((Paadm=="")||(BregRowid=="")){
		alert(t['SysErr1']);
		return;
	}
	if ((UserRowid=="")||(UserSign=="")){
		alert(t['UserErr']);
		return;
	}
	if (Prom(UserSign,UserRowid)){
		var InString=BregRowid+"^"+Paadm+"^"+UserRowid+"^"+Resume+CHR_1+AdmitNursing+CHR_1+AdmitCase;
		var obj=document.getElementById("MethodUpdateAdmit");
	    if (obj) {var encmeth=obj.value} else {var encmeth=''}
	    var ret=cspRunServerMethod(encmeth,InString);
	    if (ret>0){
			alert(t['UpdateTrue1']);
			location.reload();
		}else{
			alert(t['UpdateFalse']);
		}
	}else{
		document.getElementById("AdmitUserRowid").value="";
		document.getElementById("AdmitUser").value="";
		document.getElementById("AdmitUserSign").value="";
	}
}

function CancelVisit_onclick()
{
	var AdmitRowid=document.getElementById("AdmitRowid").value;
	var UserRowid=document.getElementById("AdmitUserRowid").value;
	var UserSign=document.getElementById("AdmitUserSign").value;
	if (AdmitRowid==""){return;}
	if (Prom(UserSign,UserRowid)){
		var InString=AdmitRowid+"^"+UserRowid;
		var obj=document.getElementById("MethodCancelAdmit");
	    if (obj) {var encmeth=obj.value} else {var encmeth=''}
	    var ret=cspRunServerMethod(encmeth,InString);
	    if (ret>0){
			alert(t['UpdateTrue2']);
			location.reload();
		}else{
			alert(t['UpdateFalse']);
		}
	}else{
		document.getElementById("AdmitUserRowid").value="";
		document.getElementById("AdmitUser").value="";
		document.getElementById("AdmitUserSign").value="";
	}
}

function Escort_onclick()
{
	var AdmitRowid=document.getElementById("AdmitRowid").value;
	var UserRowid=document.getElementById("EscortUserRowid").value;
	var UserSign=document.getElementById("EscortUserSign").value;
	if (Prom(UserSign,UserRowid)){
		var InString=AdmitRowid+"^"+UserRowid;
		var obj=document.getElementById("MethodUpdateEscort");
	    if (obj) {var encmeth=obj.value} else {var encmeth=''}
	    var ret=cspRunServerMethod(encmeth,InString);
	    if (ret>0){
			alert(t['UpdateTrue3']);
			location.reload();
		}else{
			alert(t['UpdateFalse']);
		}
	}else{
		document.getElementById("EscortUserRowid").value="";
		document.getElementById("EscortUser").value="";
		document.getElementById("EscortUserSign").value="";
	}
}

function CancelEscort_onclick()
{
	var AdmitRowid=document.getElementById("AdmitRowid").value;
	var UserRowid=document.getElementById("EscortUserRowid").value;
	var UserSign=document.getElementById("EscortUserSign").value;
	if (Prom(UserSign,UserRowid)){
		var InString=AdmitRowid+"^"+UserRowid;
		var obj=document.getElementById("MethodCancelEscort");
	    if (obj) {var encmeth=obj.value} else {var encmeth=''}
	    var ret=cspRunServerMethod(encmeth,InString);
	    if (ret>0){
			alert(t['UpdateTrue4']);
			location.reload();
		}else{
			alert(t['UpdateFalse']);
		}
	}else{
		document.getElementById("EscortUserRowid").value="";
		document.getElementById("EscortUser").value="";
		document.getElementById("EscortUserSign").value="";
	}
}

function Print_onclick()
{
	var TemplatePath="";
	var strMethod = document.getElementById("MethodGetTemplatePath").value;
	TemplatePath = cspRunServerMethod(strMethod);
	if (TemplatePath==""){
		alert(t['TemplatePath']);
		return;
	}else{
		FileName=TemplatePath+"DHCWMRAdmitVisit.xls";
		try {
			var xls = new ActiveXObject ("Excel.Application");
	    }catch(e) {
			alert("Creat Excel Object Error!");
			return;
	    }
	    
	    xls.visible=false;
		
	    var xlBook=xls.Workbooks.Add(FileName);
	    var xlsheet=xlBook.Worksheets.Item(1);
	    var tmp="";
	    tmp=document.getElementById("RegNo").value;
	    xlsheet.Cells(2,2)=tmp;
	    tmp=document.getElementById("PatName").value;
		xlsheet.Cells(2,4)=tmp;
		tmp=document.getElementById("PatSex").value;
		xlsheet.Cells(2,6)=tmp;
		tmp=document.getElementById("PatAge").value;
		xlsheet.Cells(2,8)=tmp;
		tmp=document.getElementById("BregDiagnose").value;
		xlsheet.Cells(3,2)=tmp;
		tmp="";
		var obj=document.getElementById("AdmitNursing");
		if (obj){
			for (var i=0;i<obj.options.length;i++){
				if (obj.options[i].selected=true) {
					tmp=tmp+obj.options[i].innerText+" ";
				}
			}
		}
		xlsheet.Cells(4,2)=tmp
		tmp=document.getElementById("EscortDate").value;
	    xlsheet.Cells(5,2)=tmp;
	    tmp=document.getElementById("EscortTime").value;
		xlsheet.Cells(5,4)=tmp;
		tmp=document.getElementById("BregUrgent").value;
		xlsheet.Cells(5,6)=tmp;
		tmp=document.getElementById("EscortUser").value;
		xlsheet.Cells(5,8)=tmp;
		tmp=document.getElementById("AdmWard").value;
		xlsheet.Cells(6,2)=tmp;
		tmp=document.getElementById("BregCarryType").value;
		xlsheet.Cells(6,6)=tmp;
		
		xlsheet.printout();
	    xlBook.Close (savechanges=false);
	    xls.Quit();
	    xlsheet=null;
	    xlBook=null;
	    xls=null;
	    idTmr=window.setInterval("Cleanup();",1);
	}
}

function XJPrint_onclick()
{
	var TemplatePath="";
	var strMethod = document.getElementById("MethodGetTemplatePath").value;
	TemplatePath = cspRunServerMethod(strMethod);
	if (TemplatePath==""){
		alert(t['TemplatePath']);
		return;
	}else{
		FileName=TemplatePath+"DHCWMRXJPrint.xls";
		try {
			var xls = new ActiveXObject ("Excel.Application");
	    }catch(e) {
			alert("Creat Excel Object Error!");
			return;
	    }
	    
	    xls.visible=false;
		
	    var xlBook=xls.Workbooks.Add(FileName);
	    var xlsheet=xlBook.Worksheets.Item(1);
	    
		xlsheet.printout();
	    xlBook.Close (savechanges=false);
	    xls.Quit();
	    xlsheet=null;
	    xlBook=null;
	    xls=null;
	    idTmr=window.setInterval("Cleanup();",1);
	}
}

function initEvent()
{
	var obj=document.getElementById("cmdVisit");
	if (obj){obj.onclick=Visit_onclick;}
	var obj=document.getElementById("cmdCancelVisit");
	if (obj){obj.onclick=CancelVisit_onclick;}
	var obj=document.getElementById("cmdEscort");
	if (obj){obj.onclick=Escort_onclick;}
	var obj=document.getElementById("cmdCancelEscort");
	if (obj){obj.onclick=CancelEscort_onclick;}
	var obj=document.getElementById("cmdPrint");
	if (obj){obj.onclick=Print_onclick;}
	var obj=document.getElementById("cmdXJPrint");
	if (obj){obj.onclick=XJPrint_onclick;}
	initForm();
}

initEvent();
	
function Cleanup(){
	window.clearInterval(idTmr);
	CollectGarbage();
}