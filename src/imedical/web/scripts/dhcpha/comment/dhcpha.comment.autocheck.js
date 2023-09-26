///显示处方问题列表
///Creator:LiangQiang
///CreatDate:2013-03-12
///

var unitsUrl = 'dhcpha.comment.main.save.csp';


Ext.onReady(function() {

  		Ext.QuickTips.init();// 浮动信息提示
  		Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

  		var Request = new Object();
        Request = GetRequest();
        var ChkStr = Request['ChkStr'];
  		
  		
	  	var repeatordgridcm = new Ext.grid.ColumnModel({
	  
		  columns:[
		 
		            {header:'colorflag',dataIndex:'colorflag',width:0,hidden:true},
			        {header:'处方号',dataIndex:'prescno',width:80},
		            {header:'药品名称',dataIndex:'incidesc',width:150},
				    {header:'数量',dataIndex:'qty',width:40},
				    {header:'单位',dataIndex:'uomdesc',width:60},
				    {header:'剂量',dataIndex:'dosage',width:60},
				    {header:'频次',dataIndex:'freq',width:40},
				    {header:'规格',dataIndex:'spec',width:80},
				    {header:'用法',dataIndex:'instruc',width:80},
				    {header:'用药疗程',dataIndex:'dura',width:60},
				    {header:'实用疗程',dataIndex:'realdura',width:60},
				    {header:'剂型',dataIndex:'form',width:80},
				    {header:'基本药物',dataIndex:'basflag',width:50},
				    {header:'医生',dataIndex:'doctor',width:60},
				    {header:'医嘱开单日期',dataIndex:'orddate',width:120},
				    {header:'医嘱备注',dataIndex:'remark',width:60},
				    {header:'厂家',dataIndex:'manf',width:150}
		
		        ]
		    });
	 
 
	    var repeatordgridds = new Ext.data.Store({
		proxy: "",
	        reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	        }, [
	                'colorflag',
	                'prescno',
	                'incidesc',
		            'qty',
		            'uomdesc',
		            'dosage',
		            'freq',
		            'spec',
		            'instruc',
		            'dura',
		            'realdura',
		            'form',
		            'basflag',
		            'doctor',
		            'orddate',
		            'remark',
		            'manf'
		            
			]),
			
			
	
	    	remoteSort: true
	    });


	
 
	   var repeatordgrid = new Ext.grid.GridPanel({
	        height:550,
	        width:990,
	        frame:false,
	        stripeRows: true,
	        id:'repeatordtbl',
	        region:'border',
	        enableHdMenu : false,
	        ds: repeatordgridds,
	        cm: repeatordgridcm,
	        enableColumnMove : false,
		
	        view: new Ext.ux.grid.BufferView({
	
			    rowHeight: 25,
			    scrollDelay: false,
			    getRowClass: function(record, index, rowParams, store) {  
		   
			    
				   if (record.data.colorflag > 0) {
				   
				   
				   		return 'x-grid-record-green'; 
				   
				   }
			   
			   }
			    
			    
		    }),
		    
		   
	        trackMouseOver:'true' 
	           
	           
	        
	
	        
	    });
    
        GetRepeatOrdList(ChkStr) 
  		
  		var centerPanel = new Ext.TabPanel({
	        id:'ToolsTabPanel',
		    region: 'center',
		    margins:'3 3 3 0', 
		    frame:false,
		    activeTab: 0,
		    //defaults:{autoScroll:true},
		    //deferredRender:false,
		     height:650,
		     //autoHight:'true',
		    items:[{
		                title: '重复用药',	
						id:'repeatordlist',
						items: [repeatordgrid]
		
		    }]
  		
  		})
  		
  
        var port = new Ext.Viewport({

				layout : 'border',

				items : [centerPanel]

			});
	
			/////////////////////function  /////////
			
			
			
	function GetRepeatOrdList(ChkStr)  
	{
	            
	        repeatordgridds.removeAll();
			repeatordgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=GetRepeatOrdList&ChkStr='+ChkStr });		
			repeatordgridds.load({
			callback: function(r, options, success){
	 
			         
			         
			         if (success==false){
			                     Ext.Msg.show({title:'注意',msg:'查询失败 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
			                     }
			          }
			         
			
			});
			
					
			
	} 



});


