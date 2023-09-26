Import SQLUser

Class web.INSUahInfoCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 92;

/// 插入数据
ClassMethod Insert(Instring As %String)
{
	s id=$p(Instring,"^",1)
	s InsuNo=$ZCVT($p(Instring,"^",12),"U")
	i id'=""{
	    s obj=##class(User.INSUahInfo).%OpenId(id)
	    }
	else{
		i $d(^DHCINSUahInfoI("IndexOfInsuNo",InsuNo)){
			s id=$o(^DHCINSUDicDataI("IndexOfInsuNo",InsuNo,id))
			s obj=##class(User.INSUahInfo).%OpenId(id)
			}
		else{
			s obj=##class(User.INSUahInfo).%New()
			}
		}
	s obj.IndexNo=$p(Instring,"^",2)
	s obj.InsuBorth=$p(Instring,"^",3)
	s obj.InsuCode=$p(Instring,"^",4)
	s obj.InsuCompany=$p(Instring,"^",5)
	s obj.InsuDemo=$p(Instring,"^",6)
	s obj.InsuHomeDrr=$p(Instring,"^",7)
	s obj.InsuHospital=$p(Instring,"^",8)
	s obj.InsuID=$p(Instring,"^",9)
	s obj.InsuJudgeDate=$p(Instring,"^",10)
	s obj.InsuName=$p(Instring,"^",11)
	s obj.InsuNo=$ZCVT($p(Instring,"^",12),"U")
	s obj.InsuPatType=$p(Instring,"^",13)
	s obj.InsuSex=$p(Instring,"^",14)
	s obj.InsuSpe=$p(Instring,"^",15)
	s obj.InsuTel=$p(Instring,"^",16)	
	d obj.%Save()
    s id=obj.%Id()
    d obj.%Close()
    q id
}

/// 按照医保号码查询
ClassMethod QueryByInsuNo(InsuNo As %String)
{
	n (InsuNo)
	k ^CacheTemp("INSUinfo",$j)
	s err=""
	;s InsuNo=$ZCVT(InsuNo,"U")
	i $d(^DHCINSUahInfoI("IndexOfInsuNo",InsuNo)){
		s id=""
		s id=$o(^DHCINSUahInfoI("IndexOfInsuNo",InsuNo,id))
		w !,"id="_id
		s err=..GetById(id)
		k ^CacheTemp("INSUinfo",$j)
		}	
    q err
}

/// ;按照姓名查询
ClassMethod QueryByName(Name As %String)
{
	;n (Name)
	k ^CacheTemp("INSUinfo",$j)
	;s Name=$ZCVT(Name,"U")
	s:$d(^DHCINSUahInfoI("IndexOfName",Name)) err=..SelectName(Name)
	s desc=Name
	f  s desc=$O(^DHCINSUahInfoI("IndexOfName",desc))  q:(desc="")!(desc'[Name)  d
	.;w !,"desc="_desc
	.s err=..SelectName(desc)
    q $j
}

/// 按照姓名查找
ClassMethod SelectName(Name As %String)
{
	;n (Name)
    s id=""
    f  s id=$O(^DHCINSUahInfoI("IndexOfName",Name,id))  q:id=""  d
    .w !,"id="_id
    .s err=..GetById(id)
    q 0
}

/// 按照医保号码查询
ClassMethod GetById(id As %String)
{
	q:id="" ""
	s obj=##class(User.INSUahInfo).%OpenId(id)
	s sIndexNo=obj.IndexNo
	s sInsuBorth=obj.InsuBorth
	s sInsuCode=obj.InsuCode 
	s sInsuCompany=obj.InsuCompany
	s sInsuDemo=obj.InsuDemo
	s sInsuHomeDrr=obj.InsuHomeDrr 
	s sInsuHospital=obj.InsuHospital
	s sInsuID=obj.InsuID
	s sInsuJudgeDate=obj.InsuJudgeDate
	s sInsuName=obj.InsuName
	s sInsuNo=obj.InsuNo
	s sInsuPatType=obj.InsuPatType
	s sInsuSex=obj.InsuSex
	s sInsuSpe=obj.InsuSpe 
	s temp=""
	f i=1:1:$l(sInsuSpe,"||") d
	.s speCode=$p(sInsuSpe,"||",i)
	.i speCode'="" d
	..s err=##class(web.INSUDicDataCtl).QueryByCode("SKC516",+speCode)
	..s err=$p(err,"^",4)
	..s:temp'="" temp=temp_","_err
	..s:temp="" temp=err
	s sInsuTel=obj.InsuTel
	d obj.%Close()
	s outString=id_"^"_sIndexNo_"^"_sInsuBorth_"^"_sInsuCode_"^"_sInsuCompany_"^"_sInsuDemo_"^"_sInsuHomeDrr_"^"_sInsuHospital_"^"_sInsuID_"^"_sInsuJudgeDate_"^"_sInsuName_"^"_sInsuNo_"^"_sInsuPatType_"^"_sInsuSex_"^"_sInsuSpe_"^"_sInsuTel_"^"_temp
	s ^CacheTemp("INSUinfo",$j,sInsuNo)=outString
	q outString
}

}
