function InitViewscreenEvent(obj) {
    var _DHCCLScore=ExtTool.StaticServerObject('web.DHCCLScore');
	obj.LoadEvent = function()
    {
	 var retStr=_DHCCLScore.GetCLSRecord(obj.mainCLSId)
	 var sumScore=retStr.split("^")[0]
	 obj.txtScore.setValue(sumScore)
	 var subCLSRecordStr=retStr.split("^")[1]
	 var record=subCLSRecordStr.split("#")
	 var count=record.length
	 for(var i=0;i<count;i++)
	 {
	  var domRadioGroupId="radio_"+record[i].split("!")[0]
	  var domRadioGroupEl=Ext.getCmp(domRadioGroupId);
	  var clsCLCSODr=record[i].split("!")[1]
	  domRadioGroupEl.setValue(clsCLCSODr)
	  var domTxtId="txt_"+record[i].split("!")[0]
	  var domTxtEl=Ext.getCmp(domTxtId)
	  if(domTxtEl)
	  {
	   domTxtEl.setValue(record[i].split("!")[2])
	  }  
	 }
  	};
	obj.txt_specialkey = function()
	{
	    if (arguments[1].getKey()!=13) return;
	    var domRadioGroupId="radio_"+this.id.split("_")[1];
		var quantity=this.getValue();
		var domRadioGroupEl=Ext.getCmp(domRadioGroupId);
		if(quantity=="") domRadioGroupEl.setValue("");
		else
		{
		var CLCSOId=_DHCCLScore.GetCLCSOId(this.id.split("_")[1],quantity);
		if(CLCSOId=="") alert("无此值的评分标准！")
		else
		{
		 domRadioGroupEl.setValue(CLCSOId)
		}
		}
		//var obj=domRadioEl.getValue()
		//alert(obj.getValue())
	};
	obj.btnCalScore_click=function()
	{
	 var sumScore=0
	 for(var i=0;i<obj.bgElList.length;i++)
	{
	 var txtObj=new Object();
	 var radioObj=new Object();
	 var elTypeCount=obj.bgElList[i].length;
	 if(elTypeCount==1)
	 {
	   txtObj=null;
	   radioObj=obj.bgElList[i][0];
	 }
	 else
	 {
	  txtObj=obj.bgElList[i][0];
	  radioObj=obj.bgElList[i][1];
	 }
	 var radioGroupEl=Ext.getCmp(radioObj.id);
	 var selRadioOption=radioGroupEl.getValue()
	 if(selRadioOption==null)
	 {
	  var desc=_DHCCLScore.GetCLCSDesc(radioObj.id.split("_")[1])
	  alert(desc+"没有选中评分！")
	  return;
	 }
	  var subClsValue=""
	  if(txtObj!=null)
	  {
	   txtEl=Ext.getCmp(txtObj.id);
	   subClsValue=txtEl.getValue();
	  }
	  var selOptionId=selRadioOption.inputValue;
	  var scoreValue=_DHCCLScore.GetScoreValue(selOptionId);
	  scoreValue=parseInt(scoreValue)
	  var ret0=_DHCCLScore.UpdateSubCLScore(obj.mainCLSId,radioObj.id.split("_")[1],selOptionId,subClsValue)
      if(ret0!=0) 
	  { alert(ret0);
	    return;
	  }
	  sumScore+=scoreValue
	}
	var ret1=_DHCCLScore.UpdateMainCLScore(obj.mainCLSId,sumScore)
	if(ret1!=0)alert(ret1)
	else 
	{
	 obj.txtScore.setValue(sumScore)
	}
	}
}

