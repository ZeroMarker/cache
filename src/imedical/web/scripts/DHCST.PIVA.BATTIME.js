/**
 * 模块:配液批次维护
 */
var currRow="";
function BodyLoadHandler(){
	var obj=document.getElementById("Update");
	if (obj) obj.onclick=setBat;
	var obj=document.getElementById("PLoc"); 
	if (obj) {
		obj.onkeydown=popDispLoc;
		obj.onblur=DispLocCheck;
	}    
}

function SelectRowHandler(){
	currRow=selectedRow(window);
	setItem(currRow);
}

function setItem(currRow){   
	var objploc=document.getElementById("Tploc"+"z"+currRow);
	if (objploc) var ploc=objploc.innerText;
	var objstime=document.getElementById("Tstime"+"z"+currRow);
	if (objstime) var stime=objstime.innerText;
	var objxtime=document.getElementById("Txtime"+"z"+currRow);
	if (objxtime) var xtime=objxtime.innerText;
	var objbat=document.getElementById("Tbat"+"z"+currRow);
	if (objbat) var bat=objbat.innerText;
	var objflag=document.getElementById("TSeqFlag"+"z"+currRow);
	if (objflag) var seqflag=objflag.checked  ; 
	var objflag=document.getElementById("TWard"+"z"+currRow);
	if (objflag) var TWard=objflag.value;
	var objflag=document.getElementById("TWarddesc"+"z"+currRow);
	if (objflag) var TWarddesc=objflag.innerText;
	var objplocid=document.getElementById("Tplocrowid"+"z"+currRow);
	if (objplocid) var plocrowid=objplocid.value;
	var objPloc=document.getElementById("PLoc");
	objPloc.value=ploc;
	var objStime=document.getElementById("Stime");
	objStime.value=stime;
	var objXtime=document.getElementById("Xtime");
	objXtime.value=xtime;
	var objBat=document.getElementById("Bat");
	objBat.value=bat;
	var objflag=document.getElementById("SeqFlag");
	objflag.checked=seqflag;
	var objflag=document.getElementById("WardId");
	objflag.value=TWard;
	var objflag=document.getElementById("Ward");
	objflag.innerText=TWarddesc;
	var objflag=document.getElementById("plocrowid");
	objflag.value=plocrowid;
}

function setBat(){
    if (currRow!=""){
	    var flag=2;
    	var objrowid=document.getElementById("Trowid"+"z"+currRow);
        var rowid=objrowid.value;
    }
    if (currRow=="") { //flag 1:增加   2:更新
	      flag=1;
          rowid="";
    }       
	var objPloc=document.getElementById("plocrowid");
	var Ploc=objPloc.value;
	if (Ploc==""){
		alert("配液科室没有填写");
		return;
	}
	var objStime=document.getElementById("Stime");
	var Stime=objStime.value;
	if (Stime==""){
		alert("开始时间没有填写");
		return;
	}
	if (Stime.length==5) {
		Stime=Stime+":00";
	}
	var objXtime=document.getElementById("Xtime");
	var Xtime=objXtime.value;
	if (Xtime==""){
		alert("截止时间没有填写");
		return;
	}
	if (Xtime.length==5) {
		Xtime=Xtime+":59";
	}
	var objBat=document.getElementById("Bat")
	var Bat=objBat.value
	if (Bat==""){
		alert("批次没有填写");
		return;
	}
    if (flag==2){
		var objPloc=document.getElementById("PLoc")
	    var Ploc=objPloc.value
	}
	var seqflag=false;
	var objflag=document.getElementById("SeqFlag")
    if (objflag) var seqflag=objflag.checked
    if (seqflag==true) {
	    seqflag="Y";
	} else {
		seqflag="N"
	}
    var ward=document.getElementById("Ward").value;
    var xx=document.getElementById("mSave");
	if (xx) {var encmeth=xx.value;} else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,Ploc,Stime,Xtime,Bat,flag,rowid,seqflag,ward.replace(/(^\s*)|(\s*$)/g, ""))
	if (result==-1){
		alert("此设置失败!");
		return;
	}
	else if (result==-2){
		alert("科室该批次已存在!");
		return;
	}
	else {
		alert("OK");
	}
	self.location.reload();
}

function popDispLoc(){ 
	if (window.event.keyCode==13) {  
		window.event.keyCode=117;
		Ploc_lookuphandler();
	}
}

function DispLocCheck(){
	var obj=document.getElementById("PLoc");
	var obj2=document.getElementById("plocrowid");
	if (obj) {
		if (obj.value=="") {
			obj2.value="";
		}		
	}
}

function DispLocLookUpSelect(str){ 
	var loc=str.split("^");
	var obj=document.getElementById("plocrowid");
	if (obj){
		if (loc.length>0)   {
			obj.value=loc[1] ;
		}else	{
			obj.value="" ;  
		}
	}
}

function FindClick(){
	Find_click();
}

function WardLookUpSelect(str){ 
	var loc=str.split("^");
	var obj=document.getElementById("WardId");
	if (obj){
		if (loc.length>0){
			obj.value=loc[1] ;
		}else{
			obj.value="" ; 
		} 
	}
}

document.body.onload=BodyLoadHandler