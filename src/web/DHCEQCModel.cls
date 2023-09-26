Import SQLUser

Class web.DHCEQCModel Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT M_Desc,
	   M_RowID,
	   M_Code
FROM sqluser.DHC_EQCModel
where M_InvalidFlag = 'N' and M_Desc like nvl(:para,'')||'%'
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQCModel","Model","","","","",64)
Query Model(Code As %String = "", Desc As %String = "", Remark As %String = "", Item As %String = "", ItemDR As %String) As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TRemark:%String,TItem:%String,TInvalidFlage:%String,TItemDR:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TJob:%String,TRow:%String")
{
}

ClassMethod ModelExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", Remark As %String = "", Item As %String = "", ItemDR As %String) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Desc=$ZCONVERT(Desc ,"U")
 	s Code=$ZCONVERT(Code ,"U")
 	s Remark=$ZCONVERT(Remark ,"U")
 	s Item=$ZCONVERT(Item ,"U")
	s index=1
	s rowid=0
	s TRow=1
	s TJob=$j
	
	d BuildDataGetModel
	
	d ##Class(web.DHCEQCommon).SetPageInfo("DHCEQCModel.Model",TJob,index-1)
	
	Quit $$$OK
BuildDataGetModel
	f  s rowid=$o(^DHCEQCCode("DHCEQCModel",rowid))  quit:rowid=""  d
	.d ResetVariablesGetModel
	.s LTRowID = rowid	//rowid
	.s LTCode=$p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",1) //代码
	.s LTDesc=$p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",2) //描述
	.s LTRemark=$p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",3) //备注
	.s LTItemDR=$p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",4) //设备项代码
	.s LTEquipTypeDR=0
	.i LTItemDR'=""  d
	..s LTItem=$p($g(^DHCEQCCode("DHCEQCMasterItem",LTItemDR)),"^",1) //设备项
	..s LTEquipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",LTItemDR)),"^",3) //设备类组
	.s LTInvalidFlag=$p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",5) //无符号标志
	.q:LTInvalidFlag="Y"
	.q:($ZCONVERT(LTCode,"U")'[Code)&(Code'="")
	.q:($ZCONVERT(LTDesc,"U")'[Desc)&(Desc'="")
	.q:($ZCONVERT(LTRemark,"U")'[Remark)&(Remark'="")
	.q:($ZCONVERT(LTItem,"U")'[Item)&(Item'="")
	.q:(ItemDR'="")&(ItemDR'=LTItemDR)
	.q:(LTItemDR'="")&(##Class(web.DHCEQCommon).EquipTypeIsIn(LTEquipTypeDR)'=0)
	.s LTHold1=$p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",6)
	.s LTHold2=$p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",7)
	.s LTHold3=$p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",8)
	.s LTHold4=$p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",9)
	.s LTHold5=$p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",10)
	.d OutputRowGetModel
	quit
OutputRowGetModel
   	s Data=$lb(LTRowID,LTCode,LTDesc,LTRemark,LTItem,LTInvalidFlag,LTItemDR,LTHold1,LTHold2,LTHold3,LTHold4,LTHold5,TJob,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetModel
	s (LTRowID,LTCode,LTDesc,LTRemark,LTItem,LTInvalidFlag,LTItemDR,LTHold1,LTHold2,LTHold3,LTHold4,LTHold5)=""
	quit
}

ClassMethod ModelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ModelExecute ]
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

ClassMethod ModelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ModelExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// modified by sjh SJH0038 2020-11-10 添加数据修改日志记录 
ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "")
{
	k PLIST,rowid
	s rowid=$p(val,"^",1)
	
	s $zt="ErrorSave"
	s TableName="DHC_EQCModel"
	s ClassName="User.DHCEQCModel"
	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s BussID=rowid
	s DCRRowID=""
	s OldObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s NewObj=##class(web.DHCEQ.Plat.JsonObject).%New()
	s FinalObj=##class(web.DHCEQ.Plat.JsonObject).%New()
	TSTART
	i (+isDel=1)
	{
		s OldObject=##Class(User.DHCEQCModel).%OpenId(BussID)
		s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
		
	 	s PLIST(6)="Y"
	 	&SQL(Update SQLUSER.DHC_EQCModel Values :PLIST() where M_RowID = :rowid)

		If SQLCODE
		{
			TRollback
			q SQLCODE
		}
		
		s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,"D","{""MInvalidFlag"":""Y""}",OldObj.%ToJSON(),CurUser,"")
		i Rtn
		{
			TRollback
			q Rtn
		}
		TCommit
		Quit rowid
	 }
	 
	 //modified by sjh SJH0033 2020-09-03 BEGIN
	 s Code= $p(val,"^",2)
	 s Desc= $p(val,"^",3)
	 i (Code="")
	 {
	 	s Code=Desc	 
	 }
	 s PLIST(2) = Code			;结果
	 //modified by sjh SJH0033 2020-09-03 END
	 s PLIST(3) = $p(val,"^",3)	;类型
	 s PLIST(4) = $p(val,"^",4)
	 s PLIST(5) = $p(val,"^",5)
	 s ItemDR=$p(val,"^",5)
	 s PLIST(7)=$p(val,"^",6)
	 s PLIST(8)=$p(val,"^",7)
	 s PLIST(9)=$p(val,"^",8)
	 s PLIST(10)=$p(val,"^",9)
	 s PLIST(11)=$p(val,"^",10)
	 s Rowid=""
	 &SQL(select M_RowID into :Rowid from DHC_EQCModel where M_Desc=:Desc and M_ItemDR=:ItemDR and M_InvalidFlag='N')
	 if ((Rowid'="")&&(Rowid'=rowid)) q -3001	;重复记录
	 if (rowid="")
	 {
		 s PLIST(6) ="N"
		 Set BussID="",OperateType="A"
		 &SQL(Insert Into SQLUSER.DHC_EQCModel Values :PLIST())
	}
	else
	{
		s PLIST(6) ="N"
		Set BussID=rowid,OperateType="U"
		s OldObject=##Class(User.DHCEQCModel).%OpenId(BussID)
		s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
		&SQL(Update SQLUSER.DHC_EQCModel Values :PLIST() where M_RowID = :rowid)
	}
	If SQLCODE
 	{
	 	TRollback
	 	q SQLCODE
	}
	Set ID=$g(%ROWID)
	s OldObject=""	//先关闭对象 czf 2021-01-21
	s FinalObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(##Class(User.DHCEQCModel).%OpenId(ID))
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

ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQCModel",rowid)
	s resultex=rowid   //0
	s resultex=resultex_"^"	//1
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",1)
	s resultex=resultex_"^"	//2
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",2) //描述
	s resultex=resultex_"^"	//3
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",3) //备注
	s resultex=resultex_"^"	//4
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",4) //设备项代码
	s resultex=resultex_"^"	//5
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMasterItem",$p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",4))),"^",1) //设备项
	s resultex=resultex_"^"	//6
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",6) //
	s resultex=resultex_"^"	//7
	i $p(result,"^",7)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",7) //
	s resultex=resultex_"^"	//8
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",8) //
	s resultex=resultex_"^"	//9
	i $p(result,"^",9)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",9) //
	s resultex=resultex_"^"	//10
	i $p(result,"^",10)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",10) //
	q resultex
}

// modified by czf 20170824 增加Hold2输出

Query GetModel(ItemDR, Name) As %Query(ROWSPEC = "Name:%String:名称,Hidden:%String,Code:%String:编码,HistoryFee:%String:历史价格")
{
}

ClassMethod GetModelExecute(ByRef qHandle As %Binary, ItemDR, valName) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	
	d BuildDataGetModelList
	Quit $$$OK
BuildDataGetModelList
	f  s rowid=$o(^DHCEQCCode("DHCEQCModel",rowid))  quit:rowid=""  d
	.d ResetVariablesGetModelList
	.s RowID = rowid
	.s Flag = $p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",5)
	.q:Flag="Y"
	.s Name = $p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",2)
	.s Code=$p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",1)
	.q:(valName'="")&&(($ZCONVERT(Name ,"U")'[$ZCONVERT(valName,"U"))&&($ZCONVERT(Code,"U")'[$ZCONVERT(valName,"U")))
	.s Item=$p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",4)
	.q:(ItemDR'="")&&(ItemDR'=Item)&&(Item'="")
	.s HistoryFee=$p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",7)  //Hold2 历史原值
	.d OutputRowGetModelList
	quit
OutputRowGetModelList
	s Data=$lb(Name,RowID,Code,HistoryFee) //,ModelDR,ManageLocDR,UseLocDR,GroupDR,ManageUserDR,Model,ManageLoc,UseLoc,ManageUser)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetModelList
	s (Name,RowID,Code,HistoryFee)=""
	quit
}

ClassMethod GetModelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetModelExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
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

ClassMethod GetModelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetModelExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 创建:党军 2009-07-09
/// 目的:系统自动录入机型
/// 描述:设备机型为手工录入方式时,检测机型表是否存在当前数据.是则返回RowID,否则新增记录并返回RowID
/// 输入: data:机型名称 itemdr:设备项rowid
/// 输出: 无
/// 返回值: 成功返回RowID, 失败返回错误代码
/// modified by czf 20170831 增加原值保存,保存至Hold2中
ClassMethod UpdModel(data, itemdr)
{
	n rowid,ModelOperMethod
	s rowid=""
	s SQLCODE=0
	s model=##Class(web.DHCEQCommon).Trim($p(data,"^",1))
	s originalfee=$p(data,"^",2)
	if itemdr=""
	{
		s SQLCODE=-1
		q SQLCODE
	}
	;s data=$ZCONVERT(data,"U")
	s ModelOperMethod=##class(web.DHCEQCommon).GetSysInfo("201004")
	if (ModelOperMethod=0)||(model="") q ""
	&SQL(Select M_RowID Into:rowid from SQLUSER.DHC_EQCModel Where M_Code=:model and M_Desc=:model and M_ItemDR=:itemdr)
	if rowid="" //新增当前机型
	{
		&SQL(Insert Into SQLUSER.DHC_EQCModel(M_Code,M_desc,M_ItemDR,M_InvalidFlag,M_Hold2) Values(:model,:model,:itemdr,'N',:originalfee))
		if SQLCODE 
		{
			q SQLCODE
		}
		s rowid=$G(%ROWID)
	}
	else
	{
		&SQL(update SQLUSER.DHC_EQCModel Set M_InvalidFlag='N',M_Hold2=:originalfee where M_RowID=:rowid)
		if SQLCODE 
		{
			q SQLCODE
		}
	}
	q rowid
}

}
