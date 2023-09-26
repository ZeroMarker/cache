/// 名称: web.DHCPE.KBA.IOPEIllnessStandardSrv
/// 描述: 导出导入疾病字典
/// 编写者：zhufei
/// 编写日期: 2022-01-22
Class web.DHCPE.KBA.IOPEIllnessStandardSrv Extends web.DHCPE.KBA.IOBaseSetting [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：    zhufei
/// CreatDate：  2022-01-22
/// Description: 导出疾病（私有）
/// Table：      User.DHCPEIllnessStandard
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOPEIllnessStandardSrv","QryIllnessStandard",152)
Query QryIllnessStandard(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,Detail:%String,Illness:%String,CommonIllness:%String,ToReport:%String,Sex:%String,Type:%String,TypeDesc:%String,Active:%String,KBXCode:%String")
{
}

ClassMethod QryIllnessStandardExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Set xCode=""
	For {
		Set xCode=$o(^DHCPEILLS(0,"Code",xCode))
		Quit:xCode=""
		
		Set xID=0
		For {
			Set xID=$o(^DHCPEILLS(0,"Code",xCode,xID))
			Quit:xID=""
			Continue:##class(User.DHCPEIllnessStandard).GetLocShowDataFlag(xID,aLocId)'["Y"  //无显示权限退出
			
			Set obj=##class(User.DHCPEIllnessStandard).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:obj.ILLSNoActive="N"  //无效数据过滤
			Set Code          = obj.ILLSCode
			Set Desc          = obj.ILLSDesc
			Set Detail        = obj.ILLSDetail
			Set Illness       = obj.ILLSIllness
			Set CommonIllness = obj.ILLSCommonIllness
			Set ToReport      = obj.ILLSToReport
			Set Sex           = obj.ILLSSex
			Set Type          = obj.ILLSType
			Set TypeDesc=$s(Type=1:"团体分析疾病对照使用",Type=2:"妇科疾病对照使用",Type=3:"阳性统计",1:Type)
			Set Active        = obj.ILLSNoActive
			Set KBXCode       = obj.ILLSKBXCode
			Set:Active="" Active="Y"
			
			Set Data=$lb(xID,Code,Desc,Detail,Illness,CommonIllness,ToReport,Sex,Type,TypeDesc,Active,KBXCode)
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
    }
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-22
/// Description:  导入疾病（私有）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOPEIllnessStandardSrv).SaveIllnessStandard("^0050^前列腺超声：前列腺结石^前列腺结石的病因尚不十分明确，一般认为和前列腺液成分的改变，年龄老化和局部感染等因素有关。建议您去泌尿外科门诊复查或进一步检查。^N^N^0^M^3^阳性统计^Y^50")
ClassMethod SaveIllnessStandard(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
    Set aLocId=..#InLocID
    Quit:aLocId="" "-100" //目标科室未设置
    
	Set:$g(aDelimiter)="" aDelimiter=..#Delimiter
	Set ID                 = $p(aInputStr,aDelimiter,1)    //ID
	Set Code               = $p(aInputStr,aDelimiter,2)    //疾病代码
	Set Desc               = $p(aInputStr,aDelimiter,3)    //疾病
	Set Detail             = $p(aInputStr,aDelimiter,4)    //疾病建议
	Set Illness            = $p(aInputStr,aDelimiter,5)    //是否疾病
	Set CommonIllness      = $p(aInputStr,aDelimiter,6)    //是否常见病
	Set ToReport           = $p(aInputStr,aDelimiter,7)    //是否上报
	Set Sex                = $p(aInputStr,aDelimiter,8)    //性别
	Set Type               = $p(aInputStr,aDelimiter,9)    //类型
	Set TypeDesc           = $p(aInputStr,aDelimiter,10)    //类型描述
	Set Active             = $p(aInputStr,aDelimiter,11)    //激活
	Set KBXCode            = $p(aInputStr,aDelimiter,12)    //知识库代码
	Quit:(Code="")||(Desc="") return
	
	Set Active=$s(Active["Y":"Y",Active["是":"Y",1:"N")
	
	For idxInLoc=1:1:$l(aLocId,"^"){
		Set xInLocID=$p(aLocId,"^",idxInLoc)
		Continue:xInLocID=""
		
		Set xID=0,tID=""
		For {
			Set xID=$o(^DHCPEILLS(0,"Code",Code,xID))
			Quit:xID=""
			Continue:##class(User.DHCPEIllnessStandard).GetLocShowDataFlag(xID,xInLocID)'["Y"  //无显示权限退出
			Set tID=xID
		}
		Set:ID="" ID=tID
		Continue:(tID'="")&(ID'=tID) //返回错误提示：名称不唯一
		
		If ID="" {
			Set obj=##class(User.DHCPEIllnessStandard).%New()
		}Else{
			Set obj=##class(User.DHCPEIllnessStandard).%OpenId(ID)
		}
		Continue:'$IsObject(obj)
		
		Set obj.ILLSCode               = Code            //疾病代码
		Set obj.ILLSDesc               = Desc            //疾病
		Set obj.ILLSDetail             = Detail          //疾病建议
		Set obj.ILLSIllness            = Illness         //是否疾病
		Set obj.ILLSCommonIllness      = CommonIllness   //是否常见病
		Set obj.ILLSToReport           = ToReport        //是否上报
		Set obj.ILLSSex                = Sex             //性别
		Set obj.ILLSType               = Type            //类型
		Set obj.ILLSNoActive           = Active          //激活
		Set obj.ILLSKBXCode            = KBXCode         //知识库代码
		Set obj.ILLSUpdateDate         = +$h
		Set obj.ILLSTimeUpdate         = $p($h,",",2)
		
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
		Set flg=##class(User.DHCPEIllnessStandard).SaveDataToPowerControl(obj.%Id(),xInLocID,"")
	}
	Quit return
}

/// Creator：    zhufei
/// CreatDate：  2022-01-22
/// Description: 导出疾病别名（私有）
/// Table：      User.DHCPEILLSAlias
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOPEIllnessStandardSrv","QryILLSAlias",152)
Query QryILLSAlias(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,ILLSCode:%String,ILLSDesc:%String,Text:%String")
{
}

ClassMethod QryILLSAliasExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Set xILLSID=""
	For {
		Set xILLSID=$o(^DHCPEILLSA(0,"ILLSDRText",xILLSID))
		Quit:xILLSID=""
		Continue:##class(User.DHCPEIllnessStandard).GetLocShowDataFlag(xILLSID,aLocId)'["Y"  //无显示权限退出
		
		Set xText=""
		For {
			Set xText=$o(^DHCPEILLSA(0,"ILLSDRText",xILLSID,xText))
			Quit:xText=""
			w xText,!
			Set xID=0
			For {
				Set xID=$o(^DHCPEILLSA(0,"ILLSDRText",xILLSID,xText,xID))
				Quit:xID=""
				Continue:##class(User.DHCPEILLSAlias).GetLocShowDataFlag(xID,aLocId)'["Y"  //无显示权限退出
				
				Set obj=##class(User.DHCPEILLSAlias).GetObjById(xID)
				Continue:'$IsObject(obj)
				Set (ILLSCode,ILLSDesc)=""
				If $IsObject(obj.ILLSAILLSDR){
					Set ILLSCode=obj.ILLSAILLSDR.ILLSCode
					Set ILLSDesc=obj.ILLSAILLSDR.ILLSDesc
				}
				Set Text = obj.ILLSAText
				
				Set Data=$lb(xID,ILLSCode,ILLSDesc,Text)
				Set ^CacheTemp(repid,ind)=Data
		    	Set ind=ind+1
			}
		}
    }
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-22
/// Description:  导入疾病别名（私有）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOPEIllnessStandardSrv).SaveILLSAlias()
ClassMethod SaveILLSAlias(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
    Set aLocId=..#InLocID
    Quit:aLocId="" "-100" //目标科室未设置
    
	Set:$g(aDelimiter)="" aDelimiter=..#Delimiter
	Set ID                = $p(aInputStr,aDelimiter,1)    //ID
	Set ILLSCode          = $p(aInputStr,aDelimiter,2)    //疾病代码
	Set ILLSDesc          = $p(aInputStr,aDelimiter,3)    //疾病
	Set Text              = $p(aInputStr,aDelimiter,4)    //别名
	Quit:(ILLSCode="")||(Text="") return
	
	For idxInLoc=1:1:$l(aLocId,"^"){
		Set xInLocID=$p(aLocId,"^",idxInLoc)
		Continue:xInLocID=""
		
		Set xILLSID=0,tILLSID=""
		For {
			Set xILLSID=$o(^DHCPEILLS(0,"Code",ILLSCode,xILLSID))
			Quit:xILLSID=""
			Continue:##class(User.DHCPEIllnessStandard).GetLocShowDataFlag(xILLSID,xInLocID)'["Y"  //无显示权限退出
			Set tILLSID=xILLSID
		}
		Continue:tILLSID=""
		
		Set xID=0,tID=""
		For {
			Set xID=$o(^DHCPEILLSA(0,"ILLSDRText",tILLSID,$$ALPHAUP^SSUTIL4(Text),xID))
			Quit:xID=""
			Continue:##class(User.DHCPEILLSAlias).GetLocShowDataFlag(xID,xInLocID)'["Y"  //无显示权限退出
			Set tID=xID
		}
		Set:ID="" ID=tID
		Continue:(tID'="")&(ID'=tID) //返回错误提示：名称不唯一
		
		If ID="" {
			Set obj=##class(User.DHCPEILLSAlias).%New()
		}Else{
			Set obj=##class(User.DHCPEILLSAlias).%OpenId(ID)
		}
		Continue:'$IsObject(obj)
		
		Set obj.ILLSAILLSDR = ##class(User.DHCPEIllnessStandard).GetObjById(tILLSID)
		Set obj.ILLSAText   = Text
		
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
		Set flg=##class(User.DHCPEILLSAlias).SaveDataToPowerControl(obj.%Id(),xInLocID,"")
	}
	Quit return
}

/// Creator：    zhufei
/// CreatDate：  2022-01-22
/// Description: 导出疾病建议对照（私有）
/// Table：      User.DHCPEIDRelate
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOPEIllnessStandardSrv","QryIDRelate",152)
Query QryIDRelate(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,ILLSCode:%String,ILLSDesc:%String,EDCode:%String,EDDesc:%String,Active:%String")
{
}

ClassMethod QryIDRelateExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Set xILLSID=""
	For {
		Set xILLSID=$o(^DHCPEIDR(0,"ILLSDR",xILLSID))
		Quit:xILLSID=""
		Continue:##class(User.DHCPEIllnessStandard).GetLocShowDataFlag(xILLSID,aLocId)'["Y"  //无显示权限退出
		
		Set xID=0
		For {
			Set xID=$o(^DHCPEIDR(0,"ILLSDR",xILLSID,xID))
			Quit:xID=""
			Continue:##class(User.DHCPEIDRelate).GetLocShowDataFlag(xID,aLocId)'["Y"  //无显示权限退出
			
			Set obj=##class(User.DHCPEIDRelate).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:obj.IDRNoActive="N"
			Set (ILLSCode,ILLSDesc)=""
			If $IsObject(obj.IDRILLSDR){
				Set ILLSCode=obj.IDRILLSDR.ILLSCode
				Set ILLSDesc=obj.IDRILLSDR.ILLSDesc
			}
			Set (EDCode,EDDesc)=""
			If $IsObject(obj.IDREDDR){
				Set EDCode=obj.IDREDDR.EDCode
				Set EDDesc=obj.IDREDDR.EDDiagnoseConclusion
			}
			Set Active=obj.IDRNoActive
			Set:Active="" Active="Y"
			
			Set Data=$lb(xID,ILLSCode,ILLSDesc,EDCode,EDDesc,Active)
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
    }
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-22
/// Description:  导入疾病建议对照（私有）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOPEIllnessStandardSrv).SaveIDRelate("^0002^糖尿病^000007^糖尿病^Y")
ClassMethod SaveIDRelate(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
    Set aLocId=..#InLocID
    Quit:aLocId="" "-100" //目标科室未设置
    
	Set:$g(aDelimiter)="" aDelimiter=..#Delimiter
	Set ID                = $p(aInputStr,aDelimiter,1)    //ID
	Set ILLSCode          = $p(aInputStr,aDelimiter,2)    //疾病代码
	Set ILLSDesc          = $p(aInputStr,aDelimiter,3)    //疾病
	Set EDCode            = $p(aInputStr,aDelimiter,4)    //建议代码
	Set EDDesc            = $p(aInputStr,aDelimiter,5)    //专家建议
	Set Active            = $p(aInputStr,aDelimiter,6)    //激活
	Quit:(ILLSCode="")||(EDCode="") return
	
	Set Active=$s(Active["Y":"Y",Active["是":"Y",1:"N")
	
	For idxInLoc=1:1:$l(aLocId,"^"){
		Set xInLocID=$p(aLocId,"^",idxInLoc)
		Continue:xInLocID=""
		
		Set xILLSID=0,tILLSID=""
		For {
			Set xILLSID=$o(^DHCPEILLS(0,"Code",ILLSCode,xILLSID))
			Quit:xILLSID=""
			Continue:##class(User.DHCPEIllnessStandard).GetLocShowDataFlag(xILLSID,xInLocID)'["Y"  //无显示权限退出
			Set tILLSID=xILLSID
		}
		Continue:tILLSID=""
		
		Set xEDID=0,tEDID=""
		For {
			Set xEDID=$o(^DHCPEED(0,"CODE",EDCode,xEDID))
			Quit:xEDID=""
			Continue:##class(User.DHCPEExpertDiagnosis).GetLocShowDataFlag(xEDID,xInLocID)'["Y"  //无显示权限退出
			Set tEDID=xEDID
		}
		Continue:tEDID=""
		
		Set xID=0,tID=""
		For {
			Set xID=$o(^DHCPEIDR(0,"ILLSED",tILLSID,tEDID,xID))
			Quit:xID=""
			Continue:##class(User.DHCPEIDRelate).GetLocShowDataFlag(xID,xInLocID)'["Y"  //无显示权限退出
			Set tID=xID
		}
		Set:ID="" ID=tID
		Continue:(tID'="")&(ID'=tID) //返回错误提示：名称不唯一
		
		If ID="" {
			Set obj=##class(User.DHCPEIDRelate).%New()
		}Else{
			Set obj=##class(User.DHCPEIDRelate).%OpenId(ID)
		}
		Continue:'$IsObject(obj)
		
		Set obj.IDRILLSDR = ##class(User.DHCPEIllnessStandard).GetObjById(tILLSID)
		Set obj.IDREDDR   = ##class(User.DHCPEExpertDiagnosis).GetObjById(tEDID)
		
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
		Set flg=##class(User.DHCPEIDRelate).SaveDataToPowerControl(obj.%Id(),xInLocID,"")
	}
	Quit return
}

}
