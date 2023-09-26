
function InitViewport1Event(obj) {
	//加载类方法
	obj.ClsFPICDDx = ExtTool.StaticServerObject("DHCWMR.FP.ICDDx");
	obj.ClsFPICDAlias = ExtTool.StaticServerObject("DHCWMR.FP.ICDAlias");
	
	obj.LoadEvent = function(args)
    {
		obj.btnUpdate.on("click",obj.btnUpdate_click,obj);
		obj.btnDelete.on("click",obj.btnDelete_click,obj);
		obj.btnQuery.on("click",obj.btnQuery_click,obj);
		obj.btnLIBDS.on("click",obj.btnLIBDS_click,obj);
		Common_SetVisible('btnLIBDS',false);
		
		if (SSHospCode == '37-QYFY'){
			obj.btnUpdate.setDisabled(true);
			obj.btnDelete.setDisabled(true);
		}
		
		obj.gridICDLibrary.on("rowclick",obj.gridICDLibrary_rowclick,obj);
		obj.gridICDAlias.on("rowclick",obj.gridICDAlias_rowclick,obj);
		obj.gridICDLibraryStore.load({params : {start : 0,limit : 50}});
		
		obj.txtAlias.on("specialKey",obj.txtAlias_specialKey,obj);
		obj.cboICDVersion.on("select",obj.cboICDVersion_select,obj);
		obj.cboICDVersion.getStore().load({
			callback : function(r,option,success){
				if (success) {
					if (r.length > 0) {
						obj.cboICDVersion.setValue(r[0].get("ICDID"));
						obj.cboICDVersion.setRawValue(r[0].get("ICDDesc"));
						var ICDCode = r[0].get("ICDCode");
						if ((ICDCode == 'HIS-D')||(ICDCode == 'HIS-O')){
							Common_SetVisible('btnLIBDS',true);
						} else {
							Common_SetVisible('btnLIBDS',false);
						}
					}
				}
			}
		});
  	};
	
	obj.cboICDVersion_select = function(combo,record,index){
		var ICDCode = record.get("ICDCode");
		if ((ICDCode == 'HIS-D')||(ICDCode == 'HIS-O')){
			Common_SetVisible('btnLIBDS',true);
		} else {
			Common_SetVisible('btnLIBDS',false);
		}
		Common_SetValue("txtAlias","");
		Common_LoadCurrPage("gridICDLibrary");
	}
	
	obj.txtAlias_specialKey = function(field, e) {
		if (e.getKey() != Ext.EventObject.ENTER) return;
		//Common_LoadCurrPage("gridICDLibrary");
		//update by pylian 20150616 108605 查询出数据后翻页（如翻到100页），重新输入关键字查询，页码仍显示在100页
		obj.ICDID="";
		obj.gridICDLibraryStore.load({params : {start : 0,limit : 50}});
	}
	
	obj.ClearFormItem = function()
	{
		obj.RecRowID = "";
		Common_SetValue("txtCode","");
		Common_SetValue("txtDesc","");
		//Common_SetValue("cboICDVersion","");
		Common_SetValue("txtICD10","");
		Common_SetValue("txtICD9","");
		Common_SetValue("txtIDMCode","");
		Common_SetValue("ChkIsActive",false);
		Common_SetValue("txtResume","");
		//Ext.getCmp("txtCode").setDisabled(false);
		//Ext.getCmp("txtICD10").setDisabled(false);
		//Ext.getCmp("txtICD9").setDisabled(false);
	}
	
	obj.ClearEditerFormItem = function()
	{
		obj.RecSubRowID = "";
		Common_SetValue("RowEditerIAAlias","");
	}
	obj.btnQuery_click = function()
	{
		Common_LoadCurrPage("gridICDLibrary");
		Common_SetValue("txtAlias","");
	}
	
	obj.btnLIBDS_click = function()
	{
		var LibCode = Common_GetValue("cboICDVersion");
		if (!LibCode) {
			ExtTool.alert("提示","请选择诊断库!");
			return;
		}
		
		var flg = ExtTool.RunServerMethod("DHCWMR.FPService.ICDDxSrv","GetICDDxDS",LibCode);
		if (parseInt(flg) <= 0) {
			ExtTool.alert("错误提示","HIS诊断库与编目诊断库数据同步错误!");
			return;
		} else {
			ExtTool.alert("提示","完成HIS诊断库与编目诊断库的数据同步!");
		}
	}
	
	obj.btnUpdate_click = function()
	{
		var errinfo = "";
		var Code     = Common_GetValue("txtCode");
		var Desc     = Common_GetValue("txtDesc");
		var LibCode  = Common_GetValue("cboICDVersion");
		var ICD10    = Common_GetValue("txtICD10");
		var ICD9     = Common_GetValue("txtICD9");
		var ICDMCode = Common_GetValue("txtIDMCode");
		var IsActive = Common_GetValue("ChkIsActive");
		var Resume   = Common_GetValue("txtResume");
		
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称为空!<br>";
		}
		if (!LibCode) {
			errinfo = errinfo + "诊断编码为空!<br>";
		}
		if (errinfo) {
			ExtTool.alert("错误提示",errinfo);
			return;
		}
	
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;
		inputStr = inputStr + CHR_1 + LibCode;
		inputStr = inputStr + CHR_1 + ICD10;
		inputStr = inputStr + CHR_1 + ICD9;
		inputStr = inputStr + CHR_1 + ICDMCode;
		inputStr = inputStr + CHR_1 + (IsActive ? '1' : '0');
		inputStr = inputStr + CHR_1 + Resume;
		inputStr = inputStr + CHR_1 + "";
		
		var flg = obj.ClsFPICDDx.Update(inputStr,CHR_1);
		if (parseInt(flg) <= 0) {
			ExtTool.alert("错误提示","更新数据错误!");
			return;
		}else{
			obj.ICDID = parseInt(flg);
		}
		obj.ClearFormItem();
		Common_LoadCurrPage("gridICDLibrary");
	}
	
	obj.btnDelete_click = function()
	{
		var objGrid = Ext.getCmp("gridICDLibrary");
		if (objGrid){
			var arrRec = objGrid.getSelectionModel().getSelections();
			if (arrRec.length>0){
				Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text){
					if(btn=="yes"){
						for (var indRec = 0; indRec < arrRec.length; indRec++){
							var objRec = arrRec[indRec];
							var flg = obj.ClsFPICDDx.DeleteById(objRec.get("ID"));
							if (parseInt(flg) < 0) {
								var row = objGrid.getStore().indexOfId(objRec.id);  //获取行号
								ExtTool.alert("错误提示","删除第" + row + "行数据错误!Error=" + flg);
							} else {
								obj.ICDID="";
								obj.ClearFormItem();
								objGrid.getStore().remove(objRec);
							}
						}
					}
				});
			} else {
				ExtTool.alert("提示","请选中数据记录,再点击删除!");
			}
		}
	}
	
	obj.gridICDLibrary_rowclick = function()
	{
		var index=arguments[1];
		var objRec = obj.gridICDLibrary.getStore().getAt(index);
		if (objRec.get("ID") == obj.RecRowID) {
			obj.ClearFormItem();
		} else {
			obj.RecRowID = objRec.get("ID");
			Common_SetValue("txtCode",objRec.get("ICDCode"));
			Common_SetValue("txtDesc",objRec.get("ICDDesc"));
			Common_SetValue("txtICD10",objRec.get("IDICD10"));
			Common_SetValue("txtICD9",objRec.get("IDICD9"));
			Common_SetValue("txtIDMCode",objRec.get("ICDMCode"));
			Common_SetValue("ChkIsActive",objRec.get("IsActive")=='是');
			Common_SetValue("cboICDVersion",objRec.get("ICDVID"),objRec.get("ICDVDesc"));
			Common_SetValue("txtResume",objRec.get("Resume"));
			//Ext.getCmp("txtCode").setDisabled(true);	//update by liuyh 2015-1-21
			//Ext.getCmp("txtICD10").setDisabled(true);
			//Ext.getCmp("txtICD9").setDisabled(true);
			obj.gridICDAliasStore.load({});	
		}
	};
	
	obj.gridICDAlias_rowclick = function()
	{
		var index=arguments[1];  //rowclick : (  Grid this ,  Number rowIndex ,  Ext.EventObject e  ) arguments[1]对应rowIndex
		
		var objRec = obj.gridICDAlias.getStore().getAt(index);
		if (objRec.get("SubID") == obj.RecSubRowID) {
			obj.ClearEditerFormItem();
		} else {
			obj.RecSubRowID = objRec.get("SubID");
			Common_SetValue("RowEditerIAAlias",objRec.get("ICDAlias"));
			
		}
	}
	
	obj.ICDAliasHeader = function(ICDID,ICDDesc) 
	{
		obj.ClearEditerFormItem();
		winGridRowEditer = new Ext.Window({
			layout:'fit',
			height : 300,
			closable:true,
			closeAction: 'hide',
			width : 300,
			modal : true,
			title : '别名维护-' + ICDDesc,
			layout : 'fit',
			resizable : false,
			items:[
				{
					region: 'center',
					layout : 'border',
					frame : true,
					items : [
						{
							region: 'south',
							height: 35,
							layout : 'form',
							frame : true,
							items : [
								{
									layout : 'column',
									items : [
										{
											width : 200
											,layout : 'form'
											,labelAlign : 'right'
											,labelWidth : 50
											,items: [obj.RowEditerIAAlias]
										}
									]
								}
							]
						},{
							region: 'center',
							layout : 'fit',
							items : [
								obj.gridICDAlias
							]
						}
					],
					bbar : [
					new Ext.Toolbar.Button({
						iconCls : 'icon-save',
						width : 60,
						text : "保存",
						listeners : {
							'click' : function(){
								var ParrefID = ICDID;
								var RowEditerIAAlias = Common_GetValue("RowEditerIAAlias");
								
								var errInfo = '';
								if (RowEditerIAAlias == '') {
									errInfo = errInfo + '别名为空!<br>'
								}
								
								if (errInfo != '') {
									ExtTool.alert("提示",errInfo);
									return;
								}
								var inputStr = ParrefID;
								inputStr = inputStr + CHR_1 + obj.RecSubRowID;
								inputStr = inputStr + CHR_1 + RowEditerIAAlias;
								
								var flg = obj.ClsFPICDAlias.Update(inputStr,CHR_1)
								
								if (parseInt(flg)<=0) {
									ExtTool.alert("提示","保存数据失败!Error=" + flg);
									return false;
								}
								obj.gridICDAliasStore.load({});
								obj.ClearFormItem(); 
								//obj.ClearEditerFormItem(); 
								//保存关闭之后再次保存时清空界面问题已不存在，保存之后重新加载
								obj.gridICDLibraryStore.load({params : {start : 0,limit : 50}});  
							}
						}
					}),new Ext.Toolbar.Button({
						iconCls : 'icon-Delete',
						width : 60,
						text : "删除",
						listeners : {
							'click' : function(){
								var ParrefID = ICDID;
								var objGrid = Ext.getCmp("gridICDAlias");
								if (objGrid){
									var arrRecSub = objGrid.getSelectionModel().getSelections();
									if ((arrRecSub.length>0)&&(obj.RecSubRowID != "")){
										Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text){
											if(btn=="yes"){
												for (var indRec = 0; indRec < arrRecSub.length; indRec++){
													var objRecSub = arrRecSub[indRec];
													var flg = obj.ClsFPICDAlias.DeleteById(ParrefID+"||"+objRecSub.get("SubID"));
													if (parseInt(flg) <= 0) {
														var row = objGrid.getStore().indexOfId(objRecSub.id);  //获取行号
														ExtTool.alert("错误提示","删除第" + row + "行数据错误!Error=" + flg);
													} else {
														obj.ClearEditerFormItem();
														objGrid.getStore().remove(objRecSub);
														//obj.ClearFormItem();
														//删除关闭之后再次保存、删除时清空界面问题已不存在，删除之后重新加载 
														obj.gridICDAliasStore.load({params : {start : 0,limit : 50}});
														obj.gridICDLibraryStore.load({params : {start : 0,limit : 50}}); 
													}
												}
											}
										});
									} else {
										ExtTool.alert("提示","请选中数据记录,再点击删除!");
									}
								}
							}
						}
					})
					,'->','…']
			}]
		});
		winGridRowEditer.show();
	}
}