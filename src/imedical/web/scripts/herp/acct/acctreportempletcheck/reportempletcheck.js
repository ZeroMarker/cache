AcctBook=IsExistAcctBook();
var RepCheckUrl = '../csp/herp.acct.reportempletcheckexe.csp';
//���������ı���
var RepCodeFiled = new Ext.form.TextField({
            id:'RepCodeFiled',
			columnWidth : .1,
			width : 120,
			columnWidth : .12,
			selectOnFocus : true

		});
//���������ı���
var RepNameFiled = new Ext.form.TextField({
            id:'RepNameFiled',
			columnWidth : .1,
			width : 120,
			columnWidth : .12,
			selectOnFocus : true

		});

//�±���ѡ��
var MRepCheckbox = new Ext.form.Checkbox({ 
            id : 'MRepCheckbox', 
            name : "MRepCheckbox", 
            autoScroll : false, 
			//height:4,
            //width : 90, 
            anchor : "70%", 
            hideLabel : true
});

//������ѡ��
var QRepCheckbox = new Ext.form.Checkbox({ 
            id : 'QRepCheckbox', 
            name : "QRepCheckbox", 
            autoScroll : false, 
			//height:4,
            //width : 90, 
            anchor : "70%", 
            hideLabel : true
});

//���걨��ѡ��
var SRepCheckbox = new Ext.form.Checkbox({ 
            id : 'SRepCheckbox', 
            name : "SRepCheckbox", 
            autoScroll : false, 
			//height:4,
            //width : 90, 
            anchor : "70%", 
            hideLabel : true
});
		
//�걨��ѡ��
var YRepCheckbox = new Ext.form.Checkbox({ 
            id : 'YRepCheckbox', 
            name : "YRepCheckbox", 
            autoScroll : false, 
			//height:4,
            //width : 90, 
            anchor : "70%", 
            hideLabel : true
});		

//��ѯ��ť
var findButton = new Ext.Toolbar.Button({
	text: '��ѯ',
	tooltip: '��ѯ',
	iconCls: 'find',
	handler: function(){
				//alert(year);
				var repCode=RepCodeFiled.getValue();
				var repName=RepNameFiled.getValue();
				itemMain.load({params : {start:0,limit:25,ReportCode:repCode,ReportName:repName,AcctBook:AcctBook}});
	}
});

//��������
var RepTypeStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['0', '����'], ['1', '�Զ���']]
		});
var RepTypeField = new Ext.form.ComboBox({
			id : 'RepTypeField',
			fieldLabel : '��������',
			width : 70,
			listWidth : 125,
			selectOnFocus : true,
			allowBlank : false,
			store : RepTypeStore,
			anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
//��˺���
function Checkhed()	{
	var MainRowid='';
	var selectedRow = itemMain.getSelectionModel().getSelections();
	if(selectedRow.length <1){
	 Ext.Msg.show({
						title : '����',
						msg : '��ѡ��Ҫ��˵�ģ��!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
						});
		    return;
	}
	var MainRowid=selectedRow[0].data['rowid'];
	var State    = selectedRow[0].data['CheckState'];
	if(State=="���")
	{
	  Ext.Msg.show({
						title : '����',
						msg : 'ģ������ˣ������ٴ����!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
						});
		    return;
	}
	var CheckUrl =RepCheckUrl+'?action=Checkhed&rowid='+MainRowid;
	itemMain.saveurl(CheckUrl);
    return;
};	
//ȡ�����
function CancleCheck()	{
	var MainRowid='';
	var selectedRow = itemMain.getSelectionModel().getSelections();
	if(selectedRow.length <1){
	 Ext.Msg.show({
						title : '����',
						msg : '��ѡ��Ҫȡ����˵�ģ��!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
						});
		    return;
	}
	
	var MainRowid= selectedRow[0].data['rowid'];
	var State    = selectedRow[0].data['CheckState'];
	if(State=="�½�")
	{
	  Ext.Msg.show({
						title : '����',
						msg : 'ģ�������½�״̬�������ٴ�ȡ�����!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
						});
		    return;
	}
	var CancleUrl =RepCheckUrl+'?action=CancleCheck&rowid='+MainRowid;
    itemMain.saveurl(CancleUrl);
    return;
};	
//ͣ��
function Stop()	{
	var MainRowid='';
	var selectedRow = itemMain.getSelectionModel().getSelections();
	if(selectedRow.length <1){
	 Ext.Msg.show({
						title : '����',
						msg : '��ѡ��Ҫͣ�õ�ģ��!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
						});
		    return;
	}
	var MainRowid=selectedRow[0].data['rowid'];
	var State    = selectedRow[0].data['IsStop'];
	if(State=="��"){
	  Ext.Msg.show({
						title : '����',
						msg : 'ģ���Ѿ�ͣ��!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
						});
		    return;
	}
	Ext.MessageBox.prompt("��ʾ","������дͣ��ԭ��",function(id,text){
	    if(id=="ok"){
		 	var StopUrl =RepCheckUrl+'?action=Stop&rowid='+MainRowid+'&StopDesc='+encodeURI(text);
	        itemMain.saveurl(StopUrl);
	     }
	},this,true);
	
    return;
};	
//����
function Start(){
var MainRowid='';
	var selectedRow = itemMain.getSelectionModel().getSelections();
	if(selectedRow.length <1){
	 Ext.Msg.show({
						title : '����',
						msg : '��ѡ��Ҫȡ����˵�ģ��!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
						});
		    return;
	}
	
	var MainRowid= selectedRow[0].data['rowid'];
	var State    = selectedRow[0].data['IsStop'];
	if(State=="��")
	{
	  Ext.Msg.show({
						title : '����',
						msg : 'ģ����������״̬�������ٴ�����!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
						});
		    return;
	}
	var CancleUrl =RepCheckUrl+'?action=Start&rowid='+MainRowid;
    itemMain.saveurl(CancleUrl);
    return;

}

var queryPanel = new Ext.FormPanel({
	     title: '����ģ�����',
	     iconCls:'audit',
		region: 'north',
		height: 75,
		frame: true,
		defaults: {
			bodyStyle: 'padding:5px '
		},
		items: [{
				xtype: 'panel',
				layout: 'column',
				hideLabel: true,
				width: 1200,
				items: [{
						xtype: 'displayfield',
						value: '��������',
						style: 'padding : 0 5px;'
						//width: 60
					}, RepCodeFiled,  {
						xtype: 'displayfield',
						value: '',
						width: 40
					}, {
						xtype: 'displayfield',
						value: '��������',
						style: 'padding : 0 5px;'
						//width: 60
					}, RepNameFiled, {
						xtype: 'displayfield',
						value: '',
						width: 40
					}, 
					findButton
				]
			}
		]

	});

var itemMain = new dhc.herp.Grid({
   // title: '����ģ�����',
    region : 'center',
    atLoad : false, // �Ƿ��Զ�ˢ��
    url: 'herp.acct.reportempletcheckexe.csp',
   // viewConfig : {forceFit : true},
	//tbar : ['�������룺', RepCodeFiled,'-', '�������ƣ�', RepNameFiled, '-', findButton],
    fields: [
                    {
						header : 'ID',
						dataIndex : 'rowid',
						hidden : true
					},{
						header : '������ť',
						width:200,
						hidden : false,
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store)
						{ 
							return '<span style="color:blue;cursor:hand"><BLINK id="submit"     onclick=Checkhed();>      ���  </BLINK></span>'+'<b> </b>'
							   	  +'<span style="color:blue;cursor:hand"><BLINK id="revocation" onclick=CancleCheck();>  ȡ�����  </BLINK></span>'+'<b> </b>'
								  +'<span style="color:blue;cursor:hand"><BLINK id="delete"     onclick=Start()>       ����  </BLINK></span>'+'<b> </b>' 
							   	  +'<span style="color:blue;cursor:hand"><BLINK id="delete"     onclick=Stop()>       ͣ��  </BLINK></span>'+'<b> </b>' 
					
						}
					}, {
						id : 'ReportCode',
						header : '��������',
						dataIndex : 'ReportCode',
						width : 80,
						editable:false,
						hidden : false

					}, {
						id : 'ReportName',
						header : '��������',
						width : 140,
						editable:false,
						allowBlank : false,
						dataIndex : 'ReportName'

					}, {
						id : 'ReportType',
						header : '��������',
						width : 90,
						align : 'center',
						editable:false,
						type:RepTypeField,
						//allowBlank : false,
						dataIndex : 'ReportType'

					},{
						id : 'MonthReport',
						header : '�±�',
						editable:false,
						align : 'center',
						type:MRepCheckbox,
						renderer: function (v) { return '<input type="checkbox"'+(v=="1"?" checked":"")+'/>'; },//����ֵ����checkbox�Ƿ�ѡ
						width : 60,
						dataIndex : 'MonthReport'

					}, {
						id : 'QuartReport',
						header : '����',
						editable:false,
						align : 'center',
						width : 60,
						type:QRepCheckbox,
						renderer: function (v) { return '<input type="checkbox"'+(v=="1"?" checked":"")+'/>'; },//����ֵ����checkbox�Ƿ�ѡ
						dataIndex : 'QuartReport'

					}, {
					    id:'SemyearReport',
						header : '���걨',
						width : 60,
						editable : false,
						align : 'center',
						type:SRepCheckbox,
						renderer: function (v) { return '<input type="checkbox"'+(v=="1"?" checked":"")+'/>'; },//����ֵ����checkbox�Ƿ�ѡ
						dataIndex : 'SemyearReport'

					},{
						id : 'YearReport',
						header : ' �걨',
						width : 60,
						editable:false,
						align : 'center',
						type : YRepCheckbox,
						renderer: function (v) { return '<input type="checkbox"'+(v=="1"?" checked":"")+'/>'; },//����ֵ����checkbox�Ƿ�ѡ
						hidden:false,
						dataIndex : 'YearReport'

					}, {
						id : 'LenWayArray',
						header : '��������',
						width : 80,
						editable : false,
						align : 'center',
						dataIndex : 'LenWayArray'
						
					},{
					    id:'ReportExplain',
						header : '����˵���ļ�',
						editable : false,
						width : 120,
						align : 'center',
						renderer : function(v, p, r) {
								return '<span style="color:blue;cursor:hand"><u>�鿴</u></span>';								
						},
						dataIndex : 'ReportExplain'
					},{
						id : 'IsStop',
						header : '�Ƿ�ͣ��',
						width : 80,
						align : 'center',
						editable:false,
						dataIndex : 'IsStop'

					},{
						id : 'CheckState',
						header : '���״̬',
						width : 80,
						align : 'center',
						editable:false,
						//hidden:true,
						dataIndex : 'CheckState'

					},{
						id : 'StartDate',
						header : '��������',
						width : 80,
						editable:false,
						//hidden:true,
						dataIndex : 'StartDate'

					},{
						id : 'Checkers',
						header : '�����',
						width : 100,
						align : 'center',
						editable:false,
						//hidden:true,
						dataIndex : 'Checkers'

					},{
						id : 'CheckDate',
						header : '���ʱ��',
						width : 100,
						align : 'center',
						editable:false,
						dataIndex : 'CheckDate'

					},{
					//����ʱ���Ƿ����׵�ǰʱ��
						id : 'IsEarly',
						header : '',
						width : 50,
						editable:false,
						hidden:true,
						dataIndex : 'IsEarly'
                       
					}],
	
	split : true,
	//collapsible : true,
	containerScroll : true,
	xtype : 'grid',
	trackMouseOver : true,
	stripeRows : true,
	sm : new Ext.grid.RowSelectionModel({
				singleSelect : true
			}),
	loadMask : true,	
	height:230,
	trackMouseOver: true,
	stripeRows: true

});

itemMain.on('cellclick', function(g, rowIndex, columnIndex, e) {
	// alert(columnIndex)
	// ǰ�÷�������
	if (columnIndex == 11) {
		var filename="";
		var server="";
		var path="";
		var records = itemMain.getSelectionModel().getSelections();
	    var repCode=records[0].get("ReportCode");
		var RepName=records[0].get("ReportName");
		 //alert(repCode);
		Ext.Ajax.request({
        url:'../csp/herp.acct.financialreportcheckexe.csp?action=GetFileName&AcctBook='+ AcctBook+'&RepCode='+repCode,
        method: 'GET',
        success: function(result, request) {
        var jsonData = Ext.util.JSON.decode( result.responseText );
		var result=jsonData.info;
        if (jsonData.success=='true'){
			filename=result.split("*")[0];
			server=result.split("*")[1];
			path=result.split("*")[2];
			if(filename==""){
				  Ext.Msg.show({
						title : '��ʾ',
						msg : 'δ�ϴ��ļ�! ',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
						});
		    return;
				
			}else{
			//alert(server+path);
		  
	      //window.open("ftp://192.168.102.144:21/acct/reportFile/"+filename); 
		   window.open("ftp://"+server+"/"+path+"/"+filename); 
		   }
                  }
             }
	});
	
	}
});


itemMain.btnPrintHide(); 	//���ش�ӡ��ť
itemMain.btnResetHide(); 	//�������ð�ť
itemMain.btnAddHide() 	    //�������Ӱ�ť
itemMain.btnSaveHide() 	    //���ر��水ť
itemMain.btnDeleteHide()    //����ɾ����ť
itemMain.load(({params:{start:0,limit:25,AcctBook:AcctBook}}));

itemMain.on('rowclick',function(grid,rowIndex,e){	
	var MainRowid='';
	var selectedRow = itemMain.getSelectionModel().getSelections();
	MainRowid=selectedRow[0].data['rowid'];
	var limits=Ext.getCmp("PageSizePluginhss").getValue();
			 //alert(limits);
	         if(!limits){limits=25};
	itemDetail.load({params:{start:0, limit:limits,MainRowid:MainRowid}});	
});