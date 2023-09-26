
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


          ///����ҽ������
	
  var ComBoDocLocDs = new Ext.data.Store({
		        autoLoad: true,

			proxy : new Ext.data.HttpProxy({
			url : unitsUrl
					+ '?action=GetDocLocDs',
			method : 'POST'
		}),
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'DocLocID'},
['DocLocDesc','DocLocID'])
				
	});


  ComBoDocLocDs.on(
	'beforeload',
	function(ds, o){
	
		ds.proxy = new Ext.data.HttpProxy({url:unitsUrl+'?action=GetDocLocDs', method:'GET'});
	
	}
  );

  var DocLocSelecter = new Ext.ux.form.LovCombo({
		fieldLabel:'ҽ������',
		id:'DocLocSelecter',
		name:'DocLocSelecter',
		store : ComBoDocLocDs,
		width:comwidth,
		listWidth : 250,
		emptyText:'ѡ��ҽ������...',
		hideOnSelect : false,
		maxHeight : 300,	
		valueField : 'DocLocID',
		displayField : 'DocLocDesc',
		triggerAction : 'all',
		mode:'local'

				
	});
	
	
 ///����ҩƷ����
	
	var ComBoIncitmDs = new Ext.data.Store({
		//autoLoad: true,
		proxy : new Ext.data.HttpProxy({
			url : unitsUrl,
//					+ '?action=GetIncitmDs&start=0&limit=50&searchItmValue=',

			method : 'POST'
		}),
		//proxy : '',
		reader : new Ext.data.JsonReader({
					totalProperty : "results",
					root : 'rows',
					id : 'rowId'
				}, ['rowId', 'itmcode', 'itmdesc'])

	});
	
	
	
	 var tpl =  new Ext.XTemplate(
	'<table cellpadding=2 cellspacing = 1><tbody>',
	'<tr><th style="font-weight: bold; font-size:15px;">ҩƷ����</th><th style="font-weight: bold; font-size:15px;">����</th><th style="font-weight: bold; font-size:15px;">ID</th></tr>',
	'<tpl for=".">',
	'<tr class="combo-item">',
	'<td style="width:500; font-size:15px;">{itmdesc}</td>',
	'<td style="width:20%; font-size:15px;">{itmcode}</td>',
	'<td style="width:50; font-size:15px;">{rowId}</td>',
	'</tr>',
	'</tpl>', '</tbody></table>');
	

	var IncitmSelecter = new Ext.form.ComboBox({
				id : 'InciSelecter',
				fieldLabel : 'ҩƷ����',
				store : ComBoIncitmDs,
				valueField : 'rowId',
				displayField : 'itmdesc',
				//typeAhead : true,
				pageSize : 50,
				//minChars : 1,
				width:comwidth,
				// heigth : 150,
				autoHeight:true,
				listWidth : 550,
				triggerAction : 'all',
				emptyText : 'ѡ��ҩƷ����...',
				//allowBlank : false,
				name : 'IncitmSelecter',
				selectOnFocus : true,
				forceSelection : true,
				tpl: tpl,
    				itemSelector: 'tr.combo-item',
				listeners : {
				
				        
				        specialKey :function(field,e){
				        
                                        if (e.getKey() == Ext.EventObject.ENTER) {
                                               
                                             	ComBoIncitmDs.proxy = new Ext.data.HttpProxy({
										url : unitsUrl
												+ '?action=GetIncitmDs&searchItmValue='
												+ Ext.getCmp('InciSelecter').getRawValue(),
										method : 'POST'
									})
							ComBoIncitmDs.reload({
										params : {
											start : 0,
											limit : IncitmSelecter.pageSize
										}
									});
                                        
                                                     }					
				                }
				               
			         }

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
                             
                              FindCNTSData("");
                              
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
        
        
       var FindNoButton = new Ext.Button({
             width : 65,
             id:"FindNoButton",
             text: '�������',
             icon:"../scripts/dhcpha/img/multiref.gif",       
             listeners:{   
                          "click":function(){   
                             
                            FindCommentFun();
                              }   
                       } 
             
             
             
             })
                         
            
       var ClearButton = new Ext.Button({
             width : 65,
             id:"ClearButton",
             text: '����',
             listeners:{
                          "click":function(){   
                             
                              ClearWindow();
                              
                              }   
             }
             
             })
             
             
             
             
             
             
             
              var QueryForm = new Ext.FormPanel({
                                labelWidth : 80,
				region : 'north',
				title:'������ͳ�Ʋ�ѯ',
				frame : true,
				height:140,
				tbar:[FindButton,'-',FindNoButton,'-',ExportButton],
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
										items : [   DocLocSelecter  ]
								        }  
								        
								        
								        
								        
				                                 ]
								   
								   
								   
								   
					},{
					
					
							layout : "column",
							items : [{
							                        labelAlign : 'right',
										columnWidth : .26,
										layout : "form",
										items : [  ResultCombo   ]
									}, {
									        labelAlign : 'right',
										columnWidth : .26,
										layout : "form",
										items : [  IncitmSelecter  ]
									    
										
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

       
        {header:'������',dataIndex:'pcntsno',width:100},
        {header:'������',dataIndex:'prescno',width:100},
        {header:'�ǼǺ�',dataIndex:'patno',width:80},
        {header:'����',dataIndex:'patname',width:80},
        {header:'�Ա�',dataIndex:'patsex',width:60},
        {header:'����',dataIndex:'patage',width:60},
        {header:'�ѱ�',dataIndex:'billtype',width:80},
        {header:'���',dataIndex:'diag',width:200},
        {header:'ҽ�����Ҵ���',dataIndex:'orddeptcode',width:80},
        {header:'ҽ������',dataIndex:'orddept',width:80},
        {header:'ҽ������',dataIndex:'doctorcode',width:80},
        {header:'ҽ��',dataIndex:'doctor',width:80},
        {header:'��ҩҩʦ',dataIndex:'pyuser',width:80},
        {header:'��ҩҩʦ',dataIndex:'fyuser',width:80},
        {header:'ҩƷ����',dataIndex:'incidesc',width:180}, 
        {header:'����',dataIndex:'qty',width:80},
        {header:'����',dataIndex:'price',width:80},
        {header:'���',dataIndex:'amt',width:80},
        {header:'�����ܽ��',dataIndex:'prescamt',width:80},
        {header:'����ҩ�ܽ��',dataIndex:'sumantamt',width:80},
        {header:'����ҩ�ܽ��ٷֱ�',dataIndex:'antamtcent',width:80},
        {header:'����ҩ���ܽ��',dataIndex:'sumbasamt',width:80},
        {header:'����ҩ���ܽ��ٷֱ�',dataIndex:'basamtcent',width:80},
        {header:'��λ',dataIndex:'uomdesc',width:80},
        {header:'����',dataIndex:'dosage',width:80},
        {header:'Ƶ��',dataIndex:'freq',width:80},
        {header:'�÷�',dataIndex:'instru',width:80},
        {header:'�Ƴ�',dataIndex:'duration',width:80},
        {header:'��ע',dataIndex:'remark',width:80},
        {header:'colorflag',dataIndex:'colorflag',width:0,hidden:true},
        {header:'����ҩʦ',dataIndex:'username',width:80},
        {header:'���',dataIndex:'curret',width:60},
        {header:'ԭ��',dataIndex:'reason',width:300},
        {header:'ҩʦ����',dataIndex:'phadvice',width:100},
        {header:'ҩʦ��ע',dataIndex:'phnote',width:300},
        {header:'pid',dataIndex:'pid',width:0,hidden:true}
 
       
            
    
    ]);
 
 
    var commentitmgridds = new Ext.data.Store({
	proxy: "",
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'pcntsno',
            'prescno',
	    'patno',
	    'patname',
	    'patsex',
	    'patage',
	    'billtype',
	    'diag',
	    'orddeptcode',
	    'orddept',
	    'doctorcode',
	    'doctor',
	    'curret',
	    'incidesc',
	    'colorflag',
	    'reason',
	    'phadvice',
	    'phnote',
	    'pid',
	    'qty',
	    'price',
	    'amt',
	    'prescamt',
	    'sumantamt',
	    'antamtcent',
	    'sumbasamt',
	    'basamtcent',
	    'uomdesc',
	    'dosage',
	    'freq',
	    'instru',
	    'duration',
	    'remark',
	    'pyuser',
	    'fyuser',
	    'username'
	    
	    
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
	    
        bbar: commentitmgridPagingToolbar,
        trackMouseOver:'true'
        

        
    });  
    
   
   
   ////��ԭ�����
   
   
 function showUrl(data, metadata, record, rowIndex, columnIndex, store)  
 { 
  	var doclocdr = store.getAt(rowIndex).get('locrowid'); //����
  
	sdate=Ext.getCmp("startdt").getRawValue();       
        edate=Ext.getCmp("enddt").getRawValue();
        inci=Ext.getCmp("InciSelecter").getValue(); //ҩƷ
        result=Ext.getCmp("ResultCmb").getValue(); //ҩƷ
                
        QueryStr=sdate+"^"+edate+"^"+doclocdr+"^"+inci+"^"+result;
               
       // var lnk="dhcpha.comment.querybydocloc.csp?QueryStr="+QueryStr ;
        var str2="<a href='http://www.baidu.com'>111</a>"

var str="<a   href ='javascript:alert(111)'>��һ���´���</a >"

        //return "<a href="+lnk+" target='_blank'  >"+data+"</a>";
        return str;
        

      
  
  }  

   
    
 var GroupRow1 = [
                                           {header:'����',align:'center',colspan:2},
   					   {header:'���淶����',align:'center',colspan:4},
   					   {header:'��ҩ���˴���',align:'center',colspan:4},
   					   {header:'��������',align:'center',colspan:4},
   					   {header:'������',align:'center',colspan:2},
   					   {header:'�ܴ���',align:'center',colspan:2}
   			] 
   			
   var GroupRow3 = [
                                           {header:'',align:'center',colspan:7},
   					   {header:'A',align:'center',colspan:1},
   					   {header:'B',align:'center',colspan:1},
   					   {header:'',align:'center',colspan:2}
   			] 
   			
    var GroupRow2 = [
        //{
        //header:'����',
        //dataIndex:'locdesc',
        //renderer:showUrl},
        {header:'����',dataIndex:'locdesc',width:150},
        {header:'����ID',dataIndex:'locrowid',width:0,hidden:true},
        {header:'��������',dataIndex:'reason1',width:75},
        {header:'ռ�������',dataIndex:'centprescn1',width:75},
        {header:'��������',dataIndex:'locrepnum1',width:75},
        {header:'ռ��������',dataIndex:'locrepcent1',width:75},
        {header:'��������',dataIndex:'reason2',width:75},
        {header:'ռ�������',dataIndex:'centprescn2',width:75},
        {header:'��������',dataIndex:'locrepnum2',width:75},
        {header:'ռ��������',dataIndex:'locrepcent2',width:75},
        {header:'��������',dataIndex:'reason3',width:75},
        {header:'ռ�������',dataIndex:'centprescn3',width:75},
        {header:'��������',dataIndex:'locrepnum3',width:75},
        {header:'ռ��������',dataIndex:'locrepcent3',width:75},
        {header:'����������',dataIndex:'locreanum',width:75},
        {header:'����������',dataIndex:'locbedprescnum',width:75},
        {header:'ȫԺ���ƴ�����',dataIndex:'locallprescnum',width:95},  
        {header:'��ȫԺ������',dataIndex:'loccentprescnum',width:85},  
 		{header:'pid',dataIndex:'pid',hidden:true}  

   			]   
    var group = new Ext.ux.grid.ColumnHeaderGroup({
        rows: [GroupRow1]
    });
    

 
    var reasongridds = new Ext.data.Store({
	proxy: "",
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'locdesc',
            'locrowid',
            'reason1',
	    'centprescn1',
	    'locrepnum1',
	    'locrepcent1',
	    'reason2',
	    'centprescn2',
	    'locrepnum2',
	    'locrepcent2',
	    'reason3',
	    'centprescn3',
	    'locrepnum3',
	    'locrepcent3',
	    'locreanum',
	    'locbedprescnum',
	    'locallprescnum',
	    'loccentprescnum',
	    'pid'
	    
		]),
		
		

    remoteSort: true
});



 
 var reasongrid = new Ext.grid.GridPanel({
     
        //width: 1000,
        //height: 400,
        stripeRows: true,
        enableColumnMove : false,
        enableHdMenu : false,
        store: reasongridds,
        columns: GroupRow2,
        view: new Ext.ux.grid.BufferView({
		    // custom row height
		    rowHeight: 25,
		    // render rows as they come into viewable area.
		    scrollDelay: false
			   		    
	    }),
	    
        trackMouseOver:'true',

        plugins: group
        
    });

   
   
   ////
   
   
   
      ////���������� 
 
 var prescgridcm = new Ext.grid.ColumnModel([

       
        {header:'���',dataIndex:'count',width:60},
        {header:'������',dataIndex:'prescno',width:100},
        {header:'�ǼǺ�',dataIndex:'patno',width:80},
        {header:'����',dataIndex:'patname',width:80},
        {header:'�Ա�',dataIndex:'patsex',width:35},
        {header:'��������',dataIndex:'orddate',width:100},
        {header:'����',dataIndex:'patage',width:35},
        {header:'���',dataIndex:'diag',width:150},
        {header:'ҩƷƷ��',dataIndex:'itmnum',width:80},
        {header:'����ҩ',dataIndex:'kjnum',width:80},
        {header:'ע���',dataIndex:'zsnum',width:80},
        {header:'���һ���ҩ��Ʒ����',dataIndex:'bnum',width:80},
        {header:'ҩƷͨ������',dataIndex:'gernum',width:80},
        {header:'�������',dataIndex:'amt',width:100}, 
        {header:'����ҽʦ',dataIndex:'doctor',width:80},
        {header:'��ҩҩʦ',dataIndex:'pyuser',width:80},   
        {header:'��ҩҩʦ',dataIndex:'fyuser',width:80}, 
        {header:'�Ƿ����',dataIndex:'curret',width:60},
        {header:'��������(����)',dataIndex:'reason',width:80},
        {header:'pid',dataIndex:'pid',width:80,hidden:true}

        
    
    ]);
 
 
    var prescgridds = new Ext.data.Store({
	proxy: "",
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'count',
            'prescno',
	    'patno',
	    'patname',
	    'patsex',
	    'patage',
	    'diag',
	    'curret',
	    'doctor',
	    'kjnum',
	    'zsnum',
	    'bnum',
	    'gernum',
	    'amt',
	    'pyuser',
	    'fyuser',
	    'result',
	    'reason',
	    'itmnum',
	    'orddate',
	    'pid'
	    
		]),
		
		

    remoteSort: true
});




	

 var prescgridPagingToolbar = new Ext.PagingToolbar({	
			store:prescgridds,
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

 
 var prescgrid = new Ext.grid.GridPanel({
        
        id:'presctbl',
        stripeRows: true,
        region:'center',
        width:150,
        //height:290,
        autoScroll:true,
	title:"",
        enableHdMenu : false,
        ds: prescgridds,
        cm: prescgridcm,
        enableColumnMove : false,
        view: new Ext.ux.grid.BufferView({
		    // custom row height
		    rowHeight: 25,
		    // render rows as they come into viewable area.
		    scrollDelay: false
		    
		    
	    }),
	    
        bbar: prescgridPagingToolbar,
        trackMouseOver:'true'
        

        
    });  
    
    
     
    
    ///Tabs����
    
    var QueryTabs = new Ext.TabPanel({
	    region: 'center',
	    id:'TblTabPanel',
	    //margins:'3 3 3 0', 
	    activeTab: 0,
	    //defaults:{autoScroll:true},
	    //deferredRender:false,
	     height:260,
	     autoHight:'true',
	    items:[{
	        title: '��������ϸ',
	        id:'1',
	        closable:false,
	        layout:'fit',	    
	        //listeners: {activate: Clearpatinfo},
	        items: commentitmgrid
	
	    },{
	        title: '����������',
	        id:'3',
	        closable:false,
	        layout:'fit',
	        items:[prescgrid]
	    },{
	        title: '��ԭ�����',
	        id:'2',
	        closable:false,
	        layout:'fit',
	        items:[reasongrid]
	    }
	    
	    
	    ],
	    
	      listeners:{ 
                              beforetabchange:function(t,  newTab,  currentTab){ 
                                    
                                          if (currentTab){
                                             
                                          }
                                    }
                                
                      } 
	    
	    
	    
	    
	});
	
	
	/*
	
	,
	    {
	        //title: '������ҩ��ϸ',
	        //id:'4',
	        //closable:false,
	        //layout:'fit',
	        //html: '<iframe id="adult" width=100% height=100% src=dhcpha.comment.querybyadult.csp></iframe>',
		//src: 'dhcpha.comment.querybyadult.csp'
	    }
	
	*/
	
	
    ///��ܶ���
    

      var port = new Ext.Viewport({

				layout : 'border',

				items : [QueryForm,QueryTabs]

			});

      
      
      

    
    


///----------------Events----------------



        //�Ҽ��˵� 
	commentitmgrid.addListener('rowcontextmenu', rightClickFn);
	var rightClick = new Ext.menu.Menu({ 
	    id:'rightClickCont', 
	    items: [ 
	        { 
	            id: 'ExportXls', 
	            handler: ExportNTSData, 
	            text: '����Excel' 
	        }
	    ] 
	}); 

        
        
        prescgrid.addListener('rowcontextmenu', rightClickFn);
	var rightClick = new Ext.menu.Menu({ 
	    id:'rightClickCont', 
	    items: [ 
	        { 
	            id: 'ExportXls', 
	            handler: ExportNTSData, 
	            text: '����Excel' 
	        }
	    ] 
	}); 
        
        
        reasongrid.addListener('rowcontextmenu', rightClickFn);
	var rightClick = new Ext.menu.Menu({ 
	    id:'rightClickCont', 
	    items: [ 
	        { 
	            id: 'ExportXls', 
	            handler: ExportNTSData, 
	            text: '����Excel' 
	        }
	    ] 
	}); 
	
	
		
	function rightClickFn(grid,rowindex,e){ 
	    e.preventDefault(); 
	    rightClick.showAt(e.getXY()); 
        }
        
        
        
        
        


FindCNTSData= function(str)
{

       			KillItm();
                KillTotal();
                KillReaTotal();
                ClearWindow();
                 
                sdate=Ext.getCmp("startdt").getRawValue();       
                edate=Ext.getCmp("enddt").getRawValue();
                doclocdr=Ext.getCmp("DocLocSelecter").getValue();  //����
                inci=Ext.getCmp("InciSelecter").getValue(); //ҩƷ
                result=Ext.getCmp("ResultCmb").getValue(); //ҩƷ
                comno="";  //���Ŵ�
                retflag="" ;���޽��
                if (str!=""){
                   strarr=str.split("^");
                   var sdate=strarr[0];
                   var edate=strarr[1];
                   var comno=strarr[2];
                   var retflag=strarr[3];
                   
                   var tmparr=sdate.split("/")
                   var sdt=tmparr[2]+"/"+tmparr[1]+"/"+tmparr[0];
                   var tmparr=edate.split("/")
                   var edt=tmparr[2]+"/"+tmparr[1]+"/"+tmparr[0];
                   
                   var dt = new Date(sdt);
                   Ext.getCmp("startdt").setValue(dt);
                   
                   var dt = new Date(edt);
                   Ext.getCmp("enddt").setValue(dt);
                }
                
                QueryStr=sdate+"^"+edate+"^"+doclocdr+"^"+inci+"^"+result+"^"+comno;
                
                var p = Ext.getCmp("TblTabPanel").getActiveTab();
                
                
                
                 ///������ϸ
                 
                if (p.id=="1"){
                                
                                waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "ϵͳ���ڴ������ݣ����Ժ�..." ,removeMask: true}); 
	                        waitMask.show();               
                	
                		commentitmgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=FindCNTSData&QueryStr='+QueryStr});
		
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
                
                ///ԭ�����
                
               if (p.id=="2"){
                	

                                waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "ϵͳ���ڴ������ݣ����Ժ�..." ,removeMask: true}); 
	                        waitMask.show(); 
                		reasongridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=FindCNTSDataByRea&QueryStr='+QueryStr});
		
				reasongridds.load({
							
				callback: function(r, options, success){
		 
				         waitMask.hide() ;
				         if (success==false){
				                     Ext.Msg.show({title:'ע��',msg:'��ѯʧ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
				                     }
				          }
				
				});
				
                }
                
                
                
                ///��������
                
               if (p.id=="3"){
               
                                waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "ϵͳ���ڴ������ݣ����Ժ�..." ,removeMask: true}); 
	                        waitMask.show(); 
                		prescgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=FindCNTSDataByPresc&QueryStr='+QueryStr});
		
				prescgridds.load({
					
				params:{start:0, limit:prescgridPagingToolbar.pageSize}, 
				
				callback: function(r, options, success){
		 
				         waitMask.hide() ;
				         if (success==false){
				                     Ext.Msg.show({title:'ע��',msg:'��ѯʧ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
				                     }
				          }
				
				});
				
                }
                
                if (p.id=="4"){
                
                          
			var p = Ext.getCmp("TblTabPanel").getActiveTab();	
			var iframe = p.el.dom.getElementsByTagName("iframe")[0];
                        iframe.src='dhcpha.comment.querybyadult.csp?QueryStr='+QueryStr;
                
                }

		
		


}


function ClearWindow()
{
   commentitmgridds.removeAll();
   reasongridds.removeAll();
   prescgridds.removeAll();
}
 
    
    

    
reasongrid.on('rowdblclick',function(grid,rowIndex,e){


                var selectedRow = reasongridds.data.items[rowIndex];
	        	var doclocdr = selectedRow.data["locrowid"]; //����
	        	sdate=Ext.getCmp("startdt").getRawValue();       
                edate=Ext.getCmp("enddt").getRawValue();
                inci=Ext.getCmp("InciSelecter").getValue(); //ҩƷ
                result=Ext.getCmp("ResultCmb").getValue(); //ҩƷ
        
                QueryStr=sdate+"^"+edate+"^"+doclocdr+"^"+inci+"^"+result
        
	        
                var lnk="dhcpha.comment.querybydocloc.csp?QueryStr="+QueryStr ;
				window.open(lnk,"_blank","height=600,width=1000,menubar=no,status=yes,toolbar=no,resizable=yes") ;

		
		
 });   


 //�򿪵�������
function OpenExpDetailWin(pid)
{
		//var excelUrl = 'dhccpmrunqianreport.csp?reportName=DHCSTCNTSDetailExp.raq&pid='+pid;
		//var NewWin = open(excelUrl, "����Excel", "top=20,left=20,width=930,height=660,scrollbars=1,resizable=yes");
		
		var expwin=new Ext.Window({
			title: '����excel',
			width: Ext.getBody().getViewSize().width,
			height: Ext.getBody().getViewSize().height,
			html: '<iframe id="DHCSTCNTSDetailExp" src="dhccpmrunqianreport.csp?reportName=DHCSTCNTSDetailExp.raq&pid=' + pid + '" frameborder="0" width="100%" height="100%"></iframe>',
			layout: 'fit',
			plain: true,
			modal: true
			}).show();

} 



function OpenExpTotalWin(pid)
{
		//var excelUrl = 'dhccpmrunqianreport.csp?reportName=DHCSTCNTSTotalExp.raq&pid='+pid;
		//var NewWin = open(excelUrl, "����Excel", "top=20,left=20,width=930,height=660,scrollbars=1,resizable=yes");
	
			var expwin=new Ext.Window({
			title: '����excel',
			width: Ext.getBody().getViewSize().width,
			height: Ext.getBody().getViewSize().height,
			html: '<iframe id="DHCSTCNTSDetailExp" src="dhccpmrunqianreport.csp?reportName=DHCSTCNTSTotalExp.raq&pid=' + pid + '" frameborder="0" width="100%" height="100%"></iframe>',
			layout: 'fit',
			plain: true,
			modal: true
			}).show();
	
}

function OpenExpReaTotalWin(pid)
{
		//var excelUrl = 'dhccpmrunqianreport.csp?reportName=DHCSTCNTSReaTotalExp.raq&pid='+pid;
		//var NewWin = open(excelUrl, "����Excel", "top=20,left=20,width=930,height=660,scrollbars=1,resizable=yes");
	
			var expwin=new Ext.Window({
			title: '����excel',
			width: Ext.getBody().getViewSize().width,
			height: Ext.getBody().getViewSize().height,
			html: '<iframe id="DHCSTCNTSDetailExp" src="dhccpmrunqianreport.csp?reportName=DHCSTCNTSReaTotalExp.raq&pid=' + pid + '" frameborder="0" width="100%" height="100%"></iframe>',
			layout: 'fit',
			plain: true,
			modal: true
			}).show();
	
}




//��������
function ExportNTSData()
{

			var p = Ext.getCmp("TblTabPanel").getActiveTab();
                 
            if (p.id=="1"){
                    var rows=commentitmgrid.getStore().getCount() ; 
				    if (rows== 0) { return; }
            	    var pid=commentitmgridds.getAt(0).get("pid") ;
                    OpenExpDetailWin(pid)
                }
             
              
            if (p.id=="3"){
                    var rows=prescgrid.getStore().getCount() ; 
				    if (rows== 0) { return; }
            	    var pid=prescgridds.getAt(0).get("pid") ;
                    OpenExpTotalWin(pid)
                }
                      
		    if (p.id=="2"){
                    var rows=reasongrid.getStore().getCount() ; 
				    if (rows== 0) { return; }
            	    var pid=reasongridds.getAt(0).get("pid") ;
                    OpenExpReaTotalWin(pid)
                }  
		    
}






///ִ�����TMP
function Kill(pid)
{

         Ext.Ajax.request({
	
	         url:unitsUrl+'?action=KillQueryData&pid='+pid ,
		
		 	 scope: this
		
		
		});
}




///�����ϸ
function KillItm()
{
	var totalnum =commentitmgrid.getStore().getCount() ;
	if (totalnum!=0){
	       var pid=commentitmgridds.getAt(0).get("pid") ;
	       Kill(pid);
	   } 
}

///�����������
function KillTotal()
{
         var totalnum =prescgrid.getStore().getCount() ;
         if (totalnum!=0){
	       var pid=prescgridds.getAt(0).get("pid") ;
	       Kill(pid); 
		 } 
}

///���ԭ�����
function KillReaTotal()
{
         var totalnum =reasongrid.getStore().getCount() ;
         if (totalnum!=0){
	       var pid=reasongridds.getAt(0).get("pid") ;
	       Kill(pid); 
		 } 
}


///�����ʱ��¼

document.body.onbeforeunload=function(e){

	            
                KillItm();
                KillTotal();
                KillReaTotal();
                
               
 

}


window.onbeforeunload=function checkLeave(e){
				var evt = e ? e : (window.event ? window.event : null);        //�˷���Ϊ����firefox�еļ���
                
                KillItm();
                KillTotal();
                KillReaTotal();
    
  }






});
                                                                                        