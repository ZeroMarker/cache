Class BILL.EINV.DTO.YGBX.EInvoiceDataBodyInvoiceInfoUL Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// JYH	交易号()	VARCHAR2(32)	是	唯一标识
Property JYH As %String(TRUNCATE = 1, XMLNAME = "JYH");

/// JYJGDM	成本中心	VARCHAR2(32)	是	核心系统交易机构的成本中心
Property JYJGDM As %String(TRUNCATE = 1, XMLNAME = "JYJGDM");

/// JYJGMC	交易机构名称	VARCHAR2(256)	是	核心系统交易机构名称
Property JYJGMC As %String(TRUNCATE = 1, XMLNAME = "JYJGMC");

/// ACNTUNIT	公司代码	VARCHAR2(50)	是	交易机构代码
Property ACNTUNIT As %String(TRUNCATE = 1, XMLNAME = "ACNTUNIT");

/// BDH	保单号	VARCHAR2(50)	是	如一个保单对应多个险种，不同险种需拆分为一条单独的数据发送
Property BDH As %String(TRUNCATE = 1, XMLNAME = "BDH");

/// PDH	批单号	VARCHAR2(50)	是	批单性质的业务，批单号码必填
Property PDH As %String(TRUNCATE = 1, XMLNAME = "PDH");

/// QC	期次	VARCHAR2(50)	否	付款期次
Property QC As %String(TRUNCATE = 1, XMLNAME = "QC");

/// TBRBM	投保人编码	VARCHAR2(50)	否	投保人编码
Property TBRBM As %String(TRUNCATE = 1, XMLNAME = "TBRBM");

/// TBRMC	投保人名称	VARCHAR2(50)	是	投保人名称
Property TBRMC As %String(TRUNCATE = 1, XMLNAME = "TBRMC");

/// NSRLX	纳税人类型	VARCHAR2(50)	是	一般纳税人\小规模纳税人\个人
Property NSRLX As %String(TRUNCATE = 1, XMLNAME = "NSRLX");

/// NSRSBH	纳税人识别号	VARCHAR2(32)	否	表示投保人税务登记证上地址，和营业执照注册地址一致。开票要求为专票时，必填，其他可为空。
Property NSRSBH As %String(TRUNCATE = 1, XMLNAME = "NSRSBH");

/// KPDZ	开票地址	VARCHAR2(256)	否	表示投保人税务登记证上地址，和营业执照注册地址一致。开票要求为专票时，必填，其他可为空。
Property KPDZ As %String(TRUNCATE = 1, XMLNAME = "KPDZ");

/// KPDH	开票电话	VARCHAR2(32)	否	表示投保人税局预留的固定电话一致；开票要求为专票时，必填，其他可为空。
Property KPDH As %String(TRUNCATE = 1, XMLNAME = "KPDH");

/// KHYH	开户银行	VARCHAR2(200)	否	表示投保人开户银行，一般为投保人基本户开户行。开票要求为专票时，必填，其他可为空。
Property KHYH As %String(TRUNCATE = 1, XMLNAME = "KHYH");

/// YHZH	银行账号	VARCHAR2(50)	否	表示投保人银行账号，一般为基本户开户银行账号。开票要求为专票时，必填，其他可为空。
Property YHZH As %String(TRUNCATE = 1, XMLNAME = "YHZH");

/// JYRQ	交易日期	DATE	是	表示业务生效且确认收入日期，YYYY-XX-XX
Property JYRQ As %String(TRUNCATE = 1, XMLNAME = "JYRQ");

/// JYLX	交易类型	VARCHAR2(50)	是	业务系统明细交易类型，枚举：保费收入、利息收入、账户管理费收入等
Property JYLX As %String(TRUNCATE = 1, XMLNAME = "JYLX");

/// XZDM	险种代码	VARCHAR2(50)	是	交易类型为保费收入的，必填，否则可为空
Property XZDM As %String(TRUNCATE = 1, XMLNAME = "XZDM");

/// XZMC	险种名称	VARCHAR2(256)	是	交易类型为保费收入的，必填，否则可为空
Property XZMC As %String(TRUNCATE = 1, XMLNAME = "XZMC");

/// XBDM	险别代码	VARCHAR2(50)	否	交易类型为保费收入的，必填，否则可为空
Property XBDM As %String(TRUNCATE = 1, XMLNAME = "XBDM");

/// XBMC	险别名称	VARCHAR2(256)	否	交易类型为保费收入的，必填，否则可为空
Property XBMC As %String(TRUNCATE = 1, XMLNAME = "XBMC");

/// HSJE	含税金额	NUMBER(20,2)	是	价税分离前金额
Property HSJE As %String(TRUNCATE = 1, XMLNAME = "HSJE");

/// SL	税率	NUMBER(8,4)	是	该交易价税分离采用税率
Property SL As %String(TRUNCATE = 1, XMLNAME = "SL");

/// BHSJE	不含税金额	NUMBER(20,2)	是	价税分离后金额
Property BHSJE As %String(TRUNCATE = 1, XMLNAME = "BHSJE");

/// SE	税额	NUMBER(20,4)	是	价税分离生成的税额
Property SE As %String(TRUNCATE = 1, XMLNAME = "SE");

/// YJYH	原保单号	VARCHAR2(32)	否	交易金额为负数时，保全发生回退业务时发送原业务编号（保单受理号），其他业务提供对应的保单号
Property YJYH As %String(TRUNCATE = 1, XMLNAME = "YJYH");

/// JFRMC	缴费人名称	VARCHAR2(36)
Property JFRMC As %String(TRUNCATE = 1, XMLNAME = "JFRMC");

/// KPYQ	开票要求	VARCHAR2(1)	是	0-专票；1-普票
Property KPYQ As %String(TRUNCATE = 1, XMLNAME = "KPYQ");

/// FPJZ	发票介质	VARCHAR2(1)	是	0-纸质；2-电子
Property FPJZ As %String(TRUNCATE = 1, XMLNAME = "FPJZ");

/// YWYBM	业务员编码	VARCHAR2(50)	否	完成保单交易业务员代码
Property YWYBM As %String(TRUNCATE = 1, XMLNAME = "YWYBM");

/// YWYMC	业务员名称	VARCHAR2(50)	否	完成保单交易业务员名称
Property YWYMC As %String(TRUNCATE = 1, XMLNAME = "YWYMC");

/// LYXTMC	来源系统名称	VARCHAR2(50)	是	数据来源系统名称
Property LYXTMC As %String(TRUNCATE = 1, XMLNAME = "LYXTMC");

/// QD	渠道	VARCHAR2(30)	否	渠道
Property QD As %String(TRUNCATE = 1, XMLNAME = "QD");

/// REMARK	备注	VARCHAR2(256)	否	发票备注
Property REMARK As %String(TRUNCATE = 1, XMLNAME = "REMARK");

/// YECJBS	业务场景标识	INTEGER	是	0-正常1-5月1 日批减2-信保业务收入3-共保业务4-共保分出5-共保退保
Property YECJBS As %String(TRUNCATE = 1, XMLNAME = "YECJBS");

/// JZRQ	记账日期	VARCHAR2(10)	是	收付挂账日期
Property JZRQ As %String(TRUNCATE = 1, XMLNAME = "JZRQ");

/// ZJLX	证件类型	VARCHAR2(100)	否	01-身份证02-户口薄03-护照04-军官证05-驾驶证06-返乡证07-异常身份证08-组织机构代码证99-其他
Property ZJLX As %String(TRUNCATE = 1, XMLNAME = "ZJLX");

/// ZJHM	证件号码	VARCHAR2(100)	否	
Property ZJHM As %String(TRUNCATE = 1, XMLNAME = "ZJHM");

/// COINSFLAG	联共保的标识	VARCHAR2(20)	否	退保是9，1到8是共保标识
Property COINSFLAG As %String(TRUNCATE = 1, XMLNAME = "COINSFLAG");

/// STARTDATE	税款所属期起期	VARCHAR2(100)	否	
Property STARTDATE As %String(TRUNCATE = 1, XMLNAME = "STARTDATE");

/// ENROLLDATE	税款所属期止期	VARCHAR2(100)	否	
Property ENROLLDATE As %String(TRUNCATE = 1, XMLNAME = "ENROLLDATE");

/// LICENSENO	车牌号	VARCHAR2(100)	否
Property LICENSENO As %String(TRUNCATE = 1, XMLNAME = "LICENSENO");

/// LATEFEE	滞纳金	VARCHAR2(100)	否	
Property LATEFEE As %String(TRUNCATE = 1, XMLNAME = "LATEFEE");

/// CARSHIPTAX	车船税	VARCHAR2(100)	否	
Property CARSHIPTAX As %String(TRUNCATE = 1, XMLNAME = "CARSHIPTAX");

/// APPLITYPE	个人团体标识	VARCHAR2(5)	否	1代表个人，2代表团体
Property APPLITYPE As %String(TRUNCATE = 1, XMLNAME = "APPLITYPE");

/// OPERATESITE	渠道标识	VARCHAR2(30)	否	空代表是核心出单，QBDQCWY- 关于与700度平台，QBDDIYDSX-700度--个意险承保，YGQBD-700度网络平台互联网业务（个险）对接 ，WJBX-网金阳光个人综合意外险
Property OPERATESITE As %String(TRUNCATE = 1, XMLNAME = "OPERATESITE");

/// XBFLAG	信保标识	VARCHAR2(30)	否
Property XBFLAG As %String(TRUNCATE = 1, XMLNAME = "XBFLAG");

/// APPSERIALPERIOD	缴费期数	VARCHAR2(30)	否	
Property APPSERIALPERIOD As %String(TRUNCATE = 1, XMLNAME = "APPSERIALPERIOD");

/// ISCARINSURANCE	自动开票标识	VARCHAR2(10)	否	
Property ISCARINSURANCE As %String(TRUNCATE = 1, XMLNAME = "ISCARINSURANCE");

/// WBHSJE	外币含税金额	NUMBER(20,2)	否	
Property WBHSJE As %String(TRUNCATE = 1, XMLNAME = "WBHSJE");

/// WBBHSJE	外币不含税金额	NUMBER(20,2)	否
Property WBBHSJE As %String(TRUNCATE = 1, XMLNAME = "WBBHSJE");

/// WBSE	外币税额	NUMBER(20,2)	否	
Property WBSE As %String(TRUNCATE = 1, XMLNAME = "WBSE");

/// YBZ	原币种	VARCHAR2(10)	是	人民币需填写CNY
Property YBZ As %String(TRUNCATE = 1, XMLNAME = "YBZ");

/// EMAILADDRESS	邮箱地址	VARCHAR2(100)	否
Property EMAILADDRESS As %String(TRUNCATE = 1, XMLNAME = "EMAILADDRESS");

}
