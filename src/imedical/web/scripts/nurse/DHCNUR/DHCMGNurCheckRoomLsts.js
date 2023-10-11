var Width = document.body.clientWidth-5;
var Height = document.body.clientHeight-3;
var stdate=new Ext.form.DateField({
	id:'stdate',
	format:'Y-m-d',
	tabIndex:'0',
	height:20,
	width:119,
	xtype:'datefield',
	value:new Date()
});
var eddate=new Ext.form.DateField({
	id:'enddate',
	format:'Y-m-d',
	tabIndex:'0',
	height:21,
	width:116,
	xtype:'datefield',
	value:new Date()
});
var wardLoc = new Ext.form.ComboBox({
	id:'wardloc',
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
			className:'web.DHCMgNurSysComm',
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
	pageSize:20,
	typeAhead:true,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
var QualScore=0;
var secGrpFlag=toMgSecGrp(session['LOGON.GROUPID']);
function BodyLoadHandler()
{
	var mygridpl = Ext.getCmp('mygridpl');
	mygridpl.setHeight(Height);
	mygridpl.setWidth(Width);
	var grid = Ext.getCmp('mygrid');
	var mydate = new Date();
	var tobar = grid.getTopToolbar();
	tobar.hide();
	var loctyp=Ext.getCmp("LocTyp");
	var SortPos=Ext.getCmp("SortPos");
	var gform=Ext.getCmp("gform");
  grid.setTitle("查房");
  var flag = tkMakeServerCall('web.DHCMgNurQcRestruct','getRecFlag',CheckRoomId);
  tbar2=new Ext.Toolbar({});	
	tbar2.addButton({
		text: "新建",
		handler:function(){NewCheck(flag);},
		id:'btnnew',
		icon:'../Image/light/useradd.png'
	});
  tbar2.addItem("-");
  tbar2.addButton({
		text: "编辑",
		handler:function(){ModCheck();},
		id:'btnmod',
		icon:'../image/light/useredit.png'
  }); 
  tbar2.addItem("-");
  tbar2.addButton({
		text: "删除",
		handler:function(){DelCheck();},
		id:'btndelete',
		icon:'../Image/light/delete.gif'
  });
  tbar2.addItem("-");
  tbar2.addButton({ 
		text: "Excel",
		handler:function(){exportFn();},
		id:'btnexport',
		icon:'../Image/icons/application_put.png'
  });
  tbar2.addItem("-");
  tbar2.addButton({
		text:"快速输入(满分病区)",
		handler:function(){QuickCheckIn();},
		id:'btnquickin',
		hidden:true
  });		  
  tbar2.addItem("-");
  tbar2.addButton({
		text: "查询",
		handler:function(){SchQual();},
		id:'btnSch',
		icon:'../image/light/search.png'
  });
  grid.getBottomToolbar().hide();
  var bbar2 = new Ext.PagingToolbar({
		pageSize:30,
		store:grid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
  tbar2.render(grid.tbar);
  bbar2.render(grid.bbar);
  wardLoc.store.on('beforeload',function(){
		wardLoc.store.baseParams.HsDr=1;
   	wardLoc.store.baseParams.typ="Ward";  
  });
  var dateFlag = tkMakeServerCall('DHCMGNUR.QuCheckWard','getRecDate',CheckRoomId);
  grid.store.on('beforeload',function(){
		var stdate=dateFlag;
 	 	var eddate=dateFlag;
	 	var chktyp=CheckTyp;
	 	var ward="";
	  if (chktyp=="") return;
	  //var mygrid = Ext.getCmp("mygrid");
    grid.store.baseParams.parr=stdate+"^"+eddate+"^"+chktyp+"^"+CheckRoomId+"^"+ward;
  });
  
  QualScore=tkMakeServerCall('web.DHCMgNurQcRestruct','getQualScore',CheckRoomId,flag);
  var len=grid.getColumnModel().getColumnCount()
	for(var i=0;i<len;i++){
		if(grid.getColumnModel().getDataIndex(i)=="QualDesc"){
			grid.getColumnModel().setHidden(i,true);
		}
		if(grid.getColumnModel().getDataIndex(i)=="PatName"){
			grid.getColumnModel().setHidden(i,true);
		}
		if(grid.getColumnModel().getDataIndex(i)=="rw"){
			grid.getColumnModel().setHidden(i,true);
		}
	}
	schModelData(grid,30);
}
function exportFn() 
{ 
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
	xls.ActiveWindow.Zoom = 75 
	xls.UserControl = true;  //很重要,不能省略,不然会出问题 意思是excel交由用户控制 
    xls=null; 
    xlBook=null; 
    xlSheet=null; 
}
function DelCheck()
{
	var grid = Ext.getCmp('mygrid');
	var rowObj = grid.getSelectionModel().getSelections();
	if(rowObj.length==0){
		Ext.Msg.alert('提示','请选择要删除的记录！');
		return;
	}
	var rw = rowObj[0].get('rw');
	if(confirm("删除后不可以恢复,确定删除选中的记录?")){
		tkMakeServerCall('Nur.CheckRoom','delQual',rw);
	    SchQual();
	}
}
function SchQual()
{
	var grid = Ext.getCmp('mygrid');
	schModelData(grid,30);
}
function NewCheck(flag)
{
	Check("",flag);
  CheckValue = new Hashtable();
  CheckReason = new Hashtable();
  CheckPeople = new Hashtable();
  setItmScore();
}
function ModCheck(flag)
{
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		alert("请选择一条记录！");
		return;
	}
	var Par=rowObj[0].get("rw");
	Check(Par,flag);
}
function setItmScore()
{
	Ext.getCmp("CheckScore1").setValue(QualScore);
  Ext.getCmp("HundredScore").setValue("100");
}
function Check(Par,flag)
{
	var DHCNurNightRoundScoreT110=new Ext.data.Store({proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',fields:[{'name':'ItemCode','mapping':'ItemCode'},{'name':'ItemDesc','mapping':'ItemDesc'},{'name':'ItemValue','mapping':'ItemValue'},{'name':'ItemDedStand','mapping':'ItemDedStand'},{'name':'CheckScore','mapping':'CheckScore'},{'name':'CheckMem','mapping':'CheckMem'},{'name':'CheckPeople','mapping':'CheckPeople'},{'name':'rw','mapping':'rw'},{'name':'Par','mapping':'Par'},{'name':'MinLevel','mapping':'MinLevel'},{'name':'ItemLevel','mapping':'ItemLevel'},{'name':'QualPar','mapping':'QualPar'},{'name':'QualRw','mapping':'QualRw'}]}),baseParams:{className:'web.DHCMgNurQcRestruct',methodName:'GetModelItemSub',type:'RecQuery'}});

	var arr = new Array();
	var a = cspRunServerMethod(pdata1,"","DHCNurNightRoundScore","","");
	arr = eval(a);
	window1 = new Ext.Window({
		title:'查房',
		id:"gform2",
		x:10,y:2,
		width:820,
		height:600,
		autoScroll:false,
		layout:'absolute',
		modal: true,
		items:arr
	});
	window1.show();
	var grid = Ext.getCmp('mygrid1');
	grid.getTopToolbar().hide();
	grid.getBottomToolbar().hide();
	var gridpl = Ext.getCmp('mygridpl');
	grid.setWidth(window1.getWidth()-10);
	grid.setHeight(window1.getHeight()-100);
	
	Ext.getCmp("CheckDate").setValue(new Date());
	grid.store.on('beforeload',function(){
		grid.store.baseParams.parr = CheckRoomId + "^" + Par + "^" +CheckTyp;
		grid.store.baseParams.checkflag = flag;
	});
	var checkWardCom = Ext.getCmp('CheckWard'); 
	checkWardCom.store.on("beforeload",function(){
   	checkWardCom.store.baseParams.Par=CheckRoomId;
  	checkWardCom.store.baseParams.typ="Ward"; 
  });
  checkWardCom.on('select',function(){
  	var ret = tkMakeServerCall('web.DHCNurseManageComm','GetTimeNurse',new Date().format('Y-m-d')+"^"+new Date().format("H:i")+"^"+checkWardCom.getValue());
  	Ext.getCmp('CheckNur').setValue(ret);
  	var bedPat = tkMakeServerCall('web.DHCNurseManageComm','getCurrPatOnBedNew',this.getValue());
  	Ext.getCmp('BedPat').setValue(bedPat);
  	var patCount = tkMakeServerCall('web.DHCNurseManageComm','getOrderPat',this.getValue(),"病危",new Date().format('Y-m-d'));
  	Ext.getCmp('BWPat').setValue(patCount);
  	var opatCount = tkMakeServerCall('web.DHCNurseManageComm','getOrderPat',this.getValue(),"手术申请：",new Date().format('Y-m-d'));
  	Ext.getCmp('OpPat').setValue(opatCount);
  	setItmScore();
  });
  checkWardCom.on('select',function(){
  	schModelData(grid,1000);
  });
  var len=grid.getColumnModel().getColumnCount()
	for(var i=0;i<len;i++){
		if(grid.getColumnModel().getDataIndex(i)=="ItemDedStand"){
			grid.getColumnModel().setHidden(i,true);
		}
		if(grid.getColumnModel().getDataIndex(i)=="CheckPeople"){
			grid.getColumnModel().setHidden(i,true);
		}
		if(grid.getColumnModel().getDataIndex(i)=="ItemLevel"){
			grid.getColumnModel().setHidden(i,true);
		}
		if(grid.getColumnModel().getDataIndex(i)=="MinLevel"){
			grid.getColumnModel().setHidden(i,true);
		}
		if(grid.getColumnModel().getDataIndex(i)=="rw"){
			grid.getColumnModel().setHidden(i,true);
		}
		if(grid.getColumnModel().getDataIndex(i)=="Par"){
			grid.getColumnModel().setHidden(i,true);
		}
	}
	sm1.handleMouseDown = Ext.emptyFn;
	var hd_checker = Ext.getCmp('mygrid1').getEl().select('div.x-grid3-hd-checker');
	hd_checker.removeClass('x-grid3-hd-checker'); // 去掉全选框
	sm1.on('rowselect',function( _sm1,rowIndex,record){
		var CheckWard = Ext.getCmp('CheckWard').getValue();
		if (!CheckWard) {
			Ext.Msg.alert('提示',"请先选择检查病区");
			return;
		}
		var rowFlag = record.get("MinLevel");
		if(rowFlag=="N"){
			return;
		}	
		record.set('CheckMem',record.get('ItemDesc'));
		record.set('CheckScore',record.get('ItemValue'));
		SetScore();
	},this);
	sm1.on('rowdeselect',function(_sm1,rowIndex,record){
		record.set('CheckMem','');
		record.set('CheckScore','');
		SetScore();
	},this);
	var btSure = Ext.getCmp('btnSure');
	btSure.setIcon('../images/uiimages/filesave.png');
	btSure.on('click',function(){SureCheck(Par);});
	if(Par!=""){
		var resultSet = tkMakeServerCall('Nur.CheckRoom','getRowResult',Par);
		var ha = new Hashtable();
		var tm=resultSet.split('^');
		sethashvalue(ha,tm);
		window1.items.each(function(item,index,length){
			if(item.getXType()=="combo"){
				if(item.mode=="local"){
					if(ha.items(item.getId())!=""){
						if(item.getId()&&(Ext.getCmp(item.getId()))){
							Ext.getCmp(item.getId()).setValue(ha.items(item.getId()));
						}
					}
					item.triggerAction='all';
				}else{
					Ext.getCmp(item.getId()).store.load({params:{start:0,limit:500},callback:function(){
			 			if(ha.items(item.getId())!=""){
			 				if(item.getId()&&(Ext.getCmp(item.getId()))){
			 					Ext.getCmp(item.getId()).typeAhead=false;
			 					Ext.getCmp(item.getId()).setValue(ha.items(item.getId()));
			 					if(item.getId()=="CheckWard"){Ext.getCmp(item.getId()).disable();}
			 				}
			 			}
			 		}})
				}
				item.typeAhead='false';
			}
			if(item.getXType()=="datefield"){
			 	if(ha.items(item.getId())){
					if(item.getId()&&(Ext.getCmp(item.getId()))){
						Ext.getCmp(item.getId()).setValue(ha.items(item.getId()));	
					}
				}
			}
			if(item.getXType()=="textfield"){
				if(ha.items(item.getId())){
					if(item.getId()&&(Ext.getCmp(item.getId()))){
						Ext.getCmp(item.getId()).setValue(ha.items(item.getId()));
					}
				}
			}
		})
	}
	setTimeout(function(){
		grid.store.load({params:{start:0,limit:500},callback:function(){
			var n = grid.getStore().getCount();
			var arrsel = new Array();
			for (var j = 0; j < n; j++) {
				var CheckScore = grid.store.getAt(j).get("CheckScore");
				if (CheckScore != "") {
					arrsel[j] = j;
				}
				if (grid.store.getAt(j).get("MinLevel")=="N"){
					grid.getView().getRow(j).style.backgroundColor='#855E42';
				}
			}
			grid.getSelectionModel().selectRows(arrsel, true);	
		}})
	},1000);
	
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
	var checkNur = Ext.getCmp('CheckNur').getValue(); //值班护士
	var bedPat = Ext.getCmp('BedPat').getValue(); //在床人数
	var bWPat = Ext.getCmp('BWPat').getValue(); //病危人数
	var opPat = Ext.getCmp('OpPat').getValue(); //手术人数
	var PatSum = bedPat + "!" + bWPat + "!" + opPat;
	var ReMark1=Ext.getCmp("ReMark").getValue();
	var checkScore = Ext.getCmp('CheckScore1').getValue();
	if(!checkScore){
		Ext.Msg.alert('提示','评分不能为空！');
		return;
	}
	var hundredScore = Ext.getCmp('HundredScore').getValue();
	var checkPar = tkMakeServerCall('Nur.CheckRoom','SaveQual',checkDate,session['LOGON.USERID'],CheckTyp,CheckRoomId,checkWard,checkScore,'','',Par,checkNur,PatSum,ReMark1);
	if(checkPar=="room"){
		alert("该病区已评分,请重新选择病区!");
		return;
	}
	if(checkPar!=""){
		tkMakeServerCall('Nur.CheckRoom','clearRecData',checkPar);
		var grid = Ext.getCmp('mygrid1');
		for (var i = 0; i < grid.store.getCount(); i++){
			var CheckCode = grid.store.getAt(i).get('ItemCode');
			var CheckDesc = grid.store.getAt(i).get('ItemDesc');
			var CheckValue = grid.store.getAt(i).get('ItemValue');
			var CheckMem = grid.store.getAt(i).get('CheckMem');
			var CheckScore = grid.store.getAt(i).get('CheckScore');
			var QualPar = grid.store.getAt(i).get('QualPar');
			var QualRw = grid.store.getAt(i).get('QualRw');
			tkMakeServerCall('Nur.CheckRoom','SaveSubQualItms',checkPar,CheckCode,CheckDesc,CheckValue,CheckMem,CheckScore,QualPar,QualRw);
		}
		Ext.Msg.alert('提示','保存成功！');
		SchQual();
		//tkMakeServerCall('Nur.CheckRoom','SaveQualItem',)
	}
}
 // 计算得分
function SetScore()
{
	var Score = QualScore;
	var grid = Ext.getCmp('mygrid1');
	for (var i = 0; i < grid.store.getCount(); i++){
		//if(i==0) debugger
		var score = grid.store.getAt(i).get('CheckScore');
		if(!score){continue;}
		Score = Score - parseFloat(score).toFixed(2);
	}
	if (Score != NaN) {
		Ext.getCmp("CheckScore1").setValue(Score);
	}
	var HScore = (Score*100)/QualScore;
  Ext.getCmp("HundredScore").setValue(HScore.toFixed(1));
}
function schModelData(grid,pageSize)
{
	grid.store.load({
		params:{
			start:0,
			limit:pageSize
		},callback:function(){
			var mygrid = Ext.getCmp('mygrid1');
			if(grid == mygrid){
				var n = grid.store.getCount();
				var arrsel = new Array();
				for (var j = 0; j < n; j++) {
					var CheckScore = grid.store.getAt(j).get("CheckScore");
					if (CheckScore != "") {
						arrsel[j] = j;
					}
					if (grid.store.getAt(j).get("MinLevel")=="N"){
						grid.getView().getRow(j).style.backgroundColor='#855E42';
					}
				}
				grid.getSelectionModel().selectRows(arrsel, true);
			}
	}});
}