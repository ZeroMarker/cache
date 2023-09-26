// /����: �����±�
// /����: �����±�
// /��д�ߣ�zhangdongmei
// /��д����: 2012.11.15

Ext.onReady(function() {
	var gUserId = session['LOGON.USERID'];	
	var gLocId=session['LOGON.CTLOCID'];
	//alert(gIngrRowid);
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var Url=DictUrl+ 'stkmonaction.csp?';
	var today=new Date();
	Ext.Ajax.timeout = 900000;
		//wyx add�������� 2014-03-06
	if(gParam.length<1){
		GetParam();  //��ʼ����������
		
	}
	// ɾ����ť
	var DeleteBT = new Ext.Toolbar.Button({
				id : "DeleteBT",
				text : 'ɾ��',
				tooltip : '���ɾ��',
				width : 70,
				height : 30,
				iconCls : 'page_delete',
				handler : function() {  
					Delete();
				}
			});
			
		// ��ѯ��ť
	var SearchBT = new Ext.Toolbar.Button({
				id : "SearchBT",
				text : '��ѯ',
				tooltip : '�����ѯ',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {  
					QueryRep();
				}
			});
			
	// ȷ����ť
	var OkBT = new Ext.Toolbar.Button({
				id : "OkBT",
				text : '�����±�',
				tooltip : '��������±�',
				width : 70,
				height : 30,
				iconCls : 'page_gear',
				handler : function() {  
					CreateReport();
				}
			});
	
	/**
	 * �����±�
	 */
	function CreateReport() {
		if(DetailGrid.activeEditor != null){
			DetailGrid.activeEditor.completeEdit();
		} 
		var selections=DetailGrid.getSelectionModel().getSelections();
		var CreateUser = gUserId;
		var ReCreate=false;     //�Ƿ����������±�
		
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
				Msg.info("warning",LocDesc+"�����·ݲ���Ϊ��!");
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
				Msg.info("warning",LocDesc+"��ֹʱ��Ҫ���ڿ�ʼʱ��!");
				return;
			}
			if(EndDateChk>today.format('Y-m-d')){
				Msg.info("error",LocDesc+"���ڽ�ֹ���ڲ��ܳ�������!");
				return;
			}else if(EndDateChk==today.format('Y-m-d')){
				if(EndTime>today.format('H:i:s')){
					Msg.info("error",LocDesc+"���ڽ�ֹʱ�䲻��Ϊ���ڵ�ǰʱ��!");
					return;
				}
			}
			var Params=Loc+"^"+CurMonth+"^"+CreateUser+"^"+StartDate+"^"+EndDate+"^"+StartTime+"^"+EndTime;
			var ExistFlag=CheckIfExist(Loc,CurMonth);
		    
			if(ExistFlag==true){
				Msg.info("warning",LocDesc+'�����±��Ѿ����ɣ������������ɵĻ�����ɾ����������!');
				return;
			}
			var CompleteStr=CheckIfCompleted(Loc,StartDate,EndDate);
			if((CompleteStr!="")&(gParam[0]=='Y')){
				Msg.info("warning",'"��δ��ɵ�ҵ�񵥣����������±���'+CompleteStr);
				return;
			}
			if(listParams==""){
				listParams=Params;
			}else{
				listParams=listParams+RowDelim+Params;
			}			
		}
		if(listParams==""){
			Msg.info("warning","��ѡ����Ҫ�����±��Ŀ���!");
			return;
		}
		var loadMask=ShowLoadMask(Ext.getBody(),"������...");
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
					// ˢ�½���
					Msg.info("success", "�����±��ɹ�!");
					Query();  //�±������ɺ�ִ�в�ѯ
					//QueryRep();
				} else {
					var ret=jsonData.info;					
					Msg.info("error", "�����±�ʧ�ܣ�"+ret);		
				}			
			}
		})
	
	}

	//���ĳ����ĳ�·��±��Ƿ��Ѿ�����
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
 //���ĳ����ĳ�·��±��Ƿ���δ��ɵĵ��� //add wyx 2014-03-06 
function CheckIfCompleted(LocId,StartDate,EndDate){
	var flag=false;
	var NewUrl=Url+"actiontype=CheckIfCompleted&LocId="+LocId+"&StartDate="+StartDate+"&EndDate="+EndDate;
	var responseText=ExecuteDBSynAccess(NewUrl);
	var jsonData=Ext.util.JSON.decode(responseText);
	return jsonData.info;
	}

//��ѯ
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
			header : '����',
			dataIndex : 'LocDesc',
			width : 180,
			align : 'left',
			sortable : true
		}, {
			header : '�����·�',
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
			header : '������ʼ����',
			dataIndex : 'StartDate',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "������ʼʱ��",
			dataIndex : 'StartTime',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "���ڽ�ֹ����",
			dataIndex : 'EndDate',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "���ڽ�ֹʱ��",
			dataIndex : 'EndTime',
			width : 100,
			align : 'center',
			sortable : true
		},{
			header:'�����·�',
			dataIndex:'CurMonth',
			width:100,
			align:'center',
			sortable:false,
			renderer:function(value, metaData, record, rowIndex, colIndex, store){
				return '<span style="color:green;">' + value + '</span>';
			},
			editor:new Ext.form.TextField({
				regex:/(^\d{4})-((0?[1-9]|1[0-2])$)/,
                regexText: "��������ȷ�ı����·ݣ�����2018-05",
			})
		},{
			header:'���ڿ�ʼ����',
			dataIndex:'CurStartDate',
			width:100,
			sortable:false,
			renderer:Ext.util.Format.dateRenderer(App_StkDateFormat),
			editor:new Ext.ux.DateField({
				allowBlank:false,
				format:App_StkDateFormat
			})
		},{
			header:'���ڿ�ʼʱ��',
			dataIndex:'CurStartTime',
			width:100,
			sortable:false,
			editor:new Ext.form.TextField({
				regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
				regexText:'ʱ���ʽ������ȷ��ʽhh:mm:ss',
				width : 120
			})
		},{
			header:'���ڽ�ֹ����',
			dataIndex:'CurEndDate',
			width:100,
			sortable:false,
			renderer:Ext.util.Format.dateRenderer(App_StkDateFormat),
			editor:new Ext.ux.DateField({
				allowBlank:false,
				format:App_StkDateFormat
			})
		},{
			header:'���ڽ�ֹʱ��',
			dataIndex:'CurEndTime',
			width:100,
			sortable:false,
			editor:new Ext.form.TextField({
				regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
				regexText:'ʱ���ʽ������ȷ��ʽhh:mm:ss',
				width : 120
			})
		}]);
//�������ڽ�ֹ���ں�ʱ����㱾�ڿ�ʼ����
function curstartdate(value,rec){
	var curStartDate=today.add(Date.DAY,-30);
	if(rec!=null){
		if(rec.lastToDate!=null & rec.lastToDate!="" & rec.lastToTime!=null & rec.lastToTime!=""){
			//���ڽ�ֹ����ʱ��ת����Date���ͺ��1��
			curStartDate=toDate(rec.lastToDate+" "+rec.lastToTime).add(Date.SECOND,1);
		}
	}
	return curStartDate;
}

function curstarttime(value,rec){
	var curStartTime="";
	if(rec!=null){
		if(rec.lastToDate!=null & rec.lastToDate!="" & rec.lastToTime!=null & rec.lastToTime!=""){
			//���ڽ�ֹ����ʱ��ת����Date���ͺ��1��
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
			title : '�±�����',
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
			e.cancel=true;      //���������±��Ļ������ڿ�ʼ���ںͱ��ڿ�ʼʱ�䲻���޸�
		}
	}
});
DetailGrid.addListener('afteredit',function(e){
	this.getSelectionModel().selectRow(e.row,true);
});
	//Ext.getCmp('PhaLoc').select(gLocId);
	//SetStkMonStDate();
 //��ʷ�±�
//��ѯ�±�
function QueryRep(){
	var stYear=Ext.getCmp('StYear').getValue();
	var stMonth=Ext.getCmp('StMonth').getValue();
	var stDate=stYear+'-'+stMonth+'-'+'01';
	var edYear=Ext.getCmp('EdYear').getValue();
	var edMonth=Ext.getCmp('EdMonth').getValue();
	var edDate=edYear+'-'+edMonth+'-'+'01';
	var Loc=Ext.getCmp('PhaLoc').getValue();
	if(Loc==""){
		Msg.info("warning","��ѡ����Ҫ��ѯ�±��Ŀ���!");
		return;
	}
	MainStore.setBaseParam("LocId",Loc);
	MainStore.setBaseParam("StartDate",stDate);
	MainStore.setBaseParam("EndDate",edDate);
	MainStore.load();
}
//ɾ��ĳ�±�
function Delete(){
	var rowid=null;
	var selectRow=MainGrid.getSelectionModel().getSelected();
	if(selectRow){
		rowid=selectRow.get("smRowid");
	}
	if(rowid==null || rowid==""){
		Msg.info("warning","��ѡ��Ҫɾ�����±�!");
		return false;
	}
	var loadMask=ShowLoadMask(Ext.getBody(),"������...");
	Ext.Ajax.request({
		url:Url,
		method:'POST',
		params:{actiontype:'Delete',Rowid:rowid},
		success:function(response,request){
			var jsonData=Ext.util.JSON.decode(response.responseText);
			if(jsonData.success=='true'){
				Msg.info('success','ɾ���ɹ�!');
				Query();
				MainStore.load();
			}else{
				var ret=jsonData.info;
				if(ret==-1){
					Msg.info('warning','���±��������һ���±���������ɾ��!');
				}else if(ret==-5){
					Msg.info('error','ɾ���±�ƾ֤״̬��¼��ʧ��!');
				}else{
					Msg.info('error','ɾ��ʧ��!');
				}			
			}
			
			loadMask.hide();
		}
	});
	
}
var StYear=new Ext.form.TextField({
		fieldLabel:'�·�',
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
		fieldLabel : '����',
		listWidth : 400,
		anchor: '90%',
		labelStyle : "text-align:right;width:100;",
		labelSeparator : '',
		separator:'^',	//����id��^����
		hideOnSelect : false,
		maxHeight : 300,
		editable:false,
		store : GetGroupDeptStore ,
		valueField : 'RowId',
		displayField : 'Description',
		triggerAction : 'all'
	});
	// ��¼����Ĭ��ֵ
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
	title:'��ʷ�±�',
	store:MainStore,
	tbar:new Ext.Toolbar({items:[PhaLoc,{xtype:'tbtext',text:'�±���Χ:'},StYear,{xtype:'tbtext',text:'��'},
	StMonth,{xtype:'tbtext',text:'��----'},EdYear,{xtype:'tbtext',text:'��'},EdMonth,{xtype:'tbtext',text:'��'},SearchBT,'-',DeleteBT]}),
	cm:new Ext.grid.ColumnModel([{
		header:'Rowid',
		dataIndex:'smRowid',
		width:100,
		align:'left',
		hidden:true
	},{
		header:'����',
		dataIndex:'locDesc',
		width:120,
		align:'left',
		sortable:true
	},{
		header:'�·�',
		dataIndex:'mon',
		width:100,
		align:'left',
		sortable:true
	},{
		header:'�±���ʼ����',
		dataIndex:'frDate',
		width:150,
		align:'left',
		sortable:true,
		renderer:function(value,metaData,record,rowIndex,colIndex,store){
			var StDateTime=value+" "+record.get('frTime');
			return StDateTime;
		}
	},{
		header:'�±���ֹ����',
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