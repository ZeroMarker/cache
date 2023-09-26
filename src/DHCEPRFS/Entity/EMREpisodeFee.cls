Class DHCEPRFS.Entity.EMREpisodeFee Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Property ID As %String(TRUNCATE = 1);

/// 02 系统标识号
Property MREpisodeID As %String(TRUNCATE = 1);

/// 03 病人标识号
Property MRPatientID As %String(TRUNCATE = 1);

/// 04 医疗组织机构代码
Property CompanyCode As %String(TRUNCATE = 1);

/// 05 创建日期
Property CreateDate As %Date;

/// 06 创建时间
Property CreateTime As %Time;

/// 07 最后修改日期
Property LastModifyDate As %Date;

/// 08 最后修改时间
Property LastModifyTime As %Time;

/// 09 总费用
Property F00TotalFee As %Float;

/// 10 一般医疗服务费(01)
Property F01YBYLFWF As %Float;

/// 11 一般治疗操作费(02)
Property F02YBZLCZF As %Float;

/// 12 护理费(03)
Property F03HLF As %Float;

/// 13 其他费用(04)
Property F04QTFY As %Float;

/// 14 病理诊断费(05)
Property F05BLZDF As %Float;

/// 15 实验室诊断费(06)
Property F06SYSZDF As %Float;

/// 16 影像学诊断费(07)
Property F07YXXZDF As %Float;

/// 17 临床诊断项目费(08)
Property F08LCZDXMF As %Float;

/// 18 非手术治疗项目费(09)
Property F09FSSZLF As %Float;

/// 19 手术治疗费(10)
Property F10SSZLF As %Float;

/// 20 康复费(11)
Property F11KFF As %Float;

/// 21 中医治疗费(12)
Property F12ZYZLF As %Float;

/// 22 西药费(13)
Property F13XYF As %Float;

/// 23 中成药费(14)
Property F14ZCHYF As %Float;

/// 24 中草药费(15)
Property F15ZCYF As %Float;

/// 25 血费(16)
Property F16XF As %Float;

/// 26 白蛋白类制品费(17)
Property F17BDBLF As %Float;

/// 27 球蛋白类制品费(18)
Property F18QDBLF As %Float;

/// 28 凝血因子类制品费(19)
Property F19NXYZF As %Float;

/// 29 细胞因子类制品费(20)
Property F20XBYZF As %Float;

/// 30 检查用一次性医用材料费(21)
Property F21JCYYCXCLF As %Float;

/// 31 治疗用一次性医用材料费(22)
Property F22ZLYYCXCLF As %Float;

/// 32 手术用一次性医用材料费(23)
Property F23SSYYCXCLF As %Float;

/// 33 其他费(24)
Property F24QTF As %Float;

/// 34 临床物理治疗费(09-01)
Property F0901LCWLZLF As %Float;

/// 35 麻醉费(10-01)
Property F1001MZF As %Float;

/// 36 手术费(10-02)
Property F1002SSF As %Float;

/// 37 抗菌药物费用(13-01)
Property F1301KJYWF As %Float;

}
