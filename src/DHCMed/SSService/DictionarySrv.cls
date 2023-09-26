/// 名称: DHCMed.SSService.DictionarySrv
/// 描述: DHCMed.SS.Dictionary字典表的常用操作
/// 编写者：wuwj
/// 编写日期: 2010-04-14
Class DHCMed.SSService.DictionarySrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2014-10-23
/// Description:  若字典类别活动为否，则其字典项目全置为否
/// Table：       DHCMed.SS.Dictionary
/// Input：       type：   类型
///               code： 代码
/// Return：      返回配置值的Id
/// w ##class(DHCMed.SSService.DictionarySrv).ChangeIsActive("NINFAimReportType")
ClassMethod ChangeIsActive(acode As %String) As %String
{
	New (acode)
	Set return=""
	
	Set acode=" "_acode
	Set acode=$ZCVT(acode,"U") //转换为大写
	Set rowid=""
	For {
		Set rowid=$o(^DHCMed.SS.DictionaryI("IdxofType",acode,rowid))
	 	Quit:rowid=""
	 	Set objDic=##class(DHCMed.SS.Dictionary).%OpenId(rowid)
	 	Continue:'$IsObject(objDic)
	 	Set objDic.Active=0
	 	
	 	Set sc=objDic.%Save()
		If $system.Status.IsError(sc) {        //检查Save是否成功
	   		Do $system.OBJ.DisplayError(sc) 
	   		Set return=-1
		}Else{
			Set return=objDic.%Id()
		}
			Do objDic.%Close()
	}
	
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2014-10-23
/// Description:  检查字典项目所属字典类别的有效性
/// Table：       DHCMed.SS.Dictionary
/// Input：       type：   类型
///               code： 代码
/// Return：      返回配置值的Id
/// w ##class(DHCMed.SSService.DictionarySrv).CheckIsActive("NINFAimReportType")
ClassMethod CheckIsActive(atype As %String) As %String
{
	New (atype)
	Set return=""
	
	Set atype=" "_atype
	Set atype=$ZCVT(atype,"U") //转换为大写
	Set rowid=""
	For {
		Set rowid=$o(^DHCMed.SS.DictionaryI("IndexTypeCode"," SYS",atype,rowid))
	 	Quit:rowid=""
	 	Set objDic=##class(DHCMed.SS.Dictionary).%OpenId(rowid)
	 	Continue:'$IsObject(objDic)
	 	Set return=objDic.Active
		Do objDic.%Close()
	}
	
	Quit return
}

/// Creator：     wuwj
/// CreatDate：   2010-04-15
/// Description:  根据type/code获取配置值
/// Table：       DHCMed.SS.Dictionary
/// Input：       type：   类型
///               code： 代码
/// Return：      返回配置值的Id
/// w ##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode("")
ClassMethod GetIdByTypeCode(code As %String, type As %String) As %String
{
	new (type,code)
	set val=""
    s type=$g(type)
    s code=$g(code)
    s type=" "_type
	s type=$ZCVT(type,"U") //转换为大写
	s code=" "_code
	s code=$ZCVT(code,"U") //转换为大写
	
	quit:'$d(^DHCMed.SS.DictionaryI("IdxofTypeCode",code,type)) val

	set id=$o(^DHCMed.SS.DictionaryI("IdxofTypeCode",code,type,""))
	quit id
}

/*
ClassMethod GetHospById(id As %String) As %String
{
	new (id)
	set val=""
	quit:'$d(^CT("HOSP",id)) val
    s HispsDescs=$p($g(^CT("HOSP",id)),"^",2)
	q HispsDescs
}
*/
/// Creator：     wuwj
/// CreatDate：   2010-04-15
/// Description:  根据id获取医院的名称
/// Table：       CT
/// Input：      
/// Return：      医院的名称
/// w ##class(DHCMed.SSService.DictionarySrv).GetHospById("2")
/// Creator：     wuwj
/// CreatDate：   2010-04-15
/// Description:  根据通过Rowid获得code
/// Table：       DHCMed.SS.Dictionary
/// Input：      Rowid
/// Return：      返回 code
/// w ##class(DHCMed.SSService.DictionarySrv).GetCodeByRowId(1)
ClassMethod GetCodeByRowId(rowid As %String) As %String
{
	new (rowid)
	set val=""
    s rowid=$g(rowid)
    s obj=##class(DHCMed.SS.Dictionary).%OpenId(rowid)
    if ($IsObject(obj))
    {
	   s code=obj.Code
	    q code 
	    }
	 else
	 {
		 q val
		 }
}

/// Creator：     wuwj
/// Modified By PanLei 2013-09-02
/// CreatDate：   2010-04-14
/// Description:  查询所有的基础字典或字典项
/// Table：       DHCMed.SS.Dictionary
/// Input：       aType:字典类型(例如：EpdemicType),aIsActive:是否有效(1-有效,0-无效)    
/// Return：      
/// Do ##class(%ResultSet).RunQuery("DHCMed.SSService.DictionarySrv","QryDictionary","EpdemicType",1)
Query QryDictionary(aType As %String, aIsActive As %String = "1") As %Query(ROWSPEC = "myid:%String,Code:%String,Description:%String,Type:%String,Active:%String,HispsDescs:%String,DateFrom:%String,DateTo:%String,HospDr:%String,InNo:%String") [ SqlProc ]
{
}

ClassMethod QryDictionaryExecute(ByRef qHandle As %Binary, aType As %String, aIsActive As %String = "1") As %Status
{
	Set repid = $I(^CacheTemp)
	Set ind = 1
	Set qHandle = $ListBuild(0,repid,0)
 	k TempQryDictionary
 	Set aType = $ZCVT($g(aType),"U")
 	Set RowID = 0
 	For {
	 	Set RowID = $o(^DHCMed.SS.DictionaryI("IdxofType"," "_aType,RowID))
	 	Quit:RowID=""
	 	
	 	Set objDic = ##class(DHCMed.SS.Dictionary).GetObjById(RowID)
		If $IsObject(objDic) {
		 	Set Code = objDic.Code
			Set Description = objDic.Description
			Set Type = objDic.Type
			Continue:(aType'="")&&(aType'=$ZCVT($g(Type),"U"))
			
			Set Active = objDic.Active
			Continue:(aIsActive'="")&&(aIsActive'=Active)
			
			If (Active = "1") {
				Set Active = "Yes"
			} Else {
			  	Set Active = "No"
			}
			Set HospitalDr = objDic.HospitalDr
			Set HispsDescs = $p($g(^CT("HOSP",+HospitalDr)),"^",2)
			Set DateFrom = objDic.DateFrom
			Set DateTo = objDic.DateTo
			If (DateFrom '= "") {
				Set DateFrom = $zd(DateFrom,3)
			}
			If (DateTo '= "") {
		    	Set DateTo = $zd(DateTo,3)
			}
			Set Description = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description","",Description)	
			Set InNo = objDic.InNo
			Set xInNo = InNo
			Set:InNo="" xInNo="99999"
			Set:((Description["其他")&&(InNo="")) xInNo="999999"
			set Data = $ListBuild(RowID,Code,Description,Type,Active,HispsDescs,DateFrom,DateTo,HospitalDr,InNo)
			Set TempQryDictionary("IndexInNo",xInNo,RowID) = Data
			
			
		}
	}
	Set xInNo=""
	For{
		Set xInNo = $o(TempQryDictionary("IndexInNo",xInNo))
		Quit:xInNo=""
		Set xRowID=""
		For{
			Set xRowID = $o(TempQryDictionary("IndexInNo",xInNo,xRowID))
			Quit:xRowID=""
			Set Data = TempQryDictionary("IndexInNo",xInNo,xRowID)
			Set ^CacheTemp(repid,ind) = Data
	      	Set ind = ind + 1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryDictionaryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDictionaryExecute ]
{
	Set repid = $List(qHandle,2)
 	Kill ^CacheTemp(repid)
 	
	Quit $$$OK
}

ClassMethod QryDictionaryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDictionaryExecute ]
{
	Set AtEnd = $List(qHandle,1)
 	Set repid = $List(qHandle,2)
 	Set ind = $List(qHandle,3)
 	
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd = 1
 		Set Row = ""
 	} Else {
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	Set qHandle = $ListBuild(AtEnd,repid,ind)
 	
	Quit $$$OK
}

/// Creator：     chenjb
/// CreatDate：   2010-12-22
/// Description:  查询所有的字典或者字典项
/// Table：       DHCMed.SS.Dictionary
/// Input：       
/// output:       所有的字典或者某一个字典项      
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCMed.SSService.DictionarySrv","QryDictionary")
Query QrySSDictionary(type As %String) As %Query(ROWSPEC = "myid:%String,Code:%String,Description:%String,Type:%String,Active:%String,HispsDescs:%String,DateFrom:%String,DateTo:%String,HospDr:%String") [ SqlProc ]
{
}

ClassMethod QrySSDictionaryExecute(ByRef qHandle As %Binary, type As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s type=$ZCVT($g(type),"U")
 	/*
 	if (type="")
 	{
 		s type="SYS"
 	}
 	*/
    s type=" "_type
 	s myid=$o(^DHCMed.SS.DictionaryI("IdxofType",type,""))
 	
 	//s myid=$o(^DHCMed.SS.DictionaryD(""))
 	while (myid'="")
 	{
	s mydictionary=##class(DHCMed.SS.Dictionary).%OpenId(myid)
	if ($IsObject(mydictionary))
	{    
	    
		s Code=mydictionary.Code
		s Description=mydictionary.Description
		s TypeV=mydictionary.Type
		s Active=mydictionary.Active
		if (Active="1")
		{
			s Active="YES"  
			}
	    else
	    {
		  	s Active="NO"  
		    }
			    
		s HospitalDr=mydictionary.HospitalDr
		s HispsDescs=$p($g(^CT("HOSP",+HospitalDr)),"^",2)
		
		s DateFrom=mydictionary.DateFrom
		s DateTo=mydictionary.DateTo
		if (DateFrom'="")
		{
		s DateFrom=$zd(DateFrom,1)
		}
		if (DateTo'="")
		{
	    s DateTo=$zd(DateTo,1)
		}
		set Data=$lb(myid,Code,Description,TypeV,Active,HispsDescs,DateFrom,DateTo,HospitalDr)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
      
		  } 	
	   //  s myid=$o(^DHCMed.SS.DictionaryD(myid))
	   s myid=$o(^DHCMed.SS.DictionaryI("IdxofType",type,myid))
	 	}
	Quit $$$OK
}

ClassMethod QrySSDictionaryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySSDictionaryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySSDictionaryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySSDictionaryExecute ]
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

/// Creator：     maxp
/// CreatDate：   2016-04-18
/// Description:  根据基础字典类别,基础字典项目名称获取基础字典记录
/// Table：       DHCMed.SS.Dictionary
/// Input：       type：   类型
///               code： 代码
/// Return：      返回obj
/// w ##class(DHCMed.SSService.DictionarySrv).GetObjByTypeDesc("CRMZ","汉族")
ClassMethod GetObjByTypeDesc(argTypeCode As %String, argDesc As %String, argIsActive As %String = 1, Languages As %String = "") As %String
{
	New (argTypeCode,argDesc,argIsActive,%session,Languages)
	Set:Languages="" Languages = "CH"
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	Set return=""
	Quit:(argTypeCode="")||(argDesc="") return
	
	Set TypeCode=$ZCVT(argTypeCode,"U")
	Set Desc=$ZCVT(argDesc,"U")
	Set DicID=0
	For {
		Set DicID=$o(^DHCMed.SS.DictionaryI("IndexTypeDesc"," "_TypeCode," "_Desc,DicID))
		Quit:DicID=""
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(DicID)
		Continue:'$IsObject(objDic)
		Set Description=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,objDic.Description)
		Continue:Description'=argDesc
		Set IsActive=objDic.Active
		Continue:(argIsActive'="")&&(argIsActive'=IsActive)
		
		Set return=objDic
	}
	
	Quit return
}

/// w ##Class(DHCMed.SSService.DictionarySrv).GetIDByDesc("","AIM","旅游")
ClassMethod GetIDByDesc(argHosID As %String, argTypeCode As %String, argDesc As %String) As %String
{
	New (argHosID,argTypeCode,argDesc)
	Set return=""
	Quit:(argTypeCode="")||(argDesc="") return
	
	Set TypeCode=$ZCVT(argTypeCode,"U")
	Set Desc=$ZCVT(argDesc,"U")
	Set DicID=0
	For {
		Set DicID=$o(^DHCMed.SS.DictionaryI("IndexTypeDesc"," "_TypeCode," "_Desc,DicID))
		Quit:DicID=""
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(DicID)
		Continue:'$IsObject(objDic)
		Set Description=objDic.Description
		Continue:Description'=argDesc
		Set IsActive=objDic.Active
		Continue:IsActive'=1
		Set HosID=objDic.HospitalDr
		Continue:(argHosID'="")&&(HosID'=argHosID)
		Set DateFrom=objDic.DateFrom
		Set CurrDate=+$h
		Continue:(DateFrom'="")&&(DateFrom>CurrDate)
		Set DateTo=objDic.DateTo
		Continue:(DateTo'="")&&(DateTo<CurrDate)
		Set return=objDic.Code
	}
	
	Quit return
}

/// w ##Class(DHCMed.SSService.DictionarySrv).GetIDByTypeDesc("","DTHFamilyRelation","朋友")
ClassMethod GetIDByTypeDesc(argHosID As %String, argTypeCode As %String, argDesc As %String) As %String
{
	New (argHosID,argTypeCode,argDesc)
	Set return=""
	Quit:(argTypeCode="")||(argDesc="") return
	
	Set TypeCode=$ZCVT(argTypeCode,"U")
	Set Desc=$ZCVT(argDesc,"U")
	Set DicID=0
	For {
		Set DicID=$o(^DHCMed.SS.DictionaryI("IndexTypeDesc"," "_TypeCode," "_Desc,DicID))
		Quit:DicID=""
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(DicID)
		Continue:'$IsObject(objDic)
		Set Description=objDic.Description
		Continue:Description'=argDesc
		Set IsActive=objDic.Active
		Continue:IsActive'=1
		Set HosID=objDic.HospitalDr
		Continue:(argHosID'="")&&(HosID'=argHosID)
		Set DateFrom=objDic.DateFrom
		Set CurrDate=+$h
		Continue:(DateFrom'="")&&(DateFrom>CurrDate)
		Set DateTo=objDic.DateTo
		Continue:(DateTo'="")&&(DateTo<CurrDate)
		Set return=objDic.%Id()
	}
	
	Quit return
}

/// 根据字典类型获取每个有效的字典项描述
/// w ##Class(DHCMed.SSService.DictionarySrv).GetActiveByType("EpidemicReportStatus")
ClassMethod GetActiveByType(argTypeCode As %String) As %String
{
	New (argTypeCode)
	Set return=""
	Quit:(argTypeCode="") return
	
	Set TypeCode=$ZCVT(argTypeCode,"U")
	Set xDesc = ""
	For{
		Set xDesc=$o(^DHCMed.SS.DictionaryI("IndexTypeDesc"," "_TypeCode,xDesc))
		Quit:xDesc=""
		Set DicID=""
		For {
			Set DicID=$o(^DHCMed.SS.DictionaryI("IndexTypeDesc"," "_TypeCode,xDesc,DicID))
			Quit:DicID=""
			Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(DicID)
			Continue:'$IsObject(objDic)
			Set Description=objDic.Description
			Set IsActive=objDic.Active
			Set return = return_"!!"_Description_"^"_IsActive
		}
	}
	Set:return'="" return = $e(return,3,$l(return))
	Quit return
}

/// 查询字典树
/// Add By LiYang 2011-05-28 生成字典树
/// D ##class(%ResultSet).RunQuery("DHCMed.SSService.DictionarySrv","QryDictionaryTree","root-EPD")
Query QryDictionaryTree(Type As %String) As %Query(ROWSPEC = "id:%String,text:%String,icon:%String,leaf:%String") [ SqlProc ]
{
}

ClassMethod QryDictionaryTreeExecute(ByRef qHandle As %Binary, Type As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	set nodeType=$p(Type,"-",1)
 	if (nodeType="root") {
	 	set PorCode=$p(Type,"-",2)
	 	set rowid=""
	 	for {
		 	set rowid=$o(^DHCMed.SS.ProductsD(rowid))
		 	quit:rowid=""
		 	
		 	set objProduct=##class(DHCMed.SS.Products).%OpenId(rowid)
		 	continue:'$IsObject(objProduct)
		 	do objProduct.%Close()
		 	continue:objProduct.ProActive'=1
		 	if (PorCode'="")&&(PorCode'="SYS") {
			 	continue:PorCode'=objProduct.ProCode
			}
		 	set data=$lb("")
		 	set $li(data,1)="product-"_objProduct.ProCode
		 	set $li(data,2)=objProduct.ProName
		 	set iconFileName="menuconfig.gif"
		 	///set iconFileName=$s(objProduct.ProActive=1:"menuconfig.gif",1:"") 
		 	set $li(data,3)="../scripts/dhcmed/img/"_iconFileName
		 	set $li(data,4)=0
		 	set ^CacheTemp(repid,ind)=data
		 	set ind=ind+1
		 }
	}
	
	if (nodeType="product") {
	 	set PorCode=$p(Type,"-",2)
	 	set xProCode=""
	 	for {
			set xProCode=$o(^DHCMed.SS.DictionaryI("ProductCodeIndex",xProCode))
			quit:xProCode=""
			continue:$zcvt(PorCode,"U")'=$e(xProCode,2,$l(xProCode))
			set rowid=""
			for {
				set rowid=$o(^DHCMed.SS.DictionaryI("ProductCodeIndex",xProCode," SYS",rowid))
			 	quit:rowid=""
			 	set objDic=##class(DHCMed.SS.Dictionary).%OpenId(rowid)
			 	continue:'$IsObject(objDic)
			 	do objDic.%Close()
			 	set data=$lb("")
			 	set $li(data,1)="dicType-"_objDic.Code_"-"_objDic.%Id()
			 	set $li(data,2)=objDic.Description
			 	set iconFileName="menudic.gif"
			 	set $li(data,3)="../scripts/dhcmed/img/"_iconFileName
			 	set $li(data,4)=1
			 	set ^CacheTemp(repid,ind)=data
			 	set ind=ind+1
		 	}
		 }		
	}
	
	Quit $$$OK
}

ClassMethod QryDictionaryTreeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDictionaryTreeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDictionaryTreeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDictionaryTreeExecute ]
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

/// Creator：     PanLei
/// CreatDate：   2013-04-20
/// Description:  获取基础字典中有效的数据,组织成用,和^分割的字符串,重点应用在CheckboxGroup和RadioGroup
/// Table：       DHCMed_SS.Dictionary
/// Input：       aTypeCode:"NINFInfReportStatus"
/// Return：      "RowID^Description,RowID^Description,RowID^Description"
///               341^保存,342^提交,343^审核,344^取消审核,345^退回,346^删除,637^漏报
/// w ##class(DHCMed.SSService.DictionarySrv).GetActiveDicRowIDStr("NINFInfReportStatus")
ClassMethod GetActiveDicRowIDStr(aTypeCode As %String) As %String
{
	New (aTypeCode)
	Set return = ""
	Quit:aTypeCode="" return
	
	Set aSeparateDef = ..#SEPARATE
	Set aSeparate = ","
	
	Set $ZT="GetActiveDicRowIDStrErr"
	
	Set aTypeCode = $ZCVT(aTypeCode,"U")
	Set DicRowID = 0
	For {
		Set DicRowID = $o(^DHCMed.SS.DictionaryI("IdxofType"," "_aTypeCode,DicRowID))
		Quit:DicRowID=""
		
		Set objDic = ##class(DHCMed.SS.Dictionary).GetObjById(DicRowID)
		Continue:'$IsObject(objDic)
		
		// 仅加载标记为有效的基础字典数据
		Set Active = objDic.Active
		Continue:Active'=1
		
		Set RowID = objDic.%Id()
		Set Description = objDic.Description
		Set return = return_aSeparate_RowID_aSeparateDef_Description
	}
	Set:return'="" return=$Extract(return,2,$Length(return))
	Quit return
	
GetActiveDicRowIDStrErr
	Set return = -1
	Quit return
}

/// w ##Class(DHCMed.SSService.DictionarySrv).GetDicsByType("OperationType")
ClassMethod GetDicsByType(aType As %String, aActive As %String = "1") As %String
{
	New (aType,aActive,%session)
	Set return=""
	Set langid=20
	Set Languages = "CH"
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	Set aType=$ZCVT($g(aType),"U")
 	Set RowID=0
 	For {
	 	Set RowID=$o(^DHCMed.SS.DictionaryI("IdxofType"," "_aType,RowID))
	 	Quit:RowID=""
	 	Set objDic=##class(DHCMed.SS.Dictionary).%OpenId(RowID)
		If $IsObject(objDic){
		 	Set Code=objDic.Code
			Set Description=objDic.Description
			Set Description = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,Description)	
			Set Type=objDic.Type
			Continue:(aType'="")&&(aType'=$ZCVT($g(Type),"U"))
			Set Active=objDic.Active
			Continue:(aActive'="")&&(Active'=aActive)
			If (Active="1"){
				Set Active="Yes"  
			}Else{
			  	Set Active="No"
			}
			Set HospitalDr=objDic.HospitalDr
			Set HispsDescs=$p($g(^CT("HOSP",+HospitalDr)),"^",2)
			Set DateFrom=objDic.DateFrom
			Set DateTo=objDic.DateTo
			If (DateFrom'=""){
				Set DateFrom=$zd(DateFrom,1)
			}
			If (DateTo'=""){
		    	Set DateTo=$zd(DateTo,1)
			}
			
			Set return=return_RowID_$c(2)_Description_$c(1)
		}
		If objDic'="" Do objDic.%Close()
	}
	Set:return'="" return=$e(return,1,$l(return)-1)
	
	Quit return
}

/// 根据排序码展现字典
/// w ##Class(DHCMed.SSService.DictionarySrv).GetDicsByIndNo("HIVPeriods")
ClassMethod GetDicsByIndNo(aType As %String, aActive As %String = "1") As %String
{
	New (aType,aActive)
	Set return=""
	K TEMPDicIndNo
	Set aType=$ZCVT($g(aType),"U")
 	Set RowID=0
 	For {
	 	Set RowID=$o(^DHCMed.SS.DictionaryI("IdxofType"," "_aType,RowID))
	 	Quit:RowID=""
	 	Set objDic=##class(DHCMed.SS.Dictionary).%OpenId(RowID)
		If $IsObject(objDic){
		 	Set Code=objDic.Code
			Set Description=objDic.Description
			Set Type=objDic.Type
			Continue:(aType'="")&&(aType'=$ZCVT($g(Type),"U"))
			Set Active=objDic.Active
			Continue:(aActive'="")&&(Active'=aActive)
			If (Active="1"){
				Set Active="Yes"  
			}Else{
			  	Set Active="No"
			}
			Set HospitalDr=objDic.HospitalDr
			Set HispsDescs=$p($g(^CT("HOSP",+HospitalDr)),"^",2)
			Set DateFrom=objDic.DateFrom
			Set DateTo=objDic.DateTo
			If (DateFrom'=""){
				Set DateFrom=$zd(DateFrom,1)
			}
			If (DateTo'=""){
		    	Set DateTo=$zd(DateTo,1)
			}
			Set IndNo=objDic.InNo		// 排序码
			Set xInNo = IndNo
			Set:IndNo="" xInNo="99999"
			Set:((Description["其他")&&(xInNo="")) xInNo="999999"
			Set TEMPDicIndNo("IndexInNo",xInNo,RowID) = Description
		}
		
		If objDic'="" Do objDic.%Close()
	}
	
	Set aInNo=""
	For{
		Set aInNo = $o(TEMPDicIndNo("IndexInNo",aInNo))
		Quit:aInNo=""
		Set xRowID=""
		For{
			Set xRowID = $o(TEMPDicIndNo("IndexInNo",aInNo,xRowID))
			Quit:xRowID=""
			Set aDesc = TEMPDicIndNo("IndexInNo",aInNo,xRowID)
			Set return=return_xRowID_$c(2)_aDesc_$c(1)
		}
	}
	Set:return'="" return=$e(return,1,$l(return)-1)
	
	Quit return
}

/// Creator：     wuwj
/// CreatDate：   2010-04-14
/// Description:  查询所有的字典或者字典项
/// Table：       DHCMed.SS.Dictionary
/// Input：       
/// output:       所有的字典或者某一个字典项      
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCMed.SSService.DictionarySrv","QryDicToCbo","SMDREPTYPE","^全部类型","2")
Query QryDicToCbo(aDicType As %String, aAddItem As %String = "", aHospID As %String = "") As %Query(ROWSPEC = "DicRowId:%String,DicCode:%String,DicDesc:%String")
{
}

ClassMethod QryDicToCboExecute(ByRef qHandle As %Binary, aDicType As %String, aAddItem As %String, aHospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set aDicType=$ZCVT(aDicType,"U")
 	Quit:aDicType="" $$$OK
 	
 	//add by zf 20130225 增加附加选项
	If aAddItem'="" {
		Set addItemCode=$p(aAddItem,"^",1)
		Set addItemDesc=$p(aAddItem,"^",2)
		If addItemDesc'="" {
			Set:addItemDesc="-" addItemDesc="" //空白项为空值 将"-"替换为"",避免误会"-"为已填
			Set Data=$lb(addItemCode,addItemCode,addItemDesc)
	    	Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
 	Set DicRowID=0
 	For {
	 	Set DicRowID=$o(^DHCMed.SS.DictionaryI("IdxofType"," "_aDicType,DicRowID))
	 	Quit:DicRowID=""
	 	
	 	Set objDic=##class(DHCMed.SS.Dictionary).%OpenId(DicRowID)
		If $IsObject(objDic){
		 	Set DicCode=objDic.Code
			Set DicDesc=objDic.Description
			Set DicDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description","",DicDesc)
			Set DicType=objDic.Type
			Continue:(aDicType'="")&&(aDicType'=$ZCVT(DicType,"U"))
			Set DicActive=objDic.Active
			Continue:DicActive'=1
			Set HospID=objDic.HospitalDr
			Continue:(aHospID'="")&&(HospID'=0)&&(aHospID'=HospID)   //add by jiangpengpeng 2015-06-18
			
			Set Data=$lb(DicRowID,DicCode,DicDesc)
	        Set ^CacheTemp(repid,ind)=Data
	        Set ind=ind+1
		}
		If objDic'="" Do objDic.%Close()
	}
	
	Quit $$$OK
}

ClassMethod QryDicToCboClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDicToCboExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDicToCboFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDicToCboExecute ]
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

Storage Default
{
}

/// Creator：     pylian
/// CreatDate：   2018-08-31
/// Description:  根据基础字典类别,基础字典项目代码获取基础字典记录
/// Table：       DHCMed.SS.Dictionary
/// Input：       argType:基础字典类别
///               argCode:基础字典项目代码
///               argIsActive:是否有效,0-无效,1-有效
/// Return：      返回obj
/// W ##class(DHCMed.SSService.DictionarySrv).GetObjByCode("EPIDEMICREPORTSTATUS","6","1")
ClassMethod GetObjByCode(argType As %String, argCode As %String, argIsActive As %String) As DHCMed.SS.Dictionary
{
	New (argType,argCode,argIsActive)
	Set return = "{}"
	
	Set obj =##class(DHCMed.SS.Dictionary).GetByTypeCode(argType,argCode,argIsActive)
	Quit:obj="" return
	Set return=obj
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2018-10-16
/// Description:  修改获取基础字典记录返回对象的方法
/// Table：       DHCMed.SS.Dictionary
/// Input：       ID: DHCMed.SS.Dictionary
/// Return：      返回obj
/// W ##class(DHCMed.SSService.DictionarySrv).GetObjById("1")
ClassMethod GetObjById(aID As %String) As DHCMed.SS.Dictionary
{
	New (aID)
	Set return = "{}"
	
	Set obj =##class(DHCMed.SS.Dictionary).GetObjById(aID)
	Quit:obj="" return
	Set return=obj
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2018-11-5
/// Description:  根据基础字典类别,基础字典项目名称获取基础字典记录
/// Table：       DHCMed.SS.Dictionary
/// Input：       argType:基础字典类别
///               argCode:基础字典项目代码
///               argIsActive:是否有效,0-无效,1-有效
/// Return：      返回obj
/// W ##class(DHCMed.SSService.DictionarySrv).GetObjByCode("DTCSex","女","1")
ClassMethod GetObjByDesc(argType As %String, argDesc As %String, argIsActive As %String) As DHCMed.SS.Dictionary
{
	New (argType,argDesc,argIsActive,%session)
	Set Languages = "CH"
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	Set return = "{}"
	Quit:(argType="")||(argDesc="") return
	
	Set obj =##class(DHCMed.SSService.DictionarySrv).GetObjByTypeDesc(argType,argDesc,argIsActive,Languages)
	Quit:obj="" return
	Set return=obj
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-12-05
/// Description:  根据基础字典类别,基础字典项目名称获取基础字典记录
/// Table：       DHCMed.SS.Dictionary
/// Input：       argType:基础字典类别
///               argCode:基础字典项目代码
///               argIsActive:是否有效,0-无效,1-有效
/// Return：      返回obj
/// W ##class(DHCMed.SSService.DictionarySrv).GetDicByDesc("DTCSex","女","1")
ClassMethod GetDicByDesc(argType As %String, argDesc As %String, argIsActive As %String) As DHCMed.SS.Dictionary
{
	New (argType,argDesc,argIsActive,%session)
	Set Languages = "CH"
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	Set return = "{}"
	Quit:(argType="")||(argDesc="") return
	
	Set TypeCode=$ZCVT(argType,"U")
	Set Desc=$ZCVT(argDesc,"U")
	Set DicID=0
	For {
		Set DicID=$o(^DHCMed.SS.DictionaryI("IndexTypeDesc"," "_TypeCode," "_Desc,DicID))
		Quit:DicID=""
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(DicID)
		Continue:'$IsObject(objDic)
		Set Description=objDic.Description
		Continue:Description'=argDesc
		Set Code=objDic.Code
		Set IsActive=objDic.Active
		Continue:IsActive'=argIsActive
		Set return=DicID_"^"_Code_"^"_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,Description)
	}
	
	Quit return
}

/// liuzhenhe add by 2019-12-30 for update
/// W ##class(DHCMed.SSService.DictionarySrv).GetDicByDesc()
ClassMethod ImportDict(InStr As %String, separete As %String) As %String
{
	New (InStr,separete)
	Set return=0
	Quit:InStr="" return
	Set:$g(separete)="" separete=..#SEPARATE

	Set Code=$p(InStr,separete,2)
	Set TypeCode=$p(InStr,separete,4)
	Set tID=$o(^DHCMed.SS.DictionaryI("IndexTypeCode"," "_$ZCVT(TypeCode,"U")," "_$ZCVT(Code,"U"),0))
	Set $p(InStr,separete,1)=tID
	Set return=##class(DHCMed.SS.Dictionary).Update(InStr,separete)
	Quit return
}

}
