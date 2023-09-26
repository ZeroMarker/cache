		var Adm;
		var Guser,usercode,username,username1;
		var RegNo;
	    var path;
		var regnoobj;
		var nameobj,patname1;
		var admobj;
		var moneyobj,money1;
		var warrantorobj,warrantor1;
		var remarkobj,remark1;
		var startdateobj,startdate1;
		var enddateobj,enddate1;
	    var addobj;
	    var printobj;
	    var findobj
	    var SelectedRow=-1;
function BodyLoadHandler() {
	regnoobj=document.getElementById('RegNo');
	nameobj=document.getElementById('name');
	admobj=document.getElementById('Adm');
	moneyobj=document.getElementById('money');
	warrantorobj=document.getElementById('warrantor');
	remarkobj=document.getElementById('remark');
	startdateobj=document.getElementById('startdate');
	enddateobj=document.getElementById('enddate');
	addobj=document.getElementById('Add');
	printobj=document.getElementById('Print');
	
	admobj.readOnly=true;
	Guser=session['LOGON.USERID'];
	usercode=session['LOGON.USERCODE'];
    username=session['LOGON.USERNAME'];
	regnoobj.onkeydown = getpat;
	addobj.onclick=add_click;
	printobj.onclick=print_click;
	//findobj.onclick=find_click;
	getenddate();
	getpath();
	websys_setfocus('RegNo');
}

function getpath() {
		   
			var getpath=document.getElementById('getpath');
			if (getpath) {var encmeth=getpath.value} else {var encmeth=''};
		
			path=cspRunServerMethod(encmeth,'','')
			
	}
function getenddate() {
	var getenddateobj=document.getElementById('gettoday');
	if (getenddateobj) {var encmeth=getenddateobj.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'setdate_val','','')=='1'){
				};
	}
function setdate_val(value)
	{
		startdateobj.value=value;
		enddateobj.value=value;
		}
function add_click() {		
		Adm=admobj.value
		if (Adm&&Adm!=""){
			//(adm, d1, d2, WarrName, WarrAmt, WarrStatus, memo, userid)
					patname1=nameobj.value;
					warrantor1=warrantorobj.value;
					money1=moneyobj.value;
					startdate1=startdateobj.value;
					enddate1=enddateobj.value;
					remark1=remarkobj.value;
					username1=username;
			if (patname1==""||warrantor1==""||money1==""||startdate1==""||enddate1=="") {alert(t['04']);return;}
			p1=Adm+"&"+startdateobj.value+"&"+enddateobj.value+"&"+warrantorobj.value+"&"+moneyobj.value+"&"+"Y"+"&"+remarkobj.value+"&"+Guser;
			
			var getadd=document.getElementById('getadd');
			if (getadd) {var encmeth=getadd.value} else {var encmeth=''};
				if (cspRunServerMethod(encmeth,'','',p1)=='0'){
					alert(t['01']);
					
					printZYDB();
				}
				else
				{alert(t['02']);}
			}
	}
function SelectRowHandler()	
{  
	var eSrc=window.event.srcElement;
	Objtbl=document.getElementById('tUDHCJFZYDB');
	Rows=Objtbl.rows.length;
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	//var obj=document.getElementById('Adm');
	if (selectrow!=SelectedRow) {
	var SelRowObj=document.getElementById('Tpatnamez'+selectrow);
	patname1=SelRowObj.innerText;
	if (!patname1) patname1="";
	
	var SelRowObj=document.getElementById('Twarrantorz'+selectrow);
	warrantor1=SelRowObj.innerText
	if (!warrantor1) warrantor1="";
	SelRowObj=document.getElementById('Tmoneyz'+selectrow);
	money1=SelRowObj.innerText;
	if (!money1) money1="";
	var SelRowObj=document.getElementById('Tstartdatez'+selectrow);
	startdate1=SelRowObj.innerText
	if (!startdate1) startdate1="";
	SelRowObj=document.getElementById('Tenddatez'+selectrow);
	enddate1=SelRowObj.innerText;
	if (!enddate1) enddate1="";
	SelRowObj=document.getElementById('Tuserz'+selectrow);
	username1=SelRowObj.innerText;
	if (!username1) username1="";
	SelRowObj=document.getElementById('Tremarkz'+selectrow);
	remark1=SelRowObj.innerText;
	if (!remark1) remark1="";
	
	SelectedRow = selectrow;
	
	}
	else{
					patname1="";
					warrantor1="";
					money1="";
					startdate1="";
					enddate1="";
					remark1="";
					username1="";
		SelectedRow="-1";
		}
	//alert(SelectedRow);
}
function print_click()
	{
		alert(SelectedRow);
		return;
		
		if (SelectedRow>0){
			
			printZYDB();
			}
		
		}
function getpat() {
	var key=websys_getKey(e);
	if (key==13) {
		if (regnoobj.value!=""){
			p1=regnoobj.value
			var getregno=document.getElementById('getadm');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
				if (cspRunServerMethod(encmeth,'setpat_val','',p1)=='1'){
				};
			
			}
		}
	}
function setpat_val(value)
	{
		var val=value.split("^");
		regnoobj.value=val[0];
		nameobj.value=val[1];
		admobj.value=val[2];
		Adm=admobj.value
		
		}

document.body.onload = BodyLoadHandler;