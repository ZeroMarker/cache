/// 名称: DHCMed.SS.PAPMILog
/// 描述: 记录合并登记号时的修改日志
/// 编写者：wuqk
/// 编写日期: 2011-07-21
Class DHCMed.SS.PAPMILog Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 所属产品
Property ProductDr As Products;

/// 持久类名称
Property ClassName As %String [ Required ];

/// 被修改记录的Id
Property RecordId As %String [ Required ];

/// 原PatientID
Property OldPatientID As %String [ Required ];

/// 新PatientID
Property NewPatientID As %String [ Required ];

/// 修改日期
Property UpdateDate As %Date;

/// 修改时间
Property UpdateTime As %Time;

/// 索引：产品-类-记录
Index PCR On (ProductDr, ClassName As AlphaUp, RecordId As AlphaUp);

/// 索引：原PatientID-类
Index OPC On (OldPatientID As AlphaUp, ClassName As AlphaUp);

/// 
/// Creator：     wuqk
/// CreatDate：   2011-07-27
/// Description:  插入日志信息
/// Table：       DHCMed.SS.PAPMILog
/// Input：       
/// Return：      1:成功；其它:错误信息
ClassMethod InsertLog(ProductCode As %String, ClassName As %String, RecordId As %String, OldPatientID As %String, NewPatientID As %String) As %String
{
	new (ProductCode,ClassName,RecordId,OldPatientID,NewPatientID)
	set flag=1,objProduct=""
	set obj=##class(DHCMed.SS.PAPMILog).%New()
	set ProductCode=$ZCVT(ProductCode,"U")
	if ProductCode'="" {
		if $d(^DHCMed.SS.ProductsI("ProCodeIndex"," "_ProductCode)){
			set ProductID=$o(^DHCMed.SS.ProductsI("ProCodeIndex"," "_ProductCode,0))
			set objProduct=##class(DHCMed.SS.Products).%OpenId(ProductID)
		}
	}
	set:$IsObject(objProduct) obj.ProductDr=objProduct
	set obj.ClassName=ClassName
	set obj.RecordId=RecordId
	set obj.OldPatientID=OldPatientID
	set obj.NewPatientID=NewPatientID
	set obj.UpdateDate=+$h
	set obj.UpdateTime=$p($h,",",2)
	set sc=obj.%Save()
	if $system.Status.IsError(sc){
		set flag=$system.Status.GetErrorText(sc)
	}
	else{}
	quit flag
}

Storage Default
{
<Data name="PAPMILogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ProductDr</Value>
</Value>
<Value name="3">
<Value>ClassName</Value>
</Value>
<Value name="4">
<Value>RecordId</Value>
</Value>
<Value name="5">
<Value>OldPatientID</Value>
</Value>
<Value name="6">
<Value>NewPatientID</Value>
</Value>
<Value name="7">
<Value>UpdateDate</Value>
</Value>
<Value name="8">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCMed.SS.PAPMILogD</DataLocation>
<DefaultData>PAPMILogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.SS.PAPMILogD</IdLocation>
<IndexLocation>^DHCMed.SS.PAPMILogI</IndexLocation>
<StreamLocation>^DHCMed.SS.PAPMILogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
