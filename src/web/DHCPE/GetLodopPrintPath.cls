/// 得到lodop打印的url地址
Class web.DHCPE.GetLodopPrintPath Extends %RegisteredObject
{

/// 得到报告打印的url地址，页眉，页脚信息
/// w ##Class(web.DHCPE.GetLodopPrintPath).GetReportPrintInfo("2980","PAADM","JKTJ")
/// w ##Class(web.DHCPE.GetLodopPrintPath).GetReportPrintInfo("2980","PAADM","YGBG")
ClassMethod GetReportPrintInfo(ID, Type, PrintType = "", StrEx = "")
{
    q:((ID="")||(Type="")) ""
	s PAADM=""
	if (Type="PAADM") {
		s PAADM=ID
	} elseif (Type="IADM") {
		s PAADM=$p($g(^DHCPEIADM(ID)),"^",1)
	} elseif (Type="REPORT") {
		s IADM=$o(^DHCPERPT(0,"IADM",ID,0))
		s:IADM'="" PAADM=$p($g(^DHCPEIADM(IADM)),"^",1)
	}
	q:PAADM="" ""
	
	s IADM=$o(^DHCPEIADM(0,"PAADM",PAADM,0))
    s LocID=$P($g(^PAADM(+PAADM)),"^",4)
    s ReportUrl="",Header="", Footer="",RPName=""
    s PrintReportType = $g(^DHCPESetting("DHCPE","PrintReportType",LocID))
    if (PrintReportType = "PDF") {
        s PDFFileName = ##class(web.DHCPE.ReportExportPDF).GetReportPath(PAADM)
        i PDFFileName'="" {
            s ReportFtp=$G(^DHCPESetting("DHCPE","ReportFTP"))   ;FTPIP^FTPUser^FTPPassWord^FTPPort
            s ServerIP=$P(ReportFtp,"^",1)
            s User=$P(ReportFtp,"^",2)
            s PassWord=$P(ReportFtp,"^",3)
            s Port=$P(ReportFtp,"^",4)
            //ftp://dhcgw:abc@123GW@10.1.5.79:21/report/J3739864.PDF
            s Url="ftp://"_User_":"_PassWord_"@"_ServerIP_":"_Port_"/"_PDFFileName
        }else{
            s Url=""
        }
        q Url_"^"_Header_"^"_Footer_"^"_RPName_"^"_"PDF"
    }
    
    s PAPMIdr=$p($g(^PAADM(PAADM)),"^",1)
    s PAPERName=$p($g(^PAPER(PAPMIdr,"ALL")),"^",1)  // 姓名
    s PAPERNo=$p($g(^PAPER(PAPMIdr,"PAT",1)),"^",1)  // 登记号
    s PAPERSex=$p($g(^PAPER(PAPMIdr,"ALL")),"^",7)
    i PAPERSex'="" s PAPERSex=$p($g(^CT("SEX",PAPERSex)),"^",2) // 性别
	s:PrintType="undefined" PrintType=""
	
	s other=##class(%Library.DynamicObject).%New()
	s OthCodes="FIXED"
	f tem=1:1:$l(OthCodes,"^") d
	.s OthCode=$p(OthCodes,"^",tem)
	.q:OthCode=""
	.s BaseDr=$o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_LocID, " REPORTDATA", " "_OthCode, 0))
	.s RSRowId=0
	.f  s RSRowId=$o(^User.DHCPEReportSettingI("IdxLocBeseDR", " "_LocID, " "_BaseDr, RSRowId)) q:RSRowId=""  d
	..s RSCode=$lg(^User.DHCPEReportSettingD(RSRowId),2)
	..s RSValue=$lg(^User.DHCPEReportSettingD(RSRowId),8)
	..if ($locate(RSValue, "(?i:(.jpg|.jpeg|.png|.bmp|.gif))")>0) d
    ...s RSValue=$lg(^User.DHCPEReportSettingD(RSRowId),10)
	..d other.%Set(RSCode, RSValue)
    
    if (PrintType="YGBG") {
        s ReportUrl="dhcpe/dhcpeireport.ygreport.csp"_"?ID="_PAADM_"&Type=PAADM"
        s RPName="乙肝报告"
    } elseif (PrintType="DBBG") {
	    s ReportUrl="dhcpeireport.constrast.csp"_"?PatientID="_PAADM
	    s RPName="对比报告"
    } elseif (PrintType="FCBG") {
	    s ReportUrl="dhcpe/dhcpeireport.zyjkfc.csp"_"?ID="_PAADM_"&Type=PAADM"
	    s RPName="复查报告"
        } elseif (PrintType="ZYJK") {
	    s ReportUrl="dhcpe/zyjktj/dhcpeireport.zyjk.main.csp"_"?ID="_PAADM_"&Type=PAADM"_"&PageList="
	    s RPName="职业健康"
    } elseif IADM'="" {
    	s PreIADM=$p($g(^DHCPEIADM(IADM)),"^",4)
    	s VIPLevel=$p($g(^DHCPEPreIADM(PreIADM)),"^",18)
    	;s ReportUrl=$p($g(^DHCPEVIPLevel("VIP",VIPLevel)),"^",6)
    	s LocVIPID=$o(^CF.PE.LocVIPLevelI("IdxOfLocVIP"," "_LocID,VIPLevel,""))
    	i LocVIPID'="" {
	    	s ReportUrl=$lg($g(^CF.PE.LocVIPLevelD(LocVIPID)),6) // 模板名称（科室VIP等级）
	    	s:PrintType="" PrintType=$lg($g(^CF.PE.LocVIPLevelD(LocVIPID)),14) // 总检类型
    	}
    }
	if PrintType="ZYJK" {
		s HeadTitle="职业健康体检报告"
	} else {
		s HeadTitle="健康体检报告"
	}
    s Header="<div style='height:10mm;line-height:10mm;font-size:11pt;'><img src='"_other.HOSPLOGO_"' style='height:8mm;'><span style='float:right;'><b>"_HeadTitle_"</b></span></div>"
    s Footer="<span style='font-size:11pt;'>姓名："_PAPERName_"&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;性别："_PAPERSex_"&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;健康档案号："_PAPERNo_"</span>"
    
    if ReportUrl'="" {
        s Url=..GetServerPath()_ReportUrl
    } else {
		if PrintType="ZYJK" {
			s Url=..GetServerPath()_"dhcpe/zyjktj/dhcpeireport.zyjk.main.csp"_"?ID="_ID_"&Type="_Type_"&PageList="
		} else{
			s Url=..GetServerPath()_"dhcpe/dhcpeireport.main.csp"_"?ID="_ID_"&Type="_Type_"&PageList="
		}
    }
    q Url_"^"_Header_"^"_Footer_"^"_RPName_"^"_PrintType
}

/// 得到导检单打印的url地址
ClassMethod GetDJDPrintInfo(PAADM, Type, HospID As %String = "", UserID As %String = "")
{
    s PrintAllFlag=$P(PAADM,"^",3)
    i Type="Body" s PAADM=$P(PAADM,"^",1)
    
    s CSPName="dhcpedjdtemplate.csp"
    s:Type="Header" CSPName="dhcpedjdtemplate.header.csp"
    s Url=..GetServerPath()_CSPName_"?PAADM="_PAADM_"&HospID="_HospID_"&UserID="_UserID_"&PrintAllFlag="_PrintAllFlag
    q Url
}

/// 得到导检单打印的url地址
ClassMethod GetDJDData(ID, Type, UserID As %String = "", LocID As %String = "", HospID As %String = "", ExStrs As %String = "")
{
	s locVipLevel=""
	if ("LocVIPLevel"=Type) {
		s locVipLevel=ID
		s PAADM="Temporary"
	} elseif ("PAADM"=Type) {
		s iadm=$o(^DHCPEIADM(0,"PAADM",ID,0))
    	q:iadm="" ""
		s PAADM=ID
    	s preIADM=$p($g(^DHCPEIADM(iadm)),"^",4)
    	s vipLevel=$p($g(^DHCPEPreIADM(preIADM)),"^",18)
    	s locVipLevel=$o(^CF.PE.LocVIPLevelI("IdxOfLocVIP"," "_LocID,vipLevel,0))
	}
	q:locVipLevel="" ""
	
	s Template=$lg($g(^CF.PE.LocVIPLevelD(locVipLevel)),11)
    s:Template="undefined" Template=""
	if (Template'="") {
		s HT=$p(Template,"$",1)
		s BT=$p(Template,"$",2)
		s FT=$p(Template,"$",3)
	} else {
		s HT="H-General"
		s BT="B-Formatter1"
		s FT="F-NoFooter"
	}
	
	s ShowPart=HT_"^"_BT_"^"_FT
	s djdUrl="dhcpe.ct.djdtemplate.temporary.csp?PAADM="_PAADM_"&Part="_ShowPart_"&ExStrs="_ExStrs_"&HospID="_HospID
	
	q djdUrl
}

ClassMethod GetServerPath()
{
    s ServerPath=##class(ext.util.String).GetCacheURL()
    s ServerPath=$P(ServerPath,"web/csp/",1)
    s ServerPath=ServerPath_"web/csp/"
    q ServerPath
}

/// 得到退费申请单打印的url地址
ClassMethod GetTFDPrintInfo(invPrtId, Type)
{
    s CSPName="dhcpetfdtemplate.csp"
    s:Type="Header" CSPName="dhcpetfdtemplate.header.csp"
    s Url=..GetServerPath()_CSPName_"?invPrtId="_invPrtId
    q Url
}

}
