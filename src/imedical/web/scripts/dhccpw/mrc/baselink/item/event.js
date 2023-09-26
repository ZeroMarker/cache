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
		//电子病历
		obj.eprCategoryTree.on("dblclick", obj.eprCategoryTree_dblclick, obj);
		//主窗体
		obj.tabPanel.on("tabchange", obj.tabPanel_tabchange, obj);
		obj.tabPanel.setActiveTab(0);
		obj.IDList.on("rowclick", obj.IDList_rowclick, obj);
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
		}else{
			obj.CurrRowid=objRec.get("rowid");
			obj.IDCode.setValue(objRec.get("IDCode"));
			obj.IDDesc.setValue(objRec.get("IDDesc"));
			document.getElementById("txtExpression").Text=objRec.get("IDExpression");
			obj.IDResume.setValue(objRec.get("IDResume"));
		}
	};
	obj.btnAdd_click = function()		// 添加关联项目
	{
		if(ValidateData(obj.IDCode,"代码不能为空!")==-1) return;
		if(ValidateData(obj.IDDesc,"描述不能为空!")==-1) return;
		if(document.getElementById("txtExpression").Text==""){
			ExtTool.alert("提示","表达式不能为空!");
			return;
		}
		//*******	Modified by zhaoyu 2012-11-30 基础信息维护--关联项目--添加的代码重复的监控项目时，提示信息不明确 211
		var BLIDCode = obj.IDCode.getValue();
		var BLIDRID = ""
		if (obj.CurrRowid){
			BLIDRID = obj.CurrRowid;
		}
		var objBLID = ExtTool.StaticServerObject("User.DHCMRCBaseLinkItemDic");
		var CheckVal = objBLID.CheckBLIDCode(BLIDCode,BLIDRID)
		if(CheckVal==1){
			ExtTool.alert("提示","代码重复，请重新输入！");
			return
		}
		//*******
		var objBaseLinkItemDic = ExtTool.StaticServerObject("User.DHCMRCBaseLinkItemDic");
		var tmp = obj.CurrRowid;
		tmp += "^"+obj.IDCode.getValue();
		tmp += "^"+obj.IDDesc.getValue();
		tmp += "^"+obj.SubCatID;
		tmp += "^"+document.getElementById("txtExpression").Text;
		tmp += "^"+obj.IDResume.getValue();
		var ret=objBaseLinkItemDic.Update(tmp);
		if(ret>0){
			obj.CurrRowid="";
			obj.IDCode.setValue("");
			obj.IDDesc.setValue("");
			document.getElementById("txtExpression").Text="";
			obj.IDResume.setValue("");
			obj.IDListStore.load({params : {start:0,limit:20}});
			window.parent.RefreshLeftTree();
			obj.tabPanel.setActiveTab(0);
			//obj.tabPanel.collapse(true);
		}else{
			ExtTool.alert("提示","保存失败!");
		}
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
            
            var objBaseLinkItemDic = ExtTool.StaticServerObject("User.DHCMRCBaseLinkItemDic");
			var ret = objBaseLinkItemDic.DeleteById(obj.CurrRowid);
			if(parseInt(ret)>-1){
					obj.CurrRowid="";
					obj.IDCode.setValue("");
					obj.IDDesc.setValue("");
					document.getElementById("txtExpression").Text="";
					obj.IDResume.setValue("");
					obj.IDListStore.load({ params : { start:0 , limit:20 }});
					window.parent.RefreshLeftTree();
			}else{
	 				ExtTool.alert("提示","删除失败!");
	 		}
		});
	};
	
	obj.tabPanel_tabchange=function()
	{
		//改变面板时重新加载数据
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
			case "模板目录" : 
				obj.tabPanel.expand(true);
				obj.tabPanel.setActiveTab(1);
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
			obj.MethodPackageMgr = ExtTool.StaticServerObject("web.DHCCPW.MRC.BaseLinkMethodSrv");
			var strLibName = obj.MethodPackageMgr.GetLibName(arry[0]);
			InsertText(strLibName);
		}
	};
	//********************电子病历界面模板目录树************************
	obj.eprCategoryTree_dblclick = function(objNode)
	{
		var strID = objNode.id;
		var arry = strID.split("-");
		if (arry[1]=="CategoryID") {
			obj.retInfo="[模板目录" + "||" + arry[0] + "]"
			ProcessInputHelperEvent(obj.intSelStart, obj.intSelEnd, obj.retInfo);
			//obj.tabPanel.setActiveTab(0);
			//obj.tabPanel.collapse(true);
			
			obj.IDDesc.setValue(objNode.text);
			
			var tmpNode=objNode;
			var tmpDesc="";
			while (tmpNode.parentNode!=null)
			{
				tmpDesc=tmpNode.text + " " + tmpDesc
				tmpNode=tmpNode.parentNode;
			}
			obj.IDResume.setValue(tmpDesc);
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
