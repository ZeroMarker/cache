Import SQLUser

/// -----------------------------------------
/// 修改人： ZY 2009-10-26  ZY0013
/// 新增方法：UpdManufacturer
/// 目的:系统自动录入生产厂商
/// 描述:检测生产厂商表是否存在当前数据.是则返回RowID,否则新增记录并返回RowID
/// -----------------------------------------
Class web.DHCEQCManufacturer Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/*
Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT MF_Name,
	   MF_RowID,
	   MF_Code
FROM sqluser.DHC_EQCManufacturer
where MF_InvalidFlag = 'N' and (UCASE(MF_Name) like nvl(UCASE(:para),'')||'%' or UCASE(MF_Code) like nvl(UCASE(:para),'')||'%')
}
*/
ClassMethod ManufactureClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ManufactureExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// /modified by czf 需求号：335916
ClassMethod ManufactureExecute(ByRef qHandle As %Binary, Name As %String = "", Code As %String = "", Address As %String = "", Tel As %String = "", Zip As %String = "", Fax As %String = "", Contperson As %String = "", Shname As %String = "", Grading As %String = "", Hold1 As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp) //获得当前所有输出id设备
 	Set qHandle=$lb(0,repid,0)
 	s Name=$ZCONVERT(Name ,"U")
 	s Code=$ZCONVERT(Code ,"U")
 	s Address=$ZCONVERT(Address ,"U")
 	s Tel=$ZCONVERT(Tel ,"U")
 	s Zip=$ZCONVERT(Zip ,"U")
 	s Fax=$ZCONVERT(Fax ,"U")
 	s Contperson=$ZCONVERT(Contperson ,"U")
 	s Shname=$ZCONVERT(Shname ,"U")
 	s Grading=$ZCONVERT(Grading ,"U")
	s index=1
	s TRow=1
	s rowid=0
	d BuildDataGetManufacture
	Quit $$$OK
BuildDataGetManufacture
	f  s rowid=$o(^DHCEQCCode("DHCEQCManufacturer",rowid))  quit:rowid=""  d
	.d ResetVariablesGetManufacture
	.s LTRowID = rowid	//rowid
	.s LTMDCode=$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",2) //代码1
	.s LTMDAddress=$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",3) //地址2
	.s LTMDTel=$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",4) //电话3
	.s LTMDZip=$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",5) //邮编4
	.s LTMDFax=$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",6) //传真5
	.s LTMDContperson=$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",7) //联系人6
	.s LTMDShname=$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",8) //短名称7
	.s LTMDGrading=$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",9) //等级8
	.s LTMDNam=$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",1) //名称9
    .s LTMDInvalidFlag=$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",10)
	.q:(LTMDInvalidFlag="Y") //  Grading As %String = ""
	.q:($ZCONVERT(LTMDNam,"U")'[Name)&(Name'="")
	.q:($ZCONVERT(LTMDCode,"U")'[Code)&(Code'="")
	.q:($ZCONVERT(LTMDAddress,"U")'[Address)&(Address'="")
	.q:($ZCONVERT(LTMDTel,"U")'[Tel)&(Tel'="")
	.q:($ZCONVERT(LTMDZip,"U")'[Zip)&(Zip'="")
	.q:($ZCONVERT(LTMDFax,"U")'[Fax)&(Fax'="")
	.q:($ZCONVERT(LTMDContperson,"U")'[Contperson)&(Contperson'="")
	.q:($ZCONVERT(LTMDShname,"U")'[Shname)&(Shname'="")
	.q:($ZCONVERT(LTMDGrading,"U")'[Grading)&(Grading'="")
	.//q:$ZCONVERT(LTMDNam,"U")'[$ZCONVERT(Name,"U")
	.s LTHold1=$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",11)
	.q:(Hold1'="")&&(LTHold1'[Hold1)
	.s LTHold2=$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",12)
	.s LTHold3=$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",13)
	.s LTHold4=$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",14)
	.s LTHold5=$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",15)
    .d OutputRowGetManufacture
	quit
OutputRowGetManufacture
	s Data=$lb(LTRowID,LTMDCode,LTMDAddress,LTMDTel,LTMDZip,LTMDFax,LTMDContperson,LTMDShname,LTMDGrading,LTMDNam,LTHold1,LTHold2,LTHold3,LTHold4,LTHold5,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetManufacture
	s (LTRowID,LTMDCode,LTMDAddress,LTMDTel,LTMDZip,LTMDFax,LTMDContperson,LTMDShname,LTMDGrading,LTMDNam,LTHold1,LTHold2,LTHold3,LTHold4,LTHold5)=""
	quit
}

ClassMethod ManufactureFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ManufactureExecute ]
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

Query Manufacture(Name As %String = "", Code As %String = "", Address As %String = "", Tel As %String = "", Zip As %String = "", Fax As %String = "", Contperson As %String = "", Shname As %String = "", Grading As %String = "", Hold1 As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TAddress:%String,TTel:%String,TZip:%String,TFax:%String,TContperson:%String,TShname:%String,TGrading:%String,TName:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TRow:%String")
{
}

ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "")
{
	// Mozy0030	2010-11-11
	new Rowid
	s Rowid=""
 k PLIST,rowid
 s rowid=$p(val,"^",1)
 i (+isDel=1)
 {
	  s PLIST(11) = "Y"
	 &SQL(Update SQLUSER.DHC_EQCManufacturer Values :PLIST() where MF_RowID = :rowid) 	 
 	//&SQL(Delete From SQLUSER.DHC_EQCManufacturer where MF_RowID = :rowid)
 	if SQLCODE  q SQLCODE
 	q rowid
 } 
 // i $p(val,"^",2)'=""  s PLIST(2) = $p(val,"^",2)	;名称2
 s PLIST(2) = $p(val,"^",2)	;名称2
 s name= $p(val,"^",2)
 s PLIST(3) = $ZCONVERT($p(val,"^",3),"U")	;代码3
 s code=$ZCONVERT($p(val,"^",3),"U")
 s PLIST(4) = $p(val,"^",4)	;地址4
 s PLIST(5) = $p(val,"^",5)	;电话5
 s PLIST(6) = $p(val,"^",6) ;邮编6
 s PLIST(7) = $p(val,"^",7) ;传真7
 s PLIST(8) = $p(val,"^",8) ;联系人8
 s PLIST(9) = $p(val,"^",9)	;短名称9
 s PLIST(10) = $p(val,"^",10)	;等级10
 s PLIST(11) = "N"
 s PLIST(12) = $p(val,"^",11)
 s PLIST(13) = $p(val,"^",12)
 s PLIST(14) = $p(val,"^",13)
 s PLIST(15) = $p(val,"^",14)
 s PLIST(16) = $p(val,"^",15)
 ;&SQL(select MF_RowID into :Rowid from DHC_EQCManufacturer where MF_Name=:name and MF_Code=:code and MF_InvalidFlag='N')
 &SQL(select MF_RowID into :Rowid from DHC_EQCManufacturer where MF_Name=:name and MF_InvalidFlag='N')	;Mozy	2016-5-20
 if (Rowid=rowid)
 { 
 &SQL(Update SQLUSER.DHC_EQCManufacturer Values :PLIST() where MF_RowID = :rowid) 	 
 i (+isDel=2)
 {
 	&SQL(Insert Into SQLUSER.DHC_EQCManufacturer Values :PLIST())
 	if SQLCODE  q SQLCODE
 	Set ID=$g(%ROWID)
 q ID
 } 
 }
 	elseif (Rowid="")
 	{
 if (rowid'="") 
 {
 	 &SQL(Update SQLUSER.DHC_EQCManufacturer Values :PLIST() where MF_RowID = :rowid) 	 
 }
 else
 {	 
	 &SQL(Insert Into SQLUSER.DHC_EQCManufacturer Values :PLIST())
 }
 }
 else {
	 q -2001
	 }
 if SQLCODE  q SQLCODE
 Set ID=$g(%ROWID)
 q ID
}

ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQCManufacturer",rowid)
	s resultex=rowid
	s resultex=resultex_"^"	//名称
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",1)
	s resultex=resultex_"^"	//代码
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",2)
	s resultex=resultex_"^"	//地址
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",3)
	s resultex=resultex_"^"	//电话
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",4)
	s resultex=resultex_"^"	//邮编
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",5)
	s resultex=resultex_"^"	//传真
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",6)
	s resultex=resultex_"^"	//联系人
	i $p(result,"^",7)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",7)
	s resultex=resultex_"^"	//短名称
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",8)
	s resultex=resultex_"^"	//等级
	i $p(result,"^",9)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",9)
	s resultex=resultex_"^"	//11
	i $p(result,"^",11)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",11)
	s resultex=resultex_"^"	//12
	i $p(result,"^",12)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",12)
	s resultex=resultex_"^"	//13
	i $p(result,"^",13)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",13)
	s resultex=resultex_"^"	//14
	i $p(result,"^",14)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",14)
	s resultex=resultex_"^"	//15
	i $p(result,"^",15)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",15)
	s resultex=##Class(web.DHCEQCommon).Replace(resultex,$C(13,10),"\n")
	q resultex
}

ClassMethod FindClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindExecute(ByRef qHandle As %Binary, Name As %String = "", Code As %String = "", Address As %String = "", Tel As %String = "", Zip As %String = "", Fax As %String = "", Contperson As %String = "", Shname As %String = "", Grading As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp) //获得当前所有输出id设备
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetFind
	Quit $$$OK
BuildDataGetFind
	f  s rowid=$o(^DHCEQCCode("DHCEQCManufacturer",rowid))  quit:rowid=""  d
	.d ResetVariablesGetFind
	.s LTRowID = rowid	//rowid
	.s LTMDCode=$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",2) //代码1
	.s LTMDAddress=$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",3) //地址2
	.s LTMDTel=$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",4) //电话3
	.s LTMDZip=$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",5) //邮编4
	.s LTMDFax=$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",6) //传真5
	.s LTMDContperson=$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",7) //联系人6
	.s LTMDShname=$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",8) //短名称7
	.s LTMDGrading=$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",9) //等级8
	.s LTMDNam=$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",1) //名称9
    .s LTMDInvalidFlag=$p($g(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",10)
	.q:(LTMDInvalidFlag="Y")
	.q:(LTMDNam'=Name)&(Name'="") 
	.q:(LTMDCode'=Code)&(Code'="")
	.q:(LTMDAddress'=Address)&(Address'="")
	.q:(LTMDTel'=Tel)&(Tel'="")
	.q:(LTMDZip'=Zip)&(Zip'="")
	.q:(LTMDFax'=Fax)&(Fax'="")
	.q:(LTMDContperson'=Contperson)&(Contperson'="")
	.q:(LTMDShname'=Shname)&(Shname'="")
	.q:(LTMDGrading'=Grading)&(Grading'="")
    .d OutputRowGetFind
	quit
OutputRowGetFind
	s Data=$lb(LTMDNam,LTRowID,LTMDCode)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetFind
	s (LTRowID,LTMDCode,LTMDAddress,LTMDTel,LTMDZip,LTMDFax,LTMDContperson,LTMDShname,LTMDGrading,LTMDNam)=""
	quit
}

ClassMethod FindFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindExecute ]
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

Query Find(Name As %String = "", Code As %String = "", Address As %String = "", Tel As %String = "", Zip As %String = "", Fax As %String = "", Contperson As %String = "", Shname As %String = "", Grading As %String = "") As %Query(ROWSPEC = "TName:%String,HIDDEN:%String,TCode:%String")
{
}

/// 创建:ZY 2009-10-26  zy0013
/// 目的:系统自动录入生产厂商
/// 描述:检测生产厂商表是否存在当前数据.是则返回RowID,否则新增记录并返回RowID
/// 输入: data:生产厂商
/// 输出: 无
/// 返回值: 成功返回RowID, 失败返回错误代码
/// w ##Class(web.DHCEQCManufacturer).UpdManufacturer("ddddddddddd")
ClassMethod UpdManufacturer(data)
{
	n mfrowid,ManufacturerOperMethod,Manufacturer,code,desc
	s mfrowid=""
	s code=##Class(web.DHCEQCommon).Trim($ZCONVERT($p(data,"^",1),"U"))
 	s desc=##Class(web.DHCEQCommon).Trim($ZCONVERT($p(data,"^",2),"U"))
	s SQLCODE=0
	s ManufacturerOperMethod=##class(web.DHCEQCommon).GetSysInfo("201005")
	if (ManufacturerOperMethod=0)||(desc="") q ""
	&SQL(Select MF_RowID Into:mfrowid from SQLUSER.DHC_EQCManufacturer Where MF_InvalidFlag='N' and MF_Name=:desc)
	if mfrowid="" //新增当前生产厂商
	{
		&SQL(Insert Into SQLUSER.DHC_EQCManufacturer(MF_Code,MF_Name,MF_ShName,MF_InvalidFlag) Values(:code,:desc,:desc,'N')) //2009-08-17 增加更新Code和InvalidFlag字段信息
		if SQLCODE
		{
			q SQLCODE
		}
		s mfrowid=$G(%ROWID)
	}
	q mfrowid
}

/// 20150123  Mozy0151	重写生产厂商前匹配检索为模糊检索
/// modified by CZF0093 供应商、生产厂商、服务商三商合一
/// d ##class(%ResultSet).RunQuery("web.DHCEQCManufacturer","LookUp","")
Query LookUp(Manufacturer As %String = "") As %Query(ROWSPEC = "Description:%String:生产厂商,HIDDEN:%String,Code:%String:编码,TAddress:%String:地址,TContPerson:%String:联系人,TTel:%String:联系方式,TFax:%String:传真号,TBank:%String:开户行,TBankNo:%String:开户行账号,TShName:%String:简称")
{
}

ClassMethod LookUpExecute(ByRef qHandle As %Binary, Manufacturer As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$LB(0,repid,0)
 	Set Manufacturer=##Class(web.DHCEQCommon).UnEscape(Manufacturer)
 	Set Manufacturer=$ZCONVERT(Manufacturer ,"U")
 	
 	s FirmType=3	//生产厂商
 	Set index=1
 	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCFirmContrast",0,"FirmType",FirmType,rowid)) q:rowid=""  d	//modified by czf 20200404 begin
	.s FCRowid=$o(^DHCEQCCode("DHCEQCFirmContrast",0,"FirmType",FirmType,rowid,""))
	.q:FCRowid=""
	.q:$p($g(^DHCEQCCode("DHCEQCFirmContrast",FCRowid)),"^",3)="Y"		 //modified by CZF0103 20200408
	.d ResetVariablesLookUpInfo
	.s TRowID = rowid
	.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",19)
	.q:InvalidFlag="Y"
	.s THold3=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",22)		//add by CZF00093 2020-03-17 公司类型
	.s TCode=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",1)
	.s TName=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",2)
	.s TShName=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",11)
	.q:(Manufacturer'="")&&($ZCONVERT(TCode ,"U")'[Manufacturer)&&($ZCONVERT(TName ,"U")'[Manufacturer)&&($ZCONVERT(TShName ,"U")'[Manufacturer)
	.s THold3=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",22)			//modified by czf 20200404 end
	.s TContPerson=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",8)	
	.s TTel=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",9)
	.s TAddress=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",3)
	.s TFax=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",10)
	.s TBank=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",13)
	.s TBankNo=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",14)
	.d OutputRowLookUpInfo
	Quit $$$OK
	
 	/*
	Set index=1
	Set rowid=0
	For  Set rowid=$Order(^DHCEQCCode("DHCEQCManufacturer",rowid)) Quit:rowid=""  Do
	.Do ResetVariablesLookUpInfo
	.Set TRowID = rowid
	.Set InvalidFlag=$Piece($Get(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",10)
	.Quit:InvalidFlag="Y"
	.Set TCode=$Piece($Get(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",2)
	.Set TName=$Piece($Get(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",1)
	.Set TShName=$Piece($Get(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",8)
	.Quit:(Manufacturer'="")&&($ZCONVERT(TCode ,"U")'[Manufacturer)&&($ZCONVERT(TName ,"U")'[Manufacturer)&&($ZCONVERT(TShName ,"U")'[Manufacturer)
	.Do OutputRowLookUpInfo
	*/
OutputRowLookUpInfo
	Set Data=$lb(TName,TRowID,TCode,TAddress,TContPerson,TTel,TFax,TBank,TBankNo,TShName)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesLookUpInfo
	Set (TName,TRowID,TCode,TAddress,TContPerson,TTel,TFax,TBank,TBankNo,TShName)=""
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

ClassMethod LookUpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

}
