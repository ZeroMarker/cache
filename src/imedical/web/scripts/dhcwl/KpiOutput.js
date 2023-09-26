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
            width   :80,menuDisabled : true
        },
        columns: [new Ext.grid.RowNumberer(),sm,{
            header: '指标编码',
            dataIndex: 'kpiCode'
        }, {
            header: '指标名称',
            dataIndex: 'kpiName'
        }, {
            header: '区间',
            dataIndex: 'section',
            width:160
        }, {
            header: '维度',
            dataIndex: 'dimType',
            width:160
        }, {
            header: '类别',
            dataIndex: 'category',
            width:160
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
    var choicedSearcheCond="", searcheValue="";
    var kpiPanelList = new Ext.grid.EditorGridPanel({
    	id:'dhcwl.mkpi.KpiOutput.GridPanel',
        //width:500,
        //height:760,
		// region:"west",
		//split:true,

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
					var AllRowCnt=storeKpiOut.getCount();
					var selRowCnt=0;					
					for(var i=storeKpiOut.getCount()-1;i>-1;i--){
						code=storeKpiOut.getAt(i).get("kpiCode");
						if(outThis.check(code)){
							sm.selectRow(i,true,false);
							selRowCnt++
						}
					}
					
					var hd_checker = kpiPanelList.getEl().select('div.x-grid3-hd-checker');
			    	var hd = hd_checker.first();
			    	if(hd!=null ){
			    	    if(AllRowCnt!=selRowCnt && hd.hasClass('x-grid3-hd-checker-on')){
			    	    	hd.removeClass('x-grid3-hd-checker-on');
				    	}else if(AllRowCnt==selRowCnt && !hd.hasClass('x-grid3-hd-checker-on'))
				    	{
				    		hd.addClass('x-grid3-hd-checker-on');
				    	}
			    	}					
				},
	        	'beforechange':function(pt,page){
	        		storeKpiOut.proxy.setUrl(encodeURI("dhcwl/kpi/getkpidata.csp?action=singleSearche&mark=OUTPUT&searcheCond="+choicedSearcheCond+"&searcheValue="+searcheValue));//+"&start=0&limit=50"));
	        	}
				
			}
        }),
        tbar: new Ext.Toolbar(
        /*
        [{
            text: '导出为XML文件',
            handler: function(){
            	//var outputs=outThis.getArrayStr();
            	//alert(outputs);
            	//return;
            	//getSelects();
            	outputToXMLPri();
            	outputList=[];
            	sm.clearSelections();
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
	                	{name : 'FL', value: '指标类型'},
	                	{name : 'ACTIVE', value: '是否激活'}
	             	]}),
	             	listeners:{
	        			'select':function(combo){
	        				choicedSearcheCond=combo.getValue();//ele.getValue();
	        			}
	        		}
	         	}, {
	        		xtype: 'textfield',
	            	width:300,
	            	flex : 1,
	            	id:'searcheContValue',
	            	enableKeyEvents: true,
	            	allowBlank: true,
	            	listeners :{
	            		'keypress':function(ele,event){
	            			searcheValue=Ext.get("searcheContValue").getValue();//ele.getValue();
	            			if(choicedSearcheCond=="ACTIVE"){
	            				searcheValue=((searcheValue=="Y")||(searcheValue=="y")||(searcheValue=="是")?"Y":((searcheValue==null||searcheValue=="")?"":"N"));
	            			}
	            			if ((event.getKey() == event.ENTER)){
	            				storeKpiOut.proxy.setUrl(encodeURI("dhcwl/kpi/getkpidata.csp?action=singleSearche&mark=OUTPUT&searcheCond="+choicedSearcheCond+"&searcheValue="+searcheValue+"&start=0&&limit=50"));
	            				storeKpiOut.load();
	            				kpiPanelList.show();
	            			}
	            		}
	            	}
	        	}
        	]}
        ]
        */

        {
        	layout: 'hbox',
    		//xtype : 'compositefield',
        	items : [
				{
		            //text: '导出为XML文件',
		            text: '<span style="line-Height:1">导出为XML文件</span>',
		            icon: '../images/uiimages/redo.png',
		            handler: function(){
		            	//var outputs=outThis.getArrayStr();
		            	//alert(outputs);
		            	//return;
		            	//getSelects();
		            	outputToXMLPri();
		            	outputList=[];
		            	sm.clearSelections();
		            }
		        },'-', 
        		'查找：',
        		{

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
		                	{name : 'FL', value: '指标类型'},
		                	{name : 'ACTIVE', value: '是否激活'}
		             	]}),
		             	listeners:{
		        			'select':function(combo){
		        				choicedSearcheCond=combo.getValue();//ele.getValue();
		        			}
		        		}
	         	        			
	         	}, {

	        		xtype: 'textfield',
	            	//width:300,
	            	flex : 1,
	            	id:'searcheContValue',
	            	enableKeyEvents: true,
	            	allowBlank: true,
	            	listeners :{
	            		'keypress':function(ele,event){
	            			searcheValue=Ext.get("searcheContValue").getValue();//ele.getValue();
	            			if(choicedSearcheCond=="ACTIVE"){
	            				searcheValue=((searcheValue=="Y")||(searcheValue=="y")||(searcheValue=="是")?"Y":((searcheValue==null||searcheValue=="")?"":"N"));
	            			}
	            			if ((event.getKey() == event.ENTER)){
	            				storeKpiOut.proxy.setUrl(encodeURI("dhcwl/kpi/getkpidata.csp?action=singleSearche&mark=OUTPUT&searcheCond="+choicedSearcheCond+"&searcheValue="+searcheValue+"&start=0&&limit=50"));
	            				storeKpiOut.load();
	            				kpiPanelList.show();
	            			}
	            		}
	            	}
	         	}
        	]}       
        
        
        )
        
        
        
        
    });
    //storeKpiOut.load({params:{start:0,limit:50,mark:'OUTPUT'}});--modify by wz 2015-1016
    kpiPanelList.on('afterrender',function( th ){
 		storeKpiOut.load({params:{start:0,limit:50,mark:'OUTPUT'}});
	});
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
    	var outVersion="";
    	dhcwl.mkpi.Util.ajaxExc("dhcwl/kpi/mkpiinfo.csp",
        		{'action':'KPIVERSION'
        		},
        		function(responseText){
        			if(responseText['version'])
        				outVersion=responseText['version'];
        		}
        		,outThis
        	);
		var kpis=outThis.getArrayStr();  //outputList.join(",");
		dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/kpiioservice.csp',
				{action:'getFileContentExcDim',kpiIds:kpis,flag:1},
			function(responseText){
			if(responseText){
				dhcwl.mkpi.Util.writeFile(dhcwl.mkpi.Util.nowDateTime()+"version"+outVersion+'outputKpis.kpi',dhcwl.mkpi.Util.trimLeft(responseText));
			}else{
				Ext.Msg.show({title : '错误',msg : "导出失败！\n" +responseText,buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
			}
			}
			,outThis,true,null);
    }
    function outputToXMLWithDim(){
    	if(outputList.length==0){
			alert("导出列表为空，请先选择要导出的指标！");
			return;
		}
    	var outVersion="";
    	dhcwl.mkpi.Util.ajaxExc("dhcwl/kpi/mkpiinfo.csp",
        		{'action':'KPIVERSION'
        		},
        		function(responseText){
        			if(responseText['version'])
        				outVersion=responseText['version'];
        		}
        		,outThis
        	);
		var kpis=outThis.getArrayStr();  //outputList.join(",");
		//alert(kpis);
		//Ext.Msg.confirm('信息', '是否要导出基础维度、维度属性信息？', function(btn){
			//if (btn == 'yes') {
				dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/kpiioservice.csp',
					{action:'getFileContent',kpiIds:kpis},
				function(responseText){
					//alert("responseText="+responseText);
			
					if(responseText){
						dhcwl.mkpi.Util.writeFile(dhcwl.mkpi.Util.nowDateTime()+"version"+outVersion+'outputKpis.kpi',dhcwl.mkpi.Util.trimLeft(responseText));
					}else{
						Ext.Msg.show({title : '错误',msg : "导出失败！\n" +responseText,buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
					}
			
				}
				,outThis,true,null);
			/*}else{
				dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/kpiioservice.csp',
						{action:'getFileContentExcDim',kpiIds:kpis,flag:1},
					function(responseText){
					if(responseText){
						dhcwl.mkpi.Util.writeFile(dhcwl.mkpi.Util.nowDateTime()+"version"+outVersion+'outputKpis.kpi',dhcwl.mkpi.Util.trimLeft(responseText));
					}else{
						Ext.Msg.show({title : '错误',msg : "导出失败！\n" +responseText,buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
					}
					}
					,outThis,true,null);
			}*/
		//})
    }
    this.ouputKpis=function(){
    	outputToXMLPri();
    	outputList=[];
    }
    this.ouputKpisWithDim=function(){
    	outputToXMLWithDim();
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
		
		var len=outputList.length;
		for(var i=0;i<len;i++){
			if(outputList[i]==kpiCode){
				for(var j=i;j<len;j++){
					outputList[j]=outputList[j+1];
				}
				outputList.length=len-1;
				break;
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
	
	//++add by wz.2014-3-28 .清除选择
	storeKpiOut.on('load',function( th,records,options ){

		
    	var records=sm.getSelections();
    	if (records.length==0) return;
		
		for(var i=0;i<=records.length-1;i++) {
			var kpi=records[i].get("kpiCode");
			if (!outThis.check(kpi)) {
				sm.deselectRow(i) ;
			}
		}
		
	})	
	
	
}