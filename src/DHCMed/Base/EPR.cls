/// 取电子病历信息类
/// 名称: DHCMed.Base.EPR
/// 描述: 取电子病历信息类
/// 编写者：陈剑波
/// 编写日期: 2010-09-17
Class DHCMed.Base.EPR Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

//***********************************************

//功能说明  ：设置电子病历元数据代码

//          ：所有医院电子病历元数据代码都在这设置,方便查询整理

//          ：不同医院电子病历元数据代码不同

//参数列表  ：

//HospCode  ：医院代码

//w ##class(DHCMed.Base.EPR).SetEPRElementData("NingXia_NYFY")

//w ##class(DHCMed.Base.EPR).SetEPRElementData("BeiJing_FX")

//***********************************************

ClassMethod SetEPRElementData(HospCode) As %String
{
	n (HospCode)
    s ret=""    
    k ^DHCMedEPR
    
    ;北京安贞医院
    i HospCode="BeiJing_AZ" d
    .s ^DHCMedEPR("EPR版本")=1
    .s ^DHCMedEPR("MEDNameSpace")="meddatant"
    .s ^DHCMedEPR("EPRNameSpace")="websource"
    .d SetEPRElementDataAZ
    
    ;北京地坛医院
    i HospCode="BeiJing_DT" d
    .s ^DHCMedEPR("EPR版本")=2
    .s ^DHCMedEPR("MEDNameSpace")="DHC-App"
    .s ^DHCMedEPR("EPRNameSpace")="DHC-App"
    .d SetEPRElementDataDT
    
    ;宁夏宁医附院
    i HospCode="NingXia_NYFY" d
    .s ^DHCMedEPR("EPR版本")=2
    .s ^DHCMedEPR("MEDNameSpace")="meddata"
    .s ^DHCMedEPR("EPRNameSpace")="websrc"
    .d SetEPRElementDataNYFY
    
    ;北京复兴
    i HospCode="BeiJing_FX" d
    .s ^DHCMedEPR("EPR版本")=1
    .s ^DHCMedEPR("MEDNameSpace")="meddata"
    .s ^DHCMedEPR("EPRNameSpace")="EPR"
    .d SetEPRElementDataBJFX
    s ret="Success!!!"
    q ret
SetEPRElementDataAZ
    s ^DHCMedEPR("诊断名称","主要诊断","主要诊断")="#{23||6-G-307-edt17|D-T}"
    s ^DHCMedEPR("诊断名称","其它诊断","其它诊断1")="#{23||6-G-307-edt19|D-T}"
    s ^DHCMedEPR("诊断名称","其它诊断","其它诊断2")="#{23||6-G-307-edt21|D-T}"
    s ^DHCMedEPR("诊断名称","其它诊断","其它诊断3")="#{23||6-G-307-edt23|D-T}"
    s ^DHCMedEPR("诊断名称","其它诊断","其它诊断4")="#{23||6-G-307-edt25|D-T}"
    s ^DHCMedEPR("诊断名称","其它诊断","其它诊断5")="#{23||6-G-307-edt27|D-T}"
    s ^DHCMedEPR("诊断名称","其它诊断","其它诊断6")="#{23||6-G-307-edt29|D-T}"
    s ^DHCMedEPR("诊断名称","其它诊断","其它诊断7")="#{23||6-G-307-edt31|D-T}"
    s ^DHCMedEPR("诊断ICD","主要诊断","主要诊断")="#{23||6-G-307-dbx33-T}"
    s ^DHCMedEPR("诊断ICD","其它诊断","其它诊断1")="#{23||6-G-307-dbx35-T}"
    s ^DHCMedEPR("诊断ICD","其它诊断","其它诊断2")="#{23||6-G-307-dbx37-T}"
    s ^DHCMedEPR("诊断ICD","其它诊断","其它诊断3")="#{23||6-G-307-dbx39-T}"
    s ^DHCMedEPR("诊断ICD","其它诊断","其它诊断4")="#{23||6-G-307-dbx41-T}"
    s ^DHCMedEPR("诊断ICD","其它诊断","其它诊断5")="#{23||6-G-307-dbx43-T}"
    s ^DHCMedEPR("诊断ICD","其它诊断","其它诊断6")="#{23||6-G-307-dbx45-T}"
    s ^DHCMedEPR("诊断ICD","其它诊断","其它诊断7")="#{23||6-G-307-dbx47-T}"
    q
    
SetEPRElementDataDT
    s ^DHCMedEPR("诊断名称","主要诊断","主诊断")="#{23||6-G-307-dbx33-T}"
    s ^DHCMedEPR("诊断名称","其它诊断","其它诊断1")="#{23||6-G-307-dbx35-T}"
    s ^DHCMedEPR("诊断名称","其它诊断","其它诊断2")="#{23||6-G-307-dbx37-T}"
    s ^DHCMedEPR("诊断名称","其它诊断","其它诊断3")="#{23||6-G-307-dbx39-T}"
    s ^DHCMedEPR("诊断名称","其它诊断","其它诊断4")="#{23||6-G-307-dbx41-T}"
    s ^DHCMedEPR("诊断名称","其它诊断","其它诊断5")="#{23||6-G-307-dbx43-T}"
    s ^DHCMedEPR("诊断名称","其它诊断","其它诊断6")="#{23||6-G-307-dbx45-T}"
    s ^DHCMedEPR("诊断名称","其它诊断","其它诊断7")="#{23||6-G-307-dbx47-T}"
    q
    
SetEPRElementDataNYFY
    s ^DHCMedEPR("诊断名称","初步诊断","儿内初步诊断儿急用")="#TYPE:TextDesc#TID:435#TVER:0#ECODE:E0001"
    s ^DHCMedEPR("诊断名称","初步诊断","儿内初步诊断")="#TYPE:TextDesc#TID:255#TVER:0#ECODE:E0001"
    s ^DHCMedEPR("诊断名称","初步诊断","外科初步诊断产科用")="#TYPE:TextDesc#TID:473#TVER:0#ECODE:E0014"
    s ^DHCMedEPR("诊断名称","初步诊断","外科初步诊断")="#TYPE:TextDesc#TID:155#TVER:0#ECODE:E0014"
    s ^DHCMedEPR("诊断名称","初步诊断","内科初步诊断")="#TYPE:TextDesc#TID:174#TVER:0#ECODE:E0014"
    s ^DHCMedEPR("诊断名称","初步诊断","产科初步诊断")="#TYPE:TextDesc#TID:389#TVER:0#ECODE:E0001"
    s ^DHCMedEPR("诊断名称","初步诊断","儿急初步诊断")="#TYPE:TextDesc#TID:294#TVER:0#ECODE:E0001"
    s ^DHCMedEPR("诊断名称","初步诊断","神内初步诊断")="#TYPE:TextDesc#TID:208#TVER:0#ECODE:E0014"
    s ^DHCMedEPR("诊断名称","初步诊断","神外初步诊断")="#TYPE:TextDesc#TID:369#TVER:0#ECODE:E0014"
    q
 
SetEPRElementDataBJFX
    s ^DHCMedEPR("诊断名称","主要诊断","主要诊断")="#{44||2-G-1017-dbx167-T}"
    //s ^DHCMedEPR("诊断名称","入院诊断","入院诊断")="#{23||6-G-307-edt19|D-T}"
    //s ^DHCMedEPR("诊断名称","其它诊断","其它诊断2")="#{23||6-G-307-edt21|D-T}"
    //s ^DHCMedEPR("诊断名称","其它诊断","其它诊断3")="#{23||6-G-307-edt23|D-T}"
    //s ^DHCMedEPR("诊断名称","其它诊断","其它诊断4")="#{23||6-G-307-edt25|D-T}"
    //s ^DHCMedEPR("诊断名称","其它诊断","其它诊断5")="#{23||6-G-307-edt27|D-T}"
    //s ^DHCMedEPR("诊断名称","其它诊断","其它诊断6")="#{23||6-G-307-edt29|D-T}"
    //s ^DHCMedEPR("诊断名称","其它诊断","其它诊断7")="#{23||6-G-307-edt31|D-T}"
    s ^DHCMedEPR("诊断ICD","主要诊断","主要诊断")="#{44||2-G-1017-dbx167-C}"
    //s ^DHCMedEPR("诊断ICD","入院诊断","入院诊断")="#{23||6-G-307-dbx35-T}"
    //s ^DHCMedEPR("诊断ICD","其它诊断","其它诊断2")="#{23||6-G-307-dbx37-T}"
    //s ^DHCMedEPR("诊断ICD","其它诊断","其它诊断3")="#{23||6-G-307-dbx39-T}"
    //s ^DHCMedEPR("诊断ICD","其它诊断","其它诊断4")="#{23||6-G-307-dbx41-T}"
    //s ^DHCMedEPR("诊断ICD","其它诊断","其它诊断5")="#{23||6-G-307-dbx43-T}"
    //s ^DHCMedEPR("诊断ICD","其它诊断","其它诊断6")="#{23||6-G-307-dbx45-T}"
    //s ^DHCMedEPR("诊断ICD","其它诊断","其它诊断7")="#{23||6-G-307-dbx47-T}"
    q
}

//***********************************************

//功能说明    ：取电子病历元数据

//参数列表    ：

//Paadm       ：就诊号

//EleCode     ：元数据代码描述

//IsGetCode   ：1表示取该项的代码，0表示取描述 只对字典项目有效

//调试        ：w ##class(DHCMed.Base.EPR).GetEPRElementData(Paadm,EleCode,IsGetCode)

ClassMethod GetEPRElementData(Paadm As %String = "", EleCode As %String = "", IsGetCode As %String = "") As %String
{
	n (Paadm,EleCode,IsGetCode)
    s ret=""
    q:(Paadm="")||(EleCode="") ret
    s EPREdit=$g(^DHCMedEPR("EPR版本"))
    s IsGetCode=+$g(IsGetCode)
    zn $g(^DHCMedEPR("EPRNameSpace"))   //执行EPR类方法名字空间
    //s:EPREdit=1 ret=##class(DHC.EPR.GetScatterData).GetItemDataValueV1(Paadm,EleCode,IsGetCode)
    s:EPREdit=1 ret=##class(DHC.EPR.FPInterface.ExportTable).GetItemDataValueV1ForStat(Paadm,EleCode,IsGetCode)
    s:EPREdit=2 ret=##class(EPRmeta.FPInterface.ExportTable).GetItemDataValueV2ForStat(Paadm,EleCode,IsGetCode)
    //s ret="测试诊断V"_EPREdit_"G"_IsGetCode
    zn $g(^DHCMedEPR("MEDNameSpace"))   //返回到MEDSRC名字空间
    q ret
}

Storage Default
{
<Data name="EPRDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCMed.Base.EPRD</DataLocation>
<DefaultData>EPRDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.Base.EPRD</IdLocation>
<IndexLocation>^DHCMed.Base.EPRI</IndexLocation>
<StreamLocation>^DHCMed.Base.EPRS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
