Class web.DHCWMRMedBaseEPR Extends (%Library.RegisteredObject, websys.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 6;

//取电子病历信息

//SetEPRElementData--设置编码

//GetEPRElementData--取值方法

//***********************************************

//功能说明  ：设置电子病历元数据代码

//          ：所有医院电子病历元数据代码都在这设置,方便查询整理

//          ：不同医院电子病历元数据代码不同

//参数列表  ：

//HospCode  ：医院代码

//w $$SetEPRElementData^DHCWMRMedBaseEPR("BeiJing_AZ")

//***********************************************

ClassMethod SetEPRElementData(HospCode)
{
    n (HospCode)
    s ret=""
    
    ;北京安贞医院
    i HospCode="BeiJing_AZ" d
    .s ^DHCMedEPR("EPR版本")=1
    .s ^DHCMedEPR("MEDNameSpace")="meddata"
    .s ^DHCMedEPR("EPRNameSpace")="websrc"
    .d ..SetEPRElementDataAZ()
    
    ;北京地坛医院
    i HospCode="BeiJing_DT" d
    .s ^DHCMedEPR("EPR版本")=2
    .s ^DHCMedEPR("MEDNameSpace")="dhc-data"
    .s ^DHCMedEPR("EPRNameSpace")="dhc-app"
    .d ..SetEPRElementDataDT()
    
    s ret="Success!!!"
    q ret
}

//***********************************************

//功能说明    ：取电子病历元数据

//参数列表    ：

//Paadm       ：就诊号

//EleCode     ：元数据代码描述

//IsGetCode   ：1表示取该项的代码，0表示取描述 只对字典项目有效

//调试        ：w $$GetEPRElementData^DHCWMRMedBaseEPR(Paadm,EleCode,IsGetCode)

//***********************************************

ClassMethod GetEPRElementData(Paadm, EleCode, IsGetCode)
{
    n (Paadm,EleCode,IsGetCode)
    s ret=""
    q:(Paadm="")||(EleCode="") ret
    s EPREdit=$g(^DHCMedEPR("EPR版本"))
    s IsGetCode=+$g(IsGetCode)
    
    zn $g(^DHCMedEPR("EPRSRC"))   //执行EPR类方法名字空间
    ;s:EPREdit=1 ret=##class(DHC.EPR.GetScatterData).GetItemDataValueV1(Paadm,EleCode,IsGetCode)
    ;s:EPREdit=2 ret=##class(EPRmeta.FPInterface.ExportTable).GetItemDataValueV2ForStat(paadm,EleCode,IsGetCode)
    s ret="测试诊断V"_EPREdit_"G"_IsGetCode
    zn $g(^DHCMedEPR("MEDSRC"))   //返回到MEDSRC名字空间
    
    q ret
}

ClassMethod SetEPRElementDataAZ()
{
    s ^DHCMedEPR("诊断名称","主要诊断")="#{23||6-G-307-edt17|D-T}"
    s ^DHCMedEPR("诊断名称","其它诊断1")="#{23||6-G-307-edt19|D-T}"
    s ^DHCMedEPR("诊断名称","其它诊断2")="#{23||6-G-307-edt21|D-T}"
    s ^DHCMedEPR("诊断名称","其它诊断3")="#{23||6-G-307-edt23|D-T}"
    s ^DHCMedEPR("诊断名称","其它诊断4")="#{23||6-G-307-edt25|D-T}"
    s ^DHCMedEPR("诊断名称","其它诊断5")="#{23||6-G-307-edt27|D-T}"
    s ^DHCMedEPR("诊断名称","其它诊断6")="#{23||6-G-307-edt29|D-T}"
    s ^DHCMedEPR("诊断名称","其它诊断7")="#{23||6-G-307-edt31|D-T}"
    s ^DHCMedEPR("诊断ICD","主要诊断")="#{23||6-G-307-dbx33-T}"
    s ^DHCMedEPR("诊断ICD","其它诊断1")="#{23||6-G-307-dbx35-T}"
    s ^DHCMedEPR("诊断ICD","其它诊断2")="#{23||6-G-307-dbx37-T}"
    s ^DHCMedEPR("诊断ICD","其它诊断3")="#{23||6-G-307-dbx39-T}"
    s ^DHCMedEPR("诊断ICD","其它诊断4")="#{23||6-G-307-dbx41-T}"
    s ^DHCMedEPR("诊断ICD","其它诊断5")="#{23||6-G-307-dbx43-T}"
    s ^DHCMedEPR("诊断ICD","其它诊断6")="#{23||6-G-307-dbx45-T}"
    s ^DHCMedEPR("诊断ICD","其它诊断7")="#{23||6-G-307-dbx47-T}"
    q
}

ClassMethod SetEPRElementDataDT()
{
    s ^DHCMedEPR("诊断","主诊断")="#{23||6-G-307-dbx33-T}"
    s ^DHCMedEPR("诊断","其它诊断1")="#{23||6-G-307-dbx35-T}"
    s ^DHCMedEPR("诊断","其它诊断2")="#{23||6-G-307-dbx37-T}"
    s ^DHCMedEPR("诊断","其它诊断3")="#{23||6-G-307-dbx39-T}"
    s ^DHCMedEPR("诊断","其它诊断4")="#{23||6-G-307-dbx41-T}"
    s ^DHCMedEPR("诊断","其它诊断5")="#{23||6-G-307-dbx43-T}"
    s ^DHCMedEPR("诊断","其它诊断6")="#{23||6-G-307-dbx45-T}"
    s ^DHCMedEPR("诊断","其它诊断7")="#{23||6-G-307-dbx47-T}"
    q
}

//院感取电子病历出院情况诊断信息

//w $$GetEPRDischDiag^DHCWMRMedBaseEPR(1)

ClassMethod GetEPRDischDiag(Paadm)
{
    n (Paadm)
    s ret=""
    s PaadmType=$p($g(^PAADM(Paadm)),"^",2)
    s CTLoc=$p($g(^PAADM(Paadm)),"^",4)
    s LocDesc=CTLoc_"/"_$p($g(^CTLOC(+CTLoc)),"^",2)
    s DiagType=""
    f  s DiagType=$o(^DHCMedEPR("诊断名称",DiagType)) q:DiagType=""  d
    .s (MRDiagDR,ICDDR,ICDDoctorDR,ICDType,ICDDate,ICDTime)=""
    .s EleCode=$g(^DHCMedEPR("诊断名称",DiagType))
    .q:EleCode=""
    .s DiagDesc=..GetEPRElementData(Paadm,EleCode,0)
    .q:DiagDesc=""
    .s MRDiagDR="EPR||"_DiagType
    .s ICDDR="//"_DiagDesc
    .s ICDType="//"_DiagType
    .s ret=ret_Paadm_$c(2)_PaadmType_$c(2)_LocDesc_$c(2)_MRDiagDR_$c(2)_ICDDR_$c(2)_ICDDoctorDR_$c(2)_ICDType_$c(2)_ICDDate_$c(2)_ICDTime_$c(1)
    s:ret'="" ret=$e(ret,1,$l(ret)-1)
    q ret
}

}
