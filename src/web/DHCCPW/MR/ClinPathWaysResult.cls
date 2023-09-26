/// 名称: web.DHCCPW.MR.ClinPathWaysResult
/// 描述: 终末评估记录
/// 编写者：zhufei
/// 编写日期: 2011-04-18
Class web.DHCCPW.MR.ClinPathWaysResult Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// 是否填写评估记录
/// w ##Class(web.DHCCPW.MR.ClinPathWaysResult).IsSaveResult(20)
ClassMethod IsSaveResult(aPathWayID As %String) As %String
{
	New (aPathWayID)
	Set return=1
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(aPathWayID)
	If $IsObject(objPathWay) {
		If $IsObject(objPathWay.CPWPathwayDR) {
			Set EvaList=objPathWay.CPWPathwayDR.CPWEvaluateList
			If EvaList'="" {
				Set RstID=+$o(^DHCMR("CPW",aPathWayID,"RST",""),-1)
				Set:RstID<1 return=0
			}
		}
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2011-04-18
/// Description:  根据ID取终末评估记录
/// Table：       User.DHCMRClinicalPathWayResult
/// Input：       ID:    User.DHCMRClinicalPathWayResult.Id
///               separete: 指定的分隔符
/// Return：      返回object
/// w ##class(web.DHCCPW.MR.ClinPathWaysResult).GetObjById("1||1")
ClassMethod GetObjById(argId As %String) As User.DHCMRClinicalPathWayResult
{
	New (argId)
	Set return=##Class(User.DHCMRClinicalPathWayResult).%OpenId(argId)
	Do:return'="" return.%Close()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2011-04-18
/// Description:  临床路径ID取终末评估记录
/// Table：       User.DHCMRClinicalPathWayResult
/// Input：       ID:    User.DHCMRClinicalPathWay.Id
///               separete: 指定的分隔符
/// Return：      String
/// w ##class(web.DHCCPW.MR.ClinPathWaysResult).GetStrByPathWayID(3)
ClassMethod GetStrByPathWayID(aPathWayID As %String)
{
	New (aPathWayID)
	Set return=""
	Quit:aPathWayID="" return
	
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(aPathWayID)
	Quit:'$IsObject(objPathWay) return
	
	Set ChildSub=$o(^DHCMR("CPW",aPathWayID,"RST",""),-1)
	Quit:ChildSub="" return
	
	Set RstID=aPathWayID_"||"_ChildSub
	Set objRst=..GetObjById(RstID)
	Quit:'$IsObject(objRst) return
	Set ZZGSDR=objRst.CPWRZZGSDR  //症状改善
	Set ZZGSDesc=""
	For Ind=1:1:$length(ZZGSDR,",") {
		Set tmpID=$p(ZZGSDR,",",Ind)
		Continue:tmpID=""
		Set objDic=##class(web.DHCCPW.MRC.BaseDictionary).GetObjById(tmpID)
		Continue:'$IsObject(objDic)
		Set ZZGSDesc=ZZGSDesc_","_objDic.BDDesc
	}
	Set:ZZGSDesc'="" ZZGSDesc=$e(ZZGSDesc,2,$l(ZZGSDesc))
	Set TZGSDR=objRst.CPWRTZGSDR  //体征改善
	Set TZGSDesc=""
	For Ind=1:1:$length(TZGSDR,",") {
		Set tmpID=$p(TZGSDR,",",Ind)
		Continue:tmpID=""
		Set objDic=##class(web.DHCCPW.MRC.BaseDictionary).GetObjById(tmpID)
		Continue:'$IsObject(objDic)
		Set TZGSDesc=TZGSDesc_","_objDic.BDDesc
	}
	Set:TZGSDesc'="" TZGSDesc=$e(TZGSDesc,2,$l(TZGSDesc))
	Set LHZBDR=objRst.CPWRLHZBDR  //理化指标
	Set LHZBDesc=""
	For Ind=1:1:$length(LHZBDR,",") {
		Set tmpID=$p(LHZBDR,",",Ind)
		Continue:tmpID=""
		Set objDic=##class(web.DHCCPW.MRC.BaseDictionary).GetObjById(tmpID)
		Continue:'$IsObject(objDic)
		Set LHZBDesc=LHZBDesc_","_objDic.BDDesc
	}
	Set:LHZBDesc'="" LHZBDesc=$e(LHZBDesc,2,$l(LHZBDesc))
	Set ZGQKDR=objRst.CPWRZGQKDR  //转归情况
	Set objDic=##class(web.DHCCPW.MRC.BaseDictionary).GetObjById(ZGQKDR)
	If $IsObject(objDic) {
		Set ZGQKDesc=objDic.BDDesc
	}Else{
		Set ZGQKDesc=""
	}
	Set SaveUserID=objRst.CPWRUserDR
	Set SaveUserDesc=$p($g(^SSU("SSUSR",+SaveUserID)),"^",2)
	Set SaveDate=objRst.CPWRDate
	Set:SaveDate'="" SaveDate=$zd(SaveDate,3)
	Set SaveTime=objRst.CPWRTime
	Set:SaveTime'="" SaveTime=$zt(SaveTime,2)
	Set ResumeText=objRst.CPWRResumeText
	Set return=RstID
	Set return=return_$c(1)_ZZGSDR_$c(2)_ZZGSDesc
	Set return=return_$c(1)_TZGSDR_$c(2)_TZGSDesc
	Set return=return_$c(1)_LHZBDR_$c(2)_LHZBDesc
	Set return=return_$c(1)_ZGQKDR_$c(2)_ZGQKDesc
	Set return=return_$c(1)_SaveDate
	Set return=return_$c(1)_SaveTime
	Set return=return_$c(1)_SaveUserID_$c(2)_SaveUserDesc
	Set return=return_$c(1)_ResumeText
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2011-04-18
/// Description:  更新User.DHCMRClinicalPathWayResult
/// Table：       User.DHCMRClinicalPathWayResult
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCCPW.MR.ClinPathWaysResult).Update("")
ClassMethod Update(argInStr As %String) As %String
{
	New (argInStr)
	Set return=-1
	Quit:argInStr="" return
	
	Set Parref=$p($p(argInStr,"^",1),"||",1)
	Quit:Parref="" return
	Set ChildSub=$p($p(argInStr,"^",1),"||",2)
	If ChildSub="" {
		Set obj=##class(User.DHCMRClinicalPathWayResult).%New()
	}Else{
		Set obj=##class(User.DHCMRClinicalPathWayResult).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set ZZGSDR=$p(argInStr,"^",2)
	Set TZGSDR=$p(argInStr,"^",3)
	Set LHZBDR=$p(argInStr,"^",4)
	Set ZGQKDR=$p(argInStr,"^",5)
	Set UserID=$p(argInStr,"^",6)
	Set ResumeText=$p(argInStr,"^",7)
	Quit:UserID="" return
	
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(Parref)
	Quit:'$IsObject(objPathWay) return
	
	Set obj.CPWRParRef=objPathWay
	Set obj.CPWRZZGSDR=ZZGSDR
	Set obj.CPWRTZGSDR=TZGSDR
	Set obj.CPWRLHZBDR=LHZBDR
	Set obj.CPWRZGQKDR=ZGQKDR
	Set obj.CPWRDate=+$h
	Set obj.CPWRTime=$p($h,",",2)
	Set obj.CPWRUserDR=UserID
	Set obj.CPWRResumeText=ResumeText
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {                      //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-999
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     wuqk
/// CreatDate：   2011-09-26
/// Description:  更新User.DHCMRClinicalPathWayResult
/// Table：       User.DHCMRClinicalPathWayResult
/// Input：       
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCCPW.MR.ClinPathWaysResult).UpdateEva("")
ClassMethod UpdateEva() As %String
{
	New (argList)
	//m argList=mm
	//m argList=^CacheTemp("CPWEva",processindex)
	Set return=-1
	//Quit:argList="" return
	
	//PathWayID:23,UserID:208}  CPWREvaluations
	set PathWayID=$g(argList("PathWayID",1))
	set UserID=$g(argList("UserID",1))
	set ResultID=$g(argList("ResultID",1))
	quit:PathWayID="" return
	quit:UserID="" return
	
	If ResultID="" {
		Set obj=##class(User.DHCMRClinicalPathWayResult).%New()
	}Else{
		Set obj=##class(User.DHCMRClinicalPathWayResult).%OpenId(ResultID)
	}
	Quit:'$IsObject(obj) return
	
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
	Quit:'$IsObject(objPathWay) return
	
	set index=1,CPWREvaluations=$lb(),key="",s=""
	for {
		set key=$o(argList(key))
		quit:key=""
		continue:key="PathWayID"||key="UserID"||key="ResultID"
		continue:key'["||"
		//统一日期格式 add by mxp 20170330
		set objSubCate=##class(web.DHCCPW.MRC.BaseDicSubCategory).GetObjById(key)
		continue:'$IsObject(objSubCate)
		if (objSubCate.BDSCType="D") {
			Set Value=argList(key,1)
			Set:Value'="" Value=##class(DHCMed.SSService.CommonCls).DateHtmlToLogical(Value)
			Set:Value'="" argList(key,1)=Value
		}
		set $li(CPWREvaluations,index)=key_":"_argList(key,1)
		set index=index+1
	}
	Set obj.CPWRParRef=objPathWay
	Set obj.CPWRDate=+$h
	Set obj.CPWRTime=$p($h,",",2)
	Set obj.CPWRUserDR=UserID
	Set obj.CPWREvaluations=CPWREvaluations
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {                      //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-999
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

}
