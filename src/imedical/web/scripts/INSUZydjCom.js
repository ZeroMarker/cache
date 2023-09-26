//Writen by czq 2006-04-01
var InsuType="NBB";
var ybdjkz=0;qxdjkz=0; //登记控制?取消登记控制
var zyh="",jzh="",AdmDr, PatientID//住院号,就诊号,papmidr
var Guser
var InsuType=""         //市保NBA?农保NBB标志
var spcDiagCode=""
var HisLocCode
Guser=session['LOGON.USERID'];

function BodyLoadHandler() {
	iniForm();
	var obj=document.getElementById("zyh")
	if (obj){zyh=obj.value;}
	if (zyh==""){qp();}  //Lou 2010-03-05 如果登记号不为空不清屏,如从HIS界面调过来的时候
	if (zyh!=""){GetPaAdmNO();}
	
	var obj=document.getElementById("rylb00");
	if (obj) obj.onchange=mySelectRow;
	var obj=document.getElementById("BegDate");
	if (obj) obj.onchange=myFillDateToFeeDate;
	
	var obj=document.getElementById("zyh")
	if (obj){

		obj.onchange=qp;
		obj.onkeydown=Key;
	}
	//选择就诊号
	var obj=document.getElementById("jzh")
	if (obj){obj.onchange=selejzh;}	
	//医保登记
	var obj=document.getElementById("ybdj");
	if (obj){ obj.onclick=ybdj;}	
	//取消登记
	var obj=document.getElementById("qxdj");
	if (obj) {obj.onclick=qxdj;}
	//清屏
	var obj=document.getElementById("qp");	
	if (obj) {obj.onclick=qp;}
	
    //zmgzt
	var obj=document.getElementById("INSUCARDID");
	if (obj) obj.onkeydown=ybcardnoEnter; 
	
	  //20070111	
	var obj=document.getElementById("SpcDiag");
	if (obj) obj.onchange=setSpcCodeValue;
	
	//20100201 Lou
	var obj=document.getElementById("Query");
	if (obj) obj.onclick=Query_Click;
	
	//Add by Lou 2010-03-05 如果HIS登记界面传进来了admdr,则将相应数据显示,不需操作员手工选择
	var obj=document.getElementById("adm"); 
	if (obj){
		if (obj.value!=""){
			SetData();
			}
		}
	
}
	
//*******************************
//1:初始化界面                    *
//*******************************
function iniForm(){

	obj=document.getElementById("jzh");
	if (obj){
	  obj.size=1; 
	  obj.multiple=false;	
	}
	obj=document.getElementById("xming0")
    if (obj){obj.readOnly=true;}
	obj=document.getElementById("xbie00")
	if (obj){obj.readOnly=true;}
	obj=document.getElementById("brnl00")
	if (obj){obj.readOnly=true;}
	obj=document.getElementById("id0000") //身份证件号
	if (obj){obj.readOnly=true;}
	obj=document.getElementById("ryrq00")
	if (obj){obj.readOnly=true;}
	obj=document.getElementById("rysj00")
	if (obj){obj.readOnly=true;}
	obj=document.getElementById("ryksmc")
	if (obj){obj.readOnly=true;}
	//入院类别
	obj=document.getElementById("rylb00")
	if (obj){
	  obj.size=1; 
	  obj.multiple=false;	  
	  obj.options[0]=new Option(t['10'],"3"); //普通住院
	  obj.options[1]=new Option(t['20'],"1"); //家庭建床
	  obj.options[2]=new Option(t['30'],"2"); //急观入院
	  obj.options[3]=new Option(t['40'],"4"); //大病
	  obj.options[4]=new Option(t['50'],"5"); //本院定点
	  obj.selectedIndex=0;
	}
	//卡类型
	obj=document.getElementById("CardType")
	if (obj){
	  obj.size=1; 
	  obj.multiple=false;	  
	  obj.options[0]=new Option(t['CType10'],"10");
	  obj.options[1]=new Option(t['CType11'],"11");
	  obj.options[2]=new Option(t['CType12'],"12");
	}
	//保险号
	obj=document.getElementById("InsuNo")
	if (obj){obj.readOnly=true;}
	//卡号
	obj=document.getElementById("cardno")
	if (obj){obj.readOnly=true;}
	obj=document.getElementById("icztmc")
	if (obj){obj.readOnly=true;}	
	obj=document.getElementById("sfzy")
	if (obj){obj.readOnly=true;}
	obj=document.getElementById("EndDate");
	if (obj){obj.disabled=true;}
	
		//病人类型
	obj=document.getElementById("PatType")
	if (obj){
	  obj.size=1; 
	  obj.multiple=false;	  
	  obj.options[0]=new Option(t['PatType01'],"0");
	  obj.options[1]=new Option(t['PatType02'],"1");
	  obj.options[2]=new Option(t['PatType03'],"2");
	}

}

//***********************************
//2:得到病人登记号                     *
//***********************************
function Key(){	
	if (window.event.keyCode==13){
		GetPaAdmNO();
		//getybcardno(); 不取卡号 Lou 2010-02-09
		var obj=document.getElementById("jzh");
		if (obj){obj.focus()};
		
	}
}

///2.1登记号补零
function GetPaAdmNO(){
	var obj=document.getElementById("zyh");
	var ZyhLength=10-obj.value.length;
    var i;   	
	if (obj){
		for (i=0;i<ZyhLength;i++){
			obj.value="0"+obj.value;			
		}
	}	
	var PaMasNO=obj.value;
	zyh=obj.value;	
	var TempPlist;	
	clear();		//清屏		   
	qbrxx();  		//得到病人信息
	
	//得到病人就诊列表
	var obj=document.getElementById("jzh");		
	obj.options.length=0;
	var Ins=document.getElementById('ClassAdmList');
  	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
 	var OutStr=cspRunServerMethod(encmeth,'','',PaMasNO); 		 
	//alert(OutStr)
	if (OutStr==""){
		alert("就诊记录不存在!");
		return;
	}	
	else{
		aData=OutStr.split("^")	     		
		for (i=0;i<aData.length-1;i++){
			if (aData[i]=="") Showtext="";
			else{
				TempPlist=aData[i].split("!")
				Showtext=TempPlist[4]+"  "+TempPlist[0]+"   "+TempPlist[3]
			}
			obj.options[i]=new Option(Showtext,aData[i]) ;
		}
	}				
}

///2.1.1取病人基本信息
function qbrxx(){	
	var PapamasID=zyh	
	var Ins=document.getElementById('ClassBrxx');
  	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
 	var OutStr=cspRunServerMethod(encmeth,'','',PapamasID); 
 	//alert(OutStr)
 	if ((OutStr=="")||(OutStr=="-100")) {
	 	qp();
	 	return false;
 	}
    aData=OutStr.split("^");
    var obj=document.getElementById("xming0")  //姓名
    if (obj) {obj.value=aData[2];}
    var obj=document.getElementById("xbie00")  //性别
    if (obj) {obj.value=aData[4];}
    var obj=document.getElementById("brnl00")  //年龄
    if (obj) {obj.value=aData[3];}
    var obj=document.getElementById("id0000")  //身份证号
    if (obj) {obj.value=aData[8];}
    bData=OutStr.split("!");
    cData=bData[1].split("^");
    PatientID=cData[0];

	return true;
}

//********************************
//3:选择病人就诊记录                *
//******************************** 
 function selejzh(){	
	clear();
	//alert("选择病人就诊记录");
	if (sfdj()==true){
		
		GetPaAdmInfo();
		//getybcardno(); 不取卡号 Lou 2010-02-09
	}		
    else {return true;}
 }

//3.1判断是否登记
function sfdj(){
	var TemArry;
	var obj=document.getElementById("jzh");	
	TemArry=obj[obj.selectedIndex].value;
    if (TemArry==""){
	    alert("请选择就诊记录!");
	    return false;
    }
    jzh=TemArry;
    GetPaAdmInfo();
    TempBl=TemArry.split("!");
	var PaadmRowId=TempBl[1];
	AdmDr="";
	AdmDr=PaadmRowId ;///就诊号
	var Ins=document.getElementById('Classjzxx');
  	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
 	var OutStr=cspRunServerMethod(encmeth,'','',PaadmRowId);
 	//alert(PaadmRowId);
 	//alert("医保信息"+OutStr)
 	Tary=OutStr.split("!"); 	 
    if (Tary[0]!=1){ return true;}  	    //判断返回值
    else {
	    var aData=Tary[1].split("^");		
		//var Cardinfo=aData[2].split("||")   //卡信息
		//在院状态
		obj=document.getElementById("sfzy");		
		if (aData[11]=="A"){
			obj.value="在院";
			obj=document.getElementById("qxdj");
			obj.disabled=false;
			qxdjkz=1;
		}
		if (aData[11]=="O"){
			obj=document.getElementById("sfzy");
			obj.value="已出院";
			//return false;
		}
		if (aData[11]=="S"){
			obj=document.getElementById("sfzy");
			obj.value="已作废";
 	        var obj=document.getElementById("qxdj");
	        if (obj) {obj.disabled=true;}
		}
		
		if (aData[11]=="A"){
			var obj=document.getElementById("ybdj");
	        if (obj) {obj.disabled=true;}
		}
			
		obj=document.getElementById("ryrq00");
		if (obj){			
			if (aData[12]!=""){obj.value=aData[12];}
		}
		obj=document.getElementById("rysj00");
		if (obj){			
			if (aData[13]!=""){obj.value=aData[13];}
		}
		obj=document.getElementById("ryksmc");
		if (obj){			
			//if (aData[15]!=""){obj.value=aData[15];}
		}
        //如果是取消的登记信息,则不填医保相关信息
		if (aData[11]=="I"){
			var obj=document.getElementById("ybdj");
	        if (obj) {obj.disabled=false;}
			return false;}
		
		//保险号
		obj=document.getElementById("InsuNo")
		if (obj){			
			if (aData[2]!=""){obj.value=aData[2];}
		}
        //身份证号
		obj=document.getElementById("id0000")
		if (obj){			
			if (aData[29]!=""){obj.value=aData[29];}
		}
		//卡号
		obj=document.getElementById("cardno");
		if (obj){			
			if (aData[3]!=""){obj.value=aData[3];}
		}		
		
	    //登记日期
		var obj=document.getElementById("BegDate");
		if (obj){
			var aDate=aData[26].split("-");
			obj.value=aDate[2]+"/"+aDate[1]+"/"+aDate[0];
		}
		//家床起付日期
		var obj=document.getElementById("BegFeeDate");
		if (obj){
			var aDate=aData[27].split("-");
			obj.value=aDate[2]+"/"+aDate[1]+"/"+aDate[0];
		}		
		//入院类别
		obj=document.getElementById("rylb00")
		if (obj){
			for (j=0;j<=obj.options.length-1;j++){
				if (obj.options[j].value==aData[14]){
					obj.selectedIndex=j
				}
		 	}
		}					
	    //帐户状态 0?未冻结 1?冻结
		obj=document.getElementById("icztmc");
		if (obj){
			if (aData[5]==1){obj.value="冻结";}
			else {obj.value="未冻结";}
		}	
		
			
    }    
}

///得到病人就诊记录
function GetPaAdmInfo(){
	var TemArry,TmpList
	var obj
	TemArry=jzh
	if (TemArry==""){
		clear();
		alert("选择就诊信息!");
		return false;
	}
	TempBl=TemArry.split("!");
	var PaadmRowId=TempBl[1];  //adm
	
	var Ins=document.getElementById('ClassBrjzxx');
  	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
 	var OutStr=cspRunServerMethod(encmeth,'','',PaadmRowId); 	
    //alert(OutStr)
    TmpList=OutStr.split("!");
    if (TmpList[0]=="-1"){
	    clear();	    
	    return false ;	    
	}
	else{
		aData=TmpList[1].split("^");
		obj=document.getElementById("ryrq00")
    	if (obj) {obj.value=aData[5];}
    	obj=document.getElementById("rysj00")
    	if (obj) {obj.value=aData[6];}
    	obj=document.getElementById("AdmReasonDesc")
    	if (obj) {obj.value=aData[28];}
    	
    	//Lou 2010-02-28
    	var AdmReasonStr=TmpList[1].split("=")[5]
    	obj=document.getElementById("AdmReasonDr")
    	if (obj) {obj.value=aData[27];}
    	obj=document.getElementById("AdmReasonNationalCode")
    	if (obj) {obj.value=AdmReasonStr.split("^")[5];}
        
        if(obj.value==t['INSUTYPE01'])
       	{
	        InsuType="NBB";	
	    }
       	if(obj.value==t['INSUTYPE02'])
       	{
	        InsuType="NBA";	
	    }
	    if(obj.value==t['INSUTYPE03'])
       	{
	        InsuType="NBC";	
	    }
	    if(obj.value==t['INSUTYPE04'])
       	{
	        InsuType="NBD";	
	    }	    
       	obj=document.getElementById("ryksmc")
    	if (obj) {	  
	    	var Tempryksmc=aData[4]
	    	var temp=Tempryksmc.split("-")
	    	if (temp[1]) obj.value=temp[1]
	    	else obj.value=temp[0]
	    	}
	    //Lou 2010-02-25
	    document.getElementById("HisLocCode").value=aData[3]
	}
}

//*******************************
//医保登记				        *
//*******************************
function ybdj(){	
	//if (ybdjkz!=1){return false;} 
	var TempString="",rylb00="",CardInfo=""
	var StDate="",EndDate=""
	
	obj=document.getElementById("ybdj")
	if (obj.disabled==true){return false;}

	var obj=document.getElementById("rylb00")
	if (obj) {
		if ((obj.value=="TB")&&(spcDiagCode=="")) {
			alert(t['INSUMSG01']);
			return false
		}
		rylb00=obj.value
	}
	
	var obj=document.getElementById("rylb00")
	if (obj) {
		if (obj.value=="") {
			alert("类别不能空");
			return false
		}
		rylb00=obj.value
	}	
	
	//起始日期
	var obj=document.getElementById("StDate")
	if (obj) {StDate=obj.value}
	
	//结束日期(只有家床需要)
	var obj=document.getElementById("EndDate")
	if (obj) {EndDate=obj.value}
	
	//卡号
	var obj=document.getElementById("INSUCARDID")
	if (obj) {CardInfo=obj.value}
	
	HisLocCode=document.getElementById("HisLocCode").value
	/*var Ins=document.getElementById('GetBasDicInfo');
  	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
 	var LocCodeStr=cspRunServerMethod(encmeth,'30',HisLocCode);
 	if (LocCodeStr=="-1"){
 		alert("请作科室对照!");
 		return false;
 		}
 	var TmpLoc=LocCodeStr.split("^")
 	LocCode=TmpLoc[5]  Lou 注释,放到.net程序里取2010-03-11*/
	
	if (StDate!=""){
	//格式化日期
	var aData=StDate.split("/");
	StDate=aData[2]+"-"+aData[1]+"-"+aData[0];
	}
	if (EndDate!=""){
	var aData=EndDate.split("/");
	EndDate=aData[2]+"-"+aData[1]+"-"+aData[0];
	}
	var PatType=document.getElementById("PatType").value
	
	//TempString=rylb00+"^"+StDate+"^"+BegFeeDate+"^"+Guser+"^"+spcDiagCode		
	TempString=rylb00+"^"+PatType+"^"+CardInfo+"^"+StDate+"^"+EndDate
	    	
	var AdmReasonDr=document.getElementById("AdmReasonDr").value
    
    var AdmReasonNationalCode=document.getElementById("AdmReasonNationalCode").value
    
	//登记
	flag=InsuIPReg(0,AdmDr,Guser,AdmReasonNationalCode, AdmReasonDr,TempString)//DHCInsuPort.js
		
	//if (flag!=true) {return false;}
	if (flag<0)  {return false;}	
    ybdjkz=0;
	qxdjkz=1;
	var obj=document.getElementById("ybdj")
	if (obj) {obj.disabled=true;}
 	var obj=document.getElementById("qxdj");
	if (obj) {obj.disabled=false;}
    //登记成功后清屏
    qp();
    obj=document.getElementById("zyh");
	if (obj){obj.focus();} 
	window.status="登记成功!";	
}

//取消登记
function qxdj(){

	obj=document.getElementById("qxdj")
	if (obj.disabled==true){return false;}
			
	if (qxdjkz!=1){return false;}
	var CardInfo=""
	//检测病人是否有费用不检测费用发生取消登记
	//if (jcbrfy()!=true){
	//	alert("病人已经发生费用?不允许取消登记!")
	//	return false;
	//}	
	
	//卡信息
	var obj=document.getElementById("INSUCARDID")
	if (obj) {
		CardInfo=obj.value
	}
	ExpStr=CardInfo
	
	var AdmReasonDr=document.getElementById("AdmReasonDr").value
    
    var AdmReasonNationalCode=document.getElementById("AdmReasonNationalCode").value

	//登记取消
	flag=InsuIPRegStrike(0,AdmDr,Guser, AdmReasonNationalCode, AdmReasonDr,ExpStr) //DHCInsuPort.js
	
    /*//调dll实现撤销医保登记
	if(InsuType=="NBB"){
		var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.clsBasBILLNBBFacade");  ///BasPatientBill
	}
	if(InsuType=="NBA"){
		//Lou 2009-04-26
		//var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.clsBasBILLNBAFacade");  ///BasPatientBill
		var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.clsBasBILLNBEFacade");  ///BasPatientBill
	}
	if(InsuType=="NBC"){
		var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.clsBasBILLNBCFacade");  ///BasPatientBill
	}
	if(InsuType=="NBD"){
		var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.clsBasBILLNBDFacade");  ///BasPatientBill
	}
	
	flag=DHCINSUBLL.IPRegCancle(AdmDr,"");*/
	if (flag<0) {return;}
	alert(flag)
	var obj=document.getElementById("qxdj");
	if (obj) {obj.disabled=true;}
	qxdjkz=0;
	ybdjkz=0;
	//清空界面信息
	selejzh();
    window.status="登记撤销完毕!";	
}

///判断病人是否存在费用
function jcbrfy(){
	var TemArry;
    TemArry=jzh;
    if (TemArry==""){
	    alert("请选择就诊记录!");
	    return false;
    }
    TempBl=TemArry.split("!");
	var PaadmRowId=TempBl[1];
	var guser=session["LOGON.USERID"];
	var Ins=document.getElementById('ClassCheck');
  	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
 	var Temp=cspRunServerMethod(encmeth,'','',PaadmRowId,guser);
    if (Temp!=0){
	    return false;
    }    
    return true;
}

function qp(){
	var obj		
	obj=document.getElementById("zyh");
	if (obj){
		obj.value="";
		zyh="";
	}
	obj=document.getElementById("jzh");
	if (obj){
		obj.length=0;
		jzh=""
	}
	obj=document.getElementById("xming0")
	if (obj){obj.value="";}
	obj=document.getElementById("xbie00")
	if (obj){obj.value="";}
	obj=document.getElementById("brnl00")
	if (obj){obj.value="";}
	obj=document.getElementById("id0000")
	if (obj){obj.value="";}
	obj=document.getElementById("ryrq00")
	if (obj){obj.value="";}
	obj=document.getElementById("rysj00")
	if (obj){obj.value="";}
	obj=document.getElementById("ryksmc")
	if (obj){obj.value="";}
	//obj=document.getElementById("rylb00")
	//if (obj){obj.value="";}
	obj=document.getElementById("INSUCARDID")
	if (obj){obj.value="";}
	obj=document.getElementById("ybdj")
	if (obj) {obj.disabled=false;}
    clear();
}
function clear(){
	var obj
	//obj=document.getElementById("CardType")
	//if (obj) {obj.value=""}		
	//obj=document.getElementById("CardInfo")
	//if (obj) {obj.value=""}	
	obj=document.getElementById("BegDate")
	if (obj) {obj.value=""}
	obj=document.getElementById("BegFeeDate")
	if (obj){obj.value=""}	
	obj=document.getElementById("ryrq00")
	if (obj){obj.value="";}
	obj=document.getElementById("rysj00")
	if (obj){obj.value="";}
	obj=document.getElementById("ryksmc")
	if (obj){obj.value="";}	
	//obj=document.getElementById("rylb00")
	//if (obj){obj.value="";}
	obj=document.getElementById("InsuNo")
	if (obj){obj.value="";}
	obj=document.getElementById("cardno")
	if (obj){obj.value="";}
	obj=document.getElementById("icztmc")
	if (obj){obj.value="";}
	obj=document.getElementById("gzztmc")
	if (obj){obj.value="";}
	obj=document.getElementById("sfzy")
	if (obj){obj.value="";}
	//obj=document.getElementById("INSUCARDID")
	//if (obj){obj.value="";}
	obj=document.getElementById("AdmReasonDesc")
	if (obj){obj.value="";}
    //obj=document.getElementById("ybdj")
   // if (obj) {obj.disabled=true;}
    obj=document.getElementById("qxdj")
    if (obj) {obj.disabled=true;}
	
	document.getElementById("ICD").value="";
	document.getElementById("SpcDiag").value="";
	document.getElementById("StDate").value="";
	document.getElementById("EndDate").value="";
	document.getElementById("HosName").value="";
	
		ybdjkz=0;
	qxdjkz=0;
	
}

//****************************************************************
// Description: sInputString 为输入字符串?iType为类型?分别为
// 0 - 去除前后空格; 1 - 去前导空格; 2 - 去尾部空格
//****************************************************************
function cTrim(sInputString,iType)
{
  var sTmpStr = ' '
  var i = -1

  if(iType == 0 || iType == 1)
  {
     while(sTmpStr == ' ')
     {
       ++i
       sTmpStr = sInputString.substr(i,1)
     }
     sInputString = sInputString.substring(i)
  }

  if(iType == 0 || iType == 2)
  {
    sTmpStr = ' '
    i = sInputString.length
    while(sTmpStr == ' ')
    {
       --i
       sTmpStr = sInputString.substr(i,1)
    }
    sInputString = sInputString.substring(0,i+1)
  }
  return sInputString
}
function test(){
	//var obj=document.getElementById("rylb00");
	//var index=obj.selectedIndex
	//var rylb=obj.options[index].text
    //alert(rylb);
    var x1=51,x2=10
    var x3=x1%x2
    alert(x3)
	}
function DelFile(FileName){
	var fs = new ActiveXObject("Scripting.FileSystemObject");
	///alert(FileName+"//////"+fs.FileExists(FileName));
	if (fs.FileExists(FileName)){
		    var x=fs.DeleteFile(FileName,false);
		}
	
		
	}
//根据医保卡数据得到患者信息
//zmgzt 	
function getybcardno(){
	var papstr=""
	var PatientID,patidobj
	patidobj=document.getElementById("PatientID");
	PatientID=patidobj.value;
	var obj=document.getElementById("getcardno");
	if (obj) {var encmeth=obj.value} else {var encmeth=''};
	papstr=cspRunServerMethod(encmeth,'','',PatientID);
	if (papstr!=""){
	   var papstr1=papstr.split("^");
	   if (papstr1[0]!="0"){
		   var obj=document.getElementById("ybcardno");
		   obj.value=papstr1[1];
		   //obj.readOnly=true
		   }
	   }
}	

//insert by cx 2006.06.01 
function ybcardnoEnter(e) {
	var key = websys_getKey(e);
	var obj = websys_getSrcElement(e);
	var papstr=""
	//var ybcardno
	if ((obj)&&(obj.value!="")&&(key==13)) {
		Query_Click() //Lou 2010-02
		return;
		var cardnoobj=document.getElementById("INSUCARDID");
		var cardno=cardnoobj.value;
		//zmgzt
		var myrtn=DHCACC_GetPAPMINo(cardno);
		var myary=myrtn.split("^");
		if ((myary[0]=="-201")||( myary[0]=="0")){
			var myPAPMNo=myary[1];
			var obj=document.getElementById("zyh");
		     obj.value=myPAPMNo;
		     //regnoobj.value=myPAPMNo;
		GetPaAdmNO();
		var obj=document.getElementById("jzh");
		if (obj){obj.focus()}
		
		}else{
			cardnoobj.value="";
			alert(t['nbmzdhc01']);
		}
    }
}

function getpat() {
	var key=websys_getKey(e);
	if (key==13) {
		if (obj.value!=""){
			p1=obj.value
			var getregno=document.getElementById('getadm');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
				if (cspRunServerMethod(encmeth,'setpat_val','',p1)=='1'){
				};
			
			}
		//	Find_click();
		}
		
	}

//	
function mySelectRow()
{
	var obj=document.getElementById("rylb00");
	//alert (obj[obj.selectedIndex].value)
	
	if (obj[obj.selectedIndex].value=="1")
	{
		obj=document.getElementById("EndDate")
		if (obj){obj.disabled=false;}	
	}
	else
	{
		obj=document.getElementById("EndDate")
		if (obj){obj.disabled=true;}
	}

}

function myFillDateToFeeDate()
{
	var obj=document.getElementById("BegDate")
	var myBegDate=obj.value;
	var obj=document.getElementById("BegFeeDate");
	obj.value=myBegDate;

	}
function SetInsuString(value) {
	var InsuArry=value.split("^")
	var obj=document.getElementById("DicCode")
	if(obj) {
		     obj.value=InsuArry[1];
	         spcDiagCode=obj.value;
	        }	
	//alert("DicCode"+obj.value);
	}

function setSpcCodeValue()
{
	var obj=document.getElementById("DicCode");
	var objSpcDiag=document.getElementById("SpcDiag");
	if (objSpcDiag.value==""){obj.value="";}
	spcDiagCode=objSpcDiag.value;
	//alert("spcDiagCode:"+spcDiagCode);
	//alert(obj.value);
	}
			
function getybcardno(){
	
	var papstr=""
	var obj=document.getElementById("getcardno");
	if (obj) {var encmeth=obj.value} else {var encmeth=''};
	papstr=cspRunServerMethod(encmeth,'','',PatientID);
	if (papstr!=""){
	   var papstr1=papstr.split("^");
	   if (papstr1[0]!="0"){
		   var obj=document.getElementById("INSUCARDID");
		   obj.value=papstr1[1];
		   //obj.readOnly=true
		   }
	   }
	}	

function Query_Click()
{
	var TempString="",rylb00="",CardInfo=""
	var BegDate="",BegFeeDate=""
	var obj=document.getElementById("rylb00")
	if (obj) {
		if (obj.value=="") {
			alert("类别不能空");
			return false
		}
		rylb00=obj.value
		if ((obj.value=="4")&&(spcDiagCode=="")) {
			alert(t['INSUMSG01']);
			return false
		}
	}	

	var obj=document.getElementById("INSUCARDID")
	if (obj) {
		CardInfo=obj.value
	}	
	
	TempString=CardInfo+"^"+rylb00+"^"+spcDiagCode

	var AdmReasonDr=document.getElementById("AdmReasonDr").value	
    var AdmReasonNationalCode=document.getElementById("AdmReasonNationalCode").value
	
	//登记查询
	var rtn=InsuIPRegQuery(Guser,TempString,AdmReasonNationalCode,AdmReasonDr) //DHCINSUPort.js
	//卡类别标志|卡号|姓名|职退情况|保健对象|公务员|特殊待遇标识|封存标志|在职享受退休标志|适用医保办法标志|等待期标识|特殊标识|登记类别|登记号|开始日期|结束日期|诊断编码|大病项目代码|登记医院标志|登记医院名称
	//alert(rtn)
	if (rtn=="-1"){return;}
	var List=rtn.split("|")
	document.getElementById("InsuNo").value=List[1]
	document.getElementById("xming0").value=List[2]
	document.getElementById("rylb00").value=List[12]
	document.getElementById("zyh").value=List[13]
	if (List[14]!=""){
	document.getElementById("StDate").value=List[14].substring(7,8)+"/"+List[14].substring(5,6)+"/"+List[14].substring(0,4);
	}
	if (List[15]!=""){
	document.getElementById("StDate").value=List[15].substring(7,8)+"/"+List[15].substring(5,6)+"/"+List[15].substring(0,4);
	}
	document.getElementById("ICD").value=List[16]
	if (List[17]!=""){
	document.getElementById("SpcDiag").value=List[17];
	}
	if (List[18]!=""){document.getElementById("sfzy").value="在院";}
	if (List[19]!=""){document.getElementById("HosName").value=List[19];}
	var obj=document.getElementById("ybdj");
	if (obj) {obj.disabled=true;}
	var obj=document.getElementById("qxdj");
	if (obj) {obj.disabled=false;}

}

function SetData(){
	var adm=""
	var TemArry,TempBl
	var obj=document.getElementById("adm");
	adm=obj.value

    obj=document.getElementById('jzh');
    if (obj){
	    for (i=1;i<obj.options.length;i++){
		    TemArry=obj.options[i].value
		    if (TemArry==""){
			    alert("请选择就诊记录!");
			    return false;
			}
		    TempBl=TemArry.split("!")
		    if (TempBl[1]==adm){
			    obj.selectedIndex=i;
			}
		}
		selejzh(); //
	}
	
}

document.body.onload = BodyLoadHandler;