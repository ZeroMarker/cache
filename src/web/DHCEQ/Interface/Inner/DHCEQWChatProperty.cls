Class web.DHCEQ.Interface.Inner.DHCEQWChatProperty Extends (%Library.RegisteredObject, %XML.Adaptor) [ ClassType = "", ProcedureBlock ]
{

Property EquipNo As %String(TRUNCATE = 1);

Property TableName As %String(TRUNCATE = 1);

Property valInfo As %String(TRUNCATE = 1);

Property EQRowID As %String(TRUNCATE = 1);

Property Status As %String(TRUNCATE = 1);

Property ExObjDR As %String(TRUNCATE = 1);

Property RequestLocDR As %String(TRUNCATE = 1);

Property StartDate As %String(TRUNCATE = 1);

Property EndDate As %String(TRUNCATE = 1);

Property ApproveRole As %String(TRUNCATE = 1);

Property WaitAD As %String(TRUNCATE = 1);

Property QXType As %String(TRUNCATE = 1);

Property RequestNo As %String(TRUNCATE = 1);

Property InvalidFlag As %String(TRUNCATE = 1);

Property LocFlag As %String(TRUNCATE = 1);

Property UserFlag As %String(TRUNCATE = 1);

Property GroupID As %String(TRUNCATE = 1);

Property CurUser As %String(TRUNCATE = 1);

Property vData As %String(TRUNCATE = 1);

Property MRRowID As %String(TRUNCATE = 1);

Property MRGUser As %String(TRUNCATE = 1);

Property val As %String(TRUNCATE = 1);

Property CurRole As %String(TRUNCATE = 1);

Property RoleStep As %String(TRUNCATE = 1);

Property editFieldsInfo As %String(TRUNCATE = 1);

Property AcceptUser As %String(TRUNCATE = 1);

Property FaultCase As %String(TRUNCATE = 1);

Property FaultReason As %String(TRUNCATE = 1);

Property rowid As %String(TRUNCATE = 1);

Property itmjs As %String(TRUNCATE = 1);

Property itmjsex As %String(TRUNCATE = 1);

Property TRowID As %String(TRUNCATE = 1);

Property TCode As %String(TRUNCATE = 1);

Property TDesc As %String(TRUNCATE = 1);

Property TRemark As %String(TRUNCATE = 1);

Property TSourceType As %String(TRUNCATE = 1);

Property TSourceID As %String(TRUNCATE = 1);

Property TEvaluateType As %String(TRUNCATE = 1);

Property TEvaluateTypeDR As %String(TRUNCATE = 1);

Property TScore As %String(TRUNCATE = 1);

Property TUser As %String(TRUNCATE = 1);

Property TDate As %String(TRUNCATE = 1);

Property TTime As %String(TRUNCATE = 1);

Property TApproveRole As %String(TRUNCATE = 1);

Property vSourceType As %String(TRUNCATE = 1);

Property vSourceID As %String(TRUNCATE = 1);

Property vApproveRole As %String(TRUNCATE = 1);

Property UserID As %String(TRUNCATE = 1);

Property UserName As %String(TRUNCATE = 1);

Property NumFrom As %String(TRUNCATE = 1);

Property NumTo As %String(TRUNCATE = 1);

Property vCurRole As %String(TRUNCATE = 1);

Property vUser As %String(TRUNCATE = 1);

Property EDifficulty As %String(TRUNCATE = 1);

Property EWorkAttitude As %String(TRUNCATE = 1);

Property EProcessSpeed As %String(TRUNCATE = 1);

Property CurGroupID As %String(TRUNCATE = 1);

Property EvaluateType As %String(TRUNCATE = 1);

Property vEvaluationInfo As %String(TRUNCATE = 1);

Property MaintID As %String(TRUNCATE = 1);

Property MaintProgress As %String(TRUNCATE = 1);

Property MaintInfo As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property MRStatus As %String(TRUNCATE = 1);

Property TLocDR As %String(TRUNCATE = 1);

Property TGroupDR As %String(TRUNCATE = 1);

Property LastFlag As %String(TRUNCATE = 1);

Property mRoleStep As %String(TRUNCATE = 1);

Property mInfo As %String(TRUNCATE = 1);

Property mEditInfo As %String(TRUNCATE = 1);

Property mRole As %String(TRUNCATE = 1);

Property mApproveFlowID As %String(TRUNCATE = 1);

Property mTableName As %String(TRUNCATE = 1);

Property ExObjID As %String(TRUNCATE = 1);

Property PictureInfo As %String(TRUNCATE = 1);

Property Path As %String(TRUNCATE = 1);

Property Remark As %String(TRUNCATE = 1);

Property Equipdr As %String(TRUNCATE = 1);

Property IsDel As %String(TRUNCATE = 1);

Property BussType As %String(TRUNCATE = 1);

Property mInput As %String(TRUNCATE = 1);

Property MeunType As %String(TRUNCATE = 1);

Property ApproveSetDR As %String(TRUNCATE = 1);

Property CurRoleID As %String(TRUNCATE = 1);

Property ApproveTypeCode As %String(TRUNCATE = 1);

Property Type As %String(TRUNCATE = 1);

Property CurStep As %String(TRUNCATE = 1);

Property ApproveRoleDR As %String(TRUNCATE = 1);

Property action As %String(TRUNCATE = 1);

Property step As %String(TRUNCATE = 1);

Property Password As %String(TRUNCATE = 1);

Property ChatID As %String(TRUNCATE = 1);

Property LocID As %String(TRUNCATE = 1);

Property PLID As %String(TRUNCATE = 1);

Property PTData As %String(TRUNCATE = 1);

Property PLData As %String(TRUNCATE = 1);

Property AccessoryTypeDR As %String(TRUNCATE = 1);

Property MaintItemDR As %String(TRUNCATE = 1);

Property TItemDR As %String(TRUNCATE = 1);

Property vQXType As %String(TRUNCATE = 1);

Property FinishFlag As %String(TRUNCATE = 1);

Property LeaderFlag As %String(TRUNCATE = 1);

Property MaintProcess As %String(TRUNCATE = 1);

// Add By QW20200108 BUG:QW0035 begin微信webservice参数

Property classname As %String(TRUNCATE = 1);

Property queryname As %String(TRUNCATE = 1);

Property queryparas As %String(TRUNCATE = 1);

Property CurHosptailID As %String(TRUNCATE = 1);

Property componentname As %String(TRUNCATE = 1);

Property data As %String(TRUNCATE = 1);

Property datalist As %String(TRUNCATE = 1);

Property methodname As %String(TRUNCATE = 1);

Property methodparas As %String(TRUNCATE = 1);

// Add By QW20200108 BUG:QW0035 end微信webservice参数

Property InventoryDR As %String(TRUNCATE = 1);

Property InventoryNo As %String(TRUNCATE = 1);

Property ReadOnly As %String(TRUNCATE = 1);

Property CTLocID As %String(TRUNCATE = 1);

Property CurHospID As %String(TRUNCATE = 1);

// Modify by zx 2020-07-07

Property differStatu As %String(TRUNCATE = 1);

Property InventoryLocDR As %String(TRUNCATE = 1);

Property ManageLocFlag As %String(TRUNCATE = 1);

Property PMReport As %String(TRUNCATE = 1);

Property PMReportList As %String(TRUNCATE = 1);

Property Provider As %String(TRUNCATE = 1);

Property MaxValue As %String(TRUNCATE = 1);

Property MinValue As %String(TRUNCATE = 1);

Property AccessType As %String(TRUNCATE = 1);

Property EquipTypeDR As %String(TRUNCATE = 1);

Property Model As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DHCEQWChatPropertyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EquipNo</Value>
</Value>
<Value name="3">
<Value>TableName</Value>
</Value>
<Value name="4">
<Value>valInfo</Value>
</Value>
<Value name="5">
<Value>EQRowID</Value>
</Value>
<Value name="6">
<Value>Status</Value>
</Value>
<Value name="7">
<Value>ExObjDR</Value>
</Value>
<Value name="8">
<Value>RequestLocDR</Value>
</Value>
<Value name="9">
<Value>StartDate</Value>
</Value>
<Value name="10">
<Value>EndDate</Value>
</Value>
<Value name="11">
<Value>ApproveRole</Value>
</Value>
<Value name="12">
<Value>WaitAD</Value>
</Value>
<Value name="13">
<Value>QXType</Value>
</Value>
<Value name="14">
<Value>RequestNo</Value>
</Value>
<Value name="15">
<Value>InvalidFlag</Value>
</Value>
<Value name="16">
<Value>LocFlag</Value>
</Value>
<Value name="17">
<Value>UserFlag</Value>
</Value>
<Value name="18">
<Value>GroupID</Value>
</Value>
<Value name="19">
<Value>CurUser</Value>
</Value>
<Value name="20">
<Value>vData</Value>
</Value>
<Value name="21">
<Value>MRRowID</Value>
</Value>
<Value name="22">
<Value>MRGUser</Value>
</Value>
<Value name="23">
<Value>val</Value>
</Value>
<Value name="24">
<Value>CurRole</Value>
</Value>
<Value name="25">
<Value>RoleStep</Value>
</Value>
<Value name="26">
<Value>editFieldsInfo</Value>
</Value>
<Value name="27">
<Value>AcceptUser</Value>
</Value>
<Value name="28">
<Value>FaultCase</Value>
</Value>
<Value name="29">
<Value>FaultReason</Value>
</Value>
<Value name="30">
<Value>rowid</Value>
</Value>
<Value name="31">
<Value>itmjs</Value>
</Value>
<Value name="32">
<Value>itmjsex</Value>
</Value>
<Value name="33">
<Value>TRowID</Value>
</Value>
<Value name="34">
<Value>TCode</Value>
</Value>
<Value name="35">
<Value>TDesc</Value>
</Value>
<Value name="36">
<Value>TRemark</Value>
</Value>
<Value name="37">
<Value>TSourceType</Value>
</Value>
<Value name="38">
<Value>TSourceID</Value>
</Value>
<Value name="39">
<Value>TEvaluateType</Value>
</Value>
<Value name="40">
<Value>TEvaluateTypeDR</Value>
</Value>
<Value name="41">
<Value>TScore</Value>
</Value>
<Value name="42">
<Value>TUser</Value>
</Value>
<Value name="43">
<Value>TDate</Value>
</Value>
<Value name="44">
<Value>TTime</Value>
</Value>
<Value name="45">
<Value>TApproveRole</Value>
</Value>
<Value name="46">
<Value>vSourceType</Value>
</Value>
<Value name="47">
<Value>vSourceID</Value>
</Value>
<Value name="48">
<Value>vApproveRole</Value>
</Value>
<Value name="49">
<Value>UserID</Value>
</Value>
<Value name="50">
<Value>UserName</Value>
</Value>
<Value name="51">
<Value>NumFrom</Value>
</Value>
<Value name="52">
<Value>NumTo</Value>
</Value>
<Value name="53">
<Value>vCurRole</Value>
</Value>
<Value name="54">
<Value>vUser</Value>
</Value>
<Value name="55">
<Value>EDifficulty</Value>
</Value>
<Value name="56">
<Value>EWorkAttitude</Value>
</Value>
<Value name="57">
<Value>EProcessSpeed</Value>
</Value>
<Value name="58">
<Value>CurGroupID</Value>
</Value>
<Value name="59">
<Value>EvaluateType</Value>
</Value>
<Value name="60">
<Value>vEvaluationInfo</Value>
</Value>
<Value name="61">
<Value>MaintID</Value>
</Value>
<Value name="62">
<Value>MaintProgress</Value>
</Value>
<Value name="63">
<Value>MaintInfo</Value>
</Value>
<Value name="64">
<Value>Name</Value>
</Value>
<Value name="65">
<Value>MRStatus</Value>
</Value>
<Value name="66">
<Value>TLocDR</Value>
</Value>
<Value name="67">
<Value>TGroupDR</Value>
</Value>
<Value name="68">
<Value>LastFlag</Value>
</Value>
<Value name="69">
<Value>mRoleStep</Value>
</Value>
<Value name="70">
<Value>mInfo</Value>
</Value>
<Value name="71">
<Value>mEditInfo</Value>
</Value>
<Value name="72">
<Value>mRole</Value>
</Value>
<Value name="73">
<Value>mApproveFlowID</Value>
</Value>
<Value name="74">
<Value>mTableName</Value>
</Value>
<Value name="75">
<Value>ExObjID</Value>
</Value>
<Value name="76">
<Value>PictureInfo</Value>
</Value>
<Value name="77">
<Value>Path</Value>
</Value>
<Value name="78">
<Value>Remark</Value>
</Value>
<Value name="79">
<Value>Equipdr</Value>
</Value>
<Value name="80">
<Value>IsDel</Value>
</Value>
<Value name="81">
<Value>BussType</Value>
</Value>
<Value name="82">
<Value>mInput</Value>
</Value>
<Value name="83">
<Value>MeunType</Value>
</Value>
<Value name="84">
<Value>ApproveSetDR</Value>
</Value>
<Value name="85">
<Value>CurRoleID</Value>
</Value>
<Value name="86">
<Value>ApproveTypeCode</Value>
</Value>
<Value name="87">
<Value>Type</Value>
</Value>
<Value name="88">
<Value>CurStep</Value>
</Value>
<Value name="89">
<Value>ApproveRoleDR</Value>
</Value>
<Value name="90">
<Value>action</Value>
</Value>
<Value name="91">
<Value>step</Value>
</Value>
<Value name="92">
<Value>Password</Value>
</Value>
<Value name="93">
<Value>ChatID</Value>
</Value>
<Value name="94">
<Value>LocID</Value>
</Value>
<Value name="95">
<Value>PLID</Value>
</Value>
<Value name="96">
<Value>PTData</Value>
</Value>
<Value name="97">
<Value>PLData</Value>
</Value>
<Value name="98">
<Value>AccessoryTypeDR</Value>
</Value>
<Value name="99">
<Value>MaintItemDR</Value>
</Value>
<Value name="100">
<Value>TItemDR</Value>
</Value>
<Value name="101">
<Value>vQXType</Value>
</Value>
<Value name="102">
<Value>FinishFlag</Value>
</Value>
<Value name="103">
<Value>LeaderFlag</Value>
</Value>
<Value name="104">
<Value>MaintProcess</Value>
</Value>
<Value name="105">
<Value>InventoryDR</Value>
</Value>
<Value name="106">
<Value>InventoryNo</Value>
</Value>
<Value name="107">
<Value>ReadOnly</Value>
</Value>
<Value name="108">
<Value>CTLocID</Value>
</Value>
<Value name="109">
<Value>CurHospID</Value>
</Value>
<Value name="110">
<Value>datalist</Value>
</Value>
<Value name="111">
<Value>differStatu</Value>
</Value>
<Value name="112">
<Value>InventoryLocDR</Value>
</Value>
<Value name="113">
<Value>ManageLocFlag</Value>
</Value>
<Value name="114">
<Value>PMReport</Value>
</Value>
<Value name="115">
<Value>PMReportList</Value>
</Value>
<Value name="116">
<Value>Provider</Value>
</Value>
<Value name="117">
<Value>MaxValue</Value>
</Value>
<Value name="118">
<Value>MinValue</Value>
</Value>
<Value name="119">
<Value>AccessType</Value>
</Value>
<Value name="120">
<Value>Model</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQ.I5FF.DHCEQWChatPFE1ED</DataLocation>
<DefaultData>DHCEQWChatPropertyDefaultData</DefaultData>
<IdLocation>^web.DHCEQ.I5FF.DHCEQWChatPFE1ED</IdLocation>
<IndexLocation>^web.DHCEQ.I5FF.DHCEQWChatPFE1EI</IndexLocation>
<StreamLocation>^web.DHCEQ.I5FF.DHCEQWChatPFE1ES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
