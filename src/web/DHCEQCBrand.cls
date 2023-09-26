Import SQLUser

Class web.DHCEQCBrand Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod BrandClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BrandExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

ClassMethod BrandExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", ManuFactoryDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Desc=$ZCONVERT(Desc ,"U")
 	s Code=$ZCONVERT(Code ,"U")
	s index=1
	s TRow=1
	s rowid=0
	d BuildDataGetBrand
	Quit $$$OK
BuildDataGetBrand
	f  s rowid=$o(^DHCEQCCode("DHCEQCBrand",rowid))  quit:rowid=""  d
	.d ResetVariablesGetBrand
	.s TRowID=rowid
	.s TInvalidFlag=$p($g(^DHCEQCCode("DHCEQCBrand",TRowID)),"^",5) //无符号标志
	.q:TInvalidFlag="Y"
	.s TCode=$p($g(^DHCEQCCode("DHCEQCBrand",TRowID)),"^",2) //代码
	.s TDesc=$p($g(^DHCEQCCode("DHCEQCBrand",TRowID)),"^",3) //描述
	.q:($ZCONVERT(TCode,"U")'[Code)&(Code'="")
	.q:($ZCONVERT(TDesc,"U")'[Desc)&(Desc'="")
	.s TManuFactoryDR=$p($g(^DHCEQCCode("DHCEQCBrand",TRowID)),"^",1) //生产厂家
	.q:(ManuFactoryDR'="")&&(TManuFactoryDR'=ManuFactoryDR)
	.i TManuFactoryDR'="" s TManuFactory=$p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1)
	.s TRemark=$p($g(^DHCEQCCode("DHCEQCBrand",TRowID)),"^",4) //备注
	.s THold1=$p($g(^DHCEQCCode("DHCEQCBrand",TRowID)),"^",6)
	.s THold2=$p($g(^DHCEQCCode("DHCEQCBrand",TRowID)),"^",7)
	.s THold3=$p($g(^DHCEQCCode("DHCEQCBrand",TRowID)),"^",8)
	.s THold4=$p($g(^DHCEQCCode("DHCEQCBrand",TRowID)),"^",9)
	.s THold5=$p($g(^DHCEQCCode("DHCEQCBrand",TRowID)),"^",10)
	.d OutputRowGetBrand
	quit
OutputRowGetBrand
   	s Data=$lb(TRowID,TCode,TDesc,TManuFactory,TManuFactoryDR,TRemark,THold1,THold2,THold3,THold4,THold5,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetBrand
	s (TRowID,TCode,TDesc,TManuFactory,TManuFactoryDR,TRemark,THold1,THold2,THold3,THold4,THold5)=""
	quit
}

ClassMethod BrandFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BrandExecute ]
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

Query Brand(Code As %String = "", Desc As %String = "", ManuFactoryDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TManuFactory:%String,TManuFactoryDR:%String,TRemark:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TRow:%String")
{
}

ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "")
{
 k PLIST,rowid
 s rowid=$p(val,"^",1)
 i (+isDel=1)
 {
 	s PLIST(6)="Y"
 	&SQL(Update SQLUSER.DHC_EQCBrand Values :PLIST() where B_RowID = :rowid) 
 	if SQLCODE  q SQLCODE
 	q rowid
 } 
 
 s PLIST(3) = $p(val,"^",2)	;Code
 s Code= $p(val,"^",2)
 s PLIST(4) = $p(val,"^",3)	;Desc
 s Desc= $p(val,"^",3)
 s PLIST(5) = $p(val,"^",4)	;Remark
 s ManuFactoryDR=$p(val,"^",5)	;ManuFactoryDR
 s PLIST(2)=ManuFactoryDR
 s PLIST(7)=$p(val,"^",6)
 s PLIST(8)=$p(val,"^",7)
 s PLIST(9)=$p(val,"^",8)
 s PLIST(10)=$p(val,"^",9)
 s PLIST(11)=$p(val,"^",10)
 s Rowid=""
  &SQL(select B_RowID into :Rowid from DHC_EQCBrand where B_Desc=:Desc and B_InvalidFlag='N')
 	if ((Rowid="")||(Rowid=rowid))
 	{
 		i (+isDel=2)
 		{
	 		s PLIST(6) ="N"
 			&SQL(Insert Into SQLUSER.DHC_EQCBrand Values :PLIST())
 		} 
 		if (rowid'="") 
 		{
	 		s PLIST(6) ="N"
 			 &SQL(Update SQLUSER.DHC_EQCBrand Values :PLIST() where B_RowID = :rowid) 	 
 		}
 }
 if SQLCODE  q SQLCODE
 Set ID=$g(%ROWID)
 q ID
}

ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQCBrand",rowid)
	s resultex=rowid   //0
	s resultex=resultex_"^"	//1
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCBrand",rowid)),"^",2)
	s resultex=resultex_"^"	//2
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCBrand",rowid)),"^",3) //描述
	s resultex=resultex_"^"	//3
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCBrand",rowid)),"^",4) //备注
	s resultex=resultex_"^"	//4
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCBrand",rowid)),"^",1) //生产厂家DR
	s resultex=resultex_"^"	//5
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCManufacturer",$p($g(^DHCEQCCode("DHCEQCBrand",rowid)),"^",1))),"^",1) //生产厂家
	s resultex=resultex_"^"	//6
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCBrand",rowid)),"^",6) //
	s resultex=resultex_"^"	//7
	i $p(result,"^",7)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCBrand",rowid)),"^",7) //
	s resultex=resultex_"^"	//8
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCBrand",rowid)),"^",8) //
	s resultex=resultex_"^"	//9
	i $p(result,"^",9)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCBrand",rowid)),"^",9) //
	s resultex=resultex_"^"	//10
	i $p(result,"^",10)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCBrand",rowid)),"^",10) //
	q resultex
}

Query GetBrand(ManuFactoryDR, valName) As %Query(ROWSPEC = "Name:%String,Hidden:%String,Code:%String")
{
}

ClassMethod GetBrandExecute(ByRef qHandle As %Binary, ManuFactoryDR, valName) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetBrandList
	Quit $$$OK
BuildDataGetBrandList
	f  s rowid=$o(^DHCEQCCode("DHCEQCBrand",rowid))  quit:rowid=""  d
	.d ResetVariablesGetBrandList
	.s RowID = rowid
	.s Flag = $p($g(^DHCEQCCode("DHCEQCBrand",rowid)),"^",5)
	.q:Flag="Y"
	.s Name = $p($g(^DHCEQCCode("DHCEQCBrand",rowid)),"^",3)
	.s Code=$p($g(^DHCEQCCode("DHCEQCBrand",rowid)),"^",2)
	.q:(valName'="")&&(($ZCONVERT(Name ,"U")'[$ZCONVERT(valName,"U"))&&($ZCONVERT(Code,"U")'[$ZCONVERT(valName,"U")))
	.s ManuFactory=$p($g(^DHCEQCCode("DHCEQCBrand",rowid)),"^",1)
	.q:(ManuFactoryDR'="")&&(ManuFactoryDR'=ManuFactory)&&(ManuFactory'="")
	.d OutputRowGetBrandList
	quit
OutputRowGetBrandList
	s Data=$lb(Name,RowID,Code)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetBrandList
	s (Name,RowID,Code)=""
	quit
}

ClassMethod GetBrandFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBrandExecute ]
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

ClassMethod GetBrandClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBrandExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Add By DJ 2016-07-21
/// 目的:系统自动录入品牌
/// 描述:检测品牌表是否存在当前数据.是则返回RowID,否则新增记录并返回RowID
/// 输入: data:品牌
/// 输出: 无
/// 返回值: 成功返回RowID, 失败返回错误代码
/// w ##Class(web.DHCEQCBrand).UpdBrand("LX^联想")
ClassMethod UpdBrand(data, ManuFactoryID As %String = "")
{
	Set BRowID=""
	Set code=$tr($ZCONVERT($p(data,"^",1),"U"), " ")
	Set desc=$tr($ZCONVERT($p(data,"^",2),"U"), " ") //modified by wy 除去字符串中的空格 2020-3-31需求1249905
	Set SQLCODE=0
	Set GetBrandOperMethod=##class(web.DHCEQCommon).GetSysInfo("201010")
	If (GetBrandOperMethod=0)||(desc="") Quit ""
	if ManuFactoryID=""
	{
		&SQL(Select B_RowID Into :BRowID from SQLUSER.DHC_EQCBrand Where B_InvalidFlag<>'Y' and B_Desc=:desc)
	}
	else
	{
		&SQL(select B_RowID into :BRowID from sqluser.DHC_EQCBrand where  B_Desc=:desc and B_ManuFactoryDR=:ManuFactoryID and B_InvalidFlag<>'Y' )
	}
	if BRowID=""
	{
		&SQL(Insert Into SQLUSER.DHC_EQCBrand(B_Code,B_Desc,B_ManuFactoryDR,B_InvalidFlag) Values(:code,:desc,:ManuFactoryID,'N'))
		if SQLCODE
		{
			Quit SQLCODE
		}
		Set BRowID=$Get(%ROWID)
	}
	Quit BRowID
}

}
