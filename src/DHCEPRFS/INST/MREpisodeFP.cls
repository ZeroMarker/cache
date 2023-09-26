Class DHCEPRFS.INST.MREpisodeFP Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 02 系统标识号
Property MREpisodeID As %String(TRUNCATE = 1);

/// 03 病人标识号
Property MRPatientID As %String(TRUNCATE = 1);

/// 04 医疗组织机构代码
Property CompanyCode As %String(TRUNCATE = 1);

/// 05 创建日期
Property CreateDate As %Date;

/// 06 创建时间
Property CreateTime As %Time;

/// 07 最后修改日期
Property LastModifyDate As %Date;

/// 08 最后修改时间
Property LastModifyTime As %Time;

/// 09 主要诊断ID
Property DiagMainID As %String(TRUNCATE = 1);

/// 10 主要诊断编码
Property DiagMainCode As %String(TRUNCATE = 1);

/// 11 主要诊断描述
Property DiagMainDesc As %String(TRUNCATE = 1);

/// 12 主要诊断入院病情
Property DiagMainState As %String(TRUNCATE = 1);

/// 13 其它诊断01ID    
Property Diag01ID As %String(TRUNCATE = 1);

/// 14 其它诊断01编码
Property Diag01Code As %String(TRUNCATE = 1);

/// 15 其它诊断01描述
Property Diag01Desc As %String(TRUNCATE = 1);

/// 16 其它诊断01入院病情
Property Diag01State As %String(TRUNCATE = 1);

/// 17 其它诊断02ID    
Property Diag02ID As %String(TRUNCATE = 1);

/// 18 其它诊断02编码
Property Diag02Code As %String(TRUNCATE = 1);

/// 19 其它诊断02描述
Property Diag02Desc As %String(TRUNCATE = 1);

/// 20 其它诊断02入院病情
Property Diag02State As %String(TRUNCATE = 1);

/// 21 其它诊断03ID    
Property Diag03ID As %String(TRUNCATE = 1);

/// 22 其它诊断03编码
Property Diag03Code As %String(TRUNCATE = 1);

/// 23 其它诊断03描述
Property Diag03Desc As %String(TRUNCATE = 1);

/// 24 其它诊断03入院病情
Property Diag03State As %String(TRUNCATE = 1);

/// 25 其它诊断04ID    
Property Diag04ID As %String(TRUNCATE = 1);

/// 26 其它诊断04编码
Property Diag04Code As %String(TRUNCATE = 1);

/// 27 其它诊断04描述
Property Diag04Desc As %String(TRUNCATE = 1);

/// 28 其它诊断04入院病情
Property Diag04State As %String(TRUNCATE = 1);

/// 29 其它诊断05ID    
Property Diag05ID As %String(TRUNCATE = 1);

/// 30 其它诊断05编码
Property Diag05Code As %String(TRUNCATE = 1);

/// 31 其它诊断05描述
Property Diag05Desc As %String(TRUNCATE = 1);

/// 32 其它诊断05入院病情
Property Diag05State As %String(TRUNCATE = 1);

/// 33 其它诊断06ID    
Property Diag06ID As %String(TRUNCATE = 1);

/// 34 其它诊断06编码
Property Diag06Code As %String(TRUNCATE = 1);

/// 35 其它诊断06描述
Property Diag06Desc As %String(TRUNCATE = 1);

/// 36 其它诊断06入院病情
Property Diag06State As %String(TRUNCATE = 1);

/// 37 其它诊断07ID    
Property Diag07ID As %String(TRUNCATE = 1);

/// 38 其它诊断07编码
Property Diag07Code As %String(TRUNCATE = 1);

/// 39 其它诊断07描述
Property Diag07Desc As %String(TRUNCATE = 1);

/// 40 其它诊断07入院病情
Property Diag07State As %String(TRUNCATE = 1);

/// 41 其它诊断08ID    
Property Diag08ID As %String(TRUNCATE = 1);

/// 42 其它诊断08编码
Property Diag08Code As %String(TRUNCATE = 1);

/// 43 其它诊断08描述
Property Diag08Desc As %String(TRUNCATE = 1);

/// 44 其它诊断08入院病情
Property Diag08State As %String(TRUNCATE = 1);

/// 45 其它诊断09ID    
Property Diag09ID As %String(TRUNCATE = 1);

/// 46 其它诊断09编码
Property Diag09Code As %String(TRUNCATE = 1);

/// 47 其它诊断09描述
Property Diag09Desc As %String(TRUNCATE = 1);

/// 48 其它诊断09入院病情
Property Diag09State As %String(TRUNCATE = 1);

/// 49 其它诊断10ID    
Property Diag10ID As %String(TRUNCATE = 1);

/// 50 其它诊断10编码
Property Diag10Code As %String(TRUNCATE = 1);

/// 51 其它诊断10描述
Property Diag10Desc As %String(TRUNCATE = 1);

/// 52 其它诊断10入院病情
Property Diag10State As %String(TRUNCATE = 1);

/// 53 手术01ID
Property Oper01ID As %String(TRUNCATE = 1);

/// 54 手术01编码
Property Oper01Code As %String(TRUNCATE = 1);

/// 55 手术01描述
Property Oper01Desc As %String(TRUNCATE = 1);

/// 56 手术01等级
Property Oper01Level As %String(TRUNCATE = 1);

/// 57 手术01日期
Property Oper01Date As %String(TRUNCATE = 1);

/// 58 手术01操作医师ID
Property Oper01DocID As %String(TRUNCATE = 1);

/// 59 手术01操作医师姓名
Property Oper01DocName As %String(TRUNCATE = 1);

/// 60 手术01一助ID
Property Oper01Assist1ID As %String(TRUNCATE = 1);

/// 61 手术01一助姓名
Property Oper01Assist1Name As %String(TRUNCATE = 1);

/// 62 手术01二助ID
Property Oper01Assist2ID As %String(TRUNCATE = 1);

/// 63 手术01二助姓名
Property Oper01Assist2Name As %String(TRUNCATE = 1);

/// 64 手术01切口愈合等级
Property Oper01CutLevel As %String(TRUNCATE = 1);

/// 65 手术01麻醉方式
Property Oper01AnaMethod As %String(TRUNCATE = 1);

/// 66 手术01麻醉医师ID
Property Oper01AnaDocID As %String(TRUNCATE = 1);

/// 67 手术01麻醉医师姓名
Property Oper01AnaDocName As %String(TRUNCATE = 1);

/// 68 手术02ID
Property Oper02ID As %String(TRUNCATE = 1);

/// 69 手术02编码
Property Oper02Code As %String(TRUNCATE = 1);

/// 70 手术02描述
Property Oper02Desc As %String(TRUNCATE = 1);

/// 71 手术02等级
Property Oper02Level As %String(TRUNCATE = 1);

/// 72 手术02日期
Property Oper02Date As %String(TRUNCATE = 1);

/// 73 手术02操作医师ID
Property Oper02DocID As %String(TRUNCATE = 1);

/// 74 手术02操作医师姓名
Property Oper02DocName As %String(TRUNCATE = 1);

/// 75 手术02一助ID
Property Oper02Assist1ID As %String(TRUNCATE = 1);

/// 76 手术02一助姓名
Property Oper02Assist1Name As %String(TRUNCATE = 1);

/// 77 手术02二助ID
Property Oper02Assist2ID As %String(TRUNCATE = 1);

/// 78 手术02二助姓名
Property Oper02Assist2Name As %String(TRUNCATE = 1);

/// 79 手术02切口愈合等级
Property Oper02CutLevel As %String(TRUNCATE = 1);

/// 80 手术02麻醉方式
Property Oper02AnaMethod As %String(TRUNCATE = 1);

/// 81 手术02麻醉医师ID
Property Oper02AnaDocID As %String(TRUNCATE = 1);

/// 82 手术02麻醉医师姓名
Property Oper02AnaDocName As %String(TRUNCATE = 1);

/// 83 手术03ID
Property Oper03ID As %String(TRUNCATE = 1);

/// 84 手术03编码
Property Oper03Code As %String(TRUNCATE = 1);

/// 85 手术03描述
Property Oper03Desc As %String(TRUNCATE = 1);

/// 86 手术03等级
Property Oper03Level As %String(TRUNCATE = 1);

/// 87 手术03日期
Property Oper03Date As %String(TRUNCATE = 1);

/// 88 手术03操作医师ID
Property Oper03DocID As %String(TRUNCATE = 1);

/// 89 手术03操作医师姓名
Property Oper03DocName As %String(TRUNCATE = 1);

/// 90 手术03一助ID
Property Oper03Assist1ID As %String(TRUNCATE = 1);

/// 91 手术03一助姓名
Property Oper03Assist1Name As %String(TRUNCATE = 1);

/// 92 手术03二助ID
Property Oper03Assist2ID As %String(TRUNCATE = 1);

/// 93 手术03二助姓名
Property Oper03Assist2Name As %String(TRUNCATE = 1);

/// 94 手术03切口愈合等级
Property Oper03CutLevel As %String(TRUNCATE = 1);

/// 95 手术03麻醉方式
Property Oper03AnaMethod As %String(TRUNCATE = 1);

/// 96 手术03麻醉医师ID
Property Oper03AnaDocID As %String(TRUNCATE = 1);

/// 97 手术03麻醉医师姓名
Property Oper03AnaDocName As %String(TRUNCATE = 1);

/// 98 手术04ID
Property Oper04ID As %String(TRUNCATE = 1);

/// 99 手术04编码
Property Oper04Code As %String(TRUNCATE = 1);

/// 100 手术04描述
Property Oper04Desc As %String(TRUNCATE = 1);

/// 101 手术04等级
Property Oper04Level As %String(TRUNCATE = 1);

/// 102 手术04日期
Property Oper04Date As %String(TRUNCATE = 1);

/// 103 手术04操作医师ID
Property Oper04DocID As %String(TRUNCATE = 1);

/// 104 手术04操作医师姓名
Property Oper04DocName As %String(TRUNCATE = 1);

/// 105 手术04一助ID
Property Oper04Assist1ID As %String(TRUNCATE = 1);

/// 106 手术04一助姓名
Property Oper04Assist1Name As %String(TRUNCATE = 1);

/// 107 手术04二助ID
Property Oper04Assist2ID As %String(TRUNCATE = 1);

/// 108 手术04二助姓名
Property Oper04Assist2Name As %String(TRUNCATE = 1);

/// 109 手术04切口愈合等级
Property Oper04CutLevel As %String(TRUNCATE = 1);

/// 110 手术04麻醉方式
Property Oper04AnaMethod As %String(TRUNCATE = 1);

/// 111 手术04麻醉医师ID
Property Oper04AnaDocID As %String(TRUNCATE = 1);

/// 112 手术04麻醉医师姓名
Property Oper04AnaDocName As %String(TRUNCATE = 1);

/// 113 手术05ID
Property Oper05ID As %String(TRUNCATE = 1);

/// 114 手术05编码
Property Oper05Code As %String(TRUNCATE = 1);

/// 115 手术05描述
Property Oper05Desc As %String(TRUNCATE = 1);

/// 116 手术05等级
Property Oper05Level As %String(TRUNCATE = 1);

/// 117 手术05日期
Property Oper05Date As %String(TRUNCATE = 1);

/// 118 手术05操作医师ID
Property Oper05DocID As %String(TRUNCATE = 1);

/// 119 手术05操作医师姓名
Property Oper05DocName As %String(TRUNCATE = 1);

/// 120 手术05一助ID
Property Oper05Assist1ID As %String(TRUNCATE = 1);

/// 121 手术05一助姓名
Property Oper05Assist1Name As %String(TRUNCATE = 1);

/// 122 手术05二助ID
Property Oper05Assist2ID As %String(TRUNCATE = 1);

/// 123 手术05二助姓名
Property Oper05Assist2Name As %String(TRUNCATE = 1);

/// 124 手术05切口愈合等级
Property Oper05CutLevel As %String(TRUNCATE = 1);

/// 125 手术05麻醉方式
Property Oper05AnaMethod As %String(TRUNCATE = 1);

/// 126 手术05麻醉医师ID
Property Oper05AnaDocID As %String(TRUNCATE = 1);

/// 127 手术05麻醉医师姓名
Property Oper05AnaDocName As %String(TRUNCATE = 1);

/// 128 手术06ID
Property Oper06ID As %String(TRUNCATE = 1);

/// 129 手术06编码
Property Oper06Code As %String(TRUNCATE = 1);

/// 130 手术06描述
Property Oper06Desc As %String(TRUNCATE = 1);

/// 131 手术06等级
Property Oper06Level As %String(TRUNCATE = 1);

/// 132 手术06日期
Property Oper06Date As %String(TRUNCATE = 1);

/// 133 手术06操作医师ID
Property Oper06DocID As %String(TRUNCATE = 1);

/// 134 手术06操作医师姓名
Property Oper06DocName As %String(TRUNCATE = 1);

/// 135 手术06一助ID
Property Oper06Assist1ID As %String(TRUNCATE = 1);

/// 136 手术06一助姓名
Property Oper06Assist1Name As %String(TRUNCATE = 1);

/// 137 手术06二助ID
Property Oper06Assist2ID As %String(TRUNCATE = 1);

/// 138 手术06二助姓名
Property Oper06Assist2Name As %String(TRUNCATE = 1);

/// 139 手术06切口愈合等级
Property Oper06CutLevel As %String(TRUNCATE = 1);

/// 140 手术06麻醉方式
Property Oper06AnaMethod As %String(TRUNCATE = 1);

/// 141 手术06麻醉医师ID
Property Oper06AnaDocID As %String(TRUNCATE = 1);

/// 142 手术06麻醉医师姓名
Property Oper06AnaDocName As %String(TRUNCATE = 1);

/// 143 手术07ID
Property Oper07ID As %String(TRUNCATE = 1);

/// 144 手术07编码
Property Oper07Code As %String(TRUNCATE = 1);

/// 145 手术07描述
Property Oper07Desc As %String(TRUNCATE = 1);

/// 146 手术07等级
Property Oper07Level As %String(TRUNCATE = 1);

/// 147 手术07日期
Property Oper07Date As %String(TRUNCATE = 1);

/// 148 手术07操作医师ID
Property Oper07DocID As %String(TRUNCATE = 1);

/// 149 手术07操作医师姓名
Property Oper07DocName As %String(TRUNCATE = 1);

/// 150 手术07一助ID
Property Oper07Assist1ID As %String(TRUNCATE = 1);

/// 151 手术07一助姓名
Property Oper07Assist1Name As %String(TRUNCATE = 1);

/// 152 手术07二助ID
Property Oper07Assist2ID As %String(TRUNCATE = 1);

/// 153 手术07二助姓名
Property Oper07Assist2Name As %String(TRUNCATE = 1);

/// 154 手术07切口愈合等级
Property Oper07CutLevel As %String(TRUNCATE = 1);

/// 155 手术07麻醉方式
Property Oper07AnaMethod As %String(TRUNCATE = 1);

/// 156 手术07麻醉医师ID
Property Oper07AnaDocID As %String(TRUNCATE = 1);

/// 157 手术07麻醉医师姓名
Property Oper07AnaDocName As %String(TRUNCATE = 1);

/// 158 手术08ID
Property Oper08ID As %String(TRUNCATE = 1);

/// 159 手术08编码
Property Oper08Code As %String(TRUNCATE = 1);

/// 160 手术08描述
Property Oper08Desc As %String(TRUNCATE = 1);

/// 161 手术08等级
Property Oper08Level As %String(TRUNCATE = 1);

/// 162 手术08日期
Property Oper08Date As %String(TRUNCATE = 1);

/// 163 手术08操作医师ID
Property Oper08DocID As %String(TRUNCATE = 1);

/// 164 手术08操作医师姓名
Property Oper08DocName As %String(TRUNCATE = 1);

/// 165 手术08一助ID
Property Oper08Assist1ID As %String(TRUNCATE = 1);

/// 166 手术08一助姓名
Property Oper08Assist1Name As %String(TRUNCATE = 1);

/// 167 手术08二助ID
Property Oper08Assist2ID As %String(TRUNCATE = 1);

/// 168 手术08二助姓名
Property Oper08Assist2Name As %String(TRUNCATE = 1);

/// 169 手术08切口愈合等级
Property Oper08CutLevel As %String(TRUNCATE = 1);

/// 170 手术08麻醉方式
Property Oper08AnaMethod As %String(TRUNCATE = 1);

/// 171 手术08麻醉医师ID
Property Oper08AnaDocID As %String(TRUNCATE = 1);

/// 172 手术08麻醉医师姓名
Property Oper08AnaDocName As %String(TRUNCATE = 1);

/// 173 门急诊诊断ID
Property DiagOutID As %String(TRUNCATE = 1);

/// 174 门急诊诊断编码
Property DiagOutCode As %String(TRUNCATE = 1);

/// 175 门急诊诊断描述
Property DiagOutDesc As %String(TRUNCATE = 1);

/// 176 入院诊断ID
Property DiagAdmID As %String(TRUNCATE = 1);

/// 177 入院诊断编码
Property DiagAdmCode As %String(TRUNCATE = 1);

/// 178 入院诊断描述
Property DiagAdmDesc As %String(TRUNCATE = 1);

/// 179 入院诊断入院情况
Property DiagAdmState As %String(TRUNCATE = 1);

/// 180 病理诊断
Property DiagPathDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 180 ];

/// 181 病理诊断
Property DiagPathCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 181 ];

/// 182 病历主要诊断编码
Property EMRMainDiagCode As %String(MAXLEN = 200, TRUNCATE = 1);

/// 183 病历主要诊断描述
Property EMRMainDiagDesc As %String(MAXLEN = 200, TRUNCATE = 1);

Index IdxMrEpisodeID On MREpisodeID;

Storage Default
{
<Data name="MREpisodeFPDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MREpisodeID</Value>
</Value>
<Value name="3">
<Value>MRPatientID</Value>
</Value>
<Value name="4">
<Value>CompanyCode</Value>
</Value>
<Value name="5">
<Value>CreateDate</Value>
</Value>
<Value name="6">
<Value>CreateTime</Value>
</Value>
<Value name="7">
<Value>LastModifyDate</Value>
</Value>
<Value name="8">
<Value>LastModifyTime</Value>
</Value>
<Value name="9">
<Value>DiagMainID</Value>
</Value>
<Value name="10">
<Value>DiagMainCode</Value>
</Value>
<Value name="11">
<Value>DiagMainDesc</Value>
</Value>
<Value name="12">
<Value>DiagMainState</Value>
</Value>
<Value name="13">
<Value>Diag01ID</Value>
</Value>
<Value name="14">
<Value>Diag01Code</Value>
</Value>
<Value name="15">
<Value>Diag01Desc</Value>
</Value>
<Value name="16">
<Value>Diag01State</Value>
</Value>
<Value name="17">
<Value>Diag02ID</Value>
</Value>
<Value name="18">
<Value>Diag02Code</Value>
</Value>
<Value name="19">
<Value>Diag02Desc</Value>
</Value>
<Value name="20">
<Value>Diag02State</Value>
</Value>
<Value name="21">
<Value>Diag03ID</Value>
</Value>
<Value name="22">
<Value>Diag03Code</Value>
</Value>
<Value name="23">
<Value>Diag03Desc</Value>
</Value>
<Value name="24">
<Value>Diag03State</Value>
</Value>
<Value name="25">
<Value>Diag04ID</Value>
</Value>
<Value name="26">
<Value>Diag04Code</Value>
</Value>
<Value name="27">
<Value>Diag04Desc</Value>
</Value>
<Value name="28">
<Value>Diag04State</Value>
</Value>
<Value name="29">
<Value>Diag05ID</Value>
</Value>
<Value name="30">
<Value>Diag05Code</Value>
</Value>
<Value name="31">
<Value>Diag05Desc</Value>
</Value>
<Value name="32">
<Value>Diag05State</Value>
</Value>
<Value name="33">
<Value>Diag06Code</Value>
</Value>
<Value name="34">
<Value>Diag06Desc</Value>
</Value>
<Value name="35">
<Value>Diag06ID</Value>
</Value>
<Value name="36">
<Value>Diag06State</Value>
</Value>
<Value name="37">
<Value>Diag07ID</Value>
</Value>
<Value name="38">
<Value>Diag07Code</Value>
</Value>
<Value name="39">
<Value>Diag07Desc</Value>
</Value>
<Value name="40">
<Value>Diag07State</Value>
</Value>
<Value name="41">
<Value>Diag08ID</Value>
</Value>
<Value name="42">
<Value>Diag08Code</Value>
</Value>
<Value name="43">
<Value>Diag08Desc</Value>
</Value>
<Value name="44">
<Value>Diag08State</Value>
</Value>
<Value name="45">
<Value>Diag09ID</Value>
</Value>
<Value name="46">
<Value>Diag09Code</Value>
</Value>
<Value name="47">
<Value>Diag09Desc</Value>
</Value>
<Value name="48">
<Value>Diag09State</Value>
</Value>
<Value name="49">
<Value>Diag10Code</Value>
</Value>
<Value name="50">
<Value>Diag10Desc</Value>
</Value>
<Value name="51">
<Value>Diag10ID</Value>
</Value>
<Value name="52">
<Value>Diag10State</Value>
</Value>
<Value name="53">
<Value>Oper01ID</Value>
</Value>
<Value name="54">
<Value>Oper01Code</Value>
</Value>
<Value name="55">
<Value>Oper01Desc</Value>
</Value>
<Value name="56">
<Value>Oper01Level</Value>
</Value>
<Value name="57">
<Value>Oper01Date</Value>
</Value>
<Value name="58">
<Value>Oper01DocID</Value>
</Value>
<Value name="59">
<Value>Oper01DocName</Value>
</Value>
<Value name="60">
<Value>Oper01Assist1ID</Value>
</Value>
<Value name="61">
<Value>Oper01Assist1Name</Value>
</Value>
<Value name="62">
<Value>Oper01Assist2ID</Value>
</Value>
<Value name="63">
<Value>Oper01Assist2Name</Value>
</Value>
<Value name="64">
<Value>Oper01CutLevel</Value>
</Value>
<Value name="65">
<Value>Oper01AnaMethod</Value>
</Value>
<Value name="66">
<Value>Oper01AnaDocID</Value>
</Value>
<Value name="67">
<Value>Oper01AnaDocName</Value>
</Value>
<Value name="68">
<Value>Oper02ID</Value>
</Value>
<Value name="69">
<Value>Oper02Code</Value>
</Value>
<Value name="70">
<Value>Oper02Desc</Value>
</Value>
<Value name="71">
<Value>Oper02Level</Value>
</Value>
<Value name="72">
<Value>Oper02Date</Value>
</Value>
<Value name="73">
<Value>Oper02DocID</Value>
</Value>
<Value name="74">
<Value>Oper02DocName</Value>
</Value>
<Value name="75">
<Value>Oper02Assist1ID</Value>
</Value>
<Value name="76">
<Value>Oper02Assist1Name</Value>
</Value>
<Value name="77">
<Value>Oper02Assist2ID</Value>
</Value>
<Value name="78">
<Value>Oper02Assist2Name</Value>
</Value>
<Value name="79">
<Value>Oper02CutLevel</Value>
</Value>
<Value name="80">
<Value>Oper02AnaMethod</Value>
</Value>
<Value name="81">
<Value>Oper02AnaDocID</Value>
</Value>
<Value name="82">
<Value>Oper02AnaDocName</Value>
</Value>
<Value name="83">
<Value>Oper03ID</Value>
</Value>
<Value name="84">
<Value>Oper03Code</Value>
</Value>
<Value name="85">
<Value>Oper03Desc</Value>
</Value>
<Value name="86">
<Value>Oper03Level</Value>
</Value>
<Value name="87">
<Value>Oper03Date</Value>
</Value>
<Value name="88">
<Value>Oper03DocID</Value>
</Value>
<Value name="89">
<Value>Oper03DocName</Value>
</Value>
<Value name="90">
<Value>Oper03Assist1ID</Value>
</Value>
<Value name="91">
<Value>Oper03Assist1Name</Value>
</Value>
<Value name="92">
<Value>Oper03Assist2ID</Value>
</Value>
<Value name="93">
<Value>Oper03Assist2Name</Value>
</Value>
<Value name="94">
<Value>Oper03CutLevel</Value>
</Value>
<Value name="95">
<Value>Oper03AnaMethod</Value>
</Value>
<Value name="96">
<Value>Oper03AnaDocID</Value>
</Value>
<Value name="97">
<Value>Oper03AnaDocName</Value>
</Value>
<Value name="98">
<Value>Oper04ID</Value>
</Value>
<Value name="99">
<Value>Oper04Code</Value>
</Value>
<Value name="100">
<Value>Oper04Desc</Value>
</Value>
<Value name="101">
<Value>Oper04Level</Value>
</Value>
<Value name="102">
<Value>Oper04Date</Value>
</Value>
<Value name="103">
<Value>Oper04DocID</Value>
</Value>
<Value name="104">
<Value>Oper04DocName</Value>
</Value>
<Value name="105">
<Value>Oper04Assist1ID</Value>
</Value>
<Value name="106">
<Value>Oper04Assist1Name</Value>
</Value>
<Value name="107">
<Value>Oper04Assist2ID</Value>
</Value>
<Value name="108">
<Value>Oper04Assist2Name</Value>
</Value>
<Value name="109">
<Value>Oper04CutLevel</Value>
</Value>
<Value name="110">
<Value>Oper04AnaMethod</Value>
</Value>
<Value name="111">
<Value>Oper04AnaDocID</Value>
</Value>
<Value name="112">
<Value>Oper04AnaDocName</Value>
</Value>
<Value name="113">
<Value>Oper05ID</Value>
</Value>
<Value name="114">
<Value>Oper05Code</Value>
</Value>
<Value name="115">
<Value>Oper05Desc</Value>
</Value>
<Value name="116">
<Value>Oper05Level</Value>
</Value>
<Value name="117">
<Value>Oper05Date</Value>
</Value>
<Value name="118">
<Value>Oper05DocID</Value>
</Value>
<Value name="119">
<Value>Oper05DocName</Value>
</Value>
<Value name="120">
<Value>Oper05Assist1ID</Value>
</Value>
<Value name="121">
<Value>Oper05Assist1Name</Value>
</Value>
<Value name="122">
<Value>Oper05Assist2ID</Value>
</Value>
<Value name="123">
<Value>Oper05Assist2Name</Value>
</Value>
<Value name="124">
<Value>Oper05CutLevel</Value>
</Value>
<Value name="125">
<Value>Oper05AnaMethod</Value>
</Value>
<Value name="126">
<Value>Oper05AnaDocID</Value>
</Value>
<Value name="127">
<Value>Oper05AnaDocName</Value>
</Value>
<Value name="128">
<Value>Oper06ID</Value>
</Value>
<Value name="129">
<Value>Oper06Code</Value>
</Value>
<Value name="130">
<Value>Oper06Desc</Value>
</Value>
<Value name="131">
<Value>Oper06Level</Value>
</Value>
<Value name="132">
<Value>Oper06Date</Value>
</Value>
<Value name="133">
<Value>Oper06DocID</Value>
</Value>
<Value name="134">
<Value>Oper06DocName</Value>
</Value>
<Value name="135">
<Value>Oper06Assist1ID</Value>
</Value>
<Value name="136">
<Value>Oper06Assist1Name</Value>
</Value>
<Value name="137">
<Value>Oper06Assist2ID</Value>
</Value>
<Value name="138">
<Value>Oper06Assist2Name</Value>
</Value>
<Value name="139">
<Value>Oper06CutLevel</Value>
</Value>
<Value name="140">
<Value>Oper06AnaMethod</Value>
</Value>
<Value name="141">
<Value>Oper06AnaDocID</Value>
</Value>
<Value name="142">
<Value>Oper06AnaDocName</Value>
</Value>
<Value name="143">
<Value>Oper07ID</Value>
</Value>
<Value name="144">
<Value>Oper07Code</Value>
</Value>
<Value name="145">
<Value>Oper07Desc</Value>
</Value>
<Value name="146">
<Value>Oper07Level</Value>
</Value>
<Value name="147">
<Value>Oper07Date</Value>
</Value>
<Value name="148">
<Value>Oper07DocID</Value>
</Value>
<Value name="149">
<Value>Oper07DocName</Value>
</Value>
<Value name="150">
<Value>Oper07Assist1ID</Value>
</Value>
<Value name="151">
<Value>Oper07Assist1Name</Value>
</Value>
<Value name="152">
<Value>Oper07Assist2ID</Value>
</Value>
<Value name="153">
<Value>Oper07Assist2Name</Value>
</Value>
<Value name="154">
<Value>Oper07CutLevel</Value>
</Value>
<Value name="155">
<Value>Oper07AnaMethod</Value>
</Value>
<Value name="156">
<Value>Oper07AnaDocID</Value>
</Value>
<Value name="157">
<Value>Oper07AnaDocName</Value>
</Value>
<Value name="158">
<Value>Oper08ID</Value>
</Value>
<Value name="159">
<Value>Oper08Code</Value>
</Value>
<Value name="160">
<Value>Oper08Desc</Value>
</Value>
<Value name="161">
<Value>Oper08Level</Value>
</Value>
<Value name="162">
<Value>Oper08Date</Value>
</Value>
<Value name="163">
<Value>Oper08DocID</Value>
</Value>
<Value name="164">
<Value>Oper08DocName</Value>
</Value>
<Value name="165">
<Value>Oper08Assist1ID</Value>
</Value>
<Value name="166">
<Value>Oper08Assist1Name</Value>
</Value>
<Value name="167">
<Value>Oper08Assist2ID</Value>
</Value>
<Value name="168">
<Value>Oper08Assist2Name</Value>
</Value>
<Value name="169">
<Value>Oper08CutLevel</Value>
</Value>
<Value name="170">
<Value>Oper08AnaMethod</Value>
</Value>
<Value name="171">
<Value>Oper08AnaDocID</Value>
</Value>
<Value name="172">
<Value>Oper08AnaDocName</Value>
</Value>
<Value name="173">
<Value>DiagOutID</Value>
</Value>
<Value name="174">
<Value>DiagOutCode</Value>
</Value>
<Value name="175">
<Value>DiagOutDesc</Value>
</Value>
<Value name="176">
<Value>DiagAdmID</Value>
</Value>
<Value name="177">
<Value>DiagAdmCode</Value>
</Value>
<Value name="178">
<Value>DiagAdmDesc</Value>
</Value>
<Value name="179">
<Value>DiagAdmState</Value>
</Value>
<Value name="180">
<Value>DiagPathDesc</Value>
</Value>
<Value name="181">
<Value>DiagPathCode</Value>
</Value>
<Value name="182">
<Value>EMRMainDiagCode</Value>
</Value>
<Value name="183">
<Value>EMRMainDiagDesc</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.MREpisodeFPD</DataLocation>
<DefaultData>MREpisodeFPDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.MREpisodeFPD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.MREpisodeFPI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.MREpisodeFPS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
