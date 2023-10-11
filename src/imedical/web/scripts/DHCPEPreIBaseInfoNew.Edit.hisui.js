//����  DHCPEPreIBaseInfoNew.Edit.hisui.js
//����	���˻�����Ϣά��
//����	2020.11.04
//������  xy
var myCombAry=new Array(); 
$(function(){
	 
	InitCombobox();
	
		
	//����
	$("#Update").click(function() {	
		Update_click();		
        });
	
	//���� 
	$("#BPhoto").click(function() {	
		BPhoto_click();		
        });
   
   //�����֤  
   	$("#ReadRegInfo").click(function() {	
		ReadRegInfo_OnClick();		
        });

	//����  
	$("#ReadCard").click(function() {	
		ReadCardClickHandler();		
        });

	//����
	$("#Clear").click(function() {	
		Clear_click("","");		
        });
        
     //����
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
	if((iPAPMICardType.indexOf("���֤")!="-1")&&(num!="")){
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
		title:"��Ϣ�б�",
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
			{field:'PIBI_PAPMINo',width:'100',title:'�ǼǺ�'},
			{field:'PIBI_Name',width:'80',title:'����'},
			{field:'PIBI_Sex_DR_Name',width:'60',title:'�Ա�'},
			{field:'PIBI_DOB',width:'100',title:'��������'},
			{field:'PIBI_IDCard',width:'150',title:'���֤��'},
			{field:'PIBI_Married_DR_Name',width:'70',title:'����״��'},
			{field:'PIBI_MobilePhone',width:'110',title:'�绰����'}	
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



//����
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
		$.messager.popover({msg: "����Ч!", type: "info"});
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
	     
		 //Sex �Ա�
      var mySexobj=document.getElementById("Sex");
      if (mySexobj){$("#Sex_DR_Name").combobox('setValue',mySexobj.value);}
		
		//NationDesc ����
	   var myNationDescobj=document.getElementById("NationDesc");
	   if (myNationDescobj){
		  var NationDR=tkMakeServerCall("web.DHCPE.PreCommon","GetNationDR",myNationDescobj.value)
		   $("#CTNationDR").combobox('setValue',NationDR);
	   }

		
     
	 //��������
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
		var NoExistSrc="../images/uiimages/patdefault.png"; // //û�б�����Ƭʱ��ʾ��ͼƬ
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
		var NoExistSrc="../images/uiimages/patdefault.png"; // //û�б�����Ƭʱ��ʾ��ͼƬ
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
			$.messager.popover({msg: "������Ա,�������������Ϣά���������", type: "info"});
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
   //���ݵǼǺŴ��������� 
	var CardTypeNewStr=tkMakeServerCall("web.DHCPE.PreIBIUpdate","CardTypeByRegNo",$("#PAPMINo").val());
	
	if(CardTypeNewStr!=""){
			var CardTypeNewID=CardTypeNewStr.split("^")[0];
			var CardTypeNew=CardTypeNewStr.split("^")[1];
		    $("#CardTypeNew").val(CardTypeNew);
		}
	var HospID=session['LOGON.HOSPID'];
    iPAPMINo=iPAPMINo+"$"+CardTypeNewID+"$"+HospID;
	FindPatDetail(iPAPMINo);
	
   //����
   var myCardNo=$("#CardNo").val();

	
	InitPicture();
	
	
}

//	ID ��ʽ RowId^PAPMINo^Name
function FindPatDetail(ID){
	
	var Instring=ID;
	var flag=tkMakeServerCall("web.DHCPE.PreIBaseInfo","DocListBroker",'SetPatient','',Instring)
	
}
function SetPatient(value) {
 
	if ((""==value)&&(";"==value)) { return false; }
	var Data=value.split(";");
	if(value.split("^")[2]=="δ�ҵ���¼"){
		$.messager.popover({msg: "HIS����δ�ҵ���Ϣ", type: "info"});
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
		
		//	PIBI_Name	����	2
		$("#Name").val("δ�ҵ����߼�¼");
		
		if ("NoGen"==FIBIUpdateModel) { $("#PatType_DR_Name").focus(); }
		if ("Gen"==FIBIUpdateModel) { $("#PAPMINo").focus(); }
		
		
}
//
function SetPatient_Sel(value) {

   
    $("#Update").linkbutton('enable');
	IBISetPatient_Sel(value);
		//���ݵǼǺŴ��������� 
	var CardTypeNewStr=tkMakeServerCall("web.DHCPE.PreIBIUpdate","CardTypeByRegNo",$("#PAPMINo").val());
	if(CardTypeNewStr!=""){
			var CardTypeNewID=CardTypeNewStr.split("^")[0];
			var CardTypeNew=CardTypeNewStr.split("^")[1];
		    $("#CardTypeNew").val(CardTypeNew);
		    $("#CardTypeRowID").val(CardTypeNewID);
		}
		
	InitPicture();
	/*
	//���ݵǼǺŴ���������  (��Ϊ��������Clear_click()�������)
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
	//�Ա�
	$("#Sex_DR_Name").combobox('setValue',SexNV[1]);
	//����
	$("#PatType_DR_Name").combobox('setValue',SexNV[0]);
	//֤������
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

//����������Ϣ
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
	
	//PIBI_PAPMINo	�ǼǺ�	1	
	var iPAPMINo=$("#PAPMINo").val();
	if(iPAPMINo!=""){
			var iPAPMINo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iPAPMINo);
			$("#PAPMINo").val(iPAPMINo)
   		 var flag=tkMakeServerCall("web.DHCPE.PreIADM","JudgeIGByRegNo",iPAPMINo);
		if(flag=="G"){
			$.messager.alert("��ʾ","������Ա,�������������Ϣά���������",'info');
	    	return false;
		}
	}
	
	//	PIBI_Name	����	2
	var iName=$("#Name").val();
	
	// ��������
	if (""==iName) {
			$.messager.alert("��ʾ","��������Ϊ��!","info",function(){$("#Name").focus();});
			return false
	}

	//	PIBI_Sex_DR	�Ա�	3
	var iSex_DR=$("#Sex_DR_Name").combobox('getValue');
   // �Ա����
	if (""==iSex_DR) {
			$.messager.alert("��ʾ","�Ա���Ϊ��!","info",function(){$("#Sex_DR_Name").focus();});
			return false
	}

	//	PIBI_IDCard	���֤��	9
	var iIDCard=$("#IDCard").val();
	iIDCard=trim(iIDCard)

	var iPAPMICardType=""
	var iPAPMICardType=$("#PAPMICardType_DR_Name").combobox('getText');
	if((iPAPMICardType.indexOf("���֤")!="-1")&&(iIDCard!="")){
		
		var myIsID=isIdCardNo(iIDCard);
		
				if (!myIsID){
					$("#IDCard").focus();
					return false;
				}
				var IDNoInfoStr=GetInfoFromIDCard(iIDCard)
				var IDBirthday=IDNoInfoStr[2]
				var myBirth=getValueById('DOB'); 
				if (myBirth!=IDBirthday){
					$.messager.alert("��ʾ","�������������֤��Ϣ����!","info",function(){
						$("#Birth").focus();
					});
		   		    return false;
				}
				var IDSex=IDNoInfoStr[3]
				var mySex=getValueById('Sex_DR_Name');
				var mySex=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSexDescByID",mySex)
				//alert(mySex+"^"+IDSex)
				if(mySex!=IDSex){
					$.messager.alert("��ʾ","���֤��:"+iIDCard+"��Ӧ���Ա��ǡ�"+IDSex+"��,��ѡ����ȷ���Ա�!","info",function(){
						$('#Sex').next('span').find('input').focus();
					});
					return false;
				}
	}

	//	PIBI_DOB	����	4
	var DOB=$("#DOB").val();
	if(DOB==""){ Age_Change() } //����ת��������
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
		$.messager.alert("��ʾ","�������ڲ��ܴ��ڵ�ǰ����.","info");
		return false;
	}

	//	PIBI_PatType_DR	��������	5
	var iPatType_DR=$("#PatType_DR_Name").combobox('getValue');

	
	//	PIBI_Tel2	�绰����2	7
	var iTel2=$("#Tel2").val();
    iTel2=trim(iTel2);
	if (iTel2!=""){
		if (!CheckTelOrMobile(iTel2,"Tel2","")) return false;
		
	}
	//	PIBI_MobilePhone	�ƶ��绰	8
	var iMobilePhone=$("#MobilePhone").val();
	iMobilePhone=trim(iMobilePhone);
	if (iMobilePhone==""){
		$.messager.alert("��ʾ","�ƶ��绰����Ϊ��!","info",function(){
			$("#MobilePhone").focus();
		});
		return false;
	}else{
		
		if (!CheckTelOrMobile(iMobilePhone,"MobilePhone","")) return false;
	}
	
	

	//	PIBI_Tel1	�绰����1	6
	var iTel1=$("#Tel1").val();
	iTel1=trim(iTel1);
	if (iTel1!=""){
		if (!CheckTelOrMobile(iTel1,"Tel1","")) return false;
		
	}
	//	PIBI_Vocation	ְҵ	10
	var iVocation=$("#Vocation").combobox('getValue');
	

	//	PIBI_Position	ְλ	11
	var iPosition=$("#Position").val();

	//	PIBI_Company	��˾	12
	var iCompany=$("#Company").val();

	//	PIBI_Postalcode	�ʱ�	13
	var iPostalcode=$("#Postalcode").val();
	if(!IsPostalcode(iPostalcode)){
		$("#Postalcode").focus();
		return;
	}

	//	PIBI_Address	��ϵ��ַ	14
	var iAddress=$("#Address").val();

	//	PIBI_Nation	����	15
	var iNationDesc=""
	var iNation=$("#CTNationDR").combobox('getValue');

	//	PIBI_Email	�����ʼ�	16
	var iEmail=$("#Email").val();
	 if(!IsEMail(iEmail)){
 
		 $("#Email").focus();
			return;
		}

	//	PIBI_Married	����״��	17
	var iMarriedDR=$("#Married_DR_Name").combobox('getValue');

	//	PIBI_Blood	Ѫ��	18
    var iBloodDR=$("#Blood_DR_Name").combobox('getValue');
	
	//	PIBI_UpdateDate	����	19
	var iUpdateDate='';
 
   	//VIP
 	//var iVIPLevel=$("#VIPLevel").combobox('getValue');
     var iVIPLevel=""
	//	PIBI_UpdateUser_DR	������	20
	var iUpdateUserDR=session['LOGON.USERID'];

	// /////////////////////       ������֤          ////////////////////////////////////
	//�������̵Ĳ�ͬ?����ǼǺ�
	//var FIBIUpdateModel=tkMakeServerCall("web.DHCPE.Public.Setting","GetPAPMINoGenModel")
	if ("NoGen"==FIBIUpdateModel) {}
	if ("Gen"==FIBIUpdateModel) {
		// �ǼǺű���
		if (""==iPAPMINo) {
			$.messager.alert("��ʾ","�ǼǺŲ���Ϊ��!","info",function(){$("#PAPMINo").focus();});
			return false;
		} 
	}
	if ("FreeCreate"==FIBIUpdateModel) {
		// �ǼǺű���
		if (""==iPAPMINo) {
			$.messager.alert("��ʾ","�ǼǺŲ���Ϊ��!","info",function(){$("#PAPMINo").focus();});
			return false;
		
		}
		if (isNaN(iPAPMINo)){
			$.messager.alert("��ʾ","�ǼǺŲ�������!","info",function(){$("#PAPMINo").focus();});
			return false;
		}
	}
	// �������ͱ���
	if (""==iPatType_DR) {
			$.messager.alert("��ʾ","���Ͳ���Ϊ��!","info",function(){$("#PatType_DR_Name").focus();});
			return false	
	}

  
	// ���ձ���
	if (""==iDOB) {
			$.messager.alert("��ʾ","���ղ���Ϊ��!","info",function(){$("#DOB").focus();});
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
	
	//֤������
	var iPAPMICardType=""
	var iPAPMICardType=getValueById("PAPMICardType_DR_Name");
	if((iIDCard!="")&&(iPAPMICardType=="")){
		$.messager.alert("��ʾ","֤�����Ͳ���Ϊ��!","info",function(){$("#PAPMICardType_DR_Name").focus();});
		return false
		
	}
    
    //�������ͻ�����
	var iSpecialType=$("#SpecialType").combobox('getValue'); 

    //�жϷ�ҽ�������ܸ���ҽ����,
    var PatFlag=""
    PatFlag=tkMakeServerCall("web.DHCBL.CARD.UCardRefInfo","GetInsurFlag",iPatType_DR)
   
   //alert(iPatType_DR)
    if((PatFlag=="0")&&(iMedicareCode!="")){    
	    $.messager.alert("��ʾ","��ҽ������,ҽ�����Ų�����","info");
		return false;
	    
	    }
	if((PatFlag!="0")&&(iMedicareCode=="")){
	    $.messager.alert("��ʾ","ҽ������,����д��ȷ��ҽ������","info");
		return false;
	    
	    }
	    
	    
	   
	
	var Instring=$.trim(iRowId)			//			1 
				+"^"+$.trim(iPAPMINo)			//�ǼǺ�		2
				+"^"+$.trim(iName)			//����		3
				+"^"+$.trim(iSex_DR)			//�Ա�		4
				+"^"+$.trim(iDOB)				//����		5
				+"^"+$.trim(iPatType_DR)		//��������	6
				+"^"+$.trim(iTel1)			//�绰����1	7
				+"^"+$.trim(iTel2)			//�绰����2	8
				+"^"+$.trim(iMobilePhone)		//�ƶ��绰	9
				+"^"+$.trim(iIDCard)			//���֤��	10
				+"^"+$.trim(iVocation)		//ְҵ		11
				+"^"+$.trim(iPosition)		//ְλ		12
				+"^"+$.trim(iCompany)			//��˾		13
				+"^"+$.trim(iPostalcode)		//�ʱ�		14
				+"^"+$.trim(iAddress)			//��ϵ��ַ	15
				+"^"+$.trim(iNation)			//����		16
				+"^"+$.trim(iEmail)			//�����ʼ�	17
				+"^"+$.trim(iMarriedDR)		//����״��	18
				+"^"+$.trim(iBloodDR)			//Ѫ��		19
				+"^"+$.trim(iUpdateDate)		//����		20
				+"^"+$.trim(iUpdateUserDR)	//������	21
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
			$.messager.alert("��ʾ","���³ɹ�!","info"); 
		
			
			if($("#RowId").val()==""){
		   		$("#RowId").val(iRowId);
		   		}

		Clear_click(1,iRegNo);
		return;
		}
		else {
			$.messager.alert("��ʾ","���´��󣬴���ţ�"+flag,"error");
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
	
	  //�Ա�   
		var SexObj = $HUI.combobox("#Sex_DR_Name",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindSex&ResultSetType=array",
		valueField:'id',
		textField:'sex'
		})
	
	  /*
	 //VIP�ȼ�  
		var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		})
		*/
		
	//����  
		var MarriedObj = $HUI.combobox("#Married_DR_Name",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindMarried&ResultSetType=array",
		valueField:'id',
		textField:'married'
		})

	//֤������
		var PAPMICardTypeObj = $HUI.combobox("#PAPMICardType_DR_Name",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPAPMICardType&ResultSetType=array",
		valueField:'id',
		textField:'type'
		})
		
	//ְҵ
		var VocationObj = $HUI.combobox("#Vocation",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindOccupation&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		})

	
	//Ѫ��
		var BloodObj = $HUI.combobox("#Blood_DR_Name",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindBlood&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		})
		
	//����
		var PatTypeObj = $HUI.combobox("#PatType_DR_Name",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPatType&ResultSetType=array&HospID="+session['LOGON.HOSPID'],
		valueField:'id',
		textField:'desc'
		})
		
	//����
		var CTNationObj = $HUI.combobox("#CTNationDR",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindNation&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		})
		
	//����ͻ����� 
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
		//$.messager.alert("��ʾ",xmlDoc.parseError.reason,"info");
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
		
		//����
		if(myItemName=="Name") {$("#Name").val(myItemValue);}
		//��ַ
		if(myItemName=="Address") {$("#Address").val(myItemValue);}
		//�Ա�
	    if(myItemName=="Sex") $("#Sex_DR_Name").combobox('setValue',myItemValue);
	    //����
	   	if(myItemName=="NationDesc") {
		   var NationDR=tkMakeServerCall("web.DHCPE.PreCommon","GetNationDR",myItemValue)
		   $("#CTNationDR").combobox('setValue',NationDR);
		  
	   }
	   
	   //��������
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
		
	//���֤��
	 if(myItemName=="CredNo") {$("#IDCard").val(myItemValue);}
	
	//��Ƭ
	 if(myItemName=="PhotoInfo") {$("#PhotoInfo").val(myItemValue);}
	
		
	if (myCombAry[myItemName]){
			myCombAry[myItemName].setComboValue(myItemValue);

		}else{
			
			//DHCWebD_SetObjValueXMLTrans(myItemName, myItemValue);  //��װ�Ĺȸ��������֧��
		}
	}
	delete(xmlDoc);
}

//��֤�绰���ƶ��绰
function CheckTelOrMobile(telephone,Name,Type){
	if (isMoveTel(telephone)) return true;
	if (telephone.indexOf('-')>=0){
		$.messager.alert("��ʾ",Type+"�̶��绰���ȴ���,�̶��绰���ų���Ϊ��3����4��λ,�̶��绰���볤��Ϊ��7����8��λ,�������ӷ���-������,���ʵ!","info",function(){
			$("#"+Name).focus();
		});
        return false;
	}else{
		if(telephone.length!=11){
			$.messager.alert("��ʾ",Type+"��ϵ�绰�绰����ӦΪ��11��λ,���ʵ!","info",function(){
				$("#"+Name).focus();
			});
	        return false;
		}else{
			$.messager.alert("��ʾ",Type+"�����ڸúŶε��ֻ���,���ʵ!","info",function(){
				$("#"+Name).focus();
			});
	        return false;
		}
	}
	return true;
}
/* 
��;����������Ƿ���ȷ�ĵ绰���ֻ��� 
���룺 �绰��
value���ַ��� 
���أ� ���ͨ����֤����true,���򷵻�false 
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
		 $.messager.alert("��ʾ","���֤�Ź���15λ��18λ","info");
		return false;
    }
    var Ai=pId.length==18?pId.substring(0,17):pId.slice(0,6)+"19"+pId.slice(6,15); 
    
    if (!/^\d+$/.test(Ai))
    {
	     $.messager.alert("��ʾ","���֤�����һλ�����Ϊ����","info");
    	return false;
    }
    var yyyy=Ai.slice(6,10), mm=Ai.slice(10,12)-1, dd=Ai.slice(12,14);
    var d=new Date(yyyy,mm,dd) , now=new Date(); 
    var year=d.getFullYear() , mon=d.getMonth() , day=d.getDate();
    if (year!=yyyy||mon!=mm||day!=dd||d>now||year<1901){
	    $.messager.alert("��ʾ","���֤�������","info");
	    return false;
    }
	for(var i=0,ret=0;i<17;i++) ret+=Ai.charAt(i)*Wi[i]; 
	Ai+=arrVerifyCode[ret%=11];
	
	if (pId.length == 18){
		if(!validId18(pId)){
			 $.messager.alert("��ʾ","���֤��������,����!","info");
			return false;
		}
	}
	if (pId.length == 15){
		if(!validId15(pId)){
			 $.messager.alert("��ʾ","���֤��������,����!","info");
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
	    var sex=id.slice(14,17)%2?"��":"Ů";
			///prov=areaCode[id.slice(0,6)] || areaCode[id.slice(0,4)] || areaCode[id.slice(0,2)] || "δ֪����";
	    var prov="";
	    ///var birthday=(new Date(id.slice(6,10),id.slice(10,12)-1,id.slice(12,14))).toLocaleDateString();
	    var myMM=(id.slice(10,12)).toString();
	    var myDD=id.slice(12,14).toString();
	    var myYY=id.slice(6,10).toString();
	  }else{
	  	var prov="";
	  	var sex=id.slice(14,15)%2?"��":"Ů";
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
		alert("���֤�Ź��� 15λ��18λ"); 
		return "";
    }
	if (pId.length == 18){
		if(!validId18(pId)){
			alert("���֤��������,����!");
			return "";
		}
	}
	if (pId.length == 15){
		if(!validId15(pId)){
			alert("���֤��������,����!");
			return "";
		}
	}
    var Ai=pId.length==18?pId.substring(0,17):pId.slice(0,6)+"19"+pId.slice(6,15); 
    
    if (!/^\d+$/.test(Ai))
    {
    	alert("���֤�����һλ�����Ϊ����");
    	return "";
    }
    var yyyy=Ai.slice(6,10), mm=Ai.slice(10,12)-1, dd=Ai.slice(12,14);
    var d=new Date(yyyy,mm,dd) , now=new Date(); 
    var year=d.getFullYear() , mon=d.getMonth() , day=d.getDate();
    if (year!=yyyy||mon!=mm||day!=dd||d>now||year<1901){
	    alert( "���֤�������");
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
    
	//����Ϊjpg�ļ�
	var PatientID=tkMakeServerCall("web.DHCPE.PreIADM","GetPatientID",PAPMINo);

	if(PatientID==""){
		$.messager.alert("��ʾ","������ϢID����Ϊ�ա�","info");
		return;
	}
	
	var userAgent = navigator.userAgent;
	var isChrome =  navigator.userAgent.indexOf('Chrome') > -1
	if(isChrome){
		
	var PicHeight=300;
    var Picwidth=200;
    PEPhoto.FileName=PicFilePath+PAPMINo+picType; //����ͼƬ�����ư�����׺
    if (PhotoFtpInfo==""){
        PEPhoto.FTPFlag="0" //�Ƿ��ϴ���ftp������  0
    }else{
        var FTPArr=PhotoFtpInfo.split("^");
        PEPhoto.DBFlag = "0" //�Ƿ񱣴浽���ݿ�  0  1
        PEPhoto.FTPFlag = "1" //�Ƿ񱣴浽FTP  0  1
        PEPhoto.AppName = FTPArr[4]+"/" //ftpĿ¼
        PEPhoto.FTPString = FTPArr[0]+"^"+FTPArr[1]+"^"+FTPArr[2]+"^"+FTPArr[3] //FTP������
        //PicHeight=FTPArr[5];
        //Picwidth=FTPArr[6];
    }
    PEPhoto.PicWidth=Picwidth;
    PEPhoto.PicHeight=PicHeight;
    PEPhoto.PatientID=PatientID //PA_PatMas���ID
    PEPhoto.ShowWin()
    InitPicture()    
	/*
	$HUI.window("#PhotoWin",{
		title:"�������",
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
		title:"�������",
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
	//����
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
		$.messager.alert("��ʾ","��������ȷ�ĳ�������!","info",function(){
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
		    $.messager.alert("��ʾ","��������ȷ�ĳ�������!","info",function(){
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
	
		$.messager.alert("��ʾ","��������ȷ�ĳ�������!","info",function(){
				$("#DOB").addClass("newclsInvalid"); 
				$("#DOB").focus();
			});
			
			return false;
			
	}else{
			var mybirth1=$("#DOB").val();
			var Checkrtn=CheckBirth(mybirth1);
			if(Checkrtn==false){
				$.messager.alert("��ʾ","�������ڲ��ܴ��ڽ������С�ڡ�����1840��!","info",function(){
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
