Import sqluser

/// /导入程序的公共方法
/// d ##class(web.DHCSTMHUI.Tools.CommonInput).SetErr(i,msg)
///  ##class(web.DHCSTMHUI.Tools.CommonInput).GetCNCODE()
Class web.DHCSTMHUI.Tools.CommonInput Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod vDate(d As %String) As %String
{
	n (d)
	q:d="" ""
	s $zt="errdate"
	i d["-" s d=$zdh(d,3) q d
	i d["/" {
		i $p(d,"/")>1840{
			s d = $p(d,"/",3)_"/"_$p(d,"/",2)_"/"_$p(d,"/",1)
		}
		s d=$zdh(d,4) q d
	}
	i d["." {
		s d = $p(d,".",1)_"-"_$p(d,".",2)_"-"_$p(d,".",3)
		s d=$zdh(d,3) q d
	}
	i $l(d)=8 s d=$zdh(d,8) q d
	q ""
errdate
 q -1
}

/// 错误记录
ClassMethod SetErr(row As %String, errinfo As %String)
{
     n (row,errinfo)
     s dd=+$H
     s tt=$p($h,",",2)
     &sql(insert into DHC_DataInputErr (DataInputErr_Date,DataInputErr_Time,DataInputErr_No,DataInputErr_Desc)values(:dd,:tt,:row,:errinfo))
}

/// Creator:ZhanMingChao
/// Description:返回汉字的编码信息
/// Input：	HANZI:汉字
/// 			FLAG:返回何种编码(1:ASC码,2:汉字,3:拼音,4:首拼,5:四角码6:五笔码7:区位码8:笔划数9:郑码)
/// 			SPLIT:分割符(可以为空)
/// Output：
/// 	非0:返回编码信息:ASC码^汉字^拼音^首拼^四角码^五笔码^区位码^笔划数^郑码
/// 	0：未找到编码信息
/// CreatDate:2011-06-08
ClassMethod GetCNCODE(HANZIS As %String = "", FLAG As %String = "", SPLIT As %String = "") As %String
{
	s Rtnstr="0"
	q:$g(HANZIS)="" Rtnstr
	s Rtnstr=""
	f i=1:1:$l(HANZIS) d
	.s HANZI=$EXTRACT(HANZIS,i)
	.s ASCIICODE=$ASCII(HANZI)
	.i $D(^DHCCharacterEncoding("0","ASCII",ASCIICODE))'=0 d
	..s rowid=$o(^DHCCharacterEncoding("0","ASCII",ASCIICODE,""))
	..s tmpstr=""
	..s:FLAG="" tmpstr=$g(^DHCCharacterEncoding(rowid))
	..s:FLAG'="" tmpstr=$p(^DHCCharacterEncoding(rowid),"^",FLAG)
	..i Rtnstr=""  d
	...s Rtnstr=tmpstr
	..e  d
	...s Rtnstr=Rtnstr_SPLIT_tmpstr
	.e  d
	..s:Rtnstr="" Rtnstr="?"
	..s Rtnstr=Rtnstr_SPLIT_"?"
	q Rtnstr
}

}
