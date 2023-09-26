Class User.DHCMGNurArticle Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHCMGNur_Article ]
{

//论文

Property ArticleNurDr As User.DHCMGPersons;

Property ArticleReleasedate As %Library.Date(FORMAT = 1);

Property ArticleSubject As %String(TRUNCATE = 1);

Property ArticleCommunion As %String(TRUNCATE = 1);

Property ArticleMagazine As %String(TRUNCATE = 1);

Property ArticleAuthorNo As %String(TRUNCATE = 1);

Property ArticleSign As %String(TRUNCATE = 1);

Property ArticlePoint As %String(TRUNCATE = 1);

Property ArticleRecUser As User.DHCMGPersons;

Property ArticleRecDate As %Library.Date(FORMAT = 1);

Index NurDr On ArticleNurDr;

ClassMethod Save(parr As %String) As %String
{
  //id + "^" + person + "^" + realeasDate  + "^" + subject + "^" + comm + "^" + maga+"^"+authno +"^"+point ;
   s id=$P(parr,"^",1)
   s per=$P(parr,"^",2)
   s realeasedate=$P(parr,"^",3)
   s arcsubject=$P(parr,"^",4)
   s comm=$P(parr,"^",5)
   s magazine=$P(parr,"^",6)
   s authno=$P(parr,"^",7)
   s sign=$P(parr,"^",8)
   s point=$P(parr,"^",9)
   s user=$P(parr,"^",10)
   if id'="" s a=##class(User.DHCMGNurArticle).%OpenId(id)
   e  s a=##class(User.DHCMGNurArticle).%New()
   s a.ArticleNurDr=##class(User.DHCMGPersons).%OpenId(per)

   s a.ArticleReleasedate=$ZDH(realeasedate,3)

   s a.ArticleSubject=arcsubject

   s a.ArticleCommunion=comm

   s a.ArticleMagazine=magazine

   s a.ArticleAuthorNo=authno

   s a.ArticleSign=sign

   s a.ArticlePoint=point
   s a.ArticleRecUser=##class(User.DHCMGPersons).%OpenId(user)
   s a.ArticleRecDate=+$H
   d a.%Save()
   q 0
}

Storage Default
{
<Data name="DHCMGNurArticleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ArticleAuthorNo</Value>
</Value>
<Value name="3">
<Value>ArticleCommunion</Value>
</Value>
<Value name="4">
<Value>ArticleMagazine</Value>
</Value>
<Value name="5">
<Value>ArticleNurDr</Value>
</Value>
<Value name="6">
<Value>ArticlePoint</Value>
</Value>
<Value name="7">
<Value>ArticleReleasedate</Value>
</Value>
<Value name="8">
<Value>ArticleSign</Value>
</Value>
<Value name="9">
<Value>ArticleSubject</Value>
</Value>
<Value name="10">
<Value>ArticleRecDate</Value>
</Value>
<Value name="11">
<Value>ArticleRecUser</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGNurArticleD</DataLocation>
<DefaultData>DHCMGNurArticleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGNurArticleD</IdLocation>
<IndexLocation>^User.DHCMGNurArticleI</IndexLocation>
<StreamLocation>^User.DHCMGNurArticleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
