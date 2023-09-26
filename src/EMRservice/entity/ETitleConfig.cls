Class EMRservice.entity.ETitleConfig Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 类型为TempCate的parentId
Property CategoryID As %String(TRUNCATE = 1);

/// 字典代码
Property TitleCode As %String(TRUNCATE = 1);

/// 是否另起一页
Property PageBreak As %String(TRUNCATE = 1);

/// 是否另页书写
Property PageNextBreak As %String(TRUNCATE = 1);

/// 标题顺序
Property Sequence As %Integer;

/// 是否默认加载知识库 True为默认加载，False为默认不加载
Property AutoLoad As %String;

/// 标题在时间之前 True，False
Property TitleFrist As %String;

/// 分组ID
Property GroupID As %String;

/// 关联模板ID
Property TemplateID As %String;

/// 是否唯一创建 False为重复创建，true唯一创建
Property UniqueCreate As %String;

/// False选择加载，true为默认加载
Property DefaultLoad As %String;

Relationship ColumnConfig As EMRservice.entity.ETitleColConfig [ Cardinality = children, Inverse = TitleConfig ];

}
