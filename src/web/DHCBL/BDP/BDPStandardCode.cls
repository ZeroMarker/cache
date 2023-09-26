Class web.DHCBL.BDP.BDPStandardCode Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Function: 返回查询到的数据
/// Creator:  sunfengchao
/// CreateDate:2016-4-15
/// Debug:    w ##class(web.DHCBL.BDP.BDPStandardCode).GetList()
ClassMethod GetList(tableName As %String, dataReference As %String) As %String
{
   new (tableName,dataReference,%session)
   s ID="",returnStr=""
   s ID=$o(^User.BDPStandardCodeI("DataRef",tableName,dataReference,0))
   if (ID'="")
   {
     s BDPInternalCode = $listget($g(^User.BDPStandardCodeD(ID)),6)       
     s BDPInternalDesc = $listget($g(^User.BDPStandardCodeD(ID)),7)
     s BDPHospNationalCode=$listget($g(^User.BDPStandardCodeD(ID)),8)          
     s BDPPHospNationalDesc = $listget($g(^User.BDPStandardCodeD(ID)),9)
     s returnStr=BDPInternalCode_"^"_BDPInternalDesc_"^"_BDPHospNationalCode_"^"_BDPPHospNationalDesc
   }
   q returnStr
}

ClassMethod SaveMenuName(menuName As %String) As %String
{
  new (menuName,%session)
  s MenuI= ##class(web.DHCBL.BDP.BDPStandardCode).FindMenuNameByTable(menuName)
  if (MenuI'=""){
      k ^TMP("BDPStandardCode","MenuName")
      s ^TMP("BDPStandardCode","MenuName")=MenuI
  }
  q ""
}

/// Function: 获取菜单名称
/// Creator:  sunfengchao
/// CreateDate: 2016-6-3
ClassMethod GetMenuName() As %String
{
  s MenuName=""
  s MenuName=$g(^TMP("BDPStandardCode","MenuName"))
  q MenuName
}

/// Function:查找修改数据时的rowd
/// Creator : sunfengchao
ClassMethod GetRowIdByReference(tableName As %String, dataReference As %String)
{
  new (tableName,dataReference,%session)
  s rowid=""
  if ($d(^User.BDPStandardCodeI("DataRef",tableName,dataReference))>0)
  {
    s rowid=$o(^User.BDPStandardCodeI("DataRef",tableName,dataReference,0))
  }
  q rowid
}

/// Function: 获取后台数据用于双击时显示
/// Creator : sunfengchao
/// Debug:    w ##class(web.DHCBL.BDP.BDPStandardCode).OpenData("","")
ClassMethod OpenData(tableName As %String, dataReference As %String)
{
  new (tableName,dataReference,%session)
  s returnStr="",rowid=""
  if ($d(^User.BDPStandardCodeI("DataRef",tableName,dataReference))>0)
  {
    s rowid=$o(^User.BDPStandardCodeI("DataRef",tableName,dataReference,0))
    q:rowid=""
 
    s BDPInternalCode = $listget($g(^User.BDPStandardCodeD(rowid)),6)          
    s BDPInternalDesc = $listget($g(^User.BDPStandardCodeD(rowid)),7)
    s BDPHospNationalCode=$listget($g(^User.BDPStandardCodeD(rowid)),8)          
    s BDPPHospNationalDesc = $listget($g(^User.BDPStandardCodeD(rowid)),9)
    s BDPInternalValue = $listget($g(^User.BDPStandardCodeD(rowid)),10)
    s returnStr=BDPInternalCode_"^"_BDPInternalDesc _"^"_BDPHospNationalCode _"^"_BDPPHospNationalDesc _"^"_ BDPInternalValue
  }
  q returnStr
}

/// Function: 数据保存
/// Creator : sunfengchao
ClassMethod SaveEntity(listData As %String) As %String
{
   new (listData,%session)
   s result=""
   s eobj=##class(web.Entity.CT.BDPStandardCode).%New()
   s eobj.BDPInternalCode=$p(listData,"^",1)
   s eobj.BDPInternalDesc=$p(listData,"^",2)
   s eobj.BDPHospNationalCode=$p(listData,"^",3)
   s eobj.BDPPHospNationalDesc=$p(listData,"^",4)
   s eobj.TableName=$p(listData,"^",5)
   s eobj.DataReference=$p(listData,"^",6)
   s eobj.ID=$p(listData,"^",7)
   s eobj.BDPInternalValue=$p(listData,"^",8)
   s:eobj.BDPHospNationalCode="undefined" eobj.BDPHospNationalCode=""
   s:eobj.BDPPHospNationalDesc="undefined" eobj.BDPPHospNationalDesc=""
   if ((eobj.ID'="")&(eobj.BDPInternalCode="")&(eobj.BDPPHospNationalDesc="")&(eobj.BDPHospNationalCode="")&(eobj.BDPInternalDesc="")&(eobj.BDPInternalValue=""))
   {  
     ;修改操作时，当国家标准数据为空时,清除user表里的数据
     s result=..DeleteNationalCode(eobj.TableName,eobj.DataReference)
   }
   else
   {
      if ((eobj.BDPInternalDesc="")&&(eobj.BDPInternalCode'=""))
      {
        s result = "{success:'false',errorinfo:'标准编码非空时，标准编码名称不能为空!'}" 
        s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("国家标准编码:"_eobj.TableName_"->"_eobj.DataReference,"web.DHCBL.BDP.BDPStandardCode","SaveEntity",eobj)
        s ^ERRORLOGINFO(logid)="标准编码非空时，标准编码名称不能为空!"
      }
      else
      {
       if (eobj.ID="")   
       {
         s obj = ##class(User.BDPStandardCode).%New()
       }
       else                    
       {
         s obj=##class(User.BDPStandardCode).%OpenId(eobj.ID)
         s bobj=##class(web.Entity.CT.BDPStandardCode).%New()
         s bobj.ID=eobj.ID
         s bobj.BDPHospNationalCode=obj.BDPHospNationalCode
         s bobj.BDPInternalCode = obj.BDPInternalCode          
         s bobj.BDPInternalDesc = obj.BDPInternalDesc           
         s bobj.BDPPHospNationalDesc = obj.BDPPHospNationalDesc  
         s bobj.BDPInternalValue=obj.BDPInternalValue
         s bobj.DataReference=obj.DataReference
         s bobj.TableName=obj.TableName
       }                    
   
       s obj.BDPInternalCode = eobj.BDPInternalCode          
       s obj.BDPInternalDesc = eobj.BDPInternalDesc
       s obj.BDPHospNationalCode=eobj.BDPHospNationalCode           
       s obj.BDPPHospNationalDesc = eobj.BDPPHospNationalDesc  
       s obj.BDPInternalValue=eobj.BDPInternalValue
       s obj.DataReference=eobj.DataReference
       s obj.TableName=eobj.TableName 
    
       Tstart
       s sc = obj.%Save()
       d obj.%Close()
       If $$$ISOK(sc)
       {
         Tcommit
         s id = obj.%Id()
         s result = "{success:'true',id:'"_id_"'}"         
         d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_StandardCode","User.BDPStandardCode","国家标准数据编码",id,eobj.BDPInternalDesc,"A",eobj)
         d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_StandardCode","User.BDPStandardCode","国家标准数据编码",eobj.ID,eobj.BDPInternalDesc,"U",eobj,bobj)
       }
       else
       {
         Trollback
         s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" 
         s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("国家标准编码:"_eobj.TableName_"->"_eobj.DataReference,"web.DHCBL.BDP.BDPStandardCode","SaveEntity",eobj)
         s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)  
       }
     }
    } 
  q result
}

/// Function: 删除数据
/// Creator:  sunfengchao
/// Debug:    w ##class(web.DHCBL.BDP.BDPStandardCode).DeleteFormData()
ClassMethod DeleteNationalCode(tableName As %String, dataReference As %String) As %String
{
    new (tableName,dataReference,%session)
    s result="",rowid=""
    s rowid=$o(^User.BDPStandardCodeI("DataRef",tableName,dataReference,0))
    if (rowid'="")
    {
      Tstart
      s obj=##class(User.BDPStandardCode).%OpenId(rowid)
      s eobj = ##class(web.Entity.CT.BDPStandardCode).%New()
      s eobj.ID = rowid
      s eobj.BDPInternalCode=obj.BDPInternalCode
      s eobj.BDPInternalDesc=obj.BDPInternalDesc 
      s eobj.BDPHospNationalCode= obj.BDPHospNationalCode
      s eobj.BDPPHospNationalDesc =obj.BDPPHospNationalDesc 
      s eobj.BDPInternalValue=obj.BDPInternalValue   
      s eobj.TableName=obj.TableName
      s eobj.DataReference = dataReference
      s sc= ##class(User.BDPStandardCode).%DeleteId(rowid)
      if (sc=1)
      {
        Tc
        s result="{success:'true',info:'国家标准数据删除成功!'}"  
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_StandardCode","User.BDPStandardCode","国家标准数据编码",rowid,eobj.BDPInternalDesc,"D",eobj)
        d eobj.%Close()
      }
      else
      {
        Trollback
        s result= "{success:'false',info:'国家标准数据删除失败!'}" 
        s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("国家标准编码:"_eobj.TableName_"->"_eobj.DataReference,"web.DHCBL.BDP.BDPStandardCode","DeleteNationalCode",eobj)
        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)   
      }
    } 
    else
    {
      s result="{success:'true',info:'国家标准数据为空,不用删除!'}"  
    }
   q result
}

/// 通过功能大表里的table来找到菜单维护里的菜单名
/// w ##class(web.DHCBL.BDP.BDPStandardCode).FindMenuNameByTable()
ClassMethod FindMenuNameByTable(table As %String)
{
  new (table,%session)
  s result=""
  if (table'="")
  {
     s table=$zcvt(table,"U")  
     if ($d(^User.BDPExecutablesI("CodeIndex"," "_table))>0)
     {
       s ExecuteID=0
       s ExecuteID=$o(^User.BDPExecutablesI("CodeIndex"," "_table,0))
       q:ExecuteID="" ""
       s Caption=$LISTGET($G(^User.BDPExecutablesD(ExecuteID)),3)  
       s ID=0
       for
       {
         s ID=$o(^User.BDPMenuD(ID)) 
         q:ID=""  
         s Code=$LISTGET($G(^User.BDPMenuD(ID)),2)
         s MenuCaption=$LISTGET($G(^User.BDPMenuD(ID)),3) 
         S LinkFuntionDR=$LISTGET($G(^User.BDPMenuD(ID)),4)
         //if (MenuCaption=Caption) 
         if (LinkFuntionDR=ExecuteID) 
         {
           s result=$zcvt(Code,"U")
           if (result="DHC.BDP.CARE")&(MenuCaption="医护人员") s result="DHC.BDP.CARE.CTCAREPROV"
           if (result="DHC.BDP.DOC.DHCCTLOCMEDUNIT")&(MenuCaption="医疗单元") s result="DHC.BDP.DHCCTLOCMEDUNIT"
           q 
         }
         else
         {
           continue
         }
        }
      }
    }
   q result
}

/// Function: 判断是否已经对照
/// CreateDate: 2016-4-26
/// Creator:  sunfengchao
/// debug:  w ##class(web.DHCBL.BDP.BDPStandardCode).IsContrast("CT_LocalityTypeOfStreet")
ClassMethod IsContrast(tableName As %String) As %String
{
  new (tableName,%session)
  s flag=0,flagC=0, menuName="", MenuNameI=""
  s:tableName'="" menuName=..FindMenuNameByTable(tableName) 
  q:menuName="" 0
  s MenuNameI=" "_menuName
  s flag=$d(^User.BDPMenuNATDataTypeI("contrast",MenuNameI))    
  if (flag>0) s flagC=1
  q flagC
}

/// Function:是否一键开启国家标准数据功能
/// Creator: sunfengchao
/// CreateDate:2016-5-12
/// w ##class(web.DHCBL.BDP.BDPStandardCode).IfOneKeyUp()
ClassMethod IfOneKeyUp() As %String
{
  s flag="",ID=0
  if ($d(^User.BDPConfigI("ConfigCodeI"," BDPNATIONALDATA"))>0)
  {
    s ID=$o(^User.BDPConfigI("ConfigCodeI"," BDPNATIONALDATA",ID))
    q:ID="" flag
    s flag=$listget($g(^User.BDPConfigD(ID)),3)
  }
  else
  {
    s flag=""
  }
  q flag
}

/// Function:显示哪些字段
/// CreateDate:2016-5-12
/// Creator:sunfengchao
/// Desc: true 显示  false 不显示
/// w ##class(web.DHCBL.BDP.BDPStandardCode).ShowGrid()
ClassMethod ShowGrid()
{
  s str="",ID=0
  s result=""
  if ($d(^User.BDPConfigI("ConfigCodeI"," BDPNATIONALDATASHOW"))>0)
  {
    s ID=$o(^User.BDPConfigI("ConfigCodeI"," BDPNATIONALDATASHOW",ID))
    q:ID="" ""
    s str=$listget($g(^User.BDPConfigD(ID)),3)
    s InternalCodeFlag="",InternalDescFlag="",HospCodeFlag="",HospDescFlag=""
    s InternalCodeFlag=$p($p(str,"^",1),":",2)
    s InternalDescFlag=$p($p(str,"^",2),":",2)
    s HospCodeFlag=$p($p(str,"^",3),":",2)
    s HospDescFlag=$p($p(str,"^",4),":",2)
    s result=InternalCodeFlag_"^"_InternalDescFlag_"^"_HospCodeFlag_"^"_HospDescFlag
  }
  else{
    s result=""     
  }
  q result
}

/// Function: 获取到国家标准编码的数据
/// Creator:  sunfengchao
/// CreateDate:2016-5-13
/// Descption: 先判断是否开启了国家标准编码功能，然后判断可以显示哪些字段,再看是否进行过数据对照  ，
///            满足条件的才进行查询
/// debug:    w ##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ARC_BillGrp","48")
ClassMethod GetStandardCode(tableName As %String, id As %String, IfOpenFlag As %String = "", IfconstrastFlag As %String = "", IfShowStr As %String = "")
{
   new (id,tableName,IfOpenFlag,IfconstrastFlag,IfShowStr,%session)
   s flag=0,OpenFlag="",ShowStr="",constrastFlag="",resultStr=""
   s InternalCodeFlag="",InternalDescFlag="",HospCodeFlag="",HospDescFlag=""
   s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="",BDPInternalValue="" 
   ; 是否一键开启
   if (IfOpenFlag=""){
        s OpenFlag=##class(web.DHCBL.BDP.BDPStandardCode).IfOneKeyUp()
   }
   else{
       s OpenFlag=IfOpenFlag
    }
   if (OpenFlag="Y")
   { 
     if (IfconstrastFlag=""){
        ; 是否对照 
        s constrastFlag=##class(web.DHCBL.BDP.BDPStandardCode).IsContrast(tableName)
     }
     else{
        s constrastFlag=IfconstrastFlag    
     }
     if (constrastFlag=1) 
     {
        if (IfShowStr=""){
            s ShowStr=##class(web.DHCBL.BDP.BDPStandardCode).ShowGrid() 
        } 
        else{
            s ShowStr=IfShowStr    
        }
        ; 根据配置下要显示的字段 去查询国家标准编码
        s BDPStandardRowId=$o(^User.BDPStandardCodeI("DataRef",tableName,id,0))  
        if (BDPStandardRowId'="")
        {  
          s:$p(ShowStr,"^",1)="true" BDPInternalCode = $listget($g(^User.BDPStandardCodeD(BDPStandardRowId)),6)          
          s:$p(ShowStr,"^",2)="true" BDPInternalDesc =$listget($g(^User.BDPStandardCodeD(BDPStandardRowId)),7) 
          s:$p(ShowStr,"^",3)="true" BDPHospNationalCode=$listget($g(^User.BDPStandardCodeD(BDPStandardRowId)),8)          
          s:$p(ShowStr,"^",4)="true" BDPHospNationalDesc = $listget($g(^User.BDPStandardCodeD(BDPStandardRowId)),9)
          
          s:BDPInternalCode'="" resultStr=BDPInternalCode_"#" _$listget($g(^User.BDPStandardCodeD(BDPStandardRowId)),10) _"^"_BDPInternalDesc_"^"_BDPHospNationalCode_"^"_BDPHospNationalDesc
          S:BDPInternalCode="" resultStr=$listget($g(^User.BDPStandardCodeD(BDPStandardRowId)),10) _"^"_BDPInternalDesc_"^"_BDPHospNationalCode_"^"_BDPHospNationalDesc
        }
        else
        {
          s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
          s resultStr=BDPInternalCode_"^"_BDPInternalDesc_"^"_BDPHospNationalCode_"^"_BDPHospNationalDesc
        }
     }
   }
   q resultStr
}

}
