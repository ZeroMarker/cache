

downloadMainFun=function(itemGrid,rowidIndex,SysNo,ColNum){

	itemGrid.on('cellclick',function( g, rowIndex, columnIndex, e ){
	
		if(columnIndex==ColNum){
		
		//document.write(returnCitySN["cip"]);
		//alert($("#ip"));
		
		
		var tmpRec=itemGrid.getStore().data.items[rowIndex];
	 
		var RecDr=tmpRec.data[rowidIndex];   //�ϴ���¼ID
		if(RecDr==""){
			Ext.Msg.show({title : '����',msg : '���ȱ��������������ļ�!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
			return ;
		}
		
		var DataStatus2=tmpRec.data['DataStatus'];				
		
		if (SysNo!=""){
			Ext.Ajax.request({				   	    			        
				url: 'herp.srm.uploadexe.csp'+'?action=GetSRMConfigureInfo&Type='+'2',
				success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );  
				if (jsonData.success=='true'){
					var data = jsonData.info;	
					var dataarr = data.split("^",-1);
					var ip = dataarr[0];
					var user = dataarr[1]; 	
					var userpassword = dataarr[2]; 	
					var tmpurl="ftp://"+user+":"+userpassword+"@"+ip  
					//alert(tmpurl);
					downloadFun(RecDr,SysNo,DataStatus2,itemGrid,rowIndex,ColNum,tmpurl);     
				}
				},
				scope: this
			});  
		}
			                  
		//downloadFun(RecDr,SysNo,DataStatus2,itemGrid,rowIndex,ColNum);

	}
	});

   
downloadFun = function(RecDr,SysNo,DataStatus2,itemGrid,rowIndex,ColNum,tmpurl) {

/**
if(window.location.hostname=="192.168.120.8")
{FtpURL="ftp://192.168.120.8";}
else{FtpURL="ftp://192.168.99.107";}
**/

//var FtpURL="ftp://127.0.0.1";
//var FtpURL=srmdownloadurl;
var FtpURL=tmpurl;

var itemGrid1 = new dhc.herp.Gridly({
        //title: '�ڿ�����',
        width: 400,
        //edit:false,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'herp.srm.uploadexe.csp',	  
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
            id:'SubDate',
            header: '�ϴ�ʱ��',
			allowBlank: false,
			width:100,
			editable:false,
            dataIndex: 'SubDate'
        },{
            id:'SubUser',
            header: '�ϴ���',
			allowBlank: false,
			width:100,
			hidden: true,
			editable:false,
            dataIndex: 'SubUser'
        },{
            id:'download',
            header: '����',
			allowBlank: false,
			width:80,
			editable:false,
            dataIndex: 'download',
			renderer : function(v, p, r){
			   //alert(r.get("FileURL"));
			   a=r.get("FileURL");
			   return '<span style="color:blue"><u>����</u></span>';
			   //return '<a href="###" onclick="javascript:window.location.href(FtpURL+a);">����</a>';
			   //return '<a href="###" onclick="javascript:downloadFile(FtpURL);">����</a>';
			   //return '<a href="###" onclick="javascript:window.open(FtpURL+a);">����</a>';
	                        
			}
        },{
            id:'SysNo',
            header: 'ϵͳ��',
			allowBlank: false,
			width:150,
			editable:false,
			 hidden: true,
            dataIndex: 'SysNo'
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
  
	if((DataStatus2=='���ύ')&&(session['LOGON.GROUPDESC']!="���й���ϵͳ(��Ϣ�޸�)")){
		  itemGrid1.btnDeleteHide();//����ɾ����ť	
		};
			
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
			items: itemGrid1
		});	
		
	itemGrid1.load({params:{start:0,limit:25,RecDr:RecDr,SysNo:SysNo}});
	
	
		
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
}; 

