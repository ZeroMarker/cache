
var unitsUrl = 'dhcpha.comment.main.save.csp';

FindItmLog = function(orditm,adm,pcntsitm) {
	

   Ext.QuickTips.init();

   Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
 
   var Ipitmloggridcm = new Ext.grid.ColumnModel({
  
   columns:[
       
        {header:'组号',dataIndex:'comgrpno',width:40},
        {header:'药品名称',dataIndex:'incidesc',hidden:true},
        {header:'点评原因',dataIndex:'comreason',width:250},
        {header:'点评日期',dataIndex:'comdate',width:80},
        {header:'点评时间',dataIndex:'comtime',width:60},
        {header:'点评人',dataIndex:'comuser',width:60},
        {header:'点评结果',dataIndex:'comresult',width:60},       
        {header:'不合格警示值',dataIndex:'comfactor',width:80},
        {header:'药师建议',dataIndex:'comadvice',width:150},
        {header:'医生反馈',dataIndex:'comdocadvice',width:60,hidden:true},
        {header:'药师备注',dataIndex:'comphnote',width:60},
        {header:'医生备注',dataIndex:'comdocnote',width:60},
        {header:'有效状态',dataIndex:'comactive',width:40}
        
          ]   
            
    
    });
 
 
    var Ipitmloggridds = new Ext.data.Store({
	    autoLoad: true,
		proxy : new Ext.data.HttpProxy({
				url : unitsUrl
						+ '?action=GetIPCommentLog&OrdItm='+orditm+"&Adm="+adm+"&Pcntsitm="+pcntsitm,
				method : 'POST'
			}),
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'comgrpno',
            'incidesc',
            'comreason',
            'comdate',
		    'comtime',
		    'comuser',
		    'comresult',
		    'comfactor',
		    'comadvice',
		    'comdocadvice',
		    'comphnote',
		    'comdocnote',
		    'comactive'
	    
		]),
		
		

    	remoteSort: true
});


 
 var Ipitmloggrid = new Ext.grid.GridPanel({
        
        id:'Ipitmlogtbl', 
        stripeRows: true,
        region:'center',
        width:150,
        height:600,
        autoScroll:true,
		title:"",
        enableHdMenu : false,
        ds: Ipitmloggridds,
        cm: Ipitmloggridcm,
        enableColumnMove : false,
        view: new Ext.ux.grid.BufferView({
		    // custom row height
		    rowHeight: 25,
		    // render rows as they come into viewable area.
		    scrollDelay: false
		    
		    
	    }),
	    
        trackMouseOver:'true'
        

        
    });

    
  // define window and show it in desktop
  var FindIPItmLogWindow = new Ext.Window({
    title: '点评日志列表',
    width: 1000,
    height:600,
    minWidth: 400,
    minHeight: 300,
    layout: 'border',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    items:  [  Ipitmloggrid ]


    });

    FindIPItmLogWindow.show();




///----------------Events----------------


/*
function FindIPLogData(orditm)  
{
            
        commentloggridds.removeAll();
		commentloggridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=QueryCommontLog&OrdItem='+orditem });		
		commentloggridds.load({
		callback: function(r, options, success){
 
		         
		         
		         if (success==false){
		                     Ext.Msg.show({title:'注意',msg:'查询失败 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
		                     }
		          }
		         
		
		});
		
				
		
} 

  */  
    




};