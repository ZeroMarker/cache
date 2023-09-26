/// 名称:	EMR.DOC.DTO.StdDicParameter
/// 描述:	查询字典参数传输对象
/// 编写者：yejian
/// 编写日期: 2020-11-9
Class EMR.DOC.DTO.StdDicParameter Extends %RegisteredObject
{

/// 项目标识编码
Property ProductCode As %String(TRUNCATE = 1);

/// 字典编码
Property DicCode As %String(TRUNCATE = 1);

/// 条件代码
Property ConditionCode As %String(TRUNCATE = 1);

/// 条件内容
Property Condition As %String(TRUNCATE = 1);

/// 条件(对应QueryItem)
Property SearchValue As %String(TRUNCATE = 1);

/// 条件类型（搜索类型 0: 模糊搜索, 1: 精确搜索,2:左查询）
Property SearchType As %String(TRUNCATE = 1);

/// 内置默认条件true,false
Property DefaultFilter As %String(TRUNCATE = 1);

/// 总页数
Property PageCount As %String(TRUNCATE = 1);

/// 当前页数
Property Page As %String(TRUNCATE = 1);

/// 每页行数
Property PageSize As %String(TRUNCATE = 1);

/// 行数
Property RowCount As %String(TRUNCATE = 1);

/// 缓存ID
Property SessionId As %String(TRUNCATE = 1);

/// 缓存ID
Property CookieID As %String(TRUNCATE = 1);

/// 病种ID
Property DiseaseID As %String(TRUNCATE = 1);

/// 住院号
Property PatientID As %String(TRUNCATE = 1);

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 用户ID
Property UserID As %String(TRUNCATE = 1);

/// 用户编码
Property UserCode As %String(TRUNCATE = 1);

/// 用户名称
Property UserName As %String(TRUNCATE = 1);

/// 科室ID
Property UserLocID As %String(TRUNCATE = 1);

/// 科室编码
Property UserLocCode As %String(TRUNCATE = 1);

/// 科室名称
Property UserLocName As %String(TRUNCATE = 1);

/// 安全组ID
Property SSGroupID As %String(TRUNCATE = 1);

/// 院区ID
Property HospitalID As %String(TRUNCATE = 1);

/// IP地址
Property IpAddress As %String(TRUNCATE = 1);

/// 产品类型:EMR(病历)
Property PmdType As %String(TRUNCATE = 1);

/// 产品编码
Property PmdCode As %String(TRUNCATE = 1);

/// 是否屏蔽置默认条件（0:不屏蔽,1、屏蔽）
Property All As %String(TRUNCATE = 1);

/// 屏蔽默认条件是否改变（0:没改变,1、改变）
Property AllChange As %String(TRUNCATE = 1);

/// 0:不翻页（清缓存）,1、翻页（不清缓存）
Property TurnPage As %String(TRUNCATE = 1);

/// 最小数
Property MinCount As %Integer;

/// 最大数
Property MaxCount As %Integer;

/// 表名
Property DicTableName As %String(TRUNCATE = 0);

/// 编码
Property DicCodeCol As %String(TRUNCATE = 0);

/// 描述
Property DicDescCol As %String(TRUNCATE = 0);

/// 备注
Property DicAliasCol As %String(TRUNCATE = 0);

/// 是否包含GB字符（）
Property HasGB As %Integer;

/// 是否保留字典描述列中的横线
Property IsKeepMinus As %String(TRUNCATE = 0);

/// 总行数（）
Property Total As %Integer;

}
