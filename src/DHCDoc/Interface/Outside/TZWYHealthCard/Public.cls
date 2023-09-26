Class DHCDoc.Interface.Outside.TZWYHealthCard.Public Extends %RegisteredObject
{

/// 这里应该只考虑身份证,而非其他证件
ClassMethod getIDCardNobypapmi(papmi As %String) As %String
{
	/*s IDCard=$p($g(^PAPER(papmi,"PAT",3)),"^",6)
	if IDCard=""{
		s IDCard=$p($g(^PAPER(papmi,"ALL")),"^",9)
	}
	q IDCard*/
	
	s IDCard=$p($g(^PAPER(papmi,"ALL")),"^",9)
	q IDCard
}

}
