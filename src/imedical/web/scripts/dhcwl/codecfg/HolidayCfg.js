(function(){
	Ext.ns("dhcwl.codecfg.HolidayCfg");
})();
Ext.onReady(function(){

//周六周日默认假日  假日－－1  节日－－2
//dhcwl.codecfg.HolidayCfg=function(){
	var serviceUrl="dhcwl/codecfg/codecfgholiday.csp";
	var outThis=this;
	
	var csm = new Ext.grid.CheckboxSelectionModel()     //新建复选框的对象，使用的时候直接写  'csm' 
    var columnModel = new Ext.grid.ColumnModel([
        csm,
        {header:'待选日期',dataIndex:'UnChoice',width: 300, sortable: true,menuDisabled : true},
        //{header:'所属类型',dataIndex:'DateType',width: 160, sortable: true},
        {header:'标志',dataIndex:'Weekflag',width: 10, sortable: true,hidden : true,
         renderer: function(v, metaData, record, rowIndex, colIndex, store) {
	         if(v==1){     // 选择逻辑   --- 该值==1选中，否则不处理
	                unchoiceGrid.getSelectionModel().selectRow(rowIndex,true);
	         }
	         return v;
         }

        }
    ]);
	var store = new Ext.data.Store({
    	proxy: new Ext.data.HttpProxy({url:serviceUrl}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNums',
            root: 'root',
        	fields:[
        		{name: 'UnChoice'},
            	//{name: 'DateType'},
            	{name: 'Weekflag',type : 'int'}    //设置type排序是按数字排
       		]
    	})
    });
	store.load
	/*
	var radiogroup= new Ext.form.RadioGroup({                
		fieldLabel : "维护日期类型", 
		name : "holidayflag",
		id:'holiday',
		xtype: 'radiogroup',
        columns: [50, 50],
		items : [{                            
			boxLabel : '假日',                            
			inputValue : '1',                            
			checked : true,                            
			name : "holidayflag"                        
		}, {                            
			boxLabel : '节日',                            
			name : "holidayflag",                            
			inputValue : '2'                        
		}]    
	});
	*/
	var unchoiceGrid = new Ext.grid.GridPanel({
        stripeRows:true,
        loadMask:true,
        height:480,
        store: store,
        cm: columnModel,
        sm:csm,
        title: '待选日期',
        tbar:new Ext.Toolbar([
            //'维护类型:',radiogroup
			
           //'维护类型:',
		   /*
		   {
			   xtype: 'fieldset',
			   fieldLabel :'维护类型',
               name: 'holidayflag',
               id:'holiday',
               xtype: 'radiogroup',
               //columns: [50, 50],
               //vertical: true,
               items: [
					{boxLabel: '假日', name: 'holidayflag', inputValue: 1,checked: true},   
					{boxLabel: '节日', name: 'holidayflag',inputValue: 2}   
				]
			},*/
			'维护类型:',
			{
				xtype:'radio',
				boxLabel: '假日', name: 'holidayflag', inputValue: 1,checked: true
			}, {
				xtype:'radio',
				boxLabel: '节日', name: 'holidayflag',inputValue: 2
			},			
			
			
			
			
			"->",{
                  //text:'保存',
                  text: '<span style="line-Height:1">保存</span>',
				  icon: '../images/uiimages/filesave.png',
				  //id:'grpadd_btn',
				  handler:function(){
					  
					  //var holidayFlag=Ext.getCmp('holiday').getValue().inputValue;
						var holidayInx=unchoiceGrid.getTopToolbar().items.findIndex("name","holidayflag");	
						//alert(holidayInx);
					  var holidayFlag=unchoiceGrid.getTopToolbar().items.itemAt(holidayInx).getGroupValue();
					  //alert(holidayFlag);
					  //return;
					  
					  
					  
			  //alert(holidayFlag) ; 

 	          var selectItemPara="";
			  var rowObj=unchoiceGrid.getSelectionModel().getSelections();
			  var len = rowObj.length;
			  if(len < 1){
				Ext.Msg.show({title:'注意',msg:'请选择要添加的项目！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			  }else{
				var idStr="";
					for(var i=0;i<len;i++){
						ItemId=rowObj[i].get("UnChoice");
						if(idStr==""){
							idStr=ItemId;
						}else{
							idStr=idStr+"*"+ItemId
						}
							
					}
				selectItemPara=idStr;	
				//window.close();
				}		
	           paraValues='holidayFlag='+holidayFlag+'&selectItemPara='+selectItemPara;
	           //alert(paraValues);                
	           dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=addholiday&'+paraValues);
	           Query();

				  }
			}
        ])
        
    });
    var timeRangeStore= new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({url:serviceUrl+'?action=getDHCTimeRange'}),
			reader:new Ext.data.ArrayReader({},[{name:'isGlobalV'},{name:'isGlobal'}])
		})
    var timeFlagCombo=new Ext.form.ComboBox({
		id:'timeFlagCombo',
		autoLoad:true,
		width : 150,
		editable:false,
		xtype : 'combo',
		mode : 'remote',
		triggerAction : 'all',
		value:'全天',
		name : 'globalFlagCombo',
		displayField : 'isGlobal',
		valueField : 'isGlobalV',	
		store : timeRangeStore  /*new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({url:serviceUrl+'?action=getDHCTimeRange'}),
			reader:new Ext.data.ArrayReader({},[{name:'isGlobalV'},{name:'isGlobal'}])
		})*/,
		typeAhead: true, 
		tpl:'<tpl for="."><div class="x-combo-list-item"><span><input type="checkbox" {[values.check?"checked":""]} value="{[values.isGlobal]}" /></span><span >{isGlobal}</span></div></tpl>', 
		selectOnFocus:true,
		listeners:{
				"expand":function(combo, store,index){ 
				Ext.getCmp("timeFlagCombo").getStore().load();
				} 
			},

		onSelect : function(record, index){   	        
	        if(this.fireEvent('beforeselect', this, record, index) !== false){   
	            record.set('check',!record.get('check'));   
	            var str=[];//页面显示的值   
	            var strvalue=[];//传入后台的值  
	            this.store.each(function(rc){   
	                if(rc.get('check')){   
	                    str.push(rc.get('isGlobal'));   
	                    strvalue.push(rc.get('isGlobalV'));   
	                }   
	            });   
	            this.setValue(str.join());   
	            this.value=strvalue.join();   
	            //this.collapse();   
	            this.fireEvent('select', this, record, index);  
	            var sm = choiceGrid1.getSelectionModel();
	            var rc = sm.getSelected();
	            var ID=rc.get("id");   
	             	            
	        }   
	        //alert("strvalue"+strvalue+"id"+ID) 
	        choiceStore.proxy.setUrl(encodeURI(serviceUrl+'?action=updateAP&ID='+ID+"&timeAP="+strvalue));
	        choiceStore.load();
	    }
	});
	                    
	
    var chjrcsm = new Ext.grid.CheckboxSelectionModel()     //新建复选框的对象，使用的时候直接写  'csm' 
    var cm1 = new Ext.grid.ColumnModel([
        chjrcsm,
        {header:'已选日期',dataIndex:'ChoiceDay',width: 160, sortable: true,menuDisabled : true},
        {header:'时段',dataIndex:'AmOrPm',width: 160,sortable: true,menuDisabled : true,
         editor:new Ext.grid.GridEditor(timeFlagCombo),
         renderer: function(value,metadata,record){            //选择下拉框内容后GRID显示displayField 值
                    var index = timeRangeStore.find('isGlobalV',value);   
                    if(index!=-1){   
                        return timeRangeStore.getAt(index).data.isGlobal;   
                    }   
                    return value;   
                 }
         },
        {header:'id',dataIndex:'id',width: 0, sortable: true,hidden : true}
    ]);
    
    var choiceStore = new Ext.data.Store({      
        proxy: new Ext.data.HttpProxy({url:serviceUrl}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNums',
            root: 'root',
        	fields:[
        		{name: 'ChoiceDay'},
            	{name: 'AmOrPm'},
            	{name: 'id'}
       		]
    	})
    	
    });
    choiceStore.load();
    var choiceGrid1 = new Ext.grid.EditorGridPanel({    //假日
        stripeRows:true,
        loadMask:true,
        height:480,
        store: choiceStore,
        cm: cm1,
        sm:chjrcsm,
        title: '假日已选日期',
		tbar:new Ext.Toolbar([
			{
                  //text:'移除',
                  text: '<span style="line-Height:1">移除</span>',
				  icon: '../images/uiimages/edit_remove.png',
				  //id:'grpadd_btn',
				  handler:function(){
					  var sd = Ext.get("startdt").getValue(), ed = Ext.get("enddt").getValue();
            	  var selectItemPara="";
				  var rowObj=choiceGrid1.getSelectionModel().getSelections();
				  var len = rowObj.length;
				  if(len < 1){
					Ext.Msg.show({title:'注意',msg:'请选择要删除的项目！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				  }else{
					var idStr="";
						for(var i=0;i<len;i++){
							choiceStore.remove(rowObj[i]);
							ItemId=rowObj[i].get("id");
							if(idStr==""){
								idStr=ItemId;
							}else{
								idStr=idStr+"*"+ItemId
							}
								
						}
					selectItemPara=idStr;
					}		
		           paraValues='selectItemPara='+selectItemPara;
		           //alert(paraValues);                
		           dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=delitem&'+paraValues);
		           queryPara="sDate="+sd+"&eDate="+ed;
				   //alert(queryPara)
				   store.proxy.setUrl((serviceUrl+'?action=GetAllDate&'+queryPara));  //encodeURI(preUrl+"showkpidata.csp?"+ paras));
				   store.load();
				  }
			}
		])
        
    });
    
    var timeFlagCombo1=new Ext.form.ComboBox({
		id:'timeFlagCombo1',
		width : 150,
		editable:false,
		xtype : 'combo',
		mode : 'remote',
		triggerAction : 'all',
		value:'全天',
		name : 'globalFlagCombo',
		displayField : 'isGlobal',
		valueField : 'isGlobalV',
		/*store : new Ext.data.JsonStore({
			fields : ['isGlobal', 'isGlobalV'],
			data : [{
				isGlobal : '全天',
				isGlobalV : 'AP'
			}, {
				isGlobal : '上午',
				isGlobalV : 'A'
			}, {
				isGlobal : '下午',
				isGlobalV : 'P'
			}]}),*/
		store : timeRangeStore   /*new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({url:serviceUrl+'?action=getDHCTimeRange'}),
			reader:new Ext.data.ArrayReader({},[{name:'isGlobalV'},{name:'isGlobal'}])
		})*/,
		typeAhead: true, 
		tpl:'<tpl for="."><div class="x-combo-list-item"><span><input type="checkbox" {[values.check?"checked":""]} value="{[values.isGlobal]}" /></span><span >{isGlobal}</span></div></tpl>', 
		selectOnFocus:true,
		/*listeners :{
			'select':function(combox){
				timeFlagCombo1.setValue(combox.getValue());
				//var timeAP=timeFlagCombo1.getRawValue();
				var timeAP=combox.getValue();
				//alert(timeAP);
				var sm = choiceGrid2.getSelectionModel();
                var record = sm.getSelected();
                var ID=record.get("id")
                //alert(ID)
                choiceStore1.proxy.setUrl(encodeURI(serviceUrl+'?action=updateAP&ID='+ID+"&timeAP="+timeAP));
                choiceStore1.load();
				
			}
		}*/
		listeners:{
				"expand":function(combo, store,index){ 
				Ext.getCmp("timeFlagCombo1").getStore().load();
				} 
			},
		onSelect : function(record, index){   	        
	        if(this.fireEvent('beforeselect', this, record, index) !== false){   
	            record.set('check',!record.get('check'));   
	            var str=[];//页面显示的值   
	            var strvalue=[];//传入后台的值  
	            this.store.each(function(rc){   
	                if(rc.get('check')){   
	                    str.push(rc.get('isGlobal'));   
	                    strvalue.push(rc.get('isGlobalV'));   
	                }   
	            });   
	            this.setValue(str.join());   
	            this.value=strvalue.join();   
	            //this.collapse();   
	            this.fireEvent('select', this, record, index);  
	            var sm = choiceGrid2.getSelectionModel();
	            var rc = sm.getSelected();
	            var ID=rc.get("id");   
	             	            
	        }   
	        //alert("strvalue"+strvalue+"id"+ID) 
	        choiceStore1.proxy.setUrl(encodeURI(serviceUrl+'?action=updateAP&ID='+ID+"&timeAP="+strvalue));
	        choiceStore1.load();
	    }
	});
    var chjrcsm1 = new Ext.grid.CheckboxSelectionModel()     //新建复选框的对象，使用的时候直接写  'csm' 
    var cm2 = new Ext.grid.ColumnModel([
        chjrcsm1,
        {header:'已选日期',dataIndex:'ChoiceDay',width: 160, sortable: true,menuDisabled : true},
        {header:'时段',dataIndex:'AmOrPm',width: 160,sortable: true,menuDisabled : true,
         editor:new Ext.grid.GridEditor(timeFlagCombo1),
         renderer: function(value,metadata,record){            //选择下拉框内容后GRID显示displayField 值
                    var index = timeRangeStore.find('isGlobalV',value);   
                    if(index!=-1){   
                        return timeRangeStore.getAt(index).data.isGlobal;   
                    }   
                    return value;   
                 }
         },
        {header:'id',dataIndex:'id',width: 10, sortable: true,hidden : true}
    ]);
    
    var choiceStore1 = new Ext.data.Store({      
        proxy: new Ext.data.HttpProxy({url:serviceUrl}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNums',
            root: 'root',
        	fields:[
        		{name: 'ChoiceDay'},
            	{name: 'AmOrPm'},
            	{name: 'id'}
       		]
    	})
    	
    });
    choiceStore1.load();
    var choiceGrid2 = new Ext.grid.EditorGridPanel({     //节日
        stripeRows:true,
        loadMask:true,
        height:480,
        store: choiceStore1,
        cm: cm2,
        sm:chjrcsm1,
        title: '节日已选日期',
		tbar:new Ext.Toolbar([
			{
				  //text:'移除',
				  text: '<span style="line-Height:1">移除</span>',
				  icon: '../images/uiimages/edit_remove.png',
				  //id:'grpadd_btn',
				  handler:function(){
					  var sd = Ext.get("startdt").getValue(), ed = Ext.get("enddt").getValue();
            	  var selectItemPara="";
				  var rowObj=choiceGrid2.getSelectionModel().getSelections();
				  var len = rowObj.length;
				  if(len < 1){
					Ext.Msg.show({title:'注意',msg:'请选择要删除的项目！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				  }else{
					var idStr="";
						for(var i=0;i<len;i++){
							choiceStore1.remove(rowObj[i]);
							ItemId=rowObj[i].get("id");
							if(idStr==""){
								idStr=ItemId;
							}else{
								idStr=idStr+"*"+ItemId
							}
								
						}
					selectItemPara=idStr;
					}		
		           paraValues='selectItemPara='+selectItemPara;
		           //alert(paraValues);                
		           dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=delitem&'+paraValues);
		           queryPara="sDate="+sd+"&eDate="+ed;
				   //alert(queryPara)
				   store.proxy.setUrl((serviceUrl+'?action=GetAllDate&'+queryPara));  //encodeURI(preUrl+"showkpidata.csp?"+ paras));
				   store.load();
		           //Query();
				  }
				  
			}
		])
    });
	
	var setForm=new Ext.form.FormPanel({
	  ///labelWidth: 125,
	  height:90,
      labelAlign: 'right',
	  frame : true,
	  bodyStyle:'padding:5px',
	  labelWidth : 60,
      //title: '条件选择',
      bodyStyle:'padding:5px',       //'padding:5px 5px 0',
      //width: 800,
      //layout: 'table',
	  
	  items : [{
			layout : 'column',
			items : [
			{ 
				columnWidth : .2,
				layout : 'form',
				defaultType : 'textfield',
				defaults : {
					width : 120
				},
				items : [{
					xtype:'datefield',
					fieldLabel: '开始日期',
					//format :'Y-m-d',
					name: 'startdt',
					id: 'startdt',
					startDateField: 'startdt',
					value:dhcwl.mkpi.Util.nowDate(),
					format:GetWebsysDateFormat()
					//vtype: 'daterange'
			  }]
			},{ 
				columnWidth : .2,
				layout : 'form',
				defaultType : 'textfield',
				defaults : {
					width : 120
				},
				items : [{
					xtype:'datefield',
					//format :'Y-m-d',
					fieldLabel: '结束日期',
					name: 'enddt',
					id: 'enddt',
					endDateField: 'enddt',
					value:dhcwl.mkpi.Util.nowDate(),
					format:GetWebsysDateFormat()
					//vtype: 'daterange'
			  }]
			},{ 
				columnWidth : .1,
				layout : 'form',
				defaults : {
					width : 60
				},
				items : [{
					xtype:'button',
					//text:'查询',
					text: '<span style="line-Height:1">查询</span>',
					  icon: '../images/uiimages/search.png',
					  //id:'grpadd_btn',
					  handler:function(){
						  Query();
					  }
			  }]}]
		}]
	  
	  
	});
	function Query(){
	        var sd=Ext.get("startdt").getValue()
      		if(!Ext.get("startdt").getValue()||!Ext.get("enddt").getValue()){
					alert("请选择开始日期和截止日期！");
					return;
				}
				var sd = Ext.get("startdt").getValue(), ed = Ext.get("enddt").getValue();
				/*if(Ext.get("startdt").getValue()>Ext.get("enddt").getValue()){
					alert("开始日期不能大于结束日期！");
					return ;
				}*/
				queryPara="sDate="+sd+"&eDate="+ed;
				dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=compareDate&'+queryPara
					,null,function(jsonData){
						if(!jsonData){
							Ext.Msg.show({title:'错误',msg:"初始化数据失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}
						if(jsonData.success){
							if (jsonData.tip=="ok") {
								queryPara="sDate="+sd+"&eDate="+ed;
								choiceQueryPara1="sDate="+sd+"&eDate="+ed+"&HolidayFlag=1";
								choiceQueryPara2="sDate="+sd+"&eDate="+ed+"&HolidayFlag=2";
								store.proxy.setUrl((serviceUrl+'?action=GetAllDate&'+queryPara));  
								store.load(); 
								choiceStore.proxy.setUrl((serviceUrl+'?action=GetChoiceDate&'+choiceQueryPara1));  
								choiceStore.load(); 
								choiceStore1.proxy.setUrl((serviceUrl+'?action=GetChoiceDate&'+choiceQueryPara2));  
								choiceStore1.load(); 								
							}else{
								Ext.Msg.alert("提示","开始日期不能大于结束日期！");
								return;
							}
						}else{
							Ext.Msg.show({title:'错误',msg:"日期检测失败,请稍后再试！\n"+jsonData.tip,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}
					},outThis);
				
				/*queryPara="sDate="+sd+"&eDate="+ed;
				choiceQueryPara1="sDate="+sd+"&eDate="+ed+"&HolidayFlag=1";
				choiceQueryPara2="sDate="+sd+"&eDate="+ed+"&HolidayFlag=2";
				//alert(queryPara)
				store.proxy.setUrl((serviceUrl+'?action=GetAllDate&'+queryPara));  //encodeURI(preUrl+"showkpidata.csp?"+ paras));
				store.load(); //{params:{start:0,limit:30,onePage:1}});
				//alert(choiceQueryPara1)
				choiceStore.proxy.setUrl((serviceUrl+'?action=GetChoiceDate&'+choiceQueryPara1));  //encodeURI(preUrl+"showkpidata.csp?"+ paras));
				choiceStore.load(); //{params:{start:0,limit:30,onePage:1}});
				choiceStore1.proxy.setUrl((serviceUrl+'?action=GetChoiceDate&'+choiceQueryPara2));  //encodeURI(preUrl+"showkpidata.csp?"+ paras));
				choiceStore1.load(); //{params:{start:0,limit:30,onePage:1}});*/	
	
	}
	
	var startDate=new Ext.form.DateField({
		fieldLabel: '开始日期',
		//format :'Y-m-d',
        name: 'startDate',
        width:130
		//value:dhcwl.mkpi.Util.yesterday()
    });
	var endDate=new Ext.form.DateField({
		fieldLabel: '结束日期',
		//format :'Y-m-d',
        name: 'endDate',
        width:130
		//value:dhcwl.mkpi.Util.yesterday()
    });
    function ItemPara(){
		var idStr="";    //strPara="",
        //var len=storeSubGrp.getTotalCount();
        var len=codecfgsubgroupGrid.getStore().getCount();   //grid行数
        //alert(len);
        var idStr="";
		for(var i=0;i<len;i++){
			ItemId=storeSubGrp.getAt(i).get('ID');
			if(idStr==""){
				idStr=ItemId+"*"+(i+1);
				}else{
					idStr=idStr+"-"+ItemId+"*"+(i+1)
					}		
				}
		strPara=idStr;
		//alert(strPara);
	
	}
    /*var holidayCfgPanel =new Ext.Panel ({
		//title:'节假日维护',
		id:'codecfgholiday',
		layout : 'table',
		autoScroll:true,
		layoutConfig: {columns:3},
		defaults: {frame:true, width:390},
		width:500,
		//height:500,
		//modal:true,
		//resizable:true,
		//items:detailGrid
		items:[{
            autoScroll:true,
            width:1170,
            colspan:3,
            //region: 'center',
            items:setForm
            },{
        	//region:'center',
        	autoScroll:true,
            items:unchoiceGrid
    	    },{
    	    	autoScroll:true,
    	    	items:choiceGrid1
    	    },{
    	    	autoScroll:true,
    	    	items:choiceGrid2
    	    }
		],
		listeners:{
    		"resize":function(win,width,height){    			
    			//setForm.setWidth(width-20);
    			unchoiceGrid.setHeight(height-160);
    			choiceGrid1.setHeight(height-160);
    			choiceGrid2.setHeight(height-160);
    		}
    	}
	});*/
    
    var holidayCfgPanel =new Ext.Panel ({ //Viewport({
    	//title:'节假日维护',
    	id:'codecfgholiday',
		layout: {
			type: 'vbox',
			pack: 'start',
			align: 'stretch'
		},
		
    	defaults: { border :false},
        items: [{ 
			border :false,
			flex:0.45,
			layout:"fit",
            items:[
			{
				//border :false,
				layout: {
					type: 'hbox',
					pack: 'start',
					align: 'stretch'
				},				
				items:[{
					//border :false,
					flex:1,
					layout:"fit",
					items:setForm
				}]
			}]
    	},{
			border :false,
			flex:3,
			layout:"fit",
            items:[{
				border :false,
				layout: {

					type: 'hbox',
					pack: 'start',
					align: 'stretch'
				},				
				items:[{
					flex:1,
					layout:"fit",
					items:unchoiceGrid
				},{
					flex:1,
					layout:"fit",
					items:choiceGrid1					
				},{
					flex:1,
					layout:"fit",
					items:choiceGrid2					
				}]
			}]
        }]
    });
    
	this.mainWin=new Ext.Viewport({
    	id:'maintainHolidayCfg',
        //renderTo:Ext.getBody(),
        autoShow:true,
        autoScroll:true,
        expandOnShow:true,
        resizable:true,
        layout: 'fit',
        width:1000,
        //heitht:400,
        items: [holidayCfgPanel]
    });
    this.getholidayCfgPanel=function(){
    	return holidayCfgPanel;
    }
})