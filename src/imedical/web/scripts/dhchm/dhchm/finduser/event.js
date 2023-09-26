
function InitWindow8Event(obj)
{
	
	obj.LoadEvent = function(args){};
	
	obj.btAdd_click=function()
	{ 
       var rs=TheWindowsobj.GridPanelES.getSelectionModel().getSelections();
       Ext.each(rs,function(){
       	   try{   //alert(this.get("vName"));
            TheMainobj.GridPanelMS.getStore().add(this);
           }catch(err){alert("不能插入重复数据  "+err.description)};
       })
       
       TheMainobj.GridPanelMS.getSelectionModel().selectAll();
	 /*   
	    var temp;
	    var num=TheWindowsobj.GridPanelES.getStore().getCount(); 
	    //alert(num);
	    if(num>0){
       for(var i=0;i<num;i++)
       {
       	temp=TheWindowsobj.GridPanelES.getStore().getAt(i);
       	//alert(temp.get("vName"));
      // 	if (temp.get("checked")==true) 
       	  try
          {
       	   TheMainobj.GridPanelMS.getStore().add(temp);
       	   }
          catch(err)
          {alert("不能插入重复数据  "+err.description)};
       }
      }
     */ 
      
      
      obj.Window8.setVisible(false);
      obj.GridPanelESStore.load({});
    
	}	
	obj.ButtonES_click= function()
	{/*
		if (obj.ComboBoxHCI.getValue()==""){
			ExtTool.alert("提示","人员分类不能为空");
			return;
		}
		*/
		obj.GridPanelESStore.load({params: {
                	start: 0,
                	limit: 500
            	}});
    //alert(obj.GridPanelESStore.getCount());
	}
  obj.ComboBoxHC_select = function()
	{
		obj.ComboBoxHCI.setValue();
		obj.ComboBoxHCIStore.load({});
	};
  obj.btClose_click = function()
	{
   obj.Window8.setVisible(false);
   obj.GridPanelESStore.load({});
   //obj.Window8.close();
   };
}