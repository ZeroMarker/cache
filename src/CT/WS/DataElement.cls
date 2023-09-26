/// 名称：		CT.WS.DataElement
/// 描述：		自定义字典数据维护程序配置表
/// 编写者：	yejian
/// 编写时间：	2013-4-16
Class CT.WS.DataElement Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 据元目录ID索引
Index IdxCategoryID On CategoryID;

/// 数据元标示符索引
Index IdxEntifier On Entifier;

/// 数据元允许值索引
Index IdxDEVID On DEVID;

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 建立数据元目录ID
Property CategoryID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 修改日期
Property LastModifyDate As %Date;

/// 修改时间
Property LastModifyTime As %Time;

/// 数据元表示符
Property Entifier As %String(MAXLEN = 50, TRUNCATE = 1);

/// 数据元名称
Property Name As %String(MAXLEN = 100, TRUNCATE = 1);

/// 版本
Property Versions As %String(MAXLEN = 100, TRUNCATE = 1);

/// 注册机构
Property RegOrgan As %String(MAXLEN = 100, TRUNCATE = 1);

/// 相关环境
Property Environment As %String(MAXLEN = 100, TRUNCATE = 1);

/// 定义
Property Definition As %String(MAXLEN = 200, TRUNCATE = 1);

/// 分类模式
Property ClassModle As %String(MAXLEN = 100, TRUNCATE = 1);

/// 数据元值的数据类型
Property DataType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 表示格式
Property Format As %String(MAXLEN = 100, TRUNCATE = 1);

/// 数据元允许值
Property DEVID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 主管机构
Property ResOrgan As %String(MAXLEN = 100, TRUNCATE = 1);

/// 注册状态
Property State As %String(MAXLEN = 100, TRUNCATE = 1);

/// 提交机构
Property PutInOrgan As %String(MAXLEN = 100, TRUNCATE = 1);

/// Creator:	yejian
/// CreatDate:  2012-7-9
/// Desc:		根据数据元标示符查找数据元
/// Input：		aCategoryID：数据元标示符Id
/// Return：	EPRservice.dataset.EDataElementDataset: 术语集dataset
/// Debug:		d ##Class(%ResultSet).RunQuery("CT.WS.DataElement","GetSubByEntifier","DE02.01.001.01")
Query GetSubByEntifier(aEntifier As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,CategoryID:%String,Entifier:%String,Name:%String,Versions:%String,RegOrgan:%String,Environment:%String,Definition:%String,ClassModle:%String,DataType:%String,Format:%String,DEVID:%String,ResOrgan:%String,State:%String,PutInOrgan:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_DataElement_GetSubByEntifier, SqlProc ]
{
	select ID,CategoryID,Entifier,Name,Versions,
		   RegOrgan,Environment,Definition,ClassModle,DataType,Format,DEVID,ResOrgan,State,PutInOrgan
	from CT_WS.DataElement
	where Entifier = :aEntifier
	order by ID
}

/// Creator:	yejian
/// CreatDate:  2012-7-9
/// Desc:		数据元标示符是否唯一
/// Input：		aEntifier：数据元标示符
/// Return：	EPRservice.dataset.EDataElementDataset: 术语集dataset
ClassMethod SelectByEntifier(aEntifier As %String) As %String
{
	 set Result=""	 
	 &sql(SELECT ID
	 into :Result 
	 FROM CT_WS.DataElement
	 WHERE Entifier = :aEntifier)
	 QUIT Result
}

/// Creator:	yejian
/// CreatDate:  2012-7-9
/// Desc:		数据元标示符是否唯一
/// Input：		aEntifier：数据元标示符
/// Return：	EPRservice.dataset.EDataElementDataset: 术语集dataset
/// debug: 		w ##Class(CT.WS.DataElement).SelectDevIDByEntifier("DE02.01.001.01")
ClassMethod SelectDevIDByEntifier(aEntifier As %String) As %String
{
	 set Result=""	 
	 &sql(SELECT DEVID
	 into :Result 
	 FROM CT_WS.DataElement
	 WHERE Entifier = :aEntifier)
	 QUIT Result
}

/// Creator:	yejian
/// CreatDate:  2012-7-9
/// Desc:		查找所有目录数据
/// Input：		aCategoryID：数据元标示符Id
/// Return：	EPRservice.dataset.EDataElementDataset:
/// Debug:		w ##Class(CT.WS.DataElement).SelectCountbyCategoryID(2)
ClassMethod SelectCountbyCategoryID(aCategoryID As %String) As %String
{

	 set Result=""	 
	 &sql(SELECT count(*)
	 	into :Result 
	 	FROM CT_WS.DataElement
	 	WHERE CategoryID = :aCategoryID
	 	group by CategoryID)
	 QUIT Result
}

/// Creator:	yejian
/// CreatDate:  2012-7-9
/// Desc:		根据目录ID查找数据元
/// Input：		aCategoryID：术语范畴Id
/// Return：	EPRservice.dataset.EDataElementDataset: 术语集dataset
/// Debug:		d ##Class(%ResultSet).RunQuery("CT.WS.DataElement","SelectAllByCategoryID",127)
Query SelectAllByCategoryID(ACategoryID As %String) As %Query(ROWSPEC = "ID:%Integer,CategoryID:%String,Entifier:%String,Name:%String,Versions:%String,RegOrgan:%String,Environment:%String,Definition:%String,ClassModle:%String,DataType:%String,Format:%String,DEVID:%String,ResOrgan:%String,State:%String,PutInOrgan:%String")
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
		s rowID = $o(^DHCCTWS.DataElementI("IdxCategoryID"," "_ACategoryID,rowID))
		q:(rowID = "")	
		
		s objDataElemen = ##Class(CT.WS.DataElement).%OpenId(rowID)
		
		s CategoryID = objDataElemen.CategoryID
		s Entifier = objDataElemen.Entifier
		s Name = objDataElemen.Name
		s Versions = objDataElemen.Versions
		s RegOrgan = objDataElemen.RegOrgan
		s Environment = objDataElemen.Environment
		s Definition = objDataElemen.Definition
		s ClassModle = objDataElemen.ClassModle
		s DataType = objDataElemen.DataType
		s Format = objDataElemen.Format
		s DEVID = objDataElemen.DEVID
		s ResOrgan = objDataElemen.ResOrgan
		s State = objDataElemen.State
		s PutInOrgan = objDataElemen.PutInOrgan
		
		s Data = $lb(rowID,ACategoryID,Entifier,Name,Versions,
		  RegOrgan,Environment,Definition,ClassModle,DataType,Format,DEVID,ResOrgan,State,PutInOrgan)
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

Storage Default
{
<Data name="DataElementDefaultData">
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
<Value>CategoryID</Value>
</Value>
<Value name="5">
<Value>LastModifyDate</Value>
</Value>
<Value name="6">
<Value>LastModifyTime</Value>
</Value>
<Value name="7">
<Value>Entifier</Value>
</Value>
<Value name="8">
<Value>Name</Value>
</Value>
<Value name="9">
<Value>Versions</Value>
</Value>
<Value name="10">
<Value>RegOrgan</Value>
</Value>
<Value name="11">
<Value>Environment</Value>
</Value>
<Value name="12">
<Value>Definition</Value>
</Value>
<Value name="13">
<Value>ClassModle</Value>
</Value>
<Value name="14">
<Value>DataType</Value>
</Value>
<Value name="15">
<Value>Format</Value>
</Value>
<Value name="16">
<Value>DEVID</Value>
</Value>
<Value name="17">
<Value>ResOrgan</Value>
</Value>
<Value name="18">
<Value>State</Value>
</Value>
<Value name="19">
<Value>PutInOrgan</Value>
</Value>
</Data>
<DataLocation>^DHCCTWS.DataElementD</DataLocation>
<DefaultData>DataElementDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCTWS.DataElementD</IdLocation>
<IndexLocation>^DHCCTWS.DataElementI</IndexLocation>
<StreamLocation>^DHCCTWS.DataElementS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
