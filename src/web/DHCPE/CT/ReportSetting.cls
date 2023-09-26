/// web.DHCPE.CT.ReportSetting
/// create by zhongricheng
/// 报告配置
Class web.DHCPE.CT.ReportSetting Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCPE.CT.ReportSetting","SearchRptSetting","REPORTDATA")
Query SearchRptSetting(BaseId, Code As %String = "", Desc As %String = "", LocID As %String = "", HospID As %String = "") As websys.Query(ROWSPEC = "TId:%String,TCode:%String,TDesc:%String,TTitle:%String,TBaseDesc:%String,TParamType:%String,TParamTypeDesc:%String,TValue:%String,TRemark:%String")
{
}

ClassMethod SearchRptSettingExecute(ByRef qHandle As %Binary, BaseId, Code As %String = "", Desc As %String = "", LocID As %String = "", HospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	if (BaseId="") Quit $$$OK
	s BaseId=$$ALPHAUP^SSUTIL4(BaseId)
	s:LocID="" LocID=%session.Get("LOGON.CTLOCID")
	if (LocID="") Quit $$$OK
	
	s Id=""
	f  s Id=$o(^User.DHCPEReportSettingI("IdxLocBeseDR", " "_LocID, " "_BaseId, Id)) q:Id=""  d
	.s Data=$g(^User.DHCPEReportSettingD(Id))
	.s iCode=$lg(Data,2)
	.q:((Code'="")&&(iCode'=Code))
	.s iDesc=$lg(Data,3)
	.q:((Desc'="")&&(iDesc'[Desc))
	.s iTitle=$lg(Data,4)
	.s iLocID=$lg(Data,5)
	.q:iLocID'=LocID
	.s iBaseDesc=$case(BaseId, "REPORTDATA":"报告数据", :$lg(^User.DHCPEReportSettingD(BaseId),3))
	.s iParamType=$lg(Data,7)  // 参数类型  C 自定义  E 扩展  T 文本
	.s iParamTypeDesc=$case(iParamType, "C":"自定义数据", "E":"扩展", :"文本")
	.s iValue=$lg(Data,8)
	.s iRemark=$lg(Data,9)
	.d TheBaseCode
	
	Quit $$$OK
	
TheBaseCode	
	set Data=$lb(Id,iCode,iDesc,iTitle,iBaseDesc,iParamType,iParamTypeDesc,iValue,iRemark)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// 增加/更新 基础代码
/// w ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","FIXED^固定信息^报告科室等^152^ReportData")
/// w ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","history^病史^既往史、输血史、过敏史等^152^ReportData")
/// w ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","summary^结论建议^^152^BaseInfo")
/// w ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","human^人体图^异常部位、图片、位置维护^152^ReportData")
/// w ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","RptLocDesc^报告科室^^152^1^T^东华医为健康体检中心^")
ClassMethod UpdRptSetting(Id, Strs)
{
    q:Strs="" ..OutJson("-1", "无效数据")
    s Code=$$ALPHAUP^SSUTIL4($p(Strs,"^",1))
    q:Code="" ..OutJson("-1", "编码不能为空")
    s Desc=$$ALPHAUP^SSUTIL4($p(Strs,"^",2))
    q:Desc="" ..OutJson("-1", "描述不能为空")
    s BaseId=$$ALPHAUP^SSUTIL4($p(Strs,"^",5))
    q:BaseId="" ..OutJson("-1", "对照ID不能为空")
    s LocDR=$p(Strs,"^",4)  // 科室
    q:LocDR="" ..OutJson("-1", "未获取到科室信息")
    
    s tem=$o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_LocDR, " "_BaseId, " "_Code, 0))
    q:((Id'="")&&(tem'="")&&(Id'=tem)) ..OutJson("-1","相同代码已存在")
    q:((Id="")&&(""'=tem)) ..OutJson("-1","相同代码已存在")
    
    s Title=$p(Strs,"^",3)  // 提示
    s Type=$p(Strs,"^",6)  // 参数类型
    s Value=$p(Strs,"^",7)  // 参数值
    s Remark=$p(Strs,"^",8)  // 备注
    
    i Id="" {  // 增加
        s obj=##class(User.DHCPEReportSetting).%New()
    } else {
        s obj=##class(User.DHCPEReportSetting).%OpenId(Id)
    }
    
    s obj.RSCode=Code
    s obj.RSDesc=Desc
    s obj.RSTitle=Title
    s obj.RSLocDR=LocDR
    s obj.RSBeseDR=BaseId
    s obj.RSParamType=Type
    s obj.RSValue=Value
    s obj.RSRemark=Remark
    
    // 判断是否为常见的图片地址  图片地址需为 web 包下文件路径
    if ($locate(Value, "(?i:(.jpg|.jpeg|.png|.bmp|.gif))")>0) {
	    s type=$s(($locate(Value, "(?i:(.jpg|.jpeg))")>0):"jpg",
	    		  ($locate(Value, "(?i:(.png))")>0):"png",
	    		  ($locate(Value, "(?i:(.bmp))")>0):"bmp",
	    		  ($locate(Value, "(?i:(.gif))")>0):"gif",
	    		  1:""
	    		 )
    	s stream=..GetBase64File(Value)
		i $IsObject(stream) {
			d stream.Rewind()
    		s obj.RSBase64Img="data:image/"_type_";base64,"_stream.Read(stream.Size)
		}
    }
    
    s sc=obj.%Save()
    d obj.%Close()
    i ($System.Status.IsError(sc)) {
        q ..OutJson("-1",$System.Status.GetErrorText(sc))
    } else {
        q ..OutJson("0",obj.%Id())
    }
}

/// 获取数据
/// w ##class(web.DHCPE.CT.ReportSetting).GetRptSetting(1)
ClassMethod GetRptSetting(Id, RFlag = "")
{
	q:Id="" ..OutJson("-1", "未选择对应行", "", RFlag)
    
    s json={}
    s Data=$g(^User.DHCPEReportSettingD(Id))
	s json.Code=$lg(Data,2)
	s json.Desc=$lg(Data,3)
	s json.Title=$lg(Data,4)
	s json.LocID=$lg(Data,5)
	s json.BaseID=$lg(Data,6)
	s:$lg(Data,6)'="" json.BaseDesc=$case($lg(Data,6), "REPORTDATA":"报告配置数据", :$lg(^User.DHCPEReportSettingD($lg(Data,6)),3))
	s json.ParamType=$lg(Data,7)  // 参数类型  C 自定义  E 扩展  T 文本
	s json.ParamTypeDesc=$case($lg(Data,7), "C":"自定义数据", "E":"扩展", :"文本")
	s json.Value=$lg(Data,8)
	s json.Remark=$lg(Data,9)
	q ..OutJson("0", "成功", json, RFlag)
}

/// 文件转base64
/// w ##class(web.DHCPE.CT.ReportSetting).GetBase64File("images/dhcpe/Human-Blue.png")
ClassMethod GetBase64File(fileAddr)
{
	Set fileAddr = $replace(fileAddr, "\", "/")
	Set path = $p(fileAddr, "/", 1, *-1)_"/"
	Set fileName = $p(fileAddr, "/", *)
	Set path = ##class(ext.util.String).GetPhysicalPath("")_"/"_path
	If (##class(%File).DirectoryExists(path)) {
		Set filePath = path_fileName
		Quit:'##class(%File).Exists(filePath) 0  //"文件不存在"
		
		Set fileStream = ##class(%Stream.FileBinary).%New()
		Set sc = fileStream.LinkToFile(filePath)
		
		Set WSize=12288, RSize=16384  ;写入时要为3的倍数,转Base64时补0才不会出问题. 12288=3*4*1024 12k. 12288转Base64后长度为16384
		Set stream = ##class(%Stream.GlobalCharacter).%New()
		Do fileStream.Rewind()
		While('fileStream.AtEnd){
			Set byteList = fileStream.Read(WSize)
			Set baseStr = ##class(%SYSTEM.Encryption).Base64Encode(byteList, 1)  // 1 不换行
			Do stream.Write(baseStr)
		}
		
	    Do fileStream.%Close()
	    Set fileStream=""
	    Quit stream
	}
	Quit 0
}

/// 初始化数据
/// d ##class(web.DHCPE.CT.ReportSetting).Init()
ClassMethod Init()
{
	k ^User.DHCPEReportSettingI
	k ^User.DHCPEReportSettingD
	d ##class(web.DHCPE.CT.ReportSetting).InitRptSetting("", "")
	d ##class(web.DHCPE.CT.ReportSetting).InitRptSetting("FIXED", "")
	d ##class(web.DHCPE.CT.ReportSetting).InitRptSetting("HUMAN", "")
	d ##class(web.DHCPE.CT.ReportSetting).InitRptSetting("MAN", "")
	d ##class(web.DHCPE.CT.ReportSetting).InitRptSetting("WOMAN", "")
	d ##class(web.DHCPE.CT.ReportSetting).InitRptSetting("ABNPOSITION", "")
	d ##class(web.DHCPE.CT.ReportSetting).InitRptSetting("HEAD", "")
	d ##class(web.DHCPE.CT.ReportSetting).InitRptSetting("OTOR", "")
	d ##class(web.DHCPE.CT.ReportSetting).InitRptSetting("CERV", "")
	d ##class(web.DHCPE.CT.ReportSetting).InitRptSetting("THYR", "")
	d ##class(web.DHCPE.CT.ReportSetting).InitRptSetting("LUCH", "")
	d ##class(web.DHCPE.CT.ReportSetting).InitRptSetting("BREAST", "")
	d ##class(web.DHCPE.CT.ReportSetting).InitRptSetting("MEDICALHIS", "")
	d ##class(web.DHCPE.CT.ReportSetting).InitRptSetting("PASTHISTORY", "")
	d ##class(web.DHCPE.CT.ReportSetting).InitRptSetting("FAMILYHISTORY", "")
	d ##class(web.DHCPE.CT.ReportSetting).InitRptSetting("INFECTIOUSHISTORY", "")
	d ##class(web.DHCPE.CT.ReportSetting).InitRptSetting("SURGICALHISTORY", "")
	d ##class(web.DHCPE.CT.ReportSetting).InitRptSetting("BLOODHISTORY", "")
	d ##class(web.DHCPE.CT.ReportSetting).InitRptSetting("ALLERGICHISTORY", "")
}

ClassMethod InitRptSetting(Code = "", LocID = "")
{
	if (LocID'="") {
		s loc=LocID
		d setRptSetting
	} else {
		s lgcId=0
		f  s lgcId=$o(^CF.PE.LocGrpConfigD(lgcId)) q:lgcId=""  d
		.s active=$lg(^CF.PE.LocGrpConfigD(lgcId),5)
		.q:active'="Y"
		.s loc=$lg(^CF.PE.LocGrpConfigD(lgcId),2)
		.d setRptSetting
	}
	q
setRptSetting
	s Code=$$ALPHAUP^SSUTIL4(Code)
	if Code="" {
		s Code="REPORTDATA"
		d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","FIXED^固定数据^图片地址^"_loc_"^"_Code_"^T")
		d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","HUMAN^人体图配置^图片地址^"_loc_"^"_Code_"^T")
		d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","ABNPOSITION^人体图部位^异常部位、及位置维护^"_loc_"^"_Code_"^E")
		d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","MEDICALHIS^病史^既往病史、家族史、过敏史等^"_loc_"^"_Code_"^E")
	} else {
		if Code="FIXED" {
			s PCode="REPORTDATA"
			s PId = $o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_loc, " "_PCode, " "_Code, 0))
			q:PId=""
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","PELOCTEL^体检中心联系电话^^"     _loc_"^"_PId_"^T^16688888888")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","PELOCURL^体检中心网址^^"   _loc_"^"_PId_"^T^imedical.cn")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","PELOCARR^体检中心地址^^"  _loc_"^"_PId_"^T^东华标准版数字化医院")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","PELOCBUS^体检中心公交路线^^"_loc_"^"_PId_"^T^666路、888路")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","LOCDESC^体检中心科室名称^^"_loc_"^"_PId_"^T^健康管理中心")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","HOSPDESC^医院名称^^"   _loc_"^"_PId_"^T^东华标准版数字化医院")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","HOSPLOGO^医院LOGO^^"   _loc_"^"_PId_"^T^images/dhcpe/LOGO_标志与中英文全称左右组合.png")
		} elseif Code="HUMAN" {
			s PCode="REPORTDATA"
			s PId = $o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_loc, " "_PCode, " "_Code, 0))
			q:PId=""
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","MAN^人体图男^^"     _loc_"^"_PId_"^E^images/dhcpe/Human-man.jpg")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","WOMAN^人体图女^^"   _loc_"^"_PId_"^E^images/dhcpe/Human-woman.jpg")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","BLUE^蓝^保健提醒^"  _loc_"^"_PId_"^T^images/dhcpe/Human-Blue.png^标示其他需要保健提醒的。")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","YELLOW^黄^复查随访^"_loc_"^"_PId_"^T^images/dhcpe/Human-Yellow.png^标示一般关注需要复查随访的。")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","ORANGE^橙^就诊处理^"_loc_"^"_PId_"^T^images/dhcpe/Human-Orange.png^标示重点关注需要近期就诊处理的。")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","RED^红^紧急处理^"   _loc_"^"_PId_"^T^images/dhcpe/Human-Red.png^标示紧急或马上需要处理的。")
		} elseif Code="MAN" {
			s QCode="REPORTDATA"
			s PCode="HUMAN"
			s QId = $o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_loc, " "_QCode, " "_PCode, 0))
			q:QId=""
			s PId = $o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_loc, " "_QId, " "_Code, 0))
			q:PId=""
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","HEAD^头颅^对应异常细项^"              _loc_"^"_PId_"^T^"_"12.950mm-41.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","OTOR^口鼻咽喉^对应异常细项^"          _loc_"^"_PId_"^T^"_"22.953mm-41.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","CERV^颈椎^对应异常细项^"              _loc_"^"_PId_"^T^"_"32.957mm-41.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","THYR^甲状腺颈部^对应异常细项^"        _loc_"^"_PId_"^T^"_"42.960mm-41.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","LUCH^肺/胸部^对应异常细项^"           _loc_"^"_PId_"^T^"_"52.963mm-41.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","THOR^胸椎^对应异常细项^"              _loc_"^"_PId_"^T^"_"62.967mm-41.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","LIVER^肝脏^对应异常细项^"             _loc_"^"_PId_"^T^"_"72.970mm-41.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","GALL^胆囊^对应异常细项^"              _loc_"^"_PId_"^T^"_"82.973mm-41.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","PANCREAS^胰腺^对应异常细项^"          _loc_"^"_PId_"^T^"_"92.977mm-41.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","LUMBAR^腰椎^对应异常细项^"            _loc_"^"_PId_"^T^"_"102.980mm-41.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","HIPFEM^髋关节/股骨颈^对应异常细项^"   _loc_"^"_PId_"^T^"_"112.983mm-41.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","KNEE^膝关节^对应异常细项^"            _loc_"^"_PId_"^T^"_"122.987mm-41.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","FOOT^踝关节/足^对应异常细项^"         _loc_"^"_PId_"^T^"_"132.990mm-41.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","SKIN^皮肤/皮下^对应异常细项^"         _loc_"^"_PId_"^T^"_"142.993mm-41.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","INTERNAL^内科^对应异常细项^"          _loc_"^"_PId_"^T^"_"152.997mm-41.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","FUNCTIONAL^功能医学^对应异常细项^"    _loc_"^"_PId_"^T^"_"163.000mm-41.25mm")
			
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","EYE^眼睛^对应异常细项^"               _loc_"^"_PId_"^T^"_"12.950mm-144.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","ORAL^口腔^对应异常细项^"              _loc_"^"_PId_"^T^"_"22.953mm-144.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","CARO^颈动脉^对应异常细项^"            _loc_"^"_PId_"^T^"_"32.957mm-144.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","HEART^心脏^对应异常细项^"             _loc_"^"_PId_"^T^"_"42.960mm-144.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","ESOPHAGUS^食管^对应异常细项^"         _loc_"^"_PId_"^T^"_"52.963mm-144.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","STOMACH^胃^对应异常细项^"             _loc_"^"_PId_"^T^"_"62.967mm-144.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","SPLEEN^脾^对应异常细项^"              _loc_"^"_PId_"^T^"_"72.970mm-144.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","COLORECTAL^结直肠^对应异常细项^"      _loc_"^"_PId_"^T^"_"82.973mm-144.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","KIDNEY^肾脏^对应异常细项^"            _loc_"^"_PId_"^T^"_"92.977mm-144.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","BLADDER^膀胱输尿管^对应异常细项^"     _loc_"^"_PId_"^T^"_"102.980mm-144.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","SCROTUM^阴囊睾丸^对应异常细项^"       _loc_"^"_PId_"^T^"_"112.983mm-144.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","PROSTATE^前列腺^对应异常细项^"        _loc_"^"_PId_"^T^"_"122.987mm-144.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","LIMBSBLOOD^下肢血管^对应异常细项^"    _loc_"^"_PId_"^T^"_"132.990mm-144.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","BLOODTESTING^血检^对应异常细项^"      _loc_"^"_PId_"^T^"_"142.993mm-144.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","TUMORMARKERS^肿瘤标记物^对应异常细项^"_loc_"^"_PId_"^T^"_"152.997mm-144.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","GENETESTING^基因检测^对应异常细项^"   _loc_"^"_PId_"^T^"_"163.000mm-144.25mm")
		} elseif Code="WOMAN" {
			s QCode="REPORTDATA"
			s PCode="HUMAN"
			s QId = $o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_loc, " "_QCode, " "_PCode, 0))
			q:QId=""
			s PId = $o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_loc, " "_QId, " "_Code, 0))
			q:PId=""
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","HEAD^头颅^对应异常细项^"              _loc_"^"_PId_"^T^"_"12.950mm-41.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","OTOR^口鼻咽喉^对应异常细项^"          _loc_"^"_PId_"^T^"_"22.956mm-41.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","CERV^颈椎^对应异常细项^"              _loc_"^"_PId_"^T^"_"32.963mm-41.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","THYR^甲状腺颈部^对应异常细项^"        _loc_"^"_PId_"^T^"_"42.969mm-41.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","LUCH^肺/胸部^对应异常细项^"           _loc_"^"_PId_"^T^"_"52.975mm-41.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","BREAST^乳腺^对应异常细项^"            _loc_"^"_PId_"^T^"_"62.981mm-41.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","THOR^胸椎^对应异常细项^"              _loc_"^"_PId_"^T^"_"72.988mm-41.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","LIVER^肝脏^对应异常细项^"             _loc_"^"_PId_"^T^"_"82.994mm-41.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","GALL^胆囊^对应异常细项^"              _loc_"^"_PId_"^T^"_"93.000mm-41.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","PANCREAS^胰腺^对应异常细项^"          _loc_"^"_PId_"^T^"_"103.006mm-41.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","LUMBAR^腰椎^对应异常细项^"            _loc_"^"_PId_"^T^"_"113.013mm-41.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","HIPFEM^髋关节/股骨颈^对应异常细项^"   _loc_"^"_PId_"^T^"_"123.019mm-41.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","KNEE^膝关节^对应异常细项^"            _loc_"^"_PId_"^T^"_"133.025mm-41.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","FOOT^踝关节/足^对应异常细项^"         _loc_"^"_PId_"^T^"_"143.031mm-41.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","SKIN^皮肤/皮下^对应异常细项^"         _loc_"^"_PId_"^T^"_"153.038mm-41.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","INTERNAL^内科^对应异常细项^"          _loc_"^"_PId_"^T^"_"163.044mm-41.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","FUNCTIONAL^功能医学^对应异常细项^"    _loc_"^"_PId_"^T^"_"173.050mm-41.25mm")
			
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","EYE^眼睛^对应异常细项^"               _loc_"^"_PId_"^T^"_"12.950mm-144.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","ORAL^口腔^对应异常细项^"              _loc_"^"_PId_"^T^"_"22.956mm-144.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","CARO^颈动脉^对应异常细项^"            _loc_"^"_PId_"^T^"_"32.963mm-144.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","HEART^心脏^对应异常细项^"             _loc_"^"_PId_"^T^"_"42.969mm-144.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","ESOPHAGUS^食管^对应异常细项^"         _loc_"^"_PId_"^T^"_"52.975mm-144.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","STOMACH^胃^对应异常细项^"             _loc_"^"_PId_"^T^"_"62.981mm-144.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","SPLEEN^脾^对应异常细项^"              _loc_"^"_PId_"^T^"_"72.988mm-144.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","COLORECTAL^结直肠^对应异常细项^"      _loc_"^"_PId_"^T^"_"82.994mm-144.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","KIDNEY^肾脏^对应异常细项^"            _loc_"^"_PId_"^T^"_"93.000mm-144.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","BLADDER^膀胱输尿管^对应异常细项^"     _loc_"^"_PId_"^T^"_"103.006mm-144.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","GYNAECOLOGY^妇科^对应异常细项^"       _loc_"^"_PId_"^T^"_"113.013mm-144.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","CERVIX^宫颈^对应异常细项^"            _loc_"^"_PId_"^T^"_"123.019mm-144.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","LIMBSBLOOD^下肢血管^对应异常细项^"    _loc_"^"_PId_"^T^"_"133.025mm-144.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","BLOODTESTING^血检^对应异常细项^"      _loc_"^"_PId_"^T^"_"143.031mm-144.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","TUMORMARKERS^肿瘤标记物^对应异常细项^"_loc_"^"_PId_"^T^"_"153.038mm-144.25mm")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","GENETESTING^基因检测^对应异常细项^"   _loc_"^"_PId_"^T^"_"163.044mm-144.25mm")
		} elseif Code="ABNPOSITION" {
			s PCode="REPORTDATA"
			s PId = $o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_loc, " "_PCode, " "_Code, 0))
			q:PId=""
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","HEAD^头颅^对应异常细项^"              _loc_"^"_PId_"^E^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","OTOR^口鼻咽喉^对应异常细项^"          _loc_"^"_PId_"^E^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","CERV^颈椎^对应异常细项^"              _loc_"^"_PId_"^E^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","THYR^甲状腺颈部^对应异常细项^"        _loc_"^"_PId_"^E^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","LUCH^肺/胸部^对应异常细项^"           _loc_"^"_PId_"^E^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","BREAST^乳腺^对应异常细项^"            _loc_"^"_PId_"^E^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","THOR^胸椎^对应异常细项^"              _loc_"^"_PId_"^E^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","LIVER^肝脏^对应异常细项^"             _loc_"^"_PId_"^E^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","GALL^胆囊^对应异常细项^"              _loc_"^"_PId_"^E^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","PANCREAS^胰腺^对应异常细项^"          _loc_"^"_PId_"^E^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","LUMBAR^腰椎^对应异常细项^"            _loc_"^"_PId_"^E^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","HIPFEM^髋关节/股骨颈^对应异常细项^"   _loc_"^"_PId_"^E^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","KNEE^膝关节^对应异常细项^"            _loc_"^"_PId_"^E^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","FOOT^踝关节/足^对应异常细项^"         _loc_"^"_PId_"^E^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","SKIN^皮肤/皮下^对应异常细项^"         _loc_"^"_PId_"^E^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","INTERNAL^内科^对应异常细项^"          _loc_"^"_PId_"^E^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","FUNCTIONAL^功能医学^对应异常细项^"    _loc_"^"_PId_"^E^"_"")
			
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","EYE^眼睛^对应异常细项^"               _loc_"^"_PId_"^E^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","ORAL^口腔^对应异常细项^"              _loc_"^"_PId_"^E^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","CARO^颈动脉^对应异常细项^"            _loc_"^"_PId_"^E^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","HEART^心脏^对应异常细项^"             _loc_"^"_PId_"^E^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","ESOPHAGUS^食管^对应异常细项^"         _loc_"^"_PId_"^E^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","STOMACH^胃^对应异常细项^"             _loc_"^"_PId_"^E^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","SPLEEN^脾^对应异常细项^"              _loc_"^"_PId_"^E^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","COLORECTAL^结直肠^对应异常细项^"      _loc_"^"_PId_"^E^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","KIDNEY^肾脏^对应异常细项^"            _loc_"^"_PId_"^E^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","BLADDER^膀胱输尿管^对应异常细项^"     _loc_"^"_PId_"^E^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","SCROTUM^阴囊睾丸^对应异常细项^"       _loc_"^"_PId_"^E^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","PROSTATE^前列腺^对应异常细项^"        _loc_"^"_PId_"^E^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","GYNAECOLOGY^妇科^对应异常细项^"       _loc_"^"_PId_"^E^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","CERVIX^宫颈^对应异常细项^"            _loc_"^"_PId_"^E^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","LIMBSBLOOD^下肢血管^对应异常细项^"    _loc_"^"_PId_"^E^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","BLOODTESTING^血检^对应异常细项^"      _loc_"^"_PId_"^E^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","TUMORMARKERS^肿瘤标记物^对应异常细项^"_loc_"^"_PId_"^E^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","GENETESTING^基因检测^对应异常细项^"   _loc_"^"_PId_"^E^"_"")
		} elseif Code="HEAD" {
			s QCode="REPORTDATA"
			s PCode="ABNPOSITION"
			s QId = $o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_loc, " "_QCode, " "_PCode, 0))
			q:QId=""
			s PId = $o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_loc, " "_QId, " "_Code, 0))
			q:PId=""
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","PE103020^头颅^^"_loc_"^"_PId_"^T^"_"")
		} elseif Code="OTOR" {
			s QCode="REPORTDATA"
			s PCode="ABNPOSITION"
			s QId = $o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_loc, " "_QCode, " "_PCode, 0))
			q:QId=""
			s PId = $o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_loc, " "_QId, " "_Code, 0))
			q:PId=""
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","PE105003^耳^^"_loc_"^"_PId_"^T^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","PE105004^鼻及鼻窦^^"_loc_"^"_PId_"^T^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","PE105005^咽^^"_loc_"^"_PId_"^T^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","PE105007^喉^^"_loc_"^"_PId_"^T^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","PE105008^鼻咽部^^"_loc_"^"_PId_"^T^"_"")
		} elseif Code="CERV" {
			s QCode="REPORTDATA"
			s PCode="ABNPOSITION"
			s QId = $o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_loc, " "_QCode, " "_PCode, 0))
			q:QId=""
			s PId = $o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_loc, " "_QId, " "_Code, 0))
			q:PId=""
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","PE103023^脊柱^^"_loc_"^"_PId_"^T^"_"")
		} elseif Code="THYR" {
			s QCode="REPORTDATA"
			s PCode="ABNPOSITION"
			s QId = $o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_loc, " "_QCode, " "_PCode, 0))
			q:QId=""
			s PId = $o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_loc, " "_QId, " "_Code, 0))
			q:PId=""
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","PE103005^甲状腺^^"_loc_"^"_PId_"^T^"_"")
		} elseif Code="LUCH" {
			s QCode="REPORTDATA"
			s PCode="ABNPOSITION"
			s QId = $o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_loc, " "_QCode, " "_PCode, 0))
			q:QId=""
			s PId = $o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_loc, " "_QId, " "_Code, 0))
			q:PId=""
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","PE102039^胸廓^^"_loc_"^"_PId_"^T^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","PE102040^肺部^^"_loc_"^"_PId_"^T^"_"")
		} elseif Code="BREAST" {
			s QCode="REPORTDATA"
			s PCode="ABNPOSITION"
			s QId = $o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_loc, " "_QCode, " "_PCode, 0))
			q:QId=""
			s PId = $o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_loc, " "_QId, " "_Code, 0))
			q:PId=""
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","PE103006^乳腺^^"_loc_"^"_PId_"^T^"_"")
		} elseif Code="MEDICALHIS" {
			s PCode="REPORTDATA"
			s PId = $o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_loc, " "_PCode, " "_Code, 0))
			q:PId=""
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","PASTHISTORY^既往病史^^"											_loc_"^"_PId_"^E^")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","FAMILYHISTORY^家族史^您的父母、兄弟、姐妹或子女是否患有疾病^"	_loc_"^"_PId_"^E^")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","INFECTIOUSHISTORY^传染病史^^"									_loc_"^"_PId_"^E^")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","SURGICALHISTORY^手术史^^"										_loc_"^"_PId_"^E^")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","BLOODHISTORY^输血史^^"											_loc_"^"_PId_"^E^")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","ALLERGICHISTORY^过敏史^药物、食物、其他等^"						_loc_"^"_PId_"^E^")
		} elseif Code="PASTHISTORY" {
			s QCode="REPORTDATA"
			s PCode="MEDICALHIS"
			s QId = $o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_loc, " "_QCode, " "_PCode, 0))
			q:QId=""
			s PId = $o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_loc, " "_QId, " "_Code, 0))
			q:PId=""
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","PE102001^既往史(内)^^"_loc_"^"_PId_"^T^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","PE104001^既往史(眼科)^^"_loc_"^"_PId_"^T^"_"")
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","PE105001^既往史(耳鼻喉)^^"_loc_"^"_PId_"^T^"_"")
		} elseif Code="FAMILYHISTORY" {
			s QCode="REPORTDATA"
			s PCode="MEDICALHIS"
			s QId = $o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_loc, " "_QCode, " "_PCode, 0))
			q:QId=""
			s PId = $o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_loc, " "_QId, " "_Code, 0))
			q:PId=""
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","PE102004^家族史^^"_loc_"^"_PId_"^T^"_"")
		} elseif Code="INFECTIOUSHISTORY" {
			s QCode="REPORTDATA"
			s PCode="MEDICALHIS"
			s QId = $o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_loc, " "_QCode, " "_PCode, 0))
			q:QId=""
			s PId = $o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_loc, " "_QId, " "_Code, 0))
			q:PId=""
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","PE102005^传染病史^^"_loc_"^"_PId_"^T^"_"")
		} elseif Code="SURGICALHISTORY" {
			s QCode="REPORTDATA"
			s PCode="MEDICALHIS"
			s QId = $o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_loc, " "_QCode, " "_PCode, 0))
			q:QId=""
			s PId = $o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_loc, " "_QId, " "_Code, 0))
			q:PId=""
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","PE103001^手术史(外)^^"_loc_"^"_PId_"^T^"_"")
		} elseif Code="BLOODHISTORY" {
			s QCode="REPORTDATA"
			s PCode="MEDICALHIS"
			s QId = $o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_loc, " "_QCode, " "_PCode, 0))
			q:QId=""
			s PId = $o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_loc, " "_QId, " "_Code, 0))
			q:PId=""
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","PE102009^输血史^^"_loc_"^"_PId_"^T^"_"")
		} elseif Code="ALLERGICHISTORY" {
			s QCode="REPORTDATA"
			s PCode="MEDICALHIS"
			s QId = $o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_loc, " "_QCode, " "_PCode, 0))
			q:QId=""
			s PId = $o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_loc, " "_QId, " "_Code, 0))
			q:PId=""
			d ##class(web.DHCPE.CT.ReportSetting).UpdRptSetting("","PE102010^食物、药物过敏史^^"_loc_"^"_PId_"^T^"_"")
		}
	}
	q
}

/// 按 代码 和 科室 批量更新值
/// 行数  上下行的上边距  左右列的左边距
/// d ##class(web.DHCPE.CT.ReportSetting).BathUpdPosition("WOMAN",152)
ClassMethod BathUpdPosition(Code, Loc)
{
	s row=17  // 行数
	s min=12.95, max=173.05  //, max=163
	s left=41.25, right=144.25
	
	s Diff=0
	s:row>1 Diff=(max-min)/(row-1)
	
	s QCode="REPORTDATA"
	s PCode="HUMAN"
	s QId = $o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_Loc, " "_QCode, " "_PCode, 0))
	q:QId=""
	s PId = $o(^User.DHCPEReportSettingI("IdxLocBeseDRCode", " "_Loc, " "_QId, " "_Code, 0))
	q:PId=""
	s Id=0,num=0
	f  s Id=$o(^User.DHCPEReportSettingI("IdxLocBeseDR", " "_Loc, " "_PId, Id)) q:Id=""  d
	.s iTop=$fn($s(num<row:(min+(Diff*num)), 1:(min+(Diff*(num-row)))),"N",3)_"mm"
	.s iLeft=$s(num<row:left, 1:right)_"mm"
	.s data=iTop_"-"_iLeft
	.;w data,!
	.s newList=$lu(^User.DHCPEReportSettingD(Id),8,1:data)
	.s ^User.DHCPEReportSettingD(Id)=newList
	.s num=num+1
}

ClassMethod OutJson(Code, Msg, Data = "", RFlag = "")
{
	s json={}
	s json.code=Code
	s json.msg=Msg
	s json.data=Data
	q:RFlag="Obj" json
	q json.%ToJSON()
}

}
