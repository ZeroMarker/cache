(function(){
	Ext.ns("dhcwl.mkpi.showkpidata");
})();
dhcwl.mkpi.showkpidata.SetFilterRule=function(){
	
	var parentWin;
	var nickName="", insertIdentity="", emptyOutputValue = '过滤表达式......';
	var kpiRuleStr="";
	var type="kpiRule", kpiTreeArg="";
	var kpiCodeStr="", currentLeafNode="", filterFuncStr="", logicalOperatorStr="";
	var kpiFilterStr = new Array(), filterStr = new Array(), value = new Array();
	var kpiFilterSaveStr="";
	filterStr[0] = "";
	//	**************************************************************数据存储结构说明********************************************************
	//	kpiFilterStr[kpiCode]=subFilterStrId+','+subFilterStrId
	//	filterStr[subFilterStrId]=subFilterStr
	//	[]kpiFilterStr用来存储指标kpiId的各个子过滤表达式的Id(subFilterStrId)
	//	[]filterStr用来存储所有得到的子过滤表达式(subFilterStr)
	//	******************************************************************kpiPanel*************************************************************
	
	var kpiTreePanel = new Ext.tree.TreePanel({
		title:'指标取数规则解析来的指标树',
		id:'kpiTreePanel',
		width:400,
		height:320,
		//xtype:'treepanel',
		//frame:true,
		autoScroll:true,
		rootVisible:true,
		split:true,
		loader:new Ext.tree.TreeLoader({
			dataUrl:'dhcwl/kpi/setfilterservice.csp?action=getList&type=root&kpiRuleStr='+kpiRuleStr
		}),
		root:new Ext.tree.AsyncTreeNode({
			id:'root',
			text:'指标树\/指标\/指标维度\/维度属性',
			expanded:false
		}),
		listeners:{
			'click':function(node,e){
				node.toggle();
				currentLeafNode = node;
			},
			'dblclick':function(node,e){
				setFilter(node);
				/*
				var args = node.id.split("-");
				type = args[0];
				if (!(node.isLeaf()) && ('kpiDim'!=type) && ('secDim'!=type)) {
					return;
				}
				currentLeafNode = node;
				
				var kpiCode = "";
				if(node.isLeaf()){
					kpiCode = node.parentNode.parentNode.text;
				}else if ('kpiDim'==type){
					kpiCode = node.parentNode.text;
				}else if ('secDim'==type){
					kpiCode = node.parentNode.text;
				}
				
				if (!!(kpiFilterStr[kpiCode])&&("&&"!=logicalOperatorStr)&&("||"!=logicalOperatorStr)){
					Ext.MessageBox.alert("消息","您所选择的指标已经有过滤表达式了。<br>如果要继续添加表达式，您需要从逻辑运算符列表中选择一个'&&'或'||'逻辑运算符！");
					return;
				}else if (""==filterFuncStr){
					Ext.MessageBox.alert("消息","您需要选择一个过滤函数！");
					return;
				}else if ((""==filterFuncStr)){
					Ext.MessageBox.alert("消息","您需要选择一个维度属性！");
					return;
				}
				
				if(node.isLeaf()){
					getCodeByLeafNode(currentLeafNode);
				}else if ('kpiDim'==type){
					getCodeByKpiDimNode(currentLeafNode);
				}else if ('secDim'==type){
					getCodeByKpiDimNode(currentLeafNode);
				}*/
			},
			'beforeload':function(node){
				var args = node.id.split("-");
				type = args[0];
				if ('root'==type) {
					kpiTreeArg = '&kpiRuleStr='+kpiRuleStr;
				} else if ('kpi'==type) {
					//kpiTreeArg = '&kpiRuleStr='+kpiRuleStr+'&kpiCode='+node.text;
					kpiTreeArg = '&kpiRuleStr=&kpiCode='+node.text;	//取指标的全部指标维度
				} else if ('kpiDim'==type) {
					//kpiTreeArg = '&kpiRuleStr='+kpiRuleStr+'&kpiCode='+node.parentNode.text+'&kpiDimCode='+node.text;
					kpiTreeArg = '&kpiRuleStr=&kpiCode='+node.parentNode.text+'&kpiDimCode='+node.text;	//取指标维度的全部维度属性
				} else if ('secDim'==type) {		//add by wz.2015-1-27
					kpiTreeArg = '&kpiRuleStr=&kpiCode='+node.parentNode.text+'&secDimCode='+node.text;	//取指标维度的全部维度属性
				}
				//alert(type+kpiTreeArg);
				node.loader = new Ext.tree.TreeLoader({
					dataUrl:'dhcwl/kpi/setfilterservice.csp?action=getList&type='+type+kpiTreeArg
				});
			}
		}
	});
	
	//	
	function getCodeByLeafNode(leafNode){
		if (!leafNode.isLeaf()){
			return;
		}
		var node = leafNode;
		do{
			var args = node.id.split("-"), type = args[0], id = args[1], code = node.text;
			var mCode=code.split("-");
			code=mCode[0];
			if ("dimPro"==type || "secPro"==type ){
				kpiCodeStr = code;
			}else if ("kpiDim"==type){
				kpiCodeStr = '{'+code+'.'+kpiCodeStr+'}';
			}else if ("kpi"==type){
				kpiCodeStr = code+':(['+kpiCodeStr;
			}else if ("secDim"==type){
				kpiCodeStr = '{$'+code+'.'+kpiCodeStr+'}';
			}
			node = node.parentNode;	//可保证code串拼接顺序按"维度属性->维度->指标"
		}while("root"!=node.id)
			
		Ext.MessageBox.prompt("添加子过滤表达式(动态参数以$开头)","<font color=blue>指标"+leafNode.parentNode.parentNode.text+"的维度"+leafNode.parentNode.text+"下的维度属性"+leafNode.text+"的过滤值(其中可以有','作为分隔符)为：</font>",
			function(btn, text){
				if (btn == 'ok'){
					if (!text) {
						Ext.MessageBox.alert("消息","<font color=blue>您不指定一个值的话，我怎么帮您过滤呢？</font>");
						return;
					}/*else{
						if ((-1!=text.search(/[^[A-Z]]/i)) && (-1!=text.search(/[^[0-9]]/)) && (-1!=text.search(/[^[,]]/i))) {
							Ext.MessageBox.alert("消息","<font color=blue>存在不支持的字符，只支持字母，数字，逗号！</font>");
							return;
						}
					}*/
					
					
					//add by wz.2014-4-7
					if(filterFuncStr.indexOf("[") >=0){
						var tmpFunStr=filterFuncStr.split("[");
						filterFuncStr=tmpFunStr[0]+"\\["+tmpFunStr[1]
						//alert (filterFuncStr);
					}
					if(filterFuncStr.indexOf("]") >=0){
						var tmpFunStr=filterFuncStr.split("]");
						filterFuncStr=tmpFunStr[0]+"\\]"+tmpFunStr[1]
						//alert (filterFuncStr);
					}
					
					
					filterFuncStr = filterFuncStr.replace("‘","'");
					kpiCodeStr = kpiCodeStr+' '+filterFuncStr+' '+text+'])';	//logicalOperatorStr
					// Now, we get the string like this:"kpiCode:[{dimCode.dimProCode} filterFunc filterValue]"
					// Just switch the kpiId to string, and use the string as Array index;
					var kpiCode = leafNode.parentNode.parentNode.text;
					if (!kpiFilterStr[kpiCode]){
						kpiFilterStr[kpiCode] = kpiCodeStr;
					}else{
						var tempArr = kpiCodeStr.split(':(');
						if (("&&"==logicalOperatorStr)||("||"==logicalOperatorStr)) {
							var tempStr = kpiFilterStr[kpiCode], lenOfGet = tempStr.length-1;
							kpiFilterStr[kpiCode] = tempStr.substring(0,lenOfGet)+' '+logicalOperatorStr+' '+tempArr[1];
						}
					}
					UpdateTextZoneValue();
					
					// 清空input中所有选区
					currentLeafNode.unselect();
					filterFuncGrid.getSelectionModel().clearSelections();
					logicalOperatorGrid.getSelectionModel().clearSelections();
					currentLeafNode="", filterFuncStr="", logicalOperatorStr="";	// 当次全部操作完成，置空信号变量
					//currentLeafNode.setText('<font color=black>'+currentLeafNode.text+'<font>');
					
				}
			},
		this,true,"");
	}
	
	function getCodeByKpiDimNode(notLeafNode){
		var args = notLeafNode.id.split("-");
		type = args[0];
		if ('kpiDim'!=type && 'secDim'!=type ) {
			return;
		}
		
		var node = notLeafNode;
		do{
			var args = node.id.split("-"), type = args[0], id = args[1], code = node.text;
			var mCode=code.split("-");
			code=mCode[0];
			if ("kpiDim"==type){
				kpiCodeStr = '{'+code+'}';
			}else if ("kpi"==type){
				kpiCodeStr = code+':(['+kpiCodeStr;
			}else if ("secDim"==type){
				kpiCodeStr = '{$'+code+'}';
			}
			node = node.parentNode;	//可保证code串拼接顺序按"维度属性->维度->指标"
		}while("root"!=node.id)
			
		Ext.MessageBox.prompt("添加子过滤表达式(动态参数以$开头)","<font color=blue>指标"+notLeafNode.parentNode.text+"的维度"+notLeafNode.text+"的过滤值(其中可以有','作为分隔符)为：</font>",
			function(btn, text){
				if (btn == 'ok'){
					if (!text) {
						Ext.MessageBox.alert("消息","<font color=blue>您不指定一个值的话，我怎么帮您过滤呢？</font>");
						return;
					}/*else{
						alert(text.search(/[^[0-9]]/));
						if ((-1==text.search(/[^[A-Z]]/i)) && (-1==text.search(/[^[0-9]]/)) && (-1==text.search(/[^[,]]/i))) {
							Ext.MessageBox.alert("消息","<font color=blue>存在不支持的字符，只支持字母，数字，逗号！</font>");
							return;
						}
					}*/
					filterFuncStr = filterFuncStr.replace("‘","'");
					kpiCodeStr = kpiCodeStr+' '+filterFuncStr+' '+text+'])';	//logicalOperatorStr
					// Now, we get the string like this:"kpiCode:[{dimCode.dimProCode} filterFunc filterValue]"
					// Just switch the kpiId to string, and use the string as Array index;
					var kpiCode = notLeafNode.parentNode.text;
					if (!kpiFilterStr[kpiCode]){
						kpiFilterStr[kpiCode] = kpiCodeStr;
					}else{
						var tempArr = kpiCodeStr.split(':(');
						if (("&&"==logicalOperatorStr)||("||"==logicalOperatorStr)) {
							var tempStr = kpiFilterStr[kpiCode], lenOfGet = tempStr.length-1;
							kpiFilterStr[kpiCode] = tempStr.substring(0,lenOfGet)+' '+logicalOperatorStr+' '+tempArr[1];
						}
					}
					UpdateTextZoneValue();
					
					// 清空input中所有选区
					currentLeafNode.unselect();
					filterFuncGrid.getSelectionModel().clearSelections();
					logicalOperatorGrid.getSelectionModel().clearSelections();
					currentLeafNode="", filterFuncStr="", logicalOperatorStr="";	// 当次全部操作完成，置空信号变量
					//currentLeafNode.setText('<font color=black>'+currentLeafNode.text+'<font>');
					
				}
			},
		this,true,"");
	}
	
	function UpdateTextZoneValue(){
		var key = "", tempValue = "";
		var textZoneValue=Ext.getCmp('textZone').getValue();
		for (key in kpiFilterStr){
			if ((Ext.isIE)&&(('indexOf'==key)||('remove'==key))){
				continue;
			}else if ('remove'==key) {
				continue;
			}
			if (!kpiFilterStr[key]) continue;
			if (((!!kpiFilterStr[key]) && (emptyOutputValue==textZoneValue)) || (""==tempValue)){
				tempValue = kpiFilterStr[key];
			}else{
				tempValue = tempValue+','+kpiFilterStr[key];
			}
			textZoneValue=Ext.getCmp('textZone').getValue();
		}
		Ext.getCmp('textZone').setRawValue(tempValue);
		
		nickName = "unsave";
		return;
	}
	
	function InsertText(value){
		var obj = document.getElementById('textZone'), selection = document.selection;
		if (emptyOutputValue==obj.value){
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
				if (!!kpiFilterStr[kpiCode]) {
					kpiFilterStr[kpiCode] = args[i];
				}
			}
		}else{
			var value = obj.value;
			var tempArr = value.split(':('), kpiCode = tempArr[0];
			if (!!kpiFilterStr[kpiCode]) {
				kpiFilterStr[kpiCode] = value;
			}
		}
	}
	
	//	********************************************************************over****************************************************************
	
	//	******************************************************************logicalOperatorPanel*******************************************************
	
	var logicalOperatorStore = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:'dhcwl/kpi/setfilterservice.csp?action=getLogicalOperators&start=0&pageSize=20'}),
		reader:new Ext.data.JsonReader({
			totalProperty:'totalNum',
			root:'root',
			fields:[
				{name:'code'},
				{name:'desc'}
			]
		})
	});
	
	var logicalOperatorGrid = new Ext.grid.GridPanel({
		title:'逻辑运算符与其他标识符',
		frame:true,
		width:295,
		height:320,
		viewConfig:{
			forceFit:true
		},
		store:logicalOperatorStore,
		bbar:new Ext.PagingToolbar({
			pageSize:20,
			store:logicalOperatorStore,
			displayInfo:true,
			displayMsg:'{0}~{1}条,共 {2} 条',
			emptyMsg:'sorry,data not found!',
			listeners :{
				'beforechange':function(pt,page){
					logicalOperatorStore.proxy.setUrl(encodeURI('dhcwl/kpi/setfilterservice.csp?action=getLogicalOperators'));
				}
			}
		}),
		cm:new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(),
			{header:'标识符',dataIndex:'code',sortable:true,anchor:'100%',menuDisabled : true}/*,
			{header:'描述',dataIndex:'desc',sortable:true,anchor:'100%'}*/
		]),
		sm:new Ext.grid.RowSelectionModel({
        	singleSelect: true,
            listeners: {
            	'rowselect': function(sm, row, rec){
					logicalOperatorStr = rec.get('code');
				}
			}
		}),
		listeners:{
			'rowdblclick':function(grid,rowIndex,event){
				var sm=grid.getSelectionModel();
				if(!sm) return;
				var record = sm.getSelected();
        		if(!record) return;
				var insertIdentity = record.get('code');
				if (('!'==insertIdentity)||('['==insertIdentity)||(']'==insertIdentity)){
					InsertText(insertIdentity);
				}
			}
		}
	});
	
	logicalOperatorGrid.on('render', function(grid) {    
		var store = grid.getStore();  // Capture the Store.    
		
		var view = grid.getView();    // Capture the GridView.    
		
		logicalOperatorGrid.tip = new Ext.ToolTip({    
			target: view.mainBody,    // The overall target element.    
		
			delegate: '.x-grid3-row', // Each grid row causes its own seperate show and hide.    
		
			trackMouse: true,         // Moving within the row should not hide the tip.    
		
			renderTo: document.body,  // Render immediately so that tip.body can be referenced prior to the first show.    
		
			listeners: {              // Change content dynamically depending on which element triggered the show.    
		
				beforeshow: function updateTipBody(tip) {    
					var rowIndex = view.findRowIndex(tip.triggerElement);    
					tip.body.dom.innerHTML = store.getAt(rowIndex).get('desc');    
				}    
			}    
		});    
	});   

	//	********************************************************************over****************************************************************
	
	//	******************************************************************filterFuncPanel*************************************************************
	
	var filterFunctionStore = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:'dhcwl/kpi/filterfunccfg.csp?action=lookup&start=0&pageSize=15'}),
		reader:new Ext.data.JsonReader({
			totalProperty:'totalNum',
			root:'root',
			fields:[
				//{name:'ID'},		//--modify by wz.2014-4-21
				{name:'FilterFuncID'},
				{name:'FilterFuncCode'},
				{name:'FilterFuncPrototype'},
				{name:'FilterFuncExecCode'},
				{name:'FilterFuncFuncDesc'}
			]
		})
	});
	
	var filterFuncGrid = new Ext.grid.GridPanel({
		title:'过滤函数',
		frame:true,
		width:300,
		height:320,
		viewConfig:{
			forceFit: true
		},
		store:filterFunctionStore,
		bbar:new Ext.PagingToolbar({
			pageSize:15,
			store:filterFunctionStore,
			displayInfo:true,
			displayMsg:'{0}~{1}条,共 {2} 条',
			emptyMsg:'sorry,data not found!',
			listeners :{
				'beforechange':function(pt,page){
					filterFunctionStore.proxy.setUrl(encodeURI('dhcwl/kpi/filterfunccfg.csp?action=lookup'));
				}
			}
		}),
		cm:new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(),
			//{header:'ID',dataIndex:'ID',sortable:true,width:15},
			{header:'ID',dataIndex:'FilterFuncID',sortable:true,width:15,menuDisabled : true},
			{header:'函数代码',dataIndex:'FilterFuncCode',sortable:true,width:50,menuDisabled : true},
			{header:'函数原型',dataIndex:'FilterFuncPrototype',sortable:true,anchor:'100%',menuDisabled : true}/*,
			{header:'执行代码',dataIndex:'FilterFuncExecCode',sortable:true,anchor:'5%'},
			{header:'功能描述',dataIndex:'FilterFuncFuncDesc',sortable:true,anchor:'5%'}*/
		]),
		sm:new Ext.grid.RowSelectionModel({
        	singleSelect: true,
            listeners: {
            	'rowselect': function(sm, row, rec){
					filterFuncStr = rec.get('FilterFuncCode');
				}
			}
		}),
		listeners:{
			'rowdblclick' : function( grid,rowIndex, e ) {
				var treeNode=kpiTreePanel.getSelectionModel().getSelectedNode();
				setFilter(treeNode);
			}
		}
	});
	
	filterFuncGrid.on('render', function(grid) {    
		var store = grid.getStore();  // Capture the Store.    
		
		var view = grid.getView();    // Capture the GridView.    
		
		logicalOperatorGrid.tip = new Ext.ToolTip({    
			target: view.mainBody,    // The overall target element.    
		
			delegate: '.x-grid3-row', // Each grid row causes its own seperate show and hide.    
		
			trackMouse: true,         // Moving within the row should not hide the tip.    
		
			renderTo: document.body,  // Render immediately so that tip.body can be referenced prior to the first show.    
		
			listeners: {              // Change content dynamically depending on which element triggered the show.    
		
				beforeshow: function updateTipBody(tip) {    
					var rowIndex = view.findRowIndex(tip.triggerElement);    
					tip.body.dom.innerHTML = store.getAt(rowIndex).get('FilterFuncFuncDesc');    
				}    
			}    
		});    
	});   

	//	***********************************************************************over*******************************************************************
	
	//	******************************************************************outputPanel*************************************************************
	
	var textZone = new Ext.form.TextArea({
		id:'textZone',
		title:'输出',
		width:850,
		height:115,
		enableKeyEvents:true,
		//value:"",
		maskRe:/37|38|39|40/	//	/37|38|39|40|8|13|32/屏蔽方向左、上、右、下、退格、回车、空格外的其他按键
		/*listeners:{
			'keypress':function(ele, event){
				alert(event.getKey());
			}
		}*/
	});
	
	
	var inputPanel = new Ext.Panel({
		height:325,
		//frame:true,
		monitorResize:true,
		layout:'border',
		items:[{
			region:'west',
			width:400,
			items:kpiTreePanel
		},{
			region:'center',
			items:filterFuncGrid
		},{
			region:'east',
			width:300,
			items:logicalOperatorGrid
		}]
	});
	
	var outputPanel = new Ext.Panel({
		width:1000,
		height:155,
		frame:true,
		monitorResize:true,
		layout:'border',
		items:[{region:'center',
			items:textZone
		},{
			region:'east',
			width:120,
			layout:'table',
			layoutConfig:{columns:1},
			items:[{
				html:'',
				height:25
			},{
				width:100,
				frame:'true',
				height:30,
				//text:'新增',
				text: '<span style="line-Height:1">新增</span>',
				icon: '../images/uiimages/edit_add.png',
				xtype:'button',
				listeners:{
					'click':function(){
						var treeNode=kpiTreePanel.getSelectionModel().getSelectedNode();
						setFilter(treeNode);
						/*
						node = currentLeafNode;
						if (!!node == false) {
							Ext.MessageBox.alert("消息","请先选择一个维度或者维度属性吧！");
							return;
						}
						if ((node.isLeaf()) && ('kpiDim'==type)) {
							return;
						}
						
						var kpiCode = "";
						if(node.isLeaf()){
							kpiCode = node.parentNode.parentNode.text;
						}else if ('kpiDim'==type){
							kpiCode = node.parentNode.text;
						}
						
						if (!!(kpiFilterStr[kpiCode])&&("&&"!=logicalOperatorStr)&&("||"!=logicalOperatorStr)){
							Ext.MessageBox.alert("消息","您所选择的指标已经有过滤表达式了。<br>如果要继续添加表达式，您需要从逻辑运算符列表中选择一个'&&'或'||'逻辑运算符！");
							return;
						}else if (""==filterFuncStr){
							Ext.MessageBox.alert("消息","您需要选择一个过滤函数！");
							return;
						}else if ((""==filterFuncStr)){
							Ext.MessageBox.alert("消息","您需要选择一个维度属性！");
							return;
						}
						
						var args = node.id.split("-");
						type = args[0];
						if(node.isLeaf()){
							getCodeByLeafNode(currentLeafNode);
						}else if ('kpiDim'==type){
							getCodeByKpiDimNode(currentLeafNode);
						}
						*/
					}
				}
			},{
				width:100,
				frame:'true',
				height:30,
				//text:'清空',
				text: '<span style="line-Height:1">清空</span>',
				icon: '../images/uiimages/clearscreen.png',
				xtype:'button',
				listeners:{
					'click':function(){
						if (""==nickName){
							return;
						}else if ("unsave"==nickName){
							Ext.Msg.confirm("消息","<font color=red>您尚未保存，确定清除当前的过滤表达式吗？</font>", function(btn){
								if ('yes' == btn)
								{
									Ext.getCmp('textZone').setValue(emptyOutputValue);
									/*while (kpiFilterStr.length>0) {
										kpiFilterStr.pop();
									}
									while (filterStr.length>0) {
										filterStr.pop();
									}
									while (value.length>0) {
										value.pop();
									}*/
									kpiFilterStr=[], filterStr=[], value=[];
								}
							});
						}
					}
				}
			},{
				width:100,
				frame:'true',
				height:30,
				//text:'保存',
				text: '<span style="line-Height:1">保存</span>',
				icon: '../images/uiimages/filesave.png',
				xtype:'button',
				listeners:{
					'click':function(){
						//if (""==nickName){
							//return;
						//}
						var rule = Ext.getCmp('textZone').getValue();
						if (rule==emptyOutputValue){
							rule="";
						}
						var isRight = Check(rule);
						if (true != isRight) {
							Ext.MessageBox.alert("消息","<font color=blue>"+isRight+"</font>");
							return;
						}
						if (parentWin.setKpiRule) {
							Ext.MessageBox.prompt("保存当前过滤表达式","<font color=blue>现在您可以为当前过滤表达式定义一个昵称，方便之后使用<font color=red><br>(tip：该过滤表达式将在数据预览页面关闭之后清除，如果有必要，请务必拷贝保存！）：</font>",
								function(btn, text){
									if (btn == 'ok'){
										rule = LastSwitch(rule);
										nickName = text;
										if (""==nickName) {
											nickName = rule;
										}
										//Ext.MessageBox.alert("消息","这是您刚刚保存的过滤表达式：<br><font color=blue>"+rule+"</font>");
										parentWin.setFilterRuleArray(nickName,rule);
										setFilterWin.close();
									}
								},
								this,true,"");
						}else{
							parentWin.SetDatasetKpiFilter(nickName,rule);
							setFilterWin.close();
						}
					}
				}
			}]
		}]
	});	
	
	function Check(rule) {
		var len = rule.length, isRight = "";
		//	方括弧匹配校验
		var currentChar = "", counter = 0;
		for (var i=1; i<len; i++) {
			currentChar = rule.charAt(i);
			if ('['==currentChar) {
				//add by wz.2014-4-7
				if(i>=2){
					if(rule.charAt(i-1)=="\\" ){
						continue;		//方括号被转义了。
					}
				}
				counter++;
			}else if (']'==currentChar) {
				//add by wz.2014-4-7
				if(i>=2){
					if(rule.charAt(i-1)=="\\" ){
						continue;		//方括号被转义了。
					}
				}				
				counter--;
			}
		}
		if (0!=counter) {
			return "检测到您定义的过滤表达式中'['和']'不匹配，请检查!在您修改使之匹配后方可保存!";
		}
		return true;
	}
	
	function LastSwitch(rule) {
		var tempArr = rule.split('\n'), key = "";
		rule = "";
		for (key in tempArr){
			if ((Ext.isIE)&&(('indexOf'==key)||('remove'==key))){
				continue;
			}else if ('remove'==key) {
				continue;
			}
			
			if (""==rule){
				rule = tempArr[key];
			}else{
				rule = rule+','+tempArr[key];
			}
		}
		return rule;
	}
	
	this.setParentWin=function(win){
		parentWin=win;
	}
	/*this.setFilterCode=function(selectedFilters){
		selectFilters=selectedFilters;
	}*/
	//	***********************************************************************over*********************************************************************
	
	//	***********************************************************************
	
	var filterRulePanel = new Ext.Panel({
		width:1000,
		height:480,
		//title:'生成过滤规则',
		//frame:true,
		monitorResize:true,
		layout:'border',
		items:[{
			region:'center',
			height:320,
			items:inputPanel
		},{
			region:'south',
			height:160,
			items:outputPanel
		}]
	});
	
	var setFilterWin = new Ext.Window({
		//id:'kpiWin',
		title:'过滤规则生成',
		//frame:true,
		width:1010,
		autoScroll:true,
		height:520,
		//height:Ext.getBody().getHeight()-50,
		resizable:true,
		//closeAction:'hide',
		modal:true,
		items:filterRulePanel
	});
	
	this.GetFilterRule = function(){
		
	}
	
	//	初始化指标树
	this.InitKpiTreePanel = function(kpiRule,kpiFilter){
		//kpiRule='RegLocOpNums:PatLoc.Loc,RegLocStOpNums:Loc.Loc,RegLocSexAge:Loc.Loc,MRLocCyrs:Loc.Loc,MRLocSjzcr:Loc.Loc';
		kpiRuleStr = kpiRule;
		kpiFilterSaveStr = kpiFilter;
		
		kpiTreePanel.getRootNode().loader = new Ext.tree.TreeLoader({
			dataUrl:'dhcwl/kpi/setfilterservice.csp?action=getList&type=root&kpiRuleStr='+kpiRuleStr
		});
		kpiTreePanel.getRootNode().reload();
		kpiTreePanel.getRootNode().expand();
		if ((kpiFilter!="")&&(kpiFilter!=emptyOutputValue)){
			var cmp=Ext.getCmp('textZone')
			cmp.setValue(kpiFilterSaveStr);
			var filterSaveStr=kpiFilterSaveStr.split(",");
			var i=0;
			var kpiCodes="";
			var kpiCode="";
			var kpiFilterSave="";
			for (var j=0;j<(filterSaveStr.length);j++){
				var len=filterSaveStr.length;
				if(filterSaveStr[i]==""){
					break;
				}else{
					kpiFilterSave=filterSaveStr[i];
					kpiCodes=kpiFilterSave.split(":");
					kpiCode=kpiCodes[0];
					//kpiCodeStr=kpiCodes[1];
					if (kpiCode==""){
						continue;
					}
					if (!kpiFilterStr[kpiCode]){
						kpiFilterStr[kpiCode] = kpiFilterSave;
					}else{
						var tempArr = kpiCodeStr.split(':(');
						if (("&&"==logicalOperatorStr)||("||"==logicalOperatorStr)) {
							var tempStr = kpiFilterStr[kpiCode], lenOfGet = tempStr.length-1;
							kpiFilterStr[kpiCode] = tempStr.substring(0,lenOfGet)+' '+logicalOperatorStr+' '+tempArr[1];
						}
					}
				}
				i=i+1;
		}
			nickName = "unsave"
		}
		var kpiCodes=kpiFilterSaveStr.split(":");
		var kpiCode=kpiCodes[1];
		//Ext.Msg.alert("提示",kpiCode);
		/*if (kpiFilterSaveStr!=""){
			Ext.getCmp('textZone').setRawValue(kpiFilterSaveStr);
			nickName = "unsave";
		}*/
	}
	
	this.show = function(){
		var filterfuncstore = filterFuncGrid.getStore();
		filterfuncstore.load();
		var logicalOperatorStore = logicalOperatorGrid.getStore();
		logicalOperatorStore.load();
		setFilterWin.show();
		//if (!Ext.getBody().getHeight()){
			//setFilterWin.setHeight(400);
		//}
	}
	function setFilter(node){
		if (!node) {
			Ext.Msg.alert("提示","请选择维度！");
			return;
		}
		var args = node.id.split("-");
		type = args[0];
		if (!(node.isLeaf()) && ('kpiDim'!=type) && ('secDim'!=type)) {
			return;
		}
		currentLeafNode = node;
		
		var kpiCode = "";
		if(node.isLeaf()){
			kpiCode = node.parentNode.parentNode.text;
		}else if ('kpiDim'==type){
			kpiCode = node.parentNode.text;
		}else if ('secDim'==type){
			kpiCode = node.parentNode.text;
		}
		
		if (!!(kpiFilterStr[kpiCode])&&("&&"!=logicalOperatorStr)&&("||"!=logicalOperatorStr)){
			Ext.MessageBox.alert("消息","您所选择的指标已经有过滤表达式了。<br>如果要继续添加表达式，您需要从逻辑运算符列表中选择一个'&&'或'||'逻辑运算符！");
			return;
		}else if (""==filterFuncStr){
			Ext.MessageBox.alert("消息","您需要选择一个过滤函数！");
			return;
		}else if ((""==filterFuncStr)){
			Ext.MessageBox.alert("消息","您需要选择一个维度属性！");
			return;
		}
		
		if(node.isLeaf()){
			getCodeByLeafNode(currentLeafNode);
		}else if ('kpiDim'==type){
			getCodeByKpiDimNode(currentLeafNode);
		}else if ('secDim'==type){
			getCodeByKpiDimNode(currentLeafNode);
		}		
	}
}

