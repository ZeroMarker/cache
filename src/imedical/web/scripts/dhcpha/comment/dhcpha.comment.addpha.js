///����ҩʦά��JS
///Creator:MYQ
///CreatDate:2013-11-28

var unitsUrl = 'dhcpha.comment.main.save.csp';
var comwidth=120;
var ruleformwd=650;

Ext.onReady(function() {

         Ext.QuickTips.init();// ������Ϣ��ʾ
	
	     Ext.Ajax.timeout = 900000;
         Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
        
        ///ҽ��
	
	 var ComBoDocDs = new Ext.data.Store({
		autoLoad: true,
		proxy : new Ext.data.HttpProxy({
			url : unitsUrl
					+ '?action=GetPhaDs',
			method : 'POST'
		}),
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'doctordr'},['docname','doctordr'])
				
	});
	
	
	var PhamaCombo = new Ext.form.ComboBox({
		store: ComBoDocDs,
		displayField:'docname',
		mode: 'local', 
		width : comwidth,
		id:'PhamaCmb',
		emptyText:'',
		valueField : 'doctordr',
		emptyText:'��ѡ��ҩʦ...'
	   //fieldLabel: 'ҩʦ����'
	});

	 var PhaAddButton = new Ext.Button({
             width : 65,
             id:"PhaAddBtn",
             text: '����',
             iconCls:"page_add",
             listeners:{
                          "click":function(){   
                             
                              PhamaAddClick();
                              
                              }   
             }
             
             })
             
             
             

        var DocDelButton = new Ext.Button({
             width : 65,
             id:"DocDelBtn",
             text: 'ɾ��',
             iconCls:"page_delete",
             listeners:{
                          "click":function(){   
                             
                              PhamaDelClick();
                              
                              }   
             }
             
             })
             
             
             	
   var Phamagridcm = new Ext.grid.ColumnModel({
  
  columns:[
       
        {header:'ҩʦ����',dataIndex:'docdesc',width:220},
        {header:'����ҩʦ���',dataIndex:'docrowid',width:100},
        {header:'ҩʦid',dataIndex:'docdescdr',width:100,hidden:true}
            
          ]   
            
    
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
            'docdescdr'
	    
		]),
		
		

        remoteSort: true
});
	
	
   var Phamagrid = new Ext.grid.GridPanel({
   
        id:'Phamatbl',
        title:'�������ҩʦȨ��',
        region:'center',
        //width:ruleformwd,
        autoScroll:true, //�Զ����ɹ�����
        enableHdMenu : false,
        frame : true,
        autoHeight:true,
        autoWidth:true,
        ds: Phamagridds,
        cm: Phamagridcm,
        enableColumnMove : false,
        stripeRows: true,

	tbar:['ҩʦ����',PhamaCombo,' ',PhaAddButton,'-',DocDelButton],  
    
        trackMouseOver:'true'
        

        
    });
    
       Phamagrid.on('rowclick',function(grid,rowIndex,e){

               	var selectedRow = Phamagridds.data.items[rowIndex];
               	var docdesc=selectedRow.data["docdesc"];
               	var doctordr=selectedRow.data["docdescdr"];
                //Ext.getCmp("PhamaCmb").setRawValue(docdesc);
                //Ext.getCmp("PhamaCmb").setValue(doctordr);
			
       });
       			
	

	 var QueryForm = new Ext.Panel({
      region : 'center',
      frame : true, 
      items : [Phamagrid]
      
   })
 
     var port = new Ext.Viewport({

				layout : 'fit',

				items : [QueryForm]

			});

 


		 
  
//���ӵ���ҩʦ
function PhamaAddClick()
{
	
	var docdesc=Ext.getCmp("PhamaCmb").getValue();
                if (docdesc==""){
                   Ext.Msg.show({title:'��ʾ',msg:'����ѡ��ҩʦ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
                   return;
                }             
	 
	       ///���ݿ⽻��
	
		Ext.Ajax.request({
	
	        url:unitsUrl+'?action=PhamaAdd&DocDesc='+docdesc ,
	
		failure: function(result, request) {
			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			
	  	    if (jsonData.retvalue==0) {
	  		       Ext.Msg.show({title:'��ʾ',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
	  		       QueryPhamaDs();
	  		}
	  		else if (jsonData.retvalue==100) {
	  		       Ext.Msg.alert("��ʾ", "��ҩʦ�Ѿ�����,�����ظ����!"); //�����ظ����ҩʦ
	  		}else if (jsonData.retvalue==-10) {
	  		       Ext.Msg.alert("��ʾ", "��ҩʦ������,�������!"); //�������ҩʦ
	  		}
	  		else{
	  		       Ext.Msg.alert("��ʾ", "���ʧ��!����ֵ: "+jsonData.retinfo);
	  		    
	  		}
		},
		      
			scope: this
		});
		
}

//ɾ������ҩʦ
function PhamaDelClick()
{
	
	 var row = Ext.getCmp("Phamatbl").getSelectionModel().getSelections();   
	
	       if (row.length == 0) {  
		      
		      Ext.Msg.show({title:'��ʾ',msg:'δѡ�м�¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		      return;  
	       }  
  
	       Ext.MessageBox.confirm('ע��', 'ȷ��Ҫɾ���� ? ',DelClickResult);
}

///ɾ��ȷ�϶���
 function  DelClickResult(btn)
 {
               if (btn=="no"){ return ;}
               
               
               var row = Ext.getCmp("Phamatbl").getSelectionModel().getSelections(); 
	       var docrowid = row[0].data.docrowid;         

	       ///���ݿ⽻��ɾ��
	    
		Ext.Ajax.request({
	
	        url:unitsUrl+'?action=PhamaDel&PhamaID='+docrowid ,
	
		waitMsg:'ɾ����...',
		failure: function(result, request) {
			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
	  	        if (jsonData.retvalue==0) {
	  		       Ext.Msg.show({title:'��ʾ',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
	  		       QueryPhamaDs();
	  		}
	  		else{
	  		       Ext.Msg.alert("��ʾ", "ɾ��ʧ��!����ֵ: "+jsonData.retinfo);
	  		    
	  		}
		},
		
			scope: this
		});       
                          
   }
   

 ///��������
function QueryPhamaDs()
{
               Phamagridds.removeAll(); 
                
    		Phamagridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=QueryPhamaDs' });
		
		Phamagridds.load({
		
		callback: function(r, options, success){
 
		         
		         if (success==false){
		                     Ext.Msg.show({title:'ע��',msg:'��ѯʧ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
		                     }
		          }
		
		});
		
		
}


});
                                                                                        