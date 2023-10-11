var Width = document.body.clientWidth-5;
var Height = document.body.clientHeight-3;
var stdate=new Ext.form.DateField({
	id:'stdate',
	format:'Y-m-d',
	tabIndex:'0',
	height:22,
	width:100,
	xtype:'datefield',
	value:new Date().getFirstDateOfMonth()
});
var eddate=new Ext.form.DateField({
	id:'enddate',
	format:'Y-m-d',
	tabIndex:'0',
	height:22,
	width:100,
	xtype:'datefield',
	value:new Date().getLastDateOfMonth()
});
var WardLoc=new Ext.form.ComboBox({
	id:'wardLoc',
	typeAhead:true,
	store:new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:"../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'results',
			fields:[{
				'name':'LocDes',
				'mapping':'LocDes'
			},{
				'name':'LocDr',
				'mapping':'LocDr'
			}]
		}),
		baseParams:{
			className:'web.DHCMgNurQcRestruct',
			methodName:'FindWardLoc',
			type:'Query'
		}
	}),
	tabIndex:'0',
	listWidth:'400',
	height:18,
	width:191,
	xtype:'combo',
	displayField:'LocDes',
	valueField:'LocDr',
	hideTrigger:false,
	queryParam:'HsDr',
	forceSelection:true,
	triggerAction:'all',
	minChars:1,
	pageSize:10000,
	typeAhead:false,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
var chkTyp=new Ext.form.ComboBox({
	id:'chtyp',
	tabIndex:'0',
	height:20,
	width:100,
	xtype:'combo',
	store:new Ext.data.JsonStore({
		data:[{
			desc:'护士长',
			id:'W'
		},{
			desc:'科护士长',
			id:'Z'
		},{
			desc:'护理部',
			id:'H'
		}],
		fields:['desc','id']
	}),
	displayField:'desc',
	valueField:'id',
	allowBlank:true,
	triggerAction:'all',
	mode:'local',
	value:''
});
//var DHCMGNurCheckGradeT101=new Ext.data.Store({proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',fields:[{'name':'ItemCode','mapping':'ItemCode'},{'name':'ItemDesc','mapping':'ItemDesc'},{'name':'ItemValue','mapping':'ItemValue'},{'name':'ItemDedStand','mapping':'ItemDedStand'},{'name':'CheckScore','mapping':'CheckScore'},{'name':'CheckMem','mapping':'CheckMem'},{'name':'Complete','mapping':'Complete'},{'name':'CheckPeople','mapping':'CheckPeople'},{'name':'rw','mapping':'rw'},{'name':'Par','mapping':'Par'},{'name':'MinLevel','mapping':'MinLevel'}]}),baseParams:{className:'web.DHCMgQualCheck',methodName:'GetQualItemGrade',type:'RecQuery'}});
//var DHCMgNurCheckScoreT106=new Ext.data.JsonStore({data:[],fields:['ItemCode','ItemDesc','ItemValue','ItemDedStand','CheckScore','CheckMem','Complete','CheckPeople','rw','Par','MinLevel']});

var secGrpFlag=toMgSecGrp(session['LOGON.GROUPID']);
function BodyLoadHandler()
{
	var gridpl = Ext.getCmp('mygridpl');
	gridpl.setWidth(Width);
	gridpl.setHeight(Height-25);
	if(CheckRoomId!=""){
    var checkRet = tkMakeServerCall('DHCMGNUR.MgCheckWard','getVal',CheckRoomId);
    var ha = new Hashtable();
    var tm = checkRet.split('^')
    sethashvalue(ha,tm);
    CheckTyp = ha.items("CheckTyp");
 	  CheckDate=ha.items("CheckDate");
 	  if(Ext.getCmp('stdate') && ha.items('CheckStDate')){
 	  	Ext.getCmp('stdate').setValue(ha.items('CheckStDate'));
 	  }
 		if(Ext.getCmp('enddate') && ha.items('CheckEdDate')){
 			Ext.getCmp('enddate').setValue(ha.items('CheckEdDate'));
 		}
 		if(Ext.getCmp('chtyp') && ha.items('NurTyp')){
 			Ext.getCmp('chtyp').setValue(ha.items('NurTyp'));
 		}
  }
  chkTyp.disable();
	var grid = Ext.getCmp('mygrid');
	grid.getTopToolbar().hide();
	var tbar1 = new Ext.Toolbar();
	tbar1.addItem('-','类型:',chkTyp);
	tbar1.addItem('-','查询病区:',WardLoc);
	tbar1.addItem('-','开始日期:',stdate);
	tbar1.addItem('-','结束日期:',eddate);
	var tbar2 = new Ext.Toolbar({});
	tbar2.addItem("-");
	tbar2.addButton({
		text:"新建",
		icon:'../Image/light/useradd.png',
		handler:function(){NewCheck();},
		id:'btnnew'
	});
	tbar2.addItem("-");
	tbar2.addButton({
		text:"编辑",
		handler:function(){ModCheck();},
		icon:'../image/light/useredit.png',
		id:'btnmod'
	});
	tbar2.addItem("-");
	tbar2.addButton({
		text:"删除",
		handler:function(){delChkRec();},
		icon:'../Image/light/delete.gif',
		id:'btndelete'
	});
	tbar2.addItem("-");
	tbar2.addButton({
		text:"查询",
		icon:'../image/light/search.png',
		handler:function(){var grid = Ext.getCmp('mygrid');SchQual(grid,30);},
		id:'btnSch'
	});
	tbar2.addItem("-");
	tbar2.addButton({
	className: 'new-topic-button',
	text : "质控问题汇总",
	handler : function() {exportFn();
	},
	id : 'btnexport'
	});
	grid.getBottomToolbar().hide();
	setBottomTool(grid,30);
	tbar1.render(grid.tbar);
	tbar2.render(grid.tbar);
	WardLoc.store.on('beforeload',function() {
		var laststr1 = WardLoc.lastQuery
		if (laststr1 != undefined)
			WardLoc.store.baseParams.ward = laststr1;
		WardLoc.store.baseParams.HsDr = 1;
		WardLoc.store.baseParams.nurtype = secGrpFlag+"^"+session['LOGON.USERID']+"^"+chkTyp.getValue();
	});
	grid.store.on('beforeload',function(){
		var stdate = Ext.getCmp('stdate').getValue();
		if(stdate){
			if(stdate instanceof Date){
				stdate = stdate.format('Y-m-d');
			}
		}
		var eddate = Ext.getCmp('enddate').getValue();
		if(eddate){
			if(eddate instanceof Date){
				eddate = eddate.format('Y-m-d');
			}
		}
		var ward = Ext.getCmp('wardLoc').getValue();
		grid.store.baseParams.QualDr = CheckRoomId;
		grid.store.baseParams.WardLoc = ward;
		grid.store.baseParams.CheckCode = CheckCode;
		grid.store.baseParams.ckDate = stdate+"^"+eddate;
		grid.store.baseParams.typ = Ext.getCmp('chtyp').getValue();
		grid.store.baseParams.qtype = qtype;
	});
	var len=grid.getColumnModel().getColumnCount()
  for(var i=0;i<len;i++){
		if(grid.getColumnModel().getDataIndex(i) == 'rw'){
			grid.getColumnModel().setHidden(i,true);
		}
	}
	SchQual(grid,30);
}
function delChkRec()
{
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if(rowObj.length == 0){
		Ext.Msg.alert('提示','请选择一条记录！');
		return;
	}else{
		Ext.Msg.show({    
       title:'确认删除',    
       msg:'你确定要删除此条记录吗?',    
       buttons:{'ok':'确定','cancel':'取消'},
       fn:function(btn, text){    
            if (btn == 'ok'){    
							var Par = rowObj[0].get('rw');
							tkMakeServerCall('Nur.QualCheckRec','delQual',Par);
							SchQual(grid,1000);
            }    
       },    
       animEl: 'newbutton'   
    });
	}
}
function ModCheck()
{
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		alert("请选择一条记录！");
		return;
	}
	var Par=rowObj[0].get("rw");
	Check(Par);
}
function SchQual(grid,size)
{
	grid.store.load({params:{start:0,limit:size}});
}
function NewCheck()
{
	Check('');
}
function Check(Par)
{
	var DHCMgNurCheckScoreT106=new Ext.data.Store({proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',fields:[{'name':'ItemCode','mapping':'ItemCode'},{'name':'ItemDesc','mapping':'ItemDesc'},{'name':'ItemValue','mapping':'ItemValue'},{'name':'ItemDedStand','mapping':'ItemDedStand'},{'name':'CheckScore','mapping':'CheckScore'},{'name':'CheckMem','mapping':'CheckMem'},{'name':'CheckPeople','mapping':'CheckPeople'},{'name':'Complete','mapping':'Complete'},{'name':'rw','mapping':'rw'},{'name':'Par','mapping':'Par'},{'name':'MinLevel','mapping':'MinLevel'},{'name':'QualPar','mapping':'QualPar'},{'name':'QualRw','mapping':'QualRw'}]}),baseParams:{className:'web.DHCMgNurQcRestruct',methodName:'FindQualChkItms',type:'RecQuery'}});

	var arr=new Array();
	var a=cspRunServerMethod(pdata1,"","DHCMgNurCheckScore","","");
	arr=eval(a);
	win=new Ext.Window({
		title:'质控检查',
		id:'gform2',
		x:10,y:2,
		width:962,
		height:605,
		autoScroll:true,
		layout:'absolute',
		modal:true,
		resizable:false,
		items:[arr]
	});
	win.show();
	sm1.handleMouseDown=Ext.emptyFn;
	var hd_checker = Ext.getCmp('mygrid1').getEl().select('div.x-grid3-hd-checker');
	hd_checker.removeClass('x-grid3-hd-checker'); // 去掉全选框
	var grid1pl = Ext.getCmp('mygrid1pl');
	grid1pl.setWidth(win.getInnerWidth());
	grid1pl.setHeight(win.getInnerHeight()-66);
	var grid1 = Ext.getCmp('mygrid1');
	grid1.getTopToolbar().hide();
	grid1.getBottomToolbar().hide();
	//setBottomTool(grid1,1000);
	var ItmScore =tkMakeServerCall('web.DHCMgNurQcRestruct','getQualModelScore',CheckCode,qtype);
	sm1.on('rowselect',function(sm_,rowIndex,record){
		var CheckWard=Ext.getCmp('CheckWard').getValue();
		if (CheckWard==""){
			Ext.Msg.alert('提示',"请先选择检查病区");
			iniform(1000);
			return;
		}
		var row = record;
		//分值
		var itmvalue = parseFloat(row.get("ItemValue")).toFixed(2);
		row.set("CheckScore",itmvalue);
		numflag=isNaN(row.get("ItemValue"));
		var numflag=isNaN(row.get("CheckScore"));
		if (numflag==true)
			row.set("CheckScore","");
		if (numflag == true){
			Ext.Msg.alert('提示',"分值类型不对！");
			return;
		}
		//最低级标识
		var flag=row.get("MinLevel");
		//序号
		var ItemCode=row.get("ItemCode");
		//项目内容
		var ItemDesc=row.get("ItemDesc");
		//设置扣分原因
		row.set("CheckMem",ItemDesc);
		//扣分原因
		var CheckMem=row.get("CheckMem");
		//检查对象
		var People=row.get("CheckPeople");
		if (flag=="N"){
			row.set("CheckScore","");
			row.set("CheckMem","");
			Ext.Msg.alert('提示',"不能选小标题，请重新选择");
			grid1.getView().getRow(rowIndex).style.backgroundColor='#855E42';
			return;
		}
		var checkscore=parseFloat(row.get("CheckScore")).toFixed(2);
		if(parseFloat(checkscore) > parseFloat(itmvalue)){
			row.set("CheckScore","");
		}else{
			//row.set('CheckScore',itmvalue)
		}
		SetScore(ItmScore);
	},this);
	// 行未选中的时候
	sm1.on('rowdeselect',function(sm_,rowIndex,record){
		var row=record;
		var ItemCode=row.get("ItemCode");
		row.set("CheckScore","");
		row.set("CheckMem","");
		SetScore(ItmScore);
	},this);
	var checkWard = Ext.getCmp('CheckWard');
  checkWard.store.on("beforeload",function(){
    checkWard.store.baseParams.HsDr=1;
    var laststr2=checkWard.lastQuery
    if(laststr2!=undefined){checkWard.store.baseParams.ward=laststr2;}
    checkWard.store.baseParams.nurtype = secGrpFlag+"^"+session['LOGON.USERID']+"^"+Ext.getCmp('chtyp').getValue();
  });
  var chPat = Ext.getCmp('CheckPat');
  checkWard.on('select',function(){
  	iniform(1000);
  	Ext.getCmp('Score').setValue(ItmScore);
  	Ext.getCmp('compRateField').setValue('100%');
  	chPat.setValue('');
  	chPat.store.removeAll();
  	chPat.store.load({params:{start:0,limit:1000}})
  });
  chPat.store.on('beforeload',function(){
	 	chPat.store.baseParams.ward = checkWard.getValue();
 	});
 	Ext.getCmp('CheckDate').setValue(new Date());
	grid1.store.on('beforeload',function(){
		grid1.store.baseParams.parr = qtype + "^" + CheckCode + "^" + Par;
	});
	//grid1.store.load({params:{start:0,limit:1000},callback:function(){
	//	iniform(1000);
	//}});
	var len=grid1.getColumnModel().getColumnCount()
  for(var i=0;i<len;i++){
		if(grid1.getColumnModel().getDataIndex(i)=="ItemDedStand"){
			grid1.getColumnModel().setHidden(i,true);
		}
		if(grid1.getColumnModel().getDataIndex(i)=="CheckPeople"){
			grid1.getColumnModel().setHidden(i,true);
		}
	}
	var btnSure = Ext.getCmp('btnSure');
	btnSure.on('click',function(){SureCheck(Par);});
	if(Par != ""){
		var ret = tkMakeServerCall('Nur.QualCheckRec','getRecData',Par);
		var ha = new Hashtable();
		var tm = ret.split('^');
		sethashvalue(ha,tm);
		var CheckWard = Ext.getCmp('CheckWard');
		//setComStore(CheckWard,true,ha);
		var CheckPat = Ext.getCmp('CheckPat');
		CheckWard.store.load({params:{start:0,limit:1000},callback:function(){
			if(ha.items(CheckWard.getId())){
				CheckWard.setValue(ha.items(CheckWard.getId()));
			}
			CheckWard.disable();
			CheckPat.store.load({params:{start:0,limit:1000},callback:function(){
				if(ha.items(CheckPat.getId())){
					CheckPat.setValue(ha.items(CheckPat.getId()));
				}	
			}})
		}})
		var CheckDate = Ext.getCmp('CheckDate');
		setDateStore(CheckDate,true,ha);
		var compRateField = Ext.getCmp('compRateField');
		if(ha.items('compRateField')&&compRateField){
			compRateField.setValue(ha.items('compRateField'));
		}
		var Score = Ext.getCmp('Score');
		if(ha.items('Score')&&Score){
			Score.setValue(ha.items('Score'));
		}
	}
	setTimeout(function(){
		var gridstore = grid1.store;
		gridstore.load({params:{start:0,limit:1000},callback:function(){
			//iniform(1000);
			var n = gridstore.getCount();
			var arrsel = new Array();
			for (var j = 0; j < n; j++) {
				var CheckScore = gridstore.getAt(j).get('CheckScore');
				if (CheckScore != "") {
					arrsel[j] = j;
				}
				if (gridstore.getAt(j).get('MinLevel') == "N"){
					grid1.getView().getRow(j).style.backgroundColor='#855E42';
				}
			}
			grid1.getSelectionModel().selectRows(arrsel, true);	
		}});
	},1000);
	
	var len=grid1.getColumnModel().getColumnCount()
  for(var i=0;i<len;i++){
		if(grid1.getColumnModel().getDataIndex(i)=='rw'){
			grid1.getColumnModel().setHidden(i,true);
		}
		if(grid1.getColumnModel().getDataIndex(i)=='Par'){
			grid1.getColumnModel().setHidden(i,true);
		}
		if(grid1.getColumnModel().getDataIndex(i)=='MinLevel'){
			grid1.getColumnModel().setHidden(i,true);
		}
		if(grid1.getColumnModel().getDataIndex(i)=='QualPar'){
			grid1.getColumnModel().setHidden(i,true);
		}
		if(grid1.getColumnModel().getDataIndex(i)=='QualRw'){
			grid1.getColumnModel().setHidden(i,true);
		}
	}
}
function setDateStore(obj,flag,ha)
{
	//debugger
	if(ha.items(obj.getId())){
		obj.setValue(ha.items(obj.getId()));
		if(flag==true) obj.disable();
	}
}
function setComStore(obj,flag,ha)
{
	//debugger
	obj.store.load({params:{start:0,limit:1000},callback:function(){
		if(ha.items(obj.getId())){
			obj.setValue(ha.items(obj.getId()));
			//obj.selectText()
			if(flag==true)obj.disable();
		}	
	}})
}
function SureCheck(Par)
{
	var checkDate = Ext.getCmp('CheckDate').getValue();
	if(!checkDate){
		Ext.Msg.alert('提示','请选择检查日期！');
		return;
	}else{
		if(checkDate instanceof Date){
			checkDate = checkDate.format('Y-m-d');
		}
	}
	var checkWard=Ext.getCmp("CheckWard").getValue();
	if(!checkWard){
		Ext.Msg.alert('提示','请选择检查病区！');
		return;
	}
	var checkPat = Ext.getCmp("CheckPat").getValue();
	var checkcomplete = Ext.getCmp('compRateField').getValue();
	var TScore = Ext.getCmp('Score').getValue();
	var ChkTyp=Ext.getCmp('chtyp').getValue();
	/* if((CheckTyp=="QualSelfCheck")&&(Par=="")){
		for(var j = 0; j < 4; j++){
			var checkDate2=Ext.getCmp('CheckDate').getValue().format('Y/m/d');
		    var checkDate3=new Date(checkDate2);
			checkDate3=checkDate3.add(Date.DAY,7*j).format('Y-m-d');
			alert(checkDate3)
			var CheckPar = tkMakeServerCall('Nur.QualCheckRec','SaveNurRec',checkDate3,session['LOGON.USERID'],ChkTyp,CheckCode,checkWard,TScore,"",checkPat,Par,CheckRoomId,'','',checkcomplete,CheckTyp,qtype);
			if(CheckPar!=""){
				tkMakeServerCall('Nur.QualCheckRec','clearRecData',CheckPar);
				var grid = Ext.getCmp('mygrid1');
				for (var i = 0; i < grid.store.getCount(); i++){
					var checkCode = grid.store.getAt(i).get('ItemCode');
					var CheckDesc = grid.store.getAt(i).get('ItemDesc');
					var CheckValue = grid.store.getAt(i).get('ItemValue');
					var CheckMem = grid.store.getAt(i).get('CheckMem');
					var CheckScore = grid.store.getAt(i).get('CheckScore');
					var QualPar = grid.store.getAt(i).get('QualPar');
					var QualRw = grid.store.getAt(i).get('QualRw');
					var Complete = grid.store.getAt(i).get('Complete');
					tkMakeServerCall('Nur.QualCheckRec','SaveNurChildRec',CheckPar,checkCode,CheckDesc,CheckValue,CheckMem,CheckScore,Complete,QualPar,QualRw)
				}
				//Ext.Msg.alert('提示','保存成功！');
			}
		}
	}else{ */
		var CheckPar = tkMakeServerCall('Nur.QualCheckRec','SaveNurRec',checkDate,session['LOGON.USERID'],ChkTyp,CheckCode,checkWard,TScore,"",checkPat,Par,CheckRoomId,'','',checkcomplete,CheckTyp,qtype);
		if(CheckPar!=""){
			tkMakeServerCall('Nur.QualCheckRec','clearRecData',CheckPar);
			var grid = Ext.getCmp('mygrid1');
			for (var i = 0; i < grid.store.getCount(); i++){
				var checkCode = grid.store.getAt(i).get('ItemCode');
				var CheckDesc = grid.store.getAt(i).get('ItemDesc');
				var CheckValue = grid.store.getAt(i).get('ItemValue');
				var CheckMem = grid.store.getAt(i).get('CheckMem');
				var CheckScore = grid.store.getAt(i).get('CheckScore');
				var QualPar = grid.store.getAt(i).get('QualPar');
				var QualRw = grid.store.getAt(i).get('QualRw');
				var Complete = grid.store.getAt(i).get('Complete');
				
				//tkMakeServerCall('Nur.CheckRoom','SaveSubQualItms',checkPar,CheckCode,CheckDesc,CheckValue,CheckMem,CheckScore,QualPar,QualRw);
				tkMakeServerCall('Nur.QualCheckRec','SaveNurChildRec',CheckPar,checkCode,CheckDesc,CheckValue,CheckMem,CheckScore,Complete,QualPar,QualRw)
			}
			Ext.Msg.alert('提示','保存成功！');
		}
	//}	
	Ext.getCmp('gform2').close();
	var mygrid = Ext.getCmp('mygrid');
	SchQual(mygrid,30);
}
function SetScore(ItmScore)
{
	var grid = Ext.getCmp('mygrid1');
	var totalScore = ItmScore;
	var count2 = 0;
	var count3 = 0;
	for(var i = 0;i < grid.store.getCount();i++){
		var flag = grid.store.getAt(i).get('CheckScore');
		if(flag){
			grid.store.getAt(i).set('Complete','未完成');
			count2++;
		}else{
			grid.store.getAt(i).set('Complete','已完成');
		}
		if(grid.store.getAt(i).get('MinLevel')=='Y'){
			count3++;
		}
	}
	for(var j = 0;j < grid.store.getCount();j++){
		if(grid.store.getAt(j).get('CheckScore')){
			if(grid.store.getAt(j).get('MinLevel')=='N') continue;
			totalScore =totalScore - grid.store.getAt(j).get('ItemValue');
		}else{
			if(grid.store.getAt(j).get('MinLevel')=='N') continue;
			totalScore = parseFloat(parseFloat(totalScore).toFixed(2) + parseFloat(grid.store.getAt(j).get('ItemValue')).toFixed(2)).toFixed(2);
		}
	}
	
	Ext.getCmp('Score').setValue(totalScore);
	var compRate = parseFloat((((parseInt(count3)-parseInt(count2))/parseInt(count3)).toFixed(4))*100).toFixed(2);
	Ext.getCmp('compRateField').setValue(compRate+"%");
}
function iniform(pagesize)
{
	//Ext.getCmp("CheckScore").setValue(QualScore);
	var mygrid=Ext.getCmp('mygrid1');
	mygrid.store.load({
		params:{
			start:0,
			limit:pagesize
		},
		callback:function(){
			var n = mygrid.getStore().getCount();
			for(var j=0;j<n;j++){
				if(mygrid.store.getAt(j).get("MinLevel")=="N"){
			    mygrid.getView().getRow(j).style.backgroundColor='#855E42';
				}
			}
			setqualitm(mygrid);
		}			
	});
}
function setqualitm(grid)
{
	var rowCount = grid.store.getCount(); // 记录数
	for (var i = 0;i < rowCount;i++){
		if(grid.store.getAt(i).data['MinLevel']=="Y"){
			grid.store.getAt(i).set("Complete","已完成");
		}
	}
}
function setBottomTool(grid,pageSize)
{
	var bbar1 = new Ext.PagingToolbar({
		pageSize:pageSize,
		store:grid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bbar1.render(grid.bbar);
}
function exportFn() 
{ 
	//alert("a");
	//debugger
	wordcontorl();
	return;
	var xls = new ActiveXObject ("Excel.Application"); 
	 
	xls.visible =true;  //设置excel为可见 
	var xlBook = xls.Workbooks.Add; 
	var xlSheet = xlBook.Worksheets(1); 
	
	//var grid = Ext.getCmp('ApplyRecordGrid');
  var grid = Ext.getCmp("mygrid");
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
		xlSheet.Cells(1,i).Value = cm.getColumnHeader(temp_obj[i - 1]); 
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
	xls.ActiveWindow.Zoom =100
	xls.UserControl = true;  //很重要,不能省略,不然会出问题 意思是excel交由用户控制 
  xls=null; 
  xlBook=null; 
  xlSheet=null; 
}
function wordcontorl() {

	var ret=tkMakeServerCall("web.DHCMgQualCheck","getQuestions",CheckRoomId);
	var arr=ret.split("^");
	var WordApp = new ActiveXObject("Word.Application");

	var wdCharacter = 1

	var wdOrientLandscape = 1

	WordApp.Application.Visible = true;

	var myDoc = WordApp.Documents.Add();

	// WordApp.ActiveDocument.PageSetup.Orientation = wdOrientLandscape

	WordApp.Selection.ParagraphFormat.Alignment = 1 // 1居中对齐,0为居右

	WordApp.Selection.Font.Bold = true

	WordApp.Selection.Font.Size = 20

	WordApp.Selection.TypeText("护理质控检查问题汇总");

	//WordApp.Selection.MoveRight(wdCharacter); // 光标右移字符
	var grid = Ext.getCmp("mygrid");

	var store = grid.getStore(); 
	var recordCount = arr.length; 
	//alert(CheckRoomId);
	//var view = grid.getView(); 
	
 /*	var myTable = myDoc.Tables.Add(WordApp.Selection.Range, recordCount+1, 1) // 8行7列的表格

	// myTable.Style="网格型"

	var aa = "我的列标题"

	var TableRange; // 以下为给表格中的单元格赋值

	for (i = 0; i < 1; i++)
	{

		with (myTable.Cell(1, i + 1).Range)
		{
 			font.Size = 12;

			InsertAfter(aa);

			ColumnWidth = 4

		}

	}
	//WordApp.Selection.ParagraphFormat.Alignment =2; 
	for (i = 0; i < (recordCount+1); i++)
	{
		WordApp.Selection.ParagraphFormat.Alignment =2; 	
		with (myTable.Cell(i+2, 1).Range)
		{
  		font.Size = 12;
  		
			InsertAfter(arr[i]);
			ColumnWidth = 4

		}
		/*		
		 * with (myTable.Cell(i+2, 2).Range)
		{
  			font.Size = 12;
			InsertAfter(view.getCell(i ,1).innerText);
			ColumnWidth = 4

		}
	 with (myTable.Cell(i+2, 3).Range)
		{
  		font.Size = 12;
			InsertAfter(view.getCell(i ,4).innerText);
			ColumnWidth = 4
		}
		 * */
//debugger
		var j=0;
    for (var i=0;i<recordCount;i++)
    {
    	var array=['一、','二、','三、','四、','五、','六、','七、','八、','九、','十、','十一、','十二、','十三','十四、','十五、','十六、','十七、','十八、','十九、','二十、'];
    	if (arr[i]=="") continue;
    	var itm=arr[i].split("|");
    	WordApp.Selection.TypeParagraph() ;// 插入段落

	      WordApp.Selection.Font.Size = 12;
	      if (itm.length>1)
	      {
	       WordApp.Selection.Font.Bold = false;
	
	       arr[i]=itm[0]+":"+itm[1];
	      }else{
	      	WordApp.Selection.Font.Size = 12;
	        WordApp.Selection.Font.Bold = true;
	        arr[i]=array[j]+arr[i];
	        j=j+1
	        
	      }
	      //alert(arr[i]);
	      WordApp.Selection.TypeText(arr[i]); // 分行插入日期
	      WordApp.Selection.ParagraphFormat.Alignment = 0;

    }
	myDoc.Protect(1)
	myDoc.save();  
	//WordDoc.Close();
  //关闭WordApp组件对象
  WordApp.Quit();
}