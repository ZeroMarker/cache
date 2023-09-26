Import SQLUser

Class web.INSUTarItemsCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 116;

/// **********************************************
/// 查询医保收费项目
/// 入参说明
/// /// 关键字：sKeyWord
/// /// 关键字类型：Class （拼音码、代码、名称） 
/// /// 目录类型：Type （韶关医保、广铁医保） 
/// Write by wuqk 2005-05-11
/// **********************************************
ClassMethod QueryAll(sKeyWord As %String, Class As %String, Type As %String)
{
	;n (sKeyWord,Class,Type)
    k ^CACHETEMP("INSUDIC")
    s ^CACHETEMP("INSUDIC",$j)=0
    s:sKeyWord="" Class="0"
    s count=0
    ;&js<alert("xxx")>
    i Class="0" d  s count=..QueryDic0(Type)      ;查询所有
    i Class="1" d  s count=..QueryDic1(sKeyWord,Type)      ;按照拼音码查询
    i Class="2" d  s count=..QueryDic2(sKeyWord,Type)      ;按照代码查询
    i Class="3" d  s count=..QueryDic3(sKeyWord,Type)      ;按照名称查询    Add  By wuqk 2005-07-25
    ;i Class"4" d  s count=..QueryDic4(sKeyWord,Type)      ;按照大类编码查询
    ;i Class"5" d  s count=..QueryDic5(sKeyWord,Type)      ;按照项目类别查询
    ;i Class"6" d  s count=..QueryDic6(sKeyWord,Type)      ;按照统计编码查询
    q $j
}

/// ;查询所有
ClassMethod QueryDic0(Type As %String)
{
	n (Type)
    ;&js<alert("000")>
    s id="0"
    f  s id=$O(^DHCINTIM(id)) q:id=""  s s=^(id) d
    .q:Type'=$p(s,"^",2)
    .s flag=..GetINTIM(id)
    q 0
}

/// ;按照拼音码查询
ClassMethod QueryDic1(sKeyWord As %String, Type As %String)
{
	n (sKeyWord,Type)
    ;&js<alert("111")>
	s sKeyWord=$ZCVT(sKeyWord,"U")
	s err=..SelectAlias(sKeyWord,Type)
	s desc=sKeyWord
	f  s desc=$O(^DHCINTIM("0","Alias",desc))  q:(desc="")!(desc'[sKeyWord)  d
	.s err=..SelectAlias(desc,Type)
    q 0
}

/// 按照别名查找
ClassMethod SelectAlias(Alias As %String, Type As %String)
{
	n (Alias,Type)
	;&js<alert("Alias")>
    s id=""
    f  s id=$O(^DHCINTIM("0","Alias",Alias,id))  q:id=""  d
    .s s=$g(^DHCINTIM(id))
    .q:Type'=$p(s,"^",2)
    .s flag=..GetINTIM(id)
    q 0
}

/// ;按照代码查询
ClassMethod QueryDic2(sKeyWord As %String, Type As %String)
{
	n (sKeyWord,Type)
    ;&js<alert("222")>
	s sKeyWord=$ZCVT(sKeyWord,"U")
	s id=""
	f  s id=$O(^DHCINTIM("0","CODE",sKeyWord,id))  q:id=""  d
	.s s=$g(^DHCINTIM(id))
	.q:Type'=$p(s,"^",2)
    .s flag=..GetINTIM(id)
    q 0
}

/// ;按照名称查询
ClassMethod QueryDic3(sKeyWord As %String, Type As %String)
{
	n (sKeyWord,Type)
    ;&js<alert("222")>
	;s sKeyWord=$ZCVT(sKeyWord,"U")
	s err=..SelectDESC(sKeyWord,Type)
	s desc=sKeyWord
	f  s desc=$O(^DHCINTIM("0","DESC",desc))  q:(desc="")!(desc'[sKeyWord)  d
	.s err=..SelectDESC(desc,Type)
    q 0
}

/// 按照名称查找
ClassMethod SelectDESC(DESC As %String, Type As %String)
{
	n (DESC,Type)
	;&js<alert("Alias")>
    s id=""
    f  s id=$O(^DHCINTIM("0","DESC",DESC,id))  q:id=""  d
    .s s=$g(^DHCINTIM(id))
    .q:Type'=$p(s,"^",2)
    .s flag=..GetINTIM(id)
    q 0
}

/// 取医保项目明细
ClassMethod GetINTIM(id As %String)
{
	n (id)
	q:id="" 100
	;s ^CACHETEMP("INSUDIC",$j,code)=id
	s s=$g(^DHCINTIM(id))
	;s code=$p(s,"^",3)
	s code=id
	q:code="" 101
	s INTIMsfdlbm=$p(s,"^",1)
	s fpdesc=##class(web.INSUFPCtl).QueryByCode(INTIMsfdlbm)
	s s=s_"^"_fpdesc
	i $d(^CACHETEMP("INSUDIC",$j,code))=0 d
	.s ^CACHETEMP("INSUDIC",$j,code)=id_"^"_s
	.s ^CACHETEMP("INSUDIC",$j)=$g(^CACHETEMP("INSUDIC",$j))+1
	q 0
}

/// 取医保收费项目
ClassMethod GetTar(xCode As %String, JString As %Integer)
{
	;n (xCode)
	;s outString=""
	;s xCode=$o(^CACHETEMP("INSUDIC",$j,xCode))
	;s:xCode'="" outString=$g(^CACHETEMP("INSUDIC",$j,xCode))
	;q outString
	;
	
	n (xCode,JString)
	s outString=""
	s xCode=$o(^CACHETEMP("INSUDIC",JString,xCode))
	s:xCode'="" outString=$g(^CACHETEMP("INSUDIC",JString,xCode))
	q outString
}

/// 取医保收费项目明细
ClassMethod GetInsuDetail(InsuId As %String)
{
	n (InsuId)
	q:InsuId="" ""
	;s obj=##class(User.INSUTarItems).%OpenId(InsuId)
	s s=$g(^DHCINTIM(InsuId))
	q s
}

ClassMethod Save(InString As %String)
{
   ;n (InString)
	i InString="" q 0
	s InString=InString_"^"    
	s obj=##class(User.INSUTarItems).%New()
	/*  ///  大同
	s obj.INTIMsfxmbm="DT"                //医保类别
	s obj.INTIMxmbm=$p(InString,"^",2)    //收费项目编码
	s obj.INTIMxmmc=$p(InString,"^",3)    //收费项目名称
	s obj.INTIMjx="" ;$p(InString,"^",4)      //剂型
	s obj.INTIMdw=$p(InString,"^",5)      //单位
	s obj.INTIMgg=$p(InString,"^",4)              //规格
	s obj.INTIMbzjg=+$p(InString,"^",6)   //医保标准价格
	s obj.INTIMsfdlbm=$p(InString,"^",7)  //发票分类
	s obj.INTIMxmrj=$p(InString,"^",8)    //拼音码
	s obj.INTIMzfbl1=0                    //自付比例
	s obj.INTIMtjdm=""                    //收费项目等级
	s obj.INTIMflzb1=$p(InString,"^",10)  //是否医保项目
	s obj.INTIMflzb2=$p(InString,"^",11)  //有效标志
	*/
	///   韶关
	//s obj.INTIMsfxmbm="SG"	
	//s obj.INTIMxmbm=$p(InString,"^",2)    //收费项目编码
	//s obj.INTIMxmmc=$p(InString,"^",3)    //收费项目名称
	//;s obj.INTIMjx="" ;$p(InString,"^",4) 
	//s obj.INTIMdw=$p(InString,"^",5)      //单位
	//s obj.INTIMgg=$p(InString,"^",4)      //规格
	//;s obj.INTIMbzjg=+$p(InString,"^",6)   //医保标准价格
	//s obj.INTIMsfdlbm=$p(InString,"^",6)  //发票分类
	//s obj.INTIMxmrj=$p(InString,"^",1)    //拼音码
	//s obj.INTIMzfbl1=+$p(InString,"^",8) //自付比例
	//s obj.INTIMxmlb=$p(InString,"^",9)   //收费项目等级
	//s obj.INTIMtjdm=$p(InString,"^",10)   //收费项目等级
	//s obj.INTIMflzb1=$p(InString,"^",7)  //是否医保项目
	//s obj.INTIMflzb2="Y"  //有效标志
	
	
	///  宁波
	  s obj.INTIMsfdlbm=$p(InString,"^",2)  //大类编码
      s obj.INTIMsfxmbm="NBB"				//宁波医保
	  s obj.INTIMxmbm=$p(InString,"^",3)    //医保编码
	  s obj.INTIMxmmc=$p(InString,"^",4)    //医保名称
	  s obj.INTIMxmrj=$p(InString,"^",5)    //助记符
	  s obj.INTIMxmlb=$p(InString,"^",6)    //甲乙类
	  s obj.INTIMjx=$p(InString,"^",7)	    //剂型
	  s obj.INTIMgg=$p(InString,"^",8)      //规格
	  s obj.INTIMdw=$p(InString,"^",9)      //单位
	  
	d obj.%Save()
	s id=obj.%Id()
	d obj.%Close()
	;s index=""""_$p(InString,"^",2)_""""
	;s ^aa(index)=""
	;s ^DHCINTIM(0,"CODE",index,id)=""
	q id
}

/// 发票保存
ClassMethod Savefp(StringParm As %String)
{
	n (StringParm)
	i StringParm="" q 0
	s StringParm=StringParm_"^"
	s obj=##class(User.INSUFpwh).%New()
	s obj.Code=$p(StringParm,"^",1)    //代码
	s obj.Name=$p(StringParm,"^",2)    //名称
	s obj.Fpfl=$p(StringParm,"^",3)    //发票分类
	s obj.Lb=$p(StringParm,"^",4)      //类别
	d obj.%Save()
	s id=obj.%Id()
	d obj.%Close()
	q id
}

ClassMethod SaveINTIM(InString As %String)
{
   
    n (InString)
	i InString="" q 0
	s rowid=$p(InString,"^",1)	  
	s:rowid="" obj=##class(User.INSUTarItems).%New()
	s:rowid'="" obj=##class(User.INSUTarItems).%OpenId(rowid)
    s obj.INTIMsfdlbm=$p(InString,"^",2)
    s obj.INTIMsfxmbm=$p(InString,"^",3)
    s obj.INTIMxmbm=$p(InString,"^",4)
    s obj.INTIMxmmc=$p(InString,"^",5)
    s obj.INTIMxmrj=$p(InString,"^",6)
    s obj.INTIMtxbz=$p(InString,"^",7)
    s obj.INTIMxmlb=$p(InString,"^",8)
    s obj.INTIMjx=$p(InString,"^",9)
    s obj.INTIMgg=$p(InString,"^",10)
    s obj.INTIMdw=$p(InString,"^",11)
    s obj.INTIMyf=$p(InString,"^",12)
    s obj.INTIMyl=$p(InString,"^",13)
    s obj.INTIMsl=$p(InString,"^",14)
    s obj.INTIMpzwh=$p(InString,"^",15)
    s obj.INTIMbzjg=$p(InString,"^",16)
    s obj.INTIMsjjg=$p(InString,"^",17)
    s obj.INTIMzgxj=$p(InString,"^",18)
    s obj.INTIMzfbl1=$p(InString,"^",19)
    s obj.INTIMzfbl2=$p(InString,"^",20)
    s obj.INTIMzfbl3=$p(InString,"^",21)
    s obj.INTIMbpxe=$p(InString,"^",22)
    s obj.INTIMbz=$p(InString,"^",23)
    s obj.INTIMtjdm=$p(InString,"^",24)
    s obj.INTIMflzb1=$p(InString,"^",25)
    s obj.INTIMflzb2=$p(InString,"^",26)
    s obj.INTIMflzb3=$p(InString,"^",27)
    s obj.INTIMflzb4=$p(InString,"^",28)
    s obj.INTIMflzb5=$p(InString,"^",29)
    s obj.INTIMflzb6=$p(InString,"^",30)
    s obj.INTIMflzb7=$p(InString,"^",31)
    s obj.INTIMspmc=$p(InString,"^",32)
    s obj.INTIMspmcrj=$p(InString,"^",33)
    s obj.INTIMljzfbz=$p(InString,"^",34)
    s obj.INTIMyyjzjbz=$p(InString,"^",35)
    s obj.INTIMyysmbm=$p(InString,"^",36)
    s obj.INTIMfplb=$p(InString,"^",37)
    s obj.INTIMDicType=$p(InString,"^",38)
    d obj.%Save()
	s id=obj.%Id()
	d obj.%Close()
	q id
}

ClassMethod AddIndex()
{
	s id="0"
	f  s id=$o(^DHCINTIM(id)) q:id=""  d
	.s s=$g(^DHCINTIM(id))
	.s code=$p(s,"^",3)
	.s ^DHCINTIM(0,"CODE",code,id)=""
	;s s=$g(^DHCINTIM(2))
	;s code=$p(s,"^",3)
	;w !,code
	;s ^DHCINTIM(0,"CODE",code,2)=""
	q
}

}
