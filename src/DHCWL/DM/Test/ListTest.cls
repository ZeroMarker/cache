Class DHCWL.DM.Test.ListTest Extends %RegisteredObject
{

// d ##class(DHCWL.DM.Test.ListTest).Test()

ClassMethod Test()
{
	s list=$lb()
	try{
	  f i=1:1:99999{
	    s $list(list,i)=123 ;12
	  }
	}catch(e){
	  w "i="_i,! ;16384
	  ;b ;1
	}
	;b ;0
}

// d ##class(DHCWL.DM.Test.ListTest).Test2()

ClassMethod Test2()
{
	s list=$lb()
	try{
	  f i=1:1:99999{
	    s $list(list,i)=$c(-1) ;12
	  }
	}catch(e){
	  w "i="_i,! ;16384
	  ;b ;1
	}
	;b ;0
}

// d ##class(DHCWL.DM.Test.ListTest).Test3()

ClassMethod Test3()
{
	s list=$lb()
	try{
	  f i=1:1:99999{
	    s $list(list,i)="" ;12
	  }
	}catch(e){
	  w "i="_i,! ;16384
	  ;b ;1
	}
	;b ;0
}

// d ##class(DHCWL.DM.Test.ListTest).Test4()

ClassMethod Test4()
{
	s list=$lb()
	try{
	  f i=1:1:99999{
	    s $list(list,i)=$c(0) ;12
	  }
	}catch(e){
	  w "i="_i,! ;16384
	  ;b ;1
	}
	;b ;0
}

}
