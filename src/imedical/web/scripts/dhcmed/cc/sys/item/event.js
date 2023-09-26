function InitViewportEvent(obj) {
	objEditorPanel = obj;
	obj.LoadEvent = function()
  	{
  		//操作符
  		obj.btnSymbolGreat.on("click", obj.btnSymbolGreat_click, obj);
		obj.btnSymbolGreatEqual.on("click", obj.btnSymbolGreatEqual_click, obj);
		obj.btnSymbolLess.on("click", obj.btnSymbolLess_click, obj);
		obj.btnSymbolLessEqual.on("click", obj.btnSymbolLessEqual_click, obj);
		obj.btnSymbolAdd.on("click", obj.btnSymbolAdd_click, obj);
		obj.btnSymbolMinus.on("click", obj.btnSymbolMinus_click, obj);
		obj.btnSymbolMulti.on("click", obj.btnSymbolMulti_click, obj);
		obj.btnSymbolDivide.on("click", obj.btnSymbolDivide_click, obj);
		obj.btnSymbolAnd.on("click", obj.btnSymbolAnd_click, obj);
		obj.btnSymbolOr.on("click", obj.btnSymbolOr_click, obj);
		obj.btnSymbolRight.on("click", obj.btnSymbolRight_click, obj);
		obj.btnSymbolLeft.on("click", obj.btnSymbolLeft_click, obj);
		//函数库
		obj.tvPackage.on("dblclick", obj.tvPackage_dblclick, obj);
		//医嘱项
		obj.ARCIMList.on("rowclick", obj.ARCIMList_rowclick, obj);
		obj.OEBtnUpdate.on("click", obj.ARCIMList_rowclick, obj);
		//obj.OEDesc.on("specialkey", obj.OEBtnFind_click, obj);
		obj.OEBtnFind.on("click", obj.OEBtnFind_click, obj);
		//诊断
		obj.MRCICDDxList.on("rowclick", obj.MRCICDDxList_rowclick, obj);
		obj.DBtnUpdate.on("click", obj.MRCICDDxList_rowclick, obj);
		//obj.MRCICD9CMCode.on("specialkey", obj.DBtnFind_click, obj);
		obj.DBtnFind.on("click", obj.DBtnFind_click, obj);
		//检验
		obj.LabRoom.on("select", obj.LabRoom_select, obj);
		obj.LabItmDesc.on("select", obj.LabItmDesc_select, obj);
		obj.LabBtnAddItem.on("click", obj.LabBtnAddItem_click, obj);
		obj.LabBtnDelItem.on("click", obj.LabBtnDelItem_click, obj);
		obj.LabBtnUpdate.on("click", obj.LabBtnUpdate_click, obj);
		//主窗体
		obj.tabPanel.on("tabchange", obj.tabPanel_tabchange, obj);
		obj.IDList.on("rowclick", obj.IDList_rowclick, obj);
		obj.btnFind.on("click", obj.btnFind_click, obj);
		obj.btnAdd.on("click", obj.btnAdd_click, obj);
		obj.btnDelete.on("click", obj.btnDelete_click, obj);
		//表达式
	  	window.setTimeout(
		  	function(){
		  		objTxtExp = document.getElementById("txtExpression");
					objTxtExp.attachEvent("Change",txtExpression_Change);
					objTxtExp.attachEvent("DblClick", txtExpression_DoubleClick);
			},
			3000
		);
		//等级
		obj.GradeCombo.on("select", obj.GradeCombo_select, obj);
  	};
  	
	obj.GradeCombo_select = function()
	{
	 var grade=obj.GradeCombo.getValue();
	 if(grade==1){
		obj.ItemScore.setValue("1");		
	 }
	 if(grade==2){
		obj.ItemScore.setValue("51");		
	 }
	 if(grade==3){
		obj.ItemScore.setValue("101");		
	 }
	};
	
	obj.IDList_rowclick = function()
	{
		var rowIndex = arguments[1];
		var objRec = obj.IDListStore.getAt(rowIndex);
		if(objRec.get("rowid")==obj.CurrRowid)
		{
			obj.CurrRowid="";
			obj.IDCode.setValue("");
			obj.IDDesc.setValue("");
			document.getElementById("txtExpression").Text="";
			obj.IDResume.setValue("");
			obj.ItemScore.setValue("");
			obj.GradeCombo.setValue("");
			obj.cbgAdmType.items.each(function(item){
				item.setValue(false);
			});
			obj.ItemIsActive.setValue(true);
			obj.ItemIsAbsolute.setValue(false);
			obj.ItemIsSensitive.setValue(false);
			obj.ItemIsSpecificity.setValue(false);
			obj.ItemIsRunOnce.setValue(false);
		}else{
			obj.CurrRowid=objRec.get("rowid");
			obj.IDCode.setValue(objRec.get("IDCode"));
			obj.IDDesc.setValue(objRec.get("IDDesc"));
			document.getElementById("txtExpression").Text=objRec.get("IDExpression");
			obj.IDResume.setValue(objRec.get("IDResume"));
			obj.ItemScore.setValue(objRec.get("ItemScore"));
			obj.GradeCombo.setValue(objRec.get("ItemGrade"),objRec.get("ItemGroup"));
			obj.cbgAdmType.items.each(function(item){
				item.setValue(false);
			});
			var strAdmType = objRec.get("AdmType");
			if (strAdmType.indexOf("I")>-1) {
				Ext.getCmp("cbgAdmType-I").setValue(true);
			}
			if (strAdmType.indexOf("O")>-1) {
				Ext.getCmp("cbgAdmType-O").setValue(true);
			}
			if (strAdmType.indexOf("E")>-1) {
				Ext.getCmp("cbgAdmType-E").setValue(true);
			}
			obj.ItemIsActive.setValue((objRec.get("ItemActive")==1));
			obj.ItemIsAbsolute.setValue((objRec.get("ItemAbsolute")==1));
			obj.ItemIsSensitive.setValue((objRec.get("ItemIsSensitive")==1));
			obj.ItemIsSpecificity.setValue((objRec.get("ItemIsSpecificity")==1));
			obj.ItemIsRunOnce.setValue((objRec.get("ItemIsRunOnce")==1));			
		}
	};
	obj.btnFind_click = function()
	{
		obj.IDListStore.removeAll();
		obj.IDListStore.load({ params : { start:0 , limit:20 }});
	};
	obj.btnAdd_click = function()		// 添加监控项目
	{
		if(ValidateData(obj.IDCode,"代码不能为空!")==-1) return;
		if(ValidateData(obj.IDDesc,"描述不能为空!")==-1) return;
		if(document.getElementById("txtExpression").Text==""){
			ExtTool.alert("提示","表达式不能为空!");
			return;
		}
		if (obj.ItemIsActive.getValue()){
			var IsActive="Y";
		}else{
			var IsActive="N";
		}
		if (obj.ItemIsAbsolute.getValue()){
			var IsAbsolute="Y";
		}else{
			var IsAbsolute="N";
		}
		var grade=obj.GradeCombo.getValue();
		var score=obj.ItemScore.getValue();
		if(grade==1){
			if((score<1)||(score>50)){
				ExtTool.alert("提示","分数不得超过50!");
				return;
			}
		}
		if(grade==2){
			if((score<51)||(score>100)){
				ExtTool.alert("提示","分数须大于50小于100!");
				return;
			}		
		}
		if(grade==3){
			if(score<101){
				ExtTool.alert("提示","分数须大于100!");
				return;
			}		
		}
		
		var AdmType = '';
		obj.cbgAdmType.items.each(function(item){
			if (item.getValue()) {
				if (AdmType == '') {
					AdmType = item.inputValue;
				} else {
					AdmType = AdmType + ',' + item.inputValue;
				}
			}
		});
		if (AdmType == '') {
			ExtTool.alert("提示","就诊类型不允许为空!");
			return;
		}
		
		var objSubjectItm = ExtTool.StaticServerObject("DHCMed.CCService.Sys.ItemDicSrv");
		var tmp = obj.CurrRowid;
		tmp += "^"+obj.IDCode.getValue();
		tmp += "^"+obj.IDDesc.getValue();
		tmp += "^"+obj.SubCatID;
		tmp += "^"+document.getElementById("txtExpression").Text;
		tmp += "^"+"";
		tmp += "^"+obj.IDResume.getValue();
		tmp += "^"+obj.ItemScore.getValue();
		tmp += "^"+IsActive;
		tmp += "^"+IsAbsolute;
		tmp += "^"+(obj.ItemIsSensitive.getValue() ? 'Y' : "N")
		tmp += "^"+(obj.ItemIsSpecificity.getValue() ? 'Y' : "N")
		tmp += "^"+(obj.ItemIsRunOnce.getValue() ? 'Y' : "N")
		tmp += "^"+AdmType;
		
		var ret=objSubjectItm.Update(tmp);
		if(ret>0){
			obj.CurrRowid="";
			obj.IDCode.setValue("");
			obj.IDDesc.setValue("");
			document.getElementById("txtExpression").Text="";
			obj.IDResume.setValue("");
			obj.ItemScore.setValue("");
			obj.GradeCombo.setValue("");
			obj.ItemIsActive.setValue(true);
			obj.ItemIsAbsolute.setValue(false);
			obj.cbgAdmType.items.each(function(item){
				item.setValue(false);
			});
			obj.IDListStore.load({params : {start:0,limit:20}});
			window.parent.RefreshLeftTree();
		}else{
			ExtTool.alert("提示","保存失败!");
		}
	};
	obj.btnEdit_click = function()
	{
	//请在此输入事件处理代码
	//如果需要获取函数参数，使用var myArg = arguments[i]形式 
	};
	obj.btnDelete_click = function()
	{
		if(obj.CurrRowid=="")
	 	{
	 		ExtTool.alert("提示","请先选中一行！");
	 		return;
	 	}
		ExtTool.confirm('选择框','确定删除?',function(btn){
            if(btn=="no") return;
            
            var objID = ExtTool.StaticServerObject("DHCMed.CCService.Sys.ItemDicSrv");
			var ret = objID.DeleteById(obj.CurrRowid);
			if(ret>0){
					obj.CurrRowid="";
					obj.IDCode.setValue("");
					obj.IDDesc.setValue("");
					document.getElementById("txtExpression").Text="";
					obj.IDResume.setValue("");
					obj.ItemScore.setValue("");
					obj.GradeCombo.setValue("");
					obj.ItemIsActive.setValue(true);
					obj.ItemIsAbsolute.setValue(false);
					obj.IDListStore.load({ params : { start:0 , limit:20 }});
					window.parent.RefreshLeftTree();
			}else{
	 				ExtTool.alert("提示","删除失败!");
	 		}
		});
	};
	
	obj.OEBtnFind_click = function()
	{
		obj.ARCIMListStore.removeAll();
		if (obj.OEDesc.getRawValue()!==""){
			obj.ARCIMListStore.load();
		}
	};
	obj.DBtnFind_click = function()
	{
		obj.MRCICDDxListStore.removeAll();
		if (obj.MRCICD9CMCode.getRawValue()!==""){
			obj.MRCICDDxListStore.load();
		}
	};
	obj.LabRoom_select = function()
	{
		obj.LabItmDesc.setValue("");
		obj.LabItmDescStore.removeAll();
		obj.LabItmDescStore.load();
	};
	obj.LabItmDesc_select = function()
	{
		obj.LabValue.setValue("");
		obj.LabValueStore.removeAll();
		obj.LabValueStore.load({ params : { start:0 , limit:20 }});
	};
	obj.LabBtnAddItem_click = function()
	{
		if(ValidateData(obj.LabItmDesc,"检验项目不能为空!")==-1) return;
		if(ValidateData(obj.LabOperChar,"操作符不能为空!")==-1) return;
		if(obj.LabValue.getRawValue()==""){
			ExtTool.alert("提示","值不能为空!");
			return;	
		}
		var LabDescValue=obj.LabDesc.getValue();
		//by wuqk 2011-11-10
		//obj.LabCode.setValue(obj.LabItmDesc.getValue()+"|"+obj.LabOperChar.getRawValue()+"|"+obj.LabValue.getRawValue());

		obj.LabCode.setValue(obj.LabItmDesc.getValue()+"|"+obj.LabOperChar.getRawValue()+"|"+obj.LabValue.getRawValue()+"||") //+obj.ArcimKey.getValue()+"|");  //+obj.SpecimenKey.getValue());
		
obj.LabDesc.setValue(obj.LabItmDesc.getRawValue().split("|")[0]+obj.LabOperChar.getRawValue()+obj.LabValue.getRawValue());

	};
	obj.LabBtnDelItem_click = function()
	{
		obj.LabRowid.setValue("");
		obj.LabCode.setValue("");
		obj.LabDesc.setValue("");
		obj.LabResume.setValue("");
		obj.LabRoom.setValue("");
		obj.LabItmDesc.setValue("");
		obj.LabOperChar.setValue("");
		obj.LabValue.setValue("");
		//obj.ArcimKey.setValue("");
		//obj.SpecimenKey.setValue("");
	}
	
	obj.tabPanel_tabchange=function()
	{
		//改变面板时重新加载数据
	}
	
	//*******************医嘱**********************
	obj.ARCIMList_rowclick = function()
	{
		var rc = obj.ARCIMList.getSelectionModel().getSelected();
		var OERowid=rc.get("ArcimID");
		var OEDesc=rc.get("ArcimDesc");
		obj.retInfo="[医嘱"+"||"+OERowid+"||"+OEDesc+"]";
		ProcessInputHelperEvent(obj.intSelStart, obj.intSelEnd, obj.retInfo);
		obj.LeftFPanel.collapse(true);
		
	}
	//*******************诊断*************************
	
	obj.MRCICDDxList_rowclick = function()
	{
		var rc = obj.MRCICDDxList.getSelectionModel().getSelected();
		var MRCRowid=rc.get("MRCID")
		var MRCDesc=rc.get("Descs")
		obj.retInfo="[诊断"+"||"+MRCRowid+"||"+MRCDesc+"]"
		ProcessInputHelperEvent(obj.intSelStart, obj.intSelEnd, obj.retInfo);
		obj.LeftFPanel.collapse(true);
	}
	//********************检验************************
	obj.LabBtnUpdate_click = function()
	{	
		var LabExp=obj.LabCode.getValue();
		var LabDesc=obj.LabDesc.getValue();
		obj.retInfo="[检验"+"||"+LabExp+"||"+LabDesc+"]";
		ProcessInputHelperEvent(obj.intSelStart, obj.intSelEnd, obj.retInfo);
		obj.LeftFPanel.collapse(true);
	}
	//********************操作符************************
	obj.intSelStart = 0;
	obj.intSelEnd = 0;
	obj.retInfo = "";
	obj.Interface = function(){
		var strType=arguments[0];
		obj.intSelStart = arguments[1];
		obj.intSelEnd = arguments[2];		
		var result = ""
	
		switch(strType)
		{
			case "医嘱" : 
				obj.LeftFPanel.expand(true);
				obj.tabPanel.setActiveTab(0);
				break;
			case "诊断" :
				obj.LeftFPanel.expand(true);
				obj.tabPanel.setActiveTab(1);
				break;
			case "检验" :
				obj.LeftFPanel.expand(true);
				obj.tabPanel.setActiveTab(2);
				break;
		}
	}
	
	obj.btnSymbolGreat_click = function(){
		InsertText(">");
	};
	obj.btnSymbolGreatEqual_click = function(){
		InsertText(">=");
	};
	obj.btnSymbolLess_click = function(){
		InsertText("<");
	};
	obj.btnSymbolLessEqual_click = function(){
		InsertText("<=");
	};
	obj.btnSymbolAdd_click = function(){
		InsertText("+");
	};
	obj.btnSymbolMinus_click = function(){
		InsertText("-");
	};
	obj.btnSymbolMulti_click = function(){
		InsertText("*");
	};
	obj.btnSymbolDivide_click = function(){
		InsertText("/");
	};
	obj.btnSymbolAnd_click = function(){
		InsertText(".and.");
	};
	obj.btnSymbolOr_click = function(){
		InsertText(".or.");
	};
	obj.btnSymbolLeft_click = function(){
		InsertText("(");
	};
	obj.btnSymbolRight_click = function(){
		InsertText(")");
	};
	//********************函数库************************
  	obj.tvPackage_dblclick = function(objNode)
	{
		var strID = objNode.id;
		var arry = strID.split("-");
		if (arry[1]=="Method"){
			obj.MethodPackageMgr = ExtTool.StaticServerObject("DHCMed.CCService.Sys.PackageSrv");
			var strLibName = obj.MethodPackageMgr.GetLibName(arry[0]);
			InsertText(strLibName);
		}
	};
}
function ValidateData(tObj,str)
{
	if(tObj.getValue()=="")
	{
		ExtTool.alert("提示",str);
		return -1;
	}
	else return 1;
}
function AddDataToItemDic(obj,rowid,str)
{
	var tmp=rowid.split("^");
	var objContentDicSrv = ExtTool.StaticServerObject("DHCMed.CCService.Sys.CommonSrv");	
	for(var i = 0; i < tmp.length; i ++)
    	{
    		var retData=objContentDicSrv.IsDataAdd(tmp[i].split("/")[0],str);  //判断该医嘱(诊断)是否已添加
    		
    		if(retData>0)  
    		{
    			var OERowid=tmp[i].split("/")[0];
    			var ret=window.confirm(tmp[i].split("/")[1]+'已添加,确定覆盖？');
    			if(ret==true) InsertDataToItemDic(retData,OERowid,obj,str);
    		}
    		else 
    		{
    				InsertDataToItemDic("",tmp[i].split("/")[0],obj,str);
    		}
    	}
}
function InsertDataToItemDic(IDRowid,ArcimRowid,obj,str)
{
	var ret="";
	var objArcim = ExtTool.StaticServerObject("DHCMed.Base.Arcim");
	var objID = ExtTool.StaticServerObject("DHCMed.CCService.Sys.ItemDicSrv");
	ret=objArcim.GetStringById(ArcimRowid);
	var tmp = IDRowid;						// rowid
	tmp += "^"+str+ArcimRowid;				// IDCode    "OE"+rowid
	tmp += "^"+ret.split("^")[2];			// IDDesc
	tmp += "^"+obj.SubCatID;	            // 子分类
	tmp += "^"+"{"+str+ArcimRowid+"}";		//表达式
	tmp += "^"+"";							// 范围
	tmp += "^"+"";							// 备注
	
	var retData=objID.AddInfoToDic(tmp,"OE");
	if(retData>0) 
		{
			obj.CurrRowid="";
			obj.IDCode.setValue();
			obj.IDDesc.setValue();
			obj.IDResume.setValue();
			obj.IDListStore.load({ params : { start:0 , limit:20 }});
		}
	else ExtTool.alert("提示","保存失败!");
}
function MRCAddDataToItemDic(obj,rowid,str)
{
	var tmp=rowid.split("^");
	var objContentDicSrv = ExtTool.StaticServerObject("DHCMed.CCService.Sys.CommonSrv");	
	for(var i = 0; i < tmp.length; i ++)
    	{
    		var retData=objContentDicSrv.IsDataAdd(tmp[i].split("/")[0],str);  //判断该医嘱(诊断)是否已添加
    		
    		if(retData>0)  
    		{
    			var DRowid=tmp[i].split("/")[0];
    			var ret=window.confirm(tmp[i].split("/")[1]+'已添加,确定覆盖？');
    			if(ret==true) MRCInsertDataToItemDic(retData,DRowid,obj,str);		
    		}
    		else 
    		{
    				MRCInsertDataToItemDic("",tmp[i].split("/")[0],obj,str);
    		}
    	}
}
function MRCInsertDataToItemDic(IDRowid,MRCRowid,obj,str)
{
	var ret="";
	var objMRC = ExtTool.StaticServerObject("DHCMed.Base.MRCICDDx");
	var objID = ExtTool.StaticServerObject("DHCMed.CCService.Sys.ItemDicSrv");
	ret = objMRC.GetStringById(MRCRowid);
	var tmp = IDRowid;						// rowid
	tmp += "^"+str+MRCRowid;				// IDCode    "OE"+rowid
	tmp += "^"+ret.split("^")[2];			// IDDesc
	tmp += "^"+obj.SubCatID;             	// 子分类
	tmp += "^"+"{"+str+MRCRowid+"}";		//表达式
	tmp += "^"+"";							// 范围
	tmp += "^"+"";							// 备注
	
	var retData=objID.AddInfoToDic(tmp,"D");
	if(retData>0) 
		{
			obj.CurrRowid="";
			obj.IDCode.setValue();
			obj.IDDesc.setValue();
			obj.IDResume.setValue();
			obj.IDListStore.load({ params : { start:0 , limit:20 }});
		}
	else ExtTool.alert("提示","更新失败!");
}