/// 名称: web.DHCPE.KBA.IOOMEHandOpinSrv
/// 描述: 导出导入职业健康检查处理意见
/// 编写者：zhufei
/// 编写日期: 2022-01-27
Class web.DHCPE.KBA.IOOMEHandOpinSrv Extends web.DHCPE.KBA.IOBaseSetting [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：    zhufei
/// CreatDate：  2022-01-27
/// Description: 导出职业健康检查处理意见（私有）
/// Table：      User.DHCPEHandlingOpinions
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOOMEHandOpinSrv","QryHandlingOpinions",152)
Query QryHandlingOpinions(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,Sort:%String,Active:%String,OMETCode:%String,OMETDesc:%String,CCode:%String,CDesc:%String,Remark:%String")
{
}

ClassMethod QryHandlingOpinionsExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Set xCode=""
	For {
		Set xCode=$o(^User.DHCPEHandlingOpinionsI("HOCodeIndex",xCode))
		Quit:xCode=""
		
		Set xID=0
		For {
			Set xID=$o(^User.DHCPEHandlingOpinionsI("HOCodeIndex",xCode,xID))
			Quit:xID=""
			Continue:##class(User.DHCPEHandlingOpinions).GetLocShowDataFlag(xID,aLocId)'["Y"  //无显示权限退出
			
			Set obj=##class(User.DHCPEHandlingOpinions).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:obj.HOActive'="Y"  //无效数据过滤
			Set Code        = obj.HOCode
			Set Desc        = obj.HODesc
			Set Sort        = obj.HOSort
			Set (OMETCode,OMETDesc)=""
			If $IsObject(obj.HOOMETypeDR){
				Set OMETCode = obj.HOOMETypeDR.OMETCode
				Set OMETDesc = obj.HOOMETypeDR.OMETDesc
			}
			Set (CCode,CDesc)=""
			If $IsObject(obj.HOConclusionDR){
				Set CCode = obj.HOConclusionDR.CCode
				Set CDesc = obj.HOConclusionDR.CDesc
			}
			Set Active      = obj.HOActive
			Set Remark      = obj.HORemark
			
			Set Data=$lb(xID,Code,Desc,Sort,Active,OMETCode,OMETDesc,CCode,CDesc,Remark)
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
    }
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-27
/// Description:  导入职业健康检查处理意见（私有）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOOMEHandOpinSrv).SaveHandlingOpinions("^004^肺功能异常，建议择日复查肺功能。^4^Y^02^复查^^^")
ClassMethod SaveHandlingOpinions(aInputStr As %String, aDelimiter As %String = "^") As %String
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
	Set Sort          = $p(aInputStr,aDelimiter,4)    //顺序号
	Set Active        = $p(aInputStr,aDelimiter,5)    //激活
	Set CCode         = $p(aInputStr,aDelimiter,6)    //职业病结论分类代码
	Set CDesc         = $p(aInputStr,aDelimiter,7)    //职业病结论分类描述
	Set OMETCode      = $p(aInputStr,aDelimiter,8)    //职业病检查种类代码
	Set OMETDesc      = $p(aInputStr,aDelimiter,9)    //职业病检查种类描述
	Set Remark        = $p(aInputStr,aDelimiter,10)   //备注
	Quit:(Code="")||(Desc="")||(CCode="") return
	
	Set CID=$o(^User.DHCPEConclusionI("CCodeIndex"," "_$zcvt(CCode,"U"),0))
	Quit:CID="" return
	Set OMETID=$o(^User.DHCPEOMETypeI("OMETCodeIndex"," "_$zcvt(OMETCode,"U"),0))
	Set Active=$s(Active["Y":"Y",Active["是":"Y",1:"N")
	
	For idxInLoc=1:1:$l(aLocId,"^"){
		Set xInLocID=$p(aLocId,"^",idxInLoc)
		Continue:xInLocID=""
		
		Set xID=0,tID=""
		For {
			Set xID=$o(^User.DHCPEHandlingOpinionsI("HOCodeIndex"," "_$zcvt(Code,"U"),xID))
			Quit:xID=""
			Continue:##class(User.DHCPEHandlingOpinions).GetLocShowDataFlag(xID,xInLocID)'["Y"  //无显示权限退出
			Set tID=xID
		}
		Set:ID="" ID=tID
		Continue:(tID'="")&(ID'=tID) //返回错误提示：名称不唯一
		
		If ID="" {
			Set obj=##class(User.DHCPEHandlingOpinions).%New()
		}Else{
			Set obj=##class(User.DHCPEHandlingOpinions).%OpenId(ID)
		}
		Continue:'$IsObject(obj)
		
		Set obj.HOCode          = Code
		Set obj.HODesc          = Desc
		Set obj.HOSort          = Sort
		Set obj.HOActive        = Active
		Set obj.HOOMETypeDR     = ##class(User.DHCPEOMEType).GetObjById(OMETID)
		Set obj.HOConclusionDR  = ##class(User.DHCPEConclusion).GetObjById(CID)
		Set obj.HORemark        = Remark
		Set obj.HOUpdateDate    = +$h
		Set obj.HOUpdateTime    = $p($h,",",2)
		
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
		Set flg=##class(User.DHCPEHandlingOpinions).SaveDataToPowerControl(obj.%Id(),xInLocID,"")
	}
	Quit return
}

}
