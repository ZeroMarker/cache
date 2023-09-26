/// 电子票据开具接口入参组织对象
Class BILL.EINV.DTO.AXNHTA.OPInvoiceReq Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Property issueinv As BILL.EINV.DTO.AXNHTA.OPInvoiceInv;

Storage Default
{
<Data name="OPInvoiceReqDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>busNo</Value>
</Value>
<Value name="3">
<Value>busType</Value>
</Value>
<Value name="4">
<Value>payer</Value>
</Value>
<Value name="5">
<Value>busDateTime</Value>
</Value>
<Value name="6">
<Value>placeCode</Value>
</Value>
<Value name="7">
<Value>payee</Value>
</Value>
<Value name="8">
<Value>author</Value>
</Value>
<Value name="9">
<Value>totalAmt</Value>
</Value>
<Value name="10">
<Value>remark</Value>
</Value>
<Value name="11">
<Value>alipayCode</Value>
</Value>
<Value name="12">
<Value>weChatOrderNo</Value>
</Value>
<Value name="13">
<Value>openID</Value>
</Value>
<Value name="14">
<Value>tel</Value>
</Value>
<Value name="15">
<Value>email</Value>
</Value>
<Value name="16">
<Value>idCardNo</Value>
</Value>
<Value name="17">
<Value>cardType</Value>
</Value>
<Value name="18">
<Value>cardNo</Value>
</Value>
<Value name="19">
<Value>medicalInstitution</Value>
</Value>
<Value name="20">
<Value>medCareInstitution</Value>
</Value>
<Value name="21">
<Value>medCareTypeCode</Value>
</Value>
<Value name="22">
<Value>medicalCareType</Value>
</Value>
<Value name="23">
<Value>medicalInsuranceID</Value>
</Value>
<Value name="24">
<Value>consultationDate</Value>
</Value>
<Value name="25">
<Value>category</Value>
</Value>
<Value name="26">
<Value>patientCategoryCode</Value>
</Value>
<Value name="27">
<Value>patientNo</Value>
</Value>
<Value name="28">
<Value>patientId</Value>
</Value>
<Value name="29">
<Value>sex</Value>
</Value>
<Value name="30">
<Value>age</Value>
</Value>
<Value name="31">
<Value>caseNumber</Value>
</Value>
<Value name="32">
<Value>specialDiseasesName</Value>
</Value>
<Value name="33">
<Value>accountPay</Value>
</Value>
<Value name="34">
<Value>fundPay</Value>
</Value>
<Value name="35">
<Value>otherfundPay</Value>
</Value>
<Value name="36">
<Value>ownPay</Value>
</Value>
<Value name="37">
<Value>selfConceitedAmt</Value>
</Value>
<Value name="38">
<Value>selfPayAmt</Value>
</Value>
<Value name="39">
<Value>selfCashPay</Value>
</Value>
<Value name="40">
<Value>cashPay</Value>
</Value>
<Value name="41">
<Value>chequePay</Value>
</Value>
<Value name="42">
<Value>transferAccountPay</Value>
</Value>
<Value name="43">
<Value>cashRecharge</Value>
</Value>
<Value name="44">
<Value>chequeRecharge</Value>
</Value>
<Value name="45">
<Value>transferRecharge</Value>
</Value>
<Value name="46">
<Value>cashRefund</Value>
</Value>
<Value name="47">
<Value>chequeRefund</Value>
</Value>
<Value name="48">
<Value>transferRefund</Value>
</Value>
<Value name="49">
<Value>ownAcBalance</Value>
</Value>
<Value name="50">
<Value>reimbursementAmt</Value>
</Value>
<Value name="51">
<Value>balancedNumber</Value>
</Value>
<Value name="52">
<Value>otherInfo</Value>
</Value>
<Value name="53">
<Value>otherMedicalList</Value>
</Value>
<Value name="54">
<Value>payChannelDetail</Value>
</Value>
<Value name="55">
<Value>eBillRelateNo</Value>
</Value>
<Value name="56">
<Value>chargeDetail</Value>
</Value>
<Value name="57">
<Value>listDetail</Value>
</Value>
<Value name="58">
<Value>machinetaxnr</Value>
</Value>
<Value name="59">
<Value>machinenr</Value>
</Value>
<Value name="60">
<Value>invkind</Value>
</Value>
<Value name="61">
<Value>doctype</Value>
</Value>
<Value name="62">
<Value>docnr</Value>
</Value>
<Value name="63">
<Value>docdate</Value>
</Value>
<Value name="64">
<Value>custnr</Value>
</Value>
<Value name="65">
<Value>custname</Value>
</Value>
<Value name="66">
<Value>custtaxnr</Value>
</Value>
<Value name="67">
<Value>custaddrtel</Value>
</Value>
<Value name="68">
<Value>custbankacct</Value>
</Value>
<Value name="69">
<Value>memo</Value>
</Value>
<Value name="70">
<Value>memo2</Value>
</Value>
<Value name="71">
<Value>refinvcode</Value>
</Value>
<Value name="72">
<Value>refinvnr</Value>
</Value>
<Value name="73">
<Value>rednoticenr</Value>
</Value>
<Value name="74">
<Value>issuer</Value>
</Value>
<Value name="75">
<Value>checker</Value>
</Value>
<Value name="76">
<Value>sellerbankacct</Value>
</Value>
<Value name="77">
<Value>selleraddresstel</Value>
</Value>
<Value name="78">
<Value>consignerName</Value>
</Value>
<Value name="79">
<Value>consignerTaxNr</Value>
</Value>
<Value name="80">
<Value>shipperName</Value>
</Value>
<Value name="81">
<Value>shipperTaxNr</Value>
</Value>
<Value name="82">
<Value>originViaArrivalPlace</Value>
</Value>
<Value name="83">
<Value>vehicleKindNo</Value>
</Value>
<Value name="84">
<Value>vehicleTonnage</Value>
</Value>
<Value name="85">
<Value>freightMemo</Value>
</Value>
<Value name="86">
<Value>taxdeduction</Value>
</Value>
<Value name="87">
<Value>listName</Value>
</Value>
<Value name="88">
<Value>emails</Value>
</Value>
<Value name="89">
<Value>invrecorditem</Value>
</Value>
</Data>
<DataLocation>^BILL.EINV.DTO2530.OPInvoiceReqD</DataLocation>
<DefaultData>OPInvoiceReqDefaultData</DefaultData>
<IdLocation>^BILL.EINV.DTO2530.OPInvoiceReqD</IdLocation>
<IndexLocation>^BILL.EINV.DTO2530.OPInvoiceReqI</IndexLocation>
<StreamLocation>^BILL.EINV.DTO2530.OPInvoiceReqS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
