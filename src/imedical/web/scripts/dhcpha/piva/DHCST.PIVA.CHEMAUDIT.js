

//��ʾ����
Ext.onReady(function() {

        Ext.QuickTips.init();// ������Ϣ��ʾ

        Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
      	         
        var orditem = ExtOrdItem ; 
		//var adm=tkMakeServerCall("web.DHCSTPIVA", "GetAdmByOeori",orditem);
		var PatInfo=tkMakeServerCall("web.DHCSTPIVA", "GetPatIDByOeori",orditem);
		var PatArr=PatInfo.split("^");
		PatInfo =  {
			adm: PatArr[1],
			patientID:PatArr[0],
			episodeID:PatArr[1],
			orditem:orditem

	    };


		   //����load Tab,����������
		var HrefRefresh = function (){

				var adm=PatInfo.adm; 
				
				var patientID=PatInfo.patientID; 
				var episodeID=PatInfo.episodeID; 
				var orditem=PatInfo.orditem;
		
				var p = Ext.getCmp("CenterTabPanel").getActiveTab();	
				var iframe = p.el.dom.getElementsByTagName("iframe")[0];
				
				if (p.id=="framepatinfo"){
				  iframe.src = p.src + '?orditem=' + orditem ;
				}

				if (p.id=="framepaallergy"){
				  iframe.src = p.src + '?PatientID=' + patientID +'&EpisodeID='+ adm + '&PARREF=' + patientID + '&PatientBanner=1';
				}
				
				if (p.id=="framerisquery"){
				 iframe.src = p.src + '?PatientID=' + patientID +'&EpisodeID='+ adm ;
				}
				
				if (p.id=="framelabquery"){
				  iframe.src = p.src + '?PatientID=' + patientID +'&EpisodeID='+ adm +'&NoReaded='+'1';
				}
				
				if (p.id=="frameprbrowser"){
				  iframe.src='emr.record.browse.csp?EpisodeID='+ adm;
				}	

			
	    }
	  

		var centerform = new Ext.TabPanel({
			id:'CenterTabPanel',
			region: 'center',
			margins:'3 3 3 3', 
			frame:false,
			activeTab: 0,
			items:[{
						title: '������Ϣ',	
						frameName: 'framepatinfo',
						html: '<iframe id="framepatinfo" width=100% height=100% src=DHCST.PIVA.PATINFO.csp></iframe>',		
						src: 'DHCST.PIVA.PATINFO.csp',
						id:'framepatinfo'
		
			},{
						title: '������¼',	
						frameName: 'framepaallergy',
						html: '<iframe id="paallergyFrame" width=100% height=100% src=dhcpha.comment.paallergy.csp></iframe>',		
						src: 'dhcpha.comment.paallergy.csp',
						id:'framepaallergy'
		
			},{
						title: '����¼',
						frameName: 'framerisquery',
						html: '<iframe id="framerisquery" width=100% height=100% src=dhcpha.comment.risquery.csp></iframe>',		
						src: 'dhcpha.comment.risquery.csp',
						id:'framerisquery'
			   
		
			},{
						title: '�����¼',
						frameName: 'framelabquery',
						html: '<iframe id="framelabquery" width=100% height=100% src=dhcpha.comment.labquery.csp></iframe>',		
						//src: 'dhcpha.comment.labquery.csp', //�ɰ�
						src: 'jquery.easyui.dhclaborder.csp',
						id:'framelabquery'
			   
		
			},{
						title: '�������',
						frameName: 'frameprbrowser',
						html: '<iframe id="frmeprbrowser" width=100% height=100% src=emr.record.browse.csp></iframe>',		
						src: 'emr.record.browse.csp',
						id:'frameprbrowser'
			}],
			listeners:{ 
						tabchange:function(tp,p){ 
							 HrefRefresh() ;
							} 
									
					 }
			
		});



     
        var port = new Ext.Viewport({

				layout : 'border',

				items : [centerform]

			});




    
});