Class web.DHCEQ.Plat.CTBussType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 描述：业务定义
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTBussType","GetBussType","","","1")
Query GetBussType(Code As %String = "", Desc As %String = "", ModuleType As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TName:%String,TModuleTypeDR:%String,TModuleType:%String")
{
}

ClassMethod GetBussTypeExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", ModuleType As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Desc=$ZCONVERT(Desc ,"U")
 	s Code=$ZCONVERT(Code ,"U")
	s index=1
	s RowID=0
	f  s RowID=$o(^DHCEQCCode("DHCEQCBussType",RowID))  quit:RowID=""  d
	.d ResetVariablesGetBussType  
	.q:$p($g(^DHCEQCCode("DHCEQCBussType",RowID)),"^",4)="Y"
	.s TCode=$p($g(^DHCEQCCode("DHCEQCBussType",RowID)),"^",1) 
	.q:(Code'="")&&(TCode'[Code)
	.s TName=$p($g(^DHCEQCCode("DHCEQCBussType",RowID)),"^",2) 
	.q:(Desc'="")&&(TName'[Desc)
	.s TModuleTypeDR=$p($g(^DHCEQCCode("DHCEQCBussType",RowID)),"^",3) 
	.q:(ModuleType'="")&&(TModuleTypeDR'=ModuleType)  
	.s TModuleType=$CASE(TModuleTypeDR,"":"","1":"设备管理","2":"维修管理","3":"效益分析","4":"移动盘点","5":"移动维修","6":"移动验收","7":"移动报废") //Modified By QW20200116 begin BUG:QW0039增加移动验收及报废
	.s TRowID = RowID  
	.d OutputRowGetBussType
	quit $$$OK
OutputRowGetBussType
	s Data=$lb(TRowID,TCode,TName,TModuleTypeDR,TModuleType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetBussType
	s (TRowID,TCode,TName,TModuleTypeDR,TModuleType)=""
	quit
}

ClassMethod GetBussTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBussTypeExecute ]
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

ClassMethod GetBussTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBussTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Modefied by zc 2015-07-27 zc0026
/// 描述：业务定义的新增与更新分开，此部分为更新
/// w ##Class(web.DHCEQ.Plat.CTBussType).SaveBussType("","05","效益分析","1")
/// modified by sjh SJH0038 2020-11-10 添加数据修改日志记录 
ClassMethod SaveBussType(RowId As %String, Code As %String, Desc As %String, ModleType As %String, InvalidFlag As %String = "N")
{
	k PLIST
	s $zt="ErrorSave"
 	s TableName="DHC_EQCBussType"
 	s ClassName="User.DHCEQCBussType"
 	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))		
 	s OldObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	s NewObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	s FinalObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	
	s PLIST(2)=Code
	s PLIST(3)=Desc
	s PLIST(4)=ModleType
	s PLIST(5)="N"
	s tmpid=""
	TStart
	&SQL(select BT_RowID into :tmpid from sqluser.DHC_EQCBussType where BT_Code=:Code and BT_Desc=:Desc and BT_InvalidFlag='N' and BT_ModleType=:ModleType)
	if ((tmpid'="")&&(tmpid'=RowId)) q "-3001"	;重复记录
	
	s OldObject=##Class(User.DHCEQCBussType).%OpenId(RowId) //modified by sjh SJH0041 2020-12-03
	s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
	
	&SQL(Update sqluser.DHC_EQCBussType Values :PLIST() where BT_RowID = :RowId)
	if SQLCODE  
	{
		TRollback
		q SQLCODE
	}
  	s OldObject=""	//先关闭对象 czf 2021-01-21
	s FinalObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(##Class(User.DHCEQCBussType).%OpenId(RowId))
	
	i RowId'=""
	{
		s key=""	//CZF0131 2020-01-20
		For
		{
			s value=FinalObj.GetNext(.key)
			q:key=""
			i (value'=OldObj.%Get(key)) d NewObj.%Set(key,value)
		}
	}	
	s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,RowId,"U",NewObj.%ToJSON(),OldObj.%ToJSON(),CurUser,"")
	If Rtn
	{
		TRollback
		q Rtn
	}
	
	TCommit
	Set ID=$g(%ROWID)
	q SQLCODE  // modified by sjh SJH0041 2020-12-03
ErrorSave
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORSave"_ErrorMsg     //返回错误消息 ;
}

/// d ##Class(web.DHCEQ.Plat.CTBussType).DeleteBussType("59")
/// modified by sjh SJH0038 2020-11-10 添加数据修改日志记录 
ClassMethod DeleteBussType(OPRRowid As %String)
{
	s $zt="ErrorDel"
 	s TableName="DHC_EQCBussType"
 	s ClassName="User.DHCEQCBussType"
 	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	
	TSTART
	i (OPRRowid'="")
	{
		s OldObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
		s OldObject=##Class(User.DHCEQCBussType).%OpenId(OPRRowid)
		s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
		&SQL(Update sqluser.DHC_EQCBussType set BT_InvalidFlag='Y' where BT_RowID = :OPRRowid)
		If SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	
		s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,OPRRowid,"D","{""BTInvalidFlag"":""Y""}",OldObj.%ToJSON(),CurUser,"")
		i Rtn
		{
			 TROLLBACK
		 	q Rtn
		}
	}
	TCOMMIT
	Set ID=$g(%ROWID)
	q SQLCODE  // modified by sjh SJH0041 2020-12-03
ErrorDel
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORSave"_ErrorMsg     //返回错误消息 ;
}

/// Modefied by zc 2015-07-27 zc0026
/// 描述：业务定义的新增与更新分开，此部分为新增
/// w ##Class(web.DHCEQ.Plat.CTBussType).AddBussType("123","CESHI","1")
/// modified by sjh SJH0038 2020-11-10 添加数据修改日志记录 
ClassMethod AddBussType(Code As %String, Desc As %String, ModleType As %String, InvalidFlag As %String = "N")
{
	k PLIST
	s $zt="ErrorAdd"
 	s TableName="DHC_EQCBussType"
 	s ClassName="User.DHCEQCBussType"
 	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	
 	s NewObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	TStart
	s PLIST(2)=Code
	s PLIST(3)=Desc
	s PLIST(4)=ModleType
	s PLIST(5)="N"
	s tmpid=""
	&SQL(select BT_RowID into :tmpid from sqluser.DHC_EQCBussType where BT_Code=:Code and BT_Desc=:Desc and BT_InvalidFlag='N' and BT_ModleType=:ModleType)
	if (tmpid'="") q "-3001"	;重复记录
	&SQL(Insert into sqluser.DHC_EQCBussType Values :PLIST())
	If SQLCODE
	 {
		TRollback
		q SQLCODE
	}
	Set ID=$g(%ROWID)
	s NewObject=##Class(User.DHCEQCBussType).%OpenId(ID)
	s NewObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(NewObject)	
	i NewObj.%ToJSON()'="{}"	//本次未更新则不记录
	{
		s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,ID,"A",NewObj.%ToJSON(),"",CurUser,"")
		If Rtn
	 	{
		 	TRollback
		 	q Rtn
		}
	}
	TCommit
	q ID 
ErrorAdd
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ErrorAdd"_ErrorMsg     //返回错误消息 ;
}

/// w ##Class(web.DHCEQ.Plat.CTBussType).GetBussTypeByCode(1,"63-2")
ClassMethod GetBussTypeByCode(ModleType, Code As %String = "")
{
	if Code="" q ""
	n RowID
	s findlflag=""
	s RowID=0
	f  s RowID=$o(^DHCEQCCode("DHCEQCBussType",RowID)) quit:(RowID="")||(findlflag'="")  d
	.q:$p($g(^DHCEQCCode("DHCEQCBussType",RowID)),"^",4)="Y"
	.q:$p($g(^DHCEQCCode("DHCEQCBussType",RowID)),"^",3)'=ModleType
	.q:$p($g(^DHCEQCCode("DHCEQCBussType",RowID)),"^",1)'=Code
	.s findlflag=$p($g(^DHCEQCCode("DHCEQCBussType",RowID)),"^",2)
	
	q findlflag
}

/// add by ZY 20230104 集中统一处理图片、文件业务类型数据,避免增加业务类型时,遗漏
/// w ##Class(web.DHCEQ.Plat.CTBussType).GetBussTypeForPicture(63-2)
ClassMethod GetBussTypeForPicture(code)
{
    q $Case(code,
                0:"无",
                11:"开箱验收",
                12:"安装调试验收",
                21:"入库",
                22:"转移",
                23:"减少",
                31:"维修",
                32:"保养",
                33:"检查",
                34:"报废",
                "34-1":"报废汇总",
                35:"折旧",
                41:"使用记录",
                51:"设备调帐",
                52:"设备",
                53:"设备盘点",
                54:"设备盘盈",
                61:"工程管理",
                62:"科研课题",
                63:"证件",
                "63-1":"供应商资质",
		"63-2":"生产厂商资质",		// MZY0154	3271991		2023-03-03
                "63-4":"供应商授权",
                67:"公告",
                76:"付款",
                91:"采购申请",
                "91-1":"采购申请厂家报价",
                92:"采购计划",
                93:"采购招标",
                94:"采购合同",
                95:"保修合同",
                96:"产品"
          )
}

}
