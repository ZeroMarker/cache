Import SQLUser

/// 名称: 菜单定义
/// 描述: 菜单配置
/// 编写者：基础数据平台组-李森
/// 编写日期: 2013-5-2
/// 最后修改日期：2015-10-27 谷雪萍
Class web.DHCBL.BDP.BDPMenuDefine Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：李森
/// CreatDate: 2013-5-2
/// Description：修改时打开的数据
/// Table：User.BDPMenu
/// Input：id
ClassMethod OpenData(id As %String) As %String
{
 s str="" 
 s eobj = ##class(web.Entity.BDP.BDPMenuDefine).%New()
 s eobj.ID = id
 s eobj.Code=$LISTGET($G(^User.BDPMenuD(id)),2)
 s eobj.Caption=$LISTGET($G(^User.BDPMenuD(id)),3)
 s eobj.LinkFuntionDR=$LISTGET($G(^User.BDPMenuD(id)),4)
 s eobj.LinkUrl=$LISTGET($G(^User.BDPMenuD(id)),5)
 s eobj.Image=$LISTGET($G(^User.BDPMenuD(id)),6)
 s eobj.Method=$LISTGET($G(^User.BDPMenuD(id)),7)
 s eobj.Sequence=$LISTGET($G(^User.BDPMenuD(id)),8)
 s eobj.ShortcutKey=$LISTGET($G(^User.BDPMenuD(id)),9)
 s eobj.ShowInNewWindow=$LISTGET($G(^User.BDPMenuD(id)),10)
 s eobj.ParentMenuDr=$LISTGET($G(^User.BDPMenuD(id)),11)
 s eobj.ValueExpression=$LISTGET($G(^User.BDPMenuD(id)),15)
 s ActiveFlag=$LISTGET($G(^User.BDPMenuD(id)),16)
 if (ActiveFlag'="") {
  s eobj.actMenuBDP=$select($p(ActiveFlag,"^",1)="1":"1", 1:"0")
  s eobj.actMenuAutItem=$select($p(ActiveFlag,"^",2)="1":"1", 1:"0")
  s eobj.actMenuAutData=$select($p(ActiveFlag,"^",3)="1":"1", 1:"0")
 }else {
  s eobj.actMenuBDP="1"
  s eobj.actMenuAutItem="1"
  s eobj.actMenuAutData="1"
 }
 s eobj.CompName=$LISTGET($G(^User.BDPMenuD(id)),17)
 s eobj.ProductLineDr=$LISTGET($G(^User.BDPMenuD(id)),18)
 s eobj.FirstPYCODE=$LISTGET($G(^User.BDPMenuD(id)),19)
 s eobj.WholePYCODE=$LISTGET($G(^User.BDPMenuD(id)),20)
 s eobj.IsMKBMenu=$LISTGET($G(^User.BDPMenuD(id)),21)
 if eobj.IsMKBMenu="Y" s eobj.IsMKBMenu="true"
 else  s eobj.IsMKBMenu="false"
 
 //s str = eobj.JsonS() 
 s str="{Caption:'"_eobj.Caption_"',Code:'"_eobj.Code_"',CompName:'"_eobj.CompName_"',ID:'"_eobj.ID_"',Image:'"_eobj.Image_"',LinkFuntionDR:'"_eobj.LinkFuntionDR_"',LinkUrl:'"_eobj.LinkUrl_"',Method:'"_eobj.Method_"',ParentMenuDr:'"_eobj.ParentMenuDr_"',ProductLineDr:'"_eobj.ProductLineDr_"',FirstPYCODE:'"_eobj.FirstPYCODE_"',WholePYCODE:'"_eobj.WholePYCODE_"',Sequence:'"_eobj.Sequence_"',ShortcutKey:'"_eobj.ShortcutKey_"',ShowInNewWindow:'"_eobj.ShowInNewWindow_"',ValueExpression:'"_eobj.ValueExpression_"',actMenuAutData:'"_eobj.actMenuAutData_"',actMenuAutItem:'"_eobj.actMenuAutItem_"',actMenuBDP:'"_eobj.actMenuBDP_"',IsMKBMenu:'"_eobj.IsMKBMenu_"'}"
 d eobj.%Close()
 s str = "{list:["_str_"]}"
 q str
}

/// CreatDate: 2015-12-7
/// Description：是否用组件,有多个组件的也要刷新
/// Other: w ##class(web.DHCBL.BDP.BDPMenuDefine).IFComp("612")
ClassMethod IFComp(id As %String) As %String
{
 s Flag="" 
 s groupCompStr=""
 s groupCompStr=groupCompStr_"[dhcconfigurepatenroll]^[udhchardcommanager]^[dhc.bdp.AS.Edit]^[DHCSSUser.TransDoc]^[UDHCDocPilotProjectUpdate]^[UDHCDocPilotProjectPay]^[DHCDocCT.Define]^"      //医生站配置
 s groupCompStr=groupCompStr_"[dhc.bdp.DHCNurAccess]^[dhc.bdp.DHCNURSET]^[dhc.bdp.dhcnursetcolumn]^"   //护理系统配置
 s groupCompStr=groupCompStr_"[DHCOPBillHDDC]^"    //门诊收费配置
 s groupCompStr=groupCompStr_"[pharmacy.displocsetting]^[pharmacy.addlocgrpsetting]^"    //住院药房配置
 s groupCompStr=groupCompStr_"[DHCSTPIVAS.PRIORITY]^[DHCST.PIVA.FEECONFIG]^[DHCST.PIVA.LOCGRP]^"   //静脉配液中心配置
 s groupCompStr=groupCompStr_"[DHC.RIS.APPLINK]^[DHC.RIS.LocEqumentLINK]^[DHC.RIS.ItmGoalMemoLINK]^"   //RIS预约平台配置
 s groupCompStr=groupCompStr_"[dhcanopsetreport]"    //门诊收费配置
 if (id'=""){
     s CompName=$LISTGET($G(^User.BDPMenuD(id)),17)
     if (CompName'=""){
         s Flag="Y"
     }else{
         s Code=$LISTGET($G(^User.BDPMenuD(id)),2)
         s Code=$tr(Code," ","")
         if (groupCompStr[Code){             
            s Flag="Y" 
         }else{
            s Flag="N"
         }
     }
 }
 else{
    s Flag="N" 
 }
 q Flag
}

/// Creator：李森
/// CreatDate: 2013-5-2
/// Description：数据重复验证方法，由js调用
/// Table：User.BDPMenu
/// Input：id, code
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String) As %String
{
 s:code'="" code=" "_$ZCONVERT(code,"U") //转换成大写
 s flag="",flagc=""
 s:code'="" flagc=$d(^User.BDPMenuI("UniqueCodeIndex",code))
 if (id="") //如果为空，增加时的重复判断
 {
  if (flagc>0) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc=""
  s:code'="" idc=$o(^User.BDPMenuI("UniqueCodeIndex",code,0))
  if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 q flag
}

/// Creator：李森
/// CreatDate: 2013-5-2
/// Description：数据重复验证方法
/// Table：User.BDPMenu
/// Input：id, code
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String) As %String
{
 s:code'="" code=" "_$ZCONVERT(code,"U") //转换成大写
 s flag="",flagc=""
 s:code'="" flagc=$d(^User.BDPMenuI("UniqueCodeIndex",code))
 if (id="") //如果为空，增加时的重复判断
 {
  if (flagc>0) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc=""
  s:code'="" idc=$o(^User.BDPMenuI("UniqueCodeIndex",code,0))
  if ((idc'=id)&(flagc>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 q flag
}

/// Creator：李森
/// CreatDate: 2013-5-2
/// Description：保存修改
/// Table：User.BDPMenu
/// Input：web.Entity.BDP.BDPMenuDefine 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.BDP.BDPMenuDefine).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.BDP.BDPMenuDefine, tempImage As %String = "") As %String
{
	s result="",flag=""
	if $IsObject(eobj)
	{
		s:eobj.IsMKBMenu="" eobj.IsMKBMenu="N"
		s flag=..Validate(eobj.ID,eobj.Code)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{
			if (eobj.Caption'="")
			{
		    	s eobj.FirstPYCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE($ZCONVERT(eobj.Caption,"U")) //首拼
		    	s eobj.WholePYCODE=##class(web.DHCBL.BDP.FunLib).GetCNCODE($ZCONVERT(eobj.Caption,"U"),3,"")  //全拼
			}
			s:eobj.Sequence'="" eobj.Sequence=$ZCONVERT(eobj.Sequence,"U")
			if (eobj.Image="")
			{ 
			   s eobj.Image=tempImage 
			   if (eobj.Image["../scripts/bdp/Framework/BdpIconsLib/")
			   {
			      s eobj.Image=$p(eobj.Image,"../scripts/bdp/Framework/BdpIconsLib/",2)
			   }
			}
			else
			{ 
			   s tempImage=""
			}

			if (eobj.ID="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.BDPMenu).%New()
			}
			else                     //如果RowId已赋值则修改
			{
				s obj=##class(User.BDPMenu).%OpenId(eobj.ID)
				s bobj=##class(web.Entity.BDP.BDPMenuDefine).%New()
				s bobj.ID=eobj.ID
				s bobj.Code = obj.Code           
				s bobj.Caption = obj.Caption          
				s:obj.LinkFuntionDR'="" bobj.LinkFuntionDR=obj.LinkFuntionDR.%Id()
				s bobj.LinkUrl =  obj.LinkUrl
				s bobj.Image = obj.Image
				s bobj.Method = obj.Method
				s bobj.Sequence = obj.Sequence
				s bobj.ShortcutKey = obj.ShortcutKey
				s bobj.ShowInNewWindow = obj.ShowInNewWindow
				s:obj.ParentMenuDr'="" bobj.ParentMenuDr=obj.ParentMenuDr.%Id()
				s:obj.ProductLineDr'="" bobj.ProductLineDr=obj.ProductLineDr.%Id()
				s bobj.ValueExpression = obj.ValueExpression
				s bobj.CompName=obj.CompName
				s bobj.FirstPYCODE=obj.FirstPYCODE
				s bobj.WholePYCODE=obj.WholePYCODE
				if (obj.ActiveFlag){
					s bobj.actMenuBDP = $p(obj.ActiveFlag,"^",1)
					if (bobj.actMenuBDP="") s bobj.actMenuBDP ="0"
					s bobj.actMenuAutItem=$p(obj.ActiveFlag,"^",2)
					if (bobj.actMenuAutItem="") s bobj.actMenuAutItem="0"
					s bobj.actMenuAutData=$p(obj.ActiveFlag,"^",3)
					if (bobj.actMenuAutData="") s bobj.actMenuAutData="0"
				}
				s bobj.IsMKBMenu=obj.IsMKBMenu
				
			}  
			Ts
			s obj.Code = eobj.Code          //修改代码
			s obj.Caption = eobj.Caption          //修改描述
			d obj.LinkFuntionDRSetObjectId(eobj.LinkFuntionDR)
			s obj.LinkUrl = eobj.LinkUrl

			s obj.Image =eobj.Image
			s obj.Method = eobj.Method
			s obj.Sequence = eobj.Sequence
			s obj.ShortcutKey = eobj.ShortcutKey
			s obj.ShowInNewWindow = eobj.ShowInNewWindow
			d obj.ParentMenuDrSetObjectId(eobj.ParentMenuDr)
			d obj.ProductLineDrSetObjectId(eobj.ProductLineDr)
			s obj.UpdateDate = +$p($h,",",1)
			s obj.UpdateTime = +$p($h,",",2)
			d obj.UpdateUserSetObjectId($Get(%session.Data("LOGON.USERID")))
			s obj.ValueExpression = eobj.ValueExpression
			s obj.CompName=eobj.CompName
			s obj.FirstPYCODE=eobj.FirstPYCODE
			s obj.WholePYCODE=eobj.WholePYCODE
			s obj.IsMKBMenu=eobj.IsMKBMenu
			
			s ActiveFlag = ""
			if (eobj.actMenuBDP="1") 
			{
				s $p(ActiveFlag,"^",1)="1"
			}
			else 
			{
				s eobj.actMenuBDP="0"
				s $p(ActiveFlag,"^",1)="0"
			}

			if (eobj.actMenuAutItem="1") 
			{
				s $p(ActiveFlag,"^",2)="1"
			}
			else 
			{
				s eobj.actMenuAutItem="0"
				s $p(ActiveFlag,"^",2)="0"
			}

			if (eobj.actMenuAutData="1") 
			{
				s $p(ActiveFlag,"^",3)="1"
			}
			else 
			{
				s eobj.actMenuAutData="0"
				s $p(ActiveFlag,"^",3)="0"
			}
			s obj.ActiveFlag = ActiveFlag 
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"  //返回RowId
				d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_Menu","User.BDPMenu","菜单定义",id,eobj.Caption,"A",eobj)
				d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_Menu","User.BDPMenu","菜单定义",eobj.ID,eobj.Caption,"U",eobj,bobj)
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
/// Description：菜单定义
/// Table：User.BDPMenu
/// d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPMenuDefine","GetList","","","","")
Query GetList(rowid As %String, myCode As %String, myCaption As %String, myParMenu As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Caption:%String,LinkFuntionDR:%String,LinkUrl:%String,Image:%String,Method:%String,Sequence:%String,ShortcutKey:%String,ShowInNewWindow:%String,ParentMenuDr:%String,UpdateDate:%String,UpdateTime:%String,UpdateUser:%String,ValueExpression:%String,CompName:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, myCode As %String, myCaption As %String, myParMenu As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (rowid'="") //根据rowid返回该条记录
 {
  s ID=rowid
  s Code=$LISTGET($G(^User.BDPMenuD(ID)),2)
  s Caption=$LISTGET($G(^User.BDPMenuD(ID)),3)
  s LinkFuntionDR=$LISTGET($G(^User.BDPMenuD(ID)),4)
  s:LinkFuntionDR'="" LinkFuntionDR=$LISTGET($G(^User.BDPExecutablesD(LinkFuntionDR)),3) //获取功能名称
  s LinkUrl=$LISTGET($G(^User.BDPMenuD(ID)),5)
  s Image=$LISTGET($G(^User.BDPMenuD(ID)),6)
  s Method=$LISTGET($G(^User.BDPMenuD(ID)),7)
  s Sequence=$LISTGET($G(^User.BDPMenuD(ID)),8)
  s ShortcutKey=$LISTGET($G(^User.BDPMenuD(ID)),9)
  s ShowInNewWindow=$LISTGET($G(^User.BDPMenuD(ID)),10)
  s ParentMenuDr=$LISTGET($G(^User.BDPMenuD(ID)),11)
  s:ParentMenuDr'="" ParentMenuDr=$LISTGET($G(^User.BDPMenuD(ParentMenuDr)),3) //获取菜单描述
  s UpdateDate=$LISTGET($G(^User.BDPMenuD(ID)),12)
  s UpdateTime=$LISTGET($G(^User.BDPMenuD(ID)),13)
  s UpdateUser=$LISTGET($G(^User.BDPMenuD(ID)),14)
  s:UpdateUser'="" UpdateUser=$p($g(^SSU("SSUSR",UpdateUser)),"^",1) //获取用户名
  s ValueExpression=$LISTGET($G(^User.BDPMenuD(ID)),15) 
  s CompName=$LISTGET($G(^User.BDPMenuD(ID)),17)
 
  s:UpdateDate'="" UpdateDate=$zd(UpdateDate,1) //转换日期格式
  s:UpdateTime'="" UpdateTime=$zt(UpdateTime,1) //转换时间格式
  d OutputRow
 }
 else
 {
  s:myCode'="" myCode=$$ALPHAUP^SSUTIL4(myCode) //转换成大写
  s:myCaption'="" myCaption=$$ALPHAUP^SSUTIL4(myCaption) //转换成大写
  s:myParMenu'="" myParMenu=$$ALPHAUP^SSUTIL4(myParMenu) //转换成大写
  s ID=0
  f  s ID=$o(^User.BDPMenuD(ID)) q:ID=""  d
  .s Code=$LISTGET($G(^User.BDPMenuD(ID)),2)
  .s Caption=$LISTGET($G(^User.BDPMenuD(ID)),3)
  .s LinkFuntionDR=$LISTGET($G(^User.BDPMenuD(ID)),4)
  .s:LinkFuntionDR'="" LinkFuntionDR=$LISTGET($G(^User.BDPExecutablesD(LinkFuntionDR)),3) //获取功能名称
  .s LinkUrl=$LISTGET($G(^User.BDPMenuD(ID)),5)
  .s Image=$LISTGET($G(^User.BDPMenuD(ID)),6)
  .s Method=$LISTGET($G(^User.BDPMenuD(ID)),7)
  .s Sequence=$LISTGET($G(^User.BDPMenuD(ID)),8)
  .s ShortcutKey=$LISTGET($G(^User.BDPMenuD(ID)),9)
  .s ShowInNewWindow=$LISTGET($G(^User.BDPMenuD(ID)),10)
  .s ParentMenuDr=$LISTGET($G(^User.BDPMenuD(ID)),11)
  .s:ParentMenuDr'="" ParentMenuDr=$LISTGET($G(^User.BDPMenuD(ParentMenuDr)),3) //获取菜单描述
  .s UpdateDate=$LISTGET($G(^User.BDPMenuD(ID)),12)
  .s UpdateTime=$LISTGET($G(^User.BDPMenuD(ID)),13)
  .s UpdateUser=$LISTGET($G(^User.BDPMenuD(ID)),14)
  .s:UpdateUser'="" UpdateUser=$p($g(^SSU("SSUSR",UpdateUser)),"^",1) //获取用户名
  .s ValueExpression=$LISTGET($G(^User.BDPMenuD(ID)),15)
  .s CompName=$LISTGET($G(^User.BDPMenuD(ID)),17) 
 
  .s:UpdateDate'="" UpdateDate=$zd(UpdateDate,1) //转换日期格式
  .s:UpdateTime'="" UpdateTime=$zt(UpdateTime,1) //转换时间格式
  .i ($$ALPHAUP^SSUTIL4(Code)[myCode)&($$ALPHAUP^SSUTIL4(Caption)[myCaption)&($$ALPHAUP^SSUTIL4(ParentMenuDr)[myParMenu) d
  ..d OutputRow
 }
  
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(ID,Code,Caption,LinkFuntionDR,LinkUrl,Image,Method,Sequence,ShortcutKey,ShowInNewWindow,ParentMenuDr,UpdateDate,UpdateTime,UpdateUser,ValueExpression,CompName)
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

/// Creator：李森
/// CreatDate: 2013-5-2
/// Description：根据ID删除
/// Table：User.BDPMenu
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	s result = "",flag=""
	s flag=$d(^User.BDPMenuI("ParMenuIdx",id)) //判断该菜单是否被引用
	if (flag>0)
	{
		s result = "{success:'false',info:'该菜单已被引用,禁止删除！'}"   
	}
	else
	{
		s eobj = ##class(web.Entity.BDP.BDPMenuDefine).%New()
		s eobj.ID = id
		s eobj.Code=$LISTGET($G(^User.BDPMenuD(id)),2)
		s eobj.Caption=$LISTGET($G(^User.BDPMenuD(id)),3)
		s eobj.LinkFuntionDR=$LISTGET($G(^User.BDPMenuD(id)),4)
		s eobj.LinkUrl=$LISTGET($G(^User.BDPMenuD(id)),5)
		s eobj.Image=$LISTGET($G(^User.BDPMenuD(id)),6)
		s eobj.Method=$LISTGET($G(^User.BDPMenuD(id)),7)
		s eobj.Sequence=$LISTGET($G(^User.BDPMenuD(id)),8)
		s eobj.ShortcutKey=$LISTGET($G(^User.BDPMenuD(id)),9)
		s eobj.ShowInNewWindow=$LISTGET($G(^User.BDPMenuD(id)),10)
		s eobj.ParentMenuDr=$LISTGET($G(^User.BDPMenuD(id)),11)
		s eobj.ValueExpression=$LISTGET($G(^User.BDPMenuD(id)),15)
		s eobj.CompName=$LISTGET($G(^User.BDPMenuD(id)),17)
		s eobj.ProductLineDr=$LISTGET($G(^User.BDPMenuD(id)),18)
		s eobj.FirstPYCODE=$LISTGET($G(^User.BDPMenuD(id)),19)
		s eobj.WholePYCODE=$LISTGET($G(^User.BDPMenuD(id)),20)

		s sc=##class(User.BDPMenu).%DeleteId(id)
		if $$$ISOK(sc)
		{
			s result = "{success:'true',info:'删除成功！'}" 
			//保存日志
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_Menu","User.BDPMenu","菜单定义",id,eobj.Caption,"D",eobj)
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
/// w ##class(web.DHCBL.BDP.BDPMenuDefine).GetMenuForCmb("menuTreeRoot",3)
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
  s mySMSeq=$o(^User.BDPMenuI("ParSeqIdx",id,mySMSeq))
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
   s mySMRowID=$o(^User.BDPMenuI("ParSeqIdx",id," "_mySMSeq,mySMRowID))
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
  
  s myMenuObj=##Class(User.BDPMenu).%OpenId(mySMRowID,0)
  if $IsObject(myMenuObj) {
   s myCode = myMenuObj.Code
   s myCaption = myMenuObj.Caption
   s myLinkUrl = myMenuObj.LinkUrl
   s myImage = myMenuObj.Image
   s:myImage'="" myImage = "../scripts/bdp/Framework/BdpIconsLib/"_myMenuObj.Image
   /*if (myImage'=""){
    s:(($e(myImage,1)="/")||($e(myImage,1)="\")) myImage=$e(myImage,2,$l(myImage))
    s myImage=$tr(myImage,"\","/")
    s myImage="../scripts/bdp/Framework/icons/"_myImage
   }*/
   
   //判断是否有子菜单
   if (myLinkUrl="") s myChildFlag=1
   else  s myChildFlag=0
   
   if (+myChildFlag'=0) {
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
 }
 
 k myMenuArray
 s myJsonStr="["_myJsonStr_"]"
 
 q myJsonStr
}

/// 2013-5-21 by lisen
/// Description：获取菜单树,按ascii排序,用于BDPMain.js
/// Table：User.BDPMenu
/// Input：id:父节点rowid, SessionStr
/// Ohter: w ##class(web.DHCBL.BDP.BDPMenuDefine).GetMenu("menuTreeRoot","^^^1^^^^")
ClassMethod GetMenu2(id As %String, SessionStr As %String) As %String
{
 s grpId=$p(SessionStr,"^",4)
 if (id="menuTreeRoot") s id=-100000000000000
 s mySMRowID=0
 s myMenuCount=0
 s mySMSeq=0
 k myMenuArray
 
 //生成菜单索引数组
 s mySMSeq=0
 for {
  ;q:(+mySMRowID>0)
  s mySMSeq=$o(^User.BDPMenuI("ParSeqIdx",id,mySMSeq))
  q:(mySMSeq="")
  s mySMRowID=0
  for {
   s mySMRowID=$o(^User.BDPMenuI("ParSeqIdx",id,mySMSeq,mySMRowID))
   q:(mySMRowID="")
   s myMenuCount=myMenuCount+1
   s myMenuArray(myMenuCount)=mySMRowID
   ;w !,mySMRowID
  }
 }
 
 //获取授权JSON
 s myGroupId=""
 s strAutMenu=##class(web.DHCBL.Authorize.Menu).DHCGetDataByDefaultSession()
 
 //输出菜单JSON串
 s mySMRowID=0
 s myMenuSeq=0
 s myJsonStr=""
 for {
  ;q:(+myMenuSeq>1)
  s myMenuSeq=$o(myMenuArray(myMenuSeq))
  q:(myMenuSeq="")
  s mySMRowID=$g(myMenuArray(myMenuSeq))
  
  s myMenuObj=##Class(User.BDPMenu).%OpenId(mySMRowID,0)
  if $IsObject(myMenuObj) {
   s myCode = myMenuObj.Code
   s myCaption = myMenuObj.Caption
   s myLinkFuntionDR = myMenuObj.LinkFuntionDR
   s myLinkUrl = myMenuObj.LinkUrl
   s myImage =myMenuObj.Image
   s:myImage'="" myImage = "../scripts/bdp/Framework/BdpIconsLib/"_myMenuObj.Image
   s myMethod = myMenuObj.Method
   s myShowInNewWindow = myMenuObj.ShowInNewWindow   
   /*if (myImage'=""){
    s:(($e(myImage,1)="/")||($e(myImage,1)="\")) myImage=$e(myImage,2,$l(myImage))
    s myImage=$tr(myImage,"\","/")
    s myImage="../scripts/bdp/Framework/icons/"_myImage
   }*/
   if (myLinkUrl'=""){
    s myLinkUrl="dhc.bdp.ext.sys.csp?BDPMENU="_mySMRowID
   }
   //判断是否有子菜单
   if ((myLinkUrl="")) s myChildFlag=1
   else  s myChildFlag=0
   
   //判断菜单是否有权显示
   s strMenu="{ID:"_mySMRowID_"}"
   if ((strAutMenu[strMenu)||(1=grpId)) s myMenuEnable=1
   else  s myMenuEnable=0
   
   if (+myMenuEnable) {
    s:(myJsonStr'="") myJsonStr=myJsonStr_","
    s myJsonStr=myJsonStr_"{"
    s myJsonStr=myJsonStr_"""id"":"""_""_mySMRowID_""",""text"":"""_myCaption_""","
    s myJsonStr=myJsonStr_"""iconCls"":"""_""_myImage_""","
    if (+myChildFlag'=0) {
     s myJsonStr=myJsonStr_"""leaf"":false"
    }else {
     s myJsonStr=myJsonStr_"""myhref"":"""_""_myLinkUrl_""","
     s myJsonStr=myJsonStr_"""leaf"":true"
    }
    s myJsonStr=myJsonStr_"}"
   }
   d myMenuObj.%Close()
  }
 }
 
 k myMenuArray
 s myJsonStr="["_myJsonStr_"]"
 
 q myJsonStr
}

/// w ##class(web.DHCBL.BDP.BDPMenuDefine).GetTreeJson2("menuTreeRoot")
ClassMethod GetTreeJson2(ParentID As %String) As %String
{
    if (ParentID="menuTreeRoot") s ParentID=-100000000000000
    s mySMRowID=0
    s myMenuCount=0
    s mySMSeq=0
    k myMenuArray
    
    //生成菜单索引数组
    s mySMSeq=0
    s n=0
    for {
        s mySMSeq=$o(^User.BDPMenuI("ParSeqIdx",ParentID,mySMSeq))
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
            s mySMRowID=$o(^User.BDPMenuI("ParSeqIdx",ParentID," "_mySMSeq,mySMRowID))
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
        
        s myMenuObj=##Class(User.BDPMenu).%OpenId(mySMRowID,0)
        if $IsObject(myMenuObj) {
            s myCode = myMenuObj.Code
            s myCaption = myMenuObj.Caption
            s myLinkUrl = myMenuObj.LinkUrl
            s myImage =myMenuObj.Image
            s:myImage'="" myImage = "../scripts/bdp/Framework/BdpIconsLib/"_myMenuObj.Image
            s actMenuBDP = $p(myMenuObj.ActiveFlag,"^",1)
            
            //判断是否有子菜单
            if ((myLinkUrl="")) s myChildFlag=1
            else  s myChildFlag=0
            
            //判断基础数据维护菜单是否激活
            if (actMenuBDP="1") s myMenuEn=1
            else  s myMenuEn=0
            //if (+myMenuEn) {
                s:(myJsonStr'="") myJsonStr=myJsonStr_","
                s myJsonStr=myJsonStr_"{"
                s myJsonStr=myJsonStr_"""id"":"""_""_mySMRowID_""",""text"":"""_myCaption_""","
                s myJsonStr=myJsonStr_"""iconCls"":"""_""_myImage_""","
                
                //s myJsonStr=myJsonStr_"""checked"":false,"
                
                if (+myMenuEn){
                    s myJsonStr=myJsonStr_"""checked"":true,"
                }else{
                    s myJsonStr=myJsonStr_"""checked"":false,"
                }
            
                if (+myChildFlag'=0) {
                    s myJsonStr=myJsonStr_"""leaf"":false,"
                    s myJsonStr=myJsonStr_"""expanded"":true"
                }else {
                    s myJsonStr=myJsonStr_"""leaf"":true"
                }
                s myJsonStr=myJsonStr_"}"
            //}
            
            d myMenuObj.%Close()
        }
    }
    
    k myMenuArray
    s myJsonStr="["_myJsonStr_"]"
    
    q myJsonStr
}

/// w ##class(web.DHCBL.BDP.BDPMenuDefine).SaveTreeJson2("")
ClassMethod SaveTreeJson2(Data As %String) As %String
{
    s result="",flag=""
    s ID=0
    TS
    for{
          s ID=$o(^User.BDPMenuD(ID)) q:ID=""  d
          s obj=##class(User.BDPMenu).%OpenId(ID)
          s ActiveFlag = obj.ActiveFlag
          s str="{ID:"_ID_"}"
          if (Data[str){
               s $p(ActiveFlag,"^",1)="1"     
          }else{
               s $p(ActiveFlag,"^",1)="0"
               s $p(ActiveFlag,"^",2)="0"
               s $p(ActiveFlag,"^",3)="0"
          }
          s obj.ActiveFlag=ActiveFlag         
          s sc=obj.%Save()
          d obj.%Close()
          If $$$ISOK(sc){
              s result = "{success:'true'}"  //返回RowId
          } else {
              s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
           }
    
    }
    if (result["true")
    {
        Tc
    }
    else
    {
        Trollback
        s result = "{success:'false',errorinfo:'保存失败'}"
    }
    q result
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

/// 2015-7-30 by 谷雪萍
/// Description：获取有权显示的菜单id,病拼成串，在GetHtmlMenu和GetHtmlLevel方法中被调用
/// Table：User.BDPMenu
/// Input：id:父节点rowid, SessionStr
/// Ohter: w ##class(web.DHCBL.BDP.BDPMenuDefine).GetMenuId("menuTreeRoot","^^^1^^^^")
ClassMethod GetMenuId(id As %String, SessionStr As %String, desc As %String) As %String
{
	s myGroupId=""
	//获取授权JSON
	s strAutMenu=##class(web.DHCBL.Authorize.Menu).DHCGetDataByDefaultSession()
	//s strAutMenu=""
	s grpId=$p(SessionStr,"^",4)

	//获取满足搜索条件的菜单id
	if (desc'="")
	{
		s desc=$ZCONVERT(desc,"U")
		s strSearch=..SearchMenu(desc)
	}

	if (id="menuTreeRoot") s id=-100000000000000
	s mySMRowID=0
	s myMenuCount=0

	//生成菜单索引数组
	s mySMSeq=0
	s n=0
	for 
	{
		s mySMSeq=$o(^User.BDPMenuI("ParSeqIdx",id,mySMSeq))
		q:(mySMSeq="")
		s n=n+1
		s a(n)= $p(mySMSeq," ",2)
	}
	set left=1,right=n
	d:$d(a) ..QuickSort(.a,left,right) //排序
	s mySMRowID=0
	s n=0
	s mySMSeq=0
	for 
	{
		s n=$o(a(n))
		q:(n="")
		s mySMSeq=$g(a(n))
		for 
		{
			s mySMRowID=$o(^User.BDPMenuI("ParSeqIdx",id," "_mySMSeq,mySMRowID)) 
			q:(mySMRowID="")
			s myMenuCount=myMenuCount+1
			//判断菜单是否有权显示
			s strMenu="{ID:"_mySMRowID_"}"

			if ((strAutMenu[strMenu)||(1=grpId)) s myMenuEnable=1
			else  s myMenuEnable=0

			  //判断是否满足搜索条件
			s searchEnable=""
			if (desc'="")
			{
			   if (strSearch[strMenu)
			   {
			       s searchEnable=1
			   }
			   else
			   { 
			       s searchEnable=0
			   }
			}
			else
			{
			   s searchEnable=1
			}

			//有权显示且满足搜索条件则拼成串
			if ((+myMenuEnable)&(+searchEnable))
			{
			   if (myGroupId'="")
			   {
			       s myGroupId=myGroupId_"^"_mySMRowID
			   }
			   else
			   {
			       s myGroupId=mySMRowID    
			   }
			}

			//s myMenuArray(myMenuCount)=mySMRowID
			;w !,mySMRowID
		}
	}
	q myGroupId
}

/// 2015-7-30 by 谷雪萍
/// Description：获取第二三级的菜单树,供GetHtmlMenu方法调用
/// Table：User.BDPMenu
/// Input：id:父节点mySMRowID, SessionStr
/// Ohter: d ##class(web.DHCBL.BDP.BDPMenuDefine).GetHtmlLevel("1","^^^1^^^^")
ClassMethod GetHtmlLevel(mySMRowID As %String, SessionStr As %String, desc As %String, mkbflag As %String = "") As %String
{
     s htmlStr2=""
     s htmlStr3=""
     s myGroupId2=..GetMenuId(mySMRowID,SessionStr,desc)
     if (myGroupId2'="")
     {
         //s htmlStr2="<ul class=""submenu"">"
         w !,"<ul class=""submenu"">",!
         s mySMRowID2=0
         s Len2=$Length(myGroupId2,"^")
         for j=1:1:Len2 
         {
             s mySMRowID2=$p(myGroupId2,"^",j)
             s myMenuObj2=##Class(User.BDPMenu).%OpenId(mySMRowID2,0)
             if $IsObject(myMenuObj2) 
             {            
				s myActiveFlag2 = myMenuObj2.ActiveFlag
				continue:(myActiveFlag2'="")&&('$p(myActiveFlag2,"^",1)) //查看该菜单是否被激活
			   	s IsMKBMenu=myMenuObj2.IsMKBMenu
			   	if mkbflag="" continue:IsMKBMenu="Y"   //如果是医学知识库的菜单则跳过
		   		if mkbflag="Y" continue:IsMKBMenu'="Y"
				s myCode2 = myMenuObj2.Code
				s myCaption2 = myMenuObj2.Caption
				
				//菜单版本
				s ShortcutKey=$LISTGET($G(^User.BDPMenuD(mySMRowID2)),9)
				if ShortcutKey'=""
				{
					s MenuVersion= ##class(web.DHCBL.BDP.BDPMenuVersion).GetMenuVersion(mySMRowID2)
					s myCaption2 =myCaption2_MenuVersion
				}
				s myLinkFuntionDR2 = myMenuObj2.LinkFuntionDR
				s myLinkUrl2 = myMenuObj2.LinkUrl
				s myImage2 = myMenuObj2.Image
				s:myImage2'="" myImage2 = "../scripts/bdp/Framework/BdpIconsLib/"_myMenuObj2.Image
				s ParentMenuDr2=""
				s:myMenuObj2.ParentMenuDr'="" ParentMenuDr2=myMenuObj2.ParentMenuDr.%Id()
				if (myLinkUrl2'="")
				{
					s myLinkUrl2="dhc.bdp.ext.sys.csp?BDPMENU="_mySMRowID2
				}
				//判断是否有子菜单
				if ((myLinkUrl2="")) s myChildFlag2=1
				else  s myChildFlag2=0

				if (+myChildFlag2'=0) 
				{
				     /*s htmlStr2=htmlStr2_"<li class=""""><a href=""javascript:void(0);"" class=""dropdown-toggle""><i class=""menu-icon fa  fa-caret-right""></i>"_myCaption2_" <b class=""arrow fa fa-angle-down""></b>  </a> <b class=""arrow""></b>"
				     s htmlStr3=..GetHtmlLevel(mySMRowID2,SessionStr)
				     s htmlStr2=htmlStr2_""_htmlStr3_"</li>"*/
				      
				    w "<li id='li_parent_"_mySMRowID2_"'>",!
				    w "    <a href=""javascript:void(0);"" class=""dropdown-toggle"">",!
				    if (myImage2'="")
				    {
				        w "<img src='"_myImage2_"'>",!  
				    }
				    else
				    {
				        // w "      <i class=""menu-icon fa  fa-caret-right""></i>",!
				        w "<img src=""../scripts/bdp/Framework/BdpIconsLib/CT_Zip.png"">",! 
				    }
				     w "        "_myCaption2,!
				     w "        <b class=""arrow fa fa-angle-down""></b>",!  
				     w "    </a>",!
				     w "    <b class=""arrow""></b>",!
				     d ..GetHtmlLevel(mySMRowID2,SessionStr,desc,mkbflag)                 
				     w "</li>" ,!                               

				}
				else 
				{
				    //s htmlStr2=htmlStr2_"<li class=""""><a RowID='"_mySMRowID2_"' id='"_mySMRowID2_"'  href=""javascript:void(0);""  onclick=""showNavTab("_mySMRowID2_",'"_myCaption2_"','"_myLinkUrl2_"','"_ParentMenuDr2_"',' fa-book')""><i class=""menu-icon fa fa-caret-right""></i>"_myCaption2_"</a>    <b class=""arrow""></b></li>"

				    w "<li class="""">",!
				    w "    <a RowID='"_mySMRowID2_"' id='"_mySMRowID2_"'  href=""javascript:void(0);""  onclick=""showNavTab("_mySMRowID2_",'"_myCaption2_"','"_myLinkUrl2_"','"_ParentMenuDr2_"','"_myImage2_"')"">",!
				    
				    if (myImage2'=""){
				        w "<img src="_myImage2_">",!    
				    }
				    else{
				        w "        <i class=""menu-icon fa fa-leaf green""></i>",!
				    }
				    //w "<img src=""../scripts/bdp/Framework/BdpIconsLib/系统配置/BDP功能大表维护.png"">",!
				    w "         "_myCaption2,!
				    w "    </a>",!
				    w "    <b class=""arrow""></b>",!
				    w "</li>",!

				}
				d myMenuObj2.%Close()
			} 

         }
         
         //s htmlStr2=htmlStr2_"</ul>"
         w "</ul>",!
     }
     //q htmlStr2
}

/// 2015-7-30 by 谷雪萍
/// Description：获取菜单树,用于Html页面显示菜单
/// Table：User.BDPMenu
/// Input：id:父节点rowid, SessionStr
/// Ohter: d ##class(web.DHCBL.BDP.BDPMenuDefine).GetHtmlMenu("^^^1^^^^","","","Y")
ClassMethod GetHtmlMenu(SessionStr As %String, desc As %String, id As %String = "", mkbflag As %String = "") As %String
{
	//s id="menuTreeRoot"
	if id="" s id="menuTreeRoot"
	s myGroupId=""
	s myGroupId=..GetMenuId(id,SessionStr,desc)
	//s htmlStr="<ul id=""navmenu"" class=""nav nav-list"">"
	w "<ul id=""navmenu"" class=""nav nav-list"">",!
	s htmlStr2=""
	s mySMRowID=0
	s Len=$Length(myGroupId,"^")
	for i=1:1:Len      
	{
		s mySMRowID=$p(myGroupId,"^",i)
		s myMenuObj=##Class(User.BDPMenu).%OpenId(mySMRowID,0)
		if $IsObject(myMenuObj) 
		{
			s myActiveFlag = myMenuObj.ActiveFlag
			continue:(myActiveFlag'="")&&('$p(myActiveFlag,"^",1)) //查看该菜单是否被激活
		   	s IsMKBMenu=myMenuObj.IsMKBMenu
		   	if mkbflag="" continue:IsMKBMenu="Y"   //如果是医学知识库的菜单则跳过
		   	if mkbflag="Y" continue:IsMKBMenu'="Y"
			s myCaption = myMenuObj.Caption
			s myLinkUrl = myMenuObj.LinkUrl
			//判断是否有子菜单
			if ((myLinkUrl="")) s myChildFlag=1
			else  s myChildFlag=0


			if (+myChildFlag'=0) 
			{			    
			    /*s htmlStr=htmlStr_"<li class=""""> <a href=""javascript:void(0);"" class=""dropdown-toggle""> <i class=""menu-icon fa fa-desktop""></i> <span class=""menu-text"">"_myCaption_"</span>  <b class=""arrow fa fa-angle-down""></b>  </a> <b class=""arrow""></b>"
			     //子菜单
			    s htmlStr2=..GetHtmlLevel(mySMRowID,SessionStr)
			    s htmlStr=htmlStr_htmlStr2_"</li>"   //一级菜单拼接二级菜单*/
			    
			    //样式：desktop, key, cog, flask user
			    s menuIcon="desktop"
			    s:myCaption["系统配置" menuIcon="key"
			    s:myCaption["产品配置" menuIcon="cog"
			    s:myCaption["临床知识库" menuIcon="book"
			    s:myCaption["医学知识库" menuIcon="flask"
			    s:myCaption["平台配置" menuIcon="edit"
			    s:myCaption["内部管理" menuIcon="user"
			    
			     w "<li class="""">",!
			     w "    <a href=""javascript:void(0);"" class=""dropdown-toggle"">",!
			     w "        <i class=""menu-icon fa fa-"_menuIcon_"""></i>",!
			     w "        <span class=""menu-text"">"_myCaption_"</span>",!
			     w "        <b class=""arrow fa fa-angle-down""></b>",!
			     w "    </a>",!
			     w "    <b class=""arrow""></b>",!
			     d ..GetHtmlLevel(mySMRowID,SessionStr,desc,mkbflag)
			     w "</li>",!
			    
			                      
			}
			else 
			{         
			    //s htmlStr=""  
			    w ""        
			}
			d myMenuObj.%Close()
		}   
	 
	}
	w "</ul>",! 
	//s htmlStr=htmlStr_"</ul>"
	//q htmlStr
}

/// 2015-7-30 by 谷雪萍
/// Description：获取第二三级的菜单树,供GetHtmlMenu方法调用
/// Table：User.BDPMenu
/// Input：id:父节点mySMRowID, SessionStr
/// Ohter: d ##class(web.DHCBL.BDP.BDPMenuDefine).GetSearchHtmlLevel("1","^^^1^^^^")
ClassMethod GetSearchHtmlLevel(mySMRowID As %String, SessionStr As %String, desc As %String, mkbflag As %String = "") As %String
{
     s htmlStr2=""
     s htmlStr3=""
     s myGroupId2=..GetMenuId(mySMRowID,SessionStr,desc)
     if (myGroupId2'=""){

         s htmlStr2="<ul class=""submenu"">"_$c(13,10)
         s mySMRowID2=0
         s Len2=$Length(myGroupId2,"^")
         for j=1:1:Len2 
         {
             s mySMRowID2=$p(myGroupId2,"^",j)
             s myMenuObj2=##Class(User.BDPMenu).%OpenId(mySMRowID2,0)
             if $IsObject(myMenuObj2) {
               s myActiveFlag2 = myMenuObj2.ActiveFlag
               continue:(myActiveFlag2'="")&&('$p(myActiveFlag2,"^",1)) //查看该菜单是否被激活
			   s IsMKBMenu=myMenuObj2.IsMKBMenu
			   if mkbflag="" continue:IsMKBMenu="Y"   //如果是医学知识库的菜单则跳过
		   	   if mkbflag="Y" continue:IsMKBMenu'="Y"
               s myCode2 = myMenuObj2.Code
               s myCaption2 = myMenuObj2.Caption
               s myLinkFuntionDR2 = myMenuObj2.LinkFuntionDR
               s myLinkUrl2 = myMenuObj2.LinkUrl
               s myImage2 =myMenuObj2.Image
               s:myImage2'="" myImage2 = "../scripts/bdp/Framework/BdpIconsLib/"_myMenuObj2.Image
               s ParentMenuDr2=""
               s:myMenuObj2.ParentMenuDr'="" ParentMenuDr2=myMenuObj2.ParentMenuDr.%Id()
               if (myLinkUrl2'=""){
                s myLinkUrl2="dhc.bdp.ext.sys.csp?BDPMENU="_mySMRowID2
               }
               //判断是否有子菜单
               if ((myLinkUrl2="")) s myChildFlag2=1
               else  s myChildFlag2=0
               
               if (+myChildFlag2'=0) {
                     /*s htmlStr2=htmlStr2_"<li class=""""><a href=""javascript:void(0);"" class=""dropdown-toggle""><i class=""menu-icon fa  fa-caret-right""></i>"_myCaption2_" <b class=""arrow fa fa-angle-down""></b>  </a> <b class=""arrow""></b>"
                     s htmlStr3=..GetHtmlLevel(mySMRowID2,SessionStr)
                     s htmlStr2=htmlStr2_""_htmlStr3_"</li>"*/
                     
                      
                     s htmlStr2=htmlStr2_ "<li id='li_parent_"_mySMRowID2_"'>"_$c(13,10)
                     s htmlStr2=htmlStr2_ " <a href=""javascript:void(0);"" class=""dropdown-toggle"">"
                     if (myImage2'=""){
                        s htmlStr2=htmlStr2_ "<img src='"_myImage2_"'>"_$c(13,10)   
                    }else{
                        // s htmlStr2=htmlStr2_ "       <i class=""menu-icon fa  fa-caret-right""></i>"_$c(13,10)
                         s htmlStr2=htmlStr2_  "<img src=""../scripts/bdp/Framework/BdpIconsLib/CT_Zip.png"">"_$c(13,10)
                    }
                    s htmlStr2=htmlStr2_ "      "_myCaption2_$c(13,10)
                    s htmlStr2=htmlStr2_ "      <b class=""arrow fa fa-angle-down""></b>"_$c(13,10)  
                    s htmlStr2=htmlStr2_ "  </a>"_$c(13,10)
                    s htmlStr2=htmlStr2_ "  <b class=""arrow""></b>"_$c(13,10)
                                 //子菜单
                    s htmlStr3=..GetSearchHtmlLevel(mySMRowID2,SessionStr,desc,mkbflag)
                    s htmlStr2=htmlStr2_htmlStr3_"</li>"_$c(13,10)   //一级菜单拼接二级菜单*/
                    // d ..GetHtmlLevel(mySMRowID2,SessionStr,desc)               
                    //s htmlStr2=htmlStr2_ "</li><br>"                              
                
                }else {
                    //s htmlStr2=htmlStr2_"<li class=""""><a RowID='"_mySMRowID2_"' id='"_mySMRowID2_"'  href=""javascript:void(0);""  onclick=""showNavTab("_mySMRowID2_",'"_myCaption2_"','"_myLinkUrl2_"','"_ParentMenuDr2_"',' fa-book')""><i class=""menu-icon fa fa-caret-right""></i>"_myCaption2_"</a>    <b class=""arrow""></b></li>"
                
                    s htmlStr2=htmlStr2_ "<li class="""">"_$c(13,10)
                    s htmlStr2=htmlStr2_ "     <a RowID='"_mySMRowID2_"' id='"_mySMRowID2_"'  href=""javascript:void(0);""  onclick=""showNavTab("_mySMRowID2_",'"_myCaption2_"','"_myLinkUrl2_"','"_ParentMenuDr2_"','"_myImage2_"')"">"_$c(13,10)
                    
                    if (myImage2'=""){
                        s htmlStr2=htmlStr2_ "<img src="_myImage2_">"_$c(13,10) 
                    }
                    else{
                        s htmlStr2=htmlStr2_ "         <i class=""menu-icon fa fa-leaf green""></i>"_$c(13,10)
                    }
                    //w "<img src=""../scripts/bdp/Framework/BdpIconsLib/系统配置/BDP功能大表维护.png"">",!
                    s htmlStr2=htmlStr2_ "         "_myCaption2
                    s htmlStr2=htmlStr2_ "    </a>"_$c(13,10)
                    s htmlStr2=htmlStr2_ "    <b class=""arrow""></b>"_$c(13,10)
                    s htmlStr2=htmlStr2_ "</li>"_$c(13,10)
                
                }
                d myMenuObj2.%Close()
             } 

         }
         
         s htmlStr2=htmlStr2_"</ul>"_$c(13,10)
         //w "</ul>",!
     }
     q htmlStr2
}

/// 2015-7-30 by 谷雪萍
/// Description：获取菜单树,用于Html页面显示菜单
/// Table：User.BDPMenu
/// Input：id:父节点rowid, SessionStr
/// Ohter: d ##class(web.DHCBL.BDP.BDPMenuDefine).GetSearchHtmlMenu("^^^1^^^^")
ClassMethod GetSearchHtmlMenu(SessionStr As %String, desc As %String) As %String
{
	s id="menuTreeRoot"
	s myGroupId=""
	s myGroupId=..GetMenuId(id,SessionStr,desc)
	s htmlStr="<ul id=""navmenu"" class=""nav nav-list"">"_$c(13,10)
	//w "<ul id=""navmenu"" class=""nav nav-list"">",!

	s htmlStr2=""
	s mySMRowID=0
	s Len=$Length(myGroupId,"^")
	for i=1:1:Len      
	{
	 s mySMRowID=$p(myGroupId,"^",i)
	 s myMenuObj=##Class(User.BDPMenu).%OpenId(mySMRowID,0)
	 if $IsObject(myMenuObj) {
	   s myActiveFlag = myMenuObj.ActiveFlag
	   continue:(myActiveFlag'="")&&('$p(myActiveFlag,"^",1)) //查看该菜单是否被激活
   	   s IsMKBMenu=myMenuObj.IsMKBMenu
   	   continue:IsMKBMenu="Y"   //如果是医学知识库的菜单则跳过
	   s myCaption = myMenuObj.Caption
	   s myLinkUrl = myMenuObj.LinkUrl
	   //判断是否有子菜单
	   if ((myLinkUrl="")) s myChildFlag=1
	   else  s myChildFlag=0


	    if (+myChildFlag'=0) {
	        
	        /*s htmlStr=htmlStr_"<li class=""""> <a href=""javascript:void(0);"" class=""dropdown-toggle""> <i class=""menu-icon fa fa-desktop""></i> <span class=""menu-text"">"_myCaption_"</span>  <b class=""arrow fa fa-angle-down""></b>  </a> <b class=""arrow""></b>"
	         //子菜单
	        s htmlStr2=..GetHtmlLevel(mySMRowID,SessionStr)
	        s htmlStr=htmlStr_htmlStr2_"</li>"   //一级菜单拼接二级菜单*/
	        
	        //样式：desktop, key, cog, flask
	        s menuIcon="desktop"
	        s:myCaption["系统配置" menuIcon="key"
	        s:myCaption["产品配置" menuIcon="cog"
	        s:myCaption["临床知识库" menuIcon="book"
	        s:myCaption["医学知识库" menuIcon="flask"
	        s:myCaption["平台配置" menuIcon="edit"
	        s:myCaption["内部管理" menuIcon="user"
	        
	         s htmlStr=htmlStr_ "<li class="""">"_$c(13,10)
	         s htmlStr=htmlStr_ "    <a href=""javascript:void(0);"" class=""dropdown-toggle"">"_$c(13,10)
	         s htmlStr=htmlStr_ "        <i class=""menu-icon fa fa-"_menuIcon_"""></i>"_$c(13,10)
	         s htmlStr=htmlStr_ "        <span class=""menu-text"">"_myCaption_"</span>"_$c(13,10)
	         s htmlStr=htmlStr_ "        <b class=""arrow fa fa-angle-down""></b>"_$c(13,10)
	         s htmlStr=htmlStr_"    </a>"_$c(13,10)
	         s htmlStr=htmlStr_ "    <b class=""arrow""></b>"_$c(13,10)
	         //子菜单
	         s htmlStr2=..GetSearchHtmlLevel(mySMRowID,SessionStr,desc)
	         s htmlStr=htmlStr_htmlStr2_"</li>"_$c(13,10)   //一级菜单拼接二级菜单*/
	         //s htmlStr=htmlStr_ "</li>"_$c(13,10)
	        
	                          
	    }else {         
	        s htmlStr=""        
	    }
	    d myMenuObj.%Close()
	 }   
	 
	}
	s htmlStr=htmlStr_"</ul>"_$c(13,10)
	q htmlStr
}

/// 2015-8-18 by 谷雪萍
/// Description：横版菜单：获取第二三级的菜单树,供GetTopMenu方法调用
/// Table：User.BDPMenu
/// Input：id:父节点mySMRowID, SessionStr
/// Ohter: d ##class(web.DHCBL.BDP.BDPMenuDefine).GetTopLevel("1","^^^1^^^^")
ClassMethod GetTopLevel(mySMRowID As %String, SessionStr As %String) As %String
{
     s htmlStr2=""
     s htmlStr3=""
     s myGroupId2=..GetMenuId(mySMRowID,SessionStr,"")
     if (myGroupId2'=""){

         //s htmlStr2="<ul class=""submenu"">"
         w !,"<ul class=""submenu"">",!
         s mySMRowID2=0
         s Len2=$Length(myGroupId2,"^")
         for j=1:1:Len2 
         {
             s mySMRowID2=$p(myGroupId2,"^",j)
             s myMenuObj2=##Class(User.BDPMenu).%OpenId(mySMRowID2,0)
             if $IsObject(myMenuObj2) {
               s myActiveFlag2 = myMenuObj2.ActiveFlag
               continue:(myActiveFlag2'="")&&('$p(myActiveFlag2,"^",1)) //查看该菜单是否被激活
		   	   s IsMKBMenu=myMenuObj2.IsMKBMenu
		   	   continue:IsMKBMenu="Y"   //如果是医学知识库的菜单则跳过
		   	   
               s myCode2 = myMenuObj2.Code
               s myCaption2 = myMenuObj2.Caption
               s myLinkFuntionDR2 = myMenuObj2.LinkFuntionDR
               s myLinkUrl2 = myMenuObj2.LinkUrl
               s ParentMenuDr2=""
               s:myMenuObj2.ParentMenuDr'="" ParentMenuDr2=myMenuObj2.ParentMenuDr.%Id()
               if (myLinkUrl2'=""){
                s myLinkUrl2="dhc.bdp.ext.sys.csp?BDPMENU="_mySMRowID2
               }
               //判断是否有子菜单
               if ((myLinkUrl2="")) s myChildFlag2=1
               else  s myChildFlag2=0
               
               if (+myChildFlag2'=0) {
                     /*s htmlStr2=htmlStr2_"<li class=""""><a href=""javascript:void(0);"" class=""dropdown-toggle""><i class=""menu-icon fa  fa-caret-right""></i>"_myCaption2_" <b class=""arrow fa fa-angle-down""></b>  </a> <b class=""arrow""></b>"
                     s htmlStr3=..GetHtmlLevel(mySMRowID2,SessionStr)
                     s htmlStr2=htmlStr2_""_htmlStr3_"</li>"*/
                     
                      
                     w "<li class=""hover"" id='li_parent_"_mySMRowID2_"'>",!
                     w "    <a href=""javascript:void(0);"" class=""dropdown-toggle"">",!
                     w "        <i class=""menu-icon fa  fa-caret-right""></i>",!
                     w "        "_myCaption2,!
                     w "        <b class=""arrow fa fa-angle-down""></b>",!  
                     w "    </a>",!
                     w "    <b class=""arrow""></b>",!
                     d ..GetTopLevel(mySMRowID2,SessionStr)               
                     w "</li>" ,!                               
                
                }else {
                    //s htmlStr2=htmlStr2_"<li class=""""><a RowID='"_mySMRowID2_"' id='"_mySMRowID2_"'  href=""javascript:void(0);""  onclick=""showNavTab("_mySMRowID2_",'"_myCaption2_"','"_myLinkUrl2_"','"_ParentMenuDr2_"',' fa-book')""><i class=""menu-icon fa fa-caret-right""></i>"_myCaption2_"</a>    <b class=""arrow""></b></li>"
                
                    w "<li class=""hover"">",!
                    w "    <a RowID='"_mySMRowID2_"' id='"_mySMRowID2_"'  href=""javascript:void(0);""  onclick=""showNavTab("_mySMRowID2_",'"_myCaption2_"','"_myLinkUrl2_"','"_ParentMenuDr2_"',' fa-book')"">",!
                    w "        <i class=""menu-icon fa fa-leaf green""></i>",!
                    w "         "_myCaption2,!
                    w "    </a>",!
                    w "    <b class=""arrow""></b>",!
                    w "</li>",!
                
                }
                d myMenuObj2.%Close()
             } 

         }
         
         //s htmlStr2=htmlStr2_"</ul>"
         w "</ul>",!
     }
     //q htmlStr2
}

/// 2015-7-30 by 谷雪萍
/// Description：横版菜单：获取菜单树,用于Html页面显示菜单
/// Table：User.BDPMenu
/// Input：id:父节点rowid, SessionStr
/// Ohter: d ##class(web.DHCBL.BDP.BDPMenuDefine).GetTopMenu("^^^1^^^^")
ClassMethod GetTopMenu(SessionStr As %String) As %String
{
	s id="menuTreeRoot"
	s myGroupId=""
	s myGroupId=..GetMenuId(id,SessionStr,"")
	//s htmlStr="<ul id=""navmenu"" class=""nav nav-list"">"
	w "<ul id=""navmenu"" class=""nav nav-list"">",!

	s htmlStr2=""
	s mySMRowID=0
	s Len=$Length(myGroupId,"^")
	for i=1:1:Len      
	{
	 s mySMRowID=$p(myGroupId,"^",i)
	 s myMenuObj=##Class(User.BDPMenu).%OpenId(mySMRowID,0)
	 if $IsObject(myMenuObj) {
	   s myActiveFlag = myMenuObj.ActiveFlag
	   continue:(myActiveFlag'="")&&('$p(myActiveFlag,"^",1)) //查看该菜单是否被激活
	   s IsMKBMenu=myMenuObj.IsMKBMenu
	   continue:IsMKBMenu="Y"   //如果是医学知识库的菜单则跳过
	   s myCaption = myMenuObj.Caption
	   s myLinkUrl = myMenuObj.LinkUrl
	   //判断是否有子菜单
	   if ((myLinkUrl="")) s myChildFlag=1
	   else  s myChildFlag=0


	    if (+myChildFlag'=0) {
	        
	        /*s htmlStr=htmlStr_"<li class=""""> <a href=""javascript:void(0);"" class=""dropdown-toggle""> <i class=""menu-icon fa fa-desktop""></i> <span class=""menu-text"">"_myCaption_"</span>  <b class=""arrow fa fa-angle-down""></b>  </a> <b class=""arrow""></b>"
	         //子菜单
	        s htmlStr2=..GetHtmlLevel(mySMRowID,SessionStr)
	        s htmlStr=htmlStr_htmlStr2_"</li>"   //一级菜单拼接二级菜单*/
	        
	        //样式：desktop, key, cog, flask
	        s menuIcon="desktop"
	        s:myCaption["系统配置" menuIcon="key"
	        s:myCaption["产品配置" menuIcon="cog"
	        s:myCaption["临床知识库" menuIcon="book"
	        s:myCaption["医学知识库" menuIcon="flask"
	        s:myCaption["平台配置" menuIcon="edit"
	        s:myCaption["内部管理" menuIcon="user"
	        
	         w "<li class=""hover"">",!
	         w "    <a href=""javascript:void(0);"" class=""dropdown-toggle"">",!
	         w "        <i class=""menu-icon fa fa-"_menuIcon_"""></i>",!
	         w "        <span class=""menu-text"">"_myCaption_"</span>",!
	         w "        <b class=""arrow fa fa-angle-down""></b>",!
	         w "    </a>",!
	         w "    <b class=""arrow""></b>",!
	         d ..GetTopLevel(mySMRowID,SessionStr)
	         w "</li>",!
	        
	                          
	    }else {         
	        //s htmlStr=""  
	        w ""        
	    }
	    d myMenuObj.%Close()
	 }   
	 
	}
	w "</ul>",! 
	//s htmlStr=htmlStr_"</ul>"
	//q htmlStr
}

/// 2013-5-21 by lisen
/// Description：获取菜单树,按字段'显示顺序'大小排序,用于BDPMain.js
/// Table：User.BDPMenu
/// Input：id:父节点rowid, SessionStr
/// Ohter: w ##class(web.DHCBL.BDP.BDPMenuDefine).GetMenu("menuTreeRoot","^^^1^^^^")
ClassMethod GetMenu(id As %String, SessionStr As %String, desc As %String, mkbflag As %String = "") As %String
{
 s grpId=$p(SessionStr,"^",4)
 if (id="menuTreeRoot") s id=-100000000000000
 s mySMRowID=0
 s myMenuCount=0
 s mySMSeq=0
 k myMenuArray
 
 //生成菜单索引数组
 s mySMSeq=0
 s n=0
 for {
  s mySMSeq=$o(^User.BDPMenuI("ParSeqIdx",id,mySMSeq))
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
   s mySMRowID=$o(^User.BDPMenuI("ParSeqIdx",id," "_mySMSeq,mySMRowID))
   q:(mySMRowID="")
   s myMenuCount=myMenuCount+1
   s myMenuArray(myMenuCount)=mySMRowID
   ;w !,mySMRowID
  }
 }
 
 //获取授权JSON
 s myGroupId=""
 s strAutMenu=##class(web.DHCBL.Authorize.Menu).DHCGetDataByDefaultSession()
 //s strAutMenu=""
 //获取满足搜索条件的菜单id  改为csp里判断是否满足检索条件20210520
  //s:desc'="" strSearch=..SearchMenu(desc)
 
 //输出菜单JSON串
 s mySMRowID=0
 s myMenuSeq=0
 s myJsonStr=""
 for {
  ;q:(+myMenuSeq>1)
  s myMenuSeq=$o(myMenuArray(myMenuSeq))
  q:(myMenuSeq="")
  s mySMRowID=$g(myMenuArray(myMenuSeq))
  
  s myMenuObj=##Class(User.BDPMenu).%OpenId(mySMRowID,0)
  if $IsObject(myMenuObj) {
   s myActiveFlag = myMenuObj.ActiveFlag
   continue:(myActiveFlag'="")&&('$p(myActiveFlag,"^",1)) //查看该菜单是否被激活
   s IsMKBMenu=myMenuObj.IsMKBMenu
   if mkbflag="" continue:IsMKBMenu="Y"   //如果是医学知识库的菜单则跳过
	if mkbflag="Y" continue:IsMKBMenu'="Y" 
   s myCode = myMenuObj.Code
   s myCaption = myMenuObj.Caption
   //菜单版本
	s ShortcutKey=$LISTGET($G(^User.BDPMenuD(mySMRowID)),9)
	if ShortcutKey'=""
	{
		s MenuVersion= ##class(web.DHCBL.BDP.BDPMenuVersion).GetMenuVersion(mySMRowID)
		s myCaption =myCaption_MenuVersion
	}
   s myLinkFuntionDR = myMenuObj.LinkFuntionDR
   s myLinkUrl = myMenuObj.LinkUrl
   s myImage = myMenuObj.Image
   s:myImage'="" myImage = "../scripts/bdp/Framework/BdpIconsLib/"_myMenuObj.Image
   s myMethod = myMenuObj.Method
   s ParentMenuDr=""
   s:myMenuObj.ParentMenuDr'="" ParentMenuDr=myMenuObj.ParentMenuDr.%Id()
   s myShowInNewWindow = myMenuObj.ShowInNewWindow
   /*if (myImage'=""){
    s:(($e(myImage,1)="/")||($e(myImage,1)="\")) myImage=$e(myImage,2,$l(myImage))
    s myImage=$tr(myImage,"\","/")
    s myImage="../scripts/bdp/Framework/icons/"_myImage
   }*/
   if (myLinkUrl'=""){
    s myLinkUrl="dhc.bdp.ext.sys.csp?BDPMENU="_mySMRowID
   }
   //判断是否有子菜单
   if ((myLinkUrl="")) s myChildFlag=1
   else  s myChildFlag=0
   
   //判断菜单是否有权显示
   s strMenu="{ID:"_mySMRowID_"}"
   if ((strAutMenu[strMenu)||(1=grpId)) s myMenuEnable=1
   else  s myMenuEnable=0
   
   //满足搜索条件  改为csp里判断是否满足检索条件20210520
  /* s searchEnable=""
   
   if (desc'=""){
       if (strSearch[strMenu){
           s searchEnable=1
       }
       else{ 
           s searchEnable=0
       }
   }else{
       s searchEnable=1
   }
   
   if ((+myMenuEnable)&(+searchEnable)) {*/
   if (+myMenuEnable) {
    s:(myJsonStr'="") myJsonStr=myJsonStr_","
    s myJsonStr=myJsonStr_"{"
    s myJsonStr=myJsonStr_"""id"":"""_""_mySMRowID_""",""text"":"""_myCaption_""","
    s myJsonStr=myJsonStr_"""icon"":"""_""_myImage_""","
    if (+myChildFlag'=0) {
     s myJsonStr=myJsonStr_"""leaf"":false"
    }else {
     s myJsonStr=myJsonStr_"""myhref"":"""_""_myLinkUrl_""",""parentNode"":"""_ParentMenuDr_""","
     s myJsonStr=myJsonStr_"""leaf"":true"
    }
    s myJsonStr=myJsonStr_"}"
   }
   d myMenuObj.%Close()
  }
 }
 
 k myMenuArray
 s myJsonStr="["_myJsonStr_"]"
 
 q myJsonStr
}

/// 2015-12-2 by 谷雪萍
/// Description：获取满足搜索条件的菜单id
/// Table：User.BDPMenu
/// Input：搜索框输入的desc
/// Ohter: w ##class(web.DHCBL.BDP.BDPMenuDefine).SearchMenu("用户")
ClassMethod SearchMenu(desc As %String) As %String
{
    s str=""
    s:desc'="" desc=$ZCONVERT(desc,"U")
    //满足搜索条件的菜单拼串
    s ID=0
    for {
        s ID=$o(^User.BDPMenuD(ID))
        q:ID="" 
        s Obj=##Class(User.BDPMenu).%OpenId(ID)
        if $IsObject(Obj) {
           s myActiveFlag = Obj.ActiveFlag
           continue:(myActiveFlag'="")&&('$p(myActiveFlag,"^",1)) //查看该菜单是否被激活
           s myCaption = Obj.Caption
           //支持首拼和全拼
           //s FirstWords=##class(web.DHCBL.BDP.FunLib).GetPYCODE(myCaption)  //首拼
           //s PINYIN=##class(web.DHCBL.BDP.FunLib).GetCNCODE(myCaption,3,"")  //全拼
           s FirstWords=Obj.FirstPYCODE
		   s PINYIN=Obj.WholePYCODE
           s:myCaption'="" myCaption=$ZCONVERT(myCaption,"U")
           if (myCaption[desc)||(PINYIN[desc)||(FirstWords[desc){
                if (str=""){
                    s str=ID
                }else{
                    s str=str_"^"_ID
                }       
            }
           d Obj.%Close()
        }
        
        
    }
    //b ;str
    s strChildren=""
    s strParents=""
    s strSearch=""
    s strLen=$Length(str,"^")
    for i=1:1:strLen        
    {           
        s rowid=$p(str,"^",i)
        if (rowid'=""){
            s strSearch=strSearch_"{ID:"_rowid_"}"  
            s strChildren=..SearchChildren(rowid)  //子菜单拼串
            s strParents=..SearchParents(rowid)  //父菜单拼串
            s strSearch=strSearch_strChildren_strParents
        }
    }
    //b ;strSearch
    q strSearch
}

/// Description：获取满足搜索条件的子节点
/// Ohter: w ##class(web.DHCBL.BDP.BDPMenuDefine).SearchChildren("338")  计费维护-分类维护
ClassMethod SearchChildren(rowid As %String) As %String
{
    s str=""
    s child=0
    for{
        s child=$o(^User.BDPMenuI("ParMenuIdx",rowid,child))
        q:child=""
        s ActiveFlag=$LISTGET($G(^User.BDPMenuD(child)),16)
        s:ActiveFlag'="" ActiveFlag=$p(ActiveFlag,"^",1)
        if (ActiveFlag){
            if (str=""){
                s str= "{ID:"_child_"}"
            }else{
                s str=str_","_"{ID:"_child_"}"
            }
            s str1= ..SearchChildren(child)   //递归
            s:str1'="" str=str_","_str1
        }
    }
    q str
}

/// Description：获取满足搜索条件的父节点
/// Ohter: w ##class(web.DHCBL.BDP.BDPMenuDefine).SearchParents("338") 计费维护-分类维护
ClassMethod SearchParents(rowid As %String) As %String
{
    s str=""
    s ParentMenuDr=$LISTGET($G(^User.BDPMenuD(rowid)),11)
    if (ParentMenuDr'=""){
        s ActiveFlag=$LISTGET($G(^User.BDPMenuD(ParentMenuDr)),16)
        s:ActiveFlag'="" ActiveFlag=$p(ActiveFlag,"^",1)
        if (ActiveFlag){
            if (str=""){  //第一个
                s str="{ID:"_ParentMenuDr_"}"
            }else{
                s str=str_","_"{ID:"_ParentMenuDr_"}"
            }
        
        s str1= ..SearchParents(ParentMenuDr)  //递归
        s:str1'="" str=str_","_str1
        }
    }
    q str
}

/// 2015-10-13 by 谷雪萍
/// Description：获取菜单树,按字段'显示顺序'大小排序,用于BDP_MenuNew.js
/// Table：User.BDPMenu
/// Input：id:父节点rowid
/// Ohter: w ##class(web.DHCBL.BDP.BDPMenuDefine).GetMenuNew("TreeRoot")
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
 for 
 {
	s mySMSeq=$o(^User.BDPMenuI("ParSeqIdx",LastLevel,mySMSeq))
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
   s mySMRowID=$o(^User.BDPMenuI("ParSeqIdx",LastLevel," "_mySMSeq,mySMRowID))
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
  
  s myMenuObj=##Class(User.BDPMenu).%OpenId(mySMRowID,0)
  if $IsObject(myMenuObj) {
   
	s myCode = myMenuObj.Code
	s myCaption = myMenuObj.Caption
	s myLinkFuntionDR = myMenuObj.LinkFuntionDR
	s myLinkUrl = myMenuObj.LinkUrl
	s myImage= myMenuObj.Image
	s:myImage'="" myImage = "../scripts/bdp/Framework/BdpIconsLib/"_myMenuObj.Image
	s myMethod = myMenuObj.Method
	s ParentMenuDr = myMenuObj.ParentMenuDr
	s myShowInNewWindow = myMenuObj.ShowInNewWindow
	/*if (myImage'=""){
	s:(($e(myImage,1)="/")||($e(myImage,1)="\")) myImage=$e(myImage,2,$l(myImage))
	s myImage=$tr(myImage,"\","/")
	s myImage="../scripts/bdp/Framework/icons/"_myImage
	}*/
	if (myLinkUrl'=""){
	s myLinkUrl="dhc.bdp.ext.sys.csp?BDPMENU="_mySMRowID
	}
	//判断是否有子菜单
	if ((myLinkUrl="")) s myChildFlag=1
	else  s myChildFlag=0

	s nodeId="<"_mySMRowID_">"
	s:(myJsonStr'="") myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_mySMRowID_""",""text"":"""_myCaption_""","
	s myJsonStr=myJsonStr_"""icon"":"""_""_myImage_""","
	if (+myChildFlag'=0) {
	s myJsonStr=myJsonStr_"""leaf"":false"
	if (nodeStr=""){
		 s myJsonStr=myJsonStr_",""expanded"":true"
	}else{
		if (nodeStr[nodeId){
    		s myJsonStr=myJsonStr_",""expanded"":true"
   		}
    	else{
    		s myJsonStr=myJsonStr_",""expanded"":false"
    	}
	}
	 
	}else {
	 s myJsonStr=myJsonStr_"""myhref"":"""_""_myLinkUrl_""",""parentNode"":"""_ParentMenuDr_""","
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

/// 2013-5-21 by lisen
/// d ##class(web.DHCBL.BDP.BDPMenuDefine).BuildAryByID(18,"")
ClassMethod BuildAryByID(ID As %String, SessionStr As %String) As %String
{
 if (ID'="") {
  s code=""
  s mobj = ##class(User.BDPMenu).%OpenId(ID)
  s code = mobj.LinkFuntionDR.Code
  
  d ##class(web.DHCBL.BDP.BDPExecutables).BuildAryByCode(code)
  d mobj.%Close()
 }
 q
}

/// Creator:2013-5-21 by lisen
/// Function: 返回Ext功能大表里 js的存放路径; 如： App/Patient/PAC_ReasonForChangePatData
/// Debugs: w ##class(web.DHCBL.BDP.BDPMenuDefine).GetExtfileByID(18)
ClassMethod GetExtfileByID(ID As %String) As %String
{
 s JavaScriptFile=""
 if (ID'="") {
  s mobj = ##class(User.BDPMenu).%OpenId(ID)
  s JavaScriptFile = mobj.LinkFuntionDR.JavaScriptFile
  d mobj.%Close()
 }
 q JavaScriptFile
}

Parameter pExtJSName = "ExtJSName";

Parameter pExtAppPath = "../scriptsext/";

/// tkMakeServerCall方法
/// 2015-12-10  谷雪萍 --2021-04-29重新改成调用基础平台方法
/// Debugs: d ##class(web.DHCBL.BDP.BDPMenuDefine).Head()
ClassMethod Head(page As %String = {%request.PageName})
{
    d ##Class(websys.Configuration).Head()
}

/// Creator:2015-12-25 by gss
/// Function: 根据code返回id
/// Debugs: w ##class(web.DHCBL.BDP.BDPMenuDefine).GetID("dhc.bdp.Locations.CTLoc")
ClassMethod GetID(code As %String) As %String
{
    s ID=""
    if (code'="") {
        s code=" "_$ZCONVERT(code,"U") //转换成大写
        s ID=$o(^User.BDPMenuI("UniqueCodeIndex",code,0))
    }
    q ID
}

/// Function:根据id获取Icon
/// Creator: sunfengchao
/// CreateDate:2016-9-21
/// Debug: w ##class(web.DHCBL.BDP.BDPMenuDefine).GetIconByID("3")
ClassMethod GetIconByID(id As %String) As %String
{
	q:id="" ""
    s Image=""
    s Image=$LISTGET($G(^User.BDPMenuD(id)),6)
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
/// w ##class(web.DHCBL.BDP.BDPMenuDefine).GetSequence("1")
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
  s mySMSeq=$o(^User.BDPMenuI("ParSeqIdx",id,mySMSeq))
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
    
    s obj=##class(User.BDPMenu).%OpenId(id) 
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
             s obj=##class(User.BDPMenu).%OpenId(rowid)
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

/// 2017-10-10 by 谷雪萍
/// Description：新增了两个字段-首拼和全拼，并且把数据保存进去。
/// Table：User.BDPMenu
/// Input：""
/// Return：true/false
/// Ohter: w ##class(web.DHCBL.BDP.BDPMenuDefine).SaveAllPYCode()
ClassMethod SaveAllPYCode() As %String
{
	k ^User.BDPMenuI
	d ##class(User.BDPMenu).%BuildIndices()
	s result=""
    TS
    s ID=0
    for 
    {
        s ID=$o(^User.BDPMenuD(ID))
        q:ID="" 
        s obj=##Class(User.BDPMenu).%OpenId(ID)
        if $IsObject(obj) {
           s myCaption = obj.Caption
           if (myCaption'="")
           {
	           s myCaption=$ZCONVERT(myCaption,"U")
	           s FirstWords=##class(web.DHCBL.BDP.FunLib).GetPYCODE(myCaption)  //首拼
	           s PINYIN=##class(web.DHCBL.BDP.FunLib).GetCNCODE(myCaption,3,"")  //全拼
	           s obj.FirstPYCODE=FirstWords
			   s obj.WholePYCODE=PINYIN
			   s sc=obj.%Save()
			   If '$$$ISOK(sc)
			   {
			   	  s result=1
			   }
           }
           
           d obj.%Close()
        }      
        
    }
    //b ;
    if (result="")
    {
	    TC
	    s result = "{success:'true',info:'首拼和全拼保存成功！'}"
    }
    else
    {
	    Tro
	    s result = "{success:'false',info:'首拼和全拼保存失败！'}"    
    }

    q result
}

/// Creator：陈莹
/// CreatDate: 2018-03-28
/// Description：保存菜单批量激活隐藏状态，每点击一次
/// Table：User.BDPMenu
/// Input：父节点 
/// Return：treegrid格式数据串
/// w ##class(web.DHCBL.BDP.BDPMenuDefine).SaveActiveTree("")
ClassMethod SaveActiveTree(id As %String, checked) As %String
{
	q:id="" "{success:'false',info:'保存失败'}"
	s result=""	
	s obj=##class(User.BDPMenu).%OpenId(id)
	
	s bobj=##class(web.Entity.BDP.BDPMenuDefine).%New()
	s bobj.ID=id
	s bobj.Code = obj.Code           
	s bobj.Caption = obj.Caption          
	s:obj.LinkFuntionDR'="" bobj.LinkFuntionDR=obj.LinkFuntionDR.%Id()
	s bobj.LinkUrl =  obj.LinkUrl
	s bobj.Image = obj.Image
	s bobj.Method = obj.Method
	s bobj.Sequence = obj.Sequence
	s bobj.ShortcutKey = obj.ShortcutKey
	s bobj.ShowInNewWindow = obj.ShowInNewWindow
	s:obj.ParentMenuDr'="" bobj.ParentMenuDr=obj.ParentMenuDr.%Id()
	s:obj.ProductLineDr'="" bobj.ProductLineDr=obj.ProductLineDr.%Id()
	s bobj.ValueExpression = obj.ValueExpression
	s bobj.CompName=obj.CompName
	s bobj.IsMKBMenu=obj.IsMKBMenu
	
	
	if (obj.ActiveFlag'="")
	{
		s bobj.ActiveFlag=obj.ActiveFlag
		s bobj.actMenuBDP = $p(obj.ActiveFlag,"^",1)
		s bobj.actMenuAutItem=$p(obj.ActiveFlag,"^",2)
		s bobj.actMenuAutData=$p(obj.ActiveFlag,"^",3)
	}
	
	s eobj=##class(web.Entity.BDP.BDPMenuDefine).%New()
	s eobj.ID=id
	s eobj.Code = obj.Code           
	s eobj.Caption = obj.Caption          
	s:obj.LinkFuntionDR'="" eobj.LinkFuntionDR=obj.LinkFuntionDR.%Id()
	s eobj.LinkUrl =  obj.LinkUrl
	s eobj.Image = obj.Image
	s eobj.Method = obj.Method
	s eobj.Sequence = obj.Sequence
	s eobj.ShortcutKey = obj.ShortcutKey
	s eobj.ShowInNewWindow = obj.ShowInNewWindow
	s:obj.ParentMenuDr'="" eobj.ParentMenuDr=obj.ParentMenuDr.%Id()
	s:obj.ProductLineDr'="" eobj.ProductLineDr=obj.ProductLineDr.%Id()
	s eobj.ValueExpression = obj.ValueExpression
	s eobj.CompName=obj.CompName
	s eobj.IsMKBMenu=obj.IsMKBMenu
	
	
	s ActiveFlag=obj.ActiveFlag
	if (checked="true") s $p(ActiveFlag,"^",1)="1"
	if (checked="false") s $p(ActiveFlag,"^",1)="0"
	if (checked="1") s $p(ActiveFlag,"^",1)="1"
	if (checked="0") s $p(ActiveFlag,"^",1)="0"
	
	s eobj.actMenuBDP = $p(ActiveFlag,"^",1)
	s eobj.actMenuAutItem=$p(ActiveFlag,"^",2)
	s eobj.actMenuAutData=$p(ActiveFlag,"^",3)
	s eobj.ActiveFlag =ActiveFlag
	s obj.ActiveFlag =ActiveFlag
			
	TS      
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){
		Tc
		s result = "{""success"":""true""}"  //返回RowId
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_Menu","User.BDPMenu","菜单定义",eobj.ID,eobj.Caption,"U",eobj,bobj)
	} else {
		Trollback
		s result = "{""success"":""false"",""errorinfo"":"""_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"""}"  //返回错误信息
	}
	q result
}

}
