Class DHCEPRFS.Entity.EMRMedRecord Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// 02 病案号
Property MedRecordNo As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 03 归档系统病人ID
Property MRPatientID As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 04 系统标示
Property SysCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 05 创建日期
Property CreateDate As %Date [ SqlColumnNumber = 5 ];

/// 06 创建时间
Property CreateTime As %Time [ SqlColumnNumber = 6 ];

/// 07 最后修改日期
Property LastModifyDate As %Date [ SqlColumnNumber = 7 ];

/// 08 最后修改时间
Property LastModifyTime As %Time [ SqlColumnNumber = 8 ];

/// 09 是否HIS病案号
Property IsHISMedRecord As %String(TRUNCATE = 1) [ SqlColumnNumber = 9 ];

}
