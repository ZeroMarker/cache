Class EMRmeta.DiagRefStyleData Extends %Persistent
{

Index IdxUnitLinkName On UnitLinkName;

Index IdxUnitLinkNameActive On (UnitLinkName, IsActive);

Property Code As %String;

Property Name As %String;

/// 中医诊断 与西医诊断显示的顺序
/// WC 先西医后中医
/// CW 先中医后西医
Property ConfigData As %String;

/// EMRmeta.OPUnitLink 链接单元编码
Property UnitLinkName As %String;

Property IsActive As %String;

/// 效果描述
Property Description As %String(MAXLEN = 5000);

/// 展示Type，初步诊断/修正诊断/……
/// 默认为N，实际业务情况中。
Property DisplayType As %String;

/// 展示Category，西医诊断/中医诊断
Property DisplayCategory As %String;

/// 展示诊断序号
Property OrderNumber As %String;

/// 主要用途，区分中医诊断，病症的显示格式subbehind/sublayer
Property TCMDiagStyle As %String;

/// 诊断的主要格式 Layer/Row
Property MainDiagStyle As %String;

/// d ##class(EMRmeta.DiagRefStyleData).Init()
ClassMethod Init()
{
	&sql(INSERT INTO EMRmeta.DiagRefStyleData (Code, ConfigData, Description, DisplayCategory, DisplayType, IsActive, MainDiagStyle, Name, OrderNumber, TCMDiagStyle, UnitLinkName) VALUES ('Style1', 'WC', '诊断层级模式，中医诊断病症层级显示', 'Y', 'N', 'Y', 'Layer', '综合1(推荐）', 'Y', 'sublayer', 'diagnosesLayerV8'))

    &sql(INSERT INTO EMRmeta.DiagRefStyleData (Code, ConfigData, Description, DisplayCategory, DisplayType, IsActive, MainDiagStyle, Name, OrderNumber, TCMDiagStyle, UnitLinkName) VALUES ('Style2', 'WC', '诊断层级模式，中医诊断症与病同行()内显示', 'Y', 'N', 'Y', 'Layer', '综合2', 'Y', 'subbehind', ''))

    &sql(INSERT INTO EMRmeta.DiagRefStyleData (Code, ConfigData, Description, DisplayCategory, DisplayType, IsActive, MainDiagStyle, Name, OrderNumber, TCMDiagStyle, UnitLinkName) VALUES ('Style3', 'WC', '诊断行模式，中医诊断病症行显示,分号分隔。', 'Y', 'N', 'Y', 'Row', '综合3', 'Y', 'sublayer', ''))

    &sql(INSERT INTO EMRmeta.DiagRefStyleData (Code, ConfigData, Description, DisplayCategory, DisplayType, IsActive, MainDiagStyle, Name, OrderNumber, TCMDiagStyle, UnitLinkName) VALUES ('Style4', 'WC', '诊断行模式，中医诊断症与病同位()内显示，病间分号分隔。', 'Y', 'N', 'Y', 'Row', '综合4', 'Y', 'subbehind', ''))

    &sql(INSERT INTO EMRmeta.DiagRefStyleData (Code, ConfigData, Description, DisplayCategory, DisplayType, IsActive, MainDiagStyle, Name, OrderNumber, TCMDiagStyle, UnitLinkName) VALUES ('Style5', 'CW', '诊断层级模式，中医诊断病症层级显示', 'Y', 'N', 'Y', 'Layer', '专科1', 'Y', 'sublayer', ''))
    
	&sql(INSERT INTO EMRmeta.DiagRefStyleData (Code, ConfigData, Description, DisplayCategory, DisplayType, IsActive, MainDiagStyle, Name, OrderNumber, TCMDiagStyle, UnitLinkName) VALUES ('Style6', 'CW', '诊断层级模式，中医诊断病症同行显示', 'Y', 'N', 'Y', 'Layer', '专科2(推荐）', 'Y', 'subbehind', 'diagnosesRowV8'))

    &sql(INSERT INTO EMRmeta.DiagRefStyleData (Code, ConfigData, Description, DisplayCategory, DisplayType, IsActive, MainDiagStyle, Name, OrderNumber, TCMDiagStyle, UnitLinkName) VALUES ('Style7', 'CW', '诊断行模式，中医诊断病症行显示,分号分隔', 'Y', 'N', 'Y', 'Row', '专科3', 'Y', 'sublayer', ''))

    &sql(INSERT INTO EMRmeta.DiagRefStyleData (Code, ConfigData, Description, DisplayCategory, DisplayType, IsActive, MainDiagStyle, Name, OrderNumber, TCMDiagStyle, UnitLinkName) VALUES ('Style8', 'CW', '诊断行模式，中医诊断症与病同位()内显示，病间分号分隔', 'Y', 'N', 'Y', 'Row', '专科4', 'Y', 'subbehind', ''))

    &sql(INSERT INTO EMRmeta.DiagRefStyleData (Code, ConfigData, Description, DisplayCategory, DisplayType, IsActive, MainDiagStyle, Name, OrderNumber, TCMDiagStyle, UnitLinkName) VALUES ('Style11', 'WC', '诊断层级模式，中医诊断病症层级显示,无序号', 'Y', 'N', 'Y', 'Layer', '综合11(推荐）', 'N', 'sublayer', ''))

    &sql(INSERT INTO EMRmeta.DiagRefStyleData (Code, ConfigData, Description, DisplayCategory, DisplayType, IsActive, MainDiagStyle, Name, OrderNumber, TCMDiagStyle, UnitLinkName) VALUES ('Style12', 'WC', '诊断层级模式，中医诊断症与病同行()内显示，无序号', 'Y', 'N', 'Y', 'Layer', '综合12', 'N', 'subbehind', ''))

    &sql(INSERT INTO EMRmeta.DiagRefStyleData (Code, ConfigData, Description, DisplayCategory, DisplayType, IsActive, MainDiagStyle, Name, OrderNumber, TCMDiagStyle, UnitLinkName) VALUES ('Style13', 'WC', '诊断行模式，中医诊断病症行显示,分号分隔，无序号', 'Y', 'N', 'Y', 'Row', '综合13', 'N', 'sublayer', ''))

    &sql(INSERT INTO EMRmeta.DiagRefStyleData (Code, ConfigData, Description, DisplayCategory, DisplayType, IsActive, MainDiagStyle, Name, OrderNumber, TCMDiagStyle, UnitLinkName) VALUES ('Style14', 'WC', '诊断行模式，中医诊断症与病同位()内显示，病间分号分隔，无序号', 'Y', 'N', 'Y', 'Row', '综合14', 'N', 'subbehind', ''))

    &sql(INSERT INTO EMRmeta.DiagRefStyleData (Code, ConfigData, Description, DisplayCategory, DisplayType, IsActive, MainDiagStyle, Name, OrderNumber, TCMDiagStyle, UnitLinkName) VALUES ('Style15', 'CW', '诊断层级模式，中医诊断病症层级显示，无序号', 'Y', 'N', 'Y', 'Layer', '专科11', 'N', 'sublayer', ''))

    &sql(INSERT INTO EMRmeta.DiagRefStyleData (Code, ConfigData, Description, DisplayCategory, DisplayType, IsActive, MainDiagStyle, Name, OrderNumber, TCMDiagStyle, UnitLinkName) VALUES ('Style16', 'CW', '诊断层级模式，中医诊断病症同行显示，无序号', 'Y', 'N', 'Y', 'Layer', '专科12(推荐）', 'N', 'subbehind', ''))

    &sql(INSERT INTO EMRmeta.DiagRefStyleData (Code, ConfigData, Description, DisplayCategory, DisplayType, IsActive, MainDiagStyle, Name, OrderNumber, TCMDiagStyle, UnitLinkName) VALUES ('Style17', 'CW', '诊断行模式，中医诊断病症行显示,分号分隔，无序号', 'Y', 'N', 'N', 'Row', '专科13', 'N', 'sublayer', ''))

    &sql(INSERT INTO EMRmeta.DiagRefStyleData (Code, ConfigData, Description, DisplayCategory, DisplayType, IsActive, MainDiagStyle, Name, OrderNumber, TCMDiagStyle, UnitLinkName) VALUES ('Style18', 'CW', '诊断行模式，中医诊断症与病同位()内显示，病间分号分隔，无序号', 'Y', 'N', 'N', 'Row', '专科14', 'N', 'subbehind', ''))
}

Storage Default
{
<Data name="DiagRefStyleDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>ConfigData</Value>
</Value>
<Value name="5">
<Value>UnitLinkName</Value>
</Value>
<Value name="6">
<Value>IsActive</Value>
</Value>
<Value name="7">
<Value>Description</Value>
</Value>
<Value name="8">
<Value>DisplayType</Value>
</Value>
<Value name="9">
<Value>DisplayCategory</Value>
</Value>
<Value name="10">
<Value>OrderNumber</Value>
</Value>
<Value name="11">
<Value>TCMDiagStyle</Value>
</Value>
<Value name="12">
<Value>MainDiagStyle</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.DiagRefStyleDataD</DataLocation>
<DefaultData>DiagRefStyleDataDefaultData</DefaultData>
<IdLocation>^DHCEMRM.DiagRefStyleDataD</IdLocation>
<IndexLocation>^DHCEMRM.DiagRefStyleDataI</IndexLocation>
<StreamLocation>^DHCEMRM.DiagRefStyleDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
