function BodyLoadHandler(){
	setsize("mygridpl", "gform", "mygrid",0);
	var grid=Ext.getCmp('mygrid');
	var tobar=grid.getTopToolbar(); 
	tobar.hide();
	var tbar2=new Ext.Toolbar({});
	if(session['LOGON.GROUPDESC']=='Demo Group'||session['LOGON.GROUPDESC']=='护理部'){
		tbar2.addButton({
			id:'newBtn',
			text:'新建',
			icon:'../image/icons/add.png',
			handler:function(){funNewRecord();}
		});
		tbar2.addItem('-');
		tbar2.addButton({
			id:'editBtn',
			text:'修改',
			icon:'../image/icons/application_edit.png',
			handler:function(){funEditRecord();}
		});
	}
	tbar2.addItem('-')
	tbar2.addButton({
		id:'schRecord',
		text:'查询',
		icon:'../image/icons/zoom.png',
		handler:function(){SQList()}	
	});
	tbar2.render(grid.tbar);
	tbar2.doLayout();
	SQList();
	grid.on('rowdblclick',gblRecord)
}
function createCombo()
{
	var locTyp=new Ext.form.ComboBox({
		name:'LocTyp',
		id:'LocTyp',
		store:new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({
				url:"../csp/dhc.nurse.ext.common.getdata.csp"
			}),
			reader:new Ext.data.JsonReader({
				root:'rows',
				totalProperty:'results',
				fields:[{
					'name':'LocCode',
					'mapping':'LocCode'
				},{
					'name':'LocDes',
					'mapping':'LocDes'
				},{
					'name':'rw',
					'name':'rw'
				}]
			}),
			baseParams:{
				className:'web.DHCMgNurCareTeamBuild',
				methodName:'SchLargerLocTyp',
				type:'Query'
			}
		}),
		tabIndex:'0',
		listWidth:'150',
		height:18,
		width:150,
		xtype:'combo',
		displayField:'LocDes',
		valueField:'LocCode',
		value:'',
		hideTrigger:false,
		forceSelection:true,
		triggerAction:'all',
		minChars:1,
		pageSize:10,
		typeAhead:true,
		typeAheadDelay:1000,
		editable:false,
		loadingText:'Searching...'
	});

	return locTyp;
}
function setSumGrid(par)
{
	var com=createCombo();
//	var locTyp=Ext.getCmp('LocTyp');
//	locTyp.store.on('load',function(){
//		locTyp.selectText();
//		locTyp.setValue("InWard");
//	});
	var grid=Ext.getCmp('SumGrid');
	var tbar=grid.getTopToolbar();
	tbar.hide();
	var newBar=new Ext.Toolbar({});
	newBar.render(grid.tbar);
	//var com=Ext.getCmp('LocTyp');
	newBar.addItem('-','大科：',com);
	//com.setValue('AllWard')
	//com.store.on('load',function(com,))
	newBar.addButton({})
	newBar.doLayout();
	com.on('select',function(com, record, index){
		grid.store.on('beforeLoad',function(){
			var strValue=session['LOGON.GROUPDESC']+"^"+session['LOGON.USERCODE'];
			grid.store.baseParams.parm=strValue;
			grid.store.baseParams.par=par;
			grid.store.baseParams.typ=com.getValue();
		});
		searchSumGrid();
	})
	grid.store.on('beforeLoad',function(){
		var strValue=session['LOGON.GROUPDESC']+"^"+session['LOGON.USERCODE'];
		grid.store.baseParams.parm=strValue;
		grid.store.baseParams.par=par;
		grid.store.baseParams.typ=com.getValue();
		//alert(grid.store.baseParams.par)
	})
	searchSumGrid();
}
function searchSumGrid()
{
	var grid=Ext.getCmp('SumGrid')
	grid.store.load({params:{start:0,limit:5000}});
	grid.store.sort('LocTotal','desc');
}
function funExport(grid)
{
	//Ext.Msg.alert('提示','Export');
	var xls = new ActiveXObject ("Excel.Application");
	
	xls.visible =true;  //设置excel为可见
	var xlBook = xls.Workbooks.Add;
	var xlSheet = xlBook.Worksheets(1);
	
	//var grid = Ext.getCmp('ApplyRecordGrid');
  //var grid = Ext.getCmp('SumGrid');
 	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount();
	var temp_obj = [];
	
	//只下载没有隐藏的列(isHidden()为true表示隐藏,其他都为显示) 
	//临时数组,存放所有当前显示列的下标 
	 for(i=0;i <colCount;i++){ 
		if(cm.isHidden(i) == true){ 
		}else{
			temp_obj.push(i);
		}
	}
	for(i=1;i <=temp_obj.length;i++){
		//显示列的列标题
		xlSheet.Cells(1,i).Value = cm.getColumnHeader(temp_obj[i-1]);
		xlSheet.Cells(1,i).Font.Bold = true;//加粗
	}
	var store = grid.getStore();
	var recordCount = store.getCount();
	var view = grid.getView();
	for(i=1;i <=recordCount;i++){
		for(j=1;j <=temp_obj.length;j++){
			//EXCEL数据从第二行开始,故row = i + 1;
			xlSheet.Cells(i + 1,j).Value = view.getCell(i - 1,temp_obj[j - 1]).innerText;
		}
	}
	xlSheet.Columns.AutoFit;
	xls.ActiveWindow.Zoom = 100;
	xls.UserControl = true;  //很重要,不能省略,不然会出问题 意思是excel交由用户控制 
  xls=null;
  xlBook=null; 
  xlSheet=null;
  
}

function rowDbClick(mygrid,par)
{
	var rwObj=mygrid.getSelectionModel().getSelections();
	if(rwObj.length==0){return;}
	if(rwObj[0].get('Item18')==0){return;}
	var loc=rwObj[0].get('loc');
	//var DHCNURCareOPSumsGridT101=new Ext.data.JsonStore({data:[],fields:['loc','OPItem']});
	var DHCNURCareOPSumsGridT101=new Ext.data.Store({proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',fields:[{'name':'loc','mapping':'loc'},{'name':'OPItem','mapping':'OPItem'}]}),baseParams:{className:'web.DHCMgNurCareTeamBuild',methodName:'SchOpSumGrid',type:'RecQuery'}});
	var ret=cspRunServerMethod(pdata1,"","DHCNURCareOPSumsGrid","","");
	var arm=eval(ret)
	var OpGrid=Ext.getCmp('OpGridSum');
	var OpWin=new Ext.Window({
		title:'意见和建议汇总',
		id:'OpWin',x:10,y:2,width:600,height:500,
		modal:'true',
		autoScroll:true,
		layout:'absolute',
		items:[arm],
		buttons:[{
			xtype:'button',
			id:'btnOPExport',
			text:'导出',
			handler:function(){funExport(OpGrid);Ext.getCmp('OpWin').close();}		
		}]
	});
	
	var tbar=OpGrid.getTopToolbar();
	tbar.hide();
	Ext.getCmp('OpGridSumpl').setWidth(OpWin.width);
	Ext.getCmp('OpGridSumpl').setHeight(OpWin.height)
	OpGrid.store.on('beforeLoad',function(){
		OpGrid.store.baseParams.loc=loc+"^"+par;
		//alert(grid.store.baseParams.loc)
	});
	OpWin.show();
	schOpGridSum()
}
function schOpGridSum()
{
	var grid=Ext.getCmp('OpGridSum')
	grid.store.load({params:{start:0,limit:5000}});
}
function gblRecord()
{
//	var locTyp=new Ext.form.ComboBox({
//		name:'LocTyp',
//		id:'LocTyp',
//		store:new Ext.data.Store({
//			proxy:new Ext.data.HttpProxy({
//				url:"../csp/dhc.nurse.ext.common.getdata.csp"
//			}),
//			reader:new Ext.data.JsonReader({
//				root:'rows',
//				totalProperty:'results',
//				fields:[{
//					'name':'LocCode',
//					'mapping':'LocCode'
//				},{
//					'name':'LocDes',
//					'mapping':'LocDes'
//				},{
//					'name':'rw',
//					'name':'rw'
//				}]
//			}),
//			baseParams:{
//				className:'web.DHCMgNurCareTeamBuild',
//				methodName:'SchLargerLocTyp',
//				type:'Query'
//			}
//		}),
//		tabIndex:'0',
//		listWidth:'150',
//		height:18,
//		width:150,
//		xtype:'combo',
//		displayField:'LocDes',
//		valueField:'LocCode',
//		//value:'全院',
//		hideTrigger:false,
//		forceSelection:true,
//		triggerAction:'all',
//		minChars:1,
//		pageSize:10,
//		typeAhead:true,
//		typeAheadDelay:1000,
//		editable:false,
//		loadingText:'Searching...'
//	});
	var mygrid=Ext.getCmp('mygrid');
	var rowObj = mygrid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示','请选择一条记录！');
		return;
	}
	var par = rowObj[0].get('par');
	//alert(par)
	var tabTitle=rowObj[0].get('TabTitle');
	if((session['LOGON.GROUPDESC']=="Demo Group")||(session['LOGON.GROUPDESC']=="护理部")||((session['LOGON.GROUPDESC']=="总护士长"))){
 		var DHCNURCareTeamBuildGridT101=new Ext.data.Store({proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',fields:[{'name':'LocName','mapping':'LocName'},{'name':'LocTotal','mapping':'LocTotal'},{'name':'Item18','mapping':'Item18'},{'name':'loc','mapping':'loc'}]}),baseParams:{className:'web.DHCMgNurCareTeamBuild',methodName:'SchSumQuForSecGrp',type:'RecQuery'}});
 		var a=cspRunServerMethod(pdata1, "", "DHCNURCareTeamBuildGrid", "", "");
		var arr=eval(a);
		var formPanel=new Ext.form.FormPanel({
			x:0,y:0,width:700,height:600,
	 		bodyStyle:'padding:5px 5px 0',
	    id:'formPanel',renderTo:Ext.getBody(),
	    frame:true,
	    labelAlign:'left',
	    autoScroll:true,
	    layout:'absolute',
	    defaults:{defaults:{anchor:'100%'}},
			items:[arr]
		});
		var mygrid=Ext.getCmp('SumGrid');
		var win=new Ext.Window({
			title:'调查汇总',
			id:'surWin1',x:10,y:2,width:700,height:600,
			modal:'true',
			autoScroll:true,
			layout:'absolute',
			items:[arr],
			buttons:[{
				xtype:'button',
				id:'btnExport',
				text:'导出',
				handler:function(){funExport(mygrid);}	
			},{ 
				xtype: 'button',
				id:'btnSave',
	      text:'确定',
	      handler:function(){win.close();}
	    }]
		});
		Ext.getCmp('SumGridpl').setWidth(win.width);
		Ext.getCmp('SumGridpl').setHeight(win.height);
		
		setSumGrid(par);
		//var mygrid=Ext.getCmp('SumGrid');
		mygrid.on('rowdblclick',function(){rowDbClick(mygrid,par);})
		var locTyp=Ext.getCmp('LocTyp');
		locTyp.store.on('beforeLoad',function(){
			var nurseString=session['LOGON.USERID']+"^"+session['LOGON.GROUPDESC'];
			locTyp.store.baseParams.typ=nurseString;
			//alert(locTyp.store.baseParams.typ)
		});
		win.show();
		
	}else{
		//alert(session['LOGON.GROUPDESC'])
		var comboboxDep = new Ext.form.ComboBox({
			fieldLabel:'科室',labelWidth:10,name:'comboboxDep',id:'comboboxDep',
			store:new Ext.data.Store({
				proxy:new Ext.data.HttpProxy({
					url:"../csp/dhc.nurse.ext.common.getdata.csp"
				}),
				reader:new Ext.data.JsonReader({
					root:'rows',totalProperty:'results',
					fields:[{
						'name':'ctlocDesc',	'mapping':'ctlocDesc'
					}, {
						'name':'CtLocDr','mapping':'CtLocDr'
					}]
				}),
				baseParams:{
					className:'web.DHCMgNurCareTeamBuild',
					methodName:'SearchComboDep',
					type:'Query'
				}
			}),tabIndex:'0',listWidth:'220',x:5,y:3,
			height:18,width:200,xtype:'combo',displayField:'ctlocDesc',
			valueField:'CtLocDr',hideTrigger:false,queryParam:'ward1',forceSelection:true,triggerAction:'all',
			minChars:1,pageSize:1000,typeAhead:true,typeAheadDelay:1000,loadingText:'Searching...'
		});
		comboboxDep.store.on('beforeLoad',function(){
	  	var pward=comboboxDep.lastQuery;
			var nurseString=session['LOGON.USERID']+"^"+session['LOGON.GROUPDESC'];
	    comboboxDep.store.baseParams.typ="1";
	    comboboxDep.store.baseParams.ward1=pward;        
			comboboxDep.store.baseParams.nurseid=nurseString;
		});
	  var comboboxDepStore=Ext.getCmp("comboboxDep").getStore();
		comboboxDepStore.load({params:{start:0,limit:5000}});
		//session['LOGON.USERCODE']
		var getNurseDep=document.getElementById('getNurseDep');
		var nurseVal=cspRunServerMethod(getNurseDep.value,session['LOGON.USERCODE']);
		comboboxDepStore.on('load',function(comboboxDepStore,records,options){
			comboboxDep.selectText();
			comboboxDep.setValue(nurseVal);
		});
		comboboxDep.disable();
		var formPanel =new Ext.form.FormPanel({
	    x:0,y:0,width:700, //document.body.offsetWidth,
	    height:600, //document.body.offsetHeight,
	 		bodyStyle:'padding:5px 5px 0',
	    id:'formPanel',renderTo:Ext.getBody(),
	    frame:true,labelAlign:'left',autoScroll:true,layout:'form',defaults:{defaults:{anchor:'100%'}},
	    items:[{
	    	id:'text1',text:'为进一步贯彻落实办院理念，构建和谐护理团队，了解广大护理人员所在科室团队建设情况,护理部开展此次调查。目的是为了加强管理,改进工作，从而把科室这个小家和医院这个大家建设的更好。',width:'620',xtype:'label'
	    },{},
	    {
	    	id:'text2',text:'请根据您自己的真实感受，针对每个问题按照以下五个等级进行评定，5=完全同意  4=同意  3=一般  2=不同意 1=完全不同意。谢谢！',width:'620',xtype:'label'
	    },{},comboboxDep,{},{
	    	id:'label1',text:'1、科室护理管理有序',width:500,xtype:'label'
	    },{},
	  	new Ext.form.RadioGroup({
		  	id:'Item1',hideLabel: true,x:10,y:0,width:500,
		    items:[{
		    	boxLabel:'完全不同意',inputValue:'1',name:'rg1',id:'Item1_1'
		    },{  
		      boxLabel:'不同意',name:'rg1',inputValue:'2',id:'Item1_2' 
		    },{  
		      boxLabel:'一般',name:'rg1',inputValue:'3',id:'Item1_3'
		    },{  
		      boxLabel:'同意',name:'rg1',inputValue:'4',id:'Item1_4'
		    },{
		    	boxLabel:'完全同意',name:'rg1',inputValue:'5',id:'Item1_5'	
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
		    	boxLabel:'同意',inputValue:'4',name:'rg4',id:'Item4_4'
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
		    	boxLabel:'完全同意',inputValue:'5',name:'rg7', id:'Item7_5'
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
		    	boxLabel:'一般',inputValue:'3',name:'rg8',id:'Item8_3'
		    },{
		    	boxLabel:'同意',inputValue:'4',name:'rg8',id:'Item8_4'
		    },{
		    	boxLabel:'完全同意',inputValue:'5',name:'rg8',id:'Item8_5'
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
		    	boxLabel:'不同意',inputValue:'2', name:'rg12',id:'Item12_2'
		    },{
		    	boxLabel:'一般',inputValue:'3',name:'rg12',id:'Item12_3'
		    },{
		    	boxLabel:'同意',inputValue:'4',name:'rg12',id:'Item12_4'
		    },{
		    	boxLabel:'完全同意',inputValue:'5', name:'rg12',id:'Item12_5'
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
		    	boxLabel:'不好', inputValue:'2',name:'rg17',id:'Item17_2'
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
		  	id:'item20',xtype:'textarea',x:'5',hideLabel:true,width:500,height:100
		  }]
		})  
	//Ext.QuickTips.init();
		var win= new Ext.Window({
			title:tabTitle,
			id:'surWin',x:10,y:2,width:700,
			height:600,
			modal:'true',
			autoScroll:true,
			layout:'absolute',
			items:[formPanel],
			buttons:[{ 
				xtype: 'button',
				id:'btnSave',
	      text:'保存',
	      handler:function(){saveSurvy();}
	    }]
		});
		win.show();
	}
}
//保存调查表得分
function saveSurvy()
{
	//alert("4")
	for(var i=1;i<18;i++){
		//alert(Ext.getCmp('Item'+i).getValue())
		//debugger
		var rg = Ext.getCmp('Item'+i);
		var r = rg.getValue();
		if((!r)&(i!=17)){Ext.Msg.alert('提示','第'+i+'项不能为空');return;}
		if((i==17)&&(!r)){Ext.Msg.alert('提示','请您对护理团队的整体氛围进行评价！');return;}
		var value = r.inputValue;
	}
	var nurComment=Ext.getCmp('')
}
///查询列表
function SQList()
{
	var mygrid=Ext.getCmp('mygrid');
	mygrid.store.load({
		params : {
			start : 0,
			limit : 25
		}
	});	
}
function funNewRecord()
{
	//Ext.Msg.alert('提示','新建')
	var objId=""
	var a = cspRunServerMethod(pdata1, "", "DHCNURCareTeamBuildNew", "", "");
	var arr = eval(a);
	var window= new Ext.Window({
		title:'新建',
		id:'gform2',
		x:10,y:2,
		width:450,
		height:200,
		modal:'true',
		autoScroll:true,
		layout:'absolute',
		items:[arr],
		buttons:[{ 
			xtype: 'button',
			id:'btnSave',
      text:'保存',
      handler:function(){Save(objId);}
    }]
	});
	Ext.getCmp('TabTitle').triggerAction='all';
	window.show();
	checkValue();
	
}
//检查开始时间和结束时间大小
function checkValue()
{
		var stDate=Ext.getCmp('StDate');
		stDate.addListener('select',function(dateField,date){
			var strEndDate=Ext.getCmp('EndDate').getValue();
			if(strEndDate!=""){
				var flag=date.between(date,strEndDate);
				if(!flag){
					Ext.Msg.alert('提示','开始时间不能大于结束时间！');
					stDate.setValue("");
				}
			}
		});
		var endDate=Ext.getCmp('EndDate');
		endDate.addListener('select',function(dateField,date){
			var strStDate=Ext.getCmp('StDate').getValue();
			if(strStDate!=""){
				var flag=date.between(strStDate,date);
				if(!flag){
					Ext.Msg.alert('提示','结束时间不能小于开始时间！');
					endDate.setValue('');	
				}	
			}	
		})
}
//修改数据
function funEditRecord()
{
	var mygrid=Ext.getCmp('mygrid');
	var rowObj = mygrid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示','请选择一条记录！');
		return;
	}	
	var par = rowObj[0].get('par');
	var getVal = document.getElementById('getVal');
	var ret=cspRunServerMethod(getVal.value,par);
	//alert(ret)
	var ha=new Hashtable();
	var tm=ret.split('^')
	sethashvalue(ha,tm);
	var a = cspRunServerMethod(pdata1, "", "DHCNURCareTeamBuildNew", "", "");
	var arr = eval(a);
	var window= new Ext.Window({
		title:'修改',
		id:'gform2',
		x:10,y:2,
		width:450,
		height:200,
		modal:'true',
		autoScroll:true,
		layout:'absolute',
		items:[arr],
		buttons:[{ 
			xtype: 'button',
			id:'btnSave',
      text:'保存',
      handler:function(){Save(par);}
    }]
	});
	Ext.getCmp('TabTitle').triggerAction='all';
	window.show();
	Ext.getCmp('StDate').setValue(ha.items('StDate'));
	Ext.getCmp('EndDate').setValue(ha.items('EndDate'));
	Ext.getCmp('TabTitle').setValue(ha.items('TabTitle'));
	checkValue();
}
function Save(objId)
{
	var stDate=Ext.getCmp('StDate').value;
	
	if(!stDate){Ext.Msg.alert('提示','开始时间不能为空！');return;}
	var endDate=Ext.getCmp('EndDate').value;
	if(!endDate){Ext.Msg.alert('提示','结束时间不能为空！');return;}
	var tabTitle=Ext.getCmp('TabTitle').getValue();
	if(!tabTitle){Ext.Msg.alert('提示','标题不能为空！');return;}
	var parr=stDate+"^"+endDate+"^"+tabTitle+"^"+objId
	var save=document.getElementById('Save');
	var ret=cspRunServerMethod(save.value,parr);
	//alert(ret)
	if(ret){
		Ext.getCmp('gform2').close();
		Ext.Msg.alert('提示','保存成功！');
		SQList();		
	}
}