Class CT.WS.DataElementValues Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// DECVMID,DEVID联合索引
Index IdxDevsID On (DECVMID, DEVID);

/// 数据值域标示符索引
Index IdxDEVID On DEVID;

/// 标示符关联ID索引
Index IdxDECVMID On DECVMID;

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 最终修改日期
Property LastModifyDate As %Date;

/// 最终修改时间
Property LastModifyTime As %Time;

/// 数据值域标示符
Property DEVID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 值含义
Property Meaning As %String(MAXLEN = 500, TRUNCATE = 1);

/// 说明
Property Description As %String(MAXLEN = 100, TRUNCATE = 1);

/// 标示符关联ID
Property DECVMID As %String(MAXLEN = 50, TRUNCATE = 1);

/*
/// Creator:	yejian
/// CreatDate:  2012-7-9
/// Desc:		根据值域标示符查找值域代码
/// Input：		aCategoryID：数据元标示符Id
/// Return：	EPRservice.dataset.EDataElementValuesDataset
/// Debug:		d ##Class(%ResultSet).RunQuery("CT.WS.DataElementValues","GetDatasByDECVMID",19)
Query GetDatasByDECVMID(aDECVMID As %String) As %SQLQuery(CONTAINID = 1,ROWSPEC = "ID:%Integer,DECVMID:%String,Description:%String,DEVID:%String,Meaning:%String,Name:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_DataElementValues_GetDatasByDECVMID, SqlProc ]
{
	SELECT ID,DECVMID,Description,DEVID,Meaning,Name 
	FROM CT.WS.DataElementValues 
	where DECVMID = :aDECVMID
	order by ID
}
*/
/// 判断是否存在
/// w ##Class(CT.WS.DataElementValues).SelectByDECVMID("01","CV02.01.101")
ClassMethod SelectByDECVMID(aDEVID As %String, aDECVMID As %String) As %String
{
	 set Result=""	 
	 &sql(SELECT ID
	 into :Result 
	 FROM CT_WS.DataElementValues
	 WHERE DEVID = :aDEVID AND DECVMID = :aDECVMID)
	 QUIT Result
}

/// Creator:	yejian
/// CreatDate:  2012-7-9
/// Desc:		根据值域标示符查找值域代码
/// Input：		aCategoryID：数据元标示符Id
/// Return：	EPRservice.dataset.EDataElementValuesDataset
/// Debug:		d ##Class(%ResultSet).RunQuery("CT.WS.DataElementValues","SelectAllByDECVMID","CV02.01.101")
Query SelectAllByDECVMID(aDECVMID As %String) As %Query(ROWSPEC = "ID:%Integer,DECVMID:%String,Description:%String,DEVID:%String,Meaning:%String")
{
}

ClassMethod SelectAllByDECVMIDExecute(ByRef qHandle As %Binary, aDECVMID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:($g(aDECVMID) = "") $$$OK
	
	s rowID = ""
	
	for {
		s rowID = $o(^DHCCTWS.DataElementValuesI("IdxDECVMID"," "_aDECVMID,rowID))
		q:(rowID = "")	
		
		s objDataElemen = ##Class(CT.WS.DataElementValues).%OpenId(rowID)
		
		s DECVMID = objDataElemen.DECVMID
		s Description = objDataElemen.Description
		s DEVID = objDataElemen.DEVID
		s Meaning = objDataElemen.Meaning
		
		s Data = $lb(rowID,DECVMID,Description,DEVID,Meaning)
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
<Data name="DataElementValuesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CreateDate</Value>
</Value>
<Value name="3">
<Value>CreateTime</Value>
</Value>
<Value name="4">
<Value>LastModifyDate</Value>
</Value>
<Value name="5">
<Value>LastModifyTime</Value>
</Value>
<Value name="6">
<Value>DEVID</Value>
</Value>
<Value name="7">
<Value>Meaning</Value>
</Value>
<Value name="8">
<Value>Description</Value>
</Value>
<Value name="9">
<Value>DECVMID</Value>
</Value>
</Data>
<DataLocation>^DHCCTWS.DataElementValuesD</DataLocation>
<DefaultData>DataElementValuesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCTWS.DataElementValuesD</IdLocation>
<IndexLocation>^DHCCTWS.DataElementValuesI</IndexLocation>
<StreamLocation>^DHCCTWS.DataElementValuesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
