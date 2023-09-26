var unitsUrl = 'dhcpha.comment.main.save.csp';

var comwidth=160;

Ext.onReady(function() {

		Ext.QuickTips.init();// ������Ϣ��ʾ
        Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

		///��ȫ��
		
		var ComBoSecGrpDs = new Ext.data.Store({
			autoLoad: true,
			proxy : new Ext.data.HttpProxy({
				url : unitsUrl
						+ '?action=GetSecGrpDs',
				method : 'POST'
			}),
			reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'grpdr'},['grpdesc','grpdr'])
					
		});
	
		var ComBoSecGrp = new Ext.form.ComboBox({
			store: ComBoSecGrpDs,
			displayField:'grpdesc',
			mode: 'local', 
			width : comwidth,
			id:'SecGrpCmb',
			emptyText:'',
			listWidth : 350,
			valueField : 'grpdr',
			emptyText:'ѡ��ȫ��...',
			fieldLabel: '��ȫ��',
			allowBlank: false,
			valueNotFoundText:''
		}); 
		
		
		//�޸�Ȩ��
	   var UpdateFlagField=new Ext.form.Checkbox({
        
			boxLabel : '�޸�Ȩ��',
			id : 'UpdateFlagChk',
			inputValue : '1',
			checked : false
         })
	
	   
        var WayItmAddButton = new Ext.Button({
             width : 65,
             id:"WayItmAddBtn",
             text: '����',
             iconCls:"page_add",
             listeners:{
                          "click":function(){   
                             
                              WayItmAddClick();
                              
                              }   
             }
             
             })
             
        var WayItmUpdButton = new Ext.Button({
             width : 65,
             id:"WayItmUpdBtn",
             text: '�޸�',
             iconCls:"page_edit",
             listeners:{
                          "click":function(){   
                             
                              WayItmUpdClick();
                              
                              }   
             }
             
        })           
       var WayUpdButton = new Ext.Button({
             width : 65,
             id:"WayUpdBtn",
             text: '�޸�',
             listeners:{
                          "click":function(){   
                             
                              WayUpdClick();
                              
                              }   
             }
             
             })
             

        var WayItmDelButton = new Ext.Button({
             width : 65,
             id:"WayItmDelBtn",
             text: 'ɾ��',
             iconCls:"page_delete",
             listeners:{
                          "click":function(){   
                             
                              WayItmDelClick();
                              
                              }   
             }
             
             })



       var WayCodeField=new Ext.form.TextField({
  
	        width : 60, 
	        id:"WayCodeTxt",         
	        fieldLabel:"����" 
        })
        
        
        var WayDescField=new Ext.form.TextField({
  
	        width : 300, 
	        id:"WayDescTxt",         
	        fieldLabel:"��ʽ" 
        })
        
        
        
        
        var WayActiveField=new Ext.form.Checkbox({
        
		boxLabel : '����',
		id : 'WayActive',
		inputValue : '1',
		checked : false
         })
        
        
        

	
   var waygridcm = new Ext.grid.ColumnModel({
  
  columns:[
       
        {header:'����',dataIndex:'waycode',width:60},
        {header:'��ʽ',dataIndex:'waydesc',width:300},
        {header:'����',dataIndex:'wayactive',width:100},
        {header:'rowid',dataIndex:'wayrowid',width:40,hidden:true}
            
          ]   
            
    
    });

 
    var waygridds = new Ext.data.Store({
	autoLoad: true,
	proxy : new Ext.data.HttpProxy({
			url : unitsUrl
					+ '?action=QueryWayDs',
			method : 'POST'
		}),
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'waycode',
            'waydesc',
            'wayactive',
            'wayrowid'
	    
		]),
		
		

        remoteSort: true
});


 
 var waygrid = new Ext.grid.GridPanel({
   
        id:'waytbl',
        title:'������ʽ��ȫ������',
        region:'north',
        width:650,
        height:290,
        autoScroll:true,
        enableHdMenu : false,
        ds: waygridds,
        cm: waygridcm,
        enableColumnMove : false,
        stripeRows: true,
    
        trackMouseOver:'true'
        

        
    });
    
    
    waygrid.on('rowclick',function(grid,rowIndex,e){

               	var selectedRow = waygridds.data.items[rowIndex];
               	var wayid=selectedRow.data["wayrowid"];; 
				
				QueryWayItmDs(wayid);
				
		
    });  
    
    

    
    
   var wayitmgridcm = new Ext.grid.ColumnModel({
  
		  columns:[
		       
		        {header:'��ȫ��',dataIndex:'secgrp',width:205},
		        {header:'�޸�Ȩ��',dataIndex:'updateflag',width:80},
		        {header:'rowid',dataIndex:'wayitmid',width:60,hidden:true}
		            
		          ]   
            
    
    });

 
    var wayitmgridds = new Ext.data.Store({
	//autoLoad: true,
	proxy : '',
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'secgrp',
            'updateflag',
            'wayitmid'
	    
		]),
		
		

        remoteSort: true
});
    
    
    
    
      var wayitmgrid = new Ext.grid.GridPanel({
   
        id:'wayitmtbl',
        title:'�����б�',
        region:'center',
        width:650,
        autoScroll:true,
        enableHdMenu : false,
        ds: wayitmgridds,
        cm: wayitmgridcm,
        enableColumnMove : false,
        stripeRows: true,
        tbar:["��ȫ��",ComBoSecGrp,"&nbsp;&nbsp;",UpdateFlagField,WayItmAddButton,'-',WayItmUpdButton,'-',WayItmDelButton],
        trackMouseOver:'true'
        

        
    });   
    
    
	
    ///view

	var por = new Ext.Viewport({

				layout : 'border', // ʹ��border����

				items : [waygrid,wayitmgrid]

			});





///-----------------------Events----------------------



///����

function WayItmAddClick()
{
		        
		       var waytblrow = Ext.getCmp("waytbl").getSelectionModel().getSelections(); 
		      

		       if (!(waytblrow)){
		            Ext.Msg.getDialog().setWidth(500); 
		            Ext.Msg.show({title:'��ʾ',msg:'δѡ������ʽ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		            return;
       			}
       			
       			if (waytblrow==0){
		            Ext.Msg.getDialog().setWidth(500); 
		            Ext.Msg.show({title:'��ʾ',msg:'δѡ������ʽ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		            return;
       			}
       			
		       
	            var wayrowid = waytblrow[0].data.wayrowid;  //������ʽID  
	            
		       
                var grpdr=Ext.getCmp("SecGrpCmb").getValue();
                 var grpdesc=Ext.getCmp("SecGrpCmb").getRawValue();
                if (trim(grpdesc)==""){
	               grpdr="";
	            }
                
                if (grpdr==""){
                   Ext.Msg.show({title:'��ʾ',msg:'����ѡ��ȫ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
                   return;
                } 
                var updateflag=Ext.getCmp("UpdateFlagChk").getValue();  
                if (updateflag){
                   var updateflag="Y";
                }
                else
                {
                   var updateflag="N";
                }
                
                var Input=updateflag ;
      
	
	       		///���ݿ⽻��
	
				Ext.Ajax.request({
			
			        url:unitsUrl+'?action=AddWayItm&WayID='+wayrowid + '&GrpDr='+grpdr+ '&Input='+updateflag,
			
					waitMsg:'ɾ����...',
					failure: function(result, request) {
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
			  	        if (jsonData.retvalue==0) {
			  		       Ext.Msg.show({title:'��ʾ',msg:'����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			  		       QueryWayItmDs(wayrowid);
			  		}
			  		 else if (jsonData.retvalue==-2) {
			  		       Ext.Msg.alert("��ʾ", "�ð�ȫ������Ȩ,�����ظ����! ");
			  		    
			  		}else if (jsonData.retvalue==-100) {
			  		       Ext.Msg.alert("��ʾ", "�����ڴ˰�ȫ��,�������!");
			  		    
			  		}
			  		else  {
			  		       Ext.Msg.alert("��ʾ", "����ʧ��!����ֵ: "+jsonData.retinfo);
			  		    
			  		}
				},
				
					scope: this
				});
		

}
  
  
 ///��������
 
function QueryWayItmDs(wayid)
{
	            Ext.getCmp("SecGrpCmb").setValue('');

                wayitmgridds.removeAll(); 
                
    			wayitmgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=QueryWayItmDs&WayID='+wayid });
		
				wayitmgridds.load({
		
				callback: function(r, options, success){
 
		         
		         if (success==false){
		                     Ext.Msg.show({title:'ע��',msg:'��ѯʧ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
		                     }
		          }
		
		});
		
		
}




///�޸��¼�

function WayUpdClick()
{


               var row = Ext.getCmp("waytbl").getSelectionModel().getSelections();   
	
	       if (row.length == 0) {  
		      
		      Ext.Msg.show({title:'��ʾ',msg:'δѡ�м�¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		      return;  
	       }  
	       
	       var WayID = row[0].data.wayrowid;  //ԭ��ID   
	       var WayCode=Ext.getCmp("WayCodeTxt").getValue();    
               var WayDesc=Ext.getCmp("WayDescTxt").getValue();    //����
               var WayActive=Ext.getCmp("WayActive").getValue(); 
               if (WayActive){
                   WayActive="Y";
               }else{
                   WayActive="N";
               }
               
               
               if (WayDesc=="") {
                   Ext.Msg.show({title:'��ʾ',msg:'����¼�뷽ʽ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
                   return;
               }
                
	
	       ///���ݿ⽻��
	    
		Ext.Ajax.request({
	
	        url:unitsUrl+'?action=UpdWay&WayDesc='+WayDesc+'&WayActive='+WayActive+'&WayID='+WayID+'&WayCode='+WayCode ,
	
		waitMsg:'������...',
		failure: function(result, request) {
			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
	  	        if (jsonData.retvalue==0) {
	  		       Ext.Msg.show({title:'��ʾ',msg:'����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
	  		       QueryWayDs();
	  		}
	  		else{
	  		       Ext.Msg.alert("��ʾ", "����ʧ��!����ֵ: "+jsonData.retinfo);
	  		    
	  		}
		},
		
			scope: this
		});
		
		
            


}




///�޸�ԭ����¼�

function WayItmDelClick()
{

           var row = Ext.getCmp("wayitmtbl").getSelectionModel().getSelections();   
	
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
               
               
               var row = Ext.getCmp("wayitmtbl").getSelectionModel().getSelections(); 
	           var wayitmid = row[0].data.wayitmid;  //ID       

			       ///���ݿ⽻��ɾ��
			    
				Ext.Ajax.request({
			
			        url:unitsUrl+'?action=DelWayItmData&WayItmId='+wayitmid ,
			
				waitMsg:'ɾ����...',
				failure: function(result, request) {
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
			  	        if (jsonData.retvalue==0) {
			  		       Ext.Msg.show({title:'��ʾ',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			  		       QueryWayItmDs(wayitmid);
			  		}
			  		else{
			  		       Ext.Msg.alert("��ʾ", "ɾ��ʧ��!����ֵ: "+jsonData.retinfo);
			  		    
			  		}
				},
				
					scope: this
				});       
		               

               
               
               
   }
///�޸�Ȩ��

function WayItmUpdClick()
{   
               var waytblrow = Ext.getCmp("waytbl").getSelectionModel().getSelections(); 
		       if (!(waytblrow)){
		            Ext.Msg.getDialog().setWidth(500); 
		            Ext.Msg.show({title:'��ʾ',msg:'δѡ������ʽ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		            return;
       		   }
       		   if (waytblrow==0){
		            Ext.Msg.getDialog().setWidth(500); 
		            Ext.Msg.show({title:'��ʾ',msg:'δѡ������ʽ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		            return;
       		   }
		       var row = Ext.getCmp("wayitmtbl").getSelectionModel().getSelections(); 
		       if (row.length == 0) {  
			      Ext.Msg.show({title:'��ʾ',msg:'δѡ�м�¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			      return;  
		       }  
		       var wayrowid=waytblrow[0].data.wayrowid;
		       var wayitmid = row[0].data.wayitmid;  //ID  
		       var update = row[0].data.updateflag;
		       var secgrp=row[0].data.secgrp;
		       var grpdr=Ext.getCmp("SecGrpCmb").getValue();
               var grpdesc=Ext.getCmp("SecGrpCmb").getRawValue();
               var updateflag=Ext.getCmp("UpdateFlagChk").getValue(); 
               if (updateflag){
                   var updateflag="Y";
               }
               else
               {
                   var updateflag="N";
               }

               if ((grpdesc=="")&&(updateflag==update)){
                   Ext.Msg.show({title:'��ʾ',msg:'����δ�����ı�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
                   return;
               }
               var Input=updateflag ;
	       	   ///���ݿ⽻��
			   Ext.Ajax.request({
			
			        url:unitsUrl+'?action=UpdWayItm&WayID='+wayitmid + '&SecGrp='+secgrp+ '&GrpDr='+grpdr+ '&Input='+updateflag,
					waitMsg:'�޸���...',
					failure: function(result, request) {
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request) {
					     var jsonData = Ext.util.JSON.decode( result.responseText );
			  	         if (jsonData.retvalue==0) {
			  		        Ext.Msg.show({title:'��ʾ',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			  		        QueryWayItmDs(wayrowid);
			  		     }
			  		     else if (jsonData.retvalue==-2) {
			  		        Ext.Msg.show({title:'��ʾ',msg:'�Ѵ�����ͬ��ȫ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			  		        return;
			  		     }
			  		     else  {
			  		        Ext.Msg.alert("��ʾ", "�޸�ʧ��!����ֵ: "+jsonData.retinfo);
			  		     }
				},
				
					scope: this
				});
}
});
