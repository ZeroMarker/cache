Import SQLUser

Class web.DHCEQCMeasureDept Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// add by lmm 2017-06-27 396400
/// 增加查询信息及出参 联系人：ContPerson 联系电话：Tel
Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,ContPerson:%String,Tel:%String")
{
SELECT MD_Name,
	   MD_RowID,
	   MD_Code,
	   MD_ContPerson,
	   MD_Tel
FROM sqluser.DHC_EQCMeasureDept
where MD_InvalidFlag = 'N' and MD_Name like nvl(:para,'')||'%'
}

ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "")
{
	
 k PLIST,rowid
 s rowid=$p(val,"^",1)
 i (+isDel=1)
 {
	 s PLIST(11) ="Y"
	  &SQL(Update SQLUSER.DHC_EQCMeasureDept Values :PLIST() where MD_RowID = :rowid) 	 
 	//&SQL(Delete From SQLUSER.DHC_EQCMeasureDept where MD_RowID = :rowid)
 	if SQLCODE  q SQLCODE
 	q rowid
 } 
 ;i $p(val,"^",2)'=""  
  s PLIST(2) = $p(val,"^",2)	;名称2
  s PLIST(3) = $p(val,"^",3)	;代码3
  s PLIST(4) = $p(val,"^",4)	;地址4
  s PLIST(5) = $p(val,"^",5)	;电话5
  s PLIST(6) = $p(val,"^",6) ;邮编6
  s PLIST(7) = $p(val,"^",7) ;传真7
  s PLIST(8) = $p(val,"^",8) ;联系人8
  s PLIST(9) = $p(val,"^",9)	;短名称9
  s PLIST(10) = $p(val,"^",10)	;等级10
  s PLIST(12) = $p(val,"^",11)	; //2011-10-27 DJ DJ0097 begin
  s PLIST(13) = $p(val,"^",12)	;
  s PLIST(14) = $p(val,"^",13)	;
  s PLIST(15) = $p(val,"^",14)	;
  s PLIST(16) = $p(val,"^",15)	;
  s PLIST(17) = $p(val,"^",16)	;
  s PLIST(18) = $p(val,"^",17)	;
  s PLIST(19) = $p(val,"^",18)	; //2011-10-27 DJ DJ0097 end
  //2010-06-11 党军 begin
  s PLIST(11)="N"
  s Find=""
  &SQL(Select MD_RowID Into :Find From SQLUSER.DHC_EQCMeasureDept Where (MD_Code=:PLIST(3) or MD_Name =:PLIST(2)) and MD_InvalidFlag='N' )
  if Find=""
  {
	  if rowid=""
	  {
		  &SQL(Insert Into SQLUSER.DHC_EQCMeasureDept Values :PLIST())
	  }
	  else
	  {
		  &SQL(Update SQLUSER.DHC_EQCMeasureDept Values :PLIST() where MD_RowID = :rowid)
	  }
  }
  else
  {
	  if Find=rowid
	  {
		  &SQL(Update SQLUSER.DHC_EQCMeasureDept Values :PLIST() where MD_RowID = :rowid)
	  }
	  else
	  {
		  q -99
	  }
  }
  //2010-06-11 党军 end
 if SQLCODE  q SQLCODE
 Set ID=$g(%ROWID)
 q ID
}

ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQCMeasureDept",rowid)
	s resultex=rowid
	s resultex=resultex_"^"	//名称
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMeasureDept",rowid)),"^",1)
	s resultex=resultex_"^"	//代码
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMeasureDept",rowid)),"^",2)
	s resultex=resultex_"^"	//地址
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMeasureDept",rowid)),"^",3)
	s resultex=resultex_"^"	//电话
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMeasureDept",rowid)),"^",4)
	s resultex=resultex_"^"	//邮编
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMeasureDept",rowid)),"^",5)
	s resultex=resultex_"^"	//传真
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMeasureDept",rowid)),"^",6)
	s resultex=resultex_"^"	//联系人
	i $p(result,"^",7)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMeasureDept",rowid)),"^",7)
	s resultex=resultex_"^"	//短名称
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMeasureDept",rowid)),"^",8)
	s resultex=resultex_"^"	//等级
	i $p(result,"^",9)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMeasureDept",rowid)),"^",9)
	s resultex=resultex_"^"	// 2011-10-27 DJ DJ0097 begin
	i $p(result,"^",11)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMeasureDept",rowid)),"^",11)
	s resultex=resultex_"^"	//
	i $p(result,"^",12)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMeasureDept",rowid)),"^",12)
	s resultex=resultex_"^"	//
	i $p(result,"^",13)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMeasureDept",rowid)),"^",13)
	s resultex=resultex_"^"	//
	i $p(result,"^",14)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMeasureDept",rowid)),"^",14)
	s resultex=resultex_"^"	//
	i $p(result,"^",15)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMeasureDept",rowid)),"^",15)
	s resultex=resultex_"^"	//
	i $p(result,"^",16)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMeasureDept",rowid)),"^",16)
	s resultex=resultex_"^"	//
	i $p(result,"^",17)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMeasureDept",rowid)),"^",17)
	s resultex=resultex_"^"	//
	i $p(result,"^",18)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMeasureDept",rowid)),"^",18) //2011-10-27 DJ DJ0097 end
	s resultex=##Class(web.DHCEQCommon).Replace(resultex,$C(13,10),"\n")
	q resultex
}

ClassMethod MeasureDeptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MeasureDeptExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 将所有ShName改为Shname  ContPerson改为Contperson  需求号：273781 Modify by Mwz 2016-10-21 
ClassMethod MeasureDeptExecute(ByRef qHandle As %Binary, Name As %String = "", Code As %String = "", Address As %String = "", Tel As %String = "", Zip As %String = "", Fax As %String = "", Contperson As %String = "", Shname As %String = "", Grading As %String = "") As %Status
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
 	s Contperson=$ZCONVERT(Contperson ,"U")
 	s Shname=$ZCONVERT(Shname ,"U")
 	s Grading=$ZCONVERT(Grading ,"U")
	s index=1
	s TRow=1
	s rowid=0
	d BuildDataGetMeasureDept
	Quit $$$OK
BuildDataGetMeasureDept
	f  s rowid=$o(^DHCEQCCode("DHCEQCMeasureDept",rowid))  quit:rowid=""  d
	.d ResetVariablesGetMeasureDept
	.s LTRowID = rowid	//rowid
	.s LTMDNam=$p($g(^DHCEQCCode("DHCEQCMeasureDept",rowid)),"^",1) //名称
	.s LTMDCode=$p($g(^DHCEQCCode("DHCEQCMeasureDept",rowid)),"^",2) //代码
	.s LTMDAddress=$p($g(^DHCEQCCode("DHCEQCMeasureDept",rowid)),"^",3) //地址
	.s LTMDTel=$p($g(^DHCEQCCode("DHCEQCMeasureDept",rowid)),"^",4) //电话
	.s LTMDZip=$p($g(^DHCEQCCode("DHCEQCMeasureDept",rowid)),"^",5) //邮编
	.s LTMDFax=$p($g(^DHCEQCCode("DHCEQCMeasureDept",rowid)),"^",6) //传真
	.s LTMDContperson=$p($g(^DHCEQCCode("DHCEQCMeasureDept",rowid)),"^",7) //联系人
	.s LTMDShname=$p($g(^DHCEQCCode("DHCEQCMeasureDept",rowid)),"^",8) //短名称
	.s LTMDGrading=$p($g(^DHCEQCCode("DHCEQCMeasureDept",rowid)),"^",9) //等级
	.s LTMDInvalidFlag=$p($g(^DHCEQCCode("DHCEQCMeasureDept",rowid)),"^",10)
	.q:(LTMDInvalidFlag="Y")
	.q:($ZCONVERT(LTMDNam,"U")'[Name)&(Name'="")
	.q:($ZCONVERT(LTMDCode,"U")'[Code)&(Code'="")
	.q:($ZCONVERT(LTMDAddress,"U")'[Address)&(Address'="")
	.q:($ZCONVERT(LTMDTel,"U")'[Tel)&(Tel'="")
	.q:($ZCONVERT(LTMDZip,"U")'[Zip)&(Zip'="")
	.q:($ZCONVERT(LTMDFax,"U")'[Fax)&(Fax'="")
	.q:($ZCONVERT(LTMDContperson,"U")'[Contperson)&(Contperson'="")
	.q:($ZCONVERT(LTMDShname,"U")'[Shname)&(Shname'="")
	.q:($ZCONVERT(LTMDGrading,"U")'[Grading)&(Grading'="")
	.s LTMDBank=$p($g(^DHCEQCCode("DHCEQCMeasureDept",rowid)),"^",11) // 2011-10-27 DJ DJ0097 begin
	.s LTMDBankNo=$p($g(^DHCEQCCode("DHCEQCMeasureDept",rowid)),"^",12) //
	.s LTMDEMail=$p($g(^DHCEQCCode("DHCEQCMeasureDept",rowid)),"^",13) //
	.s LTMDHold1=$p($g(^DHCEQCCode("DHCEQCMeasureDept",rowid)),"^",14) //
	.s LTMDHold2=$p($g(^DHCEQCCode("DHCEQCMeasureDept",rowid)),"^",15) //
	.s LTMDHold3=$p($g(^DHCEQCCode("DHCEQCMeasureDept",rowid)),"^",16) //
	.s LTMDHold4=$p($g(^DHCEQCCode("DHCEQCMeasureDept",rowid)),"^",17) //
	.s LTMDHold5=$p($g(^DHCEQCCode("DHCEQCMeasureDept",rowid)),"^",18) // 2011-10-27 DJ DJ0097 end
	.d OutputRowGetMeasureDept
	quit
OutputRowGetMeasureDept
	s Data=$lb(LTRowID,LTMDNam,LTMDCode,LTMDAddress,LTMDTel,LTMDZip,LTMDFax,LTMDContperson,LTMDShname,LTMDGrading,LTMDBank,LTMDBankNo,LTMDEMail,LTMDHold1,LTMDHold2,LTMDHold3,LTMDHold4,LTMDHold5,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetMeasureDept
	s (LTRowID,LTMDNam,LTMDCode,LTMDAddress,LTMDTel,LTMDZip,LTMDFax,LTMDContperson,LTMDShname,LTMDGrading,LTMDBank,LTMDBankNo,LTMDEMail,LTMDHold1,LTMDHold2,LTMDHold3,LTMDHold4,LTMDHold5)=""
	quit
}

ClassMethod MeasureDeptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MeasureDeptExecute ]
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

Query MeasureDept(Name As %String = "", Code As %String = "", Address As %String = "", Tel As %String = "", Zip As %String = "", Fax As %String = "", Contperson As %String = "", Shname As %String = "", Grading As %String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TCode:%String,TAddress:%String,TTel:%String,TZip:%String,TFax:%String,TContperson:%String,TShname:%String,TGrading:%String,TBank:%String,TBankNo:%String,TEMail:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TRow:%String")
{
}

}
