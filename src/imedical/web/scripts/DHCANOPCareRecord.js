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
	//神志
	var Consciousness=tmpSQCareRecord[1];
	SetEleGroupVal("Consciousness",5,Consciousness,"R","D");
	//术前静脉输液
	var SQIntravenInfusion=tmpSQCareRecord[2];
	SetEleGroupVal("SQIntravenInfusion",2,SQIntravenInfusion,"R","V");
	//深静脉穿刺
	var DeepIntravenPunc=tmpSQCareRecord[3];
	SetEleGroupVal("DeepIntravenPunc",2,DeepIntravenPunc,"R","V");
	//管道
	var Catheter=tmpSQCareRecord[4];
	SetEleGroupVal("Catheter",2,Catheter,"R","V");
	//术前皮肤情况
	var SQSkin=tmpSQCareRecord[5];
	SetEleGroupVal("SQSkin",2,SQSkin,"R","V");
	//药物过敏
	var PreAllergy=tmpSQCareRecord[6];
	SetEleGroupVal("PreAllergy",2,PreAllergy,"R","V");
	//术前用药
	var PreAnaDrug=tmpSQCareRecord[7];
	var objPreAnaDrug1=document.getElementById("PreAnaDrug1");
	if (PreAnaDrug=="Y") objPreAnaDrug1.checked=true;
	var objPreAnaDrug2=document.getElementById("PreAnaDrug2");
	if (PreAnaDrug=="N") objPreAnaDrug2.checked=true;
	//禁饮
	var ForbidDrink=tmpSQCareRecord[8];
	var objForbidDrink=document.getElementById("ForbidDrink");
	if (ForbidDrink=="Y") objForbidDrink.checked=true;
	//禁食
	var ForbidFood=tmpSQCareRecord[9];
	var objForbidFood=document.getElementById("ForbidFood");
	if (ForbidFood=="Y") objForbidFood.checked=true;
	//随身物品
	var VadeMecum=tmpSQCareRecord[10];
	SetEleGroupVal("VadeMecum",6,VadeMecum,"C","D");
	//体表标识
	var BodySurfIdentity=tmpSQCareRecord[11];
	SetEleGroupVal("BodySurfIdentity",2,BodySurfIdentity,"R","V");
	//手术灭菌用物指示标记
	var CareAsepticPackCheck=tmpSQCareRecord[12];
	SetEleGroupVal("CareAsepticPackCheck",2,CareAsepticPackCheck,"R","D");
	
	var tmpSZCareRecord=SZCareRecord.split("^");
	//体位
	var OperPosition=tmpSZCareRecord[0];
	SetEleLabVal("OperPosition",6,OperPosition);
	//电刀类型
	var CareElectrotome=tmpSZCareRecord[1];
	SetEleGroupVal("CareElectrotome",4,CareElectrotome,"R","D");		
	//负极板位置
	var CareNegativePlate=tmpSZCareRecord[2];
	SetEleGroupVal("CareNegativePlate",5,CareNegativePlate,"R","DV");		
	//止血带单独处理
	var CareHemostaticBelt=tmpSZCareRecord[3];
	var tmpCareHemostaticBelt=CareHemostaticBelt.split(",");
	var objCheck1=document.getElementById("CareHemostaticBelt1");
	var objCheck2=document.getElementById("CareHemostaticBelt2");
	if (tmpCareHemostaticBelt[0]==t['val:no']) objCheck1.checked=true;
	if (tmpCareHemostaticBelt[0]==t['val:yes']) objCheck2.checked=true;
	if (tmpCareHemostaticBelt.length>1){
		if ((tmpCareHemostaticBelt[1]!="")&&(tmpCareHemostaticBelt[0]==t['val:yes'])){
			var Detail=tmpCareHemostaticBelt[1].split("!");
			//部位
			var objText=document.getElementById("CareHemostaticBelt2Body");
			if (objText) objText.value=Detail[0];
			//压力
			var objText=document.getElementById("CareHemostaticBelt2Press");
			if (objText) objText.value=Detail[1];
			//充气时间
			var objText=document.getElementById("CareHemostaticBelt2PuffTime");
			if (objText) objText.value=Detail[2];
			//松时间
			var objText=document.getElementById("CareHemostaticBelt2RelaxTime");
			if (objText) objText.value=Detail[3];
		}
	}
	//体位支撑用物
	var CarePositionSupport=tmpSZCareRecord[4];
	SetEleGroupVal("CarePositionSupport",9,CarePositionSupport,"C","D");	
	//体内植入物单独处理
	var CareImplant=tmpSZCareRecord[5];
	var objCheck1=document.getElementById("CareImplant1");	
	var objCheck2=document.getElementById("CareImplant2");	
	var tmpCareImplant=CareImplant.split(",");
	if (tmpCareImplant[0]==t['val:no']) objCheck1.checked=true;
	if (tmpCareImplant[0]==t['val:yes']) objCheck2.checked=true;
	if (tmpCareImplant.length>1){
		if ((tmpCareImplant[1]!="")&&(tmpCareImplant[0]==t['val:yes'])){
 			var Detail=tmpCareImplant[1].split("!");
			//名称
			var objText=document.getElementById("CareImplant2Name");
			if (objText) objText.value=Detail[0];
			//规格
			var objText=document.getElementById("CareImplant2Spec");
			if (objText) objText.value=Detail[1];
			//部位
			var objText=document.getElementById("CareImplant2Body");
			if (objText) objText.value=Detail[2];
			//数量
			var objText=document.getElementById("CareImplant2Num");
			if (objText) objText.value=Detail[3];
		}
	}
	//标本
	var CareSpecimen=tmpSZCareRecord[6];
	SetEleGroupVal("CareSpecimen",2,CareSpecimen,"R","V");	
	//送冰冻切片
	var CareFreezingSlice=tmpSZCareRecord[7];
	var obj=document.getElementById("CareFreezingSlice");
	if (CareFreezingSlice=="Y") obj.checked=true;
	//送病理标本
	var CarePathologSection=tmpSZCareRecord[8];
	var obj=document.getElementById("CarePathologSection");
	if (CarePathologSection=="Y") obj.checked=true;
	//术中静脉输液
	var SZIntravenInfusion=tmpSZCareRecord[9];
	SetEleGroupVal("SZIntravenInfusion",2,SZIntravenInfusion,"R","V");
	//导尿
	var CareUrineCatheter=tmpSZCareRecord[10];
	SetEleGroupVal("CareUrineCatheter",2,CareUrineCatheter,"R","V");
	//术中静脉输血
	var BloodTranfused=tmpSZCareRecord[11]
	SetEleGroupVal("BloodTranfused",2,BloodTranfused,"R","V");
	//术中引流(与"//引流管",两者只用之一)
	var CareDrainageCatheter=tmpSZCareRecord[12]
	SetEleGroupVal("CareDrainageCatheter",2,CareDrainageCatheter,"R","V");

	var tmpSHCareRecord=SHCareRecord.split("^");
	//离室类型
	var ANSType=tmpSHCareRecord[1];
	//放病区
	var objANSType1=document.getElementById("ANSType1");
	if (ANSType=="W")  objANSType1.checked=true;
	//入ICU
	var objANSType2=document.getElementById("ANSType2");
	if (ANSType=="I")  objANSType2.checked=true;
	//放PACU
	var objANSType3=document.getElementById("ANSType3");
	if (ANSType=="PI")  objANSType3.checked=true;
	//术后静脉输液
	var SHIntravenInfusion=tmpSHCareRecord[2];
	SetEleGroupVal("SHIntravenInfusion",2,SHIntravenInfusion,"R","V");
	//术后皮肤情况
	var SHSkin=tmpSHCareRecord[3];
	SetEleGroupVal("SHSkin",2,SHSkin,"R","V");
	//引流管
	var CareDrainCath=tmpSHCareRecord[4];
	SetEleGroupVal("CareDrainCath",9,CareDrainCath,"C","D");
	//备注
	var ANSNote=tmpSHCareRecord[5];
	var obj=document.getElementById("ANSNote");
	if (obj) obj.value=ANSNote;
	//交班人
	var tmpShiftCtcp=tmpSHCareRecord[6];
	var ShiftCtcpId=document.getElementById("ShiftCtcpId");
	if(ShiftCtcpId) ShiftCtcpId.value=tmpShiftCtcp.split(",")[0];
	var ShiftCtcp=document.getElementById("ShiftCtcp");	
	if (ShiftCtcp) ShiftCtcp.value=tmpShiftCtcp.split(",")[1];
	//接班人
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

//单选公用事件函数
function RadioCheck()
{
	var eSrc=window.event.srcElement;
	var eleName=eSrc.name;
	eleName=eleName.replace(/[^a-z]/ig,""); //只取字符串中的英文字母
	//设定最多有7个框要选择
	for(var i=1;i<7;i++)
	{
		var Obj=document.getElementById(eleName+i);
		if ((!Obj)||(Obj.type!="checkbox")) continue;
		if((eSrc==Obj)&&(Obj.checked==true)) Obj.checked=true;
		else Obj.checked=false;
	}

}
//查询某一组元素值的公用函数
//eleStr:类似元素名称,eleNum:类似元素数目,eleType:单("R")/多选("C"),saveValType:保存值的类型("V","D","DV")
//单选返回所选值的位置"1"
//多选返回所选位置的串"1#2#3#自定义文本"
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

//设置某一组元素值的公用函数
//eleStr:类似元素名称,eleNum:类似元素数目
//eleVal:单选时为所选值所在码表的位置,如"1"
//		 多选返回所选位置的串"1#2#3#自定义文本"	
//eleType:单("R")/多选("C")
//saveValType:保存值的类型("V","D","DV")
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
//判断是否为数字
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
//取某一组元素标签值的公用函数,单选
//eleStr:类似元素名称,eleNum:类似元素数目
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
//设置某一组元素标签值的公用函数,单选
//eleStr:类似元素名称,eleNum:类似元素数目,eleVal:选中元素的标签值
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
//取某一组元素标签值+复选框的公用函数,单选,多选
//eleStr:类似元素名称,eleNum:类似元素数目,eleType:单选(R)/多选(C)
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
	//入室日期
	var obj=document.getElementById("TheatreInTime");
	if (obj) TheatreInTime=obj.value;
	//出室日期
	var obj=document.getElementById("TheatreOutTime");
	if (obj) TheatreOutTime=obj.value;
	//神志
	Consciousness=GetEleGroupVal("Consciousness",5,"R","D");
	//术前静脉输液
	SQIntravenInfusion=GetEleGroupVal("SQIntravenInfusion",2,"R","V");
	//深静脉穿刺
	DeepIntravenPunc=GetEleGroupVal("DeepIntravenPunc",2,"R","V");
	//管道
	Catheter=GetEleGroupVal("Catheter",2,"R","V");
	//术前皮肤情况
	SQSkin=GetEleGroupVal("SQSkin",2,"R","V");
	//术后皮肤情况
	SHSkin=GetEleGroupVal("SHSkin",2,"R","V");
	//药物过敏
	PreAllergy=GetEleGroupVal("PreAllergy",2,"R","V");
	//术前用药
	var obj=document.getElementById("PreAnaDrug1");
	if ((obj)&&(obj.checked==true)) var PreAnaDrug="Y";
	var obj=document.getElementById("PreAnaDrug2");
	if ((obj)&&(obj.checked==true)) var PreAnaDrug="N";
	//禁饮
	var obj=document.getElementById("ForbidDrink");
	if ((obj)&&(obj.checked==true)) var ForbidDrink="Y";
	else ForbidDrink="N";
	//禁食
	var obj=document.getElementById("ForbidFood");
	if ((obj)&&(obj.checked==true)) var ForbidFood="Y";
	else ForbidFood="N";
	//随身物品
	VadeMecum=GetEleGroupVal("VadeMecum",6,"C","D");
	//体表标识
	BodySurfIdentity=GetEleGroupVal("BodySurfIdentity",2,"R","V");
	//手术灭菌用物指示标记
	CareAsepticPackCheck=GetEleGroupVal("CareAsepticPackCheck",2,"R","D");
	//体位
	OperPosition=GetEleLabVal("OperPosition",6);
	//电刀类型
	CareElectrotome=GetEleGroupVal("CareElectrotome",4,"R","D");		
	//负极板位置
	CareNegativePlate=GetEleGroupVal("CareNegativePlate",5,"R","DV");
	//止血带单独处理
	var objCheck1=document.getElementById("CareHemostaticBelt1");	
	if ((objCheck1)&&(objCheck1.checked==true)) CareHemostaticBelt=t['val:no']+",";
	var objCheck2=document.getElementById("CareHemostaticBelt2");	
	if ((objCheck2)&&(objCheck2.checked==true)){
		var Detail=""
		//部位
		var objText=document.getElementById("CareHemostaticBelt2Body");
		if (objText) Detail=objText.value;
		Detail=Detail+"!";
		//压力
		var objText=document.getElementById("CareHemostaticBelt2Press");
		if (objText) Detail=Detail+objText.value;
		Detail=Detail+"!";
		//充气时间
		var objText=document.getElementById("CareHemostaticBelt2PuffTime");
		if (objText) Detail=Detail+objText.value;
		Detail=Detail+"!";
		//松时间
		var objText=document.getElementById("CareHemostaticBelt2RelaxTime");
		if (objText) Detail=Detail+objText.value;
		CareHemostaticBelt=t['val:yes']+","+Detail;
	}
	//体位支撑用物
	CarePositionSupport=GetEleGroupVal("CarePositionSupport",9,"C","D");
	//体内植入物单独处理
	var objCheck1=document.getElementById("CareImplant1");	
	if ((objCheck1)&&(objCheck1.checked==true)) CareImplant=t['val:no']+",";
	var objCheck2=document.getElementById("CareImplant2");	
	if ((objCheck2)&&(objCheck2.checked==true)){
		var Detail=""
		//名称
		var objText=document.getElementById("CareImplant2Name");
		if (objText) Detail=objText.value;
		Detail=Detail+"!";
		//规格
		var objText=document.getElementById("CareImplant2Spec");
		if (objText) Detail=Detail+objText.value;
		Detail=Detail+"!";
		//部位
		var objText=document.getElementById("CareImplant2Body");
		if (objText) Detail=Detail+objText.value;
		Detail=Detail+"!";
		//数量
		var objText=document.getElementById("CareImplant2Num");
		if (objText) Detail=Detail+objText.value;
		CareImplant=t['val:yes']+","+Detail;
	}
	//标本
	CareSpecimen=GetEleGroupVal("CareSpecimen",2,"R","V");	
	//送冰冻切片
	var obj=document.getElementById("CareFreezingSlice");
	if ((obj)&&(obj.checked==true)) CareFreezingSlice="Y";
	else CareFreezingSlice="N";
	//送病理标本
	var obj=document.getElementById("CarePathologSection");
	if ((obj)&&(obj.checked==true)) CarePathologSection="Y";
	else CarePathologSection="N";
	
	//离室类型
	var ANSType="";
	//放病区
	var obj=document.getElementById("ANSType1");
	if ((obj)&&(obj.checked==true))  ANSType="W";
	//入ICU
	var obj=document.getElementById("ANSType2");
	if ((obj)&&(obj.checked==true))  ANSType="I";
	//放PACU
	var obj=document.getElementById("ANSType3");
	if ((obj)&&(obj.checked==true))  ANSType="PI";
	//引流管
	//CareDrainCath=GetEleGroupVal("CareDrainCath",9,"C","D");
	//术后静脉输液
	SHIntravenInfusion=GetEleGroupVal("SHIntravenInfusion",2,"R","V");
	//备注
	var ANSNote="";
	var obj=document.getElementById("ANSNote");
	if (obj) ANSNote=obj.value;
	//交班人
	var ShiftCtcpId=document.getElementById("ShiftCtcpId").value;
	var obj=document.getElementById("ShiftCtcp");	
	if ((obj)&&(obj.value=="")) ShiftCtcpId="";
	//接班人
	var ReliefCtcpId=document.getElementById("ReliefCtcpId").value;
	var obj=document.getElementById("ReliefCtcp");	
	if ((obj)&&(obj.value=="")) ReliefCtcpId="";
	//术中静脉输液
	SZIntravenInfusion=GetEleGroupVal("SZIntravenInfusion",2,"R","V");
	//术中导尿
	CareUrineCatheter=GetEleGroupVal("CareUrineCatheter",2,"R","V");
	//术中静脉输血
	BloodTranfused=GetEleGroupVal("BloodTranfused",2,"R","V");
	//术中引流(与"//引流管",两者只用之一)
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
//取接班人ID
function GetReliefCtcp(str)
{
	var val=str.split("^");
	var obj=document.getElementById("ReliefCtcpId");
	obj.value=val[0];
	var obj=document.getElementById("ReliefCtcp");
	obj.value=val[1];
}
//取交班人ID
function GetShiftCtcp(str)
{
	var val=str.split("^");
	var obj=document.getElementById("ShiftCtcpId");
	obj.value=val[0];
	var obj=document.getElementById("ShiftCtcp");
	obj.value=val[1];
}
//取模版路径
function GetFilePath()
{   var GetPath=document.getElementById("GetPath").value;
    var path=cspRunServerMethod(GetPath);
    return path
}
//打印护理记录单
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
	//基本信息
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
   	//术前
   	row=6;
   	//入室时间
    xlsSheet.cells(row,3)=TheatreInTime;
    //神志
    var Consciousness=GetEleLabVal("Consciousness",5);
    xlsSheet.cells(row,5)=Consciousness; 
	//术前静脉输液
	var SQIntravenInfusion=GetEleLabStr("SQIntravenInfusion",2,"R");
	xlsSheet.cells(row,8)=SQIntravenInfusion;
	//深静脉穿刺
	var DeepIntravenPunc=GetEleLabStr("DeepIntravenPunc",2,"R");
	xlsSheet.cells(row,12)=DeepIntravenPunc;
	row=row+1;
	//管道
	var Catheter=GetEleLabStr("Catheter",2,"R");
	xlsSheet.cells(row,3)=Catheter;
	//术前皮肤情况
	var SQSkin=GetEleLabStr("SQSkin",2,"R");
	xlsSheet.cells(row,8)=SQSkin;
	row=row+1;
	//药物过敏
	var PreAllergy=GetEleLabStr("PreAllergy",2,"R");
	xlsSheet.cells(row,3)=PreAllergy;
	//术前用药
	var PreAnaDrug=GetEleLabStr("PreAnaDrug",2,"R");
	xlsSheet.cells(row,8)=PreAnaDrug;
	//禁饮
	var obj=document.getElementById("ForbidDrink");
	if ((obj)&&(obj.checked==true)) {
		var ObjLabel=document.getElementById("cForbidDrink");
		if (ObjLabel) xlsSheet.cells(row,11)=ObjLabel.innerText+String.fromCharCode(9632);
	}
	//禁食
	var obj=document.getElementById("ForbidFood");
	if ((obj)&&(obj.checked==true)){
		var ObjLabel=document.getElementById("cForbidFood");
		if (ObjLabel) xlsSheet.cells(row,12)=ObjLabel.innerText+String.fromCharCode(9632);
	}
	row=row+1;
	//随身物品
	var VadeMecum=GetEleLabStr("VadeMecum",6,"C");
	xlsSheet.cells(row,3)=VadeMecum;
	//体表标识
	var BodySurfIdentity=GetEleLabStr("BodySurfIdentity",2,"R");
	xlsSheet.cells(row,8)=BodySurfIdentity;
	row=row+1;
	//手术灭菌用物指示标记
	var CareAsepticPackCheck=GetEleLabStr("CareAsepticPackCheck",2,"R");
	xlsSheet.cells(row,5)=CareAsepticPackCheck;
	//术中
	row=row+1;
	//体位
	var OperPosition=GetEleLabVal("OperPosition",6);
	xlsSheet.cells(row,3)=OperPosition;
	row=row+1;
	//电刀类型
	var CareElectrotome=GetEleLabVal("CareElectrotome",4);
	xlsSheet.cells(row,3)=CareElectrotome;		
	//负极板位置
	var CareNegativePlate=GetEleLabVal("CareNegativePlate",5);	
	xlsSheet.cells(row,8)=CareNegativePlate;
	row=row+1;		
	//止血带单独处理
	var CareHemostaticBelt=GetEleLabStr("CareHemostaticBelt",2,"R");
	var Detail=""
	var objCheck2=document.getElementById("CareHemostaticBelt2");
	if ((objCheck2)&&(objCheck2.checked==true)){
		
		//部位
		var objText=document.getElementById("CareHemostaticBelt2Body");
		if (objText) Detail=t['val:Body']+objText.value;
		//压力
		var objText=document.getElementById("CareHemostaticBelt2Press");
		if (objText) Detail=Detail+" "+t['val:Press']+objText.value;
		//充气时间
		var objText=document.getElementById("CareHemostaticBelt2PuffTime");
		if (objText) Detail=Detail+" "+t['val:PuffTime']+objText.value;
		//松时间
		var objText=document.getElementById("CareHemostaticBelt2RelaxTime");
		if (objText) Detail=Detail+" "+t['val:RelaxTime']+objText.value;
	}
	xlsSheet.cells(row,3)=CareHemostaticBelt+" "+Detail;
	row=row+1;
	//体位支撑用物
	var CarePositionSupport=GetEleLabStr("CarePositionSupport",9,"C");	
	xlsSheet.cells(row,3)=CarePositionSupport;
	row=row+1;
	//体内植入物单独处理
	var CareImplant=GetEleLabStr("CareImplant",2,"R");	
	var Detail="";
	var objCheck2=document.getElementById("CareImplant2");	
	if ((objCheck2)&&(objCheck2.checked==true)){
		//名称
		var objText=document.getElementById("CareImplant2Name");
		if (objText) Detail=t['val:Name']+objText.value;
		//规格
		var objText=document.getElementById("CareImplant2Spec");
		if (objText) Detail=Detail+" "+t['val:Spec']+objText.value;
		//部位
		var objText=document.getElementById("CareImplant2Body");
		if (objText) Detail=Detail+" "+t['val:Body']+objText.value;
		//数量
		var objText=document.getElementById("CareImplant2Num");
		if (objText) Detail=Detail+" "+t['val:Num']+objText.value;
	}
	xlsSheet.cells(row,3)=CareImplant+" "+Detail;
	row=row+1;
	//标本
	var CareSpecimen=GetEleLabStr("CareSpecimen",2,"R");	
	xlsSheet.cells(row,3)=CareSpecimen;
	//送冰冻切片
	var obj=document.getElementById("CareFreezingSlice");
	if ((obj)&&(obj.checked==true)) xlsSheet.cells(row,8)=t['val:FreezingSlice'];
	//送病理标本
	var obj=document.getElementById("CarePathologSection");
	if ((obj)&&(obj.checked==true))  xlsSheet.cells(row,8)=t['val:PathologSection'];
	//术后
	row=row+1;
	//出室时间
    xlsSheet.cells(row,3)=TheatreOutTime;
	//离室类型
	var ANSType="";
	//放病区
	var ANSType=GetEleLabVal("ANSType",2);
	xlsSheet.cells(row,5)=ANSType;
	row=row+1;
	//术后静脉输液
	var SHIntravenInfusion=GetEleLabStr("SHIntravenInfusion",2,"R");
	xlsSheet.cells(row,3)=SHIntravenInfusion;
	//术后皮肤情况
	var SHSkin=GetEleLabStr("SHSkin",2,"R");
	xlsSheet.cells(row,8)=SHSkin;
	row=row+1;
	//引流管
	var CareDrainCath=GetEleLabStr("CareDrainCath",9,"C");
	xlsSheet.cells(row,3)=CareDrainCath;
	row=row+1;
	//备注
	var ANSNote="";
	var obj=document.getElementById("ANSNote");
	if (obj) ANSNote=obj.value;
	xlsSheet.cells(row,2)=ANSNote;
	row=row+1;
	//交班人
	var obj=document.getElementById("ShiftCtcp");	
	if (obj) xlsSheet.cells(row,8)=obj.value;
	//接班人
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