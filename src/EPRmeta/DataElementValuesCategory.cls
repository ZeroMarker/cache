Class EPRmeta.DataElementValuesCategory Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 标示符关联ID索引
Index IdxDECVMID On DECVMID;

/// 关联目录ID索引
Index IdxCategoryID On CategoryID;

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 最终修改日期
Property LastModifyDate As %Date;

/// 最终修改时间
Property LastModifyTime As %Time;

/// 建立数据元目录ID
Property CategoryID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 数据值域标示符
Property DECVMID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 名称
Property Name As %String(MAXLEN = 100, TRUNCATE = 1);

/// 值含义
Property PerName As %String(MAXLEN = 500, TRUNCATE = 1);

/// 说明
Property Description As %String(MAXLEN = 100, TRUNCATE = 1);

/*
/// Creator:	yejian
/// CreatDate:  2012-7-9
/// Desc:		根据值域标示符查找值域代码
/// Input：		aCategoryID：数据元标示符Id
/// Return：	EPRservice.dataset.EDataElementValuesDataset
/// Debug:		d ##Class(%ResultSet).RunQuery("EPRmeta.DataElementValues","GetDatasByDECVMID",19)
Query GetDatasByDECVMID(aDECVMID As %String) As %SQLQuery(CONTAINID = 1,ROWSPEC = "ID:%Integer,DECVMID:%String,Description:%String,DEVID:%String,Meaning:%String,Name:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_DataElementValues_GetDatasByDECVMID, SqlProc ]
{
	SELECT ID,DECVMID,Description,DEVID,Meaning,Name 
	FROM EPRmeta.DataElementValues 
	where DECVMID = :aDECVMID
	order by ID
}
*/
ClassMethod SelectByDECVMID(aDECVMID As %String) As %String
{
	 set Result=""	 
	 &sql(SELECT ID
	 into :Result 
	 FROM EPRmeta.DataElementValuesCategory
	 WHERE DECVMID = :aDECVMID)
	 QUIT Result
}

/// Creator:	yejian
/// CreatDate:  2012-7-9
/// Desc:		根据目录ID查找数据元
/// Input：		aCategoryID：术语范畴Id
/// Return：	EPRservice.dataset.EDataElementDataset: 术语集dataset
/// Debug:		d ##Class(%ResultSet).RunQuery("EPRmeta.DataElementValuesCategory","SelectAllByCategoryID","1")
Query SelectAllByCategoryID(ACategoryID As %String) As %Query(ROWSPEC = "ID:%Integer,DECVMID:%String,Description:%String,PerName:%String,Name:%String")
{
}

ClassMethod SelectAllByCategoryIDExecute(ByRef qHandle As %Binary, ACategoryID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:($g(ACategoryID) = "") $$$OK
	
	s rowID = ""
	
	for {
		s rowID = $o(^DHCEPRM.DEValuesCategoryI("IdxCategoryID"," "_ACategoryID,rowID))
		q:(rowID = "")	
		
		s objDEVCategory = ##Class(EPRmeta.DataElementValuesCategory).%OpenId(rowID)
		
		s DECVMID = objDEVCategory.DECVMID
		s Description = objDEVCategory.Description
		s PerName = objDEVCategory.PerName
		s Name = objDEVCategory.Name
		
		s Data = $lb(rowID,DECVMID,Description,PerName,Name)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1
	}
	q $$$OK
}

ClassMethod SelectAllByCategoryIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectAllByCategoryIDExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod SelectAllByCategoryIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectAllByCategoryIDExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Creator:	yejian
/// CreatDate:  2012-7-9
/// Desc:		根据值域标示符查找值域代码
/// Input：		aCategoryID：数据元标示符Id
/// Return：	EPRservice.dataset.EDataElementValuesDataset
/// Debug:		d ##Class(%ResultSet).RunQuery("EPRmeta.DataElementValuesCategory","SelectAllByDECVMID","CV02.01.101")
Query SelectAllByDECVMID(ADECVMID As %String) As %Query(ROWSPEC = "ID:%Integer,DECVMID:%String,Description:%String,PerName:%String,Name:%String")
{
}

ClassMethod SelectAllByDECVMIDExecute(ByRef qHandle As %Binary, ADECVMID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:($g(ADECVMID) = "") $$$OK
	
	s rowID = ""
	
	for {
		s rowID = $o(^DHCEPRM.DEValuesCategoryI("IdxDECVMID"," "_ADECVMID,rowID))
		q:(rowID = "")	
		
		s objDEVCategory = ##Class(EPRmeta.DataElementValuesCategory).%OpenId(rowID)
		
		s DECVMID = objDEVCategory.DECVMID
		s Description = objDEVCategory.Description
		s PerName = objDEVCategory.PerName
		s Name = objDEVCategory.Name
		
		s Data = $lb(rowID,DECVMID,Description,PerName,Name)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1
	}
	q $$$OK
}

ClassMethod SelectAllByDECVMIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectAllByDECVMIDExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod SelectAllByDECVMIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectAllByDECVMIDExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

Storage Default
{
<Data name="DataElementValuesCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CategoryID</Value>
</Value>
<Value name="3">
<Value>CreateDate</Value>
</Value>
<Value name="4">
<Value>CreateTime</Value>
</Value>
<Value name="5">
<Value>DECVMID</Value>
</Value>
<Value name="6">
<Value>Description</Value>
</Value>
<Value name="7">
<Value>LastModifyDate</Value>
</Value>
<Value name="8">
<Value>LastModifyTime</Value>
</Value>
<Value name="9">
<Value>Name</Value>
</Value>
<Value name="10">
<Value>PerName</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.DEValuesCategoryD</DataLocation>
<DefaultData>DataElementValuesCategoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.DEValuesCategoryD</IdLocation>
<IndexLocation>^DHCEPRM.DEValuesCategoryI</IndexLocation>
<StreamLocation>^DHCEPRM.DEValuesCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
