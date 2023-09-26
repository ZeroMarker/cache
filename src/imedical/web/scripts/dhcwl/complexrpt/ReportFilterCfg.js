ReportFilterCfg
(function(){
	Ext.ns("dhcwl.complexrpt.ReportFilterCfg");
})();
dhcwl.complexrpt.ReportFilterCfg=function(){
	
	var parentWin;
	var nickName="", insertIdentity="", emptyOutputValue = '过滤表达式......';
	var kpiRuleStr="";
	var type="kpiRule", kpiTreeArg="";
	var kpiCodeStr="", 	currentSelNode="", filterFuncStr="", logicalOperatorStr="",filStr="";
	var kpiFilterStr = new Array(), filterStr = new Array(), value = new Array();
	filterStr[0] = "";
	//	**************************************************************数据存储结构说明********************************************************
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
		width:200,
		height:377,
		viewConfig:{
			forceFit:true
		},
		store:logicalOperatorStore,
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
				else{
					return;
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
		width:280,
		height:377,
		viewConfig:{
			forceFit: true
		},
		store:filterFunctionStore,
		bbar:new Ext.PagingToolbar({
			pageSize:15,
			store:filterFunctionStore,
			displayInfo:true,
			//displayMsg:'{0}~{1}条,共 {2} 条',
			displayMsg:'',
			emptyMsg:'sorry,data not found!',
			listeners :{
				'beforechange':function(pt,page){
					filterFunctionStore.proxy.setUrl(encodeURI('dhcwl/kpi/filterfunccfg.csp?action=lookup'));
				}
			}
		}),
		cm:new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(),
			//{header:'ID',dataIndex:'FilterFuncID',sortable:true,width:15,menuDisabled : true},
			{header:'函数代码',dataIndex:'FilterFuncCode',sortable:true,width:100,menuDisabled : true},
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
				//var treeNode=dimTreeGrid.getSelectionModel().getSelectedNode();
			}
		}
	});  

	//	***********************************************************************over*******************************************************************
	
	//	******************************************************************outputPanel*************************************************************
	
	var textZone = new Ext.form.TextArea({
		id:'textZone',
		width:860,
		height:100,
		//margins:'3 3 3 0', 
		enableKeyEvents:true,
		value:emptyOutputValue,
		maskRe:/37|38|39|40/	//	/37|38|39|40|8|13|32/屏蔽方向左、上、右、下、退格、回车、空格外的其他按键
		
	});
	
	var outputPanel = new Ext.Panel({
		title:'报表过滤表达式',
		width:1042,
		height:148,
		frame:true,
		monitorResize:true,
		layout:'border',
		items:[{region:'center',
			items:textZone
		},{
			region:'west',
			width:10,
			layout:'table',
			layoutConfig:{columns:1},
			items:""
		},{
			region:'north',
			height:5,
			layout:'table',
			layoutConfig:{rowumns:1},
			items:""
		},{
			region:'east',
			width:120,
			layout:'table',
			layoutConfig:{columns:1},
			items:[{
				html:'',
				height:10
			},{
				width:60,
				frame:'true',
				height:30,
				text:'保存数据',
				xtype:'button',
				listeners:{
					'click':function(){
						var fil=textZone.getValue();
						Ext.getCmp('colTextZone').setValue(fil);
						setFilterWin.close();
					}
				}
			},{
				html:'',
				height:15
			},{
				width:60,
				frame:'true',
				height:30,
				text:'清空数据',
				xtype:'button',
				listeners:{
					'click':function(){
						Ext.getCmp('textZone').setValue("");
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
	

	//	***********************************************************************over*********************************************************************
	//// 待选的统计项树
     //var tree = new Ext.ux.tree.TreeGrid({
	 var tree = new Ext.tree.TreePanel( {
		id:"cfgTreePanel",
		enableSort : false,
		autoScroll : true,
		containerScroll : true,
		lines :true,
        columns:[{
            header: '描述',
            width: 200,
            dataIndex: 'text'
        }],
		loader: new Ext.tree.TreeLoader()
		});

    
		var root = new Ext.tree.TreeNode( {
		code:"root",
		className:"",
	 	parentNO:'',
	 	NO:'root',
	    iconCls:'task-folder',
		text : '统计项/维度属性树',
		draggable : false,
	    expanded: true	
		  });
		tree.setRootNode(root);
		tree.on({
			'click':function(node, e){
				//node.toggle(); //改变树节点的收缩与展开状态
				if(node.attributes.className=="DHCWL.ComplexRpt.StatItem"){
					currentSelNode = "{"+node.attributes.code+"}";
					sCode=node.attributes.code;
					clFlag="StatItem";
				}else if(node.attributes.className=="DHCWL.MKPI.DimProperty"){
					currentSelNode="{"+node.parentNode.attributes.code+"."+node.attributes.code+"}";
					sCode=node.parentNode.attributes.code+"."+node.attributes.code;
					clFlag="DimProperty";
				}else{
					currentSelNode="",sCode="",clFlag="";
					return;
				}
				dimProStore.proxy.setUrl(encodeURI('dhcwl/complexrpt/rptdimservice.csp?action=getRptDimProValue&sCode='+sCode));
	            dimProStore.load({params:{start:0,limit:20}});
	            dimProGrid.show();
       		}
		});

	var dimTreeGrid = new Ext.Panel({
       	title:'统计项',
        width:230,
        height:374,
		layout:'fit',
		items:tree
	});
	
	
	var dimProStore = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:'dhcwl/complexrpt/rptdimservice.csp?action=getRptDimProValue&sCode=&dimProCode='}),
		reader:new Ext.data.JsonReader({
			totalProperty:'totalNum',
			root:'root',
			fields:[
				{name:'dimIDV'},
				{name:'dimProV'}
			]
		})
	});
	
	
	var dimProGrid = new Ext.grid.GridPanel({
		title:'维度属性列表',
		frame:true,
		width:330,
		height:250,
		enableColumnResize :true,
		viewConfig:{
			forceFit:true
		},
		store:dimProStore,
		bbar:new Ext.PagingToolbar({
			pageSize:20,
			store:dimProStore,
			displayInfo:true,
			displayMsg:'共{2}条数据',
			emptyMsg:'暂无数据哦!',
			listeners :{
				'beforechange':function(pt,page){
					dimProStore.proxy.setUrl(encodeURI('dhcwl/complexrpt/rptdimservice.csp?action=getRptDimProValue&sCode='+sCode+'&dimProCode='+dimProCode));
				}
			}
		}),
		cm:new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(),
			{header:'维度值',dataIndex:'dimIDV',sortable:true,width:50,menuDisabled : true},
			{header:'维度属性值',dataIndex:'dimProV',sortable:true,anchor:'100%',resizable:true,menuDisabled : true}
		]),
//		sm:new Ext.grid.RowSelectionModel({
//        	singleSelect: true,
//            listeners: {
//            	'rowselect': function(sm, row, rec){
//					Str = rec.get('code');
//				}
//			}
//		}),
		listeners:{
			'rowdblclick':function(grid,rowIndex,event){
				var sm=grid.getSelectionModel();
				if(!sm) return;
				var record = sm.getSelected();
        		if(!record) return;
        		if(clFlag=="StatItem"){
        			var insertIdentity = record.get('dimIDV');
        		}else if(clFlag=="DimProperty"){
        			var insertIdentity = record.get('dimProV');
        		}else{
        			return;
        		}
				if(proTextZone.getValue()){
					proStr=proTextZone.getValue()+","+insertIdentity;
					proTextZone.setValue(proStr);
				}else{
					proTextZone.setValue(insertIdentity);
				}
			}
		}
	});
	
	
	// 维度属性值串
    var proTextZone = new Ext.form.TextArea({
		id:'proTextZone',
		title:'输出',
		width:260,
		height:85,
		enableKeyEvents:true,
		//value:emptyOutputValue,
		maskRe:/37|38|39|40/   // 键盘键左右上下
	});
	
	var proOutPutPanel = new Ext.Panel({
		title:'维度属性值',
		width:330,
		height:124,
		frame:true,
		monitorResize:true,
		layout:'border',
		items:[{region:'center',
			items:proTextZone
		},{
			region:'east',
			width:50,
			layout:'table',
			layoutConfig:{columns:1},
			items:[{
				html:'',
				height:10
			},{
				width:40,
				frame:'true',
				height:20,
				text:'确定',
				xtype:'button',
				listeners:{
					'click':function(){
						if(currentSelNode==""){
							Ext.MessageBox.alert("消息","请选择统计项目！");
							return;
						}
						if(proTextZone.getValue()==""){
							Ext.MessageBox.alert("消息","过滤值不能为空！");
							return;
						}
						if(filterFuncStr==""){
							Ext.MessageBox.alert("消息","请选择过滤函数！");
							return;
						}
						var filStr=currentSelNode+" "+filterFuncStr+" "+proTextZone.getValue();
						var filStr="["+filStr+"]";
						if((textZone.getValue()==emptyOutputValue)||(textZone.getValue()=="")){
							textZone.setValue(filStr);
						}else{
							if(logicalOperatorStr==""){
								Ext.MessageBox.alert("消息","请选择逻辑运算符！");
								return;
							}
							else{
								if((logicalOperatorStr!="&&")&&(logicalOperatorStr!="||")){
									Ext.MessageBox.alert("消息","逻辑运算符只能是【&&】或【||】！");
									return;
								}
								var filStr=textZone.getValue()+" "+logicalOperatorStr+" "+filStr;
								textZone.setValue(filStr);
							}
						}
						
						// 清空已选项
						proTextZone.setValue("");
						filterFuncGrid.getSelectionModel().clearSelections();
						logicalOperatorGrid.getSelectionModel().clearSelections();
						dimProGrid.getSelectionModel().clearSelections();
						filterFuncStr="",logicalOperatorStr="";
					}
				}
			},{
				html:'',
				height:10
			},{
				width:40,
				frame:'true',
				height:20,
				text:'清空',
				xtype:'button',
				listeners:{
					'click':function(){
						Ext.getCmp('proTextZone').setValue("");
					}
				}
			}]
		}]
		
	});
	
	
	
	////////////*************一下是窗体部分****************///////////
	var inputPanel = new Ext.Panel({
		height:380,
		//frame:true,
		monitorResize:true,
		layout:'table',
		items:[{
			width:230,
			height:380,
			items:dimTreeGrid
		},{
			width:330,
			height:380,
			items:[dimProGrid,proOutPutPanel]
		},{
			width:280,
			items:filterFuncGrid
		},{
			width:275,
			items:logicalOperatorGrid
		}]
	});
	
	var filterRulePanel = new Ext.Panel({
		width:1046,
		height:530,
		monitorResize:true,
		layout:'border',
		items:[{
			region:'center',
			height:380,
			items:inputPanel
		},{
			region:'south',
			height:150,
			items:outputPanel
		}]
	});

	
	var setFilterWin = new Ext.Window({
		id:'filterMainWin',
		title:'过滤规则生成',
		//frame:true,
		width:1060,
		height:560,
		resizable:true,
		modal:true,
		items:filterRulePanel
	});
	
	setFilterWin.on('afterrender',function(){
			updateTree();
	})
	
	function InsertText(value){
		var obj = document.getElementById('textZone'), selection = document.selection;
		if ((emptyOutputValue==obj.value)||(obj.value=="")){
			Ext.MessageBox.alert("消息","过滤表达式为空，请先配置过滤表达式！");
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
		}else if (selection && selection.createRange){	// for IE
			var sel = selection.createRange();
			sel.moveStart('character', -1);
			var lastCh = sel.text;
			sel.moveStart('character', 1),sel.moveEnd('character', 1);
			var nextCh = sel.text;
			sel.moveEnd('character', -1)
			if (('['==value)&&(('['!=lastCh))){
				Ext.MessageBox.alert("消息","当前位置不允许插入字符'"+value+"'!");
				return;
			}else if (('!'==value)&&('['!=nextCh)) {
				Ext.MessageBox.alert("消息","当前位置不允许插入字符'"+value+"'!");
				return;
			}else if ((']'==value)&&((']'!=nextCh))) {
				Ext.MessageBox.alert("消息","当前位置不允许插入字符'"+value+"'!");
				return;
			}
			sel.text = value+sel.text;
			sel.moveStart('character', -value.length);
		}else{
			obj.value += value;
		}
	}
	
	//向树控件添加节点
	function updateTree(rptCodes){
		var url=encodeURI('dhcwl/complexrpt/rptdimservice.csp?action=GetKpiDimAndPro');
		dhcwl.complexrpt.Util.ajaxExc(url,{},
			function(jsonData){
				if(jsonData.success==true && jsonData.tip=="ok"){
					var treeDatas=jsonData.data; 
					var len=treeDatas.length;
					var startNode=tree.getRootNode();
					var childNode;
					for (var i=0;i<=len-1;i++) {
						className=treeDatas[i].className;
						var dragFlag=true;
						if (treeDatas[i].className=="DHCWL.ComplexRpt.StatItem") dragFlag=false;
						childNode = new Ext.tree.TreeNode({
							code:treeDatas[i].code,
							className:treeDatas[i].className,
							parentNO:treeDatas[i].parentNO,
							NO:treeDatas[i].NO,
							iconCls:'task-folder',
							text :treeDatas[i].text,
							draggable : dragFlag,
							expanded: false
						});
						
						// 增加树节点
						var pNode=searchNodeByPNO(startNode,treeDatas[i].parentNO);
						if (pNode.length>0) {
							pNode[0].appendChild(childNode);
						}
					}
				}else{
					}
			setFilterWin.body.unmask();
		},this);
		setFilterWin.body.mask("数据加载中，请稍等");  
	}
	
	function searchNodeByPNO(startNode,PNO) {
	    var r = [];
	    var f = function(){
	    	var falsecnt=0;
	    	var attrib=this.attributes;
	    	if (attrib.NO==PNO) {
				falsecnt=1
	    	}
	        if(falsecnt==1){
	            r.push(this);
	        }
	    };
	    startNode.cascade(f);
	    return r;
	}
	
	this.GetFilterRule = function(){
	}
	
	this.show = function(){
		var filterfuncstore = filterFuncGrid.getStore();
		filterfuncstore.load();
		var logicalOperatorStore = logicalOperatorGrid.getStore();
		logicalOperatorStore.load();
		setFilterWin.show();
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