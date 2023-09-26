(function(){
	Ext.ns("dhcwl.mkpi.KpiOutput");
})();
dhcwl.mkpi.KpiOutput=function(){
	var outputList=[];
	var outThis=this;
	var choicedSearcheCond="",kpiSectionName;
	var sm=new Ext.grid.CheckboxSelectionModel({
		listeners :{
			'rowdeselect':function(csm, rowIndex, recorde){
				var kpiCode=recorde.get('kpiCode');
				outThis.remove(kpiCode);
			}
			,'rowselect':function(csm, rowIndex, recorde){
				var kpiCode=recorde.get('kpiCode');
				outThis.add(kpiCode);
			}
		}
	});
	var columnModelKpi=new Ext.grid.ColumnModel({
		defaults: {
            sortable: true,
            width   :80
        },
        columns: [new Ext.grid.RowNumberer(),sm,{
            header: '指标编码',
            dataIndex: 'kpiCode',
            editor:new Ext.grid.GridEditor(new Ext.form.TextField({disabled:true}))
        }, {
            header: '指标名称',
            dataIndex: 'kpiName',
            editor:new Ext.grid.GridEditor(new Ext.form.TextField({disabled:true}))
        }, {
            header: '区间',
            dataIndex: 'section',
            width:160,
            editor:new Ext.grid.GridEditor(new Ext.form.TextField({disabled:true}))
        }, {
            header: '维度',
            dataIndex: 'dimType',
            width:160,
            editor:new Ext.grid.GridEditor(new Ext.form.TextField({disabled:true}))
        }, {
            header: '类别',
            dataIndex: 'category',
            width:160,
            editor:new Ext.grid.GridEditor(new Ext.form.TextField({disabled:true}))
        }]
	});
	var storeKpiOut = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:'dhcwl/kpi/getkpidata.csp?action=singleSearche&mark=OUTPUT'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'choiced'},
            	{name: 'kpiCode'},
            	{name: 'kpiName'},
            	{name: 'section'},
            	{name: 'dimType'},
            	{name: 'category'}
       		]
    	})
    });
    var kpiPanelList = new Ext.grid.EditorGridPanel({
    	id:'dhcwl.mkpi.KpiOutput.GridPanel',
        width:500,
        height:760,
        frame: true,
        enableColumnResize :true,
        store: storeKpiOut,
        cm: columnModelKpi,
        sm:sm,
        bbar:new Ext.PagingToolbar({
            pageSize: 50,
            store: storeKpiOut,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
            listeners :{
				'change':function(pt,page){
					var code="";
					for(var i=storeKpiOut.getCount()-1;i>-1;i--){
						code=storeKpiOut.getAt(i).get("kpiCode");
						if(outThis.check(code)){
							sm.selectRow(i,true,false);
						}
					}
				}
			}
        }),
        tbar: new Ext.Toolbar(
        [{
            text: '导出为XML文件',
            handler: function(){
            	//var outputs=outThis.getArrayStr();
            	//alert(outputs);
            	//return;
            	//getSelects();
            	outputToXMLPri();
            	outputList=[];
            }
        },'-', '按条件快速搜索：',{
    		xtype : 'compositefield',
        	anchor: '-20',
       	 	msgTarget: 'side',
        	items : [{
	        	id:'searchCondIO',
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
	            		{name : 'Code',   value: '指标代码'},
	                	{name : 'Name',  value: '指标名称'},
	                	{name : 'Sec', value: '指标区间'},
	                	{name : 'Dim',  value: '指标维度'},
	                	{name : 'FL', value: '指标类型'}
	             	]}),
	             	listeners:{
	        			'select':function(combo){
	        				//alert("combo="+combo.getValue()+"  "+combo.getRawValue())
	        				choicedSearcheCond=combo.getValue();//ele.getValue();
	        			}
	        		}
	         	}, {
	        		xtype: 'textfield',
	            	width:300,
	            	flex : 1,
	            	id:'searcheContValue',
	            	enableKeyEvents: true,
	            	//name : 'searcheContValue',
	            	allowBlank: true,
	            	listeners :{
	            		'keypress':function(ele,event){
	            			var searcheValue=Ext.get("searcheContValue").getValue();//ele.getValue();
	            			if ((event.getKey() == event.ENTER)){
	            				//alert("searcheCond="+choicedSearcheCond+"&searcheValue="+searcheValue);
	            				storeKpiOut.proxy.setUrl(encodeURI("dhcwl/kpi/getkpidata.csp?action=singleSearche&mark=OUTPUT&searcheCond="+choicedSearcheCond+"&searcheValue="+searcheValue+"&start=0&&limit=50"));
	            				storeKpiOut.load();
	            				kpiPanelList.show();
	            			}
	            		}
	            	}
	        	}
        	]}
        ])
    });
    storeKpiOut.load({params:{start:0,limit:50,mark:'OUTPUT'}});
    function getSelects(){
    	var rds=sm.getSelections();
    	for(var i=rds.length-1;i>-1;i--){
    		outputList.push(rds[i].get("kpiCode"));
    	}
    	//alert(outputList.join(","));
    }
    function outputToXMLPri(){
    	if(outputList.length==0){
			alert("导出列表为空，请先选择要导出的指标！");
			return;
		}
		var kpis=outThis.getArrayStr();  //outputList.join(",");
		//alert(kpis);
		dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/kpiioservice.csp',
		{action:'getFileContent',kpiIds:kpis},
		function(responseText){
			//alert("responseText="+responseText);
			
			if(responseText){
				dhcwl.mkpi.Util.writeFile(dhcwl.mkpi.Util.nowDateTime()+'outputKpis.xml',dhcwl.mkpi.Util.trimLeft(responseText));
			}else{
				Ext.Msg.show({title : '错误',msg : "导出失败！\n" +responseText,buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
			}
			
		}
		,outThis,true,null);
    }
    this.ouputKpis=function(){
    	outputToXMLPri();
    	outputList=[];
    }
	this.refreshChoice=function(){
		var choiced,kpiCode,rd;
		outputList=[];
		for(var i=storeKpiOut.getTotalCount()-1;i>-1;i--){
			rd=storeKpiOut.getAt(i);
			choiced=rd.get('choiced');
			if(choiced){
				kpiCode=rd.get('kpiCode');
				outputList.push(kpiCode);
			}
		}
		return outputList;
	}
	this.showList=function(){
		if(outputList.length>0){
			Ext.Msg.show({
				title : '提示！',
				msg :outThis.getArrayStr(","),
				icon : Ext.MessageBox.INFO,
				buttons : Ext.Msg.OK
			});
		}else{
			Ext.Msg.show({
				title : '提示！',
				msg : '导出列表为空',
				icon : Ext.MessageBox.INFO,
				buttons : Ext.Msg.OK
			});
		}
	}
	this.clearList=function(){
		outputList=[];
	}
	this.add=function(kpiCode){
		if(!kpiCode||kpiCode=="") return;
		for(var i=outputList.length-1;i>-1;i--){
			if(outputList[i]==kpiCode)
				return;
		}
		outputList.push(kpiCode);
	}
	this.remove=function(kpiCode){
		if(!kpiCode||kpiCode=="") return;
		for(var i=outputList.length-1;i>-1;i--){
			if(outputList[i]==kpiCode){
				delete outputList[i]
				return;
			}
				
		}
		
	}
	this.check=function(kpiCode){
		if(!kpiCode||kpiCode=="") return false;
		for(var i=outputList.length-1;i>-1;i--){
			if(outputList[i]==kpiCode){
				return true;
			}
				
		}
		return false;
	}
	this.getArrayStr=function(deli){
		var result="";
		deli=deli||',';
		for(var i=outputList.length-1;i>-1;i--){
			if((!outputList[i])||(outputList[i]=="")){
				continue;
			}
			if(result=="") result=outputList[i]
			else  result=result+deli+outputList[i]	
		}
		return result;
	}
	this.outputToXML=function(){
		outputToXMLPri();
	}
	this.getOutputPanel=function(){
		return kpiPanelList;
	}
}