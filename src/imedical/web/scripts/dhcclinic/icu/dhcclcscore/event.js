function InitViewScreenEvent(obj)
{
	var _DHCCLCScore=ExtTool.StaticServerObject('web.DHCCLCScore');
	
	obj.LoadEvent = function(args)
	{
	};
	
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  if (rc){ 
	    obj.Rowid.setValue(rc.get("TRowid"));
	    obj.clcscorecode.setValue(rc.get("TCLCSCode"));
	    //alert(rc.get("tRowid"))
	    obj.clcscoredesc.setValue(rc.get("TCLCSDesc"));
	    //obj.clcscoretype.setValue(rc.get("TCLCSType"));
	    obj.clcscoretype.setRawValue(rc.get("TCLCSType"));
	    if(rc.get("TCLCSType")=="Select")
	    {
	    	obj.clcscoretype.setValue("S");
	    }
	    else
	    {
		    obj.clcscoretype.setValue("C");
	    }
		
	    obj.clcscorefactor.setValue(rc.get("TCLCSFactor"));
	    obj.clcscorebasevalue.setValue(rc.get("TCLCSBaseValue"));
	    obj.clcscoreismain.setValue(rc.get("TCLCSIsMainScore"));
	    if(rc.get("TCLCSIsMainScore")=="是")
	    {
	    	obj.clcscoreismain.setValue("1");
	    }
	    else
	    {
		    obj.clcscoreismain.setValue("0");
	    }
	    obj.clcscorecanedit.setRawValue(rc.get("TCLCSCanEdit"));
	    if(rc.get("TCLCSCanEdit")=="是")
	    {
	    	obj.clcscorecanedit.setValue("1");
	    }
	    else
	    {
		    obj.clcscorecanedit.setValue("0");
	    }
	    obj.clcscoreuomdr.setValue(rc.get("TCLCSUomdr"));
	    obj.clcscomord.setValue(rc.get("TCLCSComOrdDr"));
	    obj.clcscoreJianYan.setValue(rc.get("TCLCSJianYan"));
	    
	    var a=rc.get("TRowid") 
	  }
	};
	
	obj.addbutton_click = function()
	{
		var clcscomordFlag=false;
		if(obj.clcscorecode.getValue()=="")
		{
			ExtTool.alert("提示","代码不能为空!");	
			return;
		}
		if(obj.clcscoredesc.getValue()=="")
		{
			ExtTool.alert("提示","描述不能为空!");	
			return;
		}
		//var RowId = obj.RowId.getValue();
		var clcscorecode=obj.clcscorecode.getValue();           
		var clcscoredesc=obj.clcscoredesc.getValue();           
		var clcscoretype=obj.clcscoretype.getValue();         
		var clcscorefactor=obj.clcscorefactor.getValue();          
		var clcscorebasevalue=obj.clcscorebasevalue.getValue();       
		var clcscoreismain=obj.clcscoreismain.getValue();  
		//if (clcscoreismain=="") clcscoreismain="Y"
		//if (clcscoreismain=="0") clcscoreismain="N"
		var clcscorecanedit=obj.clcscorecanedit.getValue();      
		//if (clcscorecanedit=="1") clcscorecanedit="Y"
		//if (clcscorecanedit=="0") clcscorecanedit="N"
		var clcscoreuomdr=obj.clcscoreuomdr.getValue(); 
		var clcscomord=obj.clcscomord.getValue();
		var clcscoreJianYan=obj.clcscoreJianYan.getValue();
		//---20190109 YuanLin 下拉框只能选择不允许手写
		var clcscomordNum=obj.clcscomordstore.data.items.length;
		var clcscomordItems=obj.clcscomordstore.data.items;
		if(clcscomord!="")
		{
			if(clcscomordNum!=0)
			{
				for (var i = 0; i < clcscomordNum; i++)
				{
					if (clcscomord == clcscomordItems[i].data.ID)
					{
						clcscomordFlag = true;
						break;
					}
				}
				if(!clcscomordFlag)
				{
					ExtTool.alert("提示","关联常用医嘱项请从下拉框选择!");
					return ;
				}
			}
			if(clcscomordNum==0)
			{
				ExtTool.alert("提示","关联常用医嘱项请从下拉框选择!");
				return ;
			}
		}
		else
		{
			var clcscomordRaw=obj.clcscomord.getRawValue();
			if(clcscomordRaw!="")
			{
				ExtTool.alert("提示","关联常用医嘱项请从下拉框选择!");
				return ;
			}
		}         
        //alert(clcscorecode+"^"+clcscoredesc+"^"+clcscoretype+"^"+clcscorefactor+"^"+clcscorebasevalue+"^"+clcscoreismain+"^"+clcscorecanedit+"^"+clcscoreuomdr+"^"+clcscomord)
		var ret=_DHCCLCScore.InsertClCScore(clcscorecode,clcscoredesc,clcscoretype,clcscorefactor,clcscorebasevalue,clcscoreismain,clcscorecanedit,clcscoreuomdr,clcscomord,clcscoreJianYan);
		//alert(ret)
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","添加失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","添加成功!",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.clcscorecode.setValue("");
	  	  	obj.clcscoredesc.setValue("");
	  	  	obj.clcscoretype.setValue("");
	  	  	obj.clcscorefactor.setValue("");
	  	  	obj.clcscorebasevalue.setValue(""); 
	  	  	obj.clcscoreismain.setValue(""); 
	  	  	obj.clcscorecanedit.setValue("");
	  	  	obj.clcscoreuomdr.setValue("");
	  	  	obj.clcscomord.setValue("");
	  	  	obj.clcscoreJianYan.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});
		}
	};
	
	obj.updatebutton_click = function()
	{
		var clcscomordFlag=false;
		if(obj.Rowid.getValue()=="")
		{
			ExtTool.alert("提示","记录Id为空!");	
			return;
		}
		if(obj.clcscorecode.getValue()=="")
		{
			ExtTool.alert("提示","代码不能为空!");	
			return;
		}
		if(obj.clcscoredesc.getValue()=="")
		{
			ExtTool.alert("提示","描述不能为空!");	
			return;
		}
		var Rowid = obj.Rowid.getValue();
		var clcscorecode=obj.clcscorecode.getValue();           
		var clcscoredesc=obj.clcscoredesc.getValue();           
		var clcscoretype=obj.clcscoretype.getValue();
		if (clcscoretype=="Select") clcscoretype="S"
		if (clcscoretype=="Calculate") clcscoretype="C"		         
		var clcscorefactor=obj.clcscorefactor.getValue();          
		var clcscorebasevalue=obj.clcscorebasevalue.getValue();       
		var clcscoreismain=obj.clcscoreismain.getValue();  
		if (clcscoreismain=="是") clcscoreismain="1"
		if (clcscoreismain=="否") clcscoreismain="0"
		var clcscorecanedit=obj.clcscorecanedit.getValue();      
		if (clcscorecanedit=="是") clcscorecanedit="1"
		if (clcscorecanedit=="否") clcscorecanedit="0"
		var clcscoreuomdr=obj.clcscoreuomdr.getValue();
		var clcscomord=obj.clcscomord.getValue();
		var clcscoreJianYan=obj.clcscoreJianYan.getValue(); 
		//---20190109 YuanLin 下拉框只能选择不允许手写
		var clcscomordNum=obj.clcscomordstore.data.items.length;
		var clcscomordItems=obj.clcscomordstore.data.items;
		if(clcscomord!="")
		{
			if(clcscomordNum!=0)
			{
				for (var i = 0; i < clcscomordNum; i++)
				{
					if (clcscomord == clcscomordItems[i].data.ID)
					{
						clcscomordFlag = true;
						break;
					}
				}
				if(!clcscomordFlag)
				{
					ExtTool.alert("提示","关联常用医嘱项请从下拉框选择!");
					return ;
				}
			}
			if(clcscomordNum==0)
			{
				ExtTool.alert("提示","关联常用医嘱项请从下拉框选择!");
				return ;
			}
		}
		else
		{
			var clcscomordRaw=obj.clcscomord.getRawValue();
			if(clcscomordRaw!="")
			{
				ExtTool.alert("提示","关联常用医嘱项请从下拉框选择!");
				return ;
			}
		}      
        //alert(Rowid+"^"+clcscorecode+"^"+clcscoredesc+"^"+clcscoretype+"^"+clcscorefactor+"^"+clcscorebasevalue+"^"+clcscoreismain+"^"+clcscorecanedit+"^"+clcscoreuomdr+"^"+clcscomord)
		var ret=_DHCCLCScore.UpdateClCScore(Rowid,clcscorecode,clcscoredesc,clcscoretype,clcscorefactor,clcscorebasevalue,clcscoreismain,clcscorecanedit,clcscoreuomdr,clcscomord,clcscoreJianYan);	
		if(ret<0)
		{
		  Ext.Msg.alert("提示","更新失败！");	
		}
		else
		{
		  Ext.Msg.alert("提示","更新成功！",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.clcscorecode.setValue("");
	  	  	obj.clcscoredesc.setValue("");
	  	  	obj.clcscoretype.setValue("");
	  	  	obj.clcscorefactor.setValue("");
	  	  	obj.clcscorebasevalue.setValue(""); 
	  	  	obj.clcscoreismain.setValue(""); 
	  	  	obj.clcscorecanedit.setValue("");
	  	  	obj.clcscoreuomdr.setValue("");
	  	  	obj.clcscomord.setValue("");
	  	  	obj.clcscoreJianYan.setValue("");
	  	  	obj.retGridPanelStore.load({});  
		  	});
	     }
	 };
	 
	obj.deletebutton_click = function()
	{
	  var ID=obj.Rowid.getValue();
	  //alert(ID);
	  if(ID=="")
	  {
	    Ext.Msg.alert("提示","请选择一条要删除的记录！");
	    return;
	  }
	  Ext.Msg.confirm("选择","确认要删除？",function(btn){
	  	if(btn=="no")return;
	  	var ret=_DHCCLCScore.DeleteClCScore(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("提示","删除失败！");
	  	else
	  	  Ext.Msg.alert("提示","删除成功！",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.clcscorecode.setValue("");
	  	  	obj.clcscoredesc.setValue("");
	  	  	obj.clcscoretype.setValue("");
	  	  	obj.clcscorefactor.setValue("");
	  	  	obj.clcscorebasevalue.setValue(""); 
	  	  	obj.clcscoreismain.setValue(""); 
	  	  	obj.clcscorecanedit.setValue("");
	  	  	obj.clcscoreuomdr.setValue("");
	  	  	obj.clcscomord.setValue("");
	  	  	obj.clcscoreJianYan.setValue("");
	  	  	obj.retGridPanelStore.load({});  
		  	});

	  	}
	  );
	};
	
	/*obj.findbutton_click = function(){
		obj.retGridPanelStore.load({});
	  	  	obj.Rowid.setValue("");
	  	  	obj.clcscorecode.setValue("");
	  	  	obj.clcscoredesc.setValue("");
	  	  	obj.clcscoretype.setValue("");
	  	  	obj.clcscorefactor.setValue("");
	  	  	obj.clcscorebasevalue.setValue(""); 
	  	  	obj.clcscoreismain.setValue(""); 
	  	  	obj.clcscorecanedit.setValue("");
	  	  	obj.clcscoreuomdr.setValue("");
	  	  	obj.clcscomord.setValue("");
	};*/
	

	obj.retGridPanel_rowdblclick = function()
	{
		obj.MenuEdit();
	};
	obj.MenuEdit = function(){		
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj){
			var objWinEdit = new InitWinScreen(selectObj);
			objWinEdit.opCLCSRowid.disabled=true;
			objWinEdit.clcsoptioncode.disabled=true;
			objWinEdit.WinScreen.show();
		}
		else{
			ExtTool.alert("提示","请先选中一行!");
		}
	}
}

////////////////////////////////////////////////////////////////////////////////

function InitWinScreenEvent(obj)
{
	var _DHCCLCScore=ExtTool.StaticServerObject('web.DHCCLCScore');
	obj.LoadEvent = function(){
		var data = arguments[0][0];
  		if (data){
  			var menuRowid = data.get("TRowid");
  			var menuType=data.get("TCLCSType");
  			 obj.clcsoptioncode.setValue(data.get("TCLCSCode"));	//20160804+dyl
  			obj.opclcsotype.setValue(menuType);
  			obj.opCLCSRowid.setValue(menuRowid);
  		    obj.opretGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		        param.ClassName = 'web.DHCCLCScore';
		        param.QueryName = 'FindClCSOption';
		        param.Arg1=menuRowid;
		        //param.Arg1 = obj.opCLCSRowid.getValue();
		         param.ArgCnt = 1;
	            });
	        obj.opretGridPanelStore.load({});  
  		}
	}
	
	obj.opretGridPanel_rowclick = function()
	{
	  var rc = obj.opretGridPanel.getSelectionModel().getSelected();
	  if (rc){ 
	    obj.opRowid.setValue(rc.get("TRowid"));
	    obj.opCLCSRowid.setValue(rc.get("TCLCSRowid"));
	    obj.clcsoptioncode.setValue(rc.get("TCLCSOCode"));
	    obj.clcsoptiondesc.setValue(rc.get("TCLCSODesc"));
	    obj.clcsopminvalue.setValue(rc.get("TCLCSOMinValue"));
	    obj.clcsopmaxvalue.setValue(rc.get("TCLCSOMaxValue"));
	    obj.clcscorevalue.setValue(rc.get("TCLCSOScoreValue"));
	    obj.opclcsotype.setValue(rc.get("TCLCSOType"));
	  }
	};
	
	obj.opaddbutton_click = function()
	{
  
		if(obj.opCLCSRowid.getValue()=="")
		{
			ExtTool.alert("提示","父ID不能为空!")
		}
		if(obj.clcsoptioncode.getValue()=="")
		{
			ExtTool.alert("提示","代码不能为空!");	
			return;
		}
		if(obj.clcsoptiondesc.getValue()=="")
		{
			ExtTool.alert("提示","描述不能为空!");	
			return;
		}

		var opCLCSRowid = obj.opCLCSRowid.getValue();
		//弹出窗口代码
		var clcsoptioncode=obj.clcsoptioncode.getValue();         
		var clcsoptiondesc=obj.clcsoptiondesc.getValue(); 
		if(obj.opclcsotype.getValue()=="Calculate")
		{
			if(obj.clcsopminvalue.getValue()=="")
			{
				ExtTool.alert("提示","当类型为Calculate时,最小值不能为空");
				return;
			}
			if(obj.clcsopmaxvalue.getValue()=="")
			{
				ExtTool.alert("提示","当类型为Calculate时,最大值不能为空");
				return;
			}
		}          
		var clcsopminvalue=obj.clcsopminvalue.getValue();         
		var clcsopmaxvalue=obj.clcsopmaxvalue.getValue();          
		//20160913+dyl
		if(clcsopmaxvalue<clcsopminvalue)
		{
			ExtTool.alert("提示","最大值不能小于最小值");
			return;
		}
		var clcscorevalue=obj.clcscorevalue.getValue();            
        //alert(opCLCSRowid+"^"+clcsoptioncode+"^"+clcsoptiondesc+"^"+clcsopminvalue+"^"+clcsopmaxvalue+"^"+clcscorevalue)
		var ret=_DHCCLCScore.InsertClCSOption(opCLCSRowid,clcsoptioncode,clcsoptiondesc,clcsopminvalue,clcsopmaxvalue,clcscorevalue);
		//alert(ret)
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","添加失败!"+ret);
		}
		else 
		{
			Ext.Msg.alert("提示","添加成功!",function(){
	  	  	obj.opRowid.setValue("");
	  	  	obj.opCLCSRowid.setValue("");
	  	  	obj.clcsoptioncode.setValue("");
	  	  	obj.clcsoptiondesc.setValue("");
	  	  	obj.clcsopminvalue.setValue("");
	  	  	obj.clcsopmaxvalue.setValue(""); 
	  	  	obj.clcscorevalue.setValue(""); 
	  	  	obj.opclcsotype.setValue("");
	  	  	obj.opretGridPanelStore.load({});  	  	
	  	  	});
		}
	};
	
	obj.opupdatebutton_click = function()
	{
		if(obj.opRowid.getValue()=="")
		{
			ExtTool.alert("提示","ID号不能为空!");	
			return;
		}		
		if(obj.clcsoptioncode.getValue()=="")
		{
			ExtTool.alert("提示","代码不能为空!");	
			return;
		}
		if(obj.clcsoptiondesc.getValue()=="")
		{
			ExtTool.alert("提示","描述不能为空!");	
			return;
		}
		var opRowid=obj.opRowid.getValue();
		var opCLCSRowid = obj.opCLCSRowid.getValue();
		var clcsoptioncode=obj.clcsoptioncode.getValue();         
		var clcsoptiondesc=obj.clcsoptiondesc.getValue();
		//alert(obj.opclcsotype.getValue())
		if(obj.opclcsotype.getValue()=="C")
		{
			if(obj.clcsopminvalue.getValue()=="")
			{
				ExtTool.alert("提示","当类型为Calculate时,最小值不能为空");
				return;
			}
			if(obj.clcsopmaxvalue.getValue()=="")
			{
				ExtTool.alert("提示","当类型为Calculate时,最大值不能为空");
				return;
			}
		}          		           
		var clcsopminvalue=obj.clcsopminvalue.getValue();         
		var clcsopmaxvalue=obj.clcsopmaxvalue.getValue();
		//20160913+dyl
		if(clcsopmaxvalue<clcsopminvalue)
		{
			ExtTool.alert("提示","最大值不能小于最小值");
			return;
		}          
		var clcscorevalue=obj.clcscorevalue.getValue();            
        //alert(opRowid+"^"+opCLCSRowid+"^"+clcsoptioncode+"^"+clcsoptiondesc+"^"+clcsopminvalue+"^"+clcsopmaxvalue+"^"+clcscorevalue)
		var ret=_DHCCLCScore.UpdateClCSOption(opRowid,opCLCSRowid,clcsoptioncode,clcsoptiondesc,clcsopminvalue,clcsopmaxvalue,clcscorevalue);	
		if(ret<0)
		{
		  Ext.Msg.alert("提示","更新失败！");	
		}
		else
		{
		  Ext.Msg.alert("提示","更新成功！",function(){
	  	  	obj.opRowid.setValue("");
	  	  	obj.opCLCSRowid.setValue("");
	  	  	obj.clcsoptioncode.setValue("");
	  	  	obj.clcsoptiondesc.setValue("");
	  	  	obj.clcsopminvalue.setValue("");
	  	  	obj.clcsopmaxvalue.setValue(""); 
	  	  	obj.clcscorevalue.setValue(""); 
	  	  	obj.opclcsotype.setValue("");
	  	  	obj.opretGridPanelStore.load({});  
		  	});
	     }
	 };
	 
	obj.opdeletebutton_click = function()
	{
	  var ID=obj.opRowid.getValue();
	  //alert(ID);
	  if(ID=="")
	  {
	    Ext.Msg.alert("提示","请选择一条要删除的记录！");
	    return;
	  }
	  Ext.Msg.confirm("选择","确认要删除？",function(btn){
	  	if(btn=="no")return;
	  	var ret=_DHCCLCScore.DeleteClCSOption(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("提示","删除失败！");
	  	else
	  	  Ext.Msg.alert("提示","删除成功！",function(){
	  	  	obj.opRowid.setValue("");
	  	  	obj.opCLCSRowid.setValue("");
	  	  	obj.clcsoptioncode.setValue("");
	  	  	obj.clcsoptiondesc.setValue("");
	  	  	obj.clcsopminvalue.setValue("");
	  	  	obj.clcsopmaxvalue.setValue(""); 
	  	  	obj.clcscorevalue.setValue(""); 
	  	  	obj.opclcsotype.setValue("");
	  	  	obj.opretGridPanelStore.load({});   
		  	});
	  	}
	  );
	};	

    obj.opexitbutton_click=function()
    {
	    obj.WinScreen.close();
		//parent.gridListStore.load({params : {start:0,limit:15}});
    }
}