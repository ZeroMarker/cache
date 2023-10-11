var comboboxDep = new Ext.form.ComboBox({
	fieldLabel:'科室',
	labelWidth:10,
	name:'comboboxDep',
	id:'comboboxDep',
	store:new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:"../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'results',
			fields:[{
				'name':'ctlocDesc',
				'mapping':'ctlocDesc'
			}, {
				'name':'CtLocDr',
				'mapping':'CtLocDr'
			}]
		}),
		baseParams:{
			className:'web.DHCMgNurCareTeamBuild',
			methodName:'SearchComboDep',
			type:'Query'
		}
	}),
	tabIndex:'0',
	listWidth:'220',
	x:5,y:3,
	height:18,
	width:200,
	xtype:'combo',
	displayField:'ctlocDesc',
	valueField:'CtLocDr',
	hideTrigger:false,
	queryParam:'ward1',
	forceSelection:true,
	triggerAction:'all',
	minChars:1,
	pageSize:1000,
	typeAhead:true,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
function BodyLoadHandler() {
	comboboxDep.store.on('beforeLoad',function(){
  	var pward=comboboxDep.lastQuery;
		var nurseString=session['LOGON.USERID']+"^"+session['LOGON.GROUPDESC'];
    comboboxDep.store.baseParams.typ="1";
    comboboxDep.store.baseParams.ward1=pward;        
		comboboxDep.store.baseParams.nurseid=nurseString;
  });
  var comboboxDepStore=Ext.getCmp("comboboxDep").getStore();
	comboboxDepStore.load({params:{start:0,limit:5000}});
	var getNurseDep=document.getElementById('getNurseDep');
		var nurseVal=cspRunServerMethod(getNurseDep.value,session['LOGON.USERCODE']);
		comboboxDepStore.on('load',function(comboboxDepStore,records,options){
			comboboxDep.selectText();
			comboboxDep.setValue(nurseVal);
		});
		comboboxDep.disable();
	var gform=Ext.getCmp('gform');
	var ret=""
	var formPanel =new Ext.form.FormPanel({
      x:0,y:0,
      width:document.body.offsetWidth,
      height:document.body.offsetHeight,
      bodyStyle:'padding:5px 5px 0',
      id:'formPanel',
      renderTo:Ext.getBody(),
      frame:true,
      labelAlign:'left',
      autoScroll:true,
      layout:'form',
      defaults:{defaults:{anchor:'100%'}},
      items:[{
      	id:'text1',text:'为进一步贯彻落实办院理念，构建和谐护理团队，了解广大护理人员所在科室团队建设情况,护理部开展此次调查。目的是为了加强管理,改进工作，从而把科室这个小家和医院这个大家建设的更好。',width:'620',xtype:'label'
      },{},
      {
      	id:'text2',text:'请根据您自己的真实感受，针对每个问题按照以下五个等级进行评定，5=完全同意  4=同意  3=一般  2=不同意 1=完全不同意。谢谢！',width:'620',xtype:'label'
      },{},
      	comboboxDep,{},{
      		id:'label1',text:'1、科室护理管理有序',width:500,xtype:'label'	
      	},{},
      new Ext.form.RadioGroup({
		  	id:'Item1',hideLabel: true,x:10,y:0,width:500,
		    items:[{
		    	boxLabel:'完全不同意',inputValue:'1',name:'rg1',id:'Item1_1'
		    },{
		    	boxLabel:'不同意',inputValue:'2',name:'rg1',id:'Item1_2'
		    },{
		    	boxLabel:'一般',inputValue:'3', name:'rg1',id:'Item1_3'
		    },{
		    	boxLabel:'同意',inputValue:'4',name:'rg1',id:'Item1_4'
		    },{
		    	boxLabel:'完全同意',inputValue:'5',name:'rg1',id:'Item1_5'
		    }]
		  }),{
	    	id:'label2',text:'2、科室质量高，患者满意',width:500,xtype:'label'
      },{},
      new Ext.form.RadioGroup({
		  	id:'Item2',hideLabel: true,x:10,y:0,width:500,
		    items:[{
		    	boxLabel:'完全不同意',inputValue:'1',name:'rg2',id:'Item2_1'
		    },{
		    	boxLabel:'不同意',inputValue:'2',name:'rg2',id:'Item2_2'
		    },{
		    	boxLabel:'一般',inputValue:'3',name:'rg2',id:'Item2_3'
		    },{
		    	boxLabel:'同意',inputValue:'4',name:'rg2',id:'Item2_4'
		    },{
		    	boxLabel:'完全同意',inputValue:'5',name:'rg2',id:'Item2_5'
		    }]
		  }),{
		  	id:'label3',text:'3、科室质量高，医生满意',width:500,xtype:'label'
		  },{},
	  	new Ext.form.RadioGroup({
		  	id:'Item3',hideLabel: true,x:10,y:0,width:500,
		    items:[{
		    	boxLabel:'完全不同意',inputValue:'1',name:'rg3',id:'Item3_1'
		    },{
		    	boxLabel:'不同意',inputValue:'2',name:'rg3',id:'Item3_2'
		    },{
		    	boxLabel:'一般',inputValue:'3',name:'rg3',id:'Item3_3'
		    },{
		    	boxLabel:'同意',inputValue:'4',name:'rg3',id:'Item3_4'
		    },{
		    	boxLabel:'完全同意',inputValue:'5',name:'rg3',id:'Item3_5'
		    }]
		  }),{},{
		  	id:'label4',text:'4、护理团队工作效率高',width:500,xtype:'label'
		  },{},
		  new Ext.form.RadioGroup({
		  	id:'Item4',hideLabel: true,x:10,y:0,width:500,
		    items:[{
		    	boxLabel:'完全不同意',inputValue:'1',name:'rg4',id:'Item4_1'
		    },{
		    	boxLabel:'不同意',inputValue:'2',name:'rg4',id:'Item4_2'
		    },{
		    	boxLabel:'一般',inputValue:'3',name:'rg4',id:'Item4_3'
		    },{
		    	boxLabel:'同意',inputValue:'4', name:'rg4',id:'Item4_4'
		    },{
		    	boxLabel:'完全同意',inputValue:'5',name:'rg4',id:'Item4_5'
		    }]
		  }),{},{
		  	id:'label5',text:'5、护理团队凝聚力强',width:500,xtype:'label'
		  },{},
		  new Ext.form.RadioGroup({
		  	id:'Item5',hideLabel: true,x:10,y:0,width:500,
		    items:[{
		    	boxLabel:'完全不同意',inputValue:'1',name:'rg5',id:'Item5_1'
		    },{
		    	boxLabel:'不同意',inputValue:'2',name:'rg5',id:'Item5_2'
		    },{
		    	boxLabel:'一般',inputValue:'3',name:'rg5',id:'Item5_3'
		    },{
		    	boxLabel:'同意',inputValue:'4',name:'rg5',id:'Item5_4'
		    },{
		    	boxLabel:'完全同意',inputValue:'5',name:'rg5',id:'Item5_5'
		    }]
		  }),{},{
		  	id:'label6',text:'6、护士之间关系融洽',width:500,xtype:'label'	
		  },{},
		  new Ext.form.RadioGroup({
		  	id:'Item6',hideLabel: true,x:10,y:0,width:500,
		    items:[{
		    	boxLabel:'完全不同意',inputValue:'1',name:'rg6',id:'Item6_1'
		    },{
		    	boxLabel:'不同意',inputValue:'2',name:'rg6',id:'Item6_2'
		    },{
		    	boxLabel:'一般',inputValue:'3',name:'rg6',id:'Item6_3'
		    },{
		    	boxLabel:'同意',inputValue:'4',name:'rg6',id:'Item6_4'
		    },{
		    	boxLabel:'完全同意',inputValue:'5',name:'rg6',id:'Item6_5'
		    }]
		  }),{},{
		  	id:'label7',text:'7、医护之间关系融洽',width:500,xtype:'label'	
		  },{},
		  new Ext.form.RadioGroup({
		  	id:'Item7',hideLabel: true,x:10,y:0,width:500,
		    items:[{
		    	boxLabel:'完全不同意',inputValue:'1',name:'rg7',id:'Item7_1'
		    },{
		    	boxLabel:'不同意',inputValue:'2',name:'rg7',id:'Item7_2'
		    },{
		    	boxLabel:'一般',inputValue:'3',name:'rg7',id:'Item7_3'
		    },{
		    	boxLabel:'同意',inputValue:'4',name:'rg7',id:'Item7_4'
		    },{
		    	boxLabel:'完全同意',inputValue:'5', name:'rg7',id:'Item7_5'
		    }]
		  }),{},{
		  	id:'label8',text:'8、及时传达医院及护理部的指示精神',width:500,xtype:'label'	
		  },{},
		  new Ext.form.RadioGroup({
		  	id:'Item8',hideLabel: true,x:10,y:0,width:500,
		    items:[{
		    	boxLabel:'完全不同意',inputValue:'1',name:'rg8',id:'Item8_1'
		    },{
		    	boxLabel:'不同意',inputValue:'2',name:'rg8',id:'Item8_2'
		    },{
		    	boxLabel:'一般',inputValue:'3',name:'rg8', id:'Item8_3'
		    },{
		    	boxLabel:'同意',inputValue:'4',name:'rg8',id:'Item8_4'
		    },{
		    	boxLabel:'完全同意', inputValue:'5',name:'rg8',id:'Item8_5'
		    }]
		  }),{},{
		  	id:'label9',text:'9、护理团队执行力强',width:500,xtype:'label'	
		  },{},
		  new Ext.form.RadioGroup({
		  	id:'Item9',hideLabel: true,x:10,y:0,width:500,
		    items:[{
		    	boxLabel:'完全不同意',inputValue:'1',name:'rg9',id:'Item9_1'
		    },{
		    	boxLabel:'不同意',inputValue:'2',name:'rg9',id:'Item9_2'
		    },{
		    	boxLabel:'一般',inputValue:'3',name:'rg9',id:'Item9_3'
		    },{
		    	boxLabel:'同意',inputValue:'4',name:'rg9',id:'Item9_4'
		    },{
		    	boxLabel:'完全同意',inputValue:'5',name:'rg9',id:'Item9_5'
		    }]
		  }),{},{
		  	id:'label10',text:'10、护理团队氛围积极向上',width:500,xtype:'label'	
		  },{},
		  new Ext.form.RadioGroup({
		  	id:'Item10',hideLabel: true,x:10,y:0,width:500,
		    items:[{
		    	boxLabel:'完全不同意',inputValue:'1',name:'rg10',id:'Item10_1'
		    },{
		    	boxLabel:'不同意',inputValue:'2',name:'rg10',id:'Item10_2'
		    },{
		    	boxLabel:'一般',inputValue:'3',name:'rg10',id:'Item10_3'
		    },{
		    	boxLabel:'同意',inputValue:'4',name:'rg10',id:'Item10_4'
		    },{
		    	boxLabel:'完全同意',inputValue:'5',name:'rg10',id:'Item10_5'
		    }]
		  }),{},{
		  	id:'label11',text:'11、护理奖金、绩效分配公平合理',width:500,xtype:'label'	
		  },{},
		  new Ext.form.RadioGroup({
		  	id:'Item11',hideLabel: true,x:10,y:0,width:500,
		    items:[{
		    	boxLabel:'完全不同意',inputValue:'1',name:'rg11',id:'Item11_1'
		    },{
		    	boxLabel:'不同意',inputValue:'2',name:'rg11',id:'Item11_2'
		    },{
		    	boxLabel:'一般',inputValue:'3',name:'rg11',id:'Item11_3'
		    },{
		    	boxLabel:'同意',inputValue:'4',name:'rg11',id:'Item11_4'
		    },{
		    	boxLabel:'完全同意',inputValue:'5',name:'rg11',id:'Item11_5'
		    }]
		  }),{},{
		  	id:'label12',text:'12、实施弹性排班，体现以人为本',width:500,xtype:'label'	
		  },{},
		  new Ext.form.RadioGroup({
		  	id:'Item12',hideLabel: true,x:10,y:0,width:500,
		    items:[{
		    	boxLabel:'完全不同意',inputValue:'1',name:'rg12',id:'Item12_1'
		    },{
		    	boxLabel:'不同意',inputValue:'2',name:'rg12',id:'Item12_2'
		    },{
		    	boxLabel:'一般', inputValue:'3',name:'rg12',id:'Item12_3'
		    },{
		    	boxLabel:'同意',inputValue:'4',name:'rg12',id:'Item12_4'
		    },{
		    	boxLabel:'完全同意',inputValue:'5',name:'rg12',id:'Item12_5'
		    }]
		  }),{},{
		  	id:'label13',text:'13、护士学习培训安排公平公正',width:500,xtype:'label'	
		  },{},
		  new Ext.form.RadioGroup({
		  	id:'Item13',hideLabel: true,x:10,y:0,width:500,
		    items:[{
		    	boxLabel:'完全不同意',inputValue:'1',name:'rg13',id:'Item13_1'
		    },{
		    	boxLabel:'不同意',inputValue:'2',name:'rg13',id:'Item13_2'
		    },{
		    	boxLabel:'一般',inputValue:'3',name:'rg13',id:'Item13_3'
		    },{
		    	boxLabel:'同意',inputValue:'4',name:'rg13',id:'Item13_4'
		    },{
		    	boxLabel:'完全同意',inputValue:'5',name:'rg13',id:'Item13_5'
		    }]
		  }),{},{
		  	id:'label14',text:'14、您工作出色能够得到表扬与认可',width:500,xtype:'label'	
		  },{},
		  new Ext.form.RadioGroup({
		  	id:'Item14',hideLabel: true,x:10,y:0,width:500,
		    items:[{
		    	boxLabel:'完全不同意',inputValue:'1',name:'rg14',id:'Item14_1'
		    },{
		    	boxLabel:'不同意',inputValue:'2',name:'rg14',id:'Item14_2'
		    },{
		    	boxLabel:'一般',inputValue:'3',name:'rg14',id:'Item14_3'
		    },{
		    	boxLabel:'同意',inputValue:'4',name:'rg14',id:'Item14_4'
		    },{
		    	boxLabel:'完全同意',inputValue:'5',name:'rg14',id:'Item14_5'
		    }]
		  }),{},{
		  	id:'label15',text:'15、您在团队中有充分发挥才干的空间',width:500,xtype:'label'	
		  },{},
		  new Ext.form.RadioGroup({
		  	id:'Item15',hideLabel: true,x:10,y:0,width:500,
		    items:[{
		    	boxLabel:'完全不同意',inputValue:'1',name:'rg15',id:'Item15_1'
		    },{
		    	boxLabel:'不同意',inputValue:'2',name:'rg15',id:'Item15_2'
		    },{
		    	boxLabel:'一般',inputValue:'3',name:'rg15',id:'Item15_3'
		    },{
		    	boxLabel:'同意',inputValue:'4',name:'rg15',id:'Item15_4'
		    },{
		    	boxLabel:'完全同意',inputValue:'5',name:'rg15',id:'Item15_5'
		    }]
		  }),{},{
		  	id:'label16',text:'16、护理管理者能够以身作则、身先士卒',width:500,xtype:'label'	
		  },{},
		  new Ext.form.RadioGroup({
		  	id:'Item16',hideLabel: true,x:10,y:0,width:500,
		    items:[{
		    	boxLabel:'完全不同意',inputValue:'1',name:'rg16',id:'Item16_1'
		    },{
		    	boxLabel:'不同意',inputValue:'2',name:'rg16',id:'Item16_2'
		    },{
		    	boxLabel:'一般',inputValue:'3',name:'rg16',id:'Item16_3'
		    },{
		    	boxLabel:'同意',inputValue:'4',name:'rg16',id:'Item16_4'
		    },{
		    	boxLabel:'完全同意',inputValue:'5',name:'rg16',id:'Item16_5'
		    }]
		  }),{},
		  {
		  	id:'label17',text:'总之，您认为您所在科室护理团队的整体氛围：',width:500,xtype:'label'	
		  },{},
		  new Ext.form.RadioGroup({
		  	id:'Item17',hideLabel: true,x:10,y:0,width:500,
		    items:[{
		    	boxLabel:'非常不好',inputValue:'1',name:'rg17',id:'Item17_1'
		    },{
		    	boxLabel:'不好',inputValue:'2',name:'rg17',id:'Item17_2'
		    },{
		    	boxLabel:'一般',inputValue:'3',name:'rg17',id:'Item17_3'
		    },{
		    	boxLabel:'好',inputValue:'4',name:'rg17',id:'Item17_4'
		    },{
		    	boxLabel:'非常好',inputValue:'5',name:'rg17',id:'Item17_5'
		    }]
		  }),{},{
		  	id:'label18',text:'您对所在科室有何意见和建议：',width:500,xtype:'label'		  		
		  },{},{
		  	id:'Item18',xtype:'textarea',x:'5',hideLabel:true,width:500,height:100
		  },{},{
		  	id:'btnSave',
		  	text:'保存',
		  	width:80,
		  	height:30,
		  	xtype:'button',
		  	handler:function(){saveSurvy(ret);}	
		  }]
  })
  
	Ext.QuickTips.init();
	formPanel.doLayout();
	gform.add(formPanel);
	//Ext.getCmp('item20').setPosition(5,1935)
	gform.doLayout();
	var getSurvyFlag=document.getElementById('getSurvyFlag');
	var date=new Date();
	//alert(date.format('Y-m-d'))
	ret=cspRunServerMethod(getSurvyFlag.value,date.format('Y-m-d'));
	//alert(ret)
	if(!ret){Ext.Msg.alert('提示','此时间不是调查时间或者调查时间已过！');Ext.getCmp('btnSave').hide();}
	if(ret){
		var ExistData=document.getElementById('ExistData');
		var IsExist=cspRunServerMethod(ExistData.value,ret+"^"+"1"+"^"+session['LOGON.USERCODE'])	
		//alert(IsExist)
		if(IsExist){
			Ext.Msg.alert('提示','您已经参与调查过了！');
			Ext.getCmp('btnSave').hide();
		}
	}
}

function saveSurvy(str)
{
	var radioGroup="";
	var score=0;
	for(var i=1;i<18;i++){
		var rg = Ext.getCmp('Item'+i);
		//alert(rg.getXType())
		var r = rg.getValue();
		if((!r)&(i!=17)){Ext.Msg.alert('提示','第'+i+'项不能为空');return;}
		if((i==17)&&(!r)){Ext.Msg.alert('提示','请您对护理团队的整体氛围进行评价！');return;}
		var value = r.inputValue;
		var radioGroup=radioGroup+rg.id+"|"+value+"@"
		
		if(i<18){score=parseInt(score)+parseInt(value);}
	}
	//alert(score)
	//alert(radioGroup)
	var Item18=Ext.getCmp('Item18').getValue();
  var gform=Ext.getCmp('gform');
  //alert(gform)
	//gform.items.each(eachItem1, this); 
	var parr="nurseId|"+session['LOGON.USERCODE']+"^nurseLoc|"+Ext.getCmp('comboboxDep').getValue()+"^id|"+str+"^"+radioGroup+"Item18|"+Item18+"^NurScore|"+score
	//alert(parr)
	var SaveSurvey=document.getElementById('SaveSurvey');
	var flag=cspRunServerMethod(SaveSurvey.value,parr);
	if(flag){Ext.Msg.alert('提示','保存成功');Ext.getCmp('btnSave').hide();}
}

//function eachItem1(Item,index,length)
//{
////alert(1)
//	if (Item.xtype=='radiogroup'){    
//		radioGroup=radioGroup+Item.id+"|"+Item.getValue()+"^";
//	}
//}