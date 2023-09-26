Class User.NewClass123 Extends %RegisteredObject
{

/// w ##class(User.NewClass123).jiasihanCPB("贾思涵产品部")
ClassMethod jiasihanCPB(PAPMIName As %String = " ")
{
    q:PAPMIName="" "病人姓名为空"
    s papamiRowid=""
    s name=$ZConvert(PAPMIName,"U")
    s papamiRowid = $o(^PAPERi("PAPER_PatName",name,papamiRowid))
    q:papamiRowid="" "病人姓名不存在"
    
    //循环嵌套查找病人就诊类型
    s paAdmType =" "
    s count = 0
    for{
        s paAdmType = $o(^PAPERdr(papamiRowid,"ADM",paAdmType))
        q:paAdmType=""
        s paAdmRowid=""
        for{
            s paAdmRowid=$o(^PAPERdr(papamiRowid,"ADM",paAdmType,paAdmRowid))
            q:paAdmRowid=""
            s count = count + 1
         }
    }
    q count
}

}
