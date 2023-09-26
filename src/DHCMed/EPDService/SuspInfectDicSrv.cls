/// 名称：DHCMed.EPDService.SuspInfectDicSrv
/// 描述：传染病疑似诊断服务
Class DHCMed.EPDService.SuspInfectDicSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2019-01-23
/// Description:  查询传染病疑似诊断
/// Table：       DHCMed.EPD.SuspInfectDic
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.SuspInfectDicSrv","QryInfectDic","")
Query QryInfectDic(aIsActive As %String = "") As %Query(ROWSPEC = "ID:%String,BTCode:%String,BTDesc:%String,InfectID:%String,Infection:%String,KindID:%String,BTKind:%String,BTIndNo:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUser:%String,KindCode:%String") [ SqlProc ]
{
}

ClassMethod QryInfectDicExecute(ByRef qHandle As %Binary, aIsActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID = ""
	For {
		Set xID = $o(^DHCMed.EPD.SuspInfectDicD(xID))
		Quit:xID=""
		
		Set objDic = ##class(DHCMed.EPD.SuspInfectDic).GetObjById(xID)
		Continue:'$Isobject(objDic)
		Set IsActive = objDic.BTIsActive
		Continue:(aIsActive'="")&&(aIsActive'=IsActive)
		Set IsActDesc=$s(IsActive=1:"是",1:"否")
		Set Code     = objDic.BTCode
		Set Desc     = objDic.BTDesc
		Set (InfectID,Infection)=""
	    If $Isobject(objDic.BTInfectDr){
		    Set InfectID = objDic.BTInfectDr.%Id()
		    Set Infection = objDic.BTInfectDr.MIFDisease
	    }  
	    Set (KindID,KindCode,Kind)=""
	    If $Isobject(objDic.BTKindDr){
		    Set KindID = objDic.BTKindDr.%Id()
		    Set KindCode=objDic.BTKindDr.Code
		    Set Kind = objDic.BTKindDr.Description
	    } 
		Set IndNo    = objDic.BTIndNo
		Set ActDate  = objDic.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ActDate)
		Set ActTime  = objDic.BTActTime
		Set:ActTime'="" ActTime=$zt(ActTime)
		Set ActUser  = objDic.BTActUser
				
		Set Data = $lb(xID,Code,Desc,InfectID,Infection,KindID,Kind,IndNo,IsActive,IsActDesc,ActDate,ActTime,ActUser,KindCode)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryInfectDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfectDicExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryInfectDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfectDicExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2019-01-23
/// Description:  根据代码查询传染病疑似诊断
/// Table：       DHCMed.EPD.SuspInfectDic
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.SuspInfectDicSrv","QryInfectByCode","")
Query QryInfectByCode(aCode As %String) As %Query(ROWSPEC = "ID:%String,BTCode:%String,BTDesc:%String,InfectID:%String,Infection:%String,KindID:%String,BTKind:%String,BTIndNo:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUser:%String") [ SqlProc ]
{
}

ClassMethod QryInfectByCodeExecute(ByRef qHandle As %Binary, aCode As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aCode="") $$$OK
	Set aCode=$ZCVT($g(aCode),"U")
	
	Set xID = ""
	For {
		Set xID = $o(^DHCMed.EPD.SuspInfectDicI("IdxofCode",aCode,xID))
		Quit:xID=""
	
		Set objDic = ##class(DHCMed.EPD.SuspInfectDic).GetObjById(xID)
		Continue:'$Isobject(objDic)
		Set Code     = objDic.BTCode
		Set Desc     = objDic.BTDesc
		
		Set (InfectID,Infection)=""
	    If $Isobject(objDic.BTInfectDr){
		    Set InfectID = objDic.BTInfectDr.%Id()
		    Set Infection = objDic.BTInfectDr.MIFDisease
	    }  
	    Set (KindID,Kind)=""
	    If $Isobject(objDic.BTKindDr){
		    Set KindID = objDic.BTKindDr.%Id()
		    Set Kind = objDic.BTKindDr.Description
	    } 
		Set IndNo    = objDic.BTIndNo
		Set IsActive = objDic.BTIsActive
		Set IsActDesc=$s(IsActive=1:"是",1:"否")
		
		Set ActDate  = objDic.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ActDate)
		Set ActTime  = objDic.BTActTime
		Set:ActTime'="" ActTime=$zt(ActTime)
		Set ActUser  = objDic.BTActUser
				
		Set Data = $lb(xID,Code,Desc,InfectID,Infection,KindID,Kind,IndNo,IsActive,IsActDesc,ActDate,ActTime,ActUser)

		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryInfectByCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfectByCodeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryInfectByCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfectByCodeExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     yukai
/// CreatDate：   2019-04-16
/// Description:  根据描述查询传染病疑似诊断
/// Table：       DHCMed.EPD.SuspInfectDic
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.SuspInfectDicSrv","QryInfectByDesc","")
Query QryInfectByDesc(aDesc As %String) As %Query(ROWSPEC = "ID:%String,BTCode:%String,BTDesc:%String,InfectID:%String,Infection:%String,KindID:%String,BTKind:%String,BTIndNo:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUser:%String") [ SqlProc ]
{
}

ClassMethod QryInfectByDescExecute(ByRef qHandle As %Binary, aDesc As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID = ""
	For {
		Set xID = $o(^DHCMed.EPD.SuspInfectDicD(xID))
		Quit:xID=""
		
		Set objDic = ##class(DHCMed.EPD.SuspInfectDic).GetObjById(xID)
		Continue:'$Isobject(objDic)
		Set IsActive = objDic.BTIsActive
		//Continue:(IsActive="0")
		Set IsActDesc=$s(IsActive=1:"是",1:"否")
		Set Code     = objDic.BTCode
		Set Desc     = objDic.BTDesc
		if aDesc'=""{
			Continue:Desc'[aDesc
			}
		Set (InfectID,Infection)=""
	    If $Isobject(objDic.BTInfectDr){
		    Set InfectID = objDic.BTInfectDr.%Id()
		    Set Infection = objDic.BTInfectDr.MIFDisease
	    }  
	    Set (KindID,Kind)=""
	    If $Isobject(objDic.BTKindDr){
		    Set KindID = objDic.BTKindDr.%Id()
		    Set Kind = objDic.BTKindDr.Description
	    } 
		Set IndNo    = objDic.BTIndNo
		Set ActDate  = objDic.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ActDate)
		Set ActTime  = objDic.BTActTime
		Set:ActTime'="" ActTime=$zt(ActTime)
		Set ActUser  = objDic.BTActUser
				
		Set Data = $lb(xID,Code,Desc,InfectID,Infection,KindID,Kind,IndNo,IsActive,IsActDesc,ActDate,ActTime,ActUser)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryInfectByDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfectByCodeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryInfectByDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfectByCodeExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2019-01-30
/// Description:  获取传染病疑似诊断树
/// Table：       DHCMed.EPD.SuspInfectDic
/// Input：       
/// w ##class(DHCMed.EPDService.SuspInfectDicSrv).GetInfectDicTree()
ClassMethod GetInfectDicTree() As %String
{
	Set return="[]"
	Set treeJson="["
	Set treeJson=treeJson_"{"
	Set treeJson=treeJson_"""id"":""DicTree"","
	Set treeJson=treeJson_"""text"":""疑似诊断"","
	Set treeJson=treeJson_"""state"":""open"","
	Set treeJson=treeJson_"""children"":["
	
	Kill ^TMP($zn,$j,"GetInfectDicTree")
	
	Set xID = ""
	For {
		Set xID = $o(^DHCMed.EPD.SuspInfectDicD(xID))
		Quit:xID=""
		
		Set objDic = ##class(DHCMed.EPD.SuspInfectDic).GetObjById(xID)
		Continue:'$Isobject(objDic)
		Set IsActive = objDic.BTIsActive
		Continue:IsActive'=1
		Set Code     = objDic.BTCode
		Set Desc     = objDic.BTDesc
		
	 	Set Kind=""
	    If $Isobject(objDic.BTKindDr){
		    Set Kind = objDic.BTKindDr.Code
		} 
	    Set InfectID="", Infect="",Rank=""
		If $IsObject(objDic.BTInfectDr)  {
			Set InfectID=objDic.BTInfectDr.%Id()
			Set Infect=objDic.BTInfectDr.MIFDisease
			Set Rank = $p($g(^DHCMed.EPDC("IF",InfectID)),"^",4)
		} Else {
			Set xInfDr="",KindDr=""
			For {
				Set xInfDr=$o(^DHCMed.EPDC("IF",xInfDr))
				Quit:xInfDr=""
				Set objInf=##Class(DHCMed.EPD.Infection).GetObjById(xInfDr)
				Continue:'$IsObject(objInf)
				Set KindDr=objInf.MIFKind
				Set Rank=objInf.MIFRank
				
				Quit:(KindDr=Kind)		
			}
		}
		Set:Rank=5 Rank=2  //乙类按甲类管理按乙类记	
		Set:Rank="" Rank=4  //无等级按其他记
		Set ^TMP($zn,$j,"GetInfectDicTree",Rank,xID)=$lb(xID,Code,Desc,Rank)	
	}
	
	Set TypeJson=""
	Set xRank = ""
	For {
		Set xRank = $o(^TMP($zn,$j,"GetInfectDicTree",xRank))
		Quit:xRank=""
		
		Set Rank=$s(xRank=1:"甲类传染病",xRank=2:"乙类传染病",xRank=3:"丙类传染病",xRank=6:"AFP病例",1:"其他监测病例")
		Set TypeJson=TypeJson_"{"
		Set TypeJson=TypeJson_"""id"":"""_xRank_""","
		Set TypeJson=TypeJson_"""text"":"""_Rank_""","
		Set TypeJson=TypeJson_"""state"":""closed"","   //默认不展开
		Set TypeJson=TypeJson_"""children"":["

		Set DicJson=""	
		Set xID = ""
		For {
			Set xID = $o(^TMP($zn,$j,"GetInfectDicTree",xRank,xID))
			Quit:xID=""
		
		    Set Code  = $lg(^TMP($zn,$j,"GetInfectDicTree",xRank,xID),2)
			Set Desc  = $lg(^TMP($zn,$j,"GetInfectDicTree",xRank,xID),3)
		    
			Set DicJson=DicJson_"{"
	 		Set DicJson=DicJson_"""id"":"""_xID_""","
	 		Set DicJson=DicJson_"""text"":"""_Desc_""","
	 		Set DicJson=DicJson_"""state"":""open"","       //默认展开
	 		Set DicJson=DicJson_"""checked"":""true"""	     //默认复选框选中
	 		Set DicJson=DicJson_"},"
		}
	 	Set:DicJson'="" DicJson=$e(DicJson,1,$l(DicJson)-1)	//去掉最后一个逗号
		Set TypeJson=TypeJson_DicJson_"]"
	
		Set TypeJson=TypeJson_"},"
	}
	Set:TypeJson'="" TypeJson=$e(TypeJson,1,$l(TypeJson)-1)	//去掉最后一个逗号
	Set treeJson=treeJson_TypeJson_"]"
	Set treeJson=treeJson_"}"
	Set treeJson=treeJson_"]"

	Kill ^TMP($zn,$j,"GetInfectDicTree")
	
 	Set return=treeJson
 	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-02-28
/// Description:  导入传染病疑似诊断
/// Table：       DHCMed.EPD.SuspInfectDic
/// Input：       诊断字符串,"^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.EPDService.SuspInfectDicSrv).ImportInfectDic("01^鼠疫^鼠疫^鼠疫^01^1","^")
ClassMethod ImportInfectDic(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate="^"
    
	Set Code     = $p(aInput,aSeparate,1)  //代码
	Set Desc     = $p(aInput,aSeparate,2)  //描述
	Set Infect   = $p(aInput,aSeparate,3)  //传染病诊断
	Set Kind     = $p(aInput,aSeparate,4)  //传染病类别
	Set IndNo    = $p(aInput,aSeparate,5)  //排序码
	Set IsActive = $p(aInput,aSeparate,6)  //是否有效
	Quit:(Code="")||(Desc="")||(Kind="") return
	
	Set Flg=0
	Set xInfDr="",InfDr=""
	For {
		Set xInfDr=$o(^DHCMed.EPDC("IF",xInfDr))
		Quit:xInfDr=""
		Continue:Flg=1
		Set objInf=##Class(DHCMed.EPD.Infection).GetObjById(xInfDr)
		Continue:'$IsObject(objInf)
		
		Set InfDr=objInf.%Id()
		Set Disease=objInf.MIFDisease
		Continue:(Infect'=Disease)
		Set Flg = 1
	
	}
    Set:Infect="" InfDr=""
    
	Set KindDr=""
	Set objDic = ##class(DHCMed.SSService.DictionarySrv).GetObjByTypeDesc("EPDEMICTYPE",Kind)
	Set:$Isobject(objDic) KindDr = objDic.%Id()
	Quit:KindDr="" return
	
	Set ID=$o(^DHCMed.EPD.SuspInfectDicI("IdxofDesc",Desc,0))

	if Desc'=Disease{
		set InfDr=""
		}
	Set InputStr=ID                             //ID
	Set InputStr=InputStr_aSeparate_Code        //代码
	Set InputStr=InputStr_aSeparate_Desc        //描述
	Set InputStr=InputStr_aSeparate_InfDr       //传染病诊断
	Set InputStr=InputStr_aSeparate_KindDr      //传染病类别
	Set InputStr=InputStr_aSeparate_IndNo       //排序码
	Set InputStr=InputStr_aSeparate_IsActive    //是否有效
	
	Set return=##Class(DHCMed.EPD.SuspInfectDic).Update(InputStr,aSeparate)
	Quit return
}

}
