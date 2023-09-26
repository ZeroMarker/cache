(function(){
	Ext.ns("dhcwl.mkpi.showkpidata");
})();
dhcwl.mkpi.showkpidata.SetKpiRule=function(){
	var parentWin;
	var preUrl="dhcwl/kpi/";
	var columnModelKpi = new Ext.grid.ColumnModel([
	//start
        {header:'编码',dataIndex:'kpiCode', width: 90, sortable: true 
        },{header:'指标名称',dataIndex:'kpiName', width: 160, sortable: true
        },{header:'类型',dataIndex:'category',resizable:'true',width:60
        },{header:'区间',dataIndex:'section',resizable:'true',width:50
        }
    ]);
    //end
    //定义指标的存储模型
    var selectedKpi,selectedKpiDim,selectedDimPro;
    var selectedMap={},selectedKpiDimMap={},selectedDimProMap={};
    var sm=new Ext.grid.RowSelectionModel({singleSelect:true});
    var storeKpi = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:preUrl+'getkpidata.csp?action=singleSearche&mark=TASK'}), //&date='+dhcwl.mkpi.Util.nowDateTime()}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
            	{name: 'kpiCode'},
            	{name: 'kpiName'},
            	{name: 'category'},
            	{name: 'section'}
       		]
    	})
    });
    var kpiRecorde= Ext.data.Record.create([
    //start
        {name: 'kpiCode', type: 'string'},
        {name: 'kpiName', type: 'string'},
        {name: 'category', type: 'string'},
        {name: 'section', type: 'string'}
	]);
	//end
	var choicedSearcheCond="";
    var kpiListPanel = new Ext.grid.GridPanel({
    	title:'指标',
        id:"kpiListPanel",
        width:390,
        height:330,
        resizeAble:true,
        //autoHeight:true,
        enableColumnResize :true,
        store: storeKpi,
        cm: columnModelKpi,
        autoScroll: true,
        bbar:new Ext.PagingToolbar({
            pageSize: 50,
            store: storeKpi,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录"
        }),
        listeners:{
        	"rowdblclick":function(pGrid,pIndex,pEvent){
        		var sm=kpiListPanel.getSelectionModel();
        		if(!sm) return;
        		var record = sm.getSelected();
        		if(!record) return;
                var kpiCode=record.get("kpiCode");
                //var flag=dhcwl.mkpi.Util.add(selectedKpiArr,kpiCode)
                //if(!flag) return;
                if(mapGet(selectedMap,kpiCode)!=null) return;
                var selStore=selectedKpiPanel.getStore();
                var recordeData={"kpiCode":kpiCode,"kpiName":record.get("kpiName"),"category":record.get("category"),"section":record.get("section")};
                selStore.add(new kpiRecorde(recordeData));
                kpiListPanel.getStore().removeAt(pIndex);
                mapAdd(selectedMap,kpiCode,recordeData);
        	}
        }
    });
    storeKpi.load({params:{start:0,limit:50,mark:'TASK'}});
    var kpiRuleCombo= new Ext.form.TextField({
        width:0.1
        //height:0
    });
    var kpiDimColumnModel=new Ext.grid.ColumnModel([
    //start
        {header:'指标维度编码',dataIndex:'MKPIDimCode', width: 90, sortable: true 
        },{header:'指标维度名称',dataIndex:'MKPIDimDes', width: 100, sortable: true
        },{header:'关联维度',dataIndex:'MKPIDimDimDr', hidden:true
        }
    ]);
    //end
    var kpiDimRecorde= Ext.data.Record.create([
    //start
        {name: 'MKPIDimCode', type: 'string'},
        {name: 'MKPIDimDes', type: 'string'},
        {name: 'MKPIDimDimDr', type: 'string'}
	]);
	//end
    var kpiDimListPanel = new Ext.grid.GridPanel({
    	title:'指标维度',
        id:"kpiDimListPanel",
        width:195,
        height:200,
        resizeAble:true,
        cm: kpiDimColumnModel,
        store:  new Ext.data.Store({
	        proxy: new Ext.data.HttpProxy({url:preUrl+"kpidimservice.csp?action=GetKpiDimList&kpiId=0"}), //url:serviceUrl+'?action=GetKpiDimList&kpiId='+(outThis.kpiId||"")}),
	        reader: new Ext.data.JsonReader({
	            totalProperty: 'totalNum',
	            root: 'root',
	        	fields:[
	        		{name: 'MKPIDimCode'},
	            	{name: 'MKPIDimDes'},
	            	{name: 'MKPIDimDimDr'}
	       		]
	    	})
	    }),
        enableColumnResize :true
    });
    var selectedKpiDimListPanel = new Ext.grid.GridPanel({
    	title:'选中的指标维度',
        id:"selectedKpiDimListPanel",
        width:195,
        height:200,
        resizeAble:true,
        cm: kpiDimColumnModel,
        sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
        store: new Ext.data.ArrayStore({}),
        enableColumnResize :true,
        listeners:{
        	"rowdblclick":function(pGrid,pIndex,pEvent){
        		var sm=selectedKpiDimListPanel.getSelectionModel();
        		if(!sm) return;
        		var record = sm.getSelected();
        		if(!record) return;
                var code=record.get("MKPIDimCode");
                if(!mapGet(selectedKpiDimMap,selectedKpi+"_"+code)) return;
                kpiDimListPanel.getStore().add(new kpiDimRecorde(mapGet(selectedKpiDimMap,selectedKpi+"_"+code)));
                selectedKpiDimListPanel.getStore().removeAt(pIndex);
                mapRemove(selectedKpiDimMap,selectedKpi+"_"+code);
                mapRemove(selectedDimProMap,selectedKpi+"_"+code+"_");
                dimProListPanel.getStore().removeAll();
				selectedDimProListPanel.getStore().removeAll();
        	},
        	"rowclick":function(pGrid,pIndex,pEvent){
        		var sm=selectedKpiDimListPanel.getSelectionModel();
        		if(!sm) return;
        		var record = sm.getSelected();
        		if(!record) return;
                var code=record.get("MKPIDimDimDr");
        		var selDimStore=dimProListPanel.getStore();
        		selDimStore.proxy.setUrl(encodeURI(preUrl+'dimservice.csp?action=GetDimProList&start=0&limit=10&dimId='+code));
				selDimStore.load();
				selectedKpiDim=record.get("MKPIDimCode");;
				selectedDimProListPanel.getStore().removeAll();
				var selectedDimPro=mapGet(selectedDimProMap,selectedKpi+"_"+selectedKpiDim+"_");
				for(var tempPro in selectedDimPro){
					selectedDimProListPanel.getStore().add(new dimProRecorde(selectedDimPro[tempPro]));
				}
        	}
        }
    });
    var dimProColumnModel=new Ext.grid.ColumnModel([
    //start
        {header:'指标维度编码',dataIndex:'Code', width: 90, sortable: true 
        },{header:'指标维度名称',dataIndex:'Name', width: 100, sortable: true
        }
    ]);
    //end
    var dimProRecorde= Ext.data.Record.create([
    //start
        {name: 'Code', type: 'string'},
        {name: 'Name', type: 'string'}
	]);
    var dimProListPanel = new Ext.grid.GridPanel({
    	title:'维度属性',
        id:"dimProListPanel",
        width:195,
        height:200,
        resizeAble:true,
        cm: dimProColumnModel,
        store: new Ext.data.Store({
	        proxy: new Ext.data.HttpProxy({url:preUrl+"dimservice.csp?action=GetDimProList&start=0&limit=10&dimId=0"}), //url:serviceUrl+'?action=GetKpiDimList&kpiId='+(outThis.kpiId||"")}),
	        reader: new Ext.data.JsonReader({
	            totalProperty: 'totalNum',
	            root: 'root',
	        	fields:[
	        		{name: 'Code'},
	            	{name: 'Name'}
	       		]
	    	})
	    }),
        enableColumnResize :true
    });
    var selectedDimProListPanel = new Ext.grid.GridPanel({
    	title:'选中的维度属性',
        id:"selectedDimProListPanel",
        width:195,
        height:200,
        resizeAble:true,
        cm: dimProColumnModel,
        store: new Ext.data.ArrayStore({}),
        enableColumnResize :true,
        listeners:{
        	"rowdblclick":function(pGrid,pIndex,pEvent){
        		var sm=selectedDimProListPanel.getSelectionModel();
        		if(!sm) return;
        		var record = sm.getSelected();
        		if(!record) return;
                var code=record.get("Code");
                if(!mapGet(selectedDimProMap,selectedKpi+"_"+selectedKpiDim+"_"+code)) return;
                dimProListPanel.getStore().add(new dimProRecorde(mapGet(selectedDimProMap,selectedKpi+"_"+selectedKpiDim+"_"+code)));
                selectedDimProListPanel.getStore().removeAt(pIndex);
                mapRemove(selectedDimProMap,selectedKpi+"_"+selectedKpiDim+"_"+code);
        	}
        },
         tbar: [{
            text: '形成规则',
            handler : function(){
            	var kpiRule="",i=0,j=0,k=0,dimInd=-1,proInd=-1;
            	var dimProFlag=false;
            	for(var kpi in selectedMap){
            		i++;
            		if(i>1){
            			kpiRule+=","
            		}
            		kpiRule+=kpi;
            		j=0;
            		for(var kpiDim in selectedKpiDimMap){
            			dimProFlag=true;
            			dimInd=kpiDim.indexOf(kpi);
            			if(dimInd==-1) continue;
            			j++;
            			if(j==1){
            				kpiRule+=":";
            				k=0;
            			}else{		//add@2013072317修正以前程序的bug
            				if(kpiRule.charAt(kpiRule.length-1)!="^")
            					kpiRule+="^";
            			}
            			for(var dimPro in selectedDimProMap){
            				proInd=dimPro.indexOf(kpiDim);
            				if(proInd==-1) continue;
            				dimProFlag=false;
            				k++;
            				if(k>1){
	            				if(kpiRule.charAt(kpiRule.length-1)!="^")
            						kpiRule+="^";
	            			}
            				kpiRule+=kpiDim.substr(kpi.length+1,kpiDim.length-1)+"."+dimPro.substr(kpiDim.length+1,dimPro.length-1);
            			}
            			if(dimProFlag){
            				kpiRule+=kpiDim.substr(kpi.length+1,kpiDim.length-1);
            			}
            		}
            	}
            	selectedMap={},selectedKpiDimMap={},selectedDimProMap={};
            	var ruleName="";
            	Ext.MessageBox.prompt("为这次的取数规则起个名字吧，方便再次使用。","名字：",
            	function(btn, text){
				    if (btn == 'ok'){
				        ruleName=text;
				    }
				    //alert(ruleName+"  "+kpiRule);
				    parentWin.setKpiRule(ruleName,kpiRule);
            		mainWin.close();
				},this,true,"");
            	
            }
         },"-"]
    });
    var selectMainPanel = new Ext.form.FormPanel({
        id:'selectMainPanel',
    	height:125,
        bodyStyle: 'padding: 5px',
        defaults: {
            anchor: '0'
        },
        items:[
        	{
                xtype : 'compositefield',
                anchor: '-20',
                fieldLabel: '指标',
                items : [
                	kpiRuleCombo,kpiListPanel,selectedKpiPanel//kpiList,selectedKpi,kpiRuleCombo	
        		]
        	},{
                xtype : 'compositefield',
                anchor: '-20',
                fieldLabel: '维度及其维度属性',
                items : [
                	kpiRuleCombo,//new Ext.form.TextField({width:10}),
                	kpiDimListPanel,selectedKpiDimListPanel//kpiList,selectedKpi,selectedKpiDimList	
        			,dimProListPanel,selectedDimProListPanel
        		]
        	}
        ]
    });
    var mainWin= new Ext.Window({
		layout : 'fit',
		modal : false,
		width : 1000,
		height : 600,
		autoScroll:true,
		plain : true,
		title : '指标数据预览',
		id : 'dhcwl_mkpi_previewKpiData',
		//closeAction:'hide',
		closable : true,
		//closeAction:'hide',
		items : selectMainPanel,//kpiSelectPanel,kpiList
		listeners:{
			'close':function(){
				
			}
		}
	});
	this.show=function(){
		mainWin.show();
	}
	this.setParentWin=function(win){
		parentWin=win;
	}
	this.setSelectedKpiArr=function(arr){
		try{
			var selStore=selectedKpiPanel.getStore();
			for(var i=arr.length-1;i>-1;i--){
                selStore.add(new kpiRecorde(arr[i]));
                mapAdd(selectedMap,arr[i].kpiCode,arr[i]);
			}
		}catch(e){
			return;
		}
	}
	function mapAdd(map,key,value){
		map[key]=value;
	}
	function mapRemove(map,key){
		try{
			if(key.substr(key.length-1)=="_"){
				for(var pro in map){
					if(pro.indexOf(key)>-1){
						delete map[pro];
					}
				}
			}else{
				if(!map[key]) return;
				delete map[key];
			}
		}catch(e){
			return null;
		}
		return null;
	}
	function mapGet(map,key){
		try{
			if(key.substr(key.length-1)=="_"){
				var returnMap={};
				for(var pro in map){
					if(pro.indexOf(key)>-1){
						returnMap[pro]=map[pro];
					}
				}
				return returnMap;
			}else{
				if(!map[key]) return null;
				return map[key];
			}
		}catch(e){
			return null;
		}
		return null;
	}
	
}

