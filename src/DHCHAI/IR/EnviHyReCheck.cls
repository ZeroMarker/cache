/// 描述: 环境卫生学不正确原因键值对 （闭环管理）
/// 编写日期: 2022-06-15
Class DHCHAI.IR.EnviHyReCheck Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 环境卫生学ID
Property EHKey As %String;

///  环境卫生学原因和改进措施
Property EHValue As DHCHAI.IR.EnviHyBuildToCheck;

Index keyIndex On EHKey As Exact;

ClassMethod GetValue(key As %String) As %String
{
    new (key)
    Set return=""
    Quit:key=""
    Set aId=$o(^MA.HAI.IR.EnviHyReCheckI("keyIndex",key,""))
    q:aId="" ""
    
    Set obj=##class(DHCHAI.IR.EnviHyReCheck).%OpenId(aId)
    Set:$IsObject(obj.EHValue) return=obj.EHValue.ToString()
    
    Quit return
}

ClassMethod SetValue(key As %String, value As %String) As %String
{
    new (key,value)
    Set aId=$o(^MA.HAI.IR.EnviHyReCheckI("keyIndex",key,""))

    if ##class(DHCHAI.IR.EnviHyReCheck).%ExistsId(aId){
        Set obj=##class(DHCHAI.IR.EnviHyReCheck).%OpenId(aId)
    } else {
         Set obj=##class(DHCHAI.IR.EnviHyReCheck).%New()
    }
    
    Set obj.EHKey=key
    Set obj.EHValue=##class(DHCHAI.IR.EnviHyBuildToCheck).GetObj(value)
    Set sc=obj.%Save()
    
    If $system.Status.IsError(sc) {        //检查Save是否成功
        Do $system.OBJ.DisplayError(sc) 
        Set return=-1
    }Else{
        Set return=obj.%Id()
    }
    Do obj.%Close()
    Quit 1
}

ClassMethod Del(key As %String) As %String
{
    new (key)
    Set aId=$o(^MA.HAI.IR.EnviHyReCheckI("keyIndex",key,""))
    q:aId="" 0
    
    Set obj=##class(DHCHAI.IR.EnviHyReCheck).%DeleteId(aId)
    
    Set sc=obj.%Save()
    If $system.Status.IsError(sc) {        //检查Save是否成功
        Do $system.OBJ.DisplayError(sc) 
        Set return=-1
    }Else{
        Set return=obj.%Id()
    }
    Do obj.%Close()
    quit 1
}

///  Input：       id:    DHCHAI.IR.EnviHyReCheck.EHKey
///  Return：      返回 >=1,成功 "",有问题
///  w ##class(DHCHAI.IR.EnviHyReCheck).convert1(1)
///  环境卫生学不合格指向,从复检前ID修改成复检后的ID
/// Set key="" For { Set key=$o(^MA.HAI.IR.EnviHyReCheckI("keyIndex",key))  Quit:key=""  W ##class(DHCHAI.IR.EnviHyReCheck).convert1(key),! }
ClassMethod convert1(key As %String) As %String
{
    new (key)
    Set return=""
    Quit:key="" return
    Set aId=$o(^MA.HAI.IR.EnviHyReCheckI("keyIndex",key,""))
    
    if ##class(DHCHAI.IR.EnviHyReCheck).%ExistsId(+aId){
        Set obj=##class(DHCHAI.IR.EnviHyReCheck).%OpenId(+aId)
        
        Set nEHKey= $o(^DHCHAI.IR.EnviHyReportI("IdxReCheckRepDr"," "_key,""))
        Quit:nEHKey="" return
        ; 可以判断一下EHKey(原报告)是否合格
        Set obj.EHKey = nEHKey
        Set sc=obj.%Save()
        If $system.Status.IsError(sc) {        //检查Save是否成功
            Do $system.OBJ.DisplayError(sc) 
            Set return=-1
        }Else{
            Set return=obj.EHKey
        }
        Do obj.%Close()
    } 
    Quit return
}

///  Input：       id:    DHCHAI.IR.EnviHyReCheck.EHKey
///  Return：      返回 >=1,成功 "",有问题
///  w ##class(DHCHAI.IR.EnviHyReCheck).convert2(1)
///  环境卫生学不合格指向,从复检后ID修改成复检前的ID  
///  Set key="" For { Set key=$o(^MA.HAI.IR.EnviHyReCheckI("keyIndex",key))  quit:key=""  w ##class(DHCHAI.IR.EnviHyReCheck).convert2(key),! }
ClassMethod convert2(key As %String) As %String
{
    new (key)
    Set return=""
    Quit:key="" return
    Set aId=$o(^MA.HAI.IR.EnviHyReCheckI("keyIndex",key,""))

    if ##class(DHCHAI.IR.EnviHyReCheck).%ExistsId(+aId){
        Set obj=##class(DHCHAI.IR.EnviHyReCheck).%OpenId(+aId)
       
        Quit:'##class(DHCHAI.IR.EnviHyReport).%ExistsId(+key) return
        Set objEnviHy=##class(DHCHAI.IR.EnviHyReport).GetObjById(+key)
        Quit:objEnviHy.EHReCheckRepDr="" return    //退出的话说明没有复检 Del()
        ; 可以判断一下objEnviHy.EHReCheckRepDr(原报告)是否合格
        Set obj.EHKey = objEnviHy.EHReCheckRepDr   
        Set sc=obj.%Save()
        If $system.Status.IsError(sc) {        //检查Save是否成功
            Do $system.OBJ.DisplayError(sc) 
            Set return=-1
        }Else{
            Set return=obj.EHKey
        }
        Do obj.%Close()
    } 
    Quit return
}

Storage Default
{
<Data name="EnviHyReCheckDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EHKey</Value>
</Value>
<Value name="3">
<Value>EHValue</Value>
</Value>
</Data>
<DataLocation>^MA.HAI.IR.EnviHyReCheckD</DataLocation>
<DefaultData>EnviHyReCheckDefaultData</DefaultData>
<IdLocation>^MA.HAI.IR.EnviHyReCheckD</IdLocation>
<IndexLocation>^MA.HAI.IR.EnviHyReCheckI</IndexLocation>
<StreamLocation>^MA.HAI.IR.EnviHyReCheckS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
