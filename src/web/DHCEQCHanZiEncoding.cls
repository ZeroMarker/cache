Class web.DHCEQCHanZiEncoding Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:zhangyu 2014-04-15
/// Desc:返回汉字的编码信息
/// Input：	HANZIS:汉字
/// 		FLAG:返回何种编码(2:拼音,3:拼音New,4:首拼,5:ASC码,6:四角码,7:五笔码,8:郑码,9:笔划数)
/// 		SPLIT:分割符(可以为空)
/// 		ZCONVERTFlag:U:大写 ;L:小写
/// Output：
/// 		非0:返回编码信息:拼音拼音New^首拼^ASC码^四角码^五笔码^郑码^笔划数
/// 		0：未找到编码信息
/// w ##class(web.DHCEQCHanZiEncoding).GetEncoding("11楼01室",4,"","U")
ClassMethod GetEncoding(HANZIS As %String = "", FLAG As %String = "4", SPLIT As %String = "", ZCONVERTFlag As %String = "U") As %String
{
	new Rtnstr,RowID,IDStr,Len,HANZI,i
	s (Rtnstr,RowID,IDStr,Len)=""
	s HANZIS=##class(web.DHCEQCommon).Replace(HANZIS," ","")
	q:$g(HANZIS)="" Rtnstr
	s Len=$l(HANZIS)
	if RowID=""
	{
		f i=Len:-1:0 d
		.i i=0 s i=1
		.s HANZI=$EXTRACT(HANZIS,1,i)
		.i ($D(^DHCEQCCode("DHCEQCHanZiEncoding",0,"HanZi",HANZI))'=0) d
		..s RowID=$o(^DHCEQCCode("DHCEQCHanZiEncoding",0,"HanZi",HANZI,0))
		..i RowID'="" d
		...s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCHanZiEncoding",RowID)),"^",10)
		...i InvalidFlag="Y"  d
		....s value=HANZI
		...e  d
		....s value=$ZCONVERT($p(^DHCEQCCode("DHCEQCHanZiEncoding",RowID),"^",FLAG),ZCONVERTFlag)
		....i value="" s value=HANZI
		..e  d
		...s value=HANZI
		..d ResetCycle
		.e  d
		..i i=1 d
		...s value=HANZI
		...d ResetCycle
	}
	quit Rtnstr

ResetCycle
		i Rtnstr=""  d
		.s Rtnstr=value
		e  d
		.s Rtnstr=Rtnstr_SPLIT_value
		;s HANZIS=##class(web.DHCEQCommon).Replace(HANZIS,HANZI,"")
		s HANZIS=$EXTRACT(HANZIS,i+1,Len)
		s Len=$l(HANZIS)
		s i=Len
		q
}

}
