/// Functgion: 多院区业务 
/// CreateDate:2021-07-12
/// Creator:   sunfengchao
Class web.DHCBL.CT.BDPMultiHospitalService Extends %RegisteredObject
{

/// Description：查询内容 
/// CreatDate:2021-07-12
/// Creator:sunfengchao
/// Table： BDP_MultiHospitalService
/// Input： rowid,code,desc
/// Return: 
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.BDPMultiHospitalService","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,BDPMHOSPServiceCode:%String,BDPMHOSPServiceDesc:%String,BDPMHOSPServiceType:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
      
    if (rowid'="")  
    {
        s ID=rowid
        s BDPMHOSPServiceCode=$listget($g(^User.BDPMultiHospitalServiceD(ID)),2)
        s BDPMHOSPServiceDesc=$listget($g(^User.BDPMultiHospitalServiceD(ID)),3)
        s BDPMHOSPServiceType=$listget($g(^User.BDPMultiHospitalServiceD(ID)),4)
        s:BDPMHOSPServiceType="L" BDPMHOSPServiceType="受限"
        s:BDPMHOSPServiceType="UL" BDPMHOSPServiceType="不受限"
        d OutputRow
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U")  
        s:desc'="" desc=$ZCONVERT(desc,"U")  
        s ID=0
        for 
        {
            s ID=$o(^User.BDPMultiHospitalServiceD(ID))
            q:ID="" 
            s BDPMHOSPServiceCode=$listget($g(^User.BDPMultiHospitalServiceD(ID)),2)
            s BDPMHOSPServiceDesc=$listget($g(^User.BDPMultiHospitalServiceD(ID)),3)
            s BDPMHOSPServiceType=$listget($g(^User.BDPMultiHospitalServiceD(ID)),4)
            s:BDPMHOSPServiceType="L" BDPMHOSPServiceType="受限"
            s:BDPMHOSPServiceType="UL" BDPMHOSPServiceType="不受限"
            s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(BDPMHOSPServiceDesc) 
            if ($ZCONVERT(BDPMHOSPServiceCode,"U")[code)&(($ZCONVERT(BDPMHOSPServiceDesc,"U")[desc)||(PINYIN[desc))
            {
                d OutputRow
            } 
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(ID,BDPMHOSPServiceCode,BDPMHOSPServiceDesc,BDPMHOSPServiceType)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    
    Set ind=$o(^CacheTemp(repid,ind))
    If ind=""
    {
        //if there are no more rows,finish fetching...
        Set AtEnd=1
        Set Row=""
    }
    Else
    {
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// Description 修改时打开的数据 
/// Creator:    sunfengchao
/// CreatDate:  2021-07-12
/// Input：     id  
/// Other:      w ##class(web.DHCBL.CT.BDPMultiHospitalService).OpenData("9")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.BDPMultiHospitalService).%New()
    s obj = ##class(User.BDPMultiHospitalService).%OpenId(id)
    s eobj.ID=id
    s eobj.BDPMHOSPServiceCode= obj.BDPMHOSPServiceCode
    s eobj.BDPMHOSPServiceDesc= obj.BDPMHOSPServiceDesc
    s eobj.BDPMHOSPServiceType=obj.BDPMHOSPServiceType   
    s str = eobj.JsonS()    
    d eobj.%Close()
    d obj.%Close()
    q str
}

/// Description 数据重复验证方法，由js调用
/// Creator:    sunfengchao
/// CreatDate:  2021-07-12
/// Table：     User.BDPMultiHospitalService
/// Input：     id-rowid, code-代码,desc-描述
/// Return：    "1"(数据重复),"0"(数据不重复)
/// Other:      w ##class(web.DHCBL.CT.BDPMultiHospitalService).Validate("","","")
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
 
    s flag="",flagc="",flagd=""
    s:code'="" flagc=$d(^User.BDPMultiHospitalServiceI("CodeIdx",code))
    s:desc'="" flagd=$d(^User.BDPMultiHospitalServiceI("DescIdx",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^User.BDPMultiHospitalServiceI("CodeIdx",code,0))
        s:desc'="" idd=$o(^User.BDPMultiHospitalServiceI("DescIdx",desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Description 保存内容
/// Creator:    sunfengchao
/// CreatDate:  2021-01-12 
/// Table：     User.BDPMultiHospitalService
/// Input：     web.Entity.CT.BDPMultiHospitalService 实体类
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.BDPMultiHospitalService).SaveData(eobj)
ClassMethod SaveData(eobj As web.Entity.CT.BDPMultiHospitalService) As %String
{
    s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
        s flag=..Validate(eobj.ID,eobj.BDPMHOSPServiceCode,eobj.BDPMHOSPServiceDesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        else
        {
            if (eobj.ID="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.BDPMultiHospitalService).%New()
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(User.BDPMultiHospitalService).%OpenId(eobj.ID)
                s bobj=##class(web.Entity.CT.BDPMultiHospitalService).%New()
                s bobj.ID=eobj.ID
                s bobj.BDPMHOSPServiceCode=obj.BDPMHOSPServiceCode
                s bobj.BDPMHOSPServiceDesc = obj.BDPMHOSPServiceDesc          //修改描述
                s bobj.BDPMHOSPServiceType = obj.BDPMHOSPServiceType 
            }
            Ts
            s obj.BDPMHOSPServiceCode = eobj.BDPMHOSPServiceCode
            s obj.BDPMHOSPServiceDesc = eobj.BDPMHOSPServiceDesc   
            s obj.BDPMHOSPServiceType = eobj.BDPMHOSPServiceType 
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}" 
                //新增时，日志
                d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_MultiHospitalService","User.BDPMultiHospitalService","多院区业务",id,eobj.BDPMHOSPServiceDesc,"A",eobj)
                //修改时，日志
                d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_MultiHospitalService","User.BDPMultiHospitalService","多院区业务",eobj.ID,eobj.BDPMHOSPServiceDesc,"U",eobj,bobj)
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("多院区业务","web.DHCBL.CT.BDPMultiHospitalService","SaveData",eobj)
                s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
            }
        }               
    }
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
    }
    q result
ERROE
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("多院区业务","web.DHCBL.CT.BDPMultiHospitalService","SaveData",eobj)
    s ^ERRORLOGINFO(logid)=$ze
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Description:删除限制判断
/// CreatDate:2021-07-30
/// Creator:  sunfengchao 
/// Return:1- 有关联数据 ,提示是否删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
  s result=0
  q:id="" result
  if $d(^User.BDPHospitalServiceConfigD(id))  s result=1 
  q result
}

/// Creator:sunfengchao
/// CreatDate:2014-10-30
/// Description：根据ID删除多院区业务的内容
/// Table：User.BDPMultiHospitalService
/// Input：id-知识库标识字典的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.BDPMultiHospitalService).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result=""  
    //new Entity对象，用于保存日志
    s pobj = ##class(User.BDPMultiHospitalService).%OpenId(id)
    s eobj = ##class(web.Entity.CT.BDPMultiHospitalService).%New()
    s eobj.ID = id
    s eobj.BDPMHOSPServiceCode=pobj.BDPMHOSPServiceCode
    s eobj.BDPMHOSPServiceDesc=pobj.BDPMHOSPServiceDesc
    s eobj.BDPMHOSPServiceType=pobj.BDPMHOSPServiceType
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(User.BDPMultiHospitalService).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        //保存日志
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_MultiHospitalService","User.BDPMultiHospitalService","多院区业务",id,eobj.BDPMHOSPServiceDesc,"D",eobj)
        d eobj.%Close()
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("多院区业务","web.DHCBL.CT.BDPMultiHospitalService","DeleteData",eobj)
        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
    } 
    q result
}

}
