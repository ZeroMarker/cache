/// 名称: web.DHCBillParamConfig
/// 描述: 封装计费组参数配置类
/// 编写者: ZhYW
/// 编写日期: 2017-05-31
Class web.DHCBillParamConfig Extends %RegisteredObject
{

/// 是否做明细账的设置？1:做明细账, <>1:不做明细账
Parameter DetailsSaveFlag [ Final ] = 1;

/// 门诊收费医保实时结算时, DHC_AccPayINV表是否保存小条表医保结算信息(DHC_INVPRT.PRT_InsDiv_DR)?  1:保存, <>1:不保存
Parameter APISavePRTInsDivFlag [ Final ] = 0;

/// 没有业务数据时是否日结？1:不日结, <>1:日结
Parameter NullBDHandinFlag [ Final ] = 1;

/// 最小剩余票数提醒数量
Parameter MinTipRcptNum [ Final ] = 10;

/// 门急诊费用转住院业务，转入后的价格时间以门诊收费还是以住院执行时间？1:以门诊收费时间, <>1:以住院执行时间
Parameter Em2IPPriceMode [ Final ] = 1;

}
