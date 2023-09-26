/// 项目
Class dbo.BTTestCode Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestCode, StorageStrategy = Default ]
{

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On (HospitalDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

Index IndexSynonym On Synonym [ SqlName = Index_Synonym, Type = index ];

Index IndexLonicCode On LonicCode [ SqlName = Index_LonicCode, Type = index ];

Index IndexSCode On SCode [ SqlName = Index_SCode, Type = index ];

Index IndexHISCode On (HospitalDR, HISCode) [ SqlName = Index_HISCode, Type = index ];

Index IndexResultFormat On ResultFormat [ SqlName = Index_ResultFormat, Type = index ];

/// DDL Primary Key Specification
Index PKBTTESTCODE On RowID [ PrimaryKey, SqlName = PK_BT_TESTCODE, Type = index, Unique ];

/// Foreign Key FKQCTestCode created via DDL
ForeignKey FKQCTestCode(QCTestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_QCTestCode ];

/// Foreign Key FKTestCodeCostItem created via DDL
ForeignKey FKTestCodeCostItem(CostItemDR) References dbo.BTCostItem(PKBTCOSTITEM) [ SqlName = FK_TestCodeCostItem ];

/// Foreign Key FKTestCodeHospital created via DDL
ForeignKey FKTestCodeHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_TestCodeHospital ];

/// Foreign Key FKTestCodeMethod created via DDL
ForeignKey FKTestCodeMethod(TestMethodDR) References dbo.BTTestMethod(PKBTTESTMETHOD) [ SqlName = FK_TestCodeMethod ];

/// Foreign Key FKTestCodeTestSet created via DDL
ForeignKey FKTestCodeTestSet(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_TestCodeTestSet ];

/// Foreign Key FKTestCodeItemClass created via DDL
ForeignKey FKTestCodeItemClass(ItemClassDR) References dbo.BTItemClass(PKBTITEMCLASS) [ SqlName = FK_TestCodeItemClass ];

/// Foreign Key FKTestCodeDepart created via DDL
ForeignKey FKTestCodeDepart(DepartmentDR) References dbo.BTDepartment(PKBTDEPARTMENT) [ SqlName = FK_TestCodeDepart ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 4 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 全称  
Property LName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 6 ];

/// 英文名称  
Property EName As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 7 ];

/// 缩写  
Property Synonym As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 8 ];

/// 单位  
Property Units As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 9 ];

/// 结果格式  {N:数字,A:血型ABO,R:血型RH,M:微生物,X:文本,S:列表}
Property ResultFormat As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 10 ];

/// 精确度  
Property Precision As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 检测方法  
Property TestMethodDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 计算项  {1:true,0:false}
Property IsCalculate As %Library.Boolean [ SqlColumnNumber = 13 ];

/// LONIC码  
Property LonicCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 14 ];

/// 标准码  
Property SCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 15 ];

/// SOP内容  
Property SOPContent As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 16 ];

/// SOP文件  
Property SOPFile As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 17 ];

/// HIS对照码  
Property HISCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 18 ];

/// 收费项目  
Property CostItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

/// 价格  
Property Price As %Library.Float [ SqlColumnNumber = 20 ];

/// 临床意义简述  
Property ClinicalSignifyS As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 21 ];

/// 临床意义描述  
Property ClinicalSignifyL As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 22 ];

/// 独立医嘱套  
Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 23 ];

/// 打印顺序  
Property PrintOrder As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 24 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 25 ];

/// 状态  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 26 ];

/// 计算公式  
Property CalculateFormula As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 27 ];

/// 参考范围  
Property RefRanges As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 28 ];

/// 是否判断定性  {1:true,0:false}
Property IsCheckText As %Library.Boolean [ SqlColumnNumber = 29 ];

/// 特殊报告用  
Property RefField As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 30 ];

/// 是否允许负数  {1:true,0:false}
Property IsAllowNegative As %Library.Boolean [ SqlColumnNumber = 31 ];

/// 是否允许非数字  {1:true,0:false}
Property IsAllowNoNumeric As %Library.Boolean [ SqlColumnNumber = 32 ];

/// 结果判断  {1:true,0:false}
Property IsExcJudgeRule As %Library.Boolean [ SqlColumnNumber = 33 ];

/// 项目类别  
Property ItemClassDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 34 ];

/// 所属科室  
Property DepartmentDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 35 ];

/// 是否实时计算  {1:true,0:false}
Property IsRealCal As %Library.Boolean [ SqlColumnNumber = 36 ];

/// 排除低值  
Property UnacceptLow As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 37 ];

/// 排除高值  
Property UnacceptHigh As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 38 ];

/// 重新编辑  {1:true,0:false}
Property ReEditFlag As %Library.Boolean [ SqlColumnNumber = 39 ];

/// 计算项不计算  {1:true,0:false}
Property NoCalFlag As %Library.Boolean [ SqlColumnNumber = 40 ];

/// 质控项目  
Property QCTestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 41 ];

/// 文本等于校验  {1:true,0:false}
Property CheckEqual As %Library.Boolean [ SqlColumnNumber = 42 ];

///  参考范围只维护正常范围{1:true,0:false}
Property IsNormalRange As %Library.Boolean [ SqlColumnNumber = 43 ];

/// 结果互认标记(0:不互认，1:区域性互认，2：全市，3：全省，4：全国)
Property ShareFlag As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 44 ];

/// 是否允许零值  {1:true,0:false}
Property IsAllowZero As %Library.Boolean [ SqlColumnNumber = 45 ];

/// 评估标准
Property QCPatVisEval As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 46 ];

/// 允许删除  {1:true,0:false}
Property AllowDelete As %Library.Boolean [ SqlColumnNumber = 47 ];

/// 允许拆分  {1:true,0:false}
Property AllowSplit As %Library.Boolean [ SqlColumnNumber = 48 ];

/// 允许追踪  {1:true,0:false}
Property AllowTrace As %Library.Boolean [ SqlColumnNumber = 49 ];

/// 默认结果  
Property DefaultResult As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 50 ];

/// 不导出  {1:true,0:false}
Property IsNoExport As %Library.Boolean [ SqlColumnNumber = 51 ];

/// 允许CV值  
Property CVValue As %Library.Float [ SqlColumnNumber = 52 ];

/// 允许CV值来源  
Property CVSource As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 53 ];

/// 本室的σ值  1:σ<2,2:2≤σ<3,3:3≤σ<4,4:4≤σ<5,5:6≤σ<6,6:σ≥6
Property SigmaValue As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 54 ];

/// 拆分医嘱名称  
Property SplitTSName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 55 ];

Storage Default
{
<Data name="BTTestCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>HospitalDR</Value>
</Value>
<Value name="5">
<Value>LName</Value>
</Value>
<Value name="6">
<Value>EName</Value>
</Value>
<Value name="7">
<Value>Synonym</Value>
</Value>
<Value name="8">
<Value>Units</Value>
</Value>
<Value name="9">
<Value>ResultFormat</Value>
</Value>
<Value name="10">
<Value>Precision</Value>
</Value>
<Value name="11">
<Value>TestMethodDR</Value>
</Value>
<Value name="12">
<Value>IsCalculate</Value>
</Value>
<Value name="13">
<Value>LonicCode</Value>
</Value>
<Value name="14">
<Value>SCode</Value>
</Value>
<Value name="15">
<Value>SOPContent</Value>
</Value>
<Value name="16">
<Value>SOPFile</Value>
</Value>
<Value name="17">
<Value>HISCode</Value>
</Value>
<Value name="18">
<Value>CostItemDR</Value>
</Value>
<Value name="19">
<Value>Price</Value>
</Value>
<Value name="20">
<Value>ClinicalSignifyS</Value>
</Value>
<Value name="21">
<Value>ClinicalSignifyL</Value>
</Value>
<Value name="22">
<Value>TestSetDR</Value>
</Value>
<Value name="23">
<Value>PrintOrder</Value>
</Value>
<Value name="24">
<Value>Sequence</Value>
</Value>
<Value name="25">
<Value>Active</Value>
</Value>
<Value name="26">
<Value>CalculateFormula</Value>
</Value>
<Value name="27">
<Value>RefRanges</Value>
</Value>
<Value name="28">
<Value>IsCheckText</Value>
</Value>
<Value name="29">
<Value>RefField</Value>
</Value>
<Value name="30">
<Value>IsAllowNegative</Value>
</Value>
<Value name="31">
<Value>IsAllowNoNumeric</Value>
</Value>
<Value name="32">
<Value>IsExcJudgeRule</Value>
</Value>
<Value name="33">
<Value>ItemClassDR</Value>
</Value>
<Value name="34">
<Value>DepartmentDR</Value>
</Value>
<Value name="35">
<Value>IsRealCal</Value>
</Value>
<Value name="36">
<Value>UnacceptLow</Value>
</Value>
<Value name="37">
<Value>UnacceptHigh</Value>
</Value>
<Value name="38">
<Value>ReEditFlag</Value>
</Value>
<Value name="39">
<Value>NoCalFlag</Value>
</Value>
<Value name="40">
<Value>QCTestCodeDR</Value>
</Value>
<Value name="41">
<Value>CheckEqual</Value>
</Value>
<Value name="42">
<Value>IsNormalRange</Value>
</Value>
<Value name="43">
<Value>ShareFlag</Value>
</Value>
<Value name="44">
<Value>IsAllowZero</Value>
</Value>
<Value name="45">
<Value>QCPatVisEval</Value>
</Value>
<Value name="46">
<Value>AllowDelete</Value>
</Value>
<Value name="47">
<Value>AllowSplit</Value>
</Value>
<Value name="48">
<Value>AllowTrace</Value>
</Value>
<Value name="49">
<Value>DefaultResult</Value>
</Value>
<Value name="50">
<Value>IsNoExport</Value>
</Value>
<Value name="51">
<Value>CVValue</Value>
</Value>
<Value name="52">
<Value>CVSource</Value>
</Value>
<Value name="53">
<Value>SigmaValue</Value>
</Value>
<Value name="54">
<Value>SplitTSName</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestCodeD</DataLocation>
<DefaultData>BTTestCodeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTTestCodeD</IdLocation>
<IndexLocation>^dbo.BTTestCodeI</IndexLocation>
<StreamLocation>^dbo.BTTestCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
