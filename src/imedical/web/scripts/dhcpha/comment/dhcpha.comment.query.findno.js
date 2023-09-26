

FindCommentFun = function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

   var pageunitsUrl='dhcpha.comment.main.save.csp';
	
   var FindCommentQueryButton = new Ext.Button({
             width : 55,
             id:"FindCommentQueryBtn",
             text: '��ѯ',
             listeners:{   
                          "click":function(){  
              
                           FindCommentNo();
                       
                           
                              }   
                       } 
             
             })		
	

	
	
    var FindCommentOKButton = new Ext.Button({
             width : 55,
             id:"FindCommentOKBtn",
             text: 'ȷ��',
             listeners:{   
                          "click":function(){  
                          //Ext.getCmp("txt_name").setValue("1111") 
                          

                          
                               FindMainOrdData();
                              
                           
                              }   
                       } 
             
             })	
             
             
     var FindCommentDelButton = new Ext.Button({
             width : 55,
             id:"FindCommentDelBtn",
             text: 'ɾ��',
             listeners:{   
                          "click":function(){  

                           DelCommnetData();
                         
                           
                              }   
                       } 
             
             })	
	
  	
	
      var FindComStDateField=new Ext.form.DateField ({
               
                xtype: 'datefield',
                //format:'j/m/Y' ,
                fieldLabel: '��ʼ����',
                name: 'FindComStDate',
                id: 'FindComStDate',
                //invalidText:'��Ч���ڸ�ʽ,��ȷ��ʽ��:��/��/��,��:15/02/2011',
                width : 95,
                value:new Date
            })	
            
            
            
        var FindComEndDateField=new Ext.form.DateField ({
                //format:'j/m/Y' ,
                fieldLabel: '��ֹ����',
	        name: 'FindComEndDate',
	        id: 'FindComEndDate',
	        width : 95,
	        value:new Date
            })
	
 
	 var ResultData=[['���н��','1'],['���޽��','2'],['������','3'],['��������','4']];
	 
	 
	 var Resultstore = new Ext.data.SimpleStore({
		fields: ['retdesc', 'retid'],
		data : ResultData
		});

	var ResultCombo = new Ext.form.ComboBox({
		store: Resultstore,
		displayField:'retdesc',
		mode: 'local', 
		width : 95,
		emptyText:'',
		id:'ResultComb',
		valueField : 'retid'
	});
	
	
	
	 ///������ʽ
	
	 var ComBoWayDs = new Ext.data.Store({
		autoLoad: true,
		proxy : new Ext.data.HttpProxy({
			url : pageunitsUrl
					+ '?action=QueryActiveWayDs',
			method : 'POST'
		}),
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'wayrowid'},['waydesc','wayrowid'])
				
	});
	

	var ComBoWay = new Ext.form.ComboBox({
		store: ComBoWayDs,
		displayField:'waydesc',
		mode: 'local', 
		width : 95,
		id:'waycomb',
		emptyText:'',
		listWidth : 200,
		valueField : 'wayrowid',
		emptyText:'ѡ��ʽ...',
		fieldLabel: '������ʽ'
	}); 


  var sm = new Ext.grid.CheckboxSelectionModel(); 
   
  var commentgridcm = new Ext.grid.ColumnModel([sm,

        {header:'����',dataIndex:'comno',width:100},
        {header:'����',dataIndex:'comdate',width:80},
        {header:'ʱ��',dataIndex:'comtime',width:60},
        {header:'�Ƶ���',dataIndex:'comcreator',width:60},
        {header:'����',dataIndex:'comtype',width:60},
        {header:'��ʽ',dataIndex:'comway',width:90},
        {header:'��ѯ����',dataIndex:'comtext',width:300},
        {header:'rowid',dataIndex:'comrowid',width:40}   
       
            
    
    ]);
 
 
    var commentgridds = new Ext.data.Store({
	proxy: "",
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'comno',
            'comdate',
	    'comtime',
	    'comcreator',
	    'comtype',
	    'comway',
	    'comtext',
	    'comrowid'
	    
		]),
		
		

    remoteSort: true
});


 
 var commentgrid = new Ext.grid.GridPanel({
        
        id:'commentgridtbl', 
        stripeRows: true,
        region:'center',
        width:150,
        height:380,
        autoScroll:true,
	title:"",
        enableHdMenu : false,
        ds: commentgridds,
        cm: commentgridcm,
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
	    
	tbar:['��ʼ����:',FindComStDateField,"-",'��ֹ����:',FindComEndDateField,'-','������ʽ','-',ComBoWay,'���','-',ResultCombo,FindCommentQueryButton,"-",FindCommentOKButton],  
        //bbar: orddetailgridcmPagingToolbar,
        trackMouseOver:'true'
        

        
    });
    
    
   ////��ϸtable 
    
 var commentitmgridcm = new Ext.grid.ColumnModel({
  
  columns:[
       
        {header:'��ϸ����',dataIndex:'comno1',width:100},
        {header:'����',dataIndex:'comdate1',width:80},
        {header:'ʱ��',dataIndex:'comtime1',width:60},
        {header:'�Ƶ���',dataIndex:'comcreator1',width:60},
        {header:'����',dataIndex:'comtype1',width:60},
        {header:'��ѯ����',dataIndex:'comtext1',width:300},
        {header:'rowid',dataIndex:'comrowid1',width:40}   
          ]   
            
    
    });
 
 
    var commentitmgridds = new Ext.data.Store({
	proxy: "",
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'comno1',
            'comdate1',
	    'comtime1',
	    'comcreator1',
	    'comtype1',
	    'comtex1t',
	    'comrowid1'
	    
		]),
		
		

    remoteSort: true
});




 
 var commentitmgrid = new Ext.grid.GridPanel({
        
        id:'commentgriditmtbl',
        stripeRows: true,
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
		   
		   
			   if (record.data.flag > 0) {
			   
			  

			   return 'x-grid-record-green'; 
			   
			   }
		   
		   }
		    
		    
	    }),
	    

        trackMouseOver:'true'
        

        
    });   
    
    
	

    
  // define window and show it in desktop
  var FindCommentWindow = new Ext.Window({
    title: '���ҵ�����',
    width: 800,
    height:450,
    minWidth: 400,
    minHeight: 300,
    layout: 'border',
    plain:true,
    //modal:true,
    bodyStyle:'padding:5px;',
    items:  [  commentgrid]
   //commentitmgrid

    });

    FindCommentWindow.show();




///----------------Events----------------




///��ѯĳ��ʱ���ڵĵ�����

function FindCommentNo()
{
                commentgridds.removeAll();  
                sdate=Ext.getCmp("FindComStDate").getRawValue();       
                edate=Ext.getCmp("FindComEndDate").getRawValue();
                findflag="1" //����
                way=Ext.getCmp("waycomb").getValue();     
                parstr=way  //������ѯ����
                
		commentgridds.proxy = new Ext.data.HttpProxy({url: pageunitsUrl + '?action=FindCommentNo&StDate='+sdate+'&EndDate='+edate+'&ParStr='+parstr+'&FindFlag='+findflag});
		
		commentgridds.load({
		
		callback: function(r, options, success){
 
		         
		         if (success==false){
		                     Ext.Msg.show({title:'ע��',msg:'��ѯʧ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
		                     }
		          }
		
		});
}


///ѡȡ������,��������������


function FindMainOrdData()
{

                               var rows = Ext.getCmp("commentgridtbl").getSelectionModel().getSelections();   //getCmp("gridid")   

			       if (rows.length == 0) {  
				      
				      Ext.Msg.show({title:'��ʾ',msg:'δѡ�м�¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				      return;  
			       }  
			        
			           var nostr="";
			           for (var i = 0; i < rows.length; i++) {
				            
				            var row = rows[i];
				            var comno= row.data.comno;
				            if (nostr==""){
				               nostr=comno;
				            }
				            else{
				               nostr=nostr+","+comno;
				            }
				           
				        }
                                
                                 var sdate=Ext.getCmp("FindComStDate").getRawValue();       
                                 var edate=Ext.getCmp("FindComEndDate").getRawValue();
                                 var retflag=Ext.getCmp("ResultComb").getValue();
                                 var str=sdate+"^"+edate+"^"+nostr+"^"+retflag;
                                 
                
				 FindCNTSData(str);
			    
                               
                                 FindCommentWindow.close();

}


///ɾ��������

function  DelCommnetData()
    {
	   Ext.MessageBox.confirm('ע��', 'ȷ��Ҫɾ���� ? ',ShowDelResult);
	
    }

///ɾ��ȷ�϶���
function  ShowDelResult(btn)
 {
               if (btn=="no"){ return ;}
                                                     
	       var row = Ext.getCmp("commentgridtbl").getSelectionModel().getSelections();   //getCmp("gridid")   
	
	       if (row.length == 0) {  
		      
		      Ext.Msg.show({title:'��ʾ',msg:'δѡ�м�¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		      return;  
	       }  
	
	       var commontno = row[0].data.comno;
	       
	       ///���ݿ⽻��ɾ��
	    
		Ext.Ajax.request({
	
	        url:pageunitsUrl+'?action=DelCommentNo&CommontNo='+commontno,
	
		waitMsg:'ɾ����...',
		failure: function(result, request) {
			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
	  	        if (jsonData.success==0) {
	  		       FindCommentNo();
	  		}
	  		else{
	  		       Ext.Msg.alert("��ʾ", "ɾ��ʧ��!����ֵ: "+jsonData.success);
	  		    
	  		}
		},
		
			scope: this
		});
		  
    }
          
          
 
    
    
    
    




};