var Height = document.body.clientHeight-2;
var Width = document.body.clientWidth-2;
var perTyp = new Ext.form.ComboBox({
	name : 'perTyp',
	id : 'perTyp',
	tabIndex : '0',
	x:0,y:0,
	//height:20,
	width:50,
	xtype:'combo',
	store:new Ext.data.JsonStore({
		data:[{
			desc:'实习',
			id:'P'
		},{
			desc:'进修',
			id:'S'
		},{
			desc:'护理员',
			id:'W'
		}
//		,{
//			desc:'试用护士',
//			id:'U'
//		}
		],
		fields:['desc','id']
	}),
	displayField:'desc',
	valueField:'id',
	allowBlank:true,
	triggerAction:'all',
	mode:'local',
	value:''
});
var labelId=new Ext.form.TextField({
	width:60,
	id:'labelId',
	xtype:'textfield'
});
//科室
var comboboxDep=new Ext.form.ComboBox({
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
			},{
				'name':'CtLocDr',
				'mapping':'CtLocDr'
			}]
		}),
		baseParams:{
			className:'web.DHCMgNurPerHRComm',
			methodName:'SearchComboDep',
			type:'Query'
		}
	}),
	listeners:{
		    focus: {
				fn: function (e) {
				e.expand();
				this.doQuery(this.allQuery, true);
				},
				buffer: 200
			},
			beforequery: function (e) {
				var combo = e.combo;
				var me = this;
				if (!e.forceAll) {
					var input = e.query;
					var regExp = new RegExp("^" + input + ".*", "i");
						combo.store.filterBy(function (record, id) {
						var text = getPinyin(record.data[me.displayField]);
						return regExp.test(text)|regExp.test(record.data[me.displayField]); 
					});
					combo.expand();
					combo.select(0, true);
					return false;
				}
		    }
	},
	//tabIndex:'0',
	listWidth:220,
	//height:18,
	//width:150,
	xtype:'combo',
	displayField:'ctlocDesc',
	valueField:'CtLocDr',
	hideTrigger:false,
	queryParam:'ward1',
	forceSelection:true,
	triggerAction:'all',
	minChars:1,
	pageSize:10,
	typeAhead:false,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
//判断安全组
var secGrpFlag=toMgSecGrp(session['LOGON.GROUPID']);
//alert(secGrpFlag)
function BodyLoadHandler()
{
	var mygridpl=Ext.getCmp('mygridpl');
	mygridpl.setHeight(Height);
	mygridpl.setWidth(Width);
	mygridpl.setPosition(0,0);
	var grid=Ext.getCmp('mygrid');
	grid.getTopToolbar().hide();
	var bbar=grid.getBottomToolbar();
	bbar.hide();
	var tbar2=new Ext.Toolbar({});
	tbar2.addItem('-','人员类型',perTyp);
	tbar2.addItem('-','姓名',labelId);
	tbar2.addItem('-','科室',comboboxDep);
	tbar2.addItem('-','开始日期',new Ext.form.DateField({id:'JXStDate',value:new Date()}));
	tbar2.addItem('-','结束日期',new Ext.form.DateField({id:'JXEndDate',value:new Date()}));
	tbar2.addItem('-');
	var tbar3=new Ext.Toolbar({});
	tbar3.addItem('-');
	tbar3.addButton({
		id:'jxfindBtn',
		icon:'../images/uiimages/search.png',
		text:'查询',
		handler:function(){if(!Ext.getCmp('perTyp').getValue()){Ext.Msg.alert('提示','请选择人员类型！');return;};findRec();}
	});
	tbar3.addItem('-');
	tbar3.addButton({
		id:'jxaddBtn',
		icon:'../images/uiimages/edit_add.png',
		text:'增加',
		handler:function(){var flag=0; addRec(flag);}
	});
	tbar3.addItem('-');
	tbar3.addButton({
		id:'jxupdateBtn',
		icon:'../images/uiimages/pencil.png',
		text:'编辑',
		handler:function(){var flag=1;addRec(flag);}
		//handler:updateRec	
	});
	tbar3.addItem('-');
	tbar3.addButton({
		id:'btnTrans',
		text:'调科',
		hidden:true,
		icon:'../images/uiimages/blue_arrow.png',
		handler:function(){funTransDep();}
	});
	//tbar3.addItem('-');
	tbar3.addButton({
		id:'btnImport',
		text:'导入',
		hidden:true,
		handler:function(){importRec();}
	});
	var bbar2 = new Ext.PagingToolbar({
		pageSize:20,
		store:grid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bbar2.render(grid.bbar);
	tbar2.render(grid.tbar);
	tbar3.render(grid.tbar);
	var startdate=Ext.getCmp('JXStDate');
	startdate.on('blur',function(){
		if(startdate.getValue()==""){
			startdate.setValue(new Date());
		}
	});
	var enddate=Ext.getCmp('JXEndDate');
	enddate.on('blur',function(){
		if(enddate.getValue()==""){
			enddate.setValue(new Date());
		}	
	})
	if(secGrpFlag!="hlb"){
	//if((session['LOGON.GROUPDESC']=="Demo Group")||(session['LOGON.GROUPDESC']=="护理部")){
		comboboxDep.store.on("beforeLoad",function(){
    	var pward=comboboxDep.lastQuery;
			//var nurseString=session['LOGON.USERID']+"^"+session['LOGON.GROUPDESC'];
			var nurseString=session['LOGON.USERID']+"^"+secGrpFlag;
      comboboxDep.store.baseParams.typ="1";
      comboboxDep.store.baseParams.ward1=pward;        
 			comboboxDep.store.baseParams.nurseid=nurseString;
    });
	}
	if(secGrpFlag=="hlb"){
		comboboxDep.store.on("beforeLoad",function(){
    	var pward=comboboxDep.lastQuery;
			var nurseString=session['LOGON.USERID']+"^"+secGrpFlag;
			  comboboxDep.store.baseParams.typ="1";
			  comboboxDep.store.baseParams.ward1=pward;        
 			comboboxDep.store.baseParams.nurseid=nurseString;
    });
	}
	grid.store.on('beforeload',function(){
		var type=Ext.getCmp('perTyp').getValue();
		var comboboxDep=Ext.getCmp('comboboxDep').getValue();
		var stDate=Ext.getCmp('JXStDate').getValue();
		if(stDate && stDate instanceof Date) stDate=stDate.format('Y-m-d');
		var enDate=Ext.getCmp('JXEndDate').getValue();
		if(enDate && enDate instanceof Date) enDate=enDate.format('Y-m-d');
		var labelId=Ext.getCmp('labelId').getValue();
		var pstring=type+"^"+comboboxDep+"^"+stDate+"^"+enDate+"^"+labelId;
		grid.store.baseParams.parr=pstring
	})
	//findRec();
	perTyp.on('select',function(perTyp,record,index){
		if(perTyp.getValue()=="P"||perTyp.getValue()=="S"){
			Ext.getCmp('btnTrans').show();
		}else{
			Ext.getCmp('btnTrans').hide();
		}
	})
	if(session['LOGON.GROUPDESC']=="Demo Group")
	{
		//Ext.getCmp('btnImport').show();
	}
	var len=grid.getColumnModel().getColumnCount()
	for(var i=0;i<len;i++){
		if(grid.getColumnModel().getDataIndex(i)=="rw"){
			grid.getColumnModel().setHidden(i,true);
		}
	}
}
//调科
function funTransDep()
{
	var mygrid=Ext.getCmp('mygrid');
	var rowObj = mygrid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}
	type=rowObj[0].get('PersonType2');
	var rw=rowObj[0].get('rw');
	var ret=tkMakeServerCall("web.DHCMgNurSchComm","getInfornalVal",rw);
	var ha1 = new Hashtable();
	var ta1=ret.split('^')
	sethashvalue(ha1,ta1);
	var a = cspRunServerMethod(pdata1,"","DHCNURPerExchangeAdd","","");
	var arr = eval(a);
	var window= new Ext.Window({
		title:'临时人员调科',
		id:'transWin',
		x:20,y:20,
		width:380,
		height:320,
		autoScroll:true,
		layout:'absolute',
		modal:true,
		resizable: false,
		items:[arr],
		buttons:[{
			text:'保存',
			id:'btnTranSave',
			icon:'../images/uiimages/filesave.png',
			handler:function(){SaveTransDep(rw);}
		},{
			text:'关闭',
			id:'btnTranCancel',
			icon:'../images/uiimages/cancel.png',
			handler:function(){window.close();}
		}]   
	});
	window.show();
	Ext.getCmp('btnSave').hide();
	Ext.getCmp('btnSave1').hide();
	var PersonDepDR1=Ext.getCmp('PersonDepDR1');
	var descStr=tkMakeServerCall("web.DHCMgNurSchComm","getDepDesc",ha1.items('PersonDepDR'));
	PersonDepDR1.setValue(descStr);
	PersonDepDR1.disable();
	var PersonName=Ext.getCmp('PersonName');
	PersonName.setValue(ha1.items('PersonName'));
	PersonName.disable();
	var PersonID=Ext.getCmp('PersonID');
	PersonID.setValue(ha1.items('PersonID'));
	PersonID.disable();
}
//
function SaveTransDep(rw)
{
	var name=Ext.getCmp('PersonName').getValue();
	var personid=Ext.getCmp('PersonID').getValue();
	
	var dep=Ext.getCmp('PersonDepDR').getValue();
	if(!dep){
		Ext.Msg.alert('提示','护理单元不能为空！');
		return;
	}
	var StDate=Ext.getCmp('PerTranStDate').getValue();
	if(!StDate){
		Ext.Msg.alert('提示','调科日期不能为空！');
		return
	}else{
		if(StDate instanceof Date){
			StDate=StDate.format('Y-m-d');
			var StDate1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",StDate);
			var PersonAdmHos=tkMakeServerCall("web.DHCMgNurSchComm","getPersonAdmHosDate",rw);
			if(StDate1<PersonAdmHos){
				Ext.Msg.alert('提示',"开始日期不能小于来院时间！");
				return;
			}
		}
	}
	var parm=name+"^"+personid+"^^"+rw+"^"+dep+"^"+StDate+"^^"+"Y"+"^"+"0";
	//alert(parm)
	var ret=tkMakeServerCall("web.DHCMgNurSchComm","tmpTransDep",parm);
	Ext.getCmp('transWin').close();
	findRec();
}
function findRec()
{
	var mygrid=Ext.getCmp('mygrid');
	mygrid.store.load({
		params:{
			start:0,
			limit:20	
		}	
	});
}
function addRec(flag)
{
	var type="";
	if(flag==0){
		type=Ext.getCmp('perTyp').getValue();
		if(!type){
			Ext.Msg.alert('提示','请选择人员类型');
			return;	
		}
		var rw="";
	}else if(flag==1){
		var grid = Ext.getCmp("mygrid");
		var rowObj = grid.getSelectionModel().getSelections();
		if (rowObj.length == 0) {
			Ext.Msg.alert('提示',"请选择一条记录！");
			return;
		}
		type=rowObj[0].get('PersonType2');
		var rw=rowObj[0].get('rw');
	}else{
		return;
	}
	if(type=="P"){//DHCNURGRPERSONADD  DHCNURJXPERSONADD DHCNURSXPERSONADD
		var a = cspRunServerMethod(pdata1,"","DHCNURSXPERSONADD","","");
	}else if(type=="S"){
		var a=cspRunServerMethod(pdata1,"","DHCNURJXPERSONADD","","");
	}else if(type=="W"){
		var a=cspRunServerMethod(pdata1,"","DHCNURGRPERSONADD","","");
	}else if(type=="U"){
		var a=cspRunServerMethod(pdata1,"","DHCNURURNurseAdd","","");
	}
	var arr = eval(a);
	var window= new Ext.Window({
		title:'增加',
		id:'gform2',
		x:20,y:20,
		width:500,
		height:320,
		autoScroll:true,
		layout:'absolute',
		modal:true,
		resizable: false,
		items:[arr],
		buttons:[{
			text:'保存',
			id:'btnSave',
			icon:'../images/uiimages/filesave.png',
			handler:function(){funSave(flag,type,rw);}
		},{
			text:'关闭',
			id:'btnCancel',
			icon:'../images/uiimages/cancel.png',
			handler:function(){window.close();}
		}]   
	});
	window.show();
	if(flag==0){
		var autoflag_1=Ext.getCmp('autoflag_1');
		Ext.getCmp('autoflag').hide();
		/*
		autoflag_1.setValue(true);
		autoflag_1.on('check',function(autoflag_1, checked){
			if(checked==false){
				Ext.getCmp('PersonID').disable();
				Ext.getCmp('PersonID').setValue('');
			}else if(checked==true){
				Ext.getCmp('PersonID').enable();
			}
		})
		*/
		if(type=="P"){
			Ext.getCmp('gform2').setTitle('新增实习生信息');
		}else if(type=="S"){
			Ext.getCmp('gform2').setTitle('新增进修人员信息');
		}else if(type=="W"){
			Ext.getCmp('gform2').setTitle('新增护理员信息');
		}else if(type=="U"){
			Ext.getCmp('gform2').setTitle('新增未注册或试用护士信息');
			Ext.getCmp('PersonInternEndDate').hide();
			Ext.getCmp('B115').hide();
		}
//		if(type=="P"){
//			var autoflag_1=Ext.getCmp('autoflag_1');
//			autoflag_1.setValue(true);
//			autoflag_1.on('check',function(autoflag_1, checked){
//				if(checked==false){
//					Ext.getCmp('PersonID').disable();
//					Ext.getCmp('PersonID').setValue('');
//				}else if(checked==true){
//					Ext.getCmp('PersonID').enable();
//				}
//			})
//		}else if(type=="S"){
//			var autoflag_1=Ext.getCmp('autoflag_1');
//			autoflag_1.setValue(true);
//			autoflag_1.on('check',function(autoflag_1, checked){
//				if(checked==false){
//					Ext.getCmp('PersonID').disable();
//					Ext.getCmp('PersonID').setValue('');
//				}else if(checked==true){
//					Ext.getCmp('PersonID').enable();
//				}
//			})
//		}else if(type=="W"){
//			var autoflag_1=Ext.getCmp('autoflag_1');
//			autoflag_1.setValue(true);
//			autoflag_1.on('check',function(autoflag_1, checked){
//				if(checked==false){
//					Ext.getCmp('PersonID').disable();
//					Ext.getCmp('PersonID').setValue('');
//				}else if(checked==true){
//					Ext.getCmp('PersonID').enable();
//				}
//			})
//		}
	}else if(flag==1){
		//if(type=="U")Ext.getCmp('createperid').hide();
		var PersonID=Ext.getCmp('PersonID');
		PersonID.disable();
		var autoflag_1=Ext.getCmp('autoflag_1');
		Ext.getCmp('autoflag').hide();
		var strVal=tkMakeServerCall("web.DHCMgNurSchComm","getInfornalVal",rw);
		//alert(rw)
		var ha = new Hashtable();
  	var ta=strVal.split('^')
  	sethashvalue(ha,ta);
  	var PersonID=Ext.getCmp('PersonID');
  	PersonID.setValue(ha.items('PersonID'));
  	var PersonName=Ext.getCmp('PersonName');
  	PersonName.setValue(ha.items('PersonName'));
  	var PersonSexDR=Ext.getCmp('PersonSexDR');
  	PersonSexDR.setValue(ha.items('PersonSexDR'));
  	var PersonDepDR=Ext.getCmp('PersonDepDR');
  	PersonDepDR.setEditable(false);
		PersonDepDR.pageSize=1000;
  	var personDepStore=PersonDepDR.getStore();
  	personDepStore.load({params:{start:0,limit:1000}});
  	personDepStore.on('load',function(personDepStore,records,options){
			Ext.getCmp('PersonDepDR').selectText();
			Ext.getCmp('PersonDepDR').setValue(ha.items('PersonDepDR'));
		});
		var PersonBirthDay=Ext.getCmp('PersonBirthDay');
		PersonBirthDay.setValue(ha.items('PersonBirthDay'));
		var PersonAdmHosDate=Ext.getCmp('PersonAdmHosDate');
		PersonAdmHosDate.setValue(ha.items('PersonAdmHosDate'));
		var PersonTelHand=Ext.getCmp('PersonTelHand');
		PersonTelHand.setValue(ha.items('PersonTelHand'));
		var PersonInternAddress=Ext.getCmp('PersonInternAddress');
		PersonInternAddress.setValue(ha.items('PersonInternAddress'));
		var PersonInternStDate=Ext.getCmp('PersonInternStDate');
		PersonInternStDate.setValue(ha.items('PersonInternStDate'));
		var PersonInternEndDate=Ext.getCmp('PersonInternEndDate');
		PersonInternEndDate.setValue(ha.items('PersonInternEndDate'));
		if(type=="P"){
			Ext.getCmp('gform2').setTitle('修改实习生信息');
			var PersonInternSchool=Ext.getCmp('PersonInternSchool');
			PersonInternSchool.setValue(ha.items('PersonInternSchool'));
			var PersonInternProf=Ext.getCmp('PersonInternProf');
			PersonInternProf.setValue(ha.items('PersonInternProf'));
			var PersonInternClass=Ext.getCmp('PersonInternClass');
			PersonInternClass.setValue(ha.items('PersonInternClass'));
		}else if(type=="S"){
			Ext.getCmp('gform2').setTitle('修改进修人员信息');
			var PersonStudyPref=Ext.getCmp('PersonStudyPref');
			PersonStudyPref.setValue(ha.items('PersonStudyPref'));
			var PersonWorkUnit=Ext.getCmp('PersonWorkUnit');
			PersonWorkUnit.setValue(ha.items('PersonWorkUnit'));
			var PersonWorkDateTime=Ext.getCmp('PersonWorkDateTime');
			PersonWorkDateTime.setValue(ha.items('PersonWorkDateTime'));
		}else if(type=="W"){
			Ext.getCmp('gform2').setTitle('修改护理员信息');
			var PersonGRType=Ext.getCmp('PersonGRType');
			PersonGRType.setValue(ha.items('PersonGRType'));
			var PersonWorkDateTime=Ext.getCmp('PersonWorkDateTime');
			PersonWorkDateTime.setValue(ha.items('PersonWorkDateTime'));
		}else if(type=="U"){
			Ext.getCmp('gform2').setTitle('修改未注册或试用护士信息');
			var PersonWorkDateTime=Ext.getCmp('PersonWorkDateTime');
			PersonWorkDateTime.setValue(ha.items('PersonWorkDateTime'));
			Ext.getCmp('PersonInternEndDate').hide();
			Ext.getCmp('B115').hide();
		}
	}
}
function funSave(flag,type,rw)
{
	if(flag==0){
		var PersonID=Ext.getCmp('PersonID').getValue();
//		if(Ext.getCmp('autoflag_1').checked==true){
//			if(!PersonID){
//				Ext.Msg.alert('提示','工号不能为空！');
//				return;
//			}	
//		}
		if(!PersonID){
			Ext.Msg.alert('提示','工号不能为空！');
			return;
		}	
		if(type=="P"){
			if(PersonID){
				var PersonID=PersonID.toLocaleUpperCase()
				var fdStart=PersonID.indexOf('SX');
				if(fdStart!=0){
					Ext.Msg.alert('提示','请在工号前加"SX"');
					return;
				}
			}
			//var strPrefix='SX';
			var isExistId=tkMakeServerCall("web.DHCMgNurSchComm","IsExist",type+"^"+PersonID);
			if(isExistId){
				Ext.Msg.alert('提示','此工号已经存在，请重新输入！');
				return;
			}
			//var strr=fillItem();
			var PersonName=Ext.getCmp('PersonName').getValue();
			if(!PersonName){
				Ext.Msg.alert('提示','姓名不能为空！');
				return;
			}
			var PersonSexDR=Ext.getCmp('PersonSexDR').getValue();
			var PersonDepDR=Ext.getCmp('PersonDepDR').getValue();
			if(!PersonDepDR){
				Ext.Msg.alert('提示','科室不能为空！');
				return;
			}
			var PersonBirthDay1="";
			var PersonBirthDay=Ext.getCmp('PersonBirthDay').getValue();
			if(!PersonBirthDay){
				Ext.Msg.alert('提示','出生日期不能为空！');
				return;
			}else{
				if(PersonBirthDay instanceof Date){
					PersonBirthDay=PersonBirthDay.format('Y-m-d');
					var PersonBirthDay1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonBirthDay);
				}
			}
			var PersonAdmHosDate1="";
			var PersonAdmHosDate=Ext.getCmp('PersonAdmHosDate').getValue();
			if(!PersonAdmHosDate){
				Ext.Msg.alert('提示','来院日期不能为空！');
				return;
			}else{
				if(PersonAdmHosDate instanceof Date){
					PersonAdmHosDate=PersonAdmHosDate.format('Y-m-d');
					PersonAdmHosDate1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonAdmHosDate);
					if(PersonAdmHosDate1<PersonBirthDay1){
						Ext.Msg.alert('提示',"来院日期不能小于出生日期！");
						return;
					}
				}
			}
			var PersonTelHand=Ext.getCmp('PersonTelHand').getValue();
			var PersonInternAddress=Ext.getCmp('PersonInternAddress').getValue();
			var PersonInternStDate1="";
			var PersonInternStDate=Ext.getCmp('PersonInternStDate').getValue();
			if(!PersonInternStDate){
				Ext.Msg.alert('提示','开始日期不能为空！');
				return;
			}else{
				if(PersonInternStDate instanceof Date){
					PersonInternStDate=PersonInternStDate.format('Y-m-d');
					PersonInternStDate1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonInternStDate);
					if(PersonInternStDate1<PersonAdmHosDate1){
						Ext.Msg.alert('提示',"开始日期不能小于来院日期！");
						return;
					}
				}
			}
			var PersonInternEndDate=Ext.getCmp('PersonInternEndDate').getValue();
			if(!PersonInternEndDate){
				Ext.Msg.alert('提示','结束日期不能为空！');
				return;
			}else{
				if(PersonInternEndDate instanceof Date){
					PersonInternEndDate=PersonInternEndDate.format('Y-m-d');
					var PersonInternEndDate1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonInternEndDate);
					if(PersonInternEndDate1<PersonInternStDate1){
						Ext.Msg.alert('提示',"结束日期不能小于开始日期！");
						return;
					}
				}
			}
			var strr="PersonName|"+PersonName+"^PersonSexDR|"+PersonSexDR+"^PersonDepDR|"+PersonDepDR+
							"^PersonBirthDay|"+PersonBirthDay+"^PersonAdmHosDate|"+PersonAdmHosDate+"^PersonTelHand|"+PersonTelHand
							+"^PersonInternAddress|"+PersonInternAddress+"^PersonInternStDate|"+PersonInternStDate
							+"^PersonInternEndDate|"+PersonInternEndDate;
							
			var PersonInternSchool=Ext.getCmp('PersonInternSchool').getValue();
			var PersonInternProf=Ext.getCmp('PersonInternProf').getValue();
			var PersonInternClass=Ext.getCmp('PersonInternClass').getValue();
			
			var parr="PersonType2|"+type+"^rw|"+rw+"^PersonID|"+PersonID+"^"+strr+"^PersonInternSchool|"+PersonInternSchool+
								"^PersonInternProf|"+PersonInternProf+"^PersonInternClass|"+PersonInternClass;

		}else if(type=="S"){
			if(PersonID){
				var PersonID=PersonID.toLocaleUpperCase()
				var fdStart=PersonID.indexOf('JX');
				if(fdStart!=0){
					Ext.Msg.alert('提示','请在工号前加"JX"');
					return;
				}
			}
			var isExistId=tkMakeServerCall("web.DHCMgNurSchComm","IsExist",type+"^"+PersonID);
			//alert(isExistId)
			//return
			if(isExistId){
				Ext.Msg.alert('提示','此工号已经存在，请重新输入！');
				return;
			}
			//var strr=fillItem();
			var PersonName=Ext.getCmp('PersonName').getValue();
			if(!PersonName){
				Ext.Msg.alert('提示','姓名不能为空！');
				return;
			}
			var PersonSexDR=Ext.getCmp('PersonSexDR').getValue();
			var PersonDepDR=Ext.getCmp('PersonDepDR').getValue();
			if(!PersonDepDR){
				Ext.Msg.alert('提示','科室不能为空！');
				return;
			}
			var PersonBirthDay1="";
			var PersonBirthDay=Ext.getCmp('PersonBirthDay').getValue();
			if(!PersonBirthDay){
				Ext.Msg.alert('提示','出生日期不能为空！');
				return;
			}else{
				if(PersonBirthDay instanceof Date){
					PersonBirthDay=PersonBirthDay.format('Y-m-d');
					var PersonBirthDay1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonBirthDay);
				}
			}
			var PersonAdmHosDate1="";
			var PersonAdmHosDate=Ext.getCmp('PersonAdmHosDate').getValue();
			if(!PersonAdmHosDate){
				Ext.Msg.alert('提示','来院日期不能为空！');
				return;
			}else{
				if(PersonAdmHosDate instanceof Date){
					PersonAdmHosDate=PersonAdmHosDate.format('Y-m-d');
					PersonAdmHosDate1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonAdmHosDate);
					if(PersonAdmHosDate1<PersonBirthDay1){
						Ext.Msg.alert('提示',"来院日期不能小于出生日期！");
						return;
					}
				}
			}
			var PersonTelHand=Ext.getCmp('PersonTelHand').getValue();
			var PersonInternAddress=Ext.getCmp('PersonInternAddress').getValue();
			var PersonInternStDate1="";
			var PersonInternStDate=Ext.getCmp('PersonInternStDate').getValue();
			if(!PersonInternStDate){
				Ext.Msg.alert('提示','开始日期不能为空！');
				return;
			}else{
				if(PersonInternStDate instanceof Date){
					PersonInternStDate=PersonInternStDate.format('Y-m-d');
					PersonInternStDate1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonInternStDate);
					if(PersonInternStDate1<PersonAdmHosDate1){
						Ext.Msg.alert('提示',"开始日期不能小于来院日期！");
						return;
					}
				}
			}
			var PersonInternEndDate=Ext.getCmp('PersonInternEndDate').getValue();
			if(!PersonInternEndDate){
				Ext.Msg.alert('提示','结束日期不能为空！');
				return;
			}else{
				if(PersonInternEndDate instanceof Date){
					PersonInternEndDate=PersonInternEndDate.format('Y-m-d');
					var PersonInternEndDate1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonInternEndDate);
					if(PersonInternEndDate1<PersonInternStDate1){
						Ext.Msg.alert('提示',"结束日期不能小于开始日期！");
						return;
					}
				}
			}
			var strr="PersonName|"+PersonName+"^PersonSexDR|"+PersonSexDR+"^PersonDepDR|"+PersonDepDR+
							"^PersonBirthDay|"+PersonBirthDay+"^PersonAdmHosDate|"+PersonAdmHosDate+"^PersonTelHand|"+PersonTelHand
							+"^PersonInternAddress|"+PersonInternAddress+"^PersonInternStDate|"+PersonInternStDate
							+"^PersonInternEndDate|"+PersonInternEndDate;
			var PersonStudyPref=Ext.getCmp('PersonStudyPref').getValue();
			var PersonWorkUnit=Ext.getCmp('PersonWorkUnit').getValue();
			var PersonWorkDateTime=Ext.getCmp('PersonWorkDateTime').getValue();
			if(!PersonWorkDateTime){
				Ext.Msg.alert('提示','参加工作日期不能为空！');
				return;
			}else{
				if(PersonWorkDateTime instanceof Date){
					PersonWorkDateTime=PersonWorkDateTime.format('Y-m-d');
				}
			}
			var parr="PersonType2|"+type+"^rw|"+rw+"^PersonID|"+PersonID+"^"+strr+"^PersonStudyPref|"+PersonStudyPref+
								"^PersonWorkUnit|"+PersonWorkUnit+"^PersonWorkDateTime|"+PersonWorkDateTime;
		}else if(type=="W"){
			if(PersonID){
				var PersonID=PersonID.toLocaleUpperCase()
				var fdStart=PersonID.indexOf('RH');
				if(fdStart!=0){
					Ext.Msg.alert('提示','请在工号前加"RH"');
					return;
				}
			}
			var isExistId=tkMakeServerCall("web.DHCMgNurSchComm","IsExist",type+"^"+PersonID);
			//alert(isExistId)
			//return
			if(isExistId){
				Ext.Msg.alert('提示','此工号已经存在，请重新输入！');
				return;
			}
			//	var strr=fillItem();
			var PersonName=Ext.getCmp('PersonName').getValue();
			if(!PersonName){
				Ext.Msg.alert('提示','姓名不能为空！');
				return;
			}
			var PersonSexDR=Ext.getCmp('PersonSexDR').getValue();
			var PersonDepDR=Ext.getCmp('PersonDepDR').getValue();
			if(!PersonDepDR){
				Ext.Msg.alert('提示','科室不能为空！');
				return;
			}
			var PersonBirthDay1="";
			var PersonBirthDay=Ext.getCmp('PersonBirthDay').getValue();
			if(!PersonBirthDay){
				Ext.Msg.alert('提示','出生日期不能为空！');
				return;
			}else{
				if(PersonBirthDay instanceof Date){
					PersonBirthDay=PersonBirthDay.format('Y-m-d');
					var PersonBirthDay1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonBirthDay);
				}
			}
			var PersonAdmHosDate1="";
			var PersonAdmHosDate=Ext.getCmp('PersonAdmHosDate').getValue();
			if(!PersonAdmHosDate){
				Ext.Msg.alert('提示','来院日期不能为空！');
				return;
			}else{
				if(PersonAdmHosDate instanceof Date){
					PersonAdmHosDate=PersonAdmHosDate.format('Y-m-d');
					PersonAdmHosDate1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonAdmHosDate);
					if(PersonAdmHosDate1<PersonBirthDay1){
						Ext.Msg.alert('提示',"来院日期不能小于出生日期！");
						return;
					}
				}
			}
			var PersonTelHand=Ext.getCmp('PersonTelHand').getValue();
			var PersonInternAddress=Ext.getCmp('PersonInternAddress').getValue();
			var PersonInternStDate1="";
			var PersonInternStDate=Ext.getCmp('PersonInternStDate').getValue();
			if(!PersonInternStDate){
				Ext.Msg.alert('提示','开始日期不能为空！');
				return;
			}else{
				if(PersonInternStDate instanceof Date){
					PersonInternStDate=PersonInternStDate.format('Y-m-d');
					PersonInternStDate1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonInternStDate);
					if(PersonInternStDate1<PersonAdmHosDate1){
						Ext.Msg.alert('提示',"开始日期不能小于来院日期！");
						return;
					}
				}
			}
			var PersonInternEndDate=Ext.getCmp('PersonInternEndDate').getValue();
			if(!PersonInternEndDate){
				Ext.Msg.alert('提示','结束日期不能为空！');
				return;
			}else{
				if(PersonInternEndDate instanceof Date){
					PersonInternEndDate=PersonInternEndDate.format('Y-m-d');
					var PersonInternEndDate1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonInternEndDate);
					if(PersonInternEndDate1<PersonInternStDate1){
						Ext.Msg.alert('提示',"结束日期不能小于开始日期！");
						return;
					}
				}
			}
			var strr="PersonName|"+PersonName+"^PersonSexDR|"+PersonSexDR+"^PersonDepDR|"+PersonDepDR+
							"^PersonBirthDay|"+PersonBirthDay+"^PersonAdmHosDate|"+PersonAdmHosDate+"^PersonTelHand|"+PersonTelHand
							+"^PersonInternAddress|"+PersonInternAddress+"^PersonInternStDate|"+PersonInternStDate
							+"^PersonInternEndDate|"+PersonInternEndDate;
							
			var PersonWorkDateTime=Ext.getCmp('PersonWorkDateTime').getValue();
			if(!PersonWorkDateTime){
				Ext.Msg.alert('提示','参加工作日期不能为空！');
				return;
			}else{
				if(PersonWorkDateTime instanceof Date){
					PersonWorkDateTime=PersonWorkDateTime.format('Y-m-d');
				}
			}
			var PersonGRType=Ext.getCmp('PersonGRType').getValue();
			if(!PersonGRType){
				Ext.Msg.alert('提示','工人类型不能为空！');
				return;
			}
			
			var parr="PersonType2|"+type+"^rw|"+rw+"^PersonID|"+PersonID+"^"+strr+"^PersonWorkDateTime|"+PersonWorkDateTime+
							"^PersonGRType|"+PersonGRType;
		}else if(type=="U"){
			if(PersonID){
				var PersonID=PersonID.toLocaleUpperCase()
				var fdStart=PersonID.indexOf('NR');
				if(fdStart!=0){
					Ext.Msg.alert('提示','请在工号前加"NR"');
					return;
				}
			}
			var isExistId=tkMakeServerCall("web.DHCMgNurSchComm","IsExist",type+"^"+PersonID);
			//alert(isExistId)
			//return
			if(isExistId){
				Ext.Msg.alert('提示','此工号已经存在，请重新输入！');
				return;
			}
			//	var strr=fillItem();
			var PersonName=Ext.getCmp('PersonName').getValue();
			if(!PersonName){
				Ext.Msg.alert('提示','姓名不能为空！');
				return;
			}
			var PersonSexDR=Ext.getCmp('PersonSexDR').getValue();
			var PersonDepDR=Ext.getCmp('PersonDepDR').getValue();
			if(!PersonDepDR){
				Ext.Msg.alert('提示','科室不能为空！');
				return;
			}
			var PersonBirthDay1="";
			var PersonBirthDay=Ext.getCmp('PersonBirthDay').getValue();
			if(!PersonBirthDay){
				Ext.Msg.alert('提示','出生日期不能为空！');
				return;
			}else{
				if(PersonBirthDay instanceof Date){
					PersonBirthDay=PersonBirthDay.format('Y-m-d');
					var PersonBirthDay1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonBirthDay);
				}
			}
			var PersonAdmHosDate1="";
			var PersonAdmHosDate=Ext.getCmp('PersonAdmHosDate').getValue();
			if(!PersonAdmHosDate){
				Ext.Msg.alert('提示','来院日期不能为空！');
				return;
			}else{
				if(PersonAdmHosDate instanceof Date){
					PersonAdmHosDate=PersonAdmHosDate.format('Y-m-d');
					PersonAdmHosDate1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonAdmHosDate);
					if(PersonAdmHosDate1<PersonBirthDay1){
						Ext.Msg.alert('提示',"来院日期不能小于出生日期！");
						return;
					}
				}
			}
			var PersonTelHand=Ext.getCmp('PersonTelHand').getValue();
			var PersonInternAddress=Ext.getCmp('PersonInternAddress').getValue();
			var PersonInternStDate1="";
			var PersonInternStDate=Ext.getCmp('PersonInternStDate').getValue();
			if(!PersonInternStDate){
				Ext.Msg.alert('提示','开始日期不能为空！');
				return;
			}else{
				if(PersonInternStDate instanceof Date){
					PersonInternStDate=PersonInternStDate.format('Y-m-d');
					PersonInternStDate1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonInternStDate);
					if(PersonInternStDate1<PersonAdmHosDate1){
						Ext.Msg.alert('提示',"开始日期不能小于来院日期！");
						return;
					}
				}
			}
			//var PersonInternEndDate=Ext.getCmp('PersonInternEndDate').getValue();
			//if(!PersonInternEndDate){
			//	Ext.Msg.alert('提示','结束日期不能为空！');
			//	return;
			//}else{
			//	if(PersonInternEndDate instanceof Date){
			//		PersonInternEndDate=PersonInternEndDate.format('Y-m-d');
			//	}
			//}
			var strr="PersonName|"+PersonName+"^PersonSexDR|"+PersonSexDR+"^PersonDepDR|"+PersonDepDR+
							"^PersonBirthDay|"+PersonBirthDay+"^PersonAdmHosDate|"+PersonAdmHosDate+"^PersonTelHand|"+PersonTelHand
							+"^PersonInternAddress|"+PersonInternAddress+"^PersonInternStDate|"+PersonInternStDate
							+"^PersonInternEndDate|";
							
			var PersonWorkDateTime=Ext.getCmp('PersonWorkDateTime').getValue();
			if(!PersonWorkDateTime){
				Ext.Msg.alert('提示','参加工作日期不能为空！');
				return;
			}else{
				if(PersonWorkDateTime instanceof Date){
					PersonWorkDateTime=PersonWorkDateTime.format('Y-m-d');
				}
			}
			var parr="PersonType2|"+type+"^rw|"+rw+"^PersonID|"+PersonID+"^"+strr+"^PersonWorkDateTime|"+PersonWorkDateTime;
			alert(parr)
		}
		var ret=tkMakeServerCall('web.DHCMgNurSchComm','SaveInformal',parr);
		Ext.getCmp('gform2').close();
	}else if(flag=="1"){
		var PersonID=Ext.getCmp('PersonID').getValue();
		if(type=="P"){
			if(PersonID){
				var PersonID=PersonID.toLocaleUpperCase()
				var fdStart=PersonID.indexOf('SX');
				if(fdStart!=0){
					Ext.Msg.alert('提示','请在工号前加"SX"');
					return;
				}
			}
			//var strr=fillItem();
			var PersonName=Ext.getCmp('PersonName').getValue();
			if(!PersonName){
				Ext.Msg.alert('提示','姓名不能为空！');
				return;
			}
			var PersonSexDR=Ext.getCmp('PersonSexDR').getValue();
			var PersonDepDR=Ext.getCmp('PersonDepDR').getValue();
			if(!PersonDepDR){
				Ext.Msg.alert('提示','科室不能为空！');
				return;
			}
			var PersonBirthDay1="";
			var PersonBirthDay=Ext.getCmp('PersonBirthDay').getValue();
			if(!PersonBirthDay){
				Ext.Msg.alert('提示','出生日期不能为空！');
				return;
			}else{
				if(PersonBirthDay instanceof Date){
					PersonBirthDay=PersonBirthDay.format('Y-m-d');
					var PersonBirthDay1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonBirthDay);
				}
			}
			var PersonAdmHosDate1="";
			var PersonAdmHosDate=Ext.getCmp('PersonAdmHosDate').getValue();
			if(!PersonAdmHosDate){
				Ext.Msg.alert('提示','来院日期不能为空！');
				return;
			}else{
				if(PersonAdmHosDate instanceof Date){
					PersonAdmHosDate=PersonAdmHosDate.format('Y-m-d');
					PersonAdmHosDate1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonAdmHosDate);
					if(PersonAdmHosDate1<PersonBirthDay1){
						Ext.Msg.alert('提示',"来院日期不能小于出生日期！");
						return;
					}
				}
			}
			var PersonTelHand=Ext.getCmp('PersonTelHand').getValue();
			var PersonInternAddress=Ext.getCmp('PersonInternAddress').getValue();
			var PersonInternStDate1="";
			var PersonInternStDate=Ext.getCmp('PersonInternStDate').getValue();
			if(!PersonInternStDate){
				Ext.Msg.alert('提示','开始日期不能为空！');
				return;
			}else{
				if(PersonInternStDate instanceof Date){
					PersonInternStDate=PersonInternStDate.format('Y-m-d');
					PersonInternStDate1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonInternStDate);
					if(PersonInternStDate1<PersonAdmHosDate1){
						Ext.Msg.alert('提示',"开始日期不能小于来院日期！");
						return;
					}
				}
			}
			var PersonInternEndDate=Ext.getCmp('PersonInternEndDate').getValue();
			if(!PersonInternEndDate){
				Ext.Msg.alert('提示','结束日期不能为空！');
				return;
			}else{
				if(PersonInternEndDate instanceof Date){
					PersonInternEndDate=PersonInternEndDate.format('Y-m-d');
					var PersonInternEndDate1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonInternEndDate);
					if(PersonInternEndDate1<PersonInternStDate1){
						Ext.Msg.alert('提示',"结束日期不能小于开始日期！");
						return;
					}
				}
			}
			var strr="PersonName|"+PersonName+"^PersonSexDR|"+PersonSexDR+"^PersonDepDR|"+PersonDepDR+
							"^PersonBirthDay|"+PersonBirthDay+"^PersonAdmHosDate|"+PersonAdmHosDate+"^PersonTelHand|"+PersonTelHand
							+"^PersonInternAddress|"+PersonInternAddress+"^PersonInternStDate|"+PersonInternStDate
							+"^PersonInternEndDate|"+PersonInternEndDate;
			
			var PersonInternSchool=Ext.getCmp('PersonInternSchool').getValue();
			var PersonInternProf=Ext.getCmp('PersonInternProf').getValue();
			var PersonInternClass=Ext.getCmp('PersonInternClass').getValue();
			var parr="PersonType2|"+type+"^rw|"+rw+"^PersonID|"+PersonID+"^"+strr+"^PersonInternSchool|"+PersonInternSchool+
								"^PersonInternProf|"+PersonInternProf+"^PersonInternClass|"+PersonInternClass;
		}else if(type=="S"){
			if(PersonID){
				var PersonID=PersonID.toLocaleUpperCase()
				var fdStart=PersonID.indexOf('JX');
				if(fdStart!=0){
					Ext.Msg.alert('提示','请在工号前加"JX"');
					return;
				}
			}
				//var strr=fillItem();
			var PersonName=Ext.getCmp('PersonName').getValue();
			var PersonSexDR=Ext.getCmp('PersonSexDR').getValue();
			var PersonDepDR=Ext.getCmp('PersonDepDR').getValue();
			
			var PersonBirthDay1="";
			var PersonBirthDay=Ext.getCmp('PersonBirthDay').getValue();
			if(!PersonBirthDay){
				Ext.Msg.alert('提示','出生日期不能为空！');
				return;
			}else{
				if(PersonBirthDay instanceof Date){
					PersonBirthDay=PersonBirthDay.format('Y-m-d');
					var PersonBirthDay1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonBirthDay);
				}
			}
			var PersonAdmHosDate1="";
			var PersonAdmHosDate=Ext.getCmp('PersonAdmHosDate').getValue();
			if(!PersonAdmHosDate){
				Ext.Msg.alert('提示','来院日期不能为空！');
				return;
			}else{
				if(PersonAdmHosDate instanceof Date){
					PersonAdmHosDate=PersonAdmHosDate.format('Y-m-d');
					PersonAdmHosDate1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonAdmHosDate);
					if(PersonAdmHosDate1<PersonBirthDay1){
						Ext.Msg.alert('提示',"来院日期不能小于出生日期！");
						return;
					}
				}
			}
			var PersonTelHand=Ext.getCmp('PersonTelHand').getValue();
			var PersonInternAddress=Ext.getCmp('PersonInternAddress').getValue();
			var PersonInternStDate1="";
			var PersonInternStDate=Ext.getCmp('PersonInternStDate').getValue();
			if(!PersonInternStDate){
				Ext.Msg.alert('提示','开始日期不能为空！');
				return;
			}else{
				if(PersonInternStDate instanceof Date){
					PersonInternStDate=PersonInternStDate.format('Y-m-d');
					PersonInternStDate1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonInternStDate);
					if(PersonInternStDate1<PersonAdmHosDate1){
						Ext.Msg.alert('提示',"开始日期不能小于来院日期！");
						return;
					}
				}
			}
			var PersonInternEndDate=Ext.getCmp('PersonInternEndDate').getValue();
			if(!PersonInternEndDate){
				Ext.Msg.alert('提示','结束日期不能为空！');
				return;
			}else{
				if(PersonInternEndDate instanceof Date){
					PersonInternEndDate=PersonInternEndDate.format('Y-m-d');
					var PersonInternEndDate1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonInternEndDate);
					if(PersonInternEndDate1<PersonInternStDate1){
						Ext.Msg.alert('提示',"结束日期不能小于开始日期！");
						return;
					}
				}
			}
			var strr="PersonName|"+PersonName+"^PersonSexDR|"+PersonSexDR+"^PersonDepDR|"+PersonDepDR+
							"^PersonBirthDay|"+PersonBirthDay+"^PersonAdmHosDate|"+PersonAdmHosDate+"^PersonTelHand|"+PersonTelHand
							+"^PersonInternAddress|"+PersonInternAddress+"^PersonInternStDate|"+PersonInternStDate
							+"^PersonInternEndDate|"+PersonInternEndDate
				
			var PersonStudyPref=Ext.getCmp('PersonStudyPref').getValue();
			var PersonWorkUnit=Ext.getCmp('PersonWorkUnit').getValue();
			var PersonWorkDateTime=Ext.getCmp('PersonWorkDateTime').getValue();
			if(!PersonWorkDateTime){
				Ext.Msg.alert('提示','参加工作日期不能为空！');
				return;
			}else{
				if(PersonWorkDateTime instanceof Date){
					PersonWorkDateTime=PersonWorkDateTime.format('Y-m-d');
				}
			}
			var parr="PersonType2|"+type+"^rw|"+rw+"^PersonID|"+PersonID+"^"+strr+"^PersonStudyPref|"+PersonStudyPref+
								"^PersonWorkUnit|"+PersonWorkUnit+"^PersonWorkDateTime|"+PersonWorkDateTime;
		}else if(type=="W"){
			if(PersonID){
				var PersonID=PersonID.toLocaleUpperCase()
				var fdStart=PersonID.indexOf('RH');
				if(fdStart!=0){
					Ext.Msg.alert('提示','请在工号前加"RH"');
					return;
				}
			}
			//var strr=fillItem();
			var PersonName=Ext.getCmp('PersonName').getValue();
			if(!PersonName){
				Ext.Msg.alert('提示','姓名不能为空！');
				return;
			}
			var PersonSexDR=Ext.getCmp('PersonSexDR').getValue();
			var PersonDepDR=Ext.getCmp('PersonDepDR').getValue();
			if(!PersonDepDR){
				Ext.Msg.alert('提示','科室不能为空！');
				return;
			}
			var PersonBirthDay1="";
			var PersonBirthDay=Ext.getCmp('PersonBirthDay').getValue();
			if(!PersonBirthDay){
				Ext.Msg.alert('提示','出生日期不能为空！');
				return;
			}else{
				if(PersonBirthDay instanceof Date){
					PersonBirthDay=PersonBirthDay.format('Y-m-d');
					var PersonBirthDay1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonBirthDay);
				}
			}
			var PersonAdmHosDate1="";
			var PersonAdmHosDate=Ext.getCmp('PersonAdmHosDate').getValue();
			if(!PersonAdmHosDate){
				Ext.Msg.alert('提示','来院日期不能为空！');
				return;
			}else{
				if(PersonAdmHosDate instanceof Date){
					PersonAdmHosDate=PersonAdmHosDate.format('Y-m-d');
					PersonAdmHosDate1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonAdmHosDate);
					if(PersonAdmHosDate1<PersonBirthDay1){
						Ext.Msg.alert('提示',"来院日期不能小于出生日期！");
						return;
					}
				}
			}
			var PersonTelHand=Ext.getCmp('PersonTelHand').getValue();
			var PersonInternAddress=Ext.getCmp('PersonInternAddress').getValue();
			var PersonInternStDate1="";
			var PersonInternStDate=Ext.getCmp('PersonInternStDate').getValue();
			if(!PersonInternStDate){
				Ext.Msg.alert('提示','开始日期不能为空！');
				return;
			}else{
				if(PersonInternStDate instanceof Date){
					PersonInternStDate=PersonInternStDate.format('Y-m-d');
					PersonInternStDate1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonInternStDate);
					if(PersonInternStDate1<PersonAdmHosDate1){
						Ext.Msg.alert('提示',"开始日期不能小于来院日期！");
						return;
					}
				}
			}
			var PersonInternEndDate=Ext.getCmp('PersonInternEndDate').getValue();
			if(!PersonInternEndDate){
				Ext.Msg.alert('提示','结束日期不能为空！');
				return;
			}else{
				if(PersonInternEndDate instanceof Date){
					PersonInternEndDate=PersonInternEndDate.format('Y-m-d');
					var PersonInternEndDate1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonInternEndDate);
					if(PersonInternEndDate1<PersonInternStDate1){
						Ext.Msg.alert('提示',"结束日期不能小于开始日期！");
						return;
					}
				}
			}
			var strr="PersonName|"+PersonName+"^PersonSexDR|"+PersonSexDR+"^PersonDepDR|"+PersonDepDR+
							"^PersonBirthDay|"+PersonBirthDay+"^PersonAdmHosDate|"+PersonAdmHosDate+"^PersonTelHand|"+PersonTelHand
							+"^PersonInternAddress|"+PersonInternAddress+"^PersonInternStDate|"+PersonInternStDate
							+"^PersonInternEndDate|"+PersonInternEndDate;
			
			var PersonWorkDateTime=Ext.getCmp('PersonWorkDateTime').getValue();
			if(!PersonWorkDateTime){
				Ext.Msg.alert('提示','参加工作日期不能为空！');
				return;
			}else{
				if(PersonWorkDateTime instanceof Date){
					PersonWorkDateTime=PersonWorkDateTime.format('Y-m-d');
				}
			}
			var PersonGRType=Ext.getCmp('PersonGRType').getValue();
			if(!PersonGRType){
				Ext.Msg.alert('提示','工人类型不能为空！');
				return;
			}
			
			var parr="PersonType2|"+type+"^rw|"+rw+"^PersonID|"+PersonID+"^"+strr+"^PersonWorkDateTime|"+PersonWorkDateTime+
							"^PersonGRType|"+PersonGRType;
		}else if(type=="U"){
			if(PersonID){
				var PersonID=PersonID.toLocaleUpperCase()
				var fdStart=PersonID.indexOf('RH');
				if(fdStart!=0){
					Ext.Msg.alert('提示','请在工号前加"NR"');
					return;
				}
			}
			Ext.getCmp('createperid').hide();
			var PersonName=Ext.getCmp('PersonName').getValue();
			if(!PersonName){
				Ext.Msg.alert('提示','姓名不能为空！');
				return;
			}
			var PersonSexDR=Ext.getCmp('PersonSexDR').getValue();
			var PersonDepDR=Ext.getCmp('PersonDepDR').getValue();
			if(!PersonDepDR){
				Ext.Msg.alert('提示','科室不能为空！');
				return;
			}
			var PersonBirthDay1="";
			var PersonBirthDay=Ext.getCmp('PersonBirthDay').getValue();
			if(!PersonBirthDay){
				Ext.Msg.alert('提示','出生日期不能为空！');
				return;
			}else{
				if(PersonBirthDay instanceof Date){
					PersonBirthDay=PersonBirthDay.format('Y-m-d');
					var PersonBirthDay1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonBirthDay);
				}
			}
			var PersonAdmHosDate1="";
			var PersonAdmHosDate=Ext.getCmp('PersonAdmHosDate').getValue();
			if(!PersonAdmHosDate){
				Ext.Msg.alert('提示','来院日期不能为空！');
				return;
			}else{
				if(PersonAdmHosDate instanceof Date){
					PersonAdmHosDate=PersonAdmHosDate.format('Y-m-d');
					PersonAdmHosDate1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonAdmHosDate);
					if(PersonAdmHosDate1<PersonBirthDay1){
						Ext.Msg.alert('提示',"来院日期不能小于出生日期！");
						return;
					}
				}
			}
			var PersonTelHand=Ext.getCmp('PersonTelHand').getValue();
			var PersonInternAddress=Ext.getCmp('PersonInternAddress').getValue();
			var PersonInternStDate1="";
			var PersonInternStDate=Ext.getCmp('PersonInternStDate').getValue();
			if(!PersonInternStDate){
				Ext.Msg.alert('提示','开始日期不能为空！');
				return;
			}else{
				if(PersonInternStDate instanceof Date){
					PersonInternStDate=PersonInternStDate.format('Y-m-d');
					PersonInternStDate1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonInternStDate);
					if(PersonInternStDate1<PersonAdmHosDate1){
						Ext.Msg.alert('提示',"开始日期不能小于来院日期！");
						return;
					}
				}
			}
			var PersonInternEndDate=Ext.getCmp('PersonInternEndDate').getValue();
			if(!PersonInternEndDate){
				Ext.Msg.alert('提示','结束日期不能为空！');
				return;
			}else{
				if(PersonInternEndDate instanceof Date){
					PersonInternEndDate=PersonInternEndDate.format('Y-m-d');
					var PersonInternEndDate1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonInternEndDate);
					if(PersonInternEndDate1<PersonInternStDate1){
						Ext.Msg.alert('提示',"结束日期不能小于开始日期！");
						return;
					}
				}
			}
			var strr="PersonName|"+PersonName+"^PersonSexDR|"+PersonSexDR+"^PersonDepDR|"+PersonDepDR+
							"^PersonBirthDay|"+PersonBirthDay+"^PersonAdmHosDate|"+PersonAdmHosDate+"^PersonTelHand|"+PersonTelHand
							+"^PersonInternAddress|"+PersonInternAddress+"^PersonInternStDate|"+PersonInternStDate+
							"^PersonInternEndDate|"
			var PersonWorkDateTime=Ext.getCmp('PersonWorkDateTime').getValue();
			if(!PersonWorkDateTime){
				Ext.Msg.alert('提示','参加工作日期不能为空！');
				return;
			}else{
				if(PersonWorkDateTime instanceof Date){
					PersonWorkDateTime=PersonWorkDateTime.format('Y-m-d');
				}
			}
			var parr="PersonType2|"+type+"^rw|"+rw+"^PersonID|"+PersonID+"^"+strr+"^PersonWorkDateTime|"+PersonWorkDateTime;
		}
		var ret=tkMakeServerCall('web.DHCMgNurSchComm','SaveInformal',parr);
		Ext.getCmp('gform2').close();
	}

//	Ext.getCmp('gform2').close();
	findRec();
	
}
function fillItem(){
		var PersonName=Ext.getCmp('PersonName').getValue();
		var PersonSexDR=Ext.getCmp('PersonSexDR').getValue();
		var PersonDepDR=Ext.getCmp('PersonDepDR').getValue();
		var PersonBirthDay=Ext.getCmp('PersonBirthDay').getValue();
		if(!PersonBirthDay){
			Ext.Msg.alert('提示','出生日期不能为空！');
			return;
		}else{
			if(PersonBirthDay instanceof Date){
				PersonBirthDay=PersonBirthDay.format('Y-m-d');
			}
		}
		var PersonAdmHosDate=Ext.getCmp('PersonAdmHosDate').getValue();
		if(!PersonAdmHosDate){
			Ext.Msg.alert('提示','来院日期不能为空！');
			return;
		}else{
			if(PersonAdmHosDate instanceof Date){
				PersonAdmHosDate=PersonAdmHosDate.format('Y-m-d');
			}
		}
		var PersonTelHand=Ext.getCmp('PersonTelHand').getValue();
		var PersonInternAddress=Ext.getCmp('PersonInternAddress').getValue();
		var PersonInternStDate=Ext.getCmp('PersonInternStDate').getValue();
		if(!PersonInternStDate){
			Ext.Msg.alert('提示','开始日期不能为空！');
			return;
		}else{
			if(PersonInternStDate instanceof Date){
				PersonInternStDate=PersonInternStDate.format('Y-m-d');
			}
		}
		var PersonInternEndDate=Ext.getCmp('PersonInternEndDate').getValue();
		if(!PersonInternEndDate){
			Ext.Msg.alert('提示','结束日期不能为空！');
			return;
		}else{
			if(PersonInternEndDate instanceof Date){
				PersonInternEndDate=PersonInternEndDate.format('Y-m-d');
			}
		}
		var str="PersonName|"+PersonName+"^PersonSexDR|"+PersonSexDR+"^PersonDepDR|"+PersonDepDR+
						"^PersonBirthDay|"+PersonBirthDay+"^PersonAdmHosDate|"+PersonAdmHosDate+"^PersonTelHand|"+PersonTelHand
						+"^PersonInternAddress|"+PersonInternAddress+"^PersonInternStDate|"+PersonInternStDate
						+"^PersonInternEndDate|"+PersonInternEndDate
		return str;
}

function importRec()
{
	if(perTyp.getValue()=="")
	{
		Ext.Msg.alert('提示',"请选择要导入的人员类型");
		return;
	}
	var form = new Ext.form.FormPanel({
		baseCls : 'x-plain',
		labelWidth : 70,
		fileUpload : true,
		defaultType : 'textfield',
		items : [{
			xtype : 'textfield',
			fieldLabel : '请选择文件',
			name : 'filename',
			id : 'filename',
			inputType : 'file',			
			blankText : 'File can\'t not empty.',
			anchor : '100%'
		}]
	});    
	var winUpload = new Ext.Window({
		id:'winUpload',
		title : '文件上传',
		width : 400,
		height : 100,
		minWidth : 300,
		minHeight : 100,
		layout : 'fit',
		plain : true,
		modal:true,
		closable:false,
		resizable:false,
		bodyStyle : 'padding:5px;',
		buttonAlign : 'center',
		items : [form],
		buttons : [{
			text : '确定',
			id:'importSubmit',
			handler:''
	 	}, {
	 		text : '关闭',
	 		handler : function() {winUpload.close();}
		}]
	});
	winUpload.show();
	Ext.getCmp('importSubmit').on('click',function(){
		var filepath=Ext.getCmp('filename').getValue();
		if(filepath=="")
		{
			Ext.Msg.alert('提示','请选择要导入的文件！')
			return;
		}
		var progressBar=Ext.Msg.show({
			title:"数据导入",
			msg:"数据导入进度：(0/"+rowlen+")",
			progress:true,
			//progressText:'当前导入进度：0',
			width:300
		});
		var datalist=new Array();
		var i=2;
		var bartext="";
		var curnum=0;
		var xls = new ActiveXObject("Excel.Application");
		var xlBook = xls.Workbooks.open(filepath);
		xlBook.worksheets(1).select();
		var xlSheet = xlBook.ActiveSheet;
		var rowlen=xlSheet.UsedRange.Cells.Rows.Count;
		var collen=xlSheet.UsedRange.Columns.Count;	
		var colarr=['PersonID','PersonName','PersonSex','PersonIdentity','PersonDep','PersonStDate','PersonEndDate','PersonPhone','PersonAddress','PersonType'];
		var task={
			run:function () {
				if(Ext.getCmp('winUpload')!=null){
					Ext.getCmp('winUpload').close(); 
				}
				var parm="";
				for(var col=1;col<=collen;col++)
				{
					var cellvalue=xlSheet.Cells(i,col).Value;
					if(colarr[col-1].indexOf('Date')!=-1){
						if(new Date(cellvalue).format('Y-m-d')!="NaN-NaN-NaN")
						{
							cellvalue=new Date(cellvalue).format('Y-m-d');
						}
					}
					if(cellvalue==undefined) cellvalue="";
					parm=parm+"^"+colarr[col-1]+"|"+cellvalue
				}
				parm=parm+"^"+colarr[collen]+"|"+perTyp.getValue();
				datalist.push(parm);
				if (i>=rowlen) {
					//progressBar.updateProgress(1,"处理完成");
					progressBar.hide();
					Ext.TaskMgr.stop(task);
					xlBook.Close (savechanges=false);
					xls.Quit();
					idTmr = window.setInterval("Cleanup();",1);
				}
				if(i%50==0||i>=rowlen)
				{
					var parr=datalist.toString().replace(/\,/g,'@');
					var ret=tkMakeServerCall("web.DHCMgImportDataComm","ImportPerson",parr);
					parr=""
				}
				curnum=i/rowlen;
				bartext="当前导入:"+parseInt(curnum*100)+"%";
				progressBar.updateProgress(curnum,bartext);
				progressBar.updateText("数据导入进度：("+i+"/"+rowlen+")")
				i++;
			},
			interval:100
		};
		Ext.TaskMgr.start(task);
	});
}

function Cleanup(){   
 	window.clearInterval(idTmr);   
 	CollectGarbage();
}