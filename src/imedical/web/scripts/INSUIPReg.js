///ҽ����Ժ�Ǽǻ��߲��Ǽ���
///INSUIPReg.js     ---------------------------

var PapmiNo="",AdmDr="",AdmReasonDr="",AdmReasonNationalCode="",CTProvinceCode="",CTCityCode="",CTAreaCode="";       
var Guser=session['LOGON.USERID'];
var UpCardFlag=false ;// ���¿���ʶ DingSH 20160715
var inactFlag="" ; //��Ժ״̬ DingSH20160715
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

		if (PapmiNo==""){Clear();}  //Lou 2010-03-05 ����ǼǺŲ�Ϊ�ղ�����,���HIS�����������ʱ��
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
		
	//ѡ������
	var obj=document.getElementById("PaadmList")
	if (obj){obj.onchange=PaadmList_onchange;}	
	
	//
	var obj=document.getElementById("InsuType")
	if (obj){obj.onchange=InsuType_onchange;}

	//ҽ���Ǽ�
	var obj=document.getElementById("InsuIPReg");
	if (obj){ obj.onclick=InsuIPReg_onclick;}	
	//ȡ���Ǽ�
	var obj=document.getElementById("InsuIPRegCancel");
	if (obj) {obj.onclick=InsuIPRegCancel_onclick;}
	//����
	var obj=document.getElementById("InsuReadCard");
	if (obj) {obj.onclick=InsuReadCard_onclick;}
	//ҽ����������س��¼�
	var obj=document.getElementById("InsuInDiagDesc")
	if (obj){
		obj.onkeydown=InsuInDiagDesconkeydown;
	}
	//����ҽ�������� 20140917 DingSH
	var obj=document.getElementById("btnUpdINSUCardNo");
	if (obj){ obj.onclick=UpdINSUCardNo_onclick;}
	//����
	var obj=document.getElementById("Clear");	
	if (obj) {obj.onclick=Clear_onclick;}
	
   //��ϼ�¼ 2015-12-16
  var obj=document.getElementById("AdmDiagLst");	
  if (obj) {	
        obj.size=1; 
	  	obj.multiple=false;
	     obj.onchange=AdmDiagLst_onchange;
  }
	//ZLFS_onchange
	///var obj=document.getElementById("ZLFS")
	//if (obj){obj.onclick=ZLFS_onclick;}
	//ҽ�������Ż�ý����¼� 20160715 DingSH
	var obj=document.getElementById("CardNo");
	if (obj){ obj.onfocus=CardNo_onfocus;}
    //ҽ��������ʧȥ�����¼� 20160715 DingSH
	var obj=document.getElementById("CardNo");
	if (obj){ obj.onblur=CardNo_onblur;}
}


	
//*******************************
//1:��ʼ������                    *
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
	obj=document.getElementById("PatID") //���֤����
	if (obj){obj.readOnly=true;}
	//obj=document.getElementById("AdmDate") 
	//if (obj){obj.readOnly=true;} //��Ժ���� 2015-12-16  DingSH �����޸�
	//if (obj){obj.onblur=AdmDate_Checked;}	
	obj=document.getElementById("AdmDate") 
	if (obj){obj.onblur=AdmDate_Checked;}	
	obj=document.getElementById("AdmTime") 
	if (obj){obj.onblur=AdmTime_Checked;}	
	//if (obj){obj.readOnly=true;} //��Ժʱ�� 2015-12-16  DingSH �����޸�
	
	obj=document.getElementById("AdmDate") 
	if (obj){obj.onclick=AdmDate_CheckDisabled;}
	obj=document.getElementById("AdmTime") 
	if (obj){obj.onclick=AdmTime_CheckDisabled;}
	
	obj=document.getElementById("DepDesc")
	if (obj){obj.readOnly=true;}
	//��Ժ���
	obj=document.getElementById("InsuAdmType")
	if (obj){
	  obj.size=1; 
	  obj.multiple=false;	  
	}
	var VerStr="";
	VerStr=tkMakeServerCall("web.INSUDicDataCom","GetSys","","","DLLType");
	if (VerStr=="") {alert("����ҽ���ֵ���ά��DLLType");return;}
	var Arr1=VerStr.split("!")
	obj=document.getElementById("InsuType")
	if (obj){
	  //obj.disabled=true       //���HisסԺ�Ǽǽ����޸��շ�����շ������û�
	  obj.size=1; 
	  obj.multiple=false;
	  //obj.options[0]=new Option("�Է�","");
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
	//���պ�
	obj=document.getElementById("InsuNo")
	if (obj){obj.readOnly=true;}
	//����
	obj=document.getElementById("CardNo")
	//if (obj){obj.readOnly=true;}
	
	///�ɿ���
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
//2:�õ����˵ǼǺ�                     *
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

///2.1.1ȡ���˻�����Ϣ
function GetPatInfo(){	
	var obj=document.getElementById("PapmiNo");    
	if (obj){
		if (obj.value=="")
		{alert("�ǼǺŲ���Ϊ��");
		obj.focus();
		return false;
		}
	}
	var PapmiNoLength=10-obj.value.length;     //�ǼǺŲ���   	
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
	 	alert("ȡ���˻�����Ϣʧ��,��������ȷ�ĵǼǺ�!")
	 	Clear();
	 	return false;
 	}
    aData=OutStr.split("^");
    //alert(aData)
    var obj=document.getElementById("Name")  //����
    if (obj) {obj.value=aData[2];}
    var obj=document.getElementById("Sex")  //�Ա�
    if (obj) {obj.value=aData[4];}
    var obj=document.getElementById("Age")  //����
    if (obj) {obj.value=aData[3];}		
    var obj=document.getElementById("PatID")  //����
    if (obj) {obj.value=aData[8];}
    var obj=document.getElementById("CTProvinceName")  //ʡ
    if (obj) {obj.value=aData[16];}
    var obj=document.getElementById("CTCityName")  //��
    if (obj) {obj.value=aData[18];}
    var obj=document.getElementById("CTAreaName")  //��
    if (obj) {obj.value=aData[20];}
    CTProvinceCode=aData[15];
    CTCityCode=aData[17];
    CTAreaCode=aData[19];
	return true;
}

///���ݵǼǺŲ�ѯ�����¼
function GetPaadmList(){
	var objPaadmList=document.getElementById("PaadmList");		
	if (objPaadmList) {objPaadmList.options.length=0;}
	var Ins=document.getElementById('ClassGetPaadmList');
  	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
 	var OutStr=cspRunServerMethod(encmeth,'','',PapmiNo); 	 
	if (OutStr==""){
		alert("û�в�ѯ�����˾����¼,����ȷ�ϻ����Ƿ�ʿ�ִ�!");
		return false;
	}	
	else
	{
		var Arr1=OutStr.split("!")
		var obj=document.getElementById("AdmDr");		
		if (obj) 
		{
			/*
			if (obj.value!="")   //AdmDr��������ֻ������������¼
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
			//else                             //AdmDrû�д�������������о����¼
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
						if (Arr2[11]=="A"){VisitStatus="��Ժ"}
						if (Arr2[11]=="D"){VisitStatus="��Ժ"}
						if (Arr2[11]=="C"){VisitStatus="��Ժ"}
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
//3:ѡ���˾����¼                *
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
	    //alert("��ѡ������¼!");
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
	
	AdmDr=Arr1[0] ;         ///�����
	AdmReasonDr=Arr1[27]
	 var obj=document.getElementById("AdmDr");
	 if (obj) {obj.value=AdmDr}
	//2015-12-16 DingSH,His�����¼����Ժ״̬������ǼǵȲ���
	if (Arr1[11]=="C")  
	{
		alert("������ң�" +Arr1[4]+"���������ڣ�"+Arr1[5]+" "+Arr1[6]+ "Ϊ��Ժ״̬��������ǼǵȲ���");
		var obj=document.getElementById("InsuIPRegCancel");
	    if (obj) {obj.disabled=true;}
	    var obj=document.getElementById("InsuIPReg");
	    if (obj) {obj.disabled=true;}
	}
	//2015-12-16 DingSH,His��ϼ�¼
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
		  	    if(shwDiagDesc==""){shwDiagDesc=OutAry[i].split("^")[4];IsICD="(�Ǳ�׼���)"} 
				obj.options[j]=new Option(OutAry[i].split("^")[2]+ " "+ shwDiagDesc + " "+ OutAry[i].split("^")[5]+" "+IsICD,OutAry[i]);
				if (OutAry[i].split("^")[5]=="��Ժ���")	{obj.selectedIndex=j}      //ȡĬ��ֵ 
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
	
		var newDicType="AKA130"+InsuType    //ƴҽ������DicType
		VerStr=tkMakeServerCall("web.INSUDicDataCom","GetSys","","",newDicType);
		if (VerStr=="") {alert("����ҽ���ֵ���ά��"+newDicType);return;}
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
				if (Arr1[i].split("^")[9]=="Y")	{obj.selectedIndex=j}      //ȡĬ��ֵ 
				j=j+1;
		  		}			
			}	  
		}
		
		
		ZLFS_ini(); //���Ʒ�ʽ 20160830 DingSH
		BCFS_ini(); //������ʽ 20160830 DingSH
		
		
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
    	//���պ�
		obj=document.getElementById("InsuNo")
		if (obj){obj.value="";}
		//����
		obj=document.getElementById("CardNo");
		if (obj){obj.value="";}
		//��Ա���
		obj=document.getElementById("InsuPatType")
		if (obj){obj.value=""}					
	    //�ʻ�״̬
		obj=document.getElementById("InsuCardStatus");
		if (obj){obj.value=""}	
		//ҽ����Ժ��ϱ���
		obj=document.getElementById("InsuInDiagCode");
		if (obj){obj.value="";}
		//ҽ����Ժ�������
		obj=document.getElementById("InsuInDiagDesc");
		if (obj){obj.value="";}
		obj=document.getElementById("InsuActiveFlag");
		obj.value="δ�Ǽ�";
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
			obj.value="�ѵǼ�";
			obj=document.getElementById("InsuIPRegCancel");
			if (obj) {obj.disabled=false;}
			var obj=document.getElementById("InsuIPReg");
	        if (obj) {obj.disabled=true;}
	        ActBtn(document.getElementById('btnUpdINSUCardNo'))
		}
		if (Arr2[11]=="O"){
			obj=document.getElementById("InsuActiveFlag");
			obj.value="��Ժ";
			obj=document.getElementById("InsuIPRegCancel");
			if (obj) {obj.disabled=false;}
			var obj=document.getElementById("InsuIPReg");
	        if (obj) {obj.disabled=true;}
		}
		if (Arr2[11]=="S"){
			obj=document.getElementById("InsuActiveFlag");
			obj.value="ȡ���Ǽ�";
 	        var obj=document.getElementById("InsuIPRegCancel");
	        if (obj) {obj.disabled=true;}
	        var obj=document.getElementById("InsuIPReg");
	        if (obj) {obj.disabled=false;}
		}
		//���պ�
		obj=document.getElementById("InsuNo")
		if (obj){obj.value=Arr2[2];}
		//����
		obj=document.getElementById("CardNo");
		if (obj){obj.value=Arr2[3];
		          OldCardNo=Arr2[3]}
		
		//�¿����� DingSH 20190905
	    var obj=document.getElementById("NewCardNo");
	    if (obj){obj.value=Arr2[3]} 
		//�ɿ��� DingSH 20190905
		obj=document.getElementById("OldCardNo");
		if (obj){
			obj.value=Arr2[39];  
		         
		}
		//ҽ������
		obj=document.getElementById("InsuType")
		if (obj){
			for (var i=0;i<=obj.options.length-1;i++){
				if (obj.options[i].value==Arr2[18]){
					obj.selectedIndex=i
				}
		 	}
		}	
	
		//ҽ�����
		obj=document.getElementById("InsuAdmType")
		if (obj){
			if(obj.options.length<1){
				var VerStr="";
				var newDicType="AKA130"+Arr2[18]    //ƴҽ������DicType
				VerStr=tkMakeServerCall("web.INSUDicDataCom","GetSys","","",newDicType);
				if (VerStr=="") {alert("����ҽ���ֵ���ά��"+newDicType);return;}
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
		//��Ա���
		obj=document.getElementById("InsuPatType")
		if (obj){
			var TempInsuType=Arr2[18]
			var newDicType="AKC021"+TempInsuType       //��Ա��� 2013 04 08 
			var VerStr="";
			TemppatType=Arr2[4]
			VerStr=tkMakeServerCall("web.INSUDicDataCom","QueryByCode",newDicType,Arr2[4]);
			if (VerStr==""){alert("����ҽ���ֵ���ά����Ա���"+"ϵͳ����Ϊ"+newDicType+",�ֵ����Ϊ"+Arr2[4]);obj.value=""}
			
			else{
				obj.value=VerStr.split("^")[3];}
		}					
	    //�ʻ�״̬
		obj=document.getElementById("InsuCardStatus");
		if (obj){
			if (Arr2[5]==1){obj.value="����";}
			else {obj.value="����";}
		}	
		//ҽ����Ժ��ϱ���
		obj=document.getElementById("InsuInDiagCode");
		if (obj){obj.value=Arr2[26];}
		//ҽ����Ժ�������
		obj=document.getElementById("InsuInDiagDesc");
		if (obj){obj.value=Arr2[27];
		         tDiagDesc=Arr2[27];}
		//��������
		obj=document.getElementById("xzlx");
		if (obj){obj.value=Arr2[37];}
		//�������
		obj=document.getElementById("dylb");
		if (obj){obj.value=Arr2[36];}
		
		//2015-12-16 DingSH �޸�
		if ((Arr2[11]=="A")||(Arr2[11]=="O"))
		{
		//��Ժ����
		obj=document.getElementById("AdmDate");
		//if (obj){obj.value=Arr2[12];}
		//��Ժʱ��
		obj=document.getElementById("AdmTime");
		if (obj){obj.value=Arr2[13];}
		}
		ZLFS_ini(); //���Ʒ�ʽ 20160830 DingSH
		BCFS_ini(); //������ʽ 20160830 DingSH
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
	    alert("��ѡ��ҽ������!");
	    return;
    }
    var newDicType="AKA130"+InsuType    //ƴҽ������DicType
    //alert("newDicType="+newDicType);
    var VerStr="";
	VerStr=tkMakeServerCall("web.INSUDicDataCom","GetSys","","",newDicType);
	//alert("newDicType:"+newDicType+"VerStr"+VerStr);
	if (VerStr=="") {alert("����ҽ���ֵ���ά��"+newDicType);return;}
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
			if (Arr1[i].split("^")[9]=="Y")	{obj.selectedIndex=j}      //ȡĬ��ֵ
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
//ҽ���Ǽ�				        *
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
	    alert("��ѡ��ҽ������!");
	    return;
    }
	var obj=document.getElementById("InsuAdmType")
	if (obj) {
		if (obj.value=="") {
			alert("ҽ������ܿ�");
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
		alert("ҽ��������ƷǷ���������¼��")
		return ;
	}
	//��������
	var AdmDate="";
	obj=document.getElementById("AdmDate") //��Ժ����   20151216 DingSH
	if (obj)
	{
		AdmDate=obj.value;
		//Svar flag=isDate(AdmDate);
		//if(flag==false){alert("��Ժ���ڸ�ʽ�Ƿ��� ��ȷ��ʽ������[2008-08-08]") ;return false;}
	   
	}
	//����ʱ��
	var AdmTime="";
	obj=document.getElementById("AdmTime") // ��Ժʱ��  20151216 DingSH  
	if (obj)
	 {
		AdmTime=obj.value;
		var flag=isTime(AdmTime);
		if(flag==false){alert("��Ժʱ���ʽ�Ƿ��� ��ȷ��ʽ������[16:05:39]") ;return false;}
	 }
	var ZLFSStr	//���Ʒ�ʽ
	obj=document.getElementById("ZLFS")
	if (obj){var ZLFSStr=obj.value}	
	var BCFSStr	//������ʽ
	obj=document.getElementById("BCFS")
	if (obj){var BCFSStr=obj.value}	
	
	TempString=InsuAdmType+"^"+InsuInDiagCode+"^"+InsuInDiagDesc+"^"+InsuNo+"^"+AdmDate+"^"+AdmTime+"^"+ZLFSStr+"^"+BCFSStr+"^"+InsuType
	//�Ǽ�
	//alert(TempString)
	var flag=InsuIPReg(0,Guser,AdmDr,AdmReasonNationalCode, AdmReasonDr,TempString)//DHCInsuPort.js
	//flag=0
	if (+flag<0)  {alert("ҽ���Ǽ�ʧ��");return false;}	
	flag=UpdatePatAdmReason(AdmDr,"",Guser)
	inactFlag="A"; 
	alert("ҽ���Ǽǳɹ�")
	var obj=document.getElementById("InsuIPReg")
	if (obj) {obj.disabled=true;}
 	var obj=document.getElementById("InsuIPRegCancel");
	if (obj) {obj.disabled=false;}
	var obj=document.getElementById("InsuActiveFlag");
	if (obj) {obj.value="�ѵǼ�";}
	PaadmList_onchange()
    //�Ǽǳɹ�������
    //Clear();
    //obj=document.getElementById("PapmiNo");
	//if (obj){obj.value="";obj.focus();} 
	window.status="�Ǽǳɹ�!";	
}

//ȡ���Ǽ�
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
	if(""==AdmDr){alert("��ѡ���˼�������Ϣ!");return;}
	//�Ǽ�ȡ��
	var flag=InsuIPRegStrike(0,Guser,AdmDr, AdmReasonNationalCode, AdmReasonDr,ExpStr) //DHCInsuPort.js
	if (+flag<0) {alert("ȡ���Ǽ�ʧ��");return;}
	alert("ȡ���Ǽǳɹ�")
	var obj=document.getElementById("InsuIPRegCancel");
	if (obj) {obj.disabled=true;}
	var obj=document.getElementById("InsuIPReg");
	if (obj) {obj.disabled=false;}
	var obj=document.getElementById("InsuActiveFlag");
	if (obj) {obj.value="ȡ���Ǽ�";}
	//ȡ���ǼǸ��³��Է� DingSH 20160716 
	var flag=UpdatePatAdmReason(AdmDr,"1",Guser)
	//��ս�����Ϣ
	//PaadmList_onchange();
	PaadmList_onchange()
    window.status="�Ǽǳ������!";	
}

function InsuReadCard_onclick() {
	var obj=document.getElementById("InsuType");
	if (obj) {
		if (obj.value==""){alert("��ѡ��ҽ������");return}
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
		alert("��ҽ�����ɹ�");
		//ҽ�������ز�����ʽ���ο�ҽ���������ع̶������б�V2.0.xls
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
		var IsFlag=confirm("��ҽ�����Ŀ��ţ�"+NewCardNo+",�͵Ǽ�ʱҽ�����ţ�"+CardNo+"��һ�£��Ƿ�����޸�");
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
			alert("����ܿ�");
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
	
	//�Ǽǲ�ѯ
	var rtn=InsuIPRegQuery(Guser,TempString,AdmReasonNationalCode,AdmReasonDr) //DHCINSUPort.js
	//������־|����|����|ְ�����|��������|����Ա|���������ʶ|����־|��ְ�������ݱ�־|����ҽ���취��־|�ȴ��ڱ�ʶ|�����ʶ|�Ǽ����|�ǼǺ�|��ʼ����|��������|��ϱ���|����Ŀ����|�Ǽ�ҽԺ��־|�Ǽ�ҽԺ����
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
	if (List[18]!=""){document.getElementById("InsuActiveFlag").value="��Ժ";}
	var obj=document.getElementById("InsuIPReg");
	if (obj) {obj.disabled=true;}
	var obj=document.getElementById("InsuIPRegCancel");
	if (obj) {obj.disabled=false;}

}


 //����ҽ��������
 function UpdINSUCardNo_onclick(){
	var btnobj=document.getElementById("btnUpdINSUCardNo");
	if(btnobj.disabled==true){return;}
	var NewCardNo=document.getElementById("NewCardNo").value;
 	if ((NewCardNo=="")||((NewCardNo==" "))){		   
  	  	alert("�޸ĵ�ҽ������Ϊ�գ�����д");
   	 	return;   
	 }
	 if (NewCardNo==OldCardNo){		   
  	  	alert("�޸ĵ�ҽ������û�仯����������д");
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
	  alert("����ҽ��������Ϣ�ɹ�!");
	  OldCardNo=NewCardNo; //���³ɹ����µĿ��ű�ɾͿ�����
	  UpCardFlag=true;
	}
	else
	{
		alert("����ҽ��������Ϣʧ��")
		
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
	
//����ʧȥУ������ DingSH 20151216
function AdmDate_Checked(){
	
	var AdmDate="";
	obj=document.getElementById("AdmDate") //��Ժ����   20151216 DingSH
	if (obj)
	{
		AdmDate=obj.value;
		var flag=isDate(AdmDate);
		if(flag==false){alert("��Ժ���ڸ�ʽ�Ƿ��� ��ȷ��ʽ������[2008-08-08]") ;return false;}
	   
	}

	}
	
//����ʧȥУ��ʱ�� DingSH 20151216	
function AdmTime_Checked()
{
	//����ʱ��
	var AdmTime="";
	obj=document.getElementById("AdmTime") // ��Ժʱ��  20151216 DingSH  
	if (obj)
	 {
		AdmTime=obj.value;
		var flag=isTime(AdmTime);
		if(flag==false){alert("��Ժʱ���ʽ�Ƿ��� ��ȷ��ʽ������[16:05:39]") ;return false;}
	 }
}	


//У����Ժ�����Ƿ�ɱ༭ kongjian 20180516
function AdmDate_CheckDisabled(){
	obj=document.getElementById("AdmDate") //��Ժ����   20151216 DingSH
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
	
//У����Ժʱ���Ƿ�ɱ༭ kongjian 20180516	
function AdmTime_CheckDisabled()
{
	//����ʱ��
	obj=document.getElementById("AdmTime") // ��Ժʱ��  20151216 DingSH  
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

	
//1 ��ʱ�䣬���� (13:04:06) DingSH 20151216
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

//2. �����ڣ����� (2008-08-08) DingSH 20151216
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

//Zhan 20160114���Ʒ�ʽ�б�
//��Ҫ����ҽ���������ֵ���sys��ά���ڵ�
//����BJZLFS
function ZLFS_ini(){
	var obj=document.getElementById("InsuType");	
	var InsuType=obj[obj.selectedIndex].value;
    if (InsuType==""){
	    var obj=document.getElementById("InsuType");
	    if (obj) {obj.selectedIndex=0}
	    alert("��ѡ��ҽ������!");
	    return;
    }
    var newDicType="ZLFS"+InsuType    //ƴ���Ʒ�ʽ
    var VerStr="";
	VerStr=tkMakeServerCall("web.INSUDicDataCom","GetSys","","",newDicType);
	//alert("newDicType:"+newDicType+",VerStr"+VerStr);
	if (VerStr=="") {alert("����ҽ���ֵ���ά�����Ʒ�ʽ�ڵ㣺"+newDicType);return;}
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
			if (Arr1[i].split("^")[9]=="Y")	{obj.selectedIndex=j}      //ȡĬ��ֵ
			j=j+1;	
		}	
	}	
}
//Zhan 20160114������ʽ�б�
//��Ҫ����ҽ���������ֵ���sys��ά���ڵ�
//����BJBCFS
function BCFS_ini(){
	var obj=document.getElementById("InsuType");	
	var InsuType=obj[obj.selectedIndex].value;
    if (InsuType==""){
	    var obj=document.getElementById("InsuType");
	    if (obj) {obj.selectedIndex=0}
	    alert("��ѡ��ҽ������!");
	    return;
    }
    var newDicType="BCFS"+InsuType    //ƴ������ʽ
    var VerStr="";
	VerStr=tkMakeServerCall("web.INSUDicDataCom","GetSys","","",newDicType);
	//alert("newDicType:"+newDicType+",VerStr"+VerStr);
	if (VerStr=="") {alert("����ҽ���ֵ���ά��������ʽ�ڵ㣺"+newDicType);return;}
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
			if (Arr1[i].split("^")[9]=="Y")	{obj.selectedIndex=j}      //ȡĬ��ֵ
			j=j+1;	
		}	
	}	
}
//CardNo ��ȡ�����¼� DingSH 20160715
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
//CardNo ʧȥ�����¼� DingSH 20160715	 
function CardNo_onblur()
{
	var NewCard=""
	var obj=document.getElementById("CardNo");
	if (obj){NewCard=obj.value;}
	var obj=document.getElementById("NewCardNo");
	if (obj){obj.value=NewCard;}
}
	
 //����Padm.Rowid ���·ѱ�
 //ReadId Ϊ��ʱ  ���� ҽ���Ǽ���Ϣ ���� ��Ա��� ���·ѱ�
 //ReadId ��Ϊ��ʱ ���ݴ����ReadId���и��·ѱ�
//DingSH 20160713	
function UpdatePatAdmReason(AdmDr,ReadId,ExpStr)
{
	
    var Flag="";
	Flag=tkMakeServerCall("web.DHCINSUIPReg","UpdatePatAdmReason",AdmDr,ReadId,ExpStr);
	//if (Flag=="") {alert("����ҽ���ֵ���ά��DLLType");return;}
	return Flag;
 }	
//�ر���ҳ��ˢ��ҳ�津������	
// DingSH 20170716
/*function BodyUnLoadHandler()
{
	//alert("inactFlag="+inactFlag+"^AdmDr="+AdmDr)
	if ((inactFlag=="")&&(AdmDr!=""))
	{
		UpdatePatAdmReason(AdmDr,"1",Guser) ;//��ҳ�������رո��³��Է�
	 }
	
}*/	
document.body.onload = BodyLoadHandler;
//document.body.onbeforeunload = BodyUnLoadHandler;

	
/*���³�������Ŀ��ֲ����   ������Ҳο���Ҫ��Ӵ�������   �����������
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
//����ҽ�������ݵõ�������Ϣ
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
		//tgtobj.onclick=function() 	//��������δ���󣬰�ť��click�¼���Ҳ�޷����������� disabled��ֵ��
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