/// ClassName:    DtPortal.DD.DD00PublicService
/// Description:  临床科主任公共服务
/// Creator：     chengpeng
/// CreatDate:    2015-12-18
Class DtPortal.DD.DD00PublicService Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     WHH
/// CreatDate：   2017-09-13
/// Description:  DD00.00.01 查询科室内的医生
/// Input：       UserCode    :  用户工号 ROWId串
/// Return：      医生信息
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.DD.DD00PublicService","QueryLocDoc","601")
Query QueryLocDoc(UserCode As %String, locGroupID As %String) As DtPortal.Query(ROWSPEC = "UserID:%String,UserName:%String")
{
}

ClassMethod QueryLocDocExecute(ByRef qHandle As %Binary, UserCode As %String, locGroupID As %String) As %Status
{
	
	
	new (qHandle,UserCode,locGroupID)
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	k ^||QueryLocDoc
	set DocLocStr=..getDDloc(locGroupID,"I")
	Quit:DocLocStr="" $$$OK
	
	for index=1:1:$l(DocLocStr,"^")
	{
		set DocLoc=$p(DocLocStr,"^",index)
		Set AdmType="I"
		Set xDate=0
		For {
			Set xDate=$o(^PAADMi("AdmTypeCurrLoc",AdmType,DocLoc,xDate))
			Quit:xDate=""
			Set xTime=""
			For {
				Set xTime=$o(^PAADMi("AdmTypeCurrLoc",AdmType,DocLoc,xDate,xTime))
				Quit:xTime=""
			
				Set xPaadm=""
				For {
					Set xPaadm=$o(^PAADMi("AdmTypeCurrLoc",AdmType,DocLoc,xDate,xTime,xPaadm))
					Quit:xPaadm=""
				
					Continue:$p($g(^PAADM(+xPaadm)),"^",2)'="I"   //就诊类型过滤
					Continue:$p($g(^PAADM(+xPaadm)),"^",20)="C"   //就诊状态过滤
				
					Set CPDocID=$p($g(^PAADM(xPaadm)),"^",9)     //主管医生
					continue:CPDocID=""
					set UserID=$O(^SSU("SSUSR",0,"CTPCP",CPDocID,""),-1)
				
					set ^||QueryLocDoc("QueryLocDoc",UserID)=""
				}
			}
		}	
	}	
	
	set UserID=""
	for
	{
		set UserID=$o(^||QueryLocDoc("QueryLocDoc",UserID))
		quit:UserID=""
		
		set UserName=$p(^SSU("SSUSR",UserID),"^",2)
		
		Set Data=$lb(UserID,UserName)
		Set ^||CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

/// Creator：     chengpeng
/// CreatDate：   2015-12-18
/// Description:  DD00.00.01 查询科室内的医生
/// Input：       UserCode    :  用户工号
/// Return：      医生信息
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.DD.DD00PublicService","QueryLocDocBeifen","601")
Query QueryLocDocBeifen(UserCode As %String) As DtPortal.Query(ROWSPEC = "UserID:%String,UserName:%String")
{
}

ClassMethod QueryLocDocBeifenExecute(ByRef qHandle As %Binary, UserCode As %String) As %Status
{
	new (qHandle,UserCode)
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	k ^||QueryLocDoc
	set DocLoc=##class(DtPortal.Common.PaadmService).getDDLocIDByUserCode(UserCode)
	w DocLoc,!
	Quit:DocLoc="" $$$OK
	Set AdmType="I"
	
	set PaadmStr=##Class(DtPortal.Common.PaadmService).GetIPPaadmList(3,"",DocLoc)
	for index=1:1:$l(PaadmStr,"^")
	{
		set PaadmID=$p(PaadmStr,"^",index)
		continue:PaadmID=""
		Set CPDocID=$p($g(^PAADM(PaadmID)),"^",9)     //主管医生
		continue:CPDocID=""
		set UserID=$O(^SSU("SSUSR",0,"CTPCP",CPDocID,""),-1)	
		set ^||QueryLocDoc("QueryLocDoc",UserID)=""
		
	}
	
	set UserID=""
	for
	{
		set UserID=$o(^||QueryLocDoc("QueryLocDoc",UserID))
		quit:UserID=""
		
		set UserName=$p(^SSU("SSUSR",UserID),"^",2)
		
		Set Data=$lb(UserID,UserName)
		Set ^||CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

// Return：  w ##class(DtPortal.DD.DD00PublicService).getDDloc("I*157||O*","O")

/// creator    :  whh
/// date       :  20170908
/// description:  获取科室id串
ClassMethod getDDloc(alocGroupID As %String, locType As %String) As %String
{
	new (alocGroupID,locType)
	set return=""
	quit:alocGroupID'["||" alocGroupID
	s locInfoLength=$l(alocGroupID,"||")
	for i=1:1:locInfoLength{
		s locInfo=$p(alocGroupID,"||",i)
		continue:locInfo=""
		s locTypeTemp=$p(locInfo,"*",1)
		if (locType=""){
			if (return=""){
				set return=$p(locInfo,"*",2)
			}else{
				set return=return_"^"_$p(locInfo,"*",2)
			}
		}else{
			if (locTypeTemp=locType){
				s return=$p(locInfo,"*",2)
				q:return'=""   //直接退出循环
			}
		}
		
	}
	q return

	Quit return
}

/// creator    :  zhaoli
/// date       :  20180402
/// description:  获取科室code串
/// w ##class(DtPortal.DD.DD00PublicService).getDDlocCode("1","I")
ClassMethod getDDlocCode(alocGroupID As %String, locType As %String) As %String
{
	new (alocGroupID,locType)
	set return=""
	quit:alocGroupID="" return	
	set isLocGroup=0,locGID=""
	set:alocGroupID'["||" isLocGroup=1,locGID=alocGroupID
	set:alocGroupID["||" locGID=$p(alocGroupID,"||",1)
	
	set locGroupSubID=""
	for
	{
		set locGroupSubID=$o(^DtPortal.Configure.LocGroupD(locGID,"Log",locGroupSubID))
		quit:locGroupSubID=""
	
		set subRowID=locGID_"||"_locGroupSubID
		set subObj=##class(DtPortal.Configure.LocGroupSub).GetObjById(subRowID)
		continue:'$IsObject(subObj)
		set LocGroupType=subObj.LocGroupType
		set linLocIDs=subObj.LocGroupRelationLoc
		set LocID=subObj.LocGroupLocID.%Id()
		set code=$p($g(^CTLOC(LocID)),"^","1")
		continue:LocID=""
		continue:code=""
		if locType="I"
		{	
			if isLocGroup=1
			{
				set:return'="" return=return_"^"_code
				set:return="" return=code
			}else
			{
				continue:LocGroupType'="I"
				continue:alocGroupID'=subRowID
				set:return'="" return=return_"^"_code
				set:return="" return=code
			}
			
		}else
		{	
			if isLocGroup=1
			{
				continue:LocGroupType'=locType
				set:return'="" return=return_"^"_code
				set:return="" return=code
			}else
			{
				continue:LocGroupType'=locType
				set isLink=0
				for indexL=1:1:$l(linLocIDs,"^")
				{
					set linLoca=$p(linLocIDs,"^",indexL)
					continue:linLoca'=alocGroupID
					set isLink=1
				}
				continue:isLink=0
				set:return'="" return=return_"^"_code
				set:return="" return=code
			}
		}
		
	}
	Quit return
}

/// creator    :  zhaoli
/// date       :  20180402
/// description:  获取科室name串
/// w ##class(DtPortal.DD.DD00PublicService).getDDlocCode("1||5","I")
ClassMethod getDDlocName(alocGroupID As %String, locType As %String) As %String
{
	new (alocGroupID,locType)
	set return=""
	quit:alocGroupID="" return	
	set isLocGroup=0,locGID=""
	set:alocGroupID'["||" isLocGroup=1,locGID=alocGroupID
	set:alocGroupID["||" locGID=$p(alocGroupID,"||",1)
	
	set locGroupSubID=""
	for
	{
		set locGroupSubID=$o(^DtPortal.Configure.LocGroupD(locGID,"Log",locGroupSubID))
		quit:locGroupSubID=""
	
		set subRowID=locGID_"||"_locGroupSubID
		set subObj=##class(DtPortal.Configure.LocGroupSub).GetObjById(subRowID)
		continue:'$IsObject(subObj)
		set LocGroupType=subObj.LocGroupType
		set linLocIDs=subObj.LocGroupRelationLoc
		set LocID=subObj.LocGroupLocID.%Id()
		set name=$p($g(^CTLOC(LocID)),"^","2")
		i name'="" d
		.i name["-" s name=$p(name,"-",2)
		continue:LocID=""
		continue:name=""
		if locType="I"
		{	
			if isLocGroup=1
			{
				set:return'="" return=return_"^"_name
				set:return="" return=name
			}else
			{
				continue:LocGroupType'="I"
				continue:alocGroupID'=subRowID
				set:return'="" return=return_"^"_name
				set:return="" return=name
			}
			
		}else
		{	
			if isLocGroup=1
			{
				continue:LocGroupType'=locType
				set:return'="" return=return_"^"_name
				set:return="" return=name
			}else
			{
				continue:LocGroupType'=locType
				set isLink=0
				for indexL=1:1:$l(linLocIDs,"^")
				{
					set linLoca=$p(linLocIDs,"^",indexL)
					continue:linLoca'=alocGroupID
					set isLink=1
				}
				continue:isLink=0
				set:return'="" return=return_"^"_name
				set:return="" return=name
			}
		}
		
	}
	Quit return
}

/// Creator：     sunjianan
/// CreatDate：   2017-01-12
/// Description:  返回二级科室对应的His代码
/// Input：       locGroupID + SubId   :  科室组二级id
/// Return：      医生信息
/// w ##class(DtPortal.DD.DD00PublicService).getLittleDDloc("2||3")
ClassMethod getLittleDDloc(alocGroupID As %String) As %String
{
	new (alocGroupID)
	set return=""
	q:alocGroupID'["||" ""
    set subObj=##class(DtPortal.Configure.LocGroupSub).GetObjById(alocGroupID)
	q:'$IsObject(subObj)
	set LocGroupType=subObj.LocGroupType
	set locID=subObj.LocGroupLocID.%Id()
	
	Quit locID
}

}
