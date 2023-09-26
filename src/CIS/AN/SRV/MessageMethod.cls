Class CIS.AN.SRV.MessageMethod Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = MessageMethod ]
{

/// 消息方法代码，一个业务要调用多个类方法，请添加多条代码相同的记录。
Property Code As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 2 ];

/// 类名
Property ClassName As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 3 ];

/// 方法名
Property MethodName As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 4 ];

/// 激活状态，未激活的方法不会发送
Property Active As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ Required, SqlColumnNumber = 5 ];

/// 产品代码
Property Product As %String(DISPLAYLIST = ",手麻,重症,血透", VALUELIST = ",AN,ICU,BP") [ Required, SqlColumnNumber = 6 ];

/// 第三方系统名称(比如：麦迪斯顿手麻系统)
Property Target As %String(MAXLEN = 200) [ SqlColumnNumber = 7 ];

/// 产品模块名称，方便查询日志时查看
Property ProdModule As %String(MAXLEN = 200) [ SqlColumnNumber = 8 ];

/// 消息方法描述
Property Description As %String [ SqlColumnNumber = 9 ];

Index ICode On Code;

ClassMethod GetByCode(methodCode As %String) As %ListOfObjects
{
  &sql(declare methodCodeCursor cursor for select RowId into :RowId
      from CIS_AN_SRV.MessageMethod
      where Code=:methodCode and Active='Y')
  &sql(open methodCodeCursor)
  set methodList=##class(%ListOfObjects).%New()
  for
  {
    &sql(fetch methodCodeCursor)
    quit:(SQLCODE'=0)
    set messageMethod=##class(CIS.AN.SRV.MessageMethod).%OpenId(RowId)

    do:(messageMethod'="") methodList.Insert(messageMethod) 
  }
  &sql(close methodCodeCursor)
  quit methodList
}

Storage Default
{
<Data name="MessageMethodDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>ClassName</Value>
</Value>
<Value name="3">
<Value>MethodName</Value>
</Value>
<Value name="4">
<Value>Active</Value>
</Value>
<Value name="5">
<Value>Product</Value>
</Value>
<Value name="6">
<Value>Target</Value>
</Value>
<Value name="7">
<Value>ProdModule</Value>
</Value>
<Value name="8">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.SRV.MessageMethodD</DataLocation>
<DefaultData>MessageMethodDefaultData</DefaultData>
<IdLocation>^CIS.AN.SRV.MessageMethodD</IdLocation>
<IndexLocation>^CIS.AN.SRV.MessageMethodI</IndexLocation>
<StreamLocation>^CIS.AN.SRV.MessageMethodS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
