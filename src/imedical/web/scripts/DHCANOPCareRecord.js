//DHCANOPCareRecord.JS

var EpisodeID=document.getElementById("EpisodeID").value;
function BodyLoadHandler()
{
	var opaId=document.getElementById("opaId").value;
	if (opaId==""){alert(t['alert:selop']);return;}
	var GetPatInfo=document.getElementById("GetPatInfo").value;
    var res=cspRunServerMethod(GetPatInfo,opaId);
    if (res=="") {
		alert(t['alert:nopat']);
    	return;
    }
    else {
	    var patInfo=res.split("^");
		var obj=document.getElementById("patLoc");
		if (obj) obj.value=patInfo[0];
		var obj=document.getElementById("patName");
		if (obj) obj.value=patInfo[1];
		var obj=document.getElementById("patSex");
		if (obj) obj.value=patInfo[2];
		var obj=document.getElementById("patAge");
		if (obj) obj.value=patInfo[3];
		var obj=document.getElementById("patMedCareNo");
		if (obj) obj.value=patInfo[4];
		var obj=document.getElementById("patBloodType");
		if (obj) obj.value=patInfo[5];
		var obj=document.getElementById("patOpRoom");
		if (obj) obj.value=patInfo[6];
		var obj=document.getElementById("patOpDate");
		if (obj) obj.value=patInfo[7];
		var obj=document.getElementById("patOpName");
		if (obj) obj.value=patInfo[8];
		var obj=document.getElementById("TheatreInTime");
		if (obj) obj.value=patInfo[9];
		var obj=document.getElementById("TheatreOutTime");
		if (obj) obj.value=patInfo[10];
	}
	var GetCareRecord=document.getElementById("GetCareRecord").value;
    var res=cspRunServerMethod(GetCareRecord,opaId);
	var CareRecord=res.split("@");
	var SQCareRecord=CareRecord[0];
	var SZCareRecord=CareRecord[1];
	var SHCareRecord=CareRecord[2];
	var tmpSQCareRecord=SQCareRecord.split("^");
	//��־
	var Consciousness=tmpSQCareRecord[1];
	SetEleGroupVal("Consciousness",5,Consciousness,"R","D");
	//��ǰ������Һ
	var SQIntravenInfusion=tmpSQCareRecord[2];
	SetEleGroupVal("SQIntravenInfusion",2,SQIntravenInfusion,"R","V");
	//�������
	var DeepIntravenPunc=tmpSQCareRecord[3];
	SetEleGroupVal("DeepIntravenPunc",2,DeepIntravenPunc,"R","V");
	//�ܵ�
	var Catheter=tmpSQCareRecord[4];
	SetEleGroupVal("Catheter",2,Catheter,"R","V");
	//��ǰƤ�����
	var SQSkin=tmpSQCareRecord[5];
	SetEleGroupVal("SQSkin",2,SQSkin,"R","V");
	//ҩ�����
	var PreAllergy=tmpSQCareRecord[6];
	SetEleGroupVal("PreAllergy",2,PreAllergy,"R","V");
	//��ǰ��ҩ
	var PreAnaDrug=tmpSQCareRecord[7];
	var objPreAnaDrug1=document.getElementById("PreAnaDrug1");
	if (PreAnaDrug=="Y") objPreAnaDrug1.checked=true;
	var objPreAnaDrug2=document.getElementById("PreAnaDrug2");
	if (PreAnaDrug=="N") objPreAnaDrug2.checked=true;
	//����
	var ForbidDrink=tmpSQCareRecord[8];
	var objForbidDrink=document.getElementById("ForbidDrink");
	if (ForbidDrink=="Y") objForbidDrink.checked=true;
	//��ʳ
	var ForbidFood=tmpSQCareRecord[9];
	var objForbidFood=document.getElementById("ForbidFood");
	if (ForbidFood=="Y") objForbidFood.checked=true;
	//������Ʒ
	var VadeMecum=tmpSQCareRecord[10];
	SetEleGroupVal("VadeMecum",6,VadeMecum,"C","D");
	//����ʶ
	var BodySurfIdentity=tmpSQCareRecord[11];
	SetEleGroupVal("BodySurfIdentity",2,BodySurfIdentity,"R","V");
	//�����������ָʾ���
	var CareAsepticPackCheck=tmpSQCareRecord[12];
	SetEleGroupVal("CareAsepticPackCheck",2,CareAsepticPackCheck,"R","D");
	
	var tmpSZCareRecord=SZCareRecord.split("^");
	//��λ
	var OperPosition=tmpSZCareRecord[0];
	SetEleLabVal("OperPosition",6,OperPosition);
	//�絶����
	var CareElectrotome=tmpSZCareRecord[1];
	SetEleGroupVal("CareElectrotome",4,CareElectrotome,"R","D");		
	//������λ��
	var CareNegativePlate=tmpSZCareRecord[2];
	SetEleGroupVal("CareNegativePlate",5,CareNegativePlate,"R","DV");		
	//ֹѪ����������
	var CareHemostaticBelt=tmpSZCareRecord[3];
	var tmpCareHemostaticBelt=CareHemostaticBelt.split(",");
	var objCheck1=document.getElementById("CareHemostaticBelt1");
	var objCheck2=document.getElementById("CareHemostaticBelt2");
	if (tmpCareHemostaticBelt[0]==t['val:no']) objCheck1.checked=true;
	if (tmpCareHemostaticBelt[0]==t['val:yes']) objCheck2.checked=true;
	if (tmpCareHemostaticBelt.length>1){
		if ((tmpCareHemostaticBelt[1]!="")&&(tmpCareHemostaticBelt[0]==t['val:yes'])){
			var Detail=tmpCareHemostaticBelt[1].split("!");
			//��λ
			var objText=document.getElementById("CareHemostaticBelt2Body");
			if (objText) objText.value=Detail[0];
			//ѹ��
			var objText=document.getElementById("CareHemostaticBelt2Press");
			if (objText) objText.value=Detail[1];
			//����ʱ��
			var objText=document.getElementById("CareHemostaticBelt2PuffTime");
			if (objText) objText.value=Detail[2];
			//��ʱ��
			var objText=document.getElementById("CareHemostaticBelt2RelaxTime");
			if (objText) objText.value=Detail[3];
		}
	}
	//��λ֧������
	var CarePositionSupport=tmpSZCareRecord[4];
	SetEleGroupVal("CarePositionSupport",9,CarePositionSupport,"C","D");	
	//����ֲ���ﵥ������
	var CareImplant=tmpSZCareRecord[5];
	var objCheck1=document.getElementById("CareImplant1");	
	var objCheck2=document.getElementById("CareImplant2");	
	var tmpCareImplant=CareImplant.split(",");
	if (tmpCareImplant[0]==t['val:no']) objCheck1.checked=true;
	if (tmpCareImplant[0]==t['val:yes']) objCheck2.checked=true;
	if (tmpCareImplant.length>1){
		if ((tmpCareImplant[1]!="")&&(tmpCareImplant[0]==t['val:yes'])){
 			var Detail=tmpCareImplant[1].split("!");
			//����
			var objText=document.getElementById("CareImplant2Name");
			if (objText) objText.value=Detail[0];
			//���
			var objText=document.getElementById("CareImplant2Spec");
			if (objText) objText.value=Detail[1];
			//��λ
			var objText=document.getElementById("CareImplant2Body");
			if (objText) objText.value=Detail[2];
			//����
			var objText=document.getElementById("CareImplant2Num");
			if (objText) objText.value=Detail[3];
		}
	}
	//�걾
	var CareSpecimen=tmpSZCareRecord[6];
	SetEleGroupVal("CareSpecimen",2,CareSpecimen,"R","V");	
	//�ͱ�����Ƭ
	var CareFreezingSlice=tmpSZCareRecord[7];
	var obj=document.getElementById("CareFreezingSlice");
	if (CareFreezingSlice=="Y") obj.checked=true;
	//�Ͳ���걾
	var CarePathologSection=tmpSZCareRecord[8];
	var obj=document.getElementById("CarePathologSection");
	if (CarePathologSection=="Y") obj.checked=true;
	//���о�����Һ
	var SZIntravenInfusion=tmpSZCareRecord[9];
	SetEleGroupVal("SZIntravenInfusion",2,SZIntravenInfusion,"R","V");
	//����
	var CareUrineCatheter=tmpSZCareRecord[10];
	SetEleGroupVal("CareUrineCatheter",2,CareUrineCatheter,"R","V");
	//���о�����Ѫ
	var BloodTranfused=tmpSZCareRecord[11]
	SetEleGroupVal("BloodTranfused",2,BloodTranfused,"R","V");
	//��������(��"//������",����ֻ��֮һ)
	var CareDrainageCatheter=tmpSZCareRecord[12]
	SetEleGroupVal("CareDrainageCatheter",2,CareDrainageCatheter,"R","V");

	var tmpSHCareRecord=SHCareRecord.split("^");
	//��������
	var ANSType=tmpSHCareRecord[1];
	//�Ų���
	var objANSType1=document.getElementById("ANSType1");
	if (ANSType=="W")  objANSType1.checked=true;
	//��ICU
	var objANSType2=document.getElementById("ANSType2");
	if (ANSType=="I")  objANSType2.checked=true;
	//��PACU
	var objANSType3=document.getElementById("ANSType3");
	if (ANSType=="PI")  objANSType3.checked=true;
	//��������Һ
	var SHIntravenInfusion=tmpSHCareRecord[2];
	SetEleGroupVal("SHIntravenInfusion",2,SHIntravenInfusion,"R","V");
	//����Ƥ�����
	var SHSkin=tmpSHCareRecord[3];
	SetEleGroupVal("SHSkin",2,SHSkin,"R","V");
	//������
	var CareDrainCath=tmpSHCareRecord[4];
	SetEleGroupVal("CareDrainCath",9,CareDrainCath,"C","D");
	//��ע
	var ANSNote=tmpSHCareRecord[5];
	var obj=document.getElementById("ANSNote");
	if (obj) obj.value=ANSNote;
	//������
	var tmpShiftCtcp=tmpSHCareRecord[6];
	var ShiftCtcpId=document.getElementById("ShiftCtcpId");
	if(ShiftCtcpId) ShiftCtcpId.value=tmpShiftCtcp.split(",")[0];
	var ShiftCtcp=document.getElementById("ShiftCtcp");	
	if (ShiftCtcp) ShiftCtcp.value=tmpShiftCtcp.split(",")[1];
	//�Ӱ���
	var tmpReliefCtcp=tmpSHCareRecord[7];
	var ReliefCtcpId=document.getElementById("ReliefCtcpId");
	if (ReliefCtcpId) ReliefCtcpId.value=tmpReliefCtcp.split(",")[0];
	var ReliefCtcp=document.getElementById("ReliefCtcp");	
	if (ReliefCtcp) ReliefCtcp.value=tmpReliefCtcp.split(",")[1];
	var obj=document.getElementById("btnSave");
	if (obj) obj.onclick=btnSaveClick;
	var obj=document.getElementById("btnPrint");
	if (obj) obj.onclick=btnPrintClick;
	var obj=document.getElementById("Consciousness1");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("Consciousness2");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("Consciousness3");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("Consciousness4");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("Consciousness5");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("SQIntravenInfusion1");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("SQIntravenInfusion2");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("DeepIntravenPunc1");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("DeepIntravenPunc2");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("Catheter1");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("Catheter2");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("SQSkin1");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("SQSkin2");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("SHSkin1");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("SHSkin2");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("PreAllergy1");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("PreAllergy2");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("PreAnaDrug1");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("PreAnaDrug2");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("BodySurfIdentity1");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("BodySurfIdentity2");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("CareAsepticPackCheck1");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("CareAsepticPackCheck2");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("OperPosition1");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("OperPosition2");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("OperPosition3");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("OperPosition4");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("OperPosition5");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("CareElectrotome1");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("CareElectrotome2");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("CareElectrotome3");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("CareElectrotome4");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("CareNegativePlate1");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("CareNegativePlate2");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("CareNegativePlate3");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("CareNegativePlate4");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("CareHemostaticBelt1");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("CareHemostaticBelt2");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("CareImplant1");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("CareImplant2");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("CareSpecimen1");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("CareSpecimen2");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("ANSType1");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("ANSType2");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("ANSType3");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("SHIntravenInfusion1");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("SHIntravenInfusion2");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("CareUrineCatheter1");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("CareUrineCatheter2");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("SZIntravenInfusion1");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("SZIntravenInfusion2");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("BloodTranfused1");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("BloodTranfused2");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("CareDrainageCatheter1");
	if (obj) obj.onclick=RadioCheck;
	var obj=document.getElementById("CareDrainageCatheter2");
	if (obj) obj.onclick=RadioCheck;
}

//��ѡ�����¼�����
function RadioCheck()
{
	var eSrc=window.event.srcElement;
	var eleName=eSrc.name;
	eleName=eleName.replace(/[^a-z]/ig,""); //ֻȡ�ַ����е�Ӣ����ĸ
	//�趨�����7����Ҫѡ��
	for(var i=1;i<7;i++)
	{
		var Obj=document.getElementById(eleName+i);
		if ((!Obj)||(Obj.type!="checkbox")) continue;
		if((eSrc==Obj)&&(Obj.checked==true)) Obj.checked=true;
		else Obj.checked=false;
	}

}
//��ѯĳһ��Ԫ��ֵ�Ĺ��ú���
//eleStr:����Ԫ������,eleNum:����Ԫ����Ŀ,eleType:��("R")/��ѡ("C"),saveValType:����ֵ������("V","D","DV")
//��ѡ������ѡֵ��λ��"1"
//��ѡ������ѡλ�õĴ�"1#2#3#�Զ����ı�"
function GetEleGroupVal(eleStr,eleNum,eleType,saveValType)
{
	var retStr="";
	for(var i=1;i<eleNum+1;i++)
	{
		var Obj=document.getElementById(eleStr+i);
		if (!Obj) {retStr[i-1]="";continue;}
		if (Obj.type=="checkbox"){
			if(Obj.checked==true) {
				if (eleType=="R") {
					if (saveValType=="V") {
						var ObjLabel=document.getElementById("c"+eleStr+i);
						if (ObjLabel) retStr=ObjLabel.innerText;
						var objText=document.getElementById(eleStr+i+"Text");
						if (objText) retStr=retStr+","+objText.value;
						break;
					}
					if ((saveValType=="D")||(saveValType=="DV")) {
						retStr=i;
						break;
					}
				}
				else {
					if (retStr=="") retStr=i+"#";
					else retStr=retStr+i+"#";
				}
			}
		}
		if (Obj.type=="text") {
			if (eleType=="R") {
				if (saveValType=="DV") {
					retStr=Obj.value;
					break;
				}
			}
			else retStr=retStr+Obj.value;		
		}
	}
	return retStr;
}

//����ĳһ��Ԫ��ֵ�Ĺ��ú���
//eleStr:����Ԫ������,eleNum:����Ԫ����Ŀ
//eleVal:��ѡʱΪ��ѡֵ��������λ��,��"1"
//		 ��ѡ������ѡλ�õĴ�"1#2#3#�Զ����ı�"	
//eleType:��("R")/��ѡ("C")
//saveValType:����ֵ������("V","D","DV")
function SetEleGroupVal(eleStr,eleNum,eleVal,eleType,saveValType)
{	
	if ((!eleVal)||(eleVal=="")) return;
	//alert(eleStr+"^"+eleNum+"^"+eleVal+"^"+eleType+"^"+saveValType)
	var eleValLab="",eleValText="",eleValNum="",eleValList="";
	if (eleType=="R") {
		if (saveValType=="V") {
			eleValList=eleVal.split(",");
			eleValLab=eleValList[0];
			if (eleValLab!="") { 
				for(var i=1;i<eleNum+1;i++) {	
					var Obj=document.getElementById(eleStr+i);
					if (!Obj) continue;
					var ObjLab=document.getElementById("c"+eleStr+i);
					if ((Obj.type=="checkbox")&&(ObjLab.innerText==eleValLab)){
						Obj.checked=true;
						if (eleValList.length>1){
							var objText=document.getElementById(eleStr+i+"Text");
							if (objText) objText.value=eleValList[1];
						}
					}
				}
			}
		}
		if (saveValType=="D") {
			var Obj=document.getElementById(eleStr+eleVal);
			if (Obj) Obj.checked=true;
		}
		if (saveValType=="DV") {
			if (BASEisNotNum(eleVal)) {
				for(var i=eleNum;i>0;i--) {	
					var Obj=document.getElementById(eleStr+i);
					if (!Obj) continue;
					if (Obj.type=="text") {
						Obj.value=eleVal;	
						break;
					}			
				}
			}
			else {
				var Obj=document.getElementById(eleStr+eleVal);
				if (Obj) Obj.checked=true;
			}
		}
	}
	else {
		var eleValList=eleVal.split("#");	
		var eleValText=eleValList[eleValList.length-1];
		if (eleValText!="") {
			for(var k=eleNum;k>0;k--) {	
				var Obj=document.getElementById(eleStr+k);
				if ((Obj)&&(Obj.type=="text")) {
					Obj.value=eleValText;	
					break;
				}			
			}	
		}
		for(var i=0;i<eleValList.length;i++)
		{
			if (!BASEisNotNum(eleValList[i])) {
				var Obj=document.getElementById(eleStr+eleValList[i]);
				if (Obj) Obj.checked=true;
			}
		}
	}
		
}
//�ж��Ƿ�Ϊ����
function BASEisNotNum(theNum)
{
	if ((theNum=="")||(theNum==" ")) return true;
	for(var j=0;j<theNum.length;j++){
		oneNum=theNum.substring(j,j+1);
		if (oneNum<"0" || oneNum>"9")
		return true;
	}
	return false;
}
//ȡĳһ��Ԫ�ر�ǩֵ�Ĺ��ú���,��ѡ
//eleStr:����Ԫ������,eleNum:����Ԫ����Ŀ
function GetEleLabVal(eleStr,eleNum)
{
	var retStr="";
	for(var i=1;i<eleNum+1;i++)
	{
		var Obj=document.getElementById(eleStr+i);
		if (!Obj) continue;
		if (Obj.type=="checkbox"){
			if(Obj.checked==true) {
				var ObjLabel=document.getElementById("c"+eleStr+i);
				if (ObjLabel) {retStr=ObjLabel.innerText;break;}
			}
		}
		if (Obj.type=="text") retStr=Obj.value;	
	}
	return retStr;
}
//����ĳһ��Ԫ�ر�ǩֵ�Ĺ��ú���,��ѡ
//eleStr:����Ԫ������,eleNum:����Ԫ����Ŀ,eleVal:ѡ��Ԫ�صı�ǩֵ
function SetEleLabVal(eleStr,eleNum,eleVal)
{
	for(var i=1;i<eleNum+1;i++)
	{
		var Obj=document.getElementById(eleStr+i);
		if (!Obj) continue;
		if (Obj.type=="checkbox"){
			var ObjLabel=document.getElementById("c"+eleStr+i);
			if ((ObjLabel)&&(ObjLabel.innerText==eleVal)) {Obj.checked=true;break;}
		}
		if (Obj.type=="text") Obj.value=eleVal;	
	}
}
//ȡĳһ��Ԫ�ر�ǩֵ+��ѡ��Ĺ��ú���,��ѡ,��ѡ
//eleStr:����Ԫ������,eleNum:����Ԫ����Ŀ,eleType:��ѡ(R)/��ѡ(C)
function GetEleLabStr(eleStr,eleNum,eleType)
{
	var retStr="";
	for(var i=1;i<eleNum+1;i++)
	{
		var Obj=document.getElementById(eleStr+i);
		if (!Obj) continue;
		if (Obj.type=="checkbox"){
			if(Obj.checked==true) {
				if (eleType=="R"){
					var ObjLabel=document.getElementById("c"+eleStr+i);
					if (ObjLabel) {retStr=retStr+" "+ObjLabel.innerText+String.fromCharCode(9632);}
					var objText=document.getElementById(eleStr+i+"Text");
					if ((objText)&&(objText.value!="")&&(objText.value!=" ")) retStr=retStr+" "+objText.value;
				}
				else{
					var ObjLabel=document.getElementById("c"+eleStr+i);
					if (ObjLabel) {retStr=retStr+" "+ObjLabel.innerText;}
				}
			}
			else{
				if (eleType=="R"){
					var ObjLabel=document.getElementById("c"+eleStr+i);
					if (ObjLabel) {retStr=retStr+" "+ObjLabel.innerText+String.fromCharCode(9633);}
				}
			}
		}
		if (Obj.type=="text") retStr=retStr+" "+Obj.value;	
	}
	return retStr;
}

function btnSaveClick()
{
	var TheatreInTime="",TheatreOutTime="",Consciousness="",SQIntravenInfusion="",DeepIntravenPunc="",Catheter="",SQSkin="",SHSkin="",PreAllergy="",PreAnaDrug="",VadeMecum="",BodySurfIdentity="",OperPosition="",CareElectrotome="",CareNegativePlate="",CareHemostaticBelt="",CarePositionSupport="",CareImplant="",CareSpecimen="",CareDrainCath="",SHIntravenInfusion="",CareAsepticPackCheck="",CareUrineCatheter="",SZIntravenInfusion="",BloodTranfused="",CareDrainageCatheter="";
	//��������
	var obj=document.getElementById("TheatreInTime");
	if (obj) TheatreInTime=obj.value;
	//��������
	var obj=document.getElementById("TheatreOutTime");
	if (obj) TheatreOutTime=obj.value;
	//��־
	Consciousness=GetEleGroupVal("Consciousness",5,"R","D");
	//��ǰ������Һ
	SQIntravenInfusion=GetEleGroupVal("SQIntravenInfusion",2,"R","V");
	//�������
	DeepIntravenPunc=GetEleGroupVal("DeepIntravenPunc",2,"R","V");
	//�ܵ�
	Catheter=GetEleGroupVal("Catheter",2,"R","V");
	//��ǰƤ�����
	SQSkin=GetEleGroupVal("SQSkin",2,"R","V");
	//����Ƥ�����
	SHSkin=GetEleGroupVal("SHSkin",2,"R","V");
	//ҩ�����
	PreAllergy=GetEleGroupVal("PreAllergy",2,"R","V");
	//��ǰ��ҩ
	var obj=document.getElementById("PreAnaDrug1");
	if ((obj)&&(obj.checked==true)) var PreAnaDrug="Y";
	var obj=document.getElementById("PreAnaDrug2");
	if ((obj)&&(obj.checked==true)) var PreAnaDrug="N";
	//����
	var obj=document.getElementById("ForbidDrink");
	if ((obj)&&(obj.checked==true)) var ForbidDrink="Y";
	else ForbidDrink="N";
	//��ʳ
	var obj=document.getElementById("ForbidFood");
	if ((obj)&&(obj.checked==true)) var ForbidFood="Y";
	else ForbidFood="N";
	//������Ʒ
	VadeMecum=GetEleGroupVal("VadeMecum",6,"C","D");
	//����ʶ
	BodySurfIdentity=GetEleGroupVal("BodySurfIdentity",2,"R","V");
	//�����������ָʾ���
	CareAsepticPackCheck=GetEleGroupVal("CareAsepticPackCheck",2,"R","D");
	//��λ
	OperPosition=GetEleLabVal("OperPosition",6);
	//�絶����
	CareElectrotome=GetEleGroupVal("CareElectrotome",4,"R","D");		
	//������λ��
	CareNegativePlate=GetEleGroupVal("CareNegativePlate",5,"R","DV");
	//ֹѪ����������
	var objCheck1=document.getElementById("CareHemostaticBelt1");	
	if ((objCheck1)&&(objCheck1.checked==true)) CareHemostaticBelt=t['val:no']+",";
	var objCheck2=document.getElementById("CareHemostaticBelt2");	
	if ((objCheck2)&&(objCheck2.checked==true)){
		var Detail=""
		//��λ
		var objText=document.getElementById("CareHemostaticBelt2Body");
		if (objText) Detail=objText.value;
		Detail=Detail+"!";
		//ѹ��
		var objText=document.getElementById("CareHemostaticBelt2Press");
		if (objText) Detail=Detail+objText.value;
		Detail=Detail+"!";
		//����ʱ��
		var objText=document.getElementById("CareHemostaticBelt2PuffTime");
		if (objText) Detail=Detail+objText.value;
		Detail=Detail+"!";
		//��ʱ��
		var objText=document.getElementById("CareHemostaticBelt2RelaxTime");
		if (objText) Detail=Detail+objText.value;
		CareHemostaticBelt=t['val:yes']+","+Detail;
	}
	//��λ֧������
	CarePositionSupport=GetEleGroupVal("CarePositionSupport",9,"C","D");
	//����ֲ���ﵥ������
	var objCheck1=document.getElementById("CareImplant1");	
	if ((objCheck1)&&(objCheck1.checked==true)) CareImplant=t['val:no']+",";
	var objCheck2=document.getElementById("CareImplant2");	
	if ((objCheck2)&&(objCheck2.checked==true)){
		var Detail=""
		//����
		var objText=document.getElementById("CareImplant2Name");
		if (objText) Detail=objText.value;
		Detail=Detail+"!";
		//���
		var objText=document.getElementById("CareImplant2Spec");
		if (objText) Detail=Detail+objText.value;
		Detail=Detail+"!";
		//��λ
		var objText=document.getElementById("CareImplant2Body");
		if (objText) Detail=Detail+objText.value;
		Detail=Detail+"!";
		//����
		var objText=document.getElementById("CareImplant2Num");
		if (objText) Detail=Detail+objText.value;
		CareImplant=t['val:yes']+","+Detail;
	}
	//�걾
	CareSpecimen=GetEleGroupVal("CareSpecimen",2,"R","V");	
	//�ͱ�����Ƭ
	var obj=document.getElementById("CareFreezingSlice");
	if ((obj)&&(obj.checked==true)) CareFreezingSlice="Y";
	else CareFreezingSlice="N";
	//�Ͳ���걾
	var obj=document.getElementById("CarePathologSection");
	if ((obj)&&(obj.checked==true)) CarePathologSection="Y";
	else CarePathologSection="N";
	
	//��������
	var ANSType="";
	//�Ų���
	var obj=document.getElementById("ANSType1");
	if ((obj)&&(obj.checked==true))  ANSType="W";
	//��ICU
	var obj=document.getElementById("ANSType2");
	if ((obj)&&(obj.checked==true))  ANSType="I";
	//��PACU
	var obj=document.getElementById("ANSType3");
	if ((obj)&&(obj.checked==true))  ANSType="PI";
	//������
	//CareDrainCath=GetEleGroupVal("CareDrainCath",9,"C","D");
	//��������Һ
	SHIntravenInfusion=GetEleGroupVal("SHIntravenInfusion",2,"R","V");
	//��ע
	var ANSNote="";
	var obj=document.getElementById("ANSNote");
	if (obj) ANSNote=obj.value;
	//������
	var ShiftCtcpId=document.getElementById("ShiftCtcpId").value;
	var obj=document.getElementById("ShiftCtcp");	
	if ((obj)&&(obj.value=="")) ShiftCtcpId="";
	//�Ӱ���
	var ReliefCtcpId=document.getElementById("ReliefCtcpId").value;
	var obj=document.getElementById("ReliefCtcp");	
	if ((obj)&&(obj.value=="")) ReliefCtcpId="";
	//���о�����Һ
	SZIntravenInfusion=GetEleGroupVal("SZIntravenInfusion",2,"R","V");
	//���е���
	CareUrineCatheter=GetEleGroupVal("CareUrineCatheter",2,"R","V");
	//���о�����Ѫ
	BloodTranfused=GetEleGroupVal("BloodTranfused",2,"R","V");
	//��������(��"//������",����ֻ��֮һ)
	CareDrainageCatheter=GetEleGroupVal("CareDrainageCatheter",2,"R","V");
	
	var SQCareRecord=TheatreInTime+"^"+Consciousness+"^"+SQIntravenInfusion+"^"+DeepIntravenPunc+"^"+Catheter+"^"+SQSkin+"^"+PreAllergy+"^"+PreAnaDrug+"^"+ForbidDrink+"^"+ForbidFood+"^"+VadeMecum+"^"+BodySurfIdentity+"^"+CareAsepticPackCheck;
	var SZCareRecord=OperPosition+"^"+CareElectrotome+"^"+CareNegativePlate+"^"+CareHemostaticBelt+"^"+CarePositionSupport+"^"+CareImplant+"^"+CareSpecimen+"^"+CareFreezingSlice+"^"+CarePathologSection+"^"+SZIntravenInfusion+"^"+CareUrineCatheter+"^"+BloodTranfused+"^"+CareDrainageCatheter;
	var SHCareRecord=TheatreOutTime+"^"+ANSType+"^"+SHIntravenInfusion+"^"+SHSkin+"^"+CareDrainCath+"^"+ANSNote+"^"+ShiftCtcpId+"^"+ReliefCtcpId;
	//alert("SQCareRecord= "+SQCareRecord+"\n"+"SZCareRecord= "+SZCareRecord+"\n"+"SHCareRecord= "+SHCareRecord);
	var SaveCareRecord=document.getElementById("SaveCareRecord").value;
	var opaId=document.getElementById("opaId").value;
	if (opaId==""){alert(t['alert:selop']);return;}
    var res=cspRunServerMethod(SaveCareRecord,opaId,SQCareRecord,SZCareRecord,SHCareRecord);
	if (res==0) {alert(t['alert:success']);window.location.reload();}
	else alert(res);
	return;
}
//ȡ�Ӱ���ID
function GetReliefCtcp(str)
{
	var val=str.split("^");
	var obj=document.getElementById("ReliefCtcpId");
	obj.value=val[0];
	var obj=document.getElementById("ReliefCtcp");
	obj.value=val[1];
}
//ȡ������ID
function GetShiftCtcp(str)
{
	var val=str.split("^");
	var obj=document.getElementById("ShiftCtcpId");
	obj.value=val[0];
	var obj=document.getElementById("ShiftCtcp");
	obj.value=val[1];
}
//ȡģ��·��
function GetFilePath()
{   var GetPath=document.getElementById("GetPath").value;
    var path=cspRunServerMethod(GetPath);
    return path
}
//��ӡ�����¼��
function btnPrintClick()
{
    var xlsExcel,xlsSheet,xlsBook;
    var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
    var LeftFooter,CenterFooter,RightFooter;
    var path,fileName;
    path = GetFilePath();
    fileName=path + "DHCANOPCareRecord.xls";
    //fileName="C:\\DHCANOPCareRecord.xls";
    xlsExcel = new ActiveXObject("Excel.Application");
    xlsBook = xlsExcel.Workbooks.Add(fileName);
    xlsSheet = xlsBook.ActiveSheet;
    xlsTop=1;xlsLeft=1;
    
    var patLoc="",patName="",patSex="",patAge="",patMedCareNo="",patBloodType="",patOpRoom="",patOpDate="",patOpName="",TheatreInTime="",TheatreOutTime="";
    var opaId=document.getElementById("opaId").value;
	if (opaId==""){alert(t['alert:selop']);return;}
 	var PatInfo=document.getElementById("GetPatInfo");
	if (PatInfo){
    	var PatInfoStr=cspRunServerMethod(PatInfo.value,opaId);
		var patInfo=PatInfoStr.split("^");
		patLoc=patInfo[0];
		patName=patInfo[1];
		patSex=patInfo[2];
		patAge=patInfo[3];
		patMedCareNo=patInfo[4];
		patBloodType=patInfo[5];
		patOpRoom=patInfo[6];
		patOpDate=patInfo[7];
		patOpName=patInfo[8];
		TheatreInTime=patInfo[9];
		TheatreOutTime=patInfo[10];	
	}
	//������Ϣ
	var row=3;
	xlsSheet.cells(row,2)=patLoc;
	xlsSheet.cells(row,4)=patName;
    if (patSex==t['val:male']) xlsSheet.cells(row,6)=patSex+" "+String.fromCharCode(9632);
    if (patSex==t['val:female']) xlsSheet.cells(row,7)=patSex+" "+String.fromCharCode(9632);
    xlsSheet.cells(row,9)=patAge;
    xlsSheet.cells(row,11)=patMedCareNo;
    xlsSheet.cells(row,13)=patBloodType;
    row=row+1;
    xlsSheet.cells(row,2)=patOpRoom;
    xlsSheet.cells(row,4)=patOpDate;
    xlsSheet.cells(row,6)=patOpName;
   	//��ǰ
   	row=6;
   	//����ʱ��
    xlsSheet.cells(row,3)=TheatreInTime;
    //��־
    var Consciousness=GetEleLabVal("Consciousness",5);
    xlsSheet.cells(row,5)=Consciousness; 
	//��ǰ������Һ
	var SQIntravenInfusion=GetEleLabStr("SQIntravenInfusion",2,"R");
	xlsSheet.cells(row,8)=SQIntravenInfusion;
	//�������
	var DeepIntravenPunc=GetEleLabStr("DeepIntravenPunc",2,"R");
	xlsSheet.cells(row,12)=DeepIntravenPunc;
	row=row+1;
	//�ܵ�
	var Catheter=GetEleLabStr("Catheter",2,"R");
	xlsSheet.cells(row,3)=Catheter;
	//��ǰƤ�����
	var SQSkin=GetEleLabStr("SQSkin",2,"R");
	xlsSheet.cells(row,8)=SQSkin;
	row=row+1;
	//ҩ�����
	var PreAllergy=GetEleLabStr("PreAllergy",2,"R");
	xlsSheet.cells(row,3)=PreAllergy;
	//��ǰ��ҩ
	var PreAnaDrug=GetEleLabStr("PreAnaDrug",2,"R");
	xlsSheet.cells(row,8)=PreAnaDrug;
	//����
	var obj=document.getElementById("ForbidDrink");
	if ((obj)&&(obj.checked==true)) {
		var ObjLabel=document.getElementById("cForbidDrink");
		if (ObjLabel) xlsSheet.cells(row,11)=ObjLabel.innerText+String.fromCharCode(9632);
	}
	//��ʳ
	var obj=document.getElementById("ForbidFood");
	if ((obj)&&(obj.checked==true)){
		var ObjLabel=document.getElementById("cForbidFood");
		if (ObjLabel) xlsSheet.cells(row,12)=ObjLabel.innerText+String.fromCharCode(9632);
	}
	row=row+1;
	//������Ʒ
	var VadeMecum=GetEleLabStr("VadeMecum",6,"C");
	xlsSheet.cells(row,3)=VadeMecum;
	//����ʶ
	var BodySurfIdentity=GetEleLabStr("BodySurfIdentity",2,"R");
	xlsSheet.cells(row,8)=BodySurfIdentity;
	row=row+1;
	//�����������ָʾ���
	var CareAsepticPackCheck=GetEleLabStr("CareAsepticPackCheck",2,"R");
	xlsSheet.cells(row,5)=CareAsepticPackCheck;
	//����
	row=row+1;
	//��λ
	var OperPosition=GetEleLabVal("OperPosition",6);
	xlsSheet.cells(row,3)=OperPosition;
	row=row+1;
	//�絶����
	var CareElectrotome=GetEleLabVal("CareElectrotome",4);
	xlsSheet.cells(row,3)=CareElectrotome;		
	//������λ��
	var CareNegativePlate=GetEleLabVal("CareNegativePlate",5);	
	xlsSheet.cells(row,8)=CareNegativePlate;
	row=row+1;		
	//ֹѪ����������
	var CareHemostaticBelt=GetEleLabStr("CareHemostaticBelt",2,"R");
	var Detail=""
	var objCheck2=document.getElementById("CareHemostaticBelt2");
	if ((objCheck2)&&(objCheck2.checked==true)){
		
		//��λ
		var objText=document.getElementById("CareHemostaticBelt2Body");
		if (objText) Detail=t['val:Body']+objText.value;
		//ѹ��
		var objText=document.getElementById("CareHemostaticBelt2Press");
		if (objText) Detail=Detail+" "+t['val:Press']+objText.value;
		//����ʱ��
		var objText=document.getElementById("CareHemostaticBelt2PuffTime");
		if (objText) Detail=Detail+" "+t['val:PuffTime']+objText.value;
		//��ʱ��
		var objText=document.getElementById("CareHemostaticBelt2RelaxTime");
		if (objText) Detail=Detail+" "+t['val:RelaxTime']+objText.value;
	}
	xlsSheet.cells(row,3)=CareHemostaticBelt+" "+Detail;
	row=row+1;
	//��λ֧������
	var CarePositionSupport=GetEleLabStr("CarePositionSupport",9,"C");	
	xlsSheet.cells(row,3)=CarePositionSupport;
	row=row+1;
	//����ֲ���ﵥ������
	var CareImplant=GetEleLabStr("CareImplant",2,"R");	
	var Detail="";
	var objCheck2=document.getElementById("CareImplant2");	
	if ((objCheck2)&&(objCheck2.checked==true)){
		//����
		var objText=document.getElementById("CareImplant2Name");
		if (objText) Detail=t['val:Name']+objText.value;
		//���
		var objText=document.getElementById("CareImplant2Spec");
		if (objText) Detail=Detail+" "+t['val:Spec']+objText.value;
		//��λ
		var objText=document.getElementById("CareImplant2Body");
		if (objText) Detail=Detail+" "+t['val:Body']+objText.value;
		//����
		var objText=document.getElementById("CareImplant2Num");
		if (objText) Detail=Detail+" "+t['val:Num']+objText.value;
	}
	xlsSheet.cells(row,3)=CareImplant+" "+Detail;
	row=row+1;
	//�걾
	var CareSpecimen=GetEleLabStr("CareSpecimen",2,"R");	
	xlsSheet.cells(row,3)=CareSpecimen;
	//�ͱ�����Ƭ
	var obj=document.getElementById("CareFreezingSlice");
	if ((obj)&&(obj.checked==true)) xlsSheet.cells(row,8)=t['val:FreezingSlice'];
	//�Ͳ���걾
	var obj=document.getElementById("CarePathologSection");
	if ((obj)&&(obj.checked==true))  xlsSheet.cells(row,8)=t['val:PathologSection'];
	//����
	row=row+1;
	//����ʱ��
    xlsSheet.cells(row,3)=TheatreOutTime;
	//��������
	var ANSType="";
	//�Ų���
	var ANSType=GetEleLabVal("ANSType",2);
	xlsSheet.cells(row,5)=ANSType;
	row=row+1;
	//��������Һ
	var SHIntravenInfusion=GetEleLabStr("SHIntravenInfusion",2,"R");
	xlsSheet.cells(row,3)=SHIntravenInfusion;
	//����Ƥ�����
	var SHSkin=GetEleLabStr("SHSkin",2,"R");
	xlsSheet.cells(row,8)=SHSkin;
	row=row+1;
	//������
	var CareDrainCath=GetEleLabStr("CareDrainCath",9,"C");
	xlsSheet.cells(row,3)=CareDrainCath;
	row=row+1;
	//��ע
	var ANSNote="";
	var obj=document.getElementById("ANSNote");
	if (obj) ANSNote=obj.value;
	xlsSheet.cells(row,2)=ANSNote;
	row=row+1;
	//������
	var obj=document.getElementById("ShiftCtcp");	
	if (obj) xlsSheet.cells(row,8)=obj.value;
	//�Ӱ���
	var obj=document.getElementById("ReliefCtcp");	
	if (obj) xlsSheet.cells(row,12)=obj.value;
    xlsSheet.PrintOut
    xlsSheet = null;
    xlsBook.Close(savechanges=false)
    xlsBook = null;
    xlsExcel.Quit();
    xlsExcel = null;
}

document.body.onload = BodyLoadHandler;