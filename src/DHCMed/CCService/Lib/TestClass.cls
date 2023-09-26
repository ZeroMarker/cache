Class DHCMed.CCService.Lib.TestClass Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod Fn01(N1, N2) As %String
{
	n (N1, N2, %Adm, %ExtraData)
	s $li(%ExtraData,1)="OK"
	s $li(%ExtraData,2)=N1+N2
	q N1+N2
}

ClassMethod TestList()
{
	/*s tmp=$lb()
	f i=1:1:99999  d
	.s $li(tmp,i)=$lb("AAAA","BBBBB","CCCCC","DDDDDD","AAAA","BBBBB","CCCCC","DDDDDD","AAAA","BBBBB","CCCCC","DDDDDD","AAAA","BBBBB","CCCCC","DDDDDD","AAAA","BBBBB","CCCCC","DDDDDD","AAAA","BBBBB","CCCCC","DDDDDD","AAAA","BBBBB","CCCCC","DDDDDD")
	*/
	s arry=##class(%Library.ListOfObjects).%New()
	f i=1:1:2000  d
	.s a=##class(DHCMed.Base.Patient).%New()
	.d arry.InsertObject(a)
	b //处理完成
	q 0
}

ClassMethod Test()
{
	//w ##class(DHCMed.CCService.Lab.TestClass).Test()
	w ..TestList()
	q 0
}

}
