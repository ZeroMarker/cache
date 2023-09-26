
var unitsUrl = 'dhcpha.comment.query.save.csp';


Ext.onReady(function() {

         Ext.QuickTips.init();// 浮动信息提示

		 Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	 var Request = new Object();
         Request = GetRequest();
         var QueryStr = Request['QueryStr'];
			       
    
   ////明细table 
 var nm = new Ext.grid.RowNumberer();   
 var commentitmgridcm = new Ext.grid.ColumnModel([nm,

       
        {header:'点评单',dataIndex:'pcntsno',width:100},
        {header:'处方号',dataIndex:'prescno',width:100},
        {header:'登记号',dataIndex:'patno',width:60},
        {header:'性别',dataIndex:'patsex',width:60},
        {header:'年龄',dataIndex:'patage',width:60},
        {header:'诊断',dataIndex:'diag',width:200},
        {header:'医生科室',dataIndex:'orddept',width:80},
        {header:'医生',dataIndex:'doctor',width:80},
        {header:'结果',dataIndex:'curret',width:60},
        {header:'药品名称',dataIndex:'incidesc',width:180},
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
    
    

	
	
    ///框架定义
    

      var port = new Ext.Viewport({

				layout : 'border',

				items : [commentitmgrid]

			});









});