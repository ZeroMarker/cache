/// 创建人:zy 2010-08-03  No ZY0027
/// 可编辑字段设置
Class web.DHCEQCRoleReqFields Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 创建人:zy 2010-08-03  No ZY0027
/// 可编辑字段设置
/// ,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String
Query GetRoleReqFields(ApproveFlowDR As %Library.String = "", vData As %String = "") As %Query(ROWSPEC = "TRowID:%String,TField:%String,TType:%String,TMustFlag:%String,TPosition:%String,TTableName:%String,TSort:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TRow:%String")
{
}

ClassMethod GetRoleReqFieldsExecute(ByRef qHandle As %Binary, ApproveFlowDR As %Library.String = "", vData As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s TRow=0
	s index=1
	Set vData=##Class(web.DHCEQCommon).UnEscape(vData)
	Set vField=##Class(web.DHCEQCommon).GetDataByName(vData,"vField")
	Set vType=##Class(web.DHCEQCommon).GetDataByName(vData,"vType")
	Set vPosition=##Class(web.DHCEQCommon).GetDataByName(vData,"vPosition")
	Set vHold1=##Class(web.DHCEQCommon).GetDataByName(vData,"vHold1")
	if vHold1="false" set vHold1=""
	if vHold1="true" set vHold1=1
	Set vTableName=##Class(web.DHCEQCommon).GetDataByName(vData,"vTableName")
	Set vSort=##Class(web.DHCEQCommon).GetDataByName(vData,"vSort")
	Set vHold2=##Class(web.DHCEQCommon).GetDataByName(vData,"vHold2")
	Set vMustFlag=##Class(web.DHCEQCommon).GetDataByName(vData,"vMustFlag")
	if vMustFlag="false" set vMustFlag=""
	if vMustFlag="true" set vMustFlag=1
	d BuildDataGetRoleReqFields
	Quit $$$OK
BuildDataGetRoleReqFields
	q:ApproveFlowDR=""
	s Sort=0
	f  s Sort=$o(^DHCEQCCode("DHCEQCRoleReqFields",0,"Flow",ApproveFlowDR,Sort))  quit:Sort=""  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQCCode("DHCEQCRoleReqFields",0,"Flow",ApproveFlowDR,Sort,rowid))  quit:rowid=""  d
	..d ResetVariablesGetRoleReqFields
	..s TRowID = rowid
	..s TMustFlag = $p($g(^DHCEQCCode("DHCEQCRoleReqFields",rowid)),"^",2)
	..;Add by By QW 2018-08-31 HISUI改造
	..if TMustFlag="Y" d  
	...s TMustFlag=1
	..e  d
	...s TMustFlag=0
	..q:(vMustFlag'="")&&(TMustFlag'=vMustFlag)
	..;End  by By QW 2018-08-31 
	..s TField = $p($g(^DHCEQCCode("DHCEQCRoleReqFields",rowid)),"^",3)
	..q:(vField'="")&&(TField'[vField)
	..s TType = $p($g(^DHCEQCCode("DHCEQCRoleReqFields",rowid)),"^",4)
	..i TType'="" s TType = ..GetFieldTypeDisplay(TType)
	..q:(vType'="")&&(TType'=vType)
	..s TPosition = $p($g(^DHCEQCCode("DHCEQCRoleReqFields",rowid)),"^",5)
	..q:(vPosition'="")&&(TPosition'[vPosition)
	..s TTableName = $p($g(^DHCEQCCode("DHCEQCRoleReqFields",rowid)),"^",6)
	..q:(vTableName'="")&&(TTableName'[vTableName)
	..s TSort = Sort
	..q:(vSort'="")&&(TSort'=vSort)
	..s THold1=$p($g(^DHCEQCCode("DHCEQCRoleReqFields",rowid)),"^",8)
	..;Add by By QW 2018-08-31 HISUI改造
	..if THold1="Y" d
	...s THold1=1
	..e  d
	...s THold1=0
	..q:(vHold1'="")&&(THold1'[vHold1)
	..;End  by By QW 2018-08-31 
	..s THold2=$p($g(^DHCEQCCode("DHCEQCRoleReqFields",rowid)),"^",9)
	..q:(vHold2'="")&&(THold2'[vHold2)
	..s THold3=$p($g(^DHCEQCCode("DHCEQCRoleReqFields",rowid)),"^",10)
	..s THold4=$p($g(^DHCEQCCode("DHCEQCRoleReqFields",rowid)),"^",11)
	..s THold5=$p($g(^DHCEQCCode("DHCEQCRoleReqFields",rowid)),"^",12)
	..d OutputRowGetRoleReqFields
	quit
OutputRowGetRoleReqFields
	Set TRow=TRow+1
	s Data=$lb(TRowID,TField,TType,TMustFlag,TPosition,TTableName,TSort,THold1,THold2,THold3,THold4,THold5,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetRoleReqFields
	s (TRowID,TField,TType,TMustFlag,TPosition,TTableName,TSort,THold1,THold2,THold3,THold4,THold5)=""
	quit
}

ClassMethod GetRoleReqFieldsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRoleReqFieldsExecute ]
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

ClassMethod GetRoleReqFieldsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRoleReqFieldsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 创建人:zy 2010-08-03  No ZY0027
/// 可编辑字段设置
/// 描述：数据添加,修改,删除
/// -------------------------------
/// modified by sjh SJH0042 2020-12-04 增加数据修改日志
ClassMethod SaveData(val As %Library.String = "", isDel As %Library.String = "")
{
		
	 new (val,isDel)
	 Set $ZT="ERROR"
	 s tmpid=""
	 s rowid=$p(val,"^",1)
	 s Tablename="DHC_EQCRoleReqFields"
	 s ClassName="User.DHCEQCRoleReqFields"
 	 s CurUser=1  ;##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	
 	 s BussID=rowid	
 	 s OldObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	 s NewObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	 s FinalObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	 s PLIST(2) = $p(val,"^",2)	;FlowDR
	 s FlowDR=$p(val,"^",2)
 	 s PLIST(3) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",3),"bool")	;MustFlag
 	 s PLIST(4) = $p(val,"^",4) ;Field
	 s Field=$p(val,"^",4)
 	 s PLIST(5) = $p(val,"^",5) ;Type
 	 s PLIST(6) = $p(val,"^",6) ;Position
 	 s PLIST(7) = $p(val,"^",7) ;TableName
	 s TableName=$p(val,"^",7)
 	 s PLIST(8) = $p(val,"^",8) 	;Sort
 	 s PLIST(9) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",9),"bool") 	;Hold1
 	 s PLIST(10) = $p(val,"^",10) ;Hold2
 	 s PLIST(11) = $p(val,"^",11) ;Hold3
 	 s PLIST(12) = $p(val,"^",12) ;Hold4
 	 s PLIST(13) = $p(val,"^",13) ;Hold5
 	 &SQL(select RRF_RowID into :tmpid from SQLUSER.DHC_EQCRoleReqFields where RRF_FlowDR=:FlowDR and RRF_Field=:Field and RRF_TableName=:TableName)
	 TSTART
	 i (+isDel=0)  //新增按钮操作
	 {
		 if (tmpid="")
		 {
			 Set BussID="",OperateType="A"
			 &SQL(Insert Into SQLUSER.DHC_EQCRoleReqFields Values :PLIST())
		 }
		
	 }
	 i (+isDel=1)  //删除按钮操作
	 {			 	
	 	s OldObject=##Class(User.DHCEQCRoleReqFields).%OpenId(BussID)
		s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
		&SQL(Delete from SQLUser.DHC_EQCRoleReqFields where RRF_RowID = :rowid)	
		i SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
		} 
	 	s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(Tablename,ClassName,BussID,"D",NewObj.%ToJSON(),OldObj.%ToJSON(),CurUser,"")
	 	i Rtn
	 	{
		 	TROLLBACK
		 	q Rtn
		}
		TCOMMIT
	 	Quit SQLCODE	
	 }
	 i (+isDel=2) //更新按钮操作
	 {
		 if ((tmpid=rowid)||(tmpid=""))
		 {
			 Set BussID=rowid,OperateType="U"
			 s OldObject=##Class(User.DHCEQCRoleReqFields).%OpenId(BussID)
			 s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
			 &SQL(Update SQLUSER.DHC_EQCRoleReqFields Values :PLIST() where RRF_RowID = :rowid)
		 }
	 } 
	If SQLCODE
 	{
	 	TRollback
	 	q SQLCODE
	}
	Set ID=$g(%ROWID)
	s OldObject=""	//先关闭对象 czf 2021-01-21
	s FinalObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(##Class(User.DHCEQCRoleReqFields).%OpenId(ID))
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
		s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(Tablename,ClassName,BussID,OperateType,NewObj.%ToJSON(),OldObj.%ToJSON(),CurUser,"")
		If Rtn
	 	{
		 	TROLLBACK
		 	q Rtn
		}
	}
 	TCOMMIT
 	q SQLCODE
ERROR 
	TROLLBACK	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "<ERROR>"_ErrorMsg     //返回错误消息 ;
}

/// 创建人:zy 2010-08-03  No ZY0027
/// 可编辑字段设置
/// 描述：根据rowid取数据
/// -------------------------------
ClassMethod GetDataByID(rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	if (rowid=0)||(rowid="")  q ""
	s result= $g(^DHCEQCCode("DHCEQCRoleReqFields",rowid))
	i $p(result,"^",8)'="" s $p(result,"^",8)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",8),"bool")
	s resultex=resultex_"^"
	i $p(result,"^",2)'=""  d  //mustflag
	.s resultex=resultex_##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",2),"bool")
	s resultex=resultex_"^"
	i $p(result,"^",4)'=""  d  //type
	.s resultex=resultex_##Class(web.DHCEQCRoleReqFields).GetFieldTypeDisplay($p(result,"^",4))	//20140228  Mozy0120
	s result=result_"^"_resultex
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

/// 创建人:zy 2010-08-03  No ZY0027
/// 可编辑字段设置
/// 描述：字段类型
/// -------------------------------
/// modified by sjh SJH0036 2020-20-13 输出列标题修改
Query FieldType() As %Query(ROWSPEC = "TDesc:%String:描述,hidden:%String")
{
}

ClassMethod FieldTypeExecute(ByRef qHandle As %Binary, EquipNameDR As %String = "", DepreMethodDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetFieldType
	Quit $$$OK
BuildDataGetFieldType
 	for TRowID=1:1:6 d
 	.s TDesc=..GetFieldTypeDisplay(TRowID)
	.d OutputRowGetFieldType
	quit
OutputRowGetFieldType
    s Data=$lb(TDesc,TRowID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod FieldTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FieldTypeExecute ]
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

ClassMethod FieldTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FieldTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetFieldTypeDisplay(id As %Library.String) As %Status
{
	i id=""  q ""
	i +id=1  q "文本"
	i +id=2  q "日期"
	i +id=5  q "时间"	//20140228  Mozy0120
	i +id=3  q "引用"
	i +id=4	 q "数值"		//Add By DJ 2014-09-23
	i +id=6	 q "选择"		//Add By DJ 2016-05-24
	q "未定义"
}

}
