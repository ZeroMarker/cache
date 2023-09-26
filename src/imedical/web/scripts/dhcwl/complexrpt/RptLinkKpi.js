(function(){
	Ext.ns("dhcwl.complexrpt.RptLinkKpi");
})();

dhcwl.complexrpt.RptLinkKpi=function(rptCode,rptId){
	this.rptCode=rptCode;
	this.rptId=rptId;
	var outthis=this;
	var serviceUrl="dhcwl/complexrpt/rptlinkkpi.csp";
	var parentWin=null;
	
	var toColumnModel = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),
        {header:'类型',dataIndex:'rKpiType',sortable:true, width: 100, sortable: true,menuDisabled : true
        },{header:'维度串',dataIndex:'rKpiCode',sortable:true, width: 180, sortable: true,menuDisabled : true
        },{header:'指标代码',dataIndex:'rKpiName',sortable:true, width: 180, sortable: true,menuDisabled : true
        }]);
    
    var toStore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=getMkpiByRptId&RptId='+outthis.rptId}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'rKpiType'},
        		{name: 'rKpiCode'},
            	{name: 'rKpiName'},
            	{name: 'rKpi'}
       		]
    	})
    });
    
    var toStoreRecorde= Ext.data.Record.create([
        {name: 'rKpiType', type: 'string'},
        {name: 'rKpiCode', type: 'string'},
        {name: 'rKpiName', type: 'string'},
        {name: 'rKpi', type: 'string'}
	]);

    var treeDeep="";
	//// 关联指标树
     //var tree = new Ext.ux.tree.TreeGrid({
	 var tree = new Ext.tree.TreePanel( {
		id:"poolTreePanel",
		enableSort : false,
		autoScroll : true,
		//enableDD : true,
		//enableDrag : true,
		//ddGroup : 'treeGridDD',
		//draggable : true, // 是否允许拖拽
		//loadMask:{msg:"数据加载中，请稍等..."},
		containerScroll : true,
		lines :true,
        columns:[{
            header: '描述',
            width: 210,
            dataIndex: 'text'
        },{
            header: '编码',
            width: 130,
            dataIndex: 'code'
        }],
		loader: new Ext.tree.TreeLoader()
		});

    
		var root = new Ext.tree.TreeNode( {
		code:"root",
		className:"",
	 	parentNO:'',
	 	NO:'root',
	    iconCls:'task-folder',
		text : '关联指标树',
		draggable : false,
	    expanded: true	
		//checked :false
		  });
		tree.setRootNode(root);
		tree.on({
			'dblclick':function(node, e){
			if(!node.hasChildNodes()){
				var rowcolData=getTreeSelRuleValue(node);
				if(rowcolData.length==0){
					return;
                }
				var selStore=toGrid.getStore();
                var recordeData={"rKpiType":rowcolData[1],"rKpiName":rowcolData[0],"rKpiCode":rowcolData[2],"rKpi":rowcolData[3]};
                if (!checkTreekNodeSame(rowcolData,selStore)){
                selStore.add(new toStoreRecorde(recordeData));
                }else{
                	Ext.Msg.show({title:'注意',msg:'同类型指标只能关联一个！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
                	}
                }else{
                	return;
                }
           	}
		});
    

	var fromGrid = new Ext.Panel({
		//region: 'center',
		//margins:'3 3 3 0',
       	title:'关联指标树',
       	height:350,
        width:370,
		layout:'fit',
		items:tree
	});

    var toGrid = new Ext.grid.GridPanel({
    	title:'已关联指标',
        height:350,
        width:370,
        store: toStore,
        cm: toColumnModel,
        sm: new Ext.grid.RowSelectionModel({
        	singleSelect: true
        }),
        listeners:{
        	'rowdblclick' : function(th, rowIndex, e ) {
	        	var selRec=toGrid.getSelectionModel().getSelected();
				toGrid.getStore().remove(selRec);
				toGrid.getView().refresh(); //刷新
        	}
        }
    });
    
   
    //fromStore.load({params:{start:0,limit:21}});	
	//toStore.load({params:{start:0,limit:21}});
     var actform = new Ext.FormPanel({
     	width:70,
     	height:350,
		layout: {
		    type:'vbox',
		    padding:'5',
		    pack:'center',
		    align:'center'
		},
		defaults:{margins:'0 0 30 0'},
		items:[{
		    xtype:'button',
		  	id: 'moveright',
		  	icon   : '../images/uiimages/moveright.png',
		  	width:30,
		  	handler:onBtnClick
		},{
		    xtype:'button',
		    width:30,
		    id: 'moveleft',
		    icon   : '../images/uiimages/moveleft.png',
		  	handler:onBtnClick
		}]

    });
	
    var dimSelPanel =new Ext.Panel({
    	//title:'报表关联指标配置',
    	layout:"table",
        layoutConfig:{columns:3},
        items: [fromGrid,actform,toGrid]

    });
    
    toStore.load({params:{start:0,limit:20}});
    
    
	//	定义报表选取窗口
	var selItemWin = new Ext.Window({
		id:'selItemWin',
		title:'',
        width:830,
		height:420,
		resizable:false,
		//closeAction:'hide',
		closable:true, 
		layout:'border',
		modal:true,
		items:[{
			region:'center',
			items:dimSelPanel
		}],
        buttons: [
        	{
            text: '<span style="line-Height:1">保存</span>',
            icon   : '../images/uiimages/filesave.png',
            handler: OnConfirm
        },{
            //text: '退出',
			text: '<span style="line-Height:1">关闭</span>',
            icon   : '../images/uiimages/cancel.png',
            handler: OnCancel
        }],		
		listeners:{
		}
	});
	
	function OnConfirm(){
		var outStore=toGrid.getStore();
		var outString=GetStoreSpelitStr(outStore,"rKpi");
		url=encodeURI('dhcwl/complexrpt/rptlinkkpi.csp?action=SaveLinkRptKpi');
  		dhcwl.complexrpt.Util.ajaxExc(url,
  			{
				KpiPoolDr:outString,
				RptId:outthis.rptId
		
  			},
			function(jsonData){
				if(jsonData.success==true && jsonData.tip=="ok"){
					toStore.load();
           			toGrid.show();
           			Ext.Msg.alert("提示","修改成功！");
				}else{
					Ext.Msg.alert("提示",jsonData.tip);
				}
			},this);
		//selItemWin.close();
	}
	
	function OnCancel(){
	     selItemWin.close();
	}
	
	selItemWin.on('afterrender',function(){
		updateTree(outthis.rptCode);
	})
	
	function GetStoreSpelitStr(objStore,gCode){
		var codeStr=""
		var len=objStore.data.length; //长度
		for (var i = 0; i < len; i++){
			if (codeStr==""){
				codeStr=objStore.getAt(i).get(gCode);
			}else{
				codeStr=codeStr+","+objStore.getAt(i).get(gCode);
			}
		}
		return codeStr;
	}
	 
	//向树控件添加一个节点
	function updateTree(rptCode){
		var url=encodeURI('dhcwl/complexrpt/rptlinkkpi.csp?action=getRptLinkKpi');
		dhcwl.complexrpt.Util.ajaxExc(url,
			{
				RptCode:rptCode
			},
			function(jsonData){
				if(jsonData.success==true && jsonData.tip=="ok"){
					var treeDatas=jsonData.data; 
					var len=treeDatas.length;
					var startNode=tree.getRootNode();
					var childNode;
					for (var i=0;i<=len-1;i++) {
						className=treeDatas[i].className;
						var checkedFlag=false;
						childNode = new Ext.tree.TreeNode({
							code:treeDatas[i].code,
							className:treeDatas[i].className,
							parentNO:treeDatas[i].parentNO,
							NO:treeDatas[i].NO,
							id:treeDatas[i].id,
							iconCls:'task-folder',
							singleClickExpand : true,
							text :treeDatas[i].text,
							draggable : true,
							expanded: false
							//qtip : "双击或拖动节点，可添加行列条件哦！" //节点上的提示信息
							//icon：节点图标对应的路径,
							//iconCls：应用到节点图标上的样式,
							//checked:checkedFlag
						});
						
						// 增加树节点
						var pNode=searchNodeByPNO(startNode,treeDatas[i].parentNO);
						if (pNode.length>0) {
							pNode[0].appendChild(childNode);
						}
					}
				}else{
					}
			selItemWin.body.unmask();
		},this);
		selItemWin.body.mask("数据加载中，请稍等");  
	}
	
	function getTreeSelRuleValue(node){
		var itemNode="";
		var proNode="";
		var rowcolArray=[];
		if(!node.attributes.className){
			return rowcolArray;
		}
		if (node.attributes.className!='DHCWL.ComplexRpt.StatItem') {
			itemNode=node.parentNode;
			proNode=node;
			rowcolArray.push(proNode.attributes.id);
			descstr=itemNode.attributes.text;
			rowcolArray.push(descstr);
			codestr=proNode.attributes.code;
			rowcolArray.push(codestr);
			rowcolArray.push(proNode.attributes.NO);
		}else{
			return rowcolArray;
		}
		return rowcolArray;
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
	
	function checkTreekNodeSame(nodeDate,objPanelStore){
			var flag=0;
			if (nodeDate.length<3) return flag;
			var len=objPanelStore.data.length; //长度
			for (var i = 0; i < len; i++){
				if (nodeDate[1]==objPanelStore.getAt(i).get('rKpiType')){
					var flag=1;
				}
			}
			return flag;
		}
		
	function onBtnClick(btn){
		partCalExp=btn.getId();
		if(partCalExp=="moveright"){
//			for(var item in tree.getSelectionModel()){
//　				document.write(item+"<br>");
//			}
			var selRec=tree.getSelectionModel().getSelectedNode()
			if (!selRec) {
				return;
			}
			if(!selRec.hasChildNodes()){
				var rowcolData=getTreeSelRuleValue(selRec);
				var selStore=toGrid.getStore();
                var recordeData={"rKpiType":rowcolData[1],"rKpiName":rowcolData[0],"rKpiCode":rowcolData[2],"rKpi":rowcolData[3]};
                if (!checkTreekNodeSame(rowcolData,selStore)){
                	selStore.add(new toStoreRecorde(recordeData));
                	toGrid.getView().refresh(); //刷新
                }else{
                	Ext.Msg.show({title:'注意',msg:'同类型指标只能关联一个！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
                	}
                }else{
                	return;
                }
			
		}else{
			var selRec=toGrid.getSelectionModel().getSelected();
			if (!selRec) {
				return;
			}   	
			if(partCalExp=="moveleft"){
				toGrid.getStore().remove(selRec);
				toGrid.getView().refresh(); //刷新
			}
		}
    }

	this.showWin=function(parent){
		parentWin=parent;
		var winTitle="当前编辑: ' "+RptItemRptDesc+" '报表";
		selItemWin.setTitle(winTitle);
		selItemWin.show();
	}
	
    this.showRptlinkKpi=function(){
		return selItemWin;
	}
	}