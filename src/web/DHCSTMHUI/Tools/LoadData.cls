Class web.DHCSTMHUI.Tools.LoadData Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

ClassMethod LoadData(fname, sub, p) As %String
{
 ;fname : the filename including data(必须是全路径)
 ;
 q:fname="" -1
 k ^REJECT($zn)
 w "正在读取数据...",!
 d ..file(fname,sub,p)	
 q 0
}

ClassMethod file(file, sub, p)
{
 ;process file
 ;
 k ^TMPDHCSTMINPUT(p,sub)
 ;directory where files are 
 s del="^"
 s $zt="close"
 ;s file=file
 w "File Upload Starting...",!
 c file
 o file:"RS"
 u file
 f  d
 . r a
 . ;w a,!
 . s line=$o(^TMPDHCSTMINPUT(p,sub,""),-1)+1
 . s ^TMPDHCSTMINPUT(p,sub,0)=line
 . s ^TMPDHCSTMINPUT(p,sub,line)=$tr(a,$c(9),del)
 q 
close c file
 w "File Upload Finished!",!!
 q
}

}
