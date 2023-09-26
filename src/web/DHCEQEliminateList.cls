Class web.DHCEQEliminateList Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 增加、修改数据
ClassMethod SaveList(ListInfo)
{
	n Plist,RowID
	k Plist
	s RowID=$P(ListInfo,"^",1)
	s Plist(1)=$P(ListInfo,"^",1) ;rowid
	s Plist(2)=$P(ListInfo,"^",2) ;SourceType/业务类型(暂定为1)
	s Plist(3)=$P(ListInfo,"^",3) ;SourceID/业务ID(指向BuyRequest)
	s Plist(4)=$P(ListInfo,"^",4) ;EquipID
	s Plist(5)=$P(ListInfo,"^",5) ;PreWorkLoad
	s Plist(6)=$P(ListInfo,"^",6) ;PositiveRate	
	s Plist(7)=$P(ListInfo,"^",7) ;Hold1
	s Plist(8)=$P(ListInfo,"^",8) ;Hold2
	s Plist(9)=$P(ListInfo,"^",9) ;Hold3
	s Plist(10)=$P(ListInfo,"^",10) ;Hold4
	s Plist(11)=$P(ListInfo,"^",11) ;Hold5
#;	if RowID=""
#;	{
#;		&SQL(insert into sqluser.DHC_EQEliminateList values :Plist())
#;		q SQLCODE
#;	}
#;	else
#;	{
#;		&SQL(update sqluser.DHC_EQEliminateList values :Plist() where EL_RowID=:RowID)
#;		q SQLCODE
#;	}
}

/// w ##Class(web.DHCEQMaintUserList).SaveData("1^1^1^1^6^^^^^&2^1^1^2^7^^^^^&3^1^1^6^8^^^^^")
ClassMethod SaveData(val, ElementID, TemplateID)
{
    Set $ZT="ERROR" //2009-08-10 μ3?ü
	TSTART //2009-08-10 μ3?ü
	s SQLCODE=0
    s length=$l(val,"&")
	f i=1:1:length  d
	.q:SQLCODE'=0
	.s ListInfo=$p(val,"&",i)
	.s SQLCODE=##Class(web.DHCEQEliminateList).SaveList(ListInfo)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	if (ElementID'="")&&(TemplateID'="")
	{
		s tmp=""
		&SQL(select TL_RowID into :tmp from sqluser.DHC_EQTemplateList where TL_TemplateDR=:TemplateID and TL_ElementDR=:ElementID)
		i tmp'="" 
		{
			&SQL(update sqluser.DHC_EQTemplateList set TL_Result=:length where TL_RowID=:tmp)
			
			i SQLCODE
			{
				TROLLBACK
				q SQLCODE
			}
		}
	}
	TCOMMIT
    q SQLCODE
    
ERROR 
	Set ErrorMsg=$ZE	          
	TROLLBACK		      
	Quit "<ERROR>"_ErrorMsg
}

/// 根据rowid号删除数据
ClassMethod DeleteData(RowID)
{
#;	if RowID'=""
#;	{
#;		&SQL(delete FROM sqluser.DHC_EQEliminateList where EL_RowID=:RowID)
#;		q SQLCODE
#;	}
	q "删除失败"
}

/// 根据索引IndexBIBuyRequestDR查找数据
/// d ##Class(%ResultSet).RunQuery("web.DHCEQEliminateList","GetEliminateList","1","5")
Query GetEliminateList(SourceType As %String = "", SourceID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TSourceType:%String,TSourceID:%String,TEquipID:%String,TEquipName:%String,TEquipNo:%String,TTransAssetDate:%String,TPreWorkLoad:%String,TPositiveRate:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String")
{
}

ClassMethod GetEliminateListExecute(ByRef qHandle As %Binary, SourceType As %String = "", SourceID As %String = "") As %Status
{
	new repid,index,rowid
	set repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	i SourceType=""||SourceID="" Quit $$$OK
	i '$Data(^DHCEQEliminateList(0,"Source",SourceType,SourceID)) Quit $$$OK
	s index=1	
	s rowid=0
	f  s rowid=$o(^DHCEQEliminateList(0,"Source",SourceType,SourceID,rowid)) q:rowid=""  d
	.s DataList=$g(^DHCEQEliminateList(rowid))
	.s TRowID=rowid
	.s TSourceType=$P(DataList,"^",1)
	.s TSourceID=$P(DataList,"^",2)
	.s TEquipID=$P(DataList,"^",3)
	.q:TEquipID=""
	.s TEquipName=$P($Get(^DHCEQEquip(TEquipID)),"^",1)
	.s TEquipNo=$P($Get(^DHCEQEquip(TEquipID)),"^",71)
	.s TTransAssetDate=$P($Get(^DHCEQEquip(TEquipID)),"^",45)
	.s TTransAssetDate=##class(web.DHCEQCommon).TransValueToPage(TTransAssetDate,"date")
	.s TPreWorkLoad=$P(DataList,"^",4)
	.s TPositiveRate=$P(DataList,"^",5)
	.s THold1=$P(DataList,"^",6)
	.s THold2=$P(DataList,"^",7)
	.s THold3=$P(DataList,"^",8)
	.s THold4=$P(DataList,"^",9)
	.s THold5=$P(DataList,"^",10)
	.d OutputRowGetEliminateList
	Quit $$$OK
OutputRowGetEliminateList
	s Data=$lb(TRowID,TSourceType,TSourceID,TEquipID,TEquipName,TEquipNo,TTransAssetDate,TPreWorkLoad,TPositiveRate,THold1,THold2,THold3,THold4,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetEliminateListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEliminateListExecute ]
{
	s AtEnd=$LIST(qHandle,1)
	s repid=$LIST(qHandle,2)
	s ind=$LIST(qHandle,3)
	s ind=$o(^CacheTemp(repid,ind))
	if ind=""
	{
		s AtEnd=1
		s Row=""
	}
	else
	{
		set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetEliminateListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEliminateListExecute ]
{
	s repid=$LIST(qHandle,2)
	k ^CacheTemp(repid)
	Quit $$$OK
}

}
