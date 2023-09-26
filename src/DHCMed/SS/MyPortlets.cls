/// 名称: DHCMed.SS.MyPortlets
/// 描述: 个性化页签配置
/// 编写者：wuqk
/// 编写日期: 2012-11-02
Class DHCMed.SS.MyPortlets Extends (%Persistent, DHCMed.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 用户ID 
Property SSUserDr As %Integer [ Required ];

/// 自定义页签指针
Property PortletsDr As %Integer [ Required ];

/// 是否显示
Property IsShow As %Boolean;

/// 显示列
Property Column As %Integer;

/// 显示行
Property Row As %Integer;

Index IndexPor On (SSUserDr, PortletsDr) [ Unique ];

///  Creator：     maxp
///  CreatDate：   2012-11-14
///  Description:  更新个性化页签配置
///  Table：       DHCMed.SS.MyPortlets
///  Input：       各属性列表 ^分隔
///  Return：      成功：返回id，失败：返回<0的代码
///  1:Rowid 2:SSUserDr 3.PortletsDr 4.IsShow 5.Column 6.Row 
/// MyPortletInfo="^12^19^0^^"
///  w ##Class(DHCMed.SS.MyPortlets).Update(MyPortletInfo)
ClassMethod Update(MyPortletInfo As %String)
{
	new (MyPortletInfo)
	s id=""
	s ID=$p(MyPortletInfo,"^",1)
	if (ID="")
	{
		s obj=##class(DHCMed.SS.MyPortlets).%New()
	}
	else{
		s obj=##class(DHCMed.SS.MyPortlets).%OpenId(ID)
	}
	s obj.SSUserDr=$p(MyPortletInfo,"^",2)
	s obj.PortletsDr=$p(MyPortletInfo,"^",3)
	s obj.IsShow=$p(MyPortletInfo,"^",4)
	;s obj.IsShow=$s($p(MyPortletInfo,"^",4)=false:0,true:1)
	s obj.Column=$p(MyPortletInfo,"^",5)
	s obj.Row=$p(MyPortletInfo,"^",6)
	
	s sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		s id=-1
	}
	else{
		s id=obj.%Id()
		}
	do obj.%Close()
	quit id
}

///  Creator：     maxp
///  CreatDate：   2012-11-28
///  Description:  更新个性化页签配置(数据已存在，但缺少RowID)
///  Table：       DHCMed.SS.MyPortlets
///  Input：       各属性列表 ^分隔
///  Return：      成功：返回id，失败：返回<0的代码
///   1:SSUserDr 2.PortletsDr 3.IsShow 4.Column 5.Row 
/// MyPortletInfo="12^19^0^^"
///  w ##Class(DHCMed.SS.MyPortlets).UpdateByIndex(MyPortletInfo)
ClassMethod UpdateByIndex(MyPortletInfo As %String)
{
	new (MyPortletInfo)
	s id=""
	s ID=""
	s groupId=$p(MyPortletInfo,"^",1)
	s portletId=$p(MyPortletInfo,"^",2)
	if $d(^DHCMed.SS.MyPortletsI("IndexPor",groupId,portletId)){
		s ID=$o(^DHCMed.SS.MyPortletsI("IndexPor",groupId,portletId,ID))
	}
	s MyPortletInfo=ID_"^"_MyPortletInfo
	s id=##class(DHCMed.SS.MyPortlets).Update(MyPortletInfo)
	quit id
}

/// Creator：     maxp
/// CreatDate：   2012-09-17
/// Description:  删除MyPortlets
/// Table：       DHCMed.SS.MyPortlets
/// Input：       MyPortletId
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String)
{
	new (Id)
	set sc = ##class(DHCMed.SS.MyPortlets).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

/// Creator：     mxp
/// CreatDate：   2012-11-16
/// Description:  根据安全组Id获取有权限的页签显示信息树
/// Table：       DHCMed.SS.SecurityPortlets，DHCMed.SS.MyPortlets
/// Input：       groupId：  安全组Id
/// Return：      返回json格式的菜单信息，
/// w ##class(DHCMed.SS.MyPortlets).BuildShowPorJson(12)
ClassMethod BuildShowPorJson(groupId As %String) As %String
{
	new (groupId)
	s json=""
	
	quit:'$d(^DHCMed.SS.SecurityPortletsI("IndexOfPor",groupId)) json
	s portletId=$o(^DHCMed.SS.SecurityPortletsI("IndexOfPor",groupId,0))
	;s portletId=$o(^DHCMed.SS.SecurityPortletsI(""))
	while portletId'="" {
		s Flag=##class(DHCMed.SS.SecurityPortlets).CheckAuthority(groupId,portletId)
		if +Flag>0 {
			s obj=##class(DHCMed.SS.Portlets).%OpenId(portletId)
			if $IsObject(obj){
				do obj.%Close()
				s:json'="" json=json_","
				s objPor=##class(DHCMed.SS.Portlets).%OpenId(+portletId)
				s porJson="{"_"""id"":"_portletId_",""text"":"""_objPor.Description_""","
				s porJson=porJson_"""expanded"":true,"
				s porJson=porJson_"""leaf"":true,"
				s secFlag=0
				if $d(^DHCMed.SS.MyPortletsI("IndexPor",groupId,portletId)){
					s myPorId=$o(^DHCMed.SS.MyPortletsI("IndexPor",groupId,portletId,""))
					s myPoroObj=##class(DHCMed.SS.MyPortlets).%OpenId(myPorId)
					s secFlag=myPoroObj.IsShow
					do myPoroObj.%Close()
					if +secFlag>0 {
						s porJson=porJson_"""checked"":true"
					}
					else{
						s porJson=porJson_"""checked"":false"
					}
				}else{
					s porJson=porJson_"""checked"":false"
				}
				;s secFlag=##class(DHCMed.SS.SecurityPortlets).CheckAuthority(groupId,portletId)
				s json=json_porJson_"}"
			}
		}			
		s portletId=$o(^DHCMed.SS.SecurityPortletsI("IndexOfPor",groupId,portletId))
	}
	quit "["_json_"]"
}

/// Creator：     mxp
/// CreatDate：   2012-11-15
/// Description:  根据用户Id获取有权限的页签信息列表
/// Table：       DHCMed.SS.Portlets,DHCMed.SS.SecurityPortlets
/// Input：       userId：用户Id
/// Return：      返回页签信息，按照<$C1>分隔行，^分隔字段
/// w ##class(DHCMed.SS.MyPortlets).GeMyportletsByGroup(12)
ClassMethod GeMyportletsByGroup(aGroupID As %String) As %String
{
	new (aGroupID)
	set return=""
	quit:aGroupID="" return
	
	kill ^CacheTemp($zn,$j)
	set xPortletID=0
	for {
		set xPortletID=$o(^DHCMed.SS.SecurityPortletsI("IndexOfPor",aGroupID,xPortletID))
		quit:xPortletID=""
		set flag=##class(DHCMed.SS.SecurityPortlets).CheckAuthority(aGroupID,xPortletID)
		continue:flag<1
		set obj=##class(DHCMed.SS.Portlets).GetObjById(xPortletID)
		continue:'$Isobject(obj)
		set description=obj.Description
		set isShow=1
		if $d(^DHCMed.SS.MyPortletsI("IndexPor",aGroupID,xPortletID)){
			set myPorId=$o(^DHCMed.SS.MyPortletsI("IndexPor",aGroupID,xPortletID,""))
			set myPoroObj=##class(DHCMed.SS.MyPortlets).%OpenId(myPorId)
			if myPoroObj'="" do myPoroObj.%Close()
			set isShow=myPoroObj.IsShow
		}
		
		set ^CacheTemp($zn,$j,xPortletID)=xPortletID_"^"_description_"^"_isShow
		set return=return_$g(^CacheTemp($zn,$j,xPortletID))_"<$C1>"
	}
	kill ^CacheTemp($zn,$j)
	
	quit return
}

/// Creator：     mxp
/// CreatDate：   2012-11-26
/// Description:  根据用户Id获取有权限的页签显示信息
/// Table：       DHCMed.SS.Portlets,DHCMed.SS.SecurityPortlets,DHCMed.SS.MyPortlets
/// Input：       userId：用户Id
/// Return：      
/// w ##class(DHCMed.SS.MyPortlets).MaGetPortlets(12)
ClassMethod MaGetPortlets(userId)
{
	k tmp
	s list=""
	s columns=3
	
	if $d(^DHCMed.SS.MyPortletsI("IndexPor",userId))=""  d
	.d firstLogin
	.;d GetMyPortlets
	else  d
	.d CreateMyPorList
	
	quit "["_list_"]"
	
CreateMyPorList
	s index=1
	s count=0
	s PorIdList=""
	kill tmp
	s portletId=$o(^DHCMed.SS.SecurityPortletsI("IndexOfPor",userId,""))
	while (portletId'=""){
		s flag=##class(DHCMed.SS.SecurityPortlets).CheckAuthority(userId,portletId)
		if flag>0 {
			if $d(^DHCMed.SS.MyPortletsI("IndexPor",userId,portletId)){
				s myPorId=$o(^DHCMed.SS.MyPortletsI("IndexPor",userId,portletId,""))
				s myPorObj=##class(DHCMed.SS.MyPortlets).%OpenId(myPorId)
				if $IsObject(myPorObj){
					d myPorObj.%Close()
					s secFlag=myPorObj.IsShow
					if secFlag>0 {
						s column=myPorObj.Column
						s row=myPorObj.Row
						s obj=##class(DHCMed.SS.Portlets).%OpenId(portletId)
						if $IsObject(obj) {
							s tmp(column,row)=portletId_"^"_obj.Description_"^"_obj.Height
						    d obj.%Close()
						}
						s index=index+1
					}
				}else{
					s count=count+1
					s $li(PorIdList,count)=portletId
				}
			}else{
				s count=count+1
				s $li(PorIdList,count)=portletId
			}
		}
		s portletId=$o(^DHCMed.SS.SecurityPortletsI("IndexOfPor",userId,portletId))
	}
	
	if PorIdList'=""{
		for i=1:1:count {
			s porId=$li(PorIdList,i)
			s obj=##class(DHCMed.SS.Portlets).%OpenId(porId)
			if $IsObject(obj) {
				do obj.%Close()
				set row=0
				for {
					set col=0
					for {
						quit:'$d(tmp(row,col))
						quit:(col+1)>=columns
						set col=col+1
					}
					quit:'$d(tmp(row,col))
					set row=row+1
				}
				set tmp(row,col)=porId_"^"_obj.Description_"^"_obj.Height
			}
		}
	}
	
	d GetMyPortlets
	quit
		
firstLogin
	s id=""
	s index=1
	for {
		s id = $o(^DHCMed.SS.SecurityPortletsI("IndexOfPor",userId,id))
		quit:id=""
		set flag=##class(DHCMed.SS.SecurityPortlets).CheckAuthority(userId,id)
		if flag>0 {
			s obj=##class(DHCMed.SS.Portlets).%OpenId(+id)
			if $IsObject(obj) {
				s mod=index#columns
				if mod=0 {
					s tmp(columns-1,$i(tmp(columns-1)))=id_"^"_obj.Description_"^"_obj.Height
				}else{
					s tmp(mod-1,$i(tmp(mod-1)))=id_"^"_obj.Description_"^"_obj.Height
				}
			}
			do obj.%Close()
		}
		s index=index+1
	}
	d GetMyPortlets
	quit
	
GetMyPortlets
	for i=0:1:2 {
		s mod=i
		if '$d(tmp(mod)) {
			s list=list_"[],"
		}else{
			s ind=""
			s colString="["
			for {
				s ind=$o(tmp(mod,ind))
				quit:ind=""
				s id=+$g(tmp(mod,ind))
				s title=$p($g(tmp(mod,ind)),"^",2)
				s height=+$p($g(tmp(mod,ind)),"^",3)
				//s colString=colString_"{id:'portlet_"_id_"',title:'"_title_"',height:"_height_"}," //
				s colString=colString_"{id:'portlet_"_id_"',title:'"_title_"',height:"_height
				s colString=colString_",html:'<iframe id=""frm_Content_portlet_"_id_""" "
				//'dhcmed.portletdefalut.csp?id=' + this.id; dhcmed.portletdefalut.csp?id="_id_"
				s colString=colString_" src= """" width=""100%"" height=""100%"" frameborder=""0"" scrolling=""auto""></iframe>'}," 
				//,myPorId:'"_myPorId_"'
			}
			s colString=$e(colString,1,$l(colString)-1)
			s list=list_colString_"],"
		}
	}
	s list=$e(list,1,$l(list)-1)
	quit
}

/// Creator：     mxp
/// CreatDate：   2012-11-16
/// Description:  根据页签Id获取显示类型为Grid的页签的表格行列信息json串
/// Table：       DHCMed.SS.Portlets
/// Input：       portletId：  页签Id
/// Return：      返回json格式的表格行列信息
/// w ##class(DHCMed.SS.MyPortlets).BuildGridPorJson(21)
ClassMethod BuildGridPorJson(portletId As %String) As %String
{
	new (portletId)
	s json="'columModle':["
    s obj=##class(DHCMed.SS.Portlets).%OpenId(+portletId)
    s gridInfo=obj.DtlShowConfig
 	s len=$ll(gridInfo)
 	s columModle=""
 	s fieldsNames=""
 	f i=2:1:len {
	 	s:columModle'="" columModle=columModle_","
	 	s:fieldsNames'="" fieldsNames=fieldsNames_","
	 	s colInfo=$li(gridInfo,i)
	 	s colName=$li(colInfo,1)
	 	s dataIndex=$li(colInfo,2)
	 	s colHeader=$li(colInfo,3)
	 	s isHidden=$li(colInfo,4)
	 	if 'isHidden{
		 	s columModle=columModle_"{"_"'header':'"_colHeader_"','dataIndex':'"_dataIndex_"'}"
		 	s fieldsNames=fieldsNames_"{"_"'name':'"_colName_"'}"
	 	}
 	}
 	s json=json_columModle_"],'fieldsNames':["_fieldsNames_"]"
	quit "{"_json_"}"
}

/// Creator：     mxp
/// CreatDate：   2012-11-16
/// Description:  根据页签Id获取显示类型为Grid的页签的表格显示列
/// Table：       DHCMed.SS.Portlets
/// Input：       portletId：  页签Id
/// Return：      返回表格显示列信息，以^分隔
/// w ##class(DHCMed.SS.MyPortlets).getGridColumn(21)
ClassMethod getGridColumn(portletId As %String) As %String
{
	new (portletId)
	s columnName=""
    s obj=##class(DHCMed.SS.Portlets).%OpenId(+portletId)
    s gridInfo=obj.DtlShowConfig
 	s len=$ll(gridInfo)
 	f i=2:1:len {
	 	s:columnName'="" columnName=columnName_"^"
	 	s colInfo=$li(gridInfo,i)
	 	s colName=$li(colInfo,1)
	 	s dataIndex=$li(colInfo,2)
	 	s colHeader=$li(colInfo,3)
	 	s isHidden=$li(colInfo,4)
	 	if 'isHidden{
		 	s columnName=columnName_dataIndex
	 	}
 	}
	quit columnName
}

/// w ##class(DHCMed.SS.MyPortlets).GetUrlInfo("portlet_2")
ClassMethod GetUrlInfo(portletInfo As %String) As %String
{
	Set return=""
	
	Quit:portletInfo="" return
	Set portletId=$p(portletInfo,"_",2)
	Quit:portletId="" return
	
	Set obj=##class(DHCMed.SS.Portlets).%OpenId(+portletId)
	Quit:'$IsObject(obj) return
	Set MsgMenuDr=obj.MsgMenuDr
	Quit:MsgMenuDr="" return
	
	Set MenuObj=##class(DHCMed.SS.Menus).GetObjById(MsgMenuDr)
	Quit:'$IsObject(MenuObj) return
	
	Set MenuCaption=MenuObj.MenuCaption
	
	Quit MsgMenuDr_"^"_MenuCaption
}

Storage Default
{
<Data name="MyPortletsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Column</Value>
</Value>
<Value name="3">
<Value>IsShow</Value>
</Value>
<Value name="4">
<Value>PortletsDr</Value>
</Value>
<Value name="5">
<Value>Row</Value>
</Value>
<Value name="6">
<Value>SSUserDr</Value>
</Value>
</Data>
<DataLocation>^DHCMed.SS.MyPortletsD</DataLocation>
<DefaultData>MyPortletsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.SS.MyPortletsD</IdLocation>
<IndexLocation>^DHCMed.SS.MyPortletsI</IndexLocation>
<StreamLocation>^DHCMed.SS.MyPortletsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
