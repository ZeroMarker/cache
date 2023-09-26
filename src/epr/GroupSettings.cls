Class epr.GroupSettings Extends (%Library.Persistent, websys.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 400;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter EXTENTSIZE = 100;

Parameter SQLCODE = "ID";

Parameter SQLDESCRIPTION = "ID";

Parameter SQLROWID = "ID";

/// by wuqk 2011-06-08 for MenuSecurity initial length
Parameter MENULENGTH = 55000;

/// Index for property GroupDR
Index GroupDRIndex On GroupDR;

/// THIS IS NO LONGER A "DOCTOR ONLY" FLAG.
/// Log 39282: remove Doctor logic from Inactive checkbox.
/// Due to the "Cannot change the name of a component item" rule, we are keeping the name.
Property AllergiesInactiveByDoctorOnly As %Library.Boolean;

Property AllowBedHistory As %Library.Boolean;

Property AllowXML As %Library.Boolean;

Property AppTimeout As %Library.String(TRUNCATE = 1);

Property CarPrvTp As %Library.String(MAXLEN = 99999, TRUNCATE = 1);

Property CarPrvTpHideEps As %Library.Boolean;

Property DisableWardSumLink As %Library.Boolean;

Property DisplayWordFormat As %Library.Boolean;

Property GroupDR As User.SSGroup [ Required ];

Property MainChartBookDR As epr.ChartBook;

Property MainChartDR As epr.Chart;

Property MainMenuDR As websys.Menu;

/// Web Menu Security Access
Property MenuSecurity As %Library.String(COLLATION = "Exact", MAXLEN = 51000, TRUNCATE = 1);

/// Percentage size of the top Frame in the Multiple Appointment screen
/// in Resource Booking
Property MidApptFramePerc As %Library.Integer;

Property OEExecItemDetails As %Library.String(MAXLEN = 99999, TRUNCATE = 1);

Property OEExecSubCatDetails As %Library.String(MAXLEN = 99999, TRUNCATE = 1);

Property OEItemDetails As %Library.String(MAXLEN = 99999, TRUNCATE = 1);

Property OEItemItemDetails As %Library.String(MAXLEN = 99999, TRUNCATE = 1);

Property OEItemSubCatDetails As %Library.String(MAXLEN = 99999, TRUNCATE = 1);

Property OESetItems As %Library.String(MAXLEN = 99999, TRUNCATE = 1);

Property OESetSets As %Library.String(MAXLEN = 99999, TRUNCATE = 1);

Property OESetSubCats As %Library.String(MAXLEN = 99999, TRUNCATE = 1);

Property OrderProfileDR As epr.CTProfileParams;

Property PrevEpisChartDR As epr.Chart;

Property RefreshTime As %Library.Integer;

Property PharmRefreshTime As %Library.Integer;

/// Pharmacy - can dispense non-formulary items
Property PharmCanDispNonForm As %Library.Boolean;

Property LabNoDisplayType As %String(TRUNCATE = 1);

/// reference to websys.MenuGroup to display security group's side menus
Property SideMenuGroupDR As websys.MenuGroup;

Property StartPageDR As websys.WorkFlow;

Property StyleSheet As %Library.String(MAXLEN = "", TRUNCATE = 1);

/// Percentage size of the top Frame in the Multiple Appointment screen
/// in Resource Booking
Property TopApptFramePerc As %Library.Integer;

/// The height (in pixels) of the middle frame in paadmtrans.csp
Property TransCspMidFrame As %Library.Integer;

/// The height (in pixels) of the top frame in paadmtrans.csp
Property TransCspTopFrame As %Library.Integer;

/// Cumulative View Across All Episodes
Property CumAcrossAllEpisodes As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N");

/// Cumulative View Include R Prefix
Property CumIncludeRPrefix As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N");

/// Cumulative View Reference Range Position
Property CumRefRangePosition As %Library.String(DISPLAYLIST = ",Before Test Item,After Test Item,After Test Data,Do Not Display", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",BT,AT,AD,DN");

/// Cumulative View Allowed to See Graph Link
Property CumAllowedSeeGraphLink As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N");

/// Cumulative View Number of Columns
Property CumNoColumns As %Library.Integer;

/// Log 39287 - AI - 02-10-2003 : New field Cumulative View Column Width - applies to Result columns etc.
Property CumColumnWidth As %Integer;

/// Log 39459 - AI - 09-10-2003 : New field for "Only Show Uncollected Specimens On Collection Screen.
Property OnlyShowUncollectedOnCollection As %Library.Boolean;

/// KK 8/Jan/04 L:39835 - New fields Udate Date,Time,User and Hospital. 
Property LastUpdateDate As %Date;

Property LastUpdateTime As %Time;

Property LastUpdateUserDR As User.SSUser;

Property LastUpdateUserHospDR As User.CTHospital;

/// Log 42975 - AI - 24-03-2004 : New field for "Discharge Summary Document Type" - comma-separated list of epr.CTDischargeSummaryType IDs.
Property DisSumDocTp As %Library.String(MAXLEN = 99999, TRUNCATE = 1);

/// Log 44164 - AI - 31-05-2004 : New field for "Discharge Summary EPR ChartBook" - ID of epr.ChartBook.
Property DisSumEPRChartBookDR As epr.ChartBook;

/// for use with RBAppointment
Property ShowAllRows As %Library.Boolean;

Property NoSelectMultiRow As %Library.Boolean;

/// Log 45046 - AI - 17-09-2004 : New field for "Interface Workbench Refresh Time (min)" - IWRefreshTime.
///                               Used in SSInterfaceMonitor.List.js.
Property IWRefreshTime As %Library.Integer;

/// SB 29/09/04 (45587): This param allows user to switch on session type details in the calendar.
Property RBDisplaySessionType As %Library.String(TRUNCATE = 1);

/// Log 44734 - AI - 29-09-2004 : New field for "Graph Group" - DR to epr.CTGraphGroup.
Property EPRCTGraphGroupDR As epr.CTGraphGroup;

/// Log 46501 - MD - 19-10-2004 : New field for "Pharmacy Queue"  comma-separated list of Pharmacy Q IDS
Property PharmQ As %Library.String(MAXLEN = 99999, TRUNCATE = 1);

/// Log 46439 - AI - 22-10-2004 : New field for "Display message for new interface rejections" - Interface Wokbench.
Property IWNewRejectionsMessage As %Library.Boolean;

/// Log 46439 - AI - 22-10-2004 : New field for "Display message for new interface errors" - Interface Workbench.
Property IWNewErrorsMessage As %Library.Boolean;

Property CanAddDSMedications As %Library.Boolean;

/// ab 21.02.05 48554
Property AllergySeverity As %Library.String(MAXLEN = 99999, TRUNCATE = 1);

Property DrugIntSeverity As %Library.String(MAXLEN = 99999, TRUNCATE = 1);

/// SB 06/04/05 (50319)
Property CanChangeBrand As %Library.Boolean;

/// JW (54994)
Property CanOverpackPrescriptions As %Boolean;

/// Log 51381 - BKJ - 09-05-2005 : New field for "Result Type" - comma-separated list of websys.StandardTypeItems - ResultType
Property DisplayResultTypes As %Library.String(MAXLEN = 99999, TRUNCATE = 1);

/// Log 53079 - RC - 07-07-2005 : Change for OT Diary to display Operation, Procedure, or Free Text.
Property OTDiaryDisplay As %Library.String(TRUNCATE = 1);

/// display an episode selection frame on EPR?
Property EPRClinEncounter As %Library.String(TRUNCATE = 1);

/// ab 22.02.06 57855 - Able to edit Authoised Questionnaires
Property CanEditClosedAss As %Library.Boolean;

/// ab 17.11.06 61465 - Able to edit authorised Result Questionnaires
Property CanEditResQues As %Library.Boolean;

/// ab 16.03.06 50671
Property AuditTables As %Library.String(TRUNCATE = 1);

/// Log 48106 - RC - 05-04-2006 : New field for "Do not allow to overbook into Public Holiday" - Appointments.
Property NoPubHolBook As %Library.Boolean;

/// Log 54852 - JD
Property ShowOrderListFrame As %Library.Boolean;

/// Result Range Separator - 59655
Property ResultRangeSep As %Library.String(TRUNCATE = 1);

/// Log 58574 - ML - 21/06/2006 - HL7 Outbound Queue Deletion
Property HL7OutboundQueueDel As %Library.Boolean;

/// Log 59215 - JD
Property AllowPrescOverride As %Library.Boolean;

/// ab 15.08.06 60192
/// Allow to Change Admin Status
Property AllowChangeAdminStatus As %Library.Boolean;

/// Log 58162 BoC 04/09/2006
/// New field for "Show questionnaire for orders of category"
Property OEQuesCatDetails As %Library.String(MAXLEN = 99999, TRUNCATE = 1);

/// Log 58162 BoC 04/09/2006
/// New field for "Show questionnaire for orders of Subcategory"
Property OEQuesSubCatDetails As %Library.String(MAXLEN = 99999, TRUNCATE = 1);

/// 48863
Property RequireCheckOnPack As %Library.Boolean;

/// SB 06/05/06 (58637) - Display Session Edit Icon on OT Diary
Property DisplaySessEditIcon As %Library.Boolean;

/// SB 06/05/06 (58637) - Display Day Edit Icon on OT Diary
Property DisplayDayEditIcon As %Library.Boolean;

/// EZ 07/12/06 (49183) - View Episode Alert Active (yes/no)
Property ViewEpisodeAlertFlag As %Library.Boolean;

/// MD 11/12/06  - Allow overbooking when session unavailable (yes/no)
Property AllowOverbookNA As %Library.Boolean;

/// MD 12/12/2006 -Display message when adding/replacing an item/s on the Bulk Preferences screen
/// Log 65339 Kb Disable this parameter
Property XXNotUsed As %Library.Boolean;

/// 60317
Property UseAuthClinGrpPhoneOrders As %Library.Boolean;

/// EZ 26/03/07 (62758) - View PAAdm.Tree when using quick OT booking workflow (yes/no)
Property ViewPAAdmTreeOnOTWorkflow As %Library.Boolean;

/// 65700
Property PatientTypeRestrict As %Library.String(MAXLEN = 99999);

/// 65700
Property ViewSecurity As %Library.String(COLLATION = "Exact", MAXLEN = 51000, TRUNCATE = 1);

/// 锁屏时间设置，0表示永不锁屏
Property LockScrTimeOut As %Library.String(TRUNCATE = 1);

/// 是否能多页签打开菜单
Property MutilTabMenu As %Library.Boolean;

/// 是否以面板方式显示菜单
Property ShowPanelMenu As %Library.Boolean;

/// 允许的IP地址(10.1.19.1,10.1.1.*,10.1.2.[1-20])
Property AllowLogonIP As %String;

/// zhouzq 2011.07.15
/// w ##class(epr.GroupSettings).AllergiesInactiveByDoctorOnly(1) 
ClassMethod AllergiesInactiveByDoctorOnly(GrpID As %Library.String = "") As %Library.Boolean
{
}

ClassMethod CanOverPack(GroupID As %Library.String)
{
}

ClassMethod EnableAllMenuAccess(GroupID As %Library.String)
{
}

/// by wuqk 2011-07-09
ClassMethod GetAllowBedHistory(GrpID As %Library.String = "") As %Library.Boolean
{
}

ClassMethod GetApptFramePerc(grpID As %Library.String) As %Library.String
{
}

/// KM 25-Jun-2001: This method is called by the CarPrvTpDesc component item from 
/// the epr.GroupSettings.EditCarPrvTp component.
/// 定义医护人员类型
/// websysSaveCP
/// zhaocz 2011-06-18
ClassMethod GetDescForCarPrvTp(CarPrvTpID As %Library.String) As %Library.String
{
}

/// Log 42975 - AI - 24-03-2004 : This method is called by the DisSumDocTpDesc component item
///   from the epr.GroupSettings.EditDisSumDocTp component. copied from GetDescForCarPrvTp method.
/// websysSaveDSD
/// zhaocz 2011-06-18
ClassMethod GetDescForDisSumDocTp(DisSumDocTpID As %Library.String) As %Library.String
{
}

/// Log 51381 - BKJ - 10-05-2005 : This method is called by the DisplayResultTypeDesc component item
///   from the epr.GroupSettings.EditDisResTp component. copied from GetDescForCarPrvTp method.
/// websysSaveDRT
/// zhaocz 2011-06-18
ClassMethod GetDescForDisResTp(DisResTpID As %Library.String) As %Library.String
{
}

/// KM 16-Feb-2001: This method is called by the OESetItemsDesc component item from 
/// the epr.GroupSettings.EditOEDetails component.
/// zhaocz 2011-06-18
ClassMethod GetDescForOECat(OECatID As %Library.String) As %Library.String
{
}

/// s val=##class(epr.GroupSettings).GetDescForOEItem($g(%request.Data("OEItemItemID",1))) 
/// zhaocz 2011-06-18
ClassMethod GetDescForOEItem(OEItemID As %Library.String) As %Library.String
{
}

/// s val=##class(epr.GroupSettings).GetDescForOESubCat($g(%request.Data("OEItemSubcatID",1))) 
/// zhaocz 2011-06-18
ClassMethod GetDescForOESubCat(OESubCatID As %Library.String) As %String
{
}

/// zhaocz 2011-06-18
ClassMethod GetDescForPharmQ(PharmQID As %Library.String) As %Library.String
{
}

/// 对应表  PAC_AllergySeverity
/// zhaocz 2011-06-18
ClassMethod GetDescForAllergySev(AllergyID As %String = "") As %Library.String
{
}

/// 对应 表 PHC_DrugInteractSeverity   药品的药剂配伍， 药品相互作用的严重程度
/// zhaocz 2011-06-18
ClassMethod GetDescForDrugInt(DrugInt As %String = "") As %Library.String
{
}

/// 对应表 SS_AuditRules  重新写了lookup
/// zhaocz 2011-06-18
ClassMethod GetDescForAuditTab(AuditTab As %String = "") As %Library.String
{
}

ClassMethod GetDetails(GroupID As %Library.String)
{
}

ClassMethod GetDisplayWordFormat(grpID As %String) As %String
{
}

/// Log 44164 - AI - 02-06-2004 : Called from epr.chartbook.csp. Get the Discharge Summary ChartBook for the given Group.
ClassMethod GetDisSumChartBook(GroupID As %Library.String) As %Library.String
{
}

/// by wuqk 2011-05-25
ClassMethod GetIdFromGroupId(groupid As %Library.String) As %Library.String
{
}

/// Log 45046 - AI - 17-09-2004 : Return the IWRefreshTime for the logon GroupID.
ClassMethod GetIWRefreshTime() As %Library.Integer
{
}

/// Log 44734 - AI - 29-09-2004 : Return the EPRCTGraphGroupDR for the logon GroupID.
ClassMethod GetEPRCTGraphGroupDR() As %Library.Integer
{
}

/// by wuqk 2011-06-09
ClassMethod GetMainChart(grpID As %String) As %String
{
}

/// by wuqk 2011-06-09
ClassMethod GetMainChartBook(grpID As %String) As %String
{
}

/// zhaocz 2011-05-26
/// zhaocz 2011-06-17 修正
ClassMethod GetMainMenu(grpID As %Library.String, ByRef swf As %String = "") As %Library.String
{
}

/// by wuqk 2011-06-09
/// / zhaocz 2011-06-17 edit
ClassMethod GetMenuSecurity(grpID As %Library.String) As %Library.String
{
}

ClassMethod GetPrevEpisChart(grpID As %String) As %String
{
}

/// 2011.07.06  zhouzq
ClassMethod GetRefreshTime(grpID As %Library.String) As %Library.Integer
{
}

ClassMethod GetPharmCanDispNonForm(grpID As %Library.String) As %Library.Integer
{
}

ClassMethod GetPharmRefreshTime(grpID As %Library.String) As %Library.Integer
{
}

/// 增加本安全组的开始页
/// zhaocz 2009-05-18
/// Group RowID
/// zhaocz 2011-06-17 edit
ClassMethod GetStartPage(grpID As %String) As %String
{
}

/// zhouzq 2011.11.15
/// w ##class(epr.GroupSettings).GetStyleSheet(307)
ClassMethod GetStyleSheet(grpID As %Library.String) As %Library.String
{
}

/// zhouzq 2011.11.15
/// w ##class(epr.GroupSettings).GetTransFramePixels(307)
ClassMethod GetTransFramePixels(grpID As %Library.String = "") As %Library.String
{
}

ClassMethod GetWardSummaryLink(GrpID As %Library.String = "") As %Library.Boolean
{
}

ClassMethod GetShowAllRows(GrpID As %Library.String = "") As %Library.Boolean
{
}

ClassMethod GetNoSelectMultiRow(GrpID As %Library.String = "") As %Library.Boolean
{
}

ClassMethod GetOTDiaryDisplay(GrpID As %Library.String = "") As %Library.Boolean
{
}

ClassMethod GetViewEpisodeAlertFlag(GrpID As %Library.String = "") As %Library.String
{
}

ClassMethod GetNoPubHolBook(GrpID As %Library.String = "") As %Library.Boolean
{
}

/// 54852
ClassMethod GetShowOrderListFrame(GrpID As %Library.String = "") As %Library.Boolean
{
}

/// 48863
ClassMethod GetRequireCheckOnPack(GrpID As %Library.String = "") As %Library.Boolean
{
}

/// 60317
ClassMethod GetUseAuthClinGrpPhoneOrders(GrpID As %Library.String = "") As %Library.Boolean
{
}

/// 59215
ClassMethod GetAllowPrescOverride(GrpID As %Library.String = "") As %Library.Boolean
{
}

/// AllowChangeAdminStatus
ClassMethod GetAllowChangeAdminStatus(GrpID As %Library.String = "") As %Library.Boolean
{
}

ClassMethod GetAllowOverbookNA(GrpID As %Library.String = "") As %Library.Boolean
{
}

ClassMethod GetViewPAAdmTreeOnOTWorkflow(GrpID As %Library.String = "") As %Library.String
{
}

/// returns whether episodes/appts should be hidden for care prov types other than those defined
/// 
/// returns flag^hide (1/0)^types (list of types defined)
ClassMethod HideEpisodesForCPT(GroupID As %Library.String = "") As %Library.String
{
}

ClassMethod GetHL7OutboundQueueDel(grpID As %String) As %String
{
}

/// 保存某安全组一个或多个
ClassMethod SaveGroupMenuSecurity(groupid = "", menuid1 = "", menuid0 = "")
{
}

/// by wuqk 2011-06-08
/// zhaocz 2011-06-17 修正
ClassMethod SaveMenuSecurity(ID As %Library.String, GroupID As %Library.String)
{
}

/// save access for checked groups for one particular menu, called on update of component websys.Menu.EditGroupSecurity
/// by wuqk 2011-06-08
/// zhaocz 2011-06-17 edit
ClassMethod SaveMenuAccessGroups(MenuID As %Library.String = "")
{
}

ClassMethod SaveViewAccessGroups(ViewID As %Library.String = "")
{
}

/// by wuqk 2011-06-08
/// by wanghc 2017 add GroupDesc
Query FindMenuAccessGroups(MenuID As %String = "", GroupDesc = "", HospId = "") As %Query(ROWSPEC = "SSGroupID:%String,SSGroupDesc:%String,SSGroupSecurityLevel:%String,HasMenuAccess:%Boolean")
{
}

ClassMethod FindMenuAccessGroupsExecute(ByRef qHandle As %Binary, MenuID As %String = "", GroupDesc = "", HospId = "") As %Status
{
}

ClassMethod FindMenuAccessGroupsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMenuAccessGroupsExecute ]
{
}

ClassMethod FindMenuAccessGroupsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMenuAccessGroupsExecute ]
{
}

/// by wuqk 2011-06-08
Query FindViewAccessGroups(ViewID As %String = "", GroupDescWord As %String = "") As %Query(ROWSPEC = "SSGroupID:%String,SSGroupDesc:%String,SSGroupSecurityLevel:%String,HasViewAccess:%Boolean")
{
}

ClassMethod FindViewAccessGroupsExecute(ByRef qHandle As %Binary, ViewID As %String = "", GroupDescWord As %String = "") As %Status
{
}

ClassMethod FindViewAccessGroupsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindViewAccessGroupsExecute ]
{
}

ClassMethod FindViewAccessGroupsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindViewAccessGroupsExecute ]
{
}

/// Reset the applications timeout value to be that stored against the group.
/// Only reset if there is a value.
/// Usergroup's timeout value stored as minutes... need to convert to seconds.
/// zhaocz 2011-05-26
ClassMethod SetGroupSessionTimeout(GroupID As %Library.String)
{
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
/// zhaocz  2011-06-16  add
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
}

/// Invoked before websysSave - can be used to cancel the save
/// zhaocz  2011-06-16  add
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

/// KM 25-Jun-2001: Called from component epr.GroupSettings.EditCarPrvTp
/// 医护人员类型定义
/// zhaocz 2011-06-18 add
ClassMethod websysSaveCP(id As %Library.String)
{
}

/// Log 42975 - AI - 24-03-2004 : Called from component epr.GroupSettings.EditDisSumDocTp. copied from websysSaveCP.
/// zhaocz 2011-06-18
ClassMethod websysSaveDSD(id As %Library.String)
{
}

/// Log 51381 - BKJ - 10-05-2005 : Called from component epr.GroupSettings.EditDisResTp. copied from websysSaveCP.
/// GetDescForDisResTp
/// zhaocz 2011-06-18
ClassMethod websysSaveDRT(id As %Library.String)
{
}

/// KK 29/Mar/2004 L:34299
ClassMethod websysSaveGroupandSettings(ByRef id As %String, ByRef gid As %String)
{
}

/// KM 12-Mar-2001: Called from component epr.GroupSettings.EditOEDetails.
ClassMethod websysSaveOE(id As %Library.String)
{
}

/// 对应的字段是 PharmQ
/// 药品队列
/// zhaocz 2011-06-18 add
ClassMethod websysSavePHQ(id As %Library.String)
{
}

/// zhaocz 2011-06-18 add
ClassMethod websysSaveAllergySev(id As %Library.String)
{
}

/// zhaocz 2011-06-18 add
ClassMethod websysSaveDrugInt(id As %Library.String)
{
}

/// zhaocz 2011-06-18 add
ClassMethod websysSaveAuditTab(id As %Library.String)
{
}

/// 保存患者类型限制
/// zhaocz 2011-06-18 add
ClassMethod websysSavePatientTypeRST(id As %Library.String)
{
}

/// 患者类型限制
/// s val=##class(epr.GroupSettings).GetDescForPatTypeRST($g(%request.Data("PatTypeRstID",1)))
/// zhaocz 2011-06-18 add
ClassMethod GetDescForPatTypeRST(PatTypeRstID As %Library.String) As %Library.String
{
}

/// @param: websys.View ViewID
/// 判断该安全组是否有使用这个View的权限
Method HasViewAccess(ViewID)
{
}

Method GetSideMenu()
{
}

Method GetSideJson()
{
}

Storage Default
{
<Data name="GroupSettingsDefaultData">
<Attribute>listnode</Attribute>
<Value name="1">
<Value>SideMenuGroupDR</Value>
</Value>
<Value name="2">
<Value>deleted</Value>
</Value>
<Value name="3">
<Value>deleted</Value>
</Value>
<Value name="4">
<Value>GroupDR</Value>
</Value>
<Value name="5">
<Value>deleted</Value>
</Value>
<Value name="6">
<Value>deleted</Value>
</Value>
<Value name="7">
<Value>deleted</Value>
</Value>
<Value name="8">
<Value>deleted</Value>
</Value>
<Value name="9">
<Value>deleted</Value>
</Value>
<Value name="10">
<Value>deleted</Value>
</Value>
<Value name="11">
<Value>deleted</Value>
</Value>
<Value name="12">
<Value>deleted</Value>
</Value>
<Value name="13">
<Value>MainChartDR</Value>
</Value>
<Value name="14">
<Value>MainMenuDR</Value>
</Value>
<Value name="15">
<Value>PrevEpisChartDR</Value>
</Value>
<Value name="16">
<Value>StartPageDR</Value>
</Value>
<Value name="17">
<Value>deleted</Value>
</Value>
<Value name="18">
<Value>deleted</Value>
</Value>
<Value name="19">
<Value>OESetItems</Value>
</Value>
<Value name="20">
<Value>OEItemDetails</Value>
</Value>
<Value name="21">
<Value>deleted</Value>
</Value>
<Value name="22">
<Value>deleted</Value>
</Value>
<Value name="23">
<Value>RefreshTime</Value>
</Value>
<Value name="24">
<Value>MenuSecurity</Value>
</Value>
<Value name="25">
<Value>CarPrvTp</Value>
</Value>
<Value name="26">
<Value>AppTimeout</Value>
</Value>
<Value name="27">
<Value>AllowBedHistory</Value>
</Value>
<Value name="28">
<Value>OrderProfileDR</Value>
</Value>
<Value name="29">
<Value>DisableWardSumLink</Value>
</Value>
<Value name="30">
<Value>StyleSheet</Value>
</Value>
<Value name="31">
<Value>CarPrvTpHideEps</Value>
</Value>
<Value name="32">
<Value>MidApptFramePerc</Value>
</Value>
<Value name="33">
<Value>TopApptFramePerc</Value>
</Value>
<Value name="34">
<Value>AllowXML</Value>
</Value>
<Value name="35">
<Value>TransCspMidFrame</Value>
</Value>
<Value name="36">
<Value>TransCspTopFrame</Value>
</Value>
<Value name="37">
<Value>DisplayWordFormat</Value>
</Value>
<Value name="38">
<Value>AllergiesInactiveByDoctorOnly</Value>
</Value>
<Value name="39">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="40">
<Value>OEItemItemDetails</Value>
</Value>
<Value name="41">
<Value>OEItemSubCatDetails</Value>
</Value>
<Value name="42">
<Value>OESetSets</Value>
</Value>
<Value name="43">
<Value>OESetSubCats</Value>
</Value>
<Value name="44">
<Value>OEExecItemDetails</Value>
</Value>
<Value name="45">
<Value>OEExecSubCatDetails</Value>
</Value>
<Value name="46">
<Value>MainChartBookDR</Value>
</Value>
<Value name="47">
<Value>SSGRPCumAcrossAllEpisodes</Value>
</Value>
<Value name="48">
<Value>SSGRPCumAllowedSeeGraphLink</Value>
</Value>
<Value name="49">
<Value>SSGRPCumIncludeRPrefix</Value>
</Value>
<Value name="50">
<Value>SSGRPCumNoColumns</Value>
</Value>
<Value name="51">
<Value>SSGRPCumRefRangePosition</Value>
</Value>
<Value name="52">
<Value>ResultDisplay</Value>
</Value>
<Value name="53">
<Value>CumAcrossAllEpisodes</Value>
</Value>
<Value name="54">
<Value>CumAllowedSeeGraphLink</Value>
</Value>
<Value name="55">
<Value>CumIncludeRPrefix</Value>
</Value>
<Value name="56">
<Value>CumNoColumns</Value>
</Value>
<Value name="57">
<Value>CumRefRangePosition</Value>
</Value>
<Value name="58">
<Value>LabNoDisplayType</Value>
</Value>
<Value name="59">
<Value>CumColumnWidth</Value>
</Value>
<Value name="60">
<Value>OnlyShowUncollectedOnCollection</Value>
</Value>
<Value name="61">
<Value>LastUpdateDate</Value>
</Value>
<Value name="62">
<Value>LastUpdateTime</Value>
</Value>
<Value name="63">
<Value>LastUpdateUserDR</Value>
</Value>
<Value name="64">
<Value>LastUpdateUserHospDR</Value>
</Value>
<Value name="65">
<Value>DisSumDocTp</Value>
</Value>
<Value name="66">
<Value>DisSumEPRChart</Value>
</Value>
<Value name="67">
<Value>DisSumEPRChartBook</Value>
</Value>
<Value name="68">
<Value>DisSumEPRChartBookDR</Value>
</Value>
<Value name="69">
<Value>ShowAllRows</Value>
</Value>
<Value name="70">
<Value>IWRefreshTime</Value>
</Value>
<Value name="71">
<Value>RBDisplaySessionType</Value>
</Value>
<Value name="72">
<Value>EPRCTGraphGroupDR</Value>
</Value>
<Value name="73">
<Value>PharmQ</Value>
</Value>
<Value name="74">
<Value>IWNewErrorsMessage</Value>
</Value>
<Value name="75">
<Value>IWNewRejectionsMessage</Value>
</Value>
<Value name="76">
<Value>NoSelectMultiRow</Value>
</Value>
<Value name="77">
<Value>PharmRefreshTime</Value>
</Value>
<Value name="78">
<Value>PharmCanDispNonForm</Value>
</Value>
<Value name="79">
<Value>AllowCancelExeOrders</Value>
</Value>
<Value name="80">
<Value>AllergySeverity</Value>
</Value>
<Value name="81">
<Value>DrugIntSeverity</Value>
</Value>
<Value name="82">
<Value>xxxNotUsed</Value>
</Value>
<Value name="83">
<Value>AllowCancelExeOrder</Value>
</Value>
<Value name="84">
<Value>CanAddDSMedications</Value>
</Value>
<Value name="85">
<Value>CanChangeBrand</Value>
</Value>
<Value name="86">
<Value>DisplayResultTypes</Value>
</Value>
<Value name="87">
<Value>OTDiaryDisplay</Value>
</Value>
<Value name="88">
<Value>EPRClinEncounter</Value>
</Value>
<Value name="89">
<Value>CanOverpackPrescriptions</Value>
</Value>
<Value name="90">
<Value>CumResultJustification</Value>
</Value>
<Value name="91">
<Value>CanAmendAuthStatus</Value>
</Value>
<Value name="92">
<Value>CanEditClosedAss</Value>
</Value>
<Value name="93">
<Value>AuditTables</Value>
</Value>
<Value name="94">
<Value>NoPubHolBook</Value>
</Value>
<Value name="95">
<Value>ShowOrderListFrame</Value>
</Value>
<Value name="96">
<Value>ResultRangeSep</Value>
</Value>
<Value name="97">
<Value>HL7OutboundQueueDel</Value>
</Value>
<Value name="98">
<Value>FaveStock</Value>
</Value>
<Value name="99">
<Value>AllowPrescOverride</Value>
</Value>
<Value name="100">
<Value>AllowChangeAdminStatus</Value>
</Value>
<Value name="101">
<Value>OEQuesCatDetails</Value>
</Value>
<Value name="102">
<Value>OEQuesSubCatDetails</Value>
</Value>
<Value name="103">
<Value>RequireCheckOnPack</Value>
</Value>
<Value name="104">
<Value>CanEditResQues</Value>
</Value>
<Value name="105">
<Value>DisplayDayEditIcon</Value>
</Value>
<Value name="106">
<Value>DisplaySessEditIcon</Value>
</Value>
<Value name="107">
<Value>ViewEpisodeAlertFlag</Value>
</Value>
<Value name="108">
<Value>AllowOverbookNA</Value>
</Value>
<Value name="109">
<Value>DisplayMsgForBulkPref</Value>
</Value>
<Value name="110">
<Value>UseAuthClinGrpPhoneOrders</Value>
</Value>
<Value name="111">
<Value>ViewPAAdmTreeOnOTWorkflow</Value>
</Value>
<Value name="112">
<Value>PatientTypeRestrict</Value>
</Value>
<Value name="113">
<Value>XXNotUsed</Value>
</Value>
<Value name="114">
<Value>ViewSecurity</Value>
</Value>
<Value name="115">
<Value>LockScrTimeOut</Value>
</Value>
<Value name="116">
<Value>MutilTabMenu</Value>
</Value>
<Value name="117">
<Value>ShowPanelMenu</Value>
</Value>
<Value name="118">
<Value>AllowLogonIP</Value>
</Value>
</Data>
<DataLocation>^ooGroupSettingsD</DataLocation>
<DefaultData>GroupSettingsDefaultData</DefaultData>
<ExtentSize>100</ExtentSize>
<IdLocation>^ooGroupSettingsD</IdLocation>
<IndexLocation>^ooGroupSettingsI</IndexLocation>
<Property name="AllergiesInactiveByDoctorOnly">
<Selectivity>1</Selectivity>
</Property>
<Property name="AllowBedHistory">
<Selectivity>1</Selectivity>
</Property>
<Property name="AllowXML">
<Selectivity>1</Selectivity>
</Property>
<Property name="AppTimeout">
<Selectivity>1</Selectivity>
</Property>
<Property name="CarPrvTp">
<Selectivity>1</Selectivity>
</Property>
<Property name="CarPrvTpHideEps">
<Selectivity>1</Selectivity>
</Property>
<Property name="DisableWardSumLink">
<Selectivity>1</Selectivity>
</Property>
<Property name="DisplayWordFormat">
<Selectivity>1</Selectivity>
</Property>
<Property name="GroupDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="MainChartBookDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="MainChartDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="MainMenuDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="MenuSecurity">
<Selectivity>1</Selectivity>
</Property>
<Property name="MidApptFramePerc">
<Selectivity>1</Selectivity>
</Property>
<Property name="OEItemDetails">
<Selectivity>1</Selectivity>
</Property>
<Property name="OESetItems">
<Selectivity>1</Selectivity>
</Property>
<Property name="OrderProfileDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="PrevEpisChartDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="RefreshTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="SideMenuGroupDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="StartPageDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="StyleSheet">
<Selectivity>1</Selectivity>
</Property>
<Property name="TopApptFramePerc">
<Selectivity>1</Selectivity>
</Property>
<Property name="TransCspMidFrame">
<Selectivity>1</Selectivity>
</Property>
<Property name="TransCspTopFrame">
<Selectivity>1</Selectivity>
</Property>
<StreamLocation>^epr.GroupSettingsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
