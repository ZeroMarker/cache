/*      Desc: 改造原组件界面【字典管理】组件名称：PMP.Dictionary3 
    Function: 处理原组件界面按钮事件
      Author：liubaoshi
        Date: 2015-04-02
*/
function InitViewportEvent(obj) {	
	obj.LoadEvent = function(){};
	//保存
	obj.btnSave_click = function()	
	{	
		var selectObj = obj.gridList.getSelectionModel().getSelected();	
		var Id=""
		if(selectObj){	
			var Id=selectObj.get("RowID")
		}
		var bodyCode=obj.bodyCode.getValue();	//代码
		var bodyDesc=obj.bodyDesc.getValue();	//描述
		var bodyNote=obj.bodyNote.getValue();	//备注
		var bodyType=obj.bodyType.getValue();	//类型
		var bodyStr=bodyType+"^"+bodyCode+"^"+bodyDesc+"^"+bodyNote+"^"+Id+"^"+"Insert";
		alert(bodyStr);
		if(bodyType==""||bodyCode==""||bodyDesc==""){
			ExtTool.alert("提示","类型、代码、描述不能为空!");
			return;
		}
		var bodyOBJ = ExtTool.StaticServerObject("web.PMP.PMPDictionary");	
		var ret = bodyOBJ.Update(bodyStr);
		if (ret==9){   //原程序返回9为成功
			ExtTool.alert("提示","保存成功!");
		}else{
			ExtTool.alert("提示","添加失败!");
		}
		obj.clear(); 
	};
	obj.bodyCode_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.btnSch_click();
	};
	};
	obj.bodyDesc_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.btnSch_click();
	};
	};
	obj.bodyNote_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.btnSch_click();
	};
	};
	obj.bodyType_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.btnSch_click();
	};
	};
	//删除【原增删改查程序过于累赘,增加DelInfo方法】
	/*
	obj.btnDel_click  = function(){
	    //alert("删除??");{return}
		var selectObj = obj.gridList.getSelectionModel().getSelected();
		if (selectObj){
			Ext.MessageBox.show({
		    	title:'提示',
		    	msg:'你确定要删除么？',
		    	modal:true,
		    	width:260,
				fn:callBack,
		    	icon:Ext.Msg.INFO,
		    	buttons:Ext.Msg.OKCANCEL	
				//buttons:Ext.Msg.YESNOCANCEL
			});
			function callBack(btn){
				if(btn=="ok"){
					var DelOBJ = ExtTool.StaticServerObject("web.PMP.PMPDictionary");
					var ret = DelOBJ.DelInfo(selectObj.get("RowID"));
					if (ret==0){
						ExtTool.alert("提示","删除成功!");
					}else{
						ExtTool.alert("提示","删除失败!");
					}
					obj.clear();
				}		
			}  
		}else{
			ExtTool.alert("提示","请先选中一行!");
		}
	};
	*/
	//删除
	obj.btnDel_click  = function(){
		var selectObj = obj.gridList.getSelectionModel().getSelected();
		if (selectObj){
			Ext.MessageBox.show({
		    	title:'提示',
		    	msg:'你确定要删除么？',
		    	modal:true,
		    	width:260,
				fn:callBack,
		    	icon:Ext.Msg.INFO,
				//icon : Ext.Msg.WARNING,
		    	buttons:Ext.Msg.OKCANCEL	
				//buttons:Ext.Msg.YESNOCANCEL
			});
			function callBack(btn){
				if(btn=="ok"){
					var Id=selectObj.get("RowID");
					var DTYFlag=selectObj.get("DTYFlag");
					var DTYCode=selectObj.get("DTYCode");
					var DTYDesc=selectObj.get("DTYDesc");
					var DTYRemark=selectObj.get("DTYRemark");
					var DelStr=DTYFlag+"^"+DTYCode+"^"+DTYDesc+"^"+DTYRemark+"^"+Id+"^"+"Delete";
					var DelOBJ = ExtTool.StaticServerObject("web.PMP.PMPDictionary");
					var ret = DelOBJ.Update(DelStr);
					if (ret==5){
						ExtTool.alert("提示","删除成功!");
					}else{
						ExtTool.alert("提示","删除失败!");
					}
					obj.clear();
				}		
			}  
		}else{
			ExtTool.alert("提示","请先选中一行!");
		}
	};
	//更新
	obj.btnUpdate_click  = function(){
		var selectObj = obj.gridList.getSelectionModel().getSelected();
		if (selectObj){
			Ext.MessageBox.show({
		    	title:'提示',
		    	msg:'你确定要更新么？',
		    	modal:true,
		    	width:260,
				fn:callBack,
		    	icon:Ext.Msg.INFO,
		    	buttons:Ext.Msg.OKCANCEL	
				//buttons:Ext.Msg.YESNOCANCEL
			});
			function callBack(btn){
				if(btn=="ok"){
					var Id=selectObj.get("RowID");
					var bodyCode=obj.bodyCode.getValue();	//代码
					var bodyDesc=obj.bodyDesc.getValue();	//描述
					var bodyNote=obj.bodyNote.getValue();	//备注
					var bodyType=obj.bodyType.getRawValue();	//类型
					var UpdateStr=bodyType+"^"+bodyCode+"^"+bodyDesc+"^"+bodyNote+"^"+Id+"^"+"Update";
					alert(UpdateStr);
					var Updateobj = ExtTool.StaticServerObject("web.PMP.PMPDictionary");
					var ret = Updateobj.Update(UpdateStr);
					if (ret==4){
						ExtTool.alert("提示","更新成功!");
					}
					if (ret==3){
						ExtTool.alert("提示","数据完全一致,不用更新!");
					}
					obj.clear();
				}		
			}  
		}else{
			ExtTool.alert("提示","请先选中一行!");
		}
	};
	
	obj.gridList_rowclick=function()        
	{
		var selectObj = obj.gridList.getSelectionModel().getSelected();
		if (selectObj)
	    {
		    var DTYCode=selectObj.get('DTYCode');
		    var DTYDesc=selectObj.get('DTYDesc');
		    var DTYFlag=selectObj.get('DTYFlag');
		    var DTYRemark=selectObj.get('DTYRemark');
		    var RowID=selectObj.get('RowID');
			var Flagobj = ExtTool.StaticServerObject("web.PMP.PMPDictionary");
			var Flag = Flagobj.CheckSelect(DTYFlag);
			Ext.getDom('bodyCode').value=DTYCode;
			Ext.getDom("bodyDesc").value=DTYDesc;
			Ext.getDom("bodyType").value=Flag;
			Ext.getDom("bodyNote").value=DTYRemark;
	    }
	};
	//导入Excel数据
	obj.btnInput_click= function()
	{
	var lnk="PMPDictionary.CSP"
	var nwin="scrollbars=yes,top=0,left=0,width=900,height=600"
	window.open(lnk,'_blank',nwin);
	}
	//查询
	obj.btnSch_click = function(){
		obj.gridListStore.removeAll();
		obj.gridListStore.load({params : {start:0,limit:20}});
	};
	//清屏
    obj.btnClear_click = function(){
		obj.clear();
	};
	//右键
	obj.rightClickFn_click = function (gridList,rowIndex,e){ 
		obj.gridList.getSelectionModel().selectRow(rowIndex);
        e.preventDefault(); 
        obj.RightMenu.showAt(e.getXY());    //获取坐标
    };
	//窗体
	obj.btnSave1_click= function()
	{
		var objWinAdd = new InitwinScreen();
		objWinAdd.windictionary.show();
	};
	//更新
	obj.btnUpdate1_click=function()
	{
		var winselectObj = obj.gridList.getSelectionModel().getSelected();
		if (winselectObj)
		{
				var objWinAdd = new InitwinScreen(winselectObj);
				objWinAdd.windictionary.show();
				var wingridId = winselectObj.get("RowID");
				var wingridbodyType = winselectObj.get("DTYFlag");	        //类型
				var wingridbodyCode = winselectObj.get("DTYCode");	        //代码
				var wingridbodyDesc = winselectObj.get("DTYDesc");	        //描述
				var wingridbodyNote = winselectObj.get("DTYRemark");	    //备注
					
				objWinAdd.winRowid.setValue(wingridId);
				objWinAdd.winbodyType.setValue(wingridbodyType);
				objWinAdd.winbodyCode.setValue(wingridbodyCode);
				objWinAdd.winbodyDesc.setValue(wingridbodyDesc);
				objWinAdd.winbodyNote.setValue(wingridbodyNote);
		}
		else
		{
			Ext.Msg.show({
	        title : '提示',
			msg : '请选择需要修改的数据!',
			icon : Ext.Msg.WARNING,
			buttons : Ext.Msg.OK
			  });
		}		
	};
	//双击
	obj.gridList_rowclick=function(rowIndex,columnIndex,e){
	obj.btnUpdate1_click();
	};
	
	obj.clear = function(){
		Ext.getCmp('bodyCode').setValue("");
		Ext.getCmp('bodyDesc').setValue("");
		Ext.getCmp('bodyNote').setValue("");
		Ext.getCmp('bodyType').setValue("");
		obj.gridListStore.removeAll();
		obj.gridListStore.load({params : {start:0,limit:20}});
	}
}
//窗体事件处理
function InitwinScreenEvent(obj)
{
	obj.LoadEvent = function(){};
	var parent=objControlArry['Viewport'];
	
	obj.winSave_click=function()
	{	
		var winbodyOBJ = ExtTool.StaticServerObject("web.PMP.PMPDictionary");
		var winType=obj.winbodyType.getValue();	//类型
		if (winType=="") {ExtTool.alert("提示","请选择字典类型！");return;}
		var winCode=obj.winbodyCode.getValue();	//代码
		if (winCode=="") {ExtTool.alert("提示","请填写字典代码！");return;}
		var winDesc=obj.winbodyDesc.getValue();	//描述
		if (winDesc=="") {ExtTool.alert("提示","请填写字典描述！");return;}
		var winNote=obj.winbodyNote.getValue();	//描述
		var winStr=winType+"^"+winCode+"^"+winDesc+"^"+winNote;
		try
		{
			if(obj.winRowid.getValue()=="")
			{
				var Id=""
				var winSaveStr=winStr+"^"+Id+"^"+"Insert";
				var ret = winbodyOBJ.Update(winSaveStr);
				if (ret==9){   
						ExtTool.alert("提示","保存成功!");
					}else{
						ExtTool.alert("提示","添加失败!");
				}
				obj.windictionary.close();
				parent.gridListStore.removeAll();
				parent.gridListStore.load({});
			}
			else 
			{

				var winUpdateStr=winStr+"^"+obj.winRowid.getValue()+"^"+"Update";
				var ret = winbodyOBJ.Update(winUpdateStr);
				if (ret==4){
					ExtTool.alert("提示","更新成功!");
					}
					if (ret==3){
						ExtTool.alert("提示","数据完全一致,不用更新!");
					}
				obj.windictionary.close();
				parent.gridListStore.removeAll();
				parent.gridListStore.load({});
			}
		}
		catch(err)
		{
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}
	}
	obj.winclear = function(){
		Ext.getCmp('winbodyType').setValue("");
		Ext.getCmp('winbodyCode').setValue("");
		Ext.getCmp('winbodyDesc').setValue("");
		Ext.getCmp('winbodyNote').setValue("");
	}
	
	obj.winCancel_click=function()
		{
		obj.windictionary.close();
		};

}