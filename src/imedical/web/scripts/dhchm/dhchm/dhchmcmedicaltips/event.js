
function InitViewport1Event(obj) {
	
	var TheOBJ = ExtTool.StaticServerObject("web.DHCHM.BaseDataSet");
	
	var selid="";
	obj.LoadEvent = function(args)
  {};
 //���� 
	obj.btSave_click = function()
	{ 	
		
		var separete = '^';
		var tmp ='';
		 
		if(obj.MTCode.getValue()=="") {
			ExtTool.alert("��ʾ","���벻��Ϊ�գ�");
			return;
		}
                if(obj.MTDesc.getValue()=="") {
			ExtTool.alert("��ʾ","��ʾ��������Ϊ�գ�");
			return;
		}
		if(obj.MTDetail.getValue()=="") {
			ExtTool.alert("��ʾ","��ʾ���ݲ���Ϊ�գ�");
			return;
		}
		
		
		if (obj.MTActive.getValue()==false ) tmp += 'N'+ separete; else tmp += 'Y'+ separete;			
                tmp += obj.MTCode.getValue()+ separete;
		tmp += obj.MTDesc.getValue()+ separete;
		tmp += obj.MTDetail.getValue()+ separete;
		tmp += obj.MTRemark.getValue();
		

		try
		{       
			 
	//alert(selid);
	//alert(tmp);
	//alert(obj.ID.getValue());
		 var ret = TheOBJ.CMedicalTipsSaveData(selid,tmp,obj.MTAlias.getValue());	
	//alert(ret);
		 if(ret<0) {
		   ExtTool.alert("��ʾ","����ʧ�ܣ�");
		   return;
		  }else{
			//�����ظ�����	
		  	var infoStr=ret.split("^");
	                if (infoStr[0]=="-1") {
	  	            ExtTool.alert ("��ʾ", infoStr[1]);
	                }else{
	      		  //�˴����ø��� �� �½�֮��� GRID��ʾ ��������� λ����ǰ�ȣ�
			  obj.ID.setValue(ret);
			  //alert(obj.ID.getValue()+"x");
			  //obj.btFind_click();
			  ExtTool.FormToGrid(selid,obj.ItemList,obj.FormPanel3);
			  obj.btCancel_click();
			}
	   }
		}catch(err)
		{
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}
		
	};
	obj.btCancel_click = function()
	{ 
		obj.FormPanel3.getForm().reset();
		selid="";obj.ID.setValue(selid);
		obj.MTCode.focus(true,3);
	};
	obj.btFind_click = function()
	{
		obj.ItemListStore.load({params: {start: 0,limit: 15}
	});
	};
	obj.ItemList_rowclick = function(g,row,e)
	{
		var record = g.getStore().getAt(row);
		if  (record.get('MTActive')=='Y') record.set('MTActive',true);
		if  (record.get('MTActive')=='N')  record.set('MTActive',false); 
	//	alert(record.get('MTActive'));
		obj.FormPanel3.getForm().loadRecord(record);
		
		//�������� ���ȡID
		// selid = g.getSelectionModel().getSelected().id;
		 selid =obj.ID.getValue();
	//	obj.FormPanel3.buttons[0].setText('����');
	//�����������ֶ�
	 //  obj.MTAlias.setValue(TheOBJ.GetCAlias('50011006',selid));
	
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
var EType='20011006';
objWindowEx.EType.setValue(EType);
objWindowEx.GridPanelExStore.load({
		params: {
                	start: 0,
                	limit: 5
            	}
	});
};
/*Viewport1��������ռλ��*/


































































































































































































































}

