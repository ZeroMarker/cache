Class web.DHCANOperationInfo Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

/// 手术记录序号
Property OperationRecordNo As %String(TRUNCATE = 1);

/// 手术明细序号
Property OperationNo As %String(TRUNCATE = 1);

/// 手术码表Id
Property OperId As %String(TRUNCATE = 1);

/// 手术名称
Property OpName As %String(TRUNCATE = 1);

/// 手术等级
Property AnaLevel As %String(TRUNCATE = 1);

/// 手术等级ID
Property AnaLevelId As %String(TRUNCATE = 1);

/// 切口类型Id
Property ANAOPBladeTypeId As %String(TRUNCATE = 1);

/// 切口类型
Property ANAOPBladeType As %String(TRUNCATE = 1);

/// 手术切口愈合等级
Property OperationHealClass As %String(TRUNCATE = 1);

/// 主次标志
Property IsMajorIden As %String(TRUNCATE = 1);

/// 是否医源性手术
Property IsIatrogenic As %String(TRUNCATE = 1);

}
