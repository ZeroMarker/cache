/// 名称:	EMR.GB.AuthRequestData
/// 描述:	申请授权数据
/// 编写者：yejian
/// 编写日期: 2023-5-16
/// 产品组：电子病历产品组
Class EMR.GB.AuthRequestData Extends %Persistent
{

Index IdxReqData On (AuthRequest, RequestData);

Index IdxReqType On (AuthRequest, RequestType);

/// 授权申请表
Property AuthRequest As EMR.GB.AuthRequest;

/// 申请类型(TEMPLATE 模板/DOCUMENT 病历/VIEW 浏览)
Property RequestType As CT.EMR.DOC.AuthDataType;

/// 操作类型
/// ["save","print","delete","view","create"] 修改-save 打印-print 删除-delete 浏览-view 创建-creat
Property RequestAction As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 申请的ID(病历ID/模板ID/业务活动分类ID)
Property RequestData As %String;

Storage Default
{
<Data name="AuthRequestDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AuthRequest</Value>
</Value>
<Value name="3">
<Value>RequestType</Value>
</Value>
<Value name="4">
<Value>RequestAction</Value>
</Value>
<Value name="5">
<Value>RequestData</Value>
</Value>
</Data>
<DataLocation>^EMR.GB.AuthRequestDataD</DataLocation>
<DefaultData>AuthRequestDataDefaultData</DefaultData>
<IdLocation>^EMR.GB.AuthRequestDataD</IdLocation>
<IndexLocation>^EMR.GB.AuthRequestDataI</IndexLocation>
<StreamLocation>^EMR.GB.AuthRequestDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
