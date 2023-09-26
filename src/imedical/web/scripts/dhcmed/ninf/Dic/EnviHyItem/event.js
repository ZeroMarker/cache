function InitViewport1Event(obj) {
	//加载类方法
	obj.ClsDicEnviHyItem = ExtTool.StaticServerObject("DHCMed.NINF.Dic.EnviHyItem");
	obj.ClsDicEnviHyItmForMula = ExtTool.StaticServerObject("DHCMed.NINF.Dic.EnviHyItmForMula");
	obj.ClsDicEnviHyItemSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Dic.EnviHyItem");
	obj.ClsDicEnviHyItmForMulaSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Dic.EnviHyItmForMula");
	obj.LoadEvent = function(args)
    {
	    obj.btnQuery.on("click",obj.btnQuery_click,obj);
		obj.btnUpdate.on("click",obj.btnUpdate_click,obj);
		obj.btnDelete.on("click",obj.btnDelete_click,obj);
		obj.gridEnviHyItem.on("rowclick",obj.gridEnviHyItem_rowclick,obj);
		obj.gridEnviHyItmForMula.on("rowclick",obj.gridEnviHyItmForMula_rowclick,obj);
		obj.gridEnviHyItemStore.load({params : {start : 0,limit : 50}});
  	};
	
	obj.ClearFormItem = function()
	{
		obj.RecRowID = "";
		Common_SetValue("txtCode","");
		Common_SetValue("txtDesc","");
		Common_SetValue("txtContent","");
		Common_SetValue("cboCateg","","");
		Common_SetValue("cboFreq","","");
		Common_SetValue("cboNormUom","","");
		Common_SetValue("chkIsActive",false);
		Common_SetValue("txtResume","");
		Common_SetValue("txtFormula","");
	}
	obj.ClearEditerFormItem = function()
	{
		obj.RecSubRowID = "";
		Common_SetValue("RowEditerTxtFormula","");
		Common_SetValue("RowEditerChkIsActive",false);
		Common_SetValue("RowEditerTxtResume","");
	}	
	obj.btnQuery_click = function()
	{
		obj.gridEnviHyItemStore.load({params : {start : 0,limit : 50}});
	}
	obj.btnUpdate_click = function()
	{
		var errinfo = "";
		var Code = Common_GetValue("txtCode");
		var Desc = Common_GetValue("txtDesc");
		var Content = Common_GetValue("txtContent");
		var Categ = Common_GetValue("cboCateg");
		var Freq = Common_GetValue("cboFreq");
		var NormUom = Common_GetValue("cboNormUom");
		var IsActive = Common_GetValue("chkIsActive");
		var Resume = Common_GetValue("txtResume");
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称为空!<br>";
		}
		if (!Content) {
			errinfo = errinfo + "检测对象为空!<br>";
		}
		if (!Categ) {
			errinfo = errinfo + "项目分类为空!<br>";
		}
		if (!Freq) {
			errinfo = errinfo + "频次为空!<br>";
		}
		if (!NormUom) {
			errinfo = errinfo + "单位为空!<br>";
		}
		if (errinfo) {
			ExtTool.alert("错误提示",errinfo);
			return;
		}
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;
		inputStr = inputStr + CHR_1 + Content;
		inputStr = inputStr + CHR_1 + Categ;
		inputStr = inputStr + CHR_1 + Freq;
		inputStr = inputStr + CHR_1 + NormUom;
		inputStr = inputStr + CHR_1 + (IsActive ? '1' : '0');
		inputStr = inputStr + CHR_1 + Resume;
		var flg = obj.ClsDicEnviHyItemSrv.SaveRec(inputStr,CHR_1);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == -100) {
				ExtTool.alert("错误提示","数据重复!Error=" + flg);
			} else {
				ExtTool.alert("错误提示","更新数据错误!Error=" + flg);
			}
			return;
		}
		
		obj.ClearFormItem();
		Common_LoadCurrPage("gridEnviHyItem");
	}
	
	obj.btnDelete_click = function()
	{
		var objGrid = Ext.getCmp("gridEnviHyItem");
		if (objGrid){
			var arrRec = objGrid.getSelectionModel().getSelections();
			if (arrRec.length>0){
				Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text){
					if(btn=="yes"){
						for (var indRec = 0; indRec < arrRec.length; indRec++){
							var objRec = arrRec[indRec];
							var flg = obj.ClsDicEnviHyItem.DeleteById(objRec.get("ItemID"));
							if (parseInt(flg) <= 0) {
								var row = objGrid.getStore().indexOfId(objRec.id);  //获取行号
								ExtTool.alert("错误提示","删除第" + row + "行数据错误!Error=" + flg);
							} else {
								obj.ClearFormItem();
								objGrid.getStore().remove(objRec);
								obj.gridEnviHyItemStore.load({params : {start : 0,limit : 50}});
							}
						}
					}
				});
			} else {
				ExtTool.alert("提示","请选中数据记录,再点击删除!");
			}
		}
	}
	
	obj.gridEnviHyItmForMula_rowclick = function()
	{
		var index=arguments[1];  //rowclick : (  Grid this ,  Number rowIndex ,  Ext.EventObject e  ) arguments[1]对应rowIndex
		
		var objRec = obj.gridEnviHyItmForMula.getStore().getAt(index);
		if (objRec.get("ForMulaID") == obj.RecSubRowID) {
			obj.ClearEditerFormItem();
			obj.gridEnviHyItmForMula.getSelectionModel().clearSelections(); //Modified By LiYang 2014-11-02 FixBug:3916医院感染管理-环境卫生学监测-检测项目字典-双击任意记录，底色依然为蓝色且可以删除
		} else {
			obj.RecSubRowID = objRec.get("ForMulaID");
			Common_SetValue("RowEditerTxtFormula",objRec.get("ForMula"));
			Common_SetValue("RowEditerChkIsActive",(objRec.get("IsActive")=='是'));
			Common_SetValue("RowEditerTxtResume",objRec.get("Resume"));

		}
	}
	
	obj.gridEnviHyItem_rowclick = function()
	{
		var index=arguments[1];
		var objRec = obj.gridEnviHyItem.getStore().getAt(index);
		if (objRec.get("ItemID") == obj.RecRowID) {
			obj.ClearFormItem();
			obj.gridEnviHyItem.getSelectionModel().clearSelections(); //Modified By LiYang 2014-11-02 FixBug:3819'医院感染管理-环境卫生学监测-检测项目字典-点击选择一条记录，再次点击取消选择后，该条数据仍显示蓝色背景++++
		} else {
			obj.RecRowID = objRec.get("ItemID");
			Common_SetValue("txtCode",objRec.get("ItemCode"));
			Common_SetValue("txtDesc",objRec.get("ItemDesc"));
			Common_SetValue("txtContent",objRec.get("ItemContent"));
			Common_SetValue("cboCateg",objRec.get("ItemCategID"),objRec.get("ItemCategDesc"));
			Common_SetValue("cboFreq",objRec.get("ItemFreqID"),objRec.get("ItemFreqDesc"));
			Common_SetValue("cboNormUom",objRec.get("ItemNormUomID"),objRec.get("ItemNormUomDesc"));
			Common_SetValue("chkIsActive",(objRec.get("ItemActive")=='1'));
			Common_SetValue("txtResume",objRec.get("ItemResume"));
			obj.gridEnviHyItmForMulaStore.load({});	
		}
	}
	
	obj.ItemFormulaHeader = function(itemID,itemDesc) 
	{
		obj.ClearEditerFormItem();
		winGridRowEditeryhb = new Ext.Window({
			//id : 'RowEditeryhb',
			layout:'fit',
			height : 300,
			closable:true,
			closeAction: 'hide',
			width : 600,
			modal : true,
			title : '维护计算公式-' + itemDesc,
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
											width : 250
											,layout : 'form'
											,labelAlign : 'right'
											,labelWidth : 70
											,items: [obj.RowEditerTxtFormula]
										},{
											width : 100
											,layout : 'form'
											,labelAlign : 'right'
											,labelWidth : 70
											,items: [obj.RowEditerChkIsActive]
										},{
											columnWidth:1
											,layout : 'form'
											,labelAlign : 'right'
											,labelWidth : 40
											,items: [obj.RowEditerTxtResume]
										}
									]
								}
							]
						},{
							region: 'center',
							layout : 'fit',
							items : [
								obj.gridEnviHyItmForMula
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
								var ItemID = itemID;
								obj.RecRowID=ItemID;
								var RowEditerTxtFormula = Common_GetValue("RowEditerTxtFormula");
								var RowEditerChkIsActive = Common_GetValue("RowEditerChkIsActive");
								var RowEditerTxtResume = Common_GetValue("RowEditerTxtResume");
								var errInfo = '';
								if (RowEditerTxtFormula == '') {
									errInfo = errInfo + '计算公式为空!<br>'
								}
								if (errInfo != '') {
									ExtTool.alert("提示",errInfo);
									return;
								}
								
								var FID=obj.gridEnviHyItmForMulaStore.findExact("ForMula", RowEditerTxtFormula);
								var RID=obj.gridEnviHyItmForMulaStore.findExact("ForMulaID", obj.RecSubRowID);
								if ((FID>-1)&&(FID!=RID))
								{
									ExtTool.alert("提示","公式重复，请仔细填写!");
									return;
								}
								
								var inputStr = obj.RecSubRowID;
								inputStr = inputStr + CHR_1 + ItemID;
								inputStr = inputStr + CHR_1 + RowEditerTxtFormula;
								inputStr = inputStr + CHR_1 + (RowEditerChkIsActive ? '1' : '0');
								inputStr = inputStr + CHR_1 + RowEditerTxtResume;
								var flg = obj.ClsDicEnviHyItmForMulaSrv.SaveRec(inputStr,CHR_1)
								obj.ClearEditerFormItem();
								if (parseInt(flg)<=0) {
									ExtTool.alert("提示","保存数据失败!Error=" + flg);
									return false;
								}
								obj.gridEnviHyItmForMulaStore.load({});
								obj.ClearFormItem();
								obj.gridEnviHyItemStore.load({params : {start : 0,limit : 50}});
							}
						}
					}),new Ext.Toolbar.Button({
						iconCls : 'icon-Delete',
						width : 60,
						text : "删除",
						listeners : {
							'click' : function(){
								var ItemID = itemID;
								obj.RecRowID=ItemID;
								var objGrid = Ext.getCmp("gridEnviHyItmForMula");
								if (objGrid){
									var arrRecSub = objGrid.getSelectionModel().getSelections();
									if (arrRecSub.length>0){
										Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text){
											if(btn=="yes"){
												for (var indRec = 0; indRec < arrRecSub.length; indRec++){
													var objRecSub = arrRecSub[indRec];
													var flg = obj.ClsDicEnviHyItmForMula.DeleteById(ItemID+"||"+objRecSub.get("ForMulaID"));
													if (parseInt(flg) <= 0) {
														var row = objGrid.getStore().indexOfId(objRecSub.id);  //获取行号
														ExtTool.alert("错误提示","删除第" + row + "行数据错误!Error=" + flg);
													} else {
														obj.ClearEditerFormItem();
														objGrid.getStore().remove(objRecSub);
														obj.ClearFormItem();
														obj.gridEnviHyItemStore.load({params : {start : 0,limit : 50}});
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
		winGridRowEditeryhb.show();
	}
	
	obj.EditItemNormsHander = function(itemID,itemDesc){
		obj.WinEnviHyNorms = new Ext.Window({
			id : 'WinEnviHyNorms'
			,width : 800
			,height : 600
			,layout : 'fit'
			,closable : true
			,modal : true
			,maximized : true
			,title : (itemDesc == '' ? '维护环境检测标准' : '维护环境检测标准--' + itemDesc)
			,html : '<iframe id="ifEnviHyNorms" width="100%" height="100%" src="./dhcmed.ninf.dic.envihynorms.csp?+&ItemID=' + itemID + '&ItemDesc=' + itemDesc + '"/>'
		});
		obj.WinEnviHyNorms.show();
	}
}

