///处方点评主界面JS
///Creator:LiangQiang
///CreatDate:2012-05-20


var unitsUrl = 'dhcpha.comment.main.save.csp';


Ext.onReady(function() {

  Ext.QuickTips.init();// 浮动信息提示
  Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

   ///诊断table 

 
  var diaggridcm = new Ext.grid.ColumnModel({
  
  columns:[
 
        {header:'诊断',dataIndex:'diag',width:800}

        ]
    });
 
 
    var diaggridds = new Ext.data.Store({
	proxy: "",
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
                'diag'
	    
		]),
		
		

    remoteSort: true
});


	
 
 var diaggrid = new Ext.grid.EditorGridPanel({
        height:80,
        //width:700,
        frame:false,
        stripeRows: true,
        id:'diaggridtbl',
        region:'border',
        enableHdMenu : false,
        ds: diaggridds,
        cm: diaggridcm,
        enableColumnMove : false,
	clicksToEdit :1,
        view: new Ext.ux.grid.BufferView({

		    rowHeight: 25,
		    scrollDelay: false
		    
		    
	    }),
	    
	   
        trackMouseOver:'true' 
           
           
        

        
    });
    

    
    
    
    ///医嘱明细数据table
    

  var orddetailgridcm = new Ext.grid.ColumnModel({
  
  columns:[
       
        {header:'药品名称',dataIndex:'incidesc',width:150},
        {header:'数量',dataIndex:'qty',width:40},
        {header:'单位',dataIndex:'uomdesc',width:60},
        {header:'剂量',dataIndex:'dosage',width:60},
        {header:'频次',dataIndex:'freq',width:40},
        {header:'规格',dataIndex:'spec',width:80},
        {header:'用法',dataIndex:'instruc',width:80},
        {header:'用药疗程',dataIndex:'dura',width:60},
        {header:'剂型',dataIndex:'form',width:80},
        {header:'医嘱优先级',dataIndex:'pri',width:80},
        {header:'医生',dataIndex:'doctor',width:60},
        {header:'医嘱开单日期',dataIndex:'orddate',width:120},
        {header:'医嘱备注',dataIndex:'remark',width:60},
        {header:'厂家',dataIndex:'manf',width:150}
            
          ]   
            
    
    });
 
 
    var orddetailgridds = new Ext.data.Store({
	proxy: "",
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'incidesc',
            'qty',
	    'uomdesc',
	    'dosage',
	    'freq',
	    'spec',
	    'instruc',
	    'dura',
	    'form',
	    'pri',
	    'doctor',
	    'orddate',
	    'remark',
	    'manf'
	    
		]),
		
		

    remoteSort: true
});

     
 var orddetailgridcmPagingToolbar = new Ext.PagingToolbar({	
			store:orddetailgridds,
			pageSize:200,
			//显示右下角信息
			displayInfo:true,
			displayMsg:'当前记录 {0} -- {1} 条 共 {2} 条记录',
		        prevText:"上一页",
			nextText:"下一页",
			refreshText:"刷新",
			lastText:"最后页",
			firstText:"第一页",
			beforePageText:"当前页",
			afterPageText:"共{0}页",
    		        emptyMsg: "没有数据"
	});
 
 
 var orddetailgrid = new Ext.grid.GridPanel({
        
        frame:false,
        title:'药品明细',
        stripeRows: true,
        width:650,
        height:250,
        autoScroll:true,
        enableHdMenu : false,
        ds: orddetailgridds,
        cm: orddetailgridcm,
        enableColumnMove : false,
        view: new Ext.ux.grid.BufferView({
		    // custom row height
		    rowHeight: 25,
		    // render rows as they come into viewable area.
		    scrollDelay: false
		    
		    
	    }),
	    
	   
        bbar: orddetailgridcmPagingToolbar,
        trackMouseOver:'true'
        

        
    });
  
    

orddetailgrid.on('afterlayout',function(view,layout){   
  
    //orddetailgrid.setHeight(document.body.clientHeight-tabs.getSize().height-55)
    orddetailgrid.setWidth(diaggrid.getSize().width)
    
},this);
  
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
 
    var orditem="";
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
        title:'点评日志',
        frame:false,
        region:'center',
        stripeRows: true,
        width:650,
        height:300,
        autoScroll:true,
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
	    
        trackMouseOver:'true'
        

        
    });
	
     
     
     commentloggrid.on('afterlayout',function(view,layout){   
  
    		commentloggrid.setWidth(diaggrid.getSize().width)
    
	},this);
    
    
      var centerPanel = new Ext.Panel({
        region: 'center',   
        frame:false,
        items : [diaggrid,orddetailgrid,commentloggrid]
      });
      
      
      var northPanel = new Ext.Panel({
         region: 'north',   
         height:0   
         //title: '处方点评'
         //layout:'fit'
 
     });
     


      var port = new Ext.Viewport({

				layout : 'border',

				items : [centerPanel]

			});


////-----------------Events-----------------///




	


});


