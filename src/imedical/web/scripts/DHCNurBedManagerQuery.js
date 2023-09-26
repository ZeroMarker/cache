var Hosid=session['LOGON.HOSPID'];    //��ȡĬ�ϵ�½Ժ��

var CTHosStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
var CTHosStore = new Ext.data.Store({
		proxy:CTHosStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Hoscode'
		},
		[
			{name: 'HosDesc', mapping : 'HosDesc'}
			,{name: 'HosCode', mapping: 'HosCode'}
		])
     });
var CTHos = new Ext.form.ComboBox({
		id : 'CTHos'
		,width : 80
		,store : CTHosStore
		,minChars : 1
		,displayField : 'HosDesc'
		,fieldLabel : 'Ժ��'
		,editable : true
		,triggerAction : 'all'
		,anchor : '100%'
		,valueField : 'HosCode'
		,listeners:  
               {      
                    select : function(Combox, record,index)  
                    { 					
					 //cboWardStoreProxy.load("Nur.DHCBedManager","QryCTLoc",cboWard.getRawValue(),"W","",CTHos.getValue());
		             cboWardStore.load();
					 CTLoc.load();
                    }    
               }  
});	
var CTLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
var CTLocStore = new Ext.data.Store({
		proxy: CTLocStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CTLocID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'CTLocID', mapping: 'CTLocID'}
			,{name: 'CTLocCode', mapping: 'CTLocCode'}
			,{name: 'CTLocDesc', mapping: 'CTLocDesc'}
		])
	});
var CTLoc = new Ext.form.ComboBox({
		id : 'CTLoc'
		,width : 100
		,store : CTLocStore
		,minChars : 1
		,displayField : 'CTLocDesc'
		,fieldLabel : '����'
		,editable : true
		,triggerAction : 'all'
		,anchor : '100%'
		,valueField : 'CTLocID'
});
var cboWardStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
var cboWardStore = new Ext.data.Store({
		proxy: cboWardStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CTLocID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'CTLocID', mapping: 'CTLocID'}
			,{name: 'CTLocCode', mapping: 'CTLocCode'}
			,{name: 'CTLocDesc', mapping: 'CTLocDesc'}
		])
	});
var cboWard = new Ext.form.ComboBox({
		id : 'cboWard'
		,width : 100
		,minChars : 1 
		,selectOnFocus : true //true �����ڻ�ý���ʱ���ѡ�б��������д��ڵ��ı��� ����editable = true ʱӦ��(Ĭ��Ϊfalse)�� 
		,forceSelection : true 
		,store : cboWardStore
		,displayField : 'CTLocDesc'
		,fieldLabel : '����'
		,editable : true 
		,triggerAction : 'all'  
		,anchor : '100%'
		,valueField : 'CTLocID'
	});
	
var FindAll = new Ext.form.Radio({
		 boxLabel: 'ȫ��',
		                xtype: 'radiogroup',
                        name: 'rad',
                        value: '1',
						id:'FindAll',
                        width: '100',
						anchor : '100%'
	});
var Findempty = new Ext.form.Radio({
		boxLabel: '�մ�',
		                xtype: 'radiogroup',
                        name: 'rad',
						id:'Findempty',
						checked: true,
                        value: '2',
                        width: '100',
						anchor : '100%'
	});
var Findnotempty = new Ext.form.Radio({
		boxLabel: '�ǿ�',
		                xtype: 'radiogroup',
                        name: 'rad',
						id:'Findnotempty',
                        value: '3',
                        width: '100',
						anchor : '100%'
	});
	
var SearchToday = new Ext.form.DateField(
	                   {
                    xtype: 'datefield',
                    fieldLabel: '��ǰ',
					id:'startdate',
					width:50,
					format:'Y-m-d',
					value:new Date(),
                    name: 'date',
					anchor : '100%'
                }
	);	
var SearchTom = new Ext.form.DateField(
	                   {
                    xtype: 'datefield',
                    fieldLabel: '����',
					id:'enddate',
					width:50,
					format:'Y-m-d',
					value:new Date(),
                    name: 'date',
					anchor : '100%'
                }
	);	
	//����
var Tom = new Ext.form.Checkbox(
	                    {  
                        boxLabel  : '����',  
                        name      : 'Tom',  
                        inputValue: '1',  
                        id        : 'Tom',     // checked:'true'
						width:50,
						anchor : '100%'
                        }  
	);	
//����
var Tomstom = new Ext.form.Checkbox(
	                    {  
                        boxLabel  : '����',  
                        name      : 'Tomstom',  
                        inputValue: '1',  
                        id        : 'Tomstom',
						width:50,
                        anchor : '100%'						
                        }  
	);	
//�����
var Tomstomafter = new Ext.form.Checkbox(
	                    {  
                        boxLabel  : '�����',  
                        name      : 'Tomstomafter',  
                        inputValue: '2', 
                        id        : 'Tomstomafter',
                        anchor : '100%'						
                        }  
	);
var Searchbyward = new Ext.form.Checkbox(
	                    {  
                        boxLabel  : '������',  
                        name      : 'searchtype',  
                        inputValue: '1',  
						checked   : true,
                        id        : 'Searchbyward',
						anchor : '100%'
                        }  
	);
var Searchbyloc = new Ext.form.Checkbox(
	                    {  
                        boxLabel  : '������',  
                        name      : 'searchtype',  
                        inputValue: '2',  
                        id        : 'Searchbyloc',
                        anchor : '100%'						
                        }  
	);	

var btnQuery = new Ext.Button({
		id : 'btnQuery'
		,fieldLabel : ''
		//,anchor : '55%'
		//,hideLabel:true
		//,xtype: 'tbfill' 
		//,xtype : 'tbspacer'
		,width : 60
		,iconCls : 'icon-find'
		,text : '��ѯ'
		,margins : {top:0, right:0, bottom:0, left:100}

	});
	/*
var BedAuthStatus = new Ext.form.TextField({
		id : 'BedAuthStatus' 
		,width : 20
		,anchor : '100%'
		,fieldLabel : '״̬' 
	});	
	*/
var btnUpdateWardBed = new Ext.Button({
		id : 'btnUpdateWardBed'
		,fieldLabel : ''
		//,anchor : '55%'
		//,hideLabel:true
		//,xtype: 'tbfill' 
		//,xtype : 'tbspacer'
		,width : 100
		,text : '���Ų�����λȨ��'
		,margins : {top:0, right:0, bottom:0, left:100}

	});
var btnCloseWardBed = new Ext.Button({
		id : 'btnCloseWardBed'
		,fieldLabel : ''
		//,anchor : '55%'
		//,hideLabel:true
		//,xtype: 'tbfill' 
		//,xtype : 'tbspacer'
		,width : 100
		,text : '�ջز���Ȩ��'
		,margins : {top:0, right:0, bottom:0, left:100}

	});
var btnUpdateAllBed = new Ext.Button({
		id : 'btnUpdateAllBed'
		,fieldLabel : ''
		//,anchor : '55%'
		//,hideLabel:true
		//,xtype: 'tbfill' 
		//,xtype : 'tbspacer'
		,width : 100
		,text : '��������Ȩ��'
		,margins : {top:0, right:0, bottom:0, left:100}

	});
var btnCloseAllBed = new Ext.Button({
		id : 'btnCloseAllBed'
		,fieldLabel : ''
		//,anchor : '55%'
		//,hideLabel:true
		//,xtype: 'tbfill' 
		//,xtype : 'tbspacer'
		,width : 100
		,text : '�ջ�����Ȩ��'
		,margins : {top:0, right:0, bottom:0, left:100}

	});

	
var pConditionChild1 = new Ext.Panel({
		id : 'pConditionChild1'
		,buttonAlign : 'center'  //��ӵ���ǰpanel������ buttons �Ķ��뷽ʽ��
		,columnWidth : .20 //columnWidth ��ʾʹ�ðٷֱȵ���ʽָ���п�ȣ���width ����ʹ�þ������صķ�ʽָ���п��
		,layout : 'form' //���ַ�ʽ
		,items : [
		cboWard,
		CTLoc
		]  //һ����������������ɵ����飬���뵽�������С�
	});
	
	
var pConditionChild2 = new Ext.Panel({
		id : 'pConditionChild2'
		,buttonAlign : 'center'  //��ӵ���ǰpanel������ buttons �Ķ��뷽ʽ��
		,columnWidth : .10//columnWidth ��ʾʹ�ðٷֱȵ���ʽָ���п�ȣ���width ����ʹ�þ������صķ�ʽָ���п��
		,layout : 'form' //���ַ�ʽ
		,items : [
		Searchbyward,
		Searchbyloc
		
		]  //һ����������������ɵ����飬���뵽�������С�
	});
	
var pConditionChild3 = new Ext.Panel({
		id : 'pConditionChild3'
		,buttonAlign : 'center'  //��ӵ���ǰpanel������ buttons �Ķ��뷽ʽ��
		,columnWidth : .15 //columnWidth ��ʾʹ�ðٷֱȵ���ʽָ���п�ȣ���width ����ʹ�þ������صķ�ʽָ���п��
		,layout : 'form' //���ַ�ʽ
		,items : [
		SearchToday,
		SearchTom
		
		]  //һ����������������ɵ����飬���뵽�������С�
	});
var pConditionChild4 = new Ext.Panel({
		id : 'pConditionChild4'
		,buttonAlign : 'center'  //��ӵ���ǰpanel������ buttons �Ķ��뷽ʽ��
		,columnWidth : .04 //columnWidth ��ʾʹ�ðٷֱȵ���ʽָ���п�ȣ���width ����ʹ�þ������صķ�ʽָ���п��
		,layout : 'column' //���ַ�ʽ  column
		,items : [
		FindAll,
		Findempty,
		Findnotempty
		
		]  //һ����������������ɵ����飬���뵽�������С�
	});
	
	/*pConditionChild5 = new Ext.Panel({
		id : 'pConditionChild5'
		,buttonAlign : 'center'  //��ӵ���ǰpanel������ buttons �Ķ��뷽ʽ��
		,columnWidth : .12 //columnWidth ��ʾʹ�ðٷֱȵ���ʽָ���п�ȣ���width ����ʹ�þ������صķ�ʽָ���п��
		,layout : 'form' //���ַ�ʽ
		,items : [
		SearchToday
		
		]  //һ����������������ɵ����飬���뵽�������С�
	});
	pConditionChild9 = new Ext.Panel({
		id : 'pConditionChild9'
		,buttonAlign : 'center'  //��ӵ���ǰpanel������ buttons �Ķ��뷽ʽ��
		,columnWidth : .10 //columnWidth ��ʾʹ�ðٷֱȵ���ʽָ���п�ȣ���width ����ʹ�þ������صķ�ʽָ���п��
		,layout : 'fit' //���ַ�ʽanchor
		,items : [
		SearchTom
		
		]  //һ����������������ɵ����飬���뵽�������С�
	});
	*/
var pConditionChild5 = new Ext.Panel({
		id : 'pConditionChild5'
		,buttonAlign : 'center'  //��ӵ���ǰpanel������ buttons �Ķ��뷽ʽ��
		,columnWidth : .10 //columnWidth ��ʾʹ�ðٷֱȵ���ʽָ���п�ȣ���width ����ʹ�þ������صķ�ʽָ���п��
		,layout : 'form' //���ַ�ʽfit
		,items : [
		btnQuery
		]  //һ����������������ɵ����飬���뵽�������С�
	});
	
var pConditionChild6 = new Ext.Panel({
		id : 'pConditionChild6'
		,buttonAlign : 'center'  //��ӵ���ǰpanel������ buttons �Ķ��뷽ʽ��
		,columnWidth : .1 //columnWidth ��ʾʹ�ðٷֱȵ���ʽָ���п�ȣ���width ����ʹ�þ������صķ�ʽָ���п��
		,layout : 'form' //���ַ�ʽ  anchor
		,items : [
		Tom,
		Tomstom,
		Tomstomafter
		
		]  //һ����������������ɵ����飬���뵽�������С�
	});
	
var pConditionChild7 = new Ext.Panel({
		id : 'pConditionChild7'
		,buttonAlign : 'center'  //��ӵ���ǰpanel������ buttons �Ķ��뷽ʽ��
		,columnWidth : .10 //columnWidth ��ʾʹ�ðٷֱȵ���ʽָ���п�ȣ���width ����ʹ�þ������صķ�ʽָ���п��
		,layout : 'form' //���ַ�ʽ
		,items : [
		//btnUpdateWardBed,
		btnUpdateAllBed
		
		]  //һ����������������ɵ����飬���뵽�������С�
	});
var pConditionChild8 = new Ext.Panel({
		id : 'pConditionChild8'
		,buttonAlign : 'left'  //��ӵ���ǰpanel������ buttons �Ķ��뷽ʽ��
		,columnWidth : .10 //columnWidth ��ʾʹ�ðٷֱȵ���ʽָ���п�ȣ���width ����ʹ�þ������صķ�ʽָ���п��
		,layout : 'form' //���ַ�ʽ
		,items : [
		//btnCloseWardBed ,
		btnCloseAllBed
		
		]  //һ����������������ɵ����飬���뵽�������С�
	});
	
var pConditionChild9 = new Ext.Panel({
		id : 'pConditionChild9'
		,buttonAlign : 'center'  //��ӵ���ǰpanel������ buttons �Ķ��뷽ʽ��
		,columnWidth : .20 //columnWidth ��ʾʹ�ðٷֱȵ���ʽָ���п�ȣ���width ����ʹ�þ������صķ�ʽָ���п��
		,layout : 'form' //���ַ�ʽ
		,items : [
		CTHos
		]  //һ����������������ɵ����飬���뵽�������С�
	});
	
var ConditionPanel = new Ext.form.FormPanel({
		id : 'ConditionPanel',
		buttonAlign : 'center', //��ӵ���ǰpanel������ buttons �Ķ��뷽ʽ�� 
		labelAlign : 'right', //�������п��õ��ı�����ֵ���Ϸ�ֵ�� "left", "top" �� "right" (Ĭ��Ϊ "left").
		labelWidth : 40,
		bodyBorder : 'padding:0 0 0 0',
		layout : 'column',
		region : 'north',
		frame : true,
		height : 90,
		//title : winTitle,
		items : [
			pConditionChild1
			,pConditionChild2
			,pConditionChild3
			,pConditionChild6
			,pConditionChild4
			,pConditionChild5
			,pConditionChild7
		]
		//buttons : [
			//btnQuery
			//,btnExport
		//]
	});
	
	
var gridResultStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
var gridResultStore = new Ext.data.Store({
		id: 'gridResultStoretore',
		proxy: gridResultStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'IPAppID'
		}, 
		[
		    {name: 'BedId', mapping : 'BedId'}
			,{name: 'BedCode', mapping : 'BedCode'}
			,{name: 'BedStatus', mapping: 'BedStatus'}
			,{name: 'BedBill', mapping: 'BedBill'}
			,{name: 'BedAvailTime', mapping: 'BedAvailTime'}
			
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'PatSex', mapping: 'PatSex'}
			,{name: 'PatAge', mapping: 'PatAge'}
			,{name: 'BedOwn', mapping: 'BedOwn'}
			,{name: 'RegNo', mapping: 'RegNo'}
			,{name: 'EpisodeID', mapping: 'EpisodeID'}
			,{name: 'IPDate', mapping: 'IPDate'}
			,{name: 'Patward', mapping: 'Patward'}
			,{name: 'WardID', mapping: 'WardID'}
		])
	});
var gridResultCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
var gridResult = new Ext.grid.GridPanel({
		id : 'gridResult'
		,store : gridResultStore
		,region : 'center'
		,buttonAlign : 'center'
		,loadMask : { msg : '���ڶ�ȡ����,���Ժ�...'} //һ�� Ext.LoadMask ���ã�����Ϊtrue�Ա��ڼ���ʱ����grid�� Ĭ��Ϊ false .
		//,plugins: expCtrlDetail //һ���������һ���������飬Ϊ����ṩ����Ĺ��ܡ� ��һ���Ϸ��Ĳ��Ψһ��Ҫ����������һ��init()������ �ܽ���һ��Ext.Component�͵Ĳ����������������ʱ������п��õĲ��������������ÿ�������init���������������������Ϊ�����������ݸ�����Ȼ��ÿ������Ϳ��Ե��÷���������Ӧ����ϵ��¼���������Ҫ�������ṩ�Լ��Ĺ��ܡ� 
		,columns: [
			/*new Ext.grid.RowNumberer({header:"����"	,width:60})*/
			{header: '��λid', width: 50, dataIndex: 'BedId', sortable: true}
			,{header: '��λ��', width: 100, dataIndex: 'BedCode', sortable: true}
			,{header: '��λ״̬', width: 100, dataIndex: 'BedStatus', sortable: true}
			,{header: '��λ����', width: 100, dataIndex: 'BedBill', sortable: true}
			,{header: 'Ԥ��ʱ��', width: 100, dataIndex: 'BedAvailTime', sortable: true}
			,{header: '��������', width: 100, dataIndex: 'PatName', sortable: true}
			,{header: '�Ա�', width: 100, dataIndex: 'PatSex', sortable: true}
			,{header: '����', width: 100, dataIndex: 'PatAge', sortable: true}
			,{header: '��λ����', width: 100, dataIndex: 'BedOwn', sortable: true}
			,{header: '�ǼǺ�', width: 100, dataIndex: 'RegNo', sortable: true}
			,{header: '�����', width: 100, dataIndex: 'EpisodeID', sortable: true}
			,{header: '��Ժ����', width: 100, dataIndex: 'IPDate', sortable: true}		
			,{header: '����', width: 100, dataIndex: 'Patward', sortable: true}
			,{header: '����id', width: 50, dataIndex: 'WardID', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 1000,
			store : gridResultStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: ''
		})
	});

var pnScreen = new Ext.Panel({
		id : 'pnScreen'
		,buttonAlign : 'center'
		,frame : true
		,layout : 'border'
		,items:[
		
			ConditionPanel,
			gridResult
		]
	});

CTHosStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'Nur.DHCBedManager';
			param.QueryName = 'GetHospital';
			param.Arg1 = CTHos.getRawValue();;
			param.ArgCnt = 1;
	 });
	 
CTLocStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'Nur.DHCBedManager';
			param.QueryName = 'QryCTLoc';
			param.Arg1 = CTLoc.getRawValue();
			param.Arg2 = 'E';
			param.Arg3 = "";  //cboWard.getValue();
			param.Arg4 = Hosid;  //CTHos.getValue();;
			param.ArgCnt = 4;
	 });
cboWardStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'Nur.DHCBedManager';
			param.QueryName = 'QryCTLoc';
			param.Arg1 = cboWard.getRawValue();
			param.Arg2 = 'W';
			param.Arg3 = "";
			param.Arg4 = Hosid;   //CTHos.getValue();
			param.ArgCnt = 4;
	});
 gridResultStoreProxy.on('beforeload', function(objProxy, param){
            var Arg2=cboWard.getValue();
			var Arg3 = FindAll.getValue();
			var Arg4=Findempty.getValue();
			var Arg5=Findnotempty.getValue();
			var Arg6=SearchToday.getValue();
			var Arg7=SearchTom.getValue();
			param.ClassName = 'Nur.DHCBedManager';
			param.QueryName = 'Findbed';
			param.Arg1 = "";
			param.Arg2 = Arg2;
			param.Arg3 = Arg3;
			param.Arg4 = Arg4;
			param.Arg5 = Arg5;
			param.Arg6 = Arg6;
			param.Arg7 = Arg7;
    });	
	/*
var SearchToday = Ext.getCmp("SearchToday")
	//alert(SearchToday.checked)
	var SearchTom = Ext.getCmp("SearchTom")
	SearchToday.on("check", function() {

				if (SearchToday.getValue()) {
					SearchTom.setValue("false")
				}
			});
	SearchTom.on("check", function() {

				if (SearchTom.getValue()) {
					SearchToday.setValue("false")
				}
			});
	*/		
	var Searchbyward = Ext.getCmp("Searchbyward")
	//alert(SearchToday.checked)
	var Searchbyloc = Ext.getCmp("Searchbyloc")
	Searchbyward.on("check", function() {

				if (Searchbyward.getValue()) {
					Searchbyloc.setValue("false")
				}
			});
	Searchbyloc.on("check", function() {

				if (Searchbyloc.getValue()) {
					Searchbyward.setValue("false")
				}
			});
			
			
//********************
var Tomstomafter = Ext.getCmp("Tomstomafter")
	//alert(SearchToday.checked)
	var Tomstom = Ext.getCmp("Tomstom")
	var Tom=Ext.getCmp("Tom")
	//�����
	Tomstomafter.on("check", function() {

				if (Tomstomafter.getValue()) {
					Tomstom.setValue("false")
					Tom.setValue("false")
					Ext.getCmp("enddate").setValue(new Date().add(Date.DAY, +3));
					Search_onclick();
				}
			});
//����
	Tomstom.on("check", function() {

				if (Tomstom.getValue()) {
					Tomstomafter.setValue("false")
					Tom.setValue("false")
					Ext.getCmp("enddate").setValue(new Date().add(Date.DAY, +2));
					Search_onclick();
				}
			});
//����
Tom.on("check", function() {

				if (Tom.getValue()) {
					Tomstomafter.setValue("false")
					Tomstom.setValue("false")
					Ext.getCmp("enddate").setValue(new Date().add(Date.DAY, +1));
					Search_onclick();
				}
			});
//*******************************
function Search_onclick()
{
            //alert(1)
		    var SearchByLoc=Searchbyloc.getValue();     //�����Ҳ�ѯ
			var Searchbyward = Ext.getCmp("Searchbyward");
		    var Searchbyward=Searchbyward.getValue();     //��������ѯ
			var CTLoc = Ext.getCmp("CTLoc");
		    var CTLoc=CTLoc.getValue();
			var WardID = cboWard.getValue(); 
			var FindAll = Ext.getCmp("FindAll");
			var FindAll =FindAll.getValue();   
			var Findempty = Ext.getCmp("Findempty");
			var Findempty =Findempty.getValue(); 
        	var Findnotempty = Ext.getCmp("Findnotempty");		
			var Findnotempty =Findnotempty.getValue(); 
			//alert(2)
		    var SearchToday = Ext.getCmp("enddate");
			var SearchToday =SearchToday.value;   
			var SearchTom = Ext.getCmp("enddate");	
			var SearchTom =SearchTom.value; 		
			//alert(SearchByLoc+"#"+Searchbyward+"#"+CTLoc+"#"+WardID+"#"+FindAll+"#"+Findempty+"#"+Findnotempty+"#"+SearchToday+"#"+SearchTom);
			
		Ext.Ajax.request({
			url:'DHCNurBedManagerequest.csp',
			params:{action:'GetBedList',SearchByLoc:SearchByLoc,Searchbyward:Searchbyward,CTLoc:CTLoc,WardID:WardID, FindAll:FindAll, Findempty:Findempty, Findnotempty:Findnotempty, SearchToday:SearchToday, SearchTom:SearchTom} ,
			success: function(result, request) {
				//var gridResultStore=obj.gridResultStore;
				gridResultStore.removeAll();
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.GetBedList!='') {
					var GetBedListArr=jsonData.GetBedList.split("!");
					for (var i=0;i<GetBedListArr.length;i++) {
						//{name: 'checked', mapping : 'checked'}
						var BedId = GetBedListArr[i].split("^")[0];
						var BedCode = GetBedListArr[i].split("^")[1];
						var BedStatus = GetBedListArr[i].split("^")[2];
						var BedBill = GetBedListArr[i].split("^")[3];
						var BedAvailTime = GetBedListArr[i].split("^")[14];
						var PatName = GetBedListArr[i].split("^")[4];
						var PatSex = GetBedListArr[i].split("^")[5];
						var PatAge = GetBedListArr[i].split("^")[6];
						var BedOwn = GetBedListArr[i].split("^")[9];
						var RegNo = GetBedListArr[i].split("^")[12];
						var EpisodeID = GetBedListArr[i].split("^")[10];
						var IPDate = GetBedListArr[i].split("^")[7];
						var Patward = GetBedListArr[i].split("^")[8];
						var WardID = GetBedListArr[i].split("^")[13];
						//alert(GetBedListArr[i])
						var record = new Object();
			       		record.BedId = BedId ;
			       		record.BedCode = BedCode ;
			       		record.BedStatus = BedStatus ;
			       		record.BedBill = BedBill ;
			       		record.PatName = PatName ;
			       		record.PatSex = PatSex ;
			       		record.PatAge = PatAge ;
			       		record.BedOwn = BedOwn ;
			       		record.RegNo = RegNo ;
			       		record.EpisodeID = EpisodeID ;
			       		record.IPDate = IPDate ;
						record.Patward=Patward;
						record.WardID=WardID;
						record.BedAvailTime=BedAvailTime
			       		var records = new Ext.data.Record(record);
			       		
						gridResultStore.add(records);
					}
				}
			},
			scope: this
		}) ;
}
function btnUpdateAllBed_onclick()
{
var btnUpdateAllBed=Ext.getCmp("btnUpdateAllBed");
if(btnUpdateAllBed.text=="��������Ȩ��")
{
var ret=tkMakeServerCall("Nur.DHCBedManager","UpdateAllBed");
	if(ret=="0")
	{
	alert("����Ȩ�޳ɹ�")
	btnUpdateAllBed.setText("�ջ�����Ȩ��");
	}

}
else
{
var ret=tkMakeServerCall("Nur.DHCBedManager","CloseAllBed");
	if(ret=="0")
	{
	alert("�ջ�Ȩ�޳ɹ�")
	btnUpdateAllBed.setText("��������Ȩ��");
	}
}
}
/*
Ext.onReady(function(){
new Ext.Viewport({
		id : 'viewScreen'
		,frame : true
		,layout : 'fit'
		,items:[
			pnScreen
			
		]
	}),
Ext.get('btnQuery').on("click",Search_onclick);
Ext.get('btnUpdateAllBed').on("click",btnUpdateAllBed_onclick);
var ret=tkMakeServerCall("Nur.DHCBedManager","GetBedStatus");
if (ret=="1") 
{
var btnUpdateAllBed=Ext.getCmp("btnUpdateAllBed");
btnUpdateAllBed.setText("�ջ�����Ȩ��");
}
else
{
var btnUpdateAllBed=Ext.getCmp("btnUpdateAllBed");
btnUpdateAllBed.setText("��������Ȩ��");
}
//Search_onclick();
//Ext.get('btnQuery').on("click",Search_onclick);
//Search_onclick();
}
)*/
var init=function(){

new Ext.Viewport({
		id : 'viewScreen'
		,frame : true
		,layout : 'fit'
		,items:[
			pnScreen
			
		]
	}),
Ext.get('btnQuery').on("click",Search_onclick);
Ext.get('btnUpdateAllBed').on("click",btnUpdateAllBed_onclick);
var ret=tkMakeServerCall("Nur.DHCBedManager","GetBedStatus");
if (ret=="1") 
{
var btnUpdateAllBed=Ext.getCmp("btnUpdateAllBed");
btnUpdateAllBed.setText("�ջ�����Ȩ��");
}
else
{
var btnUpdateAllBed=Ext.getCmp("btnUpdateAllBed");
btnUpdateAllBed.setText("��������Ȩ��");
}
Getmessage();  //alert(3)


}
Ext.onReady(init);
