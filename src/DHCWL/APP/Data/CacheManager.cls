Class DHCWL.APP.Data.CacheManager Extends %RegisteredObject
{

/*
s cm=##class(DHCWL.APP.Data.CacheManager).Init(,6)
d cm.Set(11,"A",1,"c")
d cm.Set(14,"A",6,"a")
d cm.Set(12,"A",3,"b")
d cm.Set(13,"A",0,"d")
w cm.Get("A","b")
w cm.Order(1,"A","")
w cm.Order(-1,"A","")
w cm.Order(1,"A","a")
w cm.Order(-1,"A","a")
w cm.Order(1,"A","b")
w cm.Order(-1,"A","b")

w cm.cacheArray.Count()
*/
Property storageName As %String [ Private ];

Property cacheSize As %Integer [ Private ];

Property size As %Integer [ Private ];

Property cacheArray As %ListOfObjects [ Private ];

Property OSID As %String [ Private ];

Property isGlobal As %Boolean [ Private ];

ClassMethod Init(size As %Integer = 5120, osid, sn) As CacheManager
{
	s cm=##class(DHCWL.APP.Data.CacheManager).%New()
	if +size=0 {
		s size=##class(DHCWL.util.StringUtil).Trim(size)
		s size=1024*(+$e(size,2,$l(size)))
	}
	s sn=##class(DHCWL.util.StringUtil).Trim(sn)
	if $e(sn,1)="^" {
		s cm.isGlobal=1
	}else{
		s sn="..dataMap"
	}
	s cm.storageName=sn
	s cm.cacheSize=size
	s cm.isGlobal=0
	s cm.OSID=osid
	s cm.cacheArray=##Class(%Library.ListOfObjects).%New()
	s cache=##class(DHCWL.APP.Data.Cache).Init(0,osid,sn)
	d cm.cacheArray.Insert(cache)
	s cm.size=0
	q cm
}

Method GetCount() [ CodeMode = expression ]
{
..size
}

Method Order(direction As %Integer = 1, indexPara...) [ CodeMode = objectgenerator ]
{
	d %code.WriteLine(" s byRefPara=$g(indexPara,0)")
	d %code.WriteLine(" f i=1:1:$g(indexPara,0) {")
		d %code.WriteLine(" s byRefPara(i)=indexPara(i)")
	d %code.WriteLine(" }")
	d %code.WriteLine(" k tempArray")
	d %code.WriteLine(" f i=..cacheArray.Count():-1:1 {")
		d %code.WriteLine(" s indexValue=..cacheArray.GetAt(i).Order(direction,.byRefPara)")
		d %code.WriteLine(" continue:indexValue=""""")
		d %code.WriteLine(" s tempArray(indexValue)=""""")
	d %code.WriteLine(" }")
	d %code.WriteLine(" q $o(tempArray(""""),direction)")
	q $$$OK
}

Method Data(indexPara...) [ CodeMode = objectgenerator ]
{
	d %code.WriteLine(" s byRefPara=$g(indexPara,0)")
	d %code.WriteLine(" f i=1:1:$g(indexPara,0) {")
		d %code.WriteLine(" s byRefPara(i)=indexPara(i)")
	d %code.WriteLine(" }")
	d %code.WriteLine(" s flag=0")
	d %code.WriteLine(" f i=..cacheArray.Count():-1:1 {")
		d %code.WriteLine(" if (..cacheArray.GetAt(i).Data(.byRefPara)){")
			d %code.WriteLine(" s flag=i")
			d %code.WriteLine(" q")
		d %code.WriteLine(" }")
	d %code.WriteLine(" }")
	;d %code.WriteLine(" b ;0")
	d %code.WriteLine(" if flag'=0 {")
		d %code.WriteLine(" q ..cacheArray.GetAt(flag).Data(.byRefPara)")
	d %code.WriteLine(" }else {")
		d %code.WriteLine(" q 0")
	d %code.WriteLine(" }")
	q $$$OK
}

Method Get(indexPara...) [ CodeMode = objectgenerator ]
{
	d %code.WriteLine(" s byRefPara=$g(indexPara,0)")
	d %code.WriteLine(" f i=1:1:$g(indexPara,0) {")
		d %code.WriteLine(" s byRefPara(i)=indexPara(i)")
	d %code.WriteLine(" }")
	d %code.WriteLine(" s flag=0")
	d %code.WriteLine(" f i=..cacheArray.Count():-1:1 {")
		d %code.WriteLine(" if (..cacheArray.GetAt(i).Data(.byRefPara)){")
			d %code.WriteLine(" s flag=i")
			d %code.WriteLine(" q")
		d %code.WriteLine(" }")
	d %code.WriteLine(" }")
	;d %code.WriteLine(" b ;0")
	d %code.WriteLine(" if flag'=0 {")
		d %code.WriteLine(" q ..cacheArray.GetAt(flag).Get(.byRefPara)")
	d %code.WriteLine(" }else {")
		d %code.WriteLine(" q """"")
	d %code.WriteLine(" }")
	q $$$OK
}

Method Set(value = "", indexPara...) [ CodeMode = objectgenerator ]
{
	d %code.WriteLine(" s byRefPara=$g(indexPara,0)")
	d %code.WriteLine(" f i=1:1:$g(indexPara,0) {")
		d %code.WriteLine(" s byRefPara(i)=indexPara(i)")
	d %code.WriteLine(" }")
	d %code.WriteLine(" s flag=0")
	d %code.WriteLine(" f i=..cacheArray.Count():-1:1 {")
		d %code.WriteLine(" if (..cacheArray.GetAt(i).Get(.byRefPara)){")
			d %code.WriteLine(" s flag=i")
			d %code.WriteLine(" q")
		d %code.WriteLine(" }")
	d %code.WriteLine(" }")
	d %code.WriteLine(" if (flag'=0) {")
		d %code.WriteLine(" d ..cacheArray.GetAt(flag).Set(value,.byRefPara)")
	d %code.WriteLine(" }else {")
		d %code.WriteLine(" s ..size=..size+1")
		d %code.WriteLine(" if ((..isGlobal=0)&&((..cacheArray.Count()=0)||(..cacheArray.GetAt(..cacheArray.Count()).Size()>=..cacheSize))) {")
			d %code.WriteLine(" s cache=##class(DHCWL.APP.Data.Cache).Init(0,..OSID,..storageName)")
			d %code.WriteLine(" d ..cacheArray.Insert(cache)")
			;d %code.WriteLine(" w ..cacheArray.Count(),!")
		d %code.WriteLine(" }else {")
			d %code.WriteLine(" s cache=..cacheArray.GetAt(..cacheArray.Count())")
		d %code.WriteLine(" }")
		d %code.WriteLine(" d cache.Set(value,.byRefPara)")
	d %code.WriteLine(" }")
	
	q $$$OK
}

Method Update(ByRef indexDataArrayNew, ByRef indexDataArrayOld, value = "") As %Status [ CodeMode = objectgenerator ]
{
	;d %code.WriteLine(" b ;1")
	d %code.WriteLine(" if ..cacheArray.Count()=0 {")
		d %code.WriteLine(" s cache=##class(DHCWL.APP.Data.Cache).Init(0,..OSID,..storageName)")
		d %code.WriteLine(" d ..cacheArray.Insert(cache)")
	d %code.WriteLine(" }")
	d %code.WriteLine(" s flag=0")
	;d %code.WriteLine(" b ;0")
	d %code.WriteLine(" f i=..cacheArray.Count():-1:1 {")
		d %code.WriteLine(" if (..cacheArray.GetAt(i).Data(.indexDataArrayOld)){")
			d %code.WriteLine(" s oldValue=..cacheArray.GetAt(i).Get(.indexDataArrayOld)")
			;d %code.WriteLine(" w ..cacheArray.GetAt(i).Data(.indexDataArrayOld),!")
			;d %code.WriteLine(" b ;1")
			d %code.WriteLine(" d ..cacheArray.GetAt(i).Kill(.indexDataArrayOld)")
			d %code.WriteLine(" if value="""" s value=oldValue")
			;d %code.WriteLine(" b ;2")
			d %code.WriteLine(" d ..cacheArray.GetAt(i).Set(value,.indexDataArrayNew)")
			d %code.WriteLine(" s flag=1")
		d %code.WriteLine(" }")
	d %code.WriteLine(" }")
	d %code.WriteLine(" if flag=0 {")
		;d %code.WriteLine(" s ..ID=..ID+1")
		d %code.WriteLine(" if ((..isGlobal=0)&&((..cacheArray.Count()=0)||(..cacheArray.GetAt(..cacheArray.Count()).Size()>=..cacheSize))) {")
			d %code.WriteLine(" s cache=##class(DHCWL.APP.Data.Cache).Init(0..OSID,..storageName)")
			d %code.WriteLine(" d ..cacheArray.Insert(cache)")
		d %code.WriteLine(" }")
		d %code.WriteLine(" d ..cacheArray.GetAt(..cacheArray.Count()).Set(value,.indexDataArrayNew)")
		;d %code.WriteLine(" b ;1")
	d %code.WriteLine(" }")
	;d %code.WriteLine(" b ;1")
}

Method Delete(indexPara...) As %Status [ CodeMode = objectgenerator ]
{
	d %code.WriteLine(" s byRefPara=$g(indexPara,0)")
	d %code.WriteLine(" f i=1:1:$g(indexPara,0) {")
		d %code.WriteLine(" s byRefPara(i)=indexPara(i)")
	d %code.WriteLine(" }")
	d %code.WriteLine(" s flag=0")
	d %code.WriteLine(" f i=..cacheArray.Count():-1:1 {")
		d %code.WriteLine(" if (..cacheArray.GetAt(i).Get(.byRefPara)){")
			d %code.WriteLine(" s flag=i")
			d %code.WriteLine(" q")
		d %code.WriteLine(" }")
	d %code.WriteLine(" }")
	;d %code.WriteLine(" w flag,!")
	d %code.WriteLine(" if ((flag'=0)) {")
		d %code.WriteLine(" d ..cacheArray.GetAt(flag).Kill(.byRefPara)")
		d %code.WriteLine(" s:..size>0 ..size=..size-1")
		d %code.WriteLine(" q $$$OK")
	d %code.WriteLine(" }")
	;d %code.WriteLine(" b ;010")
	d %code.WriteLine(" if ((+$g(byRefPara)=1)&&($g(byRefPara(1))="""")){")
		d %code.WriteLine(" f i=..cacheArray.Count():-1:1 {")
			d %code.WriteLine(" d ..cacheArray.GetAt(i).Kill(.byRefPara)")
			;d %code.WriteLine(" b ;011")
		d %code.WriteLine(" }")
	d %code.WriteLine(" }")
	d %code.WriteLine(" q $$$OK")
	q $$$OK
}

Method PriDeleteByArrayPara(ByRef byRefPara = "") As %Status [ CodeMode = objectgenerator ]
{
	d %code.WriteLine(" s flag=0")
	;d %code.WriteLine(" s byRefPara=$o(byRefPara,"""")")
	d %code.WriteLine(" f i=..cacheArray.Count():-1:1 {")
		d %code.WriteLine(" if (..cacheArray.GetAt(i).Get(.byRefPara)){")
			d %code.WriteLine(" s flag=i")
			d %code.WriteLine(" q")
		d %code.WriteLine(" }")
	d %code.WriteLine(" }")
	;d %code.WriteLine(" w flag,!")
	d %code.WriteLine(" if ((flag'=0)) {")
		d %code.WriteLine(" d ..cacheArray.GetAt(flag).Kill(.byRefPara)")
		d %code.WriteLine(" s:..size>0 ..size=..size-1")
		d %code.WriteLine(" q $$$OK")
	d %code.WriteLine(" }")
	;d %code.WriteLine(" b ;010")
	d %code.WriteLine(" if ((+$g(byRefPara)=1)&&($g(byRefPara(1))="""")){")
		d %code.WriteLine(" f i=..cacheArray.Count():-1:1 {")
			d %code.WriteLine(" d ..cacheArray.GetAt(i).Kill(.byRefPara)")
			;d %code.WriteLine(" b ;011")
		d %code.WriteLine(" }")
	d %code.WriteLine(" }")
	d %code.WriteLine(" q $$$OK")
	q $$$OK
}

Method PriGetByArrayPara(ByRef indexPara) [ CodeMode = objectgenerator ]
{
	d %code.WriteLine(" s byRefPara=$g(indexPara,0)")
	d %code.WriteLine(" f i=1:1:$g(indexPara,0) {")
		d %code.WriteLine(" s byRefPara(i)=indexPara(i)")
	d %code.WriteLine(" }")
	d %code.WriteLine(" s flag=0")
	d %code.WriteLine(" f i=..cacheArray.Count():-1:1 {")
		d %code.WriteLine(" if (..cacheArray.GetAt(i).Data(.byRefPara)){")
			d %code.WriteLine(" s flag=i")
			d %code.WriteLine(" q")
		d %code.WriteLine(" }")
	d %code.WriteLine(" }")
	;d %code.WriteLine(" b ;0")
	d %code.WriteLine(" if flag'=0 {")
		d %code.WriteLine(" q ..cacheArray.GetAt(flag).Get(.byRefPara)")
	d %code.WriteLine(" }else {")
		d %code.WriteLine(" q """"")
	d %code.WriteLine(" }")
	q $$$OK
}

Method PrivateSetByArrayPara(value = "", ByRef byRefPara) [ CodeMode = objectgenerator ]
{
	d %code.WriteLine(" s flag=0")
	d %code.WriteLine(" f i=..cacheArray.Count():-1:1 {")
		d %code.WriteLine(" if (..cacheArray.GetAt(i).Get(.byRefPara)){")
			d %code.WriteLine(" s flag=i")
			d %code.WriteLine(" q")
		d %code.WriteLine(" }")
	d %code.WriteLine(" }")
	d %code.WriteLine(" if (flag'=0) {")
		d %code.WriteLine(" d ..cacheArray.GetAt(flag).Set(value,.byRefPara)")
	d %code.WriteLine(" }else {")
		d %code.WriteLine(" s ..size=..size+1")
		d %code.WriteLine(" if ((..isGlobal=0)&&((..cacheArray.Count()=0)||(..cacheArray.GetAt(..cacheArray.Count()).Size()>=..cacheSize))) {")
			d %code.WriteLine(" s cache=##class(DHCWL.APP.Data.Cache).Init(0,..OSID,..storageName)")
			d %code.WriteLine(" d ..cacheArray.Insert(cache)")
		d %code.WriteLine(" }else {")
			d %code.WriteLine(" s cache=..cacheArray.GetAt(..cacheArray.Count())")
		d %code.WriteLine(" }")
		d %code.WriteLine(" d cache.Set(value,.byRefPara)")
	d %code.WriteLine(" }")
	
	q $$$OK
}

}
