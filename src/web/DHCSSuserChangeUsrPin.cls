Include webimport

IncludeGenerator webimport

Class web.DHCSSuserChangeUsrPin Extends %RegisteredObject [ ProcedureBlock ]
{

ClassMethod ChangeUserPin(itmjs As %Library.String = "", itmjsex As %Library.String = "", UserID As %Library.String = "", NewPin As %Library.String = "", OldPin As %Library.String = "")
{
    Set Oldout=##Class(web.DHCSSuserChangeUsrPin).SysUsrEncrypt(OldPin) ;yn加
    s desc=0
    s OldoutD=""
	&sql(select ssusr_Pin into :OldoutD from ss_user
 		where ssusr_initials = :UserID)
	s desc=desc+SQLCODE
    
    if OldoutD'=Oldout{
	    s retval=itmjs_"('"_$ZCVT("99","O","JS")_"');"
 		&javascript<#(retval)#>
	}else{   
		Set Newout=##Class(web.DHCSSuserChangeUsrPin).SysUsrEncrypt(NewPin) ;yn加
		&sql(update ss_user set ssusr_Pin=:Newout
 			where ssusr_initials = :UserID)
		s desc=desc+SQLCODE
		s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
 		&javascript<#(retval)#>
	}
	q
}

ClassMethod GetEncrypt(Method As %String)
{
	s encmeth=##Class(websys.Page).Encrypt($lb(Method))
	Quit encmeth
}

ClassMethod SysUsrEncrypt(NewPin As %String) As %String
{
 s const=37,out=""
 //s NewPin="1234"
 ; BR 10/02/04 - 42300 :All trailing spaces must be removed from Pwd/PIN
 f  q:$e(NewPin,$l(NewPin))'=" "  s NewPin=$e(NewPin,1,$l(NewPin)-1)
 ;
 f piece=1:1:$l(NewPin) s char=$e(NewPin,piece) d
 . i char="D" s char=$c(2)
 . i char="p" s char=$c(3)
 . i char="d" s char=$c(4)
 . i char="t" s char=$c(5)
 . s num=$a(char)
 . s num=(num-piece+const)#255
 . i num>127 s num=(num+128)#255
 . i num<32 s num=(num+40)#255
 . i $c(num)="^" s num=num+1
 . s $e(out,piece)=$c(num#255)
 ;
 ; Pad out the length
 s len=$l(out)
 f piece=(len+1):1:12 d
 . s char=$e(out,(piece-len))
 . s num=$a(char)
 . s num=(num*2.345*const*(const-7))#255
 . i num>127 s num=(num+128)#255
 . i num<32 s num=(num+40)#255
 . i $c(num)="^" s num=num+1
 . s $e(out,piece)=$c(num#255)
	
 q out
}

}
