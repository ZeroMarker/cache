
var unitsUrl = 'dhcpha.comment.query.save.csp';


Ext.onReady(function() {

         Ext.QuickTips.init();// ������Ϣ��ʾ

		 Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	 var Request = new Object();
         Request = GetRequest();
         var QueryStr = Request['QueryStr'];
			       
    
   ////��ϸtable 
 var nm = new Ext.grid.RowNumberer();   
 var commentitmgridcm = new Ext.grid.ColumnModel([nm,

       
        {header:'������',dataIndex:'pcntsno',width:100},
        {header:'������',dataIndex:'prescno',width:100},
        {header:'�ǼǺ�',dataIndex:'patno',width:60},
        {header:'�Ա�',dataIndex:'patsex',width:60},
        {header:'����',dataIndex:'patage',width:60},
        {header:'���',dataIndex:'diag',width:200},
        {header:'ҽ������',dataIndex:'orddept',width:80},
        {header:'ҽ��',dataIndex:'doctor',width:80},
        {header:'���',dataIndex:'curret',width:60},
        {header:'ҩƷ����',dataIndex:'incidesc',width:180},
        {header:'colorflag',dataIndex:'colorflag',width:0}    

            
    
    ]);
 
 
    var commentitmgridds = new Ext.data.Store({
	autoLoad: true,
	proxy : new Ext.data.HttpProxy({
			url : unitsUrl
					+ '?action=FindCNTSData&QueryStr='+QueryStr,
			method : 'POST'
		}),
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'pcntsno',
            'prescno',
	    'patno',
	    'patsex',
	    'patage',
	    'diag',
	    'orddept',
	    'doctor',
	    'curret',
	    'incidesc',
	    'colorflag'
	    
		]),
		
		

    remoteSort: true
});




 
 var commentitmgrid = new Ext.grid.GridPanel({
        
        id:'commentgriditmtbl',
        //stripeRows: true,
        region:'center',
        width:150,
        //height:290,
        autoScroll:true,
	title:"",
        enableHdMenu : false,
        ds: commentitmgridds,
        cm: commentitmgridcm,
        enableColumnMove : false,
        view: new Ext.ux.grid.BufferView({
		    // custom row height
		    rowHeight: 25,
		    // render rows as they come into viewable area.
		    scrollDelay: false,
		       
		   getRowClass: function(record, index, rowParams, store) {  
		   		   
			   if (record.data.colorflag > 0) {
			   
			   return 'x-grid-record-green'; 
			   
			   }
		   
		   }
		    
		    
	    }),
	    

        trackMouseOver:'true'
        

        
    });  
    
    

	
	
    ///��ܶ���
    

      var port = new Ext.Viewport({

				layout : 'border',

				items : [commentitmgrid]

			});









});