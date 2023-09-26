/// 一般人群检查辅助检查
Class CHSS.PersonYearCheckAccessory Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = AccessoryRowId, SqlTableName = PersonYearCheckAccessory ]
{

//随访记录

Property YearCheckRowIdParref As CHSS.PersonYearCheckRecord [ Required ];

// 血红蛋白

Property HB As %String(MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = HB ];

//白细胞

Property WBC As %String(MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = WBC ];

//血小板

Property PLT As %String(MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PLT ];

//血常规其他

Property CBCOther As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = CBCOther ];

//尿蛋白

Property UrineProtein As %String(MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = UrineProtein ];

//尿糖

Property UrineSugar As %String(MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = UrineSugar ];

//尿酮体

Property KET As %String(MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = KET ];

//尿潜血

Property OccultBlood As %String(MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = OccultBlood ];

//尿常规其他

Property UrineRoutineOther As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = UrineRoutineOther ];

//大便潜血

Property FecalOccultBlood As CHSS.DictFecalOccultBlood [ SqlColumnNumber = 11, SqlFieldName = FecalOccultBlood ];

//谷丙转氨酶

Property ALT As %String(MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = ALT ];

//谷草转氨酶

Property AST As %String(MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = AST ];

//白蛋白

Property ALB As %String(MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = ALB ];

//总胆红素

Property TBIL As %String(MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = TBIL ];

//结合胆红素

Property DBIL As %String(MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = DBIL ];

//血肌酐

Property Scr As %String(MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = Scr ];

//尿素氮

Property BUN As %String(MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = BUN ];

//总胆固醇标准值

Property CHO As %String(MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = CHO ];

//甘油三脂

Property TG As %String(MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = TG ];

//低密度脂蛋白胆固醇

Property LDLC As %String(MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = LDLC ];

//高密度脂蛋白胆固醇

Property HDLC As %String(MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = HDLC ];

//空腹血糖

Property FPG As %Float [ SqlColumnNumber = 23, SqlFieldName = FPG ];

//餐后两小时血糖

Property PBG As %Float [ SqlColumnNumber = 24, SqlFieldName = PBG ];

//眼底

Property Eyeground As %String(MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 25, SqlFieldName = Eyeground ];

//乙肝表面抗原

Property HBsAg As CHSS.DictHBVTag [ SqlColumnNumber = 26, SqlFieldName = HBsAg ];

//

Property HbsAb As CHSS.DictHBVTag;

//糖化血红蛋白

Property HbAlc As %Float [ SqlColumnNumber = 27, SqlFieldName = HbAlc ];

//眼底异常

Property EyegroundInfo As %String(MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = EyegroundInfo ];

//心电图

Property Cardiogram As %String(MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 29, SqlFieldName = Cardiogram ];

//心电图异常

Property CardiogramInfo As %String(MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = CardiogramInfo ];

//胸片

Property Sternum As %String(MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 31, SqlFieldName = Sternum ];

//胸片来源

Property SternumSource As CHSS.DictSternumSource;

//胸片异常

Property SternumInfo As %String(MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 32, SqlFieldName = SternumInfo ];

//胸部X线检查结果

Property XRays As %String(MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 33, SqlFieldName = XRays ];

//B超检查结果

Property XRaysInfo As %String(MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 34, SqlFieldName = XRaysInfo ];

//影像检查

Property ImageCheck As %String(MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 35, SqlFieldName = ImageCheck ];

//总胆固醇

Property Cholesterin As %String(MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 36, SqlFieldName = Cholesterin ];

//其他

Property OtherCheck As %String(MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 37, SqlFieldName = OtherCheck ];

//尿液酸碱度

Property PH As %Float [ SqlColumnNumber = 38, SqlFieldName = PH ];

//癌胚抗原浓度值

Property CEA As %Float [ SqlColumnNumber = 39, SqlFieldName = CEA ];

//甲胎蛋白值

Property AFP As %Float [ SqlColumnNumber = 40, SqlFieldName = AFP ];

//球蛋白

Property Globulin As %String(MAXLEN = 10, TRUNCATE = 1);

//GGT

Property GGT As %String(MAXLEN = 10, TRUNCATE = 1);

//ARP

Property ARP As %String(MAXLEN = 10, TRUNCATE = 1);

Index YearCheckRowIdParrefIndex On YearCheckRowIdParref [ Unique ];

Storage Default
{
<Data name="PersonYearCheckAccessoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ALB</Value>
</Value>
<Value name="3">
<Value>ALT</Value>
</Value>
<Value name="4">
<Value>AST</Value>
</Value>
<Value name="5">
<Value>BUN</Value>
</Value>
<Value name="6">
<Value>CBCOther</Value>
</Value>
<Value name="7">
<Value>CHO</Value>
</Value>
<Value name="8">
<Value>Cardiogram</Value>
</Value>
<Value name="9">
<Value>CardiogramInfo</Value>
</Value>
<Value name="10">
<Value>Cholesterin</Value>
</Value>
<Value name="11">
<Value>DBIL</Value>
</Value>
<Value name="12">
<Value>Eyeground</Value>
</Value>
<Value name="13">
<Value>EyegroundInfo</Value>
</Value>
<Value name="14">
<Value>FPG</Value>
</Value>
<Value name="15">
<Value>FecalOccultBlood</Value>
</Value>
<Value name="16">
<Value>HB</Value>
</Value>
<Value name="17">
<Value>HBsAg</Value>
</Value>
<Value name="18">
<Value>HDLC</Value>
</Value>
<Value name="19">
<Value>HbAlc</Value>
</Value>
<Value name="20">
<Value>ImageCheck</Value>
</Value>
<Value name="21">
<Value>KET</Value>
</Value>
<Value name="22">
<Value>LDLC</Value>
</Value>
<Value name="23">
<Value>OccultBlood</Value>
</Value>
<Value name="24">
<Value>OtherCheck</Value>
</Value>
<Value name="25">
<Value>PBG</Value>
</Value>
<Value name="26">
<Value>PLT</Value>
</Value>
<Value name="27">
<Value>Scr</Value>
</Value>
<Value name="28">
<Value>Sternum</Value>
</Value>
<Value name="29">
<Value>SternumInfo</Value>
</Value>
<Value name="30">
<Value>TBIL</Value>
</Value>
<Value name="31">
<Value>TG</Value>
</Value>
<Value name="32">
<Value>UrineProtein</Value>
</Value>
<Value name="33">
<Value>UrineRoutineOther</Value>
</Value>
<Value name="34">
<Value>UrineSugar</Value>
</Value>
<Value name="35">
<Value>WBC</Value>
</Value>
<Value name="36">
<Value>XRays</Value>
</Value>
<Value name="37">
<Value>XRaysInfo</Value>
</Value>
<Value name="38">
<Value>AFP</Value>
</Value>
<Value name="39">
<Value>CEA</Value>
</Value>
<Value name="40">
<Value>PH</Value>
</Value>
<Value name="41">
<Value>YearCheckRowIdParref</Value>
</Value>
<Value name="42">
<Value>ARP</Value>
</Value>
<Value name="43">
<Value>GGT</Value>
</Value>
<Value name="44">
<Value>Globulin</Value>
</Value>
<Value name="45">
<Value>HBsAb</Value>
</Value>
<Value name="46">
<Value>SternumSource</Value>
</Value>
<Value name="47">
<Value>HbsAb</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonYearCheckAccessoryD</DataLocation>
<DefaultData>PersonYearCheckAccessoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonYearCheckAccessoryD</IdLocation>
<IndexLocation>^CHSS.PersonYearCheckAccessoryI</IndexLocation>
<StreamLocation>^CHSS.PersonYearCheckAccessoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
