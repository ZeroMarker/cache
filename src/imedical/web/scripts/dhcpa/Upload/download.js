//downloadMainFun=function(ItemGrid,rowidIndex,ColNum){
    /*alert("cccccc");
	ItemGrid.on('cellclick',function( g, rowIndex, columnIndex, e ){
	
		if(columnIndex==ColNum){
		
		//document.write(returnCitySN["cip"]);
		//alert($("#ip"));
		
		
		var tmpRec=ItemGrid.getStore().data.items[rowIndex];
	 
		var UDRDDr=tmpRec.data[rowidIndex];   //�ϴ���¼ID
			var DataStatus2=tmpRec.data['DataStatus'];				
		
		  //return '<span style="color:gray;cursor:hand">����</span>';	
			                  
		downloadFun(UDRDDr,DataStatus2,ItemGrid,rowIndex,ColNum);

	}
	});*/
 function downFile(FtpURL){
	 			Ext.Ajax.request({
        			url : "../csp/dhc.pa.uploadexe.csp?action=testCon&ftpcon="+ftpcon,
        			method : 'POST',
        			success : function(response) {
            		var respText = Ext.decode(response.responseText);
            		if (respText.success=="true") {
                 	 	 downloadFile(FtpURL);
           			 }else{
	           			 Ext.Msg.show({title:'����',msg:'����ʧ�ܣ���',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
	       				
	       				 }
       				 },
       				 
        			failure : function() {
	        			Ext.Msg.show({title:'����',msg:'FTP����ʧ�ܣ���',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
       					 } 
  			  		});
	 } 
   
downloadFun = function(UDRDDr,itemGrid) {
	
/*if(window.location.hostname=="192.168.120.8")
{FtpURL="ftp://192.168.120.8";}
else{FtpURL="ftp://192.168.99.107";}*/

FtpURL=downloadUrl;
var itemGrid1 = new dhc.herp.Gridly({
        //title: '�ڿ�����',
        width: 400,
        //edit:false,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'dhc.pa.uploadexe.csp',	  
		//tbar:delButton,
		atLoad : false, // �Ƿ��Զ�ˢ��
		selectOnFocus : true,
		forceSelection : true,
		loadmask:true,
        fields: [{
             id:'rowid',
            header: 'ID',
            dataIndex: 'rowid',
	    	editable:false,
            hidden: true
        },{
            id:'FileName',
            header: '�ļ�����',
			allowBlank: false,
			width:260,
			editable:false,
            dataIndex: 'FileName'
        },{
            id:'UploadDate',
            header: '�ϴ�ʱ��',
			allowBlank: false,
			width:100,
			editable:false,
            dataIndex: 'UploadDate'
        },{
            id:'UploadUser',
            header: '�ϴ���',
			allowBlank: false,
			width:100,
			editable:false,
            dataIndex: 'UploadUser'
        },{
            id:'download',
            header: '����',
			allowBlank: false,
			width:80,
			editable:false,
            dataIndex: 'download',
			renderer : function(v, p, r){
				a=r.get("FileURL");
				return '<a href="###" onclick="downFile(FtpURL)">����</a>';
			
			  //return '<a href="###" onclick="javascript:downloadFile(FtpURL);">����</a>';
			   //return '<span style="color:blue"><u>����</u></span>';
			   //return '<a href="###" onclick="javascript:window.location.href(FtpURL+a);">����</a>';
			  
			   //return '<a href="###" onclick="javascript:window.open(FtpURL+a);">����</a>';
	                        
					}
				
			
        },{
            id:'FileURL',
            header: '�ļ�·��',
			allowBlank: false,
			width:150,
			editable:false,
			hidden: true,
            dataIndex: 'FileURL'
        }
		] 
});



  itemGrid1.btnAddHide();     //�������Ӱ�ť
  itemGrid1.btnSaveHide();    //���ر��水ť
  //itemGrid.btnResetHide();   //�������ð�ť
  
	/*if((DataStatus2=='���ύ')&&(session['LOGON.GROUPDESC']!="���й���ϵͳ(��Ϣ�޸�)")){
		  itemGrid1.btnDeleteHide();//����ɾ����ť	
		};*/
	// ��ʼ��ȡ����ť
	var cancelButton = new Ext.Toolbar.Button({ text : '�ر�'});
	// ����ȡ����ť����Ӧ����
	cancelHandler = function(){ 
	  dlwin.close();
	};
	// ���ȡ����ť�ļ����¼�
	cancelButton.addListener('click', cancelHandler, false);
	
			
dlwin = new Ext.Window({
			title: '��������',
			width: 600,
			height: 450,
			//autoHeight: true,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: itemGrid1,
			buttons : [cancelButton]
		});	
		
	itemGrid1.load({params:{start:0,limit:25,UDRDDr:UDRDDr}});	
	itemGrid1.getStore().on("load",function(){
			if(itemGrid1.getStore().getCount()>0)
			{
				dlwin.show();
				
				//var record=itemGrid.getStore().getAt(rowIndex);
				//alert(record);
				//var fieldName=itemGrid.getColumnModel().getDataIndex(ColNum);
				//alert(fieldName);
				//var a=record.data[fieldName];
				//record.data[fieldName].tstyle="color:gray;";
			    
			}else {Ext.Msg.show({title:'����',msg:'û���ϴ����ݣ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}	
			
			
			});
	
	itemGrid1.on('cellclick', function(g, rowIndex, columnIndex, e) {
	
	if (columnIndex == 5) {
		var tmpRec=itemGrid1.getStore().data.items[rowIndex];
	 
		var FileURL=tmpRec.data['FileURL'];
		

		window.open(FtpURL+FileURL);
		//return '<a href="###" onclick="javascript:window.open(FtpURL+FileURL);">����</a>';
		//return '<a href="###" onclick="javascript:window.location.href(FtpURL+FileURL);">����</a>';
		//window.location.href=FtpURL+FileURL;


	}
});

	
};
//}; 

