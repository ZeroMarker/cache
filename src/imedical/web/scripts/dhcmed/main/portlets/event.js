
var CHECKROWID=0;
function InitViewport1Event(obj) {
	obj.LoadEvent = function()
  {};
	obj.GridPanel_rowclick = function()
	{
	};
	obj.GridPanel_rowdblclick = function()
	{
		obj.PortletEdit();
		
	};

/*		obj.btnQuery_click = function()
	{
		obj.GridPanelStore.removeAll();
		obj.GridPanelStore.load();
		obj.PorCode.setRawValue("");
	};
	*/
	obj.btnNew_click = function()
	{
		 var objWinEdit = new InitWinEdit();
		 CHECKROWID=0;
     objWinEdit.WinEdit.show();
	};
	obj.btnEdit_click = function()
	{
		obj.PortletEdit();
	};
	obj.btnDelete_click = function()
	{			
		var selectObj = obj.GridPanel.getSelectionModel().getSelected();	
 	  if(selectObj) {
  	  		ExtTool.confirm('选择框','确定删除?',function(btn){
       				if(btn=="no") return;
  						var objPortlet = ExtTool.StaticServerObject("DHCMed.SS.Portlets");
  						var ret=objPortlet.DeleteById(selectObj.get("Rowid"));
  						if(ret==-1)
  						{
  							ExtTool.alert("提示","删除失败！");
  						}
       		 		else
        			{
        				ExtTool.alert("提示","删除成功！");
        				obj.GridPanelStore.removeAll();
				    		obj.GridPanelStore.load();	
        			}
        })
 		}
 		else{	
 	 		ExtTool.alert("提示","请选择要删除的行!");
			return;	
 		}
	};
	
/*
	*编辑页签
	*/
	obj.PortletEdit = function(){
		var selectObj = obj.GridPanel.getSelectionModel().getSelected();
		if (selectObj){			
			var objWinEdit = new InitWinEdit(selectObj);
			objWinEdit.winfPCode.disabled=true;
			CHECKROWID=1;
			objWinEdit.WinEdit.show();
			
		}
		else{
			ExtTool.alert("提示","请先选中一行!");
		}		
	};
}
function InitWinEditEvent(obj) {
	var parent=objControlArry['Viewport1'];
	obj.LoadEvent = function(){
		var data = arguments[0][0];
  		if (data){
  			var objPortlets = ExtTool.StaticServerObject("DHCMed.SSService.PortletsSrv");
				var ret = objPortlets.GetPortletInfoById(data.get("Rowid"));
				if (ret==-1) 
				{
					ExtTool.alert("提示","页签信息不存在!");
					return;
				}
			
  			var Str=ret.split("^");		
  			
  			obj.Rowid.setValue(Str[0]);
  			obj.winfPCode.setValue(Str[1]);
  			obj.winfPDescription.setValue(Str[2]);
  			obj.winfPHeight.setValue(Str[3]);
  			obj.winfPAutoRefreash.setValue(Str[4]);
  			obj.winfPFrequency.setValue(Str[5]);
  			obj.winfPResume.setValue(Str[6]);
  			obj.winfPIsActive.setValue(Str[7]);
  			obj.winfPMessage.setValue(Str[8]);
  			obj.winfPMsgClassMethod.setValue(Str[9]);
  			//obj.winfPMsgMenuDr.setValue(Str[10]);
  			obj.winfPMsgURL.setValue(Str[11]);
  			obj.winfPQueryName.setValue(Str[12]);
  			//obj.winfPDtlMenu.setValue(Str[13]);
  			obj.winfPDtlURL.setValue(Str[14]);
  			if(Str[10]>0) 
  			{
  				ExtTool.AddComboItem(obj.winfPMsgMenuDr,Str[17],Str[10]);
  				obj.winfTab.setActiveTab(0);
  			}
  			if(Str[18]>0) ExtTool.AddComboItem(obj.winfPProductDr,Str[19],Str[18]);
  			if(Str[13]>0) 
  			{
  				ExtTool.AddComboItem(obj.winfPDtlMenu,Str[20],Str[13]);
  				obj.winfTab.setActiveTab(1);
  			}
  			
  			if(Str[15]){
  				obj.winfPDtlShowType.setValue(Str[15]);
  			}
  			else{
	  			obj.winfPDtlShowType.setValue("grid");
	  		}
  			//ExtTool.alert("提示",Str[16]);
  			if(Str[16]) 
  			{  var chart=Str[16].split("#")  ;}
  			if(Str[15]=="chart")
  			{
	  			obj.editGridPanel.setVisible (false);
	  			obj.pnShow2.setVisible (true);
	  			obj.pnShow3.setVisible (false);
  				obj.btnQuery.setVisible (false);
  				
  				obj.showcCType.setValue(chart[0]);
  				var chartDtlX=chart[1].split("$")
  				var chartDtlY=chart[2].split("$")
  				obj.showcCX.setValue(chartDtlX[0]);
  				obj.showcCY.setValue(chartDtlY[0]);				
  				obj.showcCXIndex.setValue(chartDtlX[1]);
  				obj.showcCYIndex.setValue(chartDtlY[1]);
  			}
  			if(Str[15]=="mschart"){
	  			obj.editGridPanel.setVisible (false);
	  			obj.pnShow3.setVisible (true);
	  			obj.pnShow2.setVisible (false);
  				obj.btnQuery.setVisible (false);
  				
  				obj.showcMType.setValue(chart[0]);			
  				var mschartDtlX=chart[1].split("$")
  				var mschartDtlY=chart[2].split("$")
  				var mschartDtlZ=chart[3].split("$")
  				obj.showcMX.setValue(mschartDtlX[0]);
  				obj.showcMY.setValue(mschartDtlY[0]);
  				obj.showcMZ.setValue(mschartDtlZ[0]);				
  				obj.showcMXIndex.setValue(mschartDtlX[1]);
  				obj.showcMYIndex.setValue(mschartDtlY[1]);
  				obj.showcMZIndex.setValue(mschartDtlZ[1]);
  
  			}
  			if(Str[15]=="grid"){
	  			obj.editGridPanel.setVisible (true);
	  			obj.pnShow2.setVisible (false);
	  			obj.pnShow3.setVisible (false);
	        obj.btnQuery.setVisible (true);
	        
	  			//obj.editGridPanelStore.removeAll();
	  			obj.editGridPanelStore.load();
  			}
  		}
  		obj.winfPAutoRefreash.setValue(true);
	};
	
	obj.winfPAutoRefreash_check = function(){
		var RefreashFlag = obj.winfPAutoRefreash.getValue();
		if (!RefreashFlag){
			obj.winfPFrequency.setDisabled(true);
			obj.winfPFrequency.setRawValue("");
			obj.winfPFrequency.setValue("");
		}else{
			obj.winfPFrequency.setDisabled(false);
		}
	}
	
	 obj.btnQuery_click = function()
	{
		obj.editGridPanelStore.removeAll();
		if(obj.winfPQueryName.getValue()=="")
		{
			ExtTool.alert("", "请输入Query信息!");
			return;
		}		
		obj.editGridPanelStore.load();
	};
	obj.btnSave_click = function()
	{
	//	ExtTool.alert(obj.winfTab.getActiveTab().id);
		if((obj.winfPCode.getValue()=="")||(obj.winfPDescription.getValue()=="")){
			ExtTool.alert("提示","代码、描述不能为空!");
			return;
		}
	/*	if((obj.winfPMsgMenuDr.getValue()=="")&&(obj.winfPDtlMenu.getValue()=="")){
			ExtTool.alert("提示","提示信息和明细信息中的连接菜单不能都为空!");
			return;
		}	*/
	//	if()	
	
	
		//Add By LiYang 2014-07-15 FixBug:1326 系统管理-自定义页签\菜单维护-新建，输入重复代码保存时弹出"SyntaxError:无效字符"，建议给出明确提示信息
		var selectObj = parent.GridPanel.getSelectionModel().getSelected();	
		var strCodeLast = (selectObj != null ? selectObj.get("Code") : "");
		var strCode = obj.winfPCode.getValue();
		if ((strCode != strCodeLast) && (parent.GridPanelStore.findExact("Code", strCode) >-1))
		{
			ExtTool.alert("提示","代码与列表中的现有项目重复，请仔细检查!");
			return;
		}
	
	
	
	
		var objPortlets = ExtTool.StaticServerObject("DHCMed.SS.Portlets");		
		var tmp = obj.Rowid.getValue()+"^";
		tmp+= obj.winfPCode.getValue()+"^";
		tmp+= obj.winfPDescription.getValue()+"^";
		tmp+= obj.winfPHeight.getValue()+"^";
		tmp+= (obj.winfPAutoRefreash.getValue()? "1" : "0") +"^";
		tmp+= obj.winfPFrequency.getValue()+"^";
		if(((obj.winfPFrequency.getValue()== "")||(obj.winfPFrequency.getValue()== 0))&&(obj.winfPAutoRefreash.checked))
		{
			ExtTool.alert("提示","请选择频率");
			return;
		}
		if(((obj.winfPFrequency.getValue()!= "")&&(obj.winfPFrequency.getValue()!= 0))&&(!obj.winfPAutoRefreash.checked))
		{
			ExtTool.alert("提示","您已选择频率,请勾选\"自动刷新\"");
			return;
		}
		tmp+= obj.winfPResume.getValue()+"^";
		tmp+= (obj.winfPIsActive.getValue()? "1" : "0") + "^";
		if(obj.winfTab.getActiveTab().id=="0")
		{
			if(obj.winfPDtlMenu.getValue()!="")
			{
				ExtTool.alert("提示","页签类型只能是提示信息和明细信息中的一种。<br>请返回确定页签类型并在选定的Tab页下点击保存，否则保存的信息为空！");
				obj.winfPDtlMenu.setValue("");
				return;
			}
			if(obj.winfPMsgMenuDr.getValue()==""){
				ExtTool.alert("提示","连接菜单不能为空！");
				return;
			}
			tmp+= obj.winfPMessage.getValue()+"^";
			tmp+= obj.winfPMsgClassMethod.getValue()+"^";
			tmp+= obj.winfPMsgMenuDr.getValue()+"^";
			tmp+= obj.winfPMsgURL.getValue()+"^";
			tmp+="^^^^^";
	  }
	  else{
	  	if(obj.winfPMsgMenuDr.getValue()!="")
			{
				ExtTool.alert("提示","页签类型只能是提示信息和明细信息中的一种。<br>请返回确定页签类型并在选定的Tab页下点击保存，否则保存的信息为空！");
				obj.winfPMsgMenuDr.setValue("");
				return;
			}
			if(obj.winfPDtlMenu.getValue()==""){
				ExtTool.alert("提示","连接菜单不能为空！");
				return;
			}
		  	tmp+= "^^^^";
				tmp+= obj.winfPQueryName.getValue()+"^";
				tmp+= obj.winfPDtlMenu.getValue()+"^";
				tmp+= obj.winfPDtlURL.getValue()+"^";
				tmp+= obj.winfPDtlShowType.getValue().inputValue+"^";
				var dtlShowConfig="";
				if(obj.winfPDtlShowType.getValue().inputValue=="grid")
				{//获取表格类型的明细设置信息
					if(obj.winfPQueryName.getValue()=="")
					{
						ExtTool.alert("","请输入Query信息!");
						return;
						}
					var m = obj.editGridPanelStore.getRange(0,obj.editGridPanelStore.getCount());
		      var data='';       
		      for (var i = 0; i < m.length; i++) 
		      {
		      	if(data)
		      	{
		      		data+="#";
		      	}
		      	var record = m[i];
		      	var fields = record.fields.keys; 
		        for (var j = 0; j < fields.length-1; j++) 
		        {        	
		             var name = fields[j];
		             var value = record.data[name]; 
		              	data+=value+"$"; 
		        }	
		        if(record.data[fields[fields.length-1]])
		         data+="1";
		         else
		         	data+="0"; 
		      }
		    //  Ext.Msg.alert("",data);
		    	dtlShowConfig=data;
		    }
				else if(obj.winfPDtlShowType.getValue().inputValue=="chart")
				{//获取图表类型的明细设置信息
						dtlShowConfig=obj.showcCType.getValue()+"#";
		     		dtlShowConfig+=obj.showcCX.getValue()+"$"+obj.showcCXIndex.getValue()+"#";
		     		dtlShowConfig+=obj.showcCY.getValue()+"$"+obj.showcCYIndex.getValue();
				}
				else{//获取多系列图表类型的明细设置信息
					dtlShowConfig=obj.showcMType.getValue()+"#";
					dtlShowConfig+=obj.showcMX.getValue()+"$"+obj.showcMXIndex.getValue()+"#";
	     		dtlShowConfig+=obj.showcMY.getValue()+"$"+obj.showcMYIndex.getValue()+"#";
	     		dtlShowConfig+=obj.showcMZ.getValue()+"$"+obj.showcMZIndex.getValue();
					}
		    tmp+=dtlShowConfig;
  	}
  //  Ext.Msg.alert("",tmp);
		try
		{
			var NewID = objPortlets.Update(tmp);
	//		window.alert(tmp);
			if(NewID<0) {
				ExtTool.alert("提示","保存失败！");
				return;
				}
			obj.Rowid.setValue(NewID);
			obj.WinEdit.close();
			parent.GridPanelStore.load();
			
		}catch(err)
		{
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}
	};

	obj.btnCancel_click = function()
	{
		obj.WinEdit.close();
	};
	
	obj.winfPMsgMenuDr_click = function()
	{
		obj.winfPMsgMenuDrStore.removeAll();
		obj.winfPMsgMenuDrStore.load();
	}
	
	obj.winfPDtlShowType_check = function()
	{//根据ShowType的改变显示、隐藏不同的面板
		type=obj.winfPDtlShowType.getValue().inputValue;
		//ExtTool.alert(type);
		if(type=="grid"){		
	//		ExtTool.alert("grid");
			obj.editGridPanel.setVisible (true);
			obj.pnShow2.setVisible (false);
			obj.pnShow3.setVisible (false);
			obj.btnQuery.setVisible (true);
		}
		else if(type=="chart"){
		//	ExtTool.alert("chart");
			obj.editGridPanel.setVisible (false);
			obj.pnShow2.setVisible (true);
			obj.pnShow3.setVisible (false);
			obj.btnQuery.setVisible (false);
		}
		else{
	//		ExtTool.alert("mschart");
			obj.editGridPanel.setVisible (false);
			obj.pnShow3.setVisible (true);
			obj.pnShow2.setVisible (false);
			obj.btnQuery.setVisible (false);
		}
	}
	
	obj.onAdd = function()
	{//明细设置表格类型添加一行
		//ExtTool.alert("add");	
	//	if(obj.editGridPanelStore.getCount()<5)
	//	{	
	 		var Plant = obj.editGridPanel.getStore().recordType;
	    var p = new Plant({
	        colName: '',
	        dataIndex: '',
	        colHeader: '',
	        isHidden: 1
	    });
	    var n=obj.editGridPanelStore.getCount();
	   // ExtTool.alert("提示",n+1);
	    obj.editGridPanel.stopEditing();
	    obj.editGridPanelStore.insert(n, p);
	    obj.editGridPanel.getView().refresh();
	    obj.editGridPanel.startEditing(0,0);
	/* }
 		else {
 			ExtTool.alert("提示","表格类型明细设置最多只能有五个列信息");	
		}*/
	};
	
	obj.onDelete = function()
	{//明细设置表格类型删除一行
	//	obj.editGridPanel.stopEditing();		
    var sm = obj.editGridPanel.getSelectionModel();    
    var cell = sm.getSelectedCell();
		var record = obj.editGridPanelStore.getAt(cell[0]);
		obj.editGridPanelStore.remove(record);
		obj.editGridPanel.getView().refresh();
   
	};

	//Add By LiYang 2014-07-15 FixBug:1327  系统管理-自定义页签-新建-选择无连接菜单的所属产品后，更改为有连接菜单的所属产品，连接菜单下拉框无数据
	//FixBug:1329 系统管理-自定义页签-新建/编辑-明细信息，多次修改所属产品(打开连接菜单下拉框)，连接菜单下拉框始终显示第一次所选所属产品的记录
	obj.winfPProductDr.on("select", 
		function(){
			obj.winfPMsgMenuDr.clearValue();
			obj.winfPMsgMenuDrStore.load({});
		}
	);
	
}

