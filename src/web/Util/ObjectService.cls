Class web.Util.ObjectService Extends %RegisteredObject
{

/// @author: wanghc
/// @param: src 	%Library.RegisteredObject
/// @param: dim	 	%Library.RegisteredObject
/// @desc:  src对象的属性拷贝到dim对象中
ClassMethod Copy(ByRef src As %Library.RegisteredObject, ByRef dim As %Library.RegisteredObject) [ ProcedureBlock = 0 ]
{
	n (src,dim)
	Set POClassName = src.%ClassName(1) ;$Classname(src)
	Set ROClassName = dim.%ClassName(1) ;$Classname(dim)
	s pro=""
	do {
		s pro =  $o(^oddCOM(ROClassName,"a",pro)) d ##class(%Library.CompiledProperty).PropertyInfoClose()
		q:pro=""
		if (pro'["%")&&($d(^oddCOM(POClassName,"a",pro))'=0){
			if ($g(^oddCOM(POClassName,"a",pro,"m","GetObjectId",44))=1){
				s @("val=src."_pro_"GetObjectId()")
			}else{
				s @("val=src."_pro)
			}
			if ($g(^oddCOM(ROClassName,"a",pro,"m","SetObjectId",44))=1){
				d @("dim."_pro_"SetObjectId(val)")
			}else{
				s @("dim."_pro_"=val")
			}
		}
	}while(1)	
	q $$$OK
}

}
