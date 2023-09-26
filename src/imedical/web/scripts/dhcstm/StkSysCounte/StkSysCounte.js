// ����:���ݺ��Զ����ɹ���
// ��д����:2012-06-6
//=========================����ȫ�ֱ���=================================
var StkSysCounteId = "";
//=========================����ȫ�ֱ���=================================
//=========================���ݺ��Զ����ɹ���===========================
var HospFlag = new Ext.grid.CheckColumn({
	header:'ҽԺ',
	dataIndex:'Hosp',
	sortable:true,
	width:80,
	renderer:function(v, p, record){
		p.css += ' x-grid3-check-col-td';
		return '<div class="x-grid3-check-col'+(((v=="Y")||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	}
});

var LocFlag = new Ext.grid.CheckColumn({
	header:'����',
	dataIndex:'Loc',
	sortable:true,
	width:80,
	renderer:function(v, p, record){
		p.css += ' x-grid3-check-col-td';
		return '<div class="x-grid3-check-col'+(((v=="Y")||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	}
});

var CatGrpFlag = new Ext.grid.CheckColumn({
	header:'����',
	dataIndex:'CatGrp',
	sortable:true,
	width:80,
	renderer:function(v, p, record){
		p.css += ' x-grid3-check-col-td';
		return '<div class="x-grid3-check-col'+(((v=="Y")||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	}
});

var YearFlag = new Ext.grid.CheckColumn({
	header:'��',
	sortable:true,
	dataIndex:'Year',
	width:80,
	renderer:function(v, p, record){
		p.css += ' x-grid3-check-col-td';
		return '<div class="x-grid3-check-col'+(((v=="Y")||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	}
});

var MonthFlag = new Ext.grid.CheckColumn({
	header:'��',
	dataIndex:'Month',
	sortable:true,
	width:80,
	renderer:function(v, p, record){
		p.css += ' x-grid3-check-col-td';
		return '<div class="x-grid3-check-col'+(((v=="Y")||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	}
});

var DayFlag = new Ext.grid.CheckColumn({
	header:'��',
	dataIndex:'Day',
	sortable:true,
	width:80,
	renderer:function(v, p, record){
		p.css += ' x-grid3-check-col-td';
		return '<div class="x-grid3-check-col'+(((v=="Y")||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	}
});


var CountByLocFlag = new Ext.grid.CheckColumn({
	header:'������',
	dataIndex:'CountByLoc',
	sortable:true,
	width:80,
	renderer:function(v, p, record){
		p.css += ' x-grid3-check-col-td';
		return '<div class="x-grid3-check-col'+(((v=="Y")||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	}
});


var StkSysCounteGrid="";
//��������Դ
var StkSysCounteGridUrl = 'dhcstm.stksyscounteaction.csp';
var StkSysCounteGridProxy= new Ext.data.HttpProxy({url:StkSysCounteGridUrl+'?actiontype=selectAll&StkType='+App_StkTypeCode,method:'GET'});
var StkSysCounteGridDs = new Ext.data.Store({
	proxy:StkSysCounteGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [
		{name:'RowId'},
		{name:'AppId'},
		{name:'AppCode'},
		{name:'AppDesc'},
		{name:'Hosp'},
		{name:'Loc'},
		{name:'CatGrp'},
		{name:'Prefix'},
		{name:'Year'},
		{name:'Month'},
		{name:'Day'},
		{name:'NoLength'},
		{name:'CountByLoc'}
		
	]),
    remoteSort:false
});

//ģ��
var StkSysCounteGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"����",
        dataIndex:'AppCode',
        width:200,
        align:'left',
        sortable:true
    },{
        header:"����",
        dataIndex:'AppDesc',
        width:200,
        align:'left',
        sortable:true
    },HospFlag,LocFlag,CatGrpFlag,{
        header:"ǰ׺",
        dataIndex:'Prefix',
        width:80,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'prefixField'
        })
    },YearFlag,MonthFlag,DayFlag,{
        header:"��ų���",
        dataIndex:'NoLength',
        width:100,
        align:'left',
        sortable:true,
		editor: new Ext.form.NumberField({
			id:'lengthField',
            allowBlank:false
        })
    },CountByLocFlag
]);

//��ʼ��Ĭ��������
StkSysCounteGridCm.defaultSortable = true;

var saveStkSysCounte = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		//rowid^Ӧ�ó���id^ҽԺ��־^���ұ�־^�����־^����ǰ׺^��^��^��^��ų���
		//RowId^AppId^AppCode^AppDesc^Hosp^Loc^CatGrp^Prefix^Year^Month^Day^NoLength
		if(StkSysCounteGrid.activeEditor != null){
			StkSysCounteGrid.activeEditor.completeEdit();
		}
		//��ȡ���е��¼�¼ 
		var mr=StkSysCounteGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){ 
			var rowId = mr[i].data["RowId"];
			var appId = mr[i].data["AppId"];
			var hosp = (mr[i].data["Hosp"]=="Y"?'Y':'N');
			var loc = (mr[i].data["Loc"]=="Y"?'Y':'N');
			var catGrp = (mr[i].data["CatGrp"]=="Y"?'Y':'N');
			var prefix = mr[i].data["Prefix"].trim();
			var year = (mr[i].data["Year"]=="Y"?'Y':'N');
			var month = (mr[i].data["Month"]=="Y"?'Y':'N');
			var day = (mr[i].data["Day"]=="Y"?'Y':'N');
			var length = mr[i].data["NoLength"];
			var CountByLoc =mr[i].data["CountByLoc"];
			
			var dataRow = rowId+"^"+appId+"^"+hosp+"^"+loc+"^"+catGrp+"^"+prefix+"^"+year+"^"+month+"^"+day+"^"+length+"^"+CountByLoc;
			if(data==""){
				data = dataRow;
			}else{
				data = data+xRowDelim()+dataRow;
			}
		}
		
		if(data==""){
			Msg.info("error","û���޸Ļ����������!");
			return false;
		}else{
			var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
			Ext.Ajax.request({
				url: StkSysCounteGridUrl+'?actiontype=save',
				params: {data:data},
				failure: function(result, request) {
					 mask.hide();
					Msg.info("error","������������!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success","����ɹ�!");
						StkSysCounteGridDs.load();
					}else{
						if(jsonData.info==-1){
							Msg.info("error","�����ظ�!");
						}else if(jsonData.info==-2){
							Msg.info("error","�����ظ�!");
						}else{
							Msg.info("error","����ʧ��!");
						}
					}
				},
				scope: this
			});
		}
    }
});

var synAppBtn = new Ext.Toolbar.Button({
	text:'ͬ��Ӧ��',
	tooltip:'ͬ��Ӧ��',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		var synRet = tkMakeServerCall("web.DHCSTM.Tools.CreateApp","App");
		Msg.info('success', 'ͬ���ɹ�!');
		StkSysCounteGridDs.reload();
	}
});

//���
StkSysCounteGrid = new Ext.grid.EditorGridPanel({
	store:StkSysCounteGridDs,
	cm:StkSysCounteGridCm,
	trackMouseOver:true,
	stripeRows:true,
	plugins:[HospFlag,LocFlag,CatGrpFlag,YearFlag,MonthFlag,DayFlag,CountByLocFlag],
	clicksToEdit:0,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	tbar:[synAppBtn, '-', saveStkSysCounte],
	clicksToEdit:1
});

StkSysCounteGridDs.load();
//=========================���ݺ��Զ����ɹ���===========================

//===========ģ����ҳ��=================================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var StkSysCountePanel = new Ext.Panel({
		title:'�������ɹ���',
		activeTab: 0,
		region:'center',
		layout:'fit',
		items:[StkSysCounteGrid]                                 
	});
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[StkSysCountePanel],
		renderTo:'mainPanel'
	});
});
//===========ģ����ҳ��=================================================