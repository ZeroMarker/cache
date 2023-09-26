(function(){
	Ext.ns("dhcwl.mkpi.kpiCalRelatCfg");
})();
///描述: 		计算类统计项配置页面
///编写者：		WZ
///编写日期: 		2014-11
dhcwl.mkpi.kpiCalRelatCfg=function(){
	var outThis=this;
	var aryData=new Array();;
	var curKpiID="";
	var choicedSearcheCond="";
	var serviceUrl="dhcwl/kpi/kpicalrelatcfg.csp";


	var columnModel = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),
        {header:'ID',dataIndex:'ID',sortable:true, width: 50, sortable: true,menuDisabled : true
        },{header:'编码',dataIndex:'kpiCode',sortable:true, width: 120, sortable: true,menuDisabled : true
        },{header:'描述',dataIndex:'kpiDesc', width: 240, sortable: true,menuDisabled : true
		},{header:'取值类型',dataIndex:'getValueType', width: 120, sortable: true,menuDisabled : true        
        },{header:'指标维度',dataIndex:'kpiDim', width: 120, sortable: true,menuDisabled : true
		},{header:'基础维度',dataIndex:'dimType', width: 120, sortable: true,menuDisabled : true
        },{header:'指标区间',dataIndex:'kpiSec', width: 120, sortable: true,menuDisabled : true
		},{header:'指标类型',dataIndex:'kpiCate', width: 120, sortable: true,menuDisabled : true
		}
    ]);
    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=searchKPI&start=0&limit=20&onePage=1&curKpiID='+curKpiID}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'ID'},
            	{name: 'kpiCode'},
            	{name: 'kpiDesc'},
            	{name: 'getValueType'},
            	{name: 'kpiDim'},
             	{name: 'dimType'},
             	{name: 'kpiSec'},
             	{name: 'kpiCate'}            	
       		]
    	})
    });
    var Record = Ext.data.Record.create([
    	{name: 'ID',type:'integer'},
    	{name: 'kpiCode', type: 'string'},
        {name: 'kpiDesc', type: 'string'},
        {name: 'getValueType', type: 'string'},
        {name: 'kpiDim', type: 'string'},
        {name: 'dimType', type: 'string'},
        {name: 'kpiSec', type: 'string'},
        {name: 'kpiCate', type: 'string'}
    ]);
    
    
    var sectionCombo=new Ext.form.ComboBox({
    	//id:'setKpiRuleSearchCond',
    	width: 120,
		//xtype:'combo',
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
        		{name : 'kpiCode',   value: '指标代码'},
            	{name : 'kpiDesc',  value: '指标描述'},
            	{name : 'kpiSec', value: '指标区间'},
            	{name : 'kpiFL', value: '指标类型'}
         	]}),
         	listeners:{
    			'select':function(combo){
    				//alert("combo="+combo.getValue()+"  "+combo.getRawValue())
    				choicedSearcheCond=combo.getValue();//ele.getValue();
    			}
    		}
	});    
    
    
    
    var kpiCalCfgGrid = new Ext.grid.GridPanel({
        height:330,
        store: store,
        cm: columnModel,
        sm: new Ext.grid.RowSelectionModel({
        	singleSelect: true,
            listeners: {
            }
        }),
        listeners:{
        	/*'contextmenu':function(event){
        		event.preventDefault();
        		quickMenu.showAt(event.getXY());
        	},*/
        	'rowdblclick': function(th, rowIndex, e) {
        		var rec=th.getStore().getAt(rowIndex)
        		var kpiCode=rec.get("kpiCode");
            	//var calExp=Ext.get('CalExp').getValue();
        		var calExp=kpiCalCfgForm.getForm().findField("CalExp").getValue();//modify by wk.2015-09-24
            	calExp=calExp+'<'+kpiCode+'>';
				var form=kpiCalCfgForm.getForm();
				form.setValues({CalExp:calExp});    
				
				var kpiDesc=rec.get("kpiDesc");
				var kpiCate=rec.get("kpiCate");
				var kpiSec=rec.get("kpiSec");
				arr = new Array();
				arr.push(kpiCode,kpiDesc,kpiCate,kpiSec);
				if (aryData.isExist(kpiCode)<0) aryData.push(arr);

         	}        	
        },
        bbar:new Ext.PagingToolbar({
            pageSize: 20,
            store: store,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
			listeners :{
				'beforechange':function(pt,page){
					store.proxy.setUrl(encodeURI(serviceUrl+'?action=searchKPI&curKpiID='+curKpiID));
        			searcheValue=Ext.get("setCalKpiSearcheContValue").getValue();//ele.getValue();
					searcheValue=dhcwl.mkpi.Util.trimLeft(searcheValue);
        			if (searcheValue!=""){
        				//alert("searcheCond="+choicedSearcheCond+"&searcheValue="+searcheValue);
        				store.proxy.setUrl(encodeURI(serviceUrl+"?action=searchKPI&searcheCond="+choicedSearcheCond+"&searcheValue="+searcheValue+"&start=0&&limit=20&curKpiID="+curKpiID));
        			}					
				}
			}
        })
        /*,
        tbar: new Ext.Toolbar(
        ['按条件快速搜索：',{
    		//xtype : 'compositefield',
        	//anchor: '-20',
       	 	//msgTarget: 'side',
        	items : [{
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
	            		{name : 'kpiCode',   value: '指标代码'},
	                	{name : 'kpiDesc',  value: '指标描述'},
	                	{name : 'kpiSec', value: '指标区间'},
	                	{name : 'kpiFL', value: '指标类型'}
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
	            	id:'setCalKpiSearcheContValue',
	            	enableKeyEvents: true,
	            	//name : 'searcheContValue',
	            	allowBlank: true,
	            	listeners :{
	            		'keypress':function(ele,event){
	            			searcheValue=Ext.get("setCalKpiSearcheContValue").getValue();//ele.getValue();
							searcheValue=dhcwl.mkpi.Util.trimLeft(searcheValue);
	            			if ((event.getKey() == event.ENTER)){
	            				//alert("searcheCond="+choicedSearcheCond+"&searcheValue="+searcheValue);
	            				store.proxy.setUrl(encodeURI(serviceUrl+"?action=searchKPI&searcheCond="+choicedSearcheCond+"&searcheValue="+searcheValue+"&start=0&&limit=20&curKpiID="+curKpiID));
	            				store.load();
	            				kpiCalCfgGrid.show();
	            			}
	            		}
	            	}
	        	}
        	]}
        ])
        */
        ,tbar: new Ext.Toolbar({
        	items:[
        		'按条件快速搜索：',
        		sectionCombo, 
        		{
	        		xtype: 'textfield',
	            	width:300,
	            	//flex : 1,
	            	id:'setCalKpiSearcheContValue',
	            	enableKeyEvents: true,
	            	//name : 'searcheContValue',
	            	allowBlank: true,
	            	listeners :{
	            		'keypress':function(ele,event){
	            		    searcheValue=Ext.get("setCalKpiSearcheContValue").getValue();//ele.getValue();
	            			searcheValue=dhcwl.mkpi.Util.trimLeft(searcheValue);
	            			if ((event.getKey() == event.ENTER)){
	            				//alert("searcheCond="+choicedSearcheCond+"&searcheValue="+searcheValue);
	            				store.proxy.setUrl(encodeURI(serviceUrl+"?action=searchKPI&searcheCond="+choicedSearcheCond+"&searcheValue="+searcheValue+"&start=0&&limit=20&curKpiID="+curKpiID));
	            				store.load();
	            				kpiCalCfgGrid.show();
	            			}
	            		}
	            	}
	        	}
        	
        ]        
        })
    });
    
 	
    var kpiCalCfgForm = new Ext.FormPanel({
        
        labelAlign: 'left',
        bodyStyle:'padding:5px',
        style: {
             "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },        
        
        frame: true,
        //autoHeight: true,
        //height:70,
        height:125,
        bodyStyle: 'padding: 5px',
        defaults: {
            anchor: '0'
        },
        
        items:[{
        	fieldLabel:'运算关系',
            xtype:'textfield',
            name: 'CalExp',
            anchor    : '-10'        
        },/*
        {
        	fieldLabel:'关系描述',
            xtype:'textfield',
            name: 'CalExpDesc',
            anchor    : '-10'        
        },*/
        {
         	msgTarget : 'side',
        	xtype: 'compositefield',
        	fieldLabel:'汇总维度',
        	anchor    : '-10',
        	defaults: {
                    flex: 1
                },
        	
        	items:[{
				xtype:'textfield',
	            name: 'sumDim'
        	},{
	            xtype:'button',
	            icon: '../images/uiimages/config.png',
	            //text:'配置',
	            text: '<span style="line-Height:1">配置</span>',
	            name: 'setSumDim',
	            handler:onSetSumDim ,
	            width:70
        	}]        	
        	
 
        },{
        	fieldLabel:'提示',
			xtype:'label',
			text:'参与运算的指标的汇总维度必须与计算指标的维度的顺序及基础维度一一对应！',

            anchor    : '-10'               
        }]
    });
    store.load({params:{start:0,limit:20}});	
    
    
    var itemCalBtns = new Ext.FormPanel({
        frame: true,
        height: 385,
        labelAlign: 'left',
        title: '运算符',
        bodyStyle:'padding:15px',
        
        style: {
        	//"margin-left": "10px", // when you add custom margin in IE 6...
            "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },
        layout: 'table',
        defaults: {        
        	width:40,
            height:40

        },
        layoutConfig: {columns:2},
        items:[
		{
            xtype:'button',
            text:'(',
            name: 'btn1',
            handler:onBtnClick
        },
		{
            xtype:'button',
            text:')',
            name: 'btn2',
            handler:onBtnClick
        },		{
            xtype:'button',
            text:'+',
            name: 'btn3',
            handler:onBtnClick
        },		{
            xtype:'button',
            text:'-',
            name: 'btn4',
            handler:onBtnClick
        },		{
            xtype:'button',
            text:'*',
            name: 'btn5',
            handler:onBtnClick
        },		{
            xtype:'button',
            text:'/',
            name: 'btn6',
            handler:onBtnClick
        },		{
            xtype:'button',
            text:'←',
            name: 'btn7',
            handler:function(){
            	//var calExp=Ext.get('CalExp').getValue();
            	var calExp=kpiCalCfgForm.getForm().findField("CalExp").getValue();
            	var length=calExp.length;
            	if (length<=0) return;
            	calExp=calExp.substr(0,length-1);
				var form=kpiCalCfgForm.getForm();
				form.setValues({CalExp:calExp});            	
            }
        },		{
            xtype:'button',
            text:'C',
            name: 'btn8',
            handler:function(){
				var form=kpiCalCfgForm.getForm();
				form.setValues({CalExp:''});
            }
        }]
    });    
    
    
    
    
 	var optPanel = new Ext.Panel({
 			region:'center',
            layout:'border',
            width:700,
            collapsible: false,
            items:[{
	            	region:'west',
	            	width: 340,
	            	items:kpiCalCfgGrid
            	},
            	{
	            	region:'center',
	            	width: 150,
	            	items:itemCalBtns            		
            	}
            ]
        });
	
	//	定义指标选取窗口
	var calWin = new Ext.Window({
		id:'calWin',
		title:'计算指标配置',
		closable:true,
        width:700,
		height:530,
		resizable:false,
		//closeAction:'hide',
		modal:true,
		buttonAlign:'center', 
		layout:'border',
				defaults: {
				    split: true,
				    border: false
				},
				items: [{
				    region: 'north',
				    //height: 70,
				    height: 125,
				    items:kpiCalCfgForm
				},{

				    region:'west',
				    width: 550,
				    layout:'fit',
				    items:kpiCalCfgGrid
				},{
				    region:'center',
				    width: 150,
				    items:itemCalBtns
				}],
        buttons: [{
            //text:'保存',
        	text: '<span style="line-Height:1">保存</span>',
            icon: '../images/uiimages/filesave.png',
            handler:OnConfirm
        },{
            //text: '退出',
        	text: '<span style="line-Height:1">退出</span>',
            icon: '../images/uiimages/cancel.png',
            handler: OnCancel
        }],		
		listeners:{
			'close':function(){
				//calWin.hide();
			},
			'afterrender':function(th) {
				
		        var url=serviceUrl+'?action=getCalConfig';
				//dhcwl.mkpi.Util.ajaxExc(url,null,function(jsonData){
		        dhcwl.mkpi.Util.ajaxExc(url,
		        	{
		        		'curKpiID':curKpiID
		        	}
					,function(jsonData){
						calWin.body.unmask();
						if(jsonData.success==true && jsonData.tip=="ok"){
							var sumdim=jsonData.sumdim;
							var calExp=jsonData.calExp;
							var form=kpiCalCfgForm.getForm();
							form.setValues({sumDim:sumdim});   
							form.setValues({CalExp:calExp});  
						}else{
							Ext.Msg.alert("提示","操作失败！");
							}
							
						},this);    	
		    	
		    	calWin.body.mask("数据处理中，请稍等"); 
		    	 				
			},
	        'enable':function(){
	        	alert("enable");
	        },
	        'activate':function(){
	        	kpiCalCfgGrid.doLayout();	            				
	        }
			
		}
	});

	this.showWin=function(kpiID){
		curKpiID=kpiID
		store.proxy.setUrl(encodeURI(serviceUrl+'?action=searchKPI&start=0&limit=20&onePage=1&curKpiID='+curKpiID));
    	store.load();
		calWin.show();
		//clearForm();
		/*
        var url=serviceUrl+'?action=searchDimType&kpiID='+paraValues
		dhcwl.mkpi.Util.ajaxExc(url,null,function(jsonData){
				if(jsonData.success==true && jsonData.tip=="ok"){
					CalExpOld=jsonData.CalExp;
					CalRowID=jsonData.CalRowID;
					form.setValues({CalExp:CalExpOld});
				}else{
					Ext.Msg.alert("提示","操作失败！");
					}
				},this);	  		

    	*/
	}
	
	this.setSubWinParam=function(itemDR,itemDesc){
		OPTLItemDR=itemDR;
		calItemDesc=itemDesc
		
	}
	function clearForm(){
    	var form=kpiCalCfgForm.getForm();
    	form.setValues({CustomFun:''});
    }
    
    function OnConfirm() {
	    
	    //var sumDim=Ext.get('sumDim').getValue();
	    var sumDim=kpiCalCfgForm.getForm().findField("sumDim").getValue();
    	//var CalExp=Ext.get('CalExp').getValue();
    	var CalExp=kpiCalCfgForm.getForm().findField("CalExp").getValue();
		if (sumDim=="" || CalExp=="") {
			Ext.Msg.alert("提示","‘运算关系’或‘汇总维度’的值不能为空！");
			return;
			
		}
    	sumDim=sumDim.trim();
    	CalExp=CalExp.trim();
    	var param=CalExp+"|"+sumDim;
    	
        var url=serviceUrl+'?action=updateCalExp';
		//dhcwl.mkpi.Util.ajaxExc(url,null,function(jsonData){
        dhcwl.mkpi.Util.ajaxExc(url,
        	{
        		'CalExp':param,
        		'curKpiID':curKpiID
        	}
			,function(jsonData){
				calWin.body.unmask();
				if(jsonData.success==true && jsonData.tip=="ok"){
					
					//calWin.close();
				}else{
					Ext.Msg.alert("提示",jsonData.tip);
					}
					

				},this);    	
    	
    	calWin.body.mask("数据处理中，请稍等");  

		  	
    	
    	
    	/*
    	var form=kpiCalCfgForm.getForm();
        var values=form.getValues(false);       
        var CalExp=values.CalExp;

        if(!CalExp){
	       		Ext.MessageBox.alert("提示","统计项数据填写不完整！");
	       		return;                	       	
        }
        
        paraValues="OPTLItemDR="+OPTLItemDR+"&CalRowID="+CalRowID;
        var url=serviceUrl+'?action=addCalItem&'+paraValues;
		//dhcwl.mkpi.Util.ajaxExc(url,null,function(jsonData){
        dhcwl.mkpi.Util.ajaxExc(url,
        	{'CalExp':CalExp}
			,function(jsonData){
				if(jsonData.success==true && jsonData.tip=="ok"){
					if(jsonData.rptName){
						Ext.MessageBox.alert("提示","下面的报表使用了统计项之前的配置："+jsonData.rptName+"  !请先删除这些报表！");
						return;
					}
					else{
						if (CalRowID=="") {
							CalRowID=jsonData.ROWID;
						}
						
						refresh();
						Ext.Msg.alert("提示","操作成功！");
					}
				}else{
					Ext.Msg.alert("提示","操作失败！");
					}
					
				},this);	
        */
    }
    
    function refresh(){
		kpiCalCfgGrid.getStore().proxy.setUrl(encodeURI(serviceUrl+'?action=searchCalItem&start=0&limit=20&onePage=1'));
		kpiCalCfgGrid.getStore().load();
	    kpiCalCfgGrid.show();      	
    }
    function OnCancel() {
    	calWin.close();
    }
	
   function onBtnClick(btn){
   	   	//if(!Ext.get('CalExp')) return ;
	   if(!kpiCalCfgForm.getForm().findField("CalExp").getValue()) return;
   		partCalExp=btn.getText();

    	//var calExp=Ext.get('CalExp').getValue();
    	var calExp=kpiCalCfgForm.getForm().findField("CalExp").getValue();//modify by wk.2015-09-24
    	calExp=calExp+partCalExp;
		var form=kpiCalCfgForm.getForm();
		form.setValues({CalExp:calExp});                 	
    }    

   function onSetSumDim() {

    	var aryKpiDatas=new Array();
		var kpiCodes="";
    	//var sumDim=Ext.get('sumDim').getValue();
		var sumDim=kpiCalCfgForm.getForm().findField("sumDim").getValue();
    	if (sumDim) {
    		kpiCodes=sumDim;
    	}else{
			//var calExp=Ext.get('CalExp').getValue();
    		var calExp=kpiCalCfgForm.getForm().findField("CalExp").getValue();
    		var calExpT=calExp.split('>');
			//kpiCodes="";
			for (var i=0;i<=calExpT.length-1;i++) {
				var code=calExpT[i].split('<')[1];
				if (code){
					if (kpiCodes!="") kpiCodes=kpiCodes+",";
					kpiCodes=kpiCodes+code;
					var dataPos=aryData.isExist(code)
					if(dataPos>=0) {
						var kpiDataPos=aryKpiDatas.isExist(code);
						if (kpiDataPos<0) {
							data=aryData.slice(dataPos,dataPos+1);						
							aryKpiDatas.push(data[0]);
						}
					}
				}
			}
    	}
		//setRuleWin.setSelectedKpiArr(selectedKpis);
		if (kpiCodes=="") return;
		var setRuleWin=new dhcwl.mkpi.showkpidata.SetCalKpiRule();
		
		setRuleWin.setSelectedKpiCode(kpiCodes);
		setRuleWin.setParentWin(outThis);
		setRuleWin.reconfigureKpiListPanel(aryKpiDatas);
		setRuleWin.show();
		
    }   	
   	
   	
	Array.prototype.isExist=function(key){
		ret=-1;
		for(var i=0;i<=this.length-1;i++){
			if (this[i][0]==key) {
				ret=i;
				break;
			}
		}
		return ret;
	}

	this.SetDatasetKpiRule=function(ruleName,kpiRule){
		var form=kpiCalCfgForm.getForm();
		form.setValues({sumDim:kpiRule});    
		//form.findField("sumDim").setValue(kpiRule);
	}
}