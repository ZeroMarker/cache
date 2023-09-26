Class web.DHCThreePage Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
 //w "[{text:'fold2',id:'fold2',leaf:false,children:[{text:'itm21',id:'itm21',leaf:false,children:[{text:'ver211',id:'ver211',leaf:true}]},{text:'itm22',id:'itm22',leaf:false,children:[{text:'ver221',id:'ver221',leaf:true}]}]}]"}
  w "[{text:'生命体征数据录入',id:'DHCPregnacyPersonStatus',leaf:true},"
  w "{text:'体格检查',id:'DHCPregnacyExam',leaf:true},"
  w "{text:'本次妊娠情况',id:'DHCPregnacyCurrStatus',leaf:true},"
  w "{text:'骨盆测量情况',id:'DHCPregnacyPevilcScale',leaf:true},"
  w "{text:'分娩方式评估',id:'DHCPregnacyEvaluate',leaf:true},"
  w "{text:'妊娠图',id:'dhcpapregimg',leaf:true},"
  w "{text:'诊疗记录',id:'DHCPregnacyRecord',leaf:true}"
  w "]"
  Quit $$$OK
}

}
