/// 名称: web.DHCCPW.MRC.PathWEpStep
/// 描述：对临床路径步骤的各种操作分别有添加，删除，修改，查询等操作
/// 编写者：李宇峰
/// 编写日期：2010-05-04
Class web.DHCCPW.MRC.PathWEpStep Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2010-11-07
/// Description:  根据ID取临床路径步骤
/// Table：       User.DHCMRCClinPathWaysEpStep
/// Input：       ID:    User.DHCMRCClinPathWaysEpStep.Id
///               separete: 指定的分隔符
/// Return：      返回object
/// w ##class(web.DHCCPW.MRC.PathWEpStep).GetObjById("1||1||1")
ClassMethod GetObjById(argId As %String) As User.DHCMRCClinPathWaysEpStep
{
	New (argId)
	Set return=##Class(User.DHCMRCClinPathWaysEpStep).%OpenId(argId)
	Do:return'="" return.%Close()
	Quit return
}

/// Creator:李宇峰
/// CreatDate:2010-05-04
/// Description:此Query是用来得到指定临床路径阶段下的所有步骤的全部记录或者指定的一个步骤
/// Table:User.DHCMRCClinPathWaysEpStep
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.PathWEpStep","GetPathEpStep","2||1||1","")
/// by wuqk 2011-07-25 增加列 StepTypeCode,StepTypeDesc
Query GetPathEpStep(argStepRowID As %String, argEpRowID As %String) As %Query(ROWSPEC = "StepRowid:%String,StepDay:%String,StepDayUnit:%String,StepDayUnitDesc:%String,StepDesc:%String,StepDayNum:%String,StepTypeCode:%String,StepTypeDesc:%String")
{
}

ClassMethod GetPathEpStepExecute(ByRef qHandle As %Binary, argStepRowID As %String, argEpRowID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	If argStepRowID'="" {
		Set CPWID=$p(argStepRowID,"||",1)
		Set EpID=$p(argStepRowID,"||",2)
		Set StepID=0
		For {
			Set StepID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID))
			Quit:StepID=""
			Set StepRowID=CPWID_"||"_EpID_"||"_StepID
			Set objStep=..GetObjById(StepRowID)
			If $IsObject(objStep){
				Set StepDesc=objStep.CPWSDesc
				Set StepDay=objStep.CPWSDay
				Set StepDayNum=objStep.CPWSDayNumber
				Set StepDayUnit=objStep.CPWSUnit
				Set StepDayUnitDesc=##class(web.DHCCPW.MRC.BaseConfig).GetDicByCode("EpStepDayUnit",StepDayUnit)
				//StepTypeCode,StepTypeDesc add by wuqk 2011-07-25
				set StepTypeCode=objStep.CPWSStepTypeCode
				set StepTypeDesc=##class(web.DHCCPW.MRC.BaseDictionary).GetDescBySubCateAndCode("STEPTYPE",StepTypeCode)

				Set Data=$lb(StepRowID,StepDay,StepDayUnit,StepDayUnitDesc,StepDesc,StepDayNum,StepTypeCode,StepTypeDesc)
	 			Set ^CacheTemp(repid,ind)=Data
	 			Set ind=ind+1
			}
		}
	}ElseIf argEpRowID'=""{
		Set CPWID=$p(argEpRowID,"||",1)
		Set EpID=$p(argEpRowID,"||",2)
		Set StepID=0
		For {
			Set StepID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID))
			Quit:StepID=""
			Set StepRowID=CPWID_"||"_EpID_"||"_StepID
			Set objStep=..GetObjById(StepRowID)
			If $IsObject(objStep){
				Set StepDesc=objStep.CPWSDesc
				Set StepDay=objStep.CPWSDay
				Set StepDayNum=objStep.CPWSDayNumber
				Set StepDayUnit=objStep.CPWSUnit
				Set StepDayUnitDesc=##class(web.DHCCPW.MRC.BaseConfig).GetDicByCode("EpStepDayUnit",StepDayUnit)
				//StepTypeCode,StepTypeDesc add by wuqk 2011-07-25
				set StepTypeCode=objStep.CPWSStepTypeCode
				set StepTypeDesc=##class(web.DHCCPW.MRC.BaseDictionary).GetDescBySubCateAndCode("STEPTYPE",StepTypeCode)

				Set Data=$lb(StepRowID,StepDay,StepDayUnit,StepDayUnitDesc,StepDesc,StepDayNum,StepTypeCode,StepTypeDesc)
	 			Set ^CacheTemp(repid,ind)=Data
	 			Set ind=ind+1
			}
		}
	}Else{
		//Error
	}
	
	Quit $$$OK
}

ClassMethod GetPathEpStepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPathEpStepExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}Else{				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPathEpStepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPathEpStepExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:李宇峰
/// CreatDate:2010-05-05
/// Description:AddStep是向指定临床路径阶段添加一个步骤
/// Table:User.DHCMRCClinPathWaysEpStep
/// StepTypeCode add by wuqk 2011-07-25
ClassMethod AddStep(EpRowid As %String, StepDay As %String, StepDesc As %String, StepDayNum As %String, StepDayUnit As %String, StepTypeCode As %String)
{
	New (EpRowid,StepDay,StepDesc,StepDayNum,StepDayUnit,StepTypeCode)
	Set return=-1
	Quit:(EpRowid="")||(StepDay="")||(StepDesc="")||(StepDayNum="")||(StepDayUnit="") return
	//StepTypeCode add by wuqk 2011-07-25
	Set InputStr=EpRowid_"^"_""_"^"_StepDay_"^"_StepDayNum_"^"_StepDesc_"^"_StepDayUnit_"^"_StepTypeCode
	Set return=..Update(InputStr)
	Quit return
}

/// Creator:李宇峰
/// CreatDate:2010-05-05
/// Description:UpdateStep修改一个步骤
/// Table:User.DHCMRCClinPathWaysEpStep
/// by wuqk 2011-07-25 增加StepTypeCode 
ClassMethod UpdateStep(StepRowid As %String, StepDay As %String, StepDesc As %String, StepDayNum As %String, StepDayUnit As %String, StepTypeCode As %String)
{
	New (StepRowid,StepDay,StepDesc,StepDayNum,StepDayUnit,StepTypeCode)
	Set return=-1
	Quit:(StepRowid="")||(StepDay="")||(StepDesc="")||(StepDayNum="")||(StepDayUnit="") return
	
	Set CPWID=$p(StepRowid,"||",1)
	Set EpID=$p(StepRowid,"||",2)
	Set StepID=$p(StepRowid,"||",3)
	Set EpRowID=CPWID_"||"_EpID
	//StepTypeCode add by wuqk 2011-07-25
	Set InputStr=EpRowID_"^"_StepID_"^"_StepDay_"^"_StepDayNum_"^"_StepDesc_"^"_StepDayUnit_"^"_StepTypeCode
	Set return=..Update(InputStr)
	Quit return
}

/// Creator:李宇峰
/// CreatDate:2010-05-05
/// Description:GetNewDayNum得到一个最新的序号。
/// Table:User.DHCMRCClinPathWaysEpStep
/// w ##Class(web.DHCCPW.MRC.PathWEpStep).GetNewDayNum("2||1")
ClassMethod GetNewDayNum(argEpRowID As %String)
{
	New (argEpRowID)
	Set return=0
	Quit:argEpRowID="" return
	
	Set CPWID=$p(argEpRowID,"||",1)
	Set EpID=$p(argEpRowID,"||",2)
	Set StepID=0
	For {
		Set StepID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID))
		Quit:StepID=""
		Set StepRowID=CPWID_"||"_EpID_"||"_StepID
		Set objStep=..GetObjById(StepRowID)
		If $IsObject(objStep){
			Set StepDesc=objStep.CPWSDesc
			Set StepDay=objStep.CPWSDay
			Set StepDayNum=objStep.CPWSDayNumber
			Set StepDayUnit=objStep.CPWSUnit
			Set:StepDayNum>return return=StepDayNum
		}
	}
	
	Set return=return+1
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-11-01
/// Description:  保存临床路径步骤
/// Table：       User.DHCMRCClinPathWaysEpStep
/// Input：       argInPut: 临床路径步骤数据
/// Return：      return<0: 保存失败
/// w ##Class(web.DHCCPW.MRC.PathWEpStep).Update(argInput)
ClassMethod Update(argInput As %String) As %String
{
	New (argInput)
	Set return=-1
	
	Set ParRef=$p(argInput,"^",1)
	Quit:ParRef="" return
	Set ChildSub=$p(argInput,"^",2)
	If ChildSub="" {
		Set obj=##class(User.DHCMRCClinPathWaysEpStep).%New()
	} Else {
		Set ID=ParRef_"||"_ChildSub
		Set obj=##class(User.DHCMRCClinPathWaysEpStep).%OpenId(ID)
		Quit:obj="" return
	}
	
	Set objParRef=##Class(User.DHCMRCClinPathWaysEp).%OpenId(ParRef)
	If objParRef'="" Do objParRef.%Close()
	Set Day=+$p(argInput,"^",3)
	Set DayNumber=+$p(argInput,"^",4)
	Set Desc=$p(argInput,"^",5)
	Set DayUnit=$p(argInput,"^",6)
	Quit:(Day=0)||(DayNumber<1)||(Desc="")||(objParRef="") return
	Set StepTypeCode=$p(argInput,"^",7)    //步骤类型代码 add by wuqk 2011-07-25
	
	Set obj.CPWSParRef=objParRef
	Set obj.CPWSDay=Day              //步骤时间
	Set obj.CPWSDayNumber=DayNumber  //步骤序号
	Set obj.CPWSDesc=Desc            //步骤描述
	Set obj.CPWSUnit=DayUnit         //步骤时间单位
	Set obj.CPWSStepTypeCode=StepTypeCode         //步骤类型代码 add by wuqk 2011-07-25
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {                      //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
}

/// Creator:李宇峰
/// CreatDate:2010-05-05
/// Description:DeleteStep删除一个步骤
/// Table:User.DHCMRCClinPathWaysEpStep
/// w ##Class(web.DHCCPW.MRC.PathWEpStep).DeleteStep(argId)
ClassMethod DeleteStep(argId As %String) As %String
{
	new (argId)
	set return=0
	set sc = ##class(User.DHCMRCClinPathWaysEpStep).%DeleteId(argId)
	if $system.Status.IsError(sc) {         //检查删除是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	}
	quit return
}

/// w ##Class(web.DHCCPW.MRC.PathWEpStep).GetPathEpSteps(argEpRowID)
ClassMethod GetPathEpSteps(argEpRowID As %String)
{
	New (argEpRowID)
	Set return=""
	Quit:argEpRowID="" return
	
	Set CPWID=$p(argEpRowID,"||",1)
	Set EpID=$p(argEpRowID,"||",2)
	Set StepID=0
	For {
		Set StepID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID))
		Quit:StepID=""
		Set StepRowID=CPWID_"||"_EpID_"||"_StepID
		Set objStep=..GetObjById(StepRowID)
		If $IsObject(objStep){
			Set StepDesc=objStep.CPWSDesc
			Set StepDay=objStep.CPWSDay
			Set StepDayNum=objStep.CPWSDayNumber
			Set StepDayUnit=objStep.CPWSUnit
			Set return=return_","_StepRowID_"^"_StepDesc_"--"_StepDayNum
		}
	}
	
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

/// w ##Class(web.DHCCPW.MRC.PathWEpStep).CheckSameDayNum(1,"2||1","")
ClassMethod CheckSameDayNum(argDayNum As %String, argEpRowID As %String, argStepRowID As %String)
{
	New (argDayNum,argEpRowID,argStepRowID)
	Set return=0
	Quit:(argDayNum="")||(argEpRowID="") return
	
	Set CPWID=$p(argEpRowID,"||",1)
	Set EpID=$p(argEpRowID,"||",2)
	Set StepID=0
	For {
		Set StepID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID))
		Quit:StepID=""
		Set StepRowID=CPWID_"||"_EpID_"||"_StepID
		Continue:(argStepRowID'="")||(argStepRowID=StepRowID)
		Set objStep=..GetObjById(StepRowID)
		If $IsObject(objStep){
			Set StepDesc=objStep.CPWSDesc
			Set StepDay=objStep.CPWSDay
			Set StepDayNum=objStep.CPWSDayNumber
			Set StepDayUnit=objStep.CPWSUnit
			Continue:argDayNum'=StepDayNum
			Set return=1
		}
	}
	Quit return
}

}
