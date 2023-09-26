
var EmpDeptUrl="dhc.bonus.hishr.empworkdayexe.csp"

var DeptDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
});

DeptDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	
		url:EmpDeptUrl+'?action=GetDept&str='+encodeURIComponent(Ext.getCmp('DeptField').getRawValue()),method:'POST'})
		});

var DeptField = new Ext.form.ComboBox({
	id: 'DeptField',
	store : DeptDs,
	displayField : 'name',
	valueField : 'code',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 200,
	listWidth : 220,
	pageSize : 10,
	minChars : 1,
	columnWidth : .1,
	selectOnFocus : true
});

var sDeptDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
});

sDeptDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	
		url:EmpDeptUrl+'?action=GetDept&str='+encodeURIComponent(Ext.getCmp('DeptComb').getRawValue()),method:'POST'})
		});

var DeptComb = new Ext.form.ComboBox({
	id: 'DeptComb',
	store : sDeptDs,
	displayField : 'name',
	valueField : 'code',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 200,
	listWidth : 220,
	pageSize : 10,
	minChars : 1,
	columnWidth : .1,
	selectOnFocus : true
});
// ��Ա���롢��Ա����
var EmpNameField = new Ext.form.TextField({
	id: 'EmpNameField',
	fieldLabel: '��Ա����',
	width:100,
	//listWidth : 245,	
	triggerAction: 'all',
	emptyText:'���������',
	name: 'EmpNameField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	columnWidth:.085,
	editable:true
});

// ����ϵ��
var BonusRateField = new Ext.form.NumberField({
	id: 'BonusRateField',
	fieldLabel: '����ϵ��',
	width:100,
	//listWidth : 245,	
	triggerAction: 'all',
	emptyText:'',
	name: 'BonusRateField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	columnWidth:.12,
	editable:true
});


/////////////////////////////////////// �ɼ���� ////////////////////////////////////////
var cycleDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'BonusYear'])
		});

cycleDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : EmpDeptUrl+'?action=yearlist&topCount=5&orderby=Desc',
						method : 'POST'
					});
		});		
var YearComb =new Ext.form.ComboBox({
			id:'YearComb',
			store : cycleDs,
			displayField : 'BonusYear',
			valueField : 'BonusYear',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '���',
			width : 100,
			listWidth : 100,
			//pageSize : 10,
			minChars : 1,
			columnWidth : .12,
			selectOnFocus : true
		});

//////////////////////////////////////// �ɼ��·� //////////////////////////////////////
var MonthComb = new Ext.form.ComboBox({	
			id:'MonthComb',											
			width:100,
			listWidth : 100,
			store : new Ext.data.ArrayStore({
					fields : ['month', 'vmonth'],
					data : [['01','1��'],['02','2��'],['03','3��'],['04','4��'],['05','5��'],['06','6��'],['07','7��'],['08','8��'],['09','9��'],['10','10��'],['11','11��'],['12','12��']]
				}),
			displayField : 'vmonth',
			valueField : 'month',
			typeAhead : true,
			mode : 'local',
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '�·�',
			minChars : 1,
			columnWidth : .1,
			selectOnFocus:'true'
});


//������������
/*var _Excel = new Herp.Excel(
    {
	 url:ServletURL,
     sql:'SELECT UnitDepts_code,UnitDepts_name,UnitDepts_remark,UnitDepts_start,UnitDepts_stop,UnitDepts_active,UnitDepts_unitDr->Units_name FROM dhc_ca_cache_data.UnitDepts WHERE UnitDepts_unitDr=? ORDER BY UnitDepts_code ',
     fileName:"߮�ɽҽԺ��Ա������Ϣ"     
    });*/

var exportButton = new Ext.Toolbar.Button({
	id:'exportButton',
    text: '���ڵ���',
    tooltip: '��������',
    iconCls: 'option',
    handler: function() { 
    
        function handler(id){
			if(id=="yes"){
		var year=YearComb.getValue();
		var month=MonthComb.getValue();	
		if((year!="") && (month!="")){
		var yearmonth = year+month;
		_Excel.download(yearmonth); 
		}else{
			Ext.Msg.show({title : 'ע��',
						  msg : '��ѡ�񵼳����ڵ����,�·�',
						  buttons : Ext.Msg.OK,
						  icon : Ext.MessageBox.WARNING
				});
			return;
		}
			}
			else{
				return;
				}
        }
        Ext.MessageBox.confirm('��ʾ','ȷʵҪ�������¼�¼��?',handler);
	}
});

var InsertTargetButton = new Ext.Toolbar.Button({
	id:'InsertTargetButton',
	text: '�������',
	tooltip: '�������',
	iconCls: 'option',
	handler: function(){
		
	    var year=YearComb.getValue();
		var month=MonthComb.getValue();
		if(year==""||month=="")
		{
			Ext.Msg.show({title : 'ע��',
					  msg : '��ѡ��ɼ��ڼ����,�·�',
					  buttons : Ext.Msg.OK,
					  icon : Ext.MessageBox.WARNING
			});
		
			return;
		}
		var mon=month-0;
		var month="M"+month;
		
		
		
		function handler(id){
			if(id=="yes")
			{
		
	    Ext.Ajax.request({
				url :EmpDeptUrl+'?action=Submmit&year='+year+'&month='+month,
				waitMsg : '�����...',
				failure : function(result, request) {
							Ext.Msg.show({
									title : '����',
									msg : '������������!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
									Ext.MessageBox.alert('��ʾ','������');
									
							} 
							else if(jsonData.success == 'Error')
							{					
								Ext.Msg.show({title : 'ע��',
					            msg : year+"��"+mon+'��'+'����δ�ɼ�,���Ȳɼ�',
					            buttons : Ext.Msg.OK,
					            icon : Ext.MessageBox.WARNING
			});
						    }
							else {
									var message = "SQLErr: "+ jsonData.info;
									Ext.Msg.show({
											title : '����',
											msg : message,
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							}
				},
				scope : this
				
		});
			}
			else
			{
			   return;	
			}
		}
	    Ext.MessageBox.confirm('��ʾ','ȷ��Ҫ��˸��¼�¼��?',handler);
	}
});

var _Excel = new Herp.Excel(
    {
	
	 url:'http://172.16.100.52:8081',
     sql:'SELECT BonusYear as ���,BonusPeriod as �·�,FlexStrField2 as ��������,FlexStrField4 as �ϴ���,DeptCode as ��������,DeptName as ��������,EmpCardID as Ա������,EmpName as Ա������,WorkDays as �ڰ�����,SharyRate as ��ϵ��,UpdateDate as �������� FROM dhc_bonus_extend_yjs.EmpWorkDay   WHERE BonusYear||right(BonusPeriod,2)=? ORDER BY DeptCode',
     fileName:"߮�ɽҽԺ��Ա������Ϣ"
    });
	
var findButton = new Ext.Toolbar.Button({
	id:'findbutton',
	text: '��ѯ',
	tooltip: '��ѯ',
	iconCls: 'option',
	handler: function(){
		var year=YearComb.getValue();
		var month=MonthComb.getValue();
		var Dept=DeptComb.getValue();
		var person=EmpNameField.getValue();
		var bonusRate=BonusRateField.getValue();
		itemGrid.load({params:{start:0,limit:25,year:year,month:month,Dept:Dept,person:person,bonusRate:bonusRate}});
	}
});

var collectButton = new Ext.Toolbar.Button({
	id:'collectButton',
	text: '���ڲɼ�',
	tooltip: '���ڲɼ�',
	iconCls: 'add',
	handler: function(){

		var year=YearComb.getValue();
		var month=MonthComb.getValue();
		//alert(year+"^"+month);
		
		if(year==""||month=="")
		{
			Ext.Msg.show({title : 'ע��',
					  msg : '��ѡ��ɼ��ڼ����,�·�',
					  buttons : Ext.Msg.OK,
					  icon : Ext.MessageBox.WARNING
			});
		
			return;
		}
		
		function handler(id){
			if(id=="yes")
			{
	    Ext.Ajax.request({
				url : EmpDeptUrl+'?action=gather&year='+year+'&month='+month,
				waitMsg : '�ɼ���...',
				failure : function(result, request) {
							Ext.Msg.show({
									title : '����',
									msg : '������������!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
									Ext.MessageBox.alert('��ʾ','���ݲɼ����');
									itemGrid.load({params:{start:0,limit:25,year:year,month:month}});
							} else {
									var message = "SQLErr: "+ jsonData.info;
									Ext.Msg.show({
											title : '����',
											msg : message,
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							}
				},
				scope : this
				
		});
			}
			else
			{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷ��Ҫ�ɼ����¼�¼��?',handler);
	    
	}
});


var queryPanel = new Ext.FormPanel({
	height : 80,
	region : 'north',
	frame : true,

	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [ {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [

		{   	xtype : 'displayfield',
					value : '�������:',
					columnWidth : .067
				}
				, YearComb
				, {
					xtype : 'displayfield',
					value : ' �����·�:',
					columnWidth : .067
				}
				, MonthComb
				, {
					xtype : 'displayfield',
					//value : '��Աѧ��:',
					columnWidth : .03
				}
				,collectButton, {
					xtype : 'displayfield',
					//value : '��Աѧ��:',
					columnWidth : .03
				},InsertTargetButton,{
					xtype : 'displayfield',
					//value : '��Աѧ��:',
					columnWidth : .03
				},exportButton]
	},
	{
		xtype: 'panel',
		columnWidth : 1,
		layout:"column",
		items: [
				{
					xtype : 'displayfield',
					value : '��������:',
					columnWidth : .056
				}
				,DeptComb
				,{
					xtype : 'displayfield',
					value : '��Ա����:',
					columnWidth : .056
				}
				, EmpNameField
				,{
					xtype : 'displayfield',
					columnWidth : .023
				},{
					xtype : 'displayfield',
					value : '��ϵ��:',
					columnWidth : .05
				},
				BonusRateField
				,{
					xtype : 'displayfield',
					columnWidth : .023
				}
				, findButton]
	}
		]
		
	});
var itemGrid = new dhc.herp.Grid({
        width: 400,
        //edit:false,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'dhc.bonus.hishr.empworkdayexe.csp',
		atLoad : true, // �Ƿ��Զ�ˢ��
		loadmask:true,
		//tbar:['���:',YearComb,'-','�·�:',MonthComb,'-',collectButton,'-',findButton],
		//tbar:[exportButton,'','-',''],
        fields: [{
	        editable:false,
            header: 'ID',
            dataIndex: 'rowid',
			sortable:true,	
			edit:false,
            hidden: true
        },{
	        editable:false,
            id:'BonusYear',
            header: '���',
			allowBlank: true,
			sortable:true,	
			width:70,
            dataIndex: 'BonusYear'
        },{
	        editable:false,
            id:'BonusPeriod',
            header: '�·�',
			allowBlank: true,
			sortable:true,	
			width:70,
            dataIndex: 'BonusPeriod'
        },{
	        editable:false,
            id:'DeptCode',
            header: '���ұ���',
			allowBlank: true,
			sortable:true,
			hidden:true,	
			width:120,
            dataIndex: 'DeptCode'	
        },{
            id:'DeptName',
            header: '��������',
			allowBlank: true,
			editable:true,
			sortable:true,	
			width:135,
            dataIndex: 'DeptName',
			type:DeptField
        },{
	        editable:false,
            id:'EmpCardID',
            header: '��Ա����',
			sortable:true,	
			allowBlank: true,
			width:100,
            dataIndex: 'EmpCardID'
        },{
	        editable:false,
            id:'EmpName',
            header: '��Ա����',
			allowBlank: true,
			sortable:true,	
			width:100,
            dataIndex: 'EmpName'
        },{
			editable:false,
            id:'WorkDays',
            header: '�ڰ�����',
			allowBlank: true,
			sortable:true,	
			width:120,
			align:'right',
            dataIndex: 'WorkDays'
        },{
	        editable:false,
            id:'SharyRate',
            header: '��ϵ��',
			allowBlank: true,
			sortable:true,	
			width:90,
			align:'right',
            dataIndex: 'SharyRate'
        },{
	        editable:false,
            id:'UpdateDate',
            header: '��������',
			allowBlank: true,
			sortable:true,	
			width:150,
			align:'right',
            dataIndex: 'UpdateDate'
        },{
		     id:'IsCheck',
		     header: '���״̬',
		     allowBlank: true,
		     align:'left',
		     width:60,
		     editable:false,
		     dataIndex: 'IsCheck'
		}] 
});

    
	itemGrid.btnAddHide() 	//�������Ӱ�ť
	//itemGrid.btnSaveHide() 	//���ر��水ť
	itemGrid.btnResetHide() 	//�������ð�ť
	itemGrid.btnDeleteHide() //����ɾ����ť
	itemGrid.btnPrintHide() 	//���ش�ӡ��ť
		