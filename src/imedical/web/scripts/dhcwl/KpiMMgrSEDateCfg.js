(function(){
	Ext.ns("dhcwl.mkpi.KpiMMgrSEDateCfg");
})();

  //在模块或报表生成，重生，删除操作时，用于输入开始日期和结束日期的页面
dhcwl.mkpi.KpiMMgrSEDateCfg=function(){

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
       			id:'ComboDateSecTypeID',
		        //store: dateSecType,
		        
			    store: dateSecStore,
			    valueField: 'dateSecCode',
			    displayField: 'displayText',		        

		        typeAhead: true,
		        forceSelection: true,
		        triggerAction: 'all',
		        //emptyText:'Select a state...',
		        anchor : '95%'  ,

    			mode: 'local',
		        selectOnFocus:true   
       	
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
			var dateSecType = form.getForm().findField('ComboDateSecTypeID').getValue(); 
			if (beginDate=="" || endDate=="") {
				Ext.MessageBox.alert("提示","请选择时间段！");
				return;
			}
			win.hide(this);            	
			form.getForm().findField('beginDate').setValue("");
			form.getForm().findField('endDate').setValue("");
			form.getForm().findField('ComboDateSecTypeID').setValue("");
			var actFlag;
			if (hadChecked==1) {
				actFlag=3
			}else{
				actFlag=2				
			}
			hadChecked=0;
			
			if(parentPanel){
				parentPanel.onMmDataHandle(beginDate,endDate,actFlag,dateSecType);
			}
          }

        }, {  
          //text : '取消', 
          text: '<span style="line-Height:1">取消</span>',
          icon: '../images/uiimages/undo.png',
          handler : function() {
          	win.hide(this);    
			var beginDate = form.getForm().findField('beginDate').getRawValue();  
			var endDate = form.getForm().findField('endDate').getRawValue();  
			form.getForm().findField('beginDate').setValue("");
			form.getForm().findField('endDate').setValue("");			
			if(parentPanel){
				parentPanel.onMmDataHandle(beginDate,endDate,-1,"");
			}
          }  
        }  
      ]  
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
	    {header: "指标编码", width: 60, sortable: true, dataIndex: 'kpiCode',id: 'kpiCode',menuDisabled : true},
	    {header: "模块编码", width: 160, sortable: true, dataIndex: 'treeCode',id: 'treeCode',menuDisabled : true},
	    {header: "报表编码", width: 80, sortable: true, dataIndex: 'rptCode',id: 'rptCode',menuDisabled : true},
	    {header: "数据集编码", width: 70, sortable: true, dataIndex: 'dsCode',id: 'dsCode',menuDisabled : true}	    
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
					parentPanel.onMmDataHandle("","",1);
					hadChecked=1;
				}           	
            
            }
        }]
 
	});
  
    var chkCheckGroup = {
    	id:"chkCheckGroup",
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
      items : [chkCheckGroup,form]  
    });  

  
    this.setParentPanel=function(parentP){
    	parentPanel=parentP;
    }
    this.show=function(){
    	chkGrid.getStore().removeAll();
    	win.show(this);
    }
    this.getCheckGrid=function(){
    	return chkGrid;
    }
    
    this.setCheckGroupHide=function(isHide){
    	//Ext.ComponentMgr.get('rptCfgGridPanel').hide();
    	if(isHide) Ext.getCmp("chkCheckGroup").hide();
    	else Ext.getCmp("chkCheckGroup").show();
    }
    
    this.setDateSecTypeHide=function(isHide) {
    	//var form=formPanel.getForm();
    	if (isHide){
			//隐藏编码fom
        	form.getForm().findField("ComboDateSecTypeID").disable();
        	//form.getForm().findField("ComboDateSecTypeID").label.hide();    
    		//Ext.getCmp("ComboDateSecTypeID").hide();
    		//Ext.getCmp("ComboDateSecTypeID").label.hide();
    	}else{
         	form.getForm().findField("ComboDateSecTypeID").enable();
        	//form.getForm().findField("ComboDateSecTypeID").label.show();    
    		//Ext.getCmp("ComboDateSecTypeID").show();
    		//Ext.getCmp("ComboDateSecTypeID").label.show();    		
    	}
    	
    }

} 
