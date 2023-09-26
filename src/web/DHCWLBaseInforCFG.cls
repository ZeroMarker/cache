Import SQLUSER

Class web.DHCWLBaseInforCFG Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 获取DHCWLBaseInforCfg表的时间属性
/// 返回字符串：[['',''],['Code1','Name1'],['Code2','Name2']]
ClassMethod GetDateFlag() As %String
{
	s Id=0
	s DateFlag=0
	s Str="['',''],"
	f  s DateFlag=$O(^DHCWLBIC(0,"DateFlag",DateFlag)) Q:DateFlag=""  d
	.s Id=Id+1
	.s Str=Str_"['"_Id_"','"_DateFlag_"'],"
	Q "["_$e(Str,1,$l(Str)-1)_"]"
}

/// 根据临时global来获取时间属性
/// 获取病人基础信息的配置信息
/// 返回字符串：[['',''],['Code1','Name1'],['Code2','Name2']]
ClassMethod GetDateFlagByGlobal() As %String
{
	s Id=0
	s DateFlag=0
	s Str="['',''],"
	f  s DateFlag=$O(^DHCWLPatBaseLoadInit("DateFlag",DateFlag)) Q:DateFlag=""  d
	.s Id=Id+1
	.s Str=Str_"['"_Id_"','"_DateFlag_"'],"
	Q "["_$e(Str,1,$l(Str)-1)_"]"
}

/// 获取DHCWLBaseInforCfg表的取值标志
/// 返回字符串：[['',''],['Code1','Name1'],['Code2','Name2']]
ClassMethod GetInterFlag() As %String
{
	s Id=0
	s InterFlag=0
	s Str="['',''],"
	f  s InterFlag=$O(^DHCWLBIC(0,"InterFlag",InterFlag)) Q:InterFlag=""  d
	.s Id=Id+1
	.s Str=Str_"['"_Id_"','"_InterFlag_"'],"
	Q "["_$e(Str,1,$l(Str)-1)_"]"
}

/// 根据临时global来获得取值标志
/// 获取病人基础信息的配置信息
/// 返回字符串：[['',''],['Code1','Name1'],['Code2','Name2']]
ClassMethod GetInterFlagByGlobal() As %String
{
	s Id=0
	s InterFlag=0
	s Str="['',''],"
	f  s InterFlag=$O(^DHCWLPatBaseLoadInit("InterFlag",InterFlag)) Q:InterFlag=""  d
	.s Id=Id+1
	.s Str=Str_"['"_Id_"','"_InterFlag_"'],"
	Q "["_$e(Str,1,$l(Str)-1)_"]"
}

/// 获取DHCWLBaseInforCfg表的数据
/// 返回字符串：{result:20,totalNum:908,root:[{Id:1,BICCode:'Code'}]}
/// 空：{result:0,totalNum:0,root:[]}
/// w ##Class(web.DHCWLBaseInforCFG).GetBICInfor()
ClassMethod GetBICInfor(BICStr As %String = "", PagePar As %String = "") As %String
{
	n (BICStr,PagePar)
	s startPage=$P(PagePar,"^",1)
	s endPage=$P(PagePar,"^",2)
	i +startPage=0 s startPage=0
	i +endPage=0 s endPage=20
	s mBICId=$tr($P(BICStr,"^",1)," ","")
	s mBICCode=$tr($P(BICStr,"^",3)," ","")
	s mBICDesc=$tr($P(BICStr,"^",2)," ","")
	s mBICDateFlag=$tr($P(BICStr,"^",4)," ","")
	s mBICInterFlag=$tr($P(BICStr,"^",5)," ","")
	s mBICNature=$tr($P(BICStr,"^",6)," ","")
	s mBICFunction=$tr($P(BICStr,"^",7)," ","")
	i mBICNature["更新<RF>" s mBICNature="RF"
	i mBICNature["累计<AF>" s mBICNature="AF"
	s Id=0
	s result=0,totalNum=0,Str=""
	f  s Id=$O(^DHCWLBIC(Id)) Q:Id=""  d
	.s BICCode=$P(^DHCWLBIC(Id),"^",3)
	.s BICDesc=$P(^DHCWLBIC(Id),"^",2)
	.s BICDateFlag=$P(^DHCWLBIC(Id),"^",4)
	.s BICInterFlag=$P(^DHCWLBIC(Id),"^",5)
	.s BICNature=$P(^DHCWLBIC(Id),"^",6)
	.s BICFunction=$P(^DHCWLBIC(Id),"^",7)
	.Q:(Id'=mBICId)&&(mBICId'="")
	.Q:(BICCode'[mBICCode)&&(mBICCode'="")
	.Q:(BICDesc'[mBICDesc)&&(mBICDesc'="")
	.Q:(BICDateFlag'[mBICDateFlag)&&(mBICDateFlag'="")
	.Q:(BICInterFlag'[mBICInterFlag)&&(mBICInterFlag'="")
	.Q:(BICNature'[mBICNature)&&(mBICNature'="")
	.Q:(BICFunction'[mBICFunction)&&(mBICFunction'="")
	.s totalNum=totalNum+1
	.s result=result+1
	.Q:((result<startPage)||(result>endPage))
	.s Str=Str_"{ID:'"_Id_"',BICCode:'"_BICCode_"',BICDesc:'"_BICDesc_"',BICDateFlag:'"_BICDateFlag_"',BICInterFlag:'"_BICInterFlag_"',BICNature:'"_BICNature_"',BICFunction:'"_BICFunction_"'},"
	i Str'="" d
	.s Return="{result:"_result_",totalNum:"_totalNum_",root:["_$e(Str,1,$l(Str)-1)_"]}"
	else  d
	.s Return="{result:"_0_",totalNum:"_0_",root:[]}"
	Q $g(Return)
}

ClassMethod Insert(ByRef data) As %String
{
	n (data)
	q:(data("BICCode")="")||(data("BICDesc")="")||(data("BICDateFlag")="")||(data("BICInterFlag")="")||(data("BICNature")="")||(data("BICFunction")="") "病人基础信息不全！"
	//首先判断指标代码是否已经存在。
	i $d(^DHCWLBIC(0,"Code",data("BICCode"),"U"))  q "病人基础信息代码"_data("BICCode")_"已经存在!"
	s BICobj=##class(User.DHCWLBaseInforCFG).%New()
	s BICobj.BICCode=$g(data("BICCode"))
	s BICobj.BICDesc=$g(data("BICDesc"))
	s BICobj.BICDateFlag=data("BICDateFlag")
	s BICobj.BICInterFlag=data("BICInterFlag")
	s BICobj.BICNature=$g(data("BICNature"))
	s BICobj.BICFunction=data("BICFunction")
	i BICobj.BICNature["更新<RF>" s BICobj.BICNature="RF"
	i BICobj.BICNature["累计<AF>" s BICobj.BICNature="AF"
	s sc=BICobj.%Save()
	i sc=1 Q "ok"
	e  Q "Error"
}

ClassMethod Update(id, ByRef data) As %String
{
	n (id,data)
	q:data("BICCode")="" "病人基础信息不能为空！"
	s BICobj=##class(User.DHCWLBaseInforCFG).%OpenId(id)
	i BICobj=""  q "不存在该基础Code，请重选！"
	s BICRowid=$O(^DHCWLBIC(0,"Code",data("BICCode"),""))
	i (+BICRowid=0)||(BICRowid'=+id) q "该基础信息不允许被修改!"
	s BICobj.BICCode=$g(data("BICCode"))
	s BICobj.BICDesc=$g(data("BICDesc"))
	s BICobj.BICDateFlag=$g(data("BICDateFlag"))
	s BICobj.BICInterFlag=$g(data("BICInterFlag"))
	s BICobj.BICNature=$g(data("BICNature"))
	s BICobj.BICFunction=$g(data("BICFunction"))
	i BICobj.BICNature["更新<RF>" s BICobj.BICNature="RF"
	i BICobj.BICNature["累计<AF>" s BICobj.BICNature="AF"
	s sc=BICobj.%Save()
	i sc=1 q "ok"
	e  q "Error"
}

ClassMethod Delete(id) As %String
{
	n (id)
	q:id="" "请选择删除已经存在的病人基础信息！"
	s sc=##class(User.DHCWLBaseInforCFG).%DeleteId(id)
	i sc=1  q "ok"
	e  q "删除失败！"
}

Storage Default
{
<Data name="DHCWLBaseInforCFGDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCWLBaseInforCFGD</DataLocation>
<DefaultData>DHCWLBaseInforCFGDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCWLBaseInforCFGD</IdLocation>
<IndexLocation>^web.DHCWLBaseInforCFGI</IndexLocation>
<StreamLocation>^web.DHCWLBaseInforCFGS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
