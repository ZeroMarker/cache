/// 4302 计费医保组判断是否是急诊留观
Class DHCCL.Product.ForINSU.DTO.EmergencyOperInfo Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLTYPE = "Model";

Parameter XMLNAME = "EmergencyOperInfo";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 1	mdtrt_sn	就医流水号
Property sn As %String;

/// 2	mdtrt_id	就诊ID
Property id As %String;

/// 3	psn_no	人员编号
Property no As %String;

/// 4	medrcdno	病历号
Property medrcdno As %String;

/// 5	oprn_oprt_sn	手术操作序号
Property seqNo As %String;

/// 6	oprn_oprt_code	手术操作代码
Property operCode As %String;

/// 7	oprn_oprt_name	手术操作名称
Property operDesc As %String;

/// 8	oprn_oprt_tagt_ part_name	手术操作目标部位名称
Property bodySite As %String;

/// 9	itvt_name	介入物名称
Property interventionName As %String;

/// 10	oprn_oprt_mtd_ dscr	手术及操作方法描述
Property operMethodDesc As %String;

/// 11	oprn_oprt_cnt	手术及操作次数
Property operCnt As %String;

/// 12	oprn_oprt_time	手术及操作时间
Property operTime As %String;

/// 13	vali_flag	有效标志
Property validateFlag As %String;

}
