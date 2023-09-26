Import SQLUser

/// -----------------------------------------------------------
/// Modified By DJ 2011-10-27 DJ DJ0097
/// 描述:增加开户银行,开户帐号,EMail及备用字段处理
/// -----------------------------------------------------------
/// Modified By HZY 2011-10-18 HZY0017
/// 修改函数:(1)SaveData ,     (2)Service
/// Desc:(1)重写SaveData函数.  (2)在查询Service中添加‘无效标志’的判断.
Class web.DHCEQCService Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/*
Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT SV_Name,
	   SV_RowID,
	   SV_Code
FROM sqluser.DHC_EQCService
where SV_InvalidFlag = 'N' and SV_Name like nvl(:para,'')||'%'
}*/
/// add by czf 20200408
/// 描述: 服务商
/// d ##class(%ResultSet).RunQuery("web.DHCEQCService","LookUp","")
Query LookUp(para As %String = "") As %Query(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
}

ClassMethod LookUpExecute(ByRef qHandle As %Binary, para As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$LB(0,repid,0)
 	Set Desc=##Class(web.DHCEQCommon).UnEscape(para) //modified by CZF0103 20200408
 	Set Desc=$ZCONVERT(Desc ,"U")
 	
	Set index=1
	Set FirmType=4
	
	Set rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCFirmContrast",0,"FirmType",FirmType,rowid)) q:rowid=""  d
	.s FCRowid=$o(^DHCEQCCode("DHCEQCFirmContrast",0,"FirmType",FirmType,rowid,""))
	.q:FCRowid=""
	.q:$p($g(^DHCEQCCode("DHCEQCFirmContrast",FCRowid)),"^",3)="Y"		 //modified by CZF0103 20200408
	.Do ResetGetServiceLookUp
	.Set TRowID = rowid
	.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",19)
	.q:InvalidFlag="Y"
	.s THold3=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",22)	
	.s TCode=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",1)
	.s TDesc=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",2)
	.Quit:(Desc'="")&&($ZCONVERT(TCode ,"U")'[Desc)&&($ZCONVERT(TDesc ,"U")'[Desc)
	.s TTel=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",9)
	.s TContPerson=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",8)
	.Do OutputGetServiceLookUp
	Quit $$$OK

OutputGetServiceLookUp
	Set Data=$lb(TDesc,TRowID,TCode)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetGetServiceLookUp
	Set (TDesc,TRowID,TCode,TTel,TContPerson)=""
	Quit
}

ClassMethod LookUpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpExecute ]
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
	Set qHandle=$LB(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LookUpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetServiceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

ClassMethod ServiceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ServiceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ServiceExecute(ByRef qHandle As %Binary, Name As %String = "", Code As %String = "", Address As %String = "", Tel As %String = "", Zip As %String = "", Fax As %String = "", ContPerson As %String = "", ShName As %String = "", Grading As %String = "") As %Status
{
	
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Name=$ZCONVERT(Name ,"U")
 	s Code=$ZCONVERT(Code ,"U")
 	s Address=$ZCONVERT(Address ,"U")
 	s Tel=$ZCONVERT(Tel ,"U")
 	s Zip=$ZCONVERT(Zip ,"U")
 	s Fax=$ZCONVERT(Fax ,"U")
 	s ContPerson=$ZCONVERT(ContPerson ,"U")
 	s ShName=$ZCONVERT(ShName ,"U")
 	s Grading=$ZCONVERT(Grading ,"U")
	s index=1
	s TRow=1
	s rowid=0
	d BuildDataGetService
	Quit $$$OK
BuildDataGetService
	f  s rowid=$o(^DHCEQCCode("DHCEQCService",rowid))  quit:rowid=""  d
	.d ResetVariablesGetService
	.s LTRowID = rowid	//rowid
	.s LTName=$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",1) //
	.s LTCode=$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",2) //
	.s LTAddress=$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",3) //
	.s LTTel=$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",4) //
	.s LTZip=$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",5) //
	.s LTFax=$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",6) //
	.s LTContPerson=$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",7) //
	.s LTShName=$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",8) //
	.s LTGrading=$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",9) //
	.s LTInvalidFlag=$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",10) //
	.q:(LTInvalidFlag="Y")
	.q:($ZCONVERT(LTName,"U")'[Name)&(Name'="")
	.q:($ZCONVERT(LTCode,"U")'[Code)&(Code'="")
	.q:($ZCONVERT(LTAddress,"U")'[Address)&(Address'="")
	.q:($ZCONVERT(LTTel,"U")'[Tel)&(Tel'="")
	.q:($ZCONVERT(LTZip,"U")'[Zip)&(Zip'="")
	.q:($ZCONVERT(LTFax,"U")'[Fax)&(Fax'="")
	.q:($ZCONVERT(LTContPerson,"U")'[ContPerson)&(ContPerson'="")
	.q:($ZCONVERT(LTShName,"U")'[ShName)&(ShName'="")
	.q:($ZCONVERT(LTGrading,"U")'[Grading)&(Grading'="")
	.s LTBank=$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",11) // 2011-10-27 DJ DJ0097 begin
	.s LTBankNo=$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",12) //
	.s LTEMail=$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",13) //
	.s LTHold1=$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",14) //
	.s LTHold2=$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",15) //
	.s LTHold3=$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",16) //
	.s LTHold4=$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",17) //
	.s LTHold5=$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",18) // 2011-10-27 DJ DJ0097 end
	.d OutputRowGetService
	quit
OutputRowGetService
   s Data=$lb(LTRowID,LTName,LTCode,LTAddress,LTTel,LTZip,LTFax,LTContPerson,LTShName,LTGrading,LTInvalidFlag,LTBank,LTBankNo,LTEMail,LTHold1,LTHold2,LTHold3,LTHold4,LTHold5,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetService
	s (LTRowID,LTName,LTCode,LTAddress,LTTel,LTZip,LTFax,LTContPerson,LTShName,LTGrading,LTInvalidFlag,LTBank,LTBankNo,LTEMail,LTHold1,LTHold2,LTHold3,LTHold4,LTHold5)=""
	quit
}

ClassMethod ServiceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ServiceExecute ]
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

/// Modified By HZY 2011-10-18 HZY0017
/// Desc:在查询Service中添加‘无效标志’的判断.
Query Service(Name As %String = "", Code As %String = "", Address As %String = "", Tel As %String = "", Zip As %String = "", Fax As %String = "", ContPerson As %String = "", ShName As %String = "", Grading As %String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TCode:%String,TAddress:%String,TTel:%String,TZip:%String,TFax:%String,TContPerson:%String,TShName:%String,TGrading:%String,TInvalidFlag:%String,TBank:%String,TBankNo:%String,TEMail:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TRow:%String")
{
}

/// Modified By HZY 2011-10-18 HZY0017
/// Desc:重写SaveData函数.
ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "")
{
 k PLIST,rowid
 s rowid=$p(val,"^",1)
 i (+isDel=1)
 {
 	;&SQL(Delete From SQLUSER.DHC_EQCService where SV_RowID = :rowid)
 	s PLIST(11)="Y"
 	&SQL(Update SQLUSER.DHC_EQCService Values :PLIST() where SV_RowID = :rowid) 
 } 
 else
 {
	 s PLIST(2) = $p(val,"^",2)	;
	 s Name=$p(val,"^",2)
	 s PLIST(3) = $p(val,"^",3)	;
	 s Code=$p(val,"^",3)
	 s PLIST(4) = $p(val,"^",4)	;
	 s PLIST(5) = $p(val,"^",5)	;
	 s PLIST(6) = $p(val,"^",6)	;
	 s PLIST(7) = $p(val,"^",7)	;
	 s PLIST(8) = $p(val,"^",8)	;
	 s PLIST(9) = $p(val,"^",9)	;
	 s PLIST(10) = $p(val,"^",10)	;
	 s PLIST(11) = "N"
	 s PLIST(12) = $p(val,"^",11)	; //2011-10-27 DJ DJ0097 begin
	 s PLIST(13) = $p(val,"^",12)	;
	 s PLIST(14) = $p(val,"^",13)	;
	 s PLIST(15) = $p(val,"^",14)	;
	 s PLIST(16) = $p(val,"^",15)	;
	 s PLIST(17) = $p(val,"^",16)	;
	 s PLIST(18) = $p(val,"^",17)	;
	 s PLIST(19) = $p(val,"^",18)	; //2011-10-27 DJ DJ0097 end
	 
	s tmpid=""
  	&SQL(select SV_RowID into :tmpid from SQLUSER.DHC_EQCService where SV_Name=:Name and SV_InvalidFlag='N') ;Modified by HHM 20150914 HHM0017
  	if (tmpid'="")&&(tmpid'=rowid)
  	{	//数据重复	
	  	s SQLCODE=-3001
	}
	else
	{
		if (rowid="")
		{ //新增
			&SQL(Insert Into SQLUSER.DHC_EQCService Values :PLIST())
		}
		else
		{ //更新
			&SQL(Update SQLUSER.DHC_EQCService Values :PLIST() where SV_RowID = :rowid)
		}		
	}
 }
 q SQLCODE
}

ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQCService",rowid)
	s resultex=rowid
	s resultex=resultex_"^"	//名称
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",1)
	s resultex=resultex_"^"	//代码
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",2)
	s resultex=resultex_"^"	//地址
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",3)
	s resultex=resultex_"^"	//电话
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",4)
	s resultex=resultex_"^"	//邮编
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",5)
	s resultex=resultex_"^"	//传真
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",6)
	s resultex=resultex_"^"	//联系人
	i $p(result,"^",7)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",7)
	s resultex=resultex_"^"	//短名称
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",8)
	s resultex=resultex_"^"	//等级
	i $p(result,"^",9)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",9)
	s resultex=resultex_"^"	//无效标志
	i $p(result,"^",10)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",10)
	s resultex=resultex_"^"	// 2011-10-27 DJ DJ0097 begin
	i $p(result,"^",11)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",11)
	s resultex=resultex_"^"	//
	i $p(result,"^",12)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",12)
	s resultex=resultex_"^"	//
	i $p(result,"^",13)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",13)
	s resultex=resultex_"^"	//
	i $p(result,"^",14)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",14)
	s resultex=resultex_"^"	//
	i $p(result,"^",15)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",15)
	s resultex=resultex_"^"	//
	i $p(result,"^",16)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",16)
	s resultex=resultex_"^"	//
	i $p(result,"^",17)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",17)
	s resultex=resultex_"^"	//
	i $p(result,"^",18)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCService",rowid)),"^",18) //2011-10-27 DJ DJ0097 end
	s resultex=##Class(web.DHCEQCommon).Replace(resultex,$C(13,10),"\n")
	q resultex
}

}
