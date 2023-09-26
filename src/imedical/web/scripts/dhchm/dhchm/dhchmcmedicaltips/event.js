
function InitViewport1Event(obj) {
	
	var TheOBJ = ExtTool.StaticServerObject("web.DHCHM.BaseDataSet");
	
	var selid="";
	obj.LoadEvent = function(args)
  {};
 //保存 
	obj.btSave_click = function()
	{ 	
		
		var separete = '^';
		var tmp ='';
		 
		if(obj.MTCode.getValue()=="") {
			ExtTool.alert("提示","代码不能为空！");
			return;
		}
                if(obj.MTDesc.getValue()=="") {
			ExtTool.alert("提示","提示描述不能为空！");
			return;
		}
		if(obj.MTDetail.getValue()=="") {
			ExtTool.alert("提示","提示内容不能为空！");
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
		   ExtTool.alert("提示","保存失败！");
		   return;
		  }else{
			//代码重复报错	
		  	var infoStr=ret.split("^");
	                if (infoStr[0]=="-1") {
	  	            ExtTool.alert ("提示", infoStr[1]);
	                }else{
	      		  //此处设置更新 和 新建之后的 GRID显示 （插入更新 位置提前等）
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
		
		//这里设置 点击取ID
		// selid = g.getSelectionModel().getSelected().id;
		 selid =obj.ID.getValue();
	//	obj.FormPanel3.buttons[0].setText('更新');
	//以下填充别名字段
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
/*Viewport1新增代码占位符*/


































































































































































































































}

