Import SQLUser

/// by wuqk 2009-06-12
/// 名称: 	  DHCMedEpidemicService
/// 描述: 	  传染病管理对外接口
/// 编写者：  wuqk
/// 编写日期: 2009-06-12
Class web.DHCMedEpidemicService Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 8;

/// Creator：    wuqk
/// CreatDate：  2009-06-12
/// Description：提供检查某个ICD代码是否为传染病诊断
/// Table：      DHC_MedInfection
/// Input：      MRICD: ICD代码
/// Return：     整数: >0 则为传染病诊断;  =0 非传染病诊断
ClassMethod CheckICD(MRICD) As %Integer
{
      n (MRICD)
      q:MRICD="" 0
      s flag=0,OutFlag=""
      s:$d(^DHCMIF("0","ICD",MRICD)) flag=$o(^DHCMIF("0","ICD",MRICD,""),-1)
      q:flag'=0 +flag
      
      s MIFICD=$p(MRICD,".",1)      
      s MIFICD=$o(^DHCMIF("0","ICD",MIFICD),-1)
      f  s MIFICD=$o(^DHCMIF("0","ICD",MIFICD)) q:(MIFICD="")!(MRICD'[MIFICD)!(flag>0)  d
      .s:MRICD[MIFICD flag=$o(^DHCMIF("0","ICD",MIFICD,""),-1)
      q +flag
}

}
