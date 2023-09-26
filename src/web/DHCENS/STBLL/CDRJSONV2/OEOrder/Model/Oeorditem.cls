Class web.DHCENS.STBLL.CDRJSONV2.OEOrder.Model.Oeorditem Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

/// 父医嘱明细id 
Property oeoriparentorderid As %Library.String(MAXLEN = 100, XMLNAME = "oeoriparentorderid");

/// 医嘱项目代码 
Property oeoriarcitmmastcode As %Library.String(MAXLEN = 100, XMLNAME = "oeoriarcitmmastcode");

/// 医嘱类型代码 
Property oeoriprioritycode As %Library.String(MAXLEN = 100, XMLNAME = "oeoriprioritycode");

/// 医嘱附加类型代码 
Property oeoripriorityaddcode As %Library.String(MAXLEN = 100, XMLNAME = "oeoripriorityaddcode");

/// 医嘱状态 
Property oeoristatus As %Library.String(MAXLEN = 100, XMLNAME = "oeoristatus");

/// 剂型代码 
Property oeoridoseforms As %Library.String(MAXLEN = 100, XMLNAME = "oeoridoseforms");

/// 单次剂量 
Property oeoridoseqty As %Library.String(MAXLEN = 100, XMLNAME = "oeoridoseqty");

/// 单次剂量单位代码 
Property oeoridoseunitcode As %Library.String(MAXLEN = 100, XMLNAME = "oeoridoseunitcode");

/// 频次代码 
Property oeorifreqcode As %Library.String(MAXLEN = 100, XMLNAME = "oeorifreqcode");

/// 用药途径代码 
Property oeoriinstrcode As %Library.String(MAXLEN = 100, XMLNAME = "oeoriinstrcode");

/// 疗程 
Property oeoridurationcode As %Library.String(MAXLEN = 100, XMLNAME = "oeoridurationcode");

/// 医嘱数量 
Property oeoriorderqty As %Library.String(MAXLEN = 100, XMLNAME = "oeoriorderqty");

/// 计价单位 
Property oeorichargeunit As %Library.String(MAXLEN = 100, XMLNAME = "oeorichargeunit");

/// 医嘱备注信息 
Property oeoriremarks As %Library.String(MAXLEN = 100, XMLNAME = "oeoriremarks");

/// 医嘱开立者代码 
Property oeorienterdoccode As %Library.String(MAXLEN = 100, XMLNAME = "oeorienterdoccode");

/// 医嘱开立日期 
Property oeorienterdate As %Library.String(MAXLEN = 100, XMLNAME = "oeorienterdate");

/// 医嘱开立时间 
Property oeorientertime As %Library.String(MAXLEN = 100, XMLNAME = "oeorientertime");

/// 医嘱开立科室代码 
Property oeorienterdeptcode As %Library.String(MAXLEN = 100, XMLNAME = "oeorienterdeptcode");

/// 医嘱执行科室 
Property oeoriexecdeptcode As %Library.String(MAXLEN = 100, XMLNAME = "oeoriexecdeptcode");

/// 要求执行日期 
Property oeorirequireexecdate As %Library.String(MAXLEN = 100, XMLNAME = "oeorirequireexecdate");

/// 要求执行时间 
Property oeorirequireexectime As %Library.String(MAXLEN = 100, XMLNAME = "oeorirequireexectime");

/// 医嘱停止日期 
Property oeoristopdate As %Library.String(MAXLEN = 100, XMLNAME = "oeoristopdate");

/// 医嘱停止时间 
Property oeoristoptime As %Library.String(MAXLEN = 100, XMLNAME = "oeoristoptime");

/// 停止医嘱者代码 
Property oeoristopdoccode As %Library.String(MAXLEN = 100, XMLNAME = "oeoristopdoccode");

/// 是否皮试 
Property oeoriisskintest As %Library.String(MAXLEN = 100, XMLNAME = "oeoriisskintest");

/// 最后更新日期 
Property oeoriupdatedate As %Library.String(MAXLEN = 100, XMLNAME = "oeoriupdatedate");

/// 最后更新时间 
Property oeoriupdatetime As %Library.String(MAXLEN = 100, XMLNAME = "oeoriupdatetime");

/// 最后更新人编码 
Property oeoriupdateusercode As %Library.String(MAXLEN = 100, XMLNAME = "oeoriupdateusercode");

/// 处方号 
Property oeoriprescno As %Library.String(MAXLEN = 100, XMLNAME = "oeoriprescno");

/// 时间戳 
Property updatedate As %Library.String(MAXLEN = 100, XMLNAME = "updatedate");

/// 时间戳 
Property updatetime As %Library.String(MAXLEN = 100, XMLNAME = "updatetime");

/// 医嘱别名 
Property oeorialias As %Library.String(MAXLEN = 100, XMLNAME = "oeorialias");

/// 业务域编号 
Property businessfieldcode As %Library.String(MAXLEN = 100, XMLNAME = "businessfieldcode");

/// 组号 
Property oeoriseqno As %Library.String(MAXLEN = 100, XMLNAME = "oeoriseqno");

/// 医嘱费别 
Property oeoricostcategorycode As %Library.String(MAXLEN = 100, XMLNAME = "oeoricostcategorycode");

/// 停止医嘱者描述 
Property oeoristopdocname As %Library.String(MAXLEN = 100, XMLNAME = "oeoristopdocname");

/// 医嘱开立者描述 
Property oeorienterdocname As %Library.String(MAXLEN = 100, XMLNAME = "oeorienterdocname");

/// 滚医嘱来源信息（东华老版本滚医嘱用到的，保存上一个医嘱id） 
Property oeorifillerno As %Library.String(MAXLEN = 100, XMLNAME = "oeorifillerno");

/// 业务域_院内患者id 
Property papatrelpatientid As %Library.String(MAXLEN = 100, XMLNAME = "papatrelpatientid");

/// 业务域_院内就诊号 
Property paadmrelvisitnumber As %Library.String(MAXLEN = 100, XMLNAME = "paadmrelvisitnumber");

/// 院内医嘱明细id 
Property oeorihosorderitemid As %Library.String(MAXLEN = 100, XMLNAME = "oeorihosorderitemid");

/// 全局医嘱明细id 
Property oeorirelorderitemid As %Library.String(MAXLEN = 100, XMLNAME = "oeorirelorderitemid");

}
