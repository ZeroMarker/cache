Import SQLUser

/// 名称: 导入导出菜单
/// 描述: 菜单配置
/// 编写者：基础数据平台组-李森
/// 编写日期: 2013-5-2
Class web.DHCBL.BDP.BDPEIMenu Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：李森
/// CreatDate: 2013-5-2
/// Description：修改时打开的数据
/// Table：User.BDPEIMenu
/// Input：id
ClassMethod OpenData(id As %String) As %String
{
 s str="" 
 s eobj = ##class(web.Entity.BDP.BDPEIMenu).%New()
 s eobj.ID = id
 s eobj.Code=$LISTGET($G(^User.BDPEIMenuD(id)),2)
 s eobj.Caption=$LISTGET($G(^User.BDPEIMenuD(id)),3)
 s eobj.ParentMenuDr=$LISTGET($G(^User.BDPEIMenuD(id)),4)
 s eobj.Sequence=$LISTGET($G(^User.BDPEIMenuD(id)),5)
 s eobj.Image=$LISTGET($G(^User.BDPEIMenuD(id)),6)
 s eobj.TableName=$LISTGET($G(^User.BDPEIMenuD(id)),7)
 s eobj.ClassName=$LISTGET($G(^User.BDPEIMenuD(id)),8)
 s eobj.Kglobal=$LISTGET($G(^User.BDPEIMenuD(id)),9)
 s eobj.ImportFlag=$LISTGET($G(^User.BDPEIMenuD(id)),10)
 s:eobj.ImportFlag="Y" eobj.ImportFlag="true" 
 s eobj.ExportFlag=$LISTGET($G(^User.BDPEIMenuD(id)),11)
 s:eobj.ExportFlag="Y" eobj.ExportFlag="true" 
 s eobj.LockFlag=$LISTGET($G(^User.BDPEIMenuD(id)),12)
 s:eobj.LockFlag="Y" eobj.LockFlag="true" 
 s eobj.LinkTableDr=$LISTGET($G(^User.BDPEIMenuD(id)),13)
 
 //s str = eobj.JsonS() 
 ///因为有数据有'
 s str="{ID:'"_eobj.ID_"',Code:'"_eobj.Code_"',Caption:'"_eobj.Caption_"',ParentMenuDr:'"_eobj.ParentMenuDr_"',Image:'"_eobj.Image_"',Sequence:'"_eobj.Sequence_"',TableName:'"_eobj.TableName_"',ClassName:'"_eobj.ClassName_"',Kglobal:'"_eobj.Kglobal_"',ImportFlag:'"_eobj.ImportFlag_"',ExportFlag:'"_eobj.ExportFlag_"',LockFlag:'"_eobj.LockFlag_"',LinkTableDr:'"_eobj.LinkTableDr_"'}"
 d eobj.%Close()
 s str = "{list:["_str_"]}"
 q str
}

/// Creator：李森
/// CreatDate: 2013-5-2
/// Description：数据重复验证方法
/// Table：User.BDPEIMenu
/// Input：id, code
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String) As %String
{
 s:code'="" code=" "_$ZCONVERT(code,"U") //转换成大写
 s flag="",flagc=""
 s:code'="" flagc=$d(^User.BDPEIMenuI("UniqueCodeIndex",code))
 if (id="") //如果为空，增加时的重复判断
 {
  if (flagc>0) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc=""
  s:code'="" idc=$o(^User.BDPEIMenuI("UniqueCodeIndex",code,0))
  if ((idc'=id)&(flagc>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 q flag
}

/// Creator：李森
/// CreatDate: 2013-5-2
/// Description：保存修改
/// Table：User.BDPEIMenu
/// Input：web.Entity.BDP.BDPEIMenu 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.BDP.BDPEIMenu).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.BDP.BDPEIMenu, tempImage As %String) As %String
{
 s result="",flag=""
 if $IsObject(eobj)
 {
  s flag=..Validate(eobj.ID,eobj.Code)  //调用重复验证
  if (flag=1)
  {
   s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  }
  else
  {
    s:eobj.Sequence'="" eobj.Sequence=$ZCONVERT(eobj.Sequence,"U")
   if (eobj.ID="")  //如果RowId未赋值则增加
   {
    s obj=##class(User.BDPEIMenu).%New()
   }
   else                     //如果RowId已赋值则修改
   {
    s obj=##class(User.BDPEIMenu).%OpenId(eobj.ID)
    s bobj=##class(web.Entity.BDP.BDPEIMenu).%New()
    s bobj.ID=eobj.ID
    s bobj.Code = obj.Code           
    s bobj.Caption = obj.Caption          
    s bobj.Image = obj.Image
    s bobj.Sequence = obj.Sequence
    s:obj.ParentMenuDr'="" bobj.ParentMenuDr=obj.ParentMenuDr.%Id()
    s bobj.TableName = obj.TableName
    s bobj.ClassName=obj.ClassName
    s bobj.Kglobal=obj.Kglobal
    s bobj.ImportFlag=obj.ImportFlag
    s bobj.ExportFlag=obj.ExportFlag
    s bobj.LockFlag=obj.LockFlag
    s:obj.LinkTableDr'="" bobj.LinkTableDr=obj.LinkTableDr.%Id() //关联表结构登记
    
    
 }  
   
   s obj.Code = eobj.Code          //修改代码
   s obj.Caption = eobj.Caption          //修改描述
   if ((tempImage'="")&&(tempImage["../scripts/bdp/Framework/BdpIconsLib/"))
   {
     s tempImage=$p(tempImage,"../scripts/bdp/Framework/BdpIconsLib/",2)
   }
   s eobj.Image=tempImage
   s obj.Image =tempImage
   s obj.Sequence = eobj.Sequence
   d obj.ParentMenuDrSetObjectId(eobj.ParentMenuDr)
   s obj.TableName = eobj.TableName
   s obj.ClassName=eobj.ClassName  
   s obj.Kglobal=eobj.Kglobal 
   s:eobj.ImportFlag="" eobj.ImportFlag ="N" 
   s obj.ImportFlag=eobj.ImportFlag
   s:eobj.ExportFlag="" eobj.ExportFlag ="N" 
   s obj.ExportFlag=eobj.ExportFlag  
   s:eobj.LockFlag="" eobj.LockFlag ="N" 
   s obj.LockFlag=eobj.LockFlag     
   d obj.LinkTableDrSetObjectId(eobj.LinkTableDr)  //关联表结构登记
   Ts
   s sc=obj.%Save()
   d obj.%Close()
   If $$$ISOK(sc)
   {
    Tc
    s id = obj.%Id()
    s result = "{success:'true',id:'"_id_"'}"  //返回RowId
    //保存日志
    d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_EIMenu","User.BDPEIMenu","导入导出菜单",id,eobj.Caption,"A",eobj)
    d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_EIMenu","User.BDPEIMenu","导入导出菜单",eobj.ID,eobj.Caption,"U",eobj,bobj)
   }
   else
   {
    Trollback
    s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
   }
  }    
 }
 else
 {
  s result = "{success:'false',errorinfo:'对象不存在！'}"
 }
 q result
}

/// Creator：李森
/// CreatDate: 2013-5-2
/// Description：根据ID删除
/// Table：User.BDPEIMenu
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
 s result = "",flag=""
 s flag=$d(^User.BDPEIMenuI("ParMenuIdx",id)) //判断该菜单是否被引用
 if (flag>0)
 {
  s result = "{success:'false',info:'该菜单下有子菜单,禁止删除！'}"   
 }
 else
 {
  s eobj = ##class(web.Entity.BDP.BDPEIMenu).%New()
  s eobj.ID = id
  s eobj.Code=$LISTGET($G(^User.BDPEIMenuD(id)),2)
  s eobj.Caption=$LISTGET($G(^User.BDPEIMenuD(id)),3)
  s eobj.ParentMenuDr=$LISTGET($G(^User.BDPEIMenuD(id)),4)
  s eobj.Sequence=$LISTGET($G(^User.BDPEIMenuD(id)),5)
  s eobj.Image=$LISTGET($G(^User.BDPEIMenuD(id)),6)
  s eobj.TableName=$LISTGET($G(^User.BDPEIMenuD(id)),7)
  s eobj.ClassName=$LISTGET($G(^User.BDPEIMenuD(id)),8)
  s eobj.Kglobal=$LISTGET($G(^User.BDPEIMenuD(id)),9)
  s eobj.ImportFlag=$LISTGET($G(^User.BDPEIMenuD(id)),10)
  s eobj.ExportFlag=$LISTGET($G(^User.BDPEIMenuD(id)),11)
  s eobj.LockFlag=$LISTGET($G(^User.BDPEIMenuD(id)),12)
  s eobj.LinkTableDr=$LISTGET($G(^User.BDPEIMenuD(id)),13)
  s sc=##class(User.BDPEIMenu).%DeleteId(id)
  if $$$ISOK(sc)
  {
   s result = "{success:'true',info:'删除成功！'}" 
   //保存日志
   d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_EIMenu","User.BDPEIMenu","导入导出菜单",id,eobj.Caption,"D",eobj)
   d eobj.%Close()
  }
  else 
  {
   s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
  }
 }
 q result
}

/// 2013-5-21 by lisen
/// 获取菜单树干,用于combobox
/// 入参：id(根节点), nodeId(要屏蔽的菜单rowid)
/// w ##class(web.DHCBL.BDP.BDPEIMenu).GetMenuForCmb("menuTreeRoot",3)
ClassMethod GetMenuForCmb(id As %String, nodeId As %String) As %String
{
 if (id="CatTreeRoot") s id=-100000000000000
 s mySMRowID=0
 s myMenuCount=0
 s mySMSeq=0
 k myMenuArray
 
 //生成菜单索引数组
 s mySMSeq=0
 s n=0
 for {
  s mySMSeq=$o(^User.BDPEIMenuI("ParSeqIdx",id,mySMSeq))
  q:(mySMSeq="")
  s n=n+1
  s a(n)= $p(mySMSeq," ",2)
 }
 set left=1,right=n
 d:$d(a) ..QuickSort(.a,left,right) //排序
 s mySMRowID=0
 s n=0
 s mySMSeq=0
 for {
  s n=$o(a(n))
  q:(n="")
  s mySMSeq=$g(a(n))
  for {
   s mySMRowID=$o(^User.BDPEIMenuI("ParSeqIdx",id," "_mySMSeq,mySMRowID))
   q:(mySMRowID="")
   q:(mySMRowID=nodeId)
   s myMenuCount=myMenuCount+1
   s myMenuArray(myMenuCount)=mySMRowID
   ;w !,mySMRowID
  }
 }
 
 //输出菜单JSON串
 s mySMRowID=0
 s myMenuSeq=0
 s myJsonStr=""
 for {
  ;q:(+myMenuSeq>1)
  s myMenuSeq=$o(myMenuArray(myMenuSeq))
  q:(myMenuSeq="")
  s mySMRowID=$g(myMenuArray(myMenuSeq))
  
  s myMenuObj=##Class(User.BDPEIMenu).%OpenId(mySMRowID,0)
  if $IsObject(myMenuObj) {
	s TableName = myMenuObj.TableName
	if TableName'="" continue  //2020-04-13 有表名的就是子菜单，不允许作为父菜单节点
   s myCode = myMenuObj.Code
   s myCaption = myMenuObj.Caption
   s myImage = myMenuObj.Image
   s:myImage'="" myImage = "../scripts/bdp/Framework/BdpIconsLib/"_myMenuObj.Image
   s TableName = myMenuObj.TableName
   
   s:(myJsonStr'="") myJsonStr=myJsonStr_","
    s myJsonStr=myJsonStr_"{"
    s myJsonStr=myJsonStr_"""id"":"""_""_mySMRowID_""",""text"":"""_myCaption_""","
    s myJsonStr=myJsonStr_"""iconCls"":"""_""_myImage_""","
    s myJsonStr=myJsonStr_"""leaf"":false,"
    //获取子菜单
    s myJsonStr=myJsonStr_"""children"":"_..GetMenuForCmb(mySMRowID,nodeId)
    s myJsonStr=myJsonStr_"}"
   }
   
   d myMenuObj.%Close()
 }
 
 k myMenuArray
 s myJsonStr="["_myJsonStr_"]"
 
 q myJsonStr
}

/// 2013-5-21 by lisen
/// 快速排序
ClassMethod QuickSort(ByRef a As %String, left As %String, right As %String) As %String
{
 s m=a(left),temp=0
 s i=left,j=right
 
 while (i<j)
 {
  for
  {
   if ((i<j)&(a(j)>=m))  s j=j-1        //a(j)>=m ,不加=号的话，当输入相等的数时会报错
    else  s temp=m,a(i)=a(j),a(j)=temp 
    quit:a(j)=m
  }
   for
  {
    if ((i<j)&(a(i)<=m)) s i=i+1         //a(i)<=m ,不加=号的话，当输入相等的数时会报错
    else  s temp=m,a(j)=a(i),a(i)=temp
    quit:a(i)=m 
  }
 }
  s a(i)=m
  if ((i-left)> 1)
    {
   d ..QuickSort(.a,left,i-1)
 }
  if ((right-i)> 1)  
 {
   d ..QuickSort(.a,i+1,right)
 }
    quit i
}

/// 207-10-13 by 谷雪萍
/// Description：获取菜单树,按字段'显示顺序'大小排序,用于BDP_EIMenuNew.js
/// Table：User.BDPEIMenu
/// Input：id:父节点rowid
/// Ohter: w ##class(web.DHCBL.BDP.BDPEIMenu).GetMenuNew("TreeRoot")
ClassMethod GetMenuNew(LastLevel As %String, nodeStr As %String) As %String
{
 if (LastLevel="TreeRoot") s LastLevel=-100000000000000
 s mySMRowID=0
 s myMenuCount=0
 s mySMSeq=0
 k myMenuArray
 
 //生成菜单索引数组
 s mySMSeq=0
 s n=0
 for {
  s mySMSeq=$o(^User.BDPEIMenuI("ParSeqIdx",LastLevel,mySMSeq))
  q:(mySMSeq="")
  s n=n+1
  s a(n)= $p(mySMSeq," ",2)
 }
 set left=1,right=n
 d:$d(a) ..QuickSort(.a,left,right) //排序
 s mySMRowID=0
 s n=0
 s mySMSeq=0
 for {
  s n=$o(a(n))
  q:(n="")
  s mySMSeq=$g(a(n))
  for {
   s mySMRowID=$o(^User.BDPEIMenuI("ParSeqIdx",LastLevel," "_mySMSeq,mySMRowID))
   q:(mySMRowID="")
   s myMenuCount=myMenuCount+1
   s myMenuArray(myMenuCount)=mySMRowID
   ;w !,mySMRowID
  }
 }
 //输出菜单JSON串
 s mySMRowID=0
 s myMenuSeq=0
 s myJsonStr=""
 for {
  ;q:(+myMenuSeq>1)
  s myMenuSeq=$o(myMenuArray(myMenuSeq))
  q:(myMenuSeq="")
  s mySMRowID=$g(myMenuArray(myMenuSeq))
  
  s myMenuObj=##Class(User.BDPEIMenu).%OpenId(mySMRowID,0)
  if $IsObject(myMenuObj) {
   
   s myCode = myMenuObj.Code
   s myCaption = myMenuObj.Caption
   s myImage= myMenuObj.Image
   s:myImage'="" myImage = "../scripts/bdp/Framework/BdpIconsLib/"_myMenuObj.Image
   s ParentMenuDr = myMenuObj.ParentMenuDr
   s TableName = myMenuObj.TableName
   

   //判断是否有子菜单
   if ($d(^User.BDPEIMenuI("ParMenuIdx",mySMRowID))>0) s myChildFlag=1
   else  s myChildFlag=0
   
    s nodeId="<"_mySMRowID_">"
    s:(myJsonStr'="") myJsonStr=myJsonStr_","
    s myJsonStr=myJsonStr_"{"
    s myJsonStr=myJsonStr_"""id"":"""_""_mySMRowID_""",""text"":"""_myCaption_""","
    s myJsonStr=myJsonStr_"""icon"":"""_""_myImage_""","
    if (+myChildFlag'=0) {
     s myJsonStr=myJsonStr_"""leaf"":false"
    }else {
     s myJsonStr=myJsonStr_"""parentNode"":"""_ParentMenuDr_""","
     s myJsonStr=myJsonStr_"""leaf"":true"
    }
    
    if (nodeStr[nodeId){
        s myJsonStr=myJsonStr_",""expanded"":false"
    }
    else{
        s myJsonStr=myJsonStr_",""expanded"":true"
    }
    
    s myJsonStr=myJsonStr_"}"
   
   d myMenuObj.%Close()
  }
 }
 
 k myMenuArray
 s myJsonStr="["_myJsonStr_"]"
 
 q myJsonStr
}

/// Creator:207-12-25 by gss
/// Function: 根据code返回id
/// Debugs: w ##class(web.DHCBL.BDP.BDPEIMenu).GetID("dhc.bdp.Locations.CTLoc")
ClassMethod GetID(code As %String) As %String
{
    s ID=""
    if (code'="") {
        s code=" "_$ZCONVERT(code,"U") //转换成大写
        s ID=$o(^User.BDPEIMenuI("UniqueCodeIndex",code,0))
    }
    q ID
}

/// Function:根据id获取Icon
/// Creator: sunfengchao
/// CreateDate:2016-9-21
/// Debug: w ##class(web.DHCBL.BDP.BDPEIMenu).GetIconByID("3")
ClassMethod GetIconByID(id As %String) As %String
{
    s Image=""
    s Image=$LISTGET($G(^User.BDPEIMenuD(id)),6)
    if (Image'=""){
        s Image="../scripts/bdp/Framework/BdpIconsLib/"_Image
    }
    else
    {
        s Image="../scripts/bdp/Framework/BdpIconsLib/null.png"
    }
    q Image
}

/// 添加时获取显示顺序
/// 入参：父菜单id
/// w ##class(web.DHCBL.BDP.BDPEIMenu).GetSequence("1")
ClassMethod GetSequence(id As %String) As %String
{
 if (id="TreeRoot") s id=-100000000000000
 s mySMRowID=0
 s myLineCount=0
 s mySMSeq=0
 k myLineArray
 
 //生成菜单索引数组
 s mySMSeq=0
 s n=0
 for {
  s mySMSeq=$o(^User.BDPEIMenuI("ParSeqIdx",id,mySMSeq))
  q:(mySMSeq="")
  s n=n+1
  s a(n)= $p(mySMSeq," ",2)
 }
 set left=1,right=n
 d:$d(a) ..QuickSort(.a,left,right) //排序
 s mySMRowID=0
 s n=0
 s mySMSeq=0
 for {
  s n=$o(a(n))
  q:(n="")
  s mySMSeq=$g(a(n))
 }
 
 q mySMSeq+1
}

/// Description：保存拖拽的内容 2016/9/21
/// Table：User.DHCSymptomLev
/// Input：id, parentid,orderstr
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.DHCBL.KB.DHCSymptomCon).SaveData()
ClassMethod DragNode(id, parentid, orderstr) As %String
{
    s result=""
    q:(id="") "{success:'false',errorinfo:'没有拖拽的节点'}"
    q:(parentid="") "{success:'false',errorinfo:'没有拖拽到准确的节点下'}"
    s:parentid="TreeRoot" parentid=""
    
    s obj=##class(User.BDPEIMenu).%OpenId(id) 
    d:parentid="" obj.ParentMenuDrSetObjectId("")
    d:parentid'="" obj.ParentMenuDrSetObjectId(parentid)

    Ts  
    s sc=obj.%Save()
    d obj.%Close()
    If $$$ISOK(sc)
    {
        Tc
        s id = obj.%Id()
        s result = "{success:'true',id:'"_id_"'}" //返回RowId
    
          s orderLen=$Length(orderstr,"^")
          for i=1:1:orderLen   
          {      
             s rowid=$p(orderstr,"^",i)
             s obj=##class(User.BDPEIMenu).%OpenId(rowid)
             s obj.Sequence =i
             s sc=obj.%Save()
             d obj.%Close()           
          }
    }
    else
    {
        Trollback
        s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
    }
    
    q result
}

/// 保存加锁状态
/// Other: w ##class(web.DHCBL.KB.DHCSymptomCon).ShowLockFlag()
ClassMethod ShowLockFlag(AutCode) As %String
{
    s flag=""
    if (AutCode'="")
	{
		s AutCode=" "_$ZCONVERT(AutCode,"U") //转换成大写
		s id=$o(^User.BDPEIMenuI("UniqueCodeIndex",AutCode,0))
	    s obj=##class(User.BDPEIMenu).%OpenId(id) 
	    s flag=obj.LockFlag
	    d obj.%Close()
	}
    q flag
}

/// 保存加锁状态
/// Other: w ##class(web.DHCBL.KB.DHCSymptomCon).SaveData()
ClassMethod SaveLockFlag(AutCode, flag) As %String
{
    s result=""
    q:(AutCode="") "{success:'false',errorinfo:'没有选中菜单'}"

    s AutCode=" "_$ZCONVERT(AutCode,"U") //转换成大写
	s id=$o(^User.BDPEIMenuI("UniqueCodeIndex",AutCode,0))
    s obj=##class(User.BDPEIMenu).%OpenId(id) 
    s obj.LockFlag=flag
    Ts  
    s sc=obj.%Save()
    d obj.%Close()
    If $$$ISOK(sc)
    {
        Tc
        s id = obj.%Id()
        s result = "{success:'true',id:'"_id_"'}" //返回RowId
    }
    else
    {
        Trollback
        s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
    }
    
    q result
}

/// /w ##class(web.DHCBL.BDP.BDPEIMenu).Insert()
ClassMethod Insert() As %String
{

	s file=##class(%File).%New("F:\EITable.txt")
	//w file.Size,!
	d file.Open("R")
	s SQLCODE=100
	k myXMLFileAry
	for i=1:1:file.Size {
	s data=file.Read()
	q:data=""
	s myXMLFileAry(i)=data	
	}
	close file
	b ;1
	s i=0
	for {
	s i = $o(myXMLFileAry(i))
	q:(i="")
	s Code=$p(myXMLFileAry(i),"	",1)
	s uCode=$zconvert(Code,"U")
	s:uCode'="" id=$o(^User.BDPEIMenuI("UniqueCodeIndex"," "_uCode,0))
	s Caption=$p(myXMLFileAry(i),"	",2)
	s ParentMenuDr=$p(myXMLFileAry(i),"	",3)
	s:ParentMenuDr'="" ParentMenuDr=$o(^User.BDPEIMenuI("UniqueCodeIndex"," "_ParentMenuDr,0))
	s Sequence=$p(myXMLFileAry(i),"	",4)
	s TableName=$p(myXMLFileAry(i),"	",5)
	s ClassName=$p(myXMLFileAry(i),"	",6)
	s Image=$p(myXMLFileAry(i),"	",7)
	s:Image'="" Image=Image_".png"
	s Kglobal=$p(myXMLFileAry(i),"	",8)
	s ImportFlag=$p(myXMLFileAry(i),"	",9)
	s ExportFlag=$p(myXMLFileAry(i),"	",10)
	s LockFlag=$p(myXMLFileAry(i),"	",11)
	s LinkTableDr=$p(myXMLFileAry(i),"	",12)
	&sql(insert into BDP_EIMenu (ID,Code,Caption,ParentMenuDr,Sequence,TableName,ClassName,Image,Kglobal,ImportFlag,ExportFlag,LockFlag,LinkTableDr) values (:ID,:Code,:Caption,:ParentMenuDr,:Sequence,:TableName,:ClassName,:Image,:Kglobal,:ImportFlag,:ExportFlag,:LockFlag,:LinkTableDr))
	        IF SQLCODE'=0 
	        {
	       w SQLCODE_"&"_i_"&"_data
	        }
	}
	q "over"
}

/// 获取功能JSON串,用于BDP数据导入、导出界面
/// Other: w ##class(web.DHCBL.BDP.BDPEIMenu).GetExecutableTreeJson("","I")
ClassMethod GetExecutableTreeJson(ParentID As %String, EIflag As %String) As %String
{
	if (ParentID="ExecutablegroupTreeRoot") s ParentID=-100000000000000
	s mySMRowID=0
	s myMenuCount=0
	s mySMSeq=0
	k myMenuArray
	
	//生成菜单索引数组
	s mySMSeq=0
	s n=0
	for {
		s mySMSeq=$o(^User.BDPEIMenuI("ParSeqIdx",ParentID,mySMSeq))
		q:(mySMSeq="")
		s n=n+1
		s a(n)= $p(mySMSeq," ",2)
	}
	set left=1,right=n
	d:$d(a) ..QuickSort(.a,left,right) //排序
	s mySMRowID=0
	s n=0
	s mySMSeq=0
	for {
		s n=$o(a(n))
		q:(n="")
		s mySMSeq=$g(a(n))
		for {
			s mySMRowID=$o(^User.BDPEIMenuI("ParSeqIdx",ParentID," "_mySMSeq,mySMRowID))
			q:(mySMRowID="")
			s myMenuCount=myMenuCount+1
			s myMenuArray(myMenuCount)=mySMRowID
			;w !,mySMRowID
		}
	}
	
	//输出菜单JSON串
	s mySMRowID=0
	s myMenuSeq=0
	s myJsonStr=""
	for {
		s myMenuSeq=$o(myMenuArray(myMenuSeq))
		q:(myMenuSeq="")
		s mySMRowID=$g(myMenuArray(myMenuSeq))
		
		s myMenuObj=##Class(User.BDPEIMenu).%OpenId(mySMRowID,0)
		if $IsObject(myMenuObj) {
			s myCode = myMenuObj.Code
			s myCaption = myMenuObj.Caption
			s myImage = myMenuObj.Image
			s:myImage'="" myImage= "../scripts/bdp/Framework/BdpIconsLib/"_myMenuObj.Image
			s myExeCode = myMenuObj.TableName		
			if (EIflag="E")
			{
				s myEXflag=myMenuObj.ExportFlag
				continue:(myEXflag="")||(myEXflag="N") //查看该菜单是否被激活
			}
			if (EIflag="I")
			{
				s myIMflag=myMenuObj.ImportFlag
				continue:(myIMflag="")||(myIMflag="N") //查看该菜单是否被激活
			}
		   //判断是否有子菜单
		   if ($d(^User.BDPEIMenuI("ParMenuIdx",mySMRowID))>0) s myChildFlag=1
		   else  s myChildFlag=0
			
			s:(myJsonStr'="") myJsonStr=myJsonStr_","
			s myJsonStr=myJsonStr_"{"
			s myJsonStr=myJsonStr_"""id"":"""_""_mySMRowID_""",""text"":"""_myCaption_""","
			s myJsonStr=myJsonStr_"""icon"":"""_""_myImage_""","
			
			if (+myChildFlag'=0) {
				s myJsonStr=myJsonStr_"""leaf"":false,"
				s myJsonStr=myJsonStr_"""expanded"":true"
			}else {
				s myJsonStr=myJsonStr_"""myExeCode"":"""_""_myExeCode_""","
				s myJsonStr=myJsonStr_"""myCode"":"""_""_myCode_""","
				s myJsonStr=myJsonStr_"""leaf"":true"
			}
			s myJsonStr=myJsonStr_"}"
			
			d myMenuObj.%Close()
		}
	}
	
	k myMenuArray
	s myJsonStr="["_myJsonStr_"]"
	
	q myJsonStr
}

/// 考虑有些菜单的代码和 对应的表结构登记会不一样，比如药品新医嘱模式
/// 根据导入菜单的代码，获取这个菜单对应的表，从而通过这个表的属性来判断 医院 及数据模板
/// Other: w ##class(web.DHCBL.BDP.BDPEIMenu).GetTableNameByCode("")
ClassMethod GetTableNameByCode(tablecode As %String) As %String
{
	s EImenuID=$o(^User.BDPEIMenuI("UniqueCodeIndex"," "_$zcvt(tablecode,"U"),0))
	s LinkTableDr=$LISTGET($G(^User.BDPEIMenuD(EImenuID)),13)
	S tablename=""
	if LinkTableDr'="" s tablename=$LISTGET($G(^User.BDPTableListD(LinkTableDr)),8)
	q tablename
}

/// chenying
/// 2022-08-30
/// 获取功能JSON串,用于BDP数据导入、导出界面(HISUI界面)
/// Other: w ##class(web.DHCBL.BDP.BDPEIMenu).GetExecutableTreeJsonHISUI("","I")
ClassMethod GetExecutableTreeJsonHISUI(id As %String, EIflag As %String) As %String
{
	s ParentID=id
	if (ParentID="Root") s ParentID=-100000000000000
	if (ParentID="") s ParentID=-100000000000000
	s mySMRowID=0
	s myMenuCount=0
	s mySMSeq=0
	k myMenuArray
	
	//生成菜单索引数组
	s mySMSeq=0
	s n=0
	for {
		s mySMSeq=$o(^User.BDPEIMenuI("ParSeqIdx",ParentID,mySMSeq))
		q:(mySMSeq="")
		s n=n+1
		s a(n)= $p(mySMSeq," ",2)
	}
	set left=1,right=n
	d:$d(a) ..QuickSort(.a,left,right) //排序
	s mySMRowID=0
	s n=0
	s mySMSeq=0
	for {
		s n=$o(a(n))
		q:(n="")
		s mySMSeq=$g(a(n))
		for {
			s mySMRowID=$o(^User.BDPEIMenuI("ParSeqIdx",ParentID," "_mySMSeq,mySMRowID))
			q:(mySMRowID="")
			s myMenuCount=myMenuCount+1
			s myMenuArray(myMenuCount)=mySMRowID
			;w !,mySMRowID
		}
	}
	
	//输出菜单JSON串
	s mySMRowID=0
	s myMenuSeq=0
	s myJsonStr=""
	for {
		s myMenuSeq=$o(myMenuArray(myMenuSeq))
		q:(myMenuSeq="")
		s mySMRowID=$g(myMenuArray(myMenuSeq))
		
		s myMenuObj=##Class(User.BDPEIMenu).%OpenId(mySMRowID,0)
		if $IsObject(myMenuObj) {
			s myCode = myMenuObj.Code
			s myCaption = myMenuObj.Caption
			s myImage = myMenuObj.Image
			s:myImage'="" myImage= "../scripts/bdp/Framework/BdpIconsLib/"_myMenuObj.Image
			s myExeCode = myMenuObj.TableName		
			if (EIflag="E")
			{
				s myEXflag=myMenuObj.ExportFlag
				continue:(myEXflag="")||(myEXflag="N") //查看该菜单是否被激活
			}
			if (EIflag="I")
			{
				s myIMflag=myMenuObj.ImportFlag
				continue:(myIMflag="")||(myIMflag="N") //查看该菜单是否被激活
			}
		   
		  	s:(myJsonStr'="") myJsonStr=myJsonStr_","
			s myJsonStr=myJsonStr_"{"
			//s myJsonStr=myJsonStr_"""id"":"""_""_mySMRowID_""",""text"":"""_myCaption_""","
			s myJsonStr=myJsonStr_"""icon"":"""_""_myImage_""","
			s childrenstr=""
			//判断是否有子菜单
			if ($d(^User.BDPEIMenuI("ParMenuIdx",mySMRowID))>0) {
				s myJsonStr=myJsonStr_"""leaf"":false,"
				s myJsonStr=myJsonStr_"""expanded"":true"
				//获取子菜单
				s childrenstr=..GetExecutableTreeJsonHISUI(mySMRowID,EIflag)
				s myJsonStr=myJsonStr_",""children"":"_childrenstr
			}else {
				s myJsonStr=myJsonStr_"""myExeCode"":"""_""_myExeCode_""","
				s myJsonStr=myJsonStr_"""myCode"":"""_""_myCode_""","
				s myJsonStr=myJsonStr_"""leaf"":true"
			}
			if $d(^TMPHASIMPORT("BDPData",myCode))>0
			{
				s myCaption="<font color='red'>"_myCaption_"</font>"
				s myJsonStr=myJsonStr_",""imported"":"""_""_"Y"_""""
			}
			else
			{
				if childrenstr[("""imported"":""Y""") s myCaption="<font color='orange'>"_myCaption_"</font>"
				s myJsonStr=myJsonStr_",""imported"":"""_""_"N"_""""
			}
			s myJsonStr=myJsonStr_",""id"":"""_""_mySMRowID_""",""text"":"""_myCaption_""""
			s myJsonStr=myJsonStr_"}"
			d myMenuObj.%Close()
		}
	}
	
	k myMenuArray
	s myJsonStr="["_myJsonStr_"]"
	
	q myJsonStr
}

/// Creator：基础数据平台组 陈莹
/// CreatDate: 2022-09-06
/// Description：用于数据页面中功能项颜色区分
/// input：tableName表名
/// Return:Y/N
/// w ##class(web.DHCBL.BDP.BDPEIMenu).GetImportedFlag("CT_City")
ClassMethod GetImportedFlag(tableName) As %String
{
	q:tableName="" "N"
	if $d(^TMPHASIMPORT("BDPData",tableName))>0 s flag="Y"
	else  s flag="N"
	q flag
}

}
