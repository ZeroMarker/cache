Import SQLUser

Class web.DHCEQCPurchaseType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String:申购类别,HIDDEN:%String,Code:%String:编码")
{
SELECT PT_Desc,
	   PT_RowID,
	   PT_Code
FROM sqluser.DHC_EQCPurchaseType
where PT_InvalidFlag = 'N' and PT_Desc like nvl(:para,'')||'%'
}

ClassMethod PurchaseTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PurchaseTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PurchaseTypeExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	s rowid=0
	d BuildDataGetPurchaseType
	Quit $$$OK
BuildDataGetPurchaseType
	f  s rowid=$o(^DHCEQCCode("DHCEQCPurchaseType",rowid))  quit:rowid=""  d
	.d ResetVariablesGetPurchaseType
	.s LTRowID = rowid	//rowid
	.s LTCode = $p($g(^DHCEQCCode("DHCEQCPurchaseType",rowid)),"^",1)	//代码
	.s LTDesc = $p($g(^DHCEQCCode("DHCEQCPurchaseType",rowid)),"^",2)	//描述
	.s LTRemark = $p($g(^DHCEQCCode("DHCEQCPurchaseType",rowid)),"^",3)	//备注
	.s LTDefaultFlag= $p($g(^DHCEQCCode("DHCEQCPurchaseType",rowid)),"^",4)	//默认标志
	.s LTInvalidFlag = $p($g(^DHCEQCCode("DHCEQCPurchaseType",rowid)),"^",5) //无效标志
	.q:(LTInvalidFlag="Y") 
	.d OutputRowGetPurchaseType
	quit
OutputRowGetPurchaseType
	s Data=$lb(LTRowID,LTCode,LTDesc,LTRemark,LTDefaultFlag,LTInvalidFlag,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetPurchaseType
	s (LTRowID,LTCode,LTDesc,LTRemark,LTDefaultFlag,LTInvalidFlag)=""
	quit
}

ClassMethod PurchaseTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PurchaseTypeExecute ]
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

Query PurchaseType() As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TRemark:%String,TDefaultFlag:%String,TInvalidFlag:%String,TRow:%String")
{
}

ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQCPurchaseType",rowid)
	s resultex=rowid
	s resultex=resultex_"^"	//结果
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCPurchaseType",rowid)),"^",1)
	s resultex=resultex_"^"	//类型
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCPurchaseType",rowid)),"^",2)
	s resultex=resultex_"^"	//单位代码
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCPurchaseType",rowid)),"^",3)
	s resultex=resultex_"^"	//单位代码
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCPurchaseType",rowid)),"^",4)
	s resultex=##Class(web.DHCEQCommon).Replace(resultex,$C(13,10),"\n")
	q resultex
}

/// modified by sjh SJH0038 2020-11-10 添加数据修改日志记录 
ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "")
{
	
 k PLIST,rowid
 s rowid=$p(val,"^",1)

 s $zt="ErrorSave"
 s TableName="DHC_EQCPurchaseType"
 s ClassName="User.DHCEQCPurchaseType"
 s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	
 s BussID=rowid	
 s DCRRowID=""
 s OldObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 s NewObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 s FinalObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 TSTART
 
 i (+isDel=1)
 {   	
		s OldObject=##Class(User.DHCEQCPurchaseType).%OpenId(BussID)
		s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)

 		s PLIST(6) = "Y"
 		&SQL(Update SQLUSER.DHC_EQCPurchaseType Values :PLIST() where PT_RowID = :rowid) 
	
	 	If SQLCODE
	 	{
		 	TRollback
		 	q SQLCODE
		}
	 	s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,"D","{""PTInvalidFlag"":""Y""}",OldObj.%ToJSON(),CurUser,"")
	 	i Rtn
	 	{
		 	TRollback
		 	q Rtn
		}
		TCommit
	 	Quit rowid
 } 
 ;i $p(val,"^",2)'="" 
  s PLIST(2) = $p(val,"^",2)	;代码
  s PLIST(3) = $p(val,"^",3)	;描述
  s PLIST(4) = $p(val,"^",4)	;备注
  s PLIST(5)= $p(val,"^",5)	;默认标志
  //2010-06-11 党军 begin
  s PLIST(6)="N"
  s Find=""
  &SQL(Select PT_RowID Into :Find From SQLUSER.DHC_EQCPurchaseType Where (PT_Code=:PLIST(2) or PT_Desc =:PLIST(3)) and PT_InvalidFlag='N')
  if Find=""
  {
	  if rowid=""
	  {
		  Set BussID="",OperateType="A"
		  s PLIST(6)="N"
		  &SQL(Insert Into SQLUSER.DHC_EQCPurchaseType Values :PLIST())	
	  }
	  else
	  {
			Set BussID=rowid,OperateType="U"
			s OldObject=##Class(User.DHCEQCPurchaseType).%OpenId(BussID)
			s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
		    &SQL(Update SQLUSER.DHC_EQCPurchaseType Values :PLIST() where PT_RowID = :rowid)
	  }
  }
  else
  {
	  if Find=rowid
	  {		
	  		Set BussID=rowid,OperateType="U"
			s OldObject=##Class(User.DHCEQCPurchaseType).%OpenId(BussID)
			s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
		    &SQL(Update SQLUSER.DHC_EQCPurchaseType Values :PLIST() where PT_RowID = :rowid)
	  }
	  else
	  {
		  q -99
	  }
  }
	If SQLCODE
 	{
	 	TRollback
	 	q SQLCODE
	}
	Set ID=$g(%ROWID)
	s OldObject=""	//先关闭对象 czf 2021-01-21
	s FinalObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(##Class(User.DHCEQCPurchaseType).%OpenId(ID))
	i BussID'=""	//更新数据获取更新字段Json串
	{
		s key=""
		For
		{
			s value=FinalObj.GetNext(.key)
			q:key=""
    		i (value'=OldObj.%Get(key)) d NewObj.%Set(key,value)
		}
	}
	else			//插入数据
	{
		s BussID=ID
		s NewObj=FinalObj
	}
	
	i NewObj.%ToJSON()'="{}"	//本次未更新则不记录
	{
		s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,OperateType,NewObj.%ToJSON(),OldObj.%ToJSON(),CurUser,"")
		If Rtn
	 	{
		 	TRollback
		 	q Rtn
		}
	}
	TCommit
	q ID
ErrorSave
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORSave"_ErrorMsg     //返回错误消息 ;
}

}
