//詹明超 20120717,门特登记
var tmpClearStr="^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
function BodyLoadHandler() {
	//登记号事件
	var objRegID=$("PatRegID");
	if(objRegID){
		objRegID.onkeydown=function(){
			if(window.event.keyCode==13){
				var tmpstr=GetPatInfoByRegNo(objRegID.value);
				if(""!=tmpstr){
					FillPatInfo(tmpstr)
					//查询登记记录
					QueryMTHistory();
				}
			}
		}
	}
	//登记
	var objBtnReg=$("BtnReg");
	if(objBtnReg){
		objBtnReg.onclick=BtnReg_Click;
	}	
	//登记信息下载
	var objBtnMTDownload=$("BtnMTDownload");
	if(objBtnMTDownload){
		objBtnMTDownload.onclick=MTDownload;
	}
	//撤销登记
	var objBtnBtnDestory=$("BtnDestory");
	if(objBtnBtnDestory){
		objBtnBtnDestory.onclick=BtnDestory_Click;
	}
	//三级医院
	var objHosLvl3=$("HosLvl3");
	if(objHosLvl3){
		objHosLvl3.onkeydown=function(){
			if(window.event.keyCode==13){
				window.event.keyCode=117;
				HosLvl3_lookuphandler();
			}
		}
	}
	//二级医院
	var objHosLvl2=$("HosLvl2");
	if(objHosLvl2){
		objHosLvl2.onkeydown=function(){
			if(window.event.keyCode==13){
				window.event.keyCode=117;
				HosLvl2_lookuphandler();
			}
		}
	}
	//一级医院
	var objHosLvl1=$("HosLvl1");
	if(objHosLvl1){
		objHosLvl1.onkeydown=function(){
			if(window.event.keyCode==13){
				window.event.keyCode=117;
				HosLvl1_lookuphandler();
			}
		}
	}
	var objDocSave=$("DocSave");
	if(objDocSave){
		objDocSave.onclick=DocSave_Click;
	}
	var objMTRegHistory=$("MTRegHistory");
	if(objMTRegHistory){
		objMTRegHistory.onchange=MTRegHistory_Change;
	}
	var objBtnInitialize=$("BtnInitialize");
	if(objBtnInitialize){
		objBtnInitialize.onclick=function(){
			FillPatInfo("^^^^^^");
			FillPatOtherInfo(tmpClearStr);
			$("MTRegHistory").options.length=0;
		}
	}
	
	Initialize();	//初始化界面元素
}

//初始化界面元素
function Initialize(){
	//登记病种
	var obj=$("PatRegMTBZ");
	if (obj){
		obj.size=1; 
		obj.multiple=false;
		var MTStr=tkMakeServerCall("web.INSUDicDataCom","GetDicListByType","MTLBA")
		var tmpArr=MTStr.split("!")
		obj.options[0]=new Option("","");
		for(var i=0;i<tmpArr.length;i++){
			var tmpArr2=tmpArr[i].split("^");
			obj.options[i+1]=new Option(tmpArr2[3],tmpArr2[2]);
		}
	}
	//登记记录
	var obj=$("MTRegHistory");
	if (obj){
		obj.size=1; 
		obj.multiple=false;
		obj.options[0]=new Option("","");
	}
	//社保机构
	var obj=$("InsuCenter");
	if (obj){
		obj.size=1; 
		obj.multiple=false;
		var MTStr=tkMakeServerCall("web.INSUDicDataCom","GetDicListByType","FZX")
		var tmpArr=MTStr.split("!")
		obj.options[0]=new Option("","");
		for(var i=0;i<tmpArr.length;i++){
			var tmpArr2=tmpArr[i].split("^");
			obj.options[i+1]=new Option(tmpArr2[3],tmpArr2[2]);
		}
	}
	//登记方式
	var obj=$("PatMTRegType");
	if (obj){
		obj.size=1; 
		obj.multiple=false;
		obj.options[0]=new Option("首次","1");
		obj.options[1]=new Option("接续","2");
		obj.options[2]=new Option("逾期首次","3");
	}
}
//通过登记号查询病人基本信息
function GetPatInfoByRegNo(RegNO){
	if(""==RegNO) return "";
	var PatStr=tkMakeServerCall("web.INSUBase","GetPaPamasInfo",RegNO)
	return PatStr
}
//填充病人基本信息元素
function FillPatInfo(InArgs){
	if(""==InArgs) return;
	var tmpArr=InArgs.split("^")
	if(tmpArr.length<8){
		//基本信息
		var obj=$("PapmiDr");
		if(obj) obj.value=tmpArr[0];	
		var obj=$("PatRegID");
		if(obj) obj.value=tmpArr[1];	
		var obj=$("PatName");
		if(obj) obj.value=tmpArr[2];	
		var obj=$("PatSex");
		if(obj) obj.value=tmpArr[3];	
		var obj=$("PatOld");
		if(obj) obj.value=tmpArr[4];	
		var obj=$("PatID");
		if(obj) obj.value=tmpArr[6];	
	}
}
//查询三级医院
function LookUpHosLvl3(str) 
{  //alert(str)
	//
	var tmp1 = str.split("^");
	var obj=$("HosLvl3")
	if((obj!=null)&(tmp1.length>1)) {obj.value=tmp1[1]}
}
function LookUpHosLvl2(str) 
{ 
	var tmp1 = str.split("^");
	var obj=$("HosLvl2")
	if((obj!=null)&(tmp1.length>1)) {obj.value=tmp1[1]}
}

function LookUpHosLvl1(str) 
{ 
	var tmp1 = str.split("^");
	var obj=$("HosLvl1")
	if((obj!=null)&(tmp1.length>1)) {obj.value=tmp1[1]}
}
function LookUpDrogStore(str) 
{ 
	var tmp1 = str.split("^");
	var obj=$("DrogStore")
	if((obj!=null)&(tmp1.length>1)) {obj.value=tmp1[1]}
}
//医生登记保存
function DocSave_Click(){
	if($("DocSave").disabled==true) return;
	var tmpRegRowid=$("RegRowid").value;
	if(($("MTRegHistory").options.length>1)&(""==tmpRegRowid)){
		if(confirm("病人有门特登记记录,是否新开登记?")){
		}else{
			alert("请选择登记记录!修改后保存")
			return;
		}
	}
	var tmpRegNo=$("PatRegID").value;
	if(tmpRegNo.length!=10){alert("登记号非法!");return;}
	var tmpMTBeginDate=$("MTBeginDate").value;
	if(tmpMTBeginDate.length!=10){alert("请选择门特登记开始日期!");return;}
	//var tmpPapmiDr=$("PapmiDr").value;
	var PatName=$("PatName").value;
	if(""==PatName){return;}
	var tmpPatID=$("PatID").value;	//身份证号
	var tmpDiagnose=$("PatRegMTBZ").value;	//登记病种
	if(""==tmpDiagnose) {alert("请选择门特病种!");return;}
	var tmpPatHst=$("PatHst").value;	//病史
	var tmpNote=$("Note").value;	//辅助检查
	var tmpDiagnosis=$("Diagnosis").value;	//临床诊断
	var DocCode=session['LOGON.USERCODE'];
	var tmpRegType=$("PatMTRegType").value;		//登记类别
	var tmpTel=$("PatPhone").value;
	var tmpAddress=$("PatAddress").value;		//家庭地址
	var SaveStr=tmpRegRowid+"^"+tmpRegNo+"^"+PatName+"^"+tmpPatID+"^"+tmpDiagnose+"^D^^^^^MTDJ^"+tmpRegType+"^^^A^"+DocCode+"^^^^^^^^^^^^^^^^^^^^^^^"+tmpPatHst+"^"+tmpNote+"^"+tmpDiagnosis+"^"+tmpTel+"^"+tmpAddress+"^^^^^^^^";
	SaveStr=SaveStr+"^"+tmpMTBeginDate;
	var RtnCode=tkMakeServerCall("web.DHCINSUAdmInfoCtl","SaveINSURegInfo",SaveStr)
	if(eval(RtnCode)>0){alert("保存成功!")}
}
//查询登记历史
function QueryMTHistory(){
	var RtnStr=tkMakeServerCall("web.DHCINSUAdmInfoCtl","QueryMTRegInfo",$("PatRegID").value)
	var objHisList=document.getElementById("MTRegHistory")
	if(RtnStr.length>100){
		objHisList.options.length=0;
		//填充下拉列表
		objHisList.options[0]=new Option("		有登记记录,请选择......	","");
		var tmpArr=RtnStr.split("$");
		for(var i=1;i<tmpArr.length;i++){
			var tmparr2=tmpArr[i].split("^");
			var tmpstr="门特开始日期:"+tmparr2[51]+",结束日期"+tmparr2[53]+",登记病种:"+tmparr2[4]
			objHisList.options[i]=new Option(tmpstr,tmparr2[0]);
		}
	}
}
function MTRegHistory_Change(){
	MTRegHistory();
}
function MTRegHistory(){
	//alert($("MTRegHistory").value)
	var tmprowid=$("MTRegHistory").value
	var isNum =/^\d*$/;
	if(!isNum.test(tmprowid)){tmpClearStr;return;}
	$("RegRowid").value=tmprowid
	//GetINSURegInfo
	var RtnStr=tkMakeServerCall("web.DHCINSUAdmInfoCtl","GetINSURegInfo",tmprowid)
	//alert(RtnStr)
	if(RtnStr.length<100){RtnStr=tmpClearStr}
	FillPatOtherInfo(RtnStr)
	
}

//填充病人登记信息
function FillPatOtherInfo(FPOStr){
	//alert(FPOStr)
	var tmpArr=FPOStr.split("^");
	if(("I"==tmpArr[5])||(tmpArr[9].length>2))
	{
		$("BtnReg").disabled=true;
		$("DocSave").disabled=true;
	}
	else
	{
		$("BtnReg").disabled=false;
		$("DocSave").disabled=false;
	}
	if(tmpArr[9].length>2)
	{
		$("PatMTNo").readOnly=true;
	}
	else
	{
		$("PatMTNo").readOnly=false;
	}
	if("D"==tmpArr[5]) tmpArr[5]="医生已登记"
	if("I"==tmpArr[5]) tmpArr[5]="开具成功"
	$("RegFlag").value=tmpArr[5];	//登记状态
	$("PatType").value=tmpArr[7];	//人员类别
	$("PatPhone").value=tmpArr[41];
	$("PatAddress").value=tmpArr[42];
	$("DocCode").value=tmpArr[15];	//诊断医师
	$("MTBeginDate").value=tmpArr[51];
	var tmpobjPatRegMTBZ=$("PatRegMTBZ")
	for(var i=0;i<tmpobjPatRegMTBZ.options.length;i++){
		if(tmpArr[4]==tmpobjPatRegMTBZ.options[i].value){
			tmpobjPatRegMTBZ.selectedIndex=i;
		}
	}
	$("PatInsuId").value=tmpArr[6];	//个人编码
	$("RegDate").value=tmpArr[59];	//操作日期
	$("PatMTNo").value=tmpArr[9];	//门特登记号码
	$("PatHst").value=tmpArr[38];
	$("Note").value=tmpArr[39];
	$("Diagnosis").value=tmpArr[40];
	$("MTEndDate").value=tmpArr[53];
	$("PatMTRegHos").value=tmpArr[35];
	$("PatComp").value=tmpArr[36];
	$("DocCode").value=tmpArr[15];
	$("HosAdmin").value=tmpArr[23];
	$("CenterAdmin").value=tmpArr[24];
	$("RegOPT").value=tmpArr[12];
	$("MTFrom").value=tmpArr[26];
	var tmpInsuCenter=$("InsuCenter")
	for(var i=0;i<tmpInsuCenter.options.length;i++){
		if(tmpArr[13]==tmpInsuCenter.options[i].value){
			tmpInsuCenter.selectedIndex=i;
		}
	}
	$("HosLvl1").value=tmpArr[18];
	$("HosLvl2").value=tmpArr[19];
	$("HosLvl3").value=tmpArr[20];
	$("DrogStore").value=tmpArr[21];
	var tmpPatMTRegType=$("PatMTRegType")
	for(var i=0;i<tmpPatMTRegType.options.length;i++){
		if(tmpArr[11]==tmpPatMTRegType.options[i].value){
			tmpPatMTRegType.selectedIndex=i;
		}
	}
}

function BtnReg_Click(){
	if($("BtnReg").disabled==true) return;
	//alert("tst"+String.fromCharCode(10)+"123")
	var tmpRegRowid=$("RegRowid").value;
	var PatName=$("PatName").value;//PatName
	if(PatName.length<2){return;}
	if(eval(tmpRegRowid)>0)
	{
		//调用.NET程序
		 var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_TJ");
		 //var RtnCode=DHCINSUBLL.INSUMTDJFun(tmpRegRowid,PatName,"","","","SYDJ")
		 var RtnCode=DHCINSUBLL.INSUMTDJFun(eval(tmpRegRowid),PatName,"","","","MTDJ")
		 if("0"==RtnCode)
		 {
			 alert("登记成功!")
			 MTRegHistory();
		 }else{
			 alert("登记失败2!")
		 }
	}
	else
	{alert("请选择!")}
}

function MTDownload(){
	//alert("tst"+String.fromCharCode(10)+"123")
	var tmpRegRowid=$("RegRowid").value;
	var PatName=$("PatName").value;//PatName
	if(PatName.length<2){return;}
	var PatMTNo=$("PatMTNo").value;
	if(PatMTNo.length<2){alert("请输入门特登记编号");return;}
	var MTBeginDate=$("MTBeginDate").value;
	if(MTBeginDate.length<2){alert("请选择门特开始日期");return;}
	if(eval(tmpRegRowid)>0)
	{
		//调用.NET程序
		 var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_TJ");
		 //var RtnCode=DHCINSUBLL.INSUMTDJFun(tmpRegRowid,PatName,"","","","SYDJ")
		 var RtnCode=DHCINSUBLL.INSUMTDJFun(eval(tmpRegRowid),PatName,"",PatMTNo,MTBeginDate,"MTDJDownload")
		 if("0"==RtnCode)
		 {
			 alert("下载成功")
			 MTRegHistory();
		 }else{
			 alert("下载失败2!")
		 }
	}
	else
	{alert("请选择!")}
}
function BtnDestory_Click(){
	//alert("tst"+String.fromCharCode(10)+"123")
	var tmpRegRowid=$("RegRowid").value;
	var PatName=$("PatName").value;//PatName
	if(PatName.length<2){return;}
	var PatMTNo=$("PatMTNo").value;
	if(PatMTNo.length<2){alert("请输入门特登记编号");return;}
	var MTBeginDate=$("MTBeginDate").value;
	if(MTBeginDate.length<2){alert("请选择门特开始日期");return;}
	if(eval(tmpRegRowid)>0)
	{
		//调用.NET程序
		 var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_TJ");
		 //var RtnCode=DHCINSUBLL.INSUMTDJFun(tmpRegRowid,PatName,"","","","SYDJ")
		 var RtnCode=DHCINSUBLL.INSUMTDJFun(eval(tmpRegRowid),PatName,"",PatMTNo,MTBeginDate,"MTDJCancel")
		 if("0"==RtnCode)
		 {
			 alert("撤销成功")
			 MTRegHistory();
		 }else{
			 alert("撤销失败2!")
		 }
	}
	else
	{alert("请选择!")}
}
/*
function GetObjValueById(ElmtId){
	var tmpobj=document.getElementById(ElmtId)
	if(tmpobj){
		return tmpobj.value;
	}else{
		return "-1"
	}
}
*/
document.body.onload = BodyLoadHandler;