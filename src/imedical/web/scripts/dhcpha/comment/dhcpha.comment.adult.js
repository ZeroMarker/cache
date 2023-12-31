///处方点评主界面JS
///Creator:LiangQiang
///CreatDate:2012-05-20


var unitsUrl = 'dhcpha.comment.main.save.csp';

var comwidth=120;
var ruleformwd=800;


Ext.onReady(function() {

  Ext.QuickTips.init();// 浮动信息提示
  Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
  
      
 ///定义医生科室
	
  var ComBoDocLocDs = new Ext.data.Store({
		autoLoad: true,
		proxy:"",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'DocLocID'},['DocLocDesc','DocLocID'])
				
	});


  ComBoDocLocDs.on(
	'beforeload',
	function(ds, o){
	
		ds.proxy = new Ext.data.HttpProxy({url:unitsUrl+'?action=GetDocLocDs', method:'GET'});
	
	}
  );

  var DocLocSelecter = new Ext.ux.form.LovCombo({
		fieldLabel:'医生科室',
		id:'DocLocSelecter',
		name:'DocLocSelecter',
		store : ComBoDocLocDs,
		width:comwidth,
		listWidth : 250,
		emptyText:'选择医生科室...',
		hideOnSelect : false,
		hiddenName:'doclocstr',
		maxHeight : 300,	
		valueField : 'DocLocID',
		displayField : 'DocLocDesc',
		triggerAction : 'all',
		mode:'local'

				
	});
	
	
 
  ///定义药品名称
	
	var ComBoIncitmDs = new Ext.data.Store({
		//autoLoad: true,
		//proxy : new Ext.data.HttpProxy({
		//	url : unitsUrl
		//			+ '?action=GetIncitmDs&start=0&limit=50&searchItmValue=',
		//	method : 'POST'
		//}),
		proxy : '',
		reader : new Ext.data.JsonReader({
					totalProperty : "results",
					root : 'rows',
					id : 'rowId'
				}, ['rowId', 'itmcode', 'itmdesc'])

	});
	
	
	
	 var tpl =  new Ext.XTemplate(
	'<table cellpadding=2 cellspacing = 1><tbody>',
	'<tr><th style="font-weight: bold; font-size:15px;">药品名称</th><th style="font-weight: bold; font-size:15px;">编码</th><th style="font-weight: bold; font-size:15px;">ID</th></tr>',
	'<tpl for=".">',
	'<tr class="combo-item">',
	'<td style="width:500; font-size:15px;">{itmdesc}</td>',
	'<td style="width:20%; font-size:15px;">{itmcode}</td>',
	'<td style="width:50; font-size:15px;">{rowId}</td>',
	'</tr>',
	'</tpl>', '</tbody></table>');
	

	var IncitmSelecter = new Ext.form.ComboBox({
				id : 'InciSelecter',
				fieldLabel : '药品名称',
				store : ComBoIncitmDs,
				valueField : 'rowId',
				displayField : 'itmdesc',
				//typeAhead : true,
				pageSize : 50,
				//minChars : 1,
				width:comwidth,
				// heigth : 150,
				autoHeight:true,
				listWidth : 550,
				triggerAction : 'all',
				emptyText : '选择药品名称...',
				//allowBlank : false,
				name : 'IncitmSelecter',
				selectOnFocus : true,
				forceSelection : true,
				tpl: tpl,
    				itemSelector: 'tr.combo-item',
				listeners : {
				
				        
				        specialKey :function(field,e){
				        
                                        if (e.getKey() == Ext.EventObject.ENTER) {
                                               
                                             	ComBoIncitmDs.proxy = new Ext.data.HttpProxy({
										url : unitsUrl
												+ '?action=GetIncitmDs&searchItmValue='
												+ Ext.getCmp('InciSelecter').getRawValue(),
										method : 'POST'
									})
							ComBoIncitmDs.reload({
										params : {
											start : 0,
											limit : IncitmSelecter.pageSize
										}
									});
                                        
                                                     }					
				                }
				               
			         }

	});
	
	
	
  var StDateField=new Ext.form.DateField ({
               
                xtype: 'datefield',
                format:'j/m/Y' ,
                fieldLabel: '开始日期',
                name: 'startdt',
                id: 'startdt',
                invalidText:'无效日期格式,正确格式是:日/月/年,如:15/02/2011',
                width : comwidth,
                value:new Date
            })	
            
            
            
  var EndDateField=new Ext.form.DateField ({
                format:'j/m/Y' ,
                fieldLabel: '截止日期',
	        name: 'enddt',
	        id: 'enddt',
	        width : comwidth,
	        value:new Date
            })
   
   
  var RandomNumField=new Ext.form.TextField({
  
        width : comwidth, 
        id:"RandomNumField", 
        fieldLabel:"随机数" 
        })
    

  var AgeField=new Ext.form.TextField({
  
        width : comwidth, 
        id:"agetxt", 
        fieldLabel:"患者年龄" 
        })
        
  Ext.getCmp("agetxt").setValue(">15岁");  //
        
       
  var SaveButton = new Ext.Button({
             width : 65,
             id:"SaveButton",
             text: '生成点评单',
             listeners:{
                          "click":function(){   
                             
                              SaveClick();
                              
                              }   
             }
             
             })       
         
         ///类型 
        var OpTypeData=[['门诊','1'],['急诊','2'],['全部','3']];
	 
	 
	var OpTypestore = new Ext.data.SimpleStore({
		fields: ['optypedesc', 'optypeid'],
		data : OpTypeData
		});

	var OpTypeCombo = new Ext.form.ComboBox({
		store: OpTypestore,
		displayField:'optypedesc',
		mode: 'local', 
		width : comwidth,
		id:'OptypeCmb',
		emptyText:'',
		valueField : 'optypeid',
		hiddenName:'optypeid',
		emptyText:'选择类型...',
		fieldLabel: '类型'
	});  
	
	Ext.getCmp("OptypeCmb").setValue("门诊");  //
	
	///医生
	
	 var ComBoDocDs = new Ext.data.Store({
		autoLoad: true,
		proxy : new Ext.data.HttpProxy({
			url : unitsUrl
					+ '?action=GetDoctorDs',
			method : 'POST'
		}),
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'doctordr'},['docname','doctordr'])
				
	});

	var DoctorCombo = new Ext.form.ComboBox({
		store: ComBoDocDs,
		displayField:'docname',
		mode: 'local', 
		width : comwidth,
		id:'DoctorCmb',
		emptyText:'',
		valueField : 'doctordr',
		emptyText:'选择医生...',
		fieldLabel: '医生'
	}); 
	
	
	
	
  ///定义管制分类
	
  var ComCtrlDs = new Ext.data.Store({
		autoLoad: true,
		proxy:"",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'CtrlID'},['CtrlDesc','CtrlID'])
				
	});


  ComCtrlDs.on(
	'beforeload',
	function(ds, o){
	
		ds.proxy = new Ext.data.HttpProxy({url:unitsUrl+'?action=GetComBoCtrlDs', method:'GET'});
	
	}
  );

  var ComCtrl = new Ext.ux.form.LovCombo({
		fieldLabel:'管制分类',
		id:'ComCtrlID',
		name:'ComCtrlID',
		store : ComCtrlDs,
		width : comwidth,
		listWidth : 250,
		//emptyText:'选择管制分类...',
		hideOnSelect : false,
		hiddenName:'poisonstr',
		maxHeight : 300,	
		valueField : 'CtrlID',
		displayField : 'CtrlDesc',
		triggerAction : 'all',
		mode:'local'
		


				
	});

            
	
  var RuleForm = new Ext.Panel({
                                title:'抽取成人处方规则',
                                labelWidth : 80,
				region : 'center',
				frame : true,
				height:400,
				width :ruleformwd,
				//collapsible: true,
				//frame:false,
				items : [{
							layout : "column",
							items : [{
							                        labelAlign : 'right',
										columnWidth : .33,
										layout : "form",
										items : [   StDateField  ]
									}, {
									        labelAlign : 'right',
										columnWidth : .33,
										layout : "form",
										items : [   EndDateField  ]
									    
										
								        },{
								        
								                labelAlign : 'right',
										columnWidth : .33,
										layout : "form",
										items : [  RandomNumField ]
										
								        }
								        
								        
				                                 ]
								   
								   
								   
								   
					},{
					
					
							layout : "column",
							items : [{
							                        labelAlign : 'right',
										columnWidth : .33,
										layout : "form",
										items : [  DocLocSelecter   ]
									}, {
									        labelAlign : 'right',
										columnWidth : .33,
										layout : "form",
										items : [  ComCtrl  ]
									    
										
								        },{
								                labelAlign : 'right',
										columnWidth : .33,
										layout : "form",
										items : [ OpTypeCombo  ]	    
										
								        }	
								        
								   ]
					
					    },{
					
					
							layout : "column",
							items : [{
							                        labelAlign : 'right',
										columnWidth : .33,
										layout : "form",
										items : [ AgeField     ]
									}, {
									        labelAlign : 'right',
										columnWidth : .33,
										layout : "form",
										items : [      ]
									    
										
								        },{
								                labelAlign : 'right',
										columnWidth : .33,
										layout : "form",
										items : [   ]	    
										
								        }	
								        
								   ]
					
					    }
					    
					 
					

					
					
					
					]

			});
			
			
	
   var QueryForm = new Ext.Panel({
      region : 'center',
      frame : true,
      items : [RuleForm]
      
   })
   
   	



     
     

      var port = new Ext.Viewport({

				layout : 'fit',

				items : [QueryForm]

			});


////-----------------Events-----------------///



function SaveClick()
{

    var p = Ext.getCmp("TabPanel").getActiveTab();
    if (p.id=="P"){
           rnum=Ext.getCmp("RandomNumField").getRawValue(); 
           pcent=Ext.getCmp("PercentageField").getRawValue(); 
           if ((rnum=="")&&(pcent=="")){
              Ext.Msg.show({title:'注意',msg:'请先填写随机数或随机比!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO}); 
              return;
           }
           
          Ext.MessageBox.confirm('注意', '确认要生成普通处方点评单吗 ? ',SaveCommentData);
    }
    
    if (p.id=="K"){
    
          doccent=Ext.getCmp("DocCentField").getRawValue();
          if (doccent==""){
              Ext.Msg.show({title:'注意',msg:'请先填写医生比例!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO}); 
              return;
          }
          if (doccent>60){
              Ext.Msg.show({title:'注意',msg:'比例不能大于60!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO}); 
              return;
          }
          presccent=Ext.getCmp("PrescCentField").getRawValue();
          if (presccent==""){
              Ext.Msg.show({title:'注意',msg:'请先填写处方数量!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO}); 
              return;
          }
          if (presccent>60){
              Ext.Msg.show({title:'注意',msg:'处方数量不能大于60!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO}); 
              return;
          } 
          
          Ext.MessageBox.confirm('注意', '确认要生成普通处方点评单吗 ? ',SaveKCommentData);
           
    }
     
}


function SaveCommentData(btn)
{
                if (btn=="no"){ return ;}
                var p = Ext.getCmp("TabPanel").getActiveTab();
                var waycode=p.id; //方式
                var sdate=Ext.getCmp("startdt").getRawValue();       
                var edate=Ext.getCmp("enddt").getRawValue();
                var doclocdr=Ext.getCmp("DocLocSelecter").getValue();  //科室
                var inci=Ext.getCmp("InciSelecter").getValue(); //药品
                var rnum=Ext.getCmp("RandomNumField").getValue();  //随机数
                var cent=Ext.getCmp("PercentageField").getValue();  //百分比  
                var optype=Ext.getCmp("OptypeCmb").getValue(); //操作类型
                var doctordr=Ext.getCmp("DoctorCmb").getValue(); //医生
                var ctrlstr=Ext.getCmp("ComCtrlID").getValue(); //管制分类

                var parstr=sdate+"^"+edate+"^"+doclocdr+"^"+inci+"^"+rnum+"^"+cent+"^"+optype+"^"+doctordr+"^"+ctrlstr+"^"+waycode ;
                var User=session['LOGON.USERID'] ;
                
	  	Ext.Ajax.request({
	
	        url:unitsUrl+'?action=SaveCommentData&User='+User+'&ParStr='+parstr,
	
		waitMsg:'系统处理中...',
		failure: function(result, request) {
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {

			var jsonData = Ext.util.JSON.decode( result.responseText );
                        		
			//alert(jsonData.retvalue)
			//alert(jsonData.retinfo)	
			
			if (jsonData.retvalue==0){
			  msgtxt="生成成功";
			}else{
			  msgtxt=jsonData.retinfo;
			}			  	 
	  		
	  		Ext.Msg.show({title:'提示',msg:msgtxt,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});

		},
		
			scope: this
		});
		
		
    
}


///抗生素专项
function SaveKCommentData(btn)
{
                if (btn=="no"){ return ;}
                var p = Ext.getCmp("TabPanel").getActiveTab();
                var waycode=p.id; //方式
                var sdate=Ext.getCmp("ksdt").getRawValue();       
                var edate=Ext.getCmp("kedt").getRawValue();
                var doccent=Ext.getCmp("DocCentField").getRawValue();  //医生比例
                var presccent=Ext.getCmp("PrescCentField").getRawValue();  //处方张数
                var poisonstr=Ext.getCmp("ComBoCtrlID").getValue();  //管制分类

                var parstr=sdate+"^"+edate+"^"+doccent+"^"+presccent+"^"+poisonstr+"^"+waycode ;
                var User=session['LOGON.USERID'] ;
                
	  	Ext.Ajax.request({
	
	        url:unitsUrl+'?action=SaveKCommentData&User='+User+'&ParStr='+parstr,
	
		waitMsg:'系统处理中...',
		failure: function(result, request) {
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {

			var jsonData = Ext.util.JSON.decode( result.responseText );
                        		
			//alert(jsonData.retvalue)
			//alert(jsonData.retinfo)	
			
			if (jsonData.retvalue==0){
			  msgtxt="生成成功";
			}else{
			  msgtxt=jsonData.retinfo;
			}			  	 
	  		
	  		Ext.Msg.show({title:'提示',msg:msgtxt,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});

		},
		
			scope: this
		});
		
		
    
}




	


});

