var unitsUrl = 'dhcpha.comment.systaskmanage.save.csp';
var CurrRowid="";
Ext.onReady(function() {

	Ext.QuickTips.init();// ������Ϣ��ʾ
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
���������� //��ʼ����
	
  var stdatef=new Ext.form.DateField ({
               
  	            width : 120,
                xtype: 'datefield',
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

       
       var FindButton = new Ext.Button({
             width : 65,
             id:"FindBtn",
             text: '��ѯ',
             iconCls:"page_find",
             listeners:{
                          "click":function(){   
                             
                              FindClick();
                              
                              }   
             }
             
             })
             
       var TaskUpdButton = new Ext.Button({
             width : 65,
             id:"AdviceUpdBtn",
             text: '����/ͣ��',
             iconCls:"page_active",
             listeners:{
                          "click":function(){   
                             
                              TaskUpdClick();
                              
                              }   
             }
             
             })
             



        

	
   var Taskgridcm = new Ext.grid.ColumnModel({
  
  columns:[
       
        {header:'����',dataIndex:'taskdate',width:90},
        {header:'ʱ��',dataIndex:'tasktime',width:80},
        {header:'�ύ��',dataIndex:'taskuser',width:80},
        {header:'�ύ����',dataIndex:'taskdesc',width:800},
        {header:'����',dataIndex:'taskactive',width:50},
        {header:'���ɵ���',dataIndex:'pcntsno',width:120},
        {header:'rowid',dataIndex:'taskrowid',width:50}
            
          ]   
            
    
    });

 
    var Taskgridds = new Ext.data.Store({
	autoLoad: true,
	proxy : new Ext.data.HttpProxy({
			url : unitsUrl
					+ '?action=QuerySysTaskDs',
			method : 'POST'
		}),
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'taskdate',
            'tasktime',
            'taskuser',
            'taskdesc',
            'taskactive',
            'pcntsno',
            'taskrowid'
	    
		]),
		
		

        remoteSort: true
});

 var TaskgridcmPagingToolbar = new Ext.PagingToolbar({	
			store:Taskgridds,
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
 
 var Taskgrid = new Ext.grid.GridPanel({
   
        id:'Tasktbl',
        title:'ϵͳ���������',
        region:'center',
        width:650,
        autoScroll:true,
        enableHdMenu : false,
        ds: Taskgridds,
        cm: Taskgridcm,
        enableColumnMove : false,
        stripeRows: true,

	      tbar:['��ʼ����',stdatef,'��������',enddatef,FindButton,TaskUpdButton],  
	      bbar:TaskgridcmPagingToolbar,
    
        trackMouseOver:'true'
        
        

        
    });
    

    
    
	
    ///view

	var por = new Ext.Viewport({

				layout : 'border', // ʹ��border����

				items : [Taskgrid]

			});





///-----------------------Events----------------------




///����

function AdviceAddClick()
{
                
                var advdesc=Ext.getCmp("AdviceDescTxt").getValue();
                
                if (advdesc==""){
                   Ext.Msg.show({title:'��ʾ',msg:'����¼������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
                   return;
                }              
	
	       ///���ݿ⽻��
	
		Ext.Ajax.request({
	
	        url:unitsUrl+'?action=AdviceAdd&AdviceDesc='+advdesc ,
	
		waitMsg:'ɾ����...',
		failure: function(result, request) {
			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
	  	        if (jsonData.retvalue==0) {
	  		       Ext.Msg.show({title:'��ʾ',msg:'����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
	  		       QueryAdviceDs();
	  		}
	  		else{
	  		       Ext.Msg.alert("��ʾ", "����ʧ��!����ֵ: "+jsonData.retinfo);
	  		    
	  		}
		},
		
			scope: this
		});
		

}

///��ȡ����itemֵ
 function GetParStr()
 {
  	      sdate=Ext.getCmp("startdt").getRawValue().toString();
	        edate=Ext.getCmp("enddt").getRawValue().toString();
	        var listinputstr=sdate+"^"+edate ;
	  	    
	  	    var parstr=sdate+"^"+edate ;
	  	    
	  	    return parstr;
  }
  
 ///��������
 
function FindClick()
{
                Taskgridds.removeAll(); 
                
                var parstr=GetParStr();

				    		Taskgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=QuerySysTaskDs'+'&ParStr='+parstr });
						
								Taskgridds.load({
								params:{start:0, limit:TaskgridcmPagingToolbar.pageSize},
								callback: function(r, options, success){
 
								         
								         if (success==false){
								                     Ext.Msg.show({title:'ע��',msg:'��ѯʧ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
								                     }
								          }
								
								});
				
		
}




///�����¼�

function TaskUpdClick()
{


         var row = Ext.getCmp("Tasktbl").getSelectionModel().getSelections();   
	
	       if (row.length == 0) {  
		      
		      Ext.Msg.show({title:'��ʾ',msg:'δѡ�м�¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		      return;  
	       }  
	       
	       var taskrowid = row[0].data.taskrowid ;  //ID       

	
	       ///���ݿ⽻��
	    
					Ext.Ajax.request({
				
				        url:unitsUrl+'?action=UpdTask&taskrowid='+taskrowid ,
				
					waitMsg:'������...',
					failure: function(result, request) {
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
				  	        if (jsonData.retvalue==0) {
				  		       Ext.Msg.show({title:'��ʾ',msg:'����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				  		       FindClick(); 
				  		}
				  		else{
				  		       Ext.Msg.alert("��ʾ", "����ʧ��!����ֵ: "+jsonData.retinfo);
				  		    
				  		}
					},
					
						scope: this
					});
		
		
            


}





   
   
   
   
  
	
	


});
