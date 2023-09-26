/// 名称: DHCMed.SS.Portlets
/// 描述: 医政管理自定义也签
/// 编写者：wuqk
/// 编写日期: 2012-08-28
Class DHCMed.SS.Portlets Extends (%Persistent, DHCMed.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property Code As %String(TRUNCATE = 1) [ Required ];

/// 标题
Property Description As %String(TRUNCATE = 1) [ Required ];

/// 高度
Property Height As %Integer;

/// 是否自动刷新       默认为0
Property AutoRefreash As %Integer;

/// 刷新频率 单位：Mins      5/15/30/60
Property Frequency As %Integer;

/// 备注
Property Resume As %String(TRUNCATE = 1);

/// 是否有效   
Property IsActive As %Integer;

// 数据集相关属性

/// 显示信息
Property Message As %String(MAXLEN = 200, TRUNCATE = 1);

/// 类方法
Property MsgClassMethod As %String(MAXLEN = 100, TRUNCATE = 1);

/// 连接菜单   指向 DHCMed.SS.Menus
Property MsgMenuDr As %Integer;

/// 链接地址
Property MsgURL As %String(TRUNCATE = 1);

/// 数据集Query
Property QueryName As %String(MAXLEN = 100);

/// 连接菜单   指向 DHCMed.SS.Menus
Property DtlMenuDr As %Integer;

/// 链接地址   
Property DtlURL As %String(MAXLEN = 50);

/// 明细显示类型
Property DtlShowType As %String(TRUNCATE = 1);

/// 明细显示配置
Property DtlShowConfig As %String(MAXLEN = 1000, TRUNCATE = 1);

Index IndexCode On Code [ Unique ];

/// d ##class(DHCMed.SS.Portlets).LoadPortlets()
ClassMethod LoadPortlets()
{
	s ^DHCMed.Ps(1)="Portlet1"
	s ^DHCMed.Ps(2)="Portlet2"
	s ^DHCMed.Ps(3)="Portlet3"
	s ^DHCMed.Ps(4)="Portlet4"
	s ^DHCMed.Ps(5)="Portlet5"
	s ^DHCMed.Ps(6)="Portlet6"
	s ^DHCMed.Ps(7)="Portlet7"
}

/// w ##class(DHCMed.SS.Portlets).GetPortlets()
ClassMethod GetPortlets()
{
	set columns=3
	set id=""
	set index=1
	for {
		set id = $o(^DHCMed.Ps(id))
		quit:id=""
		set mod=index#columns
		if mod=0 {
			set tmp(columns-1,$i(tmp(columns-1)))=id_"^"_$g(^DHCMed.Ps(id))
		}
		else{
			set tmp(mod-1,$i(tmp(mod-1)))=id_"^"_$g(^DHCMed.Ps(id))
		}
		set index=index+1
	}
	set mod=""
	set list=""
	for {
		set mod=$o(tmp(mod))
		quit:mod=""
		set ind=""
		set colString="["
		for {
			set ind=$o(tmp(mod,ind))
			quit:ind=""
			set id=+$g(tmp(mod,ind))
			set title=$p($g(tmp(mod,ind)),"^",2)
			set colString=colString_"{id:'portlet_"_id_"',title:'"_title_"',height:240}," //,html:'"_title_"'
		}
		set colString=$e(colString,1,$l(colString)-1)
		set list=list_colString_"],"
	}
	set list=$e(list,1,$l(list)-1)
	quit "["_list_"]"
}

/// w ##class(DHCMed.SS.Portlets).MAGetPortlets(12)
ClassMethod MAGetPortlets(userId)
{
	kill tmp
	set columns=3
	set id=""
	set index=1
	for {
		set id = $o(^DHCMed.SS.SecurityPortletsI("IndexOfPor",userId,id))
		quit:id=""
		set flag=##class(DHCMed.SS.SecurityPortlets).CheckAuthority(userId,id)
		if flag>0 {
			set obj=##class(DHCMed.SS.Portlets).%OpenId(+id)
			set mod=index#columns
			if mod=0 {
				set tmp(columns-1,$i(tmp(columns-1)))=id_"#"_obj.Description
			}
			else{
				set tmp(mod-1,$i(tmp(mod-1)))=id_"#"_obj.Description
			}
			do obj.%Close()
		}
		set index=index+1
	}
	set mod=""
	set list=""
	for {
		set mod=$o(tmp(mod))
		quit:mod=""
		set ind=""
		set colString="["
		for {
			set ind=$o(tmp(mod,ind))
			quit:ind=""
			set id=+$g(tmp(mod,ind))
			set title=$p($g(tmp(mod,ind)),"#",2)
			set colString=colString_"{id:'portlet_"_id_"',title:'"_title_"',height:240}," //,html:'"_title_"'
		}
		set colString=$e(colString,1,$l(colString)-1)
		set list=list_colString_"],"
	}
	set list=$e(list,1,$l(list)-1)
	quit "["_list_"]"
}

/// Creator：     maxp
/// CreatDate：   2012-9-17
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.SS.Portlets
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:Code 3.Description 4.Height 5.AutoRefreash 6.Frequency 7.Resume 8.IsActive 
/// 9.Message 10.MsgClassMethod 11.MsgMenuDr 12.MsgURL 13.QueryName 14.DtlMenuDr 15.DtlURL 16.DtlShowType 17.DtlShowConfig
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..Code_separete
	set return=return_..Description_separete
	set return=return_..Height_separete
	set return=return_..AutoRefreash_separete
	set return=return_..Frequency_separete
	set return=return_..Resume_separete
	set return=return_..IsActive_separete
	set return=return_..Message_separete
	set return=return_..MsgClassMethod_separete
	set return=return_..MsgMenuDr_separete
	set return=return_..MsgURL_separete
	set return=return_..QueryName_separete
	set return=return_..DtlMenuDr_separete
	set return=return_..DtlURL_separete
	set return=return_..DtlShowType_separete
	set return=return_..DtlShowConfig
	 
	quit return
}

/// Creator：     maxp
/// CreatDate：   2012-9-17
/// Description:  根据ID取页签信息
/// Table：       DHCMed.SS.Portlets
/// Input：       ID:    DHCMed.SS.Portlets.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.SS.Portlets).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.SS.Portlets
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.SS.Portlets).%ExistsId(+id) return
	set obj=##Class(DHCMed.SS.Portlets).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     maxp
/// CreatDate：   2012-9-17
/// Description:  根据ID取页签信息
/// Table：       DHCMed.SS.Portlets
/// Input：       ID:    DHCMed.SS.Menus.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.SS.Portlets).GetStringById(1)
ClassMethod GetStringById(id As %String, separete As %String) As %String
{
	new (id,separete)
	set return=""
	set obj=..GetObjById(id)
	if $IsObject(obj){
		set return=obj.ToString($g(separete))
	}	
	quit return
}

/// Creator：     maxp
/// CreatDate：   2012-9-17
/// Description:  更新Portlets
/// Table：       DHCMed.SS.Portlets
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:Code 3.Description 4.Height 5.AutoRefreash 6.Frequency 7.Resume 8.IsActive 
/// 9.Message 10.MsgClassMethod 11.MsgMenuDr 12.MsgURL 13.QueryName 14.DtlMenuDr 15.DtlURL 16.DtlShowType 17.DtlShowConfig
/// 
/// modify by maxp 2012-10-12 添加showConfig的list存储
/// PortletInfo="^klmjhn^dddd^100^1^15分钟^gg^1^aa^zz^2^csp^xx^3^ggg^grid^kk$kk$yu$true#ll$mm$nn$false#"
/// d ##Class(DHCMed.SS.Portlets).Update(PortletInfo)
/// PortletInfo="^student^学生^122^1^5^^1^^DHCMed.SS.Products||GetStringById||1^360^^^^^^^"
ClassMethod Update(PortletInfo) As %String
{
	new (PortletInfo)
	set id=0
	
	set separete="^"
	set ID=$p(PortletInfo,separete,1)
	;set Code=$p(PortletInfo,separete,2)
	;If Code'="" {
	;	Set ID=$o(^DHCMed.SS.PortletsI("IndexCode",$ZCVT(Code,"U"),0))
	;}
	if ID="" {
		set obj=##class(DHCMed.SS.Portlets).%New()
	} else {
		set obj=##class(DHCMed.SS.Portlets).%OpenId(ID)
	}
	set obj.Code=$p(PortletInfo,separete,2)
	set obj.Description=$p(PortletInfo,separete,3)
	set obj.Height=$p(PortletInfo,separete,4)
	set obj.AutoRefreash=$s(+$p(PortletInfo,separete,5)=0:0,1:1)
	if obj.AutoRefreash=0 {
		set obj.Frequency=0
	   }
	else{
	//	set obj.Frequency=$p(PortletInfo,separete,6)
		set obj.Frequency=+$p(PortletInfo,separete,6)
	}
	set obj.Resume=$p(PortletInfo,separete,7)
	set obj.IsActive=$s(+$p(PortletInfo,separete,8)=0:0,1:1)
	set obj.Message=$p(PortletInfo,separete,9)
	set obj.MsgClassMethod=$p(PortletInfo,separete,10)
	set obj.MsgMenuDr=$p(PortletInfo,separete,11)
	set obj.MsgURL=$p(PortletInfo,separete,12)
	set obj.QueryName=$p(PortletInfo,separete,13)
	set obj.DtlMenuDr=$p(PortletInfo,separete,14)
	set obj.DtlURL=$p(PortletInfo,separete,15)
	set obj.DtlShowType=$p(PortletInfo,separete,16)
	set DtlShowConfig=..ListShowConfig($p(PortletInfo,separete,16),$p(PortletInfo,separete,17))
	
    set obj.DtlShowConfig=DtlShowConfig
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=obj.%Id()
		}
	do obj.%Close()
	quit id
}

/// Creator：     maxp
/// CreatDate：   2012-12-05
/// Description:  保存DtlShowConfig
/// Table：       DHCMed.SS.Portlets
/// Input：       showType(grid、chart、mschar)、showConfig
/// showConfig="cs$cx$cd$cf#cz$cv$ch$cj#cm$ck$cu$ci"
/// showConfig="2#az$xv#cu$bi" 
/// showConfig="sdf$hjk#azm$xnv#cbu$bhi" 
/// Return：      list形式的showConfig
/// w ##Class(DHCMed.SS.Portlets).ListShowConfig("mschart",showConfig)
ClassMethod ListShowConfig(showType, showConfig)
{
	set list=""
    quit:showConfig="" list	
	set $li(list,1)=showType

	if (showType="grid") {
		s len=$l(showConfig,"#")
		f i=1:1:len {
			s columnInfo=$p(showConfig,"#",i)
			if (columnInfo'=""){
				s colName=$p(columnInfo,"$",1)
				s dataIndex=$p(columnInfo,"$",2)
				s colHeader=$p(columnInfo,"$",3)
				s isHidden=+$p(columnInfo,"$",4)
				s $li(list,i+1)=$lb(colName,dataIndex,colHeader,isHidden)
			}
		}
	}
	elseif (showType="chart"){
		s type=+$p(showConfig,"#",1)
		s $li(list,2)=$s(type=2:"Pie3D",type=3:"Line",1:"Column3D")
		f i=1:1:2 {
			s dataInfo=$p(showConfig,"#",i+1)
			s title=$p(dataInfo,"$",1)
			s dataIndex=$p(dataInfo,"$",2)
			s $li(list,i+2)=$lb(title,dataIndex)
			}
	}
	else{
		s type=+$p(showConfig,"#",1)
		s $li(list,2)=$s(type=1:"MSColumn3D",1:"MSLine")

		;s $li(list,2)="MSColumn3D"
		f i=1:1:3 {
			s dataInfo=$p(showConfig,"#",i+1)
			s title=$p(dataInfo,"$",1)
			s dataIndex=$p(dataInfo,"$",2)				
			s $li(list,i+2)=$lb(title,dataIndex)
		}
	}
	quit list
}

/// Creator：     maxp
/// CreatDate：   2012-12-05
/// Description:  解析DtlShowConfig
/// Table：       DHCMed.SS.Portlets
/// Input：       showType(chart、mtchar)、showConfig
/// showConfig="2#az$xv#cu$bi"
/// showConfig="sdf$hjk#azm$xnv#cbu$bhi"
/// Return：      字符串形式的showConfig
/// w ##Class(DHCMed.SS.Portlets).ShowConfigToString("mschart",showConfig)
/// w ##Class(DHCMed.SS.Portlets).ShowConfigToString(showConfigList)
ClassMethod ShowConfigToString(showConfigList)
{
	new (showConfigList)
	set str=""
	;s showConfigList=..ListShowConfig(showType,showConfig)
	quit:showConfigList="" str
	s showType=$li(showConfigList,1)
	q:showType="grid" str
	s len=$ll(showConfigList)
	if (showType="chart") {
		s type=$li(showConfigList,2)
		s str=str_$s(type="Column3D":1,type="Pie3D":2,1:3)
		f i=3:1:len {
			s:str'="" str=str_"#"
			s list=$li(showConfigList,i)
			s childStr=""
			if list'="" {
				set ll=$ll(list)
				for j=1:1:ll {
					s:childStr'="" childStr=childStr_"$" 
					s childStr=childStr_$li(list,j)
				}
			s str=str_childStr
			}
		}
	}
	if (showType="mschart") {
		s type=$li(showConfigList,2)
		s str=str_$s(type="MSColumn3D":1,1:2)
		f i=3:1:len {
			s:str'="" str=str_"#"
			s list=$li(showConfigList,i)
			s childStr=""
			if list'="" {
				set ll=$ll(list)
				for j=1:1:ll {
					s:childStr'="" childStr=childStr_"$" 
					s childStr=childStr_$li(list,j)
				}
			s str=str_childStr
			}
		}
	}

	quit str
}

/// Creator：     maxp
/// CreatDate：   2012-09-17
/// Description:  删除Portlets
/// Table：       DHCMed.SS.Portlets
/// Input：       PortletsId
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.SS.Portlets).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

/// Creator：     jiangpengpeng
/// CreatDate：   2014-10-21
/// Description:  检查代码Code是否重复
/// Table：       DHCMed.SS.Portlets
/// Input：       Code
/// Return：      不重复：返回0，重复：返回1
/// w ##Class(DHCMed.SS.Portlets).CheckByCode("EPDReportCnt")
ClassMethod CheckByCode(Code) As %String
{
	new (Code)
	Set return=0
	
	Set ID=0
	If (Code'="") {
		Set ID=$o(^DHCMed.SS.PortletsI("IndexCode",$ZCVT(Code,"U"),0))
	}
	Set:ID>0 return=1
	Quit return
}

Storage Default
{
<Data name="PortletsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AutoRefreash</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>DtlMenuDr</Value>
</Value>
<Value name="6">
<Value>DtlShowConfig</Value>
</Value>
<Value name="7">
<Value>DtlShowType</Value>
</Value>
<Value name="8">
<Value>Frequency</Value>
</Value>
<Value name="9">
<Value>Message</Value>
</Value>
<Value name="10">
<Value>MsgClassMethod</Value>
</Value>
<Value name="11">
<Value>MsgMenuDr</Value>
</Value>
<Value name="12">
<Value>MsgURL</Value>
</Value>
<Value name="13">
<Value>QueryName</Value>
</Value>
<Value name="14">
<Value>IsActive</Value>
</Value>
<Value name="15">
<Value>DtlURL</Value>
</Value>
<Value name="16">
<Value>Resume</Value>
</Value>
<Value name="17">
<Value>Height</Value>
</Value>
</Data>
<DataLocation>^DHCMed.SS.PortletsD</DataLocation>
<DefaultData>PortletsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.SS.PortletsD</IdLocation>
<IndexLocation>^DHCMed.SS.PortletsI</IndexLocation>
<StreamLocation>^DHCMed.SS.PortletsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
