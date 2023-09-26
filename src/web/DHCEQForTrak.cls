Import SQLUser

/// 
/// -----------------------------------------
/// 修改人： ZY 2009-10-26  zy0013
/// 新增方法：UpdProvider
/// 目的:系统自动录入供应商
/// 描述:检测供应商表是否存在当前数据.是则返回RowID,否则新增记录并返回RowID
/// -----------------------------------------
/// 修改人： JDL 2009-06-23
/// 修改目的：解决JDL0018,增加供应商分类的处理。
/// 修改内容：修改方法GetAPCVendor、UpdateAPCVendor、GetOneVendor
/// -----------------------------------------
/// 
Class web.DHCEQForTrak Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 52;

Query GetAPCVendor(Code As %String = "", Name As %String = "", VendCatDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TCode:%String,TVendCat:%String")
{
}

ClassMethod GetAPCVendorExecute(ByRef qHandle As %Binary, Code As %String, Name As %String, VendCatDR As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetAPCVendor
	Quit $$$OK
BuildDataGetAPCVendor
	if Code'=""
	{
	 s vendorCode=$ZCVT(Code,"U")
	 s curNode=$o(^APC("APCVM",0,"APCVM_Code",vendorCode),-1)
	 f  s curNode=$o(^APC("APCVM",0,"APCVM_Code",curNode))  quit:curNode=""  d
	 .q:curNode'[vendorCode
	 .s rowid=0
	 .f  s rowid=$o(^APC("APCVM",0,"APCVM_Code",curNode,rowid)) quit:rowid=""  d
	 ..d OutputRowGetAPCVendor
	}
	elseif Name'=""
	{s vendorDesc=$ZCVT(Name,"U")
	 s curNode=$o(^APC("APCVM",0,"APCVM_Name",vendorDesc),-1)
	 f  s curNode=$o(^APC("APCVM",0,"APCVM_Name",curNode))  quit:curNode=""  d
	 .q:curNode'[vendorDesc
	 .s rowid=0
	 .f  s rowid=$o(^APC("APCVM",0,"APCVM_Name",curNode,rowid)) quit:rowid=""  d
	 ..d OutputRowGetAPCVendor
	}
	else
	{
	 s rowid=0
	 f  s rowid=$o(^APC("APCVM",rowid)) quit:rowid=""  d
	 .d OutputRowGetAPCVendor
	}	
	quit
	
OutputRowGetAPCVendor
	s code=$p($g(^APC("APCVM",rowid)),"^",2)	
	s desc=$p($g(^APC("APCVM",rowid)),"^",3)
	q:$ZCVT(desc,"U")'[$ZCVT(Name,"U")
	q:$ZCVT(code,"U")'[$ZCVT(Code,"U")
	
	//add by 2009-06-23 jdl JDL0018
	//s VendCatDR=##class(web.DHCEQCommon).GetSysInfo("990008")
	q:(VendCatDR'="")&&($P($g(^APC("APCVM",rowid,1)),"^",1)'="")&&($P($g(^APC("APCVM",rowid,1)),"^",1)'=VendCatDR)
	s TVendCat=$P($g(^APC("APCVM",rowid,1)),"^",1)
	i TVendCat'="" s TVendCat=$P($g(^APC("APCVC",TVendCat)),"^",3)
	
	s Data=$lb(rowid,desc,code,TVendCat)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetAPCVendorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAPCVendorExecute ]
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

ClassMethod GetAPCVendorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAPCVendorExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQForTrak).UpdateAPCVendor(3399,"810","SHDXG-上海东星")
ClassMethod UpdateAPCVendor(id, code, desc, catdr As %String = "")
{
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set MEDDATA=Config.DataNamespace
	Set LABDATA=Config.LabDataNamespace
	Set CurrentNS=$ZNSPACE
	ZN MEDDATA	
	Set rtn=$$UpdateAPCVendor^DHCEQCommonForTrak(id,code,desc)	
	ZN CurrentNS
	q rtn
}

/// w ##Class(web.DHCEQForTrak).GetOneVendor(3925)
ClassMethod GetOneVendor(rowid)
{
	if rowid="" q ""
	s data=$g(^APC("APCVM",rowid))
	s code=$p(data,"^",2)
	s desc=$p(data,"^",3)
	s vendcatdr=$P($g(^APC("APCVM",rowid,1)),"^",1)
	if vendcatdr=$c(0) s vendcatdr=""
	s vendcat=""
	if (vendcatdr'="") s vendcat=$P(^APC("APCVC",vendcatdr),"^",3)
	q "^"_code_"^"_desc_"^"_vendcatdr_"^"_vendcat
}

/*
/// 创建:ZY 2009-10-26  zy0013
/// 目的:系统自动录入供应商
/// 描述:检测生产厂商表是否存在当前数据.是则返回RowID,否则新增记录并返回RowID
/// 输入: data:供应商
/// 输出: 无
/// 返回值: 成功返回RowID, 失败返回错误代码
/// w ##Class(web.DHCEQForTrak).UpdProvider("hhff^我w^")
ClassMethod UpdProvider(data)
{
	n prowid,ProviderOperMethod,Provider,code,desc
	s prowid=""
	s code=$p(data,"^",1)
	s desc=$p(data,"^",2)
	s code=$ZCONVERT(code,"U")
	s Provider=code_"-"_desc
	s SQLCODE=0
	s ProviderOperMethod=##class(web.DHCEQCommon).GetSysInfo("201006")
	if (ProviderOperMethod=0)||(desc="") q ""
	&SQL(Select APCVM_RowID Into :prowid from SQLUSER.APC_Vendor Where APCVM_Name=:Provider)
	if prowid="" //新增当前供应商
	{
		s prowid=..UpdateAPCVendor("",desc,Provider,"")
		s prowid=$p(prowid,"^",2)
		s prowid=$p(prowid,$c(1),1)
	}
	q prowid
}
*/
/// 创建:ZY 2009-10-26  zy0013
/// 目的:系统自动录入供应商
/// 描述:检测生产厂商表是否存在当前数据.是则返回RowID,否则新增记录并返回RowID
/// 输入: data:供应商
/// 输出: 无
/// 返回值: 成功返回RowID, 失败返回错误代码
/// Add By QW2021 bug号:QW00 增加参数CurUser
/// w ##Class(web.DHCEQForTrak).UpdProvider("HJXJYDNYXGS^昆明联想电脑有限公司^czf^12435^3")
ClassMethod UpdProvider(data, CurUser As %Library.String = "")
{
	n prowid,ProviderOperMethod,code,desc
	s prowid=""
	s code=##Class(web.DHCEQCommon).Trim($ZCONVERT($p(data,"^",1),"U"))
 	s desc=##Class(web.DHCEQCommon).Trim($ZCONVERT($p(data,"^",2),"U"))
	i desc="" q ""
	i code="" s code=##class(web.DHCEQCHanZiEncoding).GetEncoding(desc,4,"","U")		//czf 20201012
	s ProviderHandler=$p(data,"^",3)	//2013-01-14 DJ
	s ProviderTel=$p(data,"^",4)		//2013-01-14 DJ
	s FirmType=$p(data,"^",5)			//modified by CZF0093 2020-03-17 begin		modified by czf 20200910 bug号:CZF0126 begin
	i FirmType="" s FirmType=2
	s code=$ZCONVERT(code,"U")
	s SQLCODE=0
	s ProviderOperMethod=##class(web.DHCEQCommon).GetSysInfo("201006")
	if (ProviderOperMethod=0)||(desc="") q ""
	s FirmTypes=""
	&SQL(Select V_RowID,V_Hold3 Into :prowid,:FirmTypes from SQLUSER.DHC_EQCVendor Where V_Name=:desc and V_InvalidFlag='N')
	i (FirmTypes'="") d
	.i (","_FirmTypes_",")'[(","_FirmType_",") s FirmTypes=FirmTypes_","_FirmType
	e  s FirmTypes=FirmType
	s val=prowid_"^"_code_"^"_desc_"^^^^^^"_ProviderHandler_"^"_ProviderTel_"^^^^^^^^^^^^^^"_FirmTypes
	s prowid=##Class(web.DHCEQCVendor).SaveData(val,"",CurUser)		// Add By QW2021 bug号:QW00 增加参数CurUser
	q prowid
}

/// add by CZF 2020-03-21 CZF0094
/// 供应商、生产厂商保存
/// w ##Class(web.DHCEQForTrak).SaveProvider(val,"")
ClassMethod SaveProvider(val As %Library.String = "", isDel As %Library.String = "")
{
	k PLIST,rowid
	s rowid=$p(val,"^",1)
	i (+isDel=1)
	{
		s PLIST(20)="Y"
	 	&SQL(Update SQLUSER.DHC_EQCVendor Values :PLIST() where V_RowID = :rowid) 
		if SQLCODE  q SQLCODE
	 	q rowid
	}
 
 	s PLIST(2) = $ZCONVERT($p(val,"^",2),"U") ;Code //2011-10-26 DJ DJ0097
  	s PLIST(3) = $p(val,"^",3) ;Name
  	s Name=$p(val,"^",3)
 	s PLIST(4) = $p(val,"^",4) ;Address
 	s PLIST(5) = $p(val,"^",5) ;Province
  	s PLIST(6) = $p(val,"^",6) ;City
  	s PLIST(7) = $p(val,"^",7) ;State
  	s PLIST(8) = $p(val,"^",8) ;ZipCode
  	s PLIST(9) = $p(val,"^",9) ;ConPerson
  	s PLIST(10) = $p(val,"^",10) ;Tel
  	s PLIST(11) = $p(val,"^",11) ;Fax
  	s PLIST(12) = $p(val,"^",12) ;ShName
  	s PLIST(13) = $p(val,"^",13) ;Grading
  	s PLIST(14) = $p(val,"^",14) ;Bank
  	s PLIST(15) = $p(val,"^",15) ;BankNo
  	s PLIST(16) = $p(val,"^",16) ;RegistrationNo
  	s PLIST(17) = $p(val,"^",17) ;Remark
  	s PLIST(19) = $p(val,"^",23)	;ExDesc
 	s PLIST(20) = "N"
  	s PLIST(21) =$p(val,"^",18)	;Hold1
  	s PLIST(22) =$p(val,"^",19)	;Hold2	
  	s PLIST(23) =$p(val,"^",20)	;Hold3
  	s PLIST(24) =$p(val,"^",21)	;Hold4
  	s PLIST(25) =$p(val,"^",22)	;Hold5
   
  	&SQL(select V_RowID into :Rowid from DHC_EQCVendor where V_Name=:Name and V_InvalidFlag='N')
  
	if (Rowid="")
 	{
	 	i (rowid="")         //modified by CZF0094 begin
	 	{
			&SQL(Insert Into SQLUSER.DHC_EQCVendor Values :PLIST())
		} 
		else
		{
			&SQL(Update SQLUSER.DHC_EQCVendor Values :PLIST() where V_RowID = :rowid)
		}
	 }
	 else
	 {
		 q:rowid="" ""
		 q:(rowid'="")&&(rowid'=Rowid) ""
		 &SQL(Update SQLUSER.DHC_EQCVendor Values :PLIST() where V_RowID = :rowid)
	 }
	if SQLCODE  q SQLCODE
	Set ID=$g(%ROWID)		  //modified by CZF0094 end
	q ID
}

}
