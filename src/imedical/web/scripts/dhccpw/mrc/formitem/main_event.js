function InitviewScreenEvents(obj){
	obj.LoadEvents = function(){
		obj.gridFormItemStore.load({});
		obj.gridFormItem.on("rowdblclick",obj.gridFormItem_rowdblclick,obj);
		obj.gridFormItem.on("rowclick",obj.gridFormItem_rowclick,obj);
		obj.gridFormItem.on("cellclick",obj.gridFormItem_cellclick,obj);
		obj.btnAdd.on("click",obj.btnAdd_click,obj);
		obj.btnDelete.on("click",obj.btnDelete_click,obj);
		obj.btnUpdate.on("click",obj.btnUpdate_click,obj);
		
		Common_SetDisabled('btnUpdate',true);
		Common_SetDisabled('btnDelete',true);
	}
	
	obj.gridFormItem_rowclick = function(){
		var rowIndex=arguments[1];
		obj.GridRowSelect(rowIndex);
	}
	
	obj.GridRowSelect = function(rowIndex){
		var rd = obj.gridFormItem.getStore().getAt(rowIndex);
		if (rd){
			obj.currRowIndex = rowIndex;
			Common_SetValue('txtItemDesc',rd.get('ItemDesc'));
			Common_SetValue('txtGroupNo',rd.get('GroupNo'));
			Common_SetValue('cboItemSubCat',rd.get('SubCatID'),rd.get('SubCatDesc'));
			
			if (obj.IsReadOnly) {
				Common_SetDisabled('btnAdd',true);
				Common_SetDisabled('btnUpdate',true);
				Common_SetDisabled('btnDelete',true);
			}
			else {
				Common_SetDisabled('btnUpdate',false);
				Common_SetDisabled('btnDelete',false);
			}
		}
	}
	
	obj.ClearCmpListVal = function(){
		Common_SetValue('txtItemDesc','');
		Common_SetValue('txtGroupNo','');
		Common_SetValue('cboItemSubCat','','');
		
		Common_SetDisabled('btnUpdate',true);
		Common_SetDisabled('btnDelete',true);
	}
	
	obj.SaveFormItem = function(ItemSub){
		var ItemDesc = Common_GetValue('txtItemDesc');
		var GroupNo = Common_GetValue('txtGroupNo');
		var SubCatID = Common_GetValue('cboItemSubCat');
		var SubCatDesc = Common_GetText('cboItemSubCat');
		if (ItemDesc == ''){
			ExtTool.alert("提示","项目名称为必填项,请认真检查!");
	  		return false;
		}
		if ((SubCatID == '')||(SubCatDesc == '')){
			ExtTool.alert("提示","项目分类为必填项,请认真检查!");
	  		return false;
		}
		
		if (ItemSub == ''){
			//新建项目，自动生成分组号
			GroupNo = 0;
			var objStore = obj.gridFormItem.getStore();
			for (var rowIndex = 0; rowIndex < objStore.getCount(); rowIndex++){
				var rd = objStore.getAt(rowIndex);
				if (SubCatID.split('||')[0] != rd.get('CatID')) continue;
				var tmpGroupNo = rd.get('GroupNo')
				if (GroupNo < parseInt(tmpGroupNo)){
					GroupNo = parseInt(tmpGroupNo);
				}
			}
			GroupNo++;
			//新建项目，根据项目描述关键字判断是否可选项
			var IsOptional = 0;
			if ((ItemDesc.indexOf('可选') > -1)||(ItemDesc.indexOf('必要时') > -1)){
				var IsOptional = 1;
			}
		} else {
			if (GroupNo == ''){
				ExtTool.alert("提示","分组号为必填项,请认真检查!");
				return false;
			}
			var rd = obj.gridFormItem.getStore().getAt(obj.currRowIndex);
			var IsOptional = rd.get('IsOptional');
		}
		
		var inputStr = FormStepID
			+ '^' + ItemSub
			+ '^' + ItemDesc
			+ '^' + SubCatID
			+ '^' + (IsOptional==true ? 1 : 0)
			+ '^' + GroupNo    //分组号
		
		var ret = ExtTool.RunServerMethod("DHCCPW.MRC.FORM.ItemEditSrv","SaveFormItem",inputStr);
		if (parseInt(ret)<1){
			ExtTool.alert("提示","保存表单项目错误!");
	  		return false;
		}
		return true;
	}
	
	obj.btnAdd_click = function(){
		var ret = obj.SaveFormItem('');
		if (ret == true){
			obj.currRowIndex = '';
			Common_LoadCurrPage('gridFormItem');
			obj.ClearCmpListVal();
		}
	}
	
	obj.btnUpdate_click = function(){
		var ItemSub = '';
		var rd = obj.gridFormItem.getStore().getAt(obj.currRowIndex);
		if (rd){
			var ItemID = rd.get('ItemID');
			ItemSub = ItemID.split('||')[3];
		}
		var ret = obj.SaveFormItem(ItemSub);
		if (ret == true){
			Common_LoadCurrPage('gridFormItem');
			obj.ClearCmpListVal();
		}
	}
	
	obj.btnDelete_click = function(){
		Ext.MessageBox.confirm('提示', '确认是否删除当前表单项目?', function(btn,text){
			if(btn=="yes"){
				var ItemID = '';
				var rd = obj.gridFormItem.getStore().getAt(obj.currRowIndex);
				if (rd){
					ItemID = rd.get('ItemID');
				}
				var ret = ExtTool.RunServerMethod("DHCCPW.MRC.FORM.ItemEditSrv","DeleteFormItem",ItemID);
				if (parseInt(ret)<1){
					ExtTool.alert("提示","删除表单项目错误!");
					return false;
				} else {
					obj.currRowIndex = '';
					Common_LoadCurrPage('gridFormItem');
					obj.ClearCmpListVal();
				}
			}
		});
	}
	
	obj.ChangeGroupNo = function(FromItemID,ToItemID){
		if ((FromItemID == '')||(ToItemID == '')) return false;
		var ret = ExtTool.RunServerMethod("DHCCPW.MRC.FORM.ItemEditSrv","ChangeGroupNo",FromItemID,ToItemID);
		if (parseInt(ret)<1){
			ExtTool.alert("提示","向上、向下移动保存错误!");
			return false;
		} else {
			obj.currRowIndex = '';
		}
		return true;
	}
	
	obj.MergeGroupNo = function(FromItemID,ToItemID){
		if ((FromItemID == '')||(ToItemID == '')) return false;
		var ret = ExtTool.RunServerMethod("DHCCPW.MRC.FORM.ItemEditSrv","MergeGroupNo",FromItemID,ToItemID);
		if (parseInt(ret)<1){
			ExtTool.alert("提示","合并表单项目保存错误!");
			return false;
		} else {
			obj.currRowIndex = '';
		}
		return true;
	}
	
	obj.gridFormItem_rowdblclick = function()
	{
		var index=arguments[1];
		var rd = obj.gridFormItem.getStore().getAt(index);
		if (rd){
			var ItemID = rd.get("ItemID");
			var CatDesc = rd.get("CatDesc");
			if (CatDesc.indexOf('重点医嘱')>-1){
				var url="dhccpw.mrc.formitemarc.csp?1=1&FormItemID=" + ItemID + "&ReadOnly=" + ReadOnly + "&2=2";
				var oWin = window.open(url,'',"height=" + (window.screen.availHeight - 100) + ",width=" + (window.screen.availWidth - 100) + ",top=20,left=50,resizable=no");
			}
		}
	}
	
	obj.gridFormItem_cellclick = function(grid, rowIndex, columnIndex, e){
		var objRec = grid.getStore().getAt(rowIndex);
	    var fieldName = grid.getColumnModel().getDataIndex(columnIndex);
		if (fieldName != 'IsOptional'){
			return;
		}
	    var recValue = objRec.get(fieldName);
		if (recValue == '1') {
			var newValue = '0';
		} else {
			var newValue = '1';
		}
		
		var ItemID = objRec.get('ItemID');
		if (fieldName == 'IsOptional'){
			var ret = ExtTool.RunServerMethod("DHCCPW.MRC.FORM.ItemEditSrv","UpdateIsOptional",ItemID,newValue);
			if (parseInt(ret)<1){
				ExtTool.alert("提示","可选项设置错误!");
				return false;
			} else {
				obj.currRowIndex = '';
				obj.gridFormItem.getStore().load({
					callback : function(o,response,success) {
						if (success){
							var rowIndex = obj.gridFormItem.getStore().find('ItemID',ItemID);
							obj.gridFormItem.getSelectionModel().selectRow(rowIndex,true);
							obj.GridRowSelect(rowIndex);
						}
					}
				});
			}
		}
		return true;
	}
}
