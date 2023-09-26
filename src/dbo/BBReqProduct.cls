/// 申请血液产品
Class dbo.BBReqProduct Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_ReqProduct, StorageStrategy = Default ]
{

/// Foreign Key FKBBRPBloodComponents created via DDL
ForeignKey FKBBRPBloodComponents(BloodComponentsDR) References dbo.BBBloodComponents(PKBBBLOODCOMPONENTS) [ SqlName = FK_BB_RP_BloodComponents ];

/// Foreign Key FKBBRPHospital created via DDL
ForeignKey FKBBRPHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BB_RP_Hospital ];

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSeqNum On (HospitalDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBREQPRODUCT On RowID [ PrimaryKey, SqlName = PK_BB_REQPRODUCT, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// 编码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 产品特点  
Property Feature As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 6 ];

/// 申请提示  
Property ReqPrompt As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 7 ];

/// 血成分  
Property BloodComponentsDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 换算系数  
Property ScaleFactor As %Library.Float [ SqlColumnNumber = 9 ];

/// 参加计算总量  {1:true,0:false}
Property IsAccumulate As %Library.Boolean [ SqlColumnNumber = 10 ];

/// 序号  
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 12 ];

/// 单位  
Property Unit As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 13 ];

/// IsTreatment  {1:true,0:false}
Property IsTreatment As %Library.Boolean [ SqlColumnNumber = 14 ];

/// 是否自体血  {1:true,0:false}
Property IsAutologous As %Library.Boolean [ SqlColumnNumber = 15 ];

/// 最大取血量
Property MaxVolumn As %Library.Float [ SqlColumnNumber = 16 ];

/// 是否计费
Property IsFee As %Library.Boolean [ SqlColumnNumber = 17 ];

Storage Default
{
<Data name="BBReqProductDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>HospitalDR</Value>
</Value>
<Value name="5">
<Value>Feature</Value>
</Value>
<Value name="6">
<Value>ReqPrompt</Value>
</Value>
<Value name="7">
<Value>BloodComponentsDR</Value>
</Value>
<Value name="8">
<Value>ScaleFactor</Value>
</Value>
<Value name="9">
<Value>IsAccumulate</Value>
</Value>
<Value name="10">
<Value>SeqNum</Value>
</Value>
<Value name="11">
<Value>Active</Value>
</Value>
<Value name="12">
<Value>Unit</Value>
</Value>
<Value name="13">
<Value>IsTreatment</Value>
</Value>
<Value name="14">
<Value>IsAutologous</Value>
</Value>
<Value name="15">
<Value>MaxVolumn</Value>
</Value>
<Value name="16">
<Value>IsFee</Value>
</Value>
</Data>
<DataLocation>^dbo.BBReqProductD</DataLocation>
<DefaultData>BBReqProductDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBReqProductD</IdLocation>
<IndexLocation>^dbo.BBReqProductI</IndexLocation>
<StreamLocation>^dbo.BBReqProductS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
