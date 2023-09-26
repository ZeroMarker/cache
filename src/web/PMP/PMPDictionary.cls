/// 字典管理类
Class web.PMP.PMPDictionary Extends %Persistent
{

Query SelectDictionary(PmpFlagId As %String, PmpCode As %String, PmpDesc As %String, Menu As %String) As %Query(ROWSPEC = "DTYCode:%String,DTYDesc:%String,DTYFlag:%String,DTYRemark:%String,DTYFlagId:%String,RowID:%String")
{
}

//张枕平  2014-10-18

//根据条件查询当前字典数据

//d ##class(%ResultSet).RunQuery("web.PMP.PMPDictionary","SelectDictionary","","","","")

ClassMethod SelectDictionaryExecute(ByRef qHandle As %Binary, PmpFlagId As %String, PmpCode As %String, PmpDesc As %String, Menu As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s ^Temp("SelectDictionary")=PmpFlagId_"^"_PmpCode_"^"_PmpDesc_"^"_Menu
	s (DTYCode,DTYDesc,DTYFlag,DTYRemark)=""
	i PmpCode'="" s PmpCode=##Class(web.DHCINSUPort).GetCNCODE($tr(PmpCode," "),4,"")
	i PmpDesc'="" s PmpDesc=##Class(web.DHCINSUPort).GetCNCODE($tr(PmpDesc," "),4,"")
	s DTYRowid="" F  S DTYRowid=$O(^PMPDictionary(DTYRowid)) Q:DTYRowid=""  d
	.q:(DTYRowid="FLAG")||(DTYRowid="flagdesc")
	.S DTYStandby1=$p(^PMPDictionary(DTYRowid),"^",5)
	.Q:DTYStandby1'="Y"
	.s DTYFlag=$P(^PMPDictionary(DTYRowid),"^",3)
	.Q:(PmpFlagId'="")&(PmpFlagId'=DTYFlag)
	.S DTYCode=$P(^PMPDictionary(DTYRowid),"^",1)
	.s DTYCodedesc=##Class(web.DHCINSUPort).GetCNCODE($tr(DTYCode," "),4,"")_DTYCode
	.q:(PmpCode'="")&(DTYCodedesc'[PmpCode)
	.S DTYDesc=$P(^PMPDictionary(DTYRowid),"^",2)
	.q:DTYDesc=""
	.s DTYDescdesc=##Class(web.DHCINSUPort).GetCNCODE($tr(DTYDesc," "),4,"")_DTYDesc
	.q:(PmpDesc'="")&(DTYDescdesc'[PmpDesc)
	.S DTYRemark=$P(^PMPDictionary(DTYRowid),"^",4)
	.q:(Menu'="")&(DTYRemark'[Menu)
	.S DTYFlagId=..CheckSelect(DTYFlag)
	.s RowID=DTYRowid
	.D OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1      
	set Data=$lb(DTYCode,DTYDesc,DTYFlag,DTYRemark,DTYFlagId,RowID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SelectDictionaryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectDictionaryExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SelectDictionaryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectDictionaryExecute ]
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

ClassMethod CheckSelect(InPut As %String) As %String
{
	s ret="全部"
	i InPut="" s ret="全部"
	i InPut="Status" s ret="模块状态"
	i InPut="Product" s ret="产品组"
	i InPut="Profession" s ret="职称"
	i InPut="Emergency" s ret="紧急程度"
	i InPut="Improvement" s ret="需求状态"
	i InPut="Type" s ret="需求类型"
	i InPut="Degree" s ret="严重程度"
	i InPut="Communication" s ret="沟通方式"
	i InPut="AddDevDetail" s ret="开发添加类型"
	Q ret
}

ClassMethod Update(str As %String) As %String
{
	//str=PmpFlagValue+"^"+PmpCodeValue+"^"+PmpDescValue+"^"+PmpRemarkValue+"^"+PmpRowIDValue
	s ret="操作失败",type="0"
	s PmpFlag=$p(str,"^",1)
	s PmpCode=$p(str,"^",2)
	s PmpDesc=$p(str,"^",3)
	s PmpRemark=$p(str,"^",4)
	s PmpRowID=$p(str,"^",5)
	s Flag=$p(str,"^",6)
	i Flag="Update"   d
	.s DTYRowid="" f  s DTYRowid=$o(^PMPDictionary(DTYRowid)) q:DTYRowid=""  d
	..q:(DTYRowid="FLAG")||(DTYRowid="flagdesc")
	..s Flag=$p(^PMPDictionary(DTYRowid),"^",3)
	..S DTYStandby1=$p(^PMPDictionary(DTYRowid),"^",5)
	..Q:DTYStandby1'="Y"
	..q:Flag'=PmpFlag
	..s Code=$p(^PMPDictionary(DTYRowid),"^",1)
	..s Desc=$p(^PMPDictionary(DTYRowid),"^",2)
	..s Remark=$p(^PMPDictionary(DTYRowid),"^",4)
	..i (Code=PmpCode)&(DTYRowid'=PmpRowID)  d
	...s type="1"
	...s ret="1"
	..i (Desc=PmpDesc)&(DTYRowid'=PmpRowID) d
	...s type="2"
	...i ret="0" s ret=""
	...s ret=ret_"^"_"2"
	..i (Code=PmpCode)&(Desc=PmpDesc)&(Remark=PmpRemark)  d
	...s type="3" 
	...s ret="3"
	.i type="0"  d
	..&sql(update sqluser.PMP_Dictionary set DTY_Code=:PmpCode,DTY_Flag=:PmpFlag,DTY_Desc=:PmpDesc,DTY_Remark=:PmpRemark where DTY_Rowid=:PmpRowID)
	..s ret="4"
	i Flag="Delete"  d
	.&sql(update sqluser.PMP_Dictionary set DTY_Standby1='N' where DTY_Rowid=:PmpRowID)
	.s ret="5"
	i Flag="Insert"  d
	.s DTYRowid="" f  s DTYRowid=$o(^PMPDictionary(DTYRowid)) q:DTYRowid=""  d
	..q:(DTYRowid="FLAG")||(DTYRowid="flagdesc")
	..s Flag=$p(^PMPDictionary(DTYRowid),"^",3)
	..q:Flag'=PmpFlag
	..S DTYStandby1=$p(^PMPDictionary(DTYRowid),"^",5)
	..s Code=$p(^PMPDictionary(DTYRowid),"^",1)
	..s Desc=$p(^PMPDictionary(DTYRowid),"^",2)
	..s Remark=$p(^PMPDictionary(DTYRowid),"^",4)
	..i (Code=PmpCode)&(DTYStandby1'="Y") d
	...s type="1"
	...&sql(update sqluser.PMP_Dictionary set DTY_Code=:PmpCode,DTY_Flag=:PmpFlag,DTY_Desc=:PmpDesc,DTY_Remark=:PmpRemark,DTY_Standby1="Y" where DTY_Rowid=:DTYRowid)
	...s ret="6"
	..i (Code=PmpCode)&(DTYStandby1="Y") d
	...s type="3"
	...s ret="7"
	..i (Desc=PmpDesc)&(DTYStandby1="Y") d
	...s type="2"
	...s ret="8"
	.i type="0" d
	..&sql(insert into  sqluser.PMP_Dictionary  (DTY_Code,DTY_Desc,DTY_Remark,DTY_Flag,DTY_Standby1) values (:PmpCode,:PmpDesc,:PmpRemark,:PmpFlag,"Y"))
	..S ret="9"
	Q ret
}

Storage Default
{
<Data name="PMPDictionaryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.PMP.PMPDictionaryD</DataLocation>
<DefaultData>PMPDictionaryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.PMP.PMPDictionaryD</IdLocation>
<IndexLocation>^web.PMP.PMPDictionaryI</IndexLocation>
<StreamLocation>^web.PMP.PMPDictionaryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
