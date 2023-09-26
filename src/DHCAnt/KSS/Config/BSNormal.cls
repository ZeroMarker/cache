/// CTOR: QP
/// DATE: 2019-04-16
/// DESC: 抗菌药物常规设置
Class DHCAnt.KSS.Config.BSNormal Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2019-04-16
/// DESC: 保存设置
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCAnt.KSS.Config.BSNormal).DBSave(^TEMP("qp",1))
ClassMethod DBSave(BSNoramlXML As %String, InHosp As %String = "")
{
	n (BSNoramlXML,InHosp,%session)
	s ^TEMP("qp",1)=BSNoramlXML
	s ^TEMP("qp",2)=InHosp
	s errCode=0
	i InHosp="" s InHosp=%session.Get("LOGON.HOSPID")
	s BSNormalDTO=##class(DHCAnt.Base.Dto.BSNoraml).%New()
	d BSNormalDTO.XMLNodeDeserialize(.BSNormalDTO, "BSNoraml", BSNoramlXML)
	TS
	s BSNoramlEntity=##class(DHCAnt.Util.Common).GetClassPropertyList("DHCAnt.Base.Dto.BSNoraml")
	s Len=$l(BSNoramlEntity,"^")
	f i=2:1:Len {
		q:errCode'=0
		s cName=$p(BSNoramlEntity,"^",i)
		s ExitPro=BSNoramlXML[("<"_cName_">")
		Continue:ExitPro'=1		;如果xml中不存在的属性不更新
		s cValue=$ZOBJPROPERTY(BSNormalDTO, cName)
		s cForce=1
		//i (cName="LABOECATE") {
		//	s cForce=0
		//}
		s cResult=##class(DHCAnt.Base.MainConfigExcute).SetValueByMCGCodeNew(cName,cValue,cForce,InHosp)
		i cResult'=1 s errCode="-101^"_cName
	}
	//TC
	i errCode'=0 {
		tro
		Q errCode	
	}
	TC 
	q errCode
}

/// CTOR: QP
/// DATE: 2019-04-16
/// DESC: 获取设置
/// IN  : 1:IE 2:Chrome
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCAnt.KSS.Config.BSNormal).GetBSNormalSetting(2,3)
ClassMethod GetBSNormalSetting(isIE, inHosp)
{
	n (isIE,inHosp)
	s mRtn=""
	s BSNoramlEntity=##class(DHCAnt.Util.Common).GetClassPropertyList("DHCAnt.Base.Dto.BSNoraml")
	s Len=$l(BSNoramlEntity,"^")
	if (isIE=1) {
		s WebBSNormalDTO=##class(DHCAnt.Base.Dto.BSNoraml).%New()
		f i=2:1:Len {
			s cName=$p(BSNoramlEntity,"^",i)
			s cValue=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode(cName)
			s $ZOBJPROPERTY(WebBSNormalDTO, cName)=cValue
		}
	
		d WebBSNormalDTO.XMLExportToString(.mRtn)
	}elseif (isIE=2) {
		s mRtn="[{"
		f i=2:1:Len {
			s cName=$p(BSNoramlEntity,"^",i)
			s cValue=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode(cName,inHosp)
			i i=2 s mRtn=mRtn_""""_cName_""":"""_cValue_""""
			e  s mRtn=mRtn_","""_cName_""":"""_cValue_""""
			
		}
		s mRtn=mRtn_"}]"
	}else{
		//todo	
	
	}
	Q mRtn
}

/// CTOR: QP
/// DATE: 2019-04-16
/// DESC: 查询Multiple数据项
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCAnt.KSS.Config.BSNormal","QryMultipleData","UPMYF","OBJ")
Query QryMultipleData(MType As %String = "", ParID = "", InHosp = "") As %Query(ROWSPEC = "id:%String,code:%String,desc:%String")
{
}

ClassMethod QryMultipleDataExecute(ByRef qHandle As %Binary, MType As %String = "", ParID = "", InHosp = "") As %Status
{
	Set repid=$I(^CacheTemp)
    Set ind=1
    
    i MType="OEType" {
    	s id=0
    	f  s id=$o(^OECPR(id)) q:id=""  d
    	.s code=$p(^OECPR(id),"^",1)
    	.q:(code'="S")&&(code'="OMST")
    	.s desc=$p(^OECPR(id),"^",2)
    	.d OutputRowQryMultipleData
    }
    
    i MType="OEItemCat" {
    	s id=0
 		f  s id=$o(^ARC("IC",id)) q:id=""  d
 		.s desc=$p(^ARC("IC",id),"^",2)
 		.q:##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItemCat",id,InHosp)="N"
 		.s code=""
 		.d OutputRowQryMultipleData
    }
    i (MType="UPMZL") {
    	s id=0
    	s PDCType=""
 		i ParID="USE" s PDCType="AIM"
 		i ParID="ITEM" s PDCType="AIMITEM"
 		i ParID="OBJ" s PDCType="OBJ"
 		i PDCType="" {
	 		Set qHandle=$lb(0,repid,0)
	 		Quit $$$OK
 		}
 		f  s id=$o(^DHCAntBasePurposeDataConfigI("PDCType",PDCType,id)) q:id=""  d
 		.s code=""
 		.s objDesc="",objCode=""
 		.i (PDCType="AIMITEM")||(PDCType="AIM") d
 		..s objDr=$p(^DHCAntBasePurposeDataConfigD(id),"^",6)
 		..i objDr'="" d
 		...s objDesc=$p(^DHCAntBasePurposeDataConfigD(objDr),"^",3)
 		...s objCode=$p(^DHCAntBasePurposeDataConfigD(objDr),"^",4)
 		.s code=$p(^DHCAntBasePurposeDataConfigD(id),"^",4)
 		.s active=$p(^DHCAntBasePurposeDataConfigD(id),"^",5)
 		.q:active'=1
 		.i (PDCType="OBJ") s objCode=code
 		.q:(objCode'="ZL")
 		.s desc=$p(^DHCAntBasePurposeDataConfigD(id),"^",3)
 		.i (objDesc'="")&&(PDCType="AIMITEM") s desc=objDesc_"-"_desc
 		.d OutputRowQryMultipleData
    }
    i (MType="UPMYF") {
    	s id=0
    	s PDCType=""
 		i ParID="USE" s PDCType="AIM"
 		i ParID="ITEM" s PDCType="AIMITEM"
 		i ParID="OBJ" s PDCType="OBJ"
 		i PDCType="" {
	 		Set qHandle=$lb(0,repid,0)
	 		Quit $$$OK
 		}
 		f  s id=$o(^DHCAntBasePurposeDataConfigI("PDCType",PDCType,id)) q:id=""  d
 		.s code=""
 		.s objDesc="",objCode=""
 		.i (PDCType="AIMITEM")||(PDCType="AIM") d
 		..s objDr=$p(^DHCAntBasePurposeDataConfigD(id),"^",6)
 		..i objDr'="" d
 		...s objCode=$p(^DHCAntBasePurposeDataConfigD(objDr),"^",4)
 		...s objDesc=$p(^DHCAntBasePurposeDataConfigD(objDr),"^",3)
 		.s code=$p(^DHCAntBasePurposeDataConfigD(id),"^",4)
 		.i (PDCType="OBJ") s objCode=code
 		.q:(objCode'="YF")
 		.s desc=$p(^DHCAntBasePurposeDataConfigD(id),"^",3)
 		.i (objDesc'="")&&(PDCType="AIMITEM") s desc=objDesc_"-"_desc
 		.d OutputRowQryMultipleData
    }
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowQryMultipleData
	set Data=$lb(id,code,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QryMultipleDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMultipleDataExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryMultipleDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMultipleDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
