/// add by zx 2015-02-04
/// 动作定义表基础数据维护功能
Class web.DHCEQCAction Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
    SELECT A_Desc,
	       A_RowID,
	       A_Code
    FROM sqluser.DHC_EQCAction
    where A_InvalidFlag = 'N' and A_Desc like nvl(:para,'')||'%'
}

/// modified by sjh SJH0038	2020-11-10 增加数据修改日志记录
ClassMethod SaveData(val, isDel)
{
	k PLIST,rowid
	s rowid=$p(val,"^",1)
	
	s $zt="ErrorSave"
	s TableName="DHC_EQCAction"
	s ClassName="User.DHCEQCAction"
	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	
	s BussID=rowid	
	s DCRRowID=""
	s OldObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s NewObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s FinalObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	TSTART
	i (+isDel=1)
	{
		s OldObject=##Class(User.DHCEQCAction).%OpenId(BussID)
		s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)

		s PLIST(6)="Y"
		&SQL(Update sqluser.DHC_EQCAction Values :PLIST() where A_RowID = :rowid) 

	 	If SQLCODE
	 	{
		 	TRollback
		 	q SQLCODE
		}
	 	s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,"D","{""AInvalidFlag"":""Y""}",OldObj.%ToJSON(),CurUser,"")
	 	i Rtn
	 	{
		 	TRollback
		 	q Rtn
		}
		TCommit
	 	Quit rowid
	} 
	s PLIST(2)=$p(val,"^",2)
	s Code=$p(val,"^",2)
	s PLIST(3)=$p(val,"^",3)
	s Desc=$p(val,"^",3)
	s PLIST(4)=$p(val,"^",4)
	s PLIST(5)=$p(val,"^",5)
	s SourceType=$p(val,"^",5)
	s PLIST(6)=##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",6),"bool")
	s tmpid=""
	&SQL(select A_RowID into :tmpid from sqluser.DHC_EQCAction where (A_Code=:Code or A_Desc=:Desc ) and A_SourceType=:SourceType and A_InvalidFlag='N') //Modified by HHM 20150914 HHM0016
	if ((tmpid="")||(tmpid=rowid))
	{
		i (rowid="")
		{
			Set BussID="",OperateType="A"
			Set PLIST(6) ="N"
			&SQL(Insert Into sqluser.DHC_EQCAction Values :PLIST())
		}
		else
		{
			Set BussID=rowid,OperateType="U"
			s OldObject=##Class(User.DHCEQCAction).%OpenId(BussID)
			s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
			&SQL(Update sqluser.DHC_EQCAction Values :PLIST() where A_RowID = :rowid)
		}
	}
	if SQLCODE  
	{
		TRollback
		q SQLCODE
	}
	Set ID=$g(%ROWID)
	s OldObject=""	//先关闭对象 czf 2021-01-21
	s FinalObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(##Class(User.DHCEQCAction).%OpenId(ID))
	i BussID'=""	
	{
		s key=""
		For
		{
			s value=FinalObj.GetNext(.key)
			q:key=""
    		i (value'=OldObj.%Get(key)) d NewObj.%Set(key,value)
		}
	}
	else			
	{
		s BussID=ID
		s NewObj=FinalObj
	}
	
	i NewObj.%ToJSON()'="{}"	
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

Query Action(Code As %String = "", Desc As %String = "", Remark As %String = "", SourceTypeID As %String) As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TRemark:%String,TInvalidFlag:%String,TSourceTypeID:%String,TSourceType:%String,TRow:%String")
{
}

ClassMethod ActionExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", Remark As %String = "", SourceTypeID As %String) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Desc=$ZCONVERT(Desc ,"U")
 	s Code=$ZCONVERT(Code ,"U")
 	s Remark=$ZCONVERT(Remark ,"U")
	s index=1
	s TRow=1
	s rowid=0
	for  s rowid=$o(^DHCEQCCode("DHCEQCAction",rowid)) quit:rowid=""  d
	.d ResetVariablesGetAction
	.s TRowID=rowid
	.s TCode=$p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",1)
	.s TDesc=$p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",2)
	.s TRemark=$p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",3)
	.q:($ZCONVERT(TCode,"U")'[Code)&(Code'="")
	.q:($ZCONVERT(TDesc,"U")'[Desc)&(Desc'="")
	.q:($ZCONVERT(TRemark,"U")'[Remark)&(Remark'="")
	.s TSourceTypeID=$p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",4)
	.q:(SourceTypeID'="")&(SourceTypeID'=TSourceTypeID)
	.i TSourceTypeID'="" d
	..s TSourceType=$p($g(^DHCEQCCode("DHCEQCApproveType",TSourceTypeID)),"^",2)
	.s TInvalidFlag=$p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",5)
	.q:TInvalidFlag="Y"
	.d OutputRowGetAction
	Quit $$$OK
OutputRowGetAction
	s Data=$lb(TRowID,TCode,TDesc,TRemark,TInvalidFlag,TSourceTypeID,TSourceType,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetAction
	s (TRowID,TCode,TDesc,TRemark,TInvalidFlag,TSourceTypeID,TSourceType)=""
	quit
}

ClassMethod ActionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ActionExecute ]
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

ClassMethod ActionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ActionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

ClassMethod GetDocByID(rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQCAction",rowid)
	s resultex=rowid   //0
	s resultex=resultex_"^"	//1
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",1) //代码
	s resultex=resultex_"^"	//2
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",2) //描述
	s resultex=resultex_"^"	//3
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",3) //备注
	s resultex=resultex_"^"	//4
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",4) //来源类型ID
	s resultex=resultex_"^"	//5
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCApproveType",$p(result,"^",4))),"^",2) //来源类型描述
	s resultex=resultex_"^"	//6
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",6) //无效标记
	q resultex
}

/**************************************************************/
/// modified by sjh SJH0036 2020-20-13 输出列标题修改
Query GetAction(Desc As %String = "", ApproveTypeDR As %String = "") As %Query(ROWSPEC = "TDesc:%String:描述,Hidden:%String,TCode:%String:编码")
{
}

ClassMethod GetActionExecute(ByRef qHandle As %Binary, Desc As %String = "", ApproveTypeDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Desc=$ZCONVERT(Desc ,"U")
 	i ApproveTypeDR="" Quit $$$OK
	s index=1
	d ResetVariablesGetActionInfo
	s TDesc="提交"
	s TRowID="0"
	s TCode="0"
	d OutputRowGetActionInfo
	s SourceTypeDR=0
	f  s SourceTypeDR=$o(^DHCEQCCode("DHCEQCAction",0,"SourceType",SourceTypeDR))  q:SourceTypeDR=""  d
	.q:(ApproveTypeDR'="")&&(SourceTypeDR'=ApproveTypeDR)
	.s rowid=0
	.f  s rowid=$o(^DHCEQCCode("DHCEQCAction",0,"SourceType",SourceTypeDR,rowid)) quit:rowid=""  d
	..d ResetVariablesGetActionInfo
	..s TInvalidFlag=$p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",5)
	..q:TInvalidFlag="Y"
	..s TRowID=rowid
	..s TCode=$p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",1)
	..s TDesc=$p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",2)
	..q:(Desc'="")&($ZCONVERT(TDesc,"U")'[Desc)&($ZCONVERT(TCode,"U")'[Desc)
	..d OutputRowGetActionInfo
	Quit $$$OK
OutputRowGetActionInfo
	s Data=$lb(TDesc,TRowID,TCode)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetActionInfo
	s (TDesc,TRowID,TCode)=""
	quit
}

ClassMethod GetActionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetActionExecute ]
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

ClassMethod GetActionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetActionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/***********************************************************************/
}
