(function(){
	Ext.ns("dhcwl.mkpi.KpiMMgrSEDateKpiCfg");
})();

 //在指标生成，重生，删除操作时，用于输入开始日期和结束日期及选择指标的页面
dhcwl.mkpi.KpiMMgrSEDateKpiCfg=function(){
	
	dateSecType = [
        ['D','日'],
        ['M','月'],
        ['Q','季'],
        ['Y','年']
    ];
	
    var dateSecStore = new Ext.data.ArrayStore({
			        id: 0,
			        fields: [
			            'dateSecCode',
			            'displayText'
			        ],
			        data: dateSecType
			    })	
	
	
	var outThis=this;
	var parentPanel=null;
	var hadChecked=0;	
	
    var form = new Ext.FormPanel({  
      labelAlign : 'top',  
      frame : true,  
      bodyStyle : 'padding:5px 5px 0',  
      layout : 'form',  
      items: [  
        {  
            xtype: 'datefield',
            fieldLabel: '开始时间',
            name : 'beginDate',  
            //format:'Y-m-d',
            editable:false, 
            anchor : '95%',
			format:GetWebsysDateFormat()
        }, {  
            xtype : 'datefield',  
            fieldLabel : '结束时间',  
            name : 'endDate',
            //format:'Y-m-d',
            editable:false,             
            anchor : '95%',
			format:GetWebsysDateFormat()
        },{
	            xtype : 'combo',  
	            fieldLabel : '区间类型',  
       			id:'ComboDateSecTypeIDOfKpi',
		        //store: dateSecType,
		        
			    store: dateSecStore,
			    valueField: 'dateSecCode',
			    displayField: 'displayText',		        

		        typeAhead: true,
		        forceSelection: true,
		        triggerAction: 'all',
		        //emptyText:'Select a state...',
		        anchor : '95%'  ,
		        //lazyRender:true//,
    			mode: 'local'
		        //selectOnFocus:true   
       	
        } 
      ],  
      buttonAlign: 'center',
      buttons : [  
        {  
          //text : '确定',  
          text: '<span style="line-Height:1">确定</span>',
          icon: '../images/uiimages/ok.png',
          handler : function() {
			var beginDate = form.getForm().findField('beginDate').getRawValue();  
			var endDate = form.getForm().findField('endDate').getRawValue();  
			var dateSecType = form.getForm().findField('ComboDateSecTypeIDOfKpi').getValue(); 
			if (beginDate=="" || endDate=="") {
				Ext.MessageBox.alert("提示","请选择时间段！");
				return;
			}			
			
			var recs=grid.getSelectionModel().getSelections();
			if(recs.length<=0) {
				Ext.MessageBox.alert("提示","请先选择要操作的指标！");    					
				return;					
			}
			var kpiCodes="";   	
			for (var i=0;i<=recs.length-1;i++){
				var kpiCode=recs[i].get("KpiCfg_Code");
				
				if (kpiCodes!="") kpiCodes=kpiCodes+",";
				kpiCodes=kpiCodes+kpiCode.split(":")[0];
			}			
			
			form.getForm().findField('beginDate').setValue("");
			form.getForm().findField('endDate').setValue("");	
			
			
			//清除CHECKBOX的头
			var hd_checker = grid.getEl().select('div.x-grid3-hd-checker');
			var hd = hd_checker.first();  
			if(hd.hasClass('x-grid3-hd-checker-on')){ 
				hd.removeClass('x-grid3-hd-checker-on'); 
			}			
			
			win.hide(this);  			

			var actFlag;
			if (hadChecked==1) {
				actFlag=3
			}else{
				actFlag=2				
			}			
			hadChecked=0;			
			
			if(parentPanel){
				parentPanel.onMmDataHandle(beginDate,endDate,kpiCodes,actFlag,dateSecType);
			}
          }

        }, {  
          //text : '取消',  
          text: '<span style="line-Height:1">取消</span>',
          icon: '../images/uiimages/undo.png',
          handler : function() {
			form.getForm().findField('beginDate').setValue("");
			form.getForm().findField('endDate').setValue("");	

			//清除CHECKBOX的头
			var hd_checker = grid.getEl().select('div.x-grid3-hd-checker');
			var hd = hd_checker.first();  
			if(hd.hasClass('x-grid3-hd-checker-on')){ 
				hd.removeClass('x-grid3-hd-checker-on'); 
			}
			
			win.hide(this);  			
			var kpiCodes="";
			if(parentPanel){
				parentPanel.onMmDataHandle("","",kpiCodes,-1,"");
			}
			
          }  
        }  
      ]  

    });  
  
    
	var sm = new Ext.grid.CheckboxSelectionModel();	
	var proxy = new Ext.data.HttpProxy({
	    url: 'dhcwl/kpi/kpidatasetcfgdata.csp'
	});
	
	var reader = new Ext.data.JsonReader({
	    totalProperty: 'totalNum',
	    root: 'root'      	
	}, [
	    {name: 'DatasetCfg_Code',type: 'string', allowBlank: false},
	    {name: 'KpiCfg_Code',type: 'string', allowBlank: false}
	]);
	
	    
	var store = new Ext.data.Store({
	    proxy: proxy,
	    reader: reader
	});
	
	var columns =  [
		new Ext.grid.RowNumberer(),
		 sm,
	    {header: "数据集编码", width: 160, sortable: true,menuDisabled : true, dataIndex: 'DatasetCfg_Code',id: 'DatasetCfg_Code'},
	    {header: "指标编码", width: 160, sortable: true,menuDisabled : true, dataIndex: 'KpiCfg_Code',id: 'KpiCfg_Code'}
	];

	var grid = new Ext.grid.GridPanel({
		title: '选择要操作的指标',
		iconCls: 'icon-grid',
		height: 175,
		store: store,
		//autoExpandColumn: 'DatasetCfg_Desc',
		columns : columns,
		sm: sm

	});

        
    
    
    var inputKpiList=[];
	var chkStore = new Ext.data.Store({
        proxy: new Ext.data.MemoryProxy(inputKpiList),
        reader: new Ext.data.ArrayReader({},
        	[
		 	    {name: 'kpiCode',type: 'string', allowBlank: false},
			    {name: 'treeCode',type: 'string', allowBlank: false},
			    {name: 'rptCode',type: 'string', allowBlank: false},
			    {name: 'dsCode',type: 'string', allowBlank: false}
       		])
    });
	
	var chkColumns =  [
		new Ext.grid.RowNumberer(),
	    {header: "指标编码", width: 60, sortable: true, dataIndex: 'kpiCode',id: 'kpiCode'},
	    {header: "模块编码", width: 160, sortable: true, dataIndex: 'treeCode',id: 'treeCode'},
	    {header: "报表编码", width: 80, sortable: true, dataIndex: 'rptCode',id: 'rptCode'},
	    {header: "数据集编码", width: 70, sortable: true, dataIndex: 'dsCode',id: 'dsCode'}	    
	    ];

	var chkGrid = new Ext.grid.GridPanel({
		//id:'datasetCfgPanel',
		iconCls: 'icon-grid',
		height: 175,
		//width:400,
		anchor : '99%' ,
		//bodyStyle : 'padding:0px 0px 0',  
		store: chkStore,
		//autoExpandColumn: 'DatasetCfg_Desc',
		columns : chkColumns,

		tbar: [{
            iconCls: 'icon-user-add',
            text: '冲突检查',
            handler: function() {
				if(parentPanel){
					
					var recs=grid.getSelectionModel().getSelections();
					if(recs.length<=0) {
						Ext.MessageBox.alert("提示","请先选择要操作的指标！");    					
						return;					
					}					
					var kpiCodes="";   	
					for (var i=0;i<=recs.length-1;i++){
						var kpiCode=recs[i].get("KpiCfg_Code");
						
						if (kpiCodes!="") kpiCodes=kpiCodes+",";
						kpiCodes=kpiCodes+kpiCode.split(":")[0];
					}			
		
					if(parentPanel){
						parentPanel.onMmDataHandle("","",kpiCodes,1);
					}					
					hadChecked=1;
					
					
					//parentPanel.onMmDataHandle("","",1);
					//hadChecked=1;
				}           	
            
            }
        }]
 
	});
  
    var chkCheckGroup = {
    	id:"chkCheckGroupKpi",
        xtype: 'fieldset',
        title: '可以对执行操作的指标进行冲突检查',
        autoHeight: true,
        layout: 'form',
        collapsed: true,   // initially collapse the group
        collapsible: true,
        bodyStyle: 'padding:0 0px 0;',
        frame:false,
        items: [chkGrid]
    }
	    
    
    
    var win = new Ext.Window({  
      title : '选择时间段',  
      closable : false,  
      modal : true,  
      //modal为True表示为当window显示时对其后面的一切内容进行遮罩，  
      //false表示为限制对其它UI元素的语法（默认为 false）。  
      width : 440,  
      resizable : false,  
      plain : true,  
      //Plain为True表示为渲染window body的背景为透明的背景，这样看来window body与边框元素（framing elements）融为一体，  
      //false表示为加入浅色的背景，使得在视觉上body元素与外围边框清晰地分辨出来（默认为false）。  
      layout : 'form',  
      items : [grid,chkCheckGroup,form]  
    });  

  
    this.setParentPanel=function(parentP){
    	parentPanel=parentP;
    }
    this.show=function(){
    	chkGrid.getStore().removeAll();    	
    	win.show(this);
    }
    
    this.onAction=function(isAct) {  
        var beginDate = form.getForm().findField('beginDate').getRawValue();  
        var endDate = form.getForm().findField('beginDate').getRawValue();  
		if(parentPanel){
			parentPanel.onMmDataHandle(beginDate,endDate,isAct);
		}
    }  
	
    this.getStore=function(){
    	return store;
    }

    this.getCheckGrid=function(){
    	return chkGrid;
    }
	this.setCheckGroupHide=function(isHide){
		//Ext.ComponentMgr.get('rptCfgGridPanel').hide();
		if(isHide) Ext.getCmp("chkCheckGroupKpi").hide();
		else Ext.getCmp("chkCheckGroupKpi").show();
	}
    this.setDateSecTypeHide=function(isHide) {
    	//var form=formPanel.getForm();
    	if (isHide){
			//隐藏编码fom
        	form.getForm().findField("ComboDateSecTypeIDOfKpi").disable();
        	//form.getForm().findField("ComboDateSecTypeIDOfKpi").label.hide();    
    	}else{
         	form.getForm().findField("ComboDateSecTypeIDOfKpi").enable();
        	//form.getForm().findField("ComboDateSecTypeIDOfKpi").label.show();    
    	}
    	
    }    
    
} 
