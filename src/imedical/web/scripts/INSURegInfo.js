//ղ���� 20120717,���صǼ�
var tmpClearStr="^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
function BodyLoadHandler() {
	//�ǼǺ��¼�
	var objRegID=$("PatRegID");
	if(objRegID){
		objRegID.onkeydown=function(){
			if(window.event.keyCode==13){
				var tmpstr=GetPatInfoByRegNo(objRegID.value);
				if(""!=tmpstr){
					FillPatInfo(tmpstr)
					//��ѯ�ǼǼ�¼
					QueryMTHistory();
				}
			}
		}
	}
	//�Ǽ�
	var objBtnReg=$("BtnReg");
	if(objBtnReg){
		objBtnReg.onclick=BtnReg_Click;
	}	
	//�Ǽ���Ϣ����
	var objBtnMTDownload=$("BtnMTDownload");
	if(objBtnMTDownload){
		objBtnMTDownload.onclick=MTDownload;
	}
	//�����Ǽ�
	var objBtnBtnDestory=$("BtnDestory");
	if(objBtnBtnDestory){
		objBtnBtnDestory.onclick=BtnDestory_Click;
	}
	//����ҽԺ
	var objHosLvl3=$("HosLvl3");
	if(objHosLvl3){
		objHosLvl3.onkeydown=function(){
			if(window.event.keyCode==13){
				window.event.keyCode=117;
				HosLvl3_lookuphandler();
			}
		}
	}
	//����ҽԺ
	var objHosLvl2=$("HosLvl2");
	if(objHosLvl2){
		objHosLvl2.onkeydown=function(){
			if(window.event.keyCode==13){
				window.event.keyCode=117;
				HosLvl2_lookuphandler();
			}
		}
	}
	//һ��ҽԺ
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
	
	Initialize();	//��ʼ������Ԫ��
}

//��ʼ������Ԫ��
function Initialize(){
	//�Ǽǲ���
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
	//�ǼǼ�¼
	var obj=$("MTRegHistory");
	if (obj){
		obj.size=1; 
		obj.multiple=false;
		obj.options[0]=new Option("","");
	}
	//�籣����
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
	//�ǼǷ�ʽ
	var obj=$("PatMTRegType");
	if (obj){
		obj.size=1; 
		obj.multiple=false;
		obj.options[0]=new Option("�״�","1");
		obj.options[1]=new Option("����","2");
		obj.options[2]=new Option("�����״�","3");
	}
}
//ͨ���ǼǺŲ�ѯ���˻�����Ϣ
function GetPatInfoByRegNo(RegNO){
	if(""==RegNO) return "";
	var PatStr=tkMakeServerCall("web.INSUBase","GetPaPamasInfo",RegNO)
	return PatStr
}
//��䲡�˻�����ϢԪ��
function FillPatInfo(InArgs){
	if(""==InArgs) return;
	var tmpArr=InArgs.split("^")
	if(tmpArr.length<8){
		//������Ϣ
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
//��ѯ����ҽԺ
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
//ҽ���ǼǱ���
function DocSave_Click(){
	if($("DocSave").disabled==true) return;
	var tmpRegRowid=$("RegRowid").value;
	if(($("MTRegHistory").options.length>1)&(""==tmpRegRowid)){
		if(confirm("���������صǼǼ�¼,�Ƿ��¿��Ǽ�?")){
		}else{
			alert("��ѡ��ǼǼ�¼!�޸ĺ󱣴�")
			return;
		}
	}
	var tmpRegNo=$("PatRegID").value;
	if(tmpRegNo.length!=10){alert("�ǼǺŷǷ�!");return;}
	var tmpMTBeginDate=$("MTBeginDate").value;
	if(tmpMTBeginDate.length!=10){alert("��ѡ�����صǼǿ�ʼ����!");return;}
	//var tmpPapmiDr=$("PapmiDr").value;
	var PatName=$("PatName").value;
	if(""==PatName){return;}
	var tmpPatID=$("PatID").value;	//���֤��
	var tmpDiagnose=$("PatRegMTBZ").value;	//�Ǽǲ���
	if(""==tmpDiagnose) {alert("��ѡ�����ز���!");return;}
	var tmpPatHst=$("PatHst").value;	//��ʷ
	var tmpNote=$("Note").value;	//�������
	var tmpDiagnosis=$("Diagnosis").value;	//�ٴ����
	var DocCode=session['LOGON.USERCODE'];
	var tmpRegType=$("PatMTRegType").value;		//�Ǽ����
	var tmpTel=$("PatPhone").value;
	var tmpAddress=$("PatAddress").value;		//��ͥ��ַ
	var SaveStr=tmpRegRowid+"^"+tmpRegNo+"^"+PatName+"^"+tmpPatID+"^"+tmpDiagnose+"^D^^^^^MTDJ^"+tmpRegType+"^^^A^"+DocCode+"^^^^^^^^^^^^^^^^^^^^^^^"+tmpPatHst+"^"+tmpNote+"^"+tmpDiagnosis+"^"+tmpTel+"^"+tmpAddress+"^^^^^^^^";
	SaveStr=SaveStr+"^"+tmpMTBeginDate;
	var RtnCode=tkMakeServerCall("web.DHCINSUAdmInfoCtl","SaveINSURegInfo",SaveStr)
	if(eval(RtnCode)>0){alert("����ɹ�!")}
}
//��ѯ�Ǽ���ʷ
function QueryMTHistory(){
	var RtnStr=tkMakeServerCall("web.DHCINSUAdmInfoCtl","QueryMTRegInfo",$("PatRegID").value)
	var objHisList=document.getElementById("MTRegHistory")
	if(RtnStr.length>100){
		objHisList.options.length=0;
		//��������б�
		objHisList.options[0]=new Option("		�еǼǼ�¼,��ѡ��......	","");
		var tmpArr=RtnStr.split("$");
		for(var i=1;i<tmpArr.length;i++){
			var tmparr2=tmpArr[i].split("^");
			var tmpstr="���ؿ�ʼ����:"+tmparr2[51]+",��������"+tmparr2[53]+",�Ǽǲ���:"+tmparr2[4]
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

//��䲡�˵Ǽ���Ϣ
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
	if("D"==tmpArr[5]) tmpArr[5]="ҽ���ѵǼ�"
	if("I"==tmpArr[5]) tmpArr[5]="���߳ɹ�"
	$("RegFlag").value=tmpArr[5];	//�Ǽ�״̬
	$("PatType").value=tmpArr[7];	//��Ա���
	$("PatPhone").value=tmpArr[41];
	$("PatAddress").value=tmpArr[42];
	$("DocCode").value=tmpArr[15];	//���ҽʦ
	$("MTBeginDate").value=tmpArr[51];
	var tmpobjPatRegMTBZ=$("PatRegMTBZ")
	for(var i=0;i<tmpobjPatRegMTBZ.options.length;i++){
		if(tmpArr[4]==tmpobjPatRegMTBZ.options[i].value){
			tmpobjPatRegMTBZ.selectedIndex=i;
		}
	}
	$("PatInsuId").value=tmpArr[6];	//���˱���
	$("RegDate").value=tmpArr[59];	//��������
	$("PatMTNo").value=tmpArr[9];	//���صǼǺ���
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
		//����.NET����
		 var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_TJ");
		 //var RtnCode=DHCINSUBLL.INSUMTDJFun(tmpRegRowid,PatName,"","","","SYDJ")
		 var RtnCode=DHCINSUBLL.INSUMTDJFun(eval(tmpRegRowid),PatName,"","","","MTDJ")
		 if("0"==RtnCode)
		 {
			 alert("�Ǽǳɹ�!")
			 MTRegHistory();
		 }else{
			 alert("�Ǽ�ʧ��2!")
		 }
	}
	else
	{alert("��ѡ��!")}
}

function MTDownload(){
	//alert("tst"+String.fromCharCode(10)+"123")
	var tmpRegRowid=$("RegRowid").value;
	var PatName=$("PatName").value;//PatName
	if(PatName.length<2){return;}
	var PatMTNo=$("PatMTNo").value;
	if(PatMTNo.length<2){alert("���������صǼǱ��");return;}
	var MTBeginDate=$("MTBeginDate").value;
	if(MTBeginDate.length<2){alert("��ѡ�����ؿ�ʼ����");return;}
	if(eval(tmpRegRowid)>0)
	{
		//����.NET����
		 var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_TJ");
		 //var RtnCode=DHCINSUBLL.INSUMTDJFun(tmpRegRowid,PatName,"","","","SYDJ")
		 var RtnCode=DHCINSUBLL.INSUMTDJFun(eval(tmpRegRowid),PatName,"",PatMTNo,MTBeginDate,"MTDJDownload")
		 if("0"==RtnCode)
		 {
			 alert("���سɹ�")
			 MTRegHistory();
		 }else{
			 alert("����ʧ��2!")
		 }
	}
	else
	{alert("��ѡ��!")}
}
function BtnDestory_Click(){
	//alert("tst"+String.fromCharCode(10)+"123")
	var tmpRegRowid=$("RegRowid").value;
	var PatName=$("PatName").value;//PatName
	if(PatName.length<2){return;}
	var PatMTNo=$("PatMTNo").value;
	if(PatMTNo.length<2){alert("���������صǼǱ��");return;}
	var MTBeginDate=$("MTBeginDate").value;
	if(MTBeginDate.length<2){alert("��ѡ�����ؿ�ʼ����");return;}
	if(eval(tmpRegRowid)>0)
	{
		//����.NET����
		 var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_TJ");
		 //var RtnCode=DHCINSUBLL.INSUMTDJFun(tmpRegRowid,PatName,"","","","SYDJ")
		 var RtnCode=DHCINSUBLL.INSUMTDJFun(eval(tmpRegRowid),PatName,"",PatMTNo,MTBeginDate,"MTDJCancel")
		 if("0"==RtnCode)
		 {
			 alert("�����ɹ�")
			 MTRegHistory();
		 }else{
			 alert("����ʧ��2!")
		 }
	}
	else
	{alert("��ѡ��!")}
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