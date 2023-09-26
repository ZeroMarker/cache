Class DHCWL.DM.Test.GlobalTest Extends %RegisteredObject
{

// d ##class(DHCWL.DM.Test.GlobalTest).Test()

ClassMethod Test()
{
	k ^tmplhh
	s numStr=1
	s lb=$lb()
	f i=1:1:((1023)-50){
	  s $list(lb,i)=1
	}
	s numStr=$lts(lb,"")
	w numStr,!
	s ^tmplhh(numStr)=""
}

// d ##class(DHCWL.DM.Test.GlobalTest).StructTest()

ClassMethod StructTest()
{
	s struct(1,"A")=0,struct(1,"B")=0,struct(1,"C")=0,struct(2,"A")=0,struct(2,"B")=0,struct(2,"C")=0,struct(3,"A")=0,struct(3,"B")=0,struct(3,"C")=0
	s struct(4,"A")=0,struct(4,"B")=0,struct(4,"C")=0,struct(5,"A")=0,struct(5,"B")=0,struct(5,"C")=0,struct(6,"A")=0,struct(6,"B")=0,struct(6,"C")=0
	s list=$lb($lb(1,2,3,4),$lb(1,2,3,4),$lb(1,2,3,4),$lb(1,2,3,4),$lb(1,2,3,4),$lb(1,2,3,4))
	s list2=##class(%ListOfObjects).%New()
	s psd=##class(DHCWL.DM.Core.ParsedDimStruct).%New()
	s psd.SN=1
	d list2.Insert(psd)
	s psd=##class(DHCWL.DM.Core.ParsedDimStruct).%New()
	s psd.SN=2
	d list2.Insert(psd)
	s psd=##class(DHCWL.DM.Core.ParsedDimStruct).%New()
	s psd.SN=3
	d list2.Insert(psd)
	s psd=##class(DHCWL.DM.Core.ParsedDimStruct).%New()
	s psd.SN=4
	d list2.Insert(psd)
	s psd=##class(DHCWL.DM.Core.ParsedDimStruct).%New()
	s psd.SN=5
	d list2.Insert(psd)
	s psd=##class(DHCWL.DM.Core.ParsedDimStruct).%New()
	s psd.SN=6
	d list2.Insert(psd)
	s t1=$p($zts,",",2)
	f i=1:1:1000000{
		s j="" f{
			s j=$o(struct(j))
			q:j=""
			s v=struct(j,"A")
			s v=struct(j,"B")
			s v=struct(j,"C")
			s v=$g(struct(j,"D"))
		}
	}
	s t2=$p($zts,",",2)
	w "time:"_(t2-t1),!
	f i=1:1:1000000{
		f j=1:1:$ll(list){
			s v=$lg($lg(list,j),1)
			s v=$lg($lg(list,j),2)
			s v=$lg($lg(list,j),3)
			s v=$lg($lg(list,j),4)
		}
	}
	s t3=$p($zts,",",2)
	w "time:"_(t3-t2),!
	f i=1:1:1000000{
		f j=1:1:list2.Count(){
			s v=list2.GetAt(j).SN
		}
	}
	w "time:"_($p($zts,",",2)-t3),!
}

}
