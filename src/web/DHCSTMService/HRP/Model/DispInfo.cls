Class web.DHCSTMService.HRP.Model.DispInfo Extends XmlCommon
{

///  流水号(唯一)
Property receiveid As %Library.String(MAXLEN = "", XMLNAME = "receive_id");

///  收费日期
Property chargedate As %Library.String(XMLNAME = "charge_date");

///  医嘱编码
Property adviceno As %Library.String(MAXLEN = "", XMLNAME = "advice_no");

///  收费项目编码
Property detailcode As %Library.String(MAXLEN = "", XMLNAME = "detail_code");

///  收费项目名称
Property detailname As %Library.String(MAXLEN = "", XMLNAME = "detail_name");

///  物资材料编码
Property invcode As %Library.String(MAXLEN = "", XMLNAME = "inv_code");

///  物资材料名称
Property invname As %Library.String(MAXLEN = "", XMLNAME = "inv_name");

///  批号
Property batchno As %Library.String(MAXLEN = "", XMLNAME = "batch_no");

///  条形码
Property barcode As %Library.String(MAXLEN = "", XMLNAME = "bar_code");

///  收费数量
Property chargenum As %Float(XMLNAME = "charge_num");

///  消耗数量
Property outnum As %Float(XMLNAME = "out_num");

///  收费单价
Property chargeprice As %Float(XMLNAME = "charge_price");

///  开单科室编码
Property orderdeptcode As %Library.String(MAXLEN = "", XMLNAME = "order_dept_code");

///  开单科室名称
Property orderdeptname As %Library.String(MAXLEN = "", XMLNAME = "order_dept_name");

///  执行科室编码
Property execdeptcode As %Library.String(MAXLEN = "", XMLNAME = "exec_dept_code");

///  执行科室名称
Property execdeptname As %Library.String(MAXLEN = "", XMLNAME = "exec_dept_name");

///  收费员编码
Property chargecode As %Library.String(MAXLEN = "", XMLNAME = "charge_code");

///  收费员名称
Property chargename As %Library.String(MAXLEN = "", XMLNAME = "charge_name");

///  护士工号
Property nursecode As %Library.String(MAXLEN = "", XMLNAME = "nurse_code");

///  护士名称
Property nursename As %Library.String(MAXLEN = "", XMLNAME = "nurse_name");

///  医生工号
Property doccode As %Library.String(MAXLEN = "", XMLNAME = "doc_code");

///  医生姓名
Property docname As %Library.String(MAXLEN = "", XMLNAME = "doc_name");

///  患者姓名
Property patientname As %Library.String(MAXLEN = "", XMLNAME = "patient_name");

///  住院号
Property hospitalno As %Library.String(MAXLEN = "", XMLNAME = "hospital_no");

///  病床号
Property bedno As %Library.String(MAXLEN = "", XMLNAME = "bed_no");

///  医嘱类别 (I-住院，O-门诊，E-急诊)
Property doctype As %Library.String(MAXLEN = "", XMLNAME = "doc_type");

///  是否高值耗材(0-普通材料，1-高值耗材)
Property ishighvalue As %Library.String(MAXLEN = "", XMLNAME = "is_high_value");

///  移库单明细id号（HRP移库确认时推送至His
Property iniowid As %Library.String(MAXLEN = "", XMLNAME = "in_iow_id");

///  使用日期
Property operdate As %Date(XMLNAME = "oper_date");

///  备注
Property message As %Library.String(MAXLEN = "", XMLNAME = "message");

/// 第三方批次唯一码
Property onlybatchsn As %Library.String(MAXLEN = "", XMLNAME = "only_batch_sn");

}
