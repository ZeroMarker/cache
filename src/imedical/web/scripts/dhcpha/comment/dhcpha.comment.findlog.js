

FindCommentLogFun = function(orditem) {

    Ext.QuickTips.init();

	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	
    var CommentLogOKButton = new Ext.Button({
             width : 55,
             id:"CommentLogOK",
             text: '确定',
             listeners:{   
                          "click":function(){  

                           //FindOrdData();
                           FindCommentLogWindow.close()
                           
                              }   
                       } 
             
             })	
		
	
 
 
  var commentloggridcm = new Ext.grid.ColumnModel({
  
  columns:[
        {header:'点评原因',dataIndex:'comreason',width:200},
        {header:'姓名',dataIndex:'patname',width:60},
        {header:'处方号',dataIndex:'prescno',width:80},
        {header:'点评日期',dataIndex:'comdate',width:80},
        {header:'点评时间',dataIndex:'comtime',width:60},
        {header:'点评人',dataIndex:'comuser',width:60},
        {header:'点评结果',dataIndex:'comresult',width:60},       
        {header:'不合格警示值',dataIndex:'comfactor',width:80},
        {header:'药师建议',dataIndex:'comadvice',width:80},
        {header:'医生反馈',dataIndex:'comdocadvice',width:80},
        {header:'药师备注',dataIndex:'comphnote',width:60},
        {header:'医生备注',dataIndex:'comdocnote',width:60},
        {header:'激活',dataIndex:'comactive',width:40}
       
          ]   
            
    
    });
 
 
    var commentloggridds = new Ext.data.Store({
	//proxy: "",	
	autoLoad: true,
	proxy : new Ext.data.HttpProxy({
			url : unitsUrl
					+ '?action=QueryCommontLog&OrdItem='+orditem,
			method : 'POST'
		}),

        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'patname',
            'prescno',
	    'comdate',
	    'comtime',
	    'comuser',
	    'comresult',
	    'comreason',
	    'comfactor',
	    'comadvice',
	    'comdocadvice',
	    'comactive',
	    'comphnote',
	    'comdocnote',
	    'comactive'
	    
		]),
		
		

    remoteSort: true
});


 
 var commentloggrid = new Ext.grid.GridPanel({
        
        region:'west',
        stripeRows: true,
        width:650,
        height:300,
        autoScroll:true,
	title:"",
        enableHdMenu : false,
        ds: commentloggridds,
        cm: commentloggridcm,
        enableColumnMove : false,
        view: new Ext.ux.grid.BufferView({
		    // custom row height
		    rowHeight: 25,
		    // render rows as they come into viewable area.
		    scrollDelay: false,
		       
		   getRowClass: function(record, index, rowParams, store) {  
		   
		   
			   if (record.data.flag > 0) {
			   
			  

			   return 'x-grid-record-green'; 
			   
			   }
		   
		   }
		    
		    
	    }),
	    
	tbar:[],  
        //bbar: orddetailgridcmPagingToolbar,
        trackMouseOver:'true'
        

        
    });
	
    
  // define window and show it in desktop
  var FindCommentLogWindow = new Ext.Window({
    title: '查看点评日志',
    width: 800,
    height:500,
    minWidth: 400,
    minHeight: 300,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: [ commentloggrid  ]
    //buttons: [,CancelButton]

    });

    FindCommentLogWindow.show();
};