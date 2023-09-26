Class BILL.EINV.DTO.HBA.EComFPKJFPTXX Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Property class As %String(XMLPROJECTION = "ATTRIBUTE");

Property FPQQLSH As %String(CAPTION = "发票请求唯一流水号", XMLNAME = "FPQQLSH");

Property DSPTBM As %String(CAPTION = "平台编码", XMLNAME = "DSPTBM");

Property NSRSBH As %String(CAPTION = "销方纳税人识别号", XMLNAME = "NSRSBH");

Property NSRMC As %String(CAPTION = "销方名称", XMLNAME = "NSRMC");

Property NSRDZDAH As %String(CAPTION = "销方电子档案号", XMLNAME = "taxpayerId");

Property SWJGDM As %String(CAPTION = "税务机构代码", XMLNAME = "SWJG_DM");

Property DKBZ As %String(CAPTION = "代开标志", XMLNAME = "DKBZ");

Property PYDM As %String(CAPTION = "票样代码", XMLNAME = "PYDM");

Property KPXM As %String(CAPTION = "主要开票项目", XMLNAME = "KPXM");

Property XHFNSRSBH As %String(CAPTION = "销方纳税人识别号", XMLNAME = "XHF_NSRSBH");

Property XHFMC As %String(CAPTION = "销方名称", XMLNAME = "XHFMC");

Property XHFDZ As %String(CAPTION = "销方地址", XMLNAME = "XHF_DZ");

Property XHFDH As %String(CAPTION = "销方电话", XMLNAME = "XHF_DH");

Property XHFYHZH As %String(CAPTION = "销方银行账号", XMLNAME = "XHF_YHZH");

Property XHFWX As %String(CAPTION = "销方银行账号", XMLNAME = "XHF_WX");

Property GHFMC As %String(CAPTION = "购方名称", XMLNAME = "GHFMC");

Property GHFNSRSBH As %String(CAPTION = "购货方纳税人识别号", XMLNAME = "GHF_NSRSBH");

Property GHFSF As %String(CAPTION = "购货方省份", XMLNAME = "GHF_SF");

Property GHFDZ As %String(CAPTION = "购货方地址", XMLNAME = "GHF_DZ");

Property GHFGDDH As %String(CAPTION = "购货方固定电话", XMLNAME = "GHF_GDDH");

Property GHFSJ As %String(CAPTION = "购货方手机", XMLNAME = "GHF_SJ");

Property GHFEMAIL As %String(CAPTION = "购货方邮箱", XMLNAME = "GHF_EMAIL");

Property GHFQYLX As %String(CAPTION = "购方名称", XMLNAME = "GHFQYLX");

Property GHFYHZH As %String(CAPTION = "购货方银行账号", XMLNAME = "GHF_YHZH");

Property GHFWX As %String(CAPTION = "购货方微信", XMLNAME = "GHF_WX");

Property HYDM As %String(CAPTION = "行业代码", XMLNAME = "HY_DM");

Property HYMC As %String(CAPTION = "行业名称", XMLNAME = "HY_MC");

Property KPDBH As %String(CAPTION = "开票点编号", XMLNAME = "KPDBH");

Property KPY As %String(CAPTION = "开票员", XMLNAME = "KPY");

Property SKY As %String(CAPTION = "收款员", XMLNAME = "SKY");

Property FHR As %String(CAPTION = "复核人", XMLNAME = "FHR");

Property KPRQ As %String(CAPTION = "开票日期", XMLNAME = "KPRQ");

Property KPLX As %String(CAPTION = "开票类型", XMLNAME = "KPLX");

Property YFPDM As %String(CAPTION = "原发票代码", XMLNAME = "YFP_DM");

Property YFPHM As %String(CAPTION = "原发票号码", XMLNAME = "YFP_HM");

Property CZDM As %String(CAPTION = "操作代码", XMLNAME = "CZDM");

Property CHYY As %String(CAPTION = "冲红原因", XMLNAME = "CHYY");

Property TSCHBZ As %String(CAPTION = "特殊冲红标志", XMLNAME = "TSCHBZ");

Property KPHJJE As %String(CAPTION = "价税合计金额", XMLNAME = "KPHJJE");

Property HJBHSJE As %String(CAPTION = "合计不含税金额", XMLNAME = "HJBHSJE");

Property HJSE As %String(CAPTION = "合计税额", XMLNAME = "HJSE");

Property BMBBBH As %String(CAPTION = "编码表版本号", XMLNAME = "BMB_BBH");

Property QDBZ As %String(CAPTION = "清单标识", XMLNAME = "QD_BZ");

Property QDXMMC As %String(CAPTION = "清单发票项目名称", XMLNAME = "QDXMMC");

Property BZ As %String(CAPTION = "备注", XMLNAME = "BZ");

Property BYZD1 As %String(CAPTION = "备用字段", XMLNAME = "BYZD1");

Property BYZD2 As %String(CAPTION = "备用字段", XMLNAME = "BYZD2");

Property BYZD3 As %String(CAPTION = "备用字段", XMLNAME = "BYZD3");

Property BYZD4 As %String(CAPTION = "备用字段", XMLNAME = "BYZD4");

Property BYZD5 As %String(CAPTION = "备用字段", XMLNAME = "BYZD5");

}
