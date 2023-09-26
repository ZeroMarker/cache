Class CHSSWeb.HISInterface.PersonAccessoryCheckInfo Extends %Persistent
{

Property AccessoryRowId As %Integer;

// 血红蛋白

Property HB As %String(MAXLEN = 10, TRUNCATE = 1);

//白细胞

Property WBC As %String(MAXLEN = 10, TRUNCATE = 1);

//血小板

Property PLT As %String(MAXLEN = 10, TRUNCATE = 1);

//血常规其他

Property CBCOther As %String(MAXLEN = 30, TRUNCATE = 1);

//尿蛋白

Property UrineProtein As %String(MAXLEN = 10, TRUNCATE = 1);

//尿糖

Property UrineSugar As %String(MAXLEN = 10, TRUNCATE = 1);

//尿酮体

Property KET As %String(MAXLEN = 10, TRUNCATE = 1);

//尿潜血

Property OccultBlood As %String(MAXLEN = 10, TRUNCATE = 1);

//尿常规其他

Property UrineRoutineOther As %String(MAXLEN = 30, TRUNCATE = 1);

//大便潜血CHSS.DictFecalOccultBlood

Property FecalOccultBloodId As %Integer;

Property FecalOccultBlood As %String;

//谷丙转氨酶

Property ALT As %String(MAXLEN = 10, TRUNCATE = 1);

//谷草转氨酶

Property AST As %String(MAXLEN = 10, TRUNCATE = 1);

//白蛋白

Property ALB As %String(MAXLEN = 10, TRUNCATE = 1);

//总胆红素

Property TBIL As %String(MAXLEN = 10, TRUNCATE = 1);

//结合胆红素

Property DBIL As %String(MAXLEN = 10, TRUNCATE = 1);

//血肌酐

Property Scr As %String(MAXLEN = 10, TRUNCATE = 1);

//尿素氮

Property BUN As %String(MAXLEN = 10, TRUNCATE = 1);

//总胆固醇标准值

Property CHO As %String(MAXLEN = 10, TRUNCATE = 1);

//甘油三脂

Property TG As %String(MAXLEN = 10, TRUNCATE = 1);

//低密度脂蛋白胆固醇

Property LDLC As %String(MAXLEN = 10, TRUNCATE = 1);

//高密度脂蛋白胆固醇

Property HDLC As %String(MAXLEN = 10, TRUNCATE = 1);

//空腹血糖

Property FPG As %Float;

//餐后两小时血糖

Property PBG As %Float;

//眼底

Property Eyeground As %String(MAXLEN = 5, TRUNCATE = 1);

//乙肝表面抗原CHSS.DictHBVTag

Property HBsAgId As %Integer;

Property HBsAg As %String;

//

Property HbsAbId As %Integer;

Property HbsAb As %String;

//糖化血红蛋白

Property HbAlc As %Float;

//眼底异常

Property EyegroundInfo As %String(MAXLEN = 100, TRUNCATE = 1);

//心电图

Property Cardiogram As %String(MAXLEN = 5, TRUNCATE = 1);

//心电图异常

Property CardiogramInfo As %String(MAXLEN = 100, TRUNCATE = 1);

//胸片

Property Sternum As %String(MAXLEN = 5, TRUNCATE = 1);

//胸片来源CHSS.DictSternumSource

Property SternumSourceId As %Integer;

Property SternumSource As %String;

//胸片异常

Property SternumInfo As %String(MAXLEN = 100, TRUNCATE = 1);

//胸部X线检查结果

Property XRays As %String(MAXLEN = 100, TRUNCATE = 1);

//B超检查结果

Property XRaysInfo As %String(MAXLEN = 100, TRUNCATE = 1);

//影像检查

Property ImageCheck As %String(MAXLEN = 100, TRUNCATE = 1);

//总胆固醇

Property Cholesterin As %String(MAXLEN = 10, TRUNCATE = 1);

//其他

Property AccessoryOther As %String(MAXLEN = 100, TRUNCATE = 1);

//尿液酸碱度

Property PH As %Float;

//癌胚抗原浓度值

Property CEA As %Float;

//甲胎蛋白值

Property AFP As %Float;

//球蛋白

Property Globulin As %String(MAXLEN = 10, TRUNCATE = 1);

//GGT

Property GGT As %String(MAXLEN = 10, TRUNCATE = 1);

//ARP

Property ARP As %String(MAXLEN = 10, TRUNCATE = 1);

Storage Default
{
<Data name="PersonAccessoryCheckInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AFP</Value>
</Value>
<Value name="3">
<Value>ALB</Value>
</Value>
<Value name="4">
<Value>ALT</Value>
</Value>
<Value name="5">
<Value>ARP</Value>
</Value>
<Value name="6">
<Value>AST</Value>
</Value>
<Value name="7">
<Value>BUN</Value>
</Value>
<Value name="8">
<Value>CBCOther</Value>
</Value>
<Value name="9">
<Value>CEA</Value>
</Value>
<Value name="10">
<Value>CHO</Value>
</Value>
<Value name="11">
<Value>Cardiogram</Value>
</Value>
<Value name="12">
<Value>CardiogramInfo</Value>
</Value>
<Value name="13">
<Value>Cholesterin</Value>
</Value>
<Value name="14">
<Value>DBIL</Value>
</Value>
<Value name="15">
<Value>Eyeground</Value>
</Value>
<Value name="16">
<Value>EyegroundInfo</Value>
</Value>
<Value name="17">
<Value>FPG</Value>
</Value>
<Value name="18">
<Value>FecalOccultBloodDes</Value>
</Value>
<Value name="19">
<Value>FecalOccultBloodRowId</Value>
</Value>
<Value name="20">
<Value>GGT</Value>
</Value>
<Value name="21">
<Value>Globulin</Value>
</Value>
<Value name="22">
<Value>HB</Value>
</Value>
<Value name="23">
<Value>HBsAgDes</Value>
</Value>
<Value name="24">
<Value>HBsAgRowId</Value>
</Value>
<Value name="25">
<Value>HDLC</Value>
</Value>
<Value name="26">
<Value>HbAlc</Value>
</Value>
<Value name="27">
<Value>HbsAbDes</Value>
</Value>
<Value name="28">
<Value>HbsAbRowId</Value>
</Value>
<Value name="29">
<Value>ImageCheck</Value>
</Value>
<Value name="30">
<Value>KET</Value>
</Value>
<Value name="31">
<Value>LDLC</Value>
</Value>
<Value name="32">
<Value>OccultBlood</Value>
</Value>
<Value name="33">
<Value>OtherCheck</Value>
</Value>
<Value name="34">
<Value>PBG</Value>
</Value>
<Value name="35">
<Value>PH</Value>
</Value>
<Value name="36">
<Value>PLT</Value>
</Value>
<Value name="37">
<Value>Scr</Value>
</Value>
<Value name="38">
<Value>Sternum</Value>
</Value>
<Value name="39">
<Value>SternumInfo</Value>
</Value>
<Value name="40">
<Value>SternumSourceDes</Value>
</Value>
<Value name="41">
<Value>SternumSourceRowId</Value>
</Value>
<Value name="42">
<Value>TBIL</Value>
</Value>
<Value name="43">
<Value>TG</Value>
</Value>
<Value name="44">
<Value>UrineProtein</Value>
</Value>
<Value name="45">
<Value>UrineRoutineOther</Value>
</Value>
<Value name="46">
<Value>UrineSugar</Value>
</Value>
<Value name="47">
<Value>WBC</Value>
</Value>
<Value name="48">
<Value>XRays</Value>
</Value>
<Value name="49">
<Value>XRaysInfo</Value>
</Value>
<Value name="50">
<Value>FecalOccultBlood</Value>
</Value>
<Value name="51">
<Value>FecalOccultBloodId</Value>
</Value>
<Value name="52">
<Value>HBsAg</Value>
</Value>
<Value name="53">
<Value>HBsAgId</Value>
</Value>
<Value name="54">
<Value>HbsAb</Value>
</Value>
<Value name="55">
<Value>HbsAbId</Value>
</Value>
<Value name="56">
<Value>SternumSource</Value>
</Value>
<Value name="57">
<Value>SternumSourceId</Value>
</Value>
<Value name="58">
<Value>AccessoryRowId</Value>
</Value>
<Value name="59">
<Value>AccessoryOther</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.PersonAccess98DD</DataLocation>
<DefaultData>PersonAccessoryCheckInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.PersonAccess98DD</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.PersonAccess98DI</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.PersonAccess98DS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
