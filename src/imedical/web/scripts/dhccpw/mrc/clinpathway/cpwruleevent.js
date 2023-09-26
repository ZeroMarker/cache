var CHR_1=String.fromCharCode(1);    //用于分隔表达式中的field
var CHR_2=String.fromCharCode(2);    //用于Rule的field

/*
*临床路径监控规则类
*/
function CPWRule()
{
	var obj = new Object();
	obj.RowID = ""; 
	obj.Parent = "";
	obj.Desc = ""; 
	obj.Expression	 = ""; 
	obj.ActiveFlag = ""; 
}

function CPWRuleToString(obj,Parent){
	var strRule = ""
	if (obj){
		strRule += obj.RowID + CHR_2;
		strRule += Parent + CHR_2;
		strRule += obj.Desc + CHR_2;
		strRule += obj.Expression + CHR_2;
		strRule += obj.ActiveFlag? "Y" : "N";
	}
	return strRule;
}

function InitWinRulesEvent(obj)
{	
	var panelType;
	var currentType="";	
	var RuleService = ExtTool.StaticServerObject("web.DHCCPW.MRC.CheckRule");
	var cpwRowid;
	obj.LoadEvent = function(args)
	{
		cpwRowid=arguments[0][0];
	  	var panelTree = new Ext.tree.TreePanel({
			autoScroll : true
			,root : new Ext.tree.AsyncTreeNode({text:"",id:cpwRowid})
			,width : 300
			,region : 'west'
			,rootVisible:false
			,ddGroup     : 'ddGroup'
			,loader : new Ext.tree.TreeLoader({nodeParameter : "Arg1",	dataUrl:ExtToolSetting.TreeQueryPageURL, baseParams : {ClassName:"web.DHCCPW.MRC.ClinPathWaysSrv",	QueryName:"QueryCPWTree" ,ArgCnt:1}})
			,enableDrag : true
			,contextMenu:  new Ext.menu.Menu({
		        //id :'rightClickCont',   
		        items : [
		        	{   
		            	//id:'menuAddTypeA',   
		            	text : '新增规则A',
		            	handler: function(){
		            		var node = panelTree.getSelectionModel().getSelectedNode();	
		        			obj.LoadFormPanel("A",null,node);
		        			}
		        	}, 
		        	{   
		            	//id:'menuAddTypeB',   
		            	text : '新增规则B'   ,
		            	handler: function(){
		            		var node = panelTree.getSelectionModel().getSelectedNode();	
		        			obj.LoadFormPanel("B",null,node);
		        			}
		        	}]
	        
	    	 }),
		    listeners: {
		        contextmenu: function(node, e) {
		            node.select();
		            if (node.isLeaf()){
		            	var c = node.getOwnerTree().contextMenu;
		            	//c.removeAll();
		            	c.contextNode = node;
		            	c.showAt(e.getXY());
		            }
		        }
		    }
		});
	  	obj.panelTreeTab.add(panelTree);
	  	obj.panelTreeTab.doLayout(true);
	  	//obj.WinRules.setTitle(RuleService.GetCPWDesc(cpwRowid)+" 监控规则维护");
	}
	obj.btnSave_click = function(){
		//var objRule = panelType.GetRule();
		var strRule = CPWRuleToString(panelType.GetRule(),cpwRowid);
		if (strRule!=""){
			var ret = RuleService.SaveRule(strRule)
			panelType.ClearData();
			obj.gridRulesStore.load();
		}
		
	}
	
	obj.gridRules_rowclick = function(){		
		//var rowIndex = arguments[1];
		//var objData = obj.gridRules.getAt(rowIndex);
		var objData = obj.gridRules.getSelectionModel().getSelected()
		var RuleExp = objData.get("RuleExpression");
		if (RuleExp.indexOf("A")==0){
			obj.LoadFormPanel("A",objData,null)
		}
		else if (RuleExp.indexOf("B")==0){  //为每个类型增加相应的判断
			obj.LoadFormPanel("B",objData,null)
		}
	}
	
	obj.LoadFormPanel = function(ExpType,objData,node){
		if (ExpType=="A"){
			obj.LoadTypeA(objData,node)
		}
		else if (ExpType=="B"){       //为每个类型增加相应的判断
			obj.LoadTypeB(objData,node)
		}            
	}
	
	/*
	*为每个类型增加相应的LoadType方法
	*/
	obj.LoadTypeA = function(objData,node){
		if (currentType=="A"){
			panelType.LoadData(objData,node);
		}
		else{
			obj.panelEdit.removeAll();
			panelType = new InitpanelTypeA(obj,objData,node);
	  	obj.panelEdit.add(panelType.panelExpression);
	  	obj.panelEdit.doLayout();
	  	obj.btnSave.setDisabled(false);
		}
	  	currentType = "A";
	}
	obj.LoadTypeB=function(objData,node){
			if(currentType=="B"){
					panelType.LoadData(objData,node);
			}else{
					obj.panelEdit.removeAll()
					panelType=new InitpanelTypeB(obj,objData,node);
					obj.panelEdit.add(panelType.panelExpression);
	  			obj.panelEdit.doLayout();
	  			obj.btnSave.setDisabled(false);
			}
			currentType = "B";
	}
}


/*
*  A类规则编辑页面事件及控制
*  by wuqk 2010-05-13
*/
function InitpanelTypeAEvent(obj){
	var parentView ;
	var dropNode ;
	var RuleService = ExtTool.StaticServerObject("web.DHCCPW.MRC.CheckRule");
	obj.LoadEvent = function(args)
	{
		obj.DropEvent();
		parentView = arguments[0][0];	
		var dataObject = arguments[0][1];	
		var dropNode = arguments[0][2];	
		obj.ClearData();
		obj.LoadData(dataObject,dropNode);
		obj.formTypeA.doLayout();
		//Ext.getCmp('combTimeUnit').focus();
		//Ext.getCmp('combTimeStand').focus();
	}
	
	
	
	/*
	* 约定加载数据方法
	*/
	obj.LoadData = function(dataObject,dropNode){
		obj.ClearData();
		if (dataObject){
			var RuleId=dataObject.get("RuleId");
			var RuleDesc=dataObject.get("RuleDesc");
			var RuleActive=dataObject.get("RuleActive");
			var RuleExpression=dataObject.get("RuleExpression");
			Ext.getCmp('txtRuleId').setValue(RuleId);
			Ext.getCmp('txtRuleDesc').setValue(RuleDesc);
			Ext.getCmp('chkActive').setValue(RuleActive.indexOf("Y")==0);
			obj.PutExpression(RuleExpression);
		}
		else if (dropNode){
			Ext.getCmp('txtRuleId').setValue("");
			Ext.getCmp('txtItemDesc').setValue(dropNode.text);
			Ext.getCmp('txtRuleDesc').setValue(dropNode.text);
			Ext.getCmp('txtItemId').setValue(dropNode.id);
			//obj.panelExpression.setTitle(dropNode.text);	
		}	
	}
	
	/*
	* 约定提取规则数据方法
	*/
	obj.GetRule = function(){
		//增加数据校验
		
  		if(Ext.getCmp('txtRuleDesc').getValue()=="") 
  	  	{
  	 		ExtTool.alert("提示","请输入规则名称!");
			return null;	
  		}
  		if(Ext.getCmp('txtItemId').getValue()=="") 
  	  	{
  	 		ExtTool.alert("提示","请选择监控项目!");
			return null;	
  		}
  		if(Ext.getCmp('combTimeStand').getValue()=="") 
  	  	{
  	 		ExtTool.alert("提示","请选择基准时间!");
			return null;	
  		}
  		if(Ext.getCmp('combTimeUnit').getValue()=="") 
  	  	{
  	 		ExtTool.alert("提示","请选择时间单位!");
			return null;	
  		}
		var objRule = new CPWRule();
		objRule.RowID = Ext.getCmp('txtRuleId').getValue();
		objRule.Parent = obj.cpwRowid;
		objRule.Desc = Ext.getCmp('txtRuleDesc').getValue();
		objRule.Expression = obj.BuildExpression();
		objRule.ActiveFlag = Ext.getCmp('chkActive').getValue();
		return objRule;
	}
	
	/*
	* 约定清屏方法
	*/
	obj.ClearData = function(){	
		obj.panelTitle.getForm().reset();
		obj.formTypeA.getForm().reset();
		obj.formTypeB.getForm().reset();	
	}
	
	
	/*
	*1	Type	
	*2	Item	
	*3	TimeStandard	
	*4	TimeMin	
	*5	TimeMax	
	*6	TimeUnit	
	*7	QtyMin
	*8	QtyMax	
	*/
	obj.BuildExpression = function(){
		var expression = "A";
		expression += CHR_1 + Ext.getCmp('txtItemId').getValue();            //2
		expression += CHR_1 + Ext.getCmp('combTimeStand').getValue();        //3
		expression += CHR_1 + Ext.getCmp('txtTimeMin').getValue();           //4
		expression += CHR_1 + Ext.getCmp('txtTimeMax').getValue();           //5
		expression += CHR_1 + Ext.getCmp('combTimeUnit').getValue();         //6
		expression += CHR_1 + Ext.getCmp('txtQtyMin').getValue();            //7
		expression += CHR_1 + Ext.getCmp('txtQtyMax').getValue();            //8
		return expression;
	}
	
	obj.PutExpression = function(Expression){
		var arry = Expression.split(CHR_1);
		Ext.getCmp('txtItemId').setValue(arry[1]);            //2
		Ext.getCmp('combTimeStand').setValue(arry[2]);        //3
		Ext.getCmp('txtTimeMin').setValue(arry[3]);           //4
		Ext.getCmp('txtTimeMax').setValue(arry[4]);           //5
		Ext.getCmp('combTimeUnit').setValue(arry[5]);         //6
		Ext.getCmp('txtQtyMin').setValue(arry[6]);            //7
		Ext.getCmp('txtQtyMax').setValue(arry[7]);            //8
		Ext.getCmp('txtItemDesc').setValue(RuleService.GetItemDesc(arry[1]));
	}
	
	obj.DropEvent = function(){
		// This will make sure we only drop to the view container
		var formPanelDropTargetEl =  obj.panelTitle.body.dom;
	//var formPanelDropTargetEl =  Ext.getCmp('txtTimeMin').getEl();

		var formPanelDropTarget = new Ext.dd.DropTarget(formPanelDropTargetEl, {
			ddGroup     : 'ddGroup',
			notifyEnter : function(ddSource, e, data) {
	
				//Add some flare to invite drop.
				obj.panelTitle.body.stopFx();
				obj.panelTitle.body.highlight();
			},
			notifyDrop  : function(ddSource, e, data){
				Ext.getCmp('txtItemId').setValue(data.node.id);
				Ext.getCmp('txtItemDesc').setValue(data.node.text);
				Ext.getCmp('txtRuleDesc').setValue(data.node.text);
				return(true);
			}
		});	
		
	}

}
/*
*  B类规则编辑页面事件及控制
*  by wuqk 2010-05-13
*/
function InitpanelTypeBEvent(obj){
	var parentView ;
	var dropNode ;
	var RuleService = ExtTool.StaticServerObject("web.DHCCPW.MRC.CheckRule");
	obj.LoadEvent = function(args)
	{
		obj.DropEvent();
		parentView = arguments[0][0];	
		var dataObject = arguments[0][1];	
		var dropNode = arguments[0][2];	
		obj.ClearData();
		obj.LoadData(dataObject,dropNode);
		obj.formTypeA.doLayout();
		//Ext.getCmp('combTimeUnit').focus();
		//Ext.getCmp('combTimeStand').focus();
	}
	
	/*
	* 约定加载数据方法
	*/
	obj.LoadData = function(dataObject,dropNode){
		obj.ClearData();
		if (dataObject){
			var RuleId=dataObject.get("RuleId");
			var RuleDesc=dataObject.get("RuleDesc");
			var RuleActive=dataObject.get("RuleActive");
			var RuleExpression=dataObject.get("RuleExpression");
			Ext.getCmp('txtRuleId').setValue(RuleId);
			Ext.getCmp('txtRuleDesc').setValue(RuleDesc);
			Ext.getCmp('chkActive').setValue(RuleActive.indexOf("Y")==0);
			obj.PutExpression(RuleExpression);
		}
		else if (dropNode){
			Ext.getCmp('txtRuleId').setValue("");
			Ext.getCmp('txtItemDesc').setValue(dropNode.text);
			Ext.getCmp('txtRuleDesc').setValue(dropNode.text);
			Ext.getCmp('txtItemId').setValue(dropNode.id);
			//obj.panelExpression.setTitle(dropNode.text);	
		}	
	}
	/*
	* 约定提取规则数据方法
	*/
	obj.GetRule = function(){
		//增加数据校验
  		if(Ext.getCmp('txtRuleDesc').getValue()=="") 
  	  	{
  	 		ExtTool.alert("提示","请输入规则名称!");
			return null;	
  		}
  		if(Ext.getCmp('txtItemId').getValue()=="") 
  	  	{
  	 		ExtTool.alert("提示","请选择监控项目!");
			return null;	
  		}
  		if(Ext.getCmp('ItemStandard').getValue()=="") 
  	  	{
  	 		ExtTool.alert("提示","请选择基准项目!");
			return null;	
  		}
  		if(Ext.getCmp('combTimeUnit').getValue()=="") 
  	  	{
  	 		ExtTool.alert("提示","请选择时间单位!");
			return null;	
  		}
		var objRule = new CPWRule();
		objRule.RowID = Ext.getCmp('txtRuleId').getValue();
		objRule.Parent = obj.cpwRowid;
		objRule.Desc = Ext.getCmp('txtRuleDesc').getValue();
		objRule.Expression = obj.BuildExpression();
		objRule.ActiveFlag = Ext.getCmp('chkActive').getValue();
		return objRule;
	}
	
	/*
	* 约定清屏方法
	*/
	obj.ClearData = function(){	
		obj.panelTitle.getForm().reset();
		obj.formTypeA.getForm().reset();
		obj.formTypeB.getForm().reset();	
	}
	
	/*
	*1	Type	
	*2	Item	
	*3	ItemStandard	
	*4	TimeMin	
	*5	TimeMax	
	*6	TimeUnit	
	*7	QtyMin
	*8	QtyMax	
	*/
	obj.BuildExpression = function(){
		var expression = "B";
		expression += CHR_1 + Ext.getCmp('txtItemId').getValue();            //2
		expression += CHR_1 + Ext.getCmp('ItemStandardId').getValue();        //3
		expression += CHR_1 + Ext.getCmp('txtTimeMin').getValue();           //4
		expression += CHR_1 + Ext.getCmp('txtTimeMax').getValue();           //5
		expression += CHR_1 + Ext.getCmp('combTimeUnit').getValue();         //6
		expression += CHR_1 + Ext.getCmp('txtQtyMin').getValue();            //7
		expression += CHR_1 + Ext.getCmp('txtQtyMax').getValue();            //8
		return expression;
	}
	obj.PutExpression = function(Expression){
		var arry = Expression.split(CHR_1);
		Ext.getCmp('txtItemId').setValue(arry[1]);            //2
		Ext.getCmp('ItemStandardId').setValue(arry[2]);        //3
		Ext.getCmp('txtTimeMin').setValue(arry[3]);           //4
		Ext.getCmp('txtTimeMax').setValue(arry[4]);           //5
		Ext.getCmp('combTimeUnit').setValue(arry[5]);         //6
		Ext.getCmp('txtQtyMin').setValue(arry[6]);            //7
		Ext.getCmp('txtQtyMax').setValue(arry[7]);            //8
		Ext.getCmp('txtItemDesc').setValue(RuleService.GetItemDesc(arry[1]));  //项目
		Ext.getCmp('ItemStandard').setValue(RuleService.GetItemDesc(arry[2]))  //基准项目
	}
	obj.DropEvent = function(){
		// This will make sure we only drop to the view container
		var formPanelDropTargetEl =  obj.panelTitle.body.dom;
		var formPanelDropTarget = new Ext.dd.DropTarget(formPanelDropTargetEl, {
			ddGroup     : 'ddGroup',
			notifyEnter : function(ddSource, e, data) {
				//Add some flare to invite drop.
				obj.panelTitle.body.stopFx();
				obj.panelTitle.body.highlight();
			},
			notifyDrop  : function(ddSource, e, data){
				var ItemStandardId=Ext.getCmp('ItemStandardId').getValue()
				if(data.node.id==ItemStandardId){
					alert("项目不能和基准项目相同")	
					return
				}
				Ext.getCmp('txtItemId').setValue(data.node.id);
				Ext.getCmp('txtItemDesc').setValue(data.node.text);
				var txtRuleDesc=Ext.getCmp('txtRuleDesc')
				var ItemStandard=Ext.getCmp('ItemStandard')
				if(ItemStandard.getValue()==""){
						txtRuleDesc.setValue(data.node.text);
				}else{
						//txtRuleDesc.setValue(Ext.getCmp('txtItemDesc').getValue()+"（以 "+Ext.getCmp('ItemStandard').getValue()+" 为基准项目)");
						txtRuleDesc.setValue(Ext.getCmp('ItemStandard').getValue()+" "+Ext.getCmp('txtTimeMax').value+"小时后 "+Ext.getCmp('txtItemDesc').getValue())
				}
				return(true);
			}
		});	
		var textFieldDropTargetEl =  Ext.getCmp('ItemStandard').getEl();
		var formPanelDropTarget = new Ext.dd.DropTarget(textFieldDropTargetEl, {
			ddGroup     : 'ddGroup',
			notifyEnter : function(ddSource, e, data) {
				Ext.getCmp('ItemStandard').getEl().applyStyles({background:'yellow'});
			},
			notifyDrop  : function(ddSource, e, data){
				var txtItemId=Ext.getCmp('txtItemId').getValue()
				if(txtItemId==data.node.id){
						alert("基准项目不能和和相同")	
						return
				}
				Ext.getCmp('ItemStandard').getEl().applyStyles({background:'white'});
				Ext.getCmp('ItemStandardId').setValue(data.node.id);
				Ext.getCmp('ItemStandard').setValue(data.node.text);
				var txtRuleDesc=Ext.getCmp('txtRuleDesc')
				txtRuleDesc.setValue("");
				txtRuleDesc.setValue(Ext.getCmp('ItemStandard').getValue()+" "+Ext.getCmp('txtTimeMax').value+"小时后 "+Ext.getCmp('txtItemDesc').getValue())
				return(true);
			}
		});	
		
	}
		
}
