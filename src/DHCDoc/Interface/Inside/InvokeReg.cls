/// creator:guorongyong
/// date:2020-06-15
/// desc:和东华医为内部系统的接口类【主要调用其他产品组的接口】，仅患者管理（主索引相关），本类不收录医生站其他产生线与内部的接口
Class DHCDoc.Interface.Inside.InvokeReg Extends %RegisteredObject
{

/// Creator:      宋春莉
/// CreatDate:    2019.01.14
/// Description:  获取患者年龄
/// Table:        
/// Input:       Papmi:患者ID Adm:就诊ID HospId: CT_Hospital.HOSP_RowId(传入就诊时可不传)
/// Return:      0：非皮试用法医嘱 1：皮试用法医嘱
/// Others:      w ##class(DHCDoc.Interface.Inside.InvokeReg).GetPapmiAge()
ClassMethod GetPapmiAge(Papmi As %String, Adm As %String = "", HospId As %String = "", ParamAdmDate As %String = "", ParamAdmTime As %String = "")
{
	Q ##class(web.DHCBillInterface).GetPapmiAge(Papmi,Adm,HospId,ParamAdmDate,ParamAdmTime)
}

/// Creator: 宋春莉
/// CreatDate: 2019.01.14
/// Description: 保存新生儿年龄，给其他组的接口
/// Input:	papmiDr:新生儿id，birthDate:新生儿出生日期
/// 				birthTime:出生时间
/// Output:	rtn:0保存成功， -1保存失败	-2该id已存了年齡
/// Debug:	w ##class(DHCDoc.Interface.Inside.InvokeReg).ISaveNewBabyDob("1","63247","25201")
ClassMethod ISaveNewBabyDob(papmi As %String, birthDate As %String, birthTime As %String)
{
	Q ##class(web.DHCBillInterface).ISaveNewBabyDob(papmi, birthDate, birthTime)
}

}
