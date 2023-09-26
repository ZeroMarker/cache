/// 名称:		EMR.DOC.DTO.BDMSimpleElements
/// 描述:		文档管理--业务数据模型简单元素传输对象
/// 编写者：	yejian
/// 编写日期: 	2020-10-12
/// 产品组：	电子病历产品组
Class EMR.DOC.DTO.BDMSimpleElements Extends %RegisteredObject
{

/// rowID
Property ID As %String;

/// 项目标识
Property Product As %String;

/// 目录(CF.EMR.DOC.TemplateStructure表StructType类型为Section)
Property BDMCategory As %String;

/// 元素类型(MIString/MINumber/MIDateTime/MIList/MIRadioGroup/MICheckbox)
Property Type As %String;

/// 元素编码
Property Code As %String(MAXLEN = 100, TRUNCATE = 1);

/// 元素名称
Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 排序
Property Sequence As %Integer;

/// 关联术语集CF.EMR.DOC.GlossaryItem表的ID集合,以^分隔
Property GlossaryItemIDS As %String(MAXLEN = 200, TRUNCATE = 1);

/// 属性项
/// MIString:{"Code":"","Type":"","Name":"","PlaceHolder":"","Text":"","Value":"","ToolTip":"","DataBindings":"","Display":"","ReadOnly":"","AllowNull":"","FixedStructs":"","MaxLength":"","TableIndex":"","PasswordChar":"","BackgroundColor":"","Cursors":"","FontFamily":"","Color":"","FontSize":"","Bold":"","Italic":"","TextAlign":"","VerticalAlign":"","TextDecorationLine":"","ValidateMsg":"","Pattern":""}
/// MINumber:{"Code":"","Type":"","Name":"","PlaceHolder":"","Text":"","Value":"","ToolTip":"","DataBindings":"","DecimalPlaces":"","Increment":"","Maximum":"","Minmum":"","Display":"","ReadOnly":"","AllowNull":"","FixedStructs":"","MaxLength":"","TableIndex":"","PasswordChar":"","BackgroundColor":"","Cursors":"","FontFamily":"","Color":"","FontSize":"","Bold":"","Italic":"","TextAlign":"","VerticalAlign":"","TextDecorationLine":"","ValidateMsg":"","Pattern":""}
/// MIDateTime:{"Code":"","Type":"","Name":"","PlaceHolder":"","Text":"","Value":"","ToolTip":"","DataBindings":"","Format":"","MaxDate":"","MinDate":"","Display":"","ReadOnly":"","AllowNull":"","FixedStructs":"","MaxLength":"","TableIndex":"","PasswordChar":"","BackgroundColor":"","Cursors":"","FontFamily":"","Color":"","FontSize":"","Bold":"","Italic":"","TextAlign":"","VerticalAlign":"","TextDecorationLine":"","ValidateMsg":"","Pattern":""}
/// MIList:{"Code":"","Type":"","Name":"","PlaceHolder":"","Text":"","Value":"","ToolTip":"","DataBindings":"","Format":"","MaxDate":"","MinDate":"","Display":"","ReadOnly":"","AllowNull":"","FixedStructs":"","MaxLength":"","TableIndex":"","PasswordChar":"","BackgroundColor":"","Cursors":"","FontFamily":"","Color":"","FontSize":"","Bold":"","Italic":"","TextAlign":"","VerticalAlign":"","TextDecorationLine":"","ValidateMsg":"","Pattern":""}
/// MIRadioGroup:{"Code":"","Type":"","Name":"","PlaceHolder":"","Text":"","Value":"","ToolTip":"","DataBindings":"","Choices":"","Display":"","ReadOnly":"","AllowNull":"","FixedStructs":"","MaxLength":"","TableIndex":"","PasswordChar":"","CheckAlign":"","Checked":"","BackgroundColor":"","Cursors":"","FontFamily":"","Color":"","FontSize":"","Bold":"","Italic":"","TextAlign":"","VerticalAlign":"","TextDecorationLine":"","ValidateMsg":"","Pattern":""}
/// MICheckbox:{"Code":"","Type":"","Name":"","PlaceHolder":"","Text":"","Value":"","ToolTip":"","DataBindings":"","Separator":"","display":"","Choices":"","Display":"","ReadOnly":"","AllowNull":"","FixedStructs":"","MaxLength":"","TableIndex":"","PasswordChar":"","CheckAlign":"","Checked":"","BackgroundColor":"","Cursors":"","FontFamily":"","Color":"","FontSize":"","Bold":"","Italic":"","TextAlign":"","VerticalAlign":"","TextDecorationLine":"","ValidateMsg":"","Pattern":""}
Property DataAttributes As %String(MAXLEN = 30000, TRUNCATE = 1);

}
