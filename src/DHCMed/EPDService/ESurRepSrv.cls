/// Creator:	chenrui
/// CreatDate:	2021-07-16
/// Description: 流调类型表服务类
Class DHCMed.EPDService.ESurRepSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     chenrui
/// CreatDate：   2021-07-16
/// Description:  查询流调类型
/// Table：       DHCMed.EPD.ESurType
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.EPDService.ESurRepSrv","QryESurType","")
Query QryESurType(aActive As %String = "") As %Query(ROWSPEC = "ID:%String,BTCode:%String,BTDesc:%String,IsActive:%String,IsActDesc:%String,Resume:%String") [ SqlProc ]
{
}

ClassMethod QryESurTypeExecute(ByRef qHandle As %Binary, aActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
		
	Set xID=0	
	For {
		Set xID=$o(^DHCMed.EPD.ESurTypeD(xID))
		Quit:xID=""
		
		Set objESurType = ##class(DHCMed.EPD.ESurType).GetObjById(xID)
		Continue:'$Isobject(objESurType)
		Set Code 	  = objESurType.ESCode	   
	    Set Desc 	  = objESurType.ESDesc	
		Set Desc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.EPD.ESurType","ESDesc","",Desc)   	
	    Set IsActive  = objESurType.ESIsActive
	    Continue:(aActive'="")&&(aActive'=IsActive)
		Set IsActDesc = $s(IsActive=1:"是",1:"否")
	    Set Resume    = objESurType.ESResume
	 
		Set Data=$lb(xID,Code,Desc,IsActive,IsActDesc,Resume)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	
	
	Quit $$$OK
}

ClassMethod QryESurTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryESurTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryESurTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryESurTypeExecute ]
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

/// Creator：     chenrui
/// CreatDate：   2021-07-16
/// Description:  查询流调扩展项目
/// Table：       DHCMed.EPD.ESurTypeExt
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.EPDService.ESurRepSrv","QryESurTypeExt","3")
Query QryESurTypeExt(aTypeID As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,TypeID:%String,TypeCode:%String,TypeDesc:%String,DatID:%String,DatCode:%String,DatDesc:%String,DicID:%String,DicCode:%String,DicDesc:%String,IsRequired:%String,DicInfoID:%String,DicInfoCode:%String,DicInfoDesc:%String") [ SqlProc ]
{
}

ClassMethod QryESurTypeExtExecute(ByRef qHandle As %Binary, aTypeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aTypeID="" $$$OK
		
	Set xID=0	
	For {
		Set xID=$o(^DHCMed.EPD.ESurTypeD(aTypeID,"ChildExt",xID))
		Quit:xID=""
		
		Set ExtID=aTypeID_"||"_xID
		Set objEXT = ##class(DHCMed.EPD.ESurTypeExt).GetObjById(ExtID)
		Continue:'$Isobject(objEXT)
		Set Code 	  = objEXT.BTCode	   
	    Set Desc 	  = objEXT.BTDesc
	    Set IsRequired = objEXT.BTIsRequired
	    Set (TypeID,TypeCode,TypeDesc) = ""
	
		If $IsObject(objEXT.BTExtType) {	
			Set TypeID =  objEXT.BTExtType.%Id()  
			Set TypeCode = objEXT.BTExtType.Code
			Set TypeDesc = objEXT.BTExtType.Description
	    }	
	    Set (DatID,DatCode,DatDesc) = ""
		If $IsObject(objEXT.BTDatType) {	
			Set DatID =  objEXT.BTDatType.%Id()  
			Set DatCode = objEXT.BTDatType.Code
			Set DatDesc = objEXT.BTDatType.Description
	    }
	    Set (DicID,DicCode,DicDesc) = ""
		If $IsObject(objEXT.BTDicType) {	
			Set DicID =  objEXT.BTDicType.%Id()  
			Set DicCode = objEXT.BTDicType.Code
			Set DicDesc = objEXT.BTDicType.Description
	    }
	    Set (DicInfoID,DicInfoCode,DicInfoDesc) = ""
	    if (DicCode'=""){
		    Set objDicInfo = ##class(DHCMed.SS.Dictionary).GetByTypeCode(DicCode,"1","1")
		    Set:$IsObject(objDicInfo) DicInfoID = objDicInfo.%Id()  
		    Set:$IsObject(objDicInfo) DicInfoCode = objDicInfo.Code
		    Set:$IsObject(objDicInfo) DicInfoDesc = objDicInfo.Description
		
	    
		} 
	    
	    
		Set Data=$lb(ExtID,Code,Desc,TypeID,TypeCode,TypeDesc,DatID,DatCode,DatDesc,DicID,DicCode,DicDesc,IsRequired,DicInfoID,DicInfoCode,DicInfoDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryESurTypeExtClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryESurTypeExtExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryESurTypeExtFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryESurTypeExtExecute ]
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

/// Creator：     chenrui
/// CreatDate：   2021-07-16
/// Description:  查询流调扩展项目报告界面
/// Table：       DHCMed.EPD.ESurTypeExt
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.EPDService.ESurRepSrv","QryESurTypeExtByID","1","2634")
Query QryESurTypeExtByID(aTypeID As %String, aExtTypeID As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,TypeID:%String,TypeCode:%String,TypeDesc:%String,DatID:%String,DatCode:%String,DatDesc:%String,DicID:%String,DicCode:%String,DicDesc:%String,IsRequired:%String,DicInfoID:%String,DicInfoCode:%String,DicInfoDesc:%String") [ SqlProc ]
{
}

ClassMethod QryESurTypeExtByIDExecute(ByRef qHandle As %Binary, aTypeID As %String, aExtTypeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aTypeID="")||(aExtTypeID="") $$$OK
		
	Set xID=0	
	For {
		Set xID=$o(^DHCMed.EPD.ESurTypeD(aTypeID,"ChildExt",xID))
		Quit:xID=""
		
		Set ExtID=aTypeID_"||"_xID
		Set objEXT = ##class(DHCMed.EPD.ESurTypeExt).GetObjById(ExtID)
		Continue:'$Isobject(objEXT)
		Set Code 	  = objEXT.BTCode	   
	    Set Desc 	  = objEXT.BTDesc
		Set Desc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.EPD.ESurTypeExt","BTDesc","",Desc)   
	    Set IsRequired = objEXT.BTIsRequired
	    Set (TypeID,TypeCode,TypeDesc) = ""
	
		If $IsObject(objEXT.BTExtType) {	
			Set TypeID =  objEXT.BTExtType.%Id()  
			Continue:((aExtTypeID'="")&&(TypeID'=aExtTypeID))
			Set TypeCode = objEXT.BTExtType.Code
			Set TypeDesc = objEXT.BTExtType.Description
	    }	
	    Set (DatID,DatCode,DatDesc) = ""
		If $IsObject(objEXT.BTDatType) {	
			Set DatID =  objEXT.BTDatType.%Id()  
			Set DatCode = objEXT.BTDatType.Code
			Set DatDesc = objEXT.BTDatType.Description
	    }
	    Set (DicID,DicCode,DicDesc) = ""
		If $IsObject(objEXT.BTDicType) {	
			Set DicID =  objEXT.BTDicType.%Id()  
			Set DicCode = objEXT.BTDicType.Code
			Set DicDesc = objEXT.BTDicType.Description
	    }
	    Set (DicInfoID,DicInfoCode,DicInfoDesc) = ""
	    if (DicCode'=""){
		    Set objDicInfo = ##class(DHCMed.SS.Dictionary).GetByTypeCode(DicCode,"1","1")
		    Set:$IsObject(objDicInfo) DicInfoID = objDicInfo.%Id()  
		    Set:$IsObject(objDicInfo) DicInfoCode = objDicInfo.Code
		    Set:$IsObject(objDicInfo) DicInfoDesc = objDicInfo.Description
		} 
	    Set IsRequired = objEXT.BTIsRequired
	    Set ArrEXTData("IndexCode",Code) = $lb(ExtID,Desc,TypeID,TypeCode,TypeDesc,DatID,DatCode,DatDesc,DicID,DicCode,DicDesc,IsRequired,DicInfoID,DicInfoCode,DicInfoDesc)
	    
	}
	Set xCode = ""
	For{
		Set xCode = $o(ArrEXTData("IndexCode",xCode))
		Quit:xCode=""
		Set ExtInfo 		= ArrEXTData("IndexCode",xCode)
		Set xExtID  		= $lg(ExtInfo,1)
		Set xDesc 			= $lg(ExtInfo,2)
		Set xTypeID  		= $lg(ExtInfo,3)
		Set xTypeCode  		= $lg(ExtInfo,4)
		Set xTypeDesc  		= $lg(ExtInfo,5)
		Set xDatID  		= $lg(ExtInfo,6)
		Set xDatCode  		= $lg(ExtInfo,7)
		Set xDatDesc  		= $lg(ExtInfo,8)
		Set xDicID  		= $lg(ExtInfo,9)
		Set xDicCode  		= $lg(ExtInfo,10)
		Set xDicDesc  		= $lg(ExtInfo,11)
		Set xIsRequired  	= $lg(ExtInfo,12)
		Set xDicInfoID  	= $lg(ExtInfo,13)
		Set xDicInfoCode 	= $lg(ExtInfo,14)
		Set xDicInfoDesc 	= $lg(ExtInfo,15)
		Set Data=$lb(xExtID,xCode,xDesc,xTypeID,xTypeCode,xTypeDesc,xDatID,xDatCode,xDatDesc,xDicID,xDicCode,xDicDesc,xIsRequired,xDicInfoID,xDicInfoCode,xDicInfoDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	
	Quit $$$OK
}

ClassMethod QryESurTypeExtByIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryESurTypeExtByIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryESurTypeExtByIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryESurTypeExtByIDExecute ]
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

/// Creator：     chenrui
/// CreatDate：   2020-07-16
/// Description:  查询流调扩展项目分类
/// Table：       DHCMed.EPD.ESurTypeExt
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.EPDService.ESurRepSrv","QryESurRegType","3")
Query QryESurRegType(aRegTypeID As %String) As %Query(ROWSPEC = "TypeID:%String,TypeCode:%String,TypeDesc:%String") [ SqlProc ]
{
}

ClassMethod QryESurRegTypeExecute(ByRef qHandle As %Binary, aRegTypeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aRegTypeID="") $$$OK
	
	Set xTypeID=0	
	For {
		Set xTypeID=$o(^DHCMed.EPD.ESurTypeExtI("IndexType",aRegTypeID,xTypeID))
		Quit:xTypeID=""
	    Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(xTypeID)
	    Continue:'$Isobject(objDic)
		Set TypeCode = objDic.Code
		Set TypeDesc = objDic.Description
		Set Data=$lb(xTypeID,TypeCode,TypeDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryESurRegTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryESurRegTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryESurRegTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryESurRegTypeExecute ]
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

/// Creator：     chenrui
/// CreatDate：   2021-07-17
/// Description:  保存流调报告
/// Input：       aExpReg：主表信息
/// 			  aExpRegExt：扩展表
/// Return:		  return>0:成功、return<1:失败 
/// Debug:		  w ##class(DHCMed.EPDService.ESurRepSrv).SaveExpReport("5^3^住院3^0000000054^^男^^2019-02-01 10:51:54^内分泌科^医生01^1^57^54","#5^1^3||1^一、 是否有发热、咽痛、咳嗽、腹泻、鼻塞、流鼻涕、乏力等症状？^B1^5638^^^^#5^^3||2^二、14天内是否有广州荔湾区、番禹区、南沙区、白云区、佛山市、湛江市、东菀市、深圳市宝安区的旅行史或居住史？^B1^5638^^^^#5^^3||3^三、14天内是否有境外疫情严重国家或地区的旅行史或居住史^B1^5638^^^^#5^^3||4^四、14天内是否接触过新冠病毒感染确诊病例？^B1^5638^^^^#5^^3||5^五、14天内是否曾接触过广州荔湾区、番禹区、南沙区、白云区、佛山市、湛江市、东菀市、深圳市宝安区的有发热或呼吸道症状的患者？^B1^5638^^^^#5^^3||6^六、14天内是否曾接触过境外疫情严重国家或地区的有发热或呼吸道症状的患者^B1^5638^^^^#5^^3||7^七、您周围(如家中、学校班级或单位)是否有2例以上发热或呼吸到症状的病例？^B1^5638^^^^#5^^3||8^八、是否从事进口海产品冷链加工与运输工作、快递工作、公共交通系统工作(公交、地铁、网约车)^B1^5638^^^^")
ClassMethod SaveExpReport(aExpReg As %String, aExpRegExts As %String)
{
	Set return = ""
	New (aExpReg,aExpRegExts)
	
	// 保存主表
	Set return=-1
	Set RegFlag = ##class(DHCMed.EPD.ESurRepReg).Update(aExpReg,"^")
	Quit:RegFlag<0 return
	Set aRepID = RegFlag
	
	//保存扩展表
	Set return = -2
	Set aExpRegExt="" 
	For indx = 1:1:$length(aExpRegExts,"#"){
		Set aExpRegExt = $p(aExpRegExts,"#",indx)
		Continue:aExpRegExt="" 
	    Set $p(aExpRegExt,"^",1)= aRepID
		Set flg=##Class(DHCMed.EPD.ESurRegExt).Update(aExpRegExt,"^")
		Quit:flg<0 
	}
	Set return = aRepID	
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2021-07-16
/// Description:  查询流调主表信息
/// Table：       DHCMed.EPD.ESurRepReg
/// Input:        报告ID
/// do ##class(%ResultSet).RunQuery("DHCMed.EPDService.ESurRepSrv","QryRepInfo","3")
Query QryRepInfo(aRepID As %String) As %Query(ROWSPEC = "aRepID:%String,SEName:%String,SERegNo:%String,SEIDNumber:%String,SESex:%String,SETelPhone:%String,SEDiagDateTime:%String,SEDiagLoc:%String,SEDiagDoc:%String,SERepStutas:%String") [ SqlProc ]
{
}

ClassMethod QryRepInfoExecute(ByRef qHandle As %Binary, aRepID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:aRepID="" $$$OK
	
	Set objReg = ##class(DHCMed.EPD.ESurRepReg).GetObjById(aRepID)
	Quit:'$IsObject(objReg) return
	
	Set SEName 			= objReg.SEName
	Set SERegNo 		= objReg.SERegNo
	Set SEIDNumber 		= objReg.SEIDNumber
	Set SESex 			= objReg.SESex
	Set SETelPhone 		= objReg.SETelPhone
	Set SEDiagDateTime 	= objReg.SEDiagDateTime
	Set SEDiagLoc 		= objReg.SEDiagLoc
	Set SEDiagLoc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc","",SEDiagLoc)
	Set SEDiagDoc 		= objReg.SEDiagDoc
	Set SERepStutas 	= objReg.SERepStutas
	Set:SERepStutas'="" SERepStutas = $Case(SERepStutas,"1":"保存","2":"审核","3":"取消审核","4":"删除")
	Set SERepStutas = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description","",SERepStutas)	
	
	
    
    Set Data=$lb(aRepID,SEName,SERegNo,SEIDNumber,SESex,SETelPhone,SEDiagDateTime,SEDiagLoc,SEDiagDoc,SERepStutas)

	Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryRepInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryRepInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepInfoExecute ]
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

/// Creator：     chenrui
/// CreatDate：   2021-07-17
/// Description:  查询流调扩展表明细
/// Table：      DHCMed.EPD.ESurRepReg，DHCMed.EPD.ESurRegExt，DHCMed.EPD.ESurTypeExt
/// Input:        报告ID
/// do ##class(%ResultSet).RunQuery("DHCMed.EPDService.ESurRepSrv","QryExpExtInfo","3")
Query QryExpExtInfo(aRepID As %String) As %Query(ROWSPEC = "RepID:%String,SubID:%String,Code:%String,Desc:%String,ItemDesc:%String,DataType:%String,ResultID:%String,ResultCode:%String,ResultDesc:%String,ResultList:%String,ResultListCode:%String,ResultListDesc:%String,ResultTxt:%String,ActDate:%String,ActTime:%String") [ SqlProc ]
{
}

ClassMethod QryExpExtInfoExecute(ByRef qHandle As %Binary, aRepID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:aRepID="" $$$OK
	
	Set xSubID = ""
	For {
		Set xSubID =$o(^DHCMed.EPD.ESurRepRegD(aRepID,"EXT",xSubID))
		Quit:xSubID=""
		
		Set ExtID=aRepID_"||"_xSubID
		Set objExt = ##class(DHCMed.EPD.ESurRegExt).GetObjById(ExtID)
	    Continue:'$IsObject(objExt) 
		Set objItemDr  = objExt.SEItemDr
	    Continue:'$IsObject(objItemDr)	    
	    Set Code 	  = objItemDr.BTCode	   
	    Set Desc 	  = objItemDr.BTDesc	   	
	  
		Set ItemDesc   = objExt.SEItemDesc  
		Set DataType   = objExt.SEDataType  
		Set objResult  = objExt.SEResultDr 
		Set ResultID="", ResultCode="",ResultDesc=""
		If $IsObject(objResult) {
			Set ResultID = objResult.%Id()
			Set ResultCode = objResult.Code
			Set ResultDesc = objResult.Description
		}
    
		Set ResultList = objExt.SEResultList
		Set ResultListID="",ResultListCode="",ResultListDesc=""
		For indx = 1:1:ResultList.Count(){
		 	Set objDic = ResultList.GetAt(indx)
			Continue:'$IsObject(objDic)	
			Set ResultListID=ResultListID_","_objDic.%Id()
			Set ResultListCode=ResultListCode_","_objDic.Code
			Set ResultListDesc=ResultListDesc_","_objDic.Description
		} 
		Set:ResultListID'="" ResultListID=$e(ResultListID,2,$l(ResultListID))
		Set:ResultListCode'="" ResultListCode=$e(ResultListCode,2,$l(ResultListCode))
		Set:ResultListDesc'="" ResultListDesc=$e(ResultListDesc,2,$l(ResultListDesc))
		
		Set ResultTxt  = objExt.SEResultTxt 
		Set ActDate	   = objExt.SEActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)  	  
		Set ActTime	   = objExt.SEActTime
		Set:ActTime'="" ActTime=$zt(ActTime,1)	  
		
	
		Set Data=$lb(aRepID,xSubID,Code,Desc,ItemDesc,DataType,ResultID,ResultCode,ResultDesc,ResultListID,ResultListCode,ResultListDesc,ResultTxt,ActDate,ActTime)  
	    Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
	}

	Quit $$$OK
}

ClassMethod QryExpExtInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryExpExtInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryExpExtInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryExpExtInfoExecute ]
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

/// Creator：     chenrui
/// CreatDate：   2021-07-16
/// Description:  查询流调主表信息
/// Table：       DHCMed.EPD.ESurRepReg
/// Input:        报告ID
/// do ##class(%ResultSet).RunQuery("DHCMed.EPDService.ESurRepSrv","QryRepInfoByPaadm","54")
Query QryRepInfoByPaadm(aPatientID As %String) As %Query(ROWSPEC = "aRepID:%String,SEName:%String,SERegNo:%String,SEIDNumber:%String,SESex:%String,SETelPhone:%String,SEDiagDateTime:%String,SEDiagLoc:%String,SEDiagDoc:%String,SERepStutas:%String,RegTypeID:%String") [ SqlProc ]
{
}

ClassMethod QryRepInfoByPaadmExecute(ByRef qHandle As %Binary, aPatientID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:aPatientID="" $$$OK
	
	
	Set xID = ""
	For{
		Set xID = $o(^DHCMed.EPD.ESurRepRegI("IndexPatientID",aPatientID,xID))
		Quit:xID=""
		
		Set objReg = ##class(DHCMed.EPD.ESurRepReg).GetObjById(xID)
		Quit:'$IsObject(objReg)
		Set RegTypeID		= objReg.SERegTypeDr.%Id()
		Set SEName 			= objReg.SEName
		Set SERegNo 		= objReg.SERegNo
		Set SEIDNumber 		= objReg.SEIDNumber
		Set SESex 			= objReg.SESex
		Set:SESex'="" SESex = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTSex","CTSEXDesc","",SESex)
		Set SETelPhone 		= objReg.SETelPhone
		Set SEDiagDateTime 	= objReg.SEDiagDateTime
		Set SEDiagLoc 		= objReg.SEDiagLoc
		Set SEDiagLoc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc","",SEDiagLoc)
		Set SEDiagDoc 		= objReg.SEDiagDoc
		Set SERepStutas 	= objReg.SERepStutas
		Set:SERepStutas'="" SERepStutas = $Case(SERepStutas,"1":"保存","2":"审核","3":"取消审核","4":"删除")
		Set SERepStutas = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description","",SERepStutas)	
			
	    Set Data=$lb(xID,SEName,SERegNo,SEIDNumber,SESex,SETelPhone,SEDiagDateTime,SEDiagLoc,SEDiagDoc,SERepStutas,RegTypeID)
		Set ^CacheTemp(repid,ind)=Data
	    Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryRepInfoByPaadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepInfoByPaadmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryRepInfoByPaadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepInfoByPaadmExecute ]
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

/// Creator：     chenrui
/// CreatDate：   2021-07-16
/// Description:  查询流调主表信息
/// Table：       DHCMed.EPD.ESurRepReg
/// Input:        报告ID
/// do ##class(%ResultSet).RunQuery("DHCMed.EPDService.ESurRepSrv","QryESurByDate","2021-07-01","2021-07-27","","")
Query QryESurByDate(aDateFrom As %String, aDateTo As %String, aPatName As %String, aRepStatus As %String) As %Query(ROWSPEC = "aRepID:%String,SEName:%String,SERegNo:%String,SEIDNumber:%String,SESex:%String,SETelPhone:%String,SEDiagDateTime:%String,SEDiagLoc:%String,SEDiagDoc:%String,SERepStutas:%String,RegTypeID:%String,EpisodeID:%String,DescOne:%String,DescTwo:%String,DescThr:%String,DescFor:%String,DescFiv:%String,DescSix:%String,DescSev:%String,DescEit:%String,DescNin:%String") [ SqlProc ]
{
}

ClassMethod QryESurByDateExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aPatName As %String, aRepStatus As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:((aDateFrom="")||(aDateTo="")) $$$OK
	Set DateFrom = ##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set DateTo	 = ##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Set:DateFrom'="" DateFrom = +DateFrom
	Set:DateTo'="" DateTo = +DateTo
	Set (SEName,SERegNo,SEIDNumber,SESex,SETelPhone,SEDiagDateTime,SEDiagLoc,SEDiagDoc,SERepStutas,RegTypeID,DescOne,DescTwo,DescThr,DescFor,DescFiv,DescSix,DescSev,DescEit,DescNin) =""
	For tmpDate=DateFrom:1:DateTo {
		Set xRepID=""
		For {
			Set xRepID=$o(^DHCMed.EPD.ESurRepRegI("IndexEnterDate",tmpDate,xRepID))
			Quit:xRepID=""
			Set objReg = ##class(DHCMed.EPD.ESurRepReg).GetObjById(xRepID)
			Quit:'$IsObject(objReg)
			Set RegTypeID		= objReg.SERegTypeDr.%Id()
			Set SEName 			= objReg.SEName
			Continue:(aPatName'="")&&(aPatName'=SEName)
			Set SERegNo 		= objReg.SERegNo
			Set SEIDNumber 		= objReg.SEIDNumber
			Set SESex 			= objReg.SESex
			Set SETelPhone 		= objReg.SETelPhone
			Set SEDiagDateTime 	= objReg.SEDiagDateTime
			Set SEDiagLoc 		= objReg.SEDiagLoc
			Set SEDiagDoc 		= objReg.SEDiagDoc
			Set SERepStutas 	= objReg.SERepStutas
			Set EpisodeID 		= objReg.EpisodeID
			Set:SERepStutas'="" SERepStutas = $Case(SERepStutas,"1":"保存","2":"审核","3":"取消审核","4":"删除")
			Continue:(aRepStatus'="")&&(aRepStatus'=SERepStutas)
			Set xItemID = ""
			For {
				Set xItemID = $o(^DHCMed.EPD.ESurRepRegI("EXT","IndexItem",RegTypeID,xItemID))
				Quit:xItemID=""
				Set xParrf = ""
				
				For{
					Set xParrf = $o(^DHCMed.EPD.ESurRepRegI("EXT","IndexItem",RegTypeID,xItemID,xParrf))
					Quit:xParrf=""
					Set xID = RegTypeID_"||"_xParrf
					Set objRepExt = ##class(DHCMed.EPD.ESurRegExt).GetObjById(xID)
					Continue:'$IsObject(objRepExt)
					Set ItemCode = objRepExt.SEItemDr.BTCode
					Set:ItemCode="010100" DescOne = objRepExt.SEResultDr.Description
					Set:ItemCode="010200" DescTwo = objRepExt.SEResultDr.Description
					Set:ItemCode="010300" DescThr = objRepExt.SEResultDr.Description
					Set:ItemCode="010400" DescFor = objRepExt.SEResultDr.Description
					Set:ItemCode="010500" DescFiv = objRepExt.SEResultDr.Description
					Set:ItemCode="010600" DescSix = objRepExt.SEResultTxt
					Set:ItemCode="010700" DescSev = objRepExt.SEResultList
					Set:ItemCode="010800" DescEit = objRepExt.SEResultDr.Description
					if (ItemCode="010700"){
						Set ResultDrs= objRepExt.SEResultList
						Set SEResultList=""
						For ind=1:1:ResultDrs.Count() {
							Set objDic=ResultDrs.GetAt(ind)
							Continue:'$IsObject(objDic)
							Set SEResultList=SEResultList_","_objDic.Description
						}
						Set:SEResultList'="" SEResultList=$e(SEResultList,2,$l(SEResultList))
						Set DescSev = SEResultList
					}	
					Set:ItemCode="010900" DescNin = objRepExt.SEResultDr.Description
					Set Data=$lb(xRepID,SEName,SERegNo,SEIDNumber,SESex,SETelPhone,SEDiagDateTime,SEDiagLoc,SEDiagDoc,SERepStutas,RegTypeID,EpisodeID,DescOne,DescTwo,DescThr,DescFor,DescFiv,DescSix,DescSev,DescEit,DescNin)
					Set ^CacheTemp(repid,ind)=Data
				    Set ind=ind+1
				}
			}
			
			
			
		   
		}
	}
	Quit $$$OK
}

ClassMethod QryESurByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryESurByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryESurByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryESurByDateExecute ]
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

/// Creator：     chenrui
/// CreatDate：   2021-08-10
/// Description:  查询流调扩展项目对照表
/// Table：       DHCMed.EPD.ESurTypeExt
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.EPDService.ESurRepSrv","QryESurContrast")
Query QryESurContrast() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,TypeID:%String,TypeCode:%String,TypeDesc:%String,DatID:%String,DatCode:%String,DatDesc:%String,DicID:%String,DicCode:%String,DicDesc:%String,IsRequired:%String,DicInfoID:%String,DicInfoCode:%String,DicInfoDesc:%String,EsurTypeID:%String,EsurTypeDesc:%String") [ SqlProc ]
{
}

ClassMethod QryESurContrastExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	
	Set aTypeID = ""
	For{
		Set aTypeID=$o(^DHCMed.EPD.ESurTypeD(aTypeID))
		Quit:aTypeID=""
		Set xID=0	
		For {
			Set xID=$o(^DHCMed.EPD.ESurTypeD(aTypeID,"ChildExt",xID))
			Quit:xID=""
			
			Set ExtID=aTypeID_"||"_xID
			Set objEXT = ##class(DHCMed.EPD.ESurTypeExt).GetObjById(ExtID)
			Continue:'$Isobject(objEXT)
			
			Set objEsurType = ##class(DHCMed.EPD.ESurType).GetObjById(aTypeID)
			Set (EsurTypeID,EsurTypeDesc) = ""
		
			If $IsObject(objEXT.BTExtType) {	
				Set EsurTypeID =  objEsurType.%Id()  
				Set EsurTypeDesc = objEsurType.ESDesc
		    }
			
			Set Code 	  = objEXT.BTCode	   
		    Set Desc 	  = objEXT.BTDesc
		    Set IsRequired = objEXT.BTIsRequired
		    Set (TypeID,TypeCode,TypeDesc) = ""
		
			If $IsObject(objEXT.BTExtType) {	
				Set TypeID =  objEXT.BTExtType.%Id()  
				Set TypeCode = objEXT.BTExtType.Code
				Set TypeDesc = objEXT.BTExtType.Description
		    }	
		    Set (DatID,DatCode,DatDesc) = ""
			If $IsObject(objEXT.BTDatType) {	
				Set DatID =  objEXT.BTDatType.%Id()  
				Set DatCode = objEXT.BTDatType.Code
				Set DatDesc = objEXT.BTDatType.Description
		    }
		    Set (DicID,DicCode,DicDesc) = ""
			If $IsObject(objEXT.BTDicType) {	
				Set DicID =  objEXT.BTDicType.%Id()  
				Set DicCode = objEXT.BTDicType.Code
				Set DicDesc = objEXT.BTDicType.Description
		    }
		    Set (DicInfoID,DicInfoCode,DicInfoDesc) = ""
		    if (DicCode'=""){
			    Set objDicInfo = ##class(DHCMed.SS.Dictionary).GetByTypeCode(DicCode,"1","1")
			    Set:$IsObject(objDicInfo) DicInfoID = objDicInfo.%Id()  
			    Set:$IsObject(objDicInfo) DicInfoCode = objDicInfo.Code
			    Set:$IsObject(objDicInfo) DicInfoDesc = objDicInfo.Description
			} 
		    
			Set Data=$lb(ExtID,Code,Desc,TypeID,TypeCode,TypeDesc,DatID,DatCode,DatDesc,DicID,DicCode,DicDesc,IsRequired,DicInfoID,DicInfoCode,DicInfoDesc,EsurTypeID,EsurTypeDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryESurContrastClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryESurContrastExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryESurContrastFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryESurContrastExecute ]
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

}
