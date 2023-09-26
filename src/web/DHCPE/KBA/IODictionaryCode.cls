/// 名称: web.DHCPE.KBA.IODictionaryCode
/// 描述: 导出导入职业健康数据字典
/// 编写者：
/// 编写日期: 2023-03-28
Class web.DHCPE.KBA.IODictionaryCode Extends web.DHCPE.KBA.IOBaseSetting [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：    
/// CreatDate：  2023-03-28
/// Description: 导出职业健康数据字典
/// Table：      User.DHCPEDictionaryCode
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IODictionaryCode","QryDictionaryCode",152,"SYMPTOM")
Query QryDictionaryCode(aLocId As %String = "", xType As %String = "") As websys.Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,Type:%String,Active:%String,ExFlag:%String")
{
}

ClassMethod QryDictionaryCodeExecute(ByRef qHandle As %Binary, aLocId As %String = "", xType As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Quit:xType="" $$$OK
    Set xType=" "_xType
    
	Set xCode=""
	For {
		Set xCode=$o(^CT.PE.OccuDictionaryCodeI("TypeCodeIndex",xType,xCode))
		Quit:xCode=""
		
		Set xID=0
		For {
			Set xID=$o(^CT.PE.OccuDictionaryCodeI("TypeCodeIndex",xType,xCode,xID))
			Quit:xID=""
			
			Set obj=##class(User.DHCPEOccuDictionaryCode).%OpenId(xID)
			Continue:'$IsObject(obj)
			Continue:obj.ODCActive'="Y"  //无效数据过滤
			Set Code   = obj.ODCCode
			Set Desc   = obj.ODCDesc
			Set Type   = obj.ODCType
			Set Active = obj.ODCActive
			Set ExFlag = obj.ODCExFlag
			
			Set Data=$lb(xID,Code,Desc,Type,Active,ExFlag)
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
	}
    Quit $$$OK
}

/// Creator：     
/// CreatDate：   2023-03-28
/// Description:  导入职业健康数据字典
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IODictionaryCode).SaveDictionaryCode("^^^^")
ClassMethod SaveDictionaryCode(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
    Set aLocId=..#InLocID
    Quit:aLocId="" "-100" //目标科室未设置
    
	Set:$g(aDelimiter)="" aDelimiter=..#Delimiter
	Set ID            = $p(aInputStr,aDelimiter,1)    //ID
	Set Code          = $p(aInputStr,aDelimiter,2)    //代码
	Set Desc          = $p(aInputStr,aDelimiter,3)    //描述
	Set Active        = $p(aInputStr,aDelimiter,4)    //激活
	Set Type          = $p(aInputStr,aDelimiter,5)    //类型
	Set ExFlag        = $p(aInputStr,aDelimiter,6)    //子节点
	Quit:(Code="")||(Desc="")||(Type="") return
	
	Set Base=" BASE"
	Set PID=$o(^CT.PE.OccuDictionaryCodeI("TypeCodeIndex",Base," "_$zcvt(Type,"U"),0))
	Quit:PID="" return
	Quit:$lg(^CT.PE.OccuDictionaryCodeD(PID),4)'="BASE" return
	
	Set Active=$s(Active["Y":"Y",Active["是":"Y",1:"N")
	
	Set ID=$o(^CT.PE.OccuDictionaryCodeI("TypeCodeIndex"," "_$zcvt(Type,"U")," "_$zcvt(Code,"U"),0))
	If ID="" {
		Set obj=##class(User.DHCPEOccuDictionaryCode).%New()
	}Else{
		Set obj=##class(User.DHCPEOccuDictionaryCode).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
    s obj.ODCCode=Code
    s obj.ODCDesc=Desc
    s obj.ODCType=Type
    d obj.ODCRelationSetObjectId(PID)
    s obj.ODCActive=Active
    s obj.ODCExFlag=ExFlag
    
    s sc=obj.%Save()
	Do obj.%Close()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
   		Quit
	}Else{
		Set return=obj.%Id()
	}
	Quit return
}

}
