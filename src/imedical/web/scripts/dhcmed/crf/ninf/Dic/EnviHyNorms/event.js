function InitViewport1Event(obj) {
	//加载类方法
	obj.ClsDicEnviHyNorms = ExtTool.StaticServerObject("DHCMed.NINF.Dic.EnviHyNorms");
	obj.ClsDicEnviHyNormsSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Dic.EnviHyNorms");
	obj.ClsDicEnviHyItmMap = ExtTool.StaticServerObject("DHCMed.NINF.Dic.EnviHyItmMap");
    obj.ClsDicEnviHyItmMapSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Dic.EnviHyItmMap");
	
	obj.ClsDicEnviHyItem = ExtTool.StaticServerObject("DHCMed.NINF.Dic.EnviHyItem");
	obj.Dictionary = ExtTool.StaticServerObject("DHCMed.SS.Dictionary");
	obj.LoadEvent = function(args)
    {
		obj.btnUpdate.on("click",obj.btnUpdate_click,obj);
		obj.btnDelete.on("click",obj.btnDelete_click,obj);
		obj.btnQuery.on("click",obj.btnQuery_click,obj);
		obj.btnRelationItem.on("click",obj.btnRelationItem_click,obj);
		obj.gridEnviHyNorms.on("rowclick",obj.gridEnviHyNorms_rowclick,obj);
		obj.gridEnviHyItmMap.on("rowclick",obj.gridEnviHyItmMap_rowclick,obj);
		obj.gridEnviHyNormsStore.load({params : {start : 0,limit : 50}});
  	};
	obj.ClearFormItem = function()
	{
		obj.RecRowID = "";
		Common_SetValue("cboCateg","","");
		Common_SetValue("txtRange","");
		Common_SetValue("txtNorm","");
		Common_SetValue("txtNormMax","");
		Common_SetValue("txtNormMin","");
		Common_SetValue("chkIsActive",false);
		Common_SetValue("txtResume","");
		Common_SetValue("cboSpecimenType","");
		Common_SetValue("txtSpecimenNum","");
		Common_SetValue("txtCenterNum","");
		Common_SetValue("txtSurroundNum","");
		Common_SetValue("txtItemObj","");
	}
	obj.ClearEditerFormItem = function()
	{
		obj.RecSubRowID = "";
		Common_SetValue("RowEditerCboEnviHyItem","");
		obj.RowEditerCboEnviHyItem.setDisabled(false);
		Common_SetValue("RowEditerChkIsActive",false);
		Common_SetValue("RowEditerTxtResume","");
	}
	obj.btnQuery_click = function()
	{
		Common_LoadCurrPage("gridEnviHyNorms");
	}
	obj.btnUpdate_click = function()
	{
		var errinfo = "";
		var Categ = Common_GetValue("cboCateg");
		var Range = Common_GetValue("txtRange");
		var Norm = Common_GetValue("txtNorm");
		var NormMax = Common_GetValue("txtNormMax");
		var NormMin = Common_GetValue("txtNormMin");
		var SpecimenType = Common_GetValue("cboSpecimenType");
		var SpecimenNum = Common_GetValue("txtSpecimenNum");
		var CenterNum = Common_GetValue("txtCenterNum");
		var SurroundNum = Common_GetValue("txtSurroundNum");
		var ItemObj = Common_GetValue("txtItemObj");
		var IsActive = Common_GetValue("chkIsActive");
		var Resume = Common_GetValue("txtResume");
		var ItemDesc = Common_GetValue("RowEditerCboEnviHyItem");
		if (!Categ) {
			errinfo = errinfo + "环境类别为空!<br>";
		}
		if (!Range) {
			errinfo = errinfo + "检测范围为空!<br>";   //update by likai for bug:3865
		}
		if (!Norm) {
			errinfo = errinfo + "判定标准为空!<br>";
		}
		if ((!NormMax)&&(NormMax!=0)) {
			errinfo = errinfo + "最大值为空!<br>";
		}
		if ((!NormMin)&&(NormMin!=0)) {
			errinfo = errinfo + "最小值为空!<br>";
		}
		if (!SpecimenType) {
			errinfo = errinfo + "标本类型为空!<br>";
		}
		if ((!SpecimenNum)&&(SpecimenNum!=0)) {
			errinfo = errinfo + "标本数量为空!<br>";
		}
		if ((!CenterNum)&&(CenterNum!=0)) {
			errinfo = errinfo + "中心个数为空!<br>";
		}
		if ((!SurroundNum)&&(SurroundNum!=0)) {
			errinfo = errinfo + "周边个数为空!<br>";
		}
		if (!ItemObj) {
			errinfo = errinfo + "项目对象为空!<br>";
		}
		if (errinfo) {
			ExtTool.alert("错误提示",errinfo);
			return;
		}
		var inputStr = obj.RecRowID;						//1--ID 
		inputStr = inputStr + CHR_1 + Categ;					//2--环境类别
		inputStr = inputStr + CHR_1 + Range;					//3--检测范围
		inputStr = inputStr + CHR_1 + Norm;					//4--判定标准
		inputStr = inputStr + CHR_1 + SpecimenType;  				//5--标本类型
		inputStr = inputStr + CHR_1 + NormMax;					//6--中心值
		inputStr = inputStr + CHR_1 + NormMin;					//7--周边值
		inputStr = inputStr + CHR_1 + SpecimenNum;  				//8--标本数量
		inputStr = inputStr + CHR_1 + CenterNum;  				//9--中心个数
		inputStr = inputStr + CHR_1 + SurroundNum; 				//10--周边个数
		inputStr = inputStr + CHR_1 + ItemObj;    				//11--项目对象
		inputStr = inputStr + CHR_1 + Resume;					//12--备注
		inputStr = inputStr + CHR_1 + (IsActive ? '1' : '0');			//13--是否有效
		inputStr = inputStr + CHR_1 + ItemDesc;		  			//14--检测项目
		var flg = obj.ClsDicEnviHyNormsSrv.SaveRec(inputStr,CHR_1);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == -100) {
				ExtTool.alert("错误提示","数据重复!Error=" + flg);
			} else {
				ExtTool.alert("错误提示","更新数据错误!Error=" + flg);
			}
			return;
		}
		obj.ClearFormItem();
		Common_LoadCurrPage("gridEnviHyNorms");
	}
	obj.btnDelete_click = function()
	{
		var objGrid = Ext.getCmp("gridEnviHyNorms");
		if (objGrid){
			var arrRec = objGrid.getSelectionModel().getSelections();
			if (arrRec.length>0){
				Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text){
					if(btn=="yes"){
						for (var indRec = 0; indRec < arrRec.length; indRec++){
							var objRec = arrRec[indRec];
							var flg = obj.ClsDicEnviHyNorms.DeleteById(objRec.get("ID"));
							if (parseInt(flg) <= 0) {
								var row = objGrid.getStore().indexOfId(objRec.id);  //获取行号
								ExtTool.alert("错误提示","删除第" + row + "行数据错误!Error=" + flg);
							} else {
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
	
	obj.gridEnviHyNorms_rowclick = function()
	{
		var index=arguments[1];
		var objRec = obj.gridEnviHyNorms.getStore().getAt(index);
		if (objRec.get("ID") == obj.RecRowID) {
			obj.ClearFormItem();
		} else {
			obj.RecRowID = objRec.get("ID");
			Common_SetValue("cboCateg",objRec.get("EHNCategID"),objRec.get("EHNCategDesc"));
			Common_SetValue("txtRange",objRec.get("EHNRange"));
			Common_SetValue("txtNorm",objRec.get("EHNNorm"));
			Common_SetValue("txtNormMax",objRec.get("EHNNormMax"));
			Common_SetValue("txtNormMin",objRec.get("EHNNormMin"));
			Common_SetValue("chkIsActive",(objRec.get("EHNIsActive")=='1'));
			Common_SetValue("txtResume",objRec.get("EHNResume"));
			Common_SetValue("cboSpecimenType",objRec.get("SpecimenTypeID"),objRec.get("SpecimenTypeDesc"));
			Common_SetValue("txtSpecimenNum",objRec.get("SpecimenNum"));
			Common_SetValue("txtCenterNum",objRec.get("CenterNum"));
			Common_SetValue("txtSurroundNum",objRec.get("SurroundNum"));
			Common_SetValue("txtItemObj",objRec.get("ItemObj"));
			obj.gridEnviHyItmMapStore.load({});
		}
	}
	obj.gridEnviHyItmMap_rowclick = function()
	{
		var index=arguments[1];
		var objRec = obj.gridEnviHyItmMap.getStore().getAt(index);
		if (objRec.get("SubID") == obj.RecSubRowID) {
			obj.ClearEditerFormItem();
		} else {
			obj.RecSubRowID = objRec.get("SubID");
			Common_SetValue("RowEditerCboEnviHyItem",objRec.get("EHIDescID"),objRec.get("EHIDesc"));
			obj.RowEditerCboEnviHyItem.setDisabled(true);
			Common_SetValue("RowEditerChkIsActive",(objRec.get("EHIMIsActive")=='1'));
			Common_SetValue("RowEditerTxtResume",objRec.get("EHIMResume"));
		}
	}
	obj.btnRelationItem_click = function()
	{
		var objGrid = Ext.getCmp("gridEnviHyNorms");
		if (objGrid){
			var arrRec = objGrid.getSelectionModel().getSelections();
			if (arrRec.length>0){
				var objRec = arrRec[0];
				if(objRec.get("EHNIsActive")==0){
					ExtTool.alert("提示","选中的判定标准无效，不能进行关联!");
				}else{
					obj.grid_RowEditer(objRec);
				}
			} else {
				ExtTool.alert("提示","请选中数据记录,再进行关联!");
			}
		}
	}
	
	obj.grid_RowEditer = function(objRec) 
	{
		winGridRowEditer = new Ext.Window({
			layout:'fit',
			height : 300,
			closable:true,
			closeAction: 'hide',
			width : 600,
			modal : true,
			title : '关联检测项目-'+objRec.get("ID"),
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
											width : 300
											,layout : 'form'
											,labelAlign : 'right'
											,labelWidth : 80
											,items: [obj.RowEditerCboEnviHyItem]
										},{
											width : 120
											,layout : 'form'
											,labelAlign : 'right'
											,labelWidth : 80
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
								obj.gridEnviHyItmMap
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
								var ID = objRec.get("ID")
								var EnviHyItemID = Common_GetValue("RowEditerCboEnviHyItem");
								var IsActive = Common_GetValue("RowEditerChkIsActive");
								var Resume = Common_GetValue("RowEditerTxtResume");
								var errInfo = '';
								if (EnviHyItemID == '') {
									errInfo = errInfo + '检测项目为空!<br>'
								}
								if (errInfo != '') {
									ExtTool.alert("提示",errInfo);
									return;
								}
								var inputStr = obj.RecSubRowID;
								inputStr = inputStr + CHR_1 + ID;
								inputStr = inputStr + CHR_1 + EnviHyItemID;
								inputStr = inputStr + CHR_1 + (IsActive ? '1' : '0');
								inputStr = inputStr + CHR_1 + Resume;
								var flg = obj.ClsDicEnviHyItmMapSrv.SaveRec(inputStr,CHR_1)
								obj.ClearEditerFormItem();
								if (parseInt(flg)<=0) {
									ExtTool.alert("提示","关联数据失败!Error=" + flg);
									return false;
								}
								obj.gridEnviHyItmMapStore.load({});
							}
						}
					}),new Ext.Toolbar.Button({
						iconCls : 'icon-Delete',
						width : 60,
						text : "删除",
						listeners : {
							'click' : function(){
								var objGrid = Ext.getCmp("gridEnviHyItmMap");
								if (objGrid){
									var arrRecSub = objGrid.getSelectionModel().getSelections();
									if (arrRecSub.length>0){
										Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text){
											if(btn=="yes"){
												for (var indRec = 0; indRec < arrRecSub.length; indRec++){
													var objRecSub = arrRecSub[indRec];
													var flg = obj.ClsDicEnviHyItmMap.DeleteById(objRecSub.get("EHIDescID")+"||"+objRecSub.get("SubID"));
													if (parseInt(flg) <= 0) {
														var row = objGrid.getStore().indexOfId(objRecSub.id);  //获取行号
														ExtTool.alert("错误提示","删除第" + row + "行数据错误!Error=" + flg);
													} else {
														obj.ClearEditerFormItem();
														objGrid.getStore().remove(objRecSub);
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

