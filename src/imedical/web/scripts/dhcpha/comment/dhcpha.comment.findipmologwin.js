
var unitsUrl = 'dhcpha.comment.outmonitor.save.csp';

FindItmLog = function(orditm) {
	
   
   Ext.QuickTips.init();

   Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
   var CancelButton = new Ext.Button({
         width : 65,
         id:"CancelBtn",
         text: '����',
         icon:"../scripts/dhcpha/img/update.gif",
         listeners:{
                      "click":function(){   
                         
                          CancelBtnClick();
                          
                          }   
         }
         
         
         })  
 
   var Ipitmloggridcm = new Ext.grid.ColumnModel({
  
   columns:[
       
        {header:'�������',dataIndex:'auditdate',width:80},
        {header:'����ʱ��',dataIndex:'audittime',width:60},
        {header:'�����',dataIndex:'audituser',width:60},
        {header:'��˽��',dataIndex:'result',width:60},       
        {header:'���ϸ�ʾֵ',dataIndex:'factor',width:80},
        {header:'ҩʦ����',dataIndex:'advice',width:150},
        {header:'ҽ������',dataIndex:'docadvice',width:60},
        {header:'ҩʦ��ע',dataIndex:'phnote',width:60},
        {header:'ҽ����ע',dataIndex:'docnote',width:60},
        {header:'rowid',dataIndex:'rowid',width:60}
          ]   
            
    
    });
 
 
    var Ipitmloggridds = new Ext.data.Store({
	    autoLoad: true,
		proxy : new Ext.data.HttpProxy({
				url : unitsUrl
						+ '?action=GetIPOrdAuditLog&OrdItm='+orditm,
				method : 'POST'
			}),
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
  
                    'auditdate',
		    'audittime',
		    'audituser',
		    'result',
		    'factor',
		    'advice',
		    'docadvice',
		    'phnote',
		    'docnote',
		    'rowid'
	    
		]),
		
		

    	remoteSort: true
});


 
 var Ipitmloggrid = new Ext.grid.GridPanel({
        
        id:'Ipitmlogtbl', 
        stripeRows: true,
        region:'center',
        margins:'0 0 0 0',
        autoScroll:true,
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
	    
        trackMouseOver:'true',
        tbar:[CancelButton]
        

        
    });
    
    


  //��ϸGrid

   var Ipmologitmgridcm = new Ext.grid.ColumnModel({
  
   columns:[
       
        {header:'���',dataIndex:'grpno',width:40},
        {header:'ԭ���б�',dataIndex:'itmdesc',width:250}
        
          ]   
            
    
    });
 
 
    var Ipmologitmgridds = new Ext.data.Store({
		proxy :'',
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'grpno',
            'itmdesc'
	    
		]),
		
		

    	remoteSort: true
});


 
 var Ipmologitmgrid = new Ext.grid.GridPanel({
        
        id:'Ipmologitmtbl', 
        stripeRows: true,
        region:'center',
        margins:'0 0 0 0',
        autoScroll:true,
	title:"�����б�",
        enableHdMenu : false,
        ds: Ipmologitmgridds,
        cm: Ipmologitmgridcm,
        enableColumnMove : false,
        view: new Ext.ux.grid.BufferView({
		    // custom row height
		    rowHeight: 25,
		    // render rows as they come into viewable area.
		    scrollDelay: false
		    
		    
	    }),
	    
        trackMouseOver:'true'
        

        
    });
    
  	Ipitmloggrid.on('rowclick',function(grid,rowIndex,e){
	
	
	   
	        var selectedRow = Ipitmloggridds.data.items[rowIndex];
			var rowid = selectedRow.data["rowid"];
	    
	        Ipmologitmgridds.removeAll();
			Ipmologitmgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=GetIPOrdAuditItmLog&PHOMDR='+rowid });		
			Ipmologitmgridds.load({
			callback: function(r, options, success){
	 
			         
			         
			         if (success==false){
			                     Ext.Msg.show({title:'ע��',msg:'��ѯʧ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
			                     }
			          }
			         
			
			});
	
	 })
  
    
    
  // define window and show it in desktop
  var FindIPItmLogWindow = new Ext.Window({
    title: '�����־�б�',
    width: 1000,
    height:600,
    minWidth: 400,
    minHeight: 300,
    layout: 'border',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    layout:{  
	        type:'vbox', 
	        align: 'stretch',  
	        pack: 'start'  
	 }, 
    items: [{         
         	  flex: 1,
         	  layout:'border',
         	  items:[Ipitmloggrid]  
         	 },{   
         	  flex: 1 ,
         	  layout:'border',
         	  items:[Ipmologitmgrid]    
               }]

    });

    FindIPItmLogWindow.show();




///----------------Events----------------

 function CancelBtnClick()
 {
	    	var totalnum =Ipitmloggrid.getStore().getCount() ;
			if (totalnum==0){
			    return;
			 }
		      
		    var rowid=Ipitmloggridds.getAt(0).get("rowid") ;
	
	        var User=session['LOGON.USERID'] ;
	        var Input=User+"^"+rowid;

			
			Ext.Ajax.request({
		
		        url:unitsUrl+'?action=CancelPhOrdAudit&Input='+Input ,
				failure: function(result, request) {
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			    },
				success: function(result, request) {
		            
					var jsonData = Ext.util.JSON.decode( result.responseText );
					  		
					if (jsonData.retvalue==0){
		                Refresh(orditm);	
					  
					}else{
					    msgtxt=jsonData.retinfo;
		
					    Ext.Msg.show({title:'��ʾ',msg:msgtxt,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					}			  	 
		  		
		  		
		
			},
			
				scope: this
			});
	
	
 }
 
  function Refresh(orditm)
  {	        
            Ipitmloggridds.removeAll();
			Ipitmloggridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=GetIPOrdAuditLog&OrdItm='+orditm});		
			Ipitmloggridds.load({
			callback: function(r, options, success){
			         if (success==false){
			                     Ext.Msg.show({title:'ע��',msg:'��ѯʧ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
			                     }
			          }
			         
			
			});
  	
  }

};