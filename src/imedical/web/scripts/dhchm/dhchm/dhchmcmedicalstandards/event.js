function InitWindow8Event(obj)
{
	var TheOBJ = ExtTool.StaticServerObject("web.DHCHM.BaseDataSet");
	var selid="";
	obj.LoadEvent = function(args){};
  

	obj.btSave_click = function()
	{ 
		var separete = '^';
		var tmp ='';
		if(obj.MSCode.getValue()=="") {
			ExtTool.alert("��ʾ","���벻��Ϊ�գ�");
			return;
		}
		if(obj.MSDesc.getValue()=="") {
			ExtTool.alert("��ʾ","��������Ϊ�գ�");
			return;
		}
				
		if (obj.MSActive.getValue()==false ) 		tmp += 'N'+ separete; else tmp += 'Y'+ separete;		
    tmp += obj.MSCode.getValue()+ separete;
		tmp += obj.MSDesc.getValue()+ separete;
    if (obj.MSNatureValue.getValue()==false ) 		tmp += 'N'+ separete; else tmp += 'Y'+ separete;	
		tmp += obj.MSRemark.getValue();
		
                selid =TheWindowsobj.ID.getValue();	
		try
		{    
			
			var ret = TheOBJ.CMedicalStandardsSaveData(selid,tmp,"");	
			
			if(ret<0) {
				ExtTool.alert("��ʾ","����ʧ�ܣ�");
				return;
			}
			else{
                          TheWindowsobj.Window8.setVisible(false);
			  //�����ظ�����	
			  var infoStr=ret.split("^");
	      if (infoStr[0]=="-1") {
	  	  ExtTool.alert ("��ʾ", infoStr[1]);	
		    }else
		    {//obj.ItemListStore.load();
				//�˴����ø��� �� �½�֮��� GRID��ʾ ��������� λ����ǰ�ȣ�
				
			  obj.ID.setValue(ret);
				ExtTool.FormToGrid(selid,TheMainobj.ItemList,obj.FormPanel3);
		    	
		}
		obj.btCancel_click();
			}
		}catch(err)
		{
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}
		
	};
	obj.btCancel_click = function()
	{obj.FormPanel3.getForm().reset();
		selid="";obj.ID.setValue(selid);
		  obj.MSCode.focus(true,3); 
		
	};


}







function InitViewport1Event(obj) {
	
	var TheOBJ = ExtTool.StaticServerObject("web.DHCHM.BaseDataSet");
	var selid="";
	obj.LoadEvent = function(args)
  {};
  
	obj.btFind_click = function()
	{obj.ItemListStore.load({
		params: {
                	start: 0,
                	limit: 20
            	}
	});
	};

        obj.btNew_click = function()
	{
          if (TheWindowsobj==null){InitWindow8();} selid="";
          TheWindowsobj.Window8.show();
          TheWindowsobj.FormPanel3.getForm().reset();
	  selid="";TheWindowsobj.ID.getValue(selid);
	};

	obj.ItemList_rowclick = function(g,row,e)
	{ 
                if (TheWindowsobj==null){InitWindow8();}	
		TheWindowsobj.Window8.show();
	        //���ڴ������¼��������
	        TheWindowsobj.FormPanel3.getForm().reset();//�������

		var record = g.getStore().getAt(row);
		if  (record.get('MSActive')=='Y') record.set('MSActive',true); 
		if  (record.get('MSActive')=='N') record.set('MSActive',false); 
		if  (record.get('MSNatureValue')=='Y') record.set('MSNatureValue',true);
		if  (record.get('MSNatureValue')=='N')  record.set('MSNatureValue',false); 
		
                TheWindowsobj.FormPanel3.getForm().loadRecord(record);
	        selid =TheWindowsobj.ID.getValue();
		
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
var EType='20011007';
objWindowEx.EType.setValue(EType);
objWindowEx.GridPanelExStore.load({
		params: {
                	start: 0,
                	limit: 20
            	}
	});
};
/*Viewport1��������ռλ��*/



































































































































































































































}

