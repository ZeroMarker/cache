///������������������������JS
///Creator:MYQ
///CreatDate:2013-11-28


var unitsUrl = 'dhcpha.comment.main.save.csp';
var comwidth=120;
var ruleformwd=800;
var findflag="1";

Ext.onReady(function() {

         Ext.QuickTips.init();// ������Ϣ��ʾ
	
	     Ext.Ajax.timeout = 900000;

		 Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
        
         var FindCommentQueryButton = new Ext.Button({
             width : 55,
             id:"FindCommentQueryBtn",
             text: '��ѯ',
             iconCls:"page_find",
             listeners:{   
                          "click":function(){  
              
                           FindCommentNo();
                       
                           
                              }   
                       } 
             
             })		
	
 
             
     var FindCommentDelButton = new Ext.Button({
             width : 55,
             id:"FindCommentDelBtn",
             text: 'ɾ��',
             iconCls:"page_delete",
             listeners:{   
                          "click":function(){  

                           DelCommnetData();
                         
                           
                              }   
                       } 
             
             })	
             
     var SaveButton = new Ext.Button({
             width : 55,
             id:"SaveBtn",
             text: '����',
             iconCls:"page_save",
             listeners:{   
                          "click":function(){  

                           SaveData();
                         
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
	
   
	 

 
  var commentgridcm = new Ext.grid.ColumnModel({
  
  columns:[
       
        {header:'����',dataIndex:'comno',width:100},
        {header:'����',dataIndex:'comdate',width:90},
        {header:'ʱ��',dataIndex:'comtime',width:80},
        {header:'�Ƶ���',dataIndex:'comcreator',width:80},
        {header:'����',dataIndex:'comtype',width:60},
        {header:'��ʽ',dataIndex:'comway',width:100},
        {header:'���鴦��������',dataIndex:'pnum',width:110},
        {header:'δ���䴦����',dataIndex:'prenum',width:100},
        {header:'��ѯ����',dataIndex:'comtext',width:300,hidden:true},
        {header:'rowid',dataIndex:'comrowid',width:40,hidden:true} 
          
          ]   
      
    });
 
 
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
	    'comrowid',
	    'prenum',
	    'pnum'
	    
		]),

    remoteSort: true
});

///���ȡ�ĵ�����
var commentgrid = new Ext.grid.GridPanel({
        
        id:'commentgridtbl', 
        stripeRows: true,
        region:'center',
        //width:ruleformwd,
        height:300,
        //autoScroll:true,
	    title:'��ѯ������',
		layout:'fit',
		tbar:['��ʼ����',FindComStDateField,"-",'��ֹ����',FindComEndDateField,'-',FindCommentQueryButton,"-"], //FindCommentDelButton
        enableHdMenu : false,
        ds: commentgridds,
        cm: commentgridcm,
        //autoScroll:true,
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
   
 
    var Phamagridds = new Ext.data.Store({
	autoLoad: true,
	proxy : new Ext.data.HttpProxy({
			url : unitsUrl
					+ '?action=QueryPhamaDs',
			method : 'POST'
		}),
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'docdesc',
            'docrowid',
            'presconum'
	    
		]),
	

        remoteSort: true
});
	  
 var Phamagridcm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(),  
  {
        header:"ҩʦ����",
        dataIndex:'docdesc',
        width:180,
        align:'left',
        sortable:true,
        editor: new Ext.form.TextField({
            id:'docdesc',
            allowBlank:false
        })
    },{
        header:"ҩʦ��Ҫ�����Ĵ�������",
        dataIndex:'presconum',
        width:300,
        align:'left',
        sortable:true,
        editor: new Ext.form.TextField({
            id:'presconum'
            })
        },{
        header:"ҩʦ���",
        dataIndex:'Phamaid',
        width:300,
        align:'left',
        sortable:true,
        hidden:true,
        editor: new Ext.form.TextField({
            id:'doctorid'
        })
    }
    
    ]);

 ///Ϊҩʦ�����������
   var Phamagrid = new Ext.grid.EditorGridPanel({
   
        id:'Phamatbl',
        region:'center',
        width:780,
        autoScroll:true, //�Զ����ɹ�����
        enableHdMenu : false,
        trackMouseOver:true,//
        frame : true,
		height:250,
        ds: Phamagridds,
        cm: Phamagridcm,
        enableColumnMove : false ,
        stripeRows: true,
        clicksToEdit:1,

        trackMouseOver:'true'
        

        
    });
    
   
    var detailgridcm = new Ext.grid.ColumnModel({
  
  columns:[
  
        {header:'���������',dataIndex:'comuser',width:150},
        {header:'������������',dataIndex:'comnum',width:150}
        
          ]   
            
    
    });
 
  
    var detailgridds = new Ext.data.Store({	
	autoLoad: true,  
	proxy: new Ext.data.HttpProxy({
			url : unitsUrl
					+ '?action=QueryDetail',
			method : 'POST'
		}),
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            
            'comuser',
		    'comnum'
		   
		]),
    remoteSort: true
});



 
 var detailgrid = new Ext.grid.GridPanel({
        title:'�������������ϸ',
        frame:true,
        id:'detailgridtbl',
        region:'center',
        stripeRows: true,
        autoScroll:true,
        enableHdMenu : false,
        height:300,
        width:200,
        ds: detailgridds,
        cm: detailgridcm,
        enableColumnMove : false,
        view: new Ext.ux.grid.BufferView({
		    
		    rowHeight: 25,
		     
		    scrollDelay: false
		   
	    }),
	    
        trackMouseOver:'true'
        

        
    });
    
  
    

			
  var AllotForm = new Ext.Panel({
      frame : true,
      autoScroll:true, //�Զ����ɹ�����
      title:'�����������',
      height : 320,
      tbar: [SaveButton],
      width:ruleformwd,
      items : [  Phamagrid	]

      
   })
			
   
    var QueryForm = new Ext.Panel({
      region : 'west',
      frame : true,
      width:ruleformwd, 
      items : [commentgrid,AllotForm]
      
   })
   
   

   var port = new Ext.Viewport({

				layout : 'border',

				items : [QueryForm,detailgrid] //,eastPanel

			});

    
    
    
    
    
    
    
    
///----------------Events----------------


///�����б�grid �������¼�

commentgrid.on('rowclick',function(grid,rowIndex,e){

        var selectedRow = commentgridds.data.items[rowIndex];
		var comrowid = selectedRow.data["comrowid"];
	 
        Phamagrid.store.reload(); //���¼��ط������������
        FindData(comrowid)    
	  
		
    });  

///��ѯĳ��ʱ���ڵĵ�����

function FindCommentNo()
{
                commentgridds.removeAll();  
                sdate=Ext.getCmp("FindComStDate").getRawValue();       
                edate=Ext.getCmp("FindComEndDate").getRawValue();
                findflag="" //����+סԺ modified by myq 20160811
                                
				commentgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=QueryComNo&StDate='+sdate+'&EndDate='+edate+'&FindFlag='+findflag});
				
				commentgridds.load({
				
				callback: function(r, options, success){
		 
				         
				         if (success==false){
					                  
				                     Ext.Msg.show({title:'ע��',msg:'��ѯʧ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
				                     }
						 if(r.length>0){
								commentgrid.getSelectionModel().selectFirstRow();
		     					commentgrid.getSelectionModel().fireEvent('rowselect',this,0);
		     					commentgrid.getView().focusRow(0);
								var selectedRow = commentgridds.data.items[0];
								var comrowid = selectedRow.data["comrowid"];
								Phamagrid.store.reload(); //���¼��ط������������
								FindData(comrowid) 
						  }
				          }
				
				});
}




///��������

function SaveData()
{
	
	 //��ȡ���е��¼�¼ 
        var mr=Phamagrid.getStore().getCount();
        var row = Ext.getCmp("commentgridtbl").getSelectionModel().getSelections();   //getCmp("gridid") 
        if (row.length == 0)
        {
	        Ext.Msg.show({title:'����',msg:'����ѡ��Ҫ����ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	          return false;
	        }
        var prenum= row[0].data.prenum;  //ȥδ��������Ĵ�����
        var counter=0; 
        var rowid = row[0].data.comrowid; // ��������rowid
        var data="";
        for(var i=0;i<mr;i++){
	        var record = Phamagrid.getStore().getAt(i);
            var docdesc = record.data.docdesc
            var docrowid = record.data.docrowid
            var presconum = record.data.presconum
            
            if((docdesc!="")&&(presconum!="")){
                var dataRow = docdesc+"^"+docrowid+"^"+presconum ;
                if(data==""){
                    data = dataRow;
                }else{
                    data = data+"*"+dataRow;
                }
                var presconum = parseFloat(presconum);  //������ת������������
				
				if ( (!(presconum>0))||(presconum%1>0) )
				{
					var crow=parseFloat(i)+1 ;
					Ext.Msg.show({title:'����',msg:'��'+crow+"�з����������Ϸ�!",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return false;
				}

                var counter=counter+presconum  
            }
          
        }
         
          if (counter>prenum){
	          Ext.Msg.show({title:'����',msg:'����ķ�����������δ���䴦��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	          return false;
	          }     
      
        if(data==""){
	        Ext.Msg.show({title:'����',msg:'û���޸Ļ����������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
            return false;
        }
           
        else{
            Ext.Ajax.request({
	            
	              url:unitsUrl+'?action=SaveAllot&Data='+data+'&Prenum='+prenum+'&Rowid='+rowid ,
	
		waitMsg:'������...',
		failure: function(result, request) {
			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},      
        
        success: function(result, request) {
         var jsonData = Ext.util.JSON.decode( result.responseText );
         if (jsonData.retvalue==0) {  
              Ext.Msg.show({title:'��ʾ',msg:'����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
           }else{
             Ext.Msg.show({title:'error', msg:'����ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR });
            
                    } 
                },    
                scope: this       
            }
            ); 
        } 
        
         FindCommentNo()       //ˢ�µ�������ѯ��¼
         FindData(rowid)      //ˢ�µ���������ϸ��¼
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
	
	        url:unitsUrl+'?action=DelCommentNo&CommontNo='+commontno,
	
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
    
    
 //��ѯ������ϸ
function FindData(Comrowid)  
{
          
                
              var Comrowid = parseFloat(Comrowid);
               
		detailgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=QueryDetail&Comrowid='+Comrowid });	
		detailgridds.load({  
		callback: function(r, options, success){
   
		         if (success==false){
		                     Ext.Msg.show({title:'ע��',msg:'��ѯʧ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
		                     }
		          } 
		         
		
		});
		
}
    
   

});
                                                                                        