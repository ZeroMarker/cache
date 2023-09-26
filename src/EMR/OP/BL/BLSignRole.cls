/// 名称：		EMR.OP.BL.BLSignRole
/// 描述：		签名角色业务逻辑类
/// 编写者：	huhao
/// 编写时间：	2021-10-11
Class EMR.OP.BL.BLSignRole Extends EMR.OP.COM.ActionBase [ Not ProcedureBlock ]
{

/// 初始化数据
/// d ##Class(EMR.OP.BL.BLSignRole).IniData()
ClassMethod IniData()
{
		k ^CF.EMR.DOC.SignRoleI,^CF.EMR.DOC.SignRoleD
	d ..AddSignRole("Chairman","科主任","chairmanCheck","1",50,0,0,0)
	d ..AddSignRole("QCDoc","质控医师","qcdocCheck","1",70,0,0,1)	
   	d ..AddSignRole("QCNurse","质控护士","qcnurseCheck","1",70,0,0,1)
    d ..AddSignRole("ChargeNurse","责任护士","chargenurseCheck","1",0,0,0,1)
    d ..AddSignRole("student","学生","studentCheck","1",0,1,1,0)
	d ..AddSignRole("intern","实习医师","internCheck","1",0,1,1,0)
	d ..AddSignRole("Resident","住院医师","residentCheck","1",10,0,1,0)
	d ..AddSignRole("Attending","主治医师","attendingCheck","1",20,0,1,0)
	d ..AddSignRole("ViceChief","副主任医师","viceChiefCheck","1",30,0,1,0)
	d ..AddSignRole("Chief","主任","chiefCheck","1",30,0,1,0)
	d ..AddSignRole("All","医师","participantCheck","1",80,0,0,1)
	d ..AddSignRole("Check","三级审核","check","1",0,0,0,0)
	d ..AddSignRole("Refresher","进修医师","refresherCheck","1",10,0,1,0)
	d ..AddSignRole("Coder","编码员","coderCheck","1",0,0,0,0)
	d ..AddSignRole("PlanTrain","规培医师","planTrainCheck","1",10,0,1,0)
	d ..AddSignRole("TrainDoctor","规培医生","trainDoctorCheck","1",0,1,1,0)
	d ..AddSignRole("Anesthesiologist","麻醉医师","anesthesiologistCheck","1",0,0,0,0)
	d ..AddSignRole("AnesthesiaNurse","麻醉护士","anesthesiaNurseCheck","1",0,0,0,0)
	d ..AddSignRole("Patient","患者","patientSign","1",90,0,0,0)
	d ..AddSignRole("Notation","患者批注","NotationGet","1",0,0,0,0)
	d ..AddSignRole("GroupLeader","诊疗组组长","groupLeaderCheck","1",40,0,0,0)
	d ..AddSignRole("Doctor","医生","doctorCheck","1",80,0,0,0)
	d ..AddSignRole("Nurse","护士","nurseCheck","1",0,0,0,0)
}

ClassMethod AddSignRole(AName, ADescription, AActionCode, AIsValid, ARoleLevel, ASignPrefix, ACanSignOnCheck, ANotValidate) As %String
{
	s result = 0
	s rowId = $o(^CF.EMR.DOC.SignRoleI("NameIndex"," "_$zcvt(AName,"U"),""))
	if (rowId = "")
	{
		s obj = ##Class(CF.EMR.DOC.SignRole).%New()
	}
	else
	{
		s obj = ##Class(CF.EMR.DOC.SignRole).%OpenId(rowId)
	}
	s obj.Name = AName
	s obj.Description = ADescription
	s obj.ActionCode = AActionCode
	s obj.IsValid = AIsValid
	s obj.RoleLevel = ARoleLevel
	s obj.SignPrefix = ASignPrefix
	s obj.CanSignOnCheck = ACanSignOnCheck
	s obj.NotValidate = ANotValidate
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = 1
	q result
}

/// Creator:	huhao
/// CreatDate:  
/// Desc:		获取签名角色（含查询）
/// Input：		
/// Return：	失败：0，成功：1
ClassMethod SelectSignRole(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s Name=argInJson.params.name
	s Desc=argInJson.params.desc
    s strRes = ##class(EMR.OP.BL.BLSignRole).SelectRole(Name,Desc,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未查到签名角色信息",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

ClassMethod SelectRole(Name As %String, Desc As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s name = ""
	s count= 1
	s resJsonArray=##class(%DynamicArray).%New()
	for i=1:1:23
	{
		s name = $o(^CF.EMR.DOC.SignRoleI("NameIndex",name))
		q:(name = "")
		s rowId = $o(^CF.EMR.DOC.SignRoleI("NameIndex",name,""))
		continue:(rowId = "")
		s obj = ##Class(CF.EMR.DOC.SignRole).%OpenId(rowId)
		continue:(obj = "")
		;q:Name=""&&Desc=""
		if ((Name="") && (Desc'=""))
		{
			if ($find(obj.Description,Desc)'=0)
			{
				d setJson
			}	
			else
			{
				break
			}
		}
		elseif ((Name'="") && (Desc=""))
		{
			if ($find(obj.Name,Name)'=0)
			{
				d setJson
			}	
			else
			{
				break
			}
		}
		elseif ((Name'="") && (Desc'=""))
		{
			if ($find(obj.Description,Desc)'=0 && $find(obj.Name,Name)'=0)
			{
				d setJson
			}	
			else
			{
				break
			}
		}
		elseif ((Name="") && (Desc=""))
		{
			d setJson
		}
	}
	d resJsonArray.%ToJSON(argOutData)
	q "1"
setJson
	s resultJson=##class(%DynamicObject).%New()
	s resultJson.key=count
	s resultJson.name=obj.Name
	s resultJson.desc=obj.Description
	s resultJson.actioncode=obj.ActionCode
	s resultJson.rolelevel=obj.RoleLevel
	s:(obj.SignPrefix="1") resultJson.signprefix=1
	s:(obj.SignPrefix="0") resultJson.signprefix=0
	s:(obj.CanSignOnCheck="1") resultJson.cansignoncheck=1
	s:(obj.CanSignOnCheck="0") resultJson.cansignoncheck=0
	s:(obj.NotValidate="1") resultJson.notvalidate=1
	s:(obj.NotValidate="0") resultJson.notvalidate=0
	d resJsonArray.%Push(resultJson)
	s count =count+1
}

/// Creator:	huhao
/// CreatDate:  
/// Desc:		修改签名角色权限
/// Input：		
/// Return：	失败：0，成功：1
ClassMethod UpdateRoleRoot(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "ErrorMsg"
	s Name=argInJson.params.name
	s PrefixFlag=argInJson.params.signprefix
	s SignCheckFlag=argInJson.params.cansignoncheck
	s NotValidateFlag=argInJson.params.notvalidate
    s strRes = ##class(EMR.OP.BL.BLSignRole).UpdateRole(Name,PrefixFlag,SignCheckFlag,NotValidateFlag)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","修改失败",2)
	}
ErrorMsg
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// Creator:	huhao
/// CreatDate:  2021/11/1
/// Desc:		签名角色权限修改
/// Input：		
ClassMethod UpdateRole(Name As %String, PrefixFlag As %String, SignCheckFlag As %String, NotValidateFlag As %String) As %String
{
	s result=""
	q:Name="" "Name不能为空"
	s SName=Name,rowkey=""
	&sql(select ID INTO :rowkey from CF_EMR_DOC.SignRole where Name=:SName)
	s Rowkey=rowkey
	s obj=##class(CF.EMR.DOC.SignRole).%OpenId(Rowkey)
	s obj.SignPrefix=PrefixFlag
	s obj.CanSignOnCheck=SignCheckFlag
	s obj.NotValidate=NotValidateFlag
	s sc=obj.%Save()
	q "1"
}

}
