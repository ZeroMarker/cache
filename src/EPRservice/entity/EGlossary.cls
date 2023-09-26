Class EPRservice.entity.EGlossary Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// ID
Property ID As %String(TRUNCATE = 1);

/// 术语名称
Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 术语描述
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 全局唯一标识符
Property GUID As %String(MAXLEN = 36, TRUNCATE = 1);

/// 术语范畴父类ID
Property GlossaryCategoryID As %String(TRUNCATE = 1);

/// 关联的模板项目,其信息格式如下：
/// Simple型：TNAME.UNAME#TYPE:#TID:#TVER:#SCODE:#VTYPE
/// Segment型：TNAME.UNAME#TYPE:#TID:#TVER:#GCODE:#VTYPE
/// TextDesc型：TNAME.UNAME#TYPE:#TID:#TVER:#ECODE:#VTYPE
/// SegmentSimple型：TNAME.UNAME#TYPE:#TID:#TVER:#GCODE:#SCODE:#VTYPE
/// TextDescSimple型：TNAME.UNAME#TYPE:#TID:#TVER:#TCODE:#SCODE:#KBNode:#KBPartNo##VTYPE
/// Property SubItems As %String [ Collection = list ];
Property MetaItemData As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEPRGlossaryStream($J)");

/// 引用术语的项目
Property BindItemData As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEPRGlossaryStream($J)");

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 最后修改日期
Property LastModifyDate As %Date;

/// 最后修改时间
Property LastModifyTime As %Time;

/// 术语类型
Property GlossaryType As %String(TRUNCATE = 1);

/// 父节点RowID
Property ParentID As %String(TRUNCATE = 1);

/// 子术语个数
Property ChildCount As %Integer;

Property InternalID As %String(TRUNCATE = 1);

Property MetaID As %String(TRUNCATE = 1);

/// Added on 2008-06-04, by houjian@dhcc.com.cn
/// Purpose: 删除与其自身实例对象相关的临时Global
Method %OnClose() As %Status [ Private ]
{
	s id = ..MetaItemData.GetStreamId()
	if $find(id,"^CacheTempDHCEPRGlossaryStream($J)")
	{
		do ..MetaItemData.Clear()
	}
	
	s id = ..BindItemData.GetStreamId()
	if $find(id,"^CacheTempDHCEPRGlossaryStream($J)")
	{
  		do ..BindItemData.Clear()
	}
	
  	quit "1"
}

}
