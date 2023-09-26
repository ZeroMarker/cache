(function(){
	Ext.ns("dhcwl.mkpi.showkpidata");
})();
dhcwl.mkpi.showkpidata.SetDimRule=function(){

	var preUrl="dhcwl/kpi/";
	var parentWin;
	var inputRule="";
	var storeType="proxy";
	objRoot=new Object();
	objRoot.child=[];
	objRoot.split=",";
	var treeDeep="";

	
    var sm=new Ext.grid.CheckboxSelectionModel({
    	//singleSelect: true,
		listeners :{
			'rowselect': function(sm, row, rec) {
        		var rd=rec;   //sm.getSelected();
        		
				rd.attributes=new Object();
				rd.attributes.code=rd.get('KDTCode'); 
				
				if (seachChildObjByCode(objRoot,rd.get('KDTCode'))==""){
					updateTree(rd.get('KDTCode'));         			
         			//3、更新当前取数规则
					objKpi=new Object();
					objKpi.split=":";
					objKpi.child=[];

					objKpi.data=rd;

        		}

            },
            'rowdeselect':function(sm, row, rec){
            	var kpiCode=rec.get("KDTCode");
            	delChildObjByCode(objRoot,kpiCode);
				//2、删除树节点
				var startNode=tree.getRootNode();
				var kpiNode=startNode.findChild("code",kpiCode);
				kpiNode.remove();
				//3、更新当前取数规则
				refreshCurRulerValue(objRoot);
			}
		}
	});	
	var columnModelKpi = new Ext.grid.ColumnModel([
	    //sm,
        {id:'KDTCode',header:'编码',dataIndex:'KDTCode', width: 90,menuDisabled : true
        },{header:'描述',dataIndex:'KDTDesc', width: 160,menuDisabled : true
        },{header:'创建者',dataIndex:'KDTUser',resizable:'true',width:60,menuDisabled : true
        }
    ]);


    var storeKpi = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:'dhcwl/kpi/kpiservice.csp?action=lookupObj&session=DIM&className=DHCWL.MKPI.MKPIDimType'}), //&date='+dhcwl.mkpi.Util.nowDateTime()}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
            	{name: 'KDTCode'},
            	{name: 'KDTDesc'},
            	{name: 'KDTUser'}
       		]
    	})
    });
    var kpiRecorde= Ext.data.Record.create([
        {name: 'KDTCode', type: 'string'},
        {name: 'KDTDesc', type: 'string'},
        {name: 'KDTUser', type: 'string'}
	]);
	
	var choicedSearcheCond="",searcheValue="";

    var kpiListPanel = new Ext.grid.GridPanel({
    	title:'指标',
        id:"dimListPanel",
        width:380,
        height:330,
        enableColumnResize :true,
        store: storeKpi,
        sm:sm,
        cm: columnModelKpi,
        autoScroll: true,
        autoExpandColumn:'KDTCode',
        bbar:new Ext.PagingToolbar({
            pageSize: 20,
            store: storeKpi,
            displayInfo: true,
            displayMsg: '第{0}条到{1}条记录,共{2}条',
            emptyMsg: "没有记录",
            listeners :{
	        	/*'beforechange':function(pt,page){
	        		storeKpi.proxy.setUrl(encodeURI("dhcwl/kpi/getkpidata.csp?action=singleSearche&mark=OUTPUT&searcheCond="+choicedSearcheCond+"&searcheValue="+searcheValue));//+"&start=0&limit=50"));
	        	},*/
				'change':function(pt,page){
					for(var i=storeKpi.getCount()-1;i>-1;i--){
						kpiCode=storeKpi.getAt(i).get("KDTCode");
						if (seachChildObjByCode(objRoot,kpiCode)!=""){
							sm.selectRow(i,true,false);
						}

					}
				}	        	
            }
        }),
        listeners:{
        	
        },
        tbar: new Ext.Toolbar(
        {
        	layout: 'hbox',
    		xtype : 'compositefield',
        	items : [
        		'查找：',
        		{
	        	id:'setKpiRuleSearchCond',
	        	width: 100,
				xtype:'combo',
	        	mode:'local',
	        	emptyText:'请选择搜索类型',
	        	triggerAction:  'all',
	        	forceSelection: true,
	        	editable: false,
	        	displayField:'value',
	        	valueField:'name',
	        	store:new Ext.data.JsonStore({
	        		fields:['name', 'value'],
	            	data:[
	            		{name : 'Code',   value: '维度代码'},
	                	{name : 'Desc',  value: '维度描述'},
	                	{name : 'User', value: '创建者'}
	             	]}),
	             	listeners:{
	        			'select':function(combo){
	        				choicedSearcheCond=combo.getValue();//ele.getValue();
	        			}
	        		}
	         	}, {
	        		xtype: 'textfield',
	            	flex : 1,
	            	align:'middle',
	            	id:'setKpiRuleSearcheContValue',
	            	enableKeyEvents: true,
	            	allowBlank: true,
	            	listeners :{
	            		'keypress':function(ele,event){
	            			searcheValue=Ext.get("setKpiRuleSearcheContValue").getValue();//ele.getValue();
	            			if(choicedSearcheCond=="Code"){
	            				var paraValues='KDTCode='+searcheValue
	            			}
	            			if(choicedSearcheCond=="Desc"){
	            				var paraValues='KDTDesc='+searcheValue
	            			}
	            			if(choicedSearcheCond=="User"){
	            				var paraValues='KDTUser='+searcheValue
	            			}
	            			if ((event.getKey() == event.ENTER)){
	            				storeKpi.proxy.setUrl(encodeURI("dhcwl/kpi/kpiservice.csp?action=mulSearch&className=DHCWL.MKPI.MKPIDimType&"+paraValues+"&start=0&&limit=50"));
	            				storeKpi.load();
	            				kpiListPanel.show();
	            			}
	            		}
	            	}
	        	}
        	]}
        //]
        )
    });	
	

	    var tree = new Ext.ux.tree.TreeGrid({
		id:"cfgTreePanel",
		enableSort : false,
		autoScroll : true,
		//animate : true,
		containerScroll : true,
		lines :true,
        columns:[{
            header: '描述',
            width: 250,
            dataIndex: 'text'
        },{
            header: '编码',
            width: 150,
            dataIndex: 'code'
        }],		
		loader: new Ext.tree.TreeLoader(),
        tbar: new Ext.Toolbar({
		    layout: 'hbox',
		    //html:'当前规则：',
		    items: ['当前规则：',
		    		{
		    		//columnWidth: 1,
		            flex:1,
		            xtype: 'textfield',
		            name: 'field1',
		            id:'tfCurRuleValue'
		        }]       	
        })		
		});

    
		var root = new Ext.tree.TreeNode( {
		code:"root",
		className:"",
	 	parentNO:'',
	 	NO:'root',
	    iconCls:'task-folder',
		text : '取数规则树',
		draggable : false,	    
	    expanded: true	
		//checked :false
		  });
		tree.setRootNode(root);    
    
		tree.on('checkchange',function(node, checked){
                if(checked){
                    addCurRuleValue(node);
                    refreshCurRulerValue(objRoot);
                }else{
                    delCurRuleValue(node);
                    refreshCurRulerValue(objRoot);
                }
           });		
		

	
        var centerPanel = new Ext.Panel({
            region: 'center',
            margins:'3 3 3 0',
            //layout: 'border',
                        layout:'fit',
            items:tree
        });
        
        // Panel for the west
        var westPanel = new Ext.Panel({
            region: 'west',
            split: true,
            width: 330,
            margins:'3 0 3 3',
            cmargins:'3 3 3 3',
            layout:'fit',
			items:kpiListPanel
        });



	//	定义指标选取窗口
        var mainWin = new Ext.Window({
            title: '维度选择',
            modal:true,
            closable:true,
            width:1000,
            height:500,
            //border:false,
            plain:true,
            layout: 'border',
            items: [westPanel, centerPanel],
            buttonAlign:'center',
	        buttons: [
	        	{
	            //text:'保存',
	            text: '<span style="line-Height:1">保存</span>',
	            icon: '../images/uiimages/filesave.png',
	            handler:OnConfirm
	        },
	        {
	            //text: '关闭',
	            text: '<span style="line-Height:1">关闭</span>',
	            icon: '../images/uiimages/cancel.png',
	            handler: OnCancel
	        }],
	        listeners:{
				'close':function(){
			}
		}
            
        });

	function OnConfirm(){
		 var kpiRule=Ext.getCmp('tfCurRuleValue').getValue();
		 if (parentWin.setKpiRule) {
			 parentWin.setKpiRule("",kpiRule);
		 }				    
	     mainWin.close();

	}       
	
	function SetRuleName(btn, text){
		var ruleName="";
	    if (btn == 'ok'){
	        ruleName=text;
	    }
	    var kpiRule=Ext.getCmp('tfCurRuleValue').getValue();
	    if (parentWin.setKpiRule) {
		    parentWin.setKpiRule(ruleName,kpiRule);
	    }				    
		mainWin.close();
	}
	
	function OnCancel(){
	     mainWin.close();	

	}
	
	mainWin.on('afterrender',function( th ){
		if (dhcwl.mkpi.Util.trimLeft(inputRule)!="") {
			updateTree(inputRule);
		}

		//refreshCurRulerValue(objRoot);
		if (storeType=="proxy") {
			storeKpi.load();
		}

	})	        
    
    //向树控件添加一个节点。节点的编码为kpiCodes
	function updateTree(dimCodes){
		var url=encodeURI('dhcwl/kpi/dimservice.csp?action=GetDimAndPro&treeDeep='+treeDeep);
		dhcwl.mkpi.Util.ajaxExc(url,
			{
				dimCodes:dimCodes
			},
			function(jsonData){

				if(jsonData.success==true && jsonData.tip=="ok"){
	
					var treeDatas=jsonData.data; 
					var len=treeDatas.length;
					var startNode=tree.getRootNode();
					var childNode;
					for (var i=0;i<=len-1;i++) {
						className=treeDatas[i].className;
						//var childNode;	
						var checkedFlag=false;
						if (treeDatas[i].className!="DHCWL.MKPI.MKPIDimType") {
							if(treeDatas[i].checked=="true") checkedFlag=true;
							childNode = new Ext.tree.TreeNode( {
								code:treeDatas[i].code,
								className:treeDatas[i].className,
							 	parentNO:treeDatas[i].parentNO,
							 	NO:treeDatas[i].NO,
							    iconCls:'task-folder',
								text :treeDatas[i].text,
								draggable : false,	 
							    expanded: false,
							    checked:checkedFlag
							  });	
						}else{
							childNode = new Ext.tree.TreeNode( {
							code:treeDatas[i].code,
							className:treeDatas[i].className,
						 	parentNO:treeDatas[i].parentNO,
						 	NO:treeDatas[i].NO,
						    iconCls:'task-folder',
							text :treeDatas[i].text,
							draggable : false,	 
						    expanded: false
						  });								
						}
						var pNode=searchNodeByPNO(startNode,treeDatas[i].parentNO);
						if (pNode.length>0) {
							pNode[0].appendChild(childNode);
							if (checkedFlag) {
								childNode.ui.toggleCheck(true);  
								childNode.attributes.checked = true; 
							}
						}
						
						//维护数据结构

							if(treeDatas[i].className=="DHCWL.MKPI.MKPIDimType") {
								var objNode=new Object();
								objNode.data=childNode;								
								objNode.split=":";
								objNode.child=[];
								objRoot.child.push(objNode);
							}else if(treeDatas[i].className=="DHCWL_MKPI.DHCWLDimProperty" && checkedFlag) {
								var objNode=new Object();
								objNode.data=childNode;											
								addCurRuleValue(childNode)					
							}
						
					}
   
				}else{

					}
			refreshCurRulerValue(objRoot);
			mainWin.body.unmask(); 
		},this);			
		mainWin.body.mask("数据加载中，请稍等");  
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
	
	function addCurRuleValue(node){
		var dimNode="";
		var kpiNode="";
		var proNode="";
		if (node.attributes.className=='DHCWL_MKPI.DHCWLDimProperty') {
			kpiNode=node.parentNode;
			dimNode=node;
		}
		
		//通过KPI树节点找到KPI对象
		var objKpi=seachChildObjByNO(objRoot,kpiNode.attributes.NO);

		if (objKpi!="") {
			//在KPI对象里面找这个维度节点是否存在。
			//objDim=seachChildObjByCode(objKpi,dimNode.attributes.code);
			objDim=seachChildObjByNO(objKpi,dimNode.attributes.NO);
			//如果维度对象不存在，添加维度对象。
			if (objDim==0) {
				objDim=new Object();
				objDim.split="^";
				objDim.data=dimNode;
				objDim.child=[];
				objKpi.child.push(objDim);							
			}
			//当前勾选的是属性树节点，添加属性对象
			if (proNode!=""){
				objPro=new Object();
				objPro.split=".";
				objPro.data=proNode;
				objDim.child.push(objPro);							
			}
		}

	}

	
	function delCurRuleValue(node){
		var dimNode="";
		var kpiNode="";
		var proNode="";
		
		if (node.attributes.className=='DHCWL_MKPI.DHCWLDimProperty') {
			dimNode=node.parentNode;
			proNode=node;
		}		
		//通过dim树节点找到dim对象
		var objDim=seachChildObjByNO(objRoot,dimNode.attributes.NO);

		if (objDim!="") {
			if (proNode!=""){
				delChildObjByNO(objDim,proNode.attributes.NO);
				
			}
		}
	}
	
	
	function getKpiObj(kpiNode){
		var ret=0;
	
		var kpiDatas=objRoot.child;
		for(var kpiLen=kpiDatas.length-1;kpiLen>-1;kpiLen--){
			if(kpiDatas[kpiLen].data.code==kpiNode.attributes.code){
				ret=kpiDatas[kpiLen];
				break;
			}
		}

		return ret ;

	}	
	
	function seachChildObjByCode(objParent,code){
		var  find=0;
		var ret="";
		var datas=objParent.child;
		if (datas) {
			for(var i=0;i<=datas.length-1;i++){
				var objData=datas[i].data;
				if (code==objData.attributes.code) {
					find=1;
					ret=datas[i];
					break;
				}
			}
		}
		return ret;
	}
	
	function seachChildObjByNO(objParent,NO){
		var  find=0;
		var ret="";
		var datas=objParent.child;
		if (datas) {
			for(var i=0;i<=datas.length-1;i++){
				var objData=datas[i].data;
				if (NO==objData.attributes.NO) {
					find=1;
					ret=datas[i];
					break;
				}
			}
		}
		return ret;
	}
	
	function delChildObjByCode(objParent,code){
		var  find=0;
		var ret="";
		var datas=objParent.child;
		var newChild=new Array();
		if (datas) {
			for(var i=0;i<=datas.length-1;i++){
				if (code!=datas[i].data.attributes.code) {
					newChild.push(datas[i]);
				}
			}
		}
		objParent.child=newChild;
	}	

	function delChildObjByNO(objParent,NO){
		var  find=0;
		var ret="";
		var datas=objParent.child;
		var newChild=new Array();
		if (datas) {
			for(var i=0;i<=datas.length-1;i++){
				if (NO!=datas[i].data.attributes.NO) {
					newChild.push(datas[i]);
				}
			}
		}
		objParent.child=newChild;
	}	
	function refreshCurRulerValue(objRoot) {

		var ruleValue="";
		var kpiDatas=objRoot.child;
		var kpiSplit=objRoot.split;
		for(var kpiLen=0;kpiLen<=kpiDatas.length-1;kpiLen++){
			var objKpi=kpiDatas[kpiLen].data;			
			var kpiCode=objKpi.attributes.code;			
			var dimDatas=kpiDatas[kpiLen].child;
			var kpiV="";
			if (dimDatas && dimDatas.length>0) {
				var dimValues="";
				for(var dimLen=0;dimLen<=dimDatas.length-1;dimLen++){
					var dimV="";
					var objDim=dimDatas[dimLen].data;
					var dimCode=objDim.attributes.code;		
					if (objDim.attributes.className=="DHCWL.MKPI.Section") dimCode="$"+dimCode;
					var proDatas=dimDatas[dimLen].child;
					if(proDatas && proDatas.length){
						for(var proLen=0;proLen<=proDatas.length-1;proLen++){
							var objPro=proDatas[proLen].data;
							var proV=objPro.attributes.code;
							var proV=dimCode+proDatas[proLen].split+proV;
							if (dimV!="") dimV=dimV+dimDatas[dimLen].split;
							dimV=dimV+proV;
						}
						
					}else{
						dimV=dimCode;
					}
					if (dimValues!="") dimValues=dimValues+dimDatas[dimLen].split;
					dimValues=dimValues+dimV;
				}
				if (dimValues) kpiV=kpiCode+kpiDatas[kpiLen].split+dimValues;
				else kpiV=kpiCode;				
			}else{
				kpiV=kpiCode;
			}

			if (ruleValue!="") ruleValue=ruleValue+objRoot.split;
			ruleValue=ruleValue+kpiV;
		}
		Ext.getCmp('tfCurRuleValue').setValue(ruleValue);

		
	}
	
	
	this.show=function(){
		mainWin.show(this);
	}
	
	this.hideToolbar=function(){
		
		var bbar=kpiListPanel.getBottomToolbar(); 
		if(bbar) bbar.hide();
		var tbar=kpiListPanel.getTopToolbar(); 		
		if(tbar) tbar.hide();
	}
	
	this.setSelectedKpiArr=function(arr){
		this.inputRuleAry=arr;
	}
	
	this.setSelectedKpiCode=function(inRuleValue){
		inputRule=inRuleValue;
	}
	
	
	this.setParentWin=function(win){
		parentWin=win;
	}
	

	this.reconfigureKpiListPanel=function(aryData){
	    var aryStore = new Ext.data.ArrayStore({
        	fields:[
            	{name: 'kpiCode'},
            	{name: 'kpiName'},
            	{name: 'category'},
            	{name: 'section'}
       		]
	    });
		westPanel.hide();
		mainWin.setSize( 600, 400 ) ;
		treeDeep="kpiDim";


	}
	
}

