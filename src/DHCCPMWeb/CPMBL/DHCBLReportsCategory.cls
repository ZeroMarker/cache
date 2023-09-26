/// 报表目录的IDUC
Class DHCCPMWeb.CPMBL.DHCBLReportsCategory Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", CompileAfter = (DHCCPM.DHCReportsCategory, DHCCPMWeb.CPMSevice.entity.DHCEReportsCategory), Inheritance = right, Not ProcedureBlock ]
{

/// 验证本目录是否存在
ClassMethod CheckCurSelCat(CatRowID As %String) As %String
{
	;w ##class(DHCCPMWeb.CPMBL.DHCBLReportsCategory).CheckCurSelCat(1)
	n (CatRowID)
	s myrtn=0
	if ((CatRowID'="")&(CatRowID'=$c(0))){
		s myParCat=##class(DHCCPM.DHCReportsCategory).%OpenId(CatRowID)
		if ('$IsObject(myParCat)){
			s myrtn=-1104		;父对象不存在错误
		}
	}
	
	q myrtn
}

/// 验证是否有子目录
ClassMethod DELCheck(RowID As %String) As %String
{
	n (RowID)
	s myrtn=0
	;需要判断目录是否有子目录或者 
	;报表如果有，不能删除
	
	;^DHCCPM.DHCReportsCategoryI("RCatDRIdx",,1)
	;此对象存在子对象，不能删除
	q:(RowID="") -1105		;输入参数不符合条件错误
	
	if ($d(^DHCCPM.DHCReportsCategoryI("RCatDRIdx",RowID))) d
	.s myrtn=-1103
	
	s myParCat=##class(DHCCPM.DHCReportsCategory).%OpenId(RowID)
	if ('$IsObject(myParCat)){
		s myrtn=-1102
	}else{
		d myParCat.%Close()
	}
	
	QUIT myrtn
}

ClassMethod DELETE(RowID As %String) As %String
{
	;需要判断目录是否有子目录或者 
	;报表如果有，不能删除
	;没有删除
	n (RowID)
	s $ZT="ERROR^DHCSSERR"
	
	;w ##class(DHCCPMWeb.CPMBL.DHCBLReportsCategory).DELETE(12)
	s myrtn=0
	
	s myrtn=..DELCheck(RowID)
	
	q:(+myrtn'=0) +myrtn
	b
	TSTart
	
	Set mysc=##class(DHCCPM.DHCReportsCategory).%DeleteId(RowID)
	
	If $$$ISERR(mysc) {
    	s myrtn=-106
    }
	
	if (+myrtn=0){
		tc
	}else{
		tro
	}
	
	QUIT myrtn
}

ClassMethod GetRepCatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRepCatListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod INSERT(RepCat As DHCCPMWeb.CPMSevice.entity.DHCEReportsCategory) As %String
{
	;w ##class(DHCCPMWeb.CPMBL.DHCBLReportsCategory).INSERT(RepCat)
	n (RepCat)
	s $ZT="ERROR^DHCSSERR"
	
	;RepCat.RCCaption_"^"_RepCat.RCName_"^"_
	s myrtn=0
	
	tstart
	s myParCat=""
	s myCurCatRowID=""
	if ((RepCat.RCategoryDR'="")&(RepCat.RCategoryDR'=$c(0))){
		s myParCat=##class(DHCCPM.DHCReportsCategory).%OpenId(RepCat.RCategoryDR)
		if ('$IsObject(myParCat)){
			s myrtn=-1104		;父对象不存在错误
		}
	}
	
	if (+myrtn=0){
		s myobj=##class(DHCCPM.DHCReportsCategory).%New()
		
		s myobj.RCCaption=RepCat.RCCaption
		s myobj.RCName=RepCat.RCName
		s myobj.RCategoryDR=myParCat
		
		s mysc=myobj.%Save()
		s myCurCatRowID=myobj.%Id()
		
		d myobj.%Close()
		
		If $$$ISERR(mysc) {
	    	s myrtn=-104
	    }
	}
	
	if (myrtn=0){
		TCommit
	}else{
		TRollback
	}
	
	
	q myrtn_"^"_myCurCatRowID
}

ClassMethod GetRepCatListExecute(ByRef qHandle As %Binary) As %Status
{
	;w ##class(%ResultSet).RunQuery("DHCCPMWeb.CPMBL.DHCBLReportsCategory","GetRepCatList")
	Set repid=$I(^CacheTemp)
	s ind=1
	s ret=0
	
	;%ID, RC_Caption,RC_Name,RC_CategoryDR
	Set result = ##class(%ResultSet).%New("DHCCPM.DHCReportsCategory:GetRepCatList")
	Do result.Execute()
	While (result.Next()) {
		s RowID=result.Data("ID")
		s RCCaption=result.Data("RC_Caption")
		s RCName=result.Data("RC_Name")
		s RCCategoryDR=result.Data("RC_CategoryDR")
		s RepCount=0
		s myRepRowID=0
		;^DHCCPM.DHCReportsI("RepCategoryDRIndex",-100000000000000,1)=
		i RCCategoryDR
		
		f  s myRepRowID=$o(^DHCCPM.DHCReportsI("RepCategoryDRIndex",RowID,myRepRowID)) q:(myRepRowID="")  d
		.s RepCount=RepCount+1
		
		Do OutputRow
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowID, RCCaption,RCName,RCCategoryDR, RepCount)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
Validate
	s (RowID, RCCaption,RCName,RCCategoryDR, RepCount)=""
	q
}

/// 更新数据类型对照 Success=0  fail<>0
ClassMethod UPDATE(RepCat As DHCCPMWeb.CPMSevice.entity.DHCEReportsCategory) As %String
{
	;w ##class(DHCCPMWeb.CPMBL.DHCBLReportsCategory).UPDATE(RepCat)
	n (RepCat)
	;判断是否存在
	;否则更新失败
	;如果要改变目录  RCategoryDR改变
	;$IsObject
	;RepCat.RowID
	
	s $ZT="ERROR^DHCSSERR"
	
	s myrtn=0
	
	tstart
	
	s myRowID=RepCat.RowID
	s myobj=##class(DHCCPM.DHCReportsCategory).%OpenId(myRowID)
	
	if ('$IsObject(myobj)){
		s myrtn=-1102		;对象不存在错误
	}
	;转换对象
	if ((+myrtn=0)&(myobj.RCategoryDR'=RepCat.RCategoryDR)){
		s myParCat=##class(DHCCPM.DHCReportsCategory).%OpenId(RepCat.RCategoryDR)
		if ('$IsObject(myParCat)){
			
			s myobj.RCategoryDR=""
			///s myrtn=-1104		;父对象不存在错误
		}else{
			s myobj.RCategoryDR=myParCat
		}
	}
	if (+myrtn=0){
		s myobj.RCCaption=RepCat.RCCaption
		s myobj.RCName=RepCat.RCName
		;s myobj.RCategoryDR=RepCat.RCategoryDR
		
		;myobj.RCategoryDR=RepCat.RCategoryDR
		s mysc=myobj.%Save()
		
		d myobj.%Close()
		
		If $$$ISERR(mysc) {
	    	s myrtn=-104
	    }
	}
	if (myrtn=0){
		TCommit
	}else{
		TRollback
	}
	
	q myrtn
}

ClassMethod GetRepCatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRepCatListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
		Set Row=""
	}
	Else      {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 获取Cat列表
Query GetRepCatList() As %Query(ROWSPEC = "%ID:%String,RC_Caption:%String,RC_Name:%String,RC_CategoryDR:%String,RepCount:%String")
{
}

}
