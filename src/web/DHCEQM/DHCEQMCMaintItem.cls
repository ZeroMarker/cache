/// --------------------------------------------
/// Created By zc 2014-8-15  zc0001
/// Description:在设备维护菜单下新增维修类型子菜？实现对维修类型信息的管理?
/// --------------------------------------------
Class web.DHCEQM.DHCEQMCMaintItem Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetDataByID(rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQMCMaintItem",rowid)
	q result
}

ClassMethod MaintItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MaintItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod MaintItemExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", Type As %String = "", Remark As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)

 	s Desc=$ZCONVERT(Desc ,"U")		//转换为大写?
 	s Code=$ZCONVERT(Code ,"U")
	s Remark=$ZCONVERT(Remark ,"U")
 	s Type=$ZCONVERT(Type ,"U")	

	s index=1
	s rowid=0
	s TRow=1
	d BuildDataGetMaintItem
	Quit $$$OK
BuildDataGetMaintItem
	f  s rowid=$o(^DHCEQCCode("DHCEQMCMaintItem",rowid))  quit:rowid=""  d
	.d ResetVariablesGetMaintItem
	.s TRowID = rowid	//rowid
	.s TCode=$p($g(^DHCEQCCode("DHCEQMCMaintItem",rowid)),"^",1) //代码
	.s TDesc=$p($g(^DHCEQCCode("DHCEQMCMaintItem",rowid)),"^",2) //描述
	.s TRemark=$p($g(^DHCEQCCode("DHCEQMCMaintItem",rowid)),"^",3) //备注
	.s TInvalidFlag=$p($g(^DHCEQCCode("DHCEQMCMaintItem",rowid)),"^",4) //无符号标志
	.s TType=$p($g(^DHCEQCCode("DHCEQMCMaintItem",rowid)),"^",5) //替换内容
	.s TType=##Class(web.DHCEQM.DHCEQMCMaintItem).GetTypeDesc(TType)
	.q:TInvalidFlag="Y"
	.q:($ZCONVERT(TCode,"U")'[Code)&(Code'="")
	.q:($ZCONVERT(TDesc,"U")'[Desc)&(Desc'="")
	.q:($ZCONVERT(TRemark,"U")'[Remark)&(Remark'="")
	.q:($ZCONVERT(TType,"U")'[Type)&(Type'="")	
	.d OutputRowGetMaintItem
	quit
OutputRowGetMaintItem
 	set Data=$lb(TRowID,TCode,TDesc,TType,TInvalidFlag,TRemark,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1
	quit
ResetVariablesGetMaintItem
	s (TRowID,TCode,TDesc,TType,TInvalidFlag,TRemark)=""
	quit
}

ClassMethod MaintItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MaintItemExecute ]
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
 	else      
 	{
	 	Set Row=^CacheTemp(repid,ind)
 	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SaveData(val As %Library.String = "", isDel As %Library.String = "")
{
	k PLIST,rowid
 	s rowid=$p(val,"^",1)
 	i (+isDel=1)
 	{	// 删除
 		s PLIST(5)="Y"
 		&SQL(Update SQLUSER.DHC_EQMCMaintItem set MI_InvalidFlag=:PLIST(5) where MI_RowID = :rowid) 
 		if SQLCODE  q SQLCODE
 		q rowid
 	} 
 	else
 	{
	 	s PLIST(2) = $p(val,"^",2)	
	 	s Code= $p(val,"^",2)
	 	s PLIST(3) = $p(val,"^",3)
	 	s Desc= $p(val,"^",3)
	 	s PLIST(4) = $p(val,"^",4)
		//s Remark =$p(val,"^",4)
	 	s PLIST(5) = "N"
	 	//s InvalidFlag=$p(val,"^",6)
	 	s PLIST(6)=$p(val,"^",5)   /// Modify BY:ZC 2014-8-15  ZC0001
	 	//s Type=$p(val,"^",5)
	
	 	s tmpid=""
	  	&SQL(select MI_RowID into :tmpid from SQLUSER.DHC_EQMCMaintItem where MI_Code=:Code and MI_Desc=:Desc and MI_InvalidFlag='N')
	
		if (rowid="")
		{ //新增
			if (tmpid'="") //若已存在
			{
				s SQLCODE=-1001
			}
			else //若不存在 则插入数据
			{
				&SQL(Insert Into SQLUSER.DHC_EQMCMaintItem Values :PLIST())
			}
		}
		else
		{ //更新
			if (tmpid'="")
			{
				if (tmpid=rowid)
				{
					&SQL(update SQLUSER.DHC_EQMCMaintItem values:PLIST() where MI_RowID=:rowid)
				}
				else
				{
					s SQLCODE=-1001
				}
			}
			else
			{
				&SQL(update SQLUSER.DHC_EQMCMaintItem values:PLIST() where MI_RowID=:rowid)
			}
	}
 }
 if SQLCODE  q SQLCODE
 Set ID=$g(%ROWID)
 q ID
}

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,Code:%String,Type:%String,Remark:%String")
{
	SELECT MI_Desc,MI_Code,MI_Type,MI_Remark FROM sqluser.DHC_EQMCMaintItem
	where MI_InvalidFlag = 'N' and MI_Desc like nvl(:para,'')||'%'
}

/// do ##class(%ResultSet).RunQuery("web.DHCEQM.DHCEQMCMaintItem", "MaintItem", "")
/// modified by czf 406181 增加TRow并输出
Query MaintItem(Code As %String = "", Desc As %String = "", Type As %String = "", Remark As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TType:%String,TInvalidFlage:%String,TRemark:%String,TRow:%String")
{
}

ClassMethod GetTypeDesc(Type As %Library.String) As %Status
{
 	i Type=""  q ""
 	i +Type="1"  q "保养"
 	i +Type="2"  q "检查"
 	i +Type="3"  q "维修"
 	q "未定义"
}

ClassMethod SelectType(name, width) As %String
{
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")
	;;下拉列表
	//w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"	
	w "<option value=></option>"
	w "<option value=1>保养</option>"
	w "<option value=2>检查</option>"
	w "<option value=3>维修</option>"
	w "</select>",!
}

}
