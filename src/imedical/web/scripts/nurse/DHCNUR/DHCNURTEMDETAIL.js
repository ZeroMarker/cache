/**
 * @author Administrator
 */
var UserType="";
var GetUserType=document.getElementById('GetUserType');
if (GetUserType){
	UserType=cspRunServerMethod(GetUserType.value,session['LOGON.USERID']);
}

var grid;
function gethead()
{
	var GetHead=document.getElementById('GetHead');
	var ret=cspRunServerMethod(GetHead.value,EpisodeID);
	var hh=ret.split("^");
	return hh[0];
	//debugger;
}
var datePeriod="";
function BodyLoadHandler(){
	setsize("mygridpl","gform","mygrid");
	//fm.doLayout(); 
	grid1=Ext.getCmp("mygrid");
	var but1=Ext.getCmp("mygridbut1");
	but1.hide();
	var but=Ext.getCmp("mygridbut2");
	but.setText("保存");
	but.setIcon('../images/uiimages/filesave.png')
	but.on('click',save);
	Ext.override(Ext.Editor, {
		onSpecialKey : function(field, e) {
			var key = e.getKey();
			this.fireEvent('specialkey', field, e);
		}
	});
	Ext.override(Ext.grid.RowSelectionModel, {
		onEditorKey : function(F, E) {
			var C = E.getKey(), G, D = this.grid, B = D.activeEditor;
			var A = E.shiftKey;
			if (C == E.TAB) {
				E.stopEvent();
				B.completeEdit();
				if (A) {
					G = D.walkCells(B.row, B.col - 1, -1, this.acceptsNav,
							this);
				} else {
					G = D.walkCells(B.row, B.col + 1, 1, this.acceptsNav,
							this);
				}
			} else {
				if (C == E.ENTER) {
					E.stopEvent();
					// alert(B);
					B.completeEdit();
					if (this.moveEditorOnEnter !== false) {
						if (A) {
							// G = D.walkCells(B.row - 1, B.col, -1,
							// this.acceptsNav,this)
							G = D.walkCells(B.row, B.col - 1, -1,
									this.acceptsNav, this);
						} else {
							// G = D.walkCells(B.row + 1, B.col, 1,
							// this.acceptsNav,this)
							G = D.walkCells(B.row, B.col + 1, 1,
									this.acceptsNav, this);
						}
					}
				} else {
					if (C == E.ESC) {
						B.cancelEdit();
					}
				}
			}
			if (G) {
				D.startEditing(G[0], G[1]);
			}
		}
	});
    var sm2 = new Ext.grid.RowSelectionModel({   
        moveEditorOnEnter: true,   
        singleSelect: false,   
        listeners: {   
            //rowselect : function(sm, row, rec) {   
                //centerForm.getForm().loadRecord(rec);   
           // }   
        }   
  
    });
	
	grid=Ext.getCmp('mygrid');
	grid.getBottomToolbar().hide();
	grid.setTitle(gethead());
	var mydate=new Date();
	var tobar=grid.getTopToolbar();
	tobar.addItem('-');
	tobar.addItem({
		xtype:'datefield',
		//format: 'Y-m-d',
		id:'mygridstartdate',
		value:(diffDate(new Date(),-3)),
		listeners:{
			'select':selcetDateHandler
		}
		}, {
		xtype:'datefield',
		//format: 'Y-m-d',
		id:'mygridenddate',
		value:(diffDate(new Date(),0)),
		listeners:{
			'select':selcetDateHandler
		}
	});
	tobar.addItem('-');
	tobar.addButton(
	{
		className: 'new-topic-button',
		text: "查询",
		icon:'../images/uiimages/search.png',
		handler:find,
		id:'mygridSch'
	});
	tobar.addItem('-');
	tobar.addButton({
		className: 'new-topic-button',
		text: "体温未录",
		handler: findBlankTemp,
		icon:'../images/uiimages/search.png',
		id: 'mygridSchBlank'
	});
	tobar.addItem('-');
	//tobar.render(grid.tbar);
	tobar.doLayout(); 
 	if (UserType=="DOCTOR")
 	{
 		if (but1) but1.hide();
 		if (but) but.hide();
 	}
	Ext.QuickTips.init();//注意，提示初始化必须要有
	
	var startDay = tkMakeServerCall("Nur.Utility","getAdmDate",EpisodeID);
	var startDayObj = Ext.getCmp('mygridstartdate');
	if(startDay!=""){
		startDayObj.setMinValue(startDay);
		startDayObj.setMinValue(startDay);
	}	
	var endDay = tkMakeServerCall("Nur.Utility","getDisDate",EpisodeID);
	var endDayObj = Ext.getCmp('mygridenddate');
	if(endDay!=""){
		endDayObj.setValue(endDay);
		startDayObj.setValue(startDay);  //diffDate(new Date(endDay),-3)
		endDayObj.setMaxValue(endDay);
		endDayObj.setMaxValue(endDay);
	}	
	var wardId = session['LOGON.WARDID'];
	var ret = tkMakeServerCall("web.DHCThreeNew","getCurrLocPeriod",EpisodeID,wardId);
	datePeriod = eval(ret);
	find();
}


////grid可编辑列处理  songchao  2017-8-11
function gridPreHandle(grid,hideAll){
	var len = grid.getColumnModel().getColumnCount();
	for(var i = 0 ;i < len;i++){
		var dataIndex = grid.getColumnModel().getDataIndex(i);
		switch(dataIndex)
		{
			case 'RecDate':
				grid.getColumnModel().setHidden(i,false);
			  break;
			case 'RecTime':
				grid.getColumnModel().setHidden(i,false);
			  break;
			case 'Item1':
				grid.getColumnModel().setHidden(i,false);
			  break;
			default:
				grid.getColumnModel().setHidden(i,(hideAll&&true));
				break;
		}
	}
}
function selcetDateHandler(){	
	var periodStr=""
	if(datePeriod!=""){
		var flag = true;
		for(i=0;i<datePeriod.length;i++){
			var period = datePeriod[i];
		    if (period=="") break;
			var pStart = new Date(changeDateFormat(period.StartDate));//.replace(/\-/g, "\/")
			var pEnd = new Date(changeDateFormat(period.EndDate));//.replace(/\-/g, "\/")
			if((this.getValue()>=pStart)&&(this.getValue()<=pEnd)){
				flag=false;
				break;
			}else{
				periodStr+=period.StartDate+"~"+period.EndDate+"	";
			}
		}	
		if(flag){
			alert("您选择的日期病人不在本科室,无法修改数据!"+periodStr);
			this.setValue("");
			return;
		}
	}
}
var searchFlag=0;
var REC=new Array();
function find(){
	grid=Ext.getCmp("mygrid");
	gridPreHandle(grid,false);
	REC = new Array();
	var adm = EpisodeID;
	var StartDate = formatDate(Ext.getCmp("mygridstartdate").getValue());
	var EndDate = formatDate(Ext.getCmp("mygridenddate").getValue());
	var GetQueryData = document.getElementById('GetQueryData');
	var mygrid = Ext.getCmp("mygrid");
	var parr =adm+"^"+StartDate+"^"+EndDate;
	if ((StartDate=="")||(EndDate=="")) return;
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCThreeNew:GetPatTempData", "Parr$" + parr, "AddRec");
	mygrid.store.loadData(REC);
	searchFlag=0;
}
function findBlankTemp() {
	grid=Ext.getCmp("mygrid");
	gridPreHandle(grid,true);
	REC = new Array();
	var adm = EpisodeID;
	StartDateObj = Ext.getCmp("mygridstartdate");
	EndDateObj = Ext.getCmp("mygridenddate");
	var sdFlag = compareDate(StartDateObj);
	if (sdFlag) {
		var edFlag = compareDate(EndDateObj);
		if (edFlag) {
			var StartDate = formatDate(Ext.getCmp("mygridstartdate").getValue());
			var EndDate = formatDate(Ext.getCmp("mygridenddate").getValue());
			var GetQueryData = document.getElementById('GetQueryData');
			var mygrid = Ext.getCmp("mygrid");
			var parr = adm + "^" + StartDate + "^" + EndDate;
			if ((StartDate == "") || (EndDate == ""))
				return;
			//var a= tkMakeServerCall("web.DHCThreeNew","GetPatTempDataBlank","Parr$" + parr, "AddRec");
			var a = cspRunServerMethod(GetQueryData.value, "web.DHCThreeNew:GetPatTempDataBlank", "Parr$" + parr, "AddRec");
			mygrid.store.loadData(REC);
			searchFlag = 1;
		}
	}
}
function compareDate(datePickerObj){
	var periodStr=""
	if(datePeriod!=""){
		var flag = true;
		for(i=0;i<datePeriod.length;i++){
			var period = datePeriod[i];
		    if (period=="") break;
			var pStart = new Date(changeDateFormat(period.StartDate));
			var pEnd = new Date(changeDateFormat(period.EndDate)); //.replace(/\-/g, "\/")
			if((datePickerObj.getValue()>=pStart)&&(datePickerObj.getValue()<=pEnd)){
				flag=false;
				break;
			}else{
				periodStr+=period.StartDate+"~"+period.EndDate;
			}
		}	
		if(flag){
			alert("您选择的日期病人不在本科室,无法修改数据!"+periodStr);
			this.setValue("");
			return false;
		}
	}
	return true;
}
/**
*将日期格式化为YYYY/MM/DD格式
**/
function changeDateFormat(date){
	var ret="";
	if(date.indexOf('-')>0){
		ret = date.replace(/\-/g, "\/")
		return ret;
	}else {
		var dateStrs = date.split('/');
		if(dateStrs[2]>1000){
			ret = dateStrs[2]+'/'+dateStrs[1]+'/'+dateStrs[0];
			return ret;
		}
	}
	return ret;
}
function AddRec(str)
{
	//var a=new Object(eval(str));
	var obj = eval('(' + str + ')');
	//obj.PregHPregDate=getDate(obj.PregHPregDate);
	REC.push(obj);
	//debugger;
}
function save()
{
	var store = grid.store;
	var rowCount = store.getCount(); //记录数
	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount();
	var list = [];
	var rowObj = store.getModifiedRecords(); //获取所有更新过的记录grid.getSelectionModel().getSelections();
		var len = rowObj.length;
		for (var r = 0;r < len; r++) {
		list.push(rowObj[r].data);
    }
	var RecSave=document.getElementById('RecSave');
	for (var i = 0; i < list.length; i++) {
		var obj=list[i];
		var str="";
		var StDate="";
		var StTime="";
		var flag="0";
		for (var p in obj) {
			var aa = formatDate(obj[p]);	
			//alert(aa);
			if (p=='RecDate') StDate=obj[p];
			if (p=='RecTime') StTime=obj[p];
			if (p=="") continue;
			if(obj[p].indexOf("\\")>-1)
				{
					alert("不能输入'\\'");
					return;
				}
				if(obj[p].indexOf("'")>-1||obj[p].indexOf('"')>-1)
				{
					alert("不能输入引号");
					return;
				}
				if(obj[p].indexOf("[")>-1||obj[p].indexOf(']')>-1)
				{
					alert("不能输入 [ 或 ]");
					return;
				}
				if(obj[p].indexOf("{")>-1||obj[p].indexOf('}')>-1)
				{
					alert("不能输入 { 或 }");
					return;
				}
				if (p=='Item1'||(p=='Item22')) {
					if (isNaN(obj[p])){
						if ((obj[p]!="")&&(obj[p].split(".").length>2)) {
							alert("体温或物理隆温输入格式不对,包括多个点!");
							return;		
						}
						else {
							alert("体温或物理隆温值请录入数字!");
							return;
						}
					}
					else {
						if ((obj[p]!="")&&((obj[p] < 34)||(obj[p] > 43))) {
							alert("体温或物理隆温值小于34或大于43!");
							return;
						}
					}
				}
			if (p=='Item7') {
				if (isNaN(obj[p])){
					alert("脉搏值请录入数字!");
					return;
				}
				else {
					if ((obj[p]!="")&&((obj[p] < 20)||(obj[p] > 200))) {
						alert("脉搏值小于20或大于200!");
						return;
					}
				}
			}
			
			if ((p == 'Item60') || (p == 'Item61')) {
				if (isNaN(obj[p])) {
					if ((obj[p] != "") && (obj[p].split(".").length > 2)) {
						alert("疼痛或止痛输入格式不对,包括多个点!");
						return;
					} else {
						alert("疼痛或止痛值请录入数字!");
						return;
					}
				} else {
					if ((obj[p] != "") && ((obj[p] < 0) || (obj[p] > 10))) {
						alert("疼痛或止痛值请录入0到10之间的数值!");
						return;
					}
				}
			}
			if (p == 'Item17')  {			
				var reasons = ['拒测','请假','外出'];
				if ((obj[p] != "") && (reasons.indexOf(obj[p])< 0)) {
						alert("请选择下拉框中的未测原因!");
						return;
				}
			}
			if (p == 'Item62')  {			
				var reasons = ['入睡','拒测','请假','外出'];
				if ((obj[p] != "") && (reasons.indexOf(obj[p])< 0)) {
						alert("请选择下拉框中的疼痛未测原因!");
						return;
				}
			}
			
			if (aa == "") 
			{
				str = str + p + "|" + DBC2SBC(obj[p]) + '^';
			}else
			{
			  	str = str + p + "|" + aa + '^';	
			}
		}
		if ((str!="")&&(flag=="0"))
		{
		   	//alert(EpisodeID);
		  	//alert(str);
			var a=cspRunServerMethod(RecSave.value,EpisodeID,str,session['LOGON.USERID'],"DHCNUR6",session['LOGON.GROUPDESC'],StDate,StTime);
			if (a!="0")
			{
				alert(a);
				return;
			}
		}
	}
	alert("保存成功");
	if(searchFlag==0){
		find();
	}else{
		findBlankTemp();
	}
	
}
function gettime()
{
	var a=Ext.util.Format.dateRenderer('h:m');
	return a;
}
function diffDate(val,addday){
	var year=val.getFullYear();
	var mon=val.getMonth();
	var dat=val.getDate()+addday;
	var datt=new Date(year,mon,dat);
	return formatDate(datt);
}
function getDate(val)
{
	var a=val.split('-');
	var dt=new Date(a[0],a[1]-1,a[2]);
	return dt;
}
function formatDate(value){
  	try
	{
	   return value ? value.dateFormat('Y-m-d') : '';
	}
	catch(err)
	{
	   return '';
	}
 };
function DBC2SBC(str)   
{
	var result = '';
	if ((str)&&(str.length)) {
		for (var i = 0; i < str.length; i++) {
			var code = str.charCodeAt(i);
			if (code >= 65281 && code <= 65373) {
				result += String.fromCharCode(str.charCodeAt(i) - 65248);
			}
			else {
				if (code == 12288) {
					result += String.fromCharCode(str.charCodeAt(i) - 12288 + 32);
				}
				else {
					result += str.charAt(i);
				}
			}
		}
	}
	else{
		result=str;
	}  
	return result;   
}
