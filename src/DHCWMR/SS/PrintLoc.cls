/// 打印出库条院区科室配置
Class DHCWMR.SS.PrintLoc Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 医院ID （指向CT_Hospital）
Property SPHospID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 科室ID（ct_loc）
Property SPLocID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医院+科室索引
Index IndexHospLoc On (SPHospID, SPLocID);

/// Creator:          liyi
/// CreateDate:       2015-11-12
/// Description:      根据ID取出库条院区科室配置
/// OperationTable:   DHCWMR.SS.PrintLoc
/// Input:            Id : DHCWMR.SS.PrintLoc.ID
/// Output:           返回Object
/// w ##Class(DHCWMR.SS.PrintLoc).GetObjById(21)
ClassMethod GetObjById(aId As %String) As DHCWMR.SS.Main
{
	new (aId)
	quit:'##class(DHCWMR.SS.PrintLoc).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.SS.PrintLoc).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2015-11-12
/// Description:  更新出库条院区科室配置
/// Table：       DHCWMR.SS.PrintLoc
/// Input：       InputStr : %Id^HospID^LocID
///               Separate ：分隔符
/// Return：      返回新纪录的%Id()值
/// w ##class(DHCWMR.SS.PrintLoc).Update("","")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID=$p(aInputStr,aSeparate,1)
	Set HospID=$p(aInputStr,aSeparate,2)
	Set LocID=$p(aInputStr,aSeparate,3)
	
	Quit:(HospID="")||(LocID="") return
	
	If ID="" {
		Set obj=##class(DHCWMR.SS.PrintLoc).%New()
	} Else {
		Set obj=##class(DHCWMR.SS.PrintLoc).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.SPHospID     = HospID
	Set obj.SPLocID      = LocID
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		set return=obj.%Id()
	}	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2015-11-12
/// Description:  删除出库条院区科室配置
/// Table：       DHCWMR.SS.PrintLoc
/// Input：       Id : HospID , LocID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteByHospLocID(HospID As %String, LocID As %String) As %String
{
	new (HospID,LocID)
	set return=0
	quit:(HospID="")||(LocID="") return
	
	Set ID = $o(^DHCWMR.SS.PrintLocI("IndexHospLoc"," "_HospID," "_LocID,""))
	Set return = ..DeleteById(ID)
	quit return
}

/// Creator：     liyi
/// CreatDate：   2015-11-12
/// Description:  删除出库条院区科室配置
/// Table：       DHCWMR.SS.PrintLoc
/// Input：       Id : DHCWMR.SS.PrintLoc.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.SS.PrintLoc).%DeleteId(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

/// 查询科室列表
/// d ##Class(%ResultSet).RunQuery("DHCWMR.SS.PrintLoc","QueryLoction","","","","E","O","","2")
Query QueryLoction(aAlias As %String, aDepGroup As %String, aLinkLoc As %String, aLocType As %String, aAdmType As %String, aAddItem As %String, aHospitalID As %String) As %Query(ROWSPEC = "IsChecked:%String,LocRowId:%String,LocDesc:%String,LocDesc1:%String")
{
}

ClassMethod QueryLoctionExecute(ByRef qHandle As %Binary, aAlias As %String, aDepGroup As %String, aLinkLoc As %String, aLocType As %String, aAdmType As %String, aAddItem As %String, aHospitalID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set IsChecked=0
	Set aAlias=$g(aAlias)
	Set aDepGroup=$g(aDepGroup)
	Set aLinkLoc=$g(aLinkLoc)
	Set aLocType=$g(aLocType)
	Set aAdmType=$g(aAdmType)
	Set aAddItem=$g(aAddItem)
	Set aHospitalID=$g(aHospitalID)
	
	Set:aLocType'="" aLocType=$ZCVT($g(aLocType),"U")
	Set:aAdmType'="" aAdmType=$ZCVT($g(aAdmType),"U")
	
 	//add by zf 20130225 增加附加选项
	If (aAddItem'="")&&(aAlias="") {
		Set addItemCode=$p(aAddItem,"^",1)
		Set addItemDesc=$p(aAddItem,"^",2)
		Set Data=$lb(addItemCode,addItemCode,addItemDesc)
    	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Set LocID=0
	For {
		Set LocID=$o(^CTLOC(LocID))
		Quit:LocID=""
		Set tmpLoc=$g(^CTLOC(LocID))
		Set LocDesc=$p(tmpLoc,"^",2)
		Set LocDep=$p(tmpLoc,"^",19)
		Set LocType=$p(tmpLoc,"^",13)
		
		Continue:(aAlias'="")&&($zcvt(LocDesc,"U")'[$zcvt(aAlias,"U"))           //别名
		Continue:(aDepGroup'="")&&(LocDep'=aDepGroup)                            //部门组
		Continue:(aLocType'="")&&(LocType'=aLocType)                             //科室类型
		Continue:(aLinkLoc'="")&&('$d(^CTLOC(+aLinkLoc,"LINK",0,"Loc",LocID)))   //关联科室
		If $d(^DHCWMR.SS.PrintLocI("IndexHospLoc"," "_aHospitalID," "_LocID)) 
		{
			Set IsChecked=1
		}else {
			Set IsChecked=0
		}
		//主要处理集团化医院情况和总院分院情况
		If aHospitalID'="" {
			Set flg=##class(DHCWMR.SSService.HospitalSrv).CheckHospital(LocID,aHospitalID)
			Continue:flg<1
		}
		
		//增加科室按门诊、住院分类的过滤
		If (aLocType'="W")&&(aAdmType'="") {
			Continue:'$d(^PAC("ADMLOC",0,"AdmType",aAdmType,LocID))
		}
		
		Set LocDesc1=LocDesc
		Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
		
		Set Data=$lb(IsChecked,LocID,LocDesc,LocDesc1)
    	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QueryLoctionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLoctionExecute ]
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

ClassMethod QueryLoctionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLoctionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SPHospID</Value>
</Value>
<Value name="3">
<Value>SPLocID</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.SS.PrintLocD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.SS.PrintLocD</IdLocation>
<IndexLocation>^DHCWMR.SS.PrintLocI</IndexLocation>
<StreamLocation>^DHCWMR.SS.PrintLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
