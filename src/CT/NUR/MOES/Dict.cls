/// Creator：      EH
/// CreatDate：    2021-04-16
/// Description:   基础字典
///                基础数据和配置表结构几乎一致因而统一
Class CT.NUR.MOES.Dict Extends (%Persistent, Nur.MobileCare.Base) [ Not ProcedureBlock ]
{

/// 路径
Property DictPath As %String(MAXLEN = 256, TRUNCATE = 1);

/// 代码
Property DictCode As %String(MAXLEN = 256, TRUNCATE = 1);

/// 名称
Property DictName As %String(MAXLEN = 256, TRUNCATE = 1);

/// 是否启用
Property ActiveFlag As %String(TRUNCATE = 1);

/// 排序
Property DictSort As %String(TRUNCATE = 1);

/// 元素
Property DictElement As %String(MAXLEN = 1024, TRUNCATE = 1);

/// 内容
Property DictContent As %String(MAXLEN = 1024, TRUNCATE = 1);

/// 解释
Property DictInterpretation As %String(MAXLEN = 1024, TRUNCATE = 1);

/// 参数
Property DictParameter As %String(MAXLEN = 1024, TRUNCATE = 1);

/// 注释
Property DictComment As %String(MAXLEN = 1024, TRUNCATE = 1);

Index DictCode On (DictPath, DictCode);

Index DictSort On (DictPath, DictSort);

/// Creator：      EH
/// CreatDate：    2021-04-16
/// Description:   原始数据
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   
ClassMethod Raw(path, ByRef data) As %String
{
	n (path,data)
	k data s j=0
	s dictPathNode=..PathAppend(path)
	s dictPath=..Path(dictPathNode)
	i (dictPathNode="") {
		s data($i(j))=$lb("",dictPath,"mainModule","模块显示设置","Y",j,"","","","","")
		s data($i(j))=$lb("",dictPath,"window","窗口显示设置","Y",j,"","","","","")
		s data($i(j))=$lb("",dictPath,"hotLink","友情链接","Y",j,"","","","","")
		s data($i(j))=$lb("",dictPath,"globalSetting","全局设置","Y",j,"","","","","")
	}
	i (dictPathNode="mainmodule") {
		s data($i(j))=$lb("",dictPath,"infusion_main_py","配液","Y",j,"","","","{fragment:""com.dhcc.module.infusion.workarea.dosing.DosingFragment""}","")
		s data($i(j))=$lb("",dictPath,"infusion_main_cc","穿刺","Y",j,"","","","{fragment:""com.dhcc.module.infusion.workarea.puncture.PunctureFragment""}","")
		s data($i(j))=$lb("",dictPath,"infusion_main_xs","巡视","Y",j,"","","","{fragment:""com.dhcc.module.infusion.workarea.patrol.PatrolFragment""}","")
		s data($i(j))=$lb("",dictPath,"infusion_main_xy","续液","Y",j,"","","","{fragment:""com.dhcc.module.infusion.workarea.continues.ContinueFragment""}","")
		s data($i(j))=$lb("",dictPath,"infusion_main_bz","输液结束","Y",j,"","","","{fragment:""com.dhcc.module.infusion.workarea.needles.NeedlesFragment""}","")
		s data($i(j))=$lb("",dictPath,"infusion_main_skin","皮试","Y",j,"","","","{fragment:""com.dhcc.module.infusion.workarea.skin.SkinFragment""}","")
		s data($i(j))=$lb("",dictPath,"infusion_main_skin_dosing","皮试配液","Y",j,"","","","{fragment:""com.dhcc.module.infusion.workarea.skin.SkinDosingFragment""}","")
		s data($i(j))=$lb("",dictPath,"infusion_main_blood_check","采血复核","Y",j,"","","","{fragment:""com.dhcc.module.infusion.workarea.blood.BloodCollectionCheckFragment""}","")
		s data($i(j))=$lb("",dictPath,"infusion_main_blood","采血","Y",j,"","","","{fragment:""com.dhcc.module.infusion.workarea.blood.BloodCollectionFragment""}","")
		s data($i(j))=$lb("",dictPath,"infusion_main_inject_dosing","注射配液","Y",j,"","","","{fragment:""com.dhcc.module.infusion.workarea.inject.InjectDosingFragment""}","")
		s data($i(j))=$lb("",dictPath,"infusion_main_inject","注射","Y",j,"","","","{fragment:""com.dhcc.module.infusion.workarea.inject.InjectFragment""}","")
		s data($i(j))=$lb("",dictPath,"infusion_main_order_excute","医嘱执行","Y",j,"","","","{fragment:""com.dhcc.module.infusion.workarea.orderexecute.OrderExecuteFragment""}","")
		s data($i(j))=$lb("",dictPath,"infusion_main_drug_receive","药品接收","N",j,"","","","{fragment:""com.dhcc.module.infusion.workarea.drugreceive.DrugReceiveFragment""}","")
		s data($i(j))=$lb("",dictPath,"infusion_main_blood_receive","输血签收","Y",j,"","","","{fragment:""com.dhcc.module.infusion.workarea.transblood.TransBloodReceiveFragment""}","")
		s data($i(j))=$lb("",dictPath,"infusion_main_blood_transfuse","输血输注","Y",j,"","","","{fragment:""com.dhcc.module.infusion.workarea.transblood.TransBloodInfusionFragment""}","")
		s data($i(j))=$lb("",dictPath,"infusion_main_blood_tour","输血巡视","Y",j,"","","","{fragment:""com.dhcc.module.infusion.workarea.transblood.TransBloodTourFragment""}","")
		s data($i(j))=$lb("",dictPath,"infusion_main_blood_finish","输血结束","Y",j,"","","","{fragment:""com.dhcc.module.infusion.workarea.transblood.TransBloodEndFragment""}","")
		s data($i(j))=$lb("",dictPath,"infusion_main_blood_recycle","血袋回收","N",j,"","","","{fragment:""com.dhcc.module.infusion.workarea.transblood.TransBloodRecycleFragment""}","")
	}
	i (dictPathNode="window") {
		s data($i(j))=$lb("",dictPath,"CK1","窗口1","Y",j,"","","","","")
		s data($i(j))=$lb("",dictPath,"CK2","窗口2","Y",j,"","","","","")
		s data($i(j))=$lb("",dictPath,"CK3","窗口3","Y",j,"","","","","")
		s data($i(j))=$lb("",dictPath,"CK4","窗口4","Y",j,"","","","","")
	}
	i (dictPathNode="hotlink") {
		s data($i(j))=$lb("",dictPath,"upgradeLink","版本升级设置","Y",j,"{type:""hidden""}","","","","")
	}
	i (dictPathNode="globalsetting") {
		s data($i(j))=$lb("",dictPath,"parameter","参数设置","Y",j,"","","","","")
		s data($i(j))=$lb("",dictPath,"option","选项设置","Y",j,"","","","","")
		s data($i(j))=$lb("",dictPath,"flow","流程设置","Y",j,"","","","","")
		s data($i(j))=$lb("",dictPath,"function","功能设置","Y",j,"","","","","")
	}
	i (dictPathNode="globalsetting/parameter") {
		s data($i(j))=$lb("",dictPath,"defautSpeed","默认滴速","Y",j,"{type:""numberbox"",value:45,options:""min:0,max:100,precision:0""}","","","","")
		s data($i(j))=$lb("",dictPath,"skinTest.queryDays","皮试查询天数","Y",j,"{type:""numberbox"",value:45,options:""min:0,max:14,precision:0"",frontEnd:true,frontEndCode:""skinDateOffset""}","","","","")
	}
	i (dictPathNode="globalsetting/option") {
		s data($i(j))=$lb("",dictPath,"PunPart","输液部位","Y",j,"{type:""textbox"",singleLine:true,width:""250px"",value:""手背^脑后^脚背""}","","","","") /// textarea展现效果不佳改textbox/singleLine
		s data($i(j))=$lb("",dictPath,"puntureTools","输液方式","Y",j,"{type:""textbox"",singleLine:true,width:""250px"",value:""头皮针^留置针^输液港^PICC^中长期导管^CVC""}","","","","")
		s data($i(j))=$lb("",dictPath,"infusionStates","输液状态","Y",j,"{type:""textbox"",singleLine:true,width:""250px"",value:""正常^暂停^结束^其他""}","","","","")
		s data($i(j))=$lb("",dictPath,"IFReason","暂停原因","Y",j,"{type:""textbox"",singleLine:true,width:""250px"",value:""鼓针^患者要求""}","","","","")
	}
	i (dictPathNode="globalsetting/flow") {
		s data($i(j))=$lb("",dictPath,"dispensing.control","配液控制","Y",j,"{type:""checkbox"",value:true}","","","","")
		s data($i(j))=$lb("",dictPath,"dispensing.scanFlag","配液扫描确认","Y",j,"{type:""combobox"",singleLine:true,width:""150px"",value:""All"",data:[{name:""自动确认"",code:""All""},{name:""单个确认"",code:""Single""},{name:""/"",code:""/""}]}","","","","")
		s data($i(j))=$lb("",dictPath,"recOrdFlag","接单控制","Y",j,"{type:""checkbox"",value:true}","","","","")
		s data($i(j))=$lb("",dictPath,"skinTest.dualSignFlag","皮试双签名","Y",j,"{type:""checkbox"",value:true,frontEnd:true,frontEndCode:""msgSkinFlag""}","","","","")
	}
	i (dictPathNode="globalsetting/function") {
		s data($i(j))=$lb("",dictPath,"logFlag","启用日志","Y",j,"{type:""checkbox"",value:true,frontEnd:true,frontEndCode:""logFlag""}","","","","")
		s data($i(j))=$lb("",dictPath,"globalViewFlag","扫码界面快捷切换","Y",j,"{type:""checkbox"",value:true,frontEnd:true,frontEndCode:""globalViewFlag""}","","","","")
		s data($i(j))=$lb("",dictPath,"infusion.background","输液背景显示","Y",j,"{type:""checkbox"",value:true,frontEnd:true,frontEndCode:""ordStateFlag""}","","","","")
	}
	q j
}

/// Creator：      EH
/// CreatDate：    2021-04-16
/// Description:   取数据
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   w ##class(CT.NUR.MOES.Dict).Data("globalsetting",.data,"Y")
ClassMethod Data(path, ByRef data, expanding = "", ByRef more = "", ByRef recursion = "") As %String
{
	n (path,data,expanding,more,recursion)
	k data,arr,pathNodeArr
	s j=0,pathCount=0
	s pathArr($i(pathCount))=path
	/// 数组
	i (more="Y") d
	.s root=..Root()
	.s pathCount=0
	.s pathLength=$l(path,",")
	.f pathIndex=1:1:pathLength d
	..s pathNode=$p(path,",",pathIndex)
	..q:(pathNode=root)
	../// 查重
	..s repetition=0
	..f pathKey=1:1:pathCount d
	...s pathEnum=$p(path,",",pathKey)
	...i (pathEnum=pathNode) d
	....s repetition=1,pathKey=pathCount
	..q:(repetition=1)
	..s pathArr($i(pathCount))=pathNode
	s pathIndex=0
	while ($i(pathIndex)'>pathCount) {
		s pathNode=$g(pathArr(pathIndex))
		s dictPath=..Path(pathNode)
		s dictPathNode=$zcvt(dictPath,"U")
		s dictCodeNode="" f  s dictCodeNode=$o(^CT.NUR.MOES.DictI("DictCode"," "_dictPathNode," "_dictCodeNode)),dictCodeNode=$tr(dictCodeNode," ","") q:(dictCodeNode="")  d
		.s rw=$o(^CT.NUR.MOES.DictI("DictCode"," "_dictPathNode," "_dictCodeNode,""))
		.s rec=##class(CT.NUR.MOES.Dict).%OpenId(rw)
		.q:('$isobject(rec))
		.d rec.%Close()
		.s lb=$g(^CT.NUR.MOES.DictD(rw))
		.s sort=..DictSort(lb)
		.d ..Default(.sort,"DictSort")
		.s arr(pathIndex,sort,rw)=lb
		.q:(expanding'="Y")
		.s dictCode=..DictCode(lb)
		.s childPath=..Path(pathNode,dictCode)
		.s k=..Data(childPath,.child,expanding,more,"Y")
		.i (k)>0 m arr(pathIndex,sort,rw)=child
	}
	s pathIndex="" f  s pathIndex=$o(arr(pathIndex)) q:(pathIndex="")  d
	.s sort="" f  s sort=$o(arr(pathIndex,sort)) q:(sort="")  d
	..s rw=0 f  s rw=$o(arr(pathIndex,sort,rw)) q:(rw="")  d
	...m data($i(j))=arr(pathIndex,sort,rw)
	q j
}

/// Creator：      EH
/// CreatDate：    2021-04-16
/// Description:   取code
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   
ClassMethod DictCode(lb) As %String
{
	n (lb)
	q ..LG(lb,3)
}

/// Creator：      EH
/// CreatDate：    2021-04-16
/// Description:   取sort
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   
ClassMethod DictSort(lb) As %String
{
	n (lb)
	q ..LG(lb,6)
}

/// Creator：      EH
/// CreatDate：    2021-04-16
/// Description:   初始化数据
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   w ##class(CT.NUR.MOES.Dict).Init("Y")
ClassMethod Init(clear = "", path = "", ByRef init = "", ByRef recursion = "") As %String
{
	n (clear,path,init,recursion)
	i (clear="Y")&(recursion'="Y") s sc=..Clear()
	s i=..Data(path,.data)
	s j=..Raw(path,.raw)
	i (i<j) {
		s k=..CAMinus(.raw,.data,.complement,3)
		i (k>0) {
			s k=..CASave(.complement)
			i (k>0) {
				s i=..Data(path,.data)
				s init=init+k
			}
		}
	}
	s i=0 f  s i=$o(data(i)) q:(i="")  d
	.s code=..DictCode(data(i))
	.q:(code="")
	.s child=..PathAppend(path,code)
	.s k=..Raw(child,.complement)
	.i (k>0) d ..Init("N",child,.init,"Y")
	q init
}

/// Creator：      EH
/// CreatDate：    2021-04-16
/// Description:   保存
/// Table:		   
/// Input:   	   
/// Return:		   
/// Other:		   
ClassMethod Save(parr = "") As %String
{
	n (parr)
	s ret=-100
	s dictPath=$p(parr,"^",1)
	s dictCode=$p(parr,"^",2)
	i (dictCode="") q ret
	s id=$o(^CT.NUR.MOES.DictI("DictCode"," "_$zcvt(dictPath,"U")," "_$zcvt(dictCode,"U"),""))
	i (id'="") {
		s rec=##class(CT.NUR.MOES.Dict).%OpenId(id)
		i ('$isobject(rec)) q ret
	} else {
		s rec=##class(CT.NUR.MOES.Dict).%New()
	}
	d rec.Properties(.arr)
	s i=0 f  s i=$o(arr(i)) q:(i="")  d
	.s name=arr(i)
	.s value=$p(parr,"^",i)
	.i (name="DictElement") s value=$replace(value,"%5E","^")
	.s $zobjproperty(rec,name)=value
	s sc=rec.%Save()
	i ($$$ISOK(sc)) s ret=rec.%Id()
	d rec.%Close()
	q ret
}

Storage Default
{
<Data name="DictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DictPath</Value>
</Value>
<Value name="3">
<Value>DictCode</Value>
</Value>
<Value name="4">
<Value>DictName</Value>
</Value>
<Value name="5">
<Value>ActiveFlag</Value>
</Value>
<Value name="6">
<Value>DictSort</Value>
</Value>
<Value name="7">
<Value>DictElement</Value>
</Value>
<Value name="8">
<Value>DictContent</Value>
</Value>
<Value name="9">
<Value>DictInterpretation</Value>
</Value>
<Value name="10">
<Value>DictParameter</Value>
</Value>
<Value name="11">
<Value>DictComment</Value>
</Value>
</Data>
<DataLocation>^CT.NUR.MOES.DictD</DataLocation>
<DefaultData>DictDefaultData</DefaultData>
<IdLocation>^CT.NUR.MOES.DictD</IdLocation>
<IndexLocation>^CT.NUR.MOES.DictI</IndexLocation>
<StreamLocation>^CT.NUR.MOES.DictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
