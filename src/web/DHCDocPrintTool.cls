Class web.DHCDocPrintTool Extends (%RegisteredObject, %XML.Adaptor, DHCExternalService.RegInterface.SelfRegPlulic) [ Not ProcedureBlock ]
{

// d ##class(web.DHCDocPrintTool).test()

ClassMethod test() As %DynamicObject
{

	//设置模板元素
	set dynObject1 = ##class(%DynamicObject).%New()
	s dynObject1.HosName="中国医学 科学院肿瘤医院-放疗收费单"
	s dynObject1.RegNo="000000000117"
	s dynObject1.IndexRecLoc="[加速器室]"
	s dynObject1.FPrintYear="2019"
	
	//设置List打印数据
	s dynObject1.MyList= ##class(%DynamicArray).%New()
	s dynObject2 = {"ArcimDesc":"测试1","phO":"1疗程"}
	s dynObject1.MyList."0"=dynObject2
	s dynObject2 = {"ArcimDesc":"测试2","phO":"1疗程"}
	s dynObject1.MyList."1"=dynObject2
	
	//s aaa=##class(DHCDoc.Insu.PublicMeath).getXMLJSONObj("DHCDocFLSFD",dynObject1)
	b ;end1
	s aaa=..getXMLToStr("DHCDocFLSFD",dynObject1)
	
	b ;end
	q
}

/// 模板对象
/// 把打印数据转为JSON对象
/// w ##class(web.DHCDocPrintTool).getXMLJSONObj("DHCDocFLSFD",MesaObj 赋值对象)
/// input XMLName 模板名称  MesaObj 组织的数据对象
/// return json 对象模式
ClassMethod getXMLJSONObj(XMLName, MesaObj As %DynamicObject) As %DynamicObject
{
	n (XMLName,MesaObj)
   //获取打印模板对象
   Q:XMLName="" ""
   s XMLName=$zcvt(XMLName,"U")
   s XMLName=" "_XMLName
   s Id=$O(^User.DHCXMLPConfigI("XPCFlagIndex",XMLName,0))
   s XMLC=##class(User.DHCXMLPConfig).%OpenId(Id)
   s XMLStr=XMLC.XPCFileData.Read()
 
   ;组织txt数据
   //s TxtData=$P(XMLStr,"<TxtData",2)
   //s TxtData=$P(TxtData,"</TxtData>",1)
   s TxtData=""
   for m=1:1:$L(XMLStr,"</TxtData>") {
	   s OneData=$P(XMLStr,"</TxtData>",m)
	   s TxtData=TxtData_$P(OneData,"<TxtData",2)
	   }
   s printdata={"data":{}}
   for i=1:1:$L(TxtData,"<txtdatapara")  d
   .s sub=$P(TxtData,"<txtdatapara",i)
   .Q:((sub'["name")||(sub'["printvalue"))
   .s name=$$getnamecode("name")
   .;s one={}
   .s Printvalue=MesaObj.%Get(name)
   .Q:Printvalue=""
   .;s rtn=one.%Set(name,Printvalue)
   .d printdata.data.%Set(name,Printvalue)
   
   ;组织PICData数据
   //s PICData=$P(XMLStr,"<PICData",2)
   //s PICData=$P(PICData,"</PICData>",1)
   s PICData=""
   for m=1:1:$L(XMLStr,"</PICData>") {
	   s OneData=$P(XMLStr,"</PICData>",m)
	   s PICData=PICData_$P(OneData,"<PICData",2)
	   }
   for i=1:1:$L(PICData,"<PICdatapara")  d
   .s sub=$P(PICData,"<PICdatapara ",i)
   .Q:((sub'["name")||(sub'["printvalue"))
   .s name=$$getnamecode("name")
   .;s one={}
   .s Printvalue=MesaObj.%Get(name)
   .Q:Printvalue=""
   .;s rtn=one.%Set(name,Printvalue)
   .d printdata.data.%Set(name,Printvalue)
   
   ;获取List节点
   k LisNote
   s ListData=$P(XMLStr,"<ListData",2,9999)
   s ListData=$P(ListData,"</ListData>",1)
   for i=1:1:$L(ListData,"<Listdatapara")  d
   .s sub=$P(ListData,"<Listdatapara",i)
   .Q:sub=""
   .Q:((sub'["name")||(sub'["printvalue"))
   .s name=$$getnamecode("name")
   .s defaultvalue=$$getnamecode("defaultvalue")
   .s printvalue=$$getnamecode("printvalue")
   .Q:name=""
   .s num=$I(LisNote(0))
   .s LisNote(num)=name
   
   ;获取List的值
   s printdataList={"MyList":[]}
   if $IsObject(MesaObj.MyList){
	   s size=MesaObj.MyList.%Size()
	   for i=0:1:(size-1)  d
	   .s onelistobj=MesaObj.MyList.%Get(i)
	   .s one={}
	   .s find=""
	   .s num1=0
	   .f  s num1=$O(LisNote(num1)) Q:num1=""  d
	   ..s name=$G(LisNote(num1))
	   ..s printvalue=onelistobj.%Get(name)
	   ..s valein=[]
	   ..d valein.%Push(printvalue)
	   ..d one.%Set(name,valein)
	   ..s find="Y"
	   .i find="Y"  d
	   ..d printdataList.MyList.%Push(one) 
   }
   s printdata.data.MyList=##class(%DynamicArray).%New()
   s printdata.data.MyList=printdataList.MyList
   q printdata.data
getnamecode(code)
	s value1=$tr($P($P($P(sub,code,2)," ",1),"=",2),"""","")
	s value1=$tr(value1," ","")
	q value1
}

/// 按照打印模板获取打印XML串  
/// return MyPara!!!MyList
/// input XMLName 模板名称  MesaObj 组织的数据对象
/// return MyPara!!!MyList  操作公共打印接口入参
ClassMethod getXMLToStr(XMLName, MesaObj As %DynamicObject) As %String
{
	n (XMLName,MesaObj)
	s JsonObj=##class(web.DHCDocPrintTool).getXMLJSONObj(XMLName,MesaObj)
	s MyPara=""
	s MyList=""
	if $IsObject(JsonObj){
		set iter = JsonObj.%GetIterator()
	    while iter.%GetNext(.key , .value ) {if (key="MyList"){d getMyList(value)}else{ if (MyPara=""){s MyPara=key_$C(2)_value}else{s MyPara=MyPara_"^"_key_$C(2)_value}}}
	}
	q MyPara_"!!!"_MyList
getMyList(listobj)
	if $IsObject(listobj){
		s sizelist=listobj.%Size()
		for il1=0:1:sizelist-1  d
		.s onelist=listobj.%Get(il1)
		.s onelistmes=""
		.set iterlist = onelist.%GetIterator()
		.while iterlist.%GetNext(.key , .value ) {if (onelistmes=""){s onelistmes=value.%Get(0)}else{s onelistmes=onelistmes_"^"_value.%Get(0)}}
		.Q:onelistmes=""
		.if MyList="" d
		..s MyList=onelistmes
		.else  d
		..s MyList=MyList_$c(2)_onelistmes
	}
	q
}

/// 需要打印的数据
/// OrderList 需要打印的数据数组 OnePageRow 每页多少行 ListNum 列数量 每列宽度
/// input:
/// OrderList 组织的打印数据数组的指针 每行数据用^分割 OrderList(1)=order1^order2^Order3
/// OnePageRow 一页打印多少行 15
/// ListNum 数据列 3
/// ListLeng 没列长度20^0 不控制列是0
/// RtnList(sub1,sub2) 第一个节点为 页码 第二个节点为 自增  返回使用 分页后的数据
/// output:
/// pagenump 页码
/// 
ClassMethod GetPrintList(OrderList, OnePageRow, ListNum, ListLeng, RtnList) As %String
{
	n (OrderList,OnePageRow,ListNum,ListLeng,RtnList)
	s $zt="ErrorGetPrintList"
	;设定每列最大字符 为空则是全部
	for i1List=1:1:$L(ListLeng,"^") d
	.s LM(i1List)=((+$P(ListLeng,"^",i1List)))
	s LML=ListNum
	s sub1=0
	f  s sub1=$O(OrderList(sub1)) Q:sub1=""  d
	.s Mesage=$G(OrderList(sub1))
	.s LML=$L(Mesage,"^")
	.for iM=1:1:LML  d
	..s Mesagesub=$P(Mesage,"^",iM) 
	..s MesageL=$$findlength(Mesagesub) //转换字符长度让输出视觉更合理 ;$L(Mesagesub) 
	..s LMNUM=+$G(LM(iM))
	..if LMNUM=0 d
	...;如果没有维护长度一次性插入
	...s $P(OrderList(sub1,1),"^",iM)=Mesagesub
	..else  d
	...s a=MesageL/LMNUM
	...if a<=1  d
	....s $P(OrderList(sub1,1),"^",iM)=Mesagesub
	...else  d
	....s b=$fn(a,"",0)
	....if a>b s b=b+1 //取最大行
	....for j=1:1:b  d
	.....s sub2mesag=$E(Mesagesub,(LMNUM*j-LMNUM+1),LMNUM*j)
	.....s $P(OrderList(sub1,j),"^",iM)=sub2mesag
	
	;组织输出数据
	k MyList
	s MaxL=ListNum
	;组织每一行的打印数据到Globle中在打印的时候按照每一行进行输出
	s groupnum=0
	s sub1=0
	f  s sub1=$O(OrderList(sub1)) Q:sub1=""  d
	.s sub2=0
	.f  s sub2=$O(OrderList(sub1,sub2)) Q:sub2=""  d
	..s Mesag=$G(OrderList(sub1,sub2))
	..Q:Mesag=""
	..if ($P(Mesag,"^",MaxL)="") {s $P(Mesag,"^",MaxL)=""}
	..s isub=$I(MyList(0))
	..s MyList(isub)=Mesag
	
	k RtnList
	s num=0
	s pagenump=1
	s isub=0
	f  s isub=$O(MyList(isub)) Q:isub=""  d
	.if (OnePageRow'="")&&(OnePageRow=num)  d
	..s pagenump=pagenump+1
	..s num=0
	.s num=num+1
	.s RtnList(pagenump,num)=$G(MyList(isub))

	q pagenump
ErrorGetPrintList
	q "-1"
findlength(meschange)
	s lengb="qazwsxedcrfvtgbyhnujmikopl123456789~`!@#$%^&*()-+=-?<>/\][{}:;'"""""
	s length8="QAZWSXEDCRFVTGBYHNUJMIKLO"
	s findleng=0
	for ilen=1:1:$L(meschange)  d
	.s onem=$E(meschange,ilen,ilen)
	.if lengb[onem  d
	..s findleng=findleng+0.85
	.else  if length8[onem  d
	..s findleng=findleng+1
	.else  d
	..s findleng=findleng+1
	q findleng
}

}
