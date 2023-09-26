/// Description:提供EXT公用方法
/// Creator:LiangQiang
Class web.DHCSTEXTCOMMON Extends %Library.RegisteredObject
{

/// 获取json第一列格式
ClassMethod GetJsonFirstCell(CellName, CellValue) As %String
{
    S CellValue=..GetValue(CellValue)
    Q CellName_":'"_CellValue_"',"
}

/// 获取json最后一列格式
ClassMethod GetJsonLastCell(CellName, CellValue) As %String
{
    S CellValue=..GetValue(CellValue)
    Q CellName_":'"_CellValue_"'"
}

/// 获取json第一行格式 
ClassMethod GetJsonFirstRow(RowValue) As %String
{
    Q "{"_RowValue_"},"
}

/// 获取json最后一行格式 
ClassMethod GetJsonLastRow(RowValue) As %String
{
    Q "{"_RowValue_"}"_"]}"
}

/// 获取json总记录数
ClassMethod GetJsonStartString(RowCount) As %String
{
    Q "{results:"_RowCount_",rows:["
}

/// 返回空记录数
ClassMethod GetNoJson() As %String
{
    Q "{results:0,rows:[]}"
}

/// 处理影响JSON格式的字符
/// w ##class(web.DHCSTEXTCOMMON).GetValue("")
ClassMethod GetValue(value) As %String
{
    s value=$tr(value,$c(3, 9, 10, 13))
    s value=$Replace(value,"\","\\")
    s value=$Replace(value,"'","\'")
    i $isvaliddouble(value, "", -1, 1) s value =$fn(value,"N")
    q value
}

}
