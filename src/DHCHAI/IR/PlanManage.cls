/// 名称: DHCHAI.IR.PlanManage
/// 描述: 消息干预-预案管理
/// 编写者：zhoubo
/// 编写日期: 2019-04-29
Class DHCHAI.IR.PlanManage Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 预案名称
Property IRPlanName As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 预案类型("PlanType")
Property IRPlanTypeDr As DHCHAI.BT.Dictionary [ Required ];

/// 关键词
Property IRKeys As %String(MAXLEN = 500, TRUNCATE = 1);

/// 内容
Property IRContent As %String(MAXLEN = 5000, TRUNCATE = 1);

/// 更新日期
Property IRUpdateDate As %Date;

/// 更新时间
Property IRUpdateTime As %Time;

/// 更新人
Property IRUpdateUserDr As DHCHAI.BT.SysUser;

/// 是否有效
Property IRIsActive As %Boolean;

/// 预案类型索引
Index IndexPlanTypeDr On IRPlanTypeDr As Exact;

/// 预案名索引 唯一索引
Index IndexPlanName On IRPlanName As Exact;

/// Creator：     zhoubo
/// CreatDate：   2019-04-19
/// Description:  根据ID取预案信息
/// Table：       DHCHAI.IR.PlanManage
/// Input：       aId : DHCHAI.IR.PlanManage.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.PlanManage).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.PlanManage
{
	New (aId)
	Quit:'##class(DHCHAI.IR.PlanManage).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.PlanManage).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2019-04-19
/// Description:  更新预案信息
/// Table：       DHCHAI.IR.PlanManage
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.PlanManage).Update("^上呼吸道感染^700^上呼吸道感染,呼吸机^医院肺炎是我国最创建的医院感染类型，呼吸机相关肺炎（VAP）是其中的重要类型，预后较差。^^^8^1","^")
/// w ##class(DHCHAI.IR.PlanManage).Update("^多重耐药感染预防要点^701^多重耐药菌^优先安置容易传播感染的患者，如大、小便失禁的患者。将感染或定植相同病原体的患者安置在同一病房。设立隔离标识。^^^8^1","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			  = $p(aInputStr,aSeparete,1)
	Set IRPlanName    = $p(aInputStr,aSeparete,2)
	Set IRPlanTypeDr  = $p(aInputStr,aSeparete,3)
	Set IRKeys        = $p(aInputStr,aSeparete,4)
	Set IRContent     = $p(aInputStr,aSeparete,5)
	Set UpdateDate    = $p(aInputStr,aSeparete,6)
	Set UpdateTime    = $p(aInputStr,aSeparete,7)
	Set UpdateUserDr  = $p(aInputStr,aSeparete,8)
	Set IRIsActive    = +$p(aInputStr,aSeparete,9)
	
	Quit:(IRPlanName="")||(IRPlanTypeDr="")||(IRKeys="")||(IRContent="") return
	Set IRKeys = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(IRKeys)  //去掉特殊字符
	Set IRContent = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(IRContent)  //去掉特殊字符
	
	Set:UpdateDate'="" UpdateDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(UpdateDate)
	Set:UpdateDate="" UpdateDate=+$h
	Set:UpdateTime[":" UpdateTime = $zth(UpdateTime,1)
	Set:UpdateTime="" UpdateTime=$p($h,",",2)
	
	Set tID=$o(^DHCHAI.IR.PlanManageI("IndexPlanName",IRPlanName,0))
	Quit:(tID'="")&(ID'=tID) -2
	
	Set objType=##class(DHCHAI.BT.Dictionary).GetObjById(IRPlanTypeDr)
	Quit:'$IsObject(objType) return
	Set objUser=##class(DHCHAI.BT.SysUser).GetObjById(UpdateUserDr)
	
	If ID="" {
		Set obj=##class(DHCHAI.IR.PlanManage).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.PlanManage).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.IRPlanName	  = IRPlanName
	Set obj.IRPlanTypeDr  = objType
	Set obj.IRKeys        = IRKeys
	Set obj.IRContent     = IRContent
	Set obj.IRUpdateDate  = UpdateDate
	Set obj.IRUpdateTime  = UpdateTime
	Set obj.IRUpdateUserDr	= objUser
	Set obj.IRIsActive    = IRIsActive
	
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2019-04-19
/// Description:  导入预案信息
/// Table：       DHCHAI.IR.PlanManage
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.PlanManage).ImportPlanManage("^多重耐药菌感染预防^多重耐药菌预防与控制^多重耐药菌^应将患者安置","^")
ClassMethod ImportPlanManage(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=-1
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID = ""
	Set strTypeDesc = $p(aInputStr,aSeparate,2)
	Set strPlanName = $p(aInputStr,aSeparate,3)
	Set strKeys     = $p(aInputStr,aSeparate,4)
	Set strContent  = $p(aInputStr,aSeparate,5)
	Set IRIsActive  = $p(aInputStr,aSeparate,6)

	Set ID=$o(^DHCHAI.IR.PlanManageI("IndexPlanName",strPlanName,0))
	Set TypeDr=""
	Set objType = ##class(DHCHAI.BT.Dictionary).GetObjByDesc("PlanType",strTypeDesc)
    Set:$IsObject(objType) TypeDr = objType.%Id()
    Quit:TypeDr="" return
	Set InputStr=ID_"^"_strPlanName_"^"_TypeDr_"^"_strKeys_"^"_strContent_"^"_""_"^"_""_"^"_""_"^"_IRIsActive
	Set return=..Update(InputStr,"^")
	
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2019-04-19
/// Description:  删除预案信息
/// Table：       DHCHAI.IR.PlanManage
/// Input：       aId : DHCHAI.IR.PlanManage.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.PlanManage).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.PlanManage).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

Storage Default
{
<Data name="PlanManageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IRPlanName</Value>
</Value>
<Value name="3">
<Value>IRPlanTypeDr</Value>
</Value>
<Value name="4">
<Value>IRKeys</Value>
</Value>
<Value name="5">
<Value>IRContent</Value>
</Value>
<Value name="6">
<Value>IRUpdateDate</Value>
</Value>
<Value name="7">
<Value>IRUpdateTime</Value>
</Value>
<Value name="8">
<Value>IRUpdateUserDr</Value>
</Value>
<Value name="9">
<Value>IRIsActive</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.PlanManageD</DataLocation>
<DefaultData>PlanManageDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.PlanManageD</IdLocation>
<IndexLocation>^DHCHAI.IR.PlanManageI</IndexLocation>
<StreamLocation>^DHCHAI.IR.PlanManageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
