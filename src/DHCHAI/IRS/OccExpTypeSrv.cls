/// 名称: DHCHAI.IRS.OccExpTypeSrv
/// 描述: 职业暴露类型服务
/// 编写者：pylian
/// 编写日期: 2018-05-10
Class DHCHAI.IRS.OccExpTypeSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2018-05-10
/// Description:  查询职业暴露类型
/// Table：       DHCHAI.IR.OccExpType
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCHAI.IRS.OccExpTypeSrv","QryOccExpType","")
Query QryOccExpType(aActive As %String = "", aRegTypeID As %String = "") As %Query(ROWSPEC = "ID:%String,BTCode:%String,BTDesc:%String,IsActive:%String,IsActDesc:%String,Resume:%String") [ SqlProc ]
{
}

ClassMethod QryOccExpTypeExecute(ByRef qHandle As %Binary, aActive As %String = "", aRegTypeID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
		
	Set xID=0	
	For {
		Set xID=$o(^DHCHAI.IR.OccExpTypeD(xID))
		Quit:xID=""
		
		Continue:(aRegTypeID'="")&&(aRegTypeID'=xID)
		Set objExpType = ##class(DHCHAI.IR.OccExpType).GetObjById(xID)
		Continue:'$Isobject(objExpType)
		Set Code 	  = objExpType.BTCode	   
	    Set Desc 	  = objExpType.BTDesc	   	
	    Set IsActive  = objExpType.BTIsActive
	    Continue:(aActive'="")&&(aActive'=IsActive)
		Set IsActDesc = $s(IsActive=1:"是",1:"否")
	    Set Resume    = objExpType.BTResume
	 	
	 	//多语言处理
	 	Set Desc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",Desc,"DHCHAI.IR.OccExpType")
		Set Data=$lb(xID,Code,Desc,IsActive,IsActDesc,Resume)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	
	
	Quit $$$OK
}

ClassMethod QryOccExpTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOccExpTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOccExpTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOccExpTypeExecute ]
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

/// Creator：     pylian
/// CreatDate：   2018-05-10
/// Description:  查询职业暴露扩展项目
/// Table：       DHCHAI.IR.OccExpTypeExt
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCHAI.IRS.OccExpTypeSrv","QryOccExpTypeExt","")
Query QryOccExpTypeExt(aTypeID As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,TypeID:%String,TypeCode:%String,TypeDesc:%String,DatID:%String,DatCode:%String,DatDesc:%String,DicID:%String,DicCode:%String,DicDesc:%String,IsRequired:%String") [ SqlProc ]
{
}

ClassMethod QryOccExpTypeExtExecute(ByRef qHandle As %Binary, aTypeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aTypeID="" $$$OK
		
	Set xCode=""
	For{
		Set xCode=$o(^DHCHAI.IR.OccExpTypeI("EXT","IndexCode",aTypeID,xCode))
		Quit:xCode=""
		
		Set xID=0
		For{
			Set xID=$o(^DHCHAI.IR.OccExpTypeI("EXT","IndexCode",aTypeID,xCode,xID))
			Quit:xID=""
			
			Set ExtID=aTypeID_"||"_xID
			Set objEXT = ##class(DHCHAI.IR.OccExpTypeExt).GetObjById(ExtID)
			Continue:'$Isobject(objEXT)
			Set Code 	  = objEXT.BTCode	   
	    	Set Desc 	  = objEXT.BTDesc
	    	Set IsRequired = objEXT.BTIsRequired
	    	Set (TypeID,TypeCode,TypeDesc) = ""
	
			If $IsObject(objEXT.BTExtType) {	
				Set TypeID =  objEXT.BTExtType.%Id()  
				Set TypeCode = objEXT.BTExtType.BTCode
				Set TypeDesc = objEXT.BTExtType.BTDesc
	    	}	
	    	Set (DatID,DatCode,DatDesc) = ""
			If $IsObject(objEXT.BTDatType) {	
				Set DatID =  objEXT.BTDatType.%Id()  
				Set DatCode = objEXT.BTDatType.BTCode
				Set DatDesc = objEXT.BTDatType.BTDesc
	    	}
	    	Set (DicID,DicCode,DicDesc) = ""
			If $IsObject(objEXT.BTDicType) {	
				Set DicTypeID =  objEXT.BTDicType.%Id()  
				Set DicTypeCode = objEXT.BTDicType.BTCode
				Set DicTypeDesc = objEXT.BTDicType.BTDesc
				Set objDic=##class(DHCHAI.BT.Dictionary).GetObjByCode("OEDicType",DicTypeCode)
				If $IsObject(objDic) {
					Set DicID =  objDic.%Id()  
					Set DicCode = objDic.BTCode
					Set DicDesc = objDic.BTDesc
				}
	    	}
			Set Data=$lb(ExtID,Code,Desc,TypeID,TypeCode,TypeDesc,DatID,DatCode,DatDesc,DicID,DicCode,DicDesc,IsRequired)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryOccExpTypeExtClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOccExpTypeExtExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOccExpTypeExtFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOccExpTypeExtExecute ]
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

/// Creator：     ShenC
/// CreatDate：   2021-08-26
/// Description:  查询职业暴露扩展项目分类[新]
/// Table：       DHCHAI.IR.OccExpTypeExt
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCHAI.IRS.OccExpTypeSrv","QryExpRegType","1")
Query QryExpRegType(aRegTypeID As %String, aExtTypeID As %String = "") As %Query(ROWSPEC = "TypeID:%String,TypeCode:%String,TypeDesc:%String,IndNo:%String") [ SqlProc ]
{
}

ClassMethod QryExpRegTypeExecute(ByRef qHandle As %Binary, aRegTypeID As %String, aExtTypeID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aRegTypeID="") $$$OK
	//定义临时Global
	Set NIndex="QryExpRegType"
	Kill ^TMP($zn,$j,NIndex)
	
	Set xTypeID=0	
	For {
		Set xTypeID=$o(^DHCHAI.IR.OccExpTypeI("EXT","IndexType",aRegTypeID,xTypeID))
		Quit:xTypeID=""
	   
	    Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(xTypeID)
	    Continue:'$Isobject(objDic)
		Set TypeCode = objDic.BTCode
		Continue:(aExtTypeID'="")&&(TypeCode'[("-"_aExtTypeID))		//过滤类别
		Set TypeDesc = objDic.BTDesc
        Set IndNo    = objDic.BTIndNo
        Set:IndNo="" IndNo="999-"_TypeCode
        //存储数据
        Set Data=$lb(xTypeID,TypeCode,TypeDesc,IndNo)
        Set ^TMP($zn,$j,NIndex,"IndNo",IndNo)=Data
	}
	//按排序码输出数据
	Set xIndNo=""
	For{
		Set xIndNo=$o(^TMP($zn,$j,NIndex,"IndNo",xIndNo))
		Quit:xIndNo=""
		
		Set Data=$g(^TMP($zn,$j,NIndex,"IndNo",xIndNo))
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryExpRegTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryExpRegTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryExpRegTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryExpRegTypeExecute ]
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

/// Creator：     pylian
/// CreatDate：   2018-06-14
/// Description:  根据项目分类查询职业暴露扩展项目
/// Table：       DHCHAI.IR.OccExpTypeExt
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCHAI.IRS.OccExpTypeSrv","QryExtByType","1","1")
Query QryExtByType(aTypeID As %String, aExtTypeID As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,TypeID:%String,TypeCode:%String,TypeDesc:%String,DatID:%String,DatCode:%String,DatDesc:%String,DicID:%String,DicCode:%String,DicDesc:%String,IsRequired:%String") [ SqlProc ]
{
}

ClassMethod QryExtByTypeExecute(ByRef qHandle As %Binary, aTypeID As %String, aExtTypeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aTypeID="")||(aExtTypeID="") $$$OK
	//定义临时Global
	Set NIndex="QryExtByType"
	Kill ^TMP($zn,$j,NIndex)
	
	Set xID=0	
	For {
		Set xID=$o(^DHCHAI.IR.OccExpTypeI("EXT","IndexType",aTypeID,aExtTypeID,xID))
		Quit:xID=""
		
		Set ExtID=aTypeID_"||"_xID
		Set objEXT = ##class(DHCHAI.IR.OccExpTypeExt).GetObjById(ExtID)
		Continue:'$Isobject(objEXT)
		Set Code 	  = objEXT.BTCode	   
	    Set Desc 	  = objEXT.BTDesc
	    Set IsRequired = objEXT.BTIsRequired
	   
	    Set (TypeID,TypeCode,TypeDesc) = ""
		If $IsObject(objEXT.BTExtType) {	
			Set TypeID =  objEXT.BTExtType.%Id()  
			Set TypeCode = objEXT.BTExtType.BTCode
			Set TypeDesc = objEXT.BTExtType.BTDesc
	    }	
	    Set (DatID,DatCode,DatDesc) = ""
		If $IsObject(objEXT.BTDatType) {	
			Set DatID =  objEXT.BTDatType.%Id()  
			Set DatCode = objEXT.BTDatType.BTCode
			Set DatDesc = objEXT.BTDatType.BTDesc
	    }
	    Set (DicID,DicCode,DicDesc) = ""
		If $IsObject(objEXT.BTDicType) {	
			Set DicTypeID =  objEXT.BTDicType.%Id()  
			Set DicTypeCode = objEXT.BTDicType.BTCode
			Set DicTypeDesc = objEXT.BTDicType.BTDesc
			Set objDic=##class(DHCHAI.BT.Dictionary).GetObjByCode("OEDicType",DicTypeCode)
			If $IsObject(objDic) {
				Set DicID =  objDic.%Id()  
				Set DicCode = objDic.BTCode
				Set DicDesc = objDic.BTDesc
			}
	    }
	    //多语言处理
	    Set DicDesc =##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",DicDesc,"DHCHAI.BT.Dictionary")
		Set Data=$lb(ExtID,Code,Desc,TypeID,TypeCode,TypeDesc,DatID,DatCode,DatDesc,DicID,DicCode,DicDesc,IsRequired)
		//按Code排序
		Set IndCode=Code
		Set:IndCode="" IndCode="999999"
		Set ^TMP($zn,$j,NIndex,"IndCode",IndCode)=Data
	}
	//按排序码输出数据
	Set xIndCode=""
	For{
		Set xIndCode=$o(^TMP($zn,$j,NIndex,"IndCode",xIndCode))
		Quit:xIndCode=""
		
		Set Data=$g(^TMP($zn,$j,NIndex,"IndCode",xIndCode))
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryExtByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryExtByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryExtByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryExtByTypeExecute ]
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

/// Creator：     pylian
/// CreatDate：   2018-05-10
/// Description:  查询职业暴露血清学检查计划
/// Table：       DHCHAI.IR.OccExpTypeLab
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCHAI.IRS.OccExpTypeSrv","QryOccExpTypeLab","")
Query QryOccExpTypeLab(aTypeID As %String, aIsActive As %String = "") As %Query(ROWSPEC = "ID:%String,BTDesc:%String,BTIndNo:%String,BTDays:%String,IsActive:%String,IsActDesc:%String,Resume:%String,LabItemDr:%String,LabItem:%String,LabType:%String") [ SqlProc ]
{
}

ClassMethod QryOccExpTypeLabExecute(ByRef qHandle As %Binary, aTypeID As %String, aIsActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aTypeID="" $$$OK
	Set NIndex="QryOccExpTypeLab"
	Kill ^TMP($zn,$j,NIndex)	
	Set xID=0	
	For {
		Set xID=$o(^DHCHAI.IR.OccExpTypeD(aTypeID,"LAB",xID))
		Quit:xID=""
		
		Set LabID=aTypeID_"||"_xID
		Set objLAB = ##class(DHCHAI.IR.OccExpTypeLab).GetObjById(LabID)
		Continue:'$Isobject(objLAB)
	   
	    Set Desc 	  = objLAB.BTDesc
	    Set IndNo 	  = objLAB.BTIndNo
	    Set:IndNo="" IndNo="0"	//解决为空报错
	    
	    Set Days 	  = objLAB.BTDays
	    Set IsActive  = objLAB.BTIsActive
		Set IsActDesc = $s(IsActive=1:"是",1:"否")
		Continue:(aIsActive=1)&(IsActive'=1)
	    Set Resume    = objLAB.BTResume
	    Set LabItemDr="",LabItem=""
	    If $IsObject(objLAB.BTExtItemDr) {	
			Set LabItemDr = objLAB.BTExtItemDr.%Id()  
			Set LabItem   = objLAB.BTExtItemDr.BTTSDesc
	    }
	 	Set LabType="LAB"
	 	Set:Desc["HBV" LabType="HBV" 
	 	Set:Desc["HCV" LabType="HCV" 
	 	Set:Desc["HIV" LabType="HIV" 
	 	Set:Desc["梅毒" LabType="MD" 	
	 	//多语言处理	 	
	 	Set Desc = ##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",Desc,"DHCHAI.IR.OccExpTypeLab")
		Set ^TMP($zn,$j,NIndex,"IndNo",IndNo,LabID)=$lb(LabID,Desc,IndNo,Days,IsActive,IsActDesc,Resume,LabItemDr,LabItem,LabType)
	}
	Set xIndNo=""
	For {
		Set xIndNo=$o(^TMP($zn,$j,NIndex,"IndNo",xIndNo))
		Quit:xIndNo=""
		
		Set xLabID=""
		for{
			Set xLabID=$o(^TMP($zn,$j,NIndex,"IndNo",xIndNo,xLabID))
			Quit:xLabID=""
		
			Set Data=$g(^TMP($zn,$j,NIndex,"IndNo",xIndNo,xLabID))
			Continue:Data=""
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryOccExpTypeLabClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOccExpTypeLabExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOccExpTypeLabFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOccExpTypeLabExecute ]
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

/// Creator：     lyao
/// CreatDate：   2019-03-01
/// Description:  查询暴露感染筛查规则
/// Table：       DHCHAI.IR.OccExpTypeEpd
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.OccExpTypeSrv","QryOccExpTypeEpd",1)
Query QryOccExpTypeEpd(aTypeID As %String) As %Query(ROWSPEC = "ID:%String,BTDesc:%String,EpdTypeID:%String,EpdTypeDesc:%String,LabEpdDesc:%String,LabItemID:%String,LabItemDesc:%String,LabOperID:%String,LabOperator:%String,LabItemRst:%String,LabItemID2:%String,LabItemDesc2:%String,LabOperID2:%String,LabOperator2:%String,LabItemRst2:%String,IsActive:%String,ActDate:%String,ActTime:%String,ActUser:%String,Note:%String") [ SqlProc ]
{
}

ClassMethod QryOccExpTypeEpdExecute(ByRef qHandle As %Binary, aTypeID As %String) As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aTypeID="" $$$OK
	
	Set xID=""
	For{
		Set xID=$o(^DHCHAI.IR.OccExpTypeD(aTypeID,"Epd",xID))
	    Quit:xID=""
	    
	    Set ID=aTypeID_"||"_xID
		Set objEpd=##class(DHCHAI.IR.OccExpTypeEpd).GetObjById(ID)
		Continue:'$Isobject(objEpd)
		Continue:'$Isobject(objEpd.BTEpdTypeDr)
		
		Set (BTDesc,EpdTypeID,EpdTypeDesc,LabEpdDesc,LabItemID,LabItemDesc,LabOperID,LabOperator,LabItemRst,LabItemID2,LabItemDesc2,LabOperID2,LabOperator2,LabItemRst2,IsActive,ActDate,ActTime,ActUser,Note)=""
		
		Set BTDesc      = objEpd.BTDesc  //筛查规则描述
		Set EpdTypeID   = objEpd.BTEpdTypeDr.%Id() //感染类型
		Set EpdTypeDesc = objEpd.BTEpdTypeDr.BTDesc //感染类型
		Set IsActive    = objEpd.BTIsActive   //是否有效
		Set Note        = objEpd.BTNote     //备注
		Set ActDate     = objEpd.BTActDate  //日期
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		Set ActTime     = objEpd.BTActTime  // 时间
	    Set:ActTime'="" ActTime=$zt(ActTime,1)
	    If $IsObject(objEpd.BTActUser){
			Set ActUser   = objEpd.BTActUser.BTDesc
	    }
		
		If $IsObject(objEpd.BTLabItemDr){
			Set LabItemID   = objEpd.BTLabItemDr.%Id() //检验项目1
			Set LabItemDesc = objEpd.BTLabItemDr.BTTestDesc //检验项目1
		}
		If $IsObject(objEpd.BTLabOperator){
			Set LabOperID   = objEpd.BTLabOperator.%Id() //比较运算符1
			Set LabOperator = objEpd.BTLabOperator.BTDesc //比较运算符1
		}
		Set LabItemRst  = objEpd.BTLabItemRst  //结果1
		Set:LabItemDesc'="" LabEpdDesc=LabItemDesc_" "_LabOperator_" "_LabItemRst
		
		If $IsObject(objEpd.BTLabItem2Dr){
			Set LabItemID2   = objEpd.BTLabItem2Dr.%Id() //检验项目1
			Set LabItemDesc2 = objEpd.BTLabItem2Dr.BTTestDesc //检验项目1
		}
		If $IsObject(objEpd.BTLabOperator2){
			Set LabOperID2   = objEpd.BTLabOperator.%Id() //比较运算符1
			Set LabOperator2 = objEpd.BTLabOperator2.BTDesc //比较运算符1
		}
		Set LabItemRst2  = objEpd.BTLabItem2Rst  //结果1
		Set:LabItemDesc2'="" LabEpdDesc="("_LabEpdDesc_") && ("_LabItemDesc2_" "_LabOperator2_" "_LabItemRst2_")"
		
		Set Data=$lb(ID,BTDesc,EpdTypeID,EpdTypeDesc,LabEpdDesc,LabItemID,LabItemDesc,LabOperID,LabOperator,LabItemRst,LabItemID2,LabItemDesc2,LabOperID2,LabOperator2,LabItemRst2,IsActive,ActDate,ActTime,ActUser,Note)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryOccExpTypeEpdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOccExpTypeEpdExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryOccExpTypeEpdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOccExpTypeEpdExecute ]
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
