Class User.DHCNurSkinPPD Extends %Persistent
{

/// 患者
Property TestAdmDr As %String(TRUNCATE = 1);

/// 记录人
Property RecUser As %String(TRUNCATE = 1);

/// 记录日期
Property TestDate As %Library.Date(FORMAT = 1);

/// 记录时间
Property TestTime As %Library.Time;

/// 指向的医嘱
Property TestOeoriDr As %String(TRUNCATE = 1);

/// 皮肤硬结1
Property TestSkinSityOne As %String(TRUNCATE = 1);

/// 皮肤硬结2
Property TestSkinSityTwo As %String(TRUNCATE = 1);

/// 局部水泡1
Property TestSkinVclOne As %String(TRUNCATE = 1);

/// 局部水泡2
Property TestSkinVclTwo As %String(TRUNCATE = 1);

/// 红肿1
Property TestSkinSwoOne As %String(TRUNCATE = 1);

/// 红肿2
Property TestSkinSwoTwo As %String(TRUNCATE = 1);

/// 坏死
Property TestSkinNecrosis As %String(TRUNCATE = 1);

/// 淋巴管炎
Property TestSkinInflam As %String(TRUNCATE = 1);

/// 单个
Property TestSkinSing As %String(TRUNCATE = 1);

/// 散在
Property TestSkinSpora As %String(TRUNCATE = 1);

/// PPD结果
Property PPDResult As %String(TRUNCATE = 1);

/// 双圈
Property TestSkinDoubleloop As %String(TRUNCATE = 1);

/// 无局部水泡
Property TestSkinVclNoHave As %String(DISPLAYLIST = ",是,否", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N");

/// 无红肿
Property TestSkinSwoNoHave As %String(DISPLAYLIST = ",是,否", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N");

/// 无皮肤硬结
Property TestSkinSityNoHave As %String(DISPLAYLIST = ",是,否", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N");

Index ResultDateTime On (TestDate, TestTime);

Index ResultAdmDT On (TestAdmDr, TestDate, TestTime);

Index ResultOeoriDr On TestOeoriDr;

ClassMethod Save(id, parr As %String) As %String
{
	;s ^scv1("ppd")=parr
	s l=$L(parr,"^")
	for i=1:1:l
	{
		s itm=$P(parr,"^",i)
		if itm="" continue
		s name=$P(itm,"|")
		s val=$P(itm,"|",2)
		s tmp(name)=val
	}
	if $D(tmp("TestOeoriDr")) {
		s tmp("TestOeoriDr")=$TR($G(tmp("TestOeoriDr")),"!!","||")
	}
	q:$g(tmp("TestOeoriDr"))="" ""
	s ret=..IfSkinOrd(tmp("TestOeoriDr"))
	q:ret'="0" ret
	b //123
	if $G(id)'="" {
		s a=##class(User.DHCNurSkinPPD).%OpenId(id)
	}
	else
	{
			s a=##class(User.DHCNurSkinPPD).%New(id)
		}
    if $D(tmp("TestAdmDr")) s a.TestAdmDr=tmp("TestAdmDr")  //患者
    if $D(tmp("RecUser")) s a.RecUser=tmp("RecUser")           //记录人
	if $D(tmp("TestDate")) s a.TestDate=..TransDate($G(tmp("TestDate")))  //记录日期
	if $D(tmp("TestTime")) s a.TestTime=..TransTime($G(tmp("TestTime")))   //记录时间
	if $D(tmp("TestOeoriDr")) s a.TestOeoriDr=tmp("TestOeoriDr")            //医嘱id
	
	if $D(tmp("TestSkinSityOne")) s a.TestSkinSityOne=tmp("TestSkinSityOne")   //皮肤硬结1
	if $D(tmp("TestSkinSityTwo")) s a.TestSkinSityTwo=tmp("TestSkinSityTwo")   //皮肤硬结2
	if $D(tmp("TestSkinVclOne")) s a.TestSkinVclOne=tmp("TestSkinVclOne")     //局部水泡1
	if $D(tmp("TestSkinVclTwo")) s a.TestSkinVclTwo=tmp("TestSkinVclTwo")     //局部水泡2
	if $D(tmp("TestSkinSwoOne")) s a.TestSkinSwoOne=tmp("TestSkinSwoOne")     //红肿1
	if $D(tmp("TestSkinSwoTwo")) s a.TestSkinSwoTwo=tmp("TestSkinSwoTwo")     //红肿2
	if $D(tmp("TestSkinNecrosis")) s a.TestSkinNecrosis=tmp("TestSkinNecrosis")  //坏死
	
	if $D(tmp("TestSkinInflam")) s a.TestSkinInflam=tmp("TestSkinInflam")     //淋巴管炎
	if $D(tmp("TestSkinDoubleloop")) s a.TestSkinDoubleloop=tmp("TestSkinDoubleloop")     //双圈
	
	if $D(tmp("TestSkinSing")) s a.TestSkinSing=tmp("TestSkinSing")     //单个
	if $D(tmp("TestSkinSpora")) s a.TestSkinSpora=tmp("TestSkinSpora")     //散在	
	if $D(tmp("PPDResult")) s a.PPDResult=tmp("PPDResult")     //结果
	
	if $D(tmp("TestSkinVclNoHave")) s a.TestSkinVclNoHave=tmp("TestSkinVclNoHave")     //无局部水泡
	if $D(tmp("TestSkinSwoNoHave")) s a.TestSkinSwoNoHave=tmp("TestSkinSwoNoHave")     //无红肿
	if $D(tmp("TestSkinSityNoHave")) s a.TestSkinSityNoHave=tmp("TestSkinSityNoHave")     //无皮肤硬结
	
	///if $D(tmp("TestBatch")) s a.TestBatch=tmp("TestBatch")    //批号
	d a.%Save()
	//q a.%Id()
	q 0
}

ClassMethod TransDate(Date) As %String
{
	if (Date'="") {
		i Date["/" q $zdh(Date,4)
		i Date["-" q $zdh(Date,3)
		q Date
	}
	else {
		q +$h
	}
}

/// 转换数字格式时间
ClassMethod TransTime(Time) As %String
{
	if (Time'="") {
		i $l(Time,":")=2 q $zth(Time,2)
		i $l(Time,":")=3 q $zth(Time)
		q Time
	}
	else {
		q $p($h,",",2)
	}
}

ClassMethod GetIdByAdm(Adm, OeoriDr) As %String
{
	q ""
}

// 判断是否是皮试医嘱，返回0是，否则不是

/// w ##class(User.DHCNurSkinPPD).IfSkinOrd("7||12")
ClassMethod IfSkinOrd(oeoreId) As %String
{
	q:oeoreId="" ""
	s oeordId=+oeoreId
    s oeoriSub=$p(oeoreId,"||",2)
    s skinTestFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,5)),"^",2)
    s actId=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",21)
    s actCode=""
    i actId'="" s actCode=$p(^OEC("ACT",actId),"^",1)
    s skinUseMethod = ##class(DHCDoc.Interface.Inside.Service).CheckOrdIsSkinInstr(oeordId_"||"_oeoriSub)
    i (skinTestFlag'="Y")&(actCode'="YY")&(actCode'="MS")&(skinUseMethod'=1) q "非皮试医嘱!"
 
	q 0
}

ClassMethod Delete(idstr) As %String
{
	q:idstr="" ""
	s num=$l(idstr,"^")
	f i=1:1:num
	{
		s id=$p(idstr,"^",i)
		d ##class(User.DHCNurSkinPPD).%DeleteId(id)
	}
   q 0
}

/// ##class(User.DHCNurSkinPPD).GetAsArrayOfDataTypes()
Method GetAsArrayOfDataTypes() As %ArrayOfDataTypes [ CodeMode = objectgenerator ]
{
	// Only create this method when compiling other classes this is extended upon
	If (%compiledclass.Name = "User.DHCNurSkinPPD")
	 {
		
		// Wrap the object in an array
		Do %code.WriteLine(" Set array = ##class(%ArrayOfDataTypes).%New()")
	
		// Rip through each property of the class.. that does not start with a %
		// Insert each property as a key=>value pair in the array
		For i = 1:1:%compiledclass.Properties.Count()
		 {
	        Set prop = %compiledclass.Properties.GetAt(i).Name
	        IF ($EXTRACT(prop) '= "%")
	         {
		        Do %code.WriteLine(" Do array.SetAt(.."_prop_","""_prop_""")")
	        }
	    }
    
	    // Return an %ArrayOfDataTypes representation of the object
	    Do %code.WriteLine(" Quit array")
	}
}

Storage Default
{
<Data name="DHCNurSkinPPDDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestAdmDr</Value>
</Value>
<Value name="3">
<Value>RecUser</Value>
</Value>
<Value name="4">
<Value>TestDate</Value>
</Value>
<Value name="5">
<Value>TestTime</Value>
</Value>
<Value name="6">
<Value>TestOeoriDr</Value>
</Value>
<Value name="7">
<Value>TestSkinSityOne</Value>
</Value>
<Value name="8">
<Value>TestSkinSityTwo</Value>
</Value>
<Value name="9">
<Value>TestSkinVclOne</Value>
</Value>
<Value name="10">
<Value>TestSkinVclTwo</Value>
</Value>
<Value name="11">
<Value>TestSkinSwoOne</Value>
</Value>
<Value name="12">
<Value>TestSkinSwoTwo</Value>
</Value>
<Value name="13">
<Value>TestSkinNecrosis</Value>
</Value>
<Value name="14">
<Value>TestSkinInflam</Value>
</Value>
<Value name="15">
<Value>TestSkinSing</Value>
</Value>
<Value name="16">
<Value>TestSkinSpora</Value>
</Value>
<Value name="17">
<Value>PPDResult</Value>
</Value>
<Value name="18">
<Value>TestSkinDoubleloop</Value>
</Value>
<Value name="19">
<Value>TestSkinVclNoHave</Value>
</Value>
<Value name="20">
<Value>TestSkinSwoNoHave</Value>
</Value>
<Value name="21">
<Value>TestSkinSityNoHave</Value>
</Value>
</Data>
<DataLocation>^User.DHCNurSkinPPDD</DataLocation>
<DefaultData>DHCNurSkinPPDDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCNurSkinPPDD</IdLocation>
<IndexLocation>^User.DHCNurSkinPPDI</IndexLocation>
<StreamLocation>^User.DHCNurSkinPPDS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
