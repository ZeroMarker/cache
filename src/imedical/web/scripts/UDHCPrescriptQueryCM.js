var str1 // str1= PapmiRowid_"^"_PapmiNo_"^"_PatientName_"^"_PatientSex_"^"_AgeDesc_"^"_PatientBirthday_"^"_Pattype_"^"_PatientSocialStausDR_"^"_PatientSexDr_"^"_PatientDOB_"^"_PatientCompany_"^"_AgeYear_"^"_AgeMonth_"^"_AgeDay_"^"_PatientComAdd_"^"_EmployeeNO_"^"_PatientMarital_"^"_PatCategoryRowid_"^"_Medcare_"^"_RealName_"^"_RealCard_"^"_SupplyName_"^"_SupplyCard_"^"_GovernCardNo
var presc="",lyq="",loc="",Louyq=""
var cy1,cy2,cy3,cy4,cy5,cy6,cy7,cy8,cy9,cy10,cy11,cy12,cy13,cy14,cy15,cy16,cy17,cy18,cy19,cy20,cy21,cy22,cy23,cy24,cy25,cy26,cy27,cy28,note=""
var cy = new Array();
var cy1= new Array();
var cy2= new Array();
var bz= new Array();
var zd= new Array();
var DiagnoseArray=new Array();
var cjg=new Array();
var jobno,num,selectrow,selectcheck
var HospitalCode="";
var MyList = new Array();
var accessURL = "../../web/web.DHCPrintDesigner.cls";

function BodyLoadHandler()
{   
	var EpisodeID=DHCC_GetElementData("EpisodeID");
	if (EpisodeID!="") {
		var PatInfo=tkMakeServerCall("web.UDHCPrescriptQueryCM","getname",EpisodeID);
		if (PatInfo!="") {
			var PatInfoAry=PatInfo.split("^");
			var PatientID=PatInfoAry[0];
			var OldPatientID=DHCC_GetElementData("PatientID");
			if (OldPatientID==PatientID){
				var PatientNo=PatInfoAry[1];
				var PatientName=PatInfoAry[2];
				//加入病案号
				var MdeNo=PatInfoAry[18];
				DHCC_SetElementData("Patmed",MdeNo);
				SetPatientInfo(PatientNo,"",PatientID);
			}else{
				var OldCardNo=DHCC_GetElementData("CardNo");
				var OldPatientNo=DHCC_GetElementData("PatientNo");
				SetPatientInfo(OldPatientNo,OldCardNo,OldPatientID);
			}
		}
	}
	HospitalCode=DHCC_GetElementData("GetCurrentHospitalCode");
	/*
	if(document.getElementById('loc').value==""){
		document.getElementById('loc').value=session['LOGON.CTLOCID'];
	}
	*/
	var obj=document.getElementById('ks');
	if (obj) obj.onchange=ksChangeHandler;
	
	var obj1=document.getElementById('print');
	if (obj1) obj1.onclick=selectprint;
	//DHCP_GetXMLConfig("XMLObject","BJZYYCYPrescriptPrint");
	DHCP_GetXMLConfig("XMLObject","DHCOutPrescCY");
	
	var obj1=document.getElementById('allprint');
	if (obj1) obj1.onclick=allprint;
	
	var obj=document.getElementById('AllSelect');
	if (obj) obj.onclick=AllSelectClickHandler;
		
	var obj=document.getElementById("mradm");
	if (obj) var MRADMID=obj.value;
	

	var obj=document.getElementById("Copy");
	if (obj) obj.onclick=CopyClickHandler;
	
	
	var GetMRDiagnosDesc=document.getElementById("GetMRdiagnos");
	if (GetMRDiagnosDesc) {var encmeth=GetMRDiagnosDesc.value} else {var encmeth=''};
	if (encmeth!="") {
		var delim=';';//+String.fromCharCode(13)+String.fromCharCode(10)
		MRDiagnos=cspRunServerMethod(encmeth,MRADMID,delim);
		
		var len=MRDiagnos.length;
		var len1=0;
		var startpos=0;
		var endpos=0;
		var SeqNo=1
		for (var j=0;j<len;j++) {
			var char1=MRDiagnos.substring(j,j+1);
			endpos=j+1;
			if (char1==";"){
				if (len1==0) {
					DiagnoseArray[DiagnoseArray.length-1]=DiagnoseArray[DiagnoseArray.length-1]+";";
					startpos=endpos;
					continue;
				}else{
					DiagnoseArray[DiagnoseArray.length]=MRDiagnos.substring(startpos,endpos);
					startpos=endpos;
					len1=0;
					continue;
				}
			}
			if (CheckChinese(char1)) {len1=len1+2}else{len1=len1+1	}
			if (len1>12) {
				DiagnoseArray[DiagnoseArray.length]=MRDiagnos.substring(startpos,endpos);
				startpos=endpos;
				len1=0;
			}
		}
		if (len1!=0) {DiagnoseArray[DiagnoseArray.length]=MRDiagnos.substring(startpos,endpos);}
		
	}	
	document.onclick=OrderDetails;
		Objtbl=document.getElementById('tUDHCPrescriptQueryCM');
	Rows=Objtbl.rows.length;
	for (var i=1;i<Rows;i++){
		
		var cellobj=document.getElementById('stopflag1z'+i);
		if (cellobj){
			if (cellobj.value=="1"){
				//Objtbl.rows[i].className="clsInvalid";
				document.getElementById('c1z'+i).className="clsInvalid";
				}
	  
		}; 
		var cellobj=document.getElementById('stopflag2z'+i);
		if (cellobj){
			if (cellobj.value=="1"){
				//Objtbl.rows[i].className="clsInvalid";
				document.getElementById('c5z'+i).className="clsInvalid";
				}
	  
		}; 
		var cellobj=document.getElementById('stopflag3z'+i);
		if (cellobj){
			if (cellobj.value=="1"){
				//Objtbl.rows[i].className="clsInvalid";
				document.getElementById('c9z'+i).className="clsInvalid";
				}
	  
		}; 
		var cellobj=document.getElementById('stopflag4z'+i);
		if (cellobj){
			if (cellobj.value=="1"){
				//Objtbl.rows[i].className="clsInvalid";
				document.getElementById('c13z'+i).className="clsInvalid";
				}
	  
		}; 
	}
	
	//新加读卡功能 add by liyufeng
	var obj=document.getElementById('ReadCard');
	if (obj) obj.onclick=ReadCardClickHandler;
    var obj=document.getElementById('PatientNo');
	if (obj) obj.onkeydown=PatNoObj_keydown;
	var obj=document.getElementById('PatMed');
	if (obj) obj.onkeydown=PatMedObj_keydown;
	var obj=document.getElementById('CardNo');
	if (obj) obj.onkeydown = CardNoKeydownHandler;
	ReadCardType();
	var obj=document.getElementById('CardType');
	//因为dhtmlXComboFromSelect要判断isDefualt属性,
	if (obj) obj.setAttribute("isDefualt","true");
	combo_CardType=dhtmlXComboFromSelect("CardType");
	if (combo_CardType) {
		combo_CardType.enableFilteringMode(true);
		combo_CardType.selectHandle=combo_CardTypeKeydownHandler;
	}
	combo_CardTypeKeydownHandler()
}

function ksChangeHandler(){
	var obj=document.getElementById('ks');
	if(obj){
		if(obj.value=="") DHCC_SetElementData("loc","");
	}
	
}
function OrderDetails(e){
	var src=websys_getSrcElement(e);
	if (src.tagName == "A") return;

	if (src.id.substring(0,7)=="selectz")	{
		var arry=src.id.split("z");
		rowsel=arry[arry.length-1];
		var obj=document.getElementById("selectz"+rowsel);
		if (obj) {
			 //var selectcheck=document.getElementById('selectz'+selectrow);
			 //obj.onclick=click_select;
			 click_select(rowsel)
		}
	}
}
function CheckChinese(char1){
	if(escape(char1).indexOf("%u")!=-1) return true;
	return false;
}

function PrintFun(PObj,inpara,inlist){
	////DHCPrtComm.js
	try{
		var mystr="";
		for (var i= 0; i<PrtAryData.length;i++){
			mystr=mystr + PrtAryData[i];
		}
		
		inpara=DHCP_TextEncoder(inpara)
		inlist=DHCP_TextEncoder(inlist)
		var docobj=new ActiveXObject("MSXML2.DOMDocument.4.0");
		docobj.async = false;    //close
		var rtn=docobj.loadXML(mystr);
		if ((rtn)){
			////ToPrintDoc(ByVal inputdata As String, ByVal ListData As String, InDoc As MSXML2.DOMDocument40)			
			var rtn=PObj.ToPrintDocNew(inpara,inlist,docobj);
			////var rtn=PObj.ToPrintDoc(myinstr,myList,docobj);
		}
	}catch(e){
		alert(e.message);
		return;
	}
}




function getname()
{
	var encobj=document.getElementById('getname');
	var admobj=document.getElementById('EpisodeID');
			if (encobj==""){return} 
			else {
				var encmeth=encobj.value;
				obj=cspRunServerMethod(encmeth,admobj.value);
				var str1=obj.split("^");
				document.getElementById('name').value=str1
				//document.getElementById('GovernCardNo').value=str1[23]				
			}
		}

	
function getpath()
{
	var getpath=document.getElementById('getpath');
    if (getpath) {var encmeth=getpath.value} else {var encmeth=''};
	path=cspRunServerMethod(encmeth,'','')
}

function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	Objtbl=document.getElementById('tUDHCPrescriptQueryCM');
	Rows=Objtbl.rows.length;
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	
	var SelRowObj=document.getElementById('b2z'+selectrow);
	b2=SelRowObj.value;
	
	//document.getElementById('list1').value=b2;
	var job=document.getElementById('jobz'+1);
	jobno=job.value;
	var admobj=document.getElementById('EpisodeID');
	var patobj=document.getElementById('PatientID');
	var frm=dhcsys_getmenuform();
	if (frm)
	{
		frm.EpisodeID.value=admobj.value;
		frm.PatientID.value=patobj.value
	}
	//lxz 加入主选择判断
	if (eSrc.id=='selectz'+selectrow)
	{
		click_select(selectrow)
		
	}
	

}

function click_select(selectrow)
{
	/*
	var eSrc=window.event.srcElement;
	Objtbl=document.getElementById('tUDHCPrescriptQueryCM');
	Rows=Objtbl.rows.length;
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	*/
	var InputSelect=selectrow;
	var prescnoprint=document.getElementById('prescnoz'+selectrow);	
	presc=prescnoprint.value
	var job=document.getElementById('jobz'+1);
	jobno=job.value	
	var selectcheck=document.getElementById('selectz'+selectrow);
	b1=document.getElementById('prescnoz'+selectrow);
	b3=b1;
	for (i = 0; i < Rows; i++){
		if (selectrow>=Rows){continue;}
		b3=document.getElementById('prescnoz'+selectrow);
		if (b1.value!==b3.value){continue;}
		document.getElementById('select1z'+selectrow).checked=selectcheck.checked;
		
		document.getElementById('select2z'+selectrow).checked=selectcheck.checked;
		
		document.getElementById('select3z'+selectrow).checked=selectcheck.checked;
		
		document.getElementById('select4z'+selectrow).checked=selectcheck.checked;
		
		if(selectcheck.checked){
			document.getElementById('select1z'+selectrow).disabled=true;
			document.getElementById('select2z'+selectrow).disabled=true;
			document.getElementById('select3z'+selectrow).disabled=true;
			document.getElementById('select4z'+selectrow).disabled=true;
		}else{
			document.getElementById('select1z'+selectrow).disabled=false;
			document.getElementById('select2z'+selectrow).disabled=false;
			document.getElementById('select3z'+selectrow).disabled=false;
			document.getElementById('select4z'+selectrow).disabled=false;
		}
		selectrow=++selectrow
		
	}
	if (!selectcheck.checked){
		presc=""
	}
	else{
		var prescnoprint=document.getElementById('prescnoz'+InputSelect);	
		presc=prescnoprint.value
	}
	
	
}	
function LTrim(str) 
{ 
var i; 
for(i=0;i<str.length;i++) 
{ 
if(str.charAt(i)!=" "&&str.charAt(i)!=" ")break; 
} 
str=str.substring(i,str.length); 
return str; 
} 
function RTrim(str) 
{ 
var i; 
for(i=str.length-1;i>=0;i--) 
{ 
if(str.charAt(i)!=" "&&str.charAt(i)!=" ")break; 
} 
str=str.substring(0,i+1); 
return str; 
} 
function Trim(str) 
{ 
return LTrim(RTrim(str)); 
} 
	
function selectprint()
{ 
	if (HospitalCode=="BJXHYY"){
		var PrescNo=presc;
	    if (PrescNo!="") {
		    PrintPrescCY(PrescNo);
	 	}else{
	    	alert(t['Not_Select']);
		}
	  	return;
	}
    var GetMRDiagnosDesc=document.getElementById('GetMRdiagnos').value
    var obj=document.getElementById("mradm");
    if (obj) var MRADMID=obj.value;
    if (GetMRDiagnosDesc!="") {
		var delim=';';//+String.fromCharCode(13)+String.fromCharCode(10)
        MRDiagnos=cspRunServerMethod(GetMRDiagnosDesc,MRADMID,delim);
	}
	//if(presc==""){
		var objtbl=document.getElementById('tUDHCPrescriptQueryCM');
	    if (objtbl) {
	    	var SelCount=0
	    	var rows=objtbl.rows.length;
		    for (var i=1; i<rows; i++){
		    	var SelectFlag=eval(DHCC_GetColumnData("select",i));
		    	if (SelectFlag==true) {
		    			SelCount=SelCount+1
						presc=DHCC_GetColumnData("prescno",i);
						var b1obj=document.getElementById('b1z'+i);
						if ((presc!="")&&(+b1obj.innerText!="0")){
							var ReportData = tkMakeServerCall("web.DHCDocPrescript","GetPrescInfoByOrd",presc)
							PrintPrescCY('','',ReportData);
							OpenReport()
							var OnlyOriginal=false;
							var OnlyOriginalObj=document.getElementById('OnlyOriginal');
						    if (OnlyOriginalObj) OnlyOriginal=document.getElementById('OnlyOriginal').checked;
						    var flag1="Y",flag2="Y";
						    if (OnlyOriginal==true) flag2="N"
							PrintOnePrescCY(presc,"",flag1,flag2);
							//日志保存
						    var AdmId=DHCC_GetElementData("EpisodeID");
						    var PatientID=DHCC_GetElementData("PatientID");
						    var ModelName="UDHCPrescriptQueryCM";
						    var Condition="{RegNo:"+PatientID+"}";
						    var Content="{EpisodeId:"+AdmId+"}";
						    var SecretCode="";
						    var PatEncryptLevel=tkMakeServerCall("web.DHCBL.CARD.UCardPaPatMasInfo","GetPatEncryptLevel",PatientID,"");
							if (PatEncryptLevel!="") {
								var PatEncryptLevelArr=PatEncryptLevel.split("^");
								SecretCode=PatEncryptLevelArr[2];
								if (SecretCode!="") {
									var EventLogRowId=tkMakeServerCall("web.DHCEventLog","EventLog",ModelName,Condition,Content,SecretCode);
								}
							}
						}
					}
				}
	 	}
	//}
	if (SelCount==0){
		alert(t['NoPresc'])
		return;
	}
	return false;
	
	if (presc!=""){
		var ReportData = tkMakeServerCall("web.DHCDocPrescript","GetPrescInfoByOrd",presc)
		PrintPrescCY('','',ReportData);
		var ReportId =tkMakeServerCall("web.DHCDocPrescript","GetXMLTemplateId","DHCOutPrescCY");
		OpenReport(ReportId);
		var OnlyOriginal=false;
		var OnlyOriginalObj=document.getElementById('OnlyOriginal');
	    if (OnlyOriginalObj) OnlyOriginal=document.getElementById('OnlyOriginal').checked;
	    var flag1="Y",flag2="Y";
	    if (OnlyOriginal==true) flag2="N";
		PrintOnePrescCY(presc,"",flag1,flag2);
		//日志保存
	    var AdmId=DHCC_GetElementData("EpisodeID");
	    var PatientID=DHCC_GetElementData("PatientID");
	    var ModelName="UDHCPrescriptQueryCM";
	    var Condition="{RegNo:"+PatientID+"}";
	    var Content="{EpisodeId:"+AdmId+"}";
	    var SecretCode="";
	    var PatEncryptLevel=tkMakeServerCall("web.DHCBL.CARD.UCardPaPatMasInfo","GetPatEncryptLevel",PatientID,"");
		if (PatEncryptLevel!="") {
			var PatEncryptLevelArr=PatEncryptLevel.split("^");
			SecretCode=PatEncryptLevelArr[2];
			if (SecretCode!="") {
	    		//alert(ModelName+","+Condition+","+Content+","+SecretCode)
				var EventLogRowId=tkMakeServerCall("web.DHCEventLog","EventLog",ModelName,Condition,Content,SecretCode);
	    		//alert(EventLogRowId)
			}
		}
		return false;
		
		
		var StopEstimate=document.getElementById('StopEstimate');
		    encmeth=StopEstimate.value;
		    obj=cspRunServerMethod(encmeth,presc);
		    //if (obj=="C"){alert('该处方已经停止');return}    sxw 2007-12-04	
	        var admobj=document.getElementById('EpisodeID');
		    var encobj=document.getElementById('getinfo');
			if (encobj==""){return} 
			else {
				 var encmeth=encobj.value;
				 obj=cspRunServerMethod(encmeth,admobj.value,presc);
				 //alert(obj);
			     var str1=obj.split("^");
			     hospitalcode=str1[0];
			     PapmiNo=str1[1]
		    	 presc=str1[2]
			     pname=str1[3]
		    	 sex=str1[4]
			     age=str1[5]
		    	 GovernCardNo=str1[6]
		    	 OEORIOrdDept=str1[7]
		    	 if (OEORIOrdDept=="特需门诊"){var OEORIOrdDept="其他门诊"};
			     PatientComAdd=str1[8]      //病人地址
			     PatientName=str1[9]
			     DurationDesc=str1[10]
			     //alert(PatientName)
			     PHCINDesc=str1[11]
			     OEORIDoctor=str1[12]
			     je5=str1[13]
			     info1=str1[14]
			     cydate=str1[15]
			     qyks=str1[16]
			     lyq=str1[17]
			     var PrescCookMode=str1[25];
			     kl=lyq.lastIndexOf("中药煎药费");
			     
			     djf="";
			     djf=PrescCookMode;

                 //if (kl==0){var djf="代煎"}
			     DurationFactor=str1[18]
			     je6=str1[19]
			     lyqk=str1[20]
			     Louyq=str1[26]
			     //alert(Louyq)
			     note=str1[21]
			     Fre=str1[22]
			     MakeEach=str1[23]
			     AllMake=str1[24]
			     CosDesc=str1[27]
			     HospName=str1[28]
			     if (HospName!="") HospName=HospName+"中药处方"
			     cydate1=cydate.split("-")
			     cydate2=cydate1[0]+"年"+cydate1[1]+"月"+cydate1[2]+"日"
			     str2=info1.split("|")
			     MRD=MRDiagnos.split(";")
			     //alert(info1+"\n"+MRDiagnos);
			     
			     //lyqk="";   //lyqk=lyq   guorongyong 081007
			     lyqk=lyq;
			     je5="药品金额: "+je5+" 元"
			     je6=je6+"/剂"		     
				 for (k=0;k<32;k++){
			     	cy2[k]=""
			     	bz[k]=""
			     	zd[k]=""
			        cjg[k]=""
				 }
				 //alert("11");
				 for (k = 0; k < str2.length-1; k++){
                 	 cy[k]=str2[k]
                 	 cy1[k]=cy[k].split("%")
                 	 cjg[k]=cy1[k][1]
                 	 cy2[k]=cy1[k][0]
                 	 bz[k]=cy1[k][2]
                     if(Trim(bz[k].split("/")[0])!=""){
                     	 //cy2[k]=cy2[k]+"("+bz[k].split("/")[0]+")";
                     	 cy2[k]=cy2[k];    //guorongyong081030
                     }else{
                     	 //cy2[k]=cy2[k]+bz[k].split("/")[0];
                     	 cy2[k]=cy2[k];    //guorongyong081030
                     }
					 var tempStr=cy2[k].split(" ")[0];
					 var pnum=tempStr.split("(").length;
					 if(pnum>1){
						    cy2[k]=tempStr.split("(")[0]+" "+cy2[k].split(" ")[1];
					  }
                     	 //bz[k]="/"	 
                     	//alert(cy2[k]+"\n"+bz[k]+"\n"+cjg[k]);
                  }
                    // Louyq=str2[str2.length-2].split("%")[0].substr(4,3); //漏药器
                for (k = 0; k < MRD.length; k++){
                    zd[k]=MRD[k]
                }
                var zf="[正方]"
             	var PoliticalLevel="",SecretLevel="";
             	var obj1=document.getElementById("PoliticalLevel");
				if(obj1) PoliticalLevel=obj1.value;
				var obj1=document.getElementById("SecretLevel");
				if(obj1) SecretLevel=obj1.value;
				
                var myobj=document.getElementById("ClsBillPrint");
                var MyList=""
          		var MyPara="";
			    MyPara=MyPara+"hospitalcode"+String.fromCharCode(2)+hospitalcode;
			    MyPara=MyPara+"^zf"+String.fromCharCode(2)+zf;
			    MyPara=MyPara+"^PapmiNo"+String.fromCharCode(2)+PapmiNo;
			    MyPara=MyPara+"^presc"+String.fromCharCode(2)+presc;
			    MyPara=MyPara+"^PatientName"+String.fromCharCode(2)+PatientName;
			    MyPara=MyPara+"^pname"+String.fromCharCode(2)+pname;
			    MyPara=MyPara+"^sex"+String.fromCharCode(2)+sex;
			    MyPara=MyPara+"^age"+String.fromCharCode(2)+age;
			    MyPara=MyPara+"^GovernCardNo"+String.fromCharCode(2)+GovernCardNo;
			    MyPara=MyPara+"^OEORIOrdDept"+String.fromCharCode(2)+OEORIOrdDept;
			    MyPara=MyPara+"^PatientComAdd"+String.fromCharCode(2)+PatientComAdd;
			    MyPara=MyPara+"^PoliticalLevel"+String.fromCharCode(2)+PoliticalLevel;
			    MyPara=MyPara+"^SecretLevel"+String.fromCharCode(2)+SecretLevel;
			    MyPara=MyPara+"^DurationDesc"+String.fromCharCode(2)+DurationDesc;
			    MyPara=MyPara+"^PHCINDesc"+String.fromCharCode(2)+PHCINDesc;
			    MyPara=MyPara+"^note"+String.fromCharCode(2)+note.substr(0,8);
			    MyPara=MyPara+"^note1"+String.fromCharCode(2)+note.substr(8,8);
			    MyPara=MyPara+"^note2"+String.fromCharCode(2)+note.substr(16,8);
			    MyPara=MyPara+"^note3"+String.fromCharCode(2)+note.substr(24,8);
			    MyPara=MyPara+"^OEORIDoctor"+String.fromCharCode(2)+OEORIDoctor;
			    MyPara=MyPara+"^cydate2"+String.fromCharCode(2)+cydate2;
			    MyPara=MyPara+"^qyks"+String.fromCharCode(2)+qyks;
			    MyPara=MyPara+"^cy1"+String.fromCharCode(2)+cy2[0];
			    MyPara=MyPara+"^cy2"+String.fromCharCode(2)+cy2[1];
			    MyPara=MyPara+"^cy3"+String.fromCharCode(2)+cy2[2];
			    MyPara=MyPara+"^cy4"+String.fromCharCode(2)+cy2[3];
			    MyPara=MyPara+"^cy5"+String.fromCharCode(2)+cy2[4];
			    MyPara=MyPara+"^cy6"+String.fromCharCode(2)+cy2[5];
			    MyPara=MyPara+"^cy7"+String.fromCharCode(2)+cy2[6];
			    MyPara=MyPara+"^cy8"+String.fromCharCode(2)+cy2[7];
			    MyPara=MyPara+"^cy9"+String.fromCharCode(2)+cy2[8];
			    MyPara=MyPara+"^cy10"+String.fromCharCode(2)+cy2[9];
			    MyPara=MyPara+"^cy11"+String.fromCharCode(2)+cy2[10];
			    MyPara=MyPara+"^cy12"+String.fromCharCode(2)+cy2[11];
			    MyPara=MyPara+"^cy13"+String.fromCharCode(2)+cy2[12];
			    MyPara=MyPara+"^cy14"+String.fromCharCode(2)+cy2[13];
			    MyPara=MyPara+"^cy15"+String.fromCharCode(2)+cy2[14];
			    MyPara=MyPara+"^cy16"+String.fromCharCode(2)+cy2[15];
			    MyPara=MyPara+"^cy17"+String.fromCharCode(2)+cy2[16];
			    MyPara=MyPara+"^cy18"+String.fromCharCode(2)+cy2[17];
			    MyPara=MyPara+"^cy19"+String.fromCharCode(2)+cy2[18];
			    MyPara=MyPara+"^cy20"+String.fromCharCode(2)+cy2[19];
			    MyPara=MyPara+"^cy21"+String.fromCharCode(2)+cy2[20];
			    MyPara=MyPara+"^cy22"+String.fromCharCode(2)+cy2[21];
			    MyPara=MyPara+"^cy23"+String.fromCharCode(2)+cy2[22];
			    MyPara=MyPara+"^cy24"+String.fromCharCode(2)+cy2[23];
			    MyPara=MyPara+"^cy25"+String.fromCharCode(2)+cy2[24];
			    MyPara=MyPara+"^cy26"+String.fromCharCode(2)+cy2[25];
			    MyPara=MyPara+"^cy27"+String.fromCharCode(2)+cy2[26];
			    MyPara=MyPara+"^cy28"+String.fromCharCode(2)+cy2[27];
			    MyPara=MyPara+"^cy29"+String.fromCharCode(2)+cy2[28];
			    MyPara=MyPara+"^cy30"+String.fromCharCode(2)+cy2[29];
			    MyPara=MyPara+"^cy31"+String.fromCharCode(2)+cy2[30];
			    MyPara=MyPara+"^cy32"+String.fromCharCode(2)+cy2[31];
			    MyPara=MyPara+"^bz1"+String.fromCharCode(2)+bz[0].split("/")[0];
			    MyPara=MyPara+"^bz2"+String.fromCharCode(2)+bz[1].split("/")[0];
			    MyPara=MyPara+"^bz3"+String.fromCharCode(2)+bz[2].split("/")[0];
			    MyPara=MyPara+"^bz4"+String.fromCharCode(2)+bz[3].split("/")[0];
			    MyPara=MyPara+"^bz5"+String.fromCharCode(2)+bz[4].split("/")[0];
			    MyPara=MyPara+"^bz6"+String.fromCharCode(2)+bz[5].split("/")[0];
			    MyPara=MyPara+"^bz7"+String.fromCharCode(2)+bz[6].split("/")[0];
			    MyPara=MyPara+"^bz8"+String.fromCharCode(2)+bz[7].split("/")[0];
			    MyPara=MyPara+"^bz9"+String.fromCharCode(2)+bz[8].split("/")[0];
			    MyPara=MyPara+"^bz10"+String.fromCharCode(2)+bz[9].split("/")[0];
			    MyPara=MyPara+"^bz11"+String.fromCharCode(2)+bz[10].split("/")[0];
			    MyPara=MyPara+"^bz12"+String.fromCharCode(2)+bz[11].split("/")[0];
			    MyPara=MyPara+"^bz13"+String.fromCharCode(2)+bz[12].split("/")[0];
			    MyPara=MyPara+"^bz14"+String.fromCharCode(2)+bz[13].split("/")[0];
			    MyPara=MyPara+"^bz15"+String.fromCharCode(2)+bz[14].split("/")[0];
			    MyPara=MyPara+"^bz16"+String.fromCharCode(2)+bz[15].split("/")[0];
			    MyPara=MyPara+"^bz17"+String.fromCharCode(2)+bz[16].split("/")[0];
			    MyPara=MyPara+"^bz18"+String.fromCharCode(2)+bz[17].split("/")[0];
			    MyPara=MyPara+"^bz19"+String.fromCharCode(2)+bz[18].split("/")[0];
			    MyPara=MyPara+"^bz20"+String.fromCharCode(2)+bz[19].split("/")[0];
			    MyPara=MyPara+"^bz21"+String.fromCharCode(2)+bz[20].split("/")[0];
			    MyPara=MyPara+"^bz22"+String.fromCharCode(2)+bz[21].split("/")[0];
			    MyPara=MyPara+"^bz23"+String.fromCharCode(2)+bz[22].split("/")[0];
			    MyPara=MyPara+"^bz24"+String.fromCharCode(2)+bz[23].split("/")[0];
			    MyPara=MyPara+"^bz25"+String.fromCharCode(2)+bz[24].split("/")[0];
			    MyPara=MyPara+"^bz26"+String.fromCharCode(2)+bz[25].split("/")[0];
			    MyPara=MyPara+"^bz27"+String.fromCharCode(2)+bz[26].split("/")[0];
			    MyPara=MyPara+"^bz28"+String.fromCharCode(2)+bz[27].split("/")[0];
			    MyPara=MyPara+"^bz29"+String.fromCharCode(2)+bz[28].split("/")[0];
			    MyPara=MyPara+"^bz30"+String.fromCharCode(2)+bz[29].split("/")[0];
			    MyPara=MyPara+"^bz31"+String.fromCharCode(2)+bz[30].split("/")[0];
			    MyPara=MyPara+"^bz32"+String.fromCharCode(2)+bz[31].split("/")[0];
			    MyPara=MyPara+"^zd1"+String.fromCharCode(2)+zd[0];
			    MyPara=MyPara+"^zd2"+String.fromCharCode(2)+zd[1];
			    MyPara=MyPara+"^zd3"+String.fromCharCode(2)+zd[2];
			    MyPara=MyPara+"^zd4"+String.fromCharCode(2)+zd[3];
			    MyPara=MyPara+"^zd5"+String.fromCharCode(2)+zd[4];
			    MyPara=MyPara+"^zd6"+String.fromCharCode(2)+zd[5];
			    MyPara=MyPara+"^lyq"+String.fromCharCode(2)+lyqk;
			    MyPara=MyPara+"^yf"+String.fromCharCode(2)+je5;
			    MyPara=MyPara+"^djf"+String.fromCharCode(2)+djf;
			    MyPara=MyPara+"^Fre"+String.fromCharCode(2)+Fre.split(" ")[1];
			    MyPara=MyPara+"^Fre1"+String.fromCharCode(2)+Fre.split(" ")[0];
			    MyPara=MyPara+"^Louyq"+String.fromCharCode(2)+Louyq;
			    MyPara=MyPara+"^MakeEach"+String.fromCharCode(2)+MakeEach;
			    MyPara=MyPara+"^AllMake"+String.fromCharCode(2)+AllMake;
			    MyPara=MyPara+"^CosDesc"+String.fromCharCode(2)+CosDesc;   
			    if (HospName!="") MyPara=MyPara+"^HosName"+String.fromCharCode(2)+HospName; 
			    var DiagnoseArrayLen=DiagnoseArray.length;
				for (var k=0;k<DiagnoseArrayLen;k++) {
					var j=k+1;
					MyPara=MyPara+"^Diagnose"+j+String.fromCharCode(2)+DiagnoseArray[k];
				}
			    //alert(MyPara);
			    PrintFun(myobj,MyPara,MyList);
			    //日志保存
			    var AdmId=DHCC_GetElementData("EpisodeID");
			    var PatientID=DHCC_GetElementData("PatientID");
			    var ModelName="UDHCPrescriptQueryCM";
			    var Condition="{RegNo:"+PapmiNo+"}";
			    var Content="{EpisodeId:"+AdmId+"}";
			    var SecretCode="";
			    var PatEncryptLevel=tkMakeServerCall("web.DHCBL.CARD.UCardPaPatMasInfo","GetPatEncryptLevel",PatientID,"");
				if (PatEncryptLevel!="") {
					var PatEncryptLevelArr=PatEncryptLevel.split("^");
					SecretCode=PatEncryptLevelArr[2];
					if (SecretCode!="") {
			    		//alert(ModelName+","+Condition+","+Content+","+SecretCode)
						var EventLogRowId=tkMakeServerCall("web.DHCEventLog","EventLog",ModelName,Condition,Content,SecretCode);
			    		//alert(EventLogRowId)
					}
				}
			    
			    var OnlyOriginal=false;
			    var OnlyOriginalObj=document.getElementById('OnlyOriginal');
			    if (OnlyOriginalObj) OnlyOriginal=document.getElementById('OnlyOriginal').checked;
			    var lczdzy="过一个月量";
			    var lczdzy1="服用同一类药物的可放宽到不超";
			    var lczdzy2="两周量.特殊疾病病情稳定需长期";
			    var lczdzy3="不超过七天量.行动不便的不超过"
			    var lczdzy4="急性疾病不超过3天量.慢性疾病";
			    var lczdzy6="注意事项"
			    var zf="[底方]"
			    //start
			    for(var p=0;p<cy2.length;p++){
				    var tempStr=cy2[p].split(" ")[0];
				    var pnum=tempStr.split("(").length;
				    if(pnum>1){
					    cy2[p]=tempStr.split("(")[0]+" "+cy2[p].split(" ")[1];
					}
				    
				}
			    //end
			    var myobj=document.getElementById("ClsBillPrint");
                var MyList=""
                var MyPara="";
			    MyPara=MyPara+"hospitalcode"+String.fromCharCode(2)+hospitalcode;
			    MyPara=MyPara+"^zf"+String.fromCharCode(2)+zf;
			    /*
			    MyPara=MyPara+"^lczdzy"+String.fromCharCode(2)+lczdzy;
			    MyPara=MyPara+"^lczdzy1"+String.fromCharCode(2)+lczdzy1;
			    MyPara=MyPara+"^lczdzy2"+String.fromCharCode(2)+lczdzy2;
			    MyPara=MyPara+"^lczdzy3"+String.fromCharCode(2)+lczdzy3;
			    MyPara=MyPara+"^lczdzy4"+String.fromCharCode(2)+lczdzy4;
			    MyPara=MyPara+"^lczdzy6"+String.fromCharCode(2)+lczdzy6;
			    */
			    MyPara=MyPara+"^PapmiNo"+String.fromCharCode(2)+PapmiNo;
			    MyPara=MyPara+"^presc"+String.fromCharCode(2)+presc;
			    MyPara=MyPara+"^PatientName"+String.fromCharCode(2)+PatientName;
			    MyPara=MyPara+"^pname"+String.fromCharCode(2)+pname;
			    MyPara=MyPara+"^sex"+String.fromCharCode(2)+sex;
			    MyPara=MyPara+"^age"+String.fromCharCode(2)+age;
			    MyPara=MyPara+"^GovernCardNo"+String.fromCharCode(2)+GovernCardNo;
			    MyPara=MyPara+"^OEORIOrdDept"+String.fromCharCode(2)+OEORIOrdDept;
			    MyPara=MyPara+"^PatientComAdd"+String.fromCharCode(2)+PatientComAdd;
			    MyPara=MyPara+"^PatientName"+String.fromCharCode(2)+PatientName;
			    MyPara=MyPara+"^PoliticalLevel"+String.fromCharCode(2)+PoliticalLevel;
			    MyPara=MyPara+"^SecretLevel"+String.fromCharCode(2)+SecretLevel;
			    MyPara=MyPara+"^DurationDesc"+String.fromCharCode(2)+DurationDesc;
			    MyPara=MyPara+"^PHCINDesc"+String.fromCharCode(2)+PHCINDesc;
			    MyPara=MyPara+"^note"+String.fromCharCode(2)+note.substr(0,8);
			    MyPara=MyPara+"^note1"+String.fromCharCode(2)+note.substr(8,8);
			    MyPara=MyPara+"^note2"+String.fromCharCode(2)+note.substr(16,8);
			    MyPara=MyPara+"^note3"+String.fromCharCode(2)+note.substr(24,8);
			    MyPara=MyPara+"^OEORIDoctor"+String.fromCharCode(2)+OEORIDoctor;
			    MyPara=MyPara+"^cydate2"+String.fromCharCode(2)+cydate2;
			    MyPara=MyPara+"^qyks"+String.fromCharCode(2)+qyks;
			    MyPara=MyPara+"^cy1"+String.fromCharCode(2)+cy2[0];
			    MyPara=MyPara+"^cy2"+String.fromCharCode(2)+cy2[1];
			    MyPara=MyPara+"^cy3"+String.fromCharCode(2)+cy2[2];
			    MyPara=MyPara+"^cy4"+String.fromCharCode(2)+cy2[3];
			    MyPara=MyPara+"^cy5"+String.fromCharCode(2)+cy2[4];
			    MyPara=MyPara+"^cy6"+String.fromCharCode(2)+cy2[5];
			    MyPara=MyPara+"^cy7"+String.fromCharCode(2)+cy2[6];
			    MyPara=MyPara+"^cy8"+String.fromCharCode(2)+cy2[7];
			    MyPara=MyPara+"^cy9"+String.fromCharCode(2)+cy2[8];
			    MyPara=MyPara+"^cy10"+String.fromCharCode(2)+cy2[9];
			    MyPara=MyPara+"^cy11"+String.fromCharCode(2)+cy2[10];
			    MyPara=MyPara+"^cy12"+String.fromCharCode(2)+cy2[11];
			    MyPara=MyPara+"^cy13"+String.fromCharCode(2)+cy2[12];
			    MyPara=MyPara+"^cy14"+String.fromCharCode(2)+cy2[13];
			    MyPara=MyPara+"^cy15"+String.fromCharCode(2)+cy2[14];
			    MyPara=MyPara+"^cy16"+String.fromCharCode(2)+cy2[15];
			    MyPara=MyPara+"^cy17"+String.fromCharCode(2)+cy2[16];
			    MyPara=MyPara+"^cy18"+String.fromCharCode(2)+cy2[17];
			    MyPara=MyPara+"^cy19"+String.fromCharCode(2)+cy2[18];
			    MyPara=MyPara+"^cy20"+String.fromCharCode(2)+cy2[19];
			    MyPara=MyPara+"^cy21"+String.fromCharCode(2)+cy2[20];
			    MyPara=MyPara+"^cy22"+String.fromCharCode(2)+cy2[21];
			    MyPara=MyPara+"^cy23"+String.fromCharCode(2)+cy2[22];
			    MyPara=MyPara+"^cy24"+String.fromCharCode(2)+cy2[23];
			    MyPara=MyPara+"^cy25"+String.fromCharCode(2)+cy2[24];
			    MyPara=MyPara+"^cy26"+String.fromCharCode(2)+cy2[25];
			    MyPara=MyPara+"^cy27"+String.fromCharCode(2)+cy2[26];
			    MyPara=MyPara+"^cy28"+String.fromCharCode(2)+cy2[27];
			    MyPara=MyPara+"^cy29"+String.fromCharCode(2)+cy2[28];
			    MyPara=MyPara+"^cy30"+String.fromCharCode(2)+cy2[29];
			    MyPara=MyPara+"^cy31"+String.fromCharCode(2)+cy2[30];
			    MyPara=MyPara+"^cy32"+String.fromCharCode(2)+cy2[31];
			    MyPara=MyPara+"^bz1"+String.fromCharCode(2)+bz[0].split("/")[0];
			    MyPara=MyPara+"^bz2"+String.fromCharCode(2)+bz[1].split("/")[0];
			    MyPara=MyPara+"^bz3"+String.fromCharCode(2)+bz[2].split("/")[0];
			    MyPara=MyPara+"^bz4"+String.fromCharCode(2)+bz[3].split("/")[0];
			    MyPara=MyPara+"^bz5"+String.fromCharCode(2)+bz[4].split("/")[0];
			    MyPara=MyPara+"^bz6"+String.fromCharCode(2)+bz[5].split("/")[0];
			    MyPara=MyPara+"^bz7"+String.fromCharCode(2)+bz[6].split("/")[0];
			    MyPara=MyPara+"^bz8"+String.fromCharCode(2)+bz[7].split("/")[0];
			    MyPara=MyPara+"^bz9"+String.fromCharCode(2)+bz[8].split("/")[0];
			    MyPara=MyPara+"^bz10"+String.fromCharCode(2)+bz[9].split("/")[0];
			    MyPara=MyPara+"^bz11"+String.fromCharCode(2)+bz[10].split("/")[0];
			    MyPara=MyPara+"^bz12"+String.fromCharCode(2)+bz[11].split("/")[0];
			    MyPara=MyPara+"^bz13"+String.fromCharCode(2)+bz[12].split("/")[0];
			    MyPara=MyPara+"^bz14"+String.fromCharCode(2)+bz[13].split("/")[0];
			    MyPara=MyPara+"^bz15"+String.fromCharCode(2)+bz[14].split("/")[0];
			    MyPara=MyPara+"^bz16"+String.fromCharCode(2)+bz[15].split("/")[0];
			    MyPara=MyPara+"^bz17"+String.fromCharCode(2)+bz[16].split("/")[0];
			    MyPara=MyPara+"^bz18"+String.fromCharCode(2)+bz[17].split("/")[0];
			    MyPara=MyPara+"^bz19"+String.fromCharCode(2)+bz[18].split("/")[0];
			    MyPara=MyPara+"^bz20"+String.fromCharCode(2)+bz[19].split("/")[0];
			    MyPara=MyPara+"^bz21"+String.fromCharCode(2)+bz[20].split("/")[0];
			    MyPara=MyPara+"^bz22"+String.fromCharCode(2)+bz[21].split("/")[0];
			    MyPara=MyPara+"^bz23"+String.fromCharCode(2)+bz[22].split("/")[0];
			    MyPara=MyPara+"^bz24"+String.fromCharCode(2)+bz[23].split("/")[0];
			    MyPara=MyPara+"^bz25"+String.fromCharCode(2)+bz[24].split("/")[0];
			    MyPara=MyPara+"^bz26"+String.fromCharCode(2)+bz[25].split("/")[0];
			    MyPara=MyPara+"^bz27"+String.fromCharCode(2)+bz[26].split("/")[0];
			    MyPara=MyPara+"^bz28"+String.fromCharCode(2)+bz[27].split("/")[0];
			    MyPara=MyPara+"^bz29"+String.fromCharCode(2)+bz[28].split("/")[0];
			    MyPara=MyPara+"^bz30"+String.fromCharCode(2)+bz[29].split("/")[0];
			    MyPara=MyPara+"^bz31"+String.fromCharCode(2)+bz[30].split("/")[0];
			    MyPara=MyPara+"^bz32"+String.fromCharCode(2)+bz[31].split("/")[0];
			    MyPara=MyPara+"^zd1"+String.fromCharCode(2)+zd[0];
			    MyPara=MyPara+"^zd2"+String.fromCharCode(2)+zd[1];
			    MyPara=MyPara+"^zd3"+String.fromCharCode(2)+zd[2];
			    MyPara=MyPara+"^zd4"+String.fromCharCode(2)+zd[3];
			    MyPara=MyPara+"^zd5"+String.fromCharCode(2)+zd[4];
			    MyPara=MyPara+"^zd6"+String.fromCharCode(2)+zd[5];
			    MyPara=MyPara+"^lyq"+String.fromCharCode(2)+lyq;
			    MyPara=MyPara+"^yf"+String.fromCharCode(2)+je5;
			    MyPara=MyPara+"^Louyq"+String.fromCharCode(2)+Louyq;
			    
			    MyPara=MyPara+"^cjg1"+String.fromCharCode(2)+cjg[0];
			    MyPara=MyPara+"^cjg2"+String.fromCharCode(2)+cjg[1];
			    MyPara=MyPara+"^cjg3"+String.fromCharCode(2)+cjg[2];
			    MyPara=MyPara+"^cjg4"+String.fromCharCode(2)+cjg[3];
			    MyPara=MyPara+"^cjg5"+String.fromCharCode(2)+cjg[4];
			    MyPara=MyPara+"^cjg6"+String.fromCharCode(2)+cjg[5];
			    MyPara=MyPara+"^cjg7"+String.fromCharCode(2)+cjg[6];
			    MyPara=MyPara+"^cjg8"+String.fromCharCode(2)+cjg[7];
			    MyPara=MyPara+"^cjg9"+String.fromCharCode(2)+cjg[8];
			    MyPara=MyPara+"^cjg10"+String.fromCharCode(2)+cjg[9];
			    MyPara=MyPara+"^cjg11"+String.fromCharCode(2)+cjg[10];
			    MyPara=MyPara+"^cjg12"+String.fromCharCode(2)+cjg[11];
			    MyPara=MyPara+"^cjg13"+String.fromCharCode(2)+cjg[12];
			    MyPara=MyPara+"^cjg14"+String.fromCharCode(2)+cjg[13];
			    MyPara=MyPara+"^cjg15"+String.fromCharCode(2)+cjg[14];
			    MyPara=MyPara+"^cjg16"+String.fromCharCode(2)+cjg[15];
			    MyPara=MyPara+"^cjg17"+String.fromCharCode(2)+cjg[16];
			    MyPara=MyPara+"^cjg18"+String.fromCharCode(2)+cjg[17];
			    MyPara=MyPara+"^cjg19"+String.fromCharCode(2)+cjg[18];
			    MyPara=MyPara+"^cjg20"+String.fromCharCode(2)+cjg[19];
			    MyPara=MyPara+"^cjg21"+String.fromCharCode(2)+cjg[20];
			    MyPara=MyPara+"^cjg22"+String.fromCharCode(2)+cjg[21];
			    MyPara=MyPara+"^cjg23"+String.fromCharCode(2)+cjg[22];
			    MyPara=MyPara+"^cjg24"+String.fromCharCode(2)+cjg[23];
			    MyPara=MyPara+"^cjg25"+String.fromCharCode(2)+cjg[24];
			    MyPara=MyPara+"^cjg26"+String.fromCharCode(2)+cjg[25];
			    MyPara=MyPara+"^cjg27"+String.fromCharCode(2)+cjg[26];
			    MyPara=MyPara+"^cjg28"+String.fromCharCode(2)+cjg[27];
			    MyPara=MyPara+"^cjg29"+String.fromCharCode(2)+cjg[28];
			    MyPara=MyPara+"^cjg30"+String.fromCharCode(2)+cjg[29];
			    MyPara=MyPara+"^cjg31"+String.fromCharCode(2)+cjg[30];
			    MyPara=MyPara+"^cjg32"+String.fromCharCode(2)+cjg[31];
			    
			    //MyPara=MyPara+"^mjjg"+String.fromCharCode(2)+je6;
			    MyPara=MyPara+"^djf"+String.fromCharCode(2)+djf;
			    MyPara=MyPara+"^Fre"+String.fromCharCode(2)+Fre.split(" ")[1];
			    MyPara=MyPara+"^Fre1"+String.fromCharCode(2)+Fre.split(" ")[0];
			    MyPara=MyPara+"^MakeEach"+String.fromCharCode(2)+MakeEach;
			    MyPara=MyPara+"^AllMake"+String.fromCharCode(2)+AllMake;
			    MyPara=MyPara+"^CosDesc"+String.fromCharCode(2)+CosDesc;
			    if (HospName!="") MyPara=MyPara+"^HosName"+String.fromCharCode(2)+HospName;   
			    var DiagnoseArrayLen=DiagnoseArray.length;
				for (var k=0;k<DiagnoseArrayLen;k++) {
					var j=k+1;
					MyPara=MyPara+"^Diagnose"+j+String.fromCharCode(2)+DiagnoseArray[k];
				}
			    if (OnlyOriginal==false){PrintFun(myobj,MyPara,MyList)};
			  //  PrintFun(myobj,MyPara,MyList);	
		 	}				
	}else {
		alert(t['NoPresc'])
		return;
	}
}
function AllSelectClickHandler(){
	var AllSelectObj=document.getElementById('AllSelect');
	var objtbl=document.getElementById('tUDHCPrescriptQueryCM');
    if (objtbl) {
    	var rows=objtbl.rows.length;
	    for (var i=1; i<rows; i++){
	        var b1obj=document.getElementById('b1z'+i);
	        if (b1obj.innerText!=""){
	           DHCC_SetColumnData("select",i,AllSelectObj.checked);
	        }
	        click_select(i)
	        
	    	
		}
	}
}
function allprint()
{
	if (HospitalCode=="BJXHYY"){
		var objtbl=document.getElementById('tUDHCPrescriptQueryCM');
    if (objtbl) {
    	var SelCount=0
    	var rows=objtbl.rows.length;
	    for (var i=1; i<rows; i++){
	    	var SelectFlag=eval(DHCC_GetColumnData("select",i));
	    	if (SelectFlag==true) {
	    		SelCount=SelCount+1
					var PrescNo=DHCC_GetColumnData("prescno",i);
					PrintPrescCY(PrescNo);
				}
			}
			if (SelCount==0){alert(t['Not_Select'])}
 		}
  	return;
  }else{
  	var objtbl=document.getElementById('tUDHCPrescriptQueryCM');
    if (objtbl) {
    	var SelCount=0
    	var rows=objtbl.rows.length;
	    for (var i=1; i<rows; i++){
	    	var SelectFlag=eval(DHCC_GetColumnData("select",i));
	    	if (SelectFlag==true) {
	    		SelCount=SelCount+1
					presc=DHCC_GetColumnData("prescno",i);
					selectprint();
				}
			}
			if (SelCount==0){alert(t['Not_Select'])}
 		}
  	return;
  }
    
    var encobj1=document.getElementById('EpisodeID');
    var encobj=document.getElementById('allprintac');
				if (encobj==""){return} 
			else {
				var encmeth=encobj.value;
				obj=cspRunServerMethod(encmeth,encobj1.value);
				var job=obj
			}	 
	   
	   var encobj=document.getElementById('getnum');
				if (encobj==""){return} 
			else {
				var encmeth=encobj.value;
				obj=cspRunServerMethod(encmeth,job);
				str=obj.split("^")
         numall=str[0]
         numall=++numall
        
		       }
		 for (k1 = 1; k1 < numall; k1++)		
		 {
		 	var encobj=document.getElementById('getallinfo');
			if (encobj==""){return} 
			else {
						var encmeth=encobj.value;
				
				obj=cspRunServerMethod(encmeth,job,k1);
				str1=obj.split("^")
				hospitalcode=str1[0];
				     PapmiNo=str1[1]
			    	 presc=str1[2]
				     pname=str1[3]
			    	 sex=str1[4]
				     age=str1[5]
			    	 GovernCardNo=str1[6]
			    	 OEORIOrdDept=str1[7]
				     PatientComAdd=str1[8]
				     PatientName=str1[9]
				     DurationDesc=str1[10]
				     PHCINDesc=str1[11]
				     OEORIDoctor=str1[12]
				     je5=str1[13]
				     info1=str1[14]
				     cydate=str1[15]
				     qyks=str1[16]
				     lyq=str1[17]
				     kl=lyq.lastIndexOf("中药煎药费");
				     var djf=""
				     var PrescCookMode=str1[25];
				     djf=PrescCookMode;
                     //if (kl==0){var djf="代煎"}
				     DurationFactor=str1[18]
				     je6=str1[19]
				     lyqk=str1[20]
				     note=str1[21]
				     Fre=str1[22]
				     MakeEach=str1[23]
				     AllMake=str1[24]
				     CosDesc=str1[25]
				     cydate1=cydate.split("-")
				     cydate2=cydate1[0]+"年"+cydate1[1]+"月"+cydate1[2]+"日"
				     str2=info1.split("|")
				     MRD=MRDiagnos.split(";")
				    lyqk=lyq
				     je5="药品金额: "+je5+" 元"
				    je6=je6+"/剂"		     
				     for (k=0;k<32;k++)
				     {
				     	cy2[k]=""
				     	bz[k]=""
				     	zd[k]=""
				      cjg[k]=""
				     	}
				     
				      for (k = 0; k < str2.length-2; k++)
                     {
                     	 cy[k]=str2[k]
                     	 cy1[k]=cy[k].split("%")
                     	 cjg[k]=cy1[k][1]
                     	 cy2[k]=cy1[k][0]
                     	 bz[k]=cy1[k][2]
                     	 if(Trim(bz[k].split("/")[0])!=""){
                     	 //cy2[k]=cy2[k]+"("+bz[k].split("/")[0]+")"
                     	 cy2[k]=cy2[k];
                     	 }
                     	 else{
	                     	 //cy2[k]=cy2[k]+bz[k].split("/")[0]
	                     	 cy2[k]=cy2[k];
                     	 }
                     	 //bz[k]="/"	 
                     	//alert(cy2[k]+"\n"+bz[k]+"\n"+cjg[k]);
                     }
                     Louyq=str2[str2.length-2].split("%")[0].substr(4,2); //漏药器
                   
              for (k = 0; k < MRD.length; k++)
                     {
                     	zd[k]=MRD[k]
                     	}
              var OnlyOriginal=false
              var ObjOnlyOriginal=document.getElementById('OnlyOriginal')
              if (ObjOnlyOriginal) OnlyOriginal=document.getElementById('OnlyOriginal').checked;       	
               var zf="[正方]"
             
                     var myobj=document.getElementById("ClsBillPrint");
                     var MyList=""
          var MyPara="";
			    MyPara=MyPara+"hospitalcode"+String.fromCharCode(2)+hospitalcode;
			    MyPara=MyPara+"^zf"+String.fromCharCode(2)+zf;
			    MyPara=MyPara+"^PapmiNo"+String.fromCharCode(2)+PapmiNo;
			    MyPara=MyPara+"^presc"+String.fromCharCode(2)+presc;
			    MyPara=MyPara+"^PatientName"+String.fromCharCode(2)+PatientName;
			    MyPara=MyPara+"^pname"+String.fromCharCode(2)+pname;
			    MyPara=MyPara+"^sex"+String.fromCharCode(2)+sex;
			    MyPara=MyPara+"^age"+String.fromCharCode(2)+age;
			    MyPara=MyPara+"^GovernCardNo"+String.fromCharCode(2)+GovernCardNo;
			    MyPara=MyPara+"^OEORIOrdDept"+String.fromCharCode(2)+OEORIOrdDept;
			    MyPara=MyPara+"^PatientComAdd"+String.fromCharCode(2)+PatientComAdd;
			    MyPara=MyPara+"^PatientName"+String.fromCharCode(2)+PatientName;
			    MyPara=MyPara+"^DurationDesc"+String.fromCharCode(2)+DurationDesc;
			    MyPara=MyPara+"^PHCINDesc"+String.fromCharCode(2)+PHCINDesc;
			    MyPara=MyPara+"^note"+String.fromCharCode(2)+note.substr(0,8);
			    MyPara=MyPara+"^note1"+String.fromCharCode(2)+note.substr(8,8);
			    MyPara=MyPara+"^note2"+String.fromCharCode(2)+note.substr(16,8);
			    MyPara=MyPara+"^note3"+String.fromCharCode(2)+note.substr(24,8);
			    MyPara=MyPara+"^OEORIDoctor"+String.fromCharCode(2)+OEORIDoctor;
			    MyPara=MyPara+"^cydate2"+String.fromCharCode(2)+cydate2;
			    MyPara=MyPara+"^qyks"+String.fromCharCode(2)+qyks;
			    MyPara=MyPara+"^cy1"+String.fromCharCode(2)+cy2[0];
			    MyPara=MyPara+"^cy2"+String.fromCharCode(2)+cy2[1];
			    MyPara=MyPara+"^cy3"+String.fromCharCode(2)+cy2[2];
			    MyPara=MyPara+"^cy4"+String.fromCharCode(2)+cy2[3];
			    MyPara=MyPara+"^cy5"+String.fromCharCode(2)+cy2[4];
			    MyPara=MyPara+"^cy6"+String.fromCharCode(2)+cy2[5];
			    MyPara=MyPara+"^cy7"+String.fromCharCode(2)+cy2[6];
			    MyPara=MyPara+"^cy8"+String.fromCharCode(2)+cy2[7];
			    MyPara=MyPara+"^cy9"+String.fromCharCode(2)+cy2[8];
			    MyPara=MyPara+"^cy10"+String.fromCharCode(2)+cy2[9];
			    MyPara=MyPara+"^cy11"+String.fromCharCode(2)+cy2[10];
			    MyPara=MyPara+"^cy12"+String.fromCharCode(2)+cy2[11];
			    MyPara=MyPara+"^cy13"+String.fromCharCode(2)+cy2[12];
			    MyPara=MyPara+"^cy14"+String.fromCharCode(2)+cy2[13];
			    MyPara=MyPara+"^cy15"+String.fromCharCode(2)+cy2[14];
			    MyPara=MyPara+"^cy16"+String.fromCharCode(2)+cy2[15];
			    MyPara=MyPara+"^cy17"+String.fromCharCode(2)+cy2[16];
			    MyPara=MyPara+"^cy18"+String.fromCharCode(2)+cy2[17];
			    MyPara=MyPara+"^cy19"+String.fromCharCode(2)+cy2[18];
			    MyPara=MyPara+"^cy20"+String.fromCharCode(2)+cy2[19];
			    MyPara=MyPara+"^cy21"+String.fromCharCode(2)+cy2[20];
			    MyPara=MyPara+"^cy22"+String.fromCharCode(2)+cy2[21];
			    MyPara=MyPara+"^cy23"+String.fromCharCode(2)+cy2[22];
			    MyPara=MyPara+"^cy24"+String.fromCharCode(2)+cy2[23];
			    MyPara=MyPara+"^cy25"+String.fromCharCode(2)+cy2[24];
			    MyPara=MyPara+"^cy26"+String.fromCharCode(2)+cy2[25];
			    MyPara=MyPara+"^cy27"+String.fromCharCode(2)+cy2[26];
			    MyPara=MyPara+"^cy28"+String.fromCharCode(2)+cy2[27];
			    MyPara=MyPara+"^cy29"+String.fromCharCode(2)+cy2[28];
			    MyPara=MyPara+"^cy30"+String.fromCharCode(2)+cy2[29];
			    MyPara=MyPara+"^cy31"+String.fromCharCode(2)+cy2[30];
			    MyPara=MyPara+"^cy32"+String.fromCharCode(2)+cy2[31];
			    MyPara=MyPara+"^bz1"+String.fromCharCode(2)+bz[0].split("/")[0];
			    MyPara=MyPara+"^bz2"+String.fromCharCode(2)+bz[1].split("/")[0];
			    MyPara=MyPara+"^bz3"+String.fromCharCode(2)+bz[2].split("/")[0];
			    MyPara=MyPara+"^bz4"+String.fromCharCode(2)+bz[3].split("/")[0];
			    MyPara=MyPara+"^bz5"+String.fromCharCode(2)+bz[4].split("/")[0];
			    MyPara=MyPara+"^bz6"+String.fromCharCode(2)+bz[5].split("/")[0];
			    MyPara=MyPara+"^bz7"+String.fromCharCode(2)+bz[6].split("/")[0];
			    MyPara=MyPara+"^bz8"+String.fromCharCode(2)+bz[7].split("/")[0];
			    MyPara=MyPara+"^bz9"+String.fromCharCode(2)+bz[8].split("/")[0];
			    MyPara=MyPara+"^bz10"+String.fromCharCode(2)+bz[9].split("/")[0];
			    MyPara=MyPara+"^bz11"+String.fromCharCode(2)+bz[10].split("/")[0];
			    MyPara=MyPara+"^bz12"+String.fromCharCode(2)+bz[11].split("/")[0];
			    MyPara=MyPara+"^bz13"+String.fromCharCode(2)+bz[12].split("/")[0];
			    MyPara=MyPara+"^bz14"+String.fromCharCode(2)+bz[13].split("/")[0];
			    MyPara=MyPara+"^bz15"+String.fromCharCode(2)+bz[14].split("/")[0];
			    MyPara=MyPara+"^bz16"+String.fromCharCode(2)+bz[15].split("/")[0];
			    MyPara=MyPara+"^bz17"+String.fromCharCode(2)+bz[16].split("/")[0];
			    MyPara=MyPara+"^bz18"+String.fromCharCode(2)+bz[17].split("/")[0];
			    MyPara=MyPara+"^bz19"+String.fromCharCode(2)+bz[18].split("/")[0];
			    MyPara=MyPara+"^bz20"+String.fromCharCode(2)+bz[19].split("/")[0];
			    MyPara=MyPara+"^bz21"+String.fromCharCode(2)+bz[20].split("/")[0];
			    MyPara=MyPara+"^bz22"+String.fromCharCode(2)+bz[21].split("/")[0];
			    MyPara=MyPara+"^bz23"+String.fromCharCode(2)+bz[22].split("/")[0];
			    MyPara=MyPara+"^bz24"+String.fromCharCode(2)+bz[23].split("/")[0];
			    MyPara=MyPara+"^bz25"+String.fromCharCode(2)+bz[24].split("/")[0];
			    MyPara=MyPara+"^bz26"+String.fromCharCode(2)+bz[25].split("/")[0];
			    MyPara=MyPara+"^bz27"+String.fromCharCode(2)+bz[26].split("/")[0];
			    MyPara=MyPara+"^bz28"+String.fromCharCode(2)+bz[27].split("/")[0];
			    MyPara=MyPara+"^bz29"+String.fromCharCode(2)+bz[28].split("/")[0];
			    MyPara=MyPara+"^bz30"+String.fromCharCode(2)+bz[29].split("/")[0];
			    MyPara=MyPara+"^bz31"+String.fromCharCode(2)+bz[30].split("/")[0];
			    MyPara=MyPara+"^bz32"+String.fromCharCode(2)+bz[31].split("/")[0];
			    MyPara=MyPara+"^lyq"+String.fromCharCode(2)+lyqk;
			    MyPara=MyPara+"^yf"+String.fromCharCode(2)+je5;
			    MyPara=MyPara+"^djf"+String.fromCharCode(2)+djf;
			    MyPara=MyPara+"^Fre"+String.fromCharCode(2)+Fre.split(" ")[1];
			    MyPara=MyPara+"^Fre1"+String.fromCharCode(2)+Fre.split(" ")[0];
			    MyPara=MyPara+"^Louyq"+String.fromCharCode(2)+Louyq;
			    MyPara=MyPara+"^MakeEach"+String.fromCharCode(2)+MakeEach;
			    MyPara=MyPara+"^AllMake"+String.fromCharCode(2)+AllMake;
			    MyPara=MyPara+"^CosDesc"+String.fromCharCode(2)+CosDesc;
			    
			    var DiagnoseArrayLen=DiagnoseArray.length;
				for (var k=0;k<DiagnoseArrayLen;k++) {
					var j=k+1;
					MyPara=MyPara+"^Diagnose"+j+String.fromCharCode(2)+DiagnoseArray[k];
				}
			    
			    PrintFun(myobj,MyPara,MyList);	
			    
			    var lczdzy="过一个月量";
			    var lczdzy1="服用同一类药物的,可放宽到不超";
			    var lczdzy2="两周量.特殊疾病病情稳定需长期";
			    var lczdzy3="不超过七天量,行动不便的不超过"
			    var lczdzy4="急性疾病不超过3天量.慢性疾病";
			    var lczdzy6="注意事项"
			    var zf="[底方]"
			    
			    
			  var myobj=document.getElementById("ClsBillPrint");
                     var MyList=""
          var MyPara="";
			    MyPara=MyPara+"hospitalcode"+String.fromCharCode(2)+hospitalcode;
			    MyPara=MyPara+"^zf"+String.fromCharCode(2)+zf;
			    /*
			    MyPara=MyPara+"^lczdzy"+String.fromCharCode(2)+lczdzy;
			    MyPara=MyPara+"^lczdzy1"+String.fromCharCode(2)+lczdzy1;
			    MyPara=MyPara+"^lczdzy2"+String.fromCharCode(2)+lczdzy2;
			    MyPara=MyPara+"^lczdzy3"+String.fromCharCode(2)+lczdzy3;
			    MyPara=MyPara+"^lczdzy4"+String.fromCharCode(2)+lczdzy4;
			    MyPara=MyPara+"^lczdzy6"+String.fromCharCode(2)+lczdzy6;
			    */
			    MyPara=MyPara+"^PapmiNo"+String.fromCharCode(2)+PapmiNo;
			    MyPara=MyPara+"^presc"+String.fromCharCode(2)+presc;
			    MyPara=MyPara+"^PatientName"+String.fromCharCode(2)+PatientName;
			    MyPara=MyPara+"^pname"+String.fromCharCode(2)+pname;
			    MyPara=MyPara+"^sex"+String.fromCharCode(2)+sex;
			    MyPara=MyPara+"^age"+String.fromCharCode(2)+age;
			    MyPara=MyPara+"^GovernCardNo"+String.fromCharCode(2)+GovernCardNo;
			    MyPara=MyPara+"^OEORIOrdDept"+String.fromCharCode(2)+OEORIOrdDept;
			    MyPara=MyPara+"^PatientComAdd"+String.fromCharCode(2)+PatientComAdd;
			    MyPara=MyPara+"^PatientName"+String.fromCharCode(2)+PatientName;
			    MyPara=MyPara+"^DurationDesc"+String.fromCharCode(2)+DurationDesc;
			    MyPara=MyPara+"^PHCINDesc"+String.fromCharCode(2)+PHCINDesc;
			    MyPara=MyPara+"^note"+String.fromCharCode(2)+note.substr(0,8);
			    MyPara=MyPara+"^note1"+String.fromCharCode(2)+note.substr(8,8);
			    MyPara=MyPara+"^note2"+String.fromCharCode(2)+note.substr(16,8);
			    MyPara=MyPara+"^note3"+String.fromCharCode(2)+note.substr(24,8);
			    MyPara=MyPara+"^OEORIDoctor"+String.fromCharCode(2)+OEORIDoctor;
			    MyPara=MyPara+"^cydate2"+String.fromCharCode(2)+cydate2;
			    MyPara=MyPara+"^qyks"+String.fromCharCode(2)+qyks;
			    MyPara=MyPara+"^cy1"+String.fromCharCode(2)+cy2[0];
			    MyPara=MyPara+"^cy2"+String.fromCharCode(2)+cy2[1];
			    MyPara=MyPara+"^cy3"+String.fromCharCode(2)+cy2[2];
			    MyPara=MyPara+"^cy4"+String.fromCharCode(2)+cy2[3];
			    MyPara=MyPara+"^cy5"+String.fromCharCode(2)+cy2[4];
			    MyPara=MyPara+"^cy6"+String.fromCharCode(2)+cy2[5];
			    MyPara=MyPara+"^cy7"+String.fromCharCode(2)+cy2[6];
			    MyPara=MyPara+"^cy8"+String.fromCharCode(2)+cy2[7];
			    MyPara=MyPara+"^cy9"+String.fromCharCode(2)+cy2[8];
			    MyPara=MyPara+"^cy10"+String.fromCharCode(2)+cy2[9];
			    MyPara=MyPara+"^cy11"+String.fromCharCode(2)+cy2[10];
			    MyPara=MyPara+"^cy12"+String.fromCharCode(2)+cy2[11];
			    MyPara=MyPara+"^cy13"+String.fromCharCode(2)+cy2[12];
			    MyPara=MyPara+"^cy14"+String.fromCharCode(2)+cy2[13];
			    MyPara=MyPara+"^cy15"+String.fromCharCode(2)+cy2[14];
			    MyPara=MyPara+"^cy16"+String.fromCharCode(2)+cy2[15];
			    MyPara=MyPara+"^cy17"+String.fromCharCode(2)+cy2[16];
			    MyPara=MyPara+"^cy18"+String.fromCharCode(2)+cy2[17];
			    MyPara=MyPara+"^cy19"+String.fromCharCode(2)+cy2[18];
			    MyPara=MyPara+"^cy20"+String.fromCharCode(2)+cy2[19];
			    MyPara=MyPara+"^cy21"+String.fromCharCode(2)+cy2[20];
			    MyPara=MyPara+"^cy22"+String.fromCharCode(2)+cy2[21];
			    MyPara=MyPara+"^cy23"+String.fromCharCode(2)+cy2[22];
			    MyPara=MyPara+"^cy24"+String.fromCharCode(2)+cy2[23];
			    MyPara=MyPara+"^cy25"+String.fromCharCode(2)+cy2[24];
			    MyPara=MyPara+"^cy26"+String.fromCharCode(2)+cy2[25];
			    MyPara=MyPara+"^cy27"+String.fromCharCode(2)+cy2[26];
			    MyPara=MyPara+"^cy28"+String.fromCharCode(2)+cy2[27];
			    MyPara=MyPara+"^cy29"+String.fromCharCode(2)+cy2[28];
			    MyPara=MyPara+"^cy30"+String.fromCharCode(2)+cy2[29];
			    MyPara=MyPara+"^cy31"+String.fromCharCode(2)+cy2[30];
			    MyPara=MyPara+"^cy32"+String.fromCharCode(2)+cy2[31];
			   MyPara=MyPara+"^bz1"+String.fromCharCode(2)+bz[0].split("/")[0];
			    MyPara=MyPara+"^bz2"+String.fromCharCode(2)+bz[1].split("/")[0];
			    MyPara=MyPara+"^bz3"+String.fromCharCode(2)+bz[2].split("/")[0];
			    MyPara=MyPara+"^bz4"+String.fromCharCode(2)+bz[3].split("/")[0];
			    MyPara=MyPara+"^bz5"+String.fromCharCode(2)+bz[4].split("/")[0];
			    MyPara=MyPara+"^bz6"+String.fromCharCode(2)+bz[5].split("/")[0];
			    MyPara=MyPara+"^bz7"+String.fromCharCode(2)+bz[6].split("/")[0];
			    MyPara=MyPara+"^bz8"+String.fromCharCode(2)+bz[7].split("/")[0];
			    MyPara=MyPara+"^bz9"+String.fromCharCode(2)+bz[8].split("/")[0];
			    MyPara=MyPara+"^bz10"+String.fromCharCode(2)+bz[9].split("/")[0];
			    MyPara=MyPara+"^bz11"+String.fromCharCode(2)+bz[10].split("/")[0];
			    MyPara=MyPara+"^bz12"+String.fromCharCode(2)+bz[11].split("/")[0];
			    MyPara=MyPara+"^bz13"+String.fromCharCode(2)+bz[12].split("/")[0];
			    MyPara=MyPara+"^bz14"+String.fromCharCode(2)+bz[13].split("/")[0];
			    MyPara=MyPara+"^bz15"+String.fromCharCode(2)+bz[14].split("/")[0];
			    MyPara=MyPara+"^bz16"+String.fromCharCode(2)+bz[15].split("/")[0];
			    MyPara=MyPara+"^bz17"+String.fromCharCode(2)+bz[16].split("/")[0];
			    MyPara=MyPara+"^bz18"+String.fromCharCode(2)+bz[17].split("/")[0];
			    MyPara=MyPara+"^bz19"+String.fromCharCode(2)+bz[18].split("/")[0];
			    MyPara=MyPara+"^bz20"+String.fromCharCode(2)+bz[19].split("/")[0];
			    MyPara=MyPara+"^bz21"+String.fromCharCode(2)+bz[20].split("/")[0];
			    MyPara=MyPara+"^bz22"+String.fromCharCode(2)+bz[21].split("/")[0];
			    MyPara=MyPara+"^bz23"+String.fromCharCode(2)+bz[22].split("/")[0];
			    MyPara=MyPara+"^bz24"+String.fromCharCode(2)+bz[23].split("/")[0];
			    MyPara=MyPara+"^bz25"+String.fromCharCode(2)+bz[24].split("/")[0];
			    MyPara=MyPara+"^bz26"+String.fromCharCode(2)+bz[25].split("/")[0];
			    MyPara=MyPara+"^bz27"+String.fromCharCode(2)+bz[26].split("/")[0];
			    MyPara=MyPara+"^bz28"+String.fromCharCode(2)+bz[27].split("/")[0];
			    MyPara=MyPara+"^bz29"+String.fromCharCode(2)+bz[28].split("/")[0];
			    MyPara=MyPara+"^bz30"+String.fromCharCode(2)+bz[29].split("/")[0];
			    MyPara=MyPara+"^bz31"+String.fromCharCode(2)+bz[30].split("/")[0];
			    MyPara=MyPara+"^bz32"+String.fromCharCode(2)+bz[31].split("/")[0];
			    MyPara=MyPara+"^lyq"+String.fromCharCode(2)+lyq;
			    MyPara=MyPara+"^yf"+String.fromCharCode(2)+je5;
			    MyPara=MyPara+"^Louyq"+String.fromCharCode(2)+Louyq;
			    
			    MyPara=MyPara+"^cjg1"+String.fromCharCode(2)+cjg[0];
			    MyPara=MyPara+"^cjg2"+String.fromCharCode(2)+cjg[1];
			    MyPara=MyPara+"^cjg3"+String.fromCharCode(2)+cjg[2];
			    MyPara=MyPara+"^cjg4"+String.fromCharCode(2)+cjg[3];
			    MyPara=MyPara+"^cjg5"+String.fromCharCode(2)+cjg[4];
			    MyPara=MyPara+"^cjg6"+String.fromCharCode(2)+cjg[5];
			    MyPara=MyPara+"^cjg7"+String.fromCharCode(2)+cjg[6];
			    MyPara=MyPara+"^cjg8"+String.fromCharCode(2)+cjg[7];
			    MyPara=MyPara+"^cjg9"+String.fromCharCode(2)+cjg[8];
			    MyPara=MyPara+"^cjg10"+String.fromCharCode(2)+cjg[9];
			    MyPara=MyPara+"^cjg11"+String.fromCharCode(2)+cjg[10];
			    MyPara=MyPara+"^cjg12"+String.fromCharCode(2)+cjg[11];
			    MyPara=MyPara+"^cjg13"+String.fromCharCode(2)+cjg[12];
			    MyPara=MyPara+"^cjg14"+String.fromCharCode(2)+cjg[13];
			    MyPara=MyPara+"^cjg15"+String.fromCharCode(2)+cjg[14];
			    MyPara=MyPara+"^cjg16"+String.fromCharCode(2)+cjg[15];
			    MyPara=MyPara+"^cjg17"+String.fromCharCode(2)+cjg[16];
			    MyPara=MyPara+"^cjg18"+String.fromCharCode(2)+cjg[17];
			    MyPara=MyPara+"^cjg19"+String.fromCharCode(2)+cjg[18];
			    MyPara=MyPara+"^cjg20"+String.fromCharCode(2)+cjg[19];
			    MyPara=MyPara+"^cjg21"+String.fromCharCode(2)+cjg[20];
			    MyPara=MyPara+"^cjg22"+String.fromCharCode(2)+cjg[21];
			    MyPara=MyPara+"^cjg23"+String.fromCharCode(2)+cjg[22];
			    MyPara=MyPara+"^cjg24"+String.fromCharCode(2)+cjg[23];
			    MyPara=MyPara+"^cjg25"+String.fromCharCode(2)+cjg[24];
			    MyPara=MyPara+"^cjg26"+String.fromCharCode(2)+cjg[25];
			    MyPara=MyPara+"^cjg27"+String.fromCharCode(2)+cjg[26];
			    MyPara=MyPara+"^cjg28"+String.fromCharCode(2)+cjg[27];
			    MyPara=MyPara+"^cjg29"+String.fromCharCode(2)+cjg[28];
			    MyPara=MyPara+"^cjg30"+String.fromCharCode(2)+cjg[29];
			    MyPara=MyPara+"^cjg31"+String.fromCharCode(2)+cjg[30];
			    MyPara=MyPara+"^cjg32"+String.fromCharCode(2)+cjg[31];
			    
			    //MyPara=MyPara+"^mjjg"+String.fromCharCode(2)+je6;
			    MyPara=MyPara+"^djf"+String.fromCharCode(2)+djf;
			    MyPara=MyPara+"^Fre"+String.fromCharCode(2)+Fre.split(" ")[1];
			    MyPara=MyPara+"^Fre1"+String.fromCharCode(2)+Fre.split(" ")[0];
			    MyPara=MyPara+"^MakeEach"+String.fromCharCode(2)+MakeEach;
			    MyPara=MyPara+"^AllMake"+String.fromCharCode(2)+AllMake;
			    MyPara=MyPara+"^CosDesc"+String.fromCharCode(2)+CosDesc;
			    var DiagnoseArrayLen=DiagnoseArray.length;
					for (var k=0;k<DiagnoseArrayLen;k++) {
						var j=k+1;
						MyPara=MyPara+"^Diagnose"+j+String.fromCharCode(2)+DiagnoseArray[k];
					}
					if (OnlyOriginal==false){PrintFun(myobj,MyPara,MyList)};
					}	 
			}
}

function CopyClickHandler(){
	var Copyary=new Array();
	
	var par_win = window.opener;
  try{
		var objtbl=document.getElementById("tUDHCPrescriptQueryCM");
		var rows=objtbl.rows.length;
		for (var i=1; i<rows; i++){
			for (var j=1; j<5; j++){
				var sel=GetColumnData("select"+j,i);
				if (sel){
					var HidddenPara=GetColumnData("HiddenPara"+j,i);
					if (HidddenPara!=""){
						var arcim=HidddenPara.split("!")[0]
						var ret=tkMakeServerCall("web.DHCDocOrderEntryCM","CheckArcimActiveDate",arcim)
						if (ret!=0){
							alert(ret.split("^")[1])
							return false
						}
						Copyary[Copyary.length]=HidddenPara;
					}
				}
			}
		}
		
		if (Copyary.length==0) {
			alert("请选择需要复制的医嘱.");
			return;
		}
	}catch(e){alert(e.message)}
	if (par_win){
		if	(Copyary.length!=0){
			//par_win.AddCopyItemToList(Copyary);
			par_win.AddCopyItemToListFromQuery(Copyary);
		}
		window.setTimeout("Copy_click();",500);
	}


}

function GetColumnData(ColName,Row){
	var CellObj=document.getElementById(ColName+"z"+Row);
	//alert(CellObj.id+"^"+CellObj.tagName+"^"+CellObj.value);
	if (CellObj.tagName=='LABEL'){
		return CellObj.value;
	}else{
		if (CellObj.type=="checkbox"){
			return CellObj.checked;
		}else{
			return CellObj.value;}
		}
	return "";
}

function getks(str)
{
	//alert(str);
	obj=str.split("^");
	document.getElementById('loc').value=obj[1];
}
function ReadCardType(){
	DHCC_ClearList("CardType");
	var encmeth=DHCC_GetElementData("CardTypeEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCC_AddToListA","CardType");
	}
}
function ReadCardClickHandler(){
	var CardTypeRowId=GetCardTypeRowId();
	var myoptval=combo_CardType.getSelectedValue();
	var myrtn=DHCACC_GetAccInfo(CardTypeRowId,myoptval);
	var myary=myrtn.split("^");
	var rtn=myary[0];
	AccAmount=myary[3];

	switch (rtn){
		case "0": //卡有效
				var PatientID=myary[4];
				var PatientNo=myary[5];
				var CardNo=myary[1]
				var NewCardTypeRowId=myary[8];
				if (NewCardTypeRowId!=CardTypeRowId) combo_CardType.setComboValue(NewCardTypeRowId);
				SetPatientInfo(PatientNo,CardNo,PatientID);
				//event.keyCode=13;
				//Find_click(e);
				search_click();
						
			break;
		case "-200": //卡无效
			alert(t['InvaildCard']);
			websys_setfocus('RegNo');
			break;
		case "-201": //现金
			//alert(t['21']);
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			var NewCardTypeRowId=myary[8];
			if (NewCardTypeRowId!=CardTypeRowId) combo_CardType.setComboValue(NewCardTypeRowId);

			SetPatientInfo(PatientNo,CardNo,PatientID);
			//Find_click();				
			//DHCC_SelectOptionByCode("PayMode","CASH")
			break;
		default:
	}
}
function PatNoObj_keydown(e) {
	var key=websys_getKey(e);
	if (key==13) {
		var CardNo=DHCC_GetElementData("CardNo");
		var PatientID=DHCC_GetElementData("PatientID");
		var PatientNo=DHCC_GetElementData("PatientNo");
		if(PatientNo!=""){
			var GetDetail=document.getElementById('GetPatIDByPatNo');
			if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
			var PatientID=cspRunServerMethod(encmeth,PatientNo)
			if(PatientID=="")alert("此病人ID不存在")
			SetPatientInfo(PatientNo,CardNo,PatientID);
			search_click();	
			
		}
	}
}
function PatMedObj_keydown(e) {
	var key=websys_getKey(e);
	if (key==13) {
		var CardNo=DHCC_GetElementData("CardNo");
		var PatientID=DHCC_GetElementData("PatientID");
		var PatientNo=DHCC_GetElementData("PatientNo");
		var PatMed=DHCC_GetElementData("PatMed");
		if(PatMed!=""){
			var GetDetail=document.getElementById('GetPatIDByInMedNo');
			if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
			var Ret=cspRunServerMethod(encmeth,PatMed)
			if(Ret==""){alert("此病人不存在")}
			else{
			 PatientID=Ret.split("^")[0]
			 PatientNo=Ret.split("^")[1]
			SetPatientInfo(PatientNo,CardNo,PatientID);
			}
		}
	}
}
function CardNoKeydownHandler(e) {
	//这边要与卡处理一致
	if (evtName=='CardNo') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var key=websys_getKey(e);
	if (key==13) {
		var CardNo=DHCC_GetElementData("CardNo");
		CardNo=FormatCardNo();
		if (CardNo=="") return;
		var CardTypeRowId=GetCardTypeRowId();
		var rtn=DHCACC_DisabledCardType("CardType",CardNo,CardTypeRowId);
		if(!rtn) return false;
		var myrtn=DHCACC_GetAccInfo(CardTypeRowId,CardNo,"","PatInfo");
		//alert(myrtn);
		var myary=myrtn.split("^");
		var rtn=myary[0];
		AccAmount=myary[3];
		switch (rtn){
			case "0": //卡有效有帐户
				var PatientID=myary[4];
				var PatientNo=myary[5];
				var CardNo=myary[1]
				var NewCardTypeRowId=myary[8];
				if (NewCardTypeRowId!=CardTypeRowId) combo_CardType.setComboValue(NewCardTypeRowId);
				SetPatientInfo(PatientNo,CardNo,PatientID);
				event.keyCode=13;
				//FID_key(e);				
				break;
			case "-200": //卡无效
				alert(t['InvaildCard']);
				websys_setfocus('CardNo');
				break;
			case "-201": //卡有效无帐户
				//alert(t['21']);
				var PatientID=myary[4];
				var PatientNo=myary[5];
				var CardNo=myary[1]
				var NewCardTypeRowId=myary[8];
				if (NewCardTypeRowId!=CardTypeRowId) combo_CardType.setComboValue(NewCardTypeRowId);
				SetPatientInfo(PatientNo,CardNo,PatientID);
				event.keyCode=13;
				//DHCC_SelectOptionByCode("PayMode","CASH")
				break;
			default:
		}
	}
}
function combo_CardTypeKeydownHandler(){
	var myoptval=combo_CardType.getSelectedValue();
	var myary=myoptval.split("^");
	var myCardTypeDR=myary[0];	
	if (myCardTypeDR=="")	{	return;	}
	if (myary[16]=="Handle"){
		var myobj=document.getElementById("CardNo");
		if (myobj){myobj.readOnly = false;}
		DHCWeb_DisBtnA("ReadCard");
		DHCWeb_setfocus("CardNo");
	}	else{
		
		//m_CCMRowID=GetCardEqRowId();
		var myobj=document.getElementById("CardNo");
		//if (myobj){myobj.readOnly = true;}
		if (myobj){myobj.readOnly = false;}     //郭荣勇 支持手输卡号功能
		var obj=document.getElementById("ReadCard");
		if (obj){
			obj.disabled=false;
			DHCC_AvailabilityBtn(obj)
			obj.onclick=ReadCardClickHandler;
		}
		DHCWeb_setfocus("ReadCard");
	}
	
	if (combo_CardType) websys_nexttab(combo_CardType.tabIndex);
}
function GetCardTypeRowId(){
	var CardTypeRowId="";
	//var CardTypeValue=DHCC_GetElementData("CardType");
	var CardTypeValue=combo_CardType.getSelectedValue();
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^")
		CardTypeRowId=CardTypeArr[0];
	}
	return CardTypeRowId;
}
function SetPatientInfo(PatientNo,CardNo,PatientID){
	DHCC_SetElementData("PatientID",PatientID);
	DHCC_SetElementData("PatientNo",PatientNo);
	DHCC_SetElementData("CardNo",CardNo);
	
	if (PatientID!=""){
		var encmeth=DHCC_GetElementData("GetPatInfo");
		if (encmeth!=""){
			var PatInfo=cspRunServerMethod(encmeth,PatientID);
			var tempArr=PatInfo.split("^");
			var PatName=tempArr[2];
			var PatSex=tempArr[3];
			var InsurFlag=tempArr[32];
			var PatEncryptLevel=tkMakeServerCall("web.DHCBL.CARD.UCardPaPatMasInfo","GetPatEncryptLevel",PatientID,"");
			//alert(PatEncryptLevel)
			if (PatEncryptLevel!="") {
				var PatEncryptLevelArr=PatEncryptLevel.split("^");
				var obj1=document.getElementById("PoliticalLevel");
				if(obj1) obj1.value=PatEncryptLevelArr[1];
				var obj1=document.getElementById("SecretLevel");
				if(obj1) obj1.value=PatEncryptLevelArr[0];
			}
			//alert("DefaultBillType:"+tempArr[31]+"InsurFlag:"+InsurFlag);
			DHCC_SetElementData("PatName",PatName);
			DHCC_SetElementData("sex",PatSex);
			DHCC_SetElementData("PatientNo",tempArr[1]);
		}
	}
}
function GetCardNoLength(){
	var CardNoLength="";
	var CardTypeValue=DHCC_GetElementData("CardType");
	var CardTypeValue=combo_CardType.getSelectedValue();
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^");
		CardNoLength=CardTypeArr[17];
	}
	if (HospitalCode=='HXYY')	return 15;
	return CardNoLength;
}

function FormatCardNo(){
	var CardNo=DHCC_GetElementData("CardNo");
	if (CardNo!='') {
		var CardNoLength=GetCardNoLength();
		if ((CardNo.length<CardNoLength)&&(CardNoLength!=0)) {
			for (var i=(CardNoLength-CardNo.length-1); i>=0; i--) {
				CardNo="0"+CardNo;
			}
		}
	}

	return CardNo
}

document.body.onload = BodyLoadHandler;