function InitViewport1Event(obj) {
	
	var TheOBJ = ExtTool.StaticServerObject("web.DHCHM.BaseDataSet");
		var selid="";
	obj.LoadEvent = function(args)
  {};
  obj.expand_click= function()
	{ 
		//obj.SDesc.setValue(obj.param5.getRawValue());
		obj.ComboBoxHCIStore.load();
	}
	obj.btFind_click = function()
	{
	
	
	};
	obj.btNew_click = function()
	{ 
    if(obj.param5.getValue()=="") {
			ExtTool.alert("��ʾ","��ѡ��Ҫ�����Ա��");
			return;
		}
		if(obj.combo.getValue()=="") {
			ExtTool.alert("��ʾ","��ѡ����Ա���ͣ�");
			return;
		}
	var temp;
	if(obj.DActive.getValue()==true) {temp="Y";} else {temp="N";};
	var property = '';
	var tmp = temp+'^'+obj.param5.getValue()+'^'+obj.param5.getRawValue()+'^^'+obj.combo.getValue();
	//alert(tmp);

	try
		{  
			var ret = TheOBJ.DoctorSave(selid,tmp,property);	
			//alert(ret);
			//�з��ִ�
			
			var tmp8=ret.split("$")[1];
			ret=ret.split("$")[0]
		//	alert(ret+","+tmp8);
			
			if(ret.split("^")[0] == -1) {
				ExtTool.alert("ʧ��",ret.split("^")[1]);
				return;
			}
			else{
		
				//�����ظ�����	
			  var infoStr=ret.split("^");
	      if (infoStr[0]=="-1") {
	     	ExtTool.alert ("��ʾ", infoStr[1]);
	     	
	     
	      }
			
		
			}
		}catch(err)
		{
			
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
			
		}
		obj.ItemListStore.load({
		params: {
                	start: 0,
                	limit: 500
            	}
	});
	};
	
	obj.ItemList_rowclick = function(g,row,e)
	{	
                if (TheWindowsobj==null){InitWindow8();}	
		TheWindowsobj.Window8.show();
	        //���ڴ������¼��������
	        TheWindowsobj.FormPanel3.getForm().reset();//�������
             
                var record = g.getStore().getAt(row);
		if  (record.get('MActive')=='Y') record.set('MActive',true);
		if  (record.get('MActive')=='N')  record.set('MActive',false); 

		TheWindowsobj.FormPanel3.getForm().loadRecord(record);
	        selid =TheWindowsobj.ID.getValue();
             //   alert(selid );
        
	};
	
	obj.GridPanelED_cellclick = function(g,row,col,e)
        {
         var fieldName = g.getColumnModel().getDataIndex(col);
         if(fieldName!='EditExpression') return;
         var objWindowEx = new InitWindowEx();
         objWindowEx.WindowEx.show();
         var record=g.getStore().getAt(row);
         var ID=record.get("ID");
         objWindowEx.ESourceID.setValue(ID);
         var EType='20011008';
         objWindowEx.EType.setValue(EType);
         objWindowEx.GridPanelExStore.load
         ({
		params:
                {
                	start: 0,
                	limit: 20
            	}
	 });
        };


}

