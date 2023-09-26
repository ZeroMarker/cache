Class web.DHCENS.STBLL.CDRJSONV2.EmConsult.Model.DHCEmConsult Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

/// 申请科室代码 
Property ecrloccode As %Library.String(MAXLEN = 100, XMLNAME = "ecrloccode");

/// 申请日期 
Property ecrdate As %Library.String(MAXLEN = 100, XMLNAME = "ecrdate");

/// 申请时间 
Property ecrtime As %Library.String(MAXLEN = 100, XMLNAME = "ecrtime");

/// 申请医生 
Property ecrusercode As %Library.String(MAXLEN = 100, XMLNAME = "ecrusercode");

/// 病情及诊疗经过 
Property ectrepro As %Library.String(MAXLEN = 100, XMLNAME = "ectrepro");

/// 会诊的理由和目的 
Property ecpurpose As %Library.String(MAXLEN = 100, XMLNAME = "ecpurpose");

/// 会诊类别 
Property eccategory As %Library.String(MAXLEN = 100, XMLNAME = "eccategory");

/// 医生级别 
Property ecdoclev As %Library.String(MAXLEN = 100, XMLNAME = "ecdoclev");

/// 会诊日期 
Property ecndate As %Library.String(MAXLEN = 100, XMLNAME = "ecndate");

/// 会诊时间 
Property ecntime As %Library.String(MAXLEN = 100, XMLNAME = "ecntime");

/// 会诊地点 
Property ecnplace As %Library.String(MAXLEN = 100, XMLNAME = "ecnplace");

/// 审核科室 
Property ecaloccode As %Library.String(MAXLEN = 100, XMLNAME = "ecaloccode");

/// 审核人 
Property ecausercode As %Library.String(MAXLEN = 100, XMLNAME = "ecausercode");

/// 审核日期 
Property ecadate As %Library.String(MAXLEN = 100, XMLNAME = "ecadate");

/// 审核时间 
Property ecatime As %Library.String(MAXLEN = 100, XMLNAME = "ecatime");

/// 最终治疗措施 
Property ectremeasures As %Library.String(MAXLEN = 100, XMLNAME = "ectremeasures");

/// 申请状态 
Property ecrstatus As %Library.String(MAXLEN = 100, XMLNAME = "ecrstatus");

/// 会诊类型 
Property ectype As %Library.String(MAXLEN = 100, XMLNAME = "ectype");

/// 完成日期 
Property eccdate As %Library.String(MAXLEN = 100, XMLNAME = "eccdate");

/// 完成时间 
Property ecctime As %Library.String(MAXLEN = 100, XMLNAME = "ecctime");

/// 完成人 
Property eccusercode As %Library.String(MAXLEN = 100, XMLNAME = "eccusercode");

/// 是否加急 
Property ecemflag As %Library.String(MAXLEN = 100, XMLNAME = "ecemflag");

/// 是否院外 
Property ecoutflag As %Library.String(MAXLEN = 100, XMLNAME = "ecoutflag");

/// 外院名称 
Property ecunit As %Library.String(MAXLEN = 100, XMLNAME = "ecunit");

/// 外院医师 
Property ecdocname As %Library.String(MAXLEN = 100, XMLNAME = "ecdocname");

/// 备注 
Property ecremark As %Library.String(MAXLEN = 100, XMLNAME = "ecremark");

/// 联系人 
Property ecconsuser As %Library.String(MAXLEN = 100, XMLNAME = "ecconsuser");

/// 联系电话 
Property ecconsphone As %Library.String(MAXLEN = 100, XMLNAME = "ecconsphone");

/// 是否共享 
Property ecshareflag As %Library.String(MAXLEN = 100, XMLNAME = "ecshareflag");

/// 是否多科 
Property ecmoredepflag As %Library.String(MAXLEN = 100, XMLNAME = "ecmoredepflag");

/// 是否有医疗纠纷 
Property ecmedcaltangle As %Library.String(MAXLEN = 100, XMLNAME = "ecmedcaltangle");

/// 目前存在问题 
Property eccurquestion As %Library.String(MAXLEN = 100, XMLNAME = "eccurquestion");

/// 会诊意见 
Property ecopintion As %Library.String(MAXLEN = 100, XMLNAME = "ecopintion");

/// 是否同意使用抗生素 
Property ecconsentanti As %Library.String(MAXLEN = 100, XMLNAME = "ecconsentanti");

/// 是否开启医嘱录入 
Property ecordwriteflag As %Library.String(MAXLEN = 100, XMLNAME = "ecordwriteflag");

/// 打印标志 
Property ecprintflag As %Library.String(MAXLEN = 100, XMLNAME = "ecprintflag");

/// 外院科室 
Property ecunitdept As %Library.String(MAXLEN = 100, XMLNAME = "ecunitdept");

/// 评价标志 
Property ecevaflag As %Library.String(MAXLEN = 100, XMLNAME = "ecevaflag");

/// 评价内容 
Property ecevadesc As %Library.String(MAXLEN = 100, XMLNAME = "ecevadesc");

/// 院内会诊申请id 
Property echosemconsultid As %Library.String(MAXLEN = 100, XMLNAME = "echosemconsultid");

/// 业务域代码 
Property businessfieldcode As %Library.String(MAXLEN = 100, XMLNAME = "businessfieldcode");

/// 时间戳日期 
Property updatedate As %Library.String(MAXLEN = 100, XMLNAME = "updatedate");

/// 时间戳时间 
Property updatetime As %Library.String(MAXLEN = 100, XMLNAME = "updatetime");

/// 业务域_院内会诊申请id 
Property ecrelemconsultid As %Library.String(MAXLEN = 100, XMLNAME = "ecrelemconsultid");

/// 业务域_院内患者id 
Property papatrelpatientid As %Library.String(MAXLEN = 100, XMLNAME = "papatrelpatientid");

/// 业务域_院内就诊号 
Property paadmrelvisitnumber As %Library.String(MAXLEN = 100, XMLNAME = "paadmrelvisitnumber");

}
