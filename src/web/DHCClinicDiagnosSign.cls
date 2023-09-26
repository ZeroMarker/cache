Class web.DHCClinicDiagnosSign Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod Delete(ID As %String) As %Integer
{
	Quit ##class(User.ClinicDiagnosSign).%DeleteId(ID)
}

ClassMethod Edit(ID As %String, ClinicGroupDr As %Integer, MRCDSSDr As %Integer) As %Integer
{
	Set cDr = ##class(User.RBCClinicGroup).%OpenId(ClinicGroupDr)
	Set mDr = ##class(User.MRCDiagnosSignSymptom).%OpenId(MRCDSSDr)
	if (cDr && mDr)
	{
		Set rowId = ""
		&sql(SELECT CDSS_Rowid into :rowId From SQLUser.DHC_ClinicDiagnosSign where 
		CDSS_ClinicGroup_Dr = :ClinicGroupDr AND CDSS_MRCDSS_Dr = :MRCDSSDr
		)
		if (ID="")
		{
			//add
			if (%ROWCOUNT >0)
			{
				//already exists.
				Quit -1	
			}
		}
		else
		{
			//update
			if ((%ROWCOUNT >0) && (rowId '= ID))	
			{
				Quit -1	
			}
		}
		
		if (ID="")
		{
			Set cds = ##class(User.ClinicDiagnosSign).%New()
		}
		else
		{
			Set cds = ##class(User.ClinicDiagnosSign).%OpenId(ID)
		}
				
		Set cds.ClinicGroupDr = cDr
		Set cds.MRCDSSDr = mDr
		Set err = cds.%Save()
		if ($System.Status.IsError(err))
		{
			//Do $System.Status.DisplayError(err)
			Quit 0	
		}
		
		Quit 1
	}
	else
	{
		Quit 0	
	}
}

ClassMethod Encrpty(method As %String) As %String
{
	Quit ##class(websys.Page).Encrypt($LB(method))
}

ClassMethod LookupClinicBroker(itemjs As %String, itemjsex As %String, val As %String)
{
	Set desc = ""
	Set id = ""	
	
	&sql(SELECT CLGRP_Desc,CLGRP_RowId into :desc,:id from SQLUser.RBC_ClinicGroup
		WHERE ((CLGRP_Desc %StartsWith :val)
			)
	)
	if (%ROWCOUNT<1) Quit 0
	
	Set js = itemjs _ "('"_$zconvert(desc,"o","JS")_"');"	
	if (itemjsex '= "")
	{
		Set js = js_itemjsex_"('"_$zconvert(desc_"^"_id,"o","JS")_"');"
	}
	&javascript<#(js)#>
}

Query FindByClinic(ClinicGroupDr As %String, MRCDSSDr As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT CDSS_Rowid,
	CDSS_ClinicGroup_Dr->CLGRP_RowId As CLGRP_RowId ,CDSS_ClinicGroup_Dr->CLGRP_Desc As CLGRP_Desc,
	CDSS_MRCDSS_Dr->DSYM_RowId As DSYM_RowId,CDSS_MRCDSS_Dr->DSYM_Desc As DSYM_Desc
	FROM SQLUser.DHC_ClinicDiagnosSign
	WHERE ((CDSS_ClinicGroup_Dr->CLGRP_Desc %StartsWith :ClinicGroupDr) AND
	(CDSS_MRCDSS_Dr->DSYM_Desc %StartsWith :MRCDSSDr)
	)
}

Query LookupClinic(Desc As %String) As %SQLQuery(ROWSPEC = "专业名称:%String,RowId:%String,Code:%String")
{
	select CLGRP_Desc,CLGRP_RowId,CLGRP_Code from SQLUser.RBC_ClinicGroup
	where (CLGRP_Desc %Startswith :Desc)
}

}
