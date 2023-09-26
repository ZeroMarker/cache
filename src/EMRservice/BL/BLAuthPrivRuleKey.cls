Class EMRservice.BL.BLAuthPrivRuleKey Extends %RegisteredObject
{

/// d ##class(EMRservice.BL.BLAuthPrivRuleKey).BuildIndices()
ClassMethod BuildIndices()
{
	d ##class(EMRmeta.Auth.AuthPrivRuleKey).%BuildIndices()
}

/// d ##class(EMRservice.BL.BLAuthPrivRuleKey).InitRiveRuleKey()
ClassMethod InitRiveRuleKey()
{
	&sql(select KeyCode into :KeyCode from EMRmeta_Auth.AuthPrivRuleKey where KeyCode='save')
	if (KeyCode="")
	{
        &sql(INSERT INTO EMRmeta_Auth.AuthPrivRuleKey (IsActive, KeyCode, KeyName, Seq) VALUES ('Y', 'save', '保存', '1'))

        &sql(INSERT INTO EMRmeta_Auth.AuthPrivRuleKey (IsActive, KeyCode, KeyName, Seq) VALUES ('Y', 'print', '打印', '2'))

        &sql(INSERT INTO EMRmeta_Auth.AuthPrivRuleKey (IsActive, KeyCode, KeyName, Seq) VALUES ('Y', 'delete', '删除', '3'))

        &sql(INSERT INTO EMRmeta_Auth.AuthPrivRuleKey (IsActive, KeyCode, KeyName, Seq) VALUES ('Y', 'view', '查看', '4'))

        &sql(INSERT INTO EMRmeta_Auth.AuthPrivRuleKey (IsActive, KeyCode, KeyName, Seq) VALUES ('Y', 'new', '新建', '5'))

        &sql(INSERT INTO EMRmeta_Auth.AuthPrivRuleKey (IsActive, KeyCode, KeyName, Seq) VALUES ('Y', 'check', '签名', '6'))
    }
}

/// s stream=##class(EMRservice.BL.BLAuthPrivRuleKey).GetAllPrivRuleKey()
/// d stream.OutputToDevice()
ClassMethod GetAllPrivRuleKey() As %GlobalCharacterStream
{
	
	s json = ##Class(%GlobalCharacterStream).%New()
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s seq=""
	for 
	{
		s seq=$o(^DHCEMRM.AuthPrivRuleKeyI("IdxActiveSeq"," Y",seq))
		q:(seq="")
		
		s id=""
		for
		{
			s id=$o(^DHCEMRM.AuthPrivRuleKeyI("IdxActiveSeq"," Y",seq,id))
			q:(id="")	
			
			s obj = ##class(EMRmeta.Auth.AuthPrivRuleKey).%OpenId(id)
			s keyCode=obj.KeyCode
			s keyName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.Auth.AuthPrivRuleKey","KeyName",obj.KeyName,langid)
			s keySeq = obj.Seq
			
			d:(json.Size'=0) json.Write(",")
			s keyJson = "{""id"":"""_keyCode_""",""name"":"""_keyName_""",""seq"":"""_keySeq_"""}"
			
			d json.Write(keyJson)
			
		}	
	}
	
	q json
}

/// Desc:       获取授权操作类型
/// Creator:    王煜
/// CreateDate: 2022-06-08
/// Input:      
/// Output:     stream
/// Debug:      w ##class(EMRservice.BL.BLAuthPrivRuleKey).GetAllPrivRuleKeyArray()
ClassMethod GetAllPrivRuleKeyArray()
{
	s str = ""
	s ret = ##Class(%GlobalCharacterStream).%New()
	d ret.Write("[")
	s str = ..GetAllPrivRuleKey().Read()
	q:(str = "") ""
	d ret.Write(str)
	d ret.Write("]")
	q ret
}

}
