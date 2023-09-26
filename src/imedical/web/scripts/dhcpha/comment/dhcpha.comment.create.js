///处方点评主界面JS
///Creator:LiangQiang
///CreatDate:2012-05-20



Ext.onReady(function() {

     
     
     Ext.QuickTips.init();// 浮动信息提示

	 Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

    
     var tabs = new Ext.TabPanel({

	    region: 'center',
	    margins:'3 3 3 0', 
	    activeTab: 0,
	    id:'TabPanel'
	});
	

     var pageUrlList = pageUrl.split("#");
     
     for (var i = 0; i < pageUrlList.length ; i++)
     {
          var urlDetial = pageUrlList[i].split('^');
          var urldesc = urlDetial[0];
	  var urlid = urlDetial[1];


          if (urlid=="P")
	  {
		    tabs.add({
					border: false,
					title: urldesc,
					id: urlid,
					layout: 'fit',
					closable: false,
					autoScroll: true,
					html: '<iframe id="antimicrobial" width=100% height=100% src=dhcpha.comment.create.general.csp></iframe>',
					src: 'dhcpha.comment.create.antimicrobial.csp'
			}).show();
		
	  }
	 
	 /*
	  if (urlid=="K")
	  {
		    tabs.add({
					border: false,
					title: urldesc,
					id: urlid,
					layout: 'fit',
					closable: false,
					autoScroll: true,
					html: '<iframe id="antimicrobial" width=100% height=100% src=dhcpha.comment.create.antimicrobial.csp></iframe>',
					src: 'dhcpha.comment.create.antimicrobial.csp'
			}).show();
		
	  }
	  
	  
	  
	 
	 
	 
	
	  if (urlid=="C")
	  {
		    tabs.add({
					border: false,
					title: urldesc,
					id: urlid,
					layout: 'fit',
					closable: false,
					autoScroll: true,
					html: '<iframe id="adult" width=100% height=100% src=dhcpha.comment.create.adult.csp></iframe>',
					src: 'dhcpha.comment.create.adult.csp'
			}).show();
		
	 }
	 */
	
	
	
		
     }
    	
	
	

     
     var centerPanel = new Ext.Panel({
         region: 'center',       
         //title: '生成点评单',
         //width: 650,
         layout:'fit',		 
         items : [  ]
 
     });
     
     
     

      var port = new Ext.Viewport({

				layout : 'fit',

				items : [centerPanel]

			});







});

