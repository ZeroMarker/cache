
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
  	  		ExtTool.confirm('ѡ���','ȷ��ɾ��?',function(btn){
       				if(btn=="no") return;
  						var objPortlet = ExtTool.StaticServerObject("DHCMed.SS.Portlets");
  						var ret=objPortlet.DeleteById(selectObj.get("Rowid"));
  						if(ret==-1)
  						{
  							ExtTool.alert("��ʾ","ɾ��ʧ�ܣ�");
  						}
       		 		else
        			{
        				ExtTool.alert("��ʾ","ɾ���ɹ���");
        				obj.GridPanelStore.removeAll();
				    		obj.GridPanelStore.load();	
        			}
        })
 		}
 		else{	
 	 		ExtTool.alert("��ʾ","��ѡ��Ҫɾ������!");
			return;	
 		}
	};
	
/*
	*�༭ҳǩ
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
			ExtTool.alert("��ʾ","����ѡ��һ��!");
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
					ExtTool.alert("��ʾ","ҳǩ��Ϣ������!");
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
  			//ExtTool.alert("��ʾ",Str[16]);
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
			ExtTool.alert("", "������Query��Ϣ!");
			return;
		}		
		obj.editGridPanelStore.load();
	};
	obj.btnSave_click = function()
	{
	//	ExtTool.alert(obj.winfTab.getActiveTab().id);
		if((obj.winfPCode.getValue()=="")||(obj.winfPDescription.getValue()=="")){
			ExtTool.alert("��ʾ","���롢��������Ϊ��!");
			return;
		}
	/*	if((obj.winfPMsgMenuDr.getValue()=="")&&(obj.winfPDtlMenu.getValue()=="")){
			ExtTool.alert("��ʾ","��ʾ��Ϣ����ϸ��Ϣ�е����Ӳ˵����ܶ�Ϊ��!");
			return;
		}	*/
	//	if()	
	
	
		//Add By LiYang 2014-07-15 FixBug:1326 ϵͳ����-�Զ���ҳǩ\�˵�ά��-�½��������ظ����뱣��ʱ����"SyntaxError:��Ч�ַ�"�����������ȷ��ʾ��Ϣ
		var selectObj = parent.GridPanel.getSelectionModel().getSelected();	
		var strCodeLast = (selectObj != null ? selectObj.get("Code") : "");
		var strCode = obj.winfPCode.getValue();
		if ((strCode != strCodeLast) && (parent.GridPanelStore.findExact("Code", strCode) >-1))
		{
			ExtTool.alert("��ʾ","�������б��е�������Ŀ�ظ�������ϸ���!");
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
			ExtTool.alert("��ʾ","��ѡ��Ƶ��");
			return;
		}
		if(((obj.winfPFrequency.getValue()!= "")&&(obj.winfPFrequency.getValue()!= 0))&&(!obj.winfPAutoRefreash.checked))
		{
			ExtTool.alert("��ʾ","����ѡ��Ƶ��,�빴ѡ\"�Զ�ˢ��\"");
			return;
		}
		tmp+= obj.winfPResume.getValue()+"^";
		tmp+= (obj.winfPIsActive.getValue()? "1" : "0") + "^";
		if(obj.winfTab.getActiveTab().id=="0")
		{
			if(obj.winfPDtlMenu.getValue()!="")
			{
				ExtTool.alert("��ʾ","ҳǩ����ֻ������ʾ��Ϣ����ϸ��Ϣ�е�һ�֡�<br>�뷵��ȷ��ҳǩ���Ͳ���ѡ����Tabҳ�µ�����棬���򱣴����ϢΪ�գ�");
				obj.winfPDtlMenu.setValue("");
				return;
			}
			if(obj.winfPMsgMenuDr.getValue()==""){
				ExtTool.alert("��ʾ","���Ӳ˵�����Ϊ�գ�");
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
				ExtTool.alert("��ʾ","ҳǩ����ֻ������ʾ��Ϣ����ϸ��Ϣ�е�һ�֡�<br>�뷵��ȷ��ҳǩ���Ͳ���ѡ����Tabҳ�µ�����棬���򱣴����ϢΪ�գ�");
				obj.winfPMsgMenuDr.setValue("");
				return;
			}
			if(obj.winfPDtlMenu.getValue()==""){
				ExtTool.alert("��ʾ","���Ӳ˵�����Ϊ�գ�");
				return;
			}
		  	tmp+= "^^^^";
				tmp+= obj.winfPQueryName.getValue()+"^";
				tmp+= obj.winfPDtlMenu.getValue()+"^";
				tmp+= obj.winfPDtlURL.getValue()+"^";
				tmp+= obj.winfPDtlShowType.getValue().inputValue+"^";
				var dtlShowConfig="";
				if(obj.winfPDtlShowType.getValue().inputValue=="grid")
				{//��ȡ������͵���ϸ������Ϣ
					if(obj.winfPQueryName.getValue()=="")
					{
						ExtTool.alert("","������Query��Ϣ!");
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
				{//��ȡͼ�����͵���ϸ������Ϣ
						dtlShowConfig=obj.showcCType.getValue()+"#";
		     		dtlShowConfig+=obj.showcCX.getValue()+"$"+obj.showcCXIndex.getValue()+"#";
		     		dtlShowConfig+=obj.showcCY.getValue()+"$"+obj.showcCYIndex.getValue();
				}
				else{//��ȡ��ϵ��ͼ�����͵���ϸ������Ϣ
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
				ExtTool.alert("��ʾ","����ʧ�ܣ�");
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
	{//����ShowType�ĸı���ʾ�����ز�ͬ�����
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
	{//��ϸ���ñ���������һ��
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
	   // ExtTool.alert("��ʾ",n+1);
	    obj.editGridPanel.stopEditing();
	    obj.editGridPanelStore.insert(n, p);
	    obj.editGridPanel.getView().refresh();
	    obj.editGridPanel.startEditing(0,0);
	/* }
 		else {
 			ExtTool.alert("��ʾ","���������ϸ�������ֻ�����������Ϣ");	
		}*/
	};
	
	obj.onDelete = function()
	{//��ϸ���ñ������ɾ��һ��
	//	obj.editGridPanel.stopEditing();		
    var sm = obj.editGridPanel.getSelectionModel();    
    var cell = sm.getSelectedCell();
		var record = obj.editGridPanelStore.getAt(cell[0]);
		obj.editGridPanelStore.remove(record);
		obj.editGridPanel.getView().refresh();
   
	};

	//Add By LiYang 2014-07-15 FixBug:1327  ϵͳ����-�Զ���ҳǩ-�½�-ѡ�������Ӳ˵���������Ʒ�󣬸���Ϊ�����Ӳ˵���������Ʒ�����Ӳ˵�������������
	//FixBug:1329 ϵͳ����-�Զ���ҳǩ-�½�/�༭-��ϸ��Ϣ������޸�������Ʒ(�����Ӳ˵�������)�����Ӳ˵�������ʼ����ʾ��һ����ѡ������Ʒ�ļ�¼
	obj.winfPProductDr.on("select", 
		function(){
			obj.winfPMsgMenuDr.clearValue();
			obj.winfPMsgMenuDrStore.load({});
		}
	);
	
}

