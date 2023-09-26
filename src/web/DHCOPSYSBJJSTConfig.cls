Import SQLUser

Class web.DHCOPSYSBJJSTConfig Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 15;

ClassMethod EditOPBaseConfig() As %String
{
	;北京积水潭医院配置
	;w ##class(web.DHCOPSYSBJJSTConfig).EditOPBaseConfig()
	;PLIST(2)	OPFC_WebConDR
	;PLIST(3)	OPFC_SiteCode
	;PLIST(4)	OPFC_ItemFlag
	;PLIST(5)	OPFC_ReclocFlag
	;PLIST(6)	OPFC_PresNoFlag
	;PLIST(7)	OPFC_RecInvCount
	;PLIST(8)	OPFC_PrintCount
	;PLIST(9)	OPFC_HerbalFlag
	;PLIST(10)	OPFC_HerbalDesc
	;PLIST(11)	OPFC_HerbalNum
	;PLIST(12)	
	;PLIST(13)
	;PLIST(14)
	;PLIST(15)	OPFC_AppFlag
	;PLIST(16)
	
	;q "Edit"

	k PLIST
	s rtn=##class(web.DHCSOPFConfig).SELECT(1)
	;&sql(select * into PLIST() from DHC_SOPFConfig)
	;b	;
	s RowId=""
	s PLIST(2)=1						;OPFC_WebConDR
	s PLIST(3)="北京积水潭医院门诊"		;OPFC_SiteCode
	s PLIST(4)=1						;OPFC_ItemFlag
	s PLIST(5)=1						;OPFC_ReclocFlag
	s PLIST(6)=1						;OPFC_PresNoFlag
	s PLIST(7)=0						;OPFC_RecInvCount
	;原来发票打印32条记录
	s PLIST(8)=0						;OPFC_PrintCount
	s PLIST(9)=0						;OPFC_HerbalFlag
	s PLIST(10)="中草药收费"			;OPFC_HerbalDesc
	s PLIST(11)=1						;OPFC_HerbalNum
	;;产品的版本信息
	;;0   北京积水潭医院   32条记录
	;;1   合肥省立医院		;设定20条记录   按照ADM分票  退费财务不办理审批
	;;3   山西大同医院		;
	;;4		宁波明州医院	;设定23条记录
	;;5		西安交大眼科医院	只打印
	s PLIST(12)=0						;OPFC_Version
	;不连接医保程序=0   连接医保程序=1  
	;适用范围账户结算时，连接医保配置
	s PLIST(13)=0						;OPFC_YBConFlag
	;为医保考虑是否加入：根据Adm进行分票的标志
	;OPFC_AdmFlag=0表示不按照Adm分票
	;OPFC_AdmFlag=1表示按照Adm分票
	s PLIST(14)=0						;OPFC_AdmFlag
	;门诊票据退费审核标志
	;0  需要审批，不审批不能办理退费审批到DHC_INVPRT
	;1  不需要审批，不需要审批能办理退费
	;2  需要审批同时要求审批到医嘱项，如果不选医嘱项，不让审批
	s PLIST(15)=0						;OPFC_AppFlag
	;不连接医保程序=0   连接医保程序=1
	;适用范围：现金支付连接医保
	s PLIST(16)=0						;OPFC_PRTYBConFlag
	;舍入参数设置
	;=0  或=""   表示不舍入
	;>0   表示舍入
	s PLIST(17)=0						;OPFC_RoundDownNum
	
	;b
	i rtn=0 {
		s RowId=PLIST(1)
		s rtn=##class(web.DHCSOPFConfig).UPDATE(RowId)
		;&sql(UPDATE DHC_SOPFConfig VALUES PLIST() WHERE OPFC_RowID= :RowId)
	}else{
		s rtn=##class(web.DHCSOPFConfig).INSERT()
		&sql(INSERT INTO DHC_SOPFConfig Values PLIST())
	}
	
	q SQLCODE
}

ClassMethod OPGroupSet() As %String
{
	;w ##class(web.DHCOPSYSBJJSTConfig).OPGroupSet()
	;急诊安全组对应的参数配置
	&sql(update DHC_OPGroupSettings set  GS_PRTParaFlag=null, GS_ItemFlag=null, GS_RecDepFlag=null, GS_RecInvCount=null, GS_PrintCount=null  where GS_RowID=26)
	
	;门诊收费
	&sql(update DHC_OPGroupSettings set  GS_PRTParaFlag="G", GS_ItemFlag=1, GS_RecDepFlag=1, GS_RecInvCount=0, GS_PrintCount=32  where GS_RowID=1)
	;Demo Group
	&sql(update DHC_OPGroupSettings set  GS_PRTParaFlag="G", GS_ItemFlag=1, GS_RecDepFlag=1, GS_RecInvCount=0, GS_PrintCount=32  where GS_RowID=2)
	;门诊收费组长
	&sql(update DHC_OPGroupSettings set  GS_PRTParaFlag="G", GS_ItemFlag=1, GS_RecDepFlag=1, GS_RecInvCount=0, GS_PrintCount=32  where GS_RowID=3)
	
	q 0
}

}
