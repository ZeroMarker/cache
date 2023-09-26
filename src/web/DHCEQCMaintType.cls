Import SQLUser

/// ---------------------------------------------------
/// modified by GR 2014-09-29
/// 3125 代码维护-保养类型维护-【类型】为过滤条件查找时，页面显示全部类型记录
/// 修改位置MaintTypeExecute()
/// 新增按type类型查找的过程
/// -----------------------------------------------------
Class web.DHCEQCMaintType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query LookUp(para, type) As %SQLQuery(ROWSPEC = "Description:%String:名称,HIDDEN:%String,Code:%String:编码")
{
SELECT MT_Desc,
	   MT_RowID,
	   MT_Code
FROM sqluser.DHC_EQCMaintType
where MT_InvalidFlag = 'N' and MT_Desc like nvl(:para,'')||'%' and MT_Type =:type
}

Query MaintType(Code As %String = "", Desc As %String = "", Remark As %String = "", Type As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TRemark:%String,TInvalidFlage:%String,TType:%String,TRow:%String")
{
}

ClassMethod MaintTypeExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", Remark As %String = "", Type As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	Set Desc=$ZCONVERT(Desc ,"U")
 	Set Code=$ZCONVERT(Code ,"U")
 	Set Remark=$ZCONVERT(Remark ,"U")
	Set index=1
	s TRow=1
	Set rowid=0
	For  Set rowid=$Order(^DHCEQCCode("DHCEQCMaintType",rowid)) Quit:rowid=""  Do
	.Do ResetVariablesMaintType
	.Set TRowID = rowid	//rowid
	.Set TCode=$Piece($Get(^DHCEQCCode("DHCEQCMaintType",rowid)),"^",1) //代码
	.Set TDesc=$Piece($Get(^DHCEQCCode("DHCEQCMaintType",rowid)),"^",2) //描述
	.Set TRemark=$Piece($Get(^DHCEQCCode("DHCEQCMaintType",rowid)),"^",3) //备注
	.Set TInvalidFlag=$Piece($Get(^DHCEQCCode("DHCEQCMaintType",rowid)),"^",4) //无效标志
	.Set TType=$Piece($Get(^DHCEQCCode("DHCEQCMaintType",rowid)),"^",5) //类型
	.Quit:(Type'="")&&(TType'=Type)                                                  //add by GR 2014-09-29 增加按type类型查找 缺陷3125
	.If TType'="" Set TType=$CASE(TType,"1":"保养","2":"检查","3":"维修",:"没有定义")
	.Quit:TInvalidFlag'="N"
	.Quit:($ZCONVERT(TCode,"U")'[Code)&(Code'="")
	.Quit:($ZCONVERT(TDesc,"U")'[Desc)&(Desc'="")
	.Quit:($ZCONVERT(TRemark,"U")'[Remark)&(Remark'="")
	.Do OutputRowMaintType
	Quit $$$OK
OutputRowMaintType
   	Set Data=$lb(TRowID,TCode,TDesc,TRemark,TInvalidFlag,TType,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	Quit
ResetVariablesMaintType
	Set (TRowID,TCode,TDesc,TRemark,TInvalidFlag,TType)=""
	Quit
}

ClassMethod MaintTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MaintTypeExecute ]
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
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod MaintTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MaintTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// MZY0099	2245680		2021-11-13
ClassMethod TypeList(name, width, Type) As %String
{
	;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")
	w "<option value=></option>"
	w "<option value=1>保养</option>"
	w "<option value=2>检查</option>"
	w "<option value=3>维修</option>"
	w "</select>",!
}

/// w ##Class(web.DHCEQCMaintType).SaveData("","","7^24^123^^1")
ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "")
{
	Kill PLIST,rowid
 	Set rowid=$Piece(val,"^",1)
 	If (+isDel=1)
 	{
	 	&SQL(Update sqluser.DHC_EQCMaintType Set MT_InvalidFlag='Y' where MT_RowID = :rowid)
	 	If SQLCODE Quit SQLCODE
	 	Quit rowid
 	}
 	Set PLIST(2) = $Piece(val,"^",2)
	Set Code = $Piece(val,"^",2)
	Set PLIST(3) = $Piece(val,"^",3)
	Set Desc = $Piece(val,"^",3)
	Set PLIST(4) = $Piece(val,"^",4)
	Set PLIST(5) = $Piece(val,"^",5)
	Set PLIST(6) = $Piece(val,"^",6)
	Set Type = $Piece(val,"^",6)
	
	Set Rowid=""
	&SQL(select MT_RowID into :Rowid from sqluser.DHC_EQCMaintType where MT_Desc=:Desc and MT_Type=:Type and MT_InvalidFlag='N')
	if ((Rowid="")||(Rowid=rowid))
	{
		i (+isDel=2)
		{
			Set PLIST(5) ="N"
			&SQL(Insert Into sqluser.DHC_EQCMaintType Values :PLIST())
		} 
		if (rowid'="")
		{
			Set PLIST(5) ="N"
			&SQL(Update sqluser.DHC_EQCMaintType Values :PLIST() where MT_RowID = :rowid)
	 	}
	}
	if SQLCODE Quit SQLCODE
	Set ID=$Get(%ROWID)
	Quit ID
}

/// w ##Class(web.DHCEQCMaintType).GetDocByID(3)
ClassMethod GetDocByID(rowid As %Library.String = "")
{
	new result,resultex
	Set (result,resultex)=""
	Set result=^DHCEQCCode("DHCEQCMaintType",rowid)
	Set resultex=rowid_"^"_result
	Set resultex=resultex_"^"	//5
	If $Piece(result,"^",5)'="" Set resultex=resultex_$CASE($Piece(result,"^",5),"1":"保养","2":"检查","3":"维修",:"没有定义")
	Set resultex=##class(web.DHCEQCommon).Replace(resultex,$C(13,10),"\n")
	
	Quit resultex
}

}
