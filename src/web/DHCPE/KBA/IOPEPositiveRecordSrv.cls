/// 名称: web.DHCPE.KBA.IOPEPositiveRecordSrv
/// 描述: 导出导入阳性体征指标
/// 编写者：zhufei
/// 编写日期: 2022-01-22
Class web.DHCPE.KBA.IOPEPositiveRecordSrv Extends web.DHCPE.KBA.IOBaseSetting [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：    zhufei
/// CreatDate：  2022-01-22
/// Description: 导出阳性体征指标（公有）
/// Table：      User.DHCPEPositiveRecord
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOPEPositiveRecordSrv","QryPositiveRecord",152)
Query QryPositiveRecord(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,Code:%String,Name:%String,MSequence:%String,FSequence:%String,RType:%String,RTypeDesc:%String,UserDR:%String,UserName:%String,RUseRange:%String,RUseRangeDesc:%String")
{
}

ClassMethod QryPositiveRecordExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Set xCode=""
	For {
		Set xCode=$o(^User.DHCPEPositiveRecordI("PCodeUnqIdx1",xCode))
		Quit:xCode=""
		
		Set xID=0
		For {
			Set xID=$o(^User.DHCPEPositiveRecordI("PCodeUnqIdx1",xCode,xID))
			Quit:xID=""
			Continue:##class(User.DHCPEPositiveRecord).GetLocShowDataFlag(xID,aLocId)'["Y"  //无显示权限退出
			
			Set obj=##class(User.DHCPEPositiveRecord).GetObjById(xID)
			Continue:'$IsObject(obj)
			Set Code        = obj.PCode
			Set Name        = obj.PName
			Set MSequence   = obj.PMSequence
			Set FSequence   = obj.PFSequence
			Set RType       = obj.PRType
			Set RTypeDesc=$s(RType="P":"阳性记录统计",RType="Q":"数据统计",1:RType)
			Set UserDR      = obj.PRUserDR
			Set UserName=$p($g(^SSU("SSUSR",+UserDR)),"^",2)
			Set RUseRange   = obj.PRUseRange
			Set RUseRangeDesc=$s(RUseRange="S":"系统",RUseRange="U":"个人",1:RUseRange)
			
			Set Data=$lb(xID,Code,Name,MSequence,FSequence,RType,RTypeDesc,UserDR,UserName,RUseRange,RUseRangeDesc)
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
    }
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-22
/// Description:  导入阳性体征指标（公有）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOPEPositiveRecordSrv).SavePositiveRecord("^0000^神经科^1^2^Q^数据统计^^^S^系统")
ClassMethod SavePositiveRecord(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
    Set aLocId=..#InLocID
    Quit:aLocId="" "-100" //目标科室未设置
    Set aLocId=$p(aLocId,"^",1)
    
	Set:$g(aDelimiter)="" aDelimiter=..#Delimiter
	Set ID            = $p(aInputStr,aDelimiter,1)    //ID
	Set Code          = $p(aInputStr,aDelimiter,2)    //代码
	Set Name          = $p(aInputStr,aDelimiter,3)    //描述
	Set MSequence     = $p(aInputStr,aDelimiter,4)    //男性排序
	Set FSequence     = $p(aInputStr,aDelimiter,5)    //女性排序
	Set RType         = $p(aInputStr,aDelimiter,6)    //数据类型
	Set RTypeDesc     = $p(aInputStr,aDelimiter,7)    //数据类型描述
	Set UserDR        = $p(aInputStr,aDelimiter,8)    //创建者
	Set UserName      = $p(aInputStr,aDelimiter,9)    //创建者姓名
	Set RUseRange     = $p(aInputStr,aDelimiter,10)    //使用范围
	Set RUseRangeDesc = $p(aInputStr,aDelimiter,11)    //使用范围描述
	Quit:(Code="")||(Name="") return
	
	If UserDR'="" {
		Set objUser=##class(User.SSUser).%OpenId(UserDR)
		Do objUser.%Close()
	} Else {
		Set objUser=""
	}
	
	For idxInLoc=1:1:$l(aLocId,"^"){
		Set xInLocID=$p(aLocId,"^",idxInLoc)
		Continue:xInLocID=""
		
		Set xID=0,tID=""
		For {
			Set xID=$o(^User.DHCPEPositiveRecordI("PCodeUnqIdx1"," "_$zcvt(Code,"U"),xID))
			Quit:xID=""
			Continue:##class(User.DHCPEPositiveRecord).GetLocShowDataFlag(xID,xInLocID)'["Y"  //无显示权限退出
			Set tID=xID
		}
		Set:ID="" ID=tID
		Continue:(tID'="")&(ID'=tID) //返回错误提示：名称不唯一
		
		If ID="" {
			Set obj=##class(User.DHCPEPositiveRecord).%New()
		}Else{
			Set obj=##class(User.DHCPEPositiveRecord).%OpenId(ID)
		}
		Continue:'$IsObject(obj)
		
		Set obj.PCode            = Code
		Set obj.PName            = Name
		Set obj.PMSequence       = MSequence
		Set obj.PFSequence       = FSequence
		Set obj.PRType           = RType
		Set obj.PRUserDR         = objUser
		Set obj.PRUseRange       = RUseRange
		
		Set sc=obj.%Save()
		If $system.Status.IsError(sc) {        //检查Save是否成功
	   		Do $system.OBJ.DisplayError(sc) 
	   		Set return=-1
	   		Quit
		}Else{
			Set return=obj.%Id()
		}
		Do obj.%Close()
		
		//保存表记录授权
		Set flg=##class(User.DHCPEPositiveRecord).SaveDataToPowerControl(obj.%Id(),xInLocID,"")
	}
	Quit return
}

}
