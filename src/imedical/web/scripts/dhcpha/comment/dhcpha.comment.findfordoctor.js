///��ѯfor Doctor
///Creator:LiangQiang
///CreatDate:2013-08-21
///

var unitsUrl = 'dhcpha.comment.main.save.csp';
var waitMask;
var InputStr;

Ext.onReady(function() {

  Ext.QuickTips.init();// ������Ϣ��ʾ

  Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;	
  	   //ˢ��
   var  FindButton = new Ext.Button({
             width : 70,
             id:"FindBtn",
             text: '��ѯ',
             iconCls:"page_find",
             listeners:{
                          "click":function(){   
                             
                                 FindClick();
                              
                              }   
             }
             
             
   })
  
       //��ʼ����
	
  var stdatef=new Ext.form.DateField ({
               
  	            width : 120,
                
                //format:'j/m/Y' ,
                fieldLabel: '��ʼ����',
                name: 'startdt',
                id: 'startdt',
                //invalidText:'��Ч���ڸ�ʽ,��ȷ��ʽ��:��/��/��,��:15/02/2011',
                value:new Date
            })	
            
            
            
   var enddatef=new Ext.form.DateField ({
  	            width : 120,
                //format:'j/m/Y' ,
                fieldLabel: '��ֹ����',
	        name: 'enddt',
	        id: 'enddt',
	        //invalidText:'��Ч���ڸ�ʽ,��ȷ��ʽ��:��/��/��,��:15/02/2011',
	        value:new Date
            })
            
    
    
   var DocAdviceField=new Ext.form.TextArea({
	        //autoScroll:true,
	        width : 450,
	        height:120,       
	        id:"DocAdviceArea", 
	        fieldLabel:"˵��" 
        }) 
        
                
   	   //�ύ
   var  OkButton = new Ext.Button({
             width : 70,
             id:"OkBtn",
             text: '����',
             icon:"../scripts/dhcpha/img/accept.png",
             listeners:{
                          "click":function(){   
                             
                                 OkClick();
                              
                              }   
             }
             
             
   })
   
     //���ܰ�ť add by myq 20170613
   var  AcceptButton = new Ext.Button({
             width : 70,
             id:"AcceptBtn",
             text: '����',
             icon:"../scripts/dhcpha/img/accept.png",
             listeners:{
                          "click":function(){   
                             
                                 AcceptClick();
                              
                              }   
             }
             
             
   })

		
	//���Ҳ����б�ؼ�
	
    var ordlistst = new Ext.data.Store({
	    proxy: "",
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	        }, [
	            'orddate',
	            'inciDesc',
	            'qty',
	            'uomdesc',
	            'dosage',
	            'doseuom',
	            'instru',
	            'freq',
	            'duration',
	            'spec',
	            'priorty',
	            'doctor',
	            'remark',
	            'oeori'
			]),
	    // turn on remote sorting
	    remoteSort: true
	});

	  var ordlistcm = new Ext.grid.ColumnModel([
	  
	        {header:'ҽ������',dataIndex:'orddate',width: 100,menuDisabled :'false'},
	        {header:'ҽ������',dataIndex:'inciDesc',width: 160,menuDisabled :'false'},
	        {header:'����',dataIndex:'qty',width: 60,menuDisabled :'false'},
	        {header:'��λ',dataIndex:'uomdesc',width: 60,menuDisabled :'false'},
	        {header:'����',dataIndex:'dosage',width: 60,menuDisabled :'false'},
	        {header:'������λ',dataIndex:'doseuom',width: 60,menuDisabled :'false'},
	        {header:'�÷�',dataIndex:'instru',width: 60,menuDisabled :'false'},
	        {header:'Ƶ��',dataIndex:'freq',width: 60,menuDisabled :'false'},
	        {header:'�Ƴ�',dataIndex:'duration',width: 60,menuDisabled :'false'},
	        {header:'���',dataIndex:'spec',width: 60,menuDisabled :'false'},
	        {header:'���ȼ�',dataIndex:'priorty',width: 60,menuDisabled :'false'},
	        {header:'ҽ��',dataIndex:'doctor',width: 60,menuDisabled :'false'},
	        {header:'��ע',dataIndex:'remark',width: 60,menuDisabled :'false'},
	        {header:'oeori',dataIndex:'oeori',width: 60,menuDisabled :'false',hidden:true}
	        
	       
	       ]);
	    
	 var ordlistgridPagingToolbar = new Ext.PagingToolbar({	
				store:ordlistst,
				pageSize:200,
				//��ʾ���½���Ϣ
				displayInfo:true,
				displayMsg:'��ǰ��¼ {0} -- {1} �� �� {2} ����¼',
			  prevText:"��һҳ",
				nextText:"��һҳ",
				refreshText:"ˢ��",
				lastText:"���ҳ",
				firstText:"��һҳ",
				beforePageText:"��ǰҳ",
				afterPageText:"��{0}ҳ",
	    	emptyMsg: "û������"
		});
	  
	  var ordlistgrid = new Ext.grid.GridPanel({
	        id:'ordlisttbl',
	        enableColumnMove : false,
	        trackMouseOver: true,
	        stripeRows: true,
	        ds: ordlistst,
	        cm: ordlistcm,
	        bbar: ordlistgridPagingToolbar,
	        tbar:[FindButton],
	        trackMouseOver:'true'
	    });
	
	    
		///�����б�grid �������¼�

	    ordlistgrid.on('rowclick',function(grid,rowIndex,e){
	
	           var selectedRow = ordlistst.data.items[rowIndex];
		       var oeori = selectedRow.data["oeori"];
               detailgridds.removeAll();
               Ext.getCmp("DocAdviceArea").setValue('');
			   FindDetailData(oeori);
			   
	    }); 
	    

  var detailgridcm = new Ext.grid.ColumnModel([

       
        {header:'���',dataIndex:'comgrpno',width:40},
        {header:'����ԭ��',dataIndex:'comreason',width:250},
        {header:'��������',dataIndex:'comdate',width:80},
        {header:'����ʱ��',dataIndex:'comtime',width:60},
        {header:'������',dataIndex:'comuser',width:60},
        {header:'�������',dataIndex:'comresult',width:60},       
        {header:'���ϸ�ʾֵ',dataIndex:'comfactor',width:80,hidden:true},
        {header:'ҩʦ����',dataIndex:'comadvice',width:150},
        {header:'ҽ������',dataIndex:'comdocadvice',width:60,hidden:true},
        {header:'ҩʦ��ע',dataIndex:'comphnote',width:60},
        {header:'ҽ����ע',dataIndex:'comdocnote',width:450},
        {header:'��Ч',dataIndex:'comactive',width:60},
        {header:'rowid',dataIndex:'comlogrowid',width:40,hidden:true}
        
    
        

    
       ]);
 
 
    var detailgridds = new Ext.data.Store({
		    proxy: "",
		  //proxy: unitsUrl + '?action=GetDataForDoctor' ,
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [

            'comgrpno',
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
				    'comactive',
				    'comlogrowid'
	    
		]),
		
		

    remoteSort: true
});

     
 var  detailgridPagingToolbar = new Ext.PagingToolbar({	
			store:detailgridds,
			pageSize:200,
			//��ʾ���½���Ϣ
			displayInfo:true,
			displayMsg:'��ǰ��¼ {0} -- {1} �� �� {2} ����¼',
		        prevText:"��һҳ",
			nextText:"��һҳ",
			refreshText:"ˢ��",
			lastText:"���ҳ",
			firstText:"��һҳ",
			beforePageText:"��ǰҳ",
			afterPageText:"��{0}ҳ",
    		        emptyMsg: "û������"
	});
 
 
 var detailgrid = new Ext.grid.GridPanel({
        
        stripeRows: true,
        region:'center',
        margins:'0 0 3 3', 
        autoScroll:true,
        id:'orddetailtbl',
        enableHdMenu : false,
        ds: detailgridds,
        cm: detailgridcm,
        enableColumnMove : false,
        tbar:[AcceptButton,"-",OkButton,"-",'<font color="red">�����·���д����ԭ��֮����"����"��ť�������ߣ�</font>'],
        bbar: detailgridPagingToolbar,
        clicksToEdit: 1,
        //plugins: PackFlagChkColumn,
        trackMouseOver:'true',
		listeners : {
		     'afteredit' : function(e) {
		      //alert(e.record.data.packflag)
		      //alert(e.getTarget())
		     	//alert(e.field)
		     	

		     }
		}


        

        
    });
	

	

   
     var datePanel = new Ext.Panel({
         frame : true,
         labelWidth:80,
         buttonAlign:'center',
         items : [{
					layout : "column",
					items : [{
					            labelAlign : 'right',
								columnWidth : .3,
								layout : "form",
								items : [ stdatef   ]
							 },{
					            labelAlign : 'right',
								columnWidth : .3,
								layout : "form",
								items : [ enddatef   ]
							 } ]
	   
								   
					}]

      
   })
    

         
     var westPanel = new Ext.Panel({  
         title: '��������ҽ����ѯ',
         region:'west',
         collapsible: true,
         margins:'0 3 0 0',
         width:850,
         frame : true,
         layout:{  
	        type:'vbox', 
	        align: 'stretch',  
	        pack: 'start'  
         },
	 items: [{         
	 	  flex: 1,
	 	  layout:'fit',
	 	  items:[datePanel]  
	 	 },{   
	 	  flex: 12 ,
	 	  layout:'fit',
	 	  items:[ordlistgrid]    
	       }]  
     });   
   
    ////
    
     var centerPanel = new Ext.Panel({
        id:'centerform',
	    region: 'center',
	    margins:'3 3 0 3', 
	    frame : false,
		layout:{  
		        type:'vbox', 
		        align: 'stretch',  
		        pack: 'start'  
		}, 
		items: [{           
         	  flex: 3,
         	  layout:'border',
         	  items:[detailgrid]  
         	 },{   
	 	  flex: 2 ,
	 	  layout:'fit',
	 	  tbar:['<font color="red">����ԭ��¼���</font>'],
	 	  items:[DocAdviceField]    
	       }]

	    
	});
	
  

      var port = new Ext.Viewport({

				layout : 'border',
				items : [westPanel,centerPanel]

			});
			
  ///////  Event      ///////////////////////

 

/// ���ݴ����Ų鿴ҽ����ϸ

function FindClick()  
{
	  
    var sdate=Ext.getCmp("startdt").getRawValue().toString();
	  var edate=Ext.getCmp("enddt").getRawValue().toString();
    var user=session['LOGON.USERID'] ;   
    var input=sdate+"^"+edate+"^"+user ;  
    ordlistst.removeAll();
    detailgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=GetLogForDoctor' });
    detailgridds.load({params:{start:0,limit:0,input:''}})
    detailgridds.removeAll();
    
    
	Ext.getCmp("DocAdviceArea").setValue('');
		ordlistst.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=GetDataForDoctor&input='+input });		
		ordlistst.load({
		params:{start:0, limit:ordlistgridPagingToolbar.pageSize},
		callback: function(r, options, success){
 
		         
		         
		         if (success==false){
		                     Ext.Msg.show({title:'ע��',msg:'��ѯʧ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
		                     }
		                      
		          }
		       
		         
		
		});
		
				
		
}


function FindDetailData(oeori)
{   
    var input=oeori ;  
    detailgridds.removeAll();
    
		detailgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=GetLogForDoctor&input='+input });		
		detailgridds.load({
		params:{start:0, limit:detailgridPagingToolbar.pageSize},
		callback: function(r, options, success){
 
		         
		         
		         if (success==false){
		                     Ext.Msg.show({title:'ע��',msg:'��ѯʧ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
		                     }
		                      
		          }
		       
		         
		
		});
		
}

function OkClick()
{
	
	   var row = Ext.getCmp("orddetailtbl").getSelectionModel().getSelections();
	    

     if (!(row)){
           Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("��ʾ", "δѡ��Ҫ���ߵĵ���������ԭ���¼!");
           return;
     }
     if (row==0){
           Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("��ʾ", "δѡ��Ҫ���ߵĵ���������ԭ���¼!");
           return;
     }
     
     var comlogrowid = row[0].data.comlogrowid;
     if (comlogrowid==""){
     	     Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("��ʾ", "δѡ��Ҫ���ߵĵ���������ԭ���¼!");
           return;
     }

	 var comactive = row[0].data.comactive;
     if (comactive!="Y"){
     	   Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("��ʾ", "��ѡ����Ч��ԭ���¼!");
           return;
     }
     
     
    var docnote=Ext.getCmp("DocAdviceArea").getValue();  //��ע
	  
	  if (docnote==""){
	  	Ext.Msg.show({title:'��ʾ',msg:'�����·���д����ԭ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	  	return;
	  }
	  
	  
	  var input=comlogrowid+"^"+docnote;
	//alert("input:"+input)
  	Ext.Ajax.request({

	  url:unitsUrl+'?action=SaveDocAdvice&input='+encodeURI(input) ,
	
		waitMsg:'������...',
		failure: function(result, request) {
			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {

			var jsonData = Ext.util.JSON.decode( result.responseText );
			  		
			//alert(jsonData.retvalue)
			//alert(jsonData.retinfo)	
			
			if (jsonData.retvalue==0){


			  Ext.Msg.show({title:'��ʾ',msg:'���ύ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			  detailgridds.reload() ;
			  if(top && top.HideExecMsgWin) {
				top.HideExecMsgWin();
			  } 
			}else{
			
			  msgtxt=jsonData.retinfo;

			  Ext.Msg.show({title:'��ʾ',msg:msgtxt,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}			  	 
	  		
	  		

		},
		
			scope: this
		});
		
}

function AcceptClick()
{
	
	   var row = Ext.getCmp("orddetailtbl").getSelectionModel().getSelections();
	    

     if (!(row)){
           Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("��ʾ", "δѡ��Ҫ���ܵĵ���������ԭ���¼!");
           return;
     }
     if (row==0){
           Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("��ʾ", "δѡ��Ҫ���ܵĵ���������ԭ���¼!");
           return;
     }
     
     var comlogrowid = row[0].data.comlogrowid;
     if (comlogrowid==""){
     	     Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("��ʾ", "δѡ��Ҫ���ܵĵ���������ԭ���¼!");
           return;
     }

	 var comactive = row[0].data.comactive;
     if (comactive!="Y"){
     	   Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("��ʾ", "��ѡ����Ч��ԭ���¼!");
           return;
     }
     
     
    var docnote="Accept";  //��ע
	  
	  
	  var input=comlogrowid+"^"+docnote;

  	Ext.Ajax.request({

	  url:unitsUrl+'?action=SaveDocAdvice&input='+encodeURI(input) ,
	
		waitMsg:'������...',
		failure: function(result, request) {
			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {

			var jsonData = Ext.util.JSON.decode( result.responseText );
			  		
			//alert(jsonData.retvalue)
			//alert(jsonData.retinfo)	
			
			if (jsonData.retvalue==0){


			  Ext.Msg.show({title:'��ʾ',msg:'���ύ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			  detailgridds.reload() ;
			  if(top && top.HideExecMsgWin) {
				top.HideExecMsgWin();
			  } 
			  
			}else{
			
			  msgtxt=jsonData.retinfo;

			  Ext.Msg.show({title:'��ʾ',msg:msgtxt,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}			  	 
	  		
	  		

		},
		
			scope: this
		});
		
}

	FindClick();
});