// /名称: 生成月报
// /描述: 生成月报
// /编写者：zhangdongmei
// /编写日期: 2012.11.15

Ext.onReady(function() {
	var gUserId = session['LOGON.USERID'];	
	var gLocId=session['LOGON.CTLOCID'];
	//alert(gIngrRowid);
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var Url=DictUrl+ 'stkmonaction.csp?';
	var today=new Date();
	Ext.Ajax.timeout = 900000;
		//wyx add参数配置 2014-03-06
	if(gParam.length<1){
		GetParam();  //初始化参数配置
		
	}
	// 删除按钮
	var DeleteBT = new Ext.Toolbar.Button({
				id : "DeleteBT",
				text : '删除',
				tooltip : '点击删除',
				width : 70,
				height : 30,
				iconCls : 'page_delete',
				handler : function() {  
					Delete();
				}
			});
			
		// 查询按钮
	var SearchBT = new Ext.Toolbar.Button({
				id : "SearchBT",
				text : '查询',
				tooltip : '点击查询',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {  
					QueryRep();
				}
			});
			
	// 确定按钮
	var OkBT = new Ext.Toolbar.Button({
				id : "OkBT",
				text : '生成月报',
				tooltip : '点击生成月报',
				width : 70,
				height : 30,
				iconCls : 'page_gear',
				handler : function() {  
					CreateReport();
				}
			});
	
	/**
	 * 生成月报
	 */
	function CreateReport() {
		if(DetailGrid.activeEditor != null){
			DetailGrid.activeEditor.completeEdit();
		} 
		var selections=DetailGrid.getSelectionModel().getSelections();
		var CreateUser = gUserId;
		var ReCreate=false;     //是否重新生成月报
		
		var listParams="";
		for(var i=0;i<selections.length;i++){
			var record=selections[i];
			var Loc=record.get("LocId");
			var LocDesc=record.get("LocDesc");
			if(Loc==null||Loc==""){
				return;
			}
			var Month=record.get("CurMonth")
			if(Month==""){
				Msg.info("warning",LocDesc+"本期月份不能为空!");
				return;
			}
			var CurMonth=record.get("CurMonth")+"-"+"01";
			var StartDateVal = record.get("CurStartDate");
			var StartDate=StartDateVal.format(App_StkDateFormat);
			var StartDateChk=StartDateVal.format("Y-m-d");
			var StartTime =record.get("CurStartTime");
			var EndDateVal = record.get("CurEndDate");
			var EndDate=EndDateVal.format(App_StkDateFormat);
			var EndDateChk=EndDateVal.format("Y-m-d");
			var EndTime = record.get("CurEndTime");
			if((StartDateChk>EndDateChk)||(StartDateChk==EndDateChk && StartTime>=EndTime)){
				Msg.info("warning",LocDesc+"截止时间要晚于开始时间!");
				return;
			}
			if(EndDateChk>today.format('Y-m-d')){
				Msg.info("error",LocDesc+"本期截止日期不能超过当天!");
				return;
			}else if(EndDateChk==today.format('Y-m-d')){
				if(EndTime>today.format('H:i:s')){
					Msg.info("error",LocDesc+"本期截止时间不能为晚于当前时间!");
					return;
				}
			}
			var Params=Loc+"^"+CurMonth+"^"+CreateUser+"^"+StartDate+"^"+EndDate+"^"+StartTime+"^"+EndTime;
			var ExistFlag=CheckIfExist(Loc,CurMonth);
		    
			if(ExistFlag==true){
				Msg.info("warning",LocDesc+'本月月报已经生成，如需重新生成的话请先删除后再生成!');
				return;
			}
			var CompleteStr=CheckIfCompleted(Loc,StartDate,EndDate);
			if((CompleteStr!="")&(gParam[0]=='Y')){
				Msg.info("warning",'"有未完成的业务单，不能生成月报！'+CompleteStr);
				return;
			}
			if(listParams==""){
				listParams=Params;
			}else{
				listParams=listParams+RowDelim+Params;
			}			
		}
		if(listParams==""){
			Msg.info("warning","请选择需要生成月报的科室!");
			return;
		}
		var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
		var pid=tkMakeServerCall("web.DHCST.DHCStkMon","JobSendCreateReports",listParams);
		var refInt=setInterval(function(){
	    	var jobRet=tkMakeServerCall("web.DHCST.Common.Job","GetJobResult",pid);
			if(jobRet!=""){
				clearInterval(refInt);
				loadMask.hide();
				var jobRetArr=jobRet.split("^");
				if (jobRetArr[0]==0){
					Msg.info("success",jobRetArr[1]);
					Query(); 
				}else{
					Msg.info("error", jobRetArr[1]);
				}
			}	
	    }, 5000);
	    return;
	    
		Ext.Ajax.request({
			url:Url+"actiontype=CreateReport",
			params:{Params:listParams},
			method:'POST',
			success:function(response,opts){
				var jsonData = Ext.util.JSON.decode(response.responseText);
				loadMask.hide();
				if (jsonData.success == 'true') {
					// 刷新界面
					Msg.info("success", "生成月报成功!");
					Query();  //月报都生成后执行查询
					//QueryRep();
				} else {
					var ret=jsonData.info;					
					Msg.info("error", "生成月报失败："+ret);		
				}			
			}
		})
	
	}

	//检测某科室某月份月报是否已经存在
function CheckIfExist(LocId,CurMon){
	var flag=false;
	var NewUrl=Url+"actiontype=CheckIfExist&LocId="+LocId+"&CurMonth="+CurMon;
	var responseText=ExecuteDBSynAccess(NewUrl);
	var jsonData=Ext.util.JSON.decode(responseText);
	if(jsonData.success=='true'){
		flag= true;
	}
	
	return flag;
}
 //检测某科室某月份月报是否有未完成的单据 //add wyx 2014-03-06 
function CheckIfCompleted(LocId,StartDate,EndDate){
	var flag=false;
	var NewUrl=Url+"actiontype=CheckIfCompleted&LocId="+LocId+"&StartDate="+StartDate+"&EndDate="+EndDate;
	var responseText=ExecuteDBSynAccess(NewUrl);
	var jsonData=Ext.util.JSON.decode(responseText);
	return jsonData.info;
	}

//查询
function Query(){
	var GroupId=session['LOGON.GROUPID'];
	DetailStore.load({params:{actiontype:'GrpLocForStkMon',GroupId:GroupId,start:0,limit:999}});
}

var selcol=new Ext.grid.CheckboxSelectionModel({checkOnly:true});
var nm = new Ext.grid.RowNumberer();
var DetailCm = new Ext.grid.ColumnModel([nm, selcol,{
			header : "rowid",
			dataIndex : 'Rowid',
			width : 100,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : '科室',
			dataIndex : 'LocDesc',
			width : 180,
			align : 'left',
			sortable : true
		}, {
			header : '上期月份',
			dataIndex : 'Month',
			width : 80,
			align : 'left',
			sortable : true,
			renderer:function(value, metaData, record, rowIndex, colIndex, store){
				if(value==null || value==""){
					return value;
				}
				var newValue=value.substring(0,7);
				return newValue;
			}
		}, {
			header : '上期起始日期',
			dataIndex : 'StartDate',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "上期起始时间",
			dataIndex : 'StartTime',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "上期截止日期",
			dataIndex : 'EndDate',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "上期截止时间",
			dataIndex : 'EndTime',
			width : 100,
			align : 'center',
			sortable : true
		},{
			header:'本期月份',
			dataIndex:'CurMonth',
			width:100,
			align:'center',
			sortable:false,
			renderer:function(value, metaData, record, rowIndex, colIndex, store){
				return '<span style="color:green;">' + value + '</span>';
			},
			editor:new Ext.form.TextField({
				regex:/(^\d{4})-((0?[1-9]|1[0-2])$)/,
                regexText: "请输入正确的本期月份，例如2018-05",
			})
		},{
			header:'本期开始日期',
			dataIndex:'CurStartDate',
			width:100,
			sortable:false,
			renderer:Ext.util.Format.dateRenderer(App_StkDateFormat),
			editor:new Ext.ux.DateField({
				allowBlank:false,
				format:App_StkDateFormat
			})
		},{
			header:'本期开始时间',
			dataIndex:'CurStartTime',
			width:100,
			sortable:false,
			editor:new Ext.form.TextField({
				regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
				regexText:'时间格式错误，正确格式hh:mm:ss',
				width : 120
			})
		},{
			header:'本期截止日期',
			dataIndex:'CurEndDate',
			width:100,
			sortable:false,
			renderer:Ext.util.Format.dateRenderer(App_StkDateFormat),
			editor:new Ext.ux.DateField({
				allowBlank:false,
				format:App_StkDateFormat
			})
		},{
			header:'本期截止时间',
			dataIndex:'CurEndTime',
			width:100,
			sortable:false,
			editor:new Ext.form.TextField({
				regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
				regexText:'时间格式错误，正确格式hh:mm:ss',
				width : 120
			})
		}]);
//根据上期截止日期和时间计算本期开始日期
function curstartdate(value,rec){
	var curStartDate=today.add(Date.DAY,-30);
	if(rec!=null){
		if(rec.lastToDate!=null & rec.lastToDate!="" & rec.lastToTime!=null & rec.lastToTime!=""){
			//上期截止日期时间转换成Date类型后加1秒
			curStartDate=toDate(rec.lastToDate+" "+rec.lastToTime).add(Date.SECOND,1);
		}
	}
	return curStartDate;
}

function curstarttime(value,rec){
	var curStartTime="";
	if(rec!=null){
		if(rec.lastToDate!=null & rec.lastToDate!="" & rec.lastToTime!=null & rec.lastToTime!=""){
			//上期截止日期时间转换成Date类型后加1秒
			curStartTime=toDate(rec.lastToDate+" "+rec.lastToTime).add(Date.SECOND,1);
		}
	}
	if(curStartTime==""){
		return "00:00:00";
	}
	return curStartTime.format("H:i:s");
	
}

//lastStkMonRowid^lastMonth^lastFrDate^lastFrTime^lastToDate^lastToTime
var DetailStore=new Ext.data.JsonStore({
	autoDestroy: true,
    url: Url,
    storeId: 'DetailStore',
    root: 'rows',
    totalProperty : "results",
    idProperty: 'Rowid',  
    fields: [{name:'Rowid',mapping:'lastStkMonRowid'},{name:'LocId',mapping:'RowId'}, {name:'LocDesc',mapping:'Description'}, {name:'Month',mapping:'lastMonth'}, 
    	{name:'StartDate',mapping:'lastFrDate'},{name:'StartTime',mapping:'lastFrTime'},{name:'EndDate',mapping:'lastToDate'},{name:'EndTime',mapping:'lastToTime'},
    	{name:'CurMonth',defaultValue:today.getFullYear()+"-"+(today.getMonth()+1)},{name:'CurStartDate',type:'date',dateFormat:App_StkDateFormat,convert:curstartdate},
    	{name:'CurStartTime',defaultValue:"00:00:00",convert:curstarttime},
    	{name:'CurEndDate',type:'date',dateFormat:App_StkDateFormat,defaultValue:today.add(Date.DAY,-1).format(App_StkDateFormat)},{name:'CurEndTime',defaultValue:"23:59:59"}]
});

var DetailGrid = new Ext.grid.EditorGridPanel({
			id : 'DetailGrid',
			region : 'center',
			height:200,
			title : '月报生成',
			tbar : [OkBT],
			cm : DetailCm,
			store : DetailStore,
			trackMouseOver : true,
			stripeRows : true,
			loadMask : true,
			sm : selcol,   //new Ext.grid.CellSelectionModel()
			clicksToEdit:1
		});

DetailGrid.addListener('beforeedit',function(e){
	var field=this.getColumnModel().getDataIndex(e.column);
	if(field=="CurStartDate" || field=="CurStartTime"){
		if((e.record.get("Rowid")!="")&((e.record.get("Rowid")>0))){
			e.cancel=true;      //存在上期月报的话，本期开始日期和本期开始时间不能修改
		}
	}
});
DetailGrid.addListener('afteredit',function(e){
	this.getSelectionModel().selectRow(e.row,true);
});
	//Ext.getCmp('PhaLoc').select(gLocId);
	//SetStkMonStDate();
 //历史月报
//查询月报
function QueryRep(){
	var stYear=Ext.getCmp('StYear').getValue();
	var stMonth=Ext.getCmp('StMonth').getValue();
	var stDate=stYear+'-'+stMonth+'-'+'01';
	var edYear=Ext.getCmp('EdYear').getValue();
	var edMonth=Ext.getCmp('EdMonth').getValue();
	var edDate=edYear+'-'+edMonth+'-'+'01';
	var Loc=Ext.getCmp('PhaLoc').getValue();
	if(Loc==""){
		Msg.info("warning","请选择需要查询月报的科室!");
		return;
	}
	MainStore.setBaseParam("LocId",Loc);
	MainStore.setBaseParam("StartDate",stDate);
	MainStore.setBaseParam("EndDate",edDate);
	MainStore.load();
}
//删除某月报
function Delete(){
	var rowid=null;
	var selectRow=MainGrid.getSelectionModel().getSelected();
	if(selectRow){
		rowid=selectRow.get("smRowid");
	}
	if(rowid==null || rowid==""){
		Msg.info("warning","请选择要删除的月报!");
		return false;
	}
	var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
	Ext.Ajax.request({
		url:Url,
		method:'POST',
		params:{actiontype:'Delete',Rowid:rowid},
		success:function(response,request){
			var jsonData=Ext.util.JSON.decode(response.responseText);
			if(jsonData.success=='true'){
				Msg.info('success','删除成功!');
				Query();
				MainStore.load();
			}else{
				var ret=jsonData.info;
				if(ret==-1){
					Msg.info('warning','该月报不是最后一份月报，不允许删除!');
				}else if(ret==-5){
					Msg.info('error','删除月报凭证状态记录表失败!');
				}else{
					Msg.info('error','删除失败!');
				}			
			}
			
			loadMask.hide();
		}
	});
	
}
var StYear=new Ext.form.TextField({
		fieldLabel:'月份',
		id:'StYear',
		name:'StYear',
		anchor:'90%',
		width:120,
		value:today.getFullYear()
	});
	var StMonth=new Ext.form.TextField({
		fieldLabel:'',
		id:'StMonth',
		name:'StMonth',
		anchor:'90%',
		width:120,
		value:((today.getMonth()-10)<=0?1:(today.getMonth()-10))
	});
	
	var EdYear=new Ext.form.TextField({
		fieldLabel:'',
		id:'EdYear',
		name:'EdYear',
		anchor:'90%',
		width:120,
		value:today.getFullYear()
	});
	
	var EdMonth=new Ext.form.TextField({
		fieldLabel:'',
		id:'EdMonth',
		name:'EdMonth',
		anchor:'90%',
		width:120,
		value:(today.getMonth()+1)
	});
	
	var PhaLoc = new Ext.ux.form.LovCombo({
		id : 'PhaLoc',
		name : 'PhaLoc',
		fieldLabel : '科室',
		listWidth : 400,
		anchor: '90%',
		labelStyle : "text-align:right;width:100;",
		labelSeparator : '',
		separator:'^',	//科室id用^连接
		hideOnSelect : false,
		maxHeight : 300,
		editable:false,
		store : GetGroupDeptStore ,
		valueField : 'RowId',
		displayField : 'Description',
		triggerAction : 'all'
	});
	// 登录设置默认值
	SetLogInDept(PhaDeptStore, "PhaLoc");
var MainStore = new Ext.data.JsonStore({
	auroDestroy:true,
	url:Url+"actiontype=Query",
	sotreId:'MainStore',
	root:'rows',
	totalProperty:'results',
	idProperty:'smRowid',
	fields:['smRowid','locDesc','mon','frDate','frTime','toDate','toTime']
});

var mainChkCol=new Ext.grid.CheckboxSelectionModel({checkOnly:true,singleSelect:true});
var MainGrid=new Ext.grid.GridPanel({
	id:'MainGrid',
	title:'历史月报',
	store:MainStore,
	tbar:new Ext.Toolbar({items:[PhaLoc,{xtype:'tbtext',text:'月报范围:'},StYear,{xtype:'tbtext',text:'年'},
	StMonth,{xtype:'tbtext',text:'月----'},EdYear,{xtype:'tbtext',text:'年'},EdMonth,{xtype:'tbtext',text:'月'},SearchBT,'-',DeleteBT]}),
	cm:new Ext.grid.ColumnModel([{
		header:'Rowid',
		dataIndex:'smRowid',
		width:100,
		align:'left',
		hidden:true
	},{
		header:'科室',
		dataIndex:'locDesc',
		width:120,
		align:'left',
		sortable:true
	},{
		header:'月份',
		dataIndex:'mon',
		width:100,
		align:'left',
		sortable:true
	},{
		header:'月报起始日期',
		dataIndex:'frDate',
		width:150,
		align:'left',
		sortable:true,
		renderer:function(value,metaData,record,rowIndex,colIndex,store){
			var StDateTime=value+" "+record.get('frTime');
			return StDateTime;
		}
	},{
		header:'月报截止日期',
		dataIndex:'toDate',
		width:150,
		align:'left',
		sortable:true,
		renderer:function(value,metaData,record,rowIndex,colIndex,store){
			var EdDateTime=value+" "+record.get('toTime');
			return EdDateTime;
		}
	}]),
	//sm:mainChkCol,
	autoScroll:true
})

	var myPanel = new Ext.Viewport({
		renderTo:'mainPanel',
		layout : 'border',
		items : [{
			region:'center',
			layout:'fit',
			items:[DetailGrid]
		},{
			region:'south',
			height:300,
			split:true,
			layout:'fit',
			items:[MainGrid]
		} ]
	}); 
	
	//QueryRep();
	Query();
}) 