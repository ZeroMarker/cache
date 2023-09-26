
var unitsUrl = 'dhcpha.comment.query.save.csp';
var idTmr="";
var comwidth=120;

Ext.onReady(function() {

     Ext.QuickTips.init();// ������Ϣ��ʾ
	 Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;        
	 Ext.Ajax.timeout = 900000;
             
	 var ResultData=[['���ϸ�','1'],['�����ϸ�','2'],['���н��','4'],['ȫ��','3']];
	 
	 
	 var Resultstore = new Ext.data.SimpleStore({
		fields: ['retdesc', 'retid'],
		data : ResultData
		});

	var ResultCombo = new Ext.form.ComboBox({
		store: Resultstore,
		displayField:'retdesc',
		mode: 'local', 
		width : comwidth,
		id:'ResultCmb',
		emptyText:'',
		valueField : 'retid',
		emptyText:'ѡ��������...',
		fieldLabel: '�������'
	});


	
  var StDateField=new Ext.form.DateField ({
               
                xtype: 'datefield',
                format:'j/m/Y' ,
                fieldLabel: '��ʼ����',
                name: 'startdt',
                id: 'startdt',
                invalidText:'��Ч���ڸ�ʽ,��ȷ��ʽ��:��/��/��,��:15/02/2011',
                width : comwidth,
                value:new Date
            })	
            
            
            
  var EndDateField=new Ext.form.DateField ({
                format:'j/m/Y' ,
                fieldLabel: '��ֹ����',
	        name: 'enddt',
	        id: 'enddt',
	        width : comwidth,
	        value:new Date
            })
            
   var FindButton = new Ext.Button({
             width : 65,
             id:"FindButton",
             text: 'ͳ��',
             icon:"../scripts/dhcpha/img/find.gif",
             listeners:{   
                          "click":function(){   
                             
                              FindCNTSData();
                              
                              }   
                       } 
             
             }) 
             
    var ExportButton = new Ext.Button({
             width : 65,
             id:"ExportButton",
             text: '����Excel',
             icon:"../scripts/dhcpha/img/save.gif",
             listeners:{   
                          "click":function(){   
                             
                              ExportNTSData();
                              
                              }   
                       } 
             
             })   
        
        
     
             
             
              var QueryForm = new Ext.FormPanel({
                                labelWidth : 80,
				region : 'north',
				title:'סԺ������ҩָ��ͳ��',
				frame : true,
				height:140,
				tbar:[FindButton,'-',ExportButton],
				items : [{
							layout : "column",
							items : [{
							                        labelAlign : 'right',
										columnWidth : .26,
										layout : "form",
										items : [   StDateField  ]
									}, {
									        labelAlign : 'right',
										columnWidth : .26,
										layout : "form",
										items : [   EndDateField  ]
									    
										
								        },{
								        
								                labelAlign : 'right',
										columnWidth : .26,
										layout : "form",
										items : [     ]
								        }  
								        
								        
								        
								        
				                                 ]
								   
								   
								   
								   
					},{
					
					
							layout : "column",
							items : [{
							                        labelAlign : 'right',
										columnWidth : .26,
										layout : "form",
										items : [     ]
									}, {
									        labelAlign : 'right',
										columnWidth : .26,
										layout : "form",
										items : [    ]
									    
										
								        },{
								                labelAlign : 'right',
										columnWidth : .26,
										layout : "form",
										items : [   ]	    
										
								        }
								        	
								        
								   ]
					
					    }
					

					
					
					
					]

			});				
			
 



			
			       
    
   ////��ϸtable 
 var nm = new Ext.grid.RowNumberer();   
 var commentitmgridcm = new Ext.grid.ColumnModel([nm,

        {header:'����',dataIndex:'loc',width:120},
        {header:'�˾���ҩƷ����',dataIndex:'drugnum',width:100},
        {header:'�˾�ҩ��',dataIndex:'drugamt',width:100},
        {header:'����ҩ�ٷ���',dataIndex:'antdrug',width:100},
        {header:'ע��ҩ�ٷ���',dataIndex:'zsdrug',width:100},
        {header:'����ҩ��ռ�ٷ���',dataIndex:'basdrug',width:100}

    
    ]);
 
 
    var commentitmgridds = new Ext.data.Store({
	proxy: "",
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
        'loc',
	    'drugnum',
	    'drugamt',
	    'antdrug',
	    'zsdrug',
	    'basdrug'
		]),
		
		

    remoteSort: true
});


 var commentitmgridPagingToolbar = new Ext.PagingToolbar({	
			store:commentitmgridds,
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
		    scrollDelay: false
		    
		    
	    }),
	    
        bbar: commentitmgridPagingToolbar,
        trackMouseOver:'true'
        

        
    });  
    
   
       ///��ܶ���
    

      var port = new Ext.Viewport({

				layout : 'border',

				items : [QueryForm,commentitmgrid]

			});
 
function FindCNTSData()
{
	
		waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "ϵͳ���ڴ������ݣ����Ժ�..." ,removeMask: true}); 
	        waitMask.show();

                ClearWindow();
                 
                sdate=Ext.getCmp("startdt").getRawValue();       
                edate=Ext.getCmp("enddt").getRawValue();
               

                QueryStr=sdate+"^"+edate ;
                
		commentitmgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=FindIPRationalUseData&QueryStr='+QueryStr});

		commentitmgridds.load({
						
		params:{start:0, limit:commentitmgridPagingToolbar.pageSize}, 
		
		callback: function(r, options, success){
 
		         waitMask.hide() ;
		         if (success==false){
		                     Ext.Msg.show({title:'ע��',msg:'��ѯʧ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
		                     }
		          }
		
		});

                
     
		
		


}


function ClearWindow()
{
   commentitmgridds.removeAll();
 
}
 


function ExportNTSData()
{
            sdate=Ext.getCmp("startdt").getRawValue();       
            edate=Ext.getCmp("enddt").getRawValue();
           
            QueryStr=sdate+"^"+edate;
            
			var expwin=new Ext.Window({
			title: '����excel',
			width: Ext.getBody().getViewSize().width,
			height: Ext.getBody().getViewSize().height,
			html: '<iframe id="DHCSTCNTSIPRationalUse" src="dhccpmrunqianreport.csp?reportName=DHCSTCNTSIPRationalUse.raq&QueryStr=' + QueryStr + '" frameborder="0" width="100%" height="100%"></iframe>',
			layout: 'fit',
			plain: true,
			modal: true
			}).show();
	
}











});
                                                                                        