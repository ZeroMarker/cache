(function(){
	Ext.ns("dhcwl.KDQ.CreateRpt");
})();
///描述: 		查询对象
///编写者：		WZ
///编写日期: 		2016-11
dhcwl.KDQ.CreateRpt=function(pObj){
	var serviceUrl="dhcwl/kpidataquery/createrpt.csp";
	var outThis=this;
	var parentObj=pObj;
	var isContinueConfig=false;
	var selectedKpis="";

	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';	
	////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////
	//维度选择
	
	///////////////////////////////////////////////////////////////
	//dimTree
	var businessTool=new Ext.Toolbar({
        	items : [		
			"业务类型：",
			{
				allowBlank:false,
				xtype:'combo',
				id:'ComboBusiness',
				triggerAction:  'all',
				editable: false,
				displayField:   'Descript',
				valueField:     'Code',
				store:new Ext.data.Store({
						proxy: new Ext.data.HttpProxy({url:serviceUrl+"?action=getBusinessType"}),
						reader: new Ext.data.JsonReader({
							totalProperty: 'totalNum',
							root: 'root',
							fields:[
								{name: 'Descript'},
								{name: 'Code'}
							]
						})
					}),	
				mode:           'remote',
				triggerAction:  'all',
                typeAhead: true,
				listeners:{
					'beforeselect':function(combo,record,index) {
						var oldComboBusiness=getBusinessType();
						var businessCode=record.get('Code');
						if (oldComboBusiness!=businessCode) {
							OnResetCondBT();
							rootNode=dimTree.getRootNode();
							rootNode.remove();
							var root = new Ext.tree.AsyncTreeNode({
									text : 'root',
									draggable : false,
									id : 'root',//默认的node值：?node=-100
									type:'dir'
								  });
							dimTree.setRootNode(root);		
							root.loader = new Ext.tree.TreeLoader({
								dataUrl:serviceUrl+'?action=getTreeNodeOfDimRole&businessCode='+businessCode
							});	
							root.toggle();
						}	
						reloadOptionalKPI(businessCode);		
						cleanSelStore();						
					}
				}				
			}]	
		})
	
	
	var dimTree = new Ext.tree.TreePanel({
		border:false,
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
				if (node.id=="root") return;
				if (node.attributes.type=="role" || node.attributes.type=="section") {
					node.loader = new Ext.tree.TreeLoader({
						dataUrl:serviceUrl+'?action=getTreeNodeOfDimPro&RoleCode='+node.attributes.code+"&type="+node.attributes.type
					});	
				}
			}

		}
		});

	var root = new Ext.tree.AsyncTreeNode({
			text : 'root',
			draggable : false,
			id : 'root',//默认的node值：?node=-100
			type:'dir'
		  });


	var treeFilter = new Ext.tree.TreeFilter(dimTree, {  
		clearBlank : true,  
		autoClear : true  
	}); 
		  
		  
		  
		  
	dimTree.setRootNode(root);		

	dimTree.on('checkchange',function(node, checked){
			if(checked){
				var type=node.attributes.type;
				var code=node.attributes.code;
				var descript=node.text;
				var dim="";
				var pro="";
				if (type=='pro') {
					code=node.parentNode.attributes.code+"->"+code;
					if (node.parentNode.attributes.type=="section") code="$"+code;
					descript=node.parentNode.text+"->"+descript;
					pro=node.attributes.code;
					dim=node.parentNode.attributes.code;
					if (node.parentNode.attributes.type=="section") dim="$"+dim;
				}else if(type=='role') {
					dim=node.attributes.code;				
				}
				
				var isStatItem="是";
				if (parentObj.getMyName()=="RptCrossCfg") {
					isStatItem="列显示";
				}
				
				var insData = {
					code: code,
					descript: descript,
					isStatItem:isStatItem,
					isSearchItem:'否',
					type:node.attributes.type ,
					dimCode:dim,
					proCode:pro
				};
				var p = new selectedStore.recordType(insData); // create new record
				var pos=selectedStore.getCount()
				selectedStore.insert(pos, p); 	
				//选择的维度
				SelDimObjs.push(dim,pro);
				//选择的查询项
				//SelSearchItem.push(dim,pro);
				
			}else{
				var code= node.attributes.code;
				var type=node.attributes.type;
				var dim="";
				var pro="";				
				if (type=='pro') {
					code=node.parentNode.attributes.code+"->"+code;
					if (node.parentNode.attributes.type=="section") code="$"+code;
					pro=node.attributes.code;
					dim=node.parentNode.attributes.code;
					if (node.parentNode.attributes.type=="section") dim="$"+dim;					
				}else if(type=='role') {
					dim=node.attributes.code;				
				}

				SelDimObjs.del(dim,pro);
				SelSearchItem.del(dim,pro);
				var inx=selectedStore.findBy(function(rec,id) {
					return rec.get("code")==code && rec.get("type")==type;
				});
				selectedStore.removeAt(inx);			

			}
			reloadOptionalKPI();	//刷新可选指标grid
	   }); 	
	

	///////////////////////////////////////////////////////////////////////////////////////////
	////已选的角色或属性
		
	//明细报表用	
	var selectedCml = new Ext.grid.ColumnModel({
		default:{
			sortable: true,
			menuDisabled : true
		},
		columns:[
			{header:'编码',dataIndex:'code',sortable:true, width: 150},
			{header:'描述',id:'descript',dataIndex:'descript',sortable:true, width: 100},
			{header:'统计项',dataIndex:'isStatItem',sortable:true, width: 80,
				editor: new Ext.form.ComboBox({
								displayField:   'description',
								valueField:     'value',
								store:          new Ext.data.JsonStore({
									fields : ['description', 'value'],
									data   : [
										{description : '是',   value: '是'}
									   ,{description : '否',   value: '否'}
									]
								}),	
								mode:           'local',
								triggerAction:  'all',
								typeAhead: true
							})			
			},
			{header:'查询项',dataIndex:'isSearchItem',sortable:true, width: 80,
				editor: new Ext.form.ComboBox({
								displayField:   'description',
								valueField:     'value',
								store:          new Ext.data.JsonStore({
									fields : ['description', 'value'],
									data   : [
										{description : '是',   value: '是'},
									   {description : '否',   value: '否'}
									]
								}),	
								mode:           'local',
								triggerAction:  'all',
								typeAhead: true
							})			
			
			
			}
		]
	});
	
	//交叉报表用
	var selectedCmlCross = new Ext.grid.ColumnModel({
		default:{
			sortable: true,
			menuDisabled : true
		},
		columns:[
			{header:'编码',dataIndex:'code',sortable:true, width: 150},
			{header:'描述',id:'descript',dataIndex:'descript',sortable:true, width: 100},
			{header:'统计项',dataIndex:'isStatItem',sortable:true, width: 80,
				editor: new Ext.form.ComboBox({
								displayField:   'description',
								valueField:     'value',
								store:          new Ext.data.JsonStore({
									fields : ['description', 'value'],
									data   : [
										{description : '列显示',   value: '列显示'},
										{description : '行显示',   value: '行显示'},
										{description : '否',   value: '否'}
									]
								}),	
								mode:           'local',
								triggerAction:  'all',
								typeAhead: true
							})			
			},
			{header:'查询项',dataIndex:'isSearchItem',sortable:true, width: 80,
				editor: new Ext.form.ComboBox({
								displayField:   'description',
								valueField:     'value',
								store:          new Ext.data.JsonStore({
									fields : ['description', 'value'],
									data   : [
										{description : '是',   value: '是'}
									   ,{description : '否',   value: '否'}
									]
								}),	
								mode:           'local',
								triggerAction:  'all',
								typeAhead: true
							})			
			
			
			}
		]
	});	
	

    var selectedStoreData = [];	
    var selectedStore = new Ext.data.ArrayStore({
		autoDestroy: true,
        fields: [
			{name: 'code'},
			{name: 'descript'},
			{name:'isStatItem'},
			{name:'isSearchItem'},
			{name:'type'},
			{name:'dimCode'},
			{name:'proCode'}
        ]
    });	
	
    var selectedGrid = new Ext.grid.EditorGridPanel({
        border:false,
		title:'已选统计项或查询项-维度',
		//layout:'fit',
        store: selectedStore,
        cm: selectedCml,
		autoExpandColumn: 'descript',
		stripeRows: true,
		view:new Ext.grid.GridView({markDirty:false})
	});
	selectedStore.loadData(selectedStoreData);
	
	//选中或取消统计项，查询项
	selectedGrid.on('afteredit',function(obj){
		if (obj.field=="isStatItem") {
			var rec=obj.record;
			var dim=rec.get("dimCode");
			var pro=rec.get("proCode");
			if (rec.get("isStatItem")=="是" || rec.get("isStatItem")=="列显示"||rec.get("isStatItem")=="行显示") {
				//选择的维度
				SelDimObjs.push(dim,pro);
				//选择的查询项
				//SelSearchItem.push(dim,pro);				
			}else{
				SelDimObjs.del(dim,pro);
			}
		};
		if  (obj.field=="isSearchItem") {
			var rec=obj.record;
			var dim=rec.get("dimCode");
			var pro=rec.get("proCode");
			if (rec.get("isSearchItem")=="是") {
				//选择的维度
				SelSearchItem.push(dim,pro);
				//选择的查询项
				//SelSearchItem.push(dim,pro);				
			}else{
				SelSearchItem.del(dim,pro);
			}
		};
		
	});		
	
	
	///////////////////////////////////////////////////////////////////////////////////////
	/////可选指标
	var optionalKPIStore = new Ext.data.Store({
 		proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=getOptionalKPI&start=0&limit=50'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
				{name:'code'},
				{name:'descript'},
				{name:'roles'}
			]
    	})
    });
	
	var optionalKPICml = new Ext.grid.ColumnModel({
		default:{
			sortable: true,
			menuDisabled : true
		},
		columns:[
			{header:'编码',dataIndex:'code',width: 150},
			{header:'描述',id:'descript',dataIndex:'descript',width: 100},
			{header:'角色',dataIndex:'roles',width: 80}
		]
	});
	
   var optionalKPIGrid = new Ext.grid.GridPanel({
        border:false,
		title:'待选统计项-度量',
		//layout:'fit',
        store: optionalKPIStore,
        cm: optionalKPICml,
		autoExpandColumn: 'descript',
		stripeRows: true,
		view:new Ext.grid.GridView({markDirty:false}),
		bbar: new Ext.PagingToolbar({
			pageSize:50,
			store:optionalKPIStore,
			displayInfo:true,
			displayMsg:'{0}~{1}条,共 {2} 条',
			emptyMsg:'sorry,data not found!'
		})
	});	
	
	function reloadOptionalKPI(inbType) {
		var businessType="";
		if (!!inbType) businessType=inbType;
		else businessType=getBusinessType();
		
		//var dimCodes="";
		//var dimTypes="";
		var dimCodes=SelDimObjs.getDimCode();
		/*
		for(var i=0;i<selectedStore.getCount();i++) {
			var rec=selectedStore.getAt(i);
			if (dimCodes=="") dimCodes=rec.get("code");
			else dimCodes=dimCodes+","+rec.get("code");
			//if (dimTypes=="") dimTypes=rec.get("type");
			//else dimTypes=dimTypes+","+rec.get("type");			
		}
		*/
		
		

		
		
		
		optionalKPIStore.setBaseParam("dimCodes",dimCodes);	
		//optionalKPIStore.setBaseParam("dimTypes",dimTypes);			
		optionalKPIStore.setBaseParam("businessType",businessType);
		optionalKPIStore.setBaseParam("selectedKpis",selectedKpis);
		optionalKPIStore.reload();
	}
	
	function cleanSelStore(){
		selectedStore.removeAll();
		SelDimObjs.delAll();
		SelSearchItem.delAll();
	}
	
	var dimPanel = new Ext.Panel({   
		layout:'border',
		defaults: {
			collapsible: true,
			split: true//,
			//bodyBorder:false
			//border :false
			//bodyStyle: 'padding:5px'
		},
		items: [{
			title: '可选统计项或查询项-维度',
			region: 'west',
			width: 250,
			minSize: 75,
			maxSize: 350,
			layout:'fit',
			items:dimTree,
			
			tbar:new Ext.Toolbar({
					layout: 'hbox',
					items : [	
					'查询值:',
					{
						id:'BtSearchVinCreate',
						xtype:'textfield',						
						width:50
					},{
						xtype:'spacer',
						flex:1
					},				
					
					"-",{
						text: '<span style="line-Height:1">查询</span>',
						icon   : '../images/uiimages/search.png',	
						xtype:'button',
						handler:OnSearchBT
					},	
					"-",
					{
						text: '<span style="line-Height:1">清空</span>',					
						icon   : '../images/uiimages/clearscreen.png',
						xtype:'button',
						handler:OnResetCondBT			
			}]})			
			
			
		},{
			collapsible: false,
			region:'center',
						layout:'vbox',
			layoutConfig: {
				align : 'stretch',
				pack  : 'start',
			},
			items: [
				{
					flex:1,
					layout:'fit',
					items:selectedGrid
				},
				{
					flex:1,
					layout:'fit',
					items:optionalKPIGrid
				}
			]
		}]
	})	
	
	//过滤条件面板
	var filterCfgObj=new dhcwl.KDQ.CreateRptFilterCfg(outThis);
	var filterCfgPanel=filterCfgObj.getFilterPanel();
	
	//可选指标面板
	var optinalKpiCfgObj=new dhcwl.KDQ.CreateRptOptinalKpiCfg(outThis);
	var optinalKpiPanel=optinalKpiCfgObj.getOptionalKPIPanel();
	
	//配置信息汇总
	var createCfgInfoObj=new dhcwl.KDQ.CreateRptCfgInfo(outThis);
	var createCfgInfoPanel=createCfgInfoObj.getCreateInfoPanel();
	
	//继续配置下一组
	var continueCfgObj=new dhcwl.KDQ.CreateRptContinueCfg(outThis);
	var continueCfgPanel=continueCfgObj.getContinueCfgPanel();	
	
	var createPanel = new Ext.Panel({   
		layout:'card',
		activeItem: 0, // index or id
		
		items: [{
			id: 'card-0',
			layout:'fit',
			tbar:businessTool,
			items:dimPanel
		},{
			id: 'card-1',
			layout:'fit',
			items:filterCfgPanel
			
		},{
			id: 'card-2',
			layout:'fit',
			items:optinalKpiPanel
		},{
			//显示配置的汇总信息
			id: 'card-3',
			layout:'fit',
			items:createCfgInfoPanel
		},{
			//显示”继续配置“面板
			id: 'card-4',
			layout:'fit',
			items:continueCfgPanel
		}]
	})
	
	var createWin=new Ext.Window({
        width:800,
		height:500,
		resizable:false,
		closable : false,
		title:'新建报表-选择维度统计项或查询项',
		modal:true,
		layout:'fit',
		items:createPanel,
		buttonAlign :'center',
		buttons :[
			{
				text: '<span style="line-Height:1">取消</span>',
				icon   : '../images/uiimages/cancel.png',
				id:'card-cancel',
				handler: cardNav
			},{
				text: '<span style="line-Height:1">上一步</span>',
				icon   : '../images/uiimages/moveleft.png',
				id:'card-prev',
				disabled: true,
				handler: cardNav
			},{
				text: '<span style="line-Height:1">下一步</span>',
				icon   : '../images/uiimages/moveright.png',
				id:'card-next',
				handler: cardNav
			},{
				text: '<span style="line-Height:1">配置下一组</span>',
				icon   : '../images/uiimages/moveright.png',
				id:'card-continue',
				hidden: true,
				handler: cardNav
			}				
		
		]
	})

	function cardNav(btn){
		var l = createPanel.getLayout();
		var i = l.activeItem.id.split('card-')[1];
		var curInx = parseInt(i, 10)
		var nextInx=0;
		if (btn.id=="card-cancel") {	//点击“取消”，关闭新建窗口
			createWin.close();
			return;
		}else if(btn.id=="card-prev") {	//点击“上一步”
			if (isContinue() && curInx==1) {	
				nextInx=4;						//如果当前配置的不是第一组，并且，当前是过滤面板，显示“继续配置”面板
			}else nextInx=curInx-1;
		}else if(btn.id=="card-next") {	//点击“下一步”
			nextInx=curInx+1;
			if (nextInx==5) {	//“继续配置”面板的下一步是过滤
				nextInx=1;		
			}			
		}else if(btn.id=="card-continue") {	//点击“配置下一组“
			var newRptCfg=new Array();
			getRptColCfg(newRptCfg);//把新建好的配置加入到下面的“列显示”
			//getRptFilter(newRptCfg);//把新建好的配置加入到下面的“过滤”
			if (!!outThis.CallBack) outThis.CallBack(newRptCfg);	
			createWin.setTitle('新建报表-选择维度统计项或查询项');				
			
			isContinueConfig=true;
			nextInx=curInx+1;
			var param=new Object();
			var roles=SelDimObjs.getDimCode();
			//param.businessType=businessType;
			param.roles=roles;
			param.arySelRec=selectedStore.getRange();
			param.selectedKpis=selectedKpis;
			
			continueCfgObj.updateCtnPanelData(param);	

		
		}

		if (nextInx==0) {
			createWin.setTitle('新建报表-选择维度统计项或查询项');	
		}else if (nextInx==1) {
			createWin.setTitle('新建报表-配置过滤');
		}else if (nextInx==2) {
			createWin.setTitle('新建报表-选择度量统计项');
		}else if (nextInx==3) {
			createWin.setTitle('新建报表-配置汇总');
		}else if (nextInx==4) {
			createWin.setTitle('新建报表-选择新的业务类型');	
		}  
		if (nextInx==4 && btn.id=="card-next") {	//完成
			var newRptCfg=new Array();
			getRptColCfg(newRptCfg);//把新建好的配置加入到下面的“列显示”
			//getRptFilter(newRptCfg);//把新建好的配置加入到下面的“过滤”
			if (!!outThis.CallBack) outThis.CallBack(newRptCfg);
			createWin.close();
			return;			
		}

	
		
		//过滤
		if (nextInx==1) {
			if(!getBusinessType()) {
				Ext.Msg.alert("提示","请业务类型！");
				return;				
			};
			var cnt=selectedStore.getCount();
			if (cnt<=0) {
				Ext.Msg.alert("提示","需要选择统计项或查询项！");
				return;
			}
			//filterCfgObj
			var businessType=getBusinessType();
			var roles=SelDimObjs.getDimCode();
			var param=new Object();
			param.businessType=businessType;
			param.roles=roles;
			param.searchItemRoles=SelSearchItem.getDimCode();
			param.searchItemdimProCode=SelSearchItem.getDimProCode();
			param.orderFrom="CreateRpt";
			filterCfgObj.updateCreateData(param);
			
		}	


		//显示可选指标
		if ((nextInx==2) && (btn.id=="card-next")){
			var businessType=getBusinessType();
			var roles=SelDimObjs.getDimCode();
			var filterDims=filterCfgObj.getDim();
			
			var aryRole=roles.split(",");
			var aryFilterDims=filterDims.split(",");

			for(var i=0;i<aryFilterDims.length;i++){
				var sameFlag=0;
				for(var j=0;j<aryRole.length;j++) {
					if (aryFilterDims[i]==aryRole[j]) {
						sameFlag=1;
						break;
					}
				}
				if (sameFlag==0) {
					if(roles=="") roles=aryFilterDims[i];
					else roles=roles+","+aryFilterDims[i];
				}
			}

			
			var param=new Object();
			param.businessType=businessType;
			param.roles=roles;
			param.searchItemRoles=SelSearchItem.getDimCode();
			param.selectedKpis=selectedKpis;
			optinalKpiCfgObj.updateCreateData(param);
			
		}	
		//显示配置汇总信息
		if (nextInx==3){
			createCfgInfoObj.loadMgmtData();
			
		}

		/*
		if(btn.id=="card-continue")	{	//下一步显示
			var param=new Object();
			var roles=SelDimObjs.getDimCode();
			//param.businessType=businessType;
			param.roles=roles;
			param.arySelRec=selectedStore.getRange();
			continueCfgObj.updateCtnPanelData(param);
		}		
		
		*/
		
		l.setActiveItem(nextInx);
		Ext.getCmp('card-prev').setDisabled(nextInx==0 || nextInx==4);
		Ext.getCmp('card-continue').setVisible(nextInx==3);
		if ((nextInx)==3) {
			Ext.getCmp('card-next').setText("完成");
		}else{
			Ext.getCmp('card-next').setText("下一步");
		}
		
	};


	this.show=function() {
		if (parentObj.getMyName()=="RptDetailCfg")  {//被行式报表调用
		
		}else if (parentObj.getMyName()=="RptCrossCfg")  {//被交叉报表调用
			selectedGrid.reconfigure(selectedStore, selectedCmlCross ) ;
			//selectedStore.loadData(selectedStoreData);			
		}
		createWin.show();
	}
	
	
	function DimObjs (){
		this.dimData=new Object();
		this.push=push;
		this.del=del;
		this.delAll=delAll;
		this.getDimCode=getDimCode;
		this.getDimProCode=getDimProCode;
		
		function push(dim,pro) {
			if (!this.dimData[dim]) {
				var aryPro=new Array();
				if (pro!="") aryPro.push(pro);
				this.dimData[dim]=aryPro;
			}else{
				var aryPro=this.dimData[dim];
				for (var i=0;i<aryPro.length;i++) {
					if (aryPro[i]==pro) return;
				}
				if (pro!="") aryPro.push(pro);
			}
		};

		function del(dim,pro) {
			if (!!this.dimData[dim]) {
				if (pro=="") {
					delete this.dimData[dim];	//只有角色，没有属性的情况
					return;
				}else{
					var aryPro=this.dimData[dim];
					for (var i=0;i<aryPro.length;i++) {
						if (aryPro[i]==pro) {
							for(var j=i;j<aryPro.length-1;j++) {
								aryPro[j]=aryPro[j+1];
							}
							aryPro.length=aryPro.length-1;
							if (aryPro.length==0) delete this.dimData[dim];	//只有角色，没有属性的情况
							return;
						}
					}					
					
				}

			}
		};

		function delAll() {
			for(var dim in this.dimData)
			{
				delete this.dimData[dim];
			}
		};
		
		function getDimCode() {
			var ret=""
			 for (dim in this.dimData)
			 {
			   ret=ret+","+dim;
			 }
			 return ret;
		};

		
		function getDimProCode() {
			var ret=""
			 for (dim in this.dimData)
			 {
				var aryPro=this.dimData[dim];
				for (var i=0;i<aryPro.length;i++) {
					var pro=aryPro[i];
					if (pro=="") continue;
					dimpro=dim+"."+pro;
					ret=ret+","+dimpro;
				}					 
			 }			
			return ret;
		}	
	}

	function isContinue() {
		return isContinueConfig;
	}
	function getBusinessType() {
		if (!isContinue()) return Ext.getCmp("ComboBusiness").getValue();
		else return continueCfgObj.getBusinessType();
		//else return Ext.getCmp("ComboBusiness2").getValue();
	};
	
	function getRptColCfg(newRptCfg) {//把新建好的配置加入到下面的“列显示”
		var len = selectedStore.getCount();
		for(var i=0;i<len;i++) {
			var rec=selectedStore.getAt(i);
			if (rec.get("isStatItem")!="是" && rec.get("isStatItem")!="行显示" && rec.get("isStatItem")!="列显示") continue;
			dimColObj=new Object();
			dimColObj.type="dim";
			dimColObj.code=rec.get("code");
			dimColObj.descript=rec.get("descript");
			dimColObj.isStatItem=rec.get("isStatItem");
			newRptCfg.push(dimColObj);
		}
		
		//查询条件项
		for(var i=0;i<len;i++) {
			var rec=selectedStore.getAt(i);
			if (rec.get("isSearchItem")!="是") continue;
			dimColObj=new Object();
			dimColObj.type="searchItem";
			dimColObj.code=rec.get("code");
			dimColObj.descript=rec.get("descript");
			newRptCfg.push(dimColObj);
		}
		
		var filterText=filterCfgObj.getFilterText();
		var fText="";
		
		var selKpi=optinalKpiCfgObj.getOptionalKPI();
		var arySelKpi=selKpi.split(",");
		for(var i=0;i<arySelKpi.length;i++){
			arySelKpi[i].split(String.fromCharCode(2))[0];
			dimColObj=new Object();
			dimColObj.type="measure";
			dimColObj.code=arySelKpi[i].split(String.fromCharCode(2))[0];
			dimColObj.descript=arySelKpi[i].split(String.fromCharCode(2))[1];
			newRptCfg.push(dimColObj);
			if (filterText!="") {
				var tFilter=dimColObj.code+":("+filterText+")";
				if (fText=="") fText=tFilter;
				else fText=fText+","+tFilter;
			}
			
			//选择了那些指标，保存到selectedKpis中，在配置下一组时，在可选指标中剔除这些指标
			if (selectedKpis=="") selectedKpis=dimColObj.code;
			else selectedKpis=selectedKpis+","+dimColObj.code;
		}
		
		//把新建好的配置加入到下面的“过滤”	
		filterObj=new Object();
		filterObj.type="filter";
		filterObj.text=fText;
		newRptCfg.push(filterObj);
		
		
		
	}

	function OnSearchBT() {
		var treeFV=Ext.getCmp("BtSearchVinCreate").getValue();
		if (!!treeFV) {
			var re = new RegExp(Ext.escapeRe(treeFV), 'i');  
			treeFilter.filterBy(function(n) {  
                // 
                return n.getDepth()!=1  || re.test(n.text);  
            });  
		}else{
			treeFilter.clear();
		}
	}
	function OnResetCondBT() {
		Ext.getCmp("BtSearchVinCreate").setValue("");
		treeFilter.clear();
	}	
	
			
	var SelDimObjs=new DimObjs();
	
	var SelSearchItem=new DimObjs();
	
	this.getDimCode=function() {
		return SelDimObjs.getDimCode();
	}
	//过滤条件
	this.getFilterText=function() {
		return filterCfgObj.getFilterText();
	}
	//可选指标
	this.getOptionalKPI=function() {
		return optinalKpiCfgObj.getOptionalKPI();
	}
	
	//报表度量描述
	this.getRptKPIDesc=function() {
		return optinalKpiCfgObj.getOptionalKPIDesc();
		
	}
	//报表维度描述
	this.getRptDimDesc=function() {
		var ret="";
		var cnt=selectedStore.getCount();
		for(var i=0;i<cnt;i++){
			var rec=selectedStore.getAt(i);
			if (rec.get("isStatItem")!='是' && rec.get("isStatItem")!='行显示' && rec.get("isStatItem")!='列显示') continue;
			var aryDesc=rec.get("descript").split("-");
			
			if (ret=="") ret=aryDesc[aryDesc.length-1];
			else ret=ret+","+aryDesc[aryDesc.length-1];
		}
		return ret;
	}
	//报表查询项描述
	this.getRptFilterItemDesc=function() {
		var ret="";
		var cnt=selectedStore.getCount();
		for(var i=0;i<cnt;i++){
			var rec=selectedStore.getAt(i);
			if (rec.get("isSearchItem")!='是') continue;
			var aryDesc=rec.get("descript").split("-");
			if (ret=="") ret=aryDesc[aryDesc.length-1];
			else ret=ret+","+aryDesc[aryDesc.length-1];
		}
		return ret;
	}

	
}

