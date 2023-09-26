///��ʾ���������б�
///Creator:LiangQiang
///CreatDate:2013-03-12
///

var unitsUrl = 'dhcpha.comment.main.save.csp';


Ext.onReady(function() {

  		Ext.QuickTips.init();// ������Ϣ��ʾ
  		Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

  		var Request = new Object();
        Request = GetRequest();
        var ChkStr = Request['ChkStr'];
  		
  		
	  	var repeatordgridcm = new Ext.grid.ColumnModel({
	  
		  columns:[
		 
		            {header:'colorflag',dataIndex:'colorflag',width:0,hidden:true},
			        {header:'������',dataIndex:'prescno',width:80},
		            {header:'ҩƷ����',dataIndex:'incidesc',width:150},
				    {header:'����',dataIndex:'qty',width:40},
				    {header:'��λ',dataIndex:'uomdesc',width:60},
				    {header:'����',dataIndex:'dosage',width:60},
				    {header:'Ƶ��',dataIndex:'freq',width:40},
				    {header:'���',dataIndex:'spec',width:80},
				    {header:'�÷�',dataIndex:'instruc',width:80},
				    {header:'��ҩ�Ƴ�',dataIndex:'dura',width:60},
				    {header:'ʵ���Ƴ�',dataIndex:'realdura',width:60},
				    {header:'����',dataIndex:'form',width:80},
				    {header:'����ҩ��',dataIndex:'basflag',width:50},
				    {header:'ҽ��',dataIndex:'doctor',width:60},
				    {header:'ҽ����������',dataIndex:'orddate',width:120},
				    {header:'ҽ����ע',dataIndex:'remark',width:60},
				    {header:'����',dataIndex:'manf',width:150}
		
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
		                title: '�ظ���ҩ',	
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
			                     Ext.Msg.show({title:'ע��',msg:'��ѯʧ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
			                     }
			          }
			         
			
			});
			
					
			
	} 



});


