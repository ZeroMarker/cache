///医保入院登记或者补登记用
///INSUIPReg.js     ---------------------------

var PapmiNo="",AdmDr="",AdmReasonDr="",AdmReasonNationalCode="",CTProvinceCode="",CTCityCode="",CTAreaCode="";       
var Guser=session['LOGON.USERID'];
var UpCardFlag=false ;// 更新卡标识 DingSH 20160715
var inactFlag="" ; //在院状态 DingSH20160715
var InsuAdmInfoDr="" ;// InsuAdmInfo.rowid DingSH20160715
var OldCardNo ="";
var TemppatType="";
var tDiagDesc="";
function BodyLoadHandler() {
	iniForm();
	var obj=document.getElementById("PapmiNo")
	if (obj)
	{
		PapmiNo=obj.value;
		obj.onchange=Clear;
		obj.onkeydown=PapmiNo_onkeydown;

		if (PapmiNo==""){Clear();}  //Lou 2010-03-05 如果登记号不为空不清屏,如从HIS界面调过来的时候
		else
		{
			window.event.keyCode=13;
			PapmiNo_onkeydown();
			UpCardFlag=true;
		}

	}
		
	var AdmDrobj=document.getElementById("AdmDr");
	if (AdmDrobj) {
		if (AdmDrobj.value!="")
		{
			AdmDr=AdmDrobj.value
			var objPaadmList=document.getElementById("PaadmList");
			for (i=0;i<objPaadmList.options.length;i++)
				{
						if (objPaadmList.options[i].value.split("^")[0]==AdmDr) 
						{	
						objPaadmList.selectedIndex=i
						SetPaadmInsuAdm();
						}
				}
			}
		}     
		
	//选择就诊号
	var obj=document.getElementById("PaadmList")
	if (obj){obj.onchange=PaadmList_onchange;}	
	
	//
	var obj=document.getElementById("InsuType")
	if (obj){obj.onchange=InsuType_onchange;}

	//医保登记
	var obj=document.getElementById("InsuIPReg");
	if (obj){ obj.onclick=InsuIPReg_onclick;}	
	//取消登记
	var obj=document.getElementById("InsuIPRegCancel");
	if (obj) {obj.onclick=InsuIPRegCancel_onclick;}
	//读卡
	var obj=document.getElementById("InsuReadCard");
	if (obj) {obj.onclick=InsuReadCard_onclick;}
	//医保诊断描述回车事件
	var obj=document.getElementById("InsuInDiagDesc")
	if (obj){
		obj.onkeydown=InsuInDiagDesconkeydown;
	}
	//更新医保保卡号 20140917 DingSH
	var obj=document.getElementById("btnUpdINSUCardNo");
	if (obj){ obj.onclick=UpdINSUCardNo_onclick;}
	//清屏
	var obj=document.getElementById("Clear");	
	if (obj) {obj.onclick=Clear_onclick;}
	
   //诊断记录 2015-12-16
  var obj=document.getElementById("AdmDiagLst");	
  if (obj) {	
        obj.size=1; 
	  	obj.multiple=false;
	     obj.onchange=AdmDiagLst_onchange;
  }
	//ZLFS_onchange
	///var obj=document.getElementById("ZLFS")
	//if (obj){obj.onclick=ZLFS_onclick;}
	//医保保卡号获得焦点事件 20160715 DingSH
	var obj=document.getElementById("CardNo");
	if (obj){ obj.onfocus=CardNo_onfocus;}
    //医保保卡号失去焦点事件 20160715 DingSH
	var obj=document.getElementById("CardNo");
	if (obj){ obj.onblur=CardNo_onblur;}
}


	
//*******************************
//1:初始化界面                    *
//*******************************
function iniForm(){
	obj=document.getElementById("PaadmList");
	if (obj){
	  obj.size=1; 
	  obj.multiple=false;	
	}
	obj=document.getElementById("Name")
    if (obj){obj.disabled=true;}
	obj=document.getElementById("Sex")
	if (obj){obj.readOnly=true;}
	obj=document.getElementById("Age")
	if (obj){obj.readOnly=true;}
	obj=document.getElementById("AdmReasonDesc")
	if (obj){obj.readOnly=true;}
	obj=document.getElementById("PatID") //身份证件号
	if (obj){obj.readOnly=true;}
	//obj=document.getElementById("AdmDate") 
	//if (obj){obj.readOnly=true;} //入院日期 2015-12-16  DingSH 允许修改
	//if (obj){obj.onblur=AdmDate_Checked;}	
	obj=document.getElementById("AdmDate") 
	if (obj){obj.onblur=AdmDate_Checked;}	
	obj=document.getElementById("AdmTime") 
	if (obj){obj.onblur=AdmTime_Checked;}	
	//if (obj){obj.readOnly=true;} //入院时间 2015-12-16  DingSH 允许修改
	
	obj=document.getElementById("AdmDate") 
	if (obj){obj.onclick=AdmDate_CheckDisabled;}
	obj=document.getElementById("AdmTime") 
	if (obj){obj.onclick=AdmTime_CheckDisabled;}
	
	obj=document.getElementById("DepDesc")
	if (obj){obj.readOnly=true;}
	//入院类别
	obj=document.getElementById("InsuAdmType")
	if (obj){
	  obj.size=1; 
	  obj.multiple=false;	  
	}
	var VerStr="";
	VerStr=tkMakeServerCall("web.INSUDicDataCom","GetSys","","","DLLType");
	if (VerStr=="") {alert("请在医保字典中维护DLLType");return;}
	var Arr1=VerStr.split("!")
	obj=document.getElementById("InsuType")
	if (obj){
	  //obj.disabled=true       //如果His住院登记界面修改收费类别，收费类别框置灰
	  obj.size=1; 
	  obj.multiple=false;
	  //obj.options[0]=new Option("自费","");
	  for (var i=1;i<Arr1.length;i++){
		obj.options[i]=new Option(Arr1[i].split("^")[3],Arr1[i].split("^")[2]);			
		}	  
	}
	obj=document.getElementById("ZLFS")
	if (obj){
	  //obj.disabled=true
	  obj.size=1; 
	  obj.multiple=false;	  
	}
	obj=document.getElementById("BCFS")
	if (obj){
	  //obj.disabled=true
	  obj.size=1; 
	  obj.multiple=false;	  
	}
	obj=document.getElementById("InsuInDiagCode")
	if (obj){obj.readOnly=true;}
	//保险号
	obj=document.getElementById("InsuNo")
	if (obj){obj.readOnly=true;}
	//卡号
	obj=document.getElementById("CardNo")
	//if (obj){obj.readOnly=true;}
	
	///旧卡号
	obj=document.getElementById("OldCardNo")
	if (obj){obj.readOnly=true;}
	
	obj=document.getElementById("InsuCardStatus")
	if (obj){obj.readOnly=true;}	
	obj=document.getElementById("InsuActiveFlag")
	if (obj){obj.readOnly=true;}	

}

function InsuInDiagDesconkeydown(){	
	if (window.event.keyCode==13)
	{
		window.event.keyCode=117;
		InsuInDiagDesc_lookuphandler();	
	}
}
//***********************************
//2:得到病人登记号                     *
//***********************************
function PapmiNo_onkeydown(){	
	if (window.event.keyCode==13){
		var rshflag=""
		var ReshFlagobj=document.getElementById("ReshFlag");
		if (ReshFlagobj){rshflag=ReshFlagobj.value}
		if(3==rshflag){
			ReshFlagobj.value=true;
			return;
		}
		Clear();	
		var flag=GetPatInfo();
		if (flag==false) {return;}
		if(false==GetPaadmList()){
			location.href="websys.default.csp?WEBSYS.TCOMPONENT=INSUIPReg&AdmDr="+"&PapmiNo="+PapmiNo+"&ReshFlag="+3+"&PadmListIndexed"+0;		
			return;
		}
		var PaadmListobj=document.getElementById("PaadmList");   
		if (PaadmListobj){PaadmListobj.focus()}; 
		var PadmListIndexed=1
		var obj=document.getElementById("PadmListIndexed");
		if (obj){PadmListIndexed=obj.value}
		if ((PadmListIndexed=="")||(undefined==PadmListIndexed)){PadmListIndexed=1}
	    PaadmListobj.selectedIndex=PadmListIndexed
		var tFlag=SetPaadmInsuAdm();
		if ((tFlag==true)&&(rshflag!="false"))
		{
			  //alert("rshflag="+rshflag+",PadmListIndexed="+PadmListIndexed)
	          location.href="websys.default.csp?WEBSYS.TCOMPONENT=INSUIPReg&AdmDr="+AdmDr+"&PapmiNo="+PapmiNo+"&ReshFlag="+false+"&PadmListIndexed"+PadmListIndexed;		
		}              
	}
		UpCardFlag=true;
}

///2.1.1取病人基本信息
function GetPatInfo(){	
	var obj=document.getElementById("PapmiNo");    
	if (obj){
		if (obj.value=="")
		{alert("登记号不能为空");
		obj.focus();
		return false;
		}
	}
	var PapmiNoLength=10-obj.value.length;     //登记号补零   	
	if (obj){
		for (var i=0;i<PapmiNoLength;i++){
			obj.value="0"+obj.value;			
		}
	}
	PapmiNo=obj.value;	
		
	var Ins=document.getElementById('ClassGetPatInfo');
  	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
 	var OutStr=cspRunServerMethod(encmeth,'','',PapmiNo); 
 	if (OutStr.split("!")[0]!="1") {
	 	alert("取病人基本信息失败,请输入正确的登记号!")
	 	Clear();
	 	return false;
 	}
    aData=OutStr.split("^");
    //alert(aData)
    var obj=document.getElementById("Name")  //姓名
    if (obj) {obj.value=aData[2];}
    var obj=document.getElementById("Sex")  //性别
    if (obj) {obj.value=aData[4];}
    var obj=document.getElementById("Age")  //年龄
    if (obj) {obj.value=aData[3];}		
    var obj=document.getElementById("PatID")  //年龄
    if (obj) {obj.value=aData[8];}
    var obj=document.getElementById("CTProvinceName")  //省
    if (obj) {obj.value=aData[16];}
    var obj=document.getElementById("CTCityName")  //市
    if (obj) {obj.value=aData[18];}
    var obj=document.getElementById("CTAreaName")  //区
    if (obj) {obj.value=aData[20];}
    CTProvinceCode=aData[15];
    CTCityCode=aData[17];
    CTAreaCode=aData[19];
	return true;
}

///根据登记号查询就诊纪录
function GetPaadmList(){
	var objPaadmList=document.getElementById("PaadmList");		
	if (objPaadmList) {objPaadmList.options.length=0;}
	var Ins=document.getElementById('ClassGetPaadmList');
  	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
 	var OutStr=cspRunServerMethod(encmeth,'','',PapmiNo); 	 
	if (OutStr==""){
		alert("没有查询到病人就诊记录,请先确认患者是否护士分床!");
		return false;
	}	
	else
	{
		var Arr1=OutStr.split("!")
		var obj=document.getElementById("AdmDr");		
		if (obj) 
		{
			/*
			if (obj.value!="")   //AdmDr传进来，只添加这条就诊记录
			{                   
				for (i=0;i<Arr1.length;i++)
				{
						Arr2=Arr1[i].split("^")
						if (Arr2[0]==obj.value) 
						{	
						Showtext=Arr2[1]+"  "+Arr2[4]+"   "+Arr2[5];
						objPaadmList.options[0]=new Option(Showtext,Arr1[i]) ;
						PaadmList_onchange();
						}
				}
			}
			*/	
			//else                             //AdmDr没有传进来，添加所有就诊记录
			//{                                 
				for (i=0;i<Arr1.length;i++)
				{
					if (Arr1[i]=="") 
					{
						Showtext="";
					}
					else
					{
						Arr2=Arr1[i].split("^")
						var VisitStatus=""
						if (Arr2[11]=="A"){VisitStatus="在院"}
						if (Arr2[11]=="D"){VisitStatus="出院"}
						if (Arr2[11]=="C"){VisitStatus="退院"}
						Showtext=Arr2[1]+"  "+Arr2[4]+"  "+Arr2[5]+"  "+VisitStatus+"      "+"AdmReasonDr:"+Arr2[27]+"   "+"PaadmRowid:"+Arr2[0]
					}
					objPaadmList.options[i]=new Option(Showtext,Arr1[i]) ;
				}	
			//}
				
		}
	}
	return true;				
}


//********************************
//3:选择病人就诊记录                *
//******************************** 
 function PaadmList_onchange(){	
    var ReshFlag=false,PadmListIndexed="1"
     var obj=document.getElementById("PaadmList");
	 if (obj) { PadmListIndexed=obj.selectedIndex}
	 
    var obj=document.getElementById("PadmListIndexed");
	if (obj) {obj.value=PadmListIndexed}
	 var Flag=SetPaadmInsuAdm()
	  //alert("PadmListIndexed="+PadmListIndexed)
	  if ((Flag==true)) {
		  location.href="websys.default.csp?WEBSYS.TCOMPONENT=INSUIPReg&AdmDr="+AdmDr+"&PapmiNo="+PapmiNo+"&ReshFlag="+ReshFlag+"&PadmListIndexed="+PadmListIndexed;
	  }
 }

function SetPaadmInsuAdm(){
	var obj=document.getElementById("PaadmList");	
	var i=obj.selectedIndex
	var PaadmList=obj[i].value;
    if (PaadmList==""){
	    //alert("请选择就诊记录!");
	    var obj=document.getElementById("AdmDr");
		if (obj) {obj.value=""}
		AdmDr=""
	    ClearPaadmInfo();
	    ClearInsuAdmInfo();
	    return true;
    }
 
    var Arr1=PaadmList.split("^");
	var obj=document.getElementById("AdmDate");
	if (obj) {obj.value=Arr1[5]}
	var obj=document.getElementById("AdmTime");
	if (obj) {obj.value=Arr1[6]}
	var obj=document.getElementById("InDiagCode");
	if (obj) {obj.value=Arr1[21]}
	var obj=document.getElementById("InDiagDesc");
	if (obj) {obj.value=Arr1[22]}
	//var obj=document.getElementById("InsuType");
	//if (obj) {obj.value=Arr1[28]}
	var obj=document.getElementById("DepDesc");
	if (obj) {obj.value=Arr1[4]}
	var obj=document.getElementById("AdmReasonDesc");
	if (obj) {obj.value=Arr1[28]}
	
	AdmDr=Arr1[0] ;         ///就诊号
	AdmReasonDr=Arr1[27]
	 var obj=document.getElementById("AdmDr");
	 if (obj) {obj.value=AdmDr}
	//2015-12-16 DingSH,His就诊记录是退院状态不允许登记等操作
	if (Arr1[11]=="C")  
	{
		alert("就诊科室：" +Arr1[4]+"，就诊日期："+Arr1[5]+" "+Arr1[6]+ "为退院状态，不允许登记等操作");
		var obj=document.getElementById("InsuIPRegCancel");
	    if (obj) {obj.disabled=true;}
	    var obj=document.getElementById("InsuIPReg");
	    if (obj) {obj.disabled=true;}
	}
	//2015-12-16 DingSH,His诊断记录
    var obj=document.getElementById('ClassAdmDiagLstInfo');
  	if (obj) {var encmeth=obj.value} else {var encmeth=''};
 	var OutStr=cspRunServerMethod(encmeth,AdmDr,''); 
 	//alert("OutStr="+OutStr);
    if (OutStr!="")
	 { 
		obj=document.getElementById("AdmDiagLst")
		if (obj){
	  	obj.size=1; 
	  	obj.multiple=false;
	  	var j=1
	  	var OutAry=OutStr.split("$")
	  	for (var i=0;i<OutAry.length;i++)
	  	{
		  	    var shwDiagDesc=OutAry[i].split("^")[3]
		  	    var IsICD=""
		  	    if(shwDiagDesc==""){shwDiagDesc=OutAry[i].split("^")[4];IsICD="(非标准诊断)"} 
				obj.options[j]=new Option(OutAry[i].split("^")[2]+ " "+ shwDiagDesc + " "+ OutAry[i].split("^")[5]+" "+IsICD,OutAry[i]);
				if (OutAry[i].split("^")[5]=="入院诊断")	{obj.selectedIndex=j}      //取默认值 
				j=j+1;
		  					
			}	  
		}
	 
	 }
	 
	
	
	var AdmReasonInfo=PaadmList.split("=")[5]
	AdmReasonNationalCode=AdmReasonInfo.split("^")[5]
	var VerStr="";
	VerStr=tkMakeServerCall("web.INSUDicDataCom","QueryByCode","AdmReasonDrToDLLType",AdmReasonDr);
	if (VerStr!="") {
		var InsuType=VerStr.split("^")[5]
		obj=document.getElementById("InsuType")
		if (obj){
			for (var i=0;i<=obj.options.length-1;i++){
				if (obj.options[i].value==InsuType){
					obj.selectedIndex=i
				}
		 	}
		}
		var VerStr="";
	
		var newDicType="AKA130"+InsuType    //拼医疗类别的DicType
		VerStr=tkMakeServerCall("web.INSUDicDataCom","GetSys","","",newDicType);
		if (VerStr=="") {alert("请在医保字典中维护"+newDicType);return;}
		var Arr1=VerStr.split("!")
		obj=document.getElementById("InsuAdmType")
		if (obj){
	  	obj.size=1; 
	  	obj.multiple=false;
	  	var j=1
	  	for (var i=1;i<Arr1.length;i++){
		  	if (Arr1[i].split("^")[8]=="IP") 
		  		{
				obj.options[j]=new Option(Arr1[i].split("^")[3],Arr1[i].split("^")[2]);
				if (Arr1[i].split("^")[9]=="Y")	{obj.selectedIndex=j}      //取默认值 
				j=j+1;
		  		}			
			}	  
		}
		
		
		ZLFS_ini(); //治疗方式 20160830 DingSH
		BCFS_ini(); //补偿方式 20160830 DingSH
		
		
	}
	else{
		obj=document.getElementById("InsuType")
		if (obj) {obj.selectedIndex=0;}
		obj=document.getElementById("InsuAdmType")
		if (obj) {obj.selectedIndex=0;}
		obj=document.getElementById("ZLFS")
		if (obj) {obj.selectedIndex=0;}
		obj=document.getElementById("BCFS")
		if (obj) {obj.selectedIndex=0;}
		
		}	
		
		
		
		
	var obj=document.getElementById('ClassGetInsuAdmInfo');
  	if (obj) {var encmeth=obj.value} else {var encmeth=''};
 	var OutStr=cspRunServerMethod(encmeth,'','',AdmDr); 
 	//alert(OutStr)
	DisBtn(document.getElementById('btnUpdINSUCardNo'))
    if (OutStr.split("!")[0]!=1){ 
    	//保险号
		obj=document.getElementById("InsuNo")
		if (obj){obj.value="";}
		//卡号
		obj=document.getElementById("CardNo");
		if (obj){obj.value="";}
		//人员类别
		obj=document.getElementById("InsuPatType")
		if (obj){obj.value=""}					
	    //帐户状态
		obj=document.getElementById("InsuCardStatus");
		if (obj){obj.value=""}	
		//医保入院诊断编码
		obj=document.getElementById("InsuInDiagCode");
		if (obj){obj.value="";}
		//医保入院诊断名称
		obj=document.getElementById("InsuInDiagDesc");
		if (obj){obj.value="";}
		obj=document.getElementById("InsuActiveFlag");
		obj.value="未登记";
 	    var obj=document.getElementById("InsuIPRegCancel");
	    if (obj) {obj.disabled=true;}
	    var obj=document.getElementById("InsuIPReg");
	    if (obj) {obj.disabled=false;}
    	return true;}  	   
    else {
		
	      Arr2=OutStr.split("!")[1].split("^")
		  InsuAdmInfoDr=Arr2[0];
		  inactFlag=Arr2[11];	
		  obj=document.getElementById("InsuActiveFlag");	
		if (Arr2[11]=="A"){
			obj.value="已登记";
			obj=document.getElementById("InsuIPRegCancel");
			if (obj) {obj.disabled=false;}
			var obj=document.getElementById("InsuIPReg");
	        if (obj) {obj.disabled=true;}
	        ActBtn(document.getElementById('btnUpdINSUCardNo'))
		}
		if (Arr2[11]=="O"){
			obj=document.getElementById("InsuActiveFlag");
			obj.value="出院";
			obj=document.getElementById("InsuIPRegCancel");
			if (obj) {obj.disabled=false;}
			var obj=document.getElementById("InsuIPReg");
	        if (obj) {obj.disabled=true;}
		}
		if (Arr2[11]=="S"){
			obj=document.getElementById("InsuActiveFlag");
			obj.value="取消登记";
 	        var obj=document.getElementById("InsuIPRegCancel");
	        if (obj) {obj.disabled=true;}
	        var obj=document.getElementById("InsuIPReg");
	        if (obj) {obj.disabled=false;}
		}
		//保险号
		obj=document.getElementById("InsuNo")
		if (obj){obj.value=Arr2[2];}
		//卡号
		obj=document.getElementById("CardNo");
		if (obj){obj.value=Arr2[3];
		          OldCardNo=Arr2[3]}
		
		//新卡卡号 DingSH 20190905
	    var obj=document.getElementById("NewCardNo");
	    if (obj){obj.value=Arr2[3]} 
		//旧卡号 DingSH 20190905
		obj=document.getElementById("OldCardNo");
		if (obj){
			obj.value=Arr2[39];  
		         
		}
		//医保类型
		obj=document.getElementById("InsuType")
		if (obj){
			for (var i=0;i<=obj.options.length-1;i++){
				if (obj.options[i].value==Arr2[18]){
					obj.selectedIndex=i
				}
		 	}
		}	
	
		//医疗类别
		obj=document.getElementById("InsuAdmType")
		if (obj){
			if(obj.options.length<1){
				var VerStr="";
				var newDicType="AKA130"+Arr2[18]    //拼医疗类别的DicType
				VerStr=tkMakeServerCall("web.INSUDicDataCom","GetSys","","",newDicType);
				if (VerStr=="") {alert("请在医保字典中维护"+newDicType);return;}
				var Arr1=VerStr.split("!")
				obj=document.getElementById("InsuAdmType")
				if (obj){
			  	obj.size=1; 
			  	obj.multiple=false;
			  	var j=1
			  	for (var i=1;i<Arr1.length;i++){
				  	if (Arr1[i].split("^")[8]=="IP"){
						obj.options[j]=new Option(Arr1[i].split("^")[3],Arr1[i].split("^")[2]);
						j=j+1;
				  		}			
					}	  
				}
			
			}	
			for (var i=0;i<=obj.options.length-1;i++){
				if (obj.options[i].value==Arr2[14]){
					obj.selectedIndex=i
				}
		 	}
		}		
		//人员类别
		obj=document.getElementById("InsuPatType")
		if (obj){
			var TempInsuType=Arr2[18]
			var newDicType="AKC021"+TempInsuType       //人员类别 2013 04 08 
			var VerStr="";
			TemppatType=Arr2[4]
			VerStr=tkMakeServerCall("web.INSUDicDataCom","QueryByCode",newDicType,Arr2[4]);
			if (VerStr==""){alert("请在医保字典中维护人员类别"+"系统代码为"+newDicType+",字典代码为"+Arr2[4]);obj.value=""}
			
			else{
				obj.value=VerStr.split("^")[3];}
		}					
	    //帐户状态
		obj=document.getElementById("InsuCardStatus");
		if (obj){
			if (Arr2[5]==1){obj.value="封锁";}
			else {obj.value="正常";}
		}	
		//医保入院诊断编码
		obj=document.getElementById("InsuInDiagCode");
		if (obj){obj.value=Arr2[26];}
		//医保入院诊断名称
		obj=document.getElementById("InsuInDiagDesc");
		if (obj){obj.value=Arr2[27];
		         tDiagDesc=Arr2[27];}
		//险种类型
		obj=document.getElementById("xzlx");
		if (obj){obj.value=Arr2[37];}
		//待遇类别
		obj=document.getElementById("dylb");
		if (obj){obj.value=Arr2[36];}
		
		//2015-12-16 DingSH 修改
		if ((Arr2[11]=="A")||(Arr2[11]=="O"))
		{
		//入院日期
		obj=document.getElementById("AdmDate");
		//if (obj){obj.value=Arr2[12];}
		//入院时间
		obj=document.getElementById("AdmTime");
		if (obj){obj.value=Arr2[13];}
		}
		ZLFS_ini(); //治疗方式 20160830 DingSH
		BCFS_ini(); //补偿方式 20160830 DingSH
		obj=document.getElementById("ZLFS")
		if (obj){
			for (var i=0;i<=obj.options.length-1;i++){
				if (obj.options[i].value==Arr2[38]){
					obj.selectedIndex=i
				}
		 	}
		}	
		obj=document.getElementById("BCFS")
		if (obj){
			for (var i=0;i<=obj.options.length-1;i++){
				if (obj.options[i].value==Arr2[39]){
					obj.selectedIndex=i
				}
		 	}
		}	

		return true
    } 
	
}

function InsuType_onchange(){
	var obj=document.getElementById("InsuType");	
	var InsuType=obj[obj.selectedIndex].value;
    if (InsuType==""){
	    var obj=document.getElementById("InsuAdmType");
	    if (obj) {obj.selectedIndex=0}
	    alert("请选择医保类型!");
	    return;
    }
    var newDicType="AKA130"+InsuType    //拼医疗类别的DicType
    //alert("newDicType="+newDicType);
    var VerStr="";
	VerStr=tkMakeServerCall("web.INSUDicDataCom","GetSys","","",newDicType);
	//alert("newDicType:"+newDicType+"VerStr"+VerStr);
	if (VerStr=="") {alert("请在医保字典中维护"+newDicType);return;}
	var Arr1=VerStr.split("!")
	obj=document.getElementById("InsuAdmType")
	if (obj){
	  obj.options.length=0
	  obj.size=1; 
	  obj.multiple=false;
	  var j=1
	  for (var i=1;i<Arr1.length;i++){
		  	//alert("Arr1[i]="+Arr1[i])
		if (Arr1[i].split("^")[8]=="IP")
			{
		
			obj.options[j]=new Option(Arr1[i].split("^")[3],Arr1[i].split("^")[2]); 
			if (Arr1[i].split("^")[9]=="Y")	{obj.selectedIndex=j}      //取默认值
			j=j+1;
			}		
		}	
	}
	ZLFS_ini();	
	BCFS_ini();	
	var diaglistobj=document.getElementById("AdmDiagLst");
	var tmpdiagid=""
	var tmpdiagCode=""
	var tmpdiagidstr=diaglistobj[diaglistobj.selectedIndex].value
	if(tmpdiagidstr!=""){tmpdiagid=tmpdiagidstr.split("^")[1];tmpdiagCode=tmpdiagidstr.split("^")[2]}
	var tmpDiagStr=tkMakeServerCall("web.INSUDiagnosis","GetICDConInfo",tmpdiagid,tmpdiagCode,InsuType);
	if(tmpDiagStr.length>10){
	    var obj=document.getElementById("InsuInDiagCode");
	    if (obj) {obj.value=tmpDiagStr.split("^")[2]}
	    var obj=document.getElementById("InsuInDiagDesc");
	    if (obj) {obj.value=tmpDiagStr.split("^")[3]}
	}
}


//*******************************
//医保登记				        *
//*******************************
function InsuIPReg_onclick(){	
	var TempString="",InsuAdmType="",CardInfo="",InsuNo=""
	var StDate="",EndDate=""
	
	obj=document.getElementById("InsuIPReg")
	if (obj.disabled==true){return false;}
	var obj=document.getElementById("InsuType");	
	var InsuType=obj[obj.selectedIndex].value;
    if (InsuType==""){
	    var obj=document.getElementById("InsuAdmType");
	    if (obj) {obj.selectedIndex=0}
	    alert("请选择医保类型!");
	    return;
    }
	var obj=document.getElementById("InsuAdmType")
	if (obj) {
		if (obj.value=="") {
			alert("医疗类别不能空");
			return false
		}
		InsuAdmType=obj.value
	}	
	
	
	var obj=document.getElementById("InsuNo")
	if (obj){InsuNo=obj.value;}
	
	obj=document.getElementById("InsuInDiagCode")
	if (obj){var InsuInDiagCode=obj.value}
	obj=document.getElementById("InsuInDiagDesc")
	if (obj){var InsuInDiagDesc=obj.value}	
	
	if((tDiagDesc!=InsuInDiagDesc)&&(tDiagDesc!=""))
	{
		alert("医保诊断名称非法，请重新录入")
		return ;
	}
	//就诊日期
	var AdmDate="";
	obj=document.getElementById("AdmDate") //入院日期   20151216 DingSH
	if (obj)
	{
		AdmDate=obj.value;
		//Svar flag=isDate(AdmDate);
		//if(flag==false){alert("入院日期格式非法， 正确格式，形如[2008-08-08]") ;return false;}
	   
	}
	//就诊时间
	var AdmTime="";
	obj=document.getElementById("AdmTime") // 入院时间  20151216 DingSH  
	if (obj)
	 {
		AdmTime=obj.value;
		var flag=isTime(AdmTime);
		if(flag==false){alert("入院时间格式非法， 正确格式，形如[16:05:39]") ;return false;}
	 }
	var ZLFSStr	//治疗方式
	obj=document.getElementById("ZLFS")
	if (obj){var ZLFSStr=obj.value}	
	var BCFSStr	//补偿方式
	obj=document.getElementById("BCFS")
	if (obj){var BCFSStr=obj.value}	
	
	TempString=InsuAdmType+"^"+InsuInDiagCode+"^"+InsuInDiagDesc+"^"+InsuNo+"^"+AdmDate+"^"+AdmTime+"^"+ZLFSStr+"^"+BCFSStr+"^"+InsuType
	//登记
	//alert(TempString)
	var flag=InsuIPReg(0,Guser,AdmDr,AdmReasonNationalCode, AdmReasonDr,TempString)//DHCInsuPort.js
	//flag=0
	if (+flag<0)  {alert("医保登记失败");return false;}	
	flag=UpdatePatAdmReason(AdmDr,"",Guser)
	inactFlag="A"; 
	alert("医保登记成功")
	var obj=document.getElementById("InsuIPReg")
	if (obj) {obj.disabled=true;}
 	var obj=document.getElementById("InsuIPRegCancel");
	if (obj) {obj.disabled=false;}
	var obj=document.getElementById("InsuActiveFlag");
	if (obj) {obj.value="已登记";}
	PaadmList_onchange()
    //登记成功后清屏
    //Clear();
    //obj=document.getElementById("PapmiNo");
	//if (obj){obj.value="";obj.focus();} 
	window.status="登记成功!";	
}

//取消登记
function InsuIPRegCancel_onclick(){

	obj=document.getElementById("InsuIPRegCancel")
	if (obj.disabled==true){return false;}
	var ExpStr=""
	if((""==AdmReasonDr)||("1"==AdmReasonDr)){
		var insutype=document.getElementById("InsuType").value
		if(""!=insutype){
			var newAdmReasonDr=tkMakeServerCall("web.INSUDicDataCom","GetDicByCodeAndInd","AKC021"+insutype,TemppatType,6);
			if((newAdmReasonDr!="")&(newAdmReasonDr!=1)){AdmReasonDr=newAdmReasonDr}
		}
	}
	if(""==AdmDr){alert("请选择病人及就诊信息!");return;}
	//登记取消
	var flag=InsuIPRegStrike(0,Guser,AdmDr, AdmReasonNationalCode, AdmReasonDr,ExpStr) //DHCInsuPort.js
	if (+flag<0) {alert("取消登记失败");return;}
	alert("取消登记成功")
	var obj=document.getElementById("InsuIPRegCancel");
	if (obj) {obj.disabled=true;}
	var obj=document.getElementById("InsuIPReg");
	if (obj) {obj.disabled=false;}
	var obj=document.getElementById("InsuActiveFlag");
	if (obj) {obj.value="取消登记";}
	//取消登记更新成自费 DingSH 20160716 
	var flag=UpdatePatAdmReason(AdmDr,"1",Guser)
	//清空界面信息
	//PaadmList_onchange();
	PaadmList_onchange()
    window.status="登记撤销完毕!";	
}

function InsuReadCard_onclick() {
	var obj=document.getElementById("InsuType");
	if (obj) {
		if (obj.value==""){alert("请选择医保类型");return}
		else {var InsuType=obj.value}
	}
	var InsuNo=""
	var obj=document.getElementById("InsuId");
	if (obj) {InsuNo=obj.value}
	var ExpString=InsuType
	var CardType=""
	var flag=InsuReadCard(0,Guser,InsuNo,CardType,ExpString)//DHCInsuPort.js
	var NewCardNo="",CardNo="";
	if (eval(flag.split("|")[0])==0)
	{
		alert("读医保卡成功");
		//医保卡返回参数格式：参考医保读卡返回固定参数列表V2.0.xls
		 var InsuCardStr=flag.split("|")[1];
		 NewCardNo=InsuCardStr.split("^")[1];
		 var obj=document.getElementById("NewCardNo");
    	 if (obj) {obj.value=NewCardNo;}
	}
	var obj=document.getElementById("CardNo");
	if (obj){CardNo=obj.value;}
	var obj=document.getElementById("OldCardNo");
	if (obj){obj.value=CardNo;}
	if ((NewCardNo!="")&&(CardNo!="")&&(CardNo!=NewCardNo))
	{
		var IsFlag=confirm("读医保卡的卡号："+NewCardNo+",和登记时医保卡号："+CardNo+"不一致，是否进行修改");
		if(IsFlag)
		{
		  UpdINSUCardNo_onclick();
		}
	}
	
	
}
	
	


function Clear_onclick(){
	//Clear();
	//obj=document.getElementById("PapmiNo")
	//if (obj){obj.value="";}
	//obj=document.getElementById("PaadmList")
	//if (obj){obj.options.length=0}
	AdmDr=""
	PapmiNo=""
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=INSUIPReg&AdmDr="+AdmDr+"&PapmiNo="+PapmiNo
	}
function Clear(){
	//obj=document.getElementById("PapmiNo")
	//if (obj){obj.value="";}
	ClearPatInfo()
	ClearPaadmInfo()
	ClearInsuAdmInfo()
}
function ClearPatInfo() {
	obj=document.getElementById("Name")
	if (obj){obj.value="";}
	obj=document.getElementById("Sex")
	if (obj){obj.value="";}
	obj=document.getElementById("Age")
	if (obj){obj.value="";}
	obj=document.getElementById("PatID")
	if (obj){obj.value="";}
	obj=document.getElementById("CTProvinceName")
	if (obj){obj.value="";}
	obj=document.getElementById("CTCityName")
	if (obj){obj.value="";}
	obj=document.getElementById("CTAreaName")
	if (obj){obj.value="";}
	}
function ClearPaadmInfo() {
	obj=document.getElementById("AdmDate")
	if (obj){obj.value="";}
	obj=document.getElementById("AdmTime")
	if (obj){obj.value="";}
	obj=document.getElementById("DepDesc")
	if (obj){obj.value="";}	
	obj=document.getElementById("InDiagCode")
	if (obj){obj.value="";}	
	obj=document.getElementById("InDiagDesc")
	if (obj){obj.value="";}	
	obj=document.getElementById("AdmReasonDesc")
	if (obj){obj.value="";}
	}
function ClearInsuAdmInfo() {
	obj=document.getElementById("InsuType")
	if (obj){obj.value="";}	
	obj=document.getElementById("InsuAdmType")
	if (obj){obj.value="";}
	obj=document.getElementById("InsuInDiagDesc")
	if (obj){obj.value="";}
	obj=document.getElementById("InsuInDiagCode")
	if (obj){obj.value="";}
	obj=document.getElementById("InsuPatType")
	if (obj){obj.value="";}
	obj=document.getElementById("dylb")
	if (obj){obj.value="";}
	obj=document.getElementById("xzlx")
	if (obj){obj.value="";}
	obj=document.getElementById("InsuNo")
	if (obj){obj.value="";}
	obj=document.getElementById("CardNo")
	if (obj){obj.value="";}
	obj=document.getElementById("InsuCardStatus")
	if (obj){obj.value="";}
	obj=document.getElementById("InsuActiveFlag")
	if (obj){obj.value="";}
	obj=document.getElementById("InsuIPReg")
	if (obj){obj.disabled=false;}
	obj=document.getElementById("InsuIPRegCancel")
	if (obj){obj.disabled=false;}
	TemppatType="";
	}

//	
function mySelectRow()
{
	var obj=document.getElementById("InsuAdmType");
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
			
	

function Query_Click()
{
	var TempString="",InsuAdmType="",CardInfo=""
	var BegDate="",BegFeeDate=""
	var obj=document.getElementById("InsuAdmType")
	if (obj) {
		if (obj.value=="") {
			alert("类别不能空");
			return false
		}
		InsuAdmType=obj.value
		if ((obj.value=="4")&&(spcDiagCode=="")) {
			alert(t['INSUMSG01']);
			return false
		}
	}	

	var obj=document.getElementById("INSUCARDID")
	if (obj) {
		CardInfo=obj.value
	}	
	
	TempString=CardInfo+"^"+InsuAdmType+"^"+spcDiagCode

	var AdmReasonDr=document.getElementById("AdmReasonDr").value	
    var AdmReasonNationalCode=document.getElementById("AdmReasonNationalCode").value
	
	//登记查询
	var rtn=InsuIPRegQuery(Guser,TempString,AdmReasonNationalCode,AdmReasonDr) //DHCINSUPort.js
	//卡类别标志|卡号|姓名|职退情况|保健对象|公务员|特殊待遇标识|封存标志|在职享受退休标志|适用医保办法标志|等待期标识|特殊标识|登记类别|登记号|开始日期|结束日期|诊断编码|大病项目代码|登记医院标志|登记医院名称
	//alert(rtn)
	if (rtn=="-1"){return;}
	var List=rtn.split("|")
	document.getElementById("InsuNo").value=List[1]
	document.getElementById("Name").value=List[2]
	document.getElementById("InsuAdmType").value=List[12]
	document.getElementById("PapmiNo").value=List[13]
	if (List[14]!=""){
	document.getElementById("StDate").value=List[14].substring(7,8)+"/"+List[14].substring(5,6)+"/"+List[14].substring(0,4);
	}
	if (List[15]!=""){
	document.getElementById("StDate").value=List[15].substring(7,8)+"/"+List[15].substring(5,6)+"/"+List[15].substring(0,4);
	}
	if (List[17]!=""){
	document.getElementById("SpcDiag").value=List[17];
	}
	if (List[18]!=""){document.getElementById("InsuActiveFlag").value="在院";}
	var obj=document.getElementById("InsuIPReg");
	if (obj) {obj.disabled=true;}
	var obj=document.getElementById("InsuIPRegCancel");
	if (obj) {obj.disabled=false;}

}


 //更新医保卡卡号
 function UpdINSUCardNo_onclick(){
	var btnobj=document.getElementById("btnUpdINSUCardNo");
	if(btnobj.disabled==true){return;}
	var NewCardNo=document.getElementById("NewCardNo").value;
 	if ((NewCardNo=="")||((NewCardNo==" "))){		   
  	  	alert("修改的医保卡号为空，请填写");
   	 	return;   
	 }
	 if (NewCardNo==OldCardNo){		   
  	  	alert("修改的医保卡号没变化，请重新填写");
   	 	return;   
	 }
    var objUpdateINSU=document.getElementById('clsUpdateINSUCardNo');
	if (objUpdateINSU) {var encmeth=objUpdateINSU.value} else {var encmeth=''};
	if(cspRunServerMethod(encmeth,AdmDr,OldCardNo+"_"+NewCardNo)=="0")
	{
	  
	  obj=document.getElementById("CardNo");
	  if(obj){ obj.value=NewCardNo;
	           obj.focus();}
	  obj=document.getElementById("OldCardNo");
	  if(obj){obj.value=OldCardNo;}
	  alert("更新医保卡号信息成功!");
	  OldCardNo=NewCardNo; //更新成功后，新的卡号变成就卡号了
	  UpCardFlag=true;
	}
	else
	{
		alert("更新医保卡号信息失败")
		
	}
	 
	 }
function SetDiagValue(value){
	var obj=document.getElementById("InsuInDiagCode");
	if (obj) {obj.value=value.split("^")[1];}
	var obj=document.getElementById("InsuInDiagDesc");
	if (obj) {
		obj.value=value.split("^")[2];
		tDiagDesc=value.split("^")[2];
	}
	
	}
	
//焦点失去校验日期 DingSH 20151216
function AdmDate_Checked(){
	
	var AdmDate="";
	obj=document.getElementById("AdmDate") //入院日期   20151216 DingSH
	if (obj)
	{
		AdmDate=obj.value;
		var flag=isDate(AdmDate);
		if(flag==false){alert("入院日期格式非法， 正确格式，形如[2008-08-08]") ;return false;}
	   
	}

	}
	
//焦点失去校验时间 DingSH 20151216	
function AdmTime_Checked()
{
	//就诊时间
	var AdmTime="";
	obj=document.getElementById("AdmTime") // 入院时间  20151216 DingSH  
	if (obj)
	 {
		AdmTime=obj.value;
		var flag=isTime(AdmTime);
		if(flag==false){alert("入院时间格式非法， 正确格式，形如[16:05:39]") ;return false;}
	 }
}	


//校验入院日期是否可编辑 kongjian 20180516
function AdmDate_CheckDisabled(){
	obj=document.getElementById("AdmDate") //入院日期   20151216 DingSH
	if (obj)
	{
		var objInsuType=document.getElementById("InsuType");
		if (objInsuType) {
			if (objInsuType.value==""){
				return;
			}else{
				var InsuType=objInsuType.value
			}
		}
		var objClass=document.getElementById('ClassCheckModifyAdmDate');
  		if (objClass) {var encmeth=objClass.value} else {var encmeth=''};
 		var OutStr=cspRunServerMethod(encmeth,InsuType);
 		if (OutStr!="1"){
	 		obj.disabled=true;
	 	}
		
	}

	}
	
//校验入院时间是否可编辑 kongjian 20180516	
function AdmTime_CheckDisabled()
{
	//就诊时间
	obj=document.getElementById("AdmTime") // 入院时间  20151216 DingSH  
	if (obj)
	{
		var objInsuType=document.getElementById("InsuType");
		if (objInsuType) {
			if (objInsuType.value==""){
				return;
			}else{
				var InsuType=objInsuType.value
			}
		}
		var objClass=document.getElementById('ClassCheckModifyAdmDate');
  		if (objClass) {var encmeth=objClass.value} else {var encmeth=''};
 		var OutStr=cspRunServerMethod(encmeth,InsuType);
 		if (OutStr!="1"){
	 		obj.disabled=true;
	 	}
	 }
}	

	
//1 短时间，形如 (13:04:06) DingSH 20151216
function isTime(str)
{
var a = str.match(/^(\d{1,2})(:)?(\d{1,2})\2(\d{1,2})$/);
if (a == null) {return false;}
if (a[1]>24 || a[3]>60 || a[4]>60)
{
return false
}
return true;
}

//2. 短日期，形如 (2008-08-08) DingSH 20151216
function isDate(str)
{
var r = str.match(/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/); 
if(r==null)return false; 
var d= new Date(r[1], r[3]-1, r[4]); 
return (d.getFullYear()==r[1]&&(d.getMonth()+1)==r[3]&&d.getDate()==r[4]);
}

function AdmDiagLst_onchange()
{
	var obj=document.getElementById("AdmDiagLst");
	var DiagStr=obj[obj.selectedIndex].value;

    if (DiagStr!=""){
	    var obj=document.getElementById("InDiagCode");
	    if (obj) {obj.value=DiagStr.split("^")[2]}
	    var obj=document.getElementById("InDiagDesc");
	    var shwDiagDesc=DiagStr.split("^")[3];
	    if (shwDiagDesc==""){shwDiagDesc=DiagStr.split("^")[4]}
	    if (obj) {obj.value=shwDiagDesc}
    }
	
	
	
}

//Zhan 20160114治疗方式列表
//需要根据医保类型在字典表的sys中维护节点
//比如BJZLFS
function ZLFS_ini(){
	var obj=document.getElementById("InsuType");	
	var InsuType=obj[obj.selectedIndex].value;
    if (InsuType==""){
	    var obj=document.getElementById("InsuType");
	    if (obj) {obj.selectedIndex=0}
	    alert("请选择医保类型!");
	    return;
    }
    var newDicType="ZLFS"+InsuType    //拼治疗方式
    var VerStr="";
	VerStr=tkMakeServerCall("web.INSUDicDataCom","GetSys","","",newDicType);
	//alert("newDicType:"+newDicType+",VerStr"+VerStr);
	if (VerStr=="") {alert("请在医保字典中维护治疗方式节点："+newDicType);return;}
	var Arr1=VerStr.split("!")
	obj=document.getElementById("ZLFS")
	if (obj){
	  obj.options.length=0
	  obj.size=1; 
	  obj.multiple=false;
	  var j=1
	  for (var i=1;i<Arr1.length;i++){
		  	//alert("Arr1[i]="+Arr1[i])
			obj.options[j]=new Option(Arr1[i].split("^")[3],Arr1[i].split("^")[2]); 
			if (Arr1[i].split("^")[9]=="Y")	{obj.selectedIndex=j}      //取默认值
			j=j+1;	
		}	
	}	
}
//Zhan 20160114补偿方式列表
//需要根据医保类型在字典表的sys中维护节点
//比如BJBCFS
function BCFS_ini(){
	var obj=document.getElementById("InsuType");	
	var InsuType=obj[obj.selectedIndex].value;
    if (InsuType==""){
	    var obj=document.getElementById("InsuType");
	    if (obj) {obj.selectedIndex=0}
	    alert("请选择医保类型!");
	    return;
    }
    var newDicType="BCFS"+InsuType    //拼补偿方式
    var VerStr="";
	VerStr=tkMakeServerCall("web.INSUDicDataCom","GetSys","","",newDicType);
	//alert("newDicType:"+newDicType+",VerStr"+VerStr);
	if (VerStr=="") {alert("请在医保字典中维护补偿方式节点："+newDicType);return;}
	var Arr1=VerStr.split("!")
	obj=document.getElementById("BCFS")
	if (obj){
	  obj.options.length=0
	  obj.size=1; 
	  obj.multiple=false;
	  var j=1
	  for (var i=1;i<Arr1.length;i++){
		  	//alert("Arr1[i]="+Arr1[i])
			obj.options[j]=new Option(Arr1[i].split("^")[3],Arr1[i].split("^")[2]); 
			if (Arr1[i].split("^")[9]=="Y")	{obj.selectedIndex=j}      //取默认值
			j=j+1;	
		}	
	}	
}
//CardNo 获取焦点事件 DingSH 20160715
function CardNo_onfocus(){
	if (UpCardFlag)
	{
	 var OldCard=""
	 var obj=document.getElementById("CardNo");
    if (obj){OldCard=obj.value;	
             OldCardNo=obj.value}
	//var obj=document.getElementById("OldCardNo");
	//if (obj){obj.value=OldCard;}

	UpCardFlag=false;
	}

	
	}
//CardNo 失去焦点事件 DingSH 20160715	 
function CardNo_onblur()
{
	var NewCard=""
	var obj=document.getElementById("CardNo");
	if (obj){NewCard=obj.value;}
	var obj=document.getElementById("NewCardNo");
	if (obj){obj.value=NewCard;}
}
	
 //根据Padm.Rowid 更新费别
 //ReadId 为空时  根据 医保登记信息 中心 人员类别 更新费别
 //ReadId 不为空时 根据传入的ReadId进行更新费别
//DingSH 20160713	
function UpdatePatAdmReason(AdmDr,ReadId,ExpStr)
{
	
    var Flag="";
	Flag=tkMakeServerCall("web.DHCINSUIPReg","UpdatePatAdmReason",AdmDr,ReadId,ExpStr);
	//if (Flag=="") {alert("请在医保字典中维护DLLType");return;}
	return Flag;
 }	
//关闭网页或刷新页面触发函数	
// DingSH 20170716
/*function BodyUnLoadHandler()
{
	//alert("inactFlag="+inactFlag+"^AdmDr="+AdmDr)
	if ((inactFlag=="")&&(AdmDr!=""))
	{
		UpdatePatAdmReason(AdmDr,"1",Guser) ;//网页非正常关闭更新成自费
	 }
	
}*/	
document.body.onload = BodyLoadHandler;
//document.body.onbeforeunload = BodyUnLoadHandler;

	
/*以下程序老项目移植过来   紧供大家参考需要添加代码请在   此行上面添加
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
	
	
function DelFile(FileName){
	var fs = new ActiveXObject("Scripting.FileSystemObject");
	///alert(FileName+"//////"+fs.FileExists(FileName));
	if (fs.FileExists(FileName)){
		    var x=fs.DeleteFile(FileName,false);
		}
	
		
	}
//根据医保卡数据得到患者信息
//zmgzt 	
function getybCardNo(){
	var papstr=""
	var PatientID,patidobj
	patidobj=document.getElementById("PatientID");
	PatientID=patidobj.value;
	var obj=document.getElementById("getCardNo");
	if (obj) {var encmeth=obj.value} else {var encmeth=''};
	papstr=cspRunServerMethod(encmeth,'','',PatientID);
	if (papstr!=""){
	   var papstr1=papstr.split("^");
	   if (papstr1[0]!="0"){
		   var obj=document.getElementById("ybCardNo");
		   obj.value=papstr1[1];
		   //obj.readOnly=true
		   }
	   }
}	

//insert by cx 2006.06.01 
function ybCardNoEnter(e) {
	var key = websys_getKey(e);
	var obj = websys_getSrcElement(e);
	var papstr=""
	//var ybCardNo
	if ((obj)&&(obj.value!="")&&(key==13)) {
		Query_Click() //Lou 2010-02
		return;
		var CardNoobj=document.getElementById("INSUCARDID");
		var CardNo=CardNoobj.value;
		//zmgzt
		var myrtn=DHCACC_GetPAPMINo(CardNo);
		var myary=myrtn.split("^");
		if ((myary[0]=="-201")||( myary[0]=="0")){
			var myPAPMNo=myary[1];
			var obj=document.getElementById("PapmiNo");
		     obj.value=myPAPMNo;
		     //regnoobj.value=myPAPMNo;
		GetPaadmList();
		var obj=document.getElementById("PaadmList");
		if (obj){obj.focus()}
		
		}else{
			CardNoobj.value="";
			alert(t['nbmzdhc01']);
		}
    }
}
	
function getybCardNo(){
	
	var papstr=""
	var obj=document.getElementById("getCardNo");
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
	
	function myFillDateToFeeDate()
{
	var obj=document.getElementById("BegDate")
	var myBegDate=obj.value;
	var obj=document.getElementById("BegFeeDate");
	obj.value=myBegDate;

	}
	
	*/
	
	
function DisBtn(tgtobj){
	if (tgtobj){
		tgtobj.disabled=true;
		tgtobj.style.color="gray";
		//tgtobj.onclick=function() 	//运行完这段代码后，按钮的click事件再也无法触发，无论 disabled的值。
		//tgtobj.onclick=function(){return false;}
	}
}
//Enable the button
function ActBtn(tgtobj){
	if (tgtobj){
		tgtobj.disabled=false;
		tgtobj.style.color="black";
	}
}