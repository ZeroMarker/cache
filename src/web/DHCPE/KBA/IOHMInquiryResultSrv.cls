/// 名称: web.DHCPE.KBA.IOHMInquiryResultSrv
/// 描述: 导出导入体检问诊知识库
/// 编写者：zhufei
/// 编写日期: 2022-01-22
Class web.DHCPE.KBA.IOHMInquiryResultSrv Extends web.DHCPE.KBA.IOBaseSetting [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：    zhufei
/// CreatDate：  2022-01-22
/// Description: 导出体检问诊知识库（公有）
/// Table：      User.DHCHMInquiryType
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOHMInquiryResultSrv","QryInquiryType",152)
Query QryInquiryType(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,Sort:%String,Active:%String")
{
}

ClassMethod QryInquiryTypeExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Set xCode=""
	For {
		Set xCode=$o(^User.DHCHMInquiryTypeI("CodeIndex",xCode))
		Quit:xCode=""
		
		Set xID=0
		For {
			Set xID=$o(^User.DHCHMInquiryTypeI("CodeIndex",xCode,xID))
			Quit:xID=""
			Continue:##class(User.DHCHMInquiryType).GetLocShowDataFlag(xID,aLocId)'["Y"  //无显示权限退出
			
			Set obj=##class(User.DHCHMInquiryType).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:obj.ITNoActive="N"  //无效数据过滤
			Set Code        = obj.ITCode
			Set Desc        = obj.ITDesc
			Set Sort        = obj.ITSort
			Set Active      = obj.ITNoActive
			Set:Active="" Active="Y"
			
			Set Data=$lb(xID,Code,Desc,Sort,Active)
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
    }
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-22
/// Description:  导入体检问诊知识库（公有）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOHMInquiryResultSrv).SaveInquiryType()
ClassMethod SaveInquiryType(aInputStr As %String, aDelimiter As %String = "^") As %String
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
	Quit:(Code="")||(Desc="") return
	
	Set Active=$s(Active["Y":"Y",Active["是":"Y",1:"N")
	
	For idxInLoc=1:1:$l(aLocId,"^"){
		Set xInLocID=$p(aLocId,"^",idxInLoc)
		Continue:xInLocID=""
		
		Set xID=0,tID=""
		For {
			Set xID=$o(^User.DHCHMInquiryTypeI("CodeIndex"," "_$zcvt(Code,"U"),xID))
			Quit:xID=""
			Continue:##class(User.DHCHMInquiryType).GetLocShowDataFlag(xID,xInLocID)'["Y"  //无显示权限退出
			Set tID=xID
		}
		Set:ID="" ID=tID
		Continue:(tID'="")&(ID'=tID) //返回错误提示：名称不唯一
		
		If ID="" {
			Set obj=##class(User.DHCHMInquiryType).%New()
		}Else{
			Set obj=##class(User.DHCHMInquiryType).%OpenId(ID)
		}
		Continue:'$IsObject(obj)
		
		Set obj.ITCode          = Code
		Set obj.ITDesc          = Desc
		Set obj.ITSort          = Sort
		Set obj.ITNoActive      = Active
		Set obj.ITUpdateDate    = +$h
		Set obj.ITUpdateTime    = $p($h,",",2)
		
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
		Set flg=##class(User.DHCHMInquiryType).SaveDataToPowerControl(obj.%Id(),xInLocID,"")
	}
	Quit return
}

/// Creator：    zhufei
/// CreatDate：  2022-01-22
/// Description: 导出体检问诊知识库（公有）
/// Table：      User.DHCHMInquiryResult
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOHMInquiryResultSrv","QryInquiryResult",152)
Query QryInquiryResult(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,ITCode:%String,ITDesc:%String,Code:%String,Desc:%String,Sort:%String,ClassName:%String,MethodName:%String,Active:%String,IRDIntroduce:%String,IRDAdvice:%String,IRDRemark:%String")
{
}

ClassMethod QryInquiryResultExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Set xTypeID=0
    For {
		Set xTypeID=$o(^User.DHCHMInquiryResultI("CodeIndex",xTypeID))
		Quit:xTypeID=""
		
		Set xCode=""
		For {
			Set xCode=$o(^User.DHCHMInquiryResultI("CodeIndex",xTypeID,xCode))
			Quit:xCode=""
			
			Set xID=0
			For {
				Set xID=$o(^User.DHCHMInquiryResultI("CodeIndex",xTypeID,xCode,xID))
				Quit:xID=""
				Continue:##class(User.DHCHMInquiryResult).GetLocShowDataFlag(xTypeID_"||"_xID,aLocId)'["Y"  //无显示权限退出
				
				Set IRID=xTypeID_"||"_xID
				Set obj=##class(User.DHCHMInquiryResult).GetObjById(IRID)
				Continue:'$IsObject(obj)
				Continue:obj.IRNoActive="N"  //无效数据过滤
				Set ITCode      =obj.IRParRef.ITCode
				Set ITDesc      =obj.IRParRef.ITDesc
				Set Code        = obj.IRCode
				Set Desc        = obj.IRDesc
				Set Sort        = obj.IRSort
				Set ClassName   = obj.IRClassName
				Set MethodName  = obj.IRMethodName
				Set Active      = obj.IRNoActive
				Set:Active="" Active="Y"
				
				Set (IRDIntroduce,IRDAdvice,IRDRemark)=""
				Set Child=$o(^User.DHCHMInquiryTypeD(+IRID,"ITResult",+$p(IRID,"||",2),"IRDetail",0))
				If Child'="" {
					Set objDtl=##class(User.DHCHMInquiryResultDetail).GetObjById(IRID_"||"_Child)
					If $IsObject(objDtl){
						Set IRDIntroduce = objDtl.IRDIntroduce    //基本介绍
						Set IRDAdvice = ""                        //健康建议
						Set stream = objDtl.IRDAdvice
					    Do stream.Rewind()
						While 'stream.AtEnd {
							Set IRDAdvice = IRDAdvice_stream.ReadLine(,.sc,.eol)
							If $$$ISERR(sc) { Write "ERROR" Quit }
						}
						Do stream.%Close()
						Set IRDRemark = objDtl.IRDRemark  //备注
					}
				}
				Set Data=$lb(xTypeID_"||"_xID,ITCode,ITDesc,Code,Desc,Sort,ClassName,MethodName,Active,IRDIntroduce,IRDAdvice,IRDRemark)
				Set ^CacheTemp(repid,ind)=Data
		    	Set ind=ind+1
			}
	    }
	}
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-22
/// Description:  导入体检问诊知识库（公有）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOHMInquiryResultSrv).SaveInquiryResult()
ClassMethod SaveInquiryResult(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
    Set aLocId=..#InLocID
    Quit:aLocId="" "-100" //目标科室未设置
    
	Set:$g(aDelimiter)="" aDelimiter=..#Delimiter
	Set ID            = $p(aInputStr,aDelimiter,1)    //ID
	Set ITCode        = $p(aInputStr,aDelimiter,2)    //问诊类型代码
	Set ITDesc        = $p(aInputStr,aDelimiter,3)    //问诊类型描述
	Set IRCode        = $p(aInputStr,aDelimiter,4)    //代码
	Set IRDesc        = $p(aInputStr,aDelimiter,5)    //描述
	Set IRSort        = $p(aInputStr,aDelimiter,6)    //顺序号
	Set ClassName     = $p(aInputStr,aDelimiter,7)    //类名
	Set MethodName    = $p(aInputStr,aDelimiter,8)    //方法名
	Set IRActive      = $p(aInputStr,aDelimiter,9)    //激活
	Set IRDIntroduce  = $p(aInputStr,aDelimiter,10)    //基本介绍
	Set IRDAdvice     = $p(aInputStr,aDelimiter,11)    //健康建议
	Set IRDRemark     = $p(aInputStr,aDelimiter,12)    //备注
	Quit:(ITCode="")||(ITDesc="")||(IRCode="")||(IRDesc="")||(IRDIntroduce="") return
	
	Set ITID=$o(^User.DHCHMInquiryTypeI("CodeIndex"," "_$zcvt(ITCode,"U"),0))
	Quit:ITID="" return
	Set IRActive=$s(IRActive["Y":"Y",IRActive["是":"Y",1:"N")
	
	Set Sub=$o(^User.DHCHMInquiryResultI("CodeIndex",ITID," "_$zcvt(IRCode,"U"),0))
	If Sub="" {
		Set obj=##class(User.DHCHMInquiryResult).%New()
	} Else {
		Set obj=##class(User.DHCHMInquiryResult).%OpenId(ITID_"||"_Sub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.IRParRef        = ##class(User.DHCHMInquiryType).GetObjById(ITID)
	Set obj.IRCode          = IRCode         //代码
	Set obj.IRDesc          = IRDesc         //描述
	Set obj.IRSort          = IRSort         //序号
	Set obj.IRClassName     = ClassName      //类名
	Set obj.IRMethodName    = MethodName     //方法名
	Set obj.IRNoActive      = IRActive       //作废标记
	Set obj.IRUpdateDate    = +$h            //更新日期
	Set obj.IRUpdateTime    = $p($h,",",2)   //更新时间
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set IRID=obj.%Id()
		Set return=IRID
	}
	Do obj.%Close()
	Quit:(+return)<0 return
	
	Set objStream=##class(%GlobalCharacterStream).%New()
    Do objStream.Rewind()
	Do objStream.Write(IRDAdvice)
	Do objStream.%Close()
	
	Set Child=$o(^User.DHCHMInquiryTypeD(+ITID,"ITResult",+$p(IRID,"||",2),"IRDetail",0))
	If Child="" {
		Set obj=##class(User.DHCHMInquiryResultDetail).%New()
	} Else {
		Set obj=##class(User.DHCHMInquiryResultDetail).%OpenId(IRID_"||"_Child)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.IRDParRef       = ##class(User.DHCHMInquiryResult).GetObjById(IRID)
	Set obj.IRDIntroduce    = IRDIntroduce    //介绍
	Set obj.IRDAdvice       = objStream       //健康建议
	Set obj.IRDRemark       = IRDRemark       //备注
	Set obj.IRDNoActive     = IRActive        //作废标记
	Set obj.IRDUpdateDate   = +$h             //更新日期
	Set obj.IRDUpdateTime   = $p($h,",",2)    //更新时间
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set IRDID=obj.%Id()
		Set return=IRDID
	}
	Do obj.%Close()
	Quit return
}

}
