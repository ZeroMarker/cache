///筛选窗口
function InitAutoWorkFilterEvent(obj)
{
	
	obj.LoadEvent = function(args)
	{
		var FilterRule = ExtTool.StaticServerObject("DHCMed.CC.CtlFilterRule");
		var objFilterRule=FilterRule.GetObjBySubjectID(obj.SubjectID);
		
			if(objFilterRule != null)
			{
				
				obj.txtIncludeAbsolute.setValue((objFilterRule.IncludeAbsolute == "1"));
				obj.txtMinSensitiveCount.setValue(objFilterRule.MinSensitiveCount);
				obj.txtMinSpecificityCount.setValue(objFilterRule.MinSpecificityCount);
				obj.txtMinScore.setValue(objFilterRule.MinScore);
				obj.txtTotalScore.setValue(objFilterRule.TotalScore);
				obj.txtTotalNoticedScore.setValue(objFilterRule.TotalNoticedScore);
			}
			else
			{
				obj.txtIncludeAbsolute.setValue(true);
				obj.txtMinSensitiveCount.setValue("");
				obj.txtMinSpecificityCount.setValue("");
				obj.txtMinScore.setValue("");
				obj.txtTotalScore.setValue("");
				obj.txtTotalNoticedScore.setValue("");  
			}
				
	
	
	
	
	};

    
   obj.btnSave_click = function ()
	{	
		var FilterRule = ExtTool.StaticServerObject("DHCMed.CC.CtlFilterRule");
		var objFilterRule=FilterRule.GetObjBySubjectID(obj.SubjectID);
		var CurrFilterRuleID=(objFilterRule == "" ? "" : objFilterRule.RowID);
		
	 	var tmp = CurrFilterRuleID;
	 	tmp += "^"+obj.SubjectID;
	 	tmp += "^"+(obj.txtIncludeAbsolute.getValue()? "1" : "0");
		tmp += "^"+obj.txtMinSensitiveCount.getValue();
		tmp += "^"+obj.txtMinSpecificityCount.getValue();
		tmp += "^"+obj.txtMinScore.getValue();
		tmp += "^"+obj.txtTotalScore.getValue();
		tmp += "^"+obj.txtTotalNoticedScore.getValue();
		var ret=FilterRule.Update(tmp);
		//alert(tmp);
		if(ret>0) 
		{
			obj.CurrFilterRuleID="";
			obj.txtIncludeAbsolute.setValue("");
			obj.txtMinSensitiveCount.setValue("");
			obj.txtMinSpecificityCount.setValue("");
			obj.txtMinScore.setValue("");
			obj.txtTotalScore.setValue("");
			obj.txtTotalNoticedScore.setValue("");
			obj.btnCancel_click();
		}
		else ExtTool.alert("提示","保存失败!");
		
	}
     
   obj.btnCancel_click = function()
	{
		obj.pnCtlFilterRule.close();
	}
    }