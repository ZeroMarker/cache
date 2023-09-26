Class DHCDoc.Interface.Outside.GXKJElecHealthCard.Entity.vmcardQRcode Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 用户姓名
Property name As %String(XMLNAME = "name");

/// 证件类型
Property idCardTypeCode As %String(XMLNAME = "idCardTypeCode");

/// 证件号
Property idCode As %String(XMLNAME = "idCode");

/// 证件有效期开始时间
Property validStartdate As %String(XMLNAME = "validStartdate");

/// 证件有效期结束时间
Property validEnddate As %String(XMLNAME = "validEnddate");

/// 发证机关
Property idInst As %String(XMLNAME = "idInst");

/// 用户性别	
Property sex As %String(XMLNAME = "sex");

/// 用户民族
Property nation As %String(XMLNAME = "nation");

/// 出生日期	
Property birthday As %String(XMLNAME = "birthday");

/// 本人手机号
Property phone As %String(XMLNAME = "phone");

/// 出生地
Property birthplace As %String(XMLNAME = "birthplace");

/// 联系人电话
Property telephone As %String(XMLNAME = "telephone");

/// 联系人姓名
Property linkman As %String(XMLNAME = "linkman");

/// 户籍地址
Property address As %String(XMLNAME = "address");

/// 婚姻状态代码
Property maritalstatuscode As %String(XMLNAME = "maritalstatuscode");

/// 居住地址
Property currentAddress As %String(XMLNAME = "currentAddress");

/// 证件照片
Property idPhoto As %String(XMLNAME = "idPhoto");

/// 头像照片
Property scenePhoto As %String(XMLNAME = "scenePhoto");

/// 国籍
Property nationality As %String(XMLNAME = "nationality");

/// 语言
Property language As %String(XMLNAME = "language");

/// 人员类型
Property personnelType As %String(XMLNAME = "personnelType");

/// 多胎标记
Property multifetalMark As %String(XMLNAME = "multifetalMark");

/// 多胎产次
Property multpripleBirths As %String(XMLNAME = "multpripleBirths");

/// 母亲姓名
Property motherName As %String(XMLNAME = "motherName");

/// 母亲身份证号
Property motherIdCode As %String(XMLNAME = "motherIdCode");

/// 母亲身份证号
Property motherEmpi As %String(XMLNAME = "motherEmpi");

/// 绑定的或者支持的支付账户类型
Property payAccType As %String(XMLNAME = "payAccType");

/// 操作方式
Property appMode As %String(XMLNAME = "appMode");

/// 机构唯一识别码
Property orgCode As %String(XMLNAME = "orgCode");

/// 应用备案号
Property appRecordNo As %String(XMLNAME = "appRecordNo");

/// 监护人姓名 加密
Property guardianName As %String(XMLNAME = "guardianName");

/// 监护人身份证号 加密
Property guardianIdcode As %String(XMLNAME = "guardianIdcode");

/// 监护人联系方式 加密
Property guardianPhone As %String(XMLNAME = "guardianPhone");

/// 居住省份代码  参照《中华人民共和国行政区划代码》（GBT2260-2013）（9位区划代码）(V1.1)
Property provinceCode As %String(XMLNAME = "provinceCode");

/// 居住城市代码  参照《中华人民共和国行政区划代码》（GBT2260-2013）（9位区划代码）(V1.1)
Property addressCityCode As %String(XMLNAME = "addressCityCode");

/// 居住县区代码  参照《中华人民共和国行政区划代码》（GBT2260-2013）（9位区划代码）(V1.1)
Property countyCode As %String(XMLNAME = "countyCode");

/// 职业类型  参照《中华人民共和国行政区划代码》（GBT2260-2013）（9位区划代码）(V1.1)
Property professionType As %String(XMLNAME = "professionType");

/// 是否实名认证  如已经实名认证，认证渠道为必传（传输代码）
Property recognizeFlag As %String(XMLNAME = "recognizeFlag");

}
