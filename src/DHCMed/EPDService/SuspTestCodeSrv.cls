/// 名称：DHCMed.EPDService.SuspTestCodeSrv
/// 描述：传染病疑似检验项目服务
Class DHCMed.EPDService.SuspTestCodeSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2019-01-23
/// Description:  查询传染病疑似检验项目
/// Table：       DHCMed.EPD.SuspTestCode
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.SuspTestCodeSrv","QryTestCode")
Query QryTestCode() As %Query(ROWSPEC = "ID:%String,BTCode:%String,BTDesc:%String,BTNote:%String") [ SqlProc ]
{
}

ClassMethod QryTestCodeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID = ""
	For {
		Set xID = $o(^DHCMed.EPD.SuspTestCodeD(xID))
		Quit:xID=""
		
		Set objTest = ##class(DHCMed.EPD.SuspTestCode).GetObjById(xID)
		Continue:'$Isobject(objTest)
		Set Code     = objTest.BTCode
		Set Desc     = objTest.BTDesc
	    Set Note     = objTest.BTNote
		Set Data = $lb(xID,Code,Desc,Note)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryTestCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTestCodeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryTestCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTestCodeExecute ]
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
/// Description:  根据项目名称查询传染病疑似检验项目
/// Table：       DHCMed.EPD.SuspTestCode
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.SuspTestCodeSrv","QryTestCodeByDesc","")
Query QryTestCodeByDesc(aDesc As %String) As %Query(ROWSPEC = "ID:%String,BTCode:%String,BTDesc:%String,BTNote:%String") [ SqlProc ]
{
}

ClassMethod QryTestCodeByDescExecute(ByRef qHandle As %Binary, aDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID = ""
	For {
		Set xID = $o(^DHCMed.EPD.SuspTestCodeD(xID))
		Quit:xID=""
		
		Set objTest = ##class(DHCMed.EPD.SuspTestCode).GetObjById(xID)
		Continue:'$Isobject(objTest)
		Set Code     = objTest.BTCode
		Set Desc     = objTest.BTDesc
	    Set Note     = objTest.BTNote
	    if aDesc'=""{
			Continue:Desc'[aDesc
			}
		Set Data = $lb(xID,Code,Desc,Note)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryTestCodeByDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTestCodeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryTestCodeByDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTestCodeExecute ]
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
/// Description:  查询传染病疑似检验项目（外部码）
/// Table：       DHCMed.EPD.SuspTestCodeExt
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.SuspTestCodeSrv","QryTestCodeExt","1","")
Query QryTestCodeExt(aTestID As %String, aIsActive As %String = "") As %Query(ROWSPEC = "ID:%String,SubID:%String,TSDr:%String,TCCode:%String,TestSet:%String,TestCode:%String,TestDesc:%String,SpecCode:%String,SpecDesc:%String,ResultType:%String,ResultTypeDesc:%String,ResultUnit:%String,CompValueMax:%String,CompValueMin:%String,CompValues:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUser:%String,PatSex:%String,PatSexDesc:%String") [ SqlProc ]
{
}

ClassMethod QryTestCodeExtExecute(ByRef qHandle As %Binary, aTestID As %String, aIsActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
		
	Quit:aTestID="" $$$OK	
	Set xSubID = ""
	For {
		Set xSubID=$o(^DHCMed.EPD.SuspTestCodeD(aTestID,"EXT",xSubID))
		Quit:xSubID=""
		
		Set ID=aTestID_"||"_xSubID
	
		Set objExt = ##class(DHCMed.EPD.SuspTestCodeExt).GetObjById(ID)
		Continue:'$Isobject(objExt)
	
		Set IsActive      = objExt.IsActive    
		Continue:(aIsActive'="")&&(aIsActive'=IsActive)
		Set IsActDesc=$s(IsActive=1:"是",1:"否")  
		Set TestCode      = objExt.TestCode 
	    Set objTC=##class(DHCMA.Util.EP.TestCode).xGetByOID(TestCode) 
	    Continue:'$IsObject(objTC)
	    Set TCID = objTC.%Id()
	    Set TCCode = objTC.BTCode
		Set TSDr =""
		Set TSDr=$o(^DHCMA.Util.EPx.TestSetTCI("IdxOfTestCodeTS",TCID,TSDr)) 
		Set objTS=##class(DHCMA.Util.EPx.TestSet).GetObjById(TSDr)
		Continue:'$IsObject(objTS)
		Set TestSet= objTS.BTDesc
		
	    Set TestDesc      = objExt.TestDesc 
	    Set SpecCode      = objExt.SpecCode   
	    Set SpecDesc      = objExt.SpecDesc    
	    Set ResultType    = objExt.ResultType 
	    Set ResultTypeDesc=$s(ResultType="N":"数值",ResultType="L":"列表",ResultType="K":"关键词",1:"")  
	    Set ResultUnit    = objExt.ResultUnit  
	    Set CompValueMax  = objExt.CompValueMax
	    Set CompValueMin  = objExt.CompValueMin
	    Set CompValues    = objExt.CompValues  
	    Set IsActive      = objExt.IsActive    
	    Set ActDate       = objExt.ActDate 
	    Set:ActDate'="" ActDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ActDate)
	    Set ActTime       = objExt.ActTime  
	    Set:ActTime'="" ActTime=$zt(ActTime)   
	    Set ActUser       = objExt.ActUser  
	    Set PatSex       = objExt.PatSex  
	    Set objSex 		  = ##class(DHCMed.SS.Dictionary).GetByTypeCode("EPDPetSex",PatSex,"1")
	    Set PatSexDesc= ""
		Set:$IsObject(objSex) PatSexDesc = objSex.Description
	    
		Set Data = $lb(ID,xSubID,TSDr,TCCode,TestSet,TestCode,TestDesc,SpecCode,SpecDesc,ResultType,ResultTypeDesc,ResultUnit,CompValueMax,CompValueMin,CompValues,IsActive,IsActDesc,ActDate,ActTime,ActUser,PatSex,PatSexDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryTestCodeExtClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTestCodeExtExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryTestCodeExtFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTestCodeExtExecute ]
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
/// CreatDate：   2019-02-01
/// Description:  传染病关联检验医嘱
/// Table：       DHCMed.EPD.SuspTestCodeExt、DHCMA.Util.EPx.TestSet、DHCMA.Util.EPx.TestSetTC
/// Input：      
/// Return：      返回String
/// w ##class(DHCMed.EPDService.SuspTestCodeSrv).GetTestCode()
ClassMethod GetTestCode() As %String
{
	new 
	Set return=""
	Set TestCodeList=""
	
	Set xTestCode=""
	For {
		Set xTestCode = $o(^DHCMed.EPD.SuspTestCodeI("EXT","IdxofCode",xTestCode))
	    Quit:xTestCode=""
	    
		Set objTC=##class(DHCMA.Util.EP.TestCode).xGetByOID(xTestCode) 
   		Continue:'$IsObject(objTC)
   		Set TCID = objTC.%Id()
   		Set BTCode=objTC.BTCode
   		Set BTDesc=objTC.BTDesc
   		
    	Continue:((","_TestCodeList_",")[(","_BTCode_",")) //不重复
   		Set TestCodeList=TestCodeList_","_BTCode
	}	
	Set:TestCodeList'="" TestCodeList=$e(TestCodeList,2,$l(TestCodeList))

	Set return=TestCodeList
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-03-08
/// Description:  导入传染病疑似检验项目
/// Table：       DHCMed.EPD.SuspTestCode
/// Input：       检验项目字符串,"^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.EPDService.SuspTestCodeSrv).ImportTestCode("006^测试项目^说明","^")
ClassMethod ImportTestCode(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate="^"
	
	Set Code  = $p(aInput,aSeparate,1)  //项目代码
	Set Desc  = $p(aInput,aSeparate,2)  //项目名称
	Set Note  = $p(aInput,aSeparate,3)  //说明
	Quit:(Code="")||(Desc="") return
	
	Set ID=$o(^DHCMed.EPD.SuspTestCodeI("IdxofCode",Code,0))
	
	Set InputStr=ID                            
	Set InputStr=InputStr_aSeparate_Code        
	Set InputStr=InputStr_aSeparate_Desc       
	Set InputStr=InputStr_aSeparate_Note  
	
	Set return=##Class(DHCMed.EPD.SuspTestCode).Update(InputStr,aSeparate)
	Quit return
}

/// Creator：     xwj
/// CreatDate：   2019-03-27
/// Description:  查询检验医嘱
/// Table：       DHCMA.Util.EPx.TestSet
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.SuspTestCodeSrv","QryTestSetByAlias","","梅毒")
Query QryTestSetByAlias(aTCID As %String = "", aAlias As %String = "") As %Query(ROWSPEC = "ID:%String,BTCode:%String,BTDesc:%String,BTNote:%String") [ SqlProc ]
{
}

ClassMethod QryTestSetByAliasExecute(ByRef qHandle As %Binary, aTCID As %String = "", aAlias As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aAlias=$zcvt(aAlias,"U")
	
	Set xID=""
	For {
		Set xID = $o(^DHCMed.EPD.SuspTestCodeD(xID))
		Quit:xID=""
		
		If aTCID'="" {
			Continue:'$d(^DHCMed.EPD.SuspTestCodeI("IdxofCode",xID,aTCID))
		}
		
		Set objOrd = ##class(DHCMed.EPD.SuspTestCode).GetObjById(xID)
		Continue:'$Isobject(objOrd)
		
		//Set OID       = objOrd.OID
		Set Code      = objOrd.BTCode
		Set Desc      = objOrd.BTDesc
		Set Note      = objOrd.BTNote
		Continue:(aAlias'="")&&(($zcvt(Code,"U")'[aAlias)&&($zcvt(Desc,"U")'[aAlias))
 
		Set Data = $lb(xID,Code,Desc,Note)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryTestSetByAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTestSetByAliasExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryTestSetByAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTestSetByAliasExecute ]
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

}
