(function(){
	Ext.ns("dhcwl.complexrpt.RptFilterCfg");
})();
dhcwl.complexrpt.RptFilterCfg=function(){
	
	var insertIdentity="", emptyOutputValue = '过滤表达式......';
	var  currentSelNode="", filterFuncStr="", logicalOperatorStr="",filStr="";
	var value = new Array();
	
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
		width:328,
		height:180,
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

	//	******************************************************************outputPanel*************************************************************
	
	var textZone = new Ext.form.TextArea({
		id:'textZone',
		width:550,
		height:100,
		//margins:'3 3 3 0', 
		enableKeyEvents:true,
		value:emptyOutputValue,
		maskRe:/37|38|39|40/	//	/37|38|39|40|8|13|32/屏蔽方向左、上、右、下、退格、回车、空格外的其他按键
		
	});
	
	var outputPanel = new Ext.Panel({
		title:'报表过滤表达式',
		width:713,
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
			width:110,
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
	

	//	***********************************************************************over*********************************************************************
	//// 待选的统计项树
     //var tree = new Ext.ux.tree.TreeGrid({
	 var tree = new Ext.tree.TreePanel( {
		id:"filterTreePanel",
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

    	var sCode="",dimProCode="",filterValue="";
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
					dimProCode="";
					clFlag="StatItem";
				}else if(node.attributes.className=="DHCWL.MKPI.DimProperty"){
					currentSelNode="{"+node.parentNode.attributes.code+"."+node.attributes.code+"}";
					sCode=node.parentNode.attributes.code;
					dimProCode=node.attributes.code;
					clFlag="DimProperty";
				}else{
					currentSelNode="",sCode="",clFlag="",dimProCode="";
					return;
				}
				Ext.getCmp('filterSearcheValue').setValue("");
				proTextZone.setValue("");
				dimProStore.proxy.setUrl(encodeURI('dhcwl/complexrpt/rptdimservice.csp?action=getRptDimProValue&sCode='+sCode+'&dimProCode='+dimProCode+'&filterValue='));
	            dimProStore.load({params:{start:0,limit:20}});
	            dimProGrid.show();
       		}
		});

	var dimTreeGrid = new Ext.Panel({
       	title:'统计项',
        width:230,
        height:478,
		layout:'fit',
		items:tree
	});
	
	
	var dimProStore = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:'dhcwl/complexrpt/rptdimservice.csp?action=getRptDimProValue&sCode=&dimProCode=&filterValue='}),
		reader:new Ext.data.JsonReader({
			totalProperty:'totalNum',
			root:'root',
			fields:[
				{name:'dimValue'},
				{name:'dimProValue'}
			]
		})
	});
	
	
	/// 过滤函数下拉列表
    var filterFunCombo=new Ext.form.ComboBox({
    	id : 'filterFunCombo',
		width : 110,
		editable:false,
		xtype : 'combo',
		mode : 'remote',
		triggerAction : 'all',
		emptyText:'请选择过滤函数',
		name : 'filterFunCombo',
		displayField : 'funCode',
		valueField : 'funCode',
		store : new Ext.data.Store({
			autoLoad : true,
			proxy:new Ext.data.HttpProxy({url:'dhcwl/complexrpt/rptdimservice.csp?action=getFilterFunCombo'}),
			reader:new Ext.data.ArrayReader({},[{name:'funCode'},{name:'funPro'}])
		})
	});
	
	
	var dimProGrid = new Ext.grid.GridPanel({
		title:'维度属性列表',
		frame:true,
		width:381,
		height:324,
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
					filterStr=Ext.get("filterSearcheValue").getValue();
					dimProStore.proxy.setUrl(encodeURI('dhcwl/complexrpt/rptdimservice.csp?action=getRptDimProValue&sCode='+sCode+'&dimProCode='+dimProCode+'&filterValue='+filterStr));
				}
			}
		}),
		cm:new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(),
			{header:'维度值',dataIndex:'dimValue',sortable:true,width:50,menuDisabled : true},
			{header:'维度属性值',dataIndex:'dimProValue',sortable:true,anchor:'100%',resizable:true,menuDisabled : true}
		]),
		tbar: new Ext.Toolbar(
        [filterFunCombo,{
        	text: '|',
        	width:20
        	//text: '<p style="background:yellow"><B><font color="red">Fun</font></B></p>',
            //text: '<B><font color="red">Fun</font></B>',
            //style: 'background-color:Yellow',
            //handler: function(){}
        },{
        	text: '检索:'
        },{
    		xtype : 'compositefield',
        	anchor: '-20',
       	 	msgTarget: 'side',
        	items : [{
	        		xtype: 'textfield',
	            	width:160,
	            	flex : 1,
	            	id:'filterSearcheValue',
	            	//readOnly:true, //不可编辑
	       			//disabled:true, //编辑框变灰暗，不可编辑
	            	enableKeyEvents: true,
	            	allowBlank: true,
	            	//emptyText:'请输入值回车检索！',
	            	listeners :{
	            		'keypress':function(ele,event){
	            			searcheValue=Ext.get("filterSearcheValue").getValue();
	            			//按键的ASCII值等回车键的ASCII值时检索数据
	            			if ((event.getKey() == event.ENTER)){ 			
	            				dimProStore.proxy.setUrl(encodeURI('dhcwl/complexrpt/rptdimservice.csp?action=getRptDimProValue&sCode='+sCode+'&dimProCode='+dimProCode+'&filterValue='+searcheValue+'&start=0&limit=20'));
	            				dimProStore.load();
	            				dimProGrid.show();
	            			}
	            		}
	            	}
	        	}
        	]}
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
        			var insertIdentity = record.get('dimValue');
        		}else if(clFlag=="DimProperty"){
        			var insertIdentity = record.get('dimProValue');
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
		height:105,
		enableKeyEvents:true,
		//value:emptyOutputValue,
		maskRe:/37|38|39|40/   // 键盘键左右上下
	});
	
	var proOutPutPanel = new Ext.Panel({
		title:'维度属性值',
		width:330,
		height:146,
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
						if(filterFunCombo.getValue()==""){
							Ext.MessageBox.alert("消息","请选择过滤函数！");
							return;
						}
						var filterFuncStr=filterFunCombo.getValue();
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
						filterFunCombo.setValue("");
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
		height:330,
		//frame:true,
		monitorResize:true,
		layout:'table',
		items:[{
			width:383,
			height:325,
			items:[dimProGrid]
		},{
			width:330,
			items:[proOutPutPanel,logicalOperatorGrid]
		}]
	});
	
	var filterRulePanel = new Ext.Panel({
		width:946,
		height:480,
		monitorResize:true,
		layout: {
        	type: 'table', 
        	columns: 2,
        	rowumns: 2
    	},		
		items:[{
			colspan: 1,
			rowspan: 2,
			width:230,
			height:478,
			items:dimTreeGrid
		},{
			rowspan: 1,
			colspan: 1,
			height:330,
			width:715,
			items:inputPanel
		},{
			rowspan: 1,
			colspan: 1,
			height:150,
			width:715,
			items:outputPanel
		}]
	});

	
	var setFilterWin = new Ext.Window({
		id:'filterMainWin',
		title:'过滤规则生成',
		//frame:true,
		width:960,
		height:513,
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
	
	
	this.show = function(){
		var logicalOperatorStore = logicalOperatorGrid.getStore();
		logicalOperatorStore.load();
		setFilterWin.show();
	}
}