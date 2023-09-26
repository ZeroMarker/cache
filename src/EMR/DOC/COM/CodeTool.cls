/// 名称:	EMR.DOC.COM.CodeTool
/// 描述:	字符编码公用方法类
/// 编写者:	yejian
/// 编写日期: 	2021-2-22
/// 产品组：	电子病历产品组
Class EMR.DOC.COM.CodeTool Extends %RegisteredObject
{

/// Desc:       返回汉字的编码信息
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input：		HANZI:汉字
/// 			FLAG:返回何种编码(1:ASC码,2:汉字,3:拼音,4:首拼,5:四角码6:五笔码7:区位码8:笔划数9:郑码)
/// 			SPLIT:分割符(可以为空)
/// Output：	非0:返回编码信息:ASC码^汉字^拼音^首拼^四角码^五笔码^区位码^笔划数^郑码
/// 			0：未找到编码信息
/// debug: 		w ##class(EMR.DOC.COM.CodeTool).GetCNCODE("单",4,"^")
/// 			w ##class(EMR.DOC.COM.CodeTool).GetCNCODE("东华",4,"")
ClassMethod GetCNCODE(HANZIS As %String = "", FLAG As %String = "", SPLIT As %String = "") As %String
{
	s Rtnstr="0"
	q:$g(HANZIS)="" Rtnstr
	s Rtnstr=""
	for i=1:1:$l(HANZIS) 
	{
		 s HANZI=$EXTRACT(HANZIS,i)
		 s ASCIICODE=$ASCII(HANZI)
		if ($d(^DHCCharacterEncoding("0","ASCII",ASCIICODE))'=0) 
		{
			s rowid=$o(^DHCCharacterEncoding("0","ASCII",ASCIICODE,""))
			s tmpstr=""
			s:(FLAG="") tmpstr=$g(^DHCCharacterEncoding(rowid))
			s:(FLAG'="") tmpstr=$p(^DHCCharacterEncoding(rowid),"^",FLAG)
			s:(HANZI="曾")&(i=1) tmpstr="Z"
			s:(HANZI="单")&(i=1) tmpstr="S"
			s Rtnstr = $case(Rtnstr,"":tmpstr,:Rtnstr_SPLIT_tmpstr)
		}
		else
		{
			s:(Rtnstr="") Rtnstr="?"
			s Rtnstr=Rtnstr_SPLIT_"?"
		}
	}
	q Rtnstr
}

}
