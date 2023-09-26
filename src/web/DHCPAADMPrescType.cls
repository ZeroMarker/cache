Class web.DHCPAADMPrescType Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 根据处方名称,费别rowid,就诊类型,得到唯一处方的限制属性
/// w ##class(web.DHCPAADMPrescType).GetPrescLimitStr("O","自费","1")
ClassMethod GetPrescLimitStr(PAADMType As %String, OrderPrescType As %String, OrderBillTypeRowid As %String, CurLogonHosp As %String = "") As %String
{
	q:(PAADMType="")||(OrderPrescType="")||(OrderBillTypeRowid="") ""
	s PrescLimitStr=""
	set rowid=0 for  s rowid=$O(^DHCPAADMPrescType(0,"PAADMType",PAADMType,rowid)) q:rowid=""  d
	.s BillTypeRowid=$p($g(^DHCPAADMPrescType(rowid)),"^",2)
	.s PrescTypeRowid=$p($g(^DHCPAADMPrescType(rowid)),"^",3)
	.s PrescTypeDefault=$p($g(^DHCPAADMPrescType(rowid)),"^",4)
	.q:(OrderBillTypeRowid'=+BillTypeRowid) 
	.s rowid=$p(rowid,$C(1),1)
	.q:PrescTypeRowid=""
	.s PrescTypeDesc=$p($g(^DHCPrescriptType(PrescTypeRowid)),"^",2)
	.q:PrescTypeDesc'=OrderPrescType //2015-11-26 为何以前是去掉的？
	.s PrescTypeCode=$p($g(^DHCPrescriptType(PrescTypeRowid)),"^",1)
	.s PrescBillTypeRowid=$p($g(^DHCPrescriptType(PrescTypeRowid)),"^",9)
	.s PrescItemCat=..%GetConfig1("PrescriptItemCat",PrescTypeRowid,CurLogonHosp)
	.s PrescLimitSum=$p($g(^DHCPrescriptType(PrescTypeRowid)),"^",5)
	.s PrescLimitCount=$p($g(^DHCPrescriptType(PrescTypeRowid)),"^",6)
	.s PTUnaveLimitSum=$p(^DHCPrescriptType(PrescTypeRowid),"^",7)
	.s PrescLimitType=$p(^DHCPrescriptType(PrescTypeRowid),"^",8)
	.s PrescLimitStr=PrescTypeRowid_"!"_PrescTypeCode_"!"_PrescTypeDesc_"!"_PrescItemCat_"!"_PrescBillTypeRowid_"!"_PrescLimitSum_"!"_PrescLimitCount_"!"_PrescTypeDefault_"!"_PTUnaveLimitSum_"!"_PrescLimitType
	
	q PrescLimitStr
}

ClassMethod GetPrescTypeByPAADM(PAADMType As %String, BillType As %String, CurLogonHosp As %String = "", langid As %String = "") As %String
{
	i ($g(CurLogonHosp)="")&&($d(%session)) s CurLogonHosp=%session.Get("LOGON.HOSPID")
	i ($g(langid)="")&&($d(%session)) s langid=%session.Get("LOGON.LANGID")
	if langid="" s langid=20
	;根据表名、业务数据中的医院、日期取要取哪个医院的配置
	s DefHospId=##Class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("DHC_PAADMPrescType",CurLogonHosp)
	s n=0
	s ret=""
	if BillType'=""  {
		set rowid=0 for  s rowid=$O(^DHCPAADMPrescType(0,"PAADMType",PAADMType,rowid)) q:rowid=""  d
		.s BillTypeRowid=$p($g(^DHCPAADMPrescType(rowid)),"^",2)
		.s PrescTypeRowid=$p($g(^DHCPAADMPrescType(rowid)),"^",3)
		.s PrescTypeDefault=$p($g(^DHCPAADMPrescType(rowid)),"^",4)
		.s PrescTypeHospDr=$p($g(^DHCPAADMPrescType(rowid)),"^",5)
		.Q:(PrescTypeHospDr'=DefHospId)
		.q:(BillType'="")&(BillType'=+BillTypeRowid) 
		.s rowid=$p(rowid,$C(1),1)
		.q:PrescTypeRowid=""
		.s PrescTypeDesc=$p($g(^DHCPrescriptType(PrescTypeRowid)),"^",2)
		.s PrescTypeDesc=##class(User.DHCPrescriptType).GetTranByDesc("PTDescription",PrescTypeDesc,langid)
		.s PrescTypeDesc=$tr(PrescTypeDesc,"'","")
		.s PrescTypeCode=$p($g(^DHCPrescriptType(PrescTypeRowid)),"^",1)
		.s PrescBillTypeRowid=$p($g(^DHCPrescriptType(PrescTypeRowid)),"^",9)
		.s PrescItemCat=..%GetConfig1("PrescriptItemCat",PrescTypeRowid,CurLogonHosp)
		.s PrescLimitSum=$p($g(^DHCPrescriptType(PrescTypeRowid)),"^",5)
		.s PrescLimitCount=$p($g(^DHCPrescriptType(PrescTypeRowid)),"^",6)
		.s n=n+1
		.s value=PrescTypeRowid_"!"_PrescTypeCode_"!"_PrescTypeDesc_"!"_PrescItemCat_"!"_PrescBillTypeRowid_"!"_PrescLimitSum_"!"_PrescLimitCount_"!"_PrescTypeDefault
		.i n=1 s ret=value
		.e  s ret=ret_"||"_value
	}
	i (n=0) {
		Q:PAADMType="O" ret 
		/*s PrescTypeRowid=0 for  s PrescTypeRowid=$O(^DHCPrescriptType(PrescTypeRowid)) q:PrescTypeRowid=""  d
		.s PrescTypeDesc=$p($g(^DHCPrescriptType(PrescTypeRowid)),"^",2)
		.s PrescTypeCode=$p($g(^DHCPrescriptType(PrescTypeRowid)),"^",1)
		.s PrescBillTypeRowid=$p($g(^DHCPrescriptType(PrescTypeRowid)),"^",9)
		.s PrescTypeHospDr=$p($g(^DHCPrescriptType(PrescTypeRowid)),"^",11)
		.Q:(PrescTypeHospDr'=DefHospId)&&(DefHospId'="")
		.s PrescItemCat=..%GetConfig1("PrescriptItemCat",PrescTypeRowid,CurLogonHosp)
		.s PrescLimitSum=$p($g(^DHCPrescriptType(PrescTypeRowid)),"^",5)
		.s PrescLimitCount=$p($g(^DHCPrescriptType(PrescTypeRowid)),"^",6)
		.s n=n+1
		.s value=PrescTypeRowid_"!"_PrescTypeCode_"!"_PrescTypeDesc_"!"_PrescItemCat_"!"_PrescBillTypeRowid_"!"_PrescLimitSum_"!"_PrescLimitCount
		.i n=1 s ret=value
		.e  s ret=ret_"||"_value*/
		Q ..GetPrescTypeByPAADM("O",BillType,CurLogonHosp)
	}
	q ret
}

ClassMethod GetPrescTypeByPAADMBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", PAADMType As %Library.String = "", BillType As %String = "")
{
	 Set ret=..GetPrescTypeByPAADM(PAADMType,BillType)
	 s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
	 &javascript<#(retval)#>
	 q 1
}

}
