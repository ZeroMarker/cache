//����ؼ���ȫ�ֱ���
var IPURL = "http://127.0.0.1/dthealth/web/csp/";
////////�ҵ�����/////////////
var PrjTransaction=0;
var PaperTransaction=0;
var MonoTransaction=0;
var PrjAchTransaction=0;
var PatentTransaction=0;

/////////�ҵĿ���//////////////
var PrjMySRM = 0;
var prjMySRMArrived = 0;
var PrjMySRMCheck = 0;
var PaperMySRM = 0;
var MonoMySRM = 0;
var PrjAchSRM = 0;
var PatentSRM = 0;

var projUrl = 'herp.srm.SRMEnPaperPubRegexe.csp';
var HomePageUrl = 'herp.srm.srmhomepageexe.csp';

var userdr = session['LOGON.USERCODE'];  
/**
Ext.Ajax.request({				   	    			        
                     url: projUrl+'?action=GetJournalInfo',
					           success: function(result, request){
					         	 var jsonData = Ext.util.JSON.decode( result.responseText );  
						         if (jsonData.success=='true'){
							         var data = jsonData.info;	
							         var dataarr = data.split("^",-1);
							         var typename = dataarr[2];
							         var levelname = dataarr[3]; 			
							         //var ifs = dataarr[4];	   
                                      PrjTransaction = 12;	 									 
					         	}
				         	},
					       scope: this
				   	    });          
**/			
/* var SRMPanel = new Ext.form.FormPanel({
		region:'west',
		frame:true,
		layout: 'border',
		width:300,		
		items:[]
		}); */
///////////////////////////�ҵ�����///////////////////////xtype:'label',text///////////
var MyTransactionPanel = new Ext.form.FormPanel({
		title:'�ҵ�����',
		region:'west',
		frame:true,
		collapsible:true,
		width:320,
		//height:200,
        //minSize: 175,  
        //maxSize: 400,  
		reader: new Ext.data.JsonReader(
		//successProperty: 'success',
		{root:'rows'},             
		[{name:'rowid',mapping:'rowid'}, 
		{name:'name',mapping:'name'}
		]),
		//defaultType: 'textfield',
	    //defaults: {width:200},
		items:[
		  /* {
		  xtype:'textfield',
		  //xtype:'label',
		  width:200,
		  fieldLabel: '��Ʒ����',
		  name: 'rowid',
		  id: 'rowid',
		  //hidden: true,
		  allowBlank: false
	     }, */
		  {
			xtype: 'panel',
			layout:"column",
			height:25,
			hideLabel:true,
			isFormField:true,
			items:[
			        {xtype:'displayfield',columnWidth:.02},
					/* {name:'label1',id:'label1',xtype:'label',columnWidth:.98,html:'�������Ŀ'+'<a href="http://www.sina.com.cn" target="_blank"><span style="text-decoration:underline"><span style="color:#FF0000">'+PrjTransaction+'</span></span></a>'+'������'} */
					{xtype:'label',columnWidth:.3,html:'�������Ŀ'},
					{name:'prjnum',id:'prjnum',xtype:'displayfield',columnWidth:.05},
					{xtype:'label',columnWidth:.2,text:'������'}
				]
			}, {
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:25,
				isFormField:true,
				items:[
					{columnWidth:.02,xtype:'displayfield'},
					//{columnWidth:.1,xtype:'label',text: '���������15ƪ�����'}
					{xtype:'label',columnWidth:.3,html:'���������'},
					{name:'papernum',id:'papernum',xtype:'displayfield',columnWidth:.05},
					{xtype:'label',columnWidth:.2,text:'ƪ�����'}
				]
			},{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:25,
				isFormField:true,
				items:[
				    {columnWidth:.02,xtype:'displayfield'},
					//{columnWidth:.1,xtype:'label',text: '��ר��5�������'}
					{xtype:'label',columnWidth:.3,html:'��ר��'},
					{name:'monographnum',id:'monographnum',xtype:'displayfield',columnWidth:.05},
					{xtype:'label',columnWidth:.2,text:'�������'}
				]
			},{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:25,
				isFormField:true,
				items:[
				    {columnWidth:.02,xtype:'displayfield'},
					//{columnWidth:.1,xtype:'label',text: '���5ƪ�����'}
					{xtype:'label',columnWidth:.3,html:'���'},
					{name:'prjachinum',id:'prjachinum',xtype:'displayfield',columnWidth:.05},
					{xtype:'label',columnWidth:.2,text:'ƪ�����'}
				]
			},{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:25,
				isFormField:true,
				items:[
				    {columnWidth:.02,xtype:'displayfield'},
					//{columnWidth:.1,xtype:'label',text: '�������ɹ�(ר��5ƪ)'}
					{xtype:'label',columnWidth:.5,html:'�������ɹ�(ר��)'},
					{name:'patentnum',id:'patentnum',xtype:'displayfield',columnWidth:.05},
					{xtype:'label',columnWidth:.2,text:'������'},
				]
			}
		]
});


MyTransactionPanel.form.load({      
	  method:'POST',  
	  url: projUrl+'?action=GetJournalTypes&start=0&limit=10&str='+'Medline',
	  success:function(form,action){ //���سɹ��Ĵ�����  
                    MyTransactionPanel.load();  
                    
					 PrjTransaction=action.response.responseText;
					 var jsonData = Ext.util.JSON.decode( action.response.responseText )
					 var records = jsonData.rows;
					 PrjTransaction = records[0].rowid;
					 PaperTransaction = records[0].rowid;
					 MonoTransaction = records[0].rowid;
					 PrjAchTransaction = records[0].rowid;
					 PatentTransaction = records[0].rowid;
					 //prjnum.html=PrjTransaction;
					 //Ext.getCmp('label1').setText(PrjTransaction);
					 Ext.getCmp('prjnum').setValue('<a href="#" onclick = "getprjnum()" ><span style="text-decoration:underline"><span style="color:#FF0000">'+PrjTransaction+'</span></span></a>');
					 Ext.getCmp('papernum').setValue('<a href="#" onclick = "getpapernum()"  target="_blank"><span style="text-decoration:underline"><span style="color:#FF0000">'+PaperTransaction+'</span></span></a>');
					 Ext.getCmp('monographnum').setValue('<a href="#" onclick = "getmononum()"  target="_blank"><span style="text-decoration:underline"><span style="color:#FF0000">'+MonoTransaction+'</span></span></a>');
					 Ext.getCmp('prjachinum').setValue('<a href="#" onclick = "getprjachnum()"  target="_blank"><span style="text-decoration:underline"><span style="color:#FF0000">'+PrjAchTransaction+'</span></span></a>');
				     Ext.getCmp('patentnum').setValue('<a href="#" onclick = "getpatentnum()"  target="_blank"><span style="text-decoration:underline"><span style="color:#FF0000">'+PatentTransaction+'</span></span></a>');
                     //Ext.Msg.alert('��ʾ','find�ɹ�');  
                },  
                failure:function(form,action){          //����ʧ�ܵĴ�����  
                    Ext.Msg.alert('��ʾ','findʧ��');  
                }
	}); 


getprjnum = function(){
     var win = new Ext.Window({
	     title: '��������',
		 width: 400,
		 height: 400,
		 items:[queryPanel,itemGrid],
	}); 
	//window.location=IPURL+"herp.srm.SRMEnPaperRewAud.csp";
	//var prjdata = "|||||||"+userdr+"|";
    //itemGrid.load({params:{data:data,sortField:'', sortDir:'',start:0,limit:25}});      
    win.show();
};
getpapernum = function(){
	window.location=IPURL+"herp.srm.SRMEnPaperRewAud.csp";
};
getprjachnum = function(){
	window.location=IPURL+"herp.srm.auditprjachievement.csp";
};
getmononum = function(){
	window.location=IPURL+"herp.srm.monographrewardaudit.csp";
};
getpatentnum = function(){
	window.location=IPURL+"herp.srm.srmpatentrewardaudit.csp";
};
///////////////////////////�ҵĿ���//////////////////////////////////
var MySRMPanel = new Ext.form.FormPanel({
		title:'�ҵĿ���',
		region:'center',
		collapsible:true,
		frame:true,
		width:250,
		reader: new Ext.data.JsonReader(
		//successProperty: 'success',
		{root:'rows'},             
		[{name:'rowid',mapping:'rowid'}, 
		{name:'name',mapping:'name'}
		]),
		items:[{
			xtype: 'panel',
			layout:"column",
			height:25,
			hideLabel:true,
			isFormField:true,
			items:[
					{xtype:'displayfield',columnWidth:.02},
					/* {name:'label1',id:'label1',xtype:'label',columnWidth:.98,html:'�������Ŀ'+'<a href="http://www.sina.com.cn" target="_blank"><span style="text-decoration:underline"><span style="color:#FF0000">'+PrjTransaction+'</span></span></a>'+'������'} */
					{xtype:'label',columnWidth:.2,html:'�������Ŀ'},
					{name:'MySRMprjnum',id:'MySRMprjnum',xtype:'displayfield',columnWidth:.05},
					{xtype:'label',columnWidth:.2,text:'��'}
				]
			},{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:20,
				isFormField:true,
				items:[
					{xtype:'displayfield',columnWidth:.02},
					{xtype:'label',columnWidth:.2,html:'����е���'},
					{name:'MySRMprjArrived',id:'MySRMprjArrived',xtype:'displayfield',columnWidth:.05}
				]
			},{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:30,
				isFormField:true,
				items:[
					{xtype:'displayfield',columnWidth:.02},
					{xtype:'label',columnWidth:.2,html:'�����֧��'},
					{name:'MySRMprjCheck',id:'MySRMprjCheck',xtype:'displayfield',columnWidth:.05},
				]
			},{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:30,
				isFormField:true,
				items:[
					{xtype:'displayfield',columnWidth:.02},
					{xtype:'label',columnWidth:.2,html:'���������'},
					{name:'MySRMpapernum',id:'MySRMpapernum',xtype:'displayfield',columnWidth:.05},
					{xtype:'label',columnWidth:.2,text:'ƪ'}
				]
			},{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:30,
				isFormField:true,
				items:[
					{xtype:'displayfield',columnWidth:.02},
					{xtype:'label',columnWidth:.2,html:'�����ר��'},
					{name:'MySRMmonographnum',id:'MySRMmonographnum',xtype:'displayfield',columnWidth:.05},
					{xtype:'label',columnWidth:.2,text:'��'}
				]
			},
			{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:30,
				isFormField:true,
				items:[
					{xtype:'displayfield',columnWidth:.02},
					{xtype:'label',columnWidth:.3,html:'�������ɹ�(��'},
					{name:'MySRMprjachinum',id:'MySRMprjachinum',xtype:'displayfield',columnWidth:.05},
					{xtype:'label',columnWidth:.1,text:'��'},
					{xtype:'label',columnWidth:.1,html:'��ר��'},
					{name:'MySRMpatentnum',id:'MySRMpatentnum',xtype:'displayfield',columnWidth:.05},
					{xtype:'label',columnWidth:.1,text:'��)'}
				]
			}
		]
});
MySRMPanel.form.load({      
	  method:'POST',  
	  url: HomePageUrl+'?action=GetMySRM&start=0&limit=10&str='+'Medline',
	  success:function(form,action){ //���سɹ��Ĵ�����  
                    MySRMPanel.load();  
                    
					 //PrjTransaction=action.response.responseText;
					 var MySRMjsonData = Ext.util.JSON.decode( action.response.responseText )
					 var MySRMrecords = MySRMjsonData.rows;
					 PrjMySRM = MySRMrecords[0].rowid;
					 prjMySRMArrived = MySRMrecords[0].rowid;
					 PrjMySRMCheck = MySRMrecords[0].rowid;
					 PaperMySRM = MySRMrecords[0].rowid;
					 MonoMySRM = MySRMrecords[0].rowid;
					 PrjAchSRM = MySRMrecords[0].rowid;
					 PatentSRM = MySRMrecords[0].rowid;
					 //prjnum.html=PrjTransaction;
					 //Ext.getCmp('label1').setText(PrjTransaction);
					 Ext.getCmp('MySRMprjnum').setValue('<span style="color:#FF0000">'+PrjMySRM+'</span>');
					 Ext.getCmp('MySRMprjArrived').setValue('<span style="color:#FF0000">'+prjMySRMArrived+'</span>');
					 Ext.getCmp('MySRMprjCheck').setValue('<span style="color:#FF0000">'+PrjMySRMCheck+'</span>');
					 Ext.getCmp('MySRMpapernum').setValue('<span style="color:#FF0000">'+PaperMySRM+'</span>');
					 Ext.getCmp('MySRMmonographnum').setValue('<span style="color:#FF0000">'+MonoMySRM+'</span>');
					 Ext.getCmp('MySRMprjachinum').setValue('<span style="color:#FF0000">'+PrjAchSRM+'</span>');
				     Ext.getCmp('MySRMpatentnum').setValue('<span style="color:#FF0000">'+PatentSRM+'</span>');
                     //Ext.Msg.alert('��ʾ','find�ɹ�');  
                },  
                failure:function(form,action){          //����ʧ�ܵĴ�����  
                    Ext.Msg.alert('��ʾ','MySRMfindʧ��');  
                }
	}); 
///////////////////////////���ж�̬//////////////////////////////////
var SRMDynamicPanel = new Ext.form.FormPanel({
        //title :'���ж�̬',
		region:'south',
		defaults:{
		collapsible:true,
		autoScroll : true
		},
		//collapsible:true,
		height:320,
		layout:'border',
		//html:'<div id="mychartdiv"></div>'
		items:[
		{
		title:'���ж�̬',
		//collapsible:true,
		html:'<div id="mychartdiv"></div>',
		region:'center'
		},
		{
		title:'ϵͳ��Ϣ',
		//collapsible:true,
		//html:'<div id="mychartdiv"></div>',
		region:'east',
		width:350
		}
		]
});

Ext.Ajax.request({
	           url: HomePageUrl+'?action=GetChartTotal&userdr='+userdr,				
	           async:false,
	           success:function (response){ 
	           json = response.responseText;
	           jsonData = Ext.util.JSON.decode(json);   
	           var a = jsonData.rows;
	           //var data = json.split("^")
	           //var a = Ext.util.JSON.decode(data[0]).rows;
	           //var b = Ext.util.JSON.decode(data[1]).rows; 
	           //var c = Ext.util.JSON.decode(data[2]).rows; 
	           //var d = Ext.util.JSON.decode(data[3]).rows;
	           //alert(a+b+c+d)
	           
	           var  myChart6 = new FusionCharts("../scripts/herpg/Charts/swf/MSColumn2D.swf", "myChat6","500", "350", "0", "1");  
	           myChart6.setJSONData({      
             	chart:{      
                    caption:"��һ����гɹ���̬",     
                    //xaxisname:"hjb",     
                    yaxisname:"����",    
                    showvalues:1,
                    showname:1,      
                    //numberprefix:"��",
                    //labelDisplay:"WRAP",
                    exportAction:'download',
                    exportEnabled:1,
                    exportAtClient:1,
                    exportHandler:"FCExporter"  }, 
                    categories:[{  "category":a }  
               		],      
            		dataset:[        
                           	  {   "data":a  },
                  
            		 ] 
            	}); 
                myChart6.render("mychartdiv");
	           },
	           scope:this
	       })
///////////////////////////��Ϣ��Ԥ��//////////////////////////////////
var SRMNewsPanel = new Ext.form.FormPanel({
		region:'east',
		width:350,
		collapsible:true,
		title:'��Ϣ��Ԥ��'
});
