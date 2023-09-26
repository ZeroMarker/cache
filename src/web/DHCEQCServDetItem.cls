/// 服务细项定义表
/// Mozy	2010-11-19
/// ^DHCEQCCode("DHCEQCServDetItem",{SDI_RowID})
Class web.DHCEQCServDetItem Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCEQCServDetItem","ServDetItemDetail","","")
/// modified by czf 397032 增加TRow并输出
Query ServDetItemDetail(Code As %String = "", Desc As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TUnit:%String,TPrice:%String,TExType:%String,TExID:%String,TRemark:%String,TImportFlag:%String,TMinMinutes:%String,TMinutesPerTime:%String,TMaxMinutes:%String,TUpdateDate:%String,TExDesc:%String,TRow:%String")
{
}

ClassMethod ServDetItemDetailExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set TRow=1
	Set rowid=0
	set Code=$ZCONVERT(Code,"U")
	set Desc=$ZCONVERT(Desc,"U")
	Do BuildDataServDetItemDetail
	Quit $$$OK
BuildDataServDetItemDetail
	For  Set rowid=$Order(^DHCEQCCode("DHCEQCServDetItem",rowid))  Quit:rowid=""  Do
	.Do ResetVariablesServDetItemDetail
	.Set TRowID = rowid
	.Set TDesc=$Piece($Get(^DHCEQCCode("DHCEQCServDetItem",rowid)),"^",1)
	.set TDesc=$ZCONVERT(TDesc,"U")
	.Quit:(Desc'="")&&(TDesc'[Desc)
	.Set TCode=$Piece($Get(^DHCEQCCode("DHCEQCServDetItem",rowid)),"^",2)
	.set TCode=$ZCONVERT(TCode,"U")
	.Quit:(Code'="")&&(TCode'[Code)
	.Set TUnit=$Piece($Get(^DHCEQCCode("DHCEQCServDetItem",rowid)),"^",3)
	.If TUnit'="" Set TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnit)
	.Set TPrice=$Piece($Get(^DHCEQCCode("DHCEQCServDetItem",rowid)),"^",4)
	.Set TExType=$Piece($Get(^DHCEQCCode("DHCEQCServDetItem",rowid)),"^",5)
	.If TExType'="" Set TExType=##class(web.DHCEQCServDetItem).GetEditEXType(TExType)
	.Set TExID=$Piece($Get(^DHCEQCCode("DHCEQCServDetItem",rowid)),"^",6)
	.Set TRemark=$Piece($Get(^DHCEQCCode("DHCEQCServDetItem",rowid)),"^",7)
	.Set TImportFlag=$Piece($Get(^DHCEQCCode("DHCEQCServDetItem",rowid)),"^",8)
	.Set TMinMinutes=$Piece($Get(^DHCEQCCode("DHCEQCServDetItem",rowid)),"^",9)
	.Set TMinutesPerTime=$Piece($Get(^DHCEQCCode("DHCEQCServDetItem",rowid)),"^",10)
	.Set TMaxMinutes=$Piece($Get(^DHCEQCCode("DHCEQCServDetItem",rowid)),"^",11)
	.Set InvalidFlag=$Piece($Get(^DHCEQCCode("DHCEQCServDetItem",rowid)),"^",12)
	.Quit:InvalidFlag="Y"
	.Set TUpdateDate=$Piece($Get(^DHCEQCCode("DHCEQCServDetItem",rowid)),"^",13)
	.If TUpdateDate'="" Set TUpdateDate=##Class(web.DHCEQCommon).TransValueToPage(TUpdateDate,"date")
	.Set TExDesc=$Piece($Get(^DHCEQCCode("DHCEQCServDetItem",rowid)),"^",14)
	.
	.Do OutputRowServDetItemDetail
	Quit
OutputRowServDetItemDetail
	Set Data=$lb(TRowID,TCode,TDesc,TUnit,TPrice,TExType,TExID,TRemark,TImportFlag,TMinMinutes,TMinutesPerTime,TMaxMinutes,TUpdateDate,TExDesc,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1
	Quit
ResetVariablesServDetItemDetail
	Set (TRowID,TCode,TDesc,TUnit,TPrice,TExType,TExID,TRemark,TImportFlag,TMinMinutes,TMinutesPerTime,TMaxMinutes,TUpdateDate,TExDesc)=""
	Quit
}

ClassMethod ServDetItemDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ServDetItemDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ServDetItemDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ServDetItemDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##class(web.DHCEQCServDetItem).GetDocByID(1)
ClassMethod GetDocByID(rowid As %Library.String = "")
{
	new result,resultex
	Set (result,resultex)=""
	Set result= $Get(^DHCEQCCode("DHCEQCServDetItem",rowid))

	Set resultex=resultex_"^"
	If $Piece(result,"^",3)'=""  Do
	.Set resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("uom",$Piece(result,"^",3))
	If $Piece(result,"^",8)'="" Set $Piece(result,"^",8)=##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",8),"bool")
	
	Set resultex=result_resultex
	Set resultex=##class(web.DHCEQCommon).Replace(resultex,$C(13,10),"\n") //回车符转换为"\n"
	
	Quit rowid_"^"_resultex
}

/// modify by wl 2020-03-09 WL0061 大写转换,数据重复校验
ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "")
{
	k PLIST,rowid
	Set rowid=$Piece(val,"^",1)
	If (+isDel=1)
	{
	 	//&SQL(Delete From SQLUSER.DHC_EQCServDetItem where SDI_RowID = :rowid)
	 	Set PLIST(13)="Y" 		// InvalidFlag
	 	&SQL(Update SQLUSER.DHC_EQCServDetItem Values :PLIST() where SDI_RowID = :rowid)
	 	If SQLCODE  Quit SQLCODE
	 	Quit rowid
 	}
 	//转换大写
 	Set PLIST(2)=$ZCONVERT($Piece(val,"^",2),"U")		// Desc  	
 	Set PLIST(3)=$ZCONVERT($Piece(val,"^",3),"U")		// Code
 	Set PLIST(4)=$Piece(val,"^",4) 		// UnitDR
 	Set PLIST(5)=$Piece(val,"^",5) 		// Price
	Set PLIST(6)=$Piece(val,"^",6) 		// ExTypeDR
	Set PLIST(7)=$Piece(val,"^",7) 		// ExID
	Set PLIST(8)=$Piece(val,"^",8) 		// Remark
	Set PLIST(9)=$Piece(val,"^",9) 		// ImportFlag
	If PLIST(9)'="" Set PLIST(9) = ##class(web.DHCEQCommon).TransValueFromPage(PLIST(9),"bool")
	Set PLIST(10)=$Piece(val,"^",10) 	// MinMinutes
	Set PLIST(11)=$Piece(val,"^",11) 	// MinutesPerTimes
	Set PLIST(12)=$Piece(val,"^",12) 	// MaxMinutes
	Set PLIST(14)= +$h 					// UpdateDate
	Set PLIST(15)=$Piece(val,"^",13) 	// ExDesc
	s tmpid="" 	//数据重复校验
	s desc=PLIST(2)
 	s code=PLIST(3)
	If (rowid="")  //新增按钮操作
	{
	&SQL(select SDI_RowID into :tmpid  from SQLUSER.DHC_EQCServDetItem where SDI_Code=:code or SDI_Desc=:desc and (SDI_InvalidFlag  is  null OR  SDI_InvalidFlag='N'))
	i tmpid=""  &SQL(Insert Into SQLUSER.DHC_EQCServDetItem Values :PLIST())
	}
	Else  //更新按钮操作
	{	
	&SQL(select SDI_RowID into :tmpid  from SQLUSER.DHC_EQCServDetItem where  SDI_RowID!=:rowid and (SDI_Code=:code or SDI_Desc=:desc) and  (SDI_InvalidFlag  is  null OR  SDI_InvalidFlag='N')) 
	i tmpid="" 	&SQL(Update SQLUSER.DHC_EQCServDetItem Values :PLIST() where SDI_RowID = :rowid)  	
	} 
    i tmpid'="" q "-9210" 
 	If SQLCODE  Quit SQLCODE
 	Set ID=$Get(%ROWID)
 	Quit ID
}

/// Modify By QW 2018-08-31 HISUI改造：自定义下拉列表显示格式错误
ClassMethod ExType(name, width, type) As %String
{
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")
	Write "<option value=></option>"
	Write "<option value=1>DHC-LIS</option>"
	Write "<option value=2>DHC-HIS</option>"
	Write "</select>",!
}

ClassMethod GetEditEXType(Type As %Library.String) As %Status
{
	If Type=""  Quit ""
	If +Type=1  Quit "DHC-LIS"
	If +Type=2  Quit "DHC-HIS"
	Quit "未定义"
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQCServDetItem","GetServDetItem","")
Query GetServDetItem(Desc As %String = "") As %Query(ROWSPEC = "TDesc:%String:描述,Hidden,TCode:%String:编码,Hidden,TUnit:%String:单位,TPrice:%String:单价")
{
}

ClassMethod GetServDetItemExecute(ByRef qHandle As %Binary, Desc As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set rowid=0
	Do BuildDataGetServDetItem
	Quit $$$OK
BuildDataGetServDetItem
	For  Set rowid=$Order(^DHCEQCCode("DHCEQCServDetItem",rowid))  Quit:rowid=""  Do
	.Do ResetVariablesGetServDetItem
	.Set TRowID = rowid
	.Set TDesc=$Piece($Get(^DHCEQCCode("DHCEQCServDetItem",rowid)),"^",1)
	.Set TCode=$Piece($Get(^DHCEQCCode("DHCEQCServDetItem",rowid)),"^",2)
	.Quit:(Desc'="")&&(TDesc'=Desc)&&(TDesc'=TCode)
	.Set TUnitDR=$Piece($Get(^DHCEQCCode("DHCEQCServDetItem",rowid)),"^",3)
	.If TUnitDR'="" Set TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	.Set TPrice=$Piece($Get(^DHCEQCCode("DHCEQCServDetItem",rowid)),"^",4)
	.Set InvalidFlag=$Piece($Get(^DHCEQCCode("DHCEQCServDetItem",rowid)),"^",12)
	.Quit:InvalidFlag="Y"
	.
	.Do OutputRowGetServDetItem
	Quit
	
ResetVariablesGetServDetItem
	Set (TDesc,TRowID,TCode,TUnitDR,TUnit,TPrice)=""
	Quit
OutputRowGetServDetItem
	Set Data=$lb(TDesc,TRowID,TCode,TUnitDR,TUnit,TPrice)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
}

ClassMethod GetServDetItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetServDetItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetServDetItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetServDetItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQCServDetItem","GetTarItem","")
/// modify hly 20200319 bug:1235607
Query GetTarItem(ExDesc As %String = "") As %Query(ROWSPEC = "TDesc:%String:描述,TRowID:%String:描述ID,TCode:%String:编码,Hidden,TUnit:%String:单位")
{
}

ClassMethod GetTarItemExecute(ByRef qHandle As %Binary, ExDesc As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set rowid=0
	Do BuildDataGetTarItem
	Quit $$$OK
BuildDataGetTarItem
	// ^DHCTARI
	For  Set rowid=$Order(^DHCTARI(rowid))  Quit:rowid=""  Do
	.Do ResetVariablesGetTarItem
	.Set TRowID = rowid
	.Set TDesc=$Piece($Get(^DHCTARI(rowid)),"^",2)
	.Quit:(ExDesc'="")&&(TDesc'[ExDesc)
	.Set TCode=$Piece($Get(^DHCTARI(rowid)),"^",1)
	.Set TUnitDR=$Piece($Get(^DHCTARI(rowid)),"^",3)
	.If TUnitDR'="" Set TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	.
	.Set ActiveFlag=$Piece($Get(^DHCTARI(rowid)),"^",7)
	.Quit:ActiveFlag'="Y"
	.
	.Do OutputRowGetTarItem
	Quit

ResetVariablesGetTarItem
	Set (TDesc,TRowID,TCode,TUnitDR,TUnit)=""
	Quit
OutputRowGetTarItem
	Set Data=$lb(TDesc,TRowID,TCode,TUnitDR,TUnit)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
}

ClassMethod GetTarItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTarItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetTarItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTarItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
