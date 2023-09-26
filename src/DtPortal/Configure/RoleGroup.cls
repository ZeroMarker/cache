Class DtPortal.Configure.RoleGroup Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, StorageStrategy = RoleStorage ]
{

Relationship ChildItem As DtPortal.Configure.RoleGroupItem [ Cardinality = children, Inverse = ParRef ];

/// 角色对应的portal中的id
Property PortalID As %String(TRUNCATE = 1);

/// 角色code
Property RoleCode As %String(TRUNCATE = 1);

/// 角色描述
Property RoleDesc As %String(TRUNCATE = 1);

/// 是否有效 （Y：有效；N：无效）
Property RoleIsActive As %String;

/// 更新日期
Property RoleUpdate As %Date;

/// 更新时间
Property RoleUpTime As %Time;

// Portal角色ID索引

Index PortalIDIndex On PortalID;

// 角色代码索引

Index RoleCodeIndex On RoleCode;

// 角色描述索引

Index RoleDescIndex On RoleDesc;

/// Creator：     chengpeng
/// CreatDate：   2016-07-08
/// Description:  取角色配置
/// Table：       DtPortal_Configure.RoleGroup
/// Input：       DtPortal.Configure.RoleGroup
/// Return：      返回obj
/// w ##class(DtPortal.Configure.RoleGroup).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DtPortal.Configure.RoleGroup
{
	New (aId)
	Set obj=##Class(DtPortal.Configure.RoleGroup).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Return：      返回obj
/// w ##class(DtPortal.Configure.RoleGroup).test(1)
ClassMethod test(aId As %String) As %String
{
	New (aId)
	Set obj=##Class(DtPortal.Configure.RoleGroup).%OpenId(aId)
	set b="",c=""
	w obj.RoleDesc,!
	w obj.%DispatchSetProperty("RoleDesc")
	//set:$d(obj.c) c=obj.c
	w b_"$$"_c,!
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chengpeng
/// CreatDate：   2016-07-08
/// Description:  更新角色配置
/// Table：       DtPortal_Configure.RoleGroup
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DtPortal.Configure.RoleGroup).Update("^1^2^3^N","^")
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	Set return=-1
	Set:aSeparate="" aSeparate="^"
	
	Set ID=$p(aInput,aSeparate,1)
	set PortalID=$p(aInput,aSeparate,2)
	set RoleCode=$p(aInput,aSeparate,3)
	set RoleDesc=$p(aInput,aSeparate,4)
	If ID="" {
		Set obj=##class(DtPortal.Configure.RoleGroup).%New()
		set rowID=$o(^DtPortal.Configure.RoleGroupI("PortalIDIndex"," "_PortalID,""))
		quit:rowID'="" 0
		set rowID=$o(^DtPortal.Configure.RoleGroupI("RoleCodeIndex"," "_RoleCode,""))
		quit:rowID'="" 0
		set rowID=$o(^DtPortal.Configure.RoleGroupI("RoleDescIndex"," "_RoleDesc,""))
		quit:rowID'="" 0
	} Else {
		Set obj=##class(DtPortal.Configure.RoleGroup).%OpenId(ID)
		set isHava=0
		set rowID=""
		for
		{
			set rowID=$o(^DtPortal.Configure.RoleGroupI("PortalIDIndex"," "_PortalID,rowID))
			quit:rowID=""
			
			set:rowID'=ID isHava=1
		}
		quit:isHava=1 0
		
		set rowID=""
		for
		{
			set rowID=$o(^DtPortal.Configure.RoleGroupI("RoleCodeIndex"," "_RoleCode,rowID))
			quit:rowID=""
			
			set:rowID'=ID isHava=1
		}
		quit:isHava=1 0
		
		set rowID=""
		for
		{
			set rowID=$o(^DtPortal.Configure.RoleGroupI("RoleDescIndex"," "_RoleDesc,rowID))
			quit:rowID=""
			
			set:rowID'=ID isHava=1
		}
		quit:isHava=1 0
		
	}
	Quit:'$IsObject(obj) return
	
	Set obj.PortalID       = $p(aInput,aSeparate,2)
	Set obj.RoleCode       = $p(aInput,aSeparate,3)
	Set obj.RoleDesc       = $p(aInput,aSeparate,4)
	Set obj.RoleIsActive   = $p(aInput,aSeparate,5)
	Set obj.RoleUpdate     = $p($h,",",1)
	Set obj.RoleUpTime     = $p($h,",",2)
	
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     chengpeng
/// CreatDate：   2016-07-08
/// Description:  删除角色配置
/// Table：       DtPortal_Configure.RoleGroup
/// Input：       DtPortal.Configure.RoleGroup
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(ID) As %String
{
	New (ID)
	Set return=0
	Set sc = ##class(DtPortal.Configure.RoleGroup).%DeleteId(+ID)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Creator：     chengpeng
/// CreatDate：   2016-07-08
/// Description:  查询角色配置
/// Table：       DtPortal_Configure.RoleGroup
/// Input：       DtPortal.Configure.RoleGroup
/// w ##Class(DtPortal.Configure.RoleGroup).qureyGroupConfigure()
ClassMethod qureyGroupConfigure(page = 1, rows = 10, q = "") As %String
{
	 set start=(page-1)*rows+1
	 set end=page*rows
	 set count=0
	 w "{""rows"":["
	 
	 set rowID=""
	 for
	 {
		 set rowID=$o(^DtPortal.Configure.RoleGroupD(rowID))
		 quit:rowID=""
		 
		 set obj=##class(DtPortal.Configure.RoleGroup).GetObjById(rowID)
		 continue:'$IsObject(obj)
		 set count=count+1
		 continue:count<start
		 continue:count>end
		 set PortalID=obj.PortalID
		 set RoleCode=obj.RoleCode
		 set RoleDesc=obj.RoleDesc
		 set RoleIsActive=obj.RoleIsActive
		 w $case(count,start:"",:",")
		 w "{"
		 w """ID"":"_""""_rowID_""""_","
		 w """PortalID"":"_""""_PortalID_""""_","
		 w """RoleCode"":"_""""_RoleCode_""""_","
		 w """RoleDesc"":"_""""_RoleDesc_""""_","
		 w """RoleIsActive"":"_""""_RoleIsActive_""""
		 w "}" 
		 
	 }
	 w "],""total"":"_count_"}"
	 q ""
}

/// Creator：     chengpeng
/// CreatDate：   2016-07-08
/// Description:  查询角色配置
/// Table：       DtPortal_Configure.RoleGroup
/// Input：       DtPortal.Configure.RoleGroup
/// w ##Class(DtPortal.Configure.RoleGroup).qureyRole()
ClassMethod qureyRole(page = 1, rows = 10, q = "") As %String
{
	 set start=1
	 set end=1000
	 set count=0
	
	 set isHaveRole=0 
	 
	 w "["
	 set rowID=""
	 for
	 {
		 set rowID=$o(^DtPortal.Configure.RoleGroupD(rowID))
		 quit:rowID=""
		 
		 set obj=##class(DtPortal.Configure.RoleGroup).GetObjById(rowID)
		 continue:'$IsObject(obj)
		 set RoleIsActive=obj.RoleIsActive
		 continue:RoleIsActive="N"
		 
		 set count=count+1
		 continue:count<start
		 continue:count>end
		 set PortalID=obj.PortalID
		 set RoleCode=obj.RoleCode
		 set RoleDesc=obj.RoleDesc
		 set RoleIsActive=obj.RoleIsActive
		 w $case(count,start:"",:",")
		 w "{"
		 w """id"":"_""""_rowID_""""_","
		 w """text"":"_""""_RoleDesc_""""
		 w "}" 
		 set isHaveRole=1
	 }
	 w:isHaveRole=1 ","
	 w "{"
	 w """id"":"_""""_"ALL"_""""_","
	 w """text"":"_""""_"全部用户"_""""
	 w "}"
	 
	 w "]"
	 q ""
}

/// Creator：      chengpeng
/// CreatDate：    2016-07-04
/// Description：  分页显示安全组
/// Table：        SS_Group
/// Input：	      page：当前页数
///               rows：每页条数
/// Return：       
/// d ##class(DtPortal.Configure.RoleGroup).qureyGroup(,,"bk")
ClassMethod qureyGroup(page = 1, rows = 10, q)
{
    set start=(page-1)*rows+1
    set end=page*rows
    set count=0
    set q=$$ALPHAUP^SSUTIL4(q)
    
    w "{""rows"":["
    set gropID=0
    for
    {
	    set gropID=$o(^SSU("SSGRP",gropID))
	    quit:gropID=""
	    
	    set gropDesc=$p(^SSU("SSGRP",gropID),"^",1)
	    set gropDescSP=##Class(DtPortal.Common.Util.ChineseToPY).GetPY(gropDesc)
		continue:((q'="")&&(gropDescSP'[q)&&(gropDesc'[q))
	
	    set count=count+1
		continue:count<start
		continue:count>end
		
	    w $case(count,start:"",:",")
	    w "{"
	    w """ID"":"_""""_gropID_""""_","
		w """gropDesc"":"_""""_gropDesc_""""
		w "}" 
	}
	w "],""total"":"_count_"}"
	q ""
}

/// Creator：     chengpeng
/// CreatDate：   2017-04-12
/// Description:  查询科室
/// Table：       CT_LOC
/// w ##Class(DtPortal.Configure.RoleGroup).qureyLoc(1,1000,"")
ClassMethod qureyLoc(page = 1, rows = 10, q) As %String
{
	 ;set start=(page-1)*rows+1
	 ;set end=page*rows
	 set start=1
	 set end=1000
	 set count=0

	 w "["
	 
	 set q=$$ALPHAUP^SSUTIL4(q)
	 set LocDesc=""
	 for
	 {
		 set LocDesc=$o(^CTLOC(0,"Desc",LocDesc))
		 quit:LocDesc=""
		 
		 continue:LocDesc'[q
		 set LocID=""
		 for
		 {
			 set LocID=$o(^CTLOC(0,"Desc",LocDesc,LocID))
			 quit:LocID=""
			 
			 set RlocDesc=$p(^CTLOC(LocID),"^",2)
			 set:RlocDesc["-" RlocDesc=$p(RlocDesc,"-",2)
			 
			 set count=count+1
			 continue:count<start
			 continue:count>end
			 w $case(count,start:"",:",")
			 w "{"
		 	 w """id"":"_""""_LocID_""""_","
		 	 w """text"":"_""""_RlocDesc_""""
		 	 w "}" 
		 }
	 }
	 w "]"
	 q ""
}

/// Creator：     chengpeng
/// CreatDate：   2017-09-14
/// Description:  根据角色Code获取配置的安全组ID串
/// w ##Class(DtPortal.Configure.RoleGroup).getGroupStr("doctor")
ClassMethod getGroupStr(RoleCode As %String) As %String
{
	set retuen=""
	set RoleCode=$$ALPHAUP^SSUTIL4(RoleCode)
	set roleID=""
	for
	{
		set roleID=$o(^DtPortal.Configure.RoleGroupI("RoleCodeIndex"," "_RoleCode,roleID))
		quit:roleID=""
		
		set roleItemID=0
		for
		{
			set roleItemID=$o(^DtPortal.Configure.RoleGroupD(roleID,"Item",roleItemID))
			quit:roleItemID=""
			
			set roleItemObj=##class(DtPortal.Configure.RoleGroupItem).%OpenId(roleID_"||"_roleItemID)
			continue:'$IsObject(roleItemObj)
			set groupID=roleItemObj.GroupObj.%Id()
			set:retuen'="" retuen=retuen_"^"_groupID
			set:retuen="" retuen=groupID
		}
	}
	
	 
	q retuen
}

/// Creator：     程鹏
/// CreatDate：   2018-09-26
/// Description:  导出全部数据
/// w ##Class(DtPortal.Configure.RoleGroup).locIndexExp("")
ClassMethod locIndexExp() As %String
{
	
	 w "["
	 set isFirst=1,isHaveRole=0
	 set rowID=""
	 for
	 {
		 set rowID=$o(^DtPortal.Configure.RoleGroupD(rowID))
		 quit:rowID=""
		 
		 set obj=##class(DtPortal.Configure.RoleGroup).GetObjById(rowID)
		 continue:'$IsObject(obj)
		 
		 set PortalID=obj.PortalID
		 set RoleCode=obj.RoleCode
		 set RoleDesc=obj.RoleDesc
		 set RoleIsActive=obj.RoleIsActive
		 
		 w:isFirst'=1 ","
		 w "{"
		 w """PortalID"":"_""""_PortalID_""""_","
		 w """RoleCode"":"_""""_RoleCode_""""_","
		 w """RoleDesc"":"_""""_RoleDesc_""""_","
		 w """RoleIsActive"":"_""""_RoleIsActive_""""_","
		 w """subData"":["
		 
		 set isFirst=isFirst+1
		 
		 set isSubFirst=1
		 set RoleGroupID=""
		 for
		 {
			 set RoleGroupID=$o(^DtPortal.Configure.RoleGroupD(rowID,"Item",RoleGroupID))
			 quit:RoleGroupID=""
			 
			 Set RoleGroupObj=##class(DtPortal.Configure.RoleGroupItem).%OpenId(rowID_"||"_RoleGroupID)
			 continue:'$IsObject(RoleGroupObj)
			 
			 continue:'$IsObject(RoleGroupObj.GroupObj)
			 set groupID=RoleGroupObj.GroupObj.%Id()
			 set groupDesc=RoleGroupObj.GroupObj.SSGRPDesc
		
			 w:isSubFirst'=1 ","
			 w "{"
			 w """RoleCode"":"_""""_RoleCode_""""_","
			 w """RoleDesc"":"_""""_RoleDesc_""""_","
			 w """groupID"":"_""""_groupID_""""_","
			 w """groupDesc"":"_""""_groupDesc_""""
			 w "}" 
			 set isSubFirst=2
		 }
		 w "]}" 
		
	 }
	 
	 
	 w "]"
	q ""
}

/// Creator：     程鹏
/// CreatDate：   2018-09-26
/// Description:  导入数据
/// w ##Class(DtPortal.Configure.RoleGroup).locIndexInport("^13149^Doctor^医生^Y*^13501^DirectorDoctor^科主任^Y*^13147^NurseDepartment^护理部^Y*^13502^MedicalDepartment^医务部^Y*^13504^NurseHead^护士长^Y*^19701^OutpatientDepartment^门诊部^Y*^10165^User^普通用户^Y*^15526^CEO^院长^Y*^1066908^IPD^住院部^Y*^13503^Nurse^护士^Y(%)Doctor^医生^29^住院医师*DirectorDoctor^科主任^30^住院医师(主任)*NurseDepartment^护理部^69^护理部*NurseDepartment^护理部^117^护理部主任")
ClassMethod locIndexInport(inpotData) As %String
{
	set length=$l(inpotData,"*")
	quit:length=0 """"_0_"^"_"数据为空！！！"_""""
	
	k ^DtPortal.Configure.RoleGroupD
	k ^DtPortal.Configure.RoleGroupI
	
	set roleData=$p(inpotData,"(%)",1)
	set subRoleData=$p(inpotData,"(%)",2)

	set return="",isOk=0,ErrStr="",subIsOK=0,subErrStr=""
	for index=1:1:$l(roleData,"*")
	{
		set dataStr=$p(roleData,"*",index)
		continue:dataStr=""
		s ret=..Update(dataStr,"^")
		
		set roleDesc=$p(dataStr,"^",4)
		
		set:((ret=-1)&&(ErrStr'="")) ErrStr=ErrStr_"/"_roleDesc_"保存失败"
		set:((ret=-1)&&(ErrStr="")) ErrStr=roleDesc_"保存失败"
		
		set:((ret=0)&&(ErrStr'="")) ErrStr=ErrStr_"/"_roleDesc_"已存在"
		set:((ret=0)&&(ErrStr="")) ErrStr=roleDesc_"已存在"
		
		set:ret>0 isOk=+isOk+1
		
	}
	
	if subRoleData'=""
	{
		for index=1:1:$l(subRoleData,"*")
		{
			set dataStr=$p(subRoleData,"*",index)
			continue:dataStr=""
			
			set RoleCode=$p(dataStr,"^",1)
			set RoleDesc=$p(dataStr,"^",2)
			set groupID=$p(dataStr,"^",3)
			set groupDesc=$p(dataStr,"^",4)
			
			set RoleCode=$$ALPHAUP^SSUTIL4(RoleCode)
			
			set rowID=$o(^DtPortal.Configure.RoleGroupI("RoleCodeIndex"," "_RoleCode,""))
			if rowID="" 
			{
				set:subErrStr'="" subErrStr=subErrStr_"/"_groupDesc_"保存失败"_RoleDesc_"不存在"
				set:subErrStr'="" subErrStr=groupDesc_"保存失败"_RoleDesc_"不存在"
				continue
			}
			
			set groObj=##Class(User.SSGroup).%OpenId(groupID)
			if '$IsObject(groObj)
			{
				set:subErrStr'="" subErrStr=subErrStr_"/"_groupDesc_"安全组不存在"
				set:subErrStr'="" subErrStr=groupDesc_"安全组不存在"
				continue
			}
			
			set subStrSave=rowID_"^^"_groupID
			
			set subStr=##Class(DtPortal.Configure.RoleGroupItem).Update(subStrSave,"^")
			
			set:((subStr=-1)&&(subErrStr'="")) subErrStr=subErrStr_"/"_RoleDesc_groupDesc_"保存失败"
			set:((subStr=-1)&&(subErrStr="")) subErrStr=RoleDesc_groupDesc_"保存失败"
			
			set:((subStr=0)&&(subErrStr'="")) subErrStr=subErrStr_"/"_RoleDesc_groupDesc_"已存在"
			set:((subStr=0)&&(subErrStr="")) subErrStr=RoleDesc_groupDesc_"已存在"
			
			set:subStr>0 subIsOK=+subIsOK+1
			
		}
	}
	set return=""""_isOk_"^"_ErrStr_"^"_subIsOK_"^"_subErrStr_""""
	q return
}

Storage RoleStorage
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PortalID</Value>
</Value>
<Value name="3">
<Value>RoleCode</Value>
</Value>
<Value name="4">
<Value>RoleDesc</Value>
</Value>
<Value name="5">
<Value>GroupDesc</Value>
</Value>
<Value name="6">
<Value>RoleIsActive</Value>
</Value>
<Value name="7">
<Value>RoleUpdate</Value>
</Value>
<Value name="8">
<Value>RoleUpTime</Value>
</Value>
</Data>
<DataLocation>^DtPortal.Configure.RoleGroupD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DtPortal.Configure.RoleGroupD</IdLocation>
<IndexLocation>^DtPortal.Configure.RoleGroupI</IndexLocation>
<StreamLocation>^DtPortal.Configure.RoleGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
