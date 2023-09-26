Class web.eprajax.anySign Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s episodeID = $g(%request.Data("episodeID", 1), "")
	s userID = $g(%request.Data("userID", 1), "")
    s printDocID = $g(%request.Data("printDocID", 1), "")
    s eprNum = $g(%request.Data("eprNum", 1), "")
    
	s Action = $g(%request.Data("action", 1), "")
	
	s grpflag = $o(^DHCEPRM.AnySignItemSetI("IdxGrpName"," "_printDocID,""))
	if (Action="getAnySignItems") 
	{
		
		if (grpflag>=0)
		{
			d ..grpAnySignItems(printDocID,Action)
		}
		else
		{
			d ..getAnySignItems(printDocID,Action)
		}
	}
	
	if (Action="getVerifyItems")
	{
		if (grpflag>=0)
		{
			d ..grpAnySignItems(printDocID,Action)
		}
		else
		{
			d ..getAnySignItems(printDocID,Action)
		}
	}
	
	if (Action="saveSignInfo")
	{
		//episodeID, userID, printDocID, eprNum, seqNum,
		//algorithm, bioFeature, eventCert, sigValue, tsValue, version,
		//user, signTime, signScript, fingerPrint, content
		s insIDs = $g(%request.Data("insIDs",1),"")
		s seqNum = $g(%request.Data("seqNum",1),"")
		
		s algorithm = $g(%request.Data("algorithm",1),"")
		s bioFeature = $g(%request.Data("bioFeature",1),"")
		s bioFeatureStream = ##Class(%Library.GlobalCharacterStream).%New()
		s clsBio = $e(bioFeature,1,50)
		if ($f(clsBio,"CharacterStream")>1)
		{
			d bioFeatureStream.CopyFrom(bioFeature)
		}
		else
		{
			d bioFeatureStream.Write(bioFeature)
		}
		
		s eventCert = $g(%request.Data("eventCert",1),"")
		s sigValue = $g(%request.Data("sigValue",1),"")
		s tsValue = $g(%request.Data("tsValue",1),"")
		s version = $g(%request.Data("version",1),"")
		
		s user = $g(%request.Data("user",1),"")
        s signTime = $g(%request.Data("signTime",1),"")
		s signScript = $g(%request.Data("signScript",1),"")
        s fingerPrint = $g(%request.Data("fingerPrint",1),"")
        s content = $g(%request.Data("content",1),"")
        
		w ..saveSignInfo(episodeID, userID, printDocID, eprNum, insIDs, seqNum, algorithm, eventCert, sigValue, tsValue, version, user, signTime, signScript, fingerPrint, content, bioFeatureStream)
	}
	
	if (Action="checkValidSign")
	{
		s seqNum = $g(%request.Data("seqNum",1),"")
		
		w ..checkValidAnySign(episodeID, printDocID, eprNum, seqNum)
	}
	
	if (Action="getSignValue")
	{
		s seqNum = $g(%request.Data("seqNum",1),"")
		
		//w ..getSignValue(episodeID, printDocID, eprNum, seqNum)
		d ..outputSignValue(episodeID, printDocID, eprNum, seqNum)
	}
	
	if (Action="setSignValid")
	{
		s ctlocid = %session.Get("LOGON.CTLOCID")
		w ..setSignValid(episodeID, printDocID, eprNum, ctlocid)
	}
	
	if (Action="getSignStatus")
	{
		s ctlocid = %session.Get("LOGON.CTLOCID")
		w ..getSignStatus(episodeID, printDocID, eprNum, ctlocid)
	}
	
	Quit $$$OK
}

/// d ##class(web.eprajax.anySign).grpAnySignItems("507")
ClassMethod grpAnySignItems(prtDocID As %String, Action As %String = "getAnySignItems") As %String
{
	s JSON = ""
	s grpName = ""
	s grpNum = ""
	
	if (prtDocID'="")
	{
		for {
			s grpNum = $o(^DHCEPRM.AnySignItemSetI("IdxGrpName"," "_prtDocID,grpNum))
			Quit:grpNum=""
			s grpName = $o(^DHCEPRM.AnySignItemSetI("IdxGrpName"," "_prtDocID,grpNum," "))
			s btnItems = ..grpedItems(prtDocID,grpNum,Action)
			s JSON = JSON_"{title: '"_$tr(grpName," ")_"',layout:'fit',margins:'0 0 0 0',items:[{xtype:'panel',frame:true,bodyStyle:'overflow-x:hidden;overflow-y:scroll',autowidth:true,autoheight:true,items:[{layout:'column',items:[{columnWidth:.27,baseCls:'x-plain'},{columnWidth:.7,baseCls:'x-plain',style:'padding-top:10',items:"_btnItems_"},{columnWidth:.0,baseCls:'x-plain'}]}]}]},"
		}
	}
	s end = $L(JSON)
	s $e(JSON,end)=""
	w "G^["_JSON_"]"
}

/// d ##class(web.eprajax.anySign).grpedItems()
ClassMethod grpedItems(prtDocID As %String, grpNum As %Integer, Action As %String = "getAnySignItems") As %String
{
	s JSON = ""
	s seqNum =""
	
	for {
		s seqNum = $o(^DHCEPRM.AnySignItemSetI("IdxSeqInGrp"," "_prtDocID,grpNum,seqNum))
		Quit:seqNum=""
		
		s rId = $o(^DHCEPRM.AnySignItemSetI("IdxSeqInGrp"," "_prtDocID,grpNum,seqNum,""))
		s opt = ##class(EPRmeta.AnySignItemSet).%OpenId(rId)
		//s JSON = JSON_"{id:'"_opt.SeqNum_"',xtype:'button',minWidth:"_180_",text:'"_opt.AliasName_"',handler:function(){alert("_opt.SeqNum_");}},{baseCls:'x-plain',height:10},"
		if ("getAnySignItems" = Action)
		{
			//s JSON = JSON_"{id:'anySignItem"_opt.SeqNum_"',xtype:'button',minWidth:"_140_",text:'"_opt.AliasName_"',handler:function(){signature('"_opt.SeqNum_"',content,'"_opt.AliasName_"','',''"_");}},{baseCls:'x-plain',height:10},"
			s JSON = JSON_"{id:'anySignItem"_opt.SeqNum_"',xtype:'button',minWidth:"_160_",text:'"_opt.AliasName_"',handler:function(){signature('"_opt.SeqNum_"',content,'"_opt.AliasName_"','','');}},{baseCls:'x-plain',height:10},"
		}
		else
		{
			s JSON = JSON_"{id:'verifyItem"_opt.SeqNum_"',xtype:'button',minWidth:"_160_",text:'验证 "_opt.AliasName_"',handler:function(){verifyAnySign(content,'"_opt.SeqNum_"','"_opt.AliasName_"');}},{baseCls:'x-plain',height:10},"
		}
		
	}
	q "[{baseCls:'x-plain',height:20},"_JSON_"{baseCls:'x-plain',height:10}]"
}

/// d ##class(web.eprajax.anySign).getAnySignItems()
ClassMethod getAnySignItems(prtDocID As %String, Action As %String = "getAnySignItems") As %String
{
	s JSON = ""
	s SeqNum = ""
	s ind = ""
	
	if (prtDocID'="")
	{
		for {
			s SeqNum = $o(^DHCEPRM.AnySignItemSetI("IdxPrtDoc"," "_prtDocID,SeqNum))
			Quit:SeqNum=""
			for {
				s ind = $o(^DHCEPRM.AnySignItemSetI("IdxPrtDoc"," "_prtDocID,SeqNum,ind))
				Quit:ind=""
				
				s opt = ##class(EPRmeta.AnySignItemSet).%OpenId(ind)
				//s JSON = JSON_"{xtype:'button',minWidth:150,text:'"_opt.AliasName_"',handler:function(){alert('签名成功!');}},{baseCls:'x-plain',height:10},"
				if ("getAnySignItems" = Action)
				{
					s JSON = JSON_"{id:'anySignItem"_opt.SeqNum_"',xtype:'button',minWidth:"_180_",text:'"_opt.AliasName_"',handler:function(){signature('"_opt.SeqNum_"',content,'"_opt.AliasName_"','','');}},{baseCls:'x-plain',height:10},"
				}
				else
				{
					s JSON = JSON_"{id:'verifyItem"_opt.SeqNum_"',xtype:'button',minWidth:"_180_",text:'验证 "_opt.AliasName_"',handler:function(){verifyAnySign(content,'"_opt.SeqNum_"','"_opt.AliasName_"');}},{baseCls:'x-plain',height:10},"
				}
			}
		}
	}
	
	w "B^[{baseCls:'x-plain',height:20},"_JSON_"{baseCls:'x-plain',height:10}]"
}

/// d ##class(web.eprajax.anySign).saveSignInfo()
ClassMethod saveSignInfo(episodeID As %String = "", userID As %String = "", printDocID As %String = "", eprNum As %String = "", insIDs As %String, seqNum As %Integer = 0, algorithm As %String = "", eventCert As %String = "", sigValue As %String = "", tsValue As %String = "", version As %String = "", user As %String = "", signTime As %String = "", signScript As %String = "", fingerPrint As %String = "", content As %String = "", bioFeatureStream As %Stream = "")
{
	//s signScript = ""
	Quit:(episodeID = "") "0^日志保存失败，就诊号不能为空！"
	Quit:(signScript = "") "0^日志保存失败，笔迹信息为空，请检查签名是否正常完成！"
	Quit:(fingerPrint = "") "0^日志保存失败，指纹信息为空，请检查签名是否正常完成！"
	
	if (insIDs = "")
	{
		s insIDs=##Class(EPRservice.BLDigitalSignature).GetInstanceIDs(userID, printDocID, episodeID)
	}
	
	s objAnySign = ##class(EPRinstance.AnySignLog).%New()
	
	s objAnySign.IsValid = 1
	
	s objAnySign.EpisodeID = episodeID
	s objAnySign.DocUserID = userID
	s objAnySign.PrintDocID = printDocID
	s objAnySign.EPRNum = eprNum
	s objAnySign.InsID = insIDs
	s objAnySign.SeqNum = seqNum
	
	s objAnySign.Algorithm = algorithm
	d objAnySign.BioFeature.CopyFrom(bioFeatureStream)
	s objAnySign.EventCert = eventCert	//事件证书
	s objAnySign.SigValue = sigValue
	s objAnySign.TSValue = tsValue		//时间戳
	s objAnySign.Version = version
	
	s objAnySign.SignUser = user
	s objAnySign.SignTime = signTime
	d objAnySign.SignScript.Write(signScript)
	d objAnySign.FingerPrint.Write(fingerPrint)
	//s objAnySign.PlainText = content
	
	s sc = objAnySign.%Save()
	if $$$ISERR(sc)
	{
	 	s errInfo = "0^日志保存失败，ID为："_objAnySign.ID
	 	Quit errInfo
	}
	s divStateServer = ##Class(EPRservice.BOEPRLogs).GetStatusHtml(episodeID, printDocID, eprNum)
	Quit "1^"_divStateServer
}

/// d ##class(web.eprajax.anySign).checkValidAnySign()
ClassMethod checkValidAnySign(episodeID As %String = "", printDocID As %String = "", eprNum As %String = "", seqNum As %Integer = 0)
{
	Quit:(episodeID = "") 0
	Quit:(printDocID = "") 0
	Quit:(eprNum = "") 0
	Quit:(seqNum = "") 0
	
	s objAnySign = ##class(EPRinstance.AnySignLog).getValidSign(episodeID, printDocID, eprNum, seqNum)
	if objAnySign'=""
	{
		q objAnySign.IsValid
	}
	
	q 0
}

/// d ##class(web.eprajax.anySign).getSignValue()
ClassMethod getSignValue(episodeID As %String = "", printDocID As %String = "", eprNum As %String = "", seqNum As %Integer = 0)
{
	Quit:(episodeID = "") 0
	Quit:(printDocID = "") 0
	Quit:(eprNum = "") 0
	Quit:(seqNum = "") 0
	
	s objAnySign = ##class(EPRinstance.AnySignLog).getValidSign(episodeID, printDocID, eprNum, seqNum)
	if (objAnySign'="")
	{
		s JSON = "{   'SigValue' : {"
		
		s JSON = JSON_"     'Algorithm' :"_"'"_objAnySign.Algorithm_"',"
		s JSON = JSON_"     'BioFeature' : "_"'"_objAnySign.BioFeature.Read(32000)_"',"
		s JSON = JSON_"     'EventCert' : "_"'"_objAnySign.EventCert_"',"
		s JSON = JSON_"     'SigValue' : "_"'"_objAnySign.SigValue_"',"
		s JSON = JSON_"     'TSValue' : "_"'"_objAnySign.TSValue_"',"
		s JSON = JSON_"     'Version' : "_"'"_objAnySign.Version_"'"
		
		s JSON = JSON_"   }}"
		
		q JSON
	}
	
	q ""
}

ClassMethod outputSignValue(episodeID As %String = "", printDocID As %String = "", eprNum As %String = "", seqNum As %Integer = 0)
{
	Quit:(episodeID = "") 0
	Quit:(printDocID = "") 0
	Quit:(eprNum = "") 0
	Quit:(seqNum = "") 0
	
	s objAnySign = ##class(EPRinstance.AnySignLog).getValidSign(episodeID, printDocID, eprNum, seqNum)
	if (objAnySign'="")
	{
		w "{   'SigValue' : {"
		
		w "     'Algorithm' :"_"'"_objAnySign.Algorithm_"',"
		
		w "     'BioFeature' : "_"'"
		while objAnySign.BioFeature.AtEnd = 0 {
			w objAnySign.BioFeature.Read(32000)
		}
		w "',"
		
		w "     'EventCert' : "_"'"_objAnySign.EventCert_"',"
		w "     'SigValue' : "_"'"_objAnySign.SigValue_"',"
		w "     'TSValue' : "_"'"_objAnySign.TSValue_"',"
		w "     'Version' : "_"'"_objAnySign.Version_"'"
		
		w "   }}"
		
		//q JSON
	}
	//q ""
}

ClassMethod setSignValid(episodeID As %String = "", printDocID As %String = "", eprNum As %String = "", ctlocid As %String = "")
{
	if (..IsAnySignCTLoc(ctlocid)="1")
	{
		d ##Class(EPRinstance.AnySignLog).setAnySignUnvalid(episodeID, printDocID, eprNum)
		q "2^患者签名已经失效"
	}
}

ClassMethod getSignStatus(episodeID As %String = "", printDocID As %String = "", eprNum As %String = "", ctlocid As %String = "")
{
	//w "2^当前患者签名已失效"
	s status = ##Class(EPRinstance.AnySignLog).getSignStatus(episodeID,printDocID,eprNum)

	if (status="")
	{
		s is = ..IsAnySignCTLoc(ctlocid)
		q:(is=0) "1^信手书未开放"
	}
	
	q status
}

ClassMethod IsAnySignCTLoc(CTLocID As %String) As %String
{
	    s ctloc=^CF("CA","AnySignCTLocIDs")
	    if ("ALL"=ctloc) { q "1" } // 全院使用
	    else  //部分科室使用
	    {
		    s is=0
		    s count=$Length(ctloc, "^")
		    for i=1:1:count
		    {
			    if ($p(ctloc, "^", i)=CTLocID)
			    {
				    s is=1
				    q
				}
			}
			if (1=is) { q "1" }
		    else {  q "0" }
		}
        q "0"
}

}
