
var unitsUrl = 'dhcpha.comment.main.save.csp';
var comwidth=120;
var ruleformwd=800;
var findflag="1";

Ext.onReady(function() {

         Ext.QuickTips.init();// ������Ϣ��ʾ
	
	     Ext.Ajax.timeout = 900000;
        
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
             
     var SaveButton = new Ext.Button({
             width : 55,
             id:"SaveBtn",
             text: '�����������',
             listeners:{   
                          "click":function(){  

                           SaveData();
                         
                              }   
                       } 
             })
    
	
  	
	
      var FindComStDateField=new Ext.form.DateField ({
               
                xtype: 'datefield',
                format:'j/m/Y' ,
                fieldLabel: '��ʼ����',
                name: 'FindComStDate',
                id: 'FindComStDate',
                invalidText:'��Ч���ڸ�ʽ,��ȷ��ʽ��:��/��/��,��:15/02/2011',
                width : 95,
                value:new Date
            })	
            
            
            
        var FindComEndDateField=new Ext.form.DateField ({
                format:'j/m/Y' ,
                fieldLabel: '��ֹ����',
	        name: 'FindComEndDate',
	        id: 'FindComEndDate',
	        width : 95,
	        value:new Date
            })
	
   
	 

 
  var commentgridcm = new Ext.grid.ColumnModel({
  
  columns:[
       
        {header:'����',dataIndex:'comno',width:120},
        {header:'����',dataIndex:'comdate',width:100},
        {header:'ʱ��',dataIndex:'comtime',width:100},
        {header:'�Ƶ���',dataIndex:'comcreator',width:80},
        {header:'����',dataIndex:'comtype',width:60},
        {header:'��ʽ',dataIndex:'comway',width:100},
        {header:'���鴦��������',dataIndex:'pnum',width:110},
        {header:'�ɷ��䴦����',dataIndex:'prenum',width:100},
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
        width:ruleformwd,
        height:210,
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
			   
			  // return 'x-grid-record-green'; 
			   
			   }
		   } 
		    
	    }),
	   
        trackMouseOver:'true'
        

        
    });
   
 
    var Doctorgridds = new Ext.data.Store({
	autoLoad: true,
	proxy : new Ext.data.HttpProxy({
			url : unitsUrl
					+ '?action=QueryDoctorDs',
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
	  
 var Doctorgridcm = new Ext.grid.ColumnModel([
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
        dataIndex:'doctorid',
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
   var Doctorgrid = new Ext.grid.EditorGridPanel({
   
        id:'Doctortbl',
        region:'center',
        width:780,
        autoScroll:true, //�Զ����ɹ�����
        enableHdMenu : false,
        trackMouseOver:true,//
        frame : true,
		height:250,
        ds: Doctorgridds,
        cm: Doctorgridcm,
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
    
  
    
     var OrdForm = new Ext.Panel({
                title:'��ѯ������',
                labelWidth : 80,
				frame : true,
				height:300,
				autoScroll:true,
				width :ruleformwd,
				tbar:['��ʼ����:',FindComStDateField,"-",'��ֹ����:',FindComEndDateField,'-',FindCommentQueryButton],  //,"-",FindCommentDelButton
				//collapsible: true,
				items : [   commentgrid  ]
  
			});
			
			
  var AllotForm = new Ext.Panel({
      frame : true,
      autoScroll:true, //�Զ����ɹ�����
      title:'�����������',
      height : 320,
      tbar: [SaveButton],  //,'-',CancleButton
      width:ruleformwd,
      items : [  Doctorgrid	]

      
   })
			
   
    var QueryForm = new Ext.Panel({
      region : 'west',
      frame : true,
      width:ruleformwd, 
      items : [OrdForm,AllotForm]
      
   })
   
   

   var port = new Ext.Viewport({

				layout : 'border',

				items : [QueryForm,detailgrid] //,eastPanel

			});

    
    
    
    
    
    
    
    
///----------------Events----------------


///�����б�grid �������¼�

commentgrid.getSelectionModel().on('rowselect',function(grid,rowIndex,e){

        var selectedRow = commentgridds.data.items[rowIndex];
		var comrowid = selectedRow.data["comrowid"];
	
        FindData(comrowid)   
	  
	   Doctorgrid.store.reload(); //���¼��ط������������
		
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
				          }
				
				});
				
				commentgridds.on('load',function(){
				if (commentgridds.getCount()>0){
				    commentgrid.getSelectionModel().selectFirstRow();
				    //commentgrid.getSelectionModel().selectRow(0);
					commentgrid.getView().focusRow(0);
				}
			});
				
}




///��������

function SaveData()
{
	
	 //��ȡ���е��¼�¼ 
        var mr=Doctorgrid.getStore().getCount();
        var row = Ext.getCmp("commentgridtbl").getSelectionModel().getSelections();   //getCmp("gridid") 
        if (row.length == 0)
        {
	        Ext.Msg.show({title:'����',msg:'����ѡ��Ҫ����ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	          return false;
	        }
        var prenum= row[0].data.prenum;  //ȡ�ɷ�������Ĵ�����
       
        var counter=0; 
        var rowid = row[0].data.comrowid; // ��������rowid
        var data="";
        for(var i=0;i<mr;i++){
	        var record = Doctorgrid.getStore().getAt(i);
            var docdesc = record.data.docdesc
            var docrowid = record.data.docrowid
            var presconum = record.data.presconum

                if ((presconum<0)||(presconum%1>0)){
	         var crow=parseFloat(i)+1;
	         Ext.Msg.show({title:'����',msg:'��'+crow+'�з����������Ϸ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	         return false;
	         }
	         
	         var allotprescnum=tkMakeServerCall("web.DHCSTCNTSALLOTUSER","GetAllotPrescNum",rowid,docrowid)   //ȡ�õ����Ѿ��ָ�ĳҽʦ�Ĵ�����

	         if((docdesc!="")&&(presconum!="")){
		        var presconum = parseFloat(presconum);  //������ת������������
	            var difnum=presconum-allotprescnum
		       
               // var dataRow = docdesc+"^"+docrowid+"^"+presconum ;
                var dataRow = docdesc+"^"+docrowid+"^"+difnum ;
                if(data==""){
                    data = dataRow;
                }else{
	                if (difnum<0){
		              data = dataRow+"*"+data;   
	                }
	                else{
		               data = data+"*"+dataRow;  
		                }
                   
                }
                
                
                
                var counter=counter+difnum   //���䴦������
            }
          
        }
        
        
         
          if (counter>prenum){
	          Ext.Msg.show({title:'����',msg:'����ķ��������ܺͺ���ɷ��䴦��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
        
         
         Doctorgridds.reload() ;
         
         FindData(rowid)      //ˢ�µ���������ϸ��¼
         
         FindCommentNo()       //ˢ�µ�������ѯ��¼
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
                                                                                        