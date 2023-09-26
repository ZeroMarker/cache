Class DHCEPRFS.INST.MREpisodeFee Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//BASYTotalFee,22ZLYYCXCLF,13XYF,14ZCHYF,TYWFY,17BDBLF,18QDBLF,05BLZDF,07YXXZDF,19NXYZF,03HLF,06SYSZDF,21JCYYCXCLF,24QTF,10SSZLF,16XF,12ZYZLF,11KFF,09FSSZLF,TYCF,20XPYZF,15ZCYF,08LCZDXMF,TYJSF,TYGHF,TYTJF,TYMZF,TYYEF,TYPCF,04QTFY,23SSYYCXCLF,01YBYLFWF,TMCCheckFeeTag

/// 索引 系统标识号
Index IdxMREpisodeID On MREpisodeID [ Unique ];

Index IdxF00TotalFee On F00TotalFee;

/// 02 系统标识号
Property MREpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 03 病人标识号
Property MRPatientID As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 04 医疗组织机构代码
Property CompanyCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 05 创建日期
Property CreateDate As %Date [ SqlColumnNumber = 5 ];

/// 06 创建时间
Property CreateTime As %Time [ SqlColumnNumber = 6 ];

/// 07 最后修改日期
Property LastModifyDate As %Date [ SqlColumnNumber = 7 ];

/// 08 最后修改时间
Property LastModifyTime As %Time [ SqlColumnNumber = 8 ];

/// 09 总费用
Property F00TotalFee As %Float [ SqlColumnNumber = 9 ];

/// 10 一般医疗服务费(01)
Property F01YBYLFWF As %Float [ SqlColumnNumber = 10 ];

/// 11 一般治疗操作费(02)
Property F02YBZLCZF As %Float [ SqlColumnNumber = 11 ];

/// 12 护理费(03)
Property F03HLF As %Float [ SqlColumnNumber = 12 ];

/// 13 其他费用(04)
Property F04QTFY As %Float [ SqlColumnNumber = 13 ];

/// 14 病理诊断费(05)
Property F05BLZDF As %Float [ SqlColumnNumber = 14 ];

/// 15 实验室诊断费(06)
Property F06SYSZDF As %Float [ SqlColumnNumber = 15 ];

/// 16 影像学诊断费(07)
Property F07YXXZDF As %Float [ SqlColumnNumber = 16 ];

/// 17 临床诊断项目费(08)
Property F08LCZDXMF As %Float [ SqlColumnNumber = 17 ];

/// 18 非手术治疗项目费(09)
Property F09FSSZLF As %Float [ SqlColumnNumber = 18 ];

/// 19 手术治疗费(10)
Property F10SSZLF As %Float [ SqlColumnNumber = 19 ];

/// 20 康复费(11)
Property F11KFF As %Float [ SqlColumnNumber = 20 ];

/// 21 中医治疗费(12)
Property F12ZYZLF As %Float [ SqlColumnNumber = 21 ];

/// 22 西药费(13)
Property F13XYF As %Float [ SqlColumnNumber = 22 ];

/// 23 中成药费(14)
Property F14ZCHYF As %Float [ SqlColumnNumber = 23 ];

/// 24 中草药费(15)
Property F15ZCYF As %Float [ SqlColumnNumber = 24 ];

/// 25 血费(16)
Property F16XF As %Float [ SqlColumnNumber = 25 ];

/// 26 白蛋白类制品费(17)
Property F17BDBLF As %Float [ SqlColumnNumber = 26 ];

/// 27 球蛋白类制品费(18)
Property F18QDBLF As %Float [ SqlColumnNumber = 27 ];

/// 28 凝血因子类制品费(19)
Property F19NXYZF As %Float [ SqlColumnNumber = 28 ];

/// 29 细胞因子类制品费(20)
Property F20XBYZF As %Float [ SqlColumnNumber = 29 ];

/// 30 检查用一次性医用材料费(21)
Property F21JCYYCXCLF As %Float [ SqlColumnNumber = 30 ];

/// 31 治疗用一次性医用材料费(22)
Property F22ZLYYCXCLF As %Float [ SqlColumnNumber = 31 ];

/// 32 手术用一次性医用材料费(23)
Property F23SSYYCXCLF As %Float [ SqlColumnNumber = 32 ];

/// 33 其他费(24)
Property F24QTF As %Float [ SqlColumnNumber = 33 ];

/// 34 临床物理治疗费(09-01)
Property F0901LCWLZLF As %Float [ SqlColumnNumber = 34 ];

/// 35 麻醉费(10-01)
Property F1001MZF As %Float [ SqlColumnNumber = 35 ];

/// 36 手术费(10-02)
Property F1002SSF As %Float [ SqlColumnNumber = 36 ];

/// 37 抗菌药物费用(13-01)
Property F1301KJYWF As %Float [ SqlColumnNumber = 37 ];

Storage Default
{
<Data name="MREpisodeFeeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MREpisodeID</Value>
</Value>
<Value name="3">
<Value>MRPatientID</Value>
</Value>
<Value name="4">
<Value>CompanyCode</Value>
</Value>
<Value name="5">
<Value>CreateDate</Value>
</Value>
<Value name="6">
<Value>CreateTime</Value>
</Value>
<Value name="7">
<Value>LastModifyDate</Value>
</Value>
<Value name="8">
<Value>LastModifyTime</Value>
</Value>
<Value name="9">
<Value>F00TotalFee</Value>
</Value>
<Value name="10">
<Value>F01YBYLFWF</Value>
</Value>
<Value name="11">
<Value>F02YBZLCZF</Value>
</Value>
<Value name="12">
<Value>F03HLF</Value>
</Value>
<Value name="13">
<Value>F04QTFY</Value>
</Value>
<Value name="14">
<Value>F05BLZDF</Value>
</Value>
<Value name="15">
<Value>F06SYSZDF</Value>
</Value>
<Value name="16">
<Value>F07YXXZDF</Value>
</Value>
<Value name="17">
<Value>F08LCZDXMF</Value>
</Value>
<Value name="18">
<Value>F09FSSZLF</Value>
</Value>
<Value name="19">
<Value>F10SSZLF</Value>
</Value>
<Value name="20">
<Value>F11KFF</Value>
</Value>
<Value name="21">
<Value>F12ZYZLF</Value>
</Value>
<Value name="22">
<Value>F13XYF</Value>
</Value>
<Value name="23">
<Value>F14ZCHYF</Value>
</Value>
<Value name="24">
<Value>F15ZCYF</Value>
</Value>
<Value name="25">
<Value>F16XF</Value>
</Value>
<Value name="26">
<Value>F17BDBLF</Value>
</Value>
<Value name="27">
<Value>F18QDBLF</Value>
</Value>
<Value name="28">
<Value>F19NXYZF</Value>
</Value>
<Value name="29">
<Value>F20XBYZF</Value>
</Value>
<Value name="30">
<Value>F21JCYYCXCLF</Value>
</Value>
<Value name="31">
<Value>F22ZLYYCXCLF</Value>
</Value>
<Value name="32">
<Value>F23SSYYCXCLF</Value>
</Value>
<Value name="33">
<Value>F24QTF</Value>
</Value>
<Value name="34">
<Value>F0901LCWLZLF</Value>
</Value>
<Value name="35">
<Value>F1001MZF</Value>
</Value>
<Value name="36">
<Value>F1002SSF</Value>
</Value>
<Value name="37">
<Value>F1301KJYWF</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.MREpisodeFeeD</DataLocation>
<DefaultData>MREpisodeFeeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.MREpisodeFeeD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.MREpisodeFeeI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.MREpisodeFeeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
