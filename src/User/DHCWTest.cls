Class User.DHCWTest Extends (%Persistent, User.Abstract) [ SqlRowIdName = BED_RowId, SqlTableName = DHCW_Test ]
{

/// Fountion：床位信息表（默认存储）
/// CreateDate:2023-09-16
/// Creator:翁瑞珍
/// 姓名
Property PatName As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Pat_Name ];

/// 床位号
Property BEDNO As %String [ Required, SqlColumnNumber = 3, SqlFieldName = BED_NO ];

/// 病人床位信息
Property BEDDesc As %String [ Required, SqlColumnNumber = 4, SqlFieldName = BED_DESC ];

/// 床号索引
Index Code On BEDNO As Exact;

/// Fountion：排序输出
/// CreateDate:2023-09-16
/// Creator:翁瑞珍
/// Table:CPB_WengRuiZhen
/// Input:
/// Output:result
/// Others:d ##class(User.DHCWTest).WengRuiZhenCPB()
ClassMethod WengRuiZhenCPB() As %String
{
	S Code=0  
    if ($d(^User.DHCWTestI("Code",Code,0)))   ///索引存在
    {
	    for
	    {
	      s PAAMDRowid=$O(^User.DHCWTestI(0,"Code",Code,PAAMDRowid))
	      q:PAAMDRowid=""
	      s PatName=$p($g(^User.DHCWTestD(PAAMDRowid)),"^",1)
	      s BEDNO=$p($g(^User.DHCWTestD(PAAMDRowid)),"^",2)
	      s BEDDesc=$p($g(^User.DHCWTestD(PAAMDRowid)),"^",3)
		  w "病人姓名:"_PatName_",床号:"_BEDNO_",床号信息"_BEDDesc
		  w !
	    }
	}
	else
	{
		w result="数据不存在"
	}
}

Storage Default
{
<Data name="DHCWTestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PatName</Value>
</Value>
<Value name="3">
<Value>BEDNO</Value>
</Value>
<Value name="4">
<Value>BEDDesc</Value>
</Value>
</Data>
<DataLocation>^User.DHCWTestD</DataLocation>
<DefaultData>DHCWTestDefaultData</DefaultData>
<IdLocation>^User.DHCWTestD</IdLocation>
<IndexLocation>^User.DHCWTestI</IndexLocation>
<StreamLocation>^User.DHCWTestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
