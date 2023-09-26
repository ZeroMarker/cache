Class EMR.DOC.DTO.Titles Extends %RegisteredObject
{

/// 是否另立单页
Property PageBreak As %String(TRUNCATE = 1);

/// 是否另页书写
Property PageBreakOdd As %String(TRUNCATE = 1);

/// 是否创建唯一实例 False为重复创建，true唯一创建
Property UniqueCreate As %String;

/// 标题日期分行显示 0为否 1为是
Property LineBreak As %String;

/// 关联事件
Property EventCode As %String;

/// 标题位置
Property TitleAlign As %String;

/// 日期位置
Property DateAlign As %String;

/// 标题字体信息
Property TitleFontStyle As %String;

/// 日期字体信息
Property DateFontStyle As %String;

/// 是否包含上级医生级别
Property IncludeDoctorLevel As %String;

/// 是否包含上级医生姓名
Property IncludeDoctorName As %String;

/// 日期格式
Property DateFormat As %String;

/// 医生级别
Property DoctorLevel As %String;

/// 日期只读
Property DateReadonly As %String;

/// 标题只读
Property TitleReadonly As %String;

/// 是否包含日期
Property Datevisible As %String;

/// 是否包含标题
Property Titlevisible As %String;

/// 是否互斥
Property IsMutex As %String;

/// 是否加载引导框
Property IsLeadframe As %String;

/// 是否默认创建
Property DefaultCreate As %String;

/// 标题是否在日期之前
Property TitleBeforeDate As %String;

/// 文档特性（是否连续显示）
Property Serial As %String;

}
