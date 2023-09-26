
function InitViewport1Event(obj) {

	obj.LoadEvent = function(args)
    {
    	obj.gridListStore.load();
		obj.gridList.on("rowdblclick",obj.gridList_rowdblclick,obj);
  	};
	
	obj.gridList_rowdblclick = function(g,r)
	{	
		var objRec = obj.gridListStore.getAt(r);
		//alert(objRec.get("ID"));
		var objFrmEdit = new InitWinCateEdit(objRec.get("ID"),obj.CateCode,obj);
		objFrmEdit.winEdit.show();
	};
}

function InitwinEditEvent(obj) {
	//加载类方法
	obj.CateService = ExtTool.StaticServerObject("DHCMed.NINF.Dic.Cate");
	obj.LoadEvent = function(args)
    {
		obj.btnSave.on("click", obj.btnSave_click, obj);
		obj.btnCancel.on("click", obj.btnCancel_click, obj);
		
    	obj.CateID = args[0];
    	obj.CateCode = args[1];
    	obj.ParentWin = args[2];
    	if (obj.CateID!="") {
			obj.LoadData(obj.CateID);
		}
  	};
	
	//加载数据
	obj.LoadData = function(ID){
		var strCate = obj.CateService.GetStringById(ID, "^");
		if (strCate != "") {
			var arryFields = strCate.split("^");
			obj.CateCode = arryFields[3];
			obj.Code.setValue(arryFields[1]);
			obj.Code.setDisabled(true);
			obj.Description.setValue(arryFields[2]);
			obj.Active.setValue(arryFields[5] == "1");
			obj.DateFrom.setRawValue(arryFields[6]);
			obj.DateTo.setRawValue(arryFields[7]);
			obj.HispsDescsStore.load({
				callback: function(){
					obj.HispsDescs.setValue(arryFields[4]);
				}
			})
		} else {
			obj.Code.setValue('');
			obj.Code.setReadOnly(true);
			obj.Code.setDisabled(true);
			obj.Description.setValue('');
			obj.Active.setValue(1);
			obj.DateFrom.setRawValue('');
			obj.DateTo.setRawValue('');
			obj.HispsDescsStore.load({
				callback: function(){
					obj.HispsDescs.setValue('');
					obj.HispsDescs.setRawValue('');
				}
			})
		}
	}
	
	obj.btnSave_click = function(){
		var itemCode = obj.Code.getValue();
		var itemDesc = obj.Description.getValue();
        if (itemDesc == '') {
			ExtTool.alert("提示","描述不能为空！");   //update by likai for bug:3817
			return;
		}
		
      	var separete = "^";
		var tmp = obj.CateID + separete;
		tmp += itemCode + separete;
		tmp += itemDesc + separete;
		tmp += obj.CateCode + separete;
   		tmp += obj.HispsDescs.getValue() + separete;
		tmp += (obj.Active.getValue()? "1" : "0") + separete;
		tmp += obj.DateFrom.getRawValue() + separete;
	 	tmp += obj.DateTo.getRawValue() + separete;
	    
		var ret = obj.CateService.Update(tmp,separete);		
		if(ret<0) {
			if (ret == -2) {
				ExtTool.alert("提示","已维护分类项目，不允许再新建子分类!");
			} else {
				ExtTool.alert("提示","保存失败！");
			}
			return;
		}
		else {
			if (obj.ParentWin.gridListStore) {obj.ParentWin.gridListStore.load()}
			if (obj.ParentWin.dicTreeLoader) {
				var s = obj.ParentWin.objSelNode.parentNode;
				obj.ParentWin.dicTreeLoader.load(s,
					function(objNode) {
						s.expand();
					}
				);
				
			}
			obj.winEdit.close();
		}			
	}
	
	obj.btnCancel_click = function(){
		obj.winEdit.close();
	}
}

