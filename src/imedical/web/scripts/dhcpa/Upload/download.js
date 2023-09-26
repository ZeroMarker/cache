//downloadMainFun=function(ItemGrid,rowidIndex,ColNum){
    /*alert("cccccc");
	ItemGrid.on('cellclick',function( g, rowIndex, columnIndex, e ){
	
		if(columnIndex==ColNum){
		
		//document.write(returnCitySN["cip"]);
		//alert($("#ip"));
		
		
		var tmpRec=ItemGrid.getStore().data.items[rowIndex];
	 
		var UDRDDr=tmpRec.data[rowidIndex];   //上传记录ID
			var DataStatus2=tmpRec.data['DataStatus'];				
		
		  //return '<span style="color:gray;cursor:hand">下载</span>';	
			                  
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
	           			 Ext.Msg.show({title:'警告',msg:'链接失败！！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
	       				
	       				 }
       				 },
       				 
        			failure : function() {
	        			Ext.Msg.show({title:'警告',msg:'FTP链接失败！！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
       					 } 
  			  		});
	 } 
   
downloadFun = function(UDRDDr,itemGrid) {
	
/*if(window.location.hostname=="192.168.120.8")
{FtpURL="ftp://192.168.120.8";}
else{FtpURL="ftp://192.168.99.107";}*/

FtpURL=downloadUrl;
var itemGrid1 = new dhc.herp.Gridly({
        //title: '期刊定义',
        width: 400,
        //edit:false,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'dhc.pa.uploadexe.csp',	  
		//tbar:delButton,
		atLoad : false, // 是否自动刷新
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
            header: '文件描述',
			allowBlank: false,
			width:260,
			editable:false,
            dataIndex: 'FileName'
        },{
            id:'UploadDate',
            header: '上传时间',
			allowBlank: false,
			width:100,
			editable:false,
            dataIndex: 'UploadDate'
        },{
            id:'UploadUser',
            header: '上传人',
			allowBlank: false,
			width:100,
			editable:false,
            dataIndex: 'UploadUser'
        },{
            id:'download',
            header: '下载',
			allowBlank: false,
			width:80,
			editable:false,
            dataIndex: 'download',
			renderer : function(v, p, r){
				a=r.get("FileURL");
				return '<a href="###" onclick="downFile(FtpURL)">下载</a>';
			
			  //return '<a href="###" onclick="javascript:downloadFile(FtpURL);">下载</a>';
			   //return '<span style="color:blue"><u>下载</u></span>';
			   //return '<a href="###" onclick="javascript:window.location.href(FtpURL+a);">下载</a>';
			  
			   //return '<a href="###" onclick="javascript:window.open(FtpURL+a);">下载</a>';
	                        
					}
				
			
        },{
            id:'FileURL',
            header: '文件路径',
			allowBlank: false,
			width:150,
			editable:false,
			hidden: true,
            dataIndex: 'FileURL'
        }
		] 
});



  itemGrid1.btnAddHide();     //隐藏增加按钮
  itemGrid1.btnSaveHide();    //隐藏保存按钮
  //itemGrid.btnResetHide();   //隐藏重置按钮
  
	/*if((DataStatus2=='已提交')&&(session['LOGON.GROUPDESC']!="科研管理系统(信息修改)")){
		  itemGrid1.btnDeleteHide();//隐藏删除按钮	
		};*/
	// 初始化取消按钮
	var cancelButton = new Ext.Toolbar.Button({ text : '关闭'});
	// 定义取消按钮的响应函数
	cancelHandler = function(){ 
	  dlwin.close();
	};
	// 添加取消按钮的监听事件
	cancelButton.addListener('click', cancelHandler, false);
	
			
dlwin = new Ext.Window({
			title: '附件下载',
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
			    
			}else {Ext.Msg.show({title:'警告',msg:'没有上传数据！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}	
			
			
			});
	
	itemGrid1.on('cellclick', function(g, rowIndex, columnIndex, e) {
	
	if (columnIndex == 5) {
		var tmpRec=itemGrid1.getStore().data.items[rowIndex];
	 
		var FileURL=tmpRec.data['FileURL'];
		

		window.open(FtpURL+FileURL);
		//return '<a href="###" onclick="javascript:window.open(FtpURL+FileURL);">下载</a>';
		//return '<a href="###" onclick="javascript:window.location.href(FtpURL+FileURL);">下载</a>';
		//window.location.href=FtpURL+FileURL;


	}
});

	
};
//}; 

