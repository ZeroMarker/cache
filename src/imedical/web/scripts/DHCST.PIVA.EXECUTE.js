/**
 * 模块:配液扫描执行
 * js:	DHCST.PIVA.EXECUTE 
 */
function BodyLoadHandler(){
	InitForm();
	var obj = document.getElementById("tBarcode");
	if (obj) {
		obj.onkeydown=CheckByBarcode;
	} 
	var obj = document.getElementById("tFind");
	if (obj) {
		obj.onclick=FindRecord; 
	}
}

// 函数增加判断若不是一个病区的则不扫描进去 任晓娜 增加
function IfTheSameWard(){
	var ret=""	
	var ifSame="same"
	var ifNotSame="notSame"
	var ret=GetRecord();		
	if (ret!=""){
		return ifSame;
		var arr=ret.split("^");
		var ward=arr[0];
	    var tmpwardUserSel = document.getElementById("SelectWard");
		var arr=tmpwardUserSel.value.split('-');
		if(tmpwardUserSel){	
			if(tmpwardUserSel.value!=""){		
			    if(ward!=arr[1]){
				    alert("注意:该配液不属于"+arr[1]+"!");
				    return ifNotSame;
				}else{
					return ifSame;
				}
			}else{
				alert("请选择当前病区");
				return ifNotSame;
			}
		}
	}else{
		return ifSame;
	}
}

/// 初始化
function InitForm(){
	var sum=0
    var objsum=document.getElementById("tSum");
	if (objsum)	{
		sum=objsum.value;
	} 
	var remain=GetRecordNum(); //任晓娜 剩余数量
    var objtRemain=document.getElementById("tRemain");
	var ret=""
	var objret=document.getElementById("hiddenret");
	if (objret) { /// 执行返回值 =0 成功 ,<0失败	
		var ret=objret.value;
	} 
	var ret=GetRecord();
	if ((ret=="")&&(sum==0)){
		objsum.value=0;
		var objstate=document.getElementById("tState");
		if (objstate){
			objstate.value="" ;
		}
	}  //无此标签
	if (ret!=""){
		var arr=ret.split("^");
		var ward=arr[0];
		var bed=arr[1];
		var name=arr[2];
		var batno=arr[3];
		var pr=arr[4];
		var prtdt=arr[5];
		var pydt=arr[6];
	    var objward = document.getElementById("tWard");
		if (objward) {objward.value=ward}
		var objbed = document.getElementById("tBed");
		if (objbed) {objbed.value=bed}
		var objname = document.getElementById("tName");
		if (objname) {objname.value=name}
		var objbat = document.getElementById("tBatNo");
		if (objbat) {objbat.value=batno}
		var objpr = document.getElementById("tPr");
		if (objpr) {objpr.value=pr}
		var objprt= document.getElementById("tPrtDate");
		if (objprt) {objprt.value=prtdt}
		var objp = document.getElementById("tPdate");
		if (objp) {objp.value=pydt}	
		if (objsum){
			if  (objsum.value==0){
				objsum.value=1;
			}else{   
				objsum.value=parseInt(trim(objsum.value))+1; 
			}
		}			
	}
    WriteState();  //状态写入显示
	//初始化状态
	var obj = document.getElementById("tExeState");
	if (obj){
		setStates();
		obj.onchange=ExeStateSelect;
	}	
	SetFocus(); 	
}

///任晓娜 增加
///增加计算病区已经打签但是还未扫描的配液数量
function GetRecordNum()
{
	var SelectWard="" ;
	var obj = document.getElementById("SelectWard");
    if (obj) SelectWard=obj.value;
	var obj=document.getElementById("mGetRecordNum");
	if (obj) {
		var encmeth=obj.value;
	}else{
		var encmeth='';
	}
	var result=cspRunServerMethod(encmeth,SelectWard);
	return result;
}

/// 写入状态栏
function WriteState(){
     var exestate=""
	 var objstr=document.getElementById("hiddenstr");
	 if (objstr) exestate=objstr.value; //执行返回的Msg
	 var objstate=document.getElementById("tState");
	 if(objstate) objstate.value=exestate;
}

/// 获取标签记录
function GetRecord(){
	var bar="" ;
	var obj = document.getElementById("tBarcode");
    if (obj) bar=obj.value;
	var obj=document.getElementById("mGetRecord");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,bar);
	return result;
}

/// 配液执行状态索引
function setStates(){
	var obj=document.getElementById("tExeState");
	if (obj) PInitExeState(obj);
	var objindex=document.getElementById("ExeStateIndex");
	if (objindex) obj.selectedIndex=objindex.value;
}

/// 初始化配液执行状态
function PInitExeState(listobj){
	var obj=document.getElementById("mGetExeState");
	if (obj) {
		var encmeth=obj.value;
	}else{
		var encmeth='';
	}
	var result=cspRunServerMethod(encmeth,session['LOGON.CTLOCID']);
	if (result!=""){
		var tmparr=result.split("!!")
		var cnt=tmparr.length
		for (i=0;i<=cnt-1;i++){ 
			var typestr=tmparr[i].split("^")
			var type=typestr[0];
			var typeindex=typestr[1];
			/// 初始化配液执行状态
			if (listobj){
				listobj.size=1; 
			 	listobj.multiple=false;
			 	listobj.options[i+1]=new Option(type,typeindex);			 	
		    }
		}
	}else{
	    listobj.size=1; 
	 	listobj.multiple=false;
	}
}

/// ExeState
function ExeStateSelect(){
	var obj=document.getElementById("ExeStateIndex");
	if(obj){
		var objpass=document.getElementById("tExeState");
		obj.value=objpass.selectedIndex;
		SetFocus();
	}	
}

/// 扫描条码
function CheckByBarcode(){	
	if (window.event.keyCode==13){
		window.event.keyCode=117;
		var ifthesame=""
		var ifthesame=IfTheSameWard()
		if(ifthesame=="notSame"){return}
		//任晓娜注释 用于测试
		//if (CheckBeforeFind()==false){alert("请先选择< 预执行状态后重试 ...>");return;}	
		re=Execute(); // 执行
		if(re<0){
			alert("不能执行请参考界面配液状态提示")
			return
		}
		FindRecord(); // 显示记录
	}	
}

/// 执行前检查
function CheckBeforeFind(){
	var objexe=document.getElementById("tExeState");
	if (objexe) pnumber=objexe.value;
	if (pnumber==""){
		return false;
	}else{
		return true;
	}
}

/// 查找记录
function FindRecord(){
	var objbar=document.getElementById("tBarcode");
	if (objbar) barcode=objbar.value;
	var objstate=document.getElementById("tState");
	if (objstate) objstate.value="" ;
	var objstr=document.getElementById("hiddenstr"); //Msg
	if (objstr) objstr.value="" ;
	var objfind = document.getElementById("tFind");
	if (objfind) tFind_click();
}

/// 执行--
function Execute(){
	var objbar=document.getElementById("tBarcode");
	if (objbar) barcode=objbar.value;
	var userid=session['LOGON.USERID'] ;
	var ctlocid=session['LOGON.CTLOCID'] ;
	var pnumber=""
	var objexe=document.getElementById("tExeState");
	if (objexe) pnumber=objexe.value;

	var obj=document.getElementById("mExecute");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,barcode,pnumber,userid,ctlocid);
	var arr=result.split("^") ;
	var state=arr[1] ;
	var ret=arr[0] ;
	
	if (barcode==""){state=""} //清空,初始化
	
	var objstate=document.getElementById("tState");
	if (objstate) objstate.value=state ;
	
	var objstr=document.getElementById("hiddenstr"); //Msg
	if (objstr)objstr.value=state ;
	
	var objret=document.getElementById("hiddenret"); //返回值  =0 成功 ,<0失败
	if (objret)objret.value=ret ;
    return ret  //任晓娜
	
	
}

/// 获取焦点
function SetFocus(){
	obj=document.getElementById("tBarcode");
	if (obj){
		obj.value="";
		websys_setfocus(obj.id);
	};
}

document.body.onload=BodyLoadHandler;