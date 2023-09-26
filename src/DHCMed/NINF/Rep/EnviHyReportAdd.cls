/// 名称: DHCMed.NINF.Rep.EnviHyReportAdd
/// 描述: 环境卫生学报告补充
/// 编写者：
/// 编写日期: 
Class DHCMed.NINF.Rep.EnviHyReportAdd Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 日期
Property RepDate As %String(TRUNCATE = 1) [ Required ];

/// 科室
Property RepLoc As %String(TRUNCATE = 1) [ Required ];

/// 填报人
Property RepUser As %String(TRUNCATE = 1);

/// 检测项目
Property RepItem As DHCMed.SS.Dictionary;

/// 项目值
Property RepValue As %String(TRUNCATE = 1);

/// 项目值单位("NINFEnviHyNormUom")
Property RepUom As DHCMed.SS.Dictionary;

/// 备注
Property Resume As %String(TRUNCATE = 1);

Index IndexDateLoc On (RepDate As Exact, RepLoc As Exact);

/// w ##class(DHCMed.NINF.Rep.EnviHyReportAdd).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Dic.EnviHyItem
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Rep.EnviHyReportAdd).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// w ##Class(DHCMed.NINF.Rep.EnviHyReportAdd).Update("^01^非洁净区空气^^1^","^")
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	 
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set ID=$p(aInput,aSeparate,1)
	If (ID="") {
		Set obj=##class(DHCMed.NINF.Rep.EnviHyReportAdd).%New()
	} Else {
		Set obj=##class(DHCMed.NINF.Rep.EnviHyReportAdd).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set RepDate = $p(aInput,aSeparate,2)
	;Set:RepDate["-" RepDate=$zdh(RepDate,3)
	;Set:RepDate["/" RepDate=$zdh(RepDate,4)
	Set:RepDate'="" RepDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(RepDate)
	Set obj.RepDate=RepDate
	Set obj.RepLoc=$p(aInput,aSeparate,3)
	Set obj.RepUser=$p(aInput,aSeparate,4)
	Set obj.RepItem=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,5))
	Set obj.RepValue=+$p(aInput,aSeparate,6)
	Set obj.RepUom=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,7))
	Set obj.Resume=$p(aInput,aSeparate,8)
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Rep.EnviHyReportAdd).%DeleteId(+aId)
	If $System.Status.IsError(sc) { 
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// D ##class(%ResultSet).RunQuery("DHCMed.NINF.Rep.EnviHyReportAdd","QryEnviHyRepAdd","2014-01-13","")
Query QryEnviHyRepAdd(aDate As %String, aLoc As %String) As %Query(ROWSPEC = "RepAddID:%String,LocID:%String,LocDesc:%String,RepUserDesc:%String,RepItemID:%String,RepItemDesc:%String,RepValue:%String,RepUomID:%String,RepUomDesc:%String,Resume:%String,aDate:%String") [ SqlProc ]
{
}

ClassMethod QryEnviHyRepAddExecute(ByRef qHandle As %Binary, aDate As %String, aLoc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aDate="" $$$OK
 	;Set RepDate = $zdh(aDate,3)
 	Set RepDate = ##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDate)
 	/* update by zhoubo 2014-12-20
 	Set xDateFrom=$e(aDate,1,7)_"-01"
 	Set xDateFrom=$zdh(xDateFrom,3)
 	Set xDateTo=xDateFrom+32
 	Set xDateTo=$zd(xDateTo,3)
 	Set xDateTo=$p(xDateTo,"-",1)_"-"_$p(xDateTo,"-",2)_"-01"
 	Set xDateTo=$zdh(xDateTo,3)-1 
	Set RepDate = xDateFrom - 1
	*/
		Set LocID = ""
		for {
			Set LocID = $o(^DHCMed.NINFi("EnviRepAdd",0,"IndexDateLoc",RepDate,LocID))
			Quit:LocID=""
			Continue:(aLoc'="")&&(aLoc'=LocID)
			Set RepAddID = ""
			for {
				Set RepAddID = $o(^DHCMed.NINFi("EnviRepAdd",0,"IndexDateLoc",RepDate,LocID,RepAddID))
				Quit:RepAddID=""
				Set objRepAdd = ##class(DHCMed.NINF.Rep.EnviHyReportAdd).GetObjById(RepAddID)
				Set (LocDesc,RepUserDesc,RepItemID,RepItemDesc,RepValue,RepUomID,RepUomDesc,Resume)=""
				If $IsObject(objRepAdd) {
					Set objLoc=##class(DHCMed.Base.Ctloc).GetObjById(LocID)
					If $IsObject(objLoc) {
						Set LocDesc=objLoc.Descs
					}
					Set objUser=##class(DHCMed.Base.SSUser).GetObjById(objRepAdd.RepUser)
					If $IsObject(objUser) {
						Set RepUserDesc=objUser.Name
					}
					Set RepItem = objRepAdd.RepItem 
					If $IsObject(RepItem) {
						Set RepItemID=RepItem.%Id()
						Set RepItemDesc=RepItem.Description
					}
					Set RepValue = objRepAdd.RepValue
					Set RepUom = objRepAdd.RepUom 
					If $IsObject(RepUom) {
						Set RepUomID=RepUom.%Id()
						Set RepUomDesc=RepUom.Description
					}
					Set Resume = objRepAdd.Resume
					;Set ReqDate=$zd(RepDate,3)
					Set ReqDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(RepDate)
					//Set Data=$lb(RepAddID,LocID,LocDesc,RepUserDesc,RepItemID,RepItemDesc,RepValue,RepUomID,RepUomDesc,Resume,aDate)
					Set Data=$lb(RepAddID,LocID,LocDesc,RepUserDesc,RepItemID,RepItemDesc,RepValue,RepUomID,RepUomDesc,Resume,ReqDate)
					
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}	

	}
	Quit $$$OK
}

ClassMethod QryEnviHyRepAddClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEnviHyRepAddExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEnviHyRepAddFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEnviHyRepAddExecute ]
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

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RepDate</Value>
</Value>
<Value name="3">
<Value>RepLoc</Value>
</Value>
<Value name="4">
<Value>RepUser</Value>
</Value>
<Value name="5">
<Value>RepItem</Value>
</Value>
<Value name="6">
<Value>RepValue</Value>
</Value>
<Value name="7">
<Value>EHIResume</Value>
</Value>
<Value name="8">
<Value>RepUom</Value>
</Value>
<Value name="9">
<Value>Resume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF("EnviRepAdd")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF("EnviRepAdd")</IdLocation>
<IndexLocation>^DHCMed.NINFi("EnviRepAdd",0)</IndexLocation>
<StreamLocation>^DHCMed.NIN873A.EnviHyRepor7A6ES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
