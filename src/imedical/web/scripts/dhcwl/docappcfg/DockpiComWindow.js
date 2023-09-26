(function(){
	Ext.ns("dhcwl.docappcfg.DockpiComWindow");
})();
dhcwl.docappcfg.DockpiComWindow=function(sysKpiCode,docKpi,othFilter){
	this.mkpiCode = sysKpiCode;
	this.docKpi = docKpi;
	this.mothFilter = othFilter;
	var insertIdentity="", emptyOutputValue = '过滤表达式......';
	var  currentSelNode="", filterFuncStr="", logicalOperatorStr="",filStr="" ;
	var value = new Array();


	//逻辑运算符选择按钮
	logicalOperatorBar=new Ext.Toolbar([
           '逻辑运算符选择:',{text:'      '},{
               name: 'logicalflag',
               id:'logicalflag',
               xtype: 'radiogroup',
               columns: [60, 60],
               vertical: true,
               items: [
                {boxLabel: '与', name: 'logflag', inputValue: 1,checked: true},   
                {boxLabel: '或', name: 'logflag',inputValue: 2}   
               ]
            }
        ])
	
	var textZone = new Ext.form.TextArea({
		id:'textZone',
		width:550,
		height:150,
		//margins:'3 3 3 0', 
		enableKeyEvents:true,
		value:this.mothFilter,
		maskRe:/37|38|39|40/	//	/37|38|39|40|8|13|32/屏蔽方向左、上、右、下、退格、回车、空格外的其他按键
//		listeners :{
//			'afterrender': function(textZone) {
				//alert(this.mothFilter);
//				textZone.setValue(this.mothFilter);
//				url=encodeURI('dhcwl/docappcfg/dockpirel.csp?action=selectRelFilterRule&MdocKpi='+mdocKpi);
//  				dhcwl.docappcfg.Util.ajaxExc(url,{},
//					function(jsonData){
//						if(jsonData.success==true && jsonData.tip=="ok"){
//							var statDatas=jsonData.data;
//							if(statDatas[0]){
//								textZone.setValue(statDatas[0].filterStr);
//							}else{
//								return;
//							}
//						}else{
//							return;
//						}
//					},this);
//          }
//		}
		
	});
	var outputPanel = new Ext.Panel({
		title:'报表过滤表达式',
		width:713,
		height:243,
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
			height:50,
			layout:'table',
			layoutConfig:{rowumns:1},
			items:[logicalOperatorBar,{
				html:'',
				width:20
			},{
				frame:'true',
				height:20,
				text:'<B>非</B>',
				xtype:'button',
				listeners:{
					'click':function(){
						insertIdentity='!';
						InsertText(insertIdentity);
					}
				}
			},{
				html:'',
				width:25
			},{
				//frame:'true',
				height:20,
				text:'<B>左方括号</B>',
				xtype:'button',
				listeners:{
					'click':function(){
						insertIdentity='[';
						InsertText(insertIdentity);
					}
				}
			},{
				html:'',
				width:25
			},{
				//frame:'true',
				height:20,
				text:'<B>右方括号</B>',
				xtype:'button',
				listeners:{
					'click':function(){
						insertIdentity=']';
						InsertText(insertIdentity);
					}
				}
			}]
		},{
			region:'east',
			width:110,
			layout:'table',
			layoutConfig:{columns:1},
			items:[{
				html:'',
				height:20
			},{
				width:60,
				frame:'true',
				height:30,
				text:'保存数据',
				xtype:'button',
				listeners:{
					'click':function(){
						var fil=textZone.getValue();
						Ext.Ajax.request({
						url:'dhcwl/docappcfg/savekpirel.csp?action=addFilterRule',
						success:function(response){
							var result = Ext.decode(response.responseText);
							Ext.Msg.confirm('消息','保存成功,是否关闭界面',function(btn){
								if (btn=='yes'){
									var win = Ext.getCmp("filterMainWin");
									win.close();
									var tstore = Ext.getCmp("dhcwl.leadermsg.MaintainRightKpi.GridPanel").store;
									tstore.proxy.setUrl('dhcwl/docappcfg/getrelservice.csp?action=singleSearche&searcheCond=Code&searcheValue='
								+ result.dKpiId);
								tstore.reload();
								}
							})
						},
						failure:function(){
							Ext.Msg.alert('消息',"保存失败");
						},
						params:{
							filterRule:fil,
							dKpiId:docKpi
								
								}
						
					});
					
					}
				}
			},{
				html:'',
				height:25
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
	

	var loader = new Ext.tree.TreeLoader({
		dataUrl : 'dhcwl/docappcfg/comdimservice.csp?action=getComKpiDimPro&syskpiCode='+this.mkpiCode
	});
	 var tree = new Ext.ux.tree.TreeGrid( {
		id:"filterTreePanel",
		enableSort : false,
		autoScroll : true,
		containerScroll : true,
		lines :true,
		columns:[{
            header: '        维度与维度属性',
            dataIndex: 'tDesc',
            width: 230
        }],
        loader:loader
		});

	var statCode="", dimProCode="",dimId="",filterValue=""	
		
	var root = new Ext.tree.AsyncTreeNode({
		//id:'0',
	    iconCls:'task-folder',
		text : '维度属性树',
		draggable : false,
	    expanded: true	
	});

	tree.on('click', function(node) {
		var mDimProCode = node.attributes.dimProCode;
		var mstatCode = node.parentNode.attributes.dimCode
		var mDimId = node.parentNode.attributes.dimId
		statCode = mstatCode;
		dimProCode = mDimProCode;
		dimId = mDimId
		currentSelNode="{"+mstatCode+"."+mDimProCode+"}";
		
		dimProStore.proxy = new Ext.data.HttpProxy({
			url:'dhcwl/docappcfg/comdimservice.csp?action=getComDimDimPro&MDimCode='+mstatCode+'&MDimProCode='+mDimProCode+'&MDimId='+mDimId
		});
	           dimProStore.load({params:{start:0,limit:20}});
	           dimProGrid.show();
	});
	tree.setRootNode(root);
	root.expand(false, false);
	
		tree.on("contextmenu", function(node, e) {
		e.preventDefault(); 
		node.select();
		contextmenu.showAt(e.getXY());
	});
    

	var dimTreeGrid = new Ext.Panel({
       	//title:'纬度',
        width:230,
        height:478,
		layout:'fit',
		items:tree
	});
	
	
	var dimProStore = new Ext.data.Store({
		proxy:'', //'dhcwl/docappcfg/comdimservice.csp?action=getComDimDimPro&MDimCode='+mstatCode+'&MDimProCode='+mDimProCode+'&MDimId='+mDimId,
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
			proxy:new Ext.data.HttpProxy({url:'dhcwl/docappcfg/comdimservice.csp?action=getFilterFunCombo'}),
			reader:new Ext.data.ArrayReader({},[{name:'funCode'},{name:'funPro'}])
		})
	});
	
	
	var dimProGrid = new Ext.grid.GridPanel({
		title:'维度属性列表',
		frame:true,
		width:381,
		height:231,
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
					//dimProStore.proxy.setUrl(encodeURI('dhcwl/complexrpt/rptdimservice.csp?action=getRptDimProValue&sCode='+sCode+'&dimProCode='+dimProCode+'&filterValue='+filterStr));
					dimProStore.proxy.setUrl('');
				}
			}
		}),
		cm:new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(),
			{header:'维度值',dataIndex:'dimValue',sortable:true,width:50,menuDisabled : true},
			{header:'维度属性值',dataIndex:'dimProValue',sortable:true,anchor:'100%',resizable:true,menuDisabled : true}
		]),
		tbar: new Ext.Toolbar(
		{
		layout:'hbox',
        items:[filterFunCombo,{
        	text: '|',
        	width:20
        	//text: '<p style="background:yellow"><B><font color="red">Fun</font></B></p>',
            //text: '<B><font color="red">Fun</font></B>',
            //style: 'background-color:Yellow',
            //handler: function(){}
        },'检索:',{
    		//xtype : 'compositefield',
        	//anchor: '-20',
       	 	//msgTarget: 'side',
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
	            			//alert(searcheValue);
	            			//按键的ASCII值等回车键的ASCII值时检索数据
	            			if ((event.getKey() == event.ENTER)){ 	
	            				//alert(statCode);
	            				dimProStore.proxy.setUrl(encodeURI('dhcwl/docappcfg/comdimservice.csp?action=getComDimDimPro&MDimCode='+statCode+'&MDimProCode='+dimProCode+'&MDimId='+dimId+'&filterValue='+searcheValue+'&start=0&limit=20'));
	            				dimProStore.load();
	            				dimProGrid.show();
	            			}
	            		}
	            	}
	        	}
        	]}
        ),
		sm:new Ext.grid.RowSelectionModel({
        	singleSelect: true,
            listeners: {
            	'rowselect': function(sm, row, rec){
					Str = rec.get('code');
				}
			}
		}),
		listeners:{
			'rowdblclick':function(grid,rowIndex,event){
				var sm=grid.getSelectionModel();
				if(!sm) return;
				var record = sm.getSelected();
        		if(!record) return;
        		//if(clFlag=="StatItem"){
        			var insertIdentity = record.get('dimValue');
        		/*}else if(clFlag=="DimProperty"){*/
        			var insertIdentity = record.get('dimProValue');
        		/*}else{
        			return;
        		}*/
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
		width:290,
		height:130,
		enableKeyEvents:true,
		//value:emptyOutputValue,
		maskRe:/37|38|39|40/   // 键盘键左右上下
	});
	
	var proOutPutPanel = new Ext.Panel({
		title:'维度属性值',
		width:330,
		height:230,
		frame:true,
		monitorResize:true,
		layout:'border',
		items:[{region:'center',
			items:proTextZone
		},{
			region:'west',
			width:10,
			layout:'table',
			layoutConfig:{columns:1},
			items:""
		},{
			region:'north',
			height:10,
			layout:'table',
			layoutConfig:{rowumns:1},
			items:""
		},{
			region:'south',
			height:30,
			layout:'table',
			//layoutConfig:{columns:1},
			layoutConfig:{rowumns:1},
			items:[{
				html:'',
				width:190
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
						var logicalInput=Ext.getCmp('logicalflag').getValue().inputValue;
						if (logicalInput==1){
							logicalOperatorStr="&&";
						}else{
							logicalOperatorStr="||";
						}
						if(filterFunCombo.getValue()=="["){
							filterFuncStr="\\\[";
						}else{
							filterFuncStr=filterFunCombo.getValue();
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
						filterFunCombo.setValue("");
						dimProGrid.getSelectionModel().clearSelections();
						filterFuncStr="",logicalOperatorStr="";
					}
				}
			},{
				html:'',
				width:20
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
		height:235,
		//frame:true,
		monitorResize:true,
		layout:'table',
		items:[{
			width:383,
			height:232,
			items:[dimProGrid]
		},{
			width:330,
			items:[proOutPutPanel]
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
			height:235,
			width:715,
			items:inputPanel
		},{
			rowspan: 1,
			colspan: 1,
			height:245,
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
		setFilterWin.show();
	}

		this.setSubWinParam=function(sysKpiCode,docKpi){
		mkpiCode = sysKpiCode;
		mdocKpi = docKpi;
	}
	
	this.showWin = function(){
		setFilterWin.show();
//		paraValues='syskpiId='+mkpiId;
//		var treeUrl = 'dhcwl/docappcfg/comdimservice.csp?action=getComKpiDimPro&'+paraValues;
	}
}