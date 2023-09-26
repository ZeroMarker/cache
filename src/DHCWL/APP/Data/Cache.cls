Class DHCWL.APP.Data.Cache Extends %RegisteredObject
{

Property dataMap [ MultiDimensional, Private ];

Property size As %Integer [ Private ];

Property OSID As %String [ Private ];

Property storageName As %String [ Private ];

Property propertyMap [ MultiDimensional, Private ];

/*
s c=##class(DHCWL.APP.Data.Cache).Init(,"test","^temp")
s array=2,array(1)="A",array(2)="b"
d c.Set(11,.array)
w c.Get(.array)
d c.Set(10,"A","a")
d c.Set(12,"A","c")
w c.Get("A","b")
*/
ClassMethod Init(initSize As %Integer = 0, osid, storageName) As Cache
{
	s cache=##class(DHCWL.APP.Data.Cache).%New()
	s cache.size=initSize
	s cache.OSID=osid
	s cache.storageName=storageName
	;w "cache.OSID="_cache.OSID,!
	q cache
}

Method Size() [ CodeMode = expression ]
{
..size
}

Method Get(ByRef indexPara) [ CodeMode = objectgenerator ]
{
	d %code.WriteLine(" s indexParaStr=""a(0""")
	;d %code.WriteLine(" b ;1")
	d %code.WriteLine(" f i=1:1:$g(indexPara,0) {")
		d %code.WriteLine(" if i=1 {")
			d %code.WriteLine(" s indexParaStr=..storageName_""(..OSID,$g(indexPara(""_i_""))""")
		d %code.WriteLine(" }else {")
			d %code.WriteLine(" s indexParaStr=indexParaStr_"",$g(indexPara(""_i_""))""")
		d %code.WriteLine(" }")
	d %code.WriteLine(" }")
	d %code.WriteLine(" s indexParaStr=indexParaStr_"")""")
	;d %code.WriteLine(" b ;01")
	d %code.WriteLine(" if ((+$g(indexPara)=1)&&($g(indexPara(1))="""")) {")
		d %code.WriteLine(" s indexParaStr=..storageName_""(..OSID)""")
	d %code.WriteLine(" }")
	;;d %code.WriteLine(" b ;02")
	d %code.WriteLine(" s indexParaValue=$g(@indexParaStr)")
	;d %code.WriteLine(" b ;01")
	d %code.WriteLine(" q $g(indexParaValue)")
	q $$$OK
}

Method Set(value, ByRef indexPara) [ CodeMode = objectgenerator ]
{
	d %code.WriteLine(" s indexParaStr=""a(0""")
	d %code.WriteLine(" f i=1:1:$g(indexPara,0) {")
		d %code.WriteLine(" if i=1 {")
			d %code.WriteLine(" s indexParaStr=..storageName_""(..OSID,$g(indexPara(""_i_""))""")
		d %code.WriteLine(" }else {")
			d %code.WriteLine(" s indexParaStr=indexParaStr_"",$g(indexPara(""_i_""))""")
		d %code.WriteLine(" }")
	d %code.WriteLine(" }")
	d %code.WriteLine(" s indexParaStr=indexParaStr_"")""")
	d %code.WriteLine(" if ('$d(@indexParaStr))  s ..size=..size+1")
	d %code.WriteLine(" s @indexParaStr=value")
	;d %code.WriteLine(" b ;001")
	q $$$OK
}

Method Data(ByRef indexPara) [ CodeMode = objectgenerator ]
{
	d %code.WriteLine(" s indexParaStr=""a(0""")
	d %code.WriteLine(" f i=1:1:$g(indexPara,0) {")
		d %code.WriteLine(" if i=1 {")
			d %code.WriteLine(" s indexParaStr=..storageName_""(..OSID,$g(indexPara(""_i_""))""")
		d %code.WriteLine(" }else {")
			d %code.WriteLine(" s indexParaStr=indexParaStr_"",$g(indexPara(""_i_""))""")
		d %code.WriteLine(" }")
	d %code.WriteLine(" }")
	d %code.WriteLine(" s indexParaStr=indexParaStr_"")""")
	d %code.WriteLine(" q $d(@indexParaStr)")
	d %code.WriteLine(" q indexParaValue")
	q $$$OK
}

Method Order(direction As %Integer = 1, ByRef indexPara) [ CodeMode = objectgenerator ]
{
	d %code.WriteLine(" s indexParaStr=""a(0""")
	d %code.WriteLine(" f i=1:1:$g(indexPara,0) {")
		d %code.WriteLine(" if i=1 {")
			d %code.WriteLine(" s indexParaStr=..storageName_""(..OSID,$g(indexPara(""_i_""))""")
		d %code.WriteLine(" }else {")
			d %code.WriteLine(" s indexParaStr=indexParaStr_"",$g(indexPara(""_i_""))""")
		d %code.WriteLine(" }")
	d %code.WriteLine(" }")
	d %code.WriteLine(" s indexParaStr=indexParaStr_"")""")
	;d %code.WriteLine(" q:'$d(@indexParaStr) """"")
	d %code.WriteLine(" q $o(@indexParaStr,direction)")
	q $$$OK
}

Method Kill(ByRef indexPara) [ CodeMode = objectgenerator ]
{
	d %code.WriteLine(" tstart")
	d %code.WriteLine(" m ..propertyMap=indexPara")
	d %code.WriteLine(" s indexParaStr=""a""")
	d %code.WriteLine(" f i=1:1:$g(indexPara,0) {")
		d %code.WriteLine(" if i=1 {")
			d %code.WriteLine(" s indexParaStr=..storageName_""(..OSID,$g(..propertyMap(""_i_""))""")
		d %code.WriteLine(" }else {")
			d %code.WriteLine(" s indexParaStr=indexParaStr_"",$g(..propertyMap(""_i_""))""")
		d %code.WriteLine(" }")
	d %code.WriteLine(" }")
	d %code.WriteLine(" s indexParaStr=indexParaStr_"")""")
	
	d %code.WriteLine(" s indexParaStr2=""a(0""")
	d %code.WriteLine(" f i=1:1:$g(indexPara,0) {")
		d %code.WriteLine(" if i=1 {")
			d %code.WriteLine(" s indexParaStr2=..storageName_""(..OSID,$g(indexPara(""_i_""))""")
		d %code.WriteLine(" }else {")
			d %code.WriteLine(" s indexParaStr2=indexParaStr2_"",$g(indexPara(""_i_""))""")
		d %code.WriteLine(" }")
	d %code.WriteLine(" }")
	d %code.WriteLine(" s indexParaStr2=indexParaStr2_"")""")
	d %code.WriteLine(" if ((+$g(indexPara)=1)&&($g(indexPara(1))="""")) {")
		d %code.WriteLine(" s indexParaStr2=..storageName_""(..OSID)""")
		d %code.WriteLine(" s indexParaStr=..storageName_""(..OSID)""")
	d %code.WriteLine(" }")
	;d %code.WriteLine(" b ;Kill 2")
	d %code.WriteLine(" if ($d(@indexParaStr2)) {")
		d %code.WriteLine(" k @indexParaStr")
		;d %code.WriteLine(" k @..storageName@(indexParaStr)")
		;d %code.WriteLine(" b ;Kill 2")
	d %code.WriteLine(" }")
	d %code.WriteLine(" k ..propertyMap")
	d %code.WriteLine(" tcommit")
	q $$$OK
}

}
