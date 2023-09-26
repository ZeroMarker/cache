/// 名称：DHCMed.EPD.ImportReport
/// 描述：传染病导入历史报告数据
/// 编写者：luotiantian
/// 编写日期：2020-01-04
Class DHCMed.EPD.ImportReport Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 报告ID
Property ReportID As %String;

/// 报告编号
Property RepCardNo As %String;

/// 登记号
Property RegNo As %String;

/// 患者姓名
Property EPDName As %String;

/// 出生日期
Property Birthday As %Date;

/// 性别
Property Sex As %String;

/// 证件类型
Property CardType As %String;

/// 证件号码
Property PersonalID As %String;

/// 联系电话
Property TelPhone As %String;

/// 现地址
Property CurAddress As %String;

/// 家长姓名 
Property FamName As %String;

/// 职业
Property Occupation As %String;

/// 工作单位
Property Company As %String;

/// 患者所属区域
Property Area As %String;

/// 疾病名称
Property DiseaseName As %String;

/// 疾病类别
Property DiseaseKind As %String;

/// 疾病等级
Property DiseaseRank As %String;

/// 发病日期
Property EPDSickDate As %Date;

/// 诊断日期
Property EPDDiagDate As %Date;

/// 诊断分类
Property DiagDegree As %String;

/// 死亡日期 
Property DeathDate As %Date;

/// 临床严重程度 (新冠肺炎)
Property Severity As %String;

/// 是否输入性病例(新冠肺炎)
Property IsInEPD As %String;

/// 填卡人
Property EnterUser As %String;

/// 填报科室
Property ReportLoc As %String;

/// 填卡日期
Property EnterDate As %Date;

/// 填卡时间
Property EnterTime As %Time;

/// 报告状态
Property EPDStatus As %String;

/// 患者唯一索引
Index IndexPersonId On (EPDName, Birthday, PersonalID);

Index IndexRegNo On RegNo;

Index IndexRepDate On EnterDate;

/// 患者+疾病类型，避免一个患者多份报告只导入一i此
Index IndexPerDisName On (EPDName, Birthday, PersonalID, DiseaseName);

/// Creator     : luotiantian
/// CreatDate   : 2021-01-04
/// Description : 取传染病导入历史报告数据
/// Table       : DHCMed.EPD.ImportReport
/// Input       : ID
/// Return      : Object
/// w ##class(DHCMed.EPD.ImportReport).GetObjById("")
ClassMethod GetObjById(aID As %String) As DHCMed.EPD.ImportReport
{
	New (aID)
	Quit:'##class(DHCMed.EPD.ImportReport).%ExistsId(aID) ""
	Set obj=##class(DHCMed.EPD.ImportReport).%OpenId(aID)
	Do:$IsObject(obj) obj.%Close()
	Quit obj
}

/// Creator：     luotiantian
/// CreatDate：   2020-01-04
/// Description:  更新传染病导入历史报告数据
/// Table：       DHCMed.EPD.ImportReport
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.EPD.ImportReport).Update("^11^20200717002^''0000000190^yqr7101^1998/7/10^女^居民身份证号^''370982199205290629^13512341234^北京市市辖区东城区景山街道333^^干部职员^无^本县区^HIV^艾滋病^国家法定乙类^2020/7/15^2020/7/17^确诊病例^^^^高原^心内科^2020/7/17^12:11:00^待审","^")
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	 
	New (InStr,separete)
	Set return=0
	Quit:(InStr="")||(separete="") return
	Set:separete="" separete="^"
	
	Set ID			= $tr($p(InStr,separete,1),"'","")
	Set ReportID    = $tr($p(InStr,separete,2),"'","")
	Set RepCardNo   = $tr($p(InStr,separete,3),"'","")
	Set RegNo       = $tr($p(InStr,separete,4),"'","")
	Set EPDName     = $tr($p(InStr,separete,5),"'","")
	Set Birthday    = $tr($p(InStr,separete,6),"'","")
	Set Sex         = $tr($p(InStr,separete,7),"'","")
	Set CardType    = $tr($p(InStr,separete,8),"'","")
	Set PersonalID  = $tr($p(InStr,separete,9),"'","")
	Set TelPhone    = $tr($p(InStr,separete,10),"'","")
	Set CurAddress  = $tr($p(InStr,separete,11),"'","")
	Set FamName     = $tr($p(InStr,separete,12),"'","")
	Set Occupation  = $tr($p(InStr,separete,13),"'","")
	Set Company     = $tr($p(InStr,separete,14),"'","")
	Set Area        = $tr($p(InStr,separete,15),"'","")
	Set DiseaseName = $tr($p(InStr,separete,16),"'","")
	Set DiseaseKind = $tr($p(InStr,separete,17),"'","")	
	Set DiseaseRank = $tr($p(InStr,separete,18),"'","")
	Set EPDSickDate = $tr($p(InStr,separete,19),"'","")
	Set EPDDiagDate = $tr($p(InStr,separete,20),"'","")
	Set DiagDegree  = $tr($p(InStr,separete,21),"'","")
	Set DeathDate   = $tr($p(InStr,separete,22),"'","")
	Set Severity    = $tr($p(InStr,separete,23),"'","")
	Set IsInEPD     = $tr($p(InStr,separete,24),"'","")
	Set EnterUser   = $tr($p(InStr,separete,25),"'","")
	Set ReportLoc   = $tr($p(InStr,separete,26),"'","")
	Set EnterDate   = $tr($p(InStr,separete,27),"'","")
	Set EnterTime   = $tr($p(InStr,separete,28),"'","")
    Set EPDStatus   = $tr($p(InStr,separete,29),"'","")
    Quit:(EPDName="")||(Birthday="")||(PersonalID="") return
    
    Set:$e(Birthday,5)="/" Birthday=$tr(Birthday,"/","-")
	Set:Birthday'="" Birthday=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(Birthday)
	Set:$e(EPDSickDate,5)="/" EPDSickDate=$tr(EPDSickDate,"/","-")
	Set:EPDSickDate'="" EPDSickDate=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(EPDSickDate)
	Set:$e(EPDDiagDate,5)="/" EPDDiagDate=$tr(EPDDiagDate,"/","-")
	Set:EPDDiagDate'="" EPDDiagDate=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(EPDDiagDate)
	Set:$e(DeathDate,5)="/" DeathDate=$tr(DeathDate,"/","-")
	Set:DeathDate'="" DeathDate=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(DeathDate)
	Set:$e(EnterDate,5)="/" EnterDate=$tr(EnterDate,"/","-")
	Set:EnterDate'="" EnterDate=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(EnterDate)
	Set:EnterTime[":" EnterTime=$zth(EnterTime,1)	
	
	Set tID=$o(^MA.EPD.ImportReportI("IndexPerDisName"," "_$ZCVT(EPDName,"U"),Birthday," "_$ZCVT(PersonalID,"U")," "_$ZCVT(DiseaseName,"U"),0))
	Quit:((ID="")&&(tID'="")) -2 
	
	If ID="" {
		Set obj=##class(DHCMed.EPD.ImportReport).%New()
	}Else{
		Set obj=##class(DHCMed.EPD.ImportReport).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return 
	Set obj.ReportID    = ReportID   
	Set obj.RepCardNo   = RepCardNo  
	Set obj.RegNo       = RegNo      
	Set obj.EPDName     = EPDName    
	Set obj.Birthday    = Birthday   
	Set obj.Sex         = Sex        
	Set obj.CardType    = CardType   
	Set obj.PersonalID  = PersonalID 
	Set obj.TelPhone    = TelPhone   
	Set obj.CurAddress  = CurAddress 
	Set obj.FamName     = FamName    
	Set obj.Occupation  = Occupation 
	Set obj.Company     = Company    
	Set obj.Area        = Area       
	Set obj.DiseaseName = DiseaseName
	Set obj.DiseaseKind = DiseaseKind
	Set obj.DiseaseRank = DiseaseRank
	Set obj.EPDSickDate = EPDSickDate
	Set obj.EPDDiagDate = EPDDiagDate
	Set obj.DiagDegree  = DiagDegree 
	Set obj.DeathDate   = DeathDate  
	Set obj.Severity    = Severity   
	Set obj.IsInEPD     = IsInEPD    
	Set obj.EnterUser   = EnterUser  
	Set obj.ReportLoc   = ReportLoc  
	Set obj.EnterDate   = EnterDate  
	Set obj.EnterTime   = EnterTime  
	Set obj.EPDStatus   = EPDStatus  
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator     : luotiantian
/// CreatDate   : 2020-01-049
/// Description : 删除传染病导入历史报告数据
/// Table       : DHCMed.EPD.ImportReport
/// Input       : ID
/// Return      : return>0:成功; return<=0:失败
/// w ##class(DHCMed.EPD.ImportReport).DeleteById("")
ClassMethod DeleteById(aID As %String) As %String
{
	New (aID)
	Set return=0
	Quit:(aID="") return
	Set sc=##class(DHCMed.EPD.ImportReport).%DeleteId(+aID)
	If $System.Status.IsError(sc) {
		Do $System.OBJ.DisplayError(sc)
		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Creator:      luotiantian
/// CreatDate:    2021-01-5
/// Description:  根据登记号或卡片编号获取传染病历史数据
/// Table：       DHCMed.EPD.ImportReport
/// Input：       aMrNo:登记号
/// Return：      返回obj
/// W ##class(DHCMed.EPD.ImportReport).GetReportByRegNo("0001921")
ClassMethod GetReportByRegNo(aRegNo As %String) As DHCMed.EPD.ImportReport
{
	New (aRegNo)
	Set return = ""
	Quit:(aRegNo="") return
	
	Set ID = ""
	For {
		Set ID = $o(^MA.EPD.ImportReportI("IndexRegNo"," "_aRegNo,ID))
		Quit:ID=""
		
		Set objDic = ##class(DHCMed.EPD.ImportReport).%OpenId(ID)
		Continue:'$IsObject(objDic)
		Do:objDic'="" objDic.%Close()
		
		Set return = objDic
	}
	Quit return
}

/// Creator		: luotiantian
/// CteatData	: 2020-05-29
/// Description : 查询传染病导入历史报告数据
/// Do ##class(%Library.ResultSet).RunQuery("DHCMed.EPD.ImportReport","QryReportByPersonID","张杉","513701199802129812")
Query QryReportByPersonID(aName As %String, aPersonId As %String) As %Query(ROWSPEC = "RowID:%String,ReportID:%String,MrNo:%String,EPDName:%String,Birthday:%String,Sex:%String,CardType:%String,PersonalID:%String,DiseaseName:%String,DiseaseKind:%String,DiseaseRank:%String,EPDSickDate:%String,EPDDiagDateTime:%String,EnterUser:%String,ReportLoc:%String,EnterDate:%String,EnterTime:%String,EPDStatus:%String")
{
}

ClassMethod QryReportByPersonIDExecute(ByRef qHandle As %Binary, aName As %String, aPersonId As %String, aReportID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xName = ""
	For {
		Set xName = $o(^MA.EPD.ImportReportI("IndexPersonId",xName))
		Quit:xName=""
		Continue:(aName'="")&&(xName'=(" "_aName))
		
		Set xBirthday = ""
		For {
			Set xBirthday = $o(^MA.EPD.ImportReportI("IndexPersonId",xBirthday))
			Quit:xBirthday=""
		
			Set xPersonId = ""
			For {
				Set xPersonId = $o(^MA.EPD.ImportReportI("IndexPersonId",xName,xBirthday,xPersonId))
				Quit:xPersonId=""
				Continue:(aPersonId'="")&&(xPersonId'=(" "_aPersonId))
				
				Set xRowID = ""
				For {
					Set xRowID = $o(^MA.EPD.ImportReportI("IndexPersonId",xName,xBirthday,xPersonId,xRowID))	
					Quit:xRowID=""
					Set objRep = ##class(DHCMed.EPD.ImportReport).GetObjById(xRowID)
					Continue:'$IsObject(objRep)	
					
					Set ReportID    = objRep.ReportID   
					Set RepCardNo   = objRep.RepCardNo  
					Set RegNo       = objRep.RegNo      
					Set EPDName     = objRep.EPDName    
					Set Birthday    = objRep.Birthday 
					Set:Birthday'="" Birthday=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(Birthday)  
					Set Sex         = objRep.Sex        
					Set CardType    = objRep.CardType   
					Set PersonalID  = objRep.PersonalID 
					Set TelPhone    = objRep.TelPhone   
					Set CurAddress  = objRep.CurAddress 
					Set FamName     = objRep.FamName    
					Set Occupation  = objRep.Occupation 
					Set Company     = objRep.Company    
					Set Area        = objRep.Area       
					Set DiseaseName = objRep.DiseaseName
					Set DiseaseKind = objRep.DiseaseKind
					Set DiseaseRank = objRep.DiseaseRank
					Set EPDSickDate = objRep.EPDSickDate
					Set:Birthday'="" Birthday=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(Birthday)  
					Set EPDDiagDate = objRep.EPDDiagDate
					Set:EPDDiagDate'="" EPDDiagDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(EPDDiagDate)  
					Set DiagDegree  = objRep.DiagDegree 
					Set DeathDate   = objRep.DeathDate 
					Set:DeathDate'="" DeathDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(DeathDate)   
					Set Severity    = objRep.Severity   
					Set IsInEPD     = objRep.IsInEPD    
					Set EnterUser   = objRep.EnterUser  
					Set ReportLoc   = objRep.ReportLoc  
					Set EnterDate   = objRep.EnterDate
					Set:EnterDate'="" EnterDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(EnterDate)    
					Set EnterTime   = objRep.EnterTime 
					Set:EnterTime'="" EnterTime=$zt(EnterTime,1)
					Set EPDStatus   = objRep.EPDStatus 
					
					Set data=$lb(xRowID,ReportID,RepCardNo,RegNo,EPDName,Birthday,Sex,CardType,PersonalID,TelPhone,CurAddress,FamName,Occupation,Company,Area,DiseaseName,DiseaseKind,DiseaseRank,EPDSickDate,EPDDiagDate,DiagDegree,DeathDate,Severity,IsInEPD,EnterUser,ReportLoc,EnterDate,EnterTime,EPDStatus)
					Set ^CacheTemp(repid,ind)=data
					Set ind=ind+1
				}
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryReportByPersonIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReportByPersonIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryReportByPersonIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReportByPersonIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Storage Default
{
<Data name="ImportReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReportID</Value>
</Value>
<Value name="3">
<Value>RegNo</Value>
</Value>
<Value name="4">
<Value>EPDName</Value>
</Value>
<Value name="5">
<Value>Birthday</Value>
</Value>
<Value name="6">
<Value>Sex</Value>
</Value>
<Value name="7">
<Value>CardType</Value>
</Value>
<Value name="8">
<Value>PersonalID</Value>
</Value>
<Value name="9">
<Value>DiseaseName</Value>
</Value>
<Value name="10">
<Value>EPDSickDate</Value>
</Value>
<Value name="11">
<Value>EPDDiagDate</Value>
</Value>
<Value name="12">
<Value>EnterUser</Value>
</Value>
<Value name="13">
<Value>ReportLoc</Value>
</Value>
<Value name="14">
<Value>EnterDate</Value>
</Value>
<Value name="15">
<Value>EnterTime</Value>
</Value>
<Value name="16">
<Value>EPDStatus</Value>
</Value>
<Value name="17">
<Value>EPDDiagDate</Value>
</Value>
<Value name="18">
<Value>RepCardNo</Value>
</Value>
<Value name="19">
<Value>TelPhone</Value>
</Value>
<Value name="20">
<Value>CurAddress</Value>
</Value>
<Value name="21">
<Value>FamName</Value>
</Value>
<Value name="22">
<Value>Occupation</Value>
</Value>
<Value name="23">
<Value>Company</Value>
</Value>
<Value name="24">
<Value>Area</Value>
</Value>
<Value name="25">
<Value>DiagDegree</Value>
</Value>
<Value name="26">
<Value>DeathDate</Value>
</Value>
<Value name="27">
<Value>Severity</Value>
</Value>
<Value name="28">
<Value>IsInEPD</Value>
</Value>
<Value name="29">
<Value>DiseaseRank</Value>
</Value>
<Value name="30">
<Value>DiseaseKind</Value>
</Value>
</Data>
<DataLocation>^MA.EPD.ImportReportD</DataLocation>
<DefaultData>ImportReportDefaultData</DefaultData>
<IdLocation>^MA.EPD.ImportReportD</IdLocation>
<IndexLocation>^MA.EPD.ImportReportI</IndexLocation>
<StreamLocation>^MA.EPD.ImportReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
