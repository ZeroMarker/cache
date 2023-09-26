/**
 * 模块:拒发药品查询
 */
function BodyLoadHandler(){
	var obj=document.getElementById("Find")
	if (obj) obj.onclick=findDrugRefuse;
	var obj=document.getElementById("Close")
	if (obj) obj.onclick=closeWin;	
	var obj=document.getElementById("RegNo") ;    //zhangdongmei 2007-3-16
	if (obj) obj.onblur=RegNoBlur; 
	if (obj) obj.onkeydown=RegNoEnter;
	if (obj) {   
		if (obj.value==""){
			obj.value=GetRegNoByEpisodeID();
			RegNoBlur();
		}
	}
	var obj=document.getElementById("PhaLoc"); //2005-05-26
	if (obj){
		obj.onblur=PhaLocCheck;
	}
	var obj=document.getElementById("bCancelRefuse") ; 
	if (obj) obj.onclick=StopRefuse;
	GetUserWard();
	setDefaultValue();
	var obj=document.getElementById("BodyLoaded");
	if (obj.value!=1){		
		obj.value=1;
		GetDefaultPhaloc();
		//setDefaultValue();
		findDrugRefuse();
	}else{
	}
}
function GetUserWard(){
	///description:获取用户所在病区
    var loc=session['LOGON.CTLOCID'];
    var objadm=document.getElementById("EpisodeID")
	var adm=objadm.value	
	var str=tkMakeServerCall("web.DHCSTDRUGREFUSE","GetDefaultWard",loc,adm)
	var tem=str.split("^");
	if (str!=""){
		var objWard=document.getElementById("Ward");
		objWard.value=tem[0];
		var objwardrowid=document.getElementById("WardRowid");
		objwardrowid.value=tem[1];		
	}	
}

function RegNoBlur(){
	//2007-8-6,zdm	
	var obj=document.getElementById("RegNo") ;
	var regno ;
	if (obj){ 
	 	regno=obj.value ;
	 	if (regno!=""){
		 	obj.value=getRegNo(regno) ;
	  		regno=obj.value ; 	  		
	  	}
	}	
	var getpa=document.getElementById('mGetPa');
	if (getpa) {var encmeth=getpa.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'SetPa','',regno)=='0') {}  
 }	

function SetPa(value){
	var painfo=value.split("^")	;
	var obj;
	obj=document.getElementById("Name");
	if (obj) obj.value=painfo[0];
}

function RegNoEnter(){ 
	//2007-8-6,zdm	
	if (window.event.keyCode==13) {
		RegNoBlur();
	}
	else{
		var obj=document.getElementById("RegNo")
		if(isNaN(obj.value)==true)  { obj.value="" ;}
	}
}

function findDrugRefuse(){
	var PhaLocRowid = "";
	var obj=document.getElementById("PhaLocRowid");
	if (obj) PhaLocRowid=obj.value;
	var obj1=document.getElementById("StartDate");
	var obj2=document.getElementById("EndDate");
	if (obj1.value==""){
		alert(t['SD_NEED']);
	    return;
	}
	if (obj2.value==""){
		alert(t['ED_NEED']);
	    return;
	}
    if (DateStringCompare(obj1.value,obj2.value )==1) {
	    alert(t['INVALID_DATESCOPE']);
	 	return;
	 }	
	Find_click();
}

function SetPhaLocRowidLookupSelect(str){
	var data=str.split("^");
	var obj=document.getElementById("PhaLocRowid");
	if (obj){
		if (data.length>0)  {
			obj.value=data[1] ;
		}else{
			obj.value="" ;  
		}
	 }	
}
function PhaLocCheck(){
	var obj=document.getElementById("PhaLoc");
	var obj2=document.getElementById("PhaLocRowid");
	if (obj) {
	 	if (obj.value=="") obj2.value="" 
	}
} 
function SetWardRowidLookupSelect(str){
	var data=str.split("^");
	var obj=document.getElementById("WardRowid");
	if (obj){
		if (data.length>0){
			obj.value=data[1] ;
		}else{  
			obj.value="" ;  	 
		}
	}	
}

function closeWin(){
	window.history.back();
}
function setDefaultValue(){
	var sd=getRelaDate(-5);
	var ed=today();
	obj=document.getElementById("StartDate")
	if (obj) obj.value=sd;
	obj=document.getElementById("EndDate")
	if (obj) obj.value=ed;	
	///zdm,2012-04-10,登录科室如果不等于接收科室，不允许取消拒绝(防止护士取消拒绝)
    var loc=session['LOGON.CTLOCID'];
    var phaloc="";
    var obj=document.getElementById("PhaLocRowid");
    if(obj){phaloc=obj.value;} 
    if(phaloc!=loc){    
		var obj=document.getElementById("bCancelRefuse") ; 		
 		//if (obj) obj.disabled=true;
 		if (obj) obj.style.display = "none";
	}
}
function StopRefuse(){
	var obj2=document.getElementById("currentRow")
	if (obj2) {	
		var currentrow=obj2.value;
		if (currentrow<1){
			return; 
		}
	}	
	var obj=document.getElementById("TOrdStatusCode"+"z"+currentrow)
	if (obj){ 	
		var obj3=document.getElementById("Toedis"+"z"+currentrow);
		if (obj3) var oedis=obj3.value;		 
		if (oedis!=""){ 
			deleteRefuse(oedis);
		}else{
		}	 
	}
	findDrugRefuse();
}
function deleteRefuse(oedis){
	var obj=document.getElementById("mDeleteRefuse") ;
	if (obj) {
		var encmeth=obj.value;
	}else {
		var encmeth='';
	}
	var ret=cspRunServerMethod(encmeth,'','',oedis,session['LOGON.CTLOCID']) ;
	if(ret==-2){
		alert("该记录已经撤销执行或停止执行，不能取消拒绝！")
		return;
	}else if (ret ==-3){
		alert("您无法撤销拒绝,请联系拒绝发药的药房!")
		return;
	}else if (ret<0){
		alert(t['STOP_FAILED']);
		return;
	}else{ 
		alert(t['STOP_SUCCEED']);
	}
}

function SelectRowHandler() {
	var row=selectedRow(window);
	var obj=document.getElementById("currentRow") ;
	if (obj) obj.value=row
}
function GetRegNoByEpisodeID(){
	var objadm=document.getElementById("EpisodeID")
	var adm=objadm.value	
	var getpa=document.getElementById('mGetRegNoByEpisodeID');
	if (getpa) {var encmeth=getpa.value} else {var encmeth=''};
	var regno=cspRunServerMethod(encmeth,adm)
	return regno	
}

function GetDefaultPhaloc(){ 
	var objdisplocid=document.getElementById("PhaLocRowid");
	if (objdisplocid.value==""){
		var str= GetDefaultLoc(); //GetDefaultPhaLocConfig()
		DefaultStr=str.split("^")
		var DefaultPhalocDesc=DefaultStr[1]
		if (DefaultPhalocDesc=="") {return;} 
		var DefaultPhalocID=DefaultStr[0]
		if (DefaultPhalocID=="") {return;} 
		objdisplocid.value=DefaultPhalocID
		var obj=document.getElementById("PhaLoc");
		obj.value=DefaultPhalocDesc;
	}	 
}

function GetDefaultPhaLocConfig(){
  var grpid=session['LOGON.GROUPID'] ;  
  /// 多次切换界面时,obj经常为null,导致数据无法获取
  /// bianshuai 2015-12-02 修改
  var config = tkMakeServerCall("web.DHCSTKUTIL","GetDefaultPhaLoc",grpid);
  return config;
}
function GetDefaultLoc(){
  var locid=session['LOGON.CTLOCID'] ;  
  /// 多次切换界面时,obj经常为null,导致数据无法获取
  /// bianshuai 2015-12-02 修改
  var deflocstr = tkMakeServerCall("web.DHCSTDRUGREFUSE","GetDefaultLoc",locid);
  return deflocstr;
}
document.body.onload=BodyLoadHandler;