/// 名称: web.DHCPE.KBA.IOPEStationSrv
/// 描述: 导出导入站点数据（管控）
/// 编写者：zhufei
/// 编写日期: 2022-01-19
Class web.DHCPE.KBA.IOPEStationSrv Extends web.DHCPE.KBA.IOBaseSetting [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：    zhufei
/// CreatDate：  2022-01-19
/// Description: 导出站点数据（管控）
/// Table：      User.DHCPEStation
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOPEStationSrv","QryStation",152)
Query QryStation(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,Active:%String,KBXCode:%String,KBItemCatDesc:%String")
{
}

ClassMethod QryStationExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Set xCode=""
    For {
		Set xCode=$o(^DHCPEST(0,"Code",xCode))
		Quit:xCode=""
		
		Set xID=0
		For {
			Set xID=$o(^DHCPEST(0,"Code",xCode,xID))
			Quit:xID=""
			Continue:##class(User.DHCPEStation).GetLocShowDataFlag(xID,aLocId)'["Y"  //无显示权限退出
			
			Set obj=##class(User.DHCPEStation).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:obj.STActive'="Y"  //无效数据过滤
			Set Code = obj.STCode
			Set Desc = obj.STDesc
			Set KBXCode = obj.STKBXCode
			Set KBItemCatDesc = obj.STKBItemCatDesc
			Set Active = obj.STActive
			
			Set Data=$lb(xID,Code,Desc,Active,KBXCode,KBItemCatDesc)
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
    }
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-19
/// Description:  导入站点字典（管控）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOPEStationSrv).SaveStation()
ClassMethod SaveStation(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
    Set aLocId=..#InLocID
    Quit:aLocId="" "-100" //目标科室未设置
    
	Set:$g(aDelimiter)="" aDelimiter=..#Delimiter
	Set ID            = $p(aInputStr,aDelimiter,1)    //ID
	Set Code          = $p(aInputStr,aDelimiter,2)    //站点代码
	Set Desc          = $p(aInputStr,aDelimiter,3)    //站点描述
	Set Active        = $p(aInputStr,aDelimiter,4)    //是否有效
	Set KBXCode       = $p(aInputStr,aDelimiter,5)    //知识库外部码
	Set KBItemCatDesc = $p(aInputStr,aDelimiter,6)    //知识库站点名称
	Quit:(Code="")||(Desc="") return
	
	Set Active=$s(Active["Y":"Y",Active["是":"Y",1:"N")
	
	For idxInLoc=1:1:$l(aLocId,"^"){
		Set xInLocID=$p(aLocId,"^",idxInLoc)
		Continue:xInLocID=""
		
		Set xID=0,tID=""
		For {
			Set xID=$o(^DHCPEST(0,"Code",$$ALPHAUP^SSUTIL4(Code),xID))
			Quit:xID=""
			Continue:##class(User.DHCPEStation).GetLocShowDataFlag(xID,xInLocID)'["Y"  //无显示权限退出
			Set tID=xID
		}
		Set:ID="" ID=tID
		Continue:(tID'="")&(ID'=tID)  //返回错误提示：名称不唯一
		
		If ID="" {
			Set obj=##class(User.DHCPEStation).%New()
		}Else{
			Set obj=##class(User.DHCPEStation).%OpenId(ID)
		}
		Continue:'$IsObject(obj)
		
		Set obj.STCode          = Code
		Set obj.STDesc          = Desc
		Set obj.STActive        = Active
		Set obj.STKBXCode       = KBXCode
		Set obj.STKBItemCatDesc = KBItemCatDesc
		Set obj.STUpdateDate    = +$h
		Set obj.STUpdateTime    = $p($h,",",2)
		
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
		Set flg=##class(User.DHCPEStation).SaveDataToPowerControl(obj.%Id(),xInLocID,"")
	}
	Quit return
}

/// Creator：    zhufei
/// CreatDate：  2022-01-19
/// Description: 导出站点分类数据（管控）
/// Table：      User.DHCPEStationLoc
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOPEStationSrv","QryStationLoc",152)
Query QryStationLoc(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,STCode:%String,STDesc:%String,STLocDesc:%String,STLocSort:%String,Active:%String,KBXCode:%String,KBItemCatDesc:%String")
{
}

ClassMethod QryStationLocExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Set xID=0
    For {
		Set xID=$o(^DHCPEST(xID))
		Quit:xID=""
		
		Set xSub=0
		For {
			Set xSub=$o(^DHCPEST(xID,"STLOC",xSub))
			Quit:xSub=""
			Continue:##class(User.DHCPEStationLoc).GetLocShowDataFlag(xID_"||"_xSub,aLocId)'["Y"  //无显示权限退出
			
			Set objSTL=##class(User.DHCPEStationLoc).GetObjById(xID_"||"_xSub)
			Continue:'$IsObject(objSTL)
			Continue:'$IsObject(objSTL.STLParRef)
			
			Continue:objSTL.STLParRef.STActive'="Y"  //无效数据过滤
			Set STCode = objSTL.STLParRef.STCode
			Set STDesc = objSTL.STLParRef.STDesc
			
			Continue:objSTL.STLNoActive="N"  //无效数据过滤
			Set STLocDesc=objSTL.STLLocDesc
			Set STLocSort=objSTL.STLLocSort
			Set KBXCode=objSTL.STLKBXCode
			Set KBItemCatDesc=objSTL.STLKBItemCatDesc
			Set Active=objSTL.STLNoActive
			Set:Active="" Active="Y"
			
			Set Data=$lb(xID_"||"_xSub,STCode,STDesc,STLocDesc,STLocSort,Active,KBXCode,KBItemCatDesc)
			Set ^CacheTemp(repid,ind)=Data
    		Set ind=ind+1
		}
	}
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-19
/// Description:  导入站点分类字典（管控）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOPEStationSrv).SaveStationLoc()
ClassMethod SaveStationLoc(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
    Set aLocId=..#InLocID
    Quit:aLocId="" "-100" //目标科室未设置
    
	Set:$g(aDelimiter)="" aDelimiter="^"
	Set ID            = $p(aInputStr,aDelimiter,1)    //ID
	Set STCode        = $p(aInputStr,aDelimiter,2)    //站点代码
	Set STDesc        = $p(aInputStr,aDelimiter,3)    //站点名称
	Set STLDesc       = $p(aInputStr,aDelimiter,4)    //站点分类
	Set Sort          = $p(aInputStr,aDelimiter,5)    //顺序号
	Set Active        = $p(aInputStr,aDelimiter,6)    //是否有效
	Set KBXCode       = $p(aInputStr,aDelimiter,7)    //知识库外部码
	Set KBItemCatDesc = $p(aInputStr,aDelimiter,8)    //知识库站点名称
	Quit:(STCode="")||(STLDesc="") return
	
	Set STID=$o(^DHCPEST(0,"Code",$$ALPHAUP^SSUTIL4(STCode),0))
	Quit:STID="" return
	
	Set Active=$s(Active["Y":"Y",Active["是":"Y",1:"N")
	
	For idxInLoc=1:1:$l(aLocId,"^"){
		Set xInLocID=$p(aLocId,"^",idxInLoc)
		Continue:xInLocID=""
		
		Set xID=0,tSub=""
		For {
			Set xID=$o(^DHCPEST(0,"STL","Desc",$$ALPHAUP^SSUTIL4(STLDesc),STID,xID))
			Quit:xID=""
			Continue:##class(User.DHCPEStationLoc).GetLocShowDataFlag(xID,xInLocID)'["Y"  //无显示权限退出
			Set tSub=xID
		}
		If tSub="" {
			&SQL(insert into Sqluser.DHC_PE_StationLoc (STL_ParRef,STL_LocDesc,STL_LocSort) values (:STID,:STLDesc,:Sort))
			Continue:SQLCODE'=0 //插入数据错误
			Set ID=%ROWID
		} Else {
			Set tID=STID_"||"_tSub
			Set:(ID="") ID=tID
			Continue:(tID'="")&(ID'=tID)  //返回错误提示：名称不唯一
		}
		
		Set obj=##class(User.DHCPEStationLoc).%OpenId(ID)
		Continue:'$IsObject(obj)
		
		Set obj.STLLocDesc           = STLDesc
		Set obj.STLLocSort           = Sort
		Set obj.STLNoActive          = Active
		Set obj.STLKBXCode           = KBXCode
		Set obj.STLKBItemCatDesc     = KBItemCatDesc
		Set obj.STLUpdateDate        = +$h
		Set obj.STLUpdateTime        = $p($h,",",2)
		
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
		Set flg=##class(User.DHCPEStationLoc).SaveDataToPowerControl(obj.%Id(),xInLocID,"")
	}
	Quit return
}

/// Creator：    zhufei
/// CreatDate：  2022-01-19
/// Description: 导出科室站点详情（私有）
/// Table：      User.DHCPEStationSet
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOPEStationSrv","QryStationSet",152)
Query QryStationSet(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,STCode:%String,STDesc:%String,Active:%String,Sequence:%String,ReportSequence:%String,AllResultShow:%String,AutoAudit:%String,LayoutType:%String,LayoutTypeDesc:%String,ButtonType:%String,ButtonTypeDesc:%String,Place:%String,SingleQueue:%String")
{
}

ClassMethod QryStationSetExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Set xSTID=0
    For {
		Set xSTID=$o(^CF.PE.StationSetI("IdxOfLocStation"," "_aLocId,xSTID))
		Quit:xSTID=""
		
		Set xID=0
		For {
			Set xID=$o(^CF.PE.StationSetI("IdxOfLocStation"," "_aLocId,xSTID,xID))
			Quit:xID=""
			Continue:##class(User.DHCPEStationSet).GetLocShowDataFlag(xID,aLocId)'["Y"  //无显示权限退出
			
			Set objSTS=##class(User.DHCPEStationSet).GetObjById(xID)
			Continue:'$IsObject(objSTS)
			Continue:'$IsObject(objSTS.SSStationDR)
			
			Continue:objSTS.SSStationDR.STActive'="Y"  //无效数据过滤
			Set STCode = objSTS.SSStationDR.STCode
			Set STDesc = objSTS.SSStationDR.STDesc
			
			Continue:objSTS.SSActive'="Y"  //无效数据过滤
			Set Active=objSTS.SSActive
			Set Sequence=objSTS.SSSequence
			Set ReportSequence=objSTS.SSReportSequence
			Set AllResultShow=objSTS.SSAllResultShow
			Set AutoAudit=objSTS.SSAutoAudit
			Set LayoutType=objSTS.SSLayoutType
			Set LayoutTypeDesc=$s(LayoutType=1:"简化",LayoutType=2:"详细",LayoutType=3:"普通化验",LayoutType=4:"接口化验",LayoutType=5:"普通检查",LayoutType=6:"接口检查",LayoutType=7:"其它",LayoutType=8:"药品",1:LayoutType)
			Set ButtonType=objSTS.SSButtonType
			Set ButtonTypeDesc=$s(ButtonType=1:"标准",ButtonType=2:"妇科",ButtonType=3:"超声",1:ButtonType)
			Set Place=objSTS.SSPlace
			Set SingleQueue=objSTS.SSSingleQueue
			
			Set Data=$lb(xID,STCode,STDesc,Active,Sequence,ReportSequence,AllResultShow,AutoAudit,LayoutType,LayoutTypeDesc,ButtonType,ButtonTypeDesc,Place,SingleQueue)
			Set ^CacheTemp(repid,ind)=Data
    		Set ind=ind+1
		}
	}
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-19
/// Description:  导入站点分类字典（私有）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOPEStationSrv).SaveStationSet()
ClassMethod SaveStationSet(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
    Set aLocId=..#InLocID
    Quit:aLocId="" "-100" //目标科室未设置
    
	Set:$g(aDelimiter)="" aDelimiter="^"
	Set ID            = $p(aInputStr,aDelimiter,1)     //ID
	Set STCode        = $p(aInputStr,aDelimiter,2)     //站点代码
	Set STDesc        = $p(aInputStr,aDelimiter,3)     //站点描述
	Set Active        = $p(aInputStr,aDelimiter,4)     //是否有效
	Set Sequence      = $p(aInputStr,aDelimiter,5)     //总检顺序
	Set ReportSequence= $p(aInputStr,aDelimiter,6)     //报告顺序
	Set AllResultShow = $p(aInputStr,aDelimiter,7)     //总检显示所有结果
	Set AutoAudit     = $p(aInputStr,aDelimiter,8)     //科室自动提交
	Set LayoutType    = $p(aInputStr,aDelimiter,9)     //界面类型
	Set LayoutTypeDesc= $p(aInputStr,aDelimiter,10)    //界面类型描述
	Set ButtonType    = $p(aInputStr,aDelimiter,11)    //按钮类型
	Set ButtonTypeDesc= $p(aInputStr,aDelimiter,12)    //按钮类型描述
	Set Place         = $p(aInputStr,aDelimiter,13)    //站点位置
	Set SingleQueue   = $p(aInputStr,aDelimiter,14)    //单独排队站点
	Set Remark        = $p(aInputStr,aDelimiter,15)    //备注
	Quit:(STCode="")||(STDesc="") return
	
	Set STID=$o(^DHCPEST(0,"Code",$$ALPHAUP^SSUTIL4(STCode),0))
	Quit:STID="" return
	Set Active=$s(Active["Y":"Y",Active["是":"Y",1:"N")
	
	For idxInLoc=1:1:$l(aLocId,"^"){
		Set xInLocID=$p(aLocId,"^",idxInLoc)
		Continue:xInLocID=""
		
		Set xID=0,tID=""
		For {
			Set xID=$o(^CF.PE.StationSetI("IdxOfLocStation"," "_xInLocID,STID,xID))
			Quit:xID=""
			Continue:##class(User.DHCPEStationSet).GetLocShowDataFlag(xID,xInLocID)'["Y"  //无显示权限退出
			Set tID=xID
		}
		Set:ID="" ID=tID
		Continue:(tID'="")&(ID'=tID) //返回错误提示：名称不唯一
		
		If ID="" {
			Set obj=##class(User.DHCPEStationSet).%New()
		}Else{
			Set obj=##class(User.DHCPEStationSet).%OpenId(ID)
		}
		Continue:'$IsObject(obj)
		
		Set obj.SSStationDR          = ##class(User.DHCPEStation).GetObjById(STID)
		Set obj.SSLocDR              = xInLocID
		Set obj.SSPlace              = Place
		Set obj.SSSequence           = Sequence
		Set obj.SSAutoAudit          = AutoAudit
		Set obj.SSLayoutType         = LayoutType
		Set obj.SSButtonType         = ButtonType
		Set obj.SSReportSequence     = ReportSequence
		Set obj.SSAllResultShow      = AllResultShow
		Set obj.SSActive             = Active
		Set obj.SSSingleQueue        = SingleQueue
		Set obj.SSUpdateDate         = +$h
		Set obj.SSUpdateTime         = $p($h,",",2)
		
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
		Set flg=##class(User.DHCPEStationSet).SaveDataToPowerControl(obj.%Id(),xInLocID,"")
	}
	Quit return
}

}
