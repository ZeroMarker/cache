Class web.DHCPE.Occu.GBaseInfo Extends %RegisteredObject
{

/// 处理团体职业病信息
/// w ##class(web.DHCPE.Occu.GBaseInfo).UpdateOccuInfo(1,"PreGBI","Set","Y^eret^132^qwre^2^3^10^11^1^21^30^re^tr^ty^tt^^^^^^^^^^^^^^^^^^^^^^",18853)
/// w ##class(web.DHCPE.Occu.GBaseInfo).UpdateOccuInfo(23,"PreGBI","Get","","")
ClassMethod UpdateOccuInfo(Id, BeL, Type, DataString = "", UpdUser = "")
{
	q:((Id="")&&(BeL="")&&(Type="")) ..OutJson("", "")
	q:((BeL="PreGADM")&&('$d(^DHCPEPreGADM(Id)))) ..OutJson("", "")
	q:((BeL="PreGBI")&&('$d(^DHCPEPreGBI(Id)))) ..OutJson("", "")
	
	s jsonData={}
	
	s ret=""
	if BeL="PreGBI" {
		if Type="Set" {
			q:$p(DataString,"^",1)="" ..OutJson("-1", "请选择是否分支机构！")
			q:$p(DataString,"^",2)="" ..OutJson("-1", "分支机构请输入上级单位社会信用代码！")
			q:$p(DataString,"^",3)="" ..OutJson("-1", "请填写统一社会信用代码！")
			q:$p(DataString,"^",4)="" ..OutJson("-1", "请填写注册邮编！")
			q:$p(DataString,"^",5)="" ..OutJson("-1", "请选择所属省！")
			q:$p(DataString,"^",6)="" ..OutJson("-1", "请选择所属市！")
			q:$p(DataString,"^",7)="" ..OutJson("-1", "请选择所属区(县)！")
		 	q:$p(DataString,"^",8)="" ..OutJson("-1", "请选择所属镇(街道)")
			q:$p(DataString,"^",9)="" ..OutJson("-1", "请选择行业类别！")
			q:$p(DataString,"^",10)="" ..OutJson("-1", "请选择经济类型！")
			q:$p(DataString,"^",11)="" ..OutJson("-1", "请选择企业规模！")
			q:$p(DataString,"^",12)="" ..OutJson("-1", "请填写体检联系人！")
			q:$p(DataString,"^",14)="" ..OutJson("-1", "请填写体检联系人电话！")
			q:$p(DataString,"^",15)="" ..OutJson("-1", "请填写注册地址！")
		}
		
		d OptPreGBIData
	}
	q ret
OptPreGBIData
	if Type="Set" {
		s OGBIRowId=$o(^CB.PE.OccuGBaseInfoI("PreGBaseInfoIndex", Id, 0))
		
		/// ^企业名称^是否分支机构^上级单位社会信用代码^社会信用代码^单位注册邮编
		s Text="OGBIPreGBIDR^OGBIName^OGBISubOrgFlag^OGBIUpCreditCode^OGBICreditCode^OGBIPostalCode"
		
		/// 所属省^所属市^所属县区^所属镇 街道
		s Text=Text_"^"_"OGBIProvince^OGBICity^OGBICounty^OGBITown"
		
		/// 行业类别^经济类型^企业规模
		s Text=Text_"^"_"OGBIIndusType^OGBIEconomy^OGBICrptSize"
		
		/// 体检联系人^体检联系人职务^体检联系人电话
		s Text=Text_"^"_"OGBIPELinkMan^OGBIPEPosition^OGBIPELinkTel"
		
		/// 单位注册地址^注册资金
		s Text=Text_"^"_"OGBIAddress^OGBIRegFund"
		
		/// 法人联系电话^法人代表^隶属关系
		s Text=Text_"^"_"OGBICorporationTel^OGBICorporateDeputy^OGBISubjeConn"
		
		/// 建厂日期^经营面积^建档日期
		s Text=Text_"^"_"OGBIBuildDate^OGBIWorkArea^OGBIFilingDate"
		
		/// 检测联系人^检测联系人职务^检测联系人电话
		s Text=Text_"^"_"OGBIChkLinkMan^OGBIChkPosition^OGBIChkLinkTel"
		
		/// 职业卫生安全负责人^职业卫生安全联系人职务^职业卫生安全联系人电话
		s Text=Text_"^"_"OGBISafeLinkMan^OGBISafePosition^OGBISafeLinkTel"
		
		/// 作业场所地址^作业场所邮政编码^职业卫生管理机构
		s Text=Text_"^"_"OGBIEnrolAddress^OGBIEnrolPostalCode^OGBIOccuManaOffice"
		
		/// 职工人数^生产工人数^接触职业病危害因素人数^女职工人数^生产女工人数^接触职业病危害因素女工人数
		s Text=Text_"^"_"OGBIWorkForce^OGBIWorkNum^OGBIExposureEndanges^OGBIFemaleWorkForce^OGBIFemaleWorkNum^OGBIFemaleExpEndanges"
		
		s Value=Id_"^"_$p($g(^DHCPEPreGBI(Id)),"^",2)_"^"_DataString
		s saveRet=##class(User.DHCPEOccuGBaseInfo).SaveData(OGBIRowId,Value,Text)
		i $p(saveRet,"^",1)="-1" {
	        s ret=..OutJson("-1",$p(saveRet,"^",2))
	        q
	    }
	    s ret=..OutJson("0","成功",saveRet)
	} else {
		s OGBIRowId = $o(^CB.PE.OccuGBaseInfoI("PreGBaseInfoIndex", Id, 0))
		s:OGBIRowId="" ret=..OutJson("-1", "未对应团体信息！")
		q:ret'=""
		s OGBIData=$g(^CB.PE.OccuGBaseInfoD(OGBIRowId))
		
		s retJson={}
		s retJson.PreGBIDR=$lg(OGBIData,2),retJson.Name=$lg(OGBIData,3)
		s retJson.CreditCode=$lg(OGBIData,4),retJson.SubOrgFlag=$lg(OGBIData,5),retJson.UpCreditCode=$lg(OGBIData,6)
		s retJson.Province=$lg(OGBIData,7),retJson.City=$lg(OGBIData,8),retJson.County=$lg(OGBIData,9),retJson.Town=$lg(OGBIData,10)
		s retJson.IndusType=$lg(OGBIData,11),retJson.Economy=$lg(OGBIData,12),retJson.CrptSize=$lg(OGBIData,13)
		s retJson.Address=$lg(OGBIData,14),retJson.CorporationTel=$lg(OGBIData,15),retJson.CorporateDeputy=$lg(OGBIData,16),retJson.PostalCode=$lg(OGBIData,17)
		s retJson.WorkArea=$lg(OGBIData,18),retJson.RegFund=$lg(OGBIData,19)
		s retJson.FilingDate=##class(websys.Conversions).DateLogicalToHtml($lg(OGBIData,20))
		s retJson.BuildDate=##class(websys.Conversions).DateLogicalToHtml($lg(OGBIData,21))
		s retJson.SafeLinkMan=$lg(OGBIData,22),retJson.SafePosition=$lg(OGBIData,23),retJson.SafeLinkTel=$lg(OGBIData,24),retJson.ChkLinkMan=$lg(OGBIData,25)
		s retJson.ChkPosition=$lg(OGBIData,26),retJson.ChkLinkTel=$lg(OGBIData,27),retJson.PELinkMan=$lg(OGBIData,28),retJson.PEPosition=$lg(OGBIData,29)
		s retJson.PELinkTel=$lg(OGBIData,30),retJson.SubjeConn=$lg(OGBIData,31),retJson.EnrolAddress=$lg(OGBIData,32),retJson.EnrolPostalCode=$lg(OGBIData,33)
		s retJson.OccuManaOffice=$lg(OGBIData,34),retJson.WorkForce=$lg(OGBIData,35),retJson.FemaleWorkForce=$lg(OGBIData,36),retJson.WorkNum=$lg(OGBIData,37)
		s retJson.FemaleWorkNum=$lg(OGBIData,38),retJson.ExposureEndanges=$lg(OGBIData,39),retJson.FemaleExpEndanges=$lg(OGBIData,40)
		s ret=..OutJson("0","",retJson)
	}
	q
}

ClassMethod OutJson(Code, Msg, Data = "")
{
	s json={}
	s json.code=Code
	s json.msg=Msg
	s json.data=Data
	q json.%ToJSON()
}

}
