/// ClassName:    DHCMed.SPEService.PatTypeSub
/// Description:  特殊患者子分类 相关操作
/// Creator：     zhufei
/// CreatDate:    2014-07-24
Class DHCMed.SPEService.PatTypeSub Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhouruimeng
/// CreatDate：   2014-07-24
/// Description:  保存特殊患者类型
/// Table：       DHCMed.SPEPatTypeSub
/// Input：       
/// Return：      
/// d ##class(DHCMed.SPEService.PatTypeSub).SaveRec("2^2^002^test2^lol444^1^1^1^1^测试","^")
ClassMethod SaveRec(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Quit:aInput="" return
	
	Set $ZT="SaveRecErr"
	Set ParRowID  = $p(aInput,aSeparate,1)
	Quit:ParRowID="" return
	Set RowID     =$p(aInput,aSeparate,2)
	Set Code      =$p(aInput,aSeparate,3)
	Set Code      =$zcvt(Code,"U")
	Set $p(aInput,aSeparate,3)=Code
	Set Desc=$p(aInput,aSeparate,4)
	Quit:(Code="")||(Desc="") return
	Set return=-100
	Set xRowID=0,IsError=0
	For {
		Set xRowID=$o(^DHCMed.SPEDi("PatTp",0,"Sub","IndexCode"," "_Code,ParRowID,xRowID)) //如果Code不存在 就没有这条索引 xRowID="" 就跳出循环 IsError就不能等于1
		Quit:xRowID=""  
		Continue:(RowID'="")&&(RowID=xRowID)  //如果Code已存在且输入的RowID为空时【即直接输入已存在的Code点保存】，就不会进行下一次循环，程序向下执行，IsError就等于1，就会出现数据重复错误
		Set IsError=1                         //Quit是添加新数据，Continue是更新数据。什么时候会出现RowID!="" 但是RowID!=xRowID呢？
		                                      //客户端操作是不会出现的，所以RowID=xRowID这个条件是可以不要的
	}
	Quit:IsError=1 return   //-100 数据重复【没有选中Panel，输入的code重复会返回-100】
	//执行下面语句的条件是：RowID为空且Code不存在【添加】  或 RowID不为空Code存在【更新】
	Set return=##Class(DHCMed.SPE.PatTypeSub).Update(aInput,aSeparate)
	
	Quit return
	
SaveRecErr
	Quit "-999"
}

/// Creator：     zhouruimeng
/// CreatDate：   2014-07-25
/// Description:  查询特殊患者子分类
/// Table：       DHCMed.SPE.PatTypeSub
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.SPEService.PatTypeSub","QryPatTypeSub","2")
Query QryPatTypeSub(ParRef As %String) As %Query(ROWSPEC = "PTSID:%String,PTSCode:%String,PTSDesc:%String,PTSIcon:%String,PTSIsActiveDesc:%String,PTSAutoMarkDesc:%String,PTSAutoCheckDesc:%String,PTSAutoCloseDesc:%String,PTSResume:%String")
{
}

ClassMethod QryPatTypeSubExecute(ByRef qHandle As %Binary, ParRef As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:ParRef="" return
 	
	Set SubCode = ""
	Set SubRowID=""	
 	For
 	{
	 	Set SubCode=$o(^DHCMed.SPEDi("PatTp",0,"Sub","IndexCode",SubCode))
	 	Quit:SubCode=""
	 	For
	 	{	
	 		Set SubRowID=$o(^DHCMed.SPEDi("PatTp",0,"Sub","IndexCode",SubCode,ParRef,SubRowID))
	 		Quit:SubRowID=""
	 		Set RowID = ParRef_"||"_SubRowID
	 		Set SubObj = ##class(DHCMed.SPE.PatTypeSub).GetObjById(RowID)
	 		Set Code          = SubObj.PTSCode
	 		Set Desc          = SubObj.PTSDesc
	 		Set Icon          = SubObj.PTSIcon
	 		Set AutoMarkDesc  = $s(SubObj.PTSAutoMark=1:"是",1:"否")
	 		Set AutoCheckDesc = $s(SubObj.PTSAutoCheck=1:"是",1:"否")
	 		Set AutoCloseDesc = $s(SubObj.PTSAutoClose=1:"是",1:"否")
	 		Set IsActiveDesc  = $s(SubObj.PTSIsActive=1:"是",1:"否")
	 		Set Resume        = SubObj.PTSResume
	 		//Continue:SubObj.PTSIsActive'=1  //update by pylian 20150619 此方法用来显示所有状态的类型，显示有效状态的类型方法使用QryPatTypeSubActive
	 		
			Set Data=$lb(SubRowID,Code,Desc,Icon,IsActiveDesc,AutoMarkDesc,AutoCheckDesc,AutoCloseDesc,Resume)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	 	}
 	}	
	Quit $$$OK
}

ClassMethod QryPatTypeSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPatTypeSubExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPatTypeSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPatTypeSubExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhouruimeng
/// CreatDate：   2014-07-25
/// Description:  特殊患者子分类字典
/// Table：       DHCMed.SPE.PatTypeSub
/// Input：       无
/// D ##class(%ResultSet).RunQuery("DHCMed.SPEService.PatTypeSub","QryAllPatTypeSub")
Query QryAllPatTypeSub() As %Query(ROWSPEC = "PTSID:%String,PTSCode:%String,PTSDesc:%String,PTCode:%String,PTDesc:%String,IsActive:%String,Resume:%String")
{
}

ClassMethod QryAllPatTypeSubExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	Set xCode = ""
 	For {
	 	Set xCode=$o(^DHCMed.SPEDi("PatTp",0,"Sub","IndexCode",xCode))
	 	Quit:xCode=""
	 	
	 	Set xPTID=0
	 	For {	
	 		Set xPTID=$o(^DHCMed.SPEDi("PatTp",0,"Sub","IndexCode",xCode,xPTID))
	 		Quit:xPTID=""
	 		
	 		Set objPT=##class(DHCMed.SPE.PatType).GetObjById(xPTID)
	 		Continue:'$IsObject(objPT)
	 		Set PTCode=objPT.PTCode
	 		Set PTDesc=objPT.PTDesc
 			
	 		Set xSubID=0
	 		For {
	 			Set xSubID=$o(^DHCMed.SPEDi("PatTp",0,"Sub","IndexCode",xCode,xPTID,xSubID))
	 			Quit:xSubID=""
	 			
	 			Set PTSID=xPTID_"||"_xSubID
	 			Set objPTS=##class(DHCMed.SPE.PatTypeSub).GetObjById(PTSID)
	 			Continue:'$IsObject(objPTS)
	 			set PTSIsActive=objPTS.PTSIsActive
	 			continue:PTSIsActive=0
	 			Set PTSCode=objPTS.PTSCode
	 			Set PTSDesc=objPTS.PTSDesc
	 			Set IsActive=objPTS.PTSIsActive
	 			Set Resume=objPTS.PTSResume
	 			
				Set Data=$lb(PTSID,PTSCode,PTSDesc,PTCode,PTDesc,IsActive,Resume)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
	 		}
	 	}
 	}	
	Quit $$$OK
}

ClassMethod QryAllPatTypeSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAllPatTypeSubExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAllPatTypeSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAllPatTypeSubExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhouruimeng
/// CreatDate：   2014-07-25
/// Description:  查询特殊患者基础字典
/// Table：       DHCMed.SS.Dictionary
/// Input：       
/// output:            
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCMed.SPEService.PatTypeSub","QryDicToSpePat","SPEStatus")
Query QryDicToSpePat(aDicType As %String) As %Query(ROWSPEC = "DicRowId:%String,DicType:%String,DicCode:%String,DicDesc:%String,IsActive:%String,Resume:%String")
{
}

ClassMethod QryDicToSpePatExecute(ByRef qHandle As %Binary, aDicType As %String) As %Status
{
	Set repid    =$I(^CacheTemp)
	Set qHandle  =$lb(0,repid,0)
 	Set ind=1
 	
 	Set aDicType =$ZCVT(aDicType,"U")
 	Quit:aDicType="" $$$OK
 	
 	Set DicRowID=0
 	For {
	 	Set DicRowID =$o(^DHCMed.SS.DictionaryI("IdxofType"," "_aDicType,DicRowID))
	 	Quit:DicRowID=""
	 	
	 	Set objDic   =##class(DHCMed.SS.Dictionary).%OpenId(DicRowID)
		If $IsObject(objDic){
		 	Set DicCode       = objDic.Code
			Set DicDesc       = objDic.Description
			Set DicType       = objDic.Type
			Continue:(aDicType'="")&&(aDicType'=$ZCVT(DicType,"U"))
			Set DicActive     = objDic.Active
			Continue:DicActive'=1
			Set Resume="test"
			Set Data=$lb(DicRowID,DicType,DicCode,DicDesc,DicActive,Resume)
	        Set ^CacheTemp(repid,ind)=Data
	        Set ind=ind+1
		}
		If objDic'="" Do objDic.%Close()
	}
	
	Quit $$$OK
}

ClassMethod QryDicToSpePatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDicToSpePatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDicToSpePatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDicToSpePatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 导入重点患者子分类字典
/// w ##Class(DHCMed.SPEService.PatTypeSub).ImportPatTypeSub("01^重症患者^A^icon-menu^1^")
ClassMethod ImportPatTypeSub(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:aInputStr="" return
	
	Set PatType=$p(aInputStr,"^",3)
	Set Parref=$o(^DHCMed.SPEDi("PatTp",0,"IndexCode"," "_$zcvt(PatType,"U"),0))
	Quit:Parref="" return
	
	Set InputStr=Parref
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_$p(aInputStr,"^",1)
	Set InputStr=InputStr_"^"_$p(aInputStr,"^",2)
	Set InputStr=InputStr_"^"_$p(aInputStr,"^",4)
	Set InputStr=InputStr_"^"_+$p(aInputStr,"^",5)
	Set InputStr=InputStr_"^"_+$p(aInputStr,"^",6)
	Set InputStr=InputStr_"^"_+$p(aInputStr,"^",7)
	Set InputStr=InputStr_"^"_+$p(aInputStr,"^",8)
	Set InputStr=InputStr_"^"_$p(aInputStr,"^",9)
	
	Set return=##class(DHCMed.SPE.PatTypeSub).Update(InputStr,"^")
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2015-04-11
/// Description:  查询有效状态的特殊患者子分类
/// Table：       DHCMed.SPE.PatTypeSub
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.SPEService.PatTypeSub","QryPatTypeSubActive","")
Query QryPatTypeSubActive(aPatTypeID As %String) As %Query(ROWSPEC = "PTSID:%String,PTSCode:%String,PTSDesc:%String,PTSIcon:%String,PTSIsActiveDesc:%String,PTSAutoMarkDesc:%String,PTSAutoCheckDesc:%String,PTSAutoCloseDesc:%String,PTSResume:%String")
{
}

ClassMethod QryPatTypeSubActiveExecute(ByRef qHandle As %Binary, aPatTypeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	Set xCode=""
 	For {
	 	Set xCode=$o(^DHCMed.SPEDi("PatTp",0,"Sub","IndexCode",xCode))
	 	Quit:xCode=""
	 	
	 	Set xPatTypeID=0
	 	For {
		 	Set xPatTypeID=$o(^DHCMed.SPEDi("PatTp",0,"Sub","IndexCode",xCode,xPatTypeID))
	 		Quit:xPatTypeID=""
	 		Continue:(aPatTypeID'="")&(aPatTypeID'=xPatTypeID)
	 		
	 		Set xPatTypeSub=0
	 		For {
		 		Set xPatTypeSub=$o(^DHCMed.SPEDi("PatTp",0,"Sub","IndexCode",xCode,xPatTypeID,xPatTypeSub))
	 			Quit:xPatTypeSub=""
	 			
		 		Set PatTypeSubID = xPatTypeID_"||"_xPatTypeSub
		 		Set objPatTypeSub=##class(DHCMed.SPE.PatTypeSub).GetObjById(PatTypeSubID)
		 		Set Code          = objPatTypeSub.PTSCode
		 		Set Desc          = objPatTypeSub.PTSDesc
		 		Set Icon          = objPatTypeSub.PTSIcon
	 			
				Set AutoMarkDesc  = $s(objPatTypeSub.PTSAutoMark=1:"是",1:"否")
		 		Set AutoCheckDesc = $s(objPatTypeSub.PTSAutoCheck=1:"是",1:"否")
		 		Set AutoCloseDesc = $s(objPatTypeSub.PTSAutoClose=1:"是",1:"否")
		 		Set IsActiveDesc=objPatTypeSub.PTSIsActive
				Continue:IsActiveDesc'=1
				Set IsActiveDesc=$s(IsActiveDesc=1:"是",1:"否")
		 		Set Resume        = objPatTypeSub.PTSResume
	 			
				Set Data=$lb(PatTypeSubID,Code,Desc,Icon,IsActiveDesc,AutoMarkDesc,AutoCheckDesc,AutoCloseDesc,Resume)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
		 	}
		}
 	}	
	Quit $$$OK
}

ClassMethod QryPatTypeSubActiveClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPatTypeSubActiveExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPatTypeSubActiveFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPatTypeSubActiveExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
