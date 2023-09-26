
function InitViewport1Event(obj) {
	//加载类方法
	obj.MRBsService = ExtTool.StaticServerObject("DHCMed.NINF.Dic.MRB");
	
	obj.LoadEvent = function(args)
    {
		obj.btnUpdate.on("click",obj.btnUpdate_click,obj);
		obj.gridMRBs.on("rowclick",obj.gridMRBs_rowclick,obj);
		
		obj.cboPYCate.on("change",obj.cboPYCate_change,obj);
		obj.cboPYCate.on("select",obj.cboPYCate_change,obj);
		
		obj.cboANTCate.on("change",obj.cboANTCate_change,obj);
		obj.cboANTCate.on("select",obj.cboANTCate_select,obj);
		
		obj.cboANTDic.on("select",obj.cboANTDic_select,obj);
		
		Ext.getCmp("multiANTCate").on("dblclick",obj.multiList_dblclick,obj);
		Ext.getCmp("multiANTDic").on("dblclick",obj.multiList_dblclick,obj);
		
		obj.gridMRBsStore.load();
  	};
	
	obj.ClearFormItem = function()
	{
		obj.RecRowID = "";
		Common_SetValue("txtCode","");
		Common_SetValue("txtDesc","");
		Common_SetValue("txtResume","");
		Common_SetValue("chkIsActive",false);
		Common_SetValue("cboPYCate","","");
		Common_SetValue("cboPYDic","","");
		Common_SetValue("cboANTCate","","");
		Common_SetValue("cboANTDic","","");
		Common_SetValue("numANTCate","");
		Common_SetValue("numANTDic","");
		Common_SetValue("chkANTCate",false);
		Common_SetValue("chkANTDic",false);
		obj.dsANTCate.removeAll();
		obj.dsANTDic.removeAll();
	}
	
	obj.btnUpdate_click = function()
	{
		var errinfo = "";
		var formEdit = Ext.getCmp("formEdit");
		var dataRef = formEdit.getForm().getValues();
		
		if (!dataRef.txtCode) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!dataRef.txtDesc) {
			errinfo = errinfo + "名称为空!<br>";
		}
		if ((!dataRef.chkANTCate)&(!dataRef.chkANTDic)) {
			//errinfo = errinfo + "耐药规则为空!<br>";
		}
		if (errinfo) {
			ExtTool.alert("错误提示",errinfo);
			return;
		}
		var IsActive = Common_GetValue("chkIsActive");
		
		var AntiCateCode = "";
		if (dataRef.chkANTCate){
			AntiCateCode = (dataRef.chkANTCate=="on" ? '1' : '0');
		}else{
			AntiCateCode = "0"
		}
		AntiCateCode = AntiCateCode + CHR_2 + parseInt((dataRef.numANTCate=="")?0:dataRef.numANTCate);
		AntiCateCode = AntiCateCode + CHR_2 + obj.getKeysFromDataStore(obj.dsANTCate,"ID");
		
		var AntiCode = "";
		if (dataRef.chkANTDic){
			AntiCode = (dataRef.chkANTDic=="on" ? '1' : '0');
		}else{
			AntiCode = "0"
		}
		AntiCode = AntiCode + CHR_2 + parseInt((dataRef.numANTDic=="")?0:dataRef.numANTDic);
		AntiCode = AntiCode + CHR_2 + obj.getKeysFromDataStore(obj.dsANTDic,"ID");
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + dataRef.txtCode;
		inputStr = inputStr + CHR_1 + dataRef.txtDesc;
		inputStr = inputStr + CHR_1 + (IsActive ? '1' : '0');
		inputStr = inputStr + CHR_1 + obj.cboPYCate.getValue();
		inputStr = inputStr + CHR_1 + '';
		inputStr = inputStr + CHR_1 + obj.cboPYDic.getValue();
		inputStr = inputStr + CHR_1 + AntiCateCode;
		inputStr = inputStr + CHR_1 + '';
		inputStr = inputStr + CHR_1 + AntiCode;
		inputStr = inputStr + CHR_1 + dataRef.txtResume;
		//alert(inputStr);
		
		var flg = obj.MRBsService.Update(inputStr,CHR_1);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == -100) {
				ExtTool.alert("错误提示","数据重复!Error=" + flg);
			} else {
				ExtTool.alert("错误提示","更新数据错误!Error=" + flg);
			}
			return;
		}
		
		obj.ClearFormItem();
		Common_LoadCurrPage("gridMRBs");
	}
	
	obj.gridMRBs_rowclick = function()
	{
		var index=arguments[1];
		var objRec = obj.gridMRBs.getStore().getAt(index);
		if (objRec.get("ID") == obj.RecRowID) {
			obj.ClearFormItem();
		} else {
			obj.ClearFormItem();
			obj.RecRowID = objRec.get("ID");
			Common_SetValue("txtCode",objRec.get("Code"));
			Common_SetValue("txtDesc",objRec.get("Description"));
			Common_SetValue("txtResume",objRec.get("Resume"));
			Common_SetValue("chkIsActive",(objRec.get("Active")=='1'));
			var strData = obj.MRBsService.GetStringById(obj.RecRowID,CHR_1)
			var arrData = strData.split(CHR_1);
			
			Common_SetValue("cboPYCate",arrData[4].split("!!")[0],arrData[4].split("!!")[1]);
			Common_SetValue("cboPYDic",arrData[6].split("!!")[0],arrData[6].split("!!")[1]);
			
			var arrANTCate = arrData[7].split(CHR_2);
			Common_SetValue("chkANTCate",(arrANTCate[0]=='1'));
			Common_SetValue("numANTCate",arrANTCate[1]);
			if (arrANTCate.length>2) {
				var arrANTCateList = arrANTCate[2].split(",");
				obj.dsANTCate.removeAll();
				for (var i=0;i<arrANTCateList.length;i++){
					obj.dsAddRecord(obj.dsANTCate,{"ID":arrANTCateList[i].split("!!")[0],"Description":arrANTCateList[i].split("!!")[1]})
				}
			}
			
			var arrANT = arrData[9].split(CHR_2);
			Common_SetValue("chkANTDic",(arrANT[0]=='1'));
			Common_SetValue("numANTDic",arrANT[1]);
			if (arrANTCate.length>2) {
				var arrANTList = arrANT[2].split(",");
				obj.dsANTDic.removeAll();
				for (var i=0;i<arrANTList.length;i++){
					obj.dsAddRecord(obj.dsANTDic,{"ID":arrANTList[i].split("!!")[0],"Description":arrANTList[i].split("!!")[1]})
				}
			}
		}
	};
	
	obj.cboPYCate_change = function(){
		Common_SetValue("cboPYDic","");
		obj.cboPYDic.getStore().load();
	}
	
	obj.cboANTCate_change = function(){
		Common_SetValue("cboANTDic","");
		obj.cboANTDic.getStore().load();
	}
	
	obj.cboANTCate_select = function(t,r,i){
		//启用抗生素分类,才加载到列表框
		if (Common_GetValue("chkANTCate")) {
			obj.dsAddRecord(obj.dsANTCate,{ID:r.get("ID"),Description:r.get("Description")});
		}
		Common_SetValue("cboANTDic","");
		obj.cboANTDic.getStore().load();
	}
	obj.cboANTDic_select = function(t,r,i){
		//启用抗生素,才加载到列表框
		if (Common_GetValue("chkANTDic")) {
			obj.dsAddRecord(obj.dsANTDic,{ID:r.get("ID"),Description:r.get("Description")});
		}
	}
	
	obj.dsAddRecord = function(ds,data){
		var arr = new Array();
		var i=0,flag=0;
		for (var k in data){
			arr[i] = k;
			i++;
		}
		for (var j =0;j<ds.getCount();j++){
			var r = ds.getAt(j);
			if (r.get(arr[0])==data[arr[0]]){
				flag=1;
			}
		}
		if (flag==0){    //避免数据重复
			var sr = new Ext.data.Record(arr);
			sr.set(arr[0],data[arr[0]]);
			sr.set(arr[1],data[arr[1]]);
			ds.add(sr);
		}
	}
	
	obj.multiList_dblclick = function(t,i){
		if (i<0) return;
		t.getStore().removeAt(i);
	}
	obj.getKeysFromDataStore = function(ds,key){
		var keys = "";
		if (!ds) return keys;
		if (!key) return keys;
		for (var i=0;i<ds.getCount();i++){
			v = ds.getAt(i).get(key);
			if (!v) continue;
			if (keys != '') keys += ",";
			keys += v;
		}
		return keys;
	}
}

