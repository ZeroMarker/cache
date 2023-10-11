//名称  DHCPEPreIBaseInfoNew.Edit.hisui.js
//功能	个人基本信息维护
//创建	2020.11.04
//创建人  xy
var myCombAry=new Array(); 
$(function(){
	 
	InitCombobox();
	
		
	//更新
	$("#Update").click(function() {	
		Update_click();		
        });
	
	//拍照 
	$("#BPhoto").click(function() {	
		BPhoto_click();		
        });
   
   //读身份证  
   	$("#ReadRegInfo").click(function() {	
		ReadRegInfo_OnClick();		
        });

	//读卡  
	$("#ReadCard").click(function() {	
		ReadCardClickHandler();		
        });

	//清屏
	$("#Clear").click(function() {	
		Clear_click("","");		
        });
        
     //姓名
    $("#Name").keydown(function(e) {
			
			if(e.keyCode==13){
				Name_keydown();
				}
		});
    
    
	
	$("#IDCard").keydown(function(e) {
	    if (e.keyCode == "13") {
		     ChangeIDCard()
		        }
    });
    
    $("#IDCard").change(function(){
  			ChangeIDCard()
		});


		
     
    $("#Age").change(function(){
  			 Age_Change();
		});
	
   $("#DOB").blur(DOB_OnBlur);
	
	SetDefault();
	
	iniForm();
	
	

	
})

function ChangeIDCard()
{
	var num=$("#IDCard").val();
	var iRowId=$("#RowId").val();
	if (iRowId!="") return false;
	
	var iPAPMICardType=""
	iPAPMICardType=$("#PAPMICardType_DR_Name").combobox('getText');
	if((iPAPMICardType.indexOf("身份证")!="-1")&&(num!="")){
		var ret=isIdCardNo(num);
		if(ret==true){GetInfoByIdCard(num)}
	}

	var RegNo=tkMakeServerCall("web.DHCPE.PreIBaseInfo","GetRegNoByIDCard",num);
	if (RegNo==""){
		return false;
	}
	$("#PAPMINo").val(RegNo)
	RegNoChange();
	
	return false;
}

function GetInfoByIdCard(num)
{
	
	if (num=="") return true;
	var len = num.length;
	var re;	
	var ShortNum=num.substr(0,num.length-1)
	var ShortNum=ShortNum+"1"
	if (len == 15) re = new RegExp(/^(\d{6})()?(\d{2})(\d{2})(\d{2})(\d{2})$/);
	else if (len == 18) re = new RegExp(/^(\d{6})()?(\d{4})(\d{2})(\d{2})(\d{3})(\d)$/);
	var a = (ShortNum).match(re);
	if (a != null)
	{
	if (len==15)
		{
			var D = new Date("19"+a[3]+"/"+a[4]+"/"+a[5]);
			var B = D.getFullYear()==a[3]&&(D.getMonth()+1)==a[4]&&D.getDate()==a[5];
		}
		else
		{
			var D = new Date(a[3]+"/"+a[4]+"/"+a[5]);
			var B = D.getFullYear()==a[3]&&(D.getMonth()+1)==a[4]&&D.getDate()==a[5];
		}
		var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat")
		if (dtformat=="YMD"){
			var mybirth=a[3]+"-"+a[4]+"-"+a[5];
		}else if (dtformat=="DMY"){
			var mybirth=a[5]+"/"+a[4]+"/"+a[3];
		}
       
       $("#DOB").val(mybirth);
		
		var Dateinit=new Date          	
        var Yearinit=Dateinit.getFullYear();
	    var Year=Yearinit-a[3]
		
		var myAge=tkMakeServerCall("web.DHCDocCommon","GetAgeDescNew",mybirth,"")
		//DHCWebD_SetObjValueA("Age",myAge);
		$("#Age").val(myAge)
		if (len==15)
		{
			var SexFlag=num.substr(14,1);
		}
		else
		{
			var SexFlag=num.substr(16,1);
		}
		
		var SexNV=""
		var JsonData=$.cm({
		ClassName:"web.DHCPE.HISUICommon",
		MethodName:"GetDefault"
		},false);
		
		var SexNV=JsonData.ret;
		SexNV=SexNV.split("^");
		if (SexFlag%2==1)
		{
			$("#Sex_DR_Name").combobox('setValue',SexNV[2]);	
		}
		else
		{
			$("#Sex_DR_Name").combobox('setValue',SexNV[3]);	
		}
		
	}
	return true;
}

function Name_keydown()
{
	var iName="";
	var iName=$("#Name").val();
	if(iName=="") { return false; }
	var info=tkMakeServerCall("web.DHCPE.PreIBaseInfo","GetPersonInfo",iName);
	if (info==0) return;
	
	openNameWin(iName);
}

var openNameWin = function(desc){
	
	var NameWinObj=$HUI.window("#NameWin",{
		title:"信息列表",
		collapsible:false,
		modal:true,
		minimizable:false,
		maximizable:false,
		width:600,
		height:400
	});
	
	var QryLisObj = $HUI.datagrid("#QryNameWin",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.PreIBaseInfo",
			QueryName:"SearchPreIBaseInfo",
			PatName:desc

		},
		columns:[[
			{field:'PIBI_RowId',hidden:true},
			{field:'PIBI_PAPMINo',width:'100',title:'登记号'},
			{field:'PIBI_Name',width:'80',title:'姓名'},
			{field:'PIBI_Sex_DR_Name',width:'60',title:'性别'},
			{field:'PIBI_DOB',width:'100',title:'出生日期'},
			{field:'PIBI_IDCard',width:'150',title:'身份证号'},
			{field:'PIBI_Married_DR_Name',width:'70',title:'婚姻状况'},
			{field:'PIBI_MobilePhone',width:'110',title:'电话号码'}	
		]],
		onDblClickRow:function(rowIndex,rowData){
			var pibi=rowData.PIBI_PAPMINo;
			$('#PAPMINo').val(pibi);
			RegNoChange();
			NameWinObj.close();
		},
		pagination:true,
		displayMsg:"",
		pageSize:20,
		fit:true
	
		})
	
	
};



//读卡
function ReadCardClickHandle(){
	DHCACC_GetAccInfo7(CardNoKeyDownCallBack);
}

function CardNoKeyDownCallBack(myrtn){
	var CardNo=$("#CardNo").val();
	var CardTypeNew=$("#CardTypeNew").val();
	$(".textbox").val('');
	$("#CardTypeNew").val(CardTypeNew);
   var myary=myrtn.split("^");
   var rtn=myary[0];
   if ((rtn=="0")||(rtn=="-201")){
		var PatientID=myary[4];
		var PatientNo=myary[5];
		var CardNo=myary[1];
		$("#CardTypeRowID").val(myary[8]);
		$("#CardNo").focus().val(CardNo);
		$("#RegNo").val(PatientNo);
		BFind_click();
	}else if(rtn=="-200"){
		$.messager.popover({msg: "卡无效!", type: "info"});
		$("#CardNo").focus().val(CardNo);
		return false;
	}
}




/*
function ReadRegInfo_OnClick()
  {
     var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat")
	 var rtn=tkMakeServerCall("DHCDoc.Interface.Inside.Service","GetIECreat")
	var myHCTypeDR=rtn.split("^")[0];
	var myInfo=DHCWCOM_PersonInfoRead(myHCTypeDR);

   var myary=myInfo.split("^");
    
     if (myary[0]=="0")
    { 
      SetPatInfoByXML(myary[1]); 
	     
		 //Sex 性别
      var mySexobj=document.getElementById("Sex");
      if (mySexobj){$("#Sex_DR_Name").combobox('setValue',mySexobj.value);}
		
		//NationDesc 民族
	   var myNationDescobj=document.getElementById("NationDesc");
	   if (myNationDescobj){
		  var NationDR=tkMakeServerCall("web.DHCPE.PreCommon","GetNationDR",myNationDescobj.value)
		   $("#CTNationDR").combobox('setValue',NationDR);
	   }

		
     
	 //出生日期
	  var myBirobj=document.getElementById("Birth");
	    if(myBirobj){
	    var mybirth=myBirobj.value;
		 if(mybirth!=""){
		  if (dtformat=="YMD"){
			 if (mybirth.length==10){
			var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(5,7)+"-"+mybirth.substring(8,10)
 	 		}else{
 			var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(4,6)+"-"+mybirth.substring(6,8) 
  			}
		}
		if (dtformat=="DMY"){
			if (mybirth.length==10){
				var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(5,7)+"-"+mybirth.substring(8,10)
  			}else{
				var mybirth=mybirth.substring(6,8)+"/"+mybirth.substring(4,6)+"/"+mybirth.substring(0,4)
 			}
		}
		 }
	  }
    if (myBirobj){$("#DOB").val(mybirth);}

		
	var photoobj=document.getElementById("PhotoInfo");
	if ((photoobj)&&(photoobj.value!="")){
		
		var src="data:image/png;base64,"+photoobj.value;
		document.getElementById("imgPic").innerHTML='<img SRC=data:image/png;base64,'+photoobj.value+' BORDER="0" width=120 height=140>'
	}
	else{
		var src='c://'+mycredobj.value+".bmp";
		var NoExistSrc="../images/uiimages/patdefault.png"; // //没有保存照片时显示的图片
		document.getElementById("imgPic").innerHTML='<img SRC='+src+' BORDER="0" width=120 height=140 onerror=this.src="'+NoExistSrc+'">'
	
	
	}

	  var mycredobj=document.getElementById("CredNo");
	  var myidobj=document.getElementById('IDCard');
		if ((mycredobj)&&(myidobj)){
			myidobj.value=mycredobj.value;
			var RegNo=tkMakeServerCall("web.DHCPE.PreIBaseInfo","GetRegNoByIDCard",myidobj.value);
			if (RegNo==""){
				return false;
			}else{
					$("#PAPMINo").val(RegNo);
					RegNoChange();
				
			}
		}
		
		
     }
     
   
    IDReadControlDisable(true);
     
   }
   */
 function ReadRegInfo_OnClick()
  {
     var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat")
	 var rtn=tkMakeServerCall("DHCDoc.Interface.Inside.Service","GetIECreat")
	 
	var myHCTypeDR=rtn.split("^")[0];
	var myInfo=DHCWCOM_PersonInfoRead(myHCTypeDR);

  //alert("myInfo:"+myInfo)
   var myary=myInfo.split("^");
    
     if (myary[0]=="0")
    { 
    
      SetPatInfoByXML(myary[1]); 
       var PhotoInfo=$("#PhotoInfo").val();
    
	if (PhotoInfo!=""){
		
		var src="data:image/png;base64,"+PhotoInfo;
		document.getElementById("imgPic").innerHTML='<img SRC=data:image/png;base64,'+PhotoInfo+' BORDER="0" width=120 height=140>'
	}
	else{
		
		var src='c://'+$("#IDCard").val()+".bmp"
		var NoExistSrc="../images/uiimages/patdefault.png"; // //没有保存照片时显示的图片
		document.getElementById("imgPic").innerHTML='<img SRC='+src+' BORDER="0" width=120 height=140 onerror=this.src="'+NoExistSrc+'">'
	
	
	}
      var RegNo=tkMakeServerCall("web.DHCPE.PreIBaseInfo","GetRegNoByIDCard", $("#IDCard").val());
		if (RegNo==""){
			return false;
		}else{
			$("#PAPMINo").val(RegNo);
			RegNoChange();
				
		} 
		
     }
  

    IDReadControlDisable(true);
     
 }

function IDReadControlDisable(bFlag)
{
	
	var myobj=document.getElementById("IDCard");
	if (myobj){
		myobj.readOnly=bFlag;
	}
	var myobj=document.getElementById("Name");
	if (myobj){
		myobj.readOnly=bFlag;
	}
	var myobj=document.getElementById("Sex_DR_Name");
	if (myobj){
		myobj.readOnly=bFlag;
	}

	var myobj=document.getElementById("DOB");
	if (myobj){
		myobj.readOnly=bFlag;
	}
	var myobj=document.getElementById("Address");
	if (myobj){
		myobj.readOnly=bFlag;
	}
	var myobj=document.getElementById("Age");
	if (myobj){
		myobj.readOnly=bFlag;
	}
	
}




function RegNoChange() {
      
		var obj;
		var iPAPMINo=$("#PAPMINo").val();
		if (iPAPMINo!="") { 
			iPAPMINo=RegNoMask(iPAPMINo)
		}
		else { return false; }
		var iPAPMINo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iPAPMINo);
		$("#PAPMINo").val(iPAPMINo);
		var flag=tkMakeServerCall("web.DHCPE.PreIADM","JudgeIGByRegNo",iPAPMINo)
		if(flag=="G"){ 
			$.messager.popover({msg: "团体人员,请在团体基本信息维护界面操作", type: "info"});
		    return false;
		}

    var PatientID=tkMakeServerCall("web.DHCPE.PreIADM","GetPatientID",iPAPMINo)
    iPAPMINo="^"+iPAPMINo+"^";
    /*
    //var CardTypeNewID=$("#CardTypeNewID").val();
 	var SelValue=$HUI.combobox("#CardType").getValue();
 	if (SelValue==""){return;}
 	var myary=SelValue.split("^");
	var CardTypeNewID=myary[0];
	if(CardTypeNewID==""){return;}
 	
*/
   //根据登记号带出卡类型 
	var CardTypeNewStr=tkMakeServerCall("web.DHCPE.PreIBIUpdate","CardTypeByRegNo",$("#PAPMINo").val());
	
	if(CardTypeNewStr!=""){
			var CardTypeNewID=CardTypeNewStr.split("^")[0];
			var CardTypeNew=CardTypeNewStr.split("^")[1];
		    $("#CardTypeNew").val(CardTypeNew);
		}
	var HospID=session['LOGON.HOSPID'];
    iPAPMINo=iPAPMINo+"$"+CardTypeNewID+"$"+HospID;
	FindPatDetail(iPAPMINo);
	
   //卡号
   var myCardNo=$("#CardNo").val();

	
	InitPicture();
	
	
}

//	ID 格式 RowId^PAPMINo^Name
function FindPatDetail(ID){
	
	var Instring=ID;
	var flag=tkMakeServerCall("web.DHCPE.PreIBaseInfo","DocListBroker",'SetPatient','',Instring)
	
}
function SetPatient(value) {
 
	if ((""==value)&&(";"==value)) { return false; }
	var Data=value.split(";");
	if(value.split("^")[2]=="未找到记录"){
		$.messager.popover({msg: "HIS里面未找到信息", type: "info"});
		return false;
	}
   
	Clear_click("","");
	
	PreData=Data[0];
	HISData=Data[1];
	

	if (""!=PreData) {
		value=PreData;
		var Data=value.split("^");
		var iRowId=Data[0];
		//	PIBI_RowId	0
		$("#RowId").val(iRowId);
		if ("NoGen"==FIBIUpdateModel) { $("#Name").focus();}
		if ("Gen"==FIBIUpdateModel) { $("#PAPMINo").focus();}
		if ("FreeCreate"==FIBIUpdateModel) { $("#PAPMINo").focus(); }		
		
		SetPatient_Sel(value);
		
		return;
	}
	
	if (""!=HISData) {
		
		var value=HISData;
		var Data=value.split("^");
		$("#RowId").val("");
		
		SetPatient_Sel(value);
		
		if ("NoGen"==FIBIUpdateModel) { $("#Name").focus(); }
		if ("Gen"==FIBIUpdateModel) { $("#PatType_DR_Name").focus(); }		
		if ("FreeCreate"==FIBIUpdateModel) { $("#PatType_DR_Name").focus(); }
		return;
	}

		//	PIBI_RowId	0
		$("#RowId").val("");
		
		//	PIBI_Name	姓名	2
		$("#Name").val("未找到患者记录");
		
		if ("NoGen"==FIBIUpdateModel) { $("#PatType_DR_Name").focus(); }
		if ("Gen"==FIBIUpdateModel) { $("#PAPMINo").focus(); }
		
		
}
//
function SetPatient_Sel(value) {

   
    $("#Update").linkbutton('enable');
	IBISetPatient_Sel(value);
		//根据登记号带出卡类型 
	var CardTypeNewStr=tkMakeServerCall("web.DHCPE.PreIBIUpdate","CardTypeByRegNo",$("#PAPMINo").val());
	if(CardTypeNewStr!=""){
			var CardTypeNewID=CardTypeNewStr.split("^")[0];
			var CardTypeNew=CardTypeNewStr.split("^")[1];
		    $("#CardTypeNew").val(CardTypeNew);
		    $("#CardTypeRowID").val(CardTypeNewID);
		}
		
	InitPicture();
	/*
	//根据登记号带出卡类型  (因为卡类型在Clear_click()被清空了)
	var CardTypeNewStr=tkMakeServerCall("web.DHCPE.PreIBIUpdate","CardTypeByRegNo",$("#PAPMINo").val());
		//alert(CardTypeNewStr)
		if(CardTypeNewStr!=""){
			var CardTypeNewID=CardTypeNewStr.split("^")[0];
			var CardTypeNew=CardTypeNewStr.split("^")[1];
			$("#CardTypeNewID").val(CardTypeNewID);
		    $("#CardTypeNew").val(CardTypeNew);
		}
		*/
	return true;
}
function InitPicture()
{
	var PAPMINo=""; 
    PAPMINo=$("#PAPMINo").val();
	var jsonData=$.cm({
	ClassName:"web.DHCPE.PreIADM",
	MethodName:"HISUIGetPatientID",
	"PAPMINo":PAPMINo
	
	},false);
	var PatientID=jsonData.PatientID;
	
	PEShowPicByPatientID(PatientID,"imgPic")  //DHCPECommon.js
  
}
function SetDefault()
{
	
	var SexNV=""
	var JsonData=$.cm({
	ClassName:"web.DHCPE.HISUICommon",
		MethodName:"GetDefault"
	},false);
		
	var SexNV=JsonData.ret;

	SexNV=SexNV.split("^");
	//性别
	$("#Sex_DR_Name").combobox('setValue',SexNV[1]);
	//类型
	$("#PatType_DR_Name").combobox('setValue',SexNV[0]);
	//证件类型
    $("#PAPMICardType_DR_Name").combobox('setValue',SexNV[4]);
  
   //var VIPApprove=tkMakeServerCall("web.DHCPE.PreIBIUpdate","GetVIPLevel");
	//$("#VIPLevel").combobox('setValue',VIPApprove);	
}

function iniForm(){
	
	
	
	var HospID=session['LOGON.HOSPID'];
	
	if (""!=ID) {
	
		var ret=tkMakeServerCall("web.DHCPE.PreIBaseInfo","DocListBroker","","",ID+"^^^$$"+HospID);
	    if(ret!=""){SetPatient(ret);}
		
	
	}

	
}

//清除输入的信息
function Clear_click(Type,RegNo) {
	$("#CardTypeNew,#CardTypeRowID").val("");
	
	if ("NoGen"==FIBIUpdateModel) {
	
		if (RegNo!="") { 
			$("#PAPMINo").attr('disabled',true)
			$("#PAPMINo").val(RegNo);
		}
		
		if (Type!=1){
			IBIClear_click();
			}	
		$("#Name").focus();
		$("#Update").linkbutton('enable');
		var src="../images/uiimages/patdefault.png"
	      PEShowPicBySrc(src,"imgPic");

		return;
	}
	
	if ("Gen"==FIBIUpdateModel) {
		$("#PAPMINo").attr('disabled',false);
		IBIClear_click();
		$("#Update").linkbutton('enable');
		var src="../images/uiimages/patdefault.png";
	       PEShowPicBySrc(src,"imgPic");
	    $("#PAPMINo").focus();
		return;
	}
	if ("FreeCreate"==FIBIUpdateModel) {
		$("#PAPMINo").attr('disabled',false);
		IBIClear_click();
		$("#Update").linkbutton('enable');
		var src="../images/uiimages/patdefault.png";
		  PEShowPicBySrc(src,"imgPic");
		 $("#PAPMINo").focus();

		return;
	}	
	
}




function Update_click() {	

		 

	//iHospitalCode=getValueById("HospitalCode");

	//PIBI_RowId
	var iRowId=$("#RowId").val();
	
	//PIBI_PAPMINo	登记号	1	
	var iPAPMINo=$("#PAPMINo").val();
	if(iPAPMINo!=""){
			var iPAPMINo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iPAPMINo);
			$("#PAPMINo").val(iPAPMINo)
   		 var flag=tkMakeServerCall("web.DHCPE.PreIADM","JudgeIGByRegNo",iPAPMINo);
		if(flag=="G"){
			$.messager.alert("提示","团体人员,请在团体基本信息维护界面操作",'info');
	    	return false;
		}
	}
	
	//	PIBI_Name	姓名	2
	var iName=$("#Name").val();
	
	// 姓名必须
	if (""==iName) {
			$.messager.alert("提示","姓名不能为空!","info",function(){$("#Name").focus();});
			return false
	}

	//	PIBI_Sex_DR	性别	3
	var iSex_DR=$("#Sex_DR_Name").combobox('getValue');
   // 性别必须
	if (""==iSex_DR) {
			$.messager.alert("提示","性别不能为空!","info",function(){$("#Sex_DR_Name").focus();});
			return false
	}

	//	PIBI_IDCard	身份证号	9
	var iIDCard=$("#IDCard").val();
	iIDCard=trim(iIDCard)

	var iPAPMICardType=""
	var iPAPMICardType=$("#PAPMICardType_DR_Name").combobox('getText');
	if((iPAPMICardType.indexOf("身份证")!="-1")&&(iIDCard!="")){
		
		var myIsID=isIdCardNo(iIDCard);
		
				if (!myIsID){
					$("#IDCard").focus();
					return false;
				}
				var IDNoInfoStr=GetInfoFromIDCard(iIDCard)
				var IDBirthday=IDNoInfoStr[2]
				var myBirth=getValueById('DOB'); 
				if (myBirth!=IDBirthday){
					$.messager.alert("提示","出生日期与身份证信息不符!","info",function(){
						$("#Birth").focus();
					});
		   		    return false;
				}
				var IDSex=IDNoInfoStr[3]
				var mySex=getValueById('Sex_DR_Name');
				var mySex=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSexDescByID",mySex)
				//alert(mySex+"^"+IDSex)
				if(mySex!=IDSex){
					$.messager.alert("提示","身份证号:"+iIDCard+"对应的性别是【"+IDSex+"】,请选择正确的性别!","info",function(){
						$('#Sex').next('span').find('input').focus();
					});
					return false;
				}
	}

	//	PIBI_DOB	生日	4
	var DOB=$("#DOB").val();
	if(DOB==""){ Age_Change() } //年龄转换成生日
	else { 
		var flag=DOB_OnBlur();
		if(flag==false){return  false;}
			
		}
	var iDOB=$("#DOB").val();
	var iiDOB=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",iDOB)
	var mydate = new Date();
	var CurMonth=mydate.getMonth()+1;
	if((CurMonth<=9)&&(CurMonth>=0)){var CurMonth="0"+CurMonth;}
	var CurDate=mydate.getFullYear()+"-"+CurMonth+"-"+ mydate.getDate(); 
	var CurDate=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",CurDate)
	if(iiDOB>CurDate) {
		$.messager.alert("提示","出生日期不能大于当前日期.","info");
		return false;
	}

	//	PIBI_PatType_DR	客人类型	5
	var iPatType_DR=$("#PatType_DR_Name").combobox('getValue');

	
	//	PIBI_Tel2	电话号码2	7
	var iTel2=$("#Tel2").val();
    iTel2=trim(iTel2);
	if (iTel2!=""){
		if (!CheckTelOrMobile(iTel2,"Tel2","")) return false;
		
	}
	//	PIBI_MobilePhone	移动电话	8
	var iMobilePhone=$("#MobilePhone").val();
	iMobilePhone=trim(iMobilePhone);
	if (iMobilePhone==""){
		$.messager.alert("提示","移动电话不能为空!","info",function(){
			$("#MobilePhone").focus();
		});
		return false;
	}else{
		
		if (!CheckTelOrMobile(iMobilePhone,"MobilePhone","")) return false;
	}
	
	

	//	PIBI_Tel1	电话号码1	6
	var iTel1=$("#Tel1").val();
	iTel1=trim(iTel1);
	if (iTel1!=""){
		if (!CheckTelOrMobile(iTel1,"Tel1","")) return false;
		
	}
	//	PIBI_Vocation	职业	10
	var iVocation=$("#Vocation").combobox('getValue');
	

	//	PIBI_Position	职位	11
	var iPosition=$("#Position").val();

	//	PIBI_Company	公司	12
	var iCompany=$("#Company").val();

	//	PIBI_Postalcode	邮编	13
	var iPostalcode=$("#Postalcode").val();
	if(!IsPostalcode(iPostalcode)){
		$("#Postalcode").focus();
		return;
	}

	//	PIBI_Address	联系地址	14
	var iAddress=$("#Address").val();

	//	PIBI_Nation	民族	15
	var iNationDesc=""
	var iNation=$("#CTNationDR").combobox('getValue');

	//	PIBI_Email	电子邮件	16
	var iEmail=$("#Email").val();
	 if(!IsEMail(iEmail)){
 
		 $("#Email").focus();
			return;
		}

	//	PIBI_Married	婚姻状况	17
	var iMarriedDR=$("#Married_DR_Name").combobox('getValue');

	//	PIBI_Blood	血型	18
    var iBloodDR=$("#Blood_DR_Name").combobox('getValue');
	
	//	PIBI_UpdateDate	日期	19
	var iUpdateDate='';
 
   	//VIP
 	//var iVIPLevel=$("#VIPLevel").combobox('getValue');
     var iVIPLevel=""
	//	PIBI_UpdateUser_DR	更新人	20
	var iUpdateUserDR=session['LOGON.USERID'];

	// /////////////////////       数据验证          ////////////////////////////////////
	//根据流程的不同?处理登记号
	//var FIBIUpdateModel=tkMakeServerCall("web.DHCPE.Public.Setting","GetPAPMINoGenModel")
	if ("NoGen"==FIBIUpdateModel) {}
	if ("Gen"==FIBIUpdateModel) {
		// 登记号必须
		if (""==iPAPMINo) {
			$.messager.alert("提示","登记号不能为空!","info",function(){$("#PAPMINo").focus();});
			return false;
		} 
	}
	if ("FreeCreate"==FIBIUpdateModel) {
		// 登记号必须
		if (""==iPAPMINo) {
			$.messager.alert("提示","登记号不能为空!","info",function(){$("#PAPMINo").focus();});
			return false;
		
		}
		if (isNaN(iPAPMINo)){
			$.messager.alert("提示","登记号不是数字!","info",function(){$("#PAPMINo").focus();});
			return false;
		}
	}
	// 患者类型必须
	if (""==iPatType_DR) {
			$.messager.alert("提示","类型不能为空!","info",function(){$("#PatType_DR_Name").focus();});
			return false	
	}

  
	// 生日必须
	if (""==iDOB) {
			$.messager.alert("提示","生日不能为空!","info",function(){$("#DOB").focus();});
			return false
		
	}
	
	var iHPNo=""
	var iHCPDR=""
	var iHCADR="";
	
	var iCardNo=$("#CardNo").val();
	var myCardTypeDR=$("#CardTypeRowID").val();
	
	if (iCardNo!="") iCardNo=iCardNo+"$"+myCardTypeDR;;

	var iMedicareCode="";
	var iMedicareCode=$("#MedicareCode").val();
	
	var CardRelate=tkMakeServerCall("web.DHCPE.HISUICommon","GetCardRelate")
	
	//证件类型
	var iPAPMICardType=""
	var iPAPMICardType=getValueById("PAPMICardType_DR_Name");
	if((iIDCard!="")&&(iPAPMICardType=="")){
		$.messager.alert("提示","证件类型不能为空!","info",function(){$("#PAPMICardType_DR_Name").focus();});
		return false
		
	}
    
    //体检特殊客户类型
	var iSpecialType=$("#SpecialType").combobox('getValue'); 

    //判断非医保，不能更新医保号,
    var PatFlag=""
    PatFlag=tkMakeServerCall("web.DHCBL.CARD.UCardRefInfo","GetInsurFlag",iPatType_DR)
   
   //alert(iPatType_DR)
    if((PatFlag=="0")&&(iMedicareCode!="")){    
	    $.messager.alert("提示","非医保病人,医保卡号不可填","info");
		return false;
	    
	    }
	if((PatFlag!="0")&&(iMedicareCode=="")){
	    $.messager.alert("提示","医保病人,请填写正确的医保卡号","info");
		return false;
	    
	    }
	    
	    
	   
	
	var Instring=$.trim(iRowId)			//			1 
				+"^"+$.trim(iPAPMINo)			//登记号		2
				+"^"+$.trim(iName)			//姓名		3
				+"^"+$.trim(iSex_DR)			//性别		4
				+"^"+$.trim(iDOB)				//生日		5
				+"^"+$.trim(iPatType_DR)		//客人类型	6
				+"^"+$.trim(iTel1)			//电话号码1	7
				+"^"+$.trim(iTel2)			//电话号码2	8
				+"^"+$.trim(iMobilePhone)		//移动电话	9
				+"^"+$.trim(iIDCard)			//身份证号	10
				+"^"+$.trim(iVocation)		//职业		11
				+"^"+$.trim(iPosition)		//职位		12
				+"^"+$.trim(iCompany)			//公司		13
				+"^"+$.trim(iPostalcode)		//邮编		14
				+"^"+$.trim(iAddress)			//联系地址	15
				+"^"+$.trim(iNation)			//民族		16
				+"^"+$.trim(iEmail)			//电子邮件	17
				+"^"+$.trim(iMarriedDR)		//婚姻状况	18
				+"^"+$.trim(iBloodDR)			//血型		19
				+"^"+$.trim(iUpdateDate)		//日期		20
				+"^"+$.trim(iUpdateUserDR)	//更新人	21
				+"^"+iHPNo
				+"^"+iHCPDR
				+"^"+iHCADR
				+"^"+$.trim(iCardNo)
				+"^"+$.trim(iVIPLevel)
				+"^"+$.trim(iMedicareCode)
				+"^"+$.trim(iPAPMICardType)
				+"^"+iSpecialType
				+";"+FIBIUpdateModel
				
				;
				
			//alert(Instring)
		var flag=tkMakeServerCall("web.DHCPE.PreIBIUpdate","Save",'','',Instring);
	  
	
		var Data=flag.split("^");
		flag=Data[0];
		iRowId=Data[1];
		iRegNo=Data[2];
	
	
		
	if (flag=='0') {
			$.messager.alert("提示","更新成功!","info"); 
		
			
			if($("#RowId").val()==""){
		   		$("#RowId").val(iRowId);
		   		}

		Clear_click(1,iRegNo);
		return;
		}
		else {
			$.messager.alert("提示","更新错误，错误号："+flag,"error");
			return false;
		
	}
}



function trim(s) {
	if (""==s) { return "";}
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
    return (m == null) ? "" : m[1];
}
function InitCombobox()
{
	
	  //性别   
		var SexObj = $HUI.combobox("#Sex_DR_Name",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindSex&ResultSetType=array",
		valueField:'id',
		textField:'sex'
		})
	
	  /*
	 //VIP等级  
		var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		})
		*/
		
	//婚姻  
		var MarriedObj = $HUI.combobox("#Married_DR_Name",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindMarried&ResultSetType=array",
		valueField:'id',
		textField:'married'
		})

	//证件类型
		var PAPMICardTypeObj = $HUI.combobox("#PAPMICardType_DR_Name",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPAPMICardType&ResultSetType=array",
		valueField:'id',
		textField:'type'
		})
		
	//职业
		var VocationObj = $HUI.combobox("#Vocation",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindOccupation&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		})

	
	//血型
		var BloodObj = $HUI.combobox("#Blood_DR_Name",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindBlood&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		})
		
	//类型
		var PatTypeObj = $HUI.combobox("#PatType_DR_Name",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPatType&ResultSetType=array&HospID="+session['LOGON.HOSPID'],
		valueField:'id',
		textField:'desc'
		})
		
	//民族
		var CTNationObj = $HUI.combobox("#CTNationDR",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindNation&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		})
		
	//特殊客户类型 
		var SpecialTypeObj = $HUI.combobox("#SpecialType",{
		url:$URL+"?ClassName=web.DHCPE.SpecialType&QueryName=FindSPType&ResultSetType=array",
		valueField:'id',
		textField:'Desc'
		})

	
	
}

/*

function SetPatInfoByXML(XMLStr)
{
	XMLStr = "<?xml version='1.0' encoding='gb2312'?>" + XMLStr
	var xmlDoc=DHCDOM_CreateXMLDOMNew(XMLStr);
	if (!xmlDoc) return;
	
	//var xmlDoc=DHCDOM_CreateXMLDOM();
	//xmlDoc.async = false;
	//xmlDoc.loadXML(XMLStr);
	
	//if(xmlDoc.parseError.errorCode != 0) 
	//{    
		//$.messager.alert("提示",xmlDoc.parseError.reason,"info");
		//return; 
	//}
	
	var nodes = xmlDoc.documentElement.childNodes;
	if (nodes.length<=0){return;}
	for (var i = 0; i < nodes.length; i++) {

		
		//var myItemName=nodes(i).nodeName;
		//var myItemValue= nodes(i).text;
		
		var myItemName = getNodeName(nodes,i);
		
		var myItemValue = getNodeValue(nodes,i);
		if(myItemName=="Name") $("#Name").val(myItemValue);
		if(myItemName=="Address") $("#Address").val(myItemValue);
	  
	  
		
		
		if (myCombAry[myItemName]){
			myCombAry[myItemName].setComboValue(myItemValue);

		}else{
			DHCWebD_SetObjValueXMLTrans(myItemName, myItemValue);
		}
	}
	delete(xmlDoc);
}

*/

function SetPatInfoByXML(XMLStr)
{
	XMLStr = "<?xml version='1.0' encoding='gb2312'?>" + XMLStr
	var xmlDoc=DHCDOM_CreateXMLDOMNew(XMLStr);
	
	if (!xmlDoc) return;
	

	var nodes = xmlDoc.documentElement.childNodes;
	if (nodes.length<=0){return;}

	for (var i = 0; i < nodes.length; i++) {

		var myItemName = getNodeName(nodes,i);
	
		var myItemValue = getNodeValue(nodes,i);
		
		//姓名
		if(myItemName=="Name") {$("#Name").val(myItemValue);}
		//地址
		if(myItemName=="Address") {$("#Address").val(myItemValue);}
		//性别
	    if(myItemName=="Sex") $("#Sex_DR_Name").combobox('setValue',myItemValue);
	    //民族
	   	if(myItemName=="NationDesc") {
		   var NationDR=tkMakeServerCall("web.DHCPE.PreCommon","GetNationDR",myItemValue)
		   $("#CTNationDR").combobox('setValue',NationDR);
		  
	   }
	   
	   //出生日期
	   if(myItemName=="Birth") 
		{
			var mybirth=myItemValue;
		if(mybirth!=""){
		  if (dtformat=="YMD"){
			 if (mybirth.length==10){
			var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(5,7)+"-"+mybirth.substring(8,10)
 	 		}else{
 			var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(4,6)+"-"+mybirth.substring(6,8) 
  			}
		}
		if (dtformat=="DMY"){
			if (mybirth.length==10){
				var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(5,7)+"-"+mybirth.substring(8,10)
  			}else{
				var mybirth=mybirth.substring(6,8)+"/"+mybirth.substring(4,6)+"/"+mybirth.substring(0,4)
 			}
		}
		 }
			$("#DOB").val(mybirth);
			 var myAge=tkMakeServerCall("web.DHCDocCommon","GetAgeDescNew",mybirth,"");
			$("#Age").val(myAge);

		}
		
	//身份证号
	 if(myItemName=="CredNo") {$("#IDCard").val(myItemValue);}
	
	//照片
	 if(myItemName=="PhotoInfo") {$("#PhotoInfo").val(myItemValue);}
	
		
	if (myCombAry[myItemName]){
			myCombAry[myItemName].setComboValue(myItemValue);

		}else{
			
			//DHCWebD_SetObjValueXMLTrans(myItemName, myItemValue);  //封装的谷歌浏览器不支持
		}
	}
	delete(xmlDoc);
}

//验证电话或移动电话
function CheckTelOrMobile(telephone,Name,Type){
	if (isMoveTel(telephone)) return true;
	if (telephone.indexOf('-')>=0){
		$.messager.alert("提示",Type+"固定电话长度错误,固定电话区号长度为【3】或【4】位,固定电话号码长度为【7】或【8】位,并以连接符【-】连接,请核实!","info",function(){
			$("#"+Name).focus();
		});
        return false;
	}else{
		if(telephone.length!=11){
			$.messager.alert("提示",Type+"联系电话电话长度应为【11】位,请核实!","info",function(){
				$("#"+Name).focus();
			});
	        return false;
		}else{
			$.messager.alert("提示",Type+"不存在该号段的手机号,请核实!","info",function(){
				$("#"+Name).focus();
			});
	        return false;
		}
	}
	return true;
}
/* 
用途：检查输入是否正确的电话和手机号 
输入： 电话号
value：字符串 
返回： 如果通过验证返回true,否则返回false 
*/  
function isMoveTel(telephone){
 	
	var teleReg1 = /^((0\d{2,3})-)(\d{7,8})$/;
	var teleReg2 = /^((0\d{2,3}))(\d{7,8})$/; 
	var mobileReg =/^1[3|4|5|6|7|8|9][0-9]{9}$/;
	if (!teleReg1.test(telephone)&& !teleReg2.test(telephone) && !mobileReg.test(telephone)){ 
		return false; 
	}else{ 
		return true; 
	} 

}


function isIdCardNo(pId){
	pId=pId.toLowerCase();
    var arrVerifyCode = [1,0,"x",9,8,7,6,5,4,3,2]; 
    var Wi = [7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2]; 
    var Checker = [1,9,8,7,6,5,4,3,2,1,1]; 
    if(pId.length != 15 && pId.length != 18){
		 $.messager.alert("提示","身份证号共有15位或18位","info");
		return false;
    }
    var Ai=pId.length==18?pId.substring(0,17):pId.slice(0,6)+"19"+pId.slice(6,15); 
    
    if (!/^\d+$/.test(Ai))
    {
	     $.messager.alert("提示","身份证除最后一位外必须为数字","info");
    	return false;
    }
    var yyyy=Ai.slice(6,10), mm=Ai.slice(10,12)-1, dd=Ai.slice(12,14);
    var d=new Date(yyyy,mm,dd) , now=new Date(); 
    var year=d.getFullYear() , mon=d.getMonth() , day=d.getDate();
    if (year!=yyyy||mon!=mm||day!=dd||d>now||year<1901){
	    $.messager.alert("提示","身份证输入错误","info");
	    return false;
    }
	for(var i=0,ret=0;i<17;i++) ret+=Ai.charAt(i)*Wi[i]; 
	Ai+=arrVerifyCode[ret%=11];
	
	if (pId.length == 18){
		if(!validId18(pId)){
			 $.messager.alert("提示","身份证号码有误,请检查!","info");
			return false;
		}
	}
	if (pId.length == 15){
		if(!validId15(pId)){
			 $.messager.alert("提示","身份证号码有误,请检查!","info");
			return false;
		}
	}
	return true;
}

function GetInfoFromIDCard(pId){
	 
    var pId=Get18IdFromCardNo(pId)
    if (pId==""){
			return ["0","","","","","",""];
		}
	
    var id=String(pId);
    if (id.length==18){
	    var sex=id.slice(14,17)%2?"男":"女";
			///prov=areaCode[id.slice(0,6)] || areaCode[id.slice(0,4)] || areaCode[id.slice(0,2)] || "未知地区";
	    var prov="";
	    ///var birthday=(new Date(id.slice(6,10),id.slice(10,12)-1,id.slice(12,14))).toLocaleDateString();
	    var myMM=(id.slice(10,12)).toString();
	    var myDD=id.slice(12,14).toString();
	    var myYY=id.slice(6,10).toString();
	  }else{
	  	var prov="";
	  	var sex=id.slice(14,15)%2?"男":"女";
	    var myMM=(id.slice(8,10)).toString();
	    var myDD=id.slice(10,12).toString();
	    var myYY=id.slice(6,8).toString();
			if(parseInt(myYY)<10) {
				myYY = '20'+myYY;
			}else{
				myYY = '19'+myYY;
			} 
	    
	  }
    var myMM=myMM.length==1?("0"+myMM):myMM;
    var myDD=myDD.length==1?("0"+myDD):myDD;
    var sysDateFormat=tkMakeServerCall('websys.Conversions','DateFormat');
    if (sysDateFormat=="3"){
	    var birthday=myYY+"-"+ myMM +"-"+myDD;
	}
    if (sysDateFormat=="4"){
	    var birthday=myDD+"/"+ myMM +"/"+myYY;
	}
    var myAge=DHCWeb_GetAgeFromBirthDayA(birthday);
    
    return ["1",prov,birthday,sex, myAge];
}

function Get18IdFromCardNo(pId){
	
	pId=pId.toLowerCase();
	
    var arrVerifyCode = [1,0,"x",9,8,7,6,5,4,3,2]; 
    var Wi = [7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2]; 
    var Checker = [1,9,8,7,6,5,4,3,2,1,1]; 

    if(pId.length != 15 && pId.length != 18){
		alert("身份证号共有 15位或18位"); 
		return "";
    }
	if (pId.length == 18){
		if(!validId18(pId)){
			alert("身份证号码有误,请检查!");
			return "";
		}
	}
	if (pId.length == 15){
		if(!validId15(pId)){
			alert("身份证号码有误,请检查!");
			return "";
		}
	}
    var Ai=pId.length==18?pId.substring(0,17):pId.slice(0,6)+"19"+pId.slice(6,15); 
    
    if (!/^\d+$/.test(Ai))
    {
    	alert("身份证除最后一位外必须为数字");
    	return "";
    }
    var yyyy=Ai.slice(6,10), mm=Ai.slice(10,12)-1, dd=Ai.slice(12,14);
    var d=new Date(yyyy,mm,dd) , now=new Date(); 
    var year=d.getFullYear() , mon=d.getMonth() , day=d.getDate();
    if (year!=yyyy||mon!=mm||day!=dd||d>now||year<1901){
	    alert( "身份证输入错误");
	    return "";
    }
    
    
	for(var i=0,ret=0;i<17;i++) ret+=Ai.charAt(i)*Wi[i]; 
	Ai+=arrVerifyCode[ret%=11];
	
	return Ai;
}
var picType=".jpg"
var PicFilePath="D:\\"
function BPhoto_click()
{   
   var PAPMINo ="" 
    PAPMINo=getValueById('PAPMINo')
    
	//保存为jpg文件
	var PatientID=tkMakeServerCall("web.DHCPE.PreIADM","GetPatientID",PAPMINo);

	if(PatientID==""){
		$.messager.alert("提示","基本信息ID不能为空。","info");
		return;
	}
	
	var userAgent = navigator.userAgent;
	var isChrome =  navigator.userAgent.indexOf('Chrome') > -1
	if(isChrome){
		
	var PicHeight=300;
    var Picwidth=200;
    PEPhoto.FileName=PicFilePath+PAPMINo+picType; //保存图片的名称包括后缀
    if (PhotoFtpInfo==""){
        PEPhoto.FTPFlag="0" //是否上传到ftp服务器  0
    }else{
        var FTPArr=PhotoFtpInfo.split("^");
        PEPhoto.DBFlag = "0" //是否保存到数据库  0  1
        PEPhoto.FTPFlag = "1" //是否保存到FTP  0  1
        PEPhoto.AppName = FTPArr[4]+"/" //ftp目录
        PEPhoto.FTPString = FTPArr[0]+"^"+FTPArr[1]+"^"+FTPArr[2]+"^"+FTPArr[3] //FTP服务器
        //PicHeight=FTPArr[5];
        //Picwidth=FTPArr[6];
    }
    PEPhoto.PicWidth=Picwidth;
    PEPhoto.PicHeight=PicHeight;
    PEPhoto.PatientID=PatientID //PA_PatMas表的ID
    PEPhoto.ShowWin()
    InitPicture()    
	/*
	$HUI.window("#PhotoWin",{
		title:"体检拍照",
		iconCls:"icon-w-stamp",
		collapsible:false,
		minimizable:false,
		maximizable:false,
		closable:true,
		resizable:false,
		modal:true,
		width:800,
		height:600,
		content:'<iframe src="dhcpephotochrome.csp?RegNo='+PAPMINo+'" width="100%" height="100%" frameborder="0"></iframe>'
	});
	*/
	}
	
	
	else
	{
	$HUI.window("#PhotoWin",{
		title:"体检拍照",
		iconCls:"icon-w-stamp",
		collapsible:false,
		minimizable:false,
		maximizable:false,
		closable:true,
		resizable:false,
		modal:true,
		width:800,
		height:600,
		content:'<iframe src="dhcpephoto.csp?RegNo='+PAPMINo+'" width="100%" height="100%" frameborder="0"></iframe>'
	});
	}
	//$('#PhotoWin').window('close');
	//var lnk="dhcpephoto.csp?RegNo="+PAPMINo;
	//var ret=window.showModalDialog(lnk, "", "dialogwidth:800px;dialogheight:600px;center:1"); 
	//InitPicture()
}

function Age_Change()
{    
	//年龄
	var iAge=$("#Age").val();
	if (iAge=="") return;
	
	if (!(isNaN(iAge)))
	{
		if ($("#DOB").val()!="") return;
		iAge=parseInt(iAge)
		var D   =   new   Date();
	    var Year=D.getFullYear();
	    var Year=Year-iAge
		var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat")
	    if(dtformat=="DMY"){ $("#DOB").val("01/"+"01/"+Year);}
	    if(dtformat=="YMD"){ $("#DOB").val(Year+"-01"+"-01");}
	    
	}
	
}


function DOB_OnBlur()
{
	
	var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat")
	var mybirth=$("#DOB").val();
	
	if ((mybirth!="")&&((mybirth.length!=8)&&((mybirth.length!=10)))){
		$.messager.alert("提示","请输入正确的出生日期!","info",function(){
			$("#DOB").addClass("newclsInvalid"); 
			$("#DOB").focus();
		});
		return false;
	}
	$("#DOB").removeClass("newclsInvalid")
	if ((mybirth.length==8)){
	
		if (dtformat=="YMD"){
			var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(4,6)+"-"+mybirth.substring(6,8)
		}
		if (dtformat=="DMY"){
			var mybirth=mybirth.substring(6,8)+"/"+mybirth.substring(4,6)+"/"+mybirth.substring(0,4)
		}
       $("#DOB").val(mybirth)
		
	}
	
    if (mybirth!="") {
		if (dtformat=="YMD"){
			var reg=/^(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)$/;
		}
		if (dtformat=="DMY"){
			var reg=/^(((0[1-9]|[12][0-9]|3[01])\/((0[13578]|1[02]))|((0[1-9]|[12][0-9]|30)\/(0[469]|11))|(0[1-9]|[1][0-9]|2[0-8])\/(02))\/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3}))|(29\/02\/(([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00)))$/;
		}
		var ret=mybirth.match(reg);
	
	  if(ret==null){
		    $.messager.alert("提示","请输入正确的出生日期!","info",function(){
				$("#DOB").addClass("newclsInvalid"); 
				$("#DOB").focus();
			});
			return false;
		}
	    if (dtformat=="YMD"){
		  var myrtn=DHCWeb_IsDate(mybirth,"-")
	  }
	  if (dtformat=="DMY"){
		  var myrtn=DHCWeb_IsDate(mybirth,"/")
	  }

	
	
	if (!myrtn){
	
		$.messager.alert("提示","请输入正确的出生日期!","info",function(){
				$("#DOB").addClass("newclsInvalid"); 
				$("#DOB").focus();
			});
			
			return false;
			
	}else{
			var mybirth1=$("#DOB").val();
			var Checkrtn=CheckBirth(mybirth1);
			if(Checkrtn==false){
				$.messager.alert("提示","出生日期不能大于今天或者小于、等于1840年!","info",function(){
					$("#DOB").addClass("newclsInvalid"); 
					$("#DOB").focus();
				});
				return false;
			}
			var myAge=DHCWeb_GetAgeFromBirthDay("DOB");
			$("#Age").val(myAge);
		}
	}else{
		$("#DOB").removeClass("newclsInvalid");
	}
	

}

function CheckBirth(Birth)
{
	var Year,Mon,Day,Str;
	var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat")
	if (dtformat=="YMD"){
			Str=Birth.split("-")
			Year=Str[0];
			Mon=Str[1];
			Day=Str[2];
			
		}
		if (dtformat=="DMY"){
			Str=Birth.split("/")
			Year=Str[2];
			Mon=Str[1];
			Day=Str[0];
			
		}

	
	var Today,ToYear,ToMon,ToDay;
	Today=new Date();
	//ToYear=Today.getYear();
	ToYear=Today.getFullYear();
	ToMon=(Today.getMonth()+1);
	ToDay=Today.getDate();
	if((Year > ToYear)||(Year<=1840)){
		return false;
	}
	else if((Year==ToYear)&&(Mon>ToMon)){
		return false;
	}
	else if((Year==ToYear)&&(Mon==ToMon)&&(Day>ToDay)){
		return false;
	}
	else return true;
}
