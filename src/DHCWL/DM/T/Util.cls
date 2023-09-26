Class DHCWL.DM.T.Util Extends %RegisteredObject
{

ClassMethod ResolvePath(path, ByRef nspath, ByRef name, ByRef type)
{
	k nspath,name,type
	s len=$l(path)
	s flag=1,i=len,founded=0
	f  q:flag=0  d
	.s i=i-1
	.i (($e(path,i)=".")) s founded=i
	.i ( (i<1)||($e(path,i)=".")||($e(path,i)="/")) s flag=0 q
	i founded=0 q
	s type=$e(path,founded+1,len)
	s ei=founded-1,founde=0,flag=1
	f  q:flag=0  d
	.s i=i-1
	.i (($e(path,i)="/")) s founded=i
	.i ((i<1)||($e(path,i)=".")||($e(path,i)="/")) s flag=0 q
	q:founded=0
	s name=$e(path,founded+1,ei)
	s nspath=$e(path,1,founded-1)
	s:nspath="" nspath="/"
}

}
