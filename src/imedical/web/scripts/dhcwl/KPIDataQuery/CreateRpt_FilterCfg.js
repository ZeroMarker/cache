(function(){
	Ext.ns("dhcwl.KDQ.CreateRptFilterCfg");
})();
///描述: 		查询对象
///编写者：		WZ
///编写日期: 		2016-11
dhcwl.KDQ.CreateRptFilterCfg=function(createR){
	var createRpt=createR;
	var serviceUrl="dhcwl/kpidataquery/createrptfiltercfg.csp";
	var outThis=this;
	var inParam;
	var filterStr="";
	var kpiFilterStr = new Object;
	///////////////////////////////////////////////////////////////
	//dimTree

	var dimTree = new Ext.tree.TreePanel({
		title:'过滤项（角色/属性）',
		ddGroup: 'treeNodeDDGroup',
		enableDrag:true,
		border:false,
		autoScroll : true,
		animate : true,
		containerScroll : true,
		loader : new Ext.tree.TreeLoader({
		      dataUrl : serviceUrl
		        }),
		listeners:{
			'beforeload':function(node){
				if (node.id=="root") {
					if(inParam.orderFrom=="CreateRpt") {	//创建时走此流程
						var reqRoles=inParam.roles+","+inParam.searchItemRoles;
						//var reqRoles=inParam.roles;
						node.loader = new Ext.tree.TreeLoader({
							dataUrl:serviceUrl+'?action=getOptionalRoleOfFilter&roleCode='+reqRoles+'&businessType='+inParam.businessType
						});
					}else if(inParam.orderFrom=="ConfigRpt") { //配置时走此流程
						node.loader = new Ext.tree.TreeLoader({
							dataUrl:serviceUrl+'?action=getNodesOfKPI&kpiCode='+inParam.kpiCodes
						});
					} 					
				}else if (node.attributes.type=="kpi") {
					//var searchItemdimProCode=inParam.searchItemdimProCode;
					node.loader = new Ext.tree.TreeLoader({
						dataUrl:serviceUrl+'?action=getTreeNodeOfKpiRole&kpiCode='+node.attributes.code
					});	
				}else if (node.attributes.type=="role") {
					var searchItemdimProCode=inParam.searchItemdimProCode;
					node.loader = new Ext.tree.TreeLoader({
						dataUrl:serviceUrl+'?action=getTreeNodeOfDimPro&RoleCode='+node.attributes.code+'&searchItemdimProCode='+searchItemdimProCode
					});	
				}else if (node.attributes.type=="sec") {
					node.loader = new Ext.tree.TreeLoader({
						dataUrl:serviceUrl+'?action=getTreeNodeOfSecPro&secCode='+node.attributes.code
					});	
				}
			},
			'click':function(node,e){
				if (node.attributes.type=="pro") {
					proStore.removeAll();

					var dimCode=node.parentNode.attributes.dimCode;
					var proCode=node.attributes.code;
					proStore.setBaseParam("dimCode",dimCode);
					proStore.setBaseParam("proCode",proCode);
					proStore.setBaseParam("searchV","");
					proStore.setBaseParam("dimType",node.parentNode.attributes.type)
					proStore.reload();
					
					
					clearFilterV();
					
				}else{
					proStore.removeAll();
				}
			}
			

		}
		});

	var root = new Ext.tree.AsyncTreeNode({
			text : '过滤项（角色/属性）',
			draggable : false,
			id : 'root',//默认的node值：?node=-100
			type:'dir'
		  });


	dimTree.setRootNode(root);	

	///////////////////////////////////////////////////////////////////////////////////////
	/////过滤函数
	var filterStore = new Ext.data.Store({
 		proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=getFilterFun'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
				{name:'code'},
				{name:'descript'}
			]
    	})
    });
	
	var filterCml = new Ext.grid.ColumnModel({
		default:{
			sortable: true,
			menuDisabled : true
		},
		columns:[
			{header:'编码',dataIndex:'code',width: 50},
			{header:'描述',id:'descript',dataIndex:'descript',width: 100}
		]
	});
	
   var filterGrid = new Ext.grid.GridPanel({
        //height:480,
		title:'过滤函数',
		//layout:'fit',
        store: filterStore,
        cm: filterCml,
		autoExpandColumn: 'descript',
		stripeRows: true
	});	
	
	
	///////////////////////////////////////////////////////////////////////////////////////
	/////可选属性值
	var proStore = new Ext.data.Store({
 		proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=getOptionalProValue&start=0&limit=100'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
				{name:'value'}
			]
    	})
    });
	
	var proCml = new Ext.grid.ColumnModel({
		default:{
			sortable: true,
			menuDisabled : true
		},
		columns:[
			{header:'属性值',id:'value',dataIndex:'value',width: 100}
		]
	});
	
   var proGrid = new Ext.grid.GridPanel({
        //height:480,
		title:'可选过滤值',
		//layout:'fit',
        store: proStore,
        cm: proCml,
		autoExpandColumn: 'value',
		stripeRows: true,			
		bbar: new Ext.PagingToolbar({
			pageSize:100,
			store:proStore,
			displayInfo:true,
			displayMsg:'{0}~{1}条,共 {2} 条',
			emptyMsg:'sorry,data not found!'
		})
	});	

	//rowdblclick : ( Grid this, Number rowIndex, Ext.EventObject e ) 
	proGrid.on('rowdblclick',function(grid,rowIndex,e){
		var oldV=fForm.getForm().findField('selFilterV').getValue();
		var newV=proGrid.getStore().getAt(rowIndex).get('value');
		if (oldV=="") fForm.getForm().findField('selFilterV').setValue(newV);
		else fForm.getForm().findField('selFilterV').setValue(oldV+','+newV);
		
	});
	//////////////////////////////////////////////////////////////////////////////////////
	///过滤面板
	var fForm=new Ext.FormPanel({
		title:'操作',
		labelWidth: 80, // label settings here cascade unless overridden
		labelAlign : 'right',
        frame:true, 
		border:false,
		layout:'vbox',
		layoutConfig: {
			align : 'stretch',
			pack  : 'start',
		},
		items:[{
			flex:2,
			layout:'form',
			items:[{
				xtype:'fieldset',  
				title:'过滤值',
				items:[{
					hideLabel :true,
					name:'selFilterV',
					xtype:'textarea',
					anchor: '98%'
				}]
			},{
				xtype:'fieldset',  
				title:'与已选条件的逻辑关系',
				items:[{
					xtype:'radio',
					checked: true,
					hideLabel :true,
					boxLabel: '与',
					name: 'logicalOperator',
					inputValue: '&&'
				}, {
					xtype:'radio',
					hideLabel :true,
					boxLabel: '或',
					name: 'logicalOperator',
					inputValue: '||'
				}]				
					
			}],
		},{
			flex:1,
			layout: {
				type:'vbox',
				padding:'5',
				pack:'end',
				align:'center'
			},			
			items:[{
				buttonAlign:'center',
				buttons:[{
					text: '<span style="line-Height:1">确定</span>',
					icon   : '../images/uiimages/ok.png',
					handler: addFilterConf			
				}]			
			},{
				buttonAlign:'center',
				buttons:[{
					text: '<span style="line-Height:1">清空</span>',
					icon   : '../images/uiimages/clearscreen.png',
					handler: clearFilterV			
				}]			
			}]		
		
		}]
	})
	
	
	//////////////////////////////////////////////////////////////////////////////////////
	///过滤条件
	var filterStrForm=new Ext.FormPanel({
		title:'过滤条件',
		labelWidth: 80, // label settings here cascade unless overridden
		labelAlign : 'right',
        frame:true, 
		border:false,
		layout:'fit',
		items:[{
			hideLabel :true,
			name:'filterTextarea',
			id:'filterTextarea',
			xtype:'textarea',
			maskRe:/37|38|39|40/	//	/37|38|39|40|8|13|32/屏蔽方向左、上、右、下、退格、回车、空格外的其他按键
		}]
	})

	//////////////////////////////////////////////////////////////////////////////////////
	///过滤条件编辑工具
	var editFilterForm=new Ext.FormPanel({
		title:'编辑工具',
		labelWidth: 80, // label settings here cascade unless overridden
        frame:true, 
		border:false,
		//layout:'fit',
		//items:[{
		
		layout: {
			type:'hbox',
			align:'stretch'
		},	
		items:[{
			flex:1,
			layout: {
				type:'vbox',
				//padding:'5',
				pack:'center',
				align:'center'
			},			
			items:[{
				buttonAlign:'center',
				buttons:[{
					text: '<span style="line-Height:1">插入 " ! "</span>',
					id:'flagNo',
					handler: insertFilterStr			
				}]			
			},{
				buttonAlign:'center',
				buttons:[{
					text: '<span style="line-Height:1">插入 " [ "</span>',
					id:'flagleft',
					handler: insertFilterStr			
				}]			
			}]			
		},{
			flex:1,
			layout: {
				type:'vbox',
				//padding:'5',
				pack:'center',
				align:'center'
			},			
			items:[{
				buttonAlign:'center',
				buttons:[{
					text: '<span style="line-Height:1">插入 " ] "</span>',
					id:'flagright',
					handler: insertFilterStr			
				}]			
			},{
				buttonAlign:'center',
				buttons:[{
					text: '<span style="line-Height:1">清空</span>',
					icon   : '../images/uiimages/clearscreen.png',
					id:'clear',
					handler: function() {
						filterStrForm.getForm().findField("filterTextarea").setValue("");
						filterStr=""
						//清空已有的过滤规则
						for (var x in kpiFilterStr){
							delete kpiFilterStr[x];
						}							
						
					}					
				}]			
			}]				
			
		}]

		//}]
	})
	
	function insertFilterStr(btn) {
		var insStr="";
		if (btn.id=="flagNo") {
			insStr="!";
		}else if(btn.id=="flagleft") {
			insStr="[";
		}else if(btn.id=="flagright") {
			insStr="]";
		}
		
		InsertText(insStr);
	}
	
	
	
	
	
	function addFilterConf() {
		//1、判断是否已选择维度
		var node=dimTree.getSelectionModel().getSelectedNode();
		if (!node) {
			Ext.Msg.alert("提示","请选择维度！");
			return;
		}
		if (!node.id=="root") {
			Ext.Msg.alert("提示","请选择维度！");
			return;
		}
		
		type = node.attributes.type;
		if (!(node.isLeaf()) && ('role'!=type) && ('sec'!=type)) {
			return;
		}
		//2、取过滤函数值
		var rec=filterGrid.getSelectionModel().getSelected();
		if (!rec) {
			Ext.Msg.alert("提示","请选择过滤函数");
			return;
		}
		var filterFun=rec.get("code");
		//3、取逻辑操作符的值
		var logicalOperator=fForm.getForm().findField("logicalOperator").getGroupValue();
		//4、取过滤的值
		var selFilterV=fForm.getForm().findField("selFilterV").getValue();
		
		
		if ((filterStr!="")&&("&&"!=logicalOperator)&&("||"!=logicalOperator)){
			Ext.MessageBox.alert("消息","您所选择的维度/属性已经有过滤表达式了。<br>如果要继续添加表达式，您需要从逻辑运算符列表中选择一个'&&'或'||'逻辑运算符！");
			return;
		}else if (""==filterFun){
			Ext.MessageBox.alert("消息","您需要选择一个过滤函数！");
			return;
		}else if (""==selFilterV){
			Ext.MessageBox.alert("消息","您需要选择/填写一个过滤函数！");
			return;
		}
		
		
		getFilterStr(node);	
	
	}
	
	function getFilterStr(curNode){
		var node = curNode;
		var tfilterStr="";
		var kpiCode="";
		do{
			var type = node.attributes.type, id = node.id, code = node.attributes.code;
			if ("pro"==type){
				tfilterStr = code;
			}else if ("role"==type){
				if (tfilterStr!="")	tfilterStr = '{'+code+'.'+tfilterStr+'}';
				else tfilterStr = '{'+code+'}';
			}else if ("sec"==type){
				if (tfilterStr!="")	tfilterStr = '{$'+code+'.'+tfilterStr+'}';
				else tfilterStr = '{$'+code+'}';
			}else if ("kpi"==type){
				tfilterStr = code+':(['+tfilterStr;
				kpiCode=code;
			}
			node = node.parentNode;	//可保证code串拼接顺序按"维度属性->维度->指标"
		}while("root"!=node.id)
			
		//2、取过滤函数值
		
		var rec=filterGrid.getSelectionModel().getSelected();
		var filterFun=rec.get("code");
		
		//4、取过滤的值
		var filterV=fForm.getForm().findField("selFilterV").getValue();		

		//5、取逻辑操作符的值
		var logicalOperator=fForm.getForm().findField("logicalOperator").getGroupValue();
		
		
		if(filterFun.indexOf("[") >=0){
			var tmpFunStr=filterFun.split("[");
			filterFun=tmpFunStr[0]+"\\["+tmpFunStr[1]

		}
		if(filterFun.indexOf("]") >=0){
			var tmpFunStr=filterFun.split("]");
			filterFun=tmpFunStr[0]+"\\]"+tmpFunStr[1]
			//alert (ttfilterStr);
		}
		
		
		filterFun = filterFun.replace("‘","'");
		
		if (inParam.orderFrom=="CreateRpt") {
			tfilterStr= '['+tfilterStr+' '+filterFun+filterV+']';	

			if ((filterStr!="")&&(("&&"==logicalOperator)||("||"==logicalOperator))) {
				tfilterStr=" "+logicalOperator+" "+tfilterStr;
			}
		
			filterStr=filterStr+tfilterStr;
		}else if (inParam.orderFrom=="ConfigRpt") {
			filterStr="";
			tfilterStr= tfilterStr+' '+filterFun+filterV+'])';	
			filterStr=filterStr+tfilterStr;			

			if (!kpiFilterStr[kpiCode]){
				kpiFilterStr[kpiCode] = filterStr;
			}else{
				var tempArr = filterStr.split(':(');
				if (("&&"==logicalOperator)||("||"==logicalOperator)) {
					var tempStr = kpiFilterStr[kpiCode], lenOfGet = tempStr.length-1;
					kpiFilterStr[kpiCode] = tempStr.substring(0,lenOfGet)+' '+logicalOperator+' '+tempArr[1];
				}
			}			
			
			filterStr="";
			
			for (var x in kpiFilterStr){
				if (filterStr=="") filterStr=kpiFilterStr[x];
				else filterStr=filterStr+","+kpiFilterStr[x];
			}			
			
			
			/*
			if ((filterStr!="")&&(("&&"==logicalOperator)||("||"==logicalOperator))) {
				tfilterStr=" "+logicalOperator+" "+tfilterStr;
			}
			*/
		}
		
		filterStrForm.getForm().findField("filterTextarea").setValue(filterStr);	

		
		// 清空input中所有选区
		/*
		currentLeafNode.unselect();
		filterFuncGrid.getSelectionModel().clearSelections();
		logicalOperatorGrid.getSelectionModel().clearSelections();
		filterStr="";	// 当次全部操作完成，置空信号变量
		*/
		
	}
	
	function clearFilterV() {
		fForm.getForm().findField('selFilterV').setValue("");
	}
	
	var filterPanel = new Ext.Panel({
		border:false,
		layout: {
			type:'vbox',
			//padding:'5px',
			align:'stretch'
		},
		items: [
		{
			border:false,	
			flex:2,
			layout:'fit',
			items:[{
				layout: {
					type:'hbox',
					align:'stretch'
				},				
				items:[{
					flex:3,
					layout:'fit',
					items:dimTree
				},{
					flex:3,
					layout:'fit',
					items:filterGrid
				},{
					flex:3,
					layout:'fit',
					items:proGrid
				},{
					flex:2,
					layout:'fit',
					items:fForm
				}]
				
			}]
		},{
			border:false,	
			flex:1,
			layout:'fit',
			
			items:[{
				layout: {
					type:'hbox',
					align:'stretch'
				},				
				items:[{
					flex:3,
					layout:'fit',
					items:filterStrForm
				
				},{
					flex:1,
					layout:'fit',
					items:editFilterForm
				}]
				
			}]
		}]		
	});	


	var filterWin = new Ext.Window({
		width:900,
		height:550,
		resizable:false,
		closable : false,
		title:'修改',
		modal:true,
		items:filterPanel ,		
		layout:'fit',
		//autoScroll :true,			
		buttons: [
		{
			text: '<span style="line-Height:1">保存</span>',				
			icon   : '../images/uiimages/filesave.png',
			handler:OnSave			
		},{
			text: '<span style="line-Height:1">关闭</span>',
			icon   : '../images/uiimages/cancel.png',
			handler: CloseWins
		}]
	});	
	
	function OnSave() {
		if (!!outThis.CallBack) {
			var fText=filterStrForm.getForm().findField("filterTextarea").getValue();
			outThis.CallBack(fText);
			
		}
		filterWin.close();
	};
	
	function CloseWins() {
		filterWin.close();
	}		
	
	
	this.updateCreateData=function(inP) {
		inParam=inP;
		if(inP.orderFrom=="CreateRpt") { 	//在创建报表时被调用
			reloadTree();
			filterStore.reload();
			proGrid.getStore().removeAll();
		}
		if(inP.orderFrom=="ConfigRpt") { 	//在创建报表时被调用
			reloadTree();
			kpiFilterStr.length=0;
			filterStore.reload();
			proGrid.getStore().removeAll();
			
			for (var x in kpiFilterStr){
				delete kpiFilterStr[x];
			}	
		}
	};
	
	
	
	function reloadTree() {
		
		rootNode=dimTree.getRootNode();
		rootNode.remove(true);	
		var rootText='过滤项（角色/属性）';
		
		if(inParam.orderFrom=="ConfigRpt") rootText='过滤项（指标/角色/属性）';
		//rootNode.leaf=false;
		var root = new Ext.tree.AsyncTreeNode({
			text : rootText,
			draggable : false,
			id : 'root',//默认的node值：?node=-100
			type:'dir'
		  });
		dimTree.setRootNode(root);
		
	}

function InsertText(value){
		var obj = document.getElementById('filterTextarea'), selection = document.selection;
		//var obj = document.getElementByName('filterTextarea'), selection = document.selection;
		//var obj = filterStrForm.getForm().findField("filterTextarea"), selection = document.selection;
		if (""==obj.value){
			return;
		}
		obj.focus();
		if ('undefined'!=typeof(obj.selectionStart)){	// for FF,Chrome, Not IE
			var lastCh = obj.value.charAt(obj.selectionStart-1), nextCh = obj.value.charAt(obj.selectionStart);
			if (('['==value)&&(('['!=nextCh)&&('{'!=nextCh)&&('!'!=nextCh))){
				Ext.MessageBox.alert("消息","当前位置不允许插入字符'"+value+"'!");
				return;
			}else if (('!'==value)&&('['!=nextCh)) {
				Ext.MessageBox.alert("消息","当前位置不允许插入字符'"+value+"'!");
				return;
			}else if ((']'==value)&&((']'!=nextCh)&&(']'!=lastCh))) {
				Ext.MessageBox.alert("消息","当前位置不允许插入字符'"+value+"'!");
				return;
			}
			obj.selectionEnd = obj.selectionStart;	//	这里将选区置空，在起始位置插入值
			obj.value = obj.value.substr(0,obj.selectionStart)+value+obj.value.substr(obj.selectionEnd);	//	将选区内容替换为value值
			//obj.value = obj.value.substr(0,obj.selectionStart)+value+obj.value.substr(obj.selectionStart);	//	在选区开始处插入value值
			//obj.value = obj.value.substr(0,obj.selectionEnd)+value+obj.value.substr(obj.selectionEnd);	//	在选区结束处插入value值
		}else if (selection && selection.createRange){	// for IE
			var sel = selection.createRange();
			sel.moveStart('character', -1);
			var lastCh = sel.text;
			sel.moveStart('character', 1),sel.moveEnd('character', 1);
			var nextCh = sel.text;
			sel.moveEnd('character', -1)
			if (('['==value)&&(('['!=nextCh)&&('{'!=nextCh)&&('!'!=nextCh))){
				Ext.MessageBox.alert("消息","当前位置不允许插入字符'"+value+"'!");
				return;
			}else if (('!'==value)&&('['!=nextCh)) {
				Ext.MessageBox.alert("消息","当前位置不允许插入字符'"+value+"'!");
				return;
			}else if ((']'==value)&&((']'!=nextCh)&&(']'!=lastCh))) {
				Ext.MessageBox.alert("消息","当前位置不允许插入字符'"+value+"'!");
				return;
			}
			sel.text = value+sel.text;	//	在选区开始处插入value，其他同理
			sel.moveStart('character', -value.length);
		}else{
			obj.value += value;
		}
		
		// 对每个指标的指标表达式更新, 从文本框到数组的反向赋值
		if(-1!=obj.value.indexOf('\n')){	//有换行
			var args = obj.value.split('\n'), len = args.length;
			for (var i=0;i<len;i++){
				if (!args[i]) break;
				var tempArr = args[i].split(':('), kpiCode = tempArr[0];
				//alert(kpiCode);
				if (filterStr!="") {
					filterStr = args[i];
				}
			}
		}else{
			var value = obj.value;
			var tempArr = value.split(':('), kpiCode = tempArr[0];
			if (filterStr!="") {
				filterStr = value;
			}
		}
	}
	
	this.getDim=function() {
		var aryRoles=new Array();
		var fStr=filterStrForm.getForm().findField("filterTextarea").getValue();
		if (fStr!="") {
			var aryF1=fStr.split("{");
			for(var i=1;i<aryF1.length;i++) {
				var aryF2=aryF1[i].split(".");
				var role=aryF2[0];
				var sameFlag=0;
				for(var j=0;j<aryRoles.length;j++){
					if (role==aryRoles[j]) {
						sameFlag=1;
						break;
					}
				}
				if (sameFlag==0) aryRoles.push(role);
			}
		}
		
		var ret="";
		for(var j=0;j<aryRoles.length;j++){
			if (ret=="") ret=aryRoles[j];
			else ret=ret+","+aryRoles[j];
		}
		return ret; 
	}
	
	
    this.getFilterPanel=function(){
    	return filterPanel;
    }   

    this.getFilterText=function(){
    	return filterStrForm.getForm().findField("filterTextarea").getValue();
    }     
	
	this.getFilterWin=function() {
		
		return filterWin;
	}
	
	this.showWin=function() {
		filterWin.show();
		
	}
}

